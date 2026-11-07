# Revue indépendante V1154 — cleanup possédé des shaders

Verdict : **PASS 23/23, aucune anomalie**.

## Confrontation des preuves

- Manifeste source : `7/7` artefacts rehashés, zéro écart.
- Exécutable 4.20 : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Fenêtres `0x9AED50`, `0x9AEDC0`, `0x9BED40` et `0x8E2980` : tailles, SHA et instructions reconstruits directement depuis le PE.
- Deux runs finaux postérieurs au producteur : `passed=true`, projection commune `22b01f55beb00d931c9c8801b74dd6d9055ad5b343de2d893e6798ae933fad35`.
- Validateur source réexécuté : code 0, `56/56`; le reçu garde le même SHA avant et après.
- Producteur inchangé avant/après le validateur et le troisième run.
- Troisième run isolé : code 0, même projection.

Les quatre traces des deux runs source — deux nominales et deux phases de la référence partagée — totalisent 576 comparaisons adresse/instruction. Chaque adresse est une frontière d’instruction du PE épinglé et chaque séquence d’octets est relue depuis ce PE ; zéro adresse inconnue ou divergence.

## Seconde émulation indépendante

La revue implémente son propre runtime minimal, distinct de la classe du producteur, avec deux managers/records exact-layout et des proxies d’enregistrement.

| Stage | Index | Trace native | Releases | État final |
|---|---:|---:|---|---|
| vertex | 97 | 94 entrées, SHA `c4b3d2e5…4620d` | CTAB `1→0`, VS `1→0` | wrapper libéré, record/refcount 0, trois bits nuls |
| pixel | 3001 | 94 entrées, SHA `929d5397…1895f2` | CTAB `1→0`, PS `1→0` | wrapper libéré, record/refcount 0, trois bits nuls |

Les octets exécutés sont comparés en ligne au PE : zéro divergence et zéro accès mémoire invalide. Les deux appels atteignent leur sentinelle de retour.

## Limites et refus confirmés

Dans les deux runs source :

- la référence partagée suit `2→1` sans libération, puis le cleanup final complet ;
- les huit refus attendus sont exacts et n’entrent dans aucune fonction native ;
- le second cleanup VS/PS est refusé avec zéro nouvelle entrée ;
- tous les compteurs producteurs, D3DX, Create*, pool allocate, bind, draw, `Present` et readback restent nuls.

La qualification est correctement limitée : records/managers synthétiques, proxies invités d’enregistrement, branche D3D9 sélectionnée. Cette revue ne crée ni objet shader Riot, ni objet COM current-host, n’observe pas l’état vivant 2014 et ne compose pas encore les producteurs FOUR_BLEND.

## Livrables de revue

- `review_shader_owned_cleanup.py` : SHA-256 `185cd0e450685fc306c124dfcd5fb72488f3105322d52a98620675bb58db463f` ;
- `independent_third_run.json` : SHA-256 `1a53e8dc45973a0d8ca9cf6f02a506a583f9676583de65bc60751804c9c74c6a` ;
- `shader_owned_cleanup_independent_review.json` : SHA-256 `fd776adfebd4d3130c2f4b8f9cbda60868cfef74cbebdb44d1b654c6eed0b4da`.

Aucun artefact source, fichier sous `F:`, produit, registre, Goal, Plan, UI, base ou asset n’a été modifié par la revue.
