# SYS-01.2-02 — Positions agrégées et cycles des bâtiments, V478

Les18 fiches STRUCTURE-00..17-POSITION et les18 fiches STRUCTURE-00..17-CYCLE sont enrichies dans les registres et les deux bases du plan. Chaque fiche possède ses sources, consommateurs, preuves et limites propres. Les72 questions des fiches enfants V476/V477 sont conservées sans changement de propriétaire ni de statut. Aucune fiche de bâtiment n'est déclarée acceptée ou complète.

Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build du2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague.

## Fiches de position agrégées

Chaque fiche récapitulative relie les quatre enfants équipe/voie, position/hauteur, orientation/volume de clic et protection. Les preuves d'initialisation et de protection V476/V477 sont héritées, identifiées et conservées ; elles ne sont pas présentées comme relancées dans ce lot.

La réunion de ces liens ne prouve pas l'alignement visuel et le fonctionnement combiné en partie. Les conventions natives d'équipe/voie, les18 hauteurs modifiées par la grille, Move/Rot, la pose finale, SelectionHeight, le fallback local160, les dépendances et le timer natif restent ouverts. Les questions enfants sont conservées telles quelles ; la fiche agrégée possède sa propre question sur la qualification de l'ensemble.

## Cycles réellement exécutés

Un nouveau programme Rust a été compilé et exécuté contre la bibliothèque coreV476, après revalidation de toutes ses entrées enregistrées, de son identité et des outils. Il n'y a pas de nouveau cargo build du cœur. Les entrées et dépendances épinglées sont inchangées après exécution ; les commandes, journaux, bibliothèque et binaire du programme sont identifiés dans le reçu.

Chaque instance est examinée dans une simulation distincte avec six Garen fixes, trois par équipe, au tick100. Le programme choisit un joueur adverse et détruit récursivement les dépendances locales requises avant la cible, avec apply_damage et1million de dégâts vrais. Il n'assigne pas directement leur santé à zéro. Ces dégâts directs ne sont pas des commandes d'attaque, des projectiles ou une partie ordinaire.

| Instance visée | Destructions dans sa chaîne locale | Résultat spécifique |
| --- | ---: | --- |
| Barracks_T1_L1 | 3 | Mort au tick100 ; mort à7299, santé maximale à7300, même identifiant |
| Barracks_T1_R1 | 3 | Mort au tick100 ; mort à7299, santé maximale à7300, même identifiant |
| Barracks_T2_L1 | 3 | Mort au tick100 ; mort à7299, santé maximale à7300, même identifiant |
| Barracks_T2_R1 | 3 | Mort au tick100 ; mort à7299, santé maximale à7300, même identifiant |
| HQ_T1 | 5 | Vainqueur/résultat figés ; dégâts et mouvement refusés après fin |
| HQ_T2 | 5 | Vainqueur/résultat figés ; dégâts et mouvement refusés après fin |
| Turret_ChaosTurretShrine | 0 | Dégâts refusés ; état de l’unité inchangé |
| Turret_OrderTurretShrine | 0 | Dégâts refusés ; état de l’unité inchangé |
| Turret_T1_C_01 | 4 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T1_C_06 | 2 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T1_C_07 | 2 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T1_L_02 | 1 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T1_R_02 | 1 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T2_C_01 | 4 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T2_L_01 | 2 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T2_L_02 | 1 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T2_R_01 | 2 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |
| Turret_T2_R_02 | 1 | Morte encore présente après un tick ; aucun timer de retrait/réapparition |

Les scénarios produisent42 événements létaux au total, certaines dépendances étant examinées dans plusieurs simulations. Les42 gains d'or sont comparés aux valeurs de la configuration courante pour les six joueurs : prime locale au tueur et or global à son équipe, aucun gain adverse attendu. Cela ne qualifie ni l'économie native ni toutes les règles d'expérience, d'attribution et de bonus.

Pour les quatre inhibiteurs, respawn_at=100+240×30=7300. Le programme saute explicitement au tick7298, avance à7299 où l'inhibiteur est encore mort, puis à7300 où sa santé maximale revient et son timer s'efface. Le déplacement X et l'identité sont conservés. Ce saut ne simule pas les240 secondes d'une partie complète.

Pour chaque Nexus, la chaîne locale termine la partie au profit de l'autre équipe. Le résultat contient le bon Nexus, son équipe et sa pose, six joueurs et ended_tick=100. La sérialisation/désérialisation du résultat est exacte ; un mouvement et de nouveaux dégâts sont refusés avec match ended. Un advance supplémentaire conserve le tick et le résultat. Cela ne couvre pas toutes les commandes, sessions, interfaces ou nettoyages possibles.

Les dix tours restent mortes après un tick et n'ont aucun timer de retrait ou de réapparition. Les deux fontaines refusent les dégâts et conservent leur état sérialisé ; leur destruction n'est pas démontrée comme événement ordinaire atteignable. Leur asset détruit éventuel ne change pas cette conclusion.

## Sources natives et présentation

Les fichiers SCO et INIBIN de chaque définition sont identifiés. Les dix fonctions déjà recensées du LevelScript et les trois fonctions EndOfGameCeremony, DestroyNexusPhase et ScoreboardPhase sont reparsées et comparées aux empreintes/constantes conservées. Aucun de ces callbacks n'est exécuté dans le moteur Riot pour ce lot.

Le rapport existant map10_inhibitor_timer_source_audit.json distingue toujours240 secondes de suspension de génération des sbires et un délai natif de réapparition de l'inhibiteur non qualifié. Le nouveau chemin F de ce rapport est enregistré avec sa propre identité ; la référence historique reste conservée. La même valeur numérique ne résout pas la différence de sémantique.

Les24 alias visuels intacts/détruits sont relus : identité des GLB, noms de clips et indices de rôles valides, politiques d'horloge conservées. Le client remplace le modèle lors du changement d'état ; le Nexus dispose également d'un remplacement piloté par le résultat figé et l'horloge de cérémonie lorsque les snapshots ordinaires cessent d'évoluer. Les ancres de demande/chargement/maintien de pose sont reliées seulement dans leur portée examinée.

Aucun rendu de débris, transition animée, son, effet ou cérémonie n'est observé ici. Le son reste une limite ouverte ; la présence des fichiers ou des consommateurs de modèle ne vaut pas preuve audio. Pour les fontaines, le lien de cycle expose la protection et le refus de dégâts, sans présenter une branche visuelle théorique comme une destruction exécutée.

## Vérification et conservation

- 18 scénarios d'instance,42 événements létaux,4 réapparitions,2 fins de partie et2 refus de fontaine : réussis.
- 42 comparaisons des récompenses d'or pour six joueurs ; refus de dégâts sur les cibles mortes et, pour les Nexus, refus après fin.
- 4 refus du sélecteur de source : instance inconnue, dupliquée, définition absente, catégorie non supportée.
- 37 sélecteurs nominaux,38 invalides ;3 refus publics de propriétaire, résolution indue et condition de résolution vide.
- 42 214 textes comparés :36 modifiés,42 178 identiques. Les72 fiches enfants et leurs questions restent identiques.
-Publication puis audit indépendant des quatre registres et des deux bases :37 fiches/base ;42 606 états/notes,23 historiques et42 569 autres lignes du catalogue conservés exactement ; intégrité SQLite correcte.
- 98 fichiers directement épinglés, plus les entrées du programme CPU et ses dépendances. La validation de structure du graphe ne remplace pas la vérification des empreintes.

Deux préparations ont été refusées avant création du lot et avant mutation des bases : rapport de timer pas encore indexé à son chemin F, puis lecture de remove_at dans la sérialisation de Unit qui l'omet. Le collecteur enregistre désormais le rapport F explicitement et lit remove_at dans l'observation dédiée du programme. Les sources des deux essais et leurs diagnostics sont conservés. Aucun correctif de gameplay ne résulte de ces ajustements.

## Livrables, limites et suite

Les36 questions propres au lot restent ouvertes. Il manque la qualification native des cycles, récompenses/expérience, timers, transitions et conséquences ainsi que l'observation ordinaire des attaques, animations, effets, sons et cérémonie. Les vérifications CPU de ce lot sont volontairement identifiées avec leurs entrées contrôlées ; aucune acceptation humaine, native ou globale n'en est déduite.

Fichiers modifiés : les quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json ; les deux bases locales du plan ; docs/coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de production, asset, case, note ou historique manuel n'est modifié.

Reçu : docs/reference_structures_sources/instance-aggregate-cycles-v478.json. Preuve : docs/fidelity_structure_instance_aggregate_cycles_v478.json. Scripts, journaux, binaire et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision478* ; reçu d'exécution CURRENT_STRUCTURE_CYCLES.json sous revision478_runtime_checks.

Les108 fiches STRUCTURE de ce sous-inventaire ont maintenant des liens plus précis et des limites propres ; cela ne clôture aucune de leurs validations de fidélité. Le sous-inventaire global du chargeur contient286 associations encore à examiner,230 partiellement qualifiées et24 exclusions de portée conservées. Il ne mesure pas la complétion du jeu. La suite porte sur les63 fiches de camps : composition, positions, premier spawn, réapparition, aggro, récompenses et cycle. Goal actif.

Ajouts vérifiés :200 liens natifs,361 liens consommateurs,7 ancres,3 sources,36 questions ouvertes ;0 résolution.
