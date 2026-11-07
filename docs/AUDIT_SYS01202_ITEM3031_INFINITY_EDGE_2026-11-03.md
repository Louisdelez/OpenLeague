# SYS-01.2-02 — ITEM-3031-SCOPE : Infinity Edge, source et consumer

Vérification du 2026-11-03, périmètre limité à la source native 3031, à sa restriction Map10 dans le catalogue distinct 4.20.1 et au consumer shop actuel. Tâche ITEM-3031-SCOPE : a_qualifier, implementation_complete=false, acceptance_complete=false. Aucun statut n’est modifié.

## Critère de fin du sous-lot

Identifier la source native datée et son membership, relever la restriction Map10 du catalogue officiel 4.20.1, et relier le refus courant au consumer réel. Garder séparée l’évidence 4.20.1 et la disponibilité historique du client 4.20.0.315.

## Sources vérifiées

- Source native OLS-408c443e-3b1e-5fa8-a6f6-354e7f2f2ff7 : RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3031.inibin, client PUBLIC 4.20.0.315, 508 octets, SHA-256 f227fddb300de7b30d07aff1638e8dc428fef6e6ccfe2f08703d7784a0b8f9c3. Rehash actuel concordant. Le registre RadS confirme membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.239, MD5 35e3b23ce2bbf0c84456c1bb72f8a0a6.
- Valeurs natives décodées : Price=645, InStore=true, CanBeSold=true, FlatPhysicalDamageMod=80, FlatCritChanceMod=0.25, RecipeItem1=1038, RecipeItem2=1037, RecipeItem3=1018. Aucun indicateur Map10 ne figure dans les champs décodés.
- Source officielle distincte OLS-b3343643-2fe6-513b-b286-7c03b86b8409 : Data Dragon 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. L’entrée /data/3031 indique base 645, total 3800, vente 2660, composants 1038+1037+1018, 80 dégâts physiques et 25 % de critique; elle porte explicitement maps[10]=false. Source : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Ce champ est propre au catalogue 4.20.1 et n’est pas retrouvé dans l’INIBIN décodé du build 4.20.0.315.

## Consumer et résultat courant

Le consumer Rust charge data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json via crates/core/src/shop.rs. Ces tables contiennent 33 entrées chacune et aucun ID 3031. La fiche éventuelle dans items.ron est une référence non chargée par le code Rust des crates.

quote_with_counts et buy_item cherchent d’abord la définition de l’objet. Le résultat statique attendu pour 3031 est donc item behavior not implemented, avant le contrôle Map10. Si une définition était ajoutée sans admission, map10_available retournerait None et produirait item map availability not qualified. L’identité de shop.rs et des tables est réutilisée depuis V1048; hashes inchangés. Aucun test direct 3031 ni test générique supplémentaire n’a été exécuté.

Aucun achat nominal 3031 n’est possible dans le consumer actuel. La restriction Map10=false du catalogue 4.20.1 est connue, mais le refus courant est générique et n’apporte pas cette règle au runtime OpenLeague.

## Résultat et limites

Clôturé pour ce sous-lot : source native et membership identifiés, restriction Map10 du catalogue 4.20.1 relevée, consumer réel et refus courant reliés.

Reste ouvert pour ITEM-3031-SCOPE : disponibilité historique Map10 du client 4.20.0.315 non démontrée par l’INIBIN décodé; définition et admission locales absentes; feature d’achat non intégrée. Reprise avec une source native merchant/Map10 ou une preuve serveur/historique du build exact. Pour une future feature, ajouter explicitement l’item avec une règle Map10=false issue d’une source retenue et vérifier directement 3031. Aucun code, registre JSON, statut, goal, Plan, application ou base n’a été modifié; aucun test, build, runtime, installation ou migration n’a été effectué dans ce lot.