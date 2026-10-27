# Appendix B — the KnowledgeBase, and one structural finding

The corpus contains a fourth source besides the figures, the Lean files and
`math-connections.md`: fifteen markdown chapters in the `KnowledgeBase` folder, plus eight helper
ports in its `code` subfolder. This appendix covers them. It also records a structural finding
about how the June files fit together.

The KnowledgeBase chapters are not part of the public archive (`rmorleysmith/hsln-archive`), so
the measurements described here cannot be checked by a reader. They are named below by file
name only.

> **Headline finding:** the KnowledgeBase documents a **Python package (`Python/hsln/`) that does
> not exist in this workspace.** No `Python/` directory, no `hsln/` package, none of the modules
> the chapters cite (`paths.py`, `calabi_yau.py`, `category.py`, `generate.py`, `train.py`,
> `algebra.py`, `fluids.py`). Every number in chapters 08–12 was measured against that package on
> 2026-06-21 and **cannot be reproduced here**. See §4.

---

## 1. What the KnowledgeBase actually is

It is *not* another copy of the mathematics. The main corpus (figures + `math-connections.md` +
`Math-Lean/`) is about a *theory*. The KnowledgeBase is a **dated tooling survey with an
integration agenda**, and its distinguishing feature is that it cites real, checkable external
artefacts:

- AlphaProof's Nature paper (`s41586-025-09833-y`, 2026) and the IMO 2024 result
- `lean-gym` (archived May 2026), `leanprover/lean4` commits, `Mathlib4` PR numbers
- `physlib` (Navier–Stokes residual API, Wirtinger calculus, Riemannian metric),
  `PrimeNumberTheoremAnd`, `cslib`, **TorchLean** (NNs defined *inside* Lean, Feb 2026),
  **BRIDGE** (code+spec+theorem+proof synthesis), **LeanDojo-v2**, **LeanCat**, **CertPINN**
- Specific arXiv identifiers for the optimization/differentiable-physics lines
  (`2509.03738`, `2512.05534`, `2605.18106`, `2602.12706`, `2605.29955`)

and it is explicit about its own epistemic discipline:

> "Ethos, matching `../lean-ml-survey.md`: everything below was checked against the real source on
> 2026-06-21. Where something could not be confirmed, it says so. **Nothing here is fabricated.**"
> — the KnowledgeBase `README.md`

That claim was not independently verified here (see [`05-repro/README.md`](../05-repro/README.md)
§4), and it should be treated as *unverified but plausible* rather than either
trusted or doubted. What can be said is that the citations are *specific enough to be checkable*,
which is the right form for a survey to take.

### The chapters, with filenames

| File | Title / subject |
|---|---|
| `00-lean-ml-survey.md` | Lean Machine Learning: A Survey (2022–2026) — the framing document |
| `01-lean4-float-and-spec-machinery.md` | lean4: Float, specs, codegen |
| `02-mathlib4-modular-and-geometry.md` | Mathlib4: modular & geometry, plus confirmed absences |
| `03-lean-ecosystem-pnt-cslib-physlib.md` | PNT, cslib, physlib |
| `04-landscape-lexicon-optimization-physics-ml.md` | Landscape: lexicon, optimization, differentiable physics, formal-math×ML |
| `05-actionable-for-hsln.md` | Actionable synthesis — the roadmap |
| `06-natural-language-lexicon-and-structure.md` | Natural-language lexicon & structure (3 corrections to `hsln.language`) |
| `07-category-theory-and-thinking-in-lean.md` | Category theory & thinking in Lean |
| `08-trained-dna-components-decoded.md` | The trained-DNA components, decoded — the Atom/basin analysis |
| `09-monoidal-path-of-spikes.md` | Monoidal path-of-spikes — the transition monoid |
| `10-categories-in-plain-words.md` | The categories in plain words — the best prose in the corpus |
| `11-calabi-yau-and-generator.md` | Calabi–Yau compactification & the image generator |
| `12-attention-dna-nano-gpt.md` | Attention is a DNA-fluid |
| `13-monadic-llm-lean4-mathlib.md` | Monadic LLMs over atom/lexicon proofs |
| `14-hsln-compact-llm-spec.md` | HSLN Compact LLM specification |

The shared index for all fifteen is the KnowledgeBase `README.md`.

### The chapters by function

| # | Chapter | What it contributes | Status of its content |
|---|---|---|---|
| 00 | Lean ML survey (2022–2026) | **The framing document**: where Lean and ML meet, and the claimed gap. Verdict: "Architecture is never derived from the Lean spec." | Survey — checkable, not verified here |
| 01 | lean4: Float, specs, codegen | `Float` non-opaque, `Nat.powMod`, transparency split, `mvcgen'`/`WP`, incremental elab caching | Tooling notes |
| 02 | Mathlib4: modular & geometry | Sturm bound, metric connections, Cartan posDef, Taylor integral remainder, resolvent transform — **plus confirmed absences** (Hecke/Siegel/theta/E8/Leech) | Tooling notes; the absences match what the audit found |
| 03 | Lean ecosystem | PNT, cslib, physlib — Navier–Stokes residual, Wirtinger calculus, Riemannian metric | Tooling notes |
| 04 | Landscape sweep | Lexicon/dictionary frameworks, manifold optimizers, differentiable fluids, post-AlphaProof formal-math×ML | Survey |
| 05 | **Actionable synthesis** | The de-duplicated "what to do" list, every item mapped to a file and tagged by leverage | **Agenda** — see §3 |
| 06 | Natural-language lexicon | DisCoCat/lambeq, WordNet hypernymy, ConceptNet's 34 relations, FrameNet valency→genus-2. Flags **3 corrections to `hsln.language`** | Design notes for the missing package |
| 07 | Category theory & thinking in Lean | Mathlib `CategoryTheory/` as substrate, backprop-as-functor, DisCoCat, LeanCat. Open niche: CT as the agent's *internal* substrate | Survey |
| 08 | **Trained-DNA components, decoded** | Empirical: each strand = an `Atom` = an irreducible `(q−r)` = a **basin-of-attraction detector**; the `\|F⊗G\|²=\|F\|²\|G\|²` landscape homomorphism | **Measured 2026-06-21 against `Python/hsln/` — not reproducible here** |
| 09 | Monoidal path-of-spikes | A **transition monoid** of trained closed-loop drives `δ_{a→b}`; a spike-path is the monoidal product; precompute an N×N library, then any path is O(k) | **Novel relative to the figures and Lean** — see §5 |
| 10 | Categories in plain words | The glossary: every category named in plain words *and* pinned to what it does to a spike. Answers "do all neurons fire at 1.0?" → yes, by construction | Plain-words layer; useful |
| 11 | Calabi–Yau & the image generator | Two functors: `Compactify` (Hanson quintic cross-section painted by the spike field; quintic residual `7.7e-17`) and a bounded generator flow `τ̇ = J∇E` (82–85% basin-stable) | **Novel relative to the figures and Lean** — see §5 |
| 12 | Attention is a DNA-fluid | Transformer/attention read through composable DNA monoids; the narrow checkable axiom `embedding ≡ DNA` | Analogy |
| 13 | Monadic LLMs over atom/lexicon proofs | A proof-carrying lexicon monad: **no hallucinated atoms** | **Realised in Lean** — see §5 |
| 14 | HSLN Compact LLM spec | Implementation spec for distilling GPT-like capability into an HSLN-native compact model | Spec |

---

## 2. What the KnowledgeBase gets right, and where it disagrees with the main corpus

### 2a. Three cross-checks that hold

1. **The spike score.** Chapter 10 says the score is `exp(−|F|²/2σ²)`, so "at a neuron the score is
   `exp(0) = 1`". `hsln.py:57` is exactly `jnp.exp(-mn ** 2 / (2 * SIGMA ** 2))`. ✔
2. **Composition preserves genus.** Chapter 10's `Tensor` composes within a genus; `hsln.py:76–77`
   asserts `a.genus == b.genus` and convolves the DNAs. ✔
3. **The Atom/Eval/Unit category structure.** Chapter 08's decomposition — one `Atom` per surviving
   neuron, `Eval` = the polynomial `F = Σθₙqⁿ`, `Unit` = `F = 1` — matches `dna.py`'s
   `dna_from_neurons` (which literally runs `np.poly(qs)`) and `render.py`'s usage. ✔

### 2b. One place the KnowledgeBase is *sharper* than the main corpus

Chapter 08 says "The tensor product is literal **basin union**." The main corpus' prose says the
same thing more loosely ("the merged network inherits every neuron of both parents"). The
architecture thread's measurement — **542 of 856 seeds (63.3%) re-route to a B-neuron under
`A ⊗ B`** — shows that *basin partition* is **not** preserved; only the **zero set** is.

So the KnowledgeBase's phrasing is better than the corpus' because "basin union" is *almost*
right and points at the right subtlety, whereas "inherits every neuron" hides it. Both need the
same correction, recorded in
[`architecture.md`](../02-threads/architecture.md) §5 and ledger row B7: **detection survives
composition; routing does not.**

### 2c. One place it is less careful

Chapter 05 tags items "**H** leverage" with a confidence the artefacts do not support. E.g.
"Fluid dynamics is metaphorical — single-particle ODE, no PDE solver. Add `hsln/fluids.py`: spectral
projection-method NS". That is a reasonable *plan*. But the same chapter's tone elsewhere implies
capabilities that were not built — and the package it targets does not exist (§4). The KB's
"Actionable" lists read as a roadmap, not a record, and should be read that way.

---

## 3. The KnowledgeBase's genre: an integration agenda

Chapter 05 is the clearest statement of what the whole corpus was *for*: each hsln component is
framed as "the modular-form version" of an active research line, so that the framework has five
concrete baselines and a positioning narrative:

| hsln component | The big-lab line it claims to instantiate |
|---|---|
| DNA lexicon (theta coefficients) | SAE-FNO functional representation |
| Optimizer | symmetry-compatible optimizer on modular-form parameters (group = modular group / Hecke algebra) |
| Spectral operator | CFO flow-matched operator + PILNO virtual inputs |
| Formal verification | DeepSeek-Prover-V2 / ATLAS over Lean formalizations of the modular lemmas |
| Reservoir | SARC spectral reservoir, with `periods` → modular weight/level |

**This is what the project was trying to be.** It is worth recording, because
`THE-STORY.md` and the threads describe the *mathematics*, and the mathematics was in service of
this: an argument that modular structure is the right inductive bias for composable learned
models, positioned against five specific 2026 baselines. Whether that argument succeeds is exactly
the question `system-spec.md` §5.6 says is decided by the zero-shot merge test — which is not run
anywhere (ledger row F9).

Chapter 04's verdict on the field is also worth quoting, because it is the claim the whole
project rests on:

> "**Verdict for Area 1:** SOTA is AlphaProof (medal-level IMO). The whole field treats Lean as the
> *ground-truth environment*; the NN policy/value networks are off-the-shelf transformers.
> **Architecture is never derived from the Lean spec.**"

And on its own positioning:

> "**The genuinely open niche** (empty as of 2026-06-21): category theory as the agent's *internal
> reasoning substrate* — not a target domain it reasons *about*, but the typed structure its own
> cognition runs on. Everything to build this exists; nobody has assembled it."

Both are *claims about the state of a field*, dated 2026-06-21 and unverifiable here. They are the
kind of claim that a literature check would settle in an afternoon.

---

## 4. The structural finding: a missing package

Every chapter from 05 onward references `Python/hsln/` modules:

```
hsln/algebra.py     hsln/fluids.py      hsln/train.py
hsln/paths.py       hsln/calabi_yau.py  hsln/category.py
hsln/generate.py    hsln/language.py    hsln/network.py
hsln/e8.py          hsln/dna_db.py      hsln/_backend.py
hsln/net.py (rollout)  Python/examples/showcase_ct_probe.py
Figures/ct_probe_findings.json
```

**None of these exist in the June files.** What exists is:

- `PythonAndVisualizations` — 79 standalone scripts, no package, no `hsln/` module, no `hsln`
  namespace. The scripts import each other as **flat modules** in one directory.
- `Math-Lean/` — the Lean corpus.
- `NumericalTesting/` — a separate package (`numericaltesting/numerics.py`), unrelated, with an
  **empty README**.

### Consequences

1. **Chapters 08–12's numbers cannot be reproduced here.** The 5.8% / 2.6% / 47.1% basin fractions,
   the 4-surviving-neurons-from-5-targets result, the quintic residual `7.7e-17`, the 82–85%
   basin-stability figure, the `ct_probe_findings.json` dump — all measured against code that is
   not in this workspace. They are **unverifiable**, which is a different status from
   **false**. They should be treated as leads.
2. **Two generations of the project exist in these files.** `PythonAndVisualizations` is a script
   collection exploring the *mathematics*. The KnowledgeBase describes a *packaged library* with an
   `hsln` namespace, a `dna_db`, a `launcher`, `Net`/`Network` classes, and example suites. The
   package is either elsewhere, was never committed, or predates/postdates this snapshot.
3. **This is the most valuable gap to close.** If the package exists on another machine, chapters
   08–12 become checkable and the "five baselines" positioning in chapter 05 becomes assessable.
   **If the package can be located, adding it is the single highest-value step for this audit.**

---

## 5. Where the KnowledgeBase contains something the rest does not

Three items are genuinely *new* relative to the figures and the Lean files, and each is worth
taking seriously on its own terms.

### 5a. The transition monoid (chapter 09)

A **`Segment`** `δ_{a→b}` is a short *trained closed-loop control* that routes neuron `a` to neuron
`b`, using `B(u) = clip(gain·(b − position))` — it homes to `b` and decays on arrival so the
landscape captures it cleanly. Segments compose by **temporal concatenation**, so a spike-path
`(n₀,…,n_k)` is one composed drive; precomputing the N×N library makes any path **O(k)**.

Why this matters: it is a *constructive* answer to a real limitation. The static flow can only
route inputs to nearest wells; a transition monoid can **steer** a particle through a chosen
*sequence* of wells, and the training cost is amortised. The Lean reading — "the free monoid on the
transition generators, quotiented by the captured-by-basin relation" — is the right one, and it is
a **syntactic monoid of a finite automaton**, which is a well-understood object.

This is not in `PythonAndVisualizations`, it is not in `Math-Lean/`, and it is not in
`math-connections.md`. It is the KnowledgeBase's one substantive *new mechanism*, and it is
plausibly the most interesting engineering idea in the corpus. It is also **entirely unverified
here** (no `paths.py`).

### 5b. Calabi–Yau compactification as a functor (chapter 11)

`Compactify : DNA-Cat → CY` sends a trained DNA to the **Hanson cross-section painted by that
DNA's spike field**, so neurons become bright marked points on the quintic. The chapter is explicit
that this is not new physics — "the *same* classical marbles-on-a-sheet picture, read through
another functor" — and reports the quintic constraint `Σz_k⁵ = 0` to `7.7e-17`.

Read precisely, this is a **visualisation functor** with a checkable constraint. As with the
E8/Coxeter projection in `hsln_e8_torsion_factor.py`, the surface is the *picture* and the
arithmetic is unchanged. The chapter says so ("Nothing here is new physics"), which is the right
framing.

The second half — a bounded generator flow `τ̇ = J∇E` giving an "image → palette-trained DNA →
semantically similar image stream" at 82–85% basin-stability — is a **speculation about
applications** with no artefact here.

### 5c. The monadic LLM, and it is real Lean (chapter 13)

Chapter 13's proof-carrying lexicon monad **does** exist, in
`Math-Lean/Math/HSLNMonadicLLM.lean` — 121 lines, **zero `sorry`s**, and it is one of the cleanest
files in the corpus:

```lean
def pure {L : Lexicon} (x : α) : Cook L α
def bind {L : Lexicon} (x : Cook L α) (f : α → Cook L β) : Cook L β
def emit {L : Lexicon} (a : Atom) (ha : a ∈ L.allowed) : Cook L Expr

/-- The invariant exposed as a theorem: cooked atoms are never hallucinated. -/
theorem no_hallucinated_atoms {L : Lexicon} (x : Cook L α) : ...
```

This is the best concrete realisation in the corpus of "category theory as the substrate" idea
from chapter 07: a monad whose **type enforces** that every emitted atom comes from the permitted
lexicon, so the no-hallucination property is a *theorem about the type*, not a loss term. It
compiles and it is `sorry`-free.

**This deserves more attention than it has received in the main threads.** It is small, it is
correct, and it is the one place where the corpus' "formal methods shape the architecture" ambition
actually produced working code with a real guarantee.

---

## 6. Chapter 10 — worth reading in full

Chapter 10 ("The categories in plain words") is the best *writing* in the corpus. It takes the
whole categorical apparatus and pins each piece to an operational effect on a spike:

| category | plain-words name | what it does to a spike |
|---|---|---|
| **Atom** | *a well* | a place the marble can settle and fire |
| **Eval** | *the cook-book* | makes the sheet whose dips are exactly the wells |
| **Unit `I`** | *the empty system* | never fires (no wells) |

and it answers the obvious objection before it is raised:

> "On 'all neurons fire at 1.0 — is that right?' **Yes, by construction.** A neuron is *defined* as
> a zero of the form, and the spike score is `exp(−|F|²/2σ²)`, so at a neuron the score is
> `exp(0)=1`. The variation that carries information is the *climb* from 0 up to 1 as the marble
> approaches a well, and *which* well it settles in — not the peak height, which is always 1."

That is exactly right. `math-connections.md` has no self-check of this kind, which is the main
reason its claims need the grading in the ledger. Chapter 10 is a good model for how the other
June files could state their claims.

---

## 7. Chapter-by-chapter routing to the main threads

| KB chapter | Read alongside |
|---|---|
| 00, 04, 07 | `00-index/THE-STORY.md` §7–8 (what the project was for) |
| 01, 02, 03 | `03-formal/formal-status.md` (mathlib version mismatch; **the absences in ch. 02 match what the audit found**) |
| 05 | `02-threads/training-and-dynamics.md` §10 (the missing experiment) |
| 06 | not covered elsewhere — language/lexicon design for the missing package |
| 08 | `02-threads/architecture.md` §5 (the Atom = zero = irreducible factor identity) |
| 09 | **new material** — no counterpart in the threads; see §5a |
| 10 | `02-threads/architecture.md` §4 (the dynamics, stated plainly) |
| 11 | **new material** — see §5b |
| 12 | `02-threads/discrete-and-crypto.md` Part III (the analogy family) |
| 13 | **`Math-Lean/Math/HSLNMonadicLLM.lean`** — the one file where the ambition lands |
| 14 | spec only; the compact-LLM target is not built |

---

## 8. Verdict on the KnowledgeBase

| Aspect | Assessment |
|---|---|
| **Citations** | Specific, dated, checkable. Unverified here, and the "nothing here is fabricated" claim should be treated as a testable lead. |
| **Chapters 01–04** | Genuinely useful as a tooling survey; chapter 02's list of mathlib *absences* (Hecke/Siegel/theta/E8/Leech) is consistent with what the HSLN Lean files had to build around. |
| **Chapter 05** | A roadmap, not a record. Read as intention. |
| **Chapter 10** | The best prose in the corpus. |
| **Chapters 08–12** | Contain **unverifiable** measurements (the package is absent) and **two genuine new ideas** (the transition monoid, the CY functor). |
| **Chapter 13** | Points at real, `sorry`-free Lean work that the main threads under-sold. |
| **Overall** | The KnowledgeBase is the corpus' **most useful non-mathematical artefact** and its **least verifiable**. Treat chapters 09, 11 and 13 as the parts worth pursuing. |

> **Next step.** Locate `Python/hsln/`. Chapters 08–12 depend entirely on it,
> and three of the corpus' most interesting claims (the basin fractions, the transition monoid, the
> generator flow) live only there. Everything else in this directory can be checked without it.

### Cross-references

- [`evidence-ledger.md`](../02-threads/evidence-ledger.md) — the graded claims
- [`a-scripts-and-families.md`](a-scripts-and-families.md) — the PythonAndVisualizations families
- [`../05-repro/README.md`](../05-repro/README.md) §4 — what could not be checked and why
