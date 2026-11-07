# Kayle — sources et consommateurs du passif, V587

Date UTC : 2026-10-26T04:55:27.599650+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02**, liens entre exigences, sources natives et consommateurs actuels.

## Résultat

Trois fiches Kayle reliées à 15 sources natives, 45 associations, 22 points du moteur et 44 liens contrat/simulation. Quatre sources de preuves ajoutées. Trois questions propres et quatre dépendances conservées, avec leurs propriétaires.

**La réduction d’armure et de résistance magique de Holy Fervor n’est pas observée dans les scénarios exécutés.** Les attaques successives conservent les résistances et les dégâts ordinaires. Les sorts de Kayle sont refusés. Ce lot documente et relie l’écart ; il n’implémente ni n’accepte le passif.

## Sources consultées

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. Identités SHA-256 et appartenance RADS vérifiées ; appartenance ne signifie pas priorité de montage prouvée.

| Fichier | Source enregistrée |
|---|---|
| Kayle.inibin | OLS-b14cf3c7-ba7f-5895-8390-483e6198884d |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Kayle.ddf | OLS-61e2d336-ca7e-5ac0-a28b-8139c530f997 |
| CharScriptKayle.luaobj | OLS-5953a1fd-3932-5047-b507-389e5e9e7990 |
| CharScriptKayle.preload | OLS-0ed772a1-72b3-5da1-a86f-ff0c92f05d10 |
| JudicatorHolyFervor.inibin | OLS-68ef15eb-3d18-5ad9-a528-89606ea57134 |
| JudicatorHolyFervor.luaobj | OLS-a8f8abe4-859f-52f7-8544-85eebd550eb6 |
| JudicatorHolyFervorDebuff.inibin | OLS-ac0466ba-4b02-5ebe-8d71-1033dfe6ca28 |
| JudicatorHolyFervorDebuff.luaobj | OLS-f6592386-9f64-5f81-bfa0-391a11c4b66d |
| JudicatorReckoning.inibin | OLS-3a2a37eb-b810-55a3-9571-ab621df92c40 |
| JudicatorReckoning.luaobj | OLS-d240be90-0a7c-546f-b2c8-e2731572f088 |
| JudicatorReckoning.preload | OLS-e593dc69-2fb2-5b65-9f3d-2cf81ac55cfd |
| JudicatorRighteousFury.inibin | OLS-da071716-657b-5ee7-9004-8586daef001e |
| JudicatorRighteousFury.luaobj | OLS-888046d7-0c80-5f98-aecc-0dab678b0ca9 |
| JudicatorRighteousFury.preload | OLS-03d49197-19e2-5a38-bede-b31047354112 |

- `Kayle.inibin` : `Passive1LuaName=JudicatorHolyFervor`, icône `Kayle_Passive.dds`. La description liée en_GB, ligne 4214, et le buff HolyFervor ligne 2121 indiquent **3 % de réduction d’armure et de RM sur un champion attaqué, pendant cinq secondes, jusqu’à cinq cumuls**. Ces textes n’établissent pas seuls tous les détails de composition et de renouvellement.
- Quatre liaisons de buffs résolues : HolyFervor, HolyFervorDebuff, Reckoning et RighteousFury. Le debuff décrit des résistances réduites ; Q décrit un ralentissement ; E décrit portée augmentée et dégâts de zone.
- L’ancien `Passive1Desc` parle d’une aura de vitesse d’attaque. `PassLev1Desc2/3/4` parlent de régénération de mana. Ces champs sont conservés séparément et ne remplacent pas la description liée. Les six champs Passive1Level absents ne deviennent pas des zéros.
- Cinq Lua intégralement lus structurellement, aucun prototype enfant. Trois initialisations littérales : CharScript vide, buff HolyFervor et debuff. Le buff porte l’icône `Judicator_DivineBlessing.dds`, le debuff `Kayle_Passive.dds` : rôles distincts, sans remplacement automatique. Persistance et non-dissipation sont des métadonnées.
- Deux limites du lecteur littéral : `NEWTABLE` au pc14 pour Reckoning et pc18 pour RighteousFury. Ce sont des limites d’interprétation du lecteur ; aucun fichier corrompu n’en est déduit. Aucun callback serveur historique exécuté.
- Trois preloads lus. Celui de Q cite `judicatorholyfervordebuff`, sans prouver à lui seul le déclenchement ou l’ordre des effets. Celui de E contient des effets **skin07**, un halo et une animation : aucune validation de présentation du skin de base.
- DDF : huit lignes concernant Q/E, aucune formule de HolyFervor. Le coefficient bonus AD de Reckoning et les coefficients AD de Fury ne sont pas des réductions de résistances.
- Trois chemins candidats absents : preloads globaux HolyFervor/HolyFervorDebuff et inibin du passif sous les sorts du personnage. Les fichiers globaux du passif sont présents ; cette recherche ciblée ne démontre pas une absence universelle d’assets.
- Dix références communautaires séparées, avec identités/version de snapshot : CharScript, QWER, statistiques et quatre JSON associés. Le CharScript est une classe vide ; ce n’est pas une implémentation du passif.

## Essais exécutés

Compilation privée du vrai core non-test : `cargo build --locked --offline`, BUILD et RUN **0**. Identité des dépendances alignée au lock racine. 1 158 entrées de code/ressources et les preuves antérieures vérifiées, dont le BUILD initial échoué puis le diagnostic corrigé de Katarina V586. Les anciens échecs restent conservés.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-kayle-passive-holy-fervor-probe.exe` ; 6059520 octets ; SHA-256 `5fb07c28ffd802f24856ea915cd548535b59e8a1c480f265c50a6f7a164e8cba`.

Deux parties Map10 neuves. Kayle attaque Ahri ; Annie, alliée de Kayle, sert de témoin magique. Déplacements, achats, apprentissage Annie Q, attaques et arrêts passent par les commandes publiques. Aucun ajout direct de dégâts, position, santé, niveau ou temps.

| Cas | Armure cible | RM cible | Impacts mêlée | Impacts magiques | Refus |
|---|---:|---:|---:|---:|---:|
| base_target | 20.88000 | 30.0 | 7 | 2 | 17 |
| defended_target | 35.88000 | 55.0 | 7 | 2 | 17 |

La cible défendue achète Cloth1029 (+15 armure, 300 or) et Cloak1033 (+25 RM, 500 or). Chaque cas comporte six attaques Kayle successives, un Q d’Annie, une attente jusqu’à 181 ticks après la sixième attaque, puis une septième attaque Kayle et un second Q d’Annie. Tous restent vivants et niveau 1.

- **14 impacts physiques** : cible du windup vérifiée, `release` égal au tick d’impact, non critiques ; dégâts conformes à `raw × 100 / (100 + armor)` avec tolérance 0,002.
- **Quatre impacts Annie Q** : projectile source/cible identifié, dégâts bruts 80, mitigation ordinaire selon RM. Régénération au tick de l’impact explicitement prise en compte ; tolérance 0,002.
- Armure et RM inchangées à chaque tick. Après la sixième attaque, le premier Q frappe à +14 ticks. L’attente seule dure **167 ticks par cas**, soit 334 au total ; elle est distincte des **180 ticks finaux par cas**, soit 360 au total. Les points +149/+150/+151/+181 sont inspectés. Ces observations ne prouvent pas l’expiration d’un debuff qui n’est pas présent.
- **34 refus sans mutation** : joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt de Kayle et Q d’Annie pendant son délai. Q/E Kayle ne sont pas acceptés.

Attendu du contrôle actuel : statistiques inchangées et dégâts ordinaires, témoins attribuables, refus inchangés ; **observé conforme**. Attendu du passif natif : réduction des résistances après les attaques sur champion ; **écart observé**. Le plafond de cinq cumuls, la composition, le renouvellement et l’ordre précis restent non qualifiés.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_dispatch_and_refusals |
| crates/core/src/progression.rs:68 | base_item_Trundle_defense_no_HolyFervor |
| crates/core/src/progression.rs:150 | Kayle_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_Kayle_rank |
| crates/core/src/spells.rs:101 | Kayle_cast_refusal |
| crates/core/src/annie_w.rs:29 | Kayle_ground_cast_refusal |
| crates/core/src/lib.rs:685 | tick_order_and_regeneration |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | ordinary_damage_uses_target_defenses |
| crates/core/src/attacks.rs:157 | melee_windup_release_witness |
| crates/core/src/lifesteal.rs:4 | ordinary_melee_hits |
| crates/core/src/regeneration.rs:32 | regeneration_during_public_wait |
| crates/core/src/shop.rs:261 | Cloth_and_Cloak_public_purchase |
| crates/core/src/shop.rs:215 | 15armor_and25MR |
| crates/core/src/lifecycle.rs:33 | static_context_not_respawn_acceptance |
| crates/core/src/attacks.rs:103 | static_context_not_departure_acceptance |
| crates/core/src/damage.rs:38 | ordinary_resistance_formula |
| crates/core/src/penetration.rs:4 | penetration_distinct_from_reduction |
| crates/core/src/penetration.rs:9 | current_item_penetration |
| crates/core/src/annie.rs:45 | public_magic_control |
| crates/core/src/annie.rs:73 | Q_projectile_damage_witness |

Les fonctions de statistiques, mitigation, pénétration et attaques correspondent aux observations. Les défenses existantes, notamment l’ajustement Trundle, ne sont pas HolyFervor. Annie Q fournit uniquement le contrôle magique. Départ/réapparition restent des points statiques, sans validation du cycle de vie du passif.

Sept ressources locales associées séparément : champions, croissance, ressources, attaques, critiques, collision et boutique. Les profils Kayle/Ahri/Annie sont sélectionnés lorsque pertinent. Ces données locales ne deviennent pas des règles serveur natives par leur association.

## Travail restant et limites

1. Établir composition des cumuls, renouvellement global ou individuel, ordre d’application, résistances base/bonus et traitement des résistances nulles/négatives.
2. Implémenter la réduction par cible et qualifier les attaques 1 à 6, le plafond, les cibles multiples, les attaques annulées, les changements de cible et les frontières temporelles.
3. Qualifier les interactions avec pénétration et autres réductions, dégâts physiques/magiques et sources alliées. Le contrôle présent ne tranche pas toutes ces combinaisons.
4. Implémenter/qualifier Q/E pour exercer les déclenchements concernés, attaques à distance, cible principale et splash. La dépendance preload ne suffit pas à définir ces règles.
5. Mort, réapparition, déconnexion, fin de partie, nettoyage des effets et interactions avec contrôles.
6. HUD/debuff, compteur, textures/icônes, VFX, audio, rendu et synchronisation réseau : validation distincte après intégration.

Aucun serveur historique, rendu GPU ou transport réseau exécuté dans ce diagnostic. Aucun manque de modèle ou texture déduit de l’absence de réduction des résistances. BattleTraining et le défaut de déplacement V564 restent des sujets distincts ouverts.

## Livraison vérifiée

Inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels 0. 72 associations volontairement invalides et quatre graphes invalides refusés. Trois fragments de consignes actualisés, 42 212 inchangés.

Deux bases : quatre destinataires mis à jour, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés** ; synchronisation normale idempotente. Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées.

Graphe : **99 025 sources, 3 700 consommateurs**, 42 215 exigences. Revue globale : 3 700 ancres exactes, zéro divergence courante. 26 189 inconnues ouvertes et 5 517 précédemment résolues, sans changement ici. Contrôle structurel et hachage des sources sélectionnées restent distincts.

Fichiers : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/kayle-passive-holy_fervor-links-v587.json`, `docs/fidelity_kayle_passive_holy_fervor_links_v587.json`, ce rapport, couverture/plan/reprise, CURRENT/HANDOFF, reçu privé et données/consignes des deux bases. Aucune coche ou acceptation automatique, aucun gameplay ou asset modifié.

Preuves : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision587_Kayle_discovery`, `revision587_Kayle_passive_probe`, `revision587_Kayle_inspection_verified`, `revision587_Kayle` ; revue `revision588_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision588_trace_review/REVIEW.json. Kayle V587 publié/audité :15 sources natives,45 associations,22 points/44 liens. Deux cas publics14impacts mêlée4magiques34refus360tailticks334attenteticks : armure/RM et mitigation ordinaires inchangées avec/sans Cloth+Cloak. Texte lié3%5secondes5cumuls ; Q/E refusés, composition/renouvellement/ordre non qualifiés. Cinq Lua lus,3littéraux2limites NEWTABLE,4buffs3preloads,DDF8sans formule passive,10communautaires dont CharScript vide. Trois chemins candidats absents,anciennes descriptions aura/mana et skin07 non adoptés. BUILD/RUN/inspection/prepare/check/publish/audit0. Préserver échecBUILD KatarinaV586,CHECK KassadinV585,stockageV582,déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple Kennen. Goal actif;aucun statut/case/inconnu fermé.
