local M = {}

---Setup the OrigamiUnfold command.
---@param opts Options The option used to setup origami.nvim
function M.setup(opts)
  local lines_module = require("origami.functions.lines")
  vim.api.nvim_create_user_command("OrigamiUnfold", lines_module.apply_node_option_on_lines_under_cursor(opts, function(lines, node_options)
    local unfold_fn = node_options.unfold or function(_) return { "" } end
    return unfold_fn(lines)
  end), {})
end

return M
