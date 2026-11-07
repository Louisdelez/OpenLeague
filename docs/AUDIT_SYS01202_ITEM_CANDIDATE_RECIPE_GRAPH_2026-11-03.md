# Audit des dépendances de recettes — 150 objets candidats (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-ITEM-CANDIDATE-RECIPE-GRAPH-01, suite de V1116 corrigé en V1117. Question : quelles recettes et dépendances sont documentées pour les 150 candidats, et dans quel ordre hypothétique leurs définitions pourraient-elles être examinées à partir des objets déjà admis localement ? Ce lot ne qualifie ni leur admission historique, ni leur achat réel, ni les mécaniques manquantes.

## Sources et contrôles

Le script E:/mapslol3v3/item_recipe_graph_audit/probe.py lit la liste V1116 des 150 candidats, les valeurs native Data déjà décodées dans docs/reference_item_shop_sources/item_shop-links.json (reçu du 2026-10-22), le catalogue Data Dragon 4.20.1 et map10_shop_admission.json courant. Pour chaque candidat, il vérifie que le SHA du fichier natif enregistré dans l'ancien reçu est celui relu en V1116; il réutilise ces lectures, sans relire à nouveau les 150 INIBIN. Il compare RecipeItem1..4, en conservant ordre et répétitions, au tableau `from` 4.20.1; puis calcule avec Decimal le prix natif de base et le total récursif, en refusant cycle ou profondeur >=32. Attendu et observé : 150/150 recettes concordantes dans l'ordre et 150/150 prix de base et totaux calculés concordants avec `gold.base` et `gold.total` de la référence 4.20.1. C'est une comparaison interversion sous le modèle d'addition des composants, non une exécution de la boutique historique.

Les 150 se répartissent en 15 sans recette et 135 avec recette; 45 de ces derniers ont tous leurs composants directs parmi les 31 IDs actuellement marqués admis localement. Si, hypothétiquement, on enrichit uniquement l'ensemble de définitions disponibles à chaque étape avec les candidats dont tous les composants directs sont déjà présents, le calcul produit trois groupes de 60, 68 puis 19. Les IDs de chaque groupe sont conservés dans resultats.json. Ce classement est un ordre de dépendances des données, pas une instruction d'import, une preuve d'admission historique, de prix en partie ou de recette achetable; les cibles elles-mêmes sont encore absentes du catalogue.

Trois candidats restent hors de cette fermeture hypothétique : 3196 dépend de 3200, 3197 de 3196 et 3198 de 3197. Le fichier natif 3200.inibin a été relu séparément, 562 octets, SHA-256 64108956accafedf54f992978e5284e14bc7b94e10225d0fd52130747f8ba832, puis décodé avec le lecteur existant : Data/InStore=0, RequiredChampion=Viktor, Price=0, UseWhenAcquired=0. Il faut qualifier comment ce composant propre à Viktor est fourni et utilisé; ces champs ne démontrent pas à eux seuls son mode d'attribution et ne justifient pas un achat automatique.

## Consommateur courant et limites

crates/core/src/shop.rs:69–125 cherche les définitions dans le catalogue, et plan_in valide récursivement leur existence, prix et graphe avant de calculer l'achat. V1114/V1116 ont déjà établi par lecture qu'une cible absente est refusée après shop_guard; le présent lot n'a pas exécuté d'achat. Même après ajout hypothétique de définitions, l'admission Map10, les contraintes de champion, le financement, l'inventaire, les règles de jeu et les effets restent à vérifier séparément. La carte native comporte une UnpurchasableItemList et une liste d'inclusion distinctes; contexte/provider/flags effectifs restent ouverts (V1075–V1085 et V1117).

## Preuves

Commande réellement exécutée : Python 3.12.14 de F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B sur probe.py, code 0. Aucune installation, exécution de jeu ou modification de données produit. E:/mapslol3v3/item_recipe_graph_audit/probe.py SHA-256 e62ddad7a38a3cbba03f851a0c0c7fee7aecd3d22ad82ebfe91b5470d7998130; resultats.json 9204f81785fb02e26c7447bb1731d05646067a0635c8eefa74e0abe96bd098c7. Entrées : reçu item_shop-links.json f67a0d0aaccc343d322297a4863b1024188dea6604a67cbea7137f7362e7115a; priorité V1116 6400cafbecdbf5d0bdf7ed7fb37a30adb1bf3dcc8938059f1d6b9694ae43e502; catalogue 4.20.1 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1; admission locale 6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485; lecteur INIBIN 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5. Le reçu contient tous les IDs, prix et recettes individuels; ce ne sont pas des preuves de runtime.

## Reprise

Audit du graphe de données clos pour cette sélection; qualification historique et implémentation restent ouvertes. Réutiliser pour chaque ID les fiches ITEM-<ID>-SCOPE, SHOP-RECETTE, SHOP et SERVER existantes. D'abord qualifier la disponibilité et l'objet, puis examiner les dépendances dans les groupes fournis; traiter séparément le composant 3200 et l'attribution à Viktor avant de conclure sur 3196/3197/3198. Ne pas présenter 147 candidats ordonnés comme 147 fonctionnalités terminées. Aucun goal, registre, application de suivi, base ou code produit modifié.

## Complément V1120 — preuve Viktor antérieure à réutiliser

Le rapport FIDELITY_VIKTOR_PASSIVE_GLORIOUS_EVOLUTION_LINKS_V650.md documente déjà que le texte natif indique un Prototype Hex Core au départ, ainsi qu'une fixture antérieure où Viktor a l'inventaire initial vide et où les quatre achats de la chaîne sont refusés. Ces observations précèdent le graphe V1118 et ne sont pas répétées comme nouvelles dans celui-ci. Le producteur exact du prototype et son comportement dans une partie/build actuel restent à qualifier; la source InStore=0 ne démontre pas à elle seule son mode d'attribution.
