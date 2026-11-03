# SYS-01.2-02 — États natifs après copie : liens canoniques V699

UTC : 2026-10-27T23:07:10.480036+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Cette étape intègre les preuves V698 au registre canonique et aux deux bases du plan. Elle ne termine pas le chargement ou le jeu.

## Résultat observé et portée

Les douze DDS sont reliés au parcours natif après copie. Le retour S_OK est un **pont explicite**, contrôlé contre l'appel local réel V693 sur les mêmes octets, format, étendue et filtre. Le corps D3DX n'est pas exécuté par le guest. Aucun nouvel appel API/GPU ni nouveau parcours natif n'est exécuté par ce lecteur d'associations.

Les douze contextes V698 conservent 4 312 000 octets CPU identiques au niveau0 des sources. Les instructions originales poursuivent le retour9B8738, placent TLS à1, libèrent la surface et les temporaires suivis, puis publient la texture dans OBJ+8C/+90. Une allocation de20 octets reste détenue par contexte : vtable10E3270, mot de référence2, textureCOM adaptée conservée à1.

| Portrait | FormatDWORD | Étendue logique | Réf. surface | Réf. textureCOM | Allocation suivie encore détenue |
|---|---:|---|---:|---:|---|
| Ahri:0 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Ahri:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Braum:0 | 894720068 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Braum:1 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Kalista:0 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Kalista:1 | 894720068 | [308, 560] | 0 | 1 | {'1082130640': 20} |
| Lulu:0 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Lulu:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Rengar:0 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Rengar:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Zac:0 | 894720068 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Zac:1 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |

L'étendue logique308×560 et la texture déclarée512×1024 ne suffisent pas à qualifier les UV ou un recadrage. Le wrapper vivant à l'arrêt n'est pas à lui seul une fuite ; la surface à0 ne prouve pas une VRAM entièrement libérée.

## Frontière et entrées non qualifiées

Le parcours s'arrête avant l'instruction98964D appelant978820. Ni cette instruction ni son callee ne sont exécutés. Le global2D79030 vaut0 dans le contexte déclaré sans bootstrap ; cela ne prouve aucune absence dans le client historique ou notre jeu. Ce manager d'inscription reste distinct du provider90AD00 plus amont. Le banc fournit un label technique ; le nom ordinaire issu du vrai producteur, la signature et l'ownership après appel restent ouverts. Les quatre mots de pile observés ne sont pas une signature récupérée.

Le producteur978457 et les remises à zéro978574/97858C ne sont encore que des candidats statiques dans cette livraison V699 ; les nouveaux essais séparés V700 sont en cours de qualification. Les observations de V698 ne sont pas silencieusement transformées en preuve de bootstrap complet.

## Intégration et conservation

SYS-17.3-01 et SYS-01.2-02 reçoivent 13 liens natifs (EXE+12DDS) et 64 sources nouvelles. Les huit descripteurs actuels sont fraîchement vérifiés sur leurs fichiers et lignes, puis conservés. Aucun nouveau consommateur de fonctionnalité, code ou asset de production n'est ajouté ; aucun rôle de manager n'est promu à partir d'un nom de variable.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec ancien texte et condition en historique. Elle reste ouverte ; identité, propriétaire, aspects, statuts et autres inconnues sont conservés. Le graphe compte 99826 sources, 5613 consommateurs, 42 215 exigences actives, 26 189 inconnues ouvertes et5517 résolues antérieures. Ce compteur n'est pas un rehachage du catalogue complet ; les pins de cette livraison sont vérifiés séparément.

## Refus et contrôles réellement exécutés

Cinq falsifications de preuve sont refusées : retour complet prétendu, exécutionAPI prétendue, manager confondu avec un autre global, nomVFS normal prétendu et valeur de manager modifiée. Cinq mutations du candidat sont également refusées. Inversion documentaire exacte, inversion logiqueSQLite et idempotence sont vérifiées. Les deux bases publiées et auditées conservent 42 605 autres lignes, 42 607 états manuels et23 historiques. Aucune case cochée automatiquement et aucun prérequis levé.

Le premier gardeV698 s'arrêtait à9BB764/code2, en traitant à tort une jonction commune comme réservée à une texture nulle. Une version distincte corrige cette classification. La première revue demandait à tort le stopPC98964D parmi les instructions exécutées/code1 ; une autre revue distingue correctement l'événement observé avant appel. Les sources, reçus et résultats antérieurs sont conservés. Ces arrêts du banc ne constituent pas des erreurs du jeu original.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V698_POST_COPY_FIRST | 0 | 2 | c67d691dfef70cfcb9214c34634160c477eb2563463dd2eb64b2b422bed5ae6a |
| V698_POST_COPY_JOIN_CHECKED | 0 | 0 | 89e79dca81b7929c2b1a29c3baadcff1df4512710f251abddf0549f9bb6727d4 |
| V698_FIRST_REVIEW | 0 | 1 | dc4d9e92782c6118e0cec6e1f408cbb4078fe160a30e0ca893438fb44a492cc6 |
| V698_FIRST_REVIEW_CHECKED | 0 | 0 | 70ec4aaecb2b6ae19de772dc2b8ba37a18d854651a3de5dd7e0293a891aaf4ed |
| V698_POST_COPY_ALL | 0 | 0 | 8638059415fa8ebed944a94df7a4a0a0aa6e472554d8beb5fa7302c6486e40b0 |
| V698_ALL_REVIEW | 0 | 0 | 2269371afb80d5bbe5721e0bd23397aaf673e9039a593507a1bcee12044651bf |
| V698_REGISTRATION_STATIC | 0 | 0 | 3d94182e625bbd93ead02fa9cbce33498781fb2ce58819bb53f167be24486ddb |
| V698_POST_COPY_CHECKPOINT | 0 | 0 | dc2628b460416da58dfb2878719740e268377947bc7718dc8905420482011b8f |
| V699_ASSOCIATIONS | 0 | 0 | 194b074316c5a948ffab76ee73ba022fb86e3d76fb8f91cd2a07ab8ce9b57b72 |
| V699_STORAGE | 0 | 0 | 6d88e584fbedecc69fc2d397e42fc5038ff9ee2a48b0323a23376d45ee2fb7d3 |
| V699_PREPARE | 0 | 0 | 3af80119b8760ec6198ba960936d62bbba5285748b13fd022f81d923d56bdec9 |
| V699_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V699_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V699_DELIVERY_AUDIT | 0 | 0 | fef34ffb8211b56ffa88b9acc1a9a3cf24ae59efaf7dde0711012e5fa4a86cb3 |

18 fichiers historiques fermés sont compressés sans perte, avec exclusivité d'accès, taille logique, SHA-256 et sidecars conservés. Réduction de stockage rapportée : 1499151105 octets. Aucun fichier supprimé et aucune base active compressée. Scratch privé et réserve4GiB restent surF.

## Fichiers et limites

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json. Reçu : docs/reference_requirement_trace_sources/native-portrait-post-copy-v699.json. Preuve : docs/fidelity_native_portrait_post_copy_v699.json. Deux bases du plan actualisées. Ce rapport, coverage, completion_plan, resume_checkpoint et CURRENT/HANDOFF sont actualisés avec sauvegardes et conservation des anciens champs. IDS et ordre phases/lots sont byte-identiques. V698 préliminaire conserve son état daté ; V699 est son intégration ultérieure.

Lecteur : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision699_post_copy_associations\OBSERVATIONS.json. Parcours natifs : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision698_native_post_copy_all\OBSERVATIONS.json. Le PE, les scripts, allocations, payloads, reçus et journaux restent identifiés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun build moteur complet ou nouveau testRust n'est revendiqué ; les contrôles du consommateur réel du plan sont exécutés.

Les nouvelles preuves V700 montrent séparément une clé logique interne par défaut ; le terme VFS dans les notes précédentes doit être précisé selon le caller, sans imposer un chemin de fichier à tous les noms. Cela ne qualifie pas encore le producteur du nom des portraits ordinaires.

Restent ouverts : fin du constructeur et fabrique de secours du manager, contexte de backend/caps/catégorie/mode, producteur du nom ordinaire, inscription/ownership, UV/couleur/sampler, transport actuel et nettoyage complet. Les cinqARGB8/max0.5 et septDXT décodés exactement restent acquis ; qualitécompression non acceptée(max83), alpha réel opaque, DLL2014, Kalista288octets et12noms restent ouverts. Aucun écran, champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V699 a intégré et audité V698 : 12 continuations natives après pont S_OK déclaré depuis V693, TLS1, surface0, texture publiée OBJ+8C/+90, un wrapper20 encore détenu par contexte. Arrêt avant98964D→978820 ; manager2D79030=0 dans le banc sans bootstrap, nom technique et ownership non qualifiés. Deux fiches et deux bases auditées, 8 consommateurs conservés, question historisée ouverte. V700 a ensuite exécuté le préfixe original9783D0→publication978457, puis la préparation du vrai nom par défaut avant978482→978660 non exécuté : manager80, deux headers32, cinq allocations240. La routine99B170 renvoie une adresse de chaîne internée ; sept appels (deux du nom source texture_registry_system_default et cinq contrôles) donnent cinq identités, répétitions sans allocation, variantes de casse distinctes, FNV1a observé. Ne pas confondre cette table interne avec le hash de fichiers8E50F0/65599 minuscule. Constructeur complet, fabrique de secours et inscription978820 non exécutés. Revoir et intégrer V700 en précisant que le nom source par défaut est une clé logique interne : ne pas exiger universellement un chemin VFS, qualifier le vrai producteur pour chaque caller, y compris portraits. Puis qualifier la suite978660, son sélecteur de backend1225B04 et l’inscription/ownership, UV/couleur/sampler et transport actuel ; aucune valeur de backend ou pointeur inventé. Préserver les échecs de garde/revue V698, les preuves ARGB8/DXT et résidus83 non acceptés, DLL2014, Kalista288octets et12noms ouverts. Avant prepare, vérifier réserve4GiB surF et garde du scratch privé. Goal actif ; aucun écran ou jeu complet accepté.
