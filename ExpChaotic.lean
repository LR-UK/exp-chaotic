/-
Copyright (c) 2026 Lasse Rempe. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lasse Rempe
-/

import ExpChaotic.Results

/-!
# The exponential map is chaotic

This root module exposes the documented public theorems in the `ExpChaotic` namespace,
including `ExpChaotic.juliaSet_exp` and the spherical non-normality theorem. It also imports
their proof development.

Part of Lasse Rempe's formalisation of his paper with Shen,
"The Exponential Map is Chaotic: An Invitation to Transcendental Dynamics". The formalisation was carried out
with generative AI assistance including Microsoft 365 Copilot, Claude, and particularly ChatGPT.
The initial proof architecture uses John Harrison's HOL Light formalisation.
See `Challenge.lean` for the project attribution, review status, and paper coverage.
-/
