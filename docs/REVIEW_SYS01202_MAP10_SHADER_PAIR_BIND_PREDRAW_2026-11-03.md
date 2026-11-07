# Revue indépendante — V1159 shader bind pré-draw

## Verdict

**PASS — 135/135 contrôles, zéro échec.**

La revue a été réalisée uniquement par lecture des artefacts publiés dans `E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103`. Le producteur, le binder, les setters D3D9, un draw, Present et les readbacks n’ont pas été exécutés par le reviewer. Les identités du dossier primaire sont inchangées avant/après la revue.

## Points confirmés

- Les sept artefacts annoncés par le manifeste existent et leurs tailles/SHA-256 concordent.
- Les deux runs finaux sont `PASS`, ont des `run_id` distincts et partagent la projection déterministe `87d0fa59e9ebfaba215d772322bb88cd6e9ec7d3bc1a65fb116b88a0b218d072`.
- Le bind nominal passe par le résolveur puis une entrée du binder original ; l’ordre est VS puis PS, avec `0x00000000` pour les deux retours.
- Les résultats GetVS/GetPS sont `0x00000000` et leurs pointeurs correspondent aux shaders associés aux deux événements Set nominaux.
- Cache et current pair désignent le même record non nul. Le cache-hit/current-equal ne recrée, n’insère et ne rebind rien ; son état avant/après est identique.
- Le binder nul est un no-op sans setter et ne sert pas d’unbind.
- Le mismatch device est refusé avant entrée native, sans mutation du bitmap pair.
- Le diagnostic d’atomicité est correctement qualifié : vrai SetVS réussi, retour PS `0x8876086c` injecté dans l’adapter et appel host PS intentionnellement supprimé. Le Get* prouve l’état partiel VS lié / PS nul.
- Le rollback est explicitement attribué au harness seulement ; aucun rollback ni branche HRESULT n’est attribué au binder Riot.
- Tous les contrôles de cleanup sont vrais : device unbound, cache/current/desired/pools/records/shaders/proxies à zéro, fermeture propre.
- Trois entrées binder sont cohérentes avec nominal, null no-op et diagnostic ; deux vrais SetVS, un vrai SetPS et un échec PS injecté sont recensés.
- Zéro draw, zéro Present, zéro readback et aucune image dans le lot primaire.
- Le device/runtime est clairement qualifié current-host RTX 3060, non Riot 2014 ; aucune conclusion de fidélité visuelle ou de complétude du jeu n’est formulée.
- Le validateur primaire est lui-même `PASS 87/87`, sans mutation de ses entrées.

## Limites conservées

- Le backend pair, l’insertion cache, l’objet device invité et le pont setter restent des adapters bornés.
- L’échec PS est injecté dans l’adapter ; ce n’est pas un échec produit par le driver NVIDIA.
- Le device D3D9 et ses shaders sont current-host, pas un environnement Riot 2014.
- Ce lot s’arrête strictement avant tout draw/Present/readback et ne clôt pas SYS-01.2-02 ni le jeu complet.

La preuve machine détaillée se trouve dans `independent_review.json`.
