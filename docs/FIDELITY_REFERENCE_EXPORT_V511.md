# SYS-01.2-02 — Références précises dans les consignes sans entrée native V511

25 octobre 2026 ; F:\OpenLeague ; Goal actif. Cette livraison corrige le consommateur réel des instructions du plan. Elle ne complète pas le gameplay ou une ressource native manquante.

## Problème et résultat

Le registre conserve une ou plusieurs références pour chacune des 385 exigences sans entrée native. Le lecteur requirement_trace.resolve les exposait déjà dans sa fiche complète, mais instruction_lines n’en exportait aucune dans le texte copié : seul un constat d’absence native et des consommateurs apparaissaient. Cela masquait les contrats locaux, sources dérivées et recherches précisément enregistrés.

Le vrai lecteur tools/project-plan/requirement_trace.py affiche désormais, dans ces seules consignes :

- Un avertissement indiquant que les références ne prouvent ni complétude native ni comportement accepté.
- Le chemin et le SHA-256 enregistrés de chaque source présentée, avec ses relations et sélecteurs.
- Jusqu’à trois sources distinctes dans l’ordre existant. Les relations et sélecteurs distincts d’une même source sont conservés ensemble ; seule leur répétition exacte est dédupliquée dans le texte.
- Un nombre explicite de sources supplémentaires et le renvoi vers la fiche complète. Tous les liens restent dans le registre et dans resolve.

Une référence manquante du registre, une identité de source incomplète ou une relation vide sont refusées explicitement ; une quatrième source invalide est contrôlée même si elle serait hors de l’aperçu. Le cas sans référence n’invente aucun substitut.

Exemples réels : SYS-01.4-01 expose ses contrats de preuve locaux et leur portée ; REF-xx distingue les références d’ingénierie des ressources LoL ; Battle Training montre ses recherches et sources AIR dérivées sans les transformer en scénario natif complet. Le message d’absence d’entrée native, les limites de consommateur et toutes les questions ouvertes restent présents.

## Portée et sources

Objectif inchangé : relier chaque exigence à sa source native ou son contrat local explicite et à son consommateur actuel, en conservant les inconnues. Référence du projet : PUBLIC4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct d’AIR0.0.1.119.

AGENTS.md, CURRENT.md, HANDOFF.md, DECISIONS.md, l’objectif joint du Goal et le lot D01-SYS-01-2 sont relus. Le tour précédent V510 est un progrès vérifié : inventaire global et SHA de la cohorte98711, pas un état restaté. Son contrôle intégral de22,9Go n’est pas rejoué ni attribué à la nouvelle version du lecteur.

Les 385 exigences restent 356 SYS,24 REF et5 Battle Training. Ce nombre n’indique pas autant d’assets absents. Les dix premiers contrats de gouvernance et les24 références d’ingénierie avaient déjà leurs liens précis ; aucun équivalent natif artificiel ni lien redondant ne leur est ajouté.

Le consommateur ajouté uniquement à SYS-01.2-02 est plan_reference_source_export, dans append_reference_inputs à la ligne170 : lecteur du plan, provides_feature_consumer=false, pas une fonctionnalité de jeu. Aucun CID de gameplay n’est ajouté aux385 fiches et aucun lien natif n’est créé. Les anciens2 608 consommateurs restent exacts.

## Conservation et version du code

L’ancien lecteur de13413octets, SHA44239c22951d5198de247a2995ac4e7c2a2f21d97bd312055832b1c6d3d5bb32, reste archivé à :

docs/fidelity_source_versions/OLS-77df4bc2-820d-5530-b251-55299c4d44e9/44239c22951d5198de247a2995ac4e7c2a2f21d97bd312055832b1c6d3d5bb32/requirement_trace.py

Le lecteur courant fait14758octets, SHAe55a8a0af3d50725dfcc95d09d6317074ba5ec57561edba5fc8bc6032c6e0caf. Son SID reste OLS-77df4bc2-820d-5530-b251-55299c4d44e9. Le protocole source_versions.prepare_version conserve l’intégralité du précédent enregistrement et le préfixe d’historique ; validate_history avec vérification de fichiers contrôle les deux versions, archives et reçus. Les onze anciennes ancres de consommateurs dans ce fichier gardent leur ligne et leur aiguille ; les fonctions précédentes gardent leurs numéros de ligne. Aucun ancien résultat d’exécution n’est réattribué au nouveau code.

Quatre sources de preuve sont ajoutées : reçu de livraison, contrôles candidats, événement de changement du lecteur, nouveau fichier de tests. Un enregistrement de source est versionné et un consommateur de plan ajouté. Les autres sources et consommateurs, les42 213 autres tâches/fiches, toutes les questions, critères, dépendances, required_if et entités restent exacts.

## Vérifications : attendu et observé

| Vérification | Attendu | Observé |
| --- | --- | --- |
| Comparaison globale de traçabilité | Seules les copies sans entrée native changent |42214comparées :385changées,41829identiques |
| Fiches résolues avant changement de registre | Ajouter de l’affichage sans modifier les liens | Les42214objets resolve sont identiques dans le test candidat |
| Préparation avec la nouvelle version de source et le CID du plan | Ne pas affecter les autres fiches |385textes changent encore ;42213autres objets de tâche/trace exacts |
| Tests Python ciblés et régressions existantes | Provenance précise, refus et archives conservés |54tests réussis sur le candidat retenu |
| Sources/rôles/limites dans les copies | Garder tous les liens, sans promotion native/runtime |385fiches réelles vérifiées,3sources maximum et compteur du reste |
| Historique du lecteur | Ancien record et octets récupérables | Chaîne de2versions validée,11ancres précédentes exactes |
| Publication dans le plan | Changer les consignes sans altérer le suivi |386consignes par base :385exports etSYS ;une seule donnée de tâche modifiée |
| Conservation des deux bases | Autres lignes, cases, notes et historique exacts |42220autres lignes de catalogue,42606états/notes et23historiques exacts ;intégritéOK |

Les54tests comprennent8cas du nouvel export,3de portée de consommateur,12de versions de source,10de migration des versions et21de traçabilité existante. Les tests historiques de traçabilité utilisent des surcharges explicites R et D vers F:\OpenLeague et S vers le temporaire du candidat ; leurs fichiers et assertions ne sont pas modifiés. Les petits cas synthétiques de refus ne remplacent pas les385fiches réelles ou des sources originales.

Les lecteurs Store.task/copy_text, requirement_trace et instructions sont exécutés sur les deux bases courantes en mode lecture seule pendant la vérification. Le module actif et ses octets correspondent exactement au candidat testé. Les386instructions complètes incluent la mise à jour du contexte SYS ;385fragments de traçabilité changent. Les385autres cellules data des tâches sont conservées octet pour octet ; seule la donnée documentaire SYS change.

## Échecs conservés et reprise exacte

Premier candidat :54tests,53réussites et1erreur. Le banc rétablissait old.load dans le module candidat ; le test d’archives incomplètes recevait donc le TraceError de l’autre module. Le banc est corrigé en restaurant sa propre fonction ; aucune assertion de test n’est assouplie. Le candidat retenu est écrit en octets LF avec SHA mémoire/disque identiques. Les résultats initiaux restent dans revision511_candidate ; le succès retenu est dans revision511_candidate_retry. Le code actif n’était pas encore modifié pendant ces deux essais.

La première publication a ensuite terminé les écritures prévues du lecteur, des registres et des deux bases, puis a échoué au code1 dans le vérificateur : il cherchait un chemin relatif à barres obliques dans du JSON contenant le chemin absolu Windows échappé. Le nouveau CID et les valeurs structurées étaient présents. Ce défaut de contrôle n’est pas présenté comme un succès initial.

revision511_recovery.py compare d’abord les quatre postimages attendues, les versions du lecteur, l’archive, les sources pinées et les deux bases. Il remplace uniquement ce contrôle par la recherche des valeurs JSON encodées exactes. Il ne republie aucun code ni aucune donnée. PUBLICATION_VERIFIER_FAILURE.json conserve les probes et le code1, puis la preuve n’est créée qu’après les386relectures réelles réussies par base. L’audit indépendant utilise le même contrôle corrigé. L’ancien script de publication reste intact et piné : ne pas le relancer.

## Fichiers et reproduction

Dans F:\OpenLeague : tools/project-plan/requirement_trace.py ; nouveau test_reference_input_display.py ; docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json ; document fidelity_unknowns_4_20.json identique ; archive ci-dessus ; docs/reference_requirement_trace_sources/native-empty-reference-export-v511.json et reference-display-change-v511.json ; docs/fidelity_reference_export_v511.json et présent rapport. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md sont actualisés après audit avec sauvegarde de leurs versions précédentes.

Dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20 : revision511_stage.py, stage_retry.py, checks.py, checks_retry.py, delivery.py, recovery.py et finish.py (préfixe revision511_ pour chaque nom). Les candidats, journaux,54résultats, comparaisons des42214textes, quatre sauvegardes gzip, postimages de publication, reçus et vérifications des deux bases sont conservés dans revision511_candidate, revision511_candidate_retry et revision511. Les deux échecs restent consultables. Interpréteur Python avec options -X utf8 -E -u -B ; son identité et celles des scripts sont consignées dans EXECUTION_ENVIRONMENT.json.

Les commandes autoritaires de contrôle après publication sont revision511_recovery.py recover puis audit ; la première ne se rejoue pas si la preuve existe. Les étapes de préparation/publication utilisent des créations exclusives et des postimages vérifiées. Le Goal reste actif ; aucune case n’est cochée automatiquement.

## Limites et suite

Le lecteur affiche les empreintes enregistrées : il ne relit pas chaque asset à chaque copie et ne valide ni décodage, qualité, fichier original inconnu, gameplay, rendu ni écoute humaine. Les385absences d’entrée native et les25 827questions ouvertes restent inchangées. Le classement Solo/Team et les limites Battle Training conservent leurs preuves et inconnues. Aucun code de jeu, pack ou asset n’est modifié ; aucun jeu, AIR, VM Lua, NodeVM, serveur/client, build Rust, GPU ou audio n’est exécuté par cette livraison.

Poursuivre SYS-01.2-02 en examinant les18consommateurs sans lien direct actif relevés par V510 : retrouver leur provenance et leurs usages composés dans les reçus, puis décider d’un lien précis ou d’une conservation justifiée. Inspecter regeneration.rs, les sources de tests Annie et World et la frontière World correspondante. Ne pas les supprimer, les ajouter partout ou transformer une référence de test en implémentation de jeu. Les contrats locaux et références d’ingénierie déjà précis n’ont pas besoin de liens redondants.

Bilan après reprise et audit : préparation0, publication initiale1 sur assertion de chemin JSON après écritures, reprise0 sans republication et audit0. Premier banc54tests avec1erreur de module ; banc corrigé54réussites. Deux bases386instructions, une donnée SYS chacune ;42220autres lignes,42606états/notes et23historiques exacts,intégritéOK. Graphe : 98718sources / 2609consommateurs / 25827questions ouvertes / 5517résolues. Quatre nouvelles preuves,un lecteur versionné,un consommateur du plan ;zéro lien natif ou inconnue résolue.
