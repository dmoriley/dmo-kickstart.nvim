return {
    "mbbill/undotree",
    keys = {
        { "<leader>u", ":UndotreeToggle<cr>", mode = "n", desc = "Undotree toggle", noremap = true, silent = true }
    },
    config = function()
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_WindowLayout = 2
    end
}
