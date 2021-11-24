open Error
open Expr

let rec infer ctx e : texpr = match e with
  | Nat _ -> 0
  | Const (k, _) -> k
  | Succ -> 1
  | Proj (i, k) -> guard (i <= k) "In π(i, k) must hold i ≤ k"; k
  | Comp (f, gs) -> let k = infer ctx f in
    guard (k = List.length gs) "In f ∘ (g₁, …, gₖ) must hold R(f) = ℕᵏ";
    begin match gs with
      | []       -> 0
      | g :: gs' -> let n = infer ctx g in
        guard (List.for_all (fun h -> infer ctx h = n) gs')
          "In f ∘ (g₁, …, gₖ) must hold ∀ i j: R(gᵢ) = R(gⱼ)"; n
    end
  | Recur (f, g) ->
    let k = infer ctx f in guard (k + 2 = infer ctx g)
      "In ρ(f, g) must hold R(f) = ℕᵏ and R(g) = ℕᵏ⁺² for some k ∈ ℕ"; k + 1
  | Min f -> let k = infer ctx f in guard (k > 0)
      "In μ(f) f must be a function"; k - 1
  | Var x -> begin match Env.find_opt x ctx with
    | Some (k, _) -> k
    | None        -> unknown x
  end

let cons = function
  | []      -> raise (Invalid_argument "cons")
  | x :: xs -> (x, xs)

let rec eval ctx e xs = guard (infer ctx e = List.length xs)
    "Invalid number of arguments"; match e with
  | Nat k -> k
  | Const (_, n) -> n
  | Succ -> 1 + List.hd xs
  | Proj (i, _) -> List.nth xs (i - 1)
  | Comp (f, gs) -> eval ctx f (List.map (fun g -> eval ctx g xs) gs)
  | Recur (f, g) -> let (y, ys) = cons xs in
    let n = ref (eval ctx f ys) in
    for i = 1 to y do
      n := eval ctx g (i - 1 :: !n :: ys)
    done; !n
  | Min f -> let n = ref 0 in
    while eval ctx f (!n :: xs) <> 0 do
      n := !n + 1
    done; !n
  | Var x -> begin match Env.find_opt x ctx with
    | Some (_, e) -> eval ctx e xs
    | None        -> unknown x
  end