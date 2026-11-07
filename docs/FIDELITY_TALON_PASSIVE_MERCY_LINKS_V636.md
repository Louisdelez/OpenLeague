# Talon — Mercy : sources et consommateurs V636

Date UTC : 2026-10-26T20:12:17.941110+00:00. Tâche SYS-01.2-02 sur F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Build indiqué 2014-11-17 17:46:45, fuseau et date de déploiement non établis.

## Résultat et portée

Trois fiches Talon sont reliées à 63 fichiers natifs par 189 associations, et à 27 points de code par 54 liens. Le diagnostic du moteur actuel observe des attaques ordinaires sous ralentissement, étourdissement et cumul : le bonus Mercy décrit dans la source native n’est pas observé. La hausse sous Exhaust vient de sa réduction d’armure. Cette livraison précise les sources, les consommateurs et les écarts ; elle ne modifie pas le gameplay et ne termine ni Talon ni le goal.

## Sources natives

Le fontconfig en_GB contient la description du passif à la ligne 4286 et son nom Mercy à la ligne 4462 : les attaques de base infligent 10% de dégâts supplémentaires aux cibles ralenties, étourdies, immobilisées ou sous suppression. Ce texte établit le contrat annoncé, pas le code serveur historique ni l’ordre exact de ses opérations.

Le corpus sélectionné contient 21 INIBIN, 25 Lua, 15 preloads, Talon.ddf et le fontconfig. Talon.inibin porte Passive1LuaName vide, TalonMercy.dds, une ancienne description de soin Warwick, des textes de régénération mana 40/60/80% et des marqueurs 1/6/11/16 ; ces éléments restent des données distinctes. Les champs absents ne deviennent pas des zéros.

Les 25 Lua sont lus sans fonctions enfants ; trois initialisations rencontrent la limite NEWTABLE. CharScriptTalon est sous Scripts et ne déclare que Wolfman_InnerHunger.dds ; son preload cite talonmercy. TalonMercy déclare BladeRogue_CheatDeath, 22.dds et PersistsThroughDeath. Cela ne démontre ni résurrection ni multiplicateur d’attaque. BladeRogue_BrewPoison, Armsmaster et Chronokeeper présents ailleurs ne deviennent pas des règles de poison ou de champions étrangers.

Quatre BuffData sont résolus : TalonDamageAmp, TalonDisappear, TalonESlow et TalonNoxianDiplomacyBuff. TalonDamageAmp décrit l’amplification de Cutthroat, distincte de Mercy. Le DDF comporte douze lignes, quatre associations non vides : Q bonusAD 0,3 et 1,2, W bonusAD 0,6, R bonusAD 0,9. Aucun de ces coefficients ne constitue le multiplicateur du passif.

## Références communautaires et manques

Les 26 fichiers communautaires sont inspectés sans exécution C#. CharScript est vide. Q applique immédiatement 30×rang + AD total, puis six impulsions de saignement : il ne démontre pas la prochaine attaque renforcée, le ciblage champion du saignement, la révélation ou les coefficients natifs. W ne produit qu’un cône, sans aller-retour. E utilise Silence pendant une seconde et TalonAmp pendant trois secondes, sans téléportation ; le texte natif décrit une arrivée derrière la cible, un ralentissement et une amplification. R applique deux zones à 0 et 2,5 secondes avec 0,75 bonusAD, contre 0,9 dans le DDF, sans démontrer les trajectoires ni les déclenchements anticipés.

Dans le sous-arbre C# LeagueSandbox-Scripts inspecté, TalonAmp et TalonStealth n’apparaissent que dans leurs appels E/R : leurs producteurs n’y ont pas été retrouvés. Un fournisseur extérieur reste inconnu. Cela ne signifie pas que tous les assets Talon sont absents. Aucune référence communautaire n’est présentée comme le serveur original.

## Diagnostic réellement exécuté

Trois scénarios niveau 1, avec commandes publiques : Exhaust, Pyromania d’Annie, puis les deux. Talon attaque Garen avant, pendant et après l’expiration des contrôles. Les déplacements, apprentissages Annie et casts sont publics ; aucune position, XP, dommage, contrôle ou rang n’est injecté. Neuf arrivées, aucun réordre, neuf impacts Talon, dix Q Annie, deux Exhaust et deux apprentissages Q Annie. Les 84 commandes invalides ou Talon non prises en charge sont refusées sans mutation de l’instantané.

L’armure de Garen passe de 27,536 à 17,536 sous Exhaust. Les valeurs attendues sans Mercy tiennent compte de cette armure et de la régénération. Les valeurs avec bonus sont une comparaison au texte natif ; elles ne qualifient pas les arrondis du serveur historique.

| Cas | Moment | Armure | Attendu sans Mercy | Observé | Comparaison avec bonus si contrôle |
|---|---|---:|---:|---:|---:|
| slow | before_control | 27.535999 | 43.288170 | 43.288147 | 43.288170 |
| slow | during_control | 17.535999 | 46.971142 | 46.971130 | 51.668259 |
| slow | after_expiry | 27.535999 | 43.288170 | 43.288177 | 43.288170 |
| stun | before_control | 27.535999 | 43.288170 | 43.288177 | 43.288170 |
| stun | during_control | 27.535999 | 43.288170 | 43.288177 | 47.616989 |
| stun | after_expiry | 27.535999 | 43.288170 | 43.288162 | 43.288170 |
| slow_and_stun | before_control | 27.535999 | 43.288170 | 43.288177 | 43.288170 |
| slow_and_stun | during_control | 17.535999 | 46.971142 | 46.971146 | 51.668259 |
| slow_and_stun | after_expiry | 27.535999 | 43.288170 | 43.288177 | 43.288170 |

Les contrôles sont présents au tick de l’impact mesuré. Après expiration, les deux états sont absents. Les écarts au calcul ordinaire restent inférieurs à 0,002. Sous stun seul, environ 43,288 dégâts sont observés contre 47,617 avec le bonus ; sous Exhaust ou cumul, environ 46,971 contre 51,668. Aucun bonus Mercy supplémentaire n’est observé.

Le premier diagnostic privé compile avec code 0 puis échoue avec RUN 101 : son contrôle des dégâts d’Annie utilisait le mauvais ordre impact/régénération à pleine vie. Le moteur applique Annie avant régénération, l’attaque de base après. Le diagnostic corrigé vérifie cet ordre et l’interruption de Perseverance ; BUILD et RUN retournent 0. Ancien binaire, sources, journaux et reçus sont conservés. Aucun code de jeu n’a été modifié pour réussir ce contrôle.

Binaire corrigé : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-talon-passive-mercy-order-probe.exe`, 6063616 octets, SHA-256 `c012eaf9d01a6161a3ff72a1a879b4eb16a11ecbeec84cfd5cef92357ff80b9e`. Le diagnostic utilise le vrai crate core de F:/OpenLeague en profil non-test. Identités/checksums Cargo alignés ; 1158 entrées source/ressource et les preuves antérieures restent identiques.

La recherche textuelle Talon/Mercy trouve aussi OriginalRealMetadataLongerThanFifteen dans un test audio : correspondance lexicale étrangère au champion, conservée et exclue explicitement. Aucun producteur Mercy effectif n’a été trouvé dans les points inspectés.

## Vérifications de livraison

PREPARE, CHECK, PUBLISH et AUDIT doivent tous retourner 0 avant cette synthèse. Contrôles : 72 mutations d’association refusées et quatre mutations du graphe refusées ; trois liens courts de fiches actualisés. Deux bases synchronisées : quatre destinataires, 42603 autres lignes, 42607 états manuels et 23 historiques conservés ; synchronisation idempotente. Trois questions propres et quatre dépendances restent ouvertes/conservées. Registre des inconnues, index d’exigences et hiérarchie conservés à l’octet.

Graphe après livraison : 99221 sources et 4935 consommateurs ; revue des 4935 ancres exactes sans divergence. La revue globale est structurelle : elle ne revalide pas les octets de toutes les sources du graphe. Les empreintes du corpus sélectionné et des 1158 entrées runtime sont contrôlées séparément.

Fichiers actualisés : registre des tâches, sources et traces ; preuve et association Talon V636 ; coverage.json, completion_plan.json, resume_checkpoint.json ; CURRENT.md et HANDOFF.md. Les critères, statuts, propriétaires, dépendances, cases, notes et historiques antérieurs restent conservés. Aucun stage, reset ou commit.

## Preuves reproductibles

- Découverte : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision636_Talon_discovery/OBSERVATIONS.json.
- Runtime corrigé : revision636_Talon_passive_probe_order/OBSERVATIONS.json dans le même répertoire de travail ; échec initial dans revision636_Talon_passive_probe.
- Inspection : revision636_Talon_inspection/OBSERVATIONS.json.
- Livraison : revision636_Talon, reçus des commandes et copies avant modification.
- Association : docs/reference_requirement_trace_sources/talon-passive-mercy-links-v636.json.
- Preuve publique : docs/fidelity_talon_passive_mercy_links_v636.json.
- Revue : revision637_trace_review/REVIEW.json ; scripts et générateurs archivés avec la livraison.

## Travail restant et limites

1. Implémenter et qualifier le multiplicateur Mercy à partir du contrat natif, avec un producteur source explicite ; conserver les cas avant/après et les refus.
2. Qualifier immobilisation et suppression, autres niveaux et types de cible, critiques, objets, effets à l’impact, Q renforcé, amplification E et ordre des multiplicateurs/arrondis.
3. Tester les instants d’application et d’expiration au démarrage et à la résolution de l’attaque, le cumul et le retrait partiel des contrôles. Les trois cas actuels ne prouvent pas ces bornes ni une politique historique de cumul.
4. Qualifier mort, réapparition, reconnexion et déterminisme ; les métadonnées de persistance ne sont pas une politique de cycle de vie.
5. Qualifier séparément HUD, animations, textures, VFX, audio, rendu et transport réseau. Aucun de ces domaines ni le serveur original n’a été exécuté dans ce diagnostic.
6. Résoudre les limites du lecteur Lua et les producteurs communautaires absents seulement avec de nouvelles preuves ; ne pas inventer les informations manquantes.

Les limites générales V564/V606 et les autres inconnues du projet restent ouvertes. Les cinq lacunes Battle Training demeurent locales et n’empêchent pas ces associations indépendantes.

Suite : Continuer SYS-01.2-02 depuis revision637_trace_review/REVIEW.json. V636 Talon / Mercy : 63 fichiers natifs, 189 associations, 27 points de code et 54 liens. Le texte natif annonce +10% de dégâts des attaques de base contre une cible ralentie, étourdie, immobilisée ou sous suppression. Descriptions Warwick et régénération mana, marqueurs 1/6/11/16 et métadonnées BladeRogue conservés séparément. Vingt-cinq Lua sans fonctions enfants, dont trois limites NEWTABLE ; quinze preloads ; quatre BuffData traduits ; DDF douze lignes avec Q bonusAD0,3/1,2, W0,6 et R0,9. Vingt-six références communautaires partielles ou divergentes ; producteurs TalonAmp/TalonStealth non retrouvés dans le sous-arbre inspecté. Trois cas publics niveau 1 : ralentissement, étourdissement, cumul ; neuf attaques Talon avant/pendant/après, dix impacts Q Annie, deux Exhaust, neuf arrivées sans réordre et84 refus atomiques. Aucun bonus Mercy observé pendant les contrôles : dégâts ordinaires après prise en compte de la baisse d’armure Exhaust. Aucun état injecté ; sorts Talon refusés. Immobilisation, suppression et bornes d’événements non exercées. Premier RUN101 privé conservé : ordre impact Annie/régénération mal modélisé ; version corrigée BUILD/RUN/inspection0, gameplay inchangé. États, cases, inconnues et preuves conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Taric. Goal actif.

Goal actif, jeu et champion non déclarés terminés.

## Inventaire sélectionné et points de code

Les chemins complets, empreintes et appartenances RADS figurent dans les reçus JSON ; les identifiants ci-dessous permettent de les retrouver sans confondre nom de fichier et provenance.

| Fichier | Identifiant de source |
|---|---|
| Talon.inibin | OLS-0a308166-6de1-5cf4-b3e5-29ae603f8b04 |
| Talon.ddf | OLS-ca96825d-66fc-57fe-8182-7f79ba02bddc |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptTalon.luaobj | OLS-e1105c5f-bd4b-5758-855c-2ddfe9d615c2 |
| CharScriptTalon.preload | OLS-165f5904-a40d-5620-9c0c-86bd588b55a3 |
| TalonBasicAttack.inibin | OLS-5473d976-bb9f-5307-997c-bede2e1db56e |
| TalonBasicAttack2.inibin | OLS-e9171ba7-68ef-59eb-895d-f4f7e4b4b947 |
| TalonBleedDebuff.inibin | OLS-1735574c-069a-5b87-914e-d87ce547078f |
| TalonBleedDebuff.luaobj | OLS-cea61018-5a18-542d-9f65-7a26a9d44baa |
| TalonBleedDebuff.preload | OLS-2604c854-5168-5718-b71b-d65ecbfadf66 |
| TalonCritAttack.inibin | OLS-5869240d-e286-5623-8ec0-ad0e7fe8a5ae |
| TalonCutthroat.inibin | OLS-a7643759-d8c9-5d35-8e99-d58e90dd0b53 |
| TalonCutthroat.luaobj | OLS-81a73238-eb71-5ee4-84db-d66adb41d065 |
| TalonCutthroat.preload | OLS-2d15eb49-347e-514b-a195-d83508ca5997 |
| TalonDamageAmp.inibin | OLS-cdb7a58a-26ae-5bb3-9bbd-0c742c07bc10 |
| TalonDamageAmp.luaobj | OLS-5a61ec8f-24db-5c66-bdf6-86254bf9320b |
| TalonDisappear.inibin | OLS-b105c6d0-83f1-5219-8052-83d6e472f4c0 |
| TalonESlow.inibin | OLS-c7d0d646-ed9e-5922-a341-8e7a44cba84a |
| TalonESlow.luaobj | OLS-4d58d048-c93e-5e19-8058-3225f59d775e |
| TalonHaste.luaobj | OLS-ac566d71-4d2f-5791-b615-5f803a93cf88 |
| TalonHaste.preload | OLS-944fddae-0c5c-5d05-b30b-0185ca4ffa55 |
| TalonMercy.inibin | OLS-08f90faa-0e0b-5dbc-a9ae-e23e4559470b |
| TalonMercy.luaobj | OLS-b1fc70c7-2393-519e-9255-75c4d3a8a676 |
| TalonNoxianDiplomacy.inibin | OLS-254f03a1-f5c8-52a6-bf81-4e2ec396eb12 |
| TalonNoxianDiplomacy.luaobj | OLS-a5bcb239-ce85-5210-847c-58eedc445caf |
| TalonNoxianDiplomacy.preload | OLS-88f76451-4361-5bcb-84b6-9d1964c5d17d |
| TalonNoxianDiplomacyAttack.inibin | OLS-1dedc6c4-6063-5da5-8125-3c0d2d5a91fa |
| TalonNoxianDiplomacyAttack.luaobj | OLS-36a30f07-1572-5367-9501-107ba06b8b02 |
| TalonNoxianDiplomacyBuff.inibin | OLS-5153e803-7b21-51d8-af19-f678d506c927 |
| TalonNoxianDiplomacyBuff.luaobj | OLS-feb876b5-02c3-5ed1-a762-820d07b93a56 |
| TalonRake.inibin | OLS-2f00faf4-5420-5b02-82b1-8ec5549ef2e4 |
| TalonRake.luaobj | OLS-b8a465f0-15e8-5f55-8e39-bf0597500bcf |
| TalonRake.preload | OLS-f52f1344-9395-5c55-871b-410a199802f7 |
| TalonRakeMarker.luaobj | OLS-03e6da70-381b-5d31-8a34-e7a09f0e6481 |
| TalonRakeMarker.preload | OLS-019af955-2fa1-53fd-929d-88c8d2f82021 |
| TalonRakeMissileOne.inibin | OLS-14d9ed82-f6b3-5fd3-88a5-38b929962130 |
| TalonRakeMissileOne.luaobj | OLS-62be08aa-7cbc-59a9-80d6-90b510c316a0 |
| TalonRakeMissileOne.preload | OLS-6b8f0f41-6b07-5d54-8c3a-fc1864a2f05e |
| TalonRakeMissileOneMarker.luaobj | OLS-90f48e82-1617-54cd-92a6-465b4bfc6945 |
| TalonRakeMissileTwo.inibin | OLS-a36945d1-9863-5d35-ab8b-e8b400f0321d |
| TalonRakeMissileTwo.luaobj | OLS-c9c315b9-74f4-573a-8428-612f61c075d5 |
| TalonRakeMissileTwo.preload | OLS-36b24d36-5b48-53d5-a273-7e330d7a6793 |
| TalonShadowAssault.inibin | OLS-3a21708a-70d1-516a-b1d9-7794e3b6df75 |
| TalonShadowAssault.luaobj | OLS-e1944918-6943-590f-b79e-7fed755b1597 |
| TalonShadowAssault.preload | OLS-ab9c5ce1-84a2-5c89-b203-f0580a611f04 |
| TalonShadowAssaultAnimBuff.luaobj | OLS-a7634c3a-935d-5c1c-9755-ea55efbe91fa |
| TalonShadowAssaultBuff.luaobj | OLS-58a77640-ba90-5e3f-b49a-782fb438f83e |
| TalonShadowAssaultBuff.preload | OLS-2409a5f5-769a-552c-ba88-4fbcb8670b27 |
| TalonShadowAssaultMarker.luaobj | OLS-b59157dd-c4e1-528d-95d6-836d5ee27784 |
| TalonShadowAssaultMarker.preload | OLS-2c2865ba-ac2c-51fa-930b-30452fd80d9f |
| TalonShadowAssaultMisBuff.luaobj | OLS-7fadf87b-ea68-5fc7-9654-712074cbc65c |
| TalonShadowAssaultMisOne.inibin | OLS-d77c01b9-4310-51a7-847a-cbd54d63ab10 |
| TalonShadowAssaultMisOne.luaobj | OLS-bb03454b-73d3-5b71-a165-1be0dcc25c38 |
| TalonShadowAssaultMisOne.preload | OLS-25b6f938-9a03-5e13-8365-a854a679dd28 |
| TalonShadowAssaultMisOneHalf.inibin | OLS-85093d5e-240c-5fcb-8357-6600627dcfba |
| TalonShadowAssaultMisOneHalf.luaobj | OLS-a8031863-4770-58b1-a4bb-91b9752a8f30 |
| TalonShadowAssaultMisOneHalf.preload | OLS-6ff52975-9467-5ad4-b81a-e0128f5230ae |
| TalonShadowAssaultMisTwo.inibin | OLS-e301e919-cddc-562c-8171-61f513b8b602 |
| TalonShadowAssaultMisTwo.luaobj | OLS-b821fc85-b5e1-5a55-9e6d-f7624aa24b8f |
| TalonShadowAssaultMisTwo.preload | OLS-45af9221-9c3e-5297-acef-93784afb13d2 |
| TalonShadowAssaultToggle.inibin | OLS-ff144e2a-b93e-50fb-a806-86a531032372 |
| TalonShadowAssaultToggle.luaobj | OLS-cecf50a0-b21b-50e0-ac47-2b901c8b14b2 |
| TalonSlow.luaobj | OLS-0918c231-c5a1-5565-b80b-6d15d3e7c3fa |

| Point de code actuel | Rôle borné |
|---|---|
| crates/core/src/lib.rs:533 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/summoners.rs:32 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/lib.rs:598 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/progression.rs:68 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/progression.rs:150 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/progression.rs:159 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/spells.rs:101 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/annie_w.rs:29 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/lib.rs:685 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/lib.rs:744 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/damage.rs:53 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/attacks.rs:157 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/lifesteal.rs:4 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/regeneration.rs:32 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/regeneration.rs:10 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/damage.rs:38 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/attacks.rs:26 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/slows.rs:12 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/stuns.rs:6 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/summoner_exhaust.rs:55 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/summoner_exhaust.rs:23 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/summoners.rs:47 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/annie.rs:45 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/annie.rs:73 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/annie_passive.rs:9 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/annie_passive.rs:20 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
| crates/core/src/garen_passive.rs:27 | current Talon attack/refusal or public control producer;generic boundary,not Mercy implementation |
