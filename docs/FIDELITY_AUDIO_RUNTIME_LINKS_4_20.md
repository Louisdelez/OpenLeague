# Fonctionnement audio — traçabilité V118

## SYS-16.2-01

Native ambient parent requests, creation-order update and deferred owner stop; pending request is not hardware playback. Queues actual Bevy PCM voice; queued spawn and sink state do not prove audible hardware output.

Limites : Whole-game event scheduling and all champion semantics remain open.

## SYS-16.2-02

Local deterministic three-media variation, not native shuffle/RNG.

Limites : Local R variant is not native selector; actual complete native selection integration remains open.

## SYS-16.2-03

Tracks finite bone world transforms in native coordinates; position tracking does not prove spatial mixing. Selected listener mask and source modes determine native distance; metric alone not audible spatial mix.

Limites : Finite position tracking and metric exist; native 3D panning and full audible spatial mix remain open.

## SYS-16.2-04

Local camera-focus attenuation gain0.20 distance2400; no native pan/falloff claim. Native spatial controls and attenuation provider component; no full device mixing qualification.

Limites : R gain is local; native attenuation component not proof of actual full device mix.

## SYS-16.2-05

Local six-voice budget is separate from native global limit setter. Native low16 input and signed priority setter; not proof of complete voice scheduling.

Limites : Local cap6 and native setter are distinct; complete native voice admission/virtualization integration remains open.

## SYS-16.2-06

Native ambient parent requests, creation-order update and deferred owner stop; pending request is not hardware playback. Native stop flags, sorted pending identity, configured handle release; actual caller map_audio_requests.

Limites : Logical deferred stops and local one-shot retirement do not qualify all looping owners.

## SYS-16.2-07

Paused R cast voices retire; no resume/replay of this cue.

Limites : R pause retires voice without resume; required native pause/resume policy remains open.

## SYS-16.2-08

Rejects events whose owner is not visible in canonical snapshot; bounded local presentation policy.

Limites : Canonical visible-owner gate is local subset; exhaustive native sound visibility semantics remain open.

## SYS-16.2-09

Queues actual Bevy PCM voice; queued spawn and sink state do not prove audible hardware output.

Limites : No current human listening or captured hardware audio evidence; no audible qualification.

## Contrôles

35 fichiers,114 contrôles de source,38 cas lecteur dont37 refus.21 tests Rust exécutés dans cette révision, preuves conservées. Aucun test matériel audio ni écoute. Aucun changement de code produit.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-16.2-01 | Native ambient parent requests, creation-order update and deferred owner stop; pending request is not hardware playback. Queues actual Bevy PCM voice; queued spawn and sink state do not prove audible hardware output. | Whole-game event scheduling and all champion semantics remain open. |
| SYS-16.2-02 | Local deterministic three-media variation, not native shuffle/RNG. | Local R variant is not native selector; actual complete native selection integration remains open. |
| SYS-16.2-03 | Tracks finite bone world transforms in native coordinates; position tracking does not prove spatial mixing. Selected listener mask and source modes determine native distance; metric alone not audible spatial mix. | Finite position tracking and metric exist; native 3D panning and full audible spatial mix remain open. |
| SYS-16.2-04 | Local camera-focus attenuation gain0.20 distance2400; no native pan/falloff claim. Native spatial controls and attenuation provider component; no full device mixing qualification. | R gain is local; native attenuation component not proof of actual full device mix. |
| SYS-16.2-05 | Local six-voice budget is separate from native global limit setter. Native low16 input and signed priority setter; not proof of complete voice scheduling. | Local cap6 and native setter are distinct; complete native voice admission/virtualization integration remains open. |
| SYS-16.2-06 | Native ambient parent requests, creation-order update and deferred owner stop; pending request is not hardware playback. Native stop flags, sorted pending identity, configured handle release; actual caller map_audio_requests. | Logical deferred stops and local one-shot retirement do not qualify all looping owners. |
| SYS-16.2-07 | Paused R cast voices retire; no resume/replay of this cue. | R pause retires voice without resume; required native pause/resume policy remains open. |
| SYS-16.2-08 | Rejects events whose owner is not visible in canonical snapshot; bounded local presentation policy. | Canonical visible-owner gate is local subset; exhaustive native sound visibility semantics remain open. |
| SYS-16.2-09 | Queues actual Bevy PCM voice; queued spawn and sink state do not prove audible hardware output. | No current human listening or captured hardware audio evidence; no audible qualification. |

Reçu : docs/reference_audio_runtime_sources/audio_runtime-links.json. Livraison : docs/fidelity_registry_audio_runtime_links_revision_4_20.json. Les neuf tâches et le Goal restent ouverts.
