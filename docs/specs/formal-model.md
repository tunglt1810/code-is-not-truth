# Formal Model Specification

## Problem

A common claim treats source code as the only source of truth for a software system. Under that view, source code and Git history replace specifications and Architecture Decision Records (ADRs). This specification gives a Lean 4 model that shows why both statements fail.

## Types and Definitions

The module [`CodeIsNotTruth.lean`](../../CodeIsNotTruth.lean) gives six definitions:

- `HasBug`: A predicate that compares a `code` function with a separate `spec` function.
- `Decision`: A record with an `implemented` behavior, a list of `rejected` behaviors, and a `constraint`.
- `RepoArtifact`: A record with the current `code` and the `gitHistory` of committed behaviors.
- `projectToRepo`: A function from `Decision` to `RepoArtifact` that loses `rejected` behaviors and the `constraint`.
- `Drifts`: A predicate that holds when a document is true before a code change and false after it.
- `CodeMirrorDoc`: A predicate that compares current source code with a fixed snapshot.

## Theorems

Every theorem in `CodeIsNotTruth` compiles with zero custom axioms:

1. `no_bug_if_code_is_truth`: `HasBug code code` is always false. Without a separate specification, a bug cannot exist.
2. `cannot_reconstruct_of_non_injective`: If a function maps two different inputs to one output, no left-inverse function exists.
3. `cannot_reconstruct_decision_from_repo`: No function can reconstruct every `Decision` from its `RepoArtifact`. Two different decisions can produce the same `code` and `gitHistory`.
4. `code_mirror_drifts_on_every_refactor`: Whenever `before` differs from `after`, `CodeMirrorDoc before` satisfies `Drifts`.
5. `adr_policy_inconsistent`: A policy that erases implemented ADRs and keeps all data that `RepoArtifact` loses produces `False`.

## Short-Lived ADRs and Permanent ADRs

A short-lived ADR acts as a `CodeMirrorDoc`. It copies the current structure of the source code into prose, so every refactor causes documentation drift.

A permanent ADR keeps external limits and rejected options. Those facts never enter `code` or `gitHistory`. Because `projectToRepo` loses them, a permanent ADR does not copy the source code.
