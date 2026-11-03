# SYS-01.2-02 — ITEM-3097-SCOPE : Targon's Brace

Vérification du 2026-11-03. Sous-lot limité à la source native, à la référence officielle 4.20.1 et au consumer actuel. ITEM-3097-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier les valeurs natives et le contrat catalogue au consumer boutique actuel, vérifier les références textuelles propres à l’effet, et distinguer les absences locales des règles historiques inconnues.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3097.inibin : 639 octets, SHA-256 c552e3e4a09ad13458aeb841d3685f3a66f211053b71c153b0b00c058e817855, MD5 8ada6f4f7cfff174a4f318abb0e1cd70. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.1.7. Preuve antérieure réutilisée sans rehash; précédence runtime non qualifiée.

Valeurs natives boutique consignées : Price=500, SellBackModifier=0.4, InStore=1, CanBeSold=1, UseEffect=0, ItemGroup=GoldBase, RecipeItem1=3302, SpellName=AtmasImpalerDummySpell.

La référence Data Dragon officielle 4.20.1 en_US nomme Targon's Brace : base 500, total 865, vente 346, recette 3302, +175 PV et +50 % régénération de base des PV. Le passif Spoils of War exécute des sbires sous 200 PV avec une attaque de mêlée, soigne de 50 PV le porteur et l’allié proche, donne l’or d’élimination à l’allié, demande un allié proche, recharge une charge toutes les 30 s (maximum trois) et partage le groupe Gold Income. Aucun champ maps n’est fourni. La référence 4.20.1 ne décide pas la disponibilité Map10 du client 4.20.0.315.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumers actuels et résultat attendu / observé

data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json ont 33 entrées chacun et excluent 3097. Le lookup de crates/core/src/shop.rs renvoie item behavior not implemented pour tout ID sans définition, avant la garde Map10; si une définition seule était ajoutée, l’absence de règle retournerait ensuite item map availability not qualified.

Une recherche exacte de Targon, Spoils of War, GoldBase et AtmasImpalerDummySpell dans crates/core/src ne trouve aucun handler nommé. Ce résultat lexical n’exclut pas une route générique ou calculée. Le consumer shop ne charge pas le SpellName natif et n’a pas de ligne 3097.

Résultat nominal de référence si intégration autorisée : achat à 500 avec composant 3302, puis comportement Spoils of War et limite Gold Income à vérifier selon le contrat retenu. Résultat observé statiquement : refus item behavior not implemented. Aucun achat ou test direct 3097 n’a été exécuté; l’exécution de sbire, les charges et l’attribution d’or ne sont pas observées.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. Aucun passif ou comportement de Targon's Brace n’est déclaré terminé.

ITEM-3097-SCOPE reste a_qualifier : l’admission historique Map10 du client PUBLIC 4.20.0.315 reste inconnue; la référence 4.20.1 n’a pas de champ maps. Le passif, le lien SpellName et le groupe GoldBase ne sont pas reliés aux consumers OpenLeague. Reprise seulement sur une source Map10/merchant native du build exact ou une observation reproductible; pour l’effet et la limite de groupe, sur un callsite ou contrat serveur/native qualifié. Ne pas refaire les hashes ni la recherche textuelle sans nouvel indice.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
