# V1158 — Producteurs de shaders Map10, run composé contrôlé

## Verdict

**PASS — périmètre borné uniquement.** Deux runs postérieurs au dernier code ont exécuté, dans l’ordre d’enregistrement original, le corps du producteur pixel `0x98C070`, puis le corps du producteur vertex `0x98D960`, jusqu’à leur `ret 8`. Les deux stores `record+0x04` sont non nuls et ownership-valides. Les deux ressources ont ensuite été libérées une fois, en ordre inverse, par les chemins originaux vertex `0x9AED50` puis pixel `0x9AEDC0`.

Ce verdict qualifie les **producteurs originaux au sein de cette composition adaptée/current-host**. Il ne qualifie pas un runtime Riot 2014 : le VFS/stream, l’initialisation include, les factories et les managers sont des adapters ou fixtures exact-layout ; D3DX/D3D9 sont ceux de l’hôte courant.

## Périmètre et arrêt strict

- Entrée pixel : `0x98C070`; store : `0x98C2B9`; fermeture stream : `0x98C2FF`; retour : `0x98C408`.
- Entrée vertex : `0x98D960`; store : `0x98DBA9`; fermeture stream : `0x98DBC8`; retour : `0x98DCD1`.
- Ordre nominal : pixel, vertex, cleanup vertex, cleanup pixel.
- Arrêt avant pair/résolution/bind/draw : zéro entrée dans `0x9AEE30`, `0x9C22E0` et `0x9BEF40` ; zéro setter shader, draw, Present ou readback.
- Les factories `0x9AEBF0`/`0x9AEA90` sont interceptées à leur entrée et composées via les bridges déjà qualifiés. Leur corps original n’est pas exécuté dans V1158.
- Les helpers directs de découpe de chemin, assignation `std::string`, comparaison, VFS, initialisation/destruction include, contrôle cookie et slots stream sont des interceptions bornées dont les conventions de pile ont été vérifiées contre le désassemblage.

## Entrées gelées

- PE original : `League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Préflight producteur V1156 : SHA-256 `51e1152db062fc5fabd2838d9f15a5006fbd1d8f4b77871b3e04505d9cfcf1bc`.
- Composition FOUR_BLEND V1156 : SHA-256 `fcf46d803a2d294860010038f1b9b3f16f96cdabbff51ae3b48dd445cb1bc318`.
- Source slot V1157 : SHA-256 `b58a7de0d6a7bb4574043d69adc62a312246678e63b6139dde04fd5b04865264`.
- Reçu slot V1157 : SHA-256 `a55b40b0c19bf7c79229ada2df7d01a39672e6c5dd850900eea886b45a1ac5be`.
- Sources FOUR_BLEND exactes et leurs includes sont ceux déjà épinglés dans V1155/V1156.
- Macros : 3 locales exactes (`COLORPALETTE_DEFAULT`, `DISABLE_EMISSIVE`, `FOUR_BLEND`) + 23 globales exactes, soit 26 paires ; flags D3DX `0x1000`.

## Préflight avant entrée

Avant chaque producteur, le harness appelle l’allocateur original sur le manager exact-layout du stage, exige un index strictement inférieur à `0x1000`, puis libère immédiatement ce slot par le chemin bitmap original. Le bitmap doit être revenu à zéro avant l’entrée producteur.

Ce test ne construit aucun wrapper et n’entre aucune factory. Aucune saturation n’est provoquée dans une factory. Cette contrainte ferme le risque V1156 : la factory construit le wrapper avant l’allocation et le sentinel `0x1000` pouvait sinon laisser un wrapper non libéré.

## Résultats nominaux observés

| Capture | Pixel | Vertex |
|---|---:|---:|
| Entrée originale | `0x98C070` | `0x98D960` |
| Instructions du span original tracées | 518 | 522 |
| `AL` au retour | 1 | 1 |
| Profil enregistré | `ps_2_0` | `vs_2_0` |
| `EDX` à l’entrée factory | 0 | 0 |
| Source bytes | 13 310 | 7 825 |
| Source SHA-256 | `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3` | `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5` |
| Include edges | 5 | 2 |
| Source expansée bytes | 25 052 | 11 390 |
| Source expansée SHA-256 | `74858d63d5b4d048d15f472f706ba181a300c20160ea5ea01b8b602a20c6e021` | `6694b4cb1ea6566ef1c7b85ce9d4f33ea2a35789af073e86615ce9bdd58066ed` |
| Bytecode bytes | 1 244 | 992 |
| Bytecode SHA-256 | `3d184c7984532a8177ce3588a66e7bc0b1fc931d46c3d3f79db3026cd1e5ca58` | `c1a169e3aabfe63ac7d90413aee2c440acc1525f8c80cafef4bceb08f0c5be42` |
| CTAB bytes | 500 | 464 |
| CTAB SHA-256 | `791e0d1c2fd7d7804886e10f0862b95da399808aa4f60389b899f1e3a00d03f0` | `74ac067514e52ea1c3b264110a52ffed8a3103743f69dd10567536d6892ddc40` |
| Pool record stocké à `record+4` | `0x63010000` | `0x63000000` |
| Wrapper | `0x64000100` | `0x64000180` |
| CTAB proxy | `0x64000140` | `0x640001C0` |
| Shader proxy | `0x64000160` | `0x640001E0` |
| Refcount record avant cleanup | 1 | 1 |

`AL=1` ne signifie que « stream ouvert ». La réussite est donc démontrée séparément par le handle `record+4` non nul, le refcount 1, le wrapper, la CTAB, le shader et le bit de slot feuille.

Le stream `+0x10` a conservé les trois arguments factory sur la pile, n’a dépilé aucun argument et a retourné le `char*` NUL emprunté. L’objet include observé porte la vtable `0x10DBAEC` et le répertoire produit par la logique complète est `Environment/` (normalisé `Environment`). Le stream et la source empruntée sont morts après l’appel close original avec `delete=1`.

## Correction apportée à la frontière V1157

V1157 qualifie correctement l’ABI du slot `+0x10`, mais son span tardif injectait artificiellement `flag=1`. Le producteur complet montre le calcul réel : `BL` vaut 1 uniquement si le profil enregistré est `ps_3_0`/`vs_3_0`. Les sources exactes sont `ps_2_0`/`vs_2_0`; les deux runs observent donc **`EDX=0`**.

De même, le producteur complet produit `Environment/` avec slash final. La valeur manuelle `Environment` de l’isolation V1157 n’est pas reprise comme octets bruts ; seule sa normalisation de répertoire reste cohérente.

## Ownership et cleanup

- Cleanup original exécuté : vertex `0x9AED50`, puis pixel `0x9AEDC0`.
- 94 instructions tracées pour chaque chemin cleanup.
- Pour chaque record : objet et refcount remis à zéro ; les trois niveaux de bits du slot sont faux ; wrapper libéré exactement une fois.
- Quatre releases host ont retourné zéro : CTAB vertex, shader vertex, CTAB pixel, shader pixel.
- Après cleanup : bitmaps pixel/vertex à zéro, région records à zéro, zéro proxy D3DX vivant, zéro shader host vivant.
- Fermeture host : aucun shader forcé ; release device `0`, release D3D9 `0`, fenêtre détruite.
- Device réellement observé : `NVIDIA GeForce RTX 3060`.
- D3DX courant : `C:\Windows\System32\d3dx9_39.dll`; D3D9 courant : `C:\Windows\System32\d3d9.dll`.

## Cas négatifs sûrs

Six refus ont été vérifiés avant toute entrée producteur/factory/allocateur : source SHA différente, `record+4` déjà non nul, nombre de macros locales différent, vtable include différente, préflight pool indisponible, stage inconnu. Tous ont produit le code attendu avec zéro entrée native. Aucun test de saturation n’a été tenté dans une factory.

## Reproductibilité et validation

Commandes réellement exécutées après le dernier changement du code producteur :

```powershell
$env:PYTHONDONTWRITEBYTECODE='1'
python -B .\audit_shader_producers.py --run-id final1 --output .\shader_producers_run1.json
python -B .\audit_shader_producers.py --run-id final2 --output .\shader_producers_run2.json
python -B .\validate_shader_producers.py
```

- Run 1 : `PASS`, 14/14 contrôles de haut niveau.
- Run 2 : `PASS`, 14/14 contrôles de haut niveau.
- Projection déterministe commune : `7d44993531535ac1be39fe636b8ac877fdcfd11de9f84aef5f7ab4cf5e630055`.
- Validateur en lecture seule : `PASS 191/191`, zéro échec.
- Reçu run 1 SHA-256 : `e1210e680d3f8fcd1257bf27f54a768d8264ed0eb769985ea9d86d9fcf5ed7df`.
- Reçu run 2 SHA-256 : `d6482660e38f307ca1a8d753020d536db0653ac0c9a601eb46832838fdfaa575`.
- Source producteur SHA-256 : `8fd19402acdcadee5b6b78707f25aa8b257d2eab82eea8080b6cda08dcd6bd0e`.
- Source validateur SHA-256 : `45fc09123a2ca4bc5f18824e02ab215dd65c2e6960c1ec8633c88e4c01f36dc6`.

## Limites conservées

1. Les spans producteurs originaux sont exécutés, mais leurs dépendances directes sont des interceptions bornées ; ce n’est pas un processus Riot vivant.
2. Les corps factories originaux ne sont pas exécutés par V1158. Leur comportement déjà qualifié est composé via l’expandeur original borné, D3DX/D3D9 current-host, l’allocateur original et le cleanup original.
3. Les managers, records et wrappers sont des fixtures synthétiques exact-layout, pas l’état live du client 4.20.
4. D3DX/D3D9 et les objets COM sont ceux de l’hôte actuel, pas ceux de 2014.
5. Aucun pair, bind, setter, draw, Present, readback ou frame rendu n’est qualifié.
6. Ce résultat ne démontre ni fidélité visuelle, ni complétude de Map10, ni gameplay, champion ou jeu complet.
7. L’exécution n’a écrit que dans le répertoire de preuve E: V1158. `F:` n’a servi qu’aux lectures des bibliothèques/outils et corpus épinglés ; l’écriture bytecode Python a été désactivée. Aucun produit, registre, Goal, Plan, UI ou base n’a été modifié.

