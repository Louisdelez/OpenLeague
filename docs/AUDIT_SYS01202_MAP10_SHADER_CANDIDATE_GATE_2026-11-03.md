# V1161 — candidates shader Map10 et gate d'admission historique

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-SHADER-CANDIDATE-ADMISSION-GATE-01`  
Audit borné : **PASS**  
Fonctionnalité : **BLOCKED_BEFORE_MUTATION**

## Résultat

Deux permutations candidates ont été recompilées deux fois avec le bridge D3DX
current-host déjà qualifié. Les deux runs donnent la même projection
`9ec559e43c162dad34ccfc34811ed5a5bbac5c7a9fb89971262d0bf36e8cbcb1`.
Toutes les CTAB embarquées sont égales aux buffers retournés et tous les objets
D3DX sont libérés à zéro.

Ce résultat prouve seulement la reproductibilité des candidates. Il ne prouve
pas que le client Riot 4.20 a choisi l'une d'elles au draw Map10. Le gate
d'admission reste fermé tant qu'un reçu REA machine-readable ne relie pas le
vecteur ordonné exact aux deux producteurs et au consommateur terrain.

## Candidates reproductibles

### A — height + colormap

Macros locales ordonnées :

1. `COLORPALETTE_DEFAULT=1`
2. `DISABLE_EMISSIVE=1`
3. `FOUR_BLEND=1`
4. `USE_HEIGHT_BLEND=1`
5. `MOD2X_COLORMAP=1`

| Stage | Bytecode | CTAB | Registres consommés |
|---|---|---|---|
| VS | 816 octets, `6cf864b88b8b11b3357c9e31fbaa3a58f7d961699c250f85c9da12c3ed037803` | 396 octets, `b1a37e03d9cfb5108f59cd49d8a563be186516845f3f82331989641143f15f89` | `c0..3,c8..10,c31,c230,c231,c233,c250` |
| PS | 1 488 octets, `ce68b270b6ddce8147608ed5623bb4408ff90b559990961b2556e7f1f1e54400` | 528 octets, `cf8f558f3845e15232a4c6d9fba14dfda300dc2335c6e673a00fe5b91d2f7005` | `c12,c23,c25`; `s0,1,2,3,4,5,6,8,10` |

### B — height + colormap + fog pixel

Même ordre, puis `FOG_PIXELSHADER_BLEND=1`.

| Stage | Bytecode | CTAB | Registres consommés |
|---|---|---|---|
| VS | 1 116 octets, `8e741a9c203a7ad9fc50100d68a22875c6141ce6a0ff97f00c84cc6f7505bf52` | 444 octets, `8c520a041114bc0c20e8ed93107dde062f24d0a1a6ff2d04f204b656f2ff85f6` | candidate A + `c236,c237` |
| PS | 1 684 octets, `4f62f923e7a303685e0a51d32e191ba1086d64e0266456d7d21bf5ca2a82a849` | 560 octets, `afe9e3ff0703825b419610cf67533f18cab7729079ca04dadee7740384fb2c2f` | candidate A + `s9` |

La présence d'un bind `s9` ailleurs ne suffit pas à qualifier la candidate B.

## Gate d'admission

Le gate exige un objet `historical_macro_vector_link` dans le reçu REA avec :

- identité PE exacte `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- vecteur local ordonné exactement égal à une candidate ;
- mêmes arguments de vector aux producteurs `0x98c070` et `0x98d960` ;
- identité de l'argument factory établie ;
- lien au consommateur terrain `0x95a730` ;
- identifiants de preuves REA retenues `ev_*`.

Un reçu absent, partiel, en prose ou portant une autre identité est refusé. Dans
les deux runs présents, le reçu n'existait pas : verdict
`BLOCKED_BEFORE_MUTATION`, raison `REA_RECEIPT_MISSING`, état sentinelle
inchangé et zéro mutation. Même un futur reçu admis rendrait seulement le gate
`READY_FOR_SEPARATE_LIFECYCLE_NOT_EXECUTED` ; ce lot n'exécute jamais le
lifecycle.

## Exécutions et contrôles

```powershell
python -B audit_shader_candidate_gate.py --run-id run1 --output candidate_gate_run1.json
python -B audit_shader_candidate_gate.py --run-id run2 --output candidate_gate_run2.json
python -B validate_shader_candidate_gate.py --output candidate_gate_validation.json
python -B validate_shader_candidate_gate.py
```

Résultats : deux runs exit `0`; validateur `26/26`, exit `0`; seconde validation
non mutante, aucun octet du lot modifié.

## Frontières strictes

Exécuté : `D3DXCompileShader`, `D3DXDisassembleShader`, accès et libération des
buffers CPU.

Non exécuté : client original, producteurs originaux, `CreateVertexShader`,
`CreatePixelShader`, binds, upload de constantes, toute méthode de device D3D9,
`Draw*`, `Present`, readback ou inspection de pixel.

## Limites et reprise

- Runtime courant x64, pas runtime Riot x86 2014.
- Aucune candidate n'est historique à ce stade.
- Aucune valeur caméra/lumière/FoW, handle texture, render state ou sampler
  complet n'est ajoutée par ce lot.
- Aucune composition full-pipeline, frame, image, fidélité ou acceptation
  humaine n'est qualifiée.
- Reprendre uniquement avec le reçu REA V1161 final. S'il ne fournit pas le
  contrat exact, conserver l'inconnue au lieu d'assouplir le gate.

Aucun fichier sur `F:`, produit, registre, Goal, Plan, UI ou base n'a été
modifié.
