# V1157 — ABI du slot stream `+0x10` et passage aux factories shader

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-STREAM-SLOT10-HANDOFF-01`  
Verdict : **PASS pour le passage exact des callsites producteurs vers les factories avec un stream adapté ; producteurs et factories non exécutés**.

## Résultat précis

Le gap signalé par le préflight V1156 est fermé pour l’adapter composé :

- le slot virtuel stream `+0x10` est un appel `thiscall` **sans argument de pile consommé** ;
- il retourne dans `EAX` un `char*` NUL-terminé, emprunté au stream ;
- les trois valeurs déjà empilées avant cet appel ne lui appartiennent pas : elles deviennent les arguments de la factory ;
- à l’entrée de `0x9AEA90` / `0x9AEBF0`, `ECX` contient le pointeur source retourné, `EDX` le flag de stage, puis la pile contient l’objet include, le début du tableau de macros locales et son nombre de paires ;
- la source reste empruntée jusqu’au close stream original, exécuté seulement après le retour synchrone de la factory.

Cette preuve corrige l’interprétation ABI trop large de V1153 : V1153 avait correctement observé les trois valeurs sur la pile à la frontière, mais les avait décrites comme arguments du slot `+0x10`. V1157 démontre qu’elles survivent au slot et sont retirées uniquement par `add esp,0x0C` après la factory. Les résultats VFS/includes V1153 ne sont pas invalidés.

## Callsite original exact

Les deux producteurs ont le même bloc de 49 octets :

| Stage | Bloc original | SHA-256 | Slot | Factory | Retour factory |
|---|---|---|---|---|---|
| Pixel | `0x98C288..0x98C2B9` | `74ca4032d623ba03dd5524d42e47d99108df97d966fbd7548794c6aa2f4ef5a2` | `0x98C2AA` | `0x9AEBF0` | `0x98C2B6` |
| Vertex | `0x98DB78..0x98DBA9` | `4d5b7c8c81fe69edfac43c6f0743719afa3947a2e02537967821811708f91cdc` | `0x98DB9A` | `0x9AEA90` | `0x98DBA6` |

L’ordre réel est :

```text
push macro_count
push macro_begin
push include_object
ECX = stream
call [stream.vtable + 0x10]   ; retourne char* dans EAX, ne dépile rien
EDX = stage_flag
ECX = EAX
call factory
add ESP, 0x0C                 ; dépile ici les trois arguments factory
```

Au début des factories, les instructions originales confirment ensuite :

- `EDX=[EBP+8]` : objet callback include ;
- `ESI=[EBP+0x0C]` : tableau de macros locales ;
- `ECX` reste le pointeur source jusqu’à l’appel de l’expander original `0x9AE410` ;
- `[EBP+0x10]` est repoussé comme nombre de macros avant la création shader.

Le retour du slot est donc un pointeur source, pas un objet compilé, un buffer D3DX ou un handle de pool.

## Objet include exact

L’objet stack transmis à la factory porte la vtable originale `0x10DBAEC` :

- octets : `e0d4980020d79800` ;
- SHA-256 : `367bde41fed54a0ec4801903923f61b6e962c73cd3dd7fbb8ce6041fd25e5f16` ;
- slot `+0x00` → `0x98D4E0` (load include) ;
- slot `+0x04` → `0x98D720` (free include).

Son champ `+0x04` est le `std::string` small-string du répertoire shader. Pour les deux sources testées, il contient `Environment`, longueur 11, capacité `0x0F`. Ce pointeur exact arrive en argument 1 de la factory. Le tableau local contient trois paires de pointeurs x86 : `COLORPALETTE_DEFAULT=1`, `DISABLE_EMISSIVE=1`, `FOUR_BLEND=1` ; l’arithmétique originale `(end-begin)>>3` produit 3.

## Exécution bornée

Pour chaque stage, un stream invité minimal expose :

- slot `+0x00` de close pour le cleanup de l’adapter ;
- slot `+0x10` qui retourne les octets exacts de `Environment/LIT_PS.ps_2_0` ou `Environment/LIT_VS.vs_2_0`, suivis d’un NUL.

Le probe exécute les 18 instructions originales effectivement prises dans chacun des deux blocs et s’arrête lorsque `EIP` atteint la factory, avant sa première instruction.

Observations communes :

- une seule invocation du slot ;
- source PS : 13 310 octets, SHA `d59435b2…95f3` ;
- source VS : 7 825 octets, SHA `b7631de1…01e5` ;
- pointeur source identique entre le retour slot et `ECX` factory ;
- include object, macro pointer et count identiques avant/après le slot ;
- flag `EDX=1` ;
- zéro accès mémoire invalide.

Comme la factory n’est volontairement pas exécutée, le harness effectue un cleanup d’abandon explicite à cette borne : stream et source empruntée passent à zéro vivant. Le close original est statiquement localisé à `0x98C2FF` / `0x98DBC8` après le retour factory ; il n’est pas présenté comme exécuté ici.

## Refus exécutés avant entrée originale

Six préflights réels refusent sans appel du bloc original, du slot ou de la factory :

1. SHA source différent ;
2. NUL embarqué dans la source ;
3. plage macros non multiple de 8 ;
4. vtable include différente ;
5. cible slot `+0x10` différente ;
6. stream déjà fermé.

Chaque cas conserve zéro stream et zéro source vivants.

## Reproductibilité

Après la dernière modification du producteur :

- deux runs finaux : `PASS 27/27` ;
- projection commune : `05a5007c6f71c7d78f91fe0cba2e996e7d2e2b79b519bb5f3a46103d20ae39eb` ;
- validation indépendante non mutante : `PASS 65/65` ;
- manifeste final : voir `artifact_manifest.json`.

Le validateur rehash le PE et les neuf fichiers, re-décode les blocs, contrôle les adresses de trace, les registres et piles des deux frontières, les six refus et l’arrêt strict. Sans `--output`, il ne modifie aucun reçu.

## Portée et reprise

Fermé : ABI du slot adapté, nature/lifetime du retour EAX, layout include, macro triplet et passage exact aux deux factories.

Reste ouvert : classe concrète Riot/RADS du stream historique. Il n’existe pas nécessairement une cible unique, puisque le dispatch est virtuel et dépend du provider monté. Cette inconnue n’empêche pas un run producteur **adapté** si toutes les autres assertions du préflight restent vraies ; elle interdit de qualifier ce stream comme instance historique.

Arrêt strict de ce lot :

- factories exécutées : 0 ;
- entrées producteurs `0x98D960/0x98C070` : 0 ;
- D3DX, device, pool, bind, draw, `Present`, readback : 0.

La prochaine unité peut composer les producteurs avec ce stream adapté, le lifecycle FOUR_BLEND V1156 et un stop après publication/cleanup, avant paire/bind/draw. Aucun fichier sous `F:`, produit, asset, registre, Goal, Plan, interface, application ou base n’a été modifié.
