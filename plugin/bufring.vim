" ============================================================================
" File:        plugin/bufring.vim
" Version:     0.0
" Modified:    2010-09-08
" Description: Allows to switch back to buffers in the order they were viewed.
" Maintainer:  Israel Chauca F. <israelchauca@gmail.com>
" Use:         <count><leader>br
"              :<count>Bufring
"              :Bufring <count>
"              :<count>Br
"              :Br<count>

if exists("g:loaded_bufring") || &cp
  " User doesn't want this plugin or compatible is set, let's get out!
  finish
endif
let g:loaded_bufring = 1

if !exists('s:bufring')
  let s:bufring = [1]
endif

"function! EchoRing()
  "echom string(s:bufring)
"endfunction

function! s:update_ring()
  "echom string(s:bufring)
  let bufnum = bufnr('%')
  let bufindex = index(s:bufring, bufnum) != -1 
  if bufindex
    call remove(s:bufring, index(s:bufring, bufnum))
  "echom string(s:bufring)
  endif
  call add(s:bufring, bufnum)
  "echom string(s:bufring)
endfunction

function! s:switch_buf(...)
  if a:0 > 0
    "echom 'a:000: '.string(a:000)
    let ccount = split(a:1, ',')[0]
    let args = substitute(a:1,'^-\?\d\+,\(.*\)$','\1','')
  else
    let ccount = v:count
    let args = ''
  endif
  "echom 'count: '.ccount
  "echom 'args: '.args
  let len = len(s:bufring)

  if args != '' && ccount == 0
    "echom 1
    "echom 'buffer ' . args
    exec  'buffer ' . args
  elseif args != '' && ccount != 0
    echom 'Use either a count or an argument, not both.'
  elseif ccount == 0
    "echom 2
    "echom 'buffer ' . s:bufring[-2]
    exec  'buffer ' . s:bufring[-2]
  else
    "echom 3
    "echom 'buffer ' . s:bufring[-(ccount+1)]
    exec  'buffer ' . s:bufring[-(ccount+1)]
  endif
endfunction

augroup bufring
  au!
  au BufEnter * call <SID>update_ring()
augroup END

noremap <Plug>BufRing :Bufring<CR>
if hasmapto('<Plug>BufRing','n')
  silent! nmap <leader>br <Plug>BufRing
endif

command! -bar -nargs=? -complete=buffer -count=0 Bufring call <SID>switch_buf('<count>,<args>')
if !exists(':Br')
  command! -bar -nargs=? -complete=buffer -count=0 Br call <SID>switch_buf('<count>,<args>')
endif
