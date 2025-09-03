local node_module = require("origami.format.node")

---@type BlockNodeOption
local M = {}

---Format a node content
---@param type string The node type.
---@param content string The node content
---@return string format The formated content
local function format(type, content)
  if type == "," then
    return content .. " "
  elseif type == "comment" then
    if content:match("^%-%-%[%[") then return content .. " " end
    return (content:gsub("%-%-%s*(.*)%s*", "--[[ %1 ]] "))
  end
  return content
end

function M.fold(node)
  local text = ""
  for child in node:iter_children() do
    local child_type = child:type()
    if child_type == "arguments" then
      for argument in child:iter_children() do
        local argument_type = argument:type()
        local node_content = node_module.get_node_content(argument)
        text = text .. format(argument_type, table.concat(node_content, "\n"))
      end
    else
      local node_content = node_module.get_node_content(child)
      text = text .. table.concat(node_content, "\n")
    end
  end
  return vim.split(text, "\n")
end

function M.unfold(node)
  local text = ""
  for child in node:iter_children() do
    local child_type = child:type()
    if child_type == "identifier" or child_type == "dot_index_expression" then
      local node_content = node_module.get_node_content(child)
      text = text .. table.concat(node_content, "\n")
    elseif child_type == "arguments" then
      for argument in child:iter_children() do
        local argument_type = argument:type()
        local node_content = table.concat(node_module.get_node_content(argument), "\n")
        if argument_type == "," or argument_type == "(" then
          text = text .. node_content .. "\n"
        elseif argument_type == ")" then
          text = text .. "\n" .. node_content
        else
          text = text .. node_content
        end
      end
    end
  end
  return vim.split(text, "\n")
end

return M
