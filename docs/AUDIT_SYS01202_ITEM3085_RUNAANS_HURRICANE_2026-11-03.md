# SYS-01.2-02 — ITEM-3085-SCOPE : Runaan's Hurricane

Vérification du 2026-11-03. Sous-lot limité à la source native d’item, au catalogue de comparaison 4.20.1 et au consumer de boutique actuellement chargé. La tâche ITEM-3085-SCOPE reste a_qualifier.

## Critère de fin du sous-lot

Relier la source native et son membership déjà enregistrées aux valeurs/version de référence, puis établir le résultat du consumer local sans confondre refus actuel et disponibilité historique.

## Source et contrat versionnés

Le reçu docs/reference_item_shop_sources/item_shop-links.json consigne DATA/Items/3085.inibin : 550 octets, SHA-256 304f7d4139112d39b0f7a57f9416fdac2ab6ca820e2033fcdec54bb329d17a74, MD5 31dce15c813efc8d8d4f4d0c5ef1e95b. Membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.242. Cette preuve antérieure est réutilisée; aucun rehash n’a été exécuté. La précédence runtime des ressources reste non qualifiée.

Valeurs natives boutique consignées : Price=600, InStore=1, CanBeSold=1, UseEffect=0, RecipeItem1=1042, RecipeItem2=1043, RecipeItem3=1042, SpellName=AtmasImpalerDummySpell. Le reçu ne prouve pas l’admission de l’objet sur Map10.

Le contexte local de la tâche ITEM-3085-SCOPE reprend l’entrée Data Dragon 4.20.1 en_US : Runaan's Hurricane (Ranged Only), base 600, total 2400, vente 1680, purchasable=true, recette 1042+1043+1042, vitesse d’attaque +70 % et passif de deux carreaux. L’objet ne fournit aucun champ maps. Cette référence est distincte du client PUBLIC 4.20.0.315 et ne décide pas Map10 historique. La valeur native SpellName=AtmasImpalerDummySpell ne correspond pas textuellement au nom du passif de l’entrée officielle; ce lien sémantique reste inconnu et n’est pas implémenté par le consumer boutique décrit ci-dessous.

Source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json (item.json, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1).

## Consumer actuel et résultat attendu / observé

Le code Rust charge data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json; les deux listes courantes ont 33 entrées et excluent 3085. crates/core/src/shop.rs:85-86 cherche d’abord une définition et renvoie item behavior not implemented lorsqu’elle manque. buy_item suit le même ordre à shop.rs:261-268, avant la vérification Map10.

Résultat nominal de référence si intégration autorisée : prix natif 600 et composants 1042+1043+1042, sous réserve de qualification de carte et du comportement. Résultat observé par inspection statique du consumer actuel : achat 3085 refusé avec item behavior not implemented. Si la définition était ajoutée sans admission Map10, le code refuserait avec item map availability not qualified. Aucun achat ni test direct 3085 n’a été exécuté; ces résultats décrivent le chemin de code, pas une observation runtime.

## Résultat et limites

Clôturé pour le sous-audit statique source → référence → consumer. Aucun comportement Runaan n’est déclaré terminé.

ITEM-3085-SCOPE reste a_qualifier : aucune source ne tranche la disponibilité Map10 dans le client 4.20.0.315; le catalogue 4.20.1 ne fournit pas de champ maps, et InStore=1 ne vaut pas preuve Map10. Le lien entre AtmasImpalerDummySpell et le passif officiel n’est pas établi. Reprise uniquement sur une source Map10/merchant native du build exact ou une observation reproductible de ce build; pour le passif, sur une preuve native du SpellName ou un callsite/contrat de gameplay identifié. Ne pas refaire les hashes ou le refus générique.

Aucun test, build, lancement du jeu, installation ou migration n’a été effectué. Aucun code, registre de tâches, goal, Plan, application ou base de données n’a été modifié.
