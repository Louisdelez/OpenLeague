# Revue indépendante V1155 — prétraitement des shaders FOUR_BLEND

## Verdict

Revue réussie : 24 contrôles agrégés sur 24. Les deux sources FOUR_BLEND et leurs sept inclusions exactes sont développées de façon déterministe par le helper historique `0x9AE410..0x9AE57E`, puis compilées avec succès par le bridge D3DX de l’hôte courant. Une troisième exécution indépendante reproduit la projection des deux runs producteurs.

Cette qualification porte uniquement sur l’intégration bornée VFS/includes → buffer développé → D3DX. Elle ne prouve ni l’équivalence du provider/VFS Riot historique, ni le chemin complet des factories de shaders, ni l’intégration produit.

## Outil et ABI identifiés

Le prétraitement exact observé avant `0x9BE940` est le helper interne du client 4.20 situé à `0x9AE410..0x9AE57E`, et non `D3DXPreprocessShader`.

- PE : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; x86 ; image base `0x400000`.
- Corps du helper : 367 octets ; 130 instructions ; SHA-256 `c84ac7d6a13a3581660e8db8db92dc831896d2384c7bd159c9ca554ba095d676`.
- Contrat statique revérifié indépendamment : recherche textuelle de `#include`, extraction du littéral entre guillemets avec limite `< 0x200`, callback provider slot 0, récursion vers `0x9AE410`, callback free slot `+4`, ajout de la fin du source, `AL=1` en succès et `AL=0` en échec.

Le provider est un adaptateur borné : il ne sert que les neuf fichiers dont la taille et le SHA sont épinglés. La détection de cycle est également un garde de cet adaptateur, exécuté avant toute entrée native ; elle n’est pas attribuée au helper historique.

## Sources, inclusions et expansions

Les neuf fichiers présents sur F correspondent exactement aux neuf tailles et SHA attendus. Aucune écriture n’a été faite sur F.

Ordre revérifié :

- vertex : `../Fog/Fog.hls`, puis `../FogOfWar/FogOfWar_VS.hls` ;
- pixel : `../ShadowMap/pcf1.hls`, `../HeightBlending/HeightBlending.hls`, `../DeathScreen.hls`, `../MipLevels.hls`, puis `../FogOfWar/FogOfWar_PS.hls`.

Le modèle de développement écrit indépendamment reproduit bit à bit les buffers natifs :

- vertex : 11 390 octets ; SHA-256 `6694b4cb1ea6566ef1c7b85ce9d4f33ea2a35789af073e86615ce9bdd58066ed` ; trois entrées dans le helper ; 265 instructions exécutées ;
- pixel : 25 052 octets ; SHA-256 `74858d63d5b4d048d15f472f706ba181a300c20160ea5ea01b8b602a20c6e021` ; six entrées dans le helper ; 610 instructions exécutées.

Sept loads correspondent aux sept littéraux, sept frees uniques sont observés, aucun buffer include ne reste vivant, aucun accès mémoire invalide n’est présent et aucun token `#include` ne subsiste.

## Compilation D3DX sur l’hôte courant

Le bridge V1154 est épinglé au SHA-256 `40e2c2e863c1f9c832bb5d5d51eebad146fb5df1aad0ee97cd0852ce6db903ae`. Son contrat refuse un pointeur d’include non nul ; le cas utilisé passe `pInclude=NULL`. Les trois macros locales et les 23 macros globales, dans leur ordre exact, sont observées sur les trois runs.

- vertex `vs_2_0` : HRESULT 0 ; bytecode 992 octets, SHA-256 `c1a169e3aabfe63ac7d90413aee2c440acc1525f8c80cafef4bceb08f0c5be42` ; CTAB 464 octets, SHA-256 `74ac067514e52ea1c3b264110a52ffed8a3103743f69dd10567536d6892ddc40` ;
- pixel `ps_2_0` : HRESULT 0 ; bytecode 1 244 octets, SHA-256 `3d184c7984532a8177ce3588a66e7bc0b1fc931d46c3d3f79db3026cd1e5ca58` ; CTAB 500 octets, SHA-256 `791e0d1c2fd7d7804886e10f0862b95da399808aa4f60389b899f1e3a00d03f0`.

Les buffers d’erreur sont nuls. Les proxies code/CTAB sont libérés à zéro et aucun proxy ne reste vivant.

## Déterminisme et validation

- run final 1 : SHA-256 `f9a855b53d6a9685e3ed9cda6d7e6fe433a490380b61f43c6f6d6c0494bd2197` ;
- run final 2 : SHA-256 `e15b83d0d12c1f4598eec16d90e03f0940eeebbb7d7061eb5385179f1e5c249d` ;
- troisième run de revue : SHA-256 `f2ce5aa6c14d66338e570f15d7b6c482f98a48ef4f1da10568aaec8b739b50b8`.

Les trois projections valent `2fc74c5dc01a7b57cc03e37710c38949565c0ddd4e12d35a447200c834808998`. Chaque run réussit ses 16 contrôles.

Le validateur V1155 a été relancé sans `--output` : code 0, 54 contrôles réussis, `output: null`. Le SHA et le mtime du reçu de validation sont strictement inchangés avant/après ; les six artefacts du manifeste source sont également inchangés. Le manifeste source est valide 6/6 par recalcul indépendant.

## Refus, nettoyage et limites

Les quatre refus natifs bornés revérifiés sont : include non autorisé, guillemet ouvrant absent, guillemet fermant absent et littéral de longueur 512. Ils retournent l’échec sans fuite ni accès invalide. Le cycle synthétique est refusé par le garde de l’adaptateur avant le helper natif, car aucun garde de cycle historique n’est démontré.

Les compteurs structurels restent à zéro pour `0x98D960`, `0x98C070`, `CreateVertexShader`, `CreatePixelShader`, pool/cleanup possédé, bind, draw, Present et readback. Ces zéros décrivent les capacités et limites du harnais, pas une trace d’exécution Riot complète.

## Artefacts de revue

- `review_v1155.py` : vérificateur indépendant, sans import du producteur V1155 ;
- `shader_preprocess_review_run3.json` : troisième exécution native et compilation D3DX ;
- `independent_review_receipt.json` : reçu de 24/24 ;
- `artifact_manifest.json` : manifeste final de la revue.
