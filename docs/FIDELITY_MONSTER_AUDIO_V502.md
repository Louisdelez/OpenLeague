# SYS-01.2-02 — Sources et portée audio des monstres, V502

25 octobre 2026 — F:\OpenLeague. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue officiel 4.20.1 distinct.

## Résultat et inconnues

Sept fiches WORLD-<nom>-PRESENT-AUDIO sont enrichies avec leurs ressources natives, recherches, limites et conditions de résolution. Les sept configurations, 17 INIBIN d'attaques/sorts candidats, 17 Lua du boss, 138 ANM/BLND, quatre particules retrouvées et six banques candidates sont inspectés. La recherche courante couvre 498 fichiers Rust du client ; dix contiennent les marqueurs audio recherchés.

Le lien historique vers enable_map10 est conservé mais exclu de la portée sonore de ces sept exigences : charger le monde n'identifie pas un déclenchement de son du monstre. Aucun nouveau consommateur fonctionnel sonore n'est inventé. Sept questions restent ouvertes : producteur natif → événement → action/conteneur → média, sélection/matériaux, montage et locale, puis événement courant et lecture/arrêt/spatialisation/volume/rejeu.

Les 307 médias SFX embarqués ne sont pas démontrés manquants ; leur attribution aux sept monstres n'est pas établie par ce lot. Le manque concret porte sur le raccordement qualifié entre ressources, déclencheurs et consommateurs. Les deux banques VO en_US ne sont pas présentées comme les voix de la référence en_GB. Aucune reconstruction de son, modification d'asset ou implémentation audio du jeu n'est effectuée dans cette tâche d'association.

## Sources natives et méthode

Les sources viennent du deploy fourni : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA. Les chemins exacts, tailles, SHA-256 et relations sont conservés dans le reçu.

- Configurations Characters\<nom>\<nom>.inibin : présence des champs Sounds.Death/Attack/Attack1/2/3/Idle/Move et Data.WeaponMaterial/SelectionCategory relevée par le lecteur INIBIN. Les 49 champs Sounds testés sont absents. Cinq configurations nomment un matériau d'impact ; ce nom n'est pas automatiquement un événement Wwise.
- Dix-sept candidats Spells\*.inibin sont réidentifiés à partir de V497 et leurs champs sonores et particules sont relus. Douze candidats des monstres mobiles portent Sound_CastName=Sound_HitName=none.wav ; les deux champs sont absents des cinq candidats Vilemaw. Ni none.wav ni une absence de champ ne démontrent un gameplay silencieux ou l'absence de defaults/matériaux.
- Dix-sept candidats Lua de Vilemaw sont parsés avec le lecteur borné Lua5.1 ; constantes et prototypes sont parcourus pour des noms sonores. Aucune constante sonore explicite n'est identifiée par le filtre. Ce résultat n'est pas une analyse complète des appels, des noms construits ou du dispatch natif.
- Les 131 ANM et sept BLND des profils sont parcourus pour les littéraux Play_/Stop_. Les particules nommées par les champs des sorts sont recherchées dans DATA\Particles ; quatre fichiers distincts y sont retrouvés et parcourus. Aucun token n'est identifié dans ces ressources ciblées. Cette recherche ne décode pas tous les événements binaires, noms hashés ou producteurs indirects.
- Six banques Wwise sont lues par le lecteur de conteneurs version88 : chunks, inventaire HIRC, identifiants/types, plages DIDX/DATA et SHA des médias embarqués. Le lecteur ne décode pas leur graphe complet de routage ni leur audio.

Les particules globalhit_physical.troy, AnnieBasicAttack_mis.troy, globalhit_bloodslash.troy ou rampage.troy non retrouvées par la sonde de ce répertoire restent des résultats de recherche bornée. Aucune absence globale, corruption ou nécessité de recréer ces ressources n'en est déduite.

## Banques et locale

| Banque candidate | Objets HIRC | Médias embarqués indexés | Portée |
|---|---:|---:|---|
| NPC_Global_SFX_events.bnk | 771 | 0 | SFX partagés, attribution aux monstres non qualifiée |
| NPC_Global_SFX_audio.bnk | 0 | 249 | Médias embarqués présents |
| NPC_Map10_SFX_events.bnk | 261 | 0 | SFX Map10, attribution aux monstres non qualifiée |
| NPC_Map10_SFX_audio.bnk | 0 | 58 | Médias embarqués présents |
| NPC_Map10_VO_events.bnk | 203 | 0 | Candidat en_US, sélection en_GB non démontrée |
| NPC_Map10_VO_audio.bnk | 0 | 0 | Candidat en_US ; seulement BKHD observé |

Les quatre banques SFX sont sous Sounds\Wwise\SFX\Shared ; les deux VO sous Sounds\Wwise\VO\en_US\Shared. Les deux chemins analogues en_GB ont été sondés et sont absents dans ce répertoire du deploy. Cette sonde ne couvre pas tous les conteneurs, overlays, autres déploiements ou fichiers streamés. Zéro média embarqué dans la banque VO audio ne prouve pas zéro voix disponible.

Aucun littéral d'événement n'étant extrait des ressources ciblées, aucune correspondance de hash d'événement n'est produite par ce lot. La fonction analytique FNV-1 suit le contrat ASCII borné de audio_release.rs ; ses refus sont exercés, sans prétendre avoir identifié des événements natifs par un nom inventé. Un identifiant égal ne suffirait pas à prouver une chaîne complète événement → action/conteneur → média.

## Consommateurs actuels inspectés

Les corps de world.rs, animation.rs, main.rs, map_audio.rs, map_audio_requests.rs, native_ambient_parent.rs, pcm_audio.rs et des chemins audio Ezreal Q/R/E sont relus, en complément de la recherche lexicale sur les 498 fichiers client.

enable_map10 charge les définitions et le monde ; l'ancre existante ne sélectionne ni ne joue les sons du monstre. map_audio.rs déclenche notamment des cues de reliques/autels. La table des particules audio ambiantes accepte cinq documents précis et refuse les autres par « unqualified ambient particle ». Le pont PCM représente du transport après admission ; il ne fournit pas à lui seul un producteur de sons de monstres. Les sons d'un impact Ezreal sur un monstre restent des producteurs de sort Ezreal. Le lecteur visuel dédié à Vilemaw n'est pas assimilé à une implémentation sonore.

Ces observations ne prouvent pas l'absence de toute route indirecte dans tout le programme. Elles montrent pourquoi le consommateur historique retenu dans ces sept fiches est insuffisant. Les sept exclusions portent uniquement sur ces exigences audio ; le rôle global de l'ancre et ses autres utilisations restent inchangés. Les sources des chemins audio inspectés restent des références de portée, sans être affichées comme des consommateurs fonctionnels de sons de monstres.

## Vérifications, résultats et refus

| Cas | Attendu | Observé |
|---|---|---|
| Configurations et sorts | Préserver présence/absence et valeurs exactes | Sept configurations ; 24 champs cast/hit de mobiles à none.wav, dix champs correspondants du boss absents |
| Scripts et ressources d'animation | Relever les indices sans inventer leur sémantique | 17 Lua, 138 ANM/BLND et quatre particules ; zéro nom sonore explicite démontré par ces filtres |
| Banques | Plages bornées et version explicite | Six conteneurs version88 ; 307 médias SFX indexés et hashés |
| Locale | Conserver en_GB et les alternatives distinctes | Deux banques candidates en_US, deux chemins en_GB sondés absents ; aucun fallback accepté |
| Lecteur de banque invalide | Refuser sans modifier les sources | Trois refus : BKHD absent, chunk tronqué, version non qualifiée |
| Nom d'événement invalide | Refuser l'entrée analytique non qualifiée | Trois refus : non-ASCII, longueur259, NUL |
| Inconnue invalide | Refuser mauvaise propriété/fausse résolution/condition vide | Trois refus publics sur copies mémoire |
| Exclusion invalide | Refuser feature=true, preuve absente, consommateur absent | Trois refus publics sur copies mémoire |
| Plan | Conserver les sorties non ciblées | 42 214 instructions comparées ; sept changées, 42 207 identiques |
| Héritage | Préserver AI/modèles/textures/animations | 28 fiches et questions exactes |

Les commandes réellement exécutées sont revision502_audio.py, revision502_delivery.py prepare, revision502_check.py, revision502_delivery.py publish et revision502_delivery.py audit avec Python -X utf8 -E -u -B. La fin de chaque commande est observée avant d'enregistrer son succès. Aucun jeu ou runtime audio n'est lancé, aucun média n'est décodé en PCM, aucune écoute ou mesure de sortie audio n'est revendiquée.

Un script exploratoire a d'abord traité profiles de V497 comme un dictionnaire alors que c'est une liste. Il a échoué avant collecte et mutation. Sa version initiale v502_preflight_initial_failed.py est conservée sur E ; l'itération corrigée a ensuite révélé la forme réelle et les sources. La collecte et la publication ne réutilisent pas ce résultat échoué. Les modifications Git antérieures restent conservées ; aucun stage/reset/commit.

## Fichiers et reprise

Les quatre registres docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json reçoivent les associations et exclusions propres aux sept fiches. Les deux bases reçoivent seulement les données documentaires. Les critères, dépendances, cases, notes et historiques sont conservés. docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont mis à jour avec preuves et suite.

Reçu public : docs/reference_monster_behavior_sources/monster-audio-v502.json. Preuve : docs/fidelity_monster_audio_v502.json. Observation brute : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision502_audio_inspection\AUDIO_OBSERVATIONS.json. Scripts et preuves détaillées : revision502_audio.py, revision502_delivery.py, revision502_check.py, revision502_finish.py et revision502\ (préparation, baselines, candidat, publication, audit, environnement, vérification documentaire et reprise). Les versions antérieures restent intactes.

Sept questions et sept exclusions ouvertes sont ajoutées ; aucune inconnue ou tâche n'est résolue automatiquement. Une exclusion de portée n'est pas une fonctionnalité terminée. Le Goal SYS-01.2-02 reste actif. Suite : consolider les sept agrégats PRESENT à partir des facettes modèles/textures/animations/audio, en conservant la frontière sonore et les défauts ouverts, puis poursuivre les exigences encore non qualifiées.

Bilan vérifié : 24 liens natifs, zéro ancre/consommateur sonore ajouté, deux sources, sept exclusions de portée et sept questions ouvertes ; aucune résolution. 740 identités vérifiées. Graphe : 98689 sources / 2581 consommateurs / 25809 questions ouvertes / 5517 résolues avec historique. Deux bases : huit lignes documentaires actualisées chacune, 42 598 autres lignes exactes, 42 606 états/notes et 23 historiques conservés, intégrité ok. Collecte, préparation, candidat, publication et audit : codes terminaux 0 observés. Sous-inventaire : 42 à reprendre, 459 partielles, 39 exclusions ouvertes dont 27 audio ; une exclusion reste du travail ouvert, ce n'est pas un pourcentage de jeu terminé.
