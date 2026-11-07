# SYS-01.2-02 — Couverture du champ natif Data.PercentCooldownMod

**V1181 — une unité d’audit de couverture, aucune fonctionnalité close.** Le croisement est vérifié pour les dix lignes non nulles du recensement borné. Il confirme dix sources natives identifiées, une omission de ce champ dans leur projection locale, une couverture générale par les parents SERVER, et un critère CDR atomique qui reste à expliciter. Il ne démontre ni dix exigences entièrement absentes, ni dix comportements terminés.

## 1. Périmètre précis et critère de fin

Référence : PUBLIC 4.20.0.315, EUW/en_GB ; le catalogue officiel local **4.20.1 en_US** est une comparaison distincte. Périmètre : le seul champ nommé `Data.PercentCooldownMod`, hash `2196017170`, parmi les **849 lignes déjà enregistrées** dans `data/4.20/native_item_audit.json`. Aucun autre inventaire de ressources n’est revendiqué.

Le lot se clôt comme audit si le recensement est identifié, les dix valeurs non nulles sont reliées à leurs sources et membres du manifeste, leurs projections/tâches/consommateurs sont inspectés, et les corrections ainsi que les inconnues sont formulées sans modifier les tâches. Le statut du contrôle est **PASS_STATIC_SCOPE, 212/212**, après correction de deux hypothèses trop fortes du validateur ; le premier résultat **205/212** est conservé.

Les comptes désignent trois choses différentes : **849 contrôles d’entrée dans le recensement daté**, **10 lignes de champ non nulles**, **1 unité d’audit de couverture**. Le cas 3137 réemploie son audit V1180 ; les neuf autres lignes sont examinées dans ce croisement, sans revendiquer leur première découverte historique. **0 fonctionnalité close** ; aucun pourcentage de fidélité du jeu n’en est déduit.

## 2. Sources, identités et provenance

Le reçu `inventory.json` est conservé octet pour octet (SHA-256 `f5a2d113a537dccd327cae6b16e522492d2c3dd3ca630a345354ca0e85240aa9`). Son script `scan_native_cdr.py` est épinglé (`02fcd3fde79250d472982b015e66a66f0de77a996af3843ccb02ea8700f38543`). Il a lu et décodé 849/849 sources, avec 849 correspondances SHA-256, 0 absence, 0 racine inattendue, 0 erreur de décodage et 0 conversion numérique invalide. Le champ est présent dans 33 lignes : 23 valeurs nulles et 10 non nulles. La sélection convertit explicitement en nombre fini ; elle ne traite pas la chaîne `"0"` comme une valeur non nulle.

Le nouveau validateur ne refait pas ce recensement : il contrôle son identité/cohérence et relit seulement les dix sources retenues. Toutes dix sont des valeurs natives décodées de type **float**, `-0.10000000149011612`, représentation float32 little endian **`cdccccbd`**. Un signe négatif ne constitue pas, à lui seul, un contrat serveur de réduction positive de 10 %.

Les fichiers originaux sont `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\<id>.inibin`. Chaque source a un seul enregistrement exact dans `fidelity_sources_4_20.json`, et un seul chemin logique `DATA/Items/<id>.inibin` dans le manifeste agrégé `lol_game_client/0.0.1.7` (SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`). Taille et MD5 du membre correspondent aux octets source. **La release portée par un membre peut être antérieure à la release du manifeste agrégé.**

| Objet | Source enregistrée | Octets | Release membre |
|---|---|---:|---|
| 3023 Twin Shadows | OLS-9d36a127-b6f1-5f6e-9759-a791037c057b | 608 | 0.0.0.254 |
| 3056 Ohmwrecker | OLS-a1844400-9fcf-5983-adb1-2c84a792dfc0 | 620 | 0.0.1.7 |
| 3060 Banner of Command | OLS-a38914f9-0aad-59c8-bb42-cddfbd3734b0 | 642 | 0.0.1.7 |
| 3137 Dervish Blade | OLS-2e4033cb-588f-58a1-bab7-639eea54201c | 601 | 0.0.1.7 |
| 3142 Youmuu's Ghostblade | OLS-f8be4835-d611-546a-bb00-8b34c7b08203 | 570 | 0.0.0.254 |
| 3188 Blackfire Torch | OLS-2a1739a8-c094-5f12-ba68-03b6b35c5971 | 612 | 0.0.0.254 |
| 3190 Locket of the Iron Solari | OLS-0ca845a7-10f5-5c63-b29c-5b0c5073de29 | 636 | 0.0.1.7 |
| 3290 Twin Shadows | OLS-51c614f4-de96-5152-a7a5-bc3bfb136158 | 638 | 0.0.0.254 |
| 3504 Ardent Censer | OLS-df8dfb59-28b2-51b0-9dae-4b3635f74e71 | 574 | 0.0.1.7 |
| 3508 Essence Reaver | OLS-847d8bd0-c37f-5a3e-a180-a3af9801b8dd | 570 | 0.0.0.248 |

Les SHA-256 individuels, valeurs brutes, membres de manifeste, tâches, traces, conditions de périmètre et identités de tous les fichiers lus sont conservés dans `result.json` ; ils ne sont pas remplacés par cette table de lecture.

Les descriptions natives de `fontconfig_en_GB.txt` (SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`) affichent toutes `+10% Cooldown Reduction` dans la section ordinaire `<stats>`. Le cache officiel distinct 4.20.1 (SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`) conserve cette ligne et le tag CDR, mais omet le champ dans `stats`. Les descriptions complètes 3056/3504 diffèrent parce que le texte natif conserve une formule de régénération ; aucune égalité intégrale entre ces deux versions n’est prétendue.

## 3. Couverture des tâches et consommateurs actuels

Chaque objet a déjà `ITEM-<id>-SCOPE` (`required:true`, `a_qualifier`) et `ITEM-<id>-SERVER` général. Tous les parents SERVER sont ouverts, `required:false`, avec la même condition : **« Disponible dans le périmètre historique 4.20 ; classification à prouver, aucune exclusion automatique. »** Leur contrat mentionne déjà les statistiques, groupes uniques, passifs, actifs et charges. Aucun de ces dix ensembles n’a d’enfant nommé `STAT-PercentCooldownMod` ou CDR. Les cinq enfants PASSIF existants restent conservés : leur contrat générique et le contexte d’autres effets passifs ne délimitent pas explicitement la contribution ordinaire du champ CDR.

| Objet | Parent SERVER déjà présent | PASSIF enfant générique | Projection native du champ / catalogue courant | Maps officielles observées |
|---|---|---|---|---|
| 3023 | OLF-acc288a2-4bc1-58d2-827d-550a6baea3b8 | absent | absent / absent | `10:false` |
| 3056 | OLF-a5901fef-9e2f-5ea5-8d53-e0ad35bd6ac5 | présent | absent / absent | `12:false` |
| 3060 | OLF-bb6ba0b2-a0af-56b6-b107-68be1c8d948d | absent | absent / absent | champ absent |
| 3137 | OLF-86cdab72-5849-5b5e-bed7-4f59628cd037 | absent | absent / absent | `12:false,1:false` |
| 3142 | OLF-caaf4775-5054-5fac-876c-67dc238dfb33 | présent | absent / absent | champ absent |
| 3188 | OLF-bdc83189-cc49-53b8-bf25-ed687b3e5523 | absent | absent / absent | `12:false,1:false` |
| 3190 | OLF-414d4477-6cb3-5b41-bcba-35dd0aa12a8b | absent | absent / absent | champ absent |
| 3290 | OLF-46dee7df-1561-54c1-a192-fd04cacf0ff9 | présent | absent / absent | `12:false,1:false` |
| 3504 | OLF-9e87acd4-5fd7-5a8e-8d28-c024953868cb | présent | absent / absent | champ absent |
| 3508 | OLF-d9d47794-3262-516c-bea1-3ff5d647628c | présent | absent / absent | `10:false` |

Cette table relève un **manque de précision de couverture et de critères**, pas une absence de toute exigence. La présence d’un fichier, son appartenance au manifeste ou une clé de carte absente ne qualifie pas sa disponibilité historique. Les variantes 3023/3290 et les contraintes 3508 doivent notamment garder leur examen SCOPE propre ; aucun contenu n’est automatiquement admis ou exclu.

Les partitions complètes tâches/traces et les paquets `D07-ITEM-<id>` sont comparés. Les dix traces parent pointent actuellement vers `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b`, le consommateur générique de refus. Le chemin de contribution statistique est aussi inspecté dans le code réel :

`shop_foundation.json` → `shop::bonuses` → `filter_map(|id| item(*id))` → somme des bonus → `progression::stats` et plafond CDR → `cooldown::ticks` → consommateur de sort existant (Garen).

Les dix objets sont absents du catalogue chargé par `include_str!`. Le filtre de `bonuses` omet donc leur contribution statistique si un tel ID est fourni à cet itérateur ; c’est une observation statique distincte d’un essai d’achat ou d’utilisation. Le refus d’un objet inconnu et les tests antérieurs ne prouvent aucune disponibilité historique ni aucun CDR fonctionnel pour ces dix objets. Le chemin commun possède déjà déduplication par ID, plafond local à 0,4, conversion en ticks arrondie au supérieur et cadence 30 Hz. Le fichier de règles indique expressément que la déduplication et le snapshot au lancement sont reconstruits. Les consommateurs enregistrés `OLC-be153768-fdac-5822-a737-7ffdbcb30611` (stat/plafond) et `OLC-74c1a701-282b-5e1a-b9c2-34a27e61f7ab` (ticks) servent de points de reprise ; leur existence n’est pas une preuve du contrat historique.

`tools/verify_native_items.py` est lu, **non exécuté**, car il écrit un JSON de validation. Son premier passage compare seulement les champs déjà projetés ; son second passage contient treize paires numériques sans CDR. Son succès éventuel ne mesure donc pas l’exhaustivité des champs natifs. La cause exacte de génération de la projection et des enfants statistiques reste inconnue ; le résultat des recherches antérieures est réutilisé, sans nouvelle recherche générale sans piste.

## 4. Vérifications exécutées, résultat attendu et observé

Exécuté avec le Python existant `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B` ; `sys.dont_write_bytecode=True` avant les imports locaux. Aucun binaire de jeu historique n’est exécuté.

| Contrôle | Attendu | Observé |
|---|---|---|
| Recensement borné initial | sources enregistrées lisibles et identiques, sélection numérique explicite | 849/849 SHA et décodages ; 33 champs présents, 23 nuls, 10 non nuls ; 0 erreur |
| Conservation du reçu initial et entrées | SHA inchangés ; pas de nouvelle passe sur les 849 sources | conforme ; reçu daté conservé |
| Dix sources relues | identité enregistrée, float et bits exacts | 10/10 conformes, `cdccccbd` |
| Registre source/manifeste | une correspondance exacte par source, taille/MD5 concordants | 10/10 conformes, versions membres individuelles conservées |
| Projection, texte, tâches et catalogue | distinguer champ brut/texte/critère/consommation | omission champ 10 ; texte CDR 10 ; parents généraux 10 ; PASSIF 5 ; catalogue absent 10 |
| Chemin commun actuel | retrouver le lecteur et les consommateurs réels sans prétendre exécuter le jeu | filtre, somme, plafond, ticks et appel de sort identifiés statiquement |
| Résultat final | tous les contrôles statiques de ce périmètre réussissent | **212/212**, code de sortie 0 |

La première exécution a produit **205/212**, code 1, conservée dans `result-initial-checks.json`. Cinq contrôles supposaient à tort que chaque membre portait la version du manifeste agrégé ; deux supposaient une égalité intégrale des descriptions native et officielle. Le validateur a été corrigé pour épingler les versions réelles par ID et comparer le champ CDR précis tout en conservant les différences de description. Aucun changement produit n’a été fait pour obtenir le succès.

Non exécutés : jeu/client historique, moteur actuel, compilation, tests de combat ou d’achat, vérificateur natif qui écrit, générateur de plan, outil de suivi, migration, installation ou REA. Aucun refus en jeu nouveau n’est présenté comme observé. Les cas invalides sont bornés ici par les contrôles d’identité, d’unicité, de partition et de type ; leurs échecs font échouer le validateur plutôt que d’admettre une source incertaine.

## 5. Corrections proposées, exclusivement documentaires et conditionnelles

Pour **chacun** des dix IDs, préciser la couverture CDR sous le parent existant, en conservant les enfants PASSIF/ACTIF, les dépendances antérieures et la condition historique. Si une atomisation est ensuite autorisée, les deux sous-objectifs proposés ci-dessous donnent un nom au contrat et à sa réalisation. Ils ne sont **ni enregistrés, ni activés, ni comptés comme tâches réalisées** par ce lot.

| ID | Proposition contrat | Proposition de contribution statistique | Reprise propre |
|---|---|---|---|
| 3023 | ITEM-3023-SERVER-CDR-CONTRAT | ITEM-3023-SERVER-STAT-PercentCooldownMod | conserver SCOPE et ACTIF ; ne pas confondre 3290 |
| 3056 | ITEM-3056-SERVER-CDR-CONTRAT | ITEM-3056-SERVER-STAT-PercentCooldownMod | clarifier CDR ordinaire à côté du PASSIF existant |
| 3060 | ITEM-3060-SERVER-CDR-CONTRAT | ITEM-3060-SERVER-STAT-PercentCooldownMod | conserver SCOPE et ACTIF, disponibilité à prouver |
| 3137 | ITEM-3137-SERVER-CDR-CONTRAT | ITEM-3137-SERVER-STAT-PercentCooldownMod | **réemploi exact des propositions V1180**, aucun doublon |
| 3142 | ITEM-3142-SERVER-CDR-CONTRAT | ITEM-3142-SERVER-STAT-PercentCooldownMod | conserver l’audit ACTIF et le PASSIF existants |
| 3188 | ITEM-3188-SERVER-CDR-CONTRAT | ITEM-3188-SERVER-STAT-PercentCooldownMod | conserver les contraintes SCOPE et l’ACTIF |
| 3190 | ITEM-3190-SERVER-CDR-CONTRAT | ITEM-3190-SERVER-STAT-PercentCooldownMod | conserver SCOPE et ACTIF ; ne pas inférer la carte par absence de clé |
| 3290 | ITEM-3290-SERVER-CDR-CONTRAT | ITEM-3290-SERVER-STAT-PercentCooldownMod | conserver SCOPE, PASSIF et ACTIF ; variante 3023 distincte |
| 3504 | ITEM-3504-SERVER-CDR-CONTRAT | ITEM-3504-SERVER-STAT-PercentCooldownMod | clarifier CDR ordinaire à côté du PASSIF et de la régénération |
| 3508 | ITEM-3508-SERVER-CDR-CONTRAT | ITEM-3508-SERVER-STAT-PercentCooldownMod | conserver SCOPE et PASSIF ; `maps.10:false` reste un indice distinct4.20.1 |

Critères communs, paramétrés par **l’ID, son source_id, ses octets et son contexte** dans `result.json` :

1. **Contrat.** Après décision historique SCOPE sourcée pour cet ID, relier le champ brut négatif et la ligne de texte positive à une règle serveur documentée : signe/unité, valeur appliquée, cumul de doublons et d’objets différents, interaction avec plafond, moment d’échantillonnage et arrondi. Distinguer explicitement preuve native, comparaison4.20.1 et reconstruction locale. Un contrat non démontré demeure inconnu ; la seule présence du fichier ou d’un parent/PASSIF n’est pas un succès fonctionnel.
2. **Contribution.** Seulement si l’objet est admis et le contrat qualifié, intégrer la contribution au consommateur statistique réel, conserver les autres effets, relier les traces à la source précise et au chemin stat/plafond/ticks. Vérifier un inventaire nominal, retrait, doublon, combinaison, plafond et entrée non admise avec résultats attendus/observés ; démontrer l’effet sur le cooldown du sort réellement consommé. Identifier les binaires et ressources exécutés. Garder ouverts les cas non démontrés. Un test de refus seul ou un audit documentaire ne clôt pas cette contribution.

Une précision des critères du parent existant peut être suffisante ; la création de nouveaux IDs n’est pas présentée comme l’unique solution ni comme déjà autorisée. Le registre, ses compteurs, les cases et le goal restent inchangés.

## 6. Manques précis et conditions de reprise

- **Disponibilité historique de chaque variante : ouverte.** Reprendre chaque `ITEM-<id>-SCOPE` avec une preuve d’admission dans le mode/cartographie concerné ou une décision d’exclusion sourcée. Une appartenance au manifeste et les maps4.20.1 ne suffisent pas.
- **Contrat serveur du signe/cumul/snapshot : ouvert.** Reprendre avec une observation historique ou un consommateur serveur attribuable à ces champs ; ne pas recopier le signe négatif dans le catalogue local par supposition. Les audits des passifs CDR3067/3101 sont préservés, mais ils ne prouvent pas cette sémantique de champ ordinaire.
- **Projection et précision de couverture : écart établi.** Le champ nommé n’est pas projeté pour les dix lignes ; les parents généraux sont présents, mais le critère atomique proposé n’est pas enregistré. Reprise par une correction autorisée et traçable du producteur réel, quand identifié, sans modifier manuellement les bases de suivi à partir de cet audit.
- **Cause du producteur : inconnue.** Ne rouvrir la recherche générale que lorsqu’un nouveau fichier, dépôt, historique ou appel de génération fournit une piste vérifiable.
- **Fonctionnement courant par objet : ouvert et conditionnel.** Catalogue absent et absence de contribution statique sont constatés. Pas d’ajout avant qualification du périmètre et du contrat ; pas de requalification des anciens refus comme réussite CDR.

Les sources, traces et preuves anciennes restent conservées : V1180/3137 CDR, audit3137 ACTIF, audit3142 ACTIF, passages SCOPE3056/3060/3504/3508 et audits CDR3067/3101. Leurs comportements ne sont pas rejoués dans ce lot. Les objets3024/3067/3101/3108/3114 et tout autre chemin CDR hors des dix valeurs non nulles ne sont pas déclarés sans CDR ; ce recensement porte seulement sur ce champ nommé dans l’index fixé.

## 7. Livrables, conservation et reprise

Staging `E:\mapslol3v3\audit_sys01202_cdr_family_preflight_20261103` : `scan_native_cdr.py`, `inventory.json`, `validate_cdr_family.py`, `result-initial-checks.json`, `result.json`, ce rapport et `publish_documentation.py`. Le publisher est préparé, **non exécuté par ce lot** : il vérifie les empreintes du rapport/validateur/résultats/recensement et des cinq JSON protégés avant toute écriture documentaire, refuse un doublon V1181, puis contrôle leur conservation. La publication documentaire est un acte séparé à tracer par son reçu ; elle ne modifie aucun état fonctionnel.

Les cinq JSON protégés sont identifiés par leurs SHA-256 dans `result.json` : `completion_plan.json`, `resume_checkpoint.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_sources_4_20.json`, `fidelity_unknowns_4_20.json`. Aucune écriture dans F, aucun produit, Plan, interface, base, goal ou installation n’a été réalisé dans la préparation de ce lot. Le statut global SYS-01.2-02 et le jeu restent ouverts.
