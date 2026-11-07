# Annonces et musiques — traçabilité V119

## SYS-16.3-01

Native service storage exists with explicit disconnected frame/replay scope. Original bounded name composition;name output not trigger/voice dispatch.

Limites : Start announcement definition and naming exist;simulation-to-voice trigger unqualified.

## SYS-16.3-02

Kill event exposes sequence,tick,victim,killer,assists,first_blood,gold;not an announcement dispatch. Snapshot copies kill events;does not prove client audio consumption.

Limites : Kill/assist snapshot data exists;announcer event dispatch and playback unqualified.

## SYS-16.3-03

Kill event exposes sequence,tick,victim,killer,assists,first_blood,gold;not an announcement dispatch.

Limites : Kill/death streak counters do not qualify native streak/shutdown announcements.

## SYS-16.3-04

Shared unit damage/death branch handles structures; no turret announcement dispatch established.

Limites : Structure state transition is an entry boundary;turret destruction announcement consumer not identified.

## SYS-16.3-05

Inhibitor respawn scheduling exists;announcement producer/receiver not established.

Limites : Inhibitor death/respawn state exists;destroyed/respawned voice dispatch not identified.

## SYS-16.3-06

Altar cues have current playback consumer;local trigger cannot qualify all map objective announcements.

Limites : Altar cues cover a local subset;all per-map objective announcement semantics remain open.

## SYS-16.3-07

Nexus death sets winner;victory/defeat voice not established.

Limites : Winner state does not prove victory/defeat audio delivery.

## SYS-16.3-08

Registers custom PCM and loads ambient catalogue; no music scheduling or music/announcement transition consumer identified.

Limites : MUS banks exist;required loading/in-game music mapping and actual playback consumer remain open.

## SYS-16.3-09

Registers custom PCM and loads ambient catalogue; no music scheduling or music/announcement transition consumer identified.

Limites : Native music transition/ducking/priority graph not decoded;PCM registration not a transition implementation.

## Contrôles

51 fichiers,102 contrôles,38 cas lecteur dont37 refus.13 tests Rust conservés.5 sources annonces,369sections,274candidats vers69événements,524 non résolus ;10 ressources musicales. Aucun test matériel audio.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-16.3-01 | Native service storage exists with explicit disconnected frame/replay scope. Original bounded name composition;name output not trigger/voice dispatch. | Start announcement definition and naming exist;simulation-to-voice trigger unqualified. |
| SYS-16.3-02 | Kill event exposes sequence,tick,victim,killer,assists,first_blood,gold;not an announcement dispatch. Snapshot copies kill events;does not prove client audio consumption. | Kill/assist snapshot data exists;announcer event dispatch and playback unqualified. |
| SYS-16.3-03 | Kill event exposes sequence,tick,victim,killer,assists,first_blood,gold;not an announcement dispatch. | Kill/death streak counters do not qualify native streak/shutdown announcements. |
| SYS-16.3-04 | Shared unit damage/death branch handles structures; no turret announcement dispatch established. | Structure state transition is an entry boundary;turret destruction announcement consumer not identified. |
| SYS-16.3-05 | Inhibitor respawn scheduling exists;announcement producer/receiver not established. | Inhibitor death/respawn state exists;destroyed/respawned voice dispatch not identified. |
| SYS-16.3-06 | Altar cues have current playback consumer;local trigger cannot qualify all map objective announcements. | Altar cues cover a local subset;all per-map objective announcement semantics remain open. |
| SYS-16.3-07 | Nexus death sets winner;victory/defeat voice not established. | Winner state does not prove victory/defeat audio delivery. |
| SYS-16.3-08 | Registers custom PCM and loads ambient catalogue; no music scheduling or music/announcement transition consumer identified. | MUS banks exist;required loading/in-game music mapping and actual playback consumer remain open. |
| SYS-16.3-09 | Registers custom PCM and loads ambient catalogue; no music scheduling or music/announcement transition consumer identified. | Native music transition/ducking/priority graph not decoded;PCM registration not a transition implementation. |

Reçu : docs/reference_announcement_music_sources/announcement_music-links.json. Livraison : docs/fidelity_registry_announcement_music_links_revision_4_20.json. Les neuf tâches et le Goal restent ouverts.
