# Synchronisation réseau — traçabilité V138

## SYS-20.2-01

Received positions directly drive transforms;buffered interpolation not established.

Limites : Implement and qualify snapshot interpolation without leaking hidden entities.

## SYS-20.2-02

Receive consumes authoritative snapshots and retires invalid context.

Limites : Complete local divergence reconciliation still requires dedicated coverage.

## SYS-20.2-03

Local session retry and silence handling exists.

Limites : General gameplay loss policy and bounded impairment behavior remain to qualify.

## SYS-20.2-04

Assembler admits ordered ordinals and out-of-order fragments within current frame.

Limites : Complete network reorder behavior across all message classes remains open.

## SYS-20.2-05

Identical duplicate fragments are safe;conflicting duplicates poison frame.

Limites : Exactly-once effects for all event types require separate qualification.

## SYS-20.2-06

Frame size bounded at1MiB and datagrams constructed at1200bytes.

Limites : Full transport/legacy/adversarial boundary coverage remains open.

## SYS-20.2-07

Receive loop caps datagrams at512 per invocation.

Limites : All send/receive queues and saturation/backpressure policies remain unqualified.

## SYS-20.2-08

last_received Instant tracks liveness.

Limites : No measured RTT/jitter estimator identified in this consumer.

681 fichiers,716 contrôles,35 cas dont34 refus.4 tests de fragmentation ;aucune mesure de latence/gigue ni session réseau perturbée exécutée.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-20.2-01 | Received positions directly drive transforms;buffered interpolation not established. | Implement and qualify snapshot interpolation without leaking hidden entities. |
| SYS-20.2-02 | Receive consumes authoritative snapshots and retires invalid context. | Complete local divergence reconciliation still requires dedicated coverage. |
| SYS-20.2-03 | Local session retry and silence handling exists. | General gameplay loss policy and bounded impairment behavior remain to qualify. |
| SYS-20.2-04 | Assembler admits ordered ordinals and out-of-order fragments within current frame. | Complete network reorder behavior across all message classes remains open. |
| SYS-20.2-05 | Identical duplicate fragments are safe;conflicting duplicates poison frame. | Exactly-once effects for all event types require separate qualification. |
| SYS-20.2-06 | Frame size bounded at1MiB and datagrams constructed at1200bytes. | Full transport/legacy/adversarial boundary coverage remains open. |
| SYS-20.2-07 | Receive loop caps datagrams at512 per invocation. | All send/receive queues and saturation/backpressure policies remain unqualified. |
| SYS-20.2-08 | last_received Instant tracks liveness. | No measured RTT/jitter estimator identified in this consumer. |

Reçu : docs/reference_network_sync_sources/network_sync-links.json. Livraison : docs/fidelity_registry_network_sync_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
