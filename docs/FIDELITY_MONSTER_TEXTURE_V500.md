# SYS-01.2-02 — Textures des monstres Map10, V500

25 octobre 2026. Projet : F:\OpenLeague. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; littéral de build 2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue officiel 4.20.1 distinct.

## Résultat et périmètre

Sept fiches WORLD-<nom>-PRESENT-TEXTURE reliées aux INIBIN, DDS et UV SKN natifs, au GLB effectivement sélectionné par le catalogue courant et aux points de code existants qui chargent puis matérialisent les modèles. Les prérequis de phase/lot sont consignés dans le reçu ; leur présence n'est pas leur achèvement.

Les sept textures natives sont présentes. Les 2 424 832 pixels du niveau principal et les 26 273 UV ont été comparés. Tous les UV et tous les canaux RGB concordent exactement. Cinq comparaisons RGBA sont exactes ; les deux spectres présentent un écart d'alpha de 1 sur 81 110 pixels chacun, expliqué exactement par deux arrondis de palette DXT5. Aucun asset n'est réexporté ou remplacé. Cette tâche d'association ne termine pas le rendu, les monstres ou le jeu.

## Source et méthode

- Ressources natives : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\<nom>. Les chemins exacts, tailles et SHA-256 des INIBIN/DDS/SKN sont conservés par profil dans le reçu.
- Sélection actuelle : data/4.20/world_animation_manifest.json, cohérente pour ces sept assets avec data/4.20/map10_world.json. La sélection native/GLB de V499 est recontrôlée par identité ; les essais V499 ne sont pas présentés comme rejoués.
- Collecteur revision500_textures.py : lecture INIBIN, plages SKN2 et TEXCOORD_0, extraction du PNG embarqué, décodage Pillow du DDS et comparaison RGBA. Formats qualifiés par ce lecteur : DXT1/3/5 et BGRA8 aux masques observés, lignes serrées. Cubes, volumes, masques ou pitch non qualifiés sont explicitement refusés.
- Les 17 niveaux DDS déclarés ont chacun une plage exacte et un SHA de charge utile et de RGBA décodé. Aucun octet de charge utile ne reste inexpliqué. Le niveau principal est comparé au PNG ; les niveaux supplémentaires ne sont pas déclarés conservés par le PNG.
- Contrôle indépendant revision500_alpha.py : expansion des indices alpha DXT5, calcul entier avec division tronquée et division arrondie au plus proche. Les spectres décodés par Pillow correspondent exactement au premier calcul, les PNG au second. Ce résultat n'identifie pas l'arrondi du GPU historique et ne qualifie aucun décodeur natif.
- Python, modules Pillow, binaire _imaging, scripts et sources sont identifiés dans les preuves. Les ressources sont lues sans exécuter le client 4.20 ou le jeu courant.
- Le fournisseur effectif, le montage des packs/overlays et la priorité RADS native ne sont pas requalifiés par cette comparaison de fichiers. L'existence du GLB sélectionné sur disque ne démontre pas son chargement effectif.

## Consommateurs réels inspectés

Les sept modèles utilisent le chemin catalogue → requête de GLB → scène chargée avec racine actor_fow. Les trois ancres existantes V499 sont réutilisées et six ancres propres à ces fiches sont ajoutées : ordonnancement actor_fow après animation::load_models ; clone du StandardMaterial ; sélection du shader de brouillard ; entrée de matériau standard ; branche alpha ; branche unlit.

actor_fow.rs conserve le matériau de base et met native_draw_mode, factor_mode, alpha_test_enabled et facteurs d'éclairage de l'extension à zéro. Les sept GLB demandent KHR_materials_unlit et doubleSided, omettent alphaMode et n'ont pas de sampler explicite. Les sources locales verrouillées Bevy 0.19.0 établissent le chemin de conversion du matériau, du sRGB et du sampler ; elles ne constituent pas une observation de son exécution.

MeshSkin.Texture correspond au DDS observé pour les sept monstres. SelfIllumination est présent et décodé près de 0.7 (valeur exacte du lecteur consignée) ; Texture1/2/3, GlossTexture et ReflectionMap restent absents dans ces configurations. Une telle absence n'est pas convertie en valeur inventée. SelfIllumination n'est pas assimilé au drapeau unlit.

Le tableau INPUTS du module native_minion_mips.rs contient exactement trois matériaux de sbires et aucun de ces monstres. Il ne fournit donc pas à lui seul de raccordement DDS pour Vilemaw. Ce constat borné n'affirme pas l'absence de tout autre chemin dans le client. L'exporteur local utilise texture.Mips[0] pour le PNG.

## Attendu, observé et limites

| Vérification | Attendu | Observé |
|---|---|---|
| Sept sources et sélection courante | Sources identifiées, aucun fichier supposé manquant | Sept DDS présents, sélection catalogue/GLB cohérente |
| UV | Tous les sommets couverts | 26 273 UV identiques |
| Pixels du niveau principal | Égalité ou écarts mesurés explicitement | RGB identiques ; cinq RGBA exactes, deux écarts alpha attribués aux arrondis |
| Plages DDS | Tous les niveaux stockés expliqués | 17 niveaux décodés, aucune charge utile résiduelle |
| Compteurs mip bruts 0 | Interprétation avec drapeau et taille réelle | Quatre DDS sans drapeau mip, charge utile exactement un niveau ; pas de manque déduit |
| Vilemaw | Comparer la chaîne native à l'image actuelle | 11 niveaux natifs, PNG principal seul ; chargement/sampling effectifs à qualifier |
| Normales | Mesurer sans confondre différence et corruption | Écarts flottants max de 1.1920928955078125e-7 à 1.7881393432617188e-7, effet visuel non qualifié |
| Formats invalides | Refus explicites sur copies mémoire | 12 refus : en-tête, plages top/chaîne, compteur, masques, taille pixel-format, cube, pitch, volume, index/plage/signature PNG |
| Registre public | Refuser mauvais propriétaire, fausse résolution et condition vide | Trois refus validés en mémoire, documents restaurés |
| Instructions du plan | Ne modifier que les fiches concernées | 42 214 comparées : sept modifiées et 42 207 identiques |
| Héritage | Conserver modèles et AI | 14 fiches et 14 questions V499/V498 exactes |

Le matériau natif, l'usage de l'alpha, la fidélité du shader et de l'éclairage, le sRGB, les filtres/mipmaps et la visibilité effective restent à établir puis à observer sur le GPU. Cinq images contiennent de l'alpha inférieur à 255 ; cette donnée ne prouve pas à elle seule une politique de blend ou cutout native. Les deux golems ont des DDS et PNG identiques : les échelles distinctes déjà documentées ne sont pas modifiées. Aucun besoin de reconstruction de texture n'est démontré par la seule différence d'arrondi.

## Exécution, fichiers et preuves

Commandes Python réellement exécutées avec -X utf8 -E -u -B : revision500_textures.py vers revision500_texture_inspection/TEXTURE_OBSERVATIONS.json ; revision500_alpha.py vers ALPHA_ROUNDING.json ; revision500_delivery.py prepare ; revision500_check.py ; revision500_delivery.py publish ; revision500_delivery.py audit. Les codes terminaux sont contrôlés séparément. Aucun nouveau binaire du jeu n'est compilé ou lancé. Aucun GPU, écoute audio, processus historique ou acceptation humaine ne sont revendiqués.

Livrables publics : docs/reference_monster_behavior_sources/monster-texture-v500.json, docs/fidelity_monster_texture_v500.json et ce rapport. Les quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json reçoivent les associations. Les deux bases locales reçoivent seulement leurs données documentaires. docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés avec reprise et limites.

Preuves privées : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision500\PREPARATION.json, SOURCE_LINK_RECEIPT.json, CANDIDATE_CHECK.json, REGISTRATION_RAW_PROOF.json, DELIVERY_AUDIT.json, EXECUTION_ENVIRONMENT.json, DOCUMENTARY_CHECK.json et FINAL_CHECKPOINT.json ; scripts revision500_textures.py, revision500_alpha.py, revision500_delivery.py, revision500_check.py et revision500_finish.py. Les observations brutes conservent chaque format, matériau, pixel/UV, identité et refus. Les versions antérieures restent intactes.

Le contrôle Git en lecture confinée a renvoyé « this operation must be run in a work tree », y compris avec des chemins explicites. La lecture hors de ce confinement, sur F et sans verrou optionnel, a réussi avec le code 0. GIT_OBSERVATION.json conserve le relevé réel et cette limite d'environnement ; aucune configuration Git n'est corrigée dans cette tâche.

Sept questions propres aux textures sont ajoutées avec conditions de résolution. Aucune inconnue, tâche ou case n'est déclarée terminée ; critères, dépendances, notes et historique manuel sont conservés. Le Goal SYS-01.2-02 reste actif. Suite : sept fiches PRESENT-ANIM des monstres, sans assimiler comparaison de fichiers et lecture effective.

Bilan final vérifié : 21 liens natifs, 69 liens consommateurs, 6 ancres, 3 sources, 7 questions ouvertes et aucune résolution. Graphe : 98683 sources / 2567 consommateurs / 25795 questions ouvertes / 5517 résolues avec historique. 97 identités vérifiées. Deux bases : 8 lignes documentaires actualisées chacune, 42 598 autres lignes exactes, 42 606 états/notes et 23 historiques conservés, intégrité ok. Sous-inventaire : 56 à reprendre, 452 partielles, 32 exclusions ouvertes ; ce n'est pas un pourcentage de jeu terminé. Collecte, analyse alpha, préparation, candidat, publication et audit : codes terminaux 0 observés. Aucun échec nouveau.
