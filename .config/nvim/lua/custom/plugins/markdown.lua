return {

  {
    "iamcco/markdown-preview.nvim",
    priority = 1000,
    config = function()
       vim.fn["mkdp#util#install"]()
    end,
  },

}


