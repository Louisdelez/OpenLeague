# SYS-01.2-02 — Ciblage et poursuite des monstres Map10, V496

Projet F:/OpenLeague. Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement inconnus ; catalogue4.20.1 distinct. Travail limité aux associations sources/consommateurs et à leurs preuves. Aucune acceptation de monstre, de partie ou de jeu complet.

## Intégration

Les14fiches AI-CIBLE et AI-POURSUITE des7types TT_NGolem, TT_NGolem2, TT_NWolf, TT_NWolf2, TT_NWraith, TT_NWraith2 et TT_Spiderboss sont reliées aux points précis de provocation, conservation de cible, frontière d’acquisition, seuil de retour, restauration de santé, choix de destination et mouvement.

Une nouvelle ancre documentaire identifie le choix de destination déjà implémenté : la position de cible est demandée lorsque la cible dépasse attack_range+rayon ; pathfinding puis repli sur un point praticable précèdent le déplacement. Aucun code du moteur n’a été changé. La garde de l’attaque engagée de Vilemaw est ajoutée seulement à ses deux fiches. Les anciens liens restent en préfixe et conservent leur qualification ; une entrée de chargement ne vaut pas preuve de sélection.

63liens natifs,73liens consommateurs dont1ancre nouvelle,3sources documentaires et14questions propres ouvertes. Les14fiches de camps V481 et14fiches SOURCE/AI-MORT V495 restent exactement inchangées avec leurs questions.

## Sources vérifiées maintenant

Six scripts natifs sont réidentifiés et reparsés : Leashed, Aggro, Idle, AIComponentSystem, AIComponentOutOfCombatRegen et NeutralMinionSpawn. Les fonctions, mots d’instructions, constantes et empreintes concordent avec les observations conservées. Leashed.FindNewTarget référence notamment FindTargetNearPosition et LEASH_RADIUS ; cette fonction et ses helpers ne démontrent pas le choix effectif de script par le moteur historique.

Les98champs de profils des7INIBIN sont relus : présence et valeur restent identiques, y compris les champs AI absents. Les valeurs475 d’acquisition locales des wolves/wraiths restent distinctes d’un champ natif retrouvé. La valeur native d’un rayon, le helper de sélection et la règle locale de retour ne sont pas interchangeables.

Les78cas Lua avec adaptateurs et les112scénarios CPU V481,272contrôles de membres et2attaques engagées Vilemaw sont réidentifiés, avec leurs scripts, ressources, outils, binaires et journaux. **Ils ne sont pas rejoués dans V496.** La sélection effective des scripts, le scheduler natif et les aides du moteur restent non qualifiés.

## Nouvelle exécution CPU

Une nouvelle sonde Rust est compilée puis exécutée avec la bibliothèque coreV476, après vérification de l’égalité de toutes les entrées du build et des outils. Le core n’est pas recompilé. Les codes de sortie de compilation et d’exécution sont0. Le reçu CURRENT_MONSTER_AGGRO_PRIORITY.json identifie exactement bibliothèque, compilateur, sonde, binaire et ressources par taille/SHA-256.

112scénarios :7camps×2équipes×8profils.272membres sont contrôlés à l’événement et après un appel advance. La grille de navigation et le scheduler de camps sont réels. Préparation contrôlée : saut à l’échéance initiale du camp, six Annie rejointes, positions proches du camp, échéance next_ai repoussée et attaques NPC inhibées. Les dégâts passent par apply_damage. Tibbers est créé par apprentissage et lancement publics de AnnieR ; sa position est ensuite contrôlée. Les deux dégâts comparés sont injectés avant le poll d’IA suivant. Cela ne simule pas une partie ordinaire ou un ordre réseau complet.

| Profil | Attendu local | Observé |
| --- | --- | --- |
| Deux joueurs de la même équipe | Le second dégât positif remplace la cible de tous les membres vivants et réveille next_ai=0 | Identique |
| Second joueur de l’équipe opposée | Même remplacement ; pas de préférence locale pour l’équipe du premier agresseur | Identique |
| Dégât sans source après joueur | Cible initiale et échéance différée conservées | Identique ; dégât accepté |
| Dégât0 attribué au second joueur | Santé non réduite, cible initiale et échéance différée conservées | Identique ; ce n’est pas un refus de l’API |
| Dégât par structure d’équipe sans propriétaire | Cible initiale et échéance différée conservées | Identique ; dégât accepté |
| Tibbers réel après joueur | Le pet devient la cible du groupe, son propriétaire n’est pas substitué comme cible | Identique |
| Propriétaire après son pet | Le joueur redevient la cible après son dégât positif | Identique |
| Second joueur forcé mort | API directe accepte la source, groupe la cible immédiatement ; au poll suivant elle est rejetée et la santé du groupe est restaurée | Identique ; politique des appelants ordinaires non démontrée |

| Type | Contrôles de membres frais |
| --- | ---: |
| TT_NGolem |32|
| TT_NGolem2 |32|
| TT_NWolf |32|
| TT_NWolf2 |64|
| TT_NWraith |32|
| TT_NWraith2 |64|
| TT_Spiderboss |16|

Total272, réparti sans doublon par définition. Les indices des112cas uniques et identifiants de membres permettent la relecture exacte. Les deux types d’un même camp partagent certains scénarios ; leurs nombres de scénarios par profil ne doivent pas être additionnés comme des exécutions indépendantes.

## Poursuite et limites

La preuve V481 conserve les cas de proximité seule, dégâts sans source, cible morte/retirée, distance propre au home exactement800 puis801 et cible distante2000. Les monstres mobiles conservent la cible distante tant que leur propre position reste dans la politique locale de retour ; cela ne prouve pas l’issue d’une poursuite complète.

Vilemaw est stationnaire dans la définition actuelle. Sans attaque engagée, une cible hors portée est écartée. Les deux attaques engagées V481 restent une exception locale documentée : départ18001, coup accepté18031 malgré déplacement de cible, reset18033. Elles n’ont pas été rejouées ici. La nouvelle sonde inhibe les attaques NPC et ne peut pas remplacer cette preuve ni prouver toutes les annulations.

Restent ouverts, explicitement dans chaque fiche :

- Montage natif des scripts, helpers FindTargetNearPosition, priorités historiques, compteurs et règles de réacquisition.
- Politique ordinaire des sources de dégâts, notamment source morte et contrôle des appelants. Un appel API accepté ne qualifie pas une attaque de joueur.
- Zone admissible native, distances et horloges effectives. Le seuil local800 et les paramètres de fonctions natives distinctes restent séparés.
- Trajets complets, obstacles, interruption/reprise, arrivée au point d’origine et reset de tous les effets, timers et orientations.
- Sorts spéciaux de Vilemaw, rendu, animation, audio, réseau et validation humaine en partie réelle.
- Dépendances locales aux preuves privées F:/OpenLeague-work et au buildV476 ; portabilité non démontrée.

Aucun fichier manquant ou asset corrompu n’est déduit d’une absence de preuve de runtime. Les14questions V495 et14questions V481 sont préservées, sans résolution automatique.

## Contrôles du plan

42214instructions comparées :14modifiées,42200inchangées. Les28fiches héritées, leurs questions, les conditions de fin et les dépendances sont exactes.1304identités de fichiers revérifiées.15sélecteurs nominaux et16invalides ;20refus du collecteur, dont18scripts altérés et2sélections de profil ;3refus du lecteur public pour mauvais propriétaire, fausse résolution et condition de résolution absente.

Les deux bases sont contrôlées avec le vrai Store.task/copy_text en lecture seule après publication et lors de l’audit indépendant. Les42606cases/notes et23historiques doivent rester exacts. Aucun test du client graphique ou du serveur historique exécuté ; aucune case cochée.

## Historique conservé

La compilation, l’exécution, la collecte et les contrôles candidats V496 ont réussi sans réparation de gameplay. Les deux anciens essais V481 refusés restent disponibles avec leurs journaux : attente incorrecte de soin immédiat sans source et construction f32 du seuil800. Ils ne deviennent pas des succès V496 et les observations V481 ne sont pas réécrites.

## Fichiers modifiés et preuves

- docs/reference_monster_behavior_sources/monster-target-pursuit-v496.json :14associations, sources, observations, cas exacts par définition et limites.
- docs/fidelity_monster_target_pursuit_v496.json :preuve de publication et des bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json :registre et questions.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md :couverture et reprise.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision496_runtime_checks :sonde, binaire, commandes, journaux et112nouveaux cas.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision496 :baselines, préparation, contrôles candidats, audit, sauvegardes et point de reprise.

Aucun code ou asset du jeu modifié. Goal SYS-01.2-02 actif. Suite :fiches AI-ATTAQUE et AI-RESET des7monstres, sources des attaques et preuve de retour complet distincte d’un simple reset de santé/cible.

Bilan final vérifié :63liens natifs,73liens consommateurs,1ancre,3sources,14questions ouvertes,0résolution. Graphe :98674sources/2543consommateurs/25760inconnues ouvertes/5517résolues avec historique. Deux bases :15lignes documentaires actualisées,42591autres lignes exactes,42606états/notes et23historiques conservés,intégritéok. Sous-inventaire91à reprendre,417partielles,32exclusions ouvertes ;aucun pourcentage de jeu terminé. Publication et audit réussis.
