# Poppy — sources et consommateurs du passif, V615

Date UTC : 2026-10-26T13:20:09.334798+00:00. Tâche SYS-01.2-02, projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du2014-11-17 à17:46:45, fuseau et déploiement non établis.

## Résultat et portée

Les fiches CH-Poppy-PASSIF-SOURCE, CH-Poppy-PASSIF-SIMULATION-CONTRAT et CH-Poppy-PASSIF-SIMULATION sont enrichies :46 ressources natives,138 associations,24 points du code et48 liens supplémentaires pour les deux fiches de simulation. Les lecteurs de sources ne sont pas promus en implémentation.

La réduction Valiant Fighter reste absente du chemin inspecté et testé. Les dégâts observés correspondent à la mitigation générique, y compris au-dessus du seuil décrit. Les essais ne qualifient pas la formule historique ni son ordre de calcul. Aucun gameplay ou asset modifié ; trois questions propres,quatre dépendances,statuts,critères et propriétaires conservés.

## Sources natives et limites

46 ressources :12 INIBIN,19 Lua compilés,14 preloads et le fichier de texte en_GB. Elles correspondent au manifeste sélectionné. Les19 Lua sont parcourus entièrement,sans sous-fonctions ; quatre limites NEWTABLE (DevastatingBlow,HeroicCharge,ParagonOfDemacia et PoppyE) restent explicites. Une limite de lecture n’est pas une corruption ; des littéraux ne constituent pas l’exécution du serveur.

Poppy.inibin lie PoppyValiantFighter et Poppy_ValiantFighter.dds. La description ligne4255 et le BuffData ligne2471 indiquent des dégâts physiques/magiques dépassant10% des PV actuels réduits de50%, avec exclusion des structures. Le texte PoppyWIP ligne4256 omet cette exclusion ; il ne remplace pas la référence Poppy.

**Restent à qualifier :** partie exacte des dégâts réduite, comparaison et arrondis du seuil, moment de lecture des PV, ordre résistances/pénétration/autres réductions/boucliers/régénération, identification des structures. Les illustrations numériques « moitié de l’excédent » et « moitié du coup entier » du diagnostic sont explicitement des hypothèses, pas des règles natives adoptées.

Les champs hérités restent visibles : Passive1=9, Passive1Level1..4=3/7/11/15, Passive1Desc décrit Jax et PassLev1Desc2..4 la régénération de mana40/60/80%. Ils ne prouvent pas une progression de Valiant Fighter. Les champs de niveaux5/6 sont absents.

Le CharScript natif se trouve à la racine du personnage et est vide. Le CharScript communautaire est également vide. Le Lua du passif expose nom,icône,PersistsThroughDeath et NonDispellable ; aucun callback de réduction n’est qualifié par ces métadonnées. Les preloads référencent le passif,Paragon et une particule ; ils ne prouvent pas le rendu ou les règles de dommages.

Huit liens BuffData sont résolus exactement. L’un d’eux, HeroicCharge, pointe sur **VayneCondemn**, dont le texte mentionne une arbalète de Vayne. Cette liaison est conservée comme donnée source ; sa résolution textuelle n’est pas une acceptation sémantique pour Poppy.

Cinq candidats absents sont documentés : CharScript dans Scripts au lieu de la racine,Poppy.ddf,PoppyValiantFighter.inibin global au lieu du répertoire personnage,PoppyWIP.inibin et PoppyValiantFighter.ddf. Aucun DDF retenu ; aucune absence générale d’assets déduite. Aucun doublon de basename ni variante NightmareBot dans les46 ressources sélectionnées.

| Ressource | Identité du registre |
|---|---|
| Poppy.inibin | OLS-93907f8c-74f5-5551-94a4-e462eef3e81a |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptPoppy.luaobj | OLS-f8da08c8-0e7f-5816-967c-b03fd40ec6ff |
| CharScriptPoppy.preload | OLS-dfa20e76-ff2d-548f-9de9-d61233f49473 |
| PoppyBasicAttack.inibin | OLS-820a882c-d27f-5a4e-8ce9-3ebc5080215d |
| PoppyDevastatingBlow.inibin | OLS-aad62652-a01d-5ef3-bfa2-db2d3a426cc7 |
| PoppyDevastatingBlow.luaobj | OLS-7480617b-68b6-54e5-aff8-97a4229401db |
| PoppyDevastatingBlow.preload | OLS-78d9de92-511d-5ba8-8c62-a855f90f423a |
| PoppyDiplomaticImmunity.inibin | OLS-5937e040-fd61-5234-94f0-767430a500fd |
| PoppyDiplomaticImmunity.luaobj | OLS-79d4c9f7-afb2-537e-a572-ab53f88210e3 |
| PoppyDiplomaticImmunity.preload | OLS-80d860a1-ec02-5535-ab20-d310cb3fbc08 |
| PoppyDiplomaticImmunityDmg.inibin | OLS-29eebdc7-6f00-5651-b71f-767cd0d5bd97 |
| PoppyDITarget.inibin | OLS-1f35d0ec-6920-52c1-9536-f41d4dc63b72 |
| PoppyDITarget.luaobj | OLS-10e332d5-9192-5e8b-a64b-a8597d9e6b55 |
| PoppyDITarget.preload | OLS-ea04f3cd-3e90-532d-a86c-0854e86bf937 |
| PoppyDITargetDmg.luaobj | OLS-8792034c-c737-5711-a5f5-3621fd88df01 |
| PoppyEPushEnemy.luaobj | OLS-dec2b097-eca8-564a-88f1-3411306e9ecc |
| PoppyEPushEnemy.preload | OLS-7f6f99b3-691f-5d4f-a0d3-c1408434aae3 |
| PoppyEPushSelf.luaobj | OLS-55273215-bd0f-5802-a091-44a026a8f145 |
| PoppyEPushSelf.preload | OLS-42f544db-fd97-598a-9870-d7581f302065 |
| PoppyETarget.luaobj | OLS-dd21f259-d417-53d1-91ca-2787f8b398f8 |
| PoppyHeroicCharge.inibin | OLS-1d61a624-78bd-583f-8621-46c145c0b968 |
| PoppyHeroicCharge.luaobj | OLS-438ec0b9-d8e9-526c-9a3a-c8d64e982c37 |
| PoppyHeroicCharge.preload | OLS-95b6bc65-d565-5858-baa8-95bf3e63c253 |
| PoppyParagonManager.inibin | OLS-d2ed9fa2-a597-5fe6-82ae-665b5a43a2af |
| PoppyParagonManager.luaobj | OLS-6157d3a7-9561-5676-bc2e-c0099a2c66b5 |
| PoppyParagonManager.preload | OLS-621ce4ce-0182-560e-ad03-c34bc2112fad |
| PoppyParagonOfDemacia.inibin | OLS-93e2e7ba-2cf7-5738-96d8-2b4795a6cb8c |
| PoppyParagonOfDemacia.luaobj | OLS-768fba01-dcad-523a-9748-70c8ac8296cf |
| PoppyParagonOfDemacia.preload | OLS-5d0219bd-eb01-58d2-9f0d-33e4f6be25a0 |
| PoppyParagonParticle.luaobj | OLS-eb864268-1c06-519c-8975-1624705a994e |
| PoppyParagonParticle.preload | OLS-24e8e353-0132-53a8-bbf3-1f12fec017f0 |
| PoppyParagonSpeed.inibin | OLS-b3c15b22-1cbc-5248-887d-eab5cf7749aa |
| PoppyParagonSpeed.luaobj | OLS-39262d90-bb08-5acd-a9e9-09eeb36edfc9 |
| PoppyParagonSpeed.preload | OLS-d79cc19f-6138-5055-84ad-1b8548640bbd |
| PoppyParagonStats.luaobj | OLS-0eeb3008-1dd7-5a10-aa4f-fd856b013fb1 |
| PoppyValiantFighter.inibin | OLS-b735f4f3-f073-5d61-98d2-3e9bc8712101 |
| PoppyValiantFighter.luaobj | OLS-1678f4d7-3811-5f24-b27b-fbbc80b6fefe |
| PoppyValiantFighter.preload | OLS-4db114b8-89d2-59bf-859a-48fdda7d0cd3 |
| PoppyE.inibin | OLS-67e41605-7d07-5e61-ac2b-2c8d3578baee |
| PoppyE.luaobj | OLS-2f193e7a-58b9-588c-afd9-a5d9e19ddad0 |
| PoppyE.preload | OLS-c490e7cb-ef6f-5e49-9085-97a403bbaba4 |
| PoppyHeroicChargePart2.luaobj | OLS-ef3f8f3e-4061-5253-8c9a-4606ae4a11c0 |
| PoppyHeroicChargePart2.preload | OLS-cd8aa68e-8f36-5ac5-b6ea-900089329f6f |
| PoppyHeroicChargePart2Check.luaobj | OLS-00391559-9d60-5b76-841d-4edb3bc3cf96 |
| PoppyHeroicChargePoppyFix.luaobj | OLS-a512f866-6af6-5e8d-a981-8ae3b454141b |

## Références communautaires

17 références présentes sont séparées de l’autorité historique. Le Q communautaire inflige directement des dégâts magiques et fait décroître le pourcentage des PVmax de8% à4% avec le rang. Le texte natif indique8% constant,une composante CharTotalPhysical2 et un plafond. Le fichier communautaire lu ne qualifie ni l’attaque suivante renforcée,ni cette composante AD,ni le plafond.

W délègue PoppyParagon pendant5s ; sa délégation ne démontre pas les dix cumuls,les gains d’armure/dégâts et leur déclenchement décrits dans le texte natif. E inflige dégâts et stun1s sans déplacement ou collision au mur qualifiés ; le texte natif distingue impact initial et collision avec dégâts supplémentaires/stun. R délègue PoppyDiplomacy sans sélection de cible dans le fichier lu ; ce point ne qualifie pas l’immunité dépendant de la cible ni les dégâts amplifiés.

Ces scripts n’ont été ni exécutés comme serveur historique ni intégrés comme consommateurs Rust. Le passif de W et l’immunité de R restent distincts de Valiant Fighter.

## Exécution du moteur courant

Compilation privée du véritable cœur Rust sans configuration test,dépendances alignées sur Cargo.lock,offline/locked. BUILD et RUN ont retourné0. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-poppy-passive-valiant-fighter-probe.exe` ; 6135296 octets ; SHA256 `32b4ea468478ac52b01b82aaf7982f90a6ddc603dd0a550022a4c2d07585420c`.

Trois parties publiques Poppy/Annie : base,Rubis1028 (+150PV),Cape1033 (+25RM). Aucune injection directe de position,PV,dégâts ou rang. Six trajets préparatoires réussis,sans réémission d’ordres. Champions vivants au niveau1,sans contrôle de foule ou bouclier actif,sans vainqueur ; rangs/délais Poppy à zéro et mana plein.

Chaque cas comprend un Q Annie,trois attaques entrantes,120 ticks d’attente,un second Q,trois attaques entrantes puis trois attaques mêlée de Poppy. Total :neuf attaques mêlée sortantes,18 impacts physiques entrants,six Q Annie raw80/coût60,360 ticks de régénération et81 refus atomiques. Acteur inconnu,attaque de soi,slot invalide et QWER non supportés sont refusés avec snapshots inchangés. Aucun sort Poppy accepté.

| Cas | PVmax | RM | Événements au-dessus du seuil illustratif | En dessous | Refus |
|---|---:|---:|---:|---:|---:|
| base | 559.08002 | 30.0 | 5 | 3 | 27 |
| Ruby150HP | 709.08002 | 30.0 | 1 | 7 | 27 |
| Mantle25MR | 559.08002 | 55.0 | 4 | 4 | 27 |

Ces classifications comparent les dégâts après mitigation générique à10% des PV du tick,avant/après régénération consignés. Elles n’adoptent pas l’ordre historique. Sur24 événements entrants :10 au-dessus,14 en dessous ; le moteur n’applique aucune réduction supplémentaire dans les deux catégories.

Attendu du calcul générique :physique39,16252136,magie61,53845978 sans Cape et51,61290359 avec Cape. Observé,après correction de régénération :environ39,16253,61,53846 et51,61293. Le Rubis augmente les PV et déplace le seuil ; il ne modifie pas directement ces dégâts. La Cape modifie la mitigation magique,distincte d’un passif.

Exemple mesuré sans objet :un impact physique après blessure arrive avec333,97672PV avant le tick ; seuil après régénération33,40326,dégâts génériques39,16252,dégâts observés39,16254. Une illustration réduisant seulement l’excédent donnerait36,28289,une illustration réduisant tout le coup19,58126. Aucune n’est observée ; cet exemple démontre l’absence de réduction sur le chemin courant, sans choisir la formule native.

Les premiers Q arrivent avec559,08002PV (base/Cape) ou709,08002PV (Rubis). Les essais suivants font évoluer les PV par commandes publiques, sans fixture remplaçant les ressources. Les boucliers,structures,dégâts vrais,limite exacte10%,plusieurs niveaux,mort/respawn et dommages simultanés ne sont pas exercés.

## Consommateurs réels

La recherche Poppy/Valiant dans crates/core/src ne trouve aucune occurrence. La lecture et l’exécution des routes dégâts/mitigation/boucliers/régénération complètent cette recherche ; elles n’affirment pas une absence dans tous les projets. Aucun calcul Poppy dépendant des PV actuels n’est identifié dans le chemin inspecté.

Sept ressources locales sont liées explicitement :catalogue,croissance,ressources,attaques,critiques,collision et boutique. AnnieQ reste identifié dans les1158 fichiers d’entrée pinés du diagnostic. Les boucliers génériques à montant ne sont pas assimilés à la réduction Valiant Fighter.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Poppy spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary HP/MR items,not ValiantFighter |
| crates/core/src/progression.rs:150 | unsupported Poppy learning |
| crates/core/src/progression.rs:159 | unsupported Poppy ranks |
| crates/core/src/spells.rs:101 | unsupported Poppy targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported Poppy ground spell |
| crates/core/src/lib.rs:685 | 18incoming physical6Q and360idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | generic physical/magic damage,no threshold reduction observed |
| crates/core/src/attacks.rs:157 | nine outgoing melee attacks,ordinary damage |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit route |
| crates/core/src/regeneration.rs:32 | ordinary regeneration separated from damage |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | Ruby1028+150HP or Mantle1033+25MR |
| crates/core/src/shop.rs:215 | generic HP/MR bonuses |
| crates/core/src/world.rs:226 | one champion enemy,structure damage excluded by text but unexercised |
| crates/core/src/damage.rs:38 | ordinary resistance mitigation,threshold order unqualified |
| crates/core/src/attacks.rs:26 | melee windup context |
| crates/core/src/critical.rs:12 | ordinary noncritical attacks |
| crates/core/src/shields.rs:12 | generic amount shield,not ValiantFighter reduction |
| crates/core/src/shields.rs:47 | generic shield ordering,not native reduction qualification |
| crates/core/src/ally_occupancy.rs:635 | six preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication et contrôles exécutés

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu :docs/reference_requirement_trace_sources/poppy-passive-valiant-fighter-links-v615.json. Preuve :docs/fidelity_poppy_passive_valiant_fighter_links_v615.json. Les instructions copiables des trois fiches et de SYS-01.2-02 indiquent sources,écarts et limites.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases locales contrôlées :quatre destinataires,42603 autres lignes,42607 états manuels et23 historiques conservés ; synchronisation normale idempotente. Identifiants,hiérarchie et inconnues inchangés octet par octet. Aucun statut,critère,propriétaire ou case clôturé automatiquement.

Revue globale :99137 sources,4414 consommateurs,4414 ancres exactes sans divergence. Contrôle structurel global (source_hashes_verified=0) ; sources sélectionnées et code hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json,completion_plan.json,resume_checkpoint.json,docs/ai/CURRENT.md et HANDOFF.md sont actualisés avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage. Les limites Battle Training,V564 et les deux arrivées V606 restent ouvertes.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision615_Poppy_discovery/OBSERVATIONS.json,revision615_Poppy_passive_probe/OBSERVATIONS.json,revision615_Poppy_inspection/OBSERVATIONS.json,revision615_Poppy/DELIVERY_AUDIT.json et revision616_trace_review/REVIEW.json. Scripts,binaires,versions et commandes exécutées y sont identifiés.

## Travail restant

1. Qualifier formule exacte et ordre de calcul du seuil et de la réduction.
2. Implémenter la réduction dans le chemin de dégâts réellement consommé.
3. Tester juste sous,exactement sur et juste au-dessus du seuil,très faiblesPV et gros coups.
4. Tester résistances négatives,pénétration,autres réductions,boucliers,soins/régénération et variations des PVmax.
5. Tester plusieurs dommages dans le même tick,dégâts périodiques,source absente et dégâts vrais.
6. Vérifier l’exclusion des structures avec des dégâts effectivement produits par celles-ci.
7. Qualifier W/R,immunités,mort/respawn et nettoyage,séparément du passif.
8. Qualifier HUD,particules,animations,audio et réseau.

Les trois fiches restent ouvertes. Aucun serveur historique,rendu,audio ou transport réseau n’est qualifié ici. Le goal reste actif.

Suite : Continuer SYS-01.2-02 depuis revision616_trace_review/REVIEW.json. V615 Poppy / Valiant Fighter : 46 sources natives, 138 associations, 24 points et 48 liens. Texte natif : dégâts physiques/magiques dépassant10% des PV actuels réduits de50%, exclusion des structures. Trois cas publics base/Rubis1028+150PV/Cape1033+25RM : neuf attaques mêlée,18 impacts physiques entrants,six Q Annie,360 ticks d’attente et81 refus atomiques. Sur24 événements entrants,10 dépassent le seuil illustratif après mitigation et14 restent dessous ; tous infligent seulement les dégâts génériques. Réduction du passif non observée ; formule excédent/coup entier et ordre résistances/boucliers/régénération non qualifiés. Aucun sort Poppy accepté. 19 Lua dont quatre limites NEWTABLE,14 preloads,huit liens BuffData résolus dont un renvoie à VayneCondemn. CharScripts natif et communautaire vides ;17 références communautaires. Champs hérités Jax/mana/Passive1=9/niveaux3-7-11-15 non adoptés. Le texte WIP omet l’exclusion des structures ; cinq candidats absents ne prouvent pas un manque global d’assets. Q communautaire fait décroître le pourcentage dePV et ne qualifie ni attaque renforcée,AD ni plafond ; E applique un stun sans collision au mur ; W/R délèguent des buffs sans qualification complète. Six trajets réussis ; V564/V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT : 0 ; 72+4 refus de publication. Prochain passif à inspecter réellement : Quinn. Goal actif.
