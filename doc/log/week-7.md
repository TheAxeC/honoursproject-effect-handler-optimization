# 6. :: 7 Nov - 13 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/7-fix-optimization` |
| time          | **Spend approximately 14 hours this week.**      |
| head          | `1abce2d`      |
| commit: fix optimization          | `254a3d3`      |
| commit: update gitignore          | `	1be7a39`      |
| commit: update codegen tests          | `c1d42f4`      |
| commit: update tests (current head)         | `ef17062`      |

## Fixing the previous optimization
The complete, minimal example that shows the bug
```ocaml
effect EffectExample : unit -> int

effect EffectExampleOther : unit -> int

let handlerExample = handler
	| #EffectExample () k ->
		handle (k 1) with
			| #EffectExampleOther () k2 -> k2 1
	| val x -> x + 3
;;

let functionExample () = 1 + #EffectExample () + #EffectExampleOther ()

;;

with handlerExample handle (functionExample () + 2)
```
The optimization cannot see the effects that happen in the continuation `k`

### Solution

`constraints.ml`
```ocaml
let is_pure_for_handler { dirt_poset; region_poset; full_regions } { Type.ops; Type.rest } eff_clause =
  (* full_regions = unhandled effects in the computation *)
  let check_region eff r =
    (* check if 'eff' is present in the eff_clause, otherwise we don't care *)
    let rec hasCommonEffects eff_list =
        match eff_list with
            | [] -> false
            | ((eff_name,(_,_)),_)::tail when eff_name = eff -> true
            | ((eff_name,(_,_)),_)::tail -> hasCommonEffects tail
        in
    if (not (hasCommonEffects eff_clause)) then true
    else
        (* check whether the region is a constraint *)
        RegionPoset.get_prec r region_poset = [] &&
        not (FullRegions.mem r full_regions)
    in
  (* for all 'ops' check the region *)
  List.for_all (fun (eff, r) -> check_region eff r) ops &&
  (* check the rest *)
  DirtPoset.get_prec rest dirt_poset = []

```

`scheme.ml`
```ocaml
(*
    check whether the dirty_scheme is pure in terms of the handler
    ie.
        check if any operations from the handler can occur in the computation
        if so => the dirty_scheme is dirty
        otherwise the dirty_scheme is pure
*)
let is_pure_for_handler (ctx, (_, drt), cnstrs) eff_clause =
  let add_ctx_pos_neg (_, ctx_ty) (pos, neg) =
    let pos_ctx_ty, neg_ctx_ty = Type.pos_neg_params Tctx.get_variances ctx_ty
    and (@@@) = Trio.append in
    neg_ctx_ty @@@ pos, pos_ctx_ty @@@ neg
  in
  let (_, pos_ds, _), (_, neg_ds, _) = List.fold_right add_ctx_pos_neg ctx (Trio.empty, Trio.empty) in
  (* Check if the constraints from the operations in the dirt are pure in terms of the handler *)
  Constraints.is_pure_for_handler cnstrs drt eff_clause &&
  (* Check if the rest occurs in the pos_ds or neg_ds *)
  not (List.mem drt.Type.rest (pos_ds @ neg_ds))

```

`optimize.ml`
```ocaml
| Handle ({term = Handler h}, c1)
       when (Scheme.is_pure_for_handler c1.Typed.scheme h.effect_clauses) ->
```

### Observations
```ocaml
let functionName a b = .....

(* Multiple parameters = a -> b -> .... *)
(* calling `functionName a` returns a function that takes 1 parameter *)
val functionName a -> b -> returnType
```

## Optimization: split-handler specialisation
```ocaml
with h handle (c1 >> c2)

(* if c2 is pure in terms of h we can transform this to: *)

with h' handle (c1)
(* with c2 refactored into the value clause *)
```
I still need to implement this optimization.
