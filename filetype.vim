" vim syntax highlight customizations
" the following is for LAMMPS input
if exists("did_load_filetypes")
 finish
endif

augroup filetypedetect
 au! BufRead,BufNewFile in.*           setfiletype lammps
 au! BufRead,BufNewFile *.lmp          setfiletype lammps
augroup END
