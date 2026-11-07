# Audit ciblé — statistiques des 33 objets du catalogue courant (2026-11-03)

## Périmètre et sources

Unité AUD-SYS-01.2-02-ITEM-CATALOG-STATS-01, suite de V1114. Question : les bonus simples déclarés par le catalogue des 33 objets correspondent-ils aux champs natives associés et les consommateurs de statistiques utilisent-ils effectivement quelques-uns de ces bonus ? Ce lot n'établit ni disponibilité historique, ni achat, ni effets uniques/actifs, ni mécanique complète.

Les 33 définitions correspondent aux sources DATA/Items/<ID>.inibin établies en V1114. Le programme a relu les 33 fichiers, vérifié à nouveau taille et SHA attendus, puis décodé les champs de section Data avec tools/project-plan/reference_inibin.py SHA-256 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5. L'identité de chaque source est liée à son source_id dans le reçu V1114. Catalogue data/4.20/shop_foundation.json SHA-256 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae. Ce sont les données du code courant, pas une garantie sur un binaire déjà lancé.

## Valeurs et consommateurs

Onze correspondances explicites ont été comparées par objet : dégâts physiques→damage, armure→armor, résistance magique→magic_resist, PV→health, mana→mana, puissance→ability_power, vitesse d'attaque→attack_speed, vitesse de déplacement→move_speed, critique→critical_chance, vol de vie→life_steal et dégâts critiques→critical_damage. Les noms exacts des clés natives/locales et chaque couple sont conservés dans resultats.json. Comparaison numérique finie avec tolérance relative/absolue 10⁻⁵ : 363 couples, dont 334 présents côté natif et concordants; 29 absents côté natif et à zéro côté local. Les 29 absences portent toutes sur PercentLifeStealMod. Le zéro local provient d'une valeur explicite ou du défaut serde de Bonuses; l'absence de cette clé ne prouve pas le défaut historique ni l'absence d'effet.

Le code crates/core/src/shop.rs:195–245 désérialise et cumule les Bonuses de l'inventaire; progression.rs:68–126 les utilise pour les statistiques, dont vitesse via movement_speed. L'admission Map10 locale actuelle compte 31 true et 2 false (1038, 1058) dans data/4.20/map10_shop_admission.json; les 33 entrées ont été comparées indépendamment de leur admission. Cette donnée 4.20.1 locale ne décide pas à elle seule la disponibilité du serveur historique exact.

## Contrôles exécutés

Programme Python E:/mapslol3v3/item_catalog_stat_audit/probe.py via Python 3.12.14 du venv, -B, code 0; comparaison de 363 couples et contrôle synthétique de divergence. Aucune propriété native absente n'est remplacée par une preuve de zéro. Prix, recettes et admission officiels avaient déjà été traités dans le reçu item_shop-links; ils ne sont pas recalculés ici.

Fixture Rust externe `cargo run --offline --manifest-path E:/mapslol3v3/item_catalog_stat_audit/fixture/Cargo.toml --quiet`, code 0, puis binaire copié relancé, code 0. Simulation core actuelle, grille synthétique, Ahri, sans carte Map10; un seul objet à la fois est placé directement dans l'inventaire sans achat. Attendu et observé via Simulation::stats : 1036 dégâts +10; 1029 armure +15 (14,999998 observé); 1052 puissance +20; 1001 vitesse +25. Les valeurs attendues correspondent aux quatre champs natifs décodés dans ce lot. Ce test confirme quatre liaisons locales en fixture, non une transaction boutique, les 33 objets ou les effets cumulés. Aucune interface, session réseau ni serveur historique exécuté. Cargo/rustc 1.96.1, lockfile isolé, avertissements du cœur conservés; pas une qualification du build officiel.

## Preuves

E:/mapslol3v3/item_catalog_stat_audit/probe.py SHA-256 6bfc4ae4838bff405d917f8bc0fcc250c2c63182d136a8c29e8ceaeFE8E64F8C; resultats.json 041fb9e574d382a470f86238d9a4db569f63e10645e3bb0de1601e49e79038fe. Fixture : src/main.rs 7d13bbb13db72ff6bfd47cf2d6e96095b3e962297381ac2d16aba11bcec9d963; Cargo.lock 70e99cef86f3f0225244ef19fcf78a14612bf6400e62d7d407a86ed88626628e; exécutable openleague-item-stat-audit-fixture.exe, 15 783 424 octets, 1049c2311a0bc6df8b78991bea2e6c424eabfdfb65ea85ce70361216357c56ce; resultats.txt 0accb1d829a4f04e1573120086cb08b7e2b1b8a876d7f65c71babd9bef68ea39. Ancres partielles : shop.rs 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0; progression.rs eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766; map10_shop_admission.json 6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485. Empreintes partielles, non recette hermétique.

## Reprise

Audit des valeurs sélectionnées clos; quatre chemins de statistiques locaux vérifiés dans la fixture, pas les autres ni le jeu entier. Réutiliser les fiches ITEM-<ID>-SERVER-STAT correspondantes, SCOPE, SHOP et ACCEPT : qualifier le sens/des défauts natifs et chaque différence d'admission, puis vérifier achats, effets uniques/actifs, interactions, limites et présentation dans une partie réelle. Reprendre la question des 29 absences avec un consommateur natif ou un contrat historique attribuable, sans convertir automatiquement une absence en zéro. Aucun goal, registre, application de suivi, base ou code produit modifié; le parent reste ouvert.
