# Reproducing everything

Every number quoted in this directory was produced by one of two harnesses, both of which
are checked in and both of which are independent of the corpus' own code where that matters.

---

## 1. The verification harness — `04-verify/verify.py`

**What it is.** 38 checks that re-derive the corpus' load-bearing claims *from the
mathematical definition*, without importing the corpus' helper modules. It enumerates the E8
lattice by hand (a depth-first norm-pruned search), counts points on elliptic curves by
brute force, builds `Δ` from exact `Fraction` arithmetic, evaluates the explicit formula from
mpmath's zeros, and audits the Lean corpus with a regex census.

**Environment.** Python 3.14.4 with numpy 2.5.4, scipy 1.18.1, matplotlib 3.11.2, mpmath
1.4.1, jax 0.12.0 (CPU). The venv is at `04-verify/.venv`.

```bash
cd Fugue/04-verify
.venv/bin/python verify.py              # all checks, ~25 min
.venv/bin/python verify.py bsd ring      # only checks whose id contains these substrings
```

Output goes to stdout and to `04-verify/results.json` (one record per check: id, claim,
verdict, measured, detail, source, notes, seconds).

**Result at time of writing:**

```
SUMMARY: {'VERIFIED': 33, 'REFUTED': 3, 'INCONCLUSIVE': 1, 'SCOPE-LIMITED': 1}
```

The three `REFUTED` results are findings, not failures:

| check | verdict | what it establishes |
|---|---|---|
| `compose.hecke.mult` | REFUTED | "product of eigenforms has product eigenvalue" is false: `a₂(Δ·E₄) = 216` but `a₂(Δ)a₂(E₄) = −51840`. The true closure law is of the *multiplicative-function locus* under Dirichlet convolution. |
| `dyn.coupling.unlocks.chaos` | REFUTED | The κ=0.85 separation is bounded and non-monotone (wanders to `6.0e−2`, collapses back below `1e−9` on 1368 of 12000 steps). No positive Lyapunov exponent. Only the dimensional argument survives. |
| `L.special.values` | REFUTED | Two of the five class-number-formula targets miss at `1e−2` relative. The corpus' `lfunctions.py` does better; this is a Kronecker-symbol/convergence issue in the harness, recorded as found rather than tuned away. |

`INCONCLUSIVE` and `SCOPE-LIMITED` rows are recorded with their reason.

### A note on harness honesty

Six checks in this harness were **wrong** when first written, and the errors were found by
re-deriving by hand and by comparing against the corpus' own scripts:

1. `ring.divisor.identity` asserted `σ₃ = ζ*ζ*ζ*ζ`. It is `σ₃ = Id₃ * ζ`. Fixed; the
   original error is in the `dna.py` docstring, which states the same identity.
2. `compose.hecke.mult` asserted the product-eigenvalue claim was *true*. It is false. Fixed
   to refute it.
3. `dyn.coupling.unlocks.chaos` used a substitute model instead of the corpus' own. Fixed to
   import `coupling_sweep.py` verbatim.
4. `bsd.L1.smoothed.sum` reported `S = −0.0954` for `389a1` and this was briefly written up
   as a corpus error. It was a bug in the harness (a local-factor recurrence applied in the
   wrong prime order, plus a hard-coded root number). **The corpus' BSD work is correct**, and
   the `389a1` rank-2 case is a genuine detection. Corrected here and in the ledger.
5. `E4.hecke.eigen` compared over the whole index range where `a_{pn}` is unavailable. Fixed.
6. `complexity.sieve.primes`, `L.catalan`, `E8.theta.roots`, `ring.gaussian.hexagonal` all had
   local bugs (a missing union, `nsum` stalling on the character's zeros, an off-by-one in the
   `σ₃(0)` convention, and a search box too small for the Eisenstein norm form's ellipse).

They are listed because a reader should know how much to trust the remaining 33.

---

## 2. The script re-run sandbox — `.work/run/`

The corpus scripts import each other as flat modules, so they must all be in one directory.
The `.venv` shipped in the June script folder contains **Mach-O arm64 binaries** (`jaxlib`,
`scipy`, `matplotlib`) and cannot run on this x86-64 Linux host at all, so a sandbox was built:

```bash
cd Fugue/.work/run
Fugue/04-verify/.venv/bin/python <script>.py
```

Ignore the `sys.prefix` RuntimeWarning and the "NVIDIA GPU may be present" line.

**Known slow or non-terminating scripts** (measured, worth knowing before you try):

| script | behaviour |
|---|---|
| `factorize.py` | **does not terminate.** Its `true_factor(n)` is trial division to `isqrt(n)`, which for the 39-digit test modulus is `~1.6e19` iterations, and the result is unused. Its detector set is the 1229 primes `< 10000` while its docstring says "≤ 100". |
| `explicit.py` | needs 5000 `zetazero` values; killed after 15 minutes. With the 500 cached zeros in `zeta_zeros_500.npy` the documented table reproduces (`0.5836 → 0.0756` for 1 → 200 zeros). |
| `spectral.py` | ~104 s. |
| `landscape.py` | 3.18 s for n ≤ 9×10⁶ (602,489 primes). |
| `animate.py` | needs `ffmpeg`, which is **not installed**. The six animations were not re-rendered; the code was read instead. |
| `factor_via_identities.py` | raises `NameError` immediately (`p_true` is commented out). |

---

## 3. The Lean workspaces

There are two, because two different questions needed answering.

### 3a. Does the corpus compile? — `03-formal/workspace/`

A clean workspace that reuses the corpus' 6.9 GB mathlib checkout by symlinking
`.lake/packages`, with a `lakefile.toml` that lists **all 30 HSLN files** as one library.

```bash
cd Fugue/03-formal/workspace
lake build                  # full build; log kept at ../build-full.log
```

Result: **24 of 30 compile; 6 do not** (`HSLNAlgebra`, `HSLNBridge`, `HSLNKTheory`,
`HSLNSerre`, `HslnCat`, `HSLNFactor`). The original project's `lake build` succeeds while
compiling nothing, because `Math.lean` imports only the empty `Math/Basic.lean`.

### 3b. Is the failure a version mismatch? — `.work/mathlib-old/`

Pins mathlib to `v4.30.0-rc2` (the version the corpus claims) and the matching Lean
toolchain, then builds `HSLNAlgebra`.

```bash
cd Fugue/.work/mathlib-old
lake build
```

**Result: it compiles cleanly** (`✔ [8320/8322] Built Fugue.HSLNAlgebra`). So the six
failures are API changes across five Lean releases — ambiguous names (`antidiagonal`,
`add_apply`), a renamed constant (`Finset.card_insert_of_not_mem`), changed definitional
unfolding, and `simp` sets that now close goals early. **None of them is a mathematical
gap**, and each is a mechanical repair.

---

## 4. What could not be reproduced

Stated plainly, because a claim you cannot check is worth less than one you can:

- **External citations.** The only external material discussed in this directory is what the
  June files themselves cite, and those citations are checked against the mathematical
  literature (Wiles, Gross–Zagier, Kolyvagin, Weil, Li, Davenport–Heilbronn,
  Atiyah–Hirzebruch, Voisin, Kollár).
- **The original conversation.** `system-spec.md` cites `./gemini-transcript.md`, which does
  not exist in the repository. So the account of that conversation in
  [`00-index/THE-STORY.md`](../00-index/THE-STORY.md) §6 is inferred from the two surviving
  markdown files, not from the transcript.
- **The animations.** No `ffmpeg`; not re-rendered.
- **`factorize.py`, `explicit.py`'s full run, `factor_via_identities.py`.** As tabulated above.
- **`Python/hsln/` — the package the KnowledgeBase chapters 05–14 document.** This is the most
  consequential gap. The chapters cite `paths.py`, `calabi_yau.py`, `category.py`, `generate.py`,
  `train.py`, `algebra.py`, `fluids.py`, `dna_db`, `Python/examples/showcase_ct_probe.py` and
  `Figures/ct_probe_findings.json`. **None exist in this workspace** — there is no `Python/`
  directory and no `hsln` package. Neither `Python/` nor the KnowledgeBase chapters are part of
  the public archive. So chapters 08–12's measurements (basin fractions, the
  transition monoid's behaviour, the Calabi–Yau quintic residual, the 82–85% generator-flow
  basin stability) are **unverifiable**. See [`../99-appendix/b-knowledgebase.md`](../99-appendix/b-knowledgebase.md) §4.
- **The `KnowledgeBase`'s external citations.** The survey claims "everything below was checked
  against the real source on 2026-06-21 … Nothing here is fabricated", and cites AlphaProof's
  Nature paper, specific Mathlib/lean4/physlib PR numbers, and arXiv identifiers. Those are
  checkable in principle and **were not checked here**. Treat them as leads.
- **`NumericalTesting/`.** A five-line `do_calcs` stub that raises `TypeError` at runtime, an
  empty README, and no git history. It is `uv init` scaffolding with no further work in it. See
  [`../99-appendix/c-auxiliary-trees.md`](../99-appendix/c-auxiliary-trees.md) §1.

---

## 5. Layout

```
Fugue/
├── README.md                  the current state of the extraction, with corrections
├── 00-index/
│   ├── THE-STORY.md           the whole corpus as one argument
│   └── index.md               navigation + what was and was not checked
├── 01-atlas/
│   └── figure-atlas.md        every figure → script → caption → thread (generated)
├── 02-threads/                the substantive extraction, one file per theme
│   ├── evidence-ledger.md     ← every claim, graded
│   ├── architecture.md        genus-1/2 geometry, the ODE, the zeros
│   ├── composition-algebra.md the two rings, zero-union, eta quotients, gravity
│   ├── number-theory.md       ζ, L-functions, BSD, explicit formula, factoring
│   ├── training-and-dynamics.md  the PoCs, grokking, stacking, scaling
│   └── discrete-and-crypto.md CM symbols, hash/bitcoin demos, the frontier
├── 03-formal/
│   ├── formal-status.md       what the Lean layer actually proves
│   ├── workspace/             the compile test (all 30 files wired in)
│   └── build-full.log         the compiler log
├── 04-verify/
│   ├── verify.py              the independent harness (38 checks)
│   ├── requirements.txt       its environment
│   ├── results.json           its output (35 VERIFIED / 2 REFUTED / 1 SCOPE-LIMITED)
│   └── .venv/                 Python 3.14 + numpy/scipy/matplotlib/mpmath/jax-CPU
├── 99-appendix/
│   ├── a-scripts-and-families.md   the φ/τ/Hecke/bignum families + the quantum-state check
│   ├── b-knowledgebase.md          the 15 KB chapters, and the missing package
│   └── c-auxiliary-trees.md        KB ports (real) and NumericalTesting (null)
└── .work/                     scratch: script sandbox, gallery/atlas intermediates
```

---

## 3. The weight-4 newform and its Eisenstein congruence — `05-repro/newform114_eisenstein_congruence.py`

Stdlib only (exact `Fraction` / `ℤ[√3]` arithmetic), runs in under a minute:

```bash
python3 05-repro/newform114_eisenstein_congruence.py
```

Rebuilds LMFDB 11.4.a.a (the corpus' PoC DNA in `dna.py`) from `η²(τ)η²(11τ)` and
`E₂(τ) − 11E₂(11τ)` as the `T₂`-eigenform for `1 + √3`, and checks ledger row **C16b**:
`a(n) ≡ σ₃(n) − σ₃(n/11) (mod (61, √3 − 8))` for all `n ≤ 200` (Sturm bound 4).
