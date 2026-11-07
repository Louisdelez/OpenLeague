# SYS-01.2-02 — Cache natif dans la création et consommateur Rust, V683

UTC 2026-10-27T15:21:08.621302+00:00. Projet F:/OpenLeague ; PUBLIC4.20.0.315 EUW/en_GB. V682 est classé comme progression publiée et a été relu. Son résultat90AD00 fourni par adaptateur est remplacé ici par l'exécution de la recherche originale dans la même machine.

## Résultat

La chaîne `63D7A0 → 614EA0 → 90AD00 → 7172B0 → 718A70 → chargement → 716EC0` exécute désormais la recherche, la normalisation des clés et la libération de la clé temporaire du cache original. Aucun retour de90AD00 n'est injecté. Sur hit, le pointeur effectivement renvoyé par l'arbre est transmis puis stocké en acteur+3C ; le nom d'instance distinct est conservé en+24. Sur absence, l'exécution s'arrête à l'entrée de90B520, avant son premier corps d'instructions et avant la création de l'acteur.

Le producteur90B7C0, les initialisateurs de hash, le fragment de liaison des pointeurs retour et l'insertion90CEF0 produisent le gestionnaire et les nœuds. **Les11 valeurs de cache restent des jetons opaques fournis**, dont une valeur nulle. Ce ne sont pas des fournisseurs reconstruits, ni des packages ou montages effectivement validés. La présence dans ce cache de test ne prouve pas l'existence des ressources du champion.

## Cas et observations

| Contrôle | Attendu | Observé |
|---|---|---|
| 31 hits natifs | Même clé après normalisation ASCII et même skin ; valeur exacte renvoyée | Conforme, puis affectation originale du pointeur à l'acteur |
| Dont3 hits nuls | Une clé présente à valeur0 reste un hit | Conforme ; aucun appel de fabrique sur ces hits |
| 11 absences | Atteindre90B520 avec manager, nom original et skin | Conforme ; arrêt avant création, aucune affectation d'acteur |
| 42 comparaisons Rust/natif | Même résultat et ordre des lectures de recherche | Conforme avec les modules actuels compilés |
| Chaînes et propriété | Même copie normalisée, allocations/libérations temporaires ; source et cache conservés | Conforme dans les42cas |
| Refus Rust | Locale non-C et arbre cyclique rejetés explicitement | Deux refus conformes, sans invention de comportement natif équivalent |

Les cinq champions Braum, Kalista, Lulu, Rengar et Zac sont interrogés pour skins0/1 avec trois variantes de casse. Les essais skin2 et noms suffixés non enregistrés sont **des absences du cache fourni**, pas une déclaration d'assets manquants. Un nom long synthétique exerce la chaîne avec stockage de chaîne sur le tas, en hit et en absence. La valeur nulle associée au cas de test Zac/skin1 est synthétique et ne décrit pas son fournisseur historique.

Les 2436 adresses originales visitées sont vérifiées contre le binaire. La locale est la locale C initiale du PE. L'ordre historique complet de démarrage et les contextes de ressources restent ouverts. L'index de classe17 vient du compte initial de test17 ; il n'est pas présenté comme identifiant historique.

## Consommateur actuel et compilation

Six modules exacts sont compilés directement avec rustc : audio_announcer_object_lookup, audio_announcer_registry_init, audio_announcer_registry_remove, audio_replay_metadata, audio_loading_owned_string et audio_loading_resource_cache. Les sources sont incluses par leur chemin réel ; aucune copie simplifiée de resolve ne remplace l'implémentation. Le hôte de mémoire charge les octets du cache original et fournit des primitives de stockage avec propriété explicite. Aucun build Cargo complet, client graphique ou service de jeu n'est lancé.

Le consommateur `OLC-82f6a132-a446-53f3-923b-de66e0b3014f` décrit précisément `crates/core/src/audio_loading_resource_cache.rs:144`, fonction resolve. Sa source était déjà enregistrée ; aucun des5605anciens descripteurs ne visait ce module. Il est ajouté comme **entry_boundary_only**, provides_feature_consumer=false, feature_scope_complete=false, gameplay_accepted=false. Les cinq liens vers les fiches champion n'en font pas un appel depuis leur gameplay.

HitBorrowed et MissFactory restent distincts. MissFactory conserve le manager, le nom original et le skin ; cette issue n'est ni une création réussie ni un fallback implicite. Les lectures d'arbre, le descripteur normalisé, les octets de chaîne, les allocations temporaires et leur retrait sont comparés aux nouvelles observations natives. Les blocs du cache et la source empruntée restent identiques.

## Limites conservées

- Le constructeur entier d'acteur, son allocation, la position et les effets secondaires d'enregistrement restent adaptés. Arrêt à614AC2 avant la suite des chargements et la fin des routines de création.
- Les appels arrêtés laissent des chaînes appartenant aux appelants. Leur retrait est explicite, sur une pile de contrôle distincte ; cela ne prouve ni retour complet ni déroulement d'exception du client.
- Les nœuds de cache diagnostiques sont retirés avec le nettoyage natif avant destruction du manager vide. La destruction de vrais fournisseurs peuplant le cache reste non qualifiée.
- Fabrique90B520, fournisseurs réels, montage, priorités et intégration au moteur restent à vérifier. Les12 noms non résolus dans les profils antérieurs restent ouverts. Aucun asset de remplacement, son, rendu ou passif accepté.

## Publication et preuves

Six fiches actualisées : SYS et les cinq champions. 22 liens natifs et 9 nouvelles sources de preuve ; un descripteur de consommateur de bibliothèque ajouté, aucun consommateur de gameplay. Le graphe contient5606consommateurs. Les registres d'identités, phases et inconnues sont byte-exact. Les bases projet/bureau conservent42 601autres lignes,42 607états manuels et23historiques.

Quatre candidats sont refusés : promotion injustifiée du consommateur de cache, modification d'acceptation, retrait d'un consommateur et retrait d'un lien natif. L'inversion du delta restitue désormais aussi exactement la liste des consommateurs ; idempotence et lecteurs réels contrôlés. Aucune case cochée automatiquement.

Binaire : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Observation native : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision683_cache_composition_audit\OBSERVATIONS.json`, SHA256 `a1f110893224ae1c18b05f83a1d719ac0b0b9df249951411858a50040354c349`. Comparaison Rust : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision683_cache_rust_audit\OBSERVATIONS.json`, SHA256 `7ecf856ce48f2627c4508c3a109067edeab0283803599cd62d191057c9386a59`. Programme Rust et exécutable réellement exécuté : référencés et hachés dans ce second reçu, avec version rustc, commande de compilation et journaux.

| Étape exécutée | Code | SHA256 du journal |
|---|---:|---|
| V683_CACHE_COMPOSITION | 0 | 85d4a0f317cc49ce7703357945d7f6b02d89d8511c9d7788b71828769752d0fc |
| V683_CACHE_RUST | 0 | d43dfd8090d79d683903e2313797eabfd4e7bea3091e2971f3a7258c43a90be7 |
| V683_SNAPSHOT_LZX | 0 | dd0b5a78c3190d21b173d9a108b9757af1aad494e318f69f1e2d8776f50d95b3 |
| V683_ASSOCIATIONS | 0 | b0e2e9b9e8164b7cb33c055b302a9db7ae5328324a07fad84d6a5108719bd9f8 |
| V683_PREPARE | 0 | c17c23192ef373b727b9e8db323c3b648d86d85c502a2f24fb02c74aadec54ca |
| V683_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V683_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V683_DELIVERY_AUDIT | 0 | e70f2b12a4cec0402d6de2609efae111a00c26125042fb60b352855cf9f1be72 |

Six anciens snapshots V674/V682 clos sont compressés LZX sans suppression, après contrôle de WAL absent/vide et d'accès exclusif. Empreintes et tailles logiques identiques avant/après ; gain 1713586176 octets alloués. Les bases actives ne sont pas compressées.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/native-current-cache-composition-v683.json ; audit docs/fidelity_native_current_cache_composition_v683.json. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Aucun code moteur ou asset modifié.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V683 publié :90AD00 fonctionne dans la même machine que le préfixe63D7A0/614EA0 et la sélection/affectation de l’acteur ;42cas,31hits dont3nuls et11arrêts avant90B520. Les six modules Rust réels sont compilés et concordent sur résultats, lectures de recherche, normalisation et propriété/nettoyage. Un consommateur de bibliothèque audio_loading_resource_cache::resolve est ajouté au registre, pas un dispatch de jeu. Ne pas rejouer les alias ni le cache déjà qualifié sur ces entrées. Qualifier maintenant la création90B520 dans cette chaîne sur les clés modèle/skin qui manquent : relire docs/loading_resource_manager_sources/next_provider_preparation/probe_provider.py et probe_empty_provider.py, docs/loading_resource_manager_sources/next_provider_io/probe_native_io.py, et les preuves de fabrique/provider V168 avant de choisir le consommateur réel actuel. Remplacer les jetons opaques par les fournisseurs construits seulement avec preuves de contexte/chemins et limites explicites. Les essais de skins2/non-enregistrés sont des absences du cache de test, pas des assets natifs absents. Conserver les12noms de ressources non résolus, l’ordre de montage ouvert, les constructeurs d’acteur adaptés et l’arrêt614AC2 ; aucun GPU/audio/gameplay accepté. Goal actif. Le consommateur enveloppant crates/core/src/audio_replay_windows_loading_packets.rs, initialize_standard_record_owned, appelle déjà resolve : un hit retourne une limite explicite de continuation UI, une absence retourne factory90B520 unavailable. Inspecter ce consommateur avant de conclure à une implémentation absente ; ne pas confondre sa branche Standard avec la branche Tutorial distincte. Les anciens probes de préparation contiennent des chemins E: hérités : les adapter dans une nouvelle preuve privée sans réexécuter leur main ni écraser leurs oracles.

**SYS-01.2-02 et le goal restent ouverts. La preuve de cache ne termine pas le jeu ni les champions.**
