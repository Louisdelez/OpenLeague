# SYS-01.2-02 — sélection Classique 5v5 et ARAM, V457

MODE-CLASSIC-5V5-SELECT, MODE-ARAM-SELECT et leur union SYS sont reliés aux contrats de sélection du client AIR 4.20 et aux points d'entrée actuels. Dix-sept liens vers six consommateurs existants sont ajoutés ; aucun nouveau consommateur ni comportement de jeu. Les sources ObjectCFG et l'ancien chargeur Map10 sont conservés avec leur portée limitée.

## Contrat et origine

Référence : PUBLIC 4.20.0.315 EUW/en_GB, build littéral du 17 novembre 2014 à 17:46:45 ; fuseau et déploiement non établis. AIR : bibliothèques de la release 0.0.1.119. Les exports existants sont relus et comparés à l'index d'extraction ; aucune nouvelle décompilation ou exécution AIR. Quatre fichiers sont vérifiés contre le manifeste original par chemin, release du membre, taille et MD5, puis SHA-256 :

| Bibliothèque | SHA-256 |
|---|---|
| ClientLibDomain.dat | 31d7fc4597de774fa643a2789fbdc9202a48f4cd8c01449a3c642bbd5b27336e |
| ClientLibGame.dat | 72ec60851e9ab4570d0d02587327c65fab45e9f932beb52950accd9b98dd26f9 |
| ClientLibChampionSelectionCore.dat | e757c10e659493bf6fc280dae70c2e2f46d18152ffa5d85046b772de30910be5 |
| mod/ser/mod_ser.dat | 8628abec247eb498752ad6314c65a25d0b6174c69fcad6390c94d3d09bff6206 |

GameMap distingue Map11 et Map12 ; GameMode distingue CLASSIC et ARAM. StandardGameFlowVariant utilise un mode par défaut selon la carte ; GameFlowVariantFactory tient aussi compte des mutateurs et des variantes de contenu. Ces constantes et branches ne prouvent pas une file EUW active ou son payload historique.

GameQueueConfig sépare cartes prises en charge, mode, taille et gameTypeConfigId. MasterGameController.startChampionSelect résout la configuration depuis currentGame.gameTypeConfigId via GameTypeConfigManager, puis le générateur la transmet au modèle de sélection. Le manager conserve la liste reçue ; une liste nulle est signalée, et une configuration introuvable retourne la valeur nulle après journalisation. Cette lecture statique ne démontre pas le refus serveur d'une sélection.

GameTypeConfig déclare notamment SimulPick, DraftModeSinglePick et AllRandom, ainsi que les pools, doublons, échanges et timers. Le champ initial DraftModeSinglePick n'est pas un payload historique. GameUpdateCommand utilise exclusivePick ; SetVisibleChampionsCommand utilise les pools d'équipe ; ChampionSelectionControllerNew consomme pickMode et allowTrades. Les 37 fenêtres de méthodes entourant 48 ancrages sont conservées, avec les identités complètes des 14 exports.

Pour ARAM, startReroll lit pointSummary du participant local dans les deux équipes. useReroll émet une demande via le provider ; RerollServiceImpl appelle lcdsRerollService.roll sans argument de choix du champion. Les exceptions NoRollsRemainException et GameException sont routées vers le callback fourni. Cela ne récupère ni le tirage serveur, ni son pool, son coût, ses plafonds ou les échanges réellement autorisés. Le nom ARAM et PICK_ID_RANDOM=4 ne suffisent pas à les établir.

## Fonctions actuelles et portée

Les six consommateurs réutilisés sont les commandes launcher play et join_local, Simulation.join, join_with_summoners, la branche JoinResumable de Host et l'initialisation Map10 du serveur. Leurs identifiants et portées antérieures restent intacts. Le chargeur enable_map10 déjà lié est inspecté séparément et conservé.

Le launcher transmet le champion et deux sorts. join_with_summoners refuse la paire de sorts dupliquée ; Simulation.join vérifie le champion, refuse une partie terminée ou six joueurs déjà présents, équilibre les deux équipes et utilise les spawns Map10. Ces corps ne réalisent pas une sélection Classic5v5 ou ARAM complète. Les chaînes de refus sont des constats de code, pas des tests de gameplay nouvellement exécutés. Aucune absence globale de code n'est conclue d'une recherche lexicale.

Les tâches SCOPE préalables restent a_faire. Les phases et lots n'ajoutent pas de dépendance pour cette inspection de sources ; aucune disponibilité historique n'est implicitement validée. La portée est l'association SYS-01.2-02, pas l'implémentation des deux tâches SELECT.

## Vérifications et livraison

Préparation, publication et audit séparé : code 0, commandes consignées dans ROOT_COMMAND_OBSERVATIONS.json. Trente et une identités ciblées ; trois sélecteurs nominaux ; six sélecteurs incorrects refusés. Le lecteur de manifeste refuse trois cas : mauvais projet, mauvaise release du membre, membre absent. Ce sont des contrôles documentaires, pas des simulations des règles de sélection.

Delta reconstruit depuis sauvegardes : un reçu, dix-sept liens, trois fiches ; 42 211 autres exigences actives identiques. Anciens enregistrements source/consommateur, statuts et flags conservés ; listes précédentes conservées comme préfixes ; inconnues identiques en octets.

Deux bases réelles : Store.task, Store.copy_text, requirement_trace.resolve et make_instruction relisent chacune les trois fiches ; 42 606 états/notes et 23 historiques préservés ; 42 603 autres lignes de catalogue identiques ; intégrité SQLite ok. Les contrôles lisent en mode=ro/query_only. Sauvegardes avant les trois remplacements JSON et les deux transactions SQLite, sans atomicité globale revendiquée.

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et trois lignes tasks par base. Ajoutés : reçu sous docs/reference_mode_selection_sources/, preuve JSON et ce rapport. Couverture, plan et reprise actualisés avec sauvegardes. Aucun code ou asset de jeu modifié, aucun build Rust, VM, AIR, jeu, GPU ou service réseau exécuté.

Les inconnues OLU-c5b106ba-7169-5c11-9a4d-6df8d02534a6 et OLU-3f7054d2-a8dd-5dae-b657-d440c259ee54 restent ouvertes. Restent à qualifier les configurations effectives EUW, séquences de sélection, effectifs, bans, timers, pools et relances, puis leurs consommateurs de jeu. Aucune case ni acceptation automatique ; SYS-01.2-02 et le goal restent ouverts.

Preuves détaillées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision457/SOURCE_LINK_RECEIPT.json, PREPARATION.json, DELIVERY_AUDIT.json et ROOT_EXECUTION_RECEIPT.json.
