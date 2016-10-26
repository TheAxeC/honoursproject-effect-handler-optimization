# Log for the honoursprogramme

This is my main log file for the honoursprogramme. Weekly progress will be recorded in this file.

## 0. :: IFL August 31 - September 2, 2016
Prof. dr. ir. Tom Schrijvers invited me to attend [IFL 2016](https://dtai.cs.kuleuven.be/events/ifl2016/) in order to get an idea of current research in the Functional Programming Language world. I was mostly interested in talks about Effect Handlers.

## 1. :: 26 Sept - 2 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/1-learning-language` |
| time          | **Spend approximately 20 hours this week.**      |


### Time


Getting familiar with Eff. This means getting comfortable with the syntax, types, compiler and current optimizations.

The following are the files of interest in the Eff compiler:
* Optimization: `src/codegen/optimize.ml`
* Types: `src/syntax/typed.ml`
* Printing AST: `src/codegen/camlPrint.ml`
* AST generation: `src/codegen/codegen.ml`
* General printing: `src/utils/print.ml`
* Main file: `src/eff.ml`

## Tips
- The main website of Eff is :http://www.eff-lang.org/
- bitbucket: https://bitbucket.org/matijapretnar/eff
- Dependencies: Ocaml + Opam
- Compile command: `./eff.native -V 4 -n --compile filename.eff`

## 2. :: 3 Okt - 9 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/2-learning-optimizations` |
| time          | **Spend approximately 20 hours this week.**      |

## Literature
Reading papers
- An Introduction to Algebraic Effects and Handlers
- An effect system for Algebraic Effects and Handlers
- Inferring Algebraic effects

### Code snippets
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

### Questions
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

## 3. :: 10 Okt - 16 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/3-check-for-optimization` |
| time          | **Spend approximately 16 hours this week.**      |

## Literature
Reading papers
- Handling Algebraic effects
- Programming with Algebraic Effects and Handlers

## Code snippets
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

## 4. :: 17 Okt - 23 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/4-check-for-optimization` |
| time          | **Spend approximately 12 hours this week.**      |

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

## 5. :: 24 Okt - 30 Okt 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/5-write-optimization` |
| time          | **Spend approximately 10 hours this week.**      |

### optimization
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
