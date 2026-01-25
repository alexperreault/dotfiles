return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true, -- This is the magic line
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
