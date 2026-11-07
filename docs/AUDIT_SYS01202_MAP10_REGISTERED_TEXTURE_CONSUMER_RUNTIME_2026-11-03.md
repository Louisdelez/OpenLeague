# V1149 — textures Map10 enregistrées vers le consommateur D3D9

## Périmètre clos

Unité : `AUD-SYS-01.2-02-MAP10-REGISTERED-TEXTURE-CONSUMER-RUNTIME-01`.

Ce lot ferme uniquement le raccord qui restait entre les preuves existantes :

- V713/V717 : enregistrement et cycle de vie natifs communs ;
- V1141 : correspondance terrain `context+0x24/+0x28/+0x2C` vers les stages `s4/s8/s9`, mais avec des handles synthétiques ;
- V1148 : chargement, upload, publication et enregistrement des trois DDS exacts, mais sans consommation texture/sampler.

V1149 réutilise les propriétaires réellement produits par V1148 et les transmet aux consommateurs originaux `0x983CB0` et `0x95A480`. L'autorité reste limitée aux octets épinglés du client 4.20 et au runtime borné Unicorn/current-host D3D9. Aucun résultat de modèle n'est utilisé comme preuve.

## Contrat ABI vérifié

L'inspection PE et sa validation indépendante établissent la distinction suivante :

- le handle attendu par `0x983CB0` est l'owner créé par `0x989150` ;
- `owner+0x0C` fournit l'identité de cache ;
- `owner+0x8C` fournit le wrapper publié, vtable `0x10E3270` ;
- le slot 3 du wrapper (`0x870FA0`) retourne le proxy texture à `wrapper+0x08` ;
- `owner+0x88` désigne le nœud enregistré, vtable `0x10DBA18`, et ne doit remplacer ni l'owner ni le wrapper ;
- `node+0x0C` est une liaison backend/sampler distincte.

La chaîne de consommation qualifiée est donc :

`owner+0x8C → wrapper → slot 3 → wrapper+0x08 → 0x9C62B0 → IDirect3DDevice9::SetTexture`.

## Résultat attendu et observé

Attendu : conserver pour chacun des trois DDS l'identité source → owner → nœud enregistré → wrapper → texture D3D9, atteindre les stages terrain déjà qualifiés par V1141 et observer les appels current-host réels sans exécuter de draw.

Observé deux fois à l'identique :

| Source exacte | Owner réel | Nœud enregistré | Wrapper publié | Proxy texture | Stage |
|---|---:|---:|---:|---:|---:|
| `terrainHeightScale.dds` | `0x41800000` | `0x409D6700` | `0x409D66B0` | `0x404004E0` | `s4` |
| `compositeColorMap.dds` | `0x41800200` | `0x409D6840` | `0x409D67F0` | `0x40400500` | `s8` |
| `fogLightingMap.dds` | `0x41800400` | `0x409D6980` | `0x409D6930` | `0x40400520` | `s9` |

Pour chaque cas :

- le nœud reste non nul, présent dans le gestionnaire et prêt (`node+0x15=1`) ;
- `0x983CB0` conserve l'owner dans le cache du stage et son identité `owner+0x0C` ;
- le même proxy brut issu du wrapper atteint `IDirect3DDevice9::SetTexture` ;
- l'appel current-host retourne `HRESULT 0x0`.

Le sous-chemin original `0x95A480`, exécuté avec les owners réels à `context+0x28/+0x2C`, produit aussi exactement :

- `SetSamplerState(s8, ADDRESSU, CLAMP)` ;
- `SetSamplerState(s8, ADDRESSV, CLAMP)` ;
- `SetSamplerState(s9, ADDRESSU, CLAMP)` ;
- `SetSamplerState(s9, ADDRESSV, CLAMP)`.

Les arguments D3D9 observés sont respectivement `[8,1,3]`, `[8,2,3]`, `[9,1,3]` et `[9,2,3]`, tous avec `HRESULT 0x0`.

Le probe visite 6 109 adresses originales, observe zéro accès mémoire invalide, n'effectue aucun `Draw`/`Present`, détruit la fenêtre cachée et libère toutes les ressources current-host qu'il possède. Les readbacks level-0 exacts de V1148 restent tous conformes aux payloads DDS.

## Refus et limites

- Les refus V1148 sont conservés : gestionnaire absent et source mutée sont bloqués par des gardes du harness avant la continuation native. Ce ne sont pas des refus Riot.
- Le bind `s4` exécute directement le consommateur original `0x983CB0` avec l'owner réel et le stage qualifié par V1141 ; le caller terrain complet `0x95A730` n'est pas réexécuté dans ce lot.
- Les binds `s8/s9` et leurs samplers sont exécutés ensemble par le sous-chemin original `0x95A480`.
- La tentative REA/Ghidra ciblée n'a produit ni snapshot ni reçu de fonction avant sa limite ; elle est documentée dans `REA_ATTEMPT_V1149.md` et n'est pas utilisée comme preuve.
- Le runtime est le D3D9 actuel sous profil privé `escape_refusal`, pas le runtime historique 2014.
- Le teardown natif complet du gestionnaire/renderer n'est pas exécuté (`native_full_teardown=false`).
- Aucune preuve de `Draw`, `Present`, pixel de frame, ordre dans une frame complète, shader final ou fidélité visuelle n'est revendiquée.

## Reproductibilité et contrôles exécutés

Deux exécutions successives ont réussi. La projection normalisée est strictement identique, SHA-256 `56e03186222e3e97866800b36bb4fa3f0db767c4c48352b0227acbc74c223853`. Les reçus d'octets natifs sont strictement identiques, SHA-256 `641613397c3bb70e38d5a86136a66d8ce65951044c4beea01dae05a72489be3e`.

Contrôles réellement exécutés :

- compilation Python du probe runtime : réussie ;
- deux exécutions complètes du probe : réussies ;
- compilation Python du validateur runtime : réussie ;
- validation indépendante structurée : réussie ;
- inspection statique : 21/21 assertions réussies ;
- validation statique indépendante : 22/22 assertions réussies ;
- comparaison normalisée et comparaison exacte des octets natifs : réussies.

## Livrables

- `AUDIT_V1149_REGISTERED_TEXTURE_CONSUMER_STATIC.md` — `9f2aca4c0e36388ca629ed7f57c18145d33ac484819f65f0b0d16a48aa259506` ;
- `inspect_registered_texture_node.py` — `0ce8f4154a4fde20e6cb6ff11f608b85397e63e6f462aae2058068a743175eeb` ;
- `registered_texture_node_static.json` — `b8f06f72b4b67efef9015f7e045b9729de2b251ac870954be5b03009d331e361` ;
- `validate_registered_texture_node.py` — `d209774063a348fd89bd5c5adfb167a2ec006c84ad8d724c8e9f7de8bab10c6a` ;
- `registered_texture_node_static_validation.json` — `d6b9e30e6bbce14afbe8438bedd1cbe3244a6783c7eb5b0e84d11a056caaf907` ;
- `probe_registered_texture_consumer_runtime.py` — `b16a05f5d0fbf0abbb0586d9c1a43fe7c6665e8979a9e5bc1d6207d1a5b6ad95` ;
- `registered_texture_consumer_runtime_execution.json` — `ce4bde2628c5385580f2812cb4182856bf4e581da1e758d3f9ef24e8fd547cf2` ;
- `registered_texture_consumer_runtime_native_bytes.json` — `641613397c3bb70e38d5a86136a66d8ce65951044c4beea01dae05a72489be3e` ;
- `validate_registered_texture_consumer_runtime.py` — `64ef9160c95b5117c521d6de9e13b75f57687cd98039e9eb7dad0c3adaf58d10` ;
- `registered_texture_consumer_runtime_validation.json` — `65b22a9ad7055525b6d3419bd5b163dc393fd604934ea501b920bde2eb1bb2d8`.
- `REA_ATTEMPT_V1149.md` et `rea_ghidra_v1149_attempt.log` documentent la tentative REA non concluante ; ils ne remplacent aucun reçu PE/runtime.

Aucun fichier produit, Goal, Plan, interface, base ou registre n'a été modifié par ce lot E:.
