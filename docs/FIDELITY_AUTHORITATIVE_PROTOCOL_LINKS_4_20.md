# Protocole autoritaire local — traçabilité V137

## SYS-20.1-01

Local JSON session VERSION=1 exists;OLSR framing has explicit context and ordinal.

Limites : Version migration and all schemas remain to qualify;not historical wire compatibility.

## SYS-20.1-02

Server rejects unsupported local input version before state changes.

Limites : All legacy and session message entry points require complete coverage.

## SYS-20.1-03

Server validates context,capability,peer and liveness before command dispatch.

Limites : Per-command ownership/audience and account identity remain separately scoped.

## SYS-20.1-04

Sequence must exceed the last accepted value;replays are refused.

Limites : This strict monotonic local policy is not an inferred native replay-window algorithm.

## SYS-20.1-05

Authoritative Simulation.command dispatch applies feature-specific validation.

Limites : All commands/ranges/resources require feature-level coverage;registry tests do not prove them.

## SYS-20.1-06

Server schedules snapshots at100ms intervals under catchup/pause conditions.

Limites : Actual cadence,jitter and saturation must be measured;source constant is not observed network timing.

## SYS-20.1-07

Host publishes contextual state per recipient.

Limites : Every public/private event and visibility audience remains to qualify.

## SYS-20.1-08

OLSR sender binds session/player/epoch and rejects mismatched snapshot session.

Limites : Complete reconnect/context-change rendering and historical behavior remain open.

687 fichiers,724 contrôles,35 cas dont34 refus.14 tests distincts dans2 binaires :28 exécutions. Pas de mesure réseau ni compatibilité historique déduite.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-20.1-01 | Local JSON session VERSION=1 exists;OLSR framing has explicit context and ordinal. | Version migration and all schemas remain to qualify;not historical wire compatibility. |
| SYS-20.1-02 | Server rejects unsupported local input version before state changes. | All legacy and session message entry points require complete coverage. |
| SYS-20.1-03 | Server validates context,capability,peer and liveness before command dispatch. | Per-command ownership/audience and account identity remain separately scoped. |
| SYS-20.1-04 | Sequence must exceed the last accepted value;replays are refused. | This strict monotonic local policy is not an inferred native replay-window algorithm. |
| SYS-20.1-05 | Authoritative Simulation.command dispatch applies feature-specific validation. | All commands/ranges/resources require feature-level coverage;registry tests do not prove them. |
| SYS-20.1-06 | Server schedules snapshots at100ms intervals under catchup/pause conditions. | Actual cadence,jitter and saturation must be measured;source constant is not observed network timing. |
| SYS-20.1-07 | Host publishes contextual state per recipient. | Every public/private event and visibility audience remains to qualify. |
| SYS-20.1-08 | OLSR sender binds session/player/epoch and rejects mismatched snapshot session. | Complete reconnect/context-change rendering and historical behavior remain open. |

Reçu : docs/reference_authoritative_protocol_sources/authoritative_protocol-links.json. Livraison : docs/fidelity_registry_authoritative_protocol_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
