# Lectures d'horloge du rendu après Last

Revue statique des fichiers présents après intégration du candidat par le root. Aucune compilation ni exécution. Les empreintes exactes du périmètre inspecté figurent dans `manifest.json`.

## Ordre effectivement permis

`bevy_app 0.19.0/src/sub_app.rs:566..581` termine la schedule principale, puis effectue `extract` et `update` des sous-applications. La fin de `Last` n'est donc pas une barrière interdisant tout travail de rendu. Avec le plugin pipeliné, `bevy_render/src/pipelined_rendering.rs:150..205` reçoit le RenderApp, exécute son extraction et le remet au thread de rendu. Du travail GPU et de l'extraction peuvent encore avoir lieu après le checkpoint de fermeture.

## Producteurs natifs et valeurs copiées

`native_effect_clock.rs:30..43` est le producteur utilisé par le client normal : un `ClockHandle` privé échantillonne la banque canonique. `advance` est installé en `First` (`:98`). L'autre chemin, `EffectClock::receive`, échantillonne lors de la réception pause/reprise ; son appelant `main.rs:826` appartient au système `receive` installé en `Update` (`:509..535`). Les appels explicites restants de `main.rs` appartiennent à la CLI de sonde process-clock, non activée par ce runner. Les appels sous `#[cfg(test)]` ne constituent pas des consommateurs du client normal.

`native_runtime_shutdown.rs:101..108,174..195` acquiert un handle temporaire puis lit des **snapshots** avant/après la fermeture. Il ne demande aucun échantillon. Les valeurs d'identité et les compteurs avant/après sont comparés. Le handle temporaire est abandonné avant la sortie du système, et Watch ne conserve que des rapports indépendants.

Les ressources extraites inspectées ont les contenus suivants :

| Fichier | Travail après Last possible | Source temporelle transportée |
| --- | --- | --- |
| `projected_pixel_pair.rs:9..10,19..22,49..66` | copie GPU en RenderGraph | `Pair.effect_time:u32` et `paused:u32`, copiés depuis `EffectClock.now/paused()` en PostUpdate ; aucun handle natif |
| `fow_gpu.rs:4..5,17..23,33..39` | prepare/compute de brouillard | `Images.now:f32`, copié depuis `bevy::Time` en Update ; aucun `EffectClock` ni handle natif |
| `projected_pipeline_probe.rs:7..8,16..25` | mesure des pipelines | temps scalaire provenant de `bevy::Time` en PostUpdate |
| `native_hud_atlases.rs` | vérification d'atlas | handles GPU/données d'atlas, aucun producteur d'horloge |
| `projected_warmup.rs` | préparation GPU | layout/handles, aucun producteur d'horloge |
| `window_surface_lifecycle.rs:7..21` | retrait de ViewTarget orphelin | aucun accès à l'horloge native |

Les consommateurs `annie_q_vfx`, `annie_ready`, `annie_ready/live_probe`, `projected_live`, `map_audio_requests` et la caméra lisent `EffectClock.now`, des indicateurs ou des deltas déjà calculés. Une lecture de ce scalaire n'appelle ni QPC ni la banque canonique. `EffectClock` ne dérive pas `ExtractResource`, et aucune installation `ExtractResourcePlugin<EffectClock>` n'existe dans le périmètre client inspecté.

Le balayage de tout `crates/client/src/**/*.rs` pour `raw_clock_sample`, `wall_clock_f32_bits`, `ClockHandle`, `clock_handle(`, `CanonicalClock` et `audio_native_process_clock` retrouve uniquement le producteur, ses tests, la sonde CLI et l'observateur de fermeture. Aucun accès natif d'un RenderSubApp n'a été trouvé. Cette recherche et la lecture des structs extraites ne sont pas une preuve générale d'absence de toute activité de rendu après fermeture ; elles écartent le chemin concret redouté de rééchantillonnage natif par ces consommateurs.

## Limites

Cette revue n'instrumente pas QPC, le thread de rendu ou les callbacks du pilote. `fow_gpu` utilise actuellement la valeur Bevy Time ; cela ne démontre pas la fidélité de son horloge au moteur 4.20. Le patch ne modifie pas ce choix. La qualification GUI doit encore être exécutée sur le binaire reconstruit, avec ses rapports ; aucun résultat GUI n'est annoncé ici.
