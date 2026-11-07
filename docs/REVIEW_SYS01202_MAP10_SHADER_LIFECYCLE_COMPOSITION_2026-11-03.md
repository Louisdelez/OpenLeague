# Revue indépendante V1155 — cycle de vie shader composé

## Décision

**PASS 23/23, aucune anomalie résiduelle.**

La revue confirme uniquement le périmètre déclaré : composition current-host des bridges V1154 sur fixtures HLSL synthétiques, managers/records exact-layout synthétiques et primitives natives 4.20. Elle ne qualifie ni les producteurs Riot, ni les fichiers FOUR_BLEND complets, ni le runtime 2014, ni un rendu.

## Contrôles indépendants

- manifeste source : 7/7 artefacts, tailles et SHA exacts ;
- quatre producteurs V1154 : empreintes exactes ;
- PE 4.20 : SHA-256 `402bf2b9…7862` exact ;
- validateur source : code 0, 98/98, reçu inchangé avant/après ;
- deux runs finaux source : PASS ;
- troisième run physique de revue : PASS, SHA-256 `093e8fde797bf21a541288c7a44d6389f315c3801cb3710ce8262007f60d8995` ;
- projection commune aux trois runs : `99723283e226e83fe9369895a8602762598cf7b93422852bcda655aec1da4e8e`.

## Sémantique bitmap confrontée

Une nouvelle instance indépendante du manager natif a exécuté `0x8E28C0` :

- index rendu : 0 ;
- mots feuille→sommet après une allocation : `[1, 0, 0]` ;
- trace sans le stop du harness : 102 instructions, SHA-256 `24faad3c…59ab` ;
- après `0x8E2980`, bitmap intégralement nul.

Cela confirme la correction locale du gate composé : le bit feuille possède un slot ; les niveaux supérieurs indiquent qu’un enfant/sous-arbre est plein et ne doivent pas être exigés pour une allocation unique.

## Traces et octets PE

Les traces cleanup vertex et pixel ont été recalculées depuis les reçus V1154 complets et concordent avec les trois runs V1155. L’union allocator/cleanup contient 159 adresses natives uniques :

- 159/159 décodées directement dans le PE épinglé ;
- zéro adresse hors fenêtre attendue ;
- zéro écart de décodage ;
- SHA-256 canonique des octets/instructions décodés : `2e6e191a3e6ea656220e4eb9c686dd3352e8c523a10e0d5ef3796107b5e3b6af`.

La frontière de heap-free `0xC98528` est comptée comme entrée interceptée, sans exécution de son corps, conformément au harness cleanup V1154.

## Nominal, rollbacks et ownership

Pour les trois runs :

- VS et PS : tous les contrôles nominaux vrais ;
- CTAB et shader current-host : deux `Release → 0` par stage via le cleanup original ;
- records, refcounts et slots : zéro après cleanup ;
- réallocation du même index puis libération : réussie ;
- échec compilation, échec device et saturation 4 096→sentinelle 4 096 : rollbacks complets ;
- proxies D3DX vivants : 0 ;
- shaders vivants avant fermeture device : 0 ;
- aucune release de secours ;
- device et `IDirect3D9` : `Release → 0` ;
- fenêtre cachée détruite.

Le strict stop est exact : aucune entrée producteur, aucun `SetShader`, paire, bind, draw, `Present` ou readback.

## Limites

- sources : fixtures synthétiques V1154 sans include ;
- runtime : D3DX/D3D9 actuels ;
- managers, records et wrappers : fixtures exact-layout ;
- aucune preuve des producteurs originaux, des sources FOUR_BLEND complètes, du runtime Riot 2014, d’un bind ou de pixels.

Le lot peut être publié comme composition de harness réussie. La reprise doit rester distincte et partir du buffer prétraité des neuf sources exactes avant toute entrée des producteurs.
