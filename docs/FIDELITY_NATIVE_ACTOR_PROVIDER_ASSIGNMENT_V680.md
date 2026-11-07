# SYS-01.2-02 — Affectation native du fournisseur à l'acteur, V680

UTC 2026-10-27T13:49:52.884386+00:00. Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB. V679 est classé comme progression ; état Git et notes courantes relus.

## Résultat

La méthode native **716EC0** copie le nom reçu dans l'objet à `+0x24` et le fournisseur reçu dans `+0x3C`, puis retourne1. La surveillance des écritures identifie précisément `716F27` comme instruction d'affectation. **18 cas complets** exercent des noms de longueur0,15,16,399,400,401 et trois pointeurs, dont nul et une valeur opaque non déréférencée.

Un nom d’au moins 400 octets produit un appel diagnostic. Dans la sonde, le logger adapté rend la main et la méthode poursuit la copie et l’affectation. Le comportement du logger réel (retour, interruption ou autre décision) reste ouvert : la continuation observée ne prouve pas une acceptation inconditionnelle du client original. Le stockage de chaîne est également adapté ; la méthode ne valide pas le fournisseur avant de le stocker. Cela ne qualifie pas un usage ultérieur d'un pointeur invalide.

**16 préfixes de chargement** vérifient deux pointeurs pour chacune des huit tables déjà recensées par le contrat `fow_owner`. Leurs slots+1C conduisent à614A70, puis à716EC0. Les variantes6495D0,62F5E0 et62DAA0 transmettent les mêmes arguments. L'exécution s'arrête à614AC2 après l'affectation réussie, **avant le reste du chargement**.

| Table native | Cible du slot+1C |
|---|---|
| 0x1090ea8 | 0x6495d0 |
| 0x10913d8 | 0x614a70 |
| 0x109192c | 0x614a70 |
| 0x1091e14 | 0x614a70 |
| 0x1092608 | 0x62f5e0 |
| 0x1092ce8 | 0x62f5e0 |
| 0x10931b4 | 0x62daa0 |
| 0x1093d80 | 0x614a70 |

Les adresses de ces tables sont vérifiées, mais leurs noms de classes et la sélection effective d'une instance historique ne sont pas affirmés. La méthode générique de fabrique7172B0, décodée statiquement, transmet le fournisseur au slot+1C ; sa construction d'objet n'est pas exécutée dans cette étape.

## Affectation suivie de consommation

**280 compositions** (35 demandes/contrôles sur huit routes) exécutent l'affectation originale, puis7522B0 dans la même machine. Le champ acteur+3C n'est pas réécrit par la sonde entre ces étapes. Le résolveur lit donc la valeur écrite par716EC0 ; requêtes, nom retourné et sélection de package concordent avec les sorties attendues V677.

La recherche9041E0 s'exécute dans une seconde machine native, avec transfert explicite du nom et du résultat, sur les neuf fichiers physiques/18entrées enregistrés par905090. Cette frontière est conservée. Le nom de personnage, le pointeur fourni, le skin et les flags restent des entrées de test. Les douze noms absents des profils examinés restent signalés ; aucune preuve de montage réel, d'appartenance au passif ou d'activation n'est déduite.

## Contrôles et consommateurs

Douze ancres, six régions alignées et huit slots de table sont vérifiés contre le binaire piné. Les régions comprennent la méthode de base complète, le thunk complet et des préfixes explicitement bornés ; la fabrique n'est analysée que statiquement. Les 251 adresses visitées ne constituent pas une couverture complète du chargement.

La recherche actuelle du code Rust retrouve `native_effect_resource_skin_alias::resolve`, sa déclaration et son test : le callback `package_contains` reste une entrée. Cette recherche ciblée ne prouve pas l'absence de tout appel indirect. Les consommateurs existants restent reliés sans promotion en liaison de jeu. Aucun nouveau code ou asset de jeu, aucun nouveau descripteur de consommateur et aucune compilation Rust ne sont ajoutés.

Le registre, les instructions copiables et les bases projet/bureau reçoivent six fiches : Braum, Kalista, Lulu, Rengar, Zac et SYS. **22 liens natifs et 5 sources de preuve** sont intégrés. Trois candidats documentaires altérés sont refusés ; inversion et idempotence vérifiées. La relecture des deux bases conserve42 601 autres lignes,42 607 états manuels et23 historiques, avec lecteurs réels du plan et résolution des traces.

## Commandes et limites

| Étape | Code | SHA256 du journal |
|---|---:|---|
| V680_ACTOR_PROVIDER_ASSIGNMENT | 0 | c86a0448e071d2249af36ab9d0377c8c5f38c9f3a04b61b818f468256588c011 |
| V680_SNAPSHOT_LZX | 0 | 8d23f9eba8f4585f962e4597d23ba0cc31120c0472ebf51757dcb07086a83b07 |
| V680_ASSOCIATIONS | 0 | a0c205cdf27a037fd29db1be3a13479365bc5de3a649d585ef4456d5b16a3f61 |
| V680_PREPARE | 0 | 642fadd98ad2735680e30076ec6bd9d9b557f2b5123530b1aabedc2b0af86a48 |
| V680_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V680_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V680_DELIVERY_AUDIT | 0 | f0eaec0b62cb2c64e15943aab0aa3fa431fce8f09ce6a76a85ba188aea08f815 |

Une exploration de références par commande Python a été interrompue (code1) : elle relisait inutilement la même section binaire à chaque occurrence. La version corrigée lit chaque section une fois ; les résultats exploratoires sont dans `E:/mapslol3v3/v680_base_load_callers_unqualified.json` et `v680_provider_callers_unqualified.json`. Ces fenêtres de reconnaissance ne sont pas utilisées comme preuve de fonction complète. Le script qualifié redécode les régions alignées et vérifie leurs instructions avant exécution. Aucun échec n'est masqué comme réussite.

Trois copies SQLite closes de V676 ont été compressées LZX, après vérification de WAL vide et accès exclusif. SHA256 et tailles logiques identiques avant/après ; allocation réduite de856272896octets. Aucun fichier supprimé ; les bases réelles ne font pas partie de cette compression. Réserve de préparation C4Gio conservée, publication atomique sur F.

Restent ouverts : sélection et construction de classe, provenance du fournisseur concret, montage/ordre/cache effectifs, suite des chargements dérivés et liaison au moteur Rust. La vtable du fournisseur de l'acteur n'est pas observée dans une partie originale. Pas de lancement complet du client, de test Cargo complet, de rendu GPU, d'écoute audio ou de validation d'un champion.

## Fichiers et preuves

- Binaire : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Observation native : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision680_actor_provider_assignment\OBSERVATIONS.json`, SHA256 `6f64fb5786d5473671050e620d7fe96d7501dc6b236bdd81058424790f5b0152`.
- Script exécuté : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision680_actor_provider_assignment.py` ; sources/adaptations pinées dans l'observation.
- Registres modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`.
- Associations : `docs/reference_requirement_trace_sources/native-actor-provider-assignment-v680.json` ; contrôle livré : `docs/fidelity_native_actor_provider_assignment_v680.json`.
- Couverture et reprise : `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`.

Les critères, dépendances, inconnues et anciennes preuves restent conservés. Aucun état manuel ou statut de complétion du jeu n'est promu.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V680 publié/audité :716EC0 écrit le fournisseur reçu dans acteur+3C et le nom en+24 ;18 cas complets de base,16 préfixes de huit tables et280 compositions avec7522B0 réussis sans réécriture du champ par la sonde. Les huit tables du contrat fow_owner mènent à614A70 directement ou via6495D0/62F5E0/62DAA0, puis716EC0. Ne pas rejouer ces affectations ni les recherches V678/V679. Qualifier maintenant les constructeurs et la sélection des tables1090EA8/10913D8/109192C/1091E14/1092608/1092CE8/10931B4/1093D80, leur provenance de classe et le fournisseur reçu lors du véritable chargement. Chercher les écrivains de vtable et les enregistrements de types natifs, puis les producteurs nom/skin transmis à90AD00. Ne pas confondre le descripteur de personnage+20 avec le champ de base acteur+3C. 7172B0 transmet statiquement un fournisseur au slot1C de son objet, mais son allocation et l’identité des instances ne sont pas qualifiées ici. Les chemins locaux/globaux, montage effectif, dispatch courant et activation audio restent ouverts. Conserver toutes les cases, critères et inconnues ; trois anciens snapshots V676 compressés en LZX sans perte ni suppression pour maintenir la réserve C4Gio. Goal actif.
