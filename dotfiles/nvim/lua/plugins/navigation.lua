return {
    { 'junegunn/fzf',     build = ':call fzf#install()' },
    { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
    'junegunn/vim-peekaboo',
    'moll/vim-bbye',
    'stevearc/oil.nvim',
    'BartSte/hop.nvim',
}
