# 6. :: 7 Nov - 13 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/7-fix-optimization` |
| time          | **Spend approximately 5 hours this week.**      |
| head          | `1abce2d`      |

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

## Observations
```ocaml
let functionName a b = .....

(* Multiple parameters = a -> b -> .... *)
(* calling `functionName a` returns a function that takes 1 parameter *)
val functionName a -> b -> returnType
```
