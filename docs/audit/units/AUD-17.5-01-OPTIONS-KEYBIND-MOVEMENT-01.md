# Déplacement, combat et familier — sept raccourcis

## 1. Périmètre et fin précise
`AUD-17.5-01-OPTIONS-KEYBIND-MOVEMENT-01`, SYS-17.5-01 dans SYS-01.2-02. Sept déclarations XML **116..122**, keybinds simples sous input/GameEvents/game. Critère : source/consommateur/comparaison par événement, preuves/limites et correction/reprise liées, sept rubriques relues. Ni Quickbinds/mode de cast ni fonctionnalité entière inférés de ces lignes.

## 2. Sources historiques et réutilisation
Sources natives4.20/en_GB épinglées, défaut/copied Input identiques. Sept lexèmes conservés, y compris alternatives/espaces :

| Événement | Défaut physique | État courant établi |
|---|---|---|
| MoveClick | [Button 2] | Right contextuel : Attack sous cible, Move au sol |
| AttackMoveClick | [Shift] [Button 2] | Pas de branche dédiée dans commands inspecté |
| AttackOnlyClick | [<Unbound>] | Défaut non lié, comportement propre non qualifié |
| AttackMove | [a],[x] | Aucun déclencheur live nommé A/X établi |
| HoldPosition | [h] | Aucun chemin H/Hold nommé établi |
| StopPosition | [s] | S→Stop existant, remap/persistance ouverts |
| PetMoveClick | [Alt] [Button 2], [Ctrl] [Button 2] | Alt→guide Annie/Tibbers partiel ; Ctrl non dans ce prédicat |

Override deploy vide pour ces événements ; utilisateur conserve seulement Stop[s]. Sept traductions en_GB vérifiées. Natif Button2 et Bevy Right restent des identités à relier par producteur/contrat, pas une parité physique déjà prouvée. Contrats KeyBind/Read natifs et AS acquis réutilisés, aucun nouveau flow/désassemblage/export. La référence pet symbolique antérieure est conservée avec ses six frontières ; même annie_r.rs déplacé E→F (taille/SHA identiques), aucun ancien36cas natifs/CSharp relancé ou transféré en preuve de clavier/gameplay.

## 3. Consommateurs réels et écarts par événement
Main.commands garde inventaire/learning/boutique/connexion/fin, puis priorité source objets>D>F>Learn/cast non ciblé>S>right/cast ciblé. Right sous minimap est séparé du Move minimap déjà présent ; refus curseur/caméra/rayon/sol conservés. Picker géométrique choisit des ennemis vivants dans le snapshot, validation protection/visibilité et chemins reste côté core. Move/Attack/Stop et annulation windup/ordre sont présents ; ils ne constituent pas un ordre AttackMove avec acquisition/reprise.
Source S appelle Stop, puis cancel_windup et nettoyage core sous guards ; **Stop ne prouve pas Hold H**. Shift/A/X/H n’ont pas de branche dédiée dans commands inspecté ; recherche bornée des16noms sur1168sources donne deux candidats KeyA, tests de saisie et de helper négatif, aucun raccord d’événement prouvé. Aucune absence sémantique globale d’alias/implémentation indirecte affirmée.
AltLeft/Right+Right avec Annie et pet vivant/possédé/non expiré devient **CastAt3→cast_tibbers→guide_tibbers** ; cible Move/Attack du pet et refus portée/sol/forced/silence/protection/visibilité documentés. Contrôle/AI/cadence explicitement reconstruits dans l’en-tête. **Ctrl n’est pas testé par ce prédicat** : en frame autrement neutre et contexte admis, Right peut suivre la branche du joueur. Constat statique conditionnel, pas nouvel essai ou parité native. Toutes les familles de familiers et moteur natif restent hors de cette clôture.

## 4. Attendus/observés et contrôles
**286 contrôles statiques producteurs** réussis, valeurs figées par deepcopy ; sept lignes de comparaison expected/current/qualified/work dans la preuve. Treize résultats CPU distincts réutilisés : neuf picker/annulation/refus/poursuite, quatre gestes/projection/Move minimap. Logs et sources/data correspondants vérifiés, anciens binaires identifiés sans nouvelle exécution. Aucun test Rust/jeu, GUI, OS, réseau, x86/AS/Lua/CSharp ou émulation exécuté ; aucune recherche générique inchangée rejouée. Relecture indépendante requise.

## 5. Manques et reprise
- **MOVEMENT-NATIVE-EVENTS** — Native Button2/keyboard producer, event→order/confirm/target/cancel and native Hold/Pet semantics not fully qualified. Impact : Physical native lexemes plus current local paths cannot be promoted to full native equivalence. Unbound AttackOnlyClick is a source state, not an asset missing. Reprise : Reuse CONTROL-NATIVE-ACTION and attackmove catalog for its exact four-event scope. A named new handler/xref/trace or accepted versioned local policy is needed for new Hold/Move/Stop/Pet entry claims; do not rescan unchanged PE/AS/archives.
- **MOVEMENT-KEYMAP** — Effective remap/edit/cancel/default/save/restart path for world movement/Stop/Hold/Pet and real UI/input admission remains open. Impact : Fixed right/S/Alt routes exist; ordinary Move/Attack is not AttackMove, native H cannot be silently mapped to Stop and Ctrl-pet cannot be declared supported from Alt. Reprise : Five existing binding/persistence objectives and four new precise entry proposals after authorization/provider policy; preserve core interfaces and explicit unsupported context.
- **MOVEMENT-CAPTURE-PHYSICAL** — Full physical layout/window/focus/frame/repeat/held/capture/conflict/priorities and ordinary gameplay comparison not executed. Impact : Thirteen retained source-matching tests are component/minimap evidence, not seven configured-event end-to-end proofs. Existing Q→Enter capture finding is not a newly proved Stop/Pet leak. Reprise : After exact entry/action support, run only missing per-event nominal/refusal/crossed capture cases under named build/assets/session/layout; reuse SELF-FOCUS/HUD capture tasks without changing their definitions.
- **PET-NATIVE-AUTHORITY** — Native numeric state/order/event argument producer, complete pet engine/cadence and all-family bridge not qualified. Impact : Same current Annie R source and symbolic callbacks remain useful, but do not deliver native generic pet control or application of Ctrl alternative. Reprise : Named original dispatcher/argument source or explicit local contract; preserve reference_pet_order boundaries and existing same-source guide guards, then verify only the supported named pet path.

## 6. Réutiliser le travail existant
**ATTACKMOVE-INPUT/ORDER/ACQUIRE**, **CONTROL-NATIVE-ACTION** et **CONTROL-QUALIFY** réutilisés, critères/provenance inchangés ; les deux objectifs champion-only restent leurs scopes propres, pas ajoutés aux sept lignes. LOAD/SAVE/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER repris comme interfaces communes. **HUD-CAPTURE-RELEASE-FRAME-01** garde son cas Q→Enter ; pas une nouvelle fuite Stop/Pet affirmée.
Quatre propositions documentaires uniques, non appliquées : **BIND-MOVE-CONTEXT-01**, **BIND-STOP-ENTRY-01**, **CONTROL-HOLD-ENTRY-01**, **BIND-PET-ORDER-ENTRY-01**. Elles préservent les chemins présents et nomment entrée/sémantique/admission/capture/remap manquants ; pas de deuxième collecteur, moteur de pet ou acquisition AttackMove. Sources, dépendances, prérequis, travail, critères nominal/refus et conditions de reprise sont fournis. Pas de nouvel objectif d’attaque-déplacement en doublon ; nouveauté vérifiée dans les catalogues nommés seulement, sans prétention de recherche globale de toutes tâches. Aucun critère/registre/base/goal modifié.

## 7. Livraison et clôture limitée
Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-MOVEMENT-01\keybind-movement-proof.json`, script `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-MOVEMENT-01\audit_keybind_movement_v2.py`. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 76 modifications suivies antérieures, 25 protégés, cinq registres, contexte/corpus1168 inchangés. Nouveaux documents isolés seulement ; produit/assets, goal/critères normatifs, Plan/UI/bases et preuves antérieures conservés. **Audit des sept lignes clôturable après lecture ; fonctionnalité, parent et goal restent ouverts**, acceptation humaine non revendiquée. Suite bornée : treize déclarations caméra/sélection/pan126..138, avec garde mutator6v6 de SelectAlly5 maintenue.
