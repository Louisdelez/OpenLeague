# Revue indépendante V1154 — adapter des pools shader

Verdict : **PASS 34/34, aucune anomalie**.

## Confrontation des preuves

- Exécutable 4.20 relu directement : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, PE32 x86 base `0x400000`.
- Manifeste source : 6/6 fichiers, tailles et SHA exacts.
- Les deux runs sont postérieurs au producteur, épinglent son SHA `90a7232b…0c14c`, passent 12/12 et partagent la projection `103685e2…39c9e`.
- Les cinq fenêtres natives ont été extraites et rehachées indépendamment ; elles concordent avec les reçus.
- Capacité `0x1000`, managers/bases VS/PS, sentinelle, stride 8, calls alloc/free et mises à zéro des records ont été relus dans le PE, sans dépendre des booléens du producteur.
- Le validateur source a été réexécuté : code 0, 46/46 ; son reçu garde exactement le même SHA avant/après.

## Exécution native indépendante

Un second harness, écrit dans le dossier de revue, exécute uniquement `0x8E28C0` et `0x8E2980` sur deux managers exact-layout reconstruits séparément.

- franchissement de la frontière 31/32 : indices `0..32` exacts ;
- après libération, réutilisation exacte `[31,32]` ;
- saturation : 4 096 indices uniques, min 0, max 4 095, puis sentinelle `0x1000` ;
- SHA du bitmap plein : `9c4b2a8529a741011bf514bb5f3f778705aa49bd6122e4cc1049bcc7345fd70b` ;
- un second manager alloue indépendamment `0..63` sans modifier le premier ;
- cleanup : les deux bitmaps reviennent au SHA zéro `47bed81b9dd45f914b6f4c65d96eb6803050cbb576f6f4d2e7911d0b35983b51` ;
- 105 adresses originales distinctes observées, toutes dans les deux fenêtres autorisées.

## Limites conservées

La revue confirme un adapter sûr au-dessus des primitives originales, pas l’état vivant historique de 2014. Les refus par famille/génération/plage sont une politique de l’adapter. Aucune factory/release de record, aucun producteur, compilateur, device shader, bind, draw, `Present` ou readback n’est exécuté.

Le blocker pool est donc fermé pour la frontière annoncée. Le cleanup possédé complet des objets/records et l’intégration aux producteurs restent ouverts.

