# AUD-17.1-08-COUNTERS-01 — Or, score, temps et compteurs d’équipe

Contrôles : 2026-10-30T18:50:51.516756+00:00. Goal SYS-01.2-02, inchangé et toujours incomplet. Lot précédent classé progrès : livraison documentaire SYS-17.1-07, sans clôture fonctionnelle.

## R1 — Exigence, portée et décision de clôture

**SYS-17.1-08** : « Afficher or, score, temps de partie et compteurs d’équipe ». Référence stable **OLF-07ac5819-6da1-5862-a80d-a6ae4a7b6c79** ; inconnue réutilisée **OLU-a3333160-a89a-5d4c-944b-a583182fd948**, toujours `open`. La tâche conserve `a_faire`, `implementation_complete: false`, `acceptance_complete: false`.

Ce lot couvre les quatre clauses au niveau de leurs sources et consommateurs actuels : or, score individuel, horloge de partie et compteurs d’équipe. Il classe aussi les variantes conditionnelles et les champs voisins découverts dans les mêmes ressources ; aucune variante n’est effacée ni activée arbitrairement. Résultat de clôture : un état documentaire complet de cette exigence, validé par les sept rubriques et une relecture indépendante ; aucune promesse de fonctionnalité complète.

| Dimension | Conclusion |
|---|---|
| Audit | Terminé uniquement si delivery-readback.json confirme les sept rubriques et tous ses contrôles. Le reçu brut reste audit_scope_closed=false afin de ne pas se valider lui-même. |
| Implémentation | Partielle : or/temps et cadre Titan existent ; K/D/A produit dans le core et visible dans le diagnostic ; raccordement des autres compteurs natifs non identifié dans les sélecteurs inspectés. |
| Vérification | Sources, identités, liaisons, code et refus relus ; captures natives et essais Rust anciens hérités seulement. Aucune nouvelle exécution du jeu. |
| Acceptation humaine | Non demandée ; aucune acceptation implicite. |

Référence : LoL PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB, catalogue 4.20.1 distinct. La date du build n’est pas transformée en date de déploiement. Périmètre actuellement chargé : HUD ShadowIsles, liste normale ; listes inversée/replay conservées comme contexte, sans comportement historique revendiqué.

Prérequis : phase D17 ; lot D17-SYS-17-1, qui comprend cette tâche et requiert D05-SYS-05-5. Ce dernier lot reste a_faire et requiert D05-SYS-05-1/02. L’audit n’attend pas la réalisation de ces fonctionnalités pour décrire leur état, mais ne les déclare pas acquises.

## R2 — Sources, identité, provenance et limites

Deux archives ont été relues : la copie `F:/OpenLeague/data/4.20/archives/menu/HUD.zip` et l’original `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip`. Toutes deux : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

Binaire des captures héritées : `League of Legends.exe` du même déploiement, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Son identité a été revérifiée ; il n’a pas été exécuté dans ce lot.

Les quatre membres ci-dessous sont réellement déclarés dans la liste normale. Pour chacun des 25 Text candidats, le nom, l’offset brut, le fichier, les propriétés source, l’identifiant HUD antérieur et le résultat de parseur natif hérité ont été comparés. Tous ces Text sont acceptés dans leur capture héritée ; cela ne prouve ni le choix du mode ni leur affichage.

| Membre sous HUD/Elements | Text examinés | SHA-256 |
|---|---:|---|
| ShadowIslesChampionLeft.ini | 1 | `7a23abc56478e252a3d3174e24d4cbf8cbb8e03ae71f8f1ec6cb6c581bd1cf14` |
| ShadowIslesTitanBar.ini | 12 | `fa6066d540e93f7cc0b2fd74c42a0589b658513293ce23c6779323ab36f1a23c` |
| TitanBarDominion.ini | 2 | `87cdf30064a075176f6a58d656f51af7e669fff03e2b357e860d40910d1fafef` |
| ShadowIslesTeamFrames.ini | 10 | `386ff355b5c9ec3385bea89bb9508a6e828e1ebd5a807f07eb7c10f4cee485ac` |

**Classement complet des 25 candidats :** 2 champs déjà raccordés (GoldStat/GameTime), 3 K/D/A individuels, 1 compteur de sbires individuel, 2 scores d’équipe, 4 champs du groupe FirstBlood, 2 du groupe Odin/Dominion, 5 niveaux de cadres d’équipe, 5 délais de réapparition de ces cadres et 1 contexte technique FPS. Le FPS n’est pas compté comme un score de progression de partie ; sa classification explicite n’autorise pas son retrait.

Dans Scenes.ini, RealTimeOverlay et TitanBarTime sont initialement activés ; TitanBarClassic, TitanBarFirstBlood, TitanBarOdin, TitanBarOdinOverlay et Team0…4/Team0Realtime…4Realtime sont initialement désactivés. Une propriété Enabled=1 d’un Text enfant ne prouve pas l’activation de son groupe. La liste de ressources seule n’établit donc pas que les quatre compteurs FirstBlood ou les deux scores Odin doivent être visibles en 3v3.

Les cinq emplacements de cadres d’équipe ne prouvent ni cinq participants actifs, ni cinq alliés, ni un ordre de roster. Le mapping des emplacements et l’autorisation de chaque champ restent à qualifier. Le nom du fichier Dominion et les groupes Odin sont des indices de contexte, pas une qualification du producteur de score.

Preuves réutilisées sans nouveaux essais équivalents :

- AUD-22.1-04-HUD-01 : inventaire initial des Text et identifiants stables.
- AUD-22.1-05-NUMERIC-01 : règles locales, formats et limites GoldStat/GameTime ; les modules consommateurs cités sont toujours identiques.
- AUD-17.2-06-SCORE-01 : roster public, Score, diagnostic, résultats terminaux et distinction du scoreboard live ; ses dix fichiers consommateurs uniques sont toujours identiques.
- AUD-17.1-07-TARGET-01 : routes récentes de chargement, projection, transport, réception et enregistrement des plugins, relues par empreinte.
- AUD-17.4-07-PAUSE-RESUME-01 : contexte de pause déjà établi ; le garde actuel de boucle serveur est cité directement.

Les totaux d’anciens tests ne deviennent pas des tests de la version graphique courante. Aucun nouveau passage REA n’est utile pour la seule liaison documentaire présente ; une analyse native ultérieure exige un appelant nouveau d’activation de mode, de compteur ou de format.

## R3 — Consommateurs réels et contrat actuel

| Chemin actuel | Ce qu’il établit | Limite |
|---|---|---|
| native_zip_provider.rs:75–118 | Charge la liste ShadowIsles normale, structure, groupes, textures et requêtes de fontes. | Charger n’est pas dessiner ni alimenter les compteurs. |
| native_hud_widgets.rs:66–127 | Sélectionne 18 Text ; GoldStat et GameTime font partie de cette sélection. Valeurs tirées du snapshot du joueur propre. | Aucun des noms de compteurs manquants n’est sélectionné par ce filtre. |
| native_hud_panels.rs:8–18 | Dessine le cadre TitanBarFrame parmi trois cadres statiques. | Présence du cadre distincte des valeurs, icônes et états natifs d’activation. |
| core/lib.rs:154–207,744–778 | Champion contient gold/score ; snapshot copie les corps, tick et roster. | Copie interne du corps distincte des permissions publiques de chacun de ses champs. |
| core/champion_kills.rs:1–52 | Produit kills/deaths/assists, kill_streak/death_streak ; attribue l’or et publie des événements de mort. | Politiques détaillées explicitement reconstruites dans ce module ; ce n’est pas une récupération intégrale du serveur Riot. |
| core/vision.rs:15–22,137–167,208–219 | RosterEntry=id/champion/team/score ; snapshot_for retire les corps invisibles mais conserve le roster ; snapshot_for_atomic complète cette projection. | Niveau, échéance de réapparition et CS ne sont pas des champs de RosterEntry. Leur absence ne doit pas devenir zéro. |
| server/session_host.rs:158–167 → client/main.rs:1317–1335 | Récupère le snapshot du participant, prépare les paquets et reçoit un snapshot courant côté client. | Aucun nouveau test de bout en bout réseau exécuté ici. |
| core/world.rs:418–453 | Le crédit d’une unité attribue de l’or et de l’expérience. | Dans ce chemin et le schéma Champion inspectés, aucun compteur CS n’est identifié. Une prime en or n’est pas un compteur de sbires. |
| main.rs:1682–1685 | Le diagnostic affiche K/D/A du joueur propre ; unités utilise snapshot.units.len(). | Ce nombre d’unités n’est ni CS ni total permanent d’équipe. Le diagnostic F3 n’est pas le HUD natif des scores. |

**Or :** garde finie, positive ou nulle, inférieure ou égale au maximum u32, puis floor et décimal entier. Toute erreur remonte et efface les glyphes ; aucun zéro de substitution. Cette règle locale est concrète ; le formatteur historique GoldStat, ses éventuels formats et le rendu actuel ne sont pas entièrement qualifiés.

**Temps :** le client utilise snapshot.tick / TICK_RATE, avec TICK_RATE=30, puis minutes:secondes à deux chiffres. Aucun passage aux heures n’apparaît dans cette règle. Simulation::advance incrémente tick après la sortie anticipée sur winner ; la boucle serveur relue ne l’appelle pas pendant pause.is_paused(). C’est un contrat de code local, sans qualification de l’horloge historique, de son lissage ou de la ponctuation native.

**Fraîcheur :** l’absence de snapshot ou de joueur propre efface le rendu via les branches existantes. Le contrôle connexion/session retire spécifiquement RespawnTimer ; il n’établit pas une protection générale de GoldStat/GameTime contre tous les états périmés. À qualifier séparément avant de revendiquer ce résultat.

**Scores publics et durée de vie :** Score existe dans le roster et les K/D/A sont produits explicitement. Le champ possède serde(default), donc un ancien message sans score est indiscernable d’un vrai score nul après désérialisation. Le roster est construit depuis Simulation.players. La conservation des scores de participants retirés n’est pas prouvée par la seule somme des membres actuels. Les corps visibles ne peuvent pas servir de total d’équipe.

**Journal :** champion_kills garde au maximum 128 événements ; il n’est pas une autorité exhaustive de total de match ni de compteur CS. Les résultats terminaux immuables déjà audités sont conservés dans leur propre parcours et ne constituent pas une source live de remplacement.

Recherche nouvelle bornée : noms littéraux précis des Text non raccordés sur 1168 fichiers Rust/JS/HTML du corpus identifié ; zéro occurrence. Recherche distincte des tokens minions_killed/creep_score/cs_count/minion_kill_count/team_kills/enemy_kills : zéro occurrence. Tous les fichiers du corpus et ses chemins sont identiques à la preuve antérieure. Ces résultats complètent la lecture des sélecteurs et schémas ; ils ne constituent pas une preuve d’absence sémantique dans chaque algorithme possible.

## R4 — Attendu, observé et contrôles réellement exécutés

| Contrôle | Attendu | Observé |
|---|---|---|
| Réutilisation | Ne pas répéter les essais sans changement | Consommateurs NUMERIC et SCORE identiques ; preuves et limites anciennes conservées. |
| Sources | Champs individualisés et comparés à l’original | 25 identifiants HUD, quatre membres ZIP, captures et groupes comparés ; conforme. |
| Périmètre des modes | Ne pas prendre un nom de ressource pour un mode actif | Classic/FirstBlood/Odin/cadres/FPS séparés ; conditions dynamiques ouvertes. |
| Nominal or/temps | Source/contrat local, consommateur et limites identifiés | GoldStat/GameTime raccordés ; test source contient 1234.75→1234 et 61 secondes→1:01, mais ce test Rust n’est pas réexécuté ici. |
| Refus et limites | Établir ce que le code fait et ce qui a été exécuté | Joueur absent/snapshot absent/erreurs de valeurs effacent ; garde gold non finie, négative, hors u32 citée ; tests Rust de refus lus seulement. |
| K/D/A et équipe | Ne pas confondre données produites avec HUD terminé | Producteur Score présent, consommateur natif de scores non identifié ; total permanent et CS non déduits d’un journal ou de corps visibles. |
| Conservation | Pas de modification des acquis | 25 fichiers protégés et cinq registres identiques ; HEAD et 76 fichiers suivis déjà modifiés conservés. |

Producteur exécuté : Python existant, -X utf8 -E -B, verify_match_counters.py ; code 0, **355 contrôles réussis**. Détail attendu/observé dans checks du reçu. Actions : lecture ZIP/JSON/mmap, SHA-256, liaisons de Text et captures héritées, comparaisons de sources/consommateurs, recherche lexicale bornée et lecture Git.

**Non exécutés :** compilation, tests Rust, code natif ou émulateur, jeu actuel/historique, réseau, GPU/capture, application de suivi, base de données, installation, migration, changement du goal. Les captures natives de parseur et les tests Rust plus anciens restent hérités.

Deux lectures exploratoires ont utilisé des chemins supposés erronés (AUD-17.md dérivé à tort d’un nom contenant des points, puis core/src/ordinary_pause.rs). Les noms réels ont été identifiés par inventaire ; ces erreurs du lecteur n’ont produit aucune conclusion de ressource manquante et aucun changement. Le producteur livré termine sans échec.

## R5 — Écarts, inconnues et conditions de reprise

- Le raccordement or/temps est acquis au niveau du code. Les sources de formatage historiques, leur précision, l’horloge native, la fraîcheur et la comparaison graphique restent ouverts. Réutiliser NUM-GOLD-FORMAT-01, NUM-GAMETIME-FORMAT-01 et NUM-CURRENT-RENDER-01 au lieu de créer des doublons.
- Pour KillsStat/DeathsStat/AssistsStat : raccorder séparément le champ autorisé au Text original, définir format/indisponible et vérifier mutation, mort/réapparition et changement de session dans le vrai client. Producteur Score existant à conserver.
- Pour MinionKillsStat : identifier un compteur de last-hits et sa règle de crédit (dont familiers, monstres et événements non crédités), sa persistance et son transport. Ne pas transformer la récompense en or ou le nombre d’unités en CS.
- Pour TeamKillsStat/EnemyKillsStat : définir les totaux persistants, l’équipe relative au destinataire et la durée de vie du roster. Une somme des corps visibles, des seuls participants encore présents ou des 128 événements ne suffit pas.
- Pour FirstBlood et Odin/Dominion : nouvelle entrée attendue = sélecteur natif du mode/groupe et producteur de valeur, ou périmètre local explicite attesté comme reconstruction. Une désactivation initiale ne prouve pas une exclusion permanente.
- Pour les dix indicateurs de cadres d’équipe : obtenir ordre/population des slots, audience du niveau et délai de réapparition, absence/dernier connu, changement de session. Ni cinq définitions ni un Champion complet reçu ne valent autorisation historique de ces champs.
- Pour la validation fonctionnelle : exécution réelle du consommateur, sources/binaires identifiés, captures à résolution déclarée, nominal/refus/valeur absente. Tant que ces entrées manquent, fonctionnalité et inconnue d’origine restent ouvertes.

Arrêt de la recherche courante : les 25 candidats sont classés, les consommateurs existants et les limites d’absence sont établis. Reprise uniquement avec nouveau producteur/selector natif, modification d’un consommateur ou preuve runtime pertinente. Ne pas répéter les mêmes empreintes et recherches pour accumuler des rapports.

## R6 — Actions indépendantes et réutilisation

Les lignes suivantes sont des propositions documentaires ou des corrections antérieures réutilisées, sans adoption dans le plan ni modification de ses critères. Chaque champ possède un résultat propre, ses sources et son entrée de reprise dans field_corrections du reçu. Les 24 champs de jeu/contextes sont couverts une fois ; FPS est classé voisin technique avec justification d’absence de correction dans cette exigence.

| Correction | Champ / résultat unique | Condition de reprise |
|---|---|---|
| `NUM-GOLD-FORMAT-01` | GoldStat : Qualify historical GoldStat formatter and local unsigned32 nominal/fraction/large/refusal boundaries; preserve existing widget. | Native caller/format trace or explicitly versioned local display policy; no assumed grouping. |
| `NUM-GAMETIME-FORMAT-01` | GameTime : Qualify GameTime authority/format, pause/end and minute/long-match boundaries; retain current tick-based value as local policy. | Native clock/formatter trace or explicit local policy; new source required to reopen unchanged search. |
| `HUD-COUNTER-KillsStat-01` | KillsStat : Bind this original Text to authorized own Score, update after death/respawn, clear unavailable/session-mismatched state; compare original formatter and actual current render. | Current Score producer plus exact native widget binding/format or declared local reconstruction; real client trace for rendering. |
| `HUD-COUNTER-TeamMinionKillsStat-01` | TeamMinionKillsStat : Resolve mode/group applicability and authoritative value for this field; then implement only its qualified mode or explicitly mark it out of the selected reference with evidence. | Native TitanBarFirstBlood activation/value producer or explicit scoped mode contract; do not activate by name. |
| `HUD-COUNTER-EnemyMinionKillsStat-01` | EnemyMinionKillsStat : Resolve mode/group applicability and authoritative value for this field; then implement only its qualified mode or explicitly mark it out of the selected reference with evidence. | Native TitanBarFirstBlood activation/value producer or explicit scoped mode contract; do not activate by name. |
| `HUD-COUNTER-DeathsStat-01` | DeathsStat : Bind this original Text to authorized own Score, update after death/respawn, clear unavailable/session-mismatched state; compare original formatter and actual current render. | Current Score producer plus exact native widget binding/format or declared local reconstruction; real client trace for rendering. |
| `HUD-COUNTER-AssistsStat-01` | AssistsStat : Bind this original Text to authorized own Score, update after death/respawn, clear unavailable/session-mismatched state; compare original formatter and actual current render. | Current Score producer plus exact native widget binding/format or declared local reconstruction; real client trace for rendering. |
| `HUD-COUNTER-MinionKillsStat-01` | MinionKillsStat : Identify last-hit/minion attribution and persistent counter, then bind MinionKillsStat with unavailable distinct from zero; qualify pet/monster and death/session boundaries. | Counter producer or exact native/server rule; inspect existing credit path first, gold is not a kill count. |
| `HUD-COUNTER-TeamKillsStat-01` | TeamKillsStat : Define persistent per-team aggregate and viewer-relative team mapping; bind this Text; keep disconnect/reconnect, hidden actors and environment deaths correct under a named contract. | Lifetime team totals and audience policy; public roster or 128-event ring alone insufficient to prove history. |
| `HUD-COUNTER-TextFriendlyKillsFirstBlood-01` | TextFriendlyKillsFirstBlood : Resolve mode/group applicability and authoritative value for this field; then implement only its qualified mode or explicitly mark it out of the selected reference with evidence. | Native TitanBarFirstBlood activation/value producer or explicit scoped mode contract; do not activate by name. |
| `HUD-COUNTER-TextEnemyKillsFirstBlood-01` | TextEnemyKillsFirstBlood : Resolve mode/group applicability and authoritative value for this field; then implement only its qualified mode or explicitly mark it out of the selected reference with evidence. | Native TitanBarFirstBlood activation/value producer or explicit scoped mode contract; do not activate by name. |
| `HUD-COUNTER-EnemyKillsStat-01` | EnemyKillsStat : Define persistent per-team aggregate and viewer-relative team mapping; bind this Text; keep disconnect/reconnect, hidden actors and environment deaths correct under a named contract. | Lifetime team totals and audience policy; public roster or 128-event ring alone insufficient to prove history. |
| `HUD-COUNTER-ScoreStat-01` | ScoreStat : Resolve Odin score/overlay applicability and authoritative value, including the distinction between base and overlay; prove selected mode before display. | Native mode selector and score producer; generic champion kills are not proof of this score. |
| `HUD-COUNTER-ScoreStatOverlay-01` | ScoreStatOverlay : Resolve Odin score/overlay applicability and authoritative value, including the distinction between base and overlay; prove selected mode before display. | Native mode selector and score producer; generic champion kills are not proof of this score. |
| `HUD-COUNTER-TeamLevel0-01` | TeamLevel0 : Resolve frame-slot participant mapping and authorized level, then update/clear only this slot across visibility and roster/session transitions. | Historical slot order/population and per-field disclosure; five frame definitions do not prove five active allies. |
| `HUD-COUNTER-TeamLevel1-01` | TeamLevel1 : Resolve frame-slot participant mapping and authorized level, then update/clear only this slot across visibility and roster/session transitions. | Historical slot order/population and per-field disclosure; five frame definitions do not prove five active allies. |
| `HUD-COUNTER-TeamLevel2-01` | TeamLevel2 : Resolve frame-slot participant mapping and authorized level, then update/clear only this slot across visibility and roster/session transitions. | Historical slot order/population and per-field disclosure; five frame definitions do not prove five active allies. |
| `HUD-COUNTER-TeamLevel3-01` | TeamLevel3 : Resolve frame-slot participant mapping and authorized level, then update/clear only this slot across visibility and roster/session transitions. | Historical slot order/population and per-field disclosure; five frame definitions do not prove five active allies. |
| `HUD-COUNTER-TeamLevel4-01` | TeamLevel4 : Resolve frame-slot participant mapping and authorized level, then update/clear only this slot across visibility and roster/session transitions. | Historical slot order/population and per-field disclosure; five frame definitions do not prove five active allies. |
| `HUD-COUNTER-TeamRespawnTimer0-01` | TeamRespawnTimer0 : Resolve this frame-slot authorized respawn deadline/countdown and unavailable state; retain current own-respawn formatter as separate qualified primitive. | Historical frame mapping, death/respawn permission/clock and lifecycle projection; no private full Champion fallback. |
| `HUD-COUNTER-TeamRespawnTimer1-01` | TeamRespawnTimer1 : Resolve this frame-slot authorized respawn deadline/countdown and unavailable state; retain current own-respawn formatter as separate qualified primitive. | Historical frame mapping, death/respawn permission/clock and lifecycle projection; no private full Champion fallback. |
| `HUD-COUNTER-TeamRespawnTimer2-01` | TeamRespawnTimer2 : Resolve this frame-slot authorized respawn deadline/countdown and unavailable state; retain current own-respawn formatter as separate qualified primitive. | Historical frame mapping, death/respawn permission/clock and lifecycle projection; no private full Champion fallback. |
| `HUD-COUNTER-TeamRespawnTimer3-01` | TeamRespawnTimer3 : Resolve this frame-slot authorized respawn deadline/countdown and unavailable state; retain current own-respawn formatter as separate qualified primitive. | Historical frame mapping, death/respawn permission/clock and lifecycle projection; no private full Champion fallback. |
| `HUD-COUNTER-TeamRespawnTimer4-01` | TeamRespawnTimer4 : Resolve this frame-slot authorized respawn deadline/countdown and unavailable state; retain current own-respawn formatter as separate qualified primitive. | Historical frame mapping, death/respawn permission/clock and lifecycle projection; no private full Champion fallback. |

Références partagées réutilisées, sans les convertir en HUD complet :
- `NUM-CURRENT-RENDER-01` : Existing integration/viewport proof for the retained GoldStat/GameTime route; not a new copy of the numeric correction.
- `SCORE-PUBLIC-ROWS-01` : Existing public roster data contract only; scoreboard rows do not implement top-HUD KDA.
- `SCORE-ROSTER-LIFETIME-01` : Existing departure/reconnect lifetime correction; prerequisite for deriving persistent team totals from roster.
- `SCORE-COLUMN-PUBLIC-01` : Existing per-field public authority correction; relevant to CS/level/respawn but not proof that these fields already exist in RosterEntry.

| ID HUD existant | Text | Groupe | Classe actuelle |
|---|---|---|---|
| `HUD-8a03e123a0fbd692` | GoldStat | RealTimeOverlay | existing_local_numeric |
| `HUD-1c82d1efc3d2711f` | GameTime | TitanBarTime | existing_local_numeric |
| `HUD-99cef708b5cc31d5` | KillsStat | TitanBarClassic | classic_local_KDA |
| `HUD-ee9b9d0b89febf98` | TeamMinionKillsStat | TitanBarFirstBlood | conditional_FirstBlood |
| `HUD-cd507246984c3e54` | EnemyMinionKillsStat | TitanBarFirstBlood | conditional_FirstBlood |
| `HUD-9e862dbef83decf9` | DeathsStat | TitanBarClassic | classic_local_KDA |
| `HUD-69f263fb9ea2eb30` | AssistsStat | TitanBarClassic | classic_local_KDA |
| `HUD-5746c9d71232213d` | MinionKillsStat | TitanBarClassic | classic_local_CS |
| `HUD-eada0bf99aa00797` | FPS | TitanBarFrameRate | adjacent_technical_FPS |
| `HUD-9fabcc996941872b` | TeamKillsStat | TitanBarClassic | classic_team_kills |
| `HUD-09bd3ff60a42c8c7` | TextFriendlyKillsFirstBlood | TitanBarFirstBlood | conditional_FirstBlood |
| `HUD-76b63f3904c0270d` | TextEnemyKillsFirstBlood | TitanBarFirstBlood | conditional_FirstBlood |
| `HUD-b837ff5f648f33cd` | EnemyKillsStat | TitanBarClassic | classic_team_kills |
| `HUD-28a3b78e5f1e7053` | ScoreStat | TitanBarOdin | conditional_Odin_Dominion |
| `HUD-e5cf294bd85eaf5f` | ScoreStatOverlay | TitanBarOdinOverlay | conditional_Odin_Dominion |
| `HUD-f8cb00d422282f4b` | TeamLevel0 | Team0Realtime | team_frame_level |
| `HUD-5c5a20c5ca8c3253` | TeamLevel1 | Team1Realtime | team_frame_level |
| `HUD-989ac3d894703639` | TeamLevel2 | Team2Realtime | team_frame_level |
| `HUD-5c0d84734a21942f` | TeamLevel3 | Team3Realtime | team_frame_level |
| `HUD-bb43960d3ae16af6` | TeamLevel4 | Team4Realtime | team_frame_level |
| `HUD-90e0b9f9d2545bd4` | TeamRespawnTimer0 | Team0 | team_frame_respawn |
| `HUD-441a54b21620cdc0` | TeamRespawnTimer1 | Team1 | team_frame_respawn |
| `HUD-716ea0c100fc356b` | TeamRespawnTimer2 | Team2 | team_frame_respawn |
| `HUD-c556cc9e19ba0631` | TeamRespawnTimer3 | Team3 | team_frame_respawn |
| `HUD-47a24a2bd4fad5ec` | TeamRespawnTimer4 | Team4 | team_frame_respawn |

## R7 — Livraison, preuves et relecture

Nouveaux fichiers uniquement :

- Rapport : `F:/OpenLeague/docs/audit/units/AUD-17.1-08-COUNTERS-01.md`.
- Dossier `F:/OpenLeague-work/audit-units/AUD-17.1-08-COUNTERS-01/` : verify_match_counters.py, match-counters-proof.json, verify_delivery.py, delivery-readback.json.

Reçu principal : SHA-256 `154be70bb833c97a69ff62e3ce48fb8911176279a36df25283f85c60319f227a`. Producteur : `d401200bff199058f8e57cc8800e0a2b165d3fa6926fd34584b24dc8944881a1`. Les versions des sources, propriétés, offsets, fragments avec lignes, recherches, prérequis et résultats attendus/observés sont conservés dans ce reçu.

La relecture indépendante recontrôle les identités, reconstruit les liens depuis les offsets de l’inventaire, compare les membres et captures originales, les 25 classes, les 24 actions et les sept rubriques. delivery-readback.json porte la clôture documentaire si tous ces contrôles passent ; aucune clôture fonctionnelle ni du goal n’en découle.

Recontrôle sans écriture : Python existant -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.1-08-COUNTERS-01/verify_delivery.py --check-only. Les écritures de reçus sont exclusives ; aucune preuve n’est remplacée. Les cinq registres normatifs restent inchangés. Les 19 fichiers logiciels gelés et six documents de contexte restent identiques ; aucune base ouverte.

Résolu : les quatre clauses ont un état source/consommateur précis, les variantes et indicateurs voisins sont séparés, les acquis GoldStat/GameTime/Score sont conservés, les données non prouvées ne sont pas inventées. Ouvert : raccordement et qualification fonctionnels des compteurs, règles publiques/durée de vie, activations des modes et comparaison du rendu. Le goal et le jeu restent incomplets.
