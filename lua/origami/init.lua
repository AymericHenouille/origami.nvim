local M = { }

---Setup the origami plugin with the given options
---@param opts Options The options used to setup origami.nvim
function M.setup(opts)
  local options_module = require("origami.options")
  local default_options = require("origami.options.default")
  M.opts = options_module.parse(vim.tbl_deep_extend("force", default_options, opts or {}))
  require("origami.commands").setup(M.opts)
end

return M
