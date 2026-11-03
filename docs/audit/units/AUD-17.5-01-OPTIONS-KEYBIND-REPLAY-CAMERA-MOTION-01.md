# Caméra replay — audit documentaire de huit commandes

## 1. Périmètre et décision

Unité : **AUD-17.5-01-OPTIONS-KEYBIND-REPLAY-CAMERA-MOTION-01**. Goal SYS-01.2-02, parent SYS-17.5-01. Huit déclarations physiques FoundryOptionsKeybinds.xml222..229 uniquement. Le lot documentaire est proposé à la clôture après relecture ; aucune fonctionnalité replay ni exigence parente n’est déclarée terminée. La relecture et son reçu portent la décision finale.

Audit : associations et écarts établis. Implémentation : six primitives ordinaires présentes, raccord replay non qualifié. Vérification : documentaire seulement. Acceptation humaine : non demandée.

## 2. Sources et provenance

Référence locale 4.20.0.315 EUW/en_GB. Octets de l’index physique, XML, defaults/Input.ini, deux input.ini fournis, Game.cfg et locale contrôlés par SHA-256 dans la preuve. Les huit nœuds ont l’ancêtre `onlyshowif=replay`, stratégie input/GameEvents et aucun gate propre. Cette déclaration ne prouve ni visibilité effective ni permission d’exécuter.

| Événement | Ligne XML | Valeur native | Consumer actuel réutilisé |
|---|---:|---|---|
| evtCameraSnap | 222 | [Space] | Recentre sur le joueur local ordinaire |
| evtCameraLockToggle | 223 | [y] | Setting caméra partagé en mémoire, joueur local |
| evtDragScrollLock | 224 | [Ctrl] [Shift] [s] | Consumer replay non qualifié ; Stop ordinaire possible sous ses gardes |
| evtScrollUp | 225 | [Up Arrow] | Pan ordinaire, direction Z négative |
| evtScrollDown | 226 | [Down Arrow] | Pan ordinaire, direction Z positive |
| evtScrollLeft | 227 | [Left Arrow] | Pan ordinaire, direction X négative |
| evtScrollRight | 228 | [Right Arrow] | Pan ordinaire, direction X positive |
| evtOnUIMouse4Pan | 229 | [Button 3] | Aucun consumer replay de drag-pan qualifié |

Les deux overrides fournis n’ont aucune entrée pour ces huit noms. Il ne s’agit pas d’une preuve de priorité effective defaults/user/cache. Les huit noms figurent dans ReplayOptions.CategoryEvents1 de **defaults/Game.cfg:365**, pas dans cette catégorie d’Input.ini. Les sept autres déclarations partagées avec le groupe ordinaire ont des identités XML différentes ; DragScrollLock n’appartient pas au groupe ordinaire XML126..138.

## 3. Consommateurs réels et preuves réutilisées

`crates/client/src/ordinary_camera_input.rs:6..50,54..83,100..141` : six touches codées en dur, filtrage fenêtre/focus, gestes courts, verrou partagé et cible finie du joueur `connection.id`. Le pan est une politique locale PAN_SPEED150 multipliée par delta Bevy. Owner joueur/session/epoch/fenêtre et temps ordinaire ne deviennent pas automatiquement owner/acteur/horloge de replay. Suivi local en arrière-plan ou boutique ouverte est aussi une politique ordinaire explicite.

`main.rs:1503..1543` relie le focus à la caméra/rendu. `camera_native.rs:33..55` reçoit le focus fourni, utilise des flags de service0 et step_without_auto_follow : mathématiques présentes, politique de cible replay non prouvée. `main.rs:1450..1457` contient le Stop ordinaire sur S ; il reste soumis aux gardes de la commande. `six_client_match_observation.rs:366..386` vérifie l’occupation humaine de la souris ; ce n’est pas un pilote de pan.

Les recherches lexicales des audits caméra historique et ordinaire sont réutilisées par pointeurs et empreintes. Leurs lignes retrouvées sont relues ; leur corpus de1168fichiers est inchangé. Aucun scan identique n’est relancé, aucune absence sémantique globale n’est affirmée. Les35anciens contrôles composants restent hérités dans leur portée, zéro relance. Le vrai point d’entrée game replay déjà recensé reste présent ; aucune affirmation « audio seulement » ou absence globale de replay n’est faite.

## 4. Attendu, observé et contrôles

Attendu : huit sources propres, valeurs et libellés vérifiables, distinction partie/replay et écarts actionnables. Observé : huit associations établies, sept paires physiques ordinaires distinctes, six primitives ordinaires conservées, zéro raccord replay qualifié. Les sorties réelles du producteur et du lecteur, leurs codes, leurs empreintes et les contrôles détaillés sont dans les reçus.

Les contrôles exécutés portent sur les identités, fenêtres textuelles, déclarations, liens de preuves, corrections conservées, cohérence et absence de changement des fichiers gelés. Aucun jeu/Rust/native/AS/GUI/réseau, entrée clavier physique, OS, rendu ou test fonctionnel replay exécuté. Aucun loader de production, application Plan ou base ouvert. Les refus focus/session/mode/cible sont des conditions à qualifier en replay, pas des essais réussis ici.

## 5. Écarts ouverts et reprise

- **REPLAY-MOTION-OWNER-TARGET-CLOCK** : fournir le contrat ou provider de session/acteur suivi/temps de replay et son articulation avec pause, vitesse, recherche et directeur.
- **REPLAY-MOTION-INPUT-PRIORITY** : Y est aussi déclaré pour Chaos6 sous gate6v6. Ctrl+Maj+S peut emprunter Stop ordinaire si admis. Fournir handler/trace natif ou contrat local explicite de priorité et de mode ; aucune collision physique démontrée.
- **REPLAY-MOTION-DRAG-DECODING** : décodage Button3, gestes souris et lock non qualifiés. Le nom Mouse4Pan ne démontre pas le bouton Bevy ; busy-guard et zoom ne livrent pas le pan.
- **REPLAY-MOTION-PROVIDER-REMAP-RUNTIME** : montage/cache, remap, UI actif/désactivé/refusé, persistance et rendu réel restent ouverts. Reprise avec provider/callback discriminant ou contrat explicite, consumer intégré et autorisation produit/runtime distincte. Pas de nouvelles recherches génériques inchangées.

## 6. Corrections et critères réutilisés

Réutiliser **CAMERA-CONTEXT-PERSISTENCE-01**, **CAMERA-NATIVE-PERSISTENCE-01**, les deux corrections **CAMERA-COMMAND-EVTDRAGSCROLLLOCK** et **CAMERA-COMMAND-EVTONUIMOUSE4PAN**, et les corrections génériques BIND-LOAD/SAVE/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER-01. Les définitions originales et critères sont pointés par JSON Pointer et empreinte. CAMERA-KEYMAP-01 conserve sa portée13événements ordinaires ; aucune extension normative implicite. Les travaux de verrou durable et de reprise processus sont des dépendances existantes, pas des résultats livrés ici. Les tâches existantes SYS-21.1-03 et SYS-21.2-03 restent ouvertes.

Huit vues de dépendance, une par identité physique, détaillent un objectif unique et les conditions de fin dans event_comparison_matrix[].dependency_view : contrat cible/owner/temps/priorité, consumer et remap effectifs, limites appui/maintien/relâchement, refus mauvaise session/mode/focus/cible/UI et absence de commande parasite. Ces vues ne créent aucune tâche normative et n’altèrent pas les critères existants. Zéro nouvelle correction : les objectifs sont déjà couverts par les travaux nommés.

## 7. Livraison et cohérence

Livraison isolée sur F, aucun fichier antérieur remplacé. La preuve lie les sources, spécification, producteur et anciens audits par empreinte/pointeur. Le lecteur distinct recontrôle les sept rubriques, les associations et les fichiers ; son reçu lie preuve, rapport, programme, sortie et code réels. Corpus1168,25fichiers protégés et5registres conservés. Goal, critères normatifs, suivi et bases inchangés. Ni installation ni migration ni redémarrage.

Prochaine portée proposée après clôture de ce lot : **six commandes temporelles replay XML233..238** (pause, vitesse et sauts). Les autres contrôles du parent et la couverture globale restent ouverts. La clôture de cette unité documentaire ne clôture pas le parent, le goal ou le jeu.
