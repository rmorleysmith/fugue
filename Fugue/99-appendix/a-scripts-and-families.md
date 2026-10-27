# Appendix A — the scripts the main threads did not reach

Nine scripts in the June `PythonAndVisualizations` folder fall outside the thematic threads because they
belong to one of two families: the **"push something through the encoding" experiments**
(which exist to establish a negative result) and the **precision machinery** around them.
This file documents them, because "extract every piece of knowledge" includes the negative
results — and these are among the clearest pieces of reasoning in the June files.

The June files are archived unchanged in `rmorleysmith/hsln-archive` (Lean in `lean.zip`,
scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`).

> **Status:** every script in this appendix reaches a **correct negative conclusion** and says
> so plainly. Collectively they falsify the most tempting over-reading of the whole
> framework: that composition, being invertible-looking, might factor integers.
> **Evidence grade:** the *conclusions* are **PROVEN** (they are arguments, not measurements);
> the *demonstrations* are **NUMERICAL**.
> **Reproduced here:** yes, except `hsln_bignum_factor_hp.py` / `hsln_bignum_recover_show.py`,
> which are time-unbounded by design (see §4).

---

## 1. The `phi_via_category.py` argument — where the algebra stops

### The claim under test

`φ` is multiplicative: `φ(N) = N·∏_{p|N}(1 − 1/p)`. In the corpus' vocabulary that is a
**tensor product over primes**, and `φ = Id * μ` is a **Dirichlet-ring product**. Since the
framework's whole selling point is that it makes such compositions exact, the question is
whether the compositional structure gives a way to evaluate `φ(N)` **without decomposing
`N`**.

### The four routes, all of which fail — for different reasons

| Route | Form | Why it fails |
|---|---|---|
| **A. Euler product / tensor** | `N·∏_{p\|N}(1 − 1/p)` | The categorical "tensor over primes" does not bypass the **index search** `{p : p \| N}`. The index set *is* the factorisation. |
| **B. Brute coprime count** | `#{a ≤ N : gcd(a,N) = 1}` | Needs no factorisation at all — but `O(N)`, i.e. exponential in `log N`. |
| **C. Order-finding** | `lcm` of orders mod `N` → `λ(N)` | Order-finding is classically **equivalent to factoring** (Boneh–Lipton 1996; Shor 1994). Recovering `φ` from `λ` still needs the prime structure. |
| **D. Möbius / Yoneda** | `(Id * μ)(N) = Σ_{d\|N} d·μ(N/d)` | The sum is over divisors. `y(N) = {d : d \| N}` — the representable functor in the divisibility presheaf — **is** the divisor enumeration being avoided. |

Measured, from the run:

```
D. Möbius divisor sum / Yoneda (needs divisors): 165878779449240  [   1.27 µs]
     Routes A, D condition on factorisation. C is classically hard
     (Boneh-Lipton 1996). B is the only non-factoring route; O(N) time.
```

### The conclusion, in the script's own words

> "The composable model unifies ζ, μ, φ, σ, Λ as different multiplicative functors; it does
> NOT extract their values at unfactored N more cheaply than the underlying number theory
> permits. … If a categorical / compositional route to φ(N) existed in poly-time, Miller
> (1976) + Shor (1994) would already have it — **and RSA would be broken. The framework
> cannot be the missing piece.**"

> **Grade: PROVEN.** This is a correct complexity reduction, cleanly argued, with the
> references (Miller 1976; Boneh–Lipton 1996; Shor 1994) cited properly. The script takes an
> optimistic hypothesis seriously, tests it four ways, and reports that it fails.

### The general principle this establishes

Yoneda is the sharpest formulation. `φ(N) = Hom(y(N), φ)` in the presheaf category on the
divisibility poset is a **true** statement, and it is **not** an algorithm: computing the
representable functor at `N` means enumerating the divisors of `N`. The corpus' categorical
machinery *expresses* arithmetic but does not *decide* it. That distinction recurs in every
script in this appendix.

---

## 2. `hsln_tau_compose.py` — composition is a homomorphism, so it cannot split

### The idea

Ramanujan's `τ` is multiplicative: `τ(N) = τ(p)τ(q)`. The corpus' encoder is
`pos(x) = frac(log₂ x)`, and `log` turns a **product into a sum**:

```
pos(|τ(N)|) = ( pos(|τ(p)|) + pos(|τ(q)|) ) mod 1
```

So composing the `τ`-DNAs ought to reproduce `pos(τ(N))` going **forward** — and the script
confirms it does. But going *backward* is the same problem as before.

Measured (`N₀ = 47·53`):

```
[3] TRAIN onto τ(47), τ(53), τ(2491):
    τ(47)     pos=0.2983 probe ? loss=... 
    τ(53)     pos=0.5719 probe 6 loss=0.0140
    τ(2491)   pos=0.8954 probe10 loss=0.0087

[4] COMPOSE the two factor-DNAs (hsln.tensor = convolve) — the forward direction:
    composed DNA length 11 (= 6+6−1)
    composed spike peaks at Re τ = 0.2983
    ✓ FORWARD works: τ(47)-DNA ⊗ τ(53)-DNA spikes where τ(N0) lives.
```

Note the peak at `0.2983`, which equals `pos(τ(47))` *modulo 1* — the homomorphism is doing
exactly what the algebra predicts. That is the forward (build) direction, and it is correct.

### The four walls on the way back

```
To go backward (N ⟶ p,q) through τ you would need, in order:
 (a) τ(N) itself — but τ(N) is built FROM the factorisation.
 (b) factor the INTEGER τ(N) into τ(p)·τ(q) — τ(N0) here is 19 digits;
     for the big N it is ~5600 bits. That is a LARGER factoring problem than N.
 (c) invert τ(p) ⟶ p.
 (d) and the HSLN composition itself is additive after log:
     pos(τN)=pos(τp)+pos(τq), one number, two unknowns —
     the SAME 2-from-1 collapse as encoding N directly.
```

> **Grade: PROVEN.** Wall (b) is the decisive one: routing through `τ` **enlarges** the
> factoring instance rather than reducing it. Wall (d) is the structural reason, and it
> generalises: **any** encoding that is a homomorphism from `(ℕ,×)` into a group collapses
> two factors into one datum, and a single number cannot be inverted to two.

---

## 3. `hsln_hecke_exercise.py` — the Andrianov–Hecke theorem is a *determination*, not a tool

This is the most mathematically interesting script in the appendix, because it exercises a
theorem the corpus *did* formalise — and finds precisely where it stops.

### What the theorem says

A Hecke eigenform's coefficient sequence `(aₙ)` is **determined by its prime values**
`(a_p)`, via

```
(1) Hecke recursion    a_{p^{r+2}} = a_p·a_{p^{r+1}} − p^{k−1}·a_{p^r}
(2) multiplicativity   a_{mn} = a_m·a_n   for gcd(m,n) = 1
```

The script uses the most explicit eigenform: `Δ = η²⁴ ∈ S₁₂(SL₂(ℤ))`, weight `k = 12`, whose
coefficients are Ramanujan's `τ(n)`. It builds `τ(1..M)` from `Δ = q∏(1−qⁿ)²⁴` — with **no
factoring used** — then tests the theorem in both directions.

**Forward: it works perfectly.** That is the compression direction, and it is the corpus'
`HSLNHecke.lean` claim exercised on real numbers.

**Backward: it does not factor.** The script's two walls:

```
WALL 1 — you cannot evaluate a_N at N without the factorization:
    • via multiplicativity → needs the primes of N (circular).
    • via the q-expansion  → needs N coefficients. For N0 that's 2491;
      for the 1024-bit N that is 2^1024 ≈ 10^308 terms. Infeasible.

WALL 2 — even GIVEN a_N, the equation a_N = a_p·a_q just relocates the problem:
    • τ(2491) is a 19-digit integer; recovering τ(47), τ(53) means
      FACTORING that 19-digit integer — a LARGER factoring problem than N0.
    • and τ(p) → p is its own inversion: for weight 2 (elliptic curves) it is
      not even injective (|a_p| ≤ 2√p, supersingular a_p = 0 collisions).
    Net: 'factor N' is mapped to 'factor a_N', which is strictly harder.
```

### The framing, which is correct and worth quoting

> "It is a **DETERMINATION (reconstruction) theorem**: primes ⟶ all coefficients. … It
> presupposes the factorization (it is indexed BY primes). Run backward it does not factor;
> it converts factoring N into factoring the bigger a_N. The one place this multiplicative
> structure DOES drive a real factoring algo is **Lenstra ECM**: `a_p = p+1−#E(F_p)`, and a
> factor falls out when `#E(F_p)` is smooth (Lenstra 1987, Ann. Math. 126). Different
> mechanism — and still sub-exponential, infeasible for a balanced 1024-bit modulus."

> **Grade: PROVEN.** Every step is correct, and the ECM observation is the right contrast: a
> genuine factoring algorithm *does* live on this multiplicative structure, but it uses
> smoothness of `#E(F_p)`, not the inversion of `a_p`. Other June files treat "the Hecke locus
> is where the same sequence lives in both rings" as a factoring lever; this distinction is
> the precise reason it is not one.

One further point in the script is worth recording: weight-2 non-injectivity.
For an elliptic curve, `|a_p| ≤ 2√p` **and** `a_p = 0` for supersingular `p` (for
non-CM curves, for a density-1/2 set of primes). So `τ(p) ↦ p` is not a function at all in
the weight-2 case. The June files that propose inverting `a_p` do not address this point.

---

## 4. The `hsln_bignum*` family — the "recover the factors from `pos(N)`" attempt

Six scripts, one idea, one negative result. These are the scripts that a reader is most
likely to mistake for a factoring claim, so the framing matters.

### The idea

`pos(N) = frac(log₂ N)` places `N` at a position on the "lane" `Im τ = LANE_Y`. Train (or
construct) a DNA whose neuron sits at that position. Then invert the encoding:

```
cand(α, k) = round( 2^(k + α) )        for bit-shelves k ∈ ℤ
```

A balanced factor of a 1024-bit `N` is ~512 bits, so one would sweep `k ≈ 512` and
trial-divide `N` by each candidate.

### What actually happens

`hsln_bignum_4n.py` — train onto `pos(N)` with 4 neurons, then sweep:

```
  idx |   Re τ      Im τ 
    0  | 0.1343   0.1014
    1  | 0.3737   0.0862
    2  | 0.6064   0.0902
    3  | 0.8616   0.1820   ← on lane

Sweep:  α ∈ ['0.1343', '0.3737', '0.6064', '0.8616']   k ∈ [412..1023]   wiggle ±8

41616 candidates in 0.1s, 0 factor(s) found
Paired sweep: also try partner pos(N) − α (mod 1) for each zero
83232 candidates (paired), total hits 0
```

`hsln_bignum_factor.py` — the diagnostic, and it names all three reasons at once:

```
  Why this was always going to be hard:
  • pos(p·q) ≡ pos(p) + pos(q) mod 1 is a homomorphism collapsing 2D → 1D.
  • F_N was trained with one-hot loss at pos(N) — it has no factor info to
    encode in the first place.
  • The 5 secondary zeros of F_N sit BELOW the lane (Im τ < 0.11) —
    they are optimisation filler, not factor coordinates.

  The structural composition rule (F_p⊗F_q = conv) needs F_p, F_q as inputs.
  Going from F_N back to (F_p, F_q) is the missing inverse — and no construction
  in this framework provides it. Recovery requires the actual algorithmic
  factorisation of N, which HSLN does not perform.
```

Measured candidate counts across the family: 41 616 and 83 232 (from `hsln_bignum_4n.py`); a
fuller sweep in `hsln_bignum_recover_show.py` runs on the order of `10^7` candidates.

### Why zero hits is the *necessary* outcome

This is the part worth stating cleanly, because it is not an implementation failure:

1. If a candidate `cand(k, α)` divided `N`, then `pos(cand)` would equal `α` — so the
   "candidate" is defined as *the number at that lane position on that shelf*. `N` itself
   sits at `pos(N)` on the shelf `k = n_bits − 1`, so the bijection **round-trips `N`
   exactly** (the scripts verify this as a sanity check). But `p` and `q` sit at
   `pos(p)` and `pos(q)`, which are **different** positions — and `α` is `pos(N)`, not
   `pos(p)`. The single number `pos(N)` is `pos(p) + pos(q) mod 1`, so it fixes neither.
2. Trial-dividing by `N^(1/2)`-many shifted candidates is `O(√N)` in the best case —
   i.e. the same wall as trial division.

> **Grade: the negative result is PROVEN.** These scripts demonstrate, rather than assert,
> that the encoding is a homomorphism from `(ℕ, ×)` to `ℝ/ℤ` and therefore **loses exactly
> the information required to factor**. That is a theorem about the encoding, not a
> limitation of training.

### Why the precision variants exist

`hsln_bignum_factor_hp.py` lifts precision three ways, and its design is itself the evidence
that this is a numerical-resolution exercise rather than an algorithmic one:

1. `pos(N)` at **1100** mpmath digits (was 16 float digits).
2. `F_N` built **analytically** — a single atomic zero exactly at `τ = pos(N) + i·LANE_Y`.
   No probe snapping, no Adam training, no encoding error: the optimiser is removed as a
   possible culprit, which strengthens the negative result.
3. `cand_k = nearest_int(2^(k + pos(N)))` at enough precision that the integer is exact
   (≥ `k·0.302 + 40` digits — the `0.302` being `log₁₀ 2`).

It then (A) re-validates the round-trip at `k = n_bits − 1`, (B) sweeps all `k`, and (C)
**repeats on a 60-bit semiprime so the precision lift can be seen working** where the
candidate-prime gap is resolvable. That step-C control is good practice: it distinguishes
"the high-precision machinery works" from "the algorithm factors", and finds the first true
and the second false.

`hsln_bignum_recover_show.py` prints every intermediate integer with no abbreviation — its
docstring says "Nothing hidden — the actual integers the machine produces are printed",
which is the right instinct.

> **Reproduction note.** `hsln_bignum_factor_hp.py` and `hsln_bignum_recover_show.py` are
> **time-unbounded by design** (they sweep ~10⁷ candidates at high precision) and were not
> run to completion here. `hsln_bignum_4n.py` and `hsln_bignum_factor.py` were run and their
> output is quoted above. `hsln_bignum_dna.py`, `hsln_bignum_dna_matrix.py` and
> `hsln_bignum_many.py` are the training-and-inspection companions; they train on `pos(N)`
> and plot the resulting DNA and neuron positions, and they are covered by figures 50, 52
> and 53 in the atlas.

---

## 5. `hsln_quantum_state.py` — a real construction, and a real scope limit

### What it claims, and what it shows

The corpus' Lean work builds, from scratch, a complex inner product on the space of
finitely-supported functions `ι →₀ ℂ`, and shows that diagonal multiplication
`Tdiag r` is self-adjoint with real spectrum `{rᵢ}`. The script asks: does that make the HSLN
*a* quantum state, rather than an analogy of one?

It checks every axiom of the textbook definition. All pass:

```
(5) [PASS] ⟨A⟩ is real (A self-adjoint)   Im=0.00e+00
    [PASS] ⟨A⟩ = Σ r_i P(r_i)   ⟨A⟩=0.78606
(6) global phase: e^{iθ}|ψ⟩ is the same state:
    [PASS] Born probs unchanged / expectation unchanged
(7) density operator ρ = |ψ⟩⟨ψ|:
    [PASS] Tr ρ = 1 ; ρ = ρ† ; ρ² = ρ and Tr ρ² = 1 (PURE) ; mixed: Tr ρ²=0.5827 < 1
(8) HSLN-native: divisor-function DNA as a quantum state, divisor observable:
    [PASS] ⟨D⟩ = Σ d(n)³ / Σ d(n)²   ⟨D⟩=3.2414
(9) HSLN composition vs the QM tensor product:
    [PASS] tensor state stays normalised ; A⊗I + I⊗B self-adjoint
    [PASS] ⟨A⊗I+I⊗B⟩ = ⟨A⟩+⟨B⟩ on a product state
```

### The honest reading

The conclusion — "the HSLN realises EVERY axiom of a quantum state" — is **correct but
vacuous as a claim about HSLN**. Every finite-dimensional complex inner-product space *is* a
Hilbert space, and every self-adjoint operator on one *is* an observable. So the construction
demonstrates that the corpus **did** actually build a complex inner-product space in Lean —
which is a real, if small, piece of formalisation, and more than the prose claims for most
other files — but it does **not** make HSLN quantum in any sense that distinguishes it from
any other complex vector space.

The one genuinely arithmetic statement in the run is step (8):

```
⟨D⟩ = Σ d(n)³ / Σ d(n)²
```

for `D` the diagonal observable with eigenvalues the divisor counts `d(n)`. That is a
correct identity — the expectation of a diagonal operator in the normalised state is the
ratio of moments — but it is a restatement of "the mean of `d` under the weights `d²`,"
i.e. classical number theory in Dirac notation.

> **Grade: the axiom checks are VERIFIED (trivially); any claim that HSLN is *distinctively*
> a quantum state is REFUTED.** The script's own framing ("not by analogy, but because …")
> overstates: the reason is not specific to HSLN, it is that any complex inner-product space
> qualifies. What *is* worth keeping is that the Lean inner-product construction is real and
> the axioms genuinely hold for it. This Lean file compiles and is `sorry`-free at the points
> that matter.

The script follows a pattern that recurs in the June files: a **true** computation,
followed by an inference one step stronger than the computation supports.

---

## 6. The unifying observation

Every script in this appendix is an instance of one theorem, and it is worth stating once
because it is the corpus' most useful negative result:

> **Composition is a homomorphism on a build-ordered monoid, and a homomorphism cannot be
> inverted to recover the inputs it collapsed.**

Concretely, the corpus' encodings are all monoid homomorphisms `(ℕ, ×) → G`:

| Encoding | Homomorphism | Collapses |
|---|---|---|
| `pos(x) = frac(log₂ x)` | `(ℕ,×) → ℝ/ℤ` | `pos(pq) = pos(p) + pos(q)` |
| `τ` (Ramanujan) | `(ℕ,×) → ℤ` multiplicative | `τ(pq) = τ(p)τ(q)` |
| `φ` | `(ℕ, \|) → ℕ` | determined by prime-power data |
| Dirichlet convolution | the ring product | `ζ * μ = δ` has an inverse *only* because `μ` is an idempotent-like datum on prime powers |

And a single equation `F(pq) = F(p) ⊕ F(q)` with `F(pq)` known gives **one** datum for
**two** unknowns, in every case. The Dirichlet ring's group of units is the one place
inversion works — and it works because Möbius inversion is a *recursive* prime-power
statement (`μ(p²) = 0` truncates the recursion), not a generic inverse.

**This is why every factoring demo in the June files returns no factors, and why it must.**
Six scripts reach this conclusion empirically and state it correctly each time. Their
filenames still describe the family as "composing / factoring", which names the attempt
rather than the result. The mathematics in the scripts is right; only the naming is
misleading.

### Cross-references

- [`number-theory.md`](../02-threads/number-theory.md) — the sieve and factoring threads
- [`discrete-and-crypto.md`](../02-threads/discrete-and-crypto.md) — the Bitcoin/hash demos
- [`evidence-ledger.md`](../02-threads/evidence-ledger.md) — rows D11–D15, G6–G11, H1
