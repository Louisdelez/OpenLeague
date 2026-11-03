# SYS-01.2-02 — Résolution des variantes de skin, V677

Date UTC : 2026-10-27T12:42:46.141794+00:00. Projet : F:/OpenLeague. Référence native : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue des skins : Data Dragon 4.20.1 en_US, conservé comme catalogue distinct. V676 a fait progresser les associations et les bases ; son état vérifié a été relu avant cette exécution.

## Résultat intégré

La fonction native **7522B0** et le module Rust actuel **native_effect_resource_skin_alias::resolve** concordent sur **570 cas fraîchement exécutés** : 360 cas du contrat historique, 174 cas couvrant les douze noms non résolus et les skins officiels des cinq champions, puis 36 contrôles utilisant la disponibilité de fichiers natifs vérifiés.

Les **174 cas des références non résolues conservent le nom d'entrée** : aucun candidat de skin n'est trouvé par l'adaptateur fondé sur les deux manifestes sélectionnés et les payloads correspondants. Quatre contrôles positifs sélectionnent effectivement des variantes disponibles. Ce résultat écarte une résolution automatique par ce mécanisme précis dans ces conditions ; il ne prouve pas l'absence de tout autre chemin de chargement ou d'un appel serveur.

Les cinq fiches et SYS-01.2-02 reçoivent **17 liens natifs** et **5 nouvelles sources de preuve**. Cinq liens relient désormais les fiches au consommateur existant **OLC-7ecb5b1c-ed03-5d97-a27e-bdfdb469a13c**. Son descripteur demeure une frontière de bibliothèque, avec `provides_feature_consumer=false`. Aucun nouveau descripteur ni statut d'acceptation n'est créé. Le nombre de consommateurs reste 5605.

| Champion | Skins du catalogue | Cas des noms non résolus | Contrôles sélectionnant une variante |
|---|---|---:|---:|
| Braum | 0, 1 | 36 | 1 |
| Kalista | 0, 1 | 48 | 1 |
| Lulu | 0, 1, 2, 3, 4 | 30 | 0 |
| Rengar | 0, 1, 2 | 36 | 2 |
| Zac | 0, 1 | 24 | 0 |

## Cas positifs

- Braum : `Braum_Base_P_Stun_tar.troy` → `Braum_Skin01_P_Stun_tar.troy` (skin 1).
- Kalista : `Kalista_Base_P_Spear_Channel.troy` → `Kalista_Skin01_P_Spear_Channel.troy` (skin 1).
- Rengar : `Rengar_Base_P_Leap_Grass.troy` → `Rengar_Skin01_P_Leap_Grass.troy` (skin 1).
- Rengar : `Rengar_Base_P_Leap_Grass.troy` → `Rengar_Skin02_P_Leap_Grass.troy` (skin 2).

Les contrôles de Lulu et Zac conservent leur nom initial quand le nom transformé est absent. La transformation ne supprime pas arbitrairement `skn1`, ne remplace pas `Waena` par `Lulu` et ne remplace pas les suffixes `cas` ou `mis` par `tar`.

## Portée de l'exécution native

Le binaire natif vérifié porte le SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**. Le contrôle de 7522B0 est exécuté dans Unicorn en mémoire isolée ; **160 adresses d'instruction** sont visitées. Les primitives de chaînes, la mise en minuscules ASCII, le formatage, les opérations de remplacement et le cookie de sécurité sont fournis par les adaptateurs conservés et explicités. Il ne s'agit pas d'un lancement du jeu historique complet.

La disponibilité historique est fournie comme booléen explicite pour les 360 cas antérieurs. Pour les cas réels, le callback recherche les noms produits dans les manifestes sélectionnés et vérifie les payloads trouvés. **23 requêtes distinctes** sont conservées. Cette recherche par basename n'est ni le montage natif, ni la table réelle du package propriétaire, ni une preuve de priorité entre fournisseurs. Les treize sources natives directement liées, dont le binaire et les quatre variantes trouvées, correspondent aux manifestes.

## Consommateur Rust et raccordement

Le programme de vérification compile le **fichier Rust réel par référence de module**, sans recopier son implémentation et sans modifier le code du jeu. Les 570 sorties et séquences de requêtes sont comparées aux résultats natifs. Trois entrées hors contrat sont refusées : nom non-ASCII, NUL et identifiant de skin supérieur à i32::MAX ; aucun appel de disponibilité n'a lieu pour ces refus.

La recherche explicite du nom du module et du contrat dans les crates retrouve la déclaration `pub mod` et le test interne. Elle n'identifie pas de déclenchement en partie ; cette recherche littérale n'est pas une analyse exhaustive des imports indirects ou des appels dynamiques. Le lien au consommateur de bibliothèque ne valide pas la production de Owner/skin, le callback package_contains, le montage, le rendu ou l'audio.

Le fournisseur existant `crates/client/src/map_resource_provider.rs` expose `Provider::from_native_files`, `contains` et les contextes `SearchProvider`. Il constitue la prochaine entrée à exercer. Sa lecture statique ne vaut pas un test de montage ; ses contrats natifs restent à relier aux requêtes de ce lot.

## Attendu et observé

| Contrôle | Attendu | Observé |
|---|---|---|
| Contrat historique | Rejouer les 360 cas, sans utiliser les résultats comme simple vérité non testée | 360 exécutions natives fraîches concordantes, puis comparaison Rust |
| Références réelles | Tester tous les skins du catalogue, activation/désactivation et trois types de propriétaire | 174 comparaisons ; aucun candidat sélectionné |
| Fichier de variante disponible | Sélection seulement lorsque le contexte l'autorise et le candidat est disponible | Quatre sélections positives, autres contrôles conservés |
| Entrées non qualifiées | Refuser sans interroger le fournisseur | Trois refus Rust sur trois |
| Liens existants | Conserver les consommateurs antérieurs et ajouter seulement la frontière déjà enregistrée | Cinq liens ajoutés ; aucun descripteur modifié |
| Candidat altéré | Refuser acceptation, retrait de consommateur et retrait de lien natif | Trois altérations refusées |
| Réversibilité | Restaurer exactement les documents et l'état logique SQLite | Inversion documentaire et SQLite réussies |
| Bases réelles | Instructions et associations lisibles sans perte d'état manuel | Six cibles ; 42 601 autres lignes, 42 607 états et 23 historiques conservés dans chaque base ; synchronisation idempotente |

## Exécutions et stockage

La première préparation V677 a échoué pendant une copie SQLite temporaire, avec `database or disk is full`. Son script, ses copies partielles et son journal sont conservés. Les registres et bases réelles étaient inchangés. Quinze copies antérieures supplémentaires ont été compressées sans perte avant une nouvelle préparation dans un dossier distinct. Le reçu de cet essai reste `revision669_V677_SKIN_ALIAS_PREPARE.json` ; il ne compte pas comme réussite.

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| V677_SNAPSHOT_COMPRESSION | 0 | 1a658e96366b0b2eca90b73f0aaccdd67d68ec98eeb5580806ec103be6a70f7b |
| V677_SNAPSHOT_COMPRESSION_EXTENDED | 0 | 14f5af0f723e390bc311b62a8f25e6b60a9fbf3653eba56a423b28c8542a8566 |
| V677_SKIN_ALIAS_AUDIT | 0 | 113771599b8dd42e40061a613ad314fab02de7539b804dff83002e0215234eda |
| V677_SKIN_ALIAS_PREPARE_RECOVERED | 0 | 1e6c99790e0d49988bc1c7912acbce07d072ec9e231077cb214aa186bb24e309 |
| V677_SKIN_ALIAS_CHECK | 0 | 5ef6088a5074137125ea9dd143d73a1979217cd52035c09f1559527113df318b |
| V677_SKIN_ALIAS_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V677_SKIN_ALIAS_DELIVERY_AUDIT | 0 | 5e78bf9cbbc0f53de97a7aa8d8539e99a825412ac5cefafbd00d84b45612e639 |

La compilation isolée et son exécution portent chacune le code 0 ; leurs journaux, version de rustc et identité de l'exécutable sont dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision677_skin_alias_audit\skin-alias-probe.exe` et le même dossier d'audit. Aucune compilation du workspace complet, exécution du client, observation GPU ou écoute n'est revendiquée.

Six anciennes copies SQLite de vérification ont été compressées sans suppression, avec taille et SHA-256 inchangés avant/après. L'espace libre C est passé de 458444800 à 2572382208 octets pendant cette opération. Après l'échec de copie, quinze autres copies ont été compressées et vérifiées ; l'espace est passé de 150831104 à 6227820544 octets. La préparation reprise exige au moins 4 Gio libres au démarrage. La nouvelle zone temporaire V677 est aussi marquée pour compression NTFS. Preuves : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision677_snapshot_compression/VERIFIED.json` et `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision677_snapshot_compression_extended/VERIFIED.json`. Journal de préparation échouée conservé : SHA-256 `3ddb94ad4dfa5aae17e147719a6904bb12c8499d8956f434fdd281680a603c7b`.

## Fichiers et preuves

- docs/completion_tasks_2026-10-20.json : contextes des six tâches.
- docs/fidelity_requirement_trace_4_20.json : sources et cinq liens vers le consommateur existant.
- docs/fidelity_sources_4_20.json : nouvelles preuves ; anciens descripteurs préservés.
- docs/reference_requirement_trace_sources/skin-alias-exact-requests-v677.json et docs/fidelity_skin_alias_exact_requests_v677.json : associations et relecture après publication.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision677_skin_alias_audit\OBSERVATIONS.json : cas, entrées, sorties, requêtes, adaptateurs et limites.
- docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md : couverture et reprise.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 : bases vérifiées.

Les inconnues, dépendances, critères, cases, notes et historiques restent conservés. Aucun code ou asset de jeu n'est modifié. Aucun passif, champion ou jeu complet n'est déclaré terminé.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V677 publié et audité : 570 comparaisons natives 7522B0/Rust réussies (360 historiques rejouées, 174 cas des 12 noms sur skins officiels, 36 contrôles physiques) et trois refus Rust. Aucun des noms non résolus ne sélectionne de variante ; quatre contrôles positifs sélectionnent des payloads conformes. Cinq liens ajoutés vers le consommateur de bibliothèque existant OLC-7ecb5b1c-ed03-5d97-a27e-bdfdb469a13c, sans nouveau descripteur ni dispatch qualifié. Suite concrète : examiner crates/client/src/map_resource_provider.rs, Provider::from_native_files/contains et SearchProvider, leurs appels et les contrats natifs 905090/90A4A0, puis exercer les demandes et variantes avec ce fournisseur réel en conservant l’ordre et les contextes comme entrées explicites. Qualifier séparément le montage effectif et le package propriétaire virtuel +0x28 de 7522B0 ; un adaptateur par basename ne les démontre pas. Inspecter native_missile_resource_selection.rs si le nom fourni au résolveur dépend d’une variante locale/ennemie, sans appliquer ce chemin projectile à tous les passifs. Ne pas reconstruire des effets ni remplacer des noms par proximité. Conserver les limites V674-V676 et les inconnues antérieures, les cases et historiques. Les copies de contrôle C sont compressées sans perte ; utiliser une nouvelle zone compressée pour les prochaines vérifications. Goal actif.
