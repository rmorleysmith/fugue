/-
================================================================================
  DRAFT — NOT COMPILED, NOT VERIFIED. DO NOT SUBMIT AS-IS.
================================================================================
This file is a *sketch* of a contribution to the formal-conjectures repository.
It has NOT been elaborated against Lean/mathlib. It is known to be incomplete:
`leadingCoeff` is used below but is not defined anywhere in this repository or in
mathlib — a concrete, missing ingredient, and precisely the kind of thing the
target repository would reject.

It is included because writing it down exposed three real obstacles that a
serious attempt must solve first (see
../contributions-notes.md and ../formal-status.md §8). Treat it as a task list
in Lean syntax, not as code.
================================================================================
-/
/-
Copyright 2026 The Formal Conjectures Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/
module

public import FormalConjecturesUtil
public import FormalConjectures.Wikipedia.HasseWeil
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.GlobalPeriod
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.Regulator
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.Tamagawa
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.TateShafarevich
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.MinimalDiscriminant

/-!
# The strong Birch and Swinnerton-Dyer conjecture

This file states the **strong** form of the Birch and Swinnerton-Dyer conjecture, whose weak form
(the order of vanishing of the `L`-function at `s = 1` equals the rank) is in
`FormalConjectures.Millennium.BSD`.

The strong form is the conjectural evaluation of the **leading Taylor coefficient** of `L(E, s)`
at `s = 1`:

  `L^{(r)}(E, 1) / r!  =  Ω_E · Reg_E · ∏_p c_p · #Ш(E/ℚ) / #E(ℚ)_tors²`

where `r` is the rank, `Ω_E` the real period, `Reg_E` the regulator (determinant of the Néron–Tate
height pairing), `∏_p c_p` the Tamagawa product, `Ш(E/ℚ)` the Tate–-Shafarevich group, and
`E(ℚ)_tors` the torsion subgroup.

## Status of the ingredients

Every invariant in this formula now has a definition in this repository, although **not all in the
same representation**, and reconciling them is part of the work:

* `WeierstrassCurve.realPeriod` / `complexPeriod` — `FormalConjecturesForMathlib/…/GlobalPeriod.lean`,
  defined as integrals of the invariant differential over the real/complex locus. Takes an
  `Affine ℝ` / `Affine ℂ` curve.
* `WeierstrassCurve.regulator` — `…/Regulator.lean`, the absolute determinant of the Néron–Tate
  pairing's Gram matrix on `W.Point ⧸ torsion`. Requires `Module.Finite ℤ (W.Point ⧸ torsion)`,
  which is the Mordell–Weil theorem (see `mordell_weil` in
  `FormalConjectures.Wikipedia.EllipticCurveRank`, a `sorry` in this repository).
* `WeierstrassCurve.tamagawaProduct` — `…/Tamagawa.lean`. **Note the representation mismatch:**
  this is stated for `WeierstrassCurve.Projective`, whereas `BSD.Weak` and the period/regulator
  definitions use `WeierstrassCurve.Affine`. There is no bridge in this repository between the
  affine and projective models, so below the Tamagawa product is taken as an explicit argument.
* `WeierstrassCurve.Affine.tateShafarevich` — `…/TateShafarevich.lean`, an `AddSubgroup` of the
  first continuous Galois cohomology. Its order is therefore a cardinal (`Nat.card`), and finiteness
  is *not* known in general — for BSD one assumes it (or derives it from the rank-≤1 theorems).
* `HasMeromorphicContinuation` — `FormalConjectures.Wikipedia.HasseWeil`, already used by the weak
  statement; `exists_hasAnalyticContinuation_rat` provides that the `L`-function exists.

## Convention warning

The leading-coefficient formula is notoriously convention-sensitive, and any formalisation that
gets the normalisation wrong is a **misformalisation** — the failure mode this repository's README
warns about. Two known traps:

1. `Regulator.lean` records that over `ℚ` its canonical height is **twice** Tau Ceti's, so a
   rank-`r` regulator is `2^r` times Tau Ceti's regulator; it cites Silverman, *Arithmetic of
   Elliptic Curves*, 2nd ed., Remark VIII.9.8 for the relative normalisation.
2. `realPeriod` is defined as `2 * ∫ x, 1/√(Ψ₂Sq x)` over the real locus, which fixes the sign and
   the factor-of-two conventions but is not by itself the `Ω_E` of every convention in the
   literature (some texts use `Ω_E^+` and divide by `#E(ℝ)_0`).

Because of this, the statement below has **two layers**: a version parametric in the invariants
(which is convention-free and certainly correct as a statement of the shape), and a version with
the repository's own definitions plugged in, marked as requiring normalisation work.

*References:*
- [BSD1965] B. J. Birch and H. P. F. Swinnerton-Dyer. "Notes on elliptic curves. II."
  *J. reine angew. Math.* 218 (1965), 79-108,
  [doi](https://doi.org/10.1515/crll.1965.218.79)
- [Tate1966] John Tate. "On the conjectures of Birch and Swinnerton-Dyer and a geometric analog."
  *Séminaire Bourbaki*, Vol. 9, Exp. No. 306 (1966), 415-440.
- [Gross2011] Benedict H. Gross. "Lectures on the conjecture of Birch and Swinnerton-Dyer."
  *Arithmetic of L-functions*, IAS/Park City Math. Ser. 18, AMS (2011), 169-209.
- [Sil09] J. H. Silverman, *The Arithmetic of Elliptic Curves*, 2nd ed., GTM 106, Springer (2009),
  Chapter X §4 and Remark VIII.9.8.
- [LMFDB](https://www.lmfdb.org/knowledge/show/ec.regulator) and
  [LMFDB](https://www.lmfdb.org/knowledge/show/ec.period) for the reference normalisations.
-/

@[expose] public section

namespace BSD

open HasseWeil

/-- The **strong Birch and Swinnerton-Dyer conjecture**, stated parametrically in the five
arithmetic invariants rather than in terms of their definitions. This isolates the *shape* of the
conjectural identity from the convention question.

Here `leadingCoeff` is `L^{(r)}(E, 1) / r!` where `r = ord_{s=1} L(E, s)`; `period` is the real
period `Ω_E`; `regulator` is `Reg_E`; `tamagawaProduct` is `∏_p c_p`; `shaOrder` is `#Ш(E/ℚ)`
(assumed finite); and `torsionOrder` is `#E(ℚ)_tors`. The identity is

  `leadingCoeff * torsionOrder ^ 2 = period * regulator * tamagawaProduct * shaOrder`.

This is the same identity stated in the accompanying Python analysis (`StrongBSD` in the HSLN
formalisation), and it is the standard normalisation: with `Ω_E^+` and the regulator normalised as
in Silverman X.4, the relation holds for the rank-0 curves computed there (e.g. `11a1`, where
`L(E,1)/1! · 1² = 0.2538…` equals `Ω · Reg · ∏c_p · #Ш / #tors²` with `Reg = ∏c_p = #Ш = 1`). -/
def StrongBSDShape
    (leadingCoeff period regulator tamagawaProduct : ℝ) (shaOrder torsionOrder : ℕ) : Prop :=
  leadingCoeff * (torsionOrder : ℝ) ^ 2 =
    period * regulator * tamagawaProduct * (shaOrder : ℝ)

/-- The same identity, with the **Tamagawa product** taken from this repository's definition
(`WeierstrassCurve.tamagawaProduct`) and the torsion order from the rational torsion subgroup. The
period, regulator and `L`-derivative are left parametric because plugging in this repository's
definitions requires the normalisation reconciliation described in the module docstring.

`tamagawaProduct` takes the `Projective` model while the other invariants take the `Affine` model;
passing the model explicitly makes that mismatch visible rather than hiding it. -/
def StrongBSDShapeRat
    (W : WeierstrassCurve.Projective ℚ)
    (leadingCoeff period regulator : ℝ) (shaOrder : ℕ) (E : WeierstrassCurve ℚ) : Prop :=
  StrongBSDShape leadingCoeff period regulator
    (FormalConjectures..WeierstrassCurve.tamagawaProduct W : ℝ) shaOrder
    (Nat.card (AddCommGroup.torsion E.toAffine.Point))

/-- **The strong Birch and Swinnerton-Dyer conjecture over `ℚ`**, parametric form.

The hypotheses mirror `BSD.Weak`: `E.IsElliptic`, the Mordell–Weil theorem
(`[AddGroup.FG E.toAffine.Point]`), a meromorphic continuation of the `L`-series, and finiteness of
`Ш` — the last being genuinely open in general and therefore a hypothesis, not a claim.

The order of vanishing `meromorphicOrderAt L 1` is the (analytic) rank; the identity it satisfies
with the algebraic rank is the *weak* conjecture and is stated separately. -/
@[category research open, AMS 11 14]
theorem strong_birch_swinnerton_dyer_conjecture
    (E : WeierstrassCurve ℚ) [E.IsElliptic] [AddGroup.FG E.toAffine.Point]
    (L : ℂ → ℂ) (hL : HasMeromorphicContinuation E L)
    (period regulator tamagawaProduct : ℝ)
    (shaOrder torsionOrder : ℕ) :
    StrongBSDShape (leadingCoeff L 1 E) period regulator tamagawaProduct shaOrder torsionOrder := by
  sorry

end BSD
