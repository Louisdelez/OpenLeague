# SYS-01.2-02 — ITEM-3096-SCOPE : Nomad's Medallion

Vérification du 2026-11-03. Sous-lot limité à la source native, à la référence catalogue 4.20.1 et au consumer actuel de boutique. ITEM-3096-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier les valeurs natives enregistrées à leur référence de version et au consumer réellement chargé; documenter le refus, le groupe économique et les limites de portée.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3096.inibin : 660 octets, SHA-256 17803752e44d32422d467f1b8da4cc5aaea661c8a230cf443a8e09efca7b92e2, MD5 36a2aec981a0a9de49d25b1ea4cfbe1c. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve antérieure réutilisée sans rehash; précédence runtime non qualifiée.

Valeurs natives boutique consignées : Price=500, SellBackModifier=0.4, InStore=1, CanBeSold=1, UseEffect=0, ItemGroup=GoldBase, RecipeItem1=3301, SpellName=AtmasImpalerDummySpell.

Data Dragon officiel 4.20.1 en_US décrit Nomad's Medallion : base 500, total 865, vente 346, recette 3301, régénération de base PV et mana +25 %, +10 vitesse de déplacement, +2 or par 10 secondes, passif Favor (+3 or et +5 PV en proximité d’un sbire tué sans l’avoir achevé), avec une limite d’un item Gold Income. Aucun champ maps n’est fourni. Cette donnée catalogue distincte ne décide pas l’admission historique Map10 du client 4.20.0.315. La différence entre AtmasImpalerDummySpell natif et le passif Favor officiel n’est pas résolue.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun; aucun ne contient 3096. Le code crates/core/src/shop.rs recherche la définition avant l’admission Map10; quote_with_counts et buy_item renvoient item behavior not implemented si elle manque. Sans règle d’admission, une définition ajoutée seule serait ensuite refusée avec item map availability not qualified.

La recherche textuelle de Nomad's Medallion, GoldBase, AtmasImpalerDummySpell et Favor dans crates/core/src n’a trouvé aucun handler nommé. Le consumer générique, le groupe et une éventuelle association calculée ne sont pas évalués par ce résultat lexical.

Résultat nominal de référence si intégration autorisée : achat au prix 500 avec composant 3301, sous réserve d’une décision de carte et des règles de groupe GoldBase. Résultat observé statiquement : refus item behavior not implemented. Aucun achat ni test direct 3096 n’a été exécuté; le passif de soutien n’est pas consommé ou vérifié par ce chemin.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. La fonctionnalité Nomad's Medallion, son passif Favor et l’unicité GoldBase ne sont pas déclarés terminés.

ITEM-3096-SCOPE reste a_qualifier : ni InStore=1 ni Data Dragon 4.20.1 sans champ maps ne démontrent l’admission historique Map10 en 4.20.0.315. Le SpellName natif ne qualifie pas Favor. Reprise seulement sur source native Map10/merchant du build exact ou observation reproductible; pour l’effet/groupe, sur un callsite de gameplay ou une règle autoritative déjà disponible. Ne pas refaire les hashes ni la recherche lexicale ciblée sans indice nouveau.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
