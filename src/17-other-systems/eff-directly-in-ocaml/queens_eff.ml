#directory "_delimcc";;
#load "delimcc.cma";;
#use "delimcc.ml";;
(* open Delimcc;; *)

(***********************)

type empty

type ('a,'w) nondet =
  | Done   of 'w
  | Fail   of unit * (empty -> ('a,'w) nondet)
  | Choose of ('a * 'a) * ('a -> ('a,'w) nondet)
  | Cow    of 'a * ('a -> ('a,'w) nondet)

(* Sugar for sending effects. Notice how regular the sugar is.
   See the inferred types.
*)
let choose p arg = Delimcc.shift0 p (fun k -> Choose (arg,k))
let fail p arg   = Delimcc.shift0 p (fun k -> Fail (arg,k))
let cow p arg    = Delimcc.shift0 p (fun k -> Cow (arg,k))


type 'eff result = Done | Eff of 'eff

type 'a nondet2 =
  | Fail   of unit * (empty -> 'a nondet2 result)
  | Choose of ('a * 'a) * ('a -> 'a nondet2 result)
  | Cow    of 'a * ('a -> 'a nondet2 result)


let choose p arg = Delimcc.shift0 p (fun k -> Eff (Choose (arg,k)))
let fail p arg   = Delimcc.shift0 p (fun k -> Eff (Fail (arg,k)))
let cow p arg    = Delimcc.shift0 p (fun k -> Eff (Cow (arg,k)))

let r = Delimcc.new_prompt ();;

let f () =
  let x = choose r ("a","b") in
  Printf.printf "x is %s\n" x;
  let y = choose r ("c","d") in
  Printf.printf "y is %s\n" y;
;;

type 'a result_value = 'a option ref
let get_result : 'a result_value -> 'a = fun r ->
  match !r with
    Some x -> r := None; (* GC *) x


let handle_it:
    'a result Delimcc.prompt ->                     (* effect instance *)
    (unit -> 'w) ->                         (* expression *)
    ('w result_value -> 'a result -> 'c) -> (* handler *)
    'c = fun effectp exp handler ->
  let res = ref None in
  handler res (Delimcc.push_prompt effectp @@ fun () ->
    res := Some (exp ());
    Done)

(***********************)

type choice =
  | Fail of unit * (empty -> choice result)
  | Decide of unit  * (bool -> choice result)


let c = Delimcc.new_prompt ()

let fail () = match Delimcc.shift0 c (fun k -> Eff (Fail ((),k))) with _ -> failwith "unreachable"
let decide p arg = Delimcc.shift0 p (fun k -> Eff (Decide (arg,k)))

(* let rec choose_left res = function
  | Done -> get_result res
  | Eff Decide ((),k) -> choose_left res @@ k true

let rec choose_max res = function
  | Done -> get_result res
  | Eff Decide ((),k) -> max (choose_max res @@ k true)
                             (choose_max res @@ k false)

let rec choose_all res = function
  | Done -> [get_result res]
  | Eff Fail ((),_)   -> []
  | Eff Decide ((),k) -> (choose_all res @@ k true) @
                         (choose_all res @@ k false)

;;

let _ = handle_it c
 (fun () ->
  let x = (if decide c () then 10 else 20) in
  let y = (if decide c () then 0 else 5) in
  x - y)
 choose_left
;; *)
(*
(* Almost the same syntax as Eff *)
let rec choose xs =
  match xs with
  | [] -> fail ()
  | [x] -> x
  | x :: xs -> if decide c () then x else choose xs

let no_attack (x, y) (x', y') =
  x <> x' && y <> y' && abs (x - x') <> abs (y - y')

let available x qs =
  List.filter (fun y -> List.for_all
      (no_attack (x, y)) qs) [1; 2; 3; 4; 5; 6; 7; 8];;

let rec place x qs =
  if x = 9 then qs else
  let y = choose (available x qs) in
  place (x + 1) ((x, y) :: qs)

(* This is quite inefficient, but it faithfully represents
   the Eff code, with the relay of the Fail effect.
   The better version, which also lets us efficiently cout all
   solutions, should use separate Decide and Fail effects.
 *)
let rec backtrack res = function
  | Done -> get_result res
  | Eff Fail ((),_) -> fail ()
  | Eff Decide ((),k) ->
      handle_it c (fun () -> backtrack res @@ k true) (fun res1 ->
        let rec loop = function
          | Done -> get_result res1
          | Eff Fail ((),_) -> backtrack res @@ k false
        in loop)
;;

let main () =
  handle_it c (fun () ->
  place 1 [])
 backtrack

;;

main ();; *)
(******************************************************************************)

let no_attack (x, y) (x', y') =
  x <> x' && y <> y' && abs (x - x') <> abs (y - y')

let rec not_attacked x' = function
  | [] -> true
  | x :: xs -> if no_attack x' x then not_attacked x' xs else false

let available (number_of_queens, x, qs) =
  let rec loop (possible, y) =
    if y < 1 then
      possible
    else if not_attacked (x, y) qs then
      loop ((y :: possible), (y - 1))
    else
      loop (possible, (y - 1))
  in
  loop ([], number_of_queens)

let absurd void = match void with | _ -> assert false;;

let rec choose xs =
  match xs with
  | [] -> absurd (fail ())
  | x :: xs -> if decide c () then x else choose xs

let rec choose_all res = function
  | Done -> [get_result res]
  | Eff Fail ((),_)   -> []
  | Eff Decide ((),k) -> (choose_all res @@ k true) @
                          (choose_all res @@ k false)

let rec backtrack res = function
  | Done -> (fun _ -> res)
  | Eff Fail ((),_) -> (fun kf -> kf ())
  | Eff Decide ((),k) -> (fun kf -> (backtrack res @@ k true) (fun () -> (backtrack res @@ k false) kf) )

let queens number_of_queens =
  let rec place (x, qs) =
    if x > number_of_queens then qs else
      let y = choose (available (number_of_queens, x, qs)) in
      place ((x + 1), ((x, y) :: qs))
  in
  place (1, [])

let queens_one n = handle_it c (fun () -> queens n) backtrack (fun () -> (absurd (fail ())))
let queens_all n = handle_it c (fun () -> queens n) choose_all;;
