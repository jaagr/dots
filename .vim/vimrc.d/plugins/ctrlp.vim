"let g:ctrlp_map = "<leader>p"
let g:ctrlp_cmd = "CtrlPMixed"

let g:ctrlp_open_new_file = "v"
let g:ctrlp_cache_dir = expand("$XDG_CACHE_HOME/ctrlp")
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 15000

let g:ctrlp_regexp = 1
let g:ctrlp_working_path_mode = "ra"
let g:ctrlp_follow_symlinks = 2
let g:ctrlp_show_hidden = 1

let g:ctrlp_user_command = {
  \ "types": {
    \ 1: [".git/", "git --git-dir=%s/.git ls-files -oc --exclude-standard | grep -vE '\.(old|bak|tmp)\/'"]
    \ },
  \ "fallback": "$HOME/.vim/bin/ctrlp_fallback %s"
  \ }

" let g:ctrlp_custom_ignore = {
"   \ "dir" : "\v[\/](\.git|\.cpan|\.rvm|\.sass-cache|\.svn|node_modules)$",
"   \ "file": "\.(o|pyc|swp|zip|tar|rar)$"
"   \ }
