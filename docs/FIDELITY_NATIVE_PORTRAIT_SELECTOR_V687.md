# SYS-01.2-02 — Choix des portraits et provenance DDS, V687

UTC 2026-10-27T18:04:14.206111+00:00. Projet F:/OpenLeague ; référence PUBLIC4.20.0.315, EUW/en_GB. Le lot V686 publié vérifiait fournisseurs/lectures de configurations sous profil déclaré. Le présent lot relie une demande précise du caller original aux fichiers déjà trouvés et au refus actuel du consommateur Rust. Il ne porte pas le chargement de texture en production.

## Résultat et contrat source

Le code original [57DAF7,57DC62) exécute41cas :28arrêts avant la première instruction du loader98A7F0,12cas de repli pilotés par tokens de statut synthétiques et un arrêt avant la copie9935D0 d’un override trop long. Chaque instruction exécutée dans cette tranche est comparée aux octets du PE épinglé. Aucun corps98A7F0 n’est exécuté et aucun pointeur ne représente une texture historique utilisable.

- Le pointeur emprunté record+1C, s’il existe, donne le bit1 du byte ligne+12 qui sélectionne LE. Son producteur57C930 et la sélection57D77A disposent déjà de preuves antérieures ; ils ne sont pas fraîchement rejoués ici. Les lignes de la sonde sont des entrées diagnostiques.
- Skin0 demande d’abord nomLoadScreen.dds. Les skins non nuls demandent nomLoadScreen_N.dds ou nomLoadScreen_N_LE.dds. Le nom conserve ses octets/casse ; %d utilise l’entier32signé dans la feuille de formatage déclarée. Un skin de bitsFFFFFFFF est un contrôle de cette ABI, pas une acceptation du skin négatif dans le préfixe metadata.
- L’override recipient+1C0 remplace le premier chemin si sa longueur est non nulle. Copies courtes et formateur5C7F10 sont des feuilles explicites. Le cas140octets s’arrête avant9935D0, avec capacité128 et countFFFFFFFF : aucune sémantique de troncature/erreur inventée. Un contrôle127octets passe sous la copie courte adaptée.
- En cas de statut+85 non nul, le bitLE déclenche le variant ordinaire, puis viennent base et UnknownCharacter. Si skin0 porte un bitLE diagnostique et échoue, le prochain nom est nomLoadScreen_0.dds ; on ne déduit pas que cette combinaison survient historiquement.
- Le dernier retour UnknownCharacter est stocké sans retest dans cette tranche. Les pointeurs précédents sont déréférencés ; remplacer un loader absent par null ne produit pas une réussite valide.

## Attendu et observé

Les41listes de requêtes correspondent à un lecteur indépendant des règles de branche. Le provider emprunté, les deux arguments fixes0/1, le mot résiduel opaque, les changements limités à record+20 et les entrées conservées sont contrôlés. Quatre falsifications sont refusées : choixLE modifié, loader prétendu exécuté, complétion globale abusive et mauvais provider.

| Cas | Portée | Requêtes observées |
|---|---|---|
| Ahri:0:flags0 | frontière | AhriLoadScreen.dds |
| Ahri:1:flags0 | frontière | AhriLoadScreen_1.dds |
| Ahri:1:flags2 | frontière | AhriLoadScreen_1_LE.dds |
| Braum:0:flags0 | frontière | BraumLoadScreen.dds |
| Braum:1:flags0 | frontière | BraumLoadScreen_1.dds |
| Braum:1:flags2 | frontière | BraumLoadScreen_1_LE.dds |
| Kalista:0:flags0 | frontière | KalistaLoadScreen.dds |
| Kalista:1:flags0 | frontière | KalistaLoadScreen_1.dds |
| Kalista:1:flags2 | frontière | KalistaLoadScreen_1_LE.dds |
| Lulu:0:flags0 | frontière | LuluLoadScreen.dds |
| Lulu:1:flags0 | frontière | LuluLoadScreen_1.dds |
| Lulu:1:flags2 | frontière | LuluLoadScreen_1_LE.dds |
| Rengar:0:flags0 | frontière | RengarLoadScreen.dds |
| Rengar:1:flags0 | frontière | RengarLoadScreen_1.dds |
| Rengar:1:flags2 | frontière | RengarLoadScreen_1_LE.dds |
| Zac:0:flags0 | frontière | ZacLoadScreen.dds |
| Zac:1:flags0 | frontière | ZacLoadScreen_1.dds |
| Zac:1:flags2 | frontière | ZacLoadScreen_1_LE.dds |
| base_with_LE | frontière | AhriLoadScreen.dds |
| row_absent | frontière | AhriLoadScreen_1.dds |
| other_flag_only | frontière | AhriLoadScreen_1.dds |
| flag_bits_1_and_0 | frontière | AhriLoadScreen_1_LE.dds |
| override_SSO | frontière | ui.dds |
| override_heap | frontière | diagnostic/portrait.dds |
| LE_good | statuts synthétiques | AhriLoadScreen_1_LE.dds |
| LE_fallback_ordinary | statuts synthétiques | AhriLoadScreen_1_LE.dds → AhriLoadScreen_1.dds |
| LE_fallback_base | statuts synthétiques | AhriLoadScreen_1_LE.dds → AhriLoadScreen_1.dds → AhriLoadScreen.dds |
| LE_fallback_unknown | statuts synthétiques | AhriLoadScreen_1_LE.dds → AhriLoadScreen_1.dds → AhriLoadScreen.dds → UnknownCharacter.dds |
| final_unknown_not_retested | statuts synthétiques | AhriLoadScreen_1_LE.dds → AhriLoadScreen_1.dds → AhriLoadScreen.dds → UnknownCharacter.dds |
| ordinary_fallback_base | statuts synthétiques | AhriLoadScreen_1.dds → AhriLoadScreen.dds |
| ordinary_fallback_unknown | statuts synthétiques | AhriLoadScreen_1.dds → AhriLoadScreen.dds → UnknownCharacter.dds |
| base_fallback_base_again | statuts synthétiques | AhriLoadScreen.dds → AhriLoadScreen.dds |
| base_fallback_unknown | statuts synthétiques | AhriLoadScreen.dds → AhriLoadScreen.dds → UnknownCharacter.dds |
| override_keeps_LE_fallback | statuts synthétiques | ui.dds → AhriLoadScreen_1.dds |
| heap_name | frontière | LongDiagnosticChampionNameLoadScreen_1.dds |
| oversized_override_boundary | frontière | arrêt avant copie override |
| base_LE_falls_to_skin0_variant | statuts synthétiques | AhriLoadScreen.dds → AhriLoadScreen_0.dds |
| base_LE_all_fallbacks | statuts synthétiques | AhriLoadScreen.dds → AhriLoadScreen_0.dds → AhriLoadScreen.dds → UnknownCharacter.dds |
| unsigned_skin_formatted_signed | frontière | AhriLoadScreen_-1_LE.dds |
| model_case_preserved | frontière | AhRiLoadScreen_1.dds |
| override_127_bytes | frontière | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.dds |

## Sources DDS réellement présentes

Douze identités de fichiers et leurs128octets d’en-tête sont lus/revérifiés maintenant : signatureDDS, structure124, pixel format32, dimensions bornées, FourCC et empreintes. Elles correspondent aux noms demandés pour six modèles/skins0,1 sansLE et aux requêtes natives de providers conservées dans V686. Ces providers ne sont pas réexécutés ici. Les chemins, identifiants de source et références exactes restent dans la preuve structurée.

| Modèle | Skin | Dimensions | FourCC hex | SHA256 fichier |
|---|---:|---|---|---|
| Ahri | 0 | 308×560 | 00000000 | ebb91765c414cadc62d199b06e2dbf2a4a4b7ca5c6a5703952c56ddf2cf0be39 |
| Ahri | 1 | 308×560 | 00000000 | fc5b87112c680ed965749b08ceded740308f8f67f3dd7d65aa399aeb94ca4d4e |
| Braum | 0 | 308×560 | 44585435 | 84bbb12aa7cc1df80d5f69362159724602ea4617d74335095302e58b943f915f |
| Braum | 1 | 308×560 | 44585431 | 71dc85a3f8c2606d6abbf9efadc597f20def64cffb33a4610bf2f127de0e518d |
| Kalista | 0 | 308×560 | 44585431 | 01c07d3492603b02c887707706e1645e97cdeba3f71764db14a05d72ca62f40d |
| Kalista | 1 | 308×560 | 44585435 | 848f071fc469a9b8b3bd4cd154bd877b9c3572b7b220bd6b259cbd0106daf767 |
| Lulu | 0 | 308×560 | 00000000 | 2268f881c1958e22d90047d173cd5c3fcc4c3b288042f952040b3ff36f470f0e |
| Lulu | 1 | 308×560 | 00000000 | dc96bd962cb8b375c5585d0943cd2c77f2c57781e83839c3411290245ccead85 |
| Rengar | 0 | 308×560 | 44585431 | 25322b8c9498186e8ab8ca9f8f12ccef3af4b8cb6be888508b8d2d8fe38826bd |
| Rengar | 1 | 308×560 | 00000000 | 9444d4540fae986eda058dc8c590dcca5f9bf1135d701658c5ddfc561b8f95d6 |
| Zac | 0 | 308×560 | 44585435 | bdd89b637a8131fb98887af59b75520241d6a9a67320c8c5be6545e612c217a9 |
| Zac | 1 | 308×560 | 44585431 | 5a9c4bbe3a003ea5189df972a3fa72632ab489aca187e057dded812a768ddf7f |

Ces contrôles ne décodent pas les pixels et ne valident pas l’image entière, les mipmaps, le cache ou l’upload GPU. Les six candidats frères nomLoadScreen_1_LE.dds sont absents aux chemins physiques examinés ; aucune absence universelle ni résultat de requête nativeLE n’est affirmé.

## Consommateurs actuels et intégration

Les descripteurs existants initialize_standard_record_owned et audio_loading_resource_cache::resolve restent reliés avec qualification entry_boundary_only. Leur source est relue et hachée. Le caller actuel refuse explicitement manager absent, hit sans suite UI et miss sans fabrique courante. Il n’exécute pas la tranche de portraits : aucun port Rust, compilation Cargo, écran graphique ou gameplay n’a été ajouté ou accepté.

SYS-17.3-01 et SYS-01.2-02 reçoivent13liens natifs et7nouvelles sources de preuve, sans nouveau consommateur global. Les deux bases du plan sont auditées après publication :42 605autres lignes,42 607états manuels et23historiques conservés. Quatre altérations du delta documentaire sont refusées ; inversion exacte et idempotence vérifiées. Identités, phases et registre des inconnues restent byte-exact. Le graphe compte99481sources et5607consommateurs ; l’ensemble du catalogue n’est pas rehaché par ce lot.

## Limites ouvertes

Le producteur historique des valeurs de ligne/bitLE, les conditions de session, le vrai formateurCRT/copie longue, le loader98A7F0 et989B10, les retours nuls, propriétaires/références des textures, le décodage complet et le renderer restent à qualifier. Les12noms de ressources antérieurement non résolus restent ouverts. Un DDS identifié n’est ni une fonctionnalité complète ni une acceptation visuelle/audio/jeu. La localeen_GB de référence ne transforme pas les entrées diagnostiques en session historique.

## Contrôles et fichiers

| Étape exécutée | Code reçu | SHA256 du journal |
|---|---:|---|
| V687_PORTRAIT_SELECTOR | 0 | 70b1cecbe31640bad399f55e8d22d9f0d26e0b279d8ef0f0a161e4e436ca732d |
| V687_PORTRAIT_EDGES | 0 | 6e3d6b0f179d8e0aa94cb032fb6851ac820dda968fb36e9f343ed9db3a6a7fc7 |
| V687_ASSOCIATIONS | 0 | 7ffc0cca51bbed6d240bedb817eb3fc89a201826db0c8f3f026b440bde996d0b |
| V687_SNAPSHOT_LZX | 0 | f92710185db6cafc13f947d17683ce47d79e52a7611e5b659f44857446438dd9 |
| V687_PREPARE | 0 | e047aba73223797343c3ac52a761e852ebb55d460c8baf7b1361f9edd09a7b73 |
| V687_CHECK | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V687_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V687_DELIVERY_AUDIT | 0 | ee50f07836b6e4f13a095474c409f9d45f9ea45160867b638d1e4e29212a205a |

EXE source : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ; SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Tranche native :363octets, SHA256c5105456384a21ace0d7cc23051daacad2b2d3b13d28d0c188563abbcb474a26. Sonde36cas :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision687_loading_portrait_selector\OBSERVATIONS.json ; complément5cas :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision687_loading_portrait_edge_cases\OBSERVATIONS.json ; audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision687_portrait_associations\OBSERVATIONS.json. Les producteurs et sources sont épinglés dans ces reçus.

Six snapshots SQLite fermés de V686/V670 ont été compressés sans suppression, avec mêmes tailles logiques et SHA ; 1713451008octets alloués récupérés. Aucune base active compressée.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-selector-v687.json ; preuvedocs/fidelity_native_portrait_selector_v687.json, ce rapport, les deux bases locales du plan et les documents coverage/completion_plan/resume_checkpoint/CURRENT/HANDOFF. Aucun code moteur ou asset modifié.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V687 publié :41cas des branches57DAF7..57DC62,12DDS identifiés/en-têtes vérifiés, requêtes providers V686 conservées. Ne pas rejouer les41cas ni le bootstrap sans raison nouvelle. Lire le rapport pour les limites de feuilles formatage/copie/statuts et la distinction disponibilité/décodage/rendu. Suite : inspecter98A7F0 puis989150/989B10,98E640/98E010 et leurs propriétaires ; examiner les candidats actuels déjà relus : crates/client/src/native_hud_atlases.rs::decode (Image::from_buffer DDS), native_hud_portraits.rs::setup/update (portraitsHUD120x120) et relic_texture_reference_cache.rs::Cache (propriétéCPU). Leur présence et les enregistrements des plugins dans main.rs ne qualifient pas le chargement standard des portraits308x560. Confronter ces contrats à98A7F0/989B10 et au refus du caller de chargement avant de conclure à une absence de code ou à un raccordement utilisable. Relier leurs contrats aux fichiers disponibles et identifier les frontières native/IO/GPU encore non exécutées. Examiner la production effective du bitLE de la ligne+12 et la suite57C590/registre7514E0 si nécessaire, sans supposer que les données diagnostiques décrivent une session historique. La copie9935D0 des overrides longs, le retest absent de UnknownCharacter, le refcount et les retours nuls du loader restent explicites. Conserver cases/notes/historiques,12noms antérieurs et autres inconnues. Aucun chargement UI, GPU, audio, champion ou jeu complet accepté ; goal actif.
