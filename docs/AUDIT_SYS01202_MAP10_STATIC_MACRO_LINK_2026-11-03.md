# V1161 — lien statique macro → producteurs → records → draw Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-V1161-STATIC-MACRO-LINK-01`  
Périmètre d’écriture : `E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103`

## Verdict borné

**PASS — le chaînon structurel est prouvé statiquement.** Le vecteur dynamique
construit par `0x9593C0` est bien la source ordonnée des deux records
FOUR_BLEND transmis à `0x98C070` et `0x98D960`. Dans la route ordinaire
explicitée ci-dessous, les handles compilés stockés dans ces records sont
retrouvés par nom et liés par `0x95A730` avant le draw du caller `0x95AFC0`.
L’identité de bind historique inconditionnelle n’est pas revendiquée : le
remapping pixel death-screen reste hors du contrat existant.

La nuance importante est l’identité mémoire : **ce n’est pas la même
allocation**. Le vecteur pile de `0x959D30` est copié, ordre conservé, dans deux
records distincts. Le suffixe statique `DISABLE_EMISSIVE;FOUR_BLEND` est ensuite
ajouté à chacun. Les deux stages reçoivent donc le même contenu macro ordonné,
mais dans des buffers propres.

Ce résultat ne suffit pas à choisir un bytecode historique complet. Les valeurs
runtime qui déterminent les autres macros ne sont pas toutes épinglées. Les
candidats V1161 existants restent refusés comme identité historique exacte.

## Chaînon observé dans le PE original

### 1. Constructeur dynamique et extensions communes

- `0x959D74/+0x7C/+0x84` initialise le vecteur pile
  `[esp+0x10,+0x14,+0x18]`.
- `0x959D8C` passe son adresse dans `ECX`; `0x959D9B` appelle `0x9593C0`.
  Le scan ciblé des `E8 rel32` de `.text`, corroboré par la fenêtre
  désassemblée, ne trouve que ce caller direct.
- `0x959DDA` ajoute ensuite exactement une macro `COLORPALETTE_*` au même
  vecteur.
- `0x959DDF` recharge l’adresse du même vecteur et `0x959DE3` appelle
  `0x987830`, qui ajoute le groupe fog conditionnel.

L’ordre natif pertinent est donc : macros du builder, palette, fog éventuel,
puis suffixe propre au shader. Dans le builder, `PCF_MODE` est toujours ajouté
à `0x959447`; les autres groupes précoces dépendent des réglages. Lorsque la
configuration Map10 épinglée active height et colormap, l’ordre relatif est
`USE_HEIGHT_BLEND`, puis `MOD2X_COLORMAP`.

### 2. Copie vers les records et suffixe FOUR_BLEND

Chemin de création pixel :

- `0x95A045` charge l’adresse du vecteur pile;
- `0x95A04A` cible `record+0x08`, puis `0x95A04D` appelle `0x6F1820`;
- `0x95A052..0x95A062` ajoute la plage statique à partir de `record+0x0C`;
- `0x95A06B/0x95A071` passe le record à `0x98C070`.

Chemin de création vertex :

- `0x95A222` charge le même vecteur pile;
- `0x95A227/0x95A22A` le copie vers `record+0x08`;
- `0x95A22F..0x95A23F` ajoute la plage statique;
- `0x95A248/0x95A24E` passe le record à `0x98D960`.

Les chemins de rafraîchissement conservent la même relation :
`0x959F78 → 0x98BFC0 → 0x98C025/0x98C039/0x98C055` pour le pixel et
`0x95A1CE → 0x98D8B0 → 0x98D915/0x98D929/0x98D945` pour le vertex.

`0x6F1820` copie les paires de 8 octets dans l’ordre source. Le constructeur
`0x98C430` reçoit le troisième champ de table, le tokenise séquentiellement sur
`;` à `0x98C492/0x98C529`, sépare nom/valeur sur `" ="` à `0x98C4B3`, emploie
la valeur implicite `1` à `0x98C511`, puis stocke et avance la fin de plage de
8 octets à `0x98C518/0x98C51A`. `0x98F1E0` ajoute cette plage ordonnée après le
préfixe déjà copié. Les tables originales donnent, à l’index 10 dans les deux
stages :

| Stage | Nom enregistré | Source | Suffixe statique |
|---|---|---|---|
| pixel | `Environment_LIT_FOUR_BLEND_PS` | `Environment/LIT_PS.ps_2_0` | `DISABLE_EMISSIVE;FOUR_BLEND` |
| vertex | `Environment_LIT_FOUR_BLEND_VS` | `Environment/LIT_VS.vs_2_0` | `DISABLE_EMISSIVE;FOUR_BLEND` |

### 3. Producteurs et factories

- Pixel : `0x98C288/+0x28B` lit `record+8/+0xC`; `0x98C296..0x98C2A0`
  transmet le nombre et le begin; `0x98C2B1` appelle `0x9AEBF0`; `0x98C2B9`
  stocke le handle en `record+4`.
- Vertex : `0x98DB78/+0x7B` lit `record+8/+0xC`; `0x98DB86..0x98DB90`
  transmet le nombre et le begin; `0x98DBA1` appelle `0x9AEA90`; `0x98DBA9`
  stocke le handle en `record+4`.

### 4. Lookup, bind et draw

Dans la route ordinaire `selector=0`, pour `material_type=3` et le bit
`global_options&4` nul, `0x95A730` recherche les noms FOUR_BLEND exacts
ci-dessus par `0x9805C0`.

- `0x95A520` indexe les records vertex à `manager+0x102DC` et charge le
  `record+4` à `manager+0x102E0 + index*0x80`.
- Avec le remapping death-screen inactif, `0x95A570` indexe les records pixel
  à `manager+0x2D4` et charge le `record+4` à
  `manager+0x2D8 + index*0x80`.
- `0x95AFC0` appelle `0x95A730` à `0x95B046`; le draw indirect suit à
  `0x95B112`.

Ce raccord exige aussi que `0x9805C0` retourne les deux indices, que le manager
global `[0x2D79078]`, son device `manager+0x14` et les handles `record+4` soient
non nuls. Sous ces conditions, le lookup par nom rejoint le record réellement
produit, même si son index vivant n’est pas supposé à l’avance. Si le remapping
death-screen de `0x95A574..0x95A59C` est actif, un autre index pixel peut être
substitué ; cet état n’est pas épinglé et le contrat de sélection existant
l’exclut explicitement.

## Ordre macro établi et limite historique

La configuration Map10 déjà épinglée donne `height_blend=true` et
`colormap=true`. L’ordre relatif complet connu est :

1. éventuel `DISABLE_SHADOWS`;
2. `PCF_MODE=<valeur calculée ou cache>` — toujours présent;
3. éventuels groupes animation FoW, clouds et qualité basse;
4. `USE_HEIGHT_BLEND=1`;
5. `MOD2X_COLORMAP=1`;
6. éventuels `TERRAIN_EDITOR` / `NOLIGHTING`;
7. une macro `COLORPALETTE_*=1`;
8. groupe fog éventuel;
9. `DISABLE_EMISSIVE=1`;
10. `FOUR_BLEND=1`.

Le groupe fog n’est pas un booléen isolé :

- feature absente : aucune macro fog;
- feature active, mode 0 : `VERTEX_FOG`;
- mode 1 : `FOG_PIXELSHADER_BLEND`, puis `FOG_QUALITY_LOW`;
- mode ≥ 2 : `FOG_PIXELSHADER_BLEND`, puis `FOG_TEXTURED_OPACITY`.

Ainsi le candidat « fog » à une seule macro fog ne représente pas à lui seul
un span historique complet. Les entrées runtime non épinglées restent :
`0x12258F4`, `0x12258D8`, `0x2D78FAC`, `0x123F5F8`, `0x123F7E0`,
`0x2D78FB0`, `0x2D79058`, `0x14BE79F`, `0x1225904` et l’état de remapping
death-screen.

Prochaine reprise bornée : identifier leurs valeurs/producteurs au démarrage
Map10, puis régénérer la liste complète dans l’ordre prouvé. Aucun choix de
candidat n’est autorisé par intuition.

## Contrôles exécutés

```powershell
python -B E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\probe_static_macro_link.py --run-id run1 --output E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\static_macro_link_run1.json
python -B E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\probe_static_macro_link.py --run-id run2 --output E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\static_macro_link_run2.json
python -B E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\validate_static_macro_link.py --output E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103\static_macro_link_validation.json
```

Résultats : deux exits `0`, digest stable
`2f9f20dd2d75e65e712e377ddd87a85b56cd5d44e24b056af4ac08c280b0ab51`,
validateur `22/22 PASS`. Le PE original de 15 973 880 octets reste épinglé au
SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Frontières

- lecture statique du PE et réutilisation de contrats/rapports existants;
- aucune exécution du jeu, aucun appel D3D, aucune compilation shader;
- aucune écriture sur `F:`;
- aucun produit, Goal, Plan, UI ou base modifié;
- ce lot ne qualifie ni le vecteur runtime historique complet, ni un draw
  exécuté, ni Map10, le renderer ou le jeu complet.
