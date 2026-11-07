# SYS-01.2-02 — Portraits natifs et composants CPU actuels, V688

UTC 2026-10-27T18:39:54.300253+00:00. F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Le tour précédent V687 est une progression publiée et auditée : choix borné des noms et identités/en-têtes de douze portraits. Ce lot vérifie des consommateurs actuels précis sans transformer leur disponibilité en chargement standard terminé.

## Résultat concret

Trois modules de production inchangés — relic_texture_name, relic_texture_reference_cache et relic_image_reference_store — sont compilés tels quels dans un nouvel exécutable isolé. Il charge les douze DDS originaux, crée leurs ImagesCPU, conserve le payload et les mip counts, compare36hashes, exerce les hits sans nouveau décodage, les références résidentes et le nettoyage. Six refus sont exécutés : DDS invalide, en-tête tronqué, mauvaise signature, image retirée hors propriétaire, lease d’un autre store et lease après nettoyage forcé.

Les36hashes de référence proviennent d’une nouvelle exécution originale8E50F0 sur les noms demandés, résolus et résolus en majuscules des douze portraits ; aucune feuille adaptée pour ce hash. Les providers V686 et sélecteurs V687 restent des preuves héritées, sans nouveau bootstrap ni appel98A7F0 complet.

Le constructeur original9B65E0 retourne pour les douze sources. Allocation, free et cookie de sécurité sont des feuilles explicites ; les instructions natives exécutées restent comparées au PE. Onze tables de mipmaps correspondent à la formule ceil de taille du fichier ; une comparaison échoue et reste ouverte. **Le reçu d’échec n’est pas remplacé par un succès de parité.** Le lecteur d’associations vérifie que les observations reproduisent exactement cette différence.

| Source | Format natif | Format ImageCPU actuel | Mips | Table native / formule du fichier | Octets après fin native |
|---|---:|---|---:|---|---:|
| Ahri:0 | 3 | Bgra8Unorm | 1 | égaux pour cette formule | 0 |
| Ahri:1 | 3 | Bgra8Unorm | 1 | égaux pour cette formule | 0 |
| Braum:0 | 2 | Bc3RgbaUnorm | 1 | égaux pour cette formule | 0 |
| Braum:1 | 0 | Bc1RgbaUnorm | 1 | égaux pour cette formule | 0 |
| Kalista:0 | 0 | Bc1RgbaUnorm | 1 | égaux pour cette formule | 0 |
| Kalista:1 | 2 | Bc3RgbaUnorm | 10 | écart ouvert | 288 |
| Lulu:0 | 3 | Bgra8Unorm | 1 | égaux pour cette formule | 0 |
| Lulu:1 | 3 | Bgra8Unorm | 1 | égaux pour cette formule | 0 |
| Rengar:0 | 0 | Bc1RgbaUnorm | 1 | égaux pour cette formule | 0 |
| Rengar:1 | 3 | Bgra8Unorm | 1 | égaux pour cette formule | 0 |
| Zac:0 | 2 | Bc3RgbaUnorm | 1 | égaux pour cette formule | 0 |
| Zac:1 | 0 | Bc1RgbaUnorm | 1 | égaux pour cette formule | 0 |

## Écart précis : Kalista skin1

Source : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Kalista\Skins\Skin01\KalistaLoadScreen_1.dds ; 231408octets ; SHA256 848f071fc469a9b8b3bd4cd154bd877b9c3572b7b220bd6b259cbd0106daf767. Dimensions308×560, DXT5, dix mipmaps.

Table native, offsets relatifs à l’entrée DDS : [128, 172608, 216288, 227488, 230208, 230848, 231040, 231072, 231088, 231104, 231120].

Table de la formule ceil par hauteur pixel de chaque mip : [128, 172608, 216288, 227488, 230368, 231088, 231328, 231360, 231376, 231392, 231408].

9B6A83 lit le nombre initial de lignes de blocs,9B6A91 le décale par niveau,9B6AB9 le borne à1. Le pitch horizontal9B6950 arrondit séparément la largeur. Pour la hauteur de base560, le nombre140 est décalé, ce qui diffère du recalcul ceil(height_mip/4) à certains niveaux. La fin native est231120, la fin du fichier231408 :288octets restent après cette table. Les octets de la source copiés en mémoire du constructeur restent identiques.

Cette comparaison ne prouve ni que le fichier est corrompu, ni que98A7F0/989B10 utilise effectivement ce parseur pour l’écran, ni comment les mips sont réellement consommés par le GPU actuel. L’ImageCPU actuelle conserve tout le payload ; ses offsets GPU ne sont pas exercés. Aucun fichier DDS, calcul natif ou consommateur de production n’est modifié pour masquer l’écart.

## Consommateurs et limites de portée

Quatre nouveaux descripteurs identifient les fonctions actuelles réellement appelées par la sonde :

- crates/client/src/relic_texture_name.rs:13 — pub fn cache_key( ; OLC-8dafc174-18c9-5315-9ddf-95e1552c342b
- crates/client/src/relic_image_reference_store.rs:23 — pub fn acquire_dds( ; OLC-1dfcb9b9-e720-50de-8c2d-0f73abcf33ed
- crates/client/src/relic_image_reference_store.rs:67 — pub fn release( ; OLC-16b8e718-bb7d-5f06-9f36-8b6047f24f7a
- crates/client/src/relic_image_reference_store.rs:82 — pub fn cleanup_renderer( ; OLC-533c8c35-5aa3-545c-aac0-6d3e5197e3eb

Ils restent entry_boundary_only, provides_feature_consumer=false, feature_scope_complete=false et gameplay_accepted=false. La sonde appelle directement ces composants ; le caller normal initialize_standard_record_owned ne les appelle pas dans cette exécution et conserve ses erreurs de manager absent, hit sans continuation et miss sans fabrique courante.

Le chemin HUD existant native_hud_atlases::decode et native_hud_portraits::setup est relu comme comparaison de portée ; les portraits HUD120×120 ne deviennent pas l’écran de chargement308×560. Aucun nouveau consommateur de jeu complet n’est déclaré.

Le compilateur et le binaire exécuté sont identifiés dans la preuve. Les bibliothèques Bevy/serde_json sont des artefacts de cache explicitement identifiés, non recompilés ; cela ne requalifie pas tout le workspace ou les sources vendor actuelles. is_srgb=false, samplerDefault et support de toutes les compressions sont des entrées déclarées. Les pixels compressés restent compressés : créationImageCPU et conservation des bytes ne sont pas une décompression pixel, un upload ou un rendu accepté.

## Plan, question ouverte et vérification de livraison

SYS-17.3-01 et SYS-01.2-02 reçoivent13liens natifs,11sources et quatre descripteurs actuels partiels. Le graphe comporte99492sources et5611consommateurs. Aucune case ou acceptation automatique.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 disait encore process-only/V123. Elle décrit maintenant les ancrages partiels vérifiés, l’écart de mipmaps et le raccordement réel qui reste à prouver. La question/résolution précédentes sont ajoutées à question_history, une recherche est ajoutée ; statut open, propriétaire, identités, aspect et champs hors portée restent conservés. Toutes les autres inconnues sont identiques ;26 189restent ouvertes et5517résolues avec leur historique antérieur.

Quatre falsifications de preuve sont refusées : pointer de mip modifié, payload déclaré égal à tort, GPU prétendu exécuté et complétion abusive. Cinq altérations documentaires sont refusées, dont promotion d’un composant partiel et fermeture de la question. L’inversion de tous les documents modifiés, y compris cette question, est byte-exact ; l’inversion SQLite est exacte logiquement. Les lecteurs réels et l’idempotence sont contrôlés sur la copie puis sur les deux bases publiées.42 605autres lignes,42 607états et23historiques manuels conservés. Les prérequis/critères et la hiérarchie restent inchangés.

## Arrêts et exécutions conservés

La première compilation directe s’arrête au linker parce que le répertoire contenant windows.0.52.0.lib n’est pas fourni. La bibliothèque est retrouvée localement ; une version distincte ajoute les répertoires x64, puis compilation et exécution réussissent. Aucun téléchargement ni recompilation globale.

La première version de la sonde DDS contient une faute de syntaxe et n’exécute pas de code natif. La version corrigée sous un autre nom exécute douze constructeurs puis rend code2 à cause de la comparaison Kalista. Ces deux reçus et programmes restent conservés. Les résultats du lecteur d’associations ne suppriment pas cette limite.

| Commande | Code attendu pour l’observation | Code reçu | SHA256 journal |
|---|---:|---:|---|
| V688_CURRENT_STORE | 2 | 2 | b3d9ab0b70483a671080c960434e9f209822b4377a3121a44ba3c2da23d2b656 |
| V688_CURRENT_STORE_LINKED | 0 | 0 | 460c9a3e642ad34715c0f4cc557827b3102b9a125f75b5bc9bcafe690bc160fb |
| V688_NATIVE_DDS | 1 | 1 | 7271f79513afec347dad3308a0bd99f5ad66396e2b0168e462aa11dfda407be5 |
| V688_NATIVE_DDS_CHECKED | 2 | 2 | 6e6d6295bdedb8827aab0398d3babcdfbb6c13f4a4b754f05b703d83ffc856df |
| V688_STORAGE | 0 | 0 | ab634267ead28f35e2ce358e53d7f0c0d96938442e8c4ccc4fb3974cb538a935 |
| V688_EXTRA_RESERVE | 0 | 0 | c8ee1d0e7470fb8dfc8188b843b5aac4c144831deb4b4a247b648057337a954e |
| V688_ASSOCIATIONS | 0 | 0 | c05913541a6b33f0c1ddc22cef5dd12730bfc47eff84c0a5826767e11bcd52e1 |
| V688_PREPARE | 0 | 0 | 132013b8c8d93a780e21fef6921bec23d4fd97af54ad6ea38d55f1a70b35a7ab |
| V688_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V688_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V688_DELIVERY_AUDIT | 0 | 0 | 927c94941ab9518b48c984bfc04ae2ca24e723ca35ffcead6f2310888564b726 |

Code2 du constructeur signifie ici comparaison de parité échouée, pas acceptation. Les phases de préparation, contrôle, publication et audit ont toutes code0 et leur portée reste celle de la traçabilité.

Binaire réellement exécuté : {'path': 'C:\\Users\\loicd\\AppData\\Local\\Temp\\openleague-v688-linked-ncay_do1\\portrait_store_probe.exe', 'bytes': 44404224, 'sha256': '83f66a78dc2a3e34b225574e29bd7cd82c60afbcd83002b9d280cc040ca51888'}. Copie durable byte-identique sur F, non exécutée : {'path': 'F:\\OpenLeague-work\\Requirements_registry_4_20_2026-10-20\\revision688_portrait_store_linked\\portrait_store_probe.exe', 'bytes': 44404224, 'sha256': '83f66a78dc2a3e34b225574e29bd7cd82c60afbcd83002b9d280cc040ca51888'}. EXE natif : {'path': 'D:\\LeagueOfLegendsV2\\4.20\\Client\\League of Legends_UNPACKED\\League-of-Legends-4-20\\RADS\\solutions\\lol_game_client_sln\\releases\\0.0.1.68\\deploy\\League of Legends.exe', 'bytes': 15973880, 'sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'}. Observations : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision688_portrait_store_linked\OBSERVATIONS.json, F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision688_native_portrait_dds_checked\OBSERVATIONS.json et F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision688_portrait_store_execution\NATIVE_HASHES.json ; lecteur vérifié : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision688_portrait_associations\OBSERVATIONS.json.

Trois snapshots SQLite fermés de V687, un ancien census et la copie de binaire sont compressés sans perte, sans suppression : 985184289octets alloués récupérés. Un second census fermé reçoit séparément le même contrôle de contenu. Aucune base active ni source DDS n’est compressée ou réécrite.

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/fidelity_unknowns_4_20.json ; reçu docs/reference_requirement_trace_sources/native-portrait-CPU-chain-v688.json ; preuvedocs/fidelity_native_portrait_CPU_chain_v688.json, ce rapport et les deux bases locales. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md. Aucun code moteur ou asset de production modifié ; aucune compilation complète Cargo, GUI ou acceptation GPU/audio/jeu.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V688 publié :36hashes natifs/actuels,12constructeurs DDS retournés et12ImagesCPU des modules actuels,6refus ;4nouveaux descripteurs partiels reliés au chargement. Ne pas rejouer ces cas ou le bootstrap sans motif nouveau. Lire le rapport pour l’échec natif de comparaison conservé : Kalista skin1, table9B6A60 fin231120 contre formule ceil/fichier231408,288octets d’écart. Le code natif décale le nombre de lignes de blocs initial, alors que la formule du fichier les recalcule par mip. Cela ne prouve pas une corruption ni le routage effectif de l’écran. Suite : identifier le chemin réel98A7F0→989B10 et son choix DDS/parseur/upload ; déterminer si9B65E0/9B6A60 est réellement utilisé pour ce portrait, puis comparer le découpage GPU actuel (Image/Bevy_render/wgpu) à partir des sources/callers existants. Conserver le DDS et la formule actuelle tant que ce routage n’est pas établi. Les composantsCPU actuels existent et sont fraîchement exécutés en sonde isolée, mais initialize_standard_record_owned garde ses erreurs et aucun renderer/écran ne l’est. La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 a été précisée avec historique, reste ouverte ; autres questions/statuts/propriétaires inchangés. Couleur/sampler, montage effectif, bitLE/session/équipe,12noms non résolus et nettoyageGPU restent ouverts. Réutiliser les preuves et la copie de binaire F identique ; ne pas appeler la sonde le jeu complet. Goal actif.
