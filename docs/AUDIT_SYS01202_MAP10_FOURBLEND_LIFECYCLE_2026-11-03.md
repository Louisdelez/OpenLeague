# V1156 — Cycle lifecycle des shaders FOUR_BLEND exacts Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-FOURBLEND-LIFECYCLE-COMPOSITION-01`  
Verdict : **PASS pour la composition current-host/adapters bornée ; producteurs originaux, runtime 2014 et rendu toujours hors périmètre**.

## Résultat borné

Les sorties exactes V1155 des deux sources FOUR_BLEND ont franchi le cycle complet déjà qualifié séparément :

1. expansion par le helper original `0x9AE410` avec provider neuf-SHA adapté ;
2. compilation D3DX current-host avec les trois macros locales et 23 macros globales exactes ;
3. allocation du slot par l'original `0x8E28C0` ;
4. création d'un vrai `IDirect3DVertexShader9` ou `IDirect3DPixelShader9` sur la RTX 3060 ;
5. publication dans un record et wrapper exact-layout contrôlés ;
6. cleanup original `0x9AED50/0x9AEDC0 → 0x9BED40 → 0x8E2980` jusqu'à zéro.

Les fonctions productrices `0x98D960/0x98C070` ne sont jamais entrées. Aucun `SetVertexShader`, `SetPixelShader`, paire, bind, draw, `Present` ou readback de frame n'existe dans ce harness.

## Identités nominales

| Stage | Source | Buffer expansé | Bytecode | CTAB |
|---|---:|---:|---:|---:|
| vertex | 7 825 octets, `b7631de1…01e5` | 11 390, `6694b4cb…066ed` | 992, `c1a169e3…be42` | 464, `74ac0675…ddc40` |
| pixel | 13 310 octets, `d59435b2…95f3` | 25 052, `74858d63…6e021` | 1 244, `3d184c79…ca58` | 500, `791e0d1c…03f0` |

Ces six identités concordent exactement avec le reçu V1155 preprocess épinglé, SHA-256 `f9a855b53d6a9685e3ed9cda6d7e6fe433a490380b61f43c6f6d6c0494bd2197`. Les deux includes vertex et cinq includes pixel sont chargés et libérés une fois ; aucun buffer include ni accès invité invalide ne reste.

## Lifecycle nominal

Pour chacun des deux stages :

- `D3DXCompileShader` et `Create*Shader` current-host retournent `HRESULT 0` ;
- le slot original alloué est l'index 0 et son seul bit feuille est actif ;
- les deux bits supérieurs restent faux, conformément à leur rôle de résumé de sous-arbre plein ;
- le record possède un refcount 1 et les proxies CTAB/shader sont distincts ;
- le buffer code est libéré avant publication ;
- le cleanup original libère CTAB et shader avec résultats hôte zéro, le wrapper une fois, le record/refcount et les trois niveaux bitmap ;
- l'index 0 est immédiatement réutilisable puis relibéré ;
- aucune allocation/proxy/record/bitmap ne reste vivant.

Le device D3D9 et `IDirect3D9` sont finalement libérés à zéro et la fenêtre cachée est détruite. Le runtime est `C:\Windows\System32\d3d9.dll`, SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6`, sur `NVIDIA GeForce RTX 3060`.

## Rollbacks

Les trois cas négatifs réutilisent volontairement les fixtures négatives V1155, séparées des identités nominales FOUR_BLEND :

- erreur de compilation : seul le diagnostic existe, il est libéré à zéro, aucun pool/device n'est appelé ;
- erreur device par version invalide : le slot alloué est relibéré, code/CTAB reviennent à zéro, aucun record ni shader hôte ne reste ;
- saturation : 4 096 indices uniques, sentinelle `0x1000`, aucun appel device, tous les slots et buffers relibérés.

Tous les rollbacks sont atomiques dans la portée du harness.

## Reproductibilité

Producteur final : `audit_fourblend_lifecycle.py`, 13 471 octets, SHA-256 `fcf46d803a2d294860010038f1b9b3f16f96cdabbff51ae3b48dd445cb1bc318`.

- run 1 : `PASS`, SHA-256 `dfaadbf41543bf178871e071a3706c3da93bae44885ba88b758ae4114d5a181f` ;
- run 2 : `PASS`, SHA-256 `5b1301a4862cb7184f4b01c2a5265720574e717e699749b2553a56c29a2742f0` ;
- projection commune : `1cf2464ae587bdb4fbbaabd3daad52892aafaf0ed1e529738837d6ea64172c3d` ;
- validateur indépendant : `PASS 50/50`, non mutant par défaut, reçu SHA-256 `0705aa9a20c61425fcceb6e653a3b2e937c391185148419de7c9ef2fe59f7e23`.

Les runs finaux sont postérieurs à la dernière modification du producteur. `debug_run.json` est supersédé et exclu du manifeste final.

## Portée et reprise

Le corpus source/include est exact et le helper d'expansion est original, mais le provider est l'adapter borné V1155. D3DX/D3D9 sont ceux de l'hôte actuel ; managers, records et wrappers sont des fixtures invitées exact-layout, pas l'état Riot vivant de 2014.

La prochaine unité peut préparer puis exercer séparément une entrée producteur bornée qui publie les deux handles dans ces contrats composés et s'arrête avant paire/bind/draw. Elle ne doit pas présenter ce lot comme une preuve de runtime 2014, de frame rendue ou de fidélité visuelle.

Aucun fichier sous `F:`, produit, asset, registre, Goal, Plan, interface, application ou base n'a été modifié.
