# P05 — Terminer les systèmes de la Forêt torturée

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Le terrain restauré et tous les éléments de Map10 suivent leurs règles de jeu.

**Condition de fin :** Secteurs, matériaux, structures, vagues, camps, Vilemaw, autels, relique et chronologie sont vérifiés ; la partie complète se clôture en P06.

**Prérequis de phase :** P03.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P05-L0001 — Achever les textures, UV, mélanges du sol, transparences et matériaux à partir de la scène Blender restaurée.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-10-001** — Tracer la scène Blender et le GLB réellement chargés
- [ ] **OL-10-002** — Contrôler chaque matériau, UV, alpha et texture de la carte restaurée
- [ ] **OL-10-003** — Qualifier mélanges du sol, ombres et transparences sur Vulkan et DX12

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0002 — Vérifier chaque zone et chaque élément de décor dans Blender puis dans le moteur.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-10-004** — Découper la carte en secteurs de comparaison fixes
- [ ] **OL-10-005** — Comparer chaque secteur dans Blender, jeu et référence historique
- [ ] **OL-10-006** — Corriger puis recapturer tout élément manquant, flottant ou mal orienté

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0003 — Achever bâtiments, protections, destruction, débris, réapparition et victoire.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-10-007** — Qualifier les 18 structures et leurs dépendances
- [ ] **OL-10-008** — Qualifier ciblage des tours, dégâts, protections et débris
- [ ] **OL-10-009** — Qualifier inhibiteurs, super-sbires et réapparition
- [ ] **OL-10-010** — Qualifier Nexus détruit, arrêt de simulation et écran de résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0004 — Achever autels, reliques, camps, Vilemaw, chronologie et bonus.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-10-011** — Qualifier capture, contestation, verrouillage et bonus des autels
- [ ] **OL-10-012** — Qualifier relique : spawn, pickup, ressources, vitesse et respawn
- [ ] **OL-10-013** — Qualifier six camps ordinaires et leurs récompenses
- [ ] **OL-10-014** — Terminer le kit spécial et le buff de Vilemaw
- [ ] **OL-10-015** — Fixer et vérifier Vilemaw avec l’arrière vers le bas de la carte

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0005 — Vérifier sbires, super-sbires, économie, expérience, vision, animations et audio.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-10-016** — Qualifier vagues, trajectoires et formations des sbires
- [ ] **OL-10-017** — Qualifier économie, partage d’XP et montée en puissance dans la durée
- [ ] **OL-10-018** — Qualifier vision, buissons, annonces, animations et audio de tous les objectifs

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0006 — Contrôle explicite de la scène restaurée Blender et de ses empreintes ; aucune ancienne texture corrompue ne doit remplacer silencieusement la restauration.

**Prérequis du lot :** P05-L0001.

- [ ] **EX-10-01** — Contrôle explicite de la scène restaurée Blender et de ses empreintes ; aucune ancienne texture corrompue ne doit remplacer silencieusement la restauration.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0007 — Qualifier les coefficients encore reconstruits : autels, relique, fontaine, statistiques des structures et mécaniques de Vilemaw.

**Prérequis du lot :** P05-L0001.

- [ ] **EX-10-02** — Qualifier les coefficients encore reconstruits : autels, relique, fontaine, statistiques des structures et mécaniques de Vilemaw.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0008 — Contrôler orientation de Vilemaw, animation et zone d’attaque dans une vue de carte fixée.

**Prérequis du lot :** P05-L0001.

- [ ] **EX-10-03** — Contrôler orientation de Vilemaw, animation et zone d’attaque dans une vue de carte fixée.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0009 — Porter tous les types de sbires, vagues, améliorations, trajets, priorités et récompenses.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-12-001** — Qualifier les huit variantes de sbires bleus et rouges
- [ ] **OL-12-002** — Qualifier vagues, améliorations et super-sbires
- [ ] **OL-12-003** — Qualifier acquisition, priorité, attaques et projectiles des sbires

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0010 — Porter tous les monstres : acquisition, aggro, retour, patience, attaques et réapparition.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-12-004** — Qualifier acquisition et changement de cible de chaque monstre
- [ ] **OL-12-005** — Qualifier retour, patience, reset de vie et perte d’aggro
- [ ] **OL-12-006** — Qualifier attaques spéciales, niveaux, récompenses et respawn

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0011 — Porter IA des bâtiments, familiers, invocations et unités contrôlables.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-12-007** — Qualifier priorités de tours et attaques contre champions

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P05-L0012 — Map10 — définition Blue_Minion_Basic

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Blue_Minion_Basic-SOURCE** — Blue_Minion_Basic (Melee) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Basic-AI** — Blue_Minion_Basic (Melee) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Basic-PRESENT** — Blue_Minion_Basic (Melee) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Basic-ACCEPT** — Blue_Minion_Basic (Melee) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0013 — Map10 — définition Blue_Minion_MechCannon

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Blue_Minion_MechCannon-SOURCE** — Blue_Minion_MechCannon (Siege) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechCannon-AI** — Blue_Minion_MechCannon (Siege) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechCannon-PRESENT** — Blue_Minion_MechCannon (Siege) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechCannon-ACCEPT** — Blue_Minion_MechCannon (Siege) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0014 — Map10 — définition Blue_Minion_MechMelee

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Blue_Minion_MechMelee-SOURCE** — Blue_Minion_MechMelee (Super) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechMelee-AI** — Blue_Minion_MechMelee (Super) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechMelee-PRESENT** — Blue_Minion_MechMelee (Super) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_MechMelee-ACCEPT** — Blue_Minion_MechMelee (Super) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0015 — Map10 — définition Blue_Minion_Wizard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Blue_Minion_Wizard-SOURCE** — Blue_Minion_Wizard (Caster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Wizard-AI** — Blue_Minion_Wizard (Caster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Wizard-PRESENT** — Blue_Minion_Wizard (Caster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Blue_Minion_Wizard-ACCEPT** — Blue_Minion_Wizard (Caster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0016 — Map10 — définition ChaosNexus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-ChaosNexus-SOURCE** — ChaosNexus (Nexus) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-ChaosNexus-AI** — ChaosNexus (Nexus) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-ChaosNexus-PRESENT** — ChaosNexus (Nexus) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-ChaosNexus-ACCEPT** — ChaosNexus (Nexus) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0017 — Map10 — définition OrderNexus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-OrderNexus-SOURCE** — OrderNexus (Nexus) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-OrderNexus-AI** — OrderNexus (Nexus) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-OrderNexus-PRESENT** — OrderNexus (Nexus) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-OrderNexus-ACCEPT** — OrderNexus (Nexus) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0018 — Map10 — définition Red_Minion_Basic

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Red_Minion_Basic-SOURCE** — Red_Minion_Basic (Melee) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Basic-AI** — Red_Minion_Basic (Melee) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Basic-PRESENT** — Red_Minion_Basic (Melee) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Basic-ACCEPT** — Red_Minion_Basic (Melee) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0019 — Map10 — définition Red_Minion_MechCannon

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Red_Minion_MechCannon-SOURCE** — Red_Minion_MechCannon (Siege) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechCannon-AI** — Red_Minion_MechCannon (Siege) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechCannon-PRESENT** — Red_Minion_MechCannon (Siege) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechCannon-ACCEPT** — Red_Minion_MechCannon (Siege) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0020 — Map10 — définition Red_Minion_MechMelee

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Red_Minion_MechMelee-SOURCE** — Red_Minion_MechMelee (Super) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechMelee-AI** — Red_Minion_MechMelee (Super) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechMelee-PRESENT** — Red_Minion_MechMelee (Super) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_MechMelee-ACCEPT** — Red_Minion_MechMelee (Super) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0021 — Map10 — définition Red_Minion_Wizard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-Red_Minion_Wizard-SOURCE** — Red_Minion_Wizard (Caster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Wizard-AI** — Red_Minion_Wizard (Caster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Wizard-PRESENT** — Red_Minion_Wizard (Caster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-Red_Minion_Wizard-ACCEPT** — Red_Minion_Wizard (Caster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0022 — Map10 — définition TT_ChaosInhibitor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_ChaosInhibitor-SOURCE** — TT_ChaosInhibitor (Inhibitor) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosInhibitor-AI** — TT_ChaosInhibitor (Inhibitor) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosInhibitor-PRESENT** — TT_ChaosInhibitor (Inhibitor) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosInhibitor-ACCEPT** — TT_ChaosInhibitor (Inhibitor) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0023 — Map10 — définition TT_ChaosTurret1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_ChaosTurret1-SOURCE** — TT_ChaosTurret1 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret1-AI** — TT_ChaosTurret1 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret1-PRESENT** — TT_ChaosTurret1 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret1-ACCEPT** — TT_ChaosTurret1 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0024 — Map10 — définition TT_ChaosTurret2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_ChaosTurret2-SOURCE** — TT_ChaosTurret2 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret2-AI** — TT_ChaosTurret2 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret2-PRESENT** — TT_ChaosTurret2 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret2-ACCEPT** — TT_ChaosTurret2 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0025 — Map10 — définition TT_ChaosTurret3

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_ChaosTurret3-SOURCE** — TT_ChaosTurret3 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret3-AI** — TT_ChaosTurret3 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret3-PRESENT** — TT_ChaosTurret3 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret3-ACCEPT** — TT_ChaosTurret3 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0026 — Map10 — définition TT_ChaosTurret4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_ChaosTurret4-SOURCE** — TT_ChaosTurret4 (Fountain) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret4-AI** — TT_ChaosTurret4 (Fountain) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret4-PRESENT** — TT_ChaosTurret4 (Fountain) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_ChaosTurret4-ACCEPT** — TT_ChaosTurret4 (Fountain) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0027 — Map10 — définition TT_NGolem

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NGolem-SOURCE** — TT_NGolem (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem-AI** — TT_NGolem (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem-PRESENT** — TT_NGolem (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem-ACCEPT** — TT_NGolem (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0028 — Map10 — définition TT_NGolem2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NGolem2-SOURCE** — TT_NGolem2 (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem2-AI** — TT_NGolem2 (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem2-PRESENT** — TT_NGolem2 (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NGolem2-ACCEPT** — TT_NGolem2 (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0029 — Map10 — définition TT_NWolf

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NWolf-SOURCE** — TT_NWolf (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf-AI** — TT_NWolf (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf-PRESENT** — TT_NWolf (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf-ACCEPT** — TT_NWolf (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0030 — Map10 — définition TT_NWolf2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NWolf2-SOURCE** — TT_NWolf2 (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf2-AI** — TT_NWolf2 (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf2-PRESENT** — TT_NWolf2 (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWolf2-ACCEPT** — TT_NWolf2 (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0031 — Map10 — définition TT_NWraith

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NWraith-SOURCE** — TT_NWraith (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith-AI** — TT_NWraith (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith-PRESENT** — TT_NWraith (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith-ACCEPT** — TT_NWraith (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0032 — Map10 — définition TT_NWraith2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_NWraith2-SOURCE** — TT_NWraith2 (Monster) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith2-AI** — TT_NWraith2 (Monster) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith2-PRESENT** — TT_NWraith2 (Monster) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_NWraith2-ACCEPT** — TT_NWraith2 (Monster) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0033 — Map10 — définition TT_OrderInhibitor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_OrderInhibitor-SOURCE** — TT_OrderInhibitor (Inhibitor) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderInhibitor-AI** — TT_OrderInhibitor (Inhibitor) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderInhibitor-PRESENT** — TT_OrderInhibitor (Inhibitor) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderInhibitor-ACCEPT** — TT_OrderInhibitor (Inhibitor) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0034 — Map10 — définition TT_OrderTurret1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_OrderTurret1-SOURCE** — TT_OrderTurret1 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret1-AI** — TT_OrderTurret1 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret1-PRESENT** — TT_OrderTurret1 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret1-ACCEPT** — TT_OrderTurret1 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0035 — Map10 — définition TT_OrderTurret2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_OrderTurret2-SOURCE** — TT_OrderTurret2 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret2-AI** — TT_OrderTurret2 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret2-PRESENT** — TT_OrderTurret2 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret2-ACCEPT** — TT_OrderTurret2 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0036 — Map10 — définition TT_OrderTurret3

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_OrderTurret3-SOURCE** — TT_OrderTurret3 (Turret) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret3-AI** — TT_OrderTurret3 (Turret) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret3-PRESENT** — TT_OrderTurret3 (Turret) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret3-ACCEPT** — TT_OrderTurret3 (Turret) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0037 — Map10 — définition TT_OrderTurret4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_OrderTurret4-SOURCE** — TT_OrderTurret4 (Fountain) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret4-AI** — TT_OrderTurret4 (Fountain) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret4-PRESENT** — TT_OrderTurret4 (Fountain) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_OrderTurret4-ACCEPT** — TT_OrderTurret4 (Fountain) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0038 — Map10 — définition TT_Spiderboss

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **WORLD-TT_Spiderboss-SOURCE** — TT_Spiderboss (Boss) : Qualifier stats, rayon, niveau, timers et récompenses — travail existant à terminer/qualifier
- [ ] **WORLD-TT_Spiderboss-AI** — TT_Spiderboss (Boss) : Terminer acquisition, priorité, attaque, retour/reset et interactions — travail existant à terminer/qualifier
- [ ] **WORLD-TT_Spiderboss-PRESENT** — TT_Spiderboss (Boss) : Qualifier modèle, matériaux, animation, projectiles et audio — travail existant à terminer/qualifier
- [ ] **WORLD-TT_Spiderboss-ACCEPT** — TT_Spiderboss (Boss) : Valider cycle naissance → combat → mort → respawn/fin selon le type — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0039 — Map10 — structure Barracks_T1_L1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-00-POSITION** — Barracks_T1_L1 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-00-CYCLE** — Barracks_T1_L1 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0040 — Map10 — structure Barracks_T1_R1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-01-POSITION** — Barracks_T1_R1 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-01-CYCLE** — Barracks_T1_R1 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0041 — Map10 — structure Barracks_T2_L1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-02-POSITION** — Barracks_T2_L1 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-02-CYCLE** — Barracks_T2_L1 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0042 — Map10 — structure Barracks_T2_R1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-03-POSITION** — Barracks_T2_R1 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-03-CYCLE** — Barracks_T2_R1 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0043 — Map10 — structure HQ_T1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-04-POSITION** — HQ_T1 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-04-CYCLE** — HQ_T1 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0044 — Map10 — structure HQ_T2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-05-POSITION** — HQ_T2 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-05-CYCLE** — HQ_T2 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0045 — Map10 — structure Turret_ChaosTurretShrine

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-06-POSITION** — Turret_ChaosTurretShrine : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-06-CYCLE** — Turret_ChaosTurretShrine : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0046 — Map10 — structure Turret_OrderTurretShrine

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-07-POSITION** — Turret_OrderTurretShrine : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-07-CYCLE** — Turret_OrderTurretShrine : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0047 — Map10 — structure Turret_T1_C_01

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-08-POSITION** — Turret_T1_C_01 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-08-CYCLE** — Turret_T1_C_01 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0048 — Map10 — structure Turret_T1_C_06

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-09-POSITION** — Turret_T1_C_06 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-09-CYCLE** — Turret_T1_C_06 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0049 — Map10 — structure Turret_T1_C_07

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-10-POSITION** — Turret_T1_C_07 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-10-CYCLE** — Turret_T1_C_07 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0050 — Map10 — structure Turret_T1_L_02

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-11-POSITION** — Turret_T1_L_02 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-11-CYCLE** — Turret_T1_L_02 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0051 — Map10 — structure Turret_T1_R_02

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-12-POSITION** — Turret_T1_R_02 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-12-CYCLE** — Turret_T1_R_02 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0052 — Map10 — structure Turret_T2_C_01

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-13-POSITION** — Turret_T2_C_01 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-13-CYCLE** — Turret_T2_C_01 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0053 — Map10 — structure Turret_T2_L_01

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-14-POSITION** — Turret_T2_L_01 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-14-CYCLE** — Turret_T2_L_01 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0054 — Map10 — structure Turret_T2_L_02

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-15-POSITION** — Turret_T2_L_02 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-15-CYCLE** — Turret_T2_L_02 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0055 — Map10 — structure Turret_T2_R_01

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-16-POSITION** — Turret_T2_R_01 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-16-CYCLE** — Turret_T2_R_01 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0056 — Map10 — structure Turret_T2_R_02

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **STRUCTURE-17-POSITION** — Turret_T2_R_02 : qualifier équipe, position, hauteur, orientation, dépendances et ciblage — travail existant à terminer/qualifier
- [ ] **STRUCTURE-17-CYCLE** — Turret_T2_R_02 : qualifier protection, dégâts, destruction, débris et conséquences de partie — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0057 — Map10 — camp 1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-00-SOURCE** — Camp Map10 1 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-00-AI** — Camp Map10 1 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-00-REWARD** — Camp Map10 1 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-00-ACCEPT** — Camp Map10 1 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0058 — Map10 — camp 2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-01-SOURCE** — Camp Map10 2 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-01-AI** — Camp Map10 2 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-01-REWARD** — Camp Map10 2 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-01-ACCEPT** — Camp Map10 2 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0059 — Map10 — camp 3

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-02-SOURCE** — Camp Map10 3 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-02-AI** — Camp Map10 3 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-02-REWARD** — Camp Map10 3 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-02-ACCEPT** — Camp Map10 3 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0060 — Map10 — camp 4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-03-SOURCE** — Camp Map10 4 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-03-AI** — Camp Map10 4 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-03-REWARD** — Camp Map10 4 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-03-ACCEPT** — Camp Map10 4 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0061 — Map10 — camp 5

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-04-SOURCE** — Camp Map10 5 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-04-AI** — Camp Map10 5 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-04-REWARD** — Camp Map10 5 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-04-ACCEPT** — Camp Map10 5 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0062 — Map10 — camp 6

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-05-SOURCE** — Camp Map10 6 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-05-AI** — Camp Map10 6 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-05-REWARD** — Camp Map10 6 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-05-ACCEPT** — Camp Map10 6 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P05-L0063 — Map10 — camp 8

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **CAMP-06-SOURCE** — Camp Map10 8 : Qualifier composition, points, premier spawn et respawn — travail existant à terminer/qualifier
- [ ] **CAMP-06-AI** — Camp Map10 8 : Qualifier aggro, poursuite, retour, attaques et reset — travail existant à terminer/qualifier
- [ ] **CAMP-06-REWARD** — Camp Map10 8 : Qualifier récompenses, bonus et attribution de la mort — travail existant à terminer/qualifier
- [ ] **CAMP-06-ACCEPT** — Camp Map10 8 : Observer le cycle complet avec les deux équipes — travail existant à terminer/qualifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

