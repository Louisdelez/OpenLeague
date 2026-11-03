# SYS-01.2-02 — Chaîne audio native candidate de Katarina, V671

Date UTC : 2026-10-27T10:43:57.773950+00:00. Référence PUBLIC 4.20.0.315 EUW/en_GB ;catalogue 4.20.1 distinct. Projet F:/OpenLeague. Lot de traçabilité, sans acceptation de gameplay.

## Résultat intégré

La fiche CH-Katarina-PASSIF-PRESENTATION-AUDIO et SYS-01.2-02 sont enrichies dans le registre et les deux bases du plan. Six liens natifs précis complètent l'inventaire V670. Les instructions copiables exposent les médias disponibles, le chemin actuel qui exclut la particule et les preuves encore nécessaires.

La chaîne démontrée est : **KatarinaPassive.preload → katarina_spell_refresh_indicator.troy → SoundOnCreate → événement 3296454057 → action 819621714 → conteneur 622013009 → quatre sons/médias natifs.** Tous les six fichiers natifs utilisés correspondent aux manifestes sélectionnés. Les 21 champs d'identifiants du graphe sont comparés aux octets de la banque.

## Alias et déclenchement encore ouverts

Le fichier du personnage déclare **Passive1LuaName=Voracity** et l'icône Katarina_Voracity.dds. Le chunk client KatarinaPassive.luaobj déclare BuffName=KatarinaPassive et la même icône. Son initialisation est lue ;il ne contient aucune fonction enfant. Ce rapprochement et son preload constituent une piste native précise, mais ne prouvent pas l'alias effectif Voracity/KatarinaPassive ni l'appel serveur qui déclenche la particule.

Le script communautaire CharScriptKatarina inspecté est vide. Les recherches littérales dans le Rust core/client et les scripts communautaires n'ont pas de correspondance pour le nom de particule, KatarinaPassive ou Voracity. Cela ne démontre pas l'absence de tout comportement dynamique ou indirect.

## Médias disponibles

Le champ System.SoundOnCreate nomme **Play_sfx_Katarina_KatarinaPassive_buffactivate**. Les champs SoundPersistent, SoundEndsOnEmitterEnd et SoundsPlayWhileOffScreen sont absents de cette particule ;aucune valeur par défaut n'est inventée.

Les quatre plages DIDX de la banque audio sont extraites exactement. vgmstream les décode en WAV PCM16, mono, 44 100 Hz. Les échantillons sont non nuls ;les SHA du WEM, du WAV et du PCM, les offsets et les sorties du décodeur sont conservés.

Une seconde conversion des quatre WEM produit des WAV identiques en octets. L'exécutable et ses onze DLL voisines sont identifiés et rehachés avant/après. Le reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision671_decoder_repeat\OBSERVATIONS.json décrit cette répétition ;il ne prétend pas tracer chaque DLL chargée dans le processus ni valider une écoute.

| ID média | Trames | Durée en secondes | WAV de référence |
|---|---:|---:|---|
| 187636753 | 120969 | 2.7431 | [187636753.wav](F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision671_katarina_audio_audit/media/187636753.wav) |
| 429148165 | 147132 | 3.3363 | [429148165.wav](F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision671_katarina_audio_audit/media/429148165.wav) |
| 728675640 | 153881 | 3.4894 | [728675640.wav](F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision671_katarina_audio_audit/media/728675640.wav) |
| 757769698 | 144451 | 3.2755 | [757769698.wav](F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision671_katarina_audio_audit/media/757769698.wav) |

Ces fichiers sont des preuves de disponibilité, pas des assets branchés au jeu. Le conteneur natif CAkRanSeqCntr et ses champs sont conservés ;les quatre médias ne sont ni joués ensemble ni remplacés par un tirage uniforme. Les conditions et probabilités de sélection, boucles, mixage, bus et spatialisation restent à qualifier.

Le candidat Stop_sfx_Katarina_KatarinaPassive_buffactivate donne l'ID1802386383 ;il n'est pas trouvé dans la banque d'événements de base examinée. Cela ne qualifie pas la politique d'arrêt globale.

## Code actuel réellement inspecté et exercé

Les fonctions event_id et candidate_stop_name de crates/core/src/audio_release.rs sont extraites exactement et compilées dans une sonde Rust isolée. Le préfiltre et les branches du lookup de crates/client/src/map_audio_requests.rs sont également exercés avec un adaptateur Cue et un retour de texte explicites ;les chemins include_str sont relocalisés sans changer leurs contenus. Le parseur JSON, l'ordonnancement Bevy, le client complet et le matériel audio ne sont pas exécutés.

Le préfiltre exige le préfixe **Audio-Emitter_** : il ignore katarina_spell_refresh_indicator.troy. Le lookup ne contient que cinq ressources ambiantes et refuse ce nom avec **unqualified ambient particle**. Ce résultat prouve l'exclusion par ce chemin inspecté ;il ne démontre pas l'absence universelle d'un autre chemin.

La sonde passe 11 contrôles dont 5 refus : hachage natif exact, casse ASCII, caractères non ASCII, NUL, longueur259, limite258, chaîne vide conforme au code actuel, filtrage des trois entrées, lookup nominal, lookup Katarina refusé, lookup inconnu refusé. Build et exécution retournent0. Aucun helper de hachage ou route ambiante n'est promu en consommateur complet du passif.

## Contrôles de livraison

Le candidat refuse une modification de case, la suppression d'un consommateur et la suppression d'un lien natif. Son delta inverse restitue les six documents en octets exacts ;l'inversion SQLite restitue l'état logique antérieur sur copie. La synchronisation normale est idempotente.

Pour chaque base publiée :**2 lignes ciblées**, **42 605 autres lignes**, **42 607 états manuels** et **23 entrées d'historique** conservés. Store.task, Store.copy_text, Store.summary et la résolution de trace sont réellement exercés. Identités, hiérarchie et inconnues restent identiques en octets. Le registre comporte 99382 sources et5 605consommateurs ;les sources hors périmètre ne sont pas toutes rehachées dans ce lot.

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| V671_KATARINA_AUDIO_AUDIT | 0 | 71d646965153a406cb1a7c95d02b8afee7d29596a66dda6fa078f66d36d0458c |
| V671_AUDIO_DISCOVERY | 0 | b6a0cf8d60137f2c6699d445dcb257194da99fdc080c8b56107f0837d8310736 |
| V671_DECODER_REPEAT | 0 | 8ce84803cf7abf53c722c9a63f2fc13c0d28e237ab600a7db8058f8e5a0ea40d |
| V671_KATARINA_AUDIO_PREPARE | 0 | 2e5f5cdbe9d19506b629c6fb8a6ec774090bdd26da6258d8397999a605cbd575 |
| V671_KATARINA_AUDIO_CHECK | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V671_KATARINA_AUDIO_PUBLISH | 0 | b002a20fafc1d740b8bc7afd301ee2eeeca45d20dfbcadd15b3f06daeb456984 |
| V671_KATARINA_AUDIO_DELIVERY_AUDIT | 0 | 11a6bcb44fbca61f96d263db49d88c76ee232d5d4db10a490ea7d75e24a6c132 |

## File de recherche suivante

Une recherche bornée dans les Troy natifs trouve74 fichiers conformes aux manifestes,78 champs audio nommés et34 événements distincts contenant passive/pyromania/twindisciplines. Le reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision671_passive_audio_discovery\CANDIDATES.json conserve les chemins, champs, octets et limites. C'est une file de candidats lexicaux, pas une liste d'associations acceptées :WPassive, BasicAttackPassive, NightmareBot et les skins doivent être qualifiés individuellement.

## Fichiers et limites

Modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ;deux lignes dans chacune des bases du plan ;couverture, plan, reprise et notes courtes. Ajoutés : ce rapport, docs/fidelity_Katarina_passive_audio_chain_v671.json, docs/reference_requirement_trace_sources/Katarina-passive-audio-chain-v671.json et les preuves privées revision671_* sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

Avant publication, six anciennes archives JSON ont été compressées sans perte avec SHA inchangés, sans suppression. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision671_lossless_archive_storage.json. La publication vérifie une réserve globale et par document, puis écrit par blocs64Kio dans des fichiers temporaires contrôlés avant remplacement atomique. Les copies de validation sont sur C ;les preuves durables et les deltas sont sur F.

Aucun code/asset de jeu modifié, aucune case cochée, aucune inconnue fermée. Pas de test d'écoute ou de partie complète. Le passif et le goal restent incomplets.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V671 Katarina publié/audité :6liens natifs, événement3296454057 et4médias décodés ;2lignes ciblées parbase, cases/notes/historiques conservés. Le personnage déclare Voracity ;le bundle KatarinaPassive partage Katarina_Voracity.dds et précharge katarina_spell_refresh_indicator.troy. Alias effectif et déclenchement serveur restent ouverts. Le filtre réel map_audio_requests.rs ignore ce nom ;son lookup le refuse. Sonde isolée des fonctions de hachage/préfiltre/match :11contrôles dont5refus ;pas de Bevy ni écoute. Suite : utiliser revision671_passive_audio_discovery/CANDIDATES.json,74fichiers natifs avec78champs et34noms événementiels. Qualifier les chaînes natives des autres passifs, leurs alias et leurs consommateurs précis. Les noms WPassive, BasicAttackPassive et les variantes NightmareBot/skin ne doivent pas être attribués automatiquement au passif du champion. Conserver les inconnues V670 Malzahar et les priorités de banque ;aucun son à reconstruire tant que nécessité et absence ne sont pas établies. Publication :toujours exiger une réserve globale/per-document, écrire les gros JSON par blocs64Kio dans un temporaire, vérifier SHA puis remplacer atomiquement. Les anciennes archives sont conservées ;compression NTFS sans changement de contenu uniquement si nécessaire. Goal actif.
