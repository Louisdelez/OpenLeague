# Évaluation des animations — traçabilité V111

Les observations préparatoires sont conservées ;la preuve finale fixe les résultats effectifs de publication. Aucun asset corrigé ni fidélité complète déclarée.

# V111 — Évaluation des animations

Trois tests Rust structure_animation_clock réussis :240 observations de phase,480 cas de répétition et passage idle→death sur un clip partagé. Vecteurs natifs hérités ;pas de nouvel appel natif ni rendu GPU. Journal et empreintes dans structure-clock-test-receipt.json.

- Le nombre de samples est tronqué ;le dernier sample est (frameCount-1)/Fps. Ce code ne prouve pas une durée native identique au GLTF. Source : `E:\mapslol3v3\_reference\LeagueToolkit\src\LeagueToolkit.IO.Extensions\SimpleSkinFile\SimpleSkinGltfExtensions.cs:534`.

- Évalue chaque pose puis exporte TRS ;comparaison numérique native restante. Source : `E:\mapslol3v3\_reference\LeagueToolkit\src\LeagueToolkit.IO.Extensions\SimpleSkinFile\SimpleSkinGltfExtensions.cs:546`.

- Normalise les rotations après refus des quaternions invalides ;pas une conservation bit à bit. Source : `E:\mapslol3v3\_reference\LeagueToolkit\src\LeagueToolkit.IO.Extensions\SimpleSkinFile\SimpleSkinGltfExtensions.cs:555`.

- Association animation par hash du nom ;homonymes et collisions à qualifier. Source : `E:\mapslol3v3\_reference\LeagueToolkit\src\LeagueToolkit.IO.Extensions\SimpleSkinFile\SimpleSkinGltfExtensions.cs:570`.

- Transition locale de80ms ;fidélité native de ce mélange non prouvée. Source : `F:\OpenLeague\crates\client\src\animation.rs:902`.

- Pose échantillonnée à âge calculé puis lecture suspendue ;pas une couche universelle pour tous champions. Source : `F:\OpenLeague\crates\client\src\animation.rs:972`.

- Vitesse et répétition par modèle/rôle depuis catalogue de structures. Source : `F:\OpenLeague\crates\client\src\structure_animation_clock.rs:12`.

- Fin de structure retenue au dernier sample ;ne prouve pas la politique de suppression de tous les acteurs. Source : `F:\OpenLeague\crates\client\src\structure_animation_clock.rs:63`.

Huit ancres uniques vérifiées. Aucun code de production ni asset changé. Suite :durées et pistes natives,os non animés,événements,interruptions,locomotion,couches et suppression après mort ;ne pas généraliser les tests de structures aux122champions. V110 dernière intégration,Goal actif.


# V111 — Recensement des pistes actuelles

164 entrées sélectionnent156 GLB ;4503 clips lus sans erreur de décodage.21 clips de trois assets ont des quaternions dont la norme carrée diffère de1 de plus de1e-3 : Blue_Minion_MechCannon_Run_Harrowing et dix clips dans chacun des deux golems. Aucun autre diagnostic détecté dans les contrôles implémentés. Cela ne prouve pas une corruption visible ni une fidélité native. Examiner les valeurs,le chargeur et les ressources natives avant décision.

Six tests existants Ezreal R passent :âge de lecture,pause,interruptions,pertes de graphe/clip/scène/visibilité,conflit Q et GLB canonique. Preuve CPU bornée ;pas de rendu GPU ni de test de tous les champions. Source et binaire dans ezreal-r-animation-test-receipt.json.

Fichiers ajoutés :inspect_animation_samplers.py,current-animation-samplers.json,run_ezreal_r_animation_tests.py,ezreal-r-animation-tests.log,ezreal-r-animation-test-receipt.json. Aucune modification de production. Suite :analyser les21 diagnostics puis compléter durées natives,mélange,couches,événements et suppression ;intégrer aux huit exigences SYS-14.4.


# V111 — Rotations hors tolérance

Les trois assets ont été relus et leurs SHA comparés au recensement précédent.

- blue_minion_mechcannon.glb : un clip, L_thumb_a et L_thumb_b,62 samples hors tolérance ;norme carrée entre0.3880304365 et5.6576653013.
- tt_ngolem.glb et tt_ngolem2.glb : dix clips chacun,C_BUFFBONE_GLB_CENTER_LOC,525 samples hors tolérance par asset ;norme carrée maximale1.1960061025.

Les exemples exacts,indices de sample,nœuds et modes d’interpolation sont dans rotation-anomaly-detail.json. La version Cargo.lock est bevy_gltf0.19.0. Son chargeur construit Quat::from_array sans normalisation dans cette branche ;cela ne prouve pas que les étapes ultérieures gardent ces normes. Aucun rendu ni échantillonnage effectif de courbe effectué ici. Influence sur les sommets,descendants et attaches à examiner. Ne pas qualifier tous les clips comme corrompus visuellement.

Première tentative interrompue avant lecture par un nom d’encodage invalide utf8-sig ;script initial conservé,nom corrigé utf-8-sig puis exécution réussie. Aucun asset changé. Suite :examiner influences et consommation des courbes,conserver les diagnostics ouverts dans les associations SYS-14.4.


# V111 — Influence des rotations et associations

Lecture des JOINTS/WEIGHTS de tous les maillages skinnés des trois GLB,avec descendants. Les SHA concordent avec le diagnostic précédent. L_thumb_a influence25 sommets directement,L_thumb_b24 ;leur sous-arbre totalise39 sommets distincts,les ensembles se chevauchent. Les deux golems ont zéro sommet influencé par C_BUFFBONE_GLB_CENTER_LOC et aucun descendant de cet os. Attaches et rendu ne sont pas vérifiés.

Huit associations SYS-14.4 préparées avec16 ancres uniques. Locomotion et couches sont des frontières,les autres liens restent partiels. Aucun statut ou base du plan changé. Suite :lecteur de preuves,cas de refus puis intégration transactionnelle.


## Lecteur

183 fichiers et256 contrôles ;35 cas dont34 refus. Neuf tests Rust exécutés dans les checkpoints V111 antérieurs,non rejoués lors de la publication. Vecteurs natifs hérités,aucun processus natif/GPU exécuté. Les21 diagnostics sont maintenus ouverts.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-14.4-01 | Current GLB channels are consumed through AnimationGraph;4503 clips/156 assets structurally decoded.21 clips carry non-unit rotations. Cannon thumb subtree affects39 vertices;golem helper has no mesh weights/descendants. | Compare native TRS and evaluated poses;qualify non-unit curve consumption and attached effects without asserting visible corruption from raw samples. |
| SYS-14.4-02 | Three fresh structure-clock tests and six Ezreal R binding tests pass in their scopes;exporter resamples at Fps and current effect clips seek by age. | Native durations/rates for all clips,variants and interpolation remain unqualified. |
| SYS-14.4-03 | Current transitions use80ms;loaded curves attach through ready. | Qualify nonanimated bone retention,bind transforms,blend weights and native transition durations. |
| SYS-14.4-04 | Attack presentation selection uses authoritative journals and clip seek age;comments explicitly avoid retroactive clip events. | Full native timed event dispatch is not established by seeking or accepted gameplay contacts. |
| SYS-14.4-05 | Owned Ezreal R pose is retired by identity and role changes;six tests cover bounded interruptions and asset binding. | Generalize only with per-action cancellation policy and all-champion evidence. |
| SYS-14.4-06 | Current champion moving flag depends on destination/action state;structure speed catalogue does not establish champion run-rate coupling. | Measure simulated velocity/stride and sliding;qualify locomotion coupling per model. |
| SYS-14.4-07 | Current action eligibility and owned W pose are single-role decisions. | Layered moving casts,per-bone masks and concurrent animation layers remain unqualified. |
| SYS-14.4-08 | Actors absent from snapshot are despawned;structure one-shots clamp their last sample. | Qualify death completion versus entity removal,visibility loss,respawn and attachments for all actor families. |

Reçu : docs/reference_animation_evaluation_sources/animation_evaluation-links.json. Livraison : docs/fidelity_registry_animation_evaluation_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
