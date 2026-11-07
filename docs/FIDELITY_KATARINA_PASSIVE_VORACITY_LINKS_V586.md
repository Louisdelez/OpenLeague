# Katarina — sources et consommateurs du passif, V586

Date UTC : 2026-10-26T04:39:42.719947+00:00. Projet `F:/OpenLeague`. **SYS-01.2-02** : relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches Katarina reliées à **12 sources natives**, **36 associations**, **22 points du moteur** et **44 liens** contrat/simulation. Quatre sources de preuves ajoutées. Trois questions propres, quatre dépendances, statuts et critères conservés.

Les commandes publiques permettent deux éliminations de Katarina et une assistance. Ses sorts restent refusés et ses délais restent nuls : **aucun remboursement d’un délai actif n’est exercé**. Deux textes natifs donnent des règles différentes : **15 secondes sur les délais**, ou **10 secondes sur l’ultime et rafraîchissement des sorts de base**. La priorité de ces textes reste ouverte. Ce lot fournit la traçabilité de ces limites, sans implémenter ni accepter le passif.

## Sources natives et contrat non résolu

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue 4.20.1 distinct. Taille/SHA-256 et appartenance aux projets RADS sélectionnés vérifiées ; cette appartenance ne prouve pas la priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| Katarina.inibin | OLS-449afe9f-27f0-5ced-b9a0-c32800e99e13 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Katarina.ddf | OLS-9a56cc3e-e51d-5439-93ed-cef86a6fd872 |
| CharScriptKatarina.luaobj | OLS-6f80775a-5e4d-5a19-bfae-bd6ecd8b4cb7 |
| CharScriptKatarina.preload | OLS-58cc4a69-08ce-511d-853f-f0deb52fc48e |
| KatarinaPassive.inibin | OLS-136b64f9-c8b3-53e6-8b1c-3037bdc0a360 |
| KatarinaPassive.luaobj | OLS-1cd7ad69-fbb3-5135-adba-3f060f293df3 |
| KatarinaPassive.preload | OLS-61aeae2c-69aa-5b1c-a179-0f2a146422b4 |
| KatarinaQ.inibin | OLS-e19b9b8c-9900-58e0-80e5-da6374cbafd8 |
| KatarinaW.inibin | OLS-013585ca-5d67-56b1-a1e6-ee6631380740 |
| KatarinaE.inibin | OLS-549dd3d9-57ff-5306-b511-ed156f9b8ef0 |
| KatarinaR.inibin | OLS-a8fe8133-bd98-578d-87ed-b896e5fffefd |

- `Katarina.inibin` porte `Passive1LuaName=Voracity`, icône `Katarina_Voracity.dds`, Q/W/E/R `KatarinaQ/W/E/R`. La description liée en_GB ligne 4213 annonce une réduction des délais de **15 secondes** après une élimination ou assistance.
- `KatarinaPassive.inibin` lie `game_buff_tooltip_Voracity`, ligne 2922 : **10 secondes de réduction de Death Lotus et rafraîchissement des capacités de base**. La liaison directe existe, mais ne résout pas sa contradiction avec la description du personnage.
- Le nom `Voracity` du personnage, la dépendance `katarinapassive` du CharScript et le `BuffName=KatarinaPassive` du Lua restent explicitement distincts. Les chemins globaux `Voracity.inibin/.luaobj` et le chemin personnage `Spells/KatarinaPassive.inibin` sont absents dans la recherche ciblée. Le fichier global KatarinaPassive est présent : aucune substitution silencieuse ni conclusion d’absence universelle.
- Les champs `SpellData.DynamicTooltip` et `Description` du passif pointent vers les deux clés **MaliceAndSpite**, absentes du fontconfig sélectionné. Ils ne remplacent pas la liaison BuffData Voracity.
- Deux Lua lus entièrement, zéro prototype enfant, deux initialisations littérales qualifiées. CharScript vide ; buff avec icône Voracity, persistance après mort et non-dissipation. Les flags de ciblage, de déclenchement de sorts et de furtivité restent des métadonnées, sans callback serveur exécuté.
- Deux preloads déclarent KatarinaPassive et `katarina_spell_refresh_indicator.troy`. La déclaration ne démontre pas un effet visible ni une modification des délais.
- DDF : **28 lignes**, aucun identifiant/formule passive. Il conserve notamment `DeathLotus;f1` lié au bonus AD avec coefficient 5 et `KatarinaR;f1` avec coefficient 3. Ces coefficients de sorts distincts ne sont pas des remboursements de délai.
- Délais natifs Q : 10/9,5/9/8,5/8 ; W : 4 à chaque rang normal ; E : 12/10,5/9/7,5/6 ; R : 90/60/45. Ils décrivent le contexte de lancement, pas la règle du passif. Valeurs supplémentaires de rang 6 et zéros de R hors rang normal conservés sans adoption automatique. Champs de niveau passif et coûts inspectés absents ne sont pas remplacés par des valeurs inventées.
- Sept références communautaires séparées : CharScript, QWER, statistiques et JSON du passif. Le CharScript communautaire est vide ; aucun de ces éléments n’est assimilé au serveur historique.

## Diagnostic exécuté

Compilation privée `cargo build --locked --offline` du vrai `crates/core/src/lib.rs` non-test. Dépendances/checksums alignés au lock racine. **1 158 entrées de code/ressources** et la chaîne antérieure sont vérifiées, y compris le CHECK initial refusé puis la livraison corrigée de Kassadin V585 et les preuves de stockage V582.

Le premier BUILD retourne **101** : le script utilisait `Windup.releases`, alors que le champ réel s’appelle `release`. Script, source, journal et reçu initiaux sont conservés. Une version distincte corrige uniquement ce nom dans le témoin et sa vérification ; BUILD et RUN qualifiés retournent **0**. Aucun code de moteur n’est corrigé par ce changement de diagnostic.

Exécutable qualifié `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-katarina-passive-voracity-probe-qualified.exe` — 6284800 octets — SHA-256 `60bc0f173d205ffe555dc7f21a19beb3a63f21ac591cea92249da055b164658f`.

Quatre parties Map10 neuves, déplacements publics séquentiels vers le centre. Katarina attaque Annie ; pour les scénarios d’assistance, elle s’arrête sous 170 HP de la cible puis Garen, son allié, termine l’élimination. Le scénario expiré attend 451 ticks supplémentaires avant l’attaque de Garen. Dans le second scénario d’élimination, Katarina achète publiquement le Codex 3108 donnant 10 % de réduction des délais. Aucune injection de position, vie, niveau, délai, temps ou événement direct de dégâts.

| Cas | Impacts témoins | Refus | Kills Katarina | Assists Katarina | Délai depuis sa contribution, ticks | Or de crédit Katarina |
|---|---:|---:|---:|---:|---:|---:|
| kill_codexfalse | 11 | 28 | 1 | 0 | 0 | 400.000 |
| kill_codextrue | 11 | 28 | 1 | 0 | 0 | 400.000 |
| assist_codexfalse | 11 | 28 | 0 | 1 | 113 | 86.875 |
| expired_assist_codexfalse | 12 | 28 | 0 | 0 | 612 | 0.000 |

Les **45 impacts de mêlée** ont chacun un windup source/cible témoin non critique, avec `release` égal au tick de la baisse de santé. Les ticks sans impact respectent la régénération attendue. Chaque scénario produit un seul événement de mort ordinaire ; aucun impact non attribué n’est compté comme preuve.

- Deux kills directs de Katarina, chacun première élimination à 400 or dans sa partie neuve.
- Une assistance récente, créditée 113 ticks après sa dernière contribution ; part d’or observée 86,875 selon la fonction générique locale au tick de l’événement.
- Une contribution expirée, 612 ticks avant la mort après 451 ticks d’attente supplémentaire ; pas d’assistance ni d’or de crédit pour Katarina.
- Le mécanisme générique actuel admet les contributions dans une fenêtre de **450 ticks**. Ce seuil local n’est pas qualifié comme fenêtre propre au passif. Son équivalent de 15 secondes ne doit pas être confondu avec les 15 secondes de réduction annoncées par un texte natif.
- L’or ambiant du tick de mort est séparé du crédit d’élimination/assistance dans la comparaison.

**112 refus sans mutation** : joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt de QWER avant et après le crédit, attaque de la cible morte. **720 ticks après les crédits**, plus les 451 ticks d’attente du scénario expiré, sont observés. Les rangs et délais de Katarina restent `[0,0,0,0]` ; le Codex n’arme aucun délai puisque les sorts sont refusés.

Attendu du diagnostic actuel : crédits publics ordinaires, assistance récente admise/ancienne exclue, refus inchangés ; observé conforme. Attendu de qualification du passif : résolution du contrat natif puis remboursement d’un délai réel ; **non atteint**. Des délais nuls ne démontrent pas un remboursement de 10 ou 15 secondes, ni un rafraîchissement des capacités de base.

## Consommateurs actuels

| Source et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_dispatch_and_refusals |
| crates/core/src/progression.rs:68 | Codex_CDR_not_Voracity |
| crates/core/src/progression.rs:150 | Katarina_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_Katarina_rank |
| crates/core/src/spells.rs:101 | Katarina_cast_refusal |
| crates/core/src/annie_w.rs:29 | Katarina_ground_cast_refusal |
| crates/core/src/lib.rs:685 | tick_order_credit_and_regeneration |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | lethal_damage_calls_credit |
| crates/core/src/champion_kills.rs:26 | public_melee_contribution_window |
| crates/core/src/champion_kills.rs:32 | ordinary_kill_assist_no_Voracity_refund |
| crates/core/src/champion_kills.rs:19 | assist_gold_not_passive_reward |
| crates/core/src/cooldown.rs:11 | static_creation_policy_not_refund |
| crates/core/src/attacks.rs:157 | melee_windup_release_witness |
| crates/core/src/lifesteal.rs:4 | ordinary_melee_hits |
| crates/core/src/regeneration.rs:32 | regeneration_during_public_wait |
| crates/core/src/shop.rs:261 | Codex_public_purchase |
| crates/core/src/shop.rs:215 | Codex10percentCDR30AP |
| crates/core/src/passive_gold.rs:16 | ambient_gold_separated_from_credit |
| crates/core/src/lifecycle.rs:33 | static_context_not_respawn_acceptance |
| crates/core/src/attacks.rs:103 | static_context_not_departure_acceptance |

Le pipeline de contribution et récompense fournit les kills/assists observés. Les frontières d’apprentissage/lancement refusent Katarina. La fonction générique de création des délais reste du contexte statique : ce lot ne l’exerce pas avec un sort Katarina accepté. Les fonctions de réapparition et départ sont également statiques ici, sans acceptation du cycle de vie du passif.

Dix ressources locales liées séparément : champions, croissance, ressources, attaques, critiques, collision, shop, crédits de mort, or ambiant et règles de réduction des délais. Les profils Katarina/Annie/Garen sont sélectionnés lorsque pertinent. Ces contrats locaux ne deviennent pas des règles natives par leur association.

## Travail restant

1. Résoudre sur preuves la divergence 15 secondes versus 10 secondes sur R avec rafraîchissement de Q/W/E, sans choisir automatiquement la variante la plus facile à tester.
2. Établir le mapping effectif Voracity/KatarinaPassive et le rôle des références MaliceAndSpite absentes ; garder les sources et leurs versions séparées.
3. Implémenter les sorts nécessaires pour armer des délais réels, puis qualifier la réduction/remise à zéro sur éliminations et assistances publiques.
4. Plancher zéro, CDR, rangs, crédits simultanés/en chaîne, expiration au même tick, capacités déjà engagées et canalisation de R.
5. Contributions indirectes, pets, contrôles, assistances et exclusions selon le contrat natif ; le seuil générique local de 450 ticks ne tranche pas ces questions.
6. Mort/réapparition, déconnexion/fin de partie, HUD et compteurs de délai, animations, indicateur de refresh, audio et réseau.

Aucun serveur historique, rendu GPU ou transport réseau exécuté. Aucun manque de modèle ou texture n’est déduit de ces écarts. BattleTraining, les autres champions et le défaut de déplacement V564 restent distincts et ouverts. Les prérequis de phase/lot et leurs statuts restent conservés.

## Livraison et conservation

Inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels 0. BUILD initial 101 conservé ; BUILD/RUN qualifiés 0, journaux et identités pinés.

- 72 associations invalides et quatre graphes invalides refusés.
- Trois fragments de consignes changés, 42 212 inchangés.
- Deux bases : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées avec leurs propriétaires.
- Graphe : **99 021 sources, 3 678 consommateurs**, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues auparavant. Revue globale : **3 678 ancres exactes, zéro divergence courante**. Le contrôle structurel est distinct du hachage des sources sélectionnées.

Fichiers livrés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/katarina-passive-voracity-links-v586.json`, `docs/fidelity_katarina_passive_voracity_links_v586.json`, ce rapport, `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md`, `HANDOFF.md`, reçu privé de reprise et données/consignes des deux bases. Aucune coche ni acceptation automatique ; aucun gameplay ou asset modifié.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision586_Katarina_discovery`, `revision586_Katarina_passive_probe` (BUILD initial refusé), `revision586_Katarina_passive_probe_qualified`, `revision586_Katarina_inspection_verified`, `revision586_Katarina`, et revue `revision587_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision587_trace_review/REVIEW.json. Katarina V586 publié/audité :12sources natives,36associations,22points/44liens. Quatre cas publics45impacts mêlée,112refus720tailticks451attenteticks :2killsKatarina,1assistà113ticks,aucuneà612ticks. Tousrangs/délais0,sortsrefusés,aucun remboursementarmé. Textepersonnage15secondes vsbuff10secondesR+refreshbase nonrésolu;fenêtreassistlocale450ticksdistincte. DeuxLua littéraux,2preloads,1buff,DDF28sansformulepassive,7communautaires;Voracity/KatarinaPassive distincts,3chemins et2clés MaliceAndSpite absents. BUILDinitial101 mauvaischamp releases du diagnostic;qualifiedreleaseBUILD/RUN0,échecconservé. Conserver KassadinV585CHECKinitial1/lotqualified,stockageV582,déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple Kayle. Goal actif;aucun statut/case/inconnu fermé.
