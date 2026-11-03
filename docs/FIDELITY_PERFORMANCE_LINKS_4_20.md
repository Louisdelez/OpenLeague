# Performance — traçabilité V153

V153 performance:eight requirements,eight explicit boundary roles.1163 source pins,1197 checks,35 reader cases including34 refusals.1157 owned Rust sources searched for named profiling APIs with no matches;bounded search is not exhaustive absence proof.30Hz pacing,1280x800 defaults,resource readiness and packet construction are not CPU/GPU/memory/bandwidth measurements. No benchmark or Rust/game execution;all eight scopes remain open.

## SYS-23.4-01

La boucle rattrape au plus cinq ticks, sans chronométrage CPU du game.advance dans cette boucle.

Reste à faire : Instrumenter et mesurer le tick à charge définie avec distribution des durées et identité du scénario.

## SYS-23.4-02

La fenêtre par défaut est 1280x800 ; cette configuration ne prouve aucune mesure CPU/GPU à 1920x1080.

Reste à faire : Mesurer les temps CPU/GPU à 1920x1080 avec machine, pilote, backend et scénario fixés.

## SYS-23.4-03

Le témoin contrôle la présence des images dans RenderAssets ; présence des ressources et mémoire réellement allouée sont distinctes.

Reste à faire : Mesurer RAM/VRAM au début et à la fin sur le même processus et scénario, en séparant cache et fuite.

## SYS-23.4-04

WorldInstanceReady sert de témoin de disponibilité ; il ne fournit pas à lui seul un temps de chargement carte/champions de bout en bout.

Reste à faire : Définir les bornes de chargement et mesurer les cartes/champions avec cache froid et chaud identifiés.

## SYS-23.4-05

Le serveur construit les paquets par joueur ; la production de paquets ne mesure pas le débit effectif ni un flux spectateur qualifié.

Reste à faire : Mesurer les octets envoyés/reçus par rôle et intervalle, pertes/répétitions comprises, pour joueurs et spectateurs.

## SYS-23.4-06

La constante 30Hz définit la cadence ; elle ne garantit ni temps disponible par tick ni 60FPS mesurés.

Reste à faire : Fixer les budgets CPU/GPU/mémoire/réseau sur mesures et matériel cible puis qualifier les seuils.

## SYS-23.4-07

Le nettoyage des surfaces orphelines corrige un cycle de vie précis ; ce mécanisme ne fournit pas un profil de dépassement ni sa cause mesurée.

Reste à faire : Profiler les dépassements observés et créer des tâches sourcées par cause effectivement mesurée.

## SYS-23.4-08

Le vérificateur réseau attend des messages dans un délai ; il ne rejoue pas un benchmark avant/après optimisation avec métriques comparables.

Reste à faire : Définir et rejouer un scénario de mesure identique avant/après avec versions, charge et métriques conservées.

Aucun temps CPU/GPU, compteur mémoire ou débit mesuré ici. La recherche est bornée aux sources Rust propres et aux API nommées ; elle ne prouve pas l’absence de tout outil externe ou mesure historique. Le reçu FXAA conserve actual_gpu_allocation_qualified=false. Aucune cible 60FPS déclarée atteinte à partir de la constante 30Hz.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.4-01 | La boucle rattrape au plus cinq ticks, sans chronométrage CPU du game.advance dans cette boucle. | Instrumenter et mesurer le tick à charge définie avec distribution des durées et identité du scénario. |
| SYS-23.4-02 | La fenêtre par défaut est 1280x800 ; cette configuration ne prouve aucune mesure CPU/GPU à 1920x1080. | Mesurer les temps CPU/GPU à 1920x1080 avec machine, pilote, backend et scénario fixés. |
| SYS-23.4-03 | Le témoin contrôle la présence des images dans RenderAssets ; présence des ressources et mémoire réellement allouée sont distinctes. | Mesurer RAM/VRAM au début et à la fin sur le même processus et scénario, en séparant cache et fuite. |
| SYS-23.4-04 | WorldInstanceReady sert de témoin de disponibilité ; il ne fournit pas à lui seul un temps de chargement carte/champions de bout en bout. | Définir les bornes de chargement et mesurer les cartes/champions avec cache froid et chaud identifiés. |
| SYS-23.4-05 | Le serveur construit les paquets par joueur ; la production de paquets ne mesure pas le débit effectif ni un flux spectateur qualifié. | Mesurer les octets envoyés/reçus par rôle et intervalle, pertes/répétitions comprises, pour joueurs et spectateurs. |
| SYS-23.4-06 | La constante 30Hz définit la cadence ; elle ne garantit ni temps disponible par tick ni 60FPS mesurés. | Fixer les budgets CPU/GPU/mémoire/réseau sur mesures et matériel cible puis qualifier les seuils. |
| SYS-23.4-07 | Le nettoyage des surfaces orphelines corrige un cycle de vie précis ; ce mécanisme ne fournit pas un profil de dépassement ni sa cause mesurée. | Profiler les dépassements observés et créer des tâches sourcées par cause effectivement mesurée. |
| SYS-23.4-08 | Le vérificateur réseau attend des messages dans un délai ; il ne rejoue pas un benchmark avant/après optimisation avec métriques comparables. | Définir et rejouer un scénario de mesure identique avant/après avec versions, charge et métriques conservées. |

Reçu : docs/reference_performance_sources/performance-links.json. Livraison : docs/fidelity_registry_performance_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
