# HUD — traçabilité V121

## SYS-17.1-01

Panel payload uses native rectangle transform;full original framebuffer/aspect equivalence unqualified.

Limites : Full native framebuffer/aspect/anchor coverage remains open.

## SYS-17.1-02

Authoritative local health and Mana fractions;non-mana resource bars absent in this consumer.

Limites : Non-mana resources,complete local stats and trailing/tip effects remain open.

## SYS-17.1-03

Consumes authoritative health,mana,ranks,cooldowns;special rank schemes explicitly refused. Rank maxima only Ezreal Annie Garen Trundle;others explicit error,not all122champions.

Limites : Rank tables limited to four champions;special schemes and complete cooldown fidelity remain open.

## SYS-17.1-04

D/F remaining ready_at authoritative;denominator current core profile,not native server claim.

Limites : Five implemented summoners and current core cooldown denominator are not all native4.20 server semantics.

## SYS-17.1-05

Six inventory slots consume current shop catalogue and quantities;unknown item and invalid quantity refused.

Limites : Inventory consumer limited to current supported catalogue;full item coverage/input fidelity remains open.

## SYS-17.1-06

Local owner-only passive count in Buff0;no expiry prediction or generic native buff allocation.

Limites : Owner-only Ezreal passive count;generic buff/debuff duration and native slot allocation remain open.

## SYS-17.1-07

Snapshot ray selection feeds attack/cast commands;does not establish selected-target information HUD.

Limites : Picking for attack/cast commands is not selected-target information HUD;requested display not identified.

## SYS-17.1-08

Snapshot gold/time/local resource formatting;not complete team score HUD. Diagnostic text includes K/D/A and local stats;not native team scoreboard.

Limites : Gold/time native widgets plus diagnostic KDA do not prove native full score/team counters.

## Contrôles

53 fichiers,102contrôles,35cas lecteur dont34refus.55tests Rust conservés. Libellé initial hérité audio corrigé dans reçu distinct ;mutation ligne1 initialement inchangée corrigée ligne+1,script initial conservé. Aucun test GPU ni acceptation HUD complet.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-17.1-01 | Panel payload uses native rectangle transform;full original framebuffer/aspect equivalence unqualified. | Full native framebuffer/aspect/anchor coverage remains open. |
| SYS-17.1-02 | Authoritative local health and Mana fractions;non-mana resource bars absent in this consumer. | Non-mana resources,complete local stats and trailing/tip effects remain open. |
| SYS-17.1-03 | Consumes authoritative health,mana,ranks,cooldowns;special rank schemes explicitly refused. Rank maxima only Ezreal Annie Garen Trundle;others explicit error,not all122champions. | Rank tables limited to four champions;special schemes and complete cooldown fidelity remain open. |
| SYS-17.1-04 | D/F remaining ready_at authoritative;denominator current core profile,not native server claim. | Five implemented summoners and current core cooldown denominator are not all native4.20 server semantics. |
| SYS-17.1-05 | Six inventory slots consume current shop catalogue and quantities;unknown item and invalid quantity refused. | Inventory consumer limited to current supported catalogue;full item coverage/input fidelity remains open. |
| SYS-17.1-06 | Local owner-only passive count in Buff0;no expiry prediction or generic native buff allocation. | Owner-only Ezreal passive count;generic buff/debuff duration and native slot allocation remain open. |
| SYS-17.1-07 | Snapshot ray selection feeds attack/cast commands;does not establish selected-target information HUD. | Picking for attack/cast commands is not selected-target information HUD;requested display not identified. |
| SYS-17.1-08 | Snapshot gold/time/local resource formatting;not complete team score HUD. Diagnostic text includes K/D/A and local stats;not native team scoreboard. | Gold/time native widgets plus diagnostic KDA do not prove native full score/team counters. |

Reçu : docs/reference_hud_display_sources/hud_display-links.json. Livraison : docs/fidelity_registry_hud_display_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
