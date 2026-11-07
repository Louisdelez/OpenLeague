# SYS-01.2-02 — ITEM-3090-SCOPE : Wooglet's Witchcap

Vérification du 2026-11-03. Lot limité à la source native item, au catalogue officiel 4.20.1 et au consumer actuel. ITEM-3090-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier la source native et sa membership aux valeurs versionnées; vérifier le refus boutique courant et rechercher le callsite d’effet portant le SpellName relevé, sans assimiler la référence 4.20.1 au build client 4.20.0.315.

## Source et contrat versionnés

Le reçu existant docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3090.inibin : 528 octets, SHA-256 cd046f4c0b11dc29a5a761c918af153fac82133f9a40e5e87d1a6b1f239ef7a7, MD5 c2d4bb219d713bb211819dd0212db07a. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve réutilisée sans rehash; la précédence runtime des ressources n’est pas qualifiée.

Valeurs natives de boutique : Price=1045, InStore=1, CanBeSold=1, UseEffect=1, SpellName=ZhonyasHourglass, RecipeItem1=3191, RecipeItem2=1026 et RecipeItem3=1052.

L’entrée locale ITEM-3090-SCOPE reprend Data Dragon officiel 4.20.1 en_US : Wooglet's Witchcap, base 1045, total 3540, vente 2478, purchasable=true, recette 3191+1026+1052, +100 AP/+45 armure, passif +25 % AP et actif de stase de 2,5 s avec délai 90 s. Le champ maps contient 1=false et 12=false, sans valeur 10. Ce catalogue ne décide donc pas la disponibilité historique sur Map10 en 4.20.0.315. Le SpellName natif correspond au nom ZhonyasHourglass, mais cela ne prouve ni la sémantique exacte de l’effet dans ce build ni son consumer en jeu.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun; aucun ne contient 3090. crates/core/src/shop.rs résout la définition avant la règle Map10; quote_with_counts et buy_item renvoient item behavior not implemented quand la définition manque. Si une définition était ajoutée sans entrée d’admission, le consumer retournerait ensuite item map availability not qualified.

Une recherche lexicale bornée dans crates/core/src pour 3090, ZhonyasHourglass, Wooglet, Witchcap et stasis n’a identifié aucun handler item; les rares nombres 3090 trouvés appartiennent à des adresses ou noms d’audio sans lien à l’objet. La structure Item du shop ne comporte pas de champ SpellName. Cette recherche n’exclut pas un dispatch générique ou une association par clé non textuelle.

Résultat attendu de référence : achat au prix de base 1045 avec composants 3191+1026+1052 et, selon le catalogue 4.20.1, actif de stase. Résultat observé statiquement : achat refusé avec item behavior not implemented; aucun effet 3090 n’est consommé par le chemin boutique identifié. Aucun achat ou test direct n’a été exécuté.

## Résultat et limites

Clôturé pour le sous-audit statique de la source, de la référence et du consumer boutique courant. Aucune fonctionnalité 3090 n’est déclarée terminée.

ITEM-3090-SCOPE reste a_qualifier : l’admission Map10 du client 4.20.0.315 n’est pas prouvée; les entrées maps de 4.20.1 ne comprennent pas l’ID 10. L’association native ZhonyasHourglass → actif 4.20.1 est seulement une correspondance de nom, pas une démonstration d’implémentation. Reprise sur source Map10/merchant du build exact, observation reproductible du client, ou callsite natif reliant le SpellName à l’actif. Ne pas refaire les hashes, l’inspection du shop partagé, ni la recherche lexicale ciblée sans nouveau callsite.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
