# SYS-01.2-02 — ITEM-3026-SCOPE : Guardian Angel, source et consumer

Vérification du 2026-11-03, périmètre limité à la source 3026, à ses restrictions de carte disponibles et au consumer shop actuel. Tâche ITEM-3026-SCOPE : a_qualifier, implementation_complete=false, acceptance_complete=false. Aucun statut n’est modifié.

## Critère de fin du sous-lot

Identifier la source native datée, comparer les données du catalogue distinct 4.20.1 sans les présenter comme source du build client 4.20.0.315, vérifier l’admission locale réelle et relier le refus au consumer Rust. Laisser ouverte la disponibilité historique si aucune source native de restriction Map10 n’est établie.

## Sources vérifiées

- Source native OLS-a0b66c36-f5bc-50c6-97c5-6d8949b3aa19 : RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3026.inibin, client PUBLIC 4.20.0.315, 554 octets, SHA-256 e24996e6dc0c3a25ab6cd976f6791b44513c1a8e491ef1ec88fb01337c078918. Rehash actuel concordant. Le registre RadS relie le fichier au projet lol_game_client release 0.0.1.7, membership matches_selected_project_manifest, MD5 a1454d11aad6f6b9169c1c3bc17ce05e.
- Le décodeur natif courant consigne Price=1500, InStore=true, CanBeSold=true, SellBackModifier=0.4, SpellName=GuardianAngel, FlatArmorMod=50, FlatSpellBlockMod=40, RecipeItem1=1033 et RecipeItem2=1031. Aucun champ Map10 n’est présent dans ces valeurs décodées.
- Source de comparaison distincte OLS-b3343643-2fe6-513b-b286-7c03b86b8409 : Data Dragon officiel 4.20.1 en_US, 237 361 octets, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. L’entrée /data/3026 indique base 1500, total 2750, vente 1100, composants 1033+1031, armure 50, résistance magique 40 et maps 10=false, 12=false. Voir la source officielle versionnée : https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json. Cette ligne est un résultat catalogue 4.20.1, distinct du client 4.20.0.315.

## Consumer et résultat courant

Le catalogue réellement chargé par crates/core/src/shop.rs est data/4.20/shop_foundation.json; l’admission de carte provient de data/4.20/map10_shop_admission.json. Ces deux fichiers contiennent 33 éléments et n’ont pas d’entrée 3026. La fonction item cherche donc d’abord une définition; quote_with_counts et buy_item retournent le refus item behavior not implemented avant l’évaluation Map10. Si l’item était ajouté sans règle de carte, map10_available retournerait None et le consumer refuserait aussi avec item map availability not qualified. Les points d’appel et l’ordre sont visibles dans shop.rs (fichier SHA-256 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0).

data/4.20/items.ron contient une fiche de référence traduite pour 3026, mais aucun code Rust dans crates ne référence items.ron; cette fiche n’est pas le catalogue shop consommé. shop_foundation.json et map10_shop_admission.json ont les SHA-256 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae et 6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485.

Résultat attendu statique du consumer actuel pour un achat de 3026 : item behavior not implemented, avant toute règle de carte. Aucun achat nominal Map10 n’existe pour cet objet selon le catalogue 4.20.1 (maps[10]=false). Aucun test direct avec 3026 n’a été exécuté; le test générique de refus 1057 est conservé depuis le rapport ITEM-3025 et n’est pas rejoué. Le refus du consumer local n’est pas la preuve de l’interdiction historique.

## Résultat et limites

Clôturé pour ce sous-lot : source native rehashée et membership identifié; valeurs natives reliées au catalogue 4.20.1; consumer actuel, refus déterministe et absence de règle locale Map10 établis. Cela clôt l’audit source→consumer de ce périmètre, pas la fonctionnalité.

Reste ouvert pour ITEM-3026-SCOPE : la preuve Map10=true/false provenant du catalogue 4.20.1 ne décide pas à elle seule la disponibilité historique exacte du client 4.20.0.315; la définition et le comportement de Guardian Angel ne sont pas intégrés dans shop_foundation; le cas direct 3026 n’a pas de test. Reprise avec une source native Map10/merchant du build exact ou une preuve serveur/historique autoritative. Pour un futur travail de feature, qualifier séparément l’admission, la recette, les stats et le passif, puis ajouter des vérifications directes 3026. Aucun test, build, lancement du jeu, installation ou migration n’a été effectué dans ce lot.