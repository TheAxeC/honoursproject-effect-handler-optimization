# 9. :: 21 Okt - 27 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/9-optimization-let-rec` |
| time          | **Spend approximately 8 hours this week.**      |
| head          | `	e5ee123`      |

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

## Write benchmark programs
monad transformers vb porten naar Eff: paper monad modular interpreter
