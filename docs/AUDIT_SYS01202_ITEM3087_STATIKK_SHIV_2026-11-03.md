# SYS-01.2-02 — ITEM-3087-SCOPE : Statikk Shiv

Vérification du 2026-11-03. Sous-lot limité à la source native, à la référence officielle 4.20.1 et au consumer de boutique actuel. ITEM-3087-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier le reçu natif déjà existant et le contrat versionné aux consommateurs réellement chargés; distinguer le résultat local de la disponibilité historique Map10.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3087.inibin : 519 octets, SHA-256 a85fc143b0ece8179cad3a220559593003f9851fd0d839278e79ec3480b4ec7b, MD5 610296b2ede037e8c95426e543c87410. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.243. Cette preuve antérieure a été réutilisée sans rehash; la précédence runtime n’est pas qualifiée.

Valeurs natives boutique consignées : Price=600, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=3086 et RecipeItem2=3093. InStore=1 ne prouve pas la disponibilité sur Map10.

Le contexte de tâche reprend l’entrée Data Dragon officielle 4.20.1 en_US : Statikk Shiv, base 600, total 2500, vente 1750, purchasable=true, recette 3086+3093. Elle décrit +40 % vitesse d’attaque, +20 % critique, +6 % vitesse de déplacement et un passif de charges/éclairs. Elle ne contient pas de champ maps et ne tranche pas l’admission Map10 du client PUBLIC 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

Les fichiers réellement chargés sont data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json; ils comptent chacun 33 entrées et excluent 3087. crates/core/src/shop.rs cherche d’abord la définition d’objet. quote_with_counts et buy_item renvoient item behavior not implemented lorsque l’ID manque, avant la décision Map10. L’ordre du consumer partagé est réutilisé de V1048/V1053; l’absence de 3087 dans les deux tables a été vérifiée sur le contenu courant.

Résultat nominal de référence si intégration autorisée : prix 600 et composants 3086+3093, sous réserve d’une règle de carte qualifiée. Résultat observé statiquement pour le consumer actuel : achat 3087 refusé avec item behavior not implemented. Une future définition sans entrée d’admission serait ensuite refusée avec item map availability not qualified. Aucun test direct ou achat runtime 3087 n’a été exécuté.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer; le passif Statikk Shiv et la feature ne sont pas déclarés terminés.

ITEM-3087-SCOPE reste a_qualifier : le natif InStore=1 et la référence 4.20.1 sans champ maps ne prouvent pas la disponibilité historique sur Map10 en 4.20.0.315. Reprise uniquement sur une source native/merchant Map10 du build exact ou une observation reproductible du client de référence. Ne pas refaire le rehash ni le refus générique.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
