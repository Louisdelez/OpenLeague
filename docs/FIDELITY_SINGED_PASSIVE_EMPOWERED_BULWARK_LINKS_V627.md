# Singed — sources et consommateurs d’Empowered Bulwark, V627

Date UTC : 2026-10-26T17:08:54.249708+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45, fuseau et déploiement non établis.

## Résultat

Les trois fiches CH-Singed-PASSIF-SOURCE, CH-Singed-PASSIF-SIMULATION-CONTRAT et CH-Singed-PASSIF-SIMULATION sont reliées à32 sources natives par96 associations, ainsi qu’à26 points de code actuels par52 liens pour les deux fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ; statuts, critères, questions, dépendances, cases et preuves antérieures conservés.

Le texte natif décrit25PV pour100mana. Les essais montrent que le Saphir augmente le mana de200 sans augmenter les PV, avant comme après remplissage de la jauge. Le Rubis augmente correctement les PV de150. Le moteur courant ne démontre donc pas le bonus du passif dans ces profils. L’assiette exacte du calcul historique, les arrondis et les transitions restent à qualifier.

## Sources natives

**Lacune détectée après publication de V627, avant clôture du rapport :** le fichier distinct `DATA/Spells/Empowered Bulwark.inibin` existe, avec un espace. Le filtre initial ne l’avait pas sélectionné. Il résout `game_buff_tooltip_Empowered_Bulwark`, texte contenant f2 PV pour f3 mana et l’affichage du bonus f1. Les32sources et la liaison BuffData unique ci-dessous décrivent le périmètre réellement publié de V627, pas un inventaire complet. L’addendum suivant doit ajouter cette source aux trois fiches, conserver les variables non résolues et ne pas réécrire la preuve initiale.

32 fichiers :9INIBIN,14Lua,8preloads et fontconfig_en_GB.txt. Identités, SHA et appartenance RADS vérifiées ; une liaison BuffData résolue pour MegaAdhesiveSnare. Les sorts sont dans DATA/Spells ; CharScriptSinged est sous Characters/Singed/Scripts. Aucun doublon de basename ou NightmareBot sélectionné. Les ressources TT_SpiderbossSingedOrder/Chaos ne sont pas incluses dans ce périmètre du passif.

Singed.inibin contient les bases PV542.7600098, mana290.6000061, croissance82PV et45mana. PARType, Passive1 et ses six niveaux sont absents ; la ressource Mana du moteur local reste son contrat explicite, sans prétendre lire ce champ absent dans INIBIN. Passive1Desc décrit des PV pour le mana ; PassLev1Desc1 pointe vers le texte25pour100. Le vieux PassLev1Desc2 annonce une réduction magique10% : il reste distinct et n’est pas adopté comme règle du passif.

Passive1LuaName vaut « Empowered Bulwark ». EmpoweredBulwark.luaobj possède le même BuffName avec espace et le preload emploie empoweredbulwark. Les identités sont reliées sans prétendre exécuter la normalisation ou sélection du loader. Le Lua expose ChemicalMan_EmpoweredBulwark.dds, PersistsThroughDeath et NonDispellable ; ces métadonnées ne calculent pas les PV.

Les14Lua sont entièrement parcourus, sans sous-fonctions. InsanityPotion, MegaAdhesive et PoisonTrail rencontrent NEWTABLE ; ces trois limites du lecteur littéral restent explicites. Les11 autres initialisations ne constituent pas une exécution serveur. CharScriptSinged est vide. SingedEFlashLock expose Haste et une icône de hâte : cela ne qualifie ni Flash ni son verrou. Les métadonnées Rooted/Slow et les preloads Fling/root/flingdebuff sont conservés comme contexte, sans preuve de déplacement ni de sélection de zone.

Les chemins Singed.ddf et Singed.en_gb.ddf ne sont pas présents dans le dossier inspecté ; aucun DDF n’a été sélectionné. Les cinq candidats absents sont enregistrés, dont EmpoweredBulwark.inibin et les mauvais emplacements de scripts. Aucune absence globale ou corruption d’assets n’en est déduite.

QWER natifs sélectionnés : PoisonTrail, MegaAdhesive, Fling, InsanityPotion. Les textes décrivent un Q basculable avec coût par seconde, une zone W ralentissante et une immobilisation si E y projette la cible, un jet E derrière Singed, et un R augmentant AP, armure, RM, vitesse et régénérations. Ce contexte ne qualifie pas l’ensemble des sorts dans cette tâche de traçabilité du passif.

| Ressource | Identité du registre |
|---|---|
| Singed.inibin | OLS-2235ba6a-bf6e-5b1d-83bc-2b42d8269d07 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptSinged.luaobj | OLS-8fe4db45-803e-574a-b32d-fd3a3b91d204 |
| CharScriptSinged.preload | OLS-0d468644-c910-52ea-bc6d-256c4c0cfedb |
| EmpoweredBulwark.luaobj | OLS-38ef5ac2-dd39-5c99-9b4f-02e41f60605a |
| Fling.inibin | OLS-320c804b-8a7d-55ac-b23f-f12c528b7bb3 |
| Fling.luaobj | OLS-2aabd6a6-df4a-5e31-8152-d433fcaf95d1 |
| Fling.preload | OLS-152635c7-2659-562f-bd93-999cb36cecf3 |
| FlingDebuff.luaobj | OLS-6f54b700-d912-5871-b6b2-8c1f3e2ea570 |
| InsanityPotion.inibin | OLS-da824711-d5c7-5953-af86-2094ee8b0412 |
| InsanityPotion.luaobj | OLS-ef62e615-4daf-5c61-8ebc-4ba2125e6b7f |
| InsanityPotion.preload | OLS-a50da891-e74c-51f2-ab7c-c58948381920 |
| MegaAdhesive.inibin | OLS-457536a4-e8a1-59ec-9d17-31df85413dc5 |
| MegaAdhesive.luaobj | OLS-984dfebc-9d71-5831-9ee2-50f7c1bb0bf8 |
| MegaAdhesive.preload | OLS-4358b202-96ed-57d1-b86e-544869fd9dd6 |
| MegaAdhesiveApplicator.luaobj | OLS-42d0b3ec-607e-5af8-be62-91a576250510 |
| MegaAdhesiveApplicator.preload | OLS-1c263119-3ea0-5f65-a8f0-b155708b63b9 |
| MegaAdhesiveSnare.inibin | OLS-84794837-0649-5c56-8c3b-4ab0652b12db |
| MegaAdhesiveSnare.luaobj | OLS-8e048567-0695-5d9f-b74e-68ed8518bb2c |
| MegaAdhesiveSnare.preload | OLS-be056523-aab0-51af-8b62-85220c1c31e3 |
| MegaAdhesiveTarget.luaobj | OLS-d170c27c-33e6-5a96-82c5-300ff2876456 |
| PoisonTrail.inibin | OLS-143c3183-dd39-507f-86a9-2ee3c79a56b4 |
| PoisonTrail.luaobj | OLS-9eb6aafb-7be9-5a5c-9195-3bd481efc128 |
| PoisonTrail.preload | OLS-39921bed-3051-56bb-9022-7a36642597fc |
| PoisonTrailApplicator.luaobj | OLS-d77e2110-160a-536a-b701-6fa4ff965f5a |
| PoisonTrailApplicator.preload | OLS-3113aade-d11e-57c3-b548-5a1d05905876 |
| PoisonTrailMarker.luaobj | OLS-765c5a44-3fcd-5a6f-a9d1-adc7f7b8ba37 |
| PoisonTrailTarget.luaobj | OLS-1e428467-d20b-56b7-a7f9-68f737dd9bf8 |
| SingedBasicAttack.inibin | OLS-f9ba5bcf-9afd-583e-8e02-7969f253dbeb |
| SingedBasicAttack2.inibin | OLS-f25f248b-4723-5e8a-9749-2b792845741a |
| SingedCritAttack.inibin | OLS-951e8b77-ecd7-5338-8413-928db18eb092 |
| SingedEFlashLock.luaobj | OLS-f856ab51-dfc2-586f-82fd-8d23675eba1c |

## Références communautaires

14 fichiers identifiés séparément. CharScriptSinged.cs est vide. Les scripts sont lus, sans exécution comme serveur original :

- Q programme cinq impulsions autour du porteur, rayon160, avec un buff5s. Il ne démontre pas une traînée persistante, le toggle et la consommation continue native.
- W programme cinq applications de Slow1s dans une zone300. Le code inspecté n’utilise pas le rang ; l’intensité native, le maintien après sortie et le root conditionnel restent non qualifiés. Le commentaire « grounds » n’est pas une preuve.
- E ajoute6% des PVmax de la cible et un Airborne0.5s. Il ne démontre pas le déplacement derrière le porteur ni l’immobilisation dans la zone W. Le supplément6% n’est pas indiqué par le texte natif sélectionné ; son éventuelle provenance doit être qualifiée séparément.
- R ajoute directement armure, RM, AD et AP pendant25s, avec formule35/50/65 au rang1–3. Son commentaire35/50/80 est divergent du code. L’AD supplémentaire n’est pas annoncé dans le texte natif sélectionné. La délégation au buff ne prouve pas à elle seule vitesse et régénérations.

## Diagnostic : résultats attendus et observés

BUILD=0, RUN=0. Collecteur initial=1 ; relecture corrigée de la même exécution=0, inspection=0. Aucun second build ou lancement n’a remplacé le premier résultat. Cœur Rust hors configuration test, offline/locked, dépendances alignées sur Cargo.lock ;1158 entrées source et preuves antérieures contrôlées.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-singed-passive-empowered_bulwark-probe.exe`, 6093824 octets, SHA256 `3df7aa3c4b60261180b36d1f8331e2be7f37dbec7f78b22635c12a0cad572438`.

Trois profils niveau1 contre Annie : base, Rubis1028+150PV, Saphir1027+200mana. Achats/ventes/rachats publics et six déplacements Move/Stop sans réémission. Aucune injection de position, vie, mana, rang ou statistiques. Chaque profil effectue deux séries de trois attaques séparées par181ticks : total18impacts,543ticks de repos et81refus atomiques. Acteur inconnu, autoattaque de soi, slot invalide, apprentissage et lancements QWER sont refusés avec snapshots inchangés.

| Profil | PVmax | Mana / plafond à la fin | Dégâts d’attaque | Refus |
|---|---:|---:|---:|---:|
| base | 542.76001 | 290.60001/290.60001 | 52.27310 | 27 |
| Ruby150HP | 692.76001 | 290.60001/290.60001 | 52.27310 | 27 |
| Sapphire200Mana | 542.76001 | 490.60001/490.60001 | 52.27310 | 27 |

Attendu textuel : le mana contribue aux PV. Observé : base542.76PV, Rubis692.76PV et Saphir542.76PV. Le plafondmana passe290.6→490.6 avec Saphir ; la vie maximale reste identique lors de l’achat, de la vente, du rachat et après remplissage du mana. Un supplément50PV pour200mana serait la lecture proportionnelle illustrative du texte25pour100, mais l’assiette, l’ordre et les arrondis ne sont pas déclarés qualifiés à partir de cette seule phrase.

Les réserves courantes sont conservées et bornées lors des achats : le Rubis ne soigne pas instantanément ; le Saphir ne remplit pas instantanément les200points ajoutés. Le code refresh_item_caps applique cette politique locale explicitement, dont la fidélité historique reste distincte. Durant le trajet, le mana atteint son plafond avant la période de repos. Tous les181ticks d’attente par profil sont au plafond ; le contrôle n’exerce donc pas une régénération sous plafond durant cette attente.

Le collecteur initial échoue précisément parce qu’il exigeait une jauge encore incomplète au repos. La relecture OBSERVATIONS_REVIEW.json conserve les BUILD/RUN réussis, le script initial et l’assertion erronée documentée ; elle vérifie l’état réellement observé au lieu de fabriquer une dépense de mana. Les affirmations de régénération sous plafond restent exclues. Aucun sort Singed n’est accepté pour consommer du mana ; Q, R et l’interaction E/W ne sont pas exécutés.

AD62.3199997, impacts physiques ordinaires52.2731018 dans les trois profils. La cadence, les dégâts, la régénération de la cible et la mitigation sont contrôlés. La recherche Singed/EmpoweredBulwark dans crates/core/src ne trouve aucun chemin dédié ; stats calcule les PV à partir de la base, de la croissance et des objets de vie. Les26ancres sont des consommateurs génériques et frontières de refus, pas une implémentation du passif. Sept ressources locales sont liées : champions, croissance, ressources, attaques, critiques, collisions et boutique.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Singed health,mana,items,attack or spell-refusal boundary |
| crates/core/src/shop.rs:294 | public sale restores item caps,not passive conversion |
| crates/core/src/shop.rs:314 | preserves/clamps current pools,does not add mana-derived health |

## Publication et conservation

PREPARE/CHECK/PUBLISH/AUDIT : code0.72 associations et4 graphes invalides refusés. Graphe99185sources/4728consommateurs ;4728ancres exactes revues sans divergence. La validation globale est structurelle ; elle ne re-hache pas toutes les sources, contrairement aux vérifications séparées des entrées sélectionnées.

Deux bases SQLite : quatre destinataires actualisés,42603 autres lignes,42607 états manuels et23 historiques conservés ; synchronisation Store idempotente. Trois fragments de traçabilité changent,42212 restent identiques. Trois questions propres et quatre dépendances préservées. Identités, hiérarchie et inconnues inchangées octet pour octet.

Fichiers : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, reference_requirement_trace_sources/singed-passive-empowered_bulwark-links-v627.json, fidelity_singed_passive_empowered_bulwark_links_v627.json et ce rapport. Couverture, plan, reprise, CURRENT et HANDOFF mis à jour avec sauvegardes. Scripts, journaux, échec initial et observations sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision627_Singed et fichiers revision627_singed associés.

## Travail restant et limites

Qualifier la source et le consommateur du calcul mana→PV : assiette, fractions, niveaux, bonus, cumul, ordre et recalculs. Implémenter ensuite le passif avec tests achats/ventes, mana actuel incomplet/plein, changement de plafond, PV pleins/blessés, clamp et éventuelle conservation proportionnelle selon la règle native établie. Ne pas confondre une hausse de PVmax avec un soin.

Tester niveaux, buffs, soins/dégâts, mort/réapparition et reconnexion. HUD, effets, sons, animations et réseau demandent leurs propres preuves. Aucun serveur historique ou rendu exécuté. Les divergences communautaires et V564/V606 restent ouvertes. Ni Singed, ni le jeu, ni SYS-01.2-02 ne sont déclarés terminés.

Suite : Continuer SYS-01.2-02 depuis revision628_trace_review/REVIEW.json. V627 Singed / Empowered Bulwark :32 sources natives,96 associations,26 points et52 liens. Texte natif :25PV pour100mana ;base mana290,6/PV542,76. Assiette exacte,arrondis et lifecycle non qualifiés ;ancien texte réduction magique10% non adopté. Passive1LuaName avec espace,EmpoweredBulwark.luaobj avec BuffName correspondant ;résolution du loader non exécutée. 14Lua dont3 limites NEWTABLE,8preloads,1BuffData résolu,CharScripts vides,DDF absent du périmètre local inspecté. 14références communautaires :Q5impulsions non toggle,W Slow générique sans rang/root qualifiés,E ajoute6%PV et Airborne sans jet derrière ni root démontrés,R ajoute AD et calcule35/50/65 contrairement au commentaire35/50/80. Trois cas base/Rubis/Saphir :18attaques ordinaires52,27310,81 refus,543ticks,six trajets. Rubis augmente PV542,76→692,76 ;Saphir augmente mana290,6→490,6 sans hausse des PV,avant et après remplissage. BUILD/RUN0 ;collecteur initial1 car il supposait encore du mana manquant au repos. Relecture de la même exécution0,échec conservé,jauge déjà pleine au repos :régénération sous plafond non exercée pendant cette attente. Aucun sort Singed accepté ;aucun gameplay modifié,statuts et inconnues conservés. Correction de périmètre détectée après publication :Empowered Bulwark.inibin avec espace est présent,mais omis du filtre initial. Son tooltip f2PV/f3mana et affichage f1 doivent être reliés dans un addendum avant de passer à Sion. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochaine action :addendum Singed pour le fichier avec espace,avant Sion. Goal actif.
