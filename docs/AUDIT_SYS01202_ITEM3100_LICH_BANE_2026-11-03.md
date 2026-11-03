# SYS-01.2-02 — ITEM-3100-SCOPE : Lich Bane

Vérification du 2026-11-03. Lot limité à la source native, au catalogue officiel 4.20.1 et au consumer boutique actuel. ITEM-3100-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier le reçu natif à la référence versionnée et au refus actuel; vérifier si un consumer textuel identifié relie SpellName à l’effet Spellblade, sans convertir une absence de recherche lexicale en preuve absolue.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3100.inibin : 602 octets, SHA-256 8b7d32e99fb79147a099d23f64c704a79ad405a0eb7a97ef397087529a285331, MD5 996671ef57f6189218e6a6df9afa9776. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.243. Preuve antérieure réutilisée sans rehash; précédence runtime non qualifiée.

Valeurs natives consignées : Price=850, InStore=1, CanBeSold=1, UseEffect=0, SpellName=AtmasImpalerDummySpell, RecipeItem1=3057, RecipeItem2=3113.

La référence officielle Data Dragon 4.20.1 en_US nomme Lich Bane : base 850, total 3000, vente 2100, recette 3057+3113, +80 AP, +250 mana, +5 % vitesse de déplacement et passif Spellblade (après un sort, la prochaine attaque inflige des dégâts magiques bonus; délai 1,5 s). Aucun champ maps n’est présent. La référence 4.20.1 ne décide pas l’admission historique Map10 du client 4.20.0.315. Le SpellName natif ne correspond pas textuellement au passif Spellblade et son interprétation reste inconnue.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json comptent 33 entrées chacun; 3100 est absent des deux. crates/core/src/shop.rs retourne item behavior not implemented lors du lookup sans définition, avant le contrôle Map10. Si une définition était ajoutée sans entrée d’admission, la réponse suivante serait item map availability not qualified.

Une recherche exacte de LichBane, Spellblade et AtmasImpalerDummySpell dans crates/core/src n’a trouvé aucun handler nommé. La structure Item de la boutique n’expose pas SpellName; une association générique/non textuelle reste possible. Cette preuve établit seulement que le consumer courant ne relie pas directement le champ natif via ces chaînes.

Résultat nominal de référence si intégration autorisée : achat à 850 avec composants 3057+3113, puis les stats/effets à vérifier séparément. Résultat statique observé actuellement : refus item behavior not implemented. Aucun achat ni test direct 3100 n’a été exécuté; l’effet Spellblade n’est pas déclaré implémenté.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. Aucune feature Lich Bane n’est déclarée terminée.

ITEM-3100-SCOPE reste a_qualifier : l’admission Map10 exacte du client 4.20.0.315 n’est pas établie; Data Dragon 4.20.1 ne donne pas maps. Le SpellName natif et le passif Spellblade restent non reliés. Reprise uniquement sur une source Map10/merchant native du build exact, une observation reproductible, ou un callsite natif/serveur reliant 3100 à l’effet. Ne pas refaire le rehash ni la recherche lexicale sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
