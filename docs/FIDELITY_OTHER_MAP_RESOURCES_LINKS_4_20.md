# Ressources des autres cartes — liens V92

Quatre exigences SYS-11.2 sont reliées aux sources de Map1,Map11,Map8 etMap12 et à10 frontières actuelles. Les décisions de disponibilité de V91 restent ouvertes. Le lot identifie ressources et points de consommation ; il ne rend pas ces cartes jouables,ne crée pas leurs fiches individuelles et ne clôture aucun périmètre.

## Référence et résultats

116 sources identifiées,288 contrôles source,43 cas de qualification du lecteur dont42 refus.91 ressources natives correspondent individuellement aux manifestes des projets sélectionnés. Les empreintes,chemins,appartenances et tables sont conservés dans le reçu. Le lecteur reparcourt la liste des marqueurs et l'existence des fichiers optionnels même lorsqu'il réutilise ses données en mémoire ;les hashes seuls ne détecteraient pas l'ajout d'un nouveau fichier. Une qualification antérieure à ce garde est conservée séparément dans le dossier de travail ;les43cas ont été réexécutés après ajout du garde.

| Carte | Groupes CampSpawnPoints | Compositions PredefinedCamps | Marqueurs SCO candidats | Préfixe AIPath | Minimap DDS |
|---|---:|---:|---:|---|---|
| Map1 |14|8|40|3.1.0|856×856, DXT3, champ mip10|
| Map11 |16|12|0|5.1.0|512×512, DXT1, champ mip0|
| Map8 |10|10|4|3.1.1|512×512, DXT1, champ mip0|
| Map12 |4|4|27|3.1.0|512×512, DXT1, champ mip10|

Les71marqueurs sont sélectionnés par préfixes Barracks,HQ,Turret,Info,spawn/barracks. Ce sont des candidats nommés avec CentralPoint, pas71structures actives. La liste est bornée aux SCO de scène et ne couvre pas tous les formats. Map11 n'a aucun candidat dans cette sélection ; son MapObjects.mob est présent. Les conteneurs MOB de Map1 etMap11 sont identifiés mais non décodés. L'absence du chemin MOB inspecté pour Map8/Map12 ne constitue pas une absence globale de placements.

## Camps et structures

Le lecteur Lua5.1 lit intégralement les quatre chunks puis récupère leur initialisation linéaire. Les tables de points,orientations,noms et compositions sont conservées. Les44entrées NeutralMinionCamps sont encore des tables vides au point d'arrêt ; l'évaluation s'arrête à l'opcode20 pour chaque carte. Aucun callback de population,de spawn ni de gameplay n'est exécuté. Ainsi14groupes de pointsMap1 ne valent pas14camps actifs qualifiés. La présence de données de monstres dans un script Map8 ne tranche pas leur utilisation dans Dominion ou un événement.

Simulation::enable_map10 lit data/4.20/map10_world.json,construit les camps et instancie les structures de ce contrat. tools/native_lua.initialization est un consommateur d'analyse statique avec arrêts explicites. Ces deux chemins sont reliés,mais ne constituent pas des consommateurs complets des autres cartes.

## Identités des futures fiches

L'essai du vrai positional_subject_key montre que deux entrées STRUCTURE-999-POSITION,entity=HQ_T1,ayant des champs map différents,produisent la même clé semantic-task:STRUCTURE:hq_t1:POSITION. canonical_task_key produit deux clés distinctes pour les exemples entity=Map1/HQ_T1 etentity=Map11/HQ_T1. Un sujet absent est refusé. Ces exemples en mémoire documentent une condition de conception ; aucune nouvelle convention n'est adoptée et aucune identité/alias existant n'est modifié. Les noms du reçu sont qualifiés par leur carte pour permettre les futures fiches,après validation des objets.

## Navigation et terrain

Chaque AIPath est lié au terrain.inibin de sa carte et au manifeste sélectionné. Les39premiers octets permettent de relever préfixe,champ de bornes,taille de cellule et dimensions candidates ; le lecteur n'interprète pas les cellules ni les suffixes propres aux variantes. Les dimensions relevées sont293×294,295×296,280×231 et248×240. Map11 utilise le préfixe5.1.0,distinct des versions3 ; aucun stride56 supposé de Map10 n'est appliqué aux autres fichiers.

Le consommateur Rust Navigation::load attend un format local compact de11octets par cellule et refuse dimensions nulles,tailles invalides ou overflow. Le main lui fournit tt_navigation_grid.json/cells.bin,puis activeMap10. Cela ne démontre pas l'import ni la fidélité des autres grilles. L'appartenance au même répertoire/release ne suffit pas à prouver transformations,hauteurs ou alignement terrain/navigation.

## Minimap et coordonnées

Les en-têtes DDS sont lus sans décodage ni rendu. Les champs mip0 sont conservés tels quels,sans les transformer en preuve d'absence d'image. Les SCB __LevelSize_ sont présents aux chemins inspectés pour Map8/Map12 ; leurs bornes sont distinctes des en-têtes AIPath. Les chemins inspectés de Map1/Map11 sont absents,sans conclusion globale sur les limites natives de ces cartes.

Projection::map10 lit le SCB TT,exige minX/minZ nuls et utilise centre et étendue pour projeter X/Z. Les minima SCB observés de Map8/Map12 ne satisfont pas tous cette garde ; aucune substitution automatique n'est justifiée. Le module native_minimap filtre ShadowIslesMinimapRight.ini et appelle Projection::map10 dans update. Les DDS des autres cartes ne valident donc pas leur conversion écran/monde. Contrôleurs natifs,zoom/pan,points d'ancrage et recette de rendu restent ouverts.

## Refus et conservation

Le lecteur refuse notamment une population de camp inventée,un arrêt Lua effacé,un marqueur promu en objet actif,un MOB déclaré décodé,version5 remplacée par3,un mip0 normalisé sans preuve,une collision d'identité masquée et une disponibilité ou clôture inventée. Seules les métadonnées/consignes des quatre exigences et du Goal sont publiées dans les deux bases. Cases,notes,historique,identités et anciennes preuves sont conservés. Aucun jeu,serveur,AIR,Blender ou programme historique lancé ;aucun code/asset du jeu modifié.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-11.2-01 | Les scripts NeutralMinionSpawn des quatre cartes livrent des tables statiques de points et compositions ; leur évaluation locale s’arrête avant la logique de peuplement des camps. Les marqueurs SCO et conteneurs MapObjects.mob sont identifiés séparément. Le consommateur courant enable_map10 charge uniquement map10_world. | Qualifier le montage,les placements MOB et les callbacks qui remplissent les camps ; les tables initiales et marqueurs nommés ne sont ni un inventaire exhaustif de structures actives ni un monde jouable pour chaque carte. |
| SYS-11.2-02 | La politique actuelle de clés STRUCTURE/CAMP utilise entity et action ; un champ map séparé ne change pas la clé. Deux HQ_T1 de cartes différentes auraient la même clé sémantique si leur entity reste non qualifiée. Les noms natifs sont conservés avec leur carte dans le reçu. | Créer les fiches futures avec identité de carte explicite et provenance,après qualification des objets ; conserver les alias/identités existants et ne pas traiter des noms identiques comme un seul objet. Ce lot ne crée ni n’accepte ces fiches. |
| SYS-11.2-03 | Les quatre AIPath sont liés à leur terrain.inibin par carte et manifeste. Le préfixe Map11 est5.1.0,Map8 est3.1.1,Map1/Map12 sont3.1.0 ; seuls les champs communs de début sont relevés. Navigation::load consomme un format local compact11octets/cellule et le serveur lui fournit la grille TT. | Qualifier le lecteur natif de chaque variante,les transformations et la correspondance terrain/grille complète ; ne pas appliquer implicitement les offsets des cellules Map10 au format5 ni assimiler le format compact local au fichier AIPath natif. |
| SYS-11.2-04 | Les DDS minimap de chaque carte sont identifiés avec dimensions/formats ; les bornes SCB disponibles sont séparées de la bounding box AIPath. Projection::map10 utilise le SCB TT et un pan central ; sources filtre ShadowIslesMinimapRight.ini,update appelle Projection::map10. | Relier chaque texture,les bornes effectives,zoom/pan et transformations du contrôleur de sa carte,puis vérifier des points en rendu ; une image et les en-têtes de fichiers ne prouvent pas l’alignement. Les absences locales restent limitées aux chemins inspectés. |

Reçu : docs/reference_other_map_resources_sources/other_map_resources-links.json. Livraison : docs/fidelity_registry_other_map_resources_links_revision_4_20.json. Les quatre tâches et le Goal restent ouverts.

## Reprise après interruption et changement de disque

La publication initiale V92 a échoué faute d’espace avant les registres et les bases. Les trois fichiers déjà installés sont conservés octet pour octet dans le dossier de reprise ; les snapshots et le staging incomplet antérieurs restent conservés. La présente reprise part des registres et bases F après migration. Le lecteur utilise le code courant F et les manifestes historiques E explicitement conservés, sans modifier le catalogue natif épinglé. Il vérifie l’égalité du catalogue copié et refuse la substitution des racines. Les43cas incluent deux refus supplémentaires de racine. Aucun contournement du vérificateur RADS,aucune écriture E. Voir recovery-origin.json dans le dossier de reprise.

La première reprise F a également été arrêtée avant publication par le contrôle des historiques conservés sous leur identité E. Le module source_versions distingue désormais validation des archives et adoption courante : six historiques/huit versions relus,22tests réussis ;adoption E toujours refusée et fichier courant F non qualifié par un ancien hash E. Preuve : docs/reference_relocation_sources/history-relocation-verification.json. Les deux interruptions et les fichiers déjà installés restent archivés.
