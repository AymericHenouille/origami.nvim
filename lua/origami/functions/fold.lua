local lines_modules = require("origami.functions.lines")

local M = {}

---@type FoldFn
function M.fold(node)
  local lines = lines_modules.get_node_lines(node)
  local text = table.concat(lines, " ")
  text = text:gsub("%s+", " ")
  return { text }
end

---@type UnFoldFn 
function M.unfold(node)
  local lines = {}
  for child in node:iter_children() do
    local child_lines = lines_modules.get_node_lines(child)
    if lines_modules.is_multiline(child) then
      vim.list_extend(lines, child_lines)
    else
      table.insert(lines, child_lines[1])
    end
  end

  for _, l in ipairs(lines) do
    print(l)
  end

  return lines
end


return M
