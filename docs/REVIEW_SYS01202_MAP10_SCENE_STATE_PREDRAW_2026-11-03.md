# Revue indépendante V1160 — scène, targets et viewport pré-draw

## Verdict

**PASS_CURRENT_HOST_SCENE_COMPONENT_ONLY — 30/30 contrôles indépendants.**

La preuve V1160 est cohérente pour son périmètre déclaré : un composant D3D9
current-host séparé établit et restaure RT0/depth/viewport/scissor, acquiert une
scène une seule fois, observe le refus du second `BeginScene`, puis équilibre
`EndScene`. Les deux runs existants passent chacun 20/20 contrôles et ont un
contenu stable identique après retrait exclusif des identifiants et timestamps
de run.

Ce verdict ne qualifie ni l'exécution du client Riot 4.20, ni une composition
full-pipeline, ni un shader/material/texture, ni un draw, une image ou une
fidélité visuelle.

## Identités revues

- Source : `E:\mapslol3v3\audit_map10_v1160_scene_state_20261103`.
- Producteur : 33 567 octets, SHA-256
  `f911b85597ccab41e978779445569ba74fc036a2499c057c4c1f7cf901a0880d`.
- Run 1 : 30 020 octets, SHA-256
  `d247afbb662f2f842fc4c45af7543f1ffe21ccadb65b3aa370dab0f008ec323f`.
- Run 2 : 30 020 octets, SHA-256
  `a500253a2506f96c612502d15c15b230b38be9c0aa3001b1ca341dc4949bf03e`.
- Validation source : 28 850 octets, SHA-256
  `25881f78a834bef9ad4a1af2ed4a5634893212402193bdb5de949b47cd910a9b`.
- Rapport source : 9 422 octets, SHA-256
  `7d9ea63ac67f4f5e33802f7ddcb535d7051e0b1e603401f6d1b56c972858fa98`.
- Manifeste source : 1 940 octets, SHA-256
  `805424aba1ba45c6a08b53c822ff52056cdb9894f28ee1b08f3c1d245e4c4e83`.

Le manifeste source contient sept livrables : chaque chemin reste dans le
répertoire source et chaque taille/empreinte correspond. Le huitième fichier du
répertoire est le manifeste lui-même. Les six entrées épinglées par les runs
(V1154, V1155, V1159, EXE 4.20 et `d3d9.h`) existent toujours avec leurs octets
attendus.

## Contrôles indépendants

### Deux runs et déterminisme

- Schéma identique et `passed=true` deux fois.
- 20/20 contrôles intégrés dans chaque run.
- SHA-256 de la projection indépendante complète, après retrait de
  `run_id/started_utc/finished_utc` :
  `7d1b729d2361a90521520ddca506d6da0c41543b4af89b0b89855902723ca45e`
  pour les deux runs.
- Le validator source rejoué en mode sans sortie renvoie encore 30/30, digest
  `e78e55b0ba1ca58ac6da78efedef0afbb4d547fb6f6d1387023908360ec96263`,
  `output=null` et code 0.

### Ledger et frontière COM

Le reviewer a vérifié l'ordre, le rôle, le HRESULT, l'indice de vtable et
l'offset x86 de chacun des 28 appels. La suite est exactement : snapshot,
création RT/depth, quatre setters, quatre getters de vérification, gate
coopératif, deux `BeginScene`, un `EndScene`, gate post-scène, quatre setters de
rollback et quatre getters finaux.

- Premier `BeginScene` : `0x00000000`.
- Second `BeginScene` : `0x8876086c`.
- `EndScene` : `0x00000000`.
- RT/depth jetables : 32×32, MSAA compatible, même device.
- Refus 33×32 : rejet du harnais avec compteur natif inchangé à 7.

L'AST du producteur et du validator est valide. Les cibles `_method` de
`SceneDeviceAdapter` appartiennent toutes aux 13 slots autorisés. Aucune méthode
adapter de shader bind, draw, `Present` ou readback n'existe. Les cinq slots
interdits déclarés ont un compteur zéro.

Cette conclusion est volontairement **structurelle** : allowlist de l'adapter
et ledger, pas instrumentation de tout le processus. Le rapport source énonce
correctement cette limite.

### Rollback et ownership

- Rollback dans l'ordre scissor, viewport, depth nul, RT0 : quatre `S_OK`.
- Relecture : même RT0, depth de nouveau absent avec `D3DERR_NOTFOUND`,
  viewport/scissor 64×64 exacts, scène non détenue.
- Les trois ressources détenues finissent à zéro : depth jetable, RT jetable et
  RT snapshot.
- `IDirect3DDevice9::Release=0`, `IDirect3D9::Release=0`, fenêtre détruite.
- Aucun shader forcé à libérer.

## Non-mutation et incident de revue

Le replay par défaut du validator n'a modifié aucun octet source. L'inventaire
avant/après du reçu indépendant est strictement identique.

Lors du tout premier contrôle de syntaxe, `python -m py_compile` a produit un
répertoire `__pycache__` transitoire dans le lot source. Le reviewer a énuméré
les trois `.pyc`, supprimé uniquement ce répertoire généré par la revue, puis
recalculé l'inventaire et toutes les empreintes. Aucun artefact admis n'a changé
et le répertoire source final contient exactement ses huit fichiers initiaux.

## Limites conservées

- Pas de troisième run D3D : la revue rejoue le validator et inspecte les deux
  runs existants.
- Runtime Windows courant sur RTX 3060 ; pas le runtime Riot/Windows 2014.
- Wrappers Riot originaux : preuves statiques seulement, non exécutées ici.
- Device-lost forcé : **NOT RUN** ; seul le gate non-`S_OK` est présent.
- Aucun shader bind, constante, material, texture, géométrie, draw, `Present`,
  readback, pixel, fidélité visuelle ou acceptation humaine qualifié.
- Le rollback full-pipeline reste ouvert ; seul le sous-ensemble
  scène/surfaces/viewport/scissor est clos comme composant séparé.

## Conclusion

La revue ne relève aucune divergence dans le périmètre annoncé. V1160 ferme le
bloc autonome scène/targets/viewport current-host pré-draw. Il ne rend pas le
draw Map10 global READY et ne change pas l'état d'implémentation du jeu.

