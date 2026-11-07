# SYS-01.2-02 — Recherches natives du fournisseur de personnage, V679

Date UTC : 2026-10-27T13:28:32.531020+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB. La livraison V678 précédente est classée comme progression ; les fichiers courants et le point de reprise ont été relus.

## Résultat et portée

Le callback de disponibilité de la sonde de variantes de skin ne renvoie plus un booléen imposé. Il transmet le nom exact à **Contains9041E0**, exécuté dans une seconde machine native isolée, et retourne son résultat à **7522B0**. Les deux fonctions originales sont exécutées ; le transfert du nom et du résultat reste adapté. Les pointeurs, durées de vie et objets d'une partie réelle ne sont pas reconstitués par ce test.

**420 compositions** réussissent : les 210 demandes/contrôles de V677 sont exercés avec un fournisseur local enregistré par la fonction native905090, puis avec une table base fournie explicitement à partir du même résultat. **80 recherches Contains/GetResolvedPath** concordent avec les observations du fournisseur Rust V678. Les résultats Rust et l'oracle attendu V677 sont hérités après contrôle des identités ; aucune compilation Rust nouvelle n'est revendiquée.

Neuf fichiers physiques conformes aux manifestes donnent 18 entrées natives, dont les alias logiques `.troy` des `.troybin`. Les douze noms de préchargement non résolus restent absents des profils examinés. Ces résultats ne prouvent ni une absence universelle ni que le preload est nécessaire au passif en jeu.

## Lien statique conditionnel

Trois régions natives sont décodées intégralement et huit ancres sont vérifiées. 7522B0 lit `acteur+0x3C` puis appelle son slot virtuel `+0x28`. 9034D0 installe la vtable `0x10D64A8`, dont ce slot pointe effectivement vers `0x9041E0`. Ce dernier consulte la liste de contextes `0x2D78F20`, la recherche locale `0x90D1D0` et le repli `0x905D80`.

**Ce lien est conditionnel : la classe réellement attachée à acteur+0x3C n'a pas été observée.** L'objet de configuration personnage+0x20 de V167/V168 n'est pas assimilé automatiquement à cet objet d'acteur. Les constructions, caches, montages et écritures qui établiraient cette identité restent ouverts.

## Vérifications exécutées

| Contrôle | Attendu | Observé |
|---|---|---|
| Alias et recherche native | Noms retournés, requêtes et sélection de package identiques aux cas V677 | 420/420 |
| Recherche de ressource | Présence et chemin exacts identiques à V678, casse conservée dans le résultat | 80/80 |
| Priorités diagnostiques | Local tardif avant base précoce ; ordre des locaux ; ordre des bases ; absence | 4/4 |
| Profils invalides | Refuser liste vide, clés ambiguës en casse, contextes dupliqués | 3/3 |
| Candidat de registre altéré | Refuser trois altérations ciblées | Trois refus ; inversion exacte et idempotence |
| Deux bases réelles | Préserver le contenu non ciblé et tous les états manuels | Six tâches par base ; 42 601 autres lignes, 42 607 états et 23 historiques conservés |

Le cas de priorité distingue tous les contextes locaux, recherchés avant tous les contextes base pour les chemins ; il ne prouve pas l'ordre réel des montages. La comparaison et les boucles de recherche originales s'exécutent ; stockage de chaînes, allocations, singleton vide et cookie restent des frontières documentées dans les lecteurs existants. 160 adresses du résolveur et 2083 adresses du lecteur ont été visitées, sans équivalence avec une couverture complète du moteur.

## Intégration aux consommateurs réels

Les cinq fiches Braum, Kalista, Lulu, Rengar et Zac, plus SYS-01.2-02, sont enrichies dans le registre et les deux bases du plan. 22 liens natifs et 5 nouvelles sources de preuve sont enregistrés. Les liens vers les consommateurs Rust existants sont conservés ; aucun nouveau consommateur de jeu ni descripteur n'est ajouté. Le lecteur réel du plan, ses instructions copiables, ses résumés et la résolution des traces sont contrôlés après écriture.

Le helper `tools/project-plan/original_skin_provider_reference.py` sert à lire le comportement natif dans les tests ; il ne constitue pas un chargeur intégré au client Rust. Aucun code ni asset de jeu n'est modifié. Aucun passif, champion, rendu, audio, session réseau ou jeu complet n'est accepté sur la base de cette preuve.

## Exécutions et stockage

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| V679_ACTOR_PROVIDER_COMPOSITION | 0 | f3f7dffd88bcf3ea7272bbd521294bdbffa516fbabdacc272f16da945733ee0d |
| V679_SNAPSHOT_LZX_CLOSED | 0 | 4e57a16b2f7e1c85e9d7ebe640d3fedf43113952bf5589af3bea5107c96f15b6 |
| V679_ASSOCIATIONS | 0 | 7dfc0ee63eac6bb0fbd40321bbd8327a51fa7e1c2d59f307c2042bed77b81673 |
| V679_PREPARE | 0 | 6b8ed567cf5a0ae50ef38851ba3f1d3cbf11a09596e2c3c1dcc6513e8fda5fc9 |
| V679_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V679_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V679_DELIVERY_AUDIT | 0 | f3825e470bab7bcee7413ad101bfe989dd2a246cc97b44adfa369c38f0d1889b |

La première tentative de compression s'est arrêtée avant modification parce qu'un WAL était présent (code1, journal SHA256 `769b7eb17c0e857b3e049f4cc68db27680e6f8a7c0204b1cc56287b4b26f467a`). La vérification suivante a confirmé des WAL de zéro octet et obtenu un accès exclusif aux copies. Six anciens snapshots de test, aux chemins explicitement identifiés, ont été compressés en LZX ; tailles logiques et SHA256 sont identiques avant/après. Gain d'allocation mesuré : **1714278400 octets**. Aucun fichier supprimé ; bases du plan exclues de cette opération. La réserve de préparation de 4Gio sur C a été conservée.

## Sources, livrables et limites

- Binaire original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Résultat détaillé : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision679_actor_provider_composition\OBSERVATIONS.json`, SHA256 `24346ab03403c25187e9db65d1ac341918f7f6ba21ef25fd84c001ae307abd12`.
- Source et adaptateurs exécutés : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision679_actor_provider_composition.py` et les sources pinées dans l'observation.
- Registres modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`.
- Associations : `docs/reference_requirement_trace_sources/native-actor-provider-composition-v679.json` ; audit livré : `docs/fidelity_native_actor_provider_composition_v679.json`.
- Couverture/reprise : `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`.

Critères, dépendances, inconnues, notes, cases, historiques et preuves antérieures conservés. Pas de test Cargo complet, de client original complet, d'affichage GPU ou d'écoute dans cette étape. Les inconnues de serveur, montage et activation restent ouvertes.

## Prochaine action

Continuer SYS-01.2-02 sur F:/OpenLeague. V679 est publié et audité : 420 compositions natives alias7522B0/Contains9041E0, 80 recherches, quatre priorités diagnostiques et trois refus. Les méthodes natives et le transfert explicite nom/résultat sont vérifiés ; la vtable10D64A8 possède bien le slot+28 vers9041E0, mais son rattachement au champ acteur+3C reste non démontré. Ne pas rejouer les inventaires ni ces requêtes. Rechercher le producteur réel du champ acteur+3C et le chemin depuis le fournisseur personnage+20 de V167/V168, sans supposer identité de ces objets ; qualifier les écritures et leurs types à partir de fonctions alignées, puis relier le consommateur actuel. Examiner les preuves existantes de chargement de personnage et de native_config_resource_dispatch avant tout nouveau contrat. Les douze noms absents et limites de montage/déclenchement/audio restent ouverts. Conserver les cases et historiques. Six copies SQLite de test closes sont désormais compressées en LZX avec empreintes identiques ; première tentative refusée pour WAL présent mais vide conservée. Réserve C minimale4Gio et réserve F atomique maintenues ; aucun fichier supprimé. Goal actif.
