# SYS-01.2-02 — Saut éclair : commande et destination

Date : 2026-11-03. Unité AUD-SYS-01.2-02-SUMMONER-FLASH-COMMAND-01. Exigence parente SYS-01.2-02; tâche SUMMONER-SummonerFlash-SERVER, exigence OLF-9f05a32c-617f-5f72-8fa5-77d800550f1b.

## Portée et critère

Établir si le chemin courant du choix de sort jusqu'au dispatch peut représenter et exécuter une téléportation d'invocateur vers une position; relever sources, refus, code existant et différences à qualifier. Cette unité ne couvre pas toute la fidélité de Flash, ses effets, son admission historique, son réseau complet ou son acceptation. Sortie : lien source/consommateur, limites, cas nominal et refus qualifiés, tâches existantes et condition de reprise.

## Sources et preuves réutilisées

- Client original fourni 4.20.0.315 PUBLIC EUW/en_GB : DATA/Spells/SummonerFlash.inibin, OLS-a0cb20d0-2db0-57bc-87c9-b3ad1c4de825. Preuve d'identité et appartenance au projet lol_game_client 0.0.1.7, membre 0.0.1.7 : docs/reference_native_skin_loader_sources/native-release-membership.json et trace. Taille 1 080 octets; SHA-256 75c2717aedeba54e668b8ec61e71c00dd4589298c468b00d1cbffa9d459da28c; MD5 1f6a442297a92ed37816fae037190928. Reçu hérité; priorité effective du fichier non établie.
- Catalogue officiel comparatif 4.20.1 en_US, OLS-22f06d52-9752-5b89-863b-92b0614a555e, data/4.20/native_summoners_420.json:1, /data/SummonerFlash : téléportation sur courte distance vers le curseur, portée 425, recharge 300, coût 0, clé 4 et niveau de compte 8. Le catalogue est distinct du client exact et ne démontre pas les paramètres effectifs du serveur Riot EUW ni l'admission Map10.
- docs/FIDELITY_SUMMONER_SELECTION_LINKS_4_20.md et docs/reference_summoner_selection_sources/summoner_selection-links.json : sélection AIR et cinq sorts locaux déjà examinés. Pour Flash, les champs natifs DisplayName et DynamicTooltip désignent des clés de texte; CooldownTime et CooldownTime1 sont null parmi les sélecteurs interrogés, sans prouver l'absence d'une autre clé de recharge. L'inventaire et les désactivations historiques demeurent inconnus. Aucun décodage ou hash inchangé n'a été répété.

La commande de lecture .ai-tools/.venv/Scripts/python.exe -B tools/project-plan/requirement_trace.py --root F:/OpenLeague --task SUMMONER-SummonerFlash-SERVER a retourné 0. Elle relie ces sources au dispatch OLC-a1d7c55a-749b-518a-9fd0-b2654f72a3b1, mais maintient OLU-ae24e2fc-d47b-52b1-901f-10769faf76b9 ouvert et game_behavior_accepted=false. Aucun registre modifié.

## Parcours courant et limites

Le code actuel summoners.rs:6–12 définit Barrier, Heal, Exhaust, Ignite et Smite : aucune variante Flash; :44–74 les dirige vers leurs consommateurs. Le bilan V81 indiquait déjà cette absence et la limitation de sélection du launcher; ne pas la présenter comme nouvelle.

Le supplément de ce lot porte sur la destination. crates/client/src/main.rs:1394–1436 construit pour les sorts d'invocateur Action::Summoner {slot} ou SummonerTarget {slot,target: Option<u32>}; :1442–1449 associe les touches D/F aux slots. Ces deux formes ne transportent pas de point au sol. crates/core/src/lib.rs:280–300 les définit; :619–623 route Summoner/SummonerTarget vers cast_summoner et cast_summoner_on. CastAt {slot,point} est une action séparée, produite pour des compétences de champion à main.rs:1481–1489 et dirigée vers cast_at; elle ne représente pas automatiquement un sort d'invocateur.

Le transport local peut envoyer les actions existantes via session_connection.rs:131–142 et game.command via server/src/session_host.rs:121–149 ou server/src/main.rs:158–173. La séquence est commise avant le résultat de gameplay dans ces chemins; un envoi ne prouve pas l'acceptation. Aucun paquet Flash n'a été observé.

Un déplacement instantané existe dans crates/core/src/ezreal_e.rs:108–132,169–213 avec ses propres bornes et contrôles, réservé à Ezreal E. Il ne constitue ni un dispatch de Flash ni une preuve des règles historiques de Flash; son existence interdit de conclure qu'aucun déplacement instantané n'existe dans le projet.

## Attendu, observé et vérification

- Référence comparative : un sort mène le champion vers le curseur. Observation statique : le chemin D/F actuel ne représente pas cette destination et le dispatch n'a aucune variante Flash. L'ajout du seul nom dans l'énumération ne résoudrait pas ce manque de point; aucun succès de Flash ne peut être déduit de ce chemin.
- Refus : crates/core/src/trundle_e.rs:325–327 contient un test qui attend le rejet de la désérialisation JSON de la variante Flash. Le test a été lu, non exécuté; ce n'est ni un refus observé en partie ni une règle historique Riot.
- Les tests de ciblage invocateur et session existants couvrent notamment Heal/Smite; les tests CastAt concernent des compétences de champion. Ils ne valident pas le sort Flash. Aucun test Rust, binaire de jeu, client ou réseau n'a été exécuté.
- Contrôle Python en lecture seule exécuté, sortie 0 : table catalogue 425/300/clé 4; cinq variantes de l'énumération courante; deux formes D/F sans CastAt; dispatch CastAt distinct. Il contrôle ces données et ancres, pas l'exécution Rust ni la fidélité du jeu.

## Écarts et reprise

Audit statique de cette liaison terminé dans ses bornes; implémentation Flash absente du chemin courant inspecté; vérification en jeu non exécutée; acceptation humaine non donnée. SCOPE est a_qualifier et requis; SERVER et NET restent a_qualifier, conditionnés à la qualification du périmètre, implementation_complete=false et acceptance_complete=false. Les autres aspects de Flash restent ouverts.

Réutiliser SUMMONER-SummonerFlash-SCOPE pour établir disponibilité et règles historiques; SUMMONER-SummonerFlash-SERVER pour le chemin autoritaire, l'admission et la destination; SUMMONER-SummonerFlash-NET pour le transport et la réplication; ACCEPT-REFUS et ACCEPT-CARTE pour les limites. Après qualification, vérifier les deux slots, point fini ou invalide, portée limite/hors portée, terrain et obstacles, recharge, états interdits et réplication. Les règles précises de clamp, murs, collision et interruption exigent une source serveur 4.20 attribuable ou une observation historique fiable : ne pas les déduire d'Ezreal E. Ne pas relancer les recherches ou hashes précédents sans piste nouvelle.

Relecture : portée, provenance, consommateurs, attendu/observé et vérifications, inconnues, corrections existantes, dates et limites sont documentés. Aucun code, registre, application de suivi, base ou goal modifié; aucune installation ni migration.