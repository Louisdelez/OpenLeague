# Troy — traçabilité V113

Source et consommateur actuels identifiés dans des périmètres bornés ;aucune complétude des neuf fonctions déduite.

# V113 — Classes Troy

Deux tests Rust existants passent :lecteur/sélecteur contre les vecteurs natifs hérités et52groupes de carte avec refus du type non textuel. Répartition :{"Simple": 25, "Complex": 27}. Pas de nouveau processus natif ni rendu GPU.

Quatre ancres précises relues. Champ absent :Complex ;seule chaîne exacte Simple sélectionne Simple. Le consommateur ambiant exige Simple ;terrain-follow est explicitement refusé dans SimpleProjectedConfig. Ces observations ne recensent pas tous les Troy des champions,skins,sorts et objets.

Suite :inventaire des références requises,defaults/courbes,primitives,rubans/meshes,attaches,couleur et lifecycle ;qualifier chaque consommateur sans extrapoler les52groupes. Aucun code de production modifié.


# V113 — Consommateurs Simple

Neuf tests Rust existants réussis :cinq paramètres/défauts/refus,deux arrêt/délais,deux cycle de particule. Les vecteurs natifs sont hérités,le code Rust a été exécuté fraîchement. Aucun processus natif ni GPU.

- Lecture bornée des paramètres/defaults Simple. Source : `F:\OpenLeague\crates\client\src\simple_projected_config.rs:67`.

- Durées et fin propriétaire explicites ;pas un moteur universel de courbes. Source : `F:\OpenLeague\crates\client\src\simple_cycle.rs:49`.

- Arrêt idempotent,flags et horodatage conservés ;callbacks manager/audio séparés. Source : `F:\OpenLeague\crates\client\src\simple_system.rs:10`.

- Rattachement position/poids courant ;pas inventaire de tous les os. Source : `F:\OpenLeague\crates\client\src\simple_attachment.rs:10`.

- Annie Q Projected exige variante précise et coefficients owner nuls. Source : `F:\OpenLeague\crates\client\src\projected_live.rs:16`.

- Consommateur concret de la demande d’arrêt dans projection Annie Q. Source : `F:\OpenLeague\crates\client\src\projected_live.rs:119`.

Six ancres uniques vérifiées. Aucun code de production modifié. Suite :primitives,meshes/rubans,classes Complex,types couleur et couverture requise ;préserver la distinction entre chemin concret et portage exhaustif.


# V113 — Meshes et couleurs Complex

23 tests Rust existants passent :11 nexus_complex_mesh,5 native_complex_color,3 native_color_curve,4 native_color_consumers. Sources/binaires/journaux dans complex-mesh-color-test-receipt.json. Les vecteurs natifs sont hérités ;pas de nouvelle exécution originale ou GPU.

- Décodage borné des meshes natifs et refus des données invalides. Source : `F:\OpenLeague\crates\client\src\nexus_complex_mesh.rs:69`.

- Préparation du mesh avec matrice monde fournie ;ne constitue pas un producteur de pose. Source : `F:\OpenLeague\crates\client\src\nexus_complex_mesh.rs:101`.

- Primitive Complex type2 avec entrées explicites ;pas couverture de tous billboards/rubans. Source : `F:\OpenLeague\crates\client\src\relic_pickup_complex_type2_quad.rs:10`.

- Lecture de p-xrgba distincte de e-rgba. Source : `F:\OpenLeague\crates\core\src\native_complex_color.rs:28`.

- Couleur de naissance à âge émetteur et tirages aléatoires explicites. Source : `F:\OpenLeague\crates\core\src\native_color_consumers.rs:20`.

- Couleur de vie à âge particule multipliée par couleur de naissance conservée. Source : `F:\OpenLeague\crates\core\src\native_color_consumers.rs:28`.

Les profils Nexus et Ezreal importent ComplexColor ;cela ne qualifie pas tous leurs effets. p-colortype3 des projectiles de sbires est une question distincte des couleurs e-rgba/p-xrgba testées. Suite :inventaire requis,billboards/rubans,attaches et ce cas précis avant intégration SYS-15.1. Aucun code de production changé.


# V113 — Politique d’attribut3

Cinq tests Rust existants passent :politique (504 vecteurs natifs hérités),trois mises à jour particules et lookup (132 vecteurs hérités). Pas de nouveau processus natif ni GPU.

- Mode3 calcule auxiliary*multiplier+offset ;valeur auxiliaire doit être fournie et finie. Source : `F:\OpenLeague\crates\core\src\native_simple_attribute_policy.rs:14`.

- Consommateur concret :politique appliquée aux tableaux ages,velocities et auxiliary. Source : `F:\OpenLeague\crates\core\src\native_simple_particle_update.rs:43`.

- Snapshot logique,clés uniques,valeurs finies ;population native non déduite. Source : `F:\OpenLeague\crates\core\src\native_particle_attributes.rs:10`.

- Lecture bornée des deux modes ;ne constitue pas un branchement sbire. Source : `F:\OpenLeague\crates\client\src\simple_projected_config.rs:104`.

La recherche bornée dans les modules minion/projectile ne suffit pas à identifier la chaîne complète des projectiles de sbires. Ne pas convertir ce manque de preuve en absence universelle du code. Producer auxiliaire,configuration Troy exacte et sélection runtime sbires restent à relier. Le mode3 arithmétique est distinct de e-rgba/p-xrgba et de la couleur finale shader. Aucun fichier de production changé.


# V113 — Traînées et rattachements

13 tests Rust passent :dix stockage natif,un rattachements Troy,deux rattachement Simple. Premier filtre native_complex_trail_resources exécutait zéro test ;aucun succès lui a été attribué. Le module contenant les tests est native_complex_particle_storage ;premier script et journal conservés.

- Demande différée stop0x400 et gestion des contrôles faibles ;pas géométrie de ruban. Source : `F:\OpenLeague\crates\core\src\native_complex_trail_resources.rs:42`.

- Consommateur réel de suppression/traînées dans stockage de particules. Source : `F:\OpenLeague\crates\core\src\native_complex_particle_storage.rs:102`.

- Rattachements conditionnés par flags émetteur/propriétaire/visibilité. Source : `F:\OpenLeague\crates\core\src\native_troy_attachments.rs:22`.

- Position locale selon matrices fournies ;producteur d’os distinct. Source : `F:\OpenLeague\crates\client\src\simple_attachment.rs:21`.

- Profil sélectionné sans traînées ;adaptateur nul ne prouve pas un renderer de rubans. Source : `F:\OpenLeague\crates\client\src\ezreal_e_complex_engine.rs:168`.

Les contrôles de ressources/arrêt ne prouvent pas la génération de géométrie et le rendu de toutes les traînées. Profil E sélectionné sans traînées distinct des effets requis qui en utilisent. Vecteurs natifs hérités,pas de processus natif ou GPU exécuté. Suite :inventaire requis et associations SYS-15.1 avec frontières explicites.


# Inventaire des Troy inclus dans les sources Rust

{
  "utc": "2026-10-23T05:06:12.600598+00:00",
  "scope": "Literal include_str JSON in crates/**/*.rs, including test-only consumers; not whole asset inventory or reachability proof.",
  "files_scanned": 871,
  "troy_files": 12,
  "documents": 12,
  "groups": 48,
  "classes": {
    "Complex": 36,
    "Simple": 12
  },
  "missing_sections": 2,
  "all_required_troy_covered": false,
  "native_or_gpu_executed": false
}

Chaque document porte son empreinte et ses sites include_str. Les inclusions de tests sont conservées : inclusion ne signifie pas activation en jeu. Les chemins construits, chargements dynamiques, références transitives et ressources uniquement natives restent à examiner. Aucun statut de tâche ni case du plan modifié.


# Sections Troy absentes : vérification binaire

Les deux binaires originaux correspondent aux SHA-256 enregistrés. Le champ natif System/GroupPart2 confirme chaque référence. Tous les noms exportés correspondent à un hash présent dans le binaire.

- ready2 : 98 champs binaires ; 6674 noms candidats testés ; 0 correspondances ; 98 champs exportés vérifiés.
- Firefly_Spin : 353 champs binaires ; 6674 noms candidats testés ; 0 correspondances ; 43 champs exportés vérifiés.

Limite : le dictionnaire communautaire ne prouve pas l’absence de tout nom possible. Aucun fichier reconstruit ni default inventé. Le consommateur tt_well_ring_sampler::from_document vérifie déjà explicitement Firefly_Spin avec fields:null et conserve les hashes non nommés. Le provider natif et la résolution effective restent ouverts.


## Qualification du lecteur

141 fichiers,327 contrôles,38 cas dont37 refus.52 tests Rust de cette révision conservés,non rejoués lors de cette qualification. Aucune exécution GPU ou processus natif.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-15.1-01 | Default absent Complex,comparaison exacte Simple ;autres chaînes Complex. Refus explicite de type non textuel. | Required-content inventory is incomplete: map52 groups and literal Rust JSON48 groups are distinct overlapping scopes;dynamic and transitive dependencies unqualified. |
| SYS-15.1-02 | Lecture bornée des paramètres/defaults Simple. Annie Q Projected exige variante précise et coefficients owner nuls. | Bounded Simple profiles only;all emitter defaults and native provider semantics remain open. |
| SYS-15.1-03 | Durées et fin propriétaire explicites ;pas un moteur universel de courbes. Couleur de vie à âge particule multipliée par couleur de naissance conservée. | Lifetime and color consumers identified;all emission curves and timing combinations remain open. |
| SYS-15.1-04 | Primitive Complex type2 avec entrées explicites ;pas couverture de tous billboards/rubans. Annie Q Projected exige variante précise et coefficients owner nuls. | Type2 quad and selected projection consumers only;all billboard axes and camera policies unqualified. |
| SYS-15.1-05 | Demande différée stop0x400 et gestion des contrôles faibles ;pas géométrie de ruban. Consommateur réel de suppression/traînées dans stockage de particules. | Trail ownership/removal is not ribbon geometry or GPU rendering;universal ribbon consumer not established. |
| SYS-15.1-06 | Décodage borné des meshes natifs et refus des données invalides. Préparation du mesh avec matrice monde fournie ;ne constitue pas un producteur de pose. | Selected native meshes and world-matrix baking only;all required meshes and GPU fidelity unqualified. |
| SYS-15.1-07 | Rattachements conditionnés par flags émetteur/propriétaire/visibilité. Position locale selon matrices fournies ;producteur d’os distinct. | Supplied transforms and conditional attachments do not qualify all bone producers or world bindings. |
| SYS-15.1-08 | Mode3 calcule auxiliary*multiplier+offset ;valeur auxiliaire doit être fournie et finie. Consommateur concret :politique appliquée aux tableaux ages,velocities et auxiliary. | Mode3 auxiliary arithmetic identified;full minion projectile producer and rendering chain remain unqualified. |
| SYS-15.1-09 | Arrêt idempotent,flags et horodatage conservés ;callbacks manager/audio séparés. Consommateur concret de la demande d’arrêt dans projection Annie Q. | Stop request and idempotence identified;all repetition,manager callbacks and resource cleanup remain open. |

Reçu : docs/reference_troy_runtime_sources/troy_runtime-links.json. Livraison : docs/fidelity_registry_troy_runtime_links_revision_4_20.json. Les neuf tâches et le Goal restent ouverts.
