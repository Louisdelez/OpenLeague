# Forêt torturée 3v3 : sources, consommateurs et limites — V505

25 octobre 2026 — `F:\OpenLeague` — SYS-01.2-02. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; littéral de build 2014-11-17 17:46:45, fuseau et date de déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat

Les quatre fiches MODE-TT-3V3 SCOPE/SELECT/RULES/RESULT sont reliées aux sources natives/AIR et aux consommateurs actuels précis. Trois scénarios CPU contrôlés passent : admission/remplacement des six joueurs, résultat de victoire de l’équipe 0 et résultat de victoire de l’équipe 1 avec stockage immuable.

Ces fiches restent ouvertes. Une admission locale à six joueurs, des dégâts serveur injectés et un résultat écrit sur disque ne démontrent ni les files historiques EUW, ni la sélection avec bans/échanges, ni une partie complète et son retour au launcher. Les critères, dépendances, required/required_if, cases, notes et historiques sont conservés. Aucun code de production ou asset distribué n’a été modifié.

## Sources réellement examinées

La collecte fraîche du lecteur `audit_mode_rules_reference.py` réalise 174 contrôles et relit neuf classes AIR, les LevelScript sélectionnés et leurs métadonnées. Sept classes AIR supplémentaires précisent Map10, les cartes/files activées et les réponses attendues : GameMap, PlatformConfigController, GameQueueManager, GameMapEnabledDTO, ClientSystemStatesNotification, GameMapServiceImpl et MatchMakerServiceImpl.

Chaque export AIR est réidentifié par taille/SHA et relié au DAT original et au manifeste de release AIR 0.0.1.119. Les exports ne sont pas redécompilés dans V505. Le LevelScript Map10 est vérifié dans le projet RADS sélectionné ; ses constantes d’équipes 100/200 et fonctions nommées restent des sources, pas des callbacks exécutés dans le moteur historique. Le décodage/interprétation de métadonnées Lua par le lecteur existant reste distinct d’une exécution du jeu natif.

GameMap déclare TWISTED_TREELINE_ID=10. Les branches AIR reçoivent des cartes activées et des IDs de files, ou demandent getGameMapList/getAvailableQueues ; le chemin d’erreur de GameQueueManager vide sa liste. Aucun payload de disponibilité EUW daté n’est récupéré par ce travail. GameTypeConfig contient plusieurs stratégies, timers et propriétés de sélection ; les branches de bans/picks/échanges ne fournissent pas les valeurs effectivement reçues pour une file Map10 donnée. EndOfGameStats contient des champs de gains de compte et de durée : ces champs ne donnent pas leur formule ou leur seuil d’admissibilité.

Les cinq fiches SYS-11.3 précédemment reliées au référentiel de règles et leurs questions restent exactes. Les ressources de rappel et buffs d’autres modes lues par le lecteur commun ne sont pas présentées comme politiques actives de Map10.

## Associations par fiche

| Fiche | Source 4.20 et consommateur actuel | Limite conservée |
|---|---|---|
| SCOPE | 10 liens natifs supplémentaires : déclarations/branches AIR et LevelScript Map10 ; World historique et bootstrap explicite du serveur courant | Carte présente et démarrage local distincts de files EUW ouvertes à une date établie |
| SELECT | 6 liens natifs supplémentaires : GameTypeConfig/manager, contrôleurs de sélection, visibilité/pool, configuration de file ; commandes Tauri play/join_local et Simulation::join | Roster/sorts et équilibrage locaux ne qualifient pas bans/picks/trades/timers/ownership et payload serveur |
| RULES | 2 liens natifs supplémentaires : GameMode et LevelScript Map10 ; World, protection des structures, régénération et boutique actuels | Dépendances locales vérifiées ; restrictions natives spécifiques, rappels, régénération et achats restent à qualifier |
| RESULT | 2 liens natifs supplémentaires : EndOfGameStats et LevelScript Map10 ; capture du résultat, stockage serveur, dispatch, UI et retour/sortie du launcher | Résultats CPU contrôlés distincts de partie ordinaire, récompenses de compte et retour GUI observé |

Le lien World historique est conservé dans les quatre listes brutes. Pour SELECT et RESULT, `enable_map10` est explicitement hors portée de la sélection et des résultats : le lecteur public affiche les consommateurs précis ajoutés et garde World parmi les références hors portée. Son rôle global n’est pas modifié. SCOPE et RULES conservent World comme consommateur partiel de leur contexte de carte.

Treize ancres nouvelles identifient les vrais chemins : bootstrap serveur ; play/join_local du launcher ; join du core ; protected, régénération, shop_guard ; capture_final_results ; result_store::save et son dispatch serveur ; summary de l’UI ; return_button du client ; observation de sortie normale et drain du launcher. Les lignes/aiguilles/identités et portées sont dans le reçu. Les branches UI/launcher et la régénération/boutique sont lues, pas exécutées dans cette sonde.

## Exécutions CPU : attendu et observé

Sonde fraîchement compilée avec la bibliothèque core V476, réutilisée seulement après vérification des sources, ressources, bibliothèques et toolchain enregistrés. Le vrai module actuel `crates/server/src/result_store.rs` est compilé dans cette sonde et appelé directement ; aucun processus serveur, Tauri ou client n’est démarré.

| Scénario | Attendu du contrat courant | Observé |
|---|---|---|
| Admission | Champion inconnu refusé sans mutation ; six Garen admis en équipes 0/1/0/1/0/1 ; septième refusé sans mutation ; après départ d’un joueur équipe 0, remplaçant équipe 0 | Conforme ; `unknown champion` et `3v3 lobby full` ; duplicats acceptés localement, sans qualification de politique native |
| Victoire équipe 0 | Nexus protégé refuse les dégâts ; chaîne T2_L_02 → T2_L_01 → Barracks_T2_L1 → T2_C_01 → HQ_T2 ; capture du résultat à six joueurs | Conforme ; winner=0, Nexus de l’équipe 1 identifié |
| Victoire équipe 1 | Nexus protégé refuse les dégâts ; chaîne T1_L_02 → T1_C_06 → Barracks_T1_L1 → T1_C_01 → HQ_T1 ; capture du résultat à six joueurs | Conforme ; winner=1, Nexus de l’équipe 0 identifié |

Pour chaque victoire : pas de résultat dans les six snapshots avant fin ; résultat exact et identique pour les six vues après fin ; aller-retour JSON exact ; même résultat après départ d’un joueur et changement de l’or vivant ; 100 avances ne changent pas le tick terminal ; join/command/damage refusés après fin. Le winner résulte réellement de la mort du Nexus, pas d’une affectation directe.

Les destructions utilisent néanmoins des appels serveur publics apply_damage avec 1 000 000 de dégâts vrais. Les joueurs sont six Garen, sans partie ordinaire ni sélection historique. Les transitions ont lieu au tick 0 du scénario contrôlé : aucune durée admissible ni récompense de compte n’en est déduite.

Le stockage produit exactement deux JSON dans le répertoire de preuves, un par session 505000/505001. Chaque écriture est relue ; répétition identique acceptée, remplacement contradictoire refusé avec AlreadyExists et octets inchangés. Ce contrôle couvre l’appel local du module, pas les retries du vrai processus, les accès concurrents, une panne disque ou le retour GUI.

## Échecs conservés et corrections de montage

Trois exécutions de sonde : deux échouées et une réussie. Les trois compilations terminent à 0. Le premier Rust termine à 101 : la sonde avait supposé un nom T1_L_01 symétrique de T2_L_01, absent de la configuration actuelle. Le deuxième Rust termine à 101 sur Turret_T1_C_06 : les noms étaient corrigés, mais leur ordre de dépendances était inversé. La configuration réelle impose T1_L_02 avant T1_C_06. La seconde reprise respecte les deux chaînes et termine à 0 avec trois scénarios complets. Aucune de ces corrections ne modifie le jeu.

Les sources, exécutables, entrées, journaux et résultats partiels des deux échecs restent dans revision505_runtime_checks et revision505_runtime_checks_retry. Le résultat 505000 écrit dans chacun reste une sortie partielle ; aucun reçu global de réussite n’est inventé pour ces tentatives. La réussite distincte est dans revision505_runtime_checks_retry2.

Une commande de génération inline a été refusée par le parsing PowerShell avant exécution de Python et avant écriture ; une génération via fichier a ensuite été employée. La compilation du finaliseur préparé a aussi refusé un mot-clé dupliqué avant toute écriture du finaliseur ou du projet ; son compteur a été renommé et le corps initial conservé. Des chemins exploratoires supposés absents ont été remplacés par les chemins trouvés avec l’inventaire rg ; aucune absence de fonctionnalité n’est déduite de ces erreurs de recherche.

## Contrôle du registre et limite de la preuve de portée

Le premier contrôle candidat a échoué avec AssertionError: wrong_excluded_consumer. Il attendait à tort que le lecteur générique refuse toute substitution d’un consommateur déjà présent dans la fiche. Ce lecteur contrôle la forme, l’appartenance et la présence d’une preuve ; il ne juge pas automatiquement sa pertinence sémantique.

La reprise conserve ce constat et l’ancien script. Elle démontre séparément : six refus génériques (fausse déclaration de feature, preuve de portée manquante, consommateur non membre, sur les deux fiches) ; deux refus par la garde de livraison ciblée lorsque l’exclusion est changée de World vers un consommateur pertinent déjà membre. Dans ces deux cas, l’acceptation générique de métadonnées est enregistrée explicitement ; elle n’est pas renommée refus. La garde attend exactement les exclusions World prévues par le reçu, et la publication/audit compare également les documents attendus aux documents réels. Le lecteur générique n’est pas corrigé par V505 et sa limite reste documentée.

Le candidat compare 42214 instructions : 4 changent, 42210 restent exactes. Il contrôle les critères/dépendances/required_if, les cinq fiches héritées et trois refus publics de propriétaire/statut/condition des inconnues. La préparation vérifie neuf sélecteurs invalides. Les quatre nouvelles questions restent ouvertes ; aucune des anciennes n’est résolue.

## Identités et preuves

Bibliothèque réutilisée : libopenleague_core.rlib V476, SHA256 `2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c`. Reprise réussie mode_tt_probe.exe : 6540800 octets, SHA256 `4fe30a4448dce0885c41071dedf299e1c011f811ef4d3f9c93d0bd43c13962b5`. Observation CPU : 36816 octets, SHA256 `fd955de1acdf983e8987677a817c233dfbc82ea820e9729abacc1ee88d40f9e9`. Reçu CURRENT_TT_MODE.json : 251995 octets, SHA256 `823aac2ef443bded59c761a95534c6ba9f5017f54dfa643c579dff77fdf19e47`.

Observation de sources : TT_MODE_OBSERVATIONS.json, 459173 octets, SHA256 `bd961c301738a6c6b1042aac955de58666340e817d5d48494c8f933bb137eae3`. 1325 identités sont revérifiées dans le candidat. Commandes réellement lancées avec Python -X utf8 -E -u -B : trois wrappers runtime, collecteur inspection, delivery prepare, premier check en échec puis check corrigé, delivery publish et audit. Les commandes rustc et exécutions exactes, logs, codes, entrées et identités du toolchain sont conservés dans les dossiers des tentatives.

## Livraison et reste ouvert

Rapport docs/FIDELITY_TT_MODE_V505.md ; reçu docs/reference_mode_rules_sources/tt-mode-v505.json ; preuve docs/fidelity_tt_mode_v505.json. Quatre registres et deux bases du plan actualisés avec la couverture et la reprise, en conservant les acquis V504 et antérieurs. Sources/scripts/exécutions détaillés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision505*.

Restent ouverts : payloads historiques EUW de cartes/files et GameTypeConfig, sélection complète/ownership/bans/picks/timers/trades, restrictions natives de Map10, règles de récompenses de compte et de durée, comportement ordinaire du vrai serveur/client, retour GUI et fidélité humaine. Les règles locales et métadonnées native/AIR servent à progresser avec les sources disponibles ; elles ne comblent pas automatiquement ces manques. Le Goal SYS-01.2-02 reste actif.

Bilan vérifié : 20 liens natifs, 27 liens consommateurs, 13 ancres, 7 sources et 4 questions ouvertes ; aucune résolution. 1325 identités revérifiées. Graphe : 98702 sources / 2608 consommateurs / 25827 questions ouvertes / 5517 résolues avec historique. Deux bases : 5 lignes documentaires chacune, 42601 autres lignes exactes ; 42606 états/notes et 23 historiques conservés, intégrité OK. Collecte/préparation/candidat repris/publication/audit terminaux 0 ; premier candidat 1 conservé, sans écriture des registres. Trois compilations de sonde 0 ; Rust 101, 101, puis 0 avec trois scénarios complets. Sous-inventaire : 24 à reprendre, 477 partielles, 39 anciennes lignes exclues encore ouvertes ; les deux exclusions World de tâches partielles sont comptées séparément. Aucun pourcentage de jeu terminé.
