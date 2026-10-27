module
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.GlobalPeriod
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.Regulator
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.Tamagawa
public import FormalConjecturesForMathlib.AlgebraicGeometry.EllipticCurve.TateShafarevich

/-! Probe: do the strong-BSD ingredients exist, and do they cohere? -/

@[expose] public section

namespace Probe

/-- The strong-BSD *shape*, parametric in the invariants. -/
def strongBSDShape (leadingCoeff period regulator tamagawaProduct : ℝ)
    (shaOrder torsionOrder : ℕ) : Prop :=
  leadingCoeff * (torsionOrder : ℝ) ^ 2 =
    period * regulator * tamagawaProduct * (shaOrder : ℝ)

/-- The real period: correct name is `WeierstrassCurve.realPeriod`, and it is noncomputable. -/
noncomputable example (W : WeierstrassCurve ℝ) : ℝ := WeierstrassCurve.realPeriod W

/-- The complex period likewise. -/
noncomputable example (W : WeierstrassCurve ℂ) : ℝ := WeierstrassCurve.complexPeriod W

/-- The Tamagawa product: Projective model, ℕ-valued, noncomputable. -/
noncomputable example (W : WeierstrassCurve.Projective ℚ) : ℕ :=
  WeierstrassCurve.Projective.tamagawaProduct W

/-- Mixing an ℕ invariant into the real identity needs an explicit cast. -/
noncomputable example (W : WeierstrassCurve.Projective ℚ) (lc period reg : ℝ)
    (sha tors : ℕ) : Prop :=
  strongBSDShape lc period reg (WeierstrassCurve.Projective.tamagawaProduct W : ℝ) sha tors

/-- Sha is an `AddSubgroup` of `H¹`, so its cardinal is the natural size — and finiteness
is not provided by the definition. -/
noncomputable example (K : Type*) [Field K] [NumberField K] (W : WeierstrassCurve.Affine K) :
    AddSubgroup (continuousCohomology 1 W.galoisRepresentation) :=
  W.tateShafarevich

end Probe
