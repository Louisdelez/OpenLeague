# Shyvana — sources et consommateurs de Dragonborn, V626

Date UTC : 2026-10-26T16:50:16.835373+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45, fuseau et déploiement non établis.

## Résultat et portée

Les trois fiches CH-Shyvana-PASSIF-SOURCE, CH-Shyvana-PASSIF-SIMULATION-CONTRAT et CH-Shyvana-PASSIF-SIMULATION reçoivent66 sources natives,198 associations,24 points de code et48 liens pour les deux fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Les statuts, critères, questions, dépendances, cases et preuves antérieures sont préservés. Aucun gameplay modifié.

Le texte natif décrit un bonus f1 d’armure et de résistance magique, doublé en dragon. Le diagnostic actuel retrouve uniquement les défenses de base et les objets dans les profils testés. Aucun sort Shyvana n’est accepté ; la forme dragon et son doublement ne sont donc pas exercés. La Furie reste au plafond100 : son éventuel gain est non qualifié par ces essais.

## Sources et limites natives

66 fichiers :26INIBIN,23Lua,15preloads,Shyvana.ddf et fontconfig_en_GB.txt. Identités, SHA et appartenance RADS vérifiées ;8 liaisons BuffData résolvent chacune un texte. Aucun NightmareBot ou doublon de basename sélectionné. Les sorts sont dans DATA/Spells et le CharScript sous Characters/Shyvana/Scripts. Une première recherche dans Characters/Shyvana/Spells a échoué : ce rangement différent ne constitue pas une absence d’assets. Quatre chemins candidats absents restent consignés avec leurs alternatives réelles.

Shyvana.inibin définit PARType=Dragonfury, BaseMP=100, BaseStaticMPRegen=0, armure27.6280002594 et RM32.0999984741. Passive1LuaName=ShyvanaPassive, icôneShyvanaReinforcedScales.dds. Passive1 et ses six champs de niveau sont absents ; PARStart/PARMax également. La vieille description Master Yi et les textes de régénération mana40/60/80% ne sont pas adoptés comme règles de Shyvana.

ShyvanaPassive.inibin résout Dragonborn : bonus f1 aux deux défenses, doublé en dragon. La description du personnage confirme le principe, sans chiffrer le bonus. Le producteur f1 et sa progression n’ont pas été résolus dans ce périmètre. Aucune valeur supposée n’a été introduite. ShyvanaDragonScales parle d’une hausse temporaire ; son nom, son ordre et son éventuelle relation avec Dragonborn ne sont pas considérés comme équivalents automatiquement.

ShyvanaPassive.luaobj expose notamment PersistsThroughDeath, NonDispellable et IsDamagingSpell=false. Les23Lua sont entièrement parcourus, sans sous-fonctions ;9 initialisations rencontrent NEWTABLE et restent explicitement limitées. Les14 autres initialisations littérales ne sont pas une exécution serveur. CharScriptShyvana et TransformCheck ont des globals vides. TransformLeap cite JarvanIVCataclysm ; TransformDamage porte le nom Move. Ces métadonnées étrangères ne permettent pas d’importer la politique de Jarvan, le vol ou le déplacement effectif de Shyvana.

Le preload du personnage référence shyvanapassive, shyvanadragonscales et apbonusdamagetotowers. Les noms de ressources et effets restent des dépendances de présentation, sans preuve de rendu ou de déclenchement.

Shyvana.ddf possède8lignes, dont deux liaisons non vides : W bonusattackdamage×0.2 ; Q attackdamage×0.8/0.85/0.9/0.95/1.0. Elles ne renseignent pas le f1 de Dragonborn. Les mêmes noms f1 dans des sorts différents ne sont pas interchangeables.

Le sort R sélectionné est ShyvanaTransformCast. Son tooltip distingue coût de Furie par seconde, seuil d’activation, génération Effect3 toutes les1.5secondes et Effect2 par attaque. Aux rangs1–3, les champs INIBIN relevés valent respectivement Effect4=5, Effect5=100, Effect3=1/2/3 et Effect2=2. Ce sont des valeurs source disponibles, pas des résultats d’une transformation exécutée. Les valeurs résiduelles de rang4–5 ne sont pas adoptées comme des rangs accessibles. La description parle de génération par seconde : cette divergence de texte reste visible, sans choix arbitraire. ShyvanaTransform décrit le maintien de la forme grâce à la Furie et le doublement de Dragonborn. Un compteur initial100 ne prouve pas une forme dragon active. Fréquence, génération, consommation, entrée/sortie de forme et doublement effectifs restent à qualifier.

Les textes de E restent distincts : FireballDragon annonce4s ; le tooltip FireballDragon2 annonce5s, onhit2% des PVmax de la cible et plafond100 contre monstres ; sa description annonce une réduction d’armure4s. La variante active E est ShyvanaFireball. Ces fragments de contexte ne prouvent pas la sélection effective de la variante dragon ni la fidélité de l’ensemble du sort.

| Ressource | Identité du registre |
|---|---|
| Shyvana.inibin | OLS-35f2b61c-e492-5909-910d-330571f2033e |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Shyvana.ddf | OLS-1c179d4d-6b23-53e0-9558-89f2a16270cc |
| CharScriptShyvana.luaobj | OLS-bc7c090f-1354-55ed-b1e3-2daa864ca341 |
| CharScriptShyvana.preload | OLS-257924e9-e063-597e-93a0-7b4faf2f9b68 |
| ShyvanaBasicAttack.inibin | OLS-66fdc295-4d7f-52a5-9e7c-10d45df16db3 |
| ShyvanaBasicAttack2.inibin | OLS-c0a2adb6-28aa-5414-9aa6-70fdb6e6cffc |
| ShyvanaBasicAttack3.inibin | OLS-9f1be7e6-4328-502d-a909-3a56b753d912 |
| ShyvanaCritAttack.inibin | OLS-675c7d34-1137-5967-953d-761786abaa04 |
| ShyvanaDoubleAttack.inibin | OLS-fc2de444-f279-5bc5-bc4b-b94b0a0c98fc |
| ShyvanaDoubleAttack.luaobj | OLS-7cd59e69-8341-5848-8a09-7ae5ad2140e6 |
| ShyvanaDoubleAttackDragon.inibin | OLS-62c46a42-c069-51ad-a59f-b22e7e29aa53 |
| ShyvanaDoubleAttackDragon.luaobj | OLS-71fa70c1-0a71-5874-9208-e9c63bdf1f85 |
| ShyvanaDoubleAttackDragon.preload | OLS-a4f8130b-ae8c-5303-aafe-a9c63f23c93b |
| ShyvanaDoubleAttackHit.inibin | OLS-4e95ec3c-da55-56f4-b9bc-656ce4f49d0c |
| ShyvanaDoubleAttackHit.luaobj | OLS-1d67c9fd-7c92-5baa-bddf-8f30e7dc6854 |
| ShyvanaDoubleAttackHit.preload | OLS-f44de871-20bb-5fe2-95c0-9bbcd51b2a07 |
| ShyvanaDoubleAttackHitDragon.inibin | OLS-7a912358-fe0c-5f5c-96a1-a97f2959e093 |
| ShyvanaDoubleAttackHitDragon.luaobj | OLS-d35f7471-9dd2-59df-84f9-c49903d67247 |
| ShyvanaDoubleAttackHitDragon.preload | OLS-8e232203-5039-5532-9395-08ec0fcddc58 |
| ShyvanaDragonBasicAttack.inibin | OLS-9f915882-ff07-5cd5-bc7b-af0eb7d34e23 |
| ShyvanaDragonBasicAttack2.inibin | OLS-3eadbd64-1367-554b-944d-70c43b7c09da |
| ShyvanaDragonScales.inibin | OLS-09675d35-346c-52c6-a2ce-98161e62a0e9 |
| ShyvanaDragonScales.luaobj | OLS-ff9688ad-fcf5-56fd-965c-a45a27f545fe |
| ShyvanaFireball.inibin | OLS-a5ab5f70-9b76-5bbb-add4-d775aca6e2b9 |
| ShyvanaFireball.luaobj | OLS-4b480f7e-6cd7-5f21-96c4-7e9216b405dd |
| ShyvanaFireballDragon2.inibin | OLS-d8c7f154-3e15-57b7-9db2-87f76d3eebb6 |
| ShyvanaFireballDragon2.luaobj | OLS-61b09a43-101c-5dfd-8509-5c25d7becf51 |
| ShyvanaFireballDragon2.preload | OLS-9ff36554-c6fb-5384-9e8a-8388d5e003b9 |
| ShyvanaFireballDragonFxMissile.inibin | OLS-2d70dde9-4351-5670-8d20-c6358252ce0f |
| ShyvanaFireballDragonFxMissile.luaobj | OLS-92279416-b080-51c8-bb7f-69634cff7567 |
| ShyvanaFireballDragonFxMissile.preload | OLS-1917a821-5768-5338-a0d6-afd20911b323 |
| ShyvanaFireballMissile.inibin | OLS-1137c36b-2a26-5811-8b29-bd1db2093fa6 |
| ShyvanaFireballMissile.luaobj | OLS-d8e4c5f1-b5d9-5d08-b961-6fa4d2e5192a |
| ShyvanaFireballMissile.preload | OLS-3b2df0a8-5cca-534a-9955-f51f5ecdccda |
| ShyvanaFireballMissileMinion.inibin | OLS-6c4d729c-6699-555c-8930-f6035ca84ece |
| ShyvanaFireballMissileMinion.luaobj | OLS-ed81c129-a2ea-567d-bc53-f24bbb6de86b |
| ShyvanaFireballMissileMinion.preload | OLS-19a7820f-010a-58b8-a73d-46ec55d3bc57 |
| ShyvanaFireballParticle.luaobj | OLS-f8f216d8-ac39-5caf-a9a8-2f57cf6c6677 |
| ShyvanaFlameBreathDebuff.inibin | OLS-cffe3b26-d891-5d99-9e59-530aa772ebd6 |
| ShyvanaIDApplicator.luaobj | OLS-f5095451-5406-57fc-bedc-ee14e17e2796 |
| ShyvanaIDApplicator.preload | OLS-7c144833-d22c-5cd9-90d3-ab4b427456a8 |
| ShyvanaIDDamage.luaobj | OLS-b6b10517-057a-534f-bd20-d10a355f330a |
| ShyvanaImmolateDragon.inibin | OLS-a59281e6-85c0-55c2-98c1-4c047fef8f47 |
| ShyvanaImmolateDragon.luaobj | OLS-b433649a-fbc0-5631-9c96-9082d278a735 |
| ShyvanaImmolateDragon.preload | OLS-886c7e0c-4e40-5dfe-b1b8-b29b84ebcb78 |
| ShyvanaImmolationAura.inibin | OLS-5e004308-0866-5492-9911-23eab436845c |
| ShyvanaImmolationAura.luaobj | OLS-360f925d-8319-5668-b0a4-a62d7ce9db81 |
| ShyvanaImmolationAura.preload | OLS-d124e73c-6112-5ab0-869f-99807024416e |
| ShyvanaPassive.inibin | OLS-3a55ba5a-9aa6-525d-89ce-75dc68adb083 |
| ShyvanaPassive.luaobj | OLS-1f4e61d3-a5c6-55d6-bf5f-26c6cdbfec26 |
| ShyvanaPassive.preload | OLS-fabaf537-8642-5cef-8652-54bbeb2ccce8 |
| ShyvanaScorchedEarth.inibin | OLS-8d5a47cf-9a6a-55f9-bc1a-7998ebe17e2d |
| ShyvanaScorchedEarthDragon.inibin | OLS-faef854a-d128-51b3-b9dd-e9b31d257366 |
| ShyvanaTransform.inibin | OLS-208d6604-c695-5b26-84ea-2f43e8141995 |
| ShyvanaTransform.luaobj | OLS-9cd9b1ed-abdc-5c8c-b4f1-894168f606ec |
| ShyvanaTransform.preload | OLS-1fae6d64-64a0-5738-9c5f-78c3ccaccbab |
| ShyvanaTransformCast.inibin | OLS-ff388bae-2333-5d2c-b127-e71b8bd81b17 |
| ShyvanaTransformCast.luaobj | OLS-cd4c086c-e4f8-5a5b-8640-1947a2a9a241 |
| ShyvanaTransformCheck.luaobj | OLS-ea722cf7-d964-5b8f-b80b-9d78c14583cb |
| ShyvanaTransformDamage.luaobj | OLS-bdb04123-ac63-5d90-b3ff-cde393518b5d |
| ShyvanaTransformDamage.preload | OLS-dcc585f0-6e94-526d-93a4-898f6425839d |
| ShyvanaTransformDeath.luaobj | OLS-1a7104a4-2907-5be2-8600-c1e186f0920b |
| ShyvanaTransformLeap.inibin | OLS-6cf0b6f8-f7d0-5f78-9bb1-592ac1f7e50d |
| ShyvanaTransformLeap.luaobj | OLS-3d4ebeb9-e52b-59fa-bf50-ef3c077c947b |
| ShyvanaTransformLeap.preload | OLS-404efcd7-9e8f-5f56-924e-077384d6b8d3 |

## Références communautaires

31 fichiers conservés avec leur provenance propre, distincte du serveur original et du Rust courant. CharScriptShyvana.cs est vide. Lecture statique des quatre scripts, sans leur attribuer une exécution historique :

- Q applique immédiatement au postcast20/30/40/50/60% de l’AD au rang1–5. Il ne démontre pas deux impacts de la prochaine attaque, la réduction du délai Q ni le cône dragon.
- W programme trois impacts et délègue un buff3s. Il utilise20%AP, alors que la liaison native DDF utilise20%bonusAD. Le mouvement, son déclin, l’extension par attaque et la traînée dragon ne sont pas qualifiés par ce fichier.
- E sélectionne un cône avec produit scalaire0.94, rayon925 ; il réduit la RM de15% pendant4s. Cela ne démontre pas le projectile traversant, la marque5s ou les dégâts onhit2%PVmax décrits par le texte natif.
- R est une classe ShyvanaTransform, distincte du nom natif sélectionné ShyvanaTransformCast. Il délègue un buff20s et inflige des dégâts dans une zone300 autour du point cible avec Airborne0.5s. Aucun vol effectif, repoussement vers la destination, cycle de Furie ou doublement des défenses n’est démontré dans ce fichier. La délégation au buff ne prouve pas à elle seule toutes ces fonctions.

Ces écarts ne sont pas masqués par les commentaires des scripts. Les ressources communautaires sont des pistes, pas un remplacement automatique des règles natives.

## Diagnostic réel : attendu et observé

BUILD=0, RUN=0, collecte=0, inspection=0. Cœur Rust hors configuration test, compilation offline/locked ; dépendances alignées sur Cargo.lock.1158 entrées source et preuves antérieures vérifiées. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-shyvana-passive-dragonborn-probe.exe`, 6138368 octets, SHA256 `b46a557caf849823e397fb743765a70eb5e004913c84a1fc179a75da1733bf7a`.

Trois profils publics niveau1 contre Annie : base, Armure d’étoffe1029+15armure, Manteau1033+25RM. Achats, ventes et rachats réels ; six déplacements Move/Stop sans réémission. Aucune injection de position, vie, ressource, rang, forme ou statistique.

Par profil :3attaques de Shyvana,3impacts physiques d’Annie,1QAnnie,181ticks au repos et27refus atomiques. Total9attaques,9impacts physiques reçus,3Q,543ticks de repos,81refus. Ceux-ci couvrent acteur inconnu, autoattaque de soi, slot invalide, apprentissage et lancements QWER avant/après ; snapshots inchangés après refus.

| Profil | Armure | RM | Dégâts physiques reçus | Q magique reçu | Refus |
|---|---:|---:|---:|---:|---:|
| base | 27.62800 | 32.10000 | 39.49762 | 60.56019 | 27 |
| Cloth15Armor | 42.62800 | 32.10000 | 35.34369 | 60.56019 | 27 |
| Mantle25MR | 27.62800 | 57.10000 | 39.49762 | 50.92299 | 27 |

Attendu selon le texte : Dragonborn apporte un bonus aux défenses en plus de leur base, et double ce bonus en forme dragon. Valeur f1 non résolue : aucune cible numérique inventée. Observé : armure27.628 et RM32.1 en base, exactement les champs natifs ; seuls les objets ajoutent15armure ou25RM. Aucun bonus Dragonborn supplémentaire observé. Les dégâts reçus suivent la mitigation générique physique/magique, avec contrôle de la régénération et tolérance0.002. Les attaques sortantes restent50.9243469 pour AD60.7120018 dans les trois profils.

Les statistiques restent stables pendant181ticks de repos par profil. La ressource reste100/100 ; aucun gain sous le plafond n’est testé et aucune absence de génération n’est déduite. Tous rangs et délais QWER restent0 ; les refus explicites sont préservés. Ni R, ni la forme dragon, ni sa sortie, ni la mort/réapparition ne sont exercés.

La recherche Shyvana/Dragonborn/Dragonfury dans crates/core/src ne trouve aucun chemin dédié. La fonction stats inspectée combine bases, croissance, objets et autres effets explicites ; elle ne contient pas de bonus Dragonborn. Les24ancres représentent des frontières actuelles de statistiques, dégâts, ressources, déplacement et refus, pas une implémentation du passif. Sept ressources locales sont liées : champions, croissance, ressources, attaques, critiques, collisions et boutique.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Shyvana base/item defenses,damage,Dragonfury or spell-refusal boundary |

## Intégration et conservation

PREPARE/CHECK/PUBLISH/AUDIT : code0.72 associations invalides et4 graphes invalides refusés : fausse acceptation, source manquante, binaire modifié, question étrangère, dépendance retirée et autres limites. Graphe99181sources/4702consommateurs ; revue globale de4702ancres exactes sans divergence. Le contrôle structurel global ne re-hache pas toutes les sources ; les entrées sélectionnées sont vérifiées séparément.

Deux bases SQLite : quatre destinataires actualisés,42603 autres lignes conservées,42607 états manuels et23 historiques identiques ; synchronisation Store idempotente. Trois fragments de traçabilité changent,42212 restent identiques. Trois questions propres et quatre dépendances conservées. Registres des identités, hiérarchie et inconnues inchangés octet pour octet.

Fichiers livrés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, reçu reference_requirement_trace_sources/shyvana-passive-dragonborn-links-v626.json, preuve fidelity_shyvana_passive_dragonborn_links_v626.json et ce rapport. Couverture, plan de complétion, reprise, CURRENT et HANDOFF actualisés avec sauvegardes. Scripts, journaux et diagnostics privés conservés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision626_Shyvana et fichiers revision626_shyvana associés. Les preuves et erreurs des révisions antérieures sont conservées.

## Travail restant

Retrouver f1 et sa progression ; déterminer le consommateur historique effectif et l’ordre avec les défenses de base, objets et effets. Implémenter le bonus propre et son doublement en forme réelle, puis vérifier niveaux, changements d’objets, pénétration, réductions, valeurs négatives, arrondis et transition de forme. Qualifier la Furie sous plafond, son seuil, les gains, sa consommation, les resets et le lien avec R. Résoudre la sélection des textes concurrents sans utiliser le DDF Q/W pour combler le passif.

Tester mort/réapparition, départ/reconnexion et synchronisation. Qualifier séparément HUD, VFX, sons, animations et réseau. Aucun serveur historique ni rendu exécuté. Les écarts communautaires et V564/V606 restent ouverts. Cette livraison de traçabilité ne termine ni Shyvana, ni le jeu, ni SYS-01.2-02.

Suite : Continuer SYS-01.2-02 depuis revision627_trace_review/REVIEW.json. V626 Shyvana / Dragonborn :66 sources natives,198 associations,24 points et48 liens. Le texte décrit un bonus f1 en armure et résistance magique,doublé en dragon ;valeur,progression et producteur non résolus. Dragonfury100,regen0 ;ancien texte Master Yi et mana40/60/80% non adoptés. 23Lua dont9 limites NEWTABLE,15preloads,8BuffData résolus,CharScripts vides ;DDF8lignes et2liaisons Q/W,non f1 du passif. DragonScales temporaire,Transform et métadonnées JarvanIV distincts. R :tooltip Furie toutes les1,5s versus description par seconde ;FireballDragon4s,Dragon2tooltip5s/onhit2%PVmax et description4s/armure restent distincts. 31références communautaires :Q dégâts immédiats20–60%AD,W20%AP au lieu de bonusAD,E réductionRM15%4s au lieu du onhit natif,R buff20s/zone300 sans vol ni double défense prouvés. Trois cas publics base/Armure15/Résistance25 :9attaques,9impacts physiques reçus,3QAnnie,81 refus,543ticks au repos,six trajets. Défenses égales à la base native27,628/32,1 plus objets ;aucun bonus Dragonborn supplémentaire observé. Furie100/100 :gain non testable au plafond ;aucun sort Shyvana accepté,forme dragon non exercée. BUILD/RUN/inspection0 ;acquis,questions,états du plan et V564/V606 conservés,aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Singed. Goal actif.
