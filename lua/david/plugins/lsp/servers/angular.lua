local lspconfig = require('lspconfig')

return {
  -- root_markers = { 'angular.json' },
  -- root_dir = lspconfig.util.root_pattern('angular.json'),
}

-- figure this out later
-- setup = {
--   angularls = function()
--     LazyVim.lsp.on_attach(function(client)
--       --HACK: disable angular renaming capability due to duplicate rename popping up
--       client.server_capabilities.renameProvider = false
--     end, "angularls")
--   end,
-- },
