local M = {}

---Setup the OrigamiUnfold command.
---@param format_module FormatModule The format module.
function M.setup(format_module)
  vim.api.nvim_create_user_command("OrigamiUnfold", function()
    local node = format_module.get_node_at_cursor()
    if not node then return end
    format_module.unfold(node)
  end, { desc = "Unfold the node under the cursor position" })
end

return M
