# vimrc

Organize my vim life.

The aim is to have a "nice" vim experience that is portable from desktop/laptop to servers.

### Updates

#### 1/05/2020

This repo is now a submodule of my [dotfiles](https://github.com/edoardob90/dotfiles) repo. It will be automatically copied in the correct folder when recursively cloning.

**IMPORTANT NOTES:**

1. it's still needed to manually install `vim-plug` (see below) for VIM or Neovim.

2. see the updated configuration section. TL;DR: the symlinks are managed by the dotfiles manager that's installed when cloning the main repo.

#### 31/08/2017

I switched from NeoBundle to [vim-plug](https://github.com/junegunn/vim-plug) which seems more actively developed.

## Install `vim-plug` first

### Vim

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Neovim

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Configure

- Create symlink with `dot set` once the main repo has been cloned (recursively!)

- Open nvim and issue `:PlugInstall` to install plugins.

### Warnings

- If using Neovim, the plugin "Deoplete" (for autocompletion) requires **at least `nvim` 0.3.0**.
