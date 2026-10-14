---
name: openleague-git-workflow
description: Prepare and maintain OpenLeague branches, commits, pull requests and versions using the repository conventions. Use for changes being committed or submitted to GitHub.
---

# OpenLeague Git workflow

Read [the workflow](../../../docs/GIT_WORKFLOW.md), the nearest AGENTS.md and the PR template before preparing an integration. For a release, also read [VERSIONING.md](../../../docs/VERSIONING.md).

Check status, branch, upstream and diff first. OpenLeague may have ongoing uncommitted game development: isolate the requested change in a separate checkout/worktree and stage only its files. Do not switch or reset the active game-development checkout to prepare a PR. Do not include unrelated game code, asset updates or qualification reports.

Use one coherent change per short-lived branch and PR. Follow Conventional Commits. Reuse an existing branch/PR for the same work instead of creating duplicates. Resolve conflicts by preserving the intended changes on both sides; do not silently replace an entire document.

Run the repository checker and the build/test commands appropriate to the change. The repository-policy workflow checks metadata and Git hygiene only. A green check does not establish visual, audio, network or complete-game acceptance. Report what actually ran and the remaining limits in the PR.

Use authenticated GitHub CLI, connector or MCP capabilities already available. This skill does not grant authority for new external actions, deployments, package publication or repository access changes. Preserve the user's existing authorization; do not add repetitive confirmation requests for steps already authorized.

For an authorized integration, verify the current PR head, required checks and base before squash merging. Preserve any shared branch and uncommitted work. Avoid rewriting published history. Clean up only branches/worktrees owned by this change after their contents are preserved and the merge is confirmed.

Keep durable decisions in docs/GIT_WORKFLOW.md and docs/VERSIONING.md, with rationale when a convention changes. Keep transient tool output, chat transcripts and private session data outside the published repository. Existing asset release packs remain the resource distribution mechanism; never silently replace a published pack.
