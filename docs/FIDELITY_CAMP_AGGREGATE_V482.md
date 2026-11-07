# SYS-01.2-02 — Fiches de synthèse des camps, V482

Les 14 fiches CAMP-00..06-SOURCE et CAMP-00..06-ACCEPT sont reliées aux sous-preuves de leur camp dans les registres et les deux bases du plan. Les 49 sous-tâches et leurs questions ouvertes sont conservées exactement. Aucun critère d'acceptation, prérequis, état manuel, note ou historique n'est assoupli ou coché.

Référence : League of Legends 4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et déploiement non établis ; catalogue officiel 4.20.1 distinct. Projet F:/OpenLeague. CAMP-00..05 correspondent aux camps natifs 1..6 ; CAMP-06 au camp 8 Vilemaw. La relique native 7 reste séparée.

## Contrat et résultat

Chaque fiche SOURCE porte uniquement sur composition, points, premier spawn et respawn. Elle réunit donc les trois sous-tâches COMPOSITION, INITIAL et RESPAWN de V479. Chaque fiche ACCEPT exige un scénario ordinaire avec les deux équipes sur binaires et ressources identifiés, ainsi qu'une validation humaine de fidélité. Elle réunit les sept sous-tâches de son camp : les trois précédentes, REWARD, SOURCE-REWARD, AI et SOURCE-RESET.

Les associations natives et les consommateurs précis sont repris de ces enfants en conservant leur identité et leur portée. Un candidat de script d'IA reste un candidat ; une union de références ne prouve pas sa sélection dans le moteur d'origine. Aucune nouvelle ancre de code n'est inventée. Chaque agrégat reçoit une question ouverte propre explicitant ce que la réunion des preuves ne démontre pas. Les prérequis de phase et de lot sont relevés sans supposer leur achèvement.

## Preuves héritées réidentifiées

- V479 : composition et coordonnées de 17 membres, sept frontières d'apparition et de respawn, six non-respawns tant qu'un membre survit, sept activations tardives et refus de dégâts sur mort. Horloge locale 100/600 contre 15/515 native : décalage de 85 secondes non qualifié. Les 17 hauteurs au sol diffèrent des Y natifs.
- V480 : 112 scénarios de récompenses, 272 morts et refus de double crédit, 1 632 comparaisons par joueur. Récompenses du propriétaire et de l'équipe, bonus d'autel et frontières sans source sont documentés. L'application du buff de Vilemaw reste non identifiée ; champs natifs absents et zéros locaux restent distincts.
- V481 : 112 scénarios d'aggro/reset, 272 contrôles de membres et deux attaques engagées de Vilemaw. Le soin immédiat au cycle d'IA local et le seuil local 800 ne qualifient pas le composant natif. Les deux premiers essais échoués restent conservés.

Ces trois programmes ne sont pas réexécutés dans V482. Leurs reçus, sources, outils, bibliothèques, binaires et observations référencés sont réidentifiés. Les anciennes observations Lua ne deviennent pas non plus des exécutions fraîches. Aucun build, lancement de jeu, GPU, audio, réseau ou moteur Riot effectué ici.

## Contrôles exécutés

Attendu : trois enfants exacts par SOURCE, sept par ACCEPT, tous du même camp, sans changement des critères ou questions des enfants. Observé : sept groupes conformes, 49 enfants et questions intacts, 14 agrégats mis à jour. Les quatre cas invalides sont refusés : type inconnu, enfant dupliqué, INITIAL manquant et enfant d'un autre camp.

Les 15 sélecteurs nominaux et 16 sélecteurs invalides sont contrôlés, ainsi que trois refus du lecteur public : mauvais propriétaire d'inconnue, résolution indue et condition de résolution vide. Les 42 214 textes d'instruction sont comparés : 14 modifiés, 42 200 inchangés. Les quatre registres sont contrôlés avant publication et relus après.

Chaque base contient 15 fiches actualisées, dont SYS-01.2-02. Les 42 606 états et notes manuels, 23 historiques et 42 591 autres lignes de catalogue sont conservés exactement. L'intégrité SQLite et les lectures réelles de tâche/copie sont vérifiées après publication. Les anciennes inconnues et références restent présentes ; aucune inconnue n'est résolue.

## Manques et limites

La validation du cycle ordinaire continu reste ouverte : apparition, combat des deux équipes, attribution des gains, mort, respawn et retour complet. Restent également ouverts le montage natif effectif, l'origine des horloges, la sélection des scripts et helpers d'IA, le reset complet des effets/timers, le buff et les sorts spéciaux de Vilemaw, le rendu, le son et la fidélité humaine. La présence de sources ou la réussite de tests isolés ne clôture pas ces critères.

Les 63 fiches de camps disposent désormais de liens plus précis dans ce sous-inventaire, tout en restant partielles. Cela ne signifie pas que les camps ou le jeu sont terminés. Le sous-inventaire du chargeur garde 223 associations à préciser : WORLD 195, MODE 27 et SYS 1 ; 293 associations partielles et 24 exclusions, dont 12 audio, sont conservées. Ces chiffres ne mesurent pas l'achèvement global du jeu.

## Fichiers et suite

Modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json, les deux bases du plan, coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de gameplay ou asset modifié.

Livrables : docs/reference_camp_sources/camp-aggregate-v482.json, docs/fidelity_camp_aggregate_v482.json et ce rapport. Scripts, sauvegardes et contrôles : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision482*. Les preuves antérieures restent conservées.

Suite : inspecter les tâches WORLD des sbires et leurs consommateurs réels, en commençant par les sources et l'IA de Blue_Minion_Basic ; rechercher les différences avec les autres variantes avant de choisir le prochain lot. Conserver séparément MODE et SYS. Goal actif.

Ajouts : 125 liens natifs, 211 liens consommateurs, 0 nouveau consommateur, 1 source et 14 questions ouvertes. 1269 fichiers directement épinglés revalidés. Graphe : 98638 sources, 2479 consommateurs, 25628 questions ouvertes, 5517 résolues avec historique.
