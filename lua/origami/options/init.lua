---@alias FoldFn fun(node: TSNode): string[] Fold function used to concat multiple lines in one.
---@alias UnFoldFn fun(node: TSNode): string[] Unfold function used to transform a line to multiples.

---@class Options Options used for setup origami.nvim
---@field public block_nodes table<string, table<string, string|BlockNodeOption>> Table that contain as entry a target language and as value the list of node type that can be considered as a block type.

local M = {}

---Parse an origami option object to a full Options
---@param opts Options The input.
---@return Options the parsed options.
function M.parse(opts)
  local block_node_option_module = require("origami.options.block_node_option")
  local block_nodes = opts.block_nodes
  for language, tables in pairs(block_nodes) do
    for key, value in pairs(tables) do
      local node_type = type(key) == "number" and value --[[@as string]] or key
      local block_node_option = type(key) == "string" and value --[[@as BlockNodeOption]] or {}
      block_nodes[language][node_type] = block_node_option_module.create_block_node_option(block_node_option)
    end
  end
  return { block_nodes = block_nodes }
end

return M
