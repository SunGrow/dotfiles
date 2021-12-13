-- vim.api.nvim_set_keymap(mode, keys, mapping, options)
-- Functions for keybindings
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- Window Navigation
nmap("<leader>w","<C-W>")
-- File Navigation
nmap("<leader>e",":Ex<CR>")
-- Tab navigation
nmap("<leader>te", "<CMD>:tabe<CR>")
nmap("<leader>tf", "<CMD>:tabf %<CR>")
nmap("<leader>tn", "<CMD>:tabn<CR>")
nmap("<leader>tp", "<CMD>:tabp<CR>")
nmap("<leader>tc", "<CMD>:tabc<CR>")
nmap("<leader>to", "<CMD>:tabo<CR>")
nmap("<leader>tt", "<CMD>:tabe +term<CR>")
-- Buffer Control
nmap("<A-,>", "<CMD>:BufferLineCyclePrev<CR>")
nmap("<A-.>", "<CMD>:BufferLineCycleNext<CR>")
nmap("<A-<>", "<CMD>:BufferLineMovePrev<CR>")
nmap("<A->>", "<CMD>:BufferLineMoveNext<CR>")
nmap("<leader>be", "<CMD>:BufferLineSortByExtension<CR>")
nmap("<leader>bd", "<CMD>:BufferLineSortByDirectory<CR>")
nmap("<A-<num>>", "<cmd>:lua require('bufferline').go_to_buffer(num)<CR>")
nmap("<A-c>", "<CMD>:bd<CR>")
nmap("<C-s>", "<CMD>:BufferLinePick<CR>")

-- Clear highlighting on escape in normal mode
nmap("<esc><esc>", ":noh<CR>")

-- Latex
nmap("<leader>c", "<CMD>:VimtexCompile<CR>")
nmap("<leader>p", "<CMD>:VimtexView<CR>")

-- LSP
