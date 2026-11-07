# Zones de Map10 — SYS-01.2-02, V85

Les11 exigences SYS-10.2 sont reliées à44 rôles courants. Ce lot identifie leurs sources et leurs consommateurs partiels ; il ne clôture aucune recette de zone ni le Goal. Aucun code ou asset du jeu modifié. Cases et acceptation restent manuelles.

## Terrain installé et textures

Le GLB installé SHA909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a contient2578 meshes et1013104 triangles. Les235 images embarquées sont décodées ; les primitives ont des indices de matériaux valides. Les87 matériaux NVR sont relus depuis room.nvr,leurs diffuse DDS confrontées aux manifestes sélectionnés.85 diffuse correspondent exactement en pixelsRGBA de base ; les2 autres sont TT_Jungle1 etTT_Lanes1,index23/32,avec images reconstruites4096² distinctes de la diffuse native512². Ce constat n’est ni une corruption démontrée ni une égalité du rendu.

Ces2 noms sont les clés de TerrainMaterials. setup charge les six PNG hauteur/couleur/couches dont les pixels de base sont égaux aux DDS natifs ; bind remplace StandardMaterial par TerrainMaterial. Les scales sont lus depuis native_settings. Le transform spatial courant passe par le contratc233,distinct des anciens UV15360. Les28 matériaux horsNVR ne sont pas qualifiés par cet audit de diffuse. Éclairage,fog,mips,shader complet et framebuffer restent distincts.

## Fichier Blender actuel et ancien reçu

Le reçu du3octobre porte l’ancien hash a8a5595c62bc66e044d586262b9986eb0f669cf6da30240f4cbdbc1a9e48c171. Le fichier courant est33ca3eb569c99d13a7751a14addb703627075b6b1a4b84359b490d96bc88ad9b,identité déjà présente dans le registre. L’ancien reçu n’est pas réécrit et ses comptes ne sont pas présentés comme une ouverture actuelle.

Une nouvelle lecture Blender4.5.0 a été exécutée avec --background --factory-startup --disable-autoexec,le blend puis --python inspect_blender_map.py. Code retour0. Le script sauvegarde uniquement son reçu dans le workspace ; aucun save/export/render. Le binaire,le script etle blend sont identifiés par SHA256. La lecture observe2597 objets mesh,dont19 helpers glTF_not_exported ;2578 objets de rendu,1013042 triangles,110 images packées. Le SHA du GLB conservé dans la scène correspond au modèle installé. Les deux matériaux terrain contiennent chacun leurs six nœuds d’images packées.

Le label Spatial UV: reconstructed xz/15360 est présent dans le blend courant. Il ne prouve à lui seul ni les valeurs effectives de chaque UV ni une équivalence avec le transform Rust actuel. La scène déclare aussi une prévisualisation FoW entièrement visible ; l’équivalence shader/raster/clock/couleur demeure ouverte. create_map_blender_source importe le GLB et sauve un blend ; il n’exporte pas le blend dans le jeu.

L’ancien détail de suppression comprend61 enregistrements totalisant62 faces.1013104−1013042=62 :61 lignes ne signifie pas61 faces. La cause détaillée par mesh demeure une preuve héritée ; le nouveau script a compté les triangles,il n’a pas rejoué mesh.validate.

## Repères propres aux zones

Les bases utilisent __Spawn_T1/T2. Les25 points supérieurs et18 inférieurs sont reliés individuellement aux marqueurs SCO de départ,NAV_L02..24/NAV_R02..17 et arrivée. Les différences décimales entre texteSCO et configuration sont conservées ; chaque composante diffère de moins de0.001 unité native. Cela ne qualifie pas l’ordre historique de navigation,les limites de zone ou une correspondance de tous les triangles.

Les camps1..6 comprennent16 membres ; le camp8 fournit le repère de Vilemaw,et le camp7 celui de la relique. Le lecteur de l’initialisation Lua5.1 retrouve leurs XYZ et points de face sans lancer le runtimeLua ni le jeu. Les valeurs du monde courant sont comparées directement ; l’angle local est conservé sans prétendre qualifier la pose rendue. Les fonctions qui spawnenent les membres et consomment les routes sont précisément liées.

Les autels sont placés depuis le Snapshot et altars_map10. Les centres sont déclarés dérivés de géométrie NVR ; le matériau structure_shrine_base_02 existe. Ce lot ne redémontre pas le calcul géométrique de ces centres et ne les transforme pas en triggers natifs. Rayon500 et règles de capture restent reconstruits. La relique a une position native exacte,mais la présence de son modèle/idle ne couvre pas tous ses effets de sol.

Les39474 flags de navigation correspondent exactement aux octets installés. La règle line_of_sight teste le bit1 de buisson et les masques d’obstacle ; cette politique courante ne prouve pas les silhouettes visibles ou tous les volumes historiques. Les bornesSCB15398.671875 sont distinctes du rectangle caméra800/4200/14700/10000 : il reste à observer les bordures dans le rendu aux poses/zooms pertinents.

## Contrôles, refus et intégration

3337 contrôles source et 40 cas du lecteur,dont39 refus attendus. Les cas invalides changent hash,image,source,marqueur,delta,autorité de zone,ancien reçu Blender,compte de faces ou réclament une clôture/rendu non démontrés. Chaque validation réempreinte les sources ; les faits parsés peuvent être réutilisés dans le même processus seulement si leurs identités restent inchangées.

Deux premières préparations ont été corrigées avant publication : refus du hash Blender ancien,puis variable locale de coordonnées masquant le dictionnaire de lecture Blender. Le reçu intermédiaire invalide est conservé dans le workspace et exclu du registre. Aucun fichier du projet n’avait alors été modifié.

| Tâche | Consommateur constaté | Travail ouvert |
|---|---|---|
| SYS-10.2-01 | La base bleue est repérée par __Spawn_T1 ; le GLB installé est chargé sous MapRoot en XYZ/20 et importé dans le fichier Blender identifié. Les matériaux terrain ont un bind séparé. | Comparer géométrie,contacts,textures et raccords de cette base dans Blender et le framebuffer courant ; un repère de spawn ne définit pas son volume visuel complet. |
| SYS-10.2-02 | La base rouge est repérée par __Spawn_T2 ; le même GLB et le même transform direct sont consommés. Les écarts décimaux SCO/configuration restent mesurés,non effacés. | Recette visuelle propre à cette base,contacts et raccords ; ne pas déduire la symétrie parfaite ou une validation depuis la base bleue. |
| SYS-10.2-03 | Les25 points de la voie supérieure sont reliés aux SCO L01/NAV_L02..24 et au consommateur world.config.lanes[0]. Les matériaux TT_Lanes1 passent par le bind hauteur. | Qualifier surface,raccords,collisions et affichage de la voie entière ; correspondance des points de route ne prouve pas celle de chaque triangle ni l’algorithme historique. |
| SYS-10.2-04 | Les18 points de la voie inférieure sont reliés aux SCO R01/NAV_R02..17 et au consommateur world.config.lanes[1]. Les écarts de sérialisation sont conservés. | Qualifier surface,raccords,collisions et rendu de cette voie ; aucun contrôle visuel courant déduit des points. |
| SYS-10.2-05 | Les camps1..3 regroupent huit membres,issus de CampSpawnPoints natif. world.spawn_unit consomme leurs positions ; GLB et grille sont des sources distinctes. | Comparer chemins,murs,largeurs et hauteurs dans la jungle bleue ; camps et texture TT_Jungle1 ne définissent pas toutes les limites de la zone. |
| SYS-10.2-06 | Les camps4..6 regroupent huit membres dont les coordonnées correspondent à CampSpawnPoints natif et au spawn courant. Le terrain et la navigation sont distincts. | Comparer les chemins et murs de la jungle rouge ; aucun résultat de la jungle bleue n’est transféré automatiquement. |
| SYS-10.2-07 | Le repère de Vilemaw vient du camp natif8,avec position et point de face séparés. Le spawn courant consomme position,hauteur et angle local ; la fosse appartient au décor GLB. | Qualifier géométrie et accès de la fosse ainsi que l’orientation rendue ; un angle calculé depuis FacePoints ne prouve ni pose animée ni orientation native du mesh. |
| SYS-10.2-08 | Les deux autels sont rendus depuis le Snapshot aux centres de altars_map10. Ces centres sont déclarés dérivés de géométrie NVR ; le rayon500 est une politique locale,non une limite serveur native qualifiée. | Qualifier centres géométriques,limites de capture et raccords séparément ; relier chaque volume de trigger et vérifier le rendu des deux emplacements. |
| SYS-10.2-09 | Le camp natif7 fournit le repère exact de la relique. map_relic_world place le GLB TT_Relic seulement si la session et la visibilité/ disponibilité acceptées le permettent ; idle nommé/index3 vérifié par le consommateur. | Qualifier tous les effets de sol,pickup,occlusion et contacts ; présence du modèle et garde de session ne suffisent pas à la recette des effets. |
| SYS-10.2-10 | Les39474 flags de navigation sont comparés à la grille installée. line_of_sight interprète bit1 comme buisson ; Map10VisionView lit le SCB. Le décor visible et le volume logique restent distincts. | Comparer chaque silhouette de buisson et son volume de vision ; les flags et cette règle locale ne prouvent pas les limites visuelles ou les règles historiques de vision. |
| SYS-10.2-11 | Les bornes SCB15398.671875 et les limites caméra800/4200/14700/10000 sont distinctes. Le terrain courant lit le contrat c233 ; le fichier Blender importé reste identifié séparément. | Inspecter toutes les bordures visibles selon pose/zoom et raccords ; rectangle caméra et bornes de niveau ne prouvent pas une couverture complète du décor. |

Reçu : docs/reference_map_zones_sources/map_zones-links.json. Livraison : docs/fidelity_registry_map_zones_links_revision_4_20.json. Les11 périmètres et le Goal restent ouverts.
