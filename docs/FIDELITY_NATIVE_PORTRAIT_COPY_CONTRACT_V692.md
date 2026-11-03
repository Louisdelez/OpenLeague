# SYS-01.2-02 — Copie CPU native et paramètres D3DX, V692

UTC : 2026-10-27T21:18:02.284977+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Cette étape enrichit les liens source/consommateur ; elle ne termine pas le chargement ou le jeu.

## Résultat observé

Les douze DDS passent par **9BB110 → 9B6C10 → 9BB190**, puis les wrappers de surface jusqu’à l’import d3dx9_39!D3DXLoadSurfaceFromMemory, IAT FA47FC. Le corps de cette API n’est pas exécuté.

Une copie intermédiaire CPU est bien parcourue : **12 tampons, 4 312 000 octets**, identiques octet par octet au niveau0 de chaque DDS, à partir de son offset128. Les DDS originaux et la garde mémoire restent inchangés. Les douze captures binaires sont conservées et relues indépendamment.

| Portrait | Format source | Pitch, octets | Octets du tampon CPU identiques | SHA-256 tampon |
|---|---:|---:|---:|---|
| Ahri:0 | 21 | 1232 | 689920 | caf6adf65e951defdfa02a788113a9ba3ad4cc9dfa70fc13ddde93fb44f6f8df |
| Ahri:1 | 21 | 1232 | 689920 | ebdd07b7e39752df4e2c2ae203d5c8ac5414aa0f4b9e4dcf53f376d0bb0530ff |
| Braum:0 | 894720068 | 1232 | 172480 | 418fd3928d04cc445210e32f78f3a2c7c5db698b309753fef86798fe3c44ccda |
| Braum:1 | 827611204 | 616 | 86240 | f0f045773085d95e13e70698df4dd534a0afd814921f54615439b02bcc775abc |
| Kalista:0 | 827611204 | 616 | 86240 | cac8c9b992d22894d00844719fc87a8a3da73d16b533730f6094ecb759e86045 |
| Kalista:1 | 894720068 | 1232 | 172480 | 165d1aceafc41008a165780eebc39a18bc29deeda1f14406af940b0c7ace9bb1 |
| Lulu:0 | 21 | 1232 | 689920 | d713c6594ccaa3132b622b165e7dfda3e2926cf499b9e8ec940c0ce405d40ca4 |
| Lulu:1 | 21 | 1232 | 689920 | a1522a6783d886a0ded42b1b12aaeebcaaedf97e140948d66ded55a75319c784 |
| Rengar:0 | 827611204 | 616 | 86240 | 27bbf5fe08287e50c5e3255991906b59fd7ab4093996a996494fa2aecde941b1 |
| Rengar:1 | 21 | 1232 | 689920 | d53492a79998bf9db9a37e51b21eca773ad9da3dfa7a73790093134ea744f054 |
| Zac:0 | 894720068 | 1232 | 172480 | 58ec14b2b691d5fbef6da6359ac57ba63d8db79d81402ac8473b9bf322befd46 |
| Zac:1 | 827611204 | 616 | 86240 | 8f0674a4d9b4abfd14ca198416ae81b62be1408c6a956327cb84e212d643f7e3 |

Les formats sont ceux des sources :5ARGB8,4DXT1,3DXT5. Les octets de blocs compressés restent des blocs compressés ; ce constat n’est pas une mesure de pixels décodés ou d’affichage.

## Paramètres capturés et interprétation limitée

Pour chaque niveau0, les dix arguments donnent : sourceRect [0,0,308,560], destinationRect NULL, format source propre au fichier, pitch616 pourDXT1 ou1232 pourARGB8/DXT5, palettes nulles, Filter3, ColorKey0. La surface déclarée par les adaptateurs COM décrit512×1024, conformément aux arguments de création natifs. Le pointeur source appartient au tampon CPU possédé ; il ne pointe pas directement dans le DDS.

Le [contrat Microsoft de la fonction](https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dxloadsurfacefrommemory) interprète un rectangle destination nul comme toute la surface et le pitch comme des octets par ligne, y compris les lignes de blocs DXT. Le header identifié définit3 comme [D3DX_FILTER_LINEAR](https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dx-filter). **On en déduit une demande de rééchantillonnage linéaire vers la surface déclarée ; le résultat de cette demande n’est pas observé.**

Cette distinction remplace une interprétation de simple padding fondée sur les seules dimensions. Les coordonnées UV et le rendu normal restent ouverts ; aucune texture n’est modifiée à partir de cette demande.

## Sources identifiées

EXE original : {'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}. Les instructions exécutées sont comparées aux octets du PE. Les wrappers de texture et de surface sont natifs ; GetSurfaceLevel et GetDesc reçoivent des objets/descripteurs adaptés. Le SDK Windows local confirme les slots COM48 et30. Les références restantes à la texture/surface sont à1 lors de l’arrêt : ce sont des objets encore vivants, sans qualification de leur nettoyage final.

| Adresse | Octets | Instruction contrôlée |
|---|---|---|
| 0x9bb53d | e8cefbffff | call 0x9bb110 |
| 0x9bb54f | e8bcb6ffff | call 0x9b6c10 |
| 0x9bb557 | e834fcffff | call 0x9bb190 |
| 0x9c9364 | e8f7f1ffff | call 0x9c8560 |
| 0x9c859d | ff5648 | call dword ptr [esi + 0x48] |
| 0x9c93ce | c706dc280e01 | mov dword ptr [esi], 0x10e28dc |
| 0x9b7c0e | 833d585c220101 | cmp dword ptr [0x1225c58], 1 |
| 0x9b8732 | ff15fc47fa00 | call dword ptr [0xfa47fc] |
| 0x9b7590 | 890d585c2201 | mov dword ptr [0x1225c58], ecx |

Le mode1225C58 vaut2 dans l’imagePE fournie. Sa valeur active historique, sa signification et les callers du setter9B7590 restent à qualifier. Ce n’est pas une mesure du processus de jeu d’origine.

## Header Microsoft et provenance

Le [paquet Microsoft.DXSDK.D3DX9.29.952.8](https://www.nuget.org/packages/Microsoft.DXSDK.D3DX/9.29.952.8) est identifié par son catalogue officiel : SHA512 et taille comparés au téléchargement, header comparé au membre exact de l’archive. Paquet :{'path': 'F:\\OpenLeague-work\\Requirements_registry_4_20_2026-10-20\\revision692_sdk_contract_catalog\\Microsoft.DXSDK.D3DX.9.29.952.8.nupkg', 'bytes': 9833468, 'sha256': 'ead0906ae8a26c18a7525da7490127a2110f7c58f18293738283e30e97c6ea4b'}. Header :{'path': 'F:\\OpenLeague-work\\Requirements_registry_4_20_2026-10-20\\revision692_sdk_contract_catalog\\d3dx9tex.h', 'bytes': 61840, 'sha256': '64dfa1f26d6df792f6cf261c79f737e6e5c7670787ba6abfe0f76aba348e9422'}. Les réponses de registre/catalogue sont conservées, y compris leur encodagegzip. Les notices disponibles sont archivées.

Il s’agit d’un contrat SDK identifié. Aucune DLL43 n’est extraite, installée ou exécutée ; le runtime local39 n’est pas remplacé. Le SHA512 de catalogue ne constitue pas un audit séparé de signature ou d’authenticité2014. Les pages web sont reliées par URL/date et paraphrase, sans prétendre disposer d’une copie originale hachée.

Le premier récupérateur s’arrête sur HTTP404 à l’ancien endpoint .sha512, code1. La version suivante utilise correctement le hash du catalogue, télécharge et vérifie le paquet, puis s’arrête sur le nom d’encodage invalide utf8-sig, code1. Un lecteur distinct réutilise ces fichiers, lit utf-8-sig et confirme le header/signature10paramètres, code0. Les programmes, reçus et fichiers intermédiaires sont conservés.

## Corrections de portée conservant les preuves

Le premier parcours V692 atteignait déjà l’import, mais ne capturait pas son tampon. Sa formulation « aucun pixel copié » était trop large : la copieCPU est maintenant vérifiée ; le corps API et le transfertGPU restent non exécutés. L’observation initiale est conservée et sa portée précisée par cette preuve.

Le point de reprise V691 proposait la piste9BB600. Ce n’est pas le parcours observé des douze profils actuels : les adresses9BB110,9B6C10,9BB190 sont exécutées et9BB600 ne l’est pas. Les conditions et autres variantes de cette branche ne sont pas présentées comme résolues. Les retours25textures nulles/AL1 V691, formats V690, métadonnées/GPU V689 et écart Kalista288octets restent des preuves héritées, non rejouées ici.

## Intégration et contrôles

SYS-17.3-01 et SYS-01.2-02 reçoivent 13 liens natifs et 37 sources. Les huit consommateurs antérieurs sont revérifiés et inchangés ; aucun nouveau consommateur de fonctionnalité n’est créé. Le graphe compte 99609 sources et5613consommateurs ; il ne s’agit pas d’un rehachage complet du catalogue.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec son texte/condition antérieurs en historique et une recherche ajoutée ; elle reste ouverte. Identités, propriétaires, aspects, statuts et autres inconnues sont conservés :26 189ouvertes,5517résolues antérieures.

Cinq falsifications sont refusées : pitch altéré, rectangle destination inventé, tamponCPU modifié, constante de filtre changée et prétendue exécution de l’API. Cinq altérations documentaires sont refusées. Inversion documentaire exacte, inversion logique SQLite et idempotence sont vérifiées. Les deux bases publiées conservent42 605autres lignes,42 607états manuels et23historiques. Aucun prérequis ou critère n’est levé, aucune case cochée automatiquement.

| Étape | Code attendu | Code reçu | SHA-256 journal |
|---|---:|---:|---|
| V692_NATIVE_COPY_BOUNDARY | 0 | 0 | 8d3a0de69af9114ac5ee6b4e8771316c6995ccb2cb0d4aae57597719774ce409 |
| V692_NATIVE_COPY_PAYLOAD | 0 | 0 | 8d3a0de69af9114ac5ee6b4e8771316c6995ccb2cb0d4aae57597719774ce409 |
| V692_SDK_CONTRACT | 1 | 1 | 3ae4b492c88c91af5f00c6f1f026aa458de1c84ed15c68b8a44cfe062f162138 |
| V692_SDK_CONTRACT_CATALOG | 1 | 1 | d10c2b2971ac5eca753e7ddaeaf1da127564b792e43329d24b479392b6117b24 |
| V692_SDK_HEADER_CHECKED | 0 | 0 | 9271d46616db0e1c998ffb81a5afc5a779e981b98d22770f65a654080f00d606 |
| V692_ASSOCIATIONS | 0 | 0 | 3dc2fbe4c1a93961c2b2db9ddd177753b34703532a069791182f667ab8e23138 |
| V692_STORAGE | 0 | 0 | fd55673310f834722a04ae3aec22df894d683fd1c6a7c4995fa496123e1fda65 |
| V692_PREPARE | 1 | 1 | 838e397b3fd46a446619750a73a18f62f6d5156f0fe8bbee92e12ab24e9a3898 |
| V692_STORAGE_RESERVE | 0 | 0 | 6ae419cba4863501b6070b5a6756f8e83334e4fc280076acb4004c1539af8146 |
| V692_PREPARE_RESERVE | 0 | 0 | 974ecf85fe8afd97f95d0103d826e8e1d76e412b7b262ca6d68f4fa9ece2b941 |
| V692_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V692_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V692_DELIVERY_AUDIT | 0 | 0 | cc73bf3c6bc68c7651e2b12f00af012907f30e50c9321ef636b3dc8975361bf3 |

Le premier preflight d’espace arrête la préparation avant création du candidat, code1. La réserve est ensuite satisfaite par compression sans perte d’une sauvegarde fermée ; le programme inchangé est repris avec un reçu distinct. Au total sept fichiers historiques fermés sont compressés :1711234934octets alloués récupérés, tailles logiques et SHA-256 inchangés. Les sidecars de la sauvegarde supplémentaire sont aussi vérifiés. Aucun fichier n’est supprimé et les bases actives ne sont pas compressées.

## Fichiers et limites restantes

Documents modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-copy-contract-v692.json ; preuve docs/fidelity_native_portrait_copy_contract_v692.json ; ce rapport ; deux bases locales ; coverage.json, completion_plan.json, resume_checkpoint.json et CURRENT/HANDOFF. IDS et phases/lots restent byte-identiques. Outils, archives et captures sont conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun code moteur ou asset de production n’est modifié.

Observations natives :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision692_native_copy_payload\OBSERVATIONS.json. Contrat SDK :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision692_sdk_header_checked\OBSERVATIONS.json. Lecteur indépendant :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision692_copy_associations\OBSERVATIONS.json. Le PE est émulé avec backend/catégorie/CRT/COM déclarés ; aucun processus historique ou nouvel appelGPU réel n’est exécuté. Le corps D3DX, ses refus, les sorties après filtrage/compression, les UV/couleur/sampler, le mode/bootstrap effectif, le nettoyage nominal et le caller normal restent ouverts. Les12noms de ressources antérieurs demeurent non résolus. Aucun écran ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V692 publié/audité :12parcours via9BB110→9B6C10→9BB190 et wrappers de surface,12tamponsCPU/4 312 000octets identiques au niveau0DDS ; arguments capturés à d3dx9_39!D3DXLoadSurfaceFromMemory avant son corps. SourceRect308x560,pitch616DXT1 ou1232ARGB8/DXT5,destinationRectNULL,surface déclarée512x1024,filter3=LINEAR,ColorKey0. Le SDK officiel vérifié est un contratAPI, pas le runtime historique ; aucuneDLL43installée/exécutée. Le mode2 est la valeur initialePE, sa signification/sélection historique reste ouverte. Réutiliser ces preuves sans les rejouer sans raison. Suite : qualifier le résultat de cet appel et ses refus/cleanup avec le runtime local x86d3dx9_39 identifié, sur une surface locale correctement identifiée ; convertir les paramètres capturés en objets/adresses hôte valides, jamais passer les pointeursUnicorn à une vraieAPI. Capturer les sorties après filtrage/compression et comparer au transport actuel ; suivre ensuite la publication des UV/couleur/sampler et le caller normal. Établir aussi les callers du setter9B7590 et le contexteflash/backend effectif. La piste9BB600 du point de reprise est remplacée pour ces12profils par le chemin observé ; sa condition et autres variantes restent ouvertes. La première formulation no-pixel-copy était trop large : copieCPU vérifiée, seuleAPI/GPU non exécutée. Préserver les deux essaisSDK arrêtés404/encodage, préflight espace code1, retoursV691,formatsV690,GPU/métadonnéesV689 hérités,écartKalista288octets,12noms antérieurs,cases et historiques. Question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 précisée et ouverte. Goal actif ; aucun écran ou jeu accepté.
