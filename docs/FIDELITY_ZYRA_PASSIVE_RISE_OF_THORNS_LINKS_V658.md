# SYS-01.2-02 — Zyra / Rise of the Thorns, V658

Date UTC 2026-10-27T04:34:16.027434+00:00. Référence PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V658 Zyra / Rise of the Thorns : 39 sources natives, 117 associations, 22 points actuels et 44 liens de frontière. Texte natif : forme après mort, attente de 2 secondes, tir vers le curseur par une compétence, dégâts bruts et durée annoncée de 8 secondes. Huit morts/réapparitions ordinaires observées aux niveaux1/18 avec contrôles Annie ; commandes refusées autour de60/240ticks, aucune entité de plante ni projectile du passif observé. 720 refus publics et 28 refus API sans mutation, 14076 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Zyra-PASSIF-SOURCE, CH-Zyra-PASSIF-SIMULATION-CONTRAT et CH-Zyra-PASSIF-SIMULATION reçoivent sources, preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse.39ressources donnent117associations ;22points courants donnent44liens sur les deux fiches de simulation. Tous restent entry_boundary_only, provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés sans être déclarés accomplis. Inconnues, identifiants et hiérarchie restent identiques octet par octet ; statuts, critères, acceptations et états manuels restent inchangés.

## Sources et instructions de reprise

121ressources natives de première découverte et huit dépendances de personnages, soit129inspectées ;37+5références communautaires et neuf exclusions conservées. Tailles, SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ; le projet courant est F:/OpenLeague. Les références communautaires restent distinctes du serveur original.56Lua lus,21limites NEWTABLE conservées,aucune fonction enfant ; ce périmètre ne prouve pas la totalité du code serveur.

Les chemins complets ci-dessous distinguent les deux CharScriptZyraThornPlant homonymes et les fichiers de personnage/sort ZyraSeed.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Zyra\Zyra.inibin | 2472 | b96ea240a1c0b622ad98f2aba59e4a9b5f08571a4cc9820c5ff4bd77acc060ec |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Zyra\Scripts\CharScriptZyra.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Zyra\Scripts\CharScriptZyra.preload | 563 | fa7c542d613c81f62d5dd714cbe0d2fa4885ede4f24be6b4fed1049d2bb3afff |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Zyra\Zyra.ddf | 2127 | 20ef9e2f9874359eee31542e18649735386cea440bceef35274c7c55b119db4e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathDisplay.inibin | 1339 | 2a7bf1149c97882182e4e8ca95d8c3e455ae9451abdf9f87c25bee807e173860 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathDisplay.luaobj | 397 | b7c2a7d9b01c17fe777fcab5cd0b0f47d10a8c7683567c348faec52a7fd107c3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathReady.inibin | 50 | 533be142402cc9dfbc149c4e32d613eeecaa3bf83245db94d66d54f247e6efd3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManager.inibin | 1501 | 021ca8d8f18e89e6edd95777b848b9403474c94a457f27184d366dd94db2627c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManager.luaobj | 214 | 5c51b9fe73b2fb2e7c17abe419de6321a7190a5df20c2cb7b1a5e849edfb799d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManager.preload | 110 | e0cbb78393b50d587296e218eac062951f079f802fa487ad4b396cbdaa0f8d6e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManagerFire.inibin | 1506 | 8eadb7e59cdb87ae5731e595a52a9d90aecfaa2fce79e8b127478abe75384443 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManagerFire.luaobj | 156 | 13673419416df3e1d6cc820784150c4024c8e45c1a05556e0101b4dcf88c0aba |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathManagerFire.preload | 110 | e0cbb78393b50d587296e218eac062951f079f802fa487ad4b396cbdaa0f8d6e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathMissile.inibin | 1512 | 0b53fffd9a0e380882425ef9014f69f806100570e74d412691985307239d37fe |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathMissile.luaobj | 436 | e56bf0e888fd7c5c171e56e7256c97e6172b69e88f6474944fcbb8561009ccf2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPassiveDeathMissile.preload | 237 | 9238c796dd7adfeb99a0154253524b0484726a958e7520a412bacd3374f5f2ae |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThorns.inibin | 1336 | 5f8379a5e8a1051b7691e9eda2bc6d03b522e328b7b376e37dc38d238d425811 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThorns.luaobj | 455 | 594229398de02fcaf5aea85807af115d3e73e735a13d8d08e5d3d1dd4e579755 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThorns.preload | 1112 | 444f53f968808eff0baab899852bc189e5435f03830b30525f66d53c3b2dff70 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsCD.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsReady.luaobj | 217 | 01e22db208520e71f34b396e077c9b805740516644ede8570e97c8a478ea266b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsReady.preload | 95 | 505bc88d03ff471b669c5b757dfa66d1e7811abd97ce6e469872747d7d0f438f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsSeed.luaobj | 600 | 7c428fa361b1809bc8c4d79873e5f6ad320149c866e110879ac26aaca460be81 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsSound.luaobj | 173 | 86287ce42bfa94332f6d32a63cb08d3a37c4bc1413f20bc747ee3629a5e1432b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsSpawn.luaobj | 90 | 0b936e4b235f178501c4b0a41735e6e80944f715b24b4a523e28570f8020d45a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraPQueenOfThornsSpawn.preload | 221 | 6d91f3be54a1704ce58271920371014779ff14262dc9803bd454a96087bfb829 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraExpirationTimer.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraVengefulPlant.inibin | 50 | 533be142402cc9dfbc149c4e32d613eeecaa3bf83245db94d66d54f247e6efd3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraVengefulPlant.luaobj | 320 | 3c360c548a0af08e42784f98a92484033623c256cbc753fd296c7ac3cf9c3de0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\ZyraVengefulPlant.preload | 234 | 62014cdc945cda0eddd0e14e80c2aed6853cfced2eafb75c1df424765310eae6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraPassive\Scripts\CharScriptZyraThornPlant.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraPassive\Scripts\CharScriptZyraThornPlant.preload | 224 | 9049c64bcc94dcc9b3e1548ef5bfe16c0f07ad3c660c14bcf9bc9339805ada98 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraPassive\ZyraPassive.inibin | 2416 | afa88146b36d8ae658e03c61c3484942eaf999408fc03f1e75881524881feecb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\Scripts\CharScriptZyraThornPlant.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\Scripts\CharScriptZyraThornPlant.preload | 295 | 8169e54b5255193bd52824109a83071a85bd8036372bb8edf1241105d790b8a8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\ZyraThornPlant.inibin | 2707 | 077d1f306a2902c455052b10847cb777b7dd4633f98d2500fa106ccb29fa9fd2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraSeed\ZyraSeed.inibin | 2038 | cc94484197eed073041bca36513f036d25f794e770e0f0a936685d06a8c4ce1a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\TestCubeRender\TestCubeRender.inibin | 442 | d41fb80b6a735b80131a1cf3aa01939b587a1f9342f51ee31b2ceaed3167695f |

V658 Zyra / Rise of the Thorns : 39 sources natives, 117 associations, 22 points actuels et 44 liens de frontière. Texte natif : forme après mort, attente de 2 secondes, tir vers le curseur par une compétence, dégâts bruts et durée annoncée de 8 secondes. Huit morts/réapparitions ordinaires observées aux niveaux1/18 avec contrôles Annie ; commandes refusées autour de60/240ticks, aucune entité de plante ni projectile du passif observé. 720 refus publics et 28 refus API sans mutation, 14076 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Rise of the Thorns sur la référence4.20 et relier son producteur réel. Zyra.inibin déclare Passive1LuaName=ZyraPassiveDeathDisplay et l’icône ZyraP.dds. Passive1Name et PassLev1Desc1 relient les textes exacts ; Passive1,Passive1Desc et Passive1Level1..6 sont absents,pas zéro. Le tooltip BuffData décrit une forme après mort, un tir de Vengeful Thorn vers le curseur par n’importe quelle compétence après2secondes, @f1@ dégâts bruts aux ennemis traversés et une durée de8secondes. Le producteur f1, l’origine exacte des deux temporisations et leurs bornes restent à établir. Les tooltips de commande affichent0mana/0seconde et «Fire!» ; cela ne qualifie pas le coût ni une recharge de disponibilité du passif.

Sources :121ressources natives de première découverte, complétées par huit dépendances de personnages, soit129inspectées ;37+5références communautaires et neuf exclusions conservées.56chunks Lua entièrement lus sans fonctions enfants ;21limites NEWTABLE conservées. Le CharScript natif est vide. Le DDF comporte44lignes :seule ZyraSeed;f1 est renseignée avec17/16/15/14/13. Les lignes ZyraPassiveDeathManager et ZyraPassiveDeathDisplay sont vides ; ne pas utiliser la valeur du W comme formule de dégâts du passif.

Conserver les références anciennes :le Lua DeathDisplay déclare le bon BuffName mais KogMaw_IcathianSurprise.dds. PQueenOfThornsReady/Sound portent des BuffName KogMaw ; PQueenOfThornsSeed mentionne AkaliShadowDance. DeathMissile renvoie en SpellData au tooltip EzrealMysticShot, contient des constantes Dark Binding/Morgana et un skin CyberEzreal ; ses preloads mentionnent Ezreal, Caitlyn et stun. Les coefficients/rangs des fichiers Display/PQueen (0,7 ;60/110/160/210/260), Manager/Fire (1,3 ;20/60/100/140/180) et Missile (1,2 ;90/150/245/315/440) ne sont pas établis comme producteur f1. Les champs CastRange1600/1474 sont conservés sans les promouvoir en portée native acceptée.

ZyraPassiveDeathReady.inibin et ZyraVengefulPlant.inibin ciblent game_buff_tooltip_Absolute_Zero_Slow, absent du fontconfig exact ; conserver ce lien non résolu sans réécrire son alias. PQueenOfThornsCD et ExpirationTimer ont des chunks vides. Les métadonnées PersistsThroughDeath et NonDispellable ne sont pas des callbacks de cycle de vie ; un échec NEWTABLE du lecteur ne signifie pas que les globals du fichier original sont vides.

Le preload PQueenOfThornsSpawn référence zyrapassive, zyrathornplant et zyravengefulplant ; le parent référence aussi testcuberender et zyraseed. Les huit fichiers de personnages associés sont vérifiés par chemin complet, afin de distinguer les deux CharScriptZyraThornPlant homonymes et les fichiers de personnage/sort ZyraSeed. ZyraPassive porte6PV et BaseDamage−2, ZyraThornPlant6PV et BaseDamage0 ; ces déclarations ne prouvent ni leur instanciation ni les dégâts du tir. Les scripts de ces plantes sont vides. Les images, squelettes et états visuels n’ont pas été exécutés dans ce lot.

Recherches bornées :aucun producteur Zyra/Rise of the Thorns dans les routes Rust inspectées ; aucun ZyraPassive/PQueen/Rise of the Thorns dans les scripts C# communautaires. Le CharScript communautaire est vide. Les Q/W/E/R communautaires simplifiés restent des références distinctes du moteur Rust et du serveur original. La recherche ne prouve pas une absence dans toutes les archives.

Diagnostic :quatre simulations séparées, Zyra1/18 et contrôles Annie1/18, face à Annie18, avec vraie navigation/monde Map10. Six apports XP serveur préparent les niveaux ; huit trajets Move/Stop publics réussissent sans réémission. Une première mort survient à proximité de l’ennemi ; la seconde survient à la base après réapparition. Huit événements de dégâts létaux environnementaux par API serveur déclenchent les chemins actuels de mort. Aucune position,horloge,statistique,unité ou PV n’est injecté directement.

Aux ticks relatifs0,59,60,61,239,240,241 de chaque mort, Stop,Move,Attack,Learn et Cast/CastAt des quatre slots sont refusés avec «champion dead», sans mutation. C’est le garde d’entrée générique qui bloque la commande avant une logique de tir. Ces672refus, plus48refus de sorts Zyra vivant, donnent720refus publics. Les quatre morts des deux contrôles Annie suivent le même comportement générique. Au niveau1 la réapparition ordinaire intervient après480ticks ; au niveau18 après1110ticks, conformément aux16/37secondes de la table Map10 courante. Les huit retours à la base restaurent les PV et permettent Stop. L’absence d’activation ne qualifie ni une disponibilité initiale ni une recharge native, même après une seconde mort.

À chaque tick, les listes d’entités sont contrôlées pour Zyra/TestCubeRender et les listes de projectiles de champion restent vides. Les PV de l’ennemi suivent uniquement la régénération attendue. Cela ne constitue pas une capture du rendu de la forme. Un contrôle distinct par simulation inflige40dégâts bruts via l’API :40PV sont retirés sans mitigation, sans lien avec un tir Zyra. NaN,infini et négatif sont refusés ; soin et nouveaux dégâts sur le mort sont refusés. Total28refus API. Ce trajet de dégâts bruts n’est pas un projectile ni une compétence native acceptée.

Total14076ticks,8morts/respawns,4contrôles API de40dégâts,720refus publics+28API. Binaire non-test du vrai moteur, dépendances/checksums alignés sur Cargo.lock et1158entrées inchangées. Aucun rendu, audio, réseau ou serveur historique exécuté.

À compléter :établir le producteur f1 et la progression, la forme/entité réellement instanciée, le délai2s et la durée8s (origine, inclusion des bornes), l’autorisation des slots après mort et la consommation du tir. Qualifier direction au curseur, portée,vitesse,largeur,collisions,traversée multi-cibles,dégâts bruts,boucliers et catégories de cibles. Résoudre les candidats legacy, les références manquantes, disponibilité/recharge, mort répétée, fin de partie, déconnexion et respawn. Relier séparément réseau,sauvegarde,contrôle des entrées,HUD/icônes,modèle/animations,particules et audio. Préserver trois questions,quatre dépendances,critères,preuves,notes et états manuels. Ce lot relie les sources aux frontières actuelles sans terminer Zyra ni le jeu.


## Consommateurs réels

| Point courant | Ancre exacte |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/healing.rs:16 | pub fn heal( |
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/lifecycle.rs:6 | pub fn base_death_ticks( |
| crates/core/src/lifecycle.rs:33 | pub(crate) fn advance_respawns( |
| crates/core/src/lib.rs:149 | pub fn champion_catalog( |
| crates/core/src/ally_occupancy.rs:110 | pub(crate) fn placement( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/champion_kills.rs:32 | pub(crate) fn reward_champion_death( |
| crates/core/src/world.rs:226 | pub(crate) fn target_info( |
| crates/core/src/annie_r.rs:20 | pub(crate) fn combat_owner( |

Le garde de commande sur un champion mort précède la distribution des actions. Les chemins de dégâts, de mort, de réapparition, de placement, de statistiques, de régénération et de progression sont inspectés et exercés. Aucun de ces points génériques ne constitue un producteur accepté du passif natif. Les recherches bornées ne prouvent pas une absence dans toutes les archives.

## Résultats attendus et observés

| Champion | Niveau | Réapparition ordinaire (ticks) | Refus publics | Refus API | Ticks simulés |
|---|---:|---:|---:|---:|---:|
| zyra | 1 | 480 | 192 | 7 | 2904 |
| zyra | 18 | 1110 | 192 | 7 | 4164 |
| annie | 1 | 480 | 168 | 7 | 2874 |
| annie | 18 | 1110 | 168 | 7 | 4134 |

Le texte natif décrit une forme après mort, un délai2secondes avant le tir et une durée8secondes. Les ticks0,59,60,61,239,240,241 de chaque mort sont contrôlés :12commandes chacune refusées avec «champion dead», sans mutation. Cela donne672refus après mort, auxquels s’ajoutent48refus de sorts Zyra vivant. Aucune entité Zyra/TestCubeRender ni projectile de champion n’apparaît pendant les simulations ; les PV ennemis suivent la régénération attendue. Ces contrôles portent sur les données serveur, pas sur un rendu à l’écran.

Les huit réapparitions ordinaires surviennent à480ticks au niveau1 et1110au niveau18, conformément aux16/37secondes de la table Map10 courante. Les contrôles Annie présentent le même comportement générique. Stop réussit après chaque retour avec PV complets. Cela ne valide ni la forme, ni la disponibilité ou la recharge du passif natif.

Chaque simulation comprend un contrôle distinct de40dégâts bruts API infligeant exactement40PV. Douze valeurs invalides et16actions sur cible morte sont refusées, soit28refus API. Les huit événements létaux sont des appels serveur environnementaux ; ils ne prouvent pas une attaque publique à distance ni un projectile Zyra. La première mort est proche de l’ennemi, la seconde survient à la base. Six apports XP et huit trajets Move/Stop publics sans réémission ; aucune injection directe de position,PV,horloge,statistique ou unité.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-zyra-rise-of-thorns-probe.exe ; 6085120octets ; SHA-256 9da4d1eaa170dd56cac37fcce3b5de325435b7e0220cf79a46da81d5f038cf43. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false ; dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 37f56b6eadc9613a37d6364e5262e4d2fe8ad032dee9c9b541a02073469811dd |
| RUN | 0 | f92274f0d964b7e6a55202314511b6aacc9007f09c36950ce42e514d50838888 |
| prepare | 0 | e650e00da6d083a08cd19e809137d1fe8043d7132e34c44fb0a9e1796229e2fc |
| check | 0 | 6c8a4bba5cb33730d7c9b7f767cf51ca88146f67530ddc4f00b64efbc73258f3 |
| publish | 0 | c60905162b687ab503fde93a0209b188dcb364bb398eaeb5090f979d0c5b2141 |
| audit | 0 | 4fc83b34dc668bd121d1e1cab27455fc1ecea5c3db463e5f6b5f719070ddf6a4 |

Découverte, suivi des dépendances, inspection, BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources, questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5378ancres/empreintes exactes, aucun problème, pour99307sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\zyra-passive-rise_of_thorns-links-v658.json. Vérification F:\OpenLeague\docs\fidelity_zyra_passive_rise_of_thorns_links_v658.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision658_Zyra_discovery\OBSERVATIONS.json. Dépendances F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision658_Zyra_followup/OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision658_Zyra_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision658_Zyra_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision658_Zyra/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision659_trace_review\REVIEW.json. Scripts et binaire conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ; gain logique 2544905077octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision658_Zyra/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ; restauration explicite par revision658_restore_validation_snapshots.py, non exécutée après archivage.

## Limites et suite

Les ressources du passif existent, mais la forme et son tir ne sont pas produits par les chemins testés du moteur courant. Le producteur f1, la progression, les origines et bornes des temporisations2s/8s, la portée et les collisions restent ouverts. Les références KogMaw/Ezreal/Morgana/Akali et les deux tooltips Absolute_Zero_Slow non résolus sont conservés ; aucune valeur héritée n’est promue en règle native. Les lignes DDF du passif sont vides, le seul f1 renseigné appartient au W.

Les métadonnées de persistance après mort et les preloads ne prouvent pas une instanciation. Rendu, HUD, audio, réseau, sauvegarde et cycle de vie nécessitent des contrôles séparés. Ni Zyra ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision659_trace_review/REVIEW.json. V658 Zyra Rise of the Thorns publié et audité :39sources natives,117associations,22points/44liens.129sources inspectées avec huit dépendances de personnages,42références communautaires. Quatre simulations Zyra/Annie niveaux1/18 :huit morts et retours ordinaires,aucune forme/plante ni projectile du passif ;720refus publics+28API,14076ticks,1158entrées conservées,BUILD/RUN0. Quatre contrôles de40dégâts bruts API distincts du tir natif. f1,temporisations2s/8s,portée et références legacy ouverts. Prochain lot :Brand PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter Blaze4.20 avant diagnostic. Ne pas substituer les mécaniques des versions récentes. Snapshots V658 archivés/restaurables par revision658_restore_validation_snapshots.py. Goal actif. Première découverte Brand exécutée0 :revision659_Brand_discovery/OBSERVATIONS.json,48ressources natives,19références communautaires,9exclusions,aucun DDF. Alias BrandPassive/icône BrandBlaze.dds ;texte8%PVmax en dégâts magiques sur4s,maximum80par seconde contre monstres.19Lua lus sans fonctions enfants,neuf limites NEWTABLE ;CharScript vide et métadonnées de passif seules. Scripts C# appellent BrandAblaze sans implémentation retrouvée par recherche bornée ;aucun Brand/Blaze dans crates/core/src. Aucun diagnostic moteur Brand exécuté.
