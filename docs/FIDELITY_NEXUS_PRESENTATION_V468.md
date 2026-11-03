# SYS-01.2-02 — Cycle et présentation des Nexus

Quatorze fiches sont enrichies : AI, ACCEPT, PRESENT, MODEL, TEXTURE, ANIM et AUDIO pour ChaosNexus et OrderNexus. Elles disposent de liens plus précis vers les sources et les consommateurs actuels, et de quatorze questions propres aux tâches. Aucun gameplay n’est déclaré accepté.

## Résultat concret

Le catalogue monde effectivement fusionné par `animation::Catalog` sélectionne `structures/native_intact_ordernexus.glb` et `structures/native_intact_chaosnexus.glb`. Les anciens chemins `order_nexus.glb` et `chaos_nexus.glb` encore présents dans les définitions monde ne sont pas les chemins sélectionnés par cette demande de modèle. Les variantes détruites utilisent le modèle partagé `native_destroyednexus.glb`.

Les fichiers natifs MeshSkin indiquent les noms de maillage, squelette, texture et l’échelle 1.0 des formes intactes. Ces valeurs correspondent aux fichiers identifiés dans le reçu d’export préservé et au catalogue actuel. Les identités des entrées et sorties sont revérifiées ; l’exporteur n’est pas réexécuté et l’ordre de recherche natif des ressources n’est pas supposé établi.

| Modèle courant | Texture native comparée | Résultat CPU |
|---|---|---|
| OrderNexus intact | Nexus_diff.dds | 1 024 × 1 024, tous les pixels RGBA identiques au PNG intégré |
| ChaosNexus intact | Chaos_Nexus_diff.dds | 1 024 × 1 024, tous les pixels RGBA identiques au PNG intégré |
| Nexus détruit partagé | Nexus_Destroyed_diff.dds | 512 × 512, tous les pixels RGBA identiques au PNG intégré |

La comparaison utilise Pillow pour décoder les DDS et les PNG intégrés. Elle prouve l’égalité des pixels décodés, sans prouver la conversion colorimétrique du rendu, les UV, les masques, les mélanges, les shaders ou les effets. Les trois GLB contiennent un matériau de base unlit et à double face ; les effets de cristal et de lueur utilisent des chemins distincts et partiels.

Les noms et indices de clips des trois modèles ont été comparés au catalogue. Les rôles et le catalogue des horloges de structure sont reliés aux consommateurs existants. La réception demande les modèles, le chargement crée leur scène, la cérémonie choisit le modèle intact/détruit à partir du résultat figé et l’animation conserve le rôle idle du Nexus terminal. Ce sont des chemins de code relus, pas des animations observées en jeu dans ce lot.

## Audio : portée explicite

Le prototype natif `FadeOutMainSFXPhase` a été reparsé et référence `FadeOutMainSFX` et `EOG_MAIN_SFX_FADE_DURATION`. Le lecteur actuel de calendrier conserve les délais du son de fin de partie. Cette fonction ne déclenche ni ne lit de son.

Les deux fiches AUDIO distinguent donc ce lecteur de données d’un consommateur audio complet. Le lien au chargeur générique Map10 est conservé historiquement, mais classé hors de la portée démontrée de l’audio. L’événement, les médias, les déclencheurs et leur lecture effective restent à qualifier. Les recherches bornées dans les fichiers audio inspectés ne prouvent pas une absence globale d’implémentation.

## Liens intégrés et contrôles

- 66 liens natifs et 62 liens vers des consommateurs actuels ajoutés, SYS inclus. Trois nouvelles ancres précises : changement de modèle depuis le résultat figé, sélection du rôle idle terminal, lecteur de délais audio explicitement limité.
- Le consommateur déjà associé aux descripteurs et à la topologie Idle des deux Nexus reste conservé avec ses limites antérieures.
- Trois comparaisons exactes de textures, vérification des noms/indices de clips, des identités d’assets et des champs MeshSkin.
- Cinq refus du collecteur : mauvais asset sélectionné, indice de clip invalide, en-tête GLB incorrect, GLB tronqué et pixel modifié.
- Quinze sélecteurs nominaux et seize refus de mauvais couples tâche/sélecteur.
- Comparaison des 42 214 textes de traçabilité : quatorze changés, 42 200 identiques. Sorties des autres tâches hors SYS préservées.
- Sept refus via les lecteurs publics : trois questions invalides et quatre essais de qualification de portée incohérente.
- Le programme de publication est vérifié avant écriture : les quatre registres sont bien associés aux quatre empreintes de référence. L’erreur V467 n’est pas reproduite ; ses scripts et preuves restent inchangés.
- Publication puis audit indépendant réussis : quinze fiches et textes copiables par base, quatorze questions propres vérifiées, intégrité SQLite correcte.
- 42 606 états/notes et 23 entrées d’historique exactement conservés dans chaque base ; 42 591 autres lignes de catalogue inchangées.

Les anciens enregistrements de sources, consommateurs et inconnues sont conservés. Le graphe compte 98 605 sources, 2 417 consommateurs, 25 339 inconnues ouvertes et 5 517 résolues. Ce lot ajoute quatorze questions jusque-là non recensées ; il n’en résout aucune et ne modifie ni les cases, ni les statuts, ni les critères d’acceptation.

## Limites et travail restant

Les fiches AI et ACCEPT demandent toujours la qualification du cycle ordinaire, des protections natives et de la fin de partie. MODEL demande encore la comparaison complète de géométrie, taille et poses. TEXTURE conserve les vérifications de matériaux et de rendu. ANIM conserve les vérifications de lecture, temps, boucles et événements. AUDIO conserve les liaisons jusqu’au son effectivement joué. PRESENT doit couvrir l’ensemble de ces aspects, pas uniquement le matériau de base ou les particules Idle.

Aucun fichier de gameplay ou d’asset n’est modifié. Aucun jeu, client AIR, runtime Lua, build Rust ou rendu GPU n’est exécuté. Le parseur Lua, le décodage d’images, les lectures de sources et les lecteurs Python du plan sont les contrôles réellement exécutés. Les tests et observations antérieurs cités dans certains consommateurs restent hérités, sans nouvelle exécution.

## Livrables et reprise

Les liens figurent dans les quatre registres `fidelity_sources_4_20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_unknowns_4_20.json` et `completion_tasks_2026-10-20.json`, et dans les deux bases existantes du plan. Le reçu est `docs/reference_nexus_sources/nexus-presentation-v468.json`, la preuve de publication `docs/fidelity_nexus_presentation_v468.json`. La couverture et la reprise sont actualisées avec sauvegardes de leurs versions précédentes.

Les preuves détaillées sont dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision468/`. L’inventaire compte 514 associations Map10 restant à examiner : WORLD 315, STRUCTURE 108, CAMP 63, MODE 27 et SYS 1. Les 24 associations déjà qualifiées partiellement et les deux liens audio écartés sont distingués. Ce décompte ne représente pas tout le travail restant sur le jeu.

Suite : examiner les fiches SOURCE des deux Nexus et la portée de leurs anciens liens V250, puis poursuivre les autres structures et camps. Vérifier les champs effectivement consommés et leurs autorités, sans transformer une donnée absente dans un INIBIN ou un test de composant en preuve de complétude. SYS-01.2-02 et le Goal restent ouverts.
