# V1152 — Publication ciblée FOUR_BLEND : préflight et refus borné

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-PUBLICATION-PREFLIGHT-01`  
Verdict : **préflight clôturé ; publication ciblée non exécutée et toujours ouverte**.

## Résultat

La tentative a été arrêtée avant `0x98D960` et `0x98C070`. Les entrées statiques exactes, le compilateur D3DX présent sur l’hôte et le device D3D9 réutilisable sont confirmés, mais cinq contrats runtime indispensables ne sont pas prêts dans le harness backend composé V1145, ensuite hérité par V1150. Entrer dans un producteur maintenant ne garantirait ni la livraison exacte des sources avec leurs inclusions, ni le nettoyage intégral des objets créés.

Ce refus est un résultat de sécurité du harness, pas un comportement natif/Riot. Il ne constitue pas une publication, une compilation physique, un succès GPU ou une preuve historique.

## Cible exacte confirmée

| Stage | Descripteur | Producteur | Store `record+4` | Source | SHA-256 |
|---|---:|---:|---:|---|---|
| Vertex | `0x123F678` | `0x98D960` | `0x98DBA9` | `Environment/LIT_VS.vs_2_0` | `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5` |
| Pixel | `0x123F550` | `0x98C070` | `0x98C2B9` | `Environment/LIT_PS.ps_2_0` | `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3` |

Les deux descripteurs contiennent exactement `DISABLE_EMISSIVE;FOUR_BLEND`. Le profil V1151 sélectionné pour `palette=0`, brouillard désactivé et qualité `-1` soumet, dans cet ordre :

1. `COLORPALETTE_DEFAULT=1` ;
2. `DISABLE_EMISSIVE=1` ;
3. `FOUR_BLEND=1`.

Le compilateur D3D natif complète ce tableau avec `VCOLORSWIZZLE=rgba` et `IS_OPENGL=0`, appelle `D3DXCompileShader` avec `main`, `vs_2_0` ou `ps_2_0`, et les flags `0x1000`. L’import original est à l’IAT `0xFA4800` dans `d3dx9_39.dll`.

Le contrat de macros réutilisé vérifie 96 cas FOUR_BLEND, soit 48 configurations pour chacun des deux stages, mais renvoie un handle de compilateur factice. Il ne prouve donc pas une compilation D3DX physique.

## Sources et inclusions disponibles

Les neuf fichiers nécessaires sont présents et épinglés. Les sept inclusions ne contiennent pas d’inclusion supplémentaire :

| Fichier autorisé | Octets | SHA-256 |
|---|---:|---|
| `Environment/LIT_PS.ps_2_0` | 13 310 | `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3` |
| `Environment/LIT_VS.vs_2_0` | 7 825 | `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5` |
| `ShadowMap/pcf1.hls` | 2 235 | `938d0cbc2dd1cc9e42ac170c990ee8e2792cdb4fd2f2c79b06dca231f63af876` |
| `HeightBlending/HeightBlending.hls` | 1 321 | `7b9354f7ed5e23b9259bae1883c02d7a8ad91f694ecbac5c0001721aa00812fb` |
| `DeathScreen.hls` | 1 201 | `6f7b16e0a4f7ee33517353ab0b80ac42aa8e3c6f9ebb58f4b932a0cdb75b3cae` |
| `MipLevels.hls` | 398 | `344cf5e607d6fd49627410c43a52acd0d3d325db72536657055f659e33d1c5ab` |
| `FogOfWar/FogOfWar_PS.hls` | 6 760 | `04d3f73f2b0e82fcad7974ff71f51088728f727837b4c7cde5428a15c9964268` |
| `Fog/Fog.hls` | 1 613 | `a6beed0f3e9044eda22a761241dfa7e410beb5e743640d0df6a96f388a9f66c7` |
| `FogOfWar/FogOfWar_VS.hls` | 2 015 | `a42f658c4c25d819a6a8af5f311c897288877ef464d326e609be83f6f74b2cbe` |

## Prérequis disponibles

- Exécutable original PE32 x86 exact : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- V1151 : identité des descripteurs, producteurs, stores, factories et chemins de nettoyage épinglée.
- `d3dx9_39.dll` : export `D3DXCompileShader` présent dans les DLL hôte x64 et invitée x86 ; SHA-256 respectifs `aecbe2965f7c9aa60257670114c06b21a3de914b03e20ff569c5cb44ec4807fd` et `5d29988cad858f754ecc62c3d30de555f82cc21b5b26c448b890295e9b7bee82`.
- Preuve V1145 réutilisée puis héritée par V1150 : device current-host créé avec succès sur `NVIDIA GeForce RTX 3060`, backend `0x10E2F30`, 40 entrées de nettoyage hôte à zéro, fenêtre détruite et aucun upload/draw/Present. Cette preuve conserve `native_full_teardown=false` et 27 allocations invitées vivantes ; elle ne démontre donc pas un teardown natif complet.
- Slots SDK exacts : `+0x16C CreateVertexShader`, `+0x1A8 CreatePixelShader`; les slots de bind `+0x170/+0x1AC` restent interdits dans ce lot.

## Cinq contrats manquants

| Contrat | Manque exact | Condition de reprise |
|---|---|---|
| VFS/streams et inclusions | Le probe V1145, ensuite hérité par V1150, ne fournit ni instance/trace `0x8B4FB0`, ni ABI stream vérifiée. Le flux principal appelle `vtable+0x10`, puis ferme au slot 0. L’include object `0x10DBAEC` passe par `0x98D4E0/0x98D720` et exige `+0x14` taille/tell, `+0x1C` seek, `+0x24` read puis close. | Ajouter un provider lecture seule limité aux neuf SHA ci-dessus, prouver normalisation des chemins, sorties, tailles, lectures et libérations. |
| Bridge D3DX | Le hook courant n’a pas de handler `D3DXCompileShader`, `ID3DXBuffer` ou `ID3DXConstantTable`; il refuserait par `Unprovided native import`. | Traduire `D3DXMACRO` guest x86 vers hôte x64 ; supporter `Release +0x08`, `GetBufferPointer +0x0C`, `GetBufferSize +0x10`, sorties code/erreur/CTAB et nettoyage des échecs. |
| Création des stages D3D9 | Le bridge device n’expose pas `CreateVertexShader`, `CreatePixelShader`, `IDirect3DVertexShader9` ou `IDirect3DPixelShader9`. | Ajouter uniquement `+0x16C/+0x1A8` et `Release` des interfaces retournées ; aucun bind. |
| Pools shader | Aucun état vivant/possédé n’est prouvé pour VS `base 0x2D79574 / allocator 0x2D79638` ni PS `base 0x2D791D0 / allocator 0x2D792CC`. | Initialiser les pools originaux ou adapter de façon bornée `0x8E28C0/0x8E2980`, index `<0x1000`, avec snapshots avant/après et absence de collision. |
| Nettoyage possédé | V1145 n’a jamais créé de record de stage et ne prouve pas encore le nettoyage shader composé. Son nettoyage hôte ne remplace pas le teardown natif incomplet signalé ci-dessus. | Après capture : VS `0x9AED50`, PS `0x9AEDC0`; observer `0x9BED40` libérer CTAB + shader brut, `0x8E2980` libérer le slot, `record[0]=0`, tous les proxies possédés à zéro. |

## Critère exact de la prochaine tentative

Le préflight doit d’abord rendre les cinq contrats ci-dessus vrais. Un stage n’est alors publiable que si :

- `entry+4` est non nul ;
- `record[0]` est non nul et `record[1] == 1` ;
- `wrapper+0x10` est non nul ;
- les HRESULT de `D3DXCompileShader` et `Create*Shader` valent zéro ;
- le nettoyage exact remet le record et tous les objets possédés à zéro.

Tout échec de source/inclusion, compilation, création, pool, handle ou nettoyage reste un refus. `AL=1` au retour du loader ne suffit pas à prouver la publication.

## Condition d’arrêt respectée

Dans ce lot :

- entrées `0x98D960` : `0`, `0x98C070` : `0` ;
- entrées `0x9C22E0` : `0`, `0x9BEF40` : `0` ;
- bind : `0`, Draw : `0`, Present : `0`, readback frame/ressource : `0` ;
- objets hôte créés : `0`, allocations natives nouvelles : `0`, objets possédés restants : `0`.

## Vérifications réellement exécutées

- compilation syntaxique des deux scripts avec Python 3.10 : succès ;
- `audit_shader_publication_preflight.py` : succès du préflight, verdict `bounded_refusal_before_native_producer_entry` ;
- `validate_shader_publication_preflight.py` : `14/14` contrôles vrais ;
- recalcul indépendant des empreintes de toutes les entrées et des neuf fichiers d’inclusion ;
- relecture indépendante des descripteurs et fenêtres PE ;
- vérification des exports D3DX et des slots du SDK D3D9.

## Livrables

- `audit_shader_publication_preflight.py` — 23 741 octets, SHA-256 `277da966d1bf5f291fb5061f6bfd38366398156fefa10145473269548546e8d7` ;
- `validate_shader_publication_preflight.py` — 6 462 octets, SHA-256 `25a1cf83516d3a92ad5401eefae022135a57570d972114519c36e9edee55ad54` ;
- `shader_publication_preflight_receipt.json` — 21 292 octets, SHA-256 `789787350bfaa73abe11248250c411f47a7ed06891ff482ba9bf6eaa589fb8b0` ;
- `shader_publication_preflight_validation.json` — 2 092 octets, SHA-256 `806aee305a8ead51b63d335bf7adffca2fcf0ed1eb28b6d1b08218ef1cc311f6`.

Le rapport est exclu de cette liste d’empreintes pour éviter une référence circulaire. Aucun fichier de `F:` ou `D:`, produit, Goal, Plan, UI, base ou registre n’a été modifié ; aucune installation, migration ou nouvelle analyse REA globale n’a été effectuée.
