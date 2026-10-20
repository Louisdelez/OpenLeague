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

## Catalogue dans Git

Le catalogue JSON complet est conservé sans perte dans `docs/completion_tasks_2026-10-20.json.gz`. Depuis la racine du dépôt, exécuter `python tools/project-plan/restore_catalog.py` avant les outils Python ou leurs tests. La commande vérifie les empreintes et ne remplace pas un fichier divergent. La graine SQLite embarquée du programme Windows reste indépendante.
