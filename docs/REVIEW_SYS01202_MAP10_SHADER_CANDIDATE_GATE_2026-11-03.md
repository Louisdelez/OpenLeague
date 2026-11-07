# Revue indépendante — V1161 shader candidate gate

Date : 2026-11-03  
Verdict : **PASS — 19/19**

## Contrôles réalisés

- manifeste source : 7/7 entrées, tailles et SHA-256 exacts ;
- syntaxe AST des trois scripts : valide, sans création de `.pyc` ;
- deux runs source : audit `PASS`, même projection
  `9ec559e43c162dad34ccfc34811ed5a5bbac5c7a9fb89971262d0bf36e8cbcb1` ;
- toutes les CTAB embarquées égales aux buffers retournés ;
- tous les buffers D3DX libérés à refcount zéro ;
- gate REA : reçu absent explicitement refusé, zéro mutation et état inchangé ;
- ledgers device, lifecycle, bind, upload, draw, `Present` et readback vides ;
- validateur source rejoué : 26/26, exit `0`, non mutant ;
- troisième compilation isolée : exit `0`, mêmes identités/projection et même
  refus `BLOCKED_BEFORE_MUTATION` ;
- lot source byte-identique avant/après ; cinq registres protégés byte-identiques.

Le troisième run emploie un chemin de reçu intentionnellement absent dans le
dossier de revue. Une publication REA postérieure ne peut donc pas modifier ce
cas de refus.

## Conclusion

Les deux permutations sont reproductibles sur le D3DX current-host, mais elles
restent des candidates. La revue confirme que le code ne les promeut pas comme
historiques et que le gate n'accepte ni preuve partielle ni provenance
synthétique.

La fonctionnalité demeure bloquée jusqu'à un reçu REA machine-readable qui
établit l'ordre et les valeurs du vector macro, l'identité des arguments aux
deux producteurs et le lien au consommateur terrain.

## Limites

- aucun runtime Riot x86 2014 ni producteur original exécuté ;
- aucun device D3D9, shader bind, upload de constante, draw, `Present`, readback
  ou pixel ;
- aucune image, fidélité visuelle ou acceptation humaine qualifiée ;
- aucune écriture sur `F:` ou modification produit.

Preuves : `review_receipt.json` et `review_rerun.json` dans ce dossier.
