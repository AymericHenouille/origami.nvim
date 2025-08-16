---@class BlockNodeOption
---@field public fold FoldFn|nil The fold function.
---@field public unfold UnFoldFn|nil The unfold function.

local M = {}

---@type FoldFn
local function default_fold(node)
  return {}
end

---@type UnFoldFn
local function default_unfold(node)
  return {}
end

---Create a full block node option from a partial one.
---@param options BlockNodeOption The partial block node option.
---@return BlockNodeOption options The full block node option.
function M.create_block_node_option(options)
  return vim.tbl_deep_extend("force", {
    fold = default_fold,
    unfold = default_unfold,
  }, options)
end


---@class BlockNodeOptionModule provide somes function for manipulate block node option
---@field is_block_node fun(node: TSNode): boolean
---@field get_block_node_option fun(node: TSNode): BlockNodeOption

---Setup function that find a node block.
---@param opts Options The origami options.
---@return fun(node: TSNode): TSNode|nil, BlockNodeOption find_block_node return a node block and a node block option.
function M.setup_find_block_node(opts)
  ---Get the node language
  ---@return string|nil
  local function get_node_lang()
    local ok, result = pcall(require, "nvim-treesitter.parsers")
    if not ok then return nil end
    return result.get_buf_lang(0)
  end

  ---Check if the given block node is a block node
  ---@param lang string The node lang.
  ---@param node TSNode? The target node.
  ---@return boolean is_block_node True if the node is a node block.
  local function is_block_node(lang, node)
    if not lang then return false end
    if not node then return false end
    local node_type = node:type()
    local node_types = opts.block_nodes[lang]
    for key, _ in pairs(node_types) do
      if key == node_type then
        return true
      end
    end
    return false
  end

  ---Get block node option from a node.
  ---@param lang string The node lang.
  ---@param node TSNode The target node.
  ---@return BlockNodeOption|nil option The block node option.
  local function get_block_node_option(lang, node)
    local node_type = node:type()
    if not lang then return nil end
    return opts.block_nodes[lang][node_type] --[[@as BlockNodeOption]] or nil
  end

  return function(node)
    local default_node_option = M.create_block_node_option({})
    local lang = get_node_lang()
    if not lang then return nil, default_node_option end
    while not is_block_node(lang, node) and node ~= nil do
      node = node:parent()
    end
    if not node then return nil, default_node_option end
    return node, get_block_node_option(lang, node) or default_node_option
  end
end

return M
