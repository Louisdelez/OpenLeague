# AUD-22.1-07-KEY-01 — Fallback de nom d'objet

Date de contrôle : 2026-10-30T10:51:48.023263+00:00. Parent : SYS-22.1-07. Résultat documentaire uniquement ; aucune modification du Goal, du code, de l'application de suivi, des registres ou des bases.

## 1. Décision et frontière

**Audit terminé avec preuves pour le rôle de `Inconnu` dans la boutique.** `item_name(id)` recherche un identifiant numérique dans le catalogue global. Ce n'est pas un résolveur de clés de traduction. Le libellé `Inconnu` seul ne démontre donc pas la détection de chaînes localisées manquantes.

| Dimension | Conclusion limitée à ce lot |
|---|---|
| Audit | Terminé : source du libellé, entrée déclenchante, consommateur et intégrité des références de recette établis |
| Implémentation | Recherche de nom et fallback présents ; aucun signalement explicite d'ID absent dans cette fonction ; résolution de traduction non assurée par cette fonction |
| Vérification | Partielle : inspection statique et contrôles de données exécutés ; aucun test Rust ni affichage graphique exécuté pour ce lot |
| Acceptation humaine | Non demandée ; aucune validation fonctionnelle déduite |

Le parent reste ouvert pour le résolveur de traductions, ses diagnostics et les débordements. Ce lot ne clôture ni la boutique complète ni la localisation complète.

## 2. Sources et provenance

Le fichier historique présent est `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Menu/fontconfig_fr_FR.txt`. Son empreinte concorde avec `docs/item_localization_source.json`.

Ce manifeste local recense 17 objets : leurs 17 noms concordent avec le catalogue actuel. Contrôle complémentaire effectué directement sur les déclarations `tr "game_item_displayname_<id>"` du fichier historique : les 33 noms du catalogue concordent, aucune clé correspondante absente. Exemples relus : 1001, ligne 7387 ; 1038, ligne 7402 ; 1058, ligne 7413.

Cette comparaison porte sur les noms français de ce fichier 4.20. Elle ne prouve ni une sélection dynamique de locale, ni la conformité en_GB de l'interface, ni la provenance de tous les autres champs des objets. Les `source_sha256` des lignes du catalogue ne sont pas réinterprétés comme des empreintes de traduction. Le contrôle des manifestes de distribution historiques n'est pas relancé.

## 3. Consommateurs actuels

- `crates/core/src/shop.rs:36-47` charge à la compilation `data/4.20/shop_foundation.json` via serde_json et expose `config().items` par `catalog()`.
- `crates/client/src/shop_ui.rs:47-52` cherche `i.id == id`, retourne `i.name.as_str()` si trouvé et `Inconnu` sinon. Aucun Result, journal ou diagnostic n'est produit par cette fonction.
- Son seul appel de production dans ce module est à la ligne 430 : transformation des IDs de composants en noms, concaténés avec ` + ` pour `NativeText::Recipe`. Les lignes 429-433 affectent cette chaîne au texte UI. L'autre appel est un test, ligne 575.
- `main.rs:809,825` enregistre `shop_ui::setup` et `shop_ui::update`. C'est une chaîne d'appels établie par lecture ; elle n'a pas été exécutée dans ce lot.

Le catalogue global et le filtre d'achat Map10 ont des responsabilités distinctes. Le test existant `map10_purchase_catalog_preserves_global_items_and_filters_only_acquisition`, lignes 562-578, préserve explicitement les noms de 1038 et 1058, exclus de l'achat Map10 mais présents globalement. Ce test a été lu, pas relancé. Remplacer ici le catalogue global par le filtre d'achat créerait un risque de faux `Inconnu` ; aucune correction de cette nature n'est prescrite.

## 4. Attendu, observé et contrôles exécutés

Contrôles en lecture seule, Python local avec `-X utf8 -E -B`, le 2026-10-30 : json.loads, comptage des IDs/noms/références de recette, recherche de clés natives exactes, calcul SHA256 ; lecture des fonctions et appels Rust. Les commandes ont terminé avec le code 0.

| Cas | Attendu selon le contrat local | Observé et nature de la preuve |
|---|---|---|
| Catalogue nominal | IDs uniques et noms renseignés | 33 objets, 33 IDs uniques, aucun doublon, aucun nom vide : contrôle de données exécuté |
| Recettes nominales | Chaque composant possède une définition globale | 21 références sur 21 résolues ; aucune référence absente : contrôle de données exécuté |
| Provenance des noms | Accord avec les entrées françaises natives retenues | 33 noms sur 33 identiques, aucune clé correspondante absente : comparaison de données exécutée |
| ID 1001 | Retourner Bottes de vitesse | Donnée présente, branche directe dans le code ; fonction Rust non exécutée |
| IDs 1038 et 1058 | Garder le nom global malgré l'exclusion d'achat | BF Glaive et Baguette trop grosse présents ; comportement prévu par le test source existant, non relancé |
| IDs 0 et 4294967295 | Retourner Inconnu si absents | Absence de ces deux IDs contrôlée ; retour déduit de la branche Rust, pas observé à l'exécution |
| Objet présent avec nom vide | Retourner la chaîne vide selon le code actuel | Aucun objet actuel dans ce cas ; déduction statique, aucun fichier altéré pour fabriquer ce cas |

Pour les recettes du catalogue actuel, la condition de fallback n'est pas satisfaite. C'est une conclusion de données et de code, pas une preuve d'inaccessibilité globale à l'exécution. Le chargement serde exige un champ `name`, mais aucun contrôle de chaîne non vide n'est établi par les lignes inspectées. Aucune politique historique de refus, aucun diagnostic de clé de traduction et aucune mesure de débordement n'ont été exécutés.

## 5. Écarts et inconnues

L'association existante `docs/reference_localization_sources/localization-links.json` dit déjà `entry_boundary_only=true` et `full_task_scope_complete=false`. Elle reste inchangée. Son ancre est OLC-26b7dc66-05ad-52a4-8957-2db9ef9054a7 ; inconnue parente conservée : OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f.

Précision apportée : le manque à cette frontière est un **identifiant d'objet non résolu**, pas nécessairement une clé de traduction absente. Un nom vide est un autre cas, non couvert par ce fallback. Le comportement natif sur une clé absente et le traitement courant de textes hors boutique restent indéterminés. Il ne manque pas de nom français parmi les 33 objets vérifiés ; aucune recherche communautaire ni génération de texture n'est justifiée par ce constat.

## 6. Actions restantes et reprise

Ces actions sont des précisions documentaires sous les tâches existantes ; elles ne créent ni ne modifient de tâche dans l'application.

| ID et rattachement | Résultat unique et critère de fin | Entrée et condition de reprise |
|---|---|---|
| TR-RESP-01 sous SYS-22.1-04, réutilisé | Établir la chaîne actuelle clé de traduction → table → résolution → texte visible, ou l'absence délimitée de ce mécanisme. Distinguer les noms d'objet déjà résolus et les littéraux UI. | Lire les consommateurs actuels et les preuves V795. Réutiliser la source déjà identifiée ; ne pas réanalyser le lecteur de polices inchangé. |
| KEY-DIAG-01 sous SYS-22.1-07 | Spécifier la réponse à un ID d'objet absent, séparément d'une clé ou valeur localisée absente. Fin : cas nominal, ID absent et nom vide explicitement distingués, contrat retenu et diagnostic vérifiables. | Après clarification de responsabilité par TR-RESP-01 ; source native ou contrat local explicitement assumé. Une réalisation fonctionnelle exige une instruction distincte. |
| KEY-VERIFY-01 sous SYS-22.1-07 | Vérifier le diagnostic dans le vrai consommateur retenu et conserver les noms globaux 1038/1058. Fin : attendu/observé sur cas nominal et limites, identité du binaire et résultat visible si graphique. | Implémentation et périmètre d'exécution autorisés ; aucune exécution graphique n'est présumée disponible ou réussie. |

Aucune correction fonctionnelle réalisée : les données vérifiées ne présentent pas le défaut déclenchant `Inconnu`, et le fallback n'est pas le consommateur adéquat pour imposer une politique générale de traduction.

## 7. Identités, livraison et relecture

| Fichier contrôlé | Octets | SHA256 |
|---|---:|---|
| crates/client/src/shop_ui.rs | 36049 | cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1 |
| crates/core/src/shop.rs | 30601 | 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0 |
| crates/client/src/main.rs | 141376 | eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620 |
| data/4.20/shop_foundation.json | 30123 | 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae |
| docs/item_localization_source.json | 4462 | fa898d1d1698491ce4a7e56f336e73840f73a79e1363ab450d02610d9b956eee |
| Fichier natif fr_FR ci-dessus | 2469242 | 47429564a76830c2cb5a05f7cdad0c62e987532a71789347dccef8322f4d4562 |

Les constats antérieurs `AUD-22.1-07-TR-01.md` et `FIDELITY_REA_LOCALE_TEXT_V795.md` sont réutilisés comme contexte, sans relancer leurs diagnostics ni étendre leur portée. Le seul fichier créé pour ce lot est ce compte rendu. Aucune base ouverte, aucune installation, migration, compilation, nouvelle analyse REA, modification applicative ou retrait des changements gelés.

Relecture de cohérence : 33 objets du catalogue actuel ne signifient pas tous les objets de LoL ; conformité des noms français ne signifie pas localisation en_GB ; les refus des IDs absents restent des déductions statiques ; audit clos ne signifie pas fonctionnalité terminée. Les sept rubriques sont couvertes pour cette seule frontière.
