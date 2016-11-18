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


## Possible optimizations:
- [x] Unused
- [x] | Value of expression
- [ ] | Let of (pattern \* computation) list \* computation => nope
- [ ] | LetRec of (variable \* abstraction) list \* computation => nope
- [x] | Match of expression \* abstraction list
- [ ] | While of computation \* computation => nope
- [ ] | For of variable \* expression \* expression \* computation \* bool => nope
- [x] | Apply of expression \* expression
- [x] | Handle of expression \* computation => happens implicitly: `optimize_comp st c = reduce_comp st (optimize_sub_comp st c)`
- [ ] | Check of computation  => does not seem implemented
- [x] | Call of effect \* expression \* abstraction
- [x] | Bind of computation \* abstraction
- [x] | LetIn of expression \* abstraction
