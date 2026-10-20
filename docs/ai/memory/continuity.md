---
title: Cross-agent continuity
type: note
permalink: continuity
---

# Continuité entre agents

## Observations

- [decision] .rulesync/ est la source des consignes et skills ; les sorties propres aux agents sont générées et vérifiables.
- [decision] docs/ai/CURRENT.md et HANDOFF.md sont les points d'entrée courts. Les notes ne remplacent pas les fichiers, le diff Git ou les rapports de qualification.
- [decision] .ai-tools/state/ contient les passations privées, exports et index ; ces données restent hors Git.
- [limit] MCP expose les mêmes notes aux clients configurés, sans transférer automatiquement la conversation, les permissions ni l'état des processus.
- [limit] L'installation de fichiers de compatibilité ne prouve pas qu'un client absent ou déconnecté les a chargés. Le premier démarrage du client doit vérifier les instructions et les outils disponibles.

## Relations

- supports [[project]]
