# Session spectateur — traçabilité V143

V143 spectator session:seven requirements,seven boundary roles.42 source pins,111 checks,32 reader cases including31 refusals. AIR release membership retained and rechecked;no Rust tests or game execution this revision. Existing player join,state,vision,focus,result,command and resume consumers do not implement observer delay,authority,cameras or HUD.

## SYS-21.2-01

Join creates a Simulation champion player;no read-only observer in this branch.

Limites : Define distinct observer subscription and permissions without creating a playable champion.

## SYS-21.2-02

States publish a current player-specific snapshot;this branch has no spectator delay buffer.

Limites : Enforce server-side delay on every observer path including reconnect.

## SYS-21.2-03

First snapshot initializes local player focus;not a spectator target selection control.

Limites : Connect authorized followed-player selection to camera and HUD.

## SYS-21.2-04

Team vision depends on an existing player;not spectator permission selection.

Limites : Qualify selected team view without exposing unauthorized state.

## SYS-21.2-05

Terminal result panel is gated by final results,not a live spectator scoreboard.

Limites : Implement and qualify live observer scoreboard separately from end results.

## SYS-21.2-06

Authenticated player command dispatch;no observer role represented in this branch.

Limites : Reject combat inputs based on observer authority;not just malformed packets.

## SYS-21.2-07

Resume prepares clock delivery for expected player;does not preserve spectator delay/audience cursor.

Limites : Resume observer with preserved delayed cursor and audience constraints.

Les conclusions de manque sont limitées aux chemins inspectés. Aucune déclaration de service Riot récupéré, de fonction complète ou d’acceptation. Aucun test Rust ni session graphique exécuté dans cette révision.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-21.2-01 | Join creates a Simulation champion player;no read-only observer in this branch. | Define distinct observer subscription and permissions without creating a playable champion. |
| SYS-21.2-02 | States publish a current player-specific snapshot;this branch has no spectator delay buffer. | Enforce server-side delay on every observer path including reconnect. |
| SYS-21.2-03 | First snapshot initializes local player focus;not a spectator target selection control. | Connect authorized followed-player selection to camera and HUD. |
| SYS-21.2-04 | Team vision depends on an existing player;not spectator permission selection. | Qualify selected team view without exposing unauthorized state. |
| SYS-21.2-05 | Terminal result panel is gated by final results,not a live spectator scoreboard. | Implement and qualify live observer scoreboard separately from end results. |
| SYS-21.2-06 | Authenticated player command dispatch;no observer role represented in this branch. | Reject combat inputs based on observer authority;not just malformed packets. |
| SYS-21.2-07 | Resume prepares clock delivery for expected player;does not preserve spectator delay/audience cursor. | Resume observer with preserved delayed cursor and audience constraints. |

Reçu : docs/reference_spectator_session_sources/spectator_session-links.json. Livraison : docs/fidelity_registry_spectator_session_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
