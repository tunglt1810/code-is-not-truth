# code-is-not-truth

A popular argument tells teams to erase specifications and Architecture Decision Records (ADRs) when software agents write code. Source code shows current behavior, while Git history tracks past edits. Everything else supposedly drifts and wastes context tokens.

That argument fails under formal logic. Lean 4 proves why in 71 lines of code, with zero custom axioms.

Suppose a payment worker caps batches at 50 rows because an external gateway stops larger payloads after 30 seconds. The source code only shows `batchSize = 50`. Git blame points to a two-year-old commit. But neither artifact keeps the 30-second gateway limit or the two retry designs that failed in load tests.

Engineers blame ADRs for documentation drift because they write bad ADRs. A short-lived ADR copies the current module layout into prose, so every refactor makes it false. A permanent ADR keeps external limits and rejected options that never enter the source code.

## What Lean 4 Proves

The module [`CodeIsNotTruth.lean`](CodeIsNotTruth.lean) proves five theorems:

- `no_bug_if_code_is_truth`: If source code equals the specification, `HasBug code code` is always false. You cannot define a bug without a separate specification.
- `cannot_reconstruct_of_non_injective`: When a function maps two different inputs to one output, no function can reconstruct every input.
- `cannot_reconstruct_decision_from_repo`: Two different decisions can produce the same `code` and `gitHistory`. No software agent can reconstruct lost limits or rejected options from repository files alone.
- `code_mirror_drifts_on_every_refactor`: Any document that copies current source code (`CodeMirrorDoc`) becomes false on every refactor. Drift comes from copied code structure, while permanent ADRs keep facts outside the source code.
- `adr_policy_inconsistent`: A policy cannot erase implemented ADRs and also keep all facts that source code and Git history lose. Those two rules produce `False`.

The file [`docs/specs/formal-model.md`](docs/specs/formal-model.md) gives the formal specification for each type and theorem.

## Repository Files

- `CodeIsNotTruth.lean`: Lean 4 definitions and formal proofs.
- `docs/specs/formal-model.md`: Specification of the formal model and its theorems.
- `lakefile.toml`: Package configuration for Lake.
- `lake-manifest.json`: Lock file for Lake packages.
- `lean-toolchain`: Version identifier for the Lean 4 compiler.

## Compile the Proofs

1. If Lean 4 is not on your computer, install `elan` from <https://lean-lang.org>.
2. Clone this repository.
3. Open a terminal in the repository root.
4. Compile the proofs with `lake build`.
5. Make sure that the command gives zero errors.
