# SYS-01.2-02 — ITEM-3029-SCOPE : Rod of Ages (Crystal Scar)

Vérification du 2026-11-03, périmètre limité à la source native 3029, à la restriction de carte du catalogue distinct 4.20.1 et au consumer shop actuel. Tâche ITEM-3029-SCOPE : a_qualifier, implementation_complete=false, acceptance_complete=false. Aucun statut n’est modifié.

## Critère de fin du sous-lot

Identifier la source native datée et son membership, relever la restriction Map10 présente dans Data Dragon 4.20.1, et relier l’absence locale au consumer réel. Ne pas transformer la restriction 4.20.1 en affirmation historique définitive sur le client 4.20.0.315 sans donnée native correspondante.

## Sources vérifiées

- Source native OLS-76b66fe8-344e-5ff3-a44b-8ba575e62718 : RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3029.inibin, client PUBLIC 4.20.0.315, 597 octets, SHA-256 9cdb243c64ae762456da31da0d283e8bff18ddf1e2dd67efe8051afe42e1ea43. Rehash actuel concordant. Le registre RadS confirme membership matches_selected_project_manifest dans lol_game_client 0.0.1.7, release membre 0.0.0.242; MD5 2c4f36f3957a5cedaf090d08088b771a.
- Valeurs natives décodées : Price=740, InStore=true, CanBeSold=true, SpellName=RodOfAgesDummySpell, RecipeItem1=3010 et RecipeItem2=1026; +450 PV et +450 mana.
- Source officielle distincte OLS-b3343643-2fe6-513b-b286-7c03b86b8409 : Data Dragon 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. L’entrée /data/3029 est Rod of Ages (Crystal Scar), base 740, total 2800, vente 1960, composants 3010+1026, profondeur 3, 450 PV/450 mana/+60 AP; elle porte explicitement maps[10]=false, maps[12]=false et maps[1]=false. Le catalogue basic.maps donne maps[8]=true par défaut. Source : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json.
- Aucun indicateur Map10 n’est présent dans les valeurs décodées de l’INIBIN natif. InStore=true ne neutralise pas le maps[10]=false du catalogue 4.20.1 et ne décide pas la disponibilité native historique du build 4.20.0.315.

## Consumer et résultat courant

Le consumer Rust charge data/4.20/shop_foundation.json et data/4.20/map10_shop_admission.json. Ces fichiers ont 33 entrées et aucun ID 3029. data/4.20/items.ron est une fiche de référence non consommée par le code Rust des crates.

Dans crates/core/src/shop.rs, quote_with_counts et buy_item recherchent la définition de l’objet avant le contrôle de carte. Le résultat statique attendu pour un achat 3029 est donc item behavior not implemented. Si une définition était ajoutée sans règle d’admission, map10_available retournerait None et le consumer refuserait item map availability not qualified. L’identité de shop.rs et des deux fichiers JSON est réutilisée depuis V1048, hashes inchangés; aucun test générique n’a été rejoué et aucun test direct 3029 n’a été exécuté.

Il n’existe pas de cas nominal d’achat 3029 dans le consumer actuel. Le refus attendu est déterminé par l’absence exacte de l’ID dans le catalogue chargé et l’ordre de code, mais n’a pas été observé par un appel runtime ciblé.

## Résultat et limites

Clôturé pour ce sous-lot : source native et membership identifiés, restriction Map10 explicite du catalogue 4.20.1 relevée, consumer courant et refus local établis.

Reste ouvert pour ITEM-3029-SCOPE : la restriction du catalogue 4.20.1 ne prouve pas à elle seule la politique du client 4.20.0.315; l’entrée shop et l’admission locale manquent; la fonctionnalité Rod of Ages (Crystal Scar) n’est pas intégrée. Reprise avec une liste merchant/Map10 native du build exact ou une preuve historique/serveur. Pour une future feature, intégrer explicitement l’ID 3029 et sa règle Map10=false puis ajouter des contrôles directs. Aucun code, registre JSON, statut, goal, Plan, application ou base n’a été modifié; aucun test, build, runtime, installation ou migration n’a été effectué dans ce lot.