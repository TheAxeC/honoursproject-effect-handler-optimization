# Possible optimizations

## Remove unused handler (implemented)
```ocaml
with h handle (c)
```  
can be optimized to
```ocaml
c >> (fun x -> h.value_case x)
```
**if** `effects(c)` intersection `effects(h)` = empty

## Remove unused handler: bind (implemented)
```ocaml
h (c1 >> x. c2)  
h' (c1)  

with the continuation (c2) refactored into the value case of the handler
```

## Split handler: specialisation (implemented)
```ocaml
with h handle (c1 >> c2)

(* if c2 is pure in terms of h we can transform this to: *)

with h' handle (c1)
(* with c2 refactored into the value clause *)
```

## Split handler: generalization (implemented)
Similar to the situation above, except `c2` is not pure in terms of handler `h`


## Handle a LetRec
```ocaml
with h handle (LetRec defs c)

LetRec defs (with h handle c)
```

## Possible optimizations:
- [x] Unused
- [x] | Value of expression
- [x] | Let of (pattern \* computation) list \* computation
- [x] | LetRec of (variable \* abstraction) list \* computation
- [x] | Match of expression \* abstraction list
- [x] | While of computation \* computation
  * while loops are going to be removed
- [x] | For of variable \* expression \* expression \* computation \* bool
  * for loops are going to be removed
- [x] | Apply of expression \* expression
- [x] | Handle of expression \* computation => happens implicitly:  
  * `optimize_comp st c = reduce_comp st (optimize_sub_comp st c)`
- [x] | Check of computation  
  * `check` is not implemented
- [x] | Call of effect \* expression \* abstraction
- [x] | Bind of computation \* abstraction
- [x] | LetIn of expression \* abstraction
