# Entrées et ergonomie — traçabilité V148

V148 input ergonomics:seven requirements,seven roles including four boundaries.1153 source pins,1196 checks,32 reader cases including31 refusals.10 CPU shortcut tests pass;two native Input.ini files and Game.cfg rehashed. Physical layouts,editable conflicts,extra buttons,visual aids,readability and input persistence remain open.

## SYS-22.3-01

Fixed physical Q/W/E/R dispatch;not an OS AZERTY/QWERTY translation qualification.

Limites : Qualify actual AZERTY layout and physical/logical translation with ordinary inputs.

## SYS-22.3-02

Labels derived from recorded default native bindings,not a runtime editable layout.

Limites : Qualify actual QWERTY layout and all required defaults beyond four spell keys.

## SYS-22.3-03

Ordered fixed key/modifier interpretation;not rebinding conflict resolution.

Limites : Implement/qualify editable bindings and deterministic conflict handling.

## SYS-22.3-04

Ordinary click command path uses right button;extra mouse button coverage not established.

Limites : Qualify required extra mouse buttons and historical binding consumers.

## SYS-22.3-05

HUD geometry scale/anchor transform;not per-resolution human readability acceptance.

Limites : Qualify UI scale and legibility at minimum resolution with actual rendering.

## SYS-22.3-06

Current health/resource bars consume snapshot values;not proof of selectable colorblind modes.

Limites : Qualify available historical visual aids and active renderer/configuration path.

## SYS-22.3-07

User Game.cfg reader/migration;does not establish persistent editable input bindings.

Limites : Persist edited input settings and restore them after process restart.

Aucun clavier/souris matériel, rendu ou redémarrage avec remappage testé ici. Les événements CPU et valeurs Colorblind natives ne prouvent pas les fonctions complètes.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-22.3-01 | Fixed physical Q/W/E/R dispatch;not an OS AZERTY/QWERTY translation qualification. | Qualify actual AZERTY layout and physical/logical translation with ordinary inputs. |
| SYS-22.3-02 | Labels derived from recorded default native bindings,not a runtime editable layout. | Qualify actual QWERTY layout and all required defaults beyond four spell keys. |
| SYS-22.3-03 | Ordered fixed key/modifier interpretation;not rebinding conflict resolution. | Implement/qualify editable bindings and deterministic conflict handling. |
| SYS-22.3-04 | Ordinary click command path uses right button;extra mouse button coverage not established. | Qualify required extra mouse buttons and historical binding consumers. |
| SYS-22.3-05 | HUD geometry scale/anchor transform;not per-resolution human readability acceptance. | Qualify UI scale and legibility at minimum resolution with actual rendering. |
| SYS-22.3-06 | Current health/resource bars consume snapshot values;not proof of selectable colorblind modes. | Qualify available historical visual aids and active renderer/configuration path. |
| SYS-22.3-07 | User Game.cfg reader/migration;does not establish persistent editable input bindings. | Persist edited input settings and restore them after process restart. |

Reçu : docs/reference_input_ergonomics_sources/input_ergonomics-links.json. Livraison : docs/fidelity_registry_input_ergonomics_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
