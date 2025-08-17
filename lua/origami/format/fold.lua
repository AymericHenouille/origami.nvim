local M = {}

---Setup the fold function
---@param opts Options The origami options.
---@return fun(node: TSNode) fold Fold function that fold a node.
function M.setup(opts)
  local find_block_node = require("origami.options.block_node_option").setup_find_block_node(opts)
  return function(node)
    local block_node, block_node_option = find_block_node(node)
    if not block_node then return end
    local lines = block_node_option.fold(block_node)
    for _, line in ipairs(lines) do
      print(line)
    end
  end
end

return M
