# Reprendre OpenLeague avec un autre agent IA

Le dépôt porte ses consignes, compétences, décisions et état de reprise. Le service IA doit pouvoir accéder à ces fichiers, directement ou par un export sélectionné. Les permissions, processus ouverts et capacités du modèle restent propres à chaque environnement.

## Reprise immédiate

Ouvrir le dossier OpenLeague dans le logiciel choisi, depuis sa racine, puis demander :

> Lis AGENTS.md et docs/ai/HANDOFF.md. Exécute node .ai-tools/project.mjs resume. Vérifie l'état réel du dépôt et reprends ma demande actuelle en conservant les modifications existantes.

Codex, Claude Code, OpenCode, Copilot, Gemini CLI et Kimi disposent de fichiers de compatibilité. Les règles demandent de charger les points de reprise. Les choix locaux ou administratifs du client peuvent désactiver des instructions ou demander de faire confiance au dépôt ou au serveur MCP. Vérifier les instructions et les outils exposés au premier démarrage ; ils ne sont pas garantis par leur seule présence sur disque.

## Commandes depuis la racine

```text
node .ai-tools/project.mjs resume
node .ai-tools/project.mjs doctor
node .ai-tools/project.mjs sync
node .ai-tools/project.mjs check
node --test .ai-tools/project.test.mjs
node .ai-tools/project.mjs export
```

- resume : notes courtes, état Git et prochaine action enregistrée. Lecture seule, sans téléchargement ni lancement d'un agent.
- doctor : présence des fichiers et outils installés ; ne qualifie pas chaque service IA.
- sync : régénère les règles, skills et configurations MCP gérés ; préserver les paramètres externes existants.
- check : détecte les sorties Rulesync obsolètes et une divergence du fichier Gemini.
- export : crée .ai-tools/state/context.xml, un export sélectionné pour un chat web. Ce fichier doit être fourni au service choisi ; il ne donne pas à ce service l'accès au PC.

## Changer d'agent avec continues

```text
node .ai-tools/project.mjs sessions
node .ai-tools/project.mjs switch IDENTIFIANT --in claude
```

Autres destinations du raccourci : codex, opencode, gemini, copilot, kimi, cursor, droid, qwen-code. Le client cible doit être installé et connecté. Aucun changement d'agent n'est lancé automatiquement pendant une reprise.

continues lit les historiques locaux compatibles et écrit son propre cache privé dans le profil utilisateur ~/.continues/. Le raccourci sessions filtre les résultats sur le dossier OpenLeague, même si le cache amont peut contenir les métadonnées d'autres projets. Il ne convertit pas tout l'état des processus. Son export est borné par les paramètres de verbosité et par les données présentes dans les journaux. Une conversation uniquement stockée dans un service distant n'est pas garantie accessible. Examiner la session pertinente et les données transférées avant de la transmettre à un autre fournisseur.

## Passation privée reproductible

Copier .ai-tools/handoff.example.json dans .ai-tools/state/note.json et renseigner les champs avec les faits de la session, puis lancer :

```text
node .ai-tools/project.mjs handoff --input .ai-tools/state/note.json
```

Le reçu JSON est créé dans .ai-tools/state/handoffs/ avec branche, commit, modifications observées et empreintes des notes. Il ne prétend pas avoir exécuté les tests mentionnés par l'auteur. Les données privées ne sont pas ajoutées à Git.

## Mémoire commune locale

Le serveur openleague-memory est déclaré dans les configurations projet des agents. Il démarre à la demande sur stdio, sans serveur réseau permanent. Lancer les clients depuis la racine du dépôt pour résoudre .ai-tools/memory.mjs.

Le lanceur fixe un projet local pointant sur docs/ai/memory/, un index dans .ai-tools/state/basic-memory/ et une recherche textuelle sans modèle d'embedding. Au premier démarrage, l'indexation est asynchrone : une recherche peut être vide avant sa fin. Réessayer quelques secondes plus tard ou lire directement les notes ; ne pas conclure que le projet est vide. Les mêmes notes sont lisibles sans MCP. Les paramètres personnels Basic Memory ne sont pas utilisés. Le test du serveur s'exécute avec le Python du venv :

```text
.ai-tools/.venv/Scripts/python.exe -B .ai-tools/smoke-memory.py
```

Sur POSIX, utiliser .ai-tools/.venv/bin/python. Un nouveau client peut nécessiter un redémarrage de session ou une approbation native de son MCP ; la session déjà ouverte ne reçoit pas nécessairement les nouveaux outils.

## Installation sur un nouveau clone

Prérequis : Node.js 22.5+ (24 recommandé), npm, Git, Python 3.12+ avec venv/pip. Depuis la racine :

```text
npm ci --prefix .ai-tools --ignore-scripts --no-audit --no-fund
python -m venv .ai-tools/.venv
.ai-tools/.venv/Scripts/python.exe -m pip install -r .ai-tools/requirements-windows.lock.txt
node .ai-tools/project.mjs sync
node .ai-tools/project.mjs doctor
```

Le fichier requirements-windows.lock.txt fixe l'environnement Windows qualifié. Pour un autre système, utiliser requirements.txt avec le chemin bin/python : seuls les paquets principaux y sont fixés, puis qualifier l'environnement obtenu. Les environnements virtuels et node_modules ne se publient pas.

## Sources maintenues

- .rulesync/rules/ et .rulesync/skills/ : consignes et compétences communes.
- .rulesync/mcp.jsonc : déclaration du serveur local sans secret.
- docs/ai/CURRENT.md, HANDOFF.md, DECISIONS.md : état court et raisons durables.
- docs/ai/memory/ : notes partagées et indexables.
- Grands plans et preuves existants : périmètre et qualification détaillés, à lire sélectivement.

Éviter les consignes divergentes dans les fichiers générés. Les réglages MCP d'autres serveurs doivent être conservés. Rulesync est fixé à 35.0.0 ; cette version n'a pas de cible Gemini CLI, d'où l'adaptateur explicite dans project.mjs. Les fichiers JSONC préexistants doivent être revus avant toute fusion automatique de paramètres.
