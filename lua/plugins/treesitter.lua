return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
	highlight = {
	    enable = true,
	},
	indent = { enable = true },
	autotag = { enable = true },
	ensure_installed = {
	    "lua",
	    "java",
	    "cpp",
	    "c",
	},
	auto_install = false,
    }
}
