# Replay : pause, vitesses et sauts — six commandes

## 1. Portée et dimensions

**AUD-17.5-01-OPTIONS-KEYBIND-REPLAY-TIMESHIFT-01**, goal SYS-01.2-02, parent SYS-17.5-01. Portée exacte : FoundryOptionsKeybinds.xml233..238. Le précédent lot caméra constitue un progrès vérifié, sans clôture du parent. Cette unité établit six associations et actions restantes ; sa clôture documentaire dépend de la relecture séparée. Implémentation : composants sous-jacents et pause ordinaire présents, ponts UI replay non qualifiés. Vérification : documentaire seulement. Acceptation humaine : non demandée.

## 2. Sources historiques et limites

Référence locale4.20.0.315 EUW/en_GB. Index physique, XML, trois Input.ini, locale et PE identifiés par octets/SHA-256 dans la preuve. Chaque nœud a un ancêtre onlyshowif=replay, stratégie input/GameEvents et aucun gate propre. La déclaration ne prouve pas l’exposition effective EUW ou le comportement actif/désactivé/refusé.

| Événement | Ligne XML | Default natif exact | Paramètre non établi |
|---|---:|---|---|
| evtToggleReplayPause | 233 | [p] | Toggle et reprise/vitesse pending |
| evtDecreaseReplaySpeed | 234 | [-],[Num-] | Pas/table/facteur et bornes |
| evtIncreaseReplaySpeed | 235 | [=],[Num+] | Pas/table/facteur et bornes |
| evtDefaultReplaySpeed | 236 | [0],[Num0] | Argument précis de « vitesse normale » |
| evtJumpBack | 237 | [Back] | Durée, unité et borne début |
| evtJumpForward | 238 | [j] | Durée, unité, borne fin/buffer/délai |

Defaults/Input.ini462..467 contient ces six valeurs. Les deux overrides fournis ne contiennent aucun de ces noms. Les trois virgules décrivent des alternatives déclarées ; elles ne démontrent pas un chord cumulatif ou le décodage physique effectif. Les libellés en_GB sont vérifiés, notamment Play/Pause et Return to Normal Speed. Aucun facteur de vitesse,1x ou durée de saut n’est inventé depuis ces libellés. FastForwardSpeed et les champs de service sont des rôles distincts.

## 3. Consommateurs actuels

La recherche nouvelle, bornée au corpus épinglé de1168fichiers Rust/launcher, porte sur six noms d’événement, neuf KeyCode candidats et sept alias explicites. Résultat : zéro occurrence des six noms, six lignes candidates : deux de production et quatre de tests. Ce résultat lexical n’est pas une preuve d’absence sémantique globale.

Les deux lignes de production concernent **shop_ui.rs:312** (P ouvre/ferme la boutique hors recherche focalisée) et **shop_text_input.rs:67** (Backspace supprime un caractère sous les gardes fenêtre/focus/session du module). Le default natif evtOpenShop est aussi[p]. Le rapprochement est un chevauchement source, pas un essai physique de collision. [Back] n’est pas automatiquement qualifié comme Backspace Bevy.

Les composants présents sont conservés : **native_game_clock.rs:114..191** fournit PauseControl et set_scale ; **native_effect_clock.rs:55..95** applique déjà des directives Pause/Resume ordonnées de la partie ordinaire et **98..108** publie le delta d’animation. L’horloge canonique/QPC est présente. Cela ne définit pas les pas/vitesses/sauts d’un playhead replay, ni ses permissions. Les valeurs TournamentPause1800/5s ne deviennent pas des paramètres Play/Pause replay.

**audio_replay_windows_game_manager.rs:114..149** contient le vrai point d’entrée open_game_replay ; la création active de host est explicitement refusée avant modification de lifetime. Aucune conclusion « replay audio seulement » ou absence globale de replay. **audio_seek_dispatch.rs:1..39** vise des nœuds audio ; il ne reconstruit pas une partie entière après un saut. Le flag pause du worker dans **audio_replay_stream_running.rs:147..165** et AL1 de **audio_replay_object_commands.rs:41..67** ne prouvent ni toggle UI ni acquittement fonctionnel d’une commande temporelle. Les recherches complémentaires sur les fichiers audio_replay sont conservées et classées : jump-table, flag worker ou diagnostic de configuration, chacun dans sa portée.

## 4. Attendu et observé ; contrôles réels

Attendu : six identités/source/binding/consumer/écart, composants conservés et tâches actionnables. Observé : six associations documentées, trois paires de touches alternatives, zéro pont UI replay qualifié,15fenêtres de code inspectées et quatre écarts précis.

L’ancienne preuve native_game_clock_pause_progress.json disait « Pause core not wired into live EffectClock/network/UI. ». Cette phrase est conservée comme constat daté : le receiver ordonné actuel existe dans le code. Le présent audit ne prétend pas avoir exécuté son parcours. Les24séquences/72frames et40cas qu’indique cette ancienne preuve sont hérités ; les512+400cas du rapport de scale concernent TroyClock0x9283c0 et ne deviennent pas des tests de vitesse replay. Zéro cas natif/Rust/jeu relancé.

Contrôles exécutés : identités des entrées et fichiers gelés, octets XML, lignes/configuration/libellés, recherches bornées nouvelles enregistrées, lecture des fenêtres, définitions existantes et cohérence du lot. Les requêtes sont conservées puis leurs lignes relues ; elles ne sont pas relancées par le producteur/lecteur. Codes réels et empreintes du producteur et de la relecture dans leurs reçus. Non exécutés : interface, clavier physique, jeu/Rust/native/AS/réseau, paramètres historiques, comportement de timeline et parcours complet.

## 5. Écarts et conditions de reprise

- **REPLAY-TIME-OWNER-AVAILABILITY** : exposition historique effective, session/owner/playhead et pipeline complet non qualifiés. Reprise : callback/trace discriminant ou contrat local accepté, provider et pipeline réels.
- **REPLAY-TIME-PARAMETERS** : pas/table/facteurs, argument normal, durée/unité et bornes des sauts inconnus. Reprise : handler/config/xref propre à chaque événement ou contrat explicite. Pas de valeur1x/0,5x/10secondes déduite.
- **REPLAY-TIME-CAPTURE-PRIORITY** : priorité P, décodage[Back], capture UI et mode. Reprise : policy source ou locale explicite et pont d’entrée ; aucune fuite boutique/combat/timeline étrangère.
- **REPLAY-TIME-RUNTIME-COHERENCE** : cohérence simulation/animations/audio/UI et refus réellement exécutés absents pour ces six commandes. Reprise : consumers intégrés avec restauration d’état, policy temporelle et autorisation produit/runtime distincte.

## 6. Actions restantes atomiques

Réutiliser les cinq corrections génériques BIND-LOAD/SAVE/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER-01 dans leur portée originale et les tâches SYS-21.4-01..04 (disponibilité, modules, fonctions confirmées, parcours) ainsi que SYS-21.2-06 pour la frontière des commandes de combat spectateur. Leurs états et critères normatifs sont inchangés. Ces tâches ne livrent pas implicitement les six gestes UI.

Six fiches documentaires proposées, conditionnelles et non appliquées, évitent une seule tâche temporelle trop large : **BIND-REPLAY-TIME-PAUSE-01**, **BIND-REPLAY-TIME-SPEED-DOWN-01**, **BIND-REPLAY-TIME-SPEED-UP-01**, **BIND-REPLAY-TIME-SPEED-NORMAL-01**, **BIND-REPLAY-TIME-SEEK-BACK-01**, **BIND-REPLAY-TIME-SEEK-FORWARD-01**. Chacune est liée à une identité physique et décrit objectif unique, paramètre manquant, consommateurs, prérequis, travail, critères, contrôles et preuves attendues dans new_proposed_corrections[].

Fin de chaque fiche : paramètres propres sourcés/contrat explicite ; un geste nominal et son remap atteignent le consumer réel avec état avant/après attendu/observé ; mode/session/owner/focus/UI/données/borne erronés suivent un refus ou comportement qualifié, sans modifier le jeu ou une timeline étrangère. Saut arrière exige restauration cohérente, pas une simple baisse de l’horloge. Disponibilité historique ou reconstruction locale acceptée et autorisation produit distincte sont des prérequis ; déclaration XML seule ne valide pas disponibilité ou tâche fonctionnelle complète. Aucun registre/application/base n’est modifié pour proposer ces fiches.

## 7. Livraison et reprise

Lot documentaire isolé sur F ; spécification, programmes, requêtes enregistrées, preuve, rapport et reçus liés par empreinte. La relecture séparée décide de la seule clôture documentaire après examen des sept rubriques. Corpus1168fichiers,25fichiers protégés,5registres et modifications Git préexistantes conservés. Aucun goal/critère normatif/Plan/UI/base changé, aucune installation/migration/redémarrage, aucun loader de production ou ancien lecteur exécuté.

Prochaine portée : la checkbox game-only SmartCastOnKeyRelease XML242, à rapprocher des preuves de cast existantes ; ensuite réconcilier toutes les déclarations physiques du keygrid avec les lots acceptés. Le parent SYS-17.5-01, SYS-01.2-02 et le jeu restent ouverts.
