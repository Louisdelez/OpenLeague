# AUD-17.1-05-COUNT-01 — Six compteurs de quantités d'inventaire

Contrôle du 30 octobre 2026, reçu produit à 12:39:23 UTC. Parent SYS-17.1-05 « Afficher l’inventaire et les charges d’objet » ; liens de texte/police SYS-22.1-04/06 ; règle de quantités connexe SYS-07.2-08. Résultat documentaire de SYS-01.2-02. Goal, jeu, suivi et bases inchangés.

## 1. Périmètre, critère de fin et décision

Question : d'où viennent InventoryItemCount0..5, quelles données les alimentent, quand sont-ils affichés ou masqués, et que signifie leur quantité ?

Critère de fin : six définitions uniques reliées aux octets du layout original, à leurs consommateurs actuels et à leur catalogue ; normalisation et refus identifiés ; preuve ciblée existante vérifiée ; limites et conditions de reprise documentées. Le périmètre est celui des six compteurs de pile, avec leurs dépendances de slot/icône nécessaires. Il exclut toutes les charges d'instance, tous les actifs, l'équivalence de l'input natif et le rendu complet de l'inventaire.

**Audit terminé pour les six compteurs et leur frontière de quantité.** La tâche générale SYS-17.1-05 reste ouverte : ces compteurs de piles ne constituent pas un système complet de charges d'objet.

| Dimension | État |
|---|---|
| Audit | Terminé dans le périmètre des six Text et des règles actuelles décrites |
| Implémentation | Six compteurs raccordés ; affichage des piles des deux potions prises en charge ; pas de charges d'instance génériques lues par ce chemin |
| Vérification | Identités, source et règles contrôlées ; un test ciblé hérité réutilisé ; neuf cas déduits du code, sans nouvelle exécution Rust |
| Acceptation humaine | Non demandée |

## 2. Sources et provenance vérifiées

Le layout original est `HUD/Elements/ShadowIslesChampionLeft.ini`, membre 90 de HUD.zip : 20826 octets, SHA256 `7a23abc56478e252a3d3174e24d4cbf8cbb8e03ae71f8f1ec6cb6c581bd1cf14`. Il est identique dans les archives du projet et du deploy fourni, ainsi qu'aux octets capturés dans `data/4.20/native_hud_source_records_contract.json` le 6 octobre 2026.

Archives comparées :

- `F:/OpenLeague/data/4.20/archives/menu/HUD.zip`.
- `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip`.

Les deux archives font 122169 octets, SHA256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`. L'égalité des copies reste distincte de leur appartenance à une release/priorité de montage historique, non qualifiée en V226.

Les six noms, offsets, empreintes et IDs HUD de l'inventaire HUD-01 sont conservés. Chaque définition appartient à HUDLeftOverlay, couche 6, Arial taille 11, centrée ; Enabled:0 et flags capturés 0x10. La propriété Arial ne qualifie pas à elle seule la fonte effectivement rasterisée. Les six Text sont activés seulement dans leurs copies possédées par le consommateur.

`data/4.20/shop_foundation.json` et `native_inventory_icons.json` désignent les mêmes 33 IDs uniques. Le shop_sha256 du manifeste correspond toujours aux octets du catalogue courant. Parmi eux, seuls 2003 et 2004 satisfont le prédicat d'affichage d'une pile : consumable présent et max_stack supérieur à un. Le maximum local est cinq pour chacun.

Les deux INIBIN fournis sont rehashés contre les champs hérités de `docs/reference_item_shop_sources/item_shop-links.json` : 2003, SHA256 `a78328ea459393cb74caf367bc2bbe305f43acd97b89712ff121552c589dc737` ; 2004, SHA256 `aebe87e1d8f93ab561f0b01dd9b0c5cc4313eef63f3a51dfb4129cc5691e78e9`. Les champs MaxStack:5 et ItemGroup:HealthPotion/ManaPotion sont des données de client, pas le code du serveur Riot. Leur décodage n'est pas réexécuté ici.

V217 fournit déjà les 33 ponts INIBIN Data/InventoryIcon → DDS natif → DDS consommé. Les trois identités de chaque pont sont vérifiées à nouveau, sans copier ni reconstruire de texture. Le libellé descriptif « 32-item » du manifeste reste une anomalie ancienne déjà documentée en V217 ; ses 33 entrées réelles sont prises en compte. Aucun manque d'icône dans ce catalogue courant n'est inventé.

## 3. Consommateurs réels et sémantique des quantités

Le plugin est enregistré dans `crates/client/src/main.rs:691`. Dans `native_hud_inventory.rs` :

- sources, lignes 36-57 : retrouve exactement les six icônes InventoryItem0..5 et les six Text InventoryItemCount0..5 ; refuse mauvais type, doublon ou source manquante ; préserve l'ordre global des demandes de police dans les copies.
- values, lignes 17-29 : sélectionne le joueur indiqué, parcourt ses six slots, exige un objet du catalogue, lit shop::inventory_count et refuse une quantité supérieure à la limite du slot.
- count_text, ligne 31 : affiche un entier seulement si l'objet est empilable selon le prédicat local ; un objet ordinaire ou un slot vide n'affiche pas de compteur.
- prepare_counts, lignes 132-140 : active/désactive chaque copie selon la présence du texte ; écrit un tampon de 256 octets initialement nul ; associe la demande de police globale au slot. count est u8, donc son texte a au plus trois chiffres ; avec le catalogue actuel, les valeurs affichables sont 1..5. Une garde de débordement manquante n'est pas déduite de l'absence d'un test de longueur explicite ici.
- update_counts, lignes 142-165 : efface les glyphes si snapshot/joueur/valeurs/fenêtre ou hauteur de police sont indisponibles ; refuse le non-ASCII et les erreurs de copie ; reconstruit les glyphes après changement de signature. Ce lot n'établit pas l'équivalence GPU ni toute la durée de vie des handles.

### Zéro brut, quantité de pile et charge : trois notions distinctes

`Champion.inventory` et `inventory_counts` sont des tableaux de six éléments, avec serde(default), dans `crates/core/src/lib.rs:175-178`. `shop::inventory_count`, lignes 82-84, renvoie zéro pour un slot vide ; pour un slot occupé, il renvoie inventory_counts[slot].max(1).

Ainsi, une quantité brute nulle avec un objet présent est interprétée comme une unité. Un champ inventory_counts absent à la désérialisation et un tableau explicitement nul se rejoignent dans cette représentation. C'est la convention locale actuelle de compatibilité ; **le HUD ne rejette pas ce zéro**. L'audit ne la transforme pas arbitrairement en erreur sans traiter les états hérités.

La limite dans values s'applique à chaque slot. Le consommateur d'achat `shop::quote_with_counts:85-92` est différent : il additionne les unités du même objet dans tous les slots avant d'autoriser une unité supplémentaire. Un état de deux piles 3+3 passe le contrôle individuel du HUD ; l'achat local d'une unité supplémentaire est refusé par owned>=5. Ce constat de code n'est ni une exécution nouvelle de cette situation, ni une preuve que le serveur local produit normalement cet état, ni une définition exhaustive de la politique historique.

La vente et la consommation retirent une unité et effacent le slot à la dernière unité ; le déplacement échange les tableaux d'objets et de quantités. Ces règles se trouvent dans shop.rs:307-309,345-346 et consumables.rs:22. Le chemin audité lit une quantité de consommables ; il ne lit pas de modèle générique de charges attachées à une instance d'objet. D'autres mécaniques spécifiques du projet ne sont pas déclarées absentes sur cette seule observation.

## 4. Contrôles exécutés et attendu/observé

Commande exécutée, code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.1-05-COUNT-01/audit_inventory_counts.py`.

| Contrôle actuel | Attendu / observé |
|---|---|
| Réutilisation HUD-01 | Identité du reçu et des 498 sources du corpus : inchangées |
| Source des six Text | Deux membres exacts, six noms/slots/IDs uniques, même source capturée, flags désactivés : conforme |
| Catalogue et quantités | Même ensemble de 33 IDs ; deux potions empilables de limite cinq ; INIBIN correspondants identiques : conforme |
| Icônes héritées | 33 associations V217, configurations et DDS source/copie identiques : conforme |
| Reçu de test | Log, binaire et dix entrées déclarées conformes aux empreintes héritées : conforme |
| Raccordement des audits Text | Ensemble sélectionné de 25 IDs, sans doublon entre les trois consommateurs : conforme |
| Conservation | Dix-neuf fichiers logiciels gelés toujours identiques à WITHDRAWAL_INVENTORY.json ; aucune base ouverte |
| Relecture indépendante | Six propriétés de Text, 33 ponts d'icônes, dix entrées et neuf cas statiques correctement distingués des exécutions : PASS |

Le test réutilisé est `native_hud_inventory::tests::original_six_slots_counts_and_all_playable_dds_are_used_without_replacement`, exécuté le 23 octobre 2026 à 13:50:38.876186 UTC, code 0, un test passé, 1542 filtrés. Il couvre les définitions des six slots/compteurs, leurs propriétés/bindings et le décodage des 33 DDS. Il ne prouve pas à lui seul les transactions, le rendu des compteurs ou les cas de normalisation.

Reçu : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision215/CURRENT_BEVY_DDS_TESTS.json`, SHA256 `0dc1a45281802f5d85cc4bf027bcc52573436447960e22b027ef562924ef68cf`. Log : revision215/dds_test_2.log, SHA256 `6335f9759393857b0a83630d83ec505233004115bc62b14116ab9bb478aaad3b`. Binaire de test conservé : `F:/OpenLeague/target/debug/deps/openleague_client-170289a4dedad9dd.exe`, SHA256 `34bca123434a097ebb9430c8b1953eaef9116c850ae7244cf944112fd7637321`. C'est un binaire de test Rust ; aucun client historique exécuté ici.

Les dix entrées déclarées incluent le module inventaire et ses tests, tous deux inchangés. Elles ne couvrent pas toutes les dépendances transitives actuelles, notamment toutes les règles du core. Les quatre autres tests présents dans native_hud_inventory_tests.rs sont relus comme code disponible ; ce reçu ciblé ne permet pas de les compter comme quatre exécutions réussies supplémentaires.

Neuf cas de règles sont documentés par lecture du code, avec fresh_execution:false dans le JSON :

| Entrée | Résultat déduit du code actuel, pas observé par une nouvelle exécution |
|---|---|
| Joueur absent | Pas de valeurs, compteurs effacés |
| Slot vide, quantité brute non nulle | Slot ignoré ; ce chemin ne valide pas ce compteur brut |
| Bottes 1001, quantité brute 0 | Une unité normalisée ; pas de texte de pile |
| Potion 2003, quantité brute 0 | Une unité normalisée ; texte 1 |
| Potion 2003, quantité 5 | Texte 5 |
| Potion 2003, quantité 6 | Erreur de quantité ; valeurs non présentées |
| Bottes 1001, quantité 2 | Erreur de quantité |
| Objet hors catalogue | Erreur d'objet avant présentation de la quantité |
| Potion 2003 répartie 3+3 | Chaque slot passe ce HUD ; contrôle agrégé d'achat distinct |

Aucun nouveau test Rust, compilation, réseau, GPU, partie ou code natif exécuté. Aucun REA ni téléchargement nécessaires pour résoudre ces sources et règles. La reprise read-only du projet et Git a été exécutée ; HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 1943 entrées de changements préexistants. Aucun reset, staging, rollback ou lancement du suivi.

## 5. Couverture gagnée et clauses ouvertes

Les trois lots BUFF-01, NUMERIC-01 et le présent COUNT-01 couvrent maintenant les sources et règles des **25 Text sélectionnés** par les trois routes actuelles de glyphes : un compteur Ezreal, dix-huit textes numériques/raccourcis et six compteurs d'inventaire. L'union exacte des IDs est vérifiée, sans double comptage. Il s'agit de cette capture native de 154 Text et de ces consommateurs précis, pas de tous les textes du jeu.

Les 39 définitions de buff non sélectionnées ont déjà été classées dans BUFF-01. Il reste 90 autres enregistrements non sélectionnés à qualifier par contexte. Ces 90 lignes ne sont pas automatiquement 90 fonctionnalités manquantes. Les neuf routes de texte ordinaires de HUD-01 et leurs autres limites restent distinctes ; le parent SYS-22.1-04 n'est pas clos par cette réconciliation.

Manques établis : charges d'instance non traitées par ce consommateur, couverture d'objets limitée au catalogue courant, normalisation zéro/absence non séparée dans le DTO, admission agrégée non effectuée par le HUD, rendu et fidélité d'input non requalifiés. La convention max(1) et la séparation des contrôles ne sont pas automatiquement des défauts à corriger sans contrat.

Inconnues existantes conservées : `OLU-7a6c5e5b-4269-5e2c-a3a2-b770e4bde194` pour SYS-17.1-05 ; `OLU-64d55aba-4859-56ab-86c4-34b1430ed187` pour SYS-07.2-08, qui recense déjà les quantités héritées et la distinction entre piles et charges. Aucun nouveau doublon ajouté au suivi.

## 6. Corrections et conditions de reprise

Précisions documentaires sous les tâches existantes ; aucune réalisation fonctionnelle implicitement autorisée par ce lot.

| Clause / tâche | Résultat unique et critère de fin | Entrée de reprise |
|---|---|---|
| INV-RAW-COUNT-01 / SYS-07.2-08 | Versionner la signification d'un compteur absent, nul ou présent. Fin : contrat et cas explicites pour slot vide/occupé et états hérités ; ne pas remplacer max(1) en cassant les données précédentes | Décision de protocole/compatibilité et validation des producteurs de snapshots ; les champs serde et le helper sont déjà identifiés |
| INV-AGGREGATE-01 / SYS-07.2-08 | Qualifier l'admission d'une quantité répartie sur plusieurs slots, séparément du rendu. Fin : limite locale/historique attribuée, achat/chargement d'état cohérents et refus sans mutation pour les états non autorisés | Producteur concerné (achat, restauration ou migration de format) et règle d'autorité explicites ; le HUD n'est pas désigné arbitrairement comme serveur de validation |
| INV-INSTANCE-CHARGES-01 / SYS-17.1-05 | Pour le prochain objet nommé possédant des charges, identifier son état d'instance et sa projection puis le raccorder au slot correct. Fin : charge réelle, déplacement et disparition vérifiés ; aucune quantité de potions prise comme preuve de charge | Objet précis et source de sa mécanique, contrat serveur/projection et consommateur identifiés avant implémentation ; ne pas lancer une tâche globale « tous les objets » |
| INV-COUNT-RENDER-01 / SYS-22.1-06, SYS-17.1-05 | Qualifier les six compteurs après modification pertinente : vide, une unité, cinq, disparition, changement de slot/session et dimensions retenues. Fin : sources/binaires identifiés, attendu/observé et capture réelle distincte des tests CPU | Réutiliser les cinq tests existants selon leur pertinence ; contrôler les glyphes/ressources réellement affectés. Les styles et les 33 DDS n'exigent pas une nouvelle récupération |
| INV-CATALOG-01 / SYS-17.1-05 | Pour chaque nouvel objet admis par une tâche nommée, vérifier ID, icône, quantité ou charge et refus d'absence ; maintenir l'égalité catalogue/icônes. Fin limitée à l'objet ajouté | Nouvelle source ou implémentation admise. Les 33 icônes actuelles sont disponibles et préservées ; l'écart descriptif 32/33 demeure documenté |

La prochaine unité de classement des 90 Text restants doit être choisie par panneau/contexte dans HUD-01. Pas de nouvelle recherche de ces six définitions, ni de test inchangé sans piste ou modification ; les sources nécessaires sont déjà disponibles.

## 7. Livraison et relecture de clôture

Fichiers créés uniquement :

- `F:/OpenLeague/docs/audit/units/AUD-17.1-05-COUNT-01.md`, ce résultat.
- `F:/OpenLeague-work/audit-units/AUD-17.1-05-COUNT-01/audit_inventory_counts.py`, 14073 octets, SHA256 `a52fbaf3149e2e641595efc2247c8d46aaad7863f0127efd9619ca28e2c2e3dc`.
- `F:/OpenLeague-work/audit-units/AUD-17.1-05-COUNT-01/inventory-counts-proof.json`, 83799 octets, SHA256 `aa6494ec09affcc433ee22c596c0ed1233dc6a676399d9c4e0862cd46a4c08ec`.

Le JSON conserve six IDs et leurs propriétés, les deux membres comparés, 33 ponts d'icônes, les deux potions, les ancres de code, neuf déductions statiques, le test hérité et ses dix entrées, les associations/inconnues existantes et la réconciliation des 25 IDs sélectionnés. Les preuves antérieures sont conservées et leur identité contrôlée ; aucune ressource reconstruite dans ce lot.

Relecture des sept rubriques : portée, provenance, consommateurs, attendu/observé, écarts, reprise et preuves satisfaites pour cette unité. Aucun pourcentage de jeu terminé, aucune tâche parente cochée, aucune acceptation ou exécution nouvelle inventée. Les 19 fichiers logiciels gelés, le Goal, le jeu, les registres du suivi et ses bases restent inchangés ; aucune installation ni migration.
