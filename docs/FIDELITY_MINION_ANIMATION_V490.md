# SYS-01.2-02 — Animations des huit sbires, V490

24 octobre 2026, F:/OpenLeague. Périmètre : huit fiches WORLD-*-PRESENT-ANIM et leurs sources/consommateurs. Le lot V489 précédent est un progrès vérifié : liens textures publiés et limites conservées. Aucun asset ni code de gameplay modifié ici.

## Résultat attendu et observé

Identifier les animations disponibles, les clips sélectionnés dans les GLB actuels, leurs graphes natifs et le code de lecture ; conserver les écarts et inconnues.

Les **60 ANM disponibles** sont présents dans les huit GLB sélectionnés. Les noms et l'ordre correspondent exactement aux catalogues. Les quatre rôles idle/run/attack/death représentent **32 liens** ; les **28 autres clips importés** n'ont pas de rôle dans ces entrées. Cela ne signifie pas que tous doivent être joués : certains portent le suffixe unused ou correspondent à une variante, un canal ou un masque dont la sélection native reste à qualifier.

| Sbire | Clips natifs/GLB | Rôles actuels | Clips sans rôle |
|---|---:|---:|---:|
| Blue_Minion_Basic | 8 | 4 | 4 |
| Blue_Minion_Wizard | 8 | 4 | 4 |
| Blue_Minion_MechCannon | 7 | 4 | 3 |
| Blue_Minion_MechMelee | 9 | 4 | 5 |
| Red_Minion_Basic | 6 | 4 | 2 |
| Red_Minion_Wizard | 7 | 4 | 3 |
| Red_Minion_MechCannon | 6 | 4 | 2 |
| Red_Minion_MechMelee | 9 | 4 | 5 |

**346 485 échantillons de vecteurs de poses locales** ont été comparés : translations et échelles identiques pour les canaux exportés, rotations normalisées comparées en tenant compte de l'équivalence q/-q. Sur 59 clips, les écarts de composantes de rotation sont de l'ordre de 1e-7. Les temps des clés sont rapprochés de l'image native la plus proche et leur erreur est enregistrée ; cette mesure ne valide pas toute interpolation continue, le skinning ou la pose en coordonnées monde.

## Écarts précis conservés ouverts

- `blueminion_wizard_bbs` : 15 images natives, 14 exportées ; dernière clé à environ0.433333s. Le calcul float32 `(int)(fps * duration)` du convertisseur produit14.
- `Red_Minion_MechCannon_Run` : 29 images natives, 28 exportées ; dernière clé à environ0.870968s. Même effet de troncature du produit float32. Ce clip est sélectionné par le rôle run actuel.
- `Blue_Minion_MechCannon_Run_Harrowing` : écart maximal de composante de quaternion d'environ1.13439, malgré l'équivalence de signe prise en compte ; exemples sur `L_thumb_a` dès l'image0. Ce clip n'a pas de rôle courant dans le catalogue examiné. La cause et l'effet visuel restent ouverts ; le lot ne réexporte pas l'asset.
- 22 occurrences de pistes natives, réparties sur six clips, ne ciblent aucun os du GLB. Les mêmes hashes sont absents du squelette natif sélectionné : ce constat ne prouve pas une perte introduite par le seul export. Variantes Harrowing, BBS et Idle sont détaillées dans le reçu.
- Des hashes de pistes dupliqués sont présents dans les animations du Blue_Minion_Basic et dans huit clips du Red_Minion_MechMelee. Le lecteur communautaire retient la dernière piste de même hash ; la comparaison ne qualifie pas les identités dupliquées. L'anomalie de squelette BlueBasic V488 reste intacte.

## Graphes natifs et horloges

Les huit INIBIN nomment explicitement `MeshSkin.Animations`. Les huit graphes correspondants et quatre alternatives MeshSkin1/2 ont été lus, soit **12 BLND**. Les chemins exacts et les autres fichiers restent recensés ; la priorité effective du chargeur natif n'est pas déduite du nom du fichier.

Les arêtes directes des nœuds de type1 relient noms d'états et ressources ANM. Chaque graphe configuré possède aussi un nœud `Run` de type4 ; son comportement de mélange reste opaque dans ce lecteur. Le rôle run actuel sélectionne directement une ANM : cela ne démontre pas la reproduction du mélange natif.

Les champs sérialisés de début, fin et pas temporel sont conservés séparément des durées du Toolkit et de la dernière clé GLB. Par exemple, Run_RAW du mage bleu porte un pas0.025 et une plage0–30, celui du canon bleu un pas0.02, celui du mage rouge un pas proche de1/60. Les ANM correspondantes et leur GLB ont une dernière clé proche de0.967742s. Ces écarts demandent une qualification de l'horloge native ; aucun facteur de vitesse n'est inventé ici. Les sondes historiques du moteur sur les structures ne sont pas réutilisées comme preuve d'exécution sur ces sbires.

Les graphes peuvent également porter une borne différente du nombre d'images de l'ANM, par exemple le BBS du mage bleu. Aucune durée native finale n'est déduite de `frameCount/fps` seul.

## Consommateurs actuels

- data/4.20/world_animation_manifest.json : identité du GLB, liste de clips et quatre rôles par sbire.
- crates/client/src/animation.rs : demande du modèle, graphe construit depuis les clips du parent GLB, résolution des indices de rôle, branche des unités du snapshot.
- La présentation générique des sbires détecte l'augmentation de `next_attack` et ouvre une fenêtre locale de12ticks ; attaque puis déplacement/repos selon l'état, mort et étourdissement ont leurs branches. Cela n'est pas une preuve de l'état machine natif.
- Les transitions de rôle utilisent80ms. Un rôle absent ne démarre aucun clip. Repos et course sont répétés par la branche générique.
- crates/client/src/structure_animation_clock.rs et data/4.20/structure_clip_playback.json : aucun override pour ces huit sbires. Les horloges BLND relevées ici ne sont pas consommées par cette table.
- Sources LeagueToolkit UncompressedAnimationAsset, QuantizedQuaternion et Elf ; StructureExport et SimpleSkinGltfExtensions : formats ANM3/4/5, hashes, normalisation et rééchantillonnage. Ce code communautaire ne remplace pas une exécution du moteur historique.

## Vérifications et conservation

1. Lecture des60ANM, canaux GLB, squelettes et catalogues ; comparaison des clés locales et identification des ressources par chemin/taille/SHA.
2. Six refus du collecteur sur copies en mémoire : signature ANM invalide, version non prise en charge, ANM tronquée, nœud GLB hors table, en-tête BLND invalide, BLND tronqué. Aucun original modifié. Ces refus concernent les lecteurs de preuve, pas le moteur historique.
3. Neuf sélecteurs nominaux, dix sélecteurs invalides et trois refus du lecteur public pour propriétaire incorrect, fausse résolution et condition absente.
4. Comparaison de42 214 instructions : huit changées,42 206 identiques. Critères, dépendances et tous les préfixes documentaires antérieurs conservés.
5. Publication puis audit indépendant des quatre registres et deux bases : neuf lignes documentaires actualisées par base,42 597 autres lignes identiques,42 606 états/notes et23 entrées d'historique préservés.

Aucun nouveau build, lancement du client, Bevy AnimationPlayer, GPU, audio ou code natif exécuté. Les observations sont des comparaisons statiques Python et des lectures de sources. Aucun succès de parseur ne vaut acceptation globale de l'animation.

## Livrables et suite

- docs/reference_minion_behavior_sources/minion-animation-v490.json : associations natives, consommateurs et questions propres aux huit fiches.
- docs/fidelity_minion_animation_v490.json : preuve de publication.
- Les quatre registres de fidélité/tâches, docs/coverage.json, completion_plan.json, resume_checkpoint.json et notes docs/ai/CURRENT.md/HANDOFF.md sont enrichis en conservant les preuves antérieures.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision490_animation_inspection/ANIMATION_OBSERVATIONS.json et GRAPH_OBSERVATIONS.json : observations originales.
- Même racine, revision490/ : préparation, contrôle candidat, audit des bases, inventaire restant et checkpoint. Scripts revision490_animations.py, revision490_graphs.py, revision490_delivery.py, revision490_check.py et revision490_finish.py.

Suite : poursuivre les fiches de présentation des sbires encore ouvertes, en particulier audio et projectiles, puis consolider leurs agrégats en respectant leurs prérequis. Les travaux de fidélité graphique restent ouverts : variantes, mélange, clocks, événements, squelettes et rendu. Sous-inventaire lié au chargeur :143 fiches à reprendre,373 partielles,24 exclusions antérieures dont12audio. Il ne représente pas la totalité du reste du jeu. Goal actif, aucune case cochée automatiquement.

Bilan enregistré : 88 liens natifs, 88 liens consommateurs, 8 nouvelles ancres, 3 sources et 8 questions ouvertes. 143 fichiers directement épinglés. Graphe : 98660 sources, 2532 consommateurs, 25708 questions ouvertes, 5517 résolues avec historique.
