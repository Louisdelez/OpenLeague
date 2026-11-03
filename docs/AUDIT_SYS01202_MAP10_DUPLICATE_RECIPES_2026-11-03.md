# Audit dynamique — recettes Map10 à composants identiques (2026-11-03)

## Périmètre et sources

Unité AUD-SYS-01.2-02-MAP10-DUPLICATE-RECIPES-01. Question : pour les trois recettes du catalogue local nécessitant deux exemplaires identiques, le devis puis l'achat comptent-ils chaque exemplaire une seule fois et préservent-ils l'état en cas de refus ? Périmètre : cœur courant et Map10, pas l'interface, le réseau ou le serveur historique.

Le reçu natif antérieur docs/reference_item_shop_sources/item_shop-links.json, SHA-256 f67a0d0aaccc343d322297a4863b1024188dea6604a67cbea7137f7362e7115a, identifie : 3114 = 1004+1004, prix de base 240; 3101 = 1042+1042, prix de base 350; 3134 = 1036+1036, prix de base 617. Les SHA enregistrés de leurs INIBIN sont respectivement ab572056875e390973fdb9c2f46510d68c9eb9b73865d2d83f7b92da5986cc0e, 1c38a8625b5295556fdb4f699d6c21a8871c82f3e6345699f313a21b0f20cc39 et 3c9076c0f152da74ecbc7d593f27984bf8c3b3ad07b2deafaa79a534d5a4ba77. Ces sources et champs sont réutilisés, non redécodés pendant ce lot. Les prix totaux locaux des trois objets sont 600, 1250 et 1337.

Le consommateur courant `crates/core/src/shop.rs` route l'achat vers quote_with_counts/plan_in; cette dernière vérifie récursivement les définitions et crédite les emplacements de composants consommés. Les tâches ITEM-3114/3101/3134-SHOP-RECETTE sont a_faire et les tâches SHOP/SCOPE correspondantes restent partiel_a_terminer; ce contrôle ne les change pas.

## Contrôles exécutés

Fixture Rust externe E:/mapslol3v3/map10_duplicate_recipe_audit : `cargo run --offline --manifest-path E:/mapslol3v3/map10_duplicate_recipe_audit/Cargo.toml --quiet`, code 0, puis binaire conservé relancé, code 0. Grille Map10 du projet, enable_map10, Ahri vivante, position de boutique et or fournis; nouvelle simulation pour chaque cas. Les composants sont achetés par Action::Buy, pas injectés directement.

Pour chaque recette, avec zéro, un puis deux composants, devis et achat réussissent; les emplacements consommés sont tous distincts et contiennent le bon composant. Coûts attendus et observés :

| Objet | Composants | 0 possédé | 1 possédé | 2 possédés |
|---|---|---:|---:|---:|
| 3114 | 1004 + 1004 | 600 | 420 | 240 |
| 3101 | 1042 + 1042 | 1250 | 800 | 350 |
| 3134 | 1036 + 1036 | 1337 | 977 | 617 |

Pour chacun des trois objets, un achat avec deux composants mais un PO de moins que le devis est refusé `insufficient gold` et conserve snapshot, or, inventaire et quantités. Un inventaire plein de six objets sans composant utile entraîne `inventory full`, avec les mêmes contrôles. Un inventaire plein comprenant un composant utile et cinq objets 1028 permet au contraire l'achat : le composant libère son emplacement, les cinq autres restent présents et le coût est celui d'un composant possédé. Total : neuf cas nominaux, trois refus d'or, trois refus de place et trois succès avec place libérée. Les neuf devis et emplacements consommés figurent dans resultats.json.

L'égalité du snapshot et les contrôles directs ne couvrent pas nécessairement tout état privé. L'or et la position sont fournis artificiellement; les cas n'exécutent pas de tick de partie, interface, réseau ou serveur Riot. Ces résultats ne prouvent pas l'ensemble des effets, des recettes ni les règles historiques de crédit, d'arrondi ou d'admission Map10.

## Preuves et reprise

E:/mapslol3v3/map10_duplicate_recipe_audit : src/main.rs SHA-256 9a804b0c59708b3e4634a61dc085ab393a5042937755e61ca6c40f3bdd659085; Cargo.lock 7e4af338e8b711e492030267e337df9d08b2cf3b96abdbcd52e5d4cae7a16106; exécutable openleague-map10-duplicate-recipe-audit.exe, 29 046 784 octets, ca31cce4d90129c78ef839177522b524b7127ce6d3dacf6d762c53612c77c725; resultats.json 9729a2b9fe0db3aed9525b76b3aff8c5fe45fc04d8f8eaa0f727565ce922402a. Avertissements dans warnings.txt; cargo/rustc 1.96.1 et lock isolé, pas build officiel hermétique. shop.rs et les données d'admission/catalogue ont les empreintes documentées en V1120.

Audit local de ces 18 cas terminé. Réutiliser les trois tâches SHOP-RECETTE et SHOP/ACCEPT pour qualifier règles historiques, interactions et parcours réels; ne pas convertir ce succès en fonctionnalités terminées. Aucun goal, registre, application de suivi, base ou code produit modifié.
