" usage:
" (the same as ack, except that the path is required)
" examples: 
" :Ack TODO .
" :Ack sub Util.pm


function! Ack(args)
    let grepprg_bak=&grepprg
    set grepprg=ack\ -H\ --nocolor\ --nogroup\ --type=nohtml\ --ignore-dir=features\ --ignore-dir=doc\ --ignore-dir=spec\ --ignore-dir=tmp\ --ignore-dir=coverage\ --ignore-dir=vendor\ --ignore-dir=public\ --ignore-dir=script
    execute "silent! grep " . a:args
    botright copen
    let &grepprg=grepprg_bak
endfunction

command! -nargs=* -complete=file Ack call Ack(<q-args>)
