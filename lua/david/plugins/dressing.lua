return {
    "stevearc/dressing.nvim",
    event = "BufReadPre",
    config = function()
        require("dressing").setup({
            select = {
                telescope = require('telescope.themes').get_dropdown({
                    layout_config = {
                        height = 30
                    }
                })
            }
        })
    end
}
