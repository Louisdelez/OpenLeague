# OpenLeague development backup - 2026-11-07

Updates the existing backup branch and draft PR #3. This is a source/documentation checkpoint, not a release, complete backup of every local byte, or game acceptance.

## Scope

- Previous backup: `028b9f73fd99fc292bda1e82cdcd114e27c4a039`; upstream Git workflow and previous publication evidence retained.
- Source checkout: F:/OpenLeague, HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`. Its branch, files and active index are left untouched.
- Captured at 2026-11-07T07:21:30.143553+00:00.
- 13215 selected source/document paths; 425 excluded paths are listed in PUBLICATION_EXCLUSIONS_2026-11-07.json.
- Local AGENTS audit restrictions and upstream Git guidance are both preserved.
- Existing Plan sources are archived as prepared; no application, database, migration, installation or goal is executed or changed.

## Verification boundary

Selected files passed the bounded UTF-8/JSON and credential-marker preflight during preparation. Git captures their content as versioned blobs. The first Git add failed on Windows path length; the successful retry used command-local core.longpaths=true without changing repository configuration.

Publication checks and their actual outcomes are recorded in the PR update. The existing metadata checker has a known incompatibility with local-only packs whose URL is null; no product or checker correction is bundled into this backup.

No fresh complete Rust build, runtime, GPU, audio, multiplayer or game acceptance is claimed. Historical evidence retains its original qualification. Local source files can continue evolving after this snapshot.

## Exclusions

Large registries exceeding 5 MiB, reconstructed native archives, the compressed Plan database and flagged AIR sources remain local. Existing ignored asset packs, build caches, virtual environments and private session exports remain excluded. Previous exclusion manifests are retained, not replaced. This branch alone cannot restore the full current installation or all local evidence.

## Integration

Keep PR #3 in draft until repository policy, pack distribution and the remaining integration checks are resolved. The SYS-01.2-02 goal and game implementation remain open.
