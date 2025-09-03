local node_module = require("origami.format.node")

local M = {}

---Join a string array into a online string.
---@param lines string[] The string array to join
---@return string The joined string array.
local function join(lines)
  local joined = table.concat(lines, "\n")
  return vim.trim(joined)
end

---@alias JoinFn fun(left_part: string, right_part: string): string Should return the two string concatenated.

---Create a join function that join the two part with the given char between them.
---@param char string The char added between the two part.
---@return JoinFn join_fn The created join function.
function M.join_with_char(char)
  return function(left_part, right_part)
    return left_part .. char .. right_part
  end
end

---Create a format function that join the two part with a space.
---@return JoinFn join_fn The created join function.
function M.join_with_space()
  return M.join_with_char(" ")
end

---Create a format function that join the two part with a "\n".
---@return JoinFn join_fn The created join function.
function M.join_with_back_space()
  return M.join_with_char("\n")
end

---Create a format function that join the two part with a ", ".
---@return JoinFn join_fn The created join function.
function M.join_with_comma()
  return M.join_with_char(", ")
end

---Create a format function that join the two part with a " ; ".
---@return JoinFn join_fn The created join function.
function M.join_with_semi()
  return M.join_with_char(" ; ")
end

---Create a format function that join the two part with a "".
---@return JoinFn join_fn The created join function.
function M.join_with_empty()
  return M.join_with_char("")
end

---Create a format function that skip the second part.
---@return JoinFn join_fn The created join function.
function M.skip_join()
  return function(left_part, _)
    return left_part
  end
end

---Get the join function associated with the given node type in parameter.
---@param node_type string The node type.
---@param body JoinFn|table<string, JoinFn> Join function used to join the body parts.
---@return JoinFn join_fn The join function.
local function get_join_function_from_body_parameter(node_type, body)
  if type(body) == "table" then
    local join_body_fn = body[node_type] or body[1]
    return join_body_fn or M.join_with_empty()
  end
  return body --[[@as JoinFn]]
end

---Fold a node content arround a target node type.
---@param node TSNode The node to fold.
---@param node_type string The block node type.
---@param head_join_fn JoinFn Join function used to join the header to the first body item.
---@param body JoinFn|table<string, JoinFn> Join function used to join the body parts.
---@param footer_join_fn JoinFn Join function used to join the last body part to the footer.
---@return string[] lines The folded node lines.
function M.join_around_node_type(node, node_type, head_join_fn, body, footer_join_fn)
  local header, _, footer, body_node = node_module.get_node_content_around_body(node, node_type)
  local result = join(header)
  local is_first = true
  for child in body_node:iter_children() do
    local child_content = node_module.get_node_content(child)
    local joined_child_content = join(child_content)
    if is_first then
      result = head_join_fn(result, joined_child_content)
      is_first = false
    else
      local body_join_fn = get_join_function_from_body_parameter(child:type(), body)
      result = body_join_fn(result, joined_child_content)
    end
  end
  result = footer_join_fn(result, join(footer))
  return vim.split(result, "\n")
end

return M
