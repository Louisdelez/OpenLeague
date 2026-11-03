# SYS-01.2-02 — Kalista / Martial Poise, V663

Date UTC 2026-10-27T06:02:08.948786+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V663 Kalista / Martial Poise : 25 sources natives, 75 associations, 26 points actuels et 52 liens. Acquis : verrou cant_cancel natif conservé. Écart : Move pendant windup refusé, aucun bond observé. Huit simulations niveaux1/18 avec/sans bottes1001 ;20attaques,24essais de commande,132 refus publics,16860 ticks. BUILD/RUN0 et1158entrées conservées. Aucune case ni question fermée ;aucun code de jeu modifié.

## Intégration et prérequis

CH-Kalista-PASSIF-SOURCE,CH-Kalista-PASSIF-SIMULATION-CONTRAT et CH-Kalista-PASSIF-SIMULATION reçoivent sources,preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse.25ressources donnent75associations ;26fonctions donnent52liens sur les deux fiches de simulation. Les descripteurs entry_boundary_only ne revendiquent pas la fonctionnalité complète ;le support partiel du verrou d’annulation est conservé explicitement. Trois questions et quatre dépendances restent ouvertes. Inconnues,identifiants et hiérarchie inchangés octet par octet ;statuts,critères et états manuels conservés.

## Sources et instructions

241ressources natives,69références communautaires,2exclusions. Tailles,SHA et appartenance RADS vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague,projet courant F:/OpenLeague.114Lua entièrement lus,sans fonctions enfants ;24limites NEWTABLE conservées.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Kalista.inibin | 1295 | bf6f9252137e19f0c38d7a9308aefdce90fa718f3259fce0fcc60ee12c92c412 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\CharScriptKalista.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\CharScriptKalista.preload | 1703 | 6e9e684c1d36fe256fd1cfe585a3f2cc3dc7e9c985480dae3b2a82d28248bc04 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Kalista.ddf | 288 | e081d0f78966976cc73b214814691c64df7fb490df089b5e045662127e8b10b5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveBuff.inibin | 50 | 3b1a15fc233de967da906fab4bf2eb616ff18617500a7610d3364e35a858e0ae |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveBuff.luaobj | 190 | 98f070886d0711174247bd0f7ec798955b09e5328e8bcf6da21bc4cff9a7077d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveBuff.preload | 1114 | 9c8ad9cf46356c9467541ddd468d1c28b3cb8aa727c50f93def0f24ba5270e7b |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaBasicAttack.inibin | 1077 | bf5ec40827e28797621a670416dbe58d8f3d884bed23816c29d21ab37b0d5c9c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaBasicAttack.luaobj | 214 | e0f8c33b750dfb9997195271b18874fcfc4bccc188b673b8d29508cd51568cc1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashSpellActual.inibin | 1172 | 5928d0aeb83fe2940d83ed06a0402ddfe3e2f88c101b6c0a263e82986d60c1f1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashSpellActual.luaobj | 320 | c49635170f25ef619fb4388a602c7c652187937a984d87c6e7c2c132d4e90a3c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashSpellActual.preload | 95 | d326c1b5256f3f9e6fc3435117f1527aa9d63a128e5ce6019cd74d910684c654 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashSpell.inibin | 1396 | 6cef21adb8514390dbf61e85ac38d324332c7b29363984ce52f48836b0571f5c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashSpell.luaobj | 320 | 4f73d515bad3be47e4b3f86b7e62b1fe6cedc9ba0e79166c6a7ef3275fb7309e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashTargeter.inibin | 1167 | b90e1f6d987a92c9e4aedc608e17ecb168a18e5610fde9d77bccd78cfec05cd5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashTargeter.luaobj | 161 | cbff3c76497f0b5e71c084ab45c1ff1bed3b31f18fa253ed6c4b6bf4a1bee53d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDash.luaobj | 118 | e09632df49a2fd0f76998bb48d5744a649cf3b2f5ff6d928b2be980a207150bf |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDash.preload | 104 | 679775195817aa7baad5c4549514095b4aa3d45f445ab64e7c94e98e7954130f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveDashNewTarget.luaobj | 161 | cbff3c76497f0b5e71c084ab45c1ff1bed3b31f18fa253ed6c4b6bf4a1bee53d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveTestForBoots.luaobj | 161 | cbff3c76497f0b5e71c084ab45c1ff1bed3b31f18fa253ed6c4b6bf4a1bee53d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaPassiveChangeBATarget.luaobj | 161 | cbff3c76497f0b5e71c084ab45c1ff1bed3b31f18fa253ed6c4b6bf4a1bee53d |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaMysticShot.inibin | 1157 | eb509eb8fd8f08abfbc3ae99199ab99ae0f0ff948b9c7492d5a6d5bb1670db74 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaMysticShot.luaobj | 272 | f1c61a4f0413962944455e2a7a059c3df7c4d2fca44d9976e7116f35a540f812 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Spells\KalistaMysticShot.preload | 227 | 8e17e8f49a31cab7c97926d3a65e8dada97dc6797782f2d512e9f9e7984c9f2c |

OBJECTIF SYS-01.2-02 : relier les exigences Kalista PASSIF aux sources natives4.20 et aux consommateurs actuels, en conservant le verrou d’annulation déjà présent. Ne pas confondre ce support partiel avec Martial Poise complet.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct.241ressources natives,69références communautaires,2exclusions ;25sources sélectionnées donnent75associations ;26fonctions courantes donnent52liens. Trois questions propres et quatre dépendances conservées.

Alias natif KalistaPassiveBuff,icôneKalista_Passive.dds. Le nom Martial Poise et le BuffData exact sont reliés au fontconfig. PassLev1Desc1 est absent :la description game_character_passiveDescription_Kalista existe dans le fontconfig,mais ce champ ne la référence pas ;ne pas inventer ce lien. Passive1/Desc/Level1..6 absents restent inconnus. Le texte BuffData décrit des attaques non annulables,un échec si la cible quitte la vision,un bond au lancement de l’attaque ou de Pierce après commande de déplacement pendant la préparation,une distance selon le palier de bottes et25% supplémentaires vers l’arrière. Il ne fournit pas ici la formule numérique complète de distance/vitesse.

114Lua entièrement lus,sans fonctions enfants ;24limites NEWTABLE conservées. CharScriptKalista natif est vide. PassiveBuff déclare BuffName,icône et PersistsThroughDeath ;ce n’est pas une exécution des callbacks serveur. Les preloads nomment des dépendances de bottes,attaques,effets et coopération ;ils ne prouvent ni affichage ni gameplay. DDF8lignes vides :KalistaE;f1..4 et section sans nom;f1..4 ;aucune formule de bond extraite. KalistaBasicAttack pointe game_spell_tooltip_CardMasterBasicAttack et PassiveDashSpellActual pointe game_spell_tooltip_ShenShadowDash. Ces clés sont recherchées dans le fontconfig entier et conservées avec leurs correspondances réelles,sans réécriture d’alias ni reprise des dégâts de Shen comme règle Kalista.

Acquis courant :data/4.20/attack_contracts.json contient cant_cancel=true,missile_speed2600,période1.519760012626648s,préparation0.550000011920929s et ratio de vitesse0.5. Les empreintes caractère/sort correspondent aux fichiers natifs. CantCancelWhileWindingUp est relu directement dans le INIBIN de l’attaque :valeur1,conforme au booléen du profil. attacks.rs charge ce profil générique et crée un windup non annulable. cancel_windup refuse alors Stop et Move ;lib.rs ne mémorise donc pas de destination pour le bond. Une recherche textuelle de Kalista seule ne suffit pas à découvrir ce support générique.

Le script communautaire CharScriptKalista.cs est non vide :callbacks OnPreAttack/OnLaunchAttack/OnMoveEnd,orientation,choix d’une distance et vitesse selon bottes,déplacement forcé et reprise de cible. Il contient baseDistance250,speed1025,des incréments de bottes et une formule angulaire,mais aussi des mentions speculative et TODO pour paliers,ralentissements,distance et flags. Ce code C# n’est pas exécuté par notre moteur Rust et ne constitue pas la preuve du serveur historique. Les relations Oathsworn/W/R et leurs dégâts coopératifs restent distincts de la recette du bond.

Diagnostic lié au vrai moteur :huit simulations Kalista/Annie × niveaux1/18 × sans bottes/avec achat public1001. Vraie navigation et monde Map10,douze apports XP serveur et40trajets publics sans réémission. Quatre achats consomment325or sur825 et ajoutent25vitesse de marche. Aucun ajout direct de position,PV,horloge,inventaire ou statistique ;aucun appel de dégâts/soin API dans ce diagnostic.

Chaque simulation commence par une attaque publique ordinaire,puis trois essais pendant un windup attesté :Stop,Move vers l’avant,Move vers l’arrière. Kalista refuse les douze commandes avec attack windup cannot be cancelled ;chaque snapshot est inchangé immédiatement. L’attaque part au tick prévu,touche avec les dégâts physiques attendus,et la position reste fixe jusqu’au tick de lancement+30. Aucun bond ni ordre de déplacement différé n’est observé. Le Stop après impact réussit. Annie accepte les douze commandes,annule son windup,ne lance aucun projectile et ne touche pas ;Move produit seulement de la marche dans la borne vitesse/30. Les deux champions peuvent marcher après les essais. Au total20impacts physiques :16Kalista et4Annie. Les24essais et leurs échantillons sont relus indépendamment dans l’inspection.

132refus publics au total :120Kalista et12Annie. Ils comprennent les douze ordres pendant windup Kalista,Learn/Cast/CastAt des quatre slots Kalista avant/après,joueur inconnu,attaque de soi et slot invalide. Tous les refus conservent le snapshot.16860ticks,1158entrées moteur/ressources identiques avant/après. Binaire non-test,paquets/checksums alignés sur Cargo.lock. Aucun serveur historique,rendu,audio ou réseau exécuté. L’achat des bottes teste la marche,il ne qualifie pas leur effet sur le bond absent.

À compléter :mémorisation et exécution du bond sans annuler le tir,fenêtre exacte de commande,lancement et durée,distance/vitesse selon paliers,direction et bonus arrière25%,collision/murs/terrain,ralentissements et contrôles ;interaction Pierce,Q et autres sorts ;perte de vision avant/après lancement,échec du projectile,changements/disparition de cible,mort/réapparition ;Oathsworn/W/R dans leurs exigences propres. Le code actuel vérifie la vision avant lancement mais ne la revérifie pas dans sa boucle de projectiles libérés :cette lecture statique ne remplace pas un test Kalista de perte de vision. Qualifier aussi animation Attack1_Dash,orientation,effets,H​UD,audio et réplication. Préserver toutes les sources,les inconnues et les cases manuelles. Ni Kalista ni le jeu ne sont terminés.


Précision sur les références héritées :la recherche dans le fontconfig entier trouve zéro correspondance pour game_spell_tooltip_CardMasterBasicAttack et une correspondance pour game_spell_tooltip_ShenShadowDash. La première reste une clé non résolue dans ce fichier exact ;la seconde reste un texte étranger au passif,non repris comme règle Kalista. La description de personnage présente mais non liée par PassLev1Desc1 est une troisième situation distincte.

## Fonctions courantes reliées

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
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/lib.rs:149 | pub fn champion_catalog( |
| crates/core/src/world.rs:226 | pub(crate) fn target_info( |
| crates/core/src/world.rs:244 | pub fn protected( |
| crates/core/src/attacks.rs:17 | fn profiles() |
| crates/core/src/attacks.rs:29 | fn profile_windup_ticks( |
| crates/core/src/attacks.rs:129 | pub(crate) fn cancel_windup( |
| crates/core/src/attacks.rs:141 | fn attack_target_valid( |
| crates/core/src/movement.rs:53 | pub fn movement_speed( |
| crates/core/src/shop.rs:261 | pub fn buy_item( |
| crates/core/src/vision.rs:79 | pub fn visible_to( |

## Résultats attendus et observés

| Propriétaire | Niveau | Bottes1001 | Refus pendant windup | Refus publics totaux | Ticks simulés |
|---|---:|---|---:|---:|---:|
| kalista | 1 | False | 3 | 30 | 2162 |
| kalista | 1 | True | 3 | 30 | 2089 |
| kalista | 18 | False | 3 | 30 | 2136 |
| kalista | 18 | True | 3 | 30 | 2063 |
| annie | 1 | False | 0 | 3 | 2146 |
| annie | 1 | True | 0 | 3 | 2075 |
| annie | 18 | False | 0 | 3 | 2130 |
| annie | 18 | True | 0 | 3 | 2059 |

Attendu du texte natif :le tir ne peut être annulé,mais un ordre Move pendant sa préparation doit produire un bond au lancement. Observé :Kalista conserve bien le tir,mais refuse Stop/Move et reste immobile ;douze refus de windup,dont huit commandes directionnelles,avec snapshots inchangés. L’absence de bond est observée jusqu’au lancement+30ticks. Annie annule ses douze préparations et marche normalement après Move.20impacts physiques conformes ;quatre achats de bottes augmentent la marche de25,ce qui ne qualifie pas la distance du bond.16860ticks,12apports XP serveur,40trajets publics sans réémission ;aucun appel de dégâts/soin API ni injection directe.

L’inspection indépendante vérifie les24essais,les directions,les positions,les bornes de déplacement,les dégâts après armure/régénération et les achats. Les refus de sorts,joueur inconnu,attaque de soi et slot invalide portent le total à132. Le diagnostic ne couvre pas perte de vision,mort,Q,autres paliers de bottes,réseau ou rendu.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-kalista-martial-poise-probe.exe ;6100992octets ;SHA-256 ea5371890bf03abc400ee4384f1dbaf5157720c22bba20a63a695fb3e38a4de3. Vrai F:/OpenLeague/crates/core/src/lib.rs,profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées identiques avant/après. Aucun code de jeu ou asset modifié ;aucun serveur historique exécuté.

## Contrôles de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 1228278c2e42667ba95e14ea423f9eb4941c4e0d9a00047646a15d7246ceecac |
| RUN | 0 | d153d485b277f74075cec35b1bf8acb4e61368c3fd37264dd8525a9e2ad6d417 |
| prepare | 0 | b9bd51723d59c304d4b89a1b747d410749907ad5005c3e3b6d1475feca8cb892 |
| check | 0 | 424cbcab03d8188c92dc0137dbd650fef4678d3e3e4a9b991408441d4d0d1e91 |
| publish | 0 | 598ec43ce5a766a1c8238798f13db4305d3a011a0fbe076c506fb839c31f9a9e |
| audit | 0 | 228d06214f2c26263107f3294bd1bd150f9dc34b56f1d7bc6d5d3afd84f60f7e |

Découverte,inspection,BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Store.task/copy_text et résolution relisent les quatre destinataires. Deux bases :42603autres lignes,42607états manuels et23historiques conservés ;intégrité et synchronisation idempotente vérifiées. Revue indépendante :5494ancres/empreintes exactes,aucun problème,pour99327sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\kalista-passive-martial_poise-links-v663.json. Vérification F:\OpenLeague\docs\fidelity_kalista_passive_martial_poise_links_v663.json. Bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision663_Kalista_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision663_Kalista_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision663_Kalista_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision663_Kalista/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision664_trace_review\REVIEW.json. Scripts et binaire conservés. Neuf copies privées archivées après contrôle de leurs SHA décompressés ;gain logique 2602458881octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision663_Kalista/snapshot-archives/VERIFIED.json ;restauration explicite par revision663_restore_validation_snapshots.py,non exécutée après archivage. Bases actives et sources enregistrées intactes.

## Limites et suite

Manque de comportement moteur :ordre de bond et déplacement au lancement. Données natives non résolues :formule de distance/vitesse et règles exactes de paliers/direction/interactions. Références communautaires présentes mais spéculatives par endroits. Vérifications encore absentes :Q,vision,mort,collision,contrôles,présentation et réseau. Le support cant_cancel est un acquis partiel ;ni Kalista ni le jeu ne sont terminés.

Continuer SYS-01.2-02 depuis revision664_trace_review/REVIEW.json. V663 Kalista Martial Poise publié/audité :25sources natives,75associations,26points/52liens ;241candidats,69références communautaires. Huit simulations Kalista/Annie1/18 avec/sans1001,16860ticks,20attaques,24essais de commande,132refus publics,1158entrées conservées,BUILD/RUN0. Verrou cant_cancel déjà présent et relié au INIBIN ;Move pendant windup refuse au lieu de mettre le bond en attente. Ne pas effacer cet acquis ni inventer une implémentation complète. Description fontconfig présente mais PassLev1Desc1 absent ;DDF vide,CharScript natif vide,114Lua dont24limites NEWTABLE. C# communautaire non vide mais formules partiellement spéculatives. Distance/vitesse/bottes/arrière25%,Q,vision,Oathsworn et présentation restent non qualifiés. Aucun PASSIF-SIMULATION-CONTRAT restant au seul chargeur partagé après ce lot ;ce constat de traçabilité ne termine aucun passif. Prochain lot :inspecter CH-Aatrox-PASSIF-NETWORK et ses consommateurs de snapshot/protocole/transport réels,conserver les références client historiques et les limites du backend local. Le groupe réseau passif reste122fiches au chargeur partagé ;ne pas le traiter comme122implémentations absentes sans lecture. Snapshots V663 restaurables par revision663_restore_validation_snapshots.py. Goal actif.
