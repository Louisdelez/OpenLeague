# AUD-17.2-06-SCORE-01 — Scoreboard en partie, sources et données publiques

Contrôle du 30 octobre 2026 ; reçu à 13:45:10 UTC. Parent SYS-17.2-06 « Afficher les statistiques publiques dans le scoreboard ». Clauses connexes SYS-13.3-01/02, SYS-17.4-01 et SYS-22.1-04. Résultat documentaire de SYS-01.2-02. Aucun changement du Goal, du jeu, du suivi, de ses registres ou bases.

## 1. Périmètre, critères et décision

Question : un scoreboard public en cours de partie est-il raccordé ; quelles entrées et ressources natives sont disponibles ; quelles données peuvent être consommées sans confondre état visible, roster public et résultat terminal ?

Critères : relever les événements d'entrée et leurs sections exactes ; identifier les deux variantes graphiques fournies et la limite de leur sélection ; classer tous les candidats actuels de texte/entrée ; décrire les champs du roster et la projection des champions cachés ; conserver les acquis et définir des reprises précises.

**Audit terminé pour cette frontière sources/consommateurs.** Aucun scoreboard public ordinaire en cours de match n'est identifié dans les routes de présentation et d'entrée inspectées. Un tableau de résultats terminaux et le diagnostic F3 existent ; ils sont conservés et ne sont pas promus en scoreboard live.

| Dimension | État |
|---|---|
| Audit | Terminé sur les entrées, candidats graphiques, consommateur actuel et projection publique examinés |
| Implémentation | Résultats terminaux présents ; roster public partiel disponible ; scoreboard live non raccordé dans les routes inspectées |
| Vérification | Octets, provenance, configurations, vocabulaire et code contrôlés ; aucun nouveau test Rust, réseau ou graphique |
| Acceptation humaine | Non demandée |

SYS-17.2-06 reste ouverte. La liste complète des colonnes natives, leurs règles d'audience et la sélection graphique historique ne sont pas entièrement qualifiées par ce sous-lot.

## 2. Sources, identité et limites historiques

### Événements déclarés

Les deux fichiers fournis sont `DATA/cfg/defaults/Input.ini` et `DATA/cfg/input.ini`, sous le deploy 0.0.1.68 du client 4.20 sur D. Ils sont identifiés par empreinte dans le reçu.

| Section | Événement | Binding dans les fichiers fournis |
|---|---|---|
| GameEvents | evtShowScoreBoard | [o] |
| HUDEvents | evtHoldShowScoreBoard | [Tab] |
| GameEvents | evtToggleScoreboardGoldDisplay | [x] |

Le fichier input.ini fourni ne remplace pas ces trois déclarations. Leur lecture/merge local est distingué de l'exécution du chargeur original. Le nom evtHoldShowScoreBoard ne qualifie pas à lui seul toute la séquence native de maintien, relâchement, focus et priorités. Le binding X ne constitue pas une autorisation de révéler l'or des adversaires.

### Variantes graphiques déjà recensées

| Ressource sous DATA | Octets compressés / SHA256 | Source stable et release de membre héritée |
|---|---|---|
| Menu/Scoreboard.gfx | 14743 ; dee7a0f8f29de0ef63326bec2d65834a584ac93cc72ba1e49d261aff044e93f3 | OLS-f67143b7-d354-5deb-b2d8-134c8340f27d ; 0.0.0.79 |
| Menu_SC4/Scoreboard.gfx | 20167 ; b5d81535368cd674a1514925fc5e8765fd3c5cf2aad237e4608f05a9ff832dbd | OLS-f041f3a1-1a29-59a6-b43c-0746879945a2 ; 0.0.1.7 |

Les deux enregistrements de `docs/fidelity_sources_4_20.json` les attribuent au projet sélectionné lol_game_client 0.0.1.7. Les octets courants correspondent au SHA256 et au MD5 de manifeste déclarés. Le reçu de couverture OLS-ea56e35a-41ab-573c-8fb6-cf3d83b3045c est réutilisé sur F, SHA256 `e1d00324c012e28ff0eee102ca8f57bf8929f93f589c4627862ac45d07d4e9df`. Son ancien chemin E reste conservé comme provenance. Les manifestes complets ne sont pas reparsés dans ce lot.

Dans les deux cas, runtime_precedence_qualified reste false. L'appartenance au manifeste et le nom du dossier ne décident pas de la variante effectivement utilisée en partie. Aucun choix silencieux de Menu_SC4 n'est fait.

Vingt et un DDS de même préfixe sont présents et conformes à leurs identités recensées : dix-huit sous Menu, trois sous Menu_SC4. Une décompression locale du payload CFX retrouve seize noms DDS littéraux dans le premier et trois dans le second ; les fichiers correspondants existent. Scoreboard_I37.dds et Scoreboard_I50.dds sont présents mais non retrouvés par cette recherche de littéraux. Ils ne sont ni supprimés ni déclarés inutilisés globalement : ce n'est pas une analyse complète des dépendances GFx.

Observation à préserver : pour Menu, la longueur déclarée et la taille décompressée plus huit valent 48963. Pour Menu_SC4, elles valent respectivement 60672 et 61448, écart776. La décompression n'est pas le parseur GFx natif. **Aucune corruption n'est prouvée par cet écart** ; les octets correspondent à la référence recensée. Sa signification demeure à qualifier avant toute interprétation ou modification d'en-tête.

### Vocabulaire de langue

Les profils en_GB et fr_FR, déjà identifiés dans TOOLTIP-01, contiennent chacun les mêmes 106 clés dont le nom mentionne scoreboard : 18 de vocabulaire de film, cinq d'aide aux bindings, deux d'aide HUD, deux de tutoriel, neuf de replay et 70 libellés de statistiques de contexte non qualifié. Ce ne sont pas 106 colonnes d'un scoreboard live.

Les clés littérales retrouvées dans les deux films existent dans ces profils. Le vocabulaire fourni comprend notamment les rôles joueur, délai de mort, K/D/A, objets, sbires tués, ultime et compteurs d'équipe. Il ne démontre pas que chaque rôle est actif pour chaque mode/audience. flash_scoreboard_alive est présent avec une valeur vide dans les deux langues : vide ne signifie pas clé absente et n'autorise pas d'inventer un libellé.

## 3. Consommateurs et frontière de données actuels

### Résultats terminaux et diagnostic

`match_results_ui.rs:24-41` lit MatchResult et non le roster vivant. Le panneau est visible seulement lorsque result existe et que native_endgame_ui::View.dismissed est vrai. Il affiche un résultat français, durée, équipes, champion, niveau, K/D/A et or restant ; son bouton retourne au launcher. setup/update sont enregistrés dans main.rs:810,853.

`core/match_results.rs` ne capture un résultat que lorsque winner existe, puis refuse de recapturer si final_result est déjà présent. Les joueurs sont ceux de Simulation.players au moment de la capture. Les tests présents dans le code examinent notamment la conservation après retrait d'un joueur **après capture** ; cela ne qualifie pas la politique des départs antérieurs.

`main.rs:1545-1572,1685` contrôle le diagnostic F3 et peut y montrer les valeurs du joueur local. Ce diagnostic n'est pas le tableau public des participants. Les noms scoreboard dans endgame_timeline, native_endgame_ui et les observations de fin désignent une phase de fin de partie, pas une route d'ouverture O/Tab en cours de match.

### Roster public du core

`vision::RosterEntry`, lignes16-22, contient exactement : id, champion, team, score. Le Score imbriqué, dans champion_kills.rs:5, contient kills, deaths, assists, kill_streak, death_streak. Ce sont les données actuellement publiées par le contrat local ; leur présence ne qualifie pas l'intégralité de la politique Riot historique.

`Simulation::snapshot`, lib.rs:764-773, construit ce roster depuis les joueurs et copie leur Score. `snapshot_for`, vision.rs:137-203, conserve ce roster tout en retirant de players les corps non visibles. Une identité ennemie et ses scores peuvent donc rester dans le roster lorsque son corps de Champion n'est pas dans la vue.

Les champs niveau, PV/mana, position, inventaire, or, échéance de réapparition ou nombre de sbires tués ne sont pas dans RosterEntry. Ce n'est pas une affirmation d'absence partout dans le jeu : certaines valeurs existent dans d'autres états ou canaux. Leur source et leur audience doivent être identifiées pour chaque colonne au lieu de recopier un corps privé ou de convertir son absence en zéro.

Le champ score a serde(default) pour compatibilité ; après désérialisation, un ancien champ absent est indiscernable d'un Score réellement nul. Le producteur actuel le remplit explicitement. Cela appelle une décision de contrat/admission si une future UI doit distinguer ces situations, pas une correction automatique des vrais zéros.

Les événements de kills sont un journal borné à128 dans champion_kills.rs. Ils ne remplacent ni tous les agrégats du roster ni une autorité de compteur de sbires tués. Le roster lui-même est construit depuis Simulation.players ; la persistance des participants déconnectés n'est pas prouvée par cette seule structure.

### Chemins de transport inspectés

Le serveur legacy utilise game.snapshot_for puis wire::state_datagrams, server/main.rs:228-233. Le chemin de session utilise snapshot_for_atomic puis current_state_packets, session_host.rs:158-166 ; la projection atomique complète la projection existante. Ces liens sont contrôlés dans le code, sans nouvelle exécution réseau ni qualification de toutes les étapes de transport.

## 4. Contrôles exécutés et attendu/observé

Vérificateur final, code0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.2-06-SCORE-01/audit_live_scoreboard.py`.

Premier passage conservé : code1, NoOptionError pour evtHoldShowScoreBoard recherché à tort dans GameEvents. La lecture de toutes les sections a confirmé HUDEvents pour Tab. Seul le nouveau vérificateur a été corrigé ; sa première version et la cause du refus restent dans verification_attempts. Aucune configuration d'entrée n'a été modifiée.

| Contrôle actuel | Attendu / observé |
|---|---|
| Contexte et corpus | HUD-01 et 498 sources client identiques ; parcours de texte précédents réutilisés |
| Entrées | Trois événements, leurs sections exactes et les déclarations des deux fichiers identifiés ; conforme après correction du lecteur |
| Films et fichiers associés | Deux GFX et 21 DDS identiques aux références recensées ; sélection effective non qualifiée |
| Compression/littéraux | Décompression réussie, 19 noms DDS littéraux présents sur disque ; écart de longueur SC4 conservé sans diagnostic de corruption |
| Sources de langue | 106 clés distinctes par profil, contextes séparés, chaîne vide conservée ; pas de rendu déduit |
| Recherche d'entrée live | Aucun KeyCode Tab/O/X ni événement nommé correspondant dans le corpus inspecté |
| Candidats scoreboard | Cinq fichiers de la fin de partie/résultats classés ; aucun nouveau producteur live trouvé dans les routes inspectées |
| Projection publique | Quatre champs de roster, cinq sous-champs Score ; corps cachés filtrés et roster conservé par snapshot_for |
| Conservation | 19 fichiers logiciels gelés conformes à WITHDRAWAL_INVENTORY.json ; aucune base ouverte |
| Relecture indépendante | Sections, variantes, champs, recherches, sept cas statiques et limites cohérents : PASS |

Les recherches de littéraux ne constituent pas un graphe d'appels Rust exhaustif. Les sélecteurs de Text et l'inventaire des routes courantes restent la preuve complémentaire bornée de HUD-01.

Sept cas sont des déductions du code, pas de nouveaux tests exécutés :

| Cas | Résultat déduit |
|---|---|
| Partie en cours, result=None | Le panneau terminal reste caché, même si dismissed vaut vrai |
| Résultat présent, splash non fermé | Panneau terminal caché |
| Résultat présent, splash fermé | Panneau terminal affiché à partir du résultat immuable |
| Ennemi caché | Corps absent de players ; roster et Score conservés par la projection examinée |
| Identifiant de viewer absent de Simulation.players | Pas de snapshot retourné par ce chemin |
| Joueur retiré après capture finale | Résultat déjà capturé conservé ; cas antérieur à la capture non prouvé |
| Champ score ancien absent | Default zéro ; distinction avec un vrai zéro non conservée dans ce type |

Les tests existants de vision, de mise à jour du score et de résultats ont été lus comme sources disponibles. Aucun n'est compté comme une exécution fraîche. Aucune compilation, test Rust, ActionScript, export, partie, capture GPU, entrée clavier réelle ou comparaison de pixels effectuée dans ce lot.

## 5. Manques et inconnues restant ouverts

L'écart actuel est un raccordement live, pas un manque général de fichiers : aucun état d'ouverture/fermeture, tableau de participants ou consommateur de colonnes correspondant n'est identifié dans les routes inspectées. Les résultats et le diagnostic restent des acquis utiles dans leurs propres contextes.

Les ressources graphiques et bindings sont disponibles ; le choix entre Menu et Menu_SC4, le décodage complet, les colonnes par mode et leur audience native sont encore à qualifier. Les libellés de mort, objets, ultime, score personnel ou or ne créent pas les données correspondantes. Les rôles présents dans le roster peuvent servir de base locale ; les autres demandent une source autorisée, existante ou à définir, après inspection.

Pour les champs hors roster, rester explicite sur donnée absente, actuelle autorisée et éventuelle dernière observation autorisée. L'absence d'un corps ennemi ne donne pas sa valeur publique, et son état complet ne doit pas devenir implicitement le modèle du scoreboard. La règle de conservation des participants pendant une déconnexion doit aussi être définie.

L'inconnue existante `OLU-275fd9bf-dedc-56fc-84e7-ed13167aac19` reste ouverte. L'association de SYS-17.2-06 dit déjà « Immutable terminal results display; not live public scoreboard », avec full_task_scope_complete=false. Le résultat documentaire précise désormais les sources, données disponibles et reprises ; il ne change pas cette association ou une case du plan.

Aucune entrée indispensable ne manque pour clore l'audit borné de cette frontière. La sélection native et la politique des colonnes sont des limites de fidélité à reprendre sur des preuves nommées ; elles ne sont ni inventées ni déclarées résolues.

## 6. Reprise par résultats précis

Clauses documentaires sous les tâches existantes ; aucun ajout au suivi et aucune réalisation implicite. Chaque colonne ou comportement se qualifie séparément ; un premier tableau K/D/A ne termine pas tout SYS-17.2-06.

| Clause / tâche | Résultat unique et critère de fin | Entrée de reprise |
|---|---|---|
| SCORE-INPUT-01 / SYS-17.2-06, SYS-17.4-01 | Qualifier O et Tab par section : bascule/maintien, relâchement, focus perdu et priorité avec saisie/UI. Fin : attendu/observé du comportement retenu, sans commande de combat involontaire | Appelant natif ou contrat local explicite ; conserver HUDEvents distinct de GameEvents et les bindings récupérés |
| SCORE-PUBLIC-ROWS-01 / SYS-17.2-06 | Premier résultat nommé : lignes publiques id/session, champion, équipe et K/D/A depuis le roster. Fin : identités uniques, mise à jour, ennemi caché, changement de session et donnée manquante traités, sans dépendre du résultat final | Contrat du roster actuel et admission des anciens messages ; vérifier les autres sources avant toute création de projection concurrente |
| SCORE-ROSTER-LIFETIME-01 / SYS-17.2-06, SYS-13.3-07 | Définir la conservation des lignes pendant départ/reconnexion et avant/après résultat. Fin : aucun doublon, conservation/suppression selon contrat et identité de session vérifiées | Cycle réel des participants et données autorisées ; les tests après capture n'établissent pas les départs avant capture |
| SCORE-COLUMN-PUBLIC-01 / SYS-17.2-06, SYS-13.3-02 | Une colonne hors roster par sous-tâche : niveau, objets, sbires, délai ou ultime selon source/portée. Fin : source d'autorité, audience, absent/actuel/dernier connu et changement de vision contrôlés | Inspecter d'abord les producteurs et autres canaux existants ; ne pas recopier le Champion entier ni fabriquer zéro |
| SCORE-GOLD-MODE-01 / SYS-17.2-06 | Qualifier séparément le sens de evtToggleScoreboardGoldDisplay et son mode/audience. Fin : source exacte de l'or et autorisation établies avant affichage | Nouvelle trace/caller natif ou règle locale explicitement nommée ; le binding [x] ne suffit pas |
| SCORE-MOVIE-SELECTION-01 / SYS-17.2-06 | Établir la variante et le chemin effectivement sélectionnés pour la référence retenue. Fin : caller/profil/ressource identifiés, dépendances et rendu qualifiés pour ce choix | Source du sélecteur natif ; conserver les deux candidats et leurs identités sans deviner d'après le nom SC4 |
| SCORE-CFX-LENGTH-01 / SYS-17.2-06 | Qualifier la signification de l'écart776 dans le format/lecteur approprié. Fin : résultat de parseur ou trace native identifié ; aucune réécriture de la référence sur une hypothèse | Lecture GFx pertinente, provenance et comportement documentés ; zlib seul ne tranche pas la validité du film |
| SCORE-LOCALE-RENDER-01 / SYS-22.1-04, SYS-17.2-06 | Après branchement d'un cas, qualifier titres/colonnes utiles en en_GB/fr_FR, focus, tri et résolutions ; fin : source et pixels attendus/observés sans englober replay/statistiques de fin | Variante, schéma de colonnes et service de texte définis ; chaîne flash_scoreboard_alive vide préservée ou décision explicitée |

Sans nouvelle piste de sélection ou de politique native, ne pas recommencer les mêmes empreintes/regex. Les entrées de reprise sont désormais précises. Les résultats terminaux doivent rester vérifiés dans un lot distinct de l'ouverture du scoreboard live.

## 7. Livraison et relecture

Fichiers créés uniquement :

- `F:/OpenLeague/docs/audit/units/AUD-17.2-06-SCORE-01.md`, ce résultat.
- `F:/OpenLeague-work/audit-units/AUD-17.2-06-SCORE-01/audit_live_scoreboard.py`, 15967 octets, SHA256 `278989481f06a1b396e803cb372d0f3fc0cc0695aec82c44720827497054ba5d`.
- `F:/OpenLeague-work/audit-units/AUD-17.2-06-SCORE-01/audit_live_scoreboard.initial.py`, 15448 octets, SHA256 `32d8b7d4ff537193124af647e932e5a1630049a8162ee8d43059881568e1b56f`, première tentative conservée.
- `F:/OpenLeague-work/audit-units/AUD-17.2-06-SCORE-01/live-scoreboard-proof.json`, 133078 octets, SHA256 `1a56f7485b6adacec39a490b2a68858c61a494ddb809a4bf76f09c6095fdb470`.

Le reçu conserve les événements/sections, deux variantes et 21 DDS, provenance lue sélectivement dans le registre (dont l'identité complète est hachée), vocabulaire des deux langues, champs et ancres du core/serveur/client, recherche bornée, sept déductions statiques, première tentative et inconnue existante. Aucune ressource du jeu copiée, effacée ou reconstruite.

Les sept rubriques de clôture sont renseignées pour cette unité. Audit terminé n'est pas fonctionnalité terminée, source sélectionnée en runtime ou jeu complet. Goal, application de suivi, registres et bases non modifiés par le lot ; pas d'installation, de migration, de rollback ou de case cochée.
