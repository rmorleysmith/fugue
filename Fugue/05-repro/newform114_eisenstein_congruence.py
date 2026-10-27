#!/usr/bin/env python3
"""The corpus' level-11 weight-4 newform is congruent to an Eisenstein series mod 61.

The author's observation (June 2026, `PythonAndVisualizations/dna.py`): the newform basis used
as the PoC "DNA" — LMFDB 11.4.a.a, coefficients in ℚ(√3) — sits next to "E4 truncated to the
same order". Made precise, it is an **Eisenstein congruence** of exactly the Ramanujan
`τ(n) ≡ σ₁₁(n) (mod 691)` kind:

    a(n) ≡ σ₃(n) − σ₃(n/11)   (mod 𝔭),   𝔭 = (61, √3 − 8) ⊂ ℤ[√3],   for ALL n ≥ 1,

where `σ₃(n/11) := 0` unless `11 | n`. The right-hand side is the `q^n`-coefficient of the
level-11 Eisenstein series `(E₄(τ) − E₄(11τ)) / 240 ∈ M₄(Γ₀(11))` (constant term 0, like the
cusp form). The modulus is the right one: `61 ∣ 11⁴ − 1 = 14640 = 2⁴·3·5·61`, the standard
congruence prime for weight 4 and level 11 (compare 691 ∣ numerator of B₁₂ for Δ).

What this script does, all in exact rational / ℤ[√3] arithmetic (stdlib only):
  1. builds `f = η²(τ)η²(11τ)` (the weight-2 newform 11.2.a.a) and the weight-2 Eisenstein series
     `E = E₂(τ) − 11E₂(11τ)` on Γ₀(11), hence the basis `{f², f·E}` of the 2-dimensional `S₄(Γ₀(11))`;
  2. computes the Hecke operator `T₂` on that basis (char. poly `x² − 2x − 2`, roots `1 ± √3`),
     and the normalised eigenform for `1 + √3` — it reproduces LMFDB 11.4.a.a (`dna.py`'s values);
  3. checks the congruence for every `n ≤ 200`.

Why it is a theorem and not just a check: both sides are `q`-expansions of forms in
`M₄(Γ₀(11))` with coefficients in `ℤ[√3]`; by **Sturm's bound** two such forms congruent mod 𝔭
on the first `k·[SL₂(ℤ):Γ₀(11)]/12 = 4·12/12 = 4` coefficients (plus the constant term) are
congruent everywhere. We check 200 ≫ 4. (Sturm's theorem is not in Mathlib, so this stays a
numerically-certified paper theorem.)
"""
from __future__ import annotations

from fractions import Fraction as Fr
from math import gcd

M = 200                     # coefficients computed


def sigma(n: int, k: int) -> int:
    return sum(d ** k for d in range(1, n + 1) if n % d == 0)


def ser_prod(mult: int, power: int, m: int) -> list[int]:
    """Coefficients of ∏_{n≥1} (1 − q^{mult·n})^{power}, to order m."""
    c = [0] * (m + 1)
    c[0] = 1
    for n in range(1, m + 1):
        step = mult * n
        if step > m:
            break
        for _ in range(power):
            for k in range(m, step - 1, -1):
                c[k] -= c[k - step]
    return c


def mul(a, b):
    c = [0] * (M + 1)
    for i, ai in enumerate(a):
        if ai == 0:
            continue
        for j in range(0, M + 1 - i):
            if b[j]:
                c[i + j] += ai * b[j]
    return c


class K:
    """Elements a + b√3 of ℚ(√3)."""

    def __init__(self, a, b=0):
        self.a, self.b = Fr(a), Fr(b)

    def _k(self, o):
        return o if isinstance(o, K) else K(o)

    def __add__(self, o): o = self._k(o); return K(self.a + o.a, self.b + o.b)
    def __sub__(self, o): o = self._k(o); return K(self.a - o.a, self.b - o.b)
    def __mul__(self, o): o = self._k(o); return K(self.a * o.a + 3 * self.b * o.b, self.a * o.b + self.b * o.a)
    __radd__ = __add__
    __rmul__ = __mul__

    def __truediv__(self, o):
        o = self._k(o)
        n = o.a * o.a - 3 * o.b * o.b
        return self * K(o.a / n, -o.b / n)

    def norm(self):
        return self.a * self.a - 3 * self.b * self.b

    def is_zero(self):
        return self.a == 0 and self.b == 0

    def __repr__(self):
        return f"{self.a}{'+' if self.b >= 0 else ''}{self.b}√3"


def main() -> bool:
    # 1. the weight-2 objects and the basis of S₄(Γ₀(11))
    f = [0] + mul(ser_prod(1, 2, M), ser_prod(11, 2, M))[:M]            # η²(τ)η²(11τ) = q − 2q² − …
    E = [-10] + [-24 * (sigma(n, 1) - (11 * sigma(n // 11, 1) if n % 11 == 0 else 0))
                 for n in range(1, M + 1)]                              # E₂(τ) − 11E₂(11τ)
    g1, g2 = mul(f, f), mul(f, E)

    # 2. T₂ on the basis, eigenform for 1 + √3
    def T2(g):
        return [0] + [g[2 * n] + 8 * (g[n // 2] if n % 2 == 0 else 0) for n in range(1, M // 2 + 1)]

    def coords(h):
        y = Fr(h[1], g2[1])
        x = (Fr(h[2]) - y * g2[2]) / g1[2]
        assert all(Fr(h[n]) == x * g1[n] + y * g2[n] for n in range(1, M // 2 + 1)), "T₂ left the span"
        return x, y

    A = [coords(T2(g1)), coords(T2(g2))]
    tr, det = A[0][0] + A[1][1], A[0][0] * A[1][1] - A[0][1] * A[1][0]
    print(f"T₂ on S₄(Γ₀(11)): char poly x² − {tr}x + {det}   (roots 1 ± √3)")
    assert (tr, det) == (2, -2)
    lam = K(1, 1)
    x = K(1)
    y = (lam - A[0][0]) * x / K(A[1][0])
    assert (K(A[0][1]) * x + K(A[1][1]) * y - lam * y).is_zero()
    F = [x * g1[n] + y * g2[n] for n in range(M + 1)]
    F = [c / F[1] for c in F]                                          # a(1) = 1
    lmfdb = {2: K(1, 1), 3: K(-1, -4), 4: K(-4, 2), 5: K(1, 8)}        # dna.py / LMFDB 11.4.a.a
    ok_lmfdb = all((F[n] - v).is_zero() for n, v in lmfdb.items())
    print(f"a(1..8) = {F[1:9]}")
    print(f"matches LMFDB 11.4.a.a (as in dna.py): {ok_lmfdb}")

    # 3. the Eisenstein congruence
    def eis(n):                                                        # (E₄(τ) − E₄(11τ))/240
        return sigma(n, 3) - (sigma(n // 11, 3) if n % 11 == 0 else 0)

    g = 0
    for n in range(1, M + 1):
        N = (F[n] - eis(n)).norm()
        assert N.denominator == 1
        g = gcd(g, int(N))
    print(f"gcd over n ≤ {M} of N(a(n) − eis(n)) = {g}   (61 | 11⁴ − 1 = {11**4 - 1})")
    r = 8                                                              # 8² = 64 ≡ 3 (mod 61)

    def red(z: K) -> int:                                              # ℤ[√3] → 𝔽₆₁ via √3 ↦ 8
        a = z.a.numerator * pow(z.a.denominator, -1, 61)
        b = z.b.numerator * pow(z.b.denominator, -1, 61)
        return (a + r * b) % 61

    fails = [n for n in range(1, M + 1) if red(F[n] - eis(n)) != 0]
    print(f"a(n) ≡ σ₃(n) − σ₃(n/11)  (mod (61, √3−8))  for all n ≤ {M}: {not fails}  "
          f"(Sturm bound for M₄(Γ₀(11)) is 4)")
    plain = [n for n in range(1, 45) if red(F[n] - sigma(n, 3)) != 0]
    print(f"   without the 11-correction, a(n) ≡ σ₃(n) fails exactly at n = {plain}")
    return ok_lmfdb and not fails


if __name__ == "__main__":
    assert main()
