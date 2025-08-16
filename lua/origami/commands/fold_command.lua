local M = {}

---Setup the OrigamiFold command.
---@param format_module FormatModule The format module.
function M.setup(format_module)
  vim.api.nvim_create_user_command("OrigamiFold", function()
    local node = format_module.get_node_at_cursor()
    if not node then return end
    format_module.fold(node)
  end, { desc = "Fold the node under the cursor position" })
end

return M
