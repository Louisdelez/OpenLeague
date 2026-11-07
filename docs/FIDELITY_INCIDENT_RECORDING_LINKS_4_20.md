# Enregistrement des incidents — traçabilité V144

V144 incident recording:six requirements,six boundary roles.41 source pins,65 checks,29 reader cases including28 refusals. Public metadata,fixture event journal,immutable result and native diagnostic logger are distinct from deterministic match replay. No Rust tests or game execution this revision;integrity,quotas,complete inputs and finalization remain open.

## SYS-21.3-01

Command sender returns public metadata;no authoritative tick/seed/assets manifest is persisted by this branch.

Limites : Server admission tick,seed,versions and resource manifest must be captured with actual accepted commands.

## SYS-21.3-02

Fixture event journal stores elapsed wall clock and selected command/state summaries;not all deterministic inputs.

Limites : Define incident event completeness and privacy;qualify reproduction from ordinary runtime records.

## SYS-21.3-03

Immutable result writer compares existing bytes,not replay integrity validation before playback.

Limites : Validate format,lengths,integrity and exact dependencies before replay.

## SYS-21.3-04

Native service attaches ownership to audio runtime;this consumer is not a deterministic Simulation replay entry.

Limites : Connect versioned recorded inputs to deterministic Simulation replay and compare state/events.

## SYS-21.3-05

Native diagnostic message buffer is bounded;this is not a total recording storage quota or truncated replay parser.

Limites : Implement recording quotas and explicit truncated-file outcomes.

## SYS-21.3-06

Windows diagnostic FILE closes on Drop;not a complete match recording finalization contract.

Limites : Finalize and flush the authoritative recording with terminal status on every session exit path.

Dix-neuf empreintes de sources du reçu historique comparées : douze identiques, sept différentes. Les anciennes preuves restent conservées ; elles ne qualifient pas les fichiers actuels qui divergent. Les conclusions sont limitées aux chemins inspectés.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-21.3-01 | Command sender returns public metadata;no authoritative tick/seed/assets manifest is persisted by this branch. | Server admission tick,seed,versions and resource manifest must be captured with actual accepted commands. |
| SYS-21.3-02 | Fixture event journal stores elapsed wall clock and selected command/state summaries;not all deterministic inputs. | Define incident event completeness and privacy;qualify reproduction from ordinary runtime records. |
| SYS-21.3-03 | Immutable result writer compares existing bytes,not replay integrity validation before playback. | Validate format,lengths,integrity and exact dependencies before replay. |
| SYS-21.3-04 | Native service attaches ownership to audio runtime;this consumer is not a deterministic Simulation replay entry. | Connect versioned recorded inputs to deterministic Simulation replay and compare state/events. |
| SYS-21.3-05 | Native diagnostic message buffer is bounded;this is not a total recording storage quota or truncated replay parser. | Implement recording quotas and explicit truncated-file outcomes. |
| SYS-21.3-06 | Windows diagnostic FILE closes on Drop;not a complete match recording finalization contract. | Finalize and flush the authoritative recording with terminal status on every session exit path. |

Reçu : docs/reference_incident_recording_sources/incident_recording-links.json. Livraison : docs/fidelity_registry_incident_recording_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
