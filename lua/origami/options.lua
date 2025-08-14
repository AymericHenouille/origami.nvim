---@alias FoldFn fun(lines: string[]): string[] Fold function used to concat multiple lines in one.
---@alias UnFoldFn fun(line: string[]): string[] Unfold function used to transform a line to multiples.

---@class BlockNodeOption
---@field public fold FoldFn|nil The fold function.
---@field public unfold UnFoldFn|nil The unfold function.

---@class Options Options used for setup origami.nvim
---@field public block_nodes table<string, table<string, string|BlockNodeOption>> Table that contain as entry a target language and as value the list of node type that can be considered as a block type.

local M = {}

---Create a block node option from an other block node option.
---If the input block node option have nil field, this function will insert default values for them.
---@param block_node_option BlockNodeOption The input block node option.
---@return BlockNodeOption block_node_option The complete block  node option.
local function create_block_node_option(block_node_option)
  local fold_module = require("origami.functions.fold")
  return vim.tbl_deep_extend("force", {
    fold = fold_module.fold,
    unfold = fold_module.unfold,
  }, block_node_option)
end

---Parse an origami option object to a full Options
---@param opts Options The input.
---@return Options the parsed options.
function M.parse(opts)
  local block_nodes = opts.block_nodes
  for language, tables in pairs(block_nodes) do
    for key, value in pairs(tables) do
      local node_type = type(key) == "number" and value --[[@as string]] or key
      local block_node_option = type(key) == "string" and value --[[@as BlockNodeOption]] or {}
      block_nodes[language][node_type] = create_block_node_option(block_node_option)
    end
  end
  return { block_nodes = block_nodes }
end

return M
