# 5. :: 24 Okt - 30 Okt 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/5-write-optimization` |
| time          | **Spend approximately 20 hours this week.**      |
| head          | `a4f0392`      |
| own commit          | `caaa33e`      |

## Optimization
```ocaml
with h handle (c)
```  
can be optimized to
```ocaml
c >> (fun x -> h.value_case x)
```
**if** `effects(c)` intersection `effects(h)` = empty

Optimization is written as:
```ocaml
| Handle ({term = Handler h}, c1) ->
  let rec hasCommonEffects l1 l2 =
	  match l1 with
		  | [] -> false
		  | (h1,_)::t1 -> (
			  match l2 with
				  | [] -> false
				  | ((h2,(_,_)),_)::t2 when h1 = h2 -> true
				  | ((h2,(_,_)),_)::t2 -> (hasCommonEffects t1 l2) || (hasCommonEffects l1 t2)
		  ) in
  let get_dirt (_,(_,dirt),_) = dirt in
  let res = hasCommonEffects (get_dirt (c1.Typed.scheme)).Type.ops h.effect_clauses in
  if res then (c)
  else (
	  Print.debug "Remove handler, keep handler since no effects in common with computation";
	  reduce_comp (bind c1 h.value_clause)
  )
```
This is a very general case since it will match every `with h handle c`.  
We can rewrite the rule as a `match when`  
The `check for common effects` can also be extracted.  
``` ocaml
and hasEffectsInCommon c h =
    (* Print.debug "%t" (CamlPrint.print_computation_effects c1); *)
    let rec hasCommonEffects l1 l2 =
        match l1 with
            | [] -> false
            | (h1,_)::t1 -> (
                match l2 with
                    | [] -> false
                    | ((h2,(_,_)),_)::t2 when h1 = h2 -> true
                    | ((h2,(_,_)),_)::t2 -> (hasCommonEffects t1 l2) || (hasCommonEffects l1 t2)
            ) in
    let get_dirt (_,(_,dirt),_) = dirt in
    hasCommonEffects (get_dirt (c.Typed.scheme)).Type.ops h.effect_clauses



| Handle ({term = Handler h}, c1) when (not (hasEffectsInCommon c1 h)) ->
  Print.debug "Remove handler, keep handler since no effects in common with computation";
  reduce_comp (bind (refresh_comp c1) (refresh_abs h.value_clause))
```

Now we can also optimize other cases. For example the case below where `c1` does not have any effects in common with `h`.
```ocaml
with h handle (c1 >> c2)
```

This can be written as:
```ocaml
| Handle ({term = Handler h} as handler, {term = Bind (c1, {term = (p1, c2)})}) when  (not (hasEffectsInCommon c1 h)) ->
  Print.debug "Remove handler of outer Bind, keep handler since no effects in common with computation";
  reduce_comp (bind (reduce_comp c1) (abstraction p1 (reduce_comp (handle (refresh_expr handler) c2))))
```

## Thoughts
I have tested these optimizations with the new testsuite. All cases that succeeded before, also succeed when the optimizations are enabled.

I have also run the `n-queens.eff` example. It is interesting to note that all `Fail` effects are removed.
 * This was actually an effect from the incorrect optimization

## Questions
Can an optimized file also be interpreted by the Eff compiler?  
Would it be possible to also optimize commands when not using the `--compile` flag.
 * This is not possible since the interpreter is not up to date.

## Meeting: 28 Oktober
The current optimization is wrong. This can be seen in `queens.eff` which does not compile correctly. Too many handlers are removed. I should use the region parameter.
### Other optimization
```ocaml
h (c1 >> x. c2)  
h' (c1)  

with the continuation (c2) refactored into the value case of the handler
```

The following optimization should be possible in certain circumstances.
```ocaml
with h handle (f x >> c2)

(with h' handle (f x)) >> (with h'' handle (c2))
```  
Can this be generalized to:
```ocaml
with h handle (c1 >> c2)

(with h' handle (c1)) >> (with h'' handle (c2))
```  

### Benchmarking
Benchmarking can be done with the efficient-handlers repository.
