# SYS-01.2-02 — Présentation des monstres Map10, V503

25 octobre 2026 — F:\OpenLeague. Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; littéral de build 2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue officiel 4.20.1 distinct.

## Résultat et périmètre

Les sept fiches WORLD-<nom>-PRESENT sont reliées aux quatre facettes MODEL/TEXTURE/ANIM/AUDIO de leur propre monstre et aux consommateurs actuels inspectés. La composition conserve les 28 questions des facettes, leurs critères/dépendances et les sept exclusions audio. Sept fiches et questions AI supplémentaires sont vérifiées inchangées, soit 35 fiches héritées.

235 liens natifs sont composés et enrichis par les champs de 17 INIBIN candidats d'attaques/sorts. La recherche des particules est élargie de DATA\Particles à DATA récursif : six fichiers candidats distincts sont retrouvés, sans ambiguïté de basename dans ce périmètre ; deux noms restent non retrouvés. Six nouvelles ancres explicitent la queue numérique d'attaque, la frontière des projectiles sérialisés, les barres HP et l'orientation du modèle.

Cette tâche améliore le rattachement des sources et consommateurs au plan. Elle ne répare aucun asset, n'implémente aucun effet manquant et ne qualifie pas un rendu complet. Chaque agrégat conserve sa propre question ouverte et ses quatre facettes partielles. Aucun clip, média, matériau ou graphe simplement présent n'est accepté comme une fonctionnalité complète.

## Facettes héritées

| Facette | Preuve réidentifiée | Résultat et limites conservés |
|---|---|---|
| MODEL | monster-model-v499.json | Géométrie/indices et 452 os comparés ; matrices, poses effectives, fournisseur et rendu restent leurs limites |
| TEXTURE | monster-texture-v500.json | 2 424 832 pixels/26 273 UV comparés ; cinq RGBA exactes, deux écarts alpha attribués aux arrondis ; matériaux, mips et GPU non acceptés |
| ANIM | monster-animation-v501.json | 131 clips/33 rôles ; quatre clés terminales de loups non représentées, quaternions bruts de golems non unitaires, horloges et lecture effective ouvertes |
| AUDIO | monster-audio-v502.json | Banques candidates et 307 médias SFX présents, attribution et producteur sonore courant non démontrés ; VO en_US distinct de la référence en_GB |

Les quatre reçus et leurs sources épinglées sont réidentifiés, sans présenter leurs essais historiques comme rejoués. Les exigences enfants et leurs questions sont comparées à l'état courant. Pour chaque monstre, la facette AUDIO fournit une liste de consommateurs qualifiés vide ; son lien World reste conservé hors périmètre dans l'enfant. L'agrégat ne réintroduit pas ce lien comme preuve sonore. Le même World peut rester un consommateur partiel d'autres aspects de présentation sans démontrer l'audio.

Le compositeur exige exactement quatre facettes, un exemplaire de chaque type et les identifiants/propriétaires du même monstre. Il refuse aussi un consommateur audio non démontré réinjecté dans la composition. Une union de liens ne ferme aucune question et n'accorde aucune acceptation.

## Recherche native fraîche

Les sources proviennent du deploy fourni : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA. Les INIBIN sont réidentifiés à partir des candidats V497, puis leurs champs de missile/effet sont relus : vitesse, bornes, gravité, hauteur, os, MissileEffect/HitEffectName/AfterEffectName et flags associés. Présence, absence et types de valeurs sont conservés ; les getters/defaults natifs ne sont pas réexécutés.

44 références littérales de particules sont recherchées récursivement dans DATA. Les six fichiers physiques sont :

- Particles\FallenAngelBasicAttack2_mis.troybin
- Particles\TT_Spider_mis.troybin
- Particles\TT_spider_tar.troybin
- Particles\minotaurbasicattack_bld_tar.troybin
- Shared\Particles\globalhit_bloodslash.troybin
- Shared\Particles\globalhit_physical.troybin

Les deux derniers étaient hors de la sonde DATA\Particles utilisée en V502. Les retrouver n'est pas une reconstruction ou une résolution d'inconnue : le montage, la priorité, l'activation par le sort et le rendu restent à établir. AnnieBasicAttack_mis.troy et rampage.troy ne sont pas retrouvés dans cette recherche DATA ; aucune absence globale ou nécessité de recréer des ressources n'est déduite.

Le code courant définit une vitesse numérique de projectile750 pour les deux spectres, zéro pour les autres profils de ce lot. Les candidats natifs conservent leurs différences : TT_NWraith2BasicAttack2/3 ont une vitesse0 ; Vilemaw Attack/Vortex nomment1300, Attack2/3 environ347.8 et AttackDebuff n'a pas ce champ. La présence de ces variantes n'établit pas leur sélection effective. Aucune valeur n'est copiée arbitrairement sur la définition générique actuelle.

## Consommateurs et frontières actuels

Les consommateurs qualifiés des facettes visuelles sont réutilisés. Six ancres propres à l'agrégat sont ajoutées avec fichier, ligne, texte, rôle et limites :

1. world.rs : world.attacks.extend(attacks). Pending contient source/cible/dégât/deadlines/ranged/launched et éventuellement une identité de présentation ; ce champ est une queue numérique d'attaque.
2. lib.rs : projectiles: self.projectiles.clone(). Le Snapshot expose une collection distincte de projectiles d'attaque. World Pending n'est pas ce champ. Cette frontière ne démontre pas un projectile NPC visible.
3. health.rs : les unités du snapshot alimentent les barres HP locales48×5, avec position/hauteur/HP/couleurs d'équipe et masquages. L'équivalence du HUD natif et les pixels effectifs restent ouverts.
4. main.rs : la rotation initiale du modèle utilise unit.facing du snapshot.
5. main.rs : les mises à jour suivantes des NPC appellent entity_orientation::apply avec le delta de position du snapshot.
6. entity_orientation.rs : le bridge de yaw existant traite ce delta et conserve la rotation sur retour None. Aucun oracle native-yaw ou essai de facing de monstre n'est rejoué ici.

La lecture directe du code distingue ainsi facing initial et orientation dérivée du mouvement. Le producteur natif complet, l'axe avant du mesh, les changements de cible à l'arrêt et la comparaison visuelle restent à qualifier ; aucune panne d'orientation en partie n'est déclarée à partir de la seule inspection statique.

La recherche lexicale sur les 498 fichiers Rust client ne retrouve ni accès au champ générique .projectiles, ni les basenames de particules ciblés. Cette recherche n'exclut pas tout dispatch indirect. La queue Pending et le catalogue de particules, à eux seuls, ne prouvent pas une géométrie de missile, un impact visible ou sa synchronisation.

Les chemins spécifiques aux sbires ne sont pas généralisés : native_minion_mips.rs cible trois matériaux exacts de sbires ; native_minion_fade_producer.rs n'admet que les kinds Melee/Caster/Siege/Super et les acteurs lane de la fin de match. Ces sept profils sont Monster/Boss. Ces modules sont conservés comme références de frontière, sans nouvelle ancre de fonctionnalité de monstre. Cela ne prouve pas l'absence de tout autre chemin de mipmap ou de disparition de monstre.

Vilemaw conserve le lecteur visuel dédié du journal d'attaque et ses cinq rôles sans run ; les six autres profils conservent les consommateurs génériques décrits en V501. WebReel/Smash/Vortex et les variantes natives ne sont pas déclarés implémentés par la composition de reçus.

## Attendu, observé et refus

| Cas | Attendu | Observé |
|---|---|---|
| Composition nominale | Quatre facettes du bon monstre, questions conservées | Sept agrégats, 28 facettes et 35 fiches/questions héritées exactes |
| Audio | Ne pas réintroduire le consommateur exclu comme audio | Sept listes AUDIO qualifiées vides et sept exclusions conservées |
| Recherche de particules | Élargir le périmètre avant de déduire un manque | Six basenames candidats uniques dans DATA, deux noms non retrouvés dans ce périmètre |
| Profils invalides | Refuser inconnu/dupliqué | Deux refus sur copies mémoire |
| Composition invalide | Refuser enfant manquant/dupliqué, autre propriétaire, fuite audio, type inattendu | Cinq refus sur copies mémoire |
| Inconnue invalide | Refuser mauvaise propriété/fausse résolution/condition vide | Trois refus publics ; état restauré |
| Instructions | Conserver les tâches non ciblées | 42 214 comparées : sept changées et 42 207 identiques |
| Données existantes | Conserver critères, dépendances et liens historiques | Vérification du candidat puis audit indépendant des registres et deux bases |

La collecte revision503_presentation.py, la préparation revision503_delivery.py prepare, revision503_check.py, la publication et l'audit sont réellement exécutés avec Python -X utf8 -E -u -B. Les identités des ressources, scripts et fichiers courants sont vérifiées. Aucun jeu, binaire historique, Bevy, GPU ou audio n'est lancé, aucun média n'est décodé, aucun asset n'est réexporté. Une lecture exploratoire a tenté crates/client/src/attacks.rs, absent ; la recherche réelle a trouvé et relu crates/core/src/attacks.rs. Cette erreur de chemin n'est pas utilisée comme preuve d'implémentation absente.

## Livrables et suite

Les quatre registres docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json reçoivent les associations. Les deux bases reçoivent les données documentaires via leurs lecteurs réels, avec conservation des cases, notes et historiques. docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont actualisés avec les preuves et limites.

Reçu public : docs/reference_monster_behavior_sources/monster-presentation-v503.json. Preuve : docs/fidelity_monster_presentation_v503.json. Observation brute : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision503_presentation_inspection\PRESENTATION_OBSERVATIONS.json. Scripts et preuves privées : revision503_presentation.py, revision503_delivery.py, revision503_check.py, revision503_finish.py et revision503\ (baselines, préparation, candidat, publication, audit, environnement et reprise).

Sept questions d'agrégat sont ajoutées, aucune résolution. Les limites restent concrètes : provider/montage, pose et quaternions, alpha/mips/shaders, horloges/événements/variantes, effets/projectiles, HUD/orientation, sons et locale, puis scène ordinaire et comparaison native avec preuves visuelles/audio. Aucun statut ou case n'est accepté automatiquement. Le Goal SYS-01.2-02 reste actif. Suite : sept fiches ACCEPT des monstres, avec liaisons aux sources, aux contrôles effectivement exécutés et aux critères de fin encore non satisfaits.

Bilan vérifié :235liens natifs,205liens consommateurs,6ancres,2sources,7questions ouvertes,aucune résolution.817identités réidentifiées. Graphe :98691sources/2587consommateurs/25816questions ouvertes/5517résolues avec historique. Deux bases :8lignes documentaires actualisées chacune,42598autres lignes exactes ;42606états/notes et23historiques conservés,intégritéok. Collecte/préparation/candidat/publication/audit :codes terminaux0observés. Sous-inventaire :35à reprendre,466partielles,39exclusions ouvertes dont27audio ;aucun pourcentage de jeu terminé.
