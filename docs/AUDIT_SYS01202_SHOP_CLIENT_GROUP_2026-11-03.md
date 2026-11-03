# Audit SYS-01.2-02 — proposition d'achat et groupe de bottes (2026-11-03)

## Périmètre et critères

Unité AUD-SYS-01.2-02-SHOP-CLIENT-GROUP-01. Exigence parente SYS-01.2-02 ; complément à H4 dans docs/audit/units/AUD-17.5-01-SHOP-STATES-01.md, qui avait constaté statiquement que selected_action ne contrôle pas les groupes alors que le moteur les refuse. Question : avec 3020 déjà possédé, le code actuel propose-t-il 1001 puis le moteur refuse-t-il sans mutation ? Critères : extraire fidèlement les fonctions clientes actuelles, les comparer à la commande réelle du core sur un cas ciblé, un achat nominal et des refus pertinents, et décrire la portée et la reprise. La politique voulue et les règles historiques ne sont pas décidées par ce test.

## Sources, consommateurs et méthode

Le script E:/mapslol3v3/audit_shop_quote_group_20261103/prepare.py extrait textuellement les deux types et fonctions nécessaires depuis F:/OpenLeague/crates/client/src/shop_ui.rs (SHA-256 cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1). selected_action utilise map10_purchase_available et quote_with_counts pour produire l'action. La fixture compile ces fragments avec la bibliothèque locale réelle F:/OpenLeague/crates/core et envoie ensuite l'action à Simulation::command ; la garde de groupe du moteur est dans crates/core/src/shop.rs (SHA-256 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0). Le test utilise la navigation et les données locales ; les principales empreintes figurent dans input_sha256.json, sans prétendre identifier individuellement toutes les dépendances.

## Attendu et observé

- Groupe : une simulation locale Garen reçoit 5 000 pièces et achète 3020 ; elle conserve 3 900 pièces. Le devis de 1001 vaut 325 et selected_action retourne Buy(1001). Simulation::command répond `item group already owned` ; or, six cases d'inventaire et six compteurs sont inchangés. La différence auparavant constatée statiquement est ainsi reproduite au niveau de ces fonctions.
- Nominal : sur une simulation vierge avec 825 pièces, selected_action propose Buy(1001), la commande réussit, le solde devient 500 et la case 0 contient 1001.
- Refus par le contrôle client : état non prêt, boutique fermée, objet 1038 non disponible dans le catalogue Map10 local, ID inconnu, or insuffisant et joueur absent retournent None. Ces témoins ne prouvent aucune politique historique.

## Contrôles et preuves

Depuis E:/mapslol3v3/audit_shop_quote_group_20261103 : `python prepare.py`, `cargo run --offline`, puis `cargo run --offline --locked *> run.log`. Deux exécutions réussies, dernière avec code 0 ; Cargo et rustc 1.96.1. Compilation avec avertissements existants du core et un variant inutilisé dans la fixture ; aucune erreur. La sortie observée est dans run.log SHA-256 68937e9a2aaa3435f0d7b5c0296c1e8424d53a5a55f2bcf4521b3a14d1515c59. Le binaire exécuté a été conservé sous audit-shop-quote-group.exe SHA-256 0a7a8698ed59ec76bfc270bfc025ead95f8912b045f0da95bfdf0815b03cd8f1 ; le fragment extrait SHA-256 b1082b0f496a76e587e08e79a98fb060301779df59f940a781f14c574c219434. Les seuls intermédiaires Cargo de cette fixture, environ 1,25 Go, ont été supprimés après copie et comparaison des empreintes du binaire. La reproduction par Cargo les régénère.

## Écart, limites et condition de reprise

Le client peut préparer une action qui sera refusée par le moteur dans l'état injecté ; aucun achat indu ni perte d'or n'est constaté dans ce test. Cela n'établit pas qu'un bouton soit effectivement visible ou actif, qu'un clic soit envoyé, ou que le rejet soit communiqué au joueur : ECS Bevy, rendu, réseau et session réelle ne sont pas exécutés. La règle historique Riot relative aux groupes n'est pas établie par ce scénario local. L'écart ne suffit donc pas à imposer une règle UI ou à déclarer un défaut historique.

Réutiliser la correction proposée HUD-SHOP-BUY-FEEDBACK-01 de l'audit H4. Reprendre quand une session avec binaire, assets et serveur local identifiés permet de vérifier le clic, le message de refus et la réconciliation de l'état ; choisir la politique UI et qualifier séparément la règle native si une source attribuable est disponible. Critères : achat accepté met à jour l'état reçu ; refus préserve or, IDs et comptes et présente le motif choisi, sans fausse réussite. Ne pas répéter le seul contrôle de fonctions sans changement pertinent.

L'audit de ce comportement limité est terminé ; la correction produit, le parcours UI/réseau, la fidélité historique et l'acceptation humaine restent ouverts. Goal parent actif et partiel ; aucun changement de goal, d'interface, de base ou de registre.
