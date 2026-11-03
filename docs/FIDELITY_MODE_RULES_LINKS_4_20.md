# V93 — Sources des règles par mode (LoL 4.20)

Périmètre : SYS-01.2-02, liens précis pour les cinq exigences SYS-11.3. Ce lot établit la traçabilité de sources et de consommateurs actuels ; il ne termine ni les règles des modes ni les recettes du jeu. Les cinq exigences restent ouvertes et aucune case utilisateur n’est cochée.

## Sources et méthode

Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Neuf exports AIR vérifiés contre leurs deux bibliothèques originales et le manifeste lol_air_client0.0.1.119. Quinze luaobj relus intégralement : cinq LevelScript, huit variantes de rappel et deux buffs. Chacun correspond au manifeste de projet sélectionné. Les analyses AIR existantes sont relues, pas redécompilées. Aucun programme historique, AIR ou jeu local n’est exécuté.

52 fichiers épinglés,174 contrôles source,14 ancres de consommateurs actuels,33 cas du lecteur dont32 refus. Les refus couvrent les identités, les conclusions inventées, les ancres, les inconnues et deux copies Lua invalides en mémoire. Les sources originales ne sont pas modifiées. Le lecteur relit les empreintes avant de réutiliser son cache.

Code actuel et nouvelles preuves : F:/OpenLeague. Les manifestes récupérés conservent leurs chemins historiques E, explicitement désignés en lecture seule dans docs/project_location.json. Le catalogue copié sur F est comparé à celui de référence ; l’origine F du vérificateur est contrôlée. Les anciennes sources et leurs historiques gardent leurs identités.

## Sélection des champions

GameTypeConfig distingue SimulPickStrategy, DraftModeSinglePickStrategy, AllRandomPickStrategy, TournamentPickStrategy, OneTeamVotePickStrategy et AllTeamVotePickStrategy. Les timers, pools, bans, duplicatePick et allowTrades sont des déclarations de DTO. GameTypeConfigManager reçoit une liste, refuse de la remplacer par null et recherche par id ; il ne fournit pas les configurations serveur historiques.

GameUpdateCommand tient compte d’exclusivePick pour les équipes visibles ; SetVisibleChampionsCommand applique crossTeamChampionPool à ses filtres. ChampionSelectionControllerNew n’active le contrôleur d’échanges qu’en post-sélection, hors spectateur, avec allowTrades et un mode draft/tournament/all-random. Cela qualifie ces branches d’interface, pas l’ordre serveur des picks ni les valeurs de timers EUW.

Le launcher actuel play/join_local valide champion et sorts puis appelle le superviseur local. Simulation::join limite à six joueurs, équilibre deux équipes et utilise champion_spawns_map10.json. Ces entrées ne constituent pas une sélection historique blind/draft complète.

## Équipes et fin de partie

Les cinq LevelScript possèdent TEAM_ORDER=100 et TEAM_CHAOS=200. Le reçu conserve les fonctions de niveau sélectionnées, leurs lignes d’origine, constantes et instructions. La liaison d’un nom à son prototype provient des instructions adjacentes CLOSURE/SETGLOBAL, sans exécuter de callback.

Map8 et Map12 contiennent CloseShop et INPUT_LOCK_SHOP dans EndOfGameCeremony ; leurs ScoreboardPhase contiennent EndGame. Ce contexte est distinct de la condition qui déclenche la victoire. Les fonctions de niveau des autres cartes restent des pistes pour leurs appels effectifs ; leur présence ne qualifie pas une partie.

Le monde local charge Map10 ; damage_unit fixe winner=1-team lors de la destruction du Nexus. Aucune équivalence générale entre les modes ne découle de cette branche.

## Rappel, régénération et boutique

| Script natif | ChannelDuration initial |
|---|---:|
| Recall |8|
| RecallImproved |7|
| OdinRecall |4.5|
| OdinRecallImproved |4|
| ShowdownRecall |6|
| ShowdownRecallImproved |5.5|
| SuperRecall |4|
| SuperRecallImproved |4|

ChannelDuration est une globale initiale, pas un champ de SpellData. Son unité effective, le choix de variante, l’interruption et le déplacement doivent rester liés au contrôleur serveur : ce lot n’exécute pas ce contrôleur et ne fixe pas une disponibilité par mode.

Map12 OnLevelInitServer référence ApplyAramBuffs ; ce prototype référence ApplyPersistentBuffToAllChampions, HowlingAbyssAura et AramShopDisableNoParticle. Les deux luaobj de buffs ne contiennent aucun prototype enfant : ils fournissent des métadonnées et PersistsThroughDeath=true. Le nom d’un buff ne prouve pas son effet serveur. De même, CloseShop dans EndOfGameCeremony ne prouve pas une restriction d’achat durant le match.

Dans le code actuel, Action ne déclare pas de variante Recall (constat limité à cette enum). advance_regeneration traite les champions vivants ; shop_guard vérifie fin de match, vie et distance à la boutique alliée. buy_item applique map10_available quand le monde est actif. Ces frontières doivent être remplacées ou complétées par les consommateurs adaptés aux autres modes après qualification de leurs règles.

## Récompenses et recettes

EndOfGameStats expose gameLength, invalid, ipEarned, experienceEarned, bonus et plafonds custom/coop. Il s’agit de champs, pas d’une formule de calcul. Aucune durée minimale d’admissibilité n’est établie : minimum_eligible_duration reste null.

MatchResult local capture score, inventaire et gold_remaining après winner. L’or restant dans la partie n’est pas une récompense de compte. Le test actual_nexus_death_captures_terminal_results_after_dependency_chain injecte des dégâts de1_000_000 ; il reste un test de contrat et n’est pas une recette ordinaire complète. Ce test n’a pas été exécuté pendant ce lot.

GameQueueConfig et PracticeGameConfig portent la séparation carte/mode/mutateurs/configuration. La matrice EUW retenue, ses payloads effectifs, les récompenses et les recettes complètes restent à établir. Aucune matrice de couples n’est inventée à partir de la seule présence de fichiers.

## Vérifications, erreurs conservées et limites

Deux noms de constantes de vote supposés ont été corrigés d’après l’export réel (PICK_MODE_VOTE_PICK et PICK_MODE_ALL_VOTE_PICK). La première relecture du reçu a refusé les clés numériques de tables Lua après sérialisation JSON ; le reçu préparatoire est conservé, la normalisation explicite ajoutée, puis la collecte et les33cas ont réussi. Des chemins de modules protocol et ClientLibEndOfGame supposés étaient absents : recherche poursuivie dans core/lib.rs et l’inventaire réel des exports, sans conclusion d’absence globale de fonction.

La publication ne modifie que les liens, recherches et consignes de ces cinq tâches et du Goal, dans les registres et les deux bases. États manuels, notes, historique, drapeaux de validation et preuves antérieures sont conservés. Aucun code/asset du jeu n’est modifié ; aucun résultat de rendu, de gameplay ou de réseau n’est annoncé.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-11.3-01 | GameTypeConfig distingue six stratégies de sélection et des champs de timers/pools/bans. GameTypeConfigManager conserve les configurations reçues ; les contrôleurs AIR appliquent exclusivePick,crossTeamChampionPool et allowTrades. Le launcher local accepte champion et sorts puis join répartit les joueurs sans protocole blind/draft identifié dans ces entrées. | Retrouver les payloads GameTypeConfig effectifs de chaque file EUW, les séquences de bans/picks/timers et les refus serveur ; qualifier leur consommateur local. Les constantes et branches AIR ne fournissent pas ces valeurs serveur. |
| SYS-11.3-02 | Les cinq LevelScript sont des membres exacts de la référence ; les constantes TEAM_ORDER/TEAM_CHAOS et fonctions de niveau sont relevées. Les cérémonies Map8/Map12 et leurs ScoreboardPhase sont distinguées des conditions qui déclenchent la victoire. join local limite six joueurs et équilibre deux équipes avec spawns Map10 ; world fixe winner après destruction du Nexus. | Qualifier équipes,départs et conditions de victoire par couple carte-mode retenu, avec les appels serveur effectifs. La cérémonie de fin ne prouve pas les règles de victoire ; les équipes 0/1 locales ne constituent pas un contrat universel pour tous les modes. |
| SYS-11.3-03 | Huit variantes de Recall portent ChannelDuration global initial8,7,4.5,4,6,5.5,4,4. Map12 lie ApplyAramBuffs à deux buffs ; leurs luaobj ne déclarent que métadonnées et persistance. CloseShop/INPUT_LOCK_SHOP appartiennent à EndOfGameCeremony Map8/Map12. Les consommateurs locaux exposent Action, régénération et boutique Map10, pas une politique par mode qualifiée. | Relier la sélection des rappels, interruptions/téléportation et effets des buffs aux contrôleurs natifs ; qualifier restrictions de rappel,régénération et achats pour chaque mode. Ne pas déduire une interdiction depuis le nom du buff ni depuis CloseShop en fin de partie. |
| SYS-11.3-04 | EndOfGameStats déclare gameLength,invalid,ipEarned,experienceEarned,bonus et limites custom/coop. Ces champs reçus ne sont pas une formule ni un seuil. MatchResult local capture score,inventaire et gold_remaining après winner ; cet or de partie ne prouve pas une récompense de compte. | Retrouver le calcul natif/service des récompenses et seuils d’admissibilité avec unités, files et exceptions ; relier au consommateur de compte local. Garder durée minimale inconnue ; ne pas inventer un seuil depuis un DTO. |
| SYS-11.3-05 | GameQueueConfig et PracticeGameConfig séparent carte,mode,mutateurs,taille et configuration. Le démarrage serveur courant charge Map10 ; le test de résultat détruit les structures avec dégâts injectés et ne constitue pas une recette ordinaire multi-mode. Les sources de niveau sont identifiées sans exécution. | Établir la matrice carte-mode retenue et une recette ordinaire par couple, du lobby au résultat avec preuves visuelles, gameplay et réseau ; conserver les tests de contrat sans les transformer en recettes complètes. |

Reçu : docs/reference_mode_rules_sources/mode_rules-links.json. Livraison : docs/fidelity_registry_mode_rules_links_revision_4_20.json. Les cinq tâches et le Goal restent ouverts.
