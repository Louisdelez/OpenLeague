# SYS-01.2-02 — ITEM-3092-SCOPE : Frost Queen's Claim

Vérification du 2026-11-03. Lot limité à la source native, à la référence catalogue 4.20.1 et aux consumers actuels de boutique/actif. ITEM-3092-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier les valeurs source déjà enregistrées à la référence versionnée, déterminer le refus actuel et vérifier le callsite nommé SpellName/Group dans le code sans supposer une implémentation.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3092.inibin : 622 octets, SHA-256 39363ba7e8f95b40754b5c0c92972364093375d8a25b52c1d009ef1d027e9f08, MD5 debd723ef0c12f483c7cc70fe697d25e. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve antérieure réutilisée sans rehash; la précédence runtime reste non qualifiée.

Valeurs natives consignées : Price=515, SellBackModifier=0.4, InStore=1, CanBeSold=1, UseEffect=1, SpellName=ItemGlacialSpikeCast, ItemGroup=GoldBase, RecipeItem1=3098 et RecipeItem2=3108.

Data Dragon officiel 4.20.1 en_US décrit Frost Queen's Claim : base 515, total 2200, vente 880, recette 3098+3108, +50 AP, +50 % régénération de mana de base, +10 % CDR et +2 or par 10 secondes. Il décrit Tribute et un actif Glacial Spike, ainsi que la limite d’un objet Gold Income. Aucun champ maps n’est fourni. Cette référence ne détermine pas la disponibilité Map10 du client 4.20.0.315. Le groupe natif GoldBase est une valeur d’auteur; son application par un consumer serveur n’est pas établie ici.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumers actuels et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun; aucun ne contient 3092. crates/core/src/shop.rs cherche d’abord la définition de l’objet. quote_with_counts et buy_item refusent avec item behavior not implemented avant la règle Map10. Si l’objet était ajouté sans décision d’admission, le consumer refuserait avec item map availability not qualified.

La recherche textuelle exacte de ItemGlacialSpikeCast, Frost Queen, GoldBase et gold income dans crates/core/src n’a retourné aucun handler correspondant. Cela borne l’absence de callsite nommé dans le code inspecté, mais ne prouve pas l’absence de dispatch dynamique. La structure locale Item n’importe pas le SpellName natif; l’effet actif et la limite GoldBase ne sont donc pas reliés par les données shop actuelles.

Résultat nominal de référence si intégration autorisée : prix 515, recette 3098+3108, règle de groupe à qualifier. Résultat statique observé : refus item behavior not implemented; l’actif, Tribute et le groupe ne sont pas consommés par ce chemin actuel. Aucun achat ou test direct 3092 n’a été exécuté.

## Résultat et limites

Clôturé pour ce sous-audit statique source → référence → consumer. Aucune feature Frost Queen's Claim n’est déclarée terminée.

ITEM-3092-SCOPE reste a_qualifier : la disponibilité Map10 de 4.20.0.315 n’est pas décidée, et le catalogue 4.20.1 ne fournit aucun champ maps. Les consumers d’actif, Tribute et GoldBase restent non reliés. Reprise uniquement sur une source Map10/merchant native exacte ou observation reproductible; pour les effets, sur un callsite natif ou une interface de dispatch déjà disponible. Ne pas refaire les hashes ni la recherche lexicale sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
