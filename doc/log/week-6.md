# 6. :: 31 Okt - 6 Nov 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/6-fix-optimization` |
| time          | **Spend approximately 10 hours this week.**      |
| head          | `b9eea0f`      |
| own commit          | `1abce2d`      |

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

Other fixes:
- Dirt_Param: if larger than 0 -> effect is present, otherwise it is not present

## Test framework
The test framework failes when it runs.  
The main issue is:
- layout of the code printing

Reference file:
```ocaml
;;value (Pervasives.( * ) 3 2)
```
Produced file:
```ocaml
let _ = value (Pervasives.( * ) 3 2)
```

## Meeting: 3 November 2016

| Typing system        |          |
| ------------- |:--------:|
| `src/typing/constraints.ml` | Constraint definitions |
