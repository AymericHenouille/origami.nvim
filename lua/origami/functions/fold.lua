local M = {}

---@type FoldFn
function M.fold(lines)
  local text = table.concat(lines, " ")
    :gsub("%s+", " ")
  return { text }
end

---@type UnFoldFn
function M.unfold(line)
  return { line }
end

return M
