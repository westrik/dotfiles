syntax on
filetype plugin indent on

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'            " Sensible vim defaults
Plug 'tpope/vim-surround'            " Add quote substition commands
Plug 'sheerun/vim-polyglot'          " On-demand language packs
Plug 'google/vim-maktaba'            " Needed for vim-bazel
Plug 'bazelbuild/vim-bazel'          " Run bazel commands in vim
Plug 'Valloric/YouCompleteMe'        " Auto-completion

call plug#end()