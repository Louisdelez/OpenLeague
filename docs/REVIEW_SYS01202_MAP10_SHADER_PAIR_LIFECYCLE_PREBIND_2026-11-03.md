# Revue indépendante V1158 — shader pair lifecycle pré-bind

Verdict : **PASS — 244/244 contrôles, aucun écart**.

Cette revue est séparée du bundle primaire et n’a écrit que dans
`E:\mapslol3v3\audit_map10_v1158_shader_pair_lifecycle_review_20261103`.
Le PE 4.20 a été lu et rehaché statiquement ; il n’a pas été lancé. Aucun
produit, registre, Goal/Plan/UI ou base n’a été modifié.

## Gel et non-mutation du bundle primaire

Le manifeste primaire lui-même est resté à 2 761 octets, SHA-256
`5b0b89436225ffb1d16131502ecfb97584b9ffa042792f75e8cfdb9f57431d71`.
Ses sept artefacts ont été relus directement, avec concordance exacte des
tailles et SHA déclarés :

| Rôle | Artefact | Octets | SHA-256 |
|---|---|---:|---|
| producer | `audit_shader_pair_lifecycle.py` | 37 496 | `931882cd991039b52464fea33c87456a998b36923488eb2268ef3cb802444e66` |
| run 1 | `pair_lifecycle_run1.json` | 47 955 | `dfc70152ee7a85f6c8635f86973648038d0944d85bdf67fe72133a81de7a3616` |
| run 2 | `pair_lifecycle_run2.json` | 47 955 | `85471d3131a9f7ecc41491b82a59fc70b7677590167ad496f1d423d612030fa8` |
| validator | `validate_shader_pair_lifecycle.py` | 12 201 | `e9ed648e58837939fca4dd47ccaa61f5bba22ba25ee3d96362e80e3e940e960a` |
| validation receipt | `shader_pair_lifecycle_validation.json` | 5 004 | `e801396310494066a8dd2d8cb94067155a7df2d2a21263623d39c08736ea13c8` |
| report | `AUDIT_V1158_MAP10_SHADER_PAIR_LIFECYCLE_PREBIND.md` | 5 975 | `689a28bbb1d2726e0982ca7e59bf3a273419a4d1ff121804ad4f67e6306e963b` |
| manifest builder | `build_manifest.py` | 2 261 | `ee48ab62b1c16ffc3816913fc7c844db14c6409a4cba53d985ede2ca319239e5` |

Le validator primaire a été rejoué exactement sans `--output`, sous
`python -B`. Il a retourné code 0 et
`{"passed": true, "check_count": 43, "failed_checks": [], "output": null}`.
Le reçu primaire a conservé exactement taille, SHA et `mtime_ns` avant/après.
Le snapshot récursif complet du dossier primaire, y compris les trois `.pyc`
préexistants, est identique avant le validator, après le validator et après le
troisième run.

## Troisième run physique

Le producteur primaire a été exécuté une troisième fois avec `run_id=review3`.
Son seul reçu a été écrit dans le présent dossier :

- 47 958 octets ;
- SHA-256 `d7f20b2c7787feccdf74a9925c3b9887237c78e0871b7d673b54d4d1c86bc431` ;
- `passed=true` ;
- projection recomputée
  `1da44bcb97da0e71f7131c473941e42e7751d226132e7ce8e26f0ea64de16ed7`.

Les projections structurées des runs 1, 2 et 3 sont byte-logiquement
identiques après exclusion des champs non déterministes. Le run 3 termine avec
ownership nul : proxies D3DX et shaders hôte à zéro, bitmap/records de paire et
de stages nuls, cache vide, current/désirés nuls, aucune release forcée,
releases device/D3D9 à zéro et fenêtre détruite.

## Comparaison PE et frontière native

Le preflight V1157 est épinglé sans écart : JSON
`7b24fe28cf39f5c6463246882df7e2fc81bdb61a9765465f1a227831cf313d7c`
et rapport
`e2a66044762c1f8d79102e877299fa04d7dc2ad11a721ca8237c464050076bce`.
Le PE x86, image base `0x400000`, fait 15 973 880 octets et rehash à
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Fenêtre | Octets | SHA-256 | Observation indépendante |
|---|---:|---|---|
| factory `0x9AEE30..0x9AEFE0` | 432 | `8628a49035770f6bc44f0f8dfe85979fb337515cd3f4573823f075d39a7982f4` | entrée `558bec83e4f85153568bd98bf25785db` |
| resolver `0x9C22E0..0x9C239B` | 187 | `d86cec8ce20fc0b18b8535f9a134fd45d00376be697ae23471938d83d52f8583` | entrée `538bd98b83ac00000085c0750c3983a8` |
| binder `0x9BEF40..0x9BEF74` | 52 | `f6b38deb08c879b497be81bad3cc345ba24624bef206bc0453a1e0936a526067` | corps présent mais jamais entré |
| free `0x8E2980..0x8E29C6` | 70 | `5b2a03a37c7c319ff75fc662cd57f9349c69fb0cd3397cff0bacb44accf749fb` | entrée `558bec8b45082b4108578b792c85ff74`, fin `c20400` |

Les bytes `e8c9cbffff` à `0x9C2372` résolvent exactement vers `0x9BEF40`.
Cette instruction précède le store current à `0x9C2378`. La factory appelle
l’allocateur `0x8E28C0`, teste le sentinel `0x10000`, incrémente les deux
refcounts de stage, appelle l’adapter backend puis calcule le stride par
`shl 4`. Le resolver appelle la factory à `0x9C233B` et l’insertion cache à
`0x9C2349`.

Le release `0x9AEFE0` décrémente le refcount de paire, libère le backend puis
rend les références de stages, mais n’appelle pas `0x8E2980`. Le preflight ne
trouve pour ce free que les xrefs de release de stages `0x9AEDB2` et
`0x9AEE22`, jamais le release de paire. Le rollback explicite V1158 via le
vrai corps `0x8E2980` est donc bien distinct et nécessaire.

## Layout, cache, refcounts et rollback

Les trois runs prouvent le même contrat :

- capacité `0x10000`, sentinel plein `0x10000`, stride `0x10`, région records
  `0x100000` octets ;
- paire au slot/index 0, record `0x67000000`, refcount 1, bit feuille vrai et
  trois niveaux supérieurs faux ;
- records VS/PS `0x63000000` / `0x63010000`, refcounts `1→2` lors de la
  factory puis `2→1` lors du release de paire ;
- miss : cache reçoit exactement `0x67000000` tandis que current reste nul
  avant le bind interdit ;
- hit current-equal : current et cache restent `0x67000000`, refcounts
  inchangés, aucune factory/adaptation/insertion/bind supplémentaire ;
- après retrait du cache et release, backend et refcount paire sont nuls mais
  le slot reste occupé : le caractère monotone natif est observé, pas masqué ;
- le rollback explicite exécute `0x8E2980`, remet le bitmap à zéro puis
  l’allocateur réutilise exactement l’index 0 ; le free final remet encore le
  bitmap à zéro.

Les deux shaders hôte co-résident sur un seul device current-host. Le token
guest `0x6801f000` se résout vers ce seul device ; aucune composition de deux
devices différents n’est acceptée.

## Refus pré-entrée

Les refus vertex nul, pixel nul, mauvaise famille, device non co-résident,
échec de factory prédit et saturation du pool sont tous rejetés avant toute
entrée native. Pour chaque cas, les deltas factory, backend adapter, release,
resolver, insertion et bind valent tous zéro. Les raisons exactes sont
respectivement `vertex_handle_null`, `pixel_handle_null`,
`vertex_record_invalid`, `device_not_coresident`,
`pair_backend_factory_failure_predicted` et `pair_pool_saturated`.

## Traces miss/hit/release/free

| Trace | Instructions | SHA-256 des adresses | Première → dernière |
|---|---:|---|---|
| miss | 284 | `e1569038ee452deb4259ae7afb0e1a03ba4f7872c6562f11e93d88b5bc690c22` | `0x9C22E0 → 0x9C2372` |
| hit current-equal | 82 | `e7974472ec34c90bad00bcdcf386d54926ad9de461ec87239f8e50b539e68932` | `0x9C22E0 → 0x9C239A` |
| release paire | 40 | `842241674ba418f1bf78365eb141ba35fef8426cf57b9b28cada18871690af22` | `0x9AEFE0 → 0x9AEE2E` |
| rollback free | 66 | `73b70080d72bb583fa6fbdbf1a58f822dc0122dc69c6f00fd9af5830ee29d200` | `0x8E2980 → 0x8E29C3` |
| réallocation | 119 | `8761a03c9eda44607390b0d2aa990cc1d85630bd705ea93aeeff0f2aa8429f4a` | `0x8E28C0 → 0x8E2968` |

Les digests, comptes et fenêtres first/last sont identiques sur les trois runs.
Les reçus n’embarquent pas les flux complets d’adresses pour ces quatre traces ;
la revue ne prétend donc pas une comparaison adresse-par-adresse au-delà de
ces preuves et des bytes PE indépendants.

## Strict stop et limite de qualification

Les entrées natives du run 3 sont exactement : factory paire 1, adapter
backend 1, release paire 1, resolver 2, adapter cache 1, bind 0. La trace miss
s’arrête sur l’instruction `CALL` elle-même et n’entre jamais dans
`0x9BEF40`. Aucun producteur, `SetVertexShader`, `SetPixelShader`, draw,
`Present` ou readback n’est exécuté.

Nuance de preuve : seul le compteur d’entrée binder est instrumenté
dynamiquement de façon directe ; les zéros Set/draw/Present/readback sont des
assertions structurelles/littérales du harness. Elles sont corroborées par
l’arrêt avant le binder et par la surface hôte limitée à Create*Shader/Release,
mais ne constituent pas une instrumentation générique de toutes les API GPU.

Le device et `d3d9.dll` viennent du current-host (`NVIDIA GeForce RTX 3060`,
`C:\Windows\System32\d3d9.dll`). Le backend paire, l’entrée cache, le token et
les managers/records restent des adapters guest bornés ou exact-layout. Le PE
Riot 2014 n’est utilisé que comme source statique de bytes ; son runtime n’est
pas qualifié ni exécuté.

