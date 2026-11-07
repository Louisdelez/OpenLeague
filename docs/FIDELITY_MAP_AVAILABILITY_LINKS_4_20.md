# Disponibilité des cartes et modes — liens V91

Les six exigences SYS-11.1 reçoivent des sources précises et18 rôles actuels. Les18 rôles sont explicitement des frontières : validation de date, contrat local de services et démarrage du serveur surMap10. Aucun n'est présenté comme une implémentation des autres cartes ou une preuve de leur ouverture historique. Les six tâches et le Goal restent ouverts.

## Sources et vérifications

44 sources identifiées,134 contrôles source et38 cas de qualification du lecteur dont37 refus attendus. Les13 exports AIR sont reliés à quatre bibliothèques originales conformes au manifeste0.0.1.119. Leurs empreintes correspondent au registre d'exports existant ; aucune nouvelle décompilation ou exécution AVM2 n'est revendiquée. Les LevelScript de Map1,Map11,Map8 etMap12 correspondent aux projets sélectionnés du client natif. Leur présence établit une ressource livrée, pas la disponibilité d'une file.

Les cinq sources d'identité du jeu sont relues par reference_client.validate(verify_native=True). Deux appels supplémentaires refusent un fuseau ou un déploiement inventé. local_services_reference.assess distingue le périmètre local du backend Riot et refuse une famille inconnue. Ces trois refus exercés sur les vrais lecteurs sont distincts des37 mutations du reçu du nouveau lecteur.

## Cartes et files

GameMap déclare notamment Map1,Map11 shipping,Map13 WIP,Map8 Crystal Scar,Map12 Howling Abyss et sandbox90. GameMode associe Dominion à ODIN et ARAM à ARAM. Un nom SHIPPING ou une constante ne date pas son activation.

PlatformConfigController consomme gameMapEnabledDTOList. Sans cette liste, il demande gameMapService.getGameMapList. setAvailableMaps accepte une liste vide ou une liste de GameMap ; pour les DTO il intersecte GeneratedContentLoader.mapData avec gameMapId et applique minPlayers, puis publie AppConfig.availableMaps. Les listes et messages effectifs EUW datés ne sont pas récupérés par ce lot.

GameQueueManager appelle matchMakerService.getAvailableQueues et affecte le résultat à allGameQueues. Le callback d'erreur la remplace par une liste vide. getQueues filtre NORMAL, ranked solo/premade selon minimumParticipantListSize et BOT. GameQueueConfig déclare supportedMapIds,gameMutators,gameTypeConfigId et les tailles de groupes. Ces champs et branches indiquent où rechercher le payload historique ; ils ne donnent pas ses valeurs effectives.

## Tutoriels et entraînement

CreateTutorialGameController choisit le tutoriel basic/advanced. Advanced dépend de BattleTraining.Enabled ; l'appel createTutorialGame reçoit0 ou1 et currentGame reçoit le GameDTO retourné. Ces deux valeurs sont des types de tutoriels, pas des identifiants de cartes. BattleTraining.Enabled a un défautfalse, UseSRU un défauttrue dans les appels au gestionnaire dynamique. Aucun de ces défauts n'est promu en configuration régionale effective ; aucune sélection de carte n'est déduite du seul UseSRU.

PracticeGameConfig porte gameMap,gameMode,gameMutators,region et gameTypeConfig. PlatformConfigController reçoit practiceGameEnabled et practiceGameTypeConfigIdList. Ces contrats sont distincts du Practice Tool moderne ; la constante PRE_SEASON_SANDBOX90 n'en prouve ni l'existence ni la disponibilité en4.20. Cartes, scénarios et restrictions effectifs restent à qualifier.

## Consommateurs actuels et limites

Le lecteur reference_client refuse de confondre la date de build2014-11-17/17:46:45 avec le déploiement EUW ou de lui attribuer un fuseau. Le lecteur de périmètre des services renvoie implemented=false et runtime_call_executed=false ; il ne route aucune file. Le main du serveur courant appelle enable_map10 puis enable_map10_cast_ground. Ces frontières précises remplacent les seuls liens génériques du plan, sans prétendre combler les fonctionnalités ouvertes.

Aucun calendrier de maintien de Map1, déploiementMap11, ouverture Dominion/ARAM ou scénario tutoriel effectif n'est établi. Une annonce primaire régionale datée ou une réponse/configuration historique attribuable est encore nécessaire. Les recherches Web préliminaires de V90 restent des pistes non qualifiantes ; aucune nouvelle date n'en est déduite.

## Livraison

Seules les métadonnées/consignes de ces six tâches et du Goal sont actualisées dans les deux bases. Cases,notes,historique et anciennes preuves,notamment V90 et SYS-01.1-02,sont conservés. Aucun code ou asset du jeu n'est modifié ; aucun serveur,jeu,AIR ou logiciel historique lancé. Le lecteur refuse notamment un payload EUW inventé, un descripteur de carte transformé en disponibilité, une date tirée du build, une frontière présentée comme fonctionnalité et une clôture des tâches.

| Tâche | Source et consommateur | Recherche restant ouverte |
|---|---|---|
| SYS-11.1-01 | GameMap distingue Map1 et Map11 ; leurs LevelScript sont présents dans la release sélectionnée. PlatformConfigController reçoit les cartes activées ou demande getGameMapList. Le lecteur courant refuse de transformer la date du build en déploiement ; le serveur courant initialise Map10. | Retrouver la décision régionale datée de maintien/remplacement de Map1 et son payload effectif ; ni deux ressources présentes ni la date du PE ne donnent cette décision. |
| SYS-11.1-02 | SUMMONERS_RIFT_UPDATE_SHIPPING vaut11 et son LevelScript est lié au manifeste. La disponibilité provient du message système ou de gameMapService, pas du nom SHIPPING. Les consommateurs locaux identifiés sont des frontières de date/service et le démarrage Map10. | Qualifier la date de déploiement Map11 EUW avec source primaire datée et contexte de file ; distinguer publication, build et activation. Aucun calendrier établi par ce lot. |
| SYS-11.1-03 | CRYSTAL_SCAR_ID vaut8 et GameMode.DOMINION vaut ODIN. GameQueueManager reçoit getAvailableQueues, stocke allGameQueues et filtre selon le type ; une erreur vide cette liste. Ces chemins ne fournissent pas le payload EUW historique. | Relier les files Dominion réellement actives, leurs identifiants, leurs règles et leur période EUW à des réponses ou archives primaires datées ; garder le service local de périmètre distinct de son implémentation. |
| SYS-11.1-04 | HOWLING_ABYSS vaut12 et GameMode.ARAM vaut ARAM ; le LevelScript Map12 est identifié. GameQueueConfig porte supportedMapIds et gameMutators ; le contrôleur combine les cartes générées avec les DTO activés reçus. | Établir disponibilité ARAM et contraintes des files à la date EUW retenue ; constantes, DTO et scripts de carte ne prouvent pas une file ouverte ni sa date. |
| SYS-11.1-05 | CreateTutorialGameController choisit basic/advanced et appelle createTutorialGame avec0 ou1. Advanced dépend de BattleTraining.Enabled ; GameDTO renvoyé devient currentGame. BattleTraining.UseSRU a un défauttrue, distinct du payload dynamique effectif. | Identifier cartes/scénarios réellement renvoyés pour chaque tutoriel, configuration dynamique et exposition EUW ; ne pas déduire une carte de0/1 ni confondre les défauts client avec activation serveur. |
| SYS-11.1-06 | PracticeGameConfig porte carte, mode, mutateurs, région et gameTypeConfig ; PlatformConfigController consomme practiceGameEnabled et practiceGameTypeConfigIdList. PRE_SEASON_SANDBOX90 est une constante distincte ; aucun Practice Tool moderne n’est qualifié. | Établir les variantes entraînement/custom réellement exposées et leurs configurations4.20 ; relier leurs scénarios et restrictions. Le lancement localMap10 et la définition du service ne les implémentent pas. |

Reçu : docs/reference_map_availability_sources/map_availability-links.json. Livraison : docs/fidelity_registry_map_availability_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
