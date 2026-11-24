namespace CodeIsNotTruth

def HasBug {Input Output : Type} (spec code : Input → Output) : Prop :=
  ∃ x, code x ≠ spec x

theorem no_bug_if_code_is_truth {Input Output : Type} (code : Input → Output) :
    ¬ HasBug code code :=
  fun ⟨_, h⟩ => h rfl

structure Decision (Behavior Constraint : Type) where
  implemented : Behavior
  rejected : List Behavior
  constraint : Constraint

structure RepoArtifact (Behavior : Type) where
  code : Behavior
  gitHistory : List Behavior

def projectToRepo {Behavior Constraint : Type}
    (commits : Behavior → List Behavior)
    (d : Decision Behavior Constraint) : RepoArtifact Behavior :=
  { code := d.implemented, gitHistory := commits d.implemented }

theorem cannot_reconstruct_of_non_injective
    {α β : Type}
    (project : α → β)
    (h_lossy : ∃ x₁ x₂, x₁ ≠ x₂ ∧ project x₁ = project x₂) :
    ¬ ∃ reconstruct : β → α, ∀ x, reconstruct (project x) = x := by
  rintro ⟨reconstruct, h_inv⟩
  rcases h_lossy with ⟨x₁, x₂, h_neq, h_eq⟩
  apply h_neq
  calc
    x₁ = reconstruct (project x₁) := (h_inv x₁).symm
    _  = reconstruct (project x₂) := congrArg reconstruct h_eq
    _  = x₂                       := h_inv x₂

theorem cannot_reconstruct_decision_from_repo
    {Behavior Constraint : Type}
    (b alt : Behavior)
    (c : Constraint)
    (commits : Behavior → List Behavior) :
    ¬ ∃ reconstruct : RepoArtifact Behavior → Decision Behavior Constraint,
        ∀ d, reconstruct (projectToRepo commits d) = d := by
  apply cannot_reconstruct_of_non_injective (projectToRepo commits)
  refine ⟨⟨b, [], c⟩, ⟨b, [alt], c⟩, ?_, rfl⟩
  intro h
  injection h with _ h_rej _
  cases h_rej

def Drifts {Code : Type} (doc : Code → Prop) (before after : Code) : Prop :=
  doc before ∧ ¬ doc after

def CodeMirrorDoc {Code : Type} (snapshot : Code) (current : Code) : Prop :=
  current = snapshot

theorem code_mirror_drifts_on_every_refactor
    {Code : Type} (before after : Code) (h_change : before ≠ after) :
    Drifts (CodeMirrorDoc before) before after :=
  ⟨rfl, fun h_eq => h_change h_eq.symm⟩

theorem adr_policy_inconsistent
    {Doc : Type}
    (IsADR IsImplemented Recoverable Keep : Doc → Prop)
    (h_erase_adr : ∀ d, IsADR d → IsImplemented d → ¬ Keep d)
    (h_keep_lost : ∀ d, ¬ Recoverable d → Keep d)
    (h_permanent_adr : ∃ d, IsADR d ∧ IsImplemented d ∧ ¬ Recoverable d) :
    False := by
  rcases h_permanent_adr with ⟨d, h_adr, h_impl, h_lost⟩
  exact h_erase_adr d h_adr h_impl (h_keep_lost d h_lost)

end CodeIsNotTruth
