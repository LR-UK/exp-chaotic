# The exponential map is chaotic

This Lean 4 project formalises the main results of the paper by Shen and
Rempe-Gillen, *The Exponential Map Is Chaotic: An Invitation to
Transcendental Dynamics* and Misiurewicz's theorem that the Julia set of the
complex exponential is the whole plane (of which the aforementioned paper gave a new proof).

The formalisation was carried out with the help of generative AI, including
Microsoft 365 Copilot, Claude Opus 5 and, particularly, ChatGPT (GPT-5.6 Sol and GPT-6 Astra).
Preparation for submission to GitHub and Palomar was also assisted by ChatGPT.

The principal sources for the formalisation—which was mostly carried out autonomously by AI
tools, with guidance from the author—were the paper above and, for the density of the escaping
set, an existing formalisation of Misiurewicz's original proof in HOL Light. The latter was
written by John Harrison in 2014 in response to a challenge posed by the author on the FOM
(Foundations of Mathematics) mailing list and communicated to Harrison by Freek Wiedijk.

Links:
* [The original challenge](https://fomarchive.ugent.be/2014-October/018293.html)
* [The announcement of Harrison's formalisation](https://fomarchive.ugent.be/2014-November/018390.html)


## Checked results

The public statement surface is [`Challenge.lean`](Challenge.lean). The documented proofs are in
[`ExpChaotic/Results.lean`](ExpChaotic/Results.lean), imported by both
[`Solution.lean`](Solution.lean) and the library root [`ExpChaotic.lean`](ExpChaotic.lean).

The project proves:

- every sufficiently late image of a nonempty open set contains every prescribed
  compact subset of `ℂ \ {0}` (Corollary 5.5);
- the full iterated preimage of the real axis is dense;
- infinitely many iterated images of every nonempty open set meet the negative
  real axis (Theorem 4.3); in fact, every sufficiently late image does;
- the full iterated preimage of every nonzero point is dense;
- escaping points are dense (Theorem 4.1);
- along any escaping orbit, the real parts and the derivative norms of the iterates
  tend to positive infinity (Observation 5.2);
- points with dense forward orbit are dense and form an uncountable set
  (Corollary 5.6);
- repelling periodic points, hence periodic points, are dense (Theorem 6.1);
- the exponential is topologically transitive and chaotic in Devaney's sense
  (Theorem 1.2);
- the iterates, viewed as maps from the Euclidean plane to the Riemann sphere, are
  not equicontinuous at any point, and spherical sensitive dependence holds
  (Corollary 4.4);
- the explicit sensitivity condition of Definition 2.3 holds for every positive
  pair of constants, at every sufficiently late time (also giving Exercise 8.7);
- the locally defined Fatou set is empty and the Julia set is all of `ℂ`
  (Misiurewicz's theorem);
- no strictly increasing subsequence of the iterates converges locally uniformly
  in the spherical uniformity on any nonempty open set, to any sphere-valued
  function defined on that open set. This directly rules out normality of the
  sphere-valued iterates.

Thus all three clauses of the paper's Theorem 1.1 and its Theorem 1.2 are present.
The appendix/outlook and the remaining exercises are not formalised.

## Build

Install Lean with `elan`, then run from this directory:

```text
lake exe cache get
lake build
lake env lean --run scripts/CheckStatements.lean
```

The project pins Lean 4.34.0 and Mathlib commit
`7801e8406155c31b340d28e2762f754d02b5e9b0`. On Windows, keeping the checkout
outside Dropbox or excluding `.lake` from synchronisation avoids file-locking and
cross-device cache conflicts. Administrator privileges are not normally required for
a per-user `elan` installation.

The committed manifest pins dependencies; `lake update` is only needed when
deliberately updating them. `lake build` includes the `Audit` target, which checks
documentation and allowed axioms. The separate interface check compares all twelve
definition bodies and fifteen theorem types from `comparator.json` in distinct Lean
environments. The revised challenge includes the new paper consequences and the
spherical no-limit theorem with a domain-restricted limit function.

For independent Comparator/NanoDa verification on Linux, run
`./scripts/verify-comparator.sh`. This also requires Rust/Cargo, Go, Git, and Python.
The GitHub workflow runs it separately from the ordinary Lean checks. A successful
local Lean build and interface comparison are not a claim that this external
verification has run successfully; that end-to-end run remains outstanding.

## Library use and proof organisation

```lean
import ExpChaotic

#check ExpChaotic.juliaSet_exp
#check ExpChaotic.not_tendstoLocallyUniformlyOn_sphericalExpIterate
```

The modules use the development namespace `ExponentialJuliaSetMisiurewicz`.
The public results use `ExpChaotic`. `IsNormalSequenceOn` is polymorphic in both
domain and codomain and uses Mathlib's locally uniform convergence directly.

| Module | Contents |
| --- | --- |
| `Basic` | Iteration and elementary derivatives |
| `Expansion` | Lemmas 1–3: growth and quantitative open mapping |
| `StripGeometry` | Lemmas 4–5: connected images and strip geometry |
| `HalfPlane` | Cauchy bounds and Cayley transforms |
| `RealAxis` | Lemma 6: every domain eventually meets the real axis |
| `Covering` | Eventual compact covering and backward-orbit density |
| `Periodic` | Contracting inverse branches and repelling periodic points |
| `Dynamics` | Escaping points, dense orbits, and Devaney chaos |
| `Normality` | Normal sequences in uniform spaces, restriction, and the Julia theorem |
| `Spherical` | Non-equicontinuity, non-normality, and sensitivity |
| `PaperConsequences` | Theorem 4.3, precise sensitivity, and Observation 5.2 |
| `Results` | Documented public benchmark interface |

`ExpChaotic.Development` remains a compatibility import for the complete
development. For ordinary library use, prefer `import ExpChaotic`. 
`Challenge` and `Solution` must be imported in separate
environments because they intentionally declare the same names.

## Definitions and trust

Mathlib supplies `EquicontinuousAt`, and the spherical theorem uses the one-point
compactification of `ℂ` without assigning a value to the exponential at infinity. The
domain of every iterate remains the Euclidean plane.

Mathlib provides `TendstoUniformly`, `TendstoUniformlyOn`, `TendstoLocallyUniformly`,
and `TendstoLocallyUniformlyOn`. The general definition
`IsNormalSequenceOn F U` says that every subsequence has a further subsequence
converging locally uniformly on the subtype `U` to some function `U → β`, where
the domain carries a topology and `β` carries a uniform structure. It assumes
neither openness nor holomorphy. Normality restricts to arbitrary subsets.

For the Fatou set, `U` is required to be open and `F n` is the `n`-th iterate,
included from `ℂ` into the Riemann sphere. Thus finite limits, meromorphic limits
with poles, and the constant infinity limit are all treated uniformly as functions
`U → RiemannSphere`. Classical complex analysis can classify locally uniform
spherical limits of holomorphic or meromorphic functions, but that theorem is not
needed here. The direct no-limit theorem excludes every sphere-valued candidate.
The file also characterises Fatou-set membership using open discs.

The theorem `ExpChaotic.not_tendstoLocallyUniformly_sphericalExpIterate` uses
Mathlib's `TendstoLocallyUniformly` with the sphere as codomain and `U` as domain.
Its proof uses continuity of locally uniform limits and eventual point covering:
on a small neighbourhood, a hypothetical limit would force the images of every
nonzero target to equal the same limit value. The distinct targets `1` and `2`
contradict this. The Julia theorem applies this obstruction directly on the open
neighbourhood from the Fatou-set definition. The ambient-domain version remains available as
`ExpChaotic.not_tendstoLocallyUniformlyOn_sphericalExpIterate`.

The precise inverse-branch assertions of Proposition 5.3 and Lemma 6.2, and the
radius-`2π` arbitrary-centre formulation of Observation 5.4, remain outside the
challenge. The implementation has related inverse branches and a radius-8
real-centred covering estimate sufficient for the main theorems. The hyperbolic
metric preliminaries are also outside the challenge, apart from Schwarz's lemma
already supplied by Mathlib.

The solution contains no `sorry` and uses only Lean's standard axioms `propext`,
`Classical.choice`, and `Quot.sound`. The deliberate `sorry`s in `Challenge.lean`
are the statement holes expected by Palomar and are excluded from that count.

## References

- Zhaiming Shen and Lasse Rempe-Gillen, “The Exponential Map Is Chaotic: An
  Invitation to Transcendental Dynamics”, *American Mathematical Monthly* 122
  (2015), 919–940, [arXiv:1408.1129](https://arxiv.org/abs/1408.1129),
  [doi:10.4169/amer.math.monthly.122.10.919](https://doi.org/10.4169/amer.math.monthly.122.10.919).
- Michał Misiurewicz, “On iterates of e^z”, *Ergodic Theory and Dynamical
  Systems* 1 (1981), 103–106.
- John Harrison, [`Examples/misiurewicz.ml`](https://github.com/jrh13/hol-light/blob/master/Examples/misiurewicz.ml),
  HOL Light.

## Licence

Apache License 2.0. See [`LICENSE`](LICENSE).
