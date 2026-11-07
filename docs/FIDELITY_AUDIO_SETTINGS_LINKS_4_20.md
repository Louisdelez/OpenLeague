# Paramètres audio — traçabilité V120

## SYS-16.4-01

LanguageLocaleRegion match belongs to HUD font selection,not audio language selection.

Limites : HUD font locale is not audio language choice;selection among actual audio packages unqualified.

## SYS-16.4-02

Reads and merges native user/default Game.cfg; may migrate existing source;not executed on user configuration during this audit.

Limites : General config reader exists;user volume persistence and category routing not identified.

## SYS-16.4-03

Local R gain constant;does not consume MasterVolume/MusicVolume categories.

Limites : Fixed R gain is an entry boundary;mute control independent of game state not identified.

## SYS-16.4-04

Classifies child output diagnostic;does not switch/recover output device.

Limites : Unavailable output diagnostic is not device switching/recovery implementation.

## SYS-16.4-05

Reads and merges native user/default Game.cfg; may migrate existing source;not executed on user configuration during this audit. Normal startup reads configuration through zip resource provider;not proof of category volume application.

Limites : Startup configuration loading verified on temporary files;audio category restoration and actual process restart not qualified.

## Contrôles

18 fichiers,42 contrôles,26cas lecteur dont25refus.4tests du chargeur sur fichiers temporaires. Configuration native identique ;aucun paramètre utilisateur modifié,aucune écoute ou commutation périphérique.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-16.4-01 | LanguageLocaleRegion match belongs to HUD font selection,not audio language selection. | HUD font locale is not audio language choice;selection among actual audio packages unqualified. |
| SYS-16.4-02 | Reads and merges native user/default Game.cfg; may migrate existing source;not executed on user configuration during this audit. | General config reader exists;user volume persistence and category routing not identified. |
| SYS-16.4-03 | Local R gain constant;does not consume MasterVolume/MusicVolume categories. | Fixed R gain is an entry boundary;mute control independent of game state not identified. |
| SYS-16.4-04 | Classifies child output diagnostic;does not switch/recover output device. | Unavailable output diagnostic is not device switching/recovery implementation. |
| SYS-16.4-05 | Reads and merges native user/default Game.cfg; may migrate existing source;not executed on user configuration during this audit. Normal startup reads configuration through zip resource provider;not proof of category volume application. | Startup configuration loading verified on temporary files;audio category restoration and actual process restart not qualified. |

Reçu : docs/reference_audio_settings_sources/audio_settings-links.json. Livraison : docs/fidelity_registry_audio_settings_links_revision_4_20.json. Les cinq tâches et le Goal restent ouverts.
