# SYS-01.2-02 — ITEM-3098-SCOPE : Frostfang

Vérification du 2026-11-03. Sous-lot limité à la source native, à la référence 4.20.1 et au consumer boutique actuel. ITEM-3098-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier le reçu natif à la référence de version, établir le refus local, puis distinguer tout résultat lexical ressemblant à un handler de l’objet réellement ciblé.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3098.inibin : 651 octets, SHA-256 44ace9f9e0499ed170be51c12460ce491d50de526285fb6a795bf8185cc24c57, MD5 a924c3ab2d45e1338d3d48f636d8870a. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve antérieure réutilisée sans rehash; la précédence runtime n’est pas qualifiée.

Valeurs natives consignées : Price=500, SellBackModifier=0.4, InStore=1, CanBeSold=1, UseEffect=0, ItemGroup=GoldBase, RecipeItem1=3303, SpellName=AtmasImpalerDummySpell.

La référence officielle Data Dragon 4.20.1 en_US nomme Frostfang : base 500, total 865, vente 346, recette 3303, +10 AP, +50 % régénération de base du mana et +2 or par 10 secondes. Son passif Tribute donne des dégâts et de l’or sur sorts/attaques contre champions ou bâtiments, avec limite de trois déclenchements par 30 secondes; tuer un sbire désactive le passif 12 secondes. La description pose une limite d’un objet Gold Income. Aucun champ maps n’est présent; la source 4.20.1 ne décide pas la disponibilité historique Map10 du client 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun et omettent 3098. crates/core/src/shop.rs recherche d’abord une définition d’objet; quote_with_counts et buy_item renvoient item behavior not implemented avant la garde Map10. Sans règle d’admission, une définition ajoutée seule produirait ensuite item map availability not qualified.

La recherche exacte Frostfang, GoldBase, AtmasImpalerDummySpell et Tribute ne trouve aucun handler Frostfang/objet. L’unique résultat pour le mot Tribute est crates/core/src/trundle_passive.rs, qui documente King's Tribute, le passif de Trundle; il n’est relié ni à l’ID 3098 ni à Frostfang. Les structures/données de la boutique actuelle ne consomment pas SpellName natif. Un dispatch générique ou calculé n’est pas exclu par cette recherche.

Résultat nominal de référence si intégration autorisée : achat à 500 avec composant 3303, sous réserve des règles Gold Income et d’admission Map10. Résultat observé statiquement : refus item behavior not implemented. Aucun achat ou test direct 3098 n’a été exécuté; Tribute n’est ni exécuté ni déclaré implémenté par ce constat.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. La feature Frostfang, son passif Tribute et la limite Gold Income ne sont pas déclarés terminés.

ITEM-3098-SCOPE reste a_qualifier : disponibilité historique Map10 du client exact 4.20.0.315 non décidée; Data Dragon 4.20.1 ne fournit pas maps. Le SpellName natif ne relie pas au passif Tribute. Reprise uniquement sur une source native Map10/merchant du build exact ou une observation reproductible; pour l’effet, sur un callsite/item-dispatch autoritatif et identifié. Ne pas refaire les hashes ou la recherche lexicale sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
