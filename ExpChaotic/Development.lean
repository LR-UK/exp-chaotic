/-
Copyright (c) 2026 Lasse Rempe. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lasse Rempe
-/

import ExpChaotic.Normality
import ExpChaotic.PaperConsequences
import ExpChaotic.Spherical

/-!
# Complete exponential-map development

Compatibility entry point for the former single-file proof. The development declarations
use `ExponentialJuliaSetMisiurewicz`. `Normality` defines normal sequences of maps into
arbitrary uniform spaces and specializes the Fatou set to sphere-valued iterates.

The proof is organized into `Basic`, `Expansion`, `StripGeometry`, `HalfPlane`, `RealAxis`,
`Normality`, `Covering`, `Periodic`, `Dynamics`, `Spherical`, and `PaperConsequences`.
Run `lake build Audit`
for the linter and axiom audits.

Part of Lasse Rempe's formalisation of Shen and Rempe-Gillen's exponential-map paper,
with generative AI assistance including Copilot, Claude, and particularly ChatGPT.
The initial proof architecture uses John Harrison's HOL Light formalisation.
See `Challenge.lean` for the project attribution, review status, and paper coverage.
-/
