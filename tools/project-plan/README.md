# Plan OpenLeague local

Ouvrir `http://127.0.0.1:10427/`, ou lancer `Ouvrir le plan OpenLeague.cmd` sur le Bureau.

Le plan v2 comporte 24 parties, 2 770 fiches nommées et 42 214 sous-tâches. La partie 06 contient une fiche par champion du roster 4.20 ; les capacités secondaires et clips natifs ne sont pas fusionnés dans une seule tâche globale. Le nombre d’enfants dépend du contenu, sans quota.

Depuis l’accueil, choisir une partie puis ouvrir une fiche. Les groupes internes séparent les domaines du travail. Cliquer sur le titre d’une sous-tâche pour ses consignes et ses notes. Les icônes de copie copient la sous-tâche complète ou toute la fiche. Une coche de fiche agit uniquement sur ses sous-tâches actuellement affichées par les filtres.

## Stockage et compatibilité

SQLite : `E:/OpenLeague/runtime/project-plan/plan.sqlite3`. États et notes persistants, révisions optimistes, transactions, annulation et sauvegarde cohérente. Le catalogue est synchronisé par identifiant ; une mise à jour ne remplace pas les notes ou les coches existantes.

Les 392 anciennes tâches globales sont inactives et leurs états restent archivés. Les exports incluent ces archives ; les imports de l’ancien plan sont acceptés sans cocher les nouvelles tâches à partir d’une ancienne coche globale. L’interface de suivi ne transforme pas une coche manuelle en preuve d’acceptation du jeu.

Options contient export/import, sauvegarde SQLite et audit du plan. Les sources du catalogue sont `docs/completion_tasks_2026-10-20.json` et `docs/execution_plan_A_Z.json`. Les listes Markdown complètes sont dans `docs/OpenLeague_PLAN_DETAILS/D01.md` à `D24.md` et sur le Bureau.

## Vérification

`test_plan.py` vérifie catalogue, persistance, conflits, rollback, annulation, recherche, pagination exhaustive, copie, export/import, sauvegarde, HTTP local, archives et fiche de champion. `E:/mapslol3v3/Plan_granulaire_2026-10-20/audit_plan.py` contrôle tous les identifiants, graphes, contenus recensés et consignes de copie.

Serveur Python standard, écoute uniquement sur 127.0.0.1. Aucun service externe ni démarrage automatique Windows.


## Référence datée du client

Les consignes utilisent docs/reference_client_4_20.json : build PUBLIC 4.20.0.315, EUW / en_GB, date de build 2014-11-17 à 17:46:45 (fuseau inconnu). Vérification des cinq sources natives sans exécution : python -B tools/project-plan/reference_client.py --root E:/OpenLeague. Fiche et limites : docs/REFERENCE_CLIENT_4_20.md. Tests : python -B tools/project-plan/test_reference.py. Le catalogue SQLite conserve les coches et notes lors de sa régénération.


## Cases et validation utilisateur

Les cases du plan relèvent de l’utilisateur. Un résultat technique ne vaut pas une acceptation utilisateur et ne coche aucune nouvelle tâche à l’import. Un agent ne coche ni n’accepte une tâche sans demande explicite. La réimportation conserve les choix et notes existants. Contrôle ciblé : python -B tools/project-plan/test_manual_progress.py.


## Estimations et recommandations — version 1.3.0

Chaque sous-tâche conserve trois badges : temps agent IA, difficulté pour l’IA,
modèle et effort recommandés. Une carte de survol personnalisée, également
accessible au clavier, explique ces trois informations. Échap la ferme. Les badges ne déclenchent aucune action au clic. Aucun modèle, état ou note n’est changé automatiquement.

Les durées sont des scénarios d’agent IA avec outils, prérequis disponibles. La
cadence reste une hypothèse explicite avec quelques repères locaux ; ce n’est
pas un benchmark d’inférence ni une conversion d’heures humaines. Le badge de durée contient uniquement la fourchette de temps. Le survol précise
quand il s’agit d’une première passe de recherche dont la durée totale reste ouverte.
Recherche, limites et sources : docs/PLAN_AI_ESTIMATION_RESEARCH_2026-10-22.md.

Actualiser les profils intégrés aux deux interfaces sans modifier SQLite :

    python -B tools/project-plan/task_estimates.py --root E:/OpenLeague --output runtime/project-plan-estimates/task-estimates.json --refresh-ui
    python -B tools/project-plan/test_task_estimates.py

Les sources méthodologiques et la calibration explicite sont dans
tools/project-plan/task_estimate_research.json. Recompiler l’application Tauri
après une actualisation de ses ressources web. Préserver la base utilisateur.

Difficulté : cinq icônes d’étoile, avec remplissage à la demi-étoile. Les quatre
classes existantes sont représentées par 1, 2,5, 3,5 et 5 étoiles ; ce changement
visuel ne réévalue pas les tâches. Le score est annoncé aux lecteurs d’écran.
