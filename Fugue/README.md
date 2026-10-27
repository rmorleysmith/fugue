# Fugue — the audit of the June 2026 files

> Every idea, figure and numerical claim in the June 2026 HSLN files, stated precisely and
> graded by the evidence behind it.

**What is audited.** The files produced between 29 May and 4 June 2026, archived unchanged in
[rmorleysmith/hsln-archive](https://github.com/rmorleysmith/hsln-archive): 79 Python scripts
(`python.zip`), 65 numbered figures and 7 animations (`visualizations_part1.zip`,
`..._part2.zip`), 28 Lean files (`lean.zip`), and the two design documents `system-spec.md` and
`math-connections.md` (`docs.zip`). Two further working folders, `KnowledgeBase/` and
`NumericalTesting/`, are discussed in the appendices but are not part of the public archive.

**What this is for.** A reader who has never seen the June files should be able to understand
each idea in them, see which parts are theorems, which are measurements, which are analogies and
which do not hold, and rerun the measurements. Where a June file states more than its evidence
supports, the audit quotes the statement and gives the precise version.

---

## How to read this

| If you want to… | Read |
|---|---|
| the whole picture in fifteen minutes | [`00-index/THE-STORY.md`](00-index/THE-STORY.md) |
| which claims hold, row by row | [`02-threads/evidence-ledger.md`](02-threads/evidence-ledger.md) |
| the architecture, stated precisely | [`02-threads/architecture.md`](02-threads/architecture.md) |
| the composition algebra | [`02-threads/composition-algebra.md`](02-threads/composition-algebra.md) |
| the number theory | [`02-threads/number-theory.md`](02-threads/number-theory.md) |
| training and dynamics | [`02-threads/training-and-dynamics.md`](02-threads/training-and-dynamics.md) |
| the factoring and hashing probes, and why each is a negative result | [`02-threads/discrete-and-crypto.md`](02-threads/discrete-and-crypto.md) |
| what the June Lean files prove and what they only state | [`03-formal/formal-status.md`](03-formal/formal-status.md) |
| rerun any measurement | [`05-repro/README.md`](05-repro/README.md) |
| find a figure and its source script | [`01-atlas/figure-atlas.md`](01-atlas/figure-atlas.md) |
| the scope of the audit and its open questions | [`00-index/index.md`](00-index/index.md) |
| the remaining script families, the KnowledgeBase, the auxiliary folders | [`99-appendix/`](99-appendix/) |

## How AI was used

The ideas in this work are Richard Morley-Smith's: the questions, the links between areas of
mathematics, and the choices of what to pursue. AI was used as a tool, in two phases.

- **May–June 2026, the original exploration.** The exploration was carried out in conversation
  with AI coding assistants, chiefly Anthropic's Claude through Claude Code (the design document
  also quotes Google's Gemini). The assistants wrote most of the code, Lean files and documents
  from the author's ideas and direction, quickly and without later editing. Those files are kept
  unchanged in [hsln-archive](https://github.com/rmorleysmith/hsln-archive).
- **October 2026 onwards.** Claude, through Claude Code, helps the author formalise the ideas in
  Lean 4, audit and tidy the earlier files, and write out the working: the steps between an
  intuition and a precise statement. This audit was written that way.

Checking the results does not rely on trusting the AI. Every Lean theorem is verified by the
Lean kernel against Mathlib, and `#print axioms` shows only Lean's three standard axioms. Every
script asserts the numbers it reports and can be rerun. Every grade in this audit cites the
evidence it rests on.

---

## The one-paragraph version

The June files propose a reservoir computer whose energy landscape is a **modular form**. The
first observation is sharp: for a holomorphic function `F`, the minimum-modulus principle makes
`|F|²` a landscape whose only minima are the zeros of `F`, so the zeros of a modular form are a
natural set of attractors. The second is that **multiplying two such forms unions their zero
sets exactly**, `zeros(F·G) = zeros(F) ∪ zeros(G)`, a composition law for trained models that
comes with a guarantee. The rest of the files follow that law into number theory. There the
same coefficient list turns out to carry a second multiplication, the Dirichlet product, under
which the composition rule is the Euler product; Möbius inversion, the two-square theorem, the
class number formula and the explicit formula all follow. The results are classical
mathematics reached from an unusual direction. Some of the June prose states them more
strongly than the evidence allows, and those statements are listed and corrected here.

---

## Status at a glance

Per-claim grades and evidence are in the [evidence ledger](02-threads/evidence-ledger.md).

| Claim | Status |
|---|---|
| **E8 theta = E₄** | ✅ True, classical; re-derived here in exact integer arithmetic. |
| **Zeros of `F` are the minima of `\|F\|²`** | ✅ True (minimum-modulus principle). |
| **`zeros(F·G) = zeros(F) ∪ zeros(G)`** | ✅ True, and it is the load-bearing composition law. |
| **Multiplying forms = Cauchy convolution of coefficients** | ✅ True, exact; residual `2.8e-16` re-measured. |
| **The Dirichlet ring: `ζ*μ=δ`, `ζ*ζ=d(n)`, `ζ*χ₋₄=r₂/4`, `log*μ=Λ`** | ✅ All true; re-verified exactly to `n = 3000`. |
| **The multiplicative (Hecke) locus is a sub-monoid** | ✅ True (Mathlib's `IsMultiplicative.mul`); it is the precise content of "everything composes". |
| **Eta-quotient composition is linear in the exponent vector** | ✅ True; the substantive part is that admissibility is also linear. |
| **Class number formula, Dirichlet L-values, two-square and hexagonal-norm identities** | ✅ True; re-verified to machine precision. |
| **Explicit formula: zeros ↔ primes** | ✅ True, classical; reconstructed here. |
| **GUE level repulsion for the ζ-zeros** | ⚠️ True as a statistical statement; evidence, not a proof of RH. |
| **"The zero count is the coefficient-vector length / Sturm bound"** | ❌ Does not hold as stated: `k/12` is a weighted count, and Δ (`k = 12`) has no interior zeros. See below. |
| **The BSD figure's rank data** | ✅ Correct, including `389a1`, a genuine numerical detection of analytic rank 2. |
| **"RH/BSD/Hodge/Yang–Mills formally proved in Lean, modulo cited sorries"** | ❌ Not proved: a `sorry` is an unproved step, not a citation. The files state these conjectures; they do not prove them. |
| **The June Lean files compile** | ⚠️ 24 of 30 compile against the Mathlib version tested; the other six fail from API changes between Lean releases, not from errors in the mathematics. |
| **Hashing, Bitcoin and RSA probes** | ❌ No cryptographic consequence. Each probe is a negative result and says so. |

### The two corrections that matter most

**1. The zeros of the truncated series are not the zeros of the form, and the true picture is
richer than the June files describe.** The June scripts find zeros with `numpy.roots` on the
truncated `q`-polynomial. The valence formula says a level-1 form of weight `k` has few distinct
zeros in a fundamental domain; for `E₄` (weight 4) there is exactly one, a simple zero at
`ρ = e^{2πi/3}`.

Inside the `q`-disk, however, the zero set of `E₄` is countably infinite: it is the image of the
single `SL₂(ℤ)`-orbit of `ρ`, one point per coset, with

```
|q| = exp( −π√3 / (c² − cd + d²) )
```

indexed by the hexagonal norms `c² − cd + d²`, the norm form of the Eisenstein integers. Measured
roots match to nine digits:

| hexagonal norm | 1 | 3 | 7 | 13 | 19 | 21 | 37 |
|---|---|---|---|---|---|---|---|
| predicted `\|q\|` | 0.0043334 | 0.1630335 | 0.4596258 | 0.6579877 | 0.7509702 | 0.7717349 | 0.8632380 |

This explains why the June root count grows with the truncation degree: the roots of the
truncation gather onto the orbit images and onto the natural boundary `|q| = 1`. For
`240 Σ σ₃(n) qⁿ` truncated at degree `N`, with the constant term kept:

```
N=  5  roots in q-disk =   5   min |q| = 0.004333421
N= 20  roots in q-disk =  20   min |q| = 0.004333421
N= 80  roots in q-disk =  80   min |q| = 0.004333421
N=320  roots in q-disk = 318   min |q| = 0.004333421   max in-disk |q| = 0.983513
N=640  roots in q-disk = 640   min |q| = 0.004333421   max in-disk |q| = 0.997791
```

The smallest is `exp(−π√3) = 0.004333420510`, the orbit image of `ρ` itself. So:

- The smallest roots are genuine: the first six converge under Newton's method to exact orbit
  images of `ρ`.
- In aggregate the roots are truncation effects: at `N = 320` the median of `|E₄(root)|` is
  `7.7e4`, so most roots are not zeros of `E₄`.
- The Sturm bound therefore does not cap the zero count. The count grows with `N` because the
  orbit is infinite; the number of distinct zeros modulo `SL₂(ℤ)` is set by the valence formula.

**2. The June Lean files state more than they prove.** They contain over 170 `sorry`
occurrences, six files fail to compile against current Mathlib, and the build target pointed at
an empty file, so `lake build` succeeded without compiling the mathematics. The files are still
useful: several are carefully organised, state open conjectures precisely, and say plainly when
something is not proved (`HSLNZeta.lean`: "we do not prove it — nobody has"). The per-file census
is in [`03-formal/formal-status.md`](03-formal/formal-status.md).

---

## The June documents, by reliability

| Document | Reliability | Note |
|---|---|---|
| `system-spec.md` | **high** | Precise and cited; its §4 "Critical analysis" sorts its own claims into watertight, needs-argument, and speculative. |
| Lean file docstrings | **high** | Often more careful than the prose that describes the files. |
| Python script docstrings | **high** | Consistently state their own scope limits. |
| `figures/index.html` captions | **medium** | Right about what is plotted; four captions' numbers do not reproduce. |
| `KnowledgeBase/*.md` (not in the public archive) | **medium** | An earlier write-up; a useful second view, with some of the same overstatements. |
| `math-connections.md` | **low to high by section** | A three-day research log. The early sections are careful; the later ones describe conjectures as "formally proved in Lean" and give inconsistent theorem counts. |

## The evidence grades

Every claim in `02-threads/` carries one of these:

- **PROVEN** — a classical theorem, correctly applied, or an exact identity re-derived here
  with exact arithmetic.
- **NUMERICAL** — a measurement with a stated tolerance in a stated regime: real evidence, not
  a proof.
- **ANALOGY** — a structural resemblance; it may be fruitful, and establishes nothing by itself.
- **SPECULATION** — an untested hypothesis, often flagged as such in the June files themselves.
- **REFUTED** — stated in the June files, and false, vacuous, or unsupported by the evidence
  given.

## Reproduction

Every measurement quoted here was re-derived from first principles by `04-verify/verify.py`,
which imports nothing from the June code: it enumerates the E8 lattice by hand, counts points on
elliptic curves by brute force, builds Δ in exact rational arithmetic, and evaluates the
explicit formula from mpmath's zeros. Its output is `04-verify/results.json`; see
[`05-repro/README.md`](05-repro/README.md).

## Formalisation

The provable rows of the ledger are sorry-free Lean 4 / Mathlib theorems in
[rmorleysmith/fugue-formal](https://github.com/rmorleysmith/fugue-formal); its `CORPUS-MAP.md`
maps ledger rows to Lean names. One correction came out of that work: the June appendix says the
encoding `pos = frac ∘ log₂` "loses the information required to factor"; in fact `pos` is
injective on odd numbers (`Fugue.pos_injective_odd`), so the obstacle is computational, not
informational.
