# SYS-01.2-02 — Protection et victoire des deux Nexus

Les quatre fiches `WORLD-ChaosNexus-AI-VULNERABLE`, `WORLD-ChaosNexus-AI-VICTOIRE`, `WORLD-OrderNexus-AI-VULNERABLE` et `WORLD-OrderNexus-AI-VICTOIRE` citaient uniquement le chargeur Map10. Elles sont maintenant reliées aux fonctions qui traitent effectivement la protection, les dégâts et la capture du résultat. Les anciennes références sont conservées.

## Résultat intégré

- Protection : `world::protected` lit les dépendances locales et `apply_damage` refuse une cible protégée.
- Victoire : `world::damage_unit` traite la mort du Nexus, fixe le gagnant puis appelle `capture_final_results`. Celle-ci refuse une nouvelle capture si le résultat est déjà présent.
- Configuration : `HQ_T1` utilise `OrderNexus`, équipe locale 0 ; `HQ_T2` utilise `ChaosNexus`, équipe locale 1. Chaque Nexus dépend de sa tourelle centrale et de ses deux inhibiteurs dans le JSON local.
- Sources natives : six liens ajoutés vers les fonctions nommées de `LevelScript.luaobj` et `EndOfGame.luaobj`, sans présenter leur présence comme une exécution du moteur historique.
- Onze liens vers des consommateurs existants ajoutés, dont un sur SYS-01.2-02 ; aucun nouveau consommateur générique créé.

Dans le corps local inspecté, le Nexus est protégé si une dépendance `depends_all` est encore vivante, ou si toutes les dépendances de la liste non vide `depends_any` sont vivantes. Cette lecture décrit le code actuel ; elle ne démontre pas l’équivalence complète aux callbacks historiques.

## Sources et vérifications

Les deux chunks Lua originaux sont identifiés par chemin, taille, SHA-256 et MD5. Leur MD5 est comparé à celui des preuves d’appartenance au manifeste déjà conservées. Le parseur de manifeste n’est pas réexécuté.

Le lecteur Lua borné actuel a reparsé entièrement les deux chunks, sans les exécuter. Cinq fonctions ont été retrouvées et comparées à l’ancien reçu : `DeactivateCorrectStructure`, `ApplyBarracksRespawnReductions`, `HandleDestroyedObject`, `EndOfGameCeremony` et `ScoreboardPhase`. Constantes, bornes de lignes et empreintes des instructions correspondent. Il s’agit d’une qualification de source, pas d’un test des effets des API du moteur.

Les quatre consommateurs Rust existants ont été comparés à leurs sources enregistrées et aux fichiers actuels sur F. Leurs ancres et les appels concernés ont été relus. Les identités INIBIN des deux Nexus sont conservées et vérifiées, sans leur attribuer des règles de victoire qu’elles ne démontrent pas.

Contrôles réalisés :

- Cinq sélecteurs nominaux et six refus de couples tâche/sélecteur incorrects.
- Quatre refus de configuration : Nexus inconnu, instance absente, équipe erronée, dépendance absente.
- Deux refus du parseur : chunk tronqué et en-tête invalide.
- Trois refus du validateur public : question rattachée à une autre exigence, question faussement résolue, condition de résolution vide.
- Deux refus d’identité de source : taille et SHA-256 modifiés.
- Comparaison des 42 214 textes de traçabilité : quatre changés, 42 210 identiques. Les sorties complètes des autres tâches hors SYS sont préservées.
- Publication, récupération ciblée et audit indépendant des quatre registres et des deux bases du plan.
- Cinq fiches, instructions et textes copiables relus via les lecteurs réels dans chaque base ; quatre questions ouvertes vérifiées avec leur exigence propriétaire.
- 42 606 états/notes et 23 entrées d’historique exactement conservés dans chaque base ; 42 601 autres lignes du catalogue inchangées ; intégrité SQLite correcte.

Les 30 838 anciens enregistrements d’inconnues sont inchangés. Quatre questions propres aux fiches Nexus sont ajoutées, aucune n’est résolue. Le graphe conserve 42 214 exigences et 2 414 consommateurs ; il contient désormais 98 604 sources, 25 325 inconnues ouvertes et 5 517 résolues. Les statuts, critères et cases des tâches sont préservés.

## Manques explicitement ouverts

Les quatre fiches n’avaient aucune inconnue recensée. Chacune dispose maintenant d’une question propre, visible dans la traçabilité et les instructions copiables :

| Fiches | Ce qui reste à démontrer |
|---|---|
| Protection de chaque Nexus | Conditions et paramètres natifs, équivalence de chaque dépendance, réactivation après retour des inhibiteurs et contexte de lancement. |
| Victoire sur chaque Nexus | Appels natifs et voies de dégâts autorisées, victoire ordinaire par commandes normales, état de session et résultat unique pour chaque camp. |

Le helper de dégâts ne suffit pas à établir la politique d’hostilité de tous ses appelants. Les gardes de capture ne constituent pas une partie ordinaire complète. Les fonctions et constantes Lua ne prouvent ni les effets du moteur ni la fidélité des verrous, délais, animations, sons et résultats côté client. Les anciens tests mentionnés dans les consommateurs restent des preuves héritées ; ils ne sont pas rejoués ici.

Aucune modification du gameplay ou compilation Rust n’est effectuée. Aucun jeu, client AIR, runtime Lua ou rendu GPU n’est exécuté. Les lecteurs Python du plan et le parseur binaire sont les outils exécutés pour ce lot.

## Anomalies de livraison et correction

Une première préparation a échoué sur la borne de lecture de `apply_damage` : le collecteur prenait une section de tests située avant la fonction. La borne a été corrigée, puis la préparation et les contrôles ont réussi. Aucun registre n’avait été modifié à ce stade.

La publication initiale a ensuite appliqué les trois premiers registres et les deux transactions de fiches, mais laissé le quatrième registre, celui des inconnues, dans le dossier de préparation. La relecture a refusé les identifiants absents. La récupération a d’abord vérifié les trois registres publiés, le quatrième candidat, toutes les fiches touchées et la conservation des états/historiques. Elle a installé uniquement le quatrième registre déjà préparé. Aucune transaction de base n’a été rejouée. L’audit indépendant a ensuite vérifié l’état final complet. Les scripts, sauvegardes, contrôles et erreur observée sont conservés.

Ne pas réutiliser aveuglément le script de publication V467 : son adaptation conservait une borne de trois éléments sur la liste des anciennes empreintes. Une future publication de quatre registres doit parcourir les quatre chemins et les quatre empreintes. Le script livré est conservé comme preuve exacte de cette exécution et ne doit pas être rejoué.

## Fichiers et suite

Livrables : `docs/reference_nexus_sources/nexus-links-v467.json`, `docs/fidelity_nexus_links_v467.json`, les quatre registres `fidelity_sources_4_20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_unknowns_4_20.json`, `completion_tasks_2026-10-20.json`, les deux bases du plan, les documents de couverture et de reprise. Les preuves techniques et sauvegardes sont dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision467/`.

Le suivi des associations au chargeur Map10 comporte maintenant 12 associations partiellement qualifiées et 528 associations restant à examiner : WORLD 329, STRUCTURE 108, CAMP 63, MODE 27 et SYS 1. Ce décompte ne représente pas tout le travail restant sur le jeu.

Poursuivre les fiches agrégées AI/ACCEPT des Nexus, puis leurs modèles, matériaux, animations et sons, en réutilisant les preuves exactes disponibles et en recensant les limites propres à chaque tâche. SYS-01.2-02 et le Goal restent ouverts.
