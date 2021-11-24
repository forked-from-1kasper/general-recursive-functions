Firstly we assume that we have natural numbers `ℕ`: 0, 1, 2, …

We consider functions `ℕᵏ → ℕ`, and identify `ℕ⁰ → ℕ` with just `ℕ`, i.e. we have unique `k` assigned to each function. `f : ℕᵏ → ℕ` means that `f` accepts `k` arguments.

Now we postulate a few basic functions:

* Constant functions for each k, n ∈ ℕ: `C k n : ℕᵏ → ℕ`.
* Successor function: `S : ℕ → ℕ`.
* Projection functions for each 1 ≤ i ≤ k ∈ ℕ: `π i k : ℕᵏ → ℕ`.

And a few basic operators that construct a new function from some already defined ones:

* Composition operator `f ∘ (g₁, …, gₙ) : ℕᵏ → ℕ`, where `f : ℕⁿ → ℕ` and `gᵢ : ℕᵏ → ℕ` for each 1 ≤ i ≤ n.
* Primitive recursion operator `ρ f g : ℕᵏ⁺¹ → ℕ`, where `f : ℕᵏ → ℕ` and `g : ℕᵏ⁺² → ℕ`.
* Minimization operator `μ f : ℕᵏ → ℕ` where `f : ℕᵏ⁺¹ → ℕ`.

This is enough to write typechecker, but now we need to give computational semantics for these functions.

We denote function application as `f(x₁, …, xₙ)` for function `f : ℕⁿ → ℕ`.

Then we define function application recursively:

* `(C k n)(x₁, …, xₖ)` ≡ `n`.
* `S(x)` ≡ `x + 1` (here we assume that there is a way to calculate `x + 1`, but it’s not necessary to define `x + y` for arbitrary x, y ∈ ℕ).
* `(π i k)(x₁, …, xₖ)` ≡ `xᵢ`.
* `(f ∘ (g₁, …, gₙ))(x₁, …, xₖ)` ≡ `f(g₁(x₁, …, xₖ), …, gₙ(x₁, …, xₖ))`.
* `(ρ f g)(0, x₁, …, xₖ)` ≡ `f(x₁, …, xₖ)`.
* `(ρ f g)(y + 1, x₁, …, xₖ)` ≡ `g(y, (ρ f g)(y, x₁, …, xₖ), x₁, …, xₖ)`.
* `(μ f)(x₁, …, xₖ)` is a minimum `y` such that `f(y, x₁, …, xₖ)` ≡ 0. If `f(y, x₁, …, xₖ)` is always greater than zero, it does not terminate.