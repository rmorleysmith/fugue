# Figure atlas

Every visual artefact in the June files' `figures/` folder, with the script that produces
it, the author's own caption where one exists in `figures/index.html`, and the thread in
this directory that explains it.

The June figures are archived unchanged in `rmorleysmith/hsln-archive` (`visualizations_part1.zip`, `visualizations_part2.zip`); regenerated versions with corrected titles are in `rmorleysmith/fugue-exploration` under `figures/`.

Generated from `figures/index.html` plus the scripts' `suptitle`/`_save` calls. Where a
figure has no caption in `index.html`, the title shown is taken from the script's own title.

---

## Numbered figures and animations

| # | file | produced by | title | explained in |
|---|---|---|---|---|
| 01 | `01_e4_halfplane.png` | `render.py:fig_e4_halfplane` | genus 1 Θ E8 = E 4 on the upper half-plane 𝓗 1 | Genus-1 geometry: E₈, Θ_{E8} = E₄, the zero at ρ |
| 02 | `02_e4_disk.png` | `render.py:fig_e4_disk` | genus 1 E 4 on the Poincaré disk | Genus-1 geometry: E₈, Θ_{E8} = E₄, the zero at ρ |
| 03 | `03_energy_neurons.png` | `render.py:fig_energy_neurons` | network Energy landscape — neurons are the zeros | Genus-1 geometry: E₈, Θ_{E8} = E₄, the zero at ρ |
| 04 | `04_dynamics.png` | `render.py:fig_dynamics` | network Reservoir dynamics & spiking | Dynamics and spiking |
| 05 | `05_merge.png` | `render.py:fig_merge` | algebra Exact zero-shot model merging | Composition: zero-union merging and E8×E8 |
| 06 | `06_e8_roots_dna.png` | `render.py:fig_e8_roots` | E8 The 240 roots of E8 & the theta DNA | Composition: zero-union merging and E8×E8 |
| 07 | `07_siegel_genus2.png` | `render.py:fig_siegel` | genus 2 Θ (2) E8 on slices of 𝓗 2 | Composition: zero-union merging and E8×E8 |
| 08 | `08_basins_paths.png` | `render.py:fig_basins` | network Neurons & basins — paths only (cheap) | Neurons and basins |
| 09 | `09_genus2_divisor.png` | `render.py:fig_divisor` | genus 2 Neurons are a zero divisor — a curve, not a count | Genus 2: the Siegel theta and its zero divisor |
| 10 | `10_divisor_sweep.png` | `render.py:fig_divisor_sweep` | genus 2 Zero divisor vs. coupling strength | Genus 2: the Siegel theta and its zero divisor |
| 11 | `11_compose_add_vs_mul.png` | `render.py:fig_compose` | algebra Two ways to compose: + sculpts, × stacks | Composition: addition vs multiplication; the heterotic product |
| 12 | `12_heterotic_e8xe8.png` | `render.py:fig_heterotic` | E8 × E8 Heterotic: a state form × a gravity dial | Composition: addition vs multiplication; the heterotic product |
| 13 | `13_poc_training.png` | `poc.py` | trained It learns: backprop through the dynamics into the gravity DNA | Trainable proof of concept |
| 14 | `14_poc_constant_input.png` | `poc.py` | trained Constant input drive: the spec dynamics, $u$ = const | Trainable PoC: constant drive, sine, XOR, layering, end-to-end merge |
| 15 | `15_poc_sine.png` | `poc_sine.py` | trained Following a sine wave: time-varying drive $B\,u(t)$ | Trainable PoC: constant drive, sine, XOR, layering, end-to-end merge |
| 16 | `16_poc_xor.png` | `poc_xor.py` | trained Temporal XOR — the spec's task | Trainable PoC: constant drive, sine, XOR, layering, end-to-end merge |
| 17 | `17_poc_layering.png` | `poc_layer.py` | E8 × E8 Layering: tensoring doubles the neurons | Trainable PoC: constant drive, sine, XOR, layering, end-to-end merge |
| 18 | `18_e2e_compose.png` | `hsln.py` | end-to-end Train two tasks → tensor → the compound does both | Trainable PoC: constant drive, sine, XOR, layering, end-to-end merge |
| 19 | `19_dynamical_composition.png` | `hsln_dyn.py` | where it breaks Dynamical composition: the tensor product reshapes the basins | Dynamical composition (where it breaks) and the direct-sum fix |
| 20 | `20_genus2_directsum.png` | `hsln_genus2.py` | the fix Genus-2 direct sum: separate coordinates don't interfere | Dynamical composition (where it breaks) and the direct-sum fix |
| 21 | `21_eta_composition.png` | `eta_compose.py` | composability Eta-quotient DNA: composition is linear, and stays modular by construction | Eta-quotient composability; the gravity/coupling sweep |
| 22 | `22_coupling_sweep.png` | `coupling_sweep.py` | gravity The off-diagonal z: warps the route, unlocks chaos, but routing stays robust | Eta-quotient composability; the gravity/coupling sweep |
| 23 | `23_cm_alphabet.png` | `cm_alphabet.py` | alphabet The CM-point alphabet: singular moduli as integer-named symbols | The CM-point alphabet, discrete readout, learned classifiers, tensor composition |
| 24 | `24_cm_task.png` | `cm_task.py` | discrete The network answers "What is your name?" — discrete output via CM points | The CM-point alphabet, discrete readout, learned classifiers, tensor composition |
| 25 | `25_cm_classifier.png` | `cm_classifier.py` | learned A learned 4-class classifier with a CM-symbol code — 95% on held-out data | The CM-point alphabet, discrete readout, learned classifiers, tensor composition |
| 26 | `26_cm_tensor.png` | `cm_tensor.py` | compose Four models trained apart, multiplied together, classify in one shot — 95% | The CM-point alphabet, discrete readout, learned classifiers, tensor composition |
| 27 | `27_timeseries.png` | `timeseries.py` | dynamics The dynamical view: a computation is a particle's trajectory in the modular form | The dynamical view; scaling benchmarks |
| 28 | `28_scaling.png` | `scaling.py` | scaling Can we eat these for breakfast? Batched passes and composition are cheap; genus is the cost | The dynamical view; scaling benchmarks |
| 29 | `29_skill_compose.png` | `skill_compose.py` | stacking Two skills stacked: "which letter is missing — by number" | Skill stacking; grokking |
| 30 | `30_grok.png` | `grok.py` | grokking Shortcutting grokking: the native circular rep generalises immediately | Skill stacking; grokking |
| 31 | `31_prime_sieve.png` | `prime_sieve.py` | primes Finding primes by composition — the sieve in a Fourier hat | Number theory by composition: sieve, ζ from primes, factorisation |
| 32 | `32_zeta_compose.png` | `zeta_compose.py` | zeta ζ(s) = Σ 1/nˢ from first principles: compose per-prime Euler factors | Number theory by composition: sieve, ζ from primes, factorisation |
| 33 | `33_factorize.png` | `factorize.py` | factorize Factorising by composition — and the factoring wall | Number theory by composition: sieve, ζ from primes, factorisation |
| 34 | `34_spectral.png` | `spectral.py` | spectral Do the zeros behave like a quantum spectrum? (Hilbert–Pólya) | RH-adjacent: spectral/GUE, explicit formula, factorisation landscape |
| 35 | `35_explicit.png` | `explicit.py` | explicit The zeros interpolate the primes (the explicit formula) | RH-adjacent: spectral/GUE, explicit formula, factorisation landscape |
| 36 | `36_landscape.png` | `landscape.py` | landscape The factorization landscape to 9,000,000 | RH-adjacent: spectral/GUE, explicit formula, factorisation landscape |
| 37 | `37_dna_algebra.png` | `dna_algebra.py` | algebra The DNA algebra — composition is a ring, and ζ⁻¹ = μ is the group inverse | The DNA algebra (ring) and the Lie derivative |
| 38 | `38_lie_derivative.png` | `lie_derivative.py` | Lie derivative The Lie derivative of the system — two faces of one generator | The DNA algebra (ring) and the Lie derivative |
| 39 | `39_lfunctions.png` | `lfunctions.py` | L-functions Dirichlet L-functions — a parametrised family of generators in the ring | L-functions and Birch–Swinnerton-Dyer |
| 40 | `40_bsd.png` | `bsd.py` | BSD A pop at Birch–Swinnerton-Dyer — composing L(E,s) and watching the rank fall out | L-functions and Birch–Swinnerton-Dyer |
| 41 | `41_hecke_prime_dna.png` | `hecke_compression.py` | Andrianov–Hecke compression: the prime-indexed DNA | Hecke compression; DNA of primes and semiprimes |
| 42 | `42_hecke_tensor.png` | `hecke_compression.py` | Andrianov–Hecke compression: the tensor structure | Hecke compression; DNA of primes and semiprimes |
| 43 | `43_hecke_big_prime.png` | `hecke_compression.py` | Andrianov–Hecke compression at a big prime | Hecke compression; DNA of primes and semiprimes |
| 44 | `44_hsln_dna_big_prime.png` | `hsln_prime_dna.py` | Trained DNA on a large prime — /F/ landscape | Hecke compression; DNA of primes and semiprimes |
| 45 | `45_hsln_dna_atlas.png` | `hsln_prime_dna.py` | Trained DNA atlas (coefficient vector inspection) | Hecke compression; DNA of primes and semiprimes |
| 46 | `46_hsln_factor_dna.png` | `hsln_factor_dna.py` | Trained DNA on a large semiprime N = p·q | Hecke compression; DNA of primes and semiprimes |
| 47 | `47_hash_dance.png` | `hsln_hash_dance.py` | The state dancing to SHA-256("abc") | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 48 | `48_hsln_pgp_dance.png` | `hsln_pgp_dance.py` | The state dancing to a PGP key block | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 49 | `49_hsln_unknown_hash.png` | `hsln_hash_dance_v2.py` | Dancing to an unknown hash (hex input) | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 50 | `50_hsln_bignum_dna.png` | `hsln_bignum_dna.py` | DNA of a very large semiprime (high precision) | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 51 | `51_hsln_hash_inverse.png` | `hsln_hash_inverse.py` | Formal power-series inverse 1/F of a hash-derived DNA | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 52 | `52_hsln_dna_matrix.png` | `hsln_bignum_dna_matrix.py` | The DNA as a matrix (spectral view) | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 53 | `53_hsln_many_neurons.png` | `hsln_bignum_many.py` | Many neurons (dg=30) on a large N | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 54 | `54_hsln_compose_two.png` | `hsln_compose_two.py` | Two HSLN models trained jointly, then multiplied | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 55 | `55_hsln_skill_forge.png` | `hsln_skill_forge.py` | The Skill Forge — edit a model with arithmetic, not gradient descent | Hash/PGP dances, hash inverse, bignum DNA, composition, Skill Forge |
| 56 | `56_hsln_e8_divisor_bridge.png` | `hsln_e8_divisor_bridge.py` | The divisor function is the bridge: DNA algebra → E₄ → E8 → E8×E8 heterotic | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 57 | `57_hsln_e8_torsion_factor.png` | `hsln_e8_torsion_factor.py` | E8 × Siegel factoring — the roots-of-unity projection reveals divisors | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 58 | `58_hsln_reverse_factor.png` | `hsln_reverse_factor.py` | Reverse the test (N → 1): reversible YES, polynomial NO | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 59 | `59_hsln_bitcoin_probe.png` | `hsln_bitcoin_probe.py` | The instrument vs real Satoshi-era keys — what lights up | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 60 | `60_hsln_bitcoin_hash.png` | `hsln_bitcoin_hash.py` | The SHA-256 side of the genesis key — the instrument stays DARK | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 61 | `61_hsln_bitcoin_recurse.png` | `hsln_bitcoin_recurse.py` | Divide and conquer on a real key — why it does not cascade | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 62 | `62_hsln_cofactor_dna.png` | `hsln_cofactor_dna.py` | Cofactor audit — trained DNA (raw) + factoring verdict per number | E8 divisor bridge, torsion factoring, reverse factoring, Bitcoin/cofactor probes |
| 63 | `63_hsln_lie_landscape.png` | `hsln_lie_landscape.py` | Lie derivative of the trained landscape — the graded-ring symmetry | Lie landscape, cup product, DNA matrix factor |
| 64 | `64_hsln_cup_product.png` | `hsln_cup_product.py` | Cup product of trained landscapes — composes factors, never discovers | Lie landscape, cup product, DNA matrix factor |
| 65 | `65_hsln_dna_matrix_factor.png` | `hsln_dna_matrix_factor.py` | DNA as a matrix — factoring the MATRIX is easy, the spectrum is the DNA | Lie landscape, cup product, DNA matrix factor |

## Animations, interactive pages and extra renders

| file | produced by | title |
|---|---|---|
| `anim_divisor_orbit.mp4` | `animate.py` | animation The coupled divisor, rotating |
| `anim_e8_torsion_factor.mp4` | `hsln_e8_torsion_factor.py` | Animation: the E8 torsion factoring sweep |
| `anim_genus2_coupling.mp4` | `animate.py` | animation A tour through 𝓗 2 |
| `anim_gravity_dial.mp4` | `animate.py` | animation Dialing the gravity DNA |
| `anim_gravity_divisor.mp4` | `animate.py` | animation Gravity dial × the genus-2 divisor |
| `anim_reservoir_flow.mp4` | `animate.py` | animation Reservoir relaxation |
| `anim_tweak_neurons.mp4` | `animate.py` | animation Tweaking the DNA: where neurons come from & go |
| `dna.png` | `(no literal reference found)` | The DNA coefficient vector (standalone illustration) |
| `e4_disk_clean.png` | `render.py:fig_disk_clean` | E₄ on the Poincaré disk, clean render (transparent background) |
| `game_of_life.html` | — | Interactive: Conway's Life on the modular cylinder |
| `game_of_life_poster.png` | `(no literal reference found)` | interactive Game of Life on the modular cylinder → open ▶ |

## The author's captions, verbatim

Kept because the captions are themselves evidence: where a caption makes a claim, the
thread files check it. Where a caption overstates, the thread says so.

### `01_e4_halfplane.png` — genus 1 Θ E8 = E 4 on the upper half-plane 𝓗 1

> The genus-1 Siegel modular form of E8 (weight 4, level 1), as an enhanced phase portrait: hue = arg F, brightness bands = level curves of |F|. The SL(2,ℤ) fundamental domain is outlined and the unique zero at 𝜏 ≡ ρ = e 2πi/3 — the single genus-1 "neuron" — is marked.

### `02_e4_disk.png` — genus 1 E 4 on the Poincaré disk

> The same form under the Cayley transform 𝜏 ↦ (𝜏−i)/(𝜏+i). The real axis of 𝓗 becomes the boundary circle, where the modular tessellation accumulates at the cusps.

### `03_energy_neurons.png` — network Energy landscape — neurons are the zeros

> E = |F|². By the maximum-modulus principle its only minima are the zeros of F, so zeros are exactly the attractors = neurons. Left: true E 4 (one neuron orbit at ρ). Right: the (g,k,N) = (1,4,11) trained DNA — LMFDB newform 11.4.a.a, 4 neurons.

### `04_dynamics.png` — network Reservoir dynamics & spiking

> Left: the gradient flow 𝜏̇ = −α∇|F|² streaming into the neurons (attractors). Right: under a pulsed input the "membrane potential" 1/|F(𝜏(t))| crosses the threshold ε and emits a spike train — the liquid / spiking behaviour falls out of the geometry.

### `05_merge.png` — algebra Exact zero-shot model merging

> Multiplying two DNAs (Cauchy convolution of Fourier coefficients) gives a form whose zero set is the union of the parents': zeros(F A ·F B ) = zeros(F A ) ∪ zeros(F B ). The merged network inherits every neuron of both parents; weights add k A +k B .

### `06_e8_roots_dna.png` — E8 The 240 roots of E8 & the theta DNA

> Where the form comes from. Left: the 240 E8 roots in the Coxeter (Petrie) projection — 8 concentric 30-gons. Right: the theta coefficients a n = 240·σ 3 (n) that constitute the genus-1 "DNA".

### `07_siegel_genus2.png` — genus 2 Θ (2) E8 on slices of 𝓗 2

> The genuine Siegel object (complex dim 3, weight 4, Sp(4,ℤ)). Diagonal slice Z = diag(𝜏,𝜏) factorizes to E 4 ⊗E 4 (verified to 10 −15 ); a non-zero off-diagonal coupling z deforms it; the third panel is the coupling plane.

### `08_basins_paths.png` — network Neurons & basins — paths only (cheap)

> The same dynamics with no domain coloring and no dense grid: neurons (★) plus gradient-flow paths colored by which basin they fall into. Left: 3 neurons. Right: 10 neurons from one DNA — the count is capped by the DNA length (= Sturm bound), and the cost is the same class.

### `09_genus2_divisor.png` — genus 2 Neurons are a zero divisor — a curve, not a count

> At g ≥ 2 the zero set of F has complex codimension 1, so it is not isolated points. On each fixed-w complex slice of the family Z = [[τ,z],[z,τ+w]] the zero is a point (red); swept over w it traces a curve. Decoupled (z=0): two flat branches at Im τ ≈ 0.87 (the E₄⊗E₄ product). Coupled (z=0.35): the branches bend through the space — the genuine genus-2 attractor.

### `10_divisor_sweep.png` — genus 2 Zero divisor vs. coupling strength

> The same genus-2 divisor as the coupling z grows (0.10 → 0.55): the two flat branches bend through the 3-space and reconnect. The geometry of this curve — not a neuron count — is what carries the model.

### `11_compose_add_vs_mul.png` — algebra Two ways to compose: + sculpts, × stacks

> Same two parent DNAs. Addition (same weight) blends the fields — the zeros recombine by interference (new ★, parents' ○ vacated), and stays modular but breaks Hecke-eigenform-ness. Multiplication unions the zeros — every parent attractor is kept. Both are exact operations on the DNA (vector add / Cauchy convolution).

### `12_heterotic_e8xe8.png` — E8 × E8 Heterotic: a state form × a gravity dial

> The theta of a direct-sum lattice is the product of the thetas (true at every genus), so E₈×E₈ = F_state · F_gravity — exact, cheap (DNA convolution), weight 4+4=8. Freeze the state and dial the gravity DNA: it multiplicatively reshapes the field and injects its own zeros. Constraint: products only add attractors (zeros union), never delete the state's.

### `13_poc_training.png` — trained It learns: backprop through the dynamics into the gravity DNA

> A minimal genus-1 HSLN, trained on CPU with JAX autodiff. Two inputs (encoded as initial states) must route to two class attractors. Before: the reservoir paths miss. After: gradient descent on the gravity DNA — backpropagated straight through the relaxation flow — reshapes the field so each input reaches its target (loss 0.08 → 0.0002, ~3 s, no GPU). The DNA is literally the thing the optimizer tweaks.

### `14_poc_constant_input.png` — trained Constant input drive: the spec dynamics, $u$ = const

> Now the input is the actual drive term Bu from §2.3 (not the initial state). Both classes start at the same point; only the constant input u = ±1 differs. After training the gravity DNA, u = +1 arcs right and u = −1 arcs left to their class targets (loss 0.079 → 0.002). The input now lives in the dynamics, the next step toward a time-varying Bu(t).

### `15_poc_sine.png` — trained Following a sine wave: time-varying drive $B\,u(t)$

> The input is now a time-varying sine, u(t) = sin ωt, injected as the drive Bu(t). Training the gravity DNA (plus a small linear readout) makes the output track a target sine — clean monotonic convergence, RMSE ≈ 0.06. The field acts as a tunable restoring spring (a driven first-order oscillator); this is the doorway to genuine temporal tasks.

### `16_poc_xor.png` — trained Temporal XOR — the spec's task

> Two pulse-encoded channels; the network spikes (1/|F| diverges = near a zero) iff exactly one fired. The gravity field learns to place a zero exactly at the single-pulse position and none at the {neither, both} positions — a genuine nonlinear fold, count {0,2}→no spike, {1}→spike. Clean truth table, loss 1.95 → 0.002.

### `17_poc_layering.png` — E8 × E8 Layering: tensoring doubles the neurons

> A 4-target task. One small sector (≤ 2 zeros) can't cover all four. Tensoring two sectors — multiplying the forms / convolving the DNAs — gives a product with 4 zeros (the union), landing one on each target. Stacking layers adds neurons exactly and cheaply; this is the trainable E8×E8 move.

### `18_e2e_compose.png` — end-to-end Train two tasks → tensor → the compound does both

> Each network is a (genus-1 matrix state-space Z, generating-function DNA) pair; its neurons are the zeros of F. Two detectors are trained independently (A spikes at two input positions, B at a third). Tensoring their generating functions — convolving the DNAs — yields a compound that spikes at the union (verified: matches both tasks, no cross-talk), because zeros(A⊗B) = zeros(A) ∪ zeros(B). Zero-shot model merging, on trained models.

### `19_dynamical_composition.png` — where it breaks Dynamical composition: the tensor product reshapes the basins

> Composition is exact for the spike readout (zeros union) but not for routing . The flow on |F_A·F_B|² is |F_B|²∇|F_A|² + |F_A|²∇|F_B|² — not the union of the two flows. Here each parent steers its input across the middle to the far attractor and routes perfectly alone; but the compound adds the other task's attractor in the crossing path, so both inputs are captured wrong . Fixed points (zeros) survive; basins don't. The fix is the direct-sum (cross product, genus adds) — separate state-space sectors that don't interfere.

### `20_genus2_directsum.png` — the fix Genus-2 direct sum: separate coordinates don't interfere

> Take the same trained sectors that cross-talked at genus 1, but give each its own coordinate of the 2×2 matrix Z = diag(τ₁, τ₂). On the diagonal the energy factorizes |F|² = |F_A(τ₁)|²·|F_B(τ₂)|², so the flow decouples — τ₁ runs task A, τ₂ runs task B, independently. Routing error drops from 0.27 (tensor) to 0.000 (direct sum) for both tasks. This is the first place the "matrix" in matrix + generating function genuinely becomes 2×2.

### `21_eta_composition.png` — composability Eta-quotient DNA: composition is linear, and stays modular by construction

> Write a form as an eta quotient ∏ d|N η(dτ) r_d . Then multiplying two networks adds their exponent vectors (left: residual |f_r·f_s − f_{r+s}| at machine precision), and the weight k = ½∑r_d adds linearly. Newman's congruences + Ligozat's cusp-order cone are linear in r, so the admissible vectors form a monoid closed under addition (middle: the level-11 lattice, with (2,2)+(2,2)=(4,4) — the X₀(11) newform composing with itself). Trade-off (right): because η≠0 on ℍ, every neuron sits at a cusp — E₄'s interior zero at ρ is unreachable by any eta quotient.

### `22_coupling_sweep.png` — gravity The off-diagonal z: warps the route, unlocks chaos, but routing stays robust

> Gravity = the off-diagonal entry of the period matrix, entering through the Sp(4,ℝ)-invariant Siegel metric (coupling κ, with w² = κ·y₁y₂). Left: routing error stays ≈0 for all κ — the joint zero is a simultaneous zero of both sectors, so it remains an equilibrium no matter how strong the coupling. Middle: yet the trajectory bends with κ — gravity warps the route, not the destination. Right: add a periodic drive and the decoupled flow (κ=0) contracts to a single orbit (Poincaré–Bendixson forbids chaos in its 2-D extended phase space), while the coupled flow (κ=0.85) stays separated — the off-diagonal opens a third dimension, and with it, sensitive dependence.

### `23_cm_alphabet.png` — alphabet The CM-point alphabet: singular moduli as integer-named symbols

> A discrete, arithmetically-distinguished symbol set living inside the continuous state space ℍ. The nine Heegner numbers d ∈ {1,2,3,7,11,19,43,67,163} have class number 1, so their CM points carry integer j-values — and in fact perfect cubes: 12³, 20³, 0, (−15)³, (−32)³, (−96)³, (−960)³, (−5280)³, (−640320)³ (the last is why e^{π√163} is an almost-integer). Verified to 80 digits with mpmath. Each token is a point in ℍ with an integer "name" j(τ).

### `24_cm_task.png` — discrete The network answers "What is your name?" — discrete output via CM points

> A first discrete/symbolic task. The output codebook is the singular moduli : at a CM point (τ imaginary quadratic) the j-invariant is an integer. We read out by reducing the final state τ* to the fundamental domain, computing the SL₂(ℤ)-invariant j(τ*), and snapping to the nearest CM integer — that integer names a symbol. A fixed "question" input routes three output coordinates (a genus-3 direct sum) to letters' CM points; decoding j → nearest singular modulus spells "ADA" (A↦j=1728 at i, D↦j=0 at ρ). The continuous flow, a discrete answer.

### `25_cm_classifier.png` — learned A learned 4-class classifier with a CM-symbol code — 95% on held-out data

> The TensorFlow-Playground deliverable, with a number-theoretic output. Only two CM symbols are cleanly reachable (A = j=1728, D = j=0), so we encode 4 classes as 2-bit codewords across two direct-sum coordinates: AA, AD, DA, DD. The gravity landscape is fixed with neurons at the two CM points; a learned linear input-encoder routes each class into the right basin (reservoir-computing style), and the CM/j readout names the symbol. Trained on 160 points, 95% on 80 held-out — it generalises, doesn't memorise. (Left: learned decision regions, ● train ▲ test. Right: each coordinate's states landing on A or D.)

### `26_cm_tensor.png` — compose Four models trained apart, multiplied together, classify in one shot — 95%

> The headline workflow, made load-bearing. Each class gets its own minimal gravity DNA (a single neuron) trained completely separately , seeing only its own class. The compound is the tensor product — multiply the forms = convolve the DNAs: F = F₀·F₁·F₂·F₃. By the composition theorem the zeros union exactly, and we verify it: the compound's four neurons equal the four separately-trained neurons to 1.76e-16 . Classify the held-out set by nearest neuron (detection readout, so the tensor cross-talk that breaks routing never enters): 95% on first compose . No joint training, no reservoir — the 4-class model is assembled from independent pieces by one convolution, with a guarantee a reservoir can't give.

### `27_timeseries.png` — dynamics The dynamical view: a computation is a particle's trajectory in the modular form

> Reasserting the temporal nature (the classifiers had collapsed to static placement). We drive the genus-1 state with a clean input tone and integrate the driven gradient flow τ̇ = −α∇|F|² + Bu(t) — a first-order oscillator on the |F|² landscape. Left: input vs the particle's motion Re τ(t) — the computation is a time series. Middle: its path through ℍ near a neuron. Right: the Fourier spectrum of the motion — the nonlinear modular landscape broadens and reshapes the clean input tone. Exactly your framing: Fourier analysis of a particle moving in the E8 modular form.

### `28_scaling.png` — scaling Can we eat these for breakfast? Batched passes and composition are cheap; genus is the cost

> Measured CPU timings (no GPU). Left: the forward pass is a vectorised map (jax.vmap) — ~25k passes/sec on CPU, flat across batch (cores saturate); on a GPU this same curve keeps climbing, because it's exactly the parallel workload GPUs are built for. Middle: cost is linear in DNA length (neuron count), and composing K models (convolving DNAs) is **microseconds** — ~1000× cheaper than a forward pass. Right: the one genuinely steep axis is genus (the Siegel theta sum): genus-1 is ~20µs, genus-2 climbs from 0.1s to 8s as the Fourier bound grows. So batch, weight, and composition are GPU-trivial; genus is the research frontier.

### `29_skill_compose.png` — stacking Two skills stacked: "which letter is missing — by number"

> A second kind of composition: function composition B∘A (stacking), distinct from the DNA-product. Skill A finds the missing letter; skill B (trained separately) names its number; A's output feeds B. Encoding is native to the HSLN: position ↔ a root of unity. Since the roots sum to zero, the present letters' net pull points to the missing one's antipode — so skill A is a driven, confined reservoir (a particle in an |F|² well integrating the bag of present letters) that settles toward the gap; negating gives the missing state. Present A,B,D,E,F → missing C → number 3 , and 6/6 across all problems. The circular representation here is exactly the Fourier solution grokking networks discover on modular arithmetic — here it's the HSLN's native state.

### `30_grok.png` — grokking Shortcutting grokking: the native circular rep generalises immediately

> Grokking happens on modular arithmetic, and the grokked solution is a Fourier/circular representation — which is the HSLN's native state. On (a+b) mod 11 with a 50/50 split: left , the circular-phase model (one learnable phase per symbol, combine by angle-addition) sends train and test to 100% together — no grokking delay, because with only n+1 parameters it cannot memorise, only fit the global rule. Middle , a generic embedding+MLP control memorises the train set (100%) but sits at ~0% on held-out — the classic pre-grok gap. Right , the circular model's learned phases φ(k) emerge as roots of unity — the representation grokking slowly discovers is here built in. You called it: this shortcuts the whole process.

### `31_prime_sieve.png` — primes Finding primes by composition — the sieve in a Fourier hat

> A blind, cheerful attempt that actually works. Each skill detects multiples of a small prime p: the field sin(πx/p) — the p-th-root-of-unity comb — rings to zero exactly at multiples of p. Compose by multiplying the fields (the tensor product whose zeros union), F(x) = ∏ p∈{2,3,5,7} sin(πx/p): it vanishes at every composite (a union of all the multiples) and survives at the primes . For n ≤ 100 sieving by {2,3,5,7} catches every composite, so the survivors are exactly the primes — all 25 recovered, exact match . The Sieve of Eratosthenes, recast as a product of roots-of-unity fields. Composition made the prime test a computable reality.

### `32_zeta_compose.png` — zeta ζ(s) = Σ 1/nˢ from first principles: compose per-prime Euler factors

> The "golden key" as our multiply-composition. Each prime is a little model — its Euler factor 1/(1−p⁻ˢ) = Σₖ p⁻ᵏˢ, whose Dirichlet coefficients are 1 at the powers of p (top-left). Merge by Dirichlet multiplication (the Euler product) and the coefficients become all ones = ζ(s) = Σ 1/nˢ — because every integer factors uniquely into prime powers. Bottom: the merge building every integer exactly once — sparse with only {2}, filling in as primes are added; large primes (43, 47) light up last; the all-ones top row is the ζ series. Top-right: product and series both converge to ζ(2)=π²/6. Dual to the prime sieve (fig 31): there we dropped multiples of p to leave the primes; here we keep powers of p to build the integers. (Scope: this is the series for Re s>1 — the golden key — not the zeros/RH.)

### `33_factorize.png` — factorize Factorising by composition — and the factoring wall

> The inverse of the Euler product (fig 32): there we built integers from primes, here we take them apart. Each prime p ≤ 100 is a little model detecting its multiples via its roots of unity : D p (n) = (1/p)Σₖ e^{2πikn/p} = 1 iff p∣n — the p phasors align (sum = p) exactly when p divides n, else cancel (left). Compose the detectors and divide out → the factorisation (middle: 2310 = 2·3·5·7·11). With primes ≤ 100 it's complete for every n (smallest factor ≤ √n 100 (101·103, 127·9721) leaves an irreducible residual — the factoring wall (right), which is exactly why factoring is hard.

### `34_spectral.png` — spectral Do the zeros behave like a quantum spectrum? (Hilbert–Pólya)

> The honest shape of "a model exhibiting RH": a self-adjoint operator whose eigenvalues are the zeros (real ⇒ all on the line ⇒ RH). We don't have it — but Montgomery–Odlyzko found the evidence. Left: |ζ(½+it)| → 0 at each γₙ (zeros on the line). Middle: the zeros' spacings follow the GUE "Wigner surmise" (level repulsion), not Poisson. Right: an actual random Hermitian matrix's eigenvalue spacings obey the same law. So the zeros statistically behave like a Hermitian spectrum — the matrix-flavoured target. (Evidence, not a proof.)

### `35_explicit.png` — explicit The zeros interpolate the primes (the explicit formula)

> Your "proof by interpolation" instinct, made into a picture. Riemann's explicit formula writes the prime-power staircase ψ(x) as x − log 2π − ½log(1−x⁻²) − Σ_ρ xᵖ/ρ : each zero ρ = ½+iγ contributes an oscillation 2√x·Re[x^{iγ}/(½+iγ)] . Left: adding 1 → 10 → 50 zeros, the smooth term grows the staircase. Right: 200 real zeros (from mpmath) reconstruct the jumps exactly at the prime powers (vertical lines). The zeros and primes encode each other.

### `36_landscape.png` — landscape The factorization landscape to 9,000,000

> The geology under the prime work — sieved on the M1 in 0.9s. Left: a density map of (n, largest prime factor) — the bright diagonal is the primes (lpf = n), the comb of lines below is n/2, n/3, n/5, … (numbers that are a small factor times a big prime). Middle: the smoothness exponent α = log(lpf)/log n, with a spike at α=1 (primes) and Dickman-type structure (the smooth numbers — the ones a small-prime factoriser can crack; only 2.8% are 100-smooth here). Right: Erdős–Kac — the number of distinct prime factors ω(n) is bell-shaped (asymptotically Gaussian), μ≈3.0, σ≈1.05. A central-limit theorem for the primes.

### `37_dna_algebra.png` — algebra The DNA algebra — composition is a ring, and ζ⁻¹ = μ is the group inverse

> "We have all the operations, right? We could derive a group." Yes — and it's exact. Our DNAs (Dirichlet/q-expansion coefficients) under (+, convolution ×) are a commutative ring (machine-checked in HSLNAlgebra.lean ). Name a small alphabet and compose: (1) ζ⁻¹ = μ, so ζ * μ = δ — the group inverse (Möbius inversion). (2) ζ * ζ = d(n) , the divisor count. (3) MODULAR ARITHMETIC composed with the zeta generator: the mod-4 character χ gives ζ * χ = r₂(n)/4 — it counts the ways n is a sum of two squares, i.e. ζ·L(s,χ₄) is the Dedekind zeta of the Gaussian integers ℤ[i] (lattice points on circles; L(1,χ₄)=π/4). (4) the Lie/log-derivative D(ζ)=log, log * μ = Λ extracts the primes (−ζ'/ζ). Whatever we teach independently, we compose — by ring algebra.

### `38_lie_derivative.png` — Lie derivative The Lie derivative of the system — two faces of one generator

> "What's the Lie derivative of the system?" There are two, and the model knows both. Top: along the FLOW. The HSLN is a gradient flow Ż = −∇E on the modular energy E = |F|²; the Lie derivative of the energy is the dissipation L_X E = dE/dt = −|∇E|² ≤ 0 (verified along a trajectory descending into a zero/neuron — Lyapunov). Bottom: along the MODULAR grading. The generator is the Euler operator D = q d/dq (aₙ ↦ n·aₙ), and the ring C[E₂,E₄,E₆] is closed under its own Lie derivative (Ramanujan: DE₄=(E₂E₄−E₆)/3 , residual 0). The weight-corrected Serre derivative ϑ=D−(k/12)E₂ climbs the weight ladder Mₖ→Mₖ₊₂ exactly (ϑE₄=−E₆/3, ϑE₆=−E₄²/2). The same generator in the Dirichlet basis is aₙ ↦ aₙ·log n — i.e. −ζ'/ζ = Λ, the primes (fig 37). One Lie derivative, two bases.

### `39_lfunctions.png` — L-functions Dirichlet L-functions — a parametrised family of generators in the ring

> Replace ζ's all-ones coefficients by a Dirichlet character χ and the whole machinery — Euler product, Lie derivative, group inverse — applies unchanged. Panel A: a small alphabet of real characters as DNAs: χ₋₄ (mod 4 / ℚ(i)), χ₋₃ (mod 3 / ℚ(√−3)), χ₋₇ (mod 7 / ℚ(√−7)), χ₈ (mod 8 / ℚ(√2), real). Panel B: direct partial sums Σ χ(n)/n converging to the class-number-formula targets : L(1,χ₋₄)=π/4 (Leibniz), L(1,χ₋₃)=π/(3√3), L(1,χ₋₇)=π/√7, L(1,χ₈)=log(1+√2)/√2. Panel C: abelian factorisation ζ·L(·,χ₋₃) = ζ_{ℚ(√−3)} = Dedekind ζ of the Eisenstein integers; lattice points on hex-norm circles (a²−ab+b²=n) match (ζ*χ₋₃)(n)·6 to machine precision. Panel D: L(2,χ₋₄) = Catalan's constant G. All five special values verified to floating-point precision; functional equation Λ_χ(1−s)=N^{s−½}·W(χ)·Λ_{χ̄}(s) machine-checked in HSLNLFunctions.lean . One ring, a whole family of generators.

### `40_bsd.png` — BSD A pop at Birch–Swinnerton-Dyer — composing L(E,s) and watching the rank fall out

> Each elliptic curve E has an L-function L(E,s) = ∏ₚ Euler factor — yet another generator built by composition in the Dirichlet ring. By modularity (Wiles et al.) the coefficients aₙ are the Fourier coefficients of a weight-2 newform, so L(E,s) lives in our algebra as a modular-form DNA. We build L(E,s) for five famous curves by point-counting E(𝔽ₚ) for primes p ≤ 40√N, then evaluate L(E,1) via the exponentially-convergent smoothed sum (1+w)·Σ aₙ/n·exp(−2πn/√N) (w = ±1 the root number). The BSD pattern (panel C) : 11a1 / 14a1 (rank 0) → L(E,1) ≈ 0.25, 0.33; 37a1 (rank 1, Wiles), 389a1 (rank 2), 5077a1 (rank 3) → L(E,1) ≈ 0. Panel D : modularity verified — the aₚ from point counts coincide with the LMFDB Fourier coefficients of newform 11.2.a.a for all 15 primes shown. Honest scope: rank-0 ⇔ L(E,1) ≠ 0 is proven (Kolyvagin/Gross–Zagier); BSD itself is open.

### `anim_divisor_orbit.mp4` — animation The coupled divisor, rotating

> A camera orbit around the coupled (z = 0.35) genus-2 zero divisor, so you can read its full 3-D structure — the curve the "neuron" actually is.

### `anim_genus2_coupling.mp4` — animation A tour through 𝓗 2

> The off-diagonal coupling z traces a loop in ℂ while we watch Θ (2) E8 on Z = [[𝜏,z],[z,𝜏]] over the 𝜏-plane — a one-parameter path through the 3-complex-dimensional Siegel upper half-space.

### `anim_gravity_dial.mp4` — animation Dialing the gravity DNA

> State E₈ frozen (cyan zeros); the two gravity E₈ zeros (gold) orbit while the combined energy landscape F_state·F_gravity reshapes around them — an alternate parameter knob acting on a frozen base model.

### `anim_gravity_divisor.mp4` — animation Gravity dial × the genus-2 divisor

> The two realizations unified: the state E₈ divisor (cyan, coupling 0.35) is frozen while the gravity E₈ sector's coupling is dialed (gold). The network's attractor set is the union of the two sector divisors — a multiplicative co-factor whose dial is a coupling, exactly the Hořava–Witten "two walls + bulk" picture.

### `anim_reservoir_flow.mp4` — animation Reservoir relaxation

> Particles released on a trained DNA landscape fall into the neurons under 𝜏̇ = −α∇|F|². Clusters condense onto the zeros; particles in the basin of the quiescent plateau drift away.

### `anim_tweak_neurons.mp4` — animation Tweaking the DNA: where neurons come from & go

> Varying a single DNA coefficient moves the neurons (roots) continuously, but the count is not a free dial: a degree-d DNA has at most d roots, and as you tweak they cross |q|=1 — entering/leaving the disk (Im τ crossing 0) — so the live neuron count sweeps 5 → 0 → 5.

### `game_of_life_poster.png` — interactive Game of Life on the modular cylinder → open ▶

> Conway's Life (B3/S23) run on the modular cylinder 𝓗∕⟨T⟩: the horizontal direction is Re τ and wraps via the modular translation T: τ ↦ τ+1, drawn as an annulus (centre = cusp i∞, rim = the real-axis boundary). Play/pause/step, scrub speed, and click cells to toggle. Survivors warm cyan → gold → pink.
