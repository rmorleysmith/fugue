# Fugue

The audit of the June 2026 HSLN files: every idea, figure and numerical claim in them, stated
precisely and graded by the evidence behind it. Start with [`Fugue/README.md`](Fugue/README.md).

## The repositories

| Repository | What it holds |
|---|---|
| [hsln-archive](https://github.com/rmorleysmith/hsln-archive) | The June 2026 files, unchanged, with OpenTimestamps proofs anchored in Bitcoin and the May 2026 git history. DOI [10.5281/zenodo.23690426](https://doi.org/10.5281/zenodo.23690426). |
| [fugue](https://github.com/rmorleysmith/fugue) (this one) | The audit: graded evidence ledger, thematic threads, reproductions. |
| [fugue-exploration](https://github.com/rmorleysmith/fugue-exploration) | The June scripts, tidied: every figure regenerated, every script headed by what it computes, proves and does not claim. |
| [fugue-formal](https://github.com/rmorleysmith/fugue-formal) | The Lean 4 / Mathlib formalisation of the parts that hold: 103 audited theorems, no `sorry`. DOI [10.5281/zenodo.23695018](https://doi.org/10.5281/zenodo.23695018). |
| [fugue-formal-pnt](https://github.com/rmorleysmith/fugue-formal-pnt) | Ingham's theorem: zero-free regions of ζ and the error term in ψ(x). DOI [10.5281/zenodo.23695021](https://doi.org/10.5281/zenodo.23695021). |
| [palomar-ingham](https://github.com/rmorleysmith/palomar-ingham) | Two entries prepared for the Palomar registry of Lean-verified results. |

## How AI was used

The ideas in this work are Richard Morley-Smith's: the questions, the links between areas of
mathematics, and the choices of what to pursue. AI was used as a tool, in two phases.

- **May–June 2026, the original exploration.** The exploration was carried out in conversation
  with AI coding assistants, chiefly Anthropic's Claude through Claude Code (the design document
  also quotes Google's Gemini). The assistants wrote most of the code, Lean files and documents
  from the author's ideas and direction, quickly and without later editing. Those files are kept
  unchanged in [hsln-archive](https://github.com/rmorleysmith/hsln-archive).
- **October 2026 onwards.** Claude, through Claude Code, helps the author formalise the ideas in
  Lean 4, audit and tidy the earlier files, and write out the working: the steps between an
  intuition and a precise statement. This audit was written that way.

Checking the results does not rely on trusting the AI. Every Lean theorem is verified by the
Lean kernel against Mathlib, and `#print axioms` shows only Lean's three standard axioms. Every
script asserts the numbers it reports and can be rerun. Every grade in the audit cites the
evidence it rests on.

## Licence

Code: Apache-2.0. Text and figures: CC-BY-4.0.
