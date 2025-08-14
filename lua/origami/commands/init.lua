local M = {}

---Setup the Origami commands.
---@param opts Options The option used to setup origami.nvim
function M.setup(opts)
  require("origami.commands.fold_command").setup(opts)
  require("origami.commands.unfold_command").setup(opts)
end

return M
