# OpenLeague — état courant reconstitué

Dernière reprise : 2026-11-03. Goal Codex toujours actif; objectif global de recréation LoL 4.20 non achevé. Tâche active : SYS-01.2-02 — relier chaque exigence à sa source native et à ses consommateurs actuels. Le statut du registre reste partiel_a_terminer; aucune acceptation humaine n’est inscrite.

## Référence et limites actuelles

Client fourni : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB; build littéral 2014-11-17 à 17:46:45. Fuseau du build et date de déploiement non établis. Catalogue Data Dragon comparatif : 4.20.1. Présence de ressources et liens de recherche ne prouvent pas disponibilité historique, sémantique serveur, intégration du jeu ordinaire ou acceptation.

Le résolveur en lecture seule de SYS-01.2-02 a réussi sous UTF-8 (code 0) après un refus d’affichage CP1252. La fiche OLF-3a11ace9-485c-55ae-8dff-2533902a5839 porte partial_with_open_questions : 4 297 liens d’entrées natives, 4 958 liens de références, 1 319 liens consommateur pour cette fiche et cinq inconnues. Ce lot n’a pas validé toutes les empreintes ni exécuté le jeu.

Compteurs des JSON actuellement présents : 42 215 exigences, 100 405 sources, 5 759 consommateurs, 31 706 inconnues (26 189 ouvertes, 5 517 résolues). Ces comptes concordent entre les documents courants, mais n’établissent pas une nouvelle vérification des 100 405 empreintes. Les chiffres 92 639/403 et 23 303/22 sont des snapshots historiques, pas l’état courant.

## Lots récents consignés

- V796 — le recensement du manifeste actif n’a trouvé aucun nom/chemin direct URF/Cheats; OLU-6c4ea73e et OLU-f76e6025 restent ouverts. Rapport : docs/FIDELITY_NATIVE_RELEASE_MEMBERSHIP_4_20.md.
- V797 — quatre candidats d’icônes Amumu/Nunu appartiennent aux manifestes core, aucun au manifeste en_GB; priorité et casse RADS non résolues. Rapport : docs/FIDELITY_SPELL_ICON_GRAPH_V220.md.
- V798 — defaults.zip attendu par MD5 5b0713441b5e6ee27af56c23a8b625e4 absent des deux manifestes choisis; payload/producteur/staging inconnus. Rapport : docs/FIDELITY_LOCALE_FONT_LINKS_4_20.md.
- V799 — aucun appel de production PackageProvider/source_from_package trouvé; seuls les tests y font appel. Le Ring actif utilise deux textures directes. Feature et montage restent ouverts.
- V800 — aucun parseur ANM v3 disponible dans le périmètre vérifié; lecteurs locaux détectés limités à ANM4. Aucune animation Anivia analysée.
- V801 — item natif 1057 Negatron Cloak : +35 MR/+50 % regen, InStore=0/CanBeSold=0, absent du catalogue courant; disponibilité historique et feature restent ouvertes.
- V802 — lien statique item 1033 : source +25 MR, catalogue correspondant et admission locale Map10, puis agrégation shop.rs vers progression.rs. Pas d’achat ni de mesure runtime.
- V803 — résolution du résolveur de la fiche; cinq inconnues demeurent. Les compteurs globaux cités alors ont été corrigés par V806.
- V804 — recherche publique unique par MD5/chemin pour defaults.zip : aucun payload ou producteur; seuls des guides communautaires de modification manuelle. OLU-0ae207ed reste ouvert.
- V805 — prérequis D01-SYS-01-1 non accepté : les sept tâches SYS-01.1-01..07 sont requises, a_valider, acceptance_complete=false et cases non cochées. Le référentiel client présent n’accepte pas le paquet.
- V806 — compteurs des registres courants réconciliés; aucun rescannage global.

## Inconnues et conditions de reprise

Les cinq inconnues de SYS-01.2-02 restent ouvertes : OLU-3293c388-b623-5429-8fd7-c89f6f0aba7e, OLU-29959b0b-cd97-5abc-95c8-cd9eb1520f01, OLU-6c4ea73e-b19b-5768-b6b0-6f596a6a3a20, OLU-f76e6025-f166-5cef-88b4-24340ec8d4b9, OLU-0ae207ed-8eed-5b18-8086-c348282caeb5. Ne pas relancer les mêmes recherches sans nouvel élément primaire. OLU-0ae207ed reprend sur le payload au MD5 attendu, un manifeste autoritatif ou une trace native de staging/overlay.

D01-SYS-01-1 est le prérequis explicite avant intégration. Continuer seulement les audits documentaires tant que les sept sous-tâches ne sont pas acceptées selon le processus autorisé. La fiche SYS-01.2-02 indique pourtant depends_on=[]; aucun état n’a été modifié pour contourner cette différence.

Prochaine action : choisir, depuis les registres actuels, une relation source-consommateur requise distincte sans reçu dédié; éviter le résolveur, les cinq investigations déjà faites et tout re-scan global. Garder l’objectif actif et les écarts visibles. Pas de tests, build, installation, migration, lancement du jeu, modification du goal, du registre, du Plan, de l’application ou de ses bases.

## Récupération documentaire

Le CURRENT.md présent était à zéro octet après une erreur lors d’une tentative de normalisation de fin de ligne. Le snapshot historique docs/ai/history/798ddc523e2d028d1f9266670ad39b5a2644c3b74683fb9a57b0b024c11bf23a.md est conservé et son SHA-256 correspond à son nom; il couvre l’état vérifié V795. L’état V796–V806 ci-dessus est reconstitué à partir de HANDOFF.md et des entrées correspondantes du checkpoint. La copie exacte de CURRENT.md immédiatement avant l’incident n’a pas été récupérée; cette note est une synthèse reconstruite, pas une copie octet pour octet.


## V808 — Yasuo, frontière consommateur du passif

Sous-audit statique clos pour le lien chance de critique / bouclier de mouvement : le calcul courant de chance ne contient pas le facteur Yasuo; le système de bouclier générique ne comporte aucun producteur Yasuo identifié, et son seul appel de production recensé est Barrière. Sources V533 et résultat critique V536 réutilisés; aucune collecte ni exécution répétée. `CH-Yasuo-PASSIF-SOURCE`, son inconnue `OLU-5dd3c2d5-ecf3-521d-ac2c-f471376ddfcc`, le prérequis identité, l’acceptation du passif et SYS-01.2-02 restent ouverts. Aucun statut, registre, Plan, application ou base modifié; aucun test/build/runtime exécuté. Rapport : `docs/AUDIT_SYS01202_YASUO_PASSIVE_CURRENT_CONSUMER_2026-11-02.md`.

Reprise : seulement sur une source primaire 4.20.0.315 du déclencheur/formule de bouclier ou sur un changement vérifié du consommateur. V533/V536 et la recherche lexicale ne sont pas à rejouer sans piste nouvelle.

## V809 — SYS-01.2-02, objet 1001 : vitesse de déplacement

Sous-audit source → consommateur clos : preuve native antérieure réutilisée (FlatMovementSpeedMod=25, SHA-256 consigné), catalogue local 1001=+25 avec la même empreinte, consumer shop::bonuses → movement_speed. Le test ciblé passe : achat +25, doublon du groupe BootsNormal refusé sans débit, vente restaure la vitesse de base (1 passé, 0 échoué). ITEM-1001-SCOPE reste partielle, ITEM-1001-SERVER-STAT-FlatMovementSpeedMod reste à faire; prérequis D01-SYS-01-1 et SYS-01.2-02 restent ouverts. Pas de re-hachage, test de mouvement, runtime, recherche externe ni changement de statut. Rapport : docs/AUDIT_SYS01202_ITEM1001_MOVEMENT_SPEED_2026-11-02.md.

Reprise : ne pas répéter la preuve native ni la valeur. Après acceptation D01-SYS-01-1, exécuter le test de distance déjà présent dans movement.rs et traiter les limites carte/session exigées. Aucun goal, registre, Plan, app ou base modifié.

## V810 — SYS-01.2-02, objet 1006 : régénération de base des PV

Unité AUD-SYS-01.2-02-ITEM1006-BASE-HP-REGEN-LINK-01 close pour le lien PercentBaseHPRegenMod=0.5 natif → health_regen_percent=0.5 local → shop::bonuses → regeneration_rates. Source OLS-60f3e978-0395-543a-9a71-2dc78d2d8522, hash et membership antérieurs réutilisés, aucun re-hash. Test courant réussi : 2 objets donnent 2× la base, vente d’un ramène à 1,5× et progression de niveau recalcule le taux (1/1). ITEM-1006-SCOPE et ITEM-1006-SERVER restent partielles; aucun statut ni acceptation modifié. Rapport : docs/AUDIT_SYS01202_ITEM1006_BASE_HP_REGEN_LINK_2026-11-02.md.

Prochain lot retenu : item 1004 PercentBaseMPRegenMod, dont les sources/consumers sont identifiés mais le cas positif sur champion à mana manque au test existant. Reprendre ce lien sans refaire les recherches exclues ni l’extraction des objets 1001/1006. L’étape de distance item 1001 demeure conditionnelle au prérequis D01-SYS-01-1.

## V811 — récupération des timestamps du checkpoint

Incident de remplacement trop large répertorié dans docs/AUDIT_RESUME_CHECKPOINT_TIMESTAMP_RECOVERY_2026-11-02.md. Le JSON a été réparé : 1 278 timestamps identiques au snapshot validé du 27 octobre restaurés, trois timestamps récents restaurés depuis les reçus de ce fil, 131 timestamps sans copie concordante marqués null. Le contenu des autres champs a été préservé. Le parse JSON et node .ai-tools/project.mjs resume réussissent; la prochaine action reste ITEM-1004. Aucun statut, code, Plan, application, base ou goal modifié.

## V812 — SYS-01.2-02, item 1004 : régénération de mana

Sous-audit source → donnée → consommateur clos. Reçu natif 4.20 PercentBaseMPRegenMod=0.25 et hash réutilisés sans relecture; catalogue local identique. Contrôle Rust temporaire hors dépôt : Ahri 1.2 mana/s sans objet, 1.5 avec 1004, gain 1.500092 sur 30 ticks hors fontaine, retour à 1.2 après vente; cargo run --offline code 0. Le test Ahri/Akali existant est réutilisé, non rejoué. Limites ouvertes : achat manaless, cumul, croissance multi-niveaux, règles serveur historiques.

ITEM-1004-SCOPE/SERVER et SYS-01.2-02 restent ouverts; aucun statut, code produit, Plan, application, base ou goal modifié. D01-SYS-01-1 reste non accepté. Rapport : docs/AUDIT_SYS01202_ITEM1004_BASE_MP_REGEN_LINK_2026-11-02.md.

Prochaine action : sélectionner un lien source-consommateur distinct parmi les exigences SYS-01.2-02 encore ouvertes, avec reçu natif et consumer actuels déjà disponibles; auditer une unité avec un cas nominal et une limite, sans rejouer les recherches ni toucher aux statuts.

## V813 — SYS-01.2-02, item 1011 : FlatHPPoolMod

Sous-audit source → donnée → consommateur clos. Source 4.20 enregistrée OLS-f8e5fecb-5d3b-5826-a19a-24af43e2df5d, 560 octets, SHA-256 e9431e7c57900819bb504786ca78037f9a734db98162e46a7bed1585466ee597; reçu natif réutilisé, aucun re-hash. Valeur 380 PV et catalogue local concordants; Map10 admet l’objet.

Probe local Map10 réussi : 999 or refuse sans mutation; 1000 or achète +380 PV max (616,280 → 996,280); vente retire le bonus et rend 700 or. cargo run --offline code 0; aucun code source modifié. ITEM-1011-SCOPE/SERVER restent partiels; audit local ne prouve ni règles serveur historiques ni disponibilité générale. Rapport : docs/AUDIT_SYS01202_ITEM1011_FLAT_HP_POOL_LINK_2026-11-02.md.

Prochaine unité : choisir un autre lien source-consommateur requis avec preuves existantes et consumer courant, sans reprendre les lots 1001/1004/1006/1011 ni modifier les statuts.

## V814 — SYS-01.2-02, item 1018 : FlatCritChanceMod

Sous-audit source → catalogue → consumer fermé. Source OLS-0d8167ff-4a6a-5162-aaa4-070ff1c5814d, 533 octets, SHA-256 3cdd918dd0e86ac8cf43a36424e2aab965c2cfcd26c11f301f5dd3e9efb4bf5b; appartenance RADS sélectionnée concordante; preuve et valeur réutilisées, aucun re-hash. FlatCritChanceMod=0.15000000596046448 concorde avec shop_foundation et l’admission Map10.

Probe Simulation Map10 réussi : Garen, 729 or → refus sans mutation; 730 or → chance 0 → 0.150000006 et dégâts inchangés; vente → retour 0 et crédit 511; cargo run --offline code 0. Le tirage critique en combat n’a pas été testé. ITEM-1018-SCOPE/SERVER restent partiels. Rapport : docs/AUDIT_SYS01202_ITEM1018_CRIT_CHANCE_LINK_2026-11-02.md.

Prochain lien : en choisir un autre requis, distinct des lots 1001/1004/1006/1011/1018, avec source native et consumer courants; un seul nominal et une limite, aucun changement de statut.

## V815 — SYS-01.2-02, item 1029 : FlatArmorMod

Sous-audit source → catalogue → armure clos. Source native enregistrée OLS-4be229f5-8e25-5e28-b080-77c8c9dad43a, client 4.20.0.315, 528 octets, SHA-256 9596f0efec5a87ee6dca380d042f94cff48a1e73ba965fdc61955d72075526ab, membership concordante; reçu et valeur 15 réutilisés sans re-hash. Donnée locale armor=15 et Map10 allowed=true.

Test existant courant réussi : native_start_and_buy_apply_to_combat_stats (1/1). Il achète 1029 après 1036 et constate +15 armure à l’achat. Vente et refus propres à 1029 non testés; les tâches ITEM-1029-SCOPE/SERVER restent partielles. Rapport : docs/AUDIT_SYS01202_ITEM1029_FLAT_ARMOR_LINK_2026-11-02.md.

Prochaine unité : sélectionner un autre lien source-consommateur distinct avec preuve existante; nomimal + limite, aucun statut modifié.

## V816 — SYS-01.2-02, item 1051 : FlatCritChanceMod

Sous-audit source → catalogue → consumer clos. Source OLS-52920235-455a-506b-a9a5-8c32fbda196c, 4.20.0.315, 526 octets, SHA-256 ad41973e83a09bd9138de4a06b3025c0c6aae48028e5405a4386cf9d3553a681, membership sélectionnée concordante; reçu réutilisé sans re-hash. FlatCritChanceMod=0.07999999821186066 correspond à critical_chance locale et Map10 allowed=true.

Test actuel courant native_crit_components_stack_sell_and_cap_without_changing_base_damage réussi (1/1) : deux 1051 = 0,16 chance; vente d’un = 0,08; dégâts inchangés. ITEM-1051-SCOPE/SERVER restent partiels; tirage en combat non qualifié. Rapport : docs/AUDIT_SYS01202_ITEM1051_CRIT_CHANCE_LINK_2026-11-02.md.

Prochain lot : un lien requis distinct avec source et consumer actuels, succès et limite documentés, statuts inchangés.

## V817 — SYS-01.2-02, item 1052 : FlatMagicDamageMod

Sous-audit source → champ → catalogue → AP local clos. Source OLS-40885383-cc97-5bd3-9f81-211026fb4d4c, 4.20.0.315, 577 octets, SHA-256 ec992cc30be0724ce6cf625ac775d8715417cb35a0eb27315bd6e1284ee93cfd, membership concordante. Lecture INIBIN ciblée: hash Data*FlatMagicDamageMod 3524488927 présent, brut chaîne 20; sha/tailles égalent le reçu. Catalogue ability_power=20.

Test courant two_altar_power_bonus_uses_the_current_item_power réussi (1/1) : 20 AP achat, 22 deux autels, 0 après vente. Conversion du brut string au nombre est une interprétation du champ, pas une exécution du serveur natif. ITEM-1052-SCOPE/SERVER restent partiels. Rapport : docs/AUDIT_SYS01202_ITEM1052_ABILITY_POWER_LINK_2026-11-02.md.

Prochaine unité : choisir une relation requise distincte, réussir un cas nominal et documenter une limite; aucun statut modifié.

## V818 — SYS-01.2-02, item 1036 : FlatPhysicalDamageMod

Sous-audit source → catalogue → damage local clos. Source OLS-69ccc5a1-3126-52c6-a584-f9cfe8f7b781, client 4.20.0.315, 578 octets, SHA-256 e6ed2a72317ed8295f74351663e0d94124b46c48f61db02cbc479849a3e86731, membership concordante; FlatPhysicalDamageMod reçu comme string 10, catalogue damage=10.

Test du lot V815 réutilisé, non relancé en V818 : native_start_and_buy_apply_to_combat_stats achète 1036 et vérifie dégâts de base +10, 1/1. Cela ne mesure pas un coup réel. ITEM-1036-SCOPE/SERVER restent partiels. Rapport : docs/AUDIT_SYS01202_ITEM1036_DAMAGE_LINK_2026-11-02.md.

Prochain lien distinct : source native + consumer courant, un nominal et une limite; statuts conservés.

## V819 — SYS-01.2-02, item 1042 : PercentAttackSpeedMod

Sous-audit source → catalogue → cadence locale clos. Source OLS-6a0aee4b-4dc4-5377-8d10-2249a9bdcc5a, 4.20.0.315, 559 octets, SHA-256 7a69325ffca20442c839e7e0acedb719f93f4144a073b147661957c5ff1f4a75, membership concordante; PercentAttackSpeedMod=0.15000000596046448 égal au catalogue.

Test ciblé courant réussi (1/1) : achat 1042 réduit attack_cooldown_ticks; vente restaure le taux. Le refus du doublon testé concerne 1001, pas 1042; aucun DPS/hit historique mesuré. ITEM-1042-SCOPE/SERVER restent partiels. Rapport : docs/AUDIT_SYS01202_ITEM1042_ATTACK_SPEED_LINK_2026-11-02.md.

Prochain lien requis distinct, un nominal et une limite; aucun statut modifié.

## V820 — SYS-01.2-02, item 1053 : recette, AD et vol de vie

Sous-audit source → recette/données → stats → attaque locale clos. Source OLS-db739366-3781-58b7-b7c8-dbc67a297e8f, 4.20.0.315, 563 octets, SHA-256 bb7db97c466730d2b2902d68fd64b4341f322b3352d936d0621670b05756d05d, membership concordante; reçus réutilisés sans re-hash. Native Price=440 + RecipeItem1=1036; champs AD string 10 et lifesteal 0.0799999982; catalogue total recette=800, sell=560.

Deux tests courants réussis (1/1 chacun) : recette/vente retire AD et lifesteal; attaque normale soigne 8% des dégâts post-mitigation et l’overheal est clampé. C’est la simulation locale, pas une preuve du serveur historique. ITEM-1053-SCOPE/SERVER restent partiels. Rapport : docs/AUDIT_SYS01202_ITEM1053_LIFESTEAL_LINK_2026-11-02.md.

Prochain lien requis distinct avec source et consumer vérifiés; un cas nominal et une limite, statuts inchangés.


## V821 — SYS-01.2-02, item 1055 : preuve courante AD / vol de vie

Le lien source → shop_foundation → stats/attaque des deux champs est maintenant vérifié sur le test courant, sans refaire l’extraction native ni le membership. Références : OLS-7009b21b-648f-5338-9d1d-5beddef7c7c5 (520 octets, SHA-256 1645d84b…5647f38) et reçu de membership OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d. cargo test --offline -p openleague-core --test doran_blade -- --nocapture : 4 passés, 0 échoué. Achat/vente, refus (or, zone de boutique, inventaire plein), vol de vie sur attaque/Q et absence sur Jugement sont couverts. Simulation locale seulement; 24 avertissements Rust non bloquants. Tâches FlatPhysicalDamageMod et PercentLifeStealMod inchangées (a_faire, implementation/acceptance false); aucun code ou base de suivi modifié. Rapport : docs/AUDIT_SYS01202_ITEM1055_CURRENT_TEST_LINK_2026-11-02.md.


## V822 — échelles de base : état courant revalidé

Le manifeste d’animation a changé depuis le reçu du 21 octobre. Comparaison locale 122/122 bit exactes et test réel actuel cargo test --locked --offline -p openleague-client animation::scale_reference_audit:: -- --nocapture --test-threads=1 : 2 passés, 0 échec. Pour Fizz, la demande passe désormais de l’ancien 0x6666a63f au 0x6766a63f natif, chemin champions/fizz.glb. C’est la parité numérique du catalogue/consumer de demande, pas la clôture mesh/rendu; SKIN-Fizz-0-ASSET-MESH reste a_faire, implementation/acceptance false. Rapport mis à jour par addendum : docs/FIDELITY_ACTUAL_RUST_BASE_SCALE_4_20.md. Aucun statut, goal, Plan, application ou base de suivi changé.


## V823 — frontiere `RADS/system/system.cfg`

Audit statique clos pour le consommateur courant de ce fichier seulement. La source enregistree (72 octets, SHA-256 `a99ea26414fbd7deebace37c9e2c109f818a8c394f92607cfa082bd49f35c16a`) indique EUW; la recherche ciblee dans les sources Rust/launcher n'a trouve aucune lecture. Le demarrage normal utilise la racine compilee du projet (`main.rs:518`) puis son catalogue/HUD (`main.rs:599-600`). Le fichier n'est pas une entree de SYS-01.2-02, mais de SYS-01.1-01/-03. Rapport : `docs/FIDELITY_LOCALE_FONT_LINKS_4_20.md`.

Restent ouverts : bootstrap Riot 4.20, choix de release effective, priorite des configurations/overlays, preuve du lancement EUW historique et l'audit global. Aucun test/build/runtime execute, aucun code, statut, goal, Plan, application ou base de suivi modifie. Reprise OLU-29959 sur une seule trace native de chemin/configuration effective; eviter le grep deja fait.


## V824 — empreintes ciblees des consommateurs de code

Relecture du resolveur courant : SYS-01.2-02 a 4 297 sources natives, 4 958 references, 1 319 consommateurs, cinq inconnues ouvertes. Controle cible F: des 54 consumers `current_workspace` : 15 fichiers uniques; 54/54 tailles et SHA-256 identiques au registre, et 54/54 ancres exactes a la ligne indiquee. Les 1 265 autres consommateurs et leur pertinence semantique ne sont pas etablis par ce lot. Rapport : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`. Statut `partiel_a_terminer` inchange; goal, Plan, application et bases non modifies.


## V825 — controle elargi des sources/ancres consumers

Le controle cible sur la fiche actuelle confirme 1 305/1 319 consumers attaches au worktree F:. Les 1 305 chemins source/consumer relatifs concordent; 1 305 enregistrements SHA/taille correspondent sur 423 fichiers uniques; ancres exactes 1 305/1 305. Les 14 chemins externes sous E:\mapslol3v3 ne sont pas rehashes dans ce lot; leur controle d'ancre existant est reutilise. La validite semantique des liens natifs et les cinq inconnues restent ouvertes. Details : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`. SYS-01.2-02 reste partiel; aucune base, registre, Plan, application ou goal modifie.


## V826 — classification des consumers externes

Les 14 IDs hors F: pointent vers des diagnostics/outils de reference dans `E:\mapslol3v3`, pas vers les consumers du jeu F:. Leurs repertoires precis ne sont references ni dans `crates/`, ni dans `launcher/`, ni dans `Cargo.toml`. Le total root 1 319 melange donc 1 305 consumers de code F: (V825) et 14 consumers/outils externes; ne pas le presenter comme 1 319 consumers gameplay. Aucun ID n'a ete retire du registre. SYS-01.2-02 reste partiel et les cinq inconnues ouvertes.

## V827 — SYS-01.2-02, objet 3108 : bonus de puissance

Lien statique fermé pour Data.FlatMagicDamageMod=30 natif → shop_foundation.json (ability_power=30, même SHA source) → shop::bonuses → progression::stats. La suite Map10 exécutée sur le binaire déjà présent passe 5/5; le cas nominal achète les 31 objets admis, dont 3108, et vérifie inventaire/or, pas la statistique AP propre à 3108. Refus atomique des objets exclus et refus d’admission inconnue passent aussi. La compilation Cargo courante n’a pas démarré : accès au .cargo-build-lock refusé. Détails et empreinte du binaire dans docs/AUDIT_SYS01202_ITEM3108_ICON_2026-11-02.md.

L’objet et la fonctionnalité restent ouverts : aucun test AP direct pour 3108, CDR natif numérique non établi, UI boutique/rendu non vérifiés, consumer shop_ui.rs:233 absent du registre. Aucun état de tâche/goal/Plan/app/base modifié. D01-SYS-01-1 et les cinq inconnues restent ouverts. Suite : choisir un autre lien source-consommateur déjà muni de preuve; pour le CDR de 3108, reprendre uniquement sur une source primaire ou un test numérique existant, sans répéter le décodage déjà fait.

## V828 — SYS-01.2-02, consumer attack_speed

Test existant exécuté directement : shop::tests::boots_group_is_unique_and_dagger_changes_attack_cadence, 1/1 réussi. La Dague 1042 réduit les ticks d’attaque, sa vente restaure la cadence, et le doublon BootsNormal est refusé sans débit. Hashes de shop.rs, progression.rs et des deux catalogues identiques à ceux du rapport item 3101; aucun rebuild. Cette preuve porte sur le consumer générique, pas sur l’objet 3101 (+0,4) lui-même. Binaire, SHA et limites : docs/AUDIT_SYS01202_ITEM3101_ATTACK_SPEED_2026-11-02.md.

Audit source→valeur→consumer de 3101 reste statique; comportement spécifique, arrondi serveur et disponibilité historique restent ouverts. Aucun code, statut, registre, goal, Plan, app ou base modifié. Prochaine unité : une exigence distincte avec source primaire et consumer existants; ne pas refaire les décodages 3108/3101 ni les scans globaux.

## V830–V831 — consommateurs actuels des pools d’objets

Deux liens source→donnée→consumer sont vérifiés sans changer le code : 1028 FlatHPPoolMod=150 (trois tests existants réussis) et 1027 FlatMPPoolMod=200 (un test existant réussi, y compris la limite des ressources sans mana). Les INIBIN d’origine ont été rehachés et concordent avec les identités/memberships enregistrés. Rapports : docs/AUDIT_SYS01202_ITEM1028_HEALTH_POOL_2026-11-02.md et docs/AUDIT_SYS01202_ITEM1027_MANA_POOL_2026-11-02.md.

Les critères complets version/cartes/restrictions/prix/recettes des deux tâches restent ouverts; les tests ne qualifient que le simulateur local. Aucun état de tâche, goal, plan, interface ou base de suivi n’a changé.

Prochain lot : ITEM-1026-SCOPE — qualifier son champ natif de puissance magique, le membership et son consumer courant, puis vérifier un nominal et une limite sans recompilation si le binaire ciblé est cohérent avec les sources.
## V832 — consumer AP de l’objet 1026

Lien statique source/native FlatMagicDamageMod=40 → shop_foundation ability_power=40 (SHA exact) → shop::bonuses/progression::stats établi. Admission Map10 et achat normal validés par le test existant; tests d’exclusion et d’inconnue également passés. Aucun test ne mesure +40 AP en statistique après achat, et la provenance exacte du binaire précompilé au regard des empreintes actuelles n’est pas garantie. Rapport : docs/AUDIT_SYS01202_ITEM1026_ABILITY_POWER_2026-11-02.md. ITEM-1026-SCOPE et son acceptation restent ouverts.

Prochaine unité : sélectionner une autre exigence requise à partir des preuves et consumers déjà recensés; aucun rescannage global ni reprise des liens 1026–1028.
## V833 — consommateurs recette et stats de l’objet 3801

Audit borné du parcours 3801 clos : source native Price=20 et RecipeItem1/2=1028/1006, donnée locale total=600/recette identique, Map10 admis; le consumer vérifie l’incrément de 20 or, la consommation des deux emplacements et le remplacement des bonus sans double application. Deux tests existants réussis. Prix de vente serveur, disponibilité EUW, UI et acceptation restent ouverts; ITEM-3801-SCOPE ne change pas de statut. Rapport : docs/AUDIT_SYS01202_ITEM3801_RECIPE_STATS_2026-11-02.md.

Prochain lot : choisir une exigence requise distincte avec source native et consumer courant prouvables; définir un nominal et une limite/refus, réutiliser les preuves, sans refaire 3801 ni 1026–1028.

## V834 — objet 1031 : recette et armure

Preuves natives existantes réutilisées : source 4.20 1031.inibin (source OLS-27c16d5f…, 528 octets, SHA-256 a238de31…36264c), membership au manifeste sélectionné; valeur 40 armure, prix incrémental 450, recette 1029. Le catalogue local reprend ces valeurs, prix total 750 et revente locale 525; admission Map10 vraie. Le consumer shop::quote/buy_item/bonuses → progression::stats est relié. Les tests précompilés recipe_consumes_once_and_replaces_stats et unaffordable_recipe_preserves_components_and_gold passent 1/1 chacun : achat nominal +40 armure, puis refus sans mutation quand l’or manque. Binaire SHA-256 46D373…F74E6D, daté du 21 octobre; correspondance exacte binaire/sources courantes non établie. Rapport : docs/AUDIT_SYS01202_ITEM1031_ARMOR_RECIPE_2026-11-02.md.

Complément au V802 déjà existant, sans recompter le lien 1033 : son test précompilé native_w_passive_amplifies_bonus_resistances_and_sale_removes_bonus passe 1/1. Il exerce l’achat 1033 puis +5 MR via le passif de Janna; il ne vérifie pas directement +25 MR de base ni la vente de 1033. Ce contrôle ne change pas le statut de l’item.

Clôture d’audit de cette liaison locale uniquement. ITEM-1031-SCOPE reste partiel; disponibilité EUW, priorité runtime, revente historique et acceptation restent ouvertes. Aucun statut, code, goal, Plan, application ou base de suivi modifié.

Prochaine unité : sélectionner une exigence requise distincte après déduplication du registre et des rapports. Ne pas répéter les lots 1026–1029, 1031, 1033, 1036, 1042 ou 3801; ne rouvrir une preuve que sur nouvel indice primaire ou consumer modifié.


## V835 — objet 1038 : admission Map10 et consumer de refus

Source native 4.20 existante réutilisée : OLS-31246393-cf24-581a-8913-c62ed5f818d5, Price=1550, +50 dégâts, InStore/CanBeSold vrais, membership manifeste concordante. La donnée locale reprend le SHA; Map10 indique false, cohérent avec le catalogue comparatif 4.20.1 maps[10]=false. shop::buy_item refuse l’achat Map10 avant devis/débit. Le test de refus incluant 1038 avait déjà passé dans le reçu V832; il n’a pas été relancé. Ce reçu vient d’un binaire du 21 octobre, sans provenance exacte aux sources actuelles. Rapport : docs/AUDIT_SYS01202_ITEM1038_MAP10_REFUSAL_2026-11-02.md.

L’audit du refus local est clos, mais la disponibilité sur le serveur historique 4.20.0.315, la priorité runtime, les chaînes et l’acceptation restent ouvertes. ITEM-1038-SCOPE reste partiel; aucun statut modifié.

Prochain lot précis : ITEM-1037-SCOPE. Réutiliser l’identité/membership native, shop_foundation, admission et le reçu V832 du test all_31_admitted_items_still_buy_through_the_normal_map10_command_path si les versions concordent; qualifier le consumer de dégâts. Ne pas rehash ni relancer de tests sans nécessité nouvelle.


## V836 — objet 1037 : FlatPhysicalDamageMod

Preuves natives réutilisées : OLS-3c0238b4-a342-5b4e-a81f-7c18e7ecf36a, Price=875, +25 dégâts d’attaque, InStore/CanBeSold vrais, membership concordante. Le catalogue reprend le SHA, les dégâts et le prix; Map10 admet 1037. Le consumer est shop::bonuses → progression::stats. Le test V832 des 31 objets admis couvre l’achat/inventaire/débit, pas la valeur Stats.damage. Les empreintes actuelles des sources/catalogues matchent celles du reçu, mais le binaire du 21 octobre n’est pas lié aux sources exactes. Aucun test relancé. Rapport : docs/AUDIT_SYS01202_ITEM1037_DAMAGE_PURCHASE_2026-11-02.md.

Sous-audit source/donnée/consumer clos pour cette liaison locale; comportement +25 au runtime, disponibilité historique, prix de vente natif et acceptation restent ouverts. ITEM-1037-SCOPE et SYS-01.2-02 inchangés.

Prochaine unité : choisir une exigence requise distincte après déduplication des rapports et reçus; préserver le prérequis D01-SYS-01-1 et ne pas répéter les liens déjà documentés.


## V837 — consommable 2003 : consumer courant et fraîcheur des preuves

La source native et les preuves potion existantes sont réutilisées, sans rehash ni nouveau test : OLS-60c40120-0caa-524d-949f-a67b04c48944, 2003.inibin, SpellName=RegenerationPotion, UseEffect=true, MaxStack=5, Price=35 et SellBackModifier=0.4; membership au manifeste 4.20 concordante. La donnée locale expose une potion PV 150/15 s, prix 35, revente 14 et admission Map10. Le consumer Rust courant passe par shop::buy_item puis consumables::use_item/advance_consumables; use_item utilise le nom natif pour les gardes de contrôle, et l’effet chiffré vient de la donnée locale.

La preuve des nombres 150/15 s repose sur le descriptif natif et le catalogue Data Dragon 4.20.1; les corps serveur d’origine ne sont pas récupérés. Le script communautaire RegenerationPotion.cs est une corroboration communautaire, pas une autorité native. Les preuves historiques potion_sources.json, potion_integration_progress.json, potion_live_validation.json et potion_network_validation.json datent du 4 octobre et restent explicitement complete=false.

Contrôle de fraîcheur en lecture seule : les six empreintes actuelles consumables.rs, shop.rs, spells.rs, lib.rs, client/shop_ui.rs et shop_foundation.json diffèrent toutes de celles consignées dans potion_integration_progress.json. Les 375 tests Core, les 8 contrôles réseau, la capture et l’exécution d’octobre ne qualifient donc pas les sources actuelles. Aucun test/build/runtime n’a été relancé dans V837.

Résultat : le consumer courant et le lien data local sont identifiés; l’autorité historique de l’effet, le comportement actuel vérifié par build lié aux sources, les visuels/audio/HUD et l’acceptation restent ouverts. ITEM-2003-SCOPE et SYS-01.2-02 restent partiels. Aucun registre, code, goal, Plan, application ou base modifié.

Prochaine unité : ITEM-2004-SCOPE, réutiliser les reçus potion communs et contrôler uniquement son SpellName/consumer mana distinct; ne pas relancer les suites d’octobre sans autorisation de vérification et binaire lié aux sources actuelles.


## V838 — consommable 2004 : consumer mana

Source native existante réutilisée : OLS-7280ca15-830f-5756-a845-ac1a23ff6cf1, SpellName=FlaskOfCrystalWater, UseEffect=true, MaxStack=5, Price=35, SellBackModifier=0.4; membership au manifeste sélectionné concordante. Le catalogue local relie le même SHA à une potion Mana de 100/15 s, revente 14 et admission Map10. Le consumer courant use_item sélectionne FlaskOfCrystalWater, refuse un champion sans mana ou au mana plein, puis consomme une unité et programme la durée; advance_consumables applique le mana par tick si le champion utilise le mana.

La quantité/durée vient du descripteur et du catalogue comparatif 4.20.1; le corps serveur historique de FlaskOfCrystalWater reste non récupéré. Les reçus potion du 4 octobre sont réutilisés mais non actuels : le contrôle V837 a déjà établi le changement des six empreintes suivies. Aucun test/build/runtime relancé.

Lien statique source→donnée→consumer documenté; sémantique serveur, kit courant de dépense de mana, validation réseau actuelle et acceptation restent ouverts. ITEM-2004-SCOPE et SYS-01.2-02 restent partiels. Aucun code, registre, goal, Plan, application ou base modifié.

Prochaine étape : sélectionner une relation exigée distincte sans rapport dédié après déduplication; garder les constats 2003/2004 réutilisables et ne pas répéter leurs reçus.


## V839 — SYS-01.2-02, objet 2001 : absence du consumer courant

Le reçu existant compare DATA/Items/2001.inibin à un export communautaire : 62/62 champs égaux. La provenance exacte du snapshot et la sémantique serveur restent inconnues. Le catalogue actuel n’a pas d’entrée 2001; quote/achat Core et boutique UI dépendent de ce catalogue; le consumer consommable ne traite que 2003/2004. Contrôle nominal et refus attendu documentés statiquement. Aucun test, build, achat ou runtime exécuté.

Sous-audit statique du consumer terminé pour 2001; fonctionnalité absente/non qualifiée, acceptation non demandée. Aucun code, registre, goal, Plan, application ou base modifié. Rapport : docs/AUDIT_SYS01202_ITEM2001_CONSUMER_ABSENCE_2026-11-02.md. Reprise seulement si un export natif décodé, une membership de release ou une règle serveur versionnée établit que l’ID est actif et jouable sur Map10.


## V840 — SYS-01.2-02, objet 3135 : pénétration magique

Lien statique source→catalogue→consumer terminé : la ressource 3135 est comparée 68/68 à l’export communautaire; le catalogue local reprend 35 % de pénétration et Map10 l’admet; shop.rs transmet le bonus via progression.rs jusqu’au chemin penetration.rs/damage.rs. Les tests présents couvrent la formule, le hit magique et la non-cumulabilité, mais ne sont pas exécutés ici.

Les reçus d’intégration/live du 4 octobre restent complete=false et les empreintes shop.rs, progression.rs, damage.rs, spells.rs et shop_foundation.json diffèrent. Ils ne qualifient pas l’exécution actuelle; aucun test/build/runtime dans V840. Rapport : docs/AUDIT_SYS01202_ITEM3135_MAGIC_PENETRATION_CONSUMER_2026-11-02.md. Goal parent et vérification runtime restent ouverts.

## V841 — SYS-01.2-02, objet 3035 : pénétration d’armure physique

Audit statique source→donnée→consumer clôturé pour le passif du Dernier souffle : `Data*Effect1Amount=0.349999994` décodé du fichier natif 3035 (hash vérifié), 68/68 champs concordants avec le miroir communautaire dont le commit exact reste inconnu; catalogue local `armor_penetration_percent=0.35`, source SHA concordante et admission Map10 vraie. Chaîne actuelle `shop::bonuses → progression::stats → penetration::effective → damage` identifiée. Le modèle code 100 armure→65 avant mitigation et conserve les armures non positives; résultat statique uniquement.

Tests sources repérés mais non exécutés; pas de build, achat, dégât, réseau ou runtime. Sémantique serveur, precedence runtime, empilement d’objets différents et acceptation restent ouverts. Rapport : `docs/AUDIT_SYS01202_ITEM3035_ARMOR_PENETRATION_2026-11-02.md`. Aucun code, registre/statut, goal, Plan, application ou base modifié.

Prochaine action bornée : sélectionner une autre liaison non auditée à partir des preuves existantes. Reprendre le runtime 3035 uniquement avec une vérification autorisée liée aux empreintes courantes.

## V842 — SYS-01.2-02, objet 3134 : pénétration d’armure plate

Le champ natif `Data*Effect2Amount=10` (INIBIN 3134, hash rehaché), la comparaison communautaire 72/72 et le reçu de membership sont réutilisés/vérifiés. Le catalogue Map10 associe le SHA natif à `armor_penetration=10`; le chemin physique commun est réutilisé depuis V841 et ses empreintes n’ont pas changé. L’audit statique du lien 3134 est clos. Les tests sources existants comprennent deux achats 3134→une seule stat 10, mais ils n’ont pas été exécutés.

Aucun build ou runtime; sémantique serveur, precedence effective, résultat isolé, réseau et acceptation restent ouverts. Rapport : `docs/AUDIT_SYS01202_ITEM3134_FLAT_ARMOR_PENETRATION_2026-11-02.md`. Aucun code, statut, goal, Plan, application ou base de suivi modifié.

Prochaine action : sélectionner une autre liaison précise non couverte, en réutilisant les reçus actuels et sans refaire la chaîne physique commune.

## V843 — SYS-01.2-02, objet 3020 : pénétration magique plate

`Data*Effect1Amount=15` est décodé du natif 3020 rehaché; le membership et l’admission Map10 sont confirmés. Le catalogue reprend le SHA et `magic_penetration=15`; le consumer magique est réutilisé des audits V840–V841. Le reçu comparatif existant indique 72 égaux et une clé native manquante non nommée; un contrôle direct retrouve les 52 champs communautaires `Values.Data` dans l’INIBIN, dont `Effect1Amount`. La clé du compte global demeure inconnue et est signalée sans invalider ce lien ciblé.

Audit statique de la valeur 3020 clos. Tests source repérés, non exécutés; aucun build/runtime. Sémantique serveur, precedence et acceptation restent ouvertes. Rapport : `docs/AUDIT_SYS01202_ITEM3020_FLAT_MAGIC_PENETRATION_2026-11-02.md`. Aucun code, statut, goal, Plan, app ou base modifié.

Prochaine action : choisir une liaison distincte, en réutilisant les consumers/hashes communs et en n’élargissant pas la recherche sur la clé inconnue sans nouvelle raison.

## V844 — SYS-01.2-02, objet 3136 : pénétration magique

La piste sémantique de `Effect1Amount=15` est maintenant établie par la localisation native en_GB `fontconfig_en_GB.txt`, clé `game_item_description_3136` ligne 6779 : le client nomme explicitement +15 pénétration magique. Les hashes et memberships de l’INIBIN et de la localisation sont concordants; 70 champs de l’INIBIN correspondent au miroir communautaire. Catalogue Map10 et consumer courant 15 reliés. Audit documentaire limité clos.

Les tests qui emploient 3136 (achat/doublon, dégâts magiques et sort) sont repérés mais non exécutés. Exécution actuelle, logique serveur, réseau et acceptation restent ouvertes. Rapport : `docs/AUDIT_SYS01202_ITEM3136_MAGIC_PENETRATION_2026-11-02.md`. Aucun code ou statut de suivi modifié.

Suite : choisir une autre relation distincte après déduplication et réutiliser les consumers communs, sans refaire le mapping V840–V844.

## V845 — SYS-01.2-02, objet 3114 : régénération de mana

L’INIBIN natif décode `PercentBaseMPRegenMod≈0,6`; le tooltip primaire en_GB `game_item_description_3114` confirme +60 % de régénération de base et sa formule d’affichage. Le catalogue reprend la valeur et le SHA; Map10 l’admet. Consumer `shop::bonuses → regeneration_rates/advance_regeneration` identifié et rehaché. Audit statique clos.

Les preuves runtime de l’objet 1004 ont été réutilisées uniquement pour le consumer commun; elles ne valident pas le 3114. Aucun test, build ou runtime 3114 n’a été exécuté. Arrondi en jeu, serveur, réseau et acceptation restent ouverts. Rapport : `docs/AUDIT_SYS01202_ITEM3114_BASE_MANA_REGEN_2026-11-02.md`. Goal et statuts inchangés.

Prochain lot : choisir une relation distincte non auditée après déduplication.


## V846 — SYS-01.2-02, vérification ciblée du harnais de pénétration

Le binaire local existant a exécuté les 7 tests de penetration (3020, 3035, 3134, 3135, 3136) : 7 réussis, 0 échec; refus d’entrées invalides et de doublons de groupe testés. SHA du binaire, code et données relus dans AUDIT_SYS01202_PENETRATION_CURRENT_TESTS_2026-11-02.md. Cargo n’a pas pu ouvrir son verrou dans cette session; aucune recompilation revendiquée. Vérification du simulateur seulement; serveur, precedence effective, réseau et acceptation restent ouverts. 3114 n’a pas de preuve d’exécution dédiée. Goal, tâches, Plan, interface, base et checkpoint inchangés. Prochain lot : définir et vérifier un cas d’achat/régénération spécifique à 3114.

## V847 — vérification structurelle du résolveur SYS-01.2-02

Le résolveur courant a accepté SYS-01.2-02 et refusé une tâche inconnue; Python 3.12.14 a validé la cohérence structurelle du registre : 42 215 exigences, 100 405 sources, 5 759 consommateurs, 26 189 inconnues ouvertes, 5 517 résolues. Zéro hash de source vérifié; les 5 inconnues de la fiche restent ouvertes. Les chiffres joints sont anciens. Rapport et empreintes : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md. La méthode précise maintenant l’interpréteur et la portée verify_files=false. Pas de registre/tâche/goal/Plan/UI/app/base modifié; checkpoint mis à jour pour reprise.

## V848 — disponibilité REA pour OLU-3293

Contrôle local : REA, backends natifs et modules Python de désassemblage absents; aucun paquet rea-agents en cache. Pas d’installation/setup, conformément à la restriction. OLU-3293 reste ouvert; reprise seulement sur backend déjà disponible/autorisé ou nouvel artefact donnant le writer de 0x14ae870. Détails dans le supplément V848 du rapport de traçabilité.

## V849 — consumer natif Morgana base

Cas ciblé Morgana base/skinID 25000 : resolve reproduit exactement la liaison native enregistrée et refuse 25001. Le test utilise le consumer F avec son helper F préchargé; l’import ordinaire du module priorise encore E, dont le fichier courant n’a pas été lu. Aucun rendu/dispatch runtime ni acceptation qualifiés. Rapport de traçabilité, supplément V849.


## V850 — SYS-01.2-02, Morgana skin 1

Probe ciblé réussi : SkinID 25001 reproduit exactement la ligne native `MeshSkin1`/FallenMorgana du registre; SkinID erroné 25002 refusé sans liaison. Test isolé avec helper F préchargé, car le consumer privilégie encore le chemin E:/OpenLeague; l’import normal reste non qualifié. Pas de preuve de sélection/rendu runtime, aucune tâche/statut/goal/app/base modifié. Audit de liaison clos, fonctionnalité non terminée. Détails : supplément V850 dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.

Prochaine unité : choisir une relation source-consommateur distincte et encore non couverte dans le registre actif; éviter les relectures Morgana/V849 et garder les cinq inconnues ouvertes faute de nouvel artefact primaire.



## V851 — replay complet des configurations de peau

Le consumer a reproduit exactement les 668/668 identités du registre natif 4.20 : 656 résolues, 5 équivalentes, 7 ambiguës. Les 7 ambiguïtés sont les skins Renekton 0–6 : deux emplacements natifs ont le même SkinID, mais `SkinScale` diffère (1,56 ou 1,48 contre 1,60). Il manque une preuve primaire de priorité du chargeur pour connaître la valeur effectivement utilisée. Replay avec consumer/helper F:, sources D:, aucun runtime ni fichier de code écrit; import normal encore non qualifié à cause de E:. Détails et hashes : supplément V851 du rapport de traçabilité.

Reprise ciblée uniquement sur une preuve 4.20 de priorité des deux chemins Renekton ou une trace native/runtime du fichier effectivement chargé. Ne pas répéter le replay, installer REA, ni modifier les statuts.



## V852 — sources RADS des configs Renekton

Vérification ciblée des huit configs sur D: contre le manifeste client sélectionné sur F: : 8/8 concordent en octets, SHA-256 et MD5. Le parent Renekton.inibin appartient au contenu 0.0.1.7; les sept configs dédiées (base et skins 1–6) au contenu 0.0.0.249. Les deux sources sont présentes dans le projet sélectionné, ce qui ne prouve pas la priorité du chargeur. Les sept divergences SkinScale restent ouvertes. Les sources publiques consultées décrivent le format ou l’évolution postérieure, sans règle historique 4.20. Détails et IDs dans le supplément V852.

Reprise seulement sur trace/provider natif 4.20 ou exécution du client exact montrant le fichier et SkinScale consommés. Ne pas répéter le replay global ni la recherche web générique.



## V853 — sources natives de maîtrise 4312/4313

Les deux sources INIBIN sont vérifiées, membre du manifeste sélectionné et liées à l’exigence SYS-01.2-02. Le rapport source → consumer existant a été réutilisé; vérification `rg` ciblée actuelle : aucun callsite Rust de maîtrise, seulement le commentaire de non-prise en charge et une occurrence Master Yi sans rapport. `SpellData.Ranks=4` ne fixe pas le `Talent.maxRank` effectif. Tâches MASTERY-4312/4313-SCOPE restent `a_qualifier`; aucun code/statut modifié. Détails dans le supplément V853.

Reprise uniquement sur un lecteur primaire de Ranks/maxRank ou une valeur serveur versionnée, puis mapping vers un consumer gameplay réel; ne pas répéter les recherches négatives de noms.



## V854 — lien item 1027 revalidé

Source OLS-b2c39141 et consumer OLC-b38bc16e sont présents dans la sous-trace ITEM-1027 et la source figure aussi dans SYS-01.2-02. Les quatre hashes code/données du reçu V828 concordent toujours. Test direct du binaire existant (hash V831) : le cas Ahri +200 mana, Akali sans gain d’énergie et absence de régénération mana inventée passe 1/1. Cargo s’arrête avant test sur accès refusé à `.cargo-build-lock`; aucune recompilation. Sous-audit source/consumer clos, `ITEM-1027-SCOPE` reste partiel. Détails : supplément V854.

Prochaine unité : choisir une autre relation du registre parent avec source ID et consumer courant tous deux présents; éviter les lots déjà vérifiés et distinguer le mapping du comportement serveur.


## V855 — item 1033, lien de résistance magique

La source native 1033 est rehachée et membre du manifeste sélectionné; l’extraction existante et le catalogue concordent à +25 MR. Le consumer shop → stats → mitigation est identifié. Deux tests exécutés directement sur le binaire existant passent (ID 1033 dans le chemin de dégâts; refus de l’ID non implémenté 1057). Le test 1033 ne vérifie ni achat ni hausse numérique exacte de +25. Sous-audit de liaison clos; ITEM-1033-SCOPE demeure partiel et le parent reste ouvert. Aucun code ou statut de tâche modifié. Détail : docs/AUDIT_SYS01202_ITEM1033_MAGIC_RESIST_2026-11-02.md.

Prochain lot : sélectionner une paire source-consumer distincte du registre parent, déjà présente et non couverte; réutiliser les preuves stables, puis séparer résultat d’audit, fonctionnement local et preuve historique/acceptation. Ne pas refaire 1027 ou 1033.

## V856 — potion de soin 2003, lien et consumer

INIBIN item 2003 rehaché et membre RADS; UseEffect, SpellName et pile 5 confirmés. Le montant/durée 150 PV/15 s vient du catalogue officiel 4.20.1, pas du champ INIBIN item. consumables.rs contient le vrai consumer d’usage/tick, absent des consumers liés à cette sous-trace; les sources natives du sort figurent au registre global mais pas à la tâche. Quatre tests directs sur le binaire existant passent, dont cadence, file et refus atomiques. Implémentation locale constatée; trace, script natif/serveur et acceptation restent ouverts. Rapport : docs/AUDIT_SYS01202_ITEM2003_HEALTH_POTION_2026-11-02.md.

Prochaine unité : traiter ITEM-2004-SCOPE séparément seulement après reprise du même critère source/consumer, en réutilisant les tests communs sans recompter la preuve 2003. Ensuite choisir une paire encore requise dans la trace parent. Ne modifier ni statut ni registre sans autorisation.

## V857 — potion de mana 2004, lien et consumer

INIBIN 2004 rehaché et membre RADS; UseEffect, FlaskOfCrystalWater, ManaPotion et pile 5 confirmés. La valeur 100 mana/15 s est celle du catalogue 4.20.1, reprise dans le catalogue F:. Le chemin local consumables.rs traite les mana-potions et refuse les champions sans mana. Un test nouveau confirme que 2004 n’est pas réduit par Ignite; les tests de total et de refus manaless de V856 sont réutilisés avec empreintes identiques. Le sub-trace ne lie ni consumables.rs ni les sources du sort. ITEM-2004-SCOPE reste partiel; aucun code ou statut n’a changé. Détail : docs/AUDIT_SYS01202_ITEM2004_MANA_POTION_2026-11-02.md.

Prochaine unité vérifiée : ITEM-3024-SCOPE est liée à une source présente dans le parent, possède un consumer courant, n’a aucun rapport ciblé et demeure partielle. Reprendre avec un nominal et une limite, sans répéter les contrôles 2003/2004.


## V858 — Glacial Shroud 3024, audit du lien source-consumer

La paire de la sous-trace ITEM-3024-SCOPE est documentée : INIBIN 4.20.0.315 rehaché et membre RADS, entrée locale liée par hash, consumer boutique/stats/cooldown repéré. Le test direct existant passe 1/1 sur le plafond CDR avec 3024 parmi plusieurs objets; il ne vérifie pas les bonus isolément. La ligne native décodée ne donne pas de CDR numérique. Map10=true reste une donnée du simulateur, sans preuve historique concluante. Sous-audit de liaison terminé; tâche ITEM-3024 et goal restent ouverts.

Reprise suivante : prendre ITEM-3025-SCOPE après vérification de sa sous-trace et de son consumer. Pour compléter la fonctionnalité 3024, reprendre seulement sur une source historique Map10/CDR ou un test isolé exact; ne pas refaire le rehash ni le test agrégé si les empreintes restent identiques.


## V859 — Iceborn Gauntlet 3025, refus explicite du consumer

La source native 3025 est re-hachée et membre du manifeste enregistré. L’objet n’existe pas dans shop_foundation ni dans l’admission Map10; shop.rs le refuse explicitement avant la vérification de carte. Le test existant passe sur un autre ID inconnu (1057), pas sur 3025 : le résultat précis pour 3025 est confirmé par l’ordre du code et reste à tester directement. InStore=true dans l’INIBIN ne prouve pas la disponibilité historique Map10. La tâche reste a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3025_ICEBORN_GAUNTLET_REFUSAL_2026-11-02.md.

Reprise : ouvrir l’entrée officielle 4.20.1 /data/3025 déjà référencée, qualifier la carte/prix/recette, puis tester le refus exact ou implémenter les données validées. Ensuite passer à ITEM-3026-SCOPE sans répéter le rehash ni le test générique.


## V860 — source officielle 4.20.1 de 3025

L’entrée officielle 4.20.1 a été vérifiée avec son SHA enregistré : prix de base 750, total 2900, revente 2030, recette 3057/3024, +500 mana, +60 armure, +30 puissance et passif Spellblade (+10 % CDR). Elle concorde avec les champs natifs disponibles. Son champ maps est null; l’admission historique Map10 reste inconnue. ITEM-3025-SCOPE reste a_qualifier, sans modification de statut. Source relue en lecture seule dans l’archive de référence E:; les fichiers du projet restent sur F:.

Prochaine unité : ITEM-3026-SCOPE. Ne pas répéter l’inspection de la source 3025 ni le test générique 1057 sans nouvelle preuve.


## V861 — Guardian Angel 3026, indisponible sur Map10

La source Riot 4.20.1 déclare maps["10"]=false; le natif confirme 3026 InStore, base 1500 et recette 1033/1031, sans annuler la restriction par carte. Prix total 2750, revente 1100, +50 armure, +40 RM et passif de résurrection sont documentés. L’absence locale Map10 concorde avec la référence; le consumer refuse génériquement avant la garde carte. Source-scope audité; aucun statut n’a été changé et aucune fonctionnalité n’est déclarée terminée.

Reprise suivante : ITEM-3027-SCOPE. Ne pas refaire le rehash 3026 ni le test générique 1057; revenir à 3026 uniquement si on travaille une autre carte ou si un test direct de refus est demandé.


## V862 — Rod of Ages 3027, sources et limites de périmètre

INIBIN 4.20.0.315 rehaché (592 octets) : base 740, recette 3010/1026, +450 PV/+450 mana, SpellName RodOfAgesDummySpell. Data Dragon 4.20.1 : total 2800, +60 AP, cumuls et Valor’s Reward détaillés. Le champ maps est absent, donc disponibilité Map10 inconnue. L’objet manque au catalogue/admission locaux et le consumer le refuse génériquement; test 1057 réutilisé, aucun test 3027. Tâche reste a_qualifier.

Prochaine unité : ITEM-3028-SCOPE; ne pas refaire les rehashs ou le test générique sans nouvelle preuve.


## V863 — Chalice of Harmony 3028, source et consumer

INIBIN rehaché (515 octets) : base 140, recette 1004/1033/1004, +25 MR et +50 % régénération mana de base. Data Dragon 4.20.1 confirme total 1000, revente 700 et Mana Font (1,5 % du mana manquant / 5 s). Champ maps absent : admission Map10 inconnue. Objet absent du catalogue/admission locaux; refus générique shop.rs. Test 1057 réutilisé, aucun test 3028. Statut a_qualifier inchangé.

Prochaine unité : ITEM-3029-SCOPE; ne pas répéter rehash/test générique sans nouvelle preuve.


## V864 — Rod of Ages (Crystal Scar) 3029, exclusion Map10

Le catalogue officiel 4.20.1 déclare maps["10"]=false pour la variante Crystal Scar. INIBIN 4.20.0.315 : base 740, recette 3010/1026, +450 PV/+450 mana. Le total officiel est 2800; charges +20 PV/+20 mana/+2 AP toutes les 40 s (cap 10). L’absence locale est cohérente avec Map10. Consumer refuse génériquement avant la garde carte; test 1057 réutilisé, sans test direct 3029. Audit de périmètre clos, statut inchangé.

Prochaine unité : poursuivre l’ordre de la trace après 3029; ne pas refaire source/tests déjà vérifiés.


## V865 — Infinity Edge 3031, exclusion Map10

La source officielle Data Dragon 4.20.1 déclare maps["10"]=false pour Infinity Edge. L’INIBIN 4.20.0.315 confirme base 645, recette 1038/1037/1018, +80 dégâts et +25 % critique; le catalogue donne total 3800, vente 2660 et le passif à 250 % critique. L’absence locale Map10 est cohérente. Refus actuel générique; test 1057 réutilisé, pas de test 3031. Sous-audit source/périmètre clos, statut inchangé.

Prochaine unité : ITEM-3035-SCOPE; ne pas refaire les contrôles génériques.


## V866 — 3035, vérification dynamique ciblée

Deux tests existants du consumer de pénétration passent sur le binaire inchangé : dégâts sur monstres/tourelles avec 3035+3134 et limites de la formule (plancher, résistance non positive, entrée invalide). Ils complètent l’audit statique existant; aucun test 3035 isolé. Admission locale Map10=true, mais la source officielle n’a pas de champ maps; historique Map10, serveur et acceptation restent ouverts. Tâche reste partielle.

Reprise : continuer la prochaine paire requise sans refaire les tests 3035, sauf pour un test exact d’achat isolé.


## V867 — Seraph’s Embrace 3040, évolution non qualifiée

Le natif porte InStore=0, UseEffect=true et SpellName ItemSeraphsEmbrace. Data Dragon 4.20.1 confirme purchasable=false, from=3003, +1000 mana, +60 AP, passif Insight et actif Mana Shield; maps manque. Le refus d’achat direct est cohérent. Les données locales 3003/3040 et le consumer d’évolution sont absents; la transformation et Map10 restent inconnues. Pas de test 3040. Tâche a_qualifier inchangée.

Reprise : chercher une source primaire de l’évolution 3003→3040 et sa portée carte; ne pas répéter l’identité native ou le test générique de refus.


## V868 — Mejai’s Soulstealer 3041, exclusion Map10

Data Dragon 4.20.1 déclare maps["10"]=false. L’INIBIN a InStore=true, prix de base 965 et recette 1052, mais cela n’annule pas la restriction de carte. Le catalogue donne total 1400, +20 AP et passif à charges jusqu’à +15 % CDR. L’absence locale Map10 est cohérente; refus générique, test 1057 réutilisé. Sous-audit source/périmètre clos, statut inchangé.

Prochaine unité : ITEM-3042-SCOPE; ne pas répéter le contrôle générique.


## V869 — Muramana 3042, évolution non qualifiée

Les sources 4.20.0.315/4.20.1 confirment InStore=0 et purchasable=false, depuis 3004. La fiche donne +25 dégâts/+1000 mana, passif Awe et toggle consommant 3 % du mana pour des dégâts physiques. Les champs maps manquent; portée Map10 inconnue. Données 3004/3042 absentes localement, refus shop générique. Pas de test 3042/toggle. Tâche a_qualifier inchangée.

Reprise : source primaire de l’évolution 3004→3042 et son périmètre de carte; ensuite consumer/toggle.

## V870 — ITEM-3043-SCOPE, Muramana 3043

Source native 4.20.0.315 rehachée (585 octets); Data Dragon 4.20.1 confirme achat direct impossible et maps 1/10/12 désactivées. L’ID est absent du catalogue local; shop.rs refuse avant la garde Map10. Test générique inconnu réutilisé (ID 1057), aucun test 3043. La relation officielle from=3008 ne correspond pas aux champs recette natifs à zéro; évolution non qualifiée. Audit de périmètre documenté, tâche a_qualifier et goal inchangés.

Reprise : lot ITEM-3044-SCOPE, Phage; ne pas rejouer la branche générique de refus.
## V871 — ITEM-3044-SCOPE, Phage

Le natif 4.20.0.315 (520 octets) concorde avec le manifeste; Price=565, InStore=1, recette 1028+1036. Data Dragon 4.20.1 confirme purchasable=true, total1325, +200 HP/+20 AD et sorties 3078/3184. maps=null. L’ID est absent du catalogue/admission locaux; shop.rs le refuse comme non implémenté. Test inconnu réutilisé sur 1057, pas de test 3044. Audit des champs clos; Map10 et runtime restent inconnus; tâche a_qualifier.

Reprise : source primaire d’admission Map10 pour 3044, puis test direct; prochain après cela, ITEM-3046-SCOPE.
## V872 — ITEM-3046-SCOPE, Phantom Dancer

Natif 4.20.0.315 rehaché (543 octets), membre manifesté; Price=520, InStore=1, recette 1018+3086+1042. Data Dragon 4.20.1 confirme total 2800, +50 % AS/+30 % critique/+5 % déplacement; maps=null. Ligne absente localement; shop.rs refuse l’ID manquant. Test générique 1057 réutilisé, aucun test direct 3046. Prix/recette documentés; Map10 et runtime restent inconnus. Tâche a_qualifier.

Reprise : source Map10 propre à 3046; prochain lot ITEM-3047-SCOPE (Ninja Tabi).
## V873 — ITEM-3047-SCOPE, Ninja Tabi

Natif 4.20.0.315 rehaché (558 octets), membre manifesté; prix 375, InStore=1, recette 1001+1029. Data Dragon 4.20.1 : total 1000, +25 armure/+45 déplacement, passif anti-attaques de base; maps=null. Ligne absente localement, refus statique dans shop.rs. Test générique 1057 réutilisé, aucun test direct 3047. Map10/runtime non décidés; tâche a_qualifier.

Reprise : source primaire Map10 pour 3047; prochain lot ITEM-3048-SCOPE (Seraph's Embrace).
## V874 — ITEM-3048-SCOPE, Seraph's Embrace

Natif 4.20.0.315 rehaché (604 octets), InStore=0, UseEffect=1, SpellName ItemSeraphsEmbrace. Data Dragon 4.20.1 confirme purchasable=false, from=3007, effets Insight/Mana Shield et maps 1/10/12=false. ID et source 3007 absents localement; shop.rs refuse l’ID absent. Test générique 1057 réutilisé, pas de test 3048. Portée Map10 clarifiée par catalogue; évolution/runtime restent ouverts; tâche a_qualifier.

Reprise : preuve/consumer de l’évolution 3007→3048; prochain lot ITEM-3050-SCOPE (Zeke's Herald).
## V875 — ITEM-3050-SCOPE, Zeke's Herald

Natif 4.20.0.315 rehaché (579 octets), InStore=1, prix 800, recette 3067+1053. Data Dragon 4.20.1 : total 2450, +250 HP/+20 % CDR, aura alliée +10 % vol de vie/+20 AD; maps=null. ID absent des données locales, refus statique shop.rs. Test générique 1057 réutilisé; aucun test direct 3050/aura. Map10 et runtime restent inconnus; tâche a_qualifier.

Reprise : source primaire Map10 et consumer d’aura; prochain lot ITEM-3056-SCOPE (Ohmwrecker).
## V876 — ITEM-3056-SCOPE, Ohmwrecker

Natif 4.20.0.315 rehaché (620 octets), InStore=1, actif ItemFaithShaker, recette 2053+3067. Data Dragon 4.20.1 : total 2600, stats/actif tourelle; maps ne marque que 12=false, pas 10. Ligne absente localement et refus statique shop.rs; test générique 1057 réutilisé, aucun test 3056/actif. Map10 et runtime ouverts; tâche a_qualifier.

Reprise : preuve primaire Map10 puis test direct; prochain lot ITEM-3057-SCOPE (Sheen).
## V877 — ITEM-3057-SCOPE, Sheen

Natif 4.20.0.315 rehaché (543 octets), InStore=1, prix 365, recette 1027+1052. Data Dragon 4.20.1 confirme total 1200, +200 mana/+25 AP, Spellblade et sorties 3078/3100/3025; maps=null. ID absent localement et refusé par shop.rs. Test générique 1057 réutilisé; aucun test direct 3057/Spellblade. Map10 et runtime ouverts; tâche a_qualifier.

Reprise : preuve primaire Map10, puis test direct; prochain lot ITEM-3060-SCOPE (Banner of Command).
## V878 — ITEM-3060-SCOPE, Banner of Command

Natif 4.20.0.315 rehaché (642 octets), InStore=1, SpellName ItemPromote, recette 3105+3108. Data Dragon 4.20.1 : total 3000, aura Legion et actif Promote, maps=null. Ligne absente localement; shop.rs refuse l’ID. Test générique 1057 réutilisé, aucun test direct/aura/Promote. Map10/runtime ouverts; tâche a_qualifier.

Reprise : source primaire Map10 et consumer Promote; prochain lot ITEM-3065-SCOPE (Spirit Visage).
## V879 — ITEM-3065-SCOPE, Spirit Visage

Natif 4.20.0.315 rehaché (566 octets), InStore=1, prix 700, recette 3211+3067. Data Dragon 4.20.1 : total 2750, +400 HP/+55 MR/+100 % regen HP/+10 % CDR et passif de soins +20 %; maps=null. Ligne locale absente, refus shop.rs. Test générique 1057 réutilisé; aucun test direct 3065/passif. Map10/runtime ouverts; tâche a_qualifier.

Reprise : preuve primaire Map10 et test direct; prochain lot ITEM-3067-SCOPE (Kindlegem), déjà partiel dans le registre.
## V880 — ITEM-3067-SCOPE, Kindlegem

Natif 4.20.0.315 rehaché, Price=450, InStore=1, recette 1028. Data Dragon 4.20.1 base450/total850/sell595; local 3067 price850, recette1028, +200 HP/+10 % CDR: correspondance cohérente. Admission Map10 locale=true, issue de la config bâtie depuis DD 4.20.1, mais maps=null ne prouve pas l’inclusion historique. Pas de test direct/runtime 3067. Sous-audit de cohérence couvert; statut partial_a_terminer inchangé, acceptation Map10 ouverte.

Reprise : preuve Map10 primaire ou justification de la règle d’admission, puis test direct; prochain ITEM-3068-SCOPE à vérifier.
## V881 — ITEM-3068-SCOPE, Sunfire Cape

Natif 4.20.0.315 rehaché (537 octets), InStore=1, prix 850, recette 1031+1011. Data Dragon 4.20.1 : total 2600, +450 HP/+45 armure, passif 25+niveau/sec; maps=null. ID absent localement, refus statique shop.rs. Test inconnu 1057 réutilisé; aucun test direct 3068/passif. Map10/runtime ouverts; tâche a_qualifier.

Reprise : preuve Map10 et test direct; prochain ITEM-3069-SCOPE (Talisman of Ascension).
## V882 — ITEM-3069-SCOPE, Talisman of Ascension

Natif 4.20.0.315 rehaché (677 octets), prix 635, InStore=1, recette 3096+3114, groupe GoldBase, actif shurelyascrest. Data Dragon 4.20.1 : total 2100/vente 840, gains Favor, actif et limite d’objet de revenu; maps=null. ID absent localement, refus statique shop.rs. Test 1057 réutilisé; aucun test direct 3069. Map10/effets runtime ouverts; tâche a_qualifier.

Reprise : preuve Map10 et tests propres aux effets; prochain ITEM-3070-SCOPE (Tear of the Goddess).
## V883 — ITEM-3070-SCOPE, Tear of the Goddess

Natif 4.20.0.315 rehaché (609 octets), InStore=1, prix 140, recette 1027+1004. Data Dragon 4.20.1 : total 720, into 3003/3004, Mana Charge et plafond +750; maps=null. ID absent localement; shop.rs refuse. Test mana 1027 réutilisé comme contexte, pas comme preuve 3070; aucun test direct de charge. Map10 et évolution/runtime ouverts; tâche a_qualifier.

Reprise : preuve Map10 et test direct des stacks/cadence; prochain ITEM-3071-SCOPE (The Black Cleaver).
## V884 — ITEM-3071-SCOPE, The Black Cleaver

Natif 4.20.0.315 rehaché (584 octets), InStore=1, prix 1263, recette 3134+1028. Data Dragon 4.20.1 : total 3000, +200 HP/+50 AD/+10 % CDR, +10 pénétration et passif cumulable jusqu’à 25 %; maps=null. ID absent du shop local, refus statique shop.rs. Test 1057 réutilisé, aucun test direct 3071/charges. Map10/runtime ouverts; tâche a_qualifier.

Reprise : preuve primaire Map10 puis test achat/passif; prochain ITEM-3072-SCOPE (The Bloodthirster).
## V885 — ITEM-3072-SCOPE, The Bloodthirster

Natif 4.20.0.315 rehaché (564 octets), InStore=1, prix 1150, recette 1053+1038. Data Dragon 4.20.1 : total 3500, +80 AD/+20 % vol de vie, bouclier de sursoin, maps[10]=false/12=false. Ligne locale absente, shop.rs refuse; cela correspond à l’exclusion Map10 du catalogue. Test générique 1057 réutilisé; aucun test direct/effet. Sources et restriction Map10 documentés; tâche a_qualifier.

Reprise : validation runtime seulement si l’implémentation 3072 entre dans le lot; prochain ITEM-3073-SCOPE (Tear of the Goddess — Crystal Scar).
## V886 — ITEM-3073-SCOPE, Tear (Crystal Scar)

Natif 4.20.0.315 rehaché (609 octets), InStore=1, recette 1027+1004. Data Dragon 4.20.1 : base 140/total 720, into 3007/3008, charge +5/+1, plafond 750; maps 10/12/1=false. Exclusion Map10 établie au catalogue; ligne locale absente et shop.rs refuse. Map8 non renseignée; aucun test direct 3073. Tâche a_qualifier.

Reprise : runtime direct si l’évolution map-spécifique est implémentée; prochain ITEM-3074-SCOPE (Ravenous Hydra).
## V887 — ITEM-3074-SCOPE, Ravenous Hydra

Natif 4.20.0.315 rehaché (607 octets), InStore=1, SpellName ItemTiamatCleave, recette 3077+1053. Data Dragon 4.20.1 : total 3300, +75 AD/+12 % vol de vie, Cleave/Crescent; maps=null. ID absent localement, refus statique shop.rs. Test générique 1057 réutilisé; aucun test 3074/melee/actif. Map10 et runtime ouverts; tâche a_qualifier.

Reprise : preuve Map10 et tests d’effets/melee; prochain ITEM-3075-SCOPE (Thornmail).
## V888 — SYS-01.2-02 / ITEM-3075

Liaison statique terminée pour OLF-a1955857 → source native OLS-9d782a4a → consumer shop.rs OLC-77cae4b8. SHA natif recalculé et égal au registre (502 octets); FlatArmorMod=100, prix de composant 1050, recette 1029+1031. Data Dragon 4.20.1 marque Map10 false; l’objet manque au catalogue local et le consumer le refuse comme non implémenté avant la garde carte. Aucun test direct/build/runtime exécuté.

Le lot de liaison est terminé, mais ITEM-3075-SCOPE reste `a_qualifier` : la donnée 4.20.1 et `InStore=1` ne démontrent pas l’admission historique du client 4.20.0.315 sur Map10. Reprise seulement sur un inventaire Map10 ou une politique de boutique historique primaire; détails et références : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V888). Lot suivant de la séquence : ITEM-3077-SCOPE; conserver la distinction de versions et ne pas reprendre les contrôles déjà faits sur 3075.
## V889 — SYS-01.2-02 / ITEM-3077

Lien statique couvert : exigence OLF-c43eb526 → INIBIN OLS-a551312d (596 octets, SHA conforme au registre) → consumer shop.rs OLC-77cae4b8. Champs natifs relus : composant 305, recette 1037+1036+1006+1006, +40 AD, +100 % régénération PV de base. Data Dragon 4.20.1 donne total 1900/vente 1330, mais aucun champ `maps`; 3077 est absent du catalogue/admission locaux et le chemin courant refuse l’ID non catalogué. Aucun test/build/runtime direct exécuté.

Le lot source→consumer est terminé; `ITEM-3077-SCOPE` reste `a_qualifier` et Tiamat n’est pas implémentée/acceptée. L’admission historique Map10 manque. Reprendre sur une preuve primaire 4.20.0.315; ne pas refaire les contrôles de 3077. Références : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V889). Prochain lot de séquence : ITEM-3078-SCOPE.
## V890 — SYS-01.2-02 / ITEM-3078

Liaison statique couverte : exigence OLF-180fa129 → INIBIN OLS-ab75a289 (589 octets, SHA égal au registre) → consumer shop.rs OLC-77cae4b8. Données natives décodées pour les composantes de Trinity Force; l’entrée manque aux deux catalogues locaux. Data Dragon 4.20.1 donne recette [3086,3057,3044], total 3703/vente 2592 et ne fournit pas de champ `maps`. Aucun test/build/runtime direct exécuté.

Le lot source→consumer est terminé; `ITEM-3078-SCOPE` reste `a_qualifier`, sans admission historique Map10 prouvée et sans fonctionnalité terminée. Reprise seulement sur preuve primaire 4.20.0.315. Détail intégré à `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V890). Prochaine tâche de scope existante : ITEM-3082-SCOPE.
## V891 — SYS-01.2-02 / ITEM-3083

Décision de périmètre auditée pour la référence officielle 4.20.1 : Warmog's Armor 3083 a `maps[10]=false` et `maps[12]=false`; son absence des catalogues locaux est cohérente avec une exclusion Map10. La source native 4.20.0.315 (548 octets) a été décodée et son SHA égale au registre; consumer et refus générique `shop.rs` reliés. Aucun test/build/runtime exécuté.

L’audit de scope au niveau du catalogue est terminé; cela ne prouve pas le résultat d’une exécution du client 4.20.0.315 et ne termine aucune fonctionnalité Warmog. `ITEM-3083-SCOPE` demeure `a_qualifier` dans le registre, inchangé par cette intervention. ITEM-3082 a été écarté de ce lot : sa trace était déjà complète et aucun champ/source ne décide Map10. Reprendre 3082 ou 3083 uniquement sur une source primaire Map10 propre à 4.20.0.315. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V891).
## V892 — SYS-01.2-02 / ITEM-3089

Décision de périmètre clôturée au niveau du catalogue officiel 4.20.1 : Rabadon's Deathcap `maps[10]=false`, cohérent avec l’absence de l’objet dans les deux catalogues Map10 locaux. Source native 4.20.0.315 rehachée (513 octets; SHA conforme), valeurs et consumer `shop.rs` reliés. Aucun test/build/runtime exécuté.

Le sous-audit de scope catalogue est terminé; l’implémentation/acceptation Deathcap n’est pas déclarée et `ITEM-3089-SCOPE` garde son statut `a_qualifier` dans le registre, non modifié. La vérification du runtime exact 4.20.0.315 reste ouverte jusqu’à une source primaire Map10. ITEM-3082 et 3084–3087 sont différés : les traces sont déjà liées ou la fiche n’expose pas `maps[10]`; ne pas produire de nouveaux rapports sans piste nouvelle. Références : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V892).
## V893 — SYS-01.2-02 / ITEM-3112

Décision de périmètre terminée au niveau du catalogue 4.20.1 : Orb of Winter `maps[10]=false`, cohérent avec l’absence des catalogues Map10 locaux. L’INIBIN natif 4.20.0.315 a été rehaché (594 octets; SHA conforme) et ses champs principaux sont reliés au consumer shop existant. Pas de test/build/runtime direct.

La feature bouclier n’est pas implémentée/acceptée; `ITEM-3112-SCOPE` reste `a_qualifier`, sans changement de registre. L’état exact au runtime 4.20.0.315 reste une limite distincte. ITEM-3084–3087, 3090–3098 ont été différés lorsque `maps[10]` était absent ou non décisif; prochain candidat explicitement exclu du plan : ITEM-3128-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V893).
## V894 — SYS-01.2-02 / ITEM-3128

Décision de scope catalogue terminée pour Data Dragon 4.20.1 : Deathfire Grasp `maps[10]=false`, cohérent avec l’absence locale. INIBIN natif 4.20.0.315 rehaché (602 octets; SHA conforme) et lié au consumer shop courant. Aucun test direct, build ou runtime; l’actif n’est pas implémenté/accepté.

`ITEM-3128-SCOPE` garde son statut `a_qualifier`; seule la décision d’exclusion de la référence catalogue est documentée. Reprise uniquement sur preuve primaire contradictoire 4.20.0.315. Détails : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V894).
## V895 — SYS-01.2-02 / ITEM-3139

Décision catalogue clôturée pour Data Dragon officiel 4.20.1 : Mercurial Scimitar `maps[10]=false`, cohérent avec l’absence locale. Le source natif 4.20.0.315 (593 octets, SHA conforme) et le consumer shop courant sont reliés; aucun test/build/runtime direct.

L’actif n’est pas implémenté/accepté; `ITEM-3139-SCOPE` garde `a_qualifier`, sans écriture de statut. Le runtime exact 4.20.0.315 reste à prouver seulement si une source primaire contredit le catalogue. Prochain cas explicitement exclu déjà recensé : ITEM-3141-SCOPE. Détails : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V895).
## V896 — SYS-01.2-02 / ITEM-3141

Scope catalogue terminé pour 4.20.1 : Sword of the Occult a `maps[10]=false` et `maps[12]=false`; son absence du shop local correspond à l’exclusion. Source native 4.20.0.315 rehachée (562 octets; empreinte conforme) et consumer courant reliés. Aucun test direct/build/runtime. La mécanique de stacks n’est pas implémentée/acceptée.

Le registre n’a pas changé : `ITEM-3141-SCOPE` reste `a_qualifier`. Réouvrir uniquement sur une preuve primaire contradictoire du client 4.20.0.315. Prochain cas explicitement exclu déjà recensé : ITEM-3154-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V896).
## V897 — SYS-01.2-02 / ITEM-3154

Scope catalogue terminé pour 4.20.1 : Wriggle's Lantern est exclu de Map10 (`maps[10]=false`); son absence locale concorde. Source native 4.20.0.315 (597 octets; SHA conforme) et consumer shop reliés. Pas de test/build/runtime direct; effets jungle/ward/transformation non implémentés/acceptés.

`ITEM-3154-SCOPE` reste `a_qualifier`; aucun statut changé. La vérification runtime exacte reste ouverte seulement en cas de preuve primaire 4.20.0.315 contradictoire. Prochain cas explicitement exclu recensé : ITEM-3157-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V897).
## V898 — SYS-01.2-02 / ITEM-3157

Décision de périmètre catalogue terminée pour Data Dragon 4.20.1 : Zhonya’s Hourglass `maps[10]=false`, cohérent avec l’absence locale. INIBIN 4.20.0.315 (536 octets, SHA conforme) et consumer shop courant liés. Aucun test/build/runtime direct; stase et feature non acceptées.

`ITEM-3157-SCOPE` reste `a_qualifier`, sans changement de statut. Le runtime exact n’est pas prouvé. Prochain item explicitement exclu repéré dans le registre : ITEM-3166-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V898).
## V899 — SYS-01.2-02 / ITEM-3166

Décision catalogue terminée pour Data Dragon 4.20.1 : Bonetooth Necklace est limité à Rengar, sans coût, et exclu de Map10 (`maps[10]=false`); l’absence locale concorde. INIBIN 4.20.0.315 (605 octets; SHA conforme) et consumer shop reliés. Aucun test/build/runtime direct.

Le totem et les mécaniques de trophées Rengar ne sont pas implémentés/acceptés. `ITEM-3166-SCOPE` reste `a_qualifier`, sans statut modifié; le runtime exact 4.20.0.315 reste non observé. Prochain cas explicite repéré : ITEM-3167-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V899).
## V900 — SYS-01.2-02 / ITEM-3167

Décision de scope terminée pour le catalogue officiel 4.20.1 : l’entrée Rengar 3167 est `inStore=false`, `purchasable=false`, `maps[10]=false` et `maps[12]=false`. INIBIN 4.20.0.315 a `InStore=0` (591 octets; SHA conforme), concordant; l’objet manque au shop local. Aucun test/build/runtime direct.

Le totem et les trophées Rengar ne sont pas implémentés/acceptés. `ITEM-3167-SCOPE` reste `a_qualifier`, sans statut changé. Prochain cas explicitement exclu recensé : ITEM-3168-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V900).
## V901 — SYS-01.2-02 / ITEM-3168

Scope catalogue terminé : la variante Rengar 3168 est `inStore=false`, `purchasable=false` et `maps[10]=false` dans Data Dragon 4.20.1; `InStore=0` natif concorde. Source de 584 octets et consumer reliés; objet absent du shop local. Aucun test/build/runtime direct.

Le totem/trophées final n’est pas implémenté/accepté; `ITEM-3168-SCOPE` reste `a_qualifier`, sans changement de statut. Reprise seulement sur preuve primaire 4.20.0.315 contradictoire. Prochain cas explicitement exclu recensé : ITEM-3169-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V901).
## V902 — SYS-01.2-02 / ITEM-3169

Décision catalogue terminée : la variante Rengar 3169 est `inStore=false`, non achetable et `maps[10]=false`/`maps[12]=false` dans Data Dragon 4.20.1; `InStore=0` natif concorde. Hash/source et consumer reliés; localement absent. Aucun test/build/runtime direct.

Totem/trophées/évolutions Rengar non implémentés/acceptés. `ITEM-3169-SCOPE` reste `a_qualifier`, sans statut changé; runtime exact non vérifié. Prochain cas explicitement exclu recensé : ITEM-3171-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V902).
## V903 — SYS-01.2-02 / ITEM-3171

La variante finale Rengar 3171 est `inStore=false`, non achetable, et exclue de Map10 dans Data Dragon officiel 4.20.1; INIBIN natif `InStore=0` concorde. SHA source 4.20.0.315 (591 octets) confirmé; consumer relié; absent du shop local. Aucun test/build/runtime direct.

Totem/trophées non implémentés/acceptés; `ITEM-3171-SCOPE` reste `a_qualifier`, sans changement. Prochain cas explicitement exclu du registre : ITEM-3175-SCOPE. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V903).
## V904 — SYS-01.2-02 / ITEM-3175

Scope catalogue vérifié : Data Dragon 4.20.1 classe 3175 hors boutique et exclu de Map10; l’INIBIN natif observé indique InStore=0. Fichier de 591 octets, SHA-256 conforme au manifeste. Le lien source/consumer est confirmé; l’ID manque aux deux catalogues locaux et le lookup de shop.rs:86 le refuse statiquement.

La précédence effective de l’archive et le runtime exact 4.20.0.315 restent inconnus. Totem, actif et trophées ne sont ni implémentés ni acceptés. Sous-audit documentaire clos seulement; ITEM-3175-SCOPE reste a_qualifier, sans statut modifié. Reprendre uniquement sur preuve primaire contradictoire. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V904). Prochain cas de la séquence : ITEM-3180-SCOPE.
## V905 — SYS-01.2-02 / ITEM-3180

L’entrée officielle 4.20.1 rend Odyn’s Veil achetable en général (purchasable=true) mais exclut Map10; l’INIBIN natif de 592 octets indique InStore=1, ce qui ne contredit pas cette restriction de carte. SHA-256 et lien source/consumer vérifiés. L’ID absent du shop local est refusé statiquement par shop.rs:86.

Scope catalogue audité; précédence effective et runtime exact 4.20.0.315 ouverts. Passif/actif non implémentés ou acceptés. ITEM-3180-SCOPE reste a_qualifier, sans statut modifié. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V905). Prochaine unité planifiée : ITEM-3181-SCOPE, à filtrer sur les preuves existantes avant d’ouvrir un nouveau sous-lot.
## V906 — filtrage ITEM-3181-SCOPE

Le seul champ de carte visible dans la fiche Data Dragon 4.20.1 intégrée est maps[1]=false; maps[10] est absent. Ce silence ne prouve ni admission ni exclusion de Map10. Aucun sous-audit source/consumer ni changement de statut n’est ouvert pour 3181. Reprendre seulement avec une source primaire datée 4.20.0.315 ou une preuve de sélection runtime qui tranche Map10. Référence inspectée : completion_tasks_2026-10-20.json, ITEM-3181-SCOPE.
## V907 — OLU-29959 / locale : maillon courant clos, historique ouvert

Le default input original DATA/cfg/defaults/locale.cfg (37 octets) et F:/OpenLeague/data/4.20/font_configuration/locale.cfg ont des octets et SHA-256 identiques (053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f), valeur en_GB. Le démarrage normal suit main.rs:600 → native_zip_provider.rs:116 → native_hud_font_configuration.rs:38, qui lit cette copie F directement et sélectionne le fontconfig en_GB. Ce résultat ferme uniquement la liaison de la copie courante au consumer HUD.

Il ne prouve ni la production du Locale.cfg loose original, ni le provider/overlay effectif ou la ligne de commande historique. OLU-29959 reste ouverte; reprendre seulement sur preuve primaire de writer/staging ou de sélection effective 4.20.0.315. Ne pas recalculer les empreintes ni refaire le graphe Rust.


## V908 — SYS-01.2-02 : frontière de localisation shop en_GB

Sous-audit documentaire clos pour le lien natif `getLocalizedText` → interface shop → consumer Rust actuel. REA/Ghidra sur le PE épinglé confirme `FUN_00818320` enregistre `getLocalizedText` vers `FUN_007879a0`; le parseur natif `FUN_00795d10` vérifie des templates UTF-16 avec `%i/%s/%I/%n`, appelé par `FUN_00796350`. Côté Rust, `native_hud_font_configuration.rs:29-31` ignore les lignes `tr`; `shop_ui.rs:421-437` lit le catalogue et compose des libellés sans cet API. Détails et reçus : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V908).

Audit local terminé ≠ fonctionnalité terminée : retour/table de traduction, appels indirects, rendu runtime et acceptation restent ouverts. `LOCALE-en_GB-SOURCE` et `LOCALE-en_GB-HUD` restent `a_faire`; `SYS-01.2-02` reste `partiel_a_terminer`. Aucun code, statut, registre/trace, goal, Plan, interface ou base applicative modifié. Aucun test/build/runtime exécuté.

Le `next_action` de `docs/resume_checkpoint.json` pointe encore vers ITEM-3024, dont le sous-audit existe déjà (V858). Ne pas refaire ce lot; suivre le prochain lien distinct défini dans la trace et les présentes notes. Le checkpoint JSON est conservé inchangé.

## V909 — SYS-01.2-02 / ITEM-1039

Sous-audit borné clos pour le lien source/manifeste natif 4.20.0.315 → Data Dragon 4.20.1 → consumer shop actuel. La source `DATA/Items/1039.inibin` (614 octets, SHA `7ecd4d…dbdb57`) réutilise le reçu de membre existant; le catalogue officiel montre prix 400 et `maps[12]=false`, mais aucun `maps[10]`. L’entrée manque du shop local; `shop.rs:86` la refuse statiquement avec `item behavior not implemented`. Pas de runtime exécuté.

Cette clôture couvre uniquement le lien d’audit. ITEM-1039-SCOPE reste `a_qualifier`, Map10/prix natif/précédence et achat runtime restent inconnus; SYS-01.2-02 demeure partiel. Le trace JSON ne rattache aucun unknown à cette fiche; il est resté intact. Aucun code, statut, Plan, UI, base ou goal modifié.

Reprise seulement sur preuve primaire des champs natifs/Map10 ou autorisation ultérieure de corriger les liens d’inconnues. Ne pas refaire les hashes ni la lecture du catalogue. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V909).

## V910 — SYS-01.2-02 / ITEM-1062

Lien d’audit statique clos : source native 4.20.0.315 `DATA/Items/1062.inibin` (493 octets; membership et SHA réutilisés) → Data Dragon 4.20.1 `/data/1062`, où `maps[10]=false` → consumer shop courant. `shop_foundation` et l’admission Map10 n’ont pas d’entrée 1062; `shop.rs:86` refuse l’ID absent avec `item behavior not implemented`.

Cette concordance prouve le scope de la fiche officielle et le refus local, pas la précédence ni la disponibilité historique du client 4.20.0.315. Pas de décodage natif de champs ni d’exécution. ITEM-1062-SCOPE reste `a_qualifier`; la trace n’associe aucun unknown à la limite, et reste inchangée. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V910).

Prochaine étape du parent : sélectionner une exigence distincte encore sans reçu ciblé, en excluant les sous-audits déjà consignés; ne pas suivre le pointeur stale ITEM-3024 (V858 existe).


## V911 — SYS-01.2-02 / recensement de couverture

Le contrôle structurel du registre et de la trace passe : 42 215 tâches/exigences alignées, toutes les références vers source/consommateur/inconnue résolues. Sur 24 727 exigences obligatoires : 24 349 liens natifs, 378 sans lien natif mais toutes référencées, 24 690 avec un consommateur non-Plan et 37 Plan seulement. Un rôle non-Plan ne prouve pas une fonctionnalité de production. Les 36 fiches EMPTY sont déjà couvertes par V156; ne pas refaire ces recherches. Les 9 politiques SYS-01.4 sont déjà analysées par V96. Détail : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V911).

`SYS-01.2-02` reste partiel, avec cinq inconnues. Le validateur complet est bloqué par `WindowsPath.is_junction` manquant dans l’interpréteur disponible; pas de hash global exécuté ni de modification de code. Reprise : interpréteur compatible ou autorisation distincte pour corriger le contrôle, puis classer les exigences sans source native par familles. Goal, registres, tâche, Plan, UI et base non modifiés.


## V912 — SYS-01.2-02 / correction de validation et dérives d’identité

La méthode du dépôt prévoit Python 3.12.14 dans `.ai-tools/.venv`; V911 attribuait à tort l’échec au manque de `Path.is_junction` dans l’interpréteur global. Le validateur structurel passe. `--verify-files` vérifie les 5 759 ancres puis refuse les 14 092 sources enregistrées hors de ses racines. Sur 86 313 sources permises, 86 310 tailles/SHA concordent et 3 records non liés à une exigence divergent (`AGENTS.md`, client.exe, server.exe). Aucun registre n’a été corrigé. Détail, empreintes et limites : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V912).

Le goal reste partiel : 14 092 sources non vérifiées, trois identités à réconcilier, cinq inconnues parentales. Ne pas élargir l’allowlist ni rapprocher les racines `E:\OpenLeague` et `F:\OpenLeague` sans décision explicite; ne pas refaire les 86 310 hashes concordants.

Reprise : `docs/resume_checkpoint.json` reste inchangé et son `next_action` pointe encore vers ITEM-3024-SCOPE; le reçu V858 est déjà présent. Ne pas refaire ce lot. Le checkpoint JSON n’a pas été modifié sous la restriction actuelle.

## V913 — correction de portée des chemins hors racines

V912 surcomptait les chemins hors allowlist comme non lus. `project_location.json` et `source_versions.py` autorisent explicitement six sources versionnées de l’ancien `E:\OpenLeague`; huit versions historiques et huit reçus ont aussi été vérifiés. Sur 14 092 sources hors racines actives, six sont donc vérifiées via cette exception, 14 086 restent sans contenu vérifié. Le validateur global échoue toujours sur l’allowlist. Détail : section V913 du reçu.


## V914 — SYS-01.2-02 / limites d’accès de `--verify-files`

Le validateur lit les ancres consommateurs et le reçu de membership RADS avant le contrôle d’allowlist. Sur 53 ancres absolues, 17 sont sous `E:\mapslol3v3` et 36 sous le cache Cargo de `C:\Users` (17 fichiers). Le reçu RADS sous l’ancien `E:\OpenLeague` est parsé pour 7 259 liens sans vérifier son SHA. Des chemins `C:` ont donc été lus par cette invocation; ne pas relancer `--verify-files` avant une correction/qualification des racines. V914 précise le compte : 14 068 sources hors racines sans lecture, en plus des sources distinctement lues par historique, membership ou ancrage. Aucun code/registre modifié.
## V915 — ITEM-3181-SCOPE

Traçage statique achevé pour DATA/Items/3181.inibin → catalogue officiel 4.20.1 → boutique locale. Le binaire natif (564 octets) a été rehaché; Price=600, recette 1037/1053, InStore=1. L’entrée officielle indique total 2275 et maps[1]=false, mais ne contient pas maps[10]. L’objet est absent du catalogue et de l’admission Map10 locales; le code l’omet de la liste et refuse l’achat direct comme non implémenté. Audit du lien terminé, mais disponibilité historique Map10 non décidée et fonction absente. ITEM-3181-SCOPE reste a_qualifier; aucun test/runtime ni statut de registre modifié. Reprise seulement sur preuve primaire 4.20.0.315 Map10. Détail et SHA : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V915).
## V916 — ITEM-3184-SCOPE

Classification du catalogue 4.20.1 achevée : Data Dragon item.json indique explicitement maps[10]=false pour Entropy (3184). La ressource native rehachée confirme Price=500, recette 3044/1037 et InStore=1, qui ne contredit pas la restriction carte. L’entrée manque du catalogue et de l’admission locale; le consommateur la masque et refuse l’achat comme non implémenté. La classification de référence est close; l’implémentation et la priorité runtime exacte du client 4.20.0.315 restent non vérifiées. Statuts du registre inchangés. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V916).
## V917 — ITEM-3204-SCOPE

La référence officielle Data Dragon 4.20.1 marque explicitement Quill Coat (3204) indisponible sur Map10 (maps[10]=false; aussi maps[12]=false). La source native 4.20.0.315 a été rehachée : 573 octets, Price=75, recette 1039/1029, InStore=1, +20 armure. La boutique locale ne contient pas l’objet; le consommateur l’omet et renvoie actuellement le refus générique. Classification du catalogue 4.20.1 auditée; fonction et priorité runtime exacte restent non qualifiées. ITEM-3204-SCOPE garde son statut. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V917).
## V918 — ITEM-3205-SCOPE

Le catalogue officiel 4.20.1 marque Quill Coat (3205) indisponible sur Map10 et Map12. La ressource native 4.20.0.315 a été rehachée : 555 octets, coût 75, recette 1039/1029, InStore=1, SpellName=SpiritLantern, +20 armure. Elle reste distincte de l’objet 3204 malgré le nom catalogue partagé. L’objet manque du catalogue/admission locale et le consumer le refuse comme non implémenté. Audit de classification terminé; fonctionnalité et priorité runtime exacte restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V918).
## V919 — ITEM-3206-SCOPE

Le catalogue officiel 4.20.1 exclut explicitement Spirit of the Spectral Wraith (3206) de Map10 et Map12. Source native rehashée (619 octets) : coût 480, recette 1080/3108, revente x0,4; le catalogue confirme total 2075 et vente 830. L’objet est absent du catalogue/admission locale et le consommateur le refuse comme non implémenté. SpellName natif AtmasImpalerDummySpell est conservé comme fait brut, sans interprétation mécanique. Classification de catalogue auditée; fonctionnalité et priorité runtime exactes restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V919).
## V920 — ITEM-3207-SCOPE

Spirit of the Ancient Golem (3207) est explicitement exclu de Map10 et Map12 dans Data Dragon 4.20.1. Source native 4.20.0.315 rehachée (599 octets) : prix 450, recette 3205/3067, revente x0,4, +20 armure/+200 PV; total 2075 et vente 830 concordent avec la référence. Le consumer local omet l’objet et refuse un achat direct faute de définition. Classification de catalogue auditée; jungle/passifs, fonctionnalité et priorité runtime exacte restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V920).
## V921 — ITEM-3208-SCOPE

La fiche officielle 4.20.1 exclut explicitement l’ID 3208 de Map10/Map12. Le natif 4.20.0.315 (613 octets, rehaché) donne coût 450, recette 3204/3067, revente x0,4, +20 armure/+200 PV et SpellName=HextechSweeper. C’est une variante distincte de l’ID 3207 (SpiritLantern, recette 3205/3067). 3208 manque du catalogue/admission locale et est refusé faute de définition. Classification catalogue auditée; fonctionnalité, effet du SpellName et priorité runtime exacte restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V921).
## V922 — ITEM-3209-SCOPE

Data Dragon 4.20.1 exclut explicitement Spirit of the Elder Lizard (3209) de Map10 et Map12. Le natif 4.20.0.315 rehaché (615 octets) donne coût 580, recette 1080/1036/1036, revente x0,4 et +30 dégâts; total 2075 et vente 830 concordent. SpellName=ItemSpiritStoneLizardDummy est enregistré sans interprétation mécanique. L’objet manque localement et le consumer refuse l’achat faute de définition. Classification catalogue auditée; mécanique et priorité runtime restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V922).
## V923 — ITEM-3250-SCOPE

Homeguard (3250) est explicitement exclu de Map10/Map12 par le catalogue officiel 4.20.1. Source native 4.20.0.315 rehachée (599 octets) : prix de combinaison 475, recette Bottes de vitesse 3006, +45 déplacement et +25 % vitesse d’attaque. L’objet manque du catalogue et de l’admission locale; le consumer le masque et refuse l’achat faute de définition. Classification catalogue auditée; effet fonctionnel et priorité runtime exacte restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V923).
## V924 — ITEM-3255-SCOPE

L’Homeguard 3255 est explicitement exclu de Map10/Map12 par Data Dragon 4.20.1. Le natif 4.20.0.315 (555 octets, rehaché) donne coût 475 et recette 3020; la référence donne total 1575, revente 1103 et +45 mouvement. L’objet manque du catalogue et de l’admission locale; le consumer le refuse comme non implémenté. Classification catalogue auditée; intégration et priorité runtime exacte restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V924).
## V925 — ITEM-3260-SCOPE

Le Homeguard 3260 est explicitement exclu de Map10/Map12 dans le catalogue officiel 4.20.1. Le natif 4.20.0.315 rehaché (590 octets) donne coût 475, recette 3047, +25 armure et +45 mouvement; la référence donne total 1475 et vente 1033. Objet absent du catalogue/admission locale, refusé faute de définition. Classification catalogue auditée; fonction et priorité runtime exacte restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V925).
## V926 — ITEM-3265-SCOPE

Homeguard 3265 est explicitement exclu de Map10/Map12 dans Data Dragon 4.20.1. Natif 4.20.0.315 rehaché (610 octets) : coût 475, recette 3111, +45 mouvement/+25 résistance magique. L’objet manque localement et le consumer le refuse faute de définition. Classification catalogue auditée; fonctionnalité et priorité runtime exacte restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V926).
## V927 — ITEM-3270-SCOPE

Homeguard 3270 est explicitement exclu de Map10/Map12 dans Data Dragon 4.20.1. Le natif 4.20.0.315 rehaché (601 octets) indique coût 475, recette 3117 et +105 mouvement; la référence donne total 1275 et vente 893. Objet absent localement, refusé faute de définition. Classification catalogue auditée; fonctionnalité et priorité runtime exactes restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V927).
## V928 — ITEM-3275-SCOPE

Homeguard 3275 est explicitement exclu de Map10/Map12 dans Data Dragon 4.20.1. Le natif 4.20.0.315 rehaché (573 octets) donne coût 475, recette 3158 et +45 mouvement; la référence donne total 1475 et vente 1033. Objet absent du catalogue/admission locale et refusé faute de définition. Classification catalogue auditée; intégration et priorité runtime exacte restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V928).
## V929 — ITEM-3280-SCOPE

Homeguard 3280 est explicitement exclu de Map10/Map12 dans Data Dragon 4.20.1. La source native 4.20.0.315 rehachée (613 octets) donne coût 475, recette 3009 et +60 mouvement; total 1475 et vente 1033 figurent dans la référence. L’objet manque du catalogue et de l’admission locale, et le consumer le refuse faute de définition. Classification catalogue auditée; fonctionnalité et priorité runtime restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V929).
## V930 — ITEM-3340-SCOPE

La référence officielle 4.20.1 exclut Warding Totem (3340) de Map10/Map12; prix et revente sont nuls. Le natif 4.20.0.315 rehaché (631 octets) indique Price=0, InStore=1, UseEffect=1 et SpellName=TrinketTotemLvl1. L’objet manque du catalogue/admission locale et est refusé comme non implémenté. Classification catalogue auditée; usage du trinket et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V930).
## V931 — ITEM-3341-SCOPE

Data Dragon 4.20.1 exclut explicitement Sweeping Lens (3341) de Map10; maps[12] est absent et reste inconnu. Le natif 4.20.0.315 rehaché (630 octets) indique coût nul, InStore=1 et SpellName=TrinketSweeperLvl1. L’objet manque du catalogue/admission locale et le consumer le refuse faute de définition. Classification Map10 auditée; actif, Map12 et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V931).
## V932 — ITEM-3342-SCOPE

Scrying Orb (3342) est explicitement exclu de Map10 par le catalogue officiel 4.20.1; maps[12] est absent et reste inconnu. Le natif 4.20.0.315 rehaché (630 octets) indique coût nul, InStore=1 et SpellName=TrinketOrbLvl1. L’objet manque du catalogue/admission locale et est refusé faute de définition. Classification Map10 auditée; actif, Map12 et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V932).
## V933 — ITEM-3345-SCOPE

Le catalogue 4.20.1 exclut explicitement Soul Anchor (3345) de Map10/Map12 et de la map 1. Le natif 4.20.0.315 rehaché (593 octets) indique coût nul, CanBeSold=0, InStore=1 et SpellName=OdinTrinketRevive. L’objet est absent du catalogue/admission locale et le consumer le refuse faute de définition. Classification Map10 auditée; actif de réapparition et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V933).
## V934 — ITEM-3361-SCOPE

Le catalogue 4.20.1 exclut explicitement Greater Stealth Totem (3361) de Map10/Map12. Le natif 4.20.0.315 rehaché (652 octets) indique coût 475, recette 3340, sellback x0,7 et SpellName=TrinketTotemLvl3; la vente officielle est 333, l’arrondi n’est pas étudié. L’objet manque du catalogue/admission locale et est refusé faute de définition. Classification Map10 auditée; actif, règles trinket et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V934).
## V935 — ITEM-3362-SCOPE

Greater Vision Totem (3362) est explicitement exclu de Map10/Map12 par Data Dragon 4.20.1. Le natif 4.20.0.315 rehaché (646 octets) donne coût 475, recette 3340, revente x0,7 et SpellName=TrinketTotemLvl3B; le catalogue revend à 333, sans règle d’arrondi qualifiée. L’objet manque du catalogue/admission locale et le consumer le refuse. Classification Map10 auditée; actif, arrondi, fonction et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V935).
## V936 — ITEM-3363-SCOPE

Farsight Orb (3363) est explicitement exclu de Map10 dans Data Dragon 4.20.1; maps[12] est absent. Le natif 4.20.0.315 rehaché (639 octets) donne coût 475, recette 3342, revente x0,7 et SpellName=TrinketOrbLvl3; le catalogue revend à 333, sans règle d’arrondi qualifiée. L’objet manque localement et le consumer le refuse faute de définition. Classification Map10 auditée; Map12, actif et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V936).
## V937 — ITEM-3364-SCOPE

Oracle’s Lens (3364) est explicitement exclu de Map10 dans Data Dragon 4.20.1; maps[12] est absent. Le natif 4.20.0.315 rehaché (642 octets) donne coût 475, recette 3341, sellback x0,7 et SpellName=TrinketSweeperLvl3; la vente officielle est 333, sans règle d’arrondi qualifiée. L’objet manque localement et est refusé faute de définition. Classification Map10 auditée; Map12, actif et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V937).
## V938 — ITEM-3405-SCOPE

Bonetooth Necklace (3405) est réservé à Rengar dans le natif et le catalogue officiel 4.20.1; celui-ci exclut explicitement l’objet de Map10/Map12. Natif 4.20.0.315 rehaché (605 octets), coût nul, SpellName=RelicMinorSpotter. Objet absent localement et refusé faute de définition. Classification Map10 et restriction Rengar auditées; trophées, passifs, intégration et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V938).
## V939 — ITEM-3406-SCOPE

Bonetooth Necklace (3406) est réservé à Rengar et non achetable : le natif indique InStore=0, et le catalogue officiel 4.20.1 indique purchasable=false. Celui-ci marque aussi maps[10]=false/maps[12]=false. Le fichier natif a été rehaché (591 octets); l’ID manque du catalogue local, qui refuse l’achat faute de définition. Classification achat/Map10 auditée; effets Rengar et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V939).
## V940 — ITEM-3407-SCOPE

La source native 4.20.0.315 de Bonetooth Necklace (3407) indique InStore=0 et RequiredChampion=Rengar; le catalogue officiel 4.20.1 indique aussi purchasable=false, maps[10]=false/maps[12]=false. Fichier de 586 octets rehaché. L’ID manque localement et le consumer le refuse faute de définition. Classification achetabilité/Map10 auditée; passifs Rengar et priorité runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V940).
## V941 — ITEM-3408-SCOPE

La variante 3408 de Bonetooth Necklace est réservée à Rengar et non achetable : InStore=0 natif concorde avec purchasable=false officiel. Data Dragon 4.20.1 marque aussi maps[10]/maps[12]=false. Natif de 586 octets rehaché; objet absent de la boutique locale et refusé faute de définition. Classification achat/Map10 auditée; mécanique Rengar et priorité runtime restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V941).
## V942 — ITEM-3409-SCOPE

La variante 3409 de Bonetooth Necklace est réservée à Rengar et non achetable : le natif indique InStore=0 et Data Dragon 4.20.1 purchasable=false. Le catalogue marque aussi maps[10]/maps[12]=false. Le fichier natif 602 octets a été rehaché; l’objet manque localement et est refusé faute de définition. Classification achat/Map10 auditée; trophées et priorité runtime exacte restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V942).

Complément V943 — ITEM-3410-SCOPE : classification catalogue terminée pour Map10 (`maps[10]=false`), prix/achat, restriction Rengar et lien spécial 3169. Natif 4.20 relu et rehaché; référence officielle 4.20.1. L’objet manque du catalogue local, l’UI l’omet et l’achat direct échoue par refus générique; vérifications statiques seulement. Implémentation et sélection runtime restent ouvertes. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V943).

Complément V944 — ITEM-3411-SCOPE : Data Dragon 4.20.1 indique `purchasable=true` mais `maps[10]=false`; le natif indique `InStore=1`, propriété non spécifique à Map10. Item absent du shop/admission locaux : consumer retourne `None` puis refus générique faute de définition. Restriction Rengar, prix nul, recette absente qualifiés statiquement; actif/runtime ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V944).

Complément V945 — ITEM-3412-SCOPE : références native 4.20 et Data Dragon 4.20.1 concordent : Rengar requis, prix nul, non achetable, maps 10/12 exclues, sans recette. Natif 601 octets rehaché; entrée locale absente, UI filtrée et achat générique refusé, vérifiés statiquement. L’actif et la sélection runtime restent ouverts. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V945).

Compléments V946–V948 — ITEM-3413/3414/3415-SCOPE : natifs relus/rehachés; accord avec 4.20.1 pour Rengar, prix nul, non-achat, exclusion Map10 et aucune recette. Trois IDs absents du consumer : UI filtrée, état `None`, achat direct refusé faute de définition. `TrinketOrbLvl2/3` n’a pas été exécuté; la priorité runtime reste inconnue. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V946–V948.

Compléments V949–V951 — ITEM-3416/3417/3418-SCOPE : 3416 est explicitement exclu de Map10 et son lien spécial 3169 concorde; audit catalogue borné clos. Pour 3417 et 3418, `maps[10]` manque : disponibilité Map10 reste inconnue, sans inférence à partir de `InStore` ou d’une autre carte. IDs absents localement, filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V949–V951.

Compléments V952–V954 — ITEM-3419/3420/3421-SCOPE : prix nul, non-achat global et restriction Rengar confirmés par le natif et le catalogue 4.20.1. `maps[10]` absent pour les trois : disponibilité Map10 conservée `inconnue`. IDs absents du consumer; refus/filtrage statiques. Preuve primaire Map10 ou observation d’exécution nécessaire pour reprise. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V952–V954.

Complément V955 — ITEM-3422-SCOPE : natif/relais officiel concordent sur prix nul, non-achat, Rengar et SpecialRecipe 3169; le catalogue officiel ne contient pas `maps[10]`, donc disponibilité Map10 inconnue. ID absent localement; filtrage/refus statiques. Preuve primaire Map10 et comportement de transformation/runtime restent ouverts. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V955).

Compléments V956–V958 — ITEM-3450/3451/3452-SCOPE : Maps 10/12/1 explicitement fausses, Rengar requis, prix nul et aucune recette dans 4.20.1; sources natives relues/rehachées. Pour 3450, `purchasable=true` reste global et ne change pas l’exclusion Map10. Les IDs manquent du consumer; filtrage/refus statiques. OdinTrinketRevive non exécuté. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V956–V958.

Compléments V959–V961 — ITEM-3453/3454/3455-SCOPE : 3453/3454 explicitement exclus de Map10; 3455 a un lien spécial 3169 mais aucun champ `maps`, donc Map10 inconnu. Natif relu/rehaché, Rengar/prix/achat classifiés; IDs absents du consumer. OdinTrinketRevive non exécuté, runtime ouvert. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V959–V961.

Complément V962 — ITEM-3460-SCOPE : Golden Transcendence, explicitement exclu des maps 1/10/12, non achetable, sans recette ni restriction de champion précisée. Natif relu/rehaché; AscWarp non exécuté; ID absent et refus/filtrage locaux statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V962).

Compléments V963–V964 — ITEM-3504/3508-SCOPE : prix et recettes natifs concordent avec 4.20.1. Map10 de 3504 est inconnue (objet `maps` absent); 3508 est explicitement exclu malgré `purchasable=true`/`InStore=1`. IDs absents du shop local, vérification statique. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V963–V964.

Compléments V965–V967 — ITEM-3599/3706/3707-SCOPE : prix/recettes et restrictions décodés; 3599 n’a aucun objet `maps`, 3706/3707 ne précisent que `maps[12]=false`. Map10 reste inconnue pour les trois. Natif rehaché, IDs absents du consumer local; filtrage/refus statiques. The Black Spear actif non exécuté. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V965–V967.

Compléments V968–V970 — ITEM-3708/3709/3710-SCOPE : prix et recettes concordants avec le natif; seule `maps[12]=false` est documentée. Map10 reste inconnue pour les trois. IDs absents du consumer, filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V968–V970.

Compléments V971–V973 — ITEM-3711/3713/3714-SCOPE : prix/recettes concordants avec les natifs; Data Dragon ne précise que `maps[12]=false`, donc Map10 reste inconnue. IDs absents du consumer, filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V971–V973.

Compléments V974–V976 — ITEM-3715/3716/3717-SCOPE : recettes et prix comparés aux natifs; seule `maps[12]=false` est documentée. Map10 reste inconnue. IDs absents du consumer; filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V974–V976.

Compléments V977–V979 — ITEM-3718/3719/3720-SCOPE : prix/recettes vérifiés; la référence ne donne que `maps[12]=false`, donc Map10 demeure inconnue. IDs absents du consumer. Les SpellName éventuellement présents ne sont pas exécutés. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V977–V979.

Compléments V980–V982 — ITEM-3721/3722/3723-SCOPE : prix/recettes comparés au natif; référence ne donnant que `maps[12]=false`, Map10 inconnue. IDs absents du consumer; filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V980–V982.

Compléments V983–V985 — ITEM-3724/3725/3726-SCOPE : prix/recettes concordants avec le natif; `maps[10]` absent (seul `maps[12]=false` existe), statut 3v3 inconnu. IDs absents du consumer, filtrage/refus statiques. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V983–V985.

Compléments V986–V987 — ITEM-3800/3801-SCOPE : 3800 est absent localement, prix/recette natifs et officiels concordent, mais `maps` manque. 3801 est déjà partiellement intégré : shop relié au même hash natif, achat testé par code existant, admission locale `true`; pourtant la référence d’admission n’a aucun champ maps, donc preuve historique Map10 manquante. Tests lus, non exécutés; statuts inchangés. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V986–V987.

Bilan V988 — lot ITEM-SCOPE 3410–3801 : 45 fiches revues; 14 ont `maps[10]=false`, 31 n’ont aucune donnée Map10. 3801 seul est dans les catalogues locaux; son admission `true` n’est pas corroborée par la référence, qui omet `maps`. Registre inchangé : 44 `a_qualifier`, 1 `partiel_a_terminer`, aucune acceptance/implémentation/evidence marquée vraie. Les cinq inconnues globales et D01-SYS-01-1 restent ouvertes; pas de recherche répétée. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V988).

Compléments V989–V990 — ITEM-3024 relié statiquement du natif au shop : hash concordant, prix/recette/stats, admission Map10 true. Le contrat local utilise `basic.maps[10]=true` comme défaut; l’exclusion explicite de 1058 fournit le contrôle négatif. Tests lus, non lancés. Correction du lot 45 : 14 overrides Map10=false, 31 héritent true sous le contrat Data Dragon/test; seul 3801 est actuellement dans le catalogue local. Cela ne prouve pas le runtime 4.20.0.315. Statut 3024 partiel et checkpoint inchangés; ne pas répéter ce lot. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V989–V990.

Complément V991 — ITEM-3025-SCOPE : source native et Data Dragon concordent sur prix, recette 3057+3024 et stats. L’item est Map10=true par défaut du contrat 4.20.1, mais absent du shop/admission local; UI le cache et l’achat renvoie `item behavior not implemented`. Audit de liaison statique terminé; fonctionnalité et runtime restent ouverts, tâche/registre inchangés. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V991).

Complément V992 — ITEM-3187-SCOPE : source native, recette et Data Dragon relient Hextech Sweeper à Map10=true par le défaut `basic.maps`; l’item est absent du shop/admission F. Consumer renvoie `None`, masque l’entrée et refuse l’achat comme non implémenté. Le test actuel ne détecte pas l’omission d’articles absents du catalogue. Audit source→consumer clos statiquement; intégration, actif et runtime restent ouverts. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V992).

V993 — ITEM-3110-SCOPE : audit statique natif 4.20 → Data Dragon 4.20.1 → consumer terminé pour ce petit lot. Coût/recette/stats concordent; Map10=true seulement selon le défaut du contrat local, tandis que l’objet manque des 2 catalogues et le consumer renvoie `None`/masque/refuse comme non implémenté. L’absence de `maps[10]` dans 4.20.1 laisse l’historique 4.20.0.315 non établi. Fonctionnalité non terminée; statut registre inchangé. Aucun test/build/runtime lancé. Détail et reprise : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V993).

V994 — ITEM-3082-SCOPE : source native 4.20 et Data Dragon 4.20.1 concordent sur coût, composants 1029+1029 et armure. L’objet améliore 3110, mais manque des catalogues shop/admission locaux; consumer `None`/masqué/refus générique. Map10=true seulement par défaut du test local; preuve client 4.20.0.315 absente. Audit statique de ce lien terminé, acceptation registre et fonctionnalité restent ouvertes; aucun test lancé. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V994).

V995 — ITEM-3143-SCOPE : audit statique du Randuin's Omen relié à 3082 terminé. Source native 4.20 et Data Dragon 4.20.1 concordent sur prix, recette 3082+1011 et statistiques; le natif déclare `UseEffect=true/SpellName=RanduinsOmen`, non qualifié en exécution. Objet absent des catalogues locaux; consumer le masque/refuse comme non implémenté. Map10 historique reste inconnue (défaut local seulement). Aucun test lancé; fiche `a_qualifier`. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V995).

V996 — Nouvelle source Map10 du client original : `LEVELS/Map10/Items.inibin` (657 o; SHA `2e0e874e…4288456f7`) décodée en lecture seule avec le lecteur existant. 98 entrées/95 IDs; les 85 IDs DDragon 4.20.1 à maps[10]=false sont tous présents, aucun true; 10 anciens IDs sans ligne DDragon. Les 33 admissions locales concordent exactement (31 autorisés absents, 1038/1058 refusés présents). Cela soutient fortement une denylist et rend probables les admissions de 3025/3082/3110/3187/3143 absents de celle-ci. Clés et consumer client non identifiés : inférence forte, pas preuve runtime; ne pas déclarer les fonctionnalités faites. Reprise : retrouver les noms de clés ou le lecteur historique. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V996).

V997 — Contrôle Map1/8/10/11/12 : seul Map10 a l’alignement exact avec les IDs DDragon 4.20.1 `maps[10]=false`; les autres fichiers contiennent aussi des IDs explicitement admis. Donc V996 est une forte corrélation propre à Map10, sans sémantique de clé/lecteur prouvée. V993–V995 restent ouverts; absence de liste = « probablement non exclu », pas admission runtime. Reprise sur lecteur ou schéma de clés historique. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V997).


Complément V998 — OLU-0ae207ed : LoLPatcher.exe (release RADS 0.0.0.11) contient des chaînes liées à l’écriture/configuration de locale (SHA et offsets dans AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V998). Candidat producteur seulement : aucune xref/écriture/staging/démarrage complet établi; payload locale.cfg en_GB confirmé à 37 o avec SHA. Inconnue toujours ouverte; reprendre sur xrefs avec outil déjà disponible, source/symboles ou reçu de staging. Outils REA/rizin/Ghidra/objdump absents de PATH; rien installé. Aucun statut/goal/registre/checkpoint/application/base modifié.


Complément V999 — OLU-0ae207ed : REA local est bien disponible via le wrapper F, malgré son absence du PATH; V998 est corrigée sur ce point. L’analyse Ghidra du LoLPatcher établit statiquement l’écriture conditionnelle de data/cfg/defaults/locale.cfg après l’update, le mode wt, le chemin CRT d’écriture et la normalisation en_gb→en_GB. L’output attendu conditionnel correspond octet pour octet au fichier original et à la copie F. Le consumer actuel est limité à la sélection de fontes HUD. L’exécution historique, la racine physique, le provider/overlay et la sélection par le client Riot restent inconnus; OLU-0ae demeure ouverte. V999 : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.


Complément V1000 — OLU-0ae207ed : V999 (LoLPatcher) est relié au reçu natif V37 du lecteur locale.cfg. Le writer statique prédit les 37 octets en_GB sous l’entrée en_gb; ils correspondent au fichier fourni et à la copie F. Le lecteur natif du client exact a déjà lu ce fichier sous root/backend déclarés et obtenu en_GB. Cela clôt uniquement le lien conditionnel des octets producteur→lecteur dans ces conditions. L’écriture historique, l’input effectif et le bootstrap/provider/overlay complet restent inconnus; OLU-0ae reste ouverte. Aucun exécutable/test/build relancé; aucune tâche, goal, registre, checkpoint, app ou base modifié. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1000).

## V1001 — SYS-01.2-02 : Aatrox Q, lien source → consommateur

Sous-audit statique clos pour la relation `CH-Aatrox-Q-SOURCE` : fichiers natifs Aatrox/AatroxQ identifiés par hash et membership, export `/0` contrôlé contre le brut, puis relié à `Action::Cast → Simulation::cast → Err("champion spell not implemented")`. 171 champs nommés présents; `Coefficient` ne présente qu’un arrondi flottant; 15 clés brutes restent sans nom dans l’export et aucune n’a été nommée par les autres lignes du même JSON. Aucun sort exécuté. La tâche entière reste `a_qualifier`, sans preuve/acceptation ajoutée; conversion, sémantique complète, disponibilité Map10 et dépendance `CH-Aatrox-IDENTITE` restent ouvertes. Reprise seulement sur dictionnaire/lecteur natif ou source primaire nouvelle; ne pas refaire l’extraction ni le scan croisé.

Le `resume` du dépôt retourne un checkpoint dont la prochaine action enregistrée est encore ITEM-3024; ses champs Git sont `null` à cause du refus d’accès à F:. Pas de réécriture du checkpoint ni du goal. Rapport détaillé : `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md` (V1001). Aucun code, registre, Plan, application ou base modifié; aucun test/build/runtime exécuté.

## V1002 — Aatrox Q : un champ natif de tooltip résolu

Le hash `2287725201` est `BuffData.DynamicTooltip` dans `AatroxQ.inibin`, valeur `game_buff_tooltip_AatroxQ`; `SpellData.DynamicTooltip` est un champ séparé. La clé et son texte en_GB sont présents dans `fontconfig_en_GB.txt`, dont la copie locale est identique par SHA. Le loader Rust utilise cette ressource pour les polices et ignore le contenu `tr`; aucun consumer de la clé n’a été trouvé dans `crates/core/src` ou `crates/client/src`. Un hash sur les 15 est donc nommé; 14 restent inconnus. Aatrox Q reste explicitement refusé au dispatch; la tâche `CH-Aatrox-Q-SOURCE` et les règles gameplay restent ouvertes. Aucun test/build/runtime/statut/code/registres/app/base modifié. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1002).


## V1003 — Aatrox Q : recherche locale des 14 hashes sans nom

Les recherches bornées dans les dictionnaires/reçus locaux, les champs nommés des plans, 888 couples section/propriété candidats, et l’export des sorts n’ont pas nommé les 14 hashes restants. `AOE_leona_outer.dds` pointe vers des champs texture connus mais des hashes différents. Le lecteur alternatif conserve les hash inconnus; la source d’import citée est absente du dépôt/workspace contrôlés. Reprendre seulement avec une table INIBIN 4.20 ou l’outil de conversion. Pas de nouveau scan binaire avec ZIP inclus. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1003).

## V1004 — Aatrox W : lien source et refus actuel

`AatroxW.inibin` et son export `/1` sont reliés et contrôlés; 125/125 champs nommés correspondent aux hashes bruts, trois nombres ne diffèrent que par la précision float et le hash restant est `BuffData.DynamicTooltip`. Le tooltip de sort existe en en_GB; le tooltip BuffData exact manque, avec des variantes Life/Power distinctes. Le dispatch Rust refuse toujours Aatrox W. Sous-audit de liaison clos; `CH-Aatrox-W-SOURCE` demeure `a_qualifier`, la simulation, sémantique, Map10 et dépendance identité restent ouvertes. Aucun statut/code/goal/app/base modifié, aucun test/build/runtime. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1004).

## V1005 — Aatrox W, variantes de tooltip

Audit ciblé clos pour les quatre ressources de buff Life/Power : membership dans le projet client sélectionné, SHA-256 et correspondance de leurs clés BuffData.DynamicTooltip aux quatre entrées en_GB contrôlées. La clé générique game_buff_tooltip_AatroxW reste absente et le code actuel ne consomme pas les textes de sort; le dispatch Aatrox reste refusé. CH-Aatrox-W-SOURCE demeure a_qualifier; comportement, sélection des buffs/tooltip, Map10 et dépendance identité ouverts. Reprise seulement sur preuve d’activation/sélection ou consumer de traduction réel. Aucun test/build/runtime, statut, code, goal, registre, checkpoint, application ou base modifié. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1005).
## V1006 — source-consumer de l’entrée 1005

L’audit de l’exigence OLF-476a5280-c346-59f0-8c6b-3433b902d094 relie le INIBIN natif 1005 à l’entrée absente de la boutique et au refus crates/core/src/shop.rs. Le source identifie le Meki Pendant, FlatMPRegenMod=1.4, InStore=0, CanBeSold=1; la locale en_GB affiche +7 mana/5 s. DDragon 4.20.1 et shop_foundation n’ont pas de ligne 1005; Map10 n’a pas de décision. La classification « hors boutique » est étayée, son usage historique hors boutique reste inconnu; ne pas ajouter l’objet. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1006). Aucun code, tâche, statut, goal, registre, checkpoint, application ou base modifié.
## V1007 — source-consumer de l’entrée 1007

Le Regrowth Pendant natif (OLS-87be…) donne Price=435, InStore=0, CanBeSold=1 et FlatHPRegenMod=3; la locale dit +15 PV/5 s. DDragon 4.20.1, shop_foundation et l’admission Map10 n’ont pas de ligne 1007. Le lookup actuel refuse l’achat/la vente faute d’entrée; le consumer ne traite pas la régénération PV plate. L’audit du lien est clos, mais l’usage historique hors boutique et Map10 restent inconnus. Tâche NATIVE-ITEM-1007-SCOPE a_faire; aucun code ni statut changé. Détail : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1007).
## Reprise V1008 — audit borné ITEM-1043-SCOPE

1043 est relié au natif 4.20.0.315 (516 octets, SHA-256 60b4dcbf…), au texte en_GB et au refus du lookup actuel, car l’objet n’a pas de définition ni d’admission Map10 locale. La liaison statique est documentée; Map10 historique, test/runtime, icône DDS et priorité RADS restent inconnus. Statut de tâche inchangé. Rectification V880 : un test multi-objets achète bien 3067, mais le test ciblé n’a pas démarré faute d’accès au verrou target. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1008).
## V1009 — ITEM-1063-SCOPE : limite Map10

Le catalogue officiel 4.20.1 confirme maps["10"]=false pour Prospector’s Ring, malgré purchasable=true. Le binaire exact 4.20.0.315 confirme InStore=1 mais ne tranche pas la carte; le consumer local refuse l’ID faute de définition, sans règle Map10 explicite. Décision 4.20.1 établie; scope exact du client, runtime et acceptation restent ouverts. Aucune tâche/statut modifié. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md (V1009).
## V1010 — ITEM-1056 FlatMPRegenMod

Le contrôle natif brut résout l’incertitude précédente : deux lecteurs concordent sur 0,6 dans 1056.inibin; le contrôle positif 1005 vaut 1,4. L’export JSON omettait la clé. Source → consumer audité statiquement; le catalogue/consumer restent incomplets, aucun achat ni effet exécuté. Fonctionnalité et acceptation ouvertes, statut inchangé. Détail : `docs/AUDIT_SYS01202_ITEM1056_FLATMPREGENMOD_2026-11-02.md` (addendum V1010). Prochaine action : choisir une autre exigence ouverte non déjà auditée avec source F et consumer actuel; réutiliser ses preuves et clore seulement son périmètre.
## V1011 — NATIVE-ITEM-1500-SCOPE

Le fichier natif membre 4.20 classe 1500 comme non achetable/non revendable; il est absent des trois catalogues contrôlés, et shop.rs le refuserait statiquement. La classification boutique est auditée; aucun runtime, mode alternatif ni producteur serveur n’est établi. Statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1500_SCOPE_2026-11-02.md. Poursuivre sur une exigence distincte avec preuve source et consumer local, sans réexaminer 1500 si aucune nouvelle source n’apparaît.
## V1012 — NATIVE-ITEM-1501-SCOPE

Le natif 1501 est nommé « Fortification », mais ses champs déclarent prix nul, non-vente et absence d’effet/utilisation. Aucun catalogue ne le référence; shop.rs refuserait l’achat par lookup. Classification statique enregistrée; fonction de jeu, producteur, mode et runtime inconnus. Statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1501_SCOPE_2026-11-02.md. Reprise seulement sur source primaire d’un usage réel; ne pas assimiler le nom localisé à une mécanique.
## V1013 — NATIVE-ITEM-1502-SCOPE

Le natif et la locale en_GB nomment l’ID 1502 « Reinforced Armor ». Prix, store et vente sont nuls; aucune statistique/recette/activation contrôlée. Absent des catalogues, refus statique au lookup. Usage en mode, producteur et effet inconnus; statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1502_SCOPE_2026-11-02.md. Ne pas inférer de mécanique depuis le nom ou l’icône.
## V1014 — NATIVE-ITEM-1503-SCOPE

1503 est nommé Warden’s Eye, avec le texte Stealth detection, mais le natif déclare InStore=0 et CanBeSold=0; aucune entrée de shop ne le référence. Le lookup actuel refuserait l’achat. L’effet et le mode restent inconnus; statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1503_SCOPE_2026-11-02.md. Ne pas inférer une mécanique depuis le tooltip.
## V1015 — NATIVE-ITEM-1504-SCOPE

Le natif et la locale nomment 1504 « Vanguard »; ses flags indiquent prix nul, non-store, non-vendable et aucun effet/stat contrôlé. Absent des catalogues, achat refusé statiquement par lookup. La fonction supposée d’après le nom/icone reste non prouvée. Statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1504_SCOPE_2026-11-02.md.
## V1016 — NATIVE-ITEM-1505-SCOPE

1505 est localisé Lightning Rod, mais ses flags déclarent Price=0, InStore=0 et CanBeSold=0, sans effet/stat/recette contrôlé. Absent des catalogues; shop.rs le refuserait statiquement. La mécanique, le producer et le mode ne sont pas établis. Statut a_faire inchangé. Rapport : docs/AUDIT_SYS01202_ITEM1505_SCOPE_2026-11-02.md.

## V1017 — Garen E Effect1 : source native vers dégâts des pulsations

L’INIBIN 4.20.0.315 OLS-f118485c… (1 125 octets, SHA A8C5…C49DC3; membership manifest 0.0.0.181) donne Effect1 20/45/70/95/120, Effect3 70/80/90/100/110 %, Effect2 3 s. spells.rs::garen_value puis Simulation::cast/advance_spells consomme ces rangs dans le calcul de dégâts physiques. Trois tests précompilés ciblés ont réussi : six pulsations, tous les rangs, et refus de recast sous silence. Binaire réutilisé du reçu V858, non rehashé ni reconstruit. Lot source→consumer clos; la capacité entière, critiques, collisions, runtime original et acceptation restent ouverts. Détails : docs/AUDIT_SYS01202_GAREN_E_EFFECT1_LINK_2026-11-02.md. Le checkpoint pointe encore sur ITEM-3024, déjà reçu en V858; ne pas le rejouer.

## V1018 — Heal : cooldown source → consommateur

Lot limité à `SUMMONER-SummonerHeal-SCOPE` : INIBIN 4.20 et Data Dragon 4.20.1 donnent 300 s; `heal_rules.json` et `cast_heal` consomment 240 s, avec un override historique 4.5 référencé secondairement. Le refus sur recharge est relié statiquement; test non exécuté. Le lien est documenté comme divergence, sans décider le réglage serveur 4.20. La tâche reste `a_qualifier`; cartes, déblocage, sélection de cible et runtime ouverts. Reprise seulement sur source serveur/config 4.20 ou reçu runtime. Voir `docs/AUDIT_SYS01202_SUMMONER_HEAL_COOLDOWN_LINK_2026-11-02.md`.
## V1019 — Barrier : cooldown source → consommateur

`SUMMONER-SummonerBarrier-SCOPE` : INIBIN natif (842 o, SHA EB5286…) et catalogue Data Dragon 4.20.1 donnent 210 s; `barrier_rules.json` fournit 210 au consumer `summoners.rs`, qui programme `ready_at` et refuse un recast anticipé. Test existant inspecté, non exécuté. Audit de ce champ clos; annotation source locale « à vérifier » désormais obsolète. Mode Map10, unlock, modificateurs et acceptation restent ouverts. Voir `docs/AUDIT_SYS01202_SUMMONER_BARRIER_COOLDOWN_LINK_2026-11-03.md`.
## V1020 — Barrier : seuil d’unlock, consumer AIR vs OpenLeague

La référence 4.20.1 donne `summonerLevel=4`; le consumer AIR 4.20 lu dans `CreateSpellSelectionsCommand` active une option si `Spell.minLevel <= session.summonerLevel` et si le mode l’autorise. OpenLeague lit `OPENLEAGUE_SUMMONERS`, mais son `JoinRequest` n’a aucun niveau et le core ne vérifie que les doublons avant stockage. Écart d’unlock documenté statiquement; le mapping payload AIR/Data Dragon, le refus serveur historique et l’implémentation OpenLeague restent ouverts. `SUMMONER-SummonerBarrier-SCOPE` reste `a_qualifier`. Détail : `docs/AUDIT_SYS01202_SUMMONER_BARRIER_UNLOCK_LINK_2026-11-03.md`.
## V1021 — SYS-01.2-02 : producteur AIR et asset absent

L’AIR construit le dictionnaire de sorts depuis /assets/swfs/AirGeneratedContent.swf puis consomme chaque objet par Spell.minLevel, filtre de mode et niveau de compte. Le manifeste 0.0.1.119 attend cet asset (63 377 o, MD5 fd8778eedf8d83e22f34660ac37fc166), mais aucune copie n’a été trouvée dans les racines de référence locales contrôlées. Source exacte identifiée; payload Barrier et égalité summonerLevel/minLevel restent inconnus jusqu’à récupération du binaire. Audit de chaîne clos, tâche/fonction toujours ouvertes. Reprise seulement sur l’asset exact; détail et empreintes dans docs/AUDIT_SYS01202_SUMMONER_BARRIER_UNLOCK_LINK_2026-11-03.md, addendum V1021.
## V1022 — recherche communautaire de AirGeneratedContent.swf

Recherche web bornée par MD5, nom et chemin de release : aucun fichier correspondant trouvé. Un résultat secondaire ancien confirme le chemin 0.0.1.119 mais ne contient ni copie ni preuve de hash. Ne pas relancer la même recherche sans nouveau miroir/paquet. La reprise reste sur récupération de l’asset exact et vérification taille+MD5; voir l’addendum V1022 du rapport Barrier.
## V1023 — recherche locale ciblée et outil de reprise

Aucune copie d’AirGeneratedContent.swf dans les dossiers C: ciblés (Téléchargements, Bureau, Documents, Temp, caches Riot et ProgramData); le disque C: n’a pas été scanné intégralement. FFDec (5 271 501 o) et JDK 21 sont déjà disponibles, aucune installation nécessaire. Ne pas rescanner les mêmes dossiers sans nouvelle piste. Le payload reste ouvert jusqu’à récupération de l’asset exact.
## V1024 — SYS-01.2-02 / Cleanse

Clôture statique d’un seul lien : INIBIN SummonerBoost 4.20 membre de la release, cooldown 210 / CastRange 200 décodés ; le catalogue 4.20.1 indique Cleanse / niveau 6, sans établir la disponibilité serveur EUW/Map10. Le consumer Rust n’a pas de variante Cleanse ni de dispatch ; son refus au décodage est prévisible par le type mais n’a pas été exécuté. Audit du lien clos, fonctionnalité et tâche SUMMONER-SummonerBoost-SCOPE toujours ouvertes. Reprendre sur une preuve serveur primaire ou le payload AIR exact. Détails réutilisés et limites : docs/audit/units/AUD-17.1-04-SUMMONERS-01.md, R8.

## V1025 — ITEM-3024 / réconciliation Map10

Le reçu ciblé ITEM-3024 existait déjà; le checkpoint resume est donc ancien. Réutilisé sans rejouer son test CDR ni le hash/décodage de l’INIBIN. V996–V997 et une vérification ciblée confirment que 3024 est absent de LEVELS/Map10/Items.inibin, tandis que Data Dragon 4.20.1 basic.maps[10] et le contrat local admettent l’item. La liste native ressemble fortement à une exclusion Map10 (85/85 entrées maps[10]=false, zéro maps[10]=true), mais nom de clé et consumer natif restent inconnus : disponibilité historique probable, pas établie. Tâche ITEM-3024-SCOPE reste partiel_a_terminer. Rapport complété : docs/AUDIT_SYS01202_ITEM3024_GLACIAL_SHROUD_2026-11-02.md. Prérequis D01-SYS-01-1 reste a_faire.

## V1026 — ITEM-3143-SCOPE / Randuin’s Omen

Lien statique source → consumer établi pour cette exigence sans reçu ciblé : INIBIN 4.20 membre/hash vérifiés, prix de combinaison 800, recette 3082+1011 et +500 PV/+70 armure; Data Dragon 4.20.1 total 2850 et basic.maps[10]=true. Le consumer shop n’a ni ligne catalogue ni admission pour 3143; l’UI ne le liste pas et buy_item prédirait « item behavior not implemented » avant tout refus Map10. Le reçu Map10 V996–V997 rend son admission probable, pas prouvée historiquement. Tâche reste a_qualifier; détail dans le journal des traces V1026. Gate D01-01 encore ouvert.

## V1027 — ITEM-3082-SCOPE / Warden’s Mail

Lien statique source → consumer ajouté pour le composant de recette de 3143 : INIBIN 4.20 membre/hash vérifiés, prix 450, recette 1029+1029, +45 armure; Data Dragon 4.20.1 total 1050. Shop Foundation et admission Map10 n’ont pas d’entrée 3082; l’UI le masque et buy_item prédirait le refus générique d’objet non implémenté. L’ID est absent de la liste Map10 native, ce qui suggère une non-exclusion sans la prouver. Audit du lien clos statiquement, tâche ITEM-3082-SCOPE toujours a_qualifier. Détail : journal des traces V1027.

## V1028 — SYS-01.2-02 / ITEM-1054-SCOPE

Lien source→consumer audité statiquement : INIBIN 4.20.0.315 (483 o, SHA ba48836d…), membership client release 0.0.1.7, catalogue officiel 4.20.1 et consumer `shop.rs` reliés. Prix natif/catalogue 440 et +80 PV concordent; Data Dragon 4.20.1 ajoute régénération/passif mais `maps` est nul. Aucun catalogue/admission Map10 local : le code prédit le refus générique avant la règle de carte. Aucun runtime/test/build. Sous-audit de lien clos; ITEM-1054-SCOPE reste `a_qualifier`, car disponibilité historique et passifs serveur 4.20.0.315 ne sont pas prouvés. Détail V1028 dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`. Statuts/registre inchangés.
## V1029 — SYS-01.2-02 / ITEM-1074-SCOPE

La source native 4.20.0.315 (535 o, membership vérifiée) est reliée au catalogue 4.20.1 et au consumer shop. Data Dragon marque explicitement `maps[10]=false`; la liste native Map10 concorde au niveau de l’ensemble V996–V997, ce qui implique la présence de 1074, mais le lecteur/champ reste inconnu : exclusion historique probable, non prouvée. Le produit local n’a ni entrée catalogue ni admission et prédirait le refus générique avant le test Map10. Sous-audit statique clos pour le catalogue 4.20.1 et le consumer actuel; ITEM-1074-SCOPE reste `a_qualifier`. Aucun runtime/test/build. Détail V1029 dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.
## V1030 — SYS-01.2-02 / ITEM-1075-SCOPE

La source native 4.20.0.315 (533 o, membership client vérifiée) concorde sur les stats et le prix avec Data Dragon 4.20.1, qui marque `maps[10]=false`. Selon le croisement V996–V997, 1075 appartient à la liste native Map10; le sens du lecteur reste inféré. Le consumer local n’a ni donnée ni admission et prédit le refus générique avant Map10. Sous-audit catalogue/consumer clos statiquement; tâche `ITEM-1075-SCOPE` reste `a_qualifier` tant qu’aucune source primaire ne prouve la règle historique. Aucun test/build/runtime ni statut modifié. Détail V1030 dans `docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md`.
## V1031 — SYS-01.2-02 / ITEM-1076-SCOPE

L’INIBIN 4.20.0.315 (536 o, membership vérifiée) et Data Dragon 4.20.1 concordent sur le prix et les +60 PV. Data Dragon marque `maps[10]=false` et décrit +15 AP, régénération et +4 mana à l’élimination; ces effets 4.20.1 ne sont pas qualifiés par le reçu natif conservé. V996–V997 impliquent la présence dans la liste Map10, mais son lecteur/sémantique reste inconnu. Donnée/admission locales absentes; `shop.rs` prédit le refus générique. Sous-audit statique clos; `ITEM-1076-SCOPE` reste `a_qualifier`. Aucun test/build/runtime ni statut modifié. Détail V1031 dans le journal des traces.
## V1032 — SYS-01.2-02 / ITEM-1080-SCOPE

Lot source→consumer clos statiquement : INIBIN 4.20.0.315 (558 o, membership existante; SHA-256 b6f876f79bb1239a8c66e7dfad221bdd82c68fdeff9519169567c7114e93a70d), catalogue officiel 4.20.1 et shop.rs reliés. Prix natif 15 et recette 1039+1004+1006 concordent avec le catalogue; son passif (+20 % dégâts monstres, soin 6 %, mana 3 %) reste seulement une donnée 4.20.1. La corrélation V996–V997 implique la présence dans la liste Map10 sans prouver le sens du lecteur. L’objet est absent du shop local; le code prédit le refus générique avant Map10. Résolveur ciblé code 0, unknown_ids=[], game_behavior_accepted=false. ITEM-1080-SCOPE reste a_qualifier tant qu’aucune preuve primaire ne tranche Map10 sur 4.20.0.315. Détail V1032 dans docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md. Aucun statut, app, base, plan ou code modifié.

## Addendum V1032 — racines E:/F:

Le résolveur garde des chemins enregistrés E:/OpenLeague malgré --root F:/OpenLeague. Les copies F: de shop_foundation.json et native-release-membership.json ont été hachées et correspondent aux empreintes de la trace (504ad86b… et 8cfb03b7…). Le code shop.rs a été inspecté directement sur F:. Le contenu est confirmé, mais l’ancrage absolu reste périmé; ses registres n’ont pas été changés. Détail et condition de reprise dans l’addendum V1032 du journal d’audit.

## V1033 — SYS-01.2-02 / ITEM-2004-SCOPE

Consumer d’usage identifié statiquement pour 2004 : lib.rs:615 → consumables.rs:8–23, puis lib.rs:727 → advance_consumables:25–34. La sous-trace ne relie que shop.rs:69; consumer d’usage et ressources natives FlaskOfCrystalWater restent hors de ses liens. Valeurs locales 100 mana/15 s et admission Map10 réutilisées depuis V857; catalogue officiel 4.20.1, pas preuve serveur. Résolveur ciblé code 0, unknown_ids=[], behavior non accepté. Reçu V856/V857 réutilisé, aucun test rerun. Le sous-audit consumer est clos; la tâche reste partiel_a_terminer, et D01-SYS-01-1 demeure le gate d’intégration. Détail V1033 dans le journal. Aucun registre, statut, goal, application ou base modifié.

## V1034 — SYS-01.2-02 / ITEM-2009-SCOPE

Lien statique établi : INIBIN item 2009 (532 o, membership 0.0.0.235) → SpellName ItemMiniRegenPotion → INIBIN de sort enregistré (916 o, release 0.0.0.137) et refusal shop.rs:86. Data Dragon 4.20.1 dit 80 PV/50 mana sur 10 s, mais l’objet n’est pas achetable et aucun champ maps n’est présent; acquisition et historique serveur restent inconnus. La copie communautaire trouvée a un descriptif incompatible et n’est pas une preuve. Résolveur ciblé code 0, unknown_ids=[], comportement non accepté. Tâche a_qualifier; gate D01-SYS-01-1 ouvert. Détail V1034 dans le journal. Aucun code/registre/base/statut modifié.

## V1035 — SYS-01.2-02 / ITEM-2010-SCOPE

INIBIN 2010 (535 o, membership client concordante) relié au catalogue 4.20.1 et au refus shop.rs:86. Le catalogue dit non achetable, 20 PV/10 mana immédiats puis 150 PV/15 s, sans champ maps. Le même SpellName sert à 2009, mais ses effets catalogue diffèrent; aucune mécanique ne doit être transférée. Aucun consumer d’usage local trouvé; tâche reste a_qualifier. Résolveur code 0, unknown_ids=[], comportement non accepté. Détail V1035; aucun registre, code, goal ou base modifié.

## V1036 — SYS-01.2-02 / ITEM-2037-SCOPE

INIBIN natif 2037 (573 o, membership client vérifiée) relié à Data Dragon 4.20.1 et au refusal shop.rs:86. Prix 350 et piles 3 concordent; le catalogue marque maps[10]=false et décrit +120–235 PV/+15 dégâts pendant 3 min. V996–V997 impliquent une présence dans la liste Map10 sans en prouver la sémantique. Source PotionOfGiantStrength.inibin enregistrée, non décodée/exécutée. Objet absent du shop/admission locaux; tâche reste a_qualifier. Résolveur code 0, unknown_ids=[], comportement non accepté. Détail V1036; aucun code/registre/statut modifié.

## V1037 — SYS-01.2-02 / ITEM-2039-SCOPE

INIBIN 2039 (575 o, membership client concordante) relié au catalogue 4.20.1 et au refus shop.rs:86. Prix 250/piles 3 concordent; le catalogue donne +25–40 AP, +10 % CDR sur 3 min et maps[10]=false. V996–V997 impliquent une entrée dans la liste native sans en prouver le sens. Spell PotionOfBrilliance référencé globalement, non décodé/exécuté ni lié à la tâche. Objet absent du shop/admission locaux; tâche reste a_qualifier. Résolveur code 0, unknown_ids=[], comportement non accepté. Détail V1037; aucun code/registre/statut modifié.

## V1038 — SYS-01.2-02 / ITEM-2040-SCOPE

Le lien statique source native 2040 (560 o, membership client 4.20 concordante) → catalogue officiel 4.20.1 → refus actuel `shop.rs:86` est établi. Valeurs natives 500 PO, `InStore=true`, 3 charges, sort `ElixirOfRage`, sans recette; le catalogue 4.20.1 exclut l’item de Map10 et donne les valeurs d’effet, sans prouver le serveur 4.20.0.315. La corrélation Map10 V996–V997 implique sa présence dans la liste sans identifier le lecteur ou la sémantique. OpenLeague ne le définit/admet pas et prédit un refus générique. Sous-audit statique source→consumer clos; `ITEM-2040-SCOPE` reste `a_qualifier`, disponibilité historique non décidée. Résolveur code 0, `unknown_ids=[]`; aucune exécution/tests/build. Détail V1038 dans le journal. Aucun statut, goal, app ou base modifié.
## V1039 — SYS-01.2-02 / inconnue CRT OLU-3293

La trace parent actuelle contient 4 297 sources natives, 4 958 références, 1 319 consumers et cinq inconnues ouvertes. Pour OLU-3293, le binaire exact 4.20.0.315 (OLS-0d51b5dc…; SHA-256 402bf2b9…) a 27 références directes à `0x14ae870` : 26 comparaisons à zéro et un magasin à `1` à VA `0xCA99C9`. Son import table contient `EnumSystemLocalesW`, `IsValidLocale`, `GetLocaleInfoW`; cela ne prouve ni l’appel au démarrage ni l’état CRT/thread effectif. Inconnue toujours ouverte. Reprise sur le caller de `0xCA99C9`, puis initialisation et tables réelles; ne pas refaire le census xref/hash. Détail V1039 dans le journal; aucun statut, goal, app ou base modifié.
## V1040 — erratum et branche CRT non-C

Correction V1039 : l’instruction store commence à VA `0xCA99C7`; `0xCA99C9` est son opérande absolu dans le fichier. Le code autour compare le pointeur d’argument `[ebp+0x0C]` au littéral UTF-16 `L"C"` via `0xCB6B7E`; si non nul et différent, il écrit 1 dans `0x14AE870`. L’appelant, son adresse de fonction et son exécution au démarrage restent inconnus; ne pas assimiler le paramètre à `locale.cfg`. PDB embarqué absent et aucun décodeur machine-code testé disponible; pas d’installation. OLU-3293 reste ouverte. Détail V1040 dans le journal; aucun statut, goal, app ou base modifié.
## V1041 — SYS-01.2-02 / locale.cfg

LoLPatcher 0.0.0.11 contient des références de code au chemin data/cfg/defaults/locale.cfg et au modèle [General] puis LanguageLocaleRegion=; le fichier original en_GB correspondant est absent des deux manifests client épinglés. Candidat de provenance fort, écriture des 37 octets non prouvée. Le contrôle strict membership refuse la racine F parce que le catalogue conserve les chemins absolus E; les hashes des manifests F correspondent et le parsing direct réussit. OLU-0ae207ed et la question startup/montage restent ouvertes. Détail V1041 dans le journal. Goal, plan, code, registres, app et bases inchangés.
## V1042 — erratum V1041 / consommateur locale.cfg

Sous-audit source → sélection du profil clos statiquement : le chemin Rust main.rs → native_zip_provider.rs → native_hud_font_configuration.rs existe et le fichier local correspond au défaut 4.20. Preuves V795 réutilisées sans relancer les tests. Ce résultat ne qualifie ni la génération par le patcher, ni les traductions, le rendu ou le client complet. OLU-0ae207ed et OLU-29959b0b restent ouvertes. Preuve détaillée et conditions de reprise : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, section V1042.

## V1043 — résultat de recherche PDB

Piste exacte LoLPatcher.pdb (GUID 1c5218f899cf4741be88500125edccea, Age 173) close pour les recherches déjà faites : Symbol Server renvoie 404 sur les clés AD et 173; aucun résultat indexé pertinent. Ce n’est pas une preuve d’absence partout. Ne pas répéter ces requêtes. OLU-0ae207ed reste ouverte; reprise sur un nouveau PDB/source/décodeur déjà disponible. Détail : docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V1043.

## V1044 — source locale → producteur patcher → défaut client

Sous-audit statique clos pour le chemin de production candidat : RADS/system/locale.cfg (locale=en_gb) → getter RADS → writer LoLPatcher.exe en mode wt → chemin logique /data/cfg/defaults/locale.cfg. Le résultat dérivé en_GB + traduction CRLF est identique aux 37 octets de la référence (SHA-256 053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f). Aucune exécution historique ni racine physique du writer prouvée. OLU-0ae207ed et OLU-29959b0b restent ouvertes. REA n’a pas pu analyser le caller 0x4af8a0 sous la restriction d’accès au temporaire; détails et reprise dans le journal V1044.
## V1045 — candidat LoLPatcher écarté pour URF/Cheats nommés

Le scan ASCII insensible à la casse du LoLPatcher.exe exact (V1044) ne trouve aucune référence directe à Urf.inibin, Cheats.cfg ou à leurs chemins. Cela écarte uniquement ce producteur nommé; OLU-6c4ea73e et OLU-f76e6025 restent ouvertes pour chemins calculés, autre producteur, overlay et sélection au démarrage. Ne pas répéter le scan sur ce binaire; reprendre seulement sur un nouveau candidat ou une trace effective. Détail dans le journal V1045.
## V1046 — binaire client et chemins URF/Cheats

Le PE client 4.20.0.315 exact (OLS-0d51b5dc…, SHA-256 402bf2b9…) ne contient pas les quatre chemins URF/Cheats recherchés en ASCII ni UTF-16LE. Cela ne prouve pas l’absence d’un chemin calculé ou d’un lecteur générique. OLU-6c4ea73e et OLU-f76e6025 restent ouvertes sur l’origine/overlay et le choix au démarrage. Ne pas répéter ce scan sur le même hash; détail V1046 dans le journal.
## V1047 — ITEM-3025 : source, Map10 et refus shop

Le JSON officiel 4.20.1 donne coût 750/2900, vente 2030 et recette 3057+3024; son basic.maps indique Map10=true, sans override maps dans 3025. Le INIBIN natif exact 4.20.0.315 donne prix/recette/InStore mais aucun Map10 décodé. Le consumer Rust utilise shop_foundation/admission, absents de l’ID 3025; le chemin attendu est le refus item behavior not implemented avant le garde Map10. Sous-audit source→consumer clos statiquement; ITEM-3025-SCOPE reste a_qualifier, test direct et disponibilité historique ouverts. Détail dans AUDIT_SYS01202_ITEM3025_ICEBORN_GAUNTLET_REFUSAL_2026-11-02.md, V1047.
## V1048 — ITEM-3026 : Guardian Angel

Source native 4.20.0.315 rehashée; données de prix/recette/stats concordent avec Data Dragon 4.20.1, qui indique Map10=false. Ce dernier n’est pas une preuve historique exacte. Le shop local ignore l’entrée et refuse item behavior not implemented avant le contrôle Map10; la règle d’admission locale est également absente. Audit du lien source→consumer clos statiquement; ITEM-3026-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3026_GUARDIAN_ANGEL_2026-11-03.md.
## V1049 — ITEM-3027 : Rod of Ages

Source native 4.20.0.315 rehashée et membre du manifest; Data Dragon 4.20.1 concorde sur base 740 et recette 3010+1026, avec Map10=true dans basic.maps mais aucun override 3027. Ce catalogue ne décide pas l’historique exact. Le consumer shop local ignore l’entrée et refuse item behavior not implemented avant le garde carte; sa table d’admission ne contient pas l’ID. Audit source→consumer clos statiquement; ITEM-3027-SCOPE reste a_qualifier. Détail : AUDIT_SYS01202_ITEM3027_ROD_OF_AGES_2026-11-03.md.
## V1050 — ITEM-3028 : Chalice of Harmony

Source native 4.20.0.315 rehashée et membre du manifest; Data Dragon 4.20.1 concorde sur base 140, composants 1004+1033+1004 et indique Map10=true dans basic.maps sans override 3028. Le consumer shop actuel ignore l’entrée et refuse item behavior not implemented avant le contrôle carte; l’admission locale est absente. Audit source→consumer clos statiquement; ITEM-3028-SCOPE reste a_qualifier. Détail : AUDIT_SYS01202_ITEM3028_CHALICE_OF_HARMONY_2026-11-03.md.
## V1051 — ITEM-3029 : Rod of Ages (Crystal Scar)

La source native 4.20.0.315 est rehashée et membre du manifest; Data Dragon officiel 4.20.1 indique explicitement maps[10]=false. Aucun champ Map10 n’est décodé du source exact. Le shop local n’a ni l’item ni une règle d’admission; le consumer refuse avant le contrôle de carte. Audit source→consumer clos statiquement; ITEM-3029-SCOPE reste a_qualifier, disponibilité historique et feature ouvertes. Détail : AUDIT_SYS01202_ITEM3029_ROA_CRYSTAL_SCAR_2026-11-03.md.
## V1052 — ITEM-3031 : Infinity Edge

Le catalogue officiel 4.20.1 porte maps[10]=false et concorde sur base 645/recette; l’INIBIN natif 4.20.0.315 ne fournit pas de champ Map10 décodé. Le shop local n’a ni définition ni admission de l’objet; son consumer renvoie item behavior not implemented avant le garde carte. Audit statique source→consumer clos; ITEM-3031-SCOPE reste a_qualifier. Détail : AUDIT_SYS01202_ITEM3031_INFINITY_EDGE_2026-11-03.md.

## V1053 — ITEM-3084-SCOPE : Overlord's Bloodmail

Sous-audit statique source → référence 4.20.1 → consumer clos. Preuve native/membership du reçu item_shop-links.json réutilisée sans rehash; 3084 n’est présent ni dans les 33 définitions de shop_foundation.json ni dans les 33 admissions Map10. Le consumer Rust refuse avant la garde de carte avec item behavior not implemented. Data Dragon 4.20.1 indique maps[1]=false et maps[12]=false mais ne fournit pas de valeur map 10; l’historique Map10 4.20.0.315 reste indécidé. ITEM-3084-SCOPE reste a_qualifier, et aucune feature n’est déclarée terminée. Détail : docs/AUDIT_SYS01202_ITEM3084_OVERLORDS_BLOODMAIL_2026-11-03.md.

Reprise seulement sur une source Map10 native attribuable au build exact ou une observation reproductible du client 4.20.0.315. Ne pas refaire le rehash ni le test générique de refus; aucun test direct 3084 n’a été exécuté. Aucun statut, code, goal, Plan, application ou base modifié.


## V1054 — ITEM-3085-SCOPE : Runaan's Hurricane

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership item_shop-links réutilisé sans rehash : 3085 n’est pas dans les listes actuelles de 33 objets; le consumer refuse avec item behavior not implemented avant la garde Map10. Data Dragon 4.20.1 ne fournit pas de champ maps. Le natif consigne SpellName=AtmasImpalerDummySpell alors que la référence décrit les carreaux de Runaan; le lien reste à établir. Disponibilité Map10 historique 4.20.0.315 et comportement restent ouverts; ITEM-3085-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3085_RUNAANS_HURRICANE_2026-11-03.md.

Reprise seulement sur source Map10 native/merchant du build exact ou observation reproductible; pour le passif, sur preuve de lien SpellName/callsite. Ne pas rehash ni rejouer le refus générique. Aucun test direct exécuté et aucune feature déclarée terminée.


## V1055 — ITEM-3086-SCOPE : Zeal

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash. Le natif donne prix 250 et recette 1051+1042; le catalogue 4.20.1 concorde, sans champ maps. Le shop et l’admission locaux ont chacun 33 lignes et ignorent 3086; le consumer refuse avant le garde Map10 avec item behavior not implemented. Historique Map10 4.20.0.315 et feature restent ouverts; ITEM-3086-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3086_ZEAL_2026-11-03.md.

Reprise uniquement sur source Map10/merchant native du build exact ou observation reproductible. Ne pas refaire les hashes ou le refus générique; aucun test direct exécuté.


## V1056 — ITEM-3087-SCOPE : Statikk Shiv

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : 3087, prix 600, recette 3086+3093. Les tables shop et admission Map10 ont chacune 33 entrées et excluent l’ID; le consumer refuse avec item behavior not implemented avant le garde de carte. Data Dragon 4.20.1 ne fournit pas de champ maps. La disponibilité historique Map10 4.20.0.315, le passif et la feature restent ouverts; ITEM-3087-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3087_STATIKK_SHIV_2026-11-03.md.

Reprise uniquement sur source native/merchant Map10 du build exact ou observation reproductible. Ne pas refaire le hash ni le refus générique; aucun test direct exécuté.


## V1057 — ITEM-3090-SCOPE : Wooglet's Witchcap

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : 3090 a InStore=1, UseEffect=1 et SpellName=ZhonyasHourglass. Le shop et l’admission Map10 l’omettent; le consumer refuse avec item behavior not implemented. La recherche ciblée dans crates/core/src ne trouve pas de callsite item correspondant; dispatch dynamique non exclu. Data Dragon 4.20.1 indique maps[1]=false et maps[12]=false, sans clé 10. Disponibilité Map10 4.20.0.315 et actif restent ouverts; ITEM-3090-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3090_WOOGLETS_WITCHCAP_2026-11-03.md.

Reprise seulement sur source Map10/merchant du build exact, observation reproductible ou callsite natif SpellName → actif. Ne pas refaire les hashes ou la recherche ciblée sans nouvel indice; aucun test direct exécuté.


## V1058 — ITEM-3091-SCOPE : Wit's End

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 750, recette 1043+1033+1042, InStore=1. Les listes shop et admission Map10 ont chacune 33 lignes et omettent 3091; le consumer refuse avec item behavior not implemented avant le garde carte. Data Dragon 4.20.1 ne porte pas de champ maps. Disponibilité Map10 4.20.0.315, passifs et feature restent ouverts; ITEM-3091-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3091_WITS_END_2026-11-03.md.

Reprise uniquement sur source Map10/merchant native du build exact ou observation reproductible. Ne pas rehash ni rejouer le refus générique; aucun test direct exécuté.


## V1059 — ITEM-3092-SCOPE : Frost Queen's Claim

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : 3092, prix 515, recette 3098+3108, Group=GoldBase, UseEffect=1, SpellName=ItemGlacialSpikeCast. Les listes shop/admission de 33 entrées excluent l’ID et le consumer renvoie item behavior not implemented. La recherche exacte du SpellName/groupe ne trouve pas de handler nommé dans crates/core/src. Data Dragon 4.20.1 n’a pas de champ maps. Map10 historique, actifs, Tribute et limite GoldBase restent ouverts; ITEM-3092-SCOPE demeure a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3092_FROST_QUEENS_CLAIM_2026-11-03.md.

Reprise sur source Map10/merchant 4.20.0.315 ou observation reproductible; pour les effets, sur callsite/dispatch natif identifié. Ne pas rehash ni répéter la recherche lexicale sans nouvel indice; aucun test direct exécuté.


## V1060 — ITEM-3093-SCOPE : Avarice Blade

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 400, recette 1051, InStore=1, SpellName=ArchAngelsDummySpell. Les listes shop/admission de 33 objets excluent 3093; refus actuel item behavior not implemented. La recherche textuelle ciblée n’a trouvé aucun handler nommé pour le SpellName ou Avarice/Greed. Data Dragon 4.20.1 n’a pas de champ maps. Map10 historique et passifs restent ouverts; ITEM-3093-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3093_AVARICE_BLADE_2026-11-03.md.

Reprise seulement sur preuve native Map10/merchant ou observation reproductible 4.20.0.315; pour les passifs, mapping/dispatch natif ou serveur qualifié. Ne pas refaire hash ni scan lexical sans indice nouveau; aucun test direct exécuté.


## V1061 — ITEM-3096-SCOPE : Nomad's Medallion

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 500, recette 3301, Group=GoldBase, SpellName=AtmasImpalerDummySpell. Les listes shop/admission de 33 entrées excluent 3096; le consumer refuse avec item behavior not implemented. La recherche textuelle Nomad/GoldBase/SpellName/Favor n’a trouvé aucun handler nommé. Data Dragon 4.20.1 ne fournit pas de maps. Map10 historique, passif Favor, groupe et feature restent ouverts; ITEM-3096-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3096_NOMADS_MEDALLION_2026-11-03.md.

Reprise sur source native Map10/merchant 4.20.0.315 ou observation reproductible; pour Favor/GoldBase, callsite ou règle autoritative. Ne pas rehash ni répéter le scan lexical sans indice nouveau; aucun test direct exécuté.


## V1062 — ITEM-3097-SCOPE : Targon's Brace

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 500, recette 3302, Group=GoldBase, SpellName=AtmasImpalerDummySpell. Les tables shop/admission de 33 entrées excluent 3097; le consumer refuse item behavior not implemented. Recherche ciblée Targon/Spoils/GoldBase/SpellName : aucun handler textuel. Data Dragon 4.20.1 ne porte pas de champ maps. Map10 historique, Spoils of War, charges et groupe restent ouverts; ITEM-3097-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3097_TARGONS_BRACE_2026-11-03.md.

Reprise sur source native Map10/merchant 4.20.0.315 ou observation reproductible; pour Spoils/GoldBase, callsite ou contrat qualifié. Ne pas refaire les hashes ou le scan lexical sans nouvel indice; aucun test direct exécuté.


## V1063 — ITEM-3098-SCOPE : Frostfang

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : 3098, prix 500, recette 3303, Group=GoldBase, SpellName=AtmasImpalerDummySpell. Shop et admission de 33 lignes omettent l’ID; refus item behavior not implemented. La recherche lexicale n’a trouvé aucun handler Frostfang; son seul résultat Tribute est le passif de Trundle, sans relation avec cet item. Data Dragon 4.20.1 ne fournit pas maps. Map10 historique, Tribute et Gold Income restent ouverts; ITEM-3098-SCOPE reste a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3098_FROSTFANG_2026-11-03.md.

Reprise sur source Map10/merchant 4.20.0.315 ou observation reproductible; pour Tribute, sur callsite/dispatch d’objet précis. Ne pas rehash ni refaire la recherche sans nouvel indice; aucun test direct exécuté.


## V1064 — ITEM-3100-SCOPE : Lich Bane

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 850, recette 3057+3113, UseEffect=0, SpellName=AtmasImpalerDummySpell. L’objet manque des listes shop/admission de 33 entrées; le consumer refuse item behavior not implemented. La recherche LichBane/Spellblade/SpellName ne trouve pas de handler textuel. Data Dragon 4.20.1 ne contient pas maps. Map10 historique, mapping du SpellName et Spellblade restent ouverts; ITEM-3100-SCOPE demeure a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3100_LICH_BANE_2026-11-03.md.

Reprise sur source Map10/merchant 4.20.0.315, observation reproductible ou callsite natif/serveur. Ne pas rehash ni répéter la recherche lexicale sans indice; aucun test direct exécuté.


## V1065 — ITEM-3102-SCOPE : Banshee's Veil

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 1150, recette 3211+1028. L’item manque des listes shop/admission de 33 entrées; refus item behavior not implemented avant Map10. Le code ne donne aucun handler Banshee; le seul commentaire sur les spell shields dit que cette mécanique reste non qualifiée. Data Dragon 4.20.1 ne fournit pas maps. Map10 historique et passif restent ouverts; ITEM-3102-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3102_BANSHEES_VEIL_2026-11-03.md.

Reprise sur source native Map10/merchant 4.20.0.315 ou observation reproductible; pour le passif, callsite natif/serveur ou preuve contrôlée. Ne pas rehash ni refaire la recherche lexicale sans indice nouveau; aucun test direct exécuté.


## V1066 — ITEM-3104-SCOPE : Lord Van Damm's Pillager

Sous-audit statique source → référence 4.20.1 → consumer clos. Reçu natif/membership réutilisé sans rehash : prix 995, recette 3122+1037+1018, InStore=1. L’objet manque des listes shop/admission de 33 entrées; le consumer renvoie item behavior not implemented avant Map10. Data Dragon 4.20.1 porte maps[1]=false et maps[12]=false, sans valeur 10. Disponibilité historique Map10 et passif critique restent ouverts; ITEM-3104-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3104_LORD_VAN_DAMMS_PILLAGER_2026-11-03.md.

Reprise sur source Map10/merchant 4.20.0.315 ou observation reproductible. Ne pas rehash ni refaire le contrôle consumer; aucun test direct exécuté.

## V1067 — ITEM-3105-SCOPE : Aegis of the Legion

Sous-audit documentaire source → référence 4.20.1 → consumer clos statiquement. Reçu natif/membership réutilisé sans rehash : DATA/Items/3105.inibin, 577 octets, SHA-256 7880115003900947fb3d6e8860d94de400e61291b7f95862bcc7e865c8f86ee6, Price=820, InStore=1, CanBeSold=1, recette 1028+1033+1006. Data Dragon 4.20.1 donne base 820, total 1900, vente 1330 et l’aura Legion, mais aucune propriété maps. Le shop foundation et l’admission Map10 ont chacun 33 entrées et omettent 3105; shop.rs prédit statiquement item behavior not implemented avant la garde Map10. Disponibilité Map10 historique 4.20.0.315 et effet d’aura restent ouverts; ITEM-3105-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3105_AEGIS_OF_THE_LEGION_2026-11-03.md. Aucun test direct, build, runtime ni statut modifié.
## V1068 — ITEM-3106-SCOPE : Madred's Razors

Sous-audit documentaire source → référence 4.20.1 → consumer boutique clos statiquement. Reçu natif/membership réutilisé sans rehash : DATA/Items/3106.inibin, 550 octets, SHA-256 31ce8f0a80f1d45cc673d05f77c8f7d7f901b808f26735f09933de515ce83e5d, Price=0, InStore=1, CanBeSold=1, recette 1042. Data Dragon 4.20.1 donne total 450, vente 315, +15% Attack Speed et maps[12]=false, sans décision Map10. Les deux listes locales de 33 entrées omettent 3106; le refus shop générique est réutilisé de V1067 et n’a pas été rejoué. Map10 historique, passif Maim et feature restent ouverts; ITEM-3106-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3106_MADREDS_RAZORS_2026-11-03.md. Aucun test direct ni statut modifié.
## V1069 — complément ITEM-3106-SCOPE : piste historique Map10

Nouvelle recherche ciblée : la page communautaire League of Legends Wiki indique Madred's Razors exclusif à Classic Twisted Treeline, retiré de Summoner's Rift en V4.20 puis de Twisted Treeline en V5.11; elle donne la recette Dagger + 0 = 450 pour V4.20. Cela soutient une disponibilité Map10 positive au niveau du patch, sans être une preuve Riot/native du binaire PUBLIC 4.20.0.315. Détail ajouté au rapport ITEM-3106 existant. Map10 exact reste à qualifier; reprise sur source officielle/native ou observation reproductible. Aucun statut modifié.
## V1070 — ITEM-3111-SCOPE : Mercury's Treads

Sous-audit documentaire source → catalogue 4.20.1 → consumer clos statiquement. Reçu natif/membership réutilisé : DATA/Items/3111.inibin, 576 octets, SHA-256 00a0b69d7a4d28ec0648b99927f01525fd1d0b95b54af7d95d4fec92ec211c0b, Price=375, InStore=1, CanBeSold=1, recette 1001+1033. Data Dragon 4.20.1 donne total 1200, vente 840 et aucun champ maps. Les deux tables locales de 33 entrées omettent 3111; refus statique partagé réutilisé de V1067. Recherche communautaire/public non datée non retenue pour décider Map10; historique 4.20.0.315 reste ouvert. ITEM-3111-SCOPE demeure a_qualifier. Détail : docs/AUDIT_SYS01202_ITEM3111_MERCURYS_TREADS_2026-11-03.md. Aucun test direct ni statut modifié.
## V1071 — ITEM-3113-SCOPE : Aether Wisp

Sous-audit documentaire source → catalogue 4.20.1 → consumer clos statiquement. Reçu natif/membership réutilisé : DATA/Items/3113.inibin, 530 octets, SHA-256 02806800cd7bfc1763affcff39bd57e6059461e221638b297e7a4a75006ba1db, Price=515, InStore=1, recette 1052. La référence 4.20.1 donne total 950, vente 665, sans champ maps; les tables shop/admission de 33 entrées omettent 3113, refus statique commun réutilisé de V1067. Un article communautaire de février 2015 montre Aether Wisp dans une recette TT, mais ne tranche pas 4.20.0.315. Historique Map10 reste ouvert; ITEM-3113-SCOPE demeure a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3113_AETHER_WISP_2026-11-03.md. Aucun test ni statut modifié.
## V1072 — ITEM-3115-SCOPE : Nashor's Tooth

Sous-audit documentaire source → Data Dragon 4.20.1 → consumer clos statiquement. Reçu natif/membership réutilisé sans rehash : DATA/Items/3115.inibin, 551 octets, SHA-256 27ac3578489437cf56ebec439fd73bc97eb8f4065942283fff3eb25ad1b7c53a, Price=850, InStore=1, recette 3101+3108. La référence donne total 2920, vente 2044, sans maps. Les tables shop/admission de 33 entrées omettent 3115; refus partagé réutilisé de V1067. Les listes communautaires trouvées sont non versionnées et insuffisantes pour 4.20. Map10 historique et passif restent ouverts; ITEM-3115-SCOPE demeure a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3115_NASHORS_TOOTH_2026-11-03.md. Aucun test/statut modifié.
## V1073 — ITEM-3116-SCOPE : Rylai's Crystal Scepter

Sous-audit statique source → Data Dragon 4.20.1 → consumer clos pour l’ID 3116. Reçu natif/membership réutilisé sans rehash : DATA/Items/3116.inibin, 527 octets, SHA-256 f90f5d694a1058fb252f634644b1ed9d506128f0bbaaaabbf70a4effd32c2b1b; Price=605, InStore=1, CanBeSold=1, recette 1026+1052+1011. La référence indique total 2900, vente 2030 et le passif Rylai, sans maps propre à l’entrée. Shop foundation et admission Map10 ont chacun 33 entrées et omettent 3116; le code prédit item behavior not implemented avant le contrôle Map10. Disponibilité exacte 4.20.0.315 et passif serveur restent ouverts; ITEM-3116-SCOPE demeure a_qualifier. Rapport : docs/AUDIT_SYS01202_ITEM3116_RYLAIS_CRYSTAL_SCEPTER_2026-11-03.md. Aucun test/build/runtime ni statut modifié.

## V1074 — ITEM-3116 : preuve Map10 et contradiction de format

Indice natif ajouté au rapport ITEM-3116 existant. Le décodeur ciblé de LEVELS/Map10/Items.inibin trouve 98 paires, 95 valeurs intégrales et aucune valeur 3116. Le PE exact contient la chaîne “Only the items explicitly listed in LEVELS\[MapName]\Items.ini will be in the store.”; une référence de code à la chaîne map10 est localisée, mais la procédure reste inconnue. L’ancien census suggère une liste d’exclusion, le texte PE une whitelist Items.ini; le lien Items.ini → Items.inibin n’est pas établi. REA search/xrefs/résolution ont expiré après 180 s; les reçus sont conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision1074_*. Ne pas répéter ces appels inchangés. Map10 exact 4.20.0.315 reste inconnu; ITEM-3116-SCOPE demeure a_qualifier. Aucun test, build, jeu ou statut modifié.

Complément V1074 : recherche rg sans exclusion dans les noms sous D:/LeagueOfLegendsV2/4.20, F:/OpenLeague et F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : aucun Items.ini. GitHub LeagueSandbox ciblé et recherche Web exacte : aucun résultat. Cela borne les emplacements consultés, sans prouver une absence globale; conserver l’inconnue et reprendre sur le fichier original ou le mapping INI→INIBIN.

## V1075 — ITEM-3116 : deux listes natives distinctes

Correction de V1074 : la citation conserve les antislashs; le début du texte est 0xC7F218 et l’opcode push map10 est 0x199A25. Les 98 clés de LEVELS/Map10/Items.inibin correspondent exactement à UnpurchasableItemList/Item0…Item97; les deux lecteurs existants concordent et 3116 ne figure pas parmi les valeurs. Le PE référence séparément ItemInclusionList et UnpurchasableItemList, avec un helper commun. Les deux listes peuvent coexister : ces preuves ne démontrent pas de contradiction. Les valeurs effectives des flags d’inclusion et l’admission historique restent inconnues; ITEM-3116-SCOPE demeure a_qualifier. Détails et limites : docs/AUDIT_SYS01202_ITEM3116_RYLAIS_CRYSTAL_SCEPTER_2026-11-03.md, addendum V1075. Aucun test de jeu, build ou statut modifié.

## V1076 — ITEM-3116-SHOP-ICONE : asset natif et chemin boutique

Sous-audit statique de l’icône clos : Data/InventoryIcon pointe vers 3116_Rylais_Sceptre.dds; les deux PNG locales et le DDS natif décodent en 16 384 octets RGBA identiques (SHA-256 pixels 683101bef4163ea15419826014a662e17cc3b275c899c5c47e547378de86b20b). FFmpeg 8.1 retourne 0 pour les trois fichiers. shop_ui charge ui/items/{id}.png pour les lignes admises, mais définition et admission 3116 manquent des deux tables actuelles. Aucun rendu runtime ni acceptation; ITEM-3116-SHOP-ICONE reste a_faire et dépend de ITEM-3116-SCOPE. Rapport ITEM-3116, addendum V1076.

## V1077 — ITEM-3116-SHOP-TEXTE : liaison native en_GB

Sous-audit statique clos : les trois champs INIBIN 3116 pointent vers les clés displayname, description et tooltip présentes dans fontconfig_en_GB; le tooltip contient @Value@. shop_ui lit item.name et item.description du catalogue et remplace {regen_5s}; 3116 manque du catalogue et de l’admission. Le rendu, la locale effective et l’injection de @Value@ restent ouverts; ITEM-3116-SHOP-TEXTE demeure a_faire, dépendant de ITEM-3116-SCOPE. Détail : rapport ITEM-3116, addendum V1077.

## V1078 — ITEM-3116 : paramètres d’inclusion natifs

Le PE initialise à zéro les champs de it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly, mais une méthode indirecte peut écrire leurs valeurs depuis une entrée numérique. Le code de 0x5B6600 conditionne ItemInclusionList au premier champ ou au second avec comparaison à TUTORIAL; UnpurchasableItemList est parcourue séparément. Les instructions ont été recoupées avec Capstone existant; aucune exécution du client. Configuration et valeurs effectives Map10 restent inconnues; ITEM-3116-SCOPE demeure a_qualifier. Rapport ITEM-3116, addendum V1078.

## V1079 — ITEM-3116-SHOP-PRIX : prix total et combinaison

Sous-audit statique clos : INIBIN Price=605, recette 1026+1052+1011; prix des composants 860+435+1000 et catalogue 4.20.1 total=2900, vente=2030. shop.rs attend Item.price total et crédite les composants : avec une future entrée à 2900, 605 est le coût calculé conditionnel avec les trois composants; une entrée à 605 échouerait à la validation de recette. 3116 manque du catalogue et son refus actuel est statique, non exécuté; SellBackModifier interrogé absent ne qualifie pas la revente native. Tâche a_faire, scope et runtime ouverts. Rapport ITEM-3116, addendum V1079.

## V1080 — ITEM-3116 : Constants.var et dispatch des paramètres

Le fichier natif LEVELS/Map10/Constants.var (19 433 octets, SHA-256 178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2) contient les deux paramètres d’inclusion à 0, lignes 12–13; son MD5 correspond au manifeste consigné. Le PE relie statiquement le résolveur Constants/.var, le lecteur de lignes %s = %s, le registre des noms et le setter numérique. Le provider et les surcharges effectivement retenus ne sont pas prouvés : les zéros restent conditionnels et ne valident pas l’achat 3116. ITEM-3116-SCOPE demeure a_qualifier. Rapport ITEM-3116, addendum V1080; aucun jeu ni parseur natif exécuté.

## V1081 — ITEM-3116 : nom et repli de configuration

Le résolveur natif construit Constants{suffixe}.var à partir de la chaîne fournie par 0x5B26E0. Pour un fournisseur nouvellement créé, la recherche consulte sa structure locale puis, si nécessaire, transmet le même nom à un objet de repli; aucun retrait de suffixe n’est établi. Seul Constants.var est présent dans le deploy/LEVELS/Map10 consulté. Le suffixe effectif, le fournisseur réel et les overlays restent inconnus; les zéros V1080 ne prouvent pas les valeurs finales. Rapport ITEM-3116, addendum V1081; scope a_qualifier, aucun runtime ni statut modifié.

## V1082 — ITEM-3116-SHOP-RECETTE : préparation et refus

Sous-audit statique clos : recette native 1026+1052+1011, référence totale 2900. plan_in prépare une copie, crédite les composants et utilise une case libre; buy_item applique après les contrôles ordinaires. Pour une future entrée valide avec les trois composants, le flux prédit 605 et une case libérée; inventaire plein sans composant et fonds insuffisants ont des refus distincts. Aucun de ces cas 3116 n’a été exécuté; aucun rollback face à panic/interruption n’est démontré. ITEM-3116-SHOP-RECETTE demeure a_faire, dépendant de ITEM-3116-SERVER. Rapport ITEM-3116, addendum V1082.

## V1083–V1084 — ITEM-3116 : santé et passif

Deux sous-audits statiques clos. La source native FlatHPPoolMod est la chaîne « 400 », normalisée à 400 par le second lecteur; le consumer local additionne health au maximum, mais 3116 manque du catalogue. Les trois EffectAmount natifs sont -0.35, -0.15 et 1.5 environ; le mécanisme local de ralentissement exige une fraction positive, donc un passage direct des nombres négatifs prédit invalid slow. Déclenchement, conversion, catégories, cumul, valeurs runtime et santé courante historique restent ouverts. Les deux tâches sont a_faire et dépendent du scope. Rapport ITEM-3116, addenda V1083–V1084; aucun test de jeu ni statut modifié.

## V1085 — suffixe de configuration Map10

Le constructeur 0x5B2280 initialise la chaîne de suffixe vide; 0x5B2590 la remplace et 0x5B26E0 la retourne. Deux appels directs vérifiés : chemin -mapID/-missionMode à 0x5753C9 si mapID diffère de -1 et missionMode est non vide; chemin d’une structure +0x986 à 0x58A516, sous un dispatch 0x54 non qualifié comme protocole. Si CLASSIC est fourni et conservé, le nom serait ConstantsCLASSIC.var; valeur réelle, ordre et provider restent inconnus. Rapport ITEM-3116, addendum V1085; aucun runtime ni statut modifié.

## V1086–V1087 — ITEM-3116 : puissance et dépendances du passif

Deux sous-audits statiques : FlatMagicDamageMod est « 100 » dans un lecteur et 100 dans le second; le consumer local somme la puissance puis applique 1 ou 1.1 selon deux autels, sous hypothèse d’une entrée 3116 intégrée. Le preload 3116 nomme internal_35slow, itemslow et internal_15slow; les chunks 3116/15/35 ne contiennent qu’un RETURN et ItemSlow seulement des métadonnées. Cela ne qualifie pas le déclenchement du passif. Tâches a_faire, scope et runtime ouverts; rapport ITEM-3116, addenda V1086–V1087.

## V1088 — suffixe Map10 : objet du dispatch

La table native 0x10AFDD0 porte au slot +0xF0 le wrapper 0x72B2D0 → 0x72B2F0; son constructeur 0x730560 est appelé par la fabrique 0x72F540. Cette liaison statique précise le chemin V1085, sans identifier le type ou le producteur de la structure ni la valeur réelle du suffixe. Scope 3116 toujours a_qualifier; rapport ITEM-3116, addendum V1088.

## V1089–V1090 — ITEM-3116 : serveur et parcours boutique

Sous-audits statiques clos dans leurs bornes. Le chemin session→game.command→buy_item prédit le refus de définition 3116 absente après les gardes; le commit de séquence de session précède le résultat gameplay. Côté UI, l’admission absente empêche la production de Buy; send_action ne prouve pas l’acceptation serveur. Undo est désactivé et sans action; le HUD a un manifeste et des contrôles distincts. Le critère inscrit de ITEM-3116-SHOP ne décrit pas explicitement ses transactions : critères proposés dans le rapport, sans modifier le registre. Aucun runtime; SERVER et SHOP restent a_implementer_ou_integrer, scope et acceptation ouverts.

## V1091 — champ probable du mode dans la synchronisation

La structure communautaire SynchVersionResponse (commit épinglé) concorde avec les offsets natifs +5, +6, +0xA, 12 joueurs de pas 0xB5 et +0x986. Identification fortement corroborée du champ mode, non preuve de la valeur Riot Map10; CLASSIC provient d'un émulateur. Texte non ASCII et absence de capture limitent la conclusion. Reprise et sources : rapport ITEM-3116, addendum V1091; scope toujours a_qualifier.

## V1092 — Heal : sélection de cible et niveau

Audit statique borné : le code choisit automatiquement l'allié blessé au ratio PV/max le plus bas (ID en départage), refuse plusieurs cibles explicites invalides et calcule le soin selon le niveau de chaque bénéficiaire. Le catalogue 4.20.1 distingue une cible alliée et le repli sur le plus blessé, avec @player.level, mais ne prouve pas les détails du serveur 4.20. Un test existant du lanceur niveau 18/allié niveau 1 a été lu, non exécuté. Règle historique, scope, runtime et acceptation restent ouverts; détails et reprise : docs/AUDIT_SYS01202_SUMMONER_HEAL_TARGET_LEVEL_2026-11-03.md.

## V1093 — Flash : commande et destination

Audit statique borné : Flash est absent des cinq variantes de sort d'invocateur et le chemin D/F actuel ne transporte qu'un slot ou un ID de cible, sans point au sol. CastAt et le déplacement instantané d'Ezreal E existent pour les compétences de champion; ils ne démontrent pas la règle de Flash. Le catalogue comparatif 4.20.1 indique portée 425 et recharge 300, sans qualifier le serveur Riot exact. Source et tests lus, aucun jeu ni test Rust exécuté. SCOPE/SERVER/NET, règles historiques, runtime et acceptation restent ouverts; rapport docs/AUDIT_SYS01202_SUMMONER_FLASH_COMMAND_2026-11-03.md.

## V1094 — Ignite : mécanique et configuration

Audit statique borné : le code applique cinq ticks dont le premier immédiatement et remplace l'effet existant; cadence et remplacement sont des choix communautaires non qualifiés comme serveur Riot. Le JSON expose first_tick_immediate, absent de Rules : l'appel du premier tick est inconditionnel. La vision inspectée ne démontre pas la non-révélation du camouflage. Le test nommé pour la déconnexion ne vérifie pas la vision. Contrôle texte/données passé; aucun test Rust ou jeu exécuté. SCOPE/SERVER/NET et acceptation restent ouverts; rapport docs/AUDIT_SYS01202_SUMMONER_IGNITE_SERVER_2026-11-03.md.

## V1095 — Smite : récompenses et variantes

Audit statique borné : les dégâts partagés peuvent attribuer l'or/XP ordinaires, distincts des bonus de camp propres à Châtiment que smite_rules.json indique manquants; 31 IDs jungle non pris en charge provoquent un refus. Le test de récompense existant n'assert aucun bonus spécifique, et son all d'aggro n'exige pas explicitement de second monstre vivant. Catalogue 4.20.1 général non suffisant pour décider des bonus Map10. Contrôle texte/données passé, aucun test Rust exécuté ici. SCOPE/SERVER/NET restent ouverts; rapport docs/AUDIT_SYS01202_SMITE_REWARDS_2026-11-03.md.

## V1096 — Exhaust : effets et formule d'attaque

Audit statique borné : défense -10, durée locale 2,5 s et facteur de dégâts sortants 0,6 pour physique/magique; dégâts bruts préservés par la politique courante. Le facteur de vitesse soustrait 0,3 aux bonus : avec +100 %, 2,0 devient 1,7; multiplier la vitesse totale par 0,7 donnerait 1,4. La règle historique reste à qualifier. Reçus réseau et témoin V645 anciens réutilisés avec limites; aucun test Rust ou partie exécuté ici. SCOPE/SERVER/NET restent ouverts; rapport docs/AUDIT_SYS01202_EXHAUST_EFFECTS_2026-11-03.md.

## V1097 — vagues : plafond partagé et création

Complément statique à V88/V470 : le seuil local 180 compte les sbires vivants de chaque équipe sur les deux voies. Si une voie atteint ce seuil avant l'autre, la seconde tentative est sautée; si spawn_unit retourne une erreur, ce chemin ignore le résultat puis avance le créneau. Cas conditionnels non exécutés; compteur et gestion historiques restent inconnus. Le test d'inhibiteur existant ne vérifie pas explicitement voie et vague suivante. Détails et critères : docs/FIDELITY_WAVES_LINKS_4_20.md, complément V1097; tâches et acceptation ouvertes.

## V1098 — relique : cadence et second ramassage

Complément à V87 : le script communautaire contrôle les candidats après au moins 250 ms cumulées (premier contrôle possible dès son premier update); le code local examine chaque tick disponible et départage les égalités par ID. Ni l'un ni l'autre ne prouve la politique Riot. Le reçu réseau ancien revendique un second ramassage couvert par les tests du cœur, mais les tests ciblés actuels lus vérifient seulement la nouvelle disponibilité. Aucun test/serveur exécuté ici; détails dans FIDELITY_OBJECTIVES_LINKS_4_20.md, complément V1098; SYS-10.4-09 reste a_faire.

## V1099 — autels : propagation du bonus AD vers Ezreal R

Complément à V87 : le R local utilise le bonus AD calculé après multiplication de l'AD total par les deux autels et fige le brut au cast. Exemple conditionnel base 100 sans objet : bonus 0 puis 10 avec deux autels, soit +10 au brut au coefficient local 1. Le texte historique et l'ordre serveur restent à qualifier; tests de décomposition et R lus séparément, sans cast avec autels exécuté ici. Détails : FIDELITY_OBJECTIVES_LINKS_4_20.md, complément V1099; tâches et acceptation ouvertes.

## V1100 — autels : projection de capture par équipe

Complément statique à V87 : snapshot_for filtre les joueurs hors vision mais ne modifie pas map.altars; les deux routes serveur consomment cette projection, et le panneau de diagnostic F3 lit la progression. Une capture neutre hors vision peut donc rester décrite si l'envoi réussit; aucun paquet ni rendu exécuté et la publicité historique des champs reste inconnue. Le reçu réseau antérieur signale un brouillard incomplet. Détails et cas à qualifier : FIDELITY_OBJECTIVES_LINKS_4_20.md, complément V1100; tâches ouvertes.

## V1101 — autel hors vision : contrôle API exécuté

Programme externe compilé hors ligne sur E: contre le cœur courant : deux équipes, autel neutre et autres unités retirées. Au tick 5401, captureur invisible et absent du snapshot adverse, mais capturing=1/progress=1 restent dans les deux projections et l'atomique observateur. Code 0, binaire/source/lock/résultat identifiés; serde_json du lock isolé diffère du lock projet. Aucune transmission, partie réelle ou règle Riot démontrée. Piste communautaire de diffusion retrouvée seulement sur Map8, sans preuve Map10. Détails : FIDELITY_OBJECTIVES_LINKS_4_20.md, V1101.

## V1102 — autels : codecs locaux contrôlés

Fixture à deux équipes compilée hors ligne en dehors du dépôt : les champs d'autel et le filtrage du champion survivent à l'encodage/réassemblage OLST et OLSR, trois fragments par audience, avec refus ciblés de contexte, fragment manquant et rejeu OLSR. Aucun Host, UDP, authentification, rendu ou serveur Riot exécuté. Lockfile isolé différent sur quatre paquets, preuves identifiées et conservées; voir FIDELITY_OBJECTIVES_LINKS_4_20.md, V1102. Règle historique et tâches restent ouvertes.

## V1103 — plafond de vagues : contrôle local exécuté

Fixture Rust externe : à 178 sbires vivants les deux voies équipe 0 apparaissent; à 179 seule voie 0; à 180 aucune. Avec 180 copies dont une morte, le résultat correspond à 179 vivantes. Les deux voies équipe 1 apparaissent dans chaque cas. Code 0, clones synthétiques et saut au premier créneau; ni scheduler Riot ni partie réelle testés. Preuves et lock isolé : FIDELITY_WAVES_LINKS_4_20.md, complément V1103; SYS-10.5-02 reste ouvert.

## V1104 — vagues : place libérée après saturation

Fixture Rust externe exécutée : après un créneau sauté au plafond, deux places libérées permettent la création des deux unités du créneau suivant au tick 2274, sans recréer l'unité sautée au créneau précédent; cas 179, cas 180 et témoin sans plafond passés. Aucun échec de création ni partie normale testés. Le rattrapage Riot reste inconnu; preuves et lock isolé : FIDELITY_WAVES_LINKS_4_20.md, complément V1104; SYS-10.5-02 reste ouvert.

## V1105 — relique : deux ramassages exécutés en fixture

Programme Rust externe hors ligne : premier ramassage tick 5400, refus à 8099, second joueur au tick 8100, prochaine échéance 10800; PV/mana locaux et vitesse appliqués une fois, régénération séparée. Sauts de temps et unités retirées : pas une partie continue ni une preuve du serveur Riot. Le reçu ancien V1098 reste inchangé. Preuves : FIDELITY_OBJECTIVES_LINKS_4_20.md, complément V1105; SYS-10.4-09 reste ouvert.

## V1106 — interaction locale des autels et du R d'Ezreal

Fixture Rust externe hors ligne : deux autels capturés augmentent localement l'attaque de 62,09 à 68,299 et le R corrigé de 350,00043 à 356,2094; la perte d'un autel après lancement ramène l'attaque à 62,09 mais laisse le R à 356,2094. Horloge avancée par sauts, unités retirées et résistance fixée à zéro. Ce contrôle local ne prouve pas la formule Riot; source serveur ou capture historique mesurée nécessaire. Preuves, dépendances et limites : FIDELITY_OBJECTIVES_LINKS_4_20.md, V1106; tâches concernées ouvertes.

## V1107 — identité des outils externes de SYS-01.2-02

Les 14 entrées externes de V825/V826 correspondent à huit fichiers : chemins source/consumer, tailles, SHA-256 et ancres sont conformes dans le snapshot contrôlé. Deux refus synthétiques en mémoire contrôlent le comparateur uniquement. Identité et ancrage clos pour ce périmètre; outils non exécutés, sémantique, corpus natif et goal restent ouverts. Preuve détaillée : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V1107 ; résultat E:/mapslol3v3/trace_external_identity_audit/resultats.json.

## V1108 — Ahri Q : source et refus de simulation

Le fichier natif Q identifié a été rehaché et 19 champs ciblés concordent numériquement avec l'export local. Dans une fixture Rust hors ligne, apprentissage et deux formes de lancement d'Ahri Q sont refusés; le snapshot reste identique, tandis que le témoin Garen apprend et lance Q. Le HUD lit génériquement le coût, sans preuve de rendu. Audit ciblé clos, capacité non implémentée sur ces chemins et règles serveur historiques ouvertes : docs/AUDIT_SYS01202_AHRI_Q_SOURCE_DISPATCH_2026-11-03.md.

## V1109 — identité des consumers hors fiche et doublons de liens

Sur 4 441 consumers hors de la fiche parent, 4 402 chemins relatifs correspondent aux tailles/SHA enregistrés sur 271 fichiers F:; 39 chemins absolus restent exclus. Le parent compte 1 319 liens mais 1 318 ID distincts, et SYS-02.5-04 230 liens mais 229 ID : le même ID est doublé dans les deux. Le résolveur lu et exécuté conserve ces répétitions. Aucun registre modifié; correction proposée distinctement. Détails et preuves : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V1109.

## V1110 — matrice de refus des capacités

Fixture Rust externe : 118 des 122 IDs du catalogue local refusent Learn, Cast et CastAt sur Q/W/E/R, soit 1 416 refus observés avec snapshot inchangé; Garen, Annie, Trundle et Ezreal apprennent Q dans les témoins. Les 472 tâches de simulation correspondantes référencent déjà le refus générique et restent à implémenter. Ce contrôle ne valide ni les quatre témoins complets ni les sources/règles historiques. Détails : AUDIT_SYS01202_CHAMPION_SPELL_REFUSAL_MATRIX_2026-11-03.md.

## V1111 — 39 chemins absolus du registre

Les 39 consumers absolus exclus de V1109 correspondent à leurs tailles, hashes et ancres : 18 fichiers dont 17 sources Cargo. Ces 17 fichiers correspondent à six archives .crate locales dont le checksum concorde avec Cargo.lock. Pas de build ni preuve d'utilisation par un binaire. Avec les lots V825/V1107/V1109 antérieurs, les 5 759 IDs ont une preuve d'identité par partitions à des dates distinctes, sans qualification sémantique globale. Détails : AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md, V1111.

## V1112 — liens des ressources de sorts de champions

Les 7 082 fiches CH-…-Q/W/E/R sélectionnées (parents et sous-tâches confondus) pointent chacune vers le chemin native_spell_data indiqué par l'export pour leur couple; les 488 fichiers natifs distincts ont été relus et correspondent aux tailles/SHA du registre. Les comparaisons de chemin et d'octets ne qualifient ni la sémantique historique ni la mécanique jouable. Détails et reçu : AUDIT_SYS01202_CHAMPION_SPELL_SOURCE_LINKS_2026-11-03.md.

## V1113 — 26 champs numériques de 488 sorts

Comparaison native/export : 11 776 valeurs numériques concordantes, 910 absentes des deux côtés et deux textes Karma Q identiques mais non numériques en parseur strict. Le convertisseur historique isolé avait déjà été qualifié à 6,5 et 5,5 sous ses limites; aucune conversion produit ajoutée. Yasuo W sans ManaCost était déjà signalé, HUD non exécuté ici. Audit borné des champs : AUDIT_SYS01202_CHAMPION_SPELL_NUMERIC_FIELDS_2026-11-03.md.

## V1114 — liaisons des définitions d'objets

2 779 fiches ITEM (parents et enfants) sont reliées à 280 fichiers natifs portant les bons IDs; 280 tailles/SHA concordent. Le catalogue source actuel contient 33 de ces IDs; les 247 autres ne sont pas dans ce catalogue, sans que leur disponibilité historique Map10 soit établie. Aucun achat exécuté. Détails : AUDIT_SYS01202_ITEM_NATIVE_SOURCE_LINKS_2026-11-03.md.

## V1115 — statistiques des objets du catalogue

Sur 33 objets, 334 champs natifs sélectionnés correspondent au catalogue; 29 champs vol de vie absents sont à zéro localement, sans défaut historique établi. Fixture hors ligne : 1036 dégâts +10, 1029 armure +15, 1052 puissance +20, 1001 vitesse +25 après injection en inventaire. Pas d'achat ni partie. Rapport : AUDIT_SYS01202_ITEM_CATALOG_STATS_2026-11-03.md.

## V1116 — priorisation des objets absents du catalogue

Sur les 247 IDs absents du catalogue courant, Data Dragon 4.20.1 indique explicitement maps[10]=false pour 83; 164 n'ont pas de valeur 10 explicite. Parmi ceux-ci, 150 sont purchasable en 4.20.1 et ont InStore=1 dans les sources natives relues : candidats à qualifier, pas objets 3v3 confirmés. Les clés UnpurchasableItemList ont été identifiées en V1075; l'inclusion est distincte et ses flags effectifs restent inconnus. Rapport : AUDIT_SYS01202_ITEM_MAP10_PRIORITY_2026-11-03.md.


## V1117 — rectification des listes Map10

V1116 sous-décrivait les preuves : V1075 identifie les 98 clés UnpurchasableItemList et distingue la liste d'inclusion; V1078/V1080 documentent les flags d'inclusion, mais pas leur valeur effective en partie. Les deux listes peuvent coexister. Le paragraphe V1116 a été corrigé; la conclusion sur les 150 candidats reste inchangée.

## V1118 — dépendances des 150 candidats

Recettes natives et catalogue 4.20.1 concordent pour 150 candidats, ordre et prix récursifs compris. Un graphe hypothétique basé sur les 31 IDs admis localement donne 60, 68 puis 19 candidats; 3196/3197/3198 dépendent de 3200 propre à Viktor, dont le mode d'attribution reste à qualifier. Aucun achat ni admission historique prouvés. Rapport : AUDIT_SYS01202_ITEM_CANDIDATE_RECIPE_GRAPH_2026-11-03.md.

## V1119 — consommateur natif de la liste Map10

Analyse statique du PE 4.20 et du fichier Map10 : UnpurchasableItemList alimente une structure consultée lors de la construction d'un objet; une garde de boutique cliente teste ensuite l'octet lié et peut suivre le chemin « not marked as Purchasable ». Les 150 candidats V1116 sont absents de la liste relue; cela ne prouve pas leur admission finale. Aucun client ni serveur exécuté; provider, flags, cache et politique serveur restent ouverts. Détails : AUDIT_SYS01202_MAP10_NATIVE_SHOP_GUARD_2026-11-03.md.

## V1120 — matrice d'achat locale Map10

Fixture Rust hors ligne : 247 IDs absents refusés, 1038/1058 refusés par la garde Map10, 31 IDs admis achetés dans des simulations isolées, avec or et emplacement injectés. Refus hors boutique également vérifié. V650 documente déjà les essais antérieurs de Viktor et le texte natif sur son prototype. Pas une preuve de règles Riot ni de partie UI/réseau. Rapport : AUDIT_SYS01202_MAP10_SHOP_PURCHASE_MATRIX_2026-11-03.md.

## V1121 — lecture native isolée de la liste Map10

Wrapper/cache/parseur originaux exercés dans Unicorn avec racine deploy et locale en_GB fournies : fichier Items.inibin ouvert en rb, 657 octets consommés, 98 valeurs retrouvées, défaut contrôlé sur Item98. Item20 est stocké en texte mais le getter original le convertit en 3180. Les 150 candidats restent absents de cette liste dans la fixture; provider et décision serveur historiques demeurent inconnus. Rapport : AUDIT_SYS01202_MAP10_ORIGINAL_CACHE_ITEMS_2026-11-03.md.

## V1122 — boucle native de liste et garde cliente isolées

Dans Unicorn avec racine/locale/chemin et sentinelle fournis, la boucle native lit 98 valeurs, s'arrête à Item98 et construit un arbre valide de 95 IDs. La recherche native met l'octet à 0 pour ces 95 IDs et le laisse à 1 pour les 150 candidats; la garde est exercée séparément sur deux états synthétiques. Pas de provider historique, achat ou serveur exécuté. Rapport : AUDIT_SYS01202_MAP10_ORIGINAL_LIST_LOOP_2026-11-03.md.

## V1123 — vente locale des objets du catalogue

Fixture Rust : les 31 IDs admis localement s'achètent puis se vendent, remboursement local et retrait vérifiés; seconde vente refusée. Les piles 2003/2004 se vendent à l'unité; 1038/1058 injectés se vendent malgré l'interdiction d'achat locale. Reçu natif antérieur CanBeSold=1 et prix 4.20.1 rapprochés pour les 31. Pas de partie, réseau ou règle serveur historique validés. Rapport : AUDIT_SYS01202_MAP10_SHOP_SALE_MATRIX_2026-11-03.md.

## V1124 — lecteur natif isolé de Constants.var Map10

Le lecteur/lookup/setter originaux, exercés dans Unicorn sur le fichier réel et un registre de deux objets fourni, consomment 19 433 octets et fixent les deux flags d'inclusion à 0. Variantes en mémoire : valeur 1 appliquée; valeur BAD conserve la sentinelle malgré retour global positif. Provider, registre complet, choix effectif et serveur restent inconnus. Rapport : AUDIT_SYS01202_MAP10_ORIGINAL_CONSTANTS_READER_2026-11-03.md.

## V1125 — recettes locales à composants identiques

Pour 3114, 3101 et 3134, neuf devis/achats avec 0, 1 ou 2 composants ont réussi avec coûts et emplacements distincts attendus. Trois refus d'or, trois refus d'inventaire plein et trois achats avec place libérée ont été vérifiés en fixture. Pas de validation Riot, UI ou réseau. Rapport : AUDIT_SYS01202_MAP10_DUPLICATE_RECIPES_2026-11-03.md.

## V1126 — paramètres et listes natives composés

Dans une même fixture Unicorn par cas, Constants.var réel fixe les deux flags à 0 et la boucle d'inclusion est sautée; la liste d'exclusion produit 95 IDs. Avec premier flag modifié à 1 en mémoire, l'inclusion est atteinte et renvoie 0 au premier élément, puis l'exclusion produit les mêmes 95 IDs. Racine/locale/mode et registre fournis : pas une preuve de contexte historique ou d'achat serveur. Rapport : AUDIT_SYS01202_MAP10_NATIVE_COMPOSED_LISTS_2026-11-03.md.

## V1127 — mode et objet natifs Map10, exécution isolée

Vingt combinaisons de modes et flags ont confirmé la branche native d'inclusion ; un constructeur natif partiel et la recherche sur l'arbre donnent les états attendus pour 1062 présent et 1039 absent. Données de contexte injectées : le mode historique, le provider, la construction complète et l'autorité serveur restent inconnus. Rapport : AUDIT_SYS01202_MAP10_NATIVE_MODE_OBJECT_2026-11-03.md.

## V1128 — contrôle client et refus moteur pour les bottes

Avec 3020 possédé, le selected_action client extrait propose 1001 pour 325 ; le core réel refuse le groupe et conserve or, inventaire et comptes. Un achat nominal et six refus du contrôle client sont confirmés en fixture. Clic, réseau, affichage du refus et règle historique restent ouverts. Correction existante : HUD-SHOP-BUY-FEEDBACK-01. Rapport : AUDIT_SYS01202_SHOP_CLIENT_GROUP_2026-11-03.md.

## V1129 — inventaire dans le snapshot après reconnexion locale

Une fixture utilisant les modules serveur et le core réels a acheté 1001 et deux 2003, détaché puis repris le même joueur : les tableaux IDs et quantités du snapshot réassemblé sont identiques avant/après ; les fragments testés de l'autre époque sont refusés. Temps, entropie et messages fournis ; réseau, commit et rendu clients non exécutés. Rapport : AUDIT_SYS01202_RECONNECT_INVENTORY_SNAPSHOT_2026-11-03.md.

## V1130 — calcul HUD Yasuo W sous rang injecté

Le moteur refuse actuellement Learn pour Yasuo. En injectant chacun des rangs W 1–5, la fonction HUD extraite renvoie `native spell cost unknown` ; rang nul, récupération, mort et Annie E fournissent des témoins cohérents. Propagation jusqu'au nettoyage du module relevée statiquement, sans Bevy ni rendu. Aucun coût historique déduit ; CH-Yasuo-W-PRESENTATION-HUD reste ouverte. Rapport : AUDIT_SYS01202_YASUO_W_HUD_COST_2026-11-03.md.

## V1131 — vision Ignite après retrait du lanceur

Simulation locale Map10 : après lancement puis remove_player, la cible hors vision ordinaire reste visible et présente au snapshot allié aux ticks 0 et 149 ; à expiration tick 150 elle ne l'est plus. L'ancienne mention de « déconnexion » V105 est précisée : aucun détachement réseau n'a été exécuté. Riot, furtivité et NET restent ouverts. Rapport : AUDIT_SYS01202_IGNITE_REMOVED_SOURCE_VISION_2026-11-03.md.

## V1132 — Veigar : modèle choisi et rig V527

Les SKL/SKN natifs et le GLB ont les mêmes SHA que V527 ; lecture du code : sans override Veigar, animation::request choisit champions/veigar.glb. Le skin 0 actuel comporte 49 joints et la branche toe droite n'y figure pas ; les 33 influences proviennent du reçu antérieur, non redécodées. Aucune exécution ou image ; correction et poses restent ouvertes. Rapport : AUDIT_SYS01202_VEIGAR_RIG_CONSUMER_2026-11-03.md.

## V1133 — points de compétence en session et reprise

Deux sessions locales en mémoire : un Learn accepté, rejeux et usurpations refusés, puis après attribution contrôlée de 300 XP un point non dépensé survit à la reprise et peut être dépensé. Les quatre fiches SYS-05.1-02 à 05 restent partielles et sans native_inputs direct ; règles Riot, vraie concurrence et réseau ouverts. Rapport : AUDIT_SYS01202_SKILL_SESSION_RESUME_2026-11-03.md.

## V1134 — UV de deux morceaux terrain Map10

Blender 4.5 en lecture seule : 78 boucles de deux morceaux Jungle1 rapprochées du GLB et du c233 simulé ; différences maximales UV enregistrées, cinq arêtes internes du second sans rupture à 1e-6. Limites : pas de coutures inter-objets ni rendu ou constat de corruption. SYS-02.4-03 reste ouverte. Rapport : AUDIT_SYS01202_MAP10_BLENDER_TERRAIN_UV_2026-11-03.md.

## V1135 — UV et frontières du terrain Jungle1

34 objets/1 728 boucles Blender et GLB appariés : tous diffèrent du calcul c233 CPU de plus de 1e-6 sur au moins un axe. Les 99 bords exactement coïncidents entre objets concordent en UV ; autres matériaux, rapprochement approché et rendu restent ouverts. Liens réels aux textures de hauteur/couleur confirmés. Rapport : AUDIT_SYS01202_MAP10_JUNGLE1_UV_BATCH_2026-11-03.md.

## V1136 — UV Lanes1 et frontières terrain inter-matériaux

48 objets Lanes1/1 761 boucles comparés au c233 CPU ; 25 bords exactement coïncidents avec Jungle1 concordent en UV. Les images packées Blender sont identiques aux PNG clients et les paramètres d'échantillonnage sont déclarativement voisins ; orientation et pixels restent non qualifiés. SYS-02.4-03/04 ouvertes. Rapport : AUDIT_SYS01202_MAP10_CROSS_MATERIAL_UV_2026-11-03.md.

## V1137 — échantillons CPU de deux textures terrain

Modèle bilinéaire clamp LOD0 explicite sur 78 paires V1134 : écart >1e-6 pour 44 paires de hauteur et 78 de couleur. Huit témoins Blender/Pillow soutiennent une inversion verticale du tampon lu. Orientation de rendu, mipmaps, shaders et pixels restent non qualifiés ; pas de conclusion visuelle. Rapport : AUDIT_SYS01202_MAP10_TERRAIN_UV_SAMPLING_2026-11-03.md.

## V1138 — orientation du sampler Blender terrain Map10

Lot AUD-SYS-01.2-02-MAP10-TERRAIN-BLENDER-SAMPLING-01 termine pour son perimetre : 78 boucles V1134 rendues avec le vrai graphe UVMap.001 -> Image Texture -> Emission dans une scene Blender temporaire, sur les deux PNG natifs. A 8 et 16 pixels par cellule, V inverse est la meilleure correspondance : hauteur max/moyenne 0.009732/0.001249 puis 0.009906/0.001282 ; couleur 0.004479/0.001199 puis 0.004399/0.001119 ; 78/78 cellules a moins de 0.01. V direct reste a 0.107--0.114 de moyenne. Aucun asset, shader, registre, goal, application ou base modifie. Rapport : docs/AUDIT_SYS01202_MAP10_BLENDER_TEXTURE_SAMPLING_2026-11-03.md ; preuves isolees E:/mapslol3v3/audit_map10_blender_sampling_20261103. LOD exact, rendu Bevy/GPU, melange des couches et carte complete restent ouverts.
## V1139 — consommateur terrain Bevy et sampler actuel

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-CONSUMER-01` terminé pour son seul périmètre d'audit. Le code de production configure les deux PNG non tuilés, non-sRGB, ClampToEdge et Linear min/mag ; les defaults Bevy résolus statiquement donnent Nearest pour le mip et LOD 0–32, mais l'image décodée ne contient qu'un mip. Les UV de hauteur/couleur viennent de la position monde et de c233, pas de `UVMap.001` : la preuve Blender V1138 ne qualifie donc pas le rendu Bevy. Quatre tests CPU ciblés réussissent ; aucun sampler runtime, aucune lecture de pixels GPU ni preuve des états D3D terrain historiques. Aucun source, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_BEVY_TERRAIN_CONSUMER_2026-11-03.md` ; preuves isolées : `E:/mapslol3v3/audit_map10_bevy_consumer_20261103`.

## V1140 — échantillonnage GPU Bevy des deux PNG terrain

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-BEVY-GPU-SAMPLING-01` terminé pour son périmètre d'audit isolé. Bevy 0.19 a décodé les deux PNG réels en Rgba8Unorm mono-mip ; wgpu 29/Vulkan sur RTX 3060 a uploadé puis échantillonné 87 coordonnées par texture, soit 174 échantillons et 696 canaux relus. L'orientation directe des lignes décodées concorde : erreur max/moyenne hauteur `0.0000643730/0.00000376883`, colormap `0.000282243/0.0000184233`, contre `0.989790/0.0937658` et `0.647179/0.0812332` pour V inversé. Aucun défaut produit n'en découle : Blender utilisait `UVMap.001`, Bevy c233. Raster complet, autres backends et D3D 4.20 restent ouverts. Aucun fichier OpenLeague de production, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_BEVY_GPU_TEXTURE_SAMPLING_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_bevy_gpu_sampling_20261103/resultats.json`.

## V1141 — textures et sampler natifs du terrain Map10

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-SAMPLER-01` terminé pour son périmètre d'audit, sans déclarer la fidélité historique complète. Les loaders originaux relient statiquement `terrainHeightScale.dds` à `context+0x24`, `compositeColorMap.dds` à `+0x28` et `fogLightingMap.dds` à `+0x2c`. Deux exécutions isolées du chemin type 3 ont soumis les handles distincts aux stages `0..3,4,8,9` via les wrappers originaux jusqu'aux frontières D3D ; `s8/s9` demandent U/V `CLAMP`. Le setter antérieur `0x95AD40` a été exécuté dans ses deux branches ; l'analyse exhaustive des 23 références au singleton `0x2D79048` qualifie son état code-owned à false, donc `s0..s3=WRAP` et `s4=CLAMP`. Les clés MAG/MIN/MIP/LODbias restent héritées ; le type 9 MAXMIPLEVEL n'est pas relié au terrain. Les vrais handles issus des DDS, un processus/draw D3D9 historique et les pixels restent ouverts. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_SAMPLER_2026-11-03.md` ; preuves : `E:/mapslol3v3/audit_map10_native_sampler_20261103`.

## V1142 — loaders natifs des trois DDS terrain Map10

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-LOADER-01` terminé pour sa chaîne déclarée jusqu'aux feuilles readonly. Les entrées originales `0x959B10/0x959BC0/0x959C80`, la factory `0x98A770`, le constructeur `0x989150`, l'initialiseur `0x989B10` et le split `0x8B5700` ont exécuté 860 adresses originales. Trois handles distincts sont publiés dans `+0x24/+0x28/+0x2c`; neuf lectures intégrales des vrais DDS vérifient tailles et SHA aux feuilles provider `+0x28/+0x1c` et à la frontière adaptée `0x98A030`. Noms, type 2, mip logique 1, couleur `FF000000`, refcount 1 et global colormap sont observés. Le provider RADS historique, le corps `0x98A030→0x98A460`, le backend `+0x60`, le décodage/upload et les pixels restent ouverts. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_LOADER_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_native_loader_20261103/native_terrain_loader_execution.json`.

## V1143 — I/O DDS et chaîne CPU native du terrain Map10

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-DDS-IO-01` terminé pour sa frontière d'audit. Pour les trois DDS Map10 exacts, les corps originaux `0x98A030→0x98A460` puis `0x989500→0x9BB3D0→0x9B65E0→0x9BB2D0→0x9BB220` ont été exécutés. Les flux readonly adaptés observent `open→size→seek→read→close`; tailles et SHA des octets invités concordent avec les fichiers physiques. Les requêtes atteignent `0x9BB247`, où le slot `+0x60` résout `0x9C2D40`, sans exécuter cet appel. Deux refus (nom hors périmètre et mode `wb`) passent. L'import D3DX Unicorn, les capacités, le provider RADS historique, le raccord renderer/backend, COM/GPU, upload et pixels restent ouverts : fonctionnalité non terminée. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_DDS_IO_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_native_dds_io_20261103/native_terrain_dds_io_execution.json` (SHA-256 `0a4dc5b7d80d9147264616dab5429eb3a95078f2c7635940d5219adb1a261b5d`).

## V1144 — publication statique du backend D3D9 terrain

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-PUBLICATION-01` terminé pour sa frontière statique. V714 est réutilisé sans replay : `0x9808F8` publie le provider D3D9 à vtable `0x10E2E2C` dans `renderer+0x10`. Le caller original `0x981102/0x981105/0x981108/0x981110/0x981119` charge ce provider, calcule et passe `&renderer+0x14` à son slot `+0x10`, qui résout `0x9C3E30`. V716 est réutilisé séparément : factory `0x9C3E30`, constructeur `0x9C1430`, store `0x9C40C8`, objet à vtable `0x10E2F30`. La chaîne statique est close, mais aucun run composé n'observe ce store dans le vrai champ ; le chemin nominal reste bloqué à la frontière pilote privée `0x48AC16`. COM/GPU, upload et rendu restent incomplets. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_PUBLICATION_2026-11-03.md` ; reçu statique : `E:/mapslol3v3/audit_map10_native_backend_publication_20261103/native_backend_publication_static.json` (SHA-256 `a3d9e5bf4049ee2fe855f6ec4d8d09b3ae4dea3832d3674aae9e0e30f4352c02`).

## V1145 — publication composée conditionnelle du backend D3D9

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-COMPOSED-01` terminé pour le profil conditionnel `escape_refusal`. Le caller original `0x981102..0x98111c` a appelé `provider+0x10→0x9C3E30`, exécuté le constructeur `0x9C1430`, puis `0x9C40C8` a écrit l'objet `0x40800010` à vtable `0x10E2F30` dans le vrai `renderer+0x14` (`0x40010014`). 3 341 adresses originales sont observées. La requête privée à `0x48AC16` a été interceptée avant transmission et remplacée par `0xC000000D`; `driver_private_escape_executed=false`. Nettoyage hôte/fenêtre réussi, mais teardown natif complet faux et 27 allocations d'arène restent recensées. Aucun DDS, upload, draw, `Present` ou pixel. Le chemin nominal/historique et la fonctionnalité restent incomplets. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_COMPOSED_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_native_backend_composed_20261103/native_backend_composed_execution.json` (SHA-256 `2f2f22d9cea29781165603ef9942447a857d9fcefc9feee9e53577607d0bb028`).

## V1146 — création conditionnelle des textures terrain

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-TEXTURE-CREATE-01` terminé jusqu'à la frontière pré-upload `0x9BB4EC`. Les trois requêtes Map10 ont exécuté `0x9C2D40→0x9C6070→IDirect3DDevice9::CreateTexture` : 2048²/1024², mip 1, usage 0, format 21, pool 1. Trois wrappers distincts à vtable `0x10E3270`, refcount 1, sont observés dans `request+0x38`; 4 412 adresses originales, zéro mémoire invalide. L'ABI démontre que `texture+0x90/+0x8c` ne sont écrits qu'après les branches d'upload : ils restent donc zéro et ouverts. Aucun `LockRect`, D3DX upload, draw ou `Present`; l'appel privé reste non transmis. Le refus largeur zéro (`0x8876086C`) est un contrôle COM actuel, pas Riot/2014. Aucun source produit, asset, registre, goal, Plan, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_BACKEND_TEXTURE_CREATE_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_native_backend_texture_create_20261103/native_backend_texture_create_execution.json` (SHA-256 `66f6b895d80afdf75b6b945600043fc61395cf8f4f452628edddf81fe32862cd`).

## V1147 — upload et publication des textures terrain

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-TEXTURE-UPLOAD-01` terminé jusqu'à la frontière post-publication `0x98962A`, sous le profil conditionnel `escape_refusal`. Les trois DDS Map10 utilisent le chemin original `LockRect→copie CPU→UnlockRect`, sans `D3DXLoadSurfaceFromMemory`. Trois payloads de 16 777 216 / 4 194 304 / 4 194 304 octets sont transférés vers les textures D3D9 actuelles ; trois readbacks ligne par ligne reproduisent exactement les SHA sources. Pour chaque wrapper, `0x9BB76B` publie `texture+0x90`, puis `0x989624` publie la même valeur dans `texture+0x8C`. Le reçu observe trois `CreateTexture`, six lock/unlock, 4 809 adresses originales, zéro mémoire invalide et nettoyage hôte complet. Aucun draw, `Present` ou pixel de frame ; appel privé pilote non transmis, runtime 2014, retour complet du loader, enregistrement post-publication et teardown natif toujours ouverts. Aucun source produit, asset, registre, goal, Plan, interface, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_NATIVE_TEXTURE_UPLOAD_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_native_texture_upload_20261103/native_texture_upload_execution.json` (SHA-256 `4ae5b0a5a2047c2278d6e1470cd6ec4282768aa5c4805053c9e593d66c119c3d`).

## V1148 — AddRef, enregistrement et retour du loader terrain

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-POST-PUBLICATION-RUNTIME-01` terminé pour le runtime borné conditionnel. Le constructeur original `0x9783D0` publie le gestionnaire ; le builder `0x978820` n'est pas remplacé. Pour chacun des trois DDS exacts, le wrapper suit `1→2` à `0x989630→0x9AB730`, puis `2→3` quand l'enregistrement conserve sa référence. L'arbre gagne une entrée, la collection contient le nœud, `owner+0x88` est affecté, la référence temporaire du nœud revient de 2 à 1 et `node+0x15=1`. Le loader atteint `0x989695` trois fois avec `AL=1` et `ret 0x0C`; les readbacks DDS restent exacts. Deux exécutions concordent, 5 934 adresses originales, zéro accès invalide et nettoyage current-host complet. `native_full_teardown=false`; aucun draw, `Present`, pixel de frame ou runtime 2014 n'est revendiqué. Aucun source produit, asset, registre, goal, Plan, interface, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_POST_PUBLICATION_RUNTIME_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_post_publication_20261103/post_publication_runtime_execution.json` (SHA-256 `a2fbd67a7b9d33ad0012e698dd4574b626d9f5991379a0ceae5a11f2cbefb6fe`).

## V1149 — owners DDS enregistrés vers texture/samplers D3D9

Lot `AUD-SYS-01.2-02-MAP10-REGISTERED-TEXTURE-CONSUMER-RUNTIME-01` terminé pour sa frontière composée conditionnelle. L'inspection PE et la validation distinguent l'owner réel du nœud d'enregistrement : `0x983CB0` consomme `owner+0x0C/+0x8C`, jamais `owner+0x88`; le wrapper `0x10E3270` restitue le proxy brut par son slot 3. Les trois owners exacts V1148 atteignent les stages qualifiés `s4/s8/s9` et les mêmes proxies atteignent trois `IDirect3DDevice9::SetTexture` current-host réussis. Le sous-chemin original `0x95A480` produit aussi quatre `SetSamplerState` U/V `CLAMP` réussis pour `s8/s9`. Deux exécutions concordent, 6 109 adresses originales, zéro accès invalide, aucun draw/`Present` et nettoyage hôte complet. Le caller terrain complet de `s4`, le runtime 2014, le teardown natif, les shaders, pixels et la fidélité visuelle restent ouverts. Aucun source produit, asset, registre, goal, Plan, interface, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_REGISTERED_TEXTURE_CONSUMER_RUNTIME_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_map10_registered_texture_consumer_20261103/registered_texture_consumer_runtime_execution.json` (SHA-256 `ce4bde2628c5385580f2812cb4182856bf4e581da1e758d3f9ef24e8fd547cf2`).

## V1150 — appelant terrain type 3 jusqu'à la frontière pré-draw

Lot `AUD-SYS-01.2-02-MAP10-TERRAIN-CALLER-TO-DRAW-BOUNDARY-01` terminé pour sa seule frontière conditionnelle. Un appel selector 0/type 3 non mis en cache exécute le chemin original `0x95AFC0 -> 0x95AD40 -> 0x95A730`, conserve les owners DDS exacts aux stages qualifiés `s4/s8/s9`, puis atteint l'instruction originale `0x95B112` avec la pile `[0,0,0,3,0,1]`. L'exécution s'arrête avant `backend+0x20 -> 0x9C2400` : aucun draw, HRESULT de draw, `Present` ou readback frame/backbuffer. Les stages `s0..s3` sont explicitement une fixture non historique et les constantes, déclaration, VB et IB sont des adaptateurs ABI, pas des ressources GPU 4.20 qualifiées. Deux refus de prévol owner-node/owner-wrapper, deux runs, les reçus natifs byte-identiques, les différences hôte classifiées et la confrontation indépendante 15/15 passent. Trois readbacks hérités vérifient uniquement le contenu des textures uploadées. Draw réel, ressources géométriques/shaders historiques, `Present`, pixels, runtime 2014 et teardown natif restent ouverts. Aucun source produit, asset, registre, goal, Plan, interface, application ou base modifié. Rapport : `docs/AUDIT_SYS01202_MAP10_CALLER_TO_DRAW_BOUNDARY_RUNTIME_2026-11-03.md` ; preuves : `E:/mapslol3v3/audit_map10_draw_boundary_runtime_20261103` et `E:/mapslol3v3/audit_map10_v1150_evidence_audit_20261103/REVIEW_V1150_ACCEPTANCE_CONFRONTATION_V2.md`.

## V1151 — identités géométrie/shaders et corroboration REA ciblée

Deux unités statiques ferment uniquement l'identité individuelle des ressources consommées autour de `0x95AFC0`. Pour la géométrie, selector 0 est produit par `0x9596D0` dans `context+0x04` avec stride 36 ; `0x957840/0x957940` chargent les 107 VB/IB exacts de `room.nvr` dans `table+0x28/+0x34`. Validation producteur 38/38, revue indépendante 21/21. La jonction d'un selector réellement produit avec sa paire VB/IB dans un même batch historique reste ouverte. Pour les shaders type 3, noms/descripteurs FOUR_BLEND, records, handles, paire et slots D3D9 sont reliés statiquement ; validation 16/16 et revue 15/15. V1150 avait demandé NO_EMISSIVE avec indices -1 : les handles nuls sont une inférence statique, pas un log COM direct, et aucun FOUR_BLEND historique n'y a été créé ou lié.

Une seule session persistante REA 6.4.0/Ghidra 12.1.4 a réutilisé le PE original SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Elle confirme sept fonctions, trois xrefs et seize instructions critiques, puis exporte dix preuves et un snapshot de sept entrées. Validation 34/34 et relecture PE/Capstone 11/11. Les trois erreurs globales Ghidra observées hors des corps ciblés ne renversent pas ce verdict ; le `ghidra.log` éphémère n'a toutefois pas été archivé. Aucune compilation/publication/liaison shader historique, aucun draw, `Present`, pixel ou intégration Rust n'est qualifié. Aucun logiciel installé, produit, registre, Goal, Plan, UI ou base modifié. Rapports : `docs/AUDIT_SYS01202_MAP10_GEOMETRY_IDENTITY_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_SHADER_IDENTITY_STATIC_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_RESOURCE_IDENTITY_REA_2026-11-03.md` et `docs/REVIEW_SYS01202_MAP10_RESOURCE_IDENTITY_REA_2026-11-03.md` ; preuves : `E:/mapslol3v3/audit_map10_v1151_*` et `E:/mapslol3v3/audit_map10_rea_resource_identity_20261103`.

## V1152 — continuité géométrique réelle et préflight shader borné

La jonction géométrique précédemment ouverte est fermée pour un cas source-backed précis, pas pour des objets GPU historiques : le mesh `room.nvr` 1093 utilise material/VB/IB index 1, selector 2, stride 44, start vertex 213, trois sommets et les indices `[213,214,215]`. Les descripteurs exacts et les payloads complets VB1/IB1 alimentent trois factories d'enregistrement explicitement non historiques ; les mêmes wrappers atteignent les binds du chemin original `0x95AFC0 -> 0x95AD40 -> 0x95A730`. Arrêt à `0x95B112` avec arguments internes `[0,0,213,3,252,1]`, avant `backend+0x20`. Selector 0/stride 36 est refusé en préflight pour ce VB, sans attribuer ce refus à Riot. Deux runs concordent ; validation 11/11, 21/21 par run, relecture indépendante 26/26 puis 8/8 et 6 602 entrées natives sans divergence. Aucun draw, `Present`, frame ou pixel.

La publication FOUR_BLEND n'a pas été tentée. Le préflight confirme les deux sources, neuf fichiers avec inclusions, macros, D3DX, slots D3D9 et device current-host, mais refuse l'entrée dans `0x98D960/0x98C070` tant que cinq contrats manquent : VFS/streams/includes, bridge D3DX buffers/CTAB, création `Create*Shader`, pools allocate/free et nettoyage composé. Validation 14/14 et relecture corrigée 23/23. La preuve device est correctement identifiée comme V1145, ensuite héritée par V1150 : 40 nettoyages hôte à zéro et fenêtre détruite, mais `native_full_teardown=false` et 27 allocations invitées restent. Zéro producteur, objet, bind, draw, `Present` ou readback créé dans ce préflight.

La méthode de la recherche utilisateur est appliquée : preuves V1150/V1151 et snapshot REA réutilisés, deux décisions bornées, aucune réimportation générale, aucune installation d'apitrace/RenderDoc/Tree-sitter/nextest/sccache. Aucun code produit, asset, registre protégé, Goal, Plan, UI ou base modifié. Rapports : `docs/AUDIT_SYS01202_MAP10_GEOMETRY_CONTINUITY_2026-11-03.md`, `docs/REVIEW_SYS01202_MAP10_GEOMETRY_CONTINUITY_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_SHADER_PUBLICATION_PREFLIGHT_2026-11-03.md` et `docs/REVIEW_SYS01202_MAP10_SHADER_PUBLICATION_PREFLIGHT_2026-11-03.md` ; preuves : `E:/mapslol3v3/audit_map10_v1152_geometry_*` et `E:/mapslol3v3/audit_map10_v1152_shader_*`.


## V1153 — géométrie D3D9 current-host et provider VFS shader borné

Deux unités indépendantes de SYS-01.2-02 sont closes uniquement pour leurs frontières déclarées. La géométrie Map10 crée sur la RTX 3060 actuelle une déclaration de sommets, VB1 et IB1 réels (`HRESULT 0`), transfère et relit intégralement les payloads NVR exacts, puis exécute les binds par les fonctions 4.20 `0x9C2BB0`, `0x9C2C40` et `0x9C2B50`. L'arrêt reste strict à `0x95B112`, avant `backend+0x20` : aucun draw, `Present` ou pixel de frame. La revue indépendante passe 53/53, avec 13 444 comparaisons d'octets natifs au PE sans divergence. Les objets sont ceux du runtime D3D9 actuel, pas ceux de 2014, et les factories historiques ne sont pas exécutées. Rapports : `AUDIT_SYS01202_MAP10_GEOMETRY_CURRENT_HOST_D3D9_2026-11-03.md` et `REVIEW_SYS01202_MAP10_GEOMETRY_CURRENT_HOST_D3D9_2026-11-03.md`.

Le provider VFS/streams/includes ferme un seul blocker du préflight shader pour un adapter lecture seule limité aux neuf chemins et SHA épinglés. Deux sources principales et sept includes sont délivrés byte-identiques ; les séquences de stream, les buffers NUL-terminés, les refus et l'ownership sont contrôlés. Après la revue v1, le cleanup récursif a été rendu exception-safe : le cycle synthétique `A→B→A` est refusé par `include_cycle` avec deux streams fermés, deux buffers libérés et zéro objet vivant. Les deux runs v2 sont postérieurs à la correction, le validateur passe 41/41 et la seconde revue ne conserve aucun écart. Ce résultat n'est pas le VFS Riot historique ; aucun producteur, D3DX, device shader, pool, bind, draw, `Present` ou readback n'est exécuté. Rapports : `AUDIT_SYS01202_MAP10_SHADER_VFS_HARNESS_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_VFS_HARNESS_2026-11-03.md`.

Quatre blockers shader restent ouverts : bridge D3DX buffers/constant table, création device des vertex/pixel shaders, pools collision-free et cleanup possédé. Le draw, la fidélité visuelle, l'intégration Rust, Map10 et le jeu restent incomplets. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié par ces deux lots.


## V1154 — quatre contrats shader current-host fermés séparément

Quatre blockers restants du préflight V1152 sont désormais fermés pour leurs adapters/harnesses bornés, avec revues indépendantes, sans entrer dans les producteurs `0x98D960/0x98C070` et sans bind ni rendu.

- Bridge D3DX : ABI x86 originale et adaptation x64, macros, code, diagnostics et CTAB exercés par le vrai `D3DXCompileShader` current-host sur deux fixtures sans include. Deux runs 21/21, validation 38/38, revue avec troisième compilation 45/45. Les sources FOUR_BLEND complètes ne sont pas compilées dans ce lot. Rapports : `AUDIT_SYS01202_MAP10_SHADER_D3DX_BRIDGE_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_D3DX_BRIDGE_2026-11-03.md`.
- Bridge device : vrais `IDirect3DVertexShader9` et `IDirect3DPixelShader9` créés sur la RTX 3060 depuis des CSO fxc synthétiques, objets distincts, `AddRef 2→Release 1→0`, device et D3D9 libérés à zéro. Validation 45/45, revue avec troisième probe 55/55. Ce ne sont ni les shaders Riot ni le runtime 2014. Rapports : `AUDIT_SYS01202_MAP10_SHADER_DEVICE_BRIDGE_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_DEVICE_BRIDGE_2026-11-03.md`.
- Pools : les primitives originales `0x8E28C0/0x8E2980` saturent séparément deux managers exact-layout synthétiques à 4 096 indices uniques, renvoient la sentinelle `0x1000`, réutilisent les slots sans collision et finissent avec ownership/bitmaps à zéro. Validation 46/46, revue 34/34. Aucun état vivant Riot 2014 n'est observé. Rapports : `AUDIT_SYS01202_MAP10_SHADER_POOL_ADAPTER_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_POOL_ADAPTER_2026-11-03.md`.
- Cleanup possédé : les chemins originaux VS/PS `0x9AED50/0x9AEDC0→0x9BED40→0x8E2980` libèrent proxies CTAB/shader, wrapper, record/refcount et les trois niveaux bitmap sur des records/managers synthétiques. Validation non mutante 56/56, revue 23/23 et 576 instructions comparées au PE sans divergence. Rapports : `AUDIT_SYS01202_MAP10_SHADER_OWNED_CLEANUP_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_OWNED_CLEANUP_2026-11-03.md`.

Avec le provider VFS V1153, les cinq contrats du préflight sont clos séparément pour leurs harnesses, pas encore comme chaîne composée. La prochaine frontière est l'intégration source/includes→prétraitement puis le cycle D3DX→device→pool→cleanup avec rollback atomique. Les producteurs originaux, la publication FOUR_BLEND, la paire, le bind, le draw, `Present`, les pixels, l'intégration Rust et la fidélité visuelle restent ouverts. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1155 — composition prétraitement FOUR_BLEND et lifecycle shader

Deux compositions préalables aux producteurs originaux sont closes dans leurs limites déclarées.

La première exécute le helper historique `0x9AE410..0x9AE57F` sur les deux sources FOUR_BLEND et les sept includes exacts du corpus neuf-SHA. Le vertex buffer expansé fait 11 390 octets et le pixel buffer 25 052 octets ; chacun concorde byte-à-byte avec un modèle indépendant, sans token `#include`. D3DX current-host compile ensuite avec `pInclude=NULL`, les trois macros du profil et les 23 macros natives : bytecode et CTAB sont produits puis libérés à zéro. Deux runs passent 16/16, validation non mutante 54/54 et revue indépendante 24/24 avec troisième run conforme. Le helper d'expansion est original ; provider, garde de cycle et D3DX restent des adapters/current-host, pas le VFS/runtime Riot 2014. Rapports : `AUDIT_SYS01202_MAP10_SHADER_PREPROCESS_INTEGRATION_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_PREPROCESS_INTEGRATION_2026-11-03.md`.

La seconde compose sur fixtures synthétiques V1154 le cycle D3DX réel→allocateur original→`Create*Shader` actuel→record exact-layout→cleanup original VS/PS. Les succès et rollbacks compilation, device et saturation finissent sans proxy, shader, bitmap ou record vivant ; device/D3D9 retournent à zéro et la fenêtre est détruite. La composition a corrigé une incompatibilité de harness : seul le bit feuille porte l'ownership du slot, les niveaux supérieurs résument des sous-arbres pleins. Deux runs passent, validation non mutante 98/98, revue 23/23, troisième run identique et 159 adresses natives concordantes avec le PE. Rapports : `AUDIT_SYS01202_MAP10_SHADER_LIFECYCLE_COMPOSITION_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_LIFECYCLE_COMPOSITION_2026-11-03.md`.

Ces deux unités ne sont pas encore une exécution des producteurs `0x98D960/0x98C070`. Il reste à composer les sorties FOUR_BLEND exactes avec le lifecycle, puis à exercer les producteurs dans un lot borné arrêté avant paire/bind/draw. Runtime 2014, `Present`, pixels, intégration Rust et fidélité visuelle restent ouverts. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1156 — lifecycle FOUR_BLEND exact et préflight producteurs

Le lifecycle V1155 a été recomposé avec les deux sources/includes FOUR_BLEND exacts, leurs buffers expansés, bytecodes et CTAB épinglés. Sur l'hôte actuel, les vrais shaders D3D9 sont créés sur la RTX 3060, les slots sont alloués par les primitives originales, les records exact-layout sont nettoyés par les chemins originaux et tout ownership revient à zéro. Les rollbacks compilation, device et saturation passent. Deux runs sont reproductibles, validation non mutante 50/50, revue indépendante 57/57 et troisième run identique. Provider/managers/records restent des adapters contrôlés et D3DX/D3D9 sont current-host ; aucun producteur original, paire, bind ou rendu n'est exécuté. Rapports : `AUDIT_SYS01202_MAP10_FOURBLEND_LIFECYCLE_2026-11-03.md` et `REVIEW_SYS01202_MAP10_FOURBLEND_LIFECYCLE_2026-11-03.md`.

Le préflight statique des producteurs pixel `0x98C070` et vertex `0x98D960` est READY, mais leur exécution reste BLOCKED par un seul contrat : `STREAM_SLOT_0X10_RETURN_OBJECT_ABI_NOT_CLOSED`. Les ABI, stores `record+4`, factories, pools, succès/erreurs, cleanup et frontière d'arrêt avant paire/bind/draw sont reconstruits ; validation 28/28 et manifeste 6/6. Le slot stream `+0x10` doit encore prouver l'objet EAX transmis comme ECX aux factories, sa durée de vie et la préservation du triplet include/macros/count. Rapport : `AUDIT_SYS01202_MAP10_SHADER_PRODUCER_PREFLIGHT_2026-11-03.md`.

L'exécution producteur demeure interdite. V1157 traite uniquement ce dernier gap ; le runtime Riot 2014, paire, bind, draw, `Present`, pixels, intégration Rust et fidélité visuelle restent ouverts. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1157 — ABI exacte du slot stream `+0x10`

Le blocage unique du préflight producteur V1156 est fermé pour l'adapter composé. Deux exécutions des spans originaux pixel/vertex jusqu'aux entrées factory démontrent que le slot virtuel stream `+0x10` est un thiscall sans argument de pile et retourne dans `EAX` un `char*` NUL emprunté, ensuite transmis comme `ECX` à la factory. Les trois valeurs déjà empilées — objet include, `macro_begin`, `macro_count` — ne sont pas des arguments du slot : elles survivent et deviennent les arguments de factory. L'objet include exact porte la vtable `0x10DBAEC` et le répertoire `Environment`. À la frontière contrôlée, `EDX=EBX=1`.

Deux runs passent 27/27, le validateur non mutant 65/65 et la revue indépendante 60/60 avec troisième run 27/27. Zéro factory, producteur, D3DX, device, pool, bind ou draw n'est exécuté dans ce lot. La classe concrète du stream Riot/RADS historique reste `UNKNOWN_PROVIDER_SPECIFIC`; l'adapter est seul qualifié. Rapports : `AUDIT_SYS01202_MAP10_SHADER_STREAM_SLOT10_HANDOFF_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_STREAM_SLOT10_HANDOFF_2026-11-03.md`.

Cette preuve supersède les formulations trop larges de V1153/V1156 qui attribuaient le triplet de pile au slot ou évoquaient un objet string. Le préflight peut désormais passer à `READY_FOR_ONE_CONTROLLED_RUN`, toujours avec slot libre vérifié avant entrée, capture des records puis cleanup original, et arrêt avant paire/résolution/bind/draw. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1158 — producteurs shader originaux dans une composition bornée

Les corps producteurs originaux pixel `0x98C070` puis vertex `0x98D960` ont été exécutés jusqu'à leur `ret 8` dans une composition adapters/current-host. Dans chacun des deux runs, `AL=1`, les handles distincts sont publiés dans `record+4`, wrappers/CTAB/shaders sont non nuls, refcount=1 et les slots feuilles sont possédés. Le flot complet observe `EDX=0` pour `ps_2_0`/`vs_2_0` et le répertoire include `Environment/`. Le cleanup original inverse — vertex `0x9AED50`, puis pixel `0x9AEDC0` — ramène pools, records, wrappers, proxies D3DX/host et shaders à zéro.

Deux runs passent 14/14 avec la même projection, le validateur non mutant passe 191/191 et la revue indépendante 387/387 sans modifier le dossier audité. Pair `0x9AEE30`, flush `0x9C22E0`, bind `0x9BEF40`, setters, draw, `Present` et readback restent tous à zéro. Rapports : `AUDIT_SYS01202_MAP10_ORIGINAL_SHADER_PRODUCERS_2026-11-03.md` et `REVIEW_SYS01202_MAP10_ORIGINAL_SHADER_PRODUCERS_2026-11-03.md`.

Correction : le `EDX=1` injecté dans le span isolé V1157 ne qualifie pas le producteur complet ; V1158 le supersède par `EDX=0`. De même, le répertoire original complet est `Environment/` avec slash final. L'ABI du slot V1157 reste valide. Limite majeure : les corps producteurs sont originaux, mais les factories originales sont interceptées à leur entrée et leur comportement qualifié est composé via les adapters V1155/V1156 ; runtime Riot 2014 non prouvé. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1158 — pair/cache shader jusqu'à la frontière pré-bind

Le préflight statique V1157 a reconstruit la pair factory `0x9AEE30`, le resolver/cache `0x9C22E0` et le binder `0x9BEF40`. La pair record a un stride `0x10` et contient backend, refcount, handles VS/PS ; le binder appelle ensuite `SetVertexShader` puis `SetPixelShader`. Ce préflight est statiquement READY mais l'exécution bind restait BLOCKED. Rapport : `AUDIT_SYS01202_MAP10_SHADER_PAIR_BIND_PREFLIGHT_2026-11-03.md`.

Le lifecycle V1158 exécute la pair factory originale puis le resolver miss, arrêté exactement sur le `CALL` à `0x9C2372` avant `0x9BEF40`. Un hit cache/current-equal retourne sans nouvelle factory ni bind. Les deux shaders FOUR_BLEND exacts sont co-résidents sur le même device current-host ; refcounts, cache/current, refus null/famille/device/factory/saturation et ownership final sont contrôlés. Le release original ne libérant pas le slot bitmap, le harness retire d'abord le cache puis applique explicitement `0x8E2980`, prouve la réutilisation du slot 0 et ne revendique pas ce rollback comme comportement Riot implicite.

Deux runs passent, validation non mutante 43/43 et revue indépendante 244/244 avec troisième run identique. Aucun `0x9BEF40`, Set, draw, `Present` ou readback n'est exécuté. Les zéros GPU sont des assertions structurelles corroborées par la frontière et les capacités limitées du wrapper, pas une instrumentation générique. Rapports : `AUDIT_SYS01202_MAP10_SHADER_PAIR_LIFECYCLE_PREBIND_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_PAIR_LIFECYCLE_PREBIND_2026-11-03.md`.

Rollback pair/cache, co-résidence device et confinement factory sont fermés pour l'adapter. Reste à qualifier séparément l'atomicité du binder et le rollback si le second Set échoue, toujours sans draw. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.


## V1159 — bind FOUR_BLEND pré-draw et préflight draw

Le pair FOUR_BLEND V1158 a traversé le resolver, le binder original `0x9BEF40` et le store du current pair sur le device D3D9 actuel. L'ordre nominal est `SetVertexShader` puis `SetPixelShader`, tous deux `S_OK`; `GetVertexShader/GetPixelShader` confirment les deux objets attendus. Le cache-hit/current-equal ne rebinde pas, le pair nul est un no-op et le device mismatch est refusé avant entrée. Deux runs passent avec projection identique, validation 87/87 et revue indépendante 135/135.

Le binder original ne teste aucun HRESULT et n'est pas atomique. Un échec PS `0x8876086c` injecté au pont après un SetVS réel démontre l'état partiel VS lié/PS nul. Le harness seul restaure ensuite le snapshot ; ce rollback n'est pas attribué à Riot et l'échec n'est pas présenté comme généré par le pilote NVIDIA. Cleanup complet à zéro, aucun draw/`Present`/readback. Rapports : `AUDIT_SYS01202_MAP10_SHADER_PAIR_BIND_PREDRAW_2026-11-03.md` et `REVIEW_SYS01202_MAP10_SHADER_PAIR_BIND_PREDRAW_2026-11-03.md`.

Le préflight draw statique ferme la chaîne `0x95B112 → backend+0x20 → 0x9C2400 → 0x9C54A0 → DrawIndexedPrimitive slot 82`. Arguments internes `[0,0,213,3,252,1]`, arguments COM `[D3DPT_TRIANGLELIST=4,0,213,3,252,1]`; bornes VB/IB valides. Le HRESULT doit être capturé immédiatement à `0x9C54EE`; le wrapper tolère DEVICELOST et ne propage pas un statut stable. Préflight statique READY/validation 36/36, mais draw BLOCKED par composition même-run, scène/targets/viewport, caméra/constantes, matériau/render states, stages texture manquants et rollback intégral. Rapport : `AUDIT_SYS01202_MAP10_DRAW_PREFLIGHT_2026-11-03.md`.

Aucun draw, image ou fidélité visuelle n'est qualifié. Aucun produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.

## Reprise SYS-01.2-02 — V1160 scène et entrées matériau Map10 (2026-11-03)

### Scène / targets / viewport pré-draw

- **Audit** : clos pour le composant D3D9 current-host séparé. Deux runs établissent RT/depth compatibles, viewport/scissor bornés, ownership `BeginScene`/`EndScene` et rollback exact de ce sous-ensemble.
- **Implémentation** : aucune modification produit ; la composition full-pipeline demeure absente.
- **Vérification** : 20/20 par run, validation 30/30 et revue indépendante 30/30. RTX 3060 et runtime Windows courant ; aucun shader bind, `Draw*`, `Present` ou readback.
- **Acceptation humaine** : non demandée ; aucune image ni fidélité visuelle qualifiée.

### Constantes, samplers et permutation FOUR_BLEND

- **Audit** : borné PASS pour la réflexion CTAB/bytecode V1155 et l'inventaire exact des registres/samplers ; upload historique **BLOCKED avant mutation**.
- **Implémentation** : aucune. Les valeurs exactes caméra/lumière/FoW, plusieurs handles texture, les render states et les filtres/LOD complets ne sont pas composés.
- **Vérification** : deux runs déterministes, validateur non mutant 17/17 et revue indépendante 20/20 avec un troisième run reproductible ; zéro `Set*`, bind, draw, `Present`, readback ou écriture sur F.
- **Écart découvert** : V1158 avait exécuté les producteurs avec trois macros locales seulement (`COLORPALETTE_DEFAULT`, `DISABLE_EMISSIVE`, `FOUR_BLEND`), tandis que la route Map10 prouve séparément `USE_HEIGHT_BLEND` et `MOD2X_COLORMAP`. Les permutations recompilées dans V1160 restent des **candidates**, pas une preuve historique.
- **Acceptation humaine** : non applicable à cet audit CPU/statique ; aucune sortie visuelle.

### Reprise bornée

Le lot REA V1161 est actif sur cinq fonctions seulement (`0x9593C0`, `0x98C070`, `0x98D960`, `0x95A730`, `0x95AFC0`) afin de relier le vector macro original aux producteurs et au consommateur terrain. Une seule session statique, aucune installation, aucune exécution du jeu et aucune écriture produit. Condition d'arrêt : lien exact établi, ou inconnue résiduelle précisément nommée. Le draw, la composition full-pipeline, ses constantes/handles réels, son HRESULT et son rollback restent ouverts.

## Reprise SYS-01.2-02 — V1161 gate des candidates shader Map10 (2026-11-03)

- **Audit** : clos pour la reproductibilité current-host des deux permutations candidates et le contrat d'admission historique. Les CTAB embarquées correspondent aux buffers retournés et les objets D3DX sont libérés à zéro.
- **Implémentation** : aucune ; la fonctionnalité reste `BLOCKED_BEFORE_MUTATION`. Les candidates height+colormap et height+colormap+fog ne sont pas promues comme choix du client Riot 4.20.
- **Vérification** : deux runs déterministes, validateur non mutant 26/26 et revue indépendante 19/19 avec troisième run isolé. Zéro device, bind, upload, draw, `Present`, readback, pixel ou écriture produit/F.
- **Acceptation humaine** : non demandée ; aucune image ni fidélité visuelle qualifiée.
- **Reprise bornée** : les lots REA et statique ciblés cherchent uniquement le lien entre le vector macro ordonné, `0x98C070/0x98D960` et le consommateur terrain `0x95A730`. Tant qu'un reçu machine-readable ne satisfait pas tout le contrat, le gate reste fermé et l'inconnue est conservée.

## Reprise SYS-01.2-02 — V1161 lien macro Map10 et clôture REA (2026-11-03)

- **Audit statique** : `PROVEN_STATIC` pour la chaîne `0x9593C0 → 0x959D30 → records pixel/vertex → 0x98C070/0x98D960 → 0x95A730/0x95AFC0`. Le même contenu macro ordonné est copié profondément dans deux allocations distinctes, puis reçoit le même suffixe `DISABLE_EMISSIVE;FOUR_BLEND`.
- **Vérification** : deux runs au digest stable, validation non mutante 22/22 et revue indépendante 28/28. Le raccord au bind reste conditionné par selector/material/options, manager/device/handles valides et remapping death-screen inactif.
- **Écart conservé** : le vecteur historique complet reste `UNRESOLVED_RUNTIME_INPUTS`. Les candidates V1161 sont `REFUSED` : leur ordre est incomplet et le fog historique ajoute un compagnon LOW ou TEXTURED_OPACITY avec `FOG_PIXELSHADER_BLEND`.
- **REA** : les deux nouvelles tentatives sont `INCOMPLETE`, sans adresse fonctionnelle analysée ni fausse réussite. La première conserve son timeout avec fermeture acquittée ; la seconde conserve son interruption, sa fermeture protocolaire non vérifiée et trois résidus de verrouillage Ghidra laissés intacts. Leur présence ne prouve pas un processus actif. La preuve structurelle vient du lot statique indépendant, pas de ces tentatives REA.
- **Implémentation / acceptation** : aucune modification produit, aucun jeu/D3D/draw/image ni acceptation humaine. Le lot V1162 actif classe neuf globals runtime comme code-owned, configuration Map10 ou valeur de frame ; aucun vecteur historique ne sera construit tant qu'un input requis reste inconnu.

## Reprise SYS-01.2-02 — V1162 entrées runtime et remapping death-screen Map10 (2026-11-03)

### Audits bornés clos

- **Entrées des macros** : les neuf globals requis par V1161 sont classés avec leur producteur, limite et condition de reprise. Résultat : un `STATIC_CODE_OWNED` (`animate_fow_override=0`), un `MAP10_CONFIG_DETERMINABLE` (`fog_feature_byte=true`) et **sept `RUNTIME_OR_FRAME_NOT_PINNED`**. Deux runs portent le digest stable `2edd222c5873a4b18cb0ff3c67c2ec77e4c788101a059855a7067498d2bc60d4`, le validateur passe 31/31 et la revue indépendante 803/803.
- **Remapping death-screen** : l'algorithme de `0x95A570` est `PROVEN_STATIC`, le zéro constructeur est seulement `INACTIVE_PROVEN_INITIAL_ONLY`, puis l'état Map10 reste `UNKNOWN_AT_STARTUP` et **`UNKNOWN_AT_DRAW`**. Le handle `record+4` est correctement chargé à `0x95A5B5`. Deux runs portent le digest `33a95387290824dd82d116686d3a67c002153955fc209976efc595aee310111b`, le validateur passe 29/29 et la revue finale 30/30.

### Fonctionnalité toujours ouverte

La clôture concerne les deux audits V1162, pas la fonctionnalité renderer. Le vecteur historique complet reste `NOT_BUILT_REQUIRED_INPUTS_UNKNOWN` parce que sept entrées runtime/provider/objet ne sont pas figées. Le remap reste `UNKNOWN_AT_DRAW` : ni le lifecycle complet des six stores runtime, ni un snapshot admissible au draw n'est établi. **Aucun candidat n'est admis ou créé, aucun lifecycle/bind/upload/draw n'est autorisé ou exécuté par V1162.** La carte, le renderer, le runtime Riot 2014, les pixels et le jeu restent incomplets.

Rapports : `docs/AUDIT_SYS01202_MAP10_MACRO_RUNTIME_INPUTS_2026-11-03.md`, `docs/REVIEW_SYS01202_MAP10_MACRO_RUNTIME_INPUTS_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_DEATHSCREEN_PIXEL_REMAP_2026-11-03.md` et `docs/REVIEW_SYS01202_MAP10_DEATHSCREEN_PIXEL_REMAP_2026-11-03.md`. Aucun code produit, asset, registre protégé, Goal, Plan, interface, application ou base n'est modifié par ces lots.

## Reprise SYS-01.2-02 — consolidation V1162 et palette Map10 V1163 (2026-11-03)

### 18e audit borné clos

- La consolidation V1155–V1162 conserve `SYS-01.2-02` à l'état **`OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE`** : 17 audits atomiques étaient clos, mais la tâche parente restait ouverte.
- V1163 clôt le 18e audit atomique, `AUD-SYS-01.2-02-MAP10-COLOR-PALETTE-PROVIDER-ORDER-01`. L'initialiseur, le setter, les stores `0x97CCF8/0x97CDB6/0x97CDD1`, le contexte `0x2D7905C`, la lecture `0x959DA0` et le choix d'un unique `COLORPALETTE_*` sont reliés statiquement. L'ordre interne est `PROVEN_STATIC`; le dernier événement runtime parmi initialiseur, setter et slots virtuels de contexte reste `UNKNOWN_RUNTIME_ORDER`.
- Le provider générique est le getter entier `0x8B1C20`, avec ordre baseline/default puis utilisateur et overlay avant primaire. Les paires réellement retournées par le cache au lancement de référence ne sont pas observées : **provider/overlay effectif `UNKNOWN_AT_REFERENCE_RUN`**.
- Le crosscheck actuel établit seulement une étiquette UI conservée. Le chargeur Rust matérialise `EnvironmentQuality`, mais aucun bridge nommé préférence ColorPalette → état Rust → renderer/WGSL n'est trouvé dans les consommateurs ciblés.

### Fonctionnalité toujours ouverte

Cette clôture documentaire ne termine ni la palette, ni Map10, ni le renderer, ni `SYS-01.2-02`, ni le jeu. Les defaults PE et `Game.cfg` ne sont pas une valeur runtime effective. Aucun vecteur historique complet, shader candidat, frame, pixel ou acceptation humaine n'est admis. **Aucun nouveau run D3D9**, jeu, REA, installation ou changement produit n'a été effectué.

Reprendre uniquement avec une trace/snapshot original épinglant dans un même ordre les slots de contexte, `0x5902D5`, le prochain caller de `0x959D30`, les paires cache effectives et `0x2D79058` juste avant `0x959DA0`, ou avec un bridge actuel qualifié préférence → état → renderer. Ne pas répéter les scans directs sans nouveau caller, provider, bridge ou contre-observation.

Rapports : `docs/AUDIT_SYS01202_COVERAGE_CONSOLIDATION_V1162_2026-11-03.md`, `docs/AUDIT_SYS01202_MAP10_COLOR_PALETTE_PROVIDER_ORDER_2026-11-03.md`, `docs/CROSSCHECK_SYS01202_MAP10_COLOR_PALETTE_CONSUMER_2026-11-03.md` et `docs/REVIEW_SYS01202_MAP10_COLOR_PALETTE_PROVIDER_ORDER_2026-11-03.md`. Aucun Goal, Plan, UI, application, base, registre protégé, code produit ou asset n'est modifié par ce lot.


## Reprise SYS-01.2-02 — V1164 stop loose et V1165 CTYPE (2026-11-03)

### Préflight V1164

Les trois inconnues loose Urf/Cheats/Locale ont déjà leurs audits et une règle de non-répétition. Le préflight V1164 est `STOP_NO_NEW_EVIDENCE` : aucune nouvelle clôture, aucune inconnue résolue, aucun REA/jeu/install. `locale.cfg` garde un consommateur partiel limité aux fontes HUD ; l'absence Urf/Cheats reste bornée. Reprendre uniquement sur une nouvelle preuve primaire de génération, staging ou ordre de montage.

### V1165, inconnue CTYPE

L'audit du consommateur OpenLeague `AUD-SYS-01.2-02-CTYPE-CURRENT-CONSUMER-01` est clos avec preuves : le package courant contient `0x14AE870=0`, deux composants lisent le prédicat et appliquent le pli ASCII, mais refusent la branche non-C. Le démarrage normal attache la banque sans construire/publier le loading owner ni le resource manager ; implémentation `PARTIELLE_NON_RELIÉE_DE_BOUT_EN_BOUT`.

La session unique REA/Ghidra sur `0xCA99C7` est `TOOL_FAILURE_PRESERVED` : PE exact ouvert, timeout `list_segments` après 900000 ms, zéro appel fonctionnel, aucun caller/provenance produit, zéro retry, fermeture complète et aucun résidu. `[ebp+0x0C]` reste `UNKNOWN_UNCHANGED` et OLU-3293 reste `open`.

Validations : 39/39 baseline, 59/59 conservation de l'échec, 32/32 consommateur courant, revue indépendante 49/49. `D01-SYS-01-1`, `SYS-01.2-02`, la fonctionnalité et le jeu restent ouverts. Aucun Goal, Plan, UI, application, base, registre protégé, code produit ou asset n'est modifié.

## V1166 — consolidation de couverture et accélérations qualifiées (2026-11-03)

- **Couverture bornée** : 19 audits source-consommateur clos, dont 17 hérités de V1162, ColorPalette V1163 et consommateur CTYPE courant V1165. Les deux investigations REA V1165/V1166 sont closes comme investigations d'outillage et ne sont pas comptées comme audits. Elles ne résolvent pas `OLU-3293...`.
- **Probe snapshot** : le bundle exact du PE `402bf2...7862` relit hors ligne 10 preuves (7 fonctions, 3 xrefs) ; `0xCA99C7` n'y figure pas. `analyze_function` puis l'unique requête réduite `read_function_instructions` expirent à 180000 ms. Stop : `STOP_NO_THIRD_REA_REQUEST_FOR_CA99C7_WITH_THIS_SNAPSHOT_AND_PROVIDER_CONFIGURATION`.
- **Accélérations retenues** : delta sur V1162, réemploi par hash, validateurs ciblés, revue indépendante parallèle et gates de non-répétition. Tree-sitter, Cargo/nextest, apitrace et RenderDoc restent différés jusqu'à leurs déclencheurs documentés ; aucune installation n'est justifiée maintenant.
- **État** : 0 nouvelle unité historique ou fonctionnelle close après le probe ; 2 unités Map10 à une preuve et 2 bloquées restent inchangées. Aucun dénominateur global ni pourcentage de jeu n'est revendiqué. `D01-SYS-01-1` reste `a_faire` et `SYS-01.2-02` reste `OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE`.

Rapports : `AUDIT_SYS01202_V1166_COVERAGE_AND_ACCELERATION_2026-11-03.md` et `REVIEW_SYS01202_V1166_COVERAGE_AND_ACCELERATION_2026-11-03.md`. Aucun Plan, goal, UI, base, registre protégé, code produit ou asset n'a été modifié.

## Reprise SYS-01.2-02 — V1167 ITEM-3117 source et consommateur (2026-11-03)

- Unité `AUD-SYS-01.2-02-ITEM3117-SCOPE-SOURCE-CONSUMER-01` close au niveau audit statique : INIBIN 4.20 identifié et décodé, référence officielle 4.20.1 distinguée, boutique actuelle absente et refus explicite relié. Contrôle ciblé 26/26 et relecture indépendante PASS ; aucun Cargo ni runtime.
- `items.ron` contient 3117, mais le consommateur `shop.rs` charge `shop_foundation.json`, où 3117 manque. La liste native `UnpurchasableItemList` ne le contient pas ; cela ne décide pas l'admission finale Map10. `ITEM-3117-SCOPE`, le prérequis D01 et `SYS-01.2-02` restent ouverts ; aucun total global n'est déduit des 19 audits du lot V1166.
- Réutiliser `ITEM-3117-SCOPE`, `ITEM-3117-SHOP` et `ITEM-3117-SERVER-PASSIF` pour les corrections ultérieures. Rapport : `docs/AUDIT_SYS01202_ITEM3117_SCOPE_SOURCE_CONSUMER_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_sys01202_item3117_scope_20261103/result.json`. Le checkpoint 3024 est ancien et son audit existe déjà ; ne pas le rejouer.
- Aucun Plan, goal, interface, base, registre protégé, code produit ou asset n'a été modifié par cet audit documentaire.

## Reprise SYS-01.2-02 — V1168 quatre objets source et consommateur (2026-11-03)

- Quatre unités atomiques closes au niveau audit statique, chacune avec son source/consumer, valeurs, limites et correction : `ITEM-3122-SCOPE`, `ITEM-3123-SCOPE`, `ITEM-3124-SCOPE`, `ITEM-3128-SCOPE`. Contrôle commun 15/15, 34/34 par objet, 151/151 au total ; relecture indépendante PASS. Rapport : `docs/AUDIT_SYS01202_ITEM_SCOPE_3122_3123_3124_3128_SOURCE_CONSUMER_2026-11-03.md` ; reçu : `E:/mapslol3v3/audit_sys01202_item_scope_batch_20261103/result.json`.
- Les quatre tâches SCOPE restent `a_qualifier`. Le client courant refuse les quatre IDs car absents de `shop_foundation.json`. Pour 3128, `maps[10]=false` dans le comparatif 4.20.1 et présence dans la liste native `UnpurchasableItemList` convergent, sans prouver la décision finale du provider/client/serveur 4.20.0.315. Aucun achat, effet ou test Rust n'a été exécuté.
- La pièce jointe historique cite 42 214 exigences et 92 639 sources ; le registre courant contient 42 215 exigences, 100 405 entrées de sources et 5 759 consumers. Ces comptes sont structurels et ne forment pas un taux d'audits terminés. Les 19 audits V1166, l'unité 3117 V1167 et ces quatre unités restent des périmètres explicitement bornés.
- Aucun Plan, goal, application de suivi, interface, base, registre protégé, code produit ou asset n'a été modifié.

## Reprise SYS-01.2-02 — V1169 Ahri W source et consommateur (2026-11-03)

- Unité `AUD-SYS-01.2-02-AHRI-W-SOURCE-CONSUMER-01` close au niveau audit statique : INIBIN 4.20, catalogue officiel 4.20.1 distinct, cinq LuaObj clients vérifiés dans le manifeste RADS et refus des consommateurs Rust reliés. Reçu ciblé 37/37 et relecture indépendante PASS : `E:/mapslol3v3/audit_sys01202_ahri_w_20261103/result.json`. Rapport : `docs/AUDIT_SYS01202_AHRI_W_SOURCE_CONSUMER_2026-11-03.md`.
- `CH-Ahri-W-SOURCE` reste `a_qualifier` et `CH-Ahri-W-SIMULATION-CONTRAT` reste `a_faire`. Le comportement serveur 4.20, les impacts multiples, le ciblage et la simulation actuelle ne sont pas qualifiés. Le script communautaire W.cs donne 50 % sur les impacts supplémentaires contre 30 % dans le texte officiel 4.20.1 ; son dispatch historique n'est pas prouvé.
- Aucun runtime Rust, jeu original, analyse REA nouvelle ou acceptation humaine n'a été exécuté. Le reçu REA antérieur se relit hors ligne ; `0xCA99C7` reste absent de ses dix traces et sous règle d'arrêt V1166. Aucun Goal, Plan, UI, application, base, registre protégé, code produit ou asset n'a été modifié.

## Reprise SYS-01.2-02 — V1170 Ahri E et R source-consommateur (2026-11-03)

- Deux unités distinctes closes au niveau audit statique : Ahri E Charm (37/37, relecture indépendante PASS) et Ahri R Spirit Rush (50/50, relecture indépendante PASS). Rapports : docs/AUDIT_SYS01202_AHRI_E_SOURCE_CONSUMER_2026-11-03.md et docs/AUDIT_SYS01202_AHRI_R_SOURCE_CONSUMER_2026-11-03.md. Reçus : E:/mapslol3v3/audit_sys01202_ahri_e_20261103/result.json et E:/mapslol3v3/audit_sys01202_ahri_r_20261103/result.json.
- Ahri E suit actuellement Action::Cast slot 2 sans cible de point, puis le refus core ; Ahri R suit Action::Cast slot 3 au clic, puis le refus core. Les sources natives sont identifiées et comparées au catalogue officiel 4.20.1 distinct, sans preuve du serveur Riot 4.20.0.315 ou exécution du jeu.
- Les quatre tâches SOURCE/CONTRAT, leurs prérequis, la mécanique historique, les implémentations E/R et SYS-01.2-02 restent ouverts. Aucun Goal, Plan, application de suivi, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1171 Ahri passif HUD source-consommateur (2026-11-03)

- Sous-audit statique AUD-SYS-01.2-02-AHRI-PASSIF-HUD-ICON-STATE-LINK-01 clos, reçu 25/25 et relecture indépendante PASS. Rapport : docs/AUDIT_SYS01202_AHRI_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_ahri_passive_hud_20261103.
- Ahri.inibin déclare Passive1Icon=Ahri_SoulEater.dds. Les deux DDS SoulEater sont membres du client exact, mais le rôle de la variante 2 est inconnu. Le texte en_GB du client original concorde avec la copie locale. Le HUD F QWER/D-F et le module passif Ezreal ne relient aucun état ou icône passif Ahri dans leurs trajets inspectés ; la recherche bornée de 1149 fichiers Rust ne trouve aucun chemin Ahri nommé.
- CH-Ahri-PASSIF-PRESENTATION-HUD reste a_faire, son prérequis réseau et OLU-f561f2fa... restent ouverts. Aucun rendu, partie, Rust test, acceptation ou nouveau REA exécuté. Aucun Goal, Plan, application de suivi, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1172 Annie passif HUD source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ANNIE-PASSIF-HUD-ICON-STATE-LINK-01 close au niveau audit statique : 44/44 contrôles et relecture indépendante PASS. Rapport : docs/AUDIT_SYS01202_ANNIE_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ; reçu et validateur : E:/mapslol3v3/audit_sys01202_annie_passive_hud_20261103.
- Annie.inibin déclare Annie_Passive.dds et Pyromania Marker. Deux DDS distincts et trois LuaObj sont membres du manifeste lol_game_client agrégé 0.0.1.7, avec releases individuelles, tailles et MD5 vérifiés. Le texte en_GB est identifié ; la sélection et la priorité runtime restent inconnues. Le compteur Rust produit un texte général « Pyromanie n/4 » et un VFX monde, mais les chemins HUD QWER/D-F et Buff0 Ezreal inspectés ne portent pas d'icône HUD passive Annie.
- CH-Annie-PASSIF-PRESENTATION-HUD, sa dépendance réseau et OLU-9e5eb9b1... restent ouverts. Aucun jeu, rendu, Rust test, réseau, REA ni acceptation exécuté. Aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1173 P15 fermeture patcher source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-PATCHER-P15-CLOSE-CONFIRMATION-LINK-01 close au niveau audit statique : 32/32 contrôles et relecture indépendante PASS. Rapport : docs/AUDIT_SYS01202_PATCHER_P15_CLOSE_CONFIRMATION_LINK_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_patcher_p15_20261103.
- P15 est un écran de l'inventaire SYS-01.1-04 déjà a_valider, pas une tâche autonome. Le patcher 0.4.0.122, en_GB.tra et le bundle JS identifient dialogue et libellés ; la chaîne PE DisplayCloseWarning à VA 0x79CD38 est une adresse de chaîne, pas un callsite. Le launcher Tauri actuel bloque seulement certaines fermetures d'une session locale jointe, puis peut afficher un texte de statut ; aucun dialogue P15 à deux boutons n'est identifié dans les chemins inspectés.
- Investigation REA distincte : docs/AUDIT_SYS01202_PATCHER_P15_REA_XREF_STOP_2026-11-03.md, reçu E:/mapslol3v3/audit_sys01202_patcher_p15_rea_20261103/p15_rea_stop_result.json (24/24, revue indépendante PASS). Le PE exact a été ouvert ; xrefs a expiré après 600000 ms, l'export a échoué séparément, la session est fermée. Aucun appelant produit, zéro retry ; gate STOP_AFTER_SINGLE_PATCHER_P15_XREF_PROVIDER_TIMEOUT_NO_IDENTICAL_RETRY.
- Le déclencheur host/les callbacks historiques, le rendu et les branches GUI restent inconnus. Correction PATCHER-P15-CLOSE-CONFIRMATION proposée, non ajoutée au Plan. Aucun jeu, launcher, Rust test ou acceptation exécuté. Aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1174 Ashe passif HUD source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ASHE-PASSIF-HUD-ICON-STATE-LINK-01 close au niveau audit statique : 72/72 contrôles et relecture indépendante PASS. Rapport : docs/AUDIT_SYS01202_ASHE_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_ashe_passive_hud_20261103.
- Ashe.inibin déclare Ashe_Passive.dds et Focus. Trois LuaObj natifs identifient Focus, AsheCritChance avec variante Grey, et AsheCritChanceReady avec icône normale ; trois INIBIN de buff renvoient à leurs textes en_GB. Neuf fichiers ont taille, SHA-256 et appartenance au manifeste agrégé vérifiés. La sélection et les transitions historiques restent inconnues ; l'ancienne Passive1Desc diffère du texte localisé sans être déclarée corrompue.
- La trace HUD inscrit Ashe.inibin et CharScriptAshe.luaobj, mais pas le Focus.luaobj distinct, les DDS ou un consommateur HUD dédié. Le HUD courant inspecté charge seulement QWER/D-F ; Buff0 est spécifique à Ezreal, et aucun état Focus nommé n'est identifié dans Effects. CH-Ashe-PASSIF-PRESENTATION-HUD et OLU-37f17d3b... restent ouverts. Aucun jeu, rendu, test Rust, réseau ou REA exécuté ; aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1175 Kindlegem3067 passif source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ITEM3067-PASSIVE-SOURCE-CONSUMER-01 close au niveau audit statique : 49/49 contrôles et revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3067_PASSIVE_SOURCE_CONSUMER_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_item3067_passive_20261103.
- L'INIBIN déclare Effect1Amount float32 -0.10000000149, sans rôle CDR démontré. Le CDR courant +0.1 vient de la recette recover_caster_items.py fondée sur le tooltip FR UNIQUE+10%, comparé séparément au texte en_GB et au catalogue4.20.1. Le trajet réel catalogue→Bonuses/déduplication par ID→cap progression→cooldown::ticks→cast est identifié ; aucun générateur n'est exécuté.
- Les cas0/1/2 copies3067 sont des déductions statiques, pas des scénariosRust exécutés. Les deux tests3101 antérieurs restent datés et portent sur cap multi-ID et doublons3108. ITEM-3067-SERVER-PASSIF reste a_faire, SCOPE partiel_a_terminer, comportement natif et cumul ouverts. Aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1176 Youmuu3142 actif source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ITEM3142-ACTIVE-SOURCE-CONSUMER-01 close comme audit statique : 63/63 contrôles, revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3142_ACTIVE_SOURCE_CONSUMER_2026-11-03.md ; validateur/reçu : E:/mapslol3v3/audit_sys01202_item3142_active_20261103.
- Le binding item3142→YoumusBlade est natif. Item/tooltip en_GB et catalogue4.20.1 indiquent45s, tandis que SpellData.Cooldown du sort déclare60s ; rôle/override effectif inconnu. Dix ressources directes sont identifiées et membres du manifeste agrégé ; les métadonnées client et demandes communautaires6s/.2MS/.4AS ne prouvent pas le serveur Riot.
- Le chemin réel item_hotkey→Action::UseItem→command→use_item est identifié. Pour un slot hérité3142 passant les gardes antérieures, l'absence du catalogue produit item behavior not implemented avant actif/mutation ; admission absente ne vaut pas exclusion historique. La trace conserve seulement le consumer d'achat. ITEM-3142-SERVER-ACTIF, SCOPE et la mécanique restent ouverts. Aucun runtime, REA ou script communautaire exécuté ; aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1177 Quicksilver3140 actif source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ITEM3140-ACTIVE-SOURCE-CONSUMER-01 close comme audit statique : 79/79 contrôles et revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3140_ACTIVE_SOURCE_CONSUMER_2026-11-03.md ; validateur, reçu et recherche publique : E:/mapslol3v3/audit_sys01202_item3140_active_20261103.
- Le binding item3140→QuicksilverSash est natif. Item/texte en_GB/catalogue4.20.1 indiquent90s, tandis que le sort déclare60s et lie ses descriptions aux chaînes Cleanse/SummonerBoost65%/3s ; rôles/overrides effectifs inconnus. Neuf références directes ont identité/membership vérifiées. ItemLua/preload absents aussi du manifeste agrégé, sans corruption inférée.
- Le miroir communautaire présent est une donnée, pas un script exécutable. Les recherches locales dans 799 fichiers C# et les recherches publiques ciblées n'ont pas permis de récupérer un script ; couverture d'index inconnue. Le chemin hotkey→UseItem→use_item refuse un slot 3140 autrement valide car l'ID est absent du catalogue, avant actif ou mutation. Aucun test produit ou REA exécuté. Tâche, SCOPE, purge et délai restent ouverts ; aucun Goal, Plan, application, base, registre protégé, code ou asset modifié.

## Reprise SYS-01.2-02 — V1178 Mercurial3139 actif source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ITEM3139-ACTIVE-SOURCE-CONSUMER-01 close comme audit statique : 65/65 contrôles et revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3139_ACTIVE_SOURCE_CONSUMER_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_item3139_active_20261103.
- L'item 3139 se lie directement à ItemMercurial. Item, sort et texte indiquent 90 s ; les effets 0.5/1 concordent avec le texte +50 % de bonus de déplacement pendant une seconde. Le 60 s de QuicksilverSash n'est pas importé ici. Les bindings Cleanse 65 %/3 s et les drapeaux client ne prouvent pas la matrice de purge ou l'activation sous contrôle.
- Sept ressources natives directes et le miroir de données sont identifiés. Le catalogue officiel 4.20.1 porte maps10=false ; disponibilité du build exact et SCOPE restent ouverts. Le chemin d'usage actuel refuse un slot 3139 autrement valide au lookup catalogue absent. La recherche communautaire de V1177 est réutilisée comme preuve datée, sans prétendre les 799 fichiers inchangés. Aucun runtime, REA ou nouvelle recherche publique exécuté ; aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1179 Dervish3137 actif source-consommateur (2026-11-03)

- Unité AUD-SYS-01.2-02-ITEM3137-ACTIVE-SOURCE-CONSUMER-01 close comme audit statique : 66/66 contrôles et revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3137_ACTIVE_SOURCE_CONSUMER_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_item3137_active_20261103.
- L'item 3137 se lie à ItemDervishBlade. Item, sort et texte concordent sur 90 s ; le texte conditionne le bonus de déplacement +50 % pendant une seconde au porteur de mêlée, sans appliquer cette condition à la purge. Le LuaObj item existe et se limite à un RETURN ; seul le preload item est absent. Les textes Cleanse et les drapeaux client restent des rôles non qualifiés.
- Sept ressources natives et un miroir de données sont identifiés. Le catalogue 4.20.1 indique maps12=false/maps1=false mais aucune clé10 ; aucune admission n'est inférée. Le chemin actuel refuse un slot 3137 autrement valide au catalogue absent. Les recherches communautaires restent datées et ne sont pas relancées. Tâche, SCOPE et mécanique restent ouverts ; aucun runtime ou REA exécuté ; aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1180 Dervish3137 CDR couverture source-consommateur (2026-11-03)

- Une unité d'audit de couverture et de liaison statique close, 45/45 contrôles et revue indépendante PASS. Rapport : docs/AUDIT_SYS01202_ITEM3137_CDR_COVERAGE_SOURCE_CONSUMER_2026-11-03.md ; validateur et reçu : E:/mapslol3v3/audit_sys01202_item3137_cdr_coverage_20261103.
- Data.PercentCooldownMod est un champ natif nommé : hash 2196017170, float32 -0.10000000149, bits cdccccbd ; le texte en_GB annonce +10 % de CDR ordinaire. La projection native_item_audit et les stats structurées du catalogue officiel omettent ce champ. Le parent ITEM-3137-SERVER garde une portée large, mais la partition des onze tâches de l'objet ne comporte pas de sous-tâche CDR explicite. Ce manque d'individualisation n'est pas une absence de l'exigence globale.
- Le vérificateur natif existant compare des champs/paires sélectionnés, pas leur exhaustivité ; sa portée n'est pas invalidée. La cause historique de génération du plan reste inconnue. Le catalogue courant ne contient pas 3137 : filter_map ignore cet ID dans les statistiques, contribution CDR nulle pour cet inventaire isolé ; l'achat est refusé par un autre trajet. Aucun scénario produit exécuté.
- Deux fiches sont proposées uniquement dans le rapport : CDR-CONTRAT et SERVER-STAT-PercentCooldownMod. Elles ne sont pas enregistrées et ne créent aucun nouveau dénominateur ou deux audits clos. Signe appliqué, cumul ordinaire et SCOPE restent ouverts ; aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1181 famille Data.PercentCooldownMod (2026-11-03)

- Une unité d'audit de couverture du champ nommé, 212/212 contrôles statiques ; rapport docs/AUDIT_SYS01202_NATIVE_PERCENTCOOLDOWNMOD_FAMILY_COVERAGE_2026-11-03.md. Preuves E:/mapslol3v3/audit_sys01202_cdr_family_preflight_20261103. Le premier reçu 205/212 est conservé : attentes trop fortes du validateur corrigées, aucun produit corrigé pour obtenir le succès.
- Le recensement daté 849 sources est préservé, non rejoué ; il sélectionne 10 valeurs non nulles sur 33 champs présents. Les 10 sources sélectionnées sont relues et identifiées par SHA-256/source_id/membre unique du manifeste : float natif -0.10000000149011612, cdccccbd, texte ordinaire +10% CDR. Versions membres individuelles conservées. Une présence au manifeste ne qualifie pas la disponibilité historique.
- Projection locale omet le champ pour les 10 ; catalogue courant absent pour les 10 ; parents SERVER généraux présents pour les 10, PASSIF générique présent pour 3056/3142/3290/3504/3508. L'absence de sous-tâche CDR nommée est un manque de précision de couverture, pas une absence d'exigence globale. Les cinq PASSIF restent conservés.
- Chemin courant catalogue → filter_map → bonus → plafond → ticks observé statiquement, sans exécution du jeu. Audit3137 V1180 réutilisé, neuf autres lignes examinées dans ce croisement ; aucune première découverte historique générale revendiquée, aucune fonctionnalité close.
- Propositions documentaires par ID + critères communs source/signe/cumul/consommateur/tests/reprise. Elles héritent de la condition SCOPE ; propositions3137 réutilisées sans doublon. Signe appliqué, cumul, admission historique et fonctionnement par objet restent ouverts. Aucun Goal, Plan, application, base, registre protégé, code produit ou asset modifié.

## Reprise SYS-01.2-02 — V1182 consolidation PASSIF-SOURCE douze champions (2026-11-03)

- Une unité nouvelle de consolidation documentaire, rapport docs/AUDIT_SYS01202_PASSIVE_SOURCE_REUSE_12_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_passive_reuse_12_20261103/reuse_matrix.json (9/9 cohérences). Douze premières fiches PASSIF-SOURCE du roster réel122 avecAzir ; aucune SOURCE ou fonctionnalité close, aucun pourcentage de jeu.
- Une seule extraction du graphe, 3,766s mesurées :313identités/313chemins (natives + références + code, pas313sources natives),8ancres conformes et trois registres stables. Les huit CID couvrent six sites communs SOURCE/catalogue et deux producteurs Annie partiels ; les lecteurs marqués provides_feature_consumer restent limités à leur scope d'audit SOURCE, pas au gameplay. Aucun runtime/decoder/ancien validateur relancé par la consolidation.
- Six périmètres clos hérités réutilisables :Aatrox/Ahri/Akali (audits ciblant ACCEPTANCE, OLF distincts),Alistar/Amumu (fraîcheur sources/frontières, SOURCE explicitement ouverte),Annie (audit parentSYS et rôles liés). Ils ne deviennent ni six SOURCE closes ni six nouvelles clôtures. Les douze traces restent partial_with_open_questions.
- Six candidats faute relecture SOURCE de clôture explicite retrouvée :Anivia,Ashe,Azir,Blitzcrank,Brand,Braum. Preuves historiques publiées conservées ; Ashe HUD72/72 est adjacent distinct. Manques/conditions précis par rôle dans la matrice ; absence de rapport ciblé n'est pas absence globale de mécanique/asset. Aucun Plan,base,Goal,UI,registre protégé ou produit modifié.

## Reprise SYS-01.2-02 — V1183 Anivia PASSIF-SOURCE consommateur borné (2026-11-03)

- Un audit borné clos : AUD-SYS-01.2-02-ANIVIA-PASSIF-SOURCE-CONSUMER-01, rapport docs/AUDIT_SYS01202_ANIVIA_PASSIF_SOURCE_CONSUMER_2026-11-03.md, reçus E:/mapslol3v3/audit_sys01202_anivia_passive_source_20261103. Intégration : 14/14 cohérences ; aucune tâche SOURCE, inconnue ou fonctionnalité close. CH-Anivia-PASSIF-SOURCE reste a_qualifier, sa trace partial_with_open_questions, OLU-171a3812-c5d0-5548-8b36-71d54f430648 ouverte.
- Huit champs du contrat courant inchangés depuis V558. Identité/prérequis et six packages du lot restent non acceptés ou non qualifiés dans cette frontière. Les 18 identités natives V558→V1182 sont réutilisées sans rehash/décodage ; 21 fichiers courants inchangés, 20 ancres historiques + 6 SOURCE conformes. Les lecteurs SOURCE restent distincts d'un producteur Rebirth ; le chemin létal/mort/retour fontaine ordinaire est lu, sans Rebirth qualifié dans le périmètre inspecté.
- Infobulle native : œuf, plein PV, f1, 6 s et 4 min ; ces textes restent distincts de la politique serveur non démontrée. NEWTABLE pc16 n'est pas corruption, priorité 8 n'est pas callback, niveaux Egg 1/4/7 non adoptés. Le retour local 16 s/480 ticks à 30 Hz n'est pas la survie d'œuf 6 s. Les 960 ticks et 32 refus V558 restent datés, non rejoués ; aucun runtime, décodeur, REA ou build actuel.
- Provenance 086d clarifiée : SHA de OLS-f3ac7341-02b5-52fe-9d1d-89735b3b3e1d, JSON miroir LeagueSandbox-Default de 7556 B, explicitement dérivé de OLS-621265ef-9b55-5c59-a12f-80dcec45ce41 natif 7ed25b17. Le chemin logique INIBIN et le SHA du miroir désignent des types distincts, sans preuve de corruption. Les quatre lecteurs directs consomment type, pas resource/source_sha256 ; producteur exact du JSON local non établi, aucune enquête identique à relancer.
- Les corrections documentaires réutilisent SOURCE/SIMULATION-CONTRAT/SIMULATION avec critères nominal létal→œuf→survie, limites temporelles, indisponibilité et preuve primaire à obtenir. Aucun registre, Plan, Goal, UI, base, produit ou asset modifié. V1182 reste historique ; sa candidature Anivia possède désormais cette relecture bornée, sa fiche SOURCE reste ouverte.
- Reprise observée au début du lot : branche main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications locales antérieures conservées. Relevé en lecture seule : E:/mapslol3v3/resume_sys01202_20261103_v1182.txt.

## Reprise SYS-01.2-02 — V1184 Ashe PASSIF-SOURCE consommateur borné (2026-11-03)

- Une unité bornée close : AUD-SYS-01.2-02-ASHE-PASSIF-SOURCE-CONSUMER-01 ; rapport docs/AUDIT_SYS01202_ASHE_PASSIF_SOURCE_CONSUMER_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_ashe_passive_source_20261103. Intégration 14/14 cohérences ; zéro tâche SOURCE, inconnue ou fonctionnalité close. CH-Ashe-PASSIF-SOURCE reste a_qualifier, trace partial_with_open_questions, OLU-b31a9a69-0c7d-527e-9685-415f3d9cfc46 ouverte.
- V537 cible seulement SIMULATION-CONTRAT/SIMULATION ; Tryndamere et ses questions restent exclus. HUD V1174 72/72 reste adjacent distinct. Six relations natives SOURCE représentent quatre fichiers distincts ; les neuf identités HUD et le font sont réutilisés avec leur recoupement, sans nouveau rehash/décodage natif. Texte Focus : aucune attaque 3 s, @f1@ charges/s, seuil 100, charges initiales égales à chance critique ; unité/taux/ordre et ancien rawDesc différent conservés inconnus ou distincts.
- Chaîne actuelle chance → échantillonneur → cache → lancement projectile → impact relue : 14/14 pins V537, 10 ancres V537 + 6 CID SOURCE conformes. Aucun producteur Focus qualifié dans les corps inspectés ; probabilité >=1 n'est pas 100 charges, effacement attack_roll n'est pas reset Focus, lancement n'est pas impact. Recherche exacte de huit corps nommés : zéro hit, code1 attendu ; aucun nouveau scan HUD. Anciennes attentes Ashe 90/900/5400 ticks non rejouées, zéro chance n'est pas absence ou test Focus100.
- Contrat courant/prérequis gardés ouverts ; SOURCE/CONTRAT/SIM réutilisés avec critères nominaux et limites précis. Snapshot immuable de préparation122 SOURCE/1350 contrats, deux inputs et extracteur épinglés : zéro audit global clos. En cas de dérive, nouveau snapshot versionné, ne pas relancer dans le dossier de preuve. Provenance resource hash Stats JSON déjà résolue V537, aucun nouveau défaut de hash.
- Aucun registre, code, asset, Goal, Plan, UI, application ou base modifié. Reprise Git consignée dans E:/mapslol3v3/resume_sys01202_20261103_v1183.txt : main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications antérieures conservées ; aucun acte Git dans ce lot. Matrice V1182 historique inchangée ; sa candidature Ashe a désormais cette relecture bornée, pas une SOURCE complète.

## Reprise SYS-01.2-02 — V1185 Azir PASSIF-SOURCE deux branches (2026-11-03)

- Un audit borné clos : AUD-SYS-01.2-02-AZIR-PASSIF-SOURCE-CONSUMER-01, rapport docs/AUDIT_SYS01202_AZIR_PASSIF_SOURCE_CONSUMER_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_azir_passive_source_20261103. Intégration 14/14 cohérences ; zéro tâche SOURCE, inconnue ou fonctionnalité close. CH-Azir-PASSIF-SOURCE reste a_qualifier, trace partial_with_open_questions, OLU-eac5b3b2-6c9e-5d8d-a11b-83ec748e7c9b ouverte.
- Sources : 23 membres V559→V1182 réutilisés sans rehash/décodage ; SOURCE actuelle 29 relations/24 identités, dont CharScriptAzir.luaobj à la racine déjà connu, distinct du sous-dossier Scripts absent localement. Onze Lua, huit limites NEWTABLE non corruption, cinq preloads ; TowerClicker 1/4/7 non adopté comme rangs Azir. Deux bindings : taux écrit 1,25 %AS/1 %CDR et SunDisc 3 min/1 min/exclusions ; f1 est le bonus AS courant affiché, pas un taux d'accumulation.
- Deux branches courantes séparées : CDR exposée mais pas de terme CDR→AS dans le dénominateur inspecté ; picking/handlers/config27définitions+Tibbers/spawn/mort/tick ne qualifient pas l'activation SunDisc. Tibbers, structure morte et spawn générique ne sont pas SunDisc ; aucune absence d'assets natifs inférée. 21/21 pins V559, 24 ancres V559 + 6 SOURCE conformes ; requête unique huit Rust + mondeJSON, zéro hit attendu, pas scan global.
- V559 reste daté : trois cas 58/58/50 ticks, 18 impacts et 51 refus, non rejoués ; pas de GUI/activation SunDisc. Taux/texte natif ne qualifie pas unités, plafond, ordre ou politique serveur ; CDR et AS d'objet restent des contrôles distincts. Corrections SOURCE/CONTRAT/SIM précisent les deux trajets et critères sans nouveaux IDs. Prérequis identité/packages et disponibilité restent ouverts.
- Contrat réemployé du cache immuable122/1350 avec deux SHA d'entrée vérifiés, zéro parsing brut ; aucune clôture globale. Matrice V1182 historique inchangée, candidature Azir désormais relue bornément. Aucun registre, code, asset, Goal, Plan, UI ou base modifié. Reprise Git root E:/mapslol3v3/resume_sys01202_20261103_v1184.txt : main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications antérieures conservées ; aucun acte Git du lot.

## Reprise SYS-01.2-02 — V1186 Blitzcrank PASSIF-SOURCE consommateur borné (2026-11-03)

- Un audit borné clos : AUD-SYS-01.2-02-BLITZCRANK-PASSIF-SOURCE-CONSUMER-01, rapport docs/AUDIT_SYS01202_BLITZCRANK_PASSIF_SOURCE_CONSUMER_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_blitzcrank_passive_source_20261103. Intégration 15/15 cohérences ; zéro tâche SOURCE, inconnue ou fonctionnalité close. CH-Blitzcrank-PASSIF-SOURCE reste a_qualifier, trace partial_with_open_questions, OLU-9d0518cb-b11f-5c9d-913f-309518d1521f ouverte. Audit global ouvert.
- Douze membres natifs V544→V1182 réutilisés sans rehash/décodage ; SOURCE courante 15 relations/12 identités, les mêmes 12 non additionnées. Icon2263 : sous 20 %PV, 50 %mana courant, jusqu’à 10 s, 90 s. Priorité 8 littérale distincte d’un callback ; NEWTABLE pc8 ne prouve pas une corruption. Anciens Alistar/+400/+600PV/6-12-18 et quatre NightmareBot non adoptés. Serveur, disponibilité/niveaux/égalité/ordre/timers/mort restent ouverts.
- Dix frontières V544 et six CID SOURCE conformes, 17/17 pins V544 ; intersections Azir12/Anivia16/Ashe12 inchangées. Chaîne réelle Attack→dégâts→boucliers déjà présents→PV, API serveur grant_shield, tick/régénération/capacité et mort/retour lus. Aucun producteur ManaBarrier qualifié dans ces corps ; une requête neuf Rust nommés, zéro hit/code1, pas d’absence globale inférée. Refus lus statiquement, non invoqués.
- Runtime V544 du 25 octobre non rejoué : onze frappes→tick1321, 24.79 %→16.81 %PV sans bouclier. Témoin artificiel après passage 100PV/300ticks absorbe 46.5348 au1369 et expire1621 ; pas le passif, pas une formule 50 %mana ou preuve de durée native10s/ordre priorité8. Six Attack+cinq grant API : onze refus historiques, zéro nouveau test. Mana ancien plein267.2 non discriminant courant/max ; futur cas avec mana réellement entamé requis.
- Contrats SOURCE/SIMULATION-CONTRAT/SIMULATION réutilisés, critères précis autour de20%/égalité/hit franchissant, ordre/initialisation/niveaux/10s90s/mort/réactivation/refus. Cache 122 SOURCE/1350 contrats immuable, deux SHA inputs vérifiés, zéro parsing brut/audit global clos. Identité/packages ouverts, matrice V1182 historique inchangée ; candidature Blitzcrank désormais relue bornément. Une indétermination bornée termine l’audit, pas automatiquement SOURCE.
- Aucun registre, code, asset, Goal, Plan, UI, application ou base modifié. Reprise Git readonly E:/mapslol3v3/resume_sys01202_20261103_v1185.txt : main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications locales antérieures préservées ; aucun acte Git du lot.

## Reprise SYS-01.2-02 — V1187 Brand PASSIF-SOURCE consommateur borné (2026-11-03)

- Un audit borné clos : AUD-SYS-01.2-02-BRAND-PASSIF-SOURCE-CONSUMER-01, rapport docs/AUDIT_SYS01202_BRAND_PASSIF_SOURCE_CONSUMER_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_brand_passive_source_20261103. Intégration15/15cohérences ; zéro tâche SOURCE, inconnue ou fonctionnalité close. CH-Brand-PASSIF-SOURCE reste a_qualifier, trace partial_with_open_questions, OLU-445a4e9f-c64b-541f-9174-670863dbc4bc ouverte, goal global ouvert.
- Seize membres natifs V659→V1182 réutilisés sans rehash/décodage ; SOURCE19relations/16identités, les mêmes16 non additionnées. BrandBlaze natif=Q/Sear, Blaze affiché=passif, BrandAblaze=état. Texte8%PVmax magiques sur4s/plafond monstre annoncé80/s et Q2s/W+25%/Epropagation/Rchampions au rebond suivant conservés ; premier tick/bornes/PVmaxdynamiques/arrondis/cumul/refresh/plafond-mitigation/ordre restent ouverts.
- BrandAblaze.luaobj/preload présents : premier échec V659 sur fausse absence conservé, inspection presencechecked corrigée jamais rejouée. SpellData tooltip absent du font exact distinct du BuffData valide ; coefficient0.65/80..240/range25000 Q-like non adopté comme formule passive. 19Lua0prototypeenfant/9NEWTABLE datés, DDF absent seulement du périmètre ; persistance/Runspeed et chunks Sound/Zombie vides ne prouvent aucun effet actif.
- 26pins courants conformes V659,22frontières+6SOURCE,30fenêtres ; requête unique15Rust nommés0hit/code1 sans absence globale. DispatchLearn/Cast/CastAtBrand refusé dans les corps lus ; dégâts/mitigation/boucliers/PVmax/catégories/tick/mort/crédit/snapshot génériques ne qualifient aucun producteur Ablaze. IgniteTrue/GarenPhysical/AnnieQMagical distincts, aucun runtime exécuté.
- V659 du27octobre non rejoué :4casBrand/Annie1/18,4attaques ordinaires,8API40magiques,2AnnieQ,54Brand+16Annie=70refus publics+20API=90,9239ticks,6XPserveur ; dix horizons151ticks après ces témoins ne testent aucun déclencheur Brand éligible. no_direct_state_injection ne signifie pas sans événementsAPI/XP. Identité actuelle ne prouve pas le build ancien.
- SOURCE/SIMULATION-CONTRAT/SIMULATION réutilisés avec critères timing/PVmax/cap80/refresh/cumul/multi-sources/protections/mort/QWER et vrais déclencheurs. Disponibilité historique doit être décidée sur preuve pour terminer SOURCE ; indétermination bornée termine seulement cet audit. Cache122/1350 immuable, deuxSHAinputs vérifiés,0parsingbrut ; identité/packages ouverts, matriceV1182inchangée, candidature Brand relue bornément.
- Aucun registre, code, asset, Goal, Plan, UI, application ou base modifié. Reprise Git readonly E:/mapslol3v3/resume_sys01202_20261103_v1186.txt : main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, changements locaux antérieurs conservés ; aucun acte Git du lot.


## Reprise SYS-01.2-02 — V1188 Braum PASSIF-SOURCE consommateur borné

Audit AUD-SYS-01.2-02-BRAUM-PASSIF-SOURCE-CONSUMER-01 terminé pour sa liaison documentaire bornée : 1 audit, 0 SOURCE/0 inconnue/0 fonctionnalité close. CH-Braum-PASSIF-SOURCE reste a_qualifier, trace partial_with_open_questions, OLU-8cb29ec4-39dd-5c76-bda8-21d2486314dc ouverte ; disponibilité historique indéterminée, prérequis IDENTITE non accepté. Implémentation/vérification/acceptation humaine restent distinctes.

Rapport : docs/AUDIT_SYS01202_BRAUM_PASSIF_SOURCE_CONSUMER_2026-11-03.md. Stage : E:/mapslol3v3/audit_sys01202_braum_passive_source_20261103. Natif13/13 et intégration15/15 : 26 identités V660 réutilisées contre l’extrait daté313 ; 32 relations SOURCE/26identités, 78associations sur3destinataires. Courant : 28fichiers conformes V660,22frontières+6CID SOURCE/27sites,33fenêtres ; aucun producteur Braum qualifié dans les corps nommés. F1/f2/f3/f5, Q, expiration/immunité et interactions restent ouverts.

Diagnostic V660 conservé, non rejoué : 4cas Braum/Garen1/18,52coups/8quartets110ticks,92refus publics+28API,14809ticks,10XP. API40magiques/stun60ticks distincts du passif ; attente121ticks sans proc ne qualifie pas expiration/immunité. Aucun runtime/build/décodeur/REA/rehash natif, ancien collecteur ni gros parsing ; Goal/Plan/UI/DB/produit/registres inchangés.

Les six candidats V1182 initiaux ont désormais une relecture bornée ; zéro SOURCE complète close, matrice historique conservée. Prochaine étape : consolidation de couverture par deltas réutilisés après préflight explicite ; pas de septième candidat arbitraire. Voir HANDOFF pour reprise.


## Reprise SYS-01.2-02 — V1189 consolidation du delta V1167–V1188

Consolidation documentaire bornée : 22 versions, 27 entrées nommées ; 24 audits source→consommateur hérités, une revue famille CDR V1181, une consolidation V1182 et une investigation P15. Base V1166 : 19 IDs source→consommateur ; union sélectionnée vérifiée 43 IDs distincts, sans intersection. Les deux entrées couverture/consolidation et trois investigations d’outillage base+P15 restent séparées. Aucun dénominateur global ni pourcentage ; zéro nouvel audit source→consommateur, SOURCE complète, inconnue ou fonctionnalité close par V1189.

Réemploi3137/V1180 dans V1181 sans double addition ; six anciennes clôtures V1182 non recomptées. Six candidats V1182 désormais relus V1183–V1188, matrice historique immuable, tâches SOURCE/SCOPE et prérequis toujours ouverts. V1181 conserve PASS212/212 sans verdict final explicitement clos dans le rapport. Sources/code/runtime sous-jacents non requalifiés ; contrôles documentaires seulement.

Rapport : docs/AUDIT_SYS01202_COVERAGE_DELTA_V1189_2026-11-03.md. Stage E:/mapslol3v3/audit_sys01202_coverage_delta_v1189_20261103 : coverage_delta_inventory.json, result.json et preuves réemployées. Prochain préflight : V667,122 PASSIF-PRESENTATION-ANIMATION/dix frontières ; vérifier pins code et corps, puis sept rubriques déjà satisfaites avant complément borné. Aucun122audits/features clos, rehash global ou replay identique. Goal/Plan/UI/DB/produit/registres inchangés ; SYS-01.2-02 ouvert.


## Reprise SYS-01.2-02 — V1190 réemploi du périmètre partagé animation V667

Un périmètre partagé V667 acquis réutilisé ;122 exigences PASSIF-PRESENTATION-ANIMATION examinées dans ce cadre limité, pas122 audits. Zéro nouvel audit source→consommateur/historique/fonctionnel, SOURCE, tâche ANIMATION, inconnue ou feature close. Deux fichiers code aux pins V667, dix ancres exactes et deux manifestes include_str identiques ;122 clés champions/42 monde/0 collision. Les entrées compilables sont identifiées, aucun binaire/runtime qualifié. Modèles122/clips4267/graphes121/memberships4450 et29contrôles/22refus restent hérités non rejoués ; questions/statuts historiques non rafraîchis.

Matrice122 : contrats courants a_faire, implementation_complete=false, acceptance_complete=false, required=true ; dépendance NETWORK exacte,118 a_implementer_ou_integrer +4 partiel_a_terminer (Annie,Ezreal,Garen,Trundle). Corrections réutilisées sous leurs IDs existants, aucune implémentation. Aatrox/Karthus,Lucian28vs7,Nautilus,Zac,Renekton conservés ;préload≠callback ;HUD Ezreal exclu des animations squelettiques.

Rapport : docs/AUDIT_SYS01202_PASSIVE_ANIMATION_REUSE_V1190_2026-11-03.md. Stage E:/mapslol3v3/audit_sys01202_passive_animation_family_20261103 : source_contract_review.json,current_consumer_review.json,manifest_consumer_inputs.json,result.json. Prochain préflight borné : les122 dépendances PASSIF-NETWORK, matrice120 V666 + Aatrox V664/Ezreal V665, même cache1350 ;sept rubriques/consommateurs acquis d’abord, pas122clôtures ni nouveau runtime UDP. V668 concerne Annie VFX seule, aucun replay1277assets. SYS-01.2-02 ouvert ;Goal/Plan/UI/DB/produit/registres inchangés.


## Reprise SYS-01.2-02 — V1191 réemploi des périmètres réseau V664/V665/V666

Trois périmètres documentés V664 Aatrox/V665 Ezreal/V666 matrice120 réutilisés ;une revue actuelle de famille,122exigences examinées limitées,0nouvel audit/SOURCE/NETWORK/inconnue/feature close. Partition120+1+1 exacte.375associations natives/374OLSuniques hérités datés nonlive ;questions/OLF historiques sans refresh. Cache1350,réseau118àimplémenter+4partiels Annie/Ezreal/Garen/Trundle,tous implementation_complete/acceptance_complete=false. Six requires_packages conservés ;projectionAatroxvide déjà corrigée. Deux actual_task old présents,120absents noninventés.

86CIDajoutés/59sites/60needles/25fichiers/2109liens ;avec chargeurchampion_catalog lib149 retenu87CID/60sites/2231liens.31sources courantes,89comparaisonscode+36comparaisons12inputscompilation exactes ;aucunbinaireold qualifié. V6661209/1199/10JSON+2RUN101 conservés,decodef32exact ;V66422états/16refus/3clients,480ticksordinary≠BloodWell ;V66577états/4cas/12clients,180ticksLOCAL,3RUN101E. Aucunruntime/UDP/build/schema testrejoué.

Rapport :docs/AUDIT_SYS01202_PASSIVE_NETWORK_REUSE_V1191_2026-11-03.md. Stage E:/mapslol3v3/audit_sys01202_passive_network_family_20261103 :source_contract_review.json,current_consumer_review.json,result.json. Prochaincandidat àpréflight:AUDIOV670122fiches,244liensbanques,0consumerajouté ;lire reçu553891B,puisconsumer réel/absencebornée,banques≠auditclos. SYS-01.2-02 ouvert ;Goal/Plan/UI/DB/produit/registres inchangés.


## Reprise SYS-01.2-02 — V1192 frontière de routage audio des passifs

Unité AUD-SYS-01.2-02-PASSIVE-AUDIO-ROUTING-BOUNDARY-01 : un audit statique partagé proposé à la clôture root après relecture indépendante. V670 availability : un périmètre réutilisé, zéro nouvel audit availability. 122 exigences examinées ; zéro audit individuel/SOURCE/AUDIO/inconnue/feature/acceptation clos. 244 banques/633 fichiers natifs/4455 occurrences/8243 médias/124 eventbanks/75338 IDs hérités ; 10 contrôles/8 refus du lecteur V670 non rejoués, distincts de wwiser. Matrice 122 exacte, tous a_faire/implementation_complete=false/acceptance_complete=false ; dépendances/packages/prérequis concordants. OLF/OLU/OLC historiques, anciens champs absents non inventés.

NativeApplication est attachée à l’App normale (main:607–640/1735–1744). Service.attach retire le standalone et configure ServiceHandle canonique ; callbacks register/unregister et stockage pending/active existent. Le refus standalone ne qualifie pas ce backend. La limite canonique précise est ConsumerBoundary::actor_call ; receive_game_event existe mais exige le manager, non initialisé par configure_service. Aucun appel de ce pont n’est identifié dans les corps startup 607–891/Match receive 969–1350 examinés ; autres contextes non qualifiés. Deux addenda suppléent la revue initiale conservée intacte.

Quatre consommateurs Ezreal Q/E/R PCM existent : Q/R ont une enveloppe version 1, E policy=local_e_committed_blink_points_v1/events. Map : trois signaux fixes ; AmbientPlayer cinq TT vers requêtes logiques backend_available=false ; Annie quads/Ezreal passive HUD n’établissent pas d’audio. APIs core post/seek/sélection/acteurs/PCM présentes ; pont passif natif→événement→lecture admise non établi dans le chemin examiné, sans absence globale du moteur. Game.cfg effectif inconnu, loader non appelé ; StunReady sans Sound ne prouve pas un silence historique.

Rapport : docs/AUDIT_SYS01202_PASSIVE_AUDIO_ROUTING_V1192_2026-11-03.md. Stage E:/mapslol3v3/audit_sys01202_passive_audio_family_20261103 : source_contract_review.json, current_consumer_review.json, current_consumer_inputs_addendum.json, current_consumer_canonical_backend_addendum.json, result.json. Réutiliser les 122 IDs AUDIO ; reprendre un passif nommé sur événement scoped par banque + conditions/audience/arrêt + médias validés + producteur autoritaire→consumer, avec primaire précise ou changement vérifié. Aucun son inventé, pas de replay banques/wwiser/runtime/écoute. SYS-01.2-02 ouvert ; Goal/Plan/UI/DB/produit/registres inchangés.


## Reprise SYS-01.2-02 — V1194 Aatrox passif HUD icône et état

Un audit statique borné AUD-SYS-01.2-02-AATROX-PASSIF-HUD-ICON-STATE-LINK-01 proposé à clôture racine après relecture indépendante. Sources25/25 et consommateurs22/22 ; deux DDS2176B/membre0.0.0.166 identifiés sans nouveauOLS, cinq textes en_GB et métadonnéesV456 réutilisées. Death/Ready et Disintegrate conservés sans règle serveur inventée. Backend HUD normal présent, aucune liaison passive Aatrox identifiée dans les sélecteurs inspectés ; BloodWell nonMana réutilise V78 sans nouvelle clôture de ressource. Recherche1219Rust/trois hits tests ; corps/appels/configurations également examinés.

Rapport docs/AUDIT_SYS01202_AATROX_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ; preuves E:/mapslol3v3/audit_sys01202_aatrox_passive_hud_20261103. HUD CH-Aatrox-PASSIF-PRESENTATION-HUD, NETWORK, SOURCE, OLU-8e0eb136-26d1-56e4-82ad-dc2b2b854d2c et acceptation restent ouverts. Aucun runtime/build/REA, Goal/Plan/UI/base/registre/code/asset modifié. Deux DDS ouverts exploration puis producteur source ; aucun natif rehaché à publication.


## Reprise SYS-01.2-02 — V1195 Akali passif HUD icône et état

Une unité bornée AUD-SYS-01.2-02-AKALI-PASSIF-HUD-ICON-STATE-LINK-01 proposée à clôture racine après relecture/publication. Reçus sources28/28 et consommateurs20/20 ;16 empreintes/29 fenêtres communes identiques, inventaire1219 chemins sans nouveau census contenu. Deux DDS5048B, membre0.0.0.25, identifiés sans nouveauOLS ;13 identitésV557 et cinq textes en_GB réutilisés. TwinDisciplines.dds et33.dds restent distincts ;copies de manifeste ne qualifient ni resolver ni fallback.

Backend normal et QWER Akali présents ;aucun binding passif identifié dans les sélecteurs inspectés. Energy/Mana-only reprend V78, pas un nouvel audit ressource. f1/f2/SourceName/rang/états/audiences/rendu restent ouverts. CH-Akali-PASSIF-PRESENTATION-HUD, NETWORK/SOURCE et OLU-0a2755ab-a964-5df7-a493-73c993c21d99 non clos. Rapport docs/AUDIT_SYS01202_AKALI_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_akali_passive_hud_20261103. Reçu publication_receipt.json et postpublication_verification.json font foi de la décision racine après publication. Aucun Goal/Plan/UI/DB/registre/produit/asset changé, build/runtime/REA exécuté.


## Reprise SYS-01.2-02 — V1196 Alistar passif HUD icône et état

Unité bornée AUD-SYS-01.2-02-ALISTAR-PASSIF-HUD-ICON-STATE-LINK-01 proposée à clôture racine après relecture/publication. Sources28/28, consommateurs20/20 ;16 empreintes et29 fenêtres communes identiques. Inventaire1219 chemins hérité V1195 sans nouveau recensement. Huit identitésV552 réutilisées ;deux DDS8448B même basename mais contenus différents, membres0.0.1.7/0.0.0.25, sans priorité choisie. Quatre textes en_GB ;f1/f2/f3/SourceName et rang non qualifiés.

Mana ordinaire et QWER Alistar présents, aucun binding passif identifié dans les sélecteurs inspectés. Colossal Strength/Trample Buff, descriptions anciennes tourelle/HP/niveaux6/12/18 et effets monde restent distincts de règles serveur qualifiées. CH-Alistar-PASSIF-PRESENTATION-HUD, NETWORK/SOURCE et OLU-cfb5fee4-852c-5161-9aed-b046580e502b restent ouverts. Rapport docs/AUDIT_SYS01202_ALISTAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ;preuves E:/mapslol3v3/audit_sys01202_alistar_passive_hud_20261103. publication_receipt.json et postpublication_verification.json font foi après décision racine. Aucun Goal/Plan/UI/DB/registre/produit/asset changé, runtime/build/REA exécuté.


## Reprise SYS-01.2-02 — V1197 Amumu passif HUD icône et état

Une unité bornée AUD-SYS-01.2-02-AMUMU-PASSIF-HUD-ICON-STATE-LINK-01 proposée à clôture racine après relecture/publication. Sources30/30, consommateurs20/20 ;16pins/29fenêtres communs inchangés,9fichiers/16ancres V550 concordants.1219chemins hérités sans recensement. Deux DDS8448B,un contenu identique,membres0.0.0.40/0.0.0.25 sans priorité décidée. Huit identitésV550 et quatre textes en_GB réutilisés ;underscore/Self non sélectionnés.

HUD propriétaire et debuff éventuel de cible examinés sans binding Amumu identifié dans les branches bornées ;porteurs/audiences CursedTouch/Marker non attribués. Q/E/R admis,W unresolved pour priorité de candidats non qualifiée,icône/overlay omis sans refus global,aucune source W déclarée absente. CH-Amumu-PASSIF-PRESENTATION-HUD,NETWORK/SOURCE et OLU-8bf80e7e-a210-5377-b7f8-1f55f494fbeb restent ouverts. Rapport docs/AUDIT_SYS01202_AMUMU_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ;preuves E:/mapslol3v3/audit_sys01202_amumu_passive_hud_20261103. publication_receipt.json/postpublication_verification.json font foi après décision racine. Aucun Goal/Plan/UI/DB/registre/produit/asset changé,runtime/build/REA exécuté.


## Reprise SYS-01.2-02 — V1198 Anivia passif HUD icône et état

Unité bornée AUD-SYS-01.2-02-ANIVIA-PASSIF-HUD-ICON-STATE-LINK-01 proposée à clôture racine après relecture/publication. Sources35/35,consommateurs20/20 ;16pins/29fenêtres communs et12fichiers/20ancres V558 concordants,1219chemins hérités sans census. Six DDS25344B/deux contenus,Base/Charging ;six textes Anivia dans selected_four_strings etdeux AniviaEgg séparés. Dix-huit identitésV558 etV1183 réutilisées sans inspecteur ni origine086d rejoués.

QWER Anivia admis sans unresolved ;aucun binding Rebirth identifié dans les sélecteurs bornés. RespawnTimer et16s480ticks fontaine ne qualifient ni œuf6s ni recharge4min ;modèle AniviaEgg etclips non assimilés à états/rendu. CH-Anivia-PASSIF-PRESENTATION-HUD,NETWORK/SOURCE etOLU-1d114bd2-7513-5949-b4fb-e32548296682 restent ouverts. Rapport docs/AUDIT_SYS01202_ANIVIA_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ;preuves E:/mapslol3v3/audit_sys01202_anivia_passive_hud_20261103. publication_receipt.json/postpublication_verification.json font foi après décision racine. Aucun Goal/Plan/UI/DB/registre/produit/asset changé,runtime/build/REA exécuté.


## Reprise SYS-01.2-02 — V1199 Azir passif HUD icône et état

Une unité bornée AUD-SYS-01.2-02-AZIR-PASSIF-HUD-ICON-STATE-LINK-01 est proposée à clôture racine après relecture/publication. Sources 32/32, consommateurs 22/22 ; 16 pins/29 fenêtres communs et 21 entrées V1185 incluant 11 fichiers/24 ancres V559 concordent. Inventaire 1219 chemins hérité sans recensement. Un DDS 2176 octets qualifié documentaire, quatre textes en_GB et 23 identités V559 réutilisés ; root CharScript distinct expliquant SOURCE 29/24 et HUD deux relations.

CDR/cadence et états SunDisc examinés séparément : aucun fournisseur f1 ni binding HUD des deux branches identifié dans les corps bornés. Quatre lignes QWER Azir configurées ; stats/catégories boutique, tour/curseur/modèles et F3 ne remplacent pas ce lien. Huit limites NEWTABLE : constantes BuffName/Texture non promues en affectations/callbacks. CH-Azir-PASSIF-PRESENTATION-HUD, NETWORK/SOURCE et OLU-f5cf5452-bbda-5a77-8394-5a7e14933e41 restent ouverts. Rapport docs/AUDIT_SYS01202_AZIR_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ; preuves E:/mapslol3v3/audit_sys01202_azir_passive_hud_20261103. publication_receipt.json/postpublication_verification.json font foi après décision racine. Aucun Goal/Plan/UI/DB/registre/produit/asset changé ; aucun runtime/build/REA exécuté.


## Reprise SYS-01.2-02 — V1200 Blitzcrank passif HUD icône et état

Une unité bornée AUD-SYS-01.2-02-BLITZCRANK-PASSIF-HUD-ICON-STATE-LINK-01 est proposée à clôture racine après relecture/publication. Sources35/35,consommateurs23/23 ;16pins/29fenêtres et17entrées V1186 couvrant six fichiers/10ancres V544 concordent. Inventaire1219chemins hérité sans recensement. Trois DDS6528octets/deux contenus, cinq textes en_GB ;12identités V544 et SOURCE15/12 réutilisées, HUDune relation.

F3 agrégat shield et récapitulatif de mort normalement monté sont présents ; HP/Mana et transport générique ne fournissent pas les états ManaBarrier. Aucun binding spécifique identifié dans les sélecteurs bornés. QWER Blitzcrank configurés, aucune unresolved. Icon/Cooldown littéraux distingués de l’actif NEWTABLEpc8 ; constantes non transformées en affectations. CH-Blitzcrank-PASSIF-PRESENTATION-HUD,NETWORK/SOURCE etOLU-f804ef74-b559-5219-8c17-d7416fd08f47 restent ouverts. Rapport docs/AUDIT_SYS01202_BLITZCRANK_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md ;preuves E:/mapslol3v3/audit_sys01202_blitzcrank_passive_hud_20261103. publication_receipt.json/postpublication_verification.json font foi après décision racine. Aucun Goal/Plan/UI/DB/registre/produit/asset changé ;aucun runtime/build/REA exécuté.


## Reprise SYS-01.2-02 — V1201 Brand passif HUD icône et état

Audit borné AUD-SYS-01.2-02-BRAND-PASSIF-HUD-ICON-STATE-LINK-01 : sources 38/38, consommateurs 24/24 ; 16 pins/29 fenêtres communs, 26 entrées V1187 couvrant 11 fichiers/22 ancres V659, deux auxiliaires/11 fenêtres V1200 et un nouveau helper/4 fenêtres recap. Deux DDS identiques, quatre textes passif/état et quatre QWER contextuels ; SpellData BrandAblaze absent, BuffData présent. Seize identités natives/19 relations SOURCE réutilisées, sans transfert de clôture.

BrandBlaze est une déclaration d’icône passive valide et un nom Q distinct du binding ; le Q courant utilise BrandSear.dds. Aucun binding Blaze/Ablaze spécifique identifié dans les sélecteurs HUD lus. IsDeathRecapSource littéral ne fournit pas un mapper courant ; recap générique sans identité spell/buff/DoT. SourceName/rangs/audiences/états/rendu restent ouverts. CH-Brand-PASSIF-PRESENTATION-HUD + NETWORK et OLU-903fff0c-0796-543f-9d2a-4185b563167e inchangés.

Rapport docs/AUDIT_SYS01202_BRAND_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_brand_passive_hud_20261103 ; publication_receipt.json et postpublication_verification.json font foi de la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registre/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1202 Braum passif HUD icône et état

Audit borné AUD-SYS-01.2-02-BRAUM-PASSIF-HUD-ICON-STATE-LINK-01 : sources 43/43, consommateurs 24/24, 16 pins/29 fenêtres communs ; 28 entrées V1188 couvrant dix fichiers/22 ancres V660. Quatre DDS/8704 octets/trois contenus, sept textes passif/état et Q séparé ; MarkDiminish absent sans alias. V1188/V660 et 26 identités/32 relations SOURCE restent réutilisés, sans clôture SOURCE transférée.

Le HUD calcule un état à partir des stuns génériques, sous priorité unavailable→cooldown→rank0→!allowed→resource, via player_states/all_states/update/color ; aucun rendu ni proc Braum prouvé. Quatre QWER configurés, zéro unresolved ; aucun binding Braum compteur/marques/immunité/bonus identifié dans les sélecteurs lus. f1/f2/f3/f5/SourceName, rangs, audiences et rendu restent ouverts. CH-Braum-PASSIF-PRESENTATION-HUD + NETWORK et OLU-a8e19ab0-ba65-50a5-a198-9b7483e0d8e3 inchangés.

Rapport docs/AUDIT_SYS01202_BRAUM_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_braum_passive_hud_20261103 ; publication_receipt.json et postpublication_verification.json font foi de la décision racine. Une clôture bornée seulement, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1203 Caitlyn passif HUD icône et état

Audit borné AUD-SYS-01.2-02-CAITLYN-PASSIF-HUD-ICON-STATE-LINK-01 : sources 37/37, consommateurs 23/23 ; 16 pins/29 fenêtres communs, douze fichiers/22 ancres V560 et deux lecteurs/six ancres SOURCE exacts. Auxiliaires V1200 2/11 et V1202 1/2 réutilisés, deux configurations/quinze fenêtres supplémentaires. Quatre DDS/11488 octets/deux contenus et six textes ; quinze identités V560 datées réutilisées, SOURCE20/15 et HUD2, pas hash D frais inventé.

Primaire Caitlyn_Headshot.dds et Count/marker qualifiés ; Headshot2 reste candidate constante NEWTABLEpc4, missilepc0/CaitlynSkin06 distinct. f1 versus texte huit attaques, buisson×2,150%/250%,SourceName/rangs/audiences/persistance/rendu ouverts. Aucun binding Headshot spécifique identifié dans les sélecteurs courants ; critique, buisson, projectiles, QWER, Ezreal/Annie distincts. HUD+NETWORK et OLU-a01dba49-1d42-5f15-a09c-62300bef4103 inchangés.

Rapport docs/AUDIT_SYS01202_CAITLYN_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_caitlyn_passive_hud_20261103 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1204 Cassiopeia passif HUD icône et état

Audit borné AUD-SYS-01.2-02-CASSIOPEIA-PASSIF-HUD-ICON-STATE-LINK-01 : sources46/46, consommateurs24/24 ;16 pins/29 fenêtres communs, treize fichiers/25 ancres V661 et deux readers/six sites SOURCE exacts. Auxiliaires hérités V1200 2/11,V1202 2/3,V1203 2/9 ; six JSON/11 fenêtres sélectionnés. Six DDS/109992 octets/cinq contenus RGB32, douze clés présentes dont sept passif/paliers et deux absences séparées ;31identités V661 datées, SOURCE37/31 et HUD2, pas de hash D métadonnées frais inventé.

DeadlyCadence désigne ici Aspect of the Serpent, sans ancienne règle mana ni moderne. Ticker1..4 textures littérales mais ordre/seuils/audiences non qualifiés ; f1..f11 par-tooltip, f7 change de rôle entre Ticker2 et3/4. NoxiousBlastHaste et deux tooltips absents conservés ; DDFf1≠TwinFangf2. Aucun binding compteur/paliers identifié dans les sélecteurs lus ; AP/CDR objet/autel, soinAPI, AnnieQ et HP/Mana génériques distincts. HUD+NETWORK et OLU-f22d9879-6dd8-5b2d-bb23-7a3e5fdb7a85 inchangés.

Rapport docs/AUDIT_SYS01202_CASSIOPEIA_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md, preuves E:/mapslol3v3/audit_sys01202_cassiopeia_passive_hud_20261103 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1205 Chogath passif HUD icône et état

Audit borné AUD-SYS-01.2-02-CHOGATH-PASSIF-HUD-ICON-STATE-LINK-01 : sources 41/41, consommateurs31/31 ;16 pins/29 fenêtres communs, douze fichiers/17ancres V551 et deux readers/six sites SOURCE exacts. Le supplément Nov2 reste conservé mais ses17sites ne sont pas17fichiers uniques. Auxiliaires V1200 2/11,V1202 2/3,V1203 2/9,V1204 1/5 réutilisés ; deux JSON/sept fenêtres sélectionnés. Deux DDS8448octets/un contenu DXT5 et trois textes ; sept identités V551 datées, SOURCE10/7 et HUD1, aucun hash D métadonnées frais inventé.

Carnivore/GreenTerror_TailSpike déclarés valides, f1PV/f2mana et formule/niveaux/rang/audiences/états/rendu ouverts. Aucun binding spécifique identifié dans les sélecteurs lus ; HP/Mana/soin/régénération/niveau/Trundle génériques distincts. Fixture scale hors recherche.rs non comportementale. V166CSVskin02/provider et preloadBattlecast/lifesteal distincts, sans réouvrir cette branche. HUD+NETWORK et OLU-6f2493b3-0627-5c90-8023-21d84b7adfde inchangés.

Rapport docs/AUDIT_SYS01202_CHOGATH_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_chogath_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1206 Corki passif HUD icône et état

Audit borné AUD-SYS-01.2-02-CORKI-PASSIF-HUD-ICON-STATE-LINK-01 : sources49/49, consommateurs33/33 ;16pins/29fenêtres communs, onze fichiers/22sites V561 et deux readers/six sites SOURCE exacts. Auxiliaires V1200 2/11,V1201 1/3,V1202 2/3,V1203 2/9,V1204 1/2 réutilisés ; trois JSON/neuf fenêtres directes sélectionnés. Deux DDS8448octets/un contenu DXT5 et trois textes ; six identités V561 datées, SOURCE9/6 et HUD1, aucun hash D métadonnées frais inventé.

RapidReload affiche Hextech Shrapnel Shells :10%ADtotal vrai hors structures dans le texte, pas mécanisme exécuté. Annie et niveaux1/4/7/«10»/13/16 conservés non adoptés. Sept déclarations QWER/quatre primaires/trois variantes/0unresolved ; filtre InventoryIcon ne qualifie pas Big de R. True générique et recap agrégé présents sans binding RapidReload dans le scope ; rang/états/audiences/rendu ouverts. HUD+NETWORK et OLU-ff6bb908-82e8-5939-98b2-c2958d5f100b inchangés.

Rapport docs/AUDIT_SYS01202_CORKI_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_corki_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1207 Darius passif HUD icône et état

Audit borné AUD-SYS-01.2-02-DARIUS-PASSIF-HUD-ICON-STATE-LINK-01 : sources49/49, consommateurs37/37 ;16pins/29fenêtres communs, onze fichiers/22sites V562 et deux readers/six sites SOURCE exacts. Auxiliaires V1200 2/11,V1201 1/3,V1202 2/3,V1203 2/9,V1204 1/2,V1206 3/4 réutilisés ; sept helpers/sept fenêtres directes. Deux DDS11232octets/un contenu DXT5 et quatre textes ;14identités V562 datées,SOURCE20/14/HUD2, aucun hash D métadonnées frais inventé. Discovery284582B copiée exact E pour preloads, deux lectures documentaires journalisées, pas inspection native.

Hemo4.20 magique5s/cinqcumuls/5%MS parchampionensanglanté textuels ; f1/f2/SourceName/cadence/états/audiences/rendu ouverts. RawDeadlyVenom_Internal et descriptionsmana hérités conservés sansalias/adoption. Aucun binding Hemo dans les sélecteurs ; movement/bottes, IgniteTrue et recapMagical génériques distincts. HUD+NETWORK et OLU-a52c80e9-064d-5194-9a6b-8d29ba00df56 inchangés.

Rapport docs/AUDIT_SYS01202_DARIUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_darius_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1208 Diana passif HUD icône et état

Audit borné AUD-SYS-01.2-02-DIANA-PASSIF-HUD-ICON-STATE-LINK-01 : sources50/50, consommateurs38/38 ;16pins/29fenêtres communs, douze fichiers/24sites V563 et deux lecteurs/six sites SOURCE exacts. Un DDS2872octets/DXT1, trois clés uniques et deux bindings identiques ;13identités/quatreLua/deuxpreloads V563 datés. Copie documentaire DDS E issue de la lecture D de ce lot et discovery291999octets exacte ; pas rehash D des métadonnées ou corpus.

Moonsilver déclare ASf3/troisième coup magiquef1/f2, producteurs/compteur/états/rangs/audiences/rendu ouverts. CharScript natif vide, communautaire posture/animation distinct ; niveaux1/4/7 non adoptés. Quatre QWER primaires/une variante W/0unresolved, filtreInventoryIcon ne prouve pas variante activée. Aucun binding spécifique identifié ; ASobjet/AP/attaques physiques/recapMagical et compteursEzreal/Annie distincts. HUD+NETWORK et OLU-ec7f7012-65f7-537a-b0e6-0afd7ef61c4e inchangés.

Rapport docs/AUDIT_SYS01202_DIANA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_diana_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1209 Draven passif HUD icône et état

Audit borné AUD-SYS-01.2-02-DRAVEN-PASSIF-HUD-ICON-STATE-LINK-01 : sources59/59, consommateurs43/43 ;16pins/29fenêtres communs, treize fichiers/24sites V565 et deux lecteurs/six sites SOURCE exacts. Deux DDS9840octets/deux contenus distincts, cinq clés uniques/troisbindings dontQséparé ;13identités/cinqLua/deuxpreloads V565 datés. Captures DDS E issues des lectures D de ce lot, discovery303109octets exacte ; aucun rehash D des métadonnées ou corpus.

Adoration déclare charges/catch/or/perte de moitié ; f1/f2/f3/f4/SourceName, compteur/rangs/arrondi/lookup/audiences/rendu ouverts. Quatre Lua littéraux et SpinningNEWTABLEpc10 non pris en charge, pas corruption ; Q communautaire simplifié distinct. GoldStat portefeuille et récompenses ordinaires présents, aucun binding Adoration identifié. HUD+NETWORK et OLU-2be81c51-cf04-5516-ae53-0f4e9c673fde inchangés.

Rapport docs/AUDIT_SYS01202_DRAVEN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_draven_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1210 DrMundo passif HUD icône et état

Audit borné AUD-SYS-01.2-02-DRMUNDO-PASSIF-HUD-ICON-STATE-LINK-01 : sources59/59, consommateurs41/41 ;16pins/29fenêtres communs, sept fichiers/dix sites V542 et deux lecteurs/six sites SOURCE exacts. Trois DDS6528octets/un contenu, deux noms déclarés distincts ; six identités/deuxLua/un preload V542 datés. HUD une native relation définition ; pas de seconde relation CharScript inventée. Captures DDS E issues des lectures D de ce lot ; aucun rehash D des métadonnées ou corpus.

Nevershade/description annoncent0.3%maxHP/s ;0.003 conversion textuelle, pas cadence serveur. Passive1=1 et legacy20/30/40%dégâts sous40% non adoptés, facteur chaîne0/BaseHPRegen absent conservés. Base/Garen/Ignite/Trundle/heal et HPBar présents sans binding passif identifié ; rang/états/lookup/audiences/rendu ouverts, aucun compteur/cooldown inventé. HUD+NETWORK et OLU-3413cd34-3216-537d-8ce5-04ce0c3bb03d inchangés.

Rapport docs/AUDIT_SYS01202_DRMUNDO_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_drmundo_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1211 Elise passif HUD icône et état

Audit borné AUD-SYS-01.2-02-ELISE-PASSIF-HUD-ICON-STATE-LINK-01 : sources56/56, consommateurs43/43 ;16pins/29fenêtres communs, neuf fichiers/24sites V566 et deux lecteurs/six sites SOURCE exacts. Deux DDS10496octets/deux contenus, trois clés ;41identités/25Lua/sixpreloads V566 datés, SOURCE47/41/HUD2. Captures DDS E issues des lectures D de ce lot, discovery570981octets exacte ; aucun rehash D des métadonnées ou corpus.

Spider Swarm distingue réserve humaine, forme araignée et araignées vivantes ; f3/plafond/rangs/transitions/audiences/rendu ouverts. Spider1..5 pas cap5 ; legacyregen/Morgana/Swain/Akali/Twitch et marqueurR communautaire non adoptés. Aucun binding spécifique identifié ; unités/Tibbers, HP/Mana/QWER, Ezreal/Annie distincts. HUD+NETWORK et OLU-e5ddca43-ec81-56b3-ba47-35d53a66f378 inchangés.

Rapport docs/AUDIT_SYS01202_ELISE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_elise_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1212 Evelynn passif HUD icône et état

Audit borné AUD-SYS-01.2-02-EVELYNN-PASSIF-HUD-ICON-STATE-LINK-01 : sources70/70, consommateurs43/43 ;16pins/29fenêtres communs, onze fichiers/24sites V567 et deux lecteurs/six sites SOURCE exacts. Cinq DDS17064octets/quatre basenames/4contenus, six clés ;26identités/dixLua/dixpreloads V567 datés, HUDune relation native définition. Captures DDS E nouvelles et discovery403451octets exacte ; aucun rehash D des métadonnées ou corpus.

Shadow Walk décrit1%manaMAX et6s, proximité/vraievision/transition/composition inconnues ; ancienShadowWalkslot2 séparé deEvelynnW,SourceName et markupbrut conservés. Aucun binding spécifique identifié ; FOW/Ignite/projections et base/fontaine/MP génériques distincts. Rang/états/lookup/audiences/rendu ouverts. HUD+NETWORK et OLU-473304ed-b408-51bd-ba7b-90381582837d inchangés.

Rapport docs/AUDIT_SYS01202_EVELYNN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_evelynn_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1213 FiddleSticks passif HUD icône et état

Audit borné AUD-SYS-01.2-02-FIDDLESTICKS-PASSIF-HUD-ICON-STATE-LINK-01 : sources64/64, consommateurs44/44 ;16pins/29fenêtres communs, douze fichiers/24sites V568 et deux lecteurs/six sites SOURCE exacts. Deux DDS8448octets/un contenu, quatre clés dont description candidate sans liaison PassLev1Desc1 ; neuf identités retenues/troisLua/deuxpreloads V568 datés, HUDune relation native définition. Captures DDS E nouvelles et discovery343484octets exacte ; aucun rehash D des métadonnées ou corpus.

Dread décrit10MR retirée à la cible ; rayon/cumul/maintien/ordre/états/SourceName/audiences/rendu ouverts. ParanoiaMissChance pasmisschance ; Fearmonger/Drain/Nocturne exclus. Aucun binding spécifique identifié ; MRordinaire/objets/Annie/Exhaust/Trundle et pénétration source distincts. HUD+NETWORK et OLU-5f6cae13-d622-50c8-a146-1e90d84e06cf inchangés.

Rapport docs/AUDIT_SYS01202_FIDDLESTICKS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md, preuves E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_hud_20261104 ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1214 Fizz passif HUD icône et état

Audit borné AUD-SYS-01.2-02-FIZZ-PASSIF-HUD-ICON-STATE-LINK-01 : sources 63/63, consommateurs 49/49 ;16 fichiers/29 extraits communs,12 fichiers/28 sites V569 et deux lecteurs/six sites SOURCE comparés. 1 DDS/5616 octets/1 contenus ; sept identités/deux Lua/deux preloads V569 datés. Captures DDS E nouvelles, métadonnées et font D non relus.

Nimble Fighter : traversée et réduction physique des attaques reçues déclarées ; f1/niveaux/ordre/états/rang/audiences/rendu ouverts. DisplayIcon Seastone exclu ; littéraux MPregen non adoptés comme scaling. Aucun binding spécifique établi, mitigation par armure et traversée ennemie génériques séparées. HUD+NETWORK et OLU-effab10e-f7a3-563d-a253-3de05fd7a918 inchangés.

Rapport docs/AUDIT_SYS01202_FIZZ_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1215 Galio passif HUD icône et état

Audit borné AUD-SYS-01.2-02-GALIO-PASSIF-HUD-ICON-STATE-LINK-01 : sources 70/70, consommateurs 47/47 ;16 fichiers/29 extraits communs,4 fichiers/10 sites V546 et deux lecteurs/six sites SOURCE comparés. 2 DDS/5744 octets/1 contenus ; six identités/deux Lua/preload V546 datés. Captures DDS E nouvelles, métadonnées et font D non relus.

Runic Skin : texte lié50% de RM totale→AP ; f1/activation initiale/niveaux/rang/ordre/états/audiences/rendu ouverts. Ancien tiers armure/RM et valeurs9/3/7/11 non adoptés. Aucun binding spécifique établi ; APobjets/autels/MR et prédictions textuelles niveau1 séparés. HUD+NETWORK et OLU-e6f4c41a-d21a-5723-9668-fc6406015909 inchangés.

Rapport docs/AUDIT_SYS01202_GALIO_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun build/runtime/REA.


## Reprise SYS-01.2-02 — V1216 Gangplank passif HUD icône et état

Audit borné AUD-SYS-01.2-02-GANGPLANK-PASSIF-HUD-ICON-STATE-LINK-01 : sources 55/55, consommateurs 53/53 ; 16 fichiers/29 extraits communs, 13 fichiers/28 sites V570 et deux lecteurs/six sites SOURCE comparés. DDS : 1 chemins, 4224 octets, 1 contenus. Treize identités datées, cinq Lua/quatre littéraux ; Parley NEWTABLE pc12 reste une limite du lecteur. HUD : définition et CharScript, sans corps serveur original.

Scurvy propriétaire et ScurvyStrike cible/SourceName distincts du W. Texte 7%/3s/3cumuls ; f1/rangs/cadence/rafraîchissement/états/audiences/rendu ouverts, aucun21% inventé. Aucun binding spécifique établi ; attaques physiques et positifs Embrasement/Épuisement distincts. HUD+NETWORK et OLU-ab921547-33a6-549e-9658-20baa424746b inchangés.

Rapport docs/AUDIT_SYS01202_GANGPLANK_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json attestent la décision racine. Une clôture bornée, zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun nouveau build/runtime/REA.


## Reprise SYS-01.2-02 — V1217 Garen passif HUD icône et état

Audit borné AUD-SYS-01.2-02-GAREN-PASSIF-HUD-ICON-STATE-LINK-01 : sources49/49, consommateurs48/48 ;16fichiers/29extraits communs,11ancres Garen/six fichiers et neufSOURCE/quatre fichiers,unionhuit. Pas de baseline historique inventée ;31pins/20fenêtres directes. TroisDDS/9968octets/3contenus,mipbrut0/1/7 ; définition Garen_Passive et déclarations Passive/Cooldown distinctes. Cinq clés en_GB et ancien en_US séparés.

Préserver le vrai cœur partiel :heal/interrupt/règles,damage,Exhaust,TrundleE,champ sérialisé. UDP Oct3 niveau1/102samples/6checks hérité, pas binaire courant/HUD qualifié. Tiers secondaires4.17/statique10s et unités5s/persecond distincts. None immédiatement actif est un choix courant, pas une politique native prouvée. Liaison dédiée/transitions/substitutions ouvertes ;HUD+NETWORK/OLU-cdada9a0-36be-59bd-8695-4cbadf4dc9a9 inchangés.

Rapport docs/AUDIT_SYS01202_GAREN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md et preuves E:/mapslol3v3/audit_sys01202_garen_passive_hud_20261104 ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1218 Gragas passif HUD icône et état

Audit borné AUD-SYS-01.2-02-GRAGAS-PASSIF-HUD-ICON-STATE-LINK-01 : sources59/59, consommateurs51/51 ;16fichiers/29extraits communs,13fichiers/20ancres V573 et sixSOURCE sur troisfichiers.16pins/13fenêtres directes. DeuxDDS/8448octets/un contenu,DXT5/mip1 ;quatre clés en_GB,16identités datées/7Lua/6littéraux,WNEWTABLEpc16 pascorruption. HUD définition+CharScript sans corps serveur original.

HappyHour4%HPmax/8s déclaré,f1/éligibilitécast/recast/ordre/délai/mort/états/audiences/rendu ouverts. Casts Gragas refusés ne testent pas un déclenchement réussi. Generic heal/régénération et Soin90PV/240s(conflit300s) distincts. W/E sans texte pasfichiersabsents ;héritagesAlistar/400/600/10,QToggleFlashFrost etbuffsW nonadoptés. HUD+NETWORK/OLU-b5731afc-5408-5994-a7e8-a7a1a93bb3f9 inchangés.

Rapport docs/AUDIT_SYS01202_GRAGAS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1219 Graves passif HUD icône et état

Audit borné AUD-SYS-01.2-02-GRAVES-PASSIF-HUD-ICON-STATE-LINK-01 : sources65/65, consommateurs51/51 ;16fichiers/29extraits communs,13fichiers/22ancres V574 et sixSOURCE/troisfichiers.6pins/12fenêtres directes. DeuxDDS11232octets/deuxcontenus distincts,DXT5/mip7 ;cinq chaînes en_GB,quinzeidentités/sixLua/troispreloads/dixcommunity datés. HUD définition seule.

TrueGrit :incrément1s,cap10,combat décrit par dégâts3s ;f1 incrément etbonusaffiché restent deuxcontextes sansproducteur communprouvé.1966candidate sansbinding. AR/RMobjets etcontributionsassist ne sontpas étatcombat. Aucun binding spécifique établi ;aliasPineapple/Rumble,ShotAttack/FX etQuickdrawAS nonadoptés. HUD+NETWORK/OLU-ce71a40c-ced4-544e-adbc-fc0e9aad2e90 inchangés.

Rapport docs/AUDIT_SYS01202_GRAVES_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Originaux source stage/source_worker,trois miroirs canoniques source_worker vérifiés sansreplay. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1220 Hecarim passif HUD icône et état

Audit borné AUD-SYS-01.2-02-HECARIM-PASSIF-HUD-ICON-STATE-LINK-01 : sources60/60,consumer55/55 ;16fichiers/29extraits communs,V57515fichiers/29ancres etsixSOURCE/troisfichiers ;8pins/19fenêtres directes. DeuxDDS11232octets/1contenu(s),définition Hecarim_Passive et buffHecarim_Warpath distincts ;11identités/4Lua3littéraux/2bindings/2preloads/DDF16/8community datés,fontDnonrelu.

Warpath f1/f2 et basebonusvitesse/ordreplafonds/ghosting/niveaux/états/audiences/rendu ouverts. E/Ramp/DDFactifs etADobjets distincts. Alliée80=50+30navigation,pasbody80 ;passageennemi communGaren pasWarpath. Aucun binding spécifique établi. HUD+NETWORK/OLU-4b01f9ab-9275-58d4-9343-c55ab7795289 inchangés.

Rapport docs/AUDIT_SYS01202_HECARIM_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1221 Heimerdinger passif HUD icône et état

Audit borné AUD-SYS-01.2-02-HEIMERDINGER-PASSIF-HUD-ICON-STATE-LINK-01 :sources61/61,consommateurs58/58 ;16fichiers/29extraits communs,V57612fichiers/22ancres etSOURCE6sites/3fichiers ;9pins/20fenêtres directes. UnDDS2176B64x64DXT1/mip0,membre204 ;définition/source/recipient mêmebasename sanslookupprouvé ;10identités/3Lua/2bindings/2preloads/DDF16/8community datés,fontDnonrelu.

f1/portée/catégories/H28G/cumuls/lifecycle/états/audiences/rendu ouverts. Nom4376liéPassive1Name,affichagenonqualifié ;description4200 candidate,Passive1Desc/PassLev1Descnull ;sourcePersistsThroughDeathtrue,cibleabsentpasfalse. Garen/Tibbers/basegrowth/item1006 etmodificateurs reçus distincts. Aucunbinding spécifique établi ;HUD+NETWORK/OLU-66dc9221-fda2-583e-b13a-91be0062eef6 inchangés.9icônesQWER(4primaires/5variantes),1EInventoryIcon2unresolved conservé,pasabsencepassive. Préflighthealing48→45 avantcollecteur,puis2collecteurs(exit1attenduerronéunresolved0,exit0corrigé),archives exactes,pasruntime.

Rapport docs/AUDIT_SYS01202_HEIMERDINGER_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1222 Irelia passif HUD icône et état

Audit borné AUD-SYS-01.2-02-IRELIA-PASSIF-HUD-ICON-STATE-LINK-01 :sources59/59,consommateurs60/60 ;16fichiers/29extraits communs,V57711fichiers/27ancres etSOURCE4sites/2fichiers(3INIBIN+catalogue,pasLua),union12 ;8pins/19fenêtres directes. DeuxDDS5744B/1contenu,64DXT1/mip7/membre25 ;8identités/2Lua/1binding/2preloads/DDF4R/7community datés,fontDnonrelu.

Nom/description liésparPassive1Name/PassLev1Desc1,autrehashPassive1Descnull. VoracitydistinctpreloadIonianDuelist,pasKatarinaadopté.10/25/40%déclarés,f1/portée/comptage/CCeligibles/4+ennemis/lifecycle/états/audiences/rendu ouverts. control_duration litcourage_until etceil(raw*.7),pasgardechampiondirecte ;producteurpublicGaren distinct. disabled_cast_rules localpasimmuniténative. HUD+NETWORK/OLU-48dcdb33-39a7-5156-a648-61ccbc4c7889 inchangés. Source57/58premiermatcherclassevide,puisregexcorrigé59/59+49/49readback,scripts/logsarchivés,pasDreplay. Consumer1exec60/60+10/10relecture,préparateurs206/quotageSyntaxErroravantdémarrage,cheminprimairecorrigéavantcollecteurarchiveexacte.4QWER0variant0unresolved courant.

Rapport docs/AUDIT_SYS01202_IRELIA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1223 Janna passif HUD icône et état

Audit borné AUD-SYS-01.2-02-JANNA-PASSIF-HUD-ICON-STATE-LINK-01 :sources63/63,consommateurs60/60 ;16fichiers/29extraits communs,V57811fichiers/22ancres etSOURCE6sites/3fichiers(3INIBIN+2Lua+catalogue),union13 ;15pins/18fenêtres directes. DeuxDDS8448B/1contenu64DXT5/mip1,membres161/25distincts ;13identités/4Lua3littéraux/NEWTABLEpc18/3bindings/2preloads/DDF4W/10community datés,fontDnonrelu.

5%literal,pasf1passifinventé ;allalliésdescription4203vsnearby+JannaTailwindSelf2746nonrésolu. Sourcepersist/nonDispellabletrue,recipientabsentpasfalse. Passive1/levels1..4chaîne0,pasbonusnul/rangconnu,5/6absents ;Passive1Descvideautrehash,nom/PassLev1Desc1liés,AstralSpirtsnonadopté. W/Zephyr/Soin/bottes/plafondslocaux distincts. HUD+NETWORK/OLU-456910e6-474d-55b4-8f04-9556ad9f2262 inchangés. Source1prod63/63+43/43relecture,préflightbanhistoriqueaffinécheminsexacts sansscriptsmodifiés ;consumer1exec60/60+10/10,0retry,nomMDhéritécorrigéavantcréationcollecteur/assembleurarchivé,slows1..19complétéavantassemblage/prefixconservé.6QWER4primaires2variants0unresolved.

Rapport docs/AUDIT_SYS01202_JANNA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1224 JarvanIV passif HUD icône et état

Audit borné AUD-SYS-01.2-02-JARVANIV-PASSIF-HUD-ICON-STATE-LINK-01 :sources64/64,consommateurs63/63 ;16fichiers/29extraits communs,V57910fichiers/22ancres etSOURCE6sites3files,catalogue+INIBIN3+Lua2,union12 ;7pins/14fenêtres directes. DeuxDDS5744B/1contenu64DXT1mip7,membre25 ;3emanifestcandidateZyraGraspingPlantmember111nonlu,pasalias.13identités/4Lua3literal/NEWTABLEpc0/2bindings/2preloads/DDF20dont4passifsempties/9community datés,fontDnonrelu.

Texte10%PVactuelsphysicalmax400,f1secondesparcibleouvert ;sourcepersisttrue,cibleabsentpasfalse,rang6Nonepaspardéfaut,nom/PassLev1Desc1liés. LegacyYi/mana nonadoptés. ExtraSpellAnimationPassive/Cooldown0/FXidentiténequalifientpaslockout/rendu. Aucunbonus/verrouJarvanidentifiédanscorpsinspectés ;AD/1036/Garen/Trundledistincts. HUD+NETWORK/OLU-b8a86269-75fe-55c2-88af-b4ed6c21f531 inchangés. Capture2tentatives(v578refusavantcopies/payload→v579),source2producers(MDnomhéritérefusavantcontrôles→64/64)+52/52readback,archivesexactes. Consumer2exec1retry(62/63IDsOLF/OLUhérités→63/63)+10/10readback,4archivesexactes ;aucunDDS/VM/runtime/buildreplay.

Rapport docs/AUDIT_SYS01202_JARVANIV_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1225 Jax passif HUD icône et état

Audit borné AUD-SYS-01.2-02-JAX-PASSIF-HUD-ICON-STATE-LINK-01 :sources66/66,consommateurs66/66 ;16fichiers/29extraitscommuns,V58010files22sites44links3tasks+SOURCE6sites3filesunion12,V5385files8anchors16links ;12pins/21fenêtres directes. V58021natives/63relations,V53814/42,SOURCEunion22IDs/38relations. SixcontratsSEPTinconnues,OLU42e6eefaextraSIMULATIONonly(nonadoptéSOURCE/CONTRAT),V580compteur3→4historiqueconservé.

3DDS12672B2contenusMasterOfArms/CoupDeGrace64DXT5mip0member40/25,rôlesdifférentspréservés ;2homonymesmanifestMalphite/ShenNONLUS. f1%/2.5s/max6déclarés,producteur/cumuls/expiry/renduouverts. Rtroisièmehitmagique/défense etSpeedRelentlessBarrier distincts ;cléunderscoremanquantepasautoalias,nom/PassLev1Desc1liés/legacy9et3-7-11-15nonformule. Cadenceintegerround/min12et47/41seulsnequalifientpasnativeratefailure. HUD+NETWORK/OLU-5340db90-4062-50bd-b527-508578881dfa inchangés.

Préparations source/consumer archivées ;source-readback58/58,consumer-readback14/14hérité ;projection5aliasE-only16/16sansreplay,originauxbyte-exact.

Rapport docs/AUDIT_SYS01202_JAX_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche complète/feature/acceptation. Goal/Plan/UI/DB/registres/code du jeu/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1226 Jayce passif HUD icône et état

Reprise sur main / 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; 2213 entrées Git modifiées préservées.

Audit borné AUD-SYS-01.2-02-JAYCE-PASSIF-HUD-ICON-STATE-LINK-01 : sources 74/74, relecture E 55/55 ; consommateurs 58/58, relecture 10/10. V581 :37 identités natives/111 associations historiques,22 sites/11 fichiers ; SOURCE41relations/37IDs,sixsites/troisfichiers ; HUD2relations/2IDs. Six contrats HUD/NETWORK/SIMULATION/CONTRAT/SOURCE/ACCEPTANCE et six inconnues conservés. IcônesQWER8=4primaires+4variantes,zéro unresolved.

Deux DDS7792B Jayce_Passive/Summoner_haste ; nom déclaré JayceManOfTomorrow absent du manifeste et des sous-arbres ciblés Jayce/Spells, sans alias/absence globale/corruption/rendu déduits. Déclaration40speed/1.25s+unit-passing par Transform ; refus courant empêche son activation dans les cas hérités. GarenRecouperate/Apollo/Jarvan/Haste, formes et attaques chargées distincts. V5814speedcases70refus240ticks20steps +4occupancycases2extraTransformrefus=72 ; Heal/bottes/occupation65baseline nonpreuvepassif. V564 ouvert.

Source2producteurs/1correction agrégation3IDs/4liens ; consumer2collecteurs/1correction Transformgéométrique, 12hitsconservés. Originaux/journaux/contrôles échoués archivés avant révision, pas de recapture/replay.

Rapport docs/AUDIT_SYS01202_JAYCE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json et postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1227 Jinx passif HUD icône et état

Reprise main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2214entréesGitmodifiéespréservées. Audit borné AUD-SYS-01.2-02-JINX-PASSIF-HUD-ICON-STATE-LINK-01 : sources 65/65, E-readback61/61, consumer62/62, readback11/11. V58215nativeIDs/45associations,24sites/13files ; SOURCE21relations15IDs,sixsites3files ; HUD2relations2IDs. Sixcontrats HUD/NETWORK/SIM/CONTRAT/SOURCE/ACCEPTANCE et6inconnues conservés. QWER5=4primaires+1varianteQ,0unresolved.

3DDS8576B Jinx_Hidden/Jinx_Passive/Bowmaster_BullsEye ; rawBowmaster_Bullseyecassepréservée,2homonymesZyraNONLUS,pasalias/lookup/pixelsdéduits. Description4207explicitementrecherchée,PassLev1Desc1+6rankfieldsabsentspasdefault. Buffs2114/2115:175%decay4s aprèscontribution3s champion/tour/inhibiteur ;genericassist15s/QAS/social/rootpréload distincts. V5822publics48HPdropsavecprojectilestémoins4kills34refus720tails20steps,325/350sansaccélération,400/300rewards/ambientseparate ;AnnierespawnpasJinxbufflifecycle,assist/structuresnonexercés. V564ouvert,anciensincidentsstorageconservésinertessansreplay/nettoyage.

Source1producteur/1readback sanséchec ; consumer2préparationsarchivées avantunique collecteur62/62 etreadback11/11,0retry. Pasderecapture/runtime/build.

Rapport docs/AUDIT_SYS01202_JINX_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1228 Karma passif HUD icône et état

Reprise main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2215entréesGitmodifiéespréservées. Audit borné AUD-SYS-01.2-02-KARMA-PASSIF-HUD-ICON-STATE-LINK-01 : sources69/69,E-readback70/70,consumer64/64,readback10/10. V58312nativeIDs36associations,19sites/11files ; SOURCE16relations12IDs/sixsites3files,Hud1definition. SixcontractsHUD/NETWORK/SIM/CONTRAT/SOURCE/ACCEPTANCE6ownersconservés. QWER10=4primary6variantsQWE0unresolved.

UnDDS2176B Karma_Passive member155 ; KarmaInnerFlame déclarébuffnonretrouvémanifest/sous-arbresKarma/Spellsinspectés,pasalias/globalabsence/pixelsdéduits. Description4210bound/6rankfieldsabsents ;f1/f2refundunresolved,Mantralevel1withoutpoint/CD45-42-39-36s/window8sdistincts ;legacyHPmana/SpellData8-7-6-5/effectarrays/Chakra30-25-20chargesnonadoptés.4Lua3literal1NEWTABLEpc6,CharScriptLuaglobalspersist/nondispellabletruepasvide,communityCSvide. V5832Karma12physicalhitswitness34refus180tails,ranks/CDzeros,noarmedMantra ;2GarenQCDR240/216ticks2refus180tailsdistincts,total36refus360ticks. ZéroCDsansMantraactivénequalifiepasrefundfailure/amount. Ezrealrefund/GarenCDRpréservés,V564ouvert.

Sourceuniqueproducer69/read70E etconsumeruniquecollector64/read10,0échec/correction/retry. Source34inputs10F àcontrôlerroot ; composantsgelésinchangés.

Rapport docs/AUDIT_SYS01202_KARMA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1229 Karthus passif HUD icône et état

Reprise main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2216entréesGitmodifiéespréservées. Audit borné AUD-SYS-01.2-02-KARTHUS-PASSIF-HUD-ICON-STATE-LINK-01 : sources64/64,E-readback74/74,consumer67/67,readback10/10. V58427nativeIDsordinaires81associations,21sites/11files ; SOURCE32relations27IDs/sixsites3files,Hud2relations. SixcontractsHUD/NETWORK/SIM/CONTRAT/SOURCE/ACCEPTANCE6owners. QWER4primaries0variants0unresolved.

UnDDSKarthus_Passive2176Bmember235,botLich_Defiednonlu/nonadopté. Death Defiedavecspaces,description4211bound/6rankfieldsabsents,5buffbindings4resolved1missingDefilesansautoaliasKarthusDefile.8Lua7literal1NEWTABLEpc12,8preloads,5candidatsabsentsV584inclDDF/exactKarthusDeathDefied,2NightmareBotexclus9community. NativeCharScriptglobalsvides/communityCSvide,pasglobalabsence. V5842base/RubyHP516/66631Annieprojectilewitnesshits2deaths164refus110dead960tails2respawns480ticks16s ;offsets0/1/209/210/211deadrefus,snapshotinchangé. Nativefreecasts7snonqualifiés,manastablesousrefuspasfreecostproof ;cycleordinairepasétatspirituel,V564ouvert.

Source2préparationsdeprojectionarchivées avantuniqueproducteur64/read74E,aucunéchec/retry/recapture. Consumeruniquecollector67/read10,0échec/correction/retry. Source38inputs10F àgaterroot.

Rapport docs/AUDIT_SYS01202_KARTHUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ; publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ; aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1230 Kassadin passif HUD icône et état

Reprise main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2217entréesGitmodifiéespréservées. Audit borné AUD-SYS-01.2-02-KASSADIN-PASSIF-HUD-ICON-STATE-LINK-01 :sources84/84,E-readback92/92,consumer74/74,readback10/10. V58513nativeIDs39associations,24sites/15files ;SOURCE16relations13IDs/sixsites3files,Hud1definition.6contractsHUD/NETWORK/SIM/CONTRAT/SOURCE/ACCEPTANCE6owners,QWER4primary0variants0unresolved.

4DDSpayloads16896B3contentsVoidwalkerchar/global/Kassadin_VoidStone/Teemo_EagleEye,members40/25 ;rawmip1pourVoidStonecontre0pourautres.2homonymesTeemoKennen/TeemoInfoNONLUS,MD5manifestdifférentsduSpells ;Q Averdrianmetadataonly,aucunalias/lookup/pixelrenduqualifié. CharScriptLuaNONvideBuffTextureNameTeemo/CScommunautairevide,5Lua5literal,3buffsresolved3preloads4candidatsabsentshistoriques/9community.15%magic+noUnitCollisiondeclared4212/2909,Empoweredf1AS/NullLanceshielddistincts,MR30growth0nav35gameplayradiusabsent/6rankNonepasdefault.

V5854damageKassadin/Ahri±Cloak1033MR30/55:8magicQraw80witness8physicalwitness44refus360tails,ordinary61.5385/51.6129nopassive15%,0.85comparisonsillustrativesnotfullhistoricalorder.4occupancyKassadin/Garen allyblock65/enemypassbothnonqualifiant,nav!=nativebodyradius. ExistingExhaust/courage/penetration/resistance/shieldspreserved ;lifecycle/NullLanceshield/truedamage/Empoweredunexercised,V564open.

DDS3attempts[3,0,2]lecturesD=5/21120B,4saved16896B ;prefix2Epréservé,anciencompteurcorrigéarchivé. 2logsDDS=transcriptionsUTF8LFpasstderrbytes,provenanceadditionnellestage-root-gatedpasread92. Producer2exec1refuscasepreload,puis84 ;Cuniquecollector74/read10,pasretry,tailpréparatoirearchivé.

Rapport docs/AUDIT_SYS01202_KASSADIN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1231 Katarina passif HUD icône et état

Reprise main/8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2218entréesGitmodifiéespréservées. Audit borné AUD-SYS-01.2-02-KATARINA-PASSIF-HUD-ICON-STATE-LINK-01 :sources69/69,E-readback86/86,consumer67/67hérité/read10hérité,projectionE17/17. V58612nativeIDs36associations,22sites/13files ;SOURCE14relations12IDs/quatresites2files,Hud1definition.6contractsHUD/NETWORK/SIM/CONTRAT/SOURCE/ACCEPTANCE6owners,QWER5=4primary1Evariant0unresolved.

2DDS5744B1contenuKatarina_Voracity64DXT1mip7member116,OriannaInfohomonyme2176/member40MD5différentNONLU,pasalias/lookup/pixelqual. Character4213=15srefund versusbuff2922=10sR+refreshbaseUNRESOLVED ;Voracity/KatarinaPassive/katarinapassive distincts,2MaliceAndSpitekeys+3pathsabsents.2Lua2literal/CharScriptglobalsvides/communityCSvide,2preloads/DDF28nopassiveformula(DeathLotusAD5/KatarinaRAD3distincts),7community,6ranks/coûtsabsentspasdefault.

V5864publiccases45MELEEwindup.releasewitnesses=38Katarina7Garen,112refus720tails+451wait,2kills400each/1assist113ticks86.875credit/expired612ticks0 ;orambiantdistinct. Genericassist450ticks≠15srefundduration. Ranks/CDzeros,sortsrefusés,Codex10%CDR30APdoesnotarmCD,norefundamount/refreshqualified. OldBUILD101wrongreleases→qualifiedreleaseBUILD/RUN0,engineuntouched;V564/olderproofsopen.

Source3producers[1,1,0]/69+read86E,C2collectors[1,0]/67+read10 ;refus/archivesexactes. SOURCEactual4sites2files1readerunion14 ;clélegacycurrent_six_SOURCE_sitescontient4,pas6. DeuxDDSreads5744Bcaptureuniquepremierpassage.

consumer_document_projection_receipt.json :MD4/2/1/14/26corrigé,JSON/67/118pins/collecteurinchangés ;oldread10hérité/new17E-onlysansreplay,archive04exacte/générateurpréparénonexécuté. Ancienrootpacketnonpubliéarchivéavantreassembly.

Rapport docs/AUDIT_SYS01202_KATARINA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md ;publication_receipt.json/postpublication_verification.json font foi d’une seule clôture bornée. Zéro tâche/feature/inconnue/acceptation complète. Goal/Plan/UI/DB/registres/code/assets inchangés ;aucun nouveau runtime/build/REA.


## Reprise SYS-01.2-02 — V1232 Kayle passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-KAYLE-PASSIF-HUD-ICON-STATE-LINK-01` documenté dans docs/AUDIT_SYS01202_KAYLE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources58/58,relectureE84/84,consommateurs65/65,relectureE16/16 ; résultat final dans publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_kayle_passive_hud_20261104.

SOURCE18relations15identités/6sites3fichiers ;V58722sites12fichiers+2lecteurs,union14,28ancres.1DDS2176BKayle_Passive64DXT1mip0member200 ;Judicator_DivineBlessingnonretrouvé sur manifeste examiné,pas substitution. V587hérité :14mêléeKayle/4projectilesAnnie,34refus,334attente≠360suivi ;défensesinchangées,pasapplication/expirationqualifiée du3%/5s/max5. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2219entréesGitregroupéespréservées(13354expanded). Aucun nouveau build/runtime/REA,aucune clôture feature/inconnue/acceptation,aucun changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1233 Kennen passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-KENNEN-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_KENNEN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources59/59/relectureE88/88,consommateurs63/63/E21/21 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_kennen_passive_hud_20261104 font foi du résultat final.

SOURCE34relations32IDs/4sites2fichiers ;V58828sites13fichiers+1lecteur,union14,32ancres.2DDSMark4352B1contenu/member25,en-têtes qualifiés,paslookup/rendu. Native6,25s/3marques/1sstun/25énergie/diminution7snonqualifiée ;Wcinquièmeattaque distinct. V58812projectiles physiquesW0/énergie200plafonnée30refus360tails ;séparéAnnie5Q/Pyromania38ticks/424wait8refus,aucune qualificationnative transférée. Reprise main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2220entréesGitregroupéespréservées. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1234 Khazix passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-KHAZIX-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_KHAZIX_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources64/64/E105/105,consommateurs47/47/E22/22 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_khazix_passive_hud_20261104 font foi du résultat final.

HUD2natifs définition+CharScriptclientmetadata ;SOURCE35relations29IDs/6sites3fichiers,V58929sites14fichiers+2lecteurs,union16,35ancres.1DDS2872BKhazix_P64DXT1rawmip7/member126,paslookup/rendu. V5898mêlée32refus240hiddenimmobile360tails,visionlocale/projectioncohérentes,sansmagicbonus/slow ;f1/f2/f3/vision4.20/Rfurtif/HUDouverts. Lectures D du lot :SOURCE1DDS2872B ;peer2identités2065B et6exists sans payload,donc3payloads4937B au total. Dérogation de réutilisation peer consignée et non répétée. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2221entréesGitregroupéespréservées. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1235 KogMaw passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-KOGMAW-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_KOGMAW_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources63/63/E114/114,consommateurs51/51/E24/24 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_kogmaw_passive_hud_20261104 font foi du résultat final.

HUD2natifs définition+CharScriptclientmetadata ;SOURCE24relations18IDs/6sites3fichiers,V59022sites12fichiers+2lecteurs,union14,28ancres.2DDS5744B1contenuKogMaw/KogMawDead64DXT1rawmip7/membres252/251,paslookup/rendu. V59032projectilesAnnie/2morts/164refus dont110dead+24postrespawn(12parcas),960postticks/2respawns480ordinaires ;Move mort refusé/ennemi100unitéspleineHP,4spassifnonqualifié. Formule100+25lvlTRUE versus160+30lvlMAGIC ouverte,deadform présente nontransformation. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2222entréesGitregroupéespréservées. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1236 Leblanc passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LEBLANC-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LEBLANC_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources95/95/E195/195,consommateurs56/56/E27/27 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_leblanc_passive_hud_20261104 font foi du résultat final.

HUD2natifs def+CharScriptclientmetadata ;SOURCE20relations14IDs/6sites3fichiers,V59124sites12fichiers+2lecteurs,union14,30ancres.2DDS7096BnormaleDXT1mip7/ChargingDXT5mip1,différentscontenus,paslookup/rendu. V59124Annieprojectiles4crossingsstricts/54refus4102waitframes,noinvis/nocloneexposé,CDnonarmé ;Tibbersstatique. DeuxanciensRUN101(NPCtarget,impactnonattribué),qualifiécentralmêmesdurées/positionsréelles≠7000demandé.33OBShorsscope51241266Binertesarchivées,excluespreuvessémantiques. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2223dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1237 LeeSin passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LEESIN-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LEESIN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources77/77/E157/157,consommateurs43/43/E26/26 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_leesin_passive_hud_20261104 font foi du résultat final.

HUD2natifs def+CharScriptclientmetadata ;SOURCE29relations25IDs/6sites3fichiers,V59220sites10fichiers+2lecteurs,union12,26ancres.2DDS5744B1contenuLeeSinPassive/BlindMonkPassive64DXT1mip7,pasalias/lookup/rendu. Texte2attaques40%/15Energy,contradictionShenMarker/KiStrike/Jax/Mana/levels3,7,11,15,None,None nonadoptés. V5923games18melee81refus540tails/cadence46,46,40,Energycap200 ;sortsrefuséspréconditionabsente,aucunproc/charge/refundqualifié,Dagger≠Flurry/Sapphire≠Energy. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2224dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1238 Leona passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LEONA-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LEONA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources86/86/E101/101,consommateurs42/42/E28/28 ;publication_receipt.json/postpublication_verification.json sur E:/mapslol3v3/audit_sys01202_leona_passive_hud_20261104 font foi du résultat final.

HUD1natif def ;SOURCE30relations27IDs/6sites3fichiers,V59322sites12fichiers+2lecteurs,union14,28ancres.2DDS/4352B/1contenus,LeonaSunlight,paslookup/rendu. Texte3.5s/magicconsumptionalliée,@f2@nonrésolu,niveaux1/4/7nonadoptés ;permanentpassivepersists≠marktarget. V5932games6ownermelee6alliedQ54refus360tail416wait,Leona0/20AP ;allcastrefused=>marquejamaisappliquée,ni consommation/expiry/scalingqualifiés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2225dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ;aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1239 Lissandra passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LISSANDRA-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LISSANDRA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources105/105/E120/120,consommateurs40/40/E12/12 ; publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_lissandra_passive_hud_20261104 font foi du résultat final.

HUD2natifs definition+CharScriptmetadataNONserver ; SOURCE38relations32IDs/6sites3fichiers,V59424sites14fichiers+2lecteurs,union16/30ancres.1DDS2176B/64DXT1rawmip0/member0.0.0.161,paslookup/rendu. Texte18s/1s/contrôlesobjets exclus,PassiveBufftexteabsentfichierprésent,Ready distinct,6NEWTABLEnoncorruption. V5942games6ranged102refus1082wait539/540/541afterStop,Mana304cap,Codex30AP10%CDR ;sortsrefusés=>nofreecast/passiveCDarmed/CCreductionqualifiés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2226dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ; aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1240 Lucian passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LUCIAN-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LUCIAN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources102/102/E133/133,consommateurs41/41/E17/17 ; publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_lucian_passive_hud_20261104 font foi du résultat final.

HUD2natifs definition+CharScriptmetadataNONserver ; SOURCE41relations35IDs/6sites3fichiers,V59522sites12fichiers+2lecteurs,union14/28ancres.2DDS/4352B/2contenus,pasalias/lookup/rendu. Texte6s/completedcast/doubletir/@f1@classes/onhit ;25/LucianPassive/Dravenrolesdistincts,Qbuffrepeatpassif/Etooltipabsent,Coefficient1.2nonadopté. V5952games6ranged102refus362wait179/180/181afterStop,Mana298.88cap,Sword+10AD ;sortsrefusés=>noarm/secondshot/expiryqualifiés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2227dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ; aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1241 Lulu passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LULU-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LULU_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources101/101/E125/125,consommateurs42/42/E18/18 ; publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_lulu_passive_hud_20261104 font foi du résultat final.

HUD1definition ; SOURCE67relations60IDs/6sites3fichiers,V59622sites12fichiers+2lecteurs,union14/28ancres.1DDS5616B64DXT5mip7/member80,paslookup/rendu. Texte3magicboltsguidés/interceptables/@f1@f2/porteurEShield/révélationEBurn ;Caitlyn/Ezreal/Ashe/legacyaliasesconservés,24/1.2/.133NONformulePix. V5962games6ordinaryLuluprojectiles54refus360idle,Tome+20AP ;ownattacktriggerACCEPTÉmaisaucunextraPixmagicobservé,Erefusétransfertdistinctnonexercé,180ticksNOTnativeDuration. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2228dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ; aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1242 Lux passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-LUX-PASSIF-HUD-ICON-STATE-LINK-01` dans docs/AUDIT_SYS01202_LUX_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources107/107/E141/141,consommateurs43/43/E18/18 ; publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_lux_passive_hud_20261104 font foi du résultat final.

HUD1definition ; SOURCE40relations37IDs/6sites3fichiers,V59722sites12fichiers+2lecteurs,union14/28ancres.1DDS/2872B/1contenus,paslookup/rendu. Texte6smark/@f1@f2/Luxattackconsume/Rtrigger-refresh,ownerpersist≠markpersist,4SpellDatakeysabsent/BuffDataprésents,noDDF/NightmareBotexclus,0coeff≠0damage,Rprincipal/RMisdistincts. V5972games6physicalprojectiles54refus360idle,Tome+20AP ;allcastsrefused=>nomarkapplication,ordinaryattackwithoutmarknotconsumptionexpiryR. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2229dirtygroupéspréservés. Aucun nouveau build/runtime/REA ni changement goal/Plan/UI/bases/registres/produit ; aucune feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1243 Malphite passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MALPHITE-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_MALPHITE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources127/127, E171/171, consommateurs43/43, E20/20. Résultat final : publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_malphite_passive_hud_20261104.

Granite Shield : textes10%PVmax/10secondes sans coup versus sans dégâts,@f1@f2 non résolus ; icônes normale/grise documentées, sans lookup/rendu. SOURCE56relations39IDs/6sites3fichiers ; V59827sites14fichiers+2lecteurs, union16/33ancres. Deux cas base/Ruby+150HP, six impacts physiques et deux Q Annie acceptés, boucliers vides299/300/301 depuis réel Q ; prérequis de dégâts exercé, API générique ≠ producteur Malphite. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2230 entrées sales groupées préservées. Goal/Plan/UI/bases/registres/produit inchangés ; aucune fonctionnalité ou inconnue close.


## Reprise SYS-01.2-02 — V1244 Malzahar passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MALZAHAR-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_MALZAHAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources95/95, E173/173, consommateurs36/36, E20/20. Résultat final : publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_malzahar_passive_hud_20261104.

Summon Voidling :compteur quatre sorts/prêt prochain sort, variablesf1/f2/f3 et phases7/14/21 non qualifiés ;57sources171associations29sites13fichiers, SOURCE60relations57IDs/6sites3fichiers,union15/35ancres. Deux cas base/LongSword+10AD,six impacts ordinaires246refus1262idle ;aucun sort accepté ni invocation,offsets depuisStop ≠ âge créature. Tibbers/AnniePet contexte, pas producteur Malzahar. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2231 entrées sales groupées préservées. Goal/Plan/UI/bases/registres/produit inchangés ; aucune fonctionnalité ou inconnue close.


## Reprise SYS-01.2-02 — V1245 Maokai passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MAOKAI-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_MAOKAI_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources93/93,E210/210,consommateurs35/35,E23/23. Résultat final :publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_maokai_passive_hud_20261104.

Sap Magic :charge par sort proche,cinq charges puis prochain coup7%PVmax,rayon/éligibilité/f1 ouverts ;HUD2liens natifs(def+CharScriptmetadata) ;SOURCE68relations62IDs/6sites3fichiers ;V60062native186associations29sites16fichiers,union18/35ancres. Deux cas base/Ruby+150PV,10Q Annie à150 puis6mêlées,PV manquants>7%,aucun soin supplémentaire observé. Refus des sorts Maokai n’annulent pas ce scénario ;150 n’est pas rayon natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2232 entrées sales groupées préservées. Goal/Plan/UI/bases/registres/produit inchangés ;aucune fonctionnalité ou inconnue close.


## Reprise SYS-01.2-02 — V1246 MasterYi passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MASTERYI-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_MASTERYI_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources86/86,E193/193,consommateurs21/21,E23/23. Résultat final :publication_receipt.json/postpublication_verification.json dans E:/mapslol3v3/audit_sys01202_masteryi_passive_hud_20261104.

Double Strike :quatrième attaque consécutive/second50%,cycle ultérieur et auto-comptage ouverts ;HUD2liens natifs(def+CharScriptmetadata),SOURCE60relations54IDs/6sites3fichiers ;V60154native162associations23sites12fichiers,union14/29ancres. Trois cas base/LongSword/Dagger,24mêlées ordinaires,81refus,540tail ;AD60.04/70.04/60.04,cadences44/44/38,aucun second coup observé. Attaques acceptées malgré sorts propres refusés ;coups4/8 ne qualifient pas cycle suivant. MasterYi tooltipDoubleStrike absent,Ready distinct,0coeff≠0secondary/CanCrit-onhitNone≠False. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2233 entrées sales groupées préservées. Goal/Plan/UI/bases/registres/produit inchangés ;aucune fonctionnalité ou inconnue close.

Provenance collect01 :AnnieQ/E lus sans hashes alors conservés,identités historiques inconnues. root_supplement apporte deux captures ACTUELLES et un test de journalisation avant assertion,nonrétroactifs ; méthode COR-SYS01202-AUDIT-INPUT-PREFLIGHT-PINS-01 à adopter aux prochains collecteurs.


## Reprise SYS-01.2-02 — V1247 MissFortune passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MISSFORTUNE-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_MISSFORTUNE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Sources42/42,E37/37,consommateurs16/16,E7/7. Preuves :E:/mapslol3v3/audit_sys01202_missfortune_passive_hud_20261104 :publication_receipt/postpublication_verification/root_material_inventory/root_material_postpublication.

Strut distinct du W ImpureShots/alias Draw a Bead nonTristana ;5sec/+25/+8par seconde/cap70 texte, interruptions ouvertes. HUD2native/1catalogue ;SOURCE66relations62IDs6sites3fichiers ;V60262native186assoc25sites12fichiers,union14/31ancres. DDS3paths6528B2contenus,lookup/pixels nonqualifiés. Deux cas base/bottes325/350,1324waitticks8trajets216pas208fullspeed2Q54refus,aucun bonus/reset nonqualifié. Méthodejournal Python avantassertion test7/7 puis couverturecomplètebornée; exclusions/TOCTOU explicites. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2234 entrées sales groupées préservées. Aucune tâche/feature/inconnue/acceptation/goal close; Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1248 Mordekaiser passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MORDEKAISER-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_MORDEKAISER_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_mordekaiser_passive_hud_20261104 :evidence_review31/31,coherence_review42/42,result/publication/postpublication. HUD1native(definition)/1catalogue,Source60relations57IDs6sites3fichiers,V60457sources171associations32sites16fichiers,union18/38ancres. DDS2paths4352B1contenu,DXT1 64,mipbrut0,membre25 ;lookup/pixelsouverts.

Iron Man f1/f2 et décroissance3% nonrésolus ;Shield120 n’est ni capacité native prouvée ni absorption. Deuxcas base/RubySapphire :6sortantes6physiques2Q244wait54refus,aucun sort propre accepté,conversionnonexercée. API générique50absorbé/80expire30ticks/31trames/7refus distincte. HUDnatif Mana-only supprime Shieldfraction/MPStat,texte générique bouclierseparé. Sourcehashressource=JSONcommunautaire,distinctINIBIN. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2235entrées sales groupées conservées. Relecture mêmeagent,aucune validation humaine indépendante. Goal/Plan/UI/bases/registres/produit inchangés ;aucune tâche/feature/inconnueclose.


## Reprise SYS-01.2-02 — V1249 Morgana passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-MORGANA-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_MORGANA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_morgana_passive_hud_20261104 :evidence_review46/46,coherence_review44/44,result/publication/postpublication. HUD1native(definition)/1catalogue ;SOURCE38relations28IDs6sites3fichiers,V60528sources84assoc28sites15fichiers,union17/34ancres. DDS3paths12672B1contenu,Dxt5 64mipbrut0,membres130/40/25,aliasEliseSpiderlingnonconsumerMorgana ;lookup/pixelsouverts.

Empathize/SoulSiphon :f1%SpellVamp personnel,progression/modificateurs nonrésolus. CharScript natif2flagsnonvide,communautairevide ;10Lua7NEWTABLE,7preloads,18NightmareBotexclus. Trois casV605base/Tome/Vamp :9sortantes9physiques3Q540wait81refus6trajets ;sorts propres refusés,triggernonexercé. Raw9pairesHPpropres+waitregenmédian donnent0/0/4,3925476soin ordinaire,natifpassifnonqualifié. Mana/MPStat/PV génériques nequalifientpas f1/HUDpassif ;sourcehashressource=JSONcommunautaire,PARType natifabsent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2236entrées salesgroupées conservées. Relecturemêmeagent ;aucune tâche/feature/inconnue/acceptation/goalclose. Plan/UI/bases/registres/produitinchangés.


## Reprise SYS-01.2-02 — V1250 Nami passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NAMI-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_NAMI_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nami_passive_hud_20261104 :evidence_review55/55,coherence_review39/39,result/publication/postpublication. HUD2native(def+metadata)/1catalogue ;SOURCE69relations63IDs6sites3fichiers,V60663sources189assoc21sites9fichiers,union11/27ancres. DDS2paths7096B2contenus :NamiPassive64DXT1mip7/membre137,JannaTailwind64DXT5mip1/membre25 ;autrealiasJannamanifesteseulement,lookup/pixelsouverts.

SurgingTides40+f1/1,5s,nativef1/contacts/cumul/lifecycle nonqualifiés ;aucun sort Nami accepté. DeuxcasNami335/360Ahri330,184wait/12bornes/102refus ;8trajets512samples198pleins,6réussis2échouésà36unités,destinationdéjàperdueavantStop,24pleins156nuls/180chacun. Collecte0≠mouvementaccepté(false). TroisanciensBUILD0RUN101conservés. Sourcehashressource=JSONcommunautaire,PARType natifabsent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2237entrées salesgroupées conservées. Aucunetâche/feature/inconnue/acceptation/goalclose ;Plan/UI/bases/registres/produitinchangés.


## Reprise SYS-01.2-02 — V1251 Nasus passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NASUS-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_NASUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nasus_passive_hud_20261104 :evidence_review49/49,coherence_review47/47,result/publication/postpublication. HUD2native(def+metadata)/1catalogue ;SOURCE44relations32IDs6sites3fichiers,V60732sources96assoc28sites15fichiers,union17/34ancres. DDS1path2176B64DXT1mipbrut0/membre188 ;lookup/pixelsouverts.

SoulEater f1%bonusLifeSteal,paliers/combinaison nonrésolus ;Singedtextesnonadoptés,NasusQtooltipexactabsentsansréécriture. Trois casbase/LongSword/Vamp :9mêlées9physiques3Q540wait81refus6trajets ;AD59,18/69,18/69,18,taux0/0/8%. RawpairesHPmoinswaitregenmédian donnent0/0/4,6421814PV,voldevieobjetdistinct. AttaquesordinairesEXERCÉES malgréQWERrefusés ;bonusNasusabsentdeprogression(items-only),déficitnatifnonquantifiable. Sourcehashressource=JSONcommunautaire,PARType natifabsent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2238entréessalesgroupéesconservées ;Goal/Plan/UI/bases/registres/produitinchangés,aucunetâche/feature/inconnue/acceptationclose.


## Reprise SYS-01.2-02 — V1252 Nautilus passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NAUTILUS-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_NAUTILUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nautilus_passive_hud_20261104 : evidence51/51, cohérence52/52, même agent. SOURCE88relations/82IDs dont3candidats littéraux supplémentaires ; V60879sources/237assoc/31sites/16fichiers ; union18fichiers/37ancres. DDS4chemins/11488octets/2contenus,64DXT1mip7 ; lookup/pixels ouverts.

Deux cas base/Épée+10AD :6mêlées6physiques2Q360wait54refus4trajets. Attaques ordinaires exercées ; dégâts sans bonus et6paires de positions montrent11,16650390625unités/tick après premier impact,aucune immobilisation observée. f1/f2/f3/progression/immunité source-cible ouverts ; stun générique non substitué. Binaire6131200/e1a737e4…inert,BUILD/RUN0,historique15fichiers/13ancienshashes/2freshnull. Mana sourcehash communautaire,PARType natif absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2239entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1253 Nidalee passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NIDALEE-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_NIDALEE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nidalee_passive_hud_20261104 :64/64 contrôles,49/49 cohérence séparée du même agent. HUD2sources/1catalogue ; SOURCE78relations/72IDs/6sites/3fichiers,V60972sources/216associations/28sites/12fichiers ; union14fichiers/34ancres. Deux DDS4352octets,64DXT1,mipbrut0,membre237 ; lookup/pixels ouverts.

Deux cas base/Bottes :8trajets aboutis,280pas/272pleine vitesse,158buisson dont76vers ennemi visible et82en éloignement. Vitesses335/360 sans Prowl,buisson exercé. Hunt/formes non exercés ;244ticks attente,2QAnnie,54refus,4trajets préparation. Conflits5500/5900 et Swipe conservés ;2clés BuffData manquantes sans réécriture. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2240entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; aucune tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1254 Nocturne passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NOCTURNE-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_NOCTURNE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nocturne_passive_hud_20261104 :65/65 contrôles,50/50 cohérence séparée du même agent. HUD1source/1catalogue ; SOURCE61relations/59IDs/4sites/2fichiers,V61059sources/177associations/28sites/15fichiers ; union16fichiers/32ancres. DDS3chemins/7920octets/2contenus,64DXT1,prêtmip7/grismip1 ; lookup/pixels ouverts,Wolfman manifeste seulement.

Trois cas base/Épée/Sceptre :18mêlées9physiques3Q1806wait81refus6trajets. Dégâts AD ordinaire,sans120% ; soin recalculé par18pairesPV moinsregenmédiane0,05505371 :0/0/4,64404297PV,attendu objet4,64405251. Attaques ordinaires exercées ; une cible,zone/soinparcible/réduction1s non qualifiés. f1/paliers/rayon/cooldown ouverts. Fichier cooldown avec espaces présent ; CharScript Wolfman non vide≠Warwick. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2241entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; aucune tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1255 Nunu passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-NUNU-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_NUNU_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_nunu_passive_hud_20261104 :60/60 contrôles,50/50 cohérence séparée du même agent. HUD1source/1catalogue ; SOURCE50relations/36IDs/6sites/3fichiers,V61136sources/108assoc/26sites/13fichiers ; union15fichiers/32ancres. DDS3chemins/12672octets/2contenus,64DXT5,mips0/0/1 ; lookup/pixels ouverts.

Deux cas base/Cristal :12mêlées,102refus aux comptes0/4/5/6,8snapshots bruts avant/après égaux,4trajets sans reprises. AD56,856 ; mana maximal283,56/483,56. Aucun cast Nunu accepté,compteur/prêt/gratuité non qualifiés ; mana final plein et paires plafonnées ne prouvent pas le passif. Cristal augmente capacité sans remplir réserve. Historique premierBUILD0/RUN101 conservé,versionmana-bounds0/0,binaire6093312/b0dd7cf7…inerte. Collecteur actuel en collision de doublons conservé,puis20captures réutilisées+2reçus récupérés. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2242entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1256 Olaf passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-OLAF-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_OLAF_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_olaf_passive_hud_20261104 :65/65 contrôles,52/52 cohérence qualifiée du même agent ; première51/52 conservée,prédicat inline corrigé vers stats→cadence→windup/next_attack sans changementmoteur. HUD2sources/1catalogue ; SOURCE50relations/44IDs/6sites/3fichiers,V61244sources/132assoc/24sites/13fichiers ; union15fichiers/30ancres. DDS1chemin2176octets,64DXT1,mipbrut0,membre174 ; lookup/pixels ouverts.

Deux cas base/Dague :18mêlées6physiques2Q240wait54refus4trajets. Trois phases pleinevie/blessé/récupération ;12intervalles43ticks ou37Dague malgré26,1–29,1%PVmanquants. Bonus objet exercé,bonus passif absent du chemin audité ; formule/cumul/caps/arrondis/recalcul/HUD ouverts. Orthographe nativeOlafBerzerkerRage conservée,Rpassifdistinct. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2243entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1257 Orianna passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-ORIANNA-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_ORIANNA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_orianna_passive_hud_20261104 :51/51 contrôles,48/48 cohérence séparée du même agent. HUD1source/1catalogue ; SOURCE70relations/67IDs/6sites/3fichiers,V61367sources/201assoc/24sites/13fichiers ; union15fichiers/30ancres. DDS3chemins/6528octets/2contenus,64DXT1,mipbrut0 ; définitionOriannaPassive distincte deBuffPowerDagger,lookup/pixelsouverts.

Deux cas base/Tome20AP :14impacts,7projectiles distincts par partie,54refus,242wait,4trajets sans reprises. Séries4+3,intervalles46/écart137ticks ; dégâts33,8600769 identiques,physique attendu33,8600922,sansmagie/cumul observé. Attaques répétées exercées ; f1/f2/f3/progression ouverts,expiration non déduite d’un buff absent. NoBall/Yomu/Balle non qualifiés ; graphieOrianaSpellSword exactun n conservée. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2244entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1258 Pantheon passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-PANTHEON-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_PANTHEON_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_pantheon_passive_hud_20261104 :67/67 contrôles,55/55 cohérence séparée du même agent. HUD1source/1catalogue ; SOURCE100relations/97IDs/6sites/3fichiers,V61497sources/291assoc/24sites/13fichiers ; union15fichiers/30ancres. DDS3chemins/12672octets/2contenus,64DXT5,mip1 ; lookup/pixelsouverts.

Deux cas base/Armure15 :16mêlées18physiques2Q54refus4trajets. Comptes0/4/8 recalculéspar ticks ; aucunblocage,mitigationordinaire39,49017/35,33774. Armure réduitlesdégâts sansAegis,compteur/prêt/consommation/HUD ouverts. Q reçu sansAegis produit nequalifiepas conservation ; W/tourelles/sbires/monstres nonexercés. DouzeBuffData/sixrésolutions(cinqclésdistinctes)/sixabsencesexactes ; cinqvariantsdedépart auxSHA différents,globalsparchemincompletpréservés. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2245entréessalesgroupéesconservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1259 Poppy passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-POPPY-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_POPPY_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_poppy_passive_hud_20261104 :55/55 contrôles,49/49 cohérence séparée du même agent. HUD2sources/1catalogue ; SOURCE52relations/46IDs/6sites/3fichiers,V61546sources/138assoc/24sites/13fichiers ; union15fichiers/30ancres. DDS2chemins/8448octets/1contenu,64DXT5mip1 ; lookup/pixels ouverts.

Trois cas base/Rubis150PV/Cape25RM :9mêlées18physiques6Q81refus360wait6trajets. Sur24entrants,10au-dessus/14dessous du seuil illustratif après mitigation ; dégâts ordinaires,sans réduction observée. SixQ recalculés depuis PV bruts avant/après ; physiques sans PVaprès bruts,refusflags uniquement. Formule excédent/coup entier/ordre/structures/HUD ouverts. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2246entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1260 Quinn passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-QUINN-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_QUINN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_quinn_passive_hud_20261104 : 56/56 contrôles,48/48 cohérence séparée du même agent. HUD2sources/1catalogue ; SOURCE107relations/101IDs/6sites/3fichiers,V616101sources/303assoc/24sites/13fichiers ; union15fichiers/30ancres. DDS2chemins/5744octets/2contenus,64DXT1mip7 ; lookup/pixels ouverts.

Deux cas base/Épée10AD :12projectiles54refus3604wait4trajets. Deux attentes901ticks/cas ne qualifient pas période28s candidate ; dégâts ordinaires42,81161/51,19946 sans bonus Harrier observé. f1/f2/f3/propriété/période et Valor ouverts ; trois références texte manquantes/deux clés,aucun alias. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2247entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1261 Rammus passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RAMMUS-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_RAMMUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_rammus_passive_hud_20261104 :61/61 contrôles,51/51 cohérence séparée du même agent. HUD1source/1catalogue ; SOURCE40relations/32IDs/6sites/3fichiers,V61731sources/93assoc/24sites/12fichiers ; union14fichiers/30ancres. Spiked Shell.inibin supplémentaire et tooltip f1/f2 repris deV547,sanslectureD. DDS2chemins/8448octets/1contenu,64DXT5mipbrut0 ; lookup/pixels ouverts.

Trois cas base/Tissu15armure/Épée10AD :9mêlées9physiques3Q81refus6trajets,9stats/6transactions. Armure accrue sansAD,dégâts sortants46,87133 inchangés ; Épée55,25919. Conversion25%/f1/f2/ordre/armure négative/W/HUD ouverts ; W10%renvoi distinct. Mana sourcehash communautaire,PARType absent. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2248entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1262 Renekton passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RENEKTON-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_RENEKTON_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_renekton_passive_hud_20261104 :54/54 contrôles,51/51 cohérence séparée du même agent. HUD2sources/1catalogue ;SOURCE65relations/59IDs/6sites/3fichiers,V61859sources/177assoc/24sites/12fichiers ;union14fichiers/30ancres. DDS2chemins/7096octets/2contenus,RenektonDXT1mip7 etInCombatsharedCorkiDXT5mip1 ;aucun Characters/Corki lu,lookup/pixels ouverts.

Deux cas base/Saphir200mana :18mêlées dont12depuis0/sixsous50%PV,50physiques,deuxmorts/deuxrespawns480ticks,1204wait54refus6trajets. Ressource100initial/0respawn,attaquesdepuis0restent0 ;fenêtres301 depuis100sansbaisse,grâcenativeinconnue. Rage/max100/nonrestauration/reset acquis ;HUD actuel omet Rage (Mana seulement). Sourcehash StatsJSONcommunautaire distinctINIBIN,PARTypeRage natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2249entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1263 Rengar passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RENGAR-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_RENGAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_rengar_passive_hud_20261104 :74/74 contrôles,63/63 cohérence séparée du même agent. HUD2sources/1catalogue ;SOURCE150relations/145IDs/6sites/3fichiers,V619145sources/435assoc/28sites/14fichiers ;union16fichiers/34ancres. DDS3chemins/11360octets/2contenus,64mip7,DXT1underscore/DXT5sansunderscore ;lookup/pixels ouverts.

Quatre cas brush/open×base/Boots :12mêlées108refus244wait8trajets ;464pairespositions recalculées,touspas ordinaires345/370. Avant premier impact20pas/230unités ou18/221,99414 ;aucun saut observé,nativef1/éligibilité400 inconnus. Férocité5/max5,capacités ennemies refusées :génération/dépense non exercées. HUDnonMana ometFerocity ;Passive/NewPassive,septbindings/trophées/furtivité ouverts. Sourcehash communautaire distinctINIBIN,PARTypeFerocity natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2250entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1264 Riven passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RIVEN-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_RIVEN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_riven_passive_hud_20261104 :50/50 contrôles qualifiés,50/50 cohérence séparée du même agent ;initial48/50 conservé,égalité stricte corrigée vers tolérance0,002 déjà déclarée,autres48 identiques. HUD2sources/1catalogue ;SOURCE72relations/66IDs/6sites/3fichiers,V62066sources/198assoc/26sites/12fichiers ;union14fichiers/32ancres. DDS2chemins/5744octets/1contenu,64DXT1mip7 ;lookup/pixels ouverts.

Deux cas base/Épée10AD :12mêlées54refus362wait4trajets,5stats/3transactions. AD56,04/66,04,impacts47,00552–47,00554 ou55,39339–55,39340,génériques. Aucun sort accepté :charges/consommation/expiration/bonus non exercés ;None0 n’est pas compteur0. f1/f2/f3,durée/niveaux147/AutoCooldown non résolus. Sourcehash communautaire distinctINIBIN,PARTypeNone natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2251entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1265 Rumble passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RUMBLE-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_RUMBLE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_rumble_passive_hud_20261104 :71/71 contrôles,61/61 cohérence séparée du même agent. HUD2sources/1catalogue ;SOURCE109relations/103IDs/6sites/3fichiers,V621103sources/309associations/26sites/12fichiers ;union14fichiers/32ancres. DDS4chemins/10792octets/3contenus,64DXT1,mips7/0/7/7 ;lookup/pixels ouverts.

Trois cas base/Tome20AP/Saphir200mana :18mêlées,48physiques,3morts/3respawns480ticks,1806wait81refus9trajets. Ressource100initial/0respawn,max100 ;aucun cast accepté ni surchauffe effective qualifiée,attaques51,196106 physiques ordinaires même20AP. Heat/max100/nonrestauration/reset acquis ;HUD Mana-only omet Heat. Sourcehash communautaire distinctINIBIN,PARTypeHeat natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2252entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1266 Ryze passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-RYZE-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_RYZE_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_ryze_passive_hud_20261104 :71/71 contrôles,65/65 cohérence séparée du même agent. HUD2sources/1catalogue ; SOURCE35relations/30IDs/6sites/3fichiers,V62230sources/90associations/28sites/14fichiers ; union16fichiers/34ancres. DDS1chemin4224octets,64DXT5/mipbrut0,membre254 ; lookup/pixels ouverts.

Trois profils base/Codex30AP10CDR/Saphir200mana :18projectiles,3Barrier,726wait84refus6trajets/3achats. Délais propres zéro,aucun sortRyze accepté :réduction1s des autres sorts non exercée. ContrôleCDR300/270/300ticks,Barrier115/expiry60 et deadline6300inchangée ; Mana générique et HUDdélais acquis,nonpassif. PARType natif absent,sourcehash StatsJSON communautaire distinctINIBIN. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2253entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1267 Sejuani passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SEJUANI-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_SEJUANI_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_sejuani_passive_hud_20261104 :72/72 contrôles,69/69 cohérence séparée du même agent. HUD2sources/1catalogue ;SOURCE97relations/91IDs/6sites/3fichiers,V62391sources/273associations/30sites/15fichiers ;union17fichiers/36ancres. DDS2chemins/6400octets/2contenus,64DXT1mip0 etDXT5mip1 ;particule22000octets manifeste seulement,aucun Elise lu,lookup/pixels ouverts.

Trois profils base/Tissu15armure/Bottes25MS :18mêlées9physiques3Q,647samplesarmure,228Exhaust+543idle,84refus6trajets/9stats6transactions. Pas de bonusarmure après dégâts ;Exhaustimmédiat reste−10armure/30%slow75ticks,vitesse238/238/255.5. Déclencheurattaque exercé,f1/cap/expiry propres ouverts ;aucun sortSejuani accepté. Mana/stat/HUDgénériques acquis,PARType absent,sourcehash communautaire distinctINIBIN. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2254entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1268 Shaco passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SHACO-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_SHACO_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_shaco_passive_hud_20261104 :69/69 contrôles,63/63 cohérence séparée du même agent. HUD2sources/1catalogue ;SOURCE68relations/62IDs/6sites/3fichiers,V62462sources/186associations/28sites/14fichiers ;union16fichiers/34ancres. DDS2chemins/8448octets/1contenu,64DXT5mipbrut0,membres153/25 ;lookup/pixels ouverts.

Quatre cas base/Épée10AD×face/dos :24mêlées,724wait108refus12trajets/10stats6transactions.24cosinus recalculés+1/−1,yawGaren−89.999992 après déplacement réel ;Shaco facing absent nondefaulté. Dégâts45.14804–45.14807 ou52.98895 identiquesface/dos,génériques,sansbonusarrière observé. Angle/instant/categories/ordre natifs ouverts ;aucun sortShaco accepté. Mana/HUD/facing génériques acquis,PARType absent,sourcehash communautaire distinctINIBIN. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2255entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1269 Shen passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SHEN-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_SHEN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_shen_passive_hud_20261104 :66/66 contrôles,57/57 cohérence séparée du même agent. HUD1source/1catalogue ;SOURCE78relations/57IDs/6sites/3fichiers,V62557sources/171associations/26sites/13fichiers ;union15fichiers/32ancres. DDS2chemins/7792octets/2contenus,64DXT3mip7 prêt/DXT1mip1 gris,membres25/77 ;lookup/pixels ouverts.

Trois profils base/Rubis150HP/Saphir200mana :18mêlées813wait81refus6trajets/9stats6transactions. Dégâts50.46971–50.46973 physiques sansbonus ;Rubis+150HP inchangé.271ticks attente/280écartimpacts nequalifientpas période8s/9s ;énergie18paires200→200,refundauplafond nonqualifié,aucun castShen/Feint accepté. Energy200/exclusionmanaobjet acquis,régénération10statique ;HUDMana-only ometEnergy. Sourcehash communautaire distinctINIBIN,PARTypeEnergy natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2256entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1270 Shyvana passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SHYVANA-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_SHYVANA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_shyvana_passive_hud_20261104 :69/69 contrôles,61/61 cohérence séparée du même agent. HUD1source/1catalogue ;SOURCE69relations/66IDs/6sites/3fichiers,V62666sources/198associations/24sites/12fichiers ;union14fichiers/30ancres. DDS2chemins/4352octets/2contenus,64DXT1mip1,membres56 ;lookup/pixels ouverts,aucun Jarvan/Minotaur lu.

Trois profils base/Tissu15armure/Manteau25RM :9mêlées9physiques3Q,543wait81refus6trajets/9stats6transactions. Défenses27.628/32.1,42.627998/32.1,27.628/57.1 base+objets ;f1/progression inconnus,pasdéficitnumériquenatifdéduit. Aucun castShyvana/dragonexercé,doublement nonqualifié ;9pairesFurie100→100 nonpreuvegain. Dragonfury/max100 etmitigations acquises,HUDMana-only ometFurie. Sourcehash communautaire distinctINIBIN,PARTypeDragonfury natif. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2257entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1271 Singed passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SINGED-PASSIF-HUD-ICON-STATE-LINK-01` :docs/AUDIT_SYS01202_SINGED_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_singed_passive_hud_20261104 :72/72contrôles,60/60cohérence séparée même agent. HUD1/1,SOURCE42relations/33IDs/6sites/3fichiers ;V62732membres26sites+deltaV6281/1,union14fichiers/32ancres uniques/33entrées. DDS2chemins6400octets/2contenus64DXT5 etDXT1,mipbrut0,membres25/2 ;lookup/pixels ouverts.

Trois profils base/Rubis150PV/Saphir200mana :18mêlées543idle81refus6trajets9stats6transactions. Rubis+150PV acquis,Saphir+200mana sanshaussePV ;achatne remplitpas pool courant,idle déjàplafonné/régensousplafondnonexercée. Aucun cast Singed accepté,f1/f2/f3/assiette/arrondis/lifecycle ouverts. Fichieravec espace49octets lieBuffData,25/100texte ;omissionV627 corrigée,V543antérieur conservé,aucuneabsenceglobale déduite. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2258entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés,zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1272 Sion passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SION-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SION_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_sion_passive_hud_20261104 : 58/58 contrôles, 59/59 cohérence séparée du même agent. HUD2/1, SOURCE156relations/150IDs/6sites/3fichiers, V629150membres/26sites/12fichiers ; union14fichiers/32ancres. DDS1chemin2176octets64DXT1/mipbrut0,membre254 ; lookup/pixels ouverts.

Deux profils base/Rubis+150PV : 12 mêlées,34 impacts entrants avec paires PV brutes recalculées,deux morts/respawns,960trames/958mortes avant tick480,144refus dont90morts,six trajets/unachat,pasvente/rachat. Aucune phase réanimée observée ni cast Sion accepté ; normal480ticks nequalifiepas Glory in Death. Variantes420PV50AD,21limitesNEWTABLE,37BuffData19résolus18nonrésolus,provider/decay/cadence/vitesse ouverts. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2259entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1273 Sivir passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SIVIR-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SIVIR_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_sivir_passive_hud_20261104 : 59/59 contrôles, 57/57 cohérence séparée du même agent. HUD2/1, SOURCE58relations/52IDs/6sites/3fichiers, V63052membres/28sites/13fichiers ; union15fichiers/34ancres. DDS1chemin2176octets64DXT1/mipbrut0,membre183 ; lookup/pixels ouverts.

Base/Bottes+25 : 12 impacts ordinaires sur Annie,416 observations vitesse pendant attaques/244aprèsimpact,54refus,six trajets/deux marches30pas/unachat,pasvente/rachat. Vitesse335/360 sansbonus ; distances334.9951171875/360 recalculées depuis coordonnées,écartflottant conservé. Aucun cast Sivir accepté ; f1/progression/refresh/expiration ouverts,absencebonus nonpreuveexpiry. Legacyesquive etRPassive homonyme nonfusionnés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2260entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1274 Skarner passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SKARNER-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SKARNER_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_skarner_passive_hud_20261104 : 55/55 contrôles,61/61 cohérence séparée du même agent. HUD2/1,SOURCE74relations/68IDs/6sites/3fichiers,V63168membres/26sites/13fichiers ; union15fichiers/32ancres. DDS2chemins4352octets/1contenu64DXT1/mipbrut0,membres249/237 ; lookup/pixels ouverts.

Base/Tome20AP : 12mêlées ordinaires,362idle54refus4trajets5relevés boutique/3transactionsachat-vente-rachat. AD61.1559982/dégâts51.2967529inchangés ; AP20 contrôleobjet,nonpreuve scaling. Aucun cast/charge accepté ; proc/stun/verrou nonexercés,181ticks sansamorce nonpreuveexpiry. Native3charges/5s etverrou6s liés ; f1magique/f2stun/progression ouverts,Cooldown10/Q/Rdistincts. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2261entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1275 Sona passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SONA-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SONA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_sona_passive_hud_20261104 : 61/61 contrôles,66/66 cohérence séparée du même agent. HUD2/1,SOURCE98relations/92IDs/6sites/3fichiers,V63292membres/28sites/14fichiers ; union16fichiers/34ancres. DDS2chemins4352octets/2contenus64DXT1/mipbrut0,membres243 ; provider/pixels ouverts.

Base/Tome20AP :12projectiles/impactsordinaires,362idle54refus4trajets5relevés boutique/3transactions. Dégâts41.9728088–41.9728394 recalculés ;aucun cast/compteur/chargé accepté,variantes nonexercées. Native3sortshorsultime/dernierchant liés ;Q50%,W20%base+f1/3s,E40%base+APsymbolique/2s champs/font exacts,nonscaling effectif. Exhaust etslowgénérique nonDiminuendo/Tempo ;sourcef1/f2/compteur/lifecycleouverts. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2262entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1276 Soraka passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SORAKA-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SORAKA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_soraka_passive_hud_20261104 :96/96 contrôles,89/89 cohérence séparée du même agent. HUD2/1,SOURCE79relations/74IDs/6sites/3fichiers,V63374membres/29sites/14fichiers ;union16fichiers/35ancres. DDSactuel1chemin2176octets64DXT1/mipbrut0,membre251 ;ancienConsecration quatrealiasesétrangers manifesteseul,providerouvert.

Quatreprofils base/Bottes×alliésain/blessé :26projectilesennemis,112refus12arrivées8marches240trames/60versblessé,deuxachats sansvente/rachat. Vitesses325/350,distances324.990234375/349.9951171875 identiquesvers/opposé etsain/blessé. Ratios/cosinus/distancesbruts recalculés :allié≈22%,<801,vers>0.99 ;conditiontextuelle70%/<40%/2500 exercéesansbonus. Anglenatif/frontières/softcaps/provider nonqualifiés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2263entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1277 Swain passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SWAIN-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SWAIN_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_swain_passive_hud_20261104 : 91/91 contrôles, 81/81 cohérence séparée du même agent. HUD1/1, SOURCE52relations/49IDs/6sites/3fichiers ; V63449membres/31sites/14fichiers, union16fichiers/37ancres. DDS1chemin2872octets64DXT1/septmips/membre25 ; provider/pixels ouverts.

Quatre cas base/Saphir × élimination/assistance : deux plafonnés non discriminants ; deux avec déficit>47,16 et capacité524 montrent seulement régénération, sans restitution décrite par font2735. 2084 trames de combat/124 après décès recalculées ; achat public hors fontaine, niveaux1 et attribution réelle vérifiés. Branche ordinaire9+niveau, arrondis/ordre/lifecycle ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2264 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1278 Syndra passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-SYNDRA-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_SYNDRA_PASSIF_HUD_ICON_STATE_LINK_2026-11-04.md. Preuves E:/mapslol3v3/audit_sys01202_syndra_passive_hud_20261104 : 200/200 contrôles corrigés, 95/95 cohérence séparée du même agent. HUD1/1, SOURCE122relations/116IDs/6sites/3fichiers ; V635116membres/11sites/4fichiers, union6fichiers/17ancres et deux consommateurs HUD complémentaires. DDS1chemin2872octets64DXT1/septmips/membre120 ; provider/pixels ouverts.

Syndra72Learn/144casts refusés, rangs0/0/0/0 sur niveaux1–18 ; Annie18Learn acceptés/54refusés,5/5/5/3. 144 prédictions,36attributions XP diagnostiques,278refus commandes/10XP, zéro tick : pas de progression naturelle ni effets max exercés. Apprentissage core et maxima HUD excluent Syndra. Native Q15%champions/W33%durée/E50%largeur/R75portée liés ; producteurs ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2265 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1279 Talon passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-TALON-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_TALON_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Publication5novembre Europe/Zurich, lot engagé4novembre. Preuves E:/mapslol3v3/audit_sys01202_talon_passive_hud_20261104 :107/107 contrôles corrigés,108/108 cohérence séparée du même agent. HUD1/1,SOURCE65relations/63IDs/4sites/2fichiers ; V63663membres/27sites/15fichiers,union16fichiers/31ancres. DDS1chemin5616octets64DXT5/septmips/membre43 ; provider/pixels ouverts.

Trois cas publics slow/stun/cumul,9attaques Talon/10Q Annie/2Exhaust/9arrivées/84refus. Trois impacts sous contrôle sans bonus10% observé ; hausseExhaust expliquée pararmure−10. NeufpairesPV/régénération reconstituées ; pairesQadjacentes absentes. Root/suppression/critiques/onhit/frontières ouverts. CharScript114Wolfman etBladeRogue22 legacy distincts deMercy. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2266 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1280 Taric passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-TARIC-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_TARIC_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_taric_passive_hud_20261105 :69/69 contrôles,72/72 cohérence séparée du même agent. HUD1/1,SOURCE45relations/42IDs/6sites/3fichiers ;V63742membres/26sites/13fichiers,union15fichiers/32ancres. DDS1chemin4224octets64DXT5/unmip/membre25 ;provider/pixels ouverts.

Base/Tissu15armure :12mêlées ordinaires,362idle/360pairesPVadjacentes,54refus,4trajets,5relevés boutique/3transactions. Armure25.876/40.876,dégâts48.54889 ;aucun cast/étatprêt/proc/réduction2s exercés. Contradiction BuffData1943armure versusSpellData11543mana conservée,f1/f2/dispatch ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2267 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1281 Teemo passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-TEEMO-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_TEEMO_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_teemo_passive_hud_20261105 :73/73 contrôles,69/69 cohérence séparée du même agent. HUD1/1,SOURCE49relations/46IDs/6sites/3fichiers ;V63846membres/30sites/12fichiers,union14fichiers/36ancres. DDS1chemin4224octets64DXT5/mipbrut0/membre25 ;provider/pixels ouverts.

Deuxcas immobile181ticks puisattaque,ou mouvement80puisattaque :364indicateurs visibilitépositifs,6projectiles/cadence43,54refus,5arrivées. Entréefurtive nonobservée ;sortie40%/3snonexercée. Snapshotsbrutspropres début/fin identiques etgardesidle ;payloadsennemis completspartrameabsents,indicateurs issusd’assertionspasreplayLOS/protocole. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2268 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1282 Thresh passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-THRESH-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_THRESH_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_thresh_passive_hud_20261105 :239/239 contrôles,130/130 cohérence corrigée séparée du même agent. HUD1/1,SOURCE168relations/164IDs/6sites/3fichiers ;V639164membres/14sites/7fichiers,union9fichiers/20ancres etdeuxconsommateursHUDcomplémentaires. DDS1ownHUD2872octets64DXT1/septmips/membre141 ;provider/pixels ouverts.

Thresharmure16/AP0sur18niveaux,Annie19.22→87.22/AP0 ;36pointsstats/144prédictions/36awardsXPdiagnostiques,278refuscommandes/10XP,zérotick. Aucun décès/drop/pickup/gainâme exercé ;croissance0acquise nonpreuvepassifcomplet. Motif exclutthreshold ;frontièreréelleworld.damage_unit/statique,receiverTrundle distinct. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2269 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1283 Tristana passif HUD icône et état

Audit borné `AUD-SYS-01.2-02-TRISTANA-PASSIF-HUD-ICON-STATE-LINK-01` : docs/AUDIT_SYS01202_TRISTANA_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_tristana_passive_hud_20261105 :238/238 contrôles,116/116 cohérence séparée du même agent. HUD2/1,SOURCE35relations/30IDs/6sites/3fichiers ;V64030membres/18sites/8fichiers,union10fichiers/24ancres etdeuxconsommateursHUDcomplémentaires. DDS1ownHUD4224octets64DXT5/mipbrut0/membre248 ;provider/pixels ouverts.

DéfinitionTristana550aux18niveaux. Quatre scènes publiquesL1/L18,550sansmouvement/650poursuite43.332031jusqu’à606.667969 ;seuilcalculé615=550+replilocalGaren65,nativeradiusnullnoninventé.4lancements/8arrivées/7640ticksarchivés,pasd’impactsmesurés. PhaseXPniveaux36awards0tick,phaseportée2awards19245 ;278refuscommandes/10XP. Aucun E/Raccepté,croissanceexactef1ouverte. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2270 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1284 Trundle passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_TRUNDLE_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_trundle_passive_hud_20261105 :78/78 contrôles,65/65 cohérence séparée du même agent. 17 ancres/sept fichiers,27 fichiers code/configuration ;16 entrées communes et quatre identités V641 inchangées.

Acquis conservés : récepteur local après mort par dégâts, table communautaire2/3/4/5/6 %, rayon local1000, soin commun avec Ignite/W/plafond ; chemin statique health→Snapshot→receive→HPBar. QWER dispose déjà de rangs5/5/5/3 et quatre InventoryIcon. W partage Trundle_W.dds avec le buff ; cela ne prouve pas la liaison du passif. f2 natif et présentation spécifique restent ouverts.

Deux DDS propres2176 octets chacun,64 DXT1/mips bruts0/membre161 ; sélection E avant lectures SOURCE. V641 inspection465109 octets capturée une fois ; aucune copie/relecture du binaire V534787789824 octets ni1158 dépendances, neuf tests Trundle hérités parmi37 non relancés/non requalifiés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2271 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; aucune tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1285 Tryndamere passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_TRYNDAMERE_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_tryndamere_passive_hud_20261105 :89/89 contrôles corrigés,75/75 cohérence séparée du même agent. 16 ancres/huit fichiers,26 fichiers code/configuration ;16 entrées communes et14 identités V537 inchangées.

Battle Fury/PARType Battlefury/icone Tryndamere_Passive ; font1705/4292/4468. Deux diagnostics V537 hérités :frappe normale799, critique0 contre1,75 point selon texte ; mesures800/829/1009 toujours0. Sept secondes ne testent pas décroissance après8s. mana100 n'est pas un compteur Fury qualifié. HUD barres/nombres Mana-only omet ce type ; maxima QWER non intégrés. Réapparition actuelle remet le scalaire à0, fixture dédiée conservée ; aucune mécanique complète déduite.

Sept archives465003 octets et unique DDS2176 octets64 DXT1/mips bruts0/membre237 vérifiés. Aucun binaire1158 dépendances recopié/rejoué ; deux identités exécutables héritées explicitement non rehashées. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2272 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1286 Twitch passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_TWITCH_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_twitch_passive_hud_20261105 :112/112 contrôles,77/77 cohérence séparée du même agent. SOURCE60 relations/54 IDs,26 ancres/12 fichiers ;32 fichiers code/configuration,16 entrées communes et20 identités V642 inchangées.

Trois DDS64/sept mips : Twitch_Passive2872 DXT1/membre209 ; DeadlyVenom5616 DXT5/membre111 ; temp2872 DXT1/membre25. Priorité d'alias/provider/pixels ouverts. Font2816 six secondes/six cumuls/f1 inconnu ;2815 victime/SourceName ;4471/4295 nom/description. Neuf BuffData huit résolutions/Hide absent, sans alias. DDF Expunge;f1=.25 bonusAD, non passif. E communautaire magique/trois cumuls fixes non natif.

Archives L1/L18 :14 impacts physiques,455 frames d'attaque+362 post=817 paires PV recalculées float32/régénération ; aucun poison supplémentaire observé. Ignite séparé5×14 aux0/30/60/90/120, pas de paires PV brutes par frame ; pas de preuve Twitch.58 refus flags, six trajets,6818 ticks archivés, deux XP diagnostiques, aucune progression naturelle. Sept attaques ne qualifient pas le cap6.

Quatre archives2598280 octets, aucun binaire/dépendance rejoué ou copié. Identité binaire héritée6076928/6c937b15… non fraîchement rehashée. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2273 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1287 Udyr passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_UDYR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_udyr_passive_hud_20261105 :114/114 contrôles,76/76 cohérence séparée du même agent. SOURCE20 relations/15 IDs directs,19 ancres/sept fichiers ;27 fichiers code/configuration,16 entrées communes et15 identités V644 inchangées. Les78 voisins restent contexte, pas nouveaux liens.

Native :entrée en posture,+10 % AS,+5 MS,5 secondes,max3 ; quatre postures cinq rangs, Phoenix compris. Coûts47/44/41/38/35,CD6, rang6 absent ; GCD/portes non qualifiés. Marqueur UdyrPassiveBuff/BlindMonk partagé persistant distinct du bonus UdyrMonkeyAgilityBuff/Monkeys. Trois DDS4224 octets chacun, deux contenus64 DXT5,mips bruts1/0/1,membres153/25/25 ;12672 octets lus SOURCE après sélection E. Provider/pixels ouverts.

Deux cas Udyr L1/L18 :34 refus flags, deux paires initial/final égales,zéro tick, aucune posture acceptée. move_speed345 et périodes46/32 sont des stats calculées, pas attaques/déplacements mesurés. Un apport XP diagnostique. Garen Q témoin séparé :stat345→455.600006→345,45/46 ticks,deux refus ; pas AS Udyr ni durée native. HUD maxima non intégré,test de refus existant conservé ; slot3 générique3 incompatible statiquement avec Phoenix5, sans rendu rang4/5 reproduit.

Quatre archives1666950 octets ; binaire6010880/16d599de… hérité non rehashé, aucun replay/copie de binaire ou1158 dépendances. Toutes productions actuelles journalisées0. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2274 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1288 Urgot passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_URGOT_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_urgot_passive_hud_20261105 :113/113 contrôles,86/86 cohérence corrigée séparée du même agent. SOURCE18 relations/12 IDs directs,26 ancres/12 fichiers ;32 fichiers code/configuration,16 entrées communes et20 identités V645 inchangées.

Native15 %,durée2,5s/3s conservée non arbitrée ; font2844/2845/4298,nom4474. UrgotEntropyPassive→BuffName UrgotEntropyDebuff : indice client, pas preuve de priorité serveur. CharScript109 contientTeemo_EagleEye, contexte non corrompu/non substitué. Deux DDSUrgot_Passive2176 octets64 DXT1/mip brut1,membres174/25,un contenu ;4352 octets lus SOURCE après sélection E. Trois aliasTeemo manifest-only.

Archives L1/L18 :deux impacts publics,23 paires PV float32 reconstituées ;66 mesures de dégâts par API diagnostique Annie→Urgot, pas ripostes ordinaires. Ratios dérivés des Outcomes :1 après impact0/74/75/89/90/91 ;Exhaust distinct0,6/0,6/1 avant75 puis1. Politique Urgot bruts et durée non déduites d'Exhaust.62 refus flags,quatre trajets sans réordre,4207 ticks archivés,deux XP diagnostiques ;pas de progression naturelle.

Quatre archives1866884 octets ;binaire6072832/f31916c0… hérité non rehashé,aucun replay/copie du binaire ou1158 dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2275 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1289 Varus passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VARUS_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_varus_passive_hud_20261105 :225/225 contrôles,152/152 cohérence séparée du même agent. SOURCE17 relations/15 IDs directs,23 ancres/dix fichiers ;32 fichiers code/configuration,16 entrées communes et20 identités V646 inchangées. Reçu v645 hérité,lot V646.

Font2853 :f2 AS six secondes champion/assistance,f1 trois secondes sbire/monstre ;valeurs inconnues. Display2854/SourceName,DisplayMinion clé absente sans alias ;nom4475/description4299. Char56 vide,description Ashe et templates Disintegrate/Ziggs non promus. Trois préfixesPC0..17 seulement,48Lua/31limites ;Tracker=Q. Deux DDSshared2176 DXT1/mip0 et5616 DXT5/mip7,membres25/91,7792octets après sélection E ;provider/pixels ouverts.

Huit scènes API L1/L18 :morts/récompenses présentes,huit paires PV létales recalculées,périodes stats46/30 sans bonus dans56 échantillons postévénement ;aucune attaque ordinaire/portée/cadence de tirs validée. Trundle W séparé45→38→45 aux0/239/240/241.146refus flags,25689ticks,quatreXP diagnostiques ;pas progression naturelle complète ni expiration Varus qualifiée.

Quatre archives4908272octets ;binaire6073856/23c414ec… hérité non rehashé,aucun replay/copie du binaire ou1158 dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2276 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1290 Vayne passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VAYNE_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_vayne_passive_hud_20261105 :128/128 contrôles corrigés,132/132 cohérence corrigée du même agent. SOURCE15 relations/13IDs directs,24ancres/dix fichiers ;32fichiers code/configuration,16communs et20identités V647 inchangées.

Native+30 vers champions ennemis proches ;R+90,durées8/10/12,AD30/50/70. Rayon/angle/visibilité ouverts. Font4476/4300,2861/11989. Focus sous Ashe existant,contexte non producteur Vayne ;Char/Hunted56 vides,18Lua/deuxlimites. Icône propre Info2176 DXT1/mip1,membre30,SHA f8a20962… vérifiée après qualification de filtre ;aucun faux manque ni DDS étranger/particule.

L1/L18 :60vecteurs de déplacement recalculés,vers/opposé/latéral,vitesse330/pas11 ;20mesures immobiles,quatre trajets publics arrivés sans réordre. Cosinus de mouvement non facing natif. R non activé/refusé ;GarenQ séparé345→455.6→345,15vecteurs et44/45/46.60refus flags,4952ticks,unXP diagnostique ;aucune mort/fin de partie ou progression naturelle complète.

Onze archives2674028octets ;premiers échecs unreachable/Focus conservés,binaire6086656/53a17239… hérité non rehashé,aucun replay/copie du binaire ou1158dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2277 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1291 Veigar passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VEIGAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_veigar_passive_hud_20261105 :137/137 contrôles,112/112 cohérence séparée du même agent. SOURCE10 relations/5IDs,six sites ;quatre directs V554,23ancres/dix fichiers ;30fichiers code/configuration,16communs et18identités V554 inchangées.

Font2866/4301 :+1%regen par1%mana manquant,nom4477. Ancien Mundo/+40/60/80%/niveaux1/9/17 non adopté. Lua349 sans callback,flags non exécutés. Absence CharScript seulement Scripts ;cinquième identité enregistrée à racine Veigar/CharScriptVeigar.luaobj,56/SHA7402c822…/membre254,aucune relecture native. Deux noms Veigar_Entropy/VeigarEntropy,octets identiques4224 DXT5/mip1,membres237/25,SHA40d8b895… ;8448octets après sélection E,provider/pixels ouverts.

Quatre cas L1 publics :Veigar plein/Sapphire/Sapphire+Charme,Annie Sapphire.116paires mana pré-fontaine recalculées,dont87non écrêtées ;Veigar déficitaire36.87316%,taux1.2 ou1.5 avecCharme,aucun supplément observé. Quatre ticks30 fontaine15% séparés ;32refus flags,aucune injection/XP/sort fonctionnel. Ancienne correction binary64→f32 réutilisée,sans replay.

Six archives1749364octets ;binaire6025216/c98bd9d0… hérité non rehashé,aucun replay/copie du binaire ou1158dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2278 entrées sales groupées conservées. Toutes productions actuelles0. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1292 Velkoz passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VELKOZ_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_velkoz_passive_hud_20261105 :114/114 contrôles,107/107 cohérence séparée du même agent. SOURCE25 relations/19IDs,six sites ;29ancres/13fichiers,36fichiers code/configuration,16communs et24identités V648 inchangées.

Font2868 :troisième touche de sort→f1vrais,caducité7s ;attaques ordinaires rafraîchissent sans ajouter. Texte cible2871/attacks non promu contre règle précise ;nom4478/description4302.36Lua/12limites,36DDFvides,63voisins contexte. f1/niveaux/lifecycle ouverts. Deux DDS2176 DXT1/mip0,membres200/25,SHA16cb534e…/ce1936a3… ;4352octets après sélection E. Proc VelkozPassive.dds absent du manifeste70286,sans réécriture vers Velkoz_Passive.

L1/L18 :six impacts physiques non critiques,196pairesPV d’attaque+422post=618 recalculées ;211ticks par cible non marquée ne prouvent ni génération/refresh/expiration. Ignite séparé5×14 aux0/30/60/90/120,absent150 ;181frames dérivées,sansPVbruts individuels.58refus flags,six trajets publics sans réordre,6532ticks,deuxXP diagnostiques ;pas progression naturelle/fin de partie.

Sept archives2579655octets ;binaire6077952/77a57a99… hérité non rehashé,aucun replay/copie du binaire ou1158dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2279 entrées sales groupées conservées. Toutes productions actuelles0. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1293 Vi passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VI_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_vi_passive_hud_20261105 :143/143 contrôles,120/120 cohérence séparée du même agent ;HUD supplémentaire4/4 corrigé. SOURCE22 relations/16IDs,six sites ;31ancres héritées/13fichiers,deux pointsHUD supplémentaires,35fichiers code/configuration,16communs et23identités V649 inchangées.

Native10%PVmax/3s après touche de compétence activée ;f2/f3/recharge ouverts. Nom4479,Marker2891,Buff2889,Ready2892 ;description4303 etCooldown2890 contexte,PassLev1Desc1 absent non inventé. Aucun fichierCooldown parmi114candidats ni70286membres sélectionnés,absence bornée. Char56 vide,55Lua/neuflimites,98voisins contexte. Trois DDS7920octets64DXT1,mips7/7/1,membres139/25/40 ;icônes étrangères partagées non mécaniques importées.

L1/L18 :deux impacts de mêlée,41pairesPV recalculées ;cinq relevés vides aux0/89/90/91/95,95ticks d’assertions non expiration native. Barrière115/455,60ticks,24paires API PV/bouclier aux0/59/60/61 ;12absorbées,12après expiration. Recharge6300 seulement enregistrée/refusée,pas retour testé.60refus publics+14API flags,quatre trajets sans réordre,4121ticks,deuxXP diagnostiques ;pas progression naturelle/fin de partie.

main.rs1675 texte générique de somme des boucliers actifs conservé ;native_hud_bars.rs32 garde shields pending. Aucun rendu frais. Quatre archives2248713octets ;binaire6098432/3a1ce44c… hérité non rehashé,aucun replay/copie du binaire ou1158dépendances. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2280 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche/feature/inconnue/acceptation close.


## Reprise SYS-01.2-02 — V1294 Viktor passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VIKTOR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_viktor_passive_hud_20261105 :173/173 contrôles,95/95 cohérence séparée du même agent ;30ancres héritées et10repères HUD,32fichiers code/configuration,16communs/16identités V650 inchangées. SOURCE41relations/37IDs ;17INI/15Lua/4preload/font. Alias ViktorBlah,APPerLev StormTimer/Guide et sept augmentations :métadonnées,sémantique serveur/f1/lifecycle ouverts.

3200/3196/3197/3198 :AP par niveau3/4/5/6,fixe0/20/40/60,mana0/150/300/500,prix0/1000/1000/1000,recettes chaînées,restrictionViktor/invendables. Quatorze clés font exactes. Cinq DDS10880octets64DXT1/mip0,membres251 ;InventoryIcon réutilisé depuis décodage local/empreintes natives concordantes,sans INIBIN relu. Guide et stem ViktorBlah absents du manifeste70286,absence bornée.

Inventaire/HUD/recettes/descriptions génériques existants conservés ;quatreIDs absents des catalogues runtime/icônes/admission,ni interdiction native Map10 ni restriction champion prouvées. Archives L1/L18 :prototype non accordé,AP0 contre texte3/54 ;70refus publics flags,8quotes,12commandes témoins distinctes,180ticks sans180frames,uneXP diagnostique. Ancien BUILD0/RUN101 slot[1029] vs[0] conservé ;correction exacte de deux lignes du collecteur,BUILD/RUN0 hérité. Onze archives3489792octets,binaire6034944/ba4d8b7f… non rehashé/rejoué ;aucun build/jeu neuf.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2281 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche,feature,inconnue ou acceptation close. Prochain candidat :Vladimir.


## Reprise SYS-01.2-02 — V1295 Vladimir passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_VLADIMIR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_vladimir_passive_hud_20261105 :114/114 corrigés,76/76 cohérence séparée du même agent ;16ancres,27fichiers code/configuration,16communs/15identités V545 inchangées. SOURCE10relations/7IDs :2INI/2Lua/2preload/font. Noms/description/buff4481/4305/2905 ;40PV bonus→1AP,1AP→1,4PV,sans cumul ;f1/f2/ordre/arrondis/lifecycle ouverts. TextesRyze/AP30/45/60/niveaux1/6/16 non adoptés.

Deux DDS propresInfo/partagés5744octets64DXT1/mip7,membres25,mêmeSHA77b487be… ;priorité/rendu ouverts. Quatre cas niveau1,deux ordresRuby1028/Tome1052 avec Ahri témoin :144statistiques recalculées,Vladimir692,7999878PV/20AP contre prédiction720,7999878/23,75 ;conversions absentes.30ticks stables/cas ne valident pas non-récursivité absente. Financement public8or2250/2400,20refus groupés selon portée,ventes591or/capacités restaurées,9720ticks sans autant de frames.

Sept archives1375927octets ;binaire6005760/6257760d… hérité non relu/rejoué,aucun build/jeu neuf. HUD génériqueHPStat/barres existant conservé,ressourceNone ;pas de liaison CrimsonPact/f1/f2 établie. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2282entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1296 Volibear passif HUD icône et état

Audit documentaire borné :docs/AUDIT_SYS01202_VOLIBEAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_volibear_passive_hud_20261105 :86/86 contrôles,70/70 cohérence séparée du même agent ;16ancres,27fichiers code/configuration,16communs/15identités V541 inchangés. SOURCE16relations/13IDs :4INI/5Lua/3preload/font ;trois infobulles2914–2916,seuil30%/6s/2min,f1/disponibilité ouverts. BuffTextureName avec espace final préservé,HealCheck priorité8/Blitzcrank pas callback/bouclier ;CharScript56vide.

Trois DDS15456octets64DXT5,mips7/7/1,membres62,normaux mêmeSHA39431236…/gris2852ff20… ;définition/Heal justifient nom normal,sans trim de la déclaration avec espace. Deux cas niveau1 :20paires de frappes ordinaires,franchissement34,776→26,950% au1364 ;720pairesPV des fenêtres180ticks recalculées,aucun résidu ordinaire,potion témoin+59,9990845PV.8refus strings,sans tous états bruts ;4Move,3088ticks,potion270ticks restants,pas expiration/recharge/égalité/réactivation natives prouvées.

Cinq archives1484091octets,binaire5943808/f080fab3… hérité non relu/rejoué,aucun build/jeu neuf. HUD génériquePV/Mana conservé ;f1/état disponible-soin-recharge non lié. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2283entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1297 Warwick passif HUD icône et état

Audit documentaire borné :docs/AUDIT_SYS01202_WARWICK_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_warwick_passive_hud_20261105 :68/68 contrôles,66/66 cohérence séparée du même agent ;14ancres,28fichiers code/configuration,16communs/16identités V539 inchangés. SOURCE12relations/9IDs :3INI/3Lua/2preload/font,6bots exclus. Métadonnées absentes du JSON primaire,récupérées depuis découverte archivée ;Lua159/218/114 sanscallback,CharScript114nonvide. Noms4483/liens1874/1876,voisin1877non substitué ;f1/magique/soin/cumul ouverts.

Deux DDS8448octets64DXT5/mip0,WarwickInfo membre40 SHA0af60605…/Wolfmanpartagé membre25 SHA364deb38…,contenus différents,priorité/rendu ouverts. Deux cas niveau1 :12frappes Warwick,24pairesPV source/cible recalculées,6blessuresGaren,10relevés horsfrappe. Régénération avant attaques et plafond cible pleine expliquent le physique/voldevie courant. Sixrésidus0 sansobjet,4,54333496PV avec1053 ;pas EternalThirst accepté.6refus strings,4Move,2238ticks,sans toutesframes.

Cinq archives876167octets,binaire5943808/7a117a4f… hérité non relu/rejoué,aucun build/jeu neuf. HUD génériquePV/Mana conservé ;f1/cumul non liés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2284entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1298 Wukong MonkeyKing passif HUD icône et état

Audit documentaire borné :docs/AUDIT_SYS01202_MONKEYKING_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_monkeyking_passive_hud_20261105 :134/134 corrigés,127/127 cohérence séparée du même agent ;34ancres,43fichiers code/configuration,16communs/31identités V603 inchangés. SOURCE67relations/64IDs :19INI/27Lua/16preload/DDF/font ;23NightmareBots exclus. f1/rayon/niveaux/éligibilité ouverts ;600 observationnel. CassiopeiaBuff metadata,1candidatforeignHUD manifeste4224membre248 non lu,ni absentglobalement ni mécanique adoptée.

Deux StoneSkinDDS4352octets64DXT1/mip1,membres40,mêmeSHA19cb76df… ;propreInfo2176 lu SOURCE,partagé2176 réutilisé depuis Vi avec identitéE vérifiée,sans nouveauDstat/read. Deux cas6joueurs :comptes0/0/1/2/3/3/2/1/0 aux36snapshotsbornes,540framesstats ;armure/RM24,879999/32,099998 et39,879997/57,099998 constantes.28arrivées représentées par18reçus,4reprises explicites,54refusflags,6projectilesphysiques/2QAnnie ;6valeurs physiques sansPVbruts pré-impact,2endpointsQ dérivés sur12ticks chacun,5008ticks sans toutesframes.

Vingt archives8666260octets,3anciens BUILD0/RUN101 setup conservés ;binaire6129664/f9089daa… hérité non relu/rejoué,aucun build/jeu neuf. Initial132/134 qualifié :SETUP_FAILED4/6 etbasef32avant+15 ;2contrôles/1champdérivé corrigés,132autres/tousautreschamps exacts,sans replay. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2285entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1299 Xerath passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_XERATH_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_xerath_passive_hud_20261105 :107/107 contrôles,93/93 cohérence séparée du même agent ;29ancres,38fichiers code/configuration,16communs/26identités V651 inchangés. SOURCE18relations/12IDs :4INI/4Lua/3preload/font ;28Lua/13limites. f1/f2/f3, disponibilité, cooldown et lifecycle ouverts ; ni12secondes ni ratio2 adoptés. Deux DDS6400octets, propre HUD2176 DXT1/mip0 membre196 SHA7925c8d5… et partagé4224 DXT5/mip1 membre48 SHAde7dfafe… ; priorité/rendu ouverts.

Deux cas niveaux1/18,1111paires mana brutes (209attaque/902potion),6paires PV cible recalculées ;60refus flags,8arrivées Move,3XP diagnostiques,4599ticks sans toutesframes. Potion450actives+1post-expiration/cas ; régénération/potion distinctes du passif. Correction du MD V651 conservé : zéro saturation observée, plafonnement non vérifié ; fin439,60788/516,95996 et1287,12085/1315,95996. Déficit nominal200, réel L1 199,99996948 par f32. Rayon fontaine1000 et pool conservé sont des politiques actuelles.

Dix archives4186525octets ; ancien BUILD0/RustRUN101 et une ligne de placement/diagnostic modifiée conservés. Binaire6074880/be65856d… hérité non relu/rejoué, aucun build/jeu neuf. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2286entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1300 Xin Zhao passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_XINZHAO_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_xinzhao_passive_hud_20261105 :138/138 contrôles,122/122 cohérence séparée du même agent ;28ancres,36fichiers code/configuration,16communs/24identités V652 inchangés. SOURCE17relations/14IDs :6INI/3Lua/3preload/DDF/font ;17Lua/13limites. Contrat textuel15%/3secondes/une cible/attaque ou E ;ordre,renouvellement/transfert et lifecycle ouverts. MasterYi Passive1Desc anomalie non adoptée, W troisième frappe distinct ;XenZhaoIntimidate.luaobj/XinZhaoIntimidate BuffName conservés.

Deux DDS4352octets64DXT1/mip1, propre Info membre40/partagé111, même SHAc629b1cd… ; priorité/rendu ouverts. Quatre cas niveaux1/18 avec/sans1029 :366paires PV/armure brutes dont12impacts recalculées,20snapshots offsets0/89/90/91/95 reconstitués sur95ticks/cas, pas380frames brutes. Armure87,220001/102,220001 constante ; mitigation de l’objet témoin distinct. Expiration non qualifiée sans activation.108refus flags,8arrivées Move/Stop,6XP diagnostiques,8334ticks sans toutesframes.

Six archives3822322octets ; binaire6059520/ff455a74… hérité non relu/rejoué, aucun build/jeu neuf. Inspection anchorchecked pub(crate) conservée ;erreur/script avant correction non recapturés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2287entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ; zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1301 Yasuo passif HUD icône et état

Audit documentaire borné HUD : docs/AUDIT_SYS01202_YASUO_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_yasuo_passive_hud_20261105 :80/80 corrigés,77/77 cohérence séparée du même agent ;12ancres+5relevés HUD,31fichiers code/configuration,16communs/16identités V536 et8identités V808 inchangés. V808 core réutilisé,sans seconde clôture. Métadonnées absentes du primaire V536,récupérées V533/découverte qualifiée ;3sources natives,4relations SOURCE. Lua182 sanscallback,BuffNameYasuoPassive/BlindMonkWOne/PersistsThroughDeath metadata.

Font natif buff2957 : Flow/mouvement/vitesse/bouclier au maximum,champion/monstre,f1 ;critique doublé mais dégâts critiques-10%,f2. SpellTooltip12040 contradictoire (réduction aprèscapacité2s,20%+1%par4AD),sélection runtime ouverte. DDS propre2176 DXT1/mip0,membre191,SHAd28ee7a9… ;candidatBlindMonk LeeSin/HUD2872,membre188,manifeste seulement,ni absentglobalement ni substitué. Wind local n’alimente ni MPBar ni MPStat (gardes Mana) ;HP/Barrière conservés. Sixicônes QWER ne sont pas le passif.

Neufarchives9497538octets ;12relevés statistiques immédiats/aux ticks30/60/90/120 :Yasuo8/16/8% contre comparateur16/32/16%,Garen8% témoin ;multiplicateur dégâts2 distinct. Deux binaires5410304/bb0795ac… et5967360/eead663c… hérités non relus/rejoués ;aucun build/jeu neuf. Trois contrôles initiaux code1 conservés :2conteneurs membership,1attendu de motif (production91/test156,module130). Qualification1prédicat,79autres/tousautreschamps inchangés,sans replay. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2288entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1302 Yorick passif HUD icône et état

Audit documentaire borné HUD : docs/AUDIT_SYS01202_YORICK_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_yorick_passive_hud_20261105 :100/100 contrôles,89/89 cohérence séparée du même agent ;32ancres,37fichiers code/configuration,16communs/25identités V653 inchangés. SOURCE33relations/30IDs :13INI/11Lua/4preload/DDF/font ;41Lua sanscallback/limite,4CharScript vides. Texte5%attaque/réduction par invocation et35%AD/PV ;catégories,cap,cumul et snapshot ouverts. Trois personnages goules distincts des sorts homonymes,bases60PV/10AD non finales ;E DDFbonusAD/communautéAP non assimilés.

Deux DDS4352octets64DXT1/mip1,membres36,mêmeSHA5852ca4a… ;priorité/rendu ouverts. Deux cas Yorick1/18,zéro invocation :6résumés physiques sansPVbruts pré-impact,6pairesPV API serveur recalculées (pas sorts ennemis),endpoints finaux reconstruits,sans toutesframes. Témoin Tibbers distinct :apparition8,vie1350,1200PV/80AD/30armure,guideMove accepté ;samples1/1349/1350/1351 propriété1/1/0/0,lookup22/22/None/None,unité encore présente0PV après expiration. Pas d’acceptation de scaling Yorick.

57refus flags,4Move/Stop arrivés,4XP diagnostiques,5542ticks=2109+2074+1359. Sixarchives3385721octets ;binaire6074368/0809d39d… hérité non relu/rejoué,aucun build/jeu neuf. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2289entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1303 Zac passif HUD icône et état

Audit documentaire borné HUD : docs/AUDIT_SYS01202_ZAC_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_zac_passive_hud_20261105 :148/148 récupérés,147/147 cohérence séparée du même agent ;28ancres,34fichiers code/configuration+compteur générique,16communs/22identités V654 inchangés. SOURCE45relations/39IDs :8INI/15Lua/14preload/DDF/font ;29Lua sanscallback,2limites. Texte4%soin,4bloblets8secondes,10–50%PV,12%PVmax/50%défenses,5min ;f1/disponibilité/formule ouverts. Jax Passive1Desc et9/3/7/11/15/null/null bruts non adoptés. TestCubeRender10Vision distinct deZacRebirthBloblet,bases1PV nonfinales.

Trois DDS9272octets :ZacPassive2176 DXT1/mip0/db39a6a6…,Inactive2872 DXT1/mip7/32ef628d… membres155 ;Chargingpartagé4224 DXT5/mip1/430c2239… membre107,montage/rendu ouverts. Quatre cas Zac/Annie1/18 :120pairesPV régénération,4pairesclamp,8pairesfatales,64étatsde mort/réapparition ordinaires480/1110ticks,PV0 à240ticks,sansblob.72refus publics+36API flags,2XP,10384ticks,sans toutesframes. Soins40/API etréapparition normale ne sont pas ramassage4%/renaissance. Compteur réel pub(crate) countdown→respawn_at,calculceil etgarde connexion/session inspectés ;dérivationstatique,pas Bevy exécuté.

Sixarchives3752729octets,binaire6098944/611f4c26… hérité non relu/rejoué ;aucun build/jeu neuf. Deuxcontrôles code1 conservés :JSONset (recovered surcaptures,préfixeoriginalexact,zéroF/D reread) etancrepubfn au lieupub(crate) (sourceEreprise). Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2290entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1304 Zed passif HUD icône et état

Audit documentaire borné HUD : docs/AUDIT_SYS01202_ZED_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_zed_passive_hud_20261105 :142/142 contrôles,175/175 cohérence séparée du même agent ;26ancres,33fichiers code/configuration,16communs/21identités V655 inchangés. SOURCE22relations/16IDs :5INI/7Lua/2preload/DDF/font ;49Lua sanscallback,12limites. Texte sous50%,6–10%PVmaxmagique,10s/cible ;f1/paliers/ordre/plusieurslanceurs ouverts. WbonusAD/AkaliDDF distincts ;alternatives Akali/Ziggs metadata,sans priorité adoptée.

Trois DDS7920octets64DXT1 :ShadowNinja_P2872/mip7/membre134/SHA5c48281e…,Akali partagé2872/mip7/membre25/SHA3664dcef…,ZiggsReady partagé2176/mip1/membre71/SHA22eef7e1… ;montage/rendu ouverts. Sixcas niveaux1/18×60/50/40% :18pairesPV physiques,6pairesAPI magique,8préparationsAPI,18snapshots fenêtre299/300/301 recalculés. Deuxégalités50% **après régénération avant physique**,pas au début du tick ;ordre natif non qualifié. Aucun proc,donc pas expiration CD acceptée.162refus publics+18API flags,12arrivéesMove/Stop,9XP,13362ticks sans toutesframes. RessourceEnergy horsgardesMana,HPHUD présent.

Cinqarchives4722785octets,binaire6072320/e580595b… hérité non relu/rejoué ;aucun build/jeu neuf. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2291entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1305 Ziggs passif HUD icône et état

Audit documentaire borné HUD :docs/AUDIT_SYS01202_ZIGGS_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_ziggs_passive_hud_20261105 :162/162 contrôles,128/128 cohérence séparée du même agent ;26ancres,34fichiers code/configuration,16communs/22identités V656 inchangés. SOURCE16relations/14IDs :5INI/5Lua/3preload/font ;29Lua sanscallback,17limites NEWTABLE. Texte12s,réduction4s,150%structures,f1/f2 ouverts ;SpellData Disintegrate/ZiggsW/cinq12/PLACEHOLDER non adoptés comme formule.

Deux DDS4352octets64DXT1/mip1,membre71,mêmeSHA22eef7e1… ;propreInfo2176 lu SOURCE,partagé2176 réutilisé Zed sans nouveauDstat/read. Quatre cas1/18×AP0/20 :12résumés physiques sanspairesPVbrutes,12snapshots359/360/361/endpoints reconstruits. Aucun proc,donc pas expiration ni réduction4s acceptées,structures non testées. Deux pairesPV AnnieQ distinctes recalculées :Q avantregen,attaques après.118refus flags,12arrivées sansreprise,8XP,3achats1052,13272ticks sans toutesframes ;ManaHUD présent,sansbinding ShortFuse.

Septarchives5515259octets,binaire6094848/0dad4a3a… hérité non relu/rejoué ;premierRustRUN101 etdiffcollecteur conservés. dds01 code2 rôleSOURCE rejeté avant install/script ;dds02 source0,preuves conservées. Aucun build/jeu neuf. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2292entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1306 Zilean passif HUD icône et état

Audit documentaire borné HUD :docs/AUDIT_SYS01202_ZILEAN_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_zilean_passive_hud_20261105 :326/326 contrôles,228/228 cohérence séparée du même agent ;28ancres,30fichiers code/configuration,16communs/18identités V657 inchangés. SOURCE9relations/6IDs :2INI/2Lua/preload/font ;11Lua sanscallback,3limites. Texte8%XP pour Zilean/alliés proches,rayon inconnu. Heightened Learning/HeightenedLearning/heightenedlearning conservés,sans résolution native présumée.

Deux DDS8448octets64DXT5/mip0,membres40/25,mêmeSHA9c043740… ;montage/rendu ouverts. Quatre cas Zilean/Annie,allié200/6527,63 :24pairesXP directes+48comparaisons autresjoueurs ;16décèsAPI,48pairesXP et16pairesPV fatales recalculées. Sbire32/32ou64/0,monstre12,tourelle70par allié,champion220au tueur,sans8%observé. Rayonpartage1250 distinct de portéeaura.60refus publics+52XP+16deadflags,6arrivées,12208ticks sans toutesframes. LevelStat litniveau,HP/Mana présents ;pas de bindingaura.

Cinqarchives9482170octets,binaire6144000/f52dbb8a… hérité non relu/rejoué,aucun build/jeu neuf,aucun échec nouveau des producteurs. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2293entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1307 Zyra passif HUD icône et état

Audit documentaire borné HUD :docs/AUDIT_SYS01202_ZYRA_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_zyra_passive_hud_20261105 :342/342 contrôles,310/310 cohérence séparée du même agent ;28ancres,34fichiers code/configuration,16communs/21identités V658 inchangés. SOURCE42relations/39IDs :12INI/15Lua/10preload/DDF/font ;56Lua sanscallback,21limites. Texte2s/8s/tircurseur/f1brut ;producteurs/bornes ouverts.44DDF,seulZyraSeedf1 rempli,pas formulepassive. Deuxhomonymes CharScript conservés par chemin complet.

Deux ZyraPDDS5744octets64DXT1/mip7,membres111,mêmeSHA0eb88fa1… ;KogMaw/KogMawDead deuxcandidatsmanifesteseulement,non résolu own/shared,ni absenceglobale ni substitution. Quatre cas Zyra/Annie1/18 :8pairesPV fatalesAPI,88états/PV ennemis recalculés,respawns480/1110 ordinaires ;672dead+48livingrefus publics,16dead+12invalidAPI flags,4pairesAPI40True distinctes,8arrivées,6XP,14076ticks sans toutesframes. Aucun proc/forme/tir natif accepté. CompteurHUDceil réel4926/96798238… inchangé,dérivé sans Bevyexécuté ;HP/Mana présents.

Sixarchives6781239octets,binaire6085120/9da4d1ea… hérité non relu/rejoué,aucun build/jeu neuf,aucun échec nouveau des producteurs. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2294entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1308 couverture des liens HUD de passifs

Consolidation documentaire bornée :docs/AUDIT_SYS01202_PASSIF_HUD_COVERAGE_RECONCILIATION_2026-11-05.md. Corpus122IDs HUD passifs (1098autres rôles exclus) :117rapports individuels,114chaînes standard et3formatsanciens Ahri/Annie/Ashe conservés (F=E,25/44/72statiques,chronologie sansreçu standard nonreconstruite).352identités F/4702associations concordantes,dixentrées snapshotinchangées,aucundoublon,844/844cohérence séparée du même agent. Ezreal V226 retrouvé :9fichiers/29ancres inchangés,quatretests historiques nonrelancés ;pas besoin de refaire ce lien borné,fullHUD/ZIP provenance/rendu restentouverts.

118périmètres de liaison déjà documentés,quatre audits HUD ciblés restants :Fiora,Gnar,Kalista,TwistedFate. Aucune absence d’implémentation déduite d’un nom de rapport. Liste122 etIDs/inconnues exacts :E:/mapslol3v3/audit_sys01202_passive_hud_coverage_20261105/coverage_review.json. Aucun nouvelauditindividuel,feature,inconnue ou acceptation close ;goal actif. Aucun D/build/jeu/REA/GPU ;grands registres hashés,sans nouveauparseJSON. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2295entrées sales groupées conservées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1309 Fiora passif HUD icône et état

Audit documentaire borné HUD :docs/AUDIT_SYS01202_FIORA_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_fiora_passive_hud_20261105 :55/55 corrigés,56/56 cohérence séparée du même agent ;27ancres,30fichiers code/configuration,16communs/18identités V662 inchangés. SOURCE24relations/21IDs :6INI/9Lua/4preload/DDF/font ;28Lua sanscallback,6limites. Texte6s/4cumuls/f1inconnu ;description générique et buffphysique distincts,DDF Q/R non adopté comme soin.

Deux DDS11232octets64DXT5/mip7,membre79,mêmeSHAf519d597… ;montage/rendu ouverts. Catalogue Fiora6entrées QWER dont2variantes Q/R,aucune Duelist ;HP/Mana présents,pas de bindingétat/cumul/f1. V662 réutilisé :24attaques/24fenêtres181ticks,API etpréparations distincts,60refus publics/40API,12768ticks ;pas de recalcul/replay. Deuxarchives1348669octets,binaire6116352/267c7eec… hérité non relu ;ancienRUN/rawprobe9444523 non rouvert.

Premier contrôle54/55/code1 conservé :attendu4icônes trop étroit ;qualification1prédicat surcaptureE,54autres/tousautreschamps identiques,source produit inchangée. Aucun build/jeu neuf. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2296entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1310 Gnar passif HUD icône et état

Audit documentaire borné : docs/AUDIT_SYS01202_GNAR_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_gnar_passive_hud_20261105 :73/73 qualifiés,60/60 cohérence séparée du même agent ;30ancres,33fichiers code/configuration,16communs et21identités V571/V572 inchangés. SOURCE30relations/24IDs :7INI/9Lua/7preloads/font ;cinq limites NEWTABLE. Mini/Mega même icône,Gnarfury,PARStart inconnu ;texte15s,f1/f2/f3/f4/f5/f7/f8 nonrésolus.

Une DDS2176octets64DXT1/mip0,membre244,SHAf923dc37… ;montage/rendu ouverts. HUD PV présent,barre/MPStat Mana-only excluent Gnarfury ;QWER4primaires+8variantes sans passif,EzrealBuff0 spécifique. V571 hérité :100/100 saturé,12impacts/48refus/1800tail ;V572 :42impacts préparent3morts,respawn480ticks→0/100,puis12impacts sansgain,54refus/1800tail. Deux anciens RUN101/dégâts ambigus conservés ;pas de replay/recalcul/build neuf.

Premier contrôle72/73/code1 conservé :unique hitGnar est un testcatalogue animation spell4/Ashe ;qualification1prédicat,72autres/tousautreschamps identiques. Troisarchives1425091octets,deuxbinaires historiques nonrelus. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2297entrées salesgroupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;aucunefonctionnalité,inconnue,acceptation ou tâche complète close.


## Reprise SYS-01.2-02 — V1311 Kalista passif HUD icône et état

Audit documentaire borné :docs/AUDIT_SYS01202_KALISTA_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kalista_passive_hud_20261105 :69/69 documentaires,63/63 cohérence séparée du même agent ;32ancres,34fichiers code/configuration,16communs/22identités V663 inchangés. SOURCE31relations/25IDs :7INI/11Lua/5preloads/DDF/font ;114Lua natifs déjàlus,24limites. AliasKalistaPassiveBuff/iconeKalista_Passive ;PassLev1Desc1 absent,description4209 nonliée ;25% arrière/paliersbottes textuels,formules ouvertes.

DDS2176octets64DXT1/mip0,membre0.0.1.7,SHAdb6ca23d… ;montage/rendu ouverts,aliasesCommander/Shen/Rumble contexte distinct. Acquis cant_cancel=true natif conservé ;Move passe par cancel_windup avant destination,aucunbond établi. HUD HP/Mana générique,QWER4primaires+2variantesE sanspassif,EzrealBuff0 spécifique. V663 hérité :8cas,20attaques/24essais,12refusKalista/12acceptésAnnie,132refus publics dont12windup,4achats/40trajets/12XP/16860ticks ;pasde replay/recalcul.

Deuxarchives2119797octets,binaire6100992/ea537189… etancienprobe7509876 nonrelus. Aucun build/jeu neuf,septopérations matérialisées réussies si publicationgates validées. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2298entrées salesgroupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1312 Twisted Fate passif HUD icône et état

Audit documentaire borné :docs/AUDIT_SYS01202_TWISTEDFATE_PASSIF_HUD_ICON_STATE_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_twistedfate_passive_hud_20261105 :68/68 documentaires,64/64 cohérence séparée du même agent ;18ancres,31fichiers code/configuration,16communs/19identités V643 inchangés. SOURCE11relations/8IDs :7ressources sélectionnées (2INI/2Lua/preload/DDF/font) plus anciencandidat S5Test_DragonBuff OLS-aada795c… résolu par IDdans snapshot,nonpromu en policy/runtimealias.

Second Sight aliasespacé,SecondSight.lua ;texte1à6or/f1 contredit ancienPassive1Desc critique,choixhistorique inconnu.12Lua/7limites,2chunksdirects littérauxsanscallbacks,DDFW nonpassif. DeuxDDS8448octets64DXT5/mip0,membres40/25,mêmeSHA89fe52b4… ;montage/rendu ouverts. HUD GoldStat=portefeuillefloor,nonf1 ;QWER4primaires sanspassif,EzrealBuff0 spécifique. V643 APIhérité :12monstres/22refus/6000ticks,base33/18/18/48/38/28,supplément0 ;pas d'attaqueordinaire ni replay/recalcul.

Deuxarchives1134350octets,binaire5703168/01335653… etancienprobe216886 nonrelus. Aucun build/jeu neuf. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2299entrées salesgroupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;zéro tâche complète,feature,inconnue ou acceptation close.


## Reprise SYS-01.2-02 — V1313 consolidation des 122 liens HUD de passifs

Consolidation documentaire bornée :docs/AUDIT_SYS01202_PASSIF_HUD_COVERAGE_DELTA_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_passive_hud_delta_20261105 :386/386contrôles ;baselineV1308 inchangée118périmètres+4audits déjàpubliés Fiora/Gnar/Kalista/TwistedFate=122IDs.121rapports (118chaînesstandard+3formatsanciens Ahri/Annie/Ashe) etEzrealV226 ciblé conservés. Aucun doublon ni inconnue réaffectée.490identités F/4977associations concordantes,10amont/septregistres inchangés ;504chemins/1136693453octets hashés sans copie ni grandparseJSON.

Aucune nouvelle clôture individuelle oufonctionnelle ;aucune tâcheHUD complète,feature,inconnue,acceptation ougoal clos. Anciensdiagnostics/binaires/tests hérités,nativeD/build/jeu/REA/GPU nonrelancés. Qualifications Fiora/Gnar etancienséchecs conservés ;Ezreal9identités/29ancres/4tests historiques,formatsanciens nonnormalisés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2300entrées salesgroupées conservées. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1314 couverture préalable des VFX de passifs

Examen documentaire préalable :docs/AUDIT_SYS01202_PASSIF_VFX_COVERAGE_PREFLIGHT_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_preflight_20261105 :636/636contrôles,122IDs rapprochés de V669121 + V668Annie. Seize ancres exactes,15fichiers inspectés,9comparaisons anciennes concordantes ;516identités/498fichiers Rust inchangés,516/516 et sept registres protégés exacts. Anciennes recherches lexicales réutilisées ;aucun nouveau scan Troy,probe,build,jeu,GPU ou décodage natif.

V669 :20mentions nommées,267champs absents,37vides ;481requêtes héritées142résolues/339sans résultat,504associations,non comptes d'assets manquants. Annie :effet de base partiel conservé,98champs/4textures historiques ;ready2/Freljord/attaches/audiences/fidélité ouverts. Diagnostic encore limité à E:\OpenLeague\logs ligne113,non exécuté. Premier bootstrap code1 sur format prérequis Annie conservé ;reprise code0 avec field.required_package_ids sur témoins E,aucun produit modifié.

Aucune nouvelle clôture individuelle ou fonctionnelle ;seul examen préalable borné. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2301entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Akali-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1315 Akali passif VFX source et déclenchement

Audit documentaire borné :docs/AUDIT_SYS01202_AKALI_PASSIF_VFX_SOURCE_TRIGGER_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_akali_passive_vfx_20261105 :49/49documentaires,53/53cohérence séparée du même agent ;23ancres,30fichiers courants,14comparaisons V557/14sélectionnées V1314 inchangées. Deux déclarations DMG/L_hand et AP/R_hand,candidats Troybin connus ;icône33 différente des icônes TwinAP/TwinDmg,graphies et métadonnées conservées,sans callback/condition native prouvés.

Résolveur de noms et briques spatiales/attache/stop existants ;pas de liaison spécifique Twin dans les DTO/routes inspectés. Relic expose sous-catalogues DDS9/17,pas un ouvreur de ces Troy ;Map10 précis26définitions/52groupes sans Twin,non absence globale d'assets. Résolutions V6694/5 héritées,chemins .troy non ouvertures .troybin. V5574cas/12attaques/16coups entrants/32refus/120ticks hérités,non observations VFX. Aucun scan498,grosblob compilé,native D,build,jeu,GPU/REA ou probe rejoué.

Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2302entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés ;aucune tâche VFX complète,feature,inconnue ou acceptation close. Prochain lot CH-Renekton-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1316 Renekton passif VFX et applicabilité

Audit documentaire borné : docs/AUDIT_SYS01202_RENEKTON_PASSIF_VFX_APPLICABILITY_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_renekton_passive_vfx_20261105 : 47/47 contrôles qualifiés, 45/45 cohérence séparée du même agent ; 30 ancres, 21 fichiers, 19 comparaisons V618 concordantes et 14 identités communes V1315 inchangées. HaveHit/After=1 sont des métadonnées, sans déclenchement Fureur démontré. BloodSlash Darius/Base et Shared ont les mêmes octets, priorité native inconnue. Globalhit identifié ; candidat Annie non retrouvé dans ancien scan, sans nécessité passive prouvée.

Rage/restauration/respawn et helpers génériques conservés ; route Renekton spécifique non établie dans le périmètre. Original 46/47/code1 conservé : un comptage de mentions test corrigé sur octets retenus, autres 46 prédicats/payload inchangés. V618 mécanique héritée, non images VFX ; aucun nouveau build/jeu/natif D/GPU/REA ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2303 entrées sales groupées conservées.

Seul audit de liaison borné clos ; tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Maokai-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1317 Maokai passif VFX, buff prêt et applicabilité

Audit documentaire borné : docs/AUDIT_SYS01202_MAOKAI_PASSIF_VFX_READY_APPLICABILITY_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_maokai_passive_vfx_20261105 : 48/48 contrôles documentaires, 54/54 cohérence séparée du même agent ; 35 ancres, 26 fichiers, 24 comparaisons V600 concordantes et 14 identités communes V1315 inchangées. Trois noms SpellData primaires, deux indicateurs chaînes "0", sans activation démontrée. V600 contient aussi deux déclarations du buff prêt : Maokai_Base_P_cas/active.troy, bone L_BUFFBONE_GLB_HAND_LOC, source existante OLS-c65afd5e-334e-55ff-9c26-3f382babc4d5, 411 octets/SHA7bc829eb… ; pas un nouvel asset récupéré.

La fiche V669 primaire n’est pas exhaustive des buffs secondaires : les deux noms prêts ne figurent pas dans ses anciennes requêtes. Identité physique/montage/rendu des deux Troy restent ouverts, sans affirmation de manque. Soin générique et compteur Annie conservés, pas de producteur Sap Magic identifié dans le périmètre nommé. V600 mécanique héritée, non images VFX ; aucun nouveau build/jeu/natif D/GPU/REA ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2304 entrées sales groupées conservées.

Seul audit de liaison borné clos ; tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Quinn-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1318 Quinn passif VFX, champs secondaires et Event

Audit documentaire borné : docs/AUDIT_SYS01202_QUINN_PASSIF_VFX_SECONDARY_APPLICABILITY_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_quinn_passive_vfx_20261105 : 47/47 contrôles documentaires, 52/52 cohérence séparée du même agent ; 30 ancres, 22 fichiers, 20 comparaisons V616 concordantes et 14 identités communes V1315 inchangées. Trois noms Annie primaires, deux indicateurs chaînes "0", sans activation démontrée. V616 contient six sources secondaires AutoBuff déjà liées à SOURCE : quatre références Passive et quatre QWER/Valor. Ammo/VFX déclarent Buff/Weapon_Top et Haste/sol ; InCombat et WInFlight sont Event seuls. Trois champs AutoBuffActivateEvent restent distincts d’Effect, même avec valeur DeathsCaress_buf.troy.

Ces déclarations ne prouvent ni application Harrier ni rendu ; aucune récupération nouvelle. V669 primaire non exhaustif ; huit anciennes requêtes sans résolution ne couvrent pas les recettes secondaires. Identités physiques, trigger/ownership/période et rendu ouverts. V616 mécanique héritée, non images VFX ; aucun nouveau build/jeu/natif D/GPU/REA ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2305 entrées sales groupées conservées.

Seul audit de liaison borné clos ; tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Thresh-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1319 Thresh passif VFX, âmes et champs contextuels

Audit documentaire borné : docs/AUDIT_SYS01202_THRESH_PASSIF_VFX_SOUL_CONTEXT_APPLICABILITY_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_thresh_passive_vfx_20261105 : 51/51 contrôles documentaires, 50/50 cohérence séparée du même agent ; 20 ancres, 13 fichiers, 11 comparaisons V639 concordantes et 14 identités communes V1315 inchangées. Trois noms primaires Empower/GlobalHit/Annie, deux indicateurs chaînes "0", sans activation Damnation démontrée. Quatre sources secondaires R/W déjà liées à SOURCE : deux Effect, un Event et une attache3 seule ; ThreshWZoneBuff ne déclare pas Effect3 dans le chunk, aucun effet inventé. Huit chunks Souls sans AutoBuff reconnu, Vlad littéral inconnu : aucune absence de graphismes natifs déduite.

Snapshot.units/spawn_unit et routes de mort génériques préservés, traitement Trundle/récompenses conservé ; producteur Damnation nommé non identifié dans le périmètre. Quatre hits larges sont threshold, exclus par motif délimité. V639 XP/statistiques hérité avec zéro tick simulé, aucune âme ou image exercée ; aucun nouveau build/jeu/natif D/GPU/REA ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2306 entrées sales groupées conservées.

Seul audit de liaison borné clos ; tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Yasuo-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1320 Yasuo passif VFX, liaison primaire et courant

Audit de liaison primaire/courant borné : docs/AUDIT_SYS01202_YASUO_PASSIF_VFX_PRIMARY_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_yasuo_passive_vfx_20261105 : 44/44 contrôles documentaires, 46/46 cohérence séparée du même agent ; 17 ancres, 16 fichiers, 12 comparaisons V536, huit identités V808 et 14 communes V1315 concordantes. V536 ne contient pas native_metadata/phases/runtime_summary ; projection primaire V1301 réutilisée : trois ressources, un Lua182octets, icône BlindMonk et persistance sans AutoBuff. Inventaire secondaire non qualifié : aucune clôture du plein audit VFX Yasuo revendiquée.

Trois noms ChronoClock/SpiralBlade/DarkBinding et deux chaînes "0" ne prouvent pas une recette de bouclier. V808 core réutilisé, non reclos ; chance ordinaire et multiplier2 de dégâts ne réalisent pas le doublement attendu. Wind local reste distinct de l’identité native ; grant/absorb shield et Barrier conservés, sans trigger Yasuo identifié. Anciennes observations mécaniques héritées, non images ; aucun nouveau build/jeu/natif D/GPU/REA ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2307 entrées sales groupées conservées.

Seule liaison primaire/courant close ; source secondaire, tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Aatrox-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1321 Aatrox passif VFX, sources et courant

Audit documentaire borné : docs/AUDIT_SYS01202_AATROX_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_aatrox_passive_vfx_20261105 : 44/44 contrôles qualifiés, 39/39 cohérence séparée du même agent ; huit ancres, neuf fichiers, trois records damage/lifecycle/lib concordants et 14 identités communes V1315 inchangées. V456 dix sources/cinq chunks/17 affectations sans callback ou CALL ; Death et Ready sont deux IDs aux mêmes 217octets/SHA b660dc91… et au même BuffName Ready. Aucun AutoBuff dans le corpus conservé ; recette complète non qualifiée.

Trois noms Disintegrate/deathFireGrasp et deux chaînes "0" ne prouvent pas un effet de résurrection. 17 anciennes requêtes/trois chemins logiques, pas14assets manquants. Mort/réapparition génériques et Trundle conservés ; production BloodWell/réanimation non établie dans les routes sélectionnées. Deux collecteurs code1 conservés : variable réutilisée puis attente2/records3 ; reprise E et un seul prédicat qualifié, autres43/payload inchangés. Aucun nouveau build/jeu/natif D/GPU/REA/UDP ou replay. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2308entrées sales groupées conservées.

Seul audit de liaison borné clos ; tâche VFX, feature, inconnue, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot AUD-SYS-01.2-02-PASSIF-VFX-SECONDARY-SOURCE-COVERAGE-01.


## Reprise SYS-01.2-02 — V1322 couverture des sources secondaires des passifs

Consolidation documentaire bornée :docs/AUDIT_SYS01202_PASSIF_VFX_SECONDARY_SOURCE_COVERAGE_2026-11-05.md. Table122IDs :E:/mapslol3v3/audit_sys01202_passive_vfx_secondary_coverage_20261105/coverage_122.md ;provenance/pointeurs/types dans coverage_result.json.132documents/133associations,240276124octets capturés une fois depuis F ;réutilisation des mêmes copies E pour relecture.16/16contrôles,28/28cohérence séparée du même agent,14/14identités communes concordantes.

103lignes reconnues partielles+6avec contexte non mappé+13sans vue mappée ;2348vues de chunks,695champs sur72champions (417Effect/267attaches/11Event),pas un compte d’assets ou effets appliqués.29recouvrements de chemins/identités fournis sans divergence de globals.20vues de reçus non mappées conservées ;aucune absence native déduite. V669 primaire non exhaustif,références QWER/contextuelles et limites des lecteurs conservées.

Seule consolidation bornée close ;zéro audit individuel/SOURCE complet,tâche VFX,feature,inconnue,acceptation ou goal clos. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2309entrées sales groupées préservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Annie-PASSIF-PRESENTATION-VFX :qualifier deux formats existants sur copies E avant une question de consumer/applicabilité. Aucun nouveau build/jeu/natif D/GPU/REA/décodage ou replay.


## Reprise SYS-01.2-02 — V1323 Annie passif VFX sources anciennes et courant

Audit de lien documentaire borné :docs/AUDIT_SYS01202_ANNIE_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_annie_passive_vfx_20261105 :52/52documentaires,49/49cohérence séparée du même agent ;trois chunks/neuf globals concordants entre les deux formats,une déclaration StunReady.troy,98champs et4comparaisons RGBA hérités,non rejoués. Dix ancres/huit identités courantes V668 concordent.

Le renderer lit ready1 dans StunReady.json,texture base et sélection snapshot Annie vivante/pyromania>=4 ;pas un lecteur LuaObj/dispatch AutoBuff natif. Ready2 déclaré sans définition dans le périmètre retenu ;groupes frost décrits mais non sélectionnés par ce renderer. Naissance/phase/attaches/blend/audiences/skin et applicabilité restent ouverts. Première lecture resume code1 conservée,lecteur de JSON terminal corrigé sur E,bootstrap02code0. Diagnostic encore limité à E:/OpenLeague/logs,non lancé. Aucun nouveau build/test Rust/jeu/natif D/GPU/REA/probe.

Seul lien borné clos ;inventaire secondaire complet,tâche VFX,feature,inconnue,acceptation et goal ouverts. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2310entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Blitzcrank-PASSIF-PRESENTATION-VFX :vues V544 buff/cooldown/active_chunk retenues,limites NEWTABLE et consommateurs nécessaires.


## Reprise SYS-01.2-02 — V1324 Blitzcrank passif VFX sources anciennes et courant

Audit de lien documentaire borné :docs/AUDIT_SYS01202_BLITZCRANK_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_blitzcrank_passive_vfx_20261105 :38/38contrôles qualifiés,42/42cohérence séparée du même agent ;Icon/Cooldown neuflittéraux,troisvues anciennes. Actif365octets/21instructions/0enfant entièrement parsé structurellement,globals non qualifiés NEWTABLEpc8,pas corruption ni preuve d’absence. Dixancres/cinqfichiers concordants et14identités communes inchangées.

Shield/grant_shield/absorb_shields et reset mort/retour génériques conservés ;projected_live route Annie Q,pas liaison Mana Barrier. Recherche nommée nulle dans cinqfichiers,non absence globale. Préloads steamgolemshield/hit hérités,non ouvertures/rendu. Deuxéchecs de collecteur préservés :nom de fichier supposé,puis34/38attentes de schéma/noms/emplacement corrigées sur témoins E ;autres34prédicats et observations inchangés. Aucun nouveau build/test Rust/jeu/natif D/GPU/REA/probe/replay.

Seul lien borné clos ;inventaire complet,tâche VFX,feature,inconnue,acceptation et goal ouverts. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2311entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-DrMundo-PASSIF-PRESENTATION-VFX :vue buff V542 retenue et consumers nécessaires.


## Reprise SYS-01.2-02 — V1325 DrMundo passif VFX, source ancienne et consommateurs

Audit de lien documentaire borné : docs/AUDIT_SYS01202_DRMUNDO_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_drmundo_passive_vfx_20261105 : 42/42 contrôles documentaires, 38/38 cohérence séparée du même agent. Vue Nevershade plate reconnue : quatre littéraux, icône et flags, sans AutoBuff reconnu ni inventaire complet déduit. Dix ancres/cinq fichiers courants concordants ; 14 identités communes inchangées.

Régénération de base, Garen, soins, Ignite/Trundle et plafond de PV conservés ; projected_live route Annie Q, pas liaison spécifique Mundo. 0.003 dans regeneration.rs est une tolérance de test Garen ligne 83, pas un coefficient dans la partie production. Icônes DrMundo_AdrenalineRush/AdrenalineRush2 distinctes ; preuves DDS et preload héritées, non rendu. Applicabilité/recette/état/owner/skin/audiences/attache/cadence et rendu ouverts. Aucun nouveau build, test Rust, jeu, natif D, GPU, REA ou replay.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2312 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Galio-PASSIF-PRESENTATION-VFX : vue buff V546 retenue et consommateurs nécessaires.


## Reprise SYS-01.2-02 — V1326 Galio passif VFX, source ancienne et consommateurs

Audit de lien documentaire borné : docs/AUDIT_SYS01202_GALIO_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_galio_passive_vfx_20261105 : 44/44 contrôles documentaires, 38/38 cohérence séparée du même agent. Vue buff plate reconnue : quatre littéraux, GalioRunicSkin/Galio_RunicSkin et flags ; Nondispellable conservé exactement, sans alias de clé. Neuf ancres/quatre fichiers courants concordants ; 14 identités communes inchangées.

stats() calcule l’AP depuis les objets × autels et la RM séparément ; pas de conversion Galio démontrée dans l’affectation AP lue. projected_live route Annie Q ; recherche nommée nulle dans quatre fichiers, non absence globale. f1, activation/rangs et politique serveur ouverts ; Passive1=9/niveaux 3/7/11 et ancien texte tiers armure/RM non adoptés. Preloads et DDS hérités, non rendu. Applicabilité/recette/état/owner/skin/audiences/attache/cadence et rendu ouverts. Aucun nouveau build, test Rust, jeu, natif D, GPU, REA ou replay.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2313 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Garen-PASSIF-PRESENTATION-VFX : reçu source ancien retenu et consommateurs réellement cités.


## Reprise SYS-01.2-02 — V1327 Garen passif VFX, reçu ancien et consommateurs

Audit de lien documentaire borné : docs/AUDIT_SYS01202_GAREN_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_garen_passive_vfx_20261105 : 42/42 contrôles documentaires, 56/56 cohérence séparée du même agent. Quatre descriptions structurelles Lua, 22 entrées de constantes, lectures complètes et zéro enfant rapportés ; aucune affectation globale ou recette inventée. Quatorze ancres/six entrées courantes concordantes ; 14 identités communes inchangées.

Producteur partiel Garen préservé : getter/paliers, interruption, événement de capacité, taux ajouté à base/objets puis multiplicateur de soins et plafond HP. Timestamp relatif/None initial et règles locales conservés, historical_runtime_qualified=false. projected_live route Annie Q, sans binding passif Garen dans ce corps, non absence globale. Anciennes preuves core/réseau, DDS et locale en_GB héritées ; reçu ancien en_US distinct. Applicabilité/recette/état visuel/owner/skin/audiences/attache/cadence/rendu ouverts. Aucun nouveau build, test Rust, jeu, natif D, GPU, REA ou replay.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2314 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Ezreal-PASSIF-PRESENTATION-VFX : vues V665 natives/contextuelles retenues et consommateurs nécessaires.


## Reprise SYS-01.2-02 — V1328 Ezreal passif VFX, métadonnées et consommateurs

Audit de lien documentaire borné : docs/AUDIT_SYS01202_EZREAL_PASSIF_VFX_METADATA_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_ezreal_passive_vfx_20261105 : 54/54 contrôles documentaires, 48/48 cohérence séparée du même agent. V665 est réseau/contextuel, non inventaire SOURCE complet. Deux littéraux qualifiés nom/icône ; alias Buff, ancien texte 15 % et champ Ashe conservés. Dix-huit ancres/cinq fichiers actuels concordants ; 14 identités communes inchangées.

Producteur local de cumuls et HUD partiels préservés ; plugin enregistré dans main ligne 688, compteur privé validé, icône Provider/Buff0. Accesseurs passive/count et R3d distincts ; projected_live route Annie Q. Inspection main sans sélection initiale avant cfg(test) complétée sur texte intégral, aucune absence déduite. Métadonnées sans AutoBuff ne prouvent pas absence native. Applicabilité/recette/owner/skin/audiences/attache/cadence/rendu restent ouverts. V665 contacts/DTO/UDP et trois échecs privés hérités, non rejoués. Aucun nouveau build, test Rust, jeu, natif D, GPU, REA ou réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2315 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Ashe-PASSIF-PRESENTATION-VFX : sa branche V537 partagée et consommateurs nécessaires, sans clôture Tryndamere implicite.


## Reprise SYS-01.2-02 — V1329 Ashe passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_ASHE_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_ashe_passive_vfx_20261105 : 47/47 contrôles qualifiés, 36/36 cohérence séparée du même agent. Focus quatre littéraux et CharScript vide qualifiés dans les vues héritées ; effet Ready seulement contrôlé par chaînes V1174, pas recette structurée ou rendu. Huit ancres/cinq fichiers ; SOURCE14/HUD6 et 14 identités communes concordantes.

Critique/projectile génériques conservés ; recherche nommée trouve seulement un commentaire Annie/Ashe, pas un producteur Focus. Collecteur initial46/47 code1 conservé ; seul prédicat de classification qualifié, autres46 et observations inchangés. Taux f1/100charges, recette, sélection, audiences, attache et rendu ouverts. Aucun nouveau build, jeu, test Rust, natif D, GPU, REA ou réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Tryndamere préservé, non clos. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2316 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Tryndamere-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1330 Tryndamere passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_TRYNDAMERE_PASSIF_VFX_LEGACY_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_tryndamere_passive_vfx_20261105 : 56/56 contrôles documentaires, 40/40 cohérence séparée du même agent. Définition Battle Fury/Battlefury, tooltip INIBIN43 et CharScript56 vide qualifiés dans les vues héritées ; aucune recette visuelle ou absence native déduite. Onze ancres/six fichiers ; 26 entrées HUD et 14 identités communes concordantes.

Critique/projectile génériques et reset partiel de réapparition préservés ; test Tryndamere reste séparé, non exécuté. V537 +1,75 point attendu/zéro observé et mana100 distinct de Fury conservés, non rejoués. Deux préparations échouées archivées : Git nul sous confinement puis label de preuve historique ; reprises vérifiées sans nouveau build/jeu/natif D/GPU/REA/réseau. Applicabilité, recette, compteur/f1, sélection, audiences, attache et rendu ouverts.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Ashe préservé, non reclos. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2317 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Azir-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1331 Azir passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_AZIR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_azir_passive_vfx_20261105 : 57/57 contrôles documentaires, 44/44 cohérence séparée du même agent. Onze vues Lua : huit limites NEWTABLE non corruption, trois CharScripts vides qualifiés ; constantes CyberEzreal/AzirSkin01 non promues en règles de skin. Neuf ancres/six entrées (cinq Rust/un JSON) ; 21 entrées SOURCE et 14 identités communes concordantes.

CDR/AS séparés, spawn/configuration ordinaires et Tibbers conservés, aucun SunDisc produit dans les chemins qualifiés. Sélecteur Annie vérifié en texte complet ; recherche nommée bornée aux six textes, sans absence globale. Trois cas58/58/50ticks,18impacts51refusals V559 hérités, non rejoués. Préparation SOURCE échouée sur ancien schéma de reçu conservée puis reprise avec champ/SHA exacts. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2318 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Braum-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1332 Braum passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_BRAUM_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_braum_passive_vfx_20261105 : 59/59 contrôles documentaires, 50/50 cohérence séparée du même agent. Neuf vues passif/CharScript et Q contextuel distinct ; deux champs AutoBuff qualifiés LOC_Stun.troy/bone CENTER_LOC, popup séparé. Override NEWTABLEpc0 reste non qualifié, non corruption. Douze ancres/sept Rust ; 28 entrées SOURCE et 14 identités communes concordantes.

Stun générique et chaîne update→all_states→player_states→overlay préservés, avec priorité disponibilité/cooldown/rang/stun/ressource ; pas activation Braum ou particule en monde déduite. Règles Kennen/Leona/Q non transférées. Données52impacts8quartets/API40/stun60 héritées, non rejouées. Aucune opération documentaire échouée ni nouveau build/jeu/natif D/VM/GPU/REA/réseau. Applicabilité, recette, producteurs/paramètres, audiences, pose, attache et rendu ouverts.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2319 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Caitlyn-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1333 Caitlyn passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_CAITLYN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_caitlyn_passive_vfx_20261105 : 63/63 contrôles documentaires, 44/44 cohérence séparée du même agent. Count/Marker/CharScript six globals qualifiés ; Ready/missile NEWTABLEpc4/pc0 restent non qualifiés, non corruption ; Headshot2 et CaitlynSkin06 restent candidats. Douze ancres/six Rust ; 16 entrées frontières/SOURCE/profils et 14 identités communes concordantes.

Tirs/critique/projectiles et buissons de visibilité préservés, sans compteur Headshot ou rendu spécifique qualifié. V56036lancements/24impacts champion/51refus hérités ; sbires12lancements !=12impacts, dernier projectile en vol et dégâts nets non isolés. Cadrage55133octets : source externe immuable référencée et vérifiée, pas ré-embedding du reçu ; hook inchangé, aucun facteur de vitesse revendiqué. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2320 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Corki-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1334 Corki passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_CORKI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_corki_passive_vfx_20261105 : 61/61 contrôles documentaires, 48/48 cohérence séparée du même agent. RapidReload quatre globals qualifiés, CharScript vide, aucun AutoBuff dans ces vues sans absence native déduite. Description Annie et rangs typés conservés non adoptés. Douze ancres/six Rust ; 16 entrées frontières/SOURCE/HUD et 14 identités communes concordantes.

Tir Physical, mitigate/apply_damage True et recap génériques préservés, pas déclencheur ou particule Corki qualifiés. Texte damage complet vérifié au-delà du cfg(test) précoce ; première fenêtre courte non utilisée comme absence. V56118impacts champion/2tourelle/68refus et huit écarts boutique/analyse corrigée hérités ; aucun combat ou arithmétique rejoué. Cadrage45698octets et source externe exacte, hook inchangé. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Darius-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1335 Darius passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_DARIUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_darius_passive_vfx_20261105 : 80/80 contrôles documentaires,55/55 cohérence séparée du même agent. Six Lua/douze globals, CharScript vide ; aucun AutoBuff dans ces vues, sans absence native déduite. Deux preloads12/17références et quatre INIBIN confrontés à la découverte E exacte ; suffixe only6 et références DeadlyVenom conservés. Dix-sept ancres/huit Rust ; 20 entrées antérieures et14identités communes concordantes.

Attaques Physical, vitesse/bonus/caps, Magical et Ignite True génériques préservés, pas producteur ou particule Hemo qualifiés. Damage complet lu au-delà du cfg(test) précoce ; recherche nommée bornée aux huit textes. V56216impacts/720ticks/60refus hérités, non rejoués ; cinq attaques !=cinqcumuls. Cadrage56822octets et source externe exacte, hook inchangé. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Diana-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1336 Diana passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_DIANA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_diana_passive_vfx_20261105 :85/85 contrôles documentaires,63/63 cohérence séparée du même agent. Quatre Lua/six affectations, deux vides ; Passive/DeathRecap identiques sans callback/persistance exécutés. Preloads4/7références et trois sélecteurs bruts Attack1/2/3 conservés, non règle du troisième coup. Vingt ancres/huit Rust ;15entrées antérieures et14identités communes concordantes.

Chaîne ordinaire faits→attack/crit→animation::animate→lookup/play/seek identifiée statiquement ; pas compteur ou VFX Moonsilver qualifiés. Nearby18impacts/48refus/AP0-20-0/cadence48-48-42, opposite273.589 et trois échecs blue-side hérités séparément. Helper de préparation échoué sur adaptation textuelle superflue conservé puis qualifié ; prédicats inchangés. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Draven-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1337 Draven passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_DRAVEN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_draven_passive_vfx_20261105 :87/87 contrôles documentaires,62/62 cohérence séparée du même agent. Cinq Lua dont quatre initialisations qualifiées/neuf affectations ; Spinning NEWTABLEpc10 limité, constantes de skins non promues. Preloads3/8références et deux DDS distincts4224/5616octets conservés, sélection ouverte. Vingt ancres/neuf Rust ;17entrées antérieures,14identités communes et2animations ordinaires réutilisées concordantes.

Récompenses unités/champions, or ambiant, mort/réapparition et présentation ordinaire préservés, pas producteur Adoration/world FX qualifié. Six kills400/300sans supplément et45refus hérités ;123hits signifie baisses de santé,71avec projectile précédent/52sans, pas123impacts attribués. Mouvement V564/V563 distinct. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Elise-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1338 Elise passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_ELISE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_elise_passive_vfx_20261105 :91/91 contrôles documentaires,73/73 cohérence séparée du même agent.25Lua/96affectations/cinqvides ; CharScript118deuxflags, non vide. Quatre champs AutoBuff W-spiderling/Ehumain qualifiés, contexte distinct du passif ; os/Popup non pose/événement/rendu. Trois définitions, sixpreloads22références et deuxDDS128/64 conservés, f3 non qualifié. Vingt ancres/huit Rust ;14entrées antérieures,14identités communes et2animations ordinaires réutilisées concordantes.

Rangs/cast/autoattaques/fabrique/Pet/Tibbers préservés, pas réserve/transformation/araignées Elise. Public12impacts/AP0-20/34refus distincts des deux diagnostics2525XP ; zéro pet sous autoattaques n’établit pas absence de passif, Tibbers ne valide pas Elise. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Evelynn-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1339 Evelynn passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_EVELYNN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_evelynn_passive_vfx_20261105 :96/96 contrôles documentaires,76/76 cohérence séparée du même agent. DixLua/39affectations ; CharScript vide, neufsorts DATA/Spells. Watched/HEAD PC15/17 candidat révélé, non activation/pose/rendu. Dixpreloads19références et cinqDDS/quatrecontenus, mipbrut0 conservé. Vingt ancres/huit Rust ;19entrées antérieures,14identités communes et2animations ordinaires réutilisées concordantes.

Vision/projection/datagrammes statiques, sources FOW alliées et régénération génériques préservés, pas machine ShadowWalk qualifiée. V567250/900distances non seuils natifs ;360ticks visibles/projetés chacun et mana base1.6216 distinct du1%maximum conditionnel. Requête d’affichage de contexte échouée sur clé puis reprise sur schéma réel, archives intactes. Aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-FiddleSticks-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1340 FiddleSticks passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_FIDDLESTICKS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_vfx_20261105 :74/74 contrôles documentaires,74/74 cohérence séparée du même agent. Trois Lua/six affectations ; CharScript vide, Paranoia/Paranoia Aura distincts de Nocturne/raté. Fearmonger Drain exclu. Deux preloads/quatre références dont dreadwarning, deux DDS identiques64/DXT5/mipbrut0 conservés sans sélection ou rendu qualifiés.22 ancres/neuf Rust ;22 comparaisons antérieures/18chemins uniques,14identités communes et2animations ordinaires concordantes.

Producteur réel stats dans progression.rs, pas lib.rs ; requête d’affichage échouée conservée puis définition exacte lue. MR cible, pénétration source, Exhaust/TrundleR, mitigation/boucliers et diagnostics distincts de Dread. V568 trois phases250/300ticks MR30/55/30 et33refus ; trois diagnostics100magic/9refus ne sont pas des sorts ordinaires. Sept opérations documentaires exit0, aucun nouveau build/jeu/natif D/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet, tâche VFX, feature, inconnue, acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2327 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Fiora-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1341 Fiora passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_FIORA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_fiora_passive_vfx_20261105 :71/71 contrôles documentaires,85/85 cohérence séparée du même agent.28Lua/22initialisations/115affectations/sixvides/sixlimitesNEWTABLE ; troisHot identiques et15champsAutoBuff vides, non absence d’effets. HuitcontextesAutoBuff/36champs ; QWER/Weapon/Sword/CENTER non recette du passif. Quatrepreloads identifiés, corps non inspectés ici ; deuxDDS identiques64/DXT5/mip7 conservés.22ancres/neufRust ;30identités antérieures dont18V662,14communes et2animations concordantes.

Attaques/dégâts/voldevie/baseGaren/receivedheal/heal et renduAnnie préservés, pas producteurDuelist qualifié. V66224attaques/24fenêtres181ticks,12damageAPI/4heal25/20blessures/6XP/60refuspublics40API hérités ; heal25!=f1,cinquièmeattaque sansactivation!=cap4. Recherches de contexte échouées sur chemins supposés conservées, V1309 réel utilisé. Sixopérations documentaires exit0, aucun nouveau build/jeu/natifD/VM/GPU/REA/réseau.

Seul lien borné clos ; inventaire complet,tâcheVFX,feature,inconnue,acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2328 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Fizz-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1342 Fizz passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_FIZZ_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_fizz_passive_vfx_20261105 :71/71 contrôles documentaires,75/75 cohérence séparée du même agent. DeuxLua/troisaffectations ; CharScript vide, BuffTextureName/AutoBuff absents dansglobals ne signifient pas texture/effet manquant. DisplayIcon/INIBINmixte/preloadSeastone non Nimble. Deuxpreloads321octets/quatreréférences de sorts ; unDDS5616/64/DXT5/mip7 hérité.21ancres/neufRust ;16entrées antérieures,14communes et2animations concordantes.

Attaques/mitigation/boucliers, vitesse et géométrie alliée reconstruite préservés, pas producteurNimble qualifié. Navigation30, gameplayabsent et defaultscommunautaires65/40 distincts. V56912impacts30refus, armure1029 ; quatre mouvements Fizz/Garen alliés60/65, ennemistraversésminima4.336914/3 hérités, pas immunitépassive. Sixopérations documentaires exit0 ; aucun nouveau build/jeu/natifD/VM/GPU/REA/réseau.

Seul lien borné clos ; inventairecomplet,tâcheVFX,feature,inconnue,acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2329 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Gangplank-PASSIF-PRESENTATION-VFX ; Galio/Garen déjà liés.


## Reprise SYS-01.2-02 — V1343 Gangplank passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_GANGPLANK_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_gangplank_passive_vfx_20261105 :77/77 contrôles documentaires,81/81 cohérence séparée du même agent. CinqLua/quatreinitialisations/20affectations ; Parley NEWTABLEpc12 conservé. PropriétaireScurvy et cibleScurvyStrike distincts ; Particle Global_Slow/attachevidePC5/7 non activation/pose/rendu. Deuxpreloads479octets/septréférences ; unDDS4224/64/DXT5/mip1 hérité.23ancres/dixRust ;18sélectionnés/77contexte chevauchants,14communs et2animations concordants.

Slows strongest/tag/expiry/admissionNPC, attaques physiques et invocateurs préservés, pas producteurpoisonGrog qualifié. V57012impacts60refus720tailticks, trois coups sur92ticks non troischarges garanties ; contrôle séparéExhaust335234.5335/Ignite5x14=70 distinct. Ancien E0559 et gateGalio omis corrigé conservés,77contextes gardés. DeuxKeyErrors d’affichage conservés puis schéma réel lu. Sixopérations documentaires exit0, aucun nouveau build/jeu/natifD/VM/GPU/REA/réseau.

Seul lien borné clos ; inventairecomplet,tâcheVFX,feature,inconnue,acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2330 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Gnar-PASSIF-PRESENTATION-VFX, toutesversions retenues.


## Reprise SYS-01.2-02 — V1344 Gnar passif VFX, sources et consommateurs

Audit de liaison borné : docs/AUDIT_SYS01202_GNAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_gnar_passive_vfx_20261105 :70/70 contrôles documentaires qualifiés,81/81 cohérence séparée du même agent. DeuxsourcesV571/V572 conservées,15cléscommunesidentiques,aucunepréférenceautomatique.9Lua/4initialisations/5affectations/5limitesNEWTABLE ; RedVfx/Runpersistence non recette,7preloads identifiés corpsnoninspectés,DDShéritée2176/64/DXT1/mip0.22ancres/11Rust dont3contextestest ;33identités dont21parversion,14communes et2animations concordantes.

Initdef.mana/regenManaEnergy/respawnManaEnergyWindelse0 etHUDMana-only préservés, pas politiqueRageGene qualifiée. V571saturation100/12impacts48refus distincteV5723morts42prep480ticks puis0/100/12impacts54refus ;1800tickschaque,15snonqualifiées sansformeatteinte. Recherchelarge3hitscfgtestGnar/Ashe distincte ancienmotif1hit. Collecte69/70exit1 conservée,uneancreMPStat précisée70/70/69autresinchangés ; vérificateurpréfixe échoué conservé puis comparaisoncomplète qualifiée. Septopérations documentaires dont6succès/1échecconservé,aucunbuild/jeu/natifD/VM/GPU/REA/réseau.

Seul lien borné clos ; inventairecomplet,tâcheVFX,feature,inconnue,acceptation et goal ouverts. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2331 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Gragas-PASSIF-PRESENTATION-VFX.


## Reprise SYS-01.2-02 — V1345 Gragas passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_GRAGAS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_gragas_passive_vfx_20261105 :67/67 contrôles documentaires,74/74 cohérence séparée du même agent. SeptLua/sixinitialisations/30affectations ; W NEWTABLEpc16 ; unpreload231/troisréférences dont rengar_base_w_heal conservé comme candidat littéral, pas corruption/invocation. DeuxDDS identiques64/DXT5/mip1 hérités.21ancres/dixRust ;31sélectionnés/24chemins uniques,87contextuels,14communs et2animations concordants.

Casts/progression refusent Gragas dans les corps inspectés ; soins/modificateurs/régénération/invocateurs génériques distincts du passif. V573deuxcasHP583.52/733.52,10impacts40refus600ticks etHeal90 hérités sans replay ; aucun déclencheur réussi ni délai interne qualifié. Sixopérations documentaires exit0 attendues après préparation complète, aucun nouveau build/jeu/natifD/VM/GPU/REA/réseau. Registre des opérations fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2332 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés. Seule liaison bornée close ; tâcheVFX,inventairecomplet,feature,inconnues,acceptation et goal ouverts. Application de la recherche18a5e039 : prochaine étape consolidation bornée des audits déjà étayés, avant nouvelles investigations ; réutilisation avec identité, reprises sur dérive/nouvelle source/question précise, pas de gain chiffré annoncé.


## Reprise SYS-01.2-02 — V1346 consolidation des clôtures bornées des passifs VFX

Consolidation terminée : docs/AUDIT_SYS01202_PASSIF_VFX_CLOSURE_CONSOLIDATION_2026-11-05.md. Matrice et preuves : E:/mapslol3v3/audit_sys01202_passive_vfx_closure_consolidation_20261105. Sur122 tâches figées,30 livraisons individuelles ont des preuves de clôture cohérentes pour leurs périmètres bornés ;92 sans rapport individuel dans la fenêtre. Deux rapports de famille exclus. Recherche des184 IDs exacts des92 lignes dans les rapports SYS01202 : aucun candidat hors famille ; aucune absence globale déduite.

364/364 contrôles qualifiés,709/709 cohérence séparée du même agent.245 identités concordantes ;238 initiales puis7 pins exacts supplémentaires. Ancien355/364 et deux opérations échouées conservés ; sept anciens formats matériels explicitement vérifiés, pas renommés aveuglément. Source JSON/native/runtime non réanalysés, aucun build/jeu/REA/install.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2333 entrées sales groupées conservées. Aucun audit individuel nouvellement clos, aucune feature/inconnue/acceptation ou tâche VFX complète fermée. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Graves-PASSIF-PRESENTATION-VFX ; contrat et source V574 conservée dans next_lot.json. Réutiliser les30 décisions sur entrées inchangées ; ne rouvrir que sur dérive, nouvelle source/callsite ou question précise.


## Reprise SYS-01.2-02 — V1347 Graves passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_GRAVES_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_graves_passive_vfx_20261105 :72/72 contrôles documentaires,83/83 cohérence séparée du même agent. Six Lua/six initialisations/26 affectations ; Grit AutoBuffActivateEffect=GravesTrueGrit.troy pc9, Stack six champs vides et alias Pineapple/Rumble conservés sans règle inventée. Trois preloads484octets/six références ; deux DDS distincts64/DXT5/mip7 hérités.25 ancres/douze Rust ;21 comparaisons sélectionnées et87 contextuelles,14 communes et2 animations concordantes.

Stats/dégâts/pénétration/assistances et reset génériques conservés ; garde Garen exclut Graves, pas producteur True Grit établi dans les corps inspectés. V574 cinq cas40 impacts75 refus1500ticks hérités, objets+15AR/+25MR distincts des cumuls. f1/éligibilité/timing/recette/attache/rendu ouverts. Un échec préparatoire d’égalité brute de chemins conservé puis prédicat Windows précisé ; contrôles taille/SHA maintenus. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2334 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Hecarim-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1348 Hecarim passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_HECARIM_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_hecarim_passive_vfx_20261105 :80/80 contrôles documentaires,89/89 cohérence séparée du même agent. Quatre Lua/trois initialisations/20 affectations ; Ramp NEWTABLEpc10 ; trois paires effet/os RampSpeed E, pas Warpath qualifié. Deux preloads663octets/neuf références et deux noms DDS distincts/une empreinte64/DXT5/mip7 hérités.31 ancres/quinze Rust ;25 comparaisons sélectionnées et83 contextuelles,14 communes et2 animations concordantes.

Vitesse/AD/occupation génériques conservés ; pas conversion Warpath ou exemption Hecarim établie dans les corps inspectés. Cinq cas30 impacts77 refus450ticks hérités, Soin30ticks/plafonds locaux et +10AD objet distincts. Alliés Hec80=50+30,Garen65=35+30 ; ennemis traversés par les deux, pas preuve du passif. f1/f2/base de vitesse/catégories/rendu ouverts. Échec bootstrap sur futur result.json conservé, seul PREV corrigé ; aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2334 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Heimerdinger-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1349 Heimerdinger passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_HEIMERDINGER_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_heimerdinger_passive_vfx_20261105 :76/76 contrôles documentaires,88/88 cohérence séparée du même agent. Trois Lua/trois initialisations/cinq affectations ; source persistante et destinataire sans champ persistence distincts. Description4200 candidate non liée, nom4376 lié,Q/Nano non adopté. Deux preloads2103octets/29noms et unDDS64/DXT1/mipbrut0 hérités.29 ancres/quatorze Rust ;23 comparaisons sélectionnées et81 contextuelles,14 communes et2 animations concordantes.

Régénération générique/base/objets/Garen/modificateurs reçus distincts de Repair Bots ; Tibbers régénération propre/aura ennemie non H-28G. V576 deux cas10impacts30refus1200tailticks186mouvement hérités ; distances250/1250.9996 non rayon,bead+50% non f1. Trois vieux diagnostics RUN101 et variante qualifiée0/0 conservés ;58 contrôles statiques antérieurs et leur clarification sans relance distingués. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2334 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Irelia-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1350 Irelia passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_IRELIA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_irelia_passive_vfx_20261105 :82/82 contrôles documentaires,92/92 cohérence séparée du même agent. DeuxLua/deuxinitialisations/deuxaffectations ; Voracity définition distinct de IreliaIonianDuelist preload/buff,sans alias automatique. Deuxpreloads616octets/huitnoms dont troisparticules numérotées,sans mapping états ; deuxDDS/uneempreinte64/DXT1/mip7 hérités.30ancres/douzeRust+unJSONlocal ;20comparaisons sélectionnées et78contextuelles,14communes et2animations concordantes.

Getter Courage sans gardechampion mais producteur public Garen ;ceil0.7 non IonianFervor. Table disabled_cast_rules335octets/12bool explicitementlocale. V577quatreIrelia/deuxGaren,3silencespublics45ticks et14paires28événementsserveur,637expiry,74refuspublics54serveur hérités ;400unités diagnostic non rayon. Anciennes erreurs registre/PREPARE/regex et chaîne qualifiée conservées. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2334 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Janna-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1351 Janna passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_JANNA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_janna_passive_vfx_20261105 :78/78 contrôles documentaires,86/86 cohérence séparée du même agent. QuatreLua/troisinitialisations/sixaffectations ; TailwindSelf persistence/NonDispellable distinct de Tailwind sans ces champs ; SowTheWind NEWTABLEpc18 limite conservée. Deuxpreloads741octets/onzenoms et deuxDDS/uneempreinte64/DXT5/mip1,membres161/25 distincts hérités.29ancres/seizeRust ;28comparaisons sélectionnées et96contextuelles,14communes et2animations concordantes.

5% documentés,portée globale/proche indéterminée ;aucun f1 inventé,chaîneszéro et WZephyr non politique passive. Vitesse générique base/objets/Garen/Soin/relique/Trundle/caps conservée,pas producteur Tailwind établi dans la formule inspectée. V578quatre cas70refus240ticks40pas hérités ;Ahri330/355,Heal426.2/452.2 puis retour,distances250/1249.9995 non rayon. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2334 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-JarvanIV-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1352 Jarvan IV passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_JARVANIV_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_jarvaniv_passive_vfx_20261105 :89/89 contrôles documentaires,98/98 cohérence séparée du même agent. QuatreLua/troisinitialisations/cinqaffectations ;source persistante et cibleCheck sans champ persistence distinctes,Attack NEWTABLEpc0 limite. Deuxpreloads346octets/quatre noms,AnimationName Passive/FX identifiés sans recette ;deuxDDS/uneempreinte64/DXT1/mip7 membres25,homonymeZyra contextuel non lu. 37ancres/seizeRust ;19comparaisons sélectionnées et89contextuelles,14communes et2animations concordantes.

10%PV actuels physique,max400 documentés,délai f1/ordre/catégories ouverts. Chaîne générique AD/crit/Garen/Trundle,Physical/pénétration/mitigation/boucliers/voldevie distincte du bonus/verrou. V579deuxcas16impacts32refus180tailticks hérités ;AABBABAB,AD55.712/65.712,LongSword+10AD non passif. Deux erreurs préparatoires cp1252 et PREV conservées puis corrigées ;six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2339 entrées sales groupées conservées. Seul audit borné clos ;tâcheVFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Jax-PASSIF-PRESENTATION-VFX ;sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1353 Jax passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_JAX_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_jax_passive_vfx_20261105 : 110/110 contrôles documentaires, 127/127 cohérence séparée du même agent. Deux versions V538/V580 conservées,13 ressources communes concordantes,Barrier49 supplémentaire et union SOURCE22. Sept Lua/six initialisations/24 affectations ;AS AutoBuff vides,Speed=RelentlessBarrier avec particule distincte,Attack NEWTABLEpc6 limite. Cinq preloads906octets/onze références dérivées ;trois DDS/deux contenus64/DXT5/mipbrut0,membres40/25/25. 42 ancres/seize Rust ;29 comparaisons sélectionnées dont5V538 et92 contextuelles,14 communes et2 animations concordantes.

Texte2.5s/max6,f1percent ouvert ;R/troisième coup magique et Barrier distincts. Cadence générique croissance/objets/Trundle/Ezreal/Exhaust,round/min12 ;pas de producteur cumul Jax établi. V538 huit47ticks,Dague47→41→47 ;V58018impacts30refus420ticks hérités,arrondis non échec numérique natif ni preuve expiry/max6. Compteur historique3→4 et extraSIMULATION seulement conservés ;cinq alias E non nouveau collecteur. Une erreur d’affichage de schéma conservée,noms dérivés du texte ensuite ;six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2340 entrées sales groupées conservées. Seul audit borné clos ;tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Jayce-PASSIF-PRESENTATION-VFX ;sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1354 Jayce passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_JAYCE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_jayce_passive_vfx_20261105 : 120/120 contrôles documentaires,120/120 cohérence séparée du même agent. Seize Lua/14 initialisations/89 affectations,deux NEWTABLEpc14 ;18 champs AutoBuff/neuf paires effet-os Ready/Melee/Range sans activation qualifiée. Dix preloads3265octets/43 noms dont root BBPreloadSpell ;deux DDS distincts5616DXT5mip7/membre174 et2176DXT1mip0/membre195. JayceManOfTomorrow non retrouvé dans les scopes antérieurs,tooltipJaycePassive manquant,alias hérités préservés. 37 ancres/seize Rust ;28 comparaisons sélectionnées et92 contextuelles,14 communes et2 animations concordantes.

Texte40vitesse/1.25s/passage via Transform ;sorts/rangs refusent Jayce,pas producteur établi. Quatre cas vitesse70refus240ticks20pas etquatre occupation+2refus hérités ;335/360,Soin431.4/457.4 puis retour,alliés65 bloqués etennemis traversés chezJayce/Garen non passif. UnTransform::IDENTITY géométrique distinct ancienpérimètre12hits. Préparation root chemin erroné etdeux scripts absents conservés puis corrigés ;huit opérations documentaires,six exit0/deux exit1 initiaux,deux tentatives matérielles identiténull. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2341 entrées sales groupées conservées. Seul audit borné clos ;tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Jinx-PASSIF-PRESENTATION-VFX ;sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1355 Jinx passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_JINX_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_jinx_passive_vfx_20261105 : 101/101 contrôles documentaires,112/112 cohérence séparée du même agent. Six Lua/six initialisations/11 affectations ;AutoBuff Jinx_Passive_Buff distinct du preload onkill,bone absent non absence d’attache. Marker/Bowmaster,Kill/Jinx_Passive,moniteurCatchMe/Hidden etpersistence préservés. Quatre preloads1881octets/26 noms ;72DDF dont16Vi,Q AS distinct. Trois DDS/deuxDXT1 unDXT5,mipbrut0,membres181/181/25 ;casseBullseye/BullsEye sans alias. 43 ancres/20Rust+unJSONlocal2457octets ;32 comparaisons sélectionnées et96 contextuelles,14 communes et2 animations concordantes.

Texte175%/4s/contribution3s ;fenêtre générique assist15s etrécompenses300+100 distinctes,algorithme local non serveur natif. Chaînes dégâts/mort/contributions/structures/vitesse sans producteurGetExcited établi. V582deuxcas48impacts4kills34refus720ticks20pas hérités,325/350 et400/300rewards ;Annie respawn naturel non lifecycleJinx,XP/niveaux non supposés constants,assist/tours/inhib non exercés. Anciennes préparations etstockage gardés inertes,sansDB/cache/backup rouverts. Six opérations documentaires exit0,aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2342 entrées sales groupées conservées. Seul audit borné clos ;tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Kalista-PASSIF-PRESENTATION-VFX ;sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1356 Kalista passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KALISTA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kalista_passive_vfx_20261105 : 93/93 contrôles documentaires,103/103 cohérence séparée du même agent. V6634917535octets ;25 sources/75 associations. Contexte114Lua/90initialisations/24limites,11vues sélectionnées/10initialisations31affectations ;MysticShotNEWTABLEpc8,aucunAutoBuff dans11 non absenceglobale. Cinq preloads identités conservées,corps non rouverts. DDS2176/64DXT1/mip0/membre1.7 héritée. 37 ancres/17Rust+unJSON ;22comparaisonsV663,34contextuelles,16communs sous-ensemble,14VFX et2animations concordantes. Ancien V1311 schéma unifié69/63/7 conservé par pointeur vérifié,non normalisé en faux composants.

Profilcant_cancel natif brut1 etJSONtrue préservés ;cancelable=!cant_cancel,Move garde avant destination,donc pas d’ordre différé établi. KindBasic/Critical/GarenQ/TrundleQ etpontattack/crit non bond. Huitcas historiques20attaques24essais132refus16860ticks ;12Kalista refus/12Annie acceptés,4achats40trajets12XP,bottes marche non bond. Ancienraw7509876/RUN/binaire6100992/1158dépendances inertes. Six opérations documentaires exit0 ;aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2343 entrées sales groupées conservées. Seul audit borné clos ;tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Karma-PASSIF-PRESENTATION-VFX ;sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1357 Karma passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KARMA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_karma_passive_vfx_20261105 :101/101 contrôles documentaires,96/96 cohérence séparée du même agent. Quatre Lua/trois initialisations/12 affectations ; Char118 non vide,Mantra NEWTABLEpc6 ; zéroAutoBuff reconnu non absence globale. Trois preloads707octets/neuf références ;DDS2176/64DXT1/mip0/membre155 héritée,InnerFlame non localisée dans scopes antérieurs.31ancres/14Rust+unJSON ;22comparaisons sélectionnées et86contextuelles,14communes et2animations concordantes.

Mantra niveau1/CD45-42-39-36/empower8s/remboursement distincts ;f1/f2 ouverts,demi-effet attaques connu. CDRgénérique etrefundEzrealQ à garde chez appelants nonKarma. V583Karma12impacts34refus180ticks nonarmés etGaren240/216ticks2refus180ticks hérités. Unlookup root de deux gabarits absent conservé ;collect01 rôle invalide exit2 avant exécution,collect02/root exit0,registre terminal fait autorité. Aucun nouveau build/jeu/natifD/GPU/REA/probe ;anciens binaires/stockages inertes.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2344 entrées sales groupées conservées. Seul audit borné clos ;tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Karthus-PASSIF-PRESENTATION-VFX ;sources etcritères dans next_lot.json.


## Reprise SYS-01.2-02 — V1358 Karthus passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KARTHUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_karthus_passive_vfx_20261105 :115/115 contrôles documentaires,105/105 de cohérence séparée du même agent. Huit Lua/sept initialisations/29 affectations ; FallenOne2 NEWTABLEpc12, zéro AutoBuff reconnu non absence globale. Huit preloads4064octets/55 références ; DDS2176/64DXT1/mip0/membre235 héritée.35 ancres/14 Rust+un JSON ;21 comparaisons sélectionnées et85 contextuelles,14 communes et2 animations concordantes.

Death Defied espacé et Buff conservés, clé Defile non résolue, NightmareBot exclu. Sept secondes/sorts gratuits documentés ; commande morte refusée, nettoyage létal/récompense/réapparition génériques, death animation après priorité cérémonie Nexus et arrêt attaques non état spirituel. V584 deux cas31impacts/2morts/164refus dont110morts/960ticks,2respawns480ticks hérités ; mana sous refus non gratuité. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; anciens binaires et stockages inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2345 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Kassadin-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1359 Kassadin passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KASSADIN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kassadin_passive_vfx_20261105 :104/104 contrôles documentaires,102/102 cohérence séparée du même agent. Cinq Lua/cinq initialisations/19 affectations ; Char109 non vide/Teemo, deux AutoBuff NullLance/QCancel identiques distincts du passif. Trois preloads913octets/12 références minuscules ; quatre DDS4224DXT5/trois contenus,mips0/0/1/0,membres40/25/25/25 hérités.35 ancres/17 Rust+JSON ;25 comparaisons sélectionnées et87 contextuelles,14 communes et2 animations concordantes.

15%magique/unité collision connus ; MR/Courage/boucliers génériques sans producteur VoidStone établi. Profil réel35nav/120selection/gameplaynull conservé, même équipe bloque sans exemption. V585 huitmagiques/huitphysiques/44refus/360ticks et quatre cas occupation hérités ; MR30/55,alliés65 bloqués/ennemis traversés chezKassadin etGaren. Anciennes corrections DDS préfixe/cassepreload/CHECK/compteurs conservées, pas échecs actuels. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; stockages et binaires inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2346 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Katarina-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1360 Katarina passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KATARINA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_katarina_passive_vfx_20261105 :102/102 contrôles documentaires,106/106 cohérence séparée du même agent. Deux Lua/deux initialisations/sept affectations, pas AutoBuff reconnu non absence globale. Conflit15s tous délais/10sR+refresh bases et aliasVoracity/KatarinaPassive conservés. Deux preloads277octets/trois références ; deux DDS2872/64DXT1/mip7/membres116 identiques héritées.35 ancres/17 Rust+deux JSON ;24 comparaisons sélectionnées et118 contextuelles,14 communes etdeux animations concordantes.

Crédit générique et CDR/bonusCodex/refundEzrealQ distincts. V586 quatre cas45MELEE/112refus/720tail+451wait, crédits400/400/86.875/0 et délais non armés hérités ; aucune mesure isolée de remboursement. Contexte V671 réutilisé depuis deux documents : sixliens, événement3296454057/quatre médias disponibles ; filtreambiant/lookup actuels excluent la particule, pas decodeur/banque/WAV/sonde/écoute relancés. AncienBUILD101 releases→release puisBUILD/RUN0 conservé, pas erreur actuelle. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; stockages inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2347 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, AUDIO, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Kayle-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1361 Kayle passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KAYLE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kayle_passive_vfx_20261105 :89/89 contrôles documentaires,95/95 cohérence séparée du même agent. Cinq Lua/trois initialisations/huit affectations ; Q/E NEWTABLEpc14/18 limites sanspath, propriétaire deux AutoBuff vides et persistence distincts débuffcible sans flags. Trois preloads976octets/12références, Qdébuff non trigger et E skin07 non baseacceptance. DDS2176/64DXT1/mip0/membre200 héritée ;DivineBlessing non localisée dans scopes antérieurs.31ancres/14 Rust ;21 comparaisons sélectionnées et112 contextuelles,14communes etdeux animations concordantes.

3%armure/MR/5s/max5 connus ; statsbase/objets/Trundle R et pénétration génériques distincts. V587 deux cas14MELEE/4AnnieQ/34refus/360tail+334wait hérités, défenses20.88/30 ou35.88/55 ordinaires ; checkpoints149/150/151/181 sans débuff non expiration. Q/E refusés, pas de cumuls/règle de refresh qualifiés. AncienBUILD/RUN6059520B et contexteV586 BUILD101 conservés inertes. Aucun nouveau build/jeu/natifD/GPU/REA/probe ;stockages inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2348 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Kennen-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1362 Kennen passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KENNEN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kennen_passive_vfx_20261105 :119/119 contrôles documentaires,111/111 cohérence séparée du même agent. Onze Lua/onze initialisations/32 affectations ; Char109 non vide/Teemo, MegaProc56 vide ; trois AutoBuff vides contextes W/E non absence globale. Suffixe.lua non alias effectif. Neuf preloads2295octets/30références ; deux DDS2176/64DXT1/mip1/membres25 identiques héritées.37 ancres/14 Rust+JSON ;23 comparaisons sélectionnées et92 contextuelles,14 communes etdeux animations concordantes.

6.25s marques/3marques/1s stun/25énergie/répétition7s connus, refresh/diminishfacteur/ordre ouverts. Énergie et contrôle génériques acquis, pas producteur MarkOfStorm établi. V588 base/Sapphire12attaques àdistance/30refus/360tail, énergie plafonnée à200, régénération10/s ; W nonappris et aucun déficit non remboursement mesuré. Témoin Annie séparé5Q/38ticks/8refus/424wait et mouvementaprès expiré, non Kennen1s. Lecteur Lua additionnel non enregistréSOURCE etnon exécuté conservé. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; binaires/stockages inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2349 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Khazix-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1363 Kha’Zix passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KHAZIX_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_khazix_passive_vfx_20261105 :118/118 contrôles documentaires,109/109 cohérence séparée du même agent. Onze Lua/deux initialisations vides/zéro global qualifié/neuf limites NEWTABLE ; buff objet de limite non BuffName inventé, aucune absence d’effet déduite. Six preloads2763octets/37 références ; DDS2872/64DXT1/mip7/membre126 héritée.39 ancres/15 Rust+deux JSON ;22 comparaisons sélectionnées et92 contextuelles,14 communes etdeux animations concordantes.

Enemyteam nevoitpas propriétaire puisattaque champion/bonusmagique/slow2s connus,f1/f2/f3 ouverts,3/35/4/3 non formules. Vision etgardeattaquant-vers-cible de sens distinct ; défaut1350/rayons/LOS/Ignite acquis, pas événement readiness établi. V589 AP0/20 huitMELEE/32refus/240hidden/360tail hérités ; tableaux V1234 parcas2164samples/1860motionframes/projection concordante conservés sans recomputation. Targetspeed330, pasbonusmagique/slow observé ; natifvision/stealth non qualifiés. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; binaires/stockages inertes. Six opérations documentaires attendues après préparation complète, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2350 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète, feature, inconnues, acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-KogMaw-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1364 Kog’Maw passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_KOGMAW_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_kogmaw_passive_vfx_20261105 :112/112 contrôles documentaires,109/109 cohérence séparée du même agent. Six Lua/cinq initialisations/18 affectations ; Surprise NEWTABLEpc26, trois AutoBuff Display vides non absence globale. Quatre preloads1546octets/20 références ; deux DDS2872/64DXT1/mip7/membres252/251 identiques héritées.38 ancres/15 Rust+un JSON ;24 comparaisons sélectionnées et95 contextuelles,14 communes etdeux animations concordantes.

Description4s/100+25niveau dégâts bruts et trois textes160+30niveau magiques divergent ; vitesse330 Dead et CastRadius1000/CastRange1600/Coeff0.7 non règles du passif. Mort/refus/réapparition et animation death génériques conservés, pas producteur post-mortem/explosion établi. V590 deux cas32impacts/2morts/164refus dont110morts/960ticks, deux respawns480ticks hérités ; tableaux V1235 non recomputés, cible100 non rayon natif. Aucun nouveau build/jeu/natifD/GPU/REA/probe ; binaires/stockages inertes. Six opérations documentaires exit0 après préparation, registre terminal fait autorité.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2351 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Leblanc-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1365 LeBlanc passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LEBLANC_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_leblanc_passive_vfx_20261105 :115/115 contrôles documentaires,113/113 cohérence séparée du même agent. Six Lua/six initialisations/neuf affectations ; Nondispellable/NonDispellable et NoxianCruelty préservés, zéro AutoBuff reconnu non absence globale. Quatre preloads1115octets/15 références ; deux DDS2872DXT1mip7/membre153 et4224DXT5mip1/membre107 héritées.41 ancres/17Rust ;29 comparaisons sélectionnées et127 contextuelles,14 communes etdeux animations concordantes.

Texte sous40%/1s invisibilité/clone sans dégâts au plus8s/recharge60s/Alt+clic droit. Lookup pet générique, création Tibbers et entrée clavier Annie spécifiques ; pas producteur Image miroir établi. V591 deux cas24impacts/54refus/quatre franchissements/4102idle hérités, phases1810/241 ; égalité40% non exercée et cooldown non armé. Tableaux V1236 non recomputés ; deux échecs historiques lane/NPC conservés, onze identités de captures concordantes ; erreur générateur connue seulement par MD, original indisponible. Recherche root erronée corrigée, current01 garde chemins relatifs et collect01 unicité vision corrigés, scripts/résultats/logs conservés. Huit opérations documentaires : six exit0/deux exit1 initiaux. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2352 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-LeeSin-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1366 Lee Sin passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LEESIN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_leesin_passive_vfx_20261105 :109/109 contrôles documentaires,106/106 cohérence séparée du même agent. Onze Lua/quatre initialisations/22 affectations, sept NEWTABLE ; dix champs AutoBuff dont deux paires passif/cosmetic L_hand/R_hand et ETwo L_Hand/R_Hand. Un preload364octets/cinq références ; deux DDS2872/64DXT1/mip7/membres188/25 identiques héritées, pas alias effectif.32 ancres/11Rust+unJSON ;22 comparaisons sélectionnées et100 contextuelles fraîches,une identité binaire héritée gardée inerte parmi101,14 communes etdeux animations concordantes.

Texte deux attaques40%AS/15énergie après capacité ; binding Shen/Jax/mana/niveaux3/7/11/15 contradictoire conservé, pas politique adoptée. Pas producteur Rafale établi ; AS/ressource/attaques génériques acquis. V592 base/Sapphire/Dagger18impacts/81refus/540tail hérités, cadences46/46/40, énergie200cap/taux10/s ; aucun sort accepté ou remboursement non plafonné mesuré. Tableaux V1237 non recomputés ; profilEnergy sanscap, copie binaire et ancienéchec inspection inertes. Erreur root de schéma corrigée et conservée ; six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2353 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Leona-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1367 Leona passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LEONA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_leona_passive_vfx_20261105 :122/122 contrôles documentaires,113/113 cohérence séparée du même agent. Neuf Lua/neuf initialisations/31 affectations ; passif propriétaire quatre champs/persistence distinct marque cible deux champs, deux AutoBuff E vides non absence globale. Huit preloads2949octets/38 références ; deux DDS2176/64DXT1/mipbrut0/membre37 identiques héritées, pas alias effectif.34 ancres/13Rust+unJSON ;24 comparaisons sélectionnées et99 contextuelles fraîches,une identité binaire héritée inerte parmi100,14 communes etdeux animations concordantes.

Texte sorts dommageables/marque3.5s/dégâts alliés consomment, @f2@ ouvert ; niveaux1/4/7 etSolarBarrierDDF0.2 non formule Sunlight. Pas producteur marque/consommation établi ; AnnieQ/Pyromania et dégâts génériques acquis. V593 AP0/20 équipes0/0/1 sixmelee/sixQalliés54refus360tail416wait hérités, marque jamais appliquée ; contrôle80brut60mana120ticks ettolérance0.002 non Sunlight/scaling. Tableaux V1238 non recomputés, snapshots postcast/refus ethealthwait absents. Binaire inerte ; inspection passed/MDcode0 sans reçu original, BUILD/RUN0 bruts hérités. Six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2354 entrées sales groupées conservées. Seul audit borné clos ; tâche VFX complète,feature,inconnues,acceptation et goal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Prochain lot CH-Lissandra-PASSIF-PRESENTATION-VFX ; sources et critères dans next_lot.json.


## Reprise SYS-01.2-02 — V1368 Lissandra passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LISSANDRA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_lissandra_passive_vfx_20261105 :136/136 contrôles documentaires,128/128 cohérence séparée du même agent. Onze Lua/cinq initialisations/17 affectations,six NEWTABLE ; Passive/Buff persistence non lifecycle,Ready non substitué à PassiveBuff nonrésolu,SlowChronokeeper/GLOBAL_SLOW distinct du passif. Huit preloads2897octets/37 références, espace final E conservé ; DDS2176/64DXT1/mipbrut0/membre161 héritée.38 ancres/16Rust+deuxJSON ;24 comparaisons sélectionnées et104 contextuelles fraîches,une identité binaire inerte parmi105,14 communes etdeux animations concordantes.

Texte18s prochain sortgratuit/1s réductionparentravecapacité,objets exclus. Pas producteur Iceborn établi ; mana/CDR/CC génériques acquis. ProfiltypeMana : source_sha23f9… communautaire malgré cheminnatif, native0740… distincte ; caveat confirmé noncorrigé, lifecycletype seul réutilisé depuis E avecSHAactuel sanslectureFdu corps. V594 base/Codex AP0/30 CDR0/10% sixranged102refus1082idle hérités, mana304cap etsortsrefusés ; Stop/539/540/541 nonarmement/18s, pas gratuit ouentrave exercés. Tableaux V1239 nonrecomputés, rawpairs/HPidle absents. Anciennes préparations/retries etlimites de reçus/quoting conservées,binaire inerte. Sept opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2355 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Quatre clauses précises,dontprovenance ; prochain CH-Lucian-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1369 Lucian passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LUCIAN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_lucian_passive_vfx_20261105 :119/119 contrôles documentaires,111/111 cohérence séparée du même agent. Treize Lua/quatre initialisations/11affectations,neuf limites NEWTABLE non corruption ; Passive25.dds/persistence distinct BuffLucian_Passive.dds/recap,DravenE distinct. Six preloads2024octets/28noms dont buff/sound,Rageblade/Hurricane non exécution. DeuxDDS2176/64DXT1/mipbrut0/membres172 et25 différentes héritées.34ancres/13Rust ;25comparaisons sélectionnées et105contextuelles fraîches,une identité binaire héritée inerte parmi106,14communes etdeux animations concordantes.

Texte fin de sort/6s/double tir,on-hit etclasses de cible connu,@f1@ ouvert ; Shot/DummyCoefficient1.2000000000000002 non formule. Pas producteur Pistolero établi dans les corps inspectés ; attaques/projectiles/physique/voldevie/crit/recap génériques acquis. V595 deuxcasbase/SwordAD52.04→62.04,siximpacts102refus362idle hérités ; mana298.88cap,toussortsrefusés. Stop/179/180/181 non armement/expiration ; tableaux HUD nonrecomputés,paires brutes refus/PVidle absents. Binaire inerte ; inspection passed/MDcode0 sans reçu brut,BUILD/RUN0 hérités. Deux anciens inventaires et caveat provenance conservés. Huit opérations documentaires,six exit0/deux exit1 initiaux corrigés avec logs ; lecture root modèle malnommé transcrite. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2356 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises ; prochain CH-Lulu-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1370 Lulu passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LULU_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_lulu_passive_vfx_20261105 :150/150 contrôles documentaires,120/120 cohérence séparée du même agent.29Lua/25initialisations/102affectations,quatre limites NEWTABLE non corruption ;16AutoBuff dont12vides,EVisionheadbone/globalWatched eteffetR contextes distincts. Passive157 sansBuffTextureName,persistence noncycle.13preloads3625octets/49noms,companioncharacter/robot/variants/rootspell nonrecette ; DDS5616/64DXT5/mips7/membre80 héritée.39ancres/14Rust ;25comparaisons sélectionnées et107contextuelles fraîches,une identité binaire héritée inerte parmi108,14communes etdeux animations concordantes.

Troisboltsmagiquesguidés/interceptés etporteurtextuels connus,@f1@/@f2@ ouverts ; QDDF0.133/MissileCoefficient1.2/pet24 nonformule,Caitlyn/Lux/Ezreal/Ashe eticôneslegacy conservés. Pas producteur Pix/salve/transfert établi ; lookup familiergénérique maiscréationTibbers/AnnieR spécifique. V596 deuxcasAP0/20,AD46.368inchangé,sixhits/sixprojectiles54refus360idle hérités ; attaqueordinaire pertinente observée,Erefusé,aucune salve/transfert qualifiés. Stop180 non duréepassif ; septsnapshots/cas,pairesrefus/PVidle/entreimpacts absents,tableaux hérités sansrecomputation. Binaire inerte ; OBSpassed nonrawexit,BUILD/RUN0 hérités. Caveat ressourcecommunity2c2e contrea266native conservé. Six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2357 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises ; prochain CH-Lux-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1371 Lux passif VFX, sources et consommateurs

Liaison bornée terminée : docs/AUDIT_SYS01202_LUX_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_lux_passive_vfx_20261105 :126/126 contrôles documentaires,110/110 cohérence séparée du même agent.14Lua/deuxinitialisations/sixaffectations,12limitesNEWTABLE noncorruption ; Passive299flags/persistence distinct cibleFraulein360NEWTABLE8,aucunAutoBuff qualifié nonabsenceglobale. Septpreloads2284octets/30noms dontparticulecible etRmis,mapping nonrecette/ordre ; DDS2872/64DXT1/mips7/membre25 héritée.34ancres/13Rust ;25comparaisons sélectionnées et114contextuelles fraîches,une identité binaire héritée inerte parmi115,14communes etdeux animations concordantes.

Texte6s/marque/attaqueLuxconsomme/magique etRdéclenche-refresh connus,@f1@/@f2@ ouverts ; coefficients0 non dégâts0,Rmain0.75/CD80/range25000 distinct Rmis0.7000000000000001/CD60/range3500. QuatreSpellDatakeys absents nonquatreBuffDataabsents ; DDFcheminborné,26Nightmareexclus,20community secondaires. Pas producteur Illumination établi ; V597 deuxcasAP0/20,AD53.544inchangé,sixhits/sixprojectiles54refus360idle hérités,mana334cap,toussortsrefusés etaucunemarque. Stop180 nonexpiration ; pastransfertconclusionLulu,snapshotssept/cas,pairesrefus/PVidle/entreimpacts absents,tableaux hérités sansrecomputation. Binaire inerte ; OBSpassed nonrawexit,BUILD/RUN0 hérités. Caveat ressourcecommunity15a64/natif5239 conservé. Six opérations documentaires exit0. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2358 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises ; prochain CH-Malphite-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1372 Malphite passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_MALPHITE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_malphite_passive_vfx_20261105 :147/147 contrôles documentaires,133/133 de cohérence séparée du même agent. Deux reçus V548/V598 distincts :14identités communes aux39, sans conflit.13Lua/quatreinitialisations/10affectations, neuf limites NEWTABLE ; Shield normal, BeenHit gris/nom avec espaces et Removal AutoBuff vide distincts.12preloads2539octets/30noms, Leona hit et QWER non substitution ; DDS4224DXT5/2176DXT1,mip1,membres25/79 héritées.41ancres/15Rust+JSON ;29comparaisons sélectionnées,126contextuelles fraîches et une identité binaire inerte parmi127 ;14communes/deux animations concordantes.

API de bouclier générique acquise : création explicite, remplacement du tag, absorption après mitigation, nettoyage. Pas de producteur naturel Malphite établi. Texte10%/10s connu ; reset « pas touché/pas de dégâts »,@f1@/@f2@,priorité,skin06,mort/PVmax ouverts. V598 deuxcasPVmax574.2/724.2,sixphysiques/deuxQadverses acceptés,102refus602idle, offsets299/300/301 et boucliers vides ; propres sorts refusés non explication suffisante. V548 troiscas/neuffenêtres301ticks, neufrefusAttack/cinqévénements ; unique grant serveur diagnostique1418,57.42capacité,absorptions45.113+12.307/débordement32.806 hérités, non passif. V59812snapshots/cas,pairesrefus etPVidle/entreimpacts absents,tableaux nonrecomputés. Binaire inerte ; OBSpassed nonrawexit,BUILD/RUN0 hérités. Caveatcommunity5c5ab/natifb9a9 conservé. Six opérations documentaires exit0 ; aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2359 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises ; prochain CH-Malzahar-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1373 Malzahar passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_MALZAHAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_malzahar_passive_vfx_20261105 :156/156 contrôles documentaires,128/128 de cohérence séparée du même agent.23Lua/23initialisations/80affectations,sixLua56vides,zéro limite ; Ready/Count/Detonation etPhase2/3 distincts,11AutoBuff nonvides,attaches mains etE/R préservées.13preloads3643octets/48noms dontcharacter malzaharvoidling,flash/transform/evo,noncréation/recette ; troisDDS2872/64DXT1/mips7/membre25 différentes héritées.41ancres/14Rust ;28comparaisons sélectionnées,133contextuelles fraîches etune identité binaire inerte parmi134 ;14communes/deuxanimations concordantes. Manifestinitial/captured’origine/relocalisation exacte conservés,sansreplay.

Textes4sorts/21s,7s+50%ADarmure,14s+100%AS etPV200+50niveau/AD20+5niveau connus ; Ready«prochainsort»,mapping4e/5e etf1/f2/f3/bonusADproducteurouverts. StatiqueHP200/AD20 nonstatsfinales,MaleficVisionspréférence nonIAcomplète. Mécanismes familiers acquis,créationTibbersbrancheAnnie3 spécifique ; aucunproducteurVoidling établi. V599 deuxcasSwordAD54.7/64.7,sixhits/sixprojectiles246refus1262idle hérités,mana325.6cap,toussortsrefusés,aucunpet/âgearmé. Stop209..631 nonphases,16snapshots/cas,pairesrefus/PVidle/entreimpacts etfullidle absents,tableaux hérités sansrecomputation. Pasdepetobservé nonabsenceglobaleassets. Binaire inerte ; OBSpassed nonrawexit,BUILD/RUN0 hérités. Sixopérations documentaires exit0 ; aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2360 entrées sales conservées. Seul audit borné clos ; tâcheVFX complète,feature,inconnues,acceptation etgoal ouverts. Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises ; prochain CH-Maokai-PASSIF-PRESENTATION-VFX dans next_lot.json.


## Reprise SYS-01.2-02 — V1374 Maokai, réutilisation de V1317

V1317 déjà publié couvre la liaison/applicabilité Maokai : docs/AUDIT_SYS01202_MAOKAI_PASSIF_VFX_READY_APPLICABILITY_LINK_2026-11-05.md. Réutilisation vérifiée dans docs/AUDIT_SYS01202_MAOKAI_PASSIF_VFX_EXISTING_AUDIT_REUSE_2026-11-05.md. Nouveau dossier E:/mapslol3v3/audit_sys01202_maokai_passive_vfx_reuse_20261105 :28/28 contrôles,18/18 cohérence séparée du même agent ;49identités concordantes(43F,sixE),26fichiers code/données,24comparaisonsV600,14communes,deuxsources etrapport existant,sous-groupes recouvrants. Contrat/trace/métadonnées V600/runtime identiques. Anciens48/54/16 hérités,pas nouveaux tests ; aucune nouvelle clôture d’audit,feature,inconnue ou acceptation.

Deuxeffets prêts Maokai etbone connus,soin/compteur/activation etidentité/montage/Troy/rendu toujoursouverts. Six propositions historiques conservées parréférence,aucunstatutmodifié. Refus d’écraser dossierexistant etlecturebootstrap_configinexistant transcrits puisrepriseadaptée ; originauxV1317intacts. Six opérationsdocumentairesexit0,aucunbuild/jeu/natifD/GPU/REA/probe ni recherche sémantique répétée.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2361 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés. Suite CH-MasterYi-PASSIF-PRESENTATION-VFX dans next_lot.json ; référence d’animation ordinaire V1373 transmise,à revalider si utilisée. Goal actif,fonctionnalité Maokai ouverte.


## Reprise SYS-01.2-02 — V1375 Master Yi passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_MASTERYI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_masteryi_passive_vfx_20261105 :160/160 contrôles documentaires,123/123 cohérence du même agent,sept rubriques. Source V601/54identités/23Lua/14initialisations70globals/neuf limites ; Passive/Ready/Stacks distincts,32AutoBuff Wuju E non recette du passif.11preloads3088octets39noms dont masteryi_base_p_tar.troy ; deuxDDS2176/64DXT1/mipraw0/membre172 nonlookup/rendu.13Rust34ancres,25comparaisons sélectionnées145contextuelles fraîches+uneEXE inerte parmi146 ;14communes/deuxanimations ordinaires concordantes,chaîne V1374→V1373 explicite.

Texte quatrième attaque et seconde50% connu ; compteur,auto-comptage,consommation,formule/temps/interactions/recette ouverts. Troiscas base/Sword/Dagger AD60.04/70.04/60.04,cadence44/44/38,24impacts81refus540idle hérités. Attaques candidates exercées,sorts refusés non explication suffisante ; dégâts ordinaires4/8,aucune seconde frappe qualifiée.917frames sansPV,24pairesPVcible,21extrémitésentreimpacts,sixfullsnapshots/cas etNPCprésents ; rawrefusalpairs/PVidle/fullidle absents,tableaux hérités sansrecalcul. OBSpassed nonrawexit,BUILD/RUN0 hérités,binaire inerte. Sixopérations journalisées exit0 ; message final cp1252 initial échoué après écritures, gardes0 conservés. Aucun nouveau natifD/build/jeu/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2362 entrées sales conservées. Tâche VFX complète,fonctionnalité,inconnues,acceptation etgoal ouverts ; Goal/Plan/UI/bases/registres/produit inchangés. Trois clauses précises dans corrections_and_restart.json ; prochain MissFortune avec recherche préalable d’audit existant,next_lot.json.


## Reprise SYS-01.2-02 — V1376 Miss Fortune passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_MISSFORTUNE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_missfortune_passive_vfx_20261105 :73/73contrôles documentaires,122/122cohérence du même agent,sept rubriques. V602/62identités/27Lua/18littéraux45globals/neufNEWTABLE etseptLua56vides. Strut190/Debuff200/Stacks162 distincts,Passive/StackW nonStrut,uniqueAutoBuffE GLOBAL_SLOW.TROY nonrecette.13preloads3406octets42noms dontmissfortune_base_p_buff.troy/root etDebuffautoréférence ; troisDDS2176/64DXT1/mip1 normalesidentiques239/25,grise79 différente,nonlookup/rendu.13Rust35ancres ;27comparaisons sélectionnées104contextuelles fraîches+uneEXE inerte parmi105,14communes/deuxanimations ordinaires concordantes.

Textes5s/25/+8s/cap70 connus ; attacked/hit/damage,timer/reset/paliers/caps/recette ouverts. Mouvement/Bottes etQAnnie acquis,pasproducteurStrut établi. V602 base/Bottes325/350,1324waitticks,deuxQraw80cost60,huittrajets216pas208fullspeed54refus hérités ; candidatsmouvement/dégâts exercés malgré refuspropresorts,pasbonusinitial doncresetnonqualifié.84bornes34fullsnapshots20ticksuniques,PVpar-tick etpaireadjacenteimpact absents,endpointconditionnelregen,rawrefusalpairs/aftercastmana absents,NPCnonuniversellementexclus. Tableaux nonrecalculés,EXEinert6057472SHA262a20e7,rawinspectionexitnull/BUILD-RUN0 hérités.18entréescapture dont13pinhistoriques/cinqidentitésultérieures,17nonEXErelues ; champsabsentspasinventés. Septopérationsjournalisées,sixexit0 etdocumentation01exit1 initial(successeurcorrigéMonkeyKing,script/logsconservés),troisincidentsroot transcrits sansmutationsource. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2363 entrées sales conservées. TâcheVFX complète,fonctionnalité,inconnues,acceptation etgoal ouverts ; Goal/Plan/UI/bases/registres/produit inchangés. Troisclauses précises ; prochainMonkeyKing,next_lot.json.


## Reprise SYS-01.2-02 — V1377 Wukong passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_MONKEYKING_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_monkeyking_passive_vfx_20261105 :62/62contrôles documentaires,107/107cohérence même agent,sept rubriques. V603/64identités/27Lua/17initialisations46globals/dixNEWTABLE,cinqLua56vides ; Passive227Cassiopeia distinctStoneSkinpersonnage,AutoBuffcinqvidesR nonabsenceglobale.16preloads3548octets42noms,Death/remove-rocks etQpassive dépendances nonrecette ; deuxDDS2176/64DXT1/mip1/membre40identiques,Vi réutilisé,candidatCassiopeia étranger nonouvert,provider/pixelsouverts.17Rust37ancres ;31comparaisons recouvrent43contexteF,EXEinert séparéehors43,14communes/deuxanimations ordinaires concordantes. HUDV1298corrigé134/127hérités,projection279686 liéeaux10349396originauxsanschecks dupliqués.

Deuxcas6joueursMap10 base/Cloth15+NullMagic25,armure24.88/39.88MR32.1/57.1constantes,ennemis0/0/1/2/3/3/2/1/0,deuxalliéstémoins,rayon600observateur nonnatif. Sixphysiques/deuxQAnnie540idle54refus28trajets/quatreStopMove hérités,proximitéexercée maisbonusabsent ; propresortsrefusés nonexplication. f1/niveaux/rayon/éligibilité/recetteouverts.540statframes/36bornes,pasPVpositionpar-tick,pairepréimpact/pairebruterefusabsentes,Qendpoint12regen dérivé nonmesureadjacente. TroisanciensBUILD0/RUN101 et16diagnostics préservés,finalBUILD/RUN0/0hérités nonréparationnavigation,OBSpassednonrawinspectionexit. Binaire6129664SHAf9089daa inerte,1158dépendancesnonrejouées. Septopérationsdocumentaires,six0/collect01initial1 corrigé(hituniqueattacks539testrejetaliaswukong,nonpassif),logs/scripts/préuveconservés. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2364 entrées sales conservées. TâcheVFX complète,fonctionnalité,inconnues,acceptation etgoal ouverts ; Goal/Plan/UI/bases/registres/produit inchangés. Troisclauses précises ; prochainMordekaiser,next_lot.json.


## Reprise SYS-01.2-02 — V1378 Mordekaiser passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_MORDEKAISER_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_mordekaiser_passive_vfx_20261105 :57/57contrôles documentaires,117/117cohérence même agent,sept rubriques. V604/57identités/24Lua/24littéraux42globals/zérolimite,douzeLua56vides ; IronMan194persistence sansAutoBuff,effetWvide/Qeffect+bone distincts. DeuxDDS2176/64DXT1/mipbrut0/membre25identiques,nonlookup/rendu.13preloads3376octets identifiés,contenu nonqualifié : découverte830679SHAe4c889f5… absente descaptures13 etducheminE/blobsSHAprécis consultés ; source/reprise exacte documentée,aucunoldF-work/D.17Rust43ancres,18comparaisons recouvrent31contexteF,EXEinert séparée,14communes/deuxanimations ordinaires concordantes. Provenancecommunity40ff002b vsnative69844e00 préservée.

Textef2%conversion/f1max/3%parseconde/moitiésbires connu,formules/cadence/plancherouverts. PorteurShield120 nonabsorption ; PVmax555.4/705.4,Ruby150/Sapphire200,ressource120regen0,sixsortants/sixphysiquesentrants/deuxQAnnie244idle54refus hérités. Aucun dégât de compétence accepté : déclencheur nonexercé,pasIronMan. DiagnosticAPI séparé absorbe50,expire80à30ticks/31observés,septrefus,nonpassif.244waitframes sansPVpositions,24bornes,impactsnonpairepréhit etrefusnonpairesbrutes,tableauxnonrecalculés. BUILD/RUN0bruts hérités,OBSpassednonrawinspectionexit,bin6107648SHAf270d2f8 inerte. Sixopérations documentaires exit0 ; une lecture root mapping/liste corrigée/transcrite sansmutation. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2365 entrées sales conservées. TâcheVFX complète,fonctionnalité,inconnues,acceptation etgoal ouverts ; Goal/Plan/UI/bases/registres/produit inchangés. Troisclauses précises ; prochainMorgana,next_lot.json.


## Reprise SYS-01.2-02 — V1379 Morgana passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_MORGANA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_morgana_passive_vfx_20261105 :64/64documentaires,117/117cohérence même agent,sept rubriques. DeuxreçusV555498698SHA37fce10b…/V6052049558SHAdc1b5e98… distincts,7identitésanciennes sous-ensemble28,pas35. V60510Lua/troislittéraux8globals/septNEWTABLE,natifChar118flagsnonvide/communautairevide,EmpathizeAura215,nopassiveAutoBuffqualifié nonabsenceglobale. TroisDDS4224/64DXT5/mip0 identiquesEliseSpiderling130/Morgana40/Spells25,nonprovider/pixels/mécaniqueElise. Septpreloadidentités2556bytes connues,contenu nonqualifié : découverte762704SHA056b4eb8… absente descaptures etdespistesEexactes,conditionrepriseexplicite.16Rust37ancres,17selected recouvrent31contexteF,deuxEXEinertes séparées,14shared/deuxanimations ordinaires concordantes. Provenancecommunityce2bcc vsnativec99edc conservée.

V605 base/Tome20AP/Sceptre10AD8%,AD55.46/55.46/65.46,neufsortants/neufentrants/troisQAnnie540idle81refus sixtrajets hérités. Soinordinaire4.39255Sceptre,baseAPrésidus2e-6 ; neufpairesPVsource moinsmédianeregen0.03805542/tick,tolérance0.002 modèleconditionnelhérité,PVciblepréimpact/refusalrawpairs absents. V555 troiscontrôlesdistincts,Morgana0/4.10614PV etAnnie3.78937/Wsanssoin,41refus90ticks nonfusionnés. Aucun dégât de compétence Morgana accepté,déclencheurnonexercé. f1/niveaux/AoE/ticks/cibles/recetteouverts ; Wcommunity16timers/commentairepulse etW275/natif280,R600/natif625 distincts. BUILD/RUN V6050bruts hérités,OBSpassednonrawinspectionexit,deuxbin6094848/6047744 inertes. Septopérationsdocumentaires,six0/coherence01initial1 corrigé(hashcontrôleissuancienlot,script/JSON/logsconservés),sourcesintactes. Aucun nouveau build/jeu/natifD/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2366 entrées sales conservées. TâcheVFX complète,fonctionnalité,inconnues,acceptation etgoal ouverts ; Goal/Plan/UI/bases/registres/produit inchangés. Troisclauses précises ; prochainNami,next_lot.json.


## Reprise SYS-01.2-02 — V1380 Nami passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NAMI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nami_passive_vfx_20261105 :66/66 documentaires,117/117 cohérence même agent,sept rubriques. V606/63identités,26Lua/12initialisations50globals/14limites ; porteur247/Janna distinct bénéficiaire209/NamiPassivett/Nami_Base_P_buf.troy. Douze preloads4310octets : identités seules, découverte970768/SHA3595ca96… non capturée dans les pistes E précises ; aucune absence globale ou recette inventée. Deux DDS distincts2872DXT1mip7/4224DXT5mip1, non lookup/rendu. Dix Rust29ancres,11comparaisons recouvrant25contexteF,quatre binaires inertes hors25 ;14mécanismes/deux animations ordinaires concordants. Provenance communautaire51992d… distincte du natif2a9614… conservée.

Texte40+f1/1.5s connu,contact allié non exercé et aucun bonus qualifié. Deux cas3joueurs : Nami335/360,Ahri330,AP0/20,102refus184wait,huit trajets512samples198full ; six arrivées réussies,deux Ahri23 échouées à36unités avec destination déjà null avant Stop. Collecte finale0/0 non fidélité du mouvement ; trois anciens BUILD0/RUN101 conservés. V564 contexte non cause établie. Quatre clauses dont diagnostic relié à CH-Ahri-MOUVEMENT-CHEMIN existante ; registre inchangé. Six opérations documentaires exit0,une erreur de lecture root mapping/liste corrigée/transcrite. Aucun nouveau build/jeu/natif/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2367 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés. Fonctionnalité,tâche complète,inconnues,acceptation et goal ouverts. Prochain Nasus : réutiliser d’abord les audits disponibles, next_lot.json.


## Reprise SYS-01.2-02 — V1381 Nasus passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NASUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nasus_passive_vfx_20261105 :74/74documentaires,158/158cohérence même agent,sept rubriques. V540six identités sous-ensemble32V607,pas38 ;12Lua/sept initialisations23globals/cinqNEWTABLE,CharScript56vide/Passive210flags. Sept preloads3499octets/45références dont nasus_base_p_lifesteal.troy ; texteLF normalisé,reconstructionCRLF conforme aux sept empreintes. Aucun AutoBuff littéral non absence ; Q/W constants limités non recette passive. DDS2176/DXT1/mip0/membre188 non lookup/rendu.16Rust38ancres,17selected recouvrant31contexteF,14shared/deux animations ordinaires concordants ; deux identités binaires Nasus inertes distinctes.

Taux courant objets seulement ; f1 natif/niveaux/cumul ouverts. V607 trois cas AD59.18/69.18/69.18,taux0/0/8%,neufsortants/neufentrants/troisQ540wait81refus six trajets hérités ; seul Sceptre soigne4.64219PV. Attaques candidates exercées, refus sorts non explication suffisante. V540 distinct : deux cas sixfrappes0/4.33948PV et taux0/8% niveaux1–18 par API expérience, non éliminations ni combats2–18. NasusQ reste non résolu ; ancien typo/inspection1 conservés,non succès inventé. Sept opérations actuelles,six0/collect01initial1 (comparaison forme de fiche) corrigé,script/JSON/logs archivés. Aucun nouveau build/jeu/natif/GPU/REA/probe.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2368 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés ; tâche complète,fonctionnalité,inconnues,acceptation et goal ouverts. Trois clauses précises ; prochain Nautilus,next_lot.json.


## Reprise SYS-01.2-02 — V1382 Nautilus passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NAUTILUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nautilus_passive_vfx_20261105 :85/85documentaires,213/213cohérence même agent,sept rubriques.79payloadsV608 vs82IDs SOURCE avec trois candidats littéraux contextuels conservés,nonalias.33Lua23initialisations123globals10NEWTABLE ; Passive211Malady,Root256Snared,Check478sixAutoBuffvides distincts.19preloads7995octets99références,texteLF/reconstructionCRLF exacte19 ; root etparticuleslv1/6/11/16 nonrésolveur oupaliersqualifiés. QuatreDDS2872DXT1mip7 deuxpairesStaggeringBlow77/Malady25 distinctes,nonlookup/rendu.17Rust41ancres18selected/32contexteF,EXEinert séparée,14shared/deuxanimations ordinaires concordants. Source_sha29a536community7382 distinctnatife61269/2654.

V608deuxcasbase/SwordAD57.544/67.544,6sortants6entrants2Q360wait54refus4trajets hérités ; dégâts ordinaires seuls,aucunbonus/rootqualifié. Cible mobileoffsets1/2/3danschaquecas à335,11.1665039unités/tick : sixpositionsnonpreuveuniverselle,natif f1/f2/f3 ouvert. Genericgrant_stunannulewindup/presentation,nonrootNautilus ; immunitéparciblenonqualifiée. Sixopérationsdocumentaires exit0,aucunbuild/jeu/natif/GPU/REA/probe nouveau.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2369 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés ; tâche complète,fonctionnalité,inconnues,acceptation etgoal ouverts. Quatreclausesprécises ; prochainNidalee,next_lot.json.


## Reprise SYS-01.2-02 — V1383 Nidalee passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NIDALEE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nidalee_passive_vfx_20261105 :75/75documentaires,187/187cohérence même agent,sept rubriques. V60972sources,23Lua12initialisations41globals11NEWTABLE ; Hunt/Hunted/Hunting/Brush/Prowl/Scent etCougar distincts.14preloads4313octets56références,LF/reconstructionCRLF exacte14 ; effets sol/head/mains et casse préservés,non recette complète. DeuxDDS2176DXT1mip0membre237 distincts ; quatre paires Cougar de contenu égal/chemins distincts non lookup.13Rust37ancres14selected/28contexteF,EXEinert séparée,14shared/deux animations ordinaires concordants. Source_sha09fce9community6704 vsnative20ccd4/2410.

Prowl10/30%2s/5500 etHunt4s connus par textes ;5900CastRange etSwipecontradiction nonrésolus,deuxclésexactesBrushPassive/Bushwhackabsentes. V609base/Bottes335/360,huittrajets280pas272full,158grass76towardvisible82away,244wait54refus2QAnnie4setup hérités. Buisson réellement exercé sans bonus ; Hunt etCougar nonexercés,QAnnie nontrigger. Pas d’expirationactive prouvée ; tableauxhérités sansrecalcul. Sixopérations documentaires exit0,aucunbuild/jeu/natif/GPU/REA/probe nouveau.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2370 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés ; tâche complète,fonctionnalité,inconnues,acceptation etgoal ouverts. Cinqclausesprécises ; prochainNocturne,next_lot.json.


## Reprise SYS-01.2-02 — V1384 Nocturne passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NOCTURNE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nocturne_passive_vfx_20261105 :79/79documentaires,195/195cohérence même agent,sept rubriques. V61059sources/26Lua10initialisations38globals16NEWTABLE ; nativeChar114icon-onlyWolfman nonvide,Tooltip90persist/Umbra407paumes/Cooldown173espaces/Marker341vides distincts.15preloads6793octets84références,LF/reconstructionCRLF exacte15,non recette ouifhasbuffcheck exécuté. NormauxDDS2872DXT1mip7membre25identiques/gris2176mip1membre79distinct,nonlookup/pixels.16Rust37ancres16selectedréels SOURCE/frontières/30contexteF,EXEinert séparée,14shared/deuxanimations ordinaires concordants ; provenancec0809ecommunity9054 vsnativef0b1f4/3723.

Texte10s/120%physique/réduction1s connu,soinf1/rayon/temporisationouverts. V610troiscasAD59.208/69.208/69.208,taux0/0/8%,18sortants9entrants3Q1806wait81refus6trajets hérités ; seulsoinSceptre4.64403PV,attaquescandidatesexercées,uneseuleciblenonzone. Ancien540wording conservé commeerreurhistorique. Huitopérationsjournalisées,sept0/current01initial1nomcapture corrigé ; gardeautonomeStopIterationlecteursupposé corrigée16réelspins. Échecs/scriptsconservés ; contrôleEventrenforcé,premierpassageréussipréservé. Aucunbuild/jeu/natif/GPU/REA/probe nouveau.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2371 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés ; tâche complète,fonctionnalité,inconnues,acceptation etgoal ouverts. Quatreclausesprécises ; prochainNunu,next_lot.json.


## Reprise SYS-01.2-02 — V1385 Nunu passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_NUNU_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_nunu_passive_vfx_20261105 :79/79documentaires,149/149cohérence même agent,sept rubriques. V55311IDs sous-ensemble36V611,pas47 ;13Lua10initialisations37globals3NEWTABLE ; marker208/Counter163/Visionary287limité distincts,NunuBotcontexte skin.5preloads1187octets16références,LF/reconstructionCRLF exacte5 ; deuxDDSnormaux4224DXT5mip0membres40/25égaux/Charging4224mip1membre107distinct.14Rust32ancres15selected/28contexteF,2EXEcapturées+pinV553inertes,14shared/deuxanimations ordinaires concordants. Source_shac38af4community8762 vsnatived05202/3378.

V611base/Sapphire200mana,12attaques102refusétapes0/4/5/6quatretrajets hérités ; huitpairesbrutesavant/aprèsreluesexactes,aucuncastNunuaccepté. CoûtsnatifsQ60/W50/E75..115/R100connus,nongratuité. CapacitéSapphire483.56/réserveinitiale283.56 ; ancienBUILD0/RUN101hypothèsefill corrigédiagnosticmana-bounds0/0,sansfixjeu. V553Nunu/Annie séparés,10attaques24refus182ticks/Wpayant70nonVisionary. Historiquecapture22=20réutilisées+2reçusanciens,duplicationFileExistsErroretarchivesconservés,aucunaccèsactuelF-work/D. Huitopérationsactuelles,six0/deuxcollectesinitiales1ancre/casse corrigées,scripts/JSON/logsconservés. Aucunbuild/jeu/natif/GPU/REA/probe nouveau.

Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2372 entrées sales conservées. Goal/Plan/UI/bases/registres/produit inchangés ; tâche complète,fonctionnalité,inconnues,acceptation etgoal ouverts. Quatreclausesprécises ; prochainOlaf,next_lot.json.


## Reprise SYS-01.2-02 — V1386 Olaf passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_OLAF_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_olaf_passive_vfx_20261105 :32/32 documentaires,52/52 cohérence même agent. 20Lua, neuf preloads/36références, une icône ; aucune recette/rendu passif qualifié. Cadence héritée43/37ticks inchangée malgré PVmanquants ; bonus Dague acquis, bonus passif absent du chemin inspecté. Quatre corrections précises dans corrections_and_restart.json ; prochain Orianna via next_lot.json.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2373 entrées sales conservées. Audit borné clos ; tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1387 Orianna passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ORIANNA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_orianna_passive_vfx_20261105 :33/33 documentaires,56/56 cohérence même agent. 26Lua/19preloads85références/3DDS ; recette passive et rendu ouverts. Bonus magique/cumuls absents des14 impacts hérités0/20AP. Cinq clauses précises dans corrections_and_restart.json ; prochain Pantheon via next_lot.json.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2374 entrées sales conservées. Audit borné clos ; tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1388 Pantheon passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_PANTHEON_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-05.md. Preuves E:/mapslol3v3/audit_sys01202_pantheon_passive_vfx_20261105 :40/40 documentaires,61/61 cohérence même agent. 37Lua/25preloads69références/3DDS ; chaînes compactes/Aegis/W distinctes, recette/rendu ouverts.18impacts hérités non bloqués après0/4/8attaques ; contrôle Armure acquis. Cinq clauses précises dans corrections_and_restart.json ; prochain Poppy via next_lot.json.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2375 entrées sales conservées. Audit borné clos ; tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1389 Poppy passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_POPPY_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_poppy_passive_vfx_20261106 :39/39 documentaires,62/62 cohérence même agent. 19Lua/14preloads43références/2DDS identiques ; dépendance poppyvaliantfighter_eff.troy connue, recette/rendu ouverts.24dégâts hérités ordinaires,10au-dessus/14dessous du seuil illustratif ;sixpairesQbrutes relues,18physiques sans PVaprès bruts. Quatre clauses précises dans corrections_and_restart.json ; prochain Quinn via next_lot.json.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2376 entrées sales conservées. Audit borné clos ; tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1390 Rammus passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_RAMMUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_rammus_passive_vfx_20261106 :43/43 documentaires,64/64 cohérence même agent. Deuxsources V547/V617,32identités natives uniques ;conversion absente du chemin AD inspecté,contrôles Tissu/Épée acquis. Septpreloads/18références,2DDS identiques,recette/rendu ouverts. Quatre clauses dans corrections_and_restart.json ;prochain Renekton, vérifier ses audits existants.

QuinnV1318 réutilisé après40gardesF couvrant22entrées inspectées et source/rapport inchangés ;zéro nouvelle clôture Quinn. Reçu E:/mapslol3v3/reuse_sys01202_quinn_vfx_20261106/reuse_receipt.json. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2377 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1391 Rengar passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_RENGAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_rengar_passive_vfx_20261106 :42/42 documentaires,65/65 cohérence même agent.66Lua/40preloads164références/3DDS ;Passive/NewPassive et variantes non fusionnés.464paires X/Z de marche relues,12dégâts ordinaires ;portée native inconnue,Férocité non exercée par capacité. Cinq clauses dans corrections_and_restart.json ;prochain Riven.

RenektonV1316 réutilisé après39gardesF couvrant21entrées inspectées ;ancien46/47 et qualification conservés,zéro nouvelle clôture. Reçu E:/mapslol3v3/reuse_sys01202_renekton_vfx_20261106/reuse_receipt.json. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2378 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1392 Riven passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_RIVEN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_riven_passive_vfx_20261106 :38/38 documentaires,64/64 cohérence même agent.28Lua/17preloads88références/2DDS ;AABoost base/skin05/r_hand candidats non qualifiés à NEWTABLE.12attaques ordinaires,aucun sort accepté :charges/consommation/expiration non exercées. Quatre clauses dans corrections_and_restart.json ;prochain Rumble,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2379 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1393 Rumble passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_RUMBLE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_rumble_passive_vfx_20261106 :44/44 documentaires,73/73 cohérence même agent.51Lua/22preloads101références/4DDS ;candidats Overheat/head/spine/skin03 non qualifiés à NEWTABLE.18paires chaleur100→100/0→0 et48pairesPVentrants relues ;aucun sort accepté,surchauffe non exercée. Quatre clauses dans corrections_and_restart.json ;prochain Ryze,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2380 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1394 Ryze passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_RYZE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ryze_passive_vfx_20261106 : 39/39 documentaires, 68/68 cohérence même agent. Huit Lua/six preloads/18 références/un DDS ; effet R sur bag_d distinct du passif. Aucun sort Ryze accepté, délais propres nuls. Barrier : présent+59, déjà absent+60, ancien libellé précisé sans retoucher les preuves. Quatre clauses dans corrections_and_restart.json ; prochain Sejuani, chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2381 entrées sales conservées. Tâches, fonctionnalités, inconnues, acceptation et goal ouverts ; aucun build/jeu/installation ni modification du goal, Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1395 Sejuani passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SEJUANI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_sejuani_passive_vfx_20261106 :43/43 documentaires,68/68 cohérence même agent.40 Lua/19 preloads/83 références/deux DDS ;Display précharge sejuani_passive/self,recette non qualifiée. Frost ennemi,Elise et alias particule séparés.647 relevés armure,228 Exhaust et543 attentes hérités relus ;déclencheur candidat exercé sans bonus,f1 inconnu. Quatre clauses dans corrections_and_restart.json ;prochain Shaco,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2382 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1396 Shaco passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SHACO_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_shaco_passive_vfx_20261106 :40/40 documentaires,69/69 cohérence même agent.28 Lua/13 preloads/47 références/deux DDS identiques ;Backstab précharge absolutezero_tar/FromBehind,recette non qualifiée.24 géométries+1/−1 et dégâts relus,aucun bonus arrière observé ;prédicat natif ouvert,facing Shaco absent. Quatre clauses dans corrections_and_restart.json ;prochain Shen,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2383 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1397 Shen passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SHEN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_shen_passive_vfx_20261106 :42/42 documentaires,70/70 cohérence même agent. Sources V549/V625 :18 identités incluses dans57,essais séparés.20 Lua/13 preloads/33 références/deux DDS ;ready_indicator/globalhit_red dépendances non recettes.18paires énergie200→200,restitution sous plafond non exercée ;8s/9s etf1/f2/f3 ouverts. Quatre clauses dans corrections_and_restart.json ;prochain Shyvana,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2384 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1398 Shyvana passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SHYVANA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_shyvana_passive_vfx_20261106 :39/39 documentaires,65/65 cohérence même agent.23 Lua/15 preloads/75 références/deux DDS ;Q,TransformCast dargon etDragonborn séparés. Neuf paires Furie100→100 et543 relevés d’attente relus ;forme/doublement non exercés,f1 inconnu. Quatre clauses dans corrections_and_restart.json ;prochain Singed,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2385 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1399 Singed passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SINGED_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_singed_passive_vfx_20261106 :42/42 documentaires,67/67 cohérence même agent. Trois sources V543/V627/V628,33 identités uniques ;delta avec espace conservé.14 Lua/huit preloads/24 références/deux DDS ;Q/W/R distincts du passif.18 paires de pools,neuf relevés boutique et543 attentes relus ;conversion mana→PV absente sur la route inspectée,politique native/recette ouvertes. Quatre clauses dans corrections_and_restart.json ;prochain Sion,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2386 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1400 Sion passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SION_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_sion_passive_vfx_20261106 :46/46 documentaires,69/69 cohérence même agent.66 Lua/25 preloads/134 références/un DDS ;particules cas/skin/smoke/hand/tar/speed préchargées,sans création démontrée.34 paires PV entrantes et960 trames relues ;958 à zéro PV,puis deux respawns480,aucun intervalle réanimé. Quatre clauses dans corrections_and_restart.json ;prochain Sivir,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2387 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1401 Sivir passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SIVIR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_sivir_passive_vfx_20261106 :41/41 documentaires,67/67 cohérence même agent.19 Lua/11 preloads/26 références/un DDS ;Speed306 passivehaste/spine déclaré,recette/création non qualifiées.660 observations de vitesse et244 paires coordonnées relues ;60 pas mesurés334,995117/360,aucun bonus Fleet observé. Quatre clauses dans corrections_and_restart.json ;prochain Skarner,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2388 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1402 Skarner passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SKARNER_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_skarner_passive_vfx_20261106 :43/43 documentaires,66/66 cohérence même agent.28 Lua/17 preloads/84 références/deux DDS identiques ;stack1/2/3,proc/stun préchargés,sans création démontrée.12 paires mana,cinq relevés boutique et362 attentes relus ;aucune charge amorcée. Charges5s,stunf2,verrou6s et Cooldown10 distincts. Quatre clauses dans corrections_and_restart.json ;prochain Sona,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2389 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1403 Sona passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SONA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_sona_passive_vfx_20261106 :44/44 documentaires,71/71 cohérence même agent.37 Lua/23 preloads/74 références/deux DDS distincts ;Count/Ready et particules QWE référencés,sans scénario démontré.12 paires mana,cinq relevés boutique et362 attentes relus ;aucun cast/charge/variante amorcé. Trois bindings de font réutilisés après garde d’identité,sans relecture sémantique. Quatre clauses dans corrections_and_restart.json ;prochain Soraka,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2390 entrées sales conservées. Tâches,fonctionnalités,inconnues,acceptation et goal ouverts ;aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1404 Soraka passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SORAKA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_soraka_passive_vfx_20261106 :43/43 documentaires,96/96 cohérence même agent.29 Lua/25 preloads/75 références/un DDS ;speed/cross/indicatior et root ne prouvent pas création/orientation.240 trames/26 impacts relus,dont60 versallié blessé sans bonus observé. Quatre clauses précises ;prochain Swain,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2391 entrées sales conservées. Six productions réussies,une cohérence échouée puis reprise,deux erreurs racine conservées. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1405 Swain passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SWAIN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_swain_passive_vfx_20261106 :40/40 documentaires,72/72 cohérence même agent.17 Lua/15 preloads/65 références/un DDS partagé ;Dampening précharge grand_buf/neutralmonster_buf,sans recette ou création démontrée. Quatre paires mana au décès relues,deux événements déficitaires sans restitution ;2084/124 trames héritées sans rejeu complet. Quatre clauses précises ;prochain Syndra,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2392 entrées sales conservées. Six productions réussies,un collecteur échoué puis repris et une erreur racine conservés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1406 Syndra passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_SYNDRA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_syndra_passive_vfx_20261106 :47/47 documentaires qualifiés,66/66 cohérence même agent.51 Lua/31 preloads/180 références/un DDS partagé ;variantes Q5/W5/E5/R3 référencées,sans activation démontrée. Trois niveaux Syndra/douze tentatives relus,refus et rangs0000 ;144prédictions héritées sans rejeu. Quatre clauses précises,QWER distincts ;prochain Talon,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2393 entrées sales conservées. Six productions réussies,un collecteur46/47 qualifié par seul extrait/check49 et une erreur de gabarit conservés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1407 Talon passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TALON_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_talon_passive_vfx_20261106 :46/46 documentaires,71/71 cohérence même agent.25 Lua/15 preloads/48 références/un DDS partagé ;héritages Char114/Wolfman etMercy401/BladeRogue distincts,présentation Mercy dédiée inconnue. Trois impacts conditionnels relus :pas de10% observé après contrôle de l’armure Exhaust. Neuf paires PV héritées sans rejeu intégral. Quatre clauses précises ;prochain Taric,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2394 entrées sales conservées. Six productions0,erreur racine de chemin daté consignée ;anciensRUN101/Char106sur107 conservés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1408 Taric passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TARIC_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_taric_passive_vfx_20261106 :44/44 documentaires,67/67 cohérence même agent.14 Lua/10 preloads/23 références/un DDS partagé ;Gemcraft cible gemstorm,bluehands/hand constants non qualifiés,contradiction armure/mana conservée. Deux impacts non amorcés,cinq relevés boutique et362 scalaires relus ;aucun cast/trigger,délais zéro non discriminants. Cinq clauses dont proc/CDR séparés ;prochain Teemo,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2395 entrées sales conservées. Six productions0. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1409 Teemo passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TEEMO_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_teemo_passive_vfx_20261106 :43/43 documentaires qualifiés,67/67 cohérence même agent.22 Lua/neuf preloads/32 références/un DDS partagé ;Camouflage/Stealth déclarent des sorts,dont teinte/varianteTT,sans provider/rendu qualifiés.364 indicateurs/14seuils relus,pas de furtivité observée selon ces indicateurs ;payloads ennemis complets partrame absents,bonus de sortie nonexercé. Cinq clauses séparées ;prochain Thresh,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2396 entrées sales conservées. Six productions réussies,un collecteur42/43 qualifié par seul nom de méthode,autres42 inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1410 Tristana passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TRISTANA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_tristana_passive_vfx_20261106 :32/32 documentaires,42/42 cohérence même agent.11Lua/quatrepreloads/14références/unDDS ;DrawABead189 précharge deux particules partagées E,sans création démontrée. Portée550 et diagnostics hérités conservés ;existence d’un effet propre au passif inconnue. Quatre clauses précises ;prochain Trundle,chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2397 entrées sales conservées. Six productions0,une erreur de chemin contextuelle consignée. Thresh réutilisé sans doublon. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1411 Trundle passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TRUNDLE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_trundle_passive_vfx_20261106 : 29/29 contrôles documentaires, 43/43 de cohérence du même agent. Deux Lua et deux DDS HUD réutilisés ; le récepteur décès/soin existe, sans présentation spécifique qualifiée. Le commentaire présentant le rayon1000 comme natif reste à clarifier. Quatre clauses précises ; prochain Tryndamere, consulter ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2398 entrées sales conservées. Six productions réussies ; une erreur de clé lors du repérage consignée. Audit borné clos ; tâches, fonctionnalités, inconnues, acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal, Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1412 TwistedFate passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TWISTEDFATE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_twistedfate_passive_vfx_20261106 :30/30 documentaires,46/46 de cohérence du même agent. Douze vues Lua et deux icônes identiques réutilisées ; crédit générique présent, bonus/cumul et présentation spécifiques non établis. Contradiction critique/or, candidat Dragon et texte du preload218 laissés ouverts. Quatre clauses précises ; prochain Twitch, chercher ses audits existants.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2399 entrées sales conservées. Six productions réussies ; une erreur de clé contextuelle consignée. Tryndamere réutilisé après42 gardes sans doublon. Audit borné clos ; tâches, fonctionnalités, inconnues, acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal, Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1413 Twitch passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_TWITCH_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_twitch_passive_vfx_20261106 :35/35 documentaires,50/50 de cohérence du même agent.21Lua/11identités preload/troisDDS HUD ;marqueur champion,poison victime et Q/Expunge distincts. Six compteurs visuels décrits,sans création/cap serveur/rendu qualifiés.817calculs PV réutilisés,sans nouveau jeu. Quatre clauses précises ;prochain Udyr,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2400 entrées sales conservées. Six productions réussies,sans échec actuel. Anciennes corrections bootstrap/Hide préservées. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1414 Udyr passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_UDYR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_udyr_passive_vfx_20261106 :34/34 documentaires,46/46 de cohérence du même agent.15primaires/36vuesLua/troisidentités preload/troisDDS,deuxcontenus ;marqueur persistant et bonus temporaire distincts. Deux paires snapshots égales au tick0,aucune posture admise. Rendu,refresh et rangs Phoenix4/5 non qualifiés. Quatre clauses précises ;prochain Urgot,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2401 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1415 Urgot passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_URGOT_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_urgot_passive_vfx_20261106 :32/32 documentaires,52/52 de cohérence du même agent.12primaires/19Lua/deuxidentités preload/deuxDDS identiques ;alias UrgotEntropyDebuff et dépendance urgotentropy_buf nonapplication/rendu. Durées2.5/3s ouvertes ;66API/23calculsPV hérités,sans contre-attaque ordinaire. Quatre clauses précises ;prochain Varus,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2402 entrées sales conservées. Six productions réussies ;une erreur de repérage et un libellé générique qualifiés. Ancienne attente de comptage corrigée,échec85/86 préservé. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1416 Varus passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VARUS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_varus_passive_vfx_20261106 :34/34 documentaires qualifiés,54/54 de cohérence du même agent.48Lua et trois préfixes distincts ;Display/Minion déclarent deux effets,sans activation/rendu qualifiés. Huit paires létales relues ;f1/f2 et règles du bonus restent inconnus. Prochain Vayne,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2403 entrées sales conservées. Six productions réussies et un échec de comptage conservé :25448cas+241témoin=25689ticks,un seul prédicat corrigé. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1417 Vayne passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VAYNE_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_vayne_passive_vfx_20261106 :32/32 documentaires qualifiés,53/53 de cohérence du même agent.18Lua/quatreidentités preload/unDDS Info ;SpeedPart normal/renforcé vides nonabsenceVFX. Six parcours et12frames témoins relus ;330sansbonus,Rnonactivé ;rayon/angle/rendu ouverts. Prochain Veigar,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2404 entrées sales conservées. Six productions réussies et deux échecs conservés ;helper partiel récupéré et side→sideways seul prédicat corrigé. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.

Paquet initial refusé sur material_read_attempt_failed evidence01 ;prepare_packet_v2 conserve cet unique FileNotFoundError/identity null séparément,sans sourcebytesinventés. Guards des157 lectures réussies et fonctions publisher inchangés ;qualify_packet_failed_read.py et packet_preparation_qualification.json épinglés.


## Reprise SYS-01.2-02 — V1418 Veigar passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VEIGAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_veigar_passive_vfx_20261106 :30/30 documentaires,50/50 de cohérence du même agent. Quatre sources directes/unLua349,deux noms d’icône/un contenu ;CharScript racine enregistré distinct. Quatre bornes mana29/30 relues ;fontaine/Charme distincts,aucun supplément dans les deux déficits. Formule et présentation dédiée ouvertes. Prochain Velkoz,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2405 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1419 Velkoz passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VELKOZ_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_velkoz_passive_vfx_20261106 :33/33 documentaires,58/58 de cohérence du même agent.19primaires/36Lua/cinqidentités preload/deuxDDS ;Apply/Stack/Tracker/Proc distincts. Attaques rafraîchissent sans ajouter ;six reçus relus,aucun sort/refresh/expiry qualifié. Proc icon manque borné,f1/rendu ouverts. Prochain Vi,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2406 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1420 Vi passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_vi_passive_vfx_20261106 :34/34 documentaires,55/55 de cohérence du même agent.16primaires/55Lua/quatreidentités preload/troisDDS ;prêt/actif/recharge distingués. Deux impacts et24samplesBarrière relus,aucuneabilityhit Vi qualifiée. Texte HUD générique conservé,barre nativepending ;f2/f3/renduouverts. Prochain Viktor,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2407 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1421 Viktor passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VIKTOR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_viktor_passive_vfx_20261106 :31/31 documentaires qualifiés,54/54 de cohérence du même agent.37primaires/35Lua/quatreidentités preload/cinqDDS ;prototype/stades/augmentations distincts. Deux cas et12commandes témoins relus ;aucun HexCore produit. AP/f1,choix/rendu ouverts. Prochain Vladimir,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2408 entrées sales conservées. Six productions réussies,deux essais échoués conservés :rôle argparse puis un prédicat recettes string/int qualifié,30autres inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1422 Vladimir passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VLADIMIR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_vladimir_passive_vfx_20261106 :31/31 documentaires,49/49 de cohérence du même agent. Sept sources/deux Lua/deux identités preload/deux DDS de même contenu ;32témoins relus,144calculs hérités. Conversions PV/AP absentes dans les cas archivés ; politique non récursive et besoin/rendu spécifiques ouverts. Prochain Volibear, chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2409 entrées sales conservées. Six productions réussies, sans échec actuel de producteur ; deux erreurs root conservées. Audit borné clos ; tâches, fonctionnalités, inconnues, acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1423 Volibear passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_VOLIBEAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_volibear_passive_vfx_20261106 :29/29 documentaires,49/49 de cohérence qualifiés du même agent.13sources/cinqLua/troisidentités preload/troisDDS,deuxcontenus ;Heal nomme volibear_passive_heal.troy,nonactivation qualifiée.20impacts et8paires aux bornes relus,720calculs hérités. Disponibilité/f1/recharge/rendu ouverts ;potion distincte. Prochain Warwick,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2410 entrées sales conservées. Six productions réussies,un échec de cohérence conservé :champ moves inclut Buy/UseItem,un prédicat compte désormais Move,48autres inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1424 Warwick passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_WARWICK_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_warwick_passive_vfx_20261106 :27/27 documentaires,51/51 de cohérence qualifiés du même agent. V539 sans metadata/phases,découverte conservée ;neuf sources/troisLua/deuxpreloads avec quatreappels littéraux/deuxDDS différents. Char→Icon→globallifesteal_buf.troy déclaré,noncréation qualifiée.12paires acteurs/10horsfrappe relues ;lifesteal objet distinct,f1/cumuls/rendu ouverts. Prochain Xerath selon couverture VFX,rapport MonkeyKing déjà présent.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2411 entrées sales conservées. Six productions réussies,un échec de cohérence conservé :attente MonkeyKing corrigée vers Xerath,50autres contrôles et témoins inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1425 Xerath passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_XERATH_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_xerath_passive_vfx_20261106 :28/28 documentaires qualifiés,56/56 de cohérence du même agent.12primaires/28Lua/troispreloads avec14appels littéraux/deuxDDS distincts. Ascended→OnHit→xerath_base_p_manarestore.troy déclaré,noncréation qualifiée. Siximpacts/framesmana et bornespotion relus ;1111calculs hérités,aucune saturation. Disponibilité/f1/f2/f3/rendu ouverts. Prochain XinZhao,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2412 entrées sales conservées. Six productions réussies,deux échecs conservés :fenêtre source élargie et54refus principaux+6témoins,un prédicat corrigé,27autres inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1426 XinZhao passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_XINZHAO_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_xinzhao_passive_vfx_20261106 :32/32 documentaires,56/56 de cohérence du même agent.14primaires/17Lua/troispreloads avec5appels littéraux/deuxDDS même contenu. Puncture→Intimidate→xen_ziou_intimidate.troy déclaré,noncréation qualifiée.12impacts/frames et20endpoints relus ;366calculs hérités,aucune activation/expiry qualifiée. Premierimpact/cible/armure/rendu ouverts ;W distinct. Prochain Yasuo,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2413 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1428 Yorick passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_YORICK_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_yorick_passive_vfx_20261106 :31/31 documentaires qualifiés,59/59 de cohérence du même agent.30primaires/41Lua/quatrepreloads20appels/deuxDDS même contenu ;goules/Spells homonymes distincts,14AutoBuffvues/28champs nonrecette universelle. Sixrésumés impacts/sixpairesAPI/quatreTibbers relevés relus,zéroinvocation nonpreuve5%/35%,renduouvert. YasuoV1427 primaire réutilisé35gardes,nouvelleclôture0,secondaireouvert. Prochain Zac,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2414 entrées sales conservées. Six productions réussies,un échec conservé :sélecteur corrigé vers Mana_HUD_existing,30autres contrôles/témoins inchangés. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1429 Zac passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ZAC_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_zac_passive_vfx_20261106 :36/36 documentaires qualifiés,62/62 de cohérence du même agent.39primaires/29Lua/14preloads66appels/troisDDS ;TestCube fragment distinct du bloblet renaissance. Déclarations ready/explosion/soin/timeout/skin noncréation.120regenrows/huitpairesfatales/64samples relus,calculs hérités ;f1/readiness/recombinaison/rendu ouverts. Prochain Zed,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2415 entrées sales conservées. Cinq productions réussies,un échec de comptage conservé :65→66déclarations,ZacEMove huit,35autres contrôles inchangés. Bootstrap hors journal ;HUD récupération antérieure148/148 préservée. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1430 Zed passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ZED_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_zed_passive_vfx_20261106 :31/31 documentaires,57/57 de cohérence du même agent.16primaires/49Lua/deuxpreloads17appels/troisDDS distincts ;Stage1 déclaré,clone/Slow/W/alternatives distincts.18impacts/sixpairesAPI/huitpréparations/18fenêtres relus,arithmétique héritée. Seuil/f1/proc/CD par cible/rendu ouverts ;absence de proc nonexpiry. Prochain Ziggs,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2416 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1431 Ziggs passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ZIGGS_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ziggs_passive_vfx_20261106 :30/30 documentaires qualifiés,60/60 de cohérence du même agent.14primaires/29Lua17limites/troispreloads5appels/deuxDDS même contenu. ZiggsPassive/Bomb/Bomb_b/skins constantes noninterprétées,Attackpreloadtar noncréation.12résumés sanspairesPV/12fenêtres/deuxpairesAnnieQ relus,calculs hérités ;f1/f2/prêt/CD/réduction/structures/rendu ouverts. Prochain Zilean,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2417 entrées sales conservées. Six productions réussies,un échec conservé :collecteurs initial/correct inversés,qualifiés par SHA/diff,29autres contrôles inchangés. Erreurs root préservées séparément. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1432 Zilean passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ZILEAN_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_zilean_passive_vfx_20261106 :29/29 documentaires,57/57 de cohérence du même agent.6primaires/11Lua/unpreload2appels/deuxDDS même contenu ;alias espaces conservés,métadonnées nonproducteur/recette.24pairesXP/48autrescomparaisons/16pairesfatales/48pairesrécompenses relues,arithmétique héritée. Gains génériques égaux Zilean/Annie,8%/rayon natif/rendu ouverts ;1250nonportéepassive. Prochain Zyra,chercher ses audits.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2418 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1433 Zyra passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ZYRA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_zyra_passive_vfx_20261106 :35/35 documentaires,62/62 de cohérence du même agent.39primaires/56Lua21limites/10preloads43appels/deuxDDS même contenu ;homonymes complets,6AutoBuff18champs12vides nonrecette.8pairesfatales/88états-PVennemis/4pairesAPI40True relus,calculs hérités ;forme/tir/f1/lifecycle/rendu ouverts.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2419 entrées sales conservées. Six productions réussies,sans échec actuel. Audit borné clos ;tâches,fonctionnalités,inconnues,acceptation et goal ouverts. Aucun build/jeu/installation ni modification du goal,Plan/UI/bases/registres/produit. Suite :rapprochement documentaire des122IDs VFX et audits publiés,clauses secondaires ouvertes conservées ;next_lot.json explicite,pas de goal terminé ni redéfini.


## Reprise SYS-01.2-02 — V1434 Passifs VFX, rapprochement des publications

Rapprochement documentaire terminé : docs/AUDIT_SYS01202_PASSIF_VFX_PUBLISHED_COVERAGE_RECONCILIATION_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_published_reconciliation_20261106 :14/14 documentaires,357/357 cohérence du même agent.122IDs :115unités bornées réutilisées,7sans appariement dans les fenêtres,0dossier sélectionné à clarifier. Une référence Maokai exclue du doublecompte ;10anciens formats reliés par scope/lot épinglés,1370autres critères inchangés.307identités courantes concordantes,streaming seulement. AncienV1346 30→115=85dossiers supplémentaires repérés,pas85clôtures nouvelles ici.

Manques bornés :Ahri,Alistar,Amumu,Anivia,Brand,Cassiopeia,Chogath. Recherche exacte14motifs sans candidat supplémentaire,non absence universelle. Prochain Ahri,inspecter les preuves existantes hors fenêtre puis lien source/consommateur ;next_lot.json garde IDs/sources exacts. Clauses secondaires/applicabilité/ressources/états/rendu restent ouvertes,pas de jeu/champions terminés. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2420entrées sales conservées. Sept productions réussies ;goal,Plan/UI/bases/registres/produit inchangés,aucun build/natif/installation.

Empaquetage root initial exit1 : un dispatch rg traité à tort comme lecture ;2509 lectures et un dispatch distingués,original/qualification conservés,sans changement des sept opérations ni de leurs journaux.


## Reprise SYS-01.2-02 — V1435 Ahri passif VFX, sources et consommateurs

Audit de liaison documentaire terminé : docs/AUDIT_SYS01202_AHRI_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ahri_passive_vfx_20261106 : 35/35 documentaires,102/102 de cohérence du même agent. Huit Lua/38 globals,14 AutoBuff dont5vides ;variantes234 mêmes potions/Egitai,non rangs. Counter déclare SoulEater2,condition inconnue. Quatre preloads441octets identifiés sans contenu dans les reçus sélectionnés.19fichiers18Rust18ancres ;35comparaisons/32identités concordantes. SOURCE/HUD réutilisés,sans nouvelle clôture.

V556 deuxcas/60ticks/24refus hérités,aucune observation brute ni EXE rouvert. Cinq productions réussies ;erreurs root de découverte/dispatch conservées. Audit borné clos ;fonctionnalités,inconnues,acceptation et goal ouverts,COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. Prochain Alistar,next_lot_resolved.json exact ;chercher ses preuves avant nouveau travail. Git main8c19026...,13556entrées avec untracked-files=all,non comparables aux anciens comptes groupés. Rapport et notes seuls,aucun goal/Plan/UI/base/registre/code/asset/build/natif/install modifié.

Empaquetage root initial09c739 exit1 qualifié : cinq recherches optionnelles de common.pyc absent,suivies chacune de common.py retenu ;108lectures/1dispatch distincts,cinq opérations0 inchangées. Initialpacket/rapport et root_packet_schema_qualification conservés,sans création de bytecode ni changement des journaux.


## Reprise SYS-01.2-02 — V1436 Alistar passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ALISTAR_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_alistar_passive_vfx_20261106 :31/31 documentaires,94/94 cohérence du même agent. Deux Lua/sept globals sans AutoBuff ne prouvent pas absence d’effet. Colossal Strength/Trample Buff distincts,preload326 identité seule,deuxDDS homonymes distincts.16Rust/18ancres,43comparaisons39fichiers concordants. SOURCE/HUD réutilisés sans nouvelle clôture.

V552 Alistar91ticks après refus/24refus deuxcas/AnnieW813 hérités,sans rawpairs/recalcul/runtime. Pas de déclenchement,phasing,recette ou rendu qualifié. Cinq productions réussies,un capture01 échoué conservé :finalpeer absent des pins,omission qualifiée en capture02 sans inventer de pin/acceptation. Goal/Plan/UI/bases/registres/produit inchangés ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. Prochain Amumu exact dans next_lot.json. Git main8c19026...,2422entrées groupées,compte Ahri13556 dégroupé non comparable.

Empaquetage root ca03fa exit1 conservé :capture01 et capture02 ont deux versions du script. Seul le SHA initial exact est relié à capture_evidence_initial.py et au blob du journal capture01 ;version actuelle et toutes autres gardes inchangées,aucun journal réécrit. root_packet_version_qualification.json explicite.


## Reprise SYS-01.2-02 — V1437 Amumu passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_AMUMU_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_amumu_passive_vfx_20261106 :31/31 documentaires,94/94 cohérence qualifiée du même agent. Trois Lua/sept globals sans AutoBuff ;Marker/CursedTouch/CharScript AuraofDespair distincts. Preload274 identité seule ;deuxDDS même contenu,non priorité.16Rust16ancres,43comparaisons40fichiers concordants. SOURCE/HUD réutilisés sans nouvelle clôture.

V550 trois cas/neuf attaques/MR30ou55 sans réduction/91ticks suivants hérités ;100magique API nonpassif,15refuspublics12API. Aucun rawsnapshot/recalcul/runtime. Cohérence01exit1compteur39au lieu40,qualification un prédicat,93autres/témoins inchangés. Deux erreurs root d’adaptation avant sorties conservées,cinq productions réussies. Inconnues/recette/audiences/rendu ouverts ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. Prochain Anivia exact dans next_lot.json. Main8c19026...,2423entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1438 Anivia passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_ANIVIA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_anivia_passive_vfx_20261106 :31/31 documentaires,111/111 cohérence du même agent. SeptLua/sixlittéraux/36globals,RebirthNEWTABLEpc16 noncorruption ;Readypriorité8 noncallback,Play/Reset/Cooldown394 mêmesCharging nonanimationjouée. Quatrepreloads1218identités seules,sixDDSdeuxcontenus Base0/Charging1 mip.19Rust20ancres,46comparaisons41fichiers concordants. SOURCEV1183/HUDV1198 réutilisés,sans nouvelle clôture.

V558 Anivia1321/1501/1801,Ahri1356/1536/1836,960ticks/32refus hérités ;480ticksfontaine nonœuf6s/recharge4min. Aucun rawsnapshot/recalcul/runtime. Cinq productions0 sans échec,cacheoptionnelpyc distinct,sauvegardes/preuves conservées. Recette/formes/timers/audiences/rendu et inconnues restent ouverts,COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. NextBrand exactdansnext_lot.json. Main8c19026...,2424entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1439 Brand passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_BRAND_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_brand_passive_vfx_20261106 :34/34documentaires,134/134cohérence du même agent.19Lua10littéraux16globals9NEWTABLE ;sixdirects sansAutoBuff,ScorchGround98liéempty nonrecette. Ablaze247présent/Passive179/Run90/CharSoundZombie56 distinctions gardées. Deuxpreloads837identités/rôles,sixdépendances historiques nonactivation ;deuxDDSmêmecontenu.17Rust22ancres,44comparaisons40files concordants. SOURCEV1187/HUDV1201 réutilisés sans nouvelle clôture.

V659 quatre cas/4attacks8API40magic2AnnieQ6XP70public20APIrefus9239ticks hérités ;10horizons151 nontriggerBrand. Aucun rawsnapshot/recalcul/runtime. Cinqproductions0 ;rootguardfontschema exit1 conservé,F_mirror_pin remplace uniquement F_text_identity,critères et autres corps exacts. Inconnues/recettes/variantes/audiences/rendu ouverts ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. NextCassiopeia exactdansnext_lot.json. Main8c19026...,2425entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1440 Cassiopeia passif VFX, sources et consommateurs

Audit de liaison terminé : docs/AUDIT_SYS01202_CASSIOPEIA_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_cassiopeia_passive_vfx_20261106 :33/33documentaires,139/139cohérence du même agent.18Lua124globals/11directs,septcontextespassifs sansAutoBuff ;cinqQWRcontextes9champsauto nonrecette des paliers. Ticker1to4texturesdéclarées,Manager/Lockout/Haste378 mêmecontenu nonalias. Sixpreloads1870identités,sixDDS109992RGB32cinqcontenus.19Rust25ancres,46comparaisons42files concordants. SOURCEV661/HUDV1204 réutilisés sans nouvelle clôture.

V6614cas4achatsCodex4attacks8magicAPI4healAPI2AnnieQ6XP70public40APIrefus9274ticks hérités nonpoison/stacks/TwinFang. Aucun rawsnapshot/recalcul/runtime. Sixproductions0 ;qualificationd’unlibellé :TwinFangf2dégâts,Ticker2f5f6soin,originaux/33prédicats139checks/témoins inchangés. DispatchpréliminaireJSparseavantI/Oconservé. Recettes/paramètres/audiences/rendu/inconnues ouverts,COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. NextChogath exactdansnext_lot.json. Main8c19026...,2426entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1441 Chogath passif VFX, sources et consommateurs

Audit de liaison borné terminé : docs/AUDIT_SYS01202_CHOGATH_PASSIF_VFX_SOURCE_CURRENT_LINK_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_chogath_passive_vfx_20261106 :34/34 contrôles qualifiés,101/101 cohérences du même agent. V551 et HUD réutilisés, sans nouvelle clôture SOURCE/HUD ;18Rust/17ancres,45comparaisons/40fichiers concordants. Deux Lua/fourglobals,noAutoBuff ne prouve pas noVFX ;preloads182/788=970,2DDS8448DXT5 mêmecontenu,recettes/pixels non qualifiés.

V551 :Cho tick1569 supplément0,Trundle1532 supplément12.325592 distinct ;mana plein non observable,world statique,14refus et60postticks hérités sans replay. Six productions,cinq0/un evidence01 échoué33/34 conservé. Un seul prédicat cfg(test) damage11 qualifié par méthodes exactes/appels135et401 ;33autres inchangés. Erreur root affichage cp1252 conservée,relectureUTF8 réussie. f1/f2/niveaux/attribution/mana/recettes/audiences/rendu restent ouverts ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte.

Prochain lot :rapprochement incrémental V1434/122IDs et sept livraisons V1435–V1441 ;dernièreligne Chogath nonpreuve de famille complète. Main8c19026...,2427entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1442 rapprochement incrémental des122audits PASSIF-VFX

Rapprochement documentaire terminé : docs/AUDIT_SYS01202_PASSIF_VFX_INCREMENTAL_RECONCILIATION_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_incremental_reconciliation_20261106 :18/18 contrôles,43/43 cohérences du même agent.122IDs/122unités bornées rapprochés ;115lignes V1434 exactes,sept livraisons V1435–V1441 ajoutées,zéro nouvelle clôture individuelle par agrégation. Maokai réutilisation et trois familles antérieures restent exclus.

325identités courantes/254986272octets concordants,sans dérive ni conflit ;307ancienschemins+18nouveaux.77critères des sept livraisons satisfaits,preuves actives sélectionnées par AST des paquets. Cinq producteurs0 ;trois échecs historiques Alistar/Amumu/Chogath conservés. Pas de replay native/runtime/1158deps ;115anciens audits hérités sans relecture individuelle globale.

Classes V1322 conservées103partielles/13sansvuemappée/6contextesadditionnels,nonactualisées ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte. NextAnnie :comparer sa projection ancienne aux preuves VFX déjà publiées,adaptation de schéma ou manque exact,aucune nouvelle clôture individuelle. Implémentation/recettes/réseau/rendu/inconnues/acceptation ouverts. Main8c19026...,2428entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1443 Annie, fraîcheur de projection PASSIF-VFX

Rapprochement documentaire terminé : docs/AUDIT_SYS01202_ANNIE_PASSIF_VFX_PROJECTION_FRESHNESS_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_annie_passive_vfx_projection_20261106 :18/18 contrôles,28/28 cohérences du même agent. Trois vues/neufglobals déjà présentes dans audit Annie52/49 réutilisées,sans nouvelle clôture individuelle. V1322 ne gérait ni native_lua ni associations/field/native_metadata ;producteur individuel les gère déjà.

Overlay documentaire :Annie seule devient recognized_partial_views,121autres lignes exactes. Ancien snapshot103/13/6 conservé ;overlay104/12/6,ni couverture exhaustive ni jeu terminé. Pyromania146/marker214/particle201,StunReady déclaré nonruntime. Dixidentités courantes concordantes,huitconsommateurs/deuxreçus. Quatreproductions0/unprojection01KeyErrorbytes conservé ;une expression de schéma corrigée,legacycheminSHA sans taille/V668identitécomplète toujoursrequis. Aucun replay natif/runtime.

Prochain lot :douzeclasses restantes sansmapping rapprochées ensemble des preuves publiées,une ligne par ID,schémas partagés réutilisés. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte ;recettes/réseau/rendu/acceptation inchangés. Main8c19026...,2429entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1444 douze projections PASSIF-VFX restantes

Rapprochement documentaire terminé : docs/AUDIT_SYS01202_PASSIF_VFX_REMAINING_PROJECTIONS_FRESHNESS_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_remaining_passive_vfx_projections_20261106 :44/44 contrôles,107/107 cohérences du même agent. Douze IDs rapprochés,26vues/62globals ;aucune nouvelle clôture individuelle. Origines explicites :reçu sélectionné versus projection publiée avec identité concordante ;ne pas confondre les deux.

Overlay115partielles/1GarencontexteSansAffectations/6contextesadditionnels ;110autres classes exactes,Annie conservée. Garen quatrecontextes globals inconnus,Blitzactive NEWTABLE8 gardé/globalsnull.44identités courantes5005910octets concordantes. Sept producteurs,quatre0/troisarrêts conservés :Yasuo champsunknownIDs absents/Asheancienreçuidentitéseule/Blitzchunknonplat ;qualifications exactes et scripts initiaux gardés. Aucun nouveau natif/runtime.

Nextsixcontextes additionnels Jax/Malphite/Nasus/Rammus/Shen/Singed,un résultat parID enlot,sans rejouer les extractions inchangées. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 et affectations Garen restent ouverts. Main8c19026...,2430entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1445 six contextes additionnels PASSIF-VFX

Rapprochement documentaire terminé : docs/AUDIT_SYS01202_PASSIF_VFX_ADDITIONAL_CONTEXTS_FRESHNESS_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_additional_passive_vfx_contexts_20261106 :22/22 contrôles,79/79 cohérences qualifiées du même agent. Jax/Nasus contextesidentités sanspayloadLua ;Malphite/Rammus/Shen/Singed sixdéclarations22champs recoupés avec vues récentes,deuxlimitesNEWTABLE8/10 conservéesglobalsnull.

Overlay115partielles/1Garencontexte/6ancienscontextesexaminés ;116autres classes exactes,aucune exhaustivité/rendu qualifié.38identités courantes21789718octets concordantes. Sixproductions,quatre0/deuxarrêts conservés :Nasus ancienrequirement_id omis rejoint parqualification V1434/deuxcontrats ;coherence75/79 quatre prédicatslist->bool qualifiés,75autres/témoins exacts,raw conservé. Aucun natif/runtime nouveau.

Nextrevue clôture documentaire bornée famillePASSIF-VFX puis prochaine famille choisie sur référentiel figé/preuves,aucune nouvelle clôture individuelle par agrégation. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte,inconnues/recettes/réseau/rendu/acceptation inchangés. Main8c19026...,2431entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1446 revue de clôture des liaisons PASSIF-VFX

Revue documentaire bornée terminée : docs/AUDIT_SYS01202_PASSIF_VFX_FAMILY_CLOSURE_REVIEW_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_family_closure_20261106 :15/15 contrôles,15/15 cohérences du même agent.122liaisons/122unités existantes uniques,septclauses parligne,aucune nouvelle clôture individuelle. Les tâches VFX complètes et leurs parents restent PARTIAL_UNPROVEN au-delà des périmètres bornés ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte.

325identités courantes254986272octets concordantes ;supplémentsV1443/44/45 actifs18/28,44/107,22/79hérités,nonrejoués. Sixproductions,cinq0/unbootstrap01échec rôleMESH absent corrigé ;PRESENTATIONparent exclu des clôtures. Rootcheminblobprésumé manquant conservé,retained_pin réel indique snapshotE déjàretenu. Aucune source manquante ni nouveau natif/runtime.

Suite réelle :PASSIF-SIMULATION-CONTRAT122paires depuis snapshot1220lignes216b7546,aucun grandregistrechargé. Fenêtre106rapports candidats,93pairesavechits/29sans,nonpreuves de clôture/absence. NextAatroxSIMULATION-CONTRAT OLF-ef8bf5f4-465e-5222-803e-a00c33d0f5de :preuves existantes d’abord,effets/branches/source/current/manques précis. Réseau1191/animation1190/audio1192 déjàacquis àréutiliser. Main8c19026...,2432entrées groupées ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1447 Aatrox, branches Blood Well et écarts de simulation

Audit borné des branches textuelles et écarts statiques terminé : docs/AUDIT_SYS01202_AATROX_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_aatrox_passive_simulation_contract_20261106 : 42/42 contrôles documentaires, 25/25 cohérences du même agent, dix branches/quatorze fenêtres/seize identités courantes concordantes. V456 déjà lié au contrat réutilisé ; aucune nouvelle clôture SOURCE/VFX/HUD.

Textes en_GB : dépôt100%, décroissance2%/s hors combat, soins contenu+35%pool sur3s, stase3s, recharge225s ; déclarations textuelles uniquement. Pool/f2/conditions/ordre/transitions inconnus. Mort et fontaine ordinaires, sorts/progression Aatrox refusés statiquement ; aucun runtime/build nouveau. Audit borné clos, tâche complète et fonctionnalité ouvertes.

Projection122contrats/SOURCE 19627707octets SHA c37ef63de769b7f142e0b028a72d8f4d3497639172981c7e17c3788f0c87d06c réutilisable, zéro grand registre rechargé ; pas de vitesse mesurée. Next Ahri exact dans next_lot.json : preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1448 Ahri, branches Essence Theft et écarts de simulation

Audit borné des déclarations connues et écarts statiques terminé : docs/AUDIT_SYS01202_AHRI_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ahri_passive_simulation_contract_20261106 : 41/41 contrôles,30/30 cohérences du même agent,onze branches,dix-huit fenêtres dont onze communes réutilisées,dix-neuf ancres/dix-sept identités courantes. Onze fichiers sélectionnés concordent avec V556 ;aucune relecture des1158dépendances.

Textes :charge par impact,cap3par sort,seuil9charges,prochain sort soignant par touche ;Counter dit9sorts,non normalisé. f1/f2,éligibilité/instance/consommation/soin/lifecycle inconnus. V556 deuxcas60ticks24refus réutilisés,aucun sort Ahri accepté ;AnnieW/Pyromania distincts. Pas de nouveau runtime/build/natif. Audit borné clos,tâche complète et fonctionnalité ouvertes.

Projection familiale existante réutilisée,aucun grand registre chargé. Next Alistar exact dans next_lot.json,preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1449 Alistar, branches Trample et écarts de simulation

Audit borné des déclarations connues et écarts statiques terminé : docs/AUDIT_SYS01202_ALISTAR_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_alistar_passive_simulation_contract_20261106 :43/43 contrôles,30/30 cohérences du même agent,onze branches,dix-huit fenêtres dont treize communes réutilisées,dix-neuf ancres/dix-huit identités courantes. Neuf fichiers sélectionnés concordent avec V552 ;aucun recensement1158dépendances.

Texte :après sort,traversée des unités,dégâts magiques proches par seconde3s,double aux sbires. f1/f2/f3,rayon/cadence/cibles,refresh et phasing conditionnel inconnus. Rayons50/145/80 chemin/sélection/corps ne sont pas la portée Trample ;occupation des alliés nonpromue en passif. V552 deuxcas91ticks chacun24refus réutilisés,aucun cast Alistar accepté ;AnnieW distinct. Audit borné clos,tâche complète et fonctionnalité ouvertes.

Projection familiale existante réutilisée,aucun grand registre chargé. Next Amumu exact dans next_lot.json,preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1450 Amumu, branches Cursed Touch et écarts de simulation

Audit borné des déclarations connues et écarts statiques terminé : docs/AUDIT_SYS01202_AMUMU_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_amumu_passive_simulation_contract_20261106 :44/44 contrôles,30/30 cohérences du même agent,dix branches,dix-huit fenêtres dont douze communes réutilisées,dix-sept ancres/dix-neuf identités courantes. Dix fichiers sélectionnés concordent avec V550 ;aucun recensement1158dépendances.

Texte :attaque de base,réductionMR f1,3secondes. f1/niveaux,ordre/réduction/penetration,cibles,cumul/refresh/lifecycle inconnus. Trundle/objets/pénétration récepteurs distincts,pas producteurs CursedTouch. V550 trois cas9hits MR30/55inchangée,91ticksaprès chacun ;100magiques explicites diagnostic nonnatifs ;15refus publics/12événementsserveur séparés. Audit borné clos,tâche complète et fonctionnalité ouvertes.

Projection familiale existante réutilisée. Next Akali exact dans next_lot.json,preuves existantes d’abord ;sélection alphabétique sur122paires hors unités précédentes/courante,pas un taux de clôture. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1451 Akali, branches Twin Disciplines et écarts de simulation

Audit borné des déclarations connues et écarts statiques terminé : docs/AUDIT_SYS01202_AKALI_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_akali_passive_simulation_contract_20261106 :40/40 contrôles,33/33 cohérences du même agent,onze branches,21fenêtres dont19communes réutilisées,18ancres/17identités courantes. Dix fichiers sélectionnés concordent avec V557 ;aucun recensement1158dépendances.

Force/Might séparés :textes6%+1%par6AP et6%SpellVamp+1%par6BonusAD ;bases/arithmétique/fournisseurs inconnus. f1main=magic/f2main=vamp,tandis que f1TwinDmg=vamp :paramètres propres au binding. Formule communautaire6+bonusAd%6 nonnative. V5574cas12attaques120ticks32refus réutilisés ;AP20 sans supplément qualifié,1053soin4.2890625 itemlifesteal,pasMight. Audit borné clos,tâche complète et fonctionnalité ouvertes.

Projection familiale existante réutilisée. Next Anivia exact dans next_lot.json,sélectionalphabétique122paires hors unités précédentes/courante,pas clôtureglobale. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1452 Anivia, branches Rebirth et écarts de simulation

Audit borné des déclarations connues et écarts statiques terminé : docs/AUDIT_SYS01202_ANIVIA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_anivia_passive_simulation_contract_20261106 :58/58 contrôles,34/34 cohérences du même agent,dix branches,20fenêtres toutes réutilisées dont17SOURCE/V1183,21ancres/23identités courantes.14Rust sélectionnés concordent avec V558 etV1183 ;niSOURCE ni1149Rust/1158dépendances rejoués.

Texte :létal→œuf pleinPV/f1défenses→survie6s→renaissance,recharge4min ;f1/états/ordre/transitions inconnus. V558 deuxcas960ticks32refus réutilisés,morts encoreà6s puisfontaine16s,nonRebirth.7Lua/6vues36globals,RebirthNEWTABLEpc16 globalsinconnus,pasvideprouvé/corruption ;priorité8 noncallback. Audit borné clos,tâche complète et fonctionnalité ouvertes.

Provenance086dmiroir/7ed25bnatif déjàrésolue SOURCE réutilisée sansrecherche. Projection122paires conservée,nextAnnie exact etpreuves d’implémentation partielle à examiner. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1453 Annie, Pyromania partielle et contrat des branches

Audit borné terminé : docs/AUDIT_SYS01202_ANNIE_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_annie_passive_simulation_contract_20261106 : 43/43 contrôles documentaires, 36/36 cohérences du même agent ; treize branches, dix-neuf fenêtres dont neuf communes réutilisées, dix ancres dont neuf spécifiques, vingt-et-une identités courantes. Douze Rust et cinq règles JSON sélectionnés concordent avec V534.

Pyromania possède une implémentation partielle : Q impact, E acceptation, W libération même sans cible, R après spawn réussi ; réception stun/refus et lifecycle séparés. Durées locales 1,25/1,5/1,75 s non promues natives ; f1, événements historiques et politiques de refus/état restent inconnus. Six tests Annie parmi 37 filtrés/27 spécifiques V534 réutilisés, aucun rerun ni couverture exhaustive.

Audit borné clos ; tâche complète, fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection 122 paires conservée ; next Ashe exact, preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1454 Ashe, branches Focus et chaîne critique actuelle

Audit borné terminé : docs/AUDIT_SYS01202_ASHE_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ashe_passive_simulation_contract_20261106 : 37/37 contrôles documentaires, 36/36 cohérences du même agent ; douze branches, dix-huit fenêtres dont quinze réutilisées (treize SOURCE, deux communes), neuf ancres et dix-huit identités courantes. Quatorze entrées sélectionnées concordent avec V537 et SOURCE V1184, non reclos.

Focus : texte trois secondes sans attaque puis f1 charges/seconde, seuil100 et prochaine attaque critique ; f1/unités/événements inconnus. Critique générique, cache, annulation et projectile distingués. Move/Stop retirent le windup mais gardent attack_roll ; mort/libération l’effacent. Quatre échantillons Ashe V537 0/90/900/5400ticks à chance0 ne prouvent pas absence/100/reset ; Tryndamere exclu.

Audit borné clos ; tâche complète, fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection122paires conservée,next Azir exact, preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1455 Azir, conversion CDR et contrat SunDisc

Audit borné terminé : docs/AUDIT_SYS01202_AZIR_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_azir_passive_simulation_contract_20261106 :43/43 contrôles documentaires,44/44 cohérences du même agent ;16branches,25fenêtres réutilisées (20SOURCE+5communes),25ancres/25identités courantes.21entrées sélectionnées concordent avec V559 et SOURCE V1185,non reclos.

Deux branches :1,25%AS par1%CDR,f1 bonus affiché ;SunDisc depuis ruines,texte3min/1min/exclusions. Formule cadence sans conversion et trajet ruine→SunDisc non qualifié dans les corps/configuration inspectés. V5593cas58/58/50ticks,18impacts51refus hérités ;pas de clic de ruine/SunDisc.11Lua :3vues vides qualifiées,8NEWTABLE inconnues et raw{} conservés,noncorruption ;TowerClicker1/4/7 nonadoptés.

Audit borné clos ;tâche complète,fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection122paires conservée,next Blitzcrank exact,preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1456 Blitzcrank, contrat Mana Barrier et témoin générique

Audit borné terminé : docs/AUDIT_SYS01202_BLITZCRANK_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_blitzcrank_passive_simulation_contract_20261106 :39/39 contrôles documentaires,40/40 cohérences du même agent ;14branches,21fenêtres SOURCE réutilisées,11ancres/21identités courantes.17entrées sélectionnées concordent avec V544 et SOURCE V1186,non reclos.

Texte20%PV/50%mana courant/10s/90s ;seuil/ordre/capture/initialisation/réactivation inconnus. Deux cas V544 passent24,79→16,81%PV sansbarrière ;mana plein donc courant/max nondiscriminés. Témoin serveur100PV/300ticks absorbe46,5348129 puis expire,nonManaBarrier ;11refus anciens nonrejoués. Icon/CD9littéraux,priorité8 noncallback ;activeNEWTABLEpc8 globalsinconnus,noncorruption ;legacyAlistar/400/600/6-12-18 nonadoptés.

Audit borné clos ;tâche complète,fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection122paires conservée,next Brand exact,preuves existantes d’abord. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1457 Brand, Blaze et interactions QWER

Audit borné terminé : docs/AUDIT_SYS01202_BRAND_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_brand_passive_simulation_contract_20261106 :48/48 contrôles documentaires,51/51 cohérences du même agent ;18branches,30fenêtres SOURCE réutilisées,23ancres/30identités courantes.26entrées sélectionnées concordent avec V659 et SOURCE V1187,non reclos.

Blaze passif/BrandAblaze état/BrandBlaze Q séparés ;8%PVmax magiques4s,80/smonstres texte ;timing/refresh/capordre inconnus. Q2s,W+25%,Epropagationrayoninconnu,Rchampionsrebondsuivant distincts.8chaînes présentes+1SpellDatakeyabsente,nulaliasréécrit.19Lua/10vues16globals/9NEWTABLEinconnues ;6rôlespassifs9globals séparés. CompagnonsAblaze présents,premieréchec V659 conservé.

V6594cas4attaques8APIMagical2AnnieQ6XP,9239ticks,70public20APIrefus,aucun déclencheurBrandadmissible. Audit borné clos ;tâche complète,fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection122paires conservée,next Braum exact. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1458 Braum, marques et contrat Concussive Blows

Audit borné terminé : docs/AUDIT_SYS01202_BRAUM_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_braum_passive_simulation_contract_20261106 : 50/50 contrôles documentaires, 61/61 cohérences du même agent ; seize branches, 33 fenêtres SOURCE réutilisées, 23 ancres et 32 identités courantes. Vingt-huit entrées sélectionnées concordent avec V660 et SOURCE V1188, non reclos.

Texte : première marque attaque Braum/Q, contribution alliée, quatre marques/quatre secondes, proc magic/stun, immunité aux marques et bonus Braum ; fournisseurs f1/f2/f3/f5 inconnus. Q f1 distinct. Dix Lua courants : neuf vues/27 globals, Override NEWTABLE pc0 inconnu ; six homonymes Q/E/W conservés par chemin complet. DDF/Deprecated/aliases étrangers non adoptés.

V660 quatre cas hérités : 52 impacts = 26 Braum + 26 Garen ; huit quartets = quatre + quatre, 110 ticks. Témoins API40/stun60/XP distincts du proc ; 92 refus publics/28 API, non rejoués. Un échec contract01 conservé : seul prédicat métadonnées complètes/projection d’identité corrigé dans contract02. Audit borné clos ; tâche complète, fonctionnalité et inconnues ouvertes. SOURCE/HUD/VFX non reclos. Projection 122 paires conservée ; next Caitlyn exact. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1459 Caitlyn, compteur et contrat Headshot

Audit borné terminé : docs/AUDIT_SYS01202_CAITLYN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_caitlyn_passive_simulation_contract_20261106 : 47/47 contrôles documentaires, 61/61 cohérences du même agent ; seize branches, 35 fenêtres dont 27 communes réutilisées, 23 ancres/26 identités courantes. Vingt-trois entrées sélectionnées concordent avec V560 ; aucun rejeu de 1 158 dépendances.

Headshot : f1 attaques versus description huit non résolue ; buisson compte double, textes 150% champion/250% sbire. Cinq Lua, trois vues/six globals, deux NEWTABLE pc4/pc0 inconnus ; persistance/dispel restent métadonnées. Six clés en_GB vérifiées, pas de fournisseur effectif qualifié.

V560 trois cas hérités : 36 lancements ordinaires, 24 impacts champion expliqués par armure/régénération, 51 refus ; cas sbires : quatre ordres, onze retraits, dernier projectile en vol, net non isolé. Onze corrections documentaires avec critères propres. SOURCE a_qualifier et inconnues conservées, aucun audit SOURCE/HUD/VFX reclos. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Cassiopeia exact dans projection 122 paires.

bootstrap01 relatif refusé avant lecture des consommateurs ; seule jonction lexicale F corrigée dans bootstrap02, garde inchangée. Deux chemins supposés absents ne prouvent pas une absence globale ; projectiles dans attacks.rs. Cinq opérations dont un échec conservé. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1460 Cassiopeia, poison et paliers Aspect

Audit borné terminé : docs/AUDIT_SYS01202_CASSIOPEIA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_cassiopeia_passive_simulation_contract_20261106 : 54/54 contrôles documentaires, 60/60 cohérences du même agent ; dix-huit branches, 31 fenêtres dont 28 communes réutilisées, 26 ancres/28 identités courantes. Vingt-cinq entrées sélectionnées concordent avec V661 ; aucun rejeu des 1 158 dépendances ou des recherches 639 Rust/799 communautaires.

Aspect alias DeadlyCadence : charges sur seconde de poison champion, kill d’unité empoisonnée et hit TwinFang champion ; cap/paliers/AP/soin/CDR paramétrés. Bindings séparés : f5 seuil ou soin, f7 seuil ou CDR ; f3 AP des paliers absent du principal. Deux DDF 4+8 lignes, lien E f1=.55 non adopté pour tooltip f2/paliers. 18 Lua/124 globals, onze sélectionnés/79 globals ; flags persistants non exécutés. Quatorze clés en_GB, deux absentes ; aliases NoxiousBlastHaste conservés. Hash Stats communautaire a08181 distinct INIBIN3ac382, noncorruption.

V661 quatre cas dont deux Cassiopeia/deux Annie : quatre achats Codex30AP/10%CDR, quatre soins API25/cap55, deux AnnieQ104/cooldown108 ; témoins distincts du passif. Poison/charges/paliers/TwinFang non qualifiés, 70 refus publics/40 API hérités. Treize corrections avec critères propres ; SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Chogath exact depuis projection 122 paires.

contract01 imposait à tort f3 dans le principal ; seul prédicat de présence corrigé dans contract02, sources et tableau de rôles inchangés, échec conservé. Cinq opérations, quatre succès. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1461 Chogath, élimination et restitutions Carnivore

Audit borné terminé : docs/AUDIT_SYS01202_CHOGATH_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_chogath_passive_simulation_contract_20261106 : 49/49 contrôles documentaires, 58/58 cohérences du même agent ; quatorze branches, 29 fenêtres dont 27 communes réutilisées, 18 ancres/25 identités courantes. Vingt-deux entrées sélectionnées concordent avec V551 ; quatre opérations journalisées réussies, aucun rejeu des 1 158 dépendances ou du diagnostic.

Carnivore : f1 PV/f2 mana après kill, croissance selon niveau sans fournisseurs/formule qualifiés. Deux Lua/quatre globals, sept identités natives ; flags/preloads non exécutés. Trois clés en_GB, lookup distinct du fournisseur. Source_sha557011 désigne Stats communautaire, non INIBIN0c6e8e. restores_resource est une classification booléenne, pas une restitution.

V551 deux parties héritées : une Cho’Gath et un témoin Trundle, chacun quatre coups entrants/quatorze sortants/un kill. Cho1569 : PV441.1772766 égaux régénération, supplément0 avec déficit>133 ; niveau1/lifesteal0, pas de gain de niveau. Trundle1532 : +12.3255920 via reconstruction communautaire2%, distincte de Carnivore. Mana plein non observable ; 14 refus publics dont quatre Cast Cho, morts world uniquement statiques. Supplément de fraîcheur du 2026-11-02 et ancien faux rejet des séparateurs conservés, non rejoués.

Dix corrections avec fins propres, déficit de mana à obtenir par dépense publique réellement supportée ou limite maintenue. SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Corki exact depuis projection 122 paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1462 Corki, supplément True et exclusion des structures

Audit borné terminé : docs/AUDIT_SYS01202_CORKI_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_corki_passive_simulation_contract_20261106 : 50/50 contrôles documentaires, 59/59 cohérences du même agent ; quinze branches, 31 fenêtres dont 27 communes réutilisées, 23 ancres/26 identités courantes. Vingt-trois entrées sélectionnées concordent avec V561 ; six opérations journalisées : cinq réussies et un échec de sélecteur rédactionnel conservé, aucun rejeu du diagnostic ou des 1 158 dépendances.

Hextech Shrapnel Shells alias RapidReload : supplément True10%AD total écrit, structures exclues, sbires/monstres/champions nommés. Déclencheur, échantillonnage/ordre, critique, boucliers, vol de vie, cibles et cycle de vie restent ouverts. Phrase Annie et niveaux1/4/7/«10»/13/16 non adoptés ; deux Lua/quatre globals/six identités natives, trois clés en_GB, métadonnées non exécutées.

V561 quatre cas : 18 impacts champion/deux tourelle physiques seuls ; AD51.24/61.24, armure27.536/42.536/67, supplément5.124/6.124 non observé. Tourelle sans bonus ne prouve pas l’exclusion quand les cas positifs n’ont pas de proc. Calcul pur True100 trois armures/trois refus, sans événement apply_damage. 68 refus publics dont huit hors boutique ; ancienne analyse échouée et correction seule conservées, garde actuelle avant objet/slot confirmée.

Onze corrections avec critères propres. SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Darius exact depuis projection 122 paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1463 Darius, Hemorrhage et vitesse par champion ensanglanté

Audit borné terminé : docs/AUDIT_SYS01202_DARIUS_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_darius_passive_simulation_contract_20261106 :49/49 contrôles documentaires,60/60 cohérences du même agent ;16branches,33fenêtres dont31communes réutilisées,23ancres/27identités courantes.24entrées concordent avec V562 :16Rust/2Python/6JSON ;cinq sélections JSON héritées plus movement_rules courant direct,non règle native Hemorrhage.

Texte magique5s/5charges,5%vitesse par champion ennemi ensanglanté ;f1/f2,calendrier,refresh,propriété,éligibilité et composition inconnus.14identités natives,6Lua/12globals,4clés en_GB retrouvées ;métadonnées non exécution,legacy régénération mana non adoptée. Garen15ticks et30Hz courants ne qualifient pas la cadence Darius.

V562 quatre cas hérités :16impacts Physical seuls,44ticks entre attaques,4×180ticks aprèsStop sans dégâts inexpliqués ;cinq attaques ne prouvent pas cinq charges. CapeRM32.1→57.1 et Bottesvitesse340→365 sont contrôles ordinaires,+25 non bonus5%.60refus publics hérités,aucun rejeu natif/build/jeu/REA.

Treize corrections avec fins propres. SOURCE a_qualifier,dépendances et inconnues conservées. Audit borné clos ;tâche complète et fonctionnalité ouvertes. Next Diana exact depuis projection122paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1464 Diana, troisième frappe et limites du déplacement bleu

Audit borné terminé : docs/AUDIT_SYS01202_DIANA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_diana_passive_simulation_contract_20261106 :57/57 contrôles documentaires,67/67 cohérences du même agent ;16branches,38fenêtres dont31communes réutilisées,25ancres/31identités courantes.28entrées concordent V563 :19Rust/2Python/7JSON ;cinq sélections héritées plus mouvement/collision courants directs,non règles natives Moonsilver.

Texte ASf3,troisième frappe magiquef1/f2 proche ;fournisseurs/compteur/reset/géométrie inconnus.13identités natives,4Lua/6globals,deux bindings identiques,4lookups/3clés uniques ;Passive/Recap Lua identiques sans preuve de dispatch/persistance,CharScript/CombatBuff vides qualifiés. Communautaire posture non vide/non passif natif ;niveaux1/4/7 non adoptés.

V5633cas18Physicalhits,AP0/20/0,cadence48/48/42,48refus hérités ;seconde cible141.421/144.141 sans dégâts,géométrie antérieure273.589 conservée. Trois échecs bleus build0/run101 et inspection obsolète préservés ;oppositeside success ne les répare pas. Segment→TerrainBlocked→path/destination effacés statiques ;premier tick/segment/grille/cercles/budget non mesurés,rayon35/25.7666 non cause démontrée.

Treize corrections avec fins propres,références MOUVEMENT citées V563 sans statut revérifié. SOURCE a_qualifier,dépendances et inconnues conservées. Audit borné clos ;tâche complète et fonctionnalité ouvertes. Next Draven exact depuis projection122paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1465 Draven, charges Adoration et récompenses distinctes

Audit borné terminé : docs/AUDIT_SYS01202_DRAVEN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_draven_passive_simulation_contract_20261106 : 55/55 contrôles documentaires, 68/68 cohérences du même agent ; 18 branches, 35 fenêtres dont 32 communes réutilisées, 25 ancres/31 identités courantes. 27 entrées concordent V565 : 18 Rust, 2 Python, 7 JSON sélectionnés hérités.

Texte : charges par catch/sbire/monstre/tour, kill champion donnant f4 plus f1 par charge consommée, mort retirant moitié, f2/f3 statistiques. Producteurs, arrondi, compteur/crédit et ordre inconnus. 13 identités natives, 5 Lua : 4 vues/9 globals, Spinning NEWTABLE pc10 inconnue/null avec raw{} retenu ; 5 clés en_GB/4 bindings, Q distinct. Métadonnées et Q communautaire simplifié ne qualifient pas Adoration.

V565 trois cas/six kills 400/300 sans supplément, 45 refus, trois sbires crédités sans compteur observé. Champ legacy hits = 123 baisses de santé, 71 avec projectile précédent/52 sans ; attribution exclusive non qualifiée, reçu publié vérifié. Revenu ambiant 8/75s/5s et autel distincts de f1/f4. Navigation V564/anciens échecs non réaudités ni corrigés.

Quinze corrections avec fins distinctes. SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next DrMundo exact depuis projection 122 paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1466 Dr Mundo, régénération proportionnelle et plafonds

Audit borné terminé : docs/AUDIT_SYS01202_DRMUNDO_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_drmundo_passive_simulation_contract_20261106 : 42/42 contrôles documentaires, 54/54 cohérences du même agent ; 13 branches, 25 fenêtres dont 23 communes réutilisées, 11 ancres/20 identités. 17 entrées concordent V542 : 12 Rust, 2 Python, 3 JSON ; deux sélections héritées plus définition actuelle.

Texte 0.3%maxHP/s, conversion .003 distincte du calendrier natif ; Nevershade et description retrouvés, 3clés/1binding hérité. Six identités natives, deux parses Lua selon rapport V542, détails par chunk absents du reçu ; buff4valeurs déclaratives. Legacy dégâts20/30/40%, facteur chaîne0 et icônes distinctes conservés sans adoption.

Deux fenêtres180ticks V542 n’observent que base1.552PV/s ; maxHP582.52→732.52 par Ruby+150, supplément textuel1.74756/2.19756 non observé. Sommes négatives locales par tick, pas seconde simulation cumulée. Garen guard exclut Mundo ; shop conserve/plafonne les PV courants. Anciennes erreurs achat/inspection conservées. contract01 échoue sur fenêtre28..42 ; contract02 corrige seulement27..41, source inchangée. Cinq opérations, quatre réussites/un échec conservé.

Dix corrections avec fins distinctes. SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Elise exact depuis projection122paires. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1467 Elise, réserve et araignées distinctes du témoin Tibbers

Audit borné terminé : docs/AUDIT_SYS01202_ELISE_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_elise_passive_simulation_contract_20261106 : 56/56 contrôles documentaires, 66/66 cohérences du même agent ; 20 branches, 36 fenêtres dont 32 communes réutilisées depuis Draven, 25 ancres/29 identités. 26 entrées concordent V566 : 16 Rust, 2 Python, 8 JSON hérités.

41 identités natives, 25 Lua/96 globals littéraux sans callbacks ; six preloads/quatorze communautaires. Trois formes typées portées«550»/125/175 et vitesses335/345/345, slots distincts, f3/cap/réserve/transition inconnus. Trois clés en_GB/deux bindings ; Spider1..5 non plafond5. Regen/Morgana/Swain/Akali/Twitch conservés sans adoption/corruption inférée.

Deux parcours publics V566 : 12 impacts physiques isolés, AP0/20, 34 refus, zéro familier ; aucun sort humain admissible ou forme araignée, donc autoattaques sans pet ne testent pas le déclencheur natif. Contrôles séparés : 2525XP serveur, niveau6 ; Elise12refus, Annie1Rrefus puis1annietibbers. Pas progression ordinaire ni araignée Elise. Factory pet=None, Annie crée annietibbers/Pet ; dispatch public Annie/slot3, pas garde Elise inventée dans cast_tibbers interne. IA/expiry/aura Annie distincts.

Quinze corrections avec fins distinctes. SOURCE a_qualifier, dépendances et inconnues conservées. Audit borné clos ; tâche complète et fonctionnalité ouvertes. Next Evelynn exact depuis projection122paires. SOURCE/HUD/VFX et navigation V564 non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1468 Evelynn, furtivité et mana distincts de la vision générale

Audit borné terminé : docs/AUDIT_SYS01202_EVELYNN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_evelynn_passive_simulation_contract_20261106 : 57/57 contrôles documentaires, 67/67 cohérences du même agent ; 20 branches, 37 fenêtres dont32communes réutilisées, 25 ancres/31 identités. 28 entrées concordent V567 :18Rust/2Python/8JSON hérités.

26 identités natives,10Lua/39globals littéraux sans callbacks,dix preloads/dix communautaires ;6clés/5bindings. Texte proche/vraievision,1%mana maximum/s en furtivité,sort/dégâts reçus/infligés interrompent6s ;seuil/état/timing/composition inconnus. LegacyShadowWalk slot2/CastTime.5 distinctEvelynnW ;Nondispellable/NonDispellable casse préservée. BaseMPRegen absent mais BaseStaticMPRegen1.62160003 présent.

V567 deuxparcours250/899.9995,360ticks chacun visible/projeté,24refus ;pas seuil natif déduit. Achat1027 après210ticks conserve265.6mana/max465.6,20incréments211..230base1.6216 entrefontaines ;pas étatfurtif établi,4.656textuel distinct. Visible_to/snapshot_for génériques,appel serveur static datagrams/send_to non transportexécuté. Navigation V564 et anciennes inspections conservées,non réauditées/corrigées.

Seize corrections avec fins distinctes. SOURCE a_qualifier,dépendances/inconnues conservées. Audit borné clos ;tâche complète/fonctionnalité ouvertes. Next Ezreal exact depuis projection122paires ;préserver producteur partiel existant. SOURCE/HUD/VFX non reclos. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1469 Ezreal, passif partiel et contrats locaux préservés

Audit borné terminé : docs/AUDIT_SYS01202_EZREAL_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_ezreal_passive_simulation_contract_20261106 :63documentaires/61cohérences du même agent ;19branches connues,16fenêtres,20ancres dont19composants partiels,15identités gardées.13Rust et attack_contracts concordent V534 ;producteur partiel et neuf contrats locaux conservés,aucune régression en simple frontière générique. Quatre opérations réussies.

V534 hérité37CPU dont8Ezreal avec1helperAD ;aucun rejeu des1158entrées ou1147dépendances. Contacts Q/W/E/R acceptés,W allié/soi réel lanceur seul,cap5/refresh180ticks,projection privée,count0aprèsinvalidité,cleanup/cadencefuture ;politiques locales distinctes du natif. Budgets64/32 et overflow statiques non entièrement testés.

Natif INIBIN2475octets/membership hérité ;raw Passive1Desc parleAshe,quatre clés en_GB dont legacy15%/75% distinct10%/6s/5charges ;@f1@ fournisseur inconnu. Aucun nouveau Lua/natif/EXE/REA/build/runtime. Ancienne-vie autorisée localement sans life-token ne qualifie pas règle historique ;transport/HUD ouverts.

Douze corrections avec fins distinctes ;SOURCE partiel_a_terminer et questions propriétaires conservées. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactCH-FiddleSticks-PASSIF-SIMULATION-CONTRAT depuis122paires,99candidats hors23unités nommées sans compte complet déduit. Setup initial Gitnull/TypeError conservé,lecture seule autorisée qualifiemain/head/2455entrées. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1470 FiddleSticks, Dread et réduction de résistance magique

Audit borné terminé : docs/AUDIT_SYS01202_FIDDLESTICKS_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_simulation_contract_20261106 :61documentaires/91cohérences du même agent ;18branches,36fenêtres dont32communes réutilisées,25ancres génériques non Dread,24identités gardées.23entrées concordent V568 :18Rust/2Python/3JSON. Quatre opérations productrices réussies.

Neuf natifs retenus parmi10candidats ;3Lua/6globals sans callback,4clés en_GB/2bindings,2preloads/8communautaires. Texte10pointsRMunitésennemiesproches ;rayon/éligibilité/timing/cumul/life inconnus. ParanoiaMissChance=ParanoiaAura non raté ;FearmongerDrain/Nocturne exclus ;PassLev1Desc1 absent non inventé,SpellBlock30présent/BaseSpellBlockabsent.

V568 hérité3publics à250pendant300ticks chacun,RM30/55/30,33refus ;achat1033+25témoin non aura. Trois événements serveur100Magical distincts des sorts ordinaires :76.92308/64.51613/76.92308,9refus diagnostiques. Stats/penetration/mitigation génériques,aucun producteurDread dans corps inspectés ;18Rust zérooccurrence sans absenceglobale. Ancien build0/run101 cheminJSONobjet conservé,correction séparée non rejouée ;navigationV564 non corrigée.

Treize corrections avec fins distinctes ;SOURCE a_qualifier,dépendance/inconnues propriétaires conservées. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactFiora depuis122paires,98candidats hors24unités nommées sans pourcentagecomplet. Aucun nouveau runtime/build/REA/natif ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1471 Fiora, Duelist et régénération distincte des contrôles API

Audit borné terminé :docs/AUDIT_SYS01202_FIORA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_fiora_passive_simulation_contract_20261106 :56documentaires/87cohérences du même agent ;20branches,33fenêtres dont32communes réutilisées,22ancres enregistrées dont21frontières non Duelist,23identités.22entrées concordent V662 :16Rust/2Python/4JSON,gardeGaren excluantFiora incluse.

21natifs hérités parmi64candidats,26communautaires selonrapport ;28Lua lus,22initialisations qualifiées/115globals,6NEWTABLE inconnus conservés ;6vues passif/38globals,Hotparticules identiques non troisstacks.4clés en_GB :physique vs description sans type,6s/4cumuls,f1inconnu ;DDFQ.6/Dance1.2 bonusAD non soin. Resource source_sha f185Statscommunautaire non INIBINa762.

V662 hérité4cas Fiora/Annie1/18,24attaques,24horizons181ticks sousplafond,supplémentsoin non observé ;135/90/156/126ticks pour4coups.20préparations healAPI+40%PVmaxTrue,6XPserveur,8trajets publics ;12dégâtsAPI/4heal25 distincts du passif,60refuspublics/40API,12768ticks. Aucun nouveau build/runtime/REA/natif ni1158dépendances rejouées.

Dix-sept corrections avec fins distinctes ;SOURCE a_qualifier,propriétaires/dépendances conservés. Bootstrap01KeyErrorselector conservé ;bootstrap02corrige seulement sélecteurs des4JSON,cinqopérations quatre réussies. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactFizz depuis122paires,97candidats hors25unités nommées sans comptecomplet. Goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1472 Fizz, réduction des attaques et collision distinctes

Audit borné terminé :docs/AUDIT_SYS01202_FIZZ_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_fizz_passive_simulation_contract_20261106 :62documentaires/97cohérences du même agent ;18branches,40fenêtres dont32communes réutilisées,29ancres dont28frontières non NimbleFighter,27identités gardées.26entrées concordent V569 :18Rust/2Python/6JSON. Quatre opérations réussies.

Sept natifs parmi8candidats ;2Lua/3globals sans callbacks,3clés en_GB/1binding,2preloads/8communautaires. Unitpassage et basicattackphysicalreduction,f1/niveaux/ordre inconnus. Navigationraw30/gameplayabsent/bodydefaults65ou40 distincts ;DisplayIconSeastone exclu,absenceBuffTextureName non texturemanquante.

V569 hérité6publics sans injection :12impactsAnnie niveau1,30refus,armure22.412/37.412,cloth1029+15 ;pertes41.180603/36.685303 pourraw50.41 conformes arithmétiquement àmitigationordinaire,tol.002,nonsériesrejouées. Fizz/Garen alliés bloqués60/65 ;ennemis traversés parlesdeux,min4.3369/3 ;pas validationFizz. Selectionalliés/batches/routes/reservations etf32prefix/terrain gardés ;V564noncorrigée.

Quatorze corrections avec fins distinctes ;SOURCE a_qualifier et questions propriétaires conservées. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactGalio depuis122paires,96candidats hors26unités nommées sans pourcentagecomplet. Aucun nouveau runtime/build/REA/natif ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1473 Galio, Peau runique et conversion RM vers AP

Audit borné terminé : docs/AUDIT_SYS01202_GALIO_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_galio_passive_simulation_contract_20261106 : 41 documentaires/72 cohérences du même agent ; 16 branches,34 fenêtres dont32communes réutilisées,11ancres dont10frontières non conversion,23identités.22entrées concordent V546 :16Rust/2Python/4JSON. Quatre opérations réussies.

Six natifs,3clés en_GB/1binding ; deux Lua complètement parsés selonrapport,mais vues détaillées absentes du reçu. Quatre champs buff conservés dont Nondispellable ; flags non exécutés. Texte50%RMtotale→AP,f1inconnu ;legacytiersArmure/RM,Passive1=9/niveaux3/7/11 non adoptés. SpellBlock32.1+croissance1.25 présents,BaseSpellBlockabsent.

V546 héritéGalio/Ahri niveau1 :AP0 avecRM32.1/57.1 contre16.05/28.55textuels,delta12.5 ;Tome20AP/Armure15/ventes et Ahri témoins,2×30ticks stables,10refus publics individuels. APactuel objets×autels ;MRbase/croissance/objets/Annie/Exhaust/TrundleR distincts,aucun producteurGalio dans corpsinspectés. Pas d’activation initiale/ordre/temporaire/natif déduits ;16Rustzérooccurrence sans absenceglobale.

Douze corrections avec fins distinctes,SOURCE a_qualifier/propriétaires/dépendances conservés. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactGangplank depuis122paires,95candidats hors27unités nommées sans pourcentagecomplet. Aucun nouveau runtime/build/REA/natif ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1474 Gangplank, poison et ralentissement distincts des invocateurs

Audit borné terminé : docs/AUDIT_SYS01202_GANGPLANK_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_gangplank_passive_simulation_contract_20261106 : 64 documentaires/96 cohérences du même agent ;20branches,37fenêtres dont32communes réutilisées,29ancres dont28frontières nonGrog,30identités.29entrées concordent V570 :20Rust/2Python/7JSON. Quatre opérations réussies.

13natifs parmi17candidats ;5Lua/4initialisations/20globals,Parley NEWTABLEpc12 indéterminé noncorrompu ;4clés en_GB/2bindings,2preloads/12communautaires. Texte7%/3s/3cumuls,magique f1inconnu,attaque/Parrrley ;Scurvy/PirateScurvyW distincts,IsDamagingSpell Scurvyfalse/Striketrue flags noncallbacks.

V570 hérité4publics12physiques60refus720tailticks,MR30/55,vitesse335 sans poison/slow. 3premierscoups92ticks,90ticksexpiryindépendante ne garantit pas3charges ;refreshcommun inconnu,cap nonvalidé. Contrôle publicIgniteExhaust séparé5hits70True,335→234.5→335,75/150ticks,4refus ;pas f1/poison magique. GenericSlow max/tagrefresh etNPCadmissionlimitée distincts,APIserveur nongrantclient. AncienbuildE0559/SummonerTarget etsuccesseur conservés,nonrejoués ;V564noncorrigée.

Seize corrections avec fins distinctes ;SOURCE a_qualifier/propriétaires/dépendances conservés. Audit borné clos,tâche complète/feature/goal ouverts ;SOURCE/HUD/VFX non reclos. Next exactGaren depuis122paires,94candidats hors28unités nommées sans comptecomplet ;préserver producteurpartiel. Aucun nouveau runtime/build/REA/natif ;goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1475 Garen, Persévérance partielle et conflit de délais

Audit borné terminé : docs/AUDIT_SYS01202_GAREN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_garen_passive_simulation_contract_20261106 : 44 contrôles documentaires et 77 cohérences du même agent ; 15 branches connues, 35 fenêtres dont 32 communes réutilisées, 8 ancres dont 6 composants partiels réels et une frontière de table non promue, 21 identités gardées. Dix-sept Rust et table concordent V534 ; deux lecteurs Python concordent avec les preuves communes, sans faux épinglage V534.

Quatre identités natives héritées et cinq clés en_GB ; catalogue/description dix secondes contre table locale 9/6/4 issue d’une republication 4.17, conflit conservé. Champs f1/f2/f3 et affichage par cinq secondes ne prouvent pas leur fournisseur ou cadence runtime. V534 hérité 37 CPU dont 4 Garen, sans rejeu ; fixtures niveau/horloge/blessure directe distinctes de progression/PVmax/réapparition publiques. Interruption avant bouclier, Monster>=11 distinct Boss, taux courant PVmax, régénération et appel Exhaust décrits sans équivalence native.

Douze corrections avec fins distinctes ; SOURCE partiel_a_terminer et propriétaires conservés. Cinq opérations, quatre réussies ; bootstrap01 hypothèse de lecteurs épinglés V534 conservé, bootstrap02 qualifie uniquement ces deux lecteurs par preuve antérieure. Audit borné clos ; tâche complète, fonctionnalité et goal ouverts. SOURCE/HUD/VFX non reclos. Next Gnar exact, 93 candidats hors 29 unités nommées sans compte complet déduit. Aucun nouveau runtime/build/REA/natif, installation ou migration ; goal/Plan/UI/bases/registres/produit inchangés.


## Reprise SYS-01.2-02 — V1476 Gnar, rage après réapparition et transitions de forme

Audit borné terminé : docs/AUDIT_SYS01202_GNAR_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_gnar_passive_simulation_contract_20261106 : 74 contrôles documentaires/97 cohérences du même agent ; 20 branches, 34 fenêtres dont 32 communes réutilisées, 25 ancres dont 24 frontières génériques non Rage Gene, 26 identités. Dix-sept Rust, deux Python et six JSON concordent V572.

V571/V572 hérités : 24 natifs parmi 26 candidats, 9 Lua/4 initialisations/5 globals/5 limites NEWTABLE non corruption, 7 preloads, 9 clés en_GB incluant GnarBig. Texte combat/attaque, capacité suivante au maximum, 15 secondes et f1/f2/f3/f4/f5/f7/f8 inconnus ; définitions alternatives non bonus effectifs. Provenance resource11b6 Stats communautaire distincte du natif140d. WProc/Hyper exclu.

V571 trois jauges pleines 100→100, 12 impacts/48 refus/1800 ticks ; V572 trois morts publiques, 42 impacts préparatoires, 480 ticks de délai, 100→0 puis 12 impacts/54 refus/1800 ticks sans gain. Limite de saturation levée pour ces essais, pas formule native ou transformation. Deux anciens diagnostics de voie BUILD0/RUN101 conservés, attribution tick3048 non qualifiée, successeur central BUILD/RUN0 non rejoué.

Dix-huit corrections avec fins distinctes ; SOURCE a_qualifier et propriétaires conservés. Cinq opérations, quatre réussies ; bootstrap01 attendait24 au lieu25 descripteurs avec catalogue, bootstrap02 corrige seulement ce compte. Audit borné clos, tâche complète/feature/goal ouverts, SOURCE/HUD/VFX non reclos. Next Gragas exact, 92 candidats hors 30 unités nommées sans compte complet déduit. Aucun nouveau runtime/build/REA/natif, installation/migration ou changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1477 Gragas, Happy Hour distinct du contrôle Soin

Audit borné terminé : docs/AUDIT_SYS01202_GRAGAS_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_gragas_passive_simulation_contract_20261106 : 64 contrôles documentaires/87 cohérences du même agent ; 18 branches, 34 fenêtres dont32 communes réutilisées, 21 ancres dont20 frontières non Happy Hour, 28 identités. Dix-sept Rust, deux Python, huit JSON concordent V573. Quatre opérations réussies.

Seize natifs parmi20 candidats, 14 références communautaires, 7 Lua/6 initialisations/30 globals, W NEWTABLEpc16 indéterminé non corrompu ; 6 clés en_GB dont4 présentes et2 W/E sans texte, pas fichiers manquants. Texte4%maxHP/8s, f1 inconnu ; Qfalse/QToggletrue et alias FlashFrost, Alistar/400600/niveaux10 conservés sans adoption.

V573 hérité2cas publics base/Ruby1028 : maxHP583.52/733.52, dix impacts physiques, quarante refus, six cents ticks. Soin90PV dans chaque cas est un contrôle distinct, aucun cast Gragas accepté ni passif4% exercé. Heal240s/7200ticks versus natif300s conservé, non autorité du passif8s. Ancien refus du générateur de livraison conservé, pas échec moteur ; V564 non corrigée.

Seize corrections avec fins distinctes ; SOURCE a_qualifier et propriétaires conservés. Audit borné clos, tâche complète/feature/goal ouverts ; SOURCE/HUD/VFX non reclos. Next Graves exact, 91 candidats hors31 unités nommées sans compte complet déduit. Aucun nouveau runtime/build/REA/natif, installation/migration ni changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1478 Graves, True Grit et erratum des renvois de statistiques

Audit borné terminé : docs/AUDIT_SYS01202_GRAVES_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_graves_passive_simulation_contract_20261106 :65documentaires/91cohérences du même agent ;18branches,33fenêtres dont32communes réutilisées,23ancres dont22frontières nonTrueGrit,26identités. Seize Rust,deux Python,sept JSON concordent V574.

Quinze natifs aux rôles distincts,dix références communautaires,6Lua/26globals,3preloads/1FX identité seule,5clés en_GB dontGritStacks sans binding inventé. Texte incrément1s,cap10,combat défini sur3s ;f1/niveaux inconnus. AliasPineapple/Rumble/ShotAttack et legacycrit/vitesse conservés.

V574 hérité5cas publics,40impacts physiques,75refus,1500ticks. Spans432/468ticks,cadence48/52<90 compatibles avec texte mais diximpacts non dixcumuls. Armure/RM inchangées,bonus objets15armure/25RM distincts. Aucun dégât magique ni expiration native qualifiés ;contributions kills/assist non étatcombatTrueGrit.

Seize corrections avec fins distinctes,SOURCE a_qualifier et propriétaires conservés. Cinq opérations/quatre réussies :contract01KeyErrorstats conservé,contract02 corrige stats_progression et garde tous les renvois. Erratum traçable contract_branch_anchor_errata.json corrige aussi GnarV1476 Mini_stats/Mega_stats et GragasV1477 maxHP vers stats_progression ;anciennes fenêtres exactes,rapports/reçus inchangés,aucun nouvel audit antérieur clos.

Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX non reclos. Next Hecarim exact,90candidats hors32unités nommées sans compte complet déduit. V564 non corrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ni changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1479 Hecarim, conversion de vitesse et passage des unités

Audit borné terminé :docs/AUDIT_SYS01202_HECARIM_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_hecarim_passive_simulation_contract_20261106 :78documentaires/100cohérences du même agent ;16branches,39fenêtres dont32communes réutilisées,30ancres dont29frontières nonWarpath,32identités. Vingt Rust,deux Python,neuf JSON concordent V575 ;quatre opérations réussies,tous les renvois contrôlés.

Onze natifs aux rôles distincts,huit références communautaires,4Lua/3initialisations/20globals,Ramp NEWTABLEpc10 inconnu noncorrompu,2preloads,4clés en_GB. f1/f2 et basevitessebonus inconnus ;icônes personnage/buff distinctes conservées,DDF16entrées actives non formulepassive.

V575 hérité5cas vitesse/AD et4collisions :30impacts mêlée,77refus,450ticks. Vitesse345/370/441.8/467.8 sans bonusAD,contrôle Sword1036+10AD ;Heal30%expire30ticks,softcaplocal nonqualifié etcooldown240/300 conservés. Alliés bloquentHecarim/Garen80/65 ;ennemis traversés parlesdeux,min3.00435,pas preuveWarpath. 80=50+30navigation distinct gameplay80. ADsplit/collision/mouvement inspectés sans producteurWarpath.

Seize corrections avec fins distinctes,SOURCE a_qualifier et propriétaires conservés. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX non reclos. Précédent Graves repris viaresult_qualified.json concordant publication,originaux/errata conservés. Next Heimerdinger exact,89candidats hors33unités nommées sans comptecomplet. V564 noncorrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ni changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1480 Heimerdinger, aura de réparation et contrôles de régénération

Audit borné terminé :docs/AUDIT_SYS01202_HEIMERDINGER_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_heimerdinger_passive_simulation_contract_20261106 :59documentaires/83cohérences du même agent ;16branches,33fenêtres dont32communes réutilisées,23ancres dont22frontières nonRepairBots,26identités. Seize Rust,deux Python,sept JSON concordent V576 ;quatre opérations réussies,tous les renvois contrôlés.

Dix natifs aux rôles distincts,huit références communautaires,3Lua/3initialisations/5globals,2preloads,4clés en_GB. Aura source1992,buff reçu2756,championsalliés/H28G,f1PVpar5s inconnus ;sourcePersistsThroughDeathtrue,ciblechampabsent nonfalse. DDF16actifs sanspassif,NanoQ distinct,Tibbers nonH28G.

V576 hérité2cas publicsalliés :10impacts,30refus,1200ticks+186déplacement,Ahri1.3016PV/s ou1.9524avec1006 à250/1251unités. Portée native inconnue,distances non frontières etpas qualification aura0. Trois anciens BUILD0/RUN101 conservés :destinations communes puis comparateur Hecarim/Ahri bloquée ;successeur2casHeimer BUILD/RUN0,comparateur toujoursnonqualifié.

Seize corrections avec fins distinctes,SOURCE a_qualifier et propriétaires conservés. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX non reclos. Next Irelia exact,88candidats hors34unités nommées sans comptecomplet. V564 noncorrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ni changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1481 Irelia, durée des contrôles et comptage ennemi

Audit borné terminé :docs/AUDIT_SYS01202_IRELIA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_irelia_passive_simulation_contract_20261106 :70documentaires/94cohérences du même agent ;16branches,36fenêtres dont32communes réutilisées,28ancres dont27frontières nonFervor,29identités. Dix-huit Rust,deux Python,huit JSON concordent V577 ;quatre opérations réussies,tous les renvois contrôlés.

Huit natifs aux rôles distincts,sept références communautaires,2Lua/2globals,2preloads,3clés en_GB. Texte10/25/40% etf1 ;portée/comptage/arrondis inconnus. Voracitypersonnage distinctIonianDuelistpreload,sans substitution ;persistance absente nonfalse,DDF4R nonpassif.

V577 hérité4Irelia0_3ennemis et2Garen :3silencesQ publics45ticks/135ticks suivi ;14pairesAPIstun_slow,28événements637ticks,Irelia1_30_90inchangés,Garen90_90/Courage90_63. 74refus publics54serveur ;400diagnostic non portée native,API non sorts joueur. control_duration litCourageclock0.7ceil sans compteurIrelia. disabled_cast_rules12règles/lecteur réel statique,nonimmunité native.

Seize corrections avec fins distinctes,SOURCE a_qualifier et propriétaires conservés. Anciens KeyErrorentrée registre et PREPAREcomparaisontranche conservés,qualification distincte nonrejouée. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX nonreclos. Next Janna exact,87candidats hors35unités nommées sans comptecomplet. V564 noncorrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ni changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1482 Janna, portée de Tailwind et calcul de vitesse

Audit borné terminé : docs/AUDIT_SYS01202_JANNA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_janna_passive_simulation_contract_20261106 : 68 contrôles documentaires/99 cohérences du même agent ; 16 branches, 38 fenêtres dont 32 communes réutilisées, 23 ancres dont 22 frontières non Tailwind, 32 identités. Vingt Rust, deux Python et neuf JSON concordent V578 ; quatre opérations productrices réussies, tous les renvois contrôlés.

Treize natifs aux rôles distincts, dix références communautaires, 4 Lua/3 initialisations/6 globals, NEWTABLE pc18 limite non corruption, 2 preloads, 5 clés dont 3 bindings. Texte 5 %, description tous alliés versus buff Janna et alliés proches conservés distincts ; portée/auto-application inconnues. Source persistance true, cible champ absent non false ; DDF4 W et Zephyr séparés, zéros/Astral Spirts non adoptés.

V578 hérité 4 cas publics : 70 refus, 240 ticks, 40 pas mesurés. Ahri 330/355 à 250/1249.9995, Soin 426.2/452.2 puis retour tick30, Janna/Annie335 ; distances non frontières natives. movement_speed sans terme Tailwind et budget réel vitesse/30 ; softcaps locaux et Soin240/300 non règles natives du passif.

Seize corrections avec fins distinctes, SOURCE a_qualifier et propriétaires conservés. Anciennes preuves/échecs Irelia/Heimerdinger non rejoués. Invocation initiale du répartiteur sans rôle refusée avant producteur, conservée dans root_dispatch_failure.json ; invocation complète réussie, quatre opérations productrices. Audit borné clos, tâche complète/feature/goal ouverts, SOURCE/HUD/VFX non reclos. Next JarvanIV exact, 86 candidats hors 36 unités nommées sans compte complet. V564 non corrigée ; aucun nouveau runtime/build/REA/natif, installation/migration ou changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1483 Jarvan IV, bonus physique et verrou par cible

Audit borné terminé : docs/AUDIT_SYS01202_JARVANIV_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_jarvaniv_passive_simulation_contract_20261106 : 66 contrôles documentaires/92 cohérences du même agent ; 18 branches, 32 fenêtres communes réutilisées, 23 ancres dont 22 frontières non Martial Cadence, 25 identités. Quinze Rust, deux Python et sept JSON concordent V579 ; quatre opérations réussies, tous les renvois contrôlés.

Treize natifs aux rôles distincts, neuf références communautaires, 4 Lua/3 initialisations/5 globals, NEWTABLE pc0 limite non corruption, 2 preloads, 4 clés en_GB. Texte 10 % PV actuels physique max400, délai par cible f1 inconnu ; DDF20 dont4 passifs vides, Cooldown/Cooldown1..6 zéro non verrou, source persistance true/cible champ absent non false. Animation Passive/FX/preloads identifiés sans rendu ; Yi/mana non adoptés.

V579 hérité 2 cas base/Épée1036, 16 impacts sur deux cibles AABBABAB, 32 refus, 180 ticks. AD55.712/65.712 et dégâts ordinaires seuls ; premier PV511.68/bonus textuel51.168 non appliqué. Changements de cible non délai natif, plafond400 non exercé. Chaîne AD→coup mêlée→physique→mitigation/boucliers/PV inspectée sans bonus ni verrou Cadence.

Dix-huit corrections avec fins distinctes ; SOURCE a_qualifier et propriétaires conservés. Ancienne conversion hashstring/int, inspection qualified, syntaxe et commande PowerShell conservées, non rejouées ni corruption alléguée. Audit borné clos, tâche complète/feature/goal ouverts, SOURCE/HUD/VFX non reclos. Next Jax exact, 85 candidats hors 37 unités nommées sans compte complet. V564 non corrigée ; aucun nouveau runtime/build/REA/natif, installation/migration ou changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1484 Jax, cumuls AS et cadence entière

Audit borné terminé : docs/AUDIT_SYS01202_JAX_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_jax_passive_simulation_contract_20261106 : 78 contrôles documentaires/109 cohérences du même agent ; 17 branches, 32 fenêtres communes réutilisées, 31 descripteurs dont 30 frontières non passif sur 29 lignes distinctes, 25 identités. Quinze Rust, deux Python et sept JSON concordent V580 ; quatre opérations réussies, tous les renvois contrôlés.

Vingt et un natifs aux rôles distincts, 7 Lua/6 initialisations/24 globals, NEWTABLE pc6 limite non corruption, 5 preloads/2FX sans rendu, 10 clés dont9 présentes/underscore absent non aliasé. Texte f1%/2.5s/max6 ; R troisième coup et DDF12 R/Q/E séparés. Icônes MasterOfArms/CoupDeGrace distinctes, Speed=RelentlessBarrier, Debuff sans BuffName,9 et3/7/11/15 non formule.

V580 hérité2cas base/Dague1042 :18impacts,30refus,420ticks ;8coups continus gardent47/41ticks,idem après120idle. Aucun cumul actif donc pause non expiration,8coups non cap6 ; Dague15% etarrondi47/1.15 local nonrègle native. Stats/cadence/windup sans contributionJax danschemins sélectionnés ;cadence entière seule peut masquer petitsgains.

Seize corrections avec fins distinctes,SOURCE a_qualifier et propriétaires conservés. Ancienfinisher compteur3au lieu4,preuve/correction séparées eterreursJarvan conservées sansrejeu. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX nonreclos. Next Jayce exact,84candidats hors38unités nommées sanscomptecomplet. V564 noncorrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1485 Jayce, Transform refusé et passage des unités

Audit borné terminé : docs/AUDIT_SYS01202_JAYCE_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_jayce_passive_simulation_contract_20261106 : 74 contrôles documentaires/113 cohérences du même agent ; 17 branches, 38 fenêtres dont 32 communes réutilisées, 23 ancres dont 22 frontières non Hextech, 32 identités. Vingt Rust, deux Python et neuf JSON concordent V581 ; quatre opérations réussies, tous les renvois contrôlés.

Trente-sept natifs aux rôles distincts, 14 communautaires, 16 Lua/14 initialisations/89 globals, 2 NEWTABLE pc14 limites non corruption, 10 preloads, 14 clés dont13 présentes/JaycePassive absent. Texte40vitesse/1.25s/unitéspassables aprèsTransform ; attaqueschargées/formes/DDF40 séparés. GarenRecouperate/Apollo/Jarvan conservés, Haste non contratGhost, CastTime0.115 non duréebonus ; icônesdistinctes préservées.

V581 hérité4cas vitesse :70refus,240ticks20pas ;335/360, Soin431.4/457.4 retourtick30. Transform sanscible refusé avant/après60ticks, donc trigger etexpirationnonexercés. 4casoccupationJayce/Garen :alliésbloqués65,ennemis traverséslesdeux,min4.336914/3.004350,destination250 ;2refusTransformsupplémentaires,72publics distincts72associationsinvalides. Pas qualificationghostingJayce ni politiquenativeGaren.

Dix-huit corrections avec fins distinctes,SOURCE a_qualifier etpropriétaires conservés. PreuveinitialeJax/correctioncompteur/finisheréchoué nonrejoués. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX nonreclos. Next Jinx exact,83candidats hors39unités nommées sanscomptecomplet. V564 noncorrigée ;aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1486 Jinx, contribution récente et accélération après kill

Audit borné terminé : docs/AUDIT_SYS01202_JINX_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_jinx_passive_simulation_contract_20261106 : 75 contrôles documentaires/103 cohérences du même agent ;18branches,36fenêtres dont32communes réutilisées,25ancres dont24frontières nonGetExcited,32identités. Dix-neuf Rust,deux Python,dix JSON concordentV582 ;quatre opérations réussies,tous les renvois contrôlés.

Quinze natifs auxrôles distincts,huit communautaires,6Lua/6littéraux/11globals,4preloads,4clés dont2bindings. Texte175% décroissant4s aprèsdégâts3s surchampion/tour/inhibiteur ;courbe/base inconnues. PassLev1Desc1 absent,descriptionlookup explicite nonliaison ;DDF72dont16Vi,Qnonpassif ;Marker_Bullseye_Kill_JinxCatchMe_rolespréservés. Cache rapportsvide maisMDV582existant retrouvé/épinglé,cacheinchangé.

V582 hérité2cas base/bottes1001 :48baissesPV avecprojectiles témoins,4kills sansassistant,34refus,720ticks20pas ;325/350inchangés aprèskills,or400/300 distinct. XPnaturelle sanshypothèseniveauconstant,Annierespawn nonlifecycleJinx ;témoinJinx nonextensionDraven. Contribution/récompenses réelles15s génériques distinctes3sJinx etbonusvitesseabsent danschemins inspectés ;structuresstatiques nonexercées.

Dix-huit corrections avecfinsdistinctes,SOURCEa_qualifier etpropriétaires conservés. AncienPREPARE1 saturationF et3récupérations interrompues conservés ;préflightespaceseulement,aucun nettoyage/compression/copieDB. Audit borné clos,tâche complète/feature/goal ouverts,SOURCE/HUD/VFX nonreclos. NextKalista exact82candidats hors40unités nommées,suggestionancienneKarma nonautorité. V564/BattleTraining noncorrigés ;aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1487 Kalista, verrou natif conservé et bond manquant

Audit borné terminé : docs/AUDIT_SYS01202_KALISTA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_kalista_passive_simulation_contract_20261106 : 69 documentaires/104 cohérences du même agent ; 18 branches, 35 fenêtres dont 32 communes réutilisées, 27 ancres dont 26 qualifications de frontière, 26 identités. Dix-sept Rust, deux Python et six JSON concordent V663 ; quatre opérations réussies, tous les renvois contrôlés.

Acquis partiel réel conservé : CantCancelWhileWindingUp natif1 → profil cant_cancel=true → windup non annulable. Move/Stop refusés ; Move devrait préparer le bond sans annuler le tir. Nom Rust absent ne prouve pas absence du consommateur générique. Prélaunch vérifie vision ; boucle projectile libéré sans revérification, constat statique non test de perte de vision.

25 natifs sélectionnés/5 preloads/11 Lua dont10 littéraux31globals et1 limite pc8, distincts inventaire114Lua24limites. 5 clés dont4 présentes ; description non liée, CardMaster absent/Shen présent non formule. Communauté C# non vide250/1025 spéculatif non adopté ; DDF8vide etOathsworn/W/R séparés. V663 hérité8simulations1/18avec/sans1001 :20impacts,24essais,132refus,16860ticks,12apportsXPserveur et40trajets sansréémission. Kalista12refus/aucunbond lancement+30 ; Annie12acceptations/annulation/marche. Bottes marche+25 non distancehop.

Dix-huit corrections avec fins distinctes ; SOURCE a_qualifier et propriétaires conservés, archives/restauration non rejouées. Audit borné clos ; tâche complète/feature/goal ouverts, SOURCE/HUD/VFX non reclos. Next Karma exact,81 candidats hors41 unités nommées sans compte complet. V564 non corrigée ; aucun nouveau runtime/build/REA/natif, installation/migration ou changement goal/Plan/UI/bases/registres/produit.


## Reprise SYS-01.2-02 — V1488 Karma, Mantra refusé et remboursement non exercé

Audit borné terminé : docs/AUDIT_SYS01202_KARMA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_karma_passive_simulation_contract_20261106 :93 documentaires/103 cohérences du même agent,18 branches/34 fenêtres dont32 communes réutilisées,20 ancres dont19 frontières,28 identités et27 comparaisons V583. Cinq opérations : quatre réussies, première contract01 échouée sur task_ids absent des en-têtes projetés, conservée puis qualification séparée vers le paquet complet retenu.

Mantra natif niveau1 sans point,fenêtre8s,délais45/42/39/36 ;f1/f2 inconnus. V583 hérité12 impacts physiques,34 refus/180ticks Karma,Mantra jamais armé donc remboursement non mesuré. Deux contrôles GarenQ240/216,2refus/180ticks distincts ; CDR générique et remboursement Ezreal conservés sans adoption. Dix-huit corrections et propriétaires SOURCE conservés ; cache rapports vide mais MD V583 existant retrouvé.

Audit borné clos ; tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX non reclos. Next Karthus exact80 candidats hors42 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining non corrigés.


## Reprise SYS-01.2-02 — V1489 Karthus, mort ordinaire distincte de Death Defied

Audit borné terminé : docs/AUDIT_SYS01202_KARTHUS_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_karthus_passive_simulation_contract_20261106 :93 documentaires/99 cohérences du même agent,21 branches avec constats distincts des corrections,33 fenêtres dont32 communes,22 ancres dont21 frontières,29 identités et28 comparaisons V584. Cinq opérations :4succès,1assertion erronée SOURCE/contrat conservée puis qualification séparée ; propriétaires restés exacts.

Référence7s de sorts gratuits après dégâts mortels ; gardes command/cast/cast_at refusent mort,sorts aussi refusés vivant. V584 hérité31 impacts Annie témoins,2morts/2respawns ordinaires480ticks,164refus dont110dead offsets0/1/209/210/211,960ticks ;516/666PV avecRubis1028. Mana inchangé sur refus nonpreuve de gratuité.27natifs ordinaires,8Lua7littéraux29globals1NEWTABLEpc12,8preloads,7clés1Defileabsente,5candidats absents et2NightmareBot exclus ;aucun alias automatique.

21corrections ; propreOLU-309d2e7c distincte SOURCEOLU-89343a33,propriétaires conservés. Audit borné clos ; tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX non reclos. Next Kassadin exact79candidats hors43unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining noncorrigés.


## Reprise SYS-01.2-02 — V1490 Kassadin, réduction magique et passage des unités

Audit borné terminé : docs/AUDIT_SYS01202_KASSADIN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_kassadin_passive_simulation_contract_20261106 :91 documentaires/101 cohérences du même agent,19 branches et19 corrections avec fins positives précisées en relecture,38 fenêtres dont32 communes,25 ancres dont24 frontières,31 identités et30 comparaisons V585 ;quatre opérations réussies.

V585 hérité4cas Kassadin/Ahri MR30/55 avec/sansCape1033 :8hitsmagiques8physiques,44refus360ticks ;dégâts61.5385/51.6129 ordinaires,sans15%passif. Quatre cas Kassadin/Garen :alliés bloquent65,ennemis traversés parlesdeux,min0.673828/3.004350,destination250 ;passagegénérique nonVoidStone. NullLance shield,EmpoweredASf1,icônes héritées etrayonnav35/gameplayabsent séparés ;13natifs5Lua5littéraux19globals3preloads5clés,4candidats absents. AncienCHECK1NullLance etcompteurpréexécution conservés.

PropreOLU-459008e0 distincte SOURCEOLU-3ace6b6f,propriétaires conservés. Audit borné clos ;tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX non reclos. Next Katarina exact78candidats hors44unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining noncorrigés.


## Reprise SYS-01.2-02 — V1491 Katarina, crédits ordinaires et conflit de Voracity

Audit borné terminé : docs/AUDIT_SYS01202_KATARINA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_katarina_passive_simulation_contract_20261106 :89 documentaires/99 cohérences du même agent,20branches/20corrections,35fenêtres dont32communes,23ancres dont22frontières,31identités et30comparaisons V586 ;4productions réussies. Lecture exploratoire scalaires/objets échouée puis corrigée,consignée séparément sans mutation.

Deux textes directement liés15s tousdélais vs10sR+refreshQWE,priorité nonrésolue. V586 hérité4cas45hitsmêlée témoins,4morts,2killsKatarina400or,1assist113ticks86.875or,0assist612ticks après451attente ;112refus720tailticks. Rangs/délais0,aucunremboursementarmé ;Codex10%CDR noncréationdedélai. Fenêtreassistgénérique450ticks distincte15sremboursement. QWE<15s zéro nonpreuve de priorité ;Rlong etsourceprimaire nécessaires.12natifs2Lua2littéraux7globals2preloads5clés2MaliceAndSpiteabsentes,DDF28AD5/3nonrefund,3cheminscandidats absents,nomsVoracity/KatarinaPassive distincts. AncienBUILD101Windup.releases puisqualifiedreleaseBUILD/RUN0 conservés.

PropreOLU-40833857 distincte SOURCEOLU-db12bc4f,propriétaires conservés. Audit borné clos ;tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX nonreclos. Next Kayle exact77candidats hors45unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining noncorrigés.


## Reprise SYS-01.2-02 — V1492 Kayle, résistances inchangées et cumul non qualifié

Audit borné terminé : docs/AUDIT_SYS01202_KAYLE_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_kayle_passive_simulation_contract_20261106 :86documentaires/94cohérences du même agent,22branches/corrections,33fenêtres dont32communes,23ancres dont22frontières,26identités et25comparaisons V587 ;4productions réussies.

Texte lié3%5s5cumuls surchampion ;composition/refresh/ordre ouverts. V587 hérité2cas14hitsmêlée4AnnieQ,34refus360tailticks334attenteticks,checkpoints149/150/151/181 ;armure20.88/35.88 etRM30/55 inchangées,mitigationordinaire avec/sansCloth+Cloak. Q/E refusés. Debuffabsent :ni expiration ni plafond ni refresh qualifiés. Défenses existantes dontTrundle conservées.15natifs5Lua3littéraux8globals2NEWTABLEpc14/18,3preloads6clés4buffs,DDF8QE nonpassif ;aura/mana héritées,icônes distinctes etskin07 nonadoptés,3chemins absents limités.

PropreOLU-e05f41b6 distincte SOURCEOLU-d1e4dbc2,propriétaires conservés. Audit borné clos ;tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX nonreclos. Next Kennen exact76candidats hors46unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1493 Kennen, marques non exercées et contrôle Annie distinct

Audit borné terminé : docs/AUDIT_SYS01202_KENNEN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_kennen_passive_simulation_contract_20261106 :98documentaires/109cohérences du même agent,26branches/corrections,35fenêtres dont32communes,29ancres dont28frontières,30identités/29comparaisons V588 ;4productions réussies.

Natif6.25s3marques1s25énergie,diminution sous7s sanscoefficient/refresh/ordre résolus. W5attaques distinct des3marques. V588 hérité2cas12hitsprojectiles30refus360tailticks,Wnonappris,rangs/délais0,énergie200toujoursplafonnée,tauxcalculé10/s sansdéficit ;Saphir400or200mana exclu énergie. Aucun déclencheur de marque ni remboursement exercé. ContrôleAnnie5Q5hitsmagiques8refus38ticksPyromania424attenteticks,moveacceptéaprèsexpiry ;38refustotaux. Stungénérique/filtreénergie/régénération conservés,Annie38ticks etCourage nonadoptés pourKennen.32natifs11Lua11littéraux32globals9preloads10clés7buffs16communautaires,5cheminsabsents limités ;legacydamage/.luaalias/Teemo/slot3 nonadoptés.

PropreOLU-292aebc2 distincte SOURCEOLU-e1ee61ff,propriétaires conservés. Audit borné clos ;tâche complète,feature etgoal ouverts,SOURCE/HUD/VFX nonreclos. Next Khazix exact75candidats hors47unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ouchangement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés. Réutilisation/lecturesgroupées appliquées,sansgainmesuré.


## Reprise SYS-01.2-02 — V1494 Kha’Zix, vision courante et Unseen Threat non qualifié

Audit borné terminé : docs/AUDIT_SYS01202_KHAZIX_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_khazix_passive_simulation_contract_20261106 :102 contrôles documentaires,117 cohérences du même agent,24 branches/corrections,38 fenêtres dont32 communes,30 ancres dont29 frontières,31 identités et30 comparaisons V589 ;quatre productions réussies.

V589 hérité :deux cas publics AP0/20,Tome1052,huit impacts mêlée témoins,32 refus,240 ticks cachés immobiles et360 finaux visibles. Cycles par distance,LOS dégagée et snapshot_for vérifiés,propre projection conservée ;aucun bonus magique ou slow observé. Vision historique,f1/f2/f3 etfurtivitéR non qualifiés. Mécanismes réels vision/attaques/dégâts/ralentissements/vitesse conservés ;aucun grant_slow injecté.29 natifs,11 Lua dont2 littéraux vides et9 limites NEWTABLE noncorruption,six preloads,dix clés dont3 anciennes absentes,cinq buffs,DDF40 dont4 PDamage vides,Effect3/35/4/3 nonmappés ;ressources aux vrais chemins personnage,six candidats absents limités.

Propre OLU-4b7ad51f distincte de SOURCE OLU-6f337c9e,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain KogMaw :74 candidats hors48 unités nommées,sans compte global. Erreur exploratoire d’affichage CP1252 conservée,corrigée sans mutation ni échec jeu. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining et anciens échecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1495 Kog’Maw, commandes postmortem refusées et formule divergente

Audit borné terminé : docs/AUDIT_SYS01202_KOGMAW_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_kogmaw_passive_simulation_contract_20261106 :101 contrôles documentaires,104 cohérences du même agent,26 branches/corrections,34 fenêtres dont32 communes,23 ancres dont22 frontières,30 identités/29 comparaisons V590 ;quatre productions réussies.

Contrat lié4s100+25niveau bruts contre3textesSpellData160+30niveau magiques,priorité/f1/rayon/vitesse ouverts. KogMawDead etbase présents,nomsDisplay/Surprise etQ/vitesse325/330 distincts,aucun multiplicateur adopté. V590 hérité :deux cas base/Rubis150HP,32 projectiles Annie,2 morts/2 réapparitions480ticks,164 refus dont110 morts offsets0/1/119/120/121 ;960 ticks observés,ennemi100unités pleine santé,Move mort refusé,aucune explosion observée.100unités nequalifie pas rayon ;480ticks16s distincts4s. Garde morte/cleanup/Trundle/crédit/dégâtsTrue-Magic/respawn préservés.18 natifs,6Lua5littéraux18globals1NEWTABLEpc26,4preloads8clés3buffs,DDF20sansIcathian,10communautaires,4cheminsabsents limités ;Ready/Display persistence métadonnées sanscallback.

Propre OLU-5c2ab9bb distincte de SOURCE OLU-ee18e3cf,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Leblanc :73 candidats hors49 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1496 LeBlanc, seuils sans clone et recharge non armée

Audit borné terminé : docs/AUDIT_SYS01202_LEBLANC_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_leblanc_passive_simulation_contract_20261106 :98 contrôles documentaires,105 cohérences du même agent,27 branches/corrections,38 fenêtres dont32 communes,25 ancres dont24 frontières,33 identités/32 comparaisons V591 ;quatre productions réussies.

Contrat40%/1s/auplus8s/60s/Alt+clicdroit lié. V591 qualifié hérité :deux cas516/666HP,Rubis150HP,24 impacts4 passages sous40%,54 refus4102 ticks ;aucun clone/invisibilité,original visible/projeté,recharge nonarmée,égalité40% nonexercée. Offsets29/30/31,239/240/241,1799/1800/1801/1810 nonpreuves durée/recharge sansproc. Deux RUN initiaux nonnuls avec NPC visant LeBlanc,offset1778 tick3775,exactimpactinconnu ;reprise zonecentrale z7000demandé mêmes durées sansNPC,échecs eterreur générateur conservés.14 natifs6Lua6littéraux9globals4preloads4clés2buffs8communautaires,6candidatsabsents ;BuffNameNoxianCruelty etNondispellable/NonDispellable conservés,Schism/Nightmarecontextes séparés.

Vision/dégâts/régénération etTibbers existants préservés. Recherche tibbers par propriétaire/expiration sansfiltre de définition ;créationannietibbers explicite,réutilisationfutureclone exige isolation,risque statique nonreproduit couvert MULTIPLE-CLONES. Propre OLU-08bfdb44 distincte SOURCE OLU-72bce4c7,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain LeeSin :72 candidats hors50 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1497 Lee Sin, précondition de sort absente et énergie plafonnée

Audit borné terminé : docs/AUDIT_SYS01202_LEESIN_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_leesin_passive_simulation_contract_20261106 :91 contrôles documentaires,94 cohérences du même agent,24 branches/corrections,33 fenêtres dont32 communes,21 ancres dont20 frontières,25 identités/24 comparaisons V592 ;quatre productions réussies.

Texte lié aprèscapacité2attaques40%AS15énergiechacune ;aucun sort accepté donc aucun déclencheur passif valide exercé. V592 hérité :3 cas base/Saphir/Dague18 impacts mêlée témoins,81 refus540tailticks,cadences46/46/40 ;Dague40ticks distincte40%Flurry. Énergie200plafonnée,taux10/s sansmesuredepuisdéficit,aucunrefund15exercé. Cadencecroissance/objets/Trundle/Ezreal/Exhaust etfiltreMana/Energy régénération/plafonds conservés.25 natifs dontmarqueurShen contradiction,11Lua4littéraux22globals7limitesNEWTABLE,1preloadsélectionné16DDFsansFlurry14communautaires4clés ;6cheminsabsents limités. ShenMarker/KiStrike,Passive1=9,Jax/Mana etniveaux3/7/11/15/absent/absent nonadoptés ;ETwoflags nonpreuvederecast,icônesLeeSin/BlindMonkdistinctes,littérauxcosmeticegaux nonéquivalencegameplay. Ancienneinspection1 mauvaiseabsence6niveaux conservée,nouvellequalifiée sansrejouerRust.

Propre OLU-45b97f69 distincte SOURCE OLU-01beee20,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Leona :71 candidats hors51 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1498 Leona, dégâts alliés ordinaires sans marque appliquée

Audit borné terminé : docs/AUDIT_SYS01202_LEONA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_leona_passive_simulation_contract_20261106 :91 contrôles documentaires,99 cohérences du même agent,26 branches/corrections,34 fenêtres dont32 communes,23 ancres dont22 frontières,28 identités/27 comparaisons V593 ;quatre productions réussies.

Texte lié sortsdommageables→marque3.5s→dégâtsalliésconsomment/magie,f2inconnu. V593 hérité :2 cas propriétaireAP0/20,Leona/Annieéquipe0/Ahri1 ;sixmêléesLeona/sixQalliés80raw60mana120tickscd,54refus360tail416attente,rangsLeona0,aucunsortaccepté,nomarque/consommation/expiration/scalingqualifiés. Pyromania3Qpasstun,contrôleAnnieconservé.27 natifs9Lua9littéraux31globals8preloads6clés4buffs13communautaires ;permanentSunlightPassivepersistant distinctmarqueSunlightsansflagsde persistancequalifiés,Qactivation/attaque distincts,Wslot2nonindexRustautomatique,DDF4SolarBarrierarmor/MR0.2nonSunlightf2,niveaux1/4/7non table ;4cheminsabsents limités.

Propre OLU-1a3d4eea distincte SOURCE OLU-ef69d9f5,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Lissandra :70 candidats hors52 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1499 Lissandra, gratuité non exercée et recharge non armée

Audit borné terminé : docs/AUDIT_SYS01202_LISSANDRA_PASSIF_SIMULATION_CONTRAT_2026-11-06.md. Preuves E:/mapslol3v3/audit_sys01202_lissandra_passive_simulation_contract_20261106 :92 contrôles documentaires,109 cohérences du même agent,25 branches/corrections,36 fenêtres dont32 communes,25 ancres dont24 frontières,30 identités/29 comparaisons V594 ;quatre productions réussies. Unité datée6novUTC malgré7novlocal.

Texte18s prochain sortgratuit/1s réduction quandcapacitégênedéplacement ennemi,objetsCCexclus. V594 hérité :2 casbase/Codex30AP10%CDR,six projectiles102 refus1082 ticks,offsets539/540/541aprèsStop,Mana304plafonné,rangs0,aucunsortcoût/timer/CCpassifexercé. Stopnonorigine,attente18noncycle,manainchangépasgratuité ;CDRd’objet distincte exclusionCCobjets.32 natifs11Lua5littéraux17globals6limitesNEWTABLE,8preloads11clés10présentes1PassiveBuffabsente,9buffs24DDFvides16communautaires,5cheminsabsents limités ;Passive/Buff/Ready distincts,persistancepaspolitique,SlowChronokeeper conservé.

Récepteursgénériques CDR/slow/stun/mouvement préservés,noncallbacksIceborn. Slowstocke tag/fraction/expiration sansowner/typeorigine ;Stunsource sansclasscapacité/objet ;provenanceàqualifier au producteur/callsite,limite statique nonabsenceglobale/nondéfaillancereproduite,couverteCC-PROVENANCE. Propre OLU-dbfb0872 distincte SOURCE OLU-bc32c17d,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Lucian :69 candidats hors53 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1500 Lucian, double tir non armé et attribution distincte

Audit borné terminé : docs/AUDIT_SYS01202_LUCIAN_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_lucian_passive_simulation_contract_20261107 : 97 contrôles documentaires,102 cohérences du même agent ;30 branches/corrections,36 fenêtres dont32 communes,23 ancres dont22 frontières,26 identités/25 comparaisons V595. Deux échecs de contrôles conservés (Known omis puis champ boutique incorrect),contract03 qualifié réussi ;aucun défaut produit corrigé.

V595 hérité :deux cas base/épée1036+10AD,AD52.04/62.04,six projectiles102 refus362 ticks179/180/181aprèsStop,rangs/recharges0,Mana298.88plafonné. Aucun sort accepté,charge réelle,doubletir ou expiration exercés. Texte sortterminé/sixsecondes/@f1@ champions-structures/dégâtscomplets sbires-monstres/onhit lié ;Sword etShot1.2 nequalifientpas formule.35 natifs13Lua4littéraux11globals9NEWTABLE,6preloads7clés6présentes1Eabsente,5buffs4résolus,84DDF10nonvides sansPassive19communautaires,7absences limitées. Icônes25/Draven,Qrépètepassif,preloadsRageblade/Hurricane conservés.

Attaques critiques dégâts voldevie riposte etrecap génériques réels préservés. Recap capte acteur visible avantimpact etregroupe paracteur/typesdégâts ;aucune identitécapacité,IsDeathRecapSource nonpreuve raccordement ;correctionRECAP-ATTRIBUTION sansdéfautproduit/échecruntime revendiqué. Propre OLU-1eccb022 distincte SOURCE OLU-d2dbadd5,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Lulu :68 candidats hors54 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1501 Lulu, attaque exercée sans salve Pix et transfert distinct

Audit borné terminé : docs/AUDIT_SYS01202_LULU_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_lulu_passive_simulation_contract_20261107 :126 contrôles documentaires,151 cohérences du même agent ;34 branches/corrections,42 fenêtres dont32 communes,23 ancres dont22 frontières,29 identités/28 comparaisons V596. Échec bootstrap01 supposant liste de rapports vide conservé ;bootstrap02 qualifié réussi,candidat MD exact déjà présent.

V596 hérité :2 cas base/Tome1052+20AP,AD46.368inchangé,six projectiles Lulu/six impacts physiques,54 refus360 ticks aprèsStop,Mana292.4plafonné,rangs/recharges0. Attaque propre déclenchante exercée maisaucun dégât magique Pix observé ;sorts refusés bloquent séparément transfertE.180ticks non durée native.60natifs29Lua25littéraux102globals4NEWTABLE,13preloads24clés20présentes4anciennesLuxabsentes22bindingsspell6lignesmanquantes,4buffsrésolus,4DDFQ0.133nonpassif21communautaires,6absences limitées. f1/f2 nonrésolus ;petBaseDamage24 etMissile1.2 nonformules,aliasesEzreal/Ashe/Caitlyn etanciensnoms conservés.

Anniepet créeannietibbers ;lookup/ordres génériques donnéespet avecvaleursAnnie exigent isolationfuturePix,nondéfaillancereproduite. NoyauFirstContact/Pierce àdirectionfixe sansguidage/dégâts ;visionLOS/rayons/Ignite/projection etrecapparacteur préservés,nonraccordementsPix. Propre OLU-de7e1432 distincte SOURCE OLU-253ae6a0,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Lux :67 candidats hors55 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1502 Lux, marque absente et déclenchement R non exercé

Audit borné terminé : docs/AUDIT_SYS01202_LUX_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_lux_passive_simulation_contract_20261107 :125 contrôles documentaires,151 cohérences du même agent ;32 branches/corrections,39 fenêtres dont32 communes,23 ancres dont22 frontières,27 identités/26 comparaisons V597 ;quatre productions réussies. Rapport V597 retrouvé malgré candidatscachevides.

V597 hérité :2 cas base/Tome1052+20AP,AD53.544inchangé,six projectiles/six impacts physiques,54 refus360ticks180aprèsStop,Mana334plafonné,rangs/recharges0. Aucun sort accepté,marque appliquée,consommation,expiration6secondes ouRtrigger/refresh exercé ;attaques sansmarque etAPnonformule,attentedepuisStopnonexpiration.37natifs14Lua2littéraux6globals12NEWTABLE,7preloads26clés16présentes10absentes dont4passiveSpellData,26bindingsspell4buffsrésolus20communautaires,5absences limitéesdontDDF. f1/f2 nonrésolus,coefficients0nonzérodégât,persistanceporteur nonduréecible,Rmain0.75/80/100/25000/250 etMis0.7/60/0/3500/299.3 distincts ;26NightmareBot exclus.

EzrealW4.20 bonusASallié réel avecétatsource/session/temps etnettoyage,gardesréutilisablesmaisnonmarqueLux niEzrealmoderne ;150ticksnon6secondes. Attaques GarenTrundle dégâts voldevie recap préservés. Propre OLU-3f8de764 distincte SOURCE OLU-218dcb80,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Malphite :66 candidats hors56 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1503 Malphite, absorption générique distincte du bouclier naturel

Audit borné terminé : docs/AUDIT_SYS01202_MALPHITE_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_malphite_passive_simulation_contract_20261107 :120 contrôles documentaires,128 cohérences du même agent ;32 branches/corrections,38 fenêtres dont32 communes,42 ancres dont41 frontières incluant15V548,28 identités/27 comparaisons V598. CandidatcacheV548 conservé etrapportV598 retrouvé. Écheccontract01 comptait22liens comme17sources ;contract02 qualifié17sourcesuniques22liens5répétés,historiqueinchangé.

V598 hérité :2cas base/Ruby150PV,maxPV574.2/724.2,références10%57.42/72.42 nonboucliersgénérés ;sixphysiques2QAnnie80raw60mana,102refus602ticks299/300/301aprèsdernierQ,boucliersvides sansgrantinjecté. V5483cas9fenêtres301ticks_vienondécroissante pastraceexhaustive événements ;seulcontrolediagnostiquegrant57.42tick1418durée600_expire2018 absorbe45.113puis12.307avec32.806débordement,expirationnontestée ;9Attack+5grantrefusatomiques conservés. Aucunprodnaturel/resetnatifqualifié,refusMalphitesortsn’expliquepaspassifabsent.

39natifs13Lua4littéraux10globals9NEWTABLE,12preloads8clésprésentesdont2contextes2254/2630nonbindings,17communautairesdistincts22liens,4DDFLandslide nonformule,6absenceslimitées. Jax/mana/Passive9/niveaux3/7/11/15 conservésnonadoptés ;normal/gris/Removalpersistencenonrespawn,priority3/Skin06constantesnonaffectations,LeonaParticle nonrendu. Shieldgrant/expiry/absorb génériquesréels conservés,tri parexpiration nonprioriténative ;caprefresh pasrecalculshield danscorpsinspecté,hit/raw/postmitigation/absorbed/HPreMoved distinctionàqualifier. Propre OLU-ae4cf334 distincte SOURCE OLU-8dac155d,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Malzahar :65 candidats hors57 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1504 Malzahar, compteur et horloge de créature non exercés

Audit borné terminé : docs/AUDIT_SYS01202_MALZAHAR_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_malzahar_passive_simulation_contract_20261107 :112 contrôles documentaires,119 cohérences du même agent ;36 branches/corrections,39 fenêtres dont32 communes,30 ancres dont29 frontières,32 identités/31 comparaisons V599 ;quatre productions réussies. Ajout courant ciblé Annie_passive dansadditional_current_inputs,aucune référenceMalzaharfonctionnelle promue.

V599 hérité :2cas base/LongSword1036+10AD,AD54.7/64.7,six impacts physiques/six projectiles,246refus1262ticks631aprèsStop,offsets209/210/211,419/420/421,629/630/631. Aucun sort Malzahar accepté,aucun pet/voidling/horlogecréature ;7/14/21attentedepuisStop noncroissance/frénésie/expiration,épéeADchampion nonhéritagepet.57natifs23Lua23littéraux80globals0NEWTABLE0child,13preloads11clésprésentes9buffs25communautaires,6absenceslimitées13NightmareBotexclus. Texte4sorts/21s/7s+50%dégâtsarmure/14s+100%AS,formulesdescription200+50lvl/20+5lvl liées,producteursf1f2f3/niveauAD nonrésolus. Ready/CountBuff/DetonationSummon etaliasesNautilusMalady/EzrealFallenAngel conservés ;persistencenonlifecycle,deuxmainsVFXnonâge.

CompteurAnnieQimpact_W/Rrelease_Eacceptation noncompteurMalzahar. Unit.pet AnniePet,worldctorrequiresdefinition_petNone_niveaumoyeninutilisé,Map10 sansVoidling chargeannietibbers ;Tibberscréation/ordres/AI/expiry acquisdistincts,raccordementfuturexigeisolation sansdéfautreproduit. Propre OLU-8683670f distincte SOURCE OLU-9cd25feb,propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Maokai :64 candidats hors58 unités nommées,sans compte global. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1505 Maokai, sorts proches et attaques sans soin supplémentaire

Audit borné terminé : docs/AUDIT_SYS01202_MAOKAI_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_maokai_passive_simulation_contract_20261107 :108 contrôles documentaires,122 cohérences du même agent ;31 branches/corrections,39 fenêtres dont32 communes,30 ancres dont29 frontières,30 identités/29 comparaisons V600 ;quatre productions réussies.

V600 hérité :2cas base/rubis150PV,10Q ennemis Annie acceptés à150unités raw80/coût60,6mêlées Maokai,54refus atomiques360tail864CDwait76stuncleanup. PVmax572.2/722.2,références7%40.054/50.554 pas soins observés ;déficit277.66223 avant premiercoup dépasse références,supplémentexactement0. Aucun appelheal/state injecté. 5eQ/stun38localticks parcas = compteurAnnie,paschargesMaokai ;150distance pasrayon maximal,ownMaokaiCastrefused pas explication suffisante après sorts externes/attaques réels.

62natifs26Lua25littéraux80globals1NEWTABLEpc10 sanscorruption,14preloads15clés14présentes dontJestervide1descriptionabsente9buffs26communautaires6absenceslimitées. Texte5chargesproches/prochaincoup7%PVmax ;f1/rayon/éligibilité ouverts. Nidalee600/900/60/0.4,coefficientsMelee0,mana40/60/80 nonrèglesSapMagic ;Readyiconsdistinctes,Soundnames/handeyeffects nonaudio,persistence noncounterrespawn. GenerichealAPIcapIgniteTrundleW,AnniecounterQimpact/W/Rrelease/Eaccept,stun/lifesteal/regeneration acquisdistincts. Propre OLU-a21f5243 distincte SOURCE OLU-06d4ed7c propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain MasterYi :63 candidats hors59unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1506 Master Yi, quatrième attaque sans second impact

Audit borné terminé : docs/AUDIT_SYS01202_MASTERYI_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_masteryi_passive_simulation_contract_20261107 :102 contrôles documentaires,110 cohérences du même agent ;34 branches/corrections,36 fenêtres dont32 communes,24 ancres dont23 frontières,26 identités/25 comparaisons V601 ;quatre productions réussies.

V601 hérité :3cas base/LongSword10AD/Dagger15%AS,24impacts ordinaires (8parcas,coups4/8inclus),81refus atomiques540tail,AD60.04/70.04/60.04,cadences44/44/38 septintervalles constants. Aucun secondimpactentrelescoupsou180ticksaprèsStop parcas ;fenêtreexercepremierproc maiscompteur/récomptagesecond/reset/futurscycles ouverts. Ownspellsrefused pas explicationsuffisante après attaques réelles ;aucune injectioncounter/secondhit.54natifs23Lua14littéraux70globals9NEWTABLEnoncorruption11preloads13clés12présentes dontMasterYiDoubleStrikevide1BuffDoubleStrikeabsent10Buff9résolus23communautaires16DDF2nonvidesQ/Epaspassif6absenceslimitées. Texte4eattaqueconsécutive/second50% ;legacyChance/mana40/60/80/zeroCoeff nonpolicy,CanCrit/OnHitabsents nonfalse. ReadyPassive1/StacksPassive2/Persistence nondurée/reset. OrdinaryAttackADrelease_GarenTrundle_crit/lifesteal/regen/damage/recap acquisdistincts. Propre OLU-79fbf560 distincte SOURCE OLU-8d689413 propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain MissFortune :62candidats hors60unités nommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecs noncorrigés/nonreclassés.


## Reprise SYS-01.2-02 — V1507 Miss Fortune, vitesse constante sans bonus Strut

Audit borné terminé : docs/AUDIT_SYS01202_MISSFORTUNE_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_missfortune_passive_simulation_contract_20261107 :105 contrôles documentaires,117 cohérences du même agent ;32 branches/corrections,40 fenêtres dont32 communes,26 ancres dont25 frontières,29 identités/28 comparaisons V602 ;quatre producteurs journalisés réussis. Préparationlocale SyntaxError parenthèse avantcréationproducteur conservée etqualifiée parqualify_missfortune_coherence_syntax_20261107.py/coherence_preparation_qualification.json ;pasunéchecproducteur journalisé.

V602 hérité :2cas base/bottes1001+25,vitesse325/350 constante sansStrut,1324ticks4fenêtres331,2QAnnie reçusraw80cost60,8trajets216pas208complets8partiels,54refus.21offsets149/150/151à329/330/331 pasordrenatifincrément/plafond. Dégâtréel pasresetdunbonusjamaisactif ;owncastrefusalpasexplicationsuffisante de labsencependantattente/mouvement.62natifs27Lua18littéraux45globals9NEWTABLEnoncorruption13preloads10clésuniquesprésentes9Buffbindings8clésBuff25communautaires12DDF1nonvideBulletTime0.35bonusADnonStrut6absenceslimitées. Texte5sec25puis8/secplafond70 ;DrawaBeadnonTristana,Passive/PassiveStackImpureShotsWnonStrut ;persistence nontimerrespawn. MovementmodifiersGarenHealRelicTrundleSlow/occupation acquis ;stats.move_speed appellemovement_speed,pasproducteurindépendant ;caps220415490reconstructionhistoFalse ;V564nonrequalifié. Propre OLU-2b9d13b4 distincte SOURCE OLU-f8d1b519 propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain MonkeyKing :61candidats hors61unitésnommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etanciens2échecsV602 générateur/fichierabsent conservés nonreclassés.


## Reprise SYS-01.2-02 — V1508 Wukong, défenses constantes et rayon non qualifié

Audit borné terminé : docs/AUDIT_SYS01202_MONKEYKING_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_monkeyking_passive_simulation_contract_20261107 :112 contrôles documentaires qualifiés,121 cohérences du même agent ;31branches/corrections,41fenêtres dont32communes,29ancres dont28frontières,33identités/32comparaisonsV603. Cinqopérations4réussites1écheccontract01conservé ;zéroomiss etaliasWukongcfgTestattacks539=>contract02qualifié,original/code/logs etliteral_search_qualification conservés.

V603 hérité :64natifs24communautaires27Lua17littéraux46globals10NEWTABLEnoncorruption16preloads8clésprésentes6Buff16DDF3nonvidesQERpaspassiff1_23NightmareBotexclus_6absenceslimitées. StoneSkinarmureRMparennemi,f1niveauxrayonéligibilitéinconnus ;15SpellDataabsentspas0,base24.88/32.1 nonbonus ;CassiopeiaStoneSkiniconsdifférents_AkaliWolfmanaliasesnonmécaniquesétrangères_persistence nonaurarespawn. Deuxcas6joueursbase/Cloth15NullMagic25 prix800dans825,defenses24.88/32.1et39.88/57.1constantesaucunStoneSkin. Ennemis0/0/1/2/3/3/2/1/0,2alliestémoins,proches150300450visibles,lointains180019502100,600observationnonrayonnatif_1350visionnonrayonpassif.18phases540ticks6physiques2QAnnie80/60_54refus_28trajets4reprisesStopMove_setup899parcas ;3anciensBUILD0RUN101restentéchecs_reprisesfinalesnonNavFix_niCauseV564prouvée ;pasinjectionstateDamageXP. StatsbasecroissanceitemsGarenAnnieExhaustTrundle_DamageStatsPenetrationMitigationShields_VisionNavigationacquisdistincts. Propre OLU-54b724a7 distincte SOURCE OLU-f246e96f propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Mordekaiser :60candidats hors62unitésnommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining noncorrigés.


## Reprise SYS-01.2-02 — V1509 Mordekaiser, ressource et bouclier générique distincts d’Iron Man

Audit borné terminé : docs/AUDIT_SYS01202_MORDEKAISER_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_mordekaiser_passive_simulation_contract_20261107 :118 contrôles documentaires,123 cohérences du même agent ;36branches/corrections,40fenêtres dont32communes,33ancres dont32frontières,29identités/28comparaisonsV604 ;quatreproductionsréussies.

V604 hérité :57natifs23communautaires24Lua24littéraux42globals0NEWTABLE13preloads9clés8présentesJesterabsente6Buff4DDF2QbonusADnonf1f2passif6absenceslimitées. IronManf2%abilitydamage_capf1PV_decay3%sec_halfminions_notallnonchamp ;f1f2base/délai/cadence/plancherouverts. ShieldPARBaseMP120string_nonNativeCapProof_PersistentNonDispellableabsent_mana40/60/80legacy_Rguide0.5priority10nonpassif_foreignaliasesNautilusViktorFallenAngelconservés. Deuxcaspublicsbase/Ruby150Sapphire200 prix800dans825_PV555.4/705.4_carrier120max120regen0_shieldsvides6attaquessortantes6physiquesentrantes2QAnnie80/60_54refus244wait_offsets29/30/31/59/60/61nonâgeactif. AucunMordspellaccepté=>déclencheurcompétencenonexercé,attaquesordinairesnonpreuvedéchecconversion. Troisièmecontrôleautoritairegénériquegrant_shield explicitementhorssansinjection descaspublics_LOCAL_GENERIC/NOT_IRON_MAN_50absorbésur3eQ_80fixe1..29expiry30/31_7invalidesrefusés ;pasproducerIronMannidécroissance3%.4trajetspublics+2génériquesaucunreorder. Joinresource/shielddistincts_lifecycleShieldnonManaEnergy_shopcaps_genericsameTagReplacementSoonerExpiryAbsorption_acquispréservés. Propre OLU-e6b4c4a7 distincte SOURCE OLU-8606cc2e propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos. Prochain Morgana :59candidats hors63unitésnommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;anciens3échecsWukong/V564/BattleTraining nonrequalifiés.


## Reprise SYS-01.2-02 — V1510 Morgana, vol de vie ordinaire distinct de Soul Siphon

Audit borné terminé : docs/AUDIT_SYS01202_MORGANA_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_morgana_passive_simulation_contract_20261107 :157contrôles documentaires,133cohérences du même agent ;34branches/corrections,40fenêtres dont32communes,46ancres dont45frontières/18anciennesconservées,30identités/29comparaisonsV605etV555 ;AnnieWrulesajoutciblé ;quatreproductionsréussies.

V605/V555reçusrapportsconservés :28natifsincluant7anciensmêmesidentitésdéclarées_18lienscommunautaires15identitésuniquesnonfusionnés18NightmareBotexclus10Lua3littéraux8globals7NEWTABLE7preloads3clésprésentes8absencesdontDDF. CharScriptnatifNONvide2flags sanscallback_communautairevide_EmpathizeAura/persistence nonalliedregen/respawn. F1SpellVamp/niveaux/modificateurszonepériodiqueciblesouverts_legacyallyregen/mana40/60/80nonpolicy_W16timers0.3125malgrécommentSinglePulse_rayonsW275/natif280_R600/natif625nonadoptés_QWERcoefsnonf1. V6053casbase/Tome20AP/Sceptre10AD8%_9out9in3Q81refus540wait6trajets_sceptre4.392551attendu4.392550observé_baseTome0tol.002 ;PVmanquantssuffisants,pasPVpleinsantihealshieldacceptance. V5553casMorgana0/Morgana1053/Annie1053_9attacks12reçus41refus90tail_soins0/4.10614/3.78937_WAnnie70mana_tick1087_net52.937866_noheal. Contextesdistincts_mêmes29identitésnonscénariosidentiques_norégressiondéduite. AucunMorgspellaccepté=>triggernonexercé ;ordinarylifesteal/AnnieWnonSoulSiphon. CurrentbasicAttackPostMitigationHeal_genericHealCapIgniteTrundle_AnnieW64..83directmagicdamage horsTests_acquisconservés ;relevé639Rusthéritépasrejoué,18sélectionnésrelus. Propre OLU-45c6372b distincte SOURCE OLU-96dfbc8e propriétaires conservés. Audit borné clos ;tâche complète,fonctionnalité etgoal ouverts,SOURCE/HUD/VFX nonreclos,V555nonremplacé. Prochain Nami :58candidats hors64unitésnommées,sanscompteglobal. Aucun nouveau runtime/build/REA/natif,installation/migration ou changement goal/Plan/UI/bases/registres/produit ;V564/BattleTraining etancienséchecsnonrequalifiés.


## Reprise SYS-01.2-02 — V1511 Nami, contact allié non exercé et deux arrivées échouées conservées

Audit borné terminé : docs/AUDIT_SYS01202_NAMI_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_nami_passive_simulation_contract_20261107 :101contrôles documentaires,127cohérences du même agent ;36branches/corrections,36fenêtres dont32communes,22ancres dont21frontières,26identités/25comparaisonsV606 ;quatreproductionsréussies.

V606hérité :63natifs28communautaires26Lua12littéraux50globals14NEWTABLEnoncorruption12preloads9clés7Buffrésolus24DDFvidesdont4passif ;40plusf1pendant1,5s contactcompétenceallié,f1capture/niveauxéligibilitérefreshstackingouverts. PassiveDescvide_4levelsstring0_2absents_nonprogression_30SpellDataabsentsnon0_JannaMinotaurZyraaliasesnonforeignPolicy_Debuffnonmalus_RunSpeedPersistenceNonFormule_CharScriptsvides7absenceslimitéesressourcesCharactersSpells. CommunityWsingleTargetMalgréBounceComment_EnameNamiTidecaller_Qdelay1,5RinstantAngle_nonpassiveContact. Deuxcas3joueursNami21Ahri23alliéesAnnie22ennemie_baseBoots25Tome20prix760dans825_Nami335360Ahri330AP0/20Mana377,24_102refus184idle_offsets44/45/46nonâgeactif_6setups1037chacunaucunreorder. AucunNamiSpellaccepté=>contactalliéNonExercé_nonéchecPassifSurDéclencheur.8walks6pass2fail512samples198full_2allersAhri36short_destinationNone24full156zero180samples_criteresmoins1et10fullpréservés_collecte0nonNavigationPass ;3anciensBUILD0RUN101restentéchecs_causeouverteNonAttributionV564. StatsMoveSpeedmêmeproducer_genericsGarenHealRelicTrundleSlowsCaps220415490historicalfalse_fitStepOrderMotion_acquispréservés. PropreOLU7963 distincteSOURCEOLUb4e7_propriétairesconservés36correctionspositivesnonenregistrées. Auditbornéclos_tâchecomplètefonctionnalitégoalouverts_SOURCEHUDVFXnonreclos. ProchainNasus57candidatsHors65nommés_noncompteglobal. AucunNouveauRuntimeBuildREANatifInstallMigrationGoalPlanUIBasesRegistresProduit ;V564BattleTrainingAnciensÉchecsnonrequalifiés.


## Reprise SYS-01.2-02 — V1512 Nasus, vol de vie des objets et diagnostic XP distincts de Soul Eater

Audit borné terminé : docs/AUDIT_SYS01202_NASUS_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_nasus_passive_simulation_contract_20261107 :178contrôles documentaires,156cohérences du même agent ;37branches/corrections,39fenêtres dont32communes,38ancres dont37frontières,30identités/29comparaisonsV607etV540 ;quatreproductionsréussies.

V607V540reçusrapportsconservés32natifsincluant6anciensmêmesidentitésdéclarées_19lienscommunautaires16identitésuniquesnonfusionnés12Lua7littéraux23globals5NEWTABLEnoncorruption7preloads10clés9présentes6Buff5résolusNasusQabsent24DDF2Q@stacksCoeff3nonf1passif5absenceslimitées. SingedPVmanaMagic10_SoulNexusSoulNexusCounters_nonpolicy_6levels15SpellDataabsentsnon0_f1progressioncombinaisonouverts_CharScriptsvides_PersistenceNonRespawn_ChronokeeperAliasNonForeignPolicy_CommunityQspellGlobalAD_EcommentOnly_RdefensesNonConversionQualification. StatsitemsLifeStealOnly_basicPhysicalPostMitigationAliveNonStructureHeal_genericCapIgniteTrundleDistinct_acquisGarenTrundleCritMitigationRegenRecappréservés. V6073casbaseSword10ADScepter10AD8pct_AD59,18/69,18/69,18_9melee9received3Q80/60_81refus540wait6tripsNoReorder_baseSword0tol002ScepterExpected4,642174Observed4,642190PV ;missingHPenough_nonFullHPantihealAmplificationShieldOverkillAcceptance. V540NasusGaren2cas12hits6each_ticks899946993104010871134_heals0ou4,339477regen1,8024_distinctProtocolNotNumericEquivalenceNoRegressionInferred.36levelRows1to18_19245ServerAwardXP+1Each_noDirectMutationNoNetworkNoKillProgressionNoCombatHeal2to18_rates0/8pct_8XPRefus ;XPcurve989BsameBothReceipts_thresholds2to18_LocalCap18_Level1AbsentInitial0Observed_19/20nonExercised. OrdinaryBasicTriggerExercised_ownSpellRefusalNotSoleExplanation_noNativeDeficitQuantifiedWithoutF1. PriorCollection0DynamicTooltipTypoDynasuscTooltip_conservedQualifiedNewCollection_Inspection1NasusQmissing_thenLimitRecordedNotResolved. PropreOLU3b73_SOURCEOLU2f4cOwnersPreserved37positiveCorrectionsNonRegistered_fullTaskFeatureGoalOpen_SOURCEHUDVFXnotReclosed_V540notReplaced_Nami2FailedWalks3RUN101_V564BattleTrainingNotRequalified. ProchainNautilus56outside66namedNonGlobalCount. AucunNouveauRuntimeBuildREANatifInstallMigrationGoalPlanUIBasesRegistresProduit.


## Reprise SYS-01.2-02 — V1513 Nautilus, racine et immunité par cible distinctes du stun générique

Audit borné terminé : docs/AUDIT_SYS01202_NAUTILUS_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_nautilus_passive_simulation_contract_20261107 : 146 contrôles documentaires, 146 cohérences du même agent ; 42 branches/corrections, 40 fenêtres dont 32 communes, 32 ancres dont 31 frontières, 31 identités/30 comparaisons V608 ; quatre productions réussies.

V608 hérité : 79 natifs, 30 communautaires, 33 Lua/23 littéraux/123 globals/10 limites NEWTABLE sans corruption, 19 preloads, 13 clés/11 Buffs résolus, 8 DDF dont 2 Q/W non passifs, 5 absences bornées. Bonus physique f1, racine f2, délai même cible f3 connus comme rôles, valeurs/niveaux ouverts. Raw Passive1=9/niveaux3/7/11/15 et VFX lv1/6/11/16 non adoptés ; legacy Jax/mana et alias Malady/Lux sans politique étrangère ; CharScripts vides ; persistance non respawn. Root preload ne démontre pas résolveur, callback ou rendu. Q communautaire root0,5 sans hook/pull, W buff6s, R délai1s/zone300, E timers0,4/Slow2 non adoptés comme fidélité. Deux cas publics base/Épée10AD : AD57,544/67,544, six mêlées/six reçus/deux Q80/60, 54 refus atomiques, 360 ticks, quatre trajets sans reprise. Dégâts ordinaires seuls, aucun bonus ; cible mobile aux ticks2206/2207/2208 après impact2205, 11,166504 unités à335/s, six échantillons. Aucun sort propre accepté, mais attaque déclencheuse exercée : refus non explication suffisante. Pas de racine => aucune durée f2 mesurée ; pas de marqueur => attente90 non expiration f3. Stun générique grant/gardes/interruption/expiry et règles disabled_cast locales acquis distincts, non substitués à root ; dégâts, critique, soins, régénération, récapitulatif conservés. Propre OLU-d8a4ee84 distincte SOURCE OLU-df1c7ce3, propriétaires conservés ; 42 corrections positives non enregistrées. Tâche complète/fonctionnalité/goal ouverts ; SOURCE/HUD/VFX non reclos. Prochain Nidalee :55 hors67 nommés, sans compte global. Aucun nouveau runtime/build/REA/natif, installation/migration, changement goal/Plan/UI/bases/registres/produit ; V564, échecs Nami et Battle Training non requalifiés.


## Reprise SYS-01.2-02 — V1514 Nidalee, buisson exercé, Hunt et Cougar non exercés

Audit borné terminé : docs/AUDIT_SYS01202_NIDALEE_PASSIF_SIMULATION_CONTRAT_2026-11-07.md. Preuves E:/mapslol3v3/audit_sys01202_nidalee_passive_simulation_contract_20261107 : 151 contrôles documentaires qualifiés, 150 cohérences du même agent ; 44 branches/corrections, 38 fenêtres dont32 communes, 29 ancres dont28 frontières, 33 identités/32 comparaisons V609. Cinq opérations : quatre réussites et contract01 échec1 conservé ; contract02 qualifie 72 identités natives par chemin contre68 étiquettes par nom, quatre noms Cougar à deux chemins. Scripts, logs et source_role_counts_qualification conservés ; aucune source/trace modifiée.

V609 hérité :72natifs33communautaires23Lua12littéraux41globals11NEWTABLEnoncorruption14preloads32DDFvides5absencesbornées.15clés13présentes11Buff9résolus ; BrushPassive/Bushwhack absentes. Deux SpellData vérifiées directement : tooltip11745 exclut Swipe comme description4240, Buff2351 l’inclut ; conflit non tranché. CastRange5900 contre texte5500 non adopté par défaut. Brush10%2s/towardVisible30%5500/Hunt4s rôles connus ; legacycritAttackRate10/15/20 et6levelsabsents nonpolicy. Humain lieHunt,CougarLuaNameabsent nonabsence voulue du passif ; CharScriptsvides, ProwlBrushHuntHuntedHuntingScent/persistance noncallbacks/respawn. Quatre nomsCougar8identités mêmesSHA déclarésparpaire sansprioritéruntime ; casseparticulesconservée. CommunityQprojectilecommenté_WPounceNonTrappe_Rtoggle999999NonConversion. DeuxcaspublicsbaseBoots25 :335/360 constants,8walks280pas272pleins158grass76towardVisible82away54refus244wait2QAnnie80/60_4setups_sansinjection. BrushTriggerExercé=>ownSpellRefusalnonexplicationSuffisante ; HuntCougarNonExercés ; offsets59/60/61nonâgebuffactif ni expiry. NavigationFiniteHeightFlagsNotPassable_pasopenByte ; genericSpeedShopModifiersCaps220415490historicalfalse_Statsmêmeproducer_VisionLOSSharedSnapshotAtomic acquis distincts nonHuntReveal. PropreOLU2434_SOURCEOLU1ccc propriétairesconservés44correctionspositivesnonenregistrées ; tâchecomplètefonctionnalitégoalouverts_SOURCEHUDVFXnonreclos. ProchainNocturne54hors68nommés_noncompteglobal. Aucun nouveau runtime/build/REA/natif/install/migration/changement goalPlanUIBasesRegistresProduit ; V564/NamiFailures/BattleTraining nonrequalifiés.
