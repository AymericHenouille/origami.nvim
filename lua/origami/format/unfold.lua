local M = {}

---Setup the unfold function
---@param opts Options The origami options.
---@return fun(node: TSNode) unfold Unfold function that fold a node.
function M.setup(opts)
  local node_module = require("origami.format.node")
  local find_block_node = require("origami.options.block_node_option").setup_find_block_node(opts)
  return node_module.apply_node_transformation(find_block_node, function(node, node_options)
    return node_options.unfold(node)
  end)
end

return M
