# Revue indépendante V1157 — stream slot `+0x10`

Date : 2026-11-03  
Source revue : `E:\mapslol3v3\audit_map10_v1157_shader_stream_slot10_20261103`  
Verdict : **PASS 60/60 — passage adapté seulement**.

## Conclusion

La revue indépendante confirme le sous-contrat fermé par V1157 : au callsite original, le slot virtuel `stream.vtable+0x10` ne consomme aucun argument de pile et fournit dans `EAX` un pointeur `char*` NUL-terminé emprunté. Les trois valeurs déjà empilées restent intactes jusqu’à la factory : objet include, début du tableau de macros, puis nombre de macros. Le callsite copie ensuite le flag de stage dans `EDX`, le retour source de `EAX` dans `ECX`, appelle la factory et ne libère les douze octets d’arguments qu’après son retour.

La classe concrète Riot/RADS et le provider historique restent **`UNKNOWN_PROVIDER_SPECIFIC`**. La preuve qualifie l’adapter borné, pas une instance historique reconstituée.

## Contrôles indépendants

- Manifeste source : 7 artefacts, 7 identités taille/SHA exactes, aucun `debug_run*.json` inclus.
- PE original : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, image base `0x400000`.
- Validateur source lancé sans `--output` : sortie `PASS 65/65`, code 0.
- Non-mutation du reçu source : SHA avant/après `264a810c951db22c1758bca8d6ab069b30c96f22716b40eed2c9662c19370cde` et `mtime_ns=1793703027633613000` inchangés.
- Troisième run physique : `review-3`, `PASS 27/27`, projection `05a5007c6f71c7d78f91fe0cba2e996e7d2e2b79b519bb5f3a46103d20ae39eb`.
- Revue indépendante globale : `PASS 60/60`.

## Décodage PE indépendant

| Stage | Bloc | SHA-256 | Slot | Factory | Cleanup |
|---|---|---|---|---|---|
| Pixel | `0x98C288..0x98C2B9`, 49 octets | `74ca4032d623ba03dd5524d42e47d99108df97d966fbd7548794c6aa2f4ef5a2` | `0x98C2AA` | `0x9AEBF0` | `0x98C2B6` |
| Vertex | `0x98DB78..0x98DBA9`, 49 octets | `4d5b7c8c81fe69edfac43c6f0743719afa3947a2e02537967821811708f91cdc` | `0x98DB9A` | `0x9AEA90` | `0x98DBA6` |

Pour les deux blocs, le décodeur indépendant retrouve :

1. les trois `push` avant `call dword ptr [eax+0x10]` ;
2. aucune dépile ni correction de `ESP` entre ce slot et la factory ;
3. `mov edx,ebx`, puis `mov ecx,eax` au retour du slot ;
4. la cible directe exacte de la factory ;
5. `add esp,0x0C` seulement à l’adresse de retour factory.

Les préfixes des deux factories relisent indépendamment `[EBP+8]` dans `EDX` (include), `[EBP+0x0C]` dans `ESI` (macro begin), conservent `ECX` jusqu’à l’expander `0x9AE410`, puis repoussent `[EBP+0x10]` (macro count). La vtable include à `0x10DBAEC` vaut `e0d4980020d79800`, SHA-256 `367bde41fed54a0ec4801903923f61b6e962c73cd3dd7fbb8ce6041fd25e5f16`.

## Troisième run et ownership

Le run `review-3` confirme pour pixel et vertex :

- le pointeur retourné par le slot devient exactement `ECX` à la frontière factory ;
- les trois arguments de pile avant/après slot sont identiques, avec `macro_count=3` ;
- l’objet include est stack-owned, vtable `0x10DBAEC`, chemin small-string `Environment`, longueur 11, capacité 15 ;
- `EDX=1` ;
- zéro accès invalide ;
- la trace n’inclut ni les entrées producteurs `0x98C070` / `0x98D960`, ni la première instruction des factories ;
- l’abandon à la frontière effectue le cleanup manuel : zéro stream et zéro source empruntée vivants.

Le lifetime historique observé statiquement reste : source empruntée pendant l’appel factory synchrone, puis close stream original à `0x98C2FF` / `0x98DBC8`. Le close original n’est pas déclaré exécuté dans ce lot.

Les six refus ont été exercés avant toute entrée originale/slot/factory : SHA source erroné, NUL embarqué, plage macros mal alignée, vtable include erronée, cible slot erronée et stream fermé. Tous laissent zéro ressource vivante.

## Arrêt strict et limites

- factories exécutées : 0 ;
- entrées producteurs exécutées : 0 ;
- D3DX, device, pool, bind/draw/Present/readback : 0 ;
- aucun produit, asset, registre, Goal, Plan, UI ou base modifié ;
- aucune écriture sous `F:` ; seules les sources déjà épinglées y sont lues par le harness.

Le résultat autorise uniquement la reprise avec le **stream adapté** sous les préconditions déjà vérifiées. Il ne transforme pas la classe/provider Riot historique inconnu en résultat résolu.
