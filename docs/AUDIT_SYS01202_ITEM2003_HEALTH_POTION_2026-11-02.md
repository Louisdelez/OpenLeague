# SYS-01.2-02 — objet 2003 : potion de soin, source et consumer actuel

Lot V856. Critère de fin du lot : confirmer l’identité de la source item 2003 et son membership, retrouver la référence de l’effet, suivre le code courant d’achat/usage/tick, exécuter les cas nominaux/refus existants et signaler ce qui reste non qualifié. Ce lot ne clôt pas ITEM-2003-SCOPE ni l’exigence parent.

## État courant et contrat de référence

Exigence parent OLF-3a11ace9-485c-55ae-8dff-2533902a5839; sous-exigence ITEM-2003-SCOPE, OLF-c949d80e-c89f-50ed-83dc-a6645314545c. La trace courante associe une entrée native (item 2003), les références au catalogue 4.20.1, à la donnée locale et au reçu de membership, puis le consumer OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 (lookup de catalogue). État de trace : associated_sources_and_current_entrypoints, aucun unknown_id. Dans le registre des tâches, ITEM-2003-SCOPE reste partiel_a_terminer, implementation_complete=false, acceptance_complete=false.

L’entrée officielle 4.20.1 intégrée dans le contexte de la tâche décrit Health Potion : 150 Health sur 15 secondes, prix 35, vente 14, pile maximale 5. Ce contexte est le référentiel catalogue daté; il ne constitue pas une valeur encodée dans l’INIBIN de l’objet ni une preuve du serveur EUW exécuté.

## Sources et provenances

La source item native OLS-60c40120-0caa-524d-949f-a67b04c48944 est DATA/Items/2003.inibin du client PUBLIC 4.20.0.315 : 525 octets, SHA-256 a78328ea459393cb74caf367bc2bbe305f43acd97b89712ff121552c589dc737. Le fichier D: a été rehaché dans ce lot et concorde. Le manifeste sélectionné la place dans lol_game_client, projet 0.0.1.7, membre 0.0.1.7, MD5 fc327fc4277543eec39f47a2079a36c5. L’extraction native existante data/4.20/native_item_audit.json:1050-1070 confirme Price=35, InStore=true, CanBeSold=true, SellBackModifier=0.4, MaxStack=5, UseEffect=true, SpellName=RegenerationPotion et ItemGroup=HealthPotion. Elle n’attribue pas 150/15 à ces champs item.

La référence 4.20.1 enregistrée est OLS-b3343643-2fe6-513b-b286-7c03b86b8409, sélecteur /data/2003. La donnée F: data/4.20/shop_foundation.json:782-797 reprend consumable.kind=Health, amount=150, duration_seconds=15, max_stack=5 et la même empreinte native item. L’admission Map10 est true (map10_shop_admission.json:129-130).

Piste native du sort révélée par le SpellName : DATA/Spells/RegenerationPotion.inibin, source OLS-d3a5579b-d4cd-540b-945e-d7be883ef4d8, 870 octets, SHA-256 46d3bee4e396a9bdb2c48c065b265ff1b1b9f02b5eb52e0aff0befd070154ec4; et RegenerationPotion.luaobj, OLS-5161de14-b754-5da6-a1a1-cfda785467c5, 296 octets, SHA-256 c82708ca2f5136444f8d243b2cd6833a09e6744be6629bdad205997e1985c578. Le premier appartient au membre RADS 0.0.0.107, le second au membre 0.0.0.254. Les deux sources figurent dans le registre global, mais ni elles ni le consumer de consommation ne sont reliés aux entrées native_inputs/current_consumers de cette sous-exigence ou de la trace parent. Elles n’ont pas été décodées/exécutées dans ce lot.

## Consumer courant

Le consumer enregistré OLC-b38bc16e-af3e-565e-8e4a-e8549549a702 pointe sur shop.rs:69, recherche l’ID dans shop_foundation. Le chemin d’usage réel découvert dans crates/core/src/consumables.rs n’est pas référencé par cette sous-trace :
- ligne 8, use_item résout l’emplacement et la donnée catalogue, refuse les ressources pleines, les mauvais états et les actifs non pris en charge;
- lignes 14-20, un effet Health est associé localement au nom RegenerationPotion, sa durée est convertie en ticks, une unité est retirée après validation et health_potion_ticks est augmenté;
- ligne 25, advance_consumables applique amount / duration / TICK_RATE à chaque tick, borne la santé au maximum et applique healing::received_multiplier.

La relation observée est donc INIBIN item (existence/type d’actif/nom) + référence catalogue 4.20.1 (quantité et durée) → données locales F: → use_item et advance_consumables. Le code local reprend le nom de sort natif, mais sa sélection dépend de consumable.kind dans la donnée locale; il ne lit ni le INIBIN du sort ni le luaobj natif.

## Vérifications exécutées

Binaire existant target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Exécution directe, sans Cargo ni recompilation :
- consumables::tests::native_potion_totals_restore_over_exactly450_updates — réussi 1/1. Le test combine les IDs 2003 et 2004; après 450 mises à jour, santé +150 et mana +100, puis les deux files sont vides. Le +150 de santé confirme le comportement local de 2003 sur la durée catalogue.
- consumables::tests::queued_potions_extend_duration_without_multiplying_rate_and_have_cap — réussi 1/1. Cinq potions 2003 prolongent une seule cadence jusqu’à 2250 ticks; une sixième utilisation est refusée par « potion queue full », reste en inventaire et ne multiplie pas le tick de soin.
- consumables::tests::swap_one_unit_sale_and_use_preserve_correct_counts — réussi 1/1. Vente d’une unité et deux usages conservent le compte et produisent 900 ticks cumulés.
- consumables::tests::guards_full_pools_invalid_items_dead_and_finished_are_atomic — réussi 1/1. Refus santé pleine, héros mort, partie terminée, mauvais slot et effet actif non implémenté; la potion inutilisée reste comptée.

Résultat : 4 tests ciblés réussis, 0 échec. Empreintes courantes : consumables.rs 984EE7042FE5F1A82D15A80689F9022D9A4AFA3E7D6F92E16ADC3E37E340C6C6; shop.rs 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; native_item_audit.json 8490946392B459466DDC396FF681107CA4043406FD2780F41D63BD97C5D25E03; shop_foundation.json 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE; map10_shop_admission.json 6393E7C2A39ABED63B6F3DB36C265E94D5CE2FC5435E29C17CCF012F288AD485.

## Résultat, écarts et reprise

Résolu : identité et membership de l’INIBIN item, valeur d’activation et SpellName, référence 4.20.1 de 150/15, données locales, consumer d’usage/tick et contrôles nominaux/refus locaux. L’implémentation de potion est présente et les cas courants passent.

Écarts ouverts : le sous-trace ne relie pas les sources natives RegenerationPotion.inibin/luaobj ni consumables.rs; 150/15 reste établi par le catalogue 4.20.1, pas par une exécution/décodage de la ressource cliente ou du serveur exact; comportement historique, UI, réseau et acceptation humaine restent hors preuve. La correction des liens de registre n’est pas effectuée ici. Reprendre ces écarts avec une autorisation de modifier le registre et une preuve primaire du contenu natif du sort/serveur. Ne pas répéter le hash item ni les quatre tests si code/données/binaires restent identiques.

Aucun code, statut de tâche, registre de tâches/fidélité, goal Codex, application de suivi ou base de l’application n’a été modifié. Le seul JSON édité pour la reprise est le checkpoint local du projet, pas la base de suivi.
