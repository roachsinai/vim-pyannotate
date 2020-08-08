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



## Dependences

[dropbox/pyannotate: Auto-generate PEP-484 annotations](https://github.com/dropbox/pyannotate)
