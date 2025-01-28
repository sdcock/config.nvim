return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					-- theme = "gruvbox",
					theme = "palenight",
				},
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
