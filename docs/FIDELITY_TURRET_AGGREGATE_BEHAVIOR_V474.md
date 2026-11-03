# SYS-01.2-02 — Comportement et recette des tours/fontaines, V474

Seize fiches AI/ACCEPT des huit définitions TT_ChaosTurret1–4 et TT_OrderTurret1–4 sont reliées à leurs sous-fiches, sources et consommateurs actuels. La nouvelle compilation du cœur et trois tests existants réussissent. Les fiches restent partielles ; aucune case de réalisation ni acceptation humaine n'est modifiée.

## Référence et périmètre

Référence historique : League of Legends 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et date de déploiement non établis. Le catalogue 4.20.1 reste distinct. Projet actuel : F:/OpenLeague. Les règles communautaires ne sont pas assimilées à l'autorité du serveur Riot.

Les huit INIBIN de personnages, les huit sorts de base et cinq callbacks Turret.luaobj sont relus et comparés aux relevés V472/V473. Les définitions actuelles et la présence des valeurs natives n'ont pas changé. Les écarts de statistiques, la sélection native effective, les représailles et l'escalade restent ouverts dans leurs fiches propres.

## Liaison au comportement courant

La boucle normale Simulation::advance appelle advance_world avant advance_interactions, avec des gardes d'état terminal. Cette ancre est ajoutée au registre. Les bâtiments sont créés sans camp et spawn_unit ne crée home qu'à partir d'un camp : le retour au camp d'un monstre ne démontre donc pas le cycle d'un bâtiment.

Chaque fiche agrégée est reliée à ses quatre sous-fiches de ciblage, attaque, priorité/escalade ou soin/protection. Les 32 questions enfants restent ouvertes, avec leurs propriétaires et leurs textes conservés ; elles ne sont pas déplacées sur les parents. Les points de code qualifiés seulement comme frontières restent explicitement incomplets. Les dépendances déclarées du plan sont conservées, notamment PRESENT pour ACCEPT.

## Compilation et résultats effectivement obtenus

Une cible Cargo neuve, revision474_runtime_checks/cargo-target, compile le cœur courant avec `cargo test --locked --offline -p openleague-core --lib -- --list`. L'ancien binaire revision239/bin/openleague_core_v235.exe est conservé et son empreinte est revérifiée. Les 1 152 entrées recensées par le collecteur ont la même identité avant/après ; ce relevé ne prétend pas être un build hermétique exhaustif.

Trois tests exacts sont ensuite exécutés séparément avec `--exact --nocapture --test-threads=1` :

| Test | Attendu | Observé | Limite |
| --- | --- | --- | --- |
| world::tests::structure_dependencies_prevent_early_nexus_damage_and_end_match_after_chain | Refus des attaques prématurées/alliées, destruction de la chaîne nommée, victoire puis arrêt des commandes/ticks | Un test passé, code 0 | Dégâts forcés de 1 000 000 ; chaîne nommée, pas toutes les voies ni attaques ordinaires |
| world::tests::inhibitor_respawn_restores_protection_and_super_minions_are_wave_scoped | Super-sbire de la vague concernée, inhibiteur restauré et protection de la tour Nexus rétablie | Un test passé, code 0 | Sauts de tick ; tour C_01 vérifiée pour la protection, pas détruite dans ce test |
| interactions::tests::fountain_only_heals_living_allies_without_overheal | Soin et ressource alliés, ennemi sans soin de cette fontaine, mort inchangé, santé plafonnée | Un test passé, code 0 | Fixture du point bleu ; ni défense, ni recette complète des deux fontaines, ni toutes ressources/zones/cadences |

Les identifiants d'instances de tours observés dans les deux premiers tests sont T1_L_02, T1_C_06, T1_C_01 et T2_L_02, T2_L_01, T2_C_01 (préfixe Turret_). Le reçu classe explicitement leur intersection par définition. La fixture de soin relève de TT_OrderTurret4 ; elle ne qualifie pas une recette de soin de TT_ChaosTurret4.

Les journaux et le binaire exécuté sont identifiés dans le reçu CURRENT_TURRET_FOUNTAIN_TESTS.json. Aucun client graphique, moteur Riot, réseau, GPU, audio ou runtime CSharp n'est exécuté pour ce lot. Aucun code du jeu ni asset n'est modifié.

## Contrôles du plan et préservation

- Trois refus du collecteur : définition inconnue, instance manquante, script natif tronqué.
- Dix-sept sélecteurs nominaux et dix-huit invalides contrôlés ; trois refus du lecteur public : mauvais propriétaire, résolution factice, condition de résolution absente.
- Les 42 214 textes de traçabilité sont comparés : 16 changés, 42 198 identiques. Les sorties des autres fiches restent identiques, hors ajout des preuves au parent SYS.
- Publication et relecture indépendante des quatre registres et des deux bases : 17 fiches actualisées par base ; 42 606 états/notes, 23 historiques et 42 589 autres lignes du catalogue conservés exactement. Intégrité SQLite vérifiée.
- Les 51 fichiers épinglés du relevé sont vérifiés séparément de la validation structurelle du graphe.

La préparation du registre indique game_tests=0 pour sa propre exécution Python ; les trois tests du cœur avaient déjà été exécutés par revision474_tests.py. Le reçu des tests, la preuve de publication et l'audit indiquent trois tests frais, zéro partie ordinaire.

## Manques et suite

Les règles natives non établies et écarts statistiques V472/V473 restent ouverts. Il manque la recette ordinaire complète de chaque instance : attaques, priorités, représailles, escalade et reset, destruction/réapparition, défense et soins des deux fontaines, positions/frontières et ressources concernées. Les modèles, textures, animations et sons exigent leurs preuves séparées ; ce lot ne les accepte pas.

La suite de SYS-01.2-02 examine les 40 fiches PRESENT/MODEL/TEXTURE/ANIM/AUDIO des huit définitions. Dans le sous-inventaire du chargeur générique, 434 associations restent à examiner, 90 sont partiellement qualifiées et 16 sont hors portée démontrée. Ce compteur ne mesure pas l'achèvement du jeu. Le Goal reste actif.

## Fichiers et preuves

Reçu : docs/reference_turret_sources/turret-aggregate-behavior-v474.json. Preuve : docs/fidelity_turret_aggregate_behavior_v474.json. Les quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json sont enrichis. Les deux bases locales, coverage.json, completion_plan.json, resume_checkpoint.json et les notes CURRENT/HANDOFF sont actualisées sans toucher aux cases, notes ou historiques manuels.

Scripts revision474_tests.py, revision474_delivery.py, revision474_check.py et revision474_finish.py ; sauvegardes et contrôles sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision474 et revision474_runtime_checks. Les preuves antérieures sont conservées.

Ajouts vérifiés : 64 liens natifs, 429 liens aux consommateurs, une nouvelle ancre, deux sources et seize questions ouvertes ; aucune inconnue résolue.

Binaire exécuté : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision474_runtime_checks\cargo-target\debug\deps\openleague_core-21eb81eb13817108.exe` ; SHA-256 `752e12e3efb30d5d91166ed52bae6ec5164d78e3366b0ecde421cfee264a4761`.

Incident d’outillage : la lecture Git depuis le bac à sable a retourné « must be run in a work tree », puis « Permission denied » sur F:. La même lecture avec accès au répertoire autorisé a confirmé F:/OpenLeague et les modifications existantes. Aucun dépôt n’a été réinitialisé.
