# Discrete symbols, cryptographic demos, and the speculative frontier

> **Status:** The discrete-symbol work is sound and modest. **Every cryptographic probe in this
> file is a negative result.** None factors a number faster than trial division or the classical
> methods it wraps, none recovers or narrows any private key, and none inverts or weakens a hash
> function. The scripts state these limits in their own code and output; some of their file and
> figure names suggest more than the code does, and this file records, probe by probe, the precise
> reason each one cannot work. The physics/millennium material is mostly analogy plus a few small
> true theorems.
> **Evidence grade:** mix — see per-section grades
> **Corpus artefacts:** `cm_*.py` (figs 23–26), `hsln_bitcoin_*.py` (figs 59–61),
> `hsln_hash_*.py` (figs 47, 49, 51), `hsln_pgp_dance.py` (fig 48), `hsln_e8_torsion_factor.py`
> (fig 57), `hsln_reverse_factor.py` (fig 58), `hsln_cofactor_*.py` (fig 62),
> `hsln_ktheory.py` / `hsln_hodge.py` / `hsln_langlands.py` / `hsln_spectral.py` /
> `hsln_trace.py` / `hsln_yangmills.py` / `hsln_cup_product.py`
> **Reproduced here:** yes — every number quoted below was produced by running the script.

---

## Part I — Reading integers off geometry: the CM-point alphabet

### 1. The idea

The state space is the upper half-plane, so a "symbol" has to be a distinguished point in
it. The corpus picks the most arithmetically distinguished points that exist: **CM points**
(τ imaginary quadratic). At a CM point, the modular `j`-invariant takes an **algebraic
integer** value — a *singular modulus*. When the class number is 1, that algebraic integer
is a **rational integer**, and the symbol set becomes a countable alphabet of points each
labelled by an honest integer.

### 2. The precise statement

The `j`-function is `j(τ) = 1728·E4(τ)³/(E4(τ)³ − E6(τ)²)`; it is weight 0, `SL₂(ℤ)`-invariant,
and gives a bijection `H/SL₂(ℤ) → ℂ`. The nine **Heegner numbers**

```
d ∈ {1, 2, 3, 7, 11, 19, 43, 67, 163}
```

are exactly the positive integers for which `ℚ(√−d)` has class number 1, and for these the
`j`-values are rational integers — in fact **perfect cubes**:

| d | τ_d | j(τ_d) | cube root |
|---|---|---|---|
| 1 | (1+√−1)/2 = i | 1728 | 12 |
| 2 | √−2 | 8000 | 20 |
| 3 | (1+√−3)/2 = ρ | 0 | 0 |
| 7 | (1+√−7)/2 | −3375 | −15 |
| 11 | (1+√−11)/2 | −32768 | −32 |
| 19 | (1+√−19)/2 | −884736 | −96 |
| 43 | (1+√−43)/2 | −884736000 | −960 |
| 67 | (1+√−67)/2 | −147197952000 | −5280 |
| 163 | (1+√−163)/2 | −262537412640768000 | −640320 |

The last row is the source of the famous near-integer `e^{π√163} ≈ 640320³ + 744 − 7.5e−13`.

> **Grade: PROVEN.** This is classical (Weber, Heegner; the class-number-1 list by
> Heegner–Baker–Stark). Verified here with `mpmath` at 80-digit precision:
> `j((1+√−163)/2) = −640320³` to within `1e−70`.

### 3. Why `j` is a bijection, and why CM points give integers

- *Bijection:* `H/SL₂(ℤ)` is the moduli space of complex elliptic curves; the `j`-invariant
  is the complete invariant, and every complex number occurs. That is what makes the readout
  *total*: **any** invariant readout is a rational function of `j`.
- *Integrality:* an elliptic curve with CM by an order in an imaginary quadratic field has
  `j` algebraic of degree = the class number. Class number 1 ⇒ the value is rational, and
  `j` is an algebraic integer, so it is a rational integer. This is the **theory of complex
  multiplication** (Kronecker's Jugendtraum, first proved by Weber and Takagi).

Because `j` is `SL₂(ℤ)`-invariant, a readout can reduce *any* endpoint τ to the fundamental
domain first and read `j` there. The corpus exploits this correctly in `cm_task.py`.

### 4. What the code does

- **`cm_alphabet.py`** (fig 23): builds the table above at high precision and shows the nine
  symbols as points in `ℍ`.
- **`cm_task.py`** (fig 24): a fixed "question" input routes **three** output coordinates (a
  genus-3 direct sum) to letters' CM points; decoding `j →` nearest singular modulus spells
  `"ADA"`, using only the two CM points reachable in the corpus' grid (`A ↦ j = 1728` at `i`,
  `D ↦ j = 0` at `ρ`). The continuous flow, a discrete answer, genuinely.
- **`cm_classifier.py`** (fig 25): only two CM symbols are cleanly reachable, so four classes
  are encoded as **2-bit codewords** `AA/AD/DA/DD` across two direct-sum coordinates. The
  gravity landscape is **fixed** (neurons at the two CM points) and only the **linear input
  encoder** is learned — reservoir-computing style. Result: 95% on 80 held-out points.
- **`cm_tensor.py`** (fig 26): train one minimal single-neuron DNA per class *completely
  separately*, compose by tensor product (multiply forms = convolve DNAs), `F = F₀F₁F₂F₃`.
  The compound's four neurons equal the four parents' to **1.76e−16**; classify held-out by
  nearest neuron: **95% on first compose**, no joint training.

> **Grades:** CM alphabet **PROVEN**; `cm_task.py` **NUMERICAL** (a demonstration that the
> readout pipeline closes); the 95% classifiers **NUMERICAL**, and the corpus is honest that
> they are effectively *nearest-centroid assembled by composition*, not deep learning.

### 5. Scope limits the corpus itself flags — and one it half-flags

The corpus states the essential caveat correctly:

> "Our attractors are *zeros of F*, which are generically **not** CM points — so we'd have to
> *engineer* F (or the readout) so attractors coincide with chosen singular moduli."
> — `math-connections.md` §2

That is exactly right, and it is the reason the CM story is a *toy*, not a mechanism. The
engineered version is what `cm_tensor.py` does: it trains one DNA *per class* whose single
zero is placed at the class's centroid, then checks the composition law. The CM integers
appear only in the *naming*, and only two of the nine symbols are reachable in the corpus'
grid. So the accurate description is: **two integer-named attractors, and a bit-code built on
them**, not "a discrete alphabet of nine symbols in use".

A subtler point: the readout "snap `j(τ*)` to the nearest singular modulus" is not
error-correcting in any interesting sense. The singular moduli are exponentially spread
(`0, 1728, 8000, −3375, −32768, …`), so nearest-neighbour decoding succeeds whenever the
flow lands anywhere in a huge basin. The corpus notes this ("only two CM symbols are
cleanly reachable"), which amounts to the same observation.

---

## Part II — The cryptographic demos

**Every script in this part is a negative result: none breaks, weakens or recovers anything.**
This is also the part of the June files where the gap between the *code* and the *titles* is
widest. The code states its own limits correctly; several file and figure names suggest more
than the code does. Both are quoted below, so that each name can be read against what the
script actually computes.

### 1. The framing problem, stated plainly

| Artefact name | What the name could be read as | What the code does |
|---|---|---|
| `hsln_e8_torsion_factor.py` / `57_hsln_e8_torsion_factor.png` | a factoring method based on E8 torsion | Evaluates `D(k) = (1/k)·\|Σ_{j<k} e^{2πi jN/k}\|` for `k ≤ √N` — **trial division written with roots of unity** |
| `hsln_bitcoin_probe.py` / `59_hsln_bitcoin_probe.png` | a probe of Bitcoin keys | Trial-divides the *x-coordinate as an integer*. The script's own docstring says this "says exactly nothing about the private key" |
| `hsln_hash_inverse.py` / `51_hsln_hash_inverse.png` | an inverse of SHA-256 | Computes the **formal power-series inverse `1/F`** of a q-polynomial built from the hash bytes. This is polynomial long division, not a preimage attack |
| `hsln_reverse_factor.py` / `58_hsln_reverse_factor.png` | reverse factoring | Runs the same divisor scan in the other direction. Its own output says "grows ~√N: exponential in the number of digits. NOT polynomial." |
| `hsln_cofactor_dna.py` / `62_hsln_cofactor_dna.png` | a new factoring instrument | Wraps **trial division, Pollard rho/Brent, Pollard p−1, and a circulant spectral method** — all classical — around the DNA readout |
| `hsln_pgp_dance.py` / `48_hsln_pgp_dance.png`, `hsln_hash_dance.py` / `47_…`, `hsln_hash_dance_v2.py` / `49_…` | an analysis of PGP keys / hashes | Drive the reservoir with the *bits of a known* key/hash. Visualisation, no attack |

### 2. The one arithmetic fact underneath, and its cost

Everything in this cluster rests on a single correct identity. Define, for `k ≥ 1`,

```
D(k) = (1/k) · | Σ_{j=0}^{k−1} e^{2πi jN/k} |.
```

The sum is a geometric series: it equals `k` if `k | N` and `0` otherwise. Hence
**`D(k) = 1` exactly when `k` divides `N`**, and `D(k) = 0` otherwise.

> **Grade: PROVEN.** Trivial, and correct.

Scanning `k = 1, 2, 3, …` until the first hit therefore returns the smallest prime factor.
But the number of evaluations to reach it is `min(p, q) ≈ √N` for a balanced semiprime. The
corpus measures this itself, in `hsln_reverse_factor.py`:

```
       N  bits   fwd evals(~√N)    rev evals(~N)
     143     8               10              130
   10403    14              100            10300
 1022117    20             1008          1021104
...
measured time to first factor:
   N=         1022117      0.02 ms
   N=       100160063      0.21 ms
   N=     10002200057      2.17 ms
   N=   1000036000099     21.50 ms
=> grows ~√N: exponential in the number of digits. NOT polynomial.
```

**`D(k)` is trial division.** The roots-of-unity expression is a *different way to write the
same test*, not a different algorithm. There is no spectral or geometric shortcut in it: the
"spikes" of the DNA are the divisors, and finding them requires visiting every candidate `k`.
The corpus says this explicitly in `hsln_e8_torsion_factor.py`:

> "cost note: first spike appears only at the least factor (~√N) — a faithful picture, not a
> sub-√N shortcut."

That line is the honest core, and it is correct.

### 3. `hsln_e8_torsion_factor.py` — the E8 picture

The script's docstring states the scope itself:

> "**The honest, faithful reading** (what this figure shows): E8 / the Coxeter plane is the
> **PICTURE** — the ambient lattice (panels 1–3). The **ENGINE** is an arithmetic identity we
> already use (the roots-of-unity sieve / inverse Euler product…)."

That is exactly right: **the E8 torsion is the illustration, not the computation.** The
computation is integer arithmetic; the Coxeter projection is a rendering. Run output:

```
       N      form            true factors        projection fires  match
      15       p·q                  [3, 5]                  [3, 5]  OK
     323       p·q                [17, 19]                [17, 19]  OK
     210   p·q·r·s            [2, 3, 5, 7]            [2, 3, 5, 7]  OK
 verdict: projection's prime-spikes = distinct prime factors on 10/10 cases
```

Correct — and equivalent to trial division, as the script's own cost note concedes.

### 4. `hsln_bitcoin_probe.py` — public keys, and why the probe cannot work

This is a negative result. The script points the divisor scan at two public keys that have
been published on the Bitcoin blockchain since 2009 (the block-0 genesis coinbase key, never
spent; and the block-9 coinbase key, spent in block 170). It trial-divides the
**x-coordinate as an integer** (output abridged):

```
 genesis (block 0, unspent)
   x-coordinate : 255-bit integer
   small prime factors ≤ 100,000,000 : [2, 3]
   unfactored cofactor : 249-bit (prime?) — beyond classical reach

 block 9 (spent in block 170)
   x-coordinate : 253-bit integer
   small prime factors ≤ 100,000,000 : [2, 3, 38653, 183067]
   unfactored cofactor : 216-bit (prime?) — beyond classical reach
```

The script's own docstring states why this cannot bear on a key:

> "A Bitcoin key's secret is an **ELLIPTIC-CURVE DISCRETE LOG**: the private key `d` with
> `P = d·G` on secp256k1. **Factoring ≠ discrete log.** So pointing this instrument at a real
> public key is a category mismatch on purpose: what 'lights up' is just the small prime
> factors of the key's x-coordinate AS A NUMBER — which says exactly nothing about the
> private key."

> **Grade: REFUTED as framed, VERIFIED as an exercise.** The finding is real and correctly
> stated: nothing about a private key is recovered, the small factors `[2, 3]` are
> meaningless, and the cofactor is out of reach of any classical method at this size. The
> figure's name could be read as describing an attack; the code demonstrates that this route
> gives no information about a key. **The code states the scope correctly; the filename does
> not.**

### 5. `hsln_bitcoin_hash.py` — the best script in the cluster

This one exists to show that the instrument **fails**, and it does so carefully, using the
genesis public key:

1. **Avalanche** — flipping one input bit flips ~half the 256 output bits; no direction is
   privileged.
2. **Avalanche distribution** — the flip fraction is pinned at 0.5, a perfect coin per bit.
3. **Mining landscape** — leading-zero-bits per nonce is structureless; a valid block needs
   ~80+ leading zero bits, far beyond the range of the chart.
4. **Preimage gradient** — `distance(hash, target) ≈ 128` regardless of how close the *input*
   is to a known preimage. **The fitness landscape is flat: there is no gradient for
   "gravity" to descend.**
5. **The dance** — successive nonce-hashes scatter uniformly; no attractor, no clustering,
   in contrast to the factoring spikes.

And the conclusion is exactly the right one:

> "SHA-256 exposes no structure for HSLN gravity to grab. That is exactly why mining and
> hashed addresses are only QUADRATICALLY helped by quantum (Grover), never broken by
> period-finding (Shor). Factoring lights up; hashing does not."

> **Grade: PROVEN (as a negative result), and genuinely well done.** This is the clearest
> statement in the entire corpus of what the framework can and cannot touch. It should be
> the model for how the rest of the crypto cluster is presented.

### 6. `hsln_hash_inverse.py` — "inv(F)" is not an inverse hash

The name suggests more than the code does. What the code computes:

- take the 32 bytes of a hash,
- build a length-33 q-polynomial `F` whose roots are positioned by those bytes,
- compute the **formal power-series inverse** `1/F = Σ b_k q^k` via the Newton recurrence
  `b_0 = 1/a_0`, `b_k = −(1/a_0)Σ_{j=1}^{min(k,deg F)} a_j b_{k−j}`,
- in `mpmath` at 80 digits, because `|a_0| ≈ 2e−16` underflows double precision.

This is **polynomial division**, i.e. the multiplicative inverse in the ring of formal power
series. It is well-defined and correctly implemented. It has nothing to do with finding a
preimage of SHA-256: inverting `F` inside a toy polynomial ring says nothing about inverting
the hash function that produced the bytes used to build `F`.

> **Grade: REFUTED as framed.** "Compute `inv(F)` for the unknown SHA-256 hash" describes a
> symbolic algebra operation whose name ("inv") invites a reading the mathematics does not
> support.

### 7. `hsln_cofactor_safety.py` / `hsln_cofactor_dna.py` — honest brute force

These run a real battery on the 249-bit genesis cofactor:

```
 1. trial division to 10^7
 2. Pollard rho (Brent), time-bounded
 3. Pollard p−1, bounded smoothness
 4. the DNA→circulant SPECTRAL method […]
If any returns a nontrivial divisor, we print it loudly. Otherwise: safe.
```

The docstring also corrects the units: "*(Note: it's 249 **bits** ≈ 75 decimal
digits, not 249 digits.)*"

The "DNA→circulant spectral method" is the one novel-looking element. It builds a circulant
matrix from the divisor-indicator DNA over a window and reads its spectrum, on the theory
that an in-window factor would appear as a resonant eigenvalue. Since the divisor indicator
`D(k)` *is* `[k | N]`, a circulant built from it is a diagonalisable matrix whose spectrum is
the DFT of that indicator — no information beyond the indicator, i.e. beyond trial division
within the window. It cannot see a factor outside the window.

> **Grade: VERIFIED that no factor is found; the "spectral" method adds no reach.** The
> content is "we tried the classical attacks that fit in a time budget and they
> failed", which is correct and unsurprising for a 216–249-bit cofactor.

### 8. `hsln_reverse_factor.py` — the corpus's own falsification

The best thing in the factoring thread. The question was "is it reversible, and is it a
polynomial-time factoring algorithm that way round?" The script answers both, and the second
answer is no:

```
Reversible — YES.  The detector D(k) […] = [k | N] is a property of N, not of the
direction of travel. […]
   N  bits   fwd evals(~√N)    rev evals(~N)
...
=> grows ~√N: exponential in the number of digits. NOT polynomial.
```

> **Grade: VERIFIED.** A genuine negative result, correctly stated. This script is a
> *reason to trust* the corpus more, not less.

### 9. Summary judgement on the crypto cluster

- **No cryptographic result is claimed by the code, and none exists.** Every script either
  concedes its equivalence to a classical method or is explicitly a visualisation.
- **The gap is in the naming.** `hsln_e8_torsion_factor`, `hsln_hash_inverse`,
  `hsln_bitcoin_probe`, `hsln_reverse_factor` — and the figure names derived from them —
  read like capabilities. They are demonstrations of the *absence* of capability.
- **There is one genuine, useful contribution here:** `hsln_bitcoin_hash.py`'s five-fold
  demonstration that SHA-256's fitness landscape is flat, which is a crisp and correct
  explanation of why the framework's machinery cannot touch hashing while it can touch
  integer structure.
- **Recommended action:** rename. `hsln_e8_torsion_factor.py` → `roots_of_unity_divisor_scan.py`;
  `hsln_hash_inverse.py` → `qseries_formal_inverse.py`; `hsln_bitcoin_probe.py` →
  `secp256k1_pubkey_x_trial_division.py`. The mathematics is fine; the labels are not.

---

## Part III — The speculative frontier

Six clusters of Python/Lean work claim to place a Clay problem inside the framework. The
grading rule applied here: **is the Python check a real computation, and is the Lean claim a
theorem or a `Prop`?**

### 1. K-theory / Grothendieck–Riemann–Roch (`hsln_ktheory.py`, `HSLNKTheory.lean`)

**The claim.** The map `χ(f) = f(1)` (the value at `n = 1`) is a ring homomorphism
`ArithmeticFunction R →+* R` on the **Dirichlet** ring, playing the role of the Chern
character. And `χ` sees Ring B but is *blind* to Ring A: every **Cauchy** product has `χ = 0`.

**Check.** `χ(f*g) = (f*g)(1) = f(1)g(1) = χ(f)χ(g)` — because Dirichlet convolution
preserves the `n = 1` value. True and immediate. And `(f⋆g)(1) = Σ_{i+j=1} f(i)g(j) = 0`
since `f(0) = g(0) = 0`. Also true.

> **Grade: PROVEN, and nearly trivial.** "The augmentation map `f ↦ f(1)` is a ring
> homomorphism, and it annihilates the ideal of functions vanishing at 1" is a one-line fact
> about the Dirichlet ring. The GRR dictionary in `math-connections.md` is a table of
> **analogies**: `χ ↔ ch`, `ker χ ↔ K̃₀`, `Ring A ⊆ ker χ ↔` reduced K-theory. No bundle, no
> variety, no K-group is constructed. The identification of `f ↦ f(1)` with a Chern character
> is not a theorem and is not claimed in the Lean file as one.

**The Lean file does not compile** (ambiguous `antidiagonal`). Its 8 theorems include the
`chernChar : ArithmeticFunction R →+* R` construction, which is correct.

### 2. Hodge (`hsln_hodge.py`, `HSLNHodge.lean`)

**The genuine theorem.** Hodge classes of type `(k,k)` are closed under cup product — the
diagonal `H^{k,k}` is a graded subring of `⊕_k H^{2k}(X,ℚ)`. This is the reason a *ring
homomorphism* into cohomology lands inside the Hodge ring. `hodge_mul` states this and is
`sorry`-free.

**The honest caveats the corpus itself records** (in the docstring of `HSLNHodge.lean`, and
it deserves credit for this):

- the **integral** Hodge conjecture is **FALSE** (Atiyah–Hirzebruch 1962, via topological
  K-theory torsion) — so the `ℚ` is essential;
- the **Kähler** version is **FALSE** (Voisin 2002);
- the proven case is **Lefschetz (1,1)** (`k = 1`, divisors);
- and `integralHodgeModTorsion` is still false in general (Kollár 1992; Benoist–Ottem give
  *non-torsion* counterexamples).

> **Grade:** `hodge_mul` PROVEN (and genuinely nice — it is the structural reason cup product
> is the right operation to discuss). The E8×E8 torsion-freeness remark is PROVEN but
> **vacuous**: every lattice is torsion-free as an abelian group, so singling out E8 adds
> nothing. The conjecture itself is correctly a `Prop`. `HSLNHodge.lean` currently **does not
> compile** only because of the `HSLNBridge`/`HSLNKTheory` `antidiagonal` issue it imports —
> its own proofs are fine.

### 3. Langlands (`hsln_langlands.py`, `HSLNLanglands.lean`)

**The genuine content.** The multiplicativity locus
`{f : f(1)=1, f(mn)=f(m)f(n) for gcd(m,n)=1}` is closed under Dirichlet convolution, hence a
`Submonoid` of the Dirichlet ring. This is mathlib's `IsMultiplicative.mul`, and it is the
single algebraic fact underneath: the Euler product, `ζ·L(s,χ_D) = ζ_K`, Rankin–Selberg
products staying automorphic, and Hecke eigenvalues multiplying.

> **Grade: PROVEN** (via mathlib). This is the corpus' most defensible *conceptual*
> contribution: naming the locus and showing every "X composes with Y" claim is the same
> closure law. The `LanglandsTransfer` construction (a ring endomorphism mapping the locus
> into itself, composing with the identity transfer) is also correct and formalises the
> *shape* of functoriality. It is the same shape as functoriality, not functoriality.
> `HSLNLanglands.lean` compiles with 4 `sorry`s.

### 4. Spectral / Hilbert–Pólya (`hsln_spectral.py`, `HSLNSpectral.lean`)

**The one theorem doing the work.** A self-adjoint operator has real spectrum
(mathlib's `IsSymmetric.conj_eigenvalue_eq_self`). From it the file derives: a self-adjoint
operator's spectrum is real, and *if* the imaginary parts of the ζ-zeros were its spectrum,
RH would follow. The Python check is a stdlib Jacobi eigensolver with 300-trial fuzzing plus a
GOE-repulsion demo.

The file also contains a genuinely correct small theorem: `eigenvalue_smul`, that
`T ↦ cT` scales every eigenvalue by `c` and fixes the kernel. From which comes
`zero_eigenvalue_preserved`, which the corpus reads as "gravity warps the path, keeps the
destination" — a fair reading.

> **Grade:** `eigenvalue_real_of_symmetric` and `eigenvalue_smul` PROVEN. The Hilbert–Pólya
> step is **an implication whose hypothesis is not known to hold**: `riemannHypothesis_of_
> spectralZeta` is `HP operator ⇒ RH`, with the operator's existence as an open `def`. The
> corpus' later "equivalence" result (`riemannHypothesis_iff_hilbertPolyaOperator`) is also
> fine logically — but note what it says: the `def` is *equivalent* to RH, which means
> "make this def a theorem" is *exactly as hard as RH*. The corpus notices this and states
> it ("`'Make this def a theorem' now provably = 'prove RH'`"), which is honest.

### 5. Trace formula / Weil positivity (`hsln_trace.py`, `HSLNTraceFormula.lean`, `HSLNWeilPositivity.lean`)

**The content.** `weilSpectralForm_nonneg` is `Σ wᵢ|cᵢ|² ≥ 0` — true because each term is a
non-negative real times a modulus squared. It is a sum of squares, and it is `sorry`-free.
The corpus then routes: real spectrum ⇒ spectral side of the explicit formula ≥ 0 ⇒ (by the
explicit formula) the prime side ≥ 0 ⇒ Weil positivity ⇒ RH.

> **Grade: the mechanism is PROVEN; the identification is the open problem.** "A sum of
> non-negative terms is non-negative" is not the difficulty. The difficulty is that the
> explicit formula's prime-side term `Σ Λ(n)n^{−1/2}g(log n)` carries **no sign**, and
> dominating it by the positive archimedean term for *every* test function is a hard analytic
> statement equivalent to RH. `HSLNWeilPositivity.lean` says exactly this, and is the most
> honest file in the corpus:

> "**The single open node is the positivity — which *is* RH.** Why it's hard, stated
> precisely: the prime-power sum […] carries no sign and must be dominated by the positive
> Γ′/Γ archimedean term for *every* test function; and any proof must use the Euler product
> essentially (Epstein / Davenport–Heilbronn zetas satisfy the functional equation but have
> zeros off the line). **Analytic, not algebraic — no finite certificate known.**"

That paragraph is a correct and sharp statement of the obstruction. It is worth more than the
file's 14 `sorry`s.

### 6. Yang–Mills mass gap (`hsln_yangmills.py`, `HSLNYangMills.lean`)

**The content.** The mass gap is a spectral statement: `Ĥ ≥ 0`, vacuum ground state, gap
`spec(Ĥ) ∩ (0,Δ) = ∅`. The file defines `HasMassGap T Δ` and proves `massGap_smul` (the gap
scales with the coupling), `massGap_mono`, and `action_nonneg` (the YM action is a sum of
squares, via Bogomolny). The Python check confirms that `U(1)` has **no** gap (the photon is
massless) while conjecturing the gap for compact simple `G`.

> **Grade:** `massGap_smul` and `action_nonneg` PROVEN. The conjecture is a `Prop`.
> **And the corpus caught its own bug here** — this is worth highlighting as evidence of
> genuine self-audit:

> "**Two defs were too weak (vacuously true) — proven, then strengthened.** `YangMillsMassGap`
> and `TraceFormulaRealization` are satisfied by the trivial `T = 0` […]. Added
> `MassGapFaithful` + `zero_not_massGapFaithful` (the trivial witness fails the strengthened
> condition)."

Finding that your own existential is satisfied by zero, and saying so, is exactly the right
instinct. It is also the clearest sign that the deep problems are not being touched: the
faithful version needs unbounded operators with spectral measures and constructive-QFT
axioms, which do not exist in mathlib (or anywhere).

### 7. Cup product (`hsln_cup_product.py`, fig 64)

The corpus' own `system-spec.md` §4.3 is decisive and correct:

> "'**Cup product splices trained strands.**' The cup product takes `H^p ⊗ H^q → H^{p+q}`.
> For Eichler–Shimura we're in `H¹`, so the cup product lands in `H²` — a *different*
> cohomology group, of a different modular curve. There's no obvious sense in which
> `α ⌣ β` is 'a trained model that does both tasks'. This claim, as stated […], is
> metaphorical. The right operation for 'do both tasks' is **multiplication in the graded
> ring**."

> **Grade: REFUTED as an operation on models, by the corpus itself.** The correct operation
> is ring multiplication. Figure 64 was produced regardless, so the figure and the spec's own
> analysis disagree.

### 8. Frontier map (`HSLNFrontier.lean`)

The one piece of this cluster I would keep without reservation. It isolates each of four Clay
problems to a **single open node**, carrying the proven partials as hypotheses:

| Problem | Open barrier node | Proven partial carried |
|---|---|---|
| Riemann Hypothesis | Weil/Li positivity | Weil & Li equivalences |
| Birch–Swinnerton-Dyer | analytic rank ≥ 2 rank equality (+ Sha finite) | Gross–Zagier–Kolyvagin (rank ≤ 1) |
| Hodge | cycle-map surjectivity, codim `k ≥ 2` | Lefschetz (1,1) |
| Yang–Mills | existence of a gapped 4D theory | spectral-gap reformulation; 2D construction |

with each barrier annotated with the honest obstruction (BSD: "Euler systems give nothing
past analytic rank 1"; Hodge: "integral & Kähler versions are FALSE, so any proof needs
projectivity + ℚ essentially"; YM: "no rigorous 4D interacting construction exists at all").

> **Grade: PROVEN as scaffolding.** This is what a formalisation of a conjecture *should*
> look like, and its summary sentence — "This is a *frontier map*, not solutions — its value
> is precision" — is the correct description.

---

## Part IV — Verdict

| Cluster | Verdict |
|---|---|
| CM-point alphabet | PROVEN mathematics, correctly implemented. Modest, real, and clearly caveated. |
| CM classifiers | NUMERICAL. 95% held-out, but the landscape is fixed and only a linear encoder is trained; the corpus says so. |
| Factoring / divisor scans | VERIFIED as trial division written with roots of unity. The scripts' own cost measurements show it is not polynomial. |
| Bitcoin probes | Negative result: no information about any private key; the code says so. Filenames overstate. |
| Hash "inversion" | Negative result: a formal power-series inverse, unrelated to SHA-256 preimages. |
| Hash *negative* result | PROVEN and excellent — flat fitness landscape, no gradient, correct conclusion. |
| K-theory / GRR | PROVEN but near-trivial (`f ↦ f(1)` is a ring hom); the rest is analogy. |
| Hodge | `hodge_mul` genuinely PROVEN; conjecture correctly a `Prop`; E8 torsion remark vacuous. |
| Langlands | PROVEN (mathlib's `IsMultiplicative.mul`); the best conceptual contribution in the corpus. |
| Spectral / Hilbert–Pólya | One-line theorem + open hypothesis. Logically fine, mathematically untouched. |
| Weil / Li positivity | Mechanism PROVEN, identification open, and the file states this precisely. |
| Yang–Mills | Two small PROVEN lemmas; the file self-audited a vacuous definition — exemplary. |
| Cup product | REFUTED by the corpus' own spec. |
| Frontier map | PROVEN scaffolding; worth keeping. |

**The overall pattern of this cluster:** the *code* is consistently more honest than the
*prose about the code*, and the *prose inside the Lean files* is often the most honest of all.
The failure mode is naming and framing, not arithmetic.
