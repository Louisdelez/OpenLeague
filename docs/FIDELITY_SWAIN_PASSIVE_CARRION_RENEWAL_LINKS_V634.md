# Swain — Carrion Renewal, sources et limites V634

Date : 2026-10-26T19:32:36.061913+00:00. Projet `F:/OpenLeague`. Tâche SYS-01.2-02 : relier les exigences aux sources natives et consommateurs actuels. Cette livraison actualise les trois fiches PASSIF-SOURCE, PASSIF-SIMULATION-CONTRAT et PASSIF-SIMULATION de Swain et le suivi général ; elle ne constitue pas une implémentation du passif.

## Résultat

**La restauration de mana après élimination ou assistance sur champion manque dans les deux scénarios publics avec mana déficitaire.** Avec 524 de mana maximal, le texte natif demande 47,16 de restauration. Le moteur ne produit que sa régénération ordinaire. Les témoins au maximum ne permettent pas de distinguer une restauration. La branche concernant les unités ordinaires n’a pas été exercée.

49 fichiers natifs sont associés aux trois exigences, soit 147 associations. 31 points de code sont identifiés, soit 62 liens aux deux fiches de simulation. Ils restent qualifiés comme mécanismes génériques ou limites d’entrée, avec `provides_feature_consumer=false`. Les anciens liens, trois questions propres, quatre dépendances et statuts sont conservés. Aucun code du jeu ni asset modifié.

## Référence et provenance

PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue 4.20.1 distinct. Sources sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

La sélection reprend les liens précédents et contrôle les chemins globaux et propres au champion, tailles/SHA-256 et appartenance aux manifestes sélectionnés. Elle contient 16 INIBIN, 17 Lua, 15 preloads et le fontconfig. CharScriptSwain est sous Characters/Swain/Scripts ; les sorts sont sous DATA/Spells. Aucun DDF parmi les candidats contrôlés : cela ne démontre pas une absence globale de ressources. Aucun NightmareBot retenu.

| Source | Identité |
|---|---|
| Swain.inibin | OLS-7beaf3a7-c16c-580a-9b40-0c8b71e8160a |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptSwain.luaobj | OLS-3c7abc44-b567-5806-ba15-452e110f88a7 |
| CharScriptSwain.preload | OLS-fab87483-f0c1-5fb1-957c-e5cd3597a4a1 |
| Swain_RavenBasicAttack.inibin | OLS-4e554283-6885-579a-a668-2989740e2f6b |
| SwainBasicAttack.inibin | OLS-2a9adfe6-7731-5d97-b047-2afa65cfe76f |
| SwainBasicAttack2.inibin | OLS-40b32d4a-9444-52e7-a9f5-f626884e4240 |
| SwainBeamDamage.inibin | OLS-2529eb55-63a9-5f91-82a1-894f943e248c |
| SwainBeamDamage.luaobj | OLS-3178936e-9cdc-563b-b596-8905f8bb73f9 |
| SwainBeamDamage.preload | OLS-e6f9c37c-fc3a-5989-b629-0f929bc49fc2 |
| SwainBeamDamageMinion.luaobj | OLS-f9de0b20-3bc4-5bc8-8a11-1b0c2e0e39c6 |
| SwainBeamDamageMinion.preload | OLS-562c0361-b9f9-5a24-9920-4858f525b50f |
| SwainBeamDamageMinionNashor.luaobj | OLS-1796aadb-6774-5688-a959-61560c56671a |
| SwainBeamDamageMinionNashor.preload | OLS-633a3f93-f341-52ac-b2d1-f4c14c7dbc38 |
| SwainBeamExpirationTimer.luaobj | OLS-e34fd95e-8d10-5c60-a875-48ffeebcaa78 |
| SwainBeamMinion.inibin | OLS-d83479ce-9800-5ff1-95dc-4e23409f7be1 |
| SwainBeamMinion.luaobj | OLS-1a40511f-f76e-59ac-be39-8f45de8d2d60 |
| SwainBeamMinion.preload | OLS-131b47e6-e643-5e19-b3b3-d79c9021b9bf |
| SwainBeamSelf.luaobj | OLS-75b8daf3-ba14-5f47-8199-ffeb557103f6 |
| SwainBeamTransition.luaobj | OLS-6a4ae06a-0bd2-5664-8548-0d23bca49311 |
| SwainBeamTransition.preload | OLS-64b4c0f1-1ff8-52c1-9cf5-5137ea94ff82 |
| SwainDampeningFieldMana.inibin | OLS-42aa2829-54d5-50f9-9257-72fbd66fb02d |
| SwainDampeningFieldMana.luaobj | OLS-4c7debb4-f037-5283-b4af-d33e382d9609 |
| SwainDampeningFieldMana.preload | OLS-7e9bfbb2-c383-5730-a983-832607d6e11b |
| SwainDecrepify.inibin | OLS-852730cc-0294-573c-877b-e9a018569c96 |
| SwainDecrepify.luaobj | OLS-f9ffae7d-282e-502c-8c56-464794c02243 |
| SwainDecrepify.preload | OLS-66497a90-8007-5721-8949-3dec920b0ed0 |
| SwainMetaHeal.inibin | OLS-04301a20-3928-5ed5-bea9-4868e0c935ec |
| SwainMetaHeal.luaobj | OLS-ff087a9a-c480-5c65-a1a5-2945cda5fcf0 |
| SwainMetaHeal.preload | OLS-7093f956-9aed-547b-910a-ce217fd18111 |
| SwainMetaHealTorment.inibin | OLS-891391d1-4f81-557e-9508-2b03ff227eb3 |
| SwainMetaHealTorment.luaobj | OLS-4817c30f-83d2-5219-9765-30b014f21194 |
| SwainMetaHealTorment.preload | OLS-7fde37fa-cf04-5515-aed0-ddb427183ed6 |
| SwainMetamorphism.inibin | OLS-faf6f854-8762-5557-ba19-e233dc32130d |
| SwainMetamorphism.luaobj | OLS-9260039f-e7ad-532c-92f9-c310963a3761 |
| SwainMetamorphism.preload | OLS-78c30b06-18d0-584e-ba42-828ddd8fc4ab |
| SwainMetaNuke.inibin | OLS-3f4d4771-84d7-57b5-a2e3-78dd52a63ae0 |
| SwainMetaNuke.luaobj | OLS-6019a86b-fa84-56dd-8c3f-c828aabfa13d |
| SwainMetaNuke.preload | OLS-e2dd2ae0-dc70-5bb9-9407-c3c2bacd2dbd |
| SwainShadowGrasp.inibin | OLS-1579faf8-9418-5c78-a66f-b3f18d3bbdb2 |
| SwainShadowGrasp.luaobj | OLS-1195366e-68ce-5d79-b964-0edef0ba1eff |
| SwainShadowGrasp.preload | OLS-fbaeed9c-6fbc-5522-9dbc-b6d024e775c6 |
| SwainShadowGraspRoot.inibin | OLS-6b77da7d-b484-5a06-886c-27b5affc6724 |
| SwainShadowGraspRoot.luaobj | OLS-779ce2dd-3631-5b7b-8e43-e17166a46c3c |
| SwainShadowGraspRoot.preload | OLS-14cff83e-2878-5e4f-b7bd-04d94646c41f |
| SwainTorment.inibin | OLS-e80f310b-f884-5f27-bc2d-fb796ef7f344 |
| SwainTorment.luaobj | OLS-a5ec8a72-a453-5970-809c-ac8709e78449 |
| SwainTorment.preload | OLS-a0b83b8b-7f04-5d59-8335-06a8263eee51 |
| SwainTormentDoT.inibin | OLS-583e33fb-36ce-52fd-ac2d-f8706e117c28 |

## Contrat natif et inconnues

SwainDampeningFieldMana.inibin lie `game_buff_tooltip_SwainDampeningFieldMana`, ligne 2735 du fontconfig : **9 + le niveau après une unité ennemie tuée ; à la place, 9% du mana maximal après une élimination ou assistance sur champion**. La description courte ligne 4284 omet cette deuxième branche. Les formules du texte sont connues ; leur producteur historique et leurs politiques d’événements restent à qualifier.

Swain.inibin contient Passive1LuaName=SwainDampeningFieldMana, Passive1Icon=SwainCarrionRenewal.dds, les quatre alias SwainDecrepify/SwainShadowGrasp/SwainTorment/SwainMetamorphism. Passive1Desc, PARType et les six marqueurs Passive1Level sont absents des champs contrôlés. Le mana de base est la chaîne native `324.0`, la croissance la chaîne `50`, la portée d’attaque 500 et la vitesse 335 ; les représentations natives sont conservées.

Les 17 Lua sont lus entièrement sans fonctions enfants. Trois initialisations MetaHeal, MetaHealTorment et MetaNuke rencontrent NEWTABLE. CharScript est vide. DampeningFieldMana déclare nom, icône, SpellDamageRatio=1, PersistsThroughDeath et NonDispellable : le ratio de dégâts n’est pas une formule de mana et les flags ne prouvent pas une politique de cycle de vie. Metamorphism déclare SpellToggleSlot=4 sans exécuter un toggle. Six BuffData sont relevés : cinq traductions résolues, une clé SwainDecrepify non résolue dans le fontconfig sélectionné. Les quinze preloads n’établissent pas une acceptation de présentation.

Restent ouverts : catégories de cibles, attribution des morts et assistances, ordre avec expérience et changement de niveau, max mana et plafonnement, événements simultanés, mort du bénéficiaire, départs/reconnexion, producteur de la branche unité ordinaire et validation des niveaux 1 à 18.

## Références communautaires

21 fichiers sont inspectés, sans exécuter le serveur C#. CharScriptSwain est vide. Les scripts communautaires ne deviennent ni des règles natives ni des consommateurs Rust par association.

- Q planifie quatre impulsions aux instants 0, 1, 2 et 3. Le texte natif parle de trois secondes ; cadence et producteur restent à qualifier. Le commentaire de quatre secondes ne suffit pas à établir la durée réelle.
- W utilise délai 1,25 seconde, rayon 225, immobilisation 1,5 seconde : choix communautaires à comparer au contrat natif, sans les adopter automatiquement.
- E ajoute SwainTorment pendant quatre secondes. La classe de sort du même nom n’est pas un producteur du buff et ne démontre pas son amplification.
- R ajoute SwainRavenForm pendant dix secondes, frappe les ennemis à portée et calcule un soin de 75% sur les dégâts bruts. Le natif décrit un toggle, au plus trois corbeaux, priorité aux champions, coût croissant et soins distincts 75% champions / 25% sbires. Ces politiques ne sont pas démontrées dans le script choisi.

Une recherche dans les fichiers C# de LeagueSandbox-Scripts retrouve SwainTorment uniquement dans E.cs (classe de sort et appel de buff) et SwainRavenForm uniquement dans l’appel de R.cs. Les producteurs de ces buffs ne sont pas retrouvés dans ce périmètre. Un montage extérieur reste inconnu.

## Consommateurs actuels

La recherche pinée dans `crates/core/src/**/*.rs` ne trouve aucun Swain, Carrion ou DampeningField. Le chemin de récompense des morts de champions met à jour attribution, or, score, expérience et événement ; il ne restaure pas de mana pour Swain. La régénération, les caps des objets, la fontaine et l’expérience sont séparément reliés pour distinguer leurs effets.

| Point de code | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Swain public kill/assist,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:159 | actual Swain projectiles,not champion spell |
| crates/core/src/champion_kills.rs:26 | actual contribution history,not Carrion Renewal |
| crates/core/src/champion_kills.rs:32 | actual kill/assist awards lack mana restoration |
| crates/core/src/progression.rs:131 | level-up mana growth distinguished;all cases remain level1 |
| crates/core/src/interactions.rs:79 | fountain mana restoration excluded by public purchase geometry |
| crates/core/src/shop.rs:248 | public purchase requires shop range,distinct from fountain |
| crates/core/src/shop.rs:314 | Sapphire increases cap without refill,creating observable deficit |

## Diagnostic réellement exécuté

Le diagnostic privé utilise le vrai crate core de F:/OpenLeague, profil non-test et dépendances alignées sur le Cargo.lock. 1158 entrées et les preuves précédentes sont contrôlées avant/après. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-swain-passive-carrion_renewal-probe.exe`, 6191104 octets, SHA-256 `e4ef2c64d2571b119277011e9969a23963a3b77f6a39c4e04d7c9b1e97f0fb43`. Reçu complet : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision634_Swain_passive_probe/OBSERVATIONS.json`.

Swain et Garen sont alliés, Annie ennemie. Les trois personnages se déplacent par commandes publiques. L’achat de Saphir 1027, dans le rayon du magasin mais hors fontaine, augmente le maximum de 324 à 524 sans remplissage. Aucun mana, dommage, position, niveau ou événement n’est injecté. Le centre de magasin (1340,8141 ; 7996,8691) est distinct de la fontaine (1059,617 ; 7297,65869), tous deux de rayon 1000. Le point d’achat est contrôlé à moins de 1000 du magasin et plus de 1050 de la fontaine. Le déficit au début du combat est 165,752686.

En mode élimination, Swain tue Annie par projectiles ordinaires. En mode assistance, Garen la blesse, Swain contribue par un projectile, puis Garen termine ; l’événement attribue bien une assistance à Swain. Tous restent niveau 1, ce qui écarte une restauration due au changement de niveau.

| Cas | Maximum mana | Déficit au décès | Mana observé au décès | Attendu sans passif | Bonus natif théorique | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base_capped_kill | 324 | 0.000000 | 324.000000 | 324.000000 | 29.16 | 28 |
| Sapphire200Mana_kill | 524 | 142.187653 | 381.812347 | 381.812347 | 47.16 | 28 |
| base_capped_assist | 324 | 0.000000 | 324.000000 | 324.000000 | 29.16 | 28 |
| Sapphire200Mana_assist | 524 | 147.628815 | 376.371185 | 376.371185 | 47.16 | 28 |

Dans les deux cas Saphir, le déficit dépasse 142 au décès : il reste assez de place pour observer les 47,16 attendus. Le résidu observé par rapport à la seule régénération est nul au tick du décès et reste sous 0,002 pendant le suivi. Après chaque décès, 31 ticks supplémentaires sont observés. Les cas au maximum sont explicitement **non discriminants** pour la restauration conditionnelle.

Total : quatre décès, deux éliminations et deux assistances Swain, 48 impacts dont 28 projectiles Swain et 20 attaques Garen, 2084 ticks de mana en combat et 124 après décès. Seize arrivées sans réordre, deux achats de Saphir, aucune vente ni aucun rachat. 112 refus atomiques : joueur inconnu, attaques sur soi/allié, slot invalide, puis Learn/Cast/CastAt pour les quatre slots avant/après. Les sorts Swain restent refusés.

## Vérifications et conservation

Découverte, BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH et AUDIT : codes 0. Les gardes refusent 72 associations altérées et quatre graphes invalides. Les trois aperçus courts et quatre fiches complètes prévues sont actualisés. Les deux bases sont relues par les vrais lecteurs Store, copie des instructions, dépendances et rt.resolve. Synchronisation normale idempotente ; 42 603 autres lignes catalogue, 42 607 états manuels et 23 historiques conservés. Identités, hiérarchie et registre des inconnues restent identiques octet par octet.

Revue globale : 99 213 sources, 4897 points de consommation, ancres exactes sans divergence. Cette revue est structurelle ; `source_hashes_verified=0` n’est pas un re-hachage global. Les contrôles de contenu concernent la sélection et les entrées pinées décrites. 26 189 questions ouvertes et 5517 résolues avec historique restent conservées.

## Fichiers et suite

Registres : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json. Association : docs/reference_requirement_trace_sources/swain-passive-carrion_renewal-links-v634.json. Preuve : docs/fidelity_swain_passive_carrion_renewal_links_v634.json. Reprise : coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md/HANDOFF.md. Bases : runtime/project-plan/plan.sqlite3 et AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Sauvegardes, scripts et reçus privés sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision634_Swain`.

À faire : producteur Carrion Renewal, branche unité ordinaire et autres niveaux, plafonnement, événements et assistances aux limites, cycle de vie ; puis HUD, effets, sons, animations et réseau séparément. Les limites antérieures V564/V606 restent ouvertes. Aucune acceptation du passif, de Swain ou du jeu ; goal actif.

Continuer SYS-01.2-02 depuis revision635_trace_review/REVIEW.json. V634 Swain / Carrion Renewal : 49 fichiers natifs, 147 associations, 31 points de code et 62 liens. Le tooltip exact distingue 9 + le niveau après une unité ennemie tuée et, à la place, 9% du mana maximal après une élimination ou assistance sur champion. Dix-sept Lua sans fonctions enfants, dont trois limites NEWTABLE ; quinze preloads ; six BuffData, cinq traductions exactes et une non résolue. Aucun DDF dans les candidats contrôlés. Vingt et une références communautaires partielles ou divergentes ; producteurs de buffs SwainTorment et SwainRavenForm non retrouvés dans le sous-arbre inspecté. Quatre cas publics niveau 1 : élimination/assistance, mana plein ou déficit créé par achat de Saphir hors fontaine. Quarante-huit impacts, 112 refus atomiques, 16 arrivées, 2084 ticks de mana et 124 ticks après décès. Dans les deux cas avec déficit, aucun bonus de 47,16 mana observé : seule la régénération ordinaire est mesurée. Les témoins au maximum ne permettent pas de distinguer une restauration. Deux achats de Saphir ; aucune vente, aucun rachat ni état injecté. Branche unité ordinaire non exercée ; sorts Swain refusés. BUILD/RUN et inspection 0. États, cases, inconnues et preuves conservés ; gameplay inchangé. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Syndra. Goal actif.
