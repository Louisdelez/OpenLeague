# AUD-17.3-04-DEATH-SCREEN-01 — écran de mort et compte à rebours

Preuves du 2026-10-30T23:25:09.322904+00:00 au 2026-10-30T23:25:11.366748+00:00. Projet F:\OpenLeague ; LoL4.20.0.315, EUW/en_GB, catalogue4.20.1. Audit documentaire uniquement : goal, critères, jeu, suivi et bases inchangés.

Résultat : le délai serveur, son texte RespawnTimer, son cadre et leur retrait ont de vrais consommateurs. Quatorze tests hérités correspondent aux sources actuelles examinées. Le visuel natif complet, le formatter/clock original et les états spéciaux de résurrection restent non qualifiés. Le récapitulatif local n’est pas le film historique. Clôture documentaire seulement après relecture indépendante ; fonctionnalité et inconnue restent ouvertes.

## R1 — Exigence et périmètre parent

**SYS-17.3-04 — Afficher l’écran de mort et son compte à rebours** ; exigence `OLF-ca060ce9-d879-504c-b712-2c000e4f37c1` ; inconnue `OLU-27eeca18-1eb1-5fa5-bb00-e7a495668772`. Le registre conserve a_faire, implementation_complete=false, acceptance_complete=false et inconnue open. Aucun critère normatif modifié.

D17-SYS-17-3 dépend de D20-SYS-20-3, toujours a_faire. Périmètre : état de mort/délai, temps, propriétaire accepté, texte/cadre et rendu, écran visuel, récapitulatif déjà présent, nettoyage et frontières de respawn/reprise/fin. Les formules de gameplay et la résurrection restent liées à leurs exigences, pas réimplémentées par cet audit.

Exclus : changement de code/app/base/goal ou critères, installation/migration, exécution Rust/jeu/native/GUI/GPU/REA, création d’assets et acceptation humaine. Tour précédent classé **progress** : parent documentaire SYS-17.3-03 clos après138contrôles et235de relecture ; ses40contrôlesJS réutilisés et ses limites backend/retour ne terminent pas l’implémentation.

## R2 — Sources natives et preuves réutilisées

### Délai Map10 : valeurs présentes, formule effective partielle

Le reçu existant reference_death_reward_sources/death_reward-links.json identifie le brut LEVELS/Map10/DeathTimes.inibin :158octets, SHA **d7a2e54334ebe553b6f2020e527f4a37c3771d0f92b363b238da9b3a891e12ed**, appartenance matches_selected_project_manifest. L’appartenance RADS et les champs disponibles ne qualifient pas l’algorithme serveurRiot ni une priorité runtime complète.

Les **24 champs** sont relus par les deux seules fonctions AST ini/hashkey du décodeur existant, sans lancer l’importeur. Comparaison native/courante en binary32 :20niveaux plus IncrementTime/PercentCap/PercentIncrease/StartTime. La représentation0.04du JSON correspond à0.03999999910593033en binary32. Les chaînes numériques60/1020restent identifiées. Présence de champs de scaling ≠ calcul consommé.

Le champ source_sha256 du JSON courant diffère du SHA du brut : il n’est pas traité comme l’identité du fichierINIBIN. Aucune corruption n’est déduite de cette différence. La comparaison directe des24valeurs et l’identité native explicite fournissent la preuve utilisée ici ; aucune provenance non prouvée n’est inventée pour ce champ hérité.

Le code actuel sélectionne la table de base pour niveaux1..18 ; les valeurs19/20restent dans la source. Late-match scaling et modificateurs/résurrections ne sont pas consommés par ce baseline. Réutiliser SYS-04.7-05 et SYS-04.7-06 plutôt que créer une seconde formule. SYS-04.7-08 porte la réapparition légale à la fontaine, SYS-04.7-10 le recap propriétaire.

### Text et Icon : deux ressources source, deux consommateurs

HUD.zip natif et copie importée sont identiques. Membre ShadowIslesChampionLeft.ini : enregistrements **Type/Name à deux-points**, pas des sections INI entre crochets. Les blocs source sont conservés exactement dans le reçu :

| Nom | Type / état d’origine | Paramètres source utiles |
|---|---|---|
| RespawnTimer | Text, Enabled0 | Arial, taille30, couche4, ancre0/1, alignementCenter et Rect source1024×768 |
| RespawnTimerFrame | Icon, Enabled0 | HUDAtlas, couche2, teinte alpha180, Rect et UV962,274–968,280sur1024×1024 |

Le code active une **copie possédée** à partir d’un état de mort accepté ; il ne réécrit pas l’archive ni l’élément source désactivé. Un cadre ne constitue pas du texte ; la chaîne widgets→stockage→glyphes est inspectée séparément. La présence d’Arial/UV ne prouve pas les pixels ni le clipping natif.

### Visuel de mort : source exacte, sélection non établie

DeathScreen.hls courant est identique au fichier original DATA/Shaders/HLSL/DeathScreen.hls. Il contient le calcul de luminance et des variantes DEATH_SCREEN, DEATH_SCREEN_PARTIAL_DESATURATION et DEATH_SCREEN_PARTIAL_DESATURATION_HEALTH_BARS. Le choix des macros, l’état natif déclencheur et les passes affectées restent inconnus. Ne pas appliquer un gris universel sur le monde et tout le HUD à partir du seul nom de fichier.

La recherche bornée des noms de shader dans clientRust et lesWGSL ne trouve aucun usage exécutable nommé, seulement une limite en commentaire. Le pass fullscreen gamma actuel est distinct : son existence ne prouve pas un effet de mort. Une ancienne recherche de fichier avait omis le sous-répertoireHLSL ; le fichier réel a été localisé et comparé, sans déclarer son absence depuis un chemin supposé.

### Quatorze anciens essais réellement retrouvés, sans les rejouer

Une ancienne draft indiquait installed=false et tests_run=false ; ces drapeaux sont historiques. Le code actuel, les plugins et l’appel réel sont inspectés. La preuve ultérieure retenue est la promotion pack22 datée2026-10-18 : build clos code0, lecture indépendante séparée close code0, reçu et journaux intacts. Aucun de ces anciensPID/sessionIDs n’est traité comme un processus vivant actuel.

| Groupe ciblé | Lignes de tests passés retrouvées | Périmètre |
|---|---:|---|
| lifecycle | 3 | Table des niveaux, blocage des commandes/réapparition, ressource de fureur |
| native_hud_respawn | 3 | Mort réelle simulée/transport borné, frontières de ticks, UV/DPI du payload, retrait ECS |
| death_recap_panel | 8 | Données propriétaire, anonymat, session/epoch, refus, deuxième mort, layout et retrait des enfants |

Les14lignes « test … ok » sont relues dans les logs core_tests/client_tests. **Sept fichiers source actuels** correspondent exactement à leurs empreintes du runtime hérité, y compris modules de production et tests concernés. Le reste des dépendances, le binaire courant et tous les milliers d’autres tests ne sont pas requalifiés par cette sélection. ordinary_GUI_qualified=false, render_qualified=false et native_timing_parity_qualified=false restent conservés. Aucun test réexécuté maintenant.

respawn_network_validation.json est seulement un ancien résumé de quatre contrôles du baseline réseau, avec un SHA de serveur ancien. Il n’est pas promu en preuve fraîche de réseau, de GPU ou d’écran de mort ; aucun journal détaillé supplémentaire n’est inventé. Les répertoires d’adoption/GUI vides ne sont pas qualifiés comme des parcours observés.

## R3 — Source → producteur → état accepté → affichage

Le corpus de **1 168 fichiers** Rust/launcher est inchangé en membres et SHA. Six dimensions de la chaîne sont documentées :

| Maillon | Acquis actuel | Limite ouverte |
|---|---|---|
| authoritative_deadline | Native24DeathTimes values and data baseline; lethal damage producer ; Current local server schedules respawn_at at lethal health0, baseline levels1..18 only | Late scaling and revive modifiers are related mechanics, not implemented by source existence. |
| own_state_and_time | Accepted own Snapshot health/deadline/tick; connection ready/session ; Nonfinite/alive/missing owner/deadline and winner hide; ceil remaining ticks, past deadline ->0 | Original clock/formatter, freshness/reconnect and special death-state selection need bounded qualification. |
| native_text_and_frame | ShadowIslesChampionLeft typed Text/RespawnTimer and Icon/RespawnTimerFrame; authored disabled ; Actual widget inserts text, enables copied storage and renders glyphs; separate frame uses actual HUDAtlas | Native pixels, all font/clip/DPI/window transitions not proved by CPU payload tests. |
| ordinary_respawn_lifecycle | Server health/position/deadline transition; clear ECS/materials and glyphs ; Past deadline can remain dead if legal spawn unavailable; accepted life clears timer; winner/session/readiness remove view | No invented early hide at0; delayed/stale and native revive conditions remain explicit. |
| screen_visual | Original DeathScreen.hls, exact current source copy with macro variants ; No named runtime consumer found in clientRust/WGSL; gamma fullscreen is a distinct existing pass | Selection of full/partial death desaturation, affected passes and restore still unqualified. |
| local_recap | Current owner-only OLSR death recap and8matching inherited panel tests ; Requires own accepted session/epoch/death, shop hides it, separate damage/absorption labels | Local reconstruction, not original Flash recap or whole death screen; do not read hidden attacker state. |

Délai : un dommage létal ramène les PV à0, nettoie certains états puis fixe respawn_at=self.tick+base_death_ticks(level). Ce délai provient de la simulation serveur actuelle, pas d’une animation de barre ou d’une horloge murale du client. Le renderer lit snapshot.tick et le deadline du joueur identifié ; le ceil entier est une politique locale explicite, non la preuve du formatter original.

Affichage : countdown refuse winner présent, joueur absent, santé non finie/vivante ou délai absent. Le cadre exige aussi connection.ready et même session. native_hud_widgets insère réellement RespawnTimer dans les valeurs, le retire si readiness/session ne correspondent plus, active le bit de sa copie, écrit le texte et prépare les glyphes. Les erreurs de préparation/valeurs nettoient les glyphes possédés ; un paramètre cooldown0ne supprime pas le death timer dans l’essai ciblé.

À30ticks/s, les essais locaux vérifient480→16,479→16,451→16,450→15,31→2,30/29/1→1,0→0. **Zéro n’est pas vivant** : le code de spawn peut différer si aucune place légale n’est disponible. Le compteur saturant reste0 tant que le serveur conserve PV0 et deadline ; seule la transition acceptée vers la vie retire le timer. Ne pas le masquer en anticipant la réapparition depuis le seul chiffre0.

Vie et retrait : le serveur restaure position légale/PV/ressource et efface respawn_at ; le frame despawn son entité et retire son matériau quand son gate échoue. Le texte a son propre retrait/rebuild et sa dépendance à la fenêtre, aux fontes et au payload. Le tick de simulation cesse d’avancer dans la boucle de pause examinée ; cela ne qualifie pas toutes règles natives de pause/horloge, ni la fraîcheur d’une ancienne snapshot.

Récapitulatif existant : UI locale privée OLSR, pas la Flash native. Elle exige l’epoch et la session acceptées, le propriétaire mort unique, des données de recap valides et aucune fin de partie. Elle sépare PV perdus/bouclier absorbé, conserve l’anonymat des sources masquées, disparaît pendant la boutique et ne capture pas ses entrées. Elle n’est pas un remplacement de l’écran de mort ou une preuve de shader natif.

Fragments exacts et identités sont dans current_consumer_fragments, notamment :
- `F:\OpenLeague\crates\core\src\damage.rs:98` — deadline_producer (jusqu’à116).
- `F:\OpenLeague\crates\core\src\lifecycle.rs:1` — baseline_policy (jusqu’à15).
- `F:\OpenLeague\crates\core\src\lifecycle.rs:33` — respawn_transition (jusqu’à82).
- `F:\OpenLeague\crates\client\src\native_hud_respawn.rs:7` — countdown_and_gate (jusqu’à18).
- `F:\OpenLeague\crates\client\src\native_hud_respawn.rs:19` — frame_source_selection (jusqu’à38).
- `F:\OpenLeague\crates\client\src\native_hud_respawn.rs:49` — frame_lifecycle (jusqu’à76).
- `F:\OpenLeague\crates\client\src\native_hud_widgets.rs:82` — timer_text_value (jusqu’à99).
- `F:\OpenLeague\crates\client\src\native_hud_widgets.rs:100` — timer_text_render (jusqu’à124).
- `F:\OpenLeague\crates\client\src\death_recap_panel.rs:43` — recap_owner_gate (jusqu’à69).
- `F:\OpenLeague\crates\client\src\death_recap_panel.rs:126` — recap_update (jusqu’à145).
- `F:\OpenLeague\crates\client\src\native_gamma.rs:8` — fullscreen_gamma (jusqu’à29).

## R4 — Attendu, observé et contrôles exécutés

**163 contrôles documentaires réussis** avec verify_death_screen.py :24valeurs natives, deuxblocs HUD, shader original/copie,14résultats hérités et sources actuelles identiques, consommateurs et conservation. La relecture indépendante est séparée.

| Cas | Attendu | Observé / portée |
|---|---|---|
| Mort nominale | Deadline serveur et texte/cadre du propriétaire | Chemin réel identifié ; anciens tests de mort/transport/glyph data retrouvés, aucun parcoursGUI frais |
| Autre joueur vivant | Ne pas copier son death timer | Cas ciblé du test conservé ; identity/session gates du code actuel |
| Frontières de ticks | Arrondi local cohérent sans native parity inventée | Neufpoints de480à0vérifiés dans l’ancien essai, code actuel identique |
| Deadline expiré | Ne pas inférer vivant | saturating_sub→0 ; spawn peut attendre une place ; retrait sur santé/délai autoritatifs |
| Refus/fin/session | Retirer proprement éléments possédés selon leurs gates | Essais ECS/session perdue/winner et source de nettoyage conservés ; cas native/reconnect/GPU restent limités |
| Table/scaling | Conserver chiffres et limites | 24valeursbinary32égales ;late scaling non consommé, pas formule déduite de PercentCap |
| Visuel/récap | Distinguer shader, cadre et UI locale | HLS natif présent ; sélection/rendu non qualifiés ; recap local propriétaire séparé |
| Preuves | Réutiliser le bon niveau de preuve | Draft ancien≠absence actuelle ; build0/read0≠capture ni native timing |
| Conservation | Préserver le travail précédent et le suivi | 25fichiers protégés, cinqregistres et Git inchangés |

Non exécutés maintenant : Rust/cargo/tests, jeu/client/serveur, originalLoL, REA, GPU, nouvelle capture, réseau ou contrôleOS. Aucune image/texture modifiée, aucun import/décodage GPU, installation/migration, application ou base de suivi ouverte. Les14essais sont **hérités** ; seules leurs sources, journaux et résultats sont relus maintenant.

## R5 — Écarts et entrées nécessaires à la reprise

| Manque | Entrée nécessaire à la reprise | Borne / résultat attendu |
|---|---|---|
| Mode visuel natif | Callsite/état de sélection des macros DeathScreen et passes affectées, témoin visuel nommé | Pas grayscale universel ; mode et remise à l’état vivant prouvés |
| Horloge/formatter | Accessor/caller/format natifs du RespawnTimer ou contrat local explicitement distinct | Arrondi, pause/retard et délai0sans vie attendus/observés ; ne pas répéter les neufpoints acquis |
| Late-match/scaling | Source de la formule et de ses modificateurs dans SYS-04.7-05 | Pas interprétation inventée du cap1.5 ou des champs60/1020 |
| Résurrection spéciale | Producteur d’état et UI ChronoShift/SYS-04.7-06, autres cas dans tâches nominatives | Mort/revive/fontaine séparés ; un simple health0n’identifie pas tous états spéciaux |
| Texte/cadre réellement rendus | Binaire/source/ressources actuels et scénario accepté, deux tailles/DPI, fontes/payload | Actualité des deux couches, lisibilité et retrait observés ; CPU payload≠pixels |
| Reprise/fin/absence | Contexte de snapshot accepté, fenêtre/fonts, état perdu ou repris et source terminale | Aucun ancien timer/cadre réutilisé, pas deadline ou temps inventé depuis une absence |
| Recap | Réutiliser SYS-04.7-10 et ses gardes privées, source historique séparée si comparaison native | Ne pas reconstruire un attaquant caché ni déclarer Flash/parité à partir du panneau local |

Les limites empêchent une fonctionnalité fidèle complète. Les sources/consommateurs et leurs gaps sont toutefois établis pour conclure l’audit documentaire après relecture. Les inconnues restent ouvertes. Arrêter les recherches inchangées ; toute reprise doit apporter une entrée discriminante ci-dessus, sans modification implicite du produit.

## R6 — Corrections ciblées et réemploi

Réutiliser `SYS-04.7-05`, `SYS-04.7-06`, `SYS-04.7-08`, `SYS-04.7-10`, `SYS-17.1-01`, `SYS-17.3-07`. Pas de duplication de formule de mort, de mécanique de revive ou de recap. Cinq compléments **proposed_not_applied** sous le même parent/inconnue :

### DEATH-SCREEN-NATIVE-VISUAL-01

Objectif : Qualifier et raccorder le mode visuel de mort au participant local.

Écart : DeathScreen.hls possède plusieurs macros mais leur sélection et leur consumer actuel ne sont pas qualifiés.

Travail / consommateur : Identifier appel/état natif et passes concernés, puis réutiliser le shader/contrat pertinent; ne pas appliquer un gris universel depuis le seul nom DeathScreen.

Critères de fin : Mort/life/retour et modes natifs nommés ont état, pass et image comparables; pas de désaturation d’UI ou d’autres acteurs sans preuve, aucune couleur persistante après respawn.

Entrée nécessaire à la reprise : Callsite/contrat natif de sélection du mode et témoin visuel nommé, puis renderer autorisé.

Dépendances : `SYS-17.1-01`.

Preuves attendues : Exact source/binaries/state and expected/observed named death case; native clock/visual/runtime versus local CPU/mock evidence distinct; no whole game/champion completion.

Sources :24champs, blocs/shader R2 et fragments R3 du reçu. État proposed_not_applied ; aucune case/tâche/base ou code modifié.

### DEATH-TIMER-CLOCK-FORMAT-01

Objectif : Qualifier l’horloge et le format du texte de réapparition.

Écart : Le ceil entier depuis tick serveur est explicite; la formule native et son lissage/format restent ouverts.

Travail / consommateur : Relever caller/accessor/formatter natifs ou définir un contrat local distinct; conserver valeurs0/1/31ticks, pause et retard sans faire passer la progression client pour une autorité.

Critères de fin : Attendu/observé aux frontières et pause/reprise, source d’horloge et arrondi prouvés;0reste compatible avec owner encore mort, absent ne devient pas un délai fabriqué.

Entrée nécessaire à la reprise : Source/callsite natif du RespawnTimer et capture corrélée au deadline; ne pas rejouer les anciens9points locaux inchangés.

Dépendances : `SYS-04.7-05`.

Preuves attendues : Exact source/binaries/state and expected/observed named death case; native clock/visual/runtime versus local CPU/mock evidence distinct; no whole game/champion completion.

Sources :24champs, blocs/shader R2 et fragments R3 du reçu. État proposed_not_applied ; aucune case/tâche/base ou code modifié.

### DEATH-TIMER-VIEW-LIFETIME-01

Objectif : Qualifier ensemble texte et cadre au changement d’identité/état.

Écart : CPU tests couvrent plusieurs retraits; parcours réel, fenêtres/DPI/fonts, stale/reconnect et erreurs restent incomplets.

Travail / consommateur : Conserver gates ready/session/owner; vérifier activation/retrait du texte et de son cadre, fenêtre/fonts/payload indisponibles et nouvelle session, sans effacer des UI non possédées.

Critères de fin : Nominal puis session étrangère/perdue, owner vivant/absent, fin de partie et erreur font retirent les éléments possédés selon contrat; aucune valeur/cadre ancien réutilisé.

Entrée nécessaire à la reprise : Scénario de snapshot accepté et renderer autorisé avec témoins d’entités/ressources et captures, pas seulement les variables d’un helper.

Dépendances : `SYS-17.3-07`, `SYS-17.1-01`.

Preuves attendues : Exact source/binaries/state and expected/observed named death case; native clock/visual/runtime versus local CPU/mock evidence distinct; no whole game/champion completion.

Sources :24champs, blocs/shader R2 et fragments R3 du reçu. État proposed_not_applied ; aucune case/tâche/base ou code modifié.

### DEATH-REVIVAL-CHRONOSHIFT-VIEW-01

Objectif : Qualifier le choix de l’écran pendant une résurrection ChronoShift.

Écart : ChronoShift est une source native d’exemple; health/deadline ordinaires ne représentent pas tous états de résurrection.

Travail / consommateur : Réutiliser SYS04.7.06 pour la mécanique et son état, qualifier sa transition UI séparément du respawn fontaine; garder les autres champions spéciaux dans leurs tâches nominatives.

Critères de fin : Scénario ChronoShift avec état/identité/temps et comportement d’écran sourcés; aucun simple health0transformé en mort définitive ni absence traitée comme vivant.

Entrée nécessaire à la reprise : Producteur d’état et callsite/UI natif ou contrat local explicitement distinct pour ce cas, puis test d’intégration autorisé.

Dépendances : `SYS-04.7-06`.

Preuves attendues : Exact source/binaries/state and expected/observed named death case; native clock/visual/runtime versus local CPU/mock evidence distinct; no whole game/champion completion.

Sources :24champs, blocs/shader R2 et fragments R3 du reçu. État proposed_not_applied ; aucune case/tâche/base ou code modifié.

### DEATH-REAL-RENDER-OBSERVATION-01

Objectif : Observer le parcours mort->compte à rebours->réapparition sur le client actuel.

Écart : 14essais hérités de code/source ne sont pas une capture du véritable écran de mort.

Travail / consommateur : Réutiliser sources et tests identiques, vérifier une mort réelle de propriétaire et autre joueur vivant, pause/reprise, zéro encore mort et respawn, deuxtailles/DPI, puis nettoyage; garder recap local distinct.

Critères de fin : Images/texte/état producteur corrélés, délai attendu et retrait observés, aucune confusion avec recap/GPUpréparé; limites de fidélité native et late scaling conservées.

Entrée nécessaire à la reprise : Binaire/source/ressources actuels et scénario déterministe autorisé; ne pas annoncer rendu/GPUdepuis un ancien build0.

Dépendances : `DEATH-TIMER-CLOCK-FORMAT-01`, `DEATH-TIMER-VIEW-LIFETIME-01`, `DEATH-SCREEN-NATIVE-VISUAL-01`, `SYS-04.7-08`, `SYS-04.7-10`.

Preuves attendues : Exact source/binaries/state and expected/observed named death case; native clock/visual/runtime versus local CPU/mock evidence distinct; no whole game/champion completion.

Sources :24champs, blocs/shader R2 et fragments R3 du reçu. État proposed_not_applied ; aucune case/tâche/base ou code modifié.

### Quatre dimensions séparées

| Dimension | Conclusion |
|---|---|
| Audit | Parent source→délai→owner→texte/cadre→screen/recap/lifecycle documenté ; clôture seulement après R1–R7 indépendants. |
| Implémentation | Partielle avec acquis réels : baseline/délai, textes/cadre et recap local ; pas écran natif complet ou toutes résurrections. |
| Vérification | Réussite documentaire163contrôles ;14tests hérités ciblés retrouvés avec sources égales ; rendu/runtime courant non exécuté. |
| Acceptation humaine | Aucune acceptation de fonctionnalité demandée ou revendiquée. |

Aucun écart fonctionnel corrigé. Résolu pour l’audit : la minuterie n’est pas seulement un cadre ou une fonction isolée ; son consommateur texte est retrouvé. Les anciens tests plus avancés remplacent l’interprétation erronée du drapeau de draft. La désaturation native et les horloges/special states restent séparées des acquis locaux. La tâche, l’inconnue et le goal global restent ouverts.

## R7 — Livrables, identités et conservation

Nouveaux fichiers uniquement :
- [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.3-04-DEATH-SCREEN-01/audit-unit.json) — périmètre préalable.
- [verify_death_screen.py](F:/OpenLeague-work/audit-units/AUD-17.3-04-DEATH-SCREEN-01/verify_death_screen.py) — lecteur producteur.
- [death-screen-proof.json](F:/OpenLeague-work/audit-units/AUD-17.3-04-DEATH-SCREEN-01/death-screen-proof.json) — reçu et sources structurées.
- [AUD-17.3-04-DEATH-SCREEN-01.md](F:/OpenLeague/docs/audit/units/AUD-17.3-04-DEATH-SCREEN-01.md) — présent rapport.
- [verify_delivery.py](F:/OpenLeague-work/audit-units/AUD-17.3-04-DEATH-SCREEN-01/verify_delivery.py) — lecteur indépendant.
- [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.3-04-DEATH-SCREEN-01/delivery-readback.json) — conclusion documentaire séparée.

Reçu brut : 351256octets ; SHA-256 **23e81827deb6944f968324904d84bfb132e4c3b48b1a7c55651911cc762c0164**. audit_scope_closed=false est intentionnel : la relecture indépendante contrôle les sept rubriques avant clôture de ce seul périmètre.

Git main/HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76fichiers suivis déjà modifiés conservés. **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs** et pièce jointe du goal inchangés. Aucune base ouverte, aucun Store/work_cli/serveur de suivi invoqué, aucun retrait, reset, suppression, installation, migration, redémarrage ou lancement de jeu.

Relecture : identités sources natives et ancien runtime fermé,24valeurs/typedHUD/shader,14lignes de logs, septsources égales, vrais consommateurs, sixdimensions et cinqcorrections, quatre dimensions de compte rendu. --check-only ne crée pas de reçu ; ne pas répéter la vérification après réussite sans nouvelle raison.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.3-04-DEATH-SCREEN-01\verify_delivery.py' --check-only
```

Condition d’arrêt : conclure ce lot après relecture puis prendre une autre exigence non auditée. Les reprises sont R5 ; aucun changement du goal, de ses critères, de son statut, de l’application ou des bases n’en découle.
