# SYS-01.2-02 — Braum / Concussive Blows, V660

Date UTC 2026-10-27T05:12:05.588872+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V660 Braum / Concussive Blows : 26 sources natives, 78 associations, 22 points actuels et 44 liens de frontière. Texte4.20 : quatre marques par Braum puis attaques alliées, durée annoncée4s,étourdissement/dégâts puis immunité et bonus de Braum ; f1/f2/f3/f5 ouverts. Huit séquences de quatre coups en110ticks,52attaques ordinaires sans effet du passif observé ; contrôles Garen et API distincts. 92 refus publics et 28 refus API sans mutation, 14809 ticks, dix apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les fiches CH-Braum-PASSIF-SOURCE,CH-Braum-PASSIF-SIMULATION-CONTRAT et CH-Braum-PASSIF-SIMULATION reçoivent sources,preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse.26ressources donnent78associations ;22points courants donnent44liens sur les deux fiches de simulation. Tous restent entry_boundary_only,provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis sont consignés sans être déclarés accomplis. Inconnues,identifiants et hiérarchie restent identiques octet par octet ;statuts,critères,acceptations et états manuels restent inchangés.

## Sources et instructions de reprise

290ressources natives,dont181sous Deprecated,47références communautaires et six exclusions conservées. Tailles,SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ;le projet courant est F:/OpenLeague.125Lua lus,45limites NEWTABLE,aucune fonction enfant. Les six noms E/Q/W dupliqués sont séparés par chemins complets ;les26sources sélectionnées sont hors Deprecated.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Braum.inibin | 1365 | fd19cd86048c49700ac805a79802af15dc22d107b4570271cb05e4f71025baec |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\CharScriptBraum.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\CharScriptBraum.preload | 872 | 3d6952aae0cc67bff147b50ee5c2b90dd603908160f09f1a0e879e9681603f84 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Braum.ddf | 2311 | 002f988c74f000443993c5a61c8cf002d565ac1a04035e636b07a0aad21e32eb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMark.inibin | 193 | 223acf96b5b3b33d02ccf1c5dbeec40470d794bb432ad2494dbcabfad4ee5aee |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMark.luaobj | 145 | 31fd4f22bb8237d03c41b39b306b0714ac1ed2bdd02ff0bd4ea1007870cef813 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMark.preload | 590 | be2dda1f0543cffcd14c83f07c5a07c4c80e8da05025b25b400b3e7d40db69cf |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkStunReduction.inibin | 54 | 30d08f0cb8faa2bbc0724277ca2c1e3e2d4c3ced7b85a3ff4ecb1e5d722332f8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkStunReduction.luaobj | 158 | 9feb14fbf0caf1878fd6d70577b3ad42fa511e9c578c0cfc6a4a2050d3ca2091 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkStunReduction.preload | 276 | 3e39d2f5b464ed0055f0ef283c197d3f9091f52226f385404f179da2756b1224 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumPassive.inibin | 193 | 223acf96b5b3b33d02ccf1c5dbeec40470d794bb432ad2494dbcabfad4ee5aee |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumPassive.luaobj | 156 | cf8660701267ddefa66e53f1ae945556c79edfa6d34427da152f9ba9d76c9200 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumPassive.preload | 234 | 3c5ce606e053f4cfab2e3b3ed101c418a6a90b32e5a7c20e992bc63e2c22be41 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkDamageTracker.inibin | 84 | 81d46d97b2450630a403631e77aeca35d3af6bdd54cad4ff9db4ceb6304d7536 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkDamageTracker.luaobj | 163 | 2f58c4c844a5912ccff778b11b3b9f2ef442b5c8f11c556d09a3734b4ce53ac4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkDiminish.inibin | 49 | 72071caa0cf540446382bbe06a560fb678a05c387894e3bcc0130b8a3cb5dd08 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkDiminish.luaobj | 158 | 492c6544b7140685ccea033e4a304d26d38e6b9648eb5b1a367a05f1e11523f3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumStunDebuff.inibin | 47 | b2a47fd98c4d08f3d529d73683b41b7d6f35c311019846252d3547e80e002c7a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumStunDebuff.luaobj | 439 | 5f59ee16e0c871f14f3ef09fdf3b2104052ff22bda2ccddb5fb1df0108a4c797 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumBasicAttackPassiveOverride.inibin | 1595 | a536fb1561c2ac8bfbf1afb75d0ea900f963edc4da0574f85122d4a976c792fe |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumBasicAttackPassiveOverride.luaobj | 115 | 71ac483c97e007da8f721cb1948891adf59482b11306b807a383cc4651ca37d4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumQ.inibin | 1360 | 7cd9c9091d542ccc27ff14be30bac24ac5b19d9b2ecac767e7a0612bae4096c7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumQ.luaobj | 322 | 1d5b7c929378b4fb6e4465f1859adb3819c44c99a2a326f1055806186b7e2490 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkCounter.luaobj | 158 | 5b156c32a456b18b851c46d8a682fe6872b7fc548b8d21be27b070f4d27cc3a7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Spells\BraumMarkCounter.preload | 149 | a70beb3bc36af63a3513b54317b540118785ffbb83edec1991283a5c39f40348 |

V660 Braum / Concussive Blows : 26 sources natives, 78 associations, 22 points actuels et 44 liens de frontière. Texte4.20 : quatre marques par Braum puis attaques alliées, durée annoncée4s,étourdissement/dégâts puis immunité et bonus de Braum ; f1/f2/f3/f5 ouverts. Huit séquences de quatre coups en110ticks,52attaques ordinaires sans effet du passif observé ; contrôles Garen et API distincts. 92 refus publics et 28 refus API sans mutation, 14809 ticks, dix apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Concussive Blows4.20 et relier son producteur réel. Braum.inibin indique Passive1LuaName=BraumMarkDamageTracker,icôneBraum_Passive.dds,nom et description exacts. Passive1,Passive1Desc et Passive1Level1..6 sont absents,pas zéro. Le texte décrit une première marque par attaque de Braum ou Winter’s Bite/Q ; après cette première marque,les attaques alliées contribuent. Quatre marques déclenchent étourdissement et dégâts magiques. Le tooltip tracker annonce4secondes pour la marque,puis une période sans nouvelles marques pendant laquelle les attaques de Braum infligent un bonus magique. Les paramètres @f1@dégâts,@f2@durée du stun,@f3@immunité et @f5@bonus restent sans producteur qualifié.

290ressources natives inspectées,dont181sous Deprecated ;47références communautaires et six exclusions conservées. Les26sources liées sont hors Deprecated,identifiées par chemins complets. Les six noms BraumE/Q/W.inibin/luaobj existent aussi sous Deprecated :ne jamais les écraser dans un index par basename ni choisir la variante ancienne comme contrat courant.125chunks Lua lus entièrement sans fonctions enfants ;45limites NEWTABLE conservées. Le CharScript natif est vide. Le DDF contient48lignes,dont neuf renseignées ;aucune entrée BraumMark. Le lien historique BraumSlowShot;f1 vers MarkDamage et les autres noms anciens ne constituent pas un producteur prouvé des paramètres du tracker courant.

Conserver les références héritées :MarkDamageTracker porte l’icôneKennen_MarkOfStorm.dds ;MarkCounter déclare KennenMarkOfStorm ;MarkDiminish déclare KennenMoSDiminish. BraumPassive utilise LeonaShieldOfDaybreak.DDS. BasicAttackPassiveOverride contient LeonaSkin04 avec une limite NEWTABLE :ne pas conclure que les globals originaux sont vides. Le Q courant hors Deprecated porte GemKnight_Shatter.dds et MaokaiTrunkSmash ;ne pas réécrire ces métadonnées pour masquer leur origine. Ses valeurs numériques et son tooltip décrivent Q, pas les dégâts du passif.

Le BuffData de BraumMarkDiminish pointe vers game_buff_tooltip_BraumMarkDiminish,absent du fontconfig exact. Les liens de BraumMark,DamageTracker,StunReduction,StunDebuff,Passive et les tooltips SpellData de Mark/Passive/Q sont retrouvés. La métadonnée StunDebuff contient IsDamagingSpell=true et LOC_Stun.troy ;les preloads des marqueurs et du timer décrivent des dépendances, pas l’exécution de l’étourdissement ou du rendu. Les3questions et4dépendances existantes restent ouvertes/conservées.

Recherche bornée :aucun Braum/Concussive Blows dans crates/core/src. Le CharScript C# est vide. Q communautaire appelle BraumConcussive,mais la recherche ne retrouve pas sa classe de buff ;le nom diffère des aliases natifs et les scripts communautaires restent des références distinctes du moteur Rust et du serveur original. Aucune absence dans toute archive n’est déduite de ce périmètre.

Diagnostic :quatre simulations Braum1/18 et contrôles Garen1/18,avec Annie18 alliée et Annie18 ennemie,sur la vraie navigation/monde Map10. Dix apports XP par API serveur préparent les niveaux ;douze trajets Move/Stop publics réussissent sans réémission. Aucune injection directe de position,PV,horloge,statistique ou unité. Toutes les attaques passent par Action::Attack puis Stop,avec témoin de windup pour les coups mêlée et de projectile pour Annie.

Dans chaque simulation :quatre attaques alliées sans marque préalable du propriétaire servent de contrôle négatif ;une attaque du propriétaire suivie de trois attaques alliées forme ensuite une séquence de quatre coups en110ticks,inférieure aux120ticks correspondant à4secondes. Puis un coup supplémentaire du propriétaire est observé,121ticks s’écoulent,et une nouvelle séquence propriétaire+trois coups alliés intervient également en110ticks. Total13coups par simulation,52au total,huit séquences et16coups alliés de contrôle négatif. Les dégâts observés correspondent seulement aux dégâts physiques après armure et régénération ;aucun étourdissement ni supplément magique du passif n’est observé. Aucune mécanique de marque spécifique n’est trouvée dans les chemins inspectés. Attendre121ticks sans déclenchement ne valide pas l’expiration native ni la période d’immunité.

Pour Braum,Learn,Cast et CastAt des quatre slots sont refusés avant/après les séquences. Les refus de joueur inconnu,attaque de soi et slot invalide sont aussi vérifiés. Le Q n’est donc pas exercé comme initiateur de marque. Garen sert de comparaison d’attaque ordinaire ;son kit complet n’est pas qualifié par ce contrôle.

Contrôles distincts :40dégâts magiques bruts via apply_damage par simulation retirent40×100/(100+RM)PV ;ce n’est pas la formule native f1/f5. grant_stun applique ensuite une durée diagnostique de60ticks avec un tag explicitement distinct. Les commandes Move,Attack,Cast et CastAt sont refusées aux ticks0et59 ;le stun est absent au tick60 et Move/Stop sont acceptés. Cette durée n’est pas f2,ces appels serveur ne sont ni un proc Braum ni une autorité joueur. NaN,infini,négatif pour les dégâts,source/cible inconnue,tag vide et durée nulle pour le stun sont refusés sans mutation. Total92refus publics et28API.

Total14809ticks,1158entrées inchangées,binaire non-test du vrai moteur F:/OpenLeague/crates/core/src/lib.rs,dépendances/checksums alignés sur Cargo.lock. Aucun rendu,audio,réseau ou serveur historique exécuté. Les tableaux de dégâts et les bornes du stun API sont recalculés/vérifiés indépendamment dans l’inspection.

À compléter :producteurs f1/f2/f3/f5,marques par cible et propriétaire,ordre d’application/déclenchement,contribution des alliés,durée/rafraîchissement,cumul,multi-Braum,cibles éligibles,application par Q,bonus pendant immunité et disponibilité après sa fin. Qualifier mitigation,boucliers,contrôles/dissipation/ténacité,crédit de kill,mort/disparition des acteurs et changements d’équipe. Résoudre les références anciennes et le tooltip absent. Relier séparément réplication,sauvegarde,HUD/compteur/icônes,animations,particules et audio. Préserver critères,preuves,notes et états manuels ;cette traçabilité ne termine ni Braum ni le jeu.


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
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/stuns.rs:15 | pub fn grant_stun( |
| crates/core/src/stuns.rs:37 | pub(crate) fn advance_stuns( |
| crates/core/src/stuns.rs:6 | pub fn active( |
| crates/core/src/lib.rs:149 | pub fn champion_catalog( |
| crates/core/src/world.rs:226 | pub(crate) fn target_info( |
| crates/core/src/world.rs:244 | pub fn protected( |

Les chemins d’attaque alliée/propriétaire,dégâts,mitigation,régénération et étourdissement sont inspectés et exercés. Les sorts Braum restent refusés. La recherche bornée ne trouve aucune logique de marque Braum dans crates/core/src ;elle ne prouve pas une absence dans toute archive. Le contrôle d’étourdissement API est distinct du déclenchement natif attendu au quatrième coup.

## Résultats attendus et observés

| Propriétaire | Niveau | Coups | Premier→quatrième (ticks) | Refus publics | Refus API | Ticks simulés |
|---|---:|---:|---:|---:|---:|---:|
| braum | 1 | 13 | 110 | 35 | 7 | 3711 |
| braum | 18 | 13 | 110 | 35 | 7 | 3699 |
| garen | 1 | 13 | 110 | 11 | 7 | 3704 |
| garen | 18 | 13 | 110 | 11 | 7 | 3695 |

Par simulation,quatre attaques alliées sans marque du propriétaire précèdent deux séquences propriétaire+trois attaques alliées,un coup supplémentaire du propriétaire et une attente121ticks. Les huit quartets prennent110ticks chacun,donc moins que les120ticks correspondant à4secondes. Les52impacts correspondent au seul calcul physique après armure,régénération prise en compte ;aucun stun ni supplément magique n’apparaît. Le témoin est le windup pour les coups de mêlée et le projectile pour ceux d’Annie. Les mêmes contrôles sont réalisés avec Garen. Aucun stun natif n’ayant été déclenché,l’attente ne qualifie ni expiration de marque ni immunité.

Quatre événements API magiques distincts de40bruts correspondent à40×100/(100+RM)PV. Quatre stuns diagnostiques60ticks bloquent Move/Attack/Cast/CastAt à0et59,puis expirent à60 ;Move/Stop sont ensuite acceptés. Les snapshots des92refus publics et28refus API sont identiques avant/après. La durée60n’est pas le paramètre natif f2. Dix apports XP serveur et douze trajets publics sans réémission ;aucune injection directe d’état.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-braum-concussive-blows-probe.exe ;6110720octets ;SHA-256 c6b3ac4234c0fa89fc615413a9f406deb5b75f8a57195ec8fee5c78ec1c6a218. Vrai F:/OpenLeague/crates/core/src/lib.rs,profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ou asset modifié. Aucun rendu,audio,réseau ou serveur historique exécuté.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 161b20806743faf81f244880b62b5587b872d9aac58bdcb35d693d417ba2ceda |
| RUN | 0 | 998527d9b39abc1827553d6a48de416514efc6d9316f03cf4b80fbbdf7472895 |
| prepare | 0 | 2e469378069bf2e8171ebe41e5ed453f5210573f8a81bad26a648c7b05670b06 |
| check | 0 | 7368b3ff557730271cecd7ad5f00e7641c122dc49b3c6ea4475c736ff3a60ccb |
| publish | 0 | d23bc0e3066d0e18f57fd24efc9e48f3265113bd194aff1c9518c91a3286eb7b |
| audit | 0 | b5f7d4a55a4f90a74029ad75443b460e94ae978d96f48926234207befd685412 |

Découverte,inspection,BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources,questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5422ancres/empreintes exactes,aucun problème,pour99315sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\braum-passive-concussive_blows-links-v660.json. Vérification F:\OpenLeague\docs\fidelity_braum_passive_concussive_blows_links_v660.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision660_Braum_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision660_Braum_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision660_Braum_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision660_Braum/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision661_trace_review\REVIEW.json. Scripts et binaire conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ;gain logique 2568191083octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision660_Braum/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ;restauration explicite par revision660_restore_validation_snapshots.py,non exécutée après archivage.

## Limites et suite

Marques,étourdissement/dégâts au quatrième coup,période d’immunité et bonus de Braum ne sont pas réalisés dans les chemins testés. Les producteurs f1/f2/f3/f5 restent ouverts ;les paramètres anciens du DDF ne sont pas réutilisés comme valeurs par défaut. Les sources conservent leurs références Kennen/Leona/Taric/Maokai et le lien MarkDiminish non résolu. Q,multi-Braum,catégories de cibles,rafraîchissement,cycle de vie,HUD,rendu,audio,réseau et sauvegarde nécessitent des contrôles séparés. Ni Braum ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision661_trace_review/REVIEW.json. V660 Braum Concussive Blows publié et audité :26sources natives,78associations,22points/44liens.290sources inspectées dont181Deprecated,47références communautaires ;six basenames E/Q/W distincts par chemin complet. Quatre simulations Braum/Garen niveaux1/18 avec allié/ennemi Annie18 :52attaques,huit quartets propriétaire+allié en110ticks,sans stun ni supplément magique ;92refus publics+28API,14809ticks,1158entrées conservées,BUILD/RUN0. Quatre stuns API60ticks et quatre dégâts API40bruts sont des contrôles distincts,ne qualifient pas les paramètres f1/f2/f3/f5. Durée4s/quatre marques documentées ;expiration,immunité,multi-Braum,Q et rendu ouverts. Références Kennen/Leona/Taric/Maokai,tooltip MarkDiminish absent et DDF48lignes historiques conservés. Prochain lot :Cassiopeia PASSIF Aspect of the Serpent4.20,contrat encore au chargeur partagé selon revue actuelle ;inspecter déclencheurs et paliers sans substituer Deadly Cadence ancien ou passif récent. Snapshots V660 archivés/restaurables par revision660_restore_validation_snapshots.py. Goal actif. Première découverte Cassiopeia exécutée0 :revision661_Cassiopeia_discovery/OBSERVATIONS.json,53ressources natives,22références communautaires,14exclusions.18Lua entièrement lus,sans fonctions enfants ni limite de lecture littérale. Deux Cassiopeia.ddf distincts par chemin :racine4lignes,dont seul TwinFang f1=spelldamage×0,55 rempli ;Localization8lignes vides. Aucun producteur des paliers du passif identifié dans ces DDF. Texte natif Aspect of the Serpent :poison sur champion par seconde,unités empoisonnées tuées et TwinFang sur champion ;bonus AP,soin TwinFang et CDR selon paliers non résolus. Alias DeadlyCadence conservé sans lui attribuer ancien passif mana ou passif moderne. Recherche Rust bornée sans occurrence Cassiopeia ;références C# Q/W/E/R à examiner. Aucun diagnostic moteur Cassiopeia exécuté.
