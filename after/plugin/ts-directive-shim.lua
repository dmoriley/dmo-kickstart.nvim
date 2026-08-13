-- Compat shim: Neovim 0.12 removed the `all = false` option from
-- vim.treesitter.query.add_directive/add_predicate, so handlers now always receive
-- `match[capture_id]` as a TSNode[] list. nvim-treesitter's frozen `master` branch still
-- registers its handlers with `{ force = true, all = false }` and dereferences a single node,
-- which crashes in vim.treesitter.get_range().
--
-- Re-register the affected handlers with list-aware versions. Delete this file once
-- nvim-treesitter is migrated to the `main` branch.
if vim.fn.has('nvim-0.12') == 0 then
  return
end

local query = require('vim.treesitter.query')

---Unwrap a 0.12 quantified capture (TSNode[]) back to a single TSNode.
local function first(v)
  return type(v) == 'table' and v[1] or v
end

local force = { force = true }

local injection_language_aliases = {
  ex = 'elixir',
  pl = 'perl',
  sh = 'bash',
  uxn = 'uxntal',
  ts = 'typescript',
}

local html_script_type_languages = {
  ['importmap'] = 'json',
  ['module'] = 'javascript',
  ['application/ecmascript'] = 'javascript',
  ['text/ecmascript'] = 'javascript',
}

-- queries/markdown/injections.scm, queries/hurl/injections.scm
query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
  local node = first(match[pred[2]])
  if not node then
    return
  end
  local alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias })
    or injection_language_aliases[alias]
    or alias
end, force)

-- queries/html_tags/injections.scm
query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
  local node = first(match[pred[2]])
  if not node then
    return
  end
  local mimetype = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[mimetype]
  if configured then
    metadata['injection.language'] = configured
  else
    local parts = vim.split(mimetype, '/', {})
    metadata['injection.language'] = parts[#parts]
  end
end, force)

-- queries/{bash,hcl,php_only,ruby}/injections.scm
query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = first(match[id])
  if not node then
    return
  end
  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = text:lower()
end, force)

-- master's `nth?`, `is?` and `kind-eq?` predicates have the same latent bug. No query shipped by
-- nvim-treesitter, -textobjects, -context or nvim-ufo uses them, so they are shimmed only to keep
-- custom queries from hitting the same crash.
query.add_predicate('kind-eq?', function(match, _, _, pred)
  local node = first(match[pred[2]])
  if not node then
    return true
  end
  return vim.tbl_contains({ unpack(pred, 3) }, node:type())
end, force)

query.add_predicate('nth?', function(match, _, _, pred)
  local node = first(match[pred[2]])
  local n = tonumber(pred[3])
  local parent = node and node:parent()
  if parent and n and parent:named_child_count() > n then
    return parent:named_child(n) == node
  end
  return false
end, force)

query.add_predicate('is?', function(match, _, bufnr, pred)
  local node = first(match[pred[2]])
  if not node then
    return true
  end
  local locals = require('nvim-treesitter.locals')
  local _, _, kind = locals.find_definition(node, bufnr)
  return vim.tbl_contains({ unpack(pred, 3) }, kind)
end, force)
