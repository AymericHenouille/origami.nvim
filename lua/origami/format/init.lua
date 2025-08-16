---@class FormatModule module that provide an access to fold and unfold module.
---@field fold fun(node: TSNode) fold function that fold a node.
---@field unfold fun(node: TSNode) unfold function that unfold a node.
---@field get_node_at_cursor fun(): TSNode|nil Get the node at the cursor position.

local M = {}

---Get the current node at the cursor position.
---@return TSNode|nil node The current node or nil.
function M.get_node_at_cursor()
  local ok, result = pcall(require, "nvim-treesitter.ts_utils")
  if not ok then return nil end
  return result.get_node_at_cursor()
end

---Setup the format module with the origami options.
---@param opts Options The origami options.
---@return FormatModule format_module The format module
function M.setup(opts)
  local fold_module = require("origami.format.fold")
  local unfold_nodule = require("origami.format.unfold")
  return vim.tbl_extend("force", M, {
    fold = fold_module.setup(opts),
    unfold = unfold_nodule.setup(opts)
  })
end

return M
