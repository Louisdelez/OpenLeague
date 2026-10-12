# Crash du client de diagnostic : fermeture FILE avec le mauvais CRT

Capture réelle du seul enfant créé par `debug_game_manager_child.py`, commande `openleague-client.exe --native-replay-game-manager-probe E:\OpenLeague`. Enfant PID15308, thread16124. Capture de la première exception `0xC0000005`, puis terminaison de cet enfant uniquement. Aucun attachement à un autre processus, aucune installation/réseau, aucune modification de source production.

## Cause localisée

La pile capturée passe par le lecteur de configuration `native_filesystem_provider::windows::read`, puis le `fclose` de **msvcrt.dll**. Ce lecteur ouvre son FILE avec **fopen_s UCRT**, mais déclare `fclose` comme symbole externe générique. La nouvelle importation raw-dylib de `fclose` depuis msvcrt dans le module recording a capturé ce symbole à l'édition de liens du client complet. Les structures FILE des deux CRT sont incompatibles.

Preuves du binaire avant remplacement :

| Élément | Observation |
|---|---|
| Ouverture du lecteur existant | `native_filesystem_provider.rs` : `fopen_s`, import IAT RVA50B14D0 dans `api-ms-win-crt-stdio-l1-1-0.dll` |
| Retour sur la pile cliente | RVA85024C ; PDB public : `native_filesystem_provider::windows::read`, entrée84FFB0, delta29C |
| Appel immédiatement précédent | RVA850247 : call4E75D6E ; thunk4E75D6E : jmp[rip+23BBAC] → IAT50B1920 |
| Fermeture réellement importée | IAT50B1920 : `msvcrt.dll!fclose` ; fprintf/fopen également importés msvcrt aux RVA50B1928/50B1930 |
| Pile CRT | msvcrt+51570 (`fclose`) →514C5→5F034→1D60C (`free`) → ntdll+1CC5D (`RtlFreeHeap`) |
| Pointeur libéré | R8=RDI=214100000000, RSI=2140FFFFFFF0 ; lecture fautive à2140FFFFFFFF |
| En-tête FILE mal interprété | msvcrt+5F02B charge `[FILE+10h]`, puis appelle free à5F02F. Ce n'est pas le pointeur de buffer valide attendu dans son propre format FILE. |

`ntdll.dll` local est x64, SHA256 `a74f7482085eab125ccc09152ab7e0b5994bcb13e1a7b29880bdbb24179ecb8b`. L'export RtlFreeHeap débute à1CBE0 ; entrée .pdata1CBE0..1D69C. À1CC5D : `cmp byte ptr [rsi+0xF],5`, après RSI=RDI-10h. Heap RCX=R14=17885050000. CONTEXT aligné16 (reste0).

Le simple constat que fopen/fclose/fprintf proviennent tous de msvcrt n'excluait pas cette collision : un autre lecteur employait déjà fopen_s UCRT. La pile place cet accès invalide dans la lecture de configuration, pas dans `Application.close` ou le nettoyage FLS.

## Hypothèses de durée de vie examinées

`ServiceHandle::close` conserve son Arc Shared, donc le Drop final du mutex global transport peut survenir après `Application.close`. Ce décalage est réel mais existe également dans les tests core ; il n'explique pas la pile observée. Le heap CRT vide `Block.pointer` après libération et le Drop ne relibère pas le bloc normal. `Files::close` retire le label puis nullifie File.0 ; pas de double fclose normal trouvé dans cette couche. Aucun correctif de durée de vie ne doit remplacer la correction de cette collision démontrée.

Correction proposée à root : résoudre fopen/fclose/fprintf privés via GetProcAddress du module msvcrt, sans exporter/importer les symboles génériques globaux dans ce client UCRT. Puis vérifier que le fclose générique du lecteur redevient UCRT, refaire la sonde complète et conserver les contrôles heap/FLS.

## Artefacts

- `game_manager_debug_unsandboxed.json` : événements Debug API, modules, registres et 4096 octets de pile décodés en mots. Les adresses de pile hors chaîne prouvée restent des candidats, pas un StackWalk symbolique.
- `game_manager_debug_unsandboxed.child.log` : sortie enfant séparée.
- `crash_client_pdb_resolution.txt` : symboles publics MSF7 du PDB local, lus avant reconstruction ; pas de symbol server.
- `crash_crt_resolution.txt` : imports et désassemblage des instructions ci-dessus.
- `crashed_client_sha256.json` : hash du binaire capturé avant remplacement.
- Helpers reproductibles : `debug_game_manager_child.py`, `inspect_local_ntdll_fault.py`, `read_pdb_public_offsets.py`, `resolve_crash_crt.py`.

Le premier essai sandbox s'est arrêté sur PermissionDenied Game.cfg et n'a pas reproduit l'AV ; il reste distinct dans `game_manager_debug.json`. DbgHelp local n'a pas chargé le PDB (erreur126) ; la résolution réussie utilise le lecteur MSF7 explicite. Aucun cargo/build exécuté par cet agent. La correction et sa validation appartiennent à l'intégration root.
