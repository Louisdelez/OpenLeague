# SYS-01.2-02 — Présentation des huit sbires : agrégats, effets et consommateurs (V492)

24 octobre 2026 — F:\OpenLeague. LoL 4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; catalogue 4.20.1 distinct.

## Résultat

Les huit exigences WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-PRESENT sont reliées aux quatre fiches enfants de chaque profil, aux sources natives d’attaques et d’effets, et aux points actuels de présentation. Les 32 fiches enfants et leurs questions restent inchangées. Une question propre à chaque agrégat conserve la fidélité de l’ensemble ouverte : une association partielle n’est pas une acceptation du modèle, de l’animation, des effets ou du son.

Six ancres actuelles sont ajoutées : file numérique d’attaques, frontière de snapshot, entrée des barres de vie, affectation conditionnelle DDS, enregistrement du plugin DDS et producteur de fondu de fin de match. Des ancres existantes de modèles, matériaux, animations et validation DDS sont réutilisées. Aucun consommateur audio fictif n’est ajouté : les exclusions audio V491 sont conservées dans les fiches enfants.

## Projectiles et effets natifs

Vingt-six INIBIN d’attaques candidates ont été relus pour les champs MissileSpeed, MissileMinSpeed, MissileMaxSpeed, MissileGravity, MissileTargetHeightAugment, MissileBoneName, MissileEffect, HitEffectName, AfterEffectName et drapeaux associés. Présence, valeur et absence sont distinctes ; un champ absent n’est pas remplacé par un défaut supposé. Les valeurs actuelles de `map10_world.json` sont enregistrées séparément. La sélection native de l’attaque candidate n’est pas déduite de son nom.

Les 61 occurrences de références d’effets ont été cherchées par nom dans les fichiers `.troybin` de l’arbre DATA du deploy natif fourni. Quinze fichiers candidats distincts sont identifiés avec chemin, taille et SHA-256.

- `BloodSlash.troy` possède deux candidats : DATA/Shared/Particles et le dossier de particules de la skin de base de Darius. Aucun ordre de montage ni candidat actif n’est arbitrairement choisi.
- `AnnieBasicAttack_mis.troy` ne trouve pas de candidat de même basename parmi les `.troybin` parcourus. Cette observation ne prouve pas son absence des archives, d’un alias ou d’un autre format, et ne signifie pas que toute attaque de mêlée doit lancer ce projectile.
- `globalhit_physical`, `globalhit_physical_crit`, `BloodSlash` et `missing_instant` disposent de candidats dans DATA/Shared/Particles, au-delà du dossier DATA/Particles examiné en V491. La limite de ce précédent parcours était explicite ; elle est complétée ici.

La correspondance par nom ne qualifie ni l’activation de l’effet, ni ses textures, matériaux, dépendances internes, trajectoires, coordonnées de bones ou mélange sonore. Les originaux restent inchangés.

## Chemin courant des attaques et limite de présentation

`world.rs` calcule un délai de trajet à partir de la distance et de `projectile_speed`, puis ajoute un `Pending` avec source, cible, dégâts, instants de libération/résolution et drapeaux ranged/launched. Cette file permet le calendrier des impacts ; sa structure ne contient pas de modèle, de particule ou de trajectoire à dessiner.

`Snapshot.projectiles` est alimenté par `self.projectiles.clone()`, collection distincte de la file privée `world.attacks`. Ce point de code n’exporte pas cette file comme missiles visibles. La recherche lexicale dans les 498 fichiers Rust du client ne relève aucune utilisation du champ `.projectiles` ni des noms de particules retenus par l’audit. Ces constats ne constituent pas une analyse exhaustive de tout dispatch indirect. Ils ne démontrent aucune chaîne de rendu des missiles ou impacts de sbires.

Les 116 cas d’attaque contrôlés V484 restent des preuves historiques de calcul et d’annulation dans leur portée déclarée. Ils ne sont pas rejoués et ne prouvent pas le rendu des projectiles. Aucun test de session, lancement client ou capture GPU n’est effectué ici.

## Complément important : les trois DDS natifs déjà pris en charge

L’observation V489 portait notamment sur les PNG embarqués dans les GLB. Elle reste valide pour ces octets, mais ne décrit pas à elle seule le chemin de matériau actuel.

`native_minion_mips.rs` possède déjà un plugin enregistré dans `main.rs`, avec `DRAFT=false`. Pour Blue_Minion_Basic, Blue_Minion_Wizard et Red_Minion_MechMelee, il peut remplacer la texture du matériau par un DDS natif. Les trois fichiers actuels `assets/forms/native_minion_mips/*.dds` sont identiques octet par octet à leurs sources : 512×512, DXT1, dix niveaux, 174 904 octets chacun.

Ce remplacement demeure conditionnel : sous-asset chargé et identifié, format PNG d’origine attendu, support BC, chargement DDS et validation des octets/dimensions. Une texture étrangère est conservée ; le PNG est retenu ou restauré quand les gardes échouent. Le code demande sRGB, filtrage linéaire et répétition. L’affectation ne porte que sur `base_color_texture`, après le chargement des modèles et avant le raccordement FoW.

Le module comporte des tests CPU existants, mais ils ne sont ni compilés ni exécutés dans ce lot. L’égalité des DDS et la présence du code ne prouvent pas l’image effectivement chargée, le matériau rendu, le chemin GPU ou la fidélité native du filtrage. Ces limites restent ouvertes. Ce chemin existant est lié aux agrégats des trois profils concernés, sans prétendre qu’un nouveau remplacement a été implémenté ici. La prochaine reprise doit aussi enrichir leurs trois fiches TEXTURE avec cette association précise.

## HUD et fondu existants

`health.rs` utilise les positions et PV des unités du snapshot pour dessiner des barres locales de 48×5 pixels ; hauteur supplémentaire de 110 unités pour les non-structures, couleurs d’équipe, ratio borné des PV et retrait/masquage selon l’état. L’enregistrement du système est présent dans `main.rs`. Il s’agit d’un consommateur réel du HUD, pas d’une qualification des formes et règles du HUD d’origine.

`native_minion_fade_producer.rs` et son matériau suivent les acteurs de voie de l’équipe perdante après un résultat de match accepté, avec identité de session/acteur/modèle, horloge de fin, premier événement et modulation liée aux herbes. Ce chemin est distinct du cycle de mort ordinaire et du protocole natif. Aucune qualification GPU supplémentaire n’est accordée.

## Vérifications et conservation

1. Contrôles frais des champs INIBIN, index de noms de particules, trois DDS et des corps de code actuels ; fichiers identifiés et relus sans modification des ressources.
2. Sept refus contrôlés : profil inconnu, profil dupliqué, mauvais en-tête DDS, données DDS tronquées, enfant manquant, enfant dupliqué et enfant d’un autre profil.
3. Neuf sélecteurs nominaux et dix sélecteurs invalides ; trois refus publics pour propriétaire incorrect, fausse résolution et condition de résolution absente.
4. Comparaison des 42 214 instructions : huit changées, 42 206 identiques. Les 32 fiches enfants, leurs questions, leurs critères et leurs exclusions restent exacts. Les anciens liens des agrégats sont conservés comme préfixe.
5. Publication puis audit indépendant dans les registres et les deux bases : neuf lignes documentaires par base, 42 597 autres lignes inchangées, 42 606 états/notes et 23 entrées d’historique exacts. Le vrai lecteur Store.task/copy_text consomme les nouveaux liens.

Attendu et observé : les huit agrégats exposent leurs sources et leurs consommateurs partiels, sans transformer les limites en réussite. Aucun état manuel ni aucune case modifiés. Aucun build, runtime, GPU, audio ou test historique rejoué ; aucun asset ni code de jeu modifié.

## Livrables et suite

- `docs/reference_minion_behavior_sources/minion-presentation-v492.json` : associations des agrégats, enfants et points de code.
- `docs/fidelity_minion_presentation_v492.json` : preuve de publication.
- Quatre registres de fidélité/tâches, couverture, plan, reprise et notes docs/ai actualisés avec conservation des preuves précédentes.
- `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision492_presentation_inspection/PRESENTATION_OBSERVATIONS.json` : observations fraîches.
- Même racine, `revision492/` : préparation, contrôle candidat, audit et point de reprise ; scripts revision492_presentation.py, revision492_delivery.py, revision492_check.py et revision492_finish.py.

Suite : relier le chemin DDS conditionnel aux trois fiches TEXTURE concernées, puis examiner les fiches ACCEPT des huit sbires en conservant les critères de scénario ordinaire et de fidélité humaine. Les défauts de squelette V488, limites des matériaux V489, images/rotations V490, chaînes audio V491 et projectiles/effets restent ouverts. Le Goal n’est pas terminé.

Bilan : 196 liens natifs ajoutés, 221 liens consommateurs, 6 nouvelles ancres, 4 sources et 8 questions ouvertes. 736 identités vérifiées. Graphe : 98666 sources / 2538 consommateurs / 25724 questions ouvertes / 5517 résolues avec historique. Sous-inventaire chargeur :127 à reprendre,381 associations partielles,32 exclusions ouvertes dont20audio ; aucun pourcentage de jeu achevé n’en découle.
