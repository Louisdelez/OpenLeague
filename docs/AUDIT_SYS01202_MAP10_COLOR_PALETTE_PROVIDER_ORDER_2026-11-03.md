# V1163 — Provider et ordre de la palette Map10

Unité : `AUD-SYS-01.2-02-MAP10-COLOR-PALETTE-PROVIDER-ORDER-01`  
Date : 2026-11-03  
Verdict : **audit borné clos à une frontière indirecte unique**  
Fonctionnalité/runtime/Map10 : **non terminés et non déclarés conformes**

## 1. Exigence précise et périmètre

L'objectif unique était de déterminer quel provider/overlay et quel ordre alimentent le sélecteur `0x2D79058` par les stores `0x97CCF8`, `0x97CDB6` et `0x97CDD1`, avant sa lecture par `0x959DA0`, en tenant compte du contexte `0x2D7905C` et du suffixe `COLORPALETTE_*`.

L'analyse est limitée au PE original LoL 4.20, aux références absolues, callers `E8 rel32`, pointeurs de table directs et fenêtres de désassemblage nécessaires. Aucun jeu, D3D9, réseau, installation, migration ou REA n'a été lancé. Aucun fichier F:, goal, plan, suivi, base, registre ou produit n'a été modifié.

Le stop prévu est atteint : les derniers stores directs et leur ordre interne sont identifiés, puis la dernière frontière d'ordre est prouvée comme invocation virtuelle indirecte.

## 2. Sources historiques, provenance et identité

Le binaire analysé est `League of Legends.exe`, version de référence 4.20, taille 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Preuves réutilisées et épinglées :

- unité ColorPalette existante : SHA-256 `3fa3ee799741f7a078f6f1a4abb4d5e63b7c211d39d200c4c3d6e52e910a92a4` ;
- preuve JSON ColorPalette : `8dd3680238278f25f9f73254ad349d51205233a53f287328a448174bc7ce3761` ;
- producteur de cette preuve : `4ce38b9ac32f1d91f4c90c592612c0f1779130b5a5b83bcfabe163f08aa8b8cc` ;
- contrat de routage entier `0x8B1C20` : `da94a073dbe4272f17add30f825d48afc1df73e722fceeeae71c3c4b91b871a6` ;
- contrat de sélection shader : `5921c903140cf70fec95625306a9a2b82529c45d4ebb79f4b68e93eabdf63940` ;
- rapports V1161/V1162 : `27f7fcdadbb9a5c1f9b64b0e62def6c2d6a095f341a6308f7be0ab569494ef9a` et `fe09388b5b25553d245403c34a95207be4e00d6b7e2c64c71313c846bb521473` ;
- `defaults/Game.cfg` original : `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`.

Les neuf sources et leurs tailles/empreintes complètes figurent dans chaque reçu. Le fichier de defaults contient lexicalement `ColorPalette=0` et `ColorPaletteSpectator=1`; ces lignes ne prouvent pas la valeur effective du provider au lancement de référence.

## 3. Producteurs, provider, ordre et consommateur réels

### Initialisation

La chaîne directe est :

1. `0x59307A` appelle la fonction `0x58FF50` ;
2. dans cette fonction, `0x5902D5` est l'unique caller direct de l'initialiseur `0x97CD90` ;
3. `0x97CD91` lit le contexte `0x2D7905C` ;
4. contexte zéro : clé `ColorPalette`; contexte non nul : clé `ColorPaletteSpectator` ;
5. `0x97CDA9` appelle le getter entier `0x8B1C20` avec fallback 0 ;
6. résultat unsigned `<=2` : store à `0x97CDB6`; résultat `>2` : diagnostic puis store 0 à `0x97CDD1`.

Le provider natif lu est donc le getter entier `0x8B1C20`. Son contrat réutilisé, 1 296 cas, établit cet ordre générique : paire baseline/default avant paire utilisateur; overlay avant primaire dans chaque paire; résultat antérieur transmis comme fallback aux lectures utilisateur. Il reste volontairement `complete=false` : les paires de fichiers réellement peuplées et retournées par le cache `0x8ACEF0` pendant ce lancement de référence ne sont pas observées. Le provider/overlay effectif est donc `UNKNOWN_AT_REFERENCE_RUN`, pas remplacé par les defaults lexicaux.

### Changement par le setter

Les seuls callers directs de `0x97CCB0` sont `0x837ABF` et `0x837AD3`, dans le callback `0x837AA0`. Pour une valeur différente et valide :

1. `0x97CCF8` stocke d'abord le nouveau sélecteur ;
2. `0x97CD01` appelle `0x8B2E00` pour le nom de fichier utilisateur ;
3. `0x97CD28` appelle `0x8B2B10` pour demander l'écriture sérialisée ;
4. `0x97CD40..0x97CD56` parcourt les listeners et appelle leur slot virtuel `+8` à `0x97CD4E`.

Une valeur unsigned `>2` ou identique retourne avant store, provider et listener. Cette demande d'écriture ne prouve ni durabilité disque ni relecture après redémarrage.

### Contexte

Le byte `0x2D7905C` vaut 0 dans l'image PE. Les six références directes sont exhaustivement bornées :

- stores 1 : `0x72C99C`, `0x72C9C6`, `0x72CA16` ;
- reads : `0x837ACA`, `0x97CCE3`, `0x97CD91` ;
- aucun store direct 0.

Les trois fonctions écrivaines `0x72C990`, `0x72C9C0`, `0x72CA10` n'ont aucun caller direct `E8`. Elles sont exclusivement présentes dans la table virtuelle ancrée à `0x10AFE8C`, aux slots `+0xAC`, `+0xA8`, `+0xA4`. Leur invocation et leur ordre relatif à l'initialiseur et aux builds de registre constituent la frontière indirecte unique de cette unité.

Un changement de contexte seul ne réécrit pas `0x2D79058`; il influence la clé lors de l'initialisation et le mapping/la clé lors d'un passage ultérieur par le callback/setter.

### Consommateur shader

`0x959D30` a exactement trois callers directs : `0x58E385`, `0x73DF1F`, `0x95A392`. Dans chaque exécution :

1. `0x959D9B` appelle d'abord le builder préfixe `0x9593C0` ;
2. `0x959DA0` lit ensuite la valeur courante de `0x2D79058` ;
3. 1 choisit `COLORPALETTE_SPECTATOR`, 2 choisit `COLORPALETTE_COLORBLIND`, toute autre valeur choisit `COLORPALETTE_DEFAULT` ;
4. `0x959DDA` ajoute la paire choisie avec la valeur texte `1` ;
5. `0x959DE3` ajoute ensuite le groupe fog conditionnel.

L'ordre à l'intérieur de l'initialiseur, du setter et du consommateur est `PROVEN_STATIC`. Le dernier événement runtime parmi l'initialiseur, le setter et les slots de contexte avant chacun des trois appels à `0x959D30` est `UNKNOWN_RUNTIME_ORDER`.

## 4. Attendu, observé et contrôles exécutés

| Cas | Attendu | Observé |
|---|---|---|
| Initialisation contexte régulier | clé `ColorPalette`, validation et store du résultat | Chemin statique prouvé; résultat effectif du provider inconnu. |
| Initialisation contexte spectateur | clé `ColorPaletteSpectator`, validation et store | Chemin statique prouvé; ordre du slot virtuel et résultat effectif inconnus. |
| Résultat initial invalide | diagnostic puis sélecteur 0 | Branche `0x97CDB1/0x97CDB4`, store `0x97CDD1`. |
| Changement setter | store avant écriture config et notification | `0x97CCF8 -> 0x97CD01 -> 0x97CD28 -> 0x97CD4E`. |
| Construction macros | exactement un suffixe palette avant fog | `0x959DA0..0x959DDA`, puis `0x959DE3`. |

Contrôles réellement exécutés : deux runs statiques déterministes sur le PE épinglé; comparaison de leur preuve stable; scan ciblé des références absolues, callers `E8 rel32` et pointeurs directs; vérification de 20 séquences d'octets; 13 fenêtres bornées; relecture des contrats épinglés; validateur 44/44 PASS.

Digest stable commun aux deux runs : `b3789ecf90f4bd077a900e7a627f760fafd43981cc38f844dab7705b2c96fb0c`.

## 5. Écarts, limites et inconnues

- `COLOR-PALETTE-EFFECTIVE-PROVIDER` : les paires cache réellement retournées par `0x8ACEF0`, leur population et la valeur gagnante ne sont pas observées sur le lancement 4.20 de référence.
- `COLOR-PALETTE-CONTEXT-ORDER` : l'appel des slots virtuels `+0xA4/+0xA8/+0xAC` avant ou après `0x5902D5` et les trois appels à `0x959D30` n'est pas fixé statiquement.
- `COLOR-PALETTE-AT-CONSUMER` : faute de cet ordre runtime, la valeur exacte lue à `0x959DA0` reste inconnue; les trois branches sont cependant entièrement identifiées.
- Le scan qualifie les références absolues et pointeurs directs du PE épinglé. Il n'exclut pas un store calculé/aliasé sans littéral absolu; une telle hypothèse ne rouvrira l'audit qu'avec un producteur concret ou une contre-observation.
- Aucune persistance, frame, compilation shader, rendu, pixel ou acceptation visuelle n'est qualifiée.

## 6. Corrections et reprise proposées

Aucune correction produit n'est appliquée. Les preuves ColorPalette, le contrat de routage `0x8B1C20` et la chaîne V1161/V1162 sont réutilisés au lieu de relancer un inventaire général.

Une reprise ne se justifie qu'avec un paquet nouveau et précis :

1. trace ou snapshot original 4.20 donnant l'invocation des slots `+0xA4/+0xA8/+0xAC`, `0x5902D5` et le prochain caller de `0x959D30` dans un même ordre horodaté ;
2. identité et contenu des paires cache réellement rendues par `0x8ACEF0` pour les clés concernées ;
3. valeur de `0x2D79058` immédiatement avant `0x959DA0`.

Ne pas relancer les scans directs, les deux runs, l'inventaire général des options ou les mêmes contrats sans source modifiée, producteur indirect concret ou contre-observation.

## 7. Livrable, clôture et séparation des statuts

Livrables : script producteur, deux reçus déterministes, validateur, reçu de validation, ce rapport et manifeste SHA-256 dans le dossier V1163.

La clôture est limitée à l'audit atomique : provider générique, ordre intra-fonction, stores directs, consumers et frontière de reprise sont identifiés. Le provider/overlay effectif et la valeur au consumer restent inconnus avec conditions de reprise exactes. Cela ne clôt ni la fonctionnalité ColorPalette, ni Map10, ni `SYS-01.2-02`, ni le jeu. Aucune acceptation humaine n'est revendiquée.
