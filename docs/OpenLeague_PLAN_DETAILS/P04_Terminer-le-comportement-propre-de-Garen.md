# P04 — Terminer le comportement propre de Garen

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Garen dispose de son passif, Q, W, E, R et de leur présentation utilisable en partie.

**Condition de fin :** Chaque capacité fonctionne avec ses rangs, refus et effets dans le parcours ordinaire ; la recette croisée complète du kit se clôture en P11.

**Prérequis de phase :** P03.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P04-L0001 — Achever Garen comme kit de référence puis vérifier ses interactions avec les systèmes communs.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-06-001** — Consolider la fiche de fidélité du Garen 4.20 et ses écarts connus
- [ ] **OL-06-002** — Fermer les écarts restants du passif et des quatre sorts de Garen

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P04-L0002 — Garen — corps, modèle et présentation commune — partie 1/2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CH-Garen-IDENTITE** — Garen : Qualifier statistiques, croissance, rayons et ressource aux niveaux 1–18
- [ ] **CH-Garen-MODELE** — Garen : Valider modèle de base, rig, UV, textures et portraits — travail existant à terminer/qualifier
- [ ] **CH-Garen-ATTAQUE** — Garen : Terminer attaques normales, critique, portée, cadence, reset et annulation — travail existant à terminer/qualifier
- [ ] **CH-Garen-MOUVEMENT** — Garen : Qualifier mouvement, corps, navigation, poursuite et caméra — travail existant à terminer/qualifier
- [ ] **CH-Garen-TRANSITIONS** — Garen : Qualifier course, casts, rappel, mort, respawn, transformations et emotes
- [ ] **CH-Garen-VOIX** — Garen : Qualifier voix, variantes, annonces et langues requises

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

## P04-L0003 — Garen — PASSIF

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-PASSIF-SOURCE** — Garen PASSIF — Perseverance : Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions — travail existant à terminer/qualifier
- [ ] **CH-Garen-PASSIF-SIMULATION** — Garen PASSIF — Perseverance : Terminer la mécanique serveur, ses transitions et ses refus — travail existant à terminer/qualifier
- [ ] **CH-Garen-PASSIF-NETWORK** — Garen PASSIF — Perseverance : Relier état et événements autorisés aux clients — travail existant à terminer/qualifier
- [ ] **CH-Garen-PASSIF-PRESENTATION** — Garen PASSIF — Perseverance : Achever animation, effets, sons, icône et retour HUD — travail existant à terminer/qualifier
- [ ] **CH-Garen-PASSIF-ACCEPTANCE** — Garen PASSIF — Perseverance : Tester rangs, interruptions, interactions et comportement ordinaire comparé — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P04-L0004 — Garen — Q

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-Q-SOURCE** — Garen Q — Decisive Strike : Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions — travail existant à terminer/qualifier
- [ ] **CH-Garen-Q-SIMULATION** — Garen Q — Decisive Strike : Terminer la mécanique serveur, ses transitions et ses refus — travail existant à terminer/qualifier
- [ ] **CH-Garen-Q-NETWORK** — Garen Q — Decisive Strike : Relier état et événements autorisés aux clients — travail existant à terminer/qualifier
- [ ] **CH-Garen-Q-PRESENTATION** — Garen Q — Decisive Strike : Achever animation, effets, sons, icône et retour HUD — travail existant à terminer/qualifier
- [ ] **CH-Garen-Q-ACCEPTANCE** — Garen Q — Decisive Strike : Tester rangs, interruptions, interactions et comportement ordinaire comparé — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P04-L0005 — Garen — W

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-W-SOURCE** — Garen W — Courage : Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions — travail existant à terminer/qualifier
- [ ] **CH-Garen-W-SIMULATION** — Garen W — Courage : Terminer la mécanique serveur, ses transitions et ses refus — travail existant à terminer/qualifier
- [ ] **CH-Garen-W-NETWORK** — Garen W — Courage : Relier état et événements autorisés aux clients — travail existant à terminer/qualifier
- [ ] **CH-Garen-W-PRESENTATION** — Garen W — Courage : Achever animation, effets, sons, icône et retour HUD — travail existant à terminer/qualifier
- [ ] **CH-Garen-W-ACCEPTANCE** — Garen W — Courage : Tester rangs, interruptions, interactions et comportement ordinaire comparé — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P04-L0006 — Garen — E

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-E-SOURCE** — Garen E — Judgment : Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions — travail existant à terminer/qualifier
- [ ] **CH-Garen-E-SIMULATION** — Garen E — Judgment : Terminer la mécanique serveur, ses transitions et ses refus — travail existant à terminer/qualifier
- [ ] **CH-Garen-E-NETWORK** — Garen E — Judgment : Relier état et événements autorisés aux clients — travail existant à terminer/qualifier
- [ ] **CH-Garen-E-PRESENTATION** — Garen E — Judgment : Achever animation, effets, sons, icône et retour HUD — travail existant à terminer/qualifier
- [ ] **CH-Garen-E-ACCEPTANCE** — Garen E — Judgment : Tester rangs, interruptions, interactions et comportement ordinaire comparé — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P04-L0007 — Garen — R

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-R-SOURCE** — Garen R — Demacian Justice : Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions — travail existant à terminer/qualifier
- [ ] **CH-Garen-R-SIMULATION** — Garen R — Demacian Justice : Terminer la mécanique serveur, ses transitions et ses refus — travail existant à terminer/qualifier
- [ ] **CH-Garen-R-NETWORK** — Garen R — Demacian Justice : Relier état et événements autorisés aux clients — travail existant à terminer/qualifier
- [ ] **CH-Garen-R-PRESENTATION** — Garen R — Demacian Justice : Achever animation, effets, sons, icône et retour HUD — travail existant à terminer/qualifier
- [ ] **CH-Garen-R-ACCEPTANCE** — Garen R — Demacian Justice : Tester rangs, interruptions, interactions et comportement ordinaire comparé — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P04-L0008 — Garen — corps, modèle et présentation commune — partie 2/2

**Prérequis du lot :** P04-L0002.

- [ ] **CH-Garen-HUD** — Garen : Qualifier textes, raccourcis, ciblage et infobulles

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

