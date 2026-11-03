# SYS-01.2-02 — Fiora / Duelist, V662

Date UTC 2026-10-27T05:41:39.058360+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V662 Fiora / Duelist : 21 sources natives, 63 associations, 21 points actuels et 42 liens de frontière. Texte4.20 : dégâts physiques, régénération6secondes et quatre cumuls contre champions ; f1soin non résolu. 24attaques publiques,24fenêtres181ticks sans soin supplémentaire observé ; contrôles Annie et API distincts. 60 refus publics et 40 refus API sans mutation, 12768 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

CH-Fiora-PASSIF-SOURCE,CH-Fiora-PASSIF-SIMULATION-CONTRAT et CH-Fiora-PASSIF-SIMULATION reçoivent sources,preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse.21ressources donnent63associations ;21fonctions donnent42liens sur les deux fiches de simulation. Tous restent entry_boundary_only,provides_feature_consumer=false et gameplay_accepted=false. Trois questions et quatre dépendances préservées ;prérequis consignés sans acceptation implicite. Inconnues,identifiants et hiérarchie inchangés octet par octet ;statuts,critères et états manuels conservés.

## Sources et instructions

64ressources natives,26références communautaires,4exclusions. Tailles,SHA et appartenance RADS vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague,projet courant F:/OpenLeague.28Lua entièrement lus,sans fonctions enfants ;six limites NEWTABLE conservées.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Fiora\Fiora.inibin | 2592 | a762b0b53b83bcecef9612f80164d5738d1a240c1832912bd21553cc5fe58ac9 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Fiora\Scripts\CharScriptFiora.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Fiora\Scripts\CharScriptFiora.preload | 347 | 33be293f69b03b126c0b80875107958501f57af46d2b0177be39dbfff393c8f4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Fiora\Fiora.ddf | 360 | c3612ccee030b020fc53cf66d60640e84841df839642082d1ebe171ee58446dc |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelist.inibin | 44 | a712785643da358bb7a00442a2e4f3ed027827439b9a6ff3826de8f7f9303491 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelist.luaobj | 210 | 440d643b9e9b6839ea8874b69a672ea6a972f444123fdc6320dfdcc579e956b5 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelist.preload | 288 | 8b864e5615d42c026b4dfe46dfac084618ecf6f42310c795e735a12614f2dfa4 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHot.inibin | 47 | d612d2ae0e82bb0a59ac41bbb531e9fe0e97b9c238d02575207e0638388bda2a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHot.luaobj | 489 | 4c9fb5f9f0865cdd8d9006b9b6e5dec535a8e5019d336101dcc66356783dd368 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHotParticle.luaobj | 489 | 4c9fb5f9f0865cdd8d9006b9b6e5dec535a8e5019d336101dcc66356783dd368 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHotParticle.preload | 99 | e592d8ca854abf9f6ec0ecb1b3915d117f3468bc3542cedd3b09c4add1ede14a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHotParticle2.luaobj | 489 | 4c9fb5f9f0865cdd8d9006b9b6e5dec535a8e5019d336101dcc66356783dd368 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraDuelistHotParticle2.preload | 100 | 800205f479dee5dee3cf5d9979c2c3ff88d665bc2a11f93200ceee5716d47d01 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraRun.luaobj | 90 | 0b936e4b235f178501c4b0a41735e6e80944f715b24b4a523e28570f8020d45a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraBasicAttack.inibin | 1542 | 217eaf7938aa0bda2cd1698e37f466a648360606317d08a822ac94b6655240a6 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraBasicAttack.luaobj | 122 | 05784c2f9e06c459294136699eca1ad78f97bf0a15b9b300e16e3d54e9fd7fe7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraBasicAttack2.inibin | 1534 | ea32c0b058e72495db6026864d94c8858708c43b461c634d918f2a781ccfa6f1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraBasicAttack2.luaobj | 122 | 05784c2f9e06c459294136699eca1ad78f97bf0a15b9b300e16e3d54e9fd7fe7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraCritAttack.inibin | 969 | ea031d726956423eb2b101b06fc7287b1c20aa3e4095f7ab277db5b79864e338 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\FioraCritAttack.luaobj | 122 | 05784c2f9e06c459294136699eca1ad78f97bf0a15b9b300e16e3d54e9fd7fe7 |

OBJECTIF SYS-01.2-02 : relier les exigences Fiora PASSIF aux sources natives4.20 et aux fonctions courantes. Ne pas déclarer Duelist implémenté sur la seule existence de régénération et de soin génériques.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct.64ressources natives,26références communautaires,4exclusions ;21sources sélectionnées donnent63associations ;21fonctions courantes donnent42liens. Trois questions propres et quatre dépendances sont préservées.

Alias natif FioraDuelist,icôneFiora_Duelist.dds. L’infobulle BuffData dit que Fiora régénère @f1@PV sur6secondes chaque fois qu’elle inflige des dégâts physiques,avec4cumuls maximum en frappant des champions. La description du personnage dit dégâts sans préciser physiques :conserver cette différence,ne pas inventer une qualification magique/vraie. Aucun producteur natif de f1 n’est établi. Le DDF8lignes contient seulement Q;f1 bonusattackdamage×0,6 et Dance;f1 bonusattackdamage×1,2 ;ce ne sont pas les valeurs de soin. Champs Passive1/Desc/Level1..6 absents,non remplacés par zéro. Aucun passif moderne de points vitaux substitué.

28Lua lus entièrement,sans fonctions enfants,six limites NEWTABLE préservées,notamment les trois variantes d’attaque sélectionnées. CharScriptFiora natif est vide. Duelist déclare BuffName/Icon,PersistsThroughDeath et NonDispellable. DuelistHot et HotParticle1/2 déclarent le même BuffName FioraDuelistHot,la persistance/non-dissipation et des effets d’activation vides ;ces métadonnées ne prouvent ni soin ni conservation des cumuls à la mort. Duelist.preload référence Hot/HotParticle1/2/Run. Les deux preloads de particules nomment fiora_heal_buf.troy et fiora_heal2_buf.troy :ils ne démontrent pas le rendu. Run ne contient que PersistsThroughDeath. Les quatre liens de nom/description/BuffData sélectionnés sont retrouvés dans le fontconfig exact.

Recherche bornée :aucun Fiora/Duelist dans crates/core/src ;aucun FioraDuelist/DuelistHot dans LeagueSandbox-Scripts. Le CharScript C# est vide. Les scripts communautaires Q/W/E/R et statistiques restent références distinctes,non exécutées et sans autorité de serveur original. L’absence constatée est limitée aux périmètres inspectés.

Diagnostic :Fiora1/18 et Annie1/18,toutes contre Annie18,sur la vraie navigation/monde Map10. Six apports XP serveur préparent les niveaux ;huit trajets Move/Stop publics sans réémission. Aucun item ni vol de vie. Cinq préparations par simulation utilisent heal API pour retrouver les PV max puis des dégâts vrais de40%PVmax venant de l’ennemi. Ces20préparations créent une marge de PV pour observer le soin,sans injection directe de PV,position,horloge,statistique,unité ou inventaire. Le soin préparatoire est explicite,distinct du passif.

Par simulation :181ticks de référence sans dégâts sortants ;une attaque publique suivie de181ticks ;nouvelle préparation,puis quatre attaques publiques rapprochées,une cinquième,et181ticks. Les quatre premières prennent135ticks pour Fiora1,90pour Fiora18,156pour Annie1,126pour Annie18,donc moins de180ticks=6secondes. Total24attaques,avec témoin de windup pour Fiora et de projectile pour Annie. Tous les dégâts correspondent au calcul physique après armure/régénération. Les PV du propriétaire sont comparés à la régénération de base à chaque tick,y compris pendant les attaques ;aucun supplément de soin n’apparaît. Le propriétaire conserve un déficit de PV dans toutes les fenêtres,donc l’absence de soin observée n’est pas masquée par le plafond. Une cinquième attaque sans effet du passif ne valide pas son plafond.

Trois contrôles API serveur par simulation appliquent séparément40bruts physiques,magiques et vrais à l’ennemi,avec nouvelle préparation du propriétaire avant chaque cas. Les pertes attendues sont40×100/(100+armure),40×100/(100+RM),puis40 ;aucun soin immédiat du propriétaire n’est observé. Chacun est suivi de181ticks. Total24fenêtres :référence,attaque unique,séquence de coups,et trois types de dégâts. L’inspection indépendante reconstitue les additions float32 et compare les échantillons et PV finaux. Ces événements API ne sont pas des sorts publics Fiora et ne résolvent pas la différence entre descriptions natives.

Un contrôle distinct heal25 restaure exactement25PV par simulation ;il ne fournit pas la valeur f1. Pour dégâts et soin,NaN,infini,négatif,source/cible inconnue sont refusés,snapshots inchangés :40refus API. Learn/Cast/CastAt des quatre slots Fiora sont refusés avant/après ;joueur inconnu,attaque de soi et slot invalide sont également contrôlés.60refus publics au total,12768ticks,1158entrées moteur/ressources inchangées. Binaire non-test lié au vrai moteur et dépendances/checksums Cargo.lock alignés. Aucun serveur historique,rendu,audio ou réseau exécuté.

À compléter :producteur f1 et progression par niveau ;définition exacte des dégâts déclencheurs,propriétaire/crédit,attaques/sorts et cibles non-champions ;gain,rafraîchissement,ordre,durée par cumul ou commune,cap4 et cinquième événement ;périodicité/arrondi du soin,réduction/amplification,plafondPV ;mort/réapparition,dissipation,équipe/disparition et perte de cible. Qualifier les interactions Q/W/E/R et la présentation des effets,HUD,icônes,animations,particules/audio,réplication et sauvegarde. Conserver la différence des textes et les limites de lecture. Préserver preuves,critères,notes et états manuels. Cette traçabilité ne termine ni Fiora ni le jeu.


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

## Résultats attendus et observés

| Propriétaire | Niveau | Premier→quatrième coup (ticks) | Refus publics | Refus API | Ticks simulés |
|---|---:|---:|---:|---:|---:|
| fiora | 1 | 135 | 27 | 10 | 3182 |
| fiora | 18 | 90 | 27 | 10 | 3116 |
| annie | 1 | 156 | 3 | 10 | 3257 |
| annie | 18 | 126 | 3 | 10 | 3213 |

Attendu du texte :une récupération supplémentaire après dégâts physiques,avec durée6secondes et4cumuls contre champions,mais montant f1 inconnu. Observé :aucun supplément au-delà de la régénération ordinaire,dans24attaques et24fenêtres181ticks. Le déficit de PV reste présent ;aucun soin n’est masqué par le plafond. Les additions float32 sont recalculées indépendamment dans l’inspection. Les dégâts de24attaques et12événements API correspondent à leurs mitigations attendues. Quatre heal25 restaurent25PV,contrôles distincts de f1.20préparations serveur heal+40%PVmax perdus,six apports XP et huit trajets publics sans réémission. Aucun état injecté directement.60refus publics et40API sans mutation.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-fiora-duelist-probe.exe ;6116352octets ;SHA-256 267c7eecac4910c920a86c86a002c66ef0af46578a87ef330530505dbc78d16c. Vrai F:/OpenLeague/crates/core/src/lib.rs,profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées identiques avant/après. Aucun code de jeu ou asset modifié ;aucun rendu,audio,réseau ni serveur historique exécuté.

## Contrôles de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 30c4e846e54f00256308c9a8e112e65a916b6d63a745265156f3b6bf4a672e9b |
| RUN | 0 | 13ee982c50aacafc3218a73ad0f3f0df6fd47a4415fa855ef2bc1756938b1c65 |
| prepare | 0 | 7be01e9a3154405f83d074b0eb415c997536635bc678eada665c1c74ea8523f1 |
| check | 0 | 29e2309a8d15c8b8be0bb51c8d3f08e1e7ed9d905b6013519670dd5a152914fe |
| publish | 0 | 61679c50955f7c02d0fd07039e8e8eb4646ac59f2633f57eaa9e4910b2b1c9db |
| audit | 0 | e74dc11ba6c23d88eb9c6116b4ac04f62899d30c29941706714ff4c511817cbd |

Découverte,inspection,BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Store.task/copy_text et résolution relisent les quatre destinataires. Deux bases :42603autres lignes,42607états manuels et23historiques conservés ;intégrité et synchronisation idempotente vérifiées. Revue indépendante :5468ancres/empreintes exactes,aucun problème,pour99323sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\fiora-passive-duelist-links-v662.json. Vérification F:\OpenLeague\docs\fidelity_fiora_passive_duelist_links_v662.json. Bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision662_Fiora_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision662_Fiora_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision662_Fiora_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision662_Fiora/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision663_trace_review\REVIEW.json. Scripts et binaire conservés. Neuf copies privées archivées après contrôle de leurs SHA décompressés ;gain logique 2590813901octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision662_Fiora/snapshot-archives/VERIFIED.json ;restauration explicite par revision662_restore_validation_snapshots.py,non exécutée après archivage. Bases actives et sources enregistrées intactes.

## Limites et suite

f1soin,progression par niveau,gain/rafraîchissement/durée/cap des cumuls,autres cibles et types de dégâts restent ouverts. La cinquième attaque et les événements API sans proc ne qualifient pas les exceptions natives. Mort,dissipation,interactions Q/W/E/R,présentation et réplication exigent leurs propres preuves. Ni Fiora ni le jeu ne sont terminés.

Continuer SYS-01.2-02 depuis revision663_trace_review/REVIEW.json. V662 Fiora Duelist publié et audité :21sources natives,63associations,21points/42liens ;64candidats,26références communautaires. Quatre simulations Fiora/Annie niveaux1/18,12768ticks,60refus publics40API,1158entrées inchangées,BUILD/RUN0.24attaques publiques,quatre séquences4coups sous180ticks,puis cinquième coup ;24fenêtres181ticks sur propriétaire blessé suivent seulement la régénération ordinaire. Douze dégâts API physiques/magiques/vrais et quatre heal25 distincts.20préparations healAPI puis40%PVmax en dégâts vrais,aucune injection directe. Aucun soin Duelist observé ;f1,cumul,rafraîchissement,plafond et persistance non qualifiés. Texte BuffData dit dégâts physiques,description dit dégâts ;préserver différence.28Lua,six limites NEWTABLE,CharScript vide ;DDF8lignes Q/Dance pas soin. Les preloads heal/Hot/Run ne sont pas du rendu ni des callbacks. Prochain lot :Kalista PASSIF Martial Poise4.20,contrat encore au chargeur partagé selon revue actuelle ;inspecter mouvements,attaques et liens natifs avant diagnostic. Snapshots V662 archivés/restaurables par revision662_restore_validation_snapshots.py. Goal actif. Première découverte Kalista exécutée0 :revision663_Kalista_discovery/OBSERVATIONS.json,241ressources natives,69références communautaires,2exclusions ;114Lua entièrement lus,sans fonctions enfants,24limites NEWTABLE. Aucun basename dupliqué ni dossier Deprecated dans ce lot. Alias KalistaPassiveBuff/icôneKalista_Passive.dds,portée550 ;PassLev1Desc1 absent malgré description présente dans fontconfig :ne pas inventer le lien. DDF8lignes vides,noms KalistaE et section sans nom. Tooltip PassiveBuff :attaques non annulables,échec si perte de vision,ordre Move pendant windup attaque/Q déclenche lunge ;distance selon bottes et25%bonus vers arrière. Paramètres/règles de mouvement non qualifiés. Aucun diagnostic moteur Kalista exécuté.
