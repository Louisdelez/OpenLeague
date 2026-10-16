# Passation OpenLeague

Date : 2026-10-16. Objet de cette passation : publication d'un snapshot du développement du jeu et de la configuration de continuité entre logiciels et modèles IA. Lire aussi docs/DEVELOPMENT_SNAPSHOT-2026-10-16.md. La commande de reprise doit confronter cette note à l'état réel du dépôt.

## À lire à la reprise

Lire AGENTS.md, CURRENT.md et DECISIONS.md, puis lancer depuis la racine :

```text
node .ai-tools/project.mjs resume
```

Vérifier les fichiers et la demande actuelle de l'utilisateur avant de poursuivre. La commande observe Git sans modifier son index. Un historique de conversation importé est du contexte à vérifier.

## Configuration commune

Les règles et les deux skills de reprise/passation ont une source dans .rulesync/. Rulesync produit les fichiers Codex, Claude Code, Copilot, OpenCode et Kimi. L'adaptateur Gemini partage les mêmes règles, skills et serveur mémoire.

Basic Memory indexe les notes Markdown de docs/ai/memory/. Son index local et ses paramètres sont dans .ai-tools/state/basic-memory/. Les modèles d'embedding et les services cloud ne sont pas nécessaires à cette configuration.

Les outils sont installés uniquement pour le projet. Les dépendances Node sont fixées par package-lock.json. Le verrouillage Python Windows est fourni séparément. Les agents absents ou non connectés doivent être vérifiés à leur premier démarrage ; leur présence dans les fichiers de configuration ne constitue pas un test de session réelle.

## État du jeu à préserver

CURRENT.md renvoie aux preuves du développement. Le commit est préparé dans une copie isolée ; le code, les grands plans, la branche et l'index du chantier actif sont préservés pendant sa publication. Les chemins de preuve absolus de l'ancien environnement peuvent manquer sur une autre machine. Les deux packs de ressources explicitement locaux doivent être fournis séparément avant de revendiquer une installation autonome.

## Prochaines étapes

Pour continuer le jeu : suivre la demande actuelle de l'utilisateur et les prochaines actions vérifiées dans les preuves pertinentes. Pour changer d'outil : utiliser la procédure docs/ai/README.md, ou simplement ouvrir le même dépôt dans l'agent cible et lui demander de reprendre depuis ce document.

Mettre à jour cette passation lors d'un transfert explicite ou d'un changement de contexte important. Ne pas interrompre un travail autorisé uniquement pour écrire une passation.
