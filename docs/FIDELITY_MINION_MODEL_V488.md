# SYS-01.2-02 — Modèles des huit sbires, V488

Le 24 octobre 2026, contrôle de traçabilité sur F:/OpenLeague. Périmètre : huit fiches WORLD-*-PRESENT-MODEL, leurs sources 4.20 et leurs consommateurs actuels. Cette livraison ne répare aucun asset et ne valide pas le jeu complet.

## Résultat et anomalie

Les huit SKN natifs, les huit SKL, leurs huit INIBIN et les huit GLB réellement sélectionnés ont été relus. Les 14 813 positions de sommets et les indices, dans leur ordre, correspondent exactement. Cette égalité ne démontre pas les matrices de bind, les poses animées ni le résultat visuel.

| Modèle | Sommets | Os natifs | Os GLB |
|---|---:|---:|---:|
| Blue_Minion_Basic | 1861 | 53 | 52 |
| Blue_Minion_Wizard | 1471 | 56 | 56 |
| Blue_Minion_MechCannon | 1826 | 49 | 49 |
| Blue_Minion_MechMelee | 2831 | 58 | 58 |
| Red_Minion_Basic | 1358 | 52 | 52 |
| Red_Minion_Wizard | 1360 | 57 | 57 |
| Red_Minion_MechCannon | 1494 | 45 | 45 |
| Red_Minion_MechMelee | 2612 | 62 | 62 |

**Écart conservé ouvert :** Blue_Minion_Basic possède deux os natifs `F_gown_a`, IDs 29 et 30, qui influencent respectivement 33 et 11 sommets à poids positif. Le GLB contient un seul os de ce nom. La relation parent de l'os 30 vers l'os 29 est perdue. La comparaison des poids regroupés par nom passe à 1e-5, mais masque cette fusion d'identités. Le code du convertisseur Toolkit réutilise explicitement un nœud de même nom. Cela explique le mécanisme possible sans constituer une preuve de recette binaire d'export. L'impact sur les poses et animations reste à mesurer.

Les sept autres modèles ne présentent pas d'écart de nombre, de noms ou de parents des os dans cette comparaison. Ce constat n'est pas une acceptation complète de leurs squelettes.

SkinScale vaut explicitement 0.9 dans les INIBIN des sbires de mêlée et mages des deux équipes ; les catalogues actuels correspondent. Ce champ est absent pour les quatre canons/supers : la valeur locale 1.0 ne prouve pas le défaut du moteur historique. OverrideBoundingBox est absent des huit fichiers examinés.

## Sources et consommateurs

- Référence native : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy, DATA/Characters de chaque sbire. Les chemins, tailles et SHA exacts figurent dans le reçu.
- Ressources sélectionnées : F:/OpenLeague/assets/forms/{blue,red}_minion_{basic,wizard,mechcannon,mechmelee}.glb. Les anciens fichiers forms/mobs ne sont pas les modèles sélectionnés ici.
- data/4.20/world_animation_manifest.json et map10_world.json : noms, chemins et échelles concordants pour les huit entrées.
- crates/client/src/animation.rs : fusion du catalogue monde, demande du GLB explicite, lecture de l'échelle, attente de la première scène et ajout du WorldAssetRoot.
- crates/client/src/main.rs : identité du modèle issue de la définition, conversion des positions par /20, échelle finale du nœud multipliée par 0.05.
- E:/mapslol3v3/StructureExport/Program.cs, tools/export_animated_map_assets.py et sources LeagueToolkit : provenance historique et explication du convertisseur communautaire, pas code natif de Riot.

Sept nouvelles ancres précises sont ajoutées, sans supprimer les anciennes. Huit questions propres aux modèles sont ouvertes. Aucun défaut n'est déclaré résolu.

## Vérifications exécutées

1. Lecture statique SKN 2.1, SKL moderne version 0, INIBIN et GLB ; comparaison des positions, indices, noms, parents et influences par nom. Les formats non couverts ne sont pas inventés.
2. Cinq refus sur copies en mémoire : en-tête SKN incorrect, SKN tronqué, en-tête SKL incorrect, déplacement de nom SKL hors limites, accessor GLB hors limites. Les originaux restent identiques.
3. Sélecteurs nominaux des huit fiches et de SYS-01.2-02, dix sélecteurs invalides refusés ; trois refus du lecteur public pour mauvais propriétaire de question, résolution sans preuve et condition absente.
4. Comparaison de 42 214 instructions actives : huit changées, 42 206 identiques. Préfixes de sources, consommateurs, questions, critères et dépendances antérieurs conservés.
5. Publication puis audit indépendant des quatre registres et des deux bases SQLite. Neuf lignes documentaires par base, incluant SYS ; états/notes des 42 606 tâches et 23 entrées d'historique conservés exactement, ainsi que les 42 597 autres lignes.

Aucun nouveau build, lancement client, rendu GPU, audio ni exécution du moteur historique. L'exécution concerne Python, les lecteurs, les registres et SQLite. Les exécutables Python, scripts et ressources sont identifiés dans EXECUTION_ENVIRONMENT.json et les reçus.

## Échecs et corrections du contrôle

- Premier collecteur : tentative de conversion float(None) sur SkinScale absent. L'échec est conservé dans revision488_model_failure01.py ; la correction distingue champ absent et valeur locale. Aucun défaut natif n'a été inventé.
- Une tentative de modification via python -c a été refusée par le parseur PowerShell avant changement ; modification ensuite faite par fichier.
- Première préparation : ancre `.insert(name.clone(), entry.clone());` ambiguë entre production et test, refus avant création du dossier de préparation et avant publication. Copie revision488_prepare_failure01.py conservée ; ancre remplacée par la validation unique du catalogue monde, avec le contexte de fusion immédiatement suivant.

## Fichiers et preuves

- docs/reference_minion_behavior_sources/minion-model-v488.json : associations et sources exactes.
- docs/fidelity_minion_model_v488.json : preuve de publication.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json : registres enrichis.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md : reprise mise à jour avec sauvegardes.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision488_model_inspection/MODEL_OBSERVATIONS.json : observation originale, conservée avec task_registered=false au moment de sa création.
- Même racine, revision488/ : préparation, contrôle candidat, audit de livraison, inventaire restant et checkpoint. Scripts revision488_models.py, revision488_delivery.py, revision488_check.py et revision488_finish.py.

## Limites et suite

L'identité dupliquée de Blue_Minion_Basic doit être préservée lors d'une future réparation d'asset, puis comparée par matrices et poses. Les textures, UV, normales, matériaux et animations doivent être tracés dans leurs fiches dédiées. Le chargement réel et l'apparence en jeu restent non observés ici. L'absence de SkinScale pour quatre modèles reste une inconnue native. L'appartenance effective aux projets RADS n'est pas requalifiée par cette lecture des fichiers disponibles.

Le sous-inventaire de fiches liées au chargeur comporte désormais 159 fiches à reprendre et 357 partielles, avec 24 exclusions antérieures dont 12 audio. Il ne représente pas le reste de tout le jeu et une fiche à reprendre peut déjà contenir des liens précis antérieurs. Le Goal SYS-01.2-02 reste actif ; aucune case manuelle cochée et aucune acceptation globale.

Bilan enregistré : 24 liens natifs, 63 liens consommateurs, 7 nouvelles ancres, 2 sources et 8 questions ouvertes. 73 fichiers directement épinglés. Graphe : 98651 sources, 2518 consommateurs, 25692 questions ouvertes, 5517 résolues avec historique.
