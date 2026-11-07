# SYS-01.2-02 — contrôle des sélecteurs récents

Le contrôleur installé tools/project-plan/audit_recent_evidence_selectors.py vérifie107sélecteurs et5empreintes de reçus V158–V161. Il refuse les champs absents, les index invalides, les doublons et les réaffectations de tâche. Huit tests passent, dont la régression réelle /facts du reçu RADS, corrigée en V161.

Commande : python -B tools/project-plan/audit_recent_evidence_selectors.py --root F:/OpenLeague
Tests : python -B tools/project-plan/test_recent_evidence_selectors.py

La fiche SYS-01.2-02 et sa copie ont été vérifiées dans les deux bases ;42606états manuels et historique conservés, intégrité SQLite ok. La portée explicite reste limitée aux cinq reçus : les autres sélecteurs historiques, les consommateurs ordinaires et la fidélité du jeu ne sont pas validés par ce contrôle. Aucun graphe ni source native modifié dans ce lot.

Preuves : docs/fidelity_recent_selector_audit_v162.json et docs/fidelity_selector_audit_task_link_v162.json. Scripts, sorties et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision162.
