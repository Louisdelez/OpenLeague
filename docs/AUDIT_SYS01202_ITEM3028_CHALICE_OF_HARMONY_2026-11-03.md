# SYS-01.2-02 — ITEM-3028-SCOPE : Chalice of Harmony, source et consumer

Vérification du 2026-11-03, périmètre limité à la source native 3028, au catalogue distinct 4.20.1 et au consumer shop actuel. Tâche ITEM-3028-SCOPE : a_qualifier, implementation_complete=false, acceptance_complete=false. Aucun statut n’est modifié.

## Critère de fin du sous-lot

Identifier la source native datée et son membership, comparer prix/recette/carte avec Data Dragon 4.20.1 en conservant la différence de versions, et relier l’absence locale au consumer réel. Ne pas décider la disponibilité historique 4.20.0.315 à partir du seul catalogue 4.20.1.

## Sources vérifiées

- Source native OLS-cbd2e883-96b1-57cc-855a-22bc586c57f2 : RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3028.inibin, client PUBLIC 4.20.0.315, 515 octets, SHA-256 47bc1a71eb0d206b67383b9ad7d7cf10a0d9c3de0e2e73a3f428ca69f9454317. Rehash actuel concordant. Le registre RadS indique membership matches_selected_project_manifest dans lol_game_client 0.0.1.7; MD5 d385eab2280605634f43b72c1c127b56.
- Valeurs natives décodées : Price=140, InStore=true, CanBeSold=true, FlatSpellBlockMod=25, PercentBaseMPRegenMod=0.5, RecipeItem1=1004, RecipeItem2=1033, RecipeItem3=1004.
- Source officielle distincte OLS-b3343643-2fe6-513b-b286-7c03b86b8409 : Data Dragon 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. L’entrée /data/3028 indique base 140, total 1000, vente 700, composants 1004+1033+1004, builds into 3174 et 3222, profondeur 2, résistance magique 25. Le record individuel n’a pas de champ maps; le défaut basic.maps du catalogue indique 10=true. Source : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Cette valeur catalogue est distincte de la référence native 4.20.0.315.

## Consumer et résultat courant

Le consumer Rust utilise data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json via crates/core/src/shop.rs. Ces fichiers ont 33 entrées et aucun ID 3028. data/4.20/items.ron contient une fiche de référence, mais aucun code Rust dans crates ne référence items.ron; cette fiche n’alimente pas le shop actuel.

quote_with_counts et buy_item cherchent la définition avant le contrôle carte. Pour un achat 3028, le résultat statique attendu est le refus item behavior not implemented. Si une définition était ajoutée sans règle d’admission, map10_available retournerait None et buy_item refuserait item map availability not qualified. L’identité de shop.rs, shop_foundation.json et map10_shop_admission.json est réutilisée depuis V1048, hashes inchangés. Aucun test générique n’a été rejoué et aucun test direct 3028 n’a été exécuté.

Aucun cas nominal d’achat 3028 n’existe dans le consumer actuel. L’observation directe du code et l’absence exacte dans les deux tables déterminent le refus attendu, mais ne constituent pas une exécution runtime.

## Résultat et limites

Clôturé pour ce sous-lot : source native et membership identifiés, prix/recette liés au catalogue officiel 4.20.1, consumer réel inspecté et refus courant déterminé statiquement.

Reste ouvert pour ITEM-3028-SCOPE : aucun indicateur de carte natif du client 4.20.0.315 n’est présent dans les champs décodés; le catalogue 4.20.1 fournit un défaut positif sans override propre à 3028; la définition shop et l’admission locale manquent. Reprise avec une source native de liste merchant/Map10 du build exact ou une preuve historique/serveur. Pour une future feature, intégrer la définition et les règles d’admission puis vérifier directement 3028. Aucun code, registre JSON, statut, goal, Plan, application ou base n’a été modifié; aucun test, build, runtime, installation ou migration n’a été effectué dans ce lot.