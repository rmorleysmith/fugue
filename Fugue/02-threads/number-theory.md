# Number theory by composition: Euler products, root-of-unity sieves, the zeros, L-functions and BSD

> **Status:** The number-theory suite is the most carefully scoped work in the June files: every
> headline claim in it is either a **classical theorem** or a **numerical measurement quoted with its
> regime**, and its own prose repeatedly states the scope limits that matter (fig 32 "does not reach
> the zeros or RH", fig 40 "BSD itself is open", `factor_prime_pair.py` "does NOT break RSA"). Two
> claims go beyond that scope and are corrected below: the caption's "the factoring wall … which is exactly why
> factoring is hard" (fig 33) — the wall is the √N limit of the detector set and says nothing about
> complexity — and the ledger's "**55 theorems PROVEN** … sorry-free" for the Lean companion, which
> is contradicted by **41 code-level `sorry`s** in the corpus' own `HSLN*.lean` files.
> The BSD figure's rank-2 curve **389a1 is correct as the corpus states it**: `w = +1`, rank 2,
> `L(E,1) = 0`; I confirm the corpus' smoothed sum cancels to **8.7×10⁻⁴²** at 40-digit precision,
> so the vanishing is *not* sign-forced. The suspicion that the figure prints `0.306` for 389a1 is
> **not supported by anything in the corpus**: `bsd.py` prints `−0.000000`, and no occurrence of
> `0.306` exists in the corpus outside the vendored `.venv`. The value `0.306` is instead
> `L′(37a1,1) = 0.305999773834` — the BSD leading coefficient of the *rank-1* curve, which no
> script prints. What *is* wrong in the BSD neighbourhood is the **verifier**, not the corpus.
> Separately, the cluster's strongest conceptual claim — that the `s ↦ 1−s` symmetry does **not**
> force RH because the load-bearing ingredient is multiplicativity — is true, and I verify it here
> by exhibiting an off-critical-line zero of the Davenport–Heilbronn function.
> **Evidence grade:** **PROVEN** for the classical backbone (Euler product, unique factorisation,
> von Mangoldt explicit formula, Dirichlet class number formula, Jacobi two-square, Gross–Zagier–
> Kolyvagin, Pollard–Brent complexity); **NUMERICAL** for everything the figures measure;
> **REFUTED** for the "explains why factoring is hard" reading and for the Lean-ledger arithmetic.
> **Corpus artefacts:** scripts `prime_sieve.py`, `zeta_compose.py`, `factorize.py`,
> `landscape.py`, `explicit.py`, `spectral.py`, `lfunctions.py`, `bsd.py`, `zeros.py`,
> `factor_prime_pair.py`, `factor_battery.py`, `factor_via_identities.py`;
> figures `31_prime_sieve.png`, `32_zeta_compose.png`, `33_factorize.png`, `34_spectral.png`,
> `35_explicit.png`, `36_landscape.png`, `39_lfunctions.png`, `40_bsd.png`; author captions in
> `figures/index.html`; narrative `math-connections.md` (line 146);
> Lean `HSLNZeta.lean`, `HSLNFactor.lean`, `HSLNBSD.lean`, `HSLNRH.lean`, `HSLNComplexity.lean`;
> verifier [verify.py](../04-verify/verify.py) and its recorded
> [results.json](../04-verify/results.json).
> The June files are archived unchanged in `rmorleysmith/hsln-archive` (Lean in `lean.zip`,
> scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`).
> **Reproduced here:** yes. All scripts were run from `Fugue/.work/run/` with
> `Fugue/04-verify/.venv/bin/python` (CPython 3.14.4, numpy 2.5.4, mpmath 1.4.1).
> `prime_sieve.py` → 25/25 primes, exact match; `zeta_compose.py` → all coefficients 1 for n ≤ 48;
> `lfunctions.py` → all five special values; `bsd.py` → 389a1 `L(E,1) ≈ −0.000000`;
> `spectral.py` → 104 s; `landscape.py 9000000` → 3.18 s, 602 489 primes; `explicit.py` →
> **killed** by `timeout 900` after 15 m 0.03 s (it asks `zeros.get_zeros(5000)`);
> `factorize.py` → **does not terminate** (trial division to √n ≈ 1.6×10¹⁹), patched variant prints
> its residual; `factor_via_identities.py` → `NameError` at once; `factor_battery.py` → 120 s, no
> factor. Every number quoted below is from those runs or from independent `mpmath` recomputation.

---

## 1. The idea in one paragraph

A **DNA** is a coefficient vector `a = (a₁, a₂, …)`, read either as the `q`-expansion of a modular
form (zeros = the network's neurons) or as the Dirichlet coefficients of an arithmetic function
whose L-function is `Σ aₙ n^{−s}`. Two products live on this data: the **Cauchy** product
`(f⋆g)(n) = Σ_{i+j=n} f(i)g(j)` (multiplying forms = unioning zero sets) and the **Dirichlet**
product `(f∗g)(n) = Σ_{de=n} f(d)g(e)` (multiplying L-functions). The number-theory suite is what
happens when the Dirichlet product is applied to the *primes themselves*: each prime `p` carries a
one-line "little model" — its Euler factor `1/(1−p^{−s})`, with coefficients `1` at the powers of
`p` — and Dirichlet-multiplying all of them rebuilds `ζ(s) = Σ 1/nˢ`, with all coefficients `= 1`,
*because every integer factors uniquely into prime powers*. The same detector idea runs in reverse
(a root-of-unity comb `Σ_k e^{2πikn/p}` is 1 iff `p | n`, so composing combs sieves and dividing
them out factorises), sideways (the completed zeta's `s ↦ 1−s` symmetry, whose fixed axis *is* the
critical line, though symmetry alone cannot force the zeros onto it), into the zeros (the explicit
formula rebuilds the prime staircase from `Σ_ρ x^ρ/ρ`; Montgomery–Odlyzko says the zero gaps look
like a random Hermitian spectrum), and outward (Dirichlet characters, then elliptic curves, give
new "ζ-like" generators in the same ring, with class-number formulas and BSD as the payoffs).

---

## 2. The precise statement

Claims are labelled `C1 … C14` and graded. **PROVEN** means a named classical theorem (or an exactly
re-derived identity); **NUMERICAL** means a measurement in a stated regime.

**C1 (Euler product, `fig 32`). PROVEN.** For `Re s > 1`,
`∏_{p prime} (1 − p^{−s})^{−1} = Σ_{n≥1} n^{−s} = ζ(s)` (Euler, 1737). Coefficientwise: if `E_p`
has Dirichlet coefficients `1_{n=p^k}` then `(∗_{p≤P} E_p)(n) = 1` for every `n` all of whose prime
factors are `≤ P`, and `0` otherwise. The corpus verifies exactly this for `P = 47`, `n ≤ 48`.
*Scope, correctly stated by the corpus itself:* this is the identity **for `Re s > 1`**; the zeros and
RH live in the analytic continuation to `0 < Re s < 1`, which the construction does not touch
(`zeta_compose.py`, lines 19–20).

**C2 (the sieve of Eratosthenes as a detector product, `fig 31`). PROVEN, with a correction.**
Write `F(x) = ∏_{p∈{2,3,5,7}} sin(πx/p)`. Then `F(n) = 0` **iff** some `p ∈ {2,3,5,7}` divides `n`
— note this includes `n = p`, since `sin(π) = 0`. Hence the corpus' printed claim
"prime(n) ⟺ n ∈ {2,3,5,7} OR (n > 1 and F(n) ≠ 0)" is correct as written, and the corrected
statement of the set is
`{primes ≤ 100} = {2,3,5,7} ∪ { n ∈ (7,100] : ∏_{p∈{2,3,5,7}} sin(πn/p) ≠ 0 }`.
The reason it works is the classical `√n` bound: every composite `n ≤ 100` has a prime factor
`≤ √100 = 10`, and the primes `≤ 10` are exactly `{2,3,5,7}`. This is **trial division by
{2,3,5,7}** in disguise, not a new primality test. (The un-corrected form — "the primes are exactly
the survivors of `∏ sin(πx/p)`" — is false at `x = 2,3,5,7`; see §6.)

**C3 (factorising by composition, `fig 33`). PROVEN and trivial.** The per-prime roots-of-unity
detector `D_p(n) = (1/p)Σ_{k=0}^{p−1} e^{2πikn/p}` equals `1` if `p | n` and `0` otherwise
(a geometric sum: `D_p(n) = 1` iff the `p−1` non-unit phases sum to `−1`, which happens iff
`e^{2πin/p} = 1`). Applying detectors and dividing out is trial division. The claim
"complete for every `n < 10000` with primes `≤ 100`" is correct because the least prime factor of a
composite `n` is `≤ √n < 100`. In the *code* the detector set is actually the primes `< 10000`
(1229 of them), so the code is complete for `n < 9973² ≈ 9.9×10⁷` — a mismatch with its own caption
(§6).

**C4 (the "factoring wall"). PROVEN as arithmetic; the *explanatory* reading REFUTED.**
`10403 = 101·103` and `1234567 = 127·9721` are opaque to primes `≤ 100`, because no detector in the
set divides them. That is the whole content: *a detector set can only find factors it contains*.
It is the same `√N` limit as C2, restated. It is **not** an explanation of why factoring is hard:
"factoring is hard" is the complexity-theoretic statement that no polynomial-time algorithm is
known for it — equivalently that the search half of C3 has no `√n`-free replacement — and an
incompleteness statement about one detector set does not touch that. The corpus' Python docstring
says the wall is "the reason the job is hard"
(`factorize.py`, lines 13–16) and the caption says "which is exactly
why factoring is hard"; its Lean companion states the scope correctly.

**C5 (the explicit formula, `fig 35`). PROVEN (von Mangoldt 1895 / Riemann 1859).** For `x > 1` not a
prime power,
`ψ(x) = x − log 2π − ½log(1 − x⁻²) − Σ_ρ x^ρ/ρ`, `ψ(x) = Σ_{p^k ≤ x} log p`, the sum over all
nontrivial zeros `ρ` (paired as `ρ, 1−ρ`; `Σ_ρ` is conditionally convergent, so the statement is a
limit of symmetric truncations). Each conjugate pair `½ ± iγ` contributes
`−2√x·Re[x^{iγ}/(½+iγ)]`, which is exactly what `explicit.py`'s `psi_K` subtracts. At a prime power
the formula converges to the midpoint `(ψ(x⁻)+ψ(x))/2`.

**C6 (GUE statistics of the zeros, `fig 34`). ANALOGY + NUMERICAL, not proof.** Montgomery's pair
correlation conjecture (1973) and Odlyzko's numerics (1987) say the *unfolded* nearest-neighbour
spacings of the `ζ` zeros follow the GUE Wigner surmise `p(s) = (32/π²)s²e^{−4s²/π}` rather than
Poisson `e^{−s}`; equivalently, level repulsion `p(s) → 0` as `s → 0`. What is *proved*: the
pair-correlation statement for the function-field analogue (Rudnick–Sarnak), and that a nonzero
proportion of zeros lie on the line (Hardy 1914; Selberg 1942; Levinson 1974; Conrey 1989;
Conrey–Iwaniec–Soundararajan 2011). What is **not** proved: that the statistics force RH, or that a
self-adjoint operator with these eigenvalues exists (Hilbert–Pólya). `fig 34` is statistical
evidence and the corpus labels it as such.

**C7 (Dirichlet's class number formula, `fig 39`). PROVEN (Dirichlet 1839).** For the primitive
quadratic character `χ_D = (D/·)` of a discriminant `D`:
`L(1,χ_D) = 2πh/(w√|D|)` for `D < 0` (class number `h`, `w` = number of units), `= 2hR/√D` for
`D > 0` (regulator `R`). The corpus checks `D = −4, −3, −7` (imaginary) and `D = 8` (real,
`L(1,χ₈) = log(1+√2)/√2`), and `lfunctions.py` also computes `L(2,χ₋₄) = G` (Catalan's constant),
which is the `s = 2` member of the same family (Dirichlet beta), not a class-number formula.

**C8 (modular arithmetic ⊗ ζ = sums of two squares, `fig 37`/`fig 39`). PROVEN (Jacobi, 1834).**
`r₂(n) = 4Σ_{d|n} χ₋₄(d)`, i.e. `(ζ ∗ χ₋₄)(n) = r₂(n)/4`, so
`ζ(s)·L(s,χ₋₄) = ζ_{ℚ(i)}(s)`, the Dedekind zeta of `ℤ[i]`. Verified by the harness for all
`n ≤ 4000`, no mismatch.

**C9 (the Eisenstein analogue, `fig 39`). PROVEN.** For `K = ℚ(√−3)`,
`r_hex(n) := #{(a,b) ∈ ℤ² : a²−ab+b² = n} = 6·(ζ ∗ χ₋₃)(n)`, i.e. `ζ·L(s,χ₋₃) = ζ_K`; the unit
group has order 6, which is where the 6 comes from. Corrected and verified here for all `n ≤ 1500`
(the harness "refuted" it by searching too small a box; see §6).

**C10 (elliptic curves: the Euler factor and modularity, `fig 40`). PROVEN (Wiles 1995;
Taylor–Wiles 1995; Breuil–Conrad–Diamond–Taylor 2001).** For `E/ℚ` of conductor `N`,
`L(E,s) = Σ aₙ/nˢ = ∏_p (local factor)^{−1}` with `a_p = p+1−#E(𝔽_p)` for `p ∤ N`,
`a_{p^k} = a_p a_{p^{k−1}} − p a_{p^{k−2}}`, and `a_{p^k} = a_p^k` at multiplicative primes; the `aₙ`
are the Fourier coefficients of a weight-2 newform on `Γ₀(N)`. The corpus' point-count `a_p` match
LMFDB newform `11.2.a.a` at 15 primes, including `a₁₁ = 1` at the bad prime.

**C11 (the root number and central vanishing). PROVEN, elementary.** Let
`Λ_E(s) = N^{s/2}(2π)^{−s}Γ(s)L(E,s)` satisfy `Λ_E(s) = w·Λ_E(2−s)` with `w = ±1`. Then
`Λ_E(1) = wΛ_E(1)`, so `w = −1 ⇒ L(E,1) = 0`. This is a one-line linear combination and is what
`HSLNBSD.lean`'s `central_vanishing_of_rootSign_neg` formalises. It is *parity*, not a rank detector.

**C12 (BSD's proven part). PROVEN (Gross–Zagier 1986; Kolyvagin 1989).**
`L(E,1) ≠ 0 ⇒ rank E(ℚ) = 0` (Kolyvagin, for modular `E`, hence all `E/ℚ` by C10), and
`ord_{s=1}L(E,s) ≤ 1 ⇒ analytic rank = algebraic rank` (Gross–Zagier + Kolyvagin). BSD itself,
`ord_{s=1}L(E,s) = rank E(ℚ)`, is **open** — including the rank-2 case below.

**C13 (the smoothed sum and the 389a1 rank-2 case, `fig 40`). PROVEN identity + NUMERICAL check.**
The identity, derived here from the functional equation and valid exactly:
`L(E,1) = (1+w)·S`, `S := Σ_{n≥1} (aₙ/n)·e^{−2πn/√N}`.
*Correct statement for the five curves:*

| curve | N | rank | `w` | status of `L(E,1)` |
|---|---|---|---|---|
| 11a1 | 11 | 0 | **+1** | nonzero, `0.2538418608559107` |
| 14a1 | 14 | 0 | **+1** | nonzero, `0.3302236593444805` |
| 37a1 | 37 | 1 | **−1** | **sign-forced** zero (`(1+w) = 0`) |
| **389a1** | 389 | **2** | **+1** | zero, but **not** sign-forced: `S` cancels to `8.7×10⁻⁴²` |
| 5077a1 | 5077 | 3 | **−1** | sign-forced zero |

The parity rule gives `w = (−1)^{rank}`; rank 2 is even, so `w = +1` for 389a1, and the corpus'
assignment is right. Since `w = +1`, `L(E,1) = 2S` is *not* forced to vanish, so a nonzero `S` would
have contradicted the known rank 2; the sum cancels instead, so this **is** a genuine (numerical)
detection of analytic rank 2. Nothing in the corpus prints `0.306` for 389a1;
the plausible origin of that number is `L′(37a1,1) = 0.305999773834` (see §4.8).

**C14 (the RH insight: symmetry is not enough, multiplicativity is). PROVEN in the literature;
re-verified here.** Let `f` be the Davenport–Heilbronn function
`f(s) = ½(1+iκ)L(s,χ) + ½(1−iκ)L(s,χ̄)` with `χ` the odd character mod 5 and
`|κ| = (√(10−2√5)−2)/(√5−1) = 0.284079043840`, the **sign fixed by self-duality** (I use
`κ = −0.284079…`; see §4.13). Then
(i) `Λ(s) = (5/π)^{(s+1)/2}Γ((s+1)/2) f(s)` satisfies `Λ(1−s) = Λ(s)` — the *same* symmetry axis
`Re s = 1/2` as `ζ`; (ii) `f` has a zero at `s = 0.80851718245664 + 85.699348485378 i`, so
`Re s − ½ = +0.3085 ≠ 0`; (iii) the coefficients `a(n) = Re((1+iκ)χ(n))` are **not multiplicative**
(`a(2)a(3) = −0.0807 ≠ a(6) = 1`), so `f` has **no Euler product**. Hence the functional equation
does not force RH, and the load-bearing extra ingredient is multiplicativity (the primes). This is
the corpus' sharpest claim in the RH section and it survives.

---

## 3. Where it comes from

Each item is a classical theorem being *reused* in a compositional idiom, not a new one.

- **C1** stands on **unique factorisation** (Euclid/Fundamental Theorem of Arithmetic) and
  **Euler's product formula** (Euler, *Variae observationes circa series infinitas*, 1737). The
  mechanism is a bijection: `{n : all prime factors ≤ P} ↔ {finite multisets of primes ≤ P}`, which
  is multiplication's inverse. That bijection is the whole "composition builds integers" story; it is
  not a property of the network.
- **C2/C3** stand on the **√n bound** (if `n` is composite then it has a prime factor `≤ √n`) and on
  the **geometric sum of roots of unity** `Σ_{j<k} ω^j = (ω^k−1)/(ω−1)`, which vanishes unless
  `ω = 1`. `HSLNFactor.lean` formalises exactly this (`detector_eq`, `detector_fires`,
  `factors_revealed`, `semiprime_factors_revealed`) and states the scope correctly: "it is NOT a
  sub-√N algorithm (the detector scans k up to the least factor). No RSA break is claimed."
- **C5** is **Riemann's explicit formula**, in the von Mangoldt form (1895); classical references
  Davenport, *Multiplicative Number Theory* §17, or Ingham, *The Distribution of Prime Numbers*.
- **C6** is **Montgomery's pair-correlation conjecture** (1973) plus **Odlyzko's** computations
  (1987) for the numerics, and **Rudnick–Sarnak** (1996) for the function-field theorem. The
  heuristic bridge to random-matrix theory is **Hilbert–Pólya**'s "the zeros are eigenvalues of a
  self-adjoint operator", which is open — the corpus' own `HSLNWeilPositivity.lean`
  reduction says the same.
- **C7** is **Dirichlet's class number formula** (1839), the analytic class number formula's
  quadratic case.
- **C8** is **Jacobi's two-square theorem** (1834): `r₂(n) = 4∑_{d|n}χ₋₄(d)`. The L-function phrasing
  `ζ·L(s,χ₋₄) = ζ_{ℚ(i)}` is the abelian factorisation of a Dedekind zeta.
- **C9** is the same for `ℚ(√−3)`, the hexagonal norm form; the factor 6 is `|𝒪_K^×|`.
- **C10** is **modularity** (Wiles; Taylor–Wiles; BCDT). The Hasse bound `|a_p| ≤ 2√p`
  (Hasse, 1933–36) is what makes the local factors and the series converge for `Re s > 3/2`.
- **C11** is the functional equation of `Λ_E` (Mordell/Weil for the modular case), and C12 is
  **Gross–Zagier 1986** *Invent. Math.* **84** 225–320 + **Kolyvagin 1989** *Math. USSR-Izv.* **32**
  523–541.
- **C14** is **Davenport–Heilbronn 1936**, "On the zeros of certain Dirichlet series" I–II,
  *J. London Math. Soc.* **11**; the point is standard
  textbook material and is stated in the corpus' own `HSLNZeta.lean` (lines 14–20)
  and `math-connections.md` (line 160). What matters is *why*: the
  functional equation for `Λ(s,χ)` comes from the **weight-½ Jacobi theta modular transformation**
  (Riemann 1859; the metaplectic double cover of `SL₂`, not the `E8` one), and that argument is
  insensitive to whether the series has an Euler product. The Euler product is what makes the
  logarithm of the L-function a sum over prime powers, and only that structure gives the explicit
  formula and its positivity (Weil positivity) from which RH is equivalent to `B(g,g) ≥ 0`.
- **C4's algorithmic counterpart** is **Pollard rho (1975) + Brent's cycle finding (1980)**, the
  `O(N^{1/4})` method implemented in `factor_prime_pair.py`; **Miller 1976** and **RSA 1978** give
  the `φ(N) ↔ factor(N)` equivalence that `factor_via_identities.py` is about, and states correctly.

---

## 4. What the code actually does

### 4.1 `prime_sieve.py` (fig 31)

`field(x) = ∏_{p∈{2,3,5,7}} sin(πx/p)` on integers `2..100`; `found = set(SIEVE) | {n > 7 :
|field(n)| > 1e-9}`; truth by trial division. Printed:

```
composed-field survivors -> primes found (<= 100):
  2  3  5  7  11  13  17  19  23  29  31  37  41  43  47  53  59  61  67  71  73  79  83  89  97
25 found;  true primes <= 100: 25;  match: True
```

Runtime 0.78 s. The `set(SIEVE) |` union is load-bearing: `|F(2)| = 7.9e-17`, `|F(3)| = 1.1e-16`,
`|F(5)| = 8.3e-17`, `|F(7)| = 1.0e-16`, all below any sane threshold, because `sin(π·n/p) = sin(π) = 0`
at `n = p`. Without the union the survivors are the 21 primes in `(7,100]` — the exact number the
verifier reports as a failure.

### 4.2 `zeta_compose.py` (fig 32)

`euler_factor(p)` puts `1` at `n = 1, p, p², …`; `compose_primes` iterates `dirichlet_mul`; the grid
`snaps` shows the integers filling in as primes are added. At `M = 48`:

```
composed 15 per-prime models (primes up to 48).
recovered Dirichlet coefficients a(n) for n=1..48: all ones  -> this is zeta(s) = sum 1/n^s
Euler product over primes<= 48 at s=2: 1.638568
series sum_(n<= 48) 1/n^2:            1.624316
zeta(2) = pi^2/6:                     1.644934
```

Runtime 0.72 s. All 48 coefficients are exactly 1 — this is the `X < P²` statement of C1 (here
`P = 47`, `X = 48`). The two `s = 2` numbers are 0.4 % and 1.3 % low: truncated products/sums, which
is what the md's "both → ζ(2)" means. Nothing here sees the critical strip.

### 4.3 `factorize.py` (fig 33) — why it never finishes

Two independent problems, one fatal.

1. **The detector set is not what the docstring says.** `PRIMES = [p for p in range(2,10000) …]`,
   i.e. the **1229 primes below 10 000**, while the docstring, the figure caption and the print
   statement all say "primes ≤ 100". The print line even emits
   `factoriser using 1229 prime detectors (primes <= 100):` — the count and the label disagree on
   the same line.
2. **`true_factor(n)` is unbounded trial division.** The script's only test input is
   `n = 257456295689219220512995411628663795833` (39 digits), and

   ```
   def true_factor(n):
       facs, m, d = {}, n, 2
       while d * d <= m:   # d runs to isqrt(n)
   ```

   `math.isqrt(n) = 16045444702133350984 ≈ 1.6×10¹⁹`, so the loop wants ~1.6×10¹⁹ iterations of
   39-digit modular arithmetic: ≥ 10¹¹ s (thousands of years) at any plausible rate. Its *result is
   unused* — the line that consumed it is commented out (`# ok = all(...)`) but the call itself was
   left in. **Actual runtime: does not terminate.** I killed it after 600 s; `timeout 900` would
   only have been a longer wait. With that one call replaced by a stub the script completes
   instantly and prints:

   ```
   257456295689219220512995411628663795833 = [257456295689219220512995411628663795833 ?]  (residual … has all prime factors > 100)
   ```

   What the demo shows: the input is divisible by **no prime below 10 000**, so every
   one of the 1229 detectors stays silent and the factoriser returns its input. The script's only
   worked example is therefore a number its own method cannot factor; the smooth examples (`2310`, `9991`) appear
   only inside a hardcoded print string, and the `[matches trial div: no]` tag is a literal. The
   *figure* (fig 33) was produced by an earlier revision whose `_figure()` is now commented out in
   `factorize.py` (lines 80–140); it shows `2310 = 2·3·5·7·11` and
   the wall plot, both correct in substance.

### 4.4 `landscape.py` (fig 36) — measurement

`python landscape.py 9000000`:

```
sieved largest-prime-factor + omega for n <= 9,000,000 in 3.18s
  primes <= 9,000,000: 602,489  (6.69% of integers)
  100-smooth (fully factorable by primes<=100): 2.83%
```

`π(9×10⁶) = 602 489` exactly (a known table value), and 2.83 % matches the md's 2.8 %. The md's
"0.9 s on the M1" is a machine claim; here it is 3.18 s (8.3 s including the figure). The linear
sieve is the classical `Σ_p N/p = N log log N` cost.

The Erdős–Kac panel needs care: the script plots the empirical `ω(n)` histogram against a Gaussian
with the *empirical* mean and standard deviation, `μ = 3.006`, `σ = 1.048` for `n ≤ 9×10⁶`. The
theorem (Erdős–Kac 1940) is about `(ω(n) − log log n)/√(log log n) → N(0,1)`, i.e. for `n` near `N`
the mean is `log log N + B ≈ 3.035` (measured 3.006 ✓) and the standard deviation is
`√(log log N) ≈ 1.665` — **not** 1.048. The empirical `σ` is smaller because the histogram
integrates over all `n ≤ N`, where small `n` have small `ω`. Both numbers are correct as *measurements*;
only the caption's "asymptotically Gaussian, μ≈3.0, σ≈1.05" conflates the sample `σ` with the
theorem's scaling.

### 4.5 `explicit.py` (fig 35) — reproduced only in part

The script calls `get_zeros(5000)`, and `zeros.py` has no cached file for 5000 (only
`zeta_zeros_500.npy` exists), so it computes 5000 `mpmath.zetazero` values from scratch:
`timeout 900 … explicit.py` was **killed after 15 m 0.03 s having printed nothing**. I therefore
re-ran the script's own table with the 500 cached zeros and its own grid `xs = linspace(1.6, 30, 4000)`
(mean `|ψ_true| = 13.9` on that window):

| K zeros | 1 | 2 | 5 | 10 | 20 | 50 | 100 | 200 | 500 |
|---|---|---|---|---|---|---|---|---|---|
| mean \|ψ_K − ψ\|, x∈[1.6, 30] | 0.5836 | 0.4931 | 0.3881 | 0.3558 | 0.2703 | 0.1696 | 0.1145 | **0.0756** | 0.0441 |

The md's "1→10→50→200 zeros … (mean error 0.58→0.08)" reproduces: 0.5836 → 0.0756. The metric is
domain-dependent, though: on the wider window `[1.6, 200]` (where `mean|ψ_true| = 99.1`) the same
code gives 1.4818 (K=1), 0.6806 (K=50), 0.3726 (K=200), 0.2120 (K=500), and the verifier — which
evaluates at `x ∈ {97, 199, 421, 983}` — reports mean `|error|` 3.5446 for 50 zeros and 3.0226 for
200. All three sets are consistent; the truncation error of `ψ` grows like `x^{1/2}` in absolute
terms, so "the zeros reconstruct the primes" is a statement about *relative* accuracy and about a
fixed small window. `psi_K` itself implements C5 correctly (conjugate-pair terms, `x − log2π −
½log(1−x⁻²)`), and the visual in fig 35 does show the staircase tracking the prime powers.

### 4.6 `spectral.py` (fig 34) — measurement, with one over-claimed number

Runtime 104 s wall (9 m 58 s CPU, dominated by `eigvalsh` on a 1500×1500 complex Hermitian matrix).
Printed: `loaded 500 zeta zeros; first: 1/2 + 14.1347i`, `zero spacings: mean 1.000 (target 1.0);
GUE matrix bulk mean 1.000`.

Recomputing the statistics myself from the same cached zeros (unfold
`N(T) = (T/2π)(log(T/2π)−1) + 7/8`, skip the first 20 zeros, normalise spacings to mean 1; 479
spacings):

- `P(s < 0.2)`: data **0.0000**, GUE Wigner **0.0084**, Poisson **0.1813** (the verifier's 1200 zeros
  give 0.0025). Level repulsion (not Poisson) is clear; the observed small-`s` density is *lower*
  than the Wigner surmise, so "follow GUE" is an order-of-magnitude statement, not a fit.
- `KS` statistic: **0.0463** against the GUE Wigner CDF, **0.3260** against the Poisson CDF — GUE
  fits, Poisson is rejected. The verifier's recorded "KS distance to GUE CDF ≈ 0.8840" is a
  **harness bug**: it compares `cdf(v)` to `(i+1)/len(sx)` where `i` indexes only every 10th sorted
  spacing, so its empirical CDF is on the wrong scale.
- Spacing variance: data **0.1416** vs Wigner **0.1782** (and Poisson 1). A ~3σ residual given the
  sample size; plausibly imperfect unfolding on a short window.

So the corpus' claim ("GUE, not Poisson — evidence, not a proof") is supported as an analogy/measurement;
it is not a proof of anything about RH, and the figure's own caption says so.

### 4.7 `lfunctions.py` (fig 39)

Runtime 2.77 s. All four characters are rebuilt from their Euler products
(`L(s,χ) by ∏_p Euler factors == χ(n) : True` for `χ₋₄, χ₋₃, χ₋₇, χ₈`). Partial sums to
`K = 4×10⁶`:

```
L(1,χ₋₄) = π/4           : numerical 0.7853980   target 0.7853982   |err|=1.3e-07
L(1,χ₋₃) = π/(3√3)       : numerical 0.6046000   target 0.6045998   |err|=1.7e-07
L(1,χ₋₇) = π/√7          : numerical 1.1874107   target 1.1874104   |err|=2.5e-07
L(1,χ₈)  = log(1+√2)/√2  : numerical 0.6232252   target 0.6232252   |err|=8.5e-14
L(2,χ₋₄) = G (Catalan)   : numerical 0.9159656   target 0.9159656   |err|=1.2e-14
abelian factorisation ζ * χ₋₃ == r_hex(n)/6 : True
```

The `1e-7` errors are the `1/N` tail of a conditionally convergent series; the two `1e-14` cases are
absolutely convergent. Independently, I evaluated C7 in closed form for `D = −4, −3, −7, −8, −11`
using `L(1,χ_D) = −(1/|D|)Σ_{r=1}^{|D|−1} χ_D(r)ψ(r/|D|)` (digamma; the `log K` divergence cancels
because `Σχ_D(r) = 0`): every value matches `2πh/(w√|D|)` to relative error `≤ 1.7×10⁻²⁶`
(e.g. `D = −11: 0.947225825099482936`). The identity C9 holds for all `n ≤ 1500` once the
representation search box is taken as `√(4n/3)` rather than `√n` (§6).

### 4.8 `bsd.py` (fig 40) — and the 389a1 question

Modularity check, 15/15 primes agreed with LMFDB `11.2.a.a` (`p = 2…47`), including `a₁₁ = 1`, the
bad prime. Then:

```
    11a1  N=  11  w=+1  rank=0  L(E,1) ≈ +0.253842   (> 0)
    14a1  N=  14  w=+1  rank=0  L(E,1) ≈ +0.330224   (> 0)
    37a1  N=  37  w=-1  rank=1  L(E,1) ≈ +0.000000   (≈ 0)
   389a1  N= 389  w=+1  rank=2  L(E,1) ≈ -0.000000   (≈ 0)
  5077a1  N=5077  w=-1  rank=3  L(E,1) ≈ -0.000000   (≈ 0)
```

**There is no `0.306` here.** To settle the question independently I rebuilt every `aₙ` as an exact
integer (point counts on the minimal models, Hecke recurrence at good primes, `a_{p^k} = a_p^k` at
bad primes, 1200 terms) and evaluated `S` at 40 digits with `mpmath`:

| curve | `S` (dps = 40) | `L(E,1) = (1+w)S` | LMFDB/corpus value |
|---|---|---|---|
| 11a1 | `0.126920930428` | `0.253841860856` | `0.25384186085591068…` ✓ (12 digits) |
| 14a1 | `0.165111829672` | `0.330223659344` | `0.3302236593444805` (see below) |
| 37a1 | `0.191888717574` | `0.0` (w = −1) | rank 1, sign-forced zero |
| **389a1** | **`−8.65×10⁻⁴²`** | **`−1.73×10⁻⁴¹`** | **rank 2, `L(E,1) = 0`** |
| 5077a1 | `−0.256318669998` | `0.0` (w = −1) | rank 3, sign-forced zero |

Partial sums for 389a1 show the cancellation settling: `S(60) = 1.36×10⁻⁹`,
`S(120) = −3.66×10⁻¹⁸`, `S(300) = −8.43×10⁻⁴²`, `S(1200) = −8.65×10⁻⁴²`. So `w = +1` does **not**
force the zero, and the sum still vanishes to 41 digits: the corpus' sentence "the rank-2 case 389a1
is the genuinely impressive one — w = +1 doesn't force the zero, yet the sum cancels to numerical
zero because the analytic rank really is 2" is **correct**. (The md's "≈10⁻⁶" is the float64 picture;
at dps = 40 the cancellation is exact to full precision.)

Leading coefficients, from the general-`s` split-integral form of the same identity,
`L(s) = (2π)^s/Γ(s)·Σₙ aₙ[(2πn)^{−s}Γ(s,2πn/√N) + w N^{1−s}(2πn)^{s−2}Γ(2−s,2πn/√N)]`
(sanity-checked at `s = 2` for 11a1 against the direct series):
`L′(37a1,1) = 0.305999773834`; `L″(389a1,1)/2! = 0.759316500288`;
`L‴(5077a1,1)/3! = 1.73185`. **`0.305999773834` is the only "≈0.306" in the neighbourhood, and it
belongs to 37a1 (rank 1), not to 389a1.**

Independent cross-check of 14a1 by a completely different route (period ratio, which BSD predicts to
be `∏c_p/|tors|²`): with `Ω_E = 2∫_{α}^{∞} dt/√((α+t²−β)(α+t²−γ))` (the cubic having been made
square-free-free by `x = α + t²`),
`Ω(11a1) = 1.26920930427955342` and `L(1,11a1)/Ω = 0.2 = 1/5` exactly (this calibrates the routine —
an earlier version of my own script had `b₆ = −80` instead of `−79` and gave 0.200197);
`Ω(14a1) = 1.98134195606688` and

```
L(14a1,1)/Ω = 0.166666666666666667   = 1/6  exactly
Ω/6         = 0.33022365934448053903
```

which is `∏c_p/|tors|² = (2·3)/6²`, the BSD prediction for a rank-0 curve with `w = +1` (consistent
with 14a1's local data: torsion of order 6, Tamagawa numbers 2 and 3). The
level-14 newform coefficients `η(τ)η(2τ)η(7τ)η(14τ)` (computed as a full infinite product) agree
term-for-term with the point-count `aₙ` for `n ≤ 24`, and feed the same smoothed sum
(`2S = 0.33022365934448053903`). **The constant `0.3302229764286006` hardcoded in the verifier for
14a1 is wrong by 6.8×10⁻⁷**; the corpus' own script (`0.330224`) is right.

### 4.9 `zeros.py`

A cache: `get_zeros(N)` loads `zeta_zeros_N.npy` from the script's own directory, else computes
`mp.zetazero(1..N)` and writes it. Two consequences worth recording: the scripts are *not*
self-contained reproductions (the presence/absence of a `.npy` changes runtime by orders of
magnitude), and running `explicit.py` in a fresh directory is what exposes the 5000-zero cost. Only
`zeta_zeros_500.npy` ships.

### 4.10 `factor_prime_pair.py` — classical Pollard–Brent

`pollard_brent` is textbook Brent (random seed `y`, `c`, batch `m = 128`, cumulative-product GCD,
backtracking when `g = N`), with deterministic Miller–Rabin for `n < 3.3×10²⁴`. Measured here
(`sys.argv = 32 40 48 56`):

| bits/prime | N bits | N digits | time | corpus table |
|---|---|---|---|---|
| 32 | 63 | 19 | **0.030 s** | 0.012 s |
| 40 | 80 | 24 | **0.308 s** | 0.323 s |
| 48 | 95 | 29 | **0.654 s** | 6.158 s |
| 56 | 111 | 34 | **31.068 s** | 58.167 s |

The corpus' `O(N^{1/4})` label is right for the *algorithm* (rho finds `p` in `O(√p) = O(N^{1/4})`
steps), but these four timings do not measure it: one random sample per size gives ratios
`10.3×, 2.1×, 47.5×` per 8-bit increase here and `27×, 19×, 9.4×` in the corpus' own table, against
a theoretical `2⁴ = 16×` per 8 bits. Both tables are consistent with `O(N^{1/4})` *in expectation*
and both are far too noisy to demonstrate the exponent. The script's default widths are
`[32, 40, 48, 56, 64]`; 64-bit primes (128-bit `N`) would add minutes to hours, so the md's table
(which stops at 56) is the reproducible part. Nothing here threatens RSA, and the md says so:
"RSA-100 (330-bit) was factored in 1991 with GNFS … modern records sit above RSA-250 (829-bit,
factored 2020)".

### 4.11 `factor_battery.py`

`N` is a **1024-bit, 309-digit** number; only the `pollard_brent(N, 120, seed=3)` probe is enabled
(the trial-division, Fermat, `p−1` and `p+1` probes are commented out, though the closing banner
still lists them). Output: `N probable-prime? False`, `[rho] timed out`, "NO FACTOR FOUND by any
bounded classical method", `total time 120.0s` (2 m 0.16 s wall). Its own conclusion is the
right one: rho at 1024 bits needs ~`2^{128}` steps. The banner's claim to have tried five methods
is inaccurate — the code tried one.

### 4.12 `factor_via_identities.py` — non-functional

`p_true`/`q_true` are commented out (`factor_via_identities.py`, lines 153–159)
but consumed at line 179, so the script dies at once:

```
NameError: name 'p_true' is not defined
```

Its *content* is nonetheless stated correctly: `φ(N) ↔ factor(N)` (Miller 1976; RSA
1978), `μ(N)`, `Λ(N)`, `(ζ∗ζ)(N) = d(N)` all require the divisors, "the bridge identities express the
SAME factoring problem in algebraic form. They don't bypass the search", and "If our identities
reduced factoring, RSA would be broken". Had it run, its `pollard_brent` line on the same 39-digit
`N` as `factorize.py` (no factor below 10⁴) would have run for hours: the timing line is not
achievable.

### 4.13 Independent verification of the RH insight (C14)

Computing `L(s,χ₅)` (odd character mod 5) for complex `s` via
`L(s,χ) = 5^{−s}Σ_{a=1}^{4}χ(a)ζ(s,a/5)` (validated against a direct `10⁵`-term sum at `s = 2`),
`Λ(s) = (5/π)^{(s+1)/2}Γ((s+1)/2)L(s,χ)` satisfies `Λ(s)/Λ(1−s,χ̄) = W` **constant across four
widely separated `s`**, `W = 0.850650808352 + 0.525731112119i = e^{i·0.55357}`, `|W| = 1`. That is
the Riemann-type functional equation for the character. Choosing the sign of `κ` so that
`(1−iκ)/(1+iκ) = W` makes the combination self-dual, and then

```
Λ(1−s)/Λ(s) = 1.0 (+9.1e-16 i), (1.0 −1.8e-16 i), (1.0 +1.0e-16 i)   at s = 0.3+5i, 2+3i, −1.5+2i
zero: s = 0.80851718245664 + 85.699348485378 i     |f(s)| = 3.9e-21     Re s − 1/2 = +0.308517
a(2)a(3) = −0.08070090314928288   vs   a(6) = 1.0   ⇒ not multiplicative
```

So: same functional equation, same symmetry axis, an off-line zero, and no Euler product. (My first
attempt used the opposite `κ` sign and found only on-line zeros through `t = 100`; the sign is fixed
by the root number, and the first off-line zero sits at `Re s ≈ 0.8085`, just outside the
`σ ≤ 0.8` scan window. The corpus' verifier "verified" this claim with `L(−2,χ₋₄) = −2×10¹⁰`, which
is a **trivial** zero at a negative even integer and has nothing to do with the critical strip.)

---

## 5. What is verified and what is not

### Established (theorem, or exactly re-derived)

- **C1** Euler's product / `ζ` from the prime models, coefficientwise exact for `Re s > 1`
  (re-run: all 48 coefficients `= 1`).
- **C2** the sieve identity `F(n) = 0 ⟺ ∃p ∈ {2,3,5,7}, p | n` and the `√n` argument that makes the
  survivors exactly the primes `≤ 100` once `{2,3,5,7}` is unioned in (re-run 25/25).
- **C3/C4** the roots-of-unity detector `D_p(n) = 1_{p|n}` and hence "factorisation by composition"
  is trial division; `101·103` is opaque to a `≤100` detector set. (Proven, and trivial.)
- **C5** the explicit formula in von Mangoldt form; `psi_K` implements it correctly.
- **C7, C8, C9** Dirichlet's class number formula (five discriminants, to `1.7×10⁻²⁶` by digamma;
  to `1e-7`–`1e-14` by partial sums), Jacobi's two-square theorem (`n ≤ 4000`), and the Eisenstein
  analogue `r_hex = 6(ζ∗χ₋₃)` (`n ≤ 1500`).
- **C10, C11, C12** modularity of the five curves as far as `a_p` matching goes; the parity/central-
  vanishing lemma `w = −1 ⇒ L(E,1) = 0`; Kolyvagin's `L(E,1) ≠ 0 ⇒ rank 0` and Gross–Zagier's
  `analytic rank ≤ 1` case (literature).
- **C13's identity** `L(E,1) = (1+w)S`, re-derived here from `Λ_E(s) = wΛ_E(2−s)`, and validated to
  12 digits on 11a1 and to `2×10⁻¹⁶` on the period ratio for 14a1.
- **C14** Davenport–Heilbronn has the same-axis functional equation, no Euler product, and a zero
  at `Re s = 0.80852` (re-verified here to `|f| = 3.9×10⁻²¹`).
- **C4's algorithmic half** — that Pollard rho + Brent is `O(N^{1/4})` and breaks nothing — as a
  complexity statement (literature) and as a working implementation (timings above).

### Numerical only (a measurement, with its regime)

- Sieve/sieve-duality counts (`25/25` primes `≤ 100`; `π(9×10⁶) = 602 489`, 2.83 % 100-smooth in
  3.18 s here).
- The `s = 2` approach of the truncated Euler product (`1.638568`) and series (`1.624316`) to
  `π²/6 = 1.644934` at `M = 48`.
- Explicit-formula reconstruction errors on a stated window: `0.5836 → 0.0756` on `[1.6, 30]` with
  `1 → 200` zeros; `3.5446 → 3.0226` at `x ∈ {97,199,421,983}`.
- Zero-spacing statistics: `P(s<0.2) = 0.0000` vs GUE `0.0084` vs Poisson `0.1813`;
  `KS = 0.0463` (GUE) vs `0.3260` (Poisson); spacing variance `0.1416` vs Wigner `0.1782`.
- Erdős–Kac empirical `μ = 3.006`, `σ = 1.048` for `n ≤ 9×10⁶` (vs the theorem's
  `log log N + B = 3.035`, `√(log log N) = 1.665`).
- `L(E,1)` for the five curves, and the rank-2 cancellation `S(1200) = −8.65×10⁻⁴²`.
- Leading BSD coefficients `L′(37a1,1) = 0.305999773834`, `L″(389a1,1)/2 = 0.759316500288`,
  `L‴(5077a1,1)/6 = 1.73185`.
- Pollard–Brent timings (`0.030 / 0.308 / 0.654 / 31.068 s` for 32/40/48/56-bit primes).
- `factor_battery.py`: 120 s, no factor, on a 309-digit `N`.

### Not established (asserted in prose or by analogy; what would be needed)

- **Any step from C1 to the zeros or RH.** The corpus says so explicitly; the construction lives at
  `Re s > 1`. Analytic continuation past the Euler-product half-plane is required and is not built.
- **RH**, in any form (the Lean `riemann_hypothesis_proof` is a `sorry`; see §6).
- **That the GUE statistics are anything more than an analogy.** Hilbert–Pólya needs an operator;
  `HSLNHilbertPolya.lean`/`HSLNSpectral.lean` construct one *equivalent* to RH, which is a
  restatement, not a proof.
- **BSD beyond analytic rank 1** — including the rank-2 `389a1` case, which is *evidence*, not a
  proof: no result says a numerical vanishing of `S` implies `ord = 2`.
- **The `w = −1` cases as rank detectors.** For 37a1 and 5077a1 the zero is `(1+w)·S` with `1+w = 0`;
  the figure's "BSD pattern" cannot distinguish rank 1 from rank 3 (that needs parity plus the BSD
  leading term), and it detects nothing about rank at all in those two rows.
- **"The factoring wall explains why factoring is hard"** (fig 33 caption) — refuted as a reading.
- **Any complexity-theoretic consequence of the DNA/ring framework.** The corpus'
  `HSLNComplexity.lean` is careful here: `VerificationAsymmetry`
  is a `def : Prop` that is *not* proved for any concrete problem, and the file says "Whether a
  specific composition (factoring, subset-sum, …) realises it is the open combinatorial question."
- **The Lean ledger.** 41 code-level `sorry`s in `HSLN*.lean` (see §6), against a prose claim of
  "55 theorems PROVEN … sorry-free".

---

## 6. Failure modes and scope limits

**(a) "Prime test".** fig 31's caption, "Composition made the prime test a computable reality", can
be read as claiming more than the script does: `∏_{p∈{2,3,5,7}} sin(πx/p)` is the Sieve of
Eratosthenes re-encoded with `√n` trial division. It is *not* a primality test that scales — to
sieve to `N` you need the primes up to `√N`, i.e. the input to the problem. The correct content is
the identity in C2 plus the `√n` bound.

**(b) The factoring wall.** Caption: "a product of primes all > 100 … leaves an irreducible
residual — the factoring wall …, which is exactly why factoring is hard." The first clause is
arithmetic; the second does not follow from it. A set of detectors `≤ 100` failing on `101·103` is a
statement about *that set*. "Factoring is hard" is the statement that no known algorithm runs in
time polynomial in `log N`; the corpus' own `HSLNFactor.lean` states the correct scope ("NOT a
sub-√N algorithm … No RSA break is claimed") and `HSLNComplexity.lean` declines to prove anything
about a specific problem. The Lean files keep the correct scope; the caption does not.

**(c) The docstring/code mismatch in `factorize.py`.** "Using primes <= 100 the factoriser is
COMPLETE for every `n < 100^2 = 10000`" while the code builds the 1229 primes `< 10000`; the print
statement says both "1229 prime detectors" and "(primes <= 100)". The mathematical claim in the md
("With primes ≤ 100 it is complete for every `n < 10000` … smallest prime factor ≤ √n < 100") is
correct as stated; the script implements something else, and its single test input is one no
version of it can factor.

**(d) The `0.306` question — settled.** There is no `0.306` for 389a1 anywhere in the corpus:
`bsd.py` prints `−0.000000`; fig 40's panel C draws a zero-height bar labelled `L(E,1) ≈ 0` under
`rank 2`; `grep -rn "0.306"` over the corpus (excluding `.venv`) returns nothing. The correct
statement is C13's table: 389a1 has `w = +1` (rank 2 is even), so `L(E,1) = 2S` is not sign-forced,
and the measured `S = −8.65×10⁻⁴²` at dps = 40 is a genuine cancellation — the corpus' "genuinely
impressive" framing is earned. The only rank-related errors in the vicinity belong to the
*verifier*: it sets `w = 1 if known != 0 else -1` (so 389a1 gets `w = −1`), and its note asserts
"for rank ≥ 2 (389a1) the root number forces w=−1 here", which is false by parity. `L′(37a1,1) =
0.305999773834` is the likely source of the `0.306` number: it is the rank-1 curve's BSD leading
coefficient.

**(e) The verification artifact is itself unreliable in this cluster.** Re-running
[verify.py](../04-verify/verify.py) in the shipped venv (`/tmp` copy, so as not to overwrite the
delivered [results.json](../04-verify/results.json)) changes verdicts and exposes six harness
bugs:

| check | `results.json` | what the code actually does |
|---|---|---|
| `complexity.sieve.primes` | REFUTED (21 primes) | **harness bug**: the check omits the corpus' `set(SIEVE) ∪ …`; the corpus script prints 25/25. Its own `detail` text agrees with the corpus. |
| `zeta.euler.product` | REFUTED | **non-reproducible**: the shipped body returns VERIFIED now (and its hardcoded `measured` text says "all coefficients = 1", contradicting its own verdict). |
| `L.catalan` | REFUTED, `0.920826404635928` | **harness bug**: `nsum(…, method='d')` = *direct* summation, which stops when the term sequence stagnates; `χ₋₄(even) = 0`, so it returns the **9-term partial sum** `0.9208264046359284`. True value `G = 0.91596559417721901505` (`lfunctions.py` reaches it to 1.2e-14). |
| `L.special.values` | INCONCLUSIVE (`TypeError`) | **environment bug**: this mpmath (1.4.1) has no `mp.kronecker` (AttributeError). The formula is fine — my own Kronecker + digamma gives relative error `≤ 1.7×10⁻²⁶` for all five discriminants. |
| `complexity.factor.wall`, `crypto.scaling` | INCONCLUSIVE (ValueError) | **arity bug**: both bodies `return (verdict, msg, detail, notes, "")` — five items, decorator unpacks four. The intended verdicts would be VERIFIED. |
| `bsd.L1.smoothed.sum` | INCONCLUSIVE | **three bugs**: (i) `ap` is filled only for `p < 400`, so the sum aborts on the first prime factor `> 400` (401 for 11a1) whose weight is `e^{−759}`; (ii) `w` hardcoded by rank-nonzero, wrong for 389a1; (iii) the `known` constant for 14a1 is wrong by `6.8×10⁻⁷`. The recorded detail ("prime 11 not counted") is not what the code prints now ("prime 401 not counted"). |
| `ring.gaussian.hexagonal` | REFUTED, mismatch at `n = 192` | **harness bug**: the representation search box is `B = isqrt(n)+2 = 15`, which misses `(a,b) = (16,8)`; with the correct bound `√(4n/3)` there are **0** mismatches for `n ≤ 1500`. |
| `zeta.symmetry.not.enough` | VERIFIED | the verdict is right but the **evidence is vacuous**: it exhibits `L(−2,χ₋₄) = −2×10¹⁰`, a *trivial* zero at a negative even integer, not a zero in the critical strip. §4.13 supplies a real witness. |
| `bsd.pointcount.modularity` | VERIFIED | the check only tests the Hasse bound `|a_p| ≤ 2√p`; the *claim* ("= newform coefficients") is verified by the corpus' own LMFDB comparison, not by the check. |

Two further global observations: (i) three unrelated verdicts also changed on a fresh run
(`E8.theta.roots` REFUTED→VERIFIED, `compose.two.rings.differ` VERIFIED→INCONCLUSIVE NameError), so
the artifact as shipped is not a faithful record of the shipped code; (ii) `lean.sorry.audit` globs
`Math-Lean/**/*.lean`, which traverses `.lake` and reports **9942 files / 644 `sorry` / 219 `axiom`** —
numbers dominated by mathlib-adjacent *dependencies*, not by the corpus. Its per-file rows do
include the `HSLN*.lean` files, but a raw `\bsorry\b` grep cannot separate a `sorry` tactic from the
word inside a docstring: it reports 3 for `HSLNZeta.lean`, which is in fact code-sorry-free, and 36
for `HSLN.lean`, of which 29 are tactics.

**(f) The "formally proved in Lean" language.** The md says "Machine-checked in Lean (against
mathlib): the completed zeta satisfies `Λ(1−s)=Λ(s)` … (`completedRiemannZeta_one_sub`,
sorry-free)" — **true**: `HSLNZeta.lean` (lines 31–33) is a one-line wrapper
around mathlib and contains no `sorry` tactic. It also says "BSD stated and formally proved in Lean,
modulo 5 cited sorries" and "RH is now a Lean theorem in our framework". Counting `sorry`
*tactics*: **`HSLN.lean` 29, `HSLNBSD.lean` 5, `HSLNRH.lean` 7 — 41 in total**, of which
`birch_swinnerton_dyer_rank` and `riemann_hypothesis_proof` are among them. A `sorry` is a hole, not
a citation: `sorry` adds no axiom, so the corpus' `audit_axioms.sh` criterion
(`{propext, Classical.choice, Quot.sound}`) *cannot detect it*, which is exactly why "55 theorems
PROVEN" looks machine-verified. The ledger also disagrees with itself across three passages of the
same file: "**55 theorems PROVEN**" (§Capstone), "Ledger now: 15 files, **63 PROVEN**", and
"Ledger: **64 PROVEN**". The defensible statement is:

> `HSLNZeta.lean`, `HSLNFactor.lean` and `HSLNComplexity.lean` are sorry-free and prove small true
> things (the `1/2` axis; the roots-of-unity detector identity and its semiprime corollary; `P ⊆ NP`
> and the reduction of `P ≠ NP` to one unproved asymmetry). `HSLNBSD.lean` and `HSLNRH.lean` state
> BSD and RH and derive their conditional consequences, with the open conjecture itself (and the
> cited literature theorems) carried as `sorry`.

**(g) Scope notes on the measurements.** The explicit-formula "mean error" is domain-dependent
(0.08 on `[1.6,30]`, 3.0 at `x ≈ 10³`); the GUE fit is `KS = 0.046` but the spacing *variance* is
`0.142` vs `0.178`, so "follow GUE" should not be read as "fits the Wigner surmise"; the Erdős–Kac
`σ ≈ 1.05` is the sample standard deviation, not `√(log log N) ≈ 1.67`; the four Pollard–Brent
timings are single random samples and do not measure an exponent.

**(h) What the corpus gets right and says so.** `zeta_compose.py`'s docstring: "It does NOT touch
the zeros or RH". `spectral.py`: "Evidence for Hilbert–Pólya; NOT a proof". `bsd.py`: "BSD is open …
the leading-coefficient formula … is also conjectural". `factor_prime_pair.py`: "It does NOT break
RSA". `factor_via_identities.py`: "They don't bypass the search". `HSLNFactor.lean`: "No RSA break is
claimed". These scope statements are why the suite is worth keeping; the exceptions are the two
captions in (a)/(b) and the Lean ledger in (f).

---

## 7. How it connects

**Upstream.** Everything rests on **unique factorisation** and its analytic avatar, **Euler's
product**. Remove multiplicativity and C1, C2, C3, C5, C7–C13 all collapse (C14 is the sharp
statement of that). The DNA/Dirichlet-ring formalism of the sibling thread
[composition-algebra.md](composition-algebra.md) is what supplies the two products;
this whole suite lives in **Ring B** (Dirichlet convolution) — the zero-union law is Ring A and is
*not* used anywhere in figs 31–36, 39–40. Concretely: `dirichlet_mul` is the only operation that
matters here, and it is the multiplication of Dirichlet series.
`HSLNFactor.lean` gives the only machine-checked statement in the
cluster (`detector k N = k` iff `k | N`; a semiprime's prime projections fire exactly on its two
factors).

**Downstream.** The RH thread inherits three things from here: the explicit formula (fig 35), the
spectral target (fig 34), and the symmetry-is-not-enough lesson (C14), which is what makes
**Weil/Li positivity** the correct single open node rather than the functional equation — the corpus
says this itself in `HSLNWeilPositivity.lean`: "any proof
must use the Euler product essentially (Epstein / Davenport–Heilbronn zetas satisfy the functional
equation but have zeros off the line)". The BSD thread inherits the Euler-factor machinery and the
parity lemma; the Lean file's `EllipticL`/`BSDRank`/`StrongBSD`/`ParityConjecture` `Prop`s and its
product-composition theorem (`BSDRank E ∧ BSDRank E' ⇒ BSDRank (E ⊠ E')`) are the formal shadow of
"Dirichlet convolution multiplies L-functions".

**Lateral.** The surprising identifications, all classical, all verified here:
`ζ·L(s,χ₋₄) = ζ_{ℚ(i)}` with `ζ∗χ₋₄ = r₂/4` (Jacobi) — *modular arithmetic composed with the
generator counts lattice points on circles*; `ζ·L(s,χ₋₃) = ζ_{ℚ(√−3)}` with `r_hex = 6(ζ∗χ₋₃)` — the
hexagonal version; `−ζ′/ζ = Λ = log ∗ μ` — the *logarithmic derivative of the generator is the
prime spectrum*, which is why the explicit formula knows about primes at all; and
`L(E,s)·L(E′,s)` sitting in the same multiplicative locus (the Hecke/Langlands sub-monoid), which is
what makes the BSD composition statement formal rather than analogical. The K-theory thread's
`χ(f) = f(1)` is the same observation from the other side: the Dirichlet ring's unique maximal
"augmentation" sees only the `n = 1` coefficient.

---

## 8. Open questions

1. **Does the 389a1 cancellation give a rigorous algorithm?** `S` is a finite, explicitly
   computable sum of length `O(√N)`; the identity `L(E,1) = (1+w)S` is exact. Is there a
   *certified* (interval / rational) version of `S ≈ 0` that would prove analytic rank `≥ 2` for a
   specific curve without BSD? (Kolyvagin's Euler-system machine stops at analytic rank 1, so this
   is exactly the frontier the Lean file names.)
2. **Can the explicit formula's error be made uniform in a window?** The corpus' metric is a mean
   over a fixed small interval; the precise question is the trade-off between `K` (number of zeros),
   the window length, and the relative error, with an explicit unconditional error term.
3. **Is there a cheaper certificate for `2 | ord` than computing `S`?** For `w = +1`, what is the
   minimal computation that distinguishes analytic rank 0 from rank ≥ 2? (Cf. `Λ_E(1)` vs
   the `L″` term.)
4. **Unfolding error in the GUE test.** Fitting the spacing distribution with
   `N(T) = (T/2π)(log(T/2π)−1)+7/8` — how much of the `0.142` vs `0.178` variance gap is unfolding
   bias, and how many zeros are needed to distinguish Wigner from the exact GUE spacing law?
5. **A direct proof-side use of multiplicativity.** C14 says the Euler product is load-bearing; is
   there a computational statement (e.g. Weil positivity on `ζ` vs Davenport–Heilbronn on the same
   test functions) that *measures* the failure of positivity for the non-multiplicative case? That
   would turn the corpus' insight into a computation.
6. **`factorize.py` as evidence.** Should the script be fixed to (i) use the primes `≤ 100` its
   caption claims, (ii) drop the unbounded `true_factor`, and (iii) test on numbers it can actually
   factor (`2310`, `9991`, `10403`)? As shipped, the file demonstrates only that trial
   division to `√N` is infeasible for a 39-digit input.
7. **The verifier.** Six of the cluster's checks have harness bugs and three verdicts are not
   reproducible from the shipped code. Which of the corpus' claims remain *independently* unchecked
   once the buggy checks are discounted? (My answer in this cluster: none of the headline claims —
   I re-derived each one here — but the artifact cannot be cited as the reason.)
8. **The Lean ledger.** A runnable `#print axioms`-plus-sorry audit that distinguishes tactics from
   prose, restricted to `Math-Lean/Math/HSLN*.lean`, would settle "55 PROVEN" definitively; it
   should be part of any release of this corpus.
