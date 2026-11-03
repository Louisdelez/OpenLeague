# V1151 — REA ciblé sur les identités géométrie et shaders Map10

Date : 2026-11-03  
Objectif : `SYS-01.2-02` — relier chaque exigence à une source native et à son consommateur actuel.  
Verdict : **corroboration REA ciblée terminée ; aucune fonctionnalité graphique déclarée terminée**.

## Question bornée

Une seule session REA/Ghidra devait confirmer les fonctions natives qui relient :

1. la déclaration de sommets du contexte terrain à la création D3D9 ;
2. les descripteurs pixel/vertex aux handles publiés, à la paire de shaders et aux appels D3D9 de liaison.

Le lot ne devait ni compiler physiquement un shader, ni créer une frame, ni appeler Draw/Present, ni qualifier des pixels, ni modifier le produit.

## Réutilisation et exécution

Les logiciels déjà installés ont été réutilisés sans installation : REA 6.4.0, Ghidra 12.1.4, Java 21 et Node 24, via le contrat `F:\OpenLeague\tools\rea-openleague.config.json`.

Entrée : copie exacte du PE original déjà épinglée par V745, 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

La session persistante s'étend de `2026-11-03T09:10:10.349Z` à `09:21:40.684Z`. La première fonction déclenche l'unique import complet et prend 640 520 ms. Toutes les requêtes suivantes réutilisent la même base éphémère et prennent entre 4 et 314 ms, puis la session exporte :

- un bundle de 10 preuves, 4 973 996 octets ;
- un snapshot de 9 926 049 octets, sept entrées primitives et dix preuves ;
- les requêtes et réponses individuelles, le journal serveur et le reçu final `success=true`.

Le snapshot accélère la relecture exacte de ces requêtes. Il ne promet pas qu'une nouvelle requête jamais enregistrée évitera un nouvel import du PE.

## Géométrie

REA résout `0x9596D0` avec un corps disponible de 820 octets et 195 lignes d'assemblage :

- `0x95974F: LEA EAX, [EDI + 0x4]` fournit `context+0x04` comme sortie de la déclaration selector 0 ;
- `0x959790: CALL dword ptr [EDX + 0x54]` franchit la fabrique backend ;
- l'unique xref direct renvoyé est `0x96097C`.

REA résout `0x9C2880` avec un corps de 716 octets et confirme `0x9C2A68: CALL 0x009C5B20`, frontière de création de la déclaration D3D9.

Ces résultats corroborent le rapport statique V1151 : selector 0, 107 VB et 107 IB ont chacun une identité native stable. Ils ne ferment pas la jonction d'un selector réellement produit avec une paire VB/IB dans le même batch historique Map10.

## Shaders

REA résout les cinq fonctions ciblées et confirme les instructions critiques :

- pixel `0x98C070` : soumission virtuelle à `0x98C2AA`, factory `0x9AEBF0`, publication à `record+4` à `0x98C2B9` ;
- vertex `0x98D960` : soumission virtuelle à `0x98DB9A`, factory `0x9AEA90`, publication à `record+4` à `0x98DBA9` ;
- paire `0x9AEE30` : factory D3D9 `0x9BEE80`, puis conservation des handles vertex/pixel à `+0x08/+0x0C` ;
- résolution `0x9C22E0` : création de paire via `0x9AEE30`, puis liaison via `0x9BEF40` ;
- liaison `0x9BEF40` : appels D3D9 aux slots `+0x170` et `+0x1AC`, soit SetVertexShader et SetPixelShader.

Les xrefs directs comprennent `0x95A071 → 0x98C070` et `0x95A24E → 0x98D960`, exactement les deux appels d'enregistrement retenus par le rapport statique.

Cette chaîne est exacte statiquement. REA n'a pas observé un objet FOUR_BLEND compilé, un handle historique non nul, une interface COM vivante ni leur liaison dans une frame.

## Contrôles et relectures

- géométrie producteur : 38/38 ;
- géométrie indépendante : 21/21 ;
- shaders producteur : 16/16 ;
- shaders indépendante : 15/15 ;
- validation croisée REA : 34/34 ;
- relecture REA indépendante PE/Capstone : 11/11.

La validation REA exige le SHA du PE, les 14 appels non erronés du reçu, les sept adresses/fonctions, seize lignes machine critiques, les trois xrefs, l'identité/taille du bundle et du snapshot, ainsi que les quatre validations statiques. La relecture indépendante reparse le PE et redésassemble les seize instructions avec Capstone. Son premier passage 10/11, conservé dans l'historique, provenait uniquement d'une comparaison textuelle hexadécimal/décimal ; la normalisation numérique a donné 11/11 sans modifier les octets ni les attentes.

## Limites et erreurs conservées

Avant la fermeture, l'auto-analyse Ghidra globale a affiché des avertissements et trois échecs de désassemblage sur d'autres adresses (`0x79614D`, `0x72614D`, `0x746153`). Aucun ne chevauche les corps ciblés. Chaque dossier demandé est revenu sans erreur, avec corps, assemblage et références, puis a été recoupé avec les validateurs PE/Capstone indépendants.

Limite de preuve : le `ghidra.log` brut appartenait au projet éphémère et a été supprimé par `close_binary`; il n'est pas archivé dans le bundle. Ces diagnostics restent donc une observation de tour, non un reçu rehashable. Le journal serveur REA conservé, lui, contient douze statuts `ok`.

Le pseudocode, les types et conventions d'appel reconstruits par Ghidra restent consultatifs. Le verdict repose sur les adresses, instructions et xrefs exacts.

Restent ouverts :

- la jonction selector + VB/IB dans un même batch historique ;
- la compilation et publication physiques des variantes FOUR_BLEND ;
- les handles et interfaces COM d'une exécution historique ;
- leur liaison réelle, DrawIndexedPrimitive, Present et les pixels ;
- l'intégration équivalente dans le consommateur Rust actuel ;
- SYS-01.2-02 et le jeu complet.

## Condition d'arrêt et reprise

Ne pas répéter ces dix requêtes REA sans nouvelle hypothèse : le snapshot et les réponses suffisent pour leur relecture.

Le prochain lot shader clôturable est la publication ciblée par `0x98D960/0x98C070`, arrêt après capture des deux handles et nettoyage, avant paire, bind, Draw, Present ou readback. Le prochain lot géométrie clôturable est une continuité même-run selector/VB/IB arrêtée à `0x95B112`, sans draw.

## Fichiers

- `query_plan.json` et `run_rea_persistent_queries.mjs` ;
- `receipt.json`, requêtes/réponses `001..014`, `progress.ndjson`, `rea-stderr.log` ;
- `rea-evidence-bundle.json` et `map10_resource_identity.snapshot.json` ;
- `validate_rea_resource_identity.py` et `rea_resource_identity_validation.json`.

Aucun fichier produit, Goal, Plan, interface, base ou registre n'a été modifié. Aucun logiciel n'a été installé.
