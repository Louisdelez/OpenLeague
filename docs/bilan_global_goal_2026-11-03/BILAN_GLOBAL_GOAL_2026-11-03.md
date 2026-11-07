# Bilan global du goal OpenLeague — SYS-01.2-02

Date : 3 novembre 2026. Consolidation en lecture seule du projet `F:/OpenLeague`.

## Résultat

**Le périmètre du référentiel est désormais rapproché sur 42 215 exigences, 24 domaines et 2 770 fiches. Le goal reste ouvert.** Le travail acquis est réel et les liens sont structurellement cohérents. La principale lacune de pilotage est l’absence d’un verdict de clôture d’audit, avec périmètre et sept critères examinés, pour chaque exigence. Le présent bilan fournit la matrice exhaustive pour effectuer cette réconciliation sans recommencer les recherches.

**Aucun pourcentage global d’audit terminé n’est certifié.** L’ancien chiffre de 40 % n’avait pas de décompte vérifiable et doit être abandonné. Les pourcentages ci-dessous ont des définitions étroites ; aucun ne représente le jeu terminé.

## 1. Ce qui est recensé et vérifié

| Mesure | Résultat | Sens et limite |
|---|---:|---|
| Exigences atomiques actives | 42 215 | Dénominateur du référentiel lu ; parents historiques et tâches retirées non ajoutés au total |
| Requises actuellement / conditionnelles | 24 727 / 17 488 | Les conditionnelles ne sont pas supprimées : leur classification reste à auditer |
| Identifiants tâches ↔ trace ↔ fiches | 42 215 / 42 215 | Rapprochement structurel, pas fidélité sémantique |
| Sources et ancres de consommateurs enregistrées | 100 405 / 5 759 | Les 100 405 empreintes natives ne sont pas revalidées ici |
| Ancres exactes fichier/ligne/texte retrouvées | 5 759 / 5 759 — 100 % | Présence exacte seulement ; pas preuve que chaque ancre réalise l’exigence |
| Chemins de preuve déclarés localisables | 1 527 / 1 527 — 100 % | Dont deux répertoires traités comme tels ; contenu des reçus non tous revalidé |
| Statut de trace « associated_sources_and_current_entrypoints » | 22 272 / 42 215 — 52,76 % | Catégorie enregistrée ; ce n’est pas une clôture d’audit |
| Inconnues enregistrées résolues | 5 517 / 31 706 — 17,40 % | Résolutions héritées, non rejouées ; une résolution n’est pas une fonctionnalité acceptée |
| Inconnues enregistrées ouvertes | 26 189 | Questions parfois communes ou anciennes ; pas 26 189 fonctionnalités manquantes distinctes |
| Rapports primaires indexés / revues | 793 / 16 | 168 fichiers AUDIT_ et 625 fichiers FIDELITY_/REFERENCE_, plus 16 REVIEW_ |
| Rapport AUDIT_ mentionnant explicitement une tâche | 303 exigences distinctes | Correspondance textuelle pour orienter la relecture, pas couverture sémantique prouvée |
| Rapports AUDIT_ sans ID de tâche explicite reconnu | 32 | Rattachement à clarifier ; ils ne sont pas présumés inutiles ni non terminés |
| Métadonnées du jeu : implémentation / acceptation complètes | 10 / 0 | États hérités du registre du jeu ; ne mesurent pas l’audit, ni l’ensemble du code présent |

Les 168 rapports AUDIT_ ne sont pas enregistrés comme sources dans le registre figé. Cela concorde avec la restriction interdisant sa modification ; ce n’est ni une perte de preuve ni une autorisation de réécrire le registre. Le bilan les rapproche séparément.

## 2. Ce qui reste pour clôturer le goal

Les trois files suivantes sont exclusives et totalisent exactement 42 215 lignes. Elles constituent un tri documentaire, pas un nouveau statut du Plan.

| File de consolidation | Toutes exigences | Requises maintenant | Travail précis |
|---|---:|---:|---|
| Rapport AUDIT_ avec mention explicite à relire | 303 | 238 | Vérifier le périmètre réellement clos et les sept critères ; ne pas fermer automatiquement le parent |
| Liaison source ou consommateur à préciser | 5 343 | 1 310 | Relire les preuves existantes ; distinguer source native, contrat local, entrée générique, refus et absence qualifiée |
| Liaison documentée à consolider sémantiquement | 36 569 | 23 179 | Utiliser les rapports partagés et vérifier l’application exacte de la preuve à chaque exigence |

Une ligne sans mention dans un fichier AUDIT_ ne signifie pas « jamais auditée » : 625 rapports de sources/référence et des reçus structurés existent. 1 152 exigences sont aussi mentionnées explicitement dans ces rapports de référence ou de revue. Les preuves partagées ne doivent être ni ignorées ni propagées automatiquement à toute une famille.

## 3. Où se concentrent les inconnues

| Famille enregistrée | Questions ouvertes | Reprise utile |
|---|---:|---|
| Sélection/dispatch des skins non-base | 8 736 | Qualifier le mécanisme commun et ses variations ; préserver les identités individuelles |
| Entrées natives précises | 5 377 | Identifier le champ/contrat requis ; la présence d’un fichier natif ne suffit pas |
| Liaison de présentation | 2 440 | Relier ressource et événement au consommateur précis |
| Cartes et modes | 1 924 | Distinguer disponibilité historique, ressources présentes et admission effective |
| Runes et maîtrises | 1 822 | Séparer données/tooltip et effet consommé à l’exécution |
| Passifs | 1 220 | Traiter chaque passif et ses déclencheurs ; réutiliser les recherches natives déjà faites |
| Admission des unités dans le monde | 1 216 | Relier source, création et cycle de vie au mode concerné |
| Ancres natives/runtime spécifiques | 786 | Relire la preuve existante et nommer la frontière exacte non qualifiée |
| Autres familles | 2 668 | Conditions détaillées dans inconnues.csv |

Ces huit premières familles totalisent 23 521 questions, soit 89,81 % des questions ouvertes enregistrées. Cela indique un potentiel de réutilisation de mécanismes communs, pas un droit de clore en bloc. Toutes les questions ouvertes possèdent une condition de reprise textuelle ; leur pertinence et leur actualité restent à relire.

## 4. Bilan par domaine

« Cons. lié » compte au moins une entrée hors copie du Plan, hors exclusion déclarée et non marquée simple frontière. Cela reste une liaison de registre, jamais une preuve d’implémentation complète. « Mentions audit » compte les exigences citées exactement dans les fichiers AUDIT_.

| Domaine | Exigences | Requises | Conditionnelles | Source native liée | Cons. lié | Mentions audit | Questions ouvertes |
|---|---:|---:|---:|---:|---:|---:|---:|
| D01 — Référentiel complet de LoL 4.20 | 28 | 28 | 0 | 18 | 16 | 3 | 1 171 |
| D02 — Récupération et réparation des ressources | 172 | 105 | 67 | 172 | 92 | 3 | 164 |
| D03 — Moteur Rust et outils de développement | 55 | 55 | 0 | 4 | 45 | 1 | 55 |
| D04 — Combat, statistiques et contrôles | 76 | 76 | 0 | 67 | 59 | 0 | 76 |
| D05 — Progression des compétences et ressources | 31 | 31 | 0 | 24 | 23 | 4 | 31 |
| D06 — Les 122 champions, un par un | 20 400 | 20 400 | 0 | 20 400 | 20 400 | 22 | 4 022 |
| D07 — Objets et boutique | 3 784 | 556 | 3 228 | 3 784 | 3 775 | 243 | 33 |
| D08 — Runes, maîtrises et sorts invocateur | 2 001 | 389 | 1 612 | 2 001 | 512 | 17 | 1 941 |
| D09 — Déplacement, collisions et navigation | 27 | 27 | 0 | 27 | 22 | 0 | 27 |
| D10 — Carte 3v3 : Forêt torturée | 967 | 967 | 0 | 965 | 936 | 0 | 508 |
| D11 — Autres cartes et modes de la version | 1 949 | 395 | 1 554 | 1 944 | 6 | 0 | 1 977 |
| D12 — Sbires, monstres, invocations et IA | 1 441 | 529 | 912 | 1 441 | 206 | 0 | 1 441 |
| D13 — Vision, brouillard et furtivité | 28 | 28 | 0 | 11 | 18 | 1 | 28 |
| D14 — Skins, modèles, formes et animations | 10 727 | 707 | 10 020 | 10 707 | 10 717 | 4 | 14 248 |
| D15 — Effets visuels et rendu | 66 | 66 | 0 | 35 | 58 | 0 | 34 |
| D16 — Audio, voix et annonces | 58 | 58 | 0 | 30 | 43 | 0 | 28 |
| D17 — Interface de partie complète | 40 | 40 | 0 | 1 | 21 | 0 | 40 |
| D18 — Launcher historique en Rust/Tauri | 54 | 54 | 0 | 36 | 15 | 0 | 54 |
| D19 — Services de compte et de session | 38 | 38 | 0 | 38 | 1 | 0 | 38 |
| D20 — Réseau et autorité serveur | 37 | 37 | 0 | 0 | 29 | 2 | 37 |
| D21 — Spectateur, enregistrements et outils de partie | 21 | 21 | 0 | 4 | 6 | 0 | 21 |
| D22 — Localisation, options et compatibilité | 141 | 46 | 95 | 124 | 48 | 3 | 141 |
| D23 — Qualification intégrale et performance | 40 | 40 | 0 | 0 | 3 | 0 | 40 |
| D24 — Installation, livraison et clôture | 34 | 34 | 0 | 0 | 32 | 0 | 34 |

Le total des questions d’un domaine peut dépasser son nombre d’exigences. Certains contrôles de livraison, réseau ou politiques locales n’ont pas d’équivalent natif client : une source native absente dans le registre n’est donc pas automatiquement un asset manquant.

## 5. Acquis et limites relus directement

Les sept rapports suivants ont été relus pour contrôler l’interprétation des statuts. Cette relecture ne rejoue pas leurs tests et ne certifie pas tous les autres rapports.

| Rapport / périmètre | Conclusion conservée |
|---|---|
| [Structure du registre et présence des ancres](../AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md) | Audit borné clos ; pertinence sémantique et corpus natif non entièrement vérifiés. |
| [Frontière consommateur du passif Yasuo](../AUDIT_SYS01202_YASUO_PASSIVE_CURRENT_CONSUMER_2026-11-02.md) | Sous-audit statique clos ; source serveur et fonctionnalité du passif restent ouvertes. |
| [Champ natif et bonus de vitesse de l’objet 1001](../AUDIT_SYS01202_ITEM1001_MOVEMENT_SPEED_2026-11-02.md) | Liaison et test local acquis ; ni objet complet ni parcours réseau/rendu acceptés. |
| [Cycle pair/cache shader avant bind](../AUDIT_SYS01202_MAP10_SHADER_PAIR_LIFECYCLE_PREBIND_2026-11-03.md) | PASS borné avec adapters ; activation, draw, frame et runtime 2014 exclus. |
| [Comptes et stockage, rapport historique V132](../FIDELITY_ACCOUNT_STORAGE_LINKS_4_20.md) | Les frontières de session/Plan ne prouvent pas des comptes persistants ; ne pas refaire cet audit comme s’il n’existait pas. Actualisation sémantique à vérifier avant usage courant. |
| [Six parcours de partie, rapport historique V152](../FIDELITY_MATCH_JOURNEYS_LINKS_4_20.md) | Tests CPU limités et parcours ordinaires non exécutés dans ce reçu ; aucune acceptation intégrale. Résultat historique non réexécuté. |
| [Comparaisons visuelles, rapport historique V116](../FIDELITY_VISUAL_COMPARISON_LINKS_4_20.md) | A/B d’un effet reconstruit ne démontre pas LoL contre OpenLeague ; reçu historique et limites conservés. |

## 6. Branche en cours : terrain Map10

Le dernier point relu est V1158, pair/cache shader avant bind. Les DDS et leur transfert ont des preuves antérieures ; les shaders FOUR_BLEND sont co-résidents sur un même device actuel. Le lot pair/cache s’arrête avant le binder. La reprise nommée porte sur l’activation VS puis PS, l’échec éventuel du second Set et un rollback de harness distinct du comportement Riot. Draw, Present, pixels de frame, runtime 2014 et certains chemins originaux restent hors preuve. Cette investigation est une branche d’audit de ressources/rendu ; sa fin ne clôt pas tous les domaines du goal.

Pour le bilan global, aucune nouvelle exécution D3D n’était nécessaire. Les reçus existants sont réutilisés. Le blocage sur le pilote privé et les frontières historiques ne doivent pas devenir des prérequis implicites pour chaque autre audit.

## 7. Ordre de consolidation proposé

- [ ] **BIL-01 — Relire les 303 lignes déjà reliées à un rapport AUDIT_.** Entrée : relecture_clotures.csv. Fin : périmètre couvert et sept critères examinés, conclusion explicite sur chaque clause ; parent laissé ouvert si nécessaire. Aucun nouveau test sans écart identifié.
- [ ] **BIL-02 — Rattacher les 32 rapports sans ID exact reconnu.** Entrée : rapports_sans_tache_explicite.csv. Fin : une relation explicite au bon ID existant, ou justification de sa nature transversale/hors exigence ; ne pas inventer de tâche.
- [ ] **BIL-03 — Traiter les 5 343 liaisons à préciser.** Commencer par les 1 310 requises maintenant. Fin par ligne : consommateur réel, absence démontrée dans un périmètre borné, ou manque et condition de reprise ; distinguer contrats locaux et ressources historiques.
- [ ] **BIL-04 — Consolider les 36 569 liaisons restantes avec les preuves partagées.** Entrées : lots.csv, rapports.csv et les reçus déjà référencés. Fin : matrice montrant exactement quelles clauses de chaque exigence sont couvertes ; exceptions individuelles visibles. Ne pas repartir d’un audit vide pour chaque ligne.
- [ ] **BIL-05 — Vérifier les 17 488 conditions de périmètre.** Ce lot recoupe les précédents et ne s’ajoute pas au dénominateur. Fin : inclusion/exclusion justifiée sur preuve ou question explicitement ouverte, sans modifier silencieusement le périmètre du jeu.
- [ ] **BIL-06 — Réconcilier les 26 189 inconnues avec les preuves ultérieures.** Ce lot recoupe les précédents. Fin : chaque question conserve son historique, une conclusion actuelle ou un manque précis ; aucune recherche inchangée n’est répétée.
- [ ] **BIL-07 — Fermer le bilan d’audit global.** Fin : toutes les exigences requises ont une décision d’audit justifiée, les conditionnelles sont traitées explicitement, les sept critères sont contrôlés et les corrections fonctionnelles restent séparées. Une entrée réellement indispensable absente conserve un blocage ; ne pas convertir un blocage en réussite.

Ces propositions sont contenues dans ce document séparé. Elles ne créent ni goal, ni ligne de Plan, ni migration. La recette complète du jeu et son acceptation ne sont pas des critères que ce bilan prétend avoir remplis.

## 8. Mesure et règles de clôture

Le taux futur utilisable sera : exigences du périmètre d’audit dont toutes les clauses ont un verdict relu / exigences du même périmètre. Publier séparément le taux sur les 24 727 requises et le traitement des 17 488 conditionnelles ; ne pas retirer les conditionnelles non classifiées pour améliorer le chiffre. Les 2 770 regroupements, parents historiques, rapports et tests ne sont pas additionnés aux 42 215 exigences. Aucun taux n’est calculé depuis les seuls mots « clos », les cases manuelles ou le nombre V1158.

Pour chaque unité : périmètre, sources/provenance ou manque, consommateur ou recherche d’absence bornée, attendu/observé et contrôles, écarts, correction existante/proposée et critères, livrable et relecture. Garder audit, implémentation, vérification et acceptation humaine indépendants.

## 9. Livrables et contrôles réellement effectués

- [exigences.csv](exigences.csv) : 42 215 lignes, une par exigence, avec liens, questions et file de consolidation.
- [lots.csv](lots.csv) : 2 770 fiches pour organiser la reprise sans recompter leurs enfants.
- [inconnues.csv](inconnues.csv) : 31 706 questions, dont 26 189 ouvertes, avec leurs conditions de reprise.
- [ancres_consommateurs.csv](ancres_consommateurs.csv) : 5 759 résultats fichier/ligne/texte.
- [domaines.csv](domaines.csv) : 24 domaines et compteurs détaillés.
- [rapports.csv](rapports.csv) et [rapports_indexes.json](rapports_indexes.json) : 809 rapports/revues indexés par contenu et mentions.
- [relecture_clotures.csv](relecture_clotures.csv) : les 303 exigences à commencer par réconcilier avec leurs rapports dédiés.
- [rapports_sans_tache_explicite.csv](rapports_sans_tache_explicite.csv) : les 32 rapports à rattacher.
- [synthese.json](synthese.json) : règles, résultats, empreintes des six entrées et contrôles de stabilité.

- [VALIDATION_BILAN.json](VALIDATION_BILAN.json) : validation indépendante des livrables, 21 contrôles structurels réussis sur 21.
- [MANIFESTE_SHA256.json](MANIFESTE_SHA256.json) : tailles et empreintes des fichiers livrés.

Contrôles : lecture Python 3.12 du venv existant, unicité et égalité des ensembles d’IDs, rattachement aux fiches, sommes par domaine, intégrité des références source/consumer/unknown, existence des preuves déclarées, examen mécanique des ancres et index des rapports. Aucun lien cassé n’est détecté dans ces relations. Les six fichiers sources de registre ont conservé taille et date pendant la consolidation ; leurs octets ont été hachés à la lecture. Aucun corpus natif complet n’a été re-haché ; aucun test produit, build, runtime ou nouvelle recherche web n’a été lancé.

Une erreur de première passe a traité deux répertoires de preuve comme des fichiers absents. Leur nature de répertoire et leur présence ont été vérifiées ; le bilan final compte 1 527 références présentes et zéro manquante. Certains libellés de domaine de coverage.json présentent un encodage hérité dégradé ; les noms lisibles du présent bilan sont des libellés de présentation, les IDs et fichiers d’origine sont conservés.

**Limite centrale : cette consolidation est exhaustive pour les lignes des registres lus, pas une certification sémantique exhaustive du jeu ni une relecture intégrale des sept critères de tous les audits.** Les associations automatiques de rapports servent de file de travail, pas de verdict de clôture. Les reçus externes et les résultats historiques restent hérités tant qu’ils ne sont pas vérifiés pour leur portée exacte.

Aucun fichier produit, Goal, Plan, registre de tâches ou base de données n’a été modifié. Les seules écritures concernent les nouveaux livrables de ce bilan.
