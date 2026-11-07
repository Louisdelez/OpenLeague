# V1158 — cycle de vie pair/cache shader strictement avant bind

## Verdict

**PASS pour la frontière d’audit déclarée, pas pour une fonctionnalité Riot 2014 complète.** Les deux shaders `FOUR_BLEND` exacts de V1156 ont été recréés sur **un seul device D3D9 current-host RTX 3060**. Le factory pair original `0x9AEE30`, le resolver original `0x9C22E0` et la libération pair originale `0x9AEFE0` ont été exécutés sur des managers et records guest de layout exact. Le resolver miss s’arrête sur l’instruction `CALL 0x9C2372`, avant toute entrée dans `0x9BEF40`.

Le backend pair et l’insertion cache restent des adapters bornés. Aucun `SetVertexShader`, `SetPixelShader`, bind, draw, `Present` ni readback n’a été exécuté. Ce lot ne qualifie donc ni le device historique Riot/RADS 2014, ni le rendu, ni une fidélité visuelle.

## Frontière et sources épinglées

- Producteur V1156 : `fcf46d803a2d294860010038f1b9b3f16f96cdabbff51ae3b48dd445cb1bc318`.
- Reçu V1156 : `dfaadbf41543bf178871e071a3706c3da93bae44885ba88b758ae4114d5a181f`.
- Préflight statique V1157 : `7b24fe28cf39f5c6463246882df7e2fc81bdb61a9765465f1a227831cf313d7c`.
- Rapport V1157 : `e2a66044762c1f8d79102e877299fa04d7dc2ad11a721ca8237c464050076bce`.
- Producteur V1158 final : `931882cd991039b52464fea33c87456a998b36923488eb2268ef3cb802444e66`.
- L’exécutable 4.20 et les fenêtres natives utilisées transitent par les bridges V1154/V1155 déjà épinglés par V1156. Aucun producteur shader original n’est exécuté dans ce lot.

## Résultats observés

### Stages et co-résidence device

- Vertex : `Environment/LIT_VS.vs_2_0`, expansion `6694b4cb...58066ed`, bytecode `c1a169e3...c5be42`.
- Pixel : `Environment/LIT_PS.ps_2_0`, expansion `74858d63...c6e021`, bytecode `3d184c79...e5ca58`.
- Les deux objets shader sont de vrais objets current-host créés par le même `HostD3D9Device`.
- Le token device guest est un mapping d’adapter vers cet unique device current-host. Ce n’est pas le global device Riot 2014.

### Pair, capacité et refcounts

- Pool pair : capacité `0x10000`, sentinel plein `0x10000`, stride record `0x10`, région records `0x100000` octets.
- Premier slot alloué : index `0`; bit leaf posé, bits supérieurs non pleins.
- Record pair : `+0 backend`, `+4 refcount=1`, `+8 vertex record`, `+0xC pixel record`.
- Le factory original fait passer les refcounts vertex/pixel de `1` à `2`.
- La libération pair originale remet le backend et le refcount pair à zéro, libère le backend une fois, puis ramène les refs stages à `1`.

### Cache et current

- Miss : le hash `0` mène à une insertion adapter contenant exactement le pair record.
- La frontière miss est atteinte à `0x9C2372`; le current reste `0` car le bind et le store post-bind ne sont pas exécutés.
- Hit sûr : le harness initialise **uniquement** le current synthétique au pair déjà caché, puis exécute le resolver original. La route hit/current-equal retourne à `0x9C239A` sans factory, sans nouvelle insertion, sans changement de refs et sans bind.
- L’initialisation du current pour ce test est une action d’adapter représentant un état post-bind; elle ne prétend pas exécuter le store Riot original.

### Rollback, libération et réutilisation

- Le défaut monotone est observé : `0x9AEFE0` ne libère pas le bit de pool pair.
- Après suppression de l’entrée cache, l’adapter applique explicitement le rollback via le free bitmap original `0x8E2980`.
- Le même slot `0` est immédiatement réalloué puis libéré, ce qui prouve la réutilisation sans dérive monotone lorsque le rollback adapter est appliqué.
- Les deux records stages sont ensuite libérés par les chemins originaux; shaders host, proxies D3DX, bitmaps, records, cache, desired/current et fenêtre device finissent à zéro.

## Refus préflight sûrs

Chaque refus est appliqué avant toute entrée native pair/resolver et ne modifie pas les compteurs ni le bitmap :

1. vertex null → `vertex_handle_null`;
2. pixel null → `pixel_handle_null`;
3. famille inversée → `vertex_record_invalid`;
4. device non co-résident → `device_not_coresident`;
5. échec factory prédit / headroom backend absente → `pair_backend_factory_failure_predicted`;
6. pool saturé → `pair_pool_saturated`.

## Répétabilité et validation

- Run 1 : PASS.
- Run 2 : PASS.
- Projection déterministe commune : `1da44bcb97da0e71f7131c473941e42e7751d226132e7ce8e26f0ea64de16ed7`.
- Validator : **43/43 checks**, puis réexécution sans `--output`; le hash du reçu de validation est resté inchangé (`e801396310494066a8dd2d8cb94067155a7df2d2a21263623d39c08736ea13c8`).
- Une revue indépendante relit le manifeste, rejoue le validator en mode non mutant et produit un run physique séparé; son résultat est livré comme artefact de revue distinct afin d’éviter une dépendance circulaire dans le manifeste principal.

## Limites et conditions de reprise

1. `0x9BEE80` (construction backend pair) et `0x64F030` (allocation/insertion cache) sont interceptés par des adapters bornés; leurs corps originaux ne sont pas qualifiés par ce run.
2. Le provider, les globals et le device guest sont synthétiques. Le device host observé est actuel, pas Riot 2014.
3. L’absence de transaction dans le binder réel reste ouverte : V1157 a établi que les deux `Set*Shader` ne sont pas atomiques. Aucun test de cette zone n’est autorisé ici.
4. Une reprise bind ne doit avoir lieu qu’avec un rollback explicite du cache, du current, des refcounts et du slot pair, plus une stratégie pour l’échec du second `Set*Shader`.
5. Aucun rendu, aucune image et aucune conclusion de fidélité visuelle ne découle de ce lot.

## Périmètre de mutation

Tous les nouveaux artefacts sont sous `E:\mapslol3v3\audit_map10_v1158_shader_pair_lifecycle_20261103`. Aucun fichier de `F:\OpenLeague`, produit, registre, Goal, Plan, UI ou base n’a été modifié par ce lot.
