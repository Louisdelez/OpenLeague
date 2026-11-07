# SYS-01.2-02 — objet 1006, régénération de base des PV — V810

Date : 2026-11-02  
Projet : F:\OpenLeague  
Unité : AUD-SYS-01.2-02-ITEM1006-BASE-HP-REGEN-LINK-01  
Portée : champ PercentBaseHPRegenMod, relation source native → donnée locale → calcul courant.

## Résultat

**Audit borné clos.** Le champ natif 0,5 correspond à +50 % de régénération de base des PV dans le catalogue. Le calcul courant applique les bonus d’objets; le test ciblé vérifie l’achat de deux exemplaires, le cumul à 2× le taux de base, la vente d’un exemplaire et le recalcul après progression de niveau.

**Fonctionnalité et tâches parentes ouvertes.** Ce résultat ne termine pas l’objet 1006, sa boutique, ni SYS-01.2-02. Aucun statut ni acceptation n’a été modifié.

## Source et interprétation

La source native enregistrée pour la référence client 4.20.0.315 est DATA/Items/1006.inibin :

- source OLS-60f3e978-0395-543a-9a71-2dc78d2d8522 ;
- chemin D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1006.inibin ;
- taille consignée : 536 octets ;
- SHA-256 consigné : 9a3f1e1f2862760d12fa51beac8944e3d9e566aa8b6d13bded6f40144e388d48 ;
- identité client : 4.20.0.315 ;
- membership enregistré : manifeste lol_game_client, contenu 0.0.1.7, 536 octets et MD5 concordants.

Le reçu existant data/4.20/native_item_audit.json décode PercentBaseHPRegenMod = 0.5, Price = 180 et CanBeSold = true. Le catalogue local porte health_regen_percent = 0.5 et un source_sha256 identique au SHA-256 natif enregistré. Ces preuves d’identité et de décodage sont réutilisées; le binaire n’a pas été re-haché ni re-décodé dans V810.

## Consommateur courant

- data/4.20/shop_foundation.json contient l’objet 1006 avec health_regen_percent = 0.5 et group vide.
- data/4.20/map10_shop_admission.json indique allowed = true. Cela ne qualifie que cette donnée locale et cette carte.
- crates/core/src/shop.rs::bonuses additionne le health_regen_percent des objets détenus.
- crates/core/src/regeneration.rs::Simulation::regeneration_rates applique le facteur 1 + bonus à la régénération PV de base et à sa croissance; advance_regeneration applique le taux par tick, plafonné aux PV maximum.

Résultat attendu : un objet donne 1,5× le taux PV de base; deux objets cumulables donnent 2×; la vente d’un exemplaire ramène le taux à 1,5×.  
Résultat observé : la chaîne source → catalogue → agrégation des bonus → régénération correspond à ce contrat, et le test ci-dessous vérifie les trois valeurs ainsi que le recalcul après gain de niveau.

## Vérification exécutée

Commande hors ligne :

cargo test --offline -p openleague-core base_regeneration_percent_stacks_and_sale_removes_exact_modifier -- --nocapture

Résultat : shop::tests::base_regeneration_percent_stacks_and_sale_removes_exact_modifier ... ok; 1 réussi, 0 échoué; code de sortie Cargo 0.

Le test achète deux objets 1006, observe 2× le taux initial, vend un exemplaire et observe 1,5×, puis accorde de l’expérience et vérifie que le taux croît avec la statistique de base du niveau atteint. Il n’exerce pas un refus d’achat : aucun groupe unique n’est configuré pour cet objet dans la donnée locale, et le test vérifie explicitement le cumul.

## Limites et états ouverts

- ITEM-1006-SCOPE et ITEM-1006-SERVER restent partiel_a_terminer; les tâches boutique et acceptation liées à l’objet restent ouvertes. Aucun état du registre n’a été changé.
- Le test qualifie la sémantique du consommateur Rust actuel; il ne prouve pas l’exécution du serveur historique, le comportement réseau, le rendu boutique ou le parcours en client.
- L’admission Map10 n’a pas été testée comme refus sur une carte non admise.
- Aucun binaire client n’a été exécuté; l’identité et la valeur viennent des preuves natives déjà enregistrées.
- Le prérequis D01-SYS-01-1 de la tâche parent SYS-01.2-02 demeure non accepté selon l’état consigné V805.

Aucune correction de code n’est proposée pour ce lien : le chemin de calcul existe et le test courant passe. Les écarts restants relèvent des tâches existantes de scope, boutique et acceptation; ils ne sont pas couverts par cette unité.

## Reprise

Ne pas répéter l’extraction ni le hash de 1006 sans nouvel élément primaire. Poursuivre sur la relation requise 1004, PercentBaseMPRegenMod : ses sources et consumers sont identifiés, mais le test existant recensé porte sur l’exclusion d’un champion sans mana; un cas nominal positif pour un champion utilisant le mana reste à vérifier. Garder ITEM-1006 et SYS-01.2-02 ouverts jusqu’à leur procédure d’acceptation.

## Livrables et contrôles

Ajouté ou complété :

- docs/AUDIT_SYS01202_ITEM1006_BASE_HP_REGEN_LINK_2026-11-02.md
- docs/ai/CURRENT.md
- docs/ai/HANDOFF.md
- docs/resume_checkpoint.json

Aucun code, asset, registre de tâches, Plan, application de suivi, base applicative ou goal Codex n’a été modifié. Aucun logiciel installé ni migration appliquée.
