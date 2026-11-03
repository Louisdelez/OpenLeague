# Quinn — sources et consommateurs de Harrier, V616

Date UTC : 2026-10-26T13:41:43.509908+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis.

## Résultat et portée

Les fiches CH-Quinn-PASSIF-SOURCE, CH-Quinn-PASSIF-SIMULATION-CONTRAT et CH-Quinn-PASSIF-SIMULATION reçoivent 101 sources natives,303 associations,24 points de code et48 liens pour les deux fiches de simulation. Elles restent ouvertes. Aucun gameplay modifié ; sources, consommateurs actuels et qualification historique demeurent distincts.

Le producteur de marquage Harrier n'est pas identifié dans le chemin courant inspecté. Les douze impacts du diagnostic final infligent seulement les dégâts physiques génériques, après des attentes de901 ticks avant chaque série. Cela ne qualifie pas la période native, la sélection de cible ou l'attaque sur une cible effectivement marquée.

## Sources natives

101 ressources :32 INIBIN,44 Lua,22 preloads,deux DDF et un fichier de texte. Appartenance au manifeste sélectionné vérifiée. Les44 Lua sont parcourus entièrement,sans sous-fonction ;14 limites NEWTABLE restent explicites. Les30 initialisations littérales ne sont pas une exécution du serveur historique.

Quinn.inibin lie QuinnPassive et Quinn_Passive.dds. Passive1Desc vaut « Attack Speed » ; Passive1 et Passive1Level1..6 sont absents. Ces champs ne définissent pas le passif complet. Portée525,IsMelee=No,AD51,0400009155,PV532,79998779,MS335.

**QuinnValor.inibin est présent**, vérifié dans la release sélectionnée et ajouté après la découverte initiale. Il lie le même passif et la même icône,avec description vide,portée125,IsMelee=Yes et les mêmes valeurs AD/PV/MS. Ses sorts sont QuinnValorQ,QuinnW,QuinnValorE et QuinnRFinale. Cette configuration ne prouve pas la transformation dans notre moteur.

Le texte en_GB ligne2493 décrit un marquage périodique Vulnerable,durée f3,puis des dégâts physiques supplémentaires f2+(f1) sur la première attaque de base. La ligne4257 confirme la description générale. **f1/f2/f3,progression,coefficient AD,période,propriété et sélection de cible restent non qualifiés.** QuinnPassive SpellData contient Cooldown1=28,Effect1=3,Effect2=35,Effect3=4,Effect4=3,Coefficient=0,CastRange=400,ManaCost=0. Aucune correspondance automatique entre ces champs et les variables du texte n'est adoptée.

Le E natif marque immédiatement en forme Quinn et distingue la forme Valor,qui ne marque pas et ne rebondit pas. W décrit vitesse d'attaque/déplacement après attaque d'une cible Vulnerable,vitesse d'attaque de Valor et vision active sans révélation des unités furtives. Q décrit un premier impact puis zone/aveuglement,avec CharBonusPhysical et CharAbilityPower2. R décrit Tag Team,Valor mêlée mobile,puis Skystrike dépendant des PV manquants. Ces interactions ne sont pas qualifiées par le seul inventaire.

Quinn.ddf contient60 lignes :40 clés Khazix et20 Quinn. Quinn.en_us.ddf en contient28,toutes sans liaison/coefficient. Sur88 lignes,la seule liaison non vide est **KhazixW;f1,bonusattackdamage,0.6**. Les deux fichiers correspondent indépendamment au manifeste sélectionné lol_game_client0.0.1.7. Le membre en_us provient de0.0.0.150,1124 octets,SHA256 b268aecf919fddcbc90d24c09b198db7a2426663f0ea96052f86b1f73bd375f3. Pas de corruption déduite de ces noms mixtes,pas de formule Harrier déduite de KhazixW ; priorité locale effective en_GB ouverte.

Onze liens BuffData :huit résolus,trois non résolus (QuinnR sur deux ressources,QuinnWPassive). QuinnValorQ renvoie à VolibearE :la résolution textuelle est conservée sans acceptation sémantique. Pas de doublon de basename ni de variante NightmareBot sélectionnée.

CharScriptQuinn et QuinnHunted sont vides. Le Lua QuinnPassive expose notamment nom,icône,PersistsThroughDeath=true,CastingBreaksStealth=true,IsDamagingSpell=true ; aucun callback de marquage,respawn ou gestion des boucliers n'est qualifié. Aucun champ NonDispellable n'est présent. Les preloads citent passif,incombat,missileinflight,WPassive,Ammo et particules respawn/R ; ce sont des dépendances,pas une preuve de producteur ou de rendu.

Sur cinq chemins candidats,quatre sont absents :CharScript dans Scripts,QuinnPassive.inibin global,QuinnPassive.ddf global et Quinn.en_gb.ddf. Le cinquième,QuinnValor.inibin,est présent et inspecté. Aucune absence globale d'assets n'est conclue.

| Ressource | Identité du registre |
|---|---|
| Quinn.inibin | OLS-9ae1e3d5-808e-5e8d-a74e-d48bb65387ac |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Quinn.ddf | OLS-145c53f3-59d0-5f7c-b21d-aa44eecbfa27 |
| Quinn.en_us.ddf | OLS-94ce38ee-5530-5b3a-bdfe-870b105507cb |
| QuinnValor.inibin | OLS-e2ecb3fe-5a4e-568f-9f4c-ad624340da0d |
| CharScriptQuinn.luaobj | OLS-be5789c3-3586-5a7a-9697-b1557b534fac |
| CharScriptQuinn.preload | OLS-9b57c18f-0739-57aa-b372-a0bad5b69172 |
| QuinnBasicAttack.inibin | OLS-0d4b958c-ea6a-5961-af02-53a36ade8889 |
| QuinnBasicAttack2.inibin | OLS-0db2e265-d73d-5c5e-a655-4a4512a9ddd9 |
| QuinnBasicAttack3.inibin | OLS-e2dcfe6a-0984-58a7-9108-3d97c1bc4682 |
| QuinnBasicAttack4.inibin | OLS-536ea514-f2a7-5a3b-bd1a-65599c302365 |
| QuinnCritAttack.inibin | OLS-169f2dcd-9c35-5724-af3c-c9fe5cb1d275 |
| QuinnE.inibin | OLS-d466c256-d679-5570-bca3-52c0cdf36209 |
| QuinnE.luaobj | OLS-9192ad7f-80a0-579c-8507-c2cbcca66017 |
| QuinnE.preload | OLS-6ef4c300-313a-58f4-87aa-1b41c8dcbd5c |
| QuinnEBump.luaobj | OLS-397261bd-bd43-5a64-9cc5-ac918fad3088 |
| QuinnEDoubleQuinnDebug.luaobj | OLS-494110f1-6180-5754-a76f-d8c112319ab7 |
| QuinnERoot.inibin | OLS-18cf124f-3e7b-5619-a2e8-ca18e76b198e |
| QuinnERoot.luaobj | OLS-34ceb202-520c-5873-9621-8dc4b1b8a3a6 |
| QuinnERoot.preload | OLS-480a7ebf-f15d-5ccc-8f3d-a88ada8c54f1 |
| QuinnESecond.inibin | OLS-8823f694-c304-5c99-838d-5e66bb2efa84 |
| QuinnESecond.luaobj | OLS-0677b717-7b44-532a-add2-ecae7ff930d1 |
| QuinnETarget.luaobj | OLS-1bd41c6b-6fdd-58b6-9798-f660047e8333 |
| QuinnHunted.luaobj | OLS-32b1f5f1-4d74-5df0-af3e-b19440c61310 |
| QuinnMissileInFlight.luaobj | OLS-88de6f25-105f-5879-b2be-dde2bfdab557 |
| QuinnPassive.inibin | OLS-0bb8f860-f2e3-54a7-90ea-8e8324814d68 |
| QuinnPassive.luaobj | OLS-c1cbf31e-efb1-52ac-adc4-664dad7f512b |
| QuinnPassive.preload | OLS-3f7ed827-0ef5-504f-997e-84dd24052d63 |
| QuinnPassiveAmmo.inibin | OLS-e97b22ba-f2a2-5947-a017-c899b20d1413 |
| QuinnPassiveAmmo.luaobj | OLS-d03017c0-e368-5475-86aa-fd4421bc4af6 |
| QuinnPassiveInCombat.luaobj | OLS-0033c554-e5a8-59b0-b2dc-12ddec8f5dd1 |
| QuinnPassiveVFX.luaobj | OLS-ea3ad689-20a7-5475-9ef2-b974fd9c921a |
| QuinnQ.inibin | OLS-52cd735d-cdd2-5ee5-892d-a27998235800 |
| QuinnQ.luaobj | OLS-681807b2-d15b-5062-b1b2-6f3de3158366 |
| QuinnQ.preload | OLS-2c13798d-e9b9-5dc0-9343-6eacbd758574 |
| QuinnQMissile.inibin | OLS-7f229639-5cc2-50f5-820c-c54897b4523a |
| QuinnQMissile.luaobj | OLS-c989af5d-a733-558e-a58e-ce9f64759fed |
| QuinnQMissile.preload | OLS-4d45c70b-5b48-59e2-9017-5da5292b93b8 |
| QuinnR.inibin | OLS-f4071029-4e86-5fdb-83d6-110f63e26565 |
| QuinnR.luaobj | OLS-d5e44af9-b7a2-519f-8d80-4fa94810bda0 |
| QuinnR.preload | OLS-65d92f9f-e86a-5320-9ad0-c9984ec5f379 |
| QuinnRDamage.inibin | OLS-bec932f8-0fbe-536d-bbf3-1e9f0b6eff2e |
| QuinnRDamage.luaobj | OLS-e75896b6-48fe-56df-bbfe-645fc216f28b |
| QuinnRDeath.luaobj | OLS-643f03a6-15a6-5974-96e6-f9f443f76335 |
| QuinnRDeath.preload | OLS-8fe2ca1f-d838-554e-a331-c247c6180fd9 |
| QuinnRFinale.inibin | OLS-686e0f1f-9d8e-5a00-a300-d6fb3a6b6bc7 |
| QuinnRFinale.luaobj | OLS-f48a7636-cfee-5e7a-b00e-455c8abf9193 |
| QuinnRFinaleDamage.inibin | OLS-24b6bc7c-5ec9-5663-91e7-03c63794ba15 |
| QuinnRFinaleDamage.luaobj | OLS-add60d0c-57f4-5d46-8f2f-7986530690d4 |
| QuinnRForm.inibin | OLS-042c7e98-3300-5543-a21d-9f912c494aa8 |
| QuinnRSpeedDebuff.luaobj | OLS-40c97997-dc20-5e76-807d-0e85a9ccc546 |
| QuinnRtimeout.inibin | OLS-e3a31f19-24de-5714-a7a6-3d8f722a33ec |
| QuinnRtimeout.luaobj | OLS-bab9d3e7-ef06-5e24-a8a9-b4d3b970d7d9 |
| QuinnRtimeout.preload | OLS-7f301aa6-c1b8-5f41-a7a2-000fc2a91370 |
| QuinnRtimeoutSupp.luaobj | OLS-af642169-70bb-5c07-8d55-505959d780a6 |
| QuinnSpeedPart.luaobj | OLS-580679b1-38d3-5d3c-9bd8-ddc67e231f77 |
| QuinnSpeedPart.preload | OLS-7d13983c-9a32-5d4d-90e2-b81345a46539 |
| QuinnSpeedPartRemove.luaobj | OLS-e1b890a4-bc96-5b12-bd77-d98a58740aab |
| QuinnSpeedPartRemove.preload | OLS-187de0ff-04c0-5608-a91e-eff43399bbac |
| QuinnSuppressQ.luaobj | OLS-fab80280-db5e-5417-b464-0589169290bb |
| QuinnSuppressQRepeat.luaobj | OLS-d5ff64c8-4896-5da7-b39f-7b57849dff84 |
| QuinnValorE.inibin | OLS-2dfd5c48-c2a5-5e3b-9c90-e0953193d849 |
| QuinnValorE.luaobj | OLS-9320efdf-e01b-54f3-932a-15b84f0b9d93 |
| QuinnValorE.preload | OLS-50e90bb4-b3ab-570f-aa6a-e2425363c2d9 |
| QuinnValorQ.inibin | OLS-eeb1cfe5-cd66-5d51-a9a4-000c9259be3d |
| QuinnValorQ.luaobj | OLS-a7050502-8609-5099-ae56-841d2c0ec2ff |
| QuinnValorQ.preload | OLS-4030b6bc-a89e-5363-9518-4ee5cc5e1ae7 |
| QuinnValorRMis.inibin | OLS-2302185b-4414-506a-b720-77907e795014 |
| QuinnValorRMis.luaobj | OLS-191b99ec-f913-57bf-9194-06cd490ec43b |
| QuinnValorRMis.preload | OLS-29db1fd5-74eb-50b6-9968-d37fa838d5e3 |
| QuinnValorRMisController.inibin | OLS-73e0b287-3872-5fbf-bf01-77073b11aaf3 |
| QuinnValorRMisController.luaobj | OLS-53249aef-f883-5ae8-a9de-bf974b77d3bc |
| QuinnValorRMisController.preload | OLS-9625f4c3-0e22-58b3-8636-601c4403ef5e |
| QuinnW.inibin | OLS-e135fb39-967e-54fd-b5b9-85a0e82649c5 |
| QuinnW.luaobj | OLS-fef3a238-c35d-5957-80ca-2520b21c9278 |
| QuinnW.preload | OLS-191ef9e6-74e5-5880-bbf9-3730d4255cbc |
| QuinnW_Cosmetic.inibin | OLS-2db5a0f3-f413-56f2-81d6-fd5926132442 |
| QuinnW_Cosmetic.luaobj | OLS-a35ded4a-8e99-55f3-b492-68d78a3d962c |
| QuinnW_Cosmetic.preload | OLS-fa70ade3-12f0-51c3-a31e-8a84d764d189 |
| QuinnWBlind.inibin | OLS-be08e237-49d9-5f84-a9f8-27029c4a0253 |
| QuinnWBlind.luaobj | OLS-0f2ff93f-1c5e-5592-ba0e-dc90996265a7 |
| QuinnWDamage.inibin | OLS-40aae9e3-6ab5-5818-8098-0c0e9d5ef629 |
| QuinnWDamage.luaobj | OLS-f44702c0-a541-594b-abf9-c6acf8dde164 |
| QuinnWDamage.preload | OLS-5475f63a-7ee6-58e8-9091-37c45bccc978 |
| QuinnWEnhanced.inibin | OLS-f8b3dc7e-fc84-567d-a067-881aa8970aa5 |
| QuinnWEnhanced.luaobj | OLS-8f103c22-5977-5c0a-9974-3e61baf992e5 |
| QuinnWEnhanced.preload | OLS-06b490ca-604d-5a39-af4c-4ae5ac5d9d2d |
| QuinnWInFlight.inibin | OLS-fe141bf4-9a3b-545c-9302-9bad8a4a0c55 |
| QuinnWInFlight.luaobj | OLS-56c2d970-dfdd-52c9-be6d-d4639e7ed5e2 |
| QuinnWInFlight2.luaobj | OLS-e45cf405-a89a-5e24-86cf-676b12783cf9 |
| QuinnWLongRangeMarker.luaobj | OLS-dbcef2b3-da07-5ea7-b434-09a56cf2528f |
| QuinnWPassive.inibin | OLS-0fcded35-2b4f-510b-82ed-cd17fb529f71 |
| QuinnWPassive.luaobj | OLS-9b7e2d09-d515-574a-a634-eae6c3fade5d |
| QuinnWPassive.preload | OLS-b896de96-f631-5744-80cf-6ba5574c9e96 |
| QuinnWPassiveReady.luaobj | OLS-96459a3f-18c9-50a3-92a7-331965e697c8 |
| QuinnWPassiveReady.preload | OLS-82e9ab63-ba71-5ede-88d8-f48bc11e1568 |
| QuinnWRecentAttack.luaobj | OLS-6451ffc5-d63d-50e3-b315-b0a5c009609b |
| QuinnWTimingMissile.inibin | OLS-57ec24d0-15b1-50f0-94a8-08e95af08756 |
| QuinnWTimingMissile.luaobj | OLS-c0e45301-32c9-5cf6-b2b1-a1b21745e743 |
| QuinnWTimingMissile.preload | OLS-5eff19d4-50c9-58fb-952b-f8120fe00864 |
| QuinnWVision.luaobj | OLS-d5188e33-d089-5e82-afbc-36374ce86419 |

## Références communautaires

37 références présentes,distinctes de l'autorité historique. CharScript communautaire vide. Q applique au rang1 une base70 +1.2 AD total et coefficient magique AP,avec aveuglement1.5s ; le texte natif cite bonusAD et AP2,sans coefficient AD numérique résolu ici. W délègue QuinnSenses5s,sans qualification complète de vision ou bonus de vitesse.

E communautaire :base50 au rang1 +0.2AP +1.0AD total,ralentissement1.5s ; source native Effect2=40,texte bonusAD,ralentissement décroissant2s,rebond/marquage. Le fichier communautaire lu ne contient ni SetPosition ni marqueur WPassive. R délègue QuinnValorForm20s ; cette délégation ne qualifie ni transformation,réactivation ni Skystrike. Un commentaire de simplification/BehindEnemyLines ne remplace pas le contrat4.20. Aucun de ces scripts n'est exécuté comme serveur historique ou accepté comme consommateur Rust.

## Exécution du moteur courant

Compilation privée du véritable cœur Rust,offline/locked,dépendances alignées sur Cargo.lock. BUILD/RUN initiaux et prolongés :0. Binaire final `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-quinn-passive-harrier-long-wait-probe.exe` ; 6061568 octets ; SHA256 `323c52ecb31c1db3aa96b769e2c80c48ce7817591f717fcb953c7f9e5c787698`.

Deux parties publiques Quinn/Annie :sans objet et Épée longue1036 (+10AD). Aucune injection directe de position,PV,rang ou dégâts. Quatre trajets réussis sans réémission,champions vivants niveau1,aucun contrôle/bouclier/vainqueur. Mana Quinn plein,rangs et délais à zéro. Aucun sort Quinn accepté ; aucun dégât entrant ni Q Annie utilisé.

Chaque cas :attente901 ticks,trois attaques à distance,attente901 ticks,trois attaques. Total final :12 impacts avec12 témoins de projectile distincts,3604 ticks d'attente et54 refus atomiques. Les refus couvrent acteur inconnu,attaque de soi,slot invalide et QWER non supportés,avec état inchangé.

| Cas | AD | Dégâts génériques attendus | Dégâts observés | Attente cumulée | Refus |
|---|---:|---:|---:|---:|---:|
| base | 51.04000 | 42.81160736 | 42.81161499 | 1802 | 27 |
| Sword10AD | 61.04000 | 51.19946289 | 51.19946289 | 1802 | 27 |

Impacts de chaque cas :2839/2884/2929 puis3843/3888/3933. Intervalles45 ticks dans une série,914 entre séries. Les901 ticks à30Hz dépassent le champ candidat28 secondes ; ce champ n'est pas qualifié comme période effective de marquage. L'ajout de10AD change seulement les dégâts génériques observés. AP0 dans les deux cas ; forme Valor non exercée.

**Essai initial conservé :** attentes301 ticks,deux cas,12 impacts,54 refus,1204 ticks cumulés,BUILD/RUN0. Son binaire fait6061568 octets,SHA256 8306adb2dacff4bc03026ec9f08385550d31954de87ed1efc1452605592c6cc7. La variante901 ticks étend la fenêtre d'observation,sans remplacer ni présenter comme échec l'essai initial. La découverte initiale100 ressources est également conservée,puis étendue à101 avec QuinnValor. Le diagnostic final chaîne ces preuves antérieures.

## Consommateurs actuels

La recherche Quinn/Harrier dans crates/core/src ne trouve pas d'occurrence ; l'inspection des routes de combat et leur exécution ne trouvent pas de producteur de marque dans le chemin testé. Cette conclusion ne prétend pas couvrir tous les projets ou un serveur historique.

Sept ressources locales liées :catalogue,croissance,ressources,attaques,critiques,collision et boutique. Entrées du diagnostic identifiées et hachées. Aucun consommateur de Harrier remplacé par une fixture ou un lecteur de métadonnées.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Quinn spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary AD/Sword,not Harrier bonus |
| crates/core/src/progression.rs:150 | unsupported Quinn learning |
| crates/core/src/progression.rs:159 | unsupported Quinn ranks |
| crates/core/src/spells.rs:101 | unsupported Quinn targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported Quinn ground spell |
| crates/core/src/lib.rs:685 | 12ranged impacts and3604idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical damage,no Harrier bonus observed |
| crates/core/src/attacks.rs:157 | two series of three projectiles after901tick waits |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit route,not mark consumption |
| crates/core/src/regeneration.rs:32 | ordinary regeneration separated from damage |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | Sword1036+10AD |
| crates/core/src/shop.rs:215 | generic AD bonus |
| crates/core/src/world.rs:226 | one champion enemy,selection priorities unqualified |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary ranged windup |
| crates/core/src/critical.rs:12 | ordinary noncritical projectiles |
| crates/core/src/shields.rs:12 | generic shield,not DoesntBreakShields metadata acceptance |
| crates/core/src/shields.rs:47 | generic absorb path,not Harrier interaction qualification |
| crates/core/src/ally_occupancy.rs:635 | four preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication vérifiée

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_sources_4_20.json,docs/fidelity_requirement_trace_4_20.json. Reçu :docs/reference_requirement_trace_sources/quinn-passive-harrier-links-v616.json. Preuve :docs/fidelity_quinn_passive_harrier_links_v616.json. Instructions copiables des trois fiches et de SYS-01.2-02 actualisées.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases vérifiées :quatre destinataires,42603 autres lignes,42607 états manuels et23 historiques conservés,synchronisation normale idempotente. Identifiants,hiérarchie et registre des inconnues inchangés octet par octet. Trois questions propres et quatre dépendances conservées ; aucun statut,critère,propriétaire ou case clôturé.

Revue globale :99141 sources,4438 consommateurs,4438 ancres exactes,sans divergence. Revue structurelle globale (source_hashes_verified=0),distincte des hashes des sources sélectionnées et du code. Pas de recontrôle exhaustif de toutes les sources revendiqué.

coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md et HANDOFF.md actualisés,anciennes preuves conservées. Aucun stage/reset/commit/nettoyage. Battle Training,V564 et les deux arrivées V606 restent ouverts.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision616_Quinn_discovery,revision616_Quinn_discovery_with_valor,revision616_Quinn_passive_probe,revision616_Quinn_passive_probe_long_wait,revision616_Quinn_inspection (OBSERVATIONS.json),revision616_Quinn/DELIVERY_AUDIT.json et revision617_trace_review/REVIEW.json. Scripts,binaires et commandes sont identifiés.

## Travail restant

1. Relier f1/f2/f3 aux producteurs natifs et qualifier formule,progression et arrondis.
2. Qualifier période de marquage,cibles éligibles,priorité,propriété,durée et expiration.
3. Implémenter le producteur de marque et sa consommation par la première attaque dans le moteur courant.
4. Tester cibles multiples,plusieurs Quinn,ordre impact/expiration,annulation et projectiles en vol.
5. Qualifier le marquage E,bonus W,transformations Valor et retour Quinn.
6. Vérifier mort/respawn,furtivité,boucliers,immunités et nettoyage des états.
7. Résoudre les liaisons BuffData ambiguës et le choix effectif des ressources/locales.
8. Qualifier HUD,particules,animations,audio et synchronisation réseau séparément.

Aucun serveur historique,rendu,audio ou transport réseau qualifié ici. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision617_trace_review/REVIEW.json. V616 Quinn / Harrier : 101 sources natives,303 associations,24 points et48 liens. Texte natif : Valor marque périodiquement une cible Vulnérable ; première attaque avec bonus physique f2+f1, durée f3. Valeurs,période,sélection et propriété restent ouvertes. Deux cas publics base/Épée1036+10AD :12 impacts à distance,54 refus et3604 ticks d’attente. Deux attentes de901 ticks par cas dépassent le champ candidat Cooldown1=28s sans le qualifier ; dégâts seulement ordinaires42,81161/51,19946. Aucun sort Quinn accepté ni transformation Valor exercée. Premiers essais301ticks conservés,ainsi que collecte initiale avant ajout de QuinnValor trouvé présent. 44Lua dont14limites NEWTABLE,22preloads,11liens BuffData dont8résolus et3nonrésolus ; QuinnValorQ pointe vers VolibearE. DDF60lignes dont40Khazix et variante en_us28lignes,les deux conformes au manifeste core ; seul coefficient non vide concerne KhazixW,aucune formule Harrier déduite. CharScripts natif/communautaire vides ;37références communautaires. Quatre candidats absents et Valor présent ne prouvent pas un manque global d’assets. Q communautaire ADtotal contre texte bonusAD ; E dégâts/slow sans bond/retour/marquage qualifiés ; W/R délèguent des buffs. Quatre trajets réussis ; V564/V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT : 0 ; 72+4 refus de publication. Prochain passif à inspecter réellement : Rammus. Goal actif.
