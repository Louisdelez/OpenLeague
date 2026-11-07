# Revue indépendante finale v1162 — remappage pixel de l’écran de mort

## Verdict

**PASS — 30/30 contrôles indépendants.**

Lot source qualifié :
`E:\mapslol3v3\audit_map10_v1162_deathscreen_remap_20261103`

- manifeste source SHA-256 :
  `c3d1fad83a1ff3ca52f898359527264dab91910410abd7c134f30c42f6b77188` ;
- digest stable des deux runs :
  `33a95387290824dd82d116686d3a67c002153955fc209976efc595aee310111b` ;
- validateur source rejoué sans mutation : **29/29**, code retour 0 ;
- revue indépendante : **30/30**.

L’erreur documentaire trouvée dans l’instantané précédent est corrigée : le
chargement sémantique `record+4` est bien attribué à `0x95a5b5`, pas à
`0x95a5c3`.

## Intégrité des artefacts et reproductibilité

- Les six artefacts déclarés correspondent exactement au manifeste en taille et
  SHA-256.
- `run1` et `run2` sont distincts, positifs et produisent le même digest après
  recomputation canonique indépendante.
- Le validateur source exact a été chargé puis exécuté sur des copies des deux
  runs dans le dossier de revue. Son seul global de garde de chemin a été redirigé
  vers ce dossier afin qu’aucune écriture n’atteigne le lot source.
- L’empreinte complète du répertoire source avant et après le rerun est identique :
  sept fichiers, aucune mutation et aucun `__pycache__` résiduel.
- Le PE épinglé sur D: fait 15 973 880 octets et porte le SHA-256
  `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Résultats techniques confirmés

- Le `.text` contient **54 occurrences brutes** du global `0x2d78f48` et les
  runs contiennent **54 références d’instruction alignées**, toutes byte-exactes,
  uniques et en correspondance un-à-un ; aucune occurrence non alignée.
- Les cinq callers du remap sont `0x95a8a8`, `0x95ab89`, `0x95ac50`,
  `0x95acbb`, `0x95c356`. Le caller unique de l’insertion est `0x95a17d`.
- Le drapeau est exactement l’octet `[global 0x2d78f48 + 0x0c]` : chargement à
  `0x95a574`, comparaison à `0x95a579`.
- Les sept écritures directes byte-exactes sont :
  - constructeur : `0x960a51 = 0` ;
  - runtime : `0x63d99b = 0`, `0x63e56c = 1`, `0x63e5c8 = 1`,
    `0x63effb = 0`, `0x63ffa9 = 1`, `0x63ffc6 = 0`.
- Le chemin actif appelle la recherche à `0x95a58d` et charge la substitution
  depuis `node+0x14` à `0x95a599`.
- Drapeau nul : `0x95a57d` saute vers `0x95a59e`, qui recharge l’index original
  `[ebp+8]`.
- Lookup manqué : comparaison sentinelle à `0x95a594`, saut à `0x95a597` vers
  le même rechargement original à `0x95a59e`.
- Lookup réussi : `0x95a599` charge `node+0x14`, puis rejoint le sink commun à
  `0x95a5a1`/`0x95a5a7`.
- Le stride `index*0x80` est à `0x95a5b2`. Le chargement du handle
  `manager+0x2d8+index*0x80`, correspondant à `record+4`, est à `0x95a5b5`
  avec les octets `8b9408d8020000`.

## Contrôle de l’adresse corrigée

`0x95a5c3` n’apparaît plus dans les objets sémantiques `proof` et `verdict` des
deux runs. Il reste uniquement :

- dans le désassemblage brut/contexte des runs, où `0x95a5c3` vaut légitimement
  `85c9` (`test ecx, ecx`) ;
- dans le nom du contrôle négatif du validateur et son reçu, qui vérifie justement
  l’absence de cette ancienne adresse dans la preuve sémantique.

Il ne subsiste donc aucune assertion sémantique attribuant le chargement du handle
à `0x95a5c3`.

## Classification et limite ouverte

La logique de remappage est prouvée statiquement. La valeur runtime Map10 ne l’est
pas :

- constructeur : `INACTIVE_PROVEN_INITIAL_ONLY` ;
- démarrage Map10 : `UNKNOWN_AT_STARTUP` ;
- draw Map10 : `UNKNOWN_AT_DRAW`.

L’absence d’écran de mort n’est pas utilisée comme preuve. La condition de reprise
reste d’obtenir un snapshot original admissible de `[0x2d78f48]+0x0c` à
l’amorçage/au draw, ou de prouver l’ordre de toutes les écritures post-constructeur
atteignant ce byte avant `0x95a8a8/0x95a570`.

## Limites strictes de la revue

Aucun processus de jeu n’a été lancé. Aucun appel D3D, réseau ou REA n’a été
effectué. Aucun accès au disque F: n’a été effectué. Aucun goal, plan, UI, base de
données ou artefact produit n’a été modifié. Les seules écritures persistantes sont
dans le présent dossier de revue sur E:.

