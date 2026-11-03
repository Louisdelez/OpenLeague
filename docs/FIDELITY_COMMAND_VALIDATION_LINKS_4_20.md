# Validation des commandes — traçabilité V140

## SYS-20.4-01

Session input validates context,capability and peer before dispatch.

Limites : Complete hostile identity scenarios across all entry paths remain to qualify.

## SYS-20.4-02

Cast dispatch checks learned ranks and state for implemented champion paths.

Limites : Every champion,resource and cast path still requires native-specific coverage.

## SYS-20.4-03

Server purchase validates admission and quote before inventory mutation.

Limites : All zone,balance,item and runtime cases remain to qualify.

## SYS-20.4-04

Checked swap rejects stale item/count arrays before mutation.

Limites : This is not proof of every concurrent purchase/sale race or duplication path.

## SYS-20.4-05

Immutable match result persistence is not reward command replay protection.

Limites : Account reward ledger and idempotency consumer remain absent from this path.

## SYS-20.4-06

Receive buffer bounds packet bytes but does not define per-player command rates.

Limites : Movement/cast/chat spam policy and saturation behavior remain open.

## SYS-20.4-07

Rejection context/length guard exists.

Limites : All server refusal reasons need visibility/confidentiality qualification.

## SYS-20.4-08

Point finite check exists.

Limites : All indices,numeric fields,oversized payloads and downstream paths require coverage.

682 fichiers,717 contrôles,35 cas dont34 refus.21 tests de boutique ;aucune sécurité complète ni compatibilité native déduite.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-20.4-01 | Session input validates context,capability and peer before dispatch. | Complete hostile identity scenarios across all entry paths remain to qualify. |
| SYS-20.4-02 | Cast dispatch checks learned ranks and state for implemented champion paths. | Every champion,resource and cast path still requires native-specific coverage. |
| SYS-20.4-03 | Server purchase validates admission and quote before inventory mutation. | All zone,balance,item and runtime cases remain to qualify. |
| SYS-20.4-04 | Checked swap rejects stale item/count arrays before mutation. | This is not proof of every concurrent purchase/sale race or duplication path. |
| SYS-20.4-05 | Immutable match result persistence is not reward command replay protection. | Account reward ledger and idempotency consumer remain absent from this path. |
| SYS-20.4-06 | Receive buffer bounds packet bytes but does not define per-player command rates. | Movement/cast/chat spam policy and saturation behavior remain open. |
| SYS-20.4-07 | Rejection context/length guard exists. | All server refusal reasons need visibility/confidentiality qualification. |
| SYS-20.4-08 | Point finite check exists. | All indices,numeric fields,oversized payloads and downstream paths require coverage. |

Reçu : docs/reference_command_validation_sources/command_validation-links.json. Livraison : docs/fidelity_registry_command_validation_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
