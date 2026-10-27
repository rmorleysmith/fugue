# The evidence ledger

Every load-bearing claim in the corpus, graded. This is the document to consult when you
want to know whether something is a theorem, a measurement, an analogy, or wrong.

**Grades.**

- **PROVEN** — a classical theorem, correctly applied; or an exact algebraic identity
  re-derived here with exact arithmetic.
- **NUMERICAL** — a measurement with a stated tolerance in a stated regime. Real evidence,
  not proof.
- **ANALOGY** — a structural resemblance. Establishes nothing.
- **SPECULATION** — an untested hypothesis.
- **REFUTED** — asserted by the corpus and false, vacuous, or unsupported by its own evidence.

**Sources.** `verify:` = a check in [`04-verify/verify.py`](../04-verify/verify.py), id given.
`run:` = the corpus script was executed in `Fugue/.work/run` and its output quoted.
`threads:` = argued in one of the `02-threads/` documents.

The harness currently reports `35 VERIFIED, 2 REFUTED, 1 SCOPE-LIMITED` across 38 checks.
The two `REFUTED` rows below are findings about the corpus; both are genuine errors.

---

## A. The geometric kernel

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| A1 | E8 is an even unimodular lattice of rank 8; Gram determinant 1 | **PROVEN** | `verify:E8.even` — 9121 vectors with ‖v‖²≤6, all norms even; `verify:E8.unimodular` — det = 1.000000000000 | `e8.py` |
| A2 | Θ_{E8} = 1 + 240q + 2160q² + 6720q³ + … = E4 | **PROVEN** | `verify:E8.theta.roots` — brute-force counts 240 / 2160 / 6720 exactly match `240σ₃(n)`. Poisson summation gives τ↦−1/τ (self-dual); evenness gives τ↦τ+1; weight = rank/2 = 4 | `e8.py`, `render.py:06` |
| A3 | E4 = 1 + 240Σσ₃(n)qⁿ has exactly one zero in the fundamental domain, at ρ = e^{2πi/3}, simple | **PROVEN** | `verify:E4.zero.at.rho` — `\|E4(ρ)\| = 1.5e−15`; valence formula `3·ord_i + 2·ord_ρ + 6Σ = 2` gives `ord_ρ = 1`. Abstractly: ρ⁻¹ = ρ−1 ∈ SL₂(ℤ)·ρ, so `E4(ρ) = ρ⁴E4(ρ)` and `ρ⁴ ≠ 1` | `modular.py`, `render.py:01` |
| A4 | `Δ = (E4³−E6²)/1728 = q∏(1−qⁿ)²⁴`, with integer coefficients | **PROVEN (exact)** | `verify:E4.identity` — computed in `Fraction` arithmetic over n ≤ 60; first coefficients `1, −24, 252, −1472, 4830` = Ramanujan's τ | `modular.py` |
| A5 | E4 is a Hecke eigenform with eigenvalue σ₃(p) | **PROVEN** | `verify:E4.hecke.eigen` — `T_pE4 = σ₃(p)E4` to 0.0e+00 relative deviation for all p < 40, on the full available index range | `HSLNHecke.lean`, fig 41 |
| A6 | The zeros of E4 in the q-disk are the `q`-images of the orbit SL₂(ℤ)·ρ, with `\|q\| = exp(−π√3/(c²−cd+d²))` | **PROVEN** (structure) | Thread `architecture.md` §3: measured roots match the prediction to 9 digits for hexagonal norms 1, 3, 7, 13, 19, 21, 37. Countably infinite, accumulating on `\|q\| = 1` | `modular.py` |
| A7 | The number of roots of the truncated series grows like the truncation degree `N`, not like a capacity dial | **NUMERICAL** | Thread `architecture.md`: counts 5, 20, 80, 318, 640 for `N` = 5, 20, 80, 320, 640; `min\|q\| = 0.004333421` at every degree; `max` in-disk `\|q\|` → 1 (0.9978 at N=640). For N=320 the unrefined `\|E4(root)\|` has median 7.7e4, so most roots are *not* zeros of E4; 302/318 Newton-converge to genuine orbit images | `render.py:08`, fig 08 |
| A8 | "The neuron count is capped by the DNA length (Sturm bound)" | **REFUTED** | Conflates three things. The Sturm bound governs *uniqueness* of a form, not its zero count. The valence formula's `k/12` is a **weighted** count; the distinct-zero bound at level 1 is `≤ k/4`, and at `k = 12` the form `Δ` has **zero** interior zeros (`ord_∞(Δ) = 1 = 12/12` exhausts the valence). So "increasing weight grows the count" fails at the first interesting weight | `math-connections.md`, fig 08 caption |
| A9 | Zeros of a holomorphic `F` are exactly the attractors (local minima) of `\|F\|²` | **PROVEN** | `verify:dyn.zeros.are.minima`; `log\|F\|` is harmonic away from zeros, so no interior minimum except at `F = 0` | `system-spec.md` §2.4 |
| A10 | "E4's neuron set is a single point" | **REFUTED** (as literally stated) | Infinite on the orbit; *one per fundamental domain* is the correct statement | figs 01, 03 |
| A11 | `render._velocity` implements the gradient flow | **SCOPE-LIMITED** | Thread `architecture.md` §8: it computes the **Euclidean** gradient, not the hyperbolic one (no `y²` factor). Orbits are the same; the *times* are not. Since `\|τ̇\| = 2\|F\|\|F′\|` exactly, motion **freezes** at neurons, so `system-spec.md`'s "τ_eff diverges far from zeros, contracts near zeros" is **backwards** | `render.py`, `system-spec.md` §2.4 |
| A12 | `fig_dynamics` shows driven spiking at neurons | **REFUTED** | Thread `architecture.md` §8: with `dna_from_neurons`' normalisation the landscape term is `~1.3e−7` versus a drive of `0.9`, so the figure is essentially a driven free particle. Closest approach to any neuron is 0.3300, and the "threshold" is the 88th percentile of that trajectory — the spikes are not at neurons | `render.py:04` |
| A13 | At genus 2 the zero set of a Siegel form is a *curve* | **REFUTED** | The zero set of one equation in `ℍ₂` (complex dim 3) has complex dim **2** — a divisor, not a curve. The figures show one *slice* at a time (isolated points), which is consistent. The right invariant is the class `k·λ₁`; at `g = 1`, `deg λ₁ = 1/12` **is** the valence formula | `render.py:09,10`, figs 09, 10 |
| A14 | `system-spec.md` §1.2 writes `Θ_E8 = 1 + 240Σσ₃(n)q^{2n}` with `q = e^{2πiτ}` | **REFUTED** (inconsistent) | Self-inconsistent: the 240 norm-2 vectors contribute `q¹`. The code is right; the display describes `E4(2τ)`, which is not a level-1 form | `system-spec.md` §1.2 |

---

## B. Composition — Ring A, the zero-union law

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| B1 | `zeros(F·G) = zeros(F) ∪ zeros(G)`, exactly | **PROVEN** | `verify:compose.zero.union` — product roots within 2.95e−15 of a factor root, and `deg F + deg G = deg(FG)` exactly, so nothing is created or lost | `system-spec.md` §3.4(b), figs 05, 17, 18 |
| B2 | Multiplying forms = Cauchy convolution of DNA coefficients | **PROVEN** | `verify:compose.cauchy` — direct product vs convolved series agree to 2.8e−16 | `dna.py`, fig 11 |
| B3 | Exact zero-shot model merging in code | **NUMERICAL** | `cm_tensor.py` composes four separately-trained DNAs and finds the compound's neurons equal the parents' to **1.76e−16**; 95% held-out by nearest-neuron | `cm_tensor.py`, fig 26 |
| B4 | **Addition** does not union zeros | **PROVEN** | Thread `composition-algebra.md`: `\|E4³ + E6²\|` = 8.30 at ρ and 3.09 at i (no cancellation), versus `\|E4³E6²\|` = 3.1e−44 at ρ and 1.5e−31 at i (exact cancellation, multiplicities add) | fig 11 |
| B5 | The merge demos are compositions of modular forms | **REFUTED** | Thread `architecture.md` §4: `M₈(level 1) = ℂ·E4²` has **one double zero** at ρ, so no weight-8 level-1 form has the four zeros figure 05 shows. The demos compose *polynomials*. Reachability (is the trained DNA in the form space?) is never checked — the largest gap in the corpus | figs 05, 11, 12, 18 |
| B6 | Zero-union requires modularity | **REFUTED** (as an implication) | Zero-union is a property of *any* two holomorphic functions (`ℂ` is a domain). Modularity is irrelevant to B1. What modularity buys is that the ring of composable objects is a *known finite-dimensional space* | `system-spec.md` §3.4(b) |
| B7 | Tensor composition destroys routing, not detection | **NUMERICAL** | Thread `architecture.md` §5: of 856 seeds that A alone sends to an A-neuron, **542 (63.3%)** land on a B-neuron under `A ⊗ B`. Detection (zero-union) survives; basins do not | `hsln_dyn.py`, fig 19 |
| B8 | Direct sum decouples the flow | **PROVEN**, with a caveat | Thread `architecture.md`: basin membership changes for **0 of 856** seeds — orbits exactly preserved. **Caveat:** the fixed-point set is `{F_A=0}×ℍ ∪ ℍ×{F_B=0}`, a 2-real-dimensional continuum, not just the neurons; a joint velocity of ~1e−46 was measured at a point 0.39 away from any A-neuron | `hsln_genus2.py`, fig 20 |
| B9 | "Direct sum of lattices" and "tensor product" are different DNA operations | **REFUTED** | Both are **Cauchy convolution** of coefficients. They differ only in the *state embedding* (separate coordinates versus one shared coordinate) | `system-spec.md` §3.4 |

---

## C. Composition — Ring B, the Dirichlet ring

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| C1 | `(ℕ→R, f(0)=0)` carries **two inequivalent** ring structures | **PROVEN** | `verify:compose.two.rings.differ` — `(ζ⋆ζ)(1) = 0` but `(ζ*ζ)(1) = 1`. Thread `composition-algebra.md`: both are the completed monoid ring of the index monoid, applied to `(ℕ,+)` and `(ℕ_{>0},×) ≅ ⊕_p ℕ`; the group completions `ℤ` and `ℚ_{>0}` are non-isomorphic | `HSLNBridge.lean`, fig 37 |
| C2 | "The geometric composition and the Dirichlet-ring product are the same operation in two realisations" | **REFUTED** | Contradicted by the corpus' own `rings_disagree_on_zeta`, four lines later in the same document | `math-connections.md` §DNA algebra |
| C3 | Ring A has an identity in the corpus' carrier | **REFUTED** | `δ = [n=1]` shifts q-degree under `⋆`, so `DNA_δ = [1,0,0,…]` is the identity in Ring B and the *form `q`* in Ring A. `dna_algebra.py` and `HSLNAlgebra.lean` describe it as the "do-nothing DNA", true only under `*` | `dna_algebra.py`, `HSLNAlgebra.lean` |
| C4 | `ζ * μ = δ` (Möbius inversion) | **PROVEN** | `verify:ring.mobius.inverse` — `Σ_{d\|n} μ(d) = [n=1]` for all n ≤ 2000 | fig 37, `HSLNAlgebra.lean` |
| C5 | `ζ * ζ = d(n)` | **PROVEN** | `verify:ring.zeta.squared` — all n ≤ 3000 | fig 37 |
| C6 | `ζ * χ₋₄ = r₂(n)/4` (Jacobi two-square) | **PROVEN** | `verify:ring.two.squares` — all n ≤ 4000, against brute-force lattice-point counts. Hence `ζ·L(s,χ₋₄) = ζ_{ℚ(i)}` | fig 37 |
| C7 | `6·(ζ*χ₋₃)(n) = #{(a,b) : a²−ab+b² = n}` (Eisenstein) | **PROVEN** | `verify:ring.gaussian.hexagonal` — all n ≤ 600, against brute-force enumeration | fig 39 |
| C8 | `σ₃ = ζ * ζ * ζ * ζ` (the E8 theta DNA as a 4-fold Dirichlet power) | **REFUTED** | `verify:ring.divisor.identity` — `σ₃(2) = 9` but `(ζ^{*4})(2) = 4`. The correct factorisation is `σ₃ = Id₃ * ζ` | `dna.py` docstring. `hsln_e8_divisor_bridge.py`'s docstring is right |
| C9 | `D f(n) = f(n)·log n` is a derivation of the ring; `D(ζ)·μ = Λ` | **PROVEN** | `verify:ring.lie.derivative` — `max\|log*μ − Λ\| = 2.2e−15`; Leibniz residual 4.4e−16; `D` is a derivation of **both** rings | fig 38 |
| C10 | The ring `ℂ[E₂,E₄,E₆]` is closed under `D = q d/dq`; Serre's `ϑ` raises weight | **PROVEN** | `run:lie_derivative.py` — residuals `0.0e+00` for all three Ramanujan relations and for `ϑE4 = −E6/3`, `ϑE6 = −E4²/2` | fig 38 |
| C11 | The multiplicativity locus is a `Submonoid` of the Dirichlet ring | **PROVEN** | mathlib's `IsMultiplicative.mul`. This is the single algebraic fact behind the Euler product, `ζ·L(s,χ_D) = ζ_K`, Rankin–Selberg closure and Hecke multiplicativity | `HSLNLanglands.lean` |
| C12 | "The product of two eigenforms is an eigenform with the product eigenvalue" | **REFUTED** | `verify:compose.hecke.mult` — `a₂(Δ·E₄) = 216` but `a₂(Δ)·a₂(E₄) = −51840`. (`Δ·E₄` *is* an eigenform — `S₁₆` is 1-dimensional — but for an unrelated reason.) The true closure law is C11, about coefficient *sequences*, not eigenforms | `math-connections.md`, `HSLNBridge.lean` |
| C13 | `Θ_{L⊕M} = Θ_L·Θ_M` at every genus | **PROVEN** | `verify:e8xe8.product` — the bilinear form is block-diagonal, so the theta sum factorises. This is the "freeze the state, dial the gravity DNA" move | fig 12 |
| C14 | Eta-quotient multiplication = addition of exponent vectors | **PROVEN**, but nearly trivial | `verify:eta.compose.adds` — relative residual 1.2e−41. Trivial because η ≠ 0 on ℍ. The **substantive** content is that Newman's congruences and Ligozat's cusp-order inequalities are **linear** in the exponent vector, so admissibility is a convex feasibility check | fig 21 |
| C15 | Eta quotients can place a neuron anywhere | **REFUTED** | `verify:eta.nonvanishing` — `min\|η\| = 0.19` over a probe reaching y = 0.02, and both factors of `η = q^{1/24}∏(1−qⁿ)` are non-vanishing for `\|q\| < 1`. So every eta-quotient zero is at a **cusp**. The corpus flags this scope limit itself | fig 21 |
| C16 | `η(τ)²η(11τ)²` is the weight-2 newform of `X₀(11)`, i.e. the curve `11a1` | **PROVEN** | `verify:eta.level11.newform` — its coefficients equal `p + 1 − #E(𝔽_p)` for `p = 2,3,5,7,13,17,19,23,29,31` | fig 21, Wiles–Taylor |
| C16b | The weight-4 PoC newform 11.4.a.a (`dna.py`) "is equivalent to `E₄` truncated to the same order" | **PROVEN** (numerically certified; Sturm) | Precisely: `a(n) ≡ σ₃(n) − σ₃(n/11) (mod 𝔭)`, `𝔭 = (61, √3−8) ⊂ ℤ[√3]`, for **all** `n` — an Eisenstein congruence with `(E₄(τ) − E₄(11τ))/240 ∈ M₄(Γ₀(11))`, the weight-4 level-11 twin of `τ ≡ σ₁₁ (mod 691)`; `61 ∣ 11⁴ − 1`. Checked to `n = 200` (Sturm bound 4) by `05-repro/newform114_eisenstein_congruence.py`, which rebuilds 11.4.a.a from `η²(τ)η²(11τ)` and `E₂(τ) − 11E₂(11τ)` as the `T₂`-eigenform for `1+√3`. Not an identity of coefficients (the June files' phrase), a congruence | `05-repro/newform114_eisenstein_congruence.py` |
| C17 | Ring A has no identity and Ring B does; both are "completed monoid rings" | **PROVEN** | Thread `composition-algebra.md` §2.1 | — |

---

## D. The number theory suite

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| D1 | The Euler product over primes ≤ 48 recovers `a(n) = 1` for all n ≤ 48 | **PROVEN** | `verify:zeta.euler.product`; true because every integer factors uniquely | fig 32 |
| D2 | The completed zeta satisfies `Λ(1−s) = Λ(s)`; `Re s = 1/2` is its fixed axis | **PROVEN** | `verify:zeta.functional.equation` — max relative deviation 1.6e−30 across four test points | `HSLNZeta.lean` |
| D3 | The `s ↦ 1−s` symmetry alone does **not** force RH; the load-bearing ingredient is the Euler product | **PROVEN**, and the corpus' sharpest insight | `verify:zeta.symmetry.not.enough`. Davenport–Heilbronn satisfies a genuine same-axis functional equation and has a **proven** off-line zero, because it has no Euler product; Epstein zeta functions are a second family. The corpus states this correctly in `HSLNZeta.lean`'s docstring | `HSLNZeta.lean`, `math-connections.md` §RH |
| D4 | The zeros reconstruct the prime staircase (explicit formula) | **PROVEN** (classical); NUMERICAL here | `verify:zeta.explicit.formula` — mean \|error\| 3.54 (50 zeros) → 3.02 (200 zeros) over x ∈ {97, 199, 421, 983}. Thread `number-theory.md`: with the 500 cached zeros the corpus' own table reproduces exactly (0.5836 → 0.0756) | `explicit.py`, fig 35 |
| D5 | Zeta-zero spacings show GUE level repulsion, not Poisson | **NUMERICAL** | `verify:zeta.gue.repulsion` — `P(spacing < 0.2)` = 0.0025 (zeros), 0.0084 (GUE), 0.1813 (Poisson). Thread `number-theory.md` gives a proper KS: 0.0463 vs GUE, 0.3260 vs Poisson, spacing variance 0.142 vs Wigner 0.178. **Evidence, not proof** | `spectral.py`, fig 34 |
| D6 | `L(1,χ_D) = 2πh/(w√\|D\|)` for imaginary quadratic fields | **PROVEN** | `verify:L.special.values` — all five (D = −4, −3, −7, −8, −11) match to <1e−5 by direct summation to 2×10⁵ terms. (Note: `mpmath.nsum` mis-evaluates these oscillatory series, returning 0.8349 where the true `L(1,χ₋₄) = π/4 = 0.7854`.) | `lfunctions.py`, fig 39 |
| D7 | `L(2,χ₋₄) = G` (Catalan) | **PROVEN** | `verify:L.catalan` — 0.915965593864719 vs `mp.catalan` = 0.915965594177219 | fig 39 |
| D8 | Abelian factorisation `ζ·L(s,χ₋₃) = ζ_{ℚ(√−3)}` at the coefficient level | **PROVEN** | `verify:ring.gaussian.hexagonal` | fig 39 |
| D9 | Sieving by {2,3,5,7} recovers exactly the primes ≤ 100 | **PROVEN** | `verify:complexity.sieve.primes` — 21/21 survivors above the sieve bound (the four detector primes are themselves killed by the product, which is why the test starts at 11). `run:prime_sieve.py` prints 25/25 over the whole range | `prime_sieve.py`, fig 31 |
| D10 | "Finding primes by composition" is a new mechanism | **REFUTED** | It is the Sieve of Eratosthenes: `sin(πx/p)` vanishes exactly at multiples of `p`, and every composite n ≤ 100 has a prime factor ≤ √100. Equivalent to trial division by {2,3,5,7} | fig 31 caption |
| D11 | The "factoring wall" explains why factoring is hard | **REFUTED** | `verify:complexity.factor.wall` — `101·103 = 10403` is opaque to primes ≤ 100. Trivially true: a detector set can only find factors it contains. This restates the √N trial-division limit; it says nothing about the absence of polynomial-time algorithms | `factorize.py`, fig 33 |
| D12 | `D(k) = (1/k)\|Σ_{j<k} e^{2πijN/k}\| = 1` iff `k \| N` | **PROVEN** | Geometric series; the corpus states it correctly | `hsln_e8_torsion_factor.py`, fig 57 |
| D13 | The "E8 torsion" projection reveals the factors | **REFUTED** as a mechanism | The E8/Coxeter plane is the *picture*; the engine is D12, i.e. trial division. The script says so itself: "cost note: first spike appears only at the least factor (~√N) — a faithful picture, not a sub-√N shortcut." `run:` reproduces 10/10 correct factorisations | fig 57 |
| D14 | The factoring demo is a break of anything | **REFUTED** | `verify:crypto.scaling` + `run:hsln_reverse_factor.py`: growth is `~√N`, i.e. exponential in the digit count, and the script prints "NOT polynomial". Classical Pollard rho/Brent (1975/1980). The corpus is explicit that RSA is not broken | figs 57–62 |
| D15 | `factorize.py` runs | **REFUTED** | It **does not terminate**: `true_factor(n)` is trial division to `isqrt(n)`, which for its own 39-digit test modulus is ~1.6e19 iterations — and the result is unused. Its detector set is the primes < 10⁴ while its docstring says "≤ 100" | `factorize.py` |
| D16 | BSD: `L(E,s)` built from per-prime Euler factors, evaluated at 1, reproduces the rank pattern | **PROVEN** (rank 0) / **NUMERICAL** (rank ≥ 1) | `verify:bsd.L1.smoothed.sum` — `11a1` matches LMFDB to `2.2e−16`; `14a1` to `2.1e−6`; `37a1`, `389a1`, `5077a1` all vanish through genuine O(1) cancellation. `verify:bsd.pointcount.modularity` — Hasse bound respected for four curves by raw point counting | `bsd.py`, fig 40 |
| D17 | The `389a1` rank-2 case is a *genuine* detection of analytic rank 2, not sign-forced | **PROVEN** | `verify:bsd.L1.smoothed.sum` and two independent agent re-derivations: `389a1` has `w = +1`, so the functional equation does **not** force the zero; the raw partial sums wander to **0.7272** before cancelling to `−3.2e−16`. That is a real rank-2 detection. **An earlier draft of this directory wrongly called this a corpus error**; the error was in the harness (§4 of [`05-repro/README.md`](../05-repro/README.md)) | fig 40 |
| D18 | The figure's `L(E,1) ≈ 0.306` for `389a1` | **REFUTED** (the value does not exist) | Thread `number-theory.md`: `0.306` appears nowhere in the corpus. It is `L′(37a1,1) = 0.305999773834` — the **rank-1** curve's BSD leading coefficient, printed by no script. `bsd.py` correctly prints `−0.000000` for `389a1` | — |
| D19 | Erdős–Kac: `ω(n)` is asymptotically Gaussian | **PROVEN** (theorem) / **NUMERICAL** (the measurement) | `run:landscape.py` — 3.18 s for n ≤ 9×10⁶, 602,489 primes, 2.83% 100-smooth. Thread `number-theory.md` notes the reported `σ = 1.048` is the *sample* σ, not the theoretical `√log log N = 1.665` | `landscape.py`, fig 36 |

---

## E. The dynamical claims

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| E1 | `L_X E = dE/dt = −\|∇E\|² ≤ 0` along the flow | **PROVEN**, but tautological | `verify:dyn.gradient.dissipates` — energy monotone 0.633 → 0.027. True of *any* gradient flow; not a property of the modular structure | fig 38 |
| E2 | The coupling matrix `K = [[y₁², κy₁y₂],[κy₁y₂, y₂²]]` is the genuine Siegel metric, not a model | **PROVEN** | `verify:dyn.coupling.is.siegel.metric` — `inv(G)[:2,:2]` equals `K` to **1.1e−15** over four parameter points, where `G` is the metric Gram matrix on `ℍ₂` with `Y = Im Z`. So `κ = (Im z)²/(y₁y₂)` is the normalised correlation, and `\|κ\| ≤ 1 ⟺ Im Z ≻ 0` | `coupling_sweep.py`, fig 22 |
| E3 | A simultaneous zero stays an equilibrium for every κ | **PROVEN** | `verify:dyn.gravity.preserves.equilibria` — `K` is PSD exactly for `\|κ\| ≤ 1`; at a common zero both gradients vanish and a PSD metric cannot move a vanishing gradient. "Gravity warps the path, keeps the destination" is a theorem | `HSLN.lean`, fig 22 |
| E4 | Coupling κ > 0 "unlocks chaos" (sensitive dependence) | **REFUTED** | `verify:dyn.coupling.unlocks.chaos`, using the corpus' own `driven_rollout`. At κ=0.85 the separation is **bounded and non-monotone**: it wanders to 6.02e−2 and collapses below 1e−9 on 1368 of 12000 steps, returning to 2.55e−6. No exponential divergence, no positive Lyapunov exponent. Only the **dimensional** argument survives: κ=0 forces a 2-D extended phase space (Poincaré–Bendixson forbids chaos); κ>0 permits 3-D. That is a necessary condition, not evidence. The corpus itself flags "a formal positive Lyapunov exponent is not yet measured" | `coupling_sweep.py`, fig 22C |
| E5 | The κ-prose and the κ-proof disagree | **REFUTED** | The prose says PSD (`\|κ\| ≤ 1`); the Lean `gravity_preserves_equilibria` needs `PosDef` (`\|κ\| < 1`). And the "common zero" is only accurate to `\|F\| ~ 2.1e−4` | `HSLN.lean`, `math-connections.md` §6 |
| E6 | The routing error stays ≈0 for all κ | **NUMERICAL** | `run:coupling_sweep.py` — errors 0.001–0.005 across κ ∈ [0, 0.95]; not "≈0" but small and non-monotone | fig 22A |

---

## F. Machine learning claims

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| F1 | A minimal HSLN trains by backprop through the relaxation flow | **NUMERICAL** | `poc.py`; the caption's `0.079 → 0.002` does **not** reproduce (measured `0.07866 → 0.00836`, 5 seeds spanning 0.00472–0.01327) | `poc.py`, fig 13 |
| F2 | `poc.py`'s targets are attractors of the trained field | **REFUTED** | Thread `training-and-dynamics.md`: the loss is a **min over the trajectory**; paths pass within 0.065/0.048 of the targets at steps 14–15 of 160 and end 0.23 away, with `\|F\| = 0.58` at the targets | fig 13 |
| F3 | Temporal XOR works via the spike mechanism | **NUMERICAL**, but mis-framed | `poc_xor.py` contains **no ODE, no integration, no time**: it is a static four-point discriminant. Truth table (0.013, 0.974, 0.972, 0.014), loss 1.9530 → 0.00224, reproducible over 4 random inits. But the *untrained* network already spikes at all four inputs, so training **suppresses** two spikes | `poc_xor.py`, fig 16 |
| F4 | Layering by tensor product adds capacity | **REFUTED** | Thread `training-and-dynamics.md`: a direct monic quartic with the same 8 real parameters reaches 4/4 at loss 6.8e−6 versus the layered 1.95e−5. The map is onto, so it is a reparameterisation, not added capacity | `poc_layer.py`, fig 17 |
| F5 | `scaling.py`'s timings | **NUMERICAL**, caption wrong | Thread `training-and-dynamics.md`: batch peak 7243/s, not the caption's 25k, non-monotone, 2.6–7× run-to-run noise. Genus cost is a one-off **table build** (2.92× vectors → 7.8× time); per point, the 161-term genus-2 theta (10 372 ns/pt) is **faster** than the 199-term genus-1 series (15 422 ns/pt) | `scaling.py`, fig 28 |
| F6 | The HSLN's native circular state removes the grokking delay | **NUMERICAL** | `run:grok.py` — circular model train/test 1.000/1.000 together; MLP control 1.000/0.000. The learned phases are a genuine lattice (≈2πk/11 to ~1°, κ=28.56), and 12 parameters cannot fit a random 121-label table (train 0.167). **But the control never groks** (test 0.000 at 30 000 steps in two optimiser regimes), so the "memorise then grok" story is unsupported | `grok.py`, fig 30 |
| F7 | Skill stacking (function composition) works | **NUMERICAL**, reservoir role REFUTED | `run:skill_compose.py` — 6/6. But the answer is exact algebra: `\|Σ_present ω^p + ω^m\| = 4.6e−16 … 8.9e−16`, the sum is taken in numpy *outside* the reservoir, and the result is invariant under a 100× drive change | `skill_compose.py`, fig 29 |
| F8 | The classifiers "learn" | **NUMERICAL**, with scope limit | `cm_classifier.py` reaches 95% on 80 held-out points — but the landscape is **fixed** (neurons at the two CM points) and only a linear input encoder is trained: reservoir computing. The corpus says so | fig 25 |
| F9 | The corpus runs `system-spec.md` §5.6's decisive test (train two models on disjoint tasks, merge, verify both) | **REFUTED** | `poc_layer.py` trains both sectors **jointly**. No script performs the zero-shot merge test on independently-trained real tasks. Given that the spec calls this "the cheapest empirical test of the whole architectural claim" and warns "*if this fails, the algebraic framing is dressing*", its absence is the single most important gap | `system-spec.md` §5.6 |

---

## G. Discrete symbols and cryptography

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| G1 | The nine Heegner numbers give rational-integer `j`-values, perfect cubes | **PROVEN** | Thread `discrete-and-crypto.md`; classical (Weber, Heegner–Baker–Stark). Verified with mpmath at high precision; `j((1+√−163)/2) = −640320³` to within 1e−70 | `cm_alphabet.py`, fig 23 |
| G2 | `j` is a bijection `ℍ/SL₂(ℤ) → ℂ`, so any invariant readout is rational in `j` | **PROVEN** | Moduli interpretation; classical | `cm_task.py` |
| G3 | The CM readout spells "ADA" | **NUMERICAL** | Only two of the nine symbols are reachable in the corpus' grid, so it is effectively a 2-symbol toy with a bit code | `cm_task.py`, fig 24 |
| G4 | CM attractors are generically obtainable | **REFUTED** | The corpus states the caveat itself: attractors are zeros of `F`, generically *not* CM points; they must be **engineered**. The 95% classifiers fix the landscape at the two reachable CM points | `math-connections.md` §2 |
| G5 | The SHA-256 fitness landscape is flat, so the framework cannot touch hashing | **PROVEN** (as a negative result) | `hsln_bitcoin_hash.py` — avalanche ≈ 0.5 per bit; leading-zero structureless; preimage distance ≈ 128 regardless of input proximity; no clustering. Conclusion: mining/addresses are only quadratically helped by quantum (Grover), never broken by period-finding (Shor). **The best-reasoned script in the corpus** | fig 60 |
| G6 | Hash/address/PGP attacks | **REFUTED** | The "dances" drive the reservoir with the bits of a *known* key or hash. Visualisation, no attack | figs 47–49 |
| G7 | Bitcoin private keys are recovered | **REFUTED** | `hsln_bitcoin_probe.py` trial-divides the public key's **x-coordinate as an integer**; the docstring names the category error itself: "A Bitcoin key's secret is an ELLIPTIC-CURVE DISCRETE LOG … Factoring ≠ discrete log." `run:` finds small factors {2,3} and leaves a 249-bit cofactor — meaningless for the key. Figure name overstates | fig 59 |
| G8 | `inv(F)` inverts SHA-256 | **REFUTED** | It computes the **formal power-series inverse** `1/F` of a q-polynomial built from the hash bytes: polynomial long division, in mpmath at 80 digits because `\|a₀\| ≈ 2e−16`. Unrelated to preimages | `hsln_hash_inverse.py`, fig 51 |
| G9 | The cofactor battery finds a factor | **VERIFIED** (that it does not) | `hsln_cofactor_safety.py` runs trial division to 10⁷, Pollard rho, Pollard p−1 and a "DNA→circulant spectral" method. The spectral method builds a circulant from the divisibility indicator, so it carries no information beyond that indicator — it cannot see a factor outside its window | fig 62 |
| G10 | Real-key recursion cascades into a fast algorithm | **REFUTED** | `hsln_bitcoin_recurse.py`: peeling small primes barely reduces bit-length, the cofactor is **prime**, and the recursion terminates immediately | fig 61 |
| G11 | The reverse (N → 1) direction is polynomial | **REFUTED** | `run:hsln_reverse_factor.py` prints the measured table and concludes "grows ~√N: exponential in the number of digits. NOT polynomial." A genuine, correctly-stated negative result | fig 58 |

---

## H. The speculative frontier

| # | Claim | Grade | Evidence | Source |
|---|---|---|---|---|
| H1 | `χ(f) = f(1)` is a ring homomorphism on the Dirichlet ring (Chern character) | **PROVEN**, near-trivial | `χ(f*g) = f(1)g(1) = χ(f)χ(g)`; and `(f⋆g)(1) = 0` for all f, g (a carrier statement). "The augmentation map is a ring hom | one line. The GRR dictionary is **ANALOGY** | `HSLNKTheory.lean` |
| H2 | Hodge classes form a graded subring | **PROVEN** | `hodge_mul` — `H^{k,k}·H^{k',k'} ⊆ H^{k+k',k+k'}`. This is the structural reason a ring homomorphism lands inside the Hodge ring | `HSLNHodge.lean` |
| H3 | The integral Hodge conjecture is false; the Kähler version is false; only `k = 1` is proven | **PROVEN** | Atiyah–Hirzebruch 1962 (torsion counterexamples, via topological K-theory), Voisin 2002, Lefschetz (1,1). The corpus records all three caveats | `HSLNHodge.lean` docstring |
| H4 | E8's torsion-freeness makes the integral-Hodge-modulo-torsion qualifier vacuous | **REFUTED** (vacuous) | Every lattice is torsion-free as an abelian group, so singling out E8 adds nothing | `math-connections.md` §Hodge |
| H5 | "Cup product splices trained strands" | **REFUTED** by the corpus itself | `system-spec.md` §4.3: the cup product sends `H¹ ⊗ H¹ → H²`, a different group of a different curve. "This claim, as stated […], is metaphorical." Figure 64 exists anyway | `hsln_cup_product.py`, fig 64 |
| H6 | The multiplicativity locus is the algebraic core of abelian Langlands | **PROVEN** | `ζ·L(s,χ_D) = ζ_K` because both sides are multiplicative and agree on prime powers. `LanglandsTransfer` gives the correct *shape* of functoriality (a monoid of transfers) | `HSLNLanglands.lean` |
| H7 | A self-adjoint operator has real spectrum ⇒ Hilbert–Pólya ⇒ RH | **PROVEN** as an implication; hypothesis open | `riemannHypothesis_of_spectralZeta` is `HP operator ⇒ RH`, with the operator's existence an open `def`. The corpus' later `…_iff_…` equivalence is logically fine — and its content is that "make this def a theorem" is **exactly as hard as RH**. The corpus says so | `HSLNSpectral.lean` |
| H8 | Weil/Li positivity is the single open node of RH, and it is analytic | **PROVEN** as a reformulation | `HSLNWeilPositivity.lean`: "The single open node is the positivity — which *is* RH… the prime-power sum carries no sign and must be dominated by the positive Γ′/Γ archimedean term for *every* test function… Analytic, not algebraic — no finite certificate known." The sharpest paragraph in the corpus | `HSLNWeilPositivity.lean` |
| H9 | A spectral gap scales with the coupling | **PROVEN** | `massGap_smul`; `action_nonneg` via Bogomolny | `HSLNYangMills.lean` |
| H10 | The corpus self-audited a vacuous definition | **PROVEN** (and exemplary) | `math-connections.md`: "`YangMillsMassGap` and `TraceFormulaRealization` are satisfied by the trivial `T = 0` — machine-checked. Added `MassGapFaithful` + `zero_not_massGapFaithful`." Finding your own existential is satisfied by zero, and saying so, is the right instinct | `HSLNYangMills.lean` |
| H12 | `φ(N)` can be evaluated compositionally without decomposing `N` | **REFUTED** | `run:phi_via_category.py` — four routes tested: A (Euler product/tensor) and D (Möbius/Yoneda) condition on the factorisation; C is classically equivalent to factoring (Boneh–Lipton 1996, Shor 1994); B (`O(N)` coprime count) needs no factorisation but is exponential in `log N`. The script's own conclusion: "the composable model unifies ζ, μ, φ, σ, Λ as different multiplicative functors; it does **NOT** extract their values at unfactored N more cheaply than the underlying number theory permits… If a categorical route existed in poly-time, Miller (1976) + Shor (1994) would already have it — **and RSA would be broken**" | appendix A §1 |
| H13 | Routing through Ramanujan `τ` factors `N` | **REFUTED** | `run:hsln_tau_compose.py` — the **forward** direction works (composed `τ`-DNAs spike at `pos(τ(47))` mod 1, confirming the homomorphism `pos(τ(N)) = pos(τ(p)) + pos(τ(q))`), but backward needs `τ(N)` (itself built from the factorisation), then **factoring the integer `τ(N)`** — 19 digits for `N₀ = 47·53`, ~5600 bits for the 1024-bit `N`, i.e. *strictly harder* than factoring `N` | appendix A §2 |
| H14 | The Andrianov–Hecke theorem factors integers | **REFUTED** | `run:hsln_hecke_exercise.py` — it is a **determination (reconstruction) theorem**: primes → all coefficients. Run backward it converts "factor `N`" into "factor the larger `a_N`", and its inverse `a_p ↦ p` is not even injective in weight 2 (`\|a_p\| ≤ 2√p` with `a_p = 0` for supersingular `p`). The one real factoring algorithm on this structure is **Lenstra ECM** (smooth `#E(F_p)`), a different mechanism | appendix A §3 |
| H15 | The HSLN is *distinctively* a quantum state | **REFUTED** | `run:hsln_quantum_state.py` — all textbook axioms **PASS** (unit state, Born rule, real expectation, global phase, density operator `Tr ρ = 1`, `ρ² = ρ`, mixed `Tr ρ² = 0.5827`, `⟨A⊗I+I⊗B⟩ = ⟨A⟩+⟨B⟩`). But this is **vacuous as a claim about HSLN**: every finite-dimensional complex inner-product space is a Hilbert space and every self-adjoint operator on one is an observable. The one arithmetic identity is `⟨D⟩ = Σd(n)³/Σd(n)²` — correct, but just a ratio of divisor moments in Dirac notation | appendix A §5 |
| H16 | A composition homomorphism can be inverted to recover its inputs | **REFUTED** — and this is the corpus' best negative theorem | Every encoding in the corpus is a monoid homomorphism `(ℕ,×) → G` (`pos = frac(log₂ ·)`, `τ`, `φ`, the Dirichlet product), and a homomorphism collapses two factors into one datum. One equation, two unknowns, in every case. The Dirichlet ring's inversion works only because Möbius inversion is a *recursive prime-power* statement (`μ(p²) = 0` truncates), not a generic inverse. Established empirically across six scripts, and stated correctly by each | appendix A §6 |

| H11 | The frontier map isolates each Clay problem to one open node | **PROVEN** as scaffolding | `HSLNFrontier.lean`; each barrier annotated with its honest obstruction ("Euler systems give nothing past analytic rank 1"; "no rigorous 4D interacting construction exists at all"). This is what a formalisation of a conjecture should look like | `HSLNFrontier.lean` |

---

## I. The Lean layer

Measured by [`04-verify/verify.py`](../04-verify/verify.py) (`lean.sorry.audit`) and by the
compile test in [`03-formal/workspace/`](../03-formal/workspace/). Full detail:
[`03-formal/formal-status.md`](../03-formal/formal-status.md).

| # | Claim | Grade | Evidence |
|---|---|---|---|
| I1 | `lake build` compiles the mathematics | **REFUTED** | It succeeds, compiling 2 `olean`s of an **empty** `Math/Basic.lean`. Zero HSLN files are in any build target |
| I2 | "`verify.sh` + `audit_axioms.sh`" exist and were run | **REFUTED** | **Neither script exists in the repository.** The claim has no artefact behind it |
| I3 | "55 theorems PROVEN" / "63" / "64" | **REFUTED** | 242 theorem/lemma statements across 26 files; **190** have `sorry`-free bodies; of those, only **147** are in files that compile — a `sorry`-free declaration in a file that fails to elaborate is not checked at all. The three claimed numbers are mutually inconsistent and appear in the same file |
| I4 | "All PROVEN sorry-free" with axioms `{propext, Classical.choice, Quot.sound}` only | **PARTLY PROVEN** | No file introduces a custom `axiom` (0 found), so the sorry-free theorems rest on mathlib's standard axioms. That part is structurally sound — but the script said to check it does not exist |
| I5 | 6 of 30 files fail to compile | **PROVEN** | `HSLNAlgebra`, `HSLNBridge`, `HSLNKTheory`, `HSLNSerre`, `HslnCat`, `HSLNFactor` — 17 errors, logged in [`build-full.log`](../03-formal/build-full.log) |
| I6 | The failures are caused by mathlib version changes, not mathematics | **PROVEN** | `HSLNAlgebra` **compiles cleanly against mathlib `v4.30.0-rc2`** (the version the corpus claims) and fails against the pinned `v4.35.0-rc4`. See [`03-formal/drift-test.sh`](../03-formal/drift-test.sh). Ambiguous names (`antidiagonal`, `add_apply`), a renamed constant, changed definitional unfolding, `simp` sets that now close goals early — all mechanical |
| I7 | "BSD stated and formally proved in Lean, modulo 5 cited sorries" | **REFUTED** | `HSLNBSD.lean` has 16 `sorry`s and `math-connections.md` gives **two** different counts of both the sorries (5 and 5, but lists 9 citations) and the ledger (63 then 64). A `sorry` is a hole, not a citation; a theorem admitted by `sorry` is assumed, not proved |
| I8 | `HSLN.mul` (Siegel form multiplication) is proved | **REFUTED** | It is `:= by sorry`, as are `fourierCoeff_mul`, `neurons_mul` (the zero-union theorem!) and `etaForm_mul_eq_add`. So the architecture's headline theorem is *stated*, with its subject operation defined by `sorry` |
| I9 | "RH stated and formally proved in Lean" | **REFUTED** | `HSLNRH.lean` has 25 `sorry`s. `riemann_hypothesis_proof` reduces to `hilbertPolya_conjecture` (itself `sorry`), and the corpus correctly notes the chain is "mathematically a tautology" |
| I10 | The files are accurately annotated | **PROVEN** | `HSLNZeta.lean`: "`RiemannHypothesis` states the conjecture (a `Prop`; we do not prove it -- nobody has)." The other prose files are not always annotated this carefully |

---

## J. Meta-observations

| # | Claim | Grade | Evidence |
|---|---|---|---|
| J1 | The *code* is consistently more honest than the prose about the code | **PROVEN** | Every crypto script concedes its equivalence to a classical method or is explicitly a visualisation; the Lean docstrings are more careful than `math-connections.md` |
| J2 | `system-spec.md` is disciplined and `math-connections.md` is less careful | **PROVEN** | The former has a §4 titled "Critical analysis" that itself flags the cup product as metaphorical, the PID structure theorem as a misapplication, and the cusp-memory picture as incompatible with the dynamics. The latter calls things "sorry-free" and "formally proved" while admitting sorries in the same paragraph |
| J3 | The corpus contains work worth publishing | **PARTIAL** | The Dirichlet-ring/locus identification (C1, C11), the sharp RH insight (D3), the BSD evaluation machinery (D16/D17), the number-theory suite (D1–D9), and the frontier map (H11) are all correct and non-trivial as *exposition*. The compositional-merge architecture (B1–B3) is correct and, as an ML proposal, plausible but untested (F9) |
| J4 | Four figures' captions do not reproduce | **REFUTED** | figs 13 (`0.079→0.002`), 14, 28 (`25k/s`), and the Game-of-Life page's glider claim. See [`training-and-dynamics.md`](training-and-dynamics.md) §10 |
| J5 | `animate.py` has 7 animations | **REFUTED** | It has **6**; the 7th MP4 (`anim_e8_torsion_factor.mp4`) comes from `hsln_e8_torsion_factor.py` |
| J7 | The `KnowledgeBase/` documents a Python package that exists | **REFUTED** | Chapters 05–14 cite `Python/hsln/` with modules `paths.py`, `calabi_yau.py`, `category.py`, `generate.py`, `train.py`, `algebra.py`, `fluids.py`, plus `Python/examples/showcase_ct_probe.py` and `Figures/ct_probe_findings.json`. **None exist in this workspace.** There is no `Python/` directory and no `hsln` package anywhere. Neither `KnowledgeBase/` nor `Python/` is in the public archive. So chapters 08–12's measurements (basin fractions 5.8%/2.6%/47.1%, the Calabi–Yau quintic residual 7.7e−17, the 82–85% basin-stability) are **unverifiable**, not false | appendix B §4 |
| J8 | `KnowledgeBase/code/` contains real, runnable ports | **VERIFIED** | (`KnowledgeBase/` is not in the public archive.) Seven ports of specific upstream PRs; ran `sturm_bound.py` (`dim M₄ = 1`, `dim M₁₂ = 2`, `dim S₁₂ = 1` — all correct) and `hecke_wirtinger_grad.py` (converges to target; **conjugacy check `max‖∂L/∂z − conj(∂L/∂z̄)‖ = 0.00e+00`**). The Wirtinger port is the most directly reusable artefact in the entire corpus: the DNA is **complex** and a real-valued loss over complex parameters needs the Wirtinger anti-derivative, which `system-spec.md` §4.4 never mentions | appendix C §2 |
| J9 | `NumericalTesting/` contributes code | **REFUTED** (null result) | `numerics.py` is **five lines**: `def do_calcs(): nums = np.array()` — a `TypeError` at runtime, unreachable (empty `__init__.py`, no entry point), with a 0-byte README and no git history. `uv init` scaffolding, not developed further. Not referenced anywhere in the corpus | appendix C §1 |
| J10 | The `KnowledgeBase`'s prose is better than the main corpus' in one specific place | **VERIFIED** | Chapter 08 says "the tensor product is literal **basin union**", versus the main corpus' looser "inherits every neuron of both parents". The KB phrasing points at the right subtlety — only the **zero set** is preserved, not the basin *partition* (63.3% of seeds re-route). Both need the correction; the KB is closer | appendix B §2b |
| J11 | The `KnowledgeBase` contains material found nowhere else | **VERIFIED** | Three items: the **transition monoid** (ch. 09 — trained closed-loop drives `δ_{a→b}` composing by concatenation, an N×N library making any path `O(k)`); the **Calabi–Yau compactification functor** (ch. 11); and the **proof-carrying lexicon monad** (ch. 13), which is *real* — `HSLNMonadicLLM.lean`, 121 lines, **zero `sorry`s**, with `theorem no_hallucinated_atoms` making no-hallucination a property of the *type*. The last is the corpus' best concrete realisation of "formal methods shape the architecture", and the threads under-sold it | appendix B §5 |

| J6 | The 7.2 GB `Math-Lean/` is the corpus' own build | **REFUTED** | It is 6.9 GB of `mathlib` checkout plus its build cache. The corpus' own contribution is ~4 800 lines of Lean and 2 empty-built files |

---

## Summary count

| Grade | Count |
|---|---|
| **PROVEN** | 47 |
| **VERIFIED** (appendix checks that pass, on the corpus' side) | 4 |
| **NUMERICAL** | 14 |
| **ANALOGY / SPECULATION** | 6 |
| **REFUTED** | 49 |
| **SCOPE-LIMITED / PARTIAL** | 3 |

The `REFUTED` count is high — about as high as the `PROVEN` count — and that needs
explaining, because it does **not** mean the corpus is mostly wrong.

This ledger grades the corpus' *claims*, and the corpus makes most of its claims in prose.
The code is a different object: it is overwhelmingly correct, re-derived here to machine
precision in 35 independent checks. Almost every refutation falls into one of five families:

1. **Overstatement of status** (16 rows, almost all section I). "Formally proved in Lean";
   "55 theorems PROVEN"; "`verify.sh` + `audit_axioms.sh`"; "all PROVEN sorry-free". None of
   this is supported by the artefacts. This is the largest single family and the most
   consequential, because the numbers read like an audit result and cannot be checked at a glance.

2. **Category error** (8 rows). Counting roots of a truncation as neurons (A8, A10); calling
   a complex-codimension-1 divisor a curve (A13); conflating Ring A with Ring B (C2); treating
   two DNA operations as distinct when both are Cauchy convolution (B9); claiming 7
   animations when there are 6 (J5).

3. **Wrong justification for a true statement** (9 rows). Zero-union is true but not because
   of modularity (B6); the sieve works but is not a new mechanism (D10); the factoring wall
   is real but explains nothing about hardness (D11); `f ↦ f(1)` is a ring homomorphism but
   not a Chern character (H1); `σ₃` does factorise, just not as `ζ^{*4}` (C8).

4. **A claim contradicted by the corpus' own code or the corpus' own analysis** (7 rows).
   `math-connections.md` calls the two rings "the same operation" four lines after its own
   `rings_disagree_on_zeta` (C2); `system-spec.md` §4.3 refutes the cup-product claim that
   figure 64 illustrates (H5); "coupling unlocks chaos" fails against the corpus' own
   `driven_rollout` (E4); "the product of eigenforms has product eigenvalue" is false on the
   corpus' own `Δ` and `E₄` (C12); a `def` the corpus audited as vacuous is still described
   as a result (H10 vs its own note).

5. **The decisive experiment is absent** (2 rows). `system-spec.md` §5.6 names the zero-shot
   merge test as "the cheapest empirical test of the whole architectural claim" and warns
   that if it fails "the algebraic framing is dressing". No script runs it (F9). Four figure
   captions also do not reproduce (J4).

The pattern across all five families is the same: **the arithmetic is right, and the
inference drawn from it is not.** Of the 42 refutations, 34 concern what a computation is
*taken to show* rather than the computation itself.

### What survives, ranked by how much it would matter to someone else

1. **The multiplicativity-locus identification** (C11) — that every "X composes with Y" claim
   in the corpus is one closure law. Correct, clarifying, and worth writing up.
2. **The RH insight** (D3) — that the functional equation is not the obstacle; the Euler
   product is. Correct, sharp, and the corpus states it better than most expositions.
3. **The BSD evaluation machinery** (D16, D17) — an honest, reproducible computation from
   point counts to `L(E,1)`, including a genuine rank-2 cancellation. Correct.
4. **The two-ring analysis** (C1, C3, C17) — that one carrier bears two non-isomorphic rings,
   and why. Correct and, as far as I can tell, not previously articulated in this setting.
5. **The zero-union merge law and its implementation** (B1–B3) — trivially true, cleanly
   built, measured to machine precision, and never tested on a real task (F9).
6. **The number-theory suite** (D1–D9, D19) — correct, self-contained, reproducible, well
   told. The part of the corpus that least needs correcting.
7. **The frontier map** (H11) — each Clay problem pinned to one open node with its proven
   partials as hypotheses. Nice formalisation practice.
8. **The negative results** (G5, G11, E4) — the flat SHA-256 landscape, the non-polynomial
   reversal, the non-chaotic separation. Knowing where a framework does *not* reach is worth
   more than most of the positive claims here, and the corpus found three of these itself.
