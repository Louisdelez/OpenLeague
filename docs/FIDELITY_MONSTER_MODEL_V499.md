# SYS-01.2-02 — Modèles des sept monstres Map10, V499

Projet F:/OpenLeague. Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement inconnus ; catalogue4.20.1 distinct. Objectif : relier les exigences aux sources natives et aux consommateurs actuels, avec preuves et limites. Aucun monstre, rendu ou jeu complet n’est déclaré accepté.

## Résultat

Les7fiches PRESENT-MODEL de TT_NGolem, TT_NGolem2, TT_NWolf, TT_NWolf2, TT_NWraith, TT_NWraith2 et TT_Spiderboss sont reliées aux SKN/SKL/INIBIN natifs, aux GLB effectivement référencés par le catalogue courant et aux fonctions existantes de chargement du client.

21liens natifs et56liens consommateurs sont ajoutés, avec7ancres de code et2sources documentaires. Les7questions des agrégats AI V498 restent exactes.7questions propres aux modèles détaillent les vérifications visuelles et d’animation encore nécessaires. Aucun asset ou code de jeu modifié ; aucune reconstruction requise par la comparaison de géométrie dans ce lot.

## Sélection actuelle vérifiée

Le catalogue world_animation_manifest est fusionné dans Catalog et fournit explicitement les7chemins forms/*.glb et leurs échelles. La définition de l’unité choisit le nom du modèle ; le chemin explicite précède le fallback champions/{name}.glb, non exercé ici. Le client demande le premier Gltf.scene et attache cette scène avec WorldAssetRoot, Playback et actor_fow::Root.

La scène0 de chacun des7GLB contient un nœud mesh0/skin0 accessible depuis ses racines ; tous les os de la skin sont accessibles dans ce graphe. La comparaison ne porte donc pas sur un mesh simplement présent mais détaché de la scène choisie. Le fournisseur d’assets réellement ouvert par un exécutable en cours et les pixels GPU restent non observés.

Les fichiers natifs sont ceux cités par l’inventaire d’export conservé, avec confirmation des noms SimpleSkin/Skeleton dans l’INIBIN et comparaison indépendante des octets/valeurs. Le statut historique « exported » de l’inventaire n’est pas une nouvelle exécution du convertisseur. Les sources du convertisseur et de LeagueToolkit expliquent le format et son export ; ce code communautaire ne prouve pas le chargeur historique effectif.

## Comparaison fraîche de géométrie et squelette

| Type | Sommets | Indices | Os natifs / GLB | Format SKL |
| --- | ---: | ---: | --- | --- |
| TT_NGolem |2181|10518|58 /58|legacy2|
| TT_NGolem2 |2181|10518|58 /58|legacy2|
| TT_NWolf |4316|17958|66 /66|modern0|
| TT_NWolf2 |4242|17670|66 /66|modern0|
| TT_NWraith |2503|11730|68 /68|legacy2|
| TT_NWraith2 |2503|11730|68 /68|legacy2|
| TT_Spiderboss |8347|40926|68 /68|modern0|

Total :26273positions de sommets et121050indices de triangles identiques, dans le même ordre.452os comparés :noms, nombres et hiérarchies concordants, sans nom dupliqué ni os manquant détecté. Les poids regroupés par noms d’os uniques ne présentent aucun écart supérieur à1e-5. Cela ne constitue pas une simulation de déformation animée.

Les quatre rigs legacy utilisent le header r3d2sklt/version2. Le lecteur de contrôle est étendu d’après RigResource.ReadLegacy et RigResourceLegacyJoint.Read du Toolkit local :noms,parents,matrices globales3×4 et influencesuint32. Les trois rigs modern0 utilisent les champs TRS et inverse-bind natifs. Les bornes, identifiants, parents et valeurs finies sont contrôlés ; aucun format inconnu n’est remplacé par un squelette fictif.

## Matrices de bind

Les matrices locales et inverse-bind sont comparées avec un calcul indépendant en float64 :TRS colonne pour le format moderne ; inversion du global et transformation relative au parent pour le legacy ; matrices GLB lues en ordre colonne. NumPy2.3.5 et ses binaires sont identifiés dans le reçu, ainsi que Python et le script.

| Type | Écart maximal local | Écart maximal inverse-bind |
| --- | ---: | ---: |
| TT_NGolem /TT_NGolem2 |0,000012999|0,000016029|
| TT_NWolf /TT_NWolf2 |0,000000953|0,000000102|
| TT_NWraith /TT_NWraith2 |0,000013353|0,000017673|
| TT_Spiderboss |0,000014648|0,000000083|

Les452joints restent dans le seuil d’analyse choisi1e-3 ; les écarts effectivement mesurés sont tous inférieurs à0,000018. Ce seuil est un contrôle numérique local, pas une tolérance native de fidélité. Le calcul float64 n’exécute pas le décomposeur float32 du client original, son chargeur, le skinning animé ni le GPU.

## Tailles et modèle partagé des golems

| Type | Échelle catalogue | Correspondance native après castf32 |
| --- | ---: | --- |
| TT_NGolem |1,45|Oui|
| TT_NGolem2 |1,1|Oui|
| TT_NWolf |1,6|Oui|
| TT_NWolf2 |1,0|Oui|
| TT_NWraith |1,5|Oui|
| TT_NWraith2 |1,2|Oui|
| TT_Spiderboss |0,8|Oui|

Les7champs SkinScale sont présents. Pour le grand golem et le petit spectre, les valeurs Python/double ne sont pas littéralement identiques au catalogue ; leurs bits sont identiques après le castf32 effectivement demandé dans le code. Aucun faux défaut de taille n’est ouvert sur cette différence de représentation. Le client applique aussi sa conversion locale0,05 et divise la position monde par20 ; l’apparence finale n’est pas validée par ce seul calcul.

Les deux golems ont des GLB identiques par taille/SHA-256. Leurs SKN et SKL natifs sont également identiques par SHA-256, tandis que les configurations et les échelles1,45/1,1sont distinctes. Cette duplication du contenu GLB ne prouve donc pas un modèle géométrique manquant. Les textures et animations doivent être qualifiées séparément ; elles ne sont pas déclarées identiques par cette seule observation.

## Contrôles réellement exécutés

Commande du collecteur :Python du runtime local, options -X utf8 -E -u -B, script revision499_models.py, sortie revision499_model_inspection/MODEL_OBSERVATIONS.json. Exécution code0, observation passed=true et inputs_preserved=true. Aucun Blender, export d’asset, build du jeu, client ou serveur lancé.

85identités revérifiées.8refus sur copies altérées en mémoire :SKN header/troncature,SKL moderne header/offset de nom,accessor hors bornes,SKL legacy troncature/version/influence invalide. Les assets originaux ne sont pas altérés.

42214instructions comparées :7modifiées,42207inchangées. Les7agrégats AI/questions sont exacts, comme les critères et dépendances.8sélecteurs nominaux et9invalides, plus3refus du lecteur public pour mauvais propriétaire, fausse résolution et condition de résolution absente.

La publication et l’audit indépendant utilisent les quatre registres et le vrai Store.task/copy_text des deux bases. Les42606cases/notes et23historiques sont préservés. Aucun nouveau gameplay ou état manuel accepté.

## Limites et suite

Restent ouverts :fournisseur et chargement effectifs dans le client, poses/animations, skinning dynamique, bornes visibles, culling, facing et apparence finale sur GPU avec comparaison native et validation humaine. La disponibilité et la concordance statique ne prouvent pas le montage natif original ou l’ensemble des overlays.

Textures, mips, matériaux, éclairage, transparence, particules et audio gardent leurs propres fiches. Aucun fichier manquant ou corrompu n’est inventé à partir d’une absence de preuve de rendu. Les dépendances locales d’inventaire/conversion E:/mapslol3v3 et de preuves F:/OpenLeague-work restent identifiées, sans portabilité démontrée.

Préflight, collecteur, préparation et contrôles candidats ont réussi sans nouvel échec. Aucun asset n’est réparé ou réexporté par ce lot.

## Livrables

- docs/reference_monster_behavior_sources/monster-model-v499.json :7associations, sources, comparaison et consommateurs.
- docs/fidelity_monster_model_v499.json :preuve de publication et des bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json :registre enrichi, anciennes questions conservées.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md :couverture et reprise.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision499_model_inspection/MODEL_OBSERVATIONS.json :observations brutes et identités du collecteur.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision499 :baselines, préparation, contrôles candidats, audit et reprise.

Goal SYS-01.2-02 actif. Suite :7fiches PRESENT-TEXTURE des monstres ;comparer DDS natifs,images embarquées,UV et matériaux réellement sélectionnés, sans remplacer des textures existantes avant vérification.

Bilan final vérifié :21liens natifs,56liens consommateurs,7ancres,2sources,7questions ouvertes,0résolution. Graphe :98680sources/2561consommateurs/25788inconnues ouvertes/5517résolues avec historique. Deux bases :8lignes documentaires actualisées,42598autres lignes exactes,42606états/notes et23historiques conservés,intégritéok. Sous-inventaire63à reprendre,445partielles,32exclusions ouvertes ;aucun pourcentage de jeu terminé. Publication et audit réussis.
