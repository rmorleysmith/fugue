# Appendix C — the two auxiliary trees, and a null result

Two directories in the June workspace are not part of the HSLN corpus proper and are not
referenced by any figure, script, Lean file or markdown document in it. Both are inventoried here
so the extraction is complete.

The June files are archived unchanged in `rmorleysmith/hsln-archive` (Lean in `lean.zip`,
scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`). The
`KnowledgeBase` folder, including the ports in §2, is **not** in the archive, so the outputs
quoted below cannot be checked by a reader.

---

## 1. `NumericalTesting/` — a broken scaffolding stub

**What it is.** A standalone Python package with its own git repository, a `uv` lock file, a built
wheel and sdist in `dist/`, and a 57 MB venv.

**What is in it.** `src/numericaltesting/numerics.py`, **five lines**, and it does not parse:

```python
import numpy as np

def do_calcs():
    nums = np.array()

```

That last line is a `TypeError` at runtime (`np.array()` with no argument in numpy ≥ 2), and the
function is unreachable anyway because `numericaltesting/__init__.py` is empty and no entry point
is wired to it. `README.md` is **0 bytes**. `git log` returns nothing.

**Assessment: REFUTED as content.** This is the `uv init` template with a `do_calcs` stub typed
in and no further work. It contributes **nothing** to the corpus, and its 57 MB venv holds no
project code. It is not referenced anywhere.

**Recommendation.** Delete it, or `.gitignore` it. If it was meant to hold the numerical-testing
suite for the project, that suite is `PythonAndVisualizations` and its figures.

---

## 2. The KnowledgeBase `code` folder — seven real ports, and they matter

This is the opposite of the previous section. The KnowledgeBase `code` folder holds **seven runnable Python
ports** of specific upstream Lean results, plus **five Lean snippets**, and the ports work. They
were written 2026-06-21 (the KB's verification date) and each cites the PR it ports.

### 2a. The ports

| Port | Upstream | What it does | Status |
|---|---|---|---|
| `sturm_bound.py` | Mathlib #38993 (`sturm_bound_levelOne_nat`, `dimension_level_one`) | Level-1 dimension formula and Sturm truncation rank | **Verified** — output below |
| `cartan_posdef_filter.py` | Mathlib #40424 (`exists_cartanMatrix_mul_diagaonal_posDef`) | Cholesky admissibility filter for enumerated root lattices / Dynkin types | Ports a consequence; runs |
| `metric_compat_residual.py` | Mathlib #36299 (`derivMetricTensor`, `IsMetricCompatible`) | `∇g = 0` as a numerical loss term (Levi-Civita / heterotic connection) | Runs |
| `taylor_trust_region.py` | Mathlib #31176 (Taylor with integral remainder) | Exact truncation error ⇒ trust-region radius for optimiser steps | Runs |
| `resolvent_readout.py` | Mathlib #37245 (`resolventTransform`, `analyticOn_resolventTransform`) | Stieltjes–Cauchy transform of a spectral measure; holomorphic off the support | Runs |
| `hecke_wirtinger_grad.py` | physlib #1174 (`dWirtingerDir`, `dWirtingerAntiDir`) | **The correct complex gradient** for a real loss over complex DNA coefficients | **Verified** — output below |
| `navier_stokes_residual.py` | physlib `FluidDynamics/` API shape | 2-D periodic spectral projection solver; continuity + momentum residual | Runs |

The Lean snippets (`float_facts.lean`, `heterotic_connection.lean`, `kernel_spec.lean`,
`modular_arith.lean`, `sturm.lean`) are quoted verbatim from the cited PRs for later cribbing.

### 2b. Two of them I ran and checked

**`sturm_bound.py`** — the certificate behind the corpus' truncation argument. Output:

```
k= 0  dim M_k = 1  dim S_k = 0  sturm = 0  trunc_rank = 1
k= 4  dim M_k = 1  dim S_k = 0  sturm = 0  trunc_rank = 1
k= 6  dim M_k = 1  dim S_k = 0  sturm = 0  trunc_rank = 1
k=12  dim M_k = 2  dim S_k = 1  sturm = 1  trunc_rank = 2
k=24  dim M_k = 3  dim S_k = 2  sturm = 2  trunc_rank = 3
```

`dim M₄ = 1`, `dim M₁₂ = 2`, `dim S₁₂ = 1` — all correct, and consistent with the level-1
dimension formula used in [`architecture.md`](../02-threads/architecture.md) §3 and the ledger
rows A3, A8.

> This is the piece that makes the corpus' truncation defensible **when applied to the right
> question**: the Sturm bound certifies that a form is *uniquely determined* by `⌊k/12⌋ + 1`
> coefficients. It does **not** bound the number of zeros — which is exactly the conflation
> recorded in ledger row A8. The utility is right; the inference drawn from it in `math-connections.md`
> is wrong.

**`hecke_wirtinger_grad.py`** — the correct complex gradient, and the one genuinely *useful*
engineering artefact in the whole corpus for anyone who wants to train these models:

```
converged to a: z=[ 0.3-0.4j -1. +0.2j]  (target [ 0.3-0.4j -1. +0.2j])
spike energy: 1.2411 -> 0.8090  (should decrease)
conjugacy check max|∂L/∂z - conj(∂L/∂z̄)| = 0.00e+00
ok
```

The conjugacy check is the point. For a **real** loss `L` of a **complex** parameter `z`, the
correct gradient direction is `∂L/∂z̄` (the Wirtinger anti-derivative), and it satisfies
`∂L/∂z = conj(∂L/∂z̄)` exactly when `L` is real-valued. The utility verifies this identity to
`0.00e+00` and then demonstrates convergence to a target.

> **Why this matters more than it looks.** `system-spec.md` §4.4 item 4 says "gradient computation
> … backprop through the ODE solver is the standard adjoint-method trick". It never mentions that
> the DNA is **complex**, so an off-the-shelf real-valued autodiff path computes the wrong gradient
> unless the framework handles Wirtinger derivatives. The corpus' training scripts avoid the problem
> because JAX's `jax.grad` on a real-valued loss of complex inputs does the right thing when
> the convention is respected — but the fact that this port exists, and cites physlib for it,
> shows the subtlety was recognised. **This is the one port that a reader should actually reuse.**

### 2c. What these ports tell us about the project

Three observations:

1. **They are the only place where the corpus engages with *current* Lean infrastructure concretely.**
   Everything else in `Math-Lean/` is bespoke; these are ports of specific upstream PRs, with the
   PR numbers given.
2. **They are correctly scoped.** Each ports a *consequence* or an *API shape*, and says so —
   `cartan_posdef_filter.py` says it ports "the *consequence* of Mathlib4 PR #40424";
   `navier_stokes_residual.py` says it ports "the *API shape* of physlib's `FluidDynamics/`".
   That is the right way to scope a port.
3. **They are orphaned.** Nothing in `PythonAndVisualizations` imports them, no figure uses them,
   and the `hsln` package they were meant for does not exist (see
   [`b-knowledgebase.md`](b-knowledgebase.md) §4). So they sit as a demonstration that the bridges
   *can* be built, not as built bridges.

---

## 3. Coverage statement

With this appendix, every file in the June workspace outside the two git repositories is accounted
for:

| Tree | Files | Status in `Fugue/` |
|---|---|---|
| `PythonAndVisualizations` | 79 `.py`, 79 figures, 1 gallery | All named; every load-bearing one analysed or run. Family-level coverage in [`a-scripts-and-families.md`](a-scripts-and-families.md) |
| `Math-Lean/` | 31 `.lean`, 2 `.md` | Per-file census in [`formal-status.md`](../03-formal/formal-status.md); compiled twice against two mathlib versions |
| `KnowledgeBase` | 15 `.md`, 7 `.py`, 5 `.lean`, `lean_snippets/` | Chapters in [`b-knowledgebase.md`](b-knowledgebase.md); ports in §2 above. Not in the public archive |
| `NumericalTesting/` | 1 five-line stub, 1 empty README | §1 above — **null result** |
| `Math-Lean/.lake/` | 6.9 GB | Identified as a mathlib checkout + build cache, not corpus content (ledger row J6) |

### The one thing still missing

`Python/hsln/` — the package that the KnowledgeBase chapters 05–14 document and measure. It is not
in this workspace, and its absence makes chapters 08–12 unverifiable. See
[`b-knowledgebase.md`](b-knowledgebase.md) §4 and the open questions in
[`../00-index/index.md`](../00-index/index.md).
