# 10. :: 28 Nov - 4 Dec 2016
| Config        |          |
| ------------- |:--------:|
| src folder    | `src/10-benchmark-parser` |
| time          | **Spend approximately 20 hours this week.**      |
| head          | `	30e422e`      |

## Write benchmark programs: Parser help
I helped with the parser benchmark program in Eff.

```ocaml
effect Consume : unit -> string;;
effect Fail : unit -> empty;;

let hdlr = handler
    | val y -> (fun _ -> y)
    | #Consume () k ->
        fun s ->
        (match s with
            | [] -> absurd (#Fail ())
            | (x :: xs) -> k x xs);;

let res = (with hdlr handle (
let c = #Consume () in
let d = #Consume () in
    match (c) with
        | "a" -> d
        | _ -> ""


)) ["a"; "b"]
```

## Bug type system: propagation of dirt
In the current commit of the codegen branch, the queens example does not work. The "Remove handler when computation does not share effects with handler" optimization removes handlers that it should not remove.

While debugging, Amr and I went back to previous commits to check whether the bug was also present there. In commit "15e5892" the queens example works correctly (no handlers are removed). However, from newer commits, the queens example breaks. We think the problem is in the type system since the subsequent commit makes changes to the type system.

The function "is_pure_for_handler" returns the wrong result since it returns true when it should return false in the queens example. In the pure branch (which includes the optimizations), the example does work correctly.

```ocaml
effect Fail : unit -> empty

let choose_all = handler
  | val x -> [x]
  | #Fail _ _ -> []

let result = with choose_all handle
(  let rec place x qs =
    #Fail ()
  in
  place 1 [])
```

## Write benchmark programs: interpreter
I had understood the paper wrong and thought that I needed to implement each feature of the language (eg. Add) as an effect.
However, what I should do, is use the type system and pattern matching to handle the language features. I only need to use effects to replace the monad transformers.

```ocaml
type term =
    | Int of int
    | Float of float ;;

effect Num : float -> float;;
effect Add : (float * float) -> float;;
effect Div : (float * float) -> float;;

effect Var : string -> float;;
effect Set : (string * float) -> float;;
effect VarNotFound : unit -> empty;;

effect Func : float -> float;;

let interpHandler = handler
    | #Num i k -> k i
    | #Add (i1, i2) k -> k (i1 +. i2)
    | #Div (i1, i2) k ->
        begin match i2 with
            | 0. -> absurd (#DivisionByZero ())
            | _ -> k (i1 /. i2)
        end;;

let rec lookup x = function
    | [] -> absurd (#VarNotFound ())
    | (x', y) :: lst -> if x = x' then y else lookup x lst;;

let update k v env=
    (k, v) :: env;;

let varHandler = handler
    | val y -> (fun _ -> y)
    | #Var x k -> (fun s -> k (lookup x s) s)
    | #Set (x, y) k -> (fun s -> k y (update x y s));;

let interpC t =
    with interpHandler handle (t ());;
```
