# SYS-01.2-02 — Matrice de fournisseurs et octets transférés, V686

UTC 2026-10-27T17:45:42.096676+00:00. Projet F:/OpenLeague ; PUBLIC4.20.0.315 EUW/en_GB. V685 était une progression publiée : Ahri/skin0 construit puis détruit, avec identités de fichiers après exécution mais sans capture des octets transférés. Ce lot ferme cette lacune uniquement pour les lectures effectivement observées dans le nouveau profil.

## Résultat

Les fonctions originales90AD00/90B520 exécutent12cas : Ahri, Braum, Kalista, Lulu, Rengar et Zac, skins0/1. Chaque fournisseur retourné est conservé dans sa forme originale, le cache renvoie son pointeur sans nouvel appel de fabrique/allocation et les requêtes logiques sont exécutées dans le code d’origine. Une seule destruction native du manager retourne et retire tous les fournisseurs suivis. Aucun résultat de fournisseur ou de lecture INI n’est injecté.

Le profil utilise start(en_GB), un fragment de contexte par défaut, le bootstrap natif et la DLL originale dans une machine x86 isolée. Les feuilles de chaînes, tas, CRT, diagnostics et formatage restent des adaptateurs explicites ; aucune application historique Windows n’est lancée. La surcharge de langue est une entrée déclarée ; elle ne résout ni la locale CRT initiale ni les paramètres du processus de2014.

| Modèle | Skin | Requêtes trouvées | Requêtes absentes | Fragments lus dans ce cas |
|---|---:|---:|---:|---:|
| Ahri | 0 | 3 | 1 | 18 |
| Ahri | 1 | 5 | 1 | 0 |
| Braum | 0 | 3 | 1 | 27 |
| Braum | 1 | 5 | 1 | 0 |
| Kalista | 0 | 3 | 1 | 21 |
| Kalista | 1 | 5 | 1 | 0 |
| Lulu | 0 | 2 | 2 | 24 |
| Lulu | 1 | 3 | 3 | 0 |
| Rengar | 0 | 3 | 1 | 24 |
| Rengar | 1 | 5 | 1 | 0 |
| Zac | 0 | 3 | 1 | 21 |
| Zac | 1 | 5 | 1 | 0 |

Un cas sans nouvelle lecture peut réutiliser une configuration déjà en cache. Un miss est une absence dans le profil exécuté, pas une absence universelle de ressource. Le détail de chaque nom demandé et chemin logique retourné reste dans la preuve. Les trois misses supplémentaires de Lulu portent sur Base.ini/Skin01.ini : les configurations existantes MeshSkin/MeshSkin1 sont dans Lulu.inibin et l’identité capturée correspond au référentiel. Les deux skins retrouvent leurs DDS de chargement à la racine. Cette corroboration est enregistrée séparément ; elle ne prouve pas la sélection de skin en jeu et ne signale aucune texture manquante par ce seul résultat.

## Octets et couverture

Pour chaque lecture atteinte après le bootstrap, le contrôleur enregistre le fichier ouvert, son identité, la position, la taille demandée, le retour, les octets effectivement présents dans la destination émulée et leur SHA256. Ils sont comparés à la source ouverte. L’audit vérifie de nouveau les fragments, leurs plages, le contenu de source conservé et l’identité du fichier courant. Les chevauchements sont fusionnés : une lecture répétée n’augmente pas artificiellement la couverture.

| Source | Octets couverts/taille | Portée | SHA256 source |
|---|---:|---|---|
| Ahri.inibin | 2671/2671 | complète dans les transferts observés | 341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2 |
| Braum.inibin | 1365/1365 | complète dans les transferts observés | fd19cd86048c49700ac805a79802af15dc22d107b4570271cb05e4f71025baec |
| Kalista.inibin | 1295/1295 | complète dans les transferts observés | bf6f9252137e19f0c38d7a9308aefdce90fa718f3259fce0fcc60ee12c92c412 |
| Lulu.inibin | 1880/1880 | complète dans les transferts observés | a266de6d44e0d6c9785882dfcc3230f0ca42093268287bddf2011c7bf531e6c1 |
| Rengar.inibin | 1748/1748 | complète dans les transferts observés | 6bb46f0dada3c0bded8657d30f938f99d66ebdc704a5dfe694a7c46ce03844ed |
| Zac.inibin | 1752/1752 | complète dans les transferts observés | 1d9956957570def9ed28850d06007b010d21fa571dd9ac982487dbe358bd2d13 |

Total : 135fragments ; 6sources entièrement couvertes sur6. Les octets de source conservés à l’ouverture et les fragments copiés sont distincts : seul l’ensemble des plages observées fonde une couverture complète. La capture commence après le bootstrap ; les lectures antérieures de manifestes ne sont pas ajoutées à ce bilan.

**Provenance IO : flux Python en lecture seule et handles virtuels**, aux frontières CRT fread ou import DLL ReadFile. Ce ne sont pas des appels Win32 ReadFile exécutés nativement. Les appels du parseur et du fournisseur restent originaux, sous vérification des octets d’instructions. Les noms DDS sont interrogés ; leurs pixels, lecture de texture, décompression et upload GPU ne sont pas qualifiés par cette capture.

## Arrêts préservés et ABI

Le premier essai termine Ahri/skin0 et ses18fragments, puis s’arrête pour skin1 sur un chemin CRT non initialisé. Il avait atteint657FC0, dont l’adaptateur de répertoire audio existait mais était désactivé. Le deuxième active cet adaptateur ; il s’arrête parce que celui-ci traite le second argument comme String24.

La lecture du code original montre au contraire un buffer Cstring de deux chiffres produit au préalable par %02d. Le site902E9C appelle657FC0 et revient à902EA1 avec deux cases contenant des pointeurs de Cstrings. La troisième sonde adapte uniquement ce site et le format exact %1/Sounds/Skin%2/Sounds. Quatre contrôles nominaux et deux refus sur des cadres synthétiques vérifient cette convention ; 6appels du véritable chemin de matrice sont aussi observés. Les deux essais arrêtés sont gardés. Le formateur reste une feuille adaptée ; son corps CRT original n’est pas déclaré qualifié. Le premier lecteur d’associations avait terminé et écrit son observation, puis échoué sur un import json manquant au moment d’afficher son reçu. Sa version corrigée est réexécutée sous un nouveau nom ; reçu et résultat du premier lecteur sont conservés.

## Attendu, observé et contrôles

- Douze profils exacts, hits identiques du cache, refus du nom diagnostic absent, retour de destruction du manager : conformes aux assertions exécutées.
- Identité et plages des octets transférés, contenu de destination et union de couverture : vérifiés par le lecteur d’associations.
- Quatre falsifications de preuve refusées : octets destination modifiés, plage hors source, fausse complétion globale, mauvais champ parent.
- Quatre altérations du delta documentaire refusées ; inversion exacte des documents et de l’état logique SQLite, idempotence et lecteurs réels contrôlés.
- Deux bases relues après publication :42 605autres lignes,42 607états manuels et23historiques conservés. Aucune case cochée automatiquement.

## Intégration et limites

SYS-17.3-01 et SYS-01.2-02 reçoivent les preuves et 8liens natifs. 10sources de preuve ajoutées ; aucun nouveau consommateur global. Les descripteurs existants initialize_standard_record_owned et audio_loading_resource_cache::resolve restent des frontières partielles. Le code Rust conserve ses trois refus : manager absent, hit sans continuation UI et miss sans fabrique courante. Aucune compilation Rust/Cargo ou GUI n’a été exécutée dans ce lot ; aucun code moteur ou asset modifié.

La destruction du manager ne termine pas tous les propriétaires : 5362allocations de l’arène EXE, 61blocs du tas DLL et 5handles virtuels subsistent. Le nettoyage des flux hôte constate0flux de lecture ouverts après fermeture. Teardown complet DLL/process, autres champions/skins, ordre historique des montages, rendu, audio et chargement UI restent ouverts, ainsi que les12noms de ressources déjà non résolus. Les registres d’identités, phases et inconnues restent byte-exact ; le graphe comporte99474sources et5607consommateurs, sans rehachage de tout le catalogue.

## Exécutions et fichiers

| Étape | Code reçu | SHA256 du journal |
|---|---:|---|
| V686_NATIVE_MATRIX | 2 | 3e4fd00ed39b51f5465554156b7704f231da64a965f99a5e49b90ab47a71b061 |
| V686_NATIVE_MATRIX_SCAN | 2 | c8c5dd86b44ef4b553636b11348d1b4c48f311a05078aacd8b9bec93ad9e9708 |
| V686_NATIVE_MATRIX_CSTRINGS | 0 | c35149ead107da94780b6f0c3c2a5a323b2d9c1ce567bd6acb97d8520eaa0b05 |
| V686_SNAPSHOT_LZX | 0 | 2386fcf354c9cfec7e42c9979f616bae0a4e1487fcc465376846e87b763e6f5d |
| V686_ASSOCIATIONS | 1 | 40145cf551308df3ab5453139e330d0bf6f4aad2087a70851ff55197cd81b591 |
| V686_ASSOCIATIONS_FINAL | 0 | 5313463c4c9b93a55d8f0a5648a2c74f721f2aab4b1a88ec6c2e8e0eac60e135 |
| V686_LULU_CORROBORATION | 0 | ba0f5d9cdafe50239b0a921d0bb4ae55e08a65db368af20bed00c40806a7eaae |
| V686_PREPARE | 0 | 3645fb87f0493d4b06159dd7ca2c6bcd8a5b90e8bc6335e01b8e00e1e8fc3715 |
| V686_CHECK | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V686_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V686_DELIVERY_AUDIT | 0 | 04028010bc4a3f6914c105118fc8cc3440af890d037e9e26ab59a2b9a45e536c |

Preuve brute : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision686_provider_io_matrix_cstrings\OBSERVATIONS.json ; SHA256 35f0686df1ed85530a08c0ec104fa7c4502e05576192eecac115be16ad81472d. Observation vérifiée : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision686_provider_io_associations_final\OBSERVATIONS.json. EXE402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 et DLL60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521 inchangés ; sources et producteurs hachés dans les reçus.

Trois anciens snapshots SQLite fermés du lot V685 sont compressés sans perte ni suppression : 858558464octets alloués récupérés, tailles logiques et SHA identiques. Les bases actives ne sont pas compressées.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/native-provider-transfers-v686.json ; vérification docs/fidelity_native_provider_transfers_v686.json, ce rapport et les deux bases locales du plan. Couverture et reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V686 publié : six modèles Ahri/Braum/Kalista/Lulu/Rengar/Zac, skins0/1, overrideen_GB déclaré ; fournisseurs, cache, requêtes et transfert exact des configurations qualifiés dans ce profil borné. Ne pas rejouer ces cas ou le bootstrap sans changement justifié. Lire le rapport et sa table de couverture : les DDS ne sont que retrouvés par leur nom, pas lus/décodés/uploadés. Suite : inspecter la continuation originale57D77A après le call90AD00 à57D775 et les sources docs/loading_standard_resource_preparation, puis confronter aux méthodes audio_loading_standard_prefix::prepare et initialize_standard_record_owned. Identifier le choix exact du fichier/portrait par champion/skin et les nouvelles frontières de lecture/initialisation UI ; les requêtes génériques de la matrice ne remplacent pas ces demandes réelles. Garder quatre falsifications refusées, les deux sondes arrêtées et les six contrôles ABI : site902EA1 reçoit deux pointeurs de Cstrings, pas String24. Fread/ReadFile/tas/chaînes/formatage restent des feuilles explicites. Localeen_GB déclarée ne prouve pas la locale CRT ni le démarrage historique. Conserver12noms non résolus et autres inconnues ; cases/notes/historiques préservés. Aucun GPU/audio/UI/jeu accepté ; goal actif.
