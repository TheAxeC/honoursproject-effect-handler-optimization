# Log for the honoursprogramme
This is my main log file for the honoursprogramme.

## IFL August 31 - September 2, 2016
Prof. Tom Schrijvers invited me to attend [IFL 2016](https://dtai.cs.kuleuven.be/events/ifl2016/) in order to get an idea of current research in the Functional Programming Language world. I was mostly interested in talks about Effect Handlers.

## Pre 10 Okt 2016
Getting familiar with Eff. This means getting comfortable with the syntax, types, compiler and current optimizations.

The following are the files of interest in the Eff compiler:
* Optimization: `src/codegen/optimize.ml`
* Types: `src/syntax/typed.ml`
* Printing AST: `src/codegen/camlPrint.ml`
* AST generation: `src/codegen/codegen.ml`
* General printing: `src/utils/print.ml`
* Main file: `src/eff.ml`

**Spend approximately 20 hours on this task.**

## 10 Okt 2016
### Testing
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


### Questions:
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

## 11 Okt 2016
First I thought I needed to optimize the following case:
```ocaml
with h handle
    functionCall (param)
```

However I need to be able to handle the case in which a function call is used in combination with other code.
```ocaml
with h handle
    functionCall (param) + 3
```

This code generates a Bind. This Bind is what I need to optimize.
```ocaml
((_f_283 5) >>
   (fun _gen_bind_81  -> value (Pervasives.(+) _gen_bind_81 5)))
```

Possible situations were we can optimize are:
* Function call is pure (does not use effects from enclosing handler)
* Tail call for the continuation in the Handler
