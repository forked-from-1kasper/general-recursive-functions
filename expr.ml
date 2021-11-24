type texpr = int

type expr =
  | Nat of int
  | Const of (int * int)
  | Succ
  | Proj of (int * int)
  | Comp of (expr * expr list)
  | Recur of (expr * expr)
  | Min of expr
  | Var of string

module Env = Map.Make(String)
type ctx = (int * expr) Env.t
type file = (string * expr) list

let rec showExpr : expr -> string = function
  | Nat n -> string_of_int n
  | Const (k, n) -> Printf.sprintf "C %d %d" k n
  | Succ -> "S"
  | Proj (i, k) -> Printf.sprintf "π %d %d" i k
  | Comp (f, gs) ->
    List.map showExpr gs
    |> String.concat ", "
    |> Printf.sprintf "%s ∘ (%s)" (showExpr f)
  | Recur (f, g) -> Printf.sprintf "ρ %s %s" (showExpr f) (showExpr g)
  | Min f -> Printf.sprintf "μ %s" (showExpr f)
  | Var x -> x
