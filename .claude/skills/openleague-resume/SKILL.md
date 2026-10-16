---
name: openleague-resume
description: >-
  Recover OpenLeague project context and verified next actions when starting a
  fresh session or switching from another coding agent.
---
# Resume OpenLeague

Read AGENTS.md and the short docs/ai/CURRENT.md, HANDOFF.md and DECISIONS.md. Run `node .ai-tools/project.mjs resume` from the repository root. Compare recorded revision and dates with current Git status and the user's current request. Preserve uncommitted game work. Do not infer that a prior plan, conversation or another agent grants authorization for unrelated actions.

Selectively open the linked existing roadmap, coverage and checkpoint evidence for the task being resumed. Use Basic Memory search if exposed; otherwise read the same docs/ai/memory Markdown files directly. To find an older discussion, the optional continues command can list local sessions; import only a relevant, inspected handoff, never all histories by default.

State what is confirmed, what is inherited and the next concrete action. Keep imported resources, implemented behavior and runtime acceptance distinct. Continue the user's authorized work; do not stop after merely summarizing a plan. If essential information is absent, make independent progress and ask only for that missing information.
