# SYS-01.2-02 — Mordekaiser : sources et consommateurs d’Iron Man (V604)

Date UTC : 2026-10-26T10:03:01.579252+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

## Résultat et portée

Les fiches CH-Mordekaiser-PASSIF-SOURCE, CH-Mordekaiser-PASSIF-SIMULATION-CONTRAT et CH-Mordekaiser-PASSIF-SIMULATION sont reliées à57 sources natives,171 associations,32 points du moteur et64 liens sur les deux fiches de simulation. Ces points restent des frontières ou du contexte ; aucun consommateur complet d’Iron Man n’est démontré. Aucun gameplay ni asset modifié, aucun statut ou case fermé.

Les sources donnent la structure du passif, mais pas les valeurs dynamiques f1/f2 ni toutes les règles de décroissance. Deux simulations publiques montrent une ressource Shield120 constante qui n’absorbe aucun dégât. Aucun sort Mordekaiser n’est accepté : la conversion des dégâts de compétence ne peut pas être exercée. Les attaques ordinaires contrôlées ne remplacent pas ce déclencheur. Un contrôle séparé de l’API autoritaire de bouclier générique fonctionne, sans constituer un producteur ou une qualification d’Iron Man.

## Sources exactes et inconnues

- Mordekaiser.inibin : PARType=Shield, BaseMP chaîne120.0, MPPerLevel chaîne0, BaseStaticMPRegen=0, Passive1LuaName=MordekaiserIronMan, icône Mordekaiser_IronMan.dds. PARName/Max/Start/RegenRate/Enabled et Passive1Level1..6 sont absents. BaseMP120 ne prouve pas le plafond natif ou la charge initiale du bouclier.
- Description en_GB ligne4235 : une part des dégâts de compétence devient un bouclier temporaire absorbant les dégâts reçus. Tooltip IronMan ligne2311 : conversion `@f2@%`, plafond `@f1@ Health`, décroissance3% par seconde, conversion moitié contre les sbires. Valeurs f1/f2, progression, base de décroissance, cadence, délai, plancher et ordre de traitement restent ouverts. « Moitié contre les sbires » ne définit pas la règle pour toutes les cibles non champion.
- Passive1Desc pointe vers game_character_passiveDescription_Jester, absent du fichier en_GB par recherche de clé exacte. PassLev1Desc1 donne la description Mordekaiser correcte ; PassLev1Desc2..4 contiennent d’anciens textes +40/+60/+80% de régénération de mana. Aucun remplacement silencieux ni progression de bouclier déduite.
- IronMan.inibin fournit la liaison BuffData ; les champs SpellData inspectés (tooltip/description/icône, cooldown/coût, rayon/portée, coefficients, Effect1Level0..5) sont absents. Une absence ne vaut pas zéro.
- IronMan.luaobj est une initialisation littérale de BuffName, BuffTextureName et PersistsThroughDeath=true. NonDispellable n’est pas présent ; aucune valeur par défaut inventée. La persistance de métadonnées ne qualifie pas la charge au respawn.
- Les24 Lua sont parcourus entièrement, sans prototype enfant, tous littéraux et sans limite NEWTABLE dans ce lot. Cela ne vaut pas exécution des callbacks du serveur original. CharScriptMordekaiser natif et communautaire sont vides ; la définition communautaire IronMan ne contient que la clé du tooltip BuffData.
- Six liaisons BuffData exactes : COTGDot, COTGPet, COTGSelf, CreepingDeathBuff, IronMan, MaceOfSpades, lignes2307 à2312. Les13 preloads relient passif, mort, danse, dégâts supplémentaires aux tours et effets Q/E. Présence et dépendance ne prouvent ni chargement effectif ni rendu.
- Les4 lignes DDF concernent MaceOfSpades : f1=1,65bonusAD, f2=1,0bonusAD et deux lignes vides. Ces f1/f2 de Q ne résolvent pas ceux d’Iron Man. Le ratio0,5 de CotGGuide et OnPreDamagePriority10 de ChildrenOfTheGrave appartiennent à R, pas à la conversion ou à la priorité du passif.
- Alias COTGDanceOverride : icône Malady et BuffName NautilusPassive ; CotGGuide : icône Viktor/InfernalGuardianGuide ; CreepingDeathDebuff : icône FallenAngel_TormentedSoil. Ils restent distincts d’une politique de Nautilus, Viktor ou Morgana.
- 23 références communautaires identifiées, aucun fichier NightmareBot dans la sélection. Six chemins candidats absents : CharScript à la racine, IronMan.inibin/.luaobj sous Characters/Mordekaiser/Spells, IronMan.preload, MordekaiserPassive.inibin et IronMan.ddf sous DATA/Spells. Les vrais CharScript sous Scripts et IronMan sous DATA/Spells existent. Aucune absence globale de modèle, texture, animation ou son déduite.

Les57 sources sélectionnées sont comparées au registre et à l’appartenance RADS retenue, avec tailles et SHA-256.

| Fichier | Source |
|---|---|
| Mordekaiser.inibin | OLS-f3c48b67-ecf3-5774-8faf-0d1a13d1f288 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Mordekaiser.ddf | OLS-e8c17e80-e424-567b-8007-9ae25327ebd6 |
| CharScriptMordekaiser.luaobj | OLS-ee4a1330-f867-5628-a09b-933e64fa32e9 |
| CharScriptMordekaiser.preload | OLS-c2e34272-6955-5b88-94cf-219549e22249 |
| MordekaiserBasicAttack.inibin | OLS-be9cc56a-e72f-5eb8-be89-3b6491461a70 |
| MordekaiserBasicAttack2.inibin | OLS-57633c49-beeb-5e70-b03a-ae4d06ff24b9 |
| MordekaiserChildrenOfTheGrave.inibin | OLS-e9a0c46e-f254-55fe-93f7-5e0540e93792 |
| MordekaiserChildrenOfTheGrave.luaobj | OLS-b3b490db-cbed-56dd-9f7f-964a14ce3b9c |
| MordekaiserChildrenOfTheGrave.preload | OLS-772aa192-3f79-588f-943b-3606a260d94b |
| MordekaiserCOTGDanceOverride.luaobj | OLS-9fb6447a-aced-5b69-8f04-434be642cb14 |
| MordekaiserCOTGDot.inibin | OLS-156adc2c-2ea0-547f-85e1-e476925b03f3 |
| MordekaiserCOTGDot.luaobj | OLS-9a2fe203-3289-51c3-b16d-f842e2d276a3 |
| MordekaiserCotGGuide.inibin | OLS-2c9fa4b8-fff9-55eb-b6ba-5325d5a6a45e |
| MordekaiserCotGGuide.luaobj | OLS-2794bc78-c0e2-594f-a575-012a90ef3bd8 |
| MordekaiserCotGGuide.preload | OLS-7668c5c4-bb95-5770-b8b8-5eca813dfb12 |
| MordekaiserCOTGPet.inibin | OLS-1c1f94ef-677f-5bc6-a703-6e1dec1737d9 |
| MordekaiserCOTGPetBuff.inibin | OLS-ffc1c70b-f862-5d9d-95a0-8f78acd43311 |
| MordekaiserCOTGPetBuff.luaobj | OLS-46824b45-25b0-5774-b709-a88aa2855755 |
| MordekaiserCOTGPetBuff.preload | OLS-14f2a220-fdee-5883-9151-fae62ff897b2 |
| MordekaiserCOTGPetBuff2.luaobj | OLS-e128babf-a167-566b-9e0d-a9f919ff2bf4 |
| MordekaiserCOTGPetBuff2.preload | OLS-763dfba8-648c-579d-82f4-3569d7478e0c |
| MordekaiserCOTGPetDmg.luaobj | OLS-930b746f-3c2d-58dd-b338-5054f10912f9 |
| MordekaiserCOTGPetID.luaobj | OLS-9e328259-b6ef-593c-a0db-9fa71cd6baf6 |
| MordekaiserCOTGRevive.inibin | OLS-9aa7dd6f-813f-5f16-a112-256e2a0c3bd6 |
| MordekaiserCOTGRevive.luaobj | OLS-ca2dd913-c2e3-5ad7-8648-4e6f9d4ccc7e |
| MordekaiserCOTGRevive.preload | OLS-4781fbc2-4062-52cf-8f1e-860ddcd030c2 |
| MordekaiserCOTGSelf.inibin | OLS-dd1515e7-b464-5c09-8321-9aecd0b27392 |
| MordekaiserCOTGSelf.luaobj | OLS-01d6f827-2472-5f10-8a89-8c8815c34933 |
| MordekaiserCreepingDeath.inibin | OLS-9f2f0dae-8e4b-53c6-82b6-44a8628f592a |
| MordekaiserCreepingDeath.luaobj | OLS-2a9b399a-1906-5bc4-86e3-db0931747d75 |
| MordekaiserCreepingDeath.preload | OLS-0ce1b6a4-6a87-5d32-b7a0-af1ba06750ac |
| MordekaiserCreepingDeathBuff.inibin | OLS-344acb78-b6db-58c7-a3e4-e9562c7d5723 |
| MordekaiserCreepingDeathCast.inibin | OLS-4fa33d00-7734-5906-91ad-fecf558b3d5e |
| MordekaiserCreepingDeathCast.luaobj | OLS-7b5df62d-b79c-570c-bb6e-1ae08efaed57 |
| MordekaiserCreepingDeathCast.preload | OLS-9c411f23-732d-5bf1-b721-029c9be00bb5 |
| MordekaiserCreepingDeathCheck.luaobj | OLS-33b7ac3f-1929-507c-b1e6-c6c00b00216b |
| MordekaiserCreepingDeathDebuff.luaobj | OLS-7db2af94-109e-5dc9-aa0d-5ea3ca2805b8 |
| MordekaiserCritAttack.inibin | OLS-5d62a7d9-26db-51ab-9f37-dda97b8191cb |
| MordekaiserDeathParticle.luaobj | OLS-8f6dcf66-20fc-5012-b85f-d58ba4e53683 |
| MordekaiserDeathParticle.preload | OLS-dc89cbd1-7bad-55da-944c-1c68daeecf0e |
| MordekaiserIronMan.inibin | OLS-a4611436-57cd-539a-a2bc-b04209855c81 |
| MordekaiserIronMan.luaobj | OLS-69890b83-3baf-5f72-a05d-3ed7819ef6d8 |
| MordekaiserMaceOfSpades.inibin | OLS-db613cd4-4f9f-513e-b4e6-55525149436e |
| MordekaiserMaceOfSpades.luaobj | OLS-f884f6bc-77c9-5a81-b0d0-ff2349916cc9 |
| MordekaiserMaceOfSpades.preload | OLS-6f504a4e-900b-5667-8a9a-9f6602b9465d |
| MordekaiserMaceOfSpadesDmg.luaobj | OLS-207e8db4-8f78-5068-994e-877889dafdba |
| MordekaiserNukeOfTheBeast.inibin | OLS-9297ea62-d88d-5a99-b1e5-f15d041b45ef |
| MordekaiserNukeOfTheBeast.luaobj | OLS-d1b96f45-aeda-5310-b1aa-e2cf0ac04b88 |
| MordekaiserNukeOfTheBeast.preload | OLS-37503fab-94e6-57c2-bc54-9aeeec37b2a1 |
| MordekaiserNukeOfTheBeastDmg.luaobj | OLS-280f8303-b248-5a68-8631-cd65a4f7634e |
| MordekaiserSyphonDmg.luaobj | OLS-835213c6-33be-5bfe-993f-23e254c0604a |
| MordekaiserSyphonOfDestruction.inibin | OLS-adc76a33-3eb0-56d3-958e-6bf79c4c1aad |
| MordekaiserSyphonOfDestruction.luaobj | OLS-6796cd08-d7f7-5e91-a4ac-4feb547c2e2c |
| MordekaiserSyphonOfDestruction.preload | OLS-1b192ae8-bcee-5782-b911-817de82bcb61 |
| MordekaiserSyphonParticle.luaobj | OLS-f8320ca2-cbe2-5054-b5b6-ae6dbed522f2 |
| MordekaiserSyphonParticle.preload | OLS-e8e8dcd5-0f25-54a7-b163-964b07d471d8 |

## Prérequis et exécution

Phases, lots, dépendances et questions sont enregistrés dans les observations et le reçu. Trois questions propres et quatre dépendances de tâches restent conservées ; ce diagnostic ne lève pas les prérequis de fidélité.

Compilation Rust `--locked --offline`, core réel hors configuration de test, identités et checksums des dépendances alignés sur Cargo.lock. Les1158 entrées de référence core/ressources et la chaîne antérieure restent inchangées, y compris les trois essais Wukong échoués de V603. Ce lot ne répare pas la navigation ; V564 reste ouvert. Les six trajets de préparation aboutissent sans reprise Move.

Deux parties publiques Mordekaiser/Annie : Join/Buy/Move/Stop/Attack/Learn/Cast ordinaires, sans injection d’état dans ces cas. Tous restent vivants au niveau1, sans victoire, décès, contrôle ou bouclier Iron Man. Rangs et délais de Mordekaiser restent nuls.

| Cas | PV max | Ressource | Attaques sortantes | Physiques entrants | Q entrants | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|---:|
| base | 555.40002 | 120 | 3 | 3 | 1 | 27 | 122 |
| Ruby150_Sapphire200_nonmana_control | 705.40002 | 120 | 3 | 3 | 1 | 27 | 122 |

Ruby1028 (+150PV,400or) et Sapphire1027 (+200mana,400or) sont achetés dans le budget825. PV555,4/705,4 ; ressource et plafond du porteur mana120 dans les deux cas, régénération de ressource0. uses_mana exclut Shield des bonus de mana. Ce constat du moteur n’est pas une qualification de la capacité native d’Iron Man.

Attendu/observé : trois attaques ordinaires de Mordekaiser et trois projectiles physiques Annie par cas ont des témoins de cible, déclenchement et dégâts. Les pertes de PV correspondent à la mitigation et à la régénération, résidu inférieur à0,002. Chaque Q accepté inflige80 bruts et coûte60mana ; la perte de PV suit la résistance magique ordinaire, sans absorption préalable. Six attaques ordinaires sortantes ne constituent pas une preuve d’échec d’une conversion sur dégâts de compétence : aucun sort Mordekaiser n’a été accepté.

Deux fenêtres de61ticks par cas, soit244 ticks d’attente. Aux offsets29/30/31/59/60/61, la ressource reste120 et la liste de boucliers vide. Ces offsets sont ceux d’une attente, pas l’âge d’un bouclier actif ni une validation du taux de décroissance. Les54 refus atomiques comprennent joueur inconnu, auto-ciblage, slot invalide et apprentissages/lancements ciblés/au sol QWER avant puis après les observations. Les snapshots avant/après chaque refus sont identiques.

### Contrôle générique séparé

Une troisième simulation utilise `grant_shield`, API autoritaire d’événement, avec des tags explicitement marqués LOCAL_GENERIC et NOT_IRON_MAN. Ce n’est pas un ordre client produisant le passif et ce cas ne relève pas de l’affirmation « sans injection » des deux cas publics précédents.

- Sept événements invalides sont refusés sans mutation : NaN, infini,0,-1,tag vide,durée nulle,joueur inconnu.
- Charge50 et durée60ticks : le troisième Q Annie public,80 bruts/60mana, consomme50 de bouclier ; les dégâts restants vont aux PV conformément à la résistance magique. Le porteur de ressource reste120.
- Charge80 et durée30ticks :80 inchangé aux offsets1..29, bouclier absent aux offsets30/31. L’expiration fixe fonctionne ; ce n’est pas une décroissance de3% par seconde.

Les résultats vérifient seulement ces capacités génériques et leurs limites. Ils ne résolvent ni conversion, plafond, priorité, décroissance ni présentation d’Iron Man.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-mordekaiser-passive-iron-man-probe.exe` ; 6107648 octets ; SHA-256 `f270d2f8073b114a3ca0455a5ed7d1dbf746784a34bab6048b1ca2f25f264b19`. BUILD/RUN et inspection renvoient0. Aucun serveur original, rendu, audio ou transport réseau exécuté dans ces contrôles.

## Consommateurs reliés

join initialise le porteur de ressource ; stats, shop et lifecycle déterminent plafond et bonus ordinaires. apply_damage utilise les défenses et les boucliers génériques. grant_shield, advance_shields et absorb_shields n’apportent pas un producteur Iron Man. Les frontières learn/cast/cast_at refusent les compétences de Mordekaiser. Le récapitulatif des dégâts et les snapshots restent du contexte, sans qualification graphique ou réseau.

Huit ressources locales : champions, croissance, ressources, contrats d’attaque/critique, collisions, boutique, Q Annie. Ce sont des entrées du moteur courant, pas des corps serveur historiques.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | resource carrier initialized120,empty general shields |
| crates/core/src/lib.rs:598 | actual public action andrefusal boundary |
| crates/core/src/progression.rs:68 | maxresource120 despite Sapphire,HP +150Ruby |
| crates/core/src/progression.rs:150 | unsupported Mordekaiser learning |
| crates/core/src/progression.rs:159 | unsupported Mordekaiser rank policy |
| crates/core/src/spells.rs:101 | unsupported Mordekaiser ability trigger |
| crates/core/src/annie_w.rs:29 | unsupported Mordekaiser ground cast |
| crates/core/src/lib.rs:685 | actual tick order,244public idle ticks |
| crates/core/src/lib.rs:744 | resource andshield state,not network acceptance |
| crates/core/src/damage.rs:53 | actual outgoing/incoming physical andincoming magic impacts |
| crates/core/src/attacks.rs:157 | Mordekaiser ordinary melee andAnnie ranged controls |
| crates/core/src/lifesteal.rs:4 | ordinary basic effects,not abilitydamage conversion |
| crates/core/src/regeneration.rs:32 | health regeneration,zero Shield resource regeneration |
| crates/core/src/regeneration.rs:10 | resource0 andhealth corrections |
| crates/core/src/shop.rs:261 | Ruby1028 HP150,Sapphire1027 mana200 control |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | ordinary target state |
| crates/core/src/damage.rs:38 | physical/magic damage beforegeneral shields |
| crates/core/src/attacks.rs:26 | actual ordinary melee timing |
| crates/core/src/critical.rs:12 | ordinary noncritical context |
| crates/core/src/death_recap.rs:184 | damage capture context,notrendered recap |
| crates/core/src/death_recap.rs:200 | damage recap context |
| crates/core/src/shields.rs:12 | separate generic authoritative event,notIronMan producer |
| crates/core/src/shields.rs:41 | generic fixed expiry30ticks,not3percent decay |
| crates/core/src/shields.rs:47 | separate generic50absorption control |
| crates/core/src/lifecycle.rs:16 | Shield excluded frommana item cap |
| crates/core/src/lifecycle.rs:24 | Shield excluded fromMana/Energy restoration |
| crates/core/src/shop.rs:314 | actual purchase caprefresh,notshield generation |
| crates/core/src/annie.rs:45 | accepted Q raw80cost60 |
| crates/core/src/annie.rs:73 | three magic impacts includingseparate generic control |
| crates/core/src/ally_occupancy.rs:635 | six public setup travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | actual movement boundary,V564 remains open |

## Livraison et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/mordekaiser-passive-iron-man-links-v604.json ; preuve docs/fidelity_mordekaiser_passive_iron_man_links_v604.json. Les instructions copiables portent les règles sourcées, limites, distinction du contrôle générique et tâches restantes. SYS-01.2-02 reçoit la synthèse.

PREPARE/CHECK/PUBLISH/AUDIT renvoient0 ;72 associations volontairement altérées et4 graphes invalides refusés. Trois fragments de traçabilité changent,42212 restent identiques. Les deux bases SQLite, projet et application installée, reçoivent quatre lignes ciblées ;42603 autres lignes,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Identifiants, phases/lots et inconnues identiques octet par octet. Aucun critère, prérequis, propriétaire, état, case ou note fermé automatiquement.

Revue globale :99093 sources,4128 consommateurs,4128 ancres exactes,aucune divergence. source_hashes_verified=0 désigne le contrôle structurel global ; les sources sélectionnées et consommateurs sont hachés séparément, sans revendiquer un nouveau contrôle exhaustif des99093 sources.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés en conservant les preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision604_Mordekaiser_discovery/OBSERVATIONS.json ; revision604_Mordekaiser_passive_probe/OBSERVATIONS.json ; revision604_Mordekaiser_inspection_qualified/OBSERVATIONS.json ; revision604_Mordekaiser/DELIVERY_AUDIT.json ; revision605_trace_review/REVIEW.json. Tous les contrôles de ce lot renvoient0 ; les échecs antérieurs restent conservés dans la chaîne.

## Travail restant

1. Résoudre les valeurs et progressions f1/f2 depuis une source identifiée.
2. Résoudre la base, le délai, la cadence, le plancher et l’ordre de décroissance.
3. Implémenter et qualifier les sorts produisant des dégâts admissibles, puis le producteur de charge Iron Man.
4. Vérifier avant/après mitigation, multi-cibles, périodiques, Q renforcé, invocations et catégories de cibles ; ne pas généraliser la réduction sbires aux monstres sans preuve.
5. Tester charge nulle/partielle/pleine, plafond, génération/décroissance simultanées, plusieurs boucliers et priorités, coûts en PV et dégâts purs.
6. Qualifier mort/respawn, dissipation, niveau, objets, déconnexion et fin de partie ; ne pas déduire ces règles du seul PersistsThroughDeath.
7. Vérifier séparément barre de bouclier, icône, particules, animations, sons, rendu et réplication.
8. Conserver les autres limites du projet, dont Battle Training et navigationV564, sans les confondre avec le diagnostic du passif.

Les trois tâches Mordekaiser restent ouvertes selon leurs états antérieurs. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision605_trace_review/REVIEW.json. Mordekaiser V604 intégré :57sources171associations32points64liens. 57 sources natives,23 références communautaires,24 Lua littéraux,13 preloads,6 buffs résolus et4 DDF Q. Iron Man décrit f2% des dégâts de compétence convertis en bouclier plafonné à f1 PV, décroissant de3% par seconde, conversion moitié contre les sbires. f1/f2 et base/cadence/plancher de décroissance non résolus. PAR Shield et BaseMP120 ne prouvent pas le plafond natif ;alias Jester sans traduction et anciens textes mana conservés. CharScript vides ;six chemins candidats absents. Deux cas publics sans objet/Ruby150PV Sapphire200mana :6attaques sortantes6physiques entrantes2Q Annie,244ticks d’attente,54refus atomiques. PV555,4/705,4,ressource120 constante,aucun bouclier Iron Man ;aucun sort Mordekaiser accepté,donc déclencheur de dégâts de compétence non exercé. Contrôle générique séparé par API autoritaire :absorption50 sur un troisième Q Annie,expiration fixe80 à30ticks observés sur31ticks et7événements invalides refusés. Aucune qualification Iron Man. Six trajets publics sans reprise ;V564 reste ouvert. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus d’association/graphe. Conserver preuves,statuts,inconnues et contrôles génériques distincts du passif. Prochain passif à inspecter réellement : Morgana. Goal actif.
