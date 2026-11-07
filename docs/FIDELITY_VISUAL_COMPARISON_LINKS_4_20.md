# Comparaison visuelle — traçabilité V116

Six exigences reliées à des consommateurs précis ou à leurs limites.

# V116 — Consommateurs de preuves visuelles

Inspection statique des consommateurs réels. Aucun runtime lancé ni case modifiée.

- Capture fenêtre réelle optionnelle ;délai25..600s,redimensionnement et restauration ;pas reçu de succès lié au callback. `F:\OpenLeague\crates\client\src\render_probe.rs:20`

- Cadrage diagnostic fourni par environnement ;ne fixe pas toute condition lumineuse. `F:\OpenLeague\crates\client\src\main.rs:1523`

- Synchronisation des vues A/B avec caméra principale. `F:\OpenLeague\crates\client\src\projected_pixel_pair.rs:54`

- Analyse pixels A/B du consommateur local,non comparaison framebuffer natif. `F:\OpenLeague\crates\client\src\projected_pixel_pair.rs:116`

- Restriction actuelle E: empêche activation avec sortie F: ;aucun ancien script lancé. `F:\OpenLeague\crates\client\src\projected_pixel_pair.rs:17`

- Notes/cases manuelles avec révision et historique ;pas preuve d’acceptation de fidélité. `F:\OpenLeague\tools\project-plan\store.py:134`

L’analyse historique A/B mesure activation contre suppression du même effet reconstruit ;elle ne compare pas LoL et OpenLeague. Les scripts v69 écrivent sur E: et restent historiques en lecture seule. Le chemin A/B rigide reste une limite ouverte à traiter avant nouvelle capture sur F:. Aucune acceptation visuelle déduite du fichier reference_client_4_20_acceptance.json,qui concerne une autre tâche d’identité historique.


## Vérification historique

Vulkan et DX12 v69 :3/5 empreintes concordent chacun ;projected_pixel_pair.rs et exécutable courant diffèrent. Aucun ancien reçu remplacé.

## Lecteur

16 fichiers,52 contrôles,29 cas dont28 refus. Aucun test GPU ou acceptation humaine nouvelle.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-15.4-01 | Cadrage diagnostic fourni par environnement ;ne fixe pas toute condition lumineuse. Synchronisation des vues A/B avec caméra principale. | Fixed focus and copied cameras exist;complete lighting/time/reference capture conditions remain unqualified. |
| SYS-15.4-02 | Capture fenêtre réelle optionnelle ;délai25..600s,redimensionnement et restauration ;pas reçu de succès lié au callback. Analyse pixels A/B du consommateur local,non comparaison framebuffer natif. | Capture request and GPU readback consumers exist;fresh successful current runtime capture not performed. |
| SYS-15.4-03 | Synchronisation des vues A/B avec caméra principale. Analyse pixels A/B du consommateur local,non comparaison framebuffer natif. | Historical per-backend self-suppression receipts are not cross-backend or native equivalence;code/executable pins differ. |
| SYS-15.4-04 | Notes/cases manuelles avec révision et historique ;pas preuve d’acceptation de fidélité. | Manual task notes/history exist;named visual anomaly workflow with screenshots and reproduction not identified. |
| SYS-15.4-05 | Capture fenêtre réelle optionnelle ;délai25..600s,redimensionnement et restauration ;pas reçu de succès lié au callback. Restriction actuelle E: empêche activation avec sortie F: ;aucun ancien script lancé. | Capture output may reuse paths;immutable replay/comparison workflow not identified and A/B still restricts output to E. |
| SYS-15.4-06 | Notes/cases manuelles avec révision et historique ;pas preuve d’acceptation de fidélité. | Manual done/notes are not explicit human acceptance of residual visual differences;no acceptance supplied. |

Reçu : docs/reference_visual_comparison_sources/visual_comparison-links.json. Livraison : docs/fidelity_registry_visual_comparison_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
