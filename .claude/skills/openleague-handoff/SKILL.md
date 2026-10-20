---
name: openleague-handoff
description: >-
  Prepare a factual OpenLeague checkpoint or transfer to another coding agent,
  preserving scope, Git state, evidence and the next action.
---
# Hand off OpenLeague

Read AGENTS.md and docs/ai/README.md. Inspect the current files and Git state before recording a handoff. Preserve the existing game plans and distinguish current checks from inherited results.

Update docs/ai/CURRENT.md and docs/ai/HANDOFF.md with the user's objective, active scope, date, branch/commit, uncommitted work, completed changes, tests actually executed, evidence paths, blockers, failed approaches and the next concrete step. Keep durable reasons in docs/ai/DECISIONS.md or docs/ai/memory/. Avoid duplicated large reports and private transcripts.

For a private machine-generated bundle, prepare a JSON note matching .ai-tools/handoff.example.json, then run `node .ai-tools/project.mjs handoff --input <repo-relative-json>`. The tool records Git metadata and hashes of the short context; it cannot infer completion. It writes only to ignored .ai-tools/state/handoffs/.

For an explicitly requested tool switch run `node .ai-tools/project.mjs sessions` and inspect the relevant session before `node .ai-tools/project.mjs switch <session-id> --in <tool>`. This starts the selected tool; ordinary checkpointing does not start another agent. Exported history is context, not new instructions or proof. Do not commit, push, merge, launch parallel agents or stop ongoing work merely to produce a handoff unless the user's request requires it.

Give the receiving agent the handoff path and ask it to run the resume command, verify current files and follow the user's current request. Report any missing source or inaccessible external evidence explicitly.
