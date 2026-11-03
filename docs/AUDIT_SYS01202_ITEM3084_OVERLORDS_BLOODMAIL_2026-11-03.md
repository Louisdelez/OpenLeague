# SYS-01.2-02 — ITEM-3084-SCOPE : Overlord's Bloodmail

Vérification du 2026-11-03. Lot limité à la source native d’item, au catalogue de comparaison 4.20.1, et au consumer de boutique actuellement chargé. La tâche reste a_qualifier; aucun statut n’est modifié.

## Critère de fin du sous-lot

Relier une source native identifiée et son membership au contrat versionné, puis au résultat actuel du consumer. Distinguer le refus produit par OpenLeague de la disponibilité historique Map10 du client 4.20.0.315.

## Source et contrat versionnés

Le reçu existant docs/reference_item_shop_sources/item_shop-links.json associe DATA/Items/3084.inibin au client fourni : 502 octets, SHA-256 46ab45a4e334125e323ae2b1a164231a30799611b293f5f015e6bc02e1e2f8b8, MD5 183ca51b7915ae1f753042d5137d2a79. Il indique membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.239. Cette preuve antérieure a été réutilisée; aucun rehash du binaire n’a été exécuté dans ce lot. Le reçu précise aussi que la précédence runtime des ressources n’est pas qualifiée.

Valeurs boutique consignées pour le natif : Price=1055, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1011, RecipeItem2=1028. InStore=1 indique une entrée de boutique native; ce champ seul n’établit pas son admission sur Map10.

La référence distincte Data Dragon 4.20.1 en_US est docs/reference_item_shop_sources/item_shop-links.json → facts.official_source : item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. Le contexte local ITEM-3084-SCOPE donne Overlord's Bloodmail, base 1055, total 2455, vente 1719, purchasable=true, recette 1011+1028 et +850 Health. L’objet officiel décrit aussi un passif restaurant 200 PV sur 5 secondes après élimination ou assistance. Son objet maps porte 1=false et 12=false; aucune valeur 10 n’est fournie. La référence 4.20.1 ne décide donc pas l’inclusion historique sur Map10 en 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json

## Consumer actuel et résultat attendu / observé

Le code Rust charge data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json. Leur contenu courant comporte 33 entrées chacun; aucun des deux n’a l’ID 3084. crates/core/src/shop.rs:85-86 résout d’abord la définition par ID et renvoie item behavior not implemented si elle manque. buy_item suit le même ordre à shop.rs:261-268 : la recherche de définition précède la garde Map10. Ces constatations viennent de la lecture du code et des données courantes; aucun achat simulé ou test direct n’a été exécuté.

Résultat nominal de référence, si une implémentation autorisée était ajoutée : définition de l’objet au prix 1055 avec recette 1011+1028, sous réserve d’une décision de carte. Résultat observé dans le consumer actuel : achat 3084 refusé statiquement avec item behavior not implemented. Si une définition était ajoutée sans admission Map10, map10_available(3084) renverrait None et buy_item refuserait avec item map availability not qualified. Ce refus local est un manque d’intégration et ne prouve aucune interdiction historique.

## Résultat et limites

Clôturé pour ce sous-lot d’audit statique : la source native, sa membership consignée, les données distinctes 4.20.1 et le chemin de refus du consumer courant sont reliés. Aucune fonctionnalité 3084 n’est déclarée terminée.

ITEM-3084-SCOPE reste a_qualifier : l’admission historique Map10 du client 4.20.0.315 n’est pas décidée. La restriction Data Dragon 4.20.1 sur les cartes 1 et 12, l’absence de clé 10, et InStore=1 ne suffisent pas. Reprise uniquement sur une table ou configuration Map10 native attribuable au build exact, ou une observation reproductible du client 4.20.0.315. Pour toute future intégration, vérifier séparément la définition, l’admission Map10, la recette, le passif, et un test direct 3084 après autorisation d’implémentation.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
