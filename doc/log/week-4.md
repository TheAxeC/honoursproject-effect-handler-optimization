# 4. :: 17 Okt - 23 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/4-check-for-optimization` |
| time          | **Spend approximately 12 hours this week.**      |
| head          | `a4f0392`      |

## Thoughts
- Still find it difficult to reason about certain parts of the optimization:
	* ex. continuation ends in tail call --> can be optimized

## Code snippet

Definition of the bind
```ocaml
let rec ( >> ) (c : 'a computation) (f : 'a -> 'b computation) =
  match c with
  | Value x -> f x
  | Call (eff, arg, k) -> Call (eff, arg, (fun y -> (k y) >> f))
```

Example:
```ocaml
effect EffectExample : unit -> int

let handlerExample = handler
	| #EffectExample () k -> k 1
	| val x -> x + 4
;;

let f x = x + #EffectExample ()

;;

with handlerExample handle
    f (7) + 3
```

Nonoptimized example currently compiles to:
```ocaml
handle { value_clause = (fun _x_85 ->  value (Pervasives.(+) _x_85 4));
        finally_clause = (fun _gen_id_par_84 ->  value _gen_id_par_84);
        effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_EffectExample -> (fun (() :  unit) (_k_86 :  int -> _ computation) -> _k_86
        1) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (
(_f_284 1) >> fun _gen_bind_83 ->  value (Pervasives.(+) _gen_bind_83 3))
```

It should compile to:
```ocaml
value (Pervasives.(+) (Pervasives.(+) (Pervasives.(+) 1 2) 3) 4)
```
