# SYS-01.2-02 — V1145 — publication composée conditionnelle du backend natif Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-COMPOSED-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé pour la publication composée sous le profil conditionnel `escape_refusal`**  
Verdict fonctionnel : **chemin nominal historique, upload et rendu non terminés**  
Acceptation humaine : **non demandée**

## 1. Exigence et frontières

V1144 ferme statiquement la chaîne `renderer+0x10 → provider+0x10 → 0x9C3E30 → 0x9C40C8 → renderer+0x14`, mais ne l'exécute pas en un seul parcours. V1145 traite uniquement cet écart : exécuter le caller original qui calcule `&renderer+0x14`, entrer dans la factory et le constructeur D3D9 originaux déjà qualifiés par V716, puis observer le store original dans ce vrai champ.

Le lot distingue strictement :

- le caller, la factory, le constructeur et le store originaux réellement exécutés ;
- les champs renderer et le descripteur de présentation fournis comme entrées déclarées ;
- les adaptations x86 invité → API Win32/COM 64 bits actuelles héritées de V716 ;
- le refus synthétique `STATUS_INVALID_PARAMETER (0xC000000D)` injecté avant l'appel pilote privé ;
- la publication composée conditionnelle observée, distincte du chemin nominal et de tout runtime 2014.

Sont exclus : exécution du bootstrap/constructeur complet du renderer, configuration de démarrage effective, provider RADS, relecture des DDS, méthode texture `0x9C2D40`, upload, draw, `Present`, pixels, correction produit, client/assets, registres, goal, Plan, application de suivi et bases.

## 2. Sources, identités et preuves réutilisées

### Source native et preuves amont

- Exécutable 4.20 : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- V714 : reçu `fidelity_graphics_platform_selection_v714.json`, SHA-256 `b7d983a065ed97e2756b53085410f78dc277ccb0278c12c233716bde437bf090`. Il qualifie le provider D3D9 à vtable `0x10E2E2C` publié dans `renderer+0x10`.
- V716 : reçu `fidelity_native_d3d9_device_v716.json`, SHA-256 `630e696bf6d15c68fce9de7dfd0eed284e76621890ae1bfdb7f13aa89b259a96`. Il qualifie séparément le retour conditionnel de `0x9C3E30 → 0x9C1430` avec une sortie adaptée, sans caller renderer.
- V1144 : caller et ABI statiques exacts, sans exécution composée.

Ces preuves sont réutilisées ; V714/V716 ne sont pas rejoués globalement.

### Runtime hôte explicitement daté

Les modules réellement identifiés pendant le banc sont ceux de la machine actuelle, pas ceux de 2014 :

| Module | Taille | SHA-256 |
|---|---:|---|
| `C:/WINDOWS/SYSTEM32/d3d9.DLL` | 1 799 712 | `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6` |
| `C:/WINDOWS/System32/USER32.dll` | 1 974 768 | `f285937030bcb325cad39ee5be4818f6666241229adeadea4ff1ae469dfd7ef3` |
| `C:/WINDOWS/System32/KERNEL32.DLL` | 861 992 | `e132eba4166256e2f414b91fe7d5386590bc5ea8626aee5af9c9738383cf2ae1` |
| `C:/WINDOWS/System32/GDI32.dll` | 187 456 | `772c73e294a4c5f5e0d4146288af95287a85c074d3aee3fa9f320dc010d7dbfe` |
| `C:/Windows/SysWOW64/nvapi.dll` | 441 368 | `d8db00e296cdf5844ea34b382f7a385732361b475b3cb50a5b15b7e40e4448a9` |
| `C:/Windows/System32/nvapi64.dll` | 572 368 | `6863bf52f439b9fb40fc0c279bad439d9b4a487c18e2a5590744fa4e13160c7d` |

Les deux NVAPI portent la version observée `32.0.16.1088`. Leur pont 32/64 bits est un adaptateur d'architecture actuel, pas une identité de pilote historique.

## 3. Consommateur original exécuté et adaptations

### ABI minimale qualifiée

L'inspection ABI borne la fonction englobante à `0x980FA0…0x98174A`, avec trois épilogues `ret 0x14`. Le span composé commence à `0x981102` et s'arrête à `0x98111C`, immédiatement après le retour de la factory et avant le traitement FS/TLS suivant.

Le caller original prépare les cinq arguments de `0x9C3E30` dans cet ordre :

1. `[renderer+0x0C]` ;
2. `[renderer+0x04]` ;
3. `EDX | 4` ;
4. `&renderer+0x34`, descripteur de présentation de treize dwords ;
5. `&renderer+0x14`, pointeur de sortie.

| Adresse | Instruction/rôle observé |
|---:|---|
| `0x981102` | charge le provider depuis `renderer+0x10` |
| `0x981105` | calcule `&renderer+0x14` |
| `0x981108` | pousse ce vrai pointeur de sortie |
| `0x981109…0x981116` | prépare descripteur, flags et autres arguments |
| `0x981119` | appelle `[provider.vtable+0x10] → 0x9C3E30` |
| `0x9C40A4` | appelle le constructeur `0x9C1430` |
| `0x9C40C8` | écrit l'objet construit dans le pointeur de sortie |
| `0x98111C` | frontière de retour du lot, avant le traitement FS/TLS |

Le renderer est placé à `0x40010000`; son vrai champ de sortie est donc `0x40010014`. Le provider original produit sous le contrat V714 est placé à `renderer+0x10` avec vtable `0x10E2E2C`, refcount `1`, interface Direct3D9 adaptée à `+0x08` et contexte Cg nul.

### Résultat composé

Le parcours exécute 3 341 adresses d'instructions originales. `0x9C40C8` écrit l'objet `0x40800010` dans `0x40010014`; son premier dword vaut `0x10E2F30`. La factory retourne par `ret 0x14`, et le delta net de pile du span minimal est nul.

### Feuilles et adaptations déclarées

- champs `renderer+0x04/+0x0C` et descripteur `+0x34` : entrées déclarées du profil V716 ; le constructeur renderer complet n'est pas exécuté ;
- provider : construit par le code original `0x9B7590` avec interface Direct3D9 adaptée, puis placé à `renderer+0x10` ;
- Win32/COM/NVAPI : ponts x86 invité → API 64 bits actuelles hérités de V716 ;
- allocateur, CRT, cookie, sections critiques, TLS/SEH et sorties diagnostic : feuilles déterministes V716 ;
- `0x48AC16` : requête privée capturée, jamais transmise au pilote ; retour synthétique `0xC000000D` ;
- aucune feuille texture, aucun DDS, aucune copie de pixels, aucun draw ou `Present`.

## 4. Contrôles exécutés, attendu et observé

### Exécution composée conditionnelle

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_backend_composed_20261103\probe_native_backend_composed.py
```

Attendu : le caller original doit passer le vrai `renderer+0x14`, atteindre la factory et le constructeur originaux sous le seul profil `escape_refusal`, puis `0x9C40C8` doit y publier un objet à vtable `0x10E2F30`. L'appel privé pilote doit rester non exécuté.

Observé : conforme. Le reçu porte `passed=true`, `audit_complete_for_declared_conditional_boundary=true`, `composed_renderer_publication=true`, `backend_publication_feature_complete=false`, `historical_nominal_path_complete=false`, `driver_private_escape_executed=false` et `gpu_upload_or_render_complete=false`.

Toutes les adresses requises sont observées : `0x981102`, `0x981105`, `0x981108`, `0x981110`, `0x981119`, `0x98111C`, `0x9C3E30`, `0x9C40A4`, `0x9C1430`, `0x48AC16` et `0x9C40C8`. La présence de `0x48AC16` signifie que la frontière originale a été atteinte et interceptée, pas que l'appel pilote a été transmis.

### Refus contrôlés

| Cas | Attendu | Observé | Qualification |
|---|---|---|---|
| provider nul | `ValueError: renderer provider is null` | identique | préflight du banc, pas refus natif |
| mauvaise vtable provider | `ValueError: renderer provider vtable refused` | identique | préflight du banc, pas refus natif |

Le contrôle négatif natif composé `allocation_refusal` est seulement recommandé par l'analyse ABI ; il n'est pas déclaré exécuté par V1145.

### Nettoyage et reprise d'échec

Le nettoyage hôte est réussi : fermeture adaptateur, libération de 32 vertex buffers, query, surfaces, device, Direct3D9, NVAPI et DLL chargée ; la fenêtre cachée est détruite. `native_full_teardown=false` demeure exact : le teardown original complet du renderer n'est pas exécuté et 27 allocations invitées/natives restent recensées dans l'arène au point d'arrêt. Cela ne doit pas être présenté comme un cycle de vie natif complet.

Le premier essai est conservé dans `initial_failure_cleanup_assertion.json`. Toute la publication native avait réussi, mais `host_cleanup_complete` restait faux parce que le bookkeeping conservait les handles après un `FreeLibrary` réussi. La correction retire chaque handle seulement après succès ; elle ne change ni le parcours natif ni son résultat.

La relecture PowerShell indépendante vérifie le profil, le vrai champ, la vtable, les 3 341 adresses, les onze ancres, l'absence d'appel pilote, les deux refus, le nettoyage hôte, la fenêtre détruite, `native_full_teardown=false` et les dix garde-fous. Résultat : `INDEPENDENT_V1145_RECEIPT_VALIDATION=PASS`.

## 5. Résolu et ouvert

### Résolu par V1145

1. Le caller original `0x981102…0x98111B` s'exécute, pas un appel direct ou un stub de la factory.
2. Le provider original compatible V714 est lu depuis le vrai `renderer+0x10`.
3. Le caller calcule et transmet le vrai `renderer+0x14` à `0x9C3E30`.
4. La factory et le constructeur originaux s'exécutent ; `0x9C40C8` écrit un objet à vtable `0x10E2F30` dans ce champ exact.
5. La frontière privée `0x48AC16` est atteinte, bloquée avant transmission et remplacée uniquement par le refus synthétique déclaré.
6. Le nettoyage des ressources hôte possédées et de la fenêtre cachée est observé.

L'audit du lot est donc terminé pour la publication composée **conditionnelle**.

### Toujours ouvert

1. **Chemin nominal historique** : le contrat privé et la réponse normale à `0x48AC16` ne sont pas qualifiés. Le refus injecté ne démontre pas Windows/pilote 2014.
2. **Démarrage renderer complet** : configuration effective, constructeur complet et champs amont sont déclarés, pas composés depuis le startup.
3. **Teardown natif** : 27 allocations de l'arène restent recensées ; aucun destructeur renderer complet n'est exécuté.
4. **Textures terrain** : `0x9C2D40`, création texture, upload DDS Map10, sampler et handles texture ne sont pas exécutés dans ce lot.
5. **Rendu** : aucun draw, `Present`, readback, pixel ou comparaison visuelle.

La publication conditionnelle du backend ne termine ni la fonctionnalité graphique, ni la fidélité historique, ni le parent `SYS-01.2-02`.

## 6. Conditions de reprise

Les clauses `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucun correctif produit n'est appliqué.

Reprendre seulement avec une piste qui dépasse la frontière actuelle :

1. qualifier séparément le contrat privé de `0x48AC16` ou capturer une réponse runtime sûre et identifiée ; ne jamais transmettre une requête privée inconnue au pilote ;
2. si un contrôle négatif natif est requis, composer seulement le profil V716 `allocation_refusal` et vérifier retour, pile restaurée, constructeur non entré et `renderer+0x14` resté nul ;
3. pour le cycle de vie, exécuter le destructeur/teardown renderer original et démontrer la libération des 27 allocations recensées, sans confondre nettoyage hôte et teardown natif ;
4. pour la suite terrain, partir de l'objet publié et exécuter `0x9C2D40` jusqu'à la frontière COM `CreateTexture`, puis qualifier séparément l'upload via `0x9BB110 → 0x9B6C10 → 0x9BB190 / D3DXLoadSurfaceFromMemory` avec un DDS Map10 identifié ;
5. exiger ensuite seulement un draw/readback identifié pour toute conclusion visuelle.

Ne pas répéter V714, V716, V1144, ce run `escape_refusal`, les I/O DDS V1143 ou le même contrôle de hashes si le PE, les profils et les reçus n'ont pas changé.

## 7. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_backend_composed_20261103/`.

- `perimetre.md` — SHA-256 `188e2f342871de1aee1656fc3325ab1913fe8389bebf7020e03ae387e9d341e4` ;
- `probe_native_backend_composed.py` — `d9ed6947f25c73a91d1d8ee14bfbd6162b6aad0d389a8d213d72d3b0c9945f61` ;
- `native_backend_composed_execution.json` — `2f2f22d9cea29781165603ef9942447a857d9fcefc9feee9e53577607d0bb028` ;
- `native_backend_composed_native_bytes.json` — `972613ff14184a80ec22cd1c47a47cdecf7e129d3fc0efd037db0fcd37a5615a` ;
- `initial_failure_cleanup_assertion.json` — `23b4cc7708e6ee2784b48617f60d593a399ecda302dbe89260ef77b823aa3cef` ;
- `inspect_backend_composed_abi.py` — `6b562355534b10ea3232ca01a28303e64d020b869b0391c9cb76a8895caf0c4f` ;
- `native_backend_composed_abi.json` — `8de0dc23348ab2a75862910bafd78aacbd6c9d2b1c4e512a6aee5298a47d940a` ;
- `reuse_and_risk_guard.json` — `bcb4c296bd0491fadf67c5b44713ea9aa3f31370dffedd0c18a73e394bb9f224` ;
- `REUSE_AND_RISK_GUARD.md` — `a45517d24616dcccf7073c15c7217bcd1ac1bd37a4f76352d1917ab69b297f07` ;
- ce rapport.

Décision : **V1145 est terminé pour la publication composée sous le profil conditionnel `escape_refusal`. Le chemin nominal historique, le teardown natif complet, la texture/upload terrain et le rendu restent incomplets.** Le parent, les corrections terrain et l'acceptation humaine restent ouverts.

Aucun fichier F:, client original, source produit, asset, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié par ce lot.
