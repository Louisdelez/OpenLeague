# Recettes de Map10 : sources, consommateurs et limites — V90

Les huit exigences SYS-10.6 sont reliées à26 rôles courants précis et à des sources natives identifiées. Cette étude établit la traçabilité des recettes ; elle n'exécute pas les parties et ne les déclare pas acceptées. Les huit tâches restent ouvertes, avec leurs cases et états manuels conservés.

## Référence et méthode

71 identités de sources,86 contrôles source,39 cas de qualification dont38 refus attendus. Trois exports AIR sont liés par leurs hashes à deux bibliothèques originales et au manifeste0.0.1.119 : GameMap, GameServiceImpl et PlayerStatsServiceImpl. Les exports sont relus, pas régénérés ; leurs appels clients ne constituent pas une implémentation serveur récupérée.

Le script LevelScript.luaobj est parsé : HandleDestroyedObject, DeactivateCorrectStructure et OnLevelInitServer sont identifiés avec constantes et empreintes d'instructions. HandleDestroyedObject référence HQType, ORDER_HQ, CHAOS_HQ et EndOfGameCeremony. Aucun callback ou moteur historique exécuté ; la présence de ces symboles ne qualifie pas la cérémonie ou la politique complète du serveur.

## Six clients

Le launcher play/join_local lance un client à la fois dans son état supervisé ; une session existante est refusée. Simulation::join refuse le septième joueur et équilibre les équipes en donnant la priorité au bleu en cas d'égalité. Host relie JoinResumable à join_with_summoners, puis à la route et à l'horloge du joueur.

Le script verify_network.py crée six sockets UDP et contrôle3/3, pas six fenêtres graphiques. Son ancien reçu contient16 contrôles, avec son ancienne identité de serveur. Le script verify_world.py observe environ125secondes de simulation avec une connexion, jusqu'aux camps, sans partie complète. Aucun de ces outils n'est lancé dans ce lot. La capacité native d'une file, les comptes et les allocations restent distincts du cap local6 ; le numéro Map10 du client AIR n'est pas une règle de capacité serveur.

## Victoires bleue et rouge

HQ_T1/team0 et HQ_T2/team1 sont contrôlés séparément. Leurs positions correspondent aux deux SCO natifs avec écarts décimaux inférieurs à0.001. Leurs dépendances locales exigent la tour centrale et la chute d'au moins un inhibiteur. protected examine depends_all et depends_any ; damage_unit applique ces gardes, puis la mort d'un Nexus fixe winner=1-team et capture le résultat.

Les tests source de match_results affectent winner directement ou appellent damage_unit avec1_000_000 dégâts sur une chaîne de structures. Ils vérifient des transitions isolées, sans prouver une victoire jouée normalement. Les deux recettes exigent encore six clients, commandes ordinaires, même identité de binaires et preuves de la chaîne de structures, de la présentation terminale et des résultats. La victoire bleue ne valide pas automatiquement la rouge.

## Objectifs et reconnexion

advance_interactions traite autels/relique et advance_world crée les camps, dont Vilemaw. Les essais de monde, autel et relique sont des reçus séparés. Leur assemblage ne prouve pas qu'un même match ait traversé tous les objectifs. Les sémantiques partielles de Vilemaw consignées dans V87 restent ouvertes.

Le client réseau marque la récupération du même joueur après interruption. Host prépare et commit Resume, installe une nouvelle route/clock et retire l'ancien endpoint. Registry distingue Detached, qui conserve le joueur, et Retired, dont le caller retire le joueur. Le contrat local fixe silence30secondes et des limites explicites ; ce protocole n'est pas assimilé au transport Riot.

Le reçu de qualification de reconnexion du2026-10-11 est identifié par hash et relu. Il dit explicitement que compilation et tests automatisés ne démontrent pas la récupération graphique ordinaire. Il ne qualifie donc pas la reconnexion d'un joueur de chaque équipe dans un même match actuel. Les appels AIR retrieveInProgressGameInfo sont des sources d'interface, pas une preuve du registre serveur historique.

## Résultats et récompenses

capture_final_results fige une seule fois le résultat, les joueurs, scores, inventaires et l'or restant. result_store synchronise un document temporaire puis le publie par hard-link sans remplacer un résultat différent ; un contenu identique est accepté. server/main attend le résultat et réessaie après5secondes en cas d'échec. Le panneau client lit le roster figé et n'apparaît qu'avec résultat et view.dismissed.

Ces chemins sont distincts d'un compte, d'un historique transactionnel et de gains attribués une fois. PlayerStatsServiceImpl appelle des RPC de consultation de statistiques/récents/fin de partie, ce qui ne révèle pas l'attribution serveur des récompenses. Les anciens reçus de capture indiquent diagnostic_fixture=true et ordinary_victory_qualified=false ; prepare_results_visual_fixture.py injecte winner. Cette limite est conservée.

## Image et audio

Le chargement client vise assets/maps/twisted_treeline.glb, avec liaison des matériaux terrain. Le GLB courant et le fichier Blender sont comparés aux identités V85. Le Blender actuel est différent de l'ancien reçu de création ; aucune nouvelle exécution Blender, réexportation ou comparaison de framebuffer n'est déduite. Le NVR natif est une source d'environnement, pas une acceptation visuelle de toutes les zones.

Les cues autel/relique disposent de AudioPlayer. Les requêtes ambiantes suivent la propagation des poses et sont rangées dans des files logiques ; le diagnostic du consommateur indique backend_available=false. Les déclarations CLASSIC et quatre banques ont des identités exactes, conservées depuis V88 ; ce lot ne reparcourt pas leurs champs binaires ni ne qualifie un mixage. Le catalogue peut planifier une banque/événement et refuser les identifiants inconnus. Ces faits ne prouvent pas l'écoute d'une partie complète.

## Héritage, refus et intégration

Les comparaisons d'identité portent sur les fichiers courants pertinents : quatre anciens reçus réseau ont chacun un serveur différent ; neuf fichiers/binaires comparés du reçu de résultats diffèrent ; le reçu de reconnexion donne deux égalités et huit différences sur la sélection comparée. Cela ne retire pas leur valeur historique et ne les transforme pas en recette actuelle. Les autres fichiers non comparés de ces reçus ne sont pas déclarés vérifiés.

Le lecteur refuse source altérée/omise, mauvais export ou manifeste AIR, callback exécuté inventé, équipe/dépendance Nexus modifiée, ancien Blender présenté comme actuel, victoire injectée présentée comme ordinaire, preuves réseau prétendues fraîches, suppression des limites de reconnexion, clôture des huit recettes ou contournement de vérification.

Seules les consignes/métadonnées des huit tâches et du Goal sont actualisées dans les deux bases. Les audits vérifient leurs lecteurs de fiche/copie et la conservation des42606 états manuels par base, des notes, de l'historique et des preuves antérieures, notamment V88/V89 et SYS-01.1-02. Aucun jeu, serveur, Rust, Blender, AIR ou autre programme historique exécuté par ce lot ; aucun code/asset du jeu changé.

| Tâche | Consommateur actuel | Qualification restant ouverte |
|---|---|---|
| SYS-10.6-01 | Le superviseur play/join_local lance un client et refuse une autre session dans le même état ; Simulation::join limite à six joueurs et équilibre3/3. Host relie JoinResumable à cette création. La preuve réseau héritée contient six sockets UDP, pas six fenêtres. | Qualifier le lancement des six clients graphiques sur les mêmes binaires,identités et deux équipes ; garder le test UDP et les comptes/réservations historiques séparés. |
| SYS-10.6-02 | damage_unit applique protected puis la mort du Nexus fixe winner=1-team ; le Nexus rouge HQ_T2 porte team1 et ses dépendances locales. capture_final_results fige ensuite le résultat. Le callback natif HandleDestroyedObject référence EndOfGameCeremony. | Jouer et enregistrer la victoire bleue ordinaire avec six clients,commandes normales et chaîne de structures ; ni winner injecté ni damage_unit(1_000_000) ne constituent cette recette. |
| SYS-10.6-03 | La même branche traite HQ_T1/team0 pour une victoire rouge ; ses dépendances propres sont lues sans inférer la qualification depuis le camp bleu. Le résultat est capturé une seule fois. | Jouer et enregistrer séparément la victoire rouge ordinaire ; qualifier contraintes de structures,présentation terminale et résultats sur les mêmes binaires. |
| SYS-10.6-04 | advance_interactions appelle les autels et gère la relique ; advance_world crée les camps dont Vilemaw. Les anciens reçus autel/relique/monde sont des essais distincts,et les sorts/buff complets de Vilemaw restent partiels. | Observer autels,relique et Vilemaw dans le même match ordinaire jusqu’au résultat,avec identités de session et sources ; ne pas composer trois anciens essais en une seule partie acceptée. |
| SYS-10.6-05 | Le client marque une interruption pour récupérer le même joueur ; Host prépare et commit Resume avec nouvelle route/clock,Registry contrôle identité/epoch. Les transitions Detached et Retired ont des effets différents sur Simulation. | Qualifier une reconnexion de chaque équipe dans le même match courant,sans nouvelle identité ni double commande/récompense ; l’ancienne qualification automatisée ne prouve pas cette recette graphique. |
| SYS-10.6-06 | capture_final_results fige joueurs,score,inventaire et or restant. result_store publie un JSON synchronisé non remplaçable ; main réessaie une sauvegarde échouée après5secondes. Le panneau lit le roster figé et attend view.dismissed. | Qualifier six résultats uniques et gains de compte idempotents ; or restant,document par session et RPC AIR de consultation ne prouvent pas l’attribution de récompenses ni un historique de compte complet. |
| SYS-10.6-07 | Le client charge le GLB installé et lie les matériaux terrain ; ses octets et ceux du Blender courant sont comparés à V85. Le hash Blender actuel diffère de l’ancien reçu de création ; aucune nouvelle vue ni réexportation n’est déduite. | Comparer les zones,contacts,textures,effets et raccords dans le framebuffer courant avec les sources restaurées ; l’identité des fichiers et les anciennes observations ne sont pas une recette visuelle actuelle. |
| SYS-10.6-08 | Les cues autel/relique sont déclenchés ; les requêtes ambiantes sont mises en file logique après propagation des poses. Le diagnostic courant annonce backend_available=false. Le catalogue des banques fournit une planification, pas la chaîne complète des annonces. | Qualifier le backend sonore réel,dispatch/mixage/volumes puis écouter une partie complète ; conserver audio ponctuel,requête logique,graphe natif et écoute humaine comme preuves distinctes. |

Reçu : docs/reference_match_recipe_sources/match_recipe-links.json. Livraison : docs/fidelity_registry_match_recipe_links_revision_4_20.json. Les huit recettes et le Goal restent ouverts.
