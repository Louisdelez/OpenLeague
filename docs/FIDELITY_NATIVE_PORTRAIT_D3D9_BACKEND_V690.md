# SYS-01.2-02 — Pont D3D9 natif des portraits, V690

UTC : 2026-10-27T19:58:20.012125+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Cette étape enrichit les liens source/consommateur ; elle ne termine pas le chargement ou le jeu.

## Résultat observé

Le parcours original des portraits dépasse désormais la frontière virtuelle de V689 : sous backend D3D9 déclaré, les wrappers natifs de capacités et de création s’exécutent jusqu’à **IDirect3DDevice9::CreateTexture**. Sur 32 contextes, 30 atteignent cette frontière COM : 24 standard, six diagnostics. Les deux autres s’arrêtent avant le diagnostic natif des métadonnées invalides.

Les 24 demandes standard transmettent 512 × 1024, un mip, usage 0 et pool MANAGED 1. Le format reste propre à chaque DDS. Aucune texture COM n’est retournée par cette sonde, aucun pixel natif n’est transféré ou rendu.

## Source et contrat API

EXE original identifié : {'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}. Les octets des instructions exécutées sont comparés au PE. Le fragment 9C14A3 publie la table 10E2F30, dont le slot F0 mène à 9C3A40 et le slot 60 à 9C2D40. La publication du fragment ne constitue pas une exécution du constructeur complet ou une preuve de sélection historique du backend.

Le chemin F0 exécute 9C3A40 → 9C77C0 → 9C4750. Le chemin de création exécute 9C2D40 → 9C6070 → frontière COM 5C. Le SDK local 10.0.26100.0 identifie l’ordre des méthodes (GetDeviceCaps 1C, CreateTexture 5C), les formats et le pool. C’est un contrat API local identifié, **pas une DLL ou un matériel de 2014**.

| Adresse | Octets | Instruction contrôlée |
|---|---|---|
| 0x9c14a3 | c703302f0e01 | mov dword ptr [ebx], 0x10e2f30 |
| 0x9bb247 | ff5260 | call dword ptr [edx + 0x60] |
| 0x9bb2ed | ff90f0000000 | call dword ptr [eax + 0xf0] |
| 0x9c3a65 | e8563d0000 | call 0x9c77c0 |
| 0x9c3a70 | e8db0c0000 | call 0x9c4750 |
| 0x9c77ed | ff501c | call dword ptr [eax + 0x1c] |
| 0x9c47d3 | 8b4e0c | mov ecx, dword ptr [esi + 0xc] |
| 0x9c47ff | 89421c | mov dword ptr [edx + 0x1c], eax |
| 0x9c2dca | 8b4914 | mov ecx, dword ptr [ecx + 0x14] |
| 0x9c2de6 | e885320000 | call 0x9c6070 |
| 0x9c60be | ff565c | call dword ptr [esi + 0x5c] |

## Contextes déclarés et limites

Les appels COM GetDeviceCaps reçoivent deux structures déclarées de 304 octets, Caps2 = 0 ou 100h et limites de texture 8192. Trente retours de cette frontière sont réellement traduits par le code natif ; ils ne proviennent ni du GPU actuel ni d’un périphérique historique. Le convertisseur reprend les bits bruts selon les paires [[536870912, 536870912], [2, 2], [256, 256]]. Aucun nom sémantique non vérifié n’est attribué au bit 100h.

Le gestionnaire de catégorie reste emprunté, avec current=null. Le contexte flash effectif et le bootstrap ne sont pas exécutés. Allocation, libération et cookie de sécurité restent des feuilles adaptées. Les métadonnées proviennent des résultats du helper x86 d3dx9_39 mesurés en V689 ; cette API n’est pas rejouée ici. Son hash historique demeure inconnu.

Les wrappers natifs vont jusqu’à l’appel COM, dont le corps n’est pas exécuté : pas de HRESULT de création, de wrapper de ressource retourné, d’upload, de pixels copiés, de teardown ou d’acceptation graphique. Les deux métadonnées négatives s’arrêtent toujours avant la recherche de diagnostic ; leur retour complet n’est pas qualifié.

## Formats : attente trop générale corrigée

Le premier essai supposait que tous les DDS conduisaient à ARGB8 : 20 assertions échouent et 12 contextes passent, code réel 2. Cette attente était trop générale ; elle ne démontre pas un défaut du moteur original. Le programme, les résultats et le journal restent conservés. Une sonde distincte vérifie le format exact de chaque fichier et passe les 32 contextes, code 0.

| Format D3D9 | Valeur | Nombre de portraits | Format actuel observé en V689 |
|---|---:|---:|---|
| D3DFMT_A8R8G8B8 | 21 | 5 | Bgra8Unorm |
| D3DFMT_DXT1 | 827611204 | 4 | Bc1RgbaUnorm |
| D3DFMT_DXT5 | 894720068 | 3 | Bc3RgbaUnorm |

Les familles de format correspondent. La conversion générale de tous les portraits compressés en ARGB8 n’est donc pas observée. Le transport Vulkan V689 utilisait 308 × 560 ; la demande native conditionnelle utilise 512 × 1024. Cette différence reste ouverte : copie, rééchantillonnage, padding et UV ne sont pas qualifiés par la concordance des formats. Les 24 transferts GPU et 33 relectures V689 sont des preuves héritées, pas des exécutions fraîches de ce lot.

| Contexte | Mips demandés | Format natif | Pool | Usage |
|---|---:|---|---:|---:|
| Ahri:0:standard:caps0 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Ahri:0:standard:caps256 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Ahri:1:standard:caps0 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Ahri:1:standard:caps256 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Braum:0:standard:caps0 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Braum:0:standard:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Braum:1:standard:caps0 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Braum:1:standard:caps256 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Kalista:0:standard:caps0 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Kalista:0:standard:caps256 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Kalista:1:standard:caps0 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:standard:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Lulu:0:standard:caps0 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Lulu:0:standard:caps256 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Lulu:1:standard:caps0 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Lulu:1:standard:caps256 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Rengar:0:standard:caps0 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Rengar:0:standard:caps256 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Rengar:1:standard:caps0 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Rengar:1:standard:caps256 | 1 | D3DFMT_A8R8G8B8 | 1 | 0 |
| Zac:0:standard:caps0 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Zac:0:standard:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Zac:1:standard:caps0 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Zac:1:standard:caps256 | 1 | D3DFMT_DXT1 | 1 | 0 |
| Kalista:1:diagnostic_selector0:caps0 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:diagnostic_selector0:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:diagnostic_selector2:caps0 | 10 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:diagnostic_selector2:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:diagnostic_selector10:caps0 | 10 | D3DFMT_DXT5 | 1 | 0 |
| Kalista:1:diagnostic_selector10:caps256 | 1 | D3DFMT_DXT5 | 1 | 0 |

La table Kalista et son écart de 288 octets sur les mips supérieurs restent dans les preuves antérieures. Les demandes standard observées à un mip ne permettent pas d’en déduire une corruption visible du chargement. Aucun DDS n’est modifié.

## Intégration et vérification

SYS-17.3-01 et SYS-01.2-02 reçoivent 13 liens natifs et 17 sources supplémentaires. Les huit consommateurs courants déjà associés sont vérifiés et conservés sans changement ; aucun nouveau consommateur complet ou partiel n’est créé. Le graphe compte 99560 sources et 5613 consommateurs. Le catalogue entier n’est pas rehaché dans cette étape.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée, avec question et condition antérieures en historique et une recherche ajoutée. Elle reste ouverte ; les identités, propriétaires, aspects, statuts et toutes les autres inconnues sont conservés : 26 189 ouvertes, 5517 résolues antérieures.

Cinq falsifications sont refusées : format COM erroné, mip standard modifié, traduction de capacités altérée, mauvais slot API et prétendue instance historique. Cinq altérations documentaires sont également refusées. L’inversion documentaire exacte, le retour logique SQLite et l’idempotence sont vérifiés. Après publication, les deux bases conservent 42 605 autres lignes, 42 607 états manuels et 23 historiques. Aucune case ou exigence n’est promue.

| Étape | Code attendu | Code reçu | SHA-256 du journal |
|---|---:|---:|---|
| V690_NATIVE_BACKEND_REQUESTS | 2 | 2 | f7f89118da7b54fe7e3c6828492fff32e4458094415b9c7e9658c62835005724 |
| V690_NATIVE_BACKEND_REQUESTS_CHECKED | 0 | 0 | 6b5aff6f57c4bbd0b5407cbd2ba253d3b47344b43ab07fb4542257bf1b3cb7fb |
| V690_ASSOCIATIONS | 0 | 0 | a36d38c0fcf29188e2e2a7fee8d7004b30aacc2080fa9e2d2a24158ce5dbe43f |
| V690_STORAGE | 0 | 0 | 8e7aef1781641b3908161bcab16e58760f783dc23d3ebed6b348a08c4ab4befa |
| V690_PREPARE | 0 | 0 | 45ed8c00c4594bc5fd0dd0102f14adcfa7b3e84a8f24e1052f8c1966bbd2557e |
| V690_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V690_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V690_DELIVERY_AUDIT | 0 | 0 | d75dc2758d563b0b5f82d7153fedbf699fa4be6c3b91f1b022b33532d9a2e542 |

Sonde native : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision690_native_backend_requests_checked\OBSERVATIONS.json. Lecteur indépendant : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision690_backend_associations\OBSERVATIONS.json. La preuve FXAA antérieure, native_fxaa_backend_contract.json (6144 cas, trois segments isolés), est relue et reliée comme héritage, sans être rejouée ou présentée comme un backend complet. Aucun nouveau binaire du jeu, Rust ou DLL n’est exécuté : l’EXE original est émulé à partir des octets identifiés.

Six fichiers historiques fermés sont compressés sans perte : 1817515537 octets alloués récupérés, tailles logiques et SHA-256 inchangés. Les bases actives ne sont ni compressées ni supprimées par cette opération.

## Fichiers et écarts ouverts

Documents modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-D3D9-backend-v690.json ; preuve docs/fidelity_native_portrait_D3D9_backend_v690.json ; ce rapport ; deux bases du plan ; coverage.json, completion_plan.json, resume_checkpoint.json et CURRENT/HANDOFF. IDS et ordre des phases/lots restent byte-identiques. Aucun code moteur ni asset de production n’est modifié.

Le caller courant conserve ses refus de continuations UI/provider non fournies. Les 12 noms de ressources antérieurs restent non résolus. Les pixels, l’affichage, le contexte historique et la totalité du jeu demeurent non acceptés.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V690 publié/audité : 32 contextes natifs, 30 frontières COM CreateTexture dont 24 demandes standard 512×1024/1mip. Les wrappers F0/60 originaux s’exécutent sous backend D3D9 déclaré ; 30 retours COM GetDeviceCaps déclarés sont traduits nativement. Formats propres conservés : 5 ARGB8, 4 DXT1, 3 DXT5 ; l’attente initiale de format unique est réfutée et son code2 conservé. Réutiliser ces preuves sans les rejouer sans raison. Suite : qualifier le retour COM et les refus/pertes de périphérique dans 9C6070/9C2D40, le wrapper de texture 10E3270 et le rôle de 9C97C0 ; suivre ensuite 9BB3D0/9B7BB0 pour la copie/rééchantillonnage/padding et les UV entre 308×560 et 512×1024. La sélection/instance effective du backend et le contexteflash restent ouverts ; les candidats de producteur 960740→9819E0 et le fragment de publication 9C14A3 ne prouvent pas le bootstrap complet. Lire aussi revision690_backend_discovery/DISCOVERY.json et réutiliser la preuve FXAA antérieure, sans la présenter comme fraîche. Le bit brut Caps2=100h n’a pas de nom sémantique qualifié. Raccorder et comparer le caller normal actuel, couleur/sampler et nettoyage ; aucune acceptation d’écran ou de jeu. Le GPU Vulkan et les métadonnées39 V689 sont hérités, non rejoués. Question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 précisée et toujours ouverte ; conserver Kalista288octets,12noms antérieurs, autres inconnues, cases et historiques. Goal actif.
