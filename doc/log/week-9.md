# 9. :: 21 Nov - 27 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/9-optimization-let-rec` |
| time          | **Spend approximately 14 hours this week.**      |
| head          | `	e5ee123`      |
| commit: handle LetRec | `8e3e6a7` |
| commit: improve inlining of pervasives | `15e5892` |

## Clone efficient-handlers benchmark repository
Cloned the efficient-handlers repository

## Write handler optimization: let-rec
```ocaml
| Handle (h, {term = LetRec (defs, co)}) ->
  let handle_h_c = reduce_comp st (handle h co) in
  let res =
    let_rec' defs handle_h_c
  in
  reduce_comp st res
```

I still need to write a testcase to show the optimization.

## Improve inlining
Some pervasives weren't being inlined properly. These pervasives were:
- `<=`
- `>=`
- `!=`
- `<`
- `<>`

## Write benchmark programs
I need to port the monad transformers paper porten to Eff. (paper: monad modular interpreter)
