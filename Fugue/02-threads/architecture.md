# The core geometry layer of HSLN — an audit

**Scope.** Only the geometry/arithmetic layer: the E8 theta series, the modular form it
defines, that form's zeros, the flow on `|F|²`, and the genus-2 Siegel generalisation.
Composition algebra, the Dirichlet ring, the Lean corpus and the crypto demos are excluded.

**Sources.** Derived from, and only from: `system-spec.md`,
[`Fugue/README.md`](../README.md), `PythonAndVisualizations/{render.py, e8.py, modular.py,
dna.py, geom.py, siegel.py, hsln.py, coloring.py, style.py}`, and the captions in
`PythonAndVisualizations/figures/index.html`. Every number marked *measured* was re-derived
in `Fugue/.work/run` with `Fugue/04-verify/.venv/bin/python`.
The June files are archived unchanged in `rmorleysmith/hsln-archive` (Lean in `lean.zip`,
scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`).

**Grades.** `PROVEN` = a named classical theorem, correctly applied, or an identity re-derived
exactly. `NUMERICAL` = a measurement, regime stated. `ANALOGY` = resemblance, establishes
nothing. `SPECULATION` = untested. `REFUTED` = asserted and false, incoherent, or unsupported
by the corpus' own artefacts.

---

## 1. The idea in one paragraph

For holomorphic non-constant `F` and any `z₀` with `F(z₀) ≠ 0`, the open mapping theorem maps
a neighbourhood of `z₀` onto a neighbourhood of `F(z₀)`; choosing a value of smaller modulus
there produces a point with `|F| < |F(z₀)|`. Hence **`|F|` has no local minimum away from its
zero set**, so `|F|²` has its minima exactly at the zeros, and `ż = −α∇|F|²` has the zeros — and
only the zeros — as attractors. This is the *minimum-modulus principle* (a corollary of the
maximum-modulus principle), and it is the corpus' sharpest observation: **PROVEN**, and
correctly stated in `system-spec.md` §2.4 and `README.md`. Two riders are usually omitted.
(i) A zero of order `m ≥ 2` makes `∇|F|²` non-Lipschitz there, so the ODE has non-unique
solutions and trajectories arrive in finite time; "attractor" then means less than an
exponentially attracting equilibrium. (ii) The same principle forbids interior local maxima,
so every non-zero critical point of `|F|²` is a saddle: the basin structure is a Morse skeleton,
not smooth wells. Everything else in this layer is an attempt to control *how many* zeros
exist and *where*. On that point both the June files and their later correction in `README.md`
need amending, as §3 shows.

---

## 2. The E8 theta series = E4

**Statement.** With `q = e^{2πiτ}` and `Θ_Λ(τ) = Σ_{v∈Λ} e^{πiτ‖v‖²}`,

$$\Theta_{E_8}(\tau)=1+240q+2160q^2+6720q^3+17520q^4+30240q^5+60480q^6+\cdots=1+240\sum_{n\ge1}\sigma_3(n)q^n=E_4(\tau).$$

**Measured coefficient counts.** Brute-force enumeration of `E8 = ℤ⁸ ∪ (ℤ+½)⁸` with even
coordinate sum, norm-pruned (`e8.e8_vectors`), integer arithmetic, no tolerance:

| `‖v‖²` | count | `240·σ₃(n)` | | `‖v‖²` | count | `240·σ₃(n)` |
|---|---|---|---|---|---|---|
| **2** | **240** | 240 | | 8 | 17520 | 17520 |
| **4** | **2160** | 2160 | | 10 | 30240 | 30240 |
| **6** | **6720** | 6720 | | | | |

So `r_{E8}(2n) = 240σ₃(n)`; the identity `Θ_{E8} = E₄` is **PROVEN** (classical; Conway–Sloane,
*Sphere Packings, Lattices and Groups*).

**The two ingredients of the proof**, exactly as `system-spec.md` §1.2 gives them.

1. **Self-duality + Poisson summation** give `τ ↦ −1/τ`. Unimodularity makes `E8` its own dual,
   so the Poisson sum returns the same lattice with volume factor `vol(E8) = 1`. General form:
   `Θ_{Λ*}(−1/τ) = (τ/i)^{r/2}vol(Λ)^{-1}Θ_Λ(τ)`; with `Λ = Λ*` this is `(τ/i)^{r/2}`.
   **PROVEN** (Poisson summation).
2. **Evenness** gives `τ ↦ τ+1`: `Θ(τ+1) = Σ_v e^{πiτ‖v‖²}e^{πi‖v‖²} = Θ(τ)` because `‖v‖²` is
   even. **PROVEN** — and evenness does double duty: it forces `‖v‖²/2 ∈ ℤ` in `q = e^{2πiτ}`,
   which is what makes the `q`-expansion integral and the form holomorphic at the cusp. An odd
   unimodular lattice (`ℤ⁸`) would give half-integral powers and no level-1 holomorphic form.

`S = (0 −1; 1 0)` and `T = (1 1; 0 1)` generate `SL(2,ℤ)` modulo `±I` (classical), so the two
transformations give modularity.

**Why the weight is `rank/2 = 4`.** The one-variable theta function obeys
`θ(−1/τ) = (τ/i)^{1/2}θ(τ)`, the `1/2` coming from `∫_ℝ e^{−πx²}dx = 1` after rescaling by
`√(τ/i)`. The rank-`r` theta is an `r`-fold product, so the exponent is `r/2`; for `r = 8` the
automorphy factor is `(τ/i)^4 = τ^4` (`i⁴ = 1`), i.e. weight 4 — equivalently `k = r/2` in
`(cτ+d)^k`. Measured: `|E₄(−1/τ) − τ⁴E₄(τ)| = 1.058e−16` at `0.3+0.7i`, `1.303e−16` at
`0.2+0.3i`, exactly `0` at `τ = i`; `E₄(5i) = 1.0000000000054508`. **PROVEN.**

**Why the identity is forced.** `dim_ℂ M₄(SL(2,ℤ)) = 1` (dimension formula; equivalently
`M_* = ℂ[E₄,E₆]`), so `Θ_{E8} = c·E₄`, and the constant term (`v = 0`) gives `c = 1`.
**PROVEN** (graded-ring structure theorem for level 1; Serre, *A Course in Arithmetic*, VII §3).

**REFUTED — the spec's normalisation is wrong.** `system-spec.md` §1.2 writes
`Θ_{E8}(τ) = 1 + 240Σσ₃(n)q^{2n} = 1 + 240q² + 2160q⁴ + 6720q⁶ + ⋯` **with `q = e^{2πiτ}`**.
With its own definition `Θ(τ) = Σ_v e^{πiτ‖v‖²}` and its own `q`, the 240 vectors of norm² 2
contribute `q¹`, not `q²`. The displayed series is `E₄(2τ)`, a form for the conjugate of
`Γ⁰(2)`, **not** for `SL(2,ℤ)`; its zeros sit at `τ ≡ ρ/2`, not at `ρ`. Under the spec's display
both central claims of §1.2 ("equals `E₄`", "weight 4 for `SL(2,ℤ)`") would be false. The code
is right and the prose is wrong: `e8.theta1_coeffs(6) = [1,240,2160,6720,17520,30240,60480]`,
`modular._e4_series` uses `q^n`, `dna.E4_TRUNC = [1,240,2160,6720,17520,30240]`. Every figure
uses `q^n`. This is a documentation defect rather than a computational one, but it matters: a
reader of the prose alone cannot tell which function the figures draw.

---

## 3. The valence formula, and how many neurons exist

### 3.1 The theorem, and the exact count for E₄

**Valence formula.** For `f ∈ M_k(SL(2,ℤ))`, `f ≢ 0`:
`ord_∞(f) + ½ord_i(f) + ⅓ord_ρ(f) + Σ_{τ≠i,ρ}ord_τ(f) = k/12`, `ρ = e^{2πi/3}`.
**PROVEN** (classical: the level-1 residue formula for the divisor of a modular form on
`X(1) ≅ ℙ¹` — Serre, *A Course in Arithmetic*, VII §3; general `Γ`:
`Σ_{τ∈H/Γ}ord_τ(f)/|Stab(τ)| + Σ_cusps ord_σ(f) = k[SL₂(ℤ):Γ]/12`, Shimura). The spec states
it correctly.

**Derivation of the neuron count for E₄, with no numerical input.** `k = 4` gives right side
`1/3`; `E₄(∞) = 1 ≠ 0` gives `ord_∞ = 0`. Multiply by 6:
`3·ord_i(E₄) + 2·ord_ρ(E₄) + 6Σ_{τ≠i,ρ}ord_τ(E₄) = 2`. All three terms are non-negative
integers, so `Σ = 0`, `ord_i = 0`, `ord_ρ = 1`. Hence **`E₄` has exactly one zero in
`ℍ/SL(2,ℤ)`, at `ρ`, and it is simple.** Not a bound — an equality, independent of any
truncation, coefficient or numerical procedure. This is the most important single fact in the
layer, and it is the fact against which the capacity claims of §3.2 have to be measured.

Verified (**NUMERICAL**): `|E₄(ρ)| = 6.7e−16`; `E₄(i) = 1.4557628922687094 ≠ 0`;
`E₄(ρ+ε)/E₄(ρ+10ε) → 0.099974` (ε=1e−3) and `0.09999974` (ε=1e−4), i.e. ratio `0.1` — a
**simple** zero; `|E₄′(ρ)| = 6.0350855689`; the winding number of `E₄` around the fundamental
domain boundary, indented by 1e−3 rad at `ρ` and `i`, is `0.000000` over 25 000 contour points,
so no other zero lies inside `D`. At the other level-1 elliptic points `E₆(i) = −2.2e−16 = 0`
and `E₆(ρ) = 2.8815411 ≠ 0`, and the weight-6 equation `3ord_i + 2ord_ρ + 6Σ = 3` gives
`(ord_i, ord_ρ) = (1,0)`: the two forms split the two elliptic points. The unique neuron sits
at hyperbolic distance `d_ℍ(i,ρ) = ln√3 = 0.5493061443340548` from the disk centre `i`, i.e. at
Cayley radius `|(ρ−i)/(ρ+i)| = 0.2679491924311226 = 2 − √3` (**PROVEN**, elementary hyperbolic
geometry: `d = ln((|z−w̄|+|z−w|)/(|z−w̄|−|z−w|))`).

**Weight-8 sanity check.** `M₈ = ℂ·E₄²` and `k/12 = 2/3`, so `3ord_i + 2ord_ρ + 6Σ = 4` forces
`(ord_i, ord_ρ) = (0,2)`: **`E₄²` has one zero, of order 2, at `ρ`, and nothing else.** Measured:
`E₄(ρ+ε)²/E₄(ρ+10ε)² → 0.01` (double zero), winding number `0.000000`, `E₄²(i) = 2.119246 ≠ 0`.
This matters in §6.

### 3.2 The corpus' capacity claims are void

- `system-spec.md` §2.4: "the valence formula bounds `|N|` per fundamental domain by `≈k/12`".
  **REFUTED.** `k/12` is a *weighted* count — local index `1/3` at `ρ`, `1/2` at `i`, `1`
  elsewhere. For `k = 4` it is `0.333…`, not a number of points. The correct consequence: each
  zero contributes `≥ 1/3`, so `#{distinct interior zeros} ≤ k/4`, equality only when every zero
  sits at `ρ`. `k = 4` gives `≤ 1`, attained. `k = 12`: the level-1 cusp form `Δ` has
  `ord_∞ = 1`, hence `½ord_i + ⅓ord_ρ + Σ = 0`, i.e. **no interior zeros at all**. So
  "increasing `k` … grows the attractor count" fails at the first interesting weight: the
  canonical weight-12 form has zero neurons. Growth in `k` grows the weighted count; the
  cardinality is not monotone.
- `README.md` "the true form has `≈k/12` zeros": **REFUTED** for the same reason — for `E₄` the
  true count is exactly 1, and `1/3` is not approximately 1.
- The "count is capped by the DNA length (= Sturm bound)" claim (`README`, captions, `fig_basins`):
  **REFUTED**, see §3.4. The level-1 weight-4 Sturm bound is **one** coefficient (`⌊4/12⌋+1 = 1`;
  `dim M₄ = 1`), so `E₄` is determined by `a₀ = 1`. The code carries six. There is no cap; the
  count *is* the DNA length.

### 3.3 Why the roots of a truncated `q`-series are not the zeros of the form

`S_N(τ) = Σ_{n≤N} a_n q^n` (`modular.qpoly`, `dna.py`, `hsln.field`). Four statements.

**(a) `S_N` is not a modular form, and it has `N` roots.** For `E₄`, `S_N` is a degree-`N`
polynomial in `q`, so by the **fundamental theorem of algebra** it has exactly `N` roots in `ℂ`
with multiplicity; `E₄` has one zero in `ℍ/SL(2,ℤ)`. The count `N` is the number of Fourier
coefficients, not a property of `E₄`. **PROVEN.**

**(b) A lower bound on `|q|` — and a caution about which theorem applies.** The classical
**Eneström–Kakeya theorem** (1912/13) states: *if* `0 ≤ a₀ ≤ a₁ ≤ ⋯ ≤ a_N`, every zero of
`Σ_{k≤N}a_k q^k` lies in `min_k a_k/a_{k+1} ≤ |q| ≤ max_k a_k/a_{k+1}`. For the partial sums of
`Θ_{E8}` the hypothesis **fails**: `σ₃` is not monotone, the first violation being
`σ₃(24) = 16380 > σ₃(25) = 15751`, and again at `σ₃(40) = 73710 > σ₃(41) = 68922` and
`σ₃(80) = 589806 > σ₃(81) = 551881`. So the sharp-looking `a₀/a₁ = 1/240 = 0.004166667` is *not*
a theorem for this coefficient sequence; it is only the naive first-order estimate from
`1 + 240q = 0`. What is provable is a crude triangle-inequality bound: with `σ₃(n) ≤ ζ(3)n³`,
`Σ_{k≥1}a_k|q|^k ≤ 240ζ(3)Σk³r^k = 240ζ(3)r(1+4r+r²)/(1−r)^4 < 1` for `r ≤ 0.00336`, so `a₀ = 1`
cannot be cancelled and **every root of every partial sum satisfies `|q| > 0.00336`**
(`> 1/298`) — **PROVEN**, but with a constant `1.29×` below the measured value, not `1.04×` below
it. Measured actual minimum: `0.004333421 = e^{−π√3} = |q(ρ)|` at every degree tried, i.e. the
true zero sits just `4.0%` beyond the naive `1/240`. The EK upper bound is unavailable for the
same reason, and the ratios `max_k σ₃(k)/σ₃(k+1)` are `1.069` at the first violation and `1.188`
at `N = 640`, so it would not have proved `|q| < 1` even had the hypothesis held. That every root
lies inside `|q| < 1` is therefore **NUMERICAL** (measured: all `N` roots for `N ≤ 80`; `N−2` at
`N = 320` and `N = 1280`, the rest sitting on the numerical unit circle).

**(c) Roots accumulate at `|q| = 1`.** **Hurwitz's theorem**: if `f_n → f` locally uniformly and
`f ≢ 0`, limit points of the zero sets `Z(f_n)` are zeros of `f`, and each zero of `f` is a limit
of zeros of `f_n`. Here `S_N → E₄` locally uniformly on `|q| < 1` (`σ₃(n) = O(n³)`). **PROVEN**:
limit points of the roots in `|q| < 1` are zeros of `E₄`; roots that do not converge to a zero
must escape every compact set, i.e. run to `|q| = 1`, which is `Im τ = 0` — the real axis, the
boundary of `ℍ` — *not* the cusp (`|q| = 0` is the cusp). Measured: the largest root modulus
grows `0.361` (N=5) → `0.767` (20) → `0.955` (80) → `0.984` (320) → `0.998` (640).

**(d) The corpus' own truncation, measured.** `N`-th partial sum of `Θ_{E8}` (`a₀ = 1`,
`e8.theta1_coeffs(N)`), roots by `np.roots`:

| `N` | roots `|q|<1` | `min|q|` | `max|q|` | `|root − e^{2πiρ}|` | next-smallest `|q|` |
|---|---|---|---|---|---|
| 5 | 5 | 0.004333 | 0.360604 | 1.80e−12 | 0.170401 |
| 20 | 20 | 0.004333 | 0.766989 | 7.2e−18 | 0.163034 |
| 80 | 80 | 0.004333 | 0.955437 | 2.4e−17 | 0.163034 |
| 320 | 318 | 0.004333 | 0.983513 | 4.2e−16 | 0.163034 |
| 640 | 640 | 0.004333 | 0.997791 | 8.1e−16 | 0.163034 |
| 1280 | 1278 | 0.004333 | — | 6.6e−16 | 0.163034 |

(**NUMERICAL.**) The count is `N` except at `N = 320, 1280`, where exactly two roots sit on or
just outside the numerical unit circle (`max|q| = 1.0061` at `N = 320`, `1.0145` at `N = 1280`;
the remaining roots top out at `0.9835` and `0.9999`) — conditioning failure of `np.roots` on a
polynomial whose coefficients span `1` to `9.06e9` at `N = 320` and to `5.85e11` at `N = 1280`,
not mathematics. Those two roots are the *only* ones that fall outside the state space.
`min|q| = e^{−π√3}` at every degree to twelve digits, and the innermost root converges to
`e^{2πiρ}`: **the truncation reproduces the true
neuron to machine precision.** Annulus histogram at `N = 320`: `[0,0.01)`:1, `[0.01,0.1)`:0,
`[0.1,0.5)`:3, `[0.5,0.8)`:6, `[0.8,0.9)`:10, `[0.9,0.95)`:20, `[0.95,0.99)`:278, `[0.99,1)`:0.
The bulk piles up just below the rim, exactly as (c) predicts.

### 3.4 The README's table: quoted, reproduced, and wrong

*In this section "the README" means the first draft of the audit's own README, which carried
these figures; the current [README](../README.md) has the corrected values.*

`README.md` states:

```
N=  5  roots in q-disk =   4   (min |q| = 0.177980)
N= 20  roots in q-disk =  19   (min |q| = 0.169120)
N= 80  roots in q-disk =  79   (min |q| = 0.169120)
N=320  roots in q-disk = 317   (min |q| = 0.169120)   ← |q| at ρ is exp(−π√3) = 0.169141
```

**I reproduce this exactly — if and only if the constant term `a₀ = 1` is dropped.** With
`a₀ = 0` and no other change I measure `N=5`: 4 roots, `min|q| = 0.177980`; `N=20`: 19 and
`0.169120`; `N=80`: 79 and `0.169120`; `N=320`: 317 and `0.169120`. All four rows agree to the
last digit. (With `a₀ = 0` the degree-`N` polynomial has a root at `q = 0`, the cusp, filtered by
`qpoly_zeros`'s `|q| > 1e-12` — that is where `N−1` comes from.) Three corrections follow.

1. **`exp(−π√3) = 0.004333420510`, not `0.169141`** — wrong by a factor of 39.
   `exp(−π√3) = exp(−2π·Im ρ) = |q(ρ)|` in the standard convention that the code uses. The
   README's `0.169120` and `0.169141` agree with each other but with no closed form at `ρ`: two
   separate errors happen to land close together. `0.169141` has no interpretation here — not `e^{−π√3}`, not
   `e^{−π/√3} = 0.163034`, not `2−√3 = 0.267949`.
2. **The full truncation has `N` roots in the disk, not `N−1`, with `min|q| = 0.004333421 =
   e^{−π√3}`.** Deleting `a₀` deletes precisely the coefficient that makes the genuine neuron
   appear: `a₀ = 1` is the term that `240q·…` must cancel at `q = −0.004333`. The README's table,
   computed without `a₀`, therefore does not contain the neuron it sets out to isolate.
3. **The qualitative conclusion survives; the "artefact" framing does not.** See §3.5.

The README's *headline* claim — that the corpus' neuron count comes from `numpy.roots` on a
truncated `q`-polynomial and that a nonzero modular form has finitely many zeros — is **correct
and important**, and is the most valuable correction in the extraction. Its supporting table needs
correcting in both columns, as does its closed form, and the precise picture (§3.5) is more
interesting than either version.

### 3.5 What the roots actually are: the zero set of E₄ is infinite in the `q`-disk

`ℍ/SL(2,ℤ)` has one zero, at `ρ`. But `q = e^{2πiτ}` is injective only on `{0 ≤ Re τ < 1}`, so
the infinite orbit `SL(2,ℤ)·ρ` produces infinitely many distinct points of the `q`-disk. Since
`Im(γρ) = Im(ρ)/|cρ+d|²` and `|cρ+d|² = c²−cd+d² = N_{ℚ(√−3)}(c+dω)` is the hexagonal norm of a
primitive pair, there is an exact closed form:

$$\boxed{\;|q(\gamma\rho)|=\exp\!\Big(-\frac{\pi\sqrt3}{c^2-cd+d^2}\Big)\;}$$

verified by direct construction (each point has `|E₄| ≈ 1e−14`):

| hex norm | predicted | measured root of `S_N` | | hex norm | predicted | measured |
|---|---|---|---|---|---|---|
| 1 | 0.004333421 | 0.004333421 | | 19 (×2) | 0.750970151 | 0.750970149 |
| 3 | 0.163033535 | 0.163033535 | | 21 (×2) | 0.771734890 | 0.771734890 |
| 7 (×2) | 0.459625806 | 0.459625805 | | 37 (×2) | 0.863238026 | 0.863238026 |
| 13 (×2) | 0.657987672 | 0.657987689 | | | | |

**PROVEN** (elementary; the norm identity is the classical `c²−cd+d²` form of `ℚ(√−3)`, and the
norms occurring — `1,3,7,13,19,21,37,…` — are exactly those primitively represented by it, which
is why `4,9,12,16` are absent). So the "zeros of `E₄` in the `q`-disk" are **countably infinite**:
the `q`-images of the single orbit `SL(2,ℤ)·ρ`, moduli `exp(−π√3/N(c+dω))`, accumulating at
`|q| = 1⁻`. Now the diagnostic — evaluate the **true** `E₄` at each root of `S_N`:

- Unrefined, the roots are *not* zeros of `E₄`: at `N = 320` the median `|E₄(root)|` is `7.7e4`,
  the maximum `1.29e9`; `292` of `318` roots have `|E₄| > 0.1`; only `6` have `|E₄| < 1e−6`.
- After **30 Newton steps on the true `E₄`** from each root, `20/20` converge at `N=20`, `76/80`
  at `N=80`, `302/318` at `N=320` (`|E₄| < 1e−8`). Near `|q| → 1` this test is weak (the zeros
  become dense, so almost any point is in some zero's basin); it rules out only the flat claim
  that the roots bear no relation to the form. (**NUMERICAL.**)

So the correct statement is neither the corpus' nor the README's. The corpus'
"neuron count = DNA length, capped by the Sturm bound" is **REFUTED**: the Sturm bound is 1, the
count is `N`, and the count grows because the truncation resolves more and more `q`-images of one
arithmetic point. The README's "`N−1` roots, all but one artefacts" is **partly REFUTED**: at
`N = 320`, 302 roots lie in Newton basins of genuine zeros, the six smallest coincide with exact
orbit images to 9–12 digits, and the whole set is asymptotically distributed over
`{exp(2πiγρ)}`; `N−1` is a `a₀ = 0` artefact of the README's own measurement and `0.169120` is
not the minimum of anything relevant. Correct: `#roots = N` (FTA), `|q| > 0.00336` by a crude
triangle-inequality bound — the sharp-looking `1/240` is **not** available, because the
Eneström–Kakeya hypothesis fails for `σ₃` — limit points are zeros of `E₄` (Hurwitz), the bulk
accumulates at `|q| → 1`
(the real axis), one root converges to the true zero at `ρ` with error `4e−16` at `N = 320`. The
number of *modular* neurons is 1; the number of *state-space* attractors of the truncated
landscape is `N`; and the cluster set of those `N` roots is the `q`-images of that one neuron
together with the rim `|q| = 1`.

### 3.6 The level-11 PoC, for contrast

`dna.LEVEL11_4` carries `a₀…a₅` of LMFDB newform 11.4.a.a (`a₀ = 0`, a cusp form). The level-11
Sturm count is `⌊4·12/12⌋+1 = 5` coefficients (`[SL₂(ℤ):Γ₀(11)] = 12`), so the code carries one
redundant coefficient and the comment ("Sturm bound … is 5") mixes a count with its highest
index. Measured roots in the `q`-disk: degree 3 → 2, degree 4 → 2, degree 5 (the shipped DNA) →
**4** (figure 03's right panel and `Network.zeros()` both report 4). The true constraint is the
`Γ₀(11)` valence formula, `k[SL₂(ℤ):Γ₀(11)]/12 = 4` weighted, with the two cusps absorbing their
orders. The PoC's "4 neurons" and this weighted count of 4 come from two different arithmetic
objects that happen to give the same number. And the
designed DNAs of `dna.dna_from_neurons` are *not* modular at all: they are `Π(q − q_i)`, whose
roots are the prescribed ones by construction — the fundamental theorem of algebra, not a theorem
about modular forms.

---

## 4. The forward dynamics

**The ODE.** `ż = −α∇|F(Z;θ)|² + B u(t)` (`system-spec.md` §2.3), spike readout
`s(t) = 1[1/|F(Z(t))| > ε]` (§2.4).

**Which gradient?** `render._velocity` computes `(vx,vy) = −2α(Re g, −Im g)`, `g = F̄·F′`. Verified
against finite differences that this is the **Euclidean** gradient in `(Re τ, Im τ)`:
`vx = −∂_x|F|²`, `vy = −∂_y|F|²`, agreeing to six decimals at `τ = 0.3+0.7i`. The
**Poincaré-metric** gradient is `y²` times this. A positive conformal factor leaves the *orbits*
unchanged and changes every *time constant*, so the distinction is invisible in the basin pictures
and decisive for the "liquid time constant" and "memory at the cusps" discussions. The June
files do not declare a metric; the figures use the Euclidean one. (**NUMERICAL.**)

**Exact speed law.** For holomorphic `F`, `|∇_E|F|²| = 2|F||F′|`; measured
`|τ̇|/(2|F||F′|) = 1.000000` at four points. Consequences, both opposite to the spec's prose:
`|τ̇| → 0` at every neuron (**critical slowing down** — motion *freezes* on the neurons) and is
largest far from them. Near a simple zero `z₀` the relaxation time is
`τ_relax = 1/(2α|F′(z₀)|²)`; for `E₄`'s neuron, `|E₄′(ρ)| = 6.0350856` gives `τ_relax = 0.013728`
at `α = 1`. **PROVEN** (linearisation) with (**NUMERICAL**) inputs.

**REFUTED — the "liquid time constant" paragraph.** `system-spec.md` §2.3 writes
`τ_eff ∼ 1/α|∇F|²` and glosses it as diverging far from zeros (slow motion there) and contracting
near zeros ("sharp basins"). Either parse of its own formula — `(1/α)|∇F|²` or `1/(α|∇F|²)` — gives the
**opposite** limits: the gradient is largest far from the zeros and vanishes at them, so
`τ_eff` is small (fast) away and diverges (slow) at the zeros. The defensible version:
(i) the linearised relaxation time at a simple zero is the finite `1/(2α|F′(z₀)|²)`;
(ii) it is **not per-neuron tunable** — rescaling the DNA by `c` multiplies every rate by `|c|²`
at once, so the DNA sets one global clock, not a vector of time constants; (iii) a genuine LTC
has a *learnable per-unit gate*, which a fixed landscape does not provide. Grade: **ANALOGY** for the
idea, **REFUTED** as written.

**REFUTED — the implemented readout is not the spec's spike rule.** `render.fig_dynamics` sets
`ε = np.percentile(1/|F| along the trajectory, 88)` — a post-hoc threshold taken from the very
trajectory it is applied to (measured `2850.913`, giving 6 upward crossings, 12.0% of samples
"spiking"). `hsln.spike_map` is `exp(−(m/max(m))²/(2·0.35²))`: a Gaussian in the
**max-normalised** `|F|` over the probe set, not a threshold on `1/|F|`. Both are monotone in
`|F|`, so both peak where `|F|` is smallest, but neither is a model parameter and the spike
*train* is not a function of the model alone. (**NUMERICAL.**)

**REFUTED (quantitatively) — in `fig_dynamics` the landscape term is negligible.**
`dna.dna_from_neurons` normalises the DNA to `max|coeff| = 1`. Measured in the figure's own
strip with that normalisation: `|F| = 3.5e−4 … 7.5e−3` and `α|∇|F|²| = 9.0e−8 … 2.1e−3` at
`α = 0.6`, against `|Bu| = 0.900`. Along the integrated trajectory the landscape term has median
`1.34e−7` and maximum `1.74e−7`, while the drive displaces the state by `|Δτ| = 4.51`; the
trajectory's closest approach to any neuron is `0.3300` at `min|F| = 3.486e−4`. Figure 04's
"reservoir flow" is therefore, to this precision, a driven free particle on `Im τ = 0.18`, and its
"spikes" are 88th-percentile crossings of a `|F|` that stays well away from zero. `render.integrate_paths` does the right thing —
following the *direction* of `−∇|F|²` at unit speed, documenting the reason ("scale-invariant and
stable at any DNA scale") — but unit-speed reparametrisation is not the spec's ODE and removes
the timescale all the LTC/spiking language refers to.

**Gradient flows cannot be chaotic.** `|F|²` is a Lyapunov function: `dE/dt = −α|∇E|² ≤ 0`,
strictly off equilibria. Bounded orbits have `ω`-limit sets inside the equilibrium set and
asymptotic Lyapunov exponents `≤ 0`; no periodic orbits, no attractors other than fixed points.
`index.html`'s "the off-diagonal opens a third dimension, and with it sensitive dependence" is
**REFUTED** for the autonomous flow: at most finite-time separation, which is not chaos. Its
parenthetical that "Poincaré–Bendixson forbids chaos in its 2-D extended phase space" is also
**REFUTED** as applied — with a periodic drive the extended space is 3-dimensional and forced
planar systems are generically chaotic. (I did not audit the script behind figure 22; the
objection is to the stated reason.) No `P–B` is needed for the autonomous case: the Lyapunov
function suffices.

**Smaller note.** The trained figures do not use the 2-real-dimensional state space:
`hsln.field(dna, x, y=LANE_Y)` evaluates `F` on the fixed line `Im τ = 0.18` and
`spike_map(dna, xs)` varies only `Re τ`; `_central_init` places its zeros on that same lane
(`Im τ = 0.18+0.04k`). The "reservoir" of every learned result is 1-dimensional.

---

## 5. Genus 2

**The space.** `ℍ₂ = {Z ∈ Sym₂(ℂ) : Im Z ≻ 0}`, complex dimension `g(g+1)/2 = 3`, real dimension
`g(g+1) = 6`; `Sp(4,ℝ)` acts by `Z ↦ (AZ+B)(CZ+D)^{-1}`. The spec's dimensions are right.
**PROVEN.** The form `Θ^{(2)}_{E8}(Z) = Σ_{v₁,v₂∈E8} exp(πi tr[G(v₁,v₂)Z])` with `G_{ij} = v_i·v_j`
is a Siegel modular form of weight 4 degree 2 for `Sp(4,ℤ)`. **PROVEN** (classical: for an even
unimodular lattice of rank `2k`, `Θ^{(g)}_Λ` is a Siegel form of weight `k` for `Sp(2g,ℤ)` for
every `g`; Freitag, *Siegel modular forms*, LNM 254).

**Codimension — the wording needs care here, because the dimension carries weight.** A holomorphic
function on a complex `d`-fold has a zero set of complex codimension 1 (where it is not
identically zero and the zero is not a critical point): for `g = 2` that is complex dimension 2,
real dimension 4 — a **divisor**, a complex surface, not a curve. `index.html` and
`fig_divisor`'s title call the `g=2` neuron "a curve, not a count"; precisely, it is a divisor
and a curve only *relative to a 2-real-dimensional slice family*. The caption itself is careful
("On each fixed-`w` complex slice … the zero is a point … swept over `w` it traces a curve"), so
the imprecision is in the headline, not the caption. The precise generalisation of the valence
formula, which the June files do not state, is that a weight-`k` Siegel form is a section of
`det(𝔼)^k` on the moduli space of principally polarised abelian `g`-folds, so its zero divisor
lies in the class `k·λ₁` (`λ₁ = c₁(det 𝔼)`, the Hodge class). For `g = 1`, `deg λ₁ = 1/12` and
this *is* the valence formula (`k/12` with the local indices `1/3, 1/2, 1`), so the correct
genus-2 replacement for "how many neurons" is **"what divisor class"**, and the answer is
`4λ₁`. **PROVEN** (standard Hodge-bundle theory). Grade for the framing
as stated: **REFUTED**; and that any count of attractors is the right invariant is **SPECULATION**.

**What `siegel.py` computes, and what it costs.** `representation_numbers(maxn)` enumerates all
`E8` vectors of norm² `≤ maxn`, forms the chunked Gram matrix, and histogrammes
`(a,b,c) = (v₁·v₁, v₁·v₂, v₂·v₂)` with `np.add.at` for exact `r₂(T) = #{(v₁,v₂): G = T}`;
`theta2` sums `r₂(T)exp(iπ tr(TZ))`. The truncation is **exact** for every `T` in the box
`a,c ≤ maxn` (any pair with that Gram has those norms, so it is enumerated), and `|b| ≤ maxn` by
Cauchy–Schwarz. Measured serial single-threaded:

| `maxn` | terms | `#` E8 vectors | time | `max r₂` |
|---|---|---|---|---|
| 2 | 8 | 241 | 0.084 s | 30 240 |
| 4 | 29 | 2 401 | 0.755 s | 1 239 840 |
| 6 | 76 | 9 121 | 5.412 s | 8 467 200 |
| 8 | 161 | 26 641 | 38.429 s | 41 882 400 |
| 10 | 292 | 56 881 | 198.659 s | 97 554 240 |

Cost is roughly quadratic in the vector count, and the vector count grows like `maxn⁴`; the
wall-clock exponent is ≈4 from `maxn=4` to `10`. Evaluating the form is cheap by comparison:
`theta2` with 76 terms on `620×620` takes `2.228 s`; the three genus-2 figures took `95.8 s`
wall-clock, dominated by two `representation_numbers(maxn=8)` calls (38.4 s each) and two
200-slice divisor sweeps. So genus 2 is expensive but not blocked for any deep reason — it is a
`Σ_T r₂(T)e^{iπ tr(TZ)}` sum whose coefficients cost `O(|Λ_{≤M}|²)` to tabulate, with no
differentiation, no Hecke operators and no truncated series. At `~38 s` per call it is three
orders of magnitude above the `~20 µs` genus-1 forward pass quoted in the corpus' own scaling
figure, and incompatible with a training loop. `system-spec.md` §4.4's "numerically delicate" correctly
anticipates a difficulty; the difficulty is enumeration cost, not conditioning. (**NUMERICAL.**)

**Verified invariants** (all re-derived): `r₂([[2,0],[0,2]]) = 30240 = 240·126` (each `E8` root
is orthogonal to exactly 126 others: 56 at 60°, 126 at 90°, 56 at 120°, 1 antipodal);
`r₂([[2,1],[1,2]]) = 13440 = 240·56` (the 60° pairs). On the diagonal,
`Σ_b r₂([[2j,b],[b,2(n−j)]]) = r_{E8}(2j)r_{E8}(2(n−j))` for all `a,c ≤ 8`, **0 mismatches out of
15**, so `Θ^{(2)}|_{diag(τ₁,τ₂)} = E₄(τ₁)E₄(τ₂)`; the code's own check against the truncated
product gives `9.226e−16`, matching the caption's "verified to 1e−15". **NUMERICAL** (identity
**PROVEN**: the Siegel product formula for `E8 ⊥ E8`, i.e. diagonal `Sp(2,ℤ)×Sp(2,ℤ)`-equivariance).

**The divisor figure, measured.** `render.genus2_divisor_points` builds, per slice `w`, a
degree-`maxn/2 = 8` polynomial in `q` and keeps roots with `0.6 < Im τ < 1.3`. Over 200 slices:
1600 roots, **400** kept — **6 of every 8 roots are discarded**; the picture is a 2-of-8
selection and the caption should say so. On the decoupled slice (`z = 0`) the kept points are
**exactly two per `w`, both at `Im τ = 0.866025 = √3/2`**, constant in `w`, as the factorisation
`E₄(τ)E₄(τ+w) = 0` requires: the apparent *bending* of one branch in the left panel is an
artefact of the oblique 3-D projection, not geometry. On the coupled slice (`z = 0.35`) the
bending is real: `Im τ = 0.967846` at `w = 0`, `0.732669` at `w = ±0.5`, splitting to
`(0.622438, 0.902404)` at `w = ±0.25, ±0.75`, with one point per slice at `w = 0, ±1` and two
elsewhere — the branch genuinely bends and reconnects. So `index.html` is right about the
coupled divisor, and right about the decoupled one while the *rendering* of it misleads.
(**NUMERICAL.**)


---

## 6. Direct sum versus tensor

**(a) Tensor / product on a shared state** (`g = 1`, one coordinate): `F = F_A F_B`, so
`E = |F_A|²|F_B|²` and `∇E = |F_B|²∇|F_A|² + |F_A|²∇|F_B|²`. The zero set is the union —
**PROVEN**, trivially (a product vanishes iff a factor does); this is the real content of
`zeros(F_A F_B) = zeros(F_A) ∪ zeros(F_B)`. The **basins are destroyed**, measurably: with three
neurons in `A`, two in `B`, `dna_from_neurons` DNAs, 864 seeds on a `36×24` grid and
`render.integrate_paths` at unit speed, `A` alone captures `856/864`; `A⊗B` captures `849`, of
which `299` land on an `A`-neuron and `550` on a `B`-neuron. Of the 856 seeds `A` alone sent to an
`A`-neuron, **542 (63.3%)** are sent by `A⊗B` to a `B`-neuron, and among the 299 that still reach
an `A`-neuron the specific attractor changes for 7 (2.3%). "Fixed points survive; basins don't"
(`index.html`, figure 19) is right, and the effect is two-thirds of the seed set.
(**NUMERICAL.**)

**(b) Direct sum / independent coordinates**: `Z = diag(τ₁,τ₂)`, `F = F_A(τ₁)F_B(τ₂)`, so
`τ̇₁ = −α|F_B(τ₂)|²∇₁|F_A(τ₁)|²`, `τ̇₂ = −α|F_A(τ₁)|²∇₂|F_B(τ₂)|²`. Each velocity is the parent
velocity times a **positive scalar depending only on the other coordinate**; hence wherever
`F_A F_B ≠ 0` the `τ₁`-orbits are *exactly* the `A`-orbits up to time reparametrisation, and
**the direct sum preserves each sector's basin partition**: measured with unit-speed integration
per coordinate and two initial `τ₂`, `856/856` captures and **0** destination changes.
(The measurement is a consistency check rather than independent evidence — under per-coordinate
unit speed the `τ₁` trajectory is `A`'s by construction; the mathematics is the factorisation.)
**PROVEN** as an orbit statement.

**Three things "the direct sum decouples the flow" does not say.**

1. **It decouples orbits, not clocks.** Sector `A`'s time constant is multiplied by
   `1/|F_B(τ₂)|²`, which diverges as `B` approaches its own zero. Since
   `∫|F_B(τ₂(t))|²dt < ∞` for a converging `B`-flow, the `τ₁`-displacement *after* `B` settles is
   bounded: `A` and `B` are in a race between `2α|F_A′|²` and `2α|F_B′|²`, and if `B` wins, `τ₁`
   freezes at a value that need not be an `A`-neuron. The claimed "routing error 0.27 → 0.000" is
   thus a property of the corpus' reparametrised integrator, not of the spec's ODE.
   **NEEDS MORE ARGUMENT** — I did not reproduce a failure in a short run (4 time units at 100×
   DNA scaling left both sectors mid-flight), so I report the mechanism, not a counterexample.
2. **The fixed-point set is much larger than the neuron set.** Whenever `F_B(τ₂) = 0` both
   components vanish *for every `τ₁`*, so `{(τ₁,τ₂): F_B(τ₂)=0} ∪ {(τ₁,τ₂): F_A(τ₁)=0} ⊂ Fix(flow)`,
   a 2-real-dimensional continuum of equilibria. Verified: with `τ₂ = 0.40+0.66i` (an exact neuron
   of `B`) and `τ₁` between `0.07` and `0.39` from any `A`-neuron, the joint velocity is
   `(9.6e−46, 2.4e−28)` — zero to floating-point noise. A state can sit still forever at a point
   that is a neuron of *neither* sector. **PROVEN** (one line of algebra, confirmed numerically).
3. **The naming misleads.** The direct sum of lattices gives `Θ_{Λ⊕Λ′} = Θ_Λ·Θ_{Λ′}` — the
   *product* of thetas, i.e. the same Cauchy convolution the corpus calls the "tensor product"
   (its own caption says so). So the two names denote **the same operation on the DNA**; they
   differ only in whether the sector states share a coordinate. Recommend "shared-state product"
   and "independent-coordinate product".

**Two REFUTED claims attach here.** (i) **The merge demonstrations are about polynomials, not
modular forms.** `dna_from_neurons` returns `Π(q − q_i)` renormalised; multiplying two such
polynomials unions their roots by the fundamental theorem of algebra — true, exact, and not a
theorem about modular forms, because the objects multiplied are not modular forms. In the space
the figures claim: at level 1, weight 8, `M₈ = ℂ·E₄²` has **one** zero (double, at `ρ`, verified
above), and at weight 4 **one** zero. `fig_merge` exhibits a merged "weight `k_A+k_B`" form with
2+2 = 4 neurons and `fig_heterotic` a weight-8 product with 4+2 = 6. **No weight-8 level-1
modular form has four zeros**; no weight-4 level-1 form has two. The composition law is exact;
its *reachable* attractor sets are never checked and are severely constrained
(`#{distinct zeros} ≤ k/4` at level 1). This is the largest gap in the architecture: the algebra
composes, but the geometry cannot deliver the attractors being composed. (ii) **`|F|² =
|F_A|²|F_B|²` does not mean the energies add.** The natural two-independent-reservoir object is
`|F_A|² + |F_B|²`, whose flow is the sum of the two flows with no coupling; it is not a modular
object of a single weight (you cannot add weights inside `M₄`, which is 1-dimensional). The
product form buys the union of zeros at the price of the coupling `|F_B|²∇|F_A|²` — multiplicative
factorisation is exactly what produces the cross-terms that change the basins. **ANALOGY** where
the corpus says "the energy factorises so the flow decouples".

---

## 7. What is established, what is numerical, what is not established

### Established (PROVEN)

1. `Θ_{E8} = E₄`, weight 4 level 1, `r_{E8}(2n) = 240σ₃(n)`; two ingredients as the spec says
   (Poisson summation for self-duality ⇒ `τ ↦ −1/τ`; evenness ⇒ `τ ↦ τ+1`); weight `rank/2`;
   uniqueness from `dim M₄ = 1`.
2. `|F|` has no local minimum off its zero set, so the zeros are exactly the attractors of the
   unforced flow (minimum-modulus principle).
3. `E₄` has exactly one zero in `ℍ/SL(2,ℤ)`, at `ρ`, of order 1, from the valence formula alone.
4. `#{distinct interior zeros} ≤ k/4` at level 1, and `= 0` for `Δ` (weight 12).
5. `E₄²` has one double zero at `ρ` and nothing else; `M₈ = ℂ·E₄²`.
6. `S_N` has exactly `N` roots (FTA), all with `|q| > 0.00336` (crude triangle bound; the
   Eneström–Kakeya hypothesis `a_n ≤ a_{n+1}` fails for `σ₃`, first at `n = 24`), and limit points
   of the root sets in the disk are zeros of `E₄` (Hurwitz).
7. The zero set of `E₄` in the `q`-disk is the countable set of `q`-images of `SL(2,ℤ)·ρ`, with
   `|q| = exp(−π√3/(c²−cd+d²))` over primitive `(c,d)`.
8. `zeros(F·G) = zeros(F) ∪ zeros(G)`; the direct-sum flow preserves each sector's orbits up to
   time reparametrisation, with a continuum of spurious equilibria on `{F_A = 0} ∪ {F_B = 0}`.
9. `r₂([[2,0],[0,2]]) = 240·126`, `r₂([[2,1],[1,2]]) = 240·56`, and the diagonal restriction
   factorises as `E₄ ⊗ E₄`.
10. Gradient flows are not chaotic and have no periodic orbits in the autonomous case.
11. A weight-`k` Siegel form has `[Z(F)] = kλ₁`; for `g = 1`, `deg λ₁ = 1/12` recovers the
    valence formula.

### Numerical (measured, regimes stated)

Shell counts `240, 2160, 6720, 17520, 30240` for `‖v‖² = 2,4,6,8,10`. ·
`|E₄(−1/τ) − τ⁴E₄(τ)| ≈ 1.1e−16`; `|E₄(ρ)| = 6.7e−16`; `E₄(i) = 1.4557628922687094`;
`|E₄′(ρ)| = 6.0350855689`; winding number of `E₄` (and `E₄²`) on the indented contour `= 0`;
`d_ℍ(i,ρ) = ln√3`. · The root table of §3.3(d): count `N`, `min|q| = 0.004333421 = e^{−π√3}`,
`max|q| → 0.997791` at `N=640`, innermost root within `4e−16` of `e^{2πiρ}`, annulus histogram. ·
Root diagnostics: unrefined `|E₄(root)|` median `7.7e4` at `N=320`; `302/318` Newton-converge;
two roots numerically on `|q|=1` at `N=320, 1280`. · Genus-2 timings `0.084 → 198.7 s`, term
counts, `theta2` cost, divisor window keeping `400/1600` roots, decoupled branches flat at
`Im τ = √3/2`, coupled branches bending. · Tensor statistics `542/856` re-routed, `299/856`
retained. · Dynamics magnitudes: `α|∇|F|²| ~ 1e−7` vs `|Bu| = 0.9`; `|τ̇| = 2|F||F′|`; threshold
`2850.913`; closest approach `0.3300`.

### Not established

1. **Anything about capacity.** No argument connects the DNA length or the Sturm bound to the
   number of *usable* attractors. For `E₄` the Sturm bound is 1, the truncated landscape has `N`
   attractors, `E₄` has 1 neuron, and nothing relates the three numbers.
2. **Reachability of the merge.** Whether a multiplication of modular forms can realise a
   prescribed attractor set is never posed; at level 1 it cannot for the weights the figures use.
3. **Per-neuron learning.** Nothing shows a neuron can be moved without moving all of them. The
   Implicit Function Theorem of §2.5 gives the local derivative
   `∂Z*/∂a_T = −(∂F/∂Z)^{-1}∂F/∂a_T`, which is local, fails at multiple zeros and on the
   discriminant, and in the truncated model has `N` roots against `N` coefficients — degrees of
   freedom and attractors are locked 1:1, a design feature the June files do not analyse.
4. **The reservoir claim for the trained figures**, which explore a 1-D lane; nothing
   demonstrates learning in 2-D.
5. **Genus-2 dynamics.** The divisor is *drawn*; nothing integrates a flow on it, defines neurons
   from it, or shows the `kλ₁` divisor is reachable by training.

---

## 8. Failure modes and scope limits

1. **The layer's two central objects need to be kept apart: the form, and its partial sum.**
   Every capacity, neuron-count and merging claim is a claim about `Σ_{n≤N}a_nq^n`; the theorems
   invoked (valence formula, Sturm bound) are about `Σ_{n≥0}a_nq^n`. The gap is not technical:
   for `E₄` the first gives `N` attractors and the second gives 1, and no truncation closes it.
   "We are training a modular form" is **REFUTED**; the precise statement is "we are training a
   polynomial whose coefficients are the first `N` coefficients of a modular form, and whose
   zeros are asymptotic to that form's zero orbit".
2. **Some numbers in the specification documents are wrong at points that matter**: the spec's `q^{2n}`
   (§2), its `≈k/12` neurons (§3.2), the README's table and its `exp(−π√3) = 0.169141` (§3.4).
   Two of the three show up as soon as the closed forms are evaluated; the `N−1` count shows up
   only on reading the coefficient array.
3. **The metric is never declared**, and both the "liquid time constant" and "memory at the cusps"
   discussions depend on it. With the Euclidean gradient the real axis is at finite distance and
   trajectories reach it in finite time; with the Poincaré gradient the boundary is at infinity
   and the flow slows there. The spec's §4.3.4 rejects cusp memory for a different reason than
   the metric supplies.
4. **Gradient flow is a weak computational primitive**: no periodic orbits, no chaos, no
   asymptotic sensitivity; every trajectory is transient and ends at a fixed point. The `E₈×E₈` /
   gravity-dial framing treats the flow as an ongoing oscillator, which requires the drive, not
   the geometry.
5. **The figures carrying the architecture are not generated by the spec's dynamics**:
   `integrate_paths` reparametrises to unit speed (documented in the code, and different from the spec's ODE), and
   `fig_dynamics` runs the raw gradient at a DNA scale where the landscape term is `~1e−7`
   against a drive of `0.9`. Quantitative claims extracted from those panels inherit this.
6. **Genus 2 is priced, not blocked**: `38 s` at `maxn = 8` and `199 s` at `maxn = 10`, with
   `O(|Λ|²)` tabulation, rules out training loops, and the divisor picture discards 6 of every 8
   roots. The corpus' own scaling figure ("genus-1 ~20 µs, genus-2 0.1 s → 8 s") is consistent
   with mine in order of magnitude.
7. **Order-≥2 zeros break the ODE and the IFT**: non-unique solutions, finite-time arrival, and a
   singular `∂F/∂Z`. The spec flags the IFT caveat but not the well-posedness failure.
8. **Scope of the positive results.** What survives is narrow and real: the minimum-modulus
   principle; the exact `E₄ = Θ_{E8}` identity; the exact valence count of 1; the exact root law
   `exp(−π√3/N(c+dω))`; the exact union law for zeros under multiplication; the orbit-level
   factorisation of the direct sum. Everything about *learned* behaviour, capacity, merging of
   trained *modular* models, and genus-2 dynamics is untested or refuted. The instinct — that a
   modular form's zeros are a natural, arithmetically structured attractor set — is sound, and the
   arithmetic of `ρ`'s orbit is genuinely elegant. What fails is the bookkeeping that turns that
   fact into a reservoir with a controllable number of neurons.
