# SYS-01.2-02 — Classes natives et contrôle des fabriques, V681

UTC 2026-10-27T14:13:13.965516+00:00. Projet F:/OpenLeague ; PUBLIC4.20.0.315 EUW/en_GB. V680 reste conservé ; cette étape précise la provenance des classes, sans qualifier une partie jouée.

## Résultat vérifié

**32 enregistrements natifs** sont reconnus par une séquence exacte, redécodés à leurs frontières puis exécutés dans Unicorn. Le constructeur de descripteur66DD80 écrit le parent en+34 et la fonction de création en+38. Les noms et catégories sont comparés aux chaînes du binaire. Les écritures sont surveillées :66DE26 et66DE2C. Le stockage de chaînes et l'enregistrement atexit sont adaptés explicitement ; aucun destructeur ni démarrage complet n'est exécuté.

Le nom exact des champions est **AIHeroClient**. La chaîne4FF1F0 → descripteur2D5CBC8 → fabrique60D3E0 → constructeur63C9F0 est vérifiée. Le préfixe du constructeur est **analysé statiquement**, avec conservation de this en[ebp-10], rechargement à63CB9F et écriture de1092608 à63CBB4. Cela précise l'une des tables V680, pas une instance historique effectivement créée.

| Nom natif | Fabrique | Constructeur | Table racine | Slot+1C |
|---|---|---|---|---|
| obj_AI_Base | 0x600dc0 | 0x612be0 | 0x1093d80 | 0x614a70 |
| AIHeroClient | 0x60d3e0 | 0x63c9f0 | 0x1092608 | 0x62f5e0 |
| obj_AI_Minion | 0x6126c0 | 0x643500 | 0x109192c | 0x614a70 |
| obj_AI_Turret | 0x6324a0 | 0x648540 | 0x1090ea8 | 0x6495d0 |
| obj_AI_Marker | 0x642280 | 0x6423c0 | 0x1091e14 | 0x614a70 |
| LevelPropAI | 0x646a00 | 0x646f90 | 0x10913d8 | 0x614a70 |

Les six préfixes de constructeurs sont décodés jusqu'à l'écriture de table, sans exécuter leur corps. La provenance s'appuie sur les instructions et conventions d'appel ; le succès, les exceptions, les autres effets et la durée de vie des objets restent ouverts. Les deux autres tables V680,1092CE8 et10931B4, ne reçoivent pas de nom de classe qualifié ici. Aucun nom supposé `obj_AI_Hero` ne remplace AIHeroClient.

## Cas nominaux et limites

**72 cas de fabriques** couvrent six fonctions × deux allocateurs × deux états du drapeau de bootstrap × trois sorties : succès, allocation nulle, constructeur retournant zéro. Les chemins normaux complets, y compris leurs deux retours, sont exécutés. Attendu et observé : résultat constructeur+4 en succès ; zéro pour les deux échecs ; constructeur non appelé si l'allocation échoue ; bootstrap seulement si son drapeau est initialement nul. La taille allouée et le contexte de l'allocateur personnalisé sont vérifiés. Pile et chaîne SEH sont restaurées au retour.

Allocation, bootstrap et **constructeur entier sont adaptés** dans ces cas : la sonde impose leurs résultats pour vérifier le contrôle de la fabrique. Elle ne simule pas silencieusement une construction réussie du jeu. Exceptions/unwind non testés. Les32 enregistrements et72 cas visitent688adresses natives ; ce nombre n'est pas une mesure de complétion du client.

Les routes de chargement V680 et les associations de ressources V678 sont héritées et relues, pas rejouées ici. Dix ancres et les slots sont vérifiés. Les18 fichiers natifs associés sont revérifiés par empreinte avant préparation ; leur appartenance aux manifestes vient des preuves antérieures conservées. La recherche ciblée du code Rust retrouve le résolveur d'alias et son callback fourni. Aucun nouveau consommateur de jeu, asset, compilation Rust, rendu ou son n'est ajouté.

## Intégration au plan

Six fiches : SYS, Braum, Kalista, Lulu, Rengar et Zac. La classe commune n'est pas une preuve de chargement de chacun de ces champions. 22liens natifs et5sources de preuve ajoutés ; critères, dépendances et inconnues conservés. Les bases projet et bureau sont relues par les lecteurs réels ;42 601autres lignes,42 607états manuels et23historiques conservés. Trois altérations documentaires refusées ; inversion et idempotence contrôlées. Aucune case cochée ou acceptation utilisateur déduite.

## Manques et prochaine action

- Sélection réelle de la classe depuis718A70/7172B0, constructeur complet et instance vivante non qualifiés.
- Producteur du nom, du skin et du fournisseur effectif, montage, priorités, cache, puis liaison au moteur Rust restent à vérifier.
- Les12 noms de ressources des précédents profils restent non résolus ; leur absence dans ces profils ne prouve pas leur absence de toutes les archives. Aucun remplacement ou alias supplémentaire inventé.
- Deux identités de table, les chemins d'exception, le démarrage historique complet et les tests GPU/audio/gameplay restent ouverts.

Continuer SYS-01.2-02 sur F:/OpenLeague. V681 publié :32 enregistrements natifs et72 cas de contrôle de fabriques, avec adaptateurs explicites. AIHeroClient est enregistré par4FF1F0 dans2D5CBC8, fabrique60D3E0 appelle63C9F0 ; son préfixe statique écrit1092608 à63CBB4. Slot1C vers62F5E0 rejoint la route V680 vers614A70/716EC0. Ne pas rejouer les enregistrements ni les anciens alias. Qualifier la sélection de classe dans718A70/7172B0 et son lien au descripteur nommé, puis le producteur nom/skin/fournisseur transmis au chargement. Le constructeur complet63C9F0, les deux classes des tables1092CE8/10931B4, le montage effectif et le dispatch courant restent ouverts. Conserver les12 noms de ressources non résolus et les autres inconnues. Un contrôle de fabrique avec constructeur adapté ne prouve pas un objet vivant. Goal actif ; aucun état manuel accepté.

## Preuves et fichiers

Binaire : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Observation : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision681_class_factory_audit\OBSERVATIONS.json`, SHA256 `f8b8919db9809d639c173d28082ecf6b2cc157dc5e4cbc4c1d167bc01839bc57`. Script : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision681_class_factory_audit.py`. Source, versions de bibliothèques et limites pinées dans l'observation. Les explorations E/v681_*_unqualified.json restent exploratoires.

| Contrôle exécuté | Code | SHA256 du journal |
|---|---:|---|
| V681_CLASS_FACTORY | 0 | 8a150370eb5da384a227ce90c3e48493ed306b7b81aed351b45f957dcc1ddb37 |
| V681_SNAPSHOT_LZX | 0 | bfef6a21e21992f79890162e4922a0e466cfef2f8a7ec40d05c28e042133e2c3 |
| V681_ASSOCIATIONS | 0 | 9fffc4ec3b843247bc7d3f4ef20784f950672dfca3d30a1ea24655f7a060b263 |
| V681_PREPARE | 0 | ef0d7b1fde7795767ab198b6ea9ab374e7c2c00c54415a6652f56bedd3aecdc0 |
| V681_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V681_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V681_DELIVERY_AUDIT | 0 | cad5aa1634d588f7dd53630c743a9d528e01a9a500b89e3276f466258a8865ad |

Trois anciens snapshots V679 clos ont été compressés LZX avec contrôle exclusif, WAL absent/vide et SHA256 identiques avant/après : gain857468928octets alloués. Aucun fichier supprimé et aucune base active compressée.

Fichiers de registre modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/native-named-class-factory-v681.json. Contrôle : docs/fidelity_native_named_class_factory_v681.json. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md. Les registres d'identités, d'ordre des phases et d'inconnues restent byte-exact.

**SYS-01.2-02 et le goal restent ouverts. Cette étape ne termine ni les champions ni le jeu.**
