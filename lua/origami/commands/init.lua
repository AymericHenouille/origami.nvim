local M = {}

---Setup the Origami commands.
---@param opts Options The option used to setup origami.nvim
function M.setup(opts)
  local format_module = require("origami.format").setup(opts)
  require("origami.commands.fold_command").setup(format_module)
  require("origami.commands.unfold_command").setup(format_module)
end

return M
