# Revue indépendante V1161 — lien statique macros → producteurs → terrain

Date : 2026-11-03  
Source revue : `E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103`  
Verdict : **PASS_STATIC_COMPONENT_ONLY — 28/28**

## Résultat

La revue confirme le verdict borné `PROVEN_STATIC` : le vecteur dynamique issu
de `0x9593C0` est copié profondément, dans l'ordre, vers deux records distincts
pixel et vertex. Le même suffixe statique `DISABLE_EMISSIVE;FOUR_BLEND` est
ajouté après le préfixe ; les producteurs lisent ces records, publient leur
handle en `record+4`, puis le chemin terrain ordinaire rejoint ces handles avant
le draw.

La conclusion reste conditionnelle : selector 0, matériau type 3, options de
sélection compatibles, lookups/manager/device/handles valides et remapping
pixel death-screen inactif. La revue ne transforme pas ce chemin conditionnel
en identité historique inconditionnelle.

Le vecteur runtime complet reste `UNRESOLVED_RUNTIME_INPUTS`. Les candidates
V1161 restent `REFUSED` : leur ordre n'est pas celui du builder original et
elles omettent des macros conditionnelles, dont les compagnes du fog.

## Contrôles indépendants

- 6/6 artefacts du manifeste source : taille et SHA-256 exacts.
- Inventaire source exact : sept fichiers, manifeste compris.
- Syntaxe AST des deux scripts : valide, sans création de `.pyc`.
- Deux runs : schéma, IDs, verdicts et digest
  `2f9f20dd2d75e65e712e377ddd87a85b56cd5d44e24b056af4ac08c280b0ab51`
  concordants.
- Validation conservée : `22/22 PASS`.
- Validateur original rejoué avec `-B` : exit 0, `22/22 PASS`, aucun octet du
  lot source modifié.
- PE x86 original : 15 973 880 octets, SHA-256
  `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Reconstruction indépendante du mapping PE32 VA → offset : 24/24 fenêtres
  byte-exactes.
- Scan brut indépendant des `E8 rel32` de `.text` vers `0x9593C0` : seul
  caller direct `0x959D9B`.
- Copie profonde/non-alias, suffixe commun, publication `record+4`, bind
  conditionnel et limite death-screen vérifiés dans les deux runs.
- Branches fog vérifiées : aucune, `VERTEX_FOG`, ou
  `FOG_PIXELSHADER_BLEND` avec `FOG_QUALITY_LOW`/`FOG_TEXTURED_OPACITY`.
- Six groupes d'entrées runtime non épinglées conservés ; aucune candidate
  n'est admise.
- Six sources épinglées inchangées ; les cinq registres protégés de F sont
  inchangés avant/après.
- Aucune métrique obsolète (`0d012b`, `21/21`, anciens hashes) ne subsiste.

## Frontières

Aucun client original, appel D3D, réseau, compilation/lifecycle shader, bind,
draw, `Present`, readback, pixel ou acceptation humaine n'est qualifié par cette
revue. Aucun fichier du lot source ni aucun fichier sur F n'a été modifié. La
prochaine entrée utile reste une capture originale Map10, même-run, des valeurs
runtime et du vecteur ordonné complet ; répéter la même analyse statique ne
résoudrait pas ces valeurs.

Le reçu machine-readable est `review_receipt.json`.
