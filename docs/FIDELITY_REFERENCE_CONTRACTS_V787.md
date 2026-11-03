# SYS-01.2-02 — Références et identités, V787

Projet : F:/OpenLeague. Référence historique du jeu : LoL PUBLIC 4.20.0.315, EUW/en_GB.

## Défaut corrigé

Le lecteur réel reference_adoption_decisions.py refusait son reçu V158 avec « Content changed ». Deux décisions, REF-11-ADOPT et REF-12-ADOPT, épinglaient une ancienne version de requirement_trace.py. Les changements de ce fichier étaient déjà archivés : gestion des liens hors périmètre et affichage des références. Ses fonctions et lignes citées sont encore présentes.

Le nouveau reçu immuable decisions-v787.json actualise ces deux empreintes. Les douze décisions, leurs sources, commits, ancres et limites sont conservés. Le reçu V158 n’est pas modifié. Le lecteur pointe maintenant vers le nouveau reçu ; ses contrôles de hash, chemin, commit et portée restent identiques.

source_versions.py autorise explicitement le versionnement de ce lecteur local. Les deux anciens fichiers et leurs enregistrements complets sont conservés dans docs/fidelity_source_versions. Les preuves historiques et les sources natives restent interdites à l’adoption de nouvelles versions.

## Associations intégrées

Les24tâches REF-01..12-AUDIT/ADOPT et SYS-01.2-01 ont une base locale explicite, avec référence à D03.md ou D01.md.86liens existants sont conservés ;34liens supplémentaires rattachent les décisions aux lecteurs et aux déclarations ou fonctions effectivement présentes. Cinq nouvelles ancres sont créées, les autres sont réutilisées.

Les références d’ingénierie modernes ne sont pas des ressources natives Riot. Les décisions de conserver la pile ou de ne pas ajouter de dépendance concernent le livrable de traçabilité. Elles ne prouvent pas l’adoption générale des recommandations dans le jeu. Les24questions communautaires restent ouvertes et les états manuels sont conservés.

## Contrôles exécutés

| Contrôle | Attendu et observé |
| --- | --- |
| Ancien reçu contre les fichiers actuels | Refus Content changed, conservé comme observation initiale. |
| Nouveau reçu, lecteur installé |12résolutions exactes. |
| Reçu incomplet, doublon, tâche ou dépôt substitué, commit changé | Refus explicites. |
| Autorité native ou adoption complète revendiquée, décision vide | Refus explicites. |
| SHA source/consommateur erroné, chemin substitué, ligne déplacée | Refus explicites. |
| Résolution d’une tâche inconnue | Refus explicite ; total13cas de refus. |
| Tests existants de versionnement et déplacement de racine |22tests réussis. |
| Adoption d’un ancien reçu ou d’une source native | Deux refus de la liste autorisée. |
|93documents locaux de12dépôts | SHA-256 identiques au catalogue conservé. |
| Identités du registre actuel |42 215actives,151historiques,392archivées ;42 758identités uniques. |
| Métadonnées/renumérotation de références et chemins invalides | Trois invariances d’identité et quatre refus de chemins. |

Cargo.lock contient toujours Bevy0.19.0 et wgpu29.0.4. Les versions des snapshots et décisions antérieures restent distinctes. Aucun outil externe installé, aucun nouveau téléchargement, build, jeu ou GPU exécuté. La provenance distante V55 est conservée comme preuve antérieure, sans nouvelle requête. Aucune nouvelle analyse REA nécessaire pour cette correction de lecteurs Python.

## Détail par tâche

| Tâche | Objectif | Contrat et consommateur |
| --- | --- | --- |
| SYS-01.2-01 | Attribuer un identifiant stable à chaque exigence de fidélité | 2 liens ; lecteur exécuté, contexte moteur statique. |
| REF-01-AUDIT | bevyengine/bevy : vérifier les extraits récupérés au commit 90942be05dcb7bdafd1935c61dcb486156d3937f et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-01-ADOPT | bevyengine/bevy : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-02-AUDIT | chrisgliddon/bevy-skills : vérifier les extraits récupérés au commit b1b4da5744ebbd5c526342b2351967411cd5ca61 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-02-ADOPT | chrisgliddon/bevy-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-03-AUDIT | ChronoCoders/spawn : vérifier les extraits récupérés au commit 34a4c4b0e9cb71cf4d016cc5e15a3a418fbaf523 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-03-ADOPT | ChronoCoders/spawn : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-04-AUDIT | criticaldeveloper/codex-game-studio : vérifier les extraits récupérés au commit 1452f7a7240db07cd3cb9decda062da54d3d3438 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-04-ADOPT | criticaldeveloper/codex-game-studio : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-05-AUDIT | dimforge/rapier : vérifier les extraits récupérés au commit 846c463e47ef654d6a6ce6fa0e455f3a1e98c2ec et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-05-ADOPT | dimforge/rapier : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-06-AUDIT | gfx-rs/wgpu : vérifier les extraits récupérés au commit dd033bfb7fb3690eb2e80a971877a1ef8ecabe59 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-06-ADOPT | gfx-rs/wgpu : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-07-AUDIT | ketd/AnvilKit : vérifier les extraits récupérés au commit 62ea6b1a11f6a722f655926f65b9c8926eb95430 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-07-ADOPT | ketd/AnvilKit : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-08-AUDIT | leonardomso/rust-skills : vérifier les extraits récupérés au commit fd2a861ab0406a4ac536a55274d14ea6fd1ca9c9 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-08-ADOPT | leonardomso/rust-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-09-AUDIT | Luminary-Analytics/plinth : vérifier les extraits récupérés au commit afca7930192c5b3979abf03eafcd236287a655fc et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-09-ADOPT | Luminary-Analytics/plinth : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-10-AUDIT | mike007jd/game-superpowers : vérifier les extraits récupérés au commit 3925ffb92d405b34fd1be23fde79fec3f4dc6af0 et leur utilité réelle | 6 liens ; lecteur exécuté, contexte moteur statique. |
| REF-10-ADOPT | mike007jd/game-superpowers : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 2 liens ; lecteur exécuté, contexte moteur statique. |
| REF-11-AUDIT | poorvith-mp/skills-gamedev : vérifier les extraits récupérés au commit e8b87e9086fbf2322b1c216c2d2de85954bf4015 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-11-ADOPT | poorvith-mp/skills-gamedev : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |
| REF-12-AUDIT | qiuaoru-coder/game-design-agent-skills : vérifier les extraits récupérés au commit 29e8c759ca26c6bd4f337744b647dc728bf322b6 et leur utilité réelle | 7 liens ; lecteur exécuté, contexte moteur statique. |
| REF-12-ADOPT | qiuaoru-coder/game-design-agent-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire | 3 liens ; lecteur exécuté, contexte moteur statique. |

## Preuves et portée

- docs/reference_adoption_sources/decisions-v787.json : nouveau reçu, avec référence au précédent.
- docs/reference_adoption_sources/reader-refresh-v787.json : changement exact et empreintes.
- docs/fidelity_reference_contracts_v787.json : associations, sources, contrôles et limites.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision787_reference_runtime : observations, refus et journal des22tests.
- revision787_delivery : deltas ciblés, contrôles et relecture des deux bases du plan.

Modifications : deux modules Python, deux nouveaux reçus et deux archives de code, trois registres, ce rapport et sa preuve, documents de couverture/reprise et26fiches dans chacune des deux bases. Aucune copie complète de base ; cases, notes, historiques, identités et inconnues conservés. La base locale explicite ne signifie pas que la fonctionnalité du jeu est achevée.

## Suite

Continuer SYS-01.2-02 sur F. V787 corrige la lecture des décisions et explicite25contrats locaux ; les décisions de non-adoption restent bornées au livrable de traçabilité. Les7exigences sans native_inputs ni base locale explicite restantes concernent deux combats et cinq Battle Training : inspecter leurs sources, contrats et consommateurs réels avant toute conclusion. Poursuivre les associations partielles du recensement V784, dont les limites audio V783 et distribution V786. Utiliser REA pour les questions natives précises. Préserver les états, sources, preuves et inconnues.
