# SYS-01.2-02 — ITEM-3104-SCOPE : Lord Van Damm's Pillager

Vérification du 2026-11-03. Sous-lot limité à la source native item, à la référence officielle 4.20.1 et au consumer actuel de boutique. ITEM-3104-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier le reçu natif à la référence versionnée et au résultat de la boutique OpenLeague, sans déduire la disponibilité Map10 à partir des restrictions partielles du catalogue 4.20.1.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3104.inibin : 552 octets, SHA-256 aa3f1cf525c5ab7b346e6fd2847a15e75f2fe8c875f46c6fe8767fb5b599dc2e, MD5 96d596e01e9df1d26bcfeec298806bfb. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.242. Preuve antérieure réutilisée sans rehash; précédence runtime non qualifiée.

Valeurs natives de boutique consignées : Price=995, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=3122, RecipeItem2=1037, RecipeItem3=1018.

L’entrée officielle Data Dragon 4.20.1 en_US décrit Lord Van Damm's Pillager : base 995, total 3800, vente 2660, recette 3122+1037+1018, +80 dégâts physiques, +25 % critique; ses coups critiques infligent 250 % au lieu de 200 %. Son champ maps donne 1=false et 12=false, sans fournir une valeur 10. Ce catalogue ne décide pas l’admission historique Map10 du client PUBLIC 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json comptent 33 entrées chacun; 3104 est absent des deux listes. crates/core/src/shop.rs cherche d’abord une définition; quote_with_counts et buy_item renvoient item behavior not implemented avant le contrôle Map10. Une définition ajoutée sans règle d’admission serait ensuite refusée avec item map availability not qualified.

Résultat nominal de référence si intégration autorisée : achat à 995 avec composants 3122+1037+1018, sous réserve d’une décision de carte. Résultat observé statiquement dans le consumer actuel : refus item behavior not implemented. Aucun test ni achat direct 3104 n’a été exécuté. Le passif de dégâts critiques est hors de ce sous-lot de qualification et n’est pas déclaré implémenté.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer boutique. La feature 3104 et son passif ne sont pas déclarés terminés.

ITEM-3104-SCOPE reste a_qualifier : les restrictions 4.20.1 sur les cartes 1 et 12, sans champ 10, ne décident pas le statut historique Map10 du client 4.20.0.315. Reprise uniquement sur source Map10/merchant native du build exact ou observation reproductible de ce client. Ne pas refaire le rehash ni le contrôle du consumer partagé.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
