return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = 'float',
      shell = "C:\\Users\\AJ.Veendijk\\.cargo\\bin\\nu.exe",
      open_mapping =
      [[<c-\>]]
    })
  end
}
