# vimrc

#### 31/08/2017

MAJOR CHANGE: I switched from NeoBundle to [vim-plug](https://github.com/junegunn/vim-plug) which seems more actively developed.

Organize my vim life.

The aim is to have a "nice" vim experience that is portable from desktop/laptop to servers.

```
cd ~
# Backup whatever VIM configuration you have
mv .vim .vim_back
mv .vimrc .vimrc_back
git clone https://github.com/edoardob90/vimrc.git .vim
ln -s .vim/vimrc .vimrc
mkdir -p ~/.vim/myplugins  # you can change this directory, but you need to change the path also in vimrc
vim .vimrc
```

After that, reload .vimrc and **:PlugInstall** to install plugins.
