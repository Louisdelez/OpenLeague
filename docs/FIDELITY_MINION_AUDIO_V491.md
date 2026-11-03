# SYS-01.2-02 — Audio des huit sbires : sources et portée des consommateurs (V491)

24 octobre 2026 — F:\OpenLeague. Référence : client fourni LoL 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB ; catalogue 4.20.1 distinct.

## Résultat et portée

Les huit fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-PRESENT-AUDIO sont enrichies avec les références natives réellement lues et une question propre à chaque exigence. Le lien historique vers `enable_map10` est conservé, mais présenté hors périmètre audio de ces fiches : charger une unité ne démontre pas le déclenchement de ses sons. Aucun consommateur audio propre aux sbires n’est démontré par les chemins inspectés. Il ne s’agit pas d’une preuve exhaustive d’absence de tout dispatch indirect.

Ce travail porte sur les associations source/consommateur et les lacunes. Aucun son, asset, code de jeu ou mélange audio n’a été réparé. Les critères de fidélité, dépendances et états manuels sont conservés. Aucune tâche n’est déclarée achevée et le Goal reste actif.

## Sources natives observées

- Huit configurations INIBIN : champs Sounds/Death, Attack, Attack1, Attack2, Attack3, Idle, Move et Data/WeaponMaterial, SelectionCategory, avec présence et valeur enregistrées séparément.
- Vingt-six définitions d’attaques candidates déjà identifiées en V484, relues ici : les 52 champs Sound_CastName/Sound_HitName sont présents et valent `none.wav`. Cette valeur ne prouve pas que l’attaque est silencieuse : les événements d’animation, matériaux, effets ou autres producteurs peuvent intervenir. ApplyMaterialOnHitSound absent reste absent ; aucune valeur par défaut n’est inventée.
- Seule la configuration Blue_Minion_MechCannon comporte le champ Sounds/Death parmi ces huit profils, avec `Order_Minion_Rider_Death_1.wav`. Aucun fichier portant exactement ce nom n’est recensé dans le registre consulté. Les médias Wwise numérotés ne sont pas attribués à ce nom : il n’est donc pas déclaré perdu ou corrompu.
- Dix particules distinctes ont été retrouvées dans DATA/Particles à partir des champs HitEffectName, AfterEffectName et MissileEffect. La recherche de chaînes littérales Play_/Stop_ n’y trouve aucune occurrence. Ce contrôle lexical ne décode pas tous les producteurs ni les références hachées. Les références non retrouvées dans ce seul dossier sont enregistrées comme telles, sans conclusion d’absence dans tout le client ou les archives.

Les configurations de base et les noms d’attaque sont inspectés ; la sélection native de variantes/attaques critiques n’est pas qualifiée par cet audit.

## Banques candidates disponibles

Les quatre conteneurs natifs `DATA/Sounds/Wwise/SFX/Shared/NPC_{Global,Map10}_SFX_{events,audio}.bnk` sont présents et lus avec contrôles des bornes. Ils annoncent la version 88.

| Banque | Objets HIRC | Entrées médias DIDX |
| --- | ---: | ---: |
| NPC_Global_SFX_events | 771 | 0 |
| NPC_Global_SFX_audio | 0 | 249 |
| NPC_Map10_SFX_events | 261 | 0 |
| NPC_Map10_SFX_audio | 0 | 58 |

Les 307 entrées sont des médias candidats partagés, pas « 307 sons de sbires ». Offsets, tailles et SHA-256 des octets sont conservés ; aucun décodage PCM ni écoute n’a été exécuté. Les types et identifiants HIRC sont inventoriés, mais les arêtes événement/action/conteneur/média et leur sélection par un sbire restent à établir. Aucun fichier n’est choisi arbitrairement pour combler cette lacune.

## Consommateurs actuels inspectés

- `crates/core/src/world.rs::enable_map10` charge la configuration du monde et initialise structures, camps et vagues. Ce point n’établit pas une chaîne audio de sbire.
- `crates/client/src/animation.rs` lit les rôles d’animation ; aucun déclenchement sonore de sbire n’est établi dans ce chemin.
- `main.rs` enregistre les systèmes audio actuels ; `map_audio.rs` traite notamment reliques et autels, ainsi que le listener et les positions des ambiances.
- `map_audio_requests.rs` suit des demandes d’ambiance ; son sélecteur de particules comporte un refus explicite pour les particules non qualifiées. Une demande logique ne démontre pas une voix audible.
- `pcm_audio.rs` fournit un pont PCM ; ce pont ne démontre pas la sélection d’un événement de sbire. Les modules Ezreal Q/R/E consultés sont propres à ces effets et ne valent pas implémentation des sons des sbires.
- Recherche lexicale fraîche sur 498 fichiers Rust du client : dix fichiers contiennent les tokens audio ciblés ; aucun ne contient les huit noms exacts de profils. Les mentions exactes se trouvent dans trois fichiers visuels. Cette recherche guide l’inspection et ne constitue pas une analyse exhaustive du graphe d’appels ni de dispatch dynamique.

Les fichiers effectivement lus et leurs identités sont dans AUDIO_OBSERVATIONS.json et SOURCE_LINK_RECEIPT.json. Les banques candidates et chemins audio connexes sont classés comme références d’investigation, sans être présentés comme consommateurs fonctionnels de cette exigence.

## Vérifications réalisées

1. Lecture fraîche des huit configurations, 26 définitions d’attaque, dix particules et quatre banques ; vérification des bornes HIRC/DIDX et conservation des identités des entrées.
2. Trois refus du lecteur de preuve sur copies en mémoire : BKHD absent, conteneur tronqué, version non prise en charge. Aucun fichier natif modifié.
3. Neuf sélecteurs nominaux et dix sélecteurs invalides vérifiés par la préparation.
4. Comparaison des 42 214 instructions actives : huit modifiées et 42 206 identiques. Refus du mauvais propriétaire, d’une fausse résolution et d’une condition de résolution absente. Trois refus supplémentaires : exclusion qui revendique la fonctionnalité, preuve d’exclusion absente et identifiant de consommateur incorrect.
5. Publication et relecture indépendante des quatre registres et des deux bases du plan. Neuf lignes documentaires actualisées par base, 42 597 autres lignes identiques ; 42 606 états/notes et 23 entrées d’historique conservés exactement. Le vrai lecteur Store.task/copy_text affiche les limites et le lien conservé hors périmètre.

Attendu : aucune attribution audio inventée, aucune case cochée, huit questions ouvertes liées aux tâches et ancien lien conservé explicitement hors périmètre. Observé : ces propriétés sont vérifiées dans le registre et les sorties du plan. Les refus concernent les lecteurs de preuve et le registre, pas le moteur historique.

Quelques recherches exploratoires ont utilisé des chemins supposés absents ou un joker littéral non accepté par rg ; elles ont été corrigées par les imports, inventaires et chemins effectivement présents. Le registre de noms communautaire wwnames.db3 ne contenait aucun nom correspondant à « minion » ; il n’a fourni aucune attribution et n’est pas admis comme source native. Aucun outil tiers n’a été installé ni nécessaire à ce lot.

Une lecture complémentaire de processus par CIM était indisponible dans le contexte restreint. La fin de publication est établie par le retour terminal de son propre handle (code 0), pas par cette lecture CIM.

## Livrables et reste à faire

- `docs/reference_minion_behavior_sources/minion-audio-v491.json` : associations précises, champs observés, sources et questions.
- `docs/fidelity_minion_audio_v491.json` : preuve de publication et conservation des bases.
- Quatre registres fidélité/tâches, `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md` et `HANDOFF.md` actualisés sans effacer les acquis.
- `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision491_audio_inspection/AUDIO_OBSERVATIONS.json` : observation brute.
- Même racine, `revision491/` : préparation, contrôle candidat, audit indépendant, inventaire et point de reprise. Scripts `revision491_audio.py`, `revision491_delivery.py`, `revision491_check.py`, `revision491_finish.py`.

Reste pour l’audio de chaque sbire : qualifier les producteurs natifs et leurs conditions, les correspondances d’événements et de médias, les variantes et priorités de montage, identifier ou réaliser le consommateur actuel, puis vérifier déclenchement, arrêt, spatialisation, volume, mélange et reconnexion en session réelle. Ces travaux restent ouverts ; la disponibilité des banques ne les accomplit pas.

Suite de SYS-01.2-02 : examiner les références de projectiles des sbires et leurs consommateurs, puis consolider les agrégats PRESENT avec les limites des modèles, textures, animations et de l’audio. Sous-inventaire lié au chargeur : 135 fiches encore à reprendre, 373 associations partielles et 32 exclusions documentées dont 20 audio. Ces exclusions restent du travail ouvert ; ces nombres ne sont pas un pourcentage de complétion du jeu.

Bilan vérifié : 34 liens natifs ajoutés, aucune nouvelle ancre fonctionnelle, 2 sources, 8 exclusions de portée et 8 questions ouvertes. 580 identités de fichiers vérifiées. Graphe : 98662 sources, 2532 consommateurs, 25716 questions ouvertes, 5517 résolues avec historique.
