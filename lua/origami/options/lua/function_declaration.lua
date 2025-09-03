local node_module = require("origami.format.node")

---@type BlockNodeOption
local M = {}

function M.fold(node)
  local header, _, footer, body_node = node_module.get_node_content_around_body(node, "block")
  local result = vim.trim(table.concat(header, "\n"))
  for child in body_node:iter_children() do
    local child_content = node_module.get_node_content(child)
    result = result .. " " .. table.concat(child_content, "\n")
  end
  result = result .. " " .. vim.trim(table.concat(footer, "\n"))
  return vim.split(result, "\n")
end

function M.unfold(node)
  local header, _, footer, body_node = node_module.get_node_content_around_body(node, "block")
  local result = vim.trim(table.concat(header, "\n"))
  for child in body_node:iter_children() do
    local child_content = node_module.get_node_content(child)
    result = result .. "\n" .. table.concat(child_content, "\n")
  end
  result = result .. "\n" .. vim.trim(table.concat(footer, "\n"))
  return vim.split(result, "\n")
end

return M


