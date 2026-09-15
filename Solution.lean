/-
Copyright (c) 2026 Lasse Rempe. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lasse Rempe
-/

import ExpChaotic.Results

/-!
# Palomar solution: the exponential map is chaotic

This module imports the documented and proved public declarations from `ExpChaotic.Results`.
They have the same names, types, and definition bodies as the benchmarks in `Challenge.lean`.
Import `ExpChaotic` for ordinary library use. Challenge and solution are checked in separate
Lean environments, since the challenge intentionally declares the same names with proof holes.

Part of Lasse Rempe's formalisation of his paper with Shen,
"The Exponential Map is Chaotic: An Invitation to Transcendental Dynamics". The formalisation was carried out
with generative AI assistance including Microsoft 365 Copilot, Claude, and particularly ChatGPT.
The initial proof architecture uses John Harrison's HOL Light formalisation.
See `Challenge.lean` for the project attribution, review status, and paper coverage.
-/
