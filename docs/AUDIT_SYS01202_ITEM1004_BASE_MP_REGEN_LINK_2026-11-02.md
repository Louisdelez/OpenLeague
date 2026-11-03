# SYS-01.2-02 — item 1004 : PercentBaseMPRegenMod (V812)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité audite uniquement le lien entre le champ natif de l’objet 1004, sa donnée locale et son consommateur Rust courant. Le sous-audit se ferme si le reçu natif déjà enregistré correspond à la donnée locale, si le chemin d’application est identifié, et si un cas nominal en partie ainsi qu’une limite pertinente sont observés ou explicitement laissés ouvertes.

Ce résultat ne clôt ni les fonctionnalités de boutique/régénération, ni ITEM-1004-SCOPE, ITEM-1004-SERVER, les tâches enfants, le prérequis D01-SYS-01-1 ou SYS-01.2-02.

## Source 4.20 et donnée locale

- Référence client : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB; build littéral 2014-11-17 17:46:45. Fuseau et date de déploiement non établis.
- Fichier natif : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1004.inibin.
- Reçu natif réutilisé, non re-haché durant V812 : OLS-0122f422-2fd9-5404-a8af-6bdf08c07ee6; 545 octets; SHA-256 419502ab9518d8796f5aea415eb8c5837beeae2f83a937acae68ed98555d61c5.
- Valeur décodée déjà reçue : PercentBaseMPRegenMod=0.25; Price=180; InStore=true; CanBeSold=true.
- data/4.20/shop_foundation.json contient item 1004 avec mana_regen_percent=0.25, price=180, sell_price=126 et source_sha256 identique au reçu natif. data/4.20/map10_shop_admission.json admet l’objet sur Map10.

Le binaire natif et son manifeste n’ont pas été relus ni re-hachés dans ce lot; les identités ci-dessus viennent des reçus antérieurs.

## Consommateur courant identifié

- crates/core/src/shop.rs:261–288 : buy_item contrôle le garde boutique, la politique Map10 et les données catalogue; l’achat nominal a été accepté.
- crates/core/src/shop.rs:215–240 : bonuses additionne le mana_regen_percent des objets détenus.
- crates/core/src/regeneration.rs:10–27 : regeneration_rates calcule la régénération de base plus croissance de niveau, puis applique 1 + le bonus objet lorsque le champion utilise le mana. La politique lifecycle distincte détermine si une ressource est restaurée.
- crates/core/src/regeneration.rs:32–48 et crates/core/src/lib.rs:739 : l’application réelle ajoute le taux par tick; TICK_RATE vaut 30.
- Le chemin observé est celui de la simulation Map10 locale; il ne prouve pas les règles serveur historiques de Riot.

## Vérification nominale exécutée

Un petit programme Rust temporaire, hors du dépôt OpenLeague, a référencé le crate local openleague-core et les données de navigation TT déjà présentes. Il a créé une simulation Map10, rejoint Ahri, acheté 1004, déplacé le champion sur un point navigable hors de la zone de fontaine, exécuté 30 ticks, puis ramené Ahri à sa boutique avant la vente.

| Mesure | Attendu | Observé |
|---|---:|---:|
| Ahri sans 1004 | taux de base | 1,200000 mana/s |
| Ahri avec un 1004 | base × 1,25 | 1,500000 mana/s |
| Gain effectif sur 30 ticks hors fontaine | environ 1,5 mana | 1,500092 mana |
| Taux après vente | retour à la base | 1,200000 mana/s |

Résultat final du programme : PASS, code Cargo 0. Commande exécutée : cargo run --offline sur un manifeste temporaire, avec un target-dir temporaire sous E:\mapslol3v3; ces fichiers temporaires ont été supprimés après le contrôle. Le crate local compile avec des avertissements Rust préexistants; aucune erreur de compilation n’a empêché le scénario final.

## Limites, refus et résultats réutilisés

- Le test unitaire courant mana_items_do_not_create_energy_or_manaless_resources a été exécuté dans le lot précédent : 1 passé, 0 échoué. Le code de ce test vérifie Ahri et la ressource énergie d’Akali; l’achat d’un objet mana n’a pas modifié le taux de ressource d’Akali. Ce résultat est réutilisé, pas rejoué dans V812.
- Aucun scénario d’achat de 1004 sur un champion sans mana n’a été exécuté ici. Le code applique le bonus uniquement à la branche uses_mana; un test ciblé avec achat sur champion sans mana reste à faire avant une couverture complète de cette limite.
- Le taux après vente a été vérifié, mais pas le remboursement en or, le cumul de plusieurs 1004, la croissance à plusieurs niveaux, ni les interactions de tous les types de ressources.
- La tentative initiale au spawn a mesuré 51,600067 mana sur une seconde à cause du soin périodique de fontaine; ce résultat a été écarté comme contaminé. Après déplacement hors fontaine, la mesure nominale ci-dessus passe.
- Une tentative de vente hors de la boutique a été refusée par outside allied shop, conformément au garde local. Ahri a ensuite été ramenée au spawn avant la vente nominale; le refus hors boutique n’est pas attribué à l’effet 1004.
- La disponibilité historique de l’objet côté serveur 4.20, les règles serveur exactes et l’acceptation du comportement restent non établies par cette simulation.

## État et reprise

- Sous-audit source → donnée → consommateur : clos pour PercentBaseMPRegenMod.
- ITEM-1004-SCOPE et ITEM-1004-SERVER restent partiels; acceptance_complete demeure false. Aucun état de tâche ou registre n’a été modifié.
- Aucun code produit, Plan, UI, application, base de données ou goal n’a été modifié. Aucun logiciel installé, aucune migration exécutée.
- D01-SYS-01-1 demeure un prérequis non accepté selon le reçu antérieur V805.
- Les 131 horodatages non récupérables du checkpoint V811 restent null; V812 ne les a pas reconstruits ni modifiés.

Prochaine unité : choisir depuis les tâches SYS-01.2-02 encore ouvertes un lien source native → consommateur distinct des lots 1001, 1004 et 1006; confirmer d’abord qu’un reçu natif réutilisable et un consommateur courant existent; vérifier un cas nominal et une limite; ne pas rejouer les recherches déjà consignées ni modifier les statuts. D01-SYS-01-1 reste à valider.

Fichiers de référence : data/4.20/native_item_audit.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/regeneration.rs; docs/AUDIT_SYS01202_ITEM1006_BASE_HP_REGEN_LINK_2026-11-02.md; docs/AUDIT_RESUME_CHECKPOINT_TIMESTAMP_RECOVERY_2026-11-02.md.
