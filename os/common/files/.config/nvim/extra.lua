-- Telescope
local builtin = require('telescope.builtin')
local find_hidden_files = function()
	builtin.find_files {
		find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
	}
end
vim.keymap.set('n', '<leader>ff', find_hidden_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
