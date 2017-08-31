# vimrc

Organize my vim life.

The aim is to have a "nice" vim experience that is portable from desktop/laptop to servers.

```
cd ~
mv .vim .vim_back
mv .vimrc .vimrc_back
git clone https://github.com/edoardob90/vimrc.git .vim
ln -s .vim/vimrc .vimrc
vim .vimrc
```
MAJOR CHANGE: I switched from NeoBundle to [vim-plug](https://github.com/junegunn/vim-plug) which seems more actively developed. 
