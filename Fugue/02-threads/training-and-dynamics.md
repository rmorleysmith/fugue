# Training and dynamics: what the HSLN proof-of-concept actually optimises, and how far the claims carry

> **Status.** The trainable objects are small: a **5–12-dimensional complex coefficient
> vector** ("DNA") optimised by hand-rolled Adam on a **2-real-dimensional, box-clipped** state space,
> with gradients from **reverse-mode autodiff through `lax.scan`** — *not* the adjoint method the spec
> recommends. All five training scripts reproduce here. The two headline tasks (`poc_xor.py`,
> `poc_layer.py`) contain **no ODE, no integration, no spikes**: "temporal XOR" is a static four-point
> discriminant, and "layering by tensor product" is a **capacity-neutral reparameterisation** (a
> directly-parameterised monic quartic with the same 8 real parameters fits the same 4 targets *better*).
> `grok.py`'s baseline **never groks** (30 000 steps, test accuracy 0.000), so "must memorise then grok"
> is unsupported by its own control. `skill_compose.py`'s 6/6 is **exact algebra** (roots of unity sum
> to zero to $<10^{-15}$) plus a nearly-isotropic well; it survives a 100× drive-gain change, so the
> reservoir is not the mechanism. Caption numbers are partly non-reproducible: fig 14 claims
> `0.079 → 0.002` (measured `0.07866 → 0.00836`); fig 28 claims "~25k passes/sec, flat across batch"
> (measured peak 7 243/s, non-monotone, and the figure's own curve *falls*).
> **Evidence grade:** **PROVEN** for the zero-union law and the root-of-unity identity; **NUMERICAL**
> for every loss, timing and accuracy below; **ANALOGY** for the reservoir/liquid/spiking vocabulary;
> **REFUTED** for the caption numbers that do not reproduce and for the "temporal" and "GPU-trivial"
> framings. **Sources (only):** `PythonAndVisualizations/` — `poc.py`
> (fig 14, `14_poc_constant_input.png`),
> `poc_sine.py` (fig 15, `15_poc_sine.png`),
> `poc_xor.py` (fig 16, `16_poc_xor.png`),
> `poc_layer.py` (fig 17, `17_poc_layering.png`),
> `scaling.py` (fig 28, `28_scaling.png`),
> `grok.py` (fig 30, `30_grok.png`),
> `skill_compose.py` (fig 29, `29_skill_compose.png`),
> `bench.py`, `animate.py`,
> `figures/game_of_life.html`, captions in
> `figures/index.html`; architecture in
> `system-spec.md` §2, §4, §5. The June files are archived unchanged in `rmorleysmith/hsln-archive`
> (Lean in `lean.zip`, scripts in `python.zip`, figures in `visualizations_part1.zip` and `..._part2.zip`).
> **Reproduced:** yes — all eight Python scripts under
> `Fugue/04-verify/.venv/bin/python` from `Fugue/.work/run/` (CPython 3.14.4, numpy
> 2.5.4, scipy 1.18.1, matplotlib 3.11.2, mpmath 1.4.1, **jax 0.12.0 CPU**,
> `jax_enable_x64=True`). `animate.py` was **not** run: `command -v ffmpeg` returns nothing and it
> needs `FFMpegWriter` (§8). "Independent re-measurement" = inline instrumented re-runs of the same
> modules in the same directory; no file other than this one was written.

---

## 1. What is being trained

**1.1 The parameter.** The DNA is a truncated $q$-expansion coefficient vector; everything else is fixed. $F(\tau;\theta)=\sum_{n<\mathrm{DG}}\theta_n q^n$, $q=e^{2\pi
i\tau}$, and the "energy landscape" is $|F|^2$.

| script | DNA | extra trained | total | task |
|---|---|---|---|---|
| `poc.py` | `DG=6` → 12 real | — | **12** | constant drive $u=\pm1$ routes to one of two targets |
| `poc_xor.py` | `DG=5` → 10 real | — | **10** | 4-pattern XOR truth table |
| `poc_sine.py` | `DG=6` → 12 real | readout $(a,b,d)$ | **15** | follow $0.35\sin(2\pi\cdot2.5\,t/T)$ |
| `poc_layer.py` | 2 monic quadratics → 8 real | — | **8** | place zeros on 4 targets |
| `scaling.py` | `L` complex → `2L` real | — | ≤ **2048** | cost benchmark, no task |
| `grok.py` A | 11 phases $+\kappa$ | — | **12** | $(a+b)\bmod 11$ |
| `grok.py` B | $E\in\mathbb R^{11\times24},W_1,W_2$ | — | **6035** | same, control |
| `skill_compose.py` A | `DNA=[−q_c, 1]` **fixed** | — | **0** | find the missing letter |
| `skill_compose.py` B | $W\in\mathbb R^{6\times2},b$ | — | **18** | name its number |

**PROVEN** by reading: the DNA is the only trainable object in the first four files. **REFUTED** as a general architectural claim: in `skill_compose.py` skill A nothing
is trained at all, and that file's only trained object is an ordinary softmax regressor that is not an HSLN.

**1.2 The optimiser.** All five training loops are the *same* hand-rolled Adam, $\beta_1=0.9$, $\beta_2=0.999$, $\varepsilon=10^{-8}$, with explicit bias correction;
`poc.py lr=0.012`, `poc_sine.py 0.01`, `poc_xor.py 0.01`, `poc_layer.py 0.02`, `grok.py` 0.05 (A) / 0.01 (B). `skill_compose.py`'s skill B is plain full-batch GD
(`lr=0.4`, 500 steps). **PROVEN** by reading. **NUMERICAL/caveat:** no learning-rate sweep, seed average or convergence certificate exists anywhere. One shared defect:
`L` is computed *before* the update and appended *after* it, so `hist[-1]` is the penultimate parameters' loss and the logged curve is shifted one Adam step.
**NUMERICAL** evidence: decomposing the loss at `poc.py`'s *final* `p` gives $d_A=0.004268$, $d_B=0.002272$, $\mathrm{reg}=0.002079$, total **0.008620**, while the script
prints **0.008357**.

**1.3 The losses.** `poc.py` (**NUMERICAL**; the June files do not state it): the objective is a **min over the trajectory**, $\mathcal
L=\min_t\|\tau_A(t)-T_A\|^2+\min_t\|\tau_B(t)-T_B\|^2+10^{-3}\|\theta\|^2$. Re-measured at the trained parameters, the $u=+1$ path comes within **0.0653** of its target
at **step 15 of 160** and is **0.2278** away at the end; $u=-1$ comes within **0.0477** (step 14) and ends **0.2361** away; and $|F|$ **at the two targets** is **0.5813**
and **0.5740**. The targets are not zeros, so the corpus's own description ("the learned field must relax class A to target A") is not the implemented objective and not
the achieved outcome — **REFUTED** as stated. `poc_xor.py`: $\sum_4(s-\text{target})^2+10^{-4}\|\theta\|^2$ with $s=\exp(-|F|^2/2\sigma_F^2)$, $\sigma_F=0.14$.
`poc_sine.py`: MSE of a linear readout plus $10^{-4}\|\theta\|^2$. `poc_layer.py`: $\sum_4|F(\tau_j)|^2+10^{-4}\|\theta\|^2$ — a mean squared *modulus*, not a zero
placement; the single-sector model drives it to residuals $[0.217,0.167,0.183,0.219]$ while placing **no** zero on any target (0/4), so a weak objective can be reduced
without placing an attractor. `grok.py`: cross-entropy, plus $10^{-3}\sum\|W\|^2$ for model B.

**1.4 How the gradient reaches the DNA.** **PROVEN** by reading all nine sources: JAX reverse-mode autodiff of the *discrete* recurrence, exactly, via
`jax.jit(value_and_grad(loss))`; `poc.py`/`poc_sine.py` push it through `lax.scan` (160 / 240 Euler steps), `poc_xor.py`/`poc_layer.py` have no scan. Since $\partial
F/\partial\theta_n=q^n$, the $\theta$-gradient of a static energy evaluation is the basis vector — the spec's §4.4.4 observation is correct. **REFUTED** as a description
of the artefact: the spec (and §5 item 3) recommends `diffrax`/`torchdiffeq` with **adjoint sensitivity**, but `grep -n
"diffrax\|torchdiffeq\|adjoint\|vjp\|jvp\|jacobian"` over the nine sources returns **nothing**. What exists is backprop-through-the-solver on a fixed-step Euler scan: a
valid gradient of the *discrete* recurrence, memory linear in the step count, and not the continuous adjoint. Also **REFUTED**: spec §2.5's learning rule on a **temporal
spike-train loss** (van Rossum distance) appears in no file — `grep van_rossum`/`van Rossum` returns nothing; the nearest thing is `poc_xor.py`'s static Gaussian of
$|F|^2$, which has no time argument.

**1.5 Measured losses and wall clocks.** Wall clock is `time` of the whole script, including matplotlib and one-off JAX compilations; the printed line is verbatim.

| script | configuration | wall | printed |
|---|---|---|---|
| `poc.py` | 800 steps, `lr=0.012` | **12.304 s** | `loss 0.0787 -> 0.00836` (caption `0.079 → 0.002`) |
| `poc_sine.py` | 1200 steps, `lr=0.01` | **12.482 s** | `loss 0.1156 -> 0.00344; RMSE 0.0574` |
| `poc_xor.py` | 1200 steps, `lr=0.01` | **13.688 s** | `loss 1.9530 -> 0.00224` |
| `poc_layer.py` | 2 × 800 steps, `lr=0.02` | **10.900 s** | `single … 0/4` / `layered … 4/4` |
| `grok.py` | 3000 + 6000 steps | **43.916 s** | `A: 1.000/1.000` / `B: 1.000/0.000` |
| `skill_compose.py` | A untrained; 500 GD steps for B | **2.745 s** | `6/6` |
| `scaling.py` | full benchmark | **123.514 s** | §5 |
| `bench.py` | full benchmark | **193.796 s** | incl. `E4 on 1500^2 grid: 9953 ms` |

Intermediate trajectories (**NUMERICAL**, `seed=0`):

```
poc.py      :  1:0.07866  5:0.14455 10:0.06089 25:0.05701 50:0.02564 100:0.02941 200:0.00632 400:0.01062 600:0.00553 800:0.00836
poc_xor.py  :  1:1.95301  5:1.63107 10:1.13504 25:0.66147 50:0.15064 100:0.02199 200:0.00584 400:0.00288 800:0.00239 1200:0.00224
poc_sine.py :  1:0.11563  5:0.08913 10:0.08242 25:0.06014 50:0.05164 100:0.03520 200:0.02038 400:0.00948 800:0.00498 1200:0.00344
poc_layer.py:  1:0.11529 10:0.01341 25:0.00599 50:0.00138 100:0.00002 200:0.00002 400:0.00002 800:0.00002  (layered)
```

`poc.py` is non-monotone (0.0787 → 0.1446 at step 5 → 0.00553 at 600 → 0.00836 at 800). **NUMERICAL:** over five seeds the final loss is $[0.00836,\ 0.00529,\ 0.00989,\
0.01327,\ 0.00472]$, a **3× spread** — the caption's `0.002` lies below the best of five seeds and 4× below this run. **REFUTED** as a reproducible caption; no seed
average, tolerance or error bar is given for any number in these figures.

---

## 2. `poc.py` versus `poc_sine.py` / `poc_xor.py`: initial state versus drive term

**2.1 What the code does.** `poc.py`'s docstring still says the opposite of its body: *"(Input is encoded as the initial condition rather than a tangent drive `B u(t)` …
the time-driven version is the next rung.)"* — yet the body uses a **shared** start plus a **per-class constant drive**: `START=[0.50,0.55]`, `B_VEC=[0.35,0]`,
`U_A,U_B=±1`, `nx = clip(xy[0] - dt*alpha*gn[0] + dt*B_VEC[0]*u, 0.02, 0.98)`. Both classes start at the same point and differ only in $u$; the figure title and caption
say exactly that. So the docstring is **stale**: fig 13 (`13_poc_training.png`, "Two inputs (encoded as initial states)") is the superseded version, and shipped `poc.py`
is already the drive version writing fig 14. **REFUTED** as a description of `poc.py`.

**2.2 Why the drive version is a real step, and how real it is.** **PROVEN** (mathematics, not measurement): initial-state encoding gives a *static* map
$\text{input}\mapsto\Phi(\tau_0)$ — no time argument, no input history, no fading memory, no representable order. A drive $Bu(t)$ makes the state the functional
$\tau(t)=\tau_0+\int_0^t[-\alpha\nabla|F|^2(\tau(s))]+Bu(s)\,ds$, which depends on the history $u(s),s\le t$ — the reservoir-computing premise and exactly spec §2.3. The
two are different architectures and the drive version is strictly more expressive. **But** what is exercised is much less: `poc.py` drives with a **constant** $u$ for the
whole rollout, so its discriminant is still static and no history is ever needed (**ANALOGY** — the mechanism without a temporal task); `poc_sine.py` is the only file
with a genuinely time-varying input ($u(t)=\sin$, 2.5 cycles over 240 steps, `DT=0.03`, raw gradient clipped to $\pm3$ rather than unit-speed); and
`poc_xor.py`/`poc_layer.py` contain **no integration at all** — `poc_xor.py` collapses its drive to a static affine `lane = START + (u1·B1 + u2·B2)·0.40` and
`poc_layer.py` evaluates $|F|^2$ at four points, so for those files the words "temporal"/"reservoir" describe nothing in the code (**REFUTED**).

**2.3 How well `poc_sine.py` tracks.** **NUMERICAL:** `RMSE 0.0574` against a target RMS of $0.35/\sqrt2=0.2475$, i.e. **23.2 % relative error**. A least-squares sine fit
to the trained output gives amplitude **0.3081** (target 0.35), phase **−10.6°**, offset 0.0033, residual **0.0245** — so the output tracks the shape with a 12 %
amplitude deficit, a 10.6° lag and ~10 % distortion. **Ablation:** freezing the DNA and training only the 3-parameter readout gives loss **0.059028**, RMSE
**0.2427** (≈ the target RMS: no tracking at all), while training the DNA too gives loss **0.003443**, RMSE 0.0574 — a **17.1× MSE reduction**. The DNA moved by 0.8699
and the readout became $(4.12,1.18,0.18)$. This is the strongest positive evidence in the ML layer, and it is single-seed, one-frequency, 2.5 cycles.

---

## 3. Temporal XOR (`poc_xor.py`, fig 16)

**3.1 The spike rule.** $s(u_1,u_2)=\exp(-|F(\tau_{\text{lane}})|^2/2\sigma_F^2)$ with $\sigma_F=0.14$. Spec §2.4 writes $s=\mathbb 1[1/|F|>\varepsilon]$; the code's soft
bump agrees in intent and differs in threshold geometry (**ANALOGY**). There is **no time index, no integration, no spike train** — $s$ is a static function of two bits.
Lanes (measured): $(0,0)\to(0.300,0.220)$, $(1,0)\to(0.500,0.220)$, $(0,1)\to(0.484,0.240)$, $(1,1)\to(0.684,0.240)$; $B_1=(0.50,0)$ and $B_2=(0.46,0.05)$ are **6.2°
apart**, so the two single-pulse lanes are **0.0256** apart and share target 1: the network never distinguishes which channel fired.

**3.2 What "learning" means here.** Moving the DNA so one zero of the degree-4 $q$-polynomial sits at the single-pulse lane while the modulus at the other two lanes is
pushed above threshold. **NUMERICAL:** the trained zeros inside $|q|<1$ are $0.492+0.229i$ and $0.875+0.022i$; the first is **0.011** from lane $(0,1)$ and **0.012** from
lane $(1,0)$ — the zero is at the single-pulse position, as claimed. Scores:

```
before (seeded init): (0,0) 0.9942  (1,0) 0.9980  (0,1) 0.9976  (1,1) 0.9821     target (0,1,1,0)
after  (trained)    : (0,0) 0.0130  (1,0) 0.9740  (0,1) 0.9720  (1,1) 0.0140
|F|^2 at the lanes, after:   0.170     0.001      0.001       0.166
```

**A correction not made in the June files (NUMERICAL):** the *untrained* network's truth table is not all-zeros but **all-ones** — $|F|^2\le10^{-3}$ at every lane while
$2\sigma_F^2=0.0392$ — so the initial loss $1.9530\approx2$ is *spikes everywhere*, and training must **suppress** two of them ($|F|^2$ raised from $\sim10^{-5}$ to
0.17), not create a spike. Related: with $\sigma_F=0.14$ the score saturates over most of the strip, so $s$ is a coarse threshold on $|F|^2\lesssim0.04$, not a
proximity-to-zero measurement. The field carved a **hole in a plateau**, not a spike. **Does training or seeding do the work?** `init_params` pre-places a zero at the
single-pulse lane, so this matters. Independent re-measurement with four **random** initial DNAs (no seeded zero), same optimiser, 1200 steps:

```
seed 0: scores (0.009, 0.977, 0.976, 0.016) loss 1.234 -> 0.00180  zeros [0.492+0.229j]
seed 1: scores (0.010, 0.976, 0.975, 0.017) loss 1.392 -> 0.00190  zeros [0.492+0.229j]
seed 2: scores (0.012, 0.972, 0.971, 0.016) loss 1.919 -> 0.00242  zeros [0.155+0.000j 0.820+0.004j 0.492+0.229j]
seed 3: scores (0.014, 0.972, 0.969, 0.015) loss 2.000 -> 0.00265  zeros [0.108+0.023j 0.493+0.229j]
```

Four of four converge to the same truth table and three of four land on $0.492+0.229i$: the optimiser finds this solution from anywhere, so the seeding was a convenience,
not the mechanism. **NUMERICAL**, and it supports the claim. Trajectory: `1.95301 → 0.15064(50) → 0.02199(100) → 0.00224(1200)`; five seeds span $0.00196$–$0.00272$.

**3.3 Grading.** XOR truth table learned: **NUMERICAL** (5 seeds, 4 random inits). A zero at the single-pulse position and none at $\{0,2\}$: **NUMERICAL** (0.011–0.012
away; $|F|^2$ at $\{0,2\}$ raised to ~0.17). "Temporal XOR": **REFUTED** — no time, no integration, no spike train, no channel identity. "A genuine nonlinear fold
performed by the field": **NUMERICAL with a caveat** — the computation is *linear projection* ($\approx u_1+u_2$, since the channels are 6.2° apart) followed by a
**non-monotone** bump, which is genuinely enough for XOR (a monotone response cannot give the band-pass $0,1,1,0$ on $s=0,1,2$). But it is a **one-hidden-unit**
computation on a hand-designed, nearly degenerate encoder that is never trained.

---

## 4. Layering by tensor product (`poc_layer.py`, fig 17)

**4.1 The code and the reproduced measurement.** `sector()` is a monic quadratic with two complex free coefficients (4 real); `coeffs_layered` is
`jnp.convolve(sector(p[:4]), sector(p[4:]))` — a monic quartic from 8 real parameters.

```
single residuals [0.217 0.167 0.183 0.219]  (covers 0/4)
layered residuals [0. 0. 0. 0.]             (covers 4/4)   loss 0.11529 -> 0.0000195
```

The reason is **PROVEN**: $\mathrm{zeros}(F_1F_2)=\mathrm{zeros}(F_1)\cup\mathrm{zeros}(F_2)$ (ℂ is a domain) together with $\deg(F_1F_2)=\deg F_1+\deg F_2$. And the
trained layered solution really does factor the task across sectors — **NUMERICAL**: the first sector's zeros are $0.180+0.120i$ (= target 1) and $0.620+0.140i$ (= target
3), i.e. the two sectors split the four targets 2+2. That is a genuine instance of parallel composition and the best thing in this file.

**4.2 "Tensoring doubles the neuron count" is a degree identity, not a capacity gain.**

1. *Neuron count.* "≤2 per sector, ≤4 in the product" **is** $\deg F_1+\deg F_2=\deg(F_1F_2)$, for
polynomials. **PROVEN** and **trivial**, with nothing to do with the valence formula or the Sturm bound: per the README's own correction a nonzero level-1 weight-4 form
has **one** zero at $\rho=e^{2\pi i/3}$, so this file's "neurons" are the roots of a quartic and "doubling the neurons" means "use a quartic instead of a quadratic".
**ANALOGY** as architecture, **REFUTED** as a statement about modular forms.
2. *Capacity.* Independent re-measurement: train a **directly-parameterised monic quartic** with the
same **8 real parameters**, same optimiser, same loss, same seed — `residuals [0.0000 0.0001 0.0001 0.0001], 4/4, loss 0.14540 → 0.0000068` — at least as good, with a
three times lower final loss than the layered run. This is not luck: the map (monic quadratic, monic quadratic) ↦ monic quartic is **onto**, so the factored family *is*
the family of monic quartics. **REFUTED**: tensoring adds **no** capacity. It is a reparameterisation carrying an extra inductive-bias constraint ("the form factors"),
valuable for *merging already-trained* models but not a cheaper way to add capacity. Also **REFUTED** here: the "neuron placed" indicator is a threshold on a loss that
does not require zero placement (§1.3).

---

## 5. Scaling (`scaling.py` fig 28, `bench.py`)

Both benchmarks ran alone on an idle CPU; `_timeit` = one warm/compile call then means over 3 (or 50) timed calls with `block_until_ready()`.

**A. Batched forward pass** (`bench_batch`, genus-1 flow, `T=120`; two invocations of *identical* code):

```
run 1: batch    1:   0.14 ms ->  7243 inputs/s     run 2:    1:   0.99 ms ->  1013 inputs/s
       batch   16:  13.12 ms ->  1220                   16:   3.12 ms ->  5133
       batch  128:  73.56 ms ->  1740                  128:  59.92 ms ->  2136
       batch 1024: 511.37 ms ->  2002                 1024: 297.42 ms ->  3443
       batch 4096:2606.76 ms ->  1571                 4096: 986.01 ms ->  4154
```

Run 1 peaks at **batch 1** and *falls* with batch size; run 2 peaks at **batch 4096**; absolute times differ **2.6–7×** between identical runs (batch 1: 0.14 ms vs 0.99
ms). Per-input cost at batch 4096 is 4.5× *worse* than at batch 1 in run 1 and 4× *better* in run 2. Hence: "~25k passes/sec on CPU" **REFUTED** (measured peak **7
243/s**); "flat across batch, cores saturate" **REFUTED** (neither run is flat, and the figure's own plotted curve declines monotonically from batch 1 to 4096,
contradicting its caption); "on a GPU this same curve keeps climbing" is **SPECULATION** — there is no CUDA `jaxlib` (JAX prints "An NVIDIA GPU may be present … Falling
back to cpu"), no GPU run in any file, and no arithmetic-intensity measurement.

**B. DNA length = polynomial degree** (256 inputs × 120 steps per timing): `L=4: 12.63 ms → 0.41 µs/evaluation`, `L=64: 372.59 ms → 12.1 µs`, `L=1024: 9496.46 ms → 309
µs`. Ratios 29.5× then 25.5× per 16× length give cost $\approx L^{1.2}$: "linear in DNA length" is **NUMERICAL and approximately true** (mildly superlinear). Two caveats.
The label "`DNA length L` (~L neurons)" is **REFUTED** by the corpus's own README correction (DNA length is a truncation degree; a modular form's zero count is bounded by
the valence formula, $\approx k/12$), and the swept DNA is random coefficients scaled by $1/L$, which corresponds to no modular form. And "weight is cheap" fails in the
full sense, because `bench.py` measures coefficient→zero recovery by `np.roots` on a companion matrix, $O(d^3)$: `d=10: 0.11 ms → 10 roots`; `d=100: 53.50 ms → 100`;
`d=1000: 14178.77 ms → **400**`. At $d=1000$ it recovers only **400 of the 1000 designed zeros** inside $|q|<1$, from zeros placed at $\mathrm{Im}\,\tau\in[0.2,0.7]$ (all
with $|q|\in[0.012,0.284]$, far inside the disk). That is ill-conditioning of `np.roots`, not geometry: reading the neurons out of a long DNA **fails** and costs 14 s.

**C. Composition** (`bench_compose`, length-3 DNAs convolved $K$ times; cost $\sum 3m$, so $O(K^2)$):

```
K= 2:  33.0 us (len 5)     K=16:  34.9 us (len 33)
K= 4:  15.1 us (len 9)     K=32: 102.5 us (len 65)
K= 8:  18.0 us (len 17)    K=64: 170.3 us (len 129)
```

**NUMERICAL:** microseconds, and non-monotone at the low end (K=4 faster than K=2 — timer noise). The caption's "~1000× cheaper than a forward pass" is **REFUTED as
stated**: against a *single* forward evaluation at $L=4$ (0.41 µs) composition is ~100× **more** expensive; the 1000× only appears against a 256-input batch (12.6–48.3
ms). Composition *is* cheap relative to evaluating the DNA it produces (length 129 ≈ 30–40 µs/evaluation).

**D. Genus** — the only genuinely steep axis, and the mechanism is specific:

```
representation_numbers(maxn=4):   854.9 ms  ->  29 Fourier coeffs
representation_numbers(maxn=6):  6903.8 ms  ->  76
representation_numbers(maxn=8): 53763.8 ms  -> 161
genus-1 series eval (199 terms, one point, JAX): 188.34 us
bench.py: norm<=6 ->  9121 E8 vectors ->  76 terms in  7.12 s
          norm<=8 -> 26641 E8 vectors -> 161 terms in 44.26 s
```

The E8-vector count grows 2.92× from $\|v\|^2\le6$ to $\le8$ and the time grows **7.8–7.9× ≈ 2.92²**: the routine enumerates **pairs** (`B = V @ V.T`, then bins inner
products). Mechanism: the genus-$g$ theta's Fourier data is indexed by half-integral symmetric $g\times g$ matrices $T$, and $r(T)$ counts $g$-tuples of lattice vectors
with prescribed Gram matrix, so brute force is $O(N_{\text{vec}}^g)$ — the measured quadratic at $g=2$; **$g\ge3$ is an extrapolation (SPECULATION)**, since nothing here
evaluates genus 3. **The caption's framing of D needs correcting.** The caption says "genus-1 is ~20 µs, genus-2 climbs from 0.1 s to 8 s" (measured **188 µs**, and
**0.855/6.90/53.76 s** — off by 9× and ~6.7×), and it compares a **per-point evaluation** with a **one-off table construction**. Apples to apples, per point, numpy
`complex128`, 200 000 points:

```
genus-1, 199-term q-series     : 15421.7 ns/point
genus-2,  29-term Siegel theta :  1561.4 ns/point
genus-2,  76-term Siegel theta :  4116.0 ns/point
genus-2, 161-term Siegel theta : 10372.2 ns/point
```

Evaluating the 161-term genus-2 theta is **cheaper per point** than the 199-term genus-1 series used in the same figure. So "genus is the only steep axis (Siegel theta
sum)" is **REFUTED** as a statement about evaluation cost and **NUMERICAL/PROVEN** as a statement about *building the table*, where the driver is the $g$-tuple
Gram-matrix count. Finally, there is **no error control** anywhere: animate and `scaling` use `maxn=6`/`8` truncations with no tail bound, and on the animation grids the
truncation is safe only because of the grid chosen — the smallest retained mode has $|e^{i\pi(a+c)\tau}|=e^{-2\pi\cdot0.45}=5.9\times10^{-2}$ at $\mathrm{Im}\,\tau=0.45$ while the
largest *discarded* mode ($a+c=14$) has $e^{-\pi\cdot14\cdot0.45}=2.5\times10^{-9}$ — a property of the grid that is not stated or checked.

| axis | verdict | evidence |
|---|---|---|
| batch | **unestablished** — 2.6–7× run-to-run noise, non-monotone, contradicts its own caption | peak 7 243/s; 1.2k–4.2k/s across batch points |
| weight (DNA length) | **cheap for the forward pass** ($\approx L^{1.2}$: 0.41 µs → 309 µs); **expensive and unreliable** for root extraction ($O(d^3)$; 400/1000 at $d=1000$) | §5 B |
| composition | **cheap** — µs, $O(K^2)$ in the naive loop; *more* expensive than one unbatched forward pass | §5 C |
| genus | **expensive to prepare, not to evaluate**; $O(N_{\text{vec}}^2)$ measured at $g=2$; $g\ge3$ unmeasured | §5 D |

---

## 6. Grokking (`grok.py`, fig 30)

**6.1 Models.** **A**: a learnable phase $\varphi_k$ per symbol (11) plus gain $\kappa$; logits $z_c=\kappa\cos(\varphi_a+\varphi_b-\varphi_c)$; $\arg\max$ decodes. **12
parameters**. **B**: a 24-dim learned embedding, concat, `tanh` MLP width 96, readout — **6035 parameters** for **60** training constraints (50/50 split of 121 pairs),
Adam `lr=0.01`, weight decay $10^{-3}$, 6000 steps.

**6.2 Measured.**

```
A: (step 0: train 0.033, test 0.098)  then train = test = 1.000 at step 100 and every 100 steps to 3000
B: (step 0: train 0.200, test 0.049)  then train = 1.000, test = 0.000 at step 100 and every 100 steps to 6000
```

**The phases really are a lattice — NUMERICAL, verified.** Sorted $\varphi/2\pi=[0.090,0.182,0.273, 0.365,0.456,0.546,0.637,0.727,0.817,0.910,1.000]$; gaps
$0.090$–$0.093$ against the ideal $1/11=0.0909$; max gap deviation $0.0022$; $(\varphi-\varphi_0)11/2\pi$ is an integer lattice to within $0.03$, i.e.
$\varphi(k)\approx2\pi k/11+c$ to about **1°**; $\kappa=28.56$. The shift is pure gauge (only differences enter). I checked both decoders: the full $11\times11$ addition
table is decoded at **100 %** by the learned phases *and* by ideal roots of unity. My initial doubt from the PNG's jumbled label order was wrong. So "the phases emerge as
roots of unity" is **NUMERICAL, true**.

**The control never groks — REFUTED as demonstrated.** Extending the control to **30 000 steps** (5× the corpus budget) in its own regime (`wd=1e-3`, `lr=0.01`) gives
train 1.000 / test **0.000** at every 3 000-step checkpoint; a grokking-favourable regime (`wd=3e-2`, `lr=3e-3`, 30 000 steps) gives the same. The experiment therefore
shows **memorise-and-never-generalise**, not "memorise then grok". The suptitle ("a generic net must memorise then grok") describes a transition its own baseline never
makes, and the claim to *shortcut grokking* rests on a delay that was never demonstrated.

**6.3 Comparison with the literature.** *Power et al. 2022* study modular addition at $p\sim113$, tens of thousands of epochs, with tuned weight decay and train fraction, and observe
a memorisation plateau followed by an abrupt transition. Here $p=11$ (121 pairs, **60** training examples) with 6035 parameters, and 6000 steps is far below the regime
where they see the transition; my 30 000-step extension in two optimiser regimes still shows none. So this file reproduces the *plateau* and nothing else — **NUMERICAL
but not a reproduction**, and it does not bear on whether a generic net would eventually grok. The fair statement of what was shown: *at this size and budget an
overparameterised MLP finds the memorising solution and not the generalising one, while the architecture with the right inductive bias finds the generalising one
immediately* — a claim about **inductive bias**, with the inductive bias doing all the work (the required caveat). *Nanda et al. 2023* reverse-engineer a *trained*
transformer and show the circular representation is **discovered** and that their progress measures are invisible in the loss; here circularity is **built in** — the
kernel $\kappa\cos(\varphi_a+\varphi_b-\varphi_c)$ is hand-written and I verified the optimum is the lattice, so nothing is discovered. "Shortcutting Nanda et al." is
**ANALOGY**, and the stronger reading (that the HSLN's state space is natively circular) is **REFUTED** by this file: model A never touches $\mathbb H_g$, a modular form,
$|F|^2$ or the ODE; it is a 12-parameter circular decoder.

**6.4 "Only $n+1$ parameters makes memorisation impossible."** **NUMERICAL**, with a decisive control: replace the labels by a random permutation of the 121 labels, keep
the 50/50 split, retrain both —

```
circular model (12 params) on a RANDOM 121-label table: train 0.167   test 0.115
MLP control   (6035 params) on the SAME random table  : train 1.000   test 0.082
```

The MLP **memorises** and still does not generalise (0.082 ≈ chance $1/11$); the 12-parameter model **cannot** fit 60 arbitrary constraints, so it is not free to fit
noise, and on the *true* table the only low-loss solutions are the global rule. Grade the mechanism **NUMERICAL**; grade the implication carefully — this is a
**parameter-counting argument**, not a theorem that every low-loss solution generalises (11 phases over 60 constraints leave slack; 100 % test accuracy is empirical, at
one seed and one $n=11$).

---

## 7. Skill stacking (`skill_compose.py`, fig 29)

**7.1 The two kinds of composition.** **DNA-product composition**: multiply forms = Cauchy-convolve coefficients = tensor product. Semantics $\mathrm{zeros}(F\cdot
G)=\mathrm{zeros}(F)\cup\mathrm{zeros}(G)$ — **PROVEN** (ℂ is a domain) — combines two trained landscapes **in parallel**, with both parents' attractors simultaneously
and no further training or data; parameters add, degree adds. **Function composition** $B\circ A$: $A$'s output becomes $B$'s input; it computes a *sequence* and requires
$A$'s output to be something $B$ can read. Here it is literally `count(W, b, find_missing(present)[1])`, a numeric handoff — and $B$ is **not an HSLN**: a 6-class softmax
linear classifier ($W\in\mathbb R^{6\times2}$, $b\in\mathbb R^6$, **18** parameters) trained by 500 full-batch GD steps (`lr=0.4`) on $6\times80=480$ noisy direction
samples ($\sigma=0.10$). **PROVEN** by reading; the two operations are genuinely different and the file is right to say so.

**7.2 The root-of-unity trick, verified.** Encode position $p\in\{0,\dots,5\}$ as the direction $\omega^p=(\cos 2\pi p/6,\sin 2\pi p/6)$. Since
$\sum_{p=0}^{5}\omega^p=0$, $\sum_{p\in S}\omega^p=-\sum_{p\notin S}\omega^p$, so the present letters' net pull points exactly at the **antipode** of the missing one and
negating recovers it. **PROVEN**; measured residuals $|\sum_{\text{present}}\omega^p+\omega^m|$ = **4.6e-16, 8.9e-16, 6.8e-16** for $m=0,2,5$.

**7.3 What the reservoir adds: measured, and it is almost nothing.** Skill A is `xy ← xy − dt·α·∇|F|² + dt·Bd·D` in a confining well $|F|^2=|q-q_c|^2$, with
$D=\sum_{\text{present}}\mathrm{DIR}[p]$ computed **in numpy, outside the reservoir**.

```
m, angle(reservoir_recovered, true), angle(pure_sum_D, true), |displacement|, |D|
0   5.2262 deg   180.0 deg   0.25677   1.0        3   5.2262 deg   180.0 deg   0.25677   1.0
1   6.9288 deg   180.0 deg   0.16649   1.0        4   0.8288 deg   180.0 deg   0.28466   1.0
2   6.9288 deg   180.0 deg   0.16649   1.0        5   0.8288 deg   180.0 deg   0.28466   1.0
pipeline accuracy (re-measured, matches the script's own 6/6): 6/6
drive Bd = 0.005 -> 6/6 ;  Bd = 0.05 -> 6/6 ;  Bd = 0.5 -> 6/6
```

Three **NUMERICAL** findings: the pure-sum control is **exactly 180° off**, confirming $D=-\omega^m$ so that negating gives the answer by algebra alone; the reservoir
reproduces that direction to within **0.83°–6.93°** (a nearly isotropic spring, the residual error being the conformal factor of $\tau\mapsto q$ plus box clipping,
tolerated because the six classes are 60° apart); and **changing the drive gain 100× leaves the pipeline at 6/6** — a mechanism whose output is invariant under a 100×
change of its only drive is not producing the answer. So the **6/6 is PROVEN as algebra** (exact identity + a readout resolving 60°-separated classes) while the mechanism
claim — *"skill A is a CONFINED, DRIVEN reservoir … integrating the bag of present letters"* — is **REFUTED as a description of the code**: the sum is an explicit numpy
reduction and the reservoir only scales and slightly rotates a vector that already *is* the antipode of the answer. Grade the headline "stacking two skills" **ANALOGY**;
grade the arithmetic **PROVEN**.

---

## 8. Animations and the Game of Life page

**8.1 What I ran and what I did not.** **`ffmpeg` is not installed** (`command -v ffmpeg` prints nothing), and every `anim.save(...)` in `animate.py` passes
`FFMpegWriter`, so **`animate.py` was not run**; §8.2 is from reading its 290 lines plus the shipped stills and the captions in
`figures/index.html`. The seven `.mp4` files are shipped artefacts I did not decode. Note also that **`ANIMS` has exactly
six entries** (`genus2`, `flow`, `tweak`, `divisor_orbit`, `gravity`, `gravity_divisor`); the seventh file `anim_e8_torsion_factor.mp4` (27 619 bytes — 4.6× smaller than the
next smallest, 105× smaller than the largest) is written by `hsln_e8_torsion_factor.py` — outside this thread's sources — and has **no caption** in `index.html`. So "7 animations in `animate.py`"
is wrong on both counts.

**8.2 The six, with their mathematical content.** **`genus2`** — $\Theta^{(2)}_{E8}$ on the slice $Z=\left(\begin{smallmatrix}\tau&z\\z&\tau\end{smallmatrix}\right)$,
$\tau$-grid $\mathrm{Re}\,\tau\in[-0.6,0.6]$, $\mathrm{Im}\,\tau\in[0.45,1.45]$, $420^2$, 96 frames at 20 fps, with the coupling $z$ tracing a radius-0.45 circle in ℂ.
Content: a one-parameter loop through the 3-complex-dimensional $\mathbb H_2$; the slice is the diagonal embedding of $\mathbb H_1$ plus a complex coupling. **PROVEN** by
reading: the $\tau$-dependent part is precomputed per Fourier term and only $e^{2\pi ibz}$ is recomputed per frame, so a frame is one matrix–vector product. The grid is a
**rectangle in $\tau$**, not a fundamental domain, and `coloring.domain_color` colours the *value* of the form, not the domain. **`flow`** — 1380 particles ($46\times30$)
on a DNA built from three **designed** zeros ($0.30+0.46i$, $0.68+0.52i$, $0.50+0.27i$, `dna_from_neurons(lead=40)`), 700 Euler steps, basins coloured by nearest zero
within a 0.05 capture radius. Content: the **basin structure** of $\dot\tau=-\alpha\nabla|F|^2$ — the most faithful picture of the architecture. Cost is in `bench.py` (438 ms at
$d=10$, 3550 ms at $d=100$ coefficients, for 1000 paths × 700 steps). Caveat: the landscape is hand-designed, not trained, and the integrator is a hand-written Euler loop
in `render.integrate_paths`, not the JAX rollout. **`tweak`** — scales **one** coefficient ($c_0\mapsto c_0 10^{s}$, $s$ sweeping $\pm2.2$ and back over 120 frames) and
animates `np.roots` in the $q$-disk, colouring roots with $|q|<1$ as "neurons". **I verified the mechanism exactly**: for $\sum_{i=0}^d c_iq^i$, multiplying $c_0$ by
$\lambda$ scales the roots' geometric mean by exactly $\lambda^{1/d}$ (since $\prod r_i=(-1)^dc_0/c_d$). For $d=5$ the geometric mean is $0.488565$ at $s=0$, $0.615067$
at $s=0.5$, $0.774323$ at $s=1.0$, $1.345619$ at $s=2.2$ — each equal to the prediction to **six decimals** — and the count inside $|q|<1$ over the 120 frames is
$5\to5\to3\to0\to3\to5\to5$ (observed values $\{0,1,2,3,5\}$, **14 of 120 frames at zero**). So the caption's "count sweeps 5 → 0 → 5" is **NUMERICAL, true**, and it is a
statement about a *truncated polynomial* (consistent with README correction #1), which the file's own docstring states. **`divisor_orbit`** — camera orbit around the
genus-2 zero set on the coupled slice ($z=0.35$), axes $\mathrm{Re}\,\tau,\mathrm{Im}\,\tau,w$. Content: on a fixed-$z$ slice $\Theta^{(2)}$ is a holomorphic function of
two complex variables, so its zero set is complex codimension 1 = a **curve**, which is what is plotted. (In the full 3-complex-dimensional $\mathbb H_2$ a single
holomorphic function's zero set is 2-complex-dimensional — a hypersurface; the animation shows the *slice's* curve, so the caption "the curve the 'neuron' actually is" is
**ANALOGY**: accurate in the slice, an overstatement in general.) **`gravity`** — $F=F_{\text{state}}\cdot F_{\text{gravity}}$ on a $480^2$ grid, 120 frames: four
**frozen** designed state zeros ($0.25+0.52i$, $0.52+0.66i$, $0.76+0.46i$, $0.40+0.30i$) plus two gravity zeros orbiting at radius 0.20 about $0.5+0.46i$. Content: the
**product law in motion** — the displayed landscape's zero set is visibly the union of the four frozen and the two moving zeros. This is the corpus's clearest visual
statement of $\mathrm{zeros}(F\cdot G)=\mathrm{zeros}(F)\cup\mathrm{zeros}(G)$: **PROVEN** law, faithful illustration; the "dialing a cofactor" reading is **ANALOGY**.
**`gravity_divisor`** — the same on the genus-2 divisor: state curve ($z=0.35$) frozen, gravity coupling dialled $z_G\in[0.05,0.60]$ with cosine ease, camera oscillating
±24°; the attractor set is the union of the two sector divisors. Correct as the product law; the "Hořava–Witten two walls + bulk" remark in `index.html` is
**SPECULATION** (nothing in the file relates a genus-2 theta to that construction). **Overall:** **ANALOGY**, with two exceptions carrying real content — `gravity`
(faithful rendering of the union law) and `tweak` (an exact, checkable root-scaling statement). **No animation shows learning, a spike, or a computation.**

**8.3 The Game of Life page.** I read `figures/game_of_life.html` (168 lines) and did **not** execute it in a
browser; §8.4 replicates its *rule*. Content: Conway's Life (B3/S23) on a $90$ (angular) × $40$ (radial) grid drawn as an annulus, the horizontal direction being
$\mathrm{Re}\,\tau$ and **wrapping** via $T:\tau\mapsto\tau+1$, centre = cusp $i\infty$, rim = the real-axis boundary, survivors warming cyan → gold → pink, with
interactive toggle, play/pause/step/random/clear and speed 1–30 steps/s. What carries content: the angular wrap **is** the $T$-identification, and only `i` is wrapped
while `j` is bounded — verified behaviourally, a vertical blinker at column 0 and at column 89 being indistinguishable and both of period 2 — and the annulus topology is
**correct** for the modular cylinder, which has two ends. What does not: the **metric is Euclidean, not hyperbolic** (cells are uniform in (angle, radius), hence equal
*Euclidean* area, whereas the hyperbolic area element is $y^{-2}dx\,dy$ and varies without bound between rim and cusp; an area-faithful grid needs radial thickness
$\propto y^2$) — **REFUTED** as a discretisation, **ANALOGY** as a picture; the graph is the standard 8-neighbour square lattice on an annulus, not any modular
tessellation or Hecke correspondence; the age ramp encodes cell age (`t=min(a/40,1)`), which means nothing mathematically; and the rim is a **hard wall** (missing
neighbours), not the hyperbolic boundary and not a periodic identification. **Grade: ANALOGY** — faithful in exactly one respect (the $T$-wrap, verified), not faithful in
metric, graph and rim, and containing **no HSLN object at all**: no modular form, no zero, no $|F|^2$, no spike.

**8.4 Headless measurement of the page's rule.** I re-implemented the page's exact update (B3/S23, `NCOLS=90`, `NROWS=40`, angular `np.roll`, radial bounded) in numpy —
this measures the *rule*, not the page:

```
random 30% soup: 1080 -> 389 live at gen 50 (10.8%) -> 246 (6.8%) -> 95 (2.6%) -> 91 (2.5%) at gen 5000
ash is period-2 (post-5000 state differs from itself by 0 cells at offsets 0 and 2, by 4 at offsets 1, 3)
single glider translates diagonally, +1 row and +1 col per 4 generations
  gen  20: rows 15-17, cols 45-47      gen  92: rows 33-35, cols 63-65
  gen  60: rows 25-27, cols 55-57      gen  96: rows 34-36, cols 64-66
  gen  88: rows 32-34, cols 62-64      gen 100: rows 35-37, cols 65-67
  gen 120: rows 38-39, cols 68-69 (4 cells) — still 4 cells at gen 200 and 400
```

A glider released mid-grid reaches the **radial rim** at about generation 116 and freezes into a 4-cell block; it never orbits. So the page's claim that **gliders travel
around the cusp** is **REFUTED for this grid**: a Life glider moves diagonally at 45°, and where only the angular direction wraps it *must* eventually meet the radial
boundary — it can only "orbit" if it reaches the seam before the rim, which it does not (from column 40 it hits the rim first). A wrapped-but-radially-bounded cylinder
cannot host an orbiting glider. The 2.5 % ash density is ordinary Life behaviour and is not evidence about $\mathbb H$.

---

## 9. What is established / numerical / not established

### 9.1 Established (PROVEN — theorem, exact identity, or verified to machine precision)

1. $\mathrm{zeros}(F\cdot G)=\mathrm{zeros}(F)\cup\mathrm{zeros}(G)$ — ℂ is a domain; exercised in `poc_layer.py`, `animate.gravity`, `animate.gravity_divisor`.
2. $\deg(F_1F_2)=\deg F_1+\deg F_2$, hence "tensoring doubles the degree" — trivial, and the whole reason one sector covers ≤2 targets and the product ≤4.
3. $\sum_{p\in S}\omega^p=-\sum_{p\notin S}\omega^p$ for $n$-th roots of unity: measured residuals 4.6e-16 … 8.9e-16 at $n=6$.
4. Scaling $c_0$ by $\lambda$ scales a degree-$d$ polynomial's root geometric mean by exactly $\lambda^{1/d}$: verified to six decimals at $d=5$, and it fully explains `tweak`'s 5 → 0 → 5 sweep.
5. $\partial F/\partial\theta_n=q^n$, and JAX delivers the exact $\theta$-gradient by reverse-mode autodiff through the discrete recurrence in all five trainers (losses decrease in aggregate across seeds).
6. Every monic quartic factors into two monic quadratics, so the two-sector parameterisation is *onto* the monic quartics: 8 real parameters either way — confirmed numerically in §4.2.
7. Genus-2 table cost is quadratic in the E8-vector count: 9121 → 26641 vectors (2.92×) costs 7.12 s → 44.26 s; the mechanism is the $V@V^{\mathsf T}$ pair enumeration.

### 9.2 Numerical (real measurements in a stated regime, no proof)

1. Every loss and trajectory in §1.5 — single-seed, except `poc.py`'s 5-seed span $0.00472$–$0.01327$ and `poc_xor.py`'s $0.00196$–$0.00272$.
2. XOR scores $(0.013,0.974,0.972,0.014)$ vs target $(0,1,1,0)$, the zero at $0.492+0.229i$ (0.011 from the single-pulse lane), reproducible from four random inits.
3. Single-sector 0/4 vs layered 4/4, and the direct quartic's 4/4 at lower loss (6.8e-06 vs 1.95e-05).
4. `poc_sine.py`'s 17.1× MSE reduction over the frozen-DNA readout; RMSE 0.0574 vs target RMS 0.2475 (23.2 % relative); amplitude 0.3081 vs 0.35; phase −10.6°.
5. All of §5, including the 2.6–7× batch-benchmark instability and `np.roots`' failure to recover 600 of 1000 designed zeros at $d=1000$.
6. The per-point comparison: the 161-term genus-2 theta at 10 372 ns/point is *faster* than the 199-term genus-1 series at 15 422 ns/point.
7. The lattice phases ($\approx2\pi k/11$ to ~1°; gaps $0.0909\pm0.0022$; $\kappa=28.56$), the 100 % full-table decode, and the random-table capacity control (12 params: train 0.167; 6035 params: train 1.000 / test 0.082).
8. The control never generalising: test 0.000 at 30 000 steps in two optimiser regimes.
9. `skill_compose.py`'s 6/6, the 0.83°–6.93° angular errors, and the 100× drive-gain invariance.
10. `tweak`'s frame-by-frame counts ($5\to3\to0\to3\to5$; 14/120 frames at zero).
11. The Life-rule replication: 2.5 % ash, period-2 ash, glider frozen at the rim by generation 120.

### 9.3 Not established (by anything in these files)

1. **Any temporal capability.** No file trains a sequence-dependence task; `poc_sine.py` follows a pure one-frequency sine, which a linear readout of a driven 2-D system does not need memory for. No delayed-copy, parity or order-sensitivity task is attempted.
2. **Any spike train.** Nothing emits, integrates or scores one; `poc_xor.py`'s "spike" is a static scalar per pattern, and its threshold is inverted relative to §2.4's $1/|F|$ (a bump at the zero).
3. **The adjoint method / continuous-time gradient.** No `diffrax`, `torchdiffeq`, ODE solver, `vjp`, `jvp` or Jacobian anywhere; §4.4.4 of the spec is unimplemented.
4. **Zero-shot merging of two independently trained models** — spec §4.4.6's "cheapest empirical test of the whole architectural claim" and §5 item 5. `poc_layer.py` trains both sectors **jointly** under one loss, so it does not test merging, and no other file multiplies two separately trained DNAs. The June files' own stated falsification test ("if this fails, the algebraic framing is dressing") has **not been run**.
5. **Any GPU claim.** No CUDA `jaxlib`, no GPU run, no arithmetic-intensity measurement.
6. **Grokking of the baseline.** The transition is never observed, so nothing is shortcut.
7. **Error control on any truncation.** The genus-2 theta, the DG-truncated forms and the Sturm-bound story are all used without a tail bound; the PoC's "modular form" is a low-degree polynomial, and per the README a level-1 weight-4 form has exactly one zero, so the truncation controls nothing about attractor count.
8. **Anything about $\mathbb H_g$ as a state space.** The dynamics runs inside $[0.02,0.98]\times[0.05,0.95]$ with `clip` every step and a **unit-normalised** gradient (`gn = g/|g|`), so it is neither $-\alpha\nabla|F|^2$ nor a flow on $\mathbb H$.
9. **The implicit-function-theorem picture of moving zeros.** No file computes a Jacobian, perturbs a coefficient and measures a *zero*'s response; the only zero-motion evidence is that roots move (§8.2) and that zeros end up where a loss wants them.
10. **A trained encoder.** $B$, $B_1$, $B_2$, `DRIVE_GAIN`, `START`, the targets, $\sigma_F$ and the whole task geometry are hand-set; no file learns an input map.
11. **Any capacity advantage for tensor-product layering** — refuted, not merely unestablished (§4.2).
12. **Any $g\ge3$ claim.** Cost, evaluation or accuracy: no measurement.

---

## 10. Failure modes and scope limits

**The claim is narrower than the vocabulary used for it.** Every figure title says some form of "the network learns"; what the code does is optimise a **5–12-dimensional coefficient
vector** shaping a fixed analytic function on a **2-real-dimensional** clipped box, then threshold or linearly read out its value. A fixed landscape with a learned linear
encoder is a much weaker claim than "we trained a network": no weights, no layers, no nonlinearity beyond $|F|^2$, no learned input map, and — in `poc_xor.py`,
`poc_layer.py`, `skill_compose.py` — no dynamics at all. *Where the June files acknowledge this:* `poc.py`'s docstring ("the gravity DNA *is* the thing we train");
`system-spec.md` §4.4.2 (a naive linear $B$ "is fine for a first pass") and §5 item 1 (which restricts the first prototype to $g=1$, a 2-D state it calls "too small");
§4.2.3, which explicitly drops the structure-theorem framing; the README's correction #1; and `animate.py`'s `tweak` docstring ("the count is not a free dial even though
the coefficients are"). These passages are accurate, and they are what make this thread possible to grade. *Where it does not:* the captions and titles — "Temporal XOR"
(§3), "spiking reservoir", "reservoir relaxation", "the field carved a spike", "layering is the cheap way to add capacity" (§4.2), "reservoir integrates the bag of
present letters" (§7.3), "a generic net must memorise then grok" (§6.2), "~25k passes/sec" / "GPU-trivial" / "genus is the only steep axis" (§5). Each either overstates
what the code does or states a number that does not reproduce.

**Specific findings, ranked by how much they matter.**

1. **The loss does not ask for attractors at the targets.** `poc.py` minimises a min-over-trajectory distance, achieved at step 14–15 of 160, after which the state moves away; $|F|=0.58$ at both targets. The stated task is not the implemented task nor the achieved outcome. **REFUTED**.
2. **`poc_xor.py` and `poc_layer.py` are not dynamical.** No scan, no ODE, no time: "temporal" and "reservoir" are **REFUTED** for those files.
3. **Tensor-product layering is capacity-neutral.** Same 8 parameters, same 4 targets, and the direct quartic does better. **REFUTED** as "the cheap way to add capacity".
4. **`skill_compose.py`'s reservoir is not the mechanism.** The sum is numpy, the identity is exact, and the result is invariant under a 100× drive change. **REFUTED** as stated.
5. **The grokking comparison does not show grokking.** The baseline never groks in 30 000 steps in two regimes; what remains is a legitimate inductive-bias result.
6. **Caption numbers that do not reproduce.** fig 14: `0.079 → 0.002` vs measured `0.07866 → 0.00836` (best of 5 seeds 0.00472). fig 28: "~25k passes/sec, flat across batch" vs peak 7 243/s, non-monotone, figure-visible decline; "genus-1 ~20 µs" vs 188 µs; "0.1 s → 8 s" vs 0.855/6.90/53.76 s. fig 13: "loss 0.08 → 0.0002, ~3 s" — a different, earlier code path than the shipped `poc.py`.
7. **The one structural test the PoC plan itself demands is not run** (spec §4.4.6 / §5 item 5). Without it, the algebraic framing of composition remains untested against the architecture it was meant to justify.
8. **Numerical fragility.** Identical timing runs vary 2.6–7×; single-seed losses vary 3× and one seed is reported; the loss log is off by one Adam step; `np.roots` loses 60 % of designed zeros at $d=1000$; $\sigma_F=0.14$ exceeds the field's natural scale so the "spike" score is $\ge0.98$ at *all four* XOR inputs before training; and the box clipping plus unit-normalised gradient mean that no statement about $\mathbb H_g$ carries over to the implementation.
9. **The "9^25 DNA strands" story does not appear in this layer.** The largest DNA here is $L=1024$ complex coefficients (2048 real), in a *timing loop only*, where root recovery already fails; every *trained* object in this thread has **10–15** learnable real parameters, apart from the two controls (6035-parameter MLP, 18-parameter softmax).

**What survives, stated minimally.** Multiplying two forms unions their zero sets (**PROVEN**), and a product of two trained sectors really does place a union of
attractors (**NUMERICAL**, §4.1). A gradient flow on $|F|^2$ for a truncated $F$ is a workable reservoir on a 2-D state space: it routes two classes with 12 parameters
(**NUMERICAL**, with the caveat that the targets are near-misses, not attractors), tracks a sine with 15 parameters at a 17× MSE gain over a frozen landscape
(**NUMERICAL**, 23 % relative error), and solves a four-pattern XOR truth table by placing a zero within 0.012 of the single-pulse lane, robustly across initialisations
(**NUMERICAL**). A 12-parameter circular decoder generalises immediately on $(a+b)\bmod 11$ while a 6035-parameter MLP memorises and does not (**NUMERICAL**), the reason
being a parameter count that makes memorisation impossible (**NUMERICAL**) — the inductive bias, not the training, is what generalises.
