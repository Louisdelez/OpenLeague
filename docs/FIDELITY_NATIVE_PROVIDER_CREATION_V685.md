# SYS-01.2-02 — Création native du fournisseur, V685

UTC 2026-10-27T16:34:45.002521+00:00. F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB. V684 est une progression publiée et relue. Ce lot apporte une nouvelle exécution de la fabrique originale, après la réconciliation des environnements historiques.

## Résultat et portée

Dans une même machine Unicorn x86 : DLL originale attachée, bootstrap natif, fragment de contexte par défaut, initialisateurs de hash, producteur90B7C0 et liaison592E49..592E6A, puis90AD00/90B520 pour **Ahri/skin0**. La fabrique retourne un objet de56octets portant la vtable10D64A8 ; son résultat n’est pas injecté. Un deuxième90AD00 retourne le même pointeur sans allocation ni nouvel appel de la fabrique. Quatre requêtes originales sont ensuite effectuées et la destruction90A760 du manager retourne après retrait de l’objet fournisseur et du manager de l’arène suivie.

Les chaînes, CRT, diagnostics, tas DLL et lectures reposent encore sur les feuilles explicites de l’environnement de référence. Le résolveur de surcharge de locale est désactivé dans cette sonde (`start(None)`) ; les overlays de langue restent ouverts. Le format `%02d` est adapté uniquement au retour9035DA, capacité3, plage admise0..99 ; **seul0 est exercé ici**. Les fichiers d’origine sont lus sans modification. Cette exécution ne constitue pas un processus historique lancé ni un montage de jeu accepté.

## Attendu et observé

| Contrôle | Attendu | Observé |
|---|---|---|
| Création90B520 | Objet réel construit par le code original dans le profil déclaré | Pointeur 0x53000650, vtable10D64A8,56octets |
| Cache90AD00 | Même pointeur, pas de seconde fabrique/allocation | Conforme |
| Publication et visite | Instructions originales90B651 et90B270 visitées | 1 publication, 2 visite |
| INI | Conserver les appels et retours réels sans résultat fourni | 1 entrée(s), 1 retour(s) enregistrés |
| Requête absente | Le nom diagnostic manquant est refusé | Conforme |
| Destruction du manager | Retour natif, fournisseur et manager retirés de l’arène suivie | Conforme ; global laissé à0x530002a0 puis effacé par le contrôleur |
| Chemins | Sept chemins natifs contenus admis, sortie de racine et flux alternatif refusés | Neuf contrôles conformes |

Les résultats de disponibilité sont conservés tels qu’observés :

| Requête | Résultat natif | Chemin logique retourné |
|---|---|---|
| Ahri.ini | trouvé | DATA/Characters/Ahri/Ahri.ini |
| Base.ini | trouvé | DATA/Characters/Ahri/Skins/Base/Base.ini |
| AhriLoadScreen.dds | trouvé | DATA/Characters/Ahri/Skins/Base/AhriLoadScreen.dds |
| __openleague_missing_resource__.ini | absent dans ce profil | — |

La disponibilité d’un fichier sur disque et son admission par ce fournisseur sont deux constats distincts. Un résultat absent dans ce profil n’est pas une preuve d’absence universelle de l’asset. Les entrées INI et leurs valeurs retournées sont conservées. Le parent est au champ+0x10, confirmé par le setter original905000 et les octets de l’objet : la normalisation corrige l’étiquette parent du premier collecteur, qui désignait à tort le mot+0x30, sans modifier la preuve brute. Les trois fichiers originaux disponibles sont hachés après exécution et comparés au registre. Les hashes/positions des octets effectivement transférés dans les flux de cette exécution n’ont pas été enregistrés ; ils ne sont pas déduits de ces identités après coup.

## Échecs conservés et corrections

Le premier essai s’arrête dans l’adaptateur sur les chemins natifs `../configurationmanifest` et `../solutionmanifest`. Le second accepte ces deux chemins précis mais s’arrête sur les diagnostics de dispositions alternatives, dont `../lol.launcher_tencent.exe`. Le troisième normalise les chemins et réussit ses neuf contrôles, puis s’arrête à cause d’une liste native_queries non initialisée dans le collecteur passif, après publication du fournisseur. Le quatrième initialise cette liste et observe les sites de retour des visiteurs. Ces adaptations concernent le contrôleur de recherche ; les octets du client ne changent pas.

Un script de préparation du stockage avait aussi échoué avant création de son fichier, à cause d’un échappement de commande. Le reçu d’échec reste conservé ; le script correctement créé est exécuté sous un nouveau nom. Aucun de ces échecs n’est transformé en succès.

## Intégration au consommateur actuel

SYS-17.3-01 et SYS-01.2-02 sont enrichies avec ces preuves. Le descripteur existant du cache resolve est relié à la fiche de chargement, en complément du véritable appelant initialize_standard_record_owned déjà recensé. Aucun descripteur global ajouté ; aucun changement du code moteur. Les trois limites Rust restent : manager non publié, hit sans continuation UI, miss sans fabrique courante. La nouvelle exécution native précise ce qu’il reste à confronter/porter ; elle ne supprime pas ces erreurs.

Deux bases publiées et relues :42 605autres lignes,42 607états manuels et23historiques conservés ; quatre altérations documentaires refusées, inversion exacte et idempotence vérifiées. 7 sources de preuve et 5 liens natifs ajoutés. Graphe : 99464 sources,5607consommateurs ;26189inconnues ouvertes et5517résolues inchangées. Registres d’identité, phases et inconnues byte-exact. Aucune case cochée automatiquement.

## Contrôles réellement exécutés et limites

Les quatre nouvelles sondes natives, les contrôles de chemins, le lecteur d’associations, la préparation, les refus de delta, la publication et la relecture ont été exécutés. Pas de nouvelle compilation Rust/Cargo ni de client graphique. Les adresses de code EXE/DLL visitées sont vérifiées contre les images sources ; les feuilles adaptées sont explicitement listées. La destruction du manager retourne, mais 345 allocations de l’arène EXE suivie restent dans l’environnement ; ce compte ne comprend pas le tas DLL virtuel distinct. Teardown complet du contexte, de la DLL et du processus non qualifié. Aucun skin supplémentaire, autre champion, acteur V683, rendu GPU, lecture audio ou chargement complet accepté.

Les12noms de ressources non retrouvés dans les profils antérieurs restent ouverts. Le profil de ressources, les priorités et la suite UI exigent leurs preuves propres.

| Étape | Code réellement reçu | SHA256 du journal |
|---|---:|---|
| V685_EXPLORE | 2 | 822ac2ffbcae18481820fe75f803e0fbe1f05039ed816d8050da3beb080edfe0 |
| V685_PROVIDER_READY | 2 | 4848590d7c067dfb23706b3a0b8bbad7a46d256fc441c4c49e9aea8fd8439dea |
| V685_PROVIDER_CONTAINED | 2 | 33c45239761872dd79d30f26579e1d9a1e48f8e7d664c6825a546ff9e08f8391 |
| V685_PROVIDER_OBSERVED | 0 | 261f8684036f536e0002a7bab9502e21ebf189f818b28447c0b8428439ddc547 |
| V685_SNAPSHOT_LZX | 2 | b3723b6331e97335c46007afc83a91b55425d2ba9beab26dd41d801bab3c6221 |
| V685_SNAPSHOT_LZX_READY | 0 | 67770d2fc623d782daa5e8d53a3e0b31780673080752a791983a4e72ce098201 |
| V685_PROOF_LZX | 0 | df2a35b5600b64a1e38e149f8702e7db47b0987aa14e271b3d5c4378d56b9145 |
| V685_ASSOCIATIONS | 0 | 1e47dc5fc9ffefef84a5f6c3ca010481ce34e8aac651eae87a5bd664ef23722b |
| V685_PREPARE | 0 | 4f3005dbb6c69ef2af34e69aa6f523a490aad024c538df20e2a940a7920ef9a5 |
| V685_CHECK | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V685_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V685_DELIVERY_AUDIT | 0 | a8e6469b6fc8d104f2579afbf78629ceedfa3048d5bf18e7e470f1f9b3cf014c |

Preuve brute : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision685_provider_observed\OBSERVATIONS.json`, SHA256 `299f56e7fc7205c13d054c39508be41ffffc5196072de23990efe9551a1402bf`. Observation normalisée : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision685_provider_associations\OBSERVATIONS.json`. Les deux exécutables originaux gardent leurs SHA : EXE402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 ; DLL60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521.

Six anciens snapshots SQLite fermés et une ancienne preuve JSON sont compressés sans suppression, avec tailles logiques et SHA identiques. Gains alloués : C1713750016octets ; F116461265octets. Les bases actives ne sont pas compressées.

## Fichiers modifiés et suite

docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/native-provider-creation-v685.json ; vérification docs/fidelity_native_provider_creation_v685.json, ce rapport et les deux bases locales du plan. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md. Aucun code moteur ni asset modifié.

Continuer SYS-01.2-02 sur F:/OpenLeague. V685 a exécuté la fabrique90B520 d’Ahri/skin0, le hit de90AD00, quatre requêtes et le retour de destruction native du manager dans le profil de référence déclaré. Lire les résultats exacts dans docs/FIDELITY_NATIVE_PROVIDER_CREATION_V685.md et docs/fidelity_native_provider_creation_v685.json ; un fournisseur renvoyé ne termine pas le montage ni le chargement UI. Le code Rust initialize_standard_record_owned conserve ses refus manager absent, hit sans suite et miss sans fabrique. Les descripteurs actuels de cet appelant et de audio_loading_resource_cache::resolve sont maintenant reliés à SYS-17.3-01 sans nouveau consommateur global. Suite : confronter les alias, les fichiers effectivement trouvés et le parent du fournisseur à ces deux consommateurs actuels, puis qualifier les contextes/skins supplémentaires et le contrat de continuation après90AD00 sans élargir silencieusement le profil. Ne pas rejouer le bootstrap déjà conservé sans changement justifié. Les normalisations de chemins natifs sont contenues dans la racine ; garder sept contrôles nominaux/deux refus et les deux essais arrêtés. Format %02d/cap3 adapté au retour9035DA, chaînes/CRT/tas DLL/IO virtuels explicites. La destruction du manager ne qualifie pas le teardown complet DLL/process. Les12noms de ressources et autres inconnues restent ouverts ; aucune acceptation UI/GPU/audio/jeu. Goal actif.
