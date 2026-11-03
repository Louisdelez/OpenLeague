# V96 — Contrats locaux de preuve et consommateurs du plan

Périmètre : SYS-01.2-02, liens des neuf exigences SYS-01.4. Les critères de preuve sont des contrats locaux d’OpenLeague, pas des règles extraites du client historique. La référence native 4.20 est revalidée comme contexte ; elle n’est pas transformée en origine de ces politiques. Aucun faux lien native_inputs n’est ajouté aux neuf tâches.

## Contrats et parcours réellement inspectés

instructions.py contient des étapes par type : source, simulation, réseau, présentation, acceptation, ressource et travail. make_instruction assemble ces étapes, le critère d’acceptation, les preuves demandées et la traçabilité. Store.copy_text fournit ce texte à l’utilisateur. Six consignes de tâches Aatrox Q existantes ont été réellement générées, conservées et comparées : SOURCE, SIMULATION, NETWORK, PRESENTATION-VFX, PRESENTATION-AUDIO, ACCEPTANCE. Cela vérifie le générateur de consignes, pas les capacités d’Aatrox.

Les trois premières fiches et la fiche ACCEPTANCE utilisent les étapes génériques. Les fiches VFX et audio ont work_steps et remplacent donc le modèle presentation. Leurs sections de travail ne contiennent aucune des étapes génériques de présentation. L’objectif audio mentionne bien l’écoute ; cette mention ne prouve ni une écoute effectuée ni la couverture de tous les critères du modèle. Ce constat porte sur les deux exemples et sur la règle de substitution ; il n’établit pas que toutes les fiches modifiées ont les mêmes manques.

Le recensement complet des 42 214 tâches retrouve les usages suivants :

| Type | Total | Avec étapes propres |
|---|---:|---:|
| Source | 6 672 | 4 577 |
| Simulation | 3 786 | 2 344 |
| Réseau | 634 | 0 |
| Présentation | 7 944 | 5 965 |
| Acceptation | 15 646 | 13 679 |
| Ressource | 6 714 | 5 853 |
| Travail | 818 | 818 |

Les étapes source exigent version, SHA, exceptions et inconnues. Simulation exige le chemin ordinaire et les refus. Réseau exige plusieurs clients, audiences, séquences et reconnexion. Présentation distingue événements, images et sortie sonore avec une comparaison datée. Acceptation demande entrées, attendus, succès et refus. Ces contrats sont consommés comme texte ; ils ne sont pas un moteur universel de clôture ou un schéma structuré de scénario démontré.

## Péremption et refus

source_versions valide les archives et chaînes de versions pour une liste explicite de sources locales. Les tests refusent une dérive non enregistrée, des archives ou preuves modifiées et l’adoption comme nouvelle version d’une source appartenant à la racine historique. La validation historique ne certifie pas une copie différente dans la racine active.

requirement_trace ne vérifie les octets qu’avec verify_files=True. Sa validation de métadonnées peut réussir en présence d’inconnues ouvertes, tout en retournant gameplay_accepted=False. Un essai sur copie en mémoire du registre réel a forcé acceptance_complete=True : le validateur de trace a encore retourné gameplay_accepted=False et conservé 25 321 inconnues ouvertes. Aucun fichier du registre n’a été modifié par cet essai. Ce résultat qualifie la portée de ce validateur, sans prétendre avoir examiné tous les outils de recette finale.

Les critères de propagation de péremption à chaque recette dépendante, le schéma universel de scénario et la garde de recette finale restent ouverts. La consigne de conserver les inconnues est reliée à son générateur ; elle n’est pas déclarée garde technique universelle.

## Suivi manuel

Store stocke les coches et notes dans task_state, distinct de tasks.data. sync_catalog initialise une nouvelle coche à zéro et conserve les états existants. change vérifie types et révisions et conserve l’historique. summary mesure les coches ; son pourcentage ne constitue pas une preuve de complétude technique ou d’acceptation humaine.

Le test existant de suivi manuel a été exécuté sur une base temporaire F : une fiche techniquement acceptée n’est pas cochée automatiquement, la synchronisation conserve le choix manuel, et la décoche reste possible. Les bases réelles n’ont pas été touchées par cet essai. Le module de test contient un ancien ajout de chemin E : le harnais charge d’abord Store depuis F, restaure sys.path immédiatement et redirige STAGE vers le répertoire temporaire F. La source du test n’a pas été réécrite.

## Vérifications exécutées et limites

- 23 tests existants : suivi manuel, versions de sources et déplacement de racines ; aucun échec ni test ignoré.
- 9 tests existants sélectionnés du registre : identités, fausse acceptation du jeu, lien d’inconnue perdu, ancre déplacée, clôture sans preuve, provenance, SHA et compteurs périmés ; aucun échec.
- Un essai supplémentaire des indicateurs d’acceptation sur copie en mémoire, avec résultat attendu et observé.
- 90 contrôles source et 35 fichiers épinglés par le lecteur ; six consignes réellement générées.
- 28 cas du lecteur, dont 27 refus d’affirmations ou de données altérées.

Les 9 tests du registre utilisent principalement une validation de métadonnées ; le refus d’ancre sort avant un parcours global des empreintes. Ils ne démontrent pas une relecture de toutes les ressources du jeu. Les reçus identifient Python, harnais, modules, journaux et entrées. Aucun jeu, serveur multiclient, client AIR, rendu GPU, écoute ou interface native n’a été exécuté ou observé ici.

Le lot D01-SYS-01-4 dépend encore de D01-SYS-01-2 non terminé. Le contrôle préparatoire a d’abord refusé l’hypothèse que tous ces prérequis étaient achevés, avant toute modification du projet. Le contexte corrigé distingue les prérequis du Goal actif de ceux de l’implémentation et de l’acceptation du lot aval. La présente intégration est uniquement une traçabilité ; elle ne franchit pas ces dépendances.

## Conservation

Seules les neuf fiches SYS-01.4 et le Goal reçoivent des liens et consignes actualisés dans chaque base. Les indicateurs de validation, coches, notes, historiques et anciennes preuves sont conservés. Deux tâches possèdent des consommateurs partiels réels (versionnement et état manuel) ; les sept autres sont reliées comme frontières avec leur travail restant. Aucune inconnue ni tâche n’est clôturée. Les détails ci-dessous explicitent chaque portée.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-01.4-01 | STEPS.source demande version,SHA,exceptions et inconnues ;make_instruction le consomme réellement pour CH-Aatrox-Q-SOURCE. Il s’agit d’un contrat local de preuve,non d’une règle native de fermeture automatique. Les fiches avec work_steps remplacent ce modèle. | Définir et qualifier un contrat de clôture source appliqué à chaque tâche,avec disponibilité et divergences ;vérifier les overrides sans assimiler une consigne copiée à une preuve acceptée. |
| SYS-01.4-02 | STEPS.simulation exige chemin ordinaire,conditions,refus et interactions ;la consigne CH-Aatrox-Q-SIMULATION contient ces étapes. Le générateur produit du texte et n’exécute pas une simulation ni une décision de clôture. | Relier les critères à des scénarios et preuves de simulation réellement consommés pour clôturer chaque tâche ;garder les comportements et interactions non vérifiés ouverts. |
| SYS-01.4-03 | STEPS.network contient audiences,ordre,doublons,reconnexion et plusieurs clients ;la consigne réelle CH-Aatrox-Q-NETWORK les conserve. Le recensement des634 tâches network ne trouve pas d’override,mais aucun essai multiclient n’est exécuté ici. | Qualifier le format et le consommateur des preuves multiclient,les scénarios obligatoires et les refus de couverture insuffisante ;une instruction ne prouve pas la cohérence réseau. |
| SYS-01.4-04 | Le modèle presentation demande observation dans la fenêtre réelle et référence datée au même cadrage. La fiche VFX échantillonnée possède work_steps :le générateur remplace alors les étapes du modèle. Sa consigne réelle ne contient pas ces étapes génériques. | Définir des critères visuels précis et vérifier leur propagation dans les fiches réellement copiées,leurs overrides et leur décision de clôture. Aucun rendu ni comparaison visuelle n’est validé par ce lot. |
| SYS-01.4-05 | Le modèle presentation distingue sortie sonore,image et événement. La fiche audio échantillonnée demande de relier et écouter les sons dans son objectif,mais son override remplace les étapes génériques. L’objectif audio ne prouve pas une écoute comparative effectuée. | Qualifier format,référence,contexte d’écoute et acceptation audio ;vérifier chaque consigne spécifique et séparer événement émis,fichier présent et sortie réellement entendue. |
| SYS-01.4-06 | STEPS.acceptance décrit entrées,attendus,succès,refus et limites ;CH-Aatrox-Q-ACCEPTANCE les utilise. Les consignes sont exécutées comme génération de texte ;aucun schéma de scénario structuré universel ni moteur de recette n’est prouvé. | Relier un modèle de scénario exploitable à son consommateur réel et vérifier champs obligatoires,cas de refus et conservation des résultats ;ne pas prendre ce générateur pour l’exécuteur de scénarios. |
| SYS-01.4-07 | source_versions valide chaîne,archives et preuves SHA pour une liste locale explicite. Les tests réels refusent dérive,archives modifiées et adoption d’une source historique hors racine active. requirement_trace vérifie les octets seulement avec verify_files=True ;une validation de métadonnées n’établit pas leur fraîcheur. | Qualifier la propagation de péremption vers toutes les preuves dépendantes et leur clôture ;la validation d’un historique de source n’invalide pas automatiquement toutes les recettes. Conserver racines historiques et copies actives distinctes. |
| SYS-01.4-08 | requirement_trace valide un graphe avec inconnues ouvertes et retourne gameplay_accepted=False. Sur copie en mémoire du registre réel,forcer acceptance_complete=True ne transforme pas ce résultat en recette :ce validateur n’est pas une garde finale de clôture. Les consignes demandent de conserver les inconnues. | Identifier et qualifier le consommateur final qui refuse toute exigence obligatoire inconnue,ainsi que ses contournements et entrées réelles. Aucun garde final universel créé ou déclaré complet ici. |
| SYS-01.4-09 | Store conserve la coche dans task_state séparément de tasks.data. Le test courant prouve qu’une acceptation technique ne coche pas une nouvelle tâche et qu’une synchronisation conserve le choix manuel. change contrôle type,révision et historique ;summary mesure les coches,non la complétude du jeu. | Vérifier tous les parcours de présentation,import/export et clôture pour conserver cette distinction et qualifier l’acceptation humaine séparément. Le test temporaire ne vaut pas observation de l’application native. |

Reçu : docs/reference_proof_criteria_sources/proof_criteria-links.json. Livraison : docs/fidelity_registry_proof_criteria_links_revision_4_20.json. Les neuf tâches et le Goal restent ouverts.
