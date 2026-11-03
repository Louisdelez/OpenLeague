# Paramètres d’affichage — traçabilité V147

V147 display settings:seven requirements,seven roles including four boundaries.1153 source pins,1185 checks,32 reader cases including31 refusals.8 CPU projection/resize tests pass. Startup window,quality reader,backend selection,surface cleanup,focus and exit consumers remain partial;no GPU,fullscreen,Alt-Tab or persistence acceptance.

## SYS-22.2-01

Window creation hardcodes1280x800;does not persist user resolution or mode.

Limites : Persist and restore selected resolution/window mode through actual settings path.

## SYS-22.2-02

WindowPlugin uses default mode in inspected initializer;fullscreen/borderless behavior not qualified here.

Limites : Qualify fullscreen and borderless transitions on supported OS/backends.

## SYS-22.2-03

Drops stale targets without ExtractedCamera before surface recreation;not complete GPU resize proof.

Limites : Qualify GPU surface recreation,minimize/restore and game state preservation.

## SYS-22.2-04

Reads and migrates Game.cfg;quality loading is distinct from persisting user edits.

Limites : Persist quality changes and verify actual consumers after restart.

## SYS-22.2-05

Launcher passes configured backend or defaults to vulkan;compatibility/failure recovery remains distinct.

Limites : Qualify backend compatibility and explicit failure handling on available hardware.

## SYS-22.2-06

Focus loss invalidates pointer gesture batch;full Alt-Tab recovery must cover other systems.

Limites : Qualify focus loss/recovery for keyboard,pointer,audio and network under Alt-Tab.

## SYS-22.2-07

Exit handler sends session departure;does not itself flush display option changes.

Limites : Verify settings flush and preserved options across normal/error window closure.

Les huit tests exécutent des systèmes de caméra CPU. Aucun parcours fenêtre/GPU/Alt-Tab n’a été exécuté ici ; lire ou migrer Game.cfg ne prouve pas l’enregistrement de modifications utilisateur.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-22.2-01 | Window creation hardcodes1280x800;does not persist user resolution or mode. | Persist and restore selected resolution/window mode through actual settings path. |
| SYS-22.2-02 | WindowPlugin uses default mode in inspected initializer;fullscreen/borderless behavior not qualified here. | Qualify fullscreen and borderless transitions on supported OS/backends. |
| SYS-22.2-03 | Drops stale targets without ExtractedCamera before surface recreation;not complete GPU resize proof. | Qualify GPU surface recreation,minimize/restore and game state preservation. |
| SYS-22.2-04 | Reads and migrates Game.cfg;quality loading is distinct from persisting user edits. | Persist quality changes and verify actual consumers after restart. |
| SYS-22.2-05 | Launcher passes configured backend or defaults to vulkan;compatibility/failure recovery remains distinct. | Qualify backend compatibility and explicit failure handling on available hardware. |
| SYS-22.2-06 | Focus loss invalidates pointer gesture batch;full Alt-Tab recovery must cover other systems. | Qualify focus loss/recovery for keyboard,pointer,audio and network under Alt-Tab. |
| SYS-22.2-07 | Exit handler sends session departure;does not itself flush display option changes. | Verify settings flush and preserved options across normal/error window closure. |

Reçu : docs/reference_display_settings_sources/display_settings-links.json. Livraison : docs/fidelity_registry_display_settings_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
