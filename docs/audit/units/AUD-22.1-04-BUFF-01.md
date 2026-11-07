# AUD-22.1-04-BUFF-01 — Compteurs des panneaux de buffs

Contrôle du 30 octobre 2026, preuve produite à 12:18:41 UTC. Parent principal SYS-22.1-04 ; clause connexe SYS-17.1-06. Résultat documentaire de SYS-01.2-02. Aucune modification du Goal, du suivi, de ses bases ou du jeu.

## 1. Périmètre, critères de sortie et décision

Question bornée : quelles sources fournissent les compteurs Text de CenterHUD_Buffs.ini et TargetBar_Buffs.ini, lesquels sont sélectionnés par les routes actuelles, et que reçoit réellement leur consommateur en matière de durée ?

Critères : qualifier les 32 BuffStack0..31 et les huit TargetBuffStack0..7 ; relier chaque définition à ses octets natifs et à l'inventaire courant ; préserver la réparation existante ; identifier le consommateur actuel, ses gardes et la frontière de durée ; préciser les corrections et conditions de reprise. Les quarante lignes conservent leurs identifiants documentaires HUD issus de HUD-01.

**Audit terminé pour ces quarante définitions de compteurs et leur raccordement actuel.** Les clauses générales de SYS-22.1-04 et SYS-17.1-06 restent ouvertes. Cette conclusion ne qualifie pas tous les buffs, leurs icônes, tooltips, durées, animations ou politiques de visibilité.

| Dimension | État et portée |
|---|---|
| Audit | Terminé sur les deux panneaux et la frontière de données du compteur actuel |
| Implémentation | Partielle : compteur privé d'Ezreal dans le premier emplacement ; allocation générique et durées non réalisées par ce chemin |
| Vérification | Comparaisons de données et de code exécutées ; quatre tests ciblés hérités, identités vérifiées ; aucun nouveau test Rust ou rendu |
| Acceptation humaine | Non demandée ; aucune acceptation du jeu déduite |

## 2. Sources, provenance et acquis préservés

Les ZIP fourni et local sont identiques : 122169 octets, SHA256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

- Source fournie : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip`.
- Copie consommée : `F:/OpenLeague/data/4.20/archives/menu/HUD.zip`.

| Membre exact dans chacun des ZIP | Index, octets | SHA256 |
|---|---|---|
| HUD/Elements/CenterHUD_Buffs.ini | 43 ; 45915 | a9d3ec42552998c63c9ac47f10d2ec7711225e1523fb083ba1011461eeb6f218 |
| HUD/Elements/TargetBar_Buffs.ini | 135 ; 11247 | ab26e62d3e67be6e21b5ffdaac138a1b7cdd93d6d8dc05bafd0ad6dcc9b567f5 |

Ces deux membres sont égaux aux octets capturés dans `data/4.20/native_hud_source_records_contract.json`, datée du 6 octobre 2026. Les quarante enregistrements sont reliés par chemin, nom, offset et empreinte à cette capture puis à HUD-01. La capture conserve ses limites de parseur/provider ; elle n'est pas réexécutée. L'égalité des copies ne qualifie pas la release ni la priorité historique de montage : V226 laissait déjà l'appartenance des ZIP aux deux manifestes RADS sélectionnés non qualifiée.

Réparation existante préservée : `data/4.20/hud_restored/HUD/Elements/TargetBar_Buffs.ini`, 11280 octets, SHA256 `504e33f7fe6b5cadbb9d7e6e5fcaa547710b0837f5da475bbd44f217e1efe709`. Elle est exactement l'entrée restored de `data/4.20/native_hud_file_loop_contract.json`. L'unique ligne ajoutée est `EffectColor1: 64, 64, 64, 100`. Les huit blocs de propriétés Text sont inchangés. Les anciens résultats de la boucle native passent de 39 à 40 éléments généraux et de sept à huit effets ; il s'agit de résultats hérités, pas d'une nouvelle exécution. La réparation concerne une couleur d'effet, pas un compteur Text manquant.

`native_zip_provider.rs:123-140`, qualified_hud_repair, vérifie l'identité originale puis l'identité réparée avant de fournir le panneau cible. CenterHUD_Buffs reste original. Aucun fichier de ressource n'a été réécrit dans ce lot.

## 3. Définitions et consommateurs réels

| Définitions | Propriétés natives relevées | Raccordement actuel établi |
|---|---|---|
| BuffStack0..31 | Groupe CenterBuffOverlay ; couche 3 ; Enabled:0 ; Arial, taille 15 ; Align Center | BuffStack0 seul est sélectionné par native_ezreal_passive_hud |
| TargetBuffStack0..7 | Groupe TargetBar ; couche 2 ; Enabled:0 ; Arial, taille 15 ; Align Center | Aucun des huit n'est sélectionné par les routes Text inspectées |

Les quarante flags capturés valent 0x10, bit d'activation désactivé, conformément à Enabled:0. Ce sont des identifiants de widgets et des champs numériques : aucune clé de traduction de nom de buff, ni valeur textuelle de durée, n'est portée par ces quarante blocs. La propriété source Arial ne suffit pas à désigner la police rasterisée ; V226 qualifie séparément la chaîne actuelle en_GB → Gill Sans MT Pro Medium → OTF.

Le corpus courant correspond aux 498 fichiers Rust de `crates/client/src` enregistrés dans HUD-01 ; leurs empreintes sont restées identiques. La recherche et la relecture antérieures des neuf routes de texte restent la borne de l'absence de sélection. Ce n'est ni un graphe d'appels Rust exhaustif, ni une preuve d'absence de tout système de buff dans le jeu.

Chaîne du seul compteur raccordé :

1. `main.rs:688` enregistre le plugin. Les branches de session/époque réinitialisent l'état ; les frames acceptées alimentent sa présentation vers 1212-1214.
2. `native_ezreal_passive_hud.rs:40-67` copie Buff0 et BuffStack0 depuis CenterHUD_Buffs, puis active ses copies ; le stockage source reste conservé. Le choix de l'emplacement zéro est local, pas un allocateur natif retrouvé.
3. `ezreal_r_passive_presentation.rs:61-75,182-236` contrôle session, propriétaire, champion Ezreal vivant, équipe/roster et fraîcheur ; la frontière de présentation comprend aussi époque, tick et horloge saine.
4. `native_ezreal_passive_hud.rs:97-115,195-221` accepte seulement 1..5, prépare un chiffre ASCII et les glyphes/icône natifs. Une donnée absente, zéro, périmée ou rejetée masque/retire le compteur. Les erreurs de copie/préparation ne produisent pas une valeur inventée.

### Frontière de durée identifiée

`crates/core/src/ezreal_passive.rs:8,14,43-72` possède la politique locale six secondes et le champ privé Buff.until. Cette reconstruction n'est pas le code serveur Riot récupéré. Le DTO OwnerPassive, ligne 83, ne contient que `session`, `owner`, `stacks` ; sa projection privée ne transmet aucune échéance.

La constante `FRESH_SECONDS = 0.2` de `ezreal_r_passive_presentation.rs:8` est un seuil de fraîcheur de présentation. **Ce n'est pas la durée du buff.** Le HUD ne peut pas déduire de ce seuil un compte à rebours autorisé. D'autres effets spécifiques disposent de données temporelles dans le jeu ; ce constat ne généralise pas l'absence de durée à tous les effets.

## 4. Contrôles exécutés, attendu et observé

Commande exécutée, code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-BUFF-01/audit_buff_panels.py`.

| Contrôle actuel | Attendu | Observé |
|---|---|---|
| Réutilisation HUD-01 | Inventaire et 498 sources inchangés avant réemploi | Empreintes conformes |
| Deux ZIP et deux membres | Membres uniques, mêmes octets que la capture | Conforme dans les deux conteneurs |
| Exhaustivité de ce lot | 32 noms centraux, huit noms cible, sans doublon | 40 identifiants reliés à leurs sources et propriétés |
| État initial | Source désactivée, sélection séparée de l'activation | 40 désactivés ; un seul sélectionné actuellement |
| Réparation TargetBar | Identité restored préservée, pas de compteur supprimé/modifié | Une ligne EffectColor1 ajoutée ; huit Text inchangés |
| Donnée de durée | Séparer échéance serveur, DTO et fraîcheur | until privé ; DTO sans échéance ; fraîcheur locale 0,2 seconde |
| Preuves de tests | Ne réutiliser que les identités vérifiées et conserver leur date | Quatre logs, binaire et 13 entrées déclarées conformes |
| Relecture indépendante du résultat | Noms uniques, cardinalités, flags, limites et absence de nouvelle exécution cohérents | PASS ; 19 fichiers logiciels gelés également identiques à l'inventaire de retrait |

Les quatre tests réutilisés ont été exécutés le 23 octobre 2026 de 14:21:01 à 14:21:04 UTC, en V221, puis relus et qualifiés en V222 après correction du collecteur de sortie FreeType. Ils couvrent respectivement : identité source/icône/ordre de police ; chiffres et redimensionnement sans mutation des widgets ; réemploi et retrait des handles ECS ; masquage zéro/absence/mort/identité/fin et absence de prédiction d'expiration. Tous les quatre : code 0, test nommé passé. Les gardes hors plage sont aussi explicites dans le code inspecté ; aucun refus nouveau n'est présenté comme testé ici.

Reçu : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision222/QUALIFIED_CURRENT_EZREAL_PASSIVE_TESTS.json`, SHA256 `0cc1e374715d23175583a5025cc75b1935f8e17af39e6dc458d59c0b35784b20`. Logs : revision221/dds_test_0.log à dds_test_3.log ; empreintes individuelles dans le JSON livré. Binaire de test : `F:/OpenLeague/target/debug/deps/openleague_client-170289a4dedad9dd.exe`, 352612864 octets, SHA256 `34bca123434a097ebb9430c8b1953eaef9116c850ae7244cf944112fd7637321`. Ce n'est pas le binaire historique exécuté.

L'identité des 13 entrées déclarées ne requalifie pas toutes les dépendances transitives du jeu actuel. Aucun test Rust, compilation, rendu, réseau, partie, parseur natif ou logiciel historique n'est relancé. Aucun REA supplémentaire, téléchargement ou installation nécessaire pour conclure ce périmètre. Aucun accès SQL ou lancement du suivi.

## 5. Écarts et conclusions ouvertes

- Les 39 définitions non sélectionnées ne représentent pas automatiquement 39 fonctionnalités manquantes. Les 32/8 positions ne prouvent pas non plus un plafond de buffs actifs dans le serveur historique.
- L'affectation générique des emplacements, leur ordre et la politique native de remplacement restent non qualifiés. Le premier emplacement d'Ezreal est un acquis local à protéger.
- La durée autorisée ne traverse pas ce DTO ; aucune durée complète de HUD n'est donc validée. Le rafraîchissement, la pause, la mort et la reconnexion devront être traités par un contrat de projection explicite avant réalisation.
- La présentation cible exige un contrat de visibilité et d'identité autorisées ; l'existence d'un emplacement TargetBuffStack n'autorise pas la diffusion de données privées d'un ennemi caché.
- Icônes autres que celle du passif qualifiée en V226, tooltips, rendu des durées et allocateur historique sortent de cet audit Text. Leur absence ou leur équivalence ne se déduit pas de ces seuls fichiers.
- L'origine exacte de release/montage des ZIP demeure la limite héritée. Sa reprise requiert une nouvelle preuve de manifeste/provider, pas une nouvelle copie identique du même ZIP.

L'inconnue existante `OLU-44e36fd3-396b-5405-9efd-a04f638cfcb5` sous SYS-17.1-06 reste ouverte. La fiche existante décrit déjà « owner-only Ezreal passive count ; generic buff/debuff duration and native slot allocation remain open ». Aucun nouveau blocage artificiel n'est ajouté pour fermer cet audit documentaire.

## 6. Corrections et reprise précises sous les tâches existantes

Ce tableau précise des clauses documentaires ; il ne crée ni ne modifie de tâche dans le suivi. Une réalisation fonctionnelle requiert un périmètre distinct autorisé.

| Clause documentaire / tâche existante | Résultat unique et critère de fin | Entrée de reprise et bornes |
|---|---|---|
| BUFF-OWNER-SLOTS-01 / SYS-17.1-06 | Définir puis vérifier l'attribution des compteurs du propriétaire aux effets autorisés. Identifier chaque emplacement utilisé ; contrôler ajout, retrait, réemploi et changement de session ; préserver Ezreal BuffStack0 tant que son remplacement n'est pas qualifié | Contrat d'identité/visibilité des effets et politique d'ordre documentés. Sources de layout disponibles ; allocateur natif à retrouver si l'on revendique sa fidélité. Ne pas activer les 32 champs sans données |
| BUFF-OWNER-DURATION-01 / SYS-17.1-06, dépendance SYS-15.2-04 | Pour le passif Ezreal seulement, définir une projection autorisée de l'échéance et de son horloge puis vérifier application, rafraîchissement, expiration, pause, mort et reconnexion. Refuser ou masquer durée absente/périmée/incohérente, sans déduire la durée de la fraîcheur client | Politique locale déjà identifiée ; décision explicite sur champs/version/sémantique du DTO et visibilité. Fin conditionnée aux résultats attendus/observés serveur→snapshot→HUD, pas seulement à un champ ajouté |
| BUFF-TARGET-IDENTITY-01 / SYS-13.3-02 puis SYS-17.1-06 | Définir, pour une cible nommée, quels effets/comptages/durées sont publics ; vérifier changement de cible, perte de vision et de session avant branchement aux huit compteurs | Projection par spectateur autorisée et contrat local/natif identifié. Fin : aucune donnée privée exposée dans les cas de refus ; aucune valeur périmée conservée sur la nouvelle cible |
| BUFF-COUNTER-FORMAT-01 / SYS-22.1-04, complément SYS-22.1-06 | Raccorder chaque compteur réellement utilisé à sa source et à ses glyphes ; vérifier chiffres, masquage et rendu. Garder les identifiants de layout distincts des noms/tooltips traduits | Réutiliser V226 et les 40 lignes du présent résultat. Reprendre les tests uniquement après modification, anomalie ou nouvel environnement à qualifier ; rendu restant à observer |

Pas de recherche native répétée sur ces mêmes layouts : les sources du lot sont disponibles et comparées. Pour l'allocateur, un nouvel appelant ou une nouvelle trace d'affectation sera nécessaire ; pour la durée locale, le DTO et l'autorité serveur constituent la prochaine frontière concrète. Les fonctionnalités générales parentes restent ouvertes indépendamment de la clôture de ce sous-audit.

## 7. Livraison, relecture et conservation

Fichiers créés dans ce lot :

- `F:/OpenLeague/docs/audit/units/AUD-22.1-04-BUFF-01.md`, ce résultat en sept rubriques.
- `F:/OpenLeague-work/audit-units/AUD-22.1-04-BUFF-01/audit_buff_panels.py`, 8959 octets, SHA256 `8d95159d038cb0ef0dc22cd8e4df22bca2b184feebeb3b50e15b391757d04057`.
- `F:/OpenLeague-work/audit-units/AUD-22.1-04-BUFF-01/buff-panels-proof.json`, 64906 octets, SHA256 `ac2f646285ec4709784efc611b0bec67a14786a53d79a4fca6515acf63c529d3`.

Réutilisés sans réécriture : HUD-01 et ses 498 identités ; captures natives ; réparation TargetBar ; `docs/reference_passive_hud_sources/passive-hud-v226.json` ; V221/V222 ; associations de tâches dans le registre existant. Aucun ancien rapport remplacé. La relecture indépendante vérifie les quarante noms uniques, toutes les désactivations source, l'unique sélection, les quatre tests datés, les treize entrées compatibles et les limites explicites. Les dix-neuf fichiers de logiciel gelés correspondent toujours à WITHDRAWAL_INVENTORY.json.

Les sept critères de clôture sont renseignés : portée, sources, consommateurs, attendu/observé, limites, corrections et preuves. Le Goal, les registres du suivi et ses bases ne sont pas modifiés ; aucune case n'est cochée. Ce lot résout l'identification des sources et de la frontière manquante, sans déclarer la fonctionnalité de buffs, le champion ou le jeu terminés.
