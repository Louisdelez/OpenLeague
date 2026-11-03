# Sejuani — sources et consommateurs de Frost Armor, V623

Date UTC : 2026-10-26T15:58:18.964376+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat et portée

Les trois fiches CH-Sejuani-PASSIF-SOURCE, CH-Sejuani-PASSIF-SIMULATION-CONTRAT et CH-Sejuani-PASSIF-SIMULATION reçoivent 91 sources natives, 273 associations, 30 points de code et 60 liens pour les fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ; statuts, critères, inconnues et acquis conservés.

La source décrit un bonus d’armure et une réduction des ralentissements après dégâts par attaque ou sort, pendant deux secondes, prolongés de deux secondes si le buff est déjà présent. La valeur f1 et son producteur restent à qualifier. Les attaques publiques actuelles n’ajoutent aucune armure ; le ralentissement d’Exhaust reste à sa valeur générique. Ce diagnostic documente l’écart sans inventer le bonus natif.

## Sources et contrat natifs

91 ressources sélectionnées :30 INIBIN,40 Lua,19 preloads,Sejuani.ddf et texte en_GB. Taille,SHA et appartenance au manifeste RADS vérifiées. Aucun doublon de basename ou fichier NightmareBot sélectionné.

Sejuani.inibin définit Passive1LuaName=SejuaniPassive,icône Sejuani_Passive.dds,AD57.5439987183,armure29.5400009155,MR32.0999984741,portée125 et vitesse340. PARType et Passive1 sont absents ;BaseMP287.2000122070. La classification Mana actuelle reste distincte d’un champ natif absent. Les niveaux Passive1Level1..6 sont absents. Passive1Desc décrit des critiques pour les alliés,PassLev1Desc2..4 évoquent Attack Rate10/15/20% :cet héritage n’est pas adopté comme passif.

Le BuffData SejuaniPassive résout le texte Frost Armor :dégâts par sort ou attaque,bonus f1 armure et réduction f1% des ralentissements pendant2s,prolongation2s si déjà actif. La description du personnage confirme le bonus d’armure et la réduction des ralentissements. Le nom localisé du passif est « Frost » :ce nom ne fusionne pas le buff propre avec la marque ennemie Frost utilisée par E.

16 bindings BuffData :10 résolus,6 non résolus,concernant SejuaniArcticAssault,SejuaniNewE,SejuaniPassiveDisplay,SejuaniPassiveHeal,SejuaniPassiveStacks et SejuaniShieldCheck. PassiveHeal pointe game_buff_tooltip_EliseHumanEHeal ;son Lua expose EliseHumanEHeal et EliseHumanE.dds. Ces références étrangères ne prouvent ni soin ni shield propre à Sejuani.

Les40 Lua sont entièrement parcourus,sans sous-fonction ;8 conservent une limite NEWTABLE :ArcticAssault,BasicAttackW,GlacialPrison,GlacialPrisonCast,GlacialPrisonStart,NorthernWinds,NorthernWindsEnrage,WintersClaw. Les32 initialisations littérales restantes ne constituent pas l’exécution d’un serveur historique. CharScriptSejuani.luaobj est vide. Passive,Display,MS,Stacks et ShieldCheck exposent notamment des noms,icônes et PersistsThroughDeath ;ce ne sont pas des callbacks ni une politique de mort/réapparition démontrée. PassiveStacks expose BuffName=SejuaniPassiveMS,sans preuve de compteur ou plafond de durée.

Le preload du personnage référence PassiveStacks,PassiveDisplay,Frost,FrostChaos,Passive,ThreeSisters,FrostBuffer,les taunts Ashe/Lissandra et d’autres dépendances. PassiveDisplay précharge root et des particules ;PassiveHeal précharge des particules de soin. Leur présence ne prouve pas activation,rendu,soin ou règle de gameplay.

Sejuani.ddf contient20 lignes,dont une seule liaison non vide :SejuaniNorthernWinds;f1→bonushealth×0.1. Elle concerne W ;elle n’est pas le producteur f1 du passif.

Les descriptions natives des sorts restent séparées du passif :Q charge avec dégâts dépendant des PVmax cible et arrêt après projection d’un champion ;W renforce la prochaine attaque puis tourne pendant4s avec bonusHP propre et peut être réactivé ;E applique Frost4s par capacités/attaques et ralentit tous les ennemis proches marqués ;R distingue collision avec champion et explosion à portée maximale. Les variantes NewE/WintersClaw et anciens noms restent distinctes.

Quatre chemins candidats absents sont consignés :CharScript dans Scripts,Passive dans les Spells globaux,Sejuani.en_gb.ddf et SejuaniFrostArmor.inibin. Les fichiers réellement sélectionnés sont présents. Aucune absence globale d’assets ou corruption du client n’est déduite.

| Ressource | Identité du registre |
|---|---|
| Sejuani.inibin | OLS-444143ad-0d6b-54bd-be0a-c366f5d6e12e |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Sejuani.ddf | OLS-5a2d4173-0bf9-5ec4-9d40-ec9dfb333e19 |
| CharScriptSejuani.luaobj | OLS-755596b4-9474-5909-bdfd-7b86b64b34da |
| CharScriptSejuani.preload | OLS-1f0b0707-c294-5c99-827d-90d301c8c476 |
| SejuaniArcticAssault.inibin | OLS-649e01f8-945c-5a61-8154-dab9a2aab7cc |
| SejuaniArcticAssault.luaobj | OLS-434b36e7-32b3-5684-9a44-dd6cd6b87e15 |
| SejuaniArcticAssault.preload | OLS-d213f5bf-a9c5-54c4-8acd-090ddd5e9288 |
| SejuaniArcticAssaultChampion.luaobj | OLS-c38f1571-94ae-56fb-8008-655532383526 |
| SejuaniArcticAssaultChampion.preload | OLS-f807a3da-ff86-5f5f-a1d6-bb6600391f9b |
| SejuaniArcticAssaultEnd.luaobj | OLS-429d9a9e-14de-5d80-8487-80e15ac3fc52 |
| SejuaniArcticAssaultMarker.luaobj | OLS-db2df96c-bddf-52f7-803c-4ae15d88cf64 |
| SejuaniArcticAssaultMinion.luaobj | OLS-e3912371-f141-5851-bd5b-7a13454dcf22 |
| SejuaniBasicAttack.inibin | OLS-6e5cb797-a244-572d-839b-cbc0c4cdf493 |
| SejuaniBasicAttack2.inibin | OLS-28eefc45-a807-584e-b8b9-51a78cd25bdb |
| SejuaniBasicAttack3.inibin | OLS-0e99bc51-e018-5b17-9831-d4657e87b928 |
| SejuaniBasicAttackBoar.inibin | OLS-3f3dd117-84d1-5b30-8660-635d8a9c2f0b |
| SejuaniBasicAttackW.inibin | OLS-88336b29-19f5-5e41-a433-ebd4c80fbb5c |
| SejuaniBasicAttackW.luaobj | OLS-e9d48d69-5748-5993-86f0-9d9cbb099d70 |
| SejuaniCritAttack.inibin | OLS-180ad761-8567-5b45-9c05-bc12abd645ff |
| SejuaniCritAttack2.inibin | OLS-186e6a8d-17df-5152-8aad-89c8f6a13f71 |
| SejuaniCritAttack3.inibin | OLS-fc15119a-383c-520d-82e4-ae342ecb84c2 |
| SejuaniFrost.inibin | OLS-d2813da5-bcf2-587b-ac4f-99f0b84cc354 |
| SejuaniFrost.luaobj | OLS-fd836ce0-21b2-5adc-bd58-f9e226be39cd |
| SejuaniFrost.preload | OLS-3e8a7040-e90e-5b10-b1fa-be1f49548ff4 |
| SejuaniFrostApplyParticle.luaobj | OLS-32dd2c26-0586-50aa-86e5-835b23448e4d |
| SejuaniFrostApplyParticle.preload | OLS-d6e759d4-1c91-5d52-b80e-7ff3e36f31bc |
| SejuaniFrostApplyPartMinion.luaobj | OLS-c72b9e8c-59c7-5015-8b54-d00dad0b481e |
| SejuaniFrostApplyPartMinion.preload | OLS-04420d87-0c35-5251-b88f-1e6e20d51cb8 |
| SejuaniFrostArctic.inibin | OLS-7089f26e-ba7f-5891-8837-9d1856b2e8f6 |
| SejuaniFrostBuffer.luaobj | OLS-3c545abb-2a74-5316-92ff-033fb532e695 |
| SejuaniFrostChaos.luaobj | OLS-db7aa8c1-d939-58aa-b4a4-bc0759e4b567 |
| SejuaniFrostChaos.preload | OLS-0c98c048-a3c4-5f41-890e-58bc0c6873a3 |
| SejuaniFrostInternal.luaobj | OLS-f0bf483f-4951-58d8-b966-df85b9f686ce |
| SejuaniFrostInternal.preload | OLS-a2163a3e-17ee-5ffc-9b33-b20bca451b57 |
| SejuaniFrostTracker.luaobj | OLS-ebae32f6-7fd0-51d0-a3ed-eb06331388b0 |
| SejuaniGlacialPrison.inibin | OLS-12d095b9-f18b-506e-8cff-99d4498de2b2 |
| SejuaniGlacialPrison.luaobj | OLS-3f543bda-8e61-5710-9415-e6eb22b2d1bf |
| SejuaniGlacialPrison.preload | OLS-d31dfbf8-733b-5d00-a348-21abe148f49d |
| SejuaniGlacialPrisonCast.inibin | OLS-d757286a-2c87-5e20-8d59-438a03869379 |
| SejuaniGlacialPrisonCast.luaobj | OLS-a60d325e-05ff-563e-822b-72b64fbadb3b |
| SejuaniGlacialPrisonCast.preload | OLS-01e65ee8-e6be-5992-90db-53ffc3989bcf |
| SejuaniGlacialPrisonCheck.luaobj | OLS-4bd5f0ff-fa5c-573d-b670-2232a437f4e5 |
| SejuaniGlacialPrisonDetonate.inibin | OLS-9806504f-0e4c-5061-ba3e-0738ffc5648d |
| SejuaniGlacialPrisonDetonate.luaobj | OLS-fec0c10f-df82-55b6-9da1-7c94b619a723 |
| SejuaniGlacialPrisonDetonate.preload | OLS-6b81bf0e-b17a-5d9c-9c02-59c4a5041adc |
| SejuaniGlacialPrisonSlow.inibin | OLS-994156e0-d8c5-585a-a2e1-5b24835eece7 |
| SejuaniGlacialPrisonSlow.luaobj | OLS-ce187e78-d93d-5c15-ace0-36ca8e2ca170 |
| SejuaniGlacialPrisonSlow.preload | OLS-26681f47-8b70-5547-bbba-9a9cbaf47896 |
| SejuaniGlacialPrisonStart.inibin | OLS-00d4ed83-7361-5ce7-8291-8b4042968512 |
| SejuaniGlacialPrisonStart.luaobj | OLS-ccc2dca9-648c-552f-ba50-ebb053a518a8 |
| SejuaniGlacialPrisonStart.preload | OLS-2d062950-8a7a-5bd2-a9fa-a213d802041b |
| SejuaniNewE.inibin | OLS-dfb40708-93f7-5be2-a5cf-5ea3da810c70 |
| SejuaniNewE.luaobj | OLS-6b396ccd-0aae-5150-86b4-2c1c20ec92bb |
| SejuaniNewE.preload | OLS-fa07cb4b-37ed-5a9d-b4e1-43e8513940e3 |
| SejuaniNorthernWinds.inibin | OLS-4336451d-0958-59a3-aa52-bd278b7b1df0 |
| SejuaniNorthernWinds.luaobj | OLS-a2b5309a-d16f-54bc-aa8f-7ef590baff3e |
| SejuaniNorthernWinds.preload | OLS-28e7a044-8140-540a-913f-11bae6cf360e |
| SejuaniNorthernWindsEnd.luaobj | OLS-fdc2a7ae-d38d-55f9-8eb0-a998726a5a6d |
| SejuaniNorthernWindsEnrage.inibin | OLS-435d0fec-35a2-5f32-b428-470124dd6c28 |
| SejuaniNorthernWindsEnrage.luaobj | OLS-417813f4-56bb-5993-8746-2603517faaf9 |
| SejuaniNorthernWindsEnrage.preload | OLS-45d96318-77b9-5bde-a22f-4a0864354508 |
| SejuaniNorthernWindsEnrageDamage.inibin | OLS-eebefadc-72e9-531a-b18e-2c28f05f4578 |
| SejuaniNorthernWindsEnrageDamage.luaobj | OLS-582f7171-270f-5fed-9490-c1ead50fe653 |
| SejuaniNorthernWindsRemoval.inibin | OLS-3edf9762-9d14-593b-ad6e-f7a20d0bdb8b |
| SejuaniNorthernWindsRemoval.luaobj | OLS-c0ab3d88-dd0a-5565-9379-65e0435d4b95 |
| SejuaniPassive.inibin | OLS-adae259b-fff8-5fac-94f3-53a6e58749e1 |
| SejuaniPassive.luaobj | OLS-dffa2668-7cae-516a-9b15-218ca4286167 |
| SejuaniPassiveDisplay.inibin | OLS-2af46996-fb85-504c-a36f-6b75150f72e1 |
| SejuaniPassiveDisplay.luaobj | OLS-6dec06f7-df5b-5f57-a247-113a2998c0ab |
| SejuaniPassiveDisplay.preload | OLS-66eaa038-5a65-5f18-b1d3-864bb612b5a5 |
| SejuaniPassiveHeal.inibin | OLS-370b9fa2-3b5e-51d9-9d16-10fc39b0ec67 |
| SejuaniPassiveHeal.luaobj | OLS-30f8bcf7-325f-572c-afab-e73a782c62f5 |
| SejuaniPassiveHeal.preload | OLS-4d88b492-a3c2-52f2-9e6c-a4a7e1ef9f87 |
| SejuaniPassiveMS.inibin | OLS-04e23358-9eea-5960-aa68-dde739e63636 |
| SejuaniPassiveMS.luaobj | OLS-4ae3831e-fde4-5fba-98c8-a4fcf038025a |
| SejuaniPassiveStacks.inibin | OLS-ead0a14d-3ee6-51a2-8a51-de6f8dca1ea6 |
| SejuaniPassiveStacks.luaobj | OLS-59fd601e-6592-500f-b520-bdcf1d5782a7 |
| SejuaniPermafrostMissile.inibin | OLS-d00ba7c5-51c1-531b-b38e-e1e5180c7ec5 |
| SejuaniPermafrostMissile.luaobj | OLS-8407505d-fb66-5fc2-b158-ef2291f3251e |
| SejuaniQGhost.luaobj | OLS-15c8533e-e59d-50c6-b54f-08e50e287127 |
| SejuaniRunSpeed.luaobj | OLS-23834566-c9e8-5817-bcc9-0e7178cde94e |
| SejuaniShieldCheck.inibin | OLS-8b94d5cf-0aac-540b-bb8e-05ea1f0fbf53 |
| SejuaniShieldCheck.luaobj | OLS-41766ff5-ddc8-574a-b039-87f4c4df7f78 |
| SejuaniTauntAshe.luaobj | OLS-41e27579-cf21-55be-b12f-e9cd2c21ba39 |
| SejuaniTauntLissandra.luaobj | OLS-922c65d0-88e9-5cae-841c-edc230f1e17e |
| SejuaniUnlockAnimationKnockup.luaobj | OLS-a329f13a-1b56-50b4-b81e-f423ac07e8f4 |
| SejuaniUnlockAnimationQ.luaobj | OLS-b2fcfa34-f0e5-5a83-8e49-67ab729698ba |
| SejuaniWintersClaw.inibin | OLS-30395a70-da16-5948-8093-08427b60acdd |
| SejuaniWintersClaw.luaobj | OLS-f647f838-39f6-5ca1-b8a8-852a426842d1 |
| SejuaniWintersClaw.preload | OLS-1eabb0ce-760f-55ec-b689-9c4e33cbd20d |

## Références communautaires

35 fichiers identifiés séparément de l’autorité native et du Rust. CharScriptSejuani.cs est vide. Les quatre fichiers Q/W/E/R inspectés n’emploient pas SejuaniPassive ;cela ne prouve pas l’absence de toute logique ailleurs.

- Q choisit une première cible dans un cône de650 et applique dégâts puis Airborne0,5s. Aucun déplacement réel ni terme PVmax cible n’est présent dans ce fichier ;son commentaire « dash » ne prouve pas une charge.
- W programme quatre ticks à une seconde d’intervalle,dans400 unités,avec2% des PVmax de la cible. Cela diffère de l’attaque renforcée suivie d’une zone dépendant du bonusHP propre et de la réactivation natives.
- E applique dégâts et Stun0,5+0,25×rang à une cible sans vérification de marque Frost. Cela ne correspond pas au ralentissement de tous les ennemis proches marqués décrit en4.20 ;le commentaire ne démontre pas la consommation de stacks.
- R applique directement une zone de600 au point ciblé,Stun2s au centre de200 et Slow3s ailleurs. Aucun trajet de bola ni branche collision-champion/portée-maximale n’est démontré dans ce fichier.

Aucun script communautaire exécuté ici comme serveur historique ou accepté comme consommateur Rust.

## Diagnostic actuel : attendu et observé

Le premier BUILD a échoué avec code101 :le diagnostic utilisait à tort Action::Summoner avec une cible. L’API réelle est Action::SummonerTarget. Les sources et journaux initiaux sont conservés sous revision623_Sejuani_passive_probe ;la correction isolée utilise revision623_Sejuani_passive_probe_target. Aucun fichier du moteur n’a été corrigé pour faire passer ce test.

Version corrigée :BUILD=0,RUN=0,collecte=0,inspection=0. Cœur Rust hors configuration test,offline/locked,dépendances alignées sur Cargo.lock ;1158 entrées source et preuves antérieures vérifiées. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-sejuani-passive-frost-armor-probe.exe`, 6153728 octets,SHA256 `d394459073f543ed572dcf14fc8a272fe633a9d0fd49fba0f11dbec1395ac63d`.

Trois profils publics niveau1 contre Annie :base,Cloth1029+15armure,Boots1001+25vitesse. Achat/vente/rachat vérifiés. Six trajets Move/Stop sans réémission. Aucune injection de position,vie,ressource,stats,rang,slow ou échéance. L’Exhaust provient de la commande publique de l’adversaire.

Chaque profil produit trois attaques Sejuani,Exhaust immédiatement après le troisième impact,76 échantillons couvrant ses75ticks puis expiration,trois nouvelles attaques, trois impacts physiques Annie et un Q Annie,puis181ticks d’attente. Total18attaques,9impacts physiques entrants,3Q,771ticks d’attente/observation et84refus atomiques. Les refus couvrent acteur inconnu,autoattaque de soi,slot invalide,Exhaust déjà en délai et apprentissage/lancement QWER avant/après. Les snapshots restent inchangés après refus.

| Profil | Armure hors Exhaust | Armure sous Exhaust | Vitesse hors Exhaust | Vitesse sous Exhaust | Dégâts sortants physiques | Dégâts physiques entrants |
|---|---:|---:|---:|---:|---:|---:|
| base | 29.54000 | 19.54000 | 340.0 | 238.0 | 48.26706 | 38.91461 |
| Cloth15Armor | 44.54000 | 34.54000 | 340.0 | 238.0 | 48.26706 | 34.87616 |
| Boots25MS | 29.54000 | 19.54000 | 365.0 | 255.5 | 48.26706 | 38.91461 |

Attendu pour les mécanismes génériques :Cloth ajoute15armure,Boots25vitesse,Exhaust retire10armure et applique30%slow pendant75ticks. Observé conforme,avec retour de vitesse340/340/365 à expiration. Ces données correspondent au contrat courant d’Exhaust ;elles ne qualifient pas toutes ses règles historiques.

Attendu selon le texte du passif :un effet d’armure et résistance aux ralentissements après dégâts. Observé :armure constante hors la variation générique d’Exhaust,aucun bonus après impact ;ralentissement toujours30%,vitesses238/238/255,5. Le niveau numérique natif f1 reste inconnu :aucune valeur de bonus attendue n’est inventée. L’essai ne mesure pas le déplacement sous slow ;il vérifie les vitesses calculées et les états. Les trajets publics ont eu lieu avant l’application d’Exhaust.

Les attaques ordinaires infligent48.2670593262 dans tous les profils ;les dégâts entrants sont38.9146118164 ou34.8761596680 avec Cloth. La mitigation et la régénération par tick sont contrôlées. Q Annie a un brut80 et un coût60,contrôle magique distinct du passif. Aucun sort Sejuani accepté,tous rangs/délais QWER0 ;aucun cas de déclenchement par sort propre ni mort/réapparition exercé.

La recherche exacte Sejuani/FrostArmor dans crates/core/src ne trouve aucun chemin dédié. Les points génériques sont associés sans les promouvoir en implémentation du passif. Aucun état de bouclier ou de soin n’est déduit des noms de ressources.

## Consommateurs et intégration

Neuf ressources locales :champions,croissance,ressources,attaques,critiques,collisions,boutique,mouvement et Exhaust. Les lecteurs de sources restent des lecteurs,non des consommateurs de simulation.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lib.rs:598 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/progression.rs:68 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/progression.rs:150 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/progression.rs:159 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/spells.rs:101 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/annie_w.rs:29 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lib.rs:685 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lib.rs:744 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/damage.rs:53 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/attacks.rs:157 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lifesteal.rs:4 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/regeneration.rs:32 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/regeneration.rs:10 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/shop.rs:261 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/shop.rs:215 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/world.rs:226 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/damage.rs:38 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/attacks.rs:26 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lifecycle.rs:16 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/lifecycle.rs:24 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/ally_occupancy.rs:635 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/ally_occupancy.rs:526 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/spells.rs:5 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/summoners.rs:32 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/summoners.rs:47 | current generic boundary for Sejuani armor,slow,damage and refusal diagnostic |
| crates/core/src/slows.rs:12 | generic strongest slow,unreduced by FrostArmor |
| crates/core/src/slows.rs:74 | Exhaust grants30%slow75ticks |
| crates/core/src/slows.rs:78 | generic expiry,no duration extension from passive |
| crates/core/src/summoner_exhaust.rs:55 | public enemy Exhaust;minus10armor not negative FrostArmor |

PREPARE/CHECK/PUBLISH/AUDIT :code0. Les tests négatifs refusent72 associations invalides et4 graphes invalides,notamment fausse acceptation,source manquante,binaire modifié,question étrangère et dépendance retirée. Graphe99169sources/4624consommateurs ;revue de4624ancres exactes sans divergence. La validation structurelle globale ne re-hache pas toutes les sources ;les sources sélectionnées et entrées de code sont vérifiées séparément par identité.

Deux bases SQLite :quatre destinataires mis à jour,42603 autres lignes conservées,42607 états manuels et23 historiques identiques,synchronisation Store idempotente. Trois fragments de traçabilité changés,42212 inchangés. Trois questions propres et quatre dépendances conservées. Identités,hiérarchie et inconnues inchangées octet pour octet.

Fichiers livrés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,reçu reference_requirement_trace_sources/sejuani-passive-frost-armor-links-v623.json,preuve fidelity_sejuani_passive_frost_armor_links_v623.json et ce rapport. Couverture,plan de complétion,reprise,CURRENT et HANDOFF mis à jour avec sauvegardes. Les deux bases sont mises à jour sans cocher de tâche. Scripts,journaux,diagnostic Rust et observations conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 sous revision623_sejuani et revision623_Sejuani.

## Travail restant et limites

Résoudre f1,progression,plafond et règles de cumul/prolongation ;implémenter les événements après dégâts,le bonus d’armure et la réduction de ralentissement. Qualifier ordre des modificateurs,magnitude versus durée,effets posés avant/après le buff,impacts simultanés,zone,ticks,attaques interrompues,dégâts annulés/absorbés,cibles et interactions. Vérifier mort/réapparition,reconnexion,HUD,VFX,sons,animations et réseau séparément. Aucun serveur historique ou rendu exécuté ici. Les divergences communautaires et les six bindings non résolus restent ouverts. Les preuves V564/V606 sont conservées. Ni Sejuani,ni le jeu,ni SYS-01.2-02 ne sont déclarés terminés.

Suite : Continuer SYS-01.2-02 depuis revision624_trace_review/REVIEW.json. V623 Sejuani / Frost Armor :91sources natives,273associations,30points et60liens. Texte4.20 :infliger des dégâts par sort ou attaque donne de l’armure et réduit les ralentissements pendant2s,avec prolongation2s ;valeur f1,progression et plafond non résolus. PARType absent,Mana actuel distinct ;textes critiques alliés/Attack Rate10/15/20% hérités non adoptés. 40Lua dont8limites NEWTABLE,19preloads,16BuffData dont10résolus et6nonrésolus. CharScripts vides,PassiveHeal pointe EliseHumanEHeal,Stacks expose le nom PassiveMS ;aucune politique de soin/cumul déduite. Frost est aussi le nom d’une marque ennemie pour E,distincte du buff propre. DDF20lignes,une liaison WbonusHP10%,non f1 du passif. 35références communautaires :Q cône sans dash ni ratio PV cible,W dépend des PV cible au lieu du bonusHP propre,E stun monocible sans filtre Frost au lieu du ralentissement de zone natif,R zone au point ciblé au lieu des branches de collision de bola. Trois cas publics base/Cloth15armure/Boots25MS :18attaques,9impacts physiques entrants,3Q Annie,84 refus,771ticks et six trajets. Aucun gain d’armure après impact ;Exhaust public75ticks réduit l’armure de10 et conserve30%slow,vitesses238/238/255,5. Armure hors Exhaust29,54/44,54/29,54 ;aucun sort Sejuani accepté. Premier BUILD101 dû à un mauvais variant Summoner dans le diagnostic,conservé ;version SummonerTarget corrigée BUILD/RUN/inspection0. Acquis génériques,V564/V606 et états du plan conservés ;aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Shaco. Goal actif.
