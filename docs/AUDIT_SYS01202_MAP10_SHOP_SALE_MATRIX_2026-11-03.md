# Audit dynamique — vente des objets Map10 du catalogue courant (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-SHOP-SALE-MATRIX-01, suite des achats V1120. Question : les 31 objets admis localement peuvent-ils être achetés puis vendus dans une fixture, avec remboursement et retrait attendus, y compris les piles de potions ? Ce contrôle ne qualifie pas une partie réelle, une interface ou une politique serveur historique.

## Sources et consommateurs

Les 31 IDs proviennent des succès du reçu V1120, E:/mapslol3v3/map10_shop_purchase_matrix/resultats.json SHA-256 6b49b9985026880a88c272f5fcbabdc7cfab97731e819b4a8e4bad2a8d7d6541. Le code crates/core/src/lib.rs::command route Action::Sell vers crates/core/src/shop.rs::sell_item : après shop_guard, cette fonction lit l'ID et le sell_price explicite, décrémente la quantité, retire l'emplacement si elle atteint zéro et crédite l'or. Elle ne consulte pas map10_available pour la vente.

Un rapprochement en lecture seule avec le reçu natif existant docs/reference_item_shop_sources/item_shop-links.json et le catalogue Data Dragon 4.20.1 a vérifié : les 31 champs CanBeSold enregistrés valent 1 et les 31 prix de vente locaux correspondent à `gold.sell` 4.20.1. Les fichiers natifs n'ont pas été redécodés dans ce lot; ces sources ont des versions et portées distinctes, et elles ne prouvent pas la transaction serveur historique.

## Contrôles exécutés

Fixture Rust externe E:/mapslol3v3/map10_shop_sale_matrix : `cargo run --offline --manifest-path E:/mapslol3v3/map10_shop_sale_matrix/Cargo.toml --quiet`, code 0, puis binaire copié relancé, code 0. Grille Map10 du projet, enable_map10, Ahri vivante équipe 0, position de boutique et 100 000 PO injectés, inventaire initial vide; une simulation neuve par objet.

- Pour chacun des 31 IDs, Action::Buy puis Action::Sell réussissent. L'objet est retiré, sa quantité devient zéro et l'or augmente exactement du sell_price local; une deuxième vente du même emplacement est refusée `empty inventory slot`, avec snapshot sérialisé inchangé.
- Pour 2003 et 2004, deux achats créent une pile de deux; une vente laisse une unité et rembourse une fois, une seconde vide la pile et rembourse une seconde fois.
- Pour 1038 et 1058, interdits à l'achat Map10 local dans V1120, une unité a été placée directement dans l'inventaire; la vente réussit et rembourse respectivement 1085 et 1120. Cela vérifie le traitement local d'un inventaire préexistant, pas une acquisition permise ni un défaut historique. Le test source `crates/core/tests/map10_shop_admission.rs::global_definitions_and_existing_excluded_inventory_keep_stats_swap_and_sale` couvrait déjà ce scénario conceptuel; ce lot fournit une exécution externe du chemin vente, sans exécuter ce test lui-même.

Aucun tick de partie, client graphique, réseau ou serveur historique. Position, or et inventaire des deux cas exclus sont injectés; l'égalité du snapshot après refus ne couvre pas nécessairement tout état privé. Les effets, prix historiques, échanges de composants, contrôles d'accès complets et acceptation restent séparés.

## Preuves et reprise

E:/mapslol3v3/map10_shop_sale_matrix : src/main.rs SHA-256 75a39d9a82ec76d52edca67830f9c59e4c9d69341e08461b7f06d666c71fafe1; Cargo.lock 4b547ac9af66e8775b6149d29af164a8dadd6ab5ec7db9695ec8a6c5bc81fb30; binaire openleague-map10-shop-sale-matrix.exe, 29 009 920 octets, 67ad307cb8c925ba182b2d60f9928ec34a8e58bade6daf8bf2dad6d503d23559; resultats.json 8e0e962c61eb6256801ada6f89978c842e39e43c83e35e825cceda5a4d83365c. references.py 8d1c1b6f6ab39b46b28db6e5b08aa8b42fa5162023ab1458cd6fb308438cf069; references.json 8ac96bd73f9c0bb2f532fa3378d200bbb22bcdd672dc3476a4e4dbe8f177c47a. Les avertissements de compilation figurent dans warnings.txt; cargo/rustc 1.96.1 et lock isolé, pas un build officiel hermétique.

La comparaison de références a été exécutée avec Python 3.12.14 du venv F:, -B, code 0; le JSON fournit les SHA des entrées et les 31 lignes. Réutiliser les fiches ITEM-<ID>-SHOP/ACCEPT et SYS-07.2/07.3 pour qualifier les règles historiques, prix/effets, puis les transactions en partie et réseau. Audit local clos pour ces cas; aucun goal, registre, application de suivi, base ou code produit modifié.
