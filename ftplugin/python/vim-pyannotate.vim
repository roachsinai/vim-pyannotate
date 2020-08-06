if exists("loaded_annotate")
  finish
endif

function! s:AnnotatePyFile()
if getbufinfo(bufnr())[0].changed
    echo "Save buffer first."
    return
endif

let s:annotate_dir = asyncrun#get_root('%') . "/.pyannotate"
call delete(s:annotate_dir, 'rf')
call mkdir(s:annotate_dir, "", 0700)
let s:info_file = s:annotate_dir . '/type_info.json'
let s:py_file_no_ext = expand('%:t:r')
let s:pyannotate_binary = 'pyannotate'

python3 << EOF
import sys
import vim
from pyannotate_runtime import collect_types
module_to_annotate = vim.eval('s:py_file_no_ext')
start_point = vim.eval("expand('<cword>')")
exec('from ' + module_to_annotate  + ' import ' + start_point)

parameters = str(vim.eval('input("Input parameters of <cword> function: ")'))

def run():
    exec(start_point + '(' + parameters + ')')

if __name__ == '__main__':
    collect_types.init_types_collection()
    with collect_types.collect():
        run()
    collect_types.dump_stats(vim.eval('s:info_file'))
EOF

let s:output = system(s:pyannotate_binary . ' --type-info=' . s:info_file . ' -w ' . expand('%'))
echo s:output
exec ":edit"
endfunction

command AnnotatePyFile call s:AnnotatePyFile()
let loaded_annotate = 1
