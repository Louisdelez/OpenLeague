# SYS-01.2-02 — Cassiopeia / Aspect of the Serpent, V661

Date UTC 2026-10-27T05:26:30.045402+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V661 Cassiopeia / Aspect of the Serpent : 31 sources natives, 93 associations, 25 points actuels et 50 liens de frontière. Déclencheurs poison/TwinFang et paliers décrits mais producteurs non qualifiés ; ancien alias DeadlyCadence conservé. Quatre achats publics Codex :30AP et10%CDR ; quatre contrôles de soin API distincts du passif. Sorts Cassiopeia refusés. 70 refus publics et 40 refus API sans mutation, 9274 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les fiches CH-Cassiopeia-PASSIF-SOURCE,CH-Cassiopeia-PASSIF-SIMULATION-CONTRAT et CH-Cassiopeia-PASSIF-SIMULATION reçoivent sources,preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse.31ressources donnent93associations ;25fonctions courantes donnent50liens sur les deux fiches de simulation. Tous restent entry_boundary_only,provides_feature_consumer=false et gameplay_accepted=false. Trois questions et quatre dépendances préservées ;prérequis consignés,sans acceptation implicite. Inconnues,identifiants et hiérarchie inchangés octet par octet ;statuts,critères et états manuels conservés.

## Sources et instructions

53ressources natives,22références communautaires,14exclusions. Tailles,SHA et appartenance RADS vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague,projet courant F:/OpenLeague. Deux DDF séparés par chemins complets ;18Lua entièrement lus,sans fonctions enfants.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Cassiopeia.inibin | 1814 | 3ac38220c74b5dcd80c534a1e084882287e07596b6ac81182193a3bb2143a9de |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\CharScriptCassiopeia.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\CharScriptCassiopeia.preload | 975 | 2ba2a4761d72e62ff06ebfe8e08d3a0d980f07dd872b8efec83059bd9514606c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Cassiopeia.ddf | 213 | 3c999f2c20fa10055a2525f7e16cc62858c984779186b07cf8c08e9c88084e16 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Localization\Cassiopeia.ddf | 392 | b8cbd737cc15ba70bdcd514fe80c6db6d82391fddb778e777f8ba92619fc8050 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaDeadlyCadence.inibin | 55 | 7363083eb5c4edc78b0e0a7f0a56b0791ea265990edfef44129f9976b790d1d8 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaDeadlyCadence.luaobj | 398 | 9ecb7a76fb7e1f520e2955be97d83f3ef6640794bc520954e058308cd3a7fdb2 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaDeadlyCadence.preload | 99 | 60754803a06a0728113c7cf51ae37ed40dd9272e6c5b15b5eb8ec74d5f25e225 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker.inibin | 61 | a83e0c3e6d4a64353ddb3ca7843c617a8add837a9dfadd7577dc6352842093c0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker.luaobj | 437 | 1cf967ea2ec1d96f838c1b399d539cedfa0e5434d57ab50c9c188d4a1b7c6e9f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker2.inibin | 62 | 482ae471481c482551d38db9854a98de450babfc14df707e8989d360e7b5e886 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker2.luaobj | 438 | f5a74841203e6b5edc10c0204604af58c26cd5ee0a466e6119edd624fbcf48dd |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker2.preload | 172 | a2ac0b46780db7c1d3742be0bd7d69eea68d8dce3ddf32c4e26e27f33c4c1a49 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker3.inibin | 62 | b3989233d7e7f55555b6d6f673890e41496a557202e642ac56c5878e363fdecb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker3.luaobj | 438 | 73643ba0bdd5a17198c864c5f8f901292677adc5d2bf9ced36e9cc7c57fe47a7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker3.preload | 172 | a2ac0b46780db7c1d3742be0bd7d69eea68d8dce3ddf32c4e26e27f33c4c1a49 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker4.inibin | 62 | 3be6e4019b36f2408ff192bb23e892ed8bbcb6d12e08ea98751509296486519a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker4.luaobj | 438 | 1c21a2b671d9d860f19c603ade7c45a79dca63e85415b2b6f0012f299533b628 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTicker4.preload | 172 | a2ac0b46780db7c1d3742be0bd7d69eea68d8dce3ddf32c4e26e27f33c4c1a49 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTickerLockout.inibin | 61 | 088613bf069d6077812bcb1a82293b959eb68e1926f3ddc6e6e65c804f63d0ad |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonTickerLockout.luaobj | 378 | ea0466f8474255be63801d15b1887e8aae853a8a90ef9054424d0946f15b51ed |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonParticleManager.inibin | 63 | dd5ab285622cdee3f830d8d2c00dabec2ed24ec568a8941deadeb716b086f528 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaPoisonParticleManager.luaobj | 378 | ea0466f8474255be63801d15b1887e8aae853a8a90ef9054424d0946f15b51ed |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaTwinFang.inibin | 1567 | a1000ac96afb6dde131548fcd7e1bf353a9c3f84fe213e98dbed93311a726f62 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaTwinFang.luaobj | 261 | 6b7fc71775f1f3034430dd632c42ed77830ebe421a76298e93f3734440363faa |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaTwinFang.preload | 280 | dca539dcb929d6f53b82fcbbc5e1ea3bfcf424b4508c83acd14ee54bb12d6755 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaNoxiousBlast.inibin | 1467 | 8172f896b02088ca558a4b62be307e0c601a2873e00bad1b6ac9107ce37442ff |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaMiasma.inibin | 1621 | 2892226ddd32f192bc048a6598a775941f0d47857318624e23cea9eb96ee77f7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaNoxiousBlastPoison.luaobj | 301 | 74fde5683c39df01e260ad9433f0eb65f5538cf9d73f4ff4166a2ee141b2a82a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Cassiopeia\Spells\CassiopeiaMiasmaPoison.luaobj | 289 | caa31c78aea31c104246ab5e3e2ae4fe369d030046398a8b24316cb3156faca6 |

OBJECTIF SYS-01.2-02 : relier les exigences Cassiopeia PASSIF aux sources natives4.20 et aux fonctions réellement présentes. Ne pas déclarer Aspect of the Serpent implémenté à partir des contrôles génériques.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Découverte53ressources natives,22références communautaires,14exclusions ;31ressources sélectionnées,93associations,25points et50liens. Les3questions et4dépendances restent conservées.

Le personnage référence CassiopeiaDeadlyCadence et Cassiopeia_DeadlyCadence.dds,mais les textes exacts nomment Aspect of the Serpent. Ne pas substituer le passif ancien de réduction de mana ni le passif moderne. Le texte BuffData décrit une charge par seconde de poison sur champion ennemi,par unité empoisonnée tuée et quand TwinFang touche un champion ennemi. Il décrit trois paliers,bonus de puissance,soin TwinFang et réduction des délais. Les paramètres f1/f2/f3/f4/f5/f6/f7/f8/f9/f10/f11 restent sans producteurs qualifiés ;les noms d’un paramètre peuvent varier selon le tooltip et ne doivent pas être fusionnés.

Deux Cassiopeia.ddf distincts :racine quatre lignes,dont seul CassiopeiaTwinFang;f1 relie spelldamage avec coefficient0,55 ;Localization huit lignes vides. Le tooltip TwinFang utilise f2 pour son bonus,dont cette entrée f1 ne résout pas le producteur. Aucun DDF ne renseigne les paliers. Les champs absents ne valent pas zéro.

18Lua sont entièrement lus,initialisations littérales qualifiées,sans fonctions enfants. CharScriptCassiopeia est vide. DeadlyCadence et PoisonTicker1..4 déclarent PersistsThroughDeath et NonDispellable ;cela ne démontre pas la conservation des charges à la mort dans le moteur. Les Tickers portent des icônes DeadlyCadence1..4. PoisonTickerLockout et PoisonParticleManager conservent BuffName CassiopeiaNoxiousBlastHaste et son icône ;leurs deux clés BuffData tooltip sont absentes du fontconfig exact. Ne pas corriger silencieusement ces anciennes références. Les poisons Q/W pointent vers Global_Poison.troy. Les preloads décrivent des dépendances, pas une preuve de rendu ni un callback serveur.

Recherche bornée dans crates/core/src :aucune occurrence Cassiopeia,DeadlyCadence,PoisonTicker ou Aspect of the Serpent. Les statistiques actuelles viennent des objets et de l’autel ;aucun compteur de charges Cassiopeia n’a été identifié. Dans LeagueSandbox-Scripts,CharScriptCassiopeia est vide ;Q/W ajoutent CassPoison,E le cherche et double les dégâts,mais aucune définition CassPoison n’est retrouvée dans le périmètre inspecté. Ce doublement n’est pas accepté comme contrat natif. Le texte natif TwinFang décrit0,5s de délai sur cible empoisonnée et restitution du coût+3%mana totale sur kill ;la branche C# examinée ne les réalise pas. Références communautaires,client historique et moteur Rust restent séparés.

Diagnostic réel :quatre simulations Cassiopeia1/18 et Annie1/18,ennemi Annie18,sur navigation/monde Map10. Six apports XP serveur préparent les niveaux ;huit trajets Move/Stop publics réussissent sans réémission. Chaque propriétaire achète publiquement le Codex3108 pour820or sur825 :30AP,10%CDR,5or restant. Ces bonus viennent de l’objet,pas des paliers. Aucune injection directe d’état,de position,de PV,d’or,d’inventaire ou d’horloge.

Chaque simulation réalise une attaque publique ordinaire ;son projectile et ses dégâts physiques après armure/régénération sont vérifiés. Deux événements API de40dégâts magiques bruts servent de contrôles distincts et correspondent à40×100/(100+RM). Les horizons151ticks après attaque et dégâts suivent uniquement la régénération attendue ;ils ne sont pas des applications de poison et ne prouvent ni charges ni cadence native.

Contrôle de soin :80dégâts vrais via API serveur préparent une perte de PV ;heal25 restaure25,heal100000 complète les55manquants,heal0 ne restaure rien. Le mana reste inchangé. Ce soin n’est pas un TwinFang ni un bonus de palier. NaN,infini,négatif,source/cible inconnue sont refusés pour dégâts et soin,snapshots inchangés. Total40refus API.

Pour Cassiopeia,Learn/Cast/CastAt des quatre slots sont refusés avant/après les contrôles ;les refus de joueur inconnu,attaque de soi et slot invalide sont vérifiés. Comparaison distincte Annie :LearnQ/CastQ publics produisent104bruts avec30AP,coût60,délai8ticks et cooldown108ticks avec10%CDR ;les impacts respectent la mitigation et la régénération après Q. Ce contrôle ne qualifie pas TwinFang. Total70refus publics,9274ticks,1158entrées moteur/ressources inchangées,binaire non-test avec dépendances/checksums Cargo.lock alignés. Aucun serveur historique,rendu,audio ou réseau exécuté.

À compléter :producteurs exacts des seuils,cap et gains ;qualification de l’état Poison et des propriétaires ;secondes continues/discontinues,plusieurs victimes,poisons alliés,kill/crédit et TwinFang sur champion ;cumuls,verrouillage,ordre des événements,bonus AP composés,CDR/plafond et soin ;mort/réapparition,dissipation,équipes et cibles ;durées et valeurs nativesQ/W/E distinctes ;réplication,sauvegarde,HUD/compteurs/icônes,animations,particules/audio. Résoudre les deux tooltips absents et les métadonnées héritées. Préserver toutes les preuves,critères,notes et états manuels. Ni Cassiopeia ni le jeu ne sont terminés par cette livraison de traçabilité.


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
| crates/core/src/healing.rs:16 | pub fn heal( |
| crates/core/src/healing.rs:9 | pub fn received_multiplier( |
| crates/core/src/shop.rs:261 | pub fn buy_item( |
| crates/core/src/cooldown.rs:11 | pub fn ticks( |
| crates/core/src/annie.rs:45 | pub(crate) fn cast_annie( |
| crates/core/src/annie.rs:73 | pub(crate) fn advance_annie( |

## Résultats des simulations

| Propriétaire | Niveau | Refus publics | Refus API | Ticks simulés |
|---|---:|---:|---:|---:|
| cassiopeia | 1 | 27 | 10 | 2234 |
| cassiopeia | 18 | 27 | 10 | 2232 |
| annie | 1 | 8 | 10 | 2405 |
| annie | 18 | 8 | 10 | 2403 |

Attendu/observé :Codex3108 apporte30AP/10%CDR pour820or ;quatre achats publics vérifiés. Quatre attaques ordinaires correspondent aux dégâts physiques après armure/régénération. Huit événements API magiques distincts correspondent à40×100/(100+RM). Quatre préparations de80dégâts vrais permettent des contrôles de soin25puis55au plafond et0 ;ces valeurs ne sont pas les paramètres natifs du passif. Deux tirs publics AnnieQ donnent104bruts,60mana,8ticks de cast et108ticks de cooldown.70refus publics et40API sans mutation. Six apports XP serveur,huit trajets publics sans réémission. Aucun état injecté directement. Poison,charges,paliers,soin TwinFang et persistance ne sont pas exercés ;les sorts Cassiopeia restent refusés.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-cassiopeia-aspect-probe.exe ;6129152octets ;SHA-256 0196f6a769d1c6059053dda7ccfdf297e35fbe239b1c0200691c4088466fa84b. Vrai F:/OpenLeague/crates/core/src/lib.rs,profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées identiques avant/après. Aucun code de jeu ou asset modifié ;aucun rendu,audio,réseau ni serveur historique exécuté.

## Contrôles de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 964ba17eb13ff8b3e134666173e6c07056ebc9e9adc331148bd1939785acc59b |
| RUN | 0 | 2e6ef40429481e91b7de9f5872898a7d0c0d78c21c46ce0e21ed09192897d854 |
| prepare | 0 | c8617fa146b4e7281c6ba0c2b632b6b7acc00e1ca24e9ea21182ef17f4f7bc85 |
| check | 0 | 53dd00ae0116cf011e6517fedca73acfcd02ca812279c943457208c7db61acd3 |
| publish | 0 | 198fb0fdfcdf56b8204d1a5390124bb3b8b709e51cd74954528da130e8a7f178 |
| audit | 0 | 2193bf0be6ec98f6e31e08a8d779c2a356b0ffcc3e46eee4f45dc0567e292118 |

Découverte,inspection,BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Store.task/copy_text et résolution relisent les quatre destinataires. Deux bases :42603autres lignes,42607états manuels et23historiques conservés ;intégrité et synchronisation idempotente vérifiées. Revue indépendante :5447ancres/empreintes exactes,aucun problème,pour99319sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\cassiopeia-passive-aspect_of_the_serpent-links-v661.json. Vérification F:\OpenLeague\docs\fidelity_cassiopeia_passive_aspect_of_the_serpent_links_v661.json. Bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision661_Cassiopeia_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision661_Cassiopeia_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision661_Cassiopeia_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision661_Cassiopeia/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision662_trace_review\REVIEW.json. Scripts et binaire conservés. Neuf copies privées archivées après vérification de leurs SHA décompressés ;gain logique 2582987388octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision661_Cassiopeia/snapshot-archives/VERIFIED.json ;restauration explicite par revision661_restore_validation_snapshots.py,non exécutée après archivage. Bases actives et sources enregistrées intactes.

## Limites et suite

Producteurs des gains,seuils,bonusAP/CDR et soin encore non qualifiés. Les deux tooltips absents et anciennes métadonnées restent signalés. Poison par propriétaire,cibles multiples,kill/crédit,ordre des événements,plafonds,cycles de vie et réplication nécessitent leurs propres preuves. Ni Cassiopeia ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision662_trace_review/REVIEW.json. V661 Cassiopeia Aspect of the Serpent publié et audité :31sources natives,93associations,25points/50liens ;53candidats,22références communautaires. Quatre simulations Cassiopeia/Annie niveaux1/18,9274ticks,70refus publics40API,1158entrées inchangées,BUILD/RUN0. Quatre achats publics Codex3108 donnent30AP/10%CDR ;quatre soins API25/cap55/zero et deux AnnieQ104/cooldown108 sont des contrôles distincts. Poison,gains de charges,paliers,bonus et soin TwinFang natifs non exercés ;sorts Cassiopeia refusés.18Lua sans fonctions enfants ;alias DeadlyCadence et métadonnées persistantes ne prouvent pas les callbacks. Deux DDF par chemins complets,aucun producteur de paliers,unique lienTwinFang f1=.55 différent du tooltip f2. Deux tooltips manquants :PoisonTickerLockout et PoisonParticleManager. C#Q/W/E référencent CassPoison sans définition retrouvée ;E doublement non accepté. Prochain lot :Fiora PASSIF Duelist4.20,contrat encore au chargeur partagé selon revue actuelle ;inspecter régénération et cumuls du passif historique,sans substituer les points vitaux modernes. Snapshots V661 archivés/restaurables par revision661_restore_validation_snapshots.py. Goal actif. Première découverte Fiora exécutée0 :revision662_Fiora_discovery/OBSERVATIONS.json,64ressources natives,26références communautaires,4exclusions.28Lua entièrement lus,sans fonctions enfants,six limites NEWTABLE. Alias FioraDuelist/icôneFiora_Duelist.dds ;BuffData annonce dégâts physiques,durée6s et4cumuls contre champions,description du personnage dit dégâts sans préciser physique :conserver cette différence. f1soin non résolu ;DDF8lignes lie seulement Q/Dance au bonusAD0,6/1,2. CharScript vide ;Duelist et DuelistHot déclarent persistance/non-dissipation,Hot porte effets d’activation vides :pas une preuve du comportement. Aucun diagnostic moteur Fiora exécuté.
