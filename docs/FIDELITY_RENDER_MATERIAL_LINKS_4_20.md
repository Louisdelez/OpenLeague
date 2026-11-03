# Matériaux — traçabilité V114

Onze exigences reliées à des consommateurs bornés ;aucune complétude visuelle déduite.

# V114 — Rendu des particules

Trois tests Rust exécutés et réussis :routage modes/flags,mélange alpha séparé,état initial/profondeur. Les contrats natifs utilisés sont hérités ;pas de nouvelle exécution du client historique ou GPU.

- Modes0..4 et flags routés ;modes supérieurs refusés. `F:\OpenLeague\crates\client\src\particle_render_state.rs:5`

- Mélange additif RGB et alpha ONE/ONE ;périmètre projection Simple. `F:\OpenLeague\crates\client\src\particle_render_state.rs:19`

- GreaterEqual traduit la profondeur inversée ;écriture désactivée séparément. `F:\OpenLeague\crates\client\src\particle_render_state.rs:15`

- Textures de ce consommateur chargées en linéaire ;pas politique générale de toutes textures couleur. `F:\OpenLeague\crates\client\src\nexus_complex_material.rs:115`

- Encodage de sortie explicitement fourni ;équivalence cible native non qualifiée. `F:\OpenLeague\crates\client\src\nexus_complex_material.rs:25`

- Sous-ensemble de mélanges Nexus ;variantes non prises en charge restent refusées. `F:\OpenLeague\crates\client\src\nexus_complex_material.rs:225`

Restent à examiner :DDS/mips/samplers,couleurs de toutes les familles,tri transparent,ombres,post-traitements et nettoyage GPU. Les valeurs locales ne prouvent pas la fidélité globale.


# V114 — DDS, samplers et références

Sept tests Rust exécutés :deux images E,quatre terrain,un cache CPU avec100000 cycles équilibrés.

- Sampler linéaire/clamp local nommé,non récupéré du runtime natif. `F:\OpenLeague\crates\client\src\ezreal_e_bolt_images.rs:15`

- Validation dimensions,format,payload complet,mips,sampler et associations de cinq DDS ;lookup blanc local distinct. `F:\OpenLeague\crates\client\src\ezreal_e_bolt_images.rs:35`

- Terrain :canaux bruts linéaires,Repeat ou Clamp selon usage ;conversion finale dans shader. `F:\OpenLeague\crates\client\src\terrain_material.rs:107`

- Projections :LOD min et max zéro ;adaptation explicite de MIPFILTER NONE. `F:\OpenLeague\crates\client\src\terrain_material.rs:136`

- Libération CPU et retrait des IDs liés ;aucune destruction GPU exécutée ici. `F:\OpenLeague\crates\client\src\relic_texture_reference_cache.rs:37`

- Résidents et références restantes nettoyés ;effets réels GPU à qualifier séparément. `F:\OpenLeague\crates\client\src\relic_texture_reference_cache.rs:49`

Payload BC conservé ne prouve ni décodage visuel GPU ni sélection native de mip. Le sampler E et lookup blanc sont des politiques locales identifiées. Pas de preuve de destruction GPU ou de tous les formats requis.


# V114 — Tri, environnement et post-traitements

Deux tests du consommateur environnement passent :états/defaults/révisions et refus de profils non pris en charge. Vecteurs natifs hérités ;aucun GPU exécuté.

- Tri local des ReadyQuad à distance identique par identité ;ordre natif explicitement non qualifié. `F:\OpenLeague\crates\client\src\annie_ready\phase_order.rs:11`

- Lecture/état environnement et révision shadow_dynamic_only ;ne prouve pas une passe ombres. `F:\OpenLeague\crates\client\src\environment_render_config.rs:36`

- Refuse renderer alternatif et profils sans height-blend/colormap. `F:\OpenLeague\crates\client\src\environment_render_config.rs:53`

- Éclairage colormap multiplié par4 ;chaîne ombres complète non qualifiée. `F:\OpenLeague\assets\shaders\terrain_height_blend.wgsl:63`

- Caméra courante sans tonemapping ;pas inventaire des post-traitements natifs. `F:\OpenLeague\crates\client\src\main.rs:931`

- Calcul de flou FoW existant ;producteurs et intégration distincts,non testés dans cette étape. `F:\OpenLeague\crates\client\src\fow_postprocess.rs:36`

Le tri Ready est une politique locale. Le champ shadow_dynamic_only ne prouve pas une implémentation des ombres. La recherche de ses consommateurs a trouvé configuration et journal map_fog,mais ne qualifie pas toute méthode d’ombres. Le module FoW montre que Tonemapping::None ne permet pas de conclure absence de post-traitement. Restent l’inventaire natif exhaustif et la comparaison du rendu.


## FoW et qualification

Le consommateur fow_gpu::prepare utilise le noyau gaussien et prépare les passes fade et flou horizontal/vertical.14 tests FoW supplémentaires passent,total26.51 fichiers,144 contrôles et44 cas lecteur dont43 refus. Aucun GPU exécuté.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-15.3-01 | Textures de ce consommateur chargées en linéaire ;pas politique générale de toutes textures couleur. Encodage de sortie explicitement fourni ;équivalence cible native non qualifiée. | Native color-space policy must be qualified per content and shader;linear source channels plus final conversion are not universal sRGB loading. |
| SYS-15.3-02 | Terrain :canaux bruts linéaires,Repeat ou Clamp selon usage ;conversion finale dans shader. Éclairage colormap multiplié par4 ;chaîne ombres complète non qualifiée. | All numeric textures,alpha and conversion stages still require coverage. |
| SYS-15.3-03 | Validation dimensions,format,payload complet,mips,sampler et associations de cinq DDS ;lookup blanc local distinct. Sampler linéaire/clamp local nommé,non récupéré du runtime natif. | Five exact DDS payloads are checked;all required formats and GPU channel decoding remain unqualified. |
| SYS-15.3-04 | Validation dimensions,format,payload complet,mips,sampler et associations de cinq DDS ;lookup blanc local distinct. Projections :LOD min et max zéro ;adaptation explicite de MIPFILTER NONE. | Mip retention and projected LOD0 are distinct;native effective mip selection remains open. |
| SYS-15.3-05 | Sampler linéaire/clamp local nommé,non récupéré du runtime natif. Terrain :canaux bruts linéaires,Repeat ou Clamp selon usage ;conversion finale dans shader. | E linear/clamp is explicitly local;native sampler policy for every effect remains open. |
| SYS-15.3-06 | Mélange additif RGB et alpha ONE/ONE ;périmètre projection Simple. Sous-ensemble de mélanges Nexus ;variantes non prises en charge restent refusées. | Bounded projected and Nexus blends only;all native modes/flags remain open. |
| SYS-15.3-07 | Modes0..4 et flags routés ;modes supérieurs refusés. GreaterEqual traduit la profondeur inversée ;écriture désactivée séparément. | Current reversed-depth translation is bounded;all interleaved transparency states remain open. |
| SYS-15.3-08 | Tri local des ReadyQuad à distance identique par identité ;ordre natif explicitement non qualifié. | Ready tie-breaking is local,not native particle ordering;overlapping effects need reference comparison. |
| SYS-15.3-09 | Lecture/état environnement et révision shadow_dynamic_only ;ne prouve pas une passe ombres. Éclairage colormap multiplié par4 ;chaîne ombres complète non qualifiée. | ShadowDynamicOnly configuration and colormap arithmetic do not prove a complete shadow renderer. |
| SYS-15.3-10 | FoW render prepare consumes GaussianKernel::native and prepares fade plus horizontal/vertical blur bindings; CPU blur arithmetic remains separately identifiable. | FoW has a concrete render consumer;whole native postprocess inventory and visual equivalence remain open. |
| SYS-15.3-11 | Libération CPU et retrait des IDs liés ;aucune destruction GPU exécutée ici. Résidents et références restantes nettoyés ;effets réels GPU à qualifier séparément. | CPU reference cleanup does not prove GPU destruction or particle budgets. |

Reçu : docs/reference_render_material_sources/render_material-links.json. Livraison : docs/fidelity_registry_render_material_links_revision_4_20.json. Les onze tâches et le Goal restent ouverts.
