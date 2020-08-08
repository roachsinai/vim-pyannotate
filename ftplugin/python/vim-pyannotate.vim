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
call delete(l:annotate_dir, 'rf')
call mkdir(l:annotate_dir, "", 0700)

let l:py_file_no_ext = expand('%:t:r')
let l:start_point = expand('<cword>')
let l:parameters = input("Input parameters of <cword> function: ")
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
let l:prefix = get(g:, 'project_virtual_env', '')

call system(l:prefix . '/bin/python -B ' . l:annotate_dir . '/driver.py')

let l:pyannotate_binary = get(g:, 'pyannotate_use_env', v:false)? l:prefix . '/bin/pyannotate' : 'pyannotate'
let l:output = system(l:pyannotate_binary . ' --py3 --type-info=' . l:info_file . ' -w ' . expand('%'))
echo l:output
exec ":edit"
endfunction

command AnnotatePyFile call s:AnnotatePyFile()
let loaded_annotate = 1
