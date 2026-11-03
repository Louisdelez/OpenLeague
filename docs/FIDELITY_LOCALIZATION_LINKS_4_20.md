# Localisation — traçabilité V146

V146 localization:seven requirements,seven roles including three boundaries.75 source pins,142 checks,32 reader cases including31 refusals.31 native/copy pairs and19 font profiles rechecked;114 locale/interface tasks verified through228 database task/copy reads. Text keys,plurals,glyph coverage and missing-string/overflow behavior remain partial. No Rust or graphical test executed.

## SYS-22.1-01

19 supplied font profiles and31 source/copy pairs are verified;loader selects profile from locale configuration.

Limites : Complete texts,media and actual regional availability are not proved by font profiles.

## SYS-22.1-02

114 existing tasks cover19 locales with SOURCE,CLIENT,HUD,FONT,AUDIO,LAYOUT;228 database task/copy checks pass.

Limites : Keep completeness and actual availability qualification open within each named task.

## SYS-22.1-03

Launcher renders a literal French play label.

Limites : Native text-key mapping and locale-selected launcher catalog remain to qualify.

## SYS-22.1-04

Shop renders French prompts and consumes localized item catalog.

Limites : All HUD keys/tooltips need native mapping and selected-locale coverage.

## SYS-22.1-05

Tooltip regeneration value uses Rust numeric formatting.

Limites : Locale-specific plurals,number separators and duration formats remain unqualified.

## SYS-22.1-06

Font resolver selects mapped files and rejects missing/ambiguous mappings.

Limites : Glyph completeness,raster fidelity and rendering per locale remain open.

## SYS-22.1-07

Missing item lookup returns literal Inconnu.

Limites : Explicit missing-key reporting and layout overflow checks are not established by this fallback.

Les tâches SOURCE, CLIENT, HUD, FONT, AUDIO et LAYOUT existent pour chacune des19 locales ; aucune duplication créée. Présence des profils ne signifie pas disponibilité régionale complète. Les distinctions de membership de V52 sont conservées.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-22.1-01 | 19 supplied font profiles and31 source/copy pairs are verified;loader selects profile from locale configuration. | Complete texts,media and actual regional availability are not proved by font profiles. |
| SYS-22.1-02 | 114 existing tasks cover19 locales with SOURCE,CLIENT,HUD,FONT,AUDIO,LAYOUT;228 database task/copy checks pass. | Keep completeness and actual availability qualification open within each named task. |
| SYS-22.1-03 | Launcher renders a literal French play label. | Native text-key mapping and locale-selected launcher catalog remain to qualify. |
| SYS-22.1-04 | Shop renders French prompts and consumes localized item catalog. | All HUD keys/tooltips need native mapping and selected-locale coverage. |
| SYS-22.1-05 | Tooltip regeneration value uses Rust numeric formatting. | Locale-specific plurals,number separators and duration formats remain unqualified. |
| SYS-22.1-06 | Font resolver selects mapped files and rejects missing/ambiguous mappings. | Glyph completeness,raster fidelity and rendering per locale remain open. |
| SYS-22.1-07 | Missing item lookup returns literal Inconnu. | Explicit missing-key reporting and layout overflow checks are not established by this fallback. |

Reçu : docs/reference_localization_sources/localization-links.json. Livraison : docs/fidelity_registry_localization_links_revision_4_20.json. Les sept tâches et le Goal restent ouverts.
