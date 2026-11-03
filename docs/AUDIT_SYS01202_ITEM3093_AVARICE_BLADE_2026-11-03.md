# SYS-01.2-02 — ITEM-3093-SCOPE : Avarice Blade

Vérification du 2026-11-03. Sous-lot limité à la source native item, à la référence 4.20.1 et au consumer actuel de boutique. ITEM-3093-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier la preuve native/versionnée au chemin d’achat et documenter la réponse statique du consumer; isoler les incertitudes de carte et de passifs.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3093.inibin : 604 octets, SHA-256 97da372ffc208c1796e66adb68f28f48030a3c3bf549acc5e78a833ea36355bb, MD5 17cf34dae77893f8c9045335c6ac23a2. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.243. Preuve antérieure réutilisée sans rehash; la précédence runtime n’est pas qualifiée.

Valeurs natives boutique consignées : Price=400, SellBackModifier=0.4, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1051, SpellName=ArchAngelsDummySpell.

La référence Data Dragon officielle 4.20.1 en_US décrit Avarice Blade : base 400, total 800, vente 320, recette 1051, +10 % critique, +3 or toutes les 10 secondes et +2 or par unité tuée. Elle indique que l’objet peut être acheté avec un autre objet Gold Income. Aucun champ maps n’est présent. La référence catalogue ne décide pas l’admission Map10 historique en 4.20.0.315. Le SpellName natif ArchAngelsDummySpell ne correspond pas textuellement aux passifs Avarice/Greed; ce lien n’est pas interprété comme leur implémentation.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun; aucun ne contient 3093. crates/core/src/shop.rs résout d’abord la définition d’objet; quote_with_counts et buy_item renvoient item behavior not implemented lorsque l’ID manque, avant la garde Map10. L’ordre partagé du consumer est réutilisé de V1048/V1053; l’absence de l’ID a été vérifiée sur les tables courantes.

Une recherche ciblée de ArchAngelsDummySpell, Avarice Blade, Avarice, Greed et des chaînes de revenu d’or dans crates/core/src ne trouve aucun handler textuel. Cela n’exclut pas un dispatch générique ou une clé calculée. Le chemin shop courant ne charge pas le SpellName natif.

Résultat nominal de référence si intégration autorisée : achat à 400 avec composant 1051, sous réserve de l’admission de carte et de règles Gold Income. Résultat observé statiquement : refus item behavior not implemented. Aucun achat ni test direct 3093 n’a été exécuté; les passifs ne sont ni testés ni déclarés implémentés.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. La feature 3093 n’est pas déclarée terminée.

ITEM-3093-SCOPE reste a_qualifier : la disponibilité Map10 du client exact 4.20.0.315 n’est pas décidée; la référence 4.20.1 n’a pas de champ maps. Le SpellName natif et les passifs Avarice/Greed restent non reliés au code actuel. Reprise uniquement sur une source Map10/merchant native du build exact ou une observation reproductible; pour le passif, sur un mapping/dispatch natif ou serveur qualifié. Ne pas refaire les hashes ou la recherche lexicale sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
