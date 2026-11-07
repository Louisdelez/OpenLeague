# SYS-01.2-02 — Fournisseur de ressources courant, V678

Date UTC : 2026-10-27T13:10:21.151187+00:00. Projet F:/OpenLeague. Référence native : PUBLIC 4.20.0.315, EUW/en_GB. V677 a modifié les associations et les bases avec preuves ; il est classé comme progression et son état courant a été relu.

## Résultat intégré

Les **56 cas natifs** de population, recherche locale et recherche par contextes ont été fraîchement rejoués : deux tables de population, trente recherches locales et vingt-quatre recherches de contexte/délégation. Les résultats concordent avec les contrats conservés. Les fonctions Rust exactes `Provider::from_native_files`, `resolve`, `contains` et `SearchProvider` sont ensuite exercées sur ces contrats et sur le catalogue déclaré du client.

Le catalogue embarqué fournit **25 198 lignes**, produisant **46 595 entrées**. Chaque entrée est recherchée avec sa casse d'origine et en majuscules ; le chemin retourné conserve la valeur attendue. Le contrat de fusion globale natif est hérité après contrôle de son identité, **pas rejoué dans son intégralité**. Le préfixe fonctionnel Rust est compilé sans modification de ses méthodes ; le parsing serde et le démarrage Bevy du constructeur complet ne sont pas exécutés.

Pour **40 noms**, quatre profils donnent **160 résultats**. Les douze noms de préchargement non résolus ne sont trouvés dans aucun de ces profils. **210 compositions** du fournisseur avec le module de variantes de skin concordent avec les sorties natives V677 ; ces sorties de 7522B0 sont héritées, tandis que la composition Rust est exécutée maintenant. **Cinq refus** passent.

Les six fiches reçoivent **22 liens natifs**, **6 sources de preuve** et **quinze liens vers trois consommateurs déjà recensés**. Aucun descripteur n'est modifié, aucun consommateur fonctionnel nouveau n'est créé et aucun état d'acceptation n'est promu.

## Portée des profils

| Profil | Noms trouvés parmi les 40 | Noms non résolus trouvés |
|---|---:|---:|
| declared_global | 3 | 0 |
| map_with_declared_global | 3 | 0 |
| reversed_global_diagnostic | 3 | 0 |
| selected_native_files_diagnostic | 9 | 0 |

- **declared_global** : lignes et ordre du catalogue réellement inclus par le code, pas tout le contenu du client historique.
- **map_with_declared_global** : table locale Map10 reliée à la recherche globale, assemblée avec les méthodes exactes et les entrées explicites ; le constructeur Bevy complet n'est pas lancé.
- **reversed_global_diagnostic** : même inventaire dans l'ordre inversé, uniquement pour observer l'effet sur ces recherches. Il ne remplace pas l'ordre déclaré et ne prouve pas une priorité historique générale.
- **selected_native_files_diagnostic** : fichiers exacts correspondant aux noms examinés, présents et conformes aux manifestes ; ce contexte est fourni au test, pas découvert comme package effectif d'un acteur.

| Ressource de contrôle | Catalogue global déclaré | Fichiers natifs sélectionnés |
|---|---|---|
| Braum_Base_P_Stun_tar.troy | Non | Oui |
| Braum_Skin01_P_Stun_tar.troy | Non | Oui |
| Kalista_Base_P_Spear_Channel.troy | Oui | Oui |
| Kalista_Skin01_P_Spear_Channel.troy | Oui | Oui |
| LuluSignalNovaReverse.troy | Oui | Oui |
| Rengar_Base_P_Leap_Grass.troy | Non | Oui |
| Rengar_Skin01_P_Leap_Grass.troy | Non | Oui |
| Rengar_Skin02_P_Leap_Grass.troy | Non | Oui |
| Zac_W_Chunk_Splat.troy | Non | Oui |

Ce constat distingue les ressources disponibles de celles inscrites dans le catalogue global actuel. Il ne justifie pas de mettre toutes les ressources des champions dans ce catalogue : les contextes propres aux personnages et leurs priorités restent à qualifier.

## Noms logiques, chemins et contextes

La population native et le code Rust enregistrent un alias `.troy` pour un fichier `.troybin`. Le chemin logique retourné peut donc se terminer par `.troy`, alors que le payload physique vérifié se termine par `.troybin`. Ce décalage n'est pas une preuve de fichier perdu ; l'ouverture par le répartiteur binaire est une étape distincte.

Le fournisseur local et le fournisseur de recherche conservent leurs différences : une entrée locale au chemin vide existe pour `contains`, mais la recherche par contextes saute les chemins vides pour `resolve`. Avec **zéro contexte**, `SearchProvider::contains` ne consulte pas le parent, alors que `resolve` peut encore y trouver un chemin. Ces cas sont exécutés contre les fonctions natives et reproduits par Rust ; aucune simplification artificielle ne les masque.

Les sources natives directement liées sont **18 fichiers** conformes aux manifestes, comprenant le binaire, huit preloads et neuf ressources de contrôle. Les tables locales des contrats natifs sont des entrées de test explicites. L'énumération historique, l'ordre des archives et le montage de l'acteur ne sont pas établis par ces tests.

## Consommateurs et appels actuels

Les liens ajoutés pointent vers les trois descripteurs existants :

- OLC-83dcbd49-8347-5a3c-869e-675a90b891bf : insertion ordonnée des noms et alias.
- OLC-e414d90b-8dd9-5156-9176-45b2282784ae : recherche locale d'un nom.
- OLC-ad85fc57-f93e-5c1f-a722-742b7474e0e8 : recherche ordonnée par contextes.

Tous conservent `provides_feature_consumer=false`. Le code `main.rs` déclare le module et appelle `.init_resource::<map_resource_provider::Map10Catalog>()` ; cette liaison est observée statiquement, sans lancement du client. Le catalogue des reliques possède aussi `source_from_provider`, avec des usages retrouvés dans ses tests. Cela ne prouve pas le branchement du fournisseur aux passifs de Braum, Kalista, Lulu, Rengar ou Zac. Les liens V677 vers le résolveur de skins restent conservés.

## Attendu et observé

| Contrôle | Attendu | Observé |
|---|---|---|
| Population/recherche native | Rejouer les contrats d'origine sans réécrire les preuves | 56 cas conformes ; fichiers des contrats inchangés |
| Catalogue courant | Retrouver toutes les entrées et valeurs, sans confondre casse des clés et chemins | 46 595 entrées comparées dans deux casses |
| Noms étudiés | Garder absences et choix de contexte explicites | 160 résultats conservés ; aucune des douze références non résolues trouvée |
| Composition alias/fournisseur | Retrouver les requêtes et sorties natives V677 | 210 comparaisons réussies |
| Entrées hors contrat | Refuser doublon de clé insensible à la casse, clé non-ASCII, chemin à la place d'un basename, recherches non-ASCII | Cinq refus sur cinq |
| Candidate documentaire altérée | Refuser acceptation automatique, suppression d'un consommateur et retrait d'un lien natif | Trois altérations refusées |
| Réversibilité et instructions | Restaurer les documents et la base de test, relire les instructions copiables | Inversion exacte en octets / logique SQLite ; lecteurs réels et idempotence réussis |
| Bases réelles | Préserver tout ce qui n'est pas explicitement ciblé | Six cibles ; 42 601 autres lignes, 42 607 états manuels et 23 historiques conservés dans chacune |

## Essais conservés et exécutions

Deux essais de harness ont échoué avant toute intégration : le premier à la compilation Rust parce que Python avait produit une tabulation littérale dans un caractère Rust ; le second comparait la représentation interne des clés natives et Rust, alors que Rust les stocke en minuscules. Les comparaisons finales passent par les recherches publiques, en vérifiant la casse et les chemins attendus. Les fichiers, programmes et journaux initiaux restent conservés ; ce ne sont pas des réussites.

| Essai conservé | Code | SHA-256 du journal |
|---|---:|---|
| V678_RESOURCE_PROVIDER_AUDIT | 1 | c1d86804a007696b146915b06c4122ee51a9d63834f72c2d1085a0c197a3c794 |
| V678_RESOURCE_PROVIDER_ESCAPED | 1 | 5521c8cfc029a9525190fbaef2b8edf57d0fcb7cdcdf30e4a17d4ce3d9c445db |

| Étape réussie | Code | SHA-256 du journal |
|---|---:|---|
| V678_SNAPSHOT_COMPRESSION | 0 | ec50d9da847ea1261b4353ac73e9e26228575ac45964e4f5deba53540e4bf378 |
| V678_EXTRA_SNAPSHOT_COMPRESSION | 0 | 869710e5d08d1cc7302fef441cd4499b923a3c62817e93f1ff75eed032b7e476 |
| V678_RESOURCE_PROVIDER_LOOKUP_CONTRACT | 0 | d83121899c17e427e481c5665ae33404faeeef3dec58a9e553952e18c521d4ee |
| V678_RESOURCE_PROVIDER_PREPARE | 0 | 0d990aed1d1230f6ecbbce0cae55c33c627877f372c507cdfff419b38eafc1c6 |
| V678_RESOURCE_PROVIDER_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V678_RESOURCE_PROVIDER_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V678_RESOURCE_PROVIDER_DELIVERY_AUDIT | 0 | 54280a845449273471a2b9fc512fb7edaad394658c9bb8b3beb4d424c3b3c7c3 |

Les copies temporaires closes ont été compressées sans suppression et avec contrôle des empreintes avant/après. Une ancienne copie SQLite et un préfixe de candidat échoué V670 ont été conservés et compressés pour rétablir la réserve minimale de 4 Gio sur C.

Le programme Rust et son exécutable sont identifiés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision678_resource_provider_audit_lookup_contract\probe.rs` et `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision678_resource_provider_audit_lookup_contract\provider-probe.exe`. Les versions de compilateur et journaux de compilation/exécution sont conservés. Aucun test du workspace complet, client historique complet, GPU ou écoute n'est revendiqué.

## Fichiers et preuves

- docs/completion_tasks_2026-10-20.json : contextes et instructions des six tâches.
- docs/fidelity_requirement_trace_4_20.json : sources et quinze liens vers les consommateurs existants.
- docs/fidelity_sources_4_20.json : nouvelles preuves, anciens descripteurs inchangés.
- docs/reference_requirement_trace_sources/current-resource-provider-requests-v678.json et docs/fidelity_current_resource_provider_requests_v678.json : associations et vérification après publication.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision678_resource_provider_audit_lookup_contract\OBSERVATIONS.json : profils, noms, sources, sorties, limites et essais natifs.
- docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md : couverture et reprise.
- Les bases SQLite du projet et de l'application de bureau sont mises à jour et relues.

Aucun code ni asset de jeu modifié. Inconnues, critères, dépendances, cases, notes, historiques et anciennes associations préservés. Aucun passif, champion ou jeu complet déclaré terminé.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V678 publié et audité : 56 cas natifs de population/recherche fraîchement rejoués, méthodes Rust exactes comparées ; 25 198 lignes du catalogue déclaré produisent 46 595 entrées vérifiées dans deux casses. 40 noms dans quatre profils, 160 résultats, 210 compositions alias/fournisseur et cinq refus réussis. Aucun des douze noms non résolus trouvé. Le profil global/Map10 résout les contrôles Kalista Base/Skin01 Spear_Channel et LuluSignalNovaReverse, pas les contrôles physiques Braum/Rengar/Zac, disponibles dans un contexte diagnostique distinct. Quinze liens vers trois consommateurs de bibliothèque existants ajoutés ; aucun dispatch de passif accepté. Suite : inspecter les preuves existantes FIDELITY_CHARACTER_PROVIDER_RESEARCH_V167.md et FIDELITY_PROVIDER_FACTORY_GRAPH_V168.md, puis le package propriétaire de 7522B0 (acteur +0x3c, méthode virtuelle +0x28), ses producteurs de contextes et les consommateurs actuels correspondants. Conserver la distinction catalogue global Map10, ressources propres au personnage et namespace/package ; ne pas ajouter arbitrairement tous les champions au catalogue global. Relier la résolution logique .troy au répartiteur binaire .troybin si la source effective le justifie. Éviter de refaire les inventaires et les contrats déjà qualifiés ; approfondir les appels/montages encore non reliés. Préserver critères, cases, notes, historiques et limites V674-V677. Les essais de harness V678 échoués sont conservés ; réserve C minimale 4 Gio et publication atomique avec réserve F. Goal actif.
