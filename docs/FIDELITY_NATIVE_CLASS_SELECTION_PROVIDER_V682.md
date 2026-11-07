# SYS-01.2-02 — Sélection de classe et arguments du fournisseur, V682

UTC 2026-10-27T14:42:22.234703+00:00. Projet F:/OpenLeague ; PUBLIC4.20.0.315 EUW/en_GB. V681 est une progression publiée, relue avant ce travail. Cette étape relie les noms de classe aux index consommés et précise la provenance des arguments de ressources.

## Résultat et portée

Le registre natif de classe publie une paire index/descripteur dans la table globale pointée par `2D78C28`, puis inscrit l'index dans le descripteur. Pour AIHeroClient, il s'agit de `63C960` et du descripteur `2D5CBC8`. Le sélecteur `718A70` vérifie l'index et la paire, appelle la fabrique située dans le descripteur à `+38`, puis inscrit ce descripteur à l'adresse retournée (objet racine+4).

La chaîne exécutée est : `63D7A0` lit l'index du descripteur → `614EA0` demande le fournisseur à `90AD00` → `7172B0` appelle `718A70` → fabrique `60D3E0` → chargement via table `1092608` → `62F5E0`/`614A70`/`716EC0`. Le constructeur entier est adapté et sa table fournie d'après l'écriture statique qualifiée V681. Le résultat du fournisseur est également fourni : **le cache90AD00 n'est pas exécuté dans cette composition**.

Le nom du **modèle** et le skin sont capturés à l'entrée réelle de90AD00 ; son retour est transmis sans remplacement à7172B0 puis stocké en acteur+3C par716F27. Le nom de **l'instance**, volontairement différent dans le test, est copié en acteur+24. Aucun renommage implicite de l'un en l'autre n'est ajouté. La dépile de12octets de90AD00 est vérifiée sur son `ret0xC` ; son troisième argument n'est pas interprété par l'adaptateur et aucun sens métier n'est inventé.

## Contrôles attendus et observés

| Contrôle | Cas | Attendu et observé |
|---|---:|---|
| Publication d'index pour six classes | 36 | Comptes0/17/1022 acceptés ; compte1023 diagnostiqué puis refusé sans mutation ; allocation tardive réussie ; allocation nulle conduit à une lecture non mappée dans la sonde |
| Sélection de la fabrique | 18 | Six classes × trois index ; retour objet+4 et écriture du bon descripteur par718ABF |
| Limites du sélecteur | 4 | Index hors plage ou paire divergente atteint le diagnostic fatal ; constructeur nul atteindrait une écriture à0 ; allocation du registre nulle atteint une lecture non mappée |
| Composition jusqu'à l'affectation native | 20 | Cinq champions × skins0/1 × fournisseur nul/non nul ; requête modèle/skin, nom instance et pointeur stocké concordent |

Les36 cas incluent six lectures non mappées attendues après allocation nulle du registre ; ce sont des observations de limites en émulation, pas six tests échoués ni des crashs observés dans le jeu réel. La frontière fatale du sélecteur arrête la sonde sans supposer qu'elle retourne. La sonde interrompt aussi le chemin juste avant l'écriture nulle du sélecteur : la page0 sert à émuler SEH et ne doit pas transformer ce cas en succès artificiel. Le logger du registre est adapté pour rendre la main ; son comportement réel reste ouvert.

Les index viennent des écritures natives mais les comptes initiaux sont fournis. **17 n'est pas affirmé comme numéro historique de AIHeroClient.** L'ordre complet des initialisations historiques reste à qualifier. Les six descripteurs sont réinitialisés avec les stubs natifs nécessaires à la composition ; cela ne rejoue pas le démarrage du processus.

Neuf ancres et les régions alignées sont vérifiées ; 829 adresses originales visitées. Allocation, constructeur entier, classification des coordonnées finies, position et effets secondaires d'enregistrement sont adaptés explicitement. Les noms, positions et pointeurs sont des entrées synthétiques de contrôle. L'exécution s'arrête à614AC2 après l'affectation, avant la suite des chargements dérivés et la fin des routines de création. Aucune création complète d'acteur vivant n'est déduite.

## Consommateurs, intégration et conservation

La recherche ciblée actuelle retrouve le résolveur Rust d'alias et son callback de disponibilité. Aucun nouveau dispatch de jeu, asset ou code moteur n'est ajouté. Les18 fichiers natifs associés sont revérifiés par empreinte avant préparation ; leur appartenance aux manifestes reste issue des preuves conservées. La vérification globale du graphe ne recalcule pas toutes les empreintes de ses sources.

Six fiches (SYS, Braum, Kalista, Lulu, Rengar, Zac), 22 liens natifs et 5 sources de preuve sont publiés. Les lecteurs réels contrôlent les bases projet et bureau :42 601 autres lignes,42 607 états manuels et23 entrées d'historique conservés. Trois altérations documentaires sont refusées ; inversion et idempotence vérifiées. Critères, dépendances, anciennes preuves et inconnues restent conservés ; aucune case cochée automatiquement.

## Manques et suite

La prochaine limite à lever est la sélection du fournisseur dans90AD00 à partir du manager global et du couple modèle/skin. Son retour fourni ici prouve la transmission, pas l'identité du package effectif. Restent aussi ouverts le constructeur entier, le montage, les priorités/cache effectifs, la suite des chargements et la liaison au moteur Rust. Les deux tables encore sans identité et les12 noms non résolus dans les profils précédents le restent ; aucun fallback ou asset de substitution n'est inventé. Pas de compilation Cargo, lancement du client complet, test GPU, écoute audio ou acceptation gameplay pour ce lot.

Continuer SYS-01.2-02 sur F:/OpenLeague. V682 publié : le registre natif63C960 écrit un index dans le descripteur AIHeroClient et la table globale ;63D7A0 le lit,614EA0 demande90AD00 avec nom de modèle/skin, puis7172B0/718A70 créent via le descripteur avant la route de chargement716EC0. Vingt compositions montrent nom instance en+24 et fournisseur reçu en+3C, avec modèle distinct. Ne pas rejouer les registres ni les anciens alias. Remplacer maintenant la frontière adaptée90AD00 par son cache natif dans cette même chaîne, en réutilisant après relecture docs/loading_resource_manager_sources/manager/probe_manager.py et docs/loading_resource_manager_sources/cache/probe_cache_retirement.py (racines E historiques à adapter explicitement en F) ; qualifier les clés, le manager global2D78F1C, le choix effectif et les entrées de90B520. Comparer au consommateur actuel crates/core/src/audio_loading_resource_cache.rs::resolve et à ses issues HitBorrowed/MissFactory, sans convertir MissFactory en réussite. Le troisième argument est dépilé par ret0xC mais non interprété dans le corps étudié. Ne pas appeler index17 un identifiant historique : il dépend du compte de test17. Constructeur entier, allocation, position et effets de registre restent adaptés ; arrêt614AC2 avant suite des chargements. Garder ouverts montage/cache effectifs, deux identités de table,12noms de ressources non résolus, moteur et acceptation. Goal actif.

## Preuves et fichiers

Binaire : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Observation : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision682_class_selection_audit\OBSERVATIONS.json`, SHA256 `786a42b4bde9777de8ee3cd11429446926686a081316d678f2b2de97051b4eed`. Script : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision682_class_selection_audit.py`. Bibliothèques et sources pinées dans l'observation. `E:/mapslol3v3/v682_class_selection_unqualified.json` reste une exploration ; la sonde qualifiée redécode les régions retenues.

| Étape exécutée | Code | SHA256 du journal |
|---|---:|---|
| V682_CLASS_SELECTION | 0 | 2a3540ca1551f7c3ed821c55cb4ec7b171fe4975c7275e1f2100f59d7b06d008 |
| V682_SNAPSHOT_LZX | 0 | 22a15e4be07a155f22c917cfb2d0a4924ca8d46deb0a6dcd792912ebc10c638e |
| V682_SNAPSHOT_LZX_RESERVE | 0 | 0a0e8ff2fea495dd00d49b53d1a6d7199d7959ea48b9a9e463a80e4857c3b44a |
| V682_ASSOCIATIONS | 0 | fc1bae084d6810b1c47cff18e77fe602d9865b12bb827eef9b953c251b90c32d |
| V682_PREPARE | 0 | 570b5c70427f9d13eb8063b634a374d9432673f6e5485466cd9526045227140e |
| V682_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V682_PROOF_LZX | 0 | 4bbf4b6cb796d0b7937117f9d6c0d6af1a7541e584b4a82b95b351e9768aac55 |
| V682_PUBLISH_RETRY | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V682_DELIVERY_AUDIT | 0 | d638b5afdfa4ecc0b90eca14571e3f849e7f9e2846690054dd123eec5e51bb81 |

Neuf anciens snapshots V675/V680/V681 clos ont été compressés LZX, avec accès exclusif, WAL absent/vide, tailles logiques et SHA256 conservés. Gain 2571386880 octets alloués. Aucun fichier supprimé ; aucune base active compressée.

La première publication a échoué avant toute mutation : réserve conservatrice insuffisante sur F. Le reçu et son journal sont conservés (`revision669_V682_PUBLISH.json`, SHA256 du journal `6423094a4c5088d87dd8cbf103987e60efc473dcf7595df80506d97617c4af05`). Une ancienne observation close de V666 a ensuite été compressée LZX sur F, avec SHA256 identique et gain 165326178 octets ; aucun fichier supprimé. La reprise V682_PUBLISH_RETRY et la relecture installée ont réussi.

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/native-class-selection-provider-v682.json. Audit livré : docs/fidelity_native_class_selection_provider_v682.json. Couverture/reprise actualisées : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Registres d'identités, phases et inconnues byte-exact.

**Le goal et SYS-01.2-02 restent ouverts. Aucune complétion du jeu ou d'un champion n'est déclarée.**
