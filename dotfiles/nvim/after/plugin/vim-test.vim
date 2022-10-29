function! MyUnitTestStrategy(cmd)
    let testName = split(a:cmd)[-1]
    call vimspector#LaunchWithSettings( #{ configuration: 'unittest', TestName: testName } )
endfunction

let test#python#runner = 'pyunit'
let g:test#custom_strategies = {'unittest': function('MyUnitTestStrategy')}
