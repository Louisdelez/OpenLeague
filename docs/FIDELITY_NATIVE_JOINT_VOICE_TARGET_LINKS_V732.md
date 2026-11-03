# SYS-01.2-02 — Chargement conjoint des cibles de voix, V732

Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Les chemins des voix restent en_US ; la sélection historique n'est pas démontrée.

## Résultat vérifié

Les dispatchers originaux des HIRC2/3/4/5/7 sont composés dans l'ordre relatif des objets de chaque banque. Les 364 contextes base/skin reprennent les deux ordres déclarés précédemment. Les 12 672 demandes de voix sont réexécutées ; les noms et origines des événements sélectionnés restent comparés aux résultats V728.

Les 20740 objets sources sélectionnés sont vérifiés par en-tête, identifiant et empreinte. Les 201 ActorMixer sont identifiés dans les banques. Sur l'ensemble des contextes, le banc observe 35310 instances retenues de sons/conteneurs/ActorMixer, 34810 liens d'enfants et 9286 recherches natives de cibles d'actions.

Les sources sonores, les playlists, les poids, les enfants, les pointeurs parent/enfant et les origines réellement retenues sont contrôlés. Le contrôle tient compte des enfants rattachés plus tard à un parent déjà chargé : 10 liens supplémentaires dans 3 instances de parents. 34810 affectations de parent exécutées sont comparées aux champs sources, dans l'ordre de chargement. Les rechargements sont distingués des premières lectures. Les comptes portent sur les instances des contextes déclarés, pas sur autant de ressources uniques.

Les 4831 adresses exécutées correspondent au PE original SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les bus nécessaires sont créés à partir des identifiants type8 d'Init.bnk ; leurs payloads et leur mixage ne sont pas chargés.

## Correction de V731

La table de dispatch native établit :

| Type HIRC | Dispatcher | Fabrique | Lecteur |
|---|---|---|---|
| 2, son | AF8170 | B226A0 | B22AF0 |
| 5, conteneur aléatoire/séquentiel | AF87E0 | B1D610 | B1E5C0 |
| 7, ActorMixer | AF8290 | B22BE0 | B22C60 |
| 9, LayerContainer | AF8720 | B24C20 | B24F00 |

V731 avait utilisé B24C20 pour trois parents déclarés type7 dans les sources Twitch. Les trois cas sont réexécutés avec B22BE0, puis le chargement conjoint utilise AF8290. Leurs états de source sonore restent identiques, mais la classe du parent est corrigée (vtable FF1E20 au lieu de FF2218).

La note commune erronée est corrigée dans les 1 278 fiches et annotée dans SYS. Les 11 fiches Twitch dont les sources sont réellement concernées sont identifiées séparément. Les anciennes valeurs restent dans l'historique de correction et les preuves brutes restent intactes. Cette correction ne déclare pas les voix ou le jeu terminés.

## Contrôles et limites des liens

Cinq diagnostics vérifient : conservation de la source d'un son déjà chargé, conservation de la playlist d'un conteneur déjà chargé, refus d'un conteneur chargé avant ses enfants (15), refus d'une lecture de payload absente (2), et inscription dans le registre malgré une capacité nulle du vecteur propriétaire (1). Trois gardes de forme relèvent du banc ; quatre falsifications d'observations sont rejetées.

Écarts de parent entre source déclarée et graphe observé : 0. Liens d'actions dont la cible retenue provient d'une autre banque du contexte : 58. Leurs détails restent dans le reçu ; les deux ordres ne deviennent pas une priorité historique.

Les 569 sources et 29 points de code actuels sont vérifiés. Les consommateurs courants restent des références, modèles et fonctions audio d'ambiance. Aucun fournisseur complet de voix de champions ou de skins n'est accepté.

Les 1 279 fiches (668 skins, 610 voix de champions et SYS), leurs liens et leurs instructions copiables dans les deux bases sont enrichis. Les cases, notes manuelles, historiques, autres tâches, prérequis et inconnues sont conservés.

- Original dispatchers for HIRC2/3/4/5/7 run in serialized relative order. Bus factories are source-bound; other HIRC types,bus payloads and whole-bank orchestration are excluded.
- Both bank orders remain supplied candidates,not historical precedence. Retained payloads and final parent-child links are checked separately: later new children may attach to a previously loaded parent. Source-derived ordered links are compared to native 791BC0 assignments and final pointers; frozen first-parent child lists are not assumed.
- Voice naming/fallback/availability is rerun; playback boundary records and returns false. No decoder,media mounting,renderer,current voice provider or audible sound is accepted.
- Target reload/read/owner-capacity and out-of-order-child diagnostics are explicit; malformed shapes are harness refusals,not native malformed-input safety. Earlier preparation root-path and empty-BNK selection failures remain preserved.
- V731 three type7 parent contexts used type9 factory; actor source receipt records correction and three isolated reruns with B22BE0. Native type7 dispatcher is AF8290,not AF8720(type9).
- Les 1 279 fiches et leurs instructions copiables sont enrichies sans modifier les cases, notes manuelles, historiques, autres tâches ou inconnues.
- V731 attribuait B24C20 à des parents de type7. La table native montre que B24C20/B24F00 appartient au type9. Trois contextes de sons Twitch et 11 fiches concernées sont explicitement corrigés avec AF8290/B22BE0/B22C60 ; les preuves brutes antérieures sont conservées.
- Les objets HIRC14/19 et les payloads des bus ne sont pas chargés. La réussite des types2/3/4/5/7 ne qualifie pas le montage intégral des banques, le décodage, les générateurs ni le mixage.
- Les voix proviennent de chemins en_US. La sélection historique EUW/en_GB et le fournisseur actuel de voix restent ouverts.
- Les nouvelles preuves sont uniques sur F, avec deltas ciblés compressés et sans copie complète des bases.

## Livrables

Le [reçu de liaison](fidelity_native_joint_voice_target_links_v732.json) référence les preuves uniques sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision732_joint_targets_linked/OBSERVATIONS.json, revision732_actor_mixer_sources/OBSERVATIONS.json et revision732_joint_associations_linked/OBSERVATIONS.json. Les premières erreurs de préparation (racine manquante, exclusion des BNK sans objets et attente incorrecte d'une liste d'enfants figée) restent conservées. L'écart Karthus est reproduit séparément : le parent 10309 passe de 29 à 35 enfants lorsque six nouveaux conteneurs de base déclarent ce parent existant. Les affectations natives 791BC0 et les pointeurs finaux sont contrôlés. Les quatre lots partitionnent exactement les contextes, sans qualifier de priorité historique.

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Suivi : coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md, HANDOFF.md. Deux plan.sqlite3 mis à jour par deltas ciblés. Aucun code du jeu ou asset modifié.

Livraison : revision732_delivery/VERIFIED.json ; relecture indépendante réussie dans INDEPENDENT_READBACK.json. Le goal reste ouvert.


Relecture complémentaire : 13617 champs de bus sont comparés aux octets originaux et 2006 liens directs aux pointeurs chargés. La première tentative `revision732_independent_readback_checked.py` s'est arrêtée avec `StopIteration` : elle cherchait `OverrideBusId` dans le relevé réduit V729, qui ne contient pas ce champ. La version `revision732_independent_readback_verified.py` lit les relevés de dépendances V730/V731 et vérifie leurs offsets et valeurs dans les banques originales. Les scripts antérieurs sont conservés.
