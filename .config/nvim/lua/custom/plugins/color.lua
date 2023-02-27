return {

  {
    "luisiacc/the-matrix.nvim",
    priority = 1001,
    config = function()
      vim.cmd.colorscheme 'thematrix'
    end,
  },
  {
    "atelierbram/Base4Tone-nvim",
    priority = 1002,
    config = function ()
      vim.cmd.colorscheme 'base4tone_classic_i_dark'
    end
  }
}


