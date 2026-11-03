# Traçabilité des procédures de réparation — V98

Objectif SYS-01.2-02 : relier les dix exigences SYS-02.4 à leurs sources et consommateurs actuels. Dix associations, vingt rôles, sept parcours partiels et trois points d'entrée dont la procédure complète reste à qualifier. Aucune acceptation de tâche ou du jeu n'en découle.

## Résultats actuels

Deux scènes `artwork/maps/TwistedTreeline_OpenLeague.blend` et `_Animated.blend` ont été rouvertes sur F dans Blender4.5.0, en arrière-plan avec autoexec désactivé. Aucune sauvegarde, export ou rendu. Leurs empreintes et les fichiers protégés restent inchangés. Les chemins E embarqués dans les métadonnées sont historiques ;la correspondance est vérifiée par empreinte avec le GLB F.

Le bloc de contrôle topologique de `verify_map_blender_source.py` a été réexécuté sans ses écritures de rapport :62 faces dégénérées ou dupliquées sont retirées dans Blender,1013042 triangles avec matériaux contre1013104 dans le GLB. Ce constat ne couvre pas tous les critères de topologie.

Les couches UV terrain sont finies. Les nœuds Blender conservent le libellé xz/15360 ;le runtime lit le contrat natif c233 de bornes distinct de15360. Un libellé ou un marqueur de couture ne constitue pas une comparaison numérique des coordonnées. Les coutures et l'équivalence spatiale entre ces parcours restent à qualifier.

Les17 hiérarchies de rigs correspondent aux GLTF installés. Pour le marchand,55 noms et parents correspondent en outre aux octets du SKL0 natif et aux deux instances Blender. Matrices de bind,poids,déformations et ensemble des autres rigs ne sont pas qualifiés par cette vérification. Le lecteur borné documente le format depuis RigResource.cs ;il n'exécute pas le client historique ni le convertisseur C#.

Le clip marchand possède451 trames et165 canaux dont les derniers échantillons correspondent aux données ANM4 natives. La sauvegarde précédente sans la dernière trame est refusée ;son préfixe binaire ainsi que les métadonnées mesh/skin/images/nodes sont conservés dans le résultat actuel. Les deux actions Blender durent15 secondes. Le runtime impose nom/index/durée du clip et lit séparément la période `map_events::native_period`. Aucun raccourci n'assimile ces mesures à la couverture complète des événements et blends.

## Textures et audio

La logique actuelle de `audit_current_map_textures.py` a été exécutée sur une copie dont seuls les chemins d'entrée et de sortie ont été adaptés :235 images décodées sans erreur,85 matériaux NVR à pixels identiques,deux matériaux terrain composites de4096² distincts de leur diffuse natif512²,28 matériaux horsNVR,aucun binding diffus absent dans ce périmètre. Une différence de composite n'est pas déclarée corrompue ni manquante. Le périmètre NVR ne qualifie pas les matériaux de props,les autres couches ou le rendu GPU.

Les31 WEM ont été comparés aux octets DIDX/DATA de leurs banques natives et les31 WAV aux empreintes/métadonnées du catalogue. Le média51118002 a été redécodé avec le décodeur identifié dans un fichier temporaire F :résultat byte-exact au WAV installé. Six tests Rust existants de audio_media passent sur médias réels et diagnostics :décodage,métadonnées,troncatures,ordre des canaux,répétitions finies,seeks et curseurs indépendants. Aucune écoute comparative ni qualification du mixeur ou du périphérique.

## Vérifications exécutées

- Blender :deux ouvertures,retour0,observations détaillées dans blender-readonly-observation.json et identité de l'exécutable dans blender-execution.json.
- Comparateurs de référence :cas nominaux natifs et12 refus sur copies d'octets (version,bornes,parent,cycle,temps,clip,troncature,média absent),dont la vraie sauvegarde du clip incomplet.
- Rust :`cargo test --locked --offline -p openleague-core --lib audio_media:: -- --nocapture` ;six réussites,zéro échec,binaire et journal identifiés.
- Lecteur de liens :338 contrôles source,226 identités ;31 cas de qualification,dont30 refus de preuves altérées. Ces mutations testent l'intégrité et la portée,elles ne sont pas des essais du jeu.

Producteurs,journaux,exécutables et sources sont épinglés dans le reçu. Les observations natives sont de lecture ;aucun asset réel n'a été remplacé. Les modifications portent sur les outils de traçabilité,registres,documents de couverture/reprise et onze fiches de chacune des deux bases. Aucun nouveau paquet de distribution ni code runtime du jeu.

## Conservation et limites

Les anciens reçus demeurent intacts. Les registres et bases sont sauvegardés avant publication ;l'audit de livraison doit comparer états manuels,notes,historique,flags et anciens liens,puis exercer Store.task et Store.copy_text sur onze fiches par base. Son reçu final distingue résultat effectif et intention de publication. Les prérequis aval restent ouverts ;le lot qualifie les associations demandées par le Goal,pas la clôture des procédures de réparation.

Aucune comparaison GIMP/Blender/imagegen sur un original réellement manquant n'est inventée. Les différences de terrain et les matériaux horsNVR nécessitent leur propre recherche. Aucun jeu,GPU,serveur historique ou écoute humaine n'a été exécuté pour ce lot.

## Détail par exigence

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-02.4-01 | Deux scènes F ont été rouvertes dans Blender4.5 avec autoexec désactivé,sans sauvegarde ni export. Leurs empreintes et celle du GLB actuel restent exactes ;17 décors animés sont reliés au catalogue. Les scripts de création sont identifiés ;les chemins E embarqués restent des références historiques. | Qualifier la procédure de travail sur copies et tous ses exports ;une scène modifiable et sa relecture ne démontrent pas la fidélité complète ni la couverture de toutes les ressources. |
| SYS-02.4-02 | Le bloc topologique du vérificateur actuel est réexécuté sur la scène F :62 faces retirées par Blender sont dégénérées ou dupliquées ;les1013104 triangles du GLB restent conservés. La scène contient1013042 triangles avec matériaux. | Étendre les contrôles aux autres maillages et aux invariants attendus de chaque réparation ;ne pas traiter un retrait diagnostiqué comme une validation générale de topologie ou de silhouette. |
| SYS-02.4-03 | Les couches UV de terrain sont présentes et finies ;les nœuds Blender conservent le libellé xz/15360. Le consommateur Rust utilise le contrat c233 de bornes natif,distinct de15360. La présence des UV et les marqueurs de coutures ne qualifient ni les coutures ni leur équivalence spatiale. | Comparer numériquement les espaces UV,leurs transformations et les coutures sur le même matériau ;qualifier une procédure de réparation avant adoption. Ne pas remplacer une preuve de coordonnées par un simple libellé de nœud. |
| SYS-02.4-04 | La comparaison actuelle des textures est réexécutée avec seuls chemins adaptés :235 images décodées,85 matériaux NVR à pixels identiques,deux matériaux de terrain composites différents,aucun binding diffus absent dans ce périmètre et28 matériaux horsNVR. Trois modifications alpha antérieures conservent leurs preuves. | Qualifier les matériaux terrain,les autres couches et les28 matériaux horsNVR sur leurs sources propres ;les différences de composite ne sont pas des preuves de corruption ni une équivalence du rendu natif. |
| SYS-02.4-05 | Les17 hiérarchies de rigs Blender correspondent aux GLTF sources. Pour le marchand,les55 noms et parents correspondent aussi au SKL0 natif et aux deux instances Blender. La lecture est bornée et refuse versions,parents inconnus et cycles. | Qualifier matrices de bind,poids,axes et autres rigs ainsi que la procédure de réparation ;la correspondance noms/parents ne prouve pas toutes les déformations ou le dispatch natif. |
| SYS-02.4-06 | Les165 canaux du clip marchand contiennent la dernière trame native451 ;la sauvegarde précédente,qui l’omet,est refusée par ce contrôle. Les octets binaires précédents et métadonnées mesh/skin/images/nodes sont conservés. Les deux actions Blender durent15secondes. Le runtime lit séparément la période via map_events et vérifie nom/index/durée avant chargement. | Qualifier tous les clips,fenêtres d’événements,blends et effets selon leurs consommateurs ;ne pas confondre durée ANM,action Blender et période de boucle runtime. |
| SYS-02.4-07 | Les31 WEM correspondent aux entrées DIDX/DATA natives et les31 WAV à leurs empreintes/métadonnées. Un média redécodé dans F est identique au WAV installé ;six tests Rust existants de transport PCM passent. | Réaliser l’écoute comparative et qualifier sélection,mixage,boucles et périphérique ;un décodage exact et des tests de transport ne prouvent pas une restitution audible fidèle. |
| SYS-02.4-08 | Le contrôle courant fournit un exemple concret de comparaison native :aucun diffus manquant dans son périmètre NVR,avec deux composites distincts et28 matériaux horsNVR. Blender ouvre les ressources existantes ;aucune comparaison GIMP/génération d’image sur une ressource véritablement manquante n’a été démontrée. | Identifier d’abord une ressource requise réellement absente,puis comparer les outils sur ce cas et sa source de référence. Ne pas inventer un manque à partir d’une différence de matériau composite. |
| SYS-02.4-09 | Les scripts de réparation conservent des sauvegardes et des empreintes. La sauvegarde pré-endpoint du marchand est relue et son préfixe binaire préservé dans le résultat ;les sources natives,scènes et outils sont identifiés séparément. | Étendre cette traçabilité à chaque reconstruction et à chaque fichier de travail ;les exemples alpha et endpoint ne couvrent pas toute la chaîne d’adoption ni toutes les scènes. |
| SYS-02.4-10 | Les consommateurs Rust chargent le GLB installé et les modèles du catalogue,dont les gardes nom/index/durée. Les scènes Blender sont des sources modifiables ;aucun nouvel export,jeu ou contrôle GPU ne s’est déroulé ici. | Vérifier chaque résultat exporté dans le moteur avec les preuves visuelles,audio et de gameplay pertinentes ;relecture Blender,hash et tests PCM ne valent pas recette après export. |

Reçu : docs/reference_repair_workflow_sources/repair_workflow-links.json. Livraison : docs/fidelity_registry_repair_workflow_links_revision_4_20.json. Les dix tâches et le Goal restent ouverts.
