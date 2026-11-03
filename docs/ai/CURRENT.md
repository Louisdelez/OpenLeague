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
