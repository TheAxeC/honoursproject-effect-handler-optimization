# 2. :: 3 Okt - 9 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/2-learning-optimizations` |
| time          | **Spend approximately 20 hours this week.**      |
| head          | `a4f0392`      |

## Literature
Reading papers
- An Introduction to Algebraic Effects and Handlers
- An effect system for Algebraic Effects and Handlers
- Inferring Algebraic effects

## Code snippets
The code below is fully optimized and produces: `value 5`
```ocaml
effect EffectExample : unit -> bool

let a = handler
	| #EffectExample () k -> k true

;;

with a handle (if #EffectExample () then 5 else 20)
```

Explanation of Handler vs Handle:
```
Handler = expression
Handle = computation

Handler of handler = {
	effect_clauses : (effect, abstraction2) Common.assoc;
	value_clause : abstraction;
	finally_clause : abstraction;
}

Handle of expression * computation
	with (expression) handle (computation)

Bind of computation * abstraction
abstraction = (pattern * computation, Scheme.abstraction_scheme) annotation
```

So the bind function is like a semicolon; it separates the steps in a process.
The bind function's job is to take the output from the previous step,
and feed it into the next step.

## Questions
Examples from the website and from the paper don't always use the same syntax. They cannot just be copied over.

The code below does not produce the same result for `a` and `x`. The `finally` clause is not executed.
```ocaml
effect EffectExample : unit -> bool

let finHandler = handler
	| #EffectExample () k -> k true
	| finally x -> x + 5
;;

let a =
	with finHandler handle
		(if (#EffectExample ()) then 5 else 20)
;;

let x = (with finHandler handle
			(if (#EffectExample ()) then 5 else 20)
	) in x + 5

```
