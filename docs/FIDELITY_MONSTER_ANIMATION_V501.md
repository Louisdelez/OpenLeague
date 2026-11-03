# SYS-01.2-02 — Animations des monstres Map10, V501

25 octobre 2026 — F:\OpenLeague. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue officiel 4.20.1 distinct.

## Résultat

Sept fiches WORLD-<nom>-PRESENT-ANIM sont reliées aux ressources natives et aux consommateurs courants inspectés. Les 131 fichiers ANM sont présents dans les sept GLB sélectionnés, avec les mêmes noms et le même ordre que le catalogue. Le lecteur compare 1 716 771 vecteurs de poses locales. Translations et échelles comparées sont exactes. Les 572 257 quaternions comparés après normalisation des deux côtés et équivalence de signe concordent à moins de 4e-8 par composante.

Des limites concrètes restent ouvertes : quatre dernières clés non représentées chez les loups ; quaternions non unitaires dans les GLB des golems ; sélection native, horloges, interpolation, skinning et rendu effectif non qualifiés. Aucun asset ni code du jeu n'est modifié. Les sept questions d'animation sont propres à leurs tâches ; les 21 questions antérieures sur modèles, AI et textures restent exactes et ouvertes.

## Sources et vérification nominale

Ressources du deploy fourni : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\<nom>. Pour chaque monstre, le reçu identifie par chemin/taille/SHA les INIBIN et SKL sélectionnés, tous les ANM et le BLND configuré. Les identités des sept GLB, du catalogue data/4.20/world_animation_manifest.json et des consommateurs existants sont vérifiées. Les entrées de phase/lot sont consignées sans les déclarer achevées.

Le collecteur revision501_animations.py reprend le lecteur analytique ANM avec support du SKL legacy2 ou modern0 pour ce lot. Les 84 ANM3 et 47 ANM4 observés sont comparés aux canaux GLB LINEAR et à leurs clés locales ; les temps sont rapprochés de la frame native la plus proche, avec l'écart temporel consigné. Les valeurs de quaternion sont comparées en acceptant q et -q. Cette méthode n'évalue pas toutes les phases d'interpolation, les poses mondiales ou la déformation du mesh. Aucune exécution du client historique, du lecteur Bevy ou d'un GPU n'est revendiquée.

Les 131 clips exposent 33 rôles dans le catalogue : six par golem, quatre pour chacun des quatre autres monstres mobiles, cinq pour Vilemaw. Les 98 clips sans rôle catalogue ne sont pas automatiquement 98 actions manquantes. La nécessité et la sélection de chaque variante doivent être établies par le graphe et les producteurs réels.

Sept BLND configurés sont relevés : 88 nœuds de type1, 12 de type2 et un de type3. Le lecteur borné relève les ressources et champs start/end/step des nœuds type1 ; les autres charges utiles restent opaques. Leur présence ne prouve pas leur machine d'états ou leurs choix aléatoires. Le champ MeshSkin.Animations sélectionne un fichier par profil ; la priorité du fournisseur natif, le cache et les overlays ne sont pas réexécutés.

Les pistes natives sans cible GLB sont toutes également absentes du rig sélectionné pour le clip concerné. Les rigs des sept modèles n'ont pas de collision de hash de noms dans cette comparaison. Ce constat ne transforme pas ces pistes en os manquants et ne qualifie pas toutes les règles natives d'animation partielle.

## Écarts analysés

Pour TT_NWolf et TT_NWolf2, GiantWolf_SpellCast et Wolf_SpellCast contiennent chacun 63 frames natives, mais 62 frames sont représentées dans les GLB : la frame terminale 62 n'est pas couverte. Le compte reproduit par int(f32(fps×duration)) du convertisseur vaut également 62. Les quatre clips ne sont associés à aucun rôle actuel du catalogue. Leur présence et leur absence de clé finale restent deux faits séparés ; aucun impact en partie n'est déduit sans producteur et lecture effective.

La première comparaison conserve un écart allant jusqu'à 0.06937861442565918 entre rotations natives normalisées et valeurs GLB brutes pour dix clips de chacun des deux golems. revision501_rotation.py compare ensuite les deux côtés normalisés : l'écart maximal des golems descend à 3.517935986963039e-8 par composante. La norme des quaternions GLB atteint néanmoins 1.0936206392210488. Les orientations locales proches après normalisation ne valident donc pas les valeurs brutes ou leur interpolation.

Le convertisseur Toolkit local actuel contient Quaternion.Normalize et des refus pour rotation invalide. Son code présent n'est pas la preuve du binaire qui a produit ces GLB historiques. Le loader Bevy 0.19.0 verrouillé relève les rotations avec Quat::from_array ; la suite de la chaîne, son traitement des quaternions non unitaires et son rendu restent à qualifier. Aucun fichier n'est corrigé sur la seule foi de cette explication numérique.

Pour Golem_Run, l'ANM a 41 frames à 30 fps et le GLB un endpoint d'environ 1.333333373 s. Le BLND Run sérialise start0/end40/step0.0142857143655, soit un span calculé d'environ 0.571428575 s. Ces champs et bornes distincts sont conservés ; le span calculé ne devient pas une durée native acceptée sans exécution de l'horloge correspondante. Aucun override structure_animation_clock n'existe pour ces sept modèles.

## Consommateurs actuels

La chaîne catalogue → requête d'asset → scène actor_fow déjà identifiée en V499 est réutilisée. Sept ancres communes précisent la construction du graphe avec tous les clips chargés, la résolution des rôles, les entrées NPC de mouvement/stun, le refus de rôle absent, la transition de 80 ms, la politique de répétition et le contrôle de l'horloge des structures.

Deux ancres supplémentaires sont limitées aux six monstres mobiles : hausse de next_attack ouvrant une fenêtre locale de 12 ticks, puis choix générique attaque/run/idle. Les golems possèdent des rôles spell1/2, mais ces noms ne prouvent pas un producteur de sorts NPC.

Cinq ancres sont limitées à Vilemaw : réception dans main.rs, observation ordonnée et validation commune dans garen_w_live.rs, sélection d'une durée chargée valide dans vilemaw_attack_animation.rs, liaison au corps dans animation.rs et repli idle de sa branche déplacement en absence de rôle run. Son lecteur utilise le journal d'identité d'attaque, l'âge EffectClock et la durée du clip chargé. Il ne reçoit pas les deux liens de fenêtre générique des mobiles. Il représente actuellement l'attaque Basic/role attack ; WebReel/Smash importés ne qualifient pas tous les sorts ou variantes natives.

Ces liaisons sont établies par identité des fichiers et ancre ligne/texte vérifiée. Elles ne sont pas une observation fraîche des joueurs Bevy ou du serveur en partie. Les critères et dépendances des sept tâches restent conservés.

## Cas et contrôles exécutés

| Cas | Attendu | Observé |
|---|---|---|
| Sept modèles et leurs clips | Source/GLB/catalogue identifiés sans inventer d'absence | 131 clips, noms et ordre concordants |
| Échantillons locaux | Couvrir les clés et mesurer les écarts | 1 716 771 vecteurs ; translations/échelles exactes, écarts et clés terminales consignés |
| Contrôle des rotations | Distinguer orientation normalisée et données brutes | 572 257 quaternions comparés ; orientation normalisée <4e-8, données non unitaires des golems laissées ouvertes |
| Graphes | Identifier le fichier configuré et limiter l'interprétation | Sept BLND, nœuds type1 relevés, types2/3 opaques |
| ANM/GLB invalides | Refus explicites sur copies mémoire | Huit refus : signature, version, troncature, nœud cible, zéro piste legacy, offset palette, interpolation, index sampler |
| BLND invalides | Refuser en-tête et données tronquées | Deux refus |
| Quaternions invalides | Refuser zéro et non fini | Deux refus |
| Contrat du registre | Refuser mauvais propriétaire, fausse résolution, condition vide | Trois refus publics en mémoire ; état restauré |
| Instructions | Conserver les tâches non ciblées | 42 214 comparées : sept changées, 42 207 identiques |
| Héritage | Préserver modèles/AI/textures et leurs questions | 21 fiches et 21 questions exactes |

Les commandes Python -X utf8 -E -u -B réellement exécutées sont revision501_animations.py, revision501_graphs.py, revision501_rotation.py, revision501_delivery.py prepare, revision501_check.py, puis publication et audit. Chaque processus fait l'objet d'une observation de son code terminal. Python, les scripts, les sources Toolkit et la dépendance Bevy sont identifiés ; aucune nouvelle compilation du jeu ou preuve GPU n'est annoncée.

Deux lectures exploratoires ont essayé des noms inexistants : vilemaw_animation.rs et session_state.rs. La recherche réelle des fichiers a trouvé vilemaw_attack_animation.rs, garen_w_live.rs et les consommateurs de main.rs/animation.rs. Ces noms erronés ne sont pas utilisés comme preuve d'une implémentation absente. La lecture Git avec accès F a réussi ; aucun stage/reset/commit ou changement de configuration n'est effectué.

## Livrables, reprise et limites

Les quatre registres docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json reçoivent les associations. Les deux bases locales sont actualisées par leurs lecteurs réels Store.task/copy_text/requirement_trace, avec contrôle des états, notes et historiques. docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md reçoivent le résultat vérifié et la suite.

Reçu public : docs/reference_monster_behavior_sources/monster-animation-v501.json. Preuve : docs/fidelity_monster_animation_v501.json. Observations privées : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision501_animation_inspection\ANIMATION_OBSERVATIONS.json, GRAPH_OBSERVATIONS.json et ROTATION_NORMALIZATION.json. Sauvegardes, préparations, vérification du candidat, audit, environnement et point de reprise : revision501\. Les scripts revision501_animations.py, revision501_graphs.py, revision501_rotation.py, revision501_delivery.py, revision501_check.py et revision501_finish.py conservent la méthode exécutée.

Les sept questions restent ouvertes : native sélection/horloge/interpolation, valeurs de quaternion, événements et variantes, skinning et rendu effectif. Les données de présence et comparaisons statiques ne prouvent pas une présentation complète, un son, une mécanique de sort ou une acceptation humaine. Aucune case ni tâche n'est déclarée terminée. Le Goal SYS-01.2-02 reste actif.

Suite : sept fiches PRESENT-AUDIO des monstres ; rechercher les banques et événements natifs et le consommateur sonore réellement appelé, sans confondre banque présente et producteur audible. Préserver les questions d'animation, notamment les quatre clés terminales des loups et les quaternions/horloges des golems.

| Profil | Clips | Rôles | Sans rôle catalogue | Dernières clés non représentées |
|---|---:|---:|---:|---:|
| TT_NGolem | 15 | 6 | 9 | 0 |
| TT_NGolem2 | 15 | 6 | 9 | 0 |
| TT_NWolf | 21 | 4 | 17 | 2 |
| TT_NWolf2 | 21 | 4 | 17 | 2 |
| TT_NWraith | 13 | 4 | 9 | 0 |
| TT_NWraith2 | 18 | 4 | 14 | 0 |
| TT_Spiderboss | 28 | 5 | 23 | 0 |

Bilan final vérifié : 152 liens natifs, 101 liens consommateurs, 14 ancres, 4 sources et 7 questions ouvertes ; aucune résolution. 227 identités vérifiées. Graphe : 98687 sources / 2581 consommateurs / 25802 questions ouvertes / 5517 résolues avec historique. Deux bases : 8 lignes documentaires actualisées chacune, 42 598 autres lignes exactes ; 42 606 états/notes et 23 historiques conservés, intégrité ok. Collecte, graphes, contrôle des rotations, préparation, candidat, publication et audit : codes terminaux 0 observés. Sous-inventaire : 49 à reprendre, 459 partielles et 32 exclusions ouvertes ; ce n'est pas un pourcentage de jeu terminé.
