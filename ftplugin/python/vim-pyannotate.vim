if exists("loaded_annotate")
    finish
endif

function! s:AnnotatePyFile()
if getbufinfo(bufnr())[0].changed
    echo "Save buffer first."
    return
endif

let l:annotate_dir = asyncrun#get_root('%') . "/.pyannotate"
let l:info_file = l:annotate_dir . '/type_info.json'
call mkdir(l:annotate_dir, "p", 0700)

let l:py_file_no_ext = expand('%:t:r')
let l:current_line = getline(".")
let l:start_point = s:GetStartPoint(l:current_line)
if l:start_point == l:current_line
    echo "Please move cursor to the beginning line of a function!"
    return
endif

let l:python_binary_prefix = s:GetPythonBinaryPrefix()
let l:parameters = input("Input only parameters of function " . l:start_point . ": ")
redraw

call writefile([
            \ 'from pyannotate_runtime import collect_types',
            \ 'from ' . l:py_file_no_ext . ' import ' . l:start_point,
            \ '',
            \ 'collect_types.init_types_collection()',
            \ 'with collect_types.collect():',
            \ '    ' . l:start_point . '(' . l:parameters . ')',
            \ 'collect_types.dump_stats("' . l:info_file . '")'
            \], l:annotate_dir . '/driver.py')

call system(l:python_binary_prefix . ' -B ' . l:annotate_dir . '/driver.py')

let l:pyannotate_binary = get(g:, 'pyannotate_use_env', v:false)? l:python_binary_prefix . '/bin/pyannotate' : 'pyannotate'
let l:output = system(l:pyannotate_binary . ' --py3 --type-info=' . l:info_file . ' -w ' . expand('%'))
echo l:output
exec ":edit"
endfunction

function! s:GetStartPoint(text)
    return substitute(a:text, '^def \(.\{-}\)(.*$', '\1', '')
endfunction

function! s:GetPythonBinaryPrefix()
let l:prefix = get(g:, 'project_virtual_env', '')
if type(l:prefix) == 3
    let l:count = len(l:prefix)
    if l:count == 1
        let l:choice = 0
    elseif l:count > 1
        let l:choice = inputlist([ 'Select python binary of your project:' ]
                              \ + map(copy(l:prefix), '(v:key+1) . ". " . v:val . "/bin/python"')) - 1
        redraw
        if l:choice < 0 || l:choice >= l:count
            let l:choice = 0
        endif
    endif
    let l:prefix = l:prefix[l:choice]
endif
return l:prefix
endfunction

command AnnotatePyFile call s:AnnotatePyFile()
let loaded_annotate = 1
