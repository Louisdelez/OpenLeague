# Revue indépendante finale V1163 — provider/ordre ColorPalette Map10

## Verdict

**PASS — 31/31 contrôles indépendants.**

L’audit atomique
`AUD-SYS-01.2-02-MAP10-COLOR-PALETTE-PROVIDER-ORDER-01` est clos à sa
frontière indirecte unique. Cela ne termine ni la fonctionnalité ColorPalette,
ni Map10, ni le renderer, ni `SYS-01.2-02`, ni le jeu.

- lot lead PE : manifeste
  `22bf0114851722c377595f406975404035f8b83d0cfd8711317181747a235667`,
  digest stable
  `b3789ecf90f4bd077a900e7a627f760fafd43981cc38f844dab7705b2c96fb0c` ;
- crosscheck consommateur : manifeste
  `21c8024f92a831a6fc164569ad22ad8bca9d5df03f81a553a537e654897fab6d`,
  preuve reproductible
  `63ffc27fad00f4705e79a83b9218765af80970e7d5bd400477dc4fe0aacec8e1` ;
- validateur lead rejoué : **44/44**, code 0 ;
- crosscheck rejoué une troisième fois : **12/12**, sortie byte-identique ;
- les deux lots source sont inchangés avant/après.

## Preuve PE et ordre statique

Le PE 4.20 épinglé fait 15 973 880 octets et porte le SHA-256
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
Les 20 séquences critiques ont été relues indépendamment.

- `0x2D79058` : 50 occurrences brutes dans `.text`, zéro initial PE et trois
  stores directs qualifiés : `0x97CCF8`, `0x97CDB6`, `0x97CDD1`.
- `0x2D7905C` : six occurrences brutes, zéro initial PE, trois stores directs
  de la valeur 1 à `0x72C99C`, `0x72C9C6`, `0x72CA16`, aucun store direct 0.
- Callers rel32 exacts :
  - `0x97CCB0` ← `0x837ABF`, `0x837AD3` ;
  - `0x97CD90` ← `0x5902D5` ;
  - `0x959D30` ← `0x58E385`, `0x73DF1F`, `0x95A392` ;
  - `0x58FF50` ← `0x59307A` ;
  - aucun caller E8 des trois writers de contexte.
- Les trois writers sont présents uniquement dans la table virtuelle
  `0x10AFE8C`, slots `+0xA4/+0xA8/+0xAC`. Leur ordre d’invocation relativement à
  l’initialiseur et aux builders reste donc `UNKNOWN_RUNTIME_ORDER`.

Ordres intra-fonction confirmés :

1. l’initialiseur choisit `ColorPalette` si contexte 0, sinon
   `ColorPaletteSpectator` ;
2. il appelle `0x8B1C20`, accepte `0..2`, stocke le résultat à `0x97CDB6` ou
   replie sur 0 à `0x97CDD1` ;
3. le setter stocke à `0x97CCF8` avant acquisition du filename, demande de
   sérialisation et notifications listeners ;
4. `0x959DA0` lit la valeur courante : 1 → `COLORPALETTE_SPECTATOR`,
   2 → `COLORPALETTE_COLORBLIND`, toute autre valeur →
   `COLORPALETTE_DEFAULT` ;
5. la palette est ajoutée à `0x959DDA`, avant le groupe fog à `0x959DE3`.

## Defaults, provider et runtime

Les defaults `ColorPalette=0` et `ColorPaletteSpectator=1` sont confirmés comme
baselines lexicales seulement. Ils ne sont pas promus en valeur runtime.

Le getter générique `0x8B1C20` prouve l’ordre : baseline/default avant user,
overlay avant primary dans chaque paire, avec résultat précédent comme fallback.
Son contrat reste incomplet pour le lancement de référence : les paires réellement
retournées par `0x8ACEF0`, leur population et le dernier événement avant
`0x959DA0` ne sont pas observés.

Classification finale :

- provider générique : `PROVEN_STATIC_GENERIC_INTEGER_CONFIG_ROUTING` ;
- provider/overlay effectif : `UNKNOWN_AT_REFERENCE_RUN` ;
- ordre runtime au consommateur : `UNKNOWN_RUNTIME_ORDER` ;
- valeur historique effective : inconnue.

## Consommateur OpenLeague actuel

Le crosscheck borné ne trouve aucun bridge nommé ColorPalette dans les consommateurs
Rust/WGSL inspectés. Il constate une étiquette UI, mais pas d’état palette publié ni
de liaison matériau/shader. Ce résultat est limité au périmètre nommé inspecté et ne
prouve pas l’absence mondiale d’un chemin sémantiquement équivalent.

La fonctionnalité actuelle reste donc
`UNKNOWN_NOT_MATERIALIZED` dans ce raccord borné, avec `functional_completion=false`.

## Reprise et règle d’arrêt

Reprendre seulement avec une nouvelle preuve qualifiée :

- ordre horodaté same-run des slots `+0xA4/+0xA8/+0xAC`, de `0x5902D5` et du
  prochain caller `0x959D30` ;
- identité/contenu des paires cache réellement rendues par `0x8ACEF0` ;
- valeur de `0x2D79058` immédiatement avant `0x959DA0` ;
- ou, pour OpenLeague, un bridge préférence puis renderer explicitement sourcé.

Ne pas relancer les scans directs, D3D9, REA, les candidates shader ni une recherche
globale sans nouvelle entrée concrète.

## Limites de la revue

Aucune écriture F:, installation, exécution du jeu, D3D9, réseau ou REA. Aucun
produit, Goal, Plan, UI, base ou registre modifié. Les écritures de revue sont
limitées à ce dossier E:.

Note non bloquante : les deux sorties crosscheck ne portent pas de `run_id`
distinct, mais les commandes consignent deux exécutions et le présent rerun tiers
produit exactement les mêmes 12 contrôles et les mêmes octets.

