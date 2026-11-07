# Battle Training : éléments disponibles, lacunes et poursuite

Le 24 octobre 2026, l’utilisateur autorise la poursuite avec les sources disponibles et demande que les manques et limites soient explicites. Battle Training reste dans le périmètre complet, mais son manque de sources ne doit pas suspendre les travaux indépendants. Aucune tâche n’est acceptée automatiquement et les prérequis restent applicables.

## Résultat intégré

Neuf liens directs vers trois fichiers ActionScript décompilés ont été ajoutés aux références des fiches concernées et de SYS-01.2-02. Ils complètent les reçus de recherches V462, conservés. Il ne s’agit pas de neuf ressources nouvelles ni de scripts serveur récupérés. Les fichiers originaux AIR dont proviennent ces exports sont identifiés dans le registre ; leurs tailles, SHA-256 et MD5 de manifeste ont été comparés à nouveau. La décompilation elle-même n’a pas été rejouée.

| Élément | Fait étayé | Limite |
|---|---|---|
| BattleTrainingConfig.as | Requêtes de configuration Enabled et UseSRU, littéraux false/true | Ces littéraux ne sont pas les valeurs effectives du serveur |
| CreateTutorialGameController.as | Sélection conditionnelle Basic/Advanced, garde de changement de valeur, requête createTutorialGame avec argument 0/1 | Ne prouve ni disponibilité EUW à la date cible, ni carte, roster ou scénario |
| Même contrôleur, annulation et callbacks | cancelGame appelle playAnotherGame ; présence de callbacks de création et d’erreur | Une annulation de requête n’est pas une victoire, une défaite ou une récompense |
| ChooseGameViewLayoutTutorial.as | Le layout statique inspecté déclare basic_tutorial | Ne démontre pas l’absence globale ni l’activation de Battle Training |

Les références sont classées comme code AIR dérivé, sans ajout aux native_inputs de scénario. Le consommateur world::enable_map10 déjà enregistré reste une frontière Map10 : il n’implémente pas Battle Training. Aucun nouveau consommateur de jeu n’est inventé.

## Ce qui manque précisément

| Fiche | Entrée nécessaire pour lever la limite |
|---|---|
| SCOPE | Preuve primaire versionnée reliant l’identité du scénario à son activation effective, sa région et sa carte |
| SELECT | Règles originales de sélection des champions, sorts et runes, reliées au scénario identifié |
| STEPS | Script ou graphe exact des objectifs et étapes, avec preuve de son chargement |
| RULES | Producteurs des restrictions et valeurs effectives du scénario |
| RESULT | Conditions et parcours réels de réussite, échec et retour au client |

Les ressources AIR de localisation recherchées restent manquantes dans les emplacements précédemment contrôlés. Les 19 variantes et deux copies locales contrôlées lors de la reprise précédente ne constituent pas une preuve d’absence sur Internet. Les recherches ne sont pas répétées dans V463. Voir V462 et ses recherches antérieures pour les chemins et empreintes attendues.

L’absence de carte, de modèles 3D, de textures ou d’animations n’a pas été établie par ces recherches. Il ne faut pas convertir une identité de scénario non prouvée en liste d’assets prétendument absents. Retrouver des textes seuls ne suffirait pas à qualifier le mode.

## Poursuite du travail

Les cinq fiches restent ouvertes avec leurs dix inconnues inchangées. On conserve leurs exigences et leurs dépendances ; elles ne sont ni supprimées ni comptées comme terminées. L’analyse des dépendances entre tâches ne propage ce manque qu’à ces cinq fiches. Les 42 209 autres tâches sont hors de cette fermeture de dépendances ; cela ne signifie pas qu’elles sont toutes prêtes ou implémentées, car leurs propres prérequis de tâche, lot et phase restent à vérifier.

Dans SYS-01.2-02, poursuivre les associations dont les sources sont disponibles et qualifier explicitement les références partielles. Pour Battle Training, ne reprendre la recherche bloquée que sur une nouvelle archive, un payload, un script ou un lien primaire pertinent. Ne pas recommencer des audits identiques pour produire une impression de progression.

Le registre reste partiel et le jeu n’est pas déclaré terminé. Le service Goal, initialement « blocked », a été relu après l’audit et renvoie maintenant « active ». Le champ de statut inclus dans le reçu de préparation décrit l’observation antérieure ; il ne représente pas l’état courant du service.

## Contrôles exécutés

- Préparation : six sélecteurs nominaux et sept refus de mauvais sélecteur/tâche ; validation structurelle du graphe.
- Identités : trois exports historiques et leurs copies F: comparés ; deux conteneurs AIR originaux comparés aux empreintes enregistrées, dont leurs MD5 de manifeste ; ancres du code relues.
- Publication et audit séparé : lecture réelle des six fiches, instructions copiables et liens résolus dans les deux bases SQLite.
- Conservation vérifiée dans chaque base : 42 606 états/notes et 23 entrées d’historique exacts ; 42 600 autres lignes du catalogue inchangées. Les 42 208 autres exigences actives sont inchangées.
- Registre des inconnues conservé en octets ; aucun statut de tâche ni champ required modifié. Intégrité SQLite : ok.
- Aucun jeu, client AIR, compilation Rust, VM ou test GPU exécuté. Aucun comportement de gameplay n’est validé.

La première observation Git en contexte restreint échouait à lire le worktree ; l’observation en accès autorisé a réussi et montré les modifications existantes. Aucun index, commit ou fichier de jeu n’a été modifié.

## Fichiers et preuves

- docs/reference_battle_training_research/battle-training-partial-code-v463.json : sources, faits bornés et politique de poursuite.
- docs/fidelity_battle_training_partial_code_v463.json : résultats de publication.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json : registre et six fiches enrichis.
- runtime/project-plan/plan.sqlite3 et base de l’application installée : données des six fiches et textes copiables actualisés ; données manuelles préservées.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai : reprise et limites actualisées.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision463 : sauvegardes, préparation et DELIVERY_AUDIT.json.
