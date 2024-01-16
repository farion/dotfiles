return {
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "aklt/plantuml-syntax",
  },
  {
    "tyru/open-browser.vim",
  },
  {
    "weirongxu/plantuml-previewer.vim",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
