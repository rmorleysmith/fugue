# Index

## Read in this order

1. [`THE-STORY.md`](THE-STORY.md) — the June files as a single argument, with the two
   corrections that change how they read.
2. [`../02-threads/evidence-ledger.md`](../02-threads/evidence-ledger.md) — every claim,
   graded, with its evidence and source. **This is the document to consult.**
3. [`../02-threads/architecture.md`](../02-threads/architecture.md) — the geometry: E₈, the
   theta series, the valence formula, what the zeros are, the flow, Siegel degree 2.
4. [`../02-threads/composition-algebra.md`](../02-threads/composition-algebra.md) — the two
   rings, the zero-union law, eta quotients, the coupling structure.
5. [`../02-threads/number-theory.md`](../02-threads/number-theory.md) — ζ, L-functions, BSD,
   the explicit formula, and why composition does not factor integers.
6. [`../02-threads/training-and-dynamics.md`](../02-threads/training-and-dynamics.md) — the
   proof-of-concept runs, grokking, skill stacking, the scaling numbers.
7. [`../02-threads/discrete-and-crypto.md`](../02-threads/discrete-and-crypto.md) — CM-point
   symbols, the hashing and key probes (all negative results), and the Lean files named after
   open problems.
8. [`../03-formal/formal-status.md`](../03-formal/formal-status.md) — what the June Lean files
   prove and what they only state, measured.
9. [`../01-atlas/figure-atlas.md`](../01-atlas/figure-atlas.md) — every figure, its script, its
   June caption, and the thread that explains it.
10. [`../05-repro/README.md`](../05-repro/README.md) — how to rerun every measurement.
11. [`../99-appendix/a-scripts-and-families.md`](../99-appendix/a-scripts-and-families.md) — the
    script families the threads do not cover: the experiments that push `φ`, `τ` and Hecke
    theory through the encoding, the large-number factoring family, and the quantum-state check.
    Together they establish the clearest negative result in the June files.
12. [`../99-appendix/b-knowledgebase.md`](../99-appendix/b-knowledgebase.md) — the fifteen
    `KnowledgeBase/` chapters (not in the public archive).
13. [`../99-appendix/c-auxiliary-trees.md`](../99-appendix/c-auxiliary-trees.md) —
    `KnowledgeBase/code/` and `NumericalTesting/` (neither in the public archive).
14. [`../03-formal/contributions/contributions-notes.md`](../03-formal/contributions/contributions-notes.md) —
    a concrete strong-BSD contribution, with a compiled API probe and the three obstacles that
    remain.

The June files are archived unchanged in
[rmorleysmith/hsln-archive](https://github.com/rmorleysmith/hsln-archive) (Lean in `lean.zip`,
scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`, the design
documents in `docs.zip`).

## The June documents, by reliability

| Document | Reliability | Note |
|---|---|---|
| `system-spec.md` | **high** | Precise and cited. Its §4 "Critical analysis" sorts its own claims into watertight, needs-argument and speculative, and calls one of them "wrong as stated". |
| The Lean file docstrings | **high** | Individual files are careful; `HSLNZeta.lean` says "we do not prove it — nobody has". Often more careful than the prose describing them. |
| The Python script docstrings | **high** | Consistently state their own scope; `hsln_bitcoin_probe.py` and `hsln_bitcoin_hash.py` state exactly why their approach cannot work. |
| `figures/index.html` captions | **medium** | Right about what is plotted; four captions' numbers do not reproduce. |
| `KnowledgeBase/*.md` | **medium** | An earlier write-up; several chapters are well sourced, with some of the same overstatements. Not in the public archive. |
| `math-connections.md` | **low to high by section** | A three-day research log. The early sections are careful; the later ones describe conjectures as "formally proved in Lean" and give inconsistent theorem counts. |

## What was checked, and what was not

**Checked from first principles** by [`04-verify/verify.py`](../04-verify/verify.py) (38 checks:
35 VERIFIED, 2 REFUTED, 1 SCOPE-LIMITED): the E8 lattice and its theta series; the valence
formula and the zero of `E₄`; the two ring structures; Möbius inversion, the divisor function,
the two-square and hexagonal-norm identities, the von Mangoldt derivation; the Euler product,
the functional equation, the explicit formula, GUE statistics; the class number formula and
Dirichlet L-values; the BSD smoothed sums against LMFDB; the Siegel-metric identification; the
sieve and the limits of trial division; the Lean `sorry` census.

**Checked by running** every script named in the threads. The June virtual environment contains
macOS arm64 binaries and does not run on Linux, so a separate Linux environment was built.

**Checked by compiling** all 30 June Lean files against Mathlib `v4.35.0-rc4` (24 compile, 6 fail)
and `HSLNAlgebra` against `v4.30.0-rc2` (compiles), which shows the failures come from changes
between Lean releases.

**Not checked:**

- **The original conversation.** `system-spec.md` cites `./gemini-transcript.md`, which was not
  kept. The reading in `THE-STORY.md` is drawn from the surviving documents.
- **The animations.** `ffmpeg` was not available; the animations were read as code, not
  rendered.
- **`NumericalTesting/`** and **`KnowledgeBase/code/`.** Neither is referenced by any figure,
  script or document; skimmed, not verified.

## Corrections made during the audit

Recorded so that a reader can see what moved and why. Each was caught by an independent review
of the audit's own checking code:

| First-pass claim | Status | What is true |
|---|---|---|
| "The BSD figure is wrong: `389a1` is called rank 2 while the figure computes `L(E,1) ≈ 0.3`" | **Withdrawn** | `bsd.py` prints `L(E,1) ≈ −0.000000` for `389a1`, correctly. The value `0.306` is `L′(37a1, 1)`, the rank-1 curve's leading coefficient; the mistake was in the audit's own harness. |
| "Truncated `E₄` has `N − 1` roots in the `q`-disk with `min\|q\| = 0.169`" | **Withdrawn** | Both numbers came from the harness: an indexing slip dropped the constant term, and `exp(−π√3)` was miscomputed. The true picture is `N` roots with `min\|q\| = 0.004333421`, gathering on the orbit images of ρ. |
| "`σ₃ = ζ*ζ*ζ*ζ`", checked as a June claim | **Corrected** | The `dna.py` docstring implies the four-fold power, which is wrong; the identity that holds is `σ₃ = Id₃ * ζ`. |
| "A product of eigenforms is an eigenform with the product eigenvalue" | **Corrected** | False: `a₂(Δ·E₄) = 216 ≠ −51840`. |
| "`zeros(F·G) = zeros(F) ∪ zeros(G)` requires modularity" | **Corrected** | It needs only that the coefficients lie in a domain. |
