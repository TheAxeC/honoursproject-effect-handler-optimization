# 8. :: 14 Nov - 20 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/8-optimization-split-handler` |
| time          | **Spend approximately 27 hours this week.**      |
| head          | `	ef17062`      |
| commit: fix pure_beta_reduce          | `f463af2`      |
| commit: pure application specialization: uncomment          | `3b437ec`      |
| commit: optimization split-handler specialization          | `5a71de1`      |
| commit: optimization split-handler specialization         | `68543f5`      |
| commit: new test script - compare optimized and unoptimized files         | `abf44d8`      |
| commit: new test script - output variables from optimized and unoptimized files (current head)         | `e5ee123`      |

## Index:
- [x] Optimization: split-handler specialization
- [x] Optimization: split-handler generalization
- [x] Optimization error: handle letin
- [x] Optimization error: apply purelambda
- [x] Easier method to test optimizations
- [x] Optimization error: apply
- [x] Optimization error: pure apply specialization
- [x] Check has not been implemented

## Optimization: split-handler specialization (done)
```ocaml
with h handle (c1 >> c2)

(* if c2 is pure in terms of h we can transform this to: *)

with h' handle (c1)
(* with c2 refactored into the value clause *)
```
The only thing we need to do is to refactor `c2` into the value clause.

```ocaml
| Handle ({term = Handler h}, {term = Bind (c1, {term = (p1, c2)})})
      when (Scheme.is_pure_for_handler c2.Typed.scheme h.effect_clauses) ->
  Print.debug "Move inner bind into the value case";
  let new_value_clause = abstraction p1 (bind (reduce_comp st c2) h.value_clause) in
  let hdlr = handler {
    effect_clauses = h.effect_clauses;
    value_clause = new_value_clause;
    finally_clause = h.finally_clause;
  } in
  reduce_comp st (handle (refresh_expr hdlr) c1)
```

## Optimization: split-handler generalization (done)
This case is very similar to the specialization, the only difference is that we still need to place a handler around `c2`.

```ocaml
| Handle ({term = Handler h} as h2, {term = Bind (c1, {term = (p, c2)})}) ->
  Print.debug "Move (dirty) inner bind into the value case";
  let new_value_clause = abstraction p (handle (refresh_expr h2) (refresh_comp (reduce_comp st c2) )) in
  let hdlr = handler {
    effect_clauses = h.effect_clauses;
    value_clause = refresh_abs new_value_clause;
    finally_clause = h.finally_clause;
  } in
  reduce_comp st (handle (refresh_expr hdlr) (refresh_comp c1))
```

## Optimization error: handle letin (fixed)
```ocaml
effect EffectExample : unit -> int
;;
let handlerExample = handler
    | #EffectExample () k -> k 2 + k 2
    | val x -> x + 4

;;
let a = with handlerExample handle (
    let e = #EffectExample () in
    e + 1 + #EffectExample ()
)
```
This should evaluate to `36` but instead evaluates to `6`:
```ocaml
let _a_307 = Pervasives.(+) (Pervasives.(+) 2 1) (Pervasives.(+) 2 1)
```

The error was within `pure_beta_reduce`. Here, the line `pure_abstraction p (optimize_expr st e)` should actually be `pure_abstraction p (optimize_expr st exp)`.

## Optimization error: apply purelambda (explained)
Commenting this function crashes the compilation process: `Error: This expression has type int computation but an expression was expected of type int`.

This happens with any example, since the bug already shows up within the `Pervasives`.

The incorrect code:
```ocaml
let _abs_211 = (fun _x_212 ->  (match Pervasives.(<) _x_212
0 with | true ->
          ((*pure*)fun _x_24 ->
          Pervasives.(~-)
       _x_24)
       _x_212
       | false ->
          value _x_212))
```

The correctly produced code:
```ocaml
let _abs_211 = (fun _x_212 ->  (match Pervasives.(<) _x_212
0 with | true ->
          value (Pervasives.(~-)
       _x_212)
       | false ->
          value _x_212))
```

The line that is causing the error:  
`("~-", monomorphic @@ unary_inlinable "Pervasives.(~-)" Type.int_ty Type.int_ty);`

## Easier method to test optimizations (done)
### Pretty print the output
Use `main.ml` as a template file. Compile each testcase, rename/replace the `ml` files and run the main test script.

Requires the variable name to be specified as a parameter to be placed in the template file. The rest can happen automatically. Perhaps we can extract the variable names using a `grep`?

Compile with:`ocamlc notopt.ml opt.ml main.ml`  
Run: `./a.out`

```ocaml
value "End of pervasives"
(* some newlines *)
let rec? (capture name) = (* code *)
```
Add all variables in the template `main.ml` file.


### Comparing the complete output
Compile each testcase and compare the output of the `ml` files. Requires the inclusion of a `;;` at the end of the `ml` files.
```
ocaml < _tmp_no_opt/test.eff.ml > test.txt
ocaml < _tmp/test.eff.ml > opt.txt
diff opt.txt test.txt --ignore-space-change
```

## Optimization error: apply (old code -> does not occur anymore)
```ocaml
effect EffectExample : unit -> int
;;

let functionExample () = 1 + (#EffectExample ())

;;

let handlerExample = handler
  | #EffectExample () k -> k 2 + k 2

;;

with handlerExample handle (functionExample ())
```
The error that occurs is: `Typing error (file "test.eff", line 18, char 45):
This expression has type unit but it should have type int.`.

The implementation of the `Handle Apply` optimization has already changed. Now this example given the same error as the `pure apply` error below.

## Optimization error: pure apply (explained)
Optimizing a handle pure application specialization crashes the compilation with the following error:
`Fatal error: exception File "src/codegen/optimize.ml", line 435, characters 16-21: Pattern matching failed`

This line is:
`let (f_ctx,Type.Arrow(f_ty_in, f_ty_out ),f_const) = ae1.scheme in`

The issue is that `ae1.scheme` is not of type `Type.Arrow`, but of type `Type.param`.  
This is a case that can happen, the following complete, minimal example shows the bug:

```ocaml
effect EffectExample : unit -> int

let functionExample () = 1 + 5

let handlerExample = handler
  | #EffectExample () k -> k 2 + k 2

;;

with handlerExample handle (
    let testFunc p = p () in
    testFunc functionExample
)
```

In testFunc, we apply `p` to the parameter `()`. We know that `p` is/should be an application.  
However, inside the compiler, `p` has the type `Type.param`, not type `Type.Arrow`.

## Check has not been implemented outside of the interpreter (no priority)
Title is quite self-explanatory. The built-in construct `check` yields errors.  
`Error: Unbound value check`
