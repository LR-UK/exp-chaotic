/-
Copyright (c) 2026 Lasse Rempe. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lasse Rempe
-/

import ExpChaotic
import ExpChaotic.Development
import Solution

/-!
# Documentation and axiom audits

Run `lake build Audit`. Linter failures or unexpected axioms make this target fail.
The public root import is checked explicitly, and all declarations in the proof modules
are audited. `Challenge` is deliberately not
imported: its proof holes live in a separate environment from the solution.

Part of Lasse Rempe's formalisation of his paper with Shen,
"The Exponential Map is Chaotic: An Invitation to Transcendental Dynamics". The formalisation was carried out
with generative AI assistance including Microsoft 365 Copilot, Claude, and particularly ChatGPT.
The initial proof architecture uses John Harrison's HOL Light formalisation.
See `Challenge.lean` for the project attribution, review status, and paper coverage.
-/

#check ExpChaotic.juliaSet_exp
#check ExpChaotic.not_tendstoLocallyUniformlyOn_sphericalExpIterate
#check ExpChaotic.IsNormalSequenceOn
#check ExpChaotic.expansion_along_escaping_orbits

#lint docBlameThm in ExpChaotic
#lint docBlameThm in Solution

open Lean Batteries.Tactic.Lint in
run_elab do
  let permitted := #[`propext, `Classical.choice, `Quot.sound]
  let decls ← getDeclsInPackage `ExpChaotic
  for n in decls do
    let axioms ← collectAxioms n
    let unexpected := axioms.filter (!permitted.contains ·)
    unless unexpected.isEmpty do
      throwError "{n} depends on unexpected axioms: {unexpected}"
  logInfo m!"Axiom audit passed for {decls.size} declarations: only propext, Classical.choice, \
    and Quot.sound are permitted."
