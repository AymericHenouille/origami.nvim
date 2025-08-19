local M = {}

---Get node content in a string array.
---@param node TSNode The node to extract content.
---@return string[] lines The node content.
function M.get_node_content(node)
  local start_row, start_column, end_row, end_column = node:range()
  return vim.api.nvim_buf_get_text(0, start_row, start_column, end_row, end_column, {})
end

---Create a function that take a node in parameter and apply a transformation on it.
---@param find_block_node_fn fun(node: TSNode):TSNode|nil, BlockNodeOption Get the closest block node from the target node.
---@param transform_node_to_text_fn fun(node: TSNode, block_node_option: BlockNodeOption): string[] Parse a node into text.
---@return fun(node: TSNode) transform_node_fn Transform the target node text into something else.
function M.apply_node_transformation(find_block_node_fn, transform_node_to_text_fn)
  return function(node)
    local pos = vim.api.nvim_win_get_cursor(0)
    local block_node, block_node_option = find_block_node_fn(node)
    if not block_node then return end
    local lines = transform_node_to_text_fn(
      block_node,
      block_node_option
    )

    local start_row, start_column, end_row, end_column = block_node:range()
    vim.api.nvim_buf_set_text(0, start_row, start_column, end_row, end_column, lines)
    vim.api.nvim_buf_call(0, function()
      local format_end = start_row + #lines
      vim.cmd(string.format("%d,%dnormal! ==", start_row, format_end))
      vim.api.nvim_win_set_cursor(0, pos)
    end)
  end
end

return M
