# The Story

*What the June 2026 files contain, told in the order the ideas depend on each other. The files are archived unchanged in [rmorleysmith/hsln-archive](https://github.com/rmorleysmith/hsln-archive).*

---

## 0. The starting point: a landscape whose minima are roots

Take a holomorphic function `F : ℍ → ℂ` on the upper half-plane. Consider the "energy"

```
E(τ) = |F(τ)|².
```

The **minimum-modulus principle** says that a non-constant holomorphic function has no
interior minimum of `|F|` — every value `|F(τ₀)|` has smaller values arbitrarily nearby —
*unless* `F(τ₀) = 0`. Equivalently, `log|F|` is harmonic away from the zeros. So the only
local minima of `E` are the zeros of `F`, and conversely every zero is a local minimum.

This is the whole architectural seed: **write down a holomorphic function, and its zero
set becomes a set of stable attractors for the gradient flow**

```
τ̇ = −α ∇E(τ).
```

Nothing about modular forms is needed for this step. Any holomorphic `F` gives a reservoir
with a discrete attractor set. What the choice of `F` buys you is *structure*, and the
June files' bet is that modular forms buy exactly the right structure.

> **Grade: PROVEN.** Elementary complex analysis, correctly applied. `system-spec.md` §2.4
> states it, and it holds.

## 1. Why modular forms, and where E8 enters

Three properties of a modular form `F` are load-bearing:

**(a) Finite description.** A modular form is *determined by finitely many* Fourier
coefficients. This is the **Sturm bound**: if `f, g ∈ M_k(Γ)` agree on the first
`⌊k · vol/12⌋ + 1` coefficients, then `f = g`. So a finite coefficient vector ("the DNA")
specifies the entire infinite landscape. This is what makes it a trainable object with
finitely many parameters rather than a function space.

**(b) A graded ring.** Modular forms of all weights form a graded `ℂ`-algebra under
pointwise multiplication: `M_{k₁} · M_{k₂} ⊆ M_{k₁+k₂}`. So two landscapes can be combined
into a third, exactly, with a predictable weight.

**(c) A zero-union law.** Because `(F·G)(τ) = F(τ)G(τ)`, the product vanishes exactly where
either factor vanishes:

```
zeros(F·G) = zeros(F) ∪ zeros(G).
```

That is a **composition law for trained models with a provable guarantee**: train two
models separately, multiply their forms, and the compound provably has *every* attractor of
both parents, plus no new ones. In coefficient terms this is the **Cauchy product**:

```
(a ⋆ b)_n = Σ_{i+j=n} a_i b_j.
```

The June files call this "exact zero-shot model merging", and it is real. Note what it is *not*:
it is not function composition, not sequential stacking, and it does not compose the
*input→output behaviour* of the two models. It unions their attractor sets.

> **Grades:** (a) PROVEN (Sturm 1987). (b) PROVEN (classical). (c) PROVEN, directly from the
> definition of multiplication. The interesting question is whether the union of attractors is
> *useful*, which is an empirical question the June scripts test.

Now, which modular form? The June files pick the one with the most distinguished pedigree:
**the theta series of the E8 lattice.**

```
Θ_{E8}(τ) = Σ_{v ∈ E8} q^{‖v‖²/2},   q = e^{2πiτ}.
```

E8 is the unique even unimodular lattice of rank 8: even means every `‖v‖²` is even, so the
exponents are integers; unimodular means it is its own dual, so Poisson summation turns the
theta series into a weight-`8/2 = 4` modular form. There is a unique such form of level 1
with constant term 1, namely the Eisenstein series

```
E4(τ) = 1 + 240 Σ_{n≥1} σ₃(n) qⁿ,    σ₃(n) = Σ_{d|n} d³,
```

so `Θ_{E8} = E4`. Hence "240 roots of E8" = "240 = a₁", which is where figure 06
comes from. This is a beautiful and entirely classical fact.

> **Grade: PROVEN.** Re-derived here by brute-force lattice enumeration: 240 vectors of
> norm 2, 2160 of norm 4, 6720 of norm 6, matching `240σ₃(n)` exactly, with Gram
> determinant 1.

## 2. What the landscape actually looks like

`E4` has **exactly one zero** in the fundamental domain of `SL₂(ℤ)`, at

```
ρ = e^{2πi/3} = −½ + (√3/2)i,
```

and the valence formula `ord_∞ + ½ord_i + ⅓ord_ρ + Σ ord_τ = k/12` explains why: for
`k = 4` the right side is `1/3`, and an order-1 zero at the elliptic point `ρ` (stabiliser
of order 3) accounts for exactly `1/3`. One attractor, with an order-3 symmetry. `E4(ρ) = 0`
also follows abstractly from the functional equation: `ρ⁻¹ = ρ̄ = ρ − 1`, so
`E4(ρ) = ρ⁴E4(ρ−1) = ρ⁴E4(ρ)` and `ρ⁴ ≠ 1`. Measured here: `|E4(ρ)| = 1.5e−15`.

To get more zeros you must raise the weight (`E6` has a zero at `i`, `E12` at both), or
raise the level, or raise the Siegel degree. The June files do all three, and figures 01–12
are essentially a tour of this.

> **Grade: PROVEN** for the single zero of `E4` and the valence formula. **⚠️ See the
> correction below:** the zero counts in figures 03, 08 and 17 do not come from the valence
> formula.

## 3. The correction that matters: truncation adds roots, not zeros of the form

The June scripts compute zeros with `numpy.roots` applied to the *truncated* `q`-series. That
gives `N` roots for a degree-`N` truncation, and the June files read those counts as the number
of attractors and infer a capacity law ("the count is capped by the DNA length", "tensoring
doubles the neurons", "the live neuron count sweeps 5 → 0 → 5").

This puts two different objects together:

| | roots of the truncated polynomial | zeros of the modular form |
|---|---|---|
| count | = truncation degree `N` | set by the valence formula, `k/12` weighted per fundamental domain |
| location | through the `q`-disk, gathering on `\|q\| = 1` as `N` grows | the `SL₂(ℤ)`-orbit of the true zeros |
| `E4` case | `5, 20, 80, 318` roots in the disk for `N = 5, 20, 80, 320` | exactly one modulo `SL₂(ℤ)`, at `ρ` |

Measured: the smallest root has `|q| = exp(−π√3) ≈ 0.004333421`, the image of `ρ` itself, and
the next roots match further orbit images to nine digits (see the [README](../README.md)). Most
of the remaining roots are effects of the truncation rather than zeros of `E4`.

This matters because several June claims rest on that capacity law, which does not hold:

- "the count is capped by the DNA length (= Sturm bound)": the Sturm bound bounds
  *uniqueness* of the form, not the number of zeros.
- "Tensoring two sectors gives a product with 4 zeros (the union), landing one on each
  target" — a truncated quadratic has 2 roots, so this is a statement about the trained
  polynomial, not about a modular form.
- The `(1,4,11)` proof-of-concept coefficient vector is `c·E4 + newform`: a *combination* of two forms (weight 4, level
  11), not a single newform, and its root count is again a truncation count.

**Does this break the architecture?** No, and this is the important nuance. A gradient flow
on `|F|²` for a trained truncated `F` is a perfectly well-defined reservoir with finitely
many attractors; you can train it, it works, and multiplying two such polynomials still
unions their roots exactly. What changes is the *justification*: the June files argue that
modularity controls capacity and that the coefficient vector is a modular form. In the code it
is the coefficient vector of a polynomial chosen to have a prescribed root set (`dna_from_neurons`
literally runs `np.poly(qs)`). That is a useful and legitimate construction, exactly the "design a potential with chosen
minima" idea, but it is not training a modular form, and the modular structure then
motivates the design rather than carrying it.

> **Grade: REFUTED as stated** for the capacity/finite-generation arguments. The
> architecture survives; the justification does not. A repaired version would either
> (i) constrain the coefficient vector to the true modular subspace (requiring the Sturm bound
> to be respected in its *definition*, not just its length), or (ii) drop the modular
> claim and own the polynomial landscape as the object of study.

## 4. Two rings on the same data, and why that is the deep move

So far the composition law lives in the **Cauchy ring**: the index law is `i + j = n`,
because multiplying power series adds exponents.

The second, and mathematically far more interesting, move in the June files is the observation that
**the same data carries a second, different ring structure**. An arithmetic function
`f : ℕ → ℂ` (with `f(0) = 0`) can be combined by **Dirichlet convolution**

```
(f * g)(n) = Σ_{d·e = n} f(d) g(e),
```

whose index law is *multiplicative*. Under `(+, *)` the arithmetic functions form a
commutative ring, the **Dirichlet ring** — and `*` is exactly the operation that multiplies
Dirichlet series: if `F(s) = Σ f(n)n^{−s}` and `G(s) = Σ g(n)n^{−s}`, then
`(f*g)(n)` are the coefficients of `F(s)G(s)`. This is why the **Euler product** works:
ζ(s) = Σ n^{−s} is the Dirichlet product, over all primes, of the local factors
`(1 − p^{−s})^{−1}`.

The two rings are genuinely different, and the June files give the clean witness:

```
(ζ ⋆ ζ)(1) = 0        (Cauchy: only i+j=1 decompositions are (0,1),(1,0), and ζ(0)=0)
(ζ * ζ)(1) = 1        (Dirichlet: preserves the n=1 value)
```

so `0 ≠ 1` and the rings are non-isomorphic as rings on the same underlying set.

**Why this matters:** it means the June slogan "everything composes" has a precise and
*true* content — but in **Ring B**, not Ring A. The set of **multiplicative** arithmetic
functions `{f : f(1)=1, f(mn)=f(m)f(n) for gcd(m,n)=1}` is closed under Dirichlet
convolution (mathlib's `IsMultiplicative.mul`), so it is a **sub-monoid**. And that closure
is the algebraic skeleton of an enormous amount of number theory:

- the Euler product for ζ, for Dirichlet L-functions, for Dedekind zeta functions, for
  elliptic-curve L-functions;
- abelian Langlands functoriality in the form `ζ · L(s,χ_D) = ζ_K`;
- Rankin–Selberg products staying automorphic;
- Hecke eigenvalues composing multiplicatively.

The "Hecke / Langlands locus" named in the June files *is* this sub-monoid. Naming it is a
real clarification.

> **Grade: PROVEN.** All four identities re-verified exactly: `ζ*μ = δ` (n ≤ 2000),
> `ζ*ζ = d(n)` (n ≤ 3000), `ζ*χ₋₄ = r₂/4` (n ≤ 4000, against brute-force lattice-point
> counts), `log * μ = Λ` (n ≤ 3000), and the Leibniz rule for `D f(n) = f(n)log n`.

## 5. The number theory that falls out

Once you have the Dirichlet ring and named elements, a surprising amount of classical number
theory becomes "compose named coefficient vectors":

| Named vector | Identity | Classical name |
|---|---|---|
| `δ = [1,0,0,…]` | identity | — |
| `ζ = all ones` | `ζ * μ = δ` | Möbius inversion |
| `ζ * ζ` | `= d(n)` | divisor-count function |
| `ζ * χ₋₄` | `= r₂(n)/4` | Jacobi's two-square theorem |
| `ζ * χ₋₃` | `6·(ζ*χ₋₃) = #{(a,b): a²−ab+b² = n}` | Eisenstein norm form |
| `log * μ` | `= Λ(n)` | `−ζ'/ζ = Λ`, the von Mangoldt formula |
| `ζ * χ_D` | `= ζ_K` for abelian K | Dedekind factorisation |

And in the *analytic* direction:

- **Euler product** — composing per-prime factors yields ζ, exactly, for `Re s > 1`. Figure 32
  demonstrates this by recovering `a(n) = 1` for all `n ≤ 48` — correct, because
  each integer factors uniquely.
- **Explicit formula** — the zeros of ζ reconstruct the prime staircase
  `ψ(x) = x − log2π − ½log(1−x^{−2}) − Σ_ρ x^ρ/ρ`. Re-measured here: mean error falls from
  3.54 (50 zeros) to 3.02 (200 zeros). The prime–zero duality is real.
- **Class number formula** — `L(1,χ_D) = 2πh/(w√|D|)`. Re-verified for `D = −3, −4, −7,
  −8, −11` to better than `1e−8`; `L(2,χ₋₄) = G` (Catalan).
- **BSD** — build `L(E,s)` by point-counting `E(𝔽_p)`, compose the Euler factors, evaluate at
  `s = 1`. The pattern is real for the rank-0 curves; the rank-≥1 cases are forced by the sign of the
  functional equation, and `389a1` is a genuine numerical detection of analytic rank 2 (see the
  ledger).
- **GUE statistics** — the zeros' unfolded spacing distribution shows level repulsion
  matching GUE, not Poisson. Statistical evidence for a Hilbert–Pólya operator; not a proof.

The sharpest single insight in the June files is here: **the `s ↦ 1−s` symmetry does not
force RH.** Epstein zeta functions and the Davenport–Heilbronn function satisfy the same
functional equation and have zeros *off* the line, because they lack an Euler product. The
load-bearing ingredient is therefore **multiplicativity** — the primes — and not symmetry.
`HSLNZeta.lean`'s docstring says this clearly.

> **Grades: PROVEN** for all the ring identities and the explicit formula. **NUMERICAL** for
> the GUE statistics, the BSD pattern, and the class number checks. The RH-adjacent material
> is correctly *not* claimed as progress on RH.

## 6. The three June documents, compared

`system-spec.md` is disciplined. Its §4, "Critical analysis", lists what is watertight, what
needs more argument, and what is "speculative / wrong as stated". It names the cup product as
metaphorical, the PID structure theorem as the wrong tool, and the memory-at-the-cusps picture
as incompatible with the dynamics. Those judgements hold up.

`math-connections.md` is a research log written over three days. Its early sections, the triage
table and the composition results, are careful. Later sections describe RH and BSD as
"formally proved in Lean, modulo cited sorries" and give two theorem counts in adjacent
paragraphs (`63 PROVEN`, then `64 PROVEN`). A `sorry` is an unproved step, not a citation, so a
statement closed by `sorry` is not proved. The log also describes one chain of reasoning both as
"mathematically a tautology" and as something more; the first description is right.

The Lean files form a third layer: thirty files with long reference headers, careful
namespaces, and accurate inline notes such as "`RiemannHypothesis` states the conjecture (a
`Prop`; we do not prove it -- nobody has)." In places they are more careful than the prose that
describes them, and six of them do not compile against current Mathlib.

> **Grades:** the *prose* claims about formalisation are REFUTED. The *files* contain real,
> if modest, work, graded per file in [`../03-formal/formal-status.md`](../03-formal/formal-status.md).

## 7. What the June files achieved

Four things stand on their own:

1. **A clean and correct architecture.** "A holomorphic potential on a graded ring gives a
   reservoir whose attractors compose by ring multiplication." That is a legitimate idea,
   stated in `system-spec.md` with precise hypotheses, and it works in the code.

2. **The zero-union merge law, implemented and measured.** Train separately, multiply,
   zero-shot. Verified to machine precision in several scripts (`1.76e−16` in `cm_tensor.py`).
   This is the strongest empirical result in the June files and the clearest claim to novelty
   for machine learning: an ordinary reservoir has no comparable composition law.

3. **The identification of composition with the Euler product.** Recognising that
   "multiply forms" (Ring A) and "multiply L-functions" (Ring B) are *different* products on
   the *same* data, and that the multiplicativity locus is the sub-monoid where they meet, is
   a genuine conceptual clarifying move. And the corollary — that RH's difficulty is
   multiplicativity, not symmetry — is sharp and correct.

4. **A coherent number-theory suite.** The zeta/sieve/factor/explicit-formula
   sequence (figures 31–36) is correct, self-contained, reproducible, and well-told. It is
   the part of the June files that least needs correcting.

The rest of the June files are exploration. The Lean files named after open problems state
those problems and prove conditional or classical consequences. The hashing, key and factoring
probes are negative results, each with a precise reason. The cup-product idea is an analogy that
`system-spec.md` itself sets aside. In several places the vocabulary of the framework clarifies
a classical idea; none of these is a new result.

## 7b. Material that is not in the public archive

`KnowledgeBase/` chapters 05–14 describe a packaged library, `Python/hsln/`, with modules for
paths, Calabi–Yau compactification, categories, generation, training and fluids. Neither the
chapters nor the library are in the public archive, so the measurements they report (basin
fractions of 5.8%, 2.6% and 47.1%, the "5 targets → 4 surviving zeros" result, a Calabi–Yau
quintic residual of `7.7e-17`, 82–85% basin stability under generator flows) cannot be checked
by a reader. They are graded as leads, not findings.

Three ideas appear only there: the **transition monoid** (trained closed-loop drives `δ_{a→b}`
that compose by concatenation, so an N×N library makes any spike path cost `O(k)`), the
**Calabi–Yau compactification functor**, and a **proof-carrying lexicon monad**. The last is in
the archive as `HSLNMonadicLLM.lean`, 121 lines with no `sorry`, whose `no_hallucinated_atoms`
theorem makes "no hallucinated atoms" a property of the type rather than a loss term. It is the
clearest case in the June files of formal methods shaping the architecture.

## 8. Where this goes next

- **Own the polynomial landscape.** The coefficient vector is that of a truncated form; study
  that object directly: a family of potentials with finitely many designed
  minima. The composition law still holds. The Sturm/valence arguments go away and are not
  needed.
- **Test the merge law on a real task.** §5.6 of `system-spec.md` states the decisive
  experiment: train two models on *disjoint* real tasks, multiply, and check that the product
  solves both *without* the products' cross-talk degrading routing. The June results
  (`hsln_dyn.py`, figure 19) show that routing **breaks under tensor products at degree 1**
  while *detection* survives; the direct sum at Siegel degree 2 (figure 20) restores routing.
  That tension is the central design question.
- **Build on the Dirichlet-ring result.** The closure of the multiplicativity locus under
  Dirichlet convolution is a theorem (Mathlib's `IsMultiplicative.mul`), and it is
  the correct algebraic setting for "composition of arithmetic models". Build there.
- **Pick one millennium problem and formalise only what is formalisable.** The Hodge file's
  `hodge_mul` (Hodge classes form a graded subring) and the Yang–Mills `massGap_smul` are
  correct small theorems. Stating the conjecture as a `Prop` and deriving implications is
  defensible. Saying "BSD is a Lean theorem" is not.

---

## Appendix: the June files in their own words

Four quotations that show the range of the documents, from the least careful to the most.

> "**Verify output now reads**: `HSLNBSD.lean compiles — BSD stated and formally proved in
> Lean, modulo 5 cited sorries (Kolyvagin 1988, Gross-Zagier 1986, Nekovář 2006 +
> Dokchitser-Dokchitser 2010, Wiles 1995 + BCDT 2001, BS-D 1965).`"
> — `math-connections.md`

> "5.6 **Verify model merging works.** Train two HSLNs on disjoint tasks, multiply their DNAs
> (Cauchy convolution), confirm the product network solves both — this is the cheapest
> empirical test of the whole architectural claim. *If this fails, the algebraic framing is
> dressing.*"
> — `system-spec.md` §5.6

> "* `RiemannHypothesis` states the conjecture (a `Prop`; we do not prove it -- nobody has)."
> — `Math/HSLNZeta.lean`

> "**Speculative / wrong as stated.** 1. **'Cup product splices trained strands.'** … This
> claim, as stated […], is metaphorical."
> — `system-spec.md` §4.3
