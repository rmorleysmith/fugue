# Contribution notes: strong BSD in `formal-conjectures`

*What is genuinely missing from the public `formal-conjectures` Lean repository, what is verified about its
API, and what a real contribution would have to solve. Everything below was checked by compiling
against the actual repository, not by reading it.*

**Setup used.** Cloned the `formal-conjectures` repository (1 873 Lean files, `lean-toolchain`
`v4.33.1`, mathlib pinned to `v4.33.1`), ran `lake exe cache get`, then compiled
[`API-probe.lean`](API-probe.lean) inside the repo:

```
✔ [3577/3577] Built FormalConjecturesForMathlib.TestStrongBSDProbe (1.1s)
Build completed successfully (3577 jobs).
```

So the API facts below are *elaborated*, not inferred.

> **Working copy.** The clone (7.6 GB, mathlib `v4.33.1` already cached, so rebuilds are ~1 s)
> was kept locally as the working environment for the contribution described below.

---

## 1. The finding

`FormalConjectures/Millennium/BSD.lean` states **only the weak conjecture** — that a meromorphic
continuation of the `L`-series has order of vanishing at `s = 1` equal to the Mordell–Weil rank:

```lean
def Weak (K : Type*) [Field K] [NumberField K] [DecidableEq K] : Prop :=
  ∀ (E : WeierstrassCurve K) [E.IsElliptic] [AddGroup.FG E.toAffine.Point] (L : ℂ → ℂ),
    HasMeromorphicContinuation E L →
      meromorphicOrderAt L 1 = AddCommGroup.freeRank E.toAffine.Point
```

The **strong** form — the conjectural evaluation of the leading Taylor coefficient,

```
L^{(r)}(E,1)/r!  =  Ω_E · Reg_E · ∏_p c_p · #Ш(E/ℚ) / #E(ℚ)_tors²
```

— **is not stated anywhere in the repository.** Confirmed by
`grep -rniE "leadingCoeff|strong.*bsd|Lstar|regulator"` over `FormalConjectures/` and
`FormalConjecturesForMathlib/`: no hits for a strong-BSD statement.

Meanwhile the repository **already ships every invariant the strong form needs** in
`FormalConjecturesForMathlib/AlgebraicGeometry/EllipticCurve/`: `GlobalPeriod.lean`,
`Regulator.lean`, `Tamagawa.lean`, `TateShafarevich.lean`, `MinimalDiscriminant.lean`.

That is a real, well-defined gap between a directory that has the ingredients and a file that uses
only two of them. And it is squarely what the repository asks for: its README says it exists to be
"a collection of formalised statements of conjectures" and that definitions not yet in mathlib "can
be added to the `FormalConjecturesForMathlib` directory".

---

## 2. What the probe verified (and where my first reading was wrong)

I first read the signatures and got **four things wrong**. Compiling corrected all four, which is
the argument for compiling rather than reading.

| What I assumed | What is actually true |
|---|---|
| `WeierstrassCurve.realPeriod` | ✅ correct name — but `Real`/`Complex` are `section`s, not namespaces, so `WeierstrassCurve.Real.realPeriod` does **not** exist |
| `WeierstrassCurve.tamagawaProduct` | ❌ it is `WeierstrassCurve.Projective.tamagawaProduct` |
| `WeierstrassCurve.regulator` | ❌ it is `WeierstrassCurve.Affine.Point.regulator`, and it needs `Height.AdmissibleAbsValues K` |
| (unaware) | `tamagawaProduct` and `tateShafarevich` are **`noncomputable`**, as are both periods |

Verified signatures:

```lean
-- GlobalPeriod.lean, namespace WeierstrassCurve (Real / Complex are sections)
noncomputable def realPeriod (W : WeierstrassCurve ℝ) : ℝ := 2 * ∫ x, W.realPeriodIntegrand x
noncomputable def complexPeriod (W : WeierstrassCurve ℂ) : ℝ := 4 * ∫ x : ℂ, W.complexPeriodIntegrand x

-- Tamagawa.lean, namespace WeierstrassCurve.Projective
noncomputable def tamagawaProduct {K} [Field K] [NumberField K] (W : Projective K) : ℕ

-- Regulator.lean, namespace WeierstrassCurve.Affine.Point
--   variable {K} [DecidableEq K] [Field K] [Height.AdmissibleAbsValues K] {W : Affine K}
noncomputable def regulator (W) [Module.Finite ℤ (W.Point ⧸ Submodule.torsion ℤ W.Point)] : ℝ

-- TateShafarevich.lean, namespace WeierstrassCurve.Affine
noncomputable def tateShafarevich [NumberField K] :
    AddSubgroup <| continuousCohomology 1 W.galoisRepresentation
```

Useful supporting fact: mathlib provides `Height.AdmissibleAbsValues K` for number fields
(`Mathlib/NumberTheory/Height/NumberField.lean`, `instance instAdmissibleAbsValues : ...`), so the
regulator's typeclass side is not an obstruction.

---

## 3. The three real obstacles

A serious contribution has to solve these. None is fatal; all are work.

### 3.1 No bridge between the `Affine` and `Projective` models

- Periods and regulator: `WeierstrassCurve.Affine`
- Tamagawa product: `WeierstrassCurve.Projective`
- `BSD.Weak` and Stoll's Mordell–Weil formalisation: `Affine`

There is no `Affine → Projective` conversion in the repository. Verified in the probe: the two live
in different namespaces and the probe must take the model as an explicit argument. Closing this
requires either (a) an explicit affine↔projective dictionary for the invariants, or (b) restating
`tamagawaProduct` for the affine model. **(a) is the better route because it makes the comparison
checkable.**

### 3.2 The leading Taylor coefficient does not exist

`L^{(r)}(E,1)/r!` — the *left-hand side* of the strong formula — has no definition. The repository
has `meromorphicOrderAt L 1` (the order) but nothing that extracts the leading coefficient of the
Laurent expansion at that order. I searched mathlib's `Analysis/Analytic/` for a
`leadingCoeff`/`TaylorCoeff` API and found none suitable.

Nor does the existing `L : ℂ → ℂ` carry enough structure: the strong formula needs `L` to be
*meromorphic at 1 with a Taylor expansion whose leading term is a definite complex number*, and
`HasMeromorphicContinuation E L` is a bare `Prop`. **Defining the leading coefficient — and
proving it is well-defined given `HasMeromorphicContinuation` — is the single largest piece of this
contribution.** It is also genuinely in the spirit of the repository: it is a definition mathlib
lacks, which is exactly what `FormalConjecturesForMathlib/` is for.

This is why my draft [`StrongBSD.lean`](StrongBSD.lean) is marked **not compiled, not verified**:
it writes `leadingCoeff L 1 E` for a function that does not exist. I am leaving it in that state
rather than hiding the gap, because the gap *is* the finding.

### 3.3 Normalisation, and the misformalisation risk

The repository's own README warns: *"Subtle inaccuracies can arise where the formal statement might
not perfectly capture the nuances of the original conjecture"*, mitigation is human review, and
`bench-v{N}` snapshots exist to correct misformalisation (tags are immutable; fixes go into `v{N+1}`).

The strong BSD formula is the worst case for this. Two traps the repo's own files flag or imply:

1. **Regulator normalisation.** `Regulator.lean` states explicitly that *"Over `ℚ`, the canonical
   height here is twice Tau Ceti's height, so a rank-`r` regulator is `2^r` times Tau Ceti's
   regulator"*, citing Silverman *Arithmetic of Elliptic Curves* 2nd ed. Remark VIII.9.8.
2. **Period normalisation.** `realPeriod`'s docstring says it is *"the real period of the Birch and
   Swinnerton-Dyer conjecture, in the convention that absorbs the real Tamagawa number"* — i.e. the
   convention is *already chosen*, and a formalisation must respect it rather than re-derive `Ω`
   from a textbook formula.

A parametric statement (invariants as ℝ-valued arguments) is convention-free and safe; a statement
plugging in the repo's definitions is where the value lies and where the risk is. The right
contribution does both: state the parametric shape, state the plugged-in version, and prove the
plugged-in version *follows from* the parametric one — so the convention choice is isolated in one
place and is itself a checkable claim.

---

## 4. What I would actually submit

In order of increasing difficulty:

1. **The parametric shape.** `StrongBSDShape lc Ω Reg ∏c #Ш #tors : Prop` as a definition, with a
   `@[category research open]` theorem asserting it for `E/ℚ` under the same hypotheses as
   `BSD.Weak` (elliptic, Mordell–Weil, meromorphic continuation) plus finiteness of `Ш`. This is
   correct as stated, is the same identity the corpus' `StrongBSD` carries, and requires no new
   mathlib definitions. It is a legitimate statement of a real conjecture.

2. **The affine↔projective bridge.** Small, mechanical, and it unblocks everything else.

3. **The leading-coefficient definition.** `leadingCoeffAt (L : ℂ → ℂ) (z : ℂ) : ℂ` for `L`
   meromorphic at `z`, with the well-definedness lemma. This belongs in
   `FormalConjecturesForMathlib/` and is independently useful — any formalisation of a
   Taylor-coefficient conjecture (and BSD is not the only one) needs it.

4. **The plugged-in statement**, with the normalisation documented and the reduction to (1)
   proved.

5. **Optionally**, the corpus' conditional consequences — `w = −1 ⇒ Λ_E(1) = 0` and hence
   analytic rank ≥ 1 — as `@[category textbook]` lemmas. These are short, true, and they are the
   part of the corpus' `HSLNBSD.lean` that stands once its `sorry`s are removed.

**One thing not to do:** present any of this as "BSD proved in Lean". `math-connections.md`
describes `HSLNBSD.lean` as "BSD stated and formally proved in Lean, modulo 5 cited sorries", and
the audit grades that sentence as false (see [`../formal-status.md`](../formal-status.md) §3). This
repository's whole design — statements without proofs, `@[category research open]`, immutable
benchmark tags — keeps the framing accurate. That is a feature.

---

## 5. Cross-reference to the corpus

The corpus' `HSLNBSD.lean` (in `../workspace/Fugue/HSLNBSD.lean`, 630 lines, 16 `sorry`s) states the
same identity as `StrongBSDShape`:

```lean
def StrongBSD (_E : EllipticL)
    (leadingCoeff period regulator tamagawaProduct : ℝ)
    (shaOrder torsionOrder : ℕ) : Prop :=
  leadingCoeff * (torsionOrder : ℝ) ^ 2 =
    period * regulator * tamagawaProduct * (shaOrder : ℝ)
```

This is the standard normalisation and it is **identical in shape** to what the repository lacks.
Two observations:

- It takes the invariants as **arguments**, which is exactly the convention-free parametric form
  recommended in §4.1. So on this one point the corpus' statement is *better designed* than plugging
  in the repo's definitions would be — because it makes no normalisation claim at all.
- It is therefore **not** a drop-in contribution, and the corpus' `EllipticL` structure (with
  `Λ_E`, `w`, ranks, and their axioms as *fields*) has no counterpart in the repository. The
  contribution is the *statement plus the connection work*, not the corpus' file.

The corpus' `fixedAxis_eq_one` (`(2−s).re = s.re ↔ s.re = 1`), `central_vanishing_of_rootSign_neg`
(`w = −1 ⇒ Λ_E(1) = 0`) and the product-composition lemmas (`BSDRank_prod`,
`two_curves_compose_isMult`) are the parts worth salvaging: short, true, and expressible against
mathlib directly.
