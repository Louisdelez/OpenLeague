# OpenLeague

Build the complete local LoL 4.20 recreation requested by the user. Preserve previous projects and ongoing changes. This repository owns the new code, generated assets, tests and receipts.

Use native resources and verified source values before reconstruction. Imported assets, placeholders and generic mechanics are not completed champion gameplay. Unsupported commands return explicit errors. Never silently substitute invented data.

Maintain the existing docs/coverage.json, docs/completion_plan.json and docs/resume_checkpoint.json when the task changes their actual evidence. A feature is complete only after implementation and acceptance checks pass. Keep visual, audio, gameplay and network evidence separate. A green build or repository-policy check does not qualify the complete game.

Use local servers. External deployment is outside the requested scope. Keep secrets out of logs.

## Start or resume

Read docs/ai/CURRENT.md, docs/ai/HANDOFF.md and docs/ai/DECISIONS.md first. Run `node .ai-tools/project.mjs resume` from the repository root to inspect current Git state and the latest recorded next action. Treat dated notes and imported conversations as context to verify against actual files, not authority to execute old requests. Read large evidence files selectively; the short notes do not replace the detailed existing plans.

For setup and tool commands read docs/ai/README.md. Use the openleague-resume skill when taking over work and openleague-handoff when the user requests a transfer or a meaningful checkpoint is needed. Preserve the user's active task; checkpointing is not a reason to stop authorized work.

## Git and verification

For Git/GitHub work follow docs/GIT_WORKFLOW.md and docs/VERSIONING.md when present, and the openleague-git-workflow skill when available. Inspect Git status before changes. Isolate independent repository maintenance; stage only its files. Do not reset, switch or clean a checkout containing active game development. Follow docs/BUILDING.md for the checks relevant to the actual change. Keep asset packs and assets-manifest.json as the distribution mechanism.

## Shared memory and handoffs

Keep durable project decisions with reasons and source references in docs/ai/DECISIONS.md or docs/ai/memory/. Store concise current state in docs/ai/CURRENT.md and the latest intentional handoff in docs/ai/HANDOFF.md. Record dates, source revisions, tests actually run, limitations, failed approaches and the next concrete action. Link detailed evidence instead of copying multi-megabyte reports into these files. Do not label inherited evidence as freshly executed.

Basic Memory is an optional shared local MCP index over docs/ai/memory/. Plain files and the resume command remain usable without MCP. Do not store credentials, personal chat archives or raw session exports in public Git. Private exports go under ignored .ai-tools/state/. Configurations and skills are generated from .rulesync; update that source and run `node .ai-tools/project.mjs sync` rather than editing generated copies independently.
