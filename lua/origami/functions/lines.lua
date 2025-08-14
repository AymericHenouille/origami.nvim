local M = {}

---Get the current node at the cursor position.
---@return TSNode|nil node The current node or nil.
local function get_node_at_cursor()
  local ok, result = pcall(require, "nvim-treesitter.ts_utils")
  if not ok then return nil end
  return result.get_node_at_cursor()
end

---Get the language of a given node.
---@return string|nil language The node language
local function get_language()
  local ok, result = pcall(require, "nvim-treesitter.parsers")
  if not ok then return nil end
  return result.get_buf_lang(0)
end

---Check if the given node is a block.
---Take a node type in parameter and a list of node types considered as block node.
---@param node_type string The node type.
---@param node_block_types table<string, BlockNodeOption|string> The block node types
---@return boolean result True if the given node is a block node.
local function is_block_node(node_type, node_block_types)
  for key, _ in pairs(node_block_types) do
    if key == node_type then
      return true
    end
  end
  return false
end

---Auto indent the given lines given in parameters.
---To auto indent the function will the vim indent engine.
---@param lines string[] The line to indent.
---@return string[] lines The auto indented lines.
local function auto_indent_lines(lines)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.bo[buffer].filetype = vim.bo.filetype
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.api.nvim_buf_call(buffer, function()
    vim.cmd("normal! gg=G")
  end)
  local buffer_lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  vim.api.nvim_buf_delete(buffer, { force = true })
  local new_lines = {}
  local indent_cols = vim.fn.indent(vim.fn.line('.'))
  local base_indent = string.rep(" ", indent_cols)
  for index, line in ipairs(buffer_lines) do
    if index > 1 then
      line = base_indent .. line
    end
    table.insert(new_lines, line)
  end
  return new_lines
end

---This function will extract the target lines contain by the block where the cursor is, and the target BlockNodeOption
---You can apply this parameters to the apply_node_options function that return the lines to substitute.
---Then this function will update the current buffer.
---@param opts Options The options for origami.nvim
---@param apply_node_options fun(lines: string[], node_options: BlockNodeOption): string[] The function used to update the target lines.
---@return fun() update_lines_under_cursor A function that udpate the line under the cursor.
function M.apply_node_option_on_lines_under_cursor(opts, apply_node_options)
  return function()
    local node = get_node_at_cursor()
    if not node then print("No node found") return end

    local language = get_language() or "default"
    local node_blocks = opts.block_nodes[language]

    while node and not is_block_node(node:type(), node_blocks) do
      node = node:parent()
    end

    if not node then print("No block found") return end

    local start_row, start_col, end_row, end_col = node:range()
    local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    local node_options = opts.block_nodes[language][node:type()] --[[@as BlockNodeOption]]
    if not node_options then print("No block node option found") return end
    local updated_lines = apply_node_options(lines, node_options)
    local indented_lines = auto_indent_lines(updated_lines)

    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, indented_lines)
  end
end

return M
