# AUD-SYS-01.2-02 — Objet 1056, passif et cumul

Lot d’audit : AUD-SYS-01.2-02-ITEM1056-PASSIF-LINK-01

Date de contrôle : 2026-11-02  
Tâche : ITEM-1056-SERVER-PASSIF  
Requirement ID : OLF-ecdb2265-b273-5dec-b583-9a93b26d2db8  
Consommateur associé dans la trace : OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b

## Résultat borné

L’audit de liaison source–consommateur est clos pour le passif d’élimination de Doran’s Ring. Le catalogue officiel 4.20.1 dit que l’objet restaure 4 mana après l’élimination d’une unité. Un miroir communautaire dérivé de l’INIBIN associe Effect1Amount=4 et MaxStack=1 au même objet. Le miroir concorde avec le texte officiel, mais n’est pas un binaire serveur ni une preuve autonome de sémantique.

Dans le code courant, les morts d’unités traitent l’or, l’expérience et un hook de passif Trundle; les morts de champions passent par le registre de kills. Ces chemins n’appliquent pas de passif d’objet ou de restauration de mana. L’objet 1056 ne figure pas au catalogue jouable et son achat est refusé. Le comportement et les règles de cumul ne sont donc pas implémentés.

## Frontières du contrat

La tâche demande « implémenter son passif et ses règles de cumul ». La description officielle contient deux passifs : +3 mana regen par 5 secondes et restauration de 4 mana lors d’une élimination d’unité. La régénération plate est suivie séparément par ITEM-1056-SERVER-STAT-FlatMPRegenMod; ce lot couvre le déclenchement d’élimination et le cumul entre copies, pas la cadence de régénération.

La tâche reste status=a_faire, implementation_complete=false, acceptance_complete=false, required=false avec required_if conditionnel. L’INIBIN 1056 est membre vérifié du client 4.20 retenu; l’existence de l’objet rend la condition d’applicabilité pertinente. Aucun registre ni statut n’a été modifié.

## Sources et données

| Élément | Résultat |
|---|---|
| Référence client | docs/reference_client_4_20.json : 4.20.0.315, EUW, en_GB. |
| Ressource native | DATA/Items/1056.inibin; OLS-04ec5370-8428-5c53-925a-41f5fb787829; SHA-256 861cf0f8d1d7fb17098cfd76ea28991eb82467ab3361b4322c0124a43174b12c. Identité et membership lol_game_client release 0.0.1.68 réutilisés depuis le lot HEALTH-LINK; pas de rehash. |
| Référence officielle | OLS-b3343643-2fe6-513b-b286-7c03b86b8409, Data Dragon 4.20.1 en_US; SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. La description de /data/1056 dit « Restores 4 Mana upon killing a unit ». |
| Miroir communautaire | OLS-ee17f62d-f919-5d08-8377-1312d0e2faac, LeagueSandbox-Default, fichier fourni par l’utilisateur D:/LeagueOfLegendsV2/4.20/GameServer/Content/LeagueSandbox-Default/Items/1056/1056.json; 2 632 octets; SHA-256 courant 4b166001a01cae68b33d426b91334ac32d2a8fa788d0361b984570024fe5f74f, égal au registre. L’entrée annonce explicitement sa dérivation de l’INIBIN natif ci-dessus; snapshot Git modifié, base head a81a28558ea0aa4c543ae819f7ad3c4911a8bfe8, blob index 6fcb922e1fdf6a7433e4c68f873ebc01cb6e7a72. Elle contient Effect1Amount=4, MaxStack=1 et UNKNOWN_HASHES {4091408602:1}. Elle est un indice communautaire dérivé, pas une décision serveur Riot. |
| Export natif existant | data/4.20/native_item_audit.json n’énumère pas Effect1Amount pour 1056; l’étendue du décodeur ne permet pas d’en conclure que la clé est absente de l’INIBIN brut. |
| Catalogue jouable courant | shop_foundation.json n’a pas d’entrée 1056; absence établie dans les lots santé et statistiques précédents. |
| Code boutique | crates/core/src/shop.rs, SHA-256 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0. Item n’a pas de callback passif; max_stack n’est appliqué que dans la branche consumable, tandis que l’interdiction de copies utilise un champ group non vide. Sans entrée 1056, aucun groupe/passif de Doran n’est configuré. |
| Élimination d’unité | crates/core/src/damage.rs, SHA-256 0d579a7b4e7a3941df7e70f78d62029c9f34df0c345749c2adc17153f9624387, envoie les dégâts létaux sur une unité à world.damage_unit. crates/core/src/world.rs, SHA-256 407c75f77e8e4e06e6bea352f77ee3b4f90eb3357dd74cddc05a22e219651c54, retire les cibles mortes, crédite l’or et l’expérience et appelle Trundle; aucune lecture d’inventaire ni restauration de mana. |
| Élimination d’un champion | damage.rs appelle champion_kills::reward_champion_death; crates/core/src/champion_kills.rs SHA-256 b76edcb97eaf222e32bda215592a950807bd1923394d7e2aedf62e3ed4c27859 gère scores, assistances, or et événements de champion, sans passif d’objet. |
| Passif de revenu | crates/core/src/passive_gold.rs SHA-256 91e227659b546b81e53b2f5ed6e6eeada290a18f5a3639d24fa664ddc12d4b65 commente explicitement que les modificateurs de revenu passif d’objet restent non pris en charge; ce module ne traite pas la restauration de mana à l’élimination. |

## Attendu, observé et limites

**Attendu de référence :** une élimination d’unité attribuée au porteur de Doran’s Ring restaure 4 mana selon le texte du catalogue 4.20.1. Le miroir communautaire attribue la valeur 4 à Effect1Amount. Le plafond de mana, l’éligibilité des unités, les éliminations environnementales et l’effet avec plusieurs anneaux ne sont pas qualifiés par ces données seules.

**Observé dans le code courant :** le chemin d’élimination des unités et celui des champions existent, mais ne consultent pas les objets pour appliquer ce passif. L’achat de 1056 échoue en amont avec « item behavior not implemented ». Aucun cas n’a été exécuté pendant ce lot.

**Cumul :** MaxStack=1 dans le miroir ne prouve pas que le joueur ne peut posséder qu’un anneau. Le code ne consulte MaxStack pour les objets non consommables; l’unicité inter-copies dépend d’un group non vide, absent puisque la ligne 1056 n’existe pas. La règle historique de cumul du passif demeure inconnue.

## Reprise précise

Reprendre la qualification de l’effet à partir d’un mapping de clé INIBIN documenté ou d’une source serveur primaire 4.20; réutiliser l’identité et le membership déjà vérifiés. Pour le cumul, obtenir une règle historique indiquant si plusieurs copies sont achetables et si chaque copie déclenche le passif. Ensuite, relier la ligne d’objet au hook d’élimination existant et vérifier une élimination de lane minion/monstre, un refus pertinent, plafond de mana, victime non éligible, et une/deux copies. Attacher un reçu à jour au code et aux données effectivement exécutés. La valeur du passif de régénération de mana reste dans sa tâche séparée.

Ce lot clôt l’audit de l’absence du consommateur et documente les limites des sources. La mécanique, les règles de cumul, la vérification runtime et l’acceptation restent ouvertes; SYS-01.2-02 demeure actif et partiel.

## Contrôles réellement exécutés

- lecture ciblée du contrat, de la trace et de l’état de tâche;
- réutilisation du hash et membership de l’INIBIN 1056 vérifiés précédemment;
- rehash du miroir communautaire 1056 et comparaison à son entrée du source registry;
- parsing des champs MetaData/Values du miroir et lecture de la description officielle déjà enregistrée;
- recherche bornée des callsites d’élimination et inspections de shop.rs, world.rs, damage.rs, champion_kills.rs et passive_gold.rs;
- aucune exécution de test, build ou jeu.

Aucun code, registre de suivi, goal, application de suivi ou base de données n’a été modifié.