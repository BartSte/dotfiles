function FoldText()
    let line = getline(v:foldstart)
    let number_of_lines = v:foldend - v:foldstart
    let fill_count = winwidth('%') - len(line) - len(number_of_lines) - 14
    return line . ' ' . repeat('.', fill_count) . ' (' . number_of_lines . ' L)'
endfunction
set foldtext=FoldText()
set fillchars=fold:\ "
