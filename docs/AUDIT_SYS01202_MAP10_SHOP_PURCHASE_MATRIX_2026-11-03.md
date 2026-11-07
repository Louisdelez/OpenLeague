# Audit dynamique — achats Map10 du catalogue courant (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-MAP10-SHOP-PURCHASE-MATRIX-01, suite de V1114–V1116. Question : les refus prédits pour les 247 IDs absents et les 2 IDs explicitement refusés sur Map10, ainsi que l'achat nominal des 31 IDs admis localement, sont-ils atteignables dans le cœur courant ? Ce lot ne détermine pas la disponibilité historique des objets ni la conformité d'une partie complète.

## Sources et consommateur

Les 247 IDs sont ceux de E:/mapslol3v3/item_source_link_audit/catalog_resultats.json, issus de 280 définitions natives associées aux fiches ITEM en V1114, moins les 33 entrées du catalogue source actuel. data/4.20/shop_foundation.json contient ces 33 entrées; data/4.20/map10_shop_admission.json indique 31 true et 2 false (1038, 1058). Le code crates/core/src/lib.rs::command dispatch Action::Buy vers shop.rs::buy_item; shop_guard précède la recherche de l'objet et la garde Map10. Cette admission locale a été construite à partir de Data Dragon 4.20.1, distincte du serveur 4.20.0.315.

Le reçu antérieur F:/OpenLeague/docs/FIDELITY_VIKTOR_PASSIVE_GLORIOUS_EVOLUTION_LINKS_V650.md avait déjà exécuté des refus pour la chaîne Hex Core et constaté un inventaire initial vide dans une fixture antérieure. Le texte natif y documente que Viktor commence avec le prototype; le producteur exact reste ouvert. Le présent lot étend les essais d'achat à l'ensemble sélectionné sur le cœur compilé ici, avec Ahri; il ne remplace pas le test Viktor et ne détermine pas l'attribution du prototype.

## Tests exécutés

Fixture Rust externe E:/mapslol3v3/map10_shop_purchase_matrix : `cargo run --offline --manifest-path E:/mapslol3v3/map10_shop_purchase_matrix/Cargo.toml --quiet`, code 0, puis copie du binaire et réexécution, code 0. La vraie grille Map10 du projet est chargée, enable_map10 appelé, snapshot Map10 présent; Ahri équipe 0 est positionnée directement au point de boutique, vivante, avec 100 000 PO et un inventaire vide. Aucun tick de partie, interface ou transport réseau. Les 31 achats utilisent chacun une simulation neuve pour éviter les effets d'un achat précédent.

- Les 247 IDs absents produisent tous `item behavior not implemented`. Pour chaque refus, snapshot sérialisé, or, inventaire et quantités restent identiques aux valeurs avant appel.
- Les IDs 1038 et 1058, présents mais interdits par l'admission locale Map10, produisent `item unavailable on Map10`, avec les mêmes contrôles d'état. Ce résultat confirme que la branche Map10 a été atteinte dans la fixture.
- Les 31 IDs admis localement s'achètent dans leur simulation : un objet apparaît, sa quantité vaut un et l'or baisse du prix du catalogue local. Aucun composant initial n'est fourni; ces essais ne vérifient ni les crédits de recette ni les effets.
- Témoin de priorité des gardes : un ID absent demandé alors que le joueur est positionné hors boutique est d'abord refusé avec `outside allied shop`, sans changement du snapshot et des ressources contrôlées.

Le JSON resultats.json contient les IDs et prix des cas réussis. L'égalité d'instantané et les contrôles explicites ne démontrent pas l'absence de mutation dans tout état privé. Les achats sont réalisés avec position et or injectés, non dans une partie ou un parcours UI; les deux refus d'admission reflètent uniquement la politique locale. Aucune affirmation sur l'admission Riot des 247 ou sur les effets de ces 31 objets ne découle du test. Les résultats locaux confirment une frontière d'implémentation, pas une liste de contenus historiques à importer.

## Preuves et reprise

Code externe SHA-256 9d36a2eb9e0e12bc9cce4b48e9f30bcf404bec2f88eb9b2e4205aebd6979d18f; Cargo.lock fdda94f449dffa07e7882ed193006f4ade87a9190f7753b5bd50db55031649eb; binaire openleague-map10-shop-purchase-matrix.exe, 29 019 136 octets, f0ea7c34695fff82d572c1c426f79f583d6c557a9c5fc1bc98767bacb5155b09; resultats.json 6b49b9985026880a88c272f5fcbabdc7cfab97731e819b4a8e4bad2a8d7d6541. Le cœur a émis les avertissements consignés dans warnings.txt; compilation cargo/rustc 1.96.1, lock isolé, non build officiel hermétique.

Entrées identifiées : shop.rs 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0; shop_foundation.json 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae; map10_shop_admission.json 6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485; grille JSON 98903341b52e204145eafc92a949394712257abc352bc3dad5e5fe204f1c1321 et cellules beeeff7df5b236e7617cacf0c848b850c1114e007253434ce59d7ad6410b7e72. La liste d'entrée des 247 provient du reçu V1114 SHA-256 1538b353bc3e154127b8732e4779cd25b65976916772fd34451fb189f540e922.

Audit de cette matrice locale clos. Réutiliser les tâches ITEM-<ID>-SCOPE, SHOP, SERVER et ACCEPT : qualifier d'abord la règle historique et la disponibilité de chaque objet, puis implémenter/tester recettes, effets, prix et achat réel lorsque requis. Pour Viktor, réutiliser V650 et reprendre sur le producteur du prototype et sa présence dans le build/partie actuelle. Le goal et les tâches fonctionnelles restent ouverts; aucun goal, registre, application de suivi, base ou code produit modifié.
