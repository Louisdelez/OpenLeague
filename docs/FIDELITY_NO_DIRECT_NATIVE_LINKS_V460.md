# SYS-01.2-02 — audit des exigences sans input natif direct, V460

Les 385 exigences dont native_inputs est vide sont auditées. 380 possèdent des références ; cinq fiches Battle Training restent sans source identifiée. Ce résultat n’est pas un pourcentage de jeu terminé.

## Résultats vérifiés

| Contrôle | Résultat |
|---|---:|
| Exigences inspectées | 385 |
| Sources de référence distinctes | 198 |
| Identités de sources, incluant celles du code consommateur | 387 |
| Fichiers physiques distincts lus et hachés | 411 |
| Consommateurs avec ancre retrouvée dans le fichier courant | 527 |
| Pointeurs JSON résolus | 383 |
| Références descriptives ou documents sans pointeur strict | 256 |
| Identité divergente, ancre absente ou pointeur introuvable détecté | 0 |

Les identités sont comparées par taille/SHA-256 aux enregistrements. Pour les consommateurs enregistrés sous une origine E: et utilisés sous F:, les deux identités sont conservées et comparées. Les numéros de ligne observés restent distincts des anciens numéros enregistrés. Le contrôle des ancres et de l’existence des pointeurs ne démontre pas la sémantique complète du code ni l’adoption d’une recommandation.

## Autorité et inconnues

- 317 fiches ont déjà une base de contrat explicite. Son texte et ses restrictions sont conservés ; l’audit ne requalifie pas toutes leurs conclusions historiques.
- 37 fiches portent un contrat de projet local : identifiants stables, restauration/distribution de la carte, livraison et acceptation. Une source native du jeu n’est pas automatiquement leur autorité.
- 24 fiches AUDIT/ADOPT portent les références d’ingénierie fournies. Les dépôts et commits cités ne deviennent pas une autorité des règles du jeu. AnvilKit reste distinct de l’archive de tests non identifiée de SYS-03.4-07.
- SYS-04.3-14 et SYS-04.3-15 restent des frontières de combat local. Shield stocke tag/remaining/expiry ; le contrat d’absorption inspecté ne porte pas DamageKind. L’ordre local de Simulation::advance ne restitue pas l’ordre historique global des dégâts simultanés. Les preuves V63 et leurs inconnues restent conservées.
- MODE-BATTLE-TRAINING-SCOPE, SELECT, STEPS, RULES et RESULT n’ont toujours aucun input natif ou de référence. Leur lecteur de fiche ne constitue pas une implémentation du scénario. Les recherches AIR452/453 ont échoué en DNS avant HTTP ; elles ne sont pas rejouées. Le nom CSS advanced_tutorial ne suffit pas à qualifier cette identité.

L’absence d’un champ de qualification n’est jamais interprétée comme false ou comme une réussite. Les références descriptives sont conservées comme telles, sans prétendre qu’un sélecteur arbitraire a été résolu.

## Livraison dans le vrai plan

Le reçu est relié à SYS-01.2-02 et apparaît dans sa fiche ainsi que son texte copiable. Un nouveau reçu de source est enregistré ; aucun nouveau consommateur ni lien vers un corps de jeu. 42 213 autres exigences actives restent exactes.

Les lecteurs réels Store.task, Store.copy_text, requirement_trace.resolve et make_instruction sont vérifiés dans runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Une fiche est actualisée ; les 42 605 autres lignes, les 42 606 états/notes et les 23 lignes d’historique restent exacts dans chaque base. Intégrité SQLite : ok.

Audit initial, préparation, publication et relecture : code0. Un sélecteur nominal et quatre refus de mauvais sélecteur/tâche sont vérifiés. Le registre des inconnues est inchangé en octets. Graphe final de cette livraison : 42 214 exigences, 98 595 sources, 2 412 consommateurs ; 25 321 questions ouvertes, 5 517 résolues.

Aucun jeu, exécutable inspecté, VM, compilation, réseau ou GPU n’est lancé. Les contrôles de données et métadonnées ne sont pas des tests gameplay ou une acceptation utilisateur. Les helpers de publication/audit sont réutilisés ; aucune revue indépendante n’est revendiquée.

## Preuves et fichiers

- Reçu complet : docs/reference_no_direct_native_links/no-direct-native-links-v460.json.
- Vérification de livraison : docs/fidelity_no_direct_native_links_v460.json.
- Scripts : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision460_no_direct_native_audit.py et revision460_deliver_audit.py.
- Copies avant modification, audit brut, contrôles et reçus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision460/.
- Registres modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json ; couverture, plan et reprise complétés. Inconnues et cases conservées.

SYS-01.2-02 reste ouvert : les entrées historiques indispensables non identifiées ne sont pas remplacées par une réussite inventée. La prochaine vérification porte sur les autres consommateurs du registre, hors des 527 déjà contrôlés ici, avant le bilan final des liens restant non qualifiés.
