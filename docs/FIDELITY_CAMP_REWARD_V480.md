# SYS-01.2-02 — Récompenses des camps, V480

Les14 fiches CAMP-00..06-REWARD et CAMP-00..06-SOURCE-REWARD sont reliées à leurs sources et consommateurs précis. Registres et deux bases locales du plan vérifiés ; cases, notes et historiques conservés. Aucun code de gameplay ou asset n'est modifié. Chaque fiche reste partielle, avec sa propre question de fidélité.

Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau/déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague. CAMP-00..05 désignent les camps1..6 ; CAMP-06 désigne le camp8 Vilemaw. La relique native7 reste séparée.

## Champs natifs et valeurs courantes

Les sept INIBIN de personnages sont réidentifiés et redécodés. Les valeurs textuelles numériques sont converties explicitement pour comparaison ; les champs absents restent absents. L'appartenance aux manifests reste une preuve héritée, pas une nouvelle exécution du vérificateur de manifests. NeutralMinionSpawn.luaobj est reparsé et ses sept tableaux d'instructions comparés au reçu V479.

| Définition | Or local natif | XP native | Or global natif | XP globale native |
| --- | ---: | ---: | --- | --- |
| TT_NGolem | 48.0 | 150.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_NGolem2 | 38.0 | 42.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_NWolf | 28.0 | 144.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_NWolf2 | 14.0 | 12.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_NWraith | 33.0 | 120.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_NWraith2 | 18.0 | 48.0 | Absent ; défaut local0 | Absent ; défaut local0 |
| TT_Spiderboss | 25.0 | 400.0 | 190.0 | 0.0 |

Les douze absences de champs globaux des six profils ordinaires ne deviennent pas des zéros natifs retrouvés. Vilemaw contient explicitement190 d'or global et0 d'expérience globale. Les règles serveur de crédit et de modificateurs ne sont pas démontrées par ces valeurs seules.

Le texte natif en_US des autels affiche+3or par kill avec un ou deux autels. Le fichier est identifié et les lignes exactes sont comparées au relevé local. Cette preuve concerne l'affichage anglaisUS du client fourni ; elle ne qualifie ni l'activation de cette ressource pour en_GB, ni l'intégralité du calcul serveur.

## Consommateurs reliés

Huit ancres sont ajoutées : admission par apply_damage, valeurs à la création, combat_owner, gain local d'or, sélection des bénéficiaires de l'XP, or global d'équipe, award_experience et altar_kill_bonus. Les fichiers inspectés sont crates/core/src/world.rs, damage.rs, annie_r.rs, progression.rs et altars.rs. Les ancres et empreintes figurent dans le reçu.

Le code courant donne l'or local et l'expérience de monstre au joueur ou au propriétaire existant du familier. Le chemin Monster/Boss ne filtre pas ce propriétaire par distance ou santé. L'or global utilise l'équipe de la source, même si celle-ci n'a aucun propriétaire joueur. Le bonus d'autel vaut3 dès qu'au moins un autel appartient à l'équipe, sans doubler avec deux autels. Les champs de croissance de voie ne sont pas appliqués aux monstres.

## Exécution nouvelle

Un nouveau programme Rust est compilé et exécuté contre la bibliothèque coreV476 après revalidation des sources, outils, bibliothèque et dépendances enregistrées. Aucun nouveau cargo build du cœur n'est revendiqué. Le binaire, le programme, les journaux, commandes et entrées sont identifiés dans revision480_runtime_checks/CURRENT_CAMP_REWARD.json et sont inchangés après exécution.

112 simulations :7 camps ×2 équipes ×8 profils, avec six Annie par simulation. Les positions et certains états sont contrôlés directement ; le temps initial est sauté, puis les décès sont provoqués par apply_damage avec1million de dégâts vrais. Les captures d'autels passent réellement par241 advances par autel ; le familier passe par learn/cast_at et huit advances. Ce sont des tests de chemins locaux, pas des attaques ordinaires ou des parties complètes.

| Profil | Résultat observé pour chaque membre |
| --- | --- |
| Joueur proche | Prime locale et XP au tueur ; or global à son équipe selon configuration |
| Joueur éloigné | Même crédit par l'API, sans contrôle de portée dans ce chemin |
| Joueur mort | Même crédit ; santé du bénéficiaire reste nulle |
| Familier Tibbers | Prime locale et XP au propriétaire ; or global à son équipe |
| Un autel | Prime locale augmentée de3 |
| Deux autels | Prime locale augmentée de3, pas6 |
| Unité de structure alliée sans propriétaire | Pas de prime locale ni XP de monstre ; or global attribué à son équipe |
| Source absente | Aucun crédit aux joueurs |

Les scénarios totalisent272 morts, chacun comparant les gains d'or et d'expérience pour les six joueurs :1632 comparaisons. Une répétition immédiate du dégât sur chaque unité morte est refusée avec damage target dead, sans changement de l'état financier :272 refus. Les membres sont tous examinés, pas seulement le dernier du camp. Les récompenses sont immédiates au décès de chaque membre dans le code actuel.

Exemple Vilemaw sans autel :215or pour le tueur (25local+190global),190pour chacun de ses deux coéquipiers,400XP au tueur uniquement. Une source d'équipe sans propriétaire ne distribue que les190par joueur ; une source absente ne distribue rien. Ces observations ne déclarent pas ces politiques fidèles au serveur historique.

Les comparaisons mesurent les deltas avant/après chaque appel de dégâts au même tick. Les gains passifs ou changements antérieurs pendant la préparation sont exclus par ces captures. Les coéquipiers sont placés loin ; l'exclusion d'un coéquipier proche de l'XP découle ici du code inspecté, pas d'un scénario dédié. Les niveaux sont relevés, mais l'ensemble de la progression et de ses bonus n'est pas accepté par ce lot.

## Buff de Vilemaw et limites

DATA/Spells/TTBossBuff.inibin contient uniquement la référence game_buff_tooltip_TTBossBuff. Le texte natif décrit une régénération de vie/mana, une vitesse d'attaque accrue et une réduction des délais. Cela confirme des métadonnées d'effet attendu, pas les coefficients, la durée, les bénéficiaires, la persistance après mort ou le producteur serveur.

Le chemin exact DATA/Spells/TTBossBuff.luaobj est absent dans le deploy examiné. Une recherche bornée des noms TTBossBuff, boss_buff, vilemaw_buff, spiderboss_buff et Crest of Crushing dans tous les fichiers Rust de crates/core/src ne trouve aucun résultat. Les fichiers et termes recherchés sont conservés dans le reçu. Le chemin de récompenses inspecté n'identifie pas d'application de ce buff. Une recherche textuelle ne prouve pas l'absence universelle d'un équivalent sous un autre nom ; le producteur reste non identifié et les deux fiches Vilemaw restent ouvertes.

Autres limites ouvertes : politique native de partage et d'éligibilité, producteurs de dégâts ordinaires, bonus d'objets/maîtrises et scaling, crédits sans propriétaire, événements de mort dupliqués par d'autres voies, réapparitions et attribution sur un nouveau cycle. Refuser un second dégât sur une unité morte ne démontre pas toutes les garanties réseau. Aucun rendu, son, effet visuel de buff, jeu Riot ou acceptation humaine exécuté dans ce lot.

## Contrôles et conservation

- 112 scénarios,272 morts,1632 comparaisons et272 refus : réussis.
- Collecteur :4 refus réels (texte invalide, NaN, valeur négative, infini) ; absence distinguée de zéro.
- 15 sélecteurs nominaux,16 invalides ;3 refus publics (mauvais propriétaire, résolution indue, condition de résolution vide).
- 42 214 instructions comparées :14 changées et42 200 inchangées ; toutes les autres exigences, y compris les21 questions V479, conservées.
- Deux bases :15 fiches mises à jour par base ;42 606 états/notes,23 historiques et42 591 autres lignes du catalogue exacts. Intégrité SQLite correcte et relecture par les vrais lecteurs du plan.
- 683 fichiers directement épinglés, dont la recherche Rust bornée, plus les dépendances du programme revalidées. Le contrôle de structure du graphe reste distinct de la vérification des empreintes.

Une première préparation a échoué avant création du lot et toute mutation des bases : nom de codec Python utf8-sig invalide. La lecture a été corrigée en utf-8-sig ; le script de l'essai et le diagnostic sont conservés. Le programme de récompenses avait réussi et n'a pas été relancé pour ce correctif documentaire.

## Livrables et suite

Modifiés : les quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json ; les deux bases du plan ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu, asset, case, note ou historique manuel n'est modifié.

Reçu : docs/reference_camp_sources/camp-reward-v480.json. Preuve : docs/fidelity_camp_reward_v480.json. Scripts, programme, sauvegardes et journaux : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision480*. Les14 questions restent ouvertes ; zéro question résolue.

Le sous-inventaire du chargeur contient251 associations encore génériques,265 partielles et24 exclusions conservées dont12 audio. Il reste28 fiches CAMP (SOURCE,AI,ACCEPT,SOURCE-RESET pour7 camps). Ce n'est pas un pourcentage de complétion du jeu. Suite : aggro, poursuite, retour et reset avant les agrégats de validation. Goal actif.

Ajouts vérifiés :56 liens natifs,120 liens consommateurs,8 ancres,2 sources et14 questions ouvertes. Graphe :98635 sources,2470 consommateurs,25600 ouvertes,5517 résolues avec historique.
