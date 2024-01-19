-- plugins that don't need configs
return {
    {
        'tpope/vim-fugitive',
        cmd = { 'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit' }
    },
    {
        'tpope/vim-rhubarb',
        event = 'BufReadPre'
    },
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
        event = 'BufReadPre'
    },
    {
        "kylechui/nvim-surround",
        event = "InsertEnter",
        opts = {}
    },
    {
        -- "gc" to comment visual regions/lines
        'numToStr/Comment.nvim',
        event = "BufReadPre",
        opts = {}
    },
    {
        "folke/persistence.nvim",
        event = 'BufReadPre',
        opts = {}
    },
}
