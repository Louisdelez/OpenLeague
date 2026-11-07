# V1156 — Préflight statique d’entrée des producteurs shaders Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-SHADER-PRODUCER-PREFLIGHT-01`  
Entrées visées : pixel `0x98C070`, vertex `0x98D960`  
Verdict : **préflight statique READY ; exécution des producteurs BLOCKED**  
Blocage unique : `STREAM_SLOT_0X10_RETURN_OBJECT_ABI_NOT_CLOSED`

## Résultat

Les deux producteurs originaux ont été reconstruits statiquement jusqu’à leurs
factories, stores de records, retours et chemins de cleanup. L’ordre original,
l’état minimal, les assertions, les refus préalables et le rollback d’un futur
run composé sont maintenant explicites.

Le lot V1156 FOUR_BLEND parallèle ferme le cycle exact-source sur les bridges
current-host/adaptés : expansion originale, compilation, vrai shader D3D9,
allocation/publication exact-layout et cleanup original. Il n’entre toutefois
pas dans les producteurs. Il ne ferme donc pas la méthode virtuelle
`stream.vtable+0x10` située exactement entre l’ouverture VFS et les factories.

**Aucun producteur, factory, compilateur, device, pool, cleanup, paire, bind,
draw, Present ou readback n’a été exécuté par ce préflight.**

## Identité exacte

| Stage | Descripteur | Nom | Source | SHA-256 source | Producteur | Factory | Store |
|---|---:|---|---|---|---:|---:|---:|
| pixel | `0x123F550`, ligne 10 | `Environment_LIT_FOUR_BLEND_PS` | `Environment/LIT_PS.ps_2_0` | `d59435b2…95f3` | `0x98C070` | `0x9AEBF0` | `0x98C2B9` |
| vertex | `0x123F678`, ligne 10 | `Environment_LIT_FOUR_BLEND_VS` | `Environment/LIT_VS.vs_2_0` | `b7631de1…01e5` | `0x98D960` | `0x9AEA90` | `0x98DBA9` |

Les deux records emploient trois paires locales, dans cet ordre :
`COLORPALETTE_DEFAULT=1`, `DISABLE_EMISSIVE=1`, `FOUR_BLEND=1`. Les 23 paires
globales natives sont ajoutées en aval ; D3DX reçoit donc 26 paires.

## ABI des producteurs

ABI commune MSVC32, de forme `thiscall` :

- `ECX` : record shader initialisé de `0x80` octets ;
- `[EBP+8]` : nom de registre NUL-terminé ;
- `[EBP+0xC]` : chemin virtuel source NUL-terminé ;
- retour : `ret 8`, résultat booléen dans `AL`/`BL` ;
- record `+0x04` : handle du record pool publié ;
- record `+0x08/+0x0C` : début/fin du vecteur de paires macros, stride 8 ;
- record `+0x38`, `+0x50`, `+0x68` : chaînes MSVC32 nom, source et profil.

Le booléen de profil copié dans `EDX` ne vaut 1 que pour `ps_3_0` ou `vs_3_0`.
Les sources ciblées sont `ps_2_0` et `vs_2_0` : `EDX=0`.

### Pixel

1. `0x98C200` ouvre la source par `0x8B4FB0`, mode `rb`.
2. `0x98C29F/0x98C2A0/0x98C2A7` poussent nombre de macros, pointeur macros,
   objet include.
3. `0x98C2AA` appelle `[stream.vtable+0x10]`.
4. L’EAX retourné devient ECX de `0x9AEBF0` à `0x98C2B1`.
5. `0x98C2B6` retire les 12 octets partagés ; `0x98C2B9` stocke le handle dans
   `record+4`.
6. `0x98C2FF` ferme/libère le stream par son slot 0 avec argument 1.
7. `0x98C408` retourne par `ret 8`.

### Vertex

Le même contrat est observé à `0x98DAF0`, `0x98DB8F/90/97`, `0x98DB9A`,
`0x98DBA1`, `0x98DBA6`, `0x98DBA9`, `0x98DBC8` et `0x98DCD1`.

### Limite critique du retour

Après une ouverture réussie, le producteur force finalement `BL=1`, même si la
factory rend null. `AL=1` signifie donc « source ouverte », pas « shader publié ».
Un succès futur exige au minimum `record+4 != null`, record pool possédé,
refcount 1, wrapper non null, CTAB `wrapper+0` non nulle et shader brut
`wrapper+0x10` non nul.

## Frontière `stream+0x10`

Le contrat statiquement certain est :

- `ECX` = stream ouvert ;
- pile = objet include, pointeur macros locales ou null, nombre de macros ;
- les mêmes 12 octets restent en place pour la factory suivante ;
- la méthode doit donc respecter une forme plain-return/caller-preserved pour
  cette pile ; le producteur exécute seul `add esp,0x0C` après la factory ;
- EAX est transmis comme ECX à la factory, puis consommé synchroniquement par
  `0x9AE410` ; sa forme est compatible avec un objet source MSVC32 de type
  `std::string` ;
- l’objet doit rester valide jusqu’au retour de la factory, le stream étant
  fermé juste après.

Ce qui reste inconnu et bloque l’entrée native : type/layout concret exact de
l’objet EAX, propriétaire/destructeur, sémantique null/erreur, comportement
d’exception et preuve exécutée de préservation de la pile par l’adapter. V1153
avait explicitement documenté ce slot sans l’implémenter ni l’exécuter. Aucun
lot V1154–V1156 ne remplace ce contrat.

## Factories, pools et erreurs

Les factories `0x9AEBF0` (PS) et `0x9AEA90` (VS) reçoivent :

- ECX = objet EAX de `stream+0x10` ;
- EDX = drapeau profil, ici 0 ;
- pile = triplet include/macros/count partagé.

Elles appellent `0x9AE410`, sélectionnent les wrappers D3D9
`0x9BEC20/0x9BEB00`, allouent via `0x8E28C0`, puis publient le wrapper et le
refcount 1 dans un record de 8 octets. Managers/bases :

- VS : `0x2D79638` / `0x2D79574` ;
- PS : `0x2D792CC` / `0x2D791D0` ;
- saturation : sentinelle `0x1000`.

La création du wrapper précède l’allocation du pool. Sur sentinelle `0x1000`,
aucune libération explicite du wrapper n’est observée dans la factory. La
saturation est donc un refus **avant** entrée producteur, jamais un test négatif
à provoquer dans le producteur.

## État minimal d’un futur run

- globals de branche : `0x2D79470=0`, `0x2D7951C=1`, `0x14BEF40=0` ;
- device global `0x2D79428` relié au bridge D3D9 déjà qualifié ;
- provider neuf-SHA exact actif, chemins cibles ouvrables en `rb` ;
- deux records `0x80` isolés et initialisés, macros locales exactes, chaînes
  valides, `record+4=0` ;
- managers/bases exact-layout installés, au moins un slot libre par pool,
  allocation sérialisée ;
- cleanup original `0x9AED50`/`0x9AEDC0` disponible et ownership one-shot ;
- compteurs interdisant paire, bind, setters, draw, Present et readback armés.

## Ordre, arrêt et rollback

L’ordre natif est **pixel puis vertex** : l’appel `0x95A071` précède
`0x95A24E` dans `0x959D30`.

Quand le blocage `+0x10` sera fermé :

1. geler la concurrence pool/shader et capturer globals, bitmaps et compteurs ;
2. refuser l’entrée si un record est déjà publié ou si un pool n’a pas de slot ;
3. appeler PS, capturer `AL` et `record+4`, valider toute la chaîne ownership ;
4. appeler VS, capturer et valider de même ;
5. s’arrêter avant `0x9AEE30`, `0x9C22E0`, `0x9BEF40`, setters, draw, Present et
   readback ; tous leurs compteurs doivent rester à zéro ;
6. cleanup inverse exactement une fois : VS `0x9AED50`, puis PS `0x9AEDC0` ;
7. exiger zéro record, wrapper, CTAB, shader brut, proxy, buffer include, bit
   pool et référence temporaire ; restaurer ensuite les globals.

Si PS échoue, libérer tout ownership partiel PS. Si VS échoue après PS, libérer
d’abord le partiel VS puis PS. Une seconde cleanup est un refus du harness. Une
saturation ne doit jamais franchir la frontière producteur.

## Confrontation aux bridges fermés

| Preuve | Compatibilité | Limite |
|---|---|---|
| V1153 VFS | open/read/include/close compatibles | `stream+0x10` documenté seulement |
| V1154 D3DX | ABI compilation/proxies compatible | D3DX current-host |
| V1154 device | Create VS/PS et release wrapper compatibles | D3D9 current-host |
| V1154 pools | alloc/free/bitmap/sentinelle exacts | fixtures exact-layout |
| V1154 cleanup | record → wrapper → COM → pool original | one-shot |
| V1155 preprocess | sources/includes et 26 macros exacts | provider adapté |
| V1155 lifecycle | composition complète sur fixtures synthétiques | producteurs exclus |
| V1156 FOUR_BLEND | sources exactes jusqu’au cleanup original | producteurs exclus, fixtures exact-layout |

Les incompatibilités résiduelles non bloquantes pour le préflight sont le
runtime D3DX/D3D9 actuel au lieu du runtime 2014, le provider borné au lieu du
provider Riot historique et les managers/records fixtures au lieu d’un graphe
Riot vivant. Elles doivent rester qualifiées dans tout reçu futur.

## Recherches effectuées et reprise

Le PE exact SHA-256 `402bf2b9…7862` a été rehashé et les fenêtres des deux
producteurs, factories, wrappers, expander, cleanups, VFS open et fragments
d’enregistrement ont été redésassemblées. Les preuves V1151 à V1156 et le
snapshot REA existant ont été rehashés. Chaque bridge a été inspecté à la
recherche d’une implémentation ou d’une exécution de `stream+0x10` ; aucune
n’existe dans le corpus qualifié.

La reprise exige uniquement : adapter borné `+0x10`, preuve du layout et de la
durée de vie EAX, préservation exacte du triplet pile, cas nominal/null/erreur et
validation indépendante sans fuite. V1157 prend déjà cette reprise en charge ;
ce lot ne la duplique pas. Après fermeture, le statut peut devenir
`READY_FOR_ONE_CONTROLLED_RUN`, toujours arrêté avant paire/bind/draw.

## Validation

- générateur statique : `audit_shader_producer_preflight.py` ;
- contrat : `shader_producer_preflight.json` ;
- validateur indépendant, non mutant par défaut :
  `validate_shader_producer_preflight.py` ;
- résultat : **PASS 28/28** dans `shader_producer_preflight_validation.json` ;
- manifeste : `artifact_manifest.json`.

Aucun fichier F:, produit, asset, registre, Goal, Plan, interface, application
ou base n’a été modifié.
