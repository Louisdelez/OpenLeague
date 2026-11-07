# SYS-01.2-02 — objet 1001, vitesse de déplacement — V809

Date : 2026-11-02  
Projet : F:\OpenLeague  
Portée : liaison bornée entre la donnée native 4.20, le catalogue local et le consommateur courant.

## Résultat du lot

**Sous-audit source → consommateur clos.** Le bonus de déplacement de Bottes de vitesse est relié à son champ natif, au catalogue local et au calcul de vitesse courant. Le test ciblé confirme achat, bonus, refus du doublon et retrait du bonus après vente.

**La fonctionnalité n’est pas déclarée terminée.** Aucun état de tâche, d’acceptation, de registre ou de goal n’a été modifié.

## Contrat et preuve source

La source native déjà inventoriée est DATA/Items/1001.inibin du client LoL 4.20.0.315 :

- identifiant de source : OLS-4a8e6b0e-b13a-505e-a6d5-2b3c47efc3bc ;
- chemin : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1001.inibin ;
- taille et SHA-256 consignés : 582 octets, 017500a7925ca2db83df2a652668c482d09120d014248ba8cdd167ce6b216d08 ;
- extraction antérieure du champ : FlatMovementSpeedMod = 25.

Cette preuve native et son empreinte sont réutilisées; elles n’ont pas été re-hachées pendant V809.

## Intégration locale observée

- data/4.20/shop_foundation.json, objet 1001 : move_speed = 25, group = BootsNormal, prix 325, vente 227 et source_sha256 identique à l’empreinte native ci-dessus.
- data/4.20/map10_shop_admission.json : l’objet 1001 est admis (allowed = true).
- crates/core/src/shop.rs::bonuses agrège le bonus move_speed des objets en inventaire.
- crates/core/src/movement.rs::Simulation::movement_speed additionne ce bonus à la vitesse de base du champion, puis passe la valeur aux modificateurs de déplacement courants.

Résultat attendu : l’achat de l’objet 1001 ajoute 25 à la statistique de déplacement; le groupe unique empêche un doublon; vendre l’objet retire son bonus.  
Résultat observé : les données et le consommateur correspondent à ce contrat, et le test ci-dessous confirme ces trois comportements.

## Vérification exécutée

Commande, hors ligne :

cargo test --offline -p openleague-core boots_group_is_unique_and_dagger_changes_attack_cadence -- --nocapture

Résultat ciblé observé : shop::tests::boots_group_is_unique_and_dagger_changes_attack_cadence ... ok; 1 réussi, 0 échoué, code de sortie Cargo 0.

Le test achète 1001, vérifie vitesse_initiale + 25, vérifie que l’achat d’un second objet du même groupe est refusé et que l’or n’a pas été débité, puis vend le premier objet et vérifie le retour à la vitesse initiale. La commande a été réexécutée deux fois dans cette reprise afin d’isoler sa ligne de résultat après une première sortie non récupérée; aucun autre test n’a été ajouté.

## Critère de clôture et limites

Clôturé pour ce lot : concordance du champ natif déjà prouvé, du catalogue local et du consommateur courant; résultat nominal et refus pertinent vérifiés par le test.

Restent ouverts :

- ITEM-1001-SCOPE est recensée partiel_a_terminer; ITEM-1001-SERVER-STAT-FlatMovementSpeedMod reste a_faire. Ces états sont laissés intacts.
- Le prérequis d’acceptation D01-SYS-01-1 de SYS-01.2-02 n’est pas satisfait; ce constat ne vaut donc ni intégration acceptée ni clôture de l’exigence globale.
- Le test n’exerce pas le refus de politique de carte, le mouvement en session réelle, le rendu client, le réseau ou la comparaison de distance parcourue. Le test existant movement::tests::native_q_and_boots_speed_match_actual_thirty_tick_walk_distance n’a pas été exécuté dans ce lot.
- L’admission Map10 est une donnée locale constatée; elle ne prouve pas le comportement sur les autres cartes.
- La preuve native est héritée du reçu précédent; aucune nouvelle lecture de binaire ni recherche externe n’a été effectuée.

### Condition de reprise

Ne pas répéter l’extraction native ni la comparaison de valeur sans nouvelle source. Après satisfaction et acceptation du prérequis D01-SYS-01-1, reprendre le consommateur avec le test de distance de déplacement existant, puis traiter les contrôles de carte/session explicitement requis par le contrat. Garder la tâche et l’exigence ouvertes jusqu’à leur processus normal d’acceptation.

## Modifications et contrôles

Fichiers documentaires ajoutés ou complétés pour V809 :

- docs/AUDIT_SYS01202_ITEM1001_MOVEMENT_SPEED_2026-11-02.md
- docs/ai/CURRENT.md
- docs/ai/HANDOFF.md
- docs/resume_checkpoint.json

Aucun code, asset, registre de tâches, Plan, application de suivi, base de données applicative ou goal Codex n’a été modifié. Aucun logiciel installé ni migration appliquée.
