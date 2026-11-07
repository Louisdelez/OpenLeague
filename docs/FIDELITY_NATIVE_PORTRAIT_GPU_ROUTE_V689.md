# SYS-01.2-02 — Parcours DDS natif et transport GPU actuel, V689

UTC 2026-10-27T19:34:14.122672+00:00. F:/OpenLeague ; PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. V688 est une progression publiée : composantsCPU et différence de table Kalista. Ce lot précise leur portée dans un parcours de chargement et ajoute une preuve de transport GPU réel ; il ne termine pas l’écran ou le jeu.

## Faits vérifiés

Le caller de portraits pousse1, puis98A7F0/989B10 transmettent ce paramètre jusqu’au champ6C lu par989500. Sur les douze DDS, le parcours CPU original989500→9BB3D0→9B65E0→9BB2D0→9BB220 est exécuté sous contexte déclaré et s’arrête **avant** la méthode virtuelle de création60h. Vingt-quatre profils correspondant au paramètre Standard demandent1mip. Six contrôles supplémentaires de sélecteur et deux arrêts avant diagnostic natif sont conservés. Une capture complémentaire Kalista relève la table réellement produite avec le paramètre de borne0 de ce caller.

Le GPU actuel réalise24transferts de textures et33relectures de mipmaps dont les octets correspondent aux plages exactes des fichiers. Deux profils sont explicites : tous les mips du fichier et un descriptor de sonde limité à1. Aucun shader d’affichage ou écran n’est rendu par ce test.

## Import de métadonnées identifié

Le PE importe **d3dx9_39.dll!D3DXGetImageInfoFromFileInMemory**, IAT0xfa47f8. La DLL x86 installée utilisée est{'path': 'C:\\Windows\\SysWOW64\\d3dx9_39.dll', 'bytes': 3851784, 'sha256': '5d29988cad858f754ecc62c3d30de555f82cc21b5b26c448b890295e9b7bee82'}. Un helperx86 appelle réellement l’API pour les douze DDS, puis pour deux entrées invalides refusées. Architecture du module mappé14Ch, chemin finalSysWOW64 et empreinte de fichier sont contrôlés ; Windows peut présenter un aliasSystem32 et une casse différente. Les identités et alias restent séparés de l’égalité de contenu.

Cette DLL locale correspond au nom/API importés. **Son hash n’est pas qualifié comme celui du runtime installé en2014.** Le wrapper natif9B2A20 reçoit, à sa frontière importée, les résultats réellement observés de ce helper ; ce pont est déclaré, et n’est ni une exécution du processus historique ni un résultat de parseur inventé.

## Instructions et portée du parcours

| VA | Octets | Instruction source contrôlée |
|---|---|---|
| 0x57db9b | 6a01 | push 1 |
| 0x57db9d | 6a00 | push 0 |
| 0x57dba9 | e842cc4000 | call 0x98a7f0 |
| 0x98a9b4 | ff7518 | push dword ptr [ebp + 0x18] |
| 0x98a9ca | e841f1ffff | call 0x989b10 |
| 0x989cde | ff7518 | push dword ptr [ebp + 0x18] |
| 0x989e63 | e8c8010000 | call 0x98a030 |
| 0x98a0c1 | 8b4518 | mov eax, dword ptr [ebp + 0x18] |
| 0x98a0c4 | 89466c | mov dword ptr [esi + 0x6c], eax |
| 0x989603 | e8c81d0300 | call 0x9bb3d0 |
| 0x9bb412 | e8c9b1ffff | call 0x9b65e0 |
| 0x9bb4df | e8ecfdffff | call 0x9bb2d0 |
| 0x9bb4e7 | e834fdffff | call 0x9bb220 |
| 0x9bb247 | ff5260 | call dword ptr [edx + 0x60] |

Les instructions exécutées sont comparées aux octets du PE. Le constructeur989150 est exécuté ; un gestionnaire de catégorie emprunté avec current=null est fourni et la tranche98A0BB..98A0C7 publie les champs68/6C. Il s’agit du défaut natif sans catégorie, pas de la catégorieflash effective. Deux mots de capacité0/100h sont des entrées de test, sans requête à un ancien périphérique. Allocation/free/cookie de sécurité restent des feuilles déclarées.

| Contexte | Sélecteur6C | Mot de capacité déclaré | Niveaux demandés |
|---|---:|---:|---:|
| Ahri:0:standard:caps0 | 1 | 0 | 1 |
| Ahri:0:standard:caps256 | 1 | 256 | 1 |
| Ahri:1:standard:caps0 | 1 | 0 | 1 |
| Ahri:1:standard:caps256 | 1 | 256 | 1 |
| Braum:0:standard:caps0 | 1 | 0 | 1 |
| Braum:0:standard:caps256 | 1 | 256 | 1 |
| Braum:1:standard:caps0 | 1 | 0 | 1 |
| Braum:1:standard:caps256 | 1 | 256 | 1 |
| Kalista:0:standard:caps0 | 1 | 0 | 1 |
| Kalista:0:standard:caps256 | 1 | 256 | 1 |
| Kalista:1:standard:caps0 | 1 | 0 | 1 |
| Kalista:1:standard:caps256 | 1 | 256 | 1 |
| Lulu:0:standard:caps0 | 1 | 0 | 1 |
| Lulu:0:standard:caps256 | 1 | 256 | 1 |
| Lulu:1:standard:caps0 | 1 | 0 | 1 |
| Lulu:1:standard:caps256 | 1 | 256 | 1 |
| Rengar:0:standard:caps0 | 1 | 0 | 1 |
| Rengar:0:standard:caps256 | 1 | 256 | 1 |
| Rengar:1:standard:caps0 | 1 | 0 | 1 |
| Rengar:1:standard:caps256 | 1 | 256 | 1 |
| Zac:0:standard:caps0 | 1 | 0 | 1 |
| Zac:0:standard:caps256 | 1 | 256 | 1 |
| Zac:1:standard:caps0 | 1 | 0 | 1 |
| Zac:1:standard:caps256 | 1 | 256 | 1 |
| Kalista:1:diagnostic_selector0:caps0 | 0 | 0 | 1 |
| Kalista:1:diagnostic_selector0:caps256 | 0 | 256 | 1 |
| Kalista:1:diagnostic_selector2:caps0 | 2 | 0 | 10 |
| Kalista:1:diagnostic_selector2:caps256 | 2 | 256 | 1 |
| Kalista:1:diagnostic_selector10:caps0 | 10 | 0 | 10 |
| Kalista:1:diagnostic_selector10:caps256 | 10 | 256 | 1 |
| invalid_bytes | 1 | 0 | avant diagnostic |
| truncated_header | 1 | 0 | avant diagnostic |

La méthode virtuelle60h appartient à une interface encore non identifiée : son corps n’est pas exécuté, aucune texture native n’est renvoyée, aucun upload natif ou teardown graphique n’est accepté. Les deux HRESULT négatifs s’arrêtent avant la recherche de diagnostic44DCEC ; le chemin complet d’erreur/rollback reste ouvert.

## Portée de l’écart Kalista

La capture dans le caller9BB3D0 utilise bien une borne0, au lieu de la borne de longueur fournie au constructeur isolé V688. Elle produit la même table relative :[128, 172608, 216288, 227488, 230208, 230848, 231040, 231072, 231088, 231104, 231120]. La fin231120 diffère toujours de la fin231408 de la formule ceil/fichier, soit288octets sur les niveaux supérieurs. Ce constat n’est pas effacé.

Cependant, le paramètre de l’écran conduit à une demande de création **1mip** dans ces profils. On ne peut donc pas présenter cette différence des niveaux supérieurs comme preuve de corruption visible de l’écran. Les autres consommateurs multi-mips et le backend réel restent à qualifier. Aucun DDS ou calcul de production n’est modifié par hypothèse.

Autre limite désormais précise : le profil natif sans catégorie demande512×1024 après normalisation, tandis que l’Image/transport actuel utilise308×560. Les octets transférés ne prouvent pas l’équivalence des UV, du padding, de l’échantillonnage ou du rendu. Le contexteflash et le backend doivent être établis avant une décision d’implémentation.

## Transfert et relecture GPU

Périphérique observé :{'BC_requested': True, 'backend': 'Vulkan', 'device': 9476, 'driver': 'NVIDIA', 'driver_info': '610.88', 'kind': 'adapter', 'name': 'NVIDIA GeForce RTX 3060', 'vendor': 4318, 'window_created': False}. Bibliothèques Bevy→bevy_internal→bevy_render→wgpu sélectionnées par leur chaîne réelle de fingerprints ; trois modulesCPU de production sont recompilés dans une nouvelle sonde, les bibliothèques sont des artefacts de cache identifiés. Les sources vendor actuelles sont relues, non recompilées. La sonde ajouteCOPY_SRC pour permettre les relectures, utilise is_srgb=false et ne crée aucune fenêtre.

Chaque buffer de relecture est débarrassé de son padding de lignes, puis comparé octet par octet à la plage du DDS. Les33buffers, tailles et SHA restent dans la preuve. Le profil file_mips consomme tout le payload ; screen_request_one lit seulement le niveau0 et reste un profil de sonde non raccordé au caller normal.

| Portrait | Profil | Mip | Offset dans DDS | Octets relus identiques |
|---|---|---:|---:|---:|
| Ahri:0 | file_mips | 0 | 128 | 689920 |
| Ahri:0 | screen_request_one | 0 | 128 | 689920 |
| Ahri:1 | file_mips | 0 | 128 | 689920 |
| Ahri:1 | screen_request_one | 0 | 128 | 689920 |
| Braum:0 | file_mips | 0 | 128 | 172480 |
| Braum:0 | screen_request_one | 0 | 128 | 172480 |
| Braum:1 | file_mips | 0 | 128 | 86240 |
| Braum:1 | screen_request_one | 0 | 128 | 86240 |
| Kalista:0 | file_mips | 0 | 128 | 86240 |
| Kalista:0 | screen_request_one | 0 | 128 | 86240 |
| Kalista:1 | file_mips | 0 | 128 | 172480 |
| Kalista:1 | file_mips | 1 | 172608 | 43680 |
| Kalista:1 | file_mips | 2 | 216288 | 11200 |
| Kalista:1 | file_mips | 3 | 227488 | 2880 |
| Kalista:1 | file_mips | 4 | 230368 | 720 |
| Kalista:1 | file_mips | 5 | 231088 | 240 |
| Kalista:1 | file_mips | 6 | 231328 | 32 |
| Kalista:1 | file_mips | 7 | 231360 | 16 |
| Kalista:1 | file_mips | 8 | 231376 | 16 |
| Kalista:1 | file_mips | 9 | 231392 | 16 |
| Kalista:1 | screen_request_one | 0 | 128 | 172480 |
| Lulu:0 | file_mips | 0 | 128 | 689920 |
| Lulu:0 | screen_request_one | 0 | 128 | 689920 |
| Lulu:1 | file_mips | 0 | 128 | 689920 |
| Lulu:1 | screen_request_one | 0 | 128 | 689920 |
| Rengar:0 | file_mips | 0 | 128 | 86240 |
| Rengar:0 | screen_request_one | 0 | 128 | 86240 |
| Rengar:1 | file_mips | 0 | 128 | 689920 |
| Rengar:1 | screen_request_one | 0 | 128 | 689920 |
| Zac:0 | file_mips | 0 | 128 | 172480 |
| Zac:0 | screen_request_one | 0 | 128 | 172480 |
| Zac:1 | file_mips | 0 | 128 | 86240 |
| Zac:1 | screen_request_one | 0 | 128 | 86240 |

Les blocs compressés restent des blocs compressés ; ni décompression visuelle, ni sampler/couleur, framebuffer ou acceptation graphique du jeu ne découle de cette relecture. Les deux nouvelles ancres vendor décrivent create_texture_with_data et prepare_asset. Elles restent entry_boundary_only et provides_feature_consumer=false : le symbole en cache du premier est exercé, pas une compilation fraîche du vendor ou une exécution du pipeline prepare_asset complet.

## Intégration et contrôles

SYS-17.3-01 et SYS-01.2-02 reçoivent13liens natifs,51sources et deux ancrages partiels. Le graphe comporte99543sources et5613consommateurs ; l’ensemble du catalogue n’est pas rehaché dans ce lot. La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec question/résolution antérieures en historique et une recherche ajoutée, statut toujoursopen. Identités/propriétaires/aspects/statuts et toutes les autres inconnues sont conservés :26 189ouvertes,5517résolues antérieures.

Cinq falsifications de preuve sont refusées : mauvais nom de DLL, demande standard changée, octets GPU altérés, écran prétendu exécuté et mauvaise borne native. Cinq altérations du delta documentaire sont refusées ; inversion exacte des quatre documents modifiés, inversion logique SQLite et idempotence sont vérifiées. Les deux bases publiées gardent42 605autres lignes,42 607états et23historiques manuels. Aucun critère ou prérequis n’est levé, aucune case automatiquement cochée.

## Essais arrêtés conservés

Les premiers essais utilisaient la DLL43 avant inspection du nom exact importé39. Deux lecteurs se sont arrêtés sur l’aliasSystem32 ou la casse du chemin final ; un prototype de lecteur contient une faute de syntaxe ; le lecteur suivant refuse correctement l’hypothèse de l’import43. Ces résultats ne qualifient pas l’import original. Le helper générique déjà compilé est ensuite exécuté avec39, son identité et ses résultats vérifiés.

La première compilation GPU utilise une ancienne forme de l’API de portée d’erreur ; wgpu29demande un ErrorScopeGuard. Une version distincte corrigée compile et exécute les transferts. Programmes, journaux et reçus arrêtés sont conservés ; aucune réussite n’est inventée à partir d’un processus vivant ou d’un code non nul.

| Étape | Code attendu pour l’observation | Code reçu | SHA256 journal |
|---|---:|---:|---|
| V689_D3DX_INFO | 2 | 2 | 0a020a30a91aea6c9ca1c58bdc1c14a590099735ed6f2fbac79e7bec64fe09c3 |
| V689_D3DX_INFO_MODULE | 2 | 2 | 6bc85b3221b4588429c8787183ad4b48d08d6eaee47d8d6eb7bb77d5e38efbfd |
| V689_D3DX_INFO_VERIFIED | 1 | 1 | c53c0bd2abce4564a0b195f92c245d94ff6649ea6aca9fd288aae94acfde8c65 |
| V689_D3DX_INFO_VERIFIED_CHECKED | 1 | 1 | a0bd8029be34587ec942bab82b9640e162a7d82a9c3771519a1436f4d4c02052 |
| V689_ORIGINAL_IMPORT_METADATA | 0 | 0 | 0b70592d49f6488f8ba8431f55fc1b895050c1ea65a1010cf1162b30094defea |
| V689_NATIVE_TEXTURE_REQUESTS | 0 | 0 | 6b5aff6f57c4bbd0b5407cbd2ba253d3b47344b43ab07fb4542257bf1b3cb7fb |
| V689_KALISTA_MIP_FRAME | 0 | 0 | dd59cc006303773eadb241b8ae2287f9d751b67e2e7c342147af130e52c81f4d |
| V689_PORTRAIT_GPU | 2 | 2 | 70b0cbd736bf99d1e32b1e58352e7f9f905370ff3f5bd374438c665acd305713 |
| V689_PORTRAIT_GPU_SCOPED | 0 | 0 | 9300a75123e9ddf02eb077362e36385f72e698e67f463475613f977ff915f2ea |
| V689_STORAGE | 0 | 0 | 5984101567398d17cfe13c293ef9448c333c543bb7ec1a0bca55dfb536f92f5b |
| V689_ASSOCIATIONS | 0 | 0 | f93f0852bdac4acb203020f604c3ca6a057e2c92179424fcb918d2e1e228e3bc |
| V689_PREPARE | 0 | 0 | f2d821cb8cb20fd9f611ebf9125187eed33ef5383c5a98750ea110299253d93c |
| V689_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V689_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V689_DELIVERY_AUDIT | 0 | 0 | d12bf41a649070979e450513e01fc889cff70cf03e30036b530452a4a06291b3 |

Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision689_original_import_metadata\OBSERVATIONS.json,F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision689_native_texture_requests\OBSERVATIONS.json,F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision689_kalista_native_mip_frame\OBSERVATIONS.json,F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision689_portrait_gpu_scoped\OBSERVATIONS.json. Lecteur d’associations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision689_route_associations\OBSERVATIONS.json. Copies durables, byte-identiques aux deux exécutables réellement mesurés :[{'actual_executed_binary': {'path': 'C:\\Users\\loicd\\AppData\\Local\\Temp\\openleague-v689-gpu-qfz6sph7\\portrait_gpu_probe.exe', 'bytes': 51175936, 'sha256': 'fd9063a6aaf24614470228f45e3fc82381c07fc50de8daebac937603fb9bcc96'}, 'copy': {'path': 'F:\\OpenLeague-work\\Requirements_registry_4_20_2026-10-20\\revision689_portrait_gpu_scoped\\portrait_gpu_probe.exe', 'bytes': 51175936, 'sha256': 'fd9063a6aaf24614470228f45e3fc82381c07fc50de8daebac937603fb9bcc96'}, 'exact_same_bytes': True, 'copy_not_executed': True}, {'actual_executed_binary': {'path': 'C:\\Users\\loicd\\AppData\\Local\\Temp\\openleague-v689-info-vqspmdtg\\d3dx_info_probe.exe', 'bytes': 172544, 'sha256': '44c4d17da8c80bb265e384aed383a7e4f33a76c7ecd3385afe0c6693359e194c'}, 'copy': {'path': 'F:\\OpenLeague-work\\Requirements_registry_4_20_2026-10-20\\revision689_original_import_metadata\\d3dx_info_probe.exe', 'bytes': 172544, 'sha256': '44c4d17da8c80bb265e384aed383a7e4f33a76c7ecd3385afe0c6693359e194c'}, 'exact_same_bytes': True, 'copy_not_executed': True}]. EXE natif :{'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}.

Trois snapshots SQLite fermés de V688, un ancien rapport fermé et les deux copies de binaire sont compressés sans perte ni suppression :958263197octets alloués récupérés. Les bases actives et DDS originaux restent intacts.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-GPU-route-v689.json ; preuvedocs/fidelity_native_portrait_GPU_route_v689.json, ce rapport, deux bases locales et documents coverage/completion_plan/resume_checkpoint/CURRENT/HANDOFF. Aucun code moteur ou asset de production modifié. Le caller normal conserve ses erreurs ; les12noms de ressources antérieurs restent non résolus.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V689 publié/audité : sourcecaller1mip, import réel d3dx9_39,12métadonnées/2refus enhelperx86 local ;32contextes natifs et capture Kalista,24transfertsGPU/33mips relus exactement. Lire le rapport et réutiliser ces preuves sans rejouer les cas ou le bootstrap sans motif nouveau. Le profil natif utilise une catégorie courante nulle et deux mots de capacité déclarés ; il s’arrête avant la méthode virtuelle60h, dont l’interface/backend et le résultat ne sont pas qualifiés. Il demande512x1024 et1mip pour le paramètre Standard, tandis que le transportVulkan actuel travaille308x560 ; le profil screen_request_one est une sonde, pas un raccordement au caller. Suite : identifier la production/vtable du device renderer2D79078+14 et les implémentations60h/F0h, suivre la copie/padding et les UV jusqu’au backend réel après9BB3D0, puis comparer le chemin prepare_asset/chargement normal actuel et son état couleur/sampler/lifecycle. Vérifier le contexteflash effectif avant de conclure sur les dimensions. La table Kalista avec borne0 confirme l’écart supérieur288octets, mais les demandes observées1mip ne permettent pas d’en déduire une corruption de l’écran ; conserver le DDS et les consommateurs multi-mips. La DLL locale39 est identifiée, pas son hash historique. Deux ancrages vendor sont source-only avec bibliothèques en cache identifiées, aucune recompilation vendor globale ou comparaison framebuffer. Question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 précisée, toujours ouverte ; autres inconnues/statuts,12noms antérieurs, cases et historiques conservés. Aucun écran complet ou jeu accepté ; goal actif.
