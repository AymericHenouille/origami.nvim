local M = { }

---Setup the origami plugin with the given options
---@param opts Options The options used to setup origami.nvim
function M.setup(opts)
  local options = require("origami.options")
  local default_options = require("origami.default")
  M.opts = options.parse(vim.tbl_deep_extend("force", default_options, opts or {}))
  require("origami.commands").setup(M.opts)
end

return M
