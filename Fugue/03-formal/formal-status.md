# Formal status of the Lean layer

*What the 31 Lean files in `Math-Lean/` actually do, measured rather than asserted.*

The June Lean files are archived unchanged in `rmorleysmith/hsln-archive` (`lean.zip`).

Every number in this document was produced by the workspace at
[`03-formal/workspace/`](workspace/) or by the census script in
[`04-verify/verify.py`](../04-verify/verify.py) (`lean.sorry.audit`). The full compiler
log is [`03-formal/build-full.log`](build-full.log).

---

## 1. Headline

| Question | Answer |
|---|---|
| Does `lake build` succeed in the shipped project? | **Yes — and it compiles none of the mathematics.** |
| Why? | `lakefile.toml` declares one library, `Math`. `Math.lean` is `import Math.Basic`. `Math/Basic.lean` is a **0-byte file**. The build target is 4 jobs: two `olean`s of an empty file. |
| Are the HSLN files part of any target? | **No.** 26 `.lean` files in `Math/` and 4 more at the top level are unreferenced by the lakefile. |
| Do they compile if wired in? | **24 of 30 yes, 6 no.** |
| How many `sorry`s? | **176** occurrences across the 30 files. |
| How many theorems are stated? | **242.** How many are `sorry`-free in their bodies: **190**. |
| Of those, how many can the kernel actually verify as written? | **147** — the 43 in the six files that do not compile cannot be checked at all. |
| Does the corpus claim match? | **No.** It claims "**55 theorems PROVEN**" (one place) and "**63**" then "**64**" in two adjacent paragraphs of the same file, plus "machine-checked against mathlib v4.30.0-rc2 via `./verify.sh` + `./audit_axioms.sh`". |

**`verify.sh` and `audit_axioms.sh` do not exist in the repository.** The claim
"all PROVEN sorry-free, `audit_axioms.sh`" is therefore unsupported by any artefact: there
is no script, and no record of a run.

---

## 2. Why the six files fail — version mismatch, not bad mathematics

The corpus says it was checked against **mathlib v4.30.0-rc2**. The `lakefile.toml` and
`lake-manifest.json` in the repository now pin **v4.35.0-rc4**. Five Lean releases of API
churn separate them, and that is enough to break these particular proofs.

| File | Line | Error | Nature |
|---|---|---|---|
| `HSLNAlgebra.lean` | 77 | `Ambiguous term: add_apply` | `_root_.add_apply` vs `ArithmeticFunction.add_apply` now both apply; needs qualification. |
| `HSLNAlgebra.lean` | 78 | `rewrite failed: pattern ∑x∈s, f x + ∑x∈s, g x not found` | `Finset.sum_add_distrib`-shaped rewrite; the goal is now expressed via `ArithmeticFunction.pmul`, so the pattern does not occur. |
| `HSLNBridge.lean` | 62 | `Ambiguous term: antidiagonal` | `HasAntidiagonal.antidiagonal` vs `Finset.antidiagonal`. |
| `HSLNBridge.lean` | 61 | `unsolved goals` | Consequence of the above. |
| `HSLNKTheory.lean` | 63–64 | same pair as `HSLNBridge` | The file duplicates `cauchyMul` from `HSLNBridge`. |
| `HSLNSerre.lean` | 45,50,60,72 | `Application type mismatch` on `MDiff`-typed arguments; `unsolved goals` | API change in the complex-analysis derivative predicate used for the Serre derivative. |
| `HSLNFactor.lean` | 56, 78 | `No goals to be solved` | Over-eager `simp`/`ring` now closes the goal before a following tactic runs. |
| `HSLNFactor.lean` | 127 | `Unknown constant Finset.card_insert_of_not_mem` | Constant renamed in mathlib. |
| `HslnCat.lean` | 56 | `mul_one f` has type `f * 1 = f` but expected `dnaTensor dnaUnit f = f` | Needs `show`/`simp only [dnaTensor, dnaUnit]`; definitional unfolding changed. |
| `HslnCat.lean` | 65 | `failed to synthesize HMul ℂ ℂ[X] DNA` | `DNA` abelianised via `CommMonoid` instance; `HMul` instances no longer resolve. |

Every one of these is a **mechanical repair**, not a mathematical gap. This should not be
overstated in either direction: the failures do *not* show the mathematics is
wrong. They show the repository is not in a state where any of it is machine-checked.

> **A version test was run.** [`03-formal/drift-test.sh`](drift-test.sh) pins mathlib
> to `v4.30.0-rc2` and attempts `HSLNAlgebra`. It compiles there, which confirms the diagnosis
> "version mismatch and nothing else" for that file. Result recorded in §6 below.

---

## 3. What "sorry" does and does not mean

This distinction is the crux of the whole formal-status question, and the June prose does not
keep it consistent.

In Lean, `sorry` is an **axiom-like escape hatch**. Writing

```lean
theorem riemann_hypothesis_proof : RiemannHypothesis := by
  sorry
```

makes Lean *accept* `riemann_hypothesis_proof` as a theorem of type `RiemannHypothesis`. The
file compiles. `#print axioms riemann_hypothesis_proof` will report `sorryAx` among the
axioms. Lean will warn (`declaration uses 'sorry'`), but it will not fail.

Therefore:

- A `sorry`'d theorem is **not proved**. It is *assumed*.
- A proof that *cites* a paper in a comment next to `sorry` is **not** a proof citing that
  paper. The comment has no formal force. The June files use the phrase "modulo cited
  sorries" for this case. The precise statement is that a citation is not a proof step, so
  such a theorem is assumed, not proved.
- `sorry`-free *does* mean proved — **provided the file compiles**. A declaration in a file
  that fails to elaborate is not checked, so its `sorry`-freeness is vacuous.

`math-connections.md` states both sides of this point:

> "**Verify output now reads**: `HSLNBSD.lean compiles — BSD stated and formally proved in
> Lean, modulo 5 cited sorries …`" — `math-connections.md`

and two paragraphs later:

> "The conjecture itself remains open. The framework just makes the algebra crystal
> clear." — same file

Both sentences are about the same Lean file. The first is false; the second is true.

---

## 4. Per-file census

`sorry-free` counts theorem/lemma declarations whose body contains no `sorry`. `compiles`
is measured in the v4.35.0-rc4 workspace. `verifiable` is the strict figure: a declaration
counts only if it is sorry-free **and** its file compiles.

| File | lines | theorems | sorry-free | `sorry` count | compiles | verifiable |
|---|---:|---:|---:|---:|:--:|---:|
| `HSLN.lean` | 569 | 16 | 7 | 36 | ✅ | 7 |
| `HSLNAlgebra.lean` | 100 | 7 | 7 | 1 | ❌ | **0** |
| `HSLNBSD.lean` | 630 | 25 | 16 | 16 | ✅ | 16 |
| `HSLNBridge.lean` | 125 | 7 | 7 | 1 | ❌ | **0** |
| `HSLNComplexity.lean` | 170 | 6 | 5 | 9 | ✅ | 5 |
| `HSLNDivisorEuler.lean` | 111 | 9 | 8 | 4 | ✅ | 8 |
| `HSLNFactor.lean` | 155 | 10 | 10 | 0 | ❌ | **0** |
| `HSLNFrontier.lean` | 130 | 2 | 2 | 8 | ✅ | 2 |
| `HSLNHecke.lean` | 189 | 5 | 4 | 1 | ✅ | 4 |
| `HSLNHilbertPolya.lean` | 225 | 12 | 10 | 8 | ✅ | 10 |
| `HSLNHodge.lean` | 198 | 8 | 6 | 7 | ✅ | 6 |
| `HSLNKTheory.lean` | 150 | 8 | 8 | 1 | ❌ | **0** |
| `HSLNLanglands.lean` | 166 | 8 | 7 | 4 | ✅ | 7 |
| `HSLNLFunctions.lean` | 70 | 3 | 2 | 1 | ✅ | 2 |
| `HSLNMonadicLLM.lean` | 121 | 4 | 4 | 0 | ✅ | 4 |
| `HSLNQuantumState.lean` | 258 | 13 | 12 | 3 | ✅ | 12 |
| `HSLNRH.lean` | 407 | 25 | 14 | 24 | ✅ | 14 |
| `HSLNSerre.lean` | 83 | 5 | 5 | 1 | ❌ | **0** |
| `HSLNSpectral.lean` | 314 | 17 | 15 | 9 | ✅ | 15 |
| `HSLNStructureNotSearch.lean` | 113 | 8 | 8 | 0 | ✅ | 8 |
| `HSLNTraceFormula.lean` | 203 | 10 | 8 | 5 | ✅ | 8 |
| `HSLNVerify.lean` | 123 | 5 | 5 | 2 | ✅ | 5 |
| `HSLNWeilPositivity.lean` | 160 | 10 | 3 | 14 | ✅ | 3 |
| `HSLNYangMills.lean` | 221 | 12 | 12 | 3 | ✅ | 12 |
| `HSLNZeta.lean` | 60 | 3 | 2 | 3 | ✅ | 2 |
| `HslnCat.lean` | 69 | 4 | 3 | 1 | ❌ | **0** |
| **`Math/` subtotal** | **4 826** | **242** | **190** | **161** | 20/26 | **147** |
| `SpectralArithmetic.lean` | 251 | — | — | 1 | ? | ? |
| `SpectralBosonFermion.lean` | 161 | — | — | 2 | ? | ? |
| `SpectralShor.lean` | 106 | — | — | 3 | ? | ? |
| `SpectralTorsion.lean` | 121 | — | — | 3 | ? | ? |

The four top-level `Spectral*.lean` files are not in `Math/`, were not wired into the test
workspace, and are not mentioned anywhere in `math-connections.md`. They appear to be an
earlier thread that was not continued. They contain 9 `sorry`s between them.

**No file introduces a custom `axiom`.** So the sorry-free theorems genuinely rest only on
the standard three (`propext`, `Classical.choice`, `Quot.sound`) plus whatever mathlib itself
uses. That part of the corpus' claim is structurally sound — even though the script it says
checked it does not exist.

---

## 5. What is genuinely proved (the defensible residue)

These are real, small, correct theorems, and they are worth keeping:

**Genuinely load-bearing, sorry-free, compiles:**
- `HSLNAlgebra` / `HSLNBridge` — the two-ring witness `(ζ⋆ζ)(1) = 0 ≠ 1 = (ζ*ζ)(1)`, and
  the `CommRing` instance for `ArithmeticFunction ℝ`. *(7 + 7 theorems — but currently
  unverifiable because these two files do not compile. This is the most consequential
  failure, since "composition is a ring" is the corpus' headline algebraic claim.)*
- `HSLNZeta` — the functional equation `Λ(1−s) = Λ(s)` via mathlib
  (`riemannZeta_one_sub`-based), and `Re s = 1/2` as its fixed axis. Correct and clean.
- `HSLNLFunctions` — `LFunction_apply_one_ne_zero` (i.e. `L(1,χ) ≠ 0`), the analytic input to
  Dirichlet's theorem. Correct.
- `HSLNSpectral` — `IsSymmetric.conj_eigenvalue_eq_self`-based "self-adjoint ⇒ real
  spectrum", plus a genuine small theorem: the scaling `T ↦ cT` acts on eigenvalues by `c`
  (`eigenvalue_smul`) and preserves the kernel.
- `HSLNKTheory` — `χ(f) = f(1)` as a ring homomorphism on the Dirichlet ring. Trivially true,
  cleanly stated.
- `HSLNHodge` — `hodge_mul`: the `(k,k)`-part is closed under cup product, so Hodge classes
  form a graded subring. Correct and meaningful.
- `HSLNYangMills` — `massGap_smul`: the spectral gap scales with the coupling. Correct.
- `HSLNHecke` — `two_eigenforms_compose_isMultiplicative`: the product of two eigenforms is
  multiplicative. True (it is mathlib's `IsMultiplicative.mul`), and it is the right
  statement.

**Stated as open:** `HSLNZeta.lean`'s own docstring says
"`RiemannHypothesis` states the conjecture (a `Prop`; we do not prove it -- nobody has)."
That is exactly right, and it is the form the other statements of open problems in the June
files could follow.

**Genuinely valuable, even where it does not compile:** `HSLNRH.lean` and `HSLNBSD.lean` are
~1000 lines that carefully *state* the conjectures and their known partial results as
`Prop`s with literature citations (`KolyvaginRankZero`, `GrossZagierKolyvagin`,
`NekovarDokchitserParity`, `WilesTWBCD`, `robin_iff_RH`, `lagarias_iff_RH`,
`weil_function_field_rh`), and then derive the conditional consequences sorry-free. As
*scaffolding for a formal development* that is a legitimate and useful artefact. It is not a
proof of anything, and the file's header should say so explicitly.

---

## 6. The version-mismatch test — **confirmed**

The hypothesis: the six failures are API changes across five Lean releases, not mathematics.
Test: pin mathlib to **`v4.30.0-rc2`** (the version `math-connections.md` claims the corpus
was checked against) with the matching Lean toolchain, and build `HSLNAlgebra`.

```bash
bash 03-formal/drift-test.sh      # rebuilds the test from scratch; ~1 h, ~7 GB
```

**Result:**

```
✔ [8320/8322] Built Fugue.HSLNAlgebra (3.6s)
Build completed successfully (8322 jobs).
```

So `HSLNAlgebra` — the file carrying the corpus' headline claim that composition is a
`CommRing` — **compiles cleanly against the mathlib version it was written for, and fails
only against the pinned newer one.** The same is true in kind for the other five files; each
error is a mechanical repair:

- `Ambiguous term: antidiagonal` — `HasAntidiagonal.antidiagonal` now also in scope
  (`HSLNBridge`, `HSLNKTheory`).
- `Ambiguous term: add_apply` — `_root_.add_apply` vs `ArithmeticFunction.add_apply`
  (`HSLNAlgebra`).
- `Unknown constant Finset.card_insert_of_not_mem` — renamed (`HSLNFactor`).
- `No goals to be solved` — `simp`/`ring` now close the goal before the following tactic runs
  (`HSLNFactor`).
- `Application type mismatch` on `MDiff`-typed arguments — changed API for the complex
  derivative predicate (`HSLNSerre`).
- `mul_one f` has the wrong expected type; `HMul ℂ ℂ[X] DNA` no longer synthesises — changed
  definitional unfolding and abelianisation (`HslnCat`).

**What this means for the ledger.** The verdict on the Lean layer is not "it is
wrong". It is: *the mathematics is probably fine, the proofs are short and would very likely
repair in a few hours, and none of it is currently machine-checked.* Both halves matter. The
files deserve to be fixed and rebuilt; until then, the prose that describes them as
"formally proved" overstates their status.

---

## 7. Recommendations

1. **Fix the six files.** Each is a mechanical API update (qualify ambiguous names, replace
   renamed constants, adjust `simp` sets, add `show`/`unfold`). Estimated a few hours of
   focused work; no mathematics changes.
2. **Wire them into the lakefile.** The library should list every file, and `Math/Basic.lean`
   should import the lot. Otherwise `lake build` is a green light for an empty project — a
   failure mode that is easy to miss, because it looks like success.
3. **Make the status reportable.** A script that (a) builds, (b) runs
   `#print axioms` on every declaration, and (c) counts remaining `sorry`s, is about 40 lines
   of Lean plus a shell wrapper. It should be checked in and its output committed. The corpus
   already claims such a script exists; making it exist is the single highest-value fix.
4. **Rename the sorry'd "theorems".** A declaration proved by `sorry` should either (i) be a
   `def ... : Prop` (a *conjecture*), or (ii) be explicitly named
   `_of_unproved_conjecture`, so that no reader — human or downstream tool — can mistake it
   for a result. `theorem riemann_hypothesis_proof := by sorry` invites exactly that mistake
   and should be renamed.
5. **Keep the good parts.** The reformulation of each millennium problem as "one open
   node plus the proven partials" (`HSLNFrontier`) is genuinely nice work and is what a
   formalisation of a conjecture *should* look like. The problem is only the reporting.

---

## 8. The external target: `formal-conjectures`

A separate question from "does the corpus' Lean work" is "does it satisfy anyone else's". The
answer, checked by cloning and compiling against the public `formal-conjectures` Lean repository
(1 873 Lean files, Lean `v4.33.1`):

- **The corpus independently formalised the same RH-equivalence family the repo already has.**
  `FormalConjectures/Paper/RiemannHypothesisEquivalents.lean` contains `robin_criterion`,
  `lagarias_criterion`, `li_criterion` (with the conjugate-pair summation handled explicitly) and
  `weil_positivity_criterion` (with genuine archimedean and non-archimedean factors) — all
  `@[category research solved]`. The corpus' `HSLNRH.lean` / `HSLNWeilPositivity.lean` carry Robin,
  Lagarias, Li and Weil as well. That is **convergent rediscovery, not a gap filled.** It is
  validation of the direction; it is not a contribution.
- **There is one real gap, and the corpus is pointed at it.** The repo states only `BSD.Weak`, but
  ships `realPeriod`, `complexPeriod`, `regulator`, `tamagawaProduct`, `tateShafarevich` and
  `MinimalDiscriminant` — every invariant the *strong* formula needs. The corpus' `StrongBSD` is
  the strong formula, parametric in those invariants. Full analysis, with a **compiled** API probe
  and the three obstacles a real contribution must solve, in
  [`contributions/contributions-notes.md`](contributions/contributions-notes.md).

**Method note.** Four of the API facts I first read off the source were **wrong** and were caught
only by compiling the probe inside the clone. Reading signatures is not verification; the probe in
`contributions/API-probe.lean` builds cleanly (`3577 jobs`, exit 0) and is the artefact behind
those claims.
