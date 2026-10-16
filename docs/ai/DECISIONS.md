# Décisions communes aux agents

## 2026-10-15 — Continuité indépendante du fournisseur

Décision : partager les règles via Rulesync et garder l'état du projet dans des fichiers Markdown versionnables. Les agents utilisent les mêmes sources, avec des fichiers de compatibilité générés. Le modèle ou l'abonnement choisi ne devient pas la source de vérité du projet.

Raison : pouvoir reprendre OpenLeague dans Codex, Claude Code, OpenCode, Gemini CLI, Copilot ou Kimi sans reconstruire le contexte depuis une conversation unique.

Les plans détaillés existants restent les références de périmètre et de preuve. CURRENT.md et HANDOFF.md en sont des index courts ; ils ne clôturent aucune fonctionnalité. Une passation enregistre les tests effectivement exécutés, leur révision et leurs limites.

La mémoire Basic Memory utilise uniquement docs/ai/memory/, en local, avec configuration et index propres au projet. Les notes restent lisibles sans MCP. Les conversations privées, index, dépendances installées et exports restent dans des répertoires ignorés.

Les outils d'indexation de tous les historiques et les changements d'agent ne sont pas lancés automatiquement à chaque reprise. Le contexte transféré doit être borné au projet et au besoin de l'utilisateur.
