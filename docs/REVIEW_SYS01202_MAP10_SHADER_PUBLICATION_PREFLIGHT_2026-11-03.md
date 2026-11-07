# Relecture indépendante V1152 — préflight de publication FOUR_BLEND

Date : 2026-11-03  
Périmètre : `E:\mapslol3v3\audit_map10_v1152_shader_publication_20261103`  
Verdict : **refus borné et provenance documentaire confirmés ; 23/23 contrôles indépendants vrais**.

## Résultat

La publication ciblée n’a pas été exécutée. La relecture confirme que l’arrêt avant `0x98D960` et `0x98C070` est justifié par cinq contrats runtime absents du harness épinglé : VFS/inclusions, bridge D3DX, création des deux stages D3D9, pools shader et nettoyage possédé composé.

La première matrice indépendante avait obtenu 22/23 et refusé le libellé « V1150 composé ». Le lot source a ensuite été corrigé sans masquer ce constat. La matrice rejouée sur les nouveaux octets obtient désormais **23 contrôles vrais sur 23** : les chemins et le schéma identifient V1145, puis le texte distingue explicitement sa réutilisation/héritage par V1150.

Ce succès qualifie le rapport de préflight borné, jamais une publication de shader.

## Vérifications indépendantes

### Sources, PE et chaîne de compilation

- Les cinq artefacts du lot source correspondent à leurs tailles et SHA-256 annoncés.
- Les huit entrées externes du reçu sont relues et correspondent à leurs tailles et SHA-256.
- Les neuf fichiers HLSL sont relus ; leurs tailles et SHA-256 correspondent.
- Les sept arêtes `#include` sont reconstruites depuis les fichiers. Aucun des sept enfants ne contient une autre inclusion.
- Le PE source est bien le PE32 x86 de SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, base `0x400000`.
- Les deux triplets de descripteur à `0x123F678` et `0x123F550` correspondent à `Environment_LIT_FOUR_BLEND_VS/PS`, aux sources `LIT_VS/PS.vs/ps_2_0` et à `DISABLE_EMISSIVE;FOUR_BLEND`.
- Les huit fenêtres natives ont été relues dans le PE et leurs SHA-256 correspondent.
- L’import `D3DXCompileShader` est bien à l’IAT `0xFA4800` depuis `d3dx9_39.dll` ; l’export existe dans les DLL x86 et x64 épinglées.
- Les slots SDK relus sont `+0x16C CreateVertexShader`, `+0x1A8 CreatePixelShader`, `+0x170 SetVertexShader` et `+0x1AC SetPixelShader`.

### Justification du refus

Le probe amont épinglé ne contient aucune des onze ancres nécessaires : `0x8B4FB0`, `D3DXCompileShader`, `CreateVertexShader`, `CreatePixelShader`, les quatre globals de pools et les trois entrées de nettoyage shader. Il ne fournit donc aucun des cinq contrats manquants.

Le script de préflight V1152 ne contient ni Unicorn/`emu_start`, ni lancement de processus, ni installation, ni chemin d’appel COM/GPU. Ses compteurs nuls sont cohérents avec une inspection statique sans tentative runtime ; ils ne doivent pas être présentés comme une trace d’exécution native.

### Provenance amont et nettoyage

Le reçu utilise les clés `v1150_probe` et `v1150_execution`, mais elles pointent vers :

- `audit_map10_native_backend_composed_20261103/probe_native_backend_composed.py` ;
- `audit_map10_native_backend_composed_20261103/native_backend_composed_execution.json` ;
- schéma `openleague_map10_native_backend_composed_probe/v1145`.

Le rapport V1145 confirme le device current-host RTX 3060 et le nettoyage des ressources hôte possédées : 40 entrées de nettoyage, tous les proxies suivis à zéro et fenêtre cachée détruite. Il confirme aussi qu’aucun upload, draw ou `Present` n’a été réalisé.

En revanche, `native_full_teardown=false` et **27 allocations invitées/natives** restent recensées au point d’arrêt V1145. Le rapport V1152 dit correctement « nettoyage COM hôte » et ne revendique pas un teardown natif complet ; ce distinguo doit rester explicite.

## Correction vérifiée

Le rapport source écrit maintenant « preuve V1145 réutilisée puis héritée par V1150 ». Le reçu remplace les deux anciennes clés trompeuses par `v1145_probe_inherited_by_v1150` et `v1145_execution_inherited_by_v1150`. Il conserve également les trois limites nécessaires : 40 entrées de nettoyage hôte, `native_full_teardown=false` et 27 allocations invitées vivantes.

La relecture n’a pas modifié le lot source ; elle a seulement rejoué les contrôles après sa correction explicite.

## Contrôles exécutés

- compilation syntaxique des deux scripts V1152 et du validateur indépendant : succès ;
- relecture du validateur V1152 en interceptant son écriture : **14/14**, fichier source inchangé ;
- validateur indépendant exécuté deux fois après correction : **23/23**, sortie déterministe ;
- cinq hashes protégés de `F:\OpenLeague\docs` conformes aux baselines approuvées : `completion_plan`, `resume_checkpoint`, `fidelity_requirement_trace_4_20`, `fidelity_sources_4_20`, `fidelity_unknowns_4_20`.

Livrables :

- `review_shader_publication_preflight.py` — 16 065 octets, SHA-256 `16d30c5a13be750f3c22b8cb23406f407d7317050f37b9351f05bb9b88f689da` ;
- `shader_publication_independent_review.json` — 5 881 octets, SHA-256 `8c724a57108a44209bf9934ebdc84b623a4e40e83fcc886f26c3fb78402cd0ae`.

Le présent rapport est exclu de sa propre liste d’empreintes afin d’éviter une référence circulaire.

## Limites conservées

- Aucun shader n’est compilé physiquement ou publié par ce lot.
- Aucun handle `record+4`, wrapper backend, bind, draw, `Present`, readback ou pixel n’est observé.
- La RTX 3060 et les DLL actuelles ne représentent pas le runtime/pilote de 2014.
- Les hashes protégés démontrent seulement que les cinq fichiers nommés restent à leur baseline ; ils ne prouvent pas l’absence de toute écriture sans rapport ailleurs sur les disques.
- La publication ciblée reste ouverte jusqu’à réalisation et validation des cinq contrats runtime.
