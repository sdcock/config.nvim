-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Open oil.nvim
vim.keymap.set('n', '-', '<CMD>Oil --float<CR>')

-- Gitsigns preview
vim.keymap.set('n', '<leader>h', '<CMD>Gitsigns preview_hunk_inline<CR>')

-- Always navigate one visual line up and down, even if text is wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')

-- Center cursor in normal and visual mode
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('v', '<C-d>', '<C-d>zz')
vim.keymap.set('v', '<C-u>', '<C-u>zz')
vim.keymap.set('v', 'n', 'nzzzv')
vim.keymap.set('v', 'N', 'Nzzzv')

-- Cycle colorschemes
local function next_colorscheme()
  local available = vim.fn.getcompletion('', 'color')
  local cs_idx = vim.fn.indexof(available, 'v:val == "' .. vim.g.colors_name .. '"') + 1
  local new_cs = available[cs_idx % #available + 1]
  vim.cmd.colorscheme(new_cs)
  print('Current colorscheme: ' .. new_cs)
end

local function prev_colorscheme()
  local available = vim.fn.getcompletion('', 'color')
  local cs_idx = vim.fn.indexof(available, 'v:val == "' .. vim.g.colors_name .. '"') + 1
  local new_cs = available[cs_idx % #available + 1]
  vim.cmd.colorscheme(new_cs)
  print('Current colorscheme: ' .. new_cs)
end

vim.keymap.set('n', '<C-c><C-n>', next_colorscheme, { desc = 'Cycle to next colorscheme' })
vim.keymap.set('n', '<C-c><C-p>', prev_colorscheme, { desc = 'Cycle to previous colorscheme' })
