# SYS-01.2-02 — ITEM-3027-SCOPE : Rod of Ages, source et consumer

Vérification du 2026-11-03, périmètre limité à la source native 3027, au catalogue distinct 4.20.1 et au consumer shop actuel. Tâche ITEM-3027-SCOPE : a_qualifier, implementation_complete=false, acceptance_complete=false. Aucun statut n’est modifié.

## Critère de fin du sous-lot

Identifier la source native datée et son membership, comparer prix/recette/carte avec Data Dragon 4.20.1 en préservant la différence de versions, et relier l’absence locale au consumer réel. Ne pas décider la disponibilité historique 4.20.0.315 à partir du catalogue 4.20.1 seul.

## Sources vérifiées

- Source native OLS-df6c167d-856c-55f1-8197-28eaf2ac115f : RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3027.inibin, client PUBLIC 4.20.0.315, 592 octets, SHA-256 3ffc11c63a4c76f0439b1614f394c89a155beea8953e70c23fed32e5372d2128. Rehash actuel concordant. Membership enregistré : lol_game_client 0.0.1.7, DATA/Items/3027.inibin, matches_selected_project_manifest, MD5 415ee8c213d262469572bd42c20bad9c.
- Valeurs natives décodées : Price=740, InStore=true, CanBeSold=true, RecipeItem1=3010, RecipeItem2=1026, FlatHPPoolMod=450, FlatMPPoolMod=450, SpellName=RodOfAgesDummySpell.
- Source officielle distincte OLS-b3343643-2fe6-513b-b286-7c03b86b8409 : Data Dragon 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. L’entrée /data/3027 donne Rod of Ages, base 740, total 2800, vente 1960, composants 3010+1026, profondeur 3, 450 PV, 450 mana, 60 AP. Le record individuel n’a pas de champ maps; le défaut basic.maps du catalogue indique 10=true. Source : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. L’absence d’override et le défaut Data Dragon ne constituent pas une preuve native de disponibilité du client 4.20.0.315.

## Consumer et résultat courant

Le consumer Rust utilise data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json via crates/core/src/shop.rs. Les deux fichiers ont 33 entrées et aucun ID 3027. La fiche présente dans data/4.20/items.ron est un artefact de référence non référencé par le code Rust des crates; elle n’alimente pas le shop courant.

quote_with_counts et buy_item cherchent la définition de l’objet avant la règle de carte. Pour une requête 3027, le résultat statique attendu est donc le refus item behavior not implemented. Si une définition était ajoutée sans règle d’admission, map10_available retournerait None et buy_item refuserait avec item map availability not qualified. Ce sont deux états distincts. L’identité des fichiers shop.rs, shop_foundation.json et map10_shop_admission.json est réutilisée depuis V1048, hashes inchangés; pas de rehash ni de test générique répété.

Aucun cas nominal d’achat 3027 n’est disponible dans le consumer actuel. Aucun test direct 3027 n’a été exécuté; l’issue générique de refus est déduite de l’absence exacte dans les données chargées et de l’ordre du code.

## Résultat et limites

Clôturé pour ce sous-lot : source native et membership identifiés, valeurs de prix/recette liées à Data Dragon 4.20.1, consumer shop réel inspecté, et refus courant déterminé statiquement.

Reste ouvert pour ITEM-3027-SCOPE : aucune preuve native Map10 de la version 4.20.0.315 n’est présente dans les champs décodés; le catalogue 4.20.1 fournit seulement un défaut positif sans override spécifique; l’entrée shop et l’admission locale manquent; le comportement du passif/croissance de Rod of Ages n’est pas intégré. Reprise avec une source native de liste merchant/Map10 du build exact ou une preuve serveur/historique. Pour la feature, ajouter séparément définition, règles d’admission et tests directs 3027 après autorisation de modifier le code. Aucun code, registre JSON, statut, goal, Plan, application ou base n’a été modifié; aucun test, build, runtime ou installation n’a été effectué dans ce lot.