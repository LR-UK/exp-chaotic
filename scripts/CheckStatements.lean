/-
Copyright (c) 2026 Lasse Rempe. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lasse Rempe
-/

import Lean

/-!
# Compare the elaborated challenge and solution interfaces

Run `lake env lean --run scripts/CheckStatements.lean` after building the project.
The names come from `comparator.json`. Definition bodies, declaration types, and universe
parameters must match structurally in separate environments. This fast local check complements
the external Comparator/NanoDa workflow; it does not replace independent kernel replay.

Part of Lasse Rempe's formalisation of Shen and Rempe-Gillen's exponential-map paper,
with generative AI assistance including Microsoft 365 Copilot, Claude, and particularly ChatGPT.
The initial proof architecture uses John Harrison's HOL Light formalisation.
See `Challenge.lean` for the project attribution, review status, and paper coverage.
-/

open Lean

/-- Check every configured benchmark and definition in two separate Lean environments. -/
def main : IO Unit := do
  initSearchPath (← findSysroot)
  let config ← IO.ofExcept <| Json.parse (← IO.FS.readFile "comparator.json")
  let challengeModule ← IO.ofExcept <| config.getObjValAs? String "challenge_module"
  let solutionModule ← IO.ofExcept <| config.getObjValAs? String "solution_module"
  let definitions ← IO.ofExcept <| config.getObjValAs? (Array String) "definition_names"
  let theorems ← IO.ofExcept <| config.getObjValAs? (Array String) "theorem_names"
  let challengeEnv ← importModules #[{ module := challengeModule.toName }] {}
  let solutionEnv ← importModules #[{ module := solutionModule.toName }] {}
  for name in definitions ++ theorems do
    let n := name.toName
    let some c := challengeEnv.find? n
      | throw <| IO.userError s!"Missing challenge declaration: {n}"
    let some s := solutionEnv.find? n
      | throw <| IO.userError s!"Missing solution declaration: {n}"
    unless c.levelParams == s.levelParams && c.type == s.type do
      throw <| IO.userError s!"Declaration type or universe mismatch: {n}"
    if definitions.contains name then
      unless c.value?.isSome && c.value? == s.value? do
        throw <| IO.userError s!"Definition body mismatch: {n}"
  IO.println s!"Interface audit passed: {definitions.size} definition bodies and \
    {theorems.size} theorem types match structurally."
