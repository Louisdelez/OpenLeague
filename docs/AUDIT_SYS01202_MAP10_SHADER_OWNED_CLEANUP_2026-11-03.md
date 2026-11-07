# V1154 — Cleanup possédé des records shader Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-OWNED-CLEANUP-01`  
Verdict : **contrat fermé pour l’adapter/harness et la branche D3D9 déclarée ; intégration aux producteurs FOUR_BLEND toujours ouverte**.

## Résultat borné

Les chemins originaux 4.20 suivants sont exécutés sur des records, managers bitmap et wrappers synthétiques de layout exact :

- release du record vertex `0x9AED50` ;
- release du record pixel `0x9AEDC0` ;
- release du wrapper D3D9 `0x9BED40` ;
- libération du slot bitmap `0x8E2980`.

Dans les deux stages, le chemin nominal observe exactement :

1. `record[1] : 1 → 0` ;
2. appel `Release` du proxy constant table `1 → 0` ;
3. appel `Release` du proxy shader brut `1 → 0` ;
4. libération unique du wrapper ;
5. effacement des trois niveaux bitmap du slot ;
6. mise à zéro de `record[0]` ;
7. zéro accès mémoire invalide.

Ce résultat prouve l’orchestration d’ownership invitée dans le profil sélectionné. Les deux objets sont des proxies d’enregistrement, pas des interfaces shader Riot ni des objets COM current-host. Les lots D3DX et device séparés qualifient leurs propres objets hôte ; leur composition avec ce nettoyage n’est pas exécutée ici.

## Sources et ABI

Exécutable PE32 x86 : 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Fenêtre | Octets | SHA-256 | Contrat observé |
|---|---:|---|---|
| `0x9AED50..0x9AEDBF` | 111 | `7e149c9c459a0d918f69a6b308146f410eab9a854d9a08dee6bf50942badb406` | décrément VS, choix release, calcul `(record-base)>>3`, free, `record[0]=0` |
| `0x9AEDC0..0x9AEE2F` | 111 | `b868039be392d14fbc611285de272aee1fbe017b90b56f33299b53e501f493d6` | même contrat PS |
| `0x9BED40..0x9BED76` | 54 | `79d0280a868e755ed8a74260224aeabc7b58c8110f18f98e2b9a776196a10be7` | `Release(wrapper+0)`, `Release(wrapper+0x10)`, free wrapper |
| `0x8E2980..0x8E29C6` | 70 | `5b2a03a37c7c319ff75fc662cd57f9349c69fb0cd3397cff0bacb44accf749fb` | effacement hiérarchique du bit, `ret 4` |

Treize contrôles statiques confirment notamment les deux décréments, les appels directs `0x9BED40/0x8E2980`, les deux offsets d’objets possédés et la remise à zéro des records.

Le profil exécuté est explicite :

- byte `0x2D79470 = 0` ;
- byte `0x2D7951C = 1` ;
- callback de free personnalisé `0x14BEF40 = 0` ;
- conséquence : branche originale `0x9BED40`, puis free standard `0xC98528` intercepté par le proxy de heap.

Les branches alternatives `0x9B0080`, `0xC98528` direct depuis le record et callback personnalisé ne sont pas qualifiées comme équivalentes.

## Cas nominaux

Deux runtimes isolés utilisent des arrays de 4 096 records de stride 8 et des managers bitmap exact-layout à trois niveaux.

| Stage | Index | Entrées originales | Releases | État final |
|---|---:|---|---|---|
| vertex | 37 | `0x9AED50 ×1`, `0x9BED40 ×1`, `0x8E2980 ×1` | constant table `1→0`, vertex shader `1→0` | wrapper free, record nul, refcount 0, trois bits nuls |
| pixel | 2048 | `0x9AEDC0 ×1`, `0x9BED40 ×1`, `0x8E2980 ×1` | constant table `1→0`, pixel shader `1→0` | wrapper free, record nul, refcount 0, trois bits nuls |

Un second cleanup de chaque record est refusé par le préflight `record_object_null`, avant toute nouvelle entrée native. Il n’y a donc ni sous-flux du refcount, ni double release, ni double free.

## Référence partagée

Un cas séparé caractérise le comportement original avec `record[1]=2`. Le mode final-owned normal refuse cet état ; le test l’autorise explicitement uniquement pour exercer le décrément natif :

- premier appel `0x9AED50` : `2→1`, objet, slot et proxies inchangés ; aucune entrée `0x9BED40/0x8E2980` ;
- deuxième appel, revenu au gate final `record[1]=1` : cleanup complet et tous les objets possédés à zéro.

Ce cas ne modifie pas le critère d’intégration V1152, qui exige `record[1]==1` avant le cleanup final possédé.

## Refus du harness

Huit refus sont validés avant entrée native, avec zéro événement Release/free :

| Cas | Refus observé |
|---|---|
| `record[0]` nul | `record_object_null` |
| constant table absente | `constant_table_null` |
| shader brut absent | `raw_shader_null` |
| refcount nul | `record_refcount_zero` |
| refcount non final (`2`) | `record_refcount_not_final` |
| slot bitmap non alloué | `pool_slot_not_allocated` |
| record hors array ou désaligné | `record_out_of_pool_or_misaligned` |
| stage inconnu | `unknown_stage` |

Ces refus sont des gardes de l’adapter, pas des comportements Riot revendiqués. Les fixtures refusées restent sous la responsabilité de leur caller ; le harness ne tente pas un cleanup natif partiel qui déréférencerait un objet nul.

## Reproductibilité et preuves

Le producteur final `audit_shader_owned_cleanup.py` fait 31 405 octets, SHA-256 `0e2096213acd06c89488f5c65ba2cf7c9a6777aa389deb612f04df6e161d8f78`. Les deux runs finaux sont postérieurs à sa dernière modification :

- run 1 : 52 155 octets, SHA-256 `7cbe9b25a357a11d7f0abfbbfda019933bf5cb64063070bcec3c19b298419414` ;
- run 2 : 52 155 octets, SHA-256 `31d2abad194df45a00055d1be2691ed3fbf0a204b99cfc95ac6266e613d681a0` ;
- projection sémantique commune : `22b01f55beb00d931c9c8801b74dd6d9055ad5b343de2d893e6798ae933fad35` ;
- validation : `PASS 56/56`, reçu SHA-256 `f5be15a846316519c007cfec55f978fcf18756c2d46218f07159a0de0d884f0d`.

Le validateur est non mutant par défaut : le SHA du reçu est identique avant et après `python validate_shader_owned_cleanup.py`. Les reçus `debug_run*.json` sont supersédés et exclus des preuves finales.

Commandes finales :

```powershell
python .\audit_shader_owned_cleanup.py --run-id 1 --output .\shader_owned_cleanup_run1.json
python .\audit_shader_owned_cleanup.py --run-id 2 --output .\shader_owned_cleanup_run2.json
python .\validate_shader_owned_cleanup.py --output .\shader_owned_cleanup_validation.json
python .\validate_shader_owned_cleanup.py
```

## Borne stricte et limites

Les compteurs structurels restent à zéro pour : producteurs `0x98D960/0x98C070`, D3DX, `CreateVertexShader`, `CreatePixelShader`, allocation de pool, paire/bind, draw, `Present` et readback.

Restent ouverts :

1. l’intégration des sources FOUR_BLEND prétraitées au bridge D3DX ;
2. la composition D3DX → device → pool → record → cleanup dans un seul run producteur ;
3. les branches de release alternatives et l’état vivant historique de 2014 ;
4. la paire, le bind, le draw, `Present`, les pixels et l’intégration Rust.

Aucune complétude shader, terrain, Map10 ou jeu n’est déclarée. Écritures limitées à `E:\mapslol3v3\audit_map10_v1154_shader_owned_cleanup_20261103`; aucun fichier produit, asset, registre, Goal, Plan, interface, application, base ou fichier sous `F:` / `D:` n’est modifié.
