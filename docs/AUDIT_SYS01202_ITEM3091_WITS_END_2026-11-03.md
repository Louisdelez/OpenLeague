# SYS-01.2-02 — ITEM-3091-SCOPE : Wit's End

Vérification du 2026-11-03. Sous-lot limité à la source native item, au contrat officiel 4.20.1 et au consumer boutique actuel. ITEM-3091-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier le reçu natif et sa membership à la référence versionnée et au résultat du consumer actuel, sans conclure à une disponibilité Map10 historique faute de source exacte.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3091.inibin : 545 octets, SHA-256 62c74495e7eff4901842781e1a297d999f4d5ffef317ca47bacd55b3e86e4366, MD5 d3e2f886e0f15ceba9335651678d452a. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve antérieure réutilisée sans rehash; la précédence runtime n’est pas qualifiée.

Valeurs natives boutique consignées : Price=750, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1043, RecipeItem2=1033, RecipeItem3=1042. Aucun de ces champs ne décide Map10.

L’entrée de tâche référence Data Dragon officiel 4.20.1 en_US : Wit's End, base 750, total 2600, vente 1820, purchasable=true, recette 1043+1033+1042, +50 % vitesse d’attaque, +30 résistance magique et passifs de dégâts magiques/vol de résistance magique à l’impact. L’entrée n’a pas de champ maps; elle ne décide pas l’admission historique sur Map10 du client PUBLIC 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json contiennent 33 entrées chacun; aucun ne contient 3091. crates/core/src/shop.rs cherche d’abord la définition de l’objet. quote_with_counts et buy_item renvoient item behavior not implemented si elle manque, avant la décision Map10. Le consumer et l’ordre sont réutilisés depuis V1048/V1053; l’absence de l’ID est vérifiée sur le contenu actuel des deux tables.

Résultat nominal de référence si l’intégration est autorisée : prix 750 et recette 1043+1033+1042, avec les effets à qualifier séparément. Résultat observé par lecture statique : achat refusé avec item behavior not implemented. Sans entrée d’admission Map10, une définition ajoutée seule serait ensuite refusée avec item map availability not qualified. Aucun achat ni test direct 3091 n’a été exécuté; ce n’est pas un résultat runtime.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. Le passif d’impact et la feature Wit's End ne sont pas déclarés terminés.

ITEM-3091-SCOPE reste a_qualifier : InStore=1 et Data Dragon 4.20.1 sans champ maps ne démontrent pas l’admission historique Map10 de 4.20.0.315. Reprise uniquement sur une source Map10/merchant native attribuable au build exact ou une observation reproductible de ce client. Ne pas refaire les hashes ni le refus générique.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
