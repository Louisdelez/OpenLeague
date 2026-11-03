# SYS-01.2-02 — ITEM-3102-SCOPE : Banshee's Veil

Vérification du 2026-11-03. Sous-lot limité à la source native item, à la référence officielle 4.20.1 et aux consumers actuels boutique/bouclier. ITEM-3102-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier la source versionnée au consumer boutique et vérifier si le passif spell shield a un handler Banshee identifié; maintenir distincte la disponibilité historique Map10.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3102.inibin : 574 octets, SHA-256 b8d4c545f0f6a5f394098ccc7e38694b35f6417e9cb4b6489e5edf17f4a2377c, MD5 2a02f86a891033d80a0c31411033d30d. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Reçu réutilisé sans rehash; la précédence runtime n’est pas qualifiée.

Valeurs natives boutique consignées : Price=1150, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=3211, RecipeItem2=1028. Aucun champ Map10 n’est décodé dans ce reçu.

L’entrée officielle Data Dragon 4.20.1 en_US décrit Banshee's Veil : base 1150, total 2750, vente 1925, recette 3211+1028, +450 PV, +55 résistance magique, +100 % régénération de base des PV. Le passif bloque la prochaine capacité ennemie et se réinitialise après 40 secondes sans dégâts de champions ennemis. Aucun champ maps n’est présent dans l’entrée locale de référence; elle ne décide pas la disponibilité historique Map10 du client 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json contiennent 33 entrées chacun; aucun ne contient 3102. crates/core/src/shop.rs résout d’abord la définition d’objet et refuse l’ID absent avec item behavior not implemented avant la garde Map10. Sans règle d’admission, une définition ajoutée seule recevrait ensuite item map availability not qualified.

Une recherche ciblée de Banshee, spell shield et BansheeShield dans crates/core/src n’a identifié aucun handler Banshee. Le seul résultat est un commentaire dans annie_passive.rs:22 qui dit que les boucliers de sort restent non qualifiés; il ne prouve pas une mécanique générique opérationnelle ni un lien à l’item 3102. La structure Item de la boutique n’a pas de champ pour le passif.

Résultat nominal de référence si intégration autorisée : achat à 1150 avec composants 3211+1028, sous réserve de l’admission carte. Résultat statique observé : achat refusé par item behavior not implemented. Aucun achat direct ni test de bouclier 3102 n’a été exécuté.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer boutique. La feature Banshee's Veil et le passif spell shield ne sont pas déclarés terminés.

ITEM-3102-SCOPE reste a_qualifier : l’admission Map10 du client exact 4.20.0.315 n’est pas décidée; l’entrée 4.20.1 ne fournit pas de maps. Le commentaire sur les boucliers n’est pas une preuve de consumer. Reprise seulement sur une source native Map10/merchant du build exact ou une observation reproductible; pour l’effet, sur un callsite natif/serveur ou une preuve d’exécution contrôlée. Ne pas refaire les hashes ni la recherche lexicale ciblée sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
