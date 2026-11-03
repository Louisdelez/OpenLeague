# SYS-01.2-02 — ITEM-3025-SCOPE : Iceborn Gauntlet, absence locale et refus

Vérification du 2026-11-02. Lot limité à qualifier la source native enregistrée, constater l’absence dans le catalogue local et suivre le refus du consumer courant. Aucun code, statut, goal, registre de tâche/trace, Plan, interface ou base de suivi n’est modifié.

## Critère de fin du lot

Relever l’identité de la source versionnée, confirmer si l’objet est présent dans les entrées réellement chargées par OpenLeague, relier l’absence au consumer réel et vérifier le refus local applicable. Ne pas assimiler le refus local à une décision historique du jeu.

## Exigence et sources

- Tâche ITEM-3025-SCOPE, D07, titre « Objet 3025 — Iceborn Gauntlet : Qualifier version, cartes, restrictions, prix et recettes ». État conservé : a_qualifier; implementation_complete=false; acceptance_complete=false.
- Exigence de sous-trace OLF-52991b5c-5b6c-5ddc-9f23-bc7f57948b47. Trace parent SYS-01.2-02 : source native OLS-21244ad2-0dbb-52fb-9f06-b1ac63db4d59, catalogue officiel 4.20.1 OLS-b3343643-2fe6-513b-b286-7c03b86b8409, lookup local de l’item absent (sélecteur items.id=3025, selector_exists=false), consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b. Sous-trace : associated_sources_and_current_entrypoints; unknown_ids=[].
- Source native : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\3025.inibin. Enregistrement : client 4.20.0.315, 546 octets, SHA-256 bf423e8721edd30eddbc6e1e0d0d611c107cbcccc3512059315a02c16aae2956. Rehash effectué : concordant. Membership enregistré : projet lol_game_client contenu 0.0.1.7, membre release 0.0.0.243, MD5 153e57064cd754d80ee2c2f8c6cfb02c.
- Le décodage existant data/4.20/native_item_audit.json indique Price=750, InStore=true, CanBeSold=true, FlatArmorMod=60, FlatMPPoolMod=500, RecipeItem1=3057, RecipeItem2=3024 et InventoryIcon=3025_Frozen_Fist.dds. SHA-256 courant de ce rapport de décodage : 8490946392B459466DDC396FF681107CA4043406FD2780F41D63BD97C5D25E03. InStore=true n’établit pas à lui seul la disponibilité sur Map10.
- La sous-trace pointe vers l’entrée catalogue officielle /data/3025 de la source OLS-b3343643. L’identité de cette source est enregistrée comme Data Dragon 4.20.1; son fichier brut n’a pas été réouvert dans ce lot.

## Absence et consumer courant

L’item 3025 est absent de data/4.20/shop_foundation.json et de data/4.20/map10_shop_admission.json. Empreintes courantes : shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485.

Le consumer enregistré OLC-77cae4b8 est crates/core/src/shop.rs, ligne 86 : quote_with_counts cherche l’objet dans le catalogue, puis retourne « item behavior not implemented » si absent. Le même lookup est exécuté dans buy_item à la ligne 263, avant le contrôle Map10 à la ligne 267; l’objet absent ne parvient donc pas au contrôle d’admission de carte. Empreinte courante de shop.rs : 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0. La donnée locale détermine un refus d’implémentation; elle ne prouve pas une interdiction historique de l’objet sur Map10.

## Vérification exécutée

Binaire préexistant : target/debug/deps/openleague_core-21eb81eb13817108.exe, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Aucun build ni Cargo exécuté.

Test direct exécuté :
target/debug/deps/openleague_core-21eb81eb13817108.exe shop::tests::enemy_shop_dead_unknown_and_ended_guards_prevent_mutation --exact --nocapture

Résultat : 1 test réussi, 0 échec. Le test soumet l’ID inconnu 1057 à buy_item, vérifie le refus « not implemented » et confirme que l’or ne change pas après les refus testés. Il valide le chemin générique de refus, mais ne soumet pas directement l’ID 3025.

Résultat attendu pour 3025 d’après la donnée courante et le code : refus explicite « item behavior not implemented » avant le contrôle Map10. C’est une inférence déterministe du lookup absent et de l’ordre des gardes; aucun test/runtime direct avec l’ID 3025 n’a été exécuté. Le refus pour un item inconnu est vérifié par le test 1057.

## Résultat et reprise

Clôturé dans ce lot : source 3025 identifiée, re-hashée et membre du manifeste RADS enregistré; absence locale vérifiée; consumer réel de refus localisé; test générique de refus exécuté.

Restent ouverts :

1. La ligne officielle 4.20.1 /data/3025 et les règles de carte historiques doivent être lues depuis la source versionnée pour établir le prix, la recette et la disponibilité Map10. L’INIBIN et InStore=true ne suffisent pas à décider ce point.
2. Le chemin local ne peut ni acheter ni appliquer les stats ou passifs du 3025 tant qu’il n’existe pas dans shop_foundation et que les règles Map10 correspondantes ne sont pas qualifiées. Les effets du passif n’ont pas été inventés.
3. Un test ciblé utilisant directement 3025 doit confirmer le refus exact et l’absence de mutation; le test exécuté n’utilise que 1057.
4. Aucun serveur original, comparaison de partie ou acceptation humaine n’a été vérifié.

Condition de reprise : ouvrir l’entrée officielle 4.20.1 /data/3025 déjà liée dans la trace; décider séparément les valeurs et restrictions historiques, puis écrire un test exact pour 3025. Ne pas répéter le rehash natif ni le test générique tant que les empreintes sont inchangées.
## Erratum V1047 — Data Dragon 4.20.1 et consumer shop courant — 2026-11-03

La source officielle liée OLS-b3343643-2fe6-513b-b286-7c03b86b8409 a été relue localement : E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json, version 4.20.1, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1, URL officielle https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. L’entrée 3025 indique Iceborn Gauntlet, base 750, total 2900, vente 2030, composants 3057 et 3024, profondeur 3, stats +500 mana/+60 armure/+30 AP. Le record 3025 ne contient pas de champ maps; le défaut basic.maps de ce catalogue indique 10=true. Cela reste une donnée catalogue 4.20.1, distincte de la référence client 4.20.0.315.

La source native 3025.inibin déjà rehashée et enregistrée demeure celle du client 4.20.0.315, membre lol_game_client/0.0.0.243. Ses champs décodés indiquent Price=750, InStore=true, CanBeSold=true, RecipeItem1=3057 et RecipeItem2=3024; aucun indicateur Map10 n’est présent dans ces champs décodés. Le catalogue Data Dragon 4.20.1 et InStore=true ne décident donc pas seuls la disponibilité historique du build 4.20.0.315.

Vérification du consumer courant : items.ron contient une fiche 3025 de référence, mais aucun consommateur Rust dans crates ne la référence. shop.rs charge réellement shop_foundation.json et map10_shop_admission.json; chacun contient 33 entrées et aucun ID 3025. quote_with_counts et buy_item cherchent d’abord item(3025); l’absence rend le refus déterministe item behavior not implemented avant le contrôle Map10. Le code actuel ne peut donc pas acheter/apply les stats ou le passif de 3025. Le test générique de refus 1057 déjà consigné n’a pas été relancé et aucun test direct 3025 n’a été exécuté.

Clôture de ce sous-audit : sources 4.20.0.315 et 4.20.1 séparées, prix/recette catalogués, absence du Map10 natif qualifiée comme inconnue, et chemin de refus du consumer réel établi. ITEM-3025-SCOPE reste a_qualifier : la feature est absente et l’acceptation n’est pas donnée. Conditions de reprise : obtenir une source native Map10/merchant pour le build exact ou une preuve serveur/historique; pour un futur travail de feature, intégrer explicitement l’item et ses règles puis exécuter un test direct 3025. Ne pas répéter le rehash, le test générique ni la recherche de l’entrée Data Dragon.

Aucun code, registre JSON, statut de tâche, goal, Plan, application ou base de données modifié; aucun test, build, runtime ou installation exécuté dans ce lot. Source officielle 4.20.1 consultée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json.