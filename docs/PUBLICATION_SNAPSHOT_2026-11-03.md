# OpenLeague development backup — 2026-11-03

This branch preserves the current development and audit sources. It is a backup checkpoint, not a game release or a declaration of completeness.

## Scope

- Source checkout: OpenLeague on F:, left on its original main branch with its working files and index preserved.
- Base: upstream main commit `5e8f07eca8454527e4361b1757bd92aa8e039ef7`, including the existing Git/GitHub workflow changes.
- Snapshot: 12,792 selected source/document files before this publication note and its exclusion manifest; approximately 656 MB of selected file content before Git compression.
- The AGENTS.md merge retains both the local audit restrictions and the upstream Git policy paragraph.
- Existing prepared Plan application sources are archived as they stand. No application, migration, database, game, or goal is executed or modified by this publication.

## Exclusions and completeness

The accompanying `PUBLICATION_EXCLUSIONS_2026-11-03.json` lists 423 excluded paths and their reasons. They remain on the source disk.

- 57 files exceed the repository's 5 MiB per-file policy, including large task/source/unknown registries.
- 359 native archive files belong in resource packs.
- One compressed Plan database is excluded.
- Six AIR source files are quarantined due to replacement characters or private-key header matches; the latter include cryptographic fixture/parser source and are not established production secrets.

Existing ignored asset packs, caches, runtime data, virtual environments and private session exports are not added. This Git branch is therefore not a complete standalone or restorable game installation. Large local-only resource packs and the listed registries are not newly uploaded by this commit. Do not treat links to local audit receipts as hosted artifacts.

## Checks executed

- Inventory of paths, sizes and SHA-256 identities for selected files.
- Parsing of selected JSON files; UTF-8 validation of selected text files.
- Scan for private key headers and selected credential token patterns; flagged sources excluded. This bounded scan is not a guarantee that every possible secret format is detected.
- Staged file-policy checks from the unchanged upstream `tools/git/check_repo.py`: no file-policy errors.
- Global metadata policy: fails with `AttributeError: 'NoneType' object has no attribute 'startswith'` because the upstream checker assumes every asset pack URL is a string while the current manifest explicitly includes `local_only: true` and `url: null`.
- The source checkout index digest is identical before and after snapshot preparation.

No full Rust build, complete game tests, visual acceptance, or historical runtime qualification is claimed for this snapshot. Existing individual test receipts keep their original scopes. Whitespace checks report inherited formatting differences; no broad reformatting is performed during backup.

## Integration boundary

Keep this backup on its dedicated branch until the local-only pack distribution, large reference artifacts and repository-policy incompatibility are resolved or explicitly reviewed. The game audit SYS-01.2-02 and its outstanding functional work remain open.
