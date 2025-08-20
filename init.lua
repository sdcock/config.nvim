vim.cmd "language en_US"
vim.o.shell = 'powershell'
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autochdir = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.fileformat = 'dos'
vim.o.number = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.undofile = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.winborder = 'rounded'
vim.o.updatetime = 250

vim.keymap.set({ "n", "v" }, "-", "<CMD>Oil --float<CR>")
vim.keymap.set("t", "", "")
vim.keymap.set({ "n", "v" }, "<leader>h", "<CMD>Gitsigns preview_hunk<CR>")
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')
vim.keymap.set({ 'n', "v" }, '<C-d>', '<C-d>zz')
vim.keymap.set({ 'n', "v" }, '<C-u>', '<C-u>zz')
vim.keymap.set({ 'n', "v" }, 'n', 'nzzzv')
vim.keymap.set({ 'n', "v" }, 'N', 'Nzzzv')
vim.keymap.set({ 'n', "v" }, '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ 'n', "v" }, '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "vue_ls",
    "gopls",
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
        if client and client:supports_method("textDocument/formatting") then
            local augroup = vim.api.nvim_create_augroup("format-on-save", { clear = true })
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = ev.buf })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ async = false, id = ev.data.client_id })
                end,
            })
        end
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, ev.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-cursor-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = ev.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = ev.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-cursor-highlight', buffer = event2.buf }
                end,
            })
        end
    end,
})
vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/NMAC427/guess-indent.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("oil").setup({
    columns = { "icon", "size", "mtime", "permissions" },
    delete_to_trash = true,
    view_options = {
        show_hidden = true,
        case_insensitive = true,
    }
})
require("mini.pick").setup()
vim.keymap.set({ "n", "v" }, "<leader>sf", "<CMD>Pick files<CR>")
vim.keymap.set({ "n", "v" }, "<leader>sh", "<CMD>Pick help<CR>")
vim.keymap.set({ "n", "v" }, "<leader>sb", "<CMD>Pick buffers<CR>")
vim.keymap.set({ "n", "v" }, "<leader>sr", "<CMD>Pick grep_live<CR>")
vim.keymap.set({ "n", "v" }, "<leader>sn", function()
    MiniPick.builtin.files(nil, {
        source = {
            name = "Neovim files",
            cwd = vim.fn.stdpath('config')
        }
    })
end)
vim.keymap.set({ "n", "v" }, "<leader>so", function()
    local files = {}
    for _, file in ipairs(vim.v.oldfiles) do
        if vim.fn.filereadable(file) == 1 then
            table.insert(files, file)
        end
    end

    MiniPick.start({
        source = {
            name = "Recent files",
            items = files,
        },
        action = function(item)
            vim.cmd.edit(item)
        end,
    })
end)
vim.keymap.set({ "n", "v" }, "<leader>sg", function()
    local res = vim.api.nvim_exec2("Git rev-parse --show-toplevel", { output = true })
    print(res.output)
    if vim.startswith(res.output, "fatal") then return end

    MiniPick.builtin.files(nil, {
        source = {
            name = "Search files from git root",
            cwd = res.output,
        }
    })
end)
require("mason").setup()
require("nvim-autopairs").setup()
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c_sharp" },
    highlight = { enable = true }
})
require("vague").setup({
    italic = false,
})
vim.cmd "colorscheme vague"
require("gitsigns").setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
})
