# SYS-01.2-02 — item 3135 : pénétration magique et consumer courant

Date : 2026-11-02. Unité : AUD-SYS01202-ITEM3135-MAGIC-PENETRATION-01. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839.

## Portée et décision

Cette unité suit le passif de pénétration magique de l’objet 3135 depuis la source 4.20 jusqu’aux données et consumers Rust actuels. Elle ne valide pas tout l’objet, l’interface de boutique complète, la politique serveur Riot ou la version entière du jeu.

Audit statique source→donnée→consumer : terminé pour le champ PercentMagicPenetrationMod de l’ID 3135. Implémentation locale : présente dans le catalogue et le calcul de dégâts. Vérification actuelle par exécution : non établie; les anciennes preuves ne sont pas fraîches. Acceptation humaine : non demandée. Fonctionnalité complète et tâche parente : non déclarées terminées.

## Source et provenance

Le comparatif docs/fidelity_community_review_4_20.json associe la ressource native DATA/Items/3135.inibin à RADS release 0.0.1.68, chemin D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items/3135.inibin, SHA-256 8602a39fc505a71a1892309675cc7a25a6bcd485706509a9aded8c7cd8985b94.

Le reçu existant compare 68 champs à l’export communautaire Items/3135/3135.json (SHA-256 a4d797fa4095a0a428d720a09bd5edfd70d2d0164732a2686ae91c92ae7bac67) : 68 égaux, 0 différence, 0 clé native absente. Le snapshot communautaire indique ContentFormatVersion 4; le commit exact du fichier n’est pas établi. Ces reçus sont réutilisés, les fichiers d’origine n’ont pas été rehashés.

Le reçu penetration_item_sources.json et le catalogue local reprennent le passif : +70 puissance et 35 % de résistance magique ignorée avant la pénétration magique. La valeur locale magic_penetration_percent=0.35 et le source_sha256 du catalogue correspondent à l’empreinte native ci-dessus. La règle serveur originale n’est pas récupérée; l’export communautaire et le catalogue 4.20.1 restent des corroborations, pas une exécution du serveur 4.20.0.315.

## Donnée et consommateurs actuels

data/4.20/shop_foundation.json, ID 3135 (ligne 681 et suivantes), déclare recette 1026+1052, prix 2295, AP 70, magic_penetration_percent 0.35 et unique_penetration=true. L’admission locale Map10 est true. SHA-256 actuel du catalogue : 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae.

- crates/core/src/shop.rs:223-234 agrège les bonus; pour un objet unique déjà compté, le passif de pénétration identique n’est pas repris, tandis que ses bonus AP continuent de s’additionner.
- crates/core/src/progression.rs:82-86 transmet magic_penetration_percent aux Stats du joueur.
- crates/core/src/penetration.rs:4-15 lit les bonus du joueur source. Pour MR positive, effective calcule MR × (1 − pénétration %) − pénétration plate, plancher à zéro; MR nulle ou négative reste inchangée. crates/core/src/damage.rs:91 et :119 emploie penetrated_defenses pour les champions et unités avant mitigation.
- Les tests présents dans penetration.rs couvrent le nominal numérique, les dégâts magiques avec achats d’objets, l’absence de mutation des défenses cible et la non-cumulabilité du passif 3135 en double achat. Ils ne sont pas exécutés dans ce lot.

Anciennes empreintes des preuves d’intégration du 4 octobre comparées aux fichiers actuels :
- penetration.rs : identique, 7a4e2b53c0f8bbcdd0c0047a880e393d2dfcfaa6e6496ddff6bc83acdc87fd41.
- shop.rs : ancienne ff91bc3deb0751e1edfd0cb5644698e2ba319d18ac63ed8609da35215b109062; actuelle 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0.
- progression.rs : ancienne 5fddb9706ebcde5133ffb72ac78f4cf8b26d4085da3d26d8a1c20370cb3e0964; actuelle eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766.
- damage.rs : ancienne d2cb9558808b8477c2b1be2aca102f23a1dba1452334df35b6d36c0c00f78329; actuelle 0d579a7b4e7a3941df7e70f78d62029c9f34df0c345749c2adc17153f9624387.
- shop_foundation.json : ancienne e9d650db86cfb7e6752a1a947838058c6a067cbaa2fec936dc41ccccaf7c8efc; actuelle 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae.

## Attendu, observé et contrôles

Attendu nominal : à MR 100, un seul Void Staff produit MR effective 65 avant mitigation si aucun bonus plat n’est présent. Attendu limite : les résistances non positives ne sont pas réduites davantage; deux achats de 3135 ne doublent pas le passif, mais les +70 AP s’additionnent. Les formules et tests sources concordent avec ces attentes.

Observé ce tour : cohérence statique du source, du catalogue, de l’admission Map10, de l’agrégateur, de Stats et du chemin de dégâts. Aucune formule, achat ou hit n’a été exécuté. penetration_integration_progress.json et penetration_live_validation.json datent du 4 octobre, indiquent complete=false, et les empreintes des consumers/catalogue diffèrent. La capture antérieure montre 3134 dans la boutique, pas 3135; le reçu réseau note que les nouveaux dégâts magiques n’y ont pas été vérifiés. Ces preuves ne qualifient donc pas le code actuel pour 3135.

Contrôles réellement exécutés : lecture ciblée des reçus source/intégration, extraction des champs JSON 3135 et Map10, inspection des ancres de code et tests présents, comparaison des empreintes consignées aux empreintes courantes. Aucun test, build, binaire, serveur ou runtime lancé.

## Écart et reprise

Le lien statique actuel est complet pour le passif 35 %. Restent à établir par preuve actuelle : achat et application de la pénétration en exécution sur les sources présentes; effet sur un champion et une unité; transmission réseau; sémantique serveur exacte et acceptation. Le catalogue visuel ou la capture 3134 ne couvre pas ces points.

Correction proposée, non inscrite au registre : OPEN-ITEM-3135-CURRENT-PENETRATION-VERIFY. Critères : revalider sur un build attaché aux empreintes actuelles (1) achat 3135 et Stat=0.35; (2) MR positive et négative avec résultat attendu; (3) doublon 3135 ne cumule pas la pénétration mais cumule AP; (4) résultat sur champion et unité via serveur/réseau; (5) conserver séparés fidélité serveur et acceptation humaine. Reprise sur une autorisation de vérification conforme aux consignes du dépôt, ou nouvelle preuve runtime liée aux sources actuelles.

## Relecture des critères de clôture

1. Exigence et frontière limitées à un champ de 3135.
2. Source native identifiée; comparaison communautaire et limites d’autorité rapportées.
3. Consumer et callsites actuels identifiés; tests sources reliés sans les présenter comme exécutés.
4. Attendu, constat statique, anciennes preuves et vérification non exécutée séparés.
5. Écarts et reprise précise documentés.
6. Correction proposée sans inscrire ou cocher une tâche.
7. Ancres, empreintes et date consignées; aucun source-code modifié.

Cette unité clôt la cartographie statique de 3135, pas l’exécution actuelle de l’effet, l’acceptation, la fiche parente SYS-01.2-02 ni le jeu complet.
