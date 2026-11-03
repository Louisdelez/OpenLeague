# SYS-01.2-02 — item 1011 : FlatHPPoolMod (V813)

Date : 2026-11-02

## Périmètre et critères

Cette unité relie la valeur native FlatHPPoolMod de l’objet 1011 à la donnée de boutique et au consommateur Rust courant. Elle se clôt pour ce lien si le reçu source 4.20 et la donnée locale correspondent, si le chemin de calcul est identifié, et si achat nominal, limite d’achat et retour après vente sont observés.

Elle ne clôt pas l’implémentation complète de Giant’s Belt, ITEM-1011-SCOPE, ITEM-1011-SERVER, le prérequis D01-SYS-01-1 ou SYS-01.2-02.

## Source et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB. La date exacte du build demeure celle du référentiel courant; le fuseau et le déploiement ne sont pas établis ici.
- Source native enregistrée : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1011.inibin.
- Entrée fidelity_sources_4_20.json : OLS-f8e5fecb-5d3b-5826-a19a-24af43e2df5d; version 4.20.0.315; 560 octets; identity verified=true; SHA-256 e9431e7c57900819bb504786ca78037f9a734db98162e46a7bed1585466ee597.
- Reçu natif data/4.20/native_item_audit.json réutilisé sans relecture ni re-hash : FlatHPPoolMod=380; Price=1000; InStore=true; CanBeSold=true.
- data/4.20/shop_foundation.json : health=380, price=1000, sell_price=700, source_sha256 identique à la source enregistrée. data/4.20/map10_shop_admission.json : item 1011 allowed=true.

Le membership RADS n’a pas été recalculé dans V813. La provenance déclarée par le registre et l’égalité d’empreinte catalogue/source sont reprises des éléments locaux existants.

## Consommateur courant identifié

- crates/core/src/shop.rs::buy_item contrôle l’état du joueur, la boutique alliée, l’admission Map10, la recette, le prix et l’or; l’item admis est ajouté à l’inventaire.
- crates/core/src/shop.rs::bonuses additionne item.bonuses.health.
- crates/core/src/progression.rs::stats calcule max_health = base.health + croissance de niveau + items.health.
- Après achat et vente, crates/core/src/shop.rs::refresh_item_caps recalcule max_health et borne la vie courante au nouveau maximum.
- Le chemin exécuté appartient à la simulation locale Map10; il n’établit pas la sémantique historique du serveur Riot.

## Vérification exécutée

Probe Rust temporaire hors du dépôt, lié au crate local openleague-core et à la navigation TT embarquée. Garen a été placé au spawn Map10. L’or a été fixé à 999 pour le refus, puis à 1000 pour l’achat nominal. La vente a été faite à la boutique alliée.

| Cas | Attendu | Observé |
|---|---|---|
| 999 or | refus sans mutation | refus lié à l’or; or, inventaire et PV max inchangés |
| achat à 1000 or | +380 PV max | 616,280 → 996,280 PV max; vie courante conservée |
| vente de 1011 | retrait du bonus; remboursement catalogue 700 | PV max revient à 616,280; slot vidé; or=700 |

Résultat final : PASS, cargo run --offline, code 0. Le crate openleague-core a été compilé à partir des sources courantes; Cargo a émis 24 avertissements non bloquants. La sonde temporaire sous E:\mapslol3v3 a été supprimée. Les artefacts Cargo générés sont dans le target existant de F:\OpenLeague; aucun binaire n’a été installé ni lancé comme jeu.

## Limites et état

- Audit du lien source → catalogue → consommation des PV clos pour FlatHPPoolMod=380.
- Aucune preuve de classement historique côté serveur, de disponibilité globale hors admission locale Map10, de cumul de copies ou de sémantique native d’ajustement des PV courants.
- ITEM-1011-SCOPE et ITEM-1011-SERVER restent partiels; acceptance_complete=false. Le registre des tâches et les statuts n’ont pas été modifiés.
- Aucun code source produit, plan, application de suivi, base de données ou goal Codex modifié; aucune installation ni migration.
- D01-SYS-01-1 reste non accepté. La tâche parent SYS-01.2-02 et le goal global restent ouverts.

Prochaine unité : sélectionner un lien requis distinct des lots 1001, 1004, 1006 et 1011 avec une source native réutilisable et un consommateur actuel identifié; vérifier une réussite et une limite sur une seule unité, sans répéter les recherches déjà documentées ni changer les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; docs/AUDIT_SYS01202_ITEM1004_BASE_MP_REGEN_LINK_2026-11-02.md.
