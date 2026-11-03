# Reconnexion — traçabilité V139

## SYS-20.3-01

Resume validates recovery capability,session/player/epoch,nonce and owner liveness.

Limites : Historical authentication and all hostile runtime scenarios remain to qualify.

## SYS-20.3-02

Resume retains the existing Simulation player and rebuilds its delivery route.

Limites : All private ranks/resources/inventory fields and complete client restoration require coverage.

## SYS-20.3-03

Viewer-filtered atomic snapshot is the resumed state source.

Limites : All enemy visibility transitions and event audiences at reconnect require dedicated coverage.

## SYS-20.3-04

Monotone-time poll detaches silent peers while preserving their player.

Limites : Tick latency under load and real timeout behavior remain to measure.

## SYS-20.3-05

Detach removes route/clock recipient;retirement also removes player.

Limites : All connection-owned resources and teardown faults remain to qualify.

## SYS-20.3-06

Drain retires offline players;no bot replacement policy exists in this path.

Limites : Mode-specific bot replacement eligibility and behavior remain open.

687 fichiers,717 contrôles,29 cas dont28 refus.6 tests serveur contrôlés ;pas de reconnexion graphique réelle. Lecteur initial refusé :décompte7ancres hérité ;corrigé à6,initial conservé.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-20.3-01 | Resume validates recovery capability,session/player/epoch,nonce and owner liveness. | Historical authentication and all hostile runtime scenarios remain to qualify. |
| SYS-20.3-02 | Resume retains the existing Simulation player and rebuilds its delivery route. | All private ranks/resources/inventory fields and complete client restoration require coverage. |
| SYS-20.3-03 | Viewer-filtered atomic snapshot is the resumed state source. | All enemy visibility transitions and event audiences at reconnect require dedicated coverage. |
| SYS-20.3-04 | Monotone-time poll detaches silent peers while preserving their player. | Tick latency under load and real timeout behavior remain to measure. |
| SYS-20.3-05 | Detach removes route/clock recipient;retirement also removes player. | All connection-owned resources and teardown faults remain to qualify. |
| SYS-20.3-06 | Drain retires offline players;no bot replacement policy exists in this path. | Mode-specific bot replacement eligibility and behavior remain open. |

Reçu : docs/reference_reconnection_sources/reconnection-links.json. Livraison : docs/fidelity_registry_reconnection_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
