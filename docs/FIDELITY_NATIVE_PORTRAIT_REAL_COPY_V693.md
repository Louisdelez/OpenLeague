# SYS-01.2-02 — Copies D3DX39 locales réellement exécutées, V693

UTC : 2026-10-27T21:45:36.221835+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Cette preuve relie les ressources natives à un essai réel identifié et aux consommateurs actuels ; elle ne termine pas le chargement ou le jeu.

## Résultat observé

Les douze tampons CPU capturés en V692 sont fournis à **D3DXLoadSurfaceFromMemory dans la DLL39 locale réellement chargée**, avec des pointeurs et objets hôte valides. Aucun pointeur Unicorn n'est transmis à une vraie API. Le banc Rusti686 crée un périphérique D3D9 HAL et une texture MANAGED512×1024, niveau0, usage0, format propre à la source. Il applique sourceRect[0,0,308,560], destinationRectNULL, palettesNULL, pitch616(DXT1)ou1232(ARGB8/DXT5), Filter3 et ColorKey0.

Attendu pour chacun des douze cas : huit HRESULT nominaux exactement0, identité x86 des deux modules, surface conforme, source inchangée, sortie de taille prévue, libération des quatre objets et destruction de la fenêtre cachée. Observé : **12cas réussis,96HRESULT nuls,12sorties relues totalisant13 107 200octets**. Les tampons source totalisent4 312 000octets et restent identiques au niveau0DDS offset128. Formats conservés :5ARGB8,4DXT1,3DXT5. Les DDS et le code moteur restent inchangés.

| Portrait | Format | Pitch réel, octets | Octets relus, lignes utiles | SHA-256 sortie |
|---|---:|---:|---:|---|
| Ahri:0 | 21 | 2048 | 2097152 | 91b87b252bbcaf3b89f7bf30ea17f42e8652f1869a297451f4ca385ef4c0af88 |
| Ahri:1 | 21 | 2048 | 2097152 | 07690eb534a36ed83139d9640f7f7c8cbc4ca055d517ab817e308f42b0586e39 |
| Braum:0 | 894720068 | 2048 | 524288 | e1793488bfff140c24da60aea4ba59082ca5db0b5dd3ef824d5eb0a9f04fffa9 |
| Braum:1 | 827611204 | 1024 | 262144 | afbf37e9fd2f141dc3ccbce2f74760a8264652082654309507e505f7cd336b42 |
| Kalista:0 | 827611204 | 1024 | 262144 | a88ec9c69f187129252f9c27ad9404963c4762a40ad3b515c66965c95d11b353 |
| Kalista:1 | 894720068 | 2048 | 524288 | cbf3083f965534548330a8673dbab4295c242d8f4db6ebb4c56d798e843c9969 |
| Lulu:0 | 21 | 2048 | 2097152 | 1d72881c94fa474c221d803f1b3abe464c4db166ef1145d374635f1ca2a4664e |
| Lulu:1 | 21 | 2048 | 2097152 | 85d19baac2b1fc4196f563013c28e91c8fb5c4636605e66f74164a1579bfffb2 |
| Rengar:0 | 827611204 | 1024 | 262144 | 051ab4cc7da8dc67f8a0ea3a8300c81687d2e797b98d0176f4b6ede7f5823713 |
| Rengar:1 | 21 | 2048 | 2097152 | 902df55b8304c10a45bba4f209d8123d5ebddd90b4e440c23f1d76d568766617 |
| Zac:0 | 894720068 | 2048 | 524288 | df7793a499618a0d8eada5b4e913805f4805c7bb263ddf7d718eff6a731ab6fc |
| Zac:1 | 827611204 | 1024 | 262144 | e44911fdacf0a849e98727be3219e14d134d6864b31630be5948134ec9f0d92b |

Les sorties DXT sont des blocs compressés. Leur taille et empreinte sont vérifiées ; leur décodage et comparaison indépendante de pixels ne sont pas accomplis ici. Les sorties ARGB8 ont quatre octets BGRA par pixel ; seuls six pixels du premier portrait sont explorés indépendamment dans cette révision.

## Sources, binaire et environnement

EXE natif dont proviennent les captures : {'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}. Le jeu historique n'est pas lancé. Les parcours originaux de V692 sont hérités et ne sont pas rejoués ; cette révision exécute le corps API local à partir de ces captures.

Le binaire Rust et son source, leur compilation i686 et la revue ABI/slots/structures sont conservés dans revision693_real_copy_preparation. Les empreintes préparées sont revérifiées avant exécution. Le premier cas Ahri0 réussit puis fait l'objet d'une relecture indépendante avant les onze autres cas. Les scripts, commandes, PID, codes de sortie, stdout/stderr, tampons et sorties sont conservés dans le dossier de travail sur F:.

| Module physique, x86 machine14C | Chemin | Octets | SHA-256 |
|---|---|---:|---|
| D3DX39 | C:\Windows\SysWOW64\D3DX9_39.dll | 3851784 | 5d29988cad858f754ecc62c3d30de555f82cc21b5b26c448b890295e9b7bee82 |
| D3D9 | C:\Windows\SysWOW64\d3d9.dll | 1550992 | fd72e021c128a98a5d688eb9acc07e3eb1948ca6b630b9fa5f328898e78c7dbc |

Les alias retournés par GetModuleFileNameW sont System32 dans le processus32bits ; GetFinalPathNameByHandleW les résout physiquement vers SysWOW64. Les identités et empreintes physiques sont contrôlées avant/après. Aucun runtime43 n'est installé ou exécuté. La correspondance de ces DLL locales avec les fichiers effectivement utilisés en2014 reste inconnue.

Adaptateur mesuré par le banc : NVIDIA GeForce RTX 3060. Chaque fenêtre propre au banc est vérifiée invisible. Les quatre appels Release sont observés et DestroyWindow renvoie1 ; la surface conserve temporairement une référence interne avant la libération de la texture. Ces compteurs n'attestent pas une libération complète de VRAM. Les tests ne produisent pas de frame rasterisée et ne prouvent pas une exécution de shadersGPU ou une résidenceVRAM : les surfaces MANAGED peuvent être traitées en mémoireCPU.

## Comparaison indépendante et refus

La relecture Ahri0 compare six pixels à un modèle indépendant de coordonnées centrées avec interpolation bilinéaire et clamp aux bords. Différence maximale observée :0.496490478515625niveau par canal. Il s'agit d'un contrôle exploratoire partiel, sans acceptation de tous les pixels, du sampler complet ou du rendu final.

Deux cas de refus sont réellement exécutés :

- Pitch1231 au lieu1232 : le contrat d'entrée du banc refuse avant chargement des DLLs et avant toute API ; code attendu/reçu101, aucune sortie créée.
- Fichier de sortie déjà présent : un treizième appel réel D3DX réussit et la surface est relue, puis create_new refuse l'écrasement ; code attendu/reçu2, contenu existant strictement conservé, quatre libérations et destruction de fenêtre observées.

Ce sont des refus d'entrée/sortie du banc ; **aucun HRESULTD3DX ou D3D défaillant n'a été induit**. Ils ne valident pas les refus ou le nettoyage nominal du code de jeu original. La garde du tampon détecte des écritures ; elle ne prouve pas l'absence de toutes lectures internes hors contrat.

Cinq falsifications documentaires de l'essai sont refusées par le lecteur : mauvaise empreinteDLL, HRESULT1 présenté comme succès nominal, format de surface changé, octet de sortie modifié et prétendue exécution du caller normal. Cinq mutations du candidat de registre sont également refusées. Un diagnostic ponctuel Python passé en une ligne a échoué à l'analyse syntaxique avant lecture de pixels ; le script autonome de relecture a ensuite réussi sans rejouer l'API. Les reçus immuables des exécutions sont conservés.

| Étape | Code attendu | Code reçu | SHA-256 journal |
|---|---:|---:|---|
| V693_PREPARE_REAL_COPY | 0 | 0 | 9dfae1e51b8e117141f00307168a99296dab22d34481e6da3e10c91c01dc2024 |
| V693_FIRST_REAL_COPY | 0 | 0 | 0dfa126909f20f87fd9273fdce3739655d423f443eb1f7014ad1e84b0c653e94 |
| V693_FIRST_REAL_COPY_REVIEW | 0 | 0 | f1a662823b53fb9353c22c2076f17ee4f2ceeb8399a3527045fa1a868ce6e32a |
| V693_REMAINING_REAL_COPY | 0 | 0 | 682c719eab2340a7c0740630556b8f08a587c2d44a13fc01b9effaefdbe61b75 |
| V693_REAL_COPY_REFUSALS | 0 | 0 | 8c8e20d3dcb68b42e88188c9abefd51b0cc49c8ff2160504b640cacd8661e201 |
| V693_REAL_COPY_ASSOCIATIONS | 0 | 0 | 0f1a23f70cd70cc7e1a4023fe9d1614c9f63b3eefd9b8abbab3aaa414bc9eac3 |
| V693_STORAGE_ON_F | 0 | 0 | bf954cab41a17ff3489744755e8309e989c95dcfedab73df4ceffc85499bbe90 |
| V693_PREPARE | 0 | 0 | 41c134a3669df160a8db6102a25111ef061b0dfeb300afc4acd7f965583fc5b6 |
| V693_CHECK | 0 | 1 | 2e5bc1eaf0493418bbb0437b5e1af8ff9b66d48773f51929e551ec4013248adf |
| V693_CHECK_ON_F | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V693_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V693_DELIVERY_AUDIT | 0 | 0 | 7ba969f5e1aae723f7ff713699cabe2bdeb3b80cf9ea2280a09128f431a84254 |

## Intégration réelle et données conservées

SYS-17.3-01 et SYS-01.2-02 reçoivent13liens natifs et73sources nouvelles. Les huit descripteurs de consommateurs actuels sont vérifiés sur leurs sources et lignes, puis conservés sans ajout. Le graphe compte99682sources,5613consommateurs et42 215exigences actives. Ce compteur ne constitue pas un rehachage complet du catalogue.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec son ancien texte et ses conditions en historique. Elle reste ouverte ;26 189inconnues restent ouvertes et5517résolues antérieures sont conservées. Aucune autre identité,question,propriétaire,statut ou aspect n'est altéré. IDS et phases/lots sont byte-identiques.

Le candidat passe l'inversion documentaire exacte, l'inversion logiqueSQLite et l'idempotence de synchronisation. Les deux bases publiées et auditées conservent42 605autres lignes,42 607états manuels et23historiques. Aucune case n'est cochée automatiquement, aucun prérequis n'est levé, aucune acceptation du jeu n'est enregistrée.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-real-copy-v693.json ; preuvedocs/fidelity_native_portrait_real_copy_v693.json ; ce rapport ; deux bases du plan ; coverage.json,completion_plan.json,resume_checkpoint.json et docs/ai/CURRENT.md,HANDOFF.md. Les scripts et preuves détaillées restent sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun code de production ou asset modifié ; aucun rebuild du moteur complet n'est revendiqué.

## Ancienne garde de chemin et correction

Le premier contrôle V693_CHECK s'arrête avec code1 avant toute modification des bases actives : le helper revision670 exige encore le dossier temporaireC et le préfixe ancien. La préparation a déjà correctement réservé et écrit son scratch surF. Un adaptateur distinct revision693_delivery_on_F_checked.py remplace seulement cette garde par un contrôle de chemin résolu sous le dossier privé F:/OpenLeague-work/.../publication-scratch et le préfixe openleague-v693-. Le même candidat et ses empreintes restent inchangés ; aucune garde d'espace n'est abaissée. Le contrôle corrigé, reçu V693_CHECK_ON_F, réussit. L'ancien programme, le reçu d'échec et le descripteur SCRATCH_F_ADAPTER.json sont conservés et vérifiés avant chaque contrôle/publication/audit.

## Stockage et limites ouvertes

Pour conserver les nouveaux fichiers de travail sur F:,105anciens fichiersJSON de preuves fermés sont compressés sans perte, sans suppression. Taille logique et SHA-256 sont comparés avant/après chaque fichier ; réduction de stockage rapportée4585017762octets. Les bases actives ne sont pas compressées. Le nouveau scratch est sous F:/OpenLeague-work/.../publication-scratch ; la réserve de4GiB est vérifiée sur F:, volume qui reçoit effectivement les sauvegardes, au lieu du volumeC presque plein. Les gardes conservatrices de publication restent actives.

Restent ouverts : fidélité historique des DLLs2014, pixels complets et décodageDXT, comparaison au transport actuel avec entrées équivalentes, publicationUV/couleur/sampler, mode/backend/catégorieflash effectifs, chemin normal provider/cache/UI et nettoyage nominal natif. Les résultats V692/V691/V690/V689 restent des acquis hérités avec leurs limites ; l'écart Kalista288octets et les12noms de ressources non résolus sont conservés. La réussite du banc ne termine ni l'écran de chargement,ni un champion,ni le jeu.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V693 publié/audité :12copies locales réelles via x86D3DX39/D3D9 sur objets hôte,96HRESULT nominaux nuls,12surfaces512x1024 relues/13 107 200octets.5ARGB8/4DXT1/3DXT5,sources intactes,libérations et fenêtre cachée détruite. Deuxrefus du banc,pitch invalide avantAPI et fichier existant conservé après13eappel réel ; aucun HRESULTD3DX défaillant induit. Reprendre ces sorties sans relancer le matériel sans raison. Suite concrète : comparer indépendamment tous les pixels des cinq sortiesARGB8 au modèle linéaire explicite, puis décoder/qualifier séparément les sortiesDXT avec source/outil identifiés. Comparer au transport actuel sous entrées équivalentes ; poursuivre depuis9B8738 la publicationUV/couleur/sampler et le nettoyage natif nominal avec adaptations déclarées. Identifier mode1225C58/callers9B7590 et backend/catégorieflash effectifs, puis caller normal/provider/cache/UIcontinuation. DLLs2014historiques non qualifiées ; succèsHAL/lectureMANAGED ne prouve pas frameGPU,résidenceVRAM ou écran historique. Conserver inconnueOLU-ac85c18c-d131-517e-83a7-d0987d643c48 ouverte,Kalista288octets,12noms ouverts,acquisV692/V691/V690/V689 et toutes cases/historiques. Scratch de publication dorénavant surFavec réserve4GiB surF ; voir reçu de compression sans perte. Goal actif,aucun jeu ou écran accepté.
