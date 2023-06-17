return {
    { 'junegunn/fzf',     build = ':call fzf#install()' },
    { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
    'moll/vim-bbye',
    'stevearc/oil.nvim',
    'BartSte/hop.nvim',
}
