#!/usr/bin/env bash
# Reproduce the version-drift finding: HSLNAlgebra compiles against mathlib v4.30.0-rc2
# (the version the corpus claims) but not against the pinned v4.35.0-rc4.
#
# This is destructive (it fetches ~7 GB of mathlib and rebuilds it) and slow (~1 h here).
# The result is recorded in 03-formal/formal-status.md §6.
set -euo pipefail
ALT=/home/rms/Math/Fugue/.work/mathlib-old
rm -rf "$ALT"; mkdir -p "$ALT/Fugue"
cd "$ALT"
echo "leanprover/lean4:v4.30.0-rc2" > lean-toolchain
cp /home/rms/Math/Math-Lean/Math/HSLNAlgebra.lean Fugue/
echo 'import Fugue.HSLNAlgebra' > Fugue.lean
cat > lakefile.toml <<'TOML'
name = "altcheck"
version = "0.1.0"
defaultTargets = ["Fugue"]
[leanOptions]
pp.unicode.fun = true
relaxedAutoImplicit = false
maxSynthPendingDepth = 3
[[require]]
name = "mathlib"
scope = "leanprover-community"
rev = "v4.30.0-rc2"
[[lean_lib]]
name = "Fugue"
TOML
lake build
echo
echo "If this printed 'Build completed successfully', the drift hypothesis is confirmed."
