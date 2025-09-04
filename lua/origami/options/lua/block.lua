local around_node_type_module = require("origami.format.around_node_type")
local join_with_space_fn = around_node_type_module.join_with_space()
local join_with_semi_fn = around_node_type_module.join_with_semi()
local join_with_back_space_fn = around_node_type_module.join_with_back_space()
local skip_join_fn = around_node_type_module.skip_join()

---@type BlockNodeOption
local M = {}

function M.fold(node)
  return around_node_type_module.join_around_node_type(
    node,
    "block",
    join_with_space_fn,
    join_with_semi_fn,
    join_with_space_fn
  )
end

function M.unfold(node)
  return around_node_type_module.join_around_node_type(
    node,
    "block",
    join_with_back_space_fn,
    {
      join_with_back_space_fn,
      ["empty_statement"] = skip_join_fn,
    },
    join_with_back_space_fn
  )
end

return M


