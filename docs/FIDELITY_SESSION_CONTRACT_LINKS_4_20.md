# Contrat launcher–partie — traçabilité V131

## SYS-18.6-01

Champion crosses launcher/environment/JoinRequest;server issues local session/player/epoch.

Limites : Historical account identity and complete selection mapping remain open.

## SYS-18.6-02

Native selectedSkinIndex exists;current JoinRequest has no skin or form selector.

Limites : Implement and qualify skin/authorized form transmission;do not equate skin index with global skin ID.

## SYS-18.6-03

Native rune/mastery DTOs exist;current JoinRequest contains neither page.

Limites : Page selection,authorization,serialization and application remain open.

## SYS-18.6-04

Two optional local summoner slots are transmitted;duplicates rejected before player creation.

Limites : Only five local spell variants;full historical availability and mandatory-slot policy remain open.

## SYS-18.6-05

Simulation balances teams,limits players to six,and uses Map10 spawn data.

Limites : Launcher does not send team,slot,map or mode;explicit full session selection remains open.

## SYS-18.6-06

Local version/nonce/bootstrap and replay mismatch refusal paths exist;13 CPU tests retained.

Limites : Complete historical launch contract compatibility and all missing-field policies remain open.

## SYS-18.6-07

Host routes contextual state to recipients;existing tests exercise local composition.

Limites : Six-client shared complete session contract is not verified by these tests;multi-client observation remains open.

1184 fichiers,2539 contrôles,32 cas dont31 refus.13 tests CPU :6 hôte,5 transport,2 bootstrap. Pas de six clients graphiques ni runtime historique.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-18.6-01 | Champion crosses launcher/environment/JoinRequest;server issues local session/player/epoch. | Historical account identity and complete selection mapping remain open. |
| SYS-18.6-02 | Native selectedSkinIndex exists;current JoinRequest has no skin or form selector. | Implement and qualify skin/authorized form transmission;do not equate skin index with global skin ID. |
| SYS-18.6-03 | Native rune/mastery DTOs exist;current JoinRequest contains neither page. | Page selection,authorization,serialization and application remain open. |
| SYS-18.6-04 | Two optional local summoner slots are transmitted;duplicates rejected before player creation. | Only five local spell variants;full historical availability and mandatory-slot policy remain open. |
| SYS-18.6-05 | Simulation balances teams,limits players to six,and uses Map10 spawn data. | Launcher does not send team,slot,map or mode;explicit full session selection remains open. |
| SYS-18.6-06 | Local version/nonce/bootstrap and replay mismatch refusal paths exist;13 CPU tests retained. | Complete historical launch contract compatibility and all missing-field policies remain open. |
| SYS-18.6-07 | Host routes contextual state to recipients;existing tests exercise local composition. | Six-client shared complete session contract is not verified by these tests;multi-client observation remains open. |

Reçu : docs/reference_session_contract_sources/session_contract-links.json. Livraison : docs/fidelity_registry_session_contract_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
