---@type BlockNodeOption
local M = {}

function M.fold(node)
  local lines = {}
  for child in node:iter_children() do
    local child_type = child:type()
    if child_type == "arguments" then
      for argument in child:iter_children() do
        local argument_type = argument:type()
        print("argument: " .. argument_type)
      end
    else
      print(child_type)
    end
  end
  return lines
end

function M.unfold(node)

  local function test(a, b, c, d)

  end

  test(
    "1", --comment first message
    test(1, 2, 3, 4),
    --[[comment]]{
      test = ""
    },
    function()

    end,
  )
  return {}
end

return M
