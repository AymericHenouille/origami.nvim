local M = {}

---Get node content in a string array.
---@param node TSNode The node to extract content.
---@return string[] lines The node content.
function M.get_node_content(node)
  local start_row, start_column, end_row, end_column = node:range()
  return vim.api.nvim_buf_get_text(0, start_row, start_column, end_row, end_column, {})
end

---Get the node content split in tree section. header, body, and footer.
---The function take a node and a target node child type in parameter.
---if the function find a child in the node with the given type, it will return all content before the body as the header, the content as the body and the end of the content as the footer.
---@param node TSNode The node to split.
---@param body string The target body type.
---@return string[] header, string[] body, string[] footer, TSNode body_node The header the body and the footer lines
function M.get_node_content_around_body(node, body)
  local start_row, start_column, end_row, end_column = node:range()
  for child in node:iter_children() do
    local child_type = child:type()
    if child_type == body then
      local child_start_row, child_start_column, child_end_row, child_end_column = child:range()
      local header_content = vim.api.nvim_buf_get_text(0, start_row, start_column, child_start_row, child_start_column, {})
      local body_content = vim.api.nvim_buf_get_text(0, child_start_row, child_start_column, child_end_row, child_end_column, {})
      local footer_content = vim.api.nvim_buf_get_text(0, child_end_row, child_end_column, end_row, end_column, {})
      return header_content, body_content, footer_content, child
    end
  end
  return {}, {}, {}, node
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
