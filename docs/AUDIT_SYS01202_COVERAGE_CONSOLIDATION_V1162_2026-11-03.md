# SYS-01.2-02 — Consolidation de couverture V1155 à V1162

Date : 2026-11-03  
Nature : inventaire en lecture seule, sans modification d'OpenLeague  
Périmètre d'écriture : ce dossier `E:\mapslol3v3\audit_sys01202_coverage_consolidation_v1162_20261103` uniquement

## Verdict

`SYS-01.2-02` demeure **OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE**.

- 17 unités d'audit bornées sont closes avec preuves identifiées.
- 2 unités sont à une preuve admissible, ou un paquet de preuve admissible, d'une décision.
- 2 unités sont bloquées par des entrées nommées.
- La tâche parente n'est pas close : cette chaîne Map10 ne couvre pas chaque exigence de LoL 4.20.
- Aucune fonctionnalité de jeu, Map10 ou FOUR_BLEND n'est déclarée terminée.
- Aucune acceptation humaine n'a été demandée ou inférée.
- Aucun changement n'a été apporté au goal, au plan, au suivi, aux bases, aux registres ou au produit. Aucune installation, exécution du jeu, opération D3D9 ou REA n'a été effectuée.

L'inventaire machine lisible canonique est `coverage_inventory.json`. Il épingle 36 sources et preuves par chemin, taille et SHA-256. Son digest sémantique est `6bc2ef6feb398e8770a8e605f5ba69eb7beadc72f5e7b3daea4e577e0cc7365e`.

## Contrat de la tâche parente

Registre lu : `F:\OpenLeague\docs\completion_tasks_2026-10-20.json`.

- ID : `SYS-01.2-02`
- Objectif : relier chaque exigence à une source native et à son consommateur actuel.
- État recensé : `partiel_a_terminer`.
- `implementation_complete=false`; `acceptance_complete=false`.
- Critère d'acceptation recensé : résultat intégré au consommateur réel et vérifié sur la référence 4.20, avec succès, refus et limites documentés.
- Preuves demandées : source 4.20 ou contrat local, attendu/observé, fichiers et contrôles exécutés, binaires/ressources si exécution, écarts et inconnues.

Le lot d'exécution lu est `D01-SYS-01-2`, phase D01, état historique `a_faire`, prérequis `D01-SYS-01-1`, et contient `SYS-01.2-01` à `SYS-01.2-06`. Ces états sont rapportés, pas modifiés.

## Critères exacts de clôture d'un audit atomique

Les sept rubriques proviennent de `F:\OpenLeague\docs\audit\AUDIT_CHARTER.md` et sont matérialisées dans l'inventaire :

1. Exigence précise et frontières du périmètre.
2. Sources historiques pertinentes, provenance, identité et limites ; ou recherches effectuées, source non retrouvée et entrée de reprise.
3. Consommateurs réels dans le code ; ou absence constatée après une recherche délimitée et reproductible.
4. Comportement observé, contrôles pertinents réellement exécutés et résultats attendus/observés ; contrôles non exécutés nommés.
5. Écarts, limites et conclusions restant indéterminées.
6. Corrections nécessaires, réutilisées ou proposées avec ID stable, objectif unique et critères de fin ; absence de correction justifiée.
7. Livrable, preuves identifiées et datées, version/périmètre des sources et relecture de cohérence.

Une unité peut satisfaire ces sept rubriques tout en concluant que la fonctionnalité est absente, refusée ou bloquée. Les quatre dimensions restent indépendantes : audit, implémentation, vérification technique et acceptation humaine.

## Unités d'audit closes

| V | Unité | Résultat borné et vérification | Reste explicitement hors preuve |
|---|---|---|---|
| V1155 | `...TERRAIN-SHADER-PREPROCESS-INTEGRATION-01` | Helper `0x9AE410`, provider neuf-SHA adapté, expansion exacte et compilation D3DX current-host ; PASS, revue 24/24. | VFS Riot historique, producteurs, publication, draw et rendu. |
| V1155 | `...SHADER-LIFECYCLE-COMPOSITION-01` | Compile/pool/CreateShader/publication exact-layout/cleanup sur fixtures ; PASS 98/98, revue 23/23. | Sources FOUR_BLEND complètes, producteurs Riot et rendu. |
| V1156 | `...FOURBLEND-LIFECYCLE-COMPOSITION-01` | Deux sources FOUR_BLEND dans le lifecycle current-host adapté ; PASS 50/50, revue 57/57. | Producteurs originaux, runtime 2014, paire, bind et draw. |
| V1156 | `...SHADER-PRODUCER-PREFLIGHT-01` | ABI, stores, cleanup et gates statiques des producteurs `0x98C070/0x98D960` ; preflight READY. | Aucune exécution producteur dans cette unité. |
| V1157 | `...TERRAIN-SHADER-STREAM-SLOT10-HANDOFF-01` | ABI slot stream `+0x10`, passage source/include/macros vers factories ; PASS, revue 60/60. | Classe/provider Riot spécifique `UNKNOWN_PROVIDER_SPECIFIC`. |
| V1157 | `...SHADER-PAIR-BIND-PREFLIGHT-01` | Contrat statique pair, resolver et binder D3D9 jusqu'à la frontière pre-draw ; READY, non exécuté. | Risques rollback/atomicité repris par V1158/V1159. |
| V1158 | `...ORIGINAL-SHADER-PRODUCERS-01` | Spans producteurs originaux dans composition adaptée/current-host jusqu'aux stores record+4 et cleanup ; PASS 191/191, revue 387/387. | Factories/VFS/managers adaptés ; aucun pair, bind ou draw. |
| V1158 | `...SHADER-PAIR-LIFECYCLE-PREBIND-01` | Factory pair, cache/resolver, release et rollback explicite avant bind ; PASS, revue 244/244. | Bind/draw et runtime Riot ; free bitmap exige rollback externe. |
| V1159 | `...SHADER-PAIR-BIND-PREDRAW-01` | Binder original SetVertexShader puis SetPixelShader current-host et rollback externe ; PASS 87/87, revue publiée. | Aucun draw, pixel ou runtime Riot ; binder original non atomique. |
| V1159 | `...DRAW-PREFLIGHT-01` | Backend+`0x20`, six arguments, état minimal, rollback et frontière avant Present/readback ; audit statique clos. | Composition même-run, constantes, matériau, textures/samplers et rollback complet. |
| V1160 | `...SCENE-STATE-PREDRAW-01` | RT/depth/viewport/scissor/scene current-host séparés avec refus et rollback ; PASS 30/30, revue publiée. | Pas de composition full-pipeline ni draw. |
| V1160 | `...FOURBLEND-MATERIAL-CONSTANTS-PREDRAW-01` | CTAB, registres/samplers requis et inventaire des manques ; audit 17/17, revue 20/20. | Upload historique `BLOCKED_PRE_DRAW_UPLOAD`; valeurs/handles/states exacts manquants. |
| V1161 | `...SHADER-CANDIDATE-ADMISSION-GATE-01` | Reproductibilité A/B et refus avant mutation sans preuve historique ; audit 26/26, revue 19/19. | Candidates REFUSED ; fonctionnalité `BLOCKED_BEFORE_MUTATION`. |
| V1161 | `...V1161-STATIC-MACRO-LINK-01` | Builder macro, copies ordonnées, producteurs, records et route ordinaire reliés ; `PROVEN_STATIC` 22/22, revue 28/28. | Vecteur historique complet `UNRESOLVED_RUNTIME_INPUTS`. |
| V1161 | `...REA-MACRO-LINK-01` | Deux tentatives REA incomplètes conservées ; décision structurelle fondée sur preuve statique ; validation 43/43, revue bornée. | Ne pas relancer les cinq mêmes PC ; capture runtime originale requise. |
| V1162 | `...MACRO-RUNTIME-INPUTS-01` | Producteurs directs et classification des neuf globals ; audit 31/31, revue 803/803. | 1 statique, 1 déterminable Map10, 7 runtime inconnus ; vecteur non construit. |
| V1162 | `...V1162-DEATHSCREEN-REMAP-01` | Algorithme remap, flag, sept stores directs, paire clé/index et conservation record+4 ; audit 29/29, revue 30/30. | `UNKNOWN_AT_STARTUP` et `UNKNOWN_AT_DRAW`; snapshot ou ordre exhaustif requis. |

Les identifiants complets, rapports, revues, tailles et empreintes de chaque ligne sont dans `coverage_inventory.json`. Le résumé ci-dessus ne remplace pas les limites propres à chaque rapport.

## Unités à une preuve d'une décision

### État runtime death-screen

- ID : `AUD-SYS-01.2-02-MAP10-DEATHSCREEN-RUNTIME-STATE-01`.
- Question : valeur de `[0x2D78F48]+0x0C` au démarrage pertinent et au draw `0x95A8A8 -> 0x95A570`.
- Preuve unique admissible : snapshot original 4.20 Map10 horodaté aux deux frontières, ou preuve exhaustive de l'ordre des stores post-constructeur avant le draw.
- Décision permise : remap actif ou inactif au draw. L'absence d'écran de mort ne constitue pas cette preuve.

### Vecteur macro historique complet

- ID : `AUD-SYS-01.2-02-MAP10-HISTORICAL-MACRO-VECTOR-01`.
- Question : vecteur complet et ordonné transmis aux deux records FOUR_BLEND dans une même exécution Map10.
- Paquet de preuve admissible : capture originale same-run des sept valeurs runtime inconnues, du vecteur ordonné, des deux records, du passage `0x95A730 -> 0x95AFC0`, et de l'état death-screen.
- Décision permise : admettre ou refuser une identité bytecode historique. Les candidates A/B restent refusées jusque-là.

## Unités bloquées

### Upload historique pre-draw

`AUD-SYS-01.2-02-MAP10-HISTORICAL-PREDRAW-UPLOAD-01` attend :

- valeurs exactes WVP/shadow/directional/ambient/fade/FoW/cloud au draw ;
- handles historiques `s0..s7` et `s10` nécessaires ;
- render state `0x40C` et filtres/LOD complets des samplers consommés ;
- vecteur macro historique admis et état death-screen au draw.

Reprise : snapshot original Map10 attribuant chaque valeur, handle et state à son producteur et à son ordre d'upload.

### Draw D3D9 contrôlé

`AUD-SYS-01.2-02-MAP10-CONTROLLED-D3D9-DRAW-01` reste bloqué par : composition bind-to-draw same-run, caméra/monde/constantes exactes, contrat matériau/render-state, identités des textures de détail s0-s3, état complet textures/samplers, capture HRESULT/rollback d'échec, et snapshot/rollback full-pipeline.

Reprise : tous les prérequis sont sourcés, un preflight unique passe sans mutation, puis une autorisation explicite ouvre un lot D3D9 séparé.

## Recherches à ne pas relancer sans entrée nouvelle

- Harness D3D9 current-host compile/lifecycle/bind/scene déjà qualifiés.
- Recompilation/réflexion des mêmes sources FOUR_BLEND ou candidates A/B sans modification de source, macro ou anomalie.
- Producteurs V1158, pair/cache V1158, binder V1159 ou scene V1160 inchangés.
- REA sur les cinq PC `0x9593C0/0x98C070/0x98D960/0x95A730/0x95AFC0` : deux tentatives incomplètes sont conservées et le lien est déjà `PROVEN_STATIC`.
- Permutations candidates sans vecteur original complet.
- Stores directs des neuf globals V1162 ou du flag death-screen sans producteur indirect concret, source modifiée ou contre-observation.
- Vérification globale des ancres `requirement_trace` sans modification du registre/source ou anomalie nouvelle.
- Déduction de l'état death-screen depuis l'absence d'écran de mort, ou promotion des defaults Game.cfg en valeurs runtime effectives.

## Condition d'arrêt D3D9

Décision actuelle : `STOP_NO_NEW_D3D9_RUN`.

Les preuves compile/lifecycle/bind/scene current-host existantes sont réutilisables. Un nouveau run ne résoudrait pas les entrées historiques absentes. La reprise exige cumulativement :

1. vecteur macro historique admis avec état death-screen au draw ;
2. constantes, textures, samplers et render states exacts sourcés ;
3. géométrie, scène, shaders et ressources co-résidents sur un device avec snapshot/rollback complet ;
4. preflight de chaque HRESULT/refus avant entrée draw ;
5. autorisation explicite d'un lot D3D9 séparé.

Si un futur draw est autorisé, la dernière instruction originale permise est `0x95B11B`, suivie du rollback/teardown. Present, readback et capture pixel restent interdits dans ce contrat.

## Prochaine petite unité réellement clôturable

ID : `AUD-SYS-01.2-02-MAP10-COLOR-PALETTE-PROVIDER-ORDER-01`  
État : `READY_AND_REALISTICALLY_CLOSABLE`

Question unique : quel provider/overlay et quel ordre alimentent `0x2D79058` via `0x97CCF8/0x97CDB6/0x97CDD1` avant le consommateur `0x959DA0`, avec contexte `0x2D7905C` ?

Périmètre : références, callers et stores directs du sélecteur palette et du contexte spectateur uniquement ; aucun jeu, D3D9 ou REA large.

Critères de fin :

1. épingler les octets PE et tous les callers/stores directs nommés ;
2. identifier provider, overlay, contexte spectateur et ordre, ou borner le dernier chaînon absent ;
3. relier la valeur au consommateur `0x959DA0` et au suffixe `COLORPALETTE_*` ;
4. séparer defaults et valeur effective ;
5. produire deux reçus déterministes, un validateur et une revue de cohérence ;
6. clore l'audit même si la valeur runtime demeure inconnue, avec condition de reprise précise.

Arrêt : dès que le dernier store/provider direct avant `0x959DA0` est identifié, ou qu'une frontière indirecte unique est prouvée comme entrée manquante.

## Sources et contrôles

Sources de gouvernance principales épinglées :

- `F:\OpenLeague\AGENTS.md` — SHA-256 `afeae02e861851aba08389dc2a9ff9a9abf6672c16bdc92db35bd23901ee3f49`
- `F:\OpenLeague\docs\audit\AUDIT_CHARTER.md` — `56c960e16ef8fb47266dec6a52a5d0baa5d5f5c8f8ba1c9f84e424f769d9b3aa`
- `F:\OpenLeague\docs\audit\AUDIT_METHOD.md` — `1492e56dbfcce2b4bb7e2fc67e86a54199dbbd0354218c212c8fb93260010c87`
- `F:\OpenLeague\docs\completion_tasks_2026-10-20.json` — `5c30d6f9543cc7f39e7801ab721242204f5745b60e118f793fe618b13baef8da`
- `F:\OpenLeague\docs\execution_plan_A_Z.json` — `a86d11b2c4520cfb980567163098d85e8f826d0724fca68e77f023a38a8ce9e0`

Les 31 rapports/revues V1155-V1162 supplémentaires sont tous épinglés dans l'inventaire, soit 36 pins au total.

Contrôles réellement exécutés :

- génération déterministe de l'inventaire depuis les sources en lecture seule ;
- validation du schéma, du digest, des comptes, des identifiants, des quatre dimensions, des pins, des limites, de la règle D3D9 et de la prochaine unité ;
- résultat : 32/32 contrôles PASS et 36/36 pins conformes ;
- second passage sans sortie pour vérifier le caractère non mutant ;
- manifeste final d'empreintes vérifié séparément.

Limite structurelle : les preuves consolidées qualifient leurs unités atomiques ; elles ne constituent ni une couverture exhaustive de SYS-01.2-02, ni une preuve que Map10 ou OpenLeague est fonctionnel ou terminé.
