# vim-pyannotate

## Install

```
Plug 'skywind3000/asyncrun.vim'
Plug 'roachsinai/vim-pyannotate'
```

## Usage

1. Cursor on the function that need to be annotated.
2. Run `:AnnotatePyFile`.
3. Follow prompt input parameters function need, no brackets surround.

If you want annotate member function, you should custom a function like [gcd.py](https://github.com/dropbox/pyannotate/blob/master/example/gcd.py). Then put cursor on `main` on step 1.

For example,

![member_function](assets/member_function.gif)

## Project Root

> The project root is the nearest ancestor directory of the current file which contains one of these directories or files: `.svn`, `.git`, `.hg`, `.root` or `.project`. If none of the parent directories contains these root markers, the directory of the current file is used as the project root. The root markers can also be configurated, see [Project Root](https://github.com/skywind3000/asyncrun.vim/wiki/Project-Root).
>
> If your current project is not in any git or subversion repository, just put an empty .root file in your project root.

This plugin vim-pyannotate will create a `.pyannotate` folder under project root.

## Dependences

[dropbox/pyannotate: Auto-generate PEP-484 annotations](https://github.com/dropbox/pyannotate)
