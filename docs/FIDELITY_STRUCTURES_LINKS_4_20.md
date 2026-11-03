# Structures de Map10 — SYS-01.2-02, V86

Les9 exigences SYS-10.3 sont reliées à22 rôles précis :6 périmètres partiels et3 frontières (riposte prioritaire des tours,escalade des dégâts,protections temporelles). Aucun périmètre complet fermé. Aucun code/asset du jeu changé,aucun jeu,Rust,Blender ou binaire historique exécuté dans ce lot. Cases et acceptation préservées.

## Sources et valeurs

Trois scripts natifs sont analysés : LevelScript Map10,Turret etEndOfGame.20 fonctions nommées sont identifiées par la liaison CLOSURE/SETGLOBAL,leurs constantes,opcodes et empreintes des mots d’instructions. Le lecteur vérifie la consommation complète des fichiers ; les corps des callbacks ne sont pas exécutés. L’initialisation statique LevelScript s’arrête au premier appel non pris en charge,elle ne représente pas tout OnLevelInit.

Les12 définitions de structure sont comparées sur6 champsData :72 observations conservent les types bruts,les absences et les valeurs actuelles.40 égalités numériques,6 écarts deBaseHP et26 champs absents. Pour les deux équipes,les tours1/2/3 déclarent1600/1300/1900 dans l’INIBIN,contre2350/2050/2650 localement. Ce constat ne détermine pas les modificateurs serveur historiques effectifs. Les absences des inhibiteurs/Nexus etSpellBlock des fontaines ne deviennent pas des zéros natifs. Les8 CharScriptTT_Turret inspectés ont des tables de constantes/enfants vides ; cela n’exclut pas des mécanismes hérités ou des items dans d’autres sources.

Les18 placements de structures sont reliés à leur SCO exact et au graphe local depends_all/depends_any ; chaque écart de coordonnée est conservé,inférieur à0.001 unité native par composante. Les noms des dépendances existent dans le monde courant. Un nom ou une position ne prouve pas la politique native de protection.

## Contrats courants et limites

protected protège toujours les fontaines,puis applique depends_all.any(alive) ou depends_any.all(alive) non vide. Le corps ne lit pas self.tick. Le natif expose DeactivateCorrectStructure,ApplyBarracksRespawnReductions etHandleDestroyedObject. OnLevelInitServer référence AllowDamageOnBuildings avec10secondes ; la durée et les noms d’appels ne constituent pas la qualification du scheduler ou de tous les paramètres moteur.

Turret.luaobj expose OnCallForHelp,OnReceiveImportantCallForHelp,PutTargetInTargetList,UpdateTargetList etTimerFindEnemies. Le code NPC courant sélectionne la cible admissible à distance minimale. La demande de priorité contre un champion agressant un allié reste une frontière,et non une fonctionnalité démontrée par ce nearest-target. Le Pending d’attaque capture p.damage ; aucune escalade par cible n’est déduite des dégâts de base ou des modificateurs généraux. Le producteur natif exact de cette escalade reste à identifier.

wave_sequence produit un super pour la voie à inhibiteur adverse détruit,deux si les deux sont morts ; les callbacks natifs utilisent WillSpawnSuperMinion et des bonus de destruction/réapparition. Leur composition et leurs bonus complets restent à qualifier.

GetDisableMinionSpawnTime a la forme native240+0*NumOfSpawnDisables. Le reçu de5 cas interprétés antérieurs est relu et la fonction brute correspond exactement ; ces cas ne sont pas rejoués ici. Ce timer suspend les vagues. Le code Rust réactive l’inhibiteur240secondes après la mort en rétablissant toute sa santé. Le délai natif de régénération de l’inhibiteur et son ancrage restent inconnus ; aucune valeur n’est inventée.

damage_unit refuse match terminé,dégâts invalides,cible protégée ou déjà morte ; le gagnant est fixé à la destruction du Nexus. apply_damage valide source,cible et protections,mais sa doc confie les règles de ciblage aux appelants : le helper seul ne prouve pas l’hostilité du tireur ou toutes les voies de victoire légales. capture_final_results conserve un résultat figé. command/apply_damage refusent match ended,et advance effectue les nettoyages nommés puis quitte. Les verrous client et tous les ordres retardés restent à qualifier au-delà de ces chemins.

## Présentation des bâtiments

Les24 aliases intacts/détruits du catalogue courant et48 rôles sont liés aux noms de clips des GLB réellement présents. Les politiques de répétition et vitesse concordent avec les contrats antérieurs de période/lifecycle ;16 fichiersBLND et le SHA du binaire historique sont vérifiés. Les240 cas de clock et48 états sont hérités,non réexécutés.

main.receive choisit _destroyed et remplace l’entité au changement. structure_animation_clock règle vitesse/répétition et conserve le dernier frame des one-shot. Le Nexus passe par nexus_ceremony et l’horloge de fin de partie,distincte d’un changement immédiat lors de health<=0. Ce lot ne qualifie pas tous les débris,matériaux ou événements.

Le reçu normal_structure_finished_animation_progress décrit une seule tour Turret_T2_L_02,424 échantillons de fin et848 poses,avec cinq contrôlesUDP et un client graphique. Sept fichiers de preuves associés correspondent encore à leurs empreintes ; les deux exécutables actuels sont différents de ceux de l’essai. Ils sont identifiés séparément,aucun binaire n’est lancé. L’essai historique ne devient pas une recette actuelle de24 modèles ou une partie complète à six clients graphiques.

## Vérifications et livraison

385 contrôles source,41 cas du lecteur dont40 refus attendus. Les mutations testées concernent notamment les champs absents,le timer de suspension promu en respawn,les dépendances,les clips,le loop,les anciennes preuves promues en exécution actuelle et les clôtures indues. Les sources sont réempreintées à chaque validation ; un cache de parse dans le processus n’est réutilisé que si les identités restent identiques.

| Tâche | Consommateur constaté | Travail ouvert |
|---|---|---|
| SYS-10.3-01 | Les18 structures ont un graphe local depends_all/depends_any. protected teste la vie des dépendances et protège toujours les fontaines ; apply_damage refuse une cible protégée. LevelScript contient les callbacks de déverrouillage et de réactivation. | Qualifier chaque arête contre les appels natifs et le contexte de lancement ; les noms et positions SCO n’établissent pas à eux seuls la politique d’invulnérabilité. |
| SYS-10.3-02 | Turret.luaobj possède OnCallForHelp,OnReceiveImportantCallForHelp et une liste de cibles. Le corps courant inspecté choisit la cible admissible la plus proche ; cette frontière n’implémente pas la priorité demandée de riposte. | Qualifier les arguments/callbacks natifs puis relier le producteur d’agression alliée et la priorité de riposte ; ne pas présenter la distance minimale comme la politique historique. |
| SYS-10.3-03 | Le code d’attaque courant capture p.damage dans Pending ; la réduction commune consomme cette valeur et les modificateurs généraux. Les INIBIN donnent les dégâts de base,et les CharScriptTT_Turret inspectés sont vides. | Identifier le producteur natif exact de l’escalade par cible et son reset ; l’absence dans ces fichiers bornés ne prouve pas une absence globale dans les scripts/objets serveur. |
| SYS-10.3-04 | OnLevelInitServer référence AllowDamageOnBuildings avec10secondes ; le callback contient SetInvulnerable/SetTargetable. protected actuel dépend du graphe et de la vie, sans lecture du temps dans son corps. | Qualifier l’ancrage du timer,les paramètres par catégorie etles protections temporelles complètes ; ne pas assimiler le seul graphe local à cette règle native. |
| SYS-10.3-05 | La réception choisit un alias _destroyed et remplace l’entité lors du changement.24 entrées de catalogue et48 rôles sont reliés à leurs GLB et politiques de lecture ; clamp_finished garde la pose finale des one-shot. Le Nexus passe par une échéance de cérémonie. | Qualifier matériaux,événements,débris et transitions de chaque structure en partie actuelle ; l’ancienne observation Turret_T2_L_02 ne couvre pas tous les bâtiments. |
| SYS-10.3-06 | wave_sequence ajoute1super pour l’inhibiteur adverse de la voie détruit,ou2 si les deux inhibiteurs sont détruits ; les callbacks natifs contiennent WillSpawnSuperMinion et les bonus de destruction/réapparition. | Qualifier le calcul natif complet de composition,bonus et limites ; aucun simple test de vie local ne prouve l’ensemble des bonus de destruction. |
| SYS-10.3-07 | Le script calcule240+0*NumOfSpawnDisables pour la suspension des vagues. Le code courant utilise240secondes depuis la mort pour rétablir toute la santé de l’inhibiteur. Ces contrats restent distincts. | Qualifier le timer natif de régénération de l’inhibiteur,son ancrage et ses états ; ne pas convertir le timer de suspension des sbires en preuve du respawn. |
| SYS-10.3-08 | damage_unit refuse match fini,dégâts invalides,cible protégée ou déjà morte,puis définit le gagnant à la mort du Nexus. capture_final_results gèle le résultat. HandleDestroyedObject/EndOfGame fournissent les sources de cérémonie. | Qualifier toutes les voies de dégâts autorisées,les dépendances et la victoire des deux équipes ; le helper de dégâts n’impose pas à lui seul l’hostilité du tireur,qui relève des appelants. |
| SYS-10.3-09 | command et apply_damage refusent match ended ; advance clôture les projectiles/effets nommés et capture le résultat. EndOfGameCeremony natif référence verrous d’entrée,HaltAllAI et arrêt des barracks. | Qualifier toutes les commandes et ordres retardés,les sessions et les UI ; le refus de simulation ne démontre pas tous les verrous natifs ou les états du client. |

Reçu : docs/reference_structures_sources/structures-links.json. Livraison : docs/fidelity_registry_structures_links_revision_4_20.json. Les9 périmètres et le Goal restent ouverts.
