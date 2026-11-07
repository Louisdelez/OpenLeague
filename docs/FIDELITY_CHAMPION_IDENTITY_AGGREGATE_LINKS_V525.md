# SYS-01.2-02 — Identité, statistiques, ressources et rayons, V525

25 octobre2026 — Projet F:\OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue officiel4.20.1 distinct. Date littérale du build2014-11-17 à17:46:45 ; fuseau et déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-IDENTITE** sont reliées aux lecteurs précis de leurs20 champs statistiques, aux rayons mentionnés dans leur titre et au calcul local de croissance des niveaux1–18. Les **2 440 sous-tâches statistiques** et les **122 fiches de rayons existantes** sont conservées exactement. La référence aux rayons n’est pas transformée silencieusement en nouvelle dépendance : les20 dépendances du plan restent inchangées.

2 669 liens sont ajoutés :22 pour les107 profils dont la régénération de ressource est applicable selon le code courant,21 pour les15 autres.21 consommateurs existants sont réutilisés et un point précis est ajouté à progression.rs:48, le polynôme local précédé du clamp des niveaux1–18. Le chargeur partagé de définitions reste présent comme contexte de métadonnées, sans être promu en preuve de toutes les règles.

Le nouveau point ne qualifie pas la formule historique du serveur. L’ancien CID du helper de croissance est conservé sans modification ; son commentaire historique sur les alias BaseHPRegen/BaseMPRegen manquants n’est pas repris comme une absence actuelle des champs précis BaseStaticHPRegen/BaseStaticMPRegen vérifiés dans les preuvesV512/V513.

## Valeurs, types et limites conservés

**3 050 occurrences natives** sont relues :2 440 champs statistiques,366 champs de rayons,122 recherches de l’alias AttackSpeedOffset et122 recherches PARType.2 737 occurrences sont présentes. Les313 absences sont qualifiées :89 champs facultatifs GameplayCollisionRadius,122 alias AttackSpeedOffset et102 PARType. Ce ne sont pas313 fichiers ou fonctionnalités manquants.

- Les **2 318 champs directement comparables comme scalaires** conservent2 288 égalitésf32 et30 différences d’un pas de représentation. Ces30 cas comprennent4 croissances de régénération de ressource,6 croissances d’armure et20 croissances de dégâts/vitesse d’attaque déjà recensées. Ils ne sont pas normalisés. La correspondance avec un ancien test du parseur générique est héritée ; elle ne devient pas une nouvelle exécution du getter natif de chaque statistique.
- Les **122 délais d’attaque sont des ticks entiers dérivés**, distincts de l’offset flottant natif AttackDelayOffsetPercent. Les champs de comparaisonf32 restent non applicables pour ces ticks ; aucun float artificiel ne remplace ce contrat. L’alias AttackSpeedOffset absent n’est pas synthétisé à zéro. Les écarts de priorité de période Azir/Kalista restent dans leurs preuves antérieures.
- **102 types «Mana» proviennent du défaut local**, puisque PARType est absent. Les20 types explicitement présents restent séparés de ce défaut. Lire BaseMP et MPPerLevel ne prouve pas l’implémentation des mécaniques BloodWell, rage, chaleur, bouclier ou autres ressources.
- Pour **15 profils**, les deux champs de régénération de ressource sont gardés derrière le filtre courant :30 champs ne sont pas lus par l’expression numérique. Leurs consommateurs ne sont pas ajoutés comme s’ils calculaient une régénération active. Le calcul de capacité de ressource garde son contrat distinct et lit ses opérandes pour tous les profils.
- Les rayons de navigation, de sélection et de combat restent distincts. Le volume de clic allié/ennemi est lié à SelectionRadius ; le rayon de combat facultatif et ses replis locaux ne remplacent pas le rayon de navigation.
- Les **1 870 différences héritées entre maximum de vie stocké et maximum recalculé** restent enregistrées dans les contextes de progressionV515. Le calcul local incrémental et la valeur recalculée ne sont pas forcés à l’égalité. Les tests de getters avec niveaux ou inventaires injectés ne deviennent pas une preuve d’achats et de modification persistante en partie ordinaire.

Les neuf questions liées restent chez leurs propriétaires SYS : sept contrats de ressource, une question de calcul/arrondi des statistiques et une question de datation/disponibilité. Aucun identifiant d’inconnue n’est réassigné au champion. La présence dans le client fourni et le catalogue ne suffit pas à qualifier une date d’activation EUW. Les fiches source et leur acceptation restent ouvertes.

## Vérifications réellement exécutées

Le collecteur relit les122 fichiers natifs et compare les champs aux données courantes et aux contrats de chaque enfant. Les sources, ancres et preuvesCPU antérieuresV512–V517 sont vérifiées par SHA. Les anciens pins documentaires du plan décrivent leur époque ; ils sont explicitement conservés comme historiques, au lieu d’être déclarés égaux au plan actuel enrichi.

Deux essais du collecteur sont conservés : le premier incluait une association SYS supplémentaire du reçuV515 dans le comptage des champs de champions ; le second tentait une comparaisonf32 pour les ticks dérivés dont ce champ est intentionnellement non applicable. Le sélecteur est corrigé et les ticks restent des entiers avec leur contrat de conversion. Aucun registre ou base n’est écrit pendant ces essais.

Le candidat conserve les observations typées et refuse92 mutations invalides : faux propriétaire, lecteur manquant, champ natif inventé, promotion du catalogue, acceptation des enfants, fausse exécution fraîche, arrondi serveur prétendu, ressources déclarées complètes, normalisation des capacités, activation historique inventée, réattribution d’une question, effacement d’un écartf32, PARType absent transformé en valeur native et comparaisonf32 inventée pour les ticks. Trois refus du lecteur public contrôlent une source ou un consommateur absent et une acceptation de comportement inventée.

Les fragments de traçabilité des42 215 tâches sont comparés :122 changent et42 093 restent exacts.42 092 autres objets tâche/trace sont identiques. Les identités, la hiérarchie et le registre entier d’inconnues restent exacts en octets. Aucune question n’est créée ou fermée et aucune case n’est cochée.

Sur une copie privée puis dans les deux bases réelles, Store.task, copy_text, summary, les dépendances et rt.resolve sont exercés. Les2 440 enfants et122 fiches de rayons sont relus et les questions sont retrouvées chez leurs propriétaires.123 destinataires sont vérifiés par base ;42 484 autres lignes catalogue,42 607 états/notes et23 historiques restent exacts. L’intégritéSQLite estOK ; les synchronisations normales suivantes sont idempotentes.

Préparation, contrôle, publication et audit finissent au code0. Les écritures et transactions restent séquentielles ; aucune atomicité globale n’est revendiquée. Le reçu final est construit avec des champs uniques, sans relancer la publicationV524 déjà récupérée et auditée.

Il n’y a **aucun nouveau build du core, aucune nouvelle exécution du jeu, du parseur natif, du réseau, du clientGPU ou de l’audio dans ce lot**. Les anciennes exécutions sont identifiées comme héritées et leurs entrées sont revérifiées. Elles ne prouvent pas toute la sémantique serveur, les modificateurs, l’interface ou l’acceptation humaine.

## Réexamen global et portée restante

Le réexamen courant est enregistré sous **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision526_trace_review\REVIEW.json**. Le graphe de42 215 exigences et les2 656 ancres de leurs509 fichiers actuels sont vérifiés, sans divergence des octets ou ancres. Les17 consommateurs auxiliaires intentionnels sont conservés.

Le nombre de fichesCH dont le seul lien applicable est le chargeur partagé passe de9 476 à **9 354**. Cette file signale des liens à préciser ; elle ne démontre pas une absence d’implémentation. Les catégories sans source native ou avec seulement des frontières restent distinctes. Le réexamen ne rehache pas les98 763 fichiers sources et ne mesure pas la fidélité globale du jeu.

Le texte condensé garde son plafond de trois consommateurs. Le graphe complet, les contrats des enfants et le reçu qualifient l’ensemble des21/22 liens ajoutés par fiche. Les cases, notes et critères de recette restent les critères de l’utilisateur, séparés des contrôles documentaires.

## Livrables et état final

Modifiés : docs/fidelity_sources_4_20.json ; docs/fidelity_requirement_trace_4_20.json ; docs/completion_tasks_2026-10-20.json et les deux bases locales. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md reçoivent ce contexte après sauvegarde des versions précédentes.

Ajoutés : docs/reference_requirement_trace_sources/champion-identity-aggregate-links-v525.json ; docs/fidelity_champion_identity_aggregate_links_v525.json ; présent rapport. Deux sources sont ajoutées : inspection et reçu. Aucun code produit, asset, lecteur ou pack n’est modifié.

Graphe final :42 215 exigences actives,98 763 sources,2 656 consommateurs,25 919 questions ouvertes et5 517 résolues avec historique. Les46 arrivées manquéesV523 et leurs92 questions restent ouvertes ; la migrationGnarV522 et les autres écarts antérieurs sont conservés. Aucun champion ni jeu complet n’est déclaré terminé.

Travail : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision525_identity_inspection_final et revision525_identity. Scripts revision525_identity_*.py, journaux revision525_identity_COMMAND_*. Les deux collecteurs antérieurs restent conservés. Ne pas republier ce lot.

Poursuivre SYS-01.2-02 à partir de F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision526_trace_review/REVIEW.json. Les 9 354 fiches CH qui ont encore le chargeur partagé comme seul consommateur applicable constituent une file de qualification ; ce constat ne prouve pas une absence d’implémentation. Traiter ensuite les 122 CH-*-MODELE-MESH : inspecter le catalogue effectif (y compris Ezreal joint_identity), les GLB et meshes natifs, les producteurs et convertisseurs, puis les vrais chargeurs et points de rendu. Réutiliser les preuves existantes et identifier chaque provenance et limite. Préserver V512–V525, les 30 écarts de précision, les 122 délais dérivés, les 102 défauts Mana, les 15 profils sans régénération active, les 1 870 écarts entre maximum stocké et recalculé et les neuf questions SYS chez leurs propriétaires. Les arrondis serveur et l’activation EUW restent à qualifier. Conserver les 46 échecs V523 et leurs 92 questions, V522 Gnar, les 17 auxiliaires et les états manuels. Publication V525 terminée : ne pas la répéter. Goal entier actif.
