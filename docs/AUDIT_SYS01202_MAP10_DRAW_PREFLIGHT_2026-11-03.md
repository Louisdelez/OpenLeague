# V1159 — préflight statique du draw Map10 après bind

Date : 2026-11-03  
Périmètre : `backend+0x20` depuis `0x95B112`, D3D9
`DrawIndexedPrimitive`/`DrawPrimitive`, état requis, nettoyage et frontière
avant `Present`/readback  
Mode : lecture statique ; livrables E-only

## Verdict

- préflight statique déclaré : **READY** ;
- exécution contrôlée du draw : **BLOCKED** ;
- fidélité historique : **BLOCKED** ;
- bind, draw, `Present` et readback dans ce lot : **NON EXÉCUTÉS**.

Le contrat binaire du draw et les six arguments sont fermés. La V1159 de bind,
maintenant publiée, est épinglée et valide séparément le couple shader sur le
device courant. En revanche, aucune exécution unique ne compose encore ce bind,
la géométrie V1153, une cible/scène, les constantes caméra, le matériau complet
et le draw. L'audit statique est terminé ; la fonctionnalité de rendu ne l'est
pas.

## Sources épinglées et réutilisées

- exécutable 4.20 x86, image base `0x400000`, SHA-256
  `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- SDK Windows `d3d9.h`, SHA-256
  `df78083ee8e75e6d3851422f6aa8abf6213e349f22bf27e7f161e98e8d90df04` ;
- V1150 : caller et frontière avant draw ;
- V1153 : déclaration selector 2, VB1, IB1 et arguments du mesh 1093 ;
- V1158 : producteurs `FOUR_BLEND`, paire/cache et cycle de vie pré-bind ;
- V1159 bind : `SetVertexShader` et `SetPixelShader` S_OK, vérification par
  getters, cache/current identiques, cache-hit suivant sans factory/insert/bind ;
- snapshot REA existant et reçu de validation.

Le snapshot REA a seulement été rehashé. Aucun import, aucune session et aucune
requête REA n'ont été relancés. Aucun logiciel n'a été installé. Aucun fichier
F:, produit, registre, Goal, Plan, UI ou base n'a été modifié.

## Résolution vtable et chaîne nominale

La vtable backend commence à `0x10E2F30` :

| Offset | Cible | Rôle |
|---|---:|---|
| `+0x14` | `0x9C21F0` | flush virtuel vers le resolver |
| `+0x1C` | `0x9C23A0` | `DrawPrimitive` backend |
| `+0x20` | `0x9C2400` | `DrawIndexedPrimitive` backend |
| `+0x28/+0x2C` | `0x9C24F0/0x9C2500` | `BeginScene` / `EndScene` |
| `+0x3C` | `0x9C2C40` | stream source |
| `+0x50` | `0x9C2B50` | index buffer |
| `+0x58` | `0x9C2BB0` | vertex declaration |
| `+0x68` | `0x9C3050` | texture |
| `+0x70` | `0x9C2270` | sampler |
| `+0x84/+0x90` | `0x9C30C0/0x9C3110` | handles VS/PS |
| `+0x98` | `0x9C3140` | constantes float |
| `+0xB8` | `0x9C3390` | `Present` — frontière interdite |
| `+0xC8/+0xD0/+0xDC` | `0x9C3620/0x9C36B0/0x9C3820` | RT / depth / viewport |

Chaîne exacte du draw indexé :

1. `0x95B112` appelle `[backend.vtable+0x20]`.
2. `0x9C2400` appelle toujours `0x9C22E0` à `0x9C2406`.
3. Après un bind V1159 valide, le seul état acceptable est un cache-hit où
   desired, cache et current désignent la même paire ; V1159 prouve que ce cas
   ne refait ni factory, ni insertion, ni bind.
4. `0x9C2444` traduit le primitive interne via `0x10E2B0C`.
5. `0x9C2451` appelle `0x9C54A0` avec `ECX=device`, `EDX=primitive D3D9` et
   cinq arguments sur la pile.
6. `0x9C54E8` appelle `IDirect3DDevice9::DrawIndexedPrimitive`, slot 82,
   offset `0x148`.
7. Le backend retourne avec `ret 0x18` à `0x9C245B`, puis le caller avec
   `ret 0x0C` à `0x95B11B`.

## ABI et calcul des arguments

À `0x95B112`, les arguments internes observés en V1153 sont :

`[0, 0, 213, 3, 252, 1]`

Ils signifient :

| Champ | Valeur | Source |
|---|---:|---|
| primitive interne | 0 | littéral |
| `BaseVertexIndex` | 0 | littéral |
| `MinVertexIndex` | 213 | batch `+0x0C` |
| `NumVertices` | 3 | batch `+0x10` |
| `StartIndex` | 252 | batch `+0x14` |
| `PrimitiveCount` | 1 | batch `+0x18` |

La table commence par `[4,5,6,3,1,0]` ; le type interne 0 devient donc
`D3DPT_TRIANGLELIST(4)`. L'appel COM reçoit :

`[4, 0, 213, 3, 252, 1]`

Contrôles de bornes statiques :

- VB1 : `60324 / 44 = 1371` sommets ;
- fenêtre vertex : `[213,216)`, octets `[9372,9504)`, soit 132 octets ;
- IB1 : `3456 / 2 = 1728` indices `D3DFMT_INDEX16` ;
- un triangle consomme trois indices : fenêtre `[252,255)`, octets
  `[504,510)` ;
- valeurs exactes : `[213,214,215]` ;
- base 0 : indices effectifs `[213,214,215]`, tous dans `[213,216)` et dans
  le VB.

Le calcul est **PASS_STATIC**. La base vaut zéro ; ce lot ne généralise pas la
sémantique de `MinVertexIndex` à un appel avec base non nulle.

## Implémentation parallèle `DrawPrimitive`

La voie non indexée est identifiée sans être utilisée par le mesh 1093 :

- backend `+0x1C → 0x9C23A0` ;
- flush virtuel `+0x14 → 0x9C21F0 → 0x9C22E0` ;
- raw wrapper `0x9C5380` ;
- `IDirect3DDevice9::DrawPrimitive`, slot 81, offset `0x144` ;
- ABI COM : primitive, `StartVertex`, `PrimitiveCount` ;
- même traitement d'erreur que la voie indexée.

## HRESULT du draw

Le wrapper raw ne propage pas un statut exploitable par le caller :

- le slot 82 retourne le `HRESULT` dans `EAX` ;
- `0x9C54EE` copie immédiatement `EAX` dans `ESI` ;
- `TEST ESI,ESI` puis `JNS` considère tout résultat non négatif comme succès ;
- `0x88760868` (`D3DERR_DEVICELOST`) contourne le log d'erreur ordinaire ;
- les autres valeurs négatives sont formatées avec
  `Riot::X3D::D3D9::D3D9Throws::Direct3DDevice9_DrawIndexedPrimitive` ;
- les opérations TLS/logging réutilisent `EAX`, et les deux wrappers extérieurs
  n'exploitent aucun statut agrégé stable.

Un futur run devra donc capturer le `EAX` brut exactement au retour du slot 82,
avant toute instruction suivante. Pour la preuve, toute valeur négative — y
compris `DEVICELOST` — sera un échec de draw suivi d'un rollback.

## État requis avant toute entrée draw

| Domaine | État actuel | Condition manquante |
|---|---|---|
| shaders/cache | composant V1159 valide séparément | même run que cible, matériau, géométrie et draw |
| géométrie | V1153 valide séparément | recréée sur le même device que shaders et cible |
| render target/depth | RT0/depth vus au setup V1153 | descripteurs compatibles, ownership et rollback |
| viewport/scissor | non qualifiés au draw | bornes exactes sur la cible et restauration |
| scène | aucun `BeginScene`/`EndScene` qualifié | `BeginScene` S_OK possédé par le harness, `EndScene` équilibré |
| caméra/monde | helper `0x5F6620` adapté | matrices Map10 exactes |
| constantes | registres 23/25 observés mais payloads adaptés | toutes les plages lues par les deux bytecodes exacts |
| matériau/render states | type 3, material1, toggle connus | liste complète états/valeurs/HRESULT/rollback |
| textures | s4/s8/s9 exactes | identités historiques s0..s3 |
| samplers/stages | CLAMP U/V s8/s9 | états complets des stages réellement consommés |

V1153 a créé un backbuffer `1280x800`, `D3DFMT_X8R8G8B8(22)`, sans
multisampling, windowed, avec auto-depth `D3DFMT_D24S8(75)` et intervalle
immediate. `GetRenderTarget(0)` et `GetDepthStencilSurface` ont retourné S_OK ;
leurs surfaces font toutes deux `1280x800`, MSAA none. Ce sont des composants
de setup, pas une composition draw : aucun `BeginScene`, `EndScene` ou
`SetViewport` n'a eu lieu. Le futur run devra poser explicitement le viewport
`{0,0,1280,800,0.0,1.0}` et en posséder le rollback.

Les wrappers statiques sont fermés : `BeginScene` atteint le slot 41 à
`0x9C55F8`, `EndScene` le slot 42 à `0x9C5708`, `SetRenderTarget` le slot 37 à
`0x9C6FED`, `SetDepthStencilSurface` le slot 39 à `0x9C71E9`, `SetViewport` le
slot 47 à `0x9C74ED`; `Present` atteint le slot 17 à `0x9C69A0` et reste
interdit.

L'inspection conservatrice de la source active avec les macros exactes V1156
montre que c23/c25 et s4/s8/s9 ne suffisent pas : le VS dépend notamment des
plages WVP c0..c3, shadow c8..c11, directionnelles c14/c15, fade c31 et
FOW/cloud c230/c231/c250 ; le PS utilise au moins c0/c12. Les samplers actifs
sont s0..s4 plus s5 shadow, s6 FOW, s7 clouds et s10 overlay. s5/s6/s7/s10
sont absents/null dans la composition actuelle. Cette liste est un minimum de
préflight issu de la source, pas encore une réflexion du bytecode ni une preuve
des valeurs Map10.

Les 25 `GetRenderState` de V1153 sont conservés dans le JSON sous leurs IDs et
valeurs brutes. Ils sont qualifiés comme snapshot current-host/fixture, jamais
comme valeurs historiques : le futur run doit les enregistrer et les restaurer,
pas les supposer.

La cible, le depth, le viewport et le scissor doivent être compatibles ; le
device doit être coopératif ; tous les objets doivent appartenir au même
`IDirect3DDevice9`. Un échec de getter, setter, `BeginScene` ou validation de
borne interdit l'entrée `backend+0x20`.

## Nettoyage requis

Ordre prévu, non exécuté :

1. capturer le `HRESULT` brut et revenir entièrement de `0x95AFC0` ;
2. restaurer les caches terrain `+0x5C/+0x60/+0x64/+0x68/+0x6C/+0x72` ;
3. restaurer declaration, stream/offset/stride, indices, shaders, constantes,
   textures, samplers, stage states et render states ;
4. restaurer viewport/scissor, depth et render targets ; libérer toutes les
   références acquises par getters ;
5. restaurer desired/current/cache et libérer pair avant les handles VS/PS ;
6. appeler `EndScene` seulement si le harness possède le `BeginScene` ;
7. libérer géométrie, textures, shaders, surfaces, device, D3D9 et fenêtre,
   puis comparer état et refcounts à la baseline.

Un setter null ou une paire null n'est jamais une preuve de restauration. Les
getters, identités et `HRESULT` doivent la confirmer.

## Frontière avant `Present` et readback

La dernière instruction originale autorisée pour un futur draw borné est le
retour `0x95B11B`, suivi exclusivement du rollback/teardown. Sont interdits :

- `IDirect3DDevice9::Present`, slot 17 / `+0x44` ;
- `IDirect3DSwapChain9::Present`, slot 3 / `+0x0C` ;
- `GetRenderTargetData`, slot 32 / `+0x80` ;
- `GetFrontBufferData`, slot 33 / `+0x84` ;
- `LockRect` de frame/backbuffer et toute capture d'écran.

Les getters d'état (`GetRenderTarget`, `GetDepthStencilSurface`, `GetViewport`,
`Get*State`) sont autorisés uniquement pour le snapshot ; ils ne lisent pas de
pixels.

## Gaps bloquants précis

1. `BIND_TO_DRAW_SAME_RUN_COMPOSITION_NOT_QUALIFIED` ;
2. `RENDER_TARGET_DEPTH_VIEWPORT_SCENE_NOT_COMPOSED` ;
3. `CAMERA_WORLD_AND_SHADER_CONSTANTS_NOT_EXACT` ;
4. `MATERIAL_RENDER_STATE_CONTRACT_NOT_CLOSED` ;
5. `DETAIL_TEXTURE_IDENTITIES_S0_S3_UNKNOWN` ;
6. `FULL_TEXTURE_SAMPLER_STATE_NOT_CLOSED` ;
7. `DRAW_HRESULT_CAPTURE_AND_FAILURE_ROLLBACK_NOT_QUALIFIED` ;
8. `FULL_PIPELINE_SNAPSHOT_AND_ROLLBACK_NOT_QUALIFIED`.

Les gaps 1, 2, 3, 4, 6, 7 et 8 bloquent le draw technique contrôlé. Le gap 5
bloque explicitement la fidélité historique, même si un futur test technique
pouvait utiliser des textures identifiées comme fixtures.

## Contrôles exécutés

- générateur pur standard-library, lecture seule des sources puis écriture du
  seul JSON de preuve sous E: ;
- validation indépendante d'abord sans sortie : **PASS 36/36** ;
- 18 fenêtres PE et 25 séquences d'instructions réinspectées ;
- toutes les preuves V1150/V1153/V1158/V1159 et le snapshot REA rehashés ;
- vérification des arguments, capacités, bornes, slots D3D9, gaps, frontière,
  cleanup et absence d'exécution native ;
- entrée draw, bind, `Present`, readback, création device/ressource : zéro.

Ce lot ferme uniquement le préflight statique annoncé. Il ne déclare ni draw,
ni pixel, ni frame, ni fidélité visuelle, ni carte ou jeu complets.
