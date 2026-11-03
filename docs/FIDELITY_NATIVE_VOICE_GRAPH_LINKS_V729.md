# SYS-01.2-02 — Graphes et médias des voix, V729

Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Les fichiers de voix examinés portent le chemin en_US ; leur sélection historique reste à qualifier.

## Résultat vérifié

Le corpus contient545banques (364BNK et181WPK),2562conteneurs,11055objets sonores,3540actions et8892entrées de médias. Les159489champs retenus sont comparés aux octets originaux. Le parseur communautaire WWiser ne signale aucune erreur ni portion ignorée sur ces364BNK ;cela ne vaut pas validation de toute sa sémantique.

Les3537actions ciblant un conteneur et les3actions ciblant directement un son trouvent leur cible dans leur banque d'origine. Toutes les références d'enfants des conteneurs existent ;les listes d'enfants et de playlists ont le même ensemble d'identifiants. Le graphe de playlist parcouru ne contient pas de cycle.

Les11055objets sonores se répartissent ainsi :
- 10391 : média diffusé trouvé dans le groupe propre.
- 531 : candidat trouvé dans le groupe de base du même champion. La présence est démontrée, la priorité historique de montage ne l'est pas.
- 113 : média embarqué identifié par banque,source,offset absolu et taille. Les entrées DIDX emploient leurs offsets relatifs au DATA ;les deux formes ont été comparées.
- 20 : plugin0x650002 de silence généré, sans fichier média externe. Durée et exécution du générateur restent ouvertes.

Aucun asset absent n'est démontré dans ce périmètre. Les8892entrées ont un en-tête RIFF et une empreinte de contenu ;aucun décodage ou son audible n'est validé.

## Exécution native limitée

Le fragment B1E5E5..B1E742 et ses setters originaux chargent le bloc de28octets sur2562objets initialement nuls. 303adresses exécutées correspondent exactement au PE SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Les compteurs de boucle,modificateurs,bits float des transitions,évitions de répétition,modes et booléens sont comparés à une attente indépendante. Les6conteneurs de mode séquentiel passent également le chemin d'allocation bornée. Les constructeurs complets,propriétés de base,inscription,insertion des playlists,historiques et sélection ne sont pas exécutés.

Trois diagnostics couvrent la boucle nulle,les booléens non canoniques non nuls et le champ de poids sérialisé ignoré par ce fragment. Deux gardes du banc refusent les blocs tronqués ou trop longs ;quatre falsifications de preuves sont rejetées. Les gardes du banc ne prouvent pas les bornes du lecteur historique.

## Consommateurs et intégration

568sources et29points de code courants sont vérifiés. Les consommateurs restent les lecteurs de référence,modèles,contrats et dispatchers d'ambiances existants. Aucun fournisseur complet de voix de champions ou de skins n'est déclaré fonctionnel.

1279fiches (668skins,610voix de champions et SYS) et leurs instructions copiables dans les deux bases sont enrichies. Les cases,notes,historiques,autres tâches,prérequis et inconnues restent inchangés. Les12672demandes de V728 sont reliées aux graphes sources de leurs actions ;les demandes natives ne sont pas réexécutées et leurs tables de cibles étaient vides.

## Limites et essais conservés

- B1E5E5..B1E742 plus native setters executes only on fresh zeroed container state, with bounded pool allocator. Base properties,full object construction/registration,playlist insertion,random selection,history and playback remain open.
- Serialized weight flag is skipped by this fragment; do not use it as the effective native playlist weighting mode.
- 545 original banks,182 declared groups,8892 media entries. Streamed base candidates and embedded bank/source identities are identified; native media provider,mount priority,locale,decoder and audible playback remain unqualified.
- 20 generated-silence objects have no external media. Silence duration/generator semantics remain open. No missing asset is inferred from fileID alone.
- Action targets are followed inside each origin bank for source linkage. V728 still had empty native target registries: these candidates are not promoted to effective historical object selection.
- First source-census attempt stopped on double addition of DATA offset. Checked version uses absolute retained offsets and independent DIDX relative records; failed source retained. A second preliminary qualifier assumed embedded uFileOffset was DATA-relative; exact source values show absolute bank-file offsets. Verified source uses direct comparison; both failed scripts retained.
- No game code/assets modified, no source extracted, no game window or sound run.
- Les1278fiches audio de skins/voix et SYS sont enrichies sans changement des cases,notes,historiques,inconnues ou criteres de fin.
- Les compteurs sound_media_found/unresolved du recensement initial decrivent une recherche naive par fileID dans le groupe propre. La resolution qualifiee distingue113medias embarques,531candidats du groupe de base et20sources de silence ;ne pas presenter les664premiers non-rapprochements comme des assets absents.
- La provenance locale en_US est conservee. Ce corpus ne demontre pas la selection de locale historique EUW/en_GB.
- Les12672demandes et origines d actions sont heritees du recu V728 pine, non reexecutees ici. Le graphe cible est relie dans la banque d origine seulement ;il ne peuple pas le registre natif de cibles.
- Corps de preuve prive conserve une seule fois sur F ;la relecture en depend.

## Livrables

Le [reçu de liaison](fidelity_native_voice_graph_links_v729.json) référence les preuves uniques sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision729_voice_graph_checked/OBSERVATIONS.json, revision729_voice_graph_verified/OBSERVATIONS.json et revision729_graph_associations/OBSERVATIONS.json.

Les deux sources préparatoires en échec sont conservées : une double addition du début DATA dans le recensement,puis une hypothèse erronée de position relative pour uFileOffset. Les sources checked et verified corrigent ces bancs ;aucune source originale n'a été modifiée.

Registres enrichis : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Documents de reprise : coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md. Deux plan.sqlite3 mis à jour par deltas ciblés. Aucun code de jeu ni asset modifié.

Livraison : revision729_delivery/VERIFIED.json ; relecture indépendante réussie dans INDEPENDENT_READBACK.json. Le goal reste ouvert.
