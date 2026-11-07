# SYS-01.2-02 — Cycle des huit sbires et frontière de validation, V494

Projet F:/OpenLeague. Référence historique : League of Legends PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Ce travail relie les exigences aux sources et aux consommateurs actuels. Il ne clôture aucune fiche ACCEPT, aucun champion ni le jeu.

## Résultat intégré

Les huit fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-ACCEPT sont reliées à leurs agrégats SOURCE, AI et PRESENT, aux sources natives de composition/cadence des vagues et aux chemins courants de naissance, dégâts, mort, retrait et gel terminal. Les24agrégats hérités et leurs questions restent exacts. Huit questions propres exposent ce qui manque pour satisfaire le critère de validation ordinaire et humaine.

Les registres conservent leur historique ; les deux bases du plan reçoivent uniquement les nouvelles données et instructions documentaires. Aucune case, note utilisateur, dépendance ou critère de fin n’est changé.

## Contrôles exécutés maintenant

La sonde Rust utilise la bibliothèque core compilée V476, après vérification que ses entrées et outils sont toujours identiques. Le core n’a pas été recompilé. La sonde seule a été compilée puis exécutée, avec codes de sortie0. Les ressources courantes comprennent map10_world.json et la grille de navigation réelle. Le reçu identifie bibliothèque, compilateur, binaire de sonde, script et ressources par taille/SHA-256.

64cas CPU : huit cas pour chacun des huit types. L’horloge est initialement placée au tick2249 ; les décisions IA et attaques sont ensuite inhibées pour isoler le cycle. Les super-sbires nécessitent ici deux inhibiteurs adverses dont la santé a été explicitement mise à0. Aucun combat ordinaire ne provoque cette préparation.

| Cas | Attendu local | Observé |
| --- | --- | --- |
| Naissance par le scheduler réel | Mêlée et super au tick2250 ; mage2322 ; canon4122 | Identique pour les deux équipes ; santé initiale pleine, voie attribuée, aucun timer de mort/respawn |
| Dégât non létal par API publique | Perte10PV, cible vivante | Identique pour8profils |
| Dégât négatif | Refus invalid damage et santé inchangée | Identique pour8profils |
| Dégât létal après stun et contrôles préparés | Santé0 ; contrôles/chemin/cible effacés ; retrait mort+90 ; pas de respawn | Identique pour8profils |
| Nouvelle attaque sur corps | Refus damage target dead, échéance inchangée | Identique pour8profils |
| Frontière de retrait | Corps présent à+89, absent à+90 ; unknown damage target ensuite | Identique pour8profils |
| Après retrait | Même identifiant toujours absent90ticks plus tard | Identique ; observation bornée, aucune assertion infinie |
| Fin contrôlée | Après affectation directe du gagnant,100appels advance sans évolution de tick/unités ; match ended | Identique ; transition Nexus et client non exercés |

Les scènes de combat, ciblage, déplacement et progression des preuves V483-V486 sont héritées via V487 ; elles n’ont pas été rejouées. Les inspections visuelles et sonores V488-V493 sont documentaires et ne deviennent pas des captures GPU ni une écoute.

Contrôles du consommateur public :42214instructions comparées,8modifiées,42206inchangées ;24agrégats hérités inchangés ;3refus de composition (enfant absent, dupliqué, autre profil),9sélecteurs nominaux et10sélecteurs invalides,3refus du registre public (mauvais propriétaire, faux statut résolu, condition de résolution absente).2038identités de fichiers revérifiées. Publication et audit indépendants doivent réussir avant le point de reprise final.

## Limites et manques précis

- Partie ordinaire complète sur client/serveur/binaires identifiés non observée ici. Ni capture visuelle, audio, test réseau ou validation humaine.
- La durée locale de retrait de3secondes et l’absence de respawn d’un même sbire ne sont pas qualifiées comme règles du serveur historique. Les sources de vagues et configurations disponibles ne suffisent pas à les établir.
- Le gel terminal est testé avec un gagnant assigné directement. Il ne démontre pas le parcours ordinaire de destruction du Nexus ni les animations de fin.
- Les questions héritées de combat, récompenses, sélection, navigation et progression restent ouvertes. Un dégât injecté par API publique ne prouve ni la politique de ciblage des appelants ni l’économie complète.
- Les écarts de squelette BlueBasic, images/rotations d’animation, matériaux/mips, sélection des particules et producteurs audio restent ouverts. La disponibilité d’une ressource ne prouve pas son rendu ou sa lecture.
- Pas de diagnostic d’asset manquant fondé uniquement sur une absence d’exécution. Les inconnues de sources, de sémantique et de validation sont distinctes.
- Dépendance locale aux preuves privées F:/OpenLeague-work et au buildV476 ; la portabilité de ce paquet de preuves n’est pas démontrée.

## Anomalies d’exécution conservées

La ligne de résumé console du script runtime affichait116 à cause d’un littéral repris du scriptV484. Le programme exécuté vérifie et annonce64 ; l’observation contient64cas et le reçu runtime indique scenario_cases=64. Ces trois éléments ont été revérifiés indépendamment. Le script et les journaux originaux restent conservés ; aucun second passage n’a été inventé. Cette faute de libellé ne modifie pas les résultats observés.

Une première lecture a utilisé un chemin CURRENT.md erroné puis le chemin réel docs/ai/CURRENT.md a été lu. Une commande de recherche PowerShell utilisant des accolades de type shell Unix a été refusée au parsing ; la recherche a été corrigée avec des filtres rg -g. Aucune de ces lectures n’a modifié le projet. Aucun échec de compilation ou de cas CPU.

## Fichiers et preuves

- docs/reference_minion_behavior_sources/minion-lifecycle-v494.json : associations, cas observés, sources, ancres de code et limites par fiche.
- docs/fidelity_minion_lifecycle_v494.json : publication et vérification des bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json : intégration documentaire, anciens enregistrements conservés.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md : couverture/reprise mises à jour.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision494_runtime_checks/CURRENT_MINION_LIFECYCLE.json : identités et commandes exactes, reçus de compilation/exécution,64cas.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision494/{PREPARATION,CANDIDATE_CHECK,DELIVERY_AUDIT,DOCUMENTARY_CHECK,FINAL_CHECKPOINT}.json : vérifications et sauvegardes des états précédents.

Aucun fichier du moteur ou asset du jeu modifié. Le goal SYS-01.2-02 reste actif ; prochaine étape : fiches des monstres neutres, en réutilisant les preuves existantes sans transformer un lien générique en qualification complète.

Bilan : 734 liens natifs ajoutés, 787 liens consommateurs, 4 nouvelles ancres, 3 sources et 8 questions ouvertes. 2038 identités vérifiées. Graphe : 98670 sources / 2542 consommateurs / 25732 questions ouvertes / 5517 résolues avec historique. Sous-inventaire chargeur :119 à reprendre,389 associations partielles,32 exclusions ouvertes dont20audio ; aucun pourcentage de jeu achevé n’en découle.
