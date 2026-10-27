# Two rings on one sequence: what actually composes, and what the corpus conflates

> **Status:** The core law — *multiplying two forms unions their zero sets* — is **true and
> trivial** (`ℂ` is a domain). The arithmetic half — Möbius inversion, the divisor function, the
> two-square theorem, the primes — is **true and classical**. The corpus's central syntactic claim,
> that these are *one* algebra, is **false as stated**: `ℕ → ℝ` with `f(0)=0` carries **two
> inequivalent ring structures**, and the prose switches between them without saying so. The
> Hecke/Langlands locus is where the switch is harmless; that, not the ring, is the real content.
> Two headlines are refuted below: "the product of two eigenforms is an eigenform with the product
> eigenvalue" (the June verifier grades it REFUTED, while the same row's note asserts it), and
> "coupling unlocks chaos" (the measured separation is non-monotone and returns to zero). The Lean
> theorem for the core law is not proved: `HSLN.mul`, `HSLN.neurons_mul` and
> `HSLN.EtaQuotient.etaForm_mul_eq_add` are all `sorry`.
> **Evidence grade:** mixed — **PROVEN** core, **NUMERICAL** periphery, two **REFUTED** headlines.
> **Corpus artefacts:** `PythonAndVisualizations/` — `dna_algebra.py`, `eta_compose.py`,
> `lie_derivative.py`, `hsln_two_rings.py`, `hsln_compose_two.py`, `hsln_genus2.py`, `poc_layer.py`,
> `hsln_skill_forge.py`, `coupling_sweep.py`, `hsln_e8_divisor_bridge.py`; figures
> `17_poc_layering.png`,
> `20_genus2_directsum.png`,
> `21_eta_composition.png`,
> `22_coupling_sweep.png`,
> `37_dna_algebra.png`,
> `38_lie_derivative.png`,
> `54_hsln_compose_two.png`,
> `55_hsln_skill_forge.png`,
> `56_hsln_e8_divisor_bridge.png`; `Math-Lean/Math/` —
> `HSLN.lean`, `HSLNBridge.lean`, `HSLNAlgebra.lean`, `HSLNVerify.lean`, `HSLNSerre.lean`,
> `HSLNLanglands.lean`. The June files are archived unchanged in `rmorleysmith/hsln-archive` (Lean in
> `lean.zip`, scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`).
> **Reproduced here:** yes — all ten scripts run in `Fugue/.work/run/`; every number below is
> reprinted from that run or re-derived independently. Lean status re-audited by compiling.

---

## 1. The idea in one paragraph

The corpus calls a **DNA** a finite vector of complex numbers and reads it two ways: as the
`q`-expansion coefficients of a holomorphic `F(τ) = Σ aₙ qⁿ` — a *form*, whose zeros become the
reservoir's attractors — or as the Dirichlet coefficients of `a : ℕ → ℂ` — a *generator*, whose
series `Σ aₙ n^{−s}` is an L-function. On that vector sit two multiplications,
`(f ⋆ g)(n) = Σ_{i+j=n} f(i)g(j)` and `(f ∗ g)(n) = Σ_{de=n} f(d)g(e)`, and the corpus calls both
"composition". They are different operations, induced by two different monoid structures on `ℕ`.
Each is correct and useful. The **form** product makes merging exact, because a product of complex
numbers vanishes iff a factor does, so `zeros(F·G) = zeros(F) ∪ zeros(G)`. The **Dirichlet** product
makes the arithmetic close up, because the multiplicative arithmetic functions form a submonoid of
that ring — the Euler product, Hecke multiplicativity and `ζ_K = ζ·L(·,χ)` are that one closure law
in different settings. Everything the corpus says about composition is one of those two statements,
or the claim that they are the same statement. The first two are theorems; the third is false.

---

## 2. The precise statement

### 2.1 The carrier and the two products

Fix a commutative ring `R` (`ℝ` or `ℂ` in practice). The corpus works on
`𝒜 := { f : ℕ → R : f(0) = 0 }` (mathlib's `ArithmeticFunction R`) and defines

```
Ring A  (Cauchy / q-expansion)   (f ⋆ g)(n) := Σ_{i+j=n} f(i)·g(j)          [i + j = n]
Ring B  (Dirichlet)              (f ∗ g)(n) := Σ_{d·e=n} f(d)·g(e)          [d · e = n]
```

Both sums are finite, both are commutative and associative, both distribute over pointwise `+`. So
`(𝒜,+,⋆)` and `(𝒜,+,∗)` are two different commutative rings on the same set.

**Corrected statement.** `dna_algebra.py` and `math-connections.md` say a DNA is "an arithmetic
function `f : ℕ → ℝ` (the Dirichlet/q-expansion coefficients we train)" and that "our
compose-operations *are* the ring operations". The parenthetical is the error: there is no such thing
as "*the*" Dirichlet-or-`q`-expansion coefficients. A vector of numbers is neither a form nor an
L-function until you choose an index law. Corrected: *on `𝒜` there are two distinct commutative ring
structures, `⋆` and `∗`; multiplication of modular forms is `⋆`; multiplication of Dirichlet series
is `∗`; and every composition claim in the corpus is a claim in one of them.*

### 2.2 The witness, and a better one

The corpus's witness, reproduced exactly (`hsln_two_rings.py`): `(ζ ⋆ ζ)(1) = 0.0` (Cauchy) versus
`(ζ * ζ)(1) = 1.0` (Dirichlet). **Why.** For `⋆` at `n=1` the only decompositions are `(0,1)` and
`(1,0)`, and both contain `f(0)=g(0)=0`; so `(f⋆g)(1) = 0` **for every `f,g ∈ 𝒜`**, not merely for
`ζ`. For `∗`, `(f∗g)(1) = f(1)g(1) = 1`. Hence `0 ≠ 1`. This is
`HSLNBridge.rings_disagree_on_zeta` (`HSLNBridge.lean:73`), from `cauchy_apply_one_eq_zero` plus
`mul_apply_one`. Two caveats the corpus does not state.

**(a)** Since `(f⋆g)(1) = 0` identically, the witness is really "every Ring-A product lies in
`ker χ`, `χ(f) = f(1)`" — a statement about the *carrier*, true with `f = g =` anything. The corpus
reads the same fact in its K-theory section as the Chern character being blind to Ring A.

**(b)** It relies on index-0 padding: `_zeta()` sets `c[0]=0.0` ("index 0 is unused padding"). But the
corpus's *trained* DNAs have `a₀ ≠ 0` (skill C is `−0.03097 − 0.06482i` at index 0), so their carrier
is the unital ring `R[q]/(q^{d+1})` with index 0 the constant term.

**A witness with no padding.** On the natural all-ones sequence:

```
 n     | 1 | 2 | 3 | 5 | 7 | 8
 (ζ⋆ζ) | 0 | 1 | 2 | 4 | 6 | 7      = n − 1 for n ≥ 2   (ζ⋆ζ = q²/(1−q)²)
 (ζ∗ζ) | 1 | 2 | 2 | 2 | 2 | 4      = d(n)
```

First difference at `n = 2` (`1 ≠ 2`), and infinitely often (`n−1 → ∞` versus `d(n) = n^{o(1)}`). All
exact in `float64`. **Also**: composing with `δ = [n=1]` under `⋆` *shifts* `q`-degree
(`np.convolve([0,1,0,…], [0,0,3,−1,0,…])[:6] = [0,0,0,3,−1,0]`), so `DNA_δ = [1,0,0,…]` is
the do-nothing DNA in Ring B and the form `q` in Ring A. The docstrings in `dna_algebra.py` and
`HSLNAlgebra.lean` ("the 'do-nothing' DNA — composing with it changes nothing") are true only under
`∗`.

### 2.3 Why they are different rings

Both are *one* construction. For a monoid `(M,·)` in which each `m` has finitely many ordered
factorisations, the set of functions `M → R` with `(f ⊛ g)(m) := Σ_{ab=m} f(a)g(b)` is a commutative
ring — the completed monoid ring `R[M]` — with identity `δ` at the unit.

* **Ring A** = that construction for `M = (ℕ,+)`, then restricted to `f(0)=0`. In general
  `R[(ℕ,+)] = R[q]`; the corpus's carrier is the ideal `(q) ⊂ R[q]`, a **ring without identity**.
* **Ring B** = that construction for `M = (ℕ_{>0},×)`, which by unique factorisation is the free
  commutative monoid `⊕_p ℕ` on the primes. Identity `δ = [n=1]`.

So the two rings are the *same functor* applied to two *different monoids*, and cannot be relabelled
into each other:

| | Ring A | Ring B |
|---|---|---|
| index monoid | `(ℕ,+)` | `(ℕ_{>0},×) ≅ ⊕_p ℕ` |
| generators | 1 | countably many (the primes) |
| group completion | `ℤ` | `ℚ_{>0}` (divisible) |
| identity in carrier | **none** (ideal `(q)`) | `δ = [n=1]` |
| units | none in carrier | `{f : f(1) ∈ R^×}` |
| grading | by `q`-degree `n` | by the prime-exponent vector |
| distinguished order-2 unit | — | `μ` |

`(ℕ,+)` and `(ℕ_{>0},×)` have non-isomorphic group completions (`ℤ` vs `ℚ_{>0}`) and `M ↦ R[M]` is
functorial, so the rings differ. A consequence the June files do not state: Ring A's image lies in `ker χ` (since
`χ(f) = f(1)` is a Ring-B hom and `(f⋆g)(1) = 0`) — the K-theory dictionary is correct, but it is a
statement about the *padded* carrier `(q) ⊂ R[q]`, not about trained `q`-polynomials.

### 2.4 Zero-union, and why addition fails

**Theorem.** For holomorphic `F, G` on a domain `Ω`: `zeros(F·G) = zeros(F) ∪ zeros(G)`.
**Proof (one line).** `(F·G)(z)=0 ⟺ F(z)G(z)=0 ⟺ F(z)=0 or G(z)=0`, because `ℂ` is a field, so has no
zero divisors. `∎`

The same argument runs pointwise in `Z` for Siegel forms `F,G : ℍ_g → ℂ`, since the target is still
`ℂ`. This is `system-spec.md` §3.4(b)/§4.1(5), and the corpus's `neurons_mul` (`HSLN.lean:382`),
whose own comment calls it a consequence of `ℂ` being a domain.

With multiplicities `ord_z(FG) = ord_z F + ord_z G`, so by the valence formula (Serre, *A Course in
Arithmetic*, Ch. VII §3) the merged model has exactly `(k₁+k₂)/12` weighted zeros against `k₁/12` and
`k₂/12`: **the neuron budget adds, with no loss and no invention.** That is a real, exact model-merge
guarantee, of a kind that gradient-based training does not provide. The cost: zeros that were simple become multiple, so
`|F|² ~ dist^{2m}` and the basins flatten; merging `m` models raises the zero order. Reproduced on
weight-12 `F = E₄³`, `G = E₆²`: `|F·G| = 3.08e-44` at `ρ = e^{2πi/3}` (where `F(ρ)=0`, `G(ρ)≠0`) and
`1.52e-31` at `i` (where `G(i)=0`, `F(i)≠0`).

**Addition does not union.** `F+G` vanishes where `F = −G`; at a zero of `F` with `G ≠ 0` one has
`(F+G)(z) = G(z) ≠ 0`. Verified on the same pair: `|F+G| = 8.303` at `ρ` and `3.085` at `i`, with
grid minimum `0.0296` at `τ ≈ −0.212+0.979i`. The new zeros are the interference pattern of two
complex fields and are not computable from the parents' zero sets. `system-spec.md` §3.4(a) states
this correctly and never overstates it.

### 2.5 The Hecke/Langlands locus: where the two rings agree on the data

**Definition.** `𝓛(R) := { f : ℕ → R : f(1) = 1, f(mn) = f(m)f(n) whenever gcd(m,n) = 1 }` (mathlib
`ArithmeticFunction.IsMultiplicative`; the corpus's `HSLNLanglands.langlandsLocus` is literally the
`Submonoid` of these).

**Theorem.** `𝓛(R)` is closed under `∗`.

**Proof.** `(f∗g)(1) = f(1)g(1) = 1`. For coprime `m,n` every divisor `d | mn` factors uniquely as
`d = d₁d₂` with `d₁ | m`, `d₂ | n`, `gcd(d₁,d₂)=1`. Hence

```
(f∗g)(mn) = Σ_{d₁|m} Σ_{d₂|n} f(d₁d₂)g((m/d₁)(n/d₂)) = Σ f(d₁)f(d₂)g(m/d₁)g(n/d₂) = (f∗g)(m)(f∗g)(n).  ∎
```

This is the classical fact that the Dirichlet product of multiplicative functions is multiplicative
(Apostol, *Introduction to Analytic Number Theory*, Ch. 2; mathlib `IsMultiplicative.mul`), and it is
machine-checked in `HSLNLanglands.lean` (which compiles clean here).

**Why this is the real content behind "everything composes".** A multiplicative function is determined
by its prime-power values, and the convolution is computed prime-power by prime-power:
`(f∗g)(p^a) = Σ_{j=0}^{a} f(p^j)g(p^{a−j})`. So "compose two models" reduces *locally* to "multiply
their Euler factors". That one sentence is the Euler product, Hecke multiplicativity
`a_{mn} = a_m a_n`, the Dedekind factorisation `ζ_K = ζ·L(·,χ_D)`, the Rankin–Selberg product, and the
closure carrying BSD- and Langlands-flavoured statements to products. Fuzzed here: three random pairs
of multiplicative functions (independent random prime-power values) all had multiplicative Dirichlet
products on `n ≤ 400` to `1e-9`.

**What closure does *not* say — the most consequential point in this section.** Closure of `𝓛` under
`∗` is not closure of Hecke *eigenforms* under *form multiplication*.

* `results.json` row `compose.hecke.mult` is graded **REFUTED**, correctly: `a_p(Δ·E₄) = 216` while
  `a_p(Δ)·a_p(E₄) = −51840` at `p = 2`.
* The same row's `notes` then asserts the opposite — *"the product of two eigenforms is again an
  eigenform, eigenvalue = product of eigenvalues — this is exactly the closure the corpus calls the
  'Hecke locus'"*. **The note is false.** With exact integer arithmetic on `Δ = q∏(1−qⁿ)²⁴`: `Δ²` has
  `a₁ = 0`, `a₂ = 1`, `a₃ = −48`, `a₆ = 143820`, while `a₂a₃ = −48 ≠ 143820` — `Δ²` is not a
  normalised eigenform at all. (`Δ·E₄` *is* one, only because `dim S₁₆(SL₂(ℤ)) = 1`, an accident, and
  even then `a₂ = 216 ≠ −51840`.) The Hecke-equivariant product is the Rankin–Cohen bracket, not `⋆`.

### 2.6 Eta quotients: composition is linear, and almost content-free

For `r = (r_d)_{d|N} ∈ ℤ^{divisors(N)}`, the **eta quotient** is `f_r(τ) = ∏_{d|N} η(dτ)^{r_d}`,
`η(τ) = q^{1/24}∏_{n≥1}(1−qⁿ)`.

**Fact 1 (product law — trivial).** `f_r·f_s = f_{r+s}`, and `weight(f_r) = ½Σ_d r_d` is additive.
Proof: `η^a·η^b = η^{a+b}`, valid because **`η` is non-vanishing on `ℍ`** (both `q^{1/24}` and each
`1−qⁿ` are nonzero for `|q|<1`), so no branch bookkeeping is needed — which is why the corpus labels
its Lean version "pointwise it is immediate". Reproduced (`eta_compose.py`, `N = 12`,
`r = [2,1,0,−2,−1,−3]`, `s = [−3,−3,−2,2,1,3]`, 60 random `τ` with `Im τ ∈ [0.15,1.5]`): max relative
residual `6.13e-16`; `weight(r) = −1.5`, `weight(s) = −1.0`, `weight(r+s) = −2.5` (adds).

**Fact 2 (the substantive content).** Whether `f_r` is a holomorphic modular form on `Γ₀(N)` is a
**linear** condition on `r`: Newman's congruences `Σ d·r_d ≡ 0 (mod 24)` and
`Σ (N/d)·r_d ≡ 0 (mod 24)`, plus Ligozat's cusp orders
`ord_c(f_r) = (N/24) Σ_d gcd(c,d)² r_d / (gcd(c,N/c)·c·d) ≥ 0` at each cusp `c | N`. (Newman
1957/1959; Ligozat, *Courbes modulaires de genre 1*, 1975; modern statement in Rouse–Webb, Adv. Math.
**272** (2015).) All homogeneous-linear, so the admissible set is an additive submonoid of
`ℤ^{divisors(N)}`. Reproduced at `N = 11`, box `[−12,12]²`: **27** congruence points, of which **8**
admissible — `{(−1,11), (2,2), (4,4), (6,6), (8,8), (10,10), (11,−1), (12,12)}` — and I checked closure
directly: **0 failures** over all admissible pairs, and the congruence set alone is closed (27×27
checks). The corpus's exhibited `(2,2)+(2,2) = (4,4)` checks out, with `η²(τ)η²(11τ)` the weight-2
newform `11.2.a.a` and order exactly `1.0` at both cusps of `X₀(11)`.

Two precisions. **(i)** `math-connections.md` §1 calls this "a convex feasibility check"; the
constraints are congruences **mod 24**, whose solution set is a *lattice*, not a convex body — the
right tool is integer linear programming, which the same document says elsewhere. **(ii)** The
numerical `is_admissible` requires weight to be an integer `≥ 1`, excluding `r = 0`; the Lean
`admissibleMonoid` imposes no weight condition, so it contains `0` and really is a monoid. The formal
and numerical versions are different objects.

**Scope limit (the corpus states it plainly):** since `η` is non-vanishing on `ℍ`, *every* zero of an
eta quotient sits at a cusp. An eta-quotient DNA **cannot place a neuron at a chosen interior point** —
`E₄`'s zero at `ρ` is unreachable. That rules out this family for the architecture as stated; the eta cluster buys a
linear, checkable composition algebra at the price of pushing every attractor to the boundary. The
printed evidence also needs a different reading: on `Re τ = 0.13`, `Im τ ∈ [0.30, 2.3]`, `|f|` is monotone
decreasing with minimum `5.295e-07` *at the cusp end* (`Im τ = 2.3`) and `|f| = 0.125` at `Im τ = 0.30`.
That minimum is pure `q`-decay (leading exponent `q^{13/24}`), so the line
`[zeros] eta-quotient min|f| on interior slice = 5.295e-07 (no interior zero)` presents the smallest
number found as if it were a margin; the real evidence is monotonicity plus the product formula. The
`E₄` control in the same panel is genuine: printed minimum `2.355e-03` on a 400-point slice
(`h = 5.0e-3`), `8.44e-06` on a fine grid (`h = 3.3e-5`) at `Im τ = 0.866024… = √3/2` — a real interior
zero approached linearly.

### 2.7 The Lie derivative: one construction, two gradings, one tautology

Two very different things share this name in `lie_derivative.py` and `math-connections.md` §"The Lie
derivative".

**(i) The tautology.** For `E = |F|²` and `Ż = −∇E`, `L_X E = dE/dt = ∇E·(−∇E) = −|∇E|² ≤ 0`. True — of
*every* gradient flow on *every* function. The corpus's verifier agrees: `VERIFIED` with the note
*"TRUE but tautological — it is a property of any gradient flow, not of the modular structure."*
Reproduced: `max rel. error 2.11e-05` against `np.gradient`, `E: 3.505 → 4.02e-05`, monotone `True`.
Nothing modular enters.

**(ii) The ring is closed under its own Euler derivation.** `D := q d/dq`, i.e. `a_n ↦ n a_n`.
Ramanujan's differential relations (Ramanujan, *On certain arithmetical functions*, Trans. Camb. Phil.
Soc. **22** (1916), 159–184): `D E₂ = (E₂²−E₄)/12`, `D E₄ = (E₂E₄−E₆)/3`, `D E₆ = (E₂E₆−E₄²)/2`.
Reproduced with residuals **exactly `0.0e+00`** — not "small": coefficients to order 12 are integers
below `2^53`, so this is exact integer arithmetic in floating point. Fig 38 panel C is therefore a
genuine exact verification of a theorem about the *quasimodular* ring `ℂ[E₂,E₄,E₆]` (Kaneko–Zagier,
*A generalized Jacobi theta function and quasimodular forms*, 1995). `E₂` is not a modular form; the
corpus notes this in a parenthetical but not in the figure title.

**(iii) The Serre derivative raises weight.** `ϑ_k := D − (k/12)E₂` maps `M_k → M_{k+2}` (Serre,
*Cours d'arithmétique*, Ch. VII). Checked to `0.0e+00`: `ϑE₄ = −E₆/3` (4→6), `ϑE₆ = −E₄²/2` (6→8) — one
line from (ii): `DE₄ − (4/12)E₂E₄ = (E₂E₄−E₆)/3 − E₂E₄/3 = −E₆/3`.

**(iv) The same construction in the Dirichlet basis.** `D f(n) := f(n)·log n` is a **derivation of
Ring B**, since `log(de) = log d + log e`. Reproduced: max residual `7.1e-15` over random `f,g`
(mathlib: `HSLNAlgebra.leibniz_log`). Applied to the generator and normalised by `ζ⁻¹ = μ`:
`D(ζ) = log` and `log ∗ μ = Λ`, i.e. `−ζ'/ζ = Λ`. Reproduced: `D(ζ)==log : True`,
`log*μ==Λ : True`, `Λ(2)=Λ(8)=log 2`, `Λ(12)=0`; the verifier measures `max|log*μ − Λ| = 2.22e-15`.

**A precision not stated in the June files: `D` is a derivation of *both* rings, for one reason.** For Ring A the
index law `i+j=n` is already additive, so `D(f⋆g)(n) = n(f⋆g)(n) = Σ_{i+j=n}(i+j)f(i)g(j)`. For Ring B
the index law `de=n` becomes additive under `log`. Reproduced: Ring A Leibniz residual `2.7e-12`,
Ring B `7.1e-15`. So the slogan "one Lie derivative, two bases" is **true and precise**: for any monoid
homomorphism `φ : M → (ℝ,+)` from the grading monoid, `D_φ(f)(m) := φ(m)f(m)` is a derivation of
`R[M]`; Ring A has `M = (ℕ,+)`, `φ = id`; Ring B has `M = (ℕ_{>0},×)`, `φ = log` — the same functor on
the same two monoids as §2.3. The next step in `math-connections.md` is **false** as stated: *"So the model computes its own
derivative and stays in the space."* The identity shows the *ring* is `D`-stable. No script ever
evaluates `D` on a trained DNA, and trained DNAs are arbitrary truncated `q`-polynomials.

### 2.8 The "gravity" coupling: a theorem, and a refuted numerical claim

Genus-2 state `Z = [[τ₁,z],[z,τ₂]] ∈ ℍ₂`, `Y = Im Z = [[y₁,w],[w,y₂]]`, `w = Im z`. The coupling
enters through `K = [[y₁², κy₁y₂],[κy₁y₂, y₂²]]` with `κ := w²/(y₁y₂)`.

**PSD threshold.** `det K = y₁²y₂²(1−κ²)` with positive diagonal, so `K ≽ 0 ⟺ |κ| ≤ 1` and
`K ≻ 0 ⟺ |κ| < 1` (the verifier checks 25 values, `VERIFIED`).

**The corpus's `K` is not "a model of the Siegel metric" — it *is* the Siegel metric up to a
constant.** This corrects `results.json`, which says the chaos demo used *"a MODEL coupling, not the
Siegel metric"*. The Bergman/Siegel metric on `ℍ_g` is `ds² = tr(Y^{-1}dZ Y^{-1}dZ̄)`, equivalently
`ω = (i/2)∂∂̄Φ` with `Φ = −log det Y`. In the three complex coordinates `(τ₁,τ₂,z)` on `ℍ₂`, with
`D := det Y = y₁y₂ − w²`, calculus gives

```
g = (1/4D²)·[[ y₂² , w² , −2wy₂ ], [ w² , y₁² , −2wy₁ ], [ −2wy₂ , −2wy₁ , 2(y₁y₂+w²) ]]
```

confirmed against central differences of `Φ` on four test points (`|g − g_analytic|_max` between
`2.3e-05` and `4.5e-02`, i.e. finite-difference error). Inverting **exactly** (cofactor expansion,
verified numerically with `np.linalg.inv`): `(g^{-1})_{11} = 4y₁²`, `(g^{-1})_{12} = 4w²`,
`(g^{-1})_{22} = 4y₂²`. So the top-left `2×2` block of the **inverse** Siegel metric is `4K`. The code's
`y₁²`, `y₂²` and `κy₁y₂` entries are exactly the Riemannian-gradient operator `g^{ij}∂_j` restricted to
the `(τ₁,τ₂)` coordinates; applying `K` as a scalar inside each `(x,y)` pair is also right, because a
Hermitian block metric is conformally Euclidean in real coordinates. And the threshold `|κ| ≤ 1` is
*equivalent* to `Z ∈ ℍ₂`, since `κ = w²/(y₁y₂) < 1 ⟺ det Im Z > 0`. "Gravity = the off-diagonal of the
period matrix" is therefore not a metaphor.

**Theorem (equilibria preserved).** If `K(x)` is positive definite for every `x`, then
`Ż = −K(x)∇V(x)` and `Ż = −∇V(x)` have the same equilibria. Proof: `Kv = 0` with `v ≠ 0` gives
`vᵀKv > 0` by positive-definiteness but `vᵀKv = vᵀ0 = 0`; conversely `K·0 = 0`. `∎` In particular a
*simultaneous zero* of two sectors — where both gradients vanish — stays an equilibrium for every `κ`.
This is `HSLN.gravity_preserves_equilibria` (`HSLN.lean:558`, reproduced as `HSLNVerify.lean:114`), and
it **compiles sorry-free in this workspace**. The Lean hypothesis is `PosDef`: *strict*. Three
corrections.

**(1)** PSD is not needed for the equilibrium claim, only linearity of `K` in `∇`; what PSD buys is
that the flow is still a Riemannian gradient flow, hence still dissipative:
`d/dt V = −∇Vᵀ K ∇V ≤ 0`. That is the precise sense of "warps the route, not the destination", and the
verifier's *"a PSD metric cannot move a vanishing gradient"* reaches the right conclusion, but the operative
reason is linearity, not PSD. **(2)** The prose says PSD (`|κ| ≤ 1`) where the proof needs PD (`|κ| < 1`): at `|κ| = 1` the
metric has a kernel and extra equilibria become possible. The working range `κ ∈ [0,0.95]` is strictly
inside, so the experiment is unaffected. **(3)** The experiment's "common zero" is approximate:
measured here `|F_A(A_target)| = 2.17e-04`, `|∇E_A| = 1.11e-04`, `|F_B(B_target)| = 2.12e-04`,
`|∇E_B| = 1.31e-04`, and `|F_A(B_target)| = 5.0e-02`. The exact theorem explains the observed
`0.001–0.005` routing errors, but it is applied to an object that is only a common zero to `~2e-04`.

**The refuted claim.** `coupling_sweep.py`'s docstring promises *"C. sensitive dependence vs kappa --
with a periodic drive, coupling unlocks chaos"*; the figure title reads *"coupling unlocks chaos
(sensitive dependence)"*; `math-connections.md` §6 says *"At κ=0.85 the coordinates couple (3-D
extended phase space), and nearby trajectories stay separated (sensitive dependence)."* Reproduced
first at face value, then measured over the whole time course and across `κ`:

```
[chaos] final separation   kappa=0: 0.00e+00   kappa=0.85: 2.55e-06
kappa=0.85 separation curve:  t=0  1.12e-07 | t=2.5  7.51e-04 | t=10  3.18e-03
                             t=25 5.84e-11 | t=40   5.45e-05 | t=60  2.55e-06
 kappa |   max sep  |  final sep | frac(t) sep>1e-4 | n(t) sep<1e-8
  0.30 | 2.43e-05  | 0.000e+00  |     0.000       | 11948
  0.50 | 7.20e-03  | 0.000e+00  |     0.020       | 11522
  0.70 | 5.27e-02  | 0.000e+00  |     0.309       |  8081
  0.85 | 6.02e-02  | 2.55e-06  |     0.610       |  1821
  0.90 | 4.74e-01  | 0.000e+00  |     0.358       |  7437
  0.99 | 8.91e-02  | 0.000e+00  |     0.129       | 10272
```

A final separation of `2.55e-06` from an initial `1e-7`, in a domain of diameter `≈1`, is a factor of
25 — and it is **not monotone**: the curve rises to `3.2e-03`, collapses to `5.8e-11`, and comes back.
The figure's own panel C shows this: the red `log₁₀` separation oscillates between about `−3` and
`−17`, repeatedly returning to numerical zero. Sensitive dependence is not the value of a separation at
one final time; it is the asymptotic growth rate `λ = lim (1/t)log(‖δ(t)‖/‖δ(0)‖) > 0`, and it implies
that once two orbits separate they stay separated at the scale of the attractor. Here the separation
**recollapses to `≤1e-11`** at most `κ` and to exactly `0.000e+00` at `κ = 0, 0.3, 0.7, 0.9, 0.95,
0.99`. Trajectories that re-synchronise exactly are not on a strange attractor; the data are consistent
with **transient stretching followed by exact re-synchronisation**. Part of the recollapse is
mechanical: the rollouts clip to `[0.02,0.98]`, and at `κ = 0.90` the first clip hit is at `t = 1.615`;
clipping maps distinct states to the same state, so it is a synchronising device that confounds the
statistic.

What survives is only the **dimension count**: at `κ = 0` the driven system is
`ẋ₁ = −αy₀²∂_x log E(x₁) + amp·sin(ωt)` with `x₂` autonomous 1-D, i.e. a `T`-periodically forced
first-order flow, whose return map is a circle map — zero topological entropy, hence no chaos (the
Poincaré–Bendixson statement the corpus invokes, applied to the `(x₁,θ)` annulus). Coupling makes the
extended phase space 3-D, so chaos becomes *possible*. This is necessary for
chaos, not sufficient, and not evidence of it. `math-connections.md` does note that no Lyapunov
exponent was measured; the note comes after the conclusion is stated.

## 3. Where it comes from

| Claim | Standing on | Grade |
|---|---|---|
| `(𝒜,+,∗)` is a commutative ring | convolution algebra of `(ℕ_{>0},×)`; mathlib `CommRing (ArithmeticFunction R)` | **PROVEN** |
| `(𝒜,+,⋆)` is a commutative rng, `⋆ ≠ ∗` | same functor on `(ℕ,+)`, restricted to the ideal `(q)` | **PROVEN** |
| `ζ ∗ μ = δ`; units of Ring B are `{f : f(1) ∈ R^×}` | Möbius inversion (Möbius 1832; Apostol Ch. 2; mathlib `coe_zeta_mul_coe_moebius`) | **PROVEN** |
| `ζ ∗ ζ = d(n)`; `ζ ∗ χ₋₄ = r₂/4`; `ζ·L(s,χ₋₄) = ζ_{ℚ(i)}` | classical divisor count; **Jacobi two-square theorem** (1829; Hardy–Wright §16.9); Dedekind factorisation for abelian `K` (Neukirch Ch. VII) | **PROVEN** |
| `log ∗ μ = Λ` (`−ζ'/ζ = Λ`); `Σσ_k(n)n^{−s} = ζ(s)ζ(s−k)` | log-derivation of the Dirichlet ring (Apostol Ch. 2, 11) | **PROVEN** |
| `𝓛` closed under `∗` | `IsMultiplicative.mul`; `HSLNLanglands.langlands_product_mem` | **PROVEN** |
| `zeros(FG) = zeros(F) ∪ zeros(G)`, multiplicities add; `zeros(F+G)` differs | `ℂ` is a domain; `(F+G)(z) = G(z)` at a zero of `F` | **PROVEN** (trivial) |
| `Θ^{(g)}_{L⊕M} = Θ^{(g)}_L·Θ^{(g)}_M` at every genus | `Gram(v_i,v_j) = Gram'(v'_i,v'_j) + Gram''(v''_i,v''_j)`, `tr` linear | **PROVEN** |
| `Θ_{E8} = E₄`; `#E8(norm 2n) = 240σ₃(n)`; `D16⁺` shares `Θ_{E8⊥E8}` | `dim M₄ = 1` + Poisson summation (Conway–Sloane Ch. 4 §7); Witt 1941 (Ch. 16) | **PROVEN** |
| `f_r·f_s = f_{r+s}`; `η ≠ 0` on `ℍ` | `η` product formula | **PROVEN** (trivial) |
| admissibility of `f_r` is linear in `r` | Newman 1957/1959; Ligozat 1975; Rouse–Webb 2015 | **PROVEN** |
| `D E₂, D E₄, D E₆` closed forms; `ϑ_k : M_k → M_{k+2}` | Ramanujan's differential relations (1916); Serre derivative (Serre, *Cours d'arithmétique* Ch. VII) | **PROVEN** |
| `g^{-1}`'s `(τ₁,τ₂)` block is `4K`; `K ≽ 0 ⟺ \|κ\| ≤ 1` | Bergman metric `∂∂̄(−log det Y)`; exact cofactor inversion | **PROVEN** |
| coupled and bare flows share equilibria | `PosDef` ⇒ trivial kernel; `HSLN.gravity_preserves_equilibria` | **PROVEN** |
| `σ₃ = ζ ∗ Id₃`, **not** `ζ^{∗4}` | `Σσ_k n^{−s} = ζ(s)ζ(s−k)`; `σ₃(2)=9 ≠ 4 = d₄(2)` | **PROVEN** |

Everything in the arithmetic half is one classical theory: the Dirichlet ring and its multiplicative
submonoid. The precise answer to "what is really going on" is that the June files arrived at the ring of
arithmetic functions, wrote down its standard named elements, and observed that they generate real
number theory. They do. The material is classical (Apostol Ch. 2), and it is correctly assembled here.

---

## 4. What the code actually does

All ten scripts run in `Fugue/.work/run/` (CPython 3.14.4, numpy 2.5.4, jax 0.12.0 CPU, mpmath
1.4.1). Numbers are from those runs.

**`dna_algebra.py` — the named alphabet (fig 37).** `M = 80` coefficients. `dirichlet_mul` is the
double loop `c[d*e] += a[d]*b[e]`; `dirichlet_inv` is the recursive inversion needing `a[1] ≠ 0`; the
alphabet is `δ`, `ζ` (all ones, `c[0]=0`), `μ` by sieve, `Λ` by prime-power enumeration,
`χ₄ ∈ {+1,0,−1,0}`, `log`. `compose_L` *builds* `L(s,χ₄)` as the Dirichlet product of per-prime
factors `Σ_k χ(p)^k p^{−ks}` starting from `δ`. Printed:

```
[1] group inverse: ζ⁻¹ == μ : True;  ζ * μ == δ : True     [2] ζ * ζ == d(n) : True
[3] L(s,χ₄) = ∏ₚ Euler == χ(n) : True;  ζ * χ == r₂/4 : True;  L(1,χ₄) ≈ 0.785398 (π/4)
[4] Lie derivative: D(ζ) == log : True;  log * μ == Λ (the primes) : True
```

Panel C draws the Gaussian-integer circles for `n ∈ {5,25,65,50,45}` labelled `r₂ = 4(ζ∗χ)(n)`.
Independently re-derived here: `max|σ₃ − ζ∗Id₃| = 0` exactly on `n ≤ 300`, `(ζ∗μ)(n) = [n=1]` on
`n ≤ 2000`, `4(ζ∗χ₄)(n) = r₂(n)` on `n ≤ 4000`. *Notation hazard:* the docstring writes
`DNA_δ = [1,0,0,…]` while `_delta()` implements `c[1] = 1`; those are different vectors (§2.2), and
`modular.qpoly` treats index 0 as the constant term.

**`eta_compose.py` — the composition linearizer (fig 21).** `eta(tau, terms=300)` iterates
`q^{1/24}∏(1−qⁿ)` (accurate for `Im τ ≳ 0.1`; samples live in `[0.15,1.5]`). `newman_residues` returns
the two sums mod 24; `cusp_orders` implements Ligozat verbatim; `is_admissible` conjoins both
congruences, `ord_c ≥ 0` at every cusp, and "weight a positive integer". Output quoted in §2.6.

**`lie_derivative.py` — two faces of `q d/dq` (fig 38).** Part 1: `F(z) = (z−z₁)(z−z₂)`,
`z₁ = −0.60+0.85i`, `z₂ = 0.70+0.55i`, `E = |F|²`, analytic gradient `∇E = (2Re w, −2Im w)`,
`w = conj(F)F'`; RK4, `dt = 2e-4`, 6000 steps from `z₀ = −1.15+1.55i`; `dE/dt` by `np.gradient`,
identity checked on the interior slice only. Part 2: `E₂,E₄,E₆` truncated to `q¹²`, `qmul` a truncated
`np.convolve`, `D(a) = a·n`. The `assert` demands Ramanujan residuals `< 1e-6` and flow residual
`< 5e-3`; the flow figure is the binding one (`2.11e-05`). The identities are truncation-independent
mathematics, but the figure's "residual exactly 0" is a statement about degree-12 coefficients.

**`hsln_two_rings.py` — where the two rings are named.** `p₀ = 2029073`, `q₀ = 1265981`,
`N₀ = 2568767865613` (42 bits); `pos(x) = frac(log₂ x)`; the atom at `α` is the affine DNA
`[−q_pos, 1]`.

```
pos(p0)+pos(q0) mod 1 = 0.224214 = pos(N0)   match: True
α=0.623266 partner=0.600948  α+partner ≡ pos(N0) ✓   2^(k+α)=1615182 divides N0? False
(δ_p0 * δ_q0)(N0) = 1.0   (δ_p0 * δ_q0)(N0+2) = 0.0   d(N0) = (ζ*ζ)(N0) = 4
(ζ ⋆ ζ)(1) = 0.0   (ζ * ζ)(1) = 1.0
```

The script's own closing verdict is accurate, and it contradicts the title: *"Additive (Ring A) or
multiplicative (Hecke `a_N = a_p·a_q`, Ring B), it is the SAME 2-from-1 collapse. Composition builds;
it cannot un-build."* The title ("why one *builds* while the other *factors*") does not match that result. Its
claim *"Recovery is a one-way bijection: GIVEN pos(p), p = round(2^(k+pos(p)))"* also needs `k`
supplied by hand, so `pos` is not a bijection — it is a homomorphism to `ℝ/ℤ` with infinite fibres.

**`hsln_compose_two.py` — jointly train two models whose product spikes at `pos(N)` (fig 54).** `N` is
a 1024-bit (308-digit) semiprime written as a decimal literal; `mp.mp.dps = 1100`. Two free DNAs are
optimised jointly by Adam (5000 steps, `lr = 0.01`, loss `Σ(spike_map(conv(a,b)) − target)² +
1e-4‖p‖²`) so only the *composition* is constrained; then a full sweep over positions `α` and shelves
`k ∈ [462,1023]` with `±8` wiggle.

```
N is 1024-bit;  pos(N) = 0.8909051765        Target: one-hot at probe 10 (0.8600)
 (dg_a,dg_b) | loss   | on-lane a/b/comp | pair-sum hits | factor pairs
  (2,2)      | 0.3298 |     0/0/0        |       0       |      0
  (4,4)      | 0.0046 |     0/1/1        |       3       |      0
  (3,6)      | 0.0047 |     1/0/1        |       2       |      0
```

**It does not compose into `N` and does not factor `N`.** Loss reaches `0.0046`, and every sweep finds
**zero** factors. Two further points: the training target is the quantised probe `0.86` while
`pos(N) = 0.8909051765`, so the figure title "spikes at pos(N)" is off by `0.031` in lane position; and
the "pair-sum hits" compare *off-lane* roots against `pos(N)` and are coincidences.

**`hsln_genus2.py` — direct sum (fig 20).** Genus-1 tensor (shared `τ`): errors `0.275` / `0.241`;
genus-2 direct sum (`τ₁,τ₂`): `0.000` / `0.000`. The reason is exact: on the diagonal slice
`|F|² = |F_A(τ₁)|²|F_B(τ₂)|²` depends on disjoint variables, so `∇` is block-diagonal and each
coordinate runs exactly its parent's trajectory. But note what is evaluated: `run()` calls
`g1.rollout(dnaA, A_IN)` and `g1.rollout(dnaB, B_IN)` *separately* — two genus-1 integrations; no
`Sp(4,ℤ)` form is ever evaluated. So fig 20 shows that *if* you give each task its own coordinate *then*
the flow is the same two genus-1 flows. The arithmetic that makes this true,
`Θ^{(g)}_{L⊕M} = Θ^{(g)}_L Θ^{(g)}_M`, does hold at every genus (proved in §3), but the code tests only
the resulting decoupling.

**`poc_layer.py` — tensoring doubles the neurons (fig 17).** Four targets at
`0.18+0.12i, 0.42+0.17i, 0.62+0.14i, 0.83+0.10i`. A "sector" is a *monic* degree-2 polynomial
`q²+a₁q+a₀` from 4 reals; a "layer" is `np.convolve(sector, sector)` (degree 4). Loss
`Σ_i|F(t_i)|² + 1e-4‖p‖²`, Adam, 800 steps, `lr = 0.02`. Residuals: single
`[0.217 0.167 0.183 0.219]` (covers `0/4`), layered `[0. 0. 0. 0.]` (covers `4/4`). **This is a
dimension count, not a statement about `⊗`.** Four complex equations `F(t_i)=0` are 8 real
constraints; a monic degree-2 polynomial has 2 complex = 4 real parameters (hence `~0.2` residuals), a
monic degree-4 one has 4 complex = 8 real parameters (hence exact zeros). Tensoring is one way to
double the degree — and the way that preserves modularity if the factors are modular — but the script
tests no modularity and any degree-4 ansatz would do the same.

**`hsln_skill_forge.py` — edit a model with arithmetic (fig 55).** Three atoms trained *independently*
at `0.22, 0.50, 0.78` (`dg = 4`, 2500 Adam steps, one-hot targets on the probe grid), then merged by
`hsln.tensor` (two `np.convolve`s, no training) and erased by `np.polydiv` on reversed coefficients.

```
merged on-lane neurons: ['0.219', '0.459', '0.780']   expected: ['0.220', '0.460', '0.780']
deconvolution remainder norm : 6.96e-18      ‖(F/F_B) − (F_A·F_C)‖∞ : 4.48e-16
after erase on-lane neurons  : ['0.219', '0.780']
```

Best-executed script in the cluster, and the arithmetic is real. Scope limits: **(i)** the atoms are
arbitrary degree-3 `q`-polynomials, so this validates `zeros(FG) = zeros(F) ∪ zeros(G)` (true for
arbitrary holomorphic `F,G`) and nothing modular; **(ii)** erase works only because
`F_merged = F_A F_B F_C` exactly and `F_B` was kept — division amplifies error if `F_B`'s leading
coefficient is small; **(iii)** the docstring's *"No standard network can do either: merging needs
retraining and interferes; removing a learned concept cleanly is essentially impossible"* by gradient-based
training is an ML claim with no experiment behind it here; **(iv) the script is not reproducible
run-to-run** — the training seed is `hash(name) & 0xFFFF` and CPython salts string hashes per process,
so `PYTHONHASHSEED=1` and `PYTHONHASHSEED=2` give skill-A losses `5.239` and `3.727` (neuron positions
stay on-probe because the targets are snapped to the grid).

**`coupling_sweep.py` — gravity as the off-diagonal (fig 22).** Two sectors from
`hsln_dyn.train_routing`, then a coupled rollout with `vx₁ = −(y₁²gA₀ + off·gB₀)`,
`vy₁ = −(y₁²gA₁ + off·gB₁)`, `vx₂ = −(off·gA₀ + y₂²gB₀)`, `vy₂ = −(off·gA₁ + y₂²gB₁)`,
`off = κy₁y₂`, normalised to unit speed and clipped to `x ∈ [0.02,0.98]`, `y ∈ [0.06,0.95]`, 320 steps
of `dt = 0.02`. Panel A sweeps `κ ∈ linspace(0,0.95,13)`; panel B overlays three trajectories; panel C
drives a four-well landscape (zeros at `x ∈ {0.2,0.4,0.6,0.8}`, `y = 0.42`, normalised so
`|F| ~ O(1)`) with `amp·sin(ωt)` on `vx₁` only (`T = 12000`, `dt = 0.005`, `α = 0.3`, `amp = 1`,
`ω = 0.9`) and compares rollouts from `x₀` and `x₀ + (1e-7, 0)`. Panel A: routing error `0.001–0.006`
for every `κ ≤ 0.95`, ten times inside the script's own `0.05` tolerance — exactly what the
equilibrium theorem predicts. Panel B's trajectories visibly bend. Panel C is the contested panel
(§2.8).

**`hsln_e8_divisor_bridge.py` — the divisor function as the on-ramp (fig 56).** `e8_counts` enumerates
`ℤ⁸ ∩ [−2,2]⁸` with `Σxᵢ` even, plus the half-integer shell `h ∈ {±1,±3}⁸` with `4 | Σhᵢ`, and
histograms by squared norm. `240σ₃(n)` vs counted E8 vectors: `(n=1: 240, 240)`, `(2: 2160, 2160)`,
`(3: 6720, 6720)`, all matching. `E₄²` has 480 norm-2 vectors; `+16` Cartan `= 496 = dim(E8×E8)`.
`Σσ₃(n)n^{−s} = ζ(s)ζ(s−3)`: `Δ = 0.000271` at `s=5` (4000 terms, truncation `O(N^{4−s})`) and
`Δ = 3.38e-8` at `s=6`. Enumerating E8 lattice points and matching them to `240σ₃(n)` is the single
most convincing computation in the cluster. The script's own caveat matters: `D16⁺` has the **same**
theta series and is a *different* lattice, so `Θ` does not determine the lattice and "the DNA
identifies the model" fails even here. **One correction:** the docstring writes `σ₃ = ζ ∗ Id₃`
(correct), while `dna.py` / `results.json` `ring.divisor.identity` asserts `σ₃ = (ζ∗ζ∗ζ∗ζ)(n)`, graded
**REFUTED** at `(n=2: 9 vs 4)`. Confirmed exactly here: `max|σ₃ − ζ∗Id₃| = 0` and
`σ₃(2)=9 ≠ 4 = d₄(2)` on `n ≤ 300`. The E8 bridge needs the *shifted* form
`Σσ_k(n)n^{−s} = ζ(s)ζ(s−k)`.

---

## 5. What is verified and what is not

### Established (theorem, or exactly re-derived here)

1. **Two inequivalent ring structures** on the same carrier, as the convolution algebras of `(ℕ,+)`
   and `(ℕ_{>0},×)`; `(ζ⋆ζ)(1) = 0 ≠ 1 = (ζ∗ζ)(1)`; with no padding, `(ζ⋆ζ)(2) = 1 ≠ 2 = (ζ∗ζ)(2)`.
   Ring A has no identity in the carrier; Ring B does.
2. **Zero-union** with multiplicities adding — `|FG| = 3.1e-44` at `ρ`, `1.5e-31` at `i` for
   `F = E₄³, G = E₆²`. **Addition does not union**: `|F+G| = 8.30` at `ρ`, `3.09` at `i`.
3. **Closure of `𝓛` under `∗`**, re-derived and fuzzed.
4. **Möbius inversion, divisor count, Jacobi two-square, von Mangoldt** — all to machine precision;
   `results.json` agrees (`ring.mobius.inverse`, `ring.zeta.squared`, `ring.two.squares`,
   `ring.lie.derivative` all `VERIFIED`).
5. **`σ₃ = ζ∗Id₃` and `σ₃ ≠ ζ^{∗4}`; `Σσ₃(n)n^{−s} = ζ(s)ζ(s−3)`; `#E8(norm 2n) = 240σ₃(n)`** by
   lattice enumeration for `n = 1,2,3`.
6. **`Θ^{(g)}_{L⊕M} = Θ^{(g)}_L Θ^{(g)}_M` at every genus**, proved by additivity of Gram matrices — so
   `results.json`'s "holds at every genus" is right although the harness tested genus 1.
7. **Eta product law** (residual `6.13e-16`) and **linearity of admissibility**, with 8 admissible
   vectors at `N=11` in the box and zero closure failures.
8. **Ramanujan `D`-identities and the Serre derivative**, residuals identically `0.0e+00`.
9. **`D` is a derivation of both rings** (Ring A `2.7e-12`, Ring B `7.1e-15`).
10. **The inverse Siegel metric's `(τ₁,τ₂)` block is `4K`** with `κ = w²/(y₁y₂)`, by cofactor expansion
    and numerical inversion; `K ≽ 0 ⟺ |κ| ≤ 1 ⟺ det Im Z ≥ 0`.
11. **`K` positive definite ⇒ coupled and bare gradient flows share equilibria** —
    `HSLN.gravity_preserves_equilibria`, compiling clean here.
12. **Eta-quotient zero-free interior** (`|f|` monotone in `Im τ`), against `E₄`'s genuine interior zero
    at `√3/2` (`8.44e-06` on a fine grid).

### Numerical only (measurement, with tolerance and regime)

1. **Skill Forge** merge/erase: neurons `['0.219','0.459','0.780']` vs `['0.220','0.460','0.780']`;
   remainder `6.96e-18`; `‖F/F_B − F_A F_C‖∞ = 4.48e-16`. Regime: three degree-3 non-modular
   `q`-polynomials, 12-probe grid. **Not reproducible run-to-run** (salted `hash` seed).
2. **Layer coverage** (fig 17): `0/4` vs `4/4`, residuals `~0.2` vs `0`. Regime: four targets, monic
   degree ≤ 4, unconstrained.
3. **Genus-2 direct sum** (fig 20): `0.275/0.241 → 0.000/0.000`. Regime: two coordinates, one trained
   sector each, `hsln_dyn`'s clipped unit-speed flow.
4. **Routing robustness** (fig 22A): `0.001–0.005` for `κ ∈ [0,0.95]` against a `0.05` tolerance — but
   the "common zero" is only accurate to `|F| ~ 2.1e-04`. **Route bending** (22B): the path changes
   visibly with `κ`, the endpoint does not.
5. **"Sensitive dependence"** (fig 22C): final separation `2.55e-06` at `κ = 0.85` vs `0.00e+00` at
   `κ = 0`; the curve is non-monotone (`1.1e-07 → 3.2e-03 → 5.8e-11 → 5.5e-05 → 2.6e-06`) and returns
   to exactly `0` for `κ ≥ 0.9`. **Not evidence of chaos.**
6. **Joint composition targeting `pos(N)`** (fig 54): best loss `0.0046`; **0 factors** found for a
   1024-bit semiprime.
7. **Eta linearization** at 60 random `τ`, `Im τ ∈ [0.15,1.5]`: `6.13e-16`.

### Not established (asserted in prose or by analogy)

1. **That the trained objects are modular forms.** Every training script here (`hsln.py`,
   `hsln_dyn.py`, `poc_layer.py`, `hsln_skill_forge.py`, `hsln_compose_two.py`) optimises an arbitrary
   truncated `q`-polynomial; nothing constrains the DNA to `M_k(Γ₀(N))` or to the Hecke locus. The
   merge *guarantee* survives (zero-union holds for arbitrary holomorphic functions), but "we compose
   modular forms" does not. Needed: a parameterisation onto `M_k` (or the eta basis of §2.6), then figs
   17/20/55 re-run with the constraint live.
2. **That composition preserves performance.** Zero-union says an equilibrium exists at each parent's
   neuron. It says nothing about the readout: `∇|F_AF_B|² = |F_B|²∇|F_A|² + |F_A|²∇|F_B|²` is not the
   union of the flows, so *basins* reshape and inputs can be captured by the wrong attractor.
   `hsln_dyn.py`'s fig 19 demonstrates this. The corpus is explicit and correct about it; its fix is
   the direct sum — don't merge landscapes, use separate coordinates.
3. **Chaos.** No positive Lyapunov exponent measured, and the separation data contradict the claim.
   Needed: `λ_max` by two trajectories or the tangent equation, with the clipping removed or replaced by
   a smooth confining potential, plus a Kaplan–Yorke dimension above 2.
4. **That the `(ζ⋆ζ)(1)=0` witness is about the natural carrier.** §2.2(a,b).
5. **That the eta route is expressive.** The corpus flags it: eta quotients cannot place a neuron in the
   interior. Needed: a form family with interior zeros whose admissibility is *also* linear — which
   essentially forces you outside `{f_r}`.
6. **The Lean formalisation of the core law.** See the audit below.

### Lean audit (re-run here)

Compiled with `lake env lean <file>` against the pinned toolchain `leanprover/lean4:v4.35.0-rc4`
(mathlib present and built, `.lake` 7.2 GB):

| file | result | real `sorry` tactics |
|---|---|---|
| `Math/HSLNVerify.lean`, `HSLNLanglands.lean`, `HSLNHecke.lean`, `HSLNZeta.lean`, `HSLNDivisorEuler.lean` | **compile clean** | 0 |
| `Math/HSLN.lean` | compiles, **28 `sorry` warnings** | 28 |
| `Math/HSLNBridge.lean` | **fails to elaborate — 2 errors** | 0 |
| `Math/HSLNAlgebra.lean` | **fails to elaborate — 2 errors** | 0 |
| `Math/HSLNSerre.lean` | **fails to elaborate — 5 errors** | 0 |

The failures come from changes in the mathlib API, not from wrong mathematics: `HSLNBridge.lean:62 error: Ambiguous term
'antidiagonal'` (new vs old), `HSLNAlgebra.lean:77 error: Ambiguous term 'add_apply'`,
`HSLNSerre.lean:45 error: Application type mismatch: F has type ℍ → ℂ but is expected to have type
MDiff ?m.10`. So the statements are presumably still true and the proofs one-line fixes — but
"machine-checked, sorry-free against mathlib v4.30.0-rc2" is not reproducible, because the repository
pins `v4.35.0-rc4`.

**The load-bearing theorem of this thread is not proved in Lean.** From `HSLN.lean`:

```lean
line 356  def mul {g N : ℕ} {k₁ k₂ : ℤ}
              (F₁ : M_[g, N, k₁]) (F₂ : M_[g, N, k₂]) : M_[g, N, k₁ + k₂] := by sorry
line 365  theorem fourierCoeff_mul ... := by sorry
line 382  theorem neurons_mul (F₁ : M_[g,N,k₁]) (F₂ : M_[g,N,k₂]) :
              neurons (F₁ ⋆ F₂) = neurons F₁ ∪ neurons F₂ := by
            ext Z
            show (F₁ ⋆ F₂).toFun Z = 0 ↔ F₁.toFun Z = 0 ∨ F₂.toFun Z = 0
            have hmul : (F₁ ⋆ F₂).toFun Z = F₁.toFun Z * F₂.toFun Z := by sorry   -- line 393
            rw [hmul, mul_eq_zero]
line 528  def etaForm (N : ℕ) (r : Exp) : UpperHalfPlane → ℂ := by sorry
line 535  theorem etaForm_mul_eq_add (N : ℕ) (r s : Exp) :
              (fun τ => etaForm N r τ * etaForm N s τ) = etaForm N (r + s) := by sorry
```

`HSLN.mul` — the multiplication of Siegel modular forms, the operation the architecture is based on —
is a definition filled in with `sorry`. `neurons_mul` then proves a theorem about that placeholder,
assuming its defining property as another `sorry`. `etaForm_mul_eq_add`, the formal statement of the eta
composition law, is a `sorry`. The *mathematics* of both theorems is real and trivial (§2.4, §2.6); what
is missing is the connection to the corpus's bespoke `M_[g,N,k]` type (mathlib has multiplication on
modular forms only classically). `HSLNVerify.lean` describes itself accurately — its header calls itself the extraction of
§6–§7 *"that compile cleanly and sorry-free"* — but the narrative documents (`math-connections.md`,
`system-spec.md` §4.1(5), and `hsln_skill_forge.py`'s "machine-checked by `neurons_mul`") cite the
version containing `sorry` as the certificate, and that version does not certify the statement.

---

## 6. Failure modes and scope limits

**1. The central conflation.** `dna_algebra.py`: *"A DNA is an arithmetic function `f : ℕ → ℝ` — the
Dirichlet/q-expansion coefficients we train. Under (pointwise +, Dirichlet convolution `*`) these form
a COMMUTATIVE RING. **So 'whatever we can teach independently, we can compose' is literally ring
algebra.**"* And `math-connections.md`, same section: *"**Direct sum / tensor of the dynamical systems
corresponds to multiplication of their L-functions** … so the geometric composition and the
Dirichlet-ring product are the same operation in two realisations."* **Correction.** Those two
sentences are mutually inconsistent and the second is false: dynamical composition (tensor of models)
is *Cauchy*; the L-function product is *Dirichlet*; "the same operation" is exactly what
`rings_disagree_on_zeta` disproves, four lines later in the same section. Direct sum/tensor corresponds
to theta series multiplying (`Θ_{L⊕M} = Θ_L·Θ_M`, Ring A); Dirichlet series multiply by Ring B; they are
different functions of the same vector. The June files are clear about this in `HSLNBridge.lean`'s header,
so the issue lies in the narrative documents; it still matters, because "composition is a ring" is the
architecture's headline.

**2. "The product of two eigenforms is an eigenform with the product eigenvalue."** The `notes` field of
`results.json` row `compose.hecke.mult`. **Refuted**: `Δ²` has `a₁ = 0`, `a₆ = 143820`, `a₂a₃ = −48`;
`Δ·E₄` is an eigenform (because `dim S₁₆ = 1`) with `a₂ = 216 ≠ −51840 = a₂(Δ)a₂(E₄)`. The closure
theorem is about `𝓛` under `∗` (true), not about eigenforms under `⋆` (false). The row's own `verdict`
says `REFUTED` — only its `notes` asserts the opposite, and `math-connections.md` §"The bridge" invites
the same wrong inference.

**3. "Coupling unlocks chaos."** `math-connections.md` §6: *"At κ=0.85 the coordinates couple (3-D
extended phase space), and **nearby trajectories stay separated** (sensitive dependence)."* **Refuted as
measured**: the separation rises to `3.2e-03`, collapses to `5.8e-11`, and ends at `2.55e-06`; at
`κ = 0.90, 0.95, 0.99` it returns to exactly `0.000e+00`. A quantity that repeatedly returns to
numerical zero is a re-synchronisation signal, not an attractor. The same section does note the missing
Lyapunov exponent, but after stating the conclusion, so the conclusion is what a reader takes away.

**4. "The model computes its own Lie derivative."** `math-connections.md` §Lie: *"`D E₄ =
(E₂E₄−E₆)/3` (residual **exactly 0** in float). **So the model computes its own derivative and stays in
the space.**"* The identities are true and reproduced at `0.0e+00`. The inference is not: they say the
*ring* is `D`-stable. For the sentence you would need the trained DNA to be in `ℂ[E₂,E₄,E₆]` and the
code to evaluate `D` on it; no script does either. Equations PROVEN, sentence ANALOGY.

**5. "Convex feasibility" vs congruences.** `math-connections.md` §1: *"the modularity conditions are
linear (integer points in a polytope), so 'is this still a valid modular form?' is a convex feasibility
check."* The constraints are `≡ 0 (mod 24)` equalities; the solution set is a lattice, not a convex
body. The same document says the right thing one paragraph later ("integer linear programming"). Minor,
but a reader who follows the first wording would choose the wrong algorithm.

**6. "No standard network can do either."** `hsln_skill_forge.py`: *"merging needs retraining and
interferes; removing a learned concept cleanly is essentially impossible"* by gradient-based training. The
arithmetic demonstrated is real (merge `×`, erase `÷`, exact to `4.5e-16`), but the comparison is
unsupported by any experiment in the corpus, and clean removal is available only because the composite
was *built* by multiplication and the divisor *kept* — that is polynomial division, not machine
unlearning. Demo PROVEN, contrast ANALOGY.

**7. The eta "no interior zero" evidence.** The printed line `[zeros] eta-quotient min|f| on interior
slice = 5.295e-07 (no interior zero)` presents a decay value as if it were a margin; it sits at the cusp
end of the slice, where `|f| ~ |q|^{13/24}`. The conclusion is true for the structural reason; present
the proof, not the number.

**8. Three arithmetic/documentation slips.** `σ₃` is `ζ ∗ Id₃`, not `ζ^{∗4}` (`σ₃(2) = 9`,
`(ζ^{∗4})(2) = 4`), confirmed exactly; `hsln_compose_two.py`'s docstring says "the 309-digit `N`" while
the script prints `N is 1024-bit` (308 digits); and one encoding is used in three ways — `ArithmeticFunction R`
forces `f(0)=0`, `dna_algebra.py` writes `DNA_δ = [1,0,0,…]` but implements `c[1]=1`, and
`modular.qpoly` treats index 0 as the constant term. The witness `(ζ⋆ζ)(1) = 0` is valid only under the
first. One sentence in a header fixes it: *for Ring A, index 0 is the constant term; for Ring B, index 0
is padding and `a₁` is the unit.*

**9. Merging enlarges the model.** `zeros` and weights add, so merging `m` sectors gives weight `Σkᵢ` and
zero budget `Σkᵢ/12`; the Sturm bound, truncation length and evaluation cost all grow (fig 28 states
correctly that *convolution* takes microseconds). "Compose for free" is true of the arithmetic, not of the resulting
model.

---

## 7. How it connects

**Upstream.** This thread is the load-bearing cluster. `hsln.py`/`modular.qpoly` supply the "DNA =
truncated `q`-polynomial, neurons = `np.roots`" convention every merging figure uses; the sibling
finding that a degree-`N` truncated `E₄` has `N` roots in the `q`-disk, most of them truncation effects rather than zeros of `E₄` (architecture §3.4–3.5), limits
every neuron-count claim in figs 17, 20, 54, 55 to *polynomial* neuron counts. The zero-union law itself
is unaffected (it is about actual zeros), but "the merged model has exactly `n_A+n_B` neurons" should
read "exactly `n_A+n_B` polynomial roots, of which at most `(k_A+k_B)/12` can survive as true zeros of a
form". `hsln_dyn.py` (fig 19) is the necessary negative result: zeros survive merging, basins do not. It
is what motivates both the direct sum (fig 20) and the detection-style readouts used in figs 26 and 55.

**Downstream.** The number-theory thread (`32_zeta_compose`, `33_factorize`, `37_dna_algebra`,
`39_lfunctions`, `40_bsd`) is entirely Ring B, and every "build ζ from primes", "factorise", "class
number formula", "Dedekind factorisation" result rests on the closure of `𝓛`. The formal thread consumes
`HSLNBridge` (two rings) and `HSLNLanglands` (the submonoid) — and per §5, `HSLNBridge` currently fails
to elaborate while `HSLNLanglands` compiles. The `00-index/THE-STORY.md` framing ("the same operation as
the Euler product") needs §6(1)'s correction: *not* the same operation, but two operations on one
vector, with `𝓛` closed under one of them.

**Lateral identifications that are genuine.**

* **Convolution algebra of a monoid.** Rings A and B are one functor on `(ℕ,+)` and on `⊕_p ℕ`. This is
  *why* there are two rings, it produces the table in §2.3 in one stroke, and it explains the two "Lie
  derivatives" of §2.7 (a monoid homomorphism `φ : M → (ℝ,+)` yields a derivation; `(ℕ,+)` has
  `φ = id`, `⊕_p ℕ` has `φ = log`).
* **`Θ_{L⊕M} = Θ_L Θ_M`** bridges the lattice picture and the ring picture. "Add two reservoirs" and
  "multiply two forms" — operations from two worlds — are literally the same function of the period
  matrix, at every genus.
* **The inverse Siegel metric's `(τ₁,τ₂)` block is `K`.** So `κ` is not a knob; it is
  `(Im z)²/(Im τ₁ Im τ₂)`, and "PSD for `|κ| ≤ 1`" *is* the condition `Z ∈ ℍ₂`.
* **`E₂` is quasimodular, and that is why the Lie-derivative story needs it.** `D` does not preserve
  `M_*`; the quasimodular ring is `D`-stable, and the Serre correction `−(k/12)E₂` is exactly what
  removes the anomaly while raising weight. This is not stated in the June files, and it makes fig 38 coherent.
* **`Θ_{E8} = E₄` and `Θ_{D16⁺} = E₄²`** together are a counterexample to "the DNA determines the
  model": two non-isometric lattices, one theta series.

**Cross-reference.** The sibling thread
[discrete-and-crypto.md](discrete-and-crypto.md) covers the CM/`j` readout and the
factoring demos; its §"`hsln_reverse_factor.py`" reaches the conclusion this thread reaches from
`hsln_compose_two.py` — the ring encodes factorisation and gives no shortcut to computing it. The
two-ring distinction of §2.1 is the missing premise that turns that conclusion from an observation into
a theorem.

---

## 8. Open questions

1. **Does the merge guarantee survive a modularity constraint?** Retrain figs 17/20/55 with the DNA
   parameterised in `M_k(Γ₀(N))` (a `q`-basis, or the eta basis at `N = 11`) instead of freely.
   Zero-union still holds; the question is whether the constrained space still contains models that
   solve the tasks. If yes, "composition with guarantees" is a real result.
2. **What is the actual `λ_max` of the driven coupled flow?** Remove the clipping, integrate the tangent
   equation to saturation, and report `λ_max` versus `κ`. Prediction from the measurement above:
   `λ_max ≤ 0` for every `κ ∈ [0,1)`, with the observed stretching a transient. If `λ_max > 0` somewhere,
   state the window and the Kaplan–Yorke dimension.
3. **Is there a form family with interior zeros whose admissibility is linear?** Eta quotients fail. Next
   candidate: a linear combination in a *fixed* basis of forms with interior zeros, with the linear
   condition "not the zero form". Does a submonoid with the closure property exist that can place a
   neuron at a prescribed `τ ∈ ℍ`?
4. **Can the Cauchy/Dirichlet split be enforced in code?** One header defining `ringA_mul` and
   `ringB_mul`, plus a unit test asserting `ringA_mul(ζ,ζ)[2] = 1 ≠ 2 = ringB_mul(ζ,ζ)[2]`. Every
   downstream script then has to name which product it means.
5. **Does `HSLN.mul` have a real definition?** For `g = 1`, `Γ = SL₂(ℤ)`, mathlib's modular form ring
   supplies it; for the corpus's `M_[g,N,k]` it does not exist. Filling it in removes the two `sorry`s
   that carry the architecture (`fourierCoeff_mul`, `neurons_mul`), and the proofs are the one-line
   `mul_eq_zero` argument. It is plumbing, and it would move the flagship claim from "stated" to
   "proved".
6. **Is the exact common-zero hypothesis ever satisfiable?** The routing experiment reaches
   `|F| ~ 2e-04`. Can two independently trained sectors be made to share a zero *exactly* without
   retraining? The direct sum sidesteps this; a partially overlapping design would need it.
7. **Does `∗`-closure of `𝓛` ever imply anything about `⋆`?** The two products agree only on trivial
   data. A clean theorem — "`f ⋆ g = f ∗ g` for all `f,g` iff `f` or `g` is trivial" — would settle the
   distinction for good.
8. **Which corpus claims are about `𝓛` and which about `⋆`?** A mechanical audit of
   `math-connections.md` tagging every occurrence of "compose" as Ring A, Ring B, direct sum, or function
   composition would be the single most useful table in the extraction.
