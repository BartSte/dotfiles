require('jump').setup({
  labels = 'tnseriaogmplfuwyqbjdhvkzxc',
  -- The highlight group to use for match highlights.
  search = 'Search',
  -- The highlight group to use for labels.
  label = 'FlashLabel',
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', require('jump').start, {})
