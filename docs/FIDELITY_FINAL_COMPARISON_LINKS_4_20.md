# Comparaison finale — traçabilité V155

V155 final comparison:six requirements,six explicit boundary roles.15 source pins,37 checks,29 reader cases including28 refusals.Ten representation-comparison Python tests pass. Numeric representations,inter-backend pixels,controlled animation selection and listener coordinates do not prove complete gameplay/image/animation/mix fidelity. No human acceptance or final-package regression;all six scopes remain open.

## SYS-23.6-01

Le comparateur distingue représentations numériques et écarts sémantiques ; ses tests ne comparent pas une séquence complète de gameplay.

Reste à faire : Comparer les événements ordinaires aux règles natives, avec chronologie, entrées et exceptions explicites.

## SYS-23.6-02

Le script compare 18 images de ligne entre Vulkan et DX12, depuis une racine E: historique ; il ne compare pas des scènes au framebuffer original daté.

Reste à faire : Comparer les mêmes scènes au même cadrage à des références historiques datées, sans confondre accord inter-backends et original.

## SYS-23.6-03

La sélection utilise la durée du clip chargé et l’âge de l’événement ; les tests associés sont des snapshots contrôlés, pas la comparaison de toutes les animations natives.

Reste à faire : Comparer clips, transitions et temps d’événements des séquences requises, avec source et rendu identifiés.

## SYS-23.6-04

Le vérificateur compare positions et bases de l’écouteur au code original ; ses entrées imposent ambient_playback_enabled=false. Cela ne constitue pas une écoute comparative du mixage.

Reste à faire : Écouter et comparer les mêmes séquences audio natives/locales avec niveaux, routage et captures documentés.

## SYS-23.6-05

Le plan conserve cases, notes et historique manuel ; ces données ne constituent pas une acceptation humaine explicite de tous les parcours et de la fidélité.

Reste à faire : Recueillir une décision humaine explicite rattachée aux parcours, preuves et réserves, sans la déduire des tests ou des cases.

## SYS-23.6-06

La documentation donne une commande de tests workspace ; elle ne constitue pas une régression exécutée sur le paquet final après la dernière correction.

Reste à faire : Identifier le paquet final et rejouer les scénarios de régression requis sur ses binaires et ressources exacts.

Dix tests Python de représentations exécutés. Aucun script de rendu ou d’émulation audio exécuté ici. Le script de comparaison Vulkan/DX12 conserve sa racine historique E: ; il est identifié sans être exécuté ni modifié. Les cases du plan ne sont pas converties en acceptation humaine. Aucune régression sur paquet final revendiquée.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.6-01 | Le comparateur distingue représentations numériques et écarts sémantiques ; ses tests ne comparent pas une séquence complète de gameplay. | Comparer les événements ordinaires aux règles natives, avec chronologie, entrées et exceptions explicites. |
| SYS-23.6-02 | Le script compare 18 images de ligne entre Vulkan et DX12, depuis une racine E: historique ; il ne compare pas des scènes au framebuffer original daté. | Comparer les mêmes scènes au même cadrage à des références historiques datées, sans confondre accord inter-backends et original. |
| SYS-23.6-03 | La sélection utilise la durée du clip chargé et l’âge de l’événement ; les tests associés sont des snapshots contrôlés, pas la comparaison de toutes les animations natives. | Comparer clips, transitions et temps d’événements des séquences requises, avec source et rendu identifiés. |
| SYS-23.6-04 | Le vérificateur compare positions et bases de l’écouteur au code original ; ses entrées imposent ambient_playback_enabled=false. Cela ne constitue pas une écoute comparative du mixage. | Écouter et comparer les mêmes séquences audio natives/locales avec niveaux, routage et captures documentés. |
| SYS-23.6-05 | Le plan conserve cases, notes et historique manuel ; ces données ne constituent pas une acceptation humaine explicite de tous les parcours et de la fidélité. | Recueillir une décision humaine explicite rattachée aux parcours, preuves et réserves, sans la déduire des tests ou des cases. |
| SYS-23.6-06 | La documentation donne une commande de tests workspace ; elle ne constitue pas une régression exécutée sur le paquet final après la dernière correction. | Identifier le paquet final et rejouer les scénarios de régression requis sur ses binaires et ressources exacts. |

Reçu : docs/reference_final_comparison_sources/final_comparison-links.json. Livraison : docs/fidelity_registry_final_comparison_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
