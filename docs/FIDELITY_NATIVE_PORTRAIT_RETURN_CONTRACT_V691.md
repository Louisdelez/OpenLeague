# SYS-01.2-02 — Retours natifs, pointeur de texture et nettoyage, V691

UTC : 2026-10-27T20:25:57.957760+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Cette étape enrichit la traçabilité source/consommateur ; elle ne termine pas le chargement ou le jeu.

## Résultat vérifié

Le parcours original est exécuté dans **53 contextes déclarés**. Le résultat du chargeur est distinct du pointeur de texture, du statut TLS et de la propriété des allocations. Les 25 retours complets observés publient une texture nulle tout en renvoyant **AL = 1**. Ce booléen seul ne garantit donc pas une ressource graphique disponible.

| Contexte et quantité | Attendu dans le contexte déclaré | Observé |
|---|---|---|
| Succès COM adapté, 14 | Wrapper natif 10E3270 propriétaire du handle fourni ; arrêt avant pixels | 14 wrappers, référence brute 1, AddRef/Release et métadonnées traversés |
| Device lost adapté, 13 | Retour nul, branche native sans copie, statut et nettoyage mesurés séparément | AL1, texture8C=0, TLS0, aucune allocation/référence déclarée restante |
| Refus de l’allocation du wrapper, 12 | CreateTexture adapté S_OK puis allocation20octets refusée ; retour nul et nettoyage | AL1, texture8C=0, TLS1, aucune allocation/référence déclarée restante |
| Mémoire vidéo indisponible adaptée, 12 | Atteindre le diagnostic natif distinct de device lost | Arrêt à9C60F5 avant recherche de diagnostic ; pas de retour complet qualifié |
| Métadonnées invalides, 2 | Arrêt avant le diagnostic natif | Arrêt à9B2A8A ; pas de création ou retour complet qualifié |

Les douze DDS sont chacun exercés avec les quatre premiers profils. Trois contrôles supplémentaires concernent Kalista1 : sélecteur10 avec succès/perte de périphérique, puis succès avec Caps2=100h. Les deux métadonnées invalides complètent les 53 contextes. Les attentes et observations précises par cas se trouvent dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision691_native_returns_checked\OBSERVATIONS.json et F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision691_return_associations\OBSERVATIONS.json.

## Sources et contrat exact

EXE original identifié : {'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}. Les octets des instructions exécutées sont comparés au PE. Le code natif 9C6070/9C2D40 traite les résultats COM déclarés. Le pointeur nul traverse 9BB4F3 → 9BB764, puis 989500 publie le champ8C et renvoie AL1. Le statut TLS observé au retour complet est0 pour les13device_lost et1 pour les12refus d’allocation-wrapper.

| Adresse | Octets | Instruction contrôlée |
|---|---|---|
| 0xc975f5 | 3b0dd02e2201 | cmp ecx, dword ptr [0x1222ed0] |
| 0xc975fd | f3c3 | repz ret  |
| 0x9c60cb | 81fe68087688 | cmp esi, 0x88760868 |
| 0x9c60d1 | 0f848c000000 | je 0x9c6163 |
| 0x9c2e62 | ff5004 | call dword ptr [eax + 4] |
| 0x9c2e6c | e84f690000 | call 0x9c97c0 |
| 0x9c2e84 | ff5108 | call dword ptr [ecx + 8] |
| 0x9c2e8a | 8930 | mov dword ptr [eax], esi |
| 0x9c2ea8 | c7400400000000 | mov dword ptr [eax + 4], 0 |
| 0x9bb4f3 | 85ff | test edi, edi |
| 0x9bb4f5 | 0f8469020000 | je 0x9bb764 |
| 0x9bb76b | 8938 | mov dword ptr [eax], edi |
| 0x989624 | 898e8c000000 | mov dword ptr [esi + 0x8c], ecx |
| 0x989682 | b001 | mov al, 1 |

Le SDK local identifie DEVICELOST=MAKE_D3DHRESULT(2152) et OUTOFVIDEOMEMORY=MAKE_D3DHRESULT(380). Il fournit un contrat API identifié, pas une identité de runtime2014. Les formats propres aux12portraits, établis en V690, restent conservés :5ARGB8,4DXT1,3DXT5.

## Entrées adaptées et portée

COM CreateTexture, GetDeviceCaps, AddRef, Release, GetLevelCount et GetLevelDesc sont des frontières adaptées. Les succès fournissent un objet COM simulé et des descripteurs explicites issus des arguments natifs. Les wrappers originaux exécutent14AddRef,26Release,14GetLevelCount et23GetLevelDesc sous ces entrées. Le chemin9C97C0 est traversé, y compris son branchement indirect et ses getters, sans le renommer « inscription » ou mesure de VRAM réelle.

L’objet natif nominal est construit et reste vivant à l’arrêt ; ses allocations actives ne sont pas présentées comme des fuites ou un nettoyage complet. **Aucun appel GPU réel, pixel copié, échantillonné ou rendu** n’est exécuté. Les capacités, la catégorie current=null, les résultats COM et l’allocateur sont déclarés ; le bootstrap historique et l’instance effective restent ouverts. Les métadonnées d3dx9_39 et transferts Vulkan V689 sont hérités, non rejoués.

La mémoire de sonde est portée à16MiB, avec pool séparé40800000..41000000, pile40300000 et garde407FF000. Les allocations sont bornées à4MiB et ne chevauchent ni la pile, ni les fixtures, ni les allocations encore possédées. Les53cas gardent les octets des DDS et la garde mémoire intacts. Le profil de CRT initialisé est explicite : flag2D77B20=1, custom14BEF58/14BEF40=0 ; son initialisation complète n’est pas exécutée. Les allocations sont zéro-initialisées par l’adaptateur.

## Premier essai conservé et correction de sonde

Le premier essai renvoie le code2 :14frontières de diagnostic passent,39contextes s’arrêtent sur une lecture non mappée. L’adaptateur de cookie mettaitEAX à0 et masquait le HRESULT ; les chemins suivants atteignaient un contexte d’initialisation d’allocateur non fourni. Le CMP/RET original deC975F5 ne modifie pasEAX sur son chemin réussi. Une version distincte préserve ce registre et déclare l’allocateur initialisé ; elle passe53/53, code0. Ce correctif de sonde ne démontre ni défaut du jeu original ni bootstrap complet. L’ancien programme, ses observations et son journal restent intacts.

## Intégration et contrôles

SYS-17.3-01 et SYS-01.2-02 reçoivent 13 liens natifs et 12 sources. Les huit consommateurs antérieurs sont revérifiés et conservés ; aucun consommateur complet ou partiel n’est ajouté. Le graphe comporte 99572 sources et5613consommateurs. Le catalogue entier n’est pas rehaché dans ce lot.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec question/condition précédentes en historique et une recherche ajoutée. Elle reste ouverte ; identités, propriétaires, aspects, statuts et autres inconnues sont conservés :26 189ouvertes,5517résolues antérieures.

Cinq falsifications sont refusées : AL altéré, texture nulle promue en pointeur, allocation restante inventée, TLSdevice_lost modifié et prétendue exécution GPU. Cinq altérations documentaires sont refusées ; inversion documentaire exacte, inversion logique SQLite et idempotence sont vérifiées. Après publication, les deux bases conservent42 605autres lignes,42 607états manuels et23historiques. Aucun prérequis ou critère n’est levé, aucune case cochée automatiquement.

| Étape | Code attendu | Code reçu | SHA-256 journal |
|---|---:|---:|---|
| V691_NATIVE_RETURNS | 2 | 2 | ffe056f688f5b147ff8f8a659ad08cc8e657fc8150aabece030890bbe1fb8030 |
| V691_NATIVE_RETURNS_CHECKED | 0 | 0 | aed49e1207d416686f5c83f0eb66abebcf23f5aa961b577681697b9a9c1af1f5 |
| V691_ASSOCIATIONS | 0 | 0 | 7200085aa327843003a065062f8cf73564fb750298806b12cee5b081b4c4e17b |
| V691_STORAGE | 0 | 0 | 07c05496af177e8ea8253e8eef5e9e420e1212f24379dcabd015823e5ca461b2 |
| V691_PREPARE | 0 | 0 | 401516f4da89652feb1fb753d630251d8a58101cd4f8e827f06d216049ebe9c3 |
| V691_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V691_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V691_DELIVERY_AUDIT | 0 | 0 | 3e08b4bc6dc011e1291e2e156cc153948800580d2acc4f3f8a16df4579176b2a |

Cinq fichiers historiques fermés sont compressés sans perte : 1391749542 octets alloués récupérés, tailles logiques et SHA-256 inchangés. Les bases actives ne sont pas compressées ou supprimées par cette opération.

## Fichiers modifiés et limites restantes

Documents : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-return-contract-v691.json ; preuve docs/fidelity_native_portrait_return_contract_v691.json ; ce rapport ; deux bases locales ; coverage.json, completion_plan.json, resume_checkpoint.json et CURRENT/HANDOFF. IDS et ordre des phases/lots restent byte-identiques. Les outils et observations détaillés sont conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun code moteur ou asset de production n’est modifié, aucun nouveau binaire du jeu/Rust/DLL n’est exécuté : les octets identifiés du PE sont émulés.

Les diagnostics complets, copie/rééchantillonnage/padding, UV, objets GPU réels, couleur/sampler, montage/backend/catégorieflash effectifs et caller normal demeurent ouverts. Les refus UI/provider courants, les12noms antérieurs et l’écart Kalista288octets sont conservés. Ni disponibilité graphique, ni écran normal ou totalité du jeu ne sont acceptés à partir de ces retours.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V691 publié/audité : 53 contextes natifs, 14 wrappers nominaux arrêtés avant copie, 25 retours complets989500 avec texture nulle et AL1 (13device_lost/TLS0,12refus20octets/TLS1), allocations et références déclarées libérées ;12erreurs vidéo et2métadonnées restent avant diagnostic complet. Le booléen du chargeur ne prouve pas la texture prête. Réutiliser ces preuves sans les rejouer sans motif nouveau. Suite : suivre la copie après9BB4F0, notamment la branche9BB600 due aux dimensions et9B7BB0/D3DXLoadSurfaceFromMemory, identifier les rectangles/pitch/format/padding et la publication des UV. Conserver la séparation des retours, du pointeur et du TLS ; qualifier aussi les diagnostics complets et le nettoyage du wrapper nominal. La sonde utilise pool16MiB séparé, allocateur CRT initialisé déclaré et feuille cookie préservant EAX ; COM et descripteurs adaptés, aucun GPU réel ou bootstrap historique. Le rôle de9C97C0 ne devient pas une inscription par hypothèse. Retrouver l’instance/backend/catégorieflash effectifs puis le caller normal actuel/couleur/sampler. FormatsV690 et métadonnées/GPUV689 hérités, non rejoués. Conserver le premier essai39arrêts mémoire/code2, écartKalista288octets,12noms antérieurs, autres inconnues, cases et historiques. Question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 précisée et ouverte. Goal actif ; aucun écran ou jeu accepté.
