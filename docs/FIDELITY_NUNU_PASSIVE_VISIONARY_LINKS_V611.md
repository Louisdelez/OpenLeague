# SYS-01.2-02 — Nunu : sources et consommateurs de Visionary (V611)

Date UTC : 2026-10-26T12:14:05.432276+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

## Résultat

CH-Nunu-PASSIF-SOURCE, CH-Nunu-PASSIF-SIMULATION-CONTRAT et CH-Nunu-PASSIF-SIMULATION sont reliées à36sources natives,108associations,26points actuels et52liens sur les deux fiches de simulation. Aucun gameplay ni asset modifié ; aucune fiche déclarée complète.

Deux essais publics ont exécuté douze attaques de base et102refus atomiques aux comptes observés0/4/5/6. Les attaques ordinaires fonctionnent, mais l’apprentissage et les sorts Nunu restent refusés. Le sort gratuit de Visionary n’est donc pas utilisable dans le moteur actuel. Les attaques exercées ne constituent pas une qualification d’un compteur natif ni d’une consommation gratuite.

## Sources natives et limites

- Nunu.inibin lie Visionary, Yeti_FrostNova.dds et la description en_GB. Visionary.inibin lie game_buff_tooltip_Visionary : après5attaques de base, prochain sort sans coût en mana. La description générale confirme5attaques. Visions.inibin décrit le sort prêt ; Visionary Counter.inibin décrit la charge. Textes aux lignes2898–2900,4242 et4418 du font consulté.
- Des textes hérités parlent de chance aléatoire, de sort non ultime et de Yuralia avec10% de chance. Ils sont conservés sans les promouvoir comme politique4.20. Les champs Passive1Level1..4=1/6/11/16 ne déterminent pas une progression du compteur. Passive1 est absent, sans valeur0 inventée.
- Le fichier **Visionary Counter.inibin** existe avec espace. Le Lua **Visionary_Counter.luaobj** contient BuffName=Visionary Counter. Les chemins restent distincts : cette correspondance n’établit pas l’ordre de résolution du moteur historique.
- Le lecteur de Visionary.luaobj rencontre NEWTABLE. Ses constantes comprennent Visions, Visionary_buf.troy, NonDispellable et NunuBot ; une liste de constantes ne démontre pas une initialisation complète, un callback ni une priorité de chargement. NunuBot ici est une référence de skin, pas un motif pour exclure tout le passif normal.
- Visionary_marker.luaobj expose icône, BuffName=Visionary, PersistsThroughDeath et NonDispellable. Ces flags ne suffisent pas à qualifier tous les resets et comportements de mort/respawn.
- 17INIBIN,13Lua,5preloads et1font composent les36sources. Les13Lua sont parcourus intégralement sans prototype enfant :10initialisations littérales et3limites NEWTABLE (AbsoluteZero, Consume, Visionary). Limite du lecteur ne signifie pas corruption. Neuf clés BuffData sont résolues exactement.
- CharScripts natif et communautaire vides. Les preloads relient compteur, marqueur, Visionary et contexte QWER ; leurs noms ne prouvent pas l’exécution du passif ou son rendu.
- Six chemins candidats absents : CharScript à la racine plutôt que sous Scripts, Nunu.ddf du répertoire du personnage, Visionary_Counter.inibin plutôt que la variante avec espace, Visionary.preload, Visionary_marker.inibin et Visions.luaobj. Aucun manque global d’assets ou de tous les liens dynamiques n’est déduit. Aucun NightmareBotNunu dans les emplacements sélectionnés.
- Coûts SpellData relevés : Consume60 aux5rangs, BloodBoil50 aux5rangs, IceBlast75/85/95/105/115, AbsoluteZero100aux3rangs. Les champs ManaCost absents des buffs Visionary/Counter/Visions ne prouvent pas un coût0 effectif.
- Le comptage initiation/impact, les attaques admissibles, la gestion des ratés/blocages, le plafond, le reset, les sorts admissibles et le moment de consommation restent à qualifier. Le texte général « prochain sort » ne suffit pas à régler toutes les interactions R/items/summoners/recasts ou interruptions.

Vingt-deux références communautaires sont séparées du serveur original. Q calcule75de soin au rang1 sans AP, contre70et coefficient0,75dans les champs natifs ; malgré son commentaire « non-champ », son corps accepte un ennemi ObjAIBase sans exclusion explicite d’un champion. W ne montre qu’une application du buff à la cible, sans double application propriétaire/allié démontrée. E applique dégâts directs et un buff Slow, sans projectile ni ralentissement d’attaque qualifiés dans le fichier lu. R applique trois pulses temporisés à0/1/2s, sans canalisation originale qualifiée. Aucun script communautaire n’est exécuté comme consommateur Rust dans ce lot.

Identités contrôlées par taille/SHA-256 et appartenance RADS sélectionnée. Les chemins distincts sont conservés.

| Fichier | Source |
|---|---|
| Nunu.inibin | OLS-09134c7b-dbd7-5075-bcb3-f61621e363d9 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptNunu.luaobj | OLS-6f98d4d7-488c-590c-9610-a7823ce62de0 |
| CharScriptNunu.preload | OLS-8a465d13-a535-5a9a-96a1-e79d4f42b823 |
| AbsoluteZero.inibin | OLS-ffd91883-9a5a-5616-a0c0-1b4a36fe05ea |
| AbsoluteZero.luaobj | OLS-c8c88d27-8da6-5c78-82f7-ab0a88e8459e |
| AbsoluteZero.preload | OLS-8327b3c7-ae4d-5e5b-8064-8d9e319388ce |
| AbsoluteZero2.inibin | OLS-129e3653-12ba-5682-a8cb-1831cec77673 |
| AbsoluteZeroSlow.inibin | OLS-a32e7191-a267-5816-be87-8fae6a0e6a4c |
| AbsoluteZeroSlow.luaobj | OLS-6be01652-59cc-586e-9ecf-7554e3a5f76f |
| BloodBoil.inibin | OLS-be67c8fe-54af-563c-82a8-1476cef9f542 |
| BloodBoil.luaobj | OLS-5b5ea148-9b85-5fae-9494-7d89b389474c |
| Consume.inibin | OLS-eaf3bf36-7619-5f5e-91de-d30f5b7d637b |
| Consume.luaobj | OLS-9cf48d37-7581-5997-9787-eac57e4d7cea |
| Consume.preload | OLS-bdff966a-ffb9-5e35-a3da-14d943ba7179 |
| IceBlast.inibin | OLS-d09a79e6-42af-5767-b1ef-471441c0da82 |
| IceBlast.luaobj | OLS-52ebd5c0-d709-59b9-928c-0b725e07bfcb |
| IceBlast.preload | OLS-7dc77cfc-c6fd-57db-8d45-c8ebb532b551 |
| NunuBasicAttack.inibin | OLS-cca09ccc-2186-5fbc-9067-1f87e445fdce |
| NunuBasicAttack2.inibin | OLS-7d3d3a26-a4c9-5393-8f78-d6b3a26826e1 |
| NunuCritAttack.inibin | OLS-4e5bc30c-6d70-5868-aeb6-eddfc6d56a7b |
| NunuQBuffGolem.inibin | OLS-582b21bc-51ef-5ec8-82e0-77f8610dba4f |
| NunuQBuffGolem.luaobj | OLS-fe7a4b47-d042-5a54-a668-439253d54586 |
| NunuQBuffLizard.inibin | OLS-d099f0ab-128d-5a79-901c-f10822f1c54f |
| NunuQBuffLizard.luaobj | OLS-268a2b90-e702-5c55-8dca-b4709ff27bd0 |
| NunuQBuffWolf.inibin | OLS-5da12add-91a0-54ab-bb76-844d5ab69429 |
| NunuQBuffWolf.luaobj | OLS-c7716e7b-6d72-5bfe-9b3f-e6d82a59735b |
| NunuQBuffWraith.inibin | OLS-71dc2c0d-5924-52a6-b001-21bddef51f33 |
| NunuQBuffWraith.luaobj | OLS-d1b6787a-bd61-5fa4-be02-874db0f001cd |
| Visionary Counter.inibin | OLS-8366b75d-69e2-5c10-bd5c-9af6578fe922 |
| Visionary.inibin | OLS-2ac789f8-54a7-5033-8dbb-da268da9c45e |
| Visionary.luaobj | OLS-2c57c0a1-05ed-55aa-b44a-ceb1a4b969ba |
| Visionary_Counter.luaobj | OLS-61cc496f-d67e-5b1c-80f3-9515190e21bf |
| Visionary_Counter.preload | OLS-7ebdb048-b1fb-5851-8563-17eb3220ee03 |
| Visionary_marker.luaobj | OLS-b96df443-378d-5901-ba62-2bf4c3b01360 |
| Visions.inibin | OLS-e136d9db-8573-5b20-b592-299c29858433 |

## Exécution : attendu, observé et limites

Prérequis de phases/lots consultés. Trois questions propres et quatre dépendances conservées. Compilation Rust --locked --offline du core réel hors configuration de test, dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et la chaîne de preuves antérieures restent inchangées.

Deux parties publiques Nunu/Annie, sans objet puis Cristal de saphir1027(+200mana maximal). Aucun état, dégât, niveau, ressource ou déplacement injecté. Les personnages restent vivants niveau1, sans victoire, contrôle de foule ni bouclier ; rangs/délais Nunu nuls. Quatre trajets de préparation réussis sans reprise.

Chaque cas exécute six attaques mêlée, avec témoins windup.release et dégâts ordinaires après armure. Les commandes Learn/Cast/CastAt des quatre sorts sont essayées aux comptes observés0,4,5,6. À chaque étape,12refus conservent exactement le snapshot. Trois refus supplémentaires couvrent joueur inconnu, auto-attaque et slot invalide, soit51par cas et102au total.

| Cas | AD | Mana maximal | Mana final | Attaques | Refus |
|---|---:|---:|---:|---:|---:|
| base | 56.85600 | 283.56000 | 283.56000 | 6 | 51 |
| Sapphire200mana | 56.85600 | 483.56000 | 483.56000 | 6 | 51 |

Attendu pour le code courant : attaques génériques, coûts non évalués pour les sorts Nunu refusés, régénération ordinaire du mana et aucune mutation lors d’un refus. Observé :12impacts conformes à l’AD après armure, résidus inférieurs à0,002 ; refus inchangés après les quatrième, cinquième et sixième attaques. Aucun lancement de sort Nunu accepté, aucun coût gratuit consommé. Le mana final plein ne démontre aucune gratuité.

La première compilation a réussi (BUILD0), puis le programme a échoué (RUN101) sur une hypothèse du diagnostic : il exigeait mana courant=mana maximal immédiatement après achat du Cristal. Valeurs observées au premier tick :283,6096contre483,56. Le moteur augmente la capacité sans remplir instantanément la réserve ; ce comportement est visible dans refresh_item_caps. Le contrôle a été corrigé dans un nouveau programme/binaire : bornes0..max et prédiction de la régénération à chaque tick d’attaque, avec tolérance0,002. Le premier script, binaire, journal et reçu restent pinés. Aucun code du moteur n’a changé pour faire passer le diagnostic.

Binaire corrigé `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nunu-passive-visionary-mana-bounds-probe.exe`, 6093312octets, SHA-256 `b0dd7cf7943d3b38f3c2738afe2b85e598c42367c7928fd9cfc59e15c2385800`. BUILD/RUN corrigé et inspection :0. Les seuils d’attaques sont des comptes observés par le test ; ils ne sont pas présentés comme la valeur d’un compteur Visionary implémenté.

Pas de validation de sort à mana nul, de consommation/reset ou de plusieurs cycles ; aucune qualification serveur historique, rendu, audio ou réseau. Les quatre trajets réussis ne ferment pas V564 ni les deux échecs d’arrivée V606.

## Consommateurs réels

Recherche Nunu/Visionary dans crates/core/src sans occurrence, complétée par lecture et exécution des routes. La recherche lexicale seule ne prouve pas une absence globale.

next_rank refuse la progression Nunu. cast et cast_at refusent ses sorts avant un traitement de coût ou d’exemption. Effects ne contient pas de compteur ou marqueur prêt Visionary. advance_attacks et basic_attack_hit produisent les attaques ordinaires ; aucune production du passif n’est identifiée sur ces chemins. stats, uses_mana, restores_resource, regeneration et refresh_item_caps expliquent le mana observé.

Sept ressources locales liées séparément des règles natives du passif : catalogue, croissance, ressources, attaques, critiques, collision et boutique. Les données de Nunu ne constituent pas une implémentation de ses sorts.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Nunu spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals at0/4/5/6observed attacks |
| crates/core/src/progression.rs:68 | ordinary AD and Sapphire maxmana |
| crates/core/src/progression.rs:150 | unsupported Nunu learning |
| crates/core/src/progression.rs:159 | unsupported Nunu ranks |
| crates/core/src/spells.rs:101 | unsupported Nunu targeted spell before any cost waiver |
| crates/core/src/annie_w.rs:29 | unsupported Nunu ground spell |
| crates/core/src/lib.rs:685 | ordinary tick order during12attacks |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical damage |
| crates/core/src/attacks.rs:157 | Nunu melee attack path,not Visionary counter |
| crates/core/src/lifesteal.rs:4 | ordinary melee hit,no Visionary producer identified |
| crates/core/src/regeneration.rs:32 | ordinary HP/mana regeneration |
| crates/core/src/regeneration.rs:10 | per-tick mana prediction |
| crates/core/src/shop.rs:261 | Sapphire1027 purchase |
| crates/core/src/shop.rs:215 | ordinary item maxmana input |
| crates/core/src/world.rs:226 | ordinary enemy target |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | melee release witness |
| crates/core/src/critical.rs:12 | ordinary attack profile context |
| crates/core/src/ally_occupancy.rs:635 | four public preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |
| crates/core/src/lifecycle.rs:16 | ordinary mana resource classification |
| crates/core/src/lifecycle.rs:24 | ordinary mana restoration policy |
| crates/core/src/spells.rs:5 | serialized effect state has no Visionary counter or ready marker |
| crates/core/src/shop.rs:314 | maxmana cap update is not immediate mana refill |

## Publication et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/nunu-passive-visionary-links-v611.json ; preuve docs/fidelity_nunu_passive_visionary_links_v611.json. Instructions copiables enrichies dans les trois fiches et la synthèse SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72associations altérées et4graphes invalides refusés. Trois fragments de traçabilité modifiés,42212identiques. Deux bases locales : quatre destinataires,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation normale idempotente. Identifiants, hiérarchie et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99121sources,4318consommateurs,4318ancres exactes sans divergence. Vérification structurelle globale (source_hashes_verified=0) ; sources sélectionnées et code hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md actualisés en conservant les preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision611_Nunu_discovery/OBSERVATIONS.json ; revision611_Nunu_passive_probe (premier échec) ; revision611_Nunu_passive_probe_mana_bounds/OBSERVATIONS.json ; revision611_Nunu_inspection/OBSERVATIONS.json ; revision611_Nunu/DELIVERY_AUDIT.json ; revision612_trace_review/REVIEW.json. Scripts, binaires et reçus identifiés dans ces preuves.

## Travail restant

1. Résoudre les événements de comptage, les attaques et sorts admissibles, les resets et la consommation.
2. Implémenter le compteur/prêt Visionary et son branchement au vrai chemin de lancement des sorts Nunu.
3. Implémenter les capacités nécessaires pour exercer réellement le sort gratuit, avec les coûts natifs sourcés.
4. Tester seuils4/5/6, plusieurs cycles, mana nul/insuffisant/plein, refus/annulations/interruptions et absence de consommation indue.
5. Vérifier cibles champions/sbires/monstres/structures, ratés/blocages, mort/respawn, changement de cible et nettoyage.
6. Qualifier séparément HUD du compteur/prêt/coût, rendu, particules, animations, audio et réseau.

Les trois fiches Nunu restent ouvertes. Les limites Battle Training et navigation sont conservées. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision612_trace_review/REVIEW.json. V611 Nunu / Visionary :36sources natives,108associations,26points et52liens. Textes4.20 : après5attaques de base, prochain sort sans coût en mana. Textes hérités chance aléatoire/non-ultime/Yuralia10% conservés sans adoption. Deux cas publics base/Cristal de saphir1027 :12attaques mêlée,102refus atomiques aux comptes observés0/4/5/6,4trajets sans reprise. AD56,856 ; mana maximal283,56/483,56. Aucun sort Nunu accepté, compteur et consommation gratuite non qualifiés. Le premier essai BUILD0/RUN101 supposait à tort que l’achat remplissait immédiatement le mana ; corrigé par bornes et régénération, original conservé. 13Lua dont3limites NEWTABLE,5preloads,9clés BuffData résolues,22références communautaires. CharScripts natif et communautaire vides. Visionary Counter.inibin existe avec espace ;6candidats absents dont Nunu.ddf ne prouvent pas un manque global d’assets. Q communautaire soigne75sans AP au rang1 contre70et coefficient0,75natifs, sans exclusion explicite des champions dans le corps ; W applique seulement le buff à la cible ; R utilise trois pulses temporisés, non qualifiés comme canalisation native. V564 et deux échecs de trajet V606 ouverts. Aucun gameplay modifié. BUILD/RUN corrigé/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ; premier RUN101 conservé.72+4refus de publication. Prochain passif à inspecter réellement : Olaf. Goal actif.
