# SYS-01.2-02 — item 2001 : absence de consommateur courant

Date de contrôle : 2026-11-02 (UTC). Unité d’audit : AUD-SYS01202-ITEM2001-CURRENT-CONSUMER-01. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839.

## Portée et décision

Cette unité détermine si la ressource native DATA/Items/2001.inibin est reliée au catalogue d’objets, à l’achat de partie, à la boutique cliente ou à l’usage des consommables dans les sources Rust actuelles. Elle ne qualifie ni l’inclusion historique de l’objet dans chaque mode/carte, ni ses règles serveur, ni le jeu complet.

Audit : terminé pour l’inventaire statique du consommateur actuel de l’ID 2001. Implémentation locale : absente du catalogue/consumer inspecté. Vérification runtime : non exécutée. Acceptation humaine : non demandée. Cette clôture ne modifie pas l’état de la tâche parente ni le goal.

## Source réutilisée et limites

Le comparatif existant docs/fidelity_community_review_4_20.json identifie la source native comme :

- D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\2001.inibin
- Empreinte enregistrée : SHA-256 1c5678b5bebd0d3b1281a7c10ac2cda22031e82d8cb43488746515bdb9f903fd.
- Comparaison existante avec D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Default\Items\2001\2001.json, SHA-256 2895b58a6d9c16b1e2ba6fc6111899d5a168530878a4578d47c6866c957eda6b : 62 champs comparés, 62 égaux, 0 différence, 0 clé native manquante. Le reçu situe le fichier sous RADS release 0.0.1.68.

Ce reçu est réutilisé; les fichiers d’origine n’ont pas été rehashés dans ce lot. L’export communautaire indique ContentFormatVersion=4, qui décrit son schéma, et le reçu précise que le commit exact correspondant au fichier n’est pas établi. Une égalité de champs ne démontre ni la sémantique serveur, ni la disponibilité EUW/Map10, ni que l’objet doit être offert dans cette version. Aucun identifiant de source de tâche n’est inféré à partir du seul chemin.

## Consommateurs Rust actuels inspectés

- data/4.20/shop_foundation.json (SHA-256 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE) contient les IDs 2003 et 2004 aux lignes 782 et 813; la recherche ciblée des IDs 20xx n’y trouve pas 2001. Les IDs 2003/2004 sont le contrôle nominal statique pour cette famille de consommables.
- crates/core/src/shop.rs:46 charge ce catalogue; :69 résout un ID par recherche. quote_with_counts retourne item behavior not implemented quand l’ID est absent (:85-86); buy_item fait la même résolution avant d’évaluer la disponibilité Map10 (:261-263).
- crates/client/src/shop_ui.rs:57-59 construit la liste achetable Map10 à partir du catalogue central filtré. Sans entrée 2001 dans ce catalogue, l’interface actuelle ne peut pas le présenter par ce chemin.
- crates/core/src/consumables.rs:12-14 exige une entrée du catalogue avec une définition d’effet; les noms natifs gérés sont RegenerationPotion et FlaskOfCrystalWater. advance_consumables consomme les définitions 2003 et 2004 (:25-30). Aucun branchement 2001 n’est présent dans ce consumer.

Empreintes des quatre fichiers actuellement inspectés :

- shop.rs: 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0
- consumables.rs: 984ee7042fe5f1a82d15a80689f9022d9a4afa3e7d6f92e16adc3e37e340c6c6
- shop_ui.rs: cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1
- shop_foundation.json: 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae

## Attendu, observé et contrôles

- Contrôle nominal attendu : les entrées implémentées sont visibles dans le catalogue et reliées à un consumer. Observé statiquement : 2003/2004 sont dans les données et consommés par le chemin potion santé/mana. Ce n’est pas un achat joué ni un test runtime.
- Limite/refus attendu pour 2001 dans l’état actuel : ID absent du catalogue, donc devis et achat suivent l’erreur générique item behavior not implemented, avant le contrôle Map10. Observé statiquement : la branche et l’absence de l’entrée concordent. La commande d’achat n’a pas été appelée et son erreur n’a pas été observée à l’exécution.
- Contrôles réellement exécutés : lecture ciblée du reçu communautaire/native; recherche des IDs 2001–2004 dans le catalogue; inspection des callsites Rust indiqués; calcul SHA-256 des quatre fichiers locaux; git status --short préalable. Aucun test, build, binaire ou runtime n’a été lancé.
- Les fichiers Rust et les données ont des modifications antérieures dans l’arbre de travail partagé. Elles ont été conservées; aucune n’a été éditée dans ce lot.

## Écart, correction et condition de reprise

L’écart prouvé est l’absence du lien source→catalogue→consumer local pour l’ID 2001. La preuve ne permet pas de conclure que cette absence est une régression : l’appartenance de 2001 au périmètre jouable 4.20.0.315 EUW/Map10 et son type d’effet restent inconnus. Il n’est donc pas justifié d’ajouter une entrée inventée ou de modifier le code sous ce goal documentaire.

Correction proposée, non ajoutée au registre : OPEN-ITEM-2001-SCOPE-AND-CONSUMER. Critères de fin : (1) établir l’identité/membership de la ressource dans la release de référence; (2) déterminer depuis des champs natifs décodés et une source serveur/versionnée si 2001 est actif et admis sur Map10; (3) si oui, implémenter ses données, présentation, achat/usage/vente et tests nominaux/refus avec preuves liées aux sources courantes; si non, documenter l’exclusion historique avec une source explicite; (4) laisser runtime et acceptation séparés.

Reprise uniquement sur un nouvel élément probant : export natif décodé de 2001 avec provenance de release, entrée de manifeste/membership sélectionnée, ou règle serveur historique versionnée établissant son rôle et son admission. Le comparatif communautaire déjà lu ne suffit pas à trancher ce point. Ne pas refaire son hash ou les scans globaux sans modification de la ressource ou piste nouvelle.

## Relecture des critères de clôture

1. Exigence et frontière : identifiées ci-dessus.
2. Source, identité, provenance partielle et limites : documentées; champs et disponibilité serveur restent inconnus.
3. Consommateurs ou absence : catalogue, résolution Core, achat, UI et potion inspectés; absence bornée constatée.
4. Attendu/observé et contrôles : séparés; exécution runtime explicitement non faite.
5. Écarts et inconnues : listés.
6. Correction stable proposée avec critères; aucune modification fonctionnelle ni de registre effectuée.
7. Livrable daté, empreintes actuelles et reçus existants identifiés; relecture effectuée.

Cette unité ferme seulement l’inventaire statique du consumer Rust pour l’ID 2001. La fidélité de l’objet, les autres liens d’exigence, SYS-01.2-02, D01-SYS-01-1 et la complétion du jeu restent ouverts.
