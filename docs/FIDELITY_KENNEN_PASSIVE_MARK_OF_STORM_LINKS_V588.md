# Kennen — sources et consommateurs du passif, V588

Date UTC : 2026-10-26T05:09:52.615347+00:00. Projet `F:/OpenLeague`. **SYS-01.2-02** : relier les exigences aux sources natives et aux consommateurs actuels.

## Résultat

Trois fiches Kennen enrichies avec **32 sources natives, 96 associations, 28 points du moteur et 56 liens** contrat/simulation. Quatre sources de preuves ajoutées. Trois inconnues propres, quatre dépendances, statuts et critères conservés.

**Les sorts de Kennen restent refusés : aucun déclenchement natif de marque n’a pu être exercé.** Douze attaques ordinaires avec W non appris, une réserve d’énergie au plafond et un étourdissement fourni par Annie ne valident pas Mark of the Storm. Ce lot rend ces limites vérifiables et accessibles dans les consignes du plan ; aucun gameplay n’est modifié.

## Sources et contrat

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau et déploiement inconnus ; catalogue 4.20.1 distinct. Identités des sources et appartenance aux projets RADS sélectionnés vérifiées. Cette appartenance ne prouve pas la priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| Kennen.inibin | OLS-6506ceb1-0fca-5dfb-865c-b12937941312 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptKennen.luaobj | OLS-7d7d2ace-94af-5d4a-b7d8-91ca23b35130 |
| CharScriptKennen.preload | OLS-6974ec64-6c8b-5620-a8e3-dae880bbb03d |
| KennenMarkOfStorm.inibin | OLS-1a51a161-62ac-5860-96e6-86339c7452b8 |
| KennenMarkofStorm.luaobj | OLS-a2682e21-3a03-53cb-9780-6fe781fc0c99 |
| KennenMarkofStorm.preload | OLS-4d1d06b5-fd49-5464-944b-1f2ed0146ae9 |
| KennenMoSDiminish.inibin | OLS-ae78a94a-9ded-5504-ae8c-aa9160145f89 |
| KennenMoSDiminish.luaobj | OLS-d7b5f385-c37f-56ff-9aa6-b330d6a32038 |
| KennenMegaProc.inibin | OLS-39b0b2d3-8a72-5332-8360-5676672e6ba1 |
| KennenMegaProc.luaobj | OLS-5992d82d-ca0c-5727-a83f-e5807a35761b |
| KennenMegaProc.preload | OLS-c3cbe8d7-6e69-5382-8897-1affdbc16f6a |
| KennenBringTheLight.inibin | OLS-1abb828b-5376-5e18-821e-82ab58f4150b |
| KennenBringTheLight.luaobj | OLS-a2c6c449-6ea1-5842-8052-071a68136612 |
| KennenBringTheLight.preload | OLS-2c9e2121-e91e-5012-93c0-103ecbee4465 |
| KennenDoubleStrikeIndicator.inibin | OLS-c04a289b-16c7-5392-8eff-5972bf055d5e |
| KennenDoubleStrikeIndicator.luaobj | OLS-698f1d26-f6d0-59f9-accf-ae2b1befae84 |
| KennenDoubleStrikeLive.inibin | OLS-28aa79a0-2dd2-5f8c-a11f-c09c8ec87980 |
| KennenDoubleStrikeLive.luaobj | OLS-a83db019-fd32-5ed2-bb3c-67b3f37a94c0 |
| KennenDoubleStrikeLive.preload | OLS-7ead5b79-19c4-576f-bb87-11291016db54 |
| KennenDoubleStrikeProc.inibin | OLS-da899522-5912-503a-927c-e35c97fbdf94 |
| KennenDoubleStrikeProc.luaobj | OLS-34256265-2707-544d-bee8-50e9d3b9f6c3 |
| KennenDoubleStrikeProc.preload | OLS-333640a3-162b-5e9b-831f-ac5d2a0492c8 |
| KennenShurikenHurlMissile1.inibin | OLS-55255848-5a34-5902-a22c-964fbc14d696 |
| KennenShurikenHurlMissile1.luaobj | OLS-6acf0e2e-9dbb-5184-a2b8-d25c55c80185 |
| KennenShurikenHurlMissile1.preload | OLS-16ee02a6-e7e8-521c-bc65-8769320ccd16 |
| KennenLightningRush.inibin | OLS-ccbc70df-cd54-56fb-af80-52f57d0b1919 |
| KennenLightningRush.luaobj | OLS-c5cb72bc-3328-5ee7-912b-80a448e75069 |
| KennenLightningRush.preload | OLS-8af35f48-27f7-5c99-87c2-c21a5cb3f5c9 |
| KennenShurikenStorm.inibin | OLS-4fb241eb-c0bf-5339-a2bf-1d1a2651ad30 |
| KennenShurikenStorm.luaobj | OLS-d9dc0681-e7b7-5f0f-9f65-40258e98814d |
| KennenShurikenStorm.preload | OLS-67bb1325-28ba-5588-a523-10cfb1373863 |

- `Kennen.inibin` : `PARType=Energy`, `BaseMP=200`, `Passive1LuaName=KennenMarkOfStorm.lua`, icône `Kennen_MarkOfStorm.dds`. Les champs absents restent absents. Le suffixe `.lua` est conservé ; le fichier source ainsi nommé est absent au chemin global recherché, tandis que le `.luaobj` compilé existe. Aucune résolution runtime d’alias n’est déduite de ce constat.
- Description en_GB liée, ligne 4215 : marques durant **6,25 secondes**, étourdissement de **1 seconde à trois marques**, gain de **25 énergie**, effet diminué si un nouvel étourdissement survient dans les **sept secondes**. Le montant réduit, l’ordre des effets et la politique de renouvellement ne sont pas établis par ce seul texte.
- Sept liaisons de buffs résolues : MarkOfStorm, MoSDiminish, DoubleStrikeIndicator/Live/Proc, LightningRush et ShurikenStorm. Le buff MarkOfStorm décrit le seuil de trois marques ; MoSDiminish décrit une réduction de l’étourdissement répété sans en donner ici le coefficient.
- W `KennenBringTheLight`, tooltip lié ligne 11643 : attaque renforcée **toutes les cinq attaques** avec dégâts magiques et une marque. Ce compteur de W est distinct des trois marques du passif. Les attaques de notre diagnostic ont W non appris : elles ne qualifient pas ce déclencheur.
- L’ancien `Passive1Desc` mentionne des dégâts lors du déclenchement à trois marques. Cette description est conservée séparément ; elle ne permet pas d’ajouter arbitrairement des dégâts au contrat localisé.
- Onze Lua lus intégralement, zéro prototype enfant, onze initialisations littérales. Le CharScript natif contient seulement une métadonnée d’icône `Teemo_EagleEye.dds`, sans logique de marque. Le Lua MarkOfStorm porte le nom et l’icône attendus du buff. Les flags de sorts et `SpellToggleSlot=3` de LightningRush restent des métadonnées ; ce 3 n’est pas automatiquement interprété comme le slot Rust de R.
- Neuf preloads lus : dépendances vers marque, diminution, compteurs W et effets. Le preload MegaProc cite MarkOfStorm ; le nom MegaProc ne prouve pas des dégâts supplémentaires. Q, W et R citent la marque, E ses sous-effets. Les dépendances déclarées ne démontrent ni callbacks serveur ni rendu.
- Cinq chemins candidats absents : preloads MoSDiminish et DoubleStrikeIndicator, DDF de Kennen, source globale MarkOfStorm.lua et inibin du passif sous le répertoire de sorts du personnage. Les ressources globales compilées présentes restent reconnues. Aucune absence générale d’assets ni corruption n’est déduite.
- Seize références communautaires versionnées séparément : CharScript, QWER, statistiques et dix JSON associés. Le CharScript communautaire est vide ; les autres sources ne deviennent pas une preuve de code serveur historique.

## Exécution réelle

Diagnostic privé compilé contre le vrai `crates/core/src/lib.rs` non-test avec `cargo build --locked --offline`. BUILD et RUN **0**. Dépendances et checksums alignés sur le lock racine. **1 158 entrées** de code/ressources et la chaîne de preuves antérieures vérifiées ; anciens échecs conservés.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-kennen-passive-mark-of-storm-probe.exe` — 6081024 octets — SHA-256 `ef3ef2b20a4254095280d718f6ca1516c463d0e1a20a28807894451f3df094af`.

Deux parties Map10 neuves : Kennen attaque Annie après déplacements publics. Le second cas achète publiquement le Cristal de saphir 1027, coût 400 or, bonus local +200 mana. Ni positions, ni santé, ni niveau, ni temps, ni événements de dégâts/étourdissement ne sont injectés.

| Cas | Impacts physiques | Refus | Énergie maximale | Régénération déclarée/s | Ticks finaux |
|---|---:|---:|---:|---:|---:|
| base | 6 | 15 | 200 | 10 | 180 |
| Sapphire_energy_control | 6 | 15 | 200 | 10 | 180 |

Les **12 impacts physiques** disposent chacun d’un projectile source/cible non critique identifiable avant l’impact. Les dégâts suivent la mitigation physique ordinaire avec tolérance 0,002, en tenant compte de la régénération. Aucun étourdissement sur la cible. Kennen reste niveau 1, rangs et délais nuls, énergie 200 au plafond ; le bonus de mana ne change pas cette réserve. Le taux courant de régénération est 10/s, mais aucune récupération depuis un déficit n’est exercée.

**30 refus inchangés** dans ces deux cas : joueur inconnu, attaque sur soi, slot invalide, apprentissage et lancement QWER ciblés/au sol. **360 ticks après les attaques** n’ajoutent que la régénération de la cible. Attaques sans W appris et énergie pleine ne permettent de conclure ni sur le gain de 25 énergie ni sur la logique de marques.

### Contrôle distinct de l’étourdissement générique

Une troisième partie neuve place Annie face à Kennen. Annie apprend Q puis lance cinq Q publics successifs, avec **424 ticks d’attente de délai** au total. Les cinq impacts disposent chacun d’un projectile témoin et respectent les dégâts magiques ordinaires avec régénération, tolérance 0,002. Les quatre premiers chargent Pyromania ; le cinquième consomme les charges et étourdit Kennen.

- Tag **Pyromania**, source Annie, durée courante **38 ticks** au niveau 1 (arrondi local de 1,25 seconde).
- Cinq refus de Q pendant son délai, puis trois refus de Kennen pendant l’étourdissement : déplacement, attaque et lancement. États inchangés.
- Position immobile et contrôle actif jusqu’à la frontière d’expiration ; retrait exact à l’expiration observée. Déplacement public accepté et mouvement observé juste après.
- Kennen reste à 200 énergie ; aucun remboursement hors plafond n’est exercé.

Ce contrôle vérifie que la chaîne générique d’étourdissement fonctionne. **Les 38 ticks d’Annie ne sont pas la seconde annoncée pour Kennen** ; aucune diminution sur répétition ni marque Kennen n’est validée. Total du lot : **38 refus publics sans mutation**, 12 impacts physiques, cinq impacts magiques et un étourdissement générique.

Attendu du diagnostic : commandes ordinaires possibles, sorts Kennen refusés, absence de transformation mana→énergie et contrôle Annie séparé ; observé conforme. Attendu de qualification MarkOfStorm : producteurs de marques, seuil, étourdissement, diminution et gain d’énergie sur événement valide ; **non atteint**.

## Consommateurs et limites de leurs rôles

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_dispatch_and_refusals |
| crates/core/src/progression.rs:68 | Energy_cap_excludes_item_mana |
| crates/core/src/progression.rs:150 | Kennen_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_Kennen_rank |
| crates/core/src/spells.rs:101 | Kennen_cast_refusal |
| crates/core/src/annie_w.rs:29 | Kennen_ground_cast_refusal |
| crates/core/src/lib.rs:685 | tick_order_and_regeneration |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | ordinary_damage_and_Annie_control |
| crates/core/src/attacks.rs:157 | ranged_projectile_witness_not_mark_trigger |
| crates/core/src/lifesteal.rs:4 | ordinary_melee_hits |
| crates/core/src/regeneration.rs:32 | regeneration_during_public_wait |
| crates/core/src/shop.rs:261 | Sapphire_public_purchase |
| crates/core/src/shop.rs:215 | Sapphire200mana_not_energy |
| crates/core/src/lifecycle.rs:33 | static_context_not_respawn_acceptance |
| crates/core/src/attacks.rs:103 | static_context_not_departure_acceptance |
| crates/core/src/annie.rs:45 | public_magic_control |
| crates/core/src/annie.rs:73 | Q_projectile_damage_witness |
| crates/core/src/regeneration.rs:10 | base10energy_per_second_not_refund |
| crates/core/src/lifecycle.rs:16 | mana_item_exclusion_for_energy |
| crates/core/src/lifecycle.rs:24 | Energy_regeneration_context |
| crates/core/src/stuns.rs:6 | Annie_stun_expiry_control |
| crates/core/src/stuns.rs:15 | Annie_calls_generic_stun_not_Kennen_marks |
| crates/core/src/stuns.rs:37 | Annie_stun_cleanup |
| crates/core/src/annie_passive.rs:9 | fourAnniecharges_then_fifthQ_stun |
| crates/core/src/annie_passive.rs:20 | Annie_tagged_stun_not_MarkOfStorm |
| crates/core/src/annie_passive.rs:3 | Annielevel1_38ticks_not_Kennen1second |

Les 28 points sont des fonctions d’entrée ou de soutien réellement présentes. Aucun n’est marqué comme implémentation complète du passif. Les lecteurs de sources restent distincts de la simulation. Départ et réapparition sont des points statiques, non des tests du cycle de vie du passif.

Neuf ressources locales associées séparément : champions, croissance, ressources, attaques, critiques, collision, boutique, règles de Q Annie et règles de lancement sous contrôle. Profils Kennen/Annie sélectionnés lorsque pertinent. Ces données locales ne prouvent pas les règles du serveur historique.

## Travail restant

1. Déterminer les producteurs de marques et leurs conditions : Q, W appris/actif, attaques renforcées, E, R, cibles valides, refus et effets simultanés.
2. Qualifier trois marques, consommation/renouvellement global ou individuel, changement de cible, propriétaires multiples et durée de 6,25 secondes ; définir l’arrondi local sans le présenter comme natif.
3. Établir le coefficient et le renouvellement de la diminution sous sept secondes, puis tester tenacité, contrôles répétés, immunités et ordre des effets.
4. Implémenter les sorts nécessaires et qualifier gain de 25 énergie après dépense réelle, plafond, événements multiples et distinction entre énergie, mana et régénération.
5. Résoudre les rôles du nom `.lua`, des ressources compilées, de l’ancienne description de dégâts et des métadonnées ; conserver les absences ciblées et les prérequis ouverts.
6. Mort/réapparition, déconnexion, fin de partie, nettoyage des marques, puis HUD/compteurs, icônes, animations, VFX, audio et réseau.

Aucun serveur historique, rendu GPU ou transport réseau exécuté par ce diagnostic. Aucun manque de modèle/texture déduit des sorts refusés. BattleTraining, les autres champions et le défaut de déplacement V564 restent distincts et ouverts.

## Livraison et conservation

Inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels **0**. 72 associations invalides et quatre graphes invalides refusés. Trois fragments de consignes actualisés ; 42 212 inchangés.

Deux bases : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente. Registres d’identités, hiérarchie et inconnues inchangés octet pour octet. Trois inconnues propres et quatre dépendances conservées avec leurs propriétaires.

Graphe : **99 029 sources, 3 728 consommateurs**, 42 215 exigences ; revue globale : **3 728 ancres exactes, zéro divergence courante**. 26 189 inconnues ouvertes et 5 517 précédemment résolues restent inchangées. Le hachage des sources sélectionnées est distinct du contrôle structurel du graphe.

Fichiers modifiés : registres `completion_tasks_2026-10-20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_sources_4_20.json` ; reçu `reference_requirement_trace_sources/kennen-passive-mark_of_storm-links-v588.json` ; preuve `fidelity_kennen_passive_mark_of_storm_links_v588.json` ; ce rapport, couverture/plan/reprise, CURRENT/HANDOFF, reçu privé et données/consignes des deux bases. Aucun gameplay, asset, statut de fin ou case manuelle modifié.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision588_Kennen_discovery`, `revision588_Kennen_passive_probe`, `revision588_Kennen_inspection_verified`, `revision588_Kennen` et `revision589_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision589_trace_review/REVIEW.json. Kennen V588 publié/audité :32sources natives,96associations,28points/56liens. Deuxcas base/Saphir12attaques ordinaires30refus360tailticks;Wnonappris,sortsrefusés,énergie200plafonnée,taux10/s. Aucun déclenchement de marque ni remboursement hors plafond exercé. Contrôle distinct Annie5Q8refus38ticksPyromania424attenteticks,déplacement admis après expiration. Native6,25secondes3marques1seconde25énergie,diminution sous7secondes;ordre/renouvellement/coefficient ouverts. OnzeLua littéraux,7buffs9preloads,16communautaires,CharScript vide;5chemins candidats absents dontDDF/.lua,compilé présent. Ancienne description dégâts,Teemoicône,SpellToggleSlot3 nonadoptés. BUILD/RUN/inspection/prepare/check/publish/audit0. Préserver échecs KatarinaV586,KassadinV585,stockageV582,déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple Khazix. Goal actif;aucun statut/case/inconnu fermé.
