# Lulu et Pix — sources et consommateurs, V596

Date UTC : 2026-10-26T07:28:59.243744+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, liaison des exigences aux sources natives et aux consommateurs actuels.

## Résultat

Trois fiches enrichies : `CH-Lulu-PASSIF-SOURCE`, `CH-Lulu-PASSIF-SIMULATION-CONTRAT`, `CH-Lulu-PASSIF-SIMULATION`. **60 sources natives, 180 associations, 22 points de code et 44 liens** ; quatre sources de preuves ajoutées. Trois questions propres et quatre dépendances conservées, sans changement de statut ou de critère.

Deux cas publics du moteur actuel vérifient **six projectiles et impacts physiques ordinaires, 54 refus atomiques et 360 ticks d'attente**. Les attaques de Lulu sont acceptées ; aucun dommage magique supplémentaire de Pix n'est observé. L'achat de +20 puissance ne modifie pas ce résultat. La salve native de Pix n'est pas qualifiée. Aucun sort de Lulu n'est accepté, donc son transfert par E n'est pas exercé.

Ces résultats localisent une lacune de gameplay. Ils ne démontrent pas un manque global de modèles, textures ou animations. Aucun code de jeu ni asset modifié par cette livraison de traçabilité.

## Sources et contrats

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. Taille, SHA-256 et appartenance aux manifestes RADS sélectionnés vérifiées pour les 60 fichiers ; cela ne reconstitue ni l'ordre de montage historique ni le serveur original.

| Fichier | Identité source |
|---|---|
| Lulu.inibin | OLS-61c32b25-9f90-57ff-9b67-4be39fb9c48b |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Lulu.ddf | OLS-1c7b1824-6418-5671-b5c0-cee8f83a91c7 |
| LuluFaerie.inibin | OLS-291364b3-0e14-520c-8176-16250ba53146 |
| CharScriptLuluFaerie.luaobj | OLS-9eb81b7c-ee78-5189-ae3f-25cd095a5d1a |
| CharScriptLulu.luaobj | OLS-e2fc0865-23ef-5b34-998c-ea9e8f47ac84 |
| CharScriptLulu.preload | OLS-5ea35d11-945a-5f6c-8c83-fa939e6bd838 |
| LuluBasicAttack.inibin | OLS-607b306a-c447-54fa-906a-8fe39c1a6258 |
| LuluBasicAttack2.inibin | OLS-e59c3f80-c55a-51ea-8700-4142b2ba683a |
| LuluBuddyPassive.luaobj | OLS-945bce9c-369c-547d-8236-30fcf0f7aadb |
| LuluCritAttack.inibin | OLS-193cb76c-b431-50d7-9723-4725482ceb1a |
| LuluE.inibin | OLS-65f5e683-1972-5087-91c4-a71b71e5154a |
| LuluE.luaobj | OLS-390de345-ce99-5c9a-8211-a6ecf041825a |
| LuluE.preload | OLS-c91029a1-f714-59f0-b041-570c5d257255 |
| LuluEBurn.inibin | OLS-cfa02634-114d-529c-9a3d-5593614140ed |
| LuluEShield.inibin | OLS-a022d09d-7c27-518f-b034-6b1651680ae3 |
| LuluEVision.luaobj | OLS-6ac0448e-c640-5523-8515-8f16e654571a |
| LuluFaerieAttackAid.luaobj | OLS-e40e25c2-9798-5a9f-b81e-6d7c9e9c2fc4 |
| LuluFaerieAttackAid.preload | OLS-5dd3de8c-e4bf-57d6-ad18-538f1f320d91 |
| LuluFaerieAttackAidLinger.luaobj | OLS-e14c6f28-f958-594f-b993-17f8aeff6966 |
| LuluFaerieBurn.luaobj | OLS-63ce7735-1c0c-5feb-9be6-7431c37d4382 |
| LuluFaerieBurnController.luaobj | OLS-23047752-7ae0-587b-a3e4-cfa265751da8 |
| LuluFaerieMultishot.luaobj | OLS-224b3e93-40d1-5323-906f-f642fe344b3d |
| LuluFaerieOverride.luaobj | OLS-f037fe7e-c195-589b-bce1-20b01731da92 |
| LuluFaerieOverride.preload | OLS-984c6e67-c6ae-5604-ad45-13df44337859 |
| LuluFaerieOverrideTemp.luaobj | OLS-4e6ae801-6f42-5c1c-9155-2e2fac887416 |
| LuluFaerieRoot.luaobj | OLS-e010ccfa-fec3-5ab7-ab44-9d7ceb0d4344 |
| LuluFaerieShield.luaobj | OLS-3a5f38d9-3c55-5a88-8826-9b2c04fb7add |
| LuluFaerieShield.preload | OLS-ce053e0c-7a5e-5094-bfdc-0321bba58245 |
| LuluFaerieShieldController.luaobj | OLS-d026e0bc-8afc-5479-a5b7-41c2acc532b3 |
| LuluFaerieSpawn.luaobj | OLS-70b3bded-8a42-5cad-ac3a-36dd79702797 |
| LuluFaerieSpawn.preload | OLS-feaa6b08-2196-5e9d-a443-2097db4b49fd |
| LuluFaerieSpawnBackup.luaobj | OLS-59565ca3-9e2d-52c8-96e0-195bb7ee5b77 |
| LuluFaerieSpawnBackup.preload | OLS-39784f27-4e51-5c89-8798-e4b1eee295c2 |
| LuluPassive.inibin | OLS-a6b9057d-f979-5c21-a349-36abec70ffa5 |
| LuluPassive.luaobj | OLS-d560c7e1-ad6c-5728-98d1-e68408572197 |
| LuluPassive.preload | OLS-d9fe64ba-ce7c-5a54-89b8-97046536e9df |
| LuluPassiveMissile.inibin | OLS-2cac3b1f-7930-5833-84f5-02538820ab60 |
| LuluPassiveMissile.luaobj | OLS-4508742f-3449-5bfd-a2cc-f5e7c9e7d49b |
| LuluPassiveMissile.preload | OLS-954e91d1-f1ce-5825-87d5-689387b1e9b6 |
| LuluPassiveMissileController.inibin | OLS-732c7302-d9ee-5a77-84d7-4f183b3dbf4d |
| LuluPassiveMissileController.luaobj | OLS-bb9c108e-a052-5595-9e56-53fb9851a851 |
| LuluPassiveOff.luaobj | OLS-b5bab1b7-1654-5be2-99f4-119644e5616a |
| LuluPassiveRun.luaobj | OLS-4122d321-c186-54fc-96da-ee44a1e0e543 |
| LuluQ.inibin | OLS-0022523e-7493-57ff-a727-703ecd648c2a |
| LuluQ.luaobj | OLS-caf82b8e-fad5-542b-9ce6-def62f3308c4 |
| LuluQMissile.inibin | OLS-432bbeb2-806f-5e36-a9a6-34870a9970b6 |
| LuluQMissile.luaobj | OLS-d1feb93f-86ca-5d09-97da-d3c2283a4418 |
| LuluQMissile.preload | OLS-320bcf06-8506-54e1-bddb-598c9b542c18 |
| LuluQMissileTwo.inibin | OLS-6cd88cd8-5226-5ad2-a958-9a04eb17d964 |
| LuluQMissileTwo.luaobj | OLS-d2bc3752-bbd4-524d-8d95-8c5ca7a13542 |
| LuluQMissileTwo.preload | OLS-5cd3c63e-77ed-572d-92bd-69549d2282f7 |
| LuluR.inibin | OLS-1ea52f99-4b3f-5e0c-b9ea-99800a443f27 |
| LuluR.luaobj | OLS-2bc54bc4-5e07-53f7-ac58-16dd4bec9e64 |
| LuluRobotBuddyPassive.luaobj | OLS-f93e7044-2927-533c-9939-a14cd58a401f |
| LuluRobotBuddyPassive.preload | OLS-b3227301-f103-5d55-9a4f-4180c40b2c00 |
| LuluRobotBuddyTracker.luaobj | OLS-61351e25-e55c-595e-b63d-4a8a4b0783f6 |
| LuluRobotBuddyTracker.preload | OLS-ecf58aa2-2e4e-5c46-aab4-bac56cc2d3c6 |
| LuluW.inibin | OLS-028cda02-0a2f-53c6-9d15-90d37246d925 |
| LuluW.luaobj | OLS-6be505de-4bed-5043-87c4-ac9304eb6aba |

- `Lulu.inibin` lie `LuluPassive`, `Lulu_PixFaerieCompanion.dds` et la description passive, ligne **4226**. Les six champs de niveau passif sont absents et restent absents.
- Le buff passif, ligne **2232**, décrit **trois projectiles magiques guidés**, interceptables par d'autres unités. Le total contient **`@f1@` et `@f2@`, non résolus** par ce lot.
- `LuluEShield`, ligne **2231**, décrit Pix suivant l'unité protégée et aidant ses attaques au lieu de celles de Lulu. `LuluEBurn`, ligne **2230**, décrit Pix révélant l'unité suivie à ses alliés. Le buff R, ligne **2234**, est un contexte distinct de vie augmentée et ralentissement. **Quatre liaisons de buffs, toutes résolues.**
- **29 Lua** parcourus structurellement, tous entièrement consommés, sans prototype enfant. **25 initialisations littérales**, dont les deux CharScript vides ; **quatre limites NEWTABLE** : FaerieBurn au pc4, FaerieShield au pc16, QMissile et QMissileTwo au pc12. Ce sont des limites du lecteur, sans preuve de corruption ni d'exécution de callbacks serveur.
- **13 preloads** relient les états Passive/Run/Off, Spawn/Backup, Buddy/RobotBuddy, Override/Temp, AttackAid/Linger, Burn/Shield et leurs contrôleurs, le E et les deux missiles Q. Ils identifient des dépendances ; leur présence ne prouve ni création effective de Pix ni effet joué.
- `LuluFaerie.inibin` et son CharScript sont présents. Sa description héritée désigne **Caitlyn**, son `BaseDamage` vaut **24**, sa portée d'attaque est la chaîne `0` et sa hauteur de sélection la chaîne `0`. Ces métadonnées ne sont pas transformées en formule de dégât des projectiles de Pix.
- Missile passif : vitesse **900**, portée **25000**, coefficient voisin de **1,2** ; contrôleur : vitesse **1000**, portée **350**, même coefficient. Les champs restent attachés à leurs ressources respectives. **Aucune formule de salve n'est déduite du seul coefficient.** Coût et recharge explicitement nuls des deux ressources ne prouvent pas le séquencement complet du passif.
- Le contrôleur passif garde une description et un tooltip **EzrealMysticShot**. Les deux missiles Q gardent la description **EzrealEssenceFlux** et le tooltip **EnchantedCrystalArrow**. Leurs valeurs de portée **950/1000** restent distinctes. Les clés exactes ont été recherchées dans le catalogue sans réécriture d'alias.
- Les icônes et noms anciens sont conservés : **FallenAngel_DarkBinding / LuluShred**, **OriannaCommandRedact / LuluShield**, **3114_Malady / NautilusPassive**, **Sunfire Cape Self**, **Rune Prison**. Un nom d'icône, un popup Snared, une priorité de pré-dégât ou un booléen de persistance ne prouve ni contrôle appliqué, ni durée, ni règle au décès. `IsDeathRecapSource` du missile ne démontre pas une attribution Pix actuelle.
- **Quatre lignes DDF**, toutes sous LuluQ, dont `f1 → spelldamage × 0.133` ; les trois autres liens/coefficients sont vides. Cette entrée n'est pas adoptée comme formule complète du passif, ni utilisée pour résoudre automatiquement les deux variables du buff.
- **21 références communautaires** présentes, hachées et distinguées des sources natives. Le CharScript communautaire de Lulu est vide ; il ne fournit pas le comportement original de Pix.

Six chemins candidats sont absents : CharScriptLulu à la racine du personnage, Passive INIBIN dans un répertoire de sorts du personnage, INIBIN de PassiveRun/Off/FaerieSpawn dans les sorts globaux et preload du CharScript de LuluFaerie. Les chemins effectivement présents sont identifiés. Cette liste ne constitue pas un recensement global d'assets manquants.

## Exécution actuelle et limites

Compilation privée `cargo build --locked --offline` contre le vrai core non-test, avec paquets et checksums alignés sur le lock racine. **1 158 entrées** de code/ressources et chaîne de preuves précédentes vérifiées sans changement.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-lulu-passive-pix-probe.exe` ; **6039040 octets**, SHA-256 `27280e4fc7f54185a056dc7a2c5ad0ef7f99ea71df96c0d1ce3eefb7f6e00dff`.

Deux parties Map10 neuves, Lulu contre Annie : cas de base puis achat public de l'ouvrage 1052, **+20 puissance**. Déplacements publics vers la zone centrale, trois attaques puis Stop et 180 ticks d'attente par cas. Aucune injection de position, temps, rang, charge ou familier.

| Cas | AD | Puissance | Impacts physiques | Projectiles Lulu | Refus | Attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 46.36800 | 0.0 | 3 | 3 | 27 | 180 |
| Tome_AP_control | 46.36800 | 20.0 | 3 | 3 | 27 | 180 |

**Attendu pour le contrôle ordinaire :** projectile d'attaque Lulu→Annie et dégâts physiques selon AD/armure, corrigés de la régénération. **Observé :** six impacts avec témoins de projectile, aucun critique, écart inférieur à 0,002 ; AD **46,3680000305** inchangé après l'achat. Trois identités de projectile du propriétaire relevées par cas. Aucun dommage supplémentaire n'a été observé entre ces impacts ni dans les 360 ticks suivant Stop.

**Attendu selon le texte natif :** Pix accompagne les attaques de son porteur par trois projectiles magiques pouvant être interceptés. **Observé dans ces deux cas :** le chemin d'attaque ordinaire est exercé, mais aucune contribution magique de Pix n'est constatée. L'absence de sort accepté ne justifie pas cette lacune sur les attaques propres de Lulu ; elle empêche séparément de vérifier le transfert par E.

**54 refus atomiques :** joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt QWER avant les attaques puis après l'attente. Chaque refus conserve le snapshot. Le dispatch de progression refuse les champions non pris en charge et le dispatch de sorts renvoie l'absence d'implémentation pour Lulu.

Les participants restent vivants au niveau 1, sans stun/ralentissement, décès ou fin de partie. Mana de Lulu au plafond **292,3999938965** ; rangs et recharges nuls. L'attente de 180 ticks est une observation locale après Stop, **pas une durée native attribuée au passif**.

La collecte ne qualifie ni collision des trois bolts, ni porteur allié/ennemi, critique/procs, sbires/monstres/structures, serveur historique, transport réseau, rendu, animation, HUD ou audio.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD,AP and target resistance |
| crates/core/src/progression.rs:150 | unsupported Lulu learning |
| crates/core/src/progression.rs:159 | unsupported Lulu rank policy |
| crates/core/src/spells.rs:101 | unsupported Lulu cast |
| crates/core/src/annie_w.rs:29 | unsupported Lulu ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary ranged launch and impact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public Tome20AP control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not Pix bolt spacing |
| crates/core/src/critical.rs:12 | ordinary critical profile;Pix critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not Pix passive recap source |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted Pix attribution |

Attaque/projectile, `basic_attack_hit`, dégâts et mitigation expliquent les impacts physiques ordinaires. Statistiques/boutique expliquent +20 puissance. Progression et sorts expliquent les refus. Régénération explique les variations de vie pendant l'attente. Profils critiques et capture/commit du récapitulatif restent des points de contexte, sans qualification de Pix. Les 22 points sont explicitement marqués comme frontières actuelles ; aucun n'est présenté comme implémentation complète du passif.

Sept ressources locales sont liées séparément : catalogue des champions, croissance, ressources, profils d'attaque, profils critiques, collision et boutique. Elles ne remplacent pas les règles du serveur original.

## Travail restant

1. Qualifier la création, le suivi, les déplacements et le cycle de vie du familier ; distinguer propriétaire, porteur et source de dégâts.
2. Résoudre les deux variables du tooltip, la progression, le coefficient de puissance et le partage des dégâts entre trois projectiles.
3. Qualifier l'événement déclencheur sur une attaque acceptée, annulée, lancée ou à l'impact ; définir les attaques simultanées et la cadence de Pix.
4. Implémenter et vérifier trois projectiles avec délai, origine, direction, vitesse, guidage et fin de vie selon leurs contrats natifs précis.
5. Qualifier l'interception par les différentes unités, ordre de collision, rayons, portée, disparition de cible et changement de porteur en cours de salve.
6. Relier le E allié à l'assistance au porteur et le E ennemi à la révélation ; qualifier durée, renouvellement, retour et états Override/AttackAid/Linger/PassiveOff.
7. Vérifier l'origine de chacun des missiles Q lorsque Pix est sur Lulu ou transféré ; conserver les différences de ressources sans adopter leurs textes hérités.
8. Qualifier dégâts magiques, résistance/pénétration, boucliers, invulnérabilité, procs, critiques, objets et absence de récursion.
9. Qualifier kill/assist, récapitulatif, visibilité et attribution Lulu/porteur ; les booléens natifs seuls ne suffisent pas.
10. Vérifier mort/réapparition, contrôle, déconnexion, retour à Lulu et fin de partie, puis modèle/animation/attachement, icônes, VFX, audio et réseau séparément.
11. Étendre le lecteur pour les quatre blocs NEWTABLE si nécessaire, en conservant les métadonnées originales et les limites présentes.

Les trois questions propres et quatre dépendances restent ouvertes/préservées. Les lacunes Battle Training et le défaut de déplacement V564 restent dans leurs preuves antérieures ; ce lot ne les résout pas.

## Livraison et vérifications

BUILD/RUN, inspection, PREPARE/CHECK/PUBLISH/AUDIT et revue globale : codes réels 0. **72 associations invalides et quatre graphes invalides refusés.** Trois fragments génériques de consignes changés, 42 212 inchangés ; notice SYS actualisée séparément.

Dans chacune des deux bases locales : quatre destinataires actualisés, **42 603 autres lignes, 42 607 états manuels et 23 historiques conservés** ; synchronisation normale idempotente. Identités, hiérarchie et registre des inconnues conservés octet pour octet. Aucun statut, critère, prérequis ou case coché automatiquement.

Graphe : **99 061 sources, 3 913 consommateurs, 42 215 exigences actives, 26 189 inconnues ouvertes et 5 517 résolues antérieurement**. Relecture : **3 913 ancres exactes, aucune divergence courante**. Le contrôle structurel du graphe ne constitue pas un nouveau hachage exhaustif de toutes les sources ; les contenus sélectionnés et les fichiers des consommateurs sont contrôlés séparément.

Fichiers modifiés : registres `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json` ; reçu `docs/reference_requirement_trace_sources/lulu-passive-pix-links-v596.json` ; preuve `docs/fidelity_lulu_passive_pix_links_v596.json` ; ce rapport ; couverture/plan/reprise, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, consignes ciblées des deux bases et note privée. Aucun gameplay ou asset modifié.

Preuves : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision596_Lulu_discovery`, `revision596_Lulu_passive_probe`, `revision596_Lulu_inspection_qualified`, `revision596_Lulu` et `revision597_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision597_trace_review/REVIEW.json. Lulu V596 intégré et audité : 60 sources,180 associations,22 points,44 liens. Deux cas publics base/Tome20AP :6 impacts physiques de6 projectiles Lulu,54 refus,360 ticks sans dommage supplémentaire. Attaques déclenchantes acceptées mais aucun dégât magique Pix observé ; salve/interception non qualifiées. E refusé,transfert non exercé. Texte3projectiles guidés/interceptables et porteur allié/révélation ennemi lié ; @f1@/@f2@ non résolus.29Lua dont4limites NEWTABLE,13preloads,4buffs résolus,4DDFQ dont0.133 et21références communautaires. Anciens noms/icônes et aliases Ezreal/Ashe/Caitlyn conservés ;coefficient1.2 et familierBaseDamage24 non adoptés comme formule. Six chemins candidats absents. BUILD/RUN/inspection/prepare/check/publish/audit0,72+4refus. Conserver les preuves et le défaut V564. Prochain passif à inspecter réellement : Lux. Goal actif ;aucun statut/case/inconnue fermé.
