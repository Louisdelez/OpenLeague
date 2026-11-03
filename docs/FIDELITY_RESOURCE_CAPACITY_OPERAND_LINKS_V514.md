# SYS-01.2-02 — Capacité de ressource, opérandes et consommateur réel V514

25 octobre 2026. F:/OpenLeague. Résultat : les 244 fiches MP/MPPERLEVEL des 122 champions sont reliées précisément aux champs natifs BaseMP/MPPerLevel et au calcul de capacité courant. Le périmètre est la traçabilité des sources et consommateurs. SYS-01.2-02 et le jeu restent partiels.

Référence : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; date littérale 2014-11-17 17:46:45, fuseau/déploiement non établis. Catalogue 4.20.1 distinct du client AIR 0.0.1.119. Le projet actif est F:/OpenLeague ; les chemins historiques E sont conservés et comparés, sans confondre deux fichiers de mêmes octets.

## Contrat observé et intégration

Le calcul dans crates/core/src/progression.rs:110 lit base.mana + g.mana * factor pour tous les champions. La garde lifecycle::uses_mana concerne uniquement items.mana. Les gardes de régénération de V513 ne s'appliquent pas à ces deux opérandes de capacité : les 15 champions sans régénération automatique passent eux aussi par la lecture de base et de croissance.

Le CID existant OLC-07efedeb-8f9f-51ab-b6c5-69d8de29136c est réutilisé sans changer son rôle, son champ scope ou son identité historique. Les 244 fiches reçoivent le lien vers ce point de code et une qualification bornée propre à leur champ. Aucun nouveau CID ; les anciens liens de chargement restent présents.

Deux liaisons natives par fiche précisent le champ numérique et la recherche PARType utile au bonus d'objet, soit 488 liaisons. Les sélecteurs distinguent native_present=False/field_absent de native_present=True/value="None". Les valeurs manquantes ne sont pas remplacées par des zéros.

Les références ajoutées relient l'observation indépendante, le reçu du probe et le champ courant réel sur F. Les anciennes références de données sur E restent exactes. Leurs copies de travail F sont comparées en taille/SHA ; cette égalité n'efface ni leur chemin ni leur provenance. Les deux fichiers de données courants ont des sources F déjà enregistrées : aucun alias de source supplémentaire n'est créé.

## Sources et résultats attendus/observés

Les 122 INIBIN sous le deploy 0.0.1.68 sont relus avec reference_inibin.py, leurs champs et identités comparés au référentiel existant. BaseMP est rapproché de champions.json[id]/mana ; MPPerLevel de champion_growth_420.json[champion]/mana. Les pointeurs existants sont résolus et la correspondance du champion vérifiée.

Attendu : chaque opérande natif décodé, converti en binary32, correspond au champ courant de la même fiche. Observé : 244 correspondances exactes, aucun champ de capacité absent et aucun écart numérique. Cela ne qualifie pas une formule serveur historique.

La classification conserve 102 Mana à PARType absent, cinq Energy et 15 autres types explicites. Le type Mana des 102 premières entrées reste un défaut local dont le producteur natif est inconnu. Le source_sha256 de champion_resources.json reste celui du JSON Stats décodé, jamais celui de l'INIBIN. Les exports et MetaData.ResourcePath sont à nouveau vérifiés. Les preuves précédentes de régénération et de précision sont conservées sans nouvelle exécution du parseur original.

## Probe du vrai getter courant

Un nouveau probe appelle Simulation::stats(id).max_mana sur la bibliothèque core V476 après comparaison exacte de ses entrées, outils, bibliothèque et dépendances. Compilation du probe et exécution au code 0 ; le core n'est pas recompilé. Nouveau binaire et script sont pinés dans le reçu CURRENT_RESOURCE_CAPACITY.json, schéma /v514.

Trois inventaires sont injectés, sans achat : vide, 1027 (+200 selon les données courantes), 3024 (+250). Pour chaque champion, une simulation isolée utilise une navigation synthétique 20x20 ; le niveau est directement assigné.

- Attendu : modèle f32 courant base + croissance × facteur de niveau + bonus de mana réservé au type local Mana. Observé : 6588 capacités conformes aux 18 niveaux légaux, trois inventaires et 122 champions.
- Attendu : bornes 1..18 du facteur aux niveaux injectés 0/19/255. Observé : 1098 capacités conformes.
- Les 20 champions non Mana conservent les mêmes capacités pour les trois inventaires, y compris les 15 sans régénération ; leur capacité n'est pas artificiellement remplacée par zéro.
- Le getter ne modifie ni les joueurs ni le tick. Les 122 valeurs initiales au join correspondent en bits à la valeur de base courante ; ce constat auxiliaire ne constitue pas une qualification du spawn natif.

Limite API effectivement observée : stats indexe directement le joueur demandé. Pour 122 identifiants absents, il provoque un panic "no entry found for key". Le probe capture ces panics attendus avec catch_unwind ; le hook de test conserve les 122 messages dans les observations. Le processus de test se termine normalement, mais l'API produit n'a pas de refus Result/Option propre dans ce cas. Aucun correctif de gameplay ou d'API n'est inclus dans une tâche limitée aux associations de sources.

Aucun match ordinaire, monde avancé, achat, tick de soin/régénération, état mort, ordre complet de modificateurs, ressource secondaire, timing serveur, GPU ou audio n'est qualifié. L'attendu réplique le contrat numérique local pour comparer le vrai getter ; ce n'est pas une formule indépendante de serveur Riot.

## Contrôles du candidat et du consommateur du plan

Le candidat est reconstruit depuis les quatre baselines immuables. Les 42214 textes de trace sont comparés : 244 changés, 41970 exacts. Les 245 contextes, dont SYS, gardent exactement les consommateurs sélectionnés ; SYS ne récupère pas les consommateurs de gameplay des champions. Les 41969 autres objets tâche/trace et tous les anciens enregistrements de sources/consommateurs restent exacts.

Six refus d'inspection rejettent opérande absent, NaN, infini, type courant absent, défaut Mana abusif sur un autre type et désaccord d'un type explicite. Cinquante-quatre gardes propres à la livraison couvrent six champs de Janna/Akali/Aatrox et neuf substitutions : mauvais propriétaire, champ de régénération substitué, faux défaut natif, fausse complétude/acceptation, garde de régénération appliquée à la capacité, PARType inventé, lecture numérique retirée et mauvaise source native. Le lecteur public refuse séparément une source de consommateur inexistante. Ces refus ne sont pas attribués indistinctement au même outil.

1499 identités sont contrôlées et les quatre registres vivants comparés aux pins de baseline avant publication. Les 244 textes montrent le champ exact et le point de code :110 ; les 30 fiches sans régénération restent reliées au calcul de capacité. Les questions sont conservées intégralement : aucune créée ou résolue. Les 17 sources auxiliaires V512 et les travaux V511/V513 restent préservés.

Après publication, l'audit reconstruit le candidat depuis les baselines et compare les postimages. Les deux bases sont lues avec les vrais Store.task/copy_text et rt.resolve, en URI mode=ro/query_only : 245 fiches par base, 42361 autres lignes exactes, 42606 états/notes et 23 historiques exacts, intégrité SQLite OK. Les cases manuelles ne sont pas modifiées.

## Fichiers et preuves

Registres modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json. Le registre des inconnues reste identique. Trois preuves supplémentaires, aucun nouveau consommateur. Reçu : docs/reference_requirement_trace_sources/resource-capacity-operand-links-v514.json. Preuve : docs/fidelity_resource_capacity_operand_links_v514.json.

Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Documentation : ce rapport, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md ; versions précédentes sauvegardées. Les autres champs documentaires restent conservés hors date/prochaine action.

Travail sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision514_inspection/OBSERVATIONS.json, revision514_runtime_checks/CURRENT_RESOURCE_CAPACITY.json et OBSERVED_RESOURCE_CAPACITY.json ; revision514/BASELINE.json, SOURCE_LINK_RECEIPT.json, PREPARATION.json, CANDIDATE_CHECK.json, DELIVERY_AUDIT.json et point de reprise. Scripts revision514_inspection.py, revision514_probe.rs, revision514_runtime.py, revision514_generate_runtime.py, revision514_delivery.py et revision514_check.py.

Le wrapper revision514_command_runner.py garde les commandes Python complètes avec -X utf8 -E -u -B, leurs logs et codes pour prepare, publish, audit. Le candidat est vérifié avant publication ; les mutations de registres et bases sont séquentielles et ne forment pas une transaction globale. Aucun code produit, asset, pack, ancien journal ou preuve immuable n'est remplacé.

## Suite

Poursuivre les 244 fiches HP/HPPERLEVEL, avec les champs natifs et les vrais consommateurs de capacité de vie, chargement et croissance. Le calcul max_health existe à progression.rs:117 ; la recherche dans le registre courant ne trouve aucun CID précis pour ce champ. La présence du code est donc établie, son lien détaillé reste à qualifier. Séparer le maximum calculé, l'état initial et l'application au passage de niveau ; ne pas confondre ces lectures avec le getter de régénération déjà qualifié. Conserver les défauts de type inconnus, les écarts de précision, les limites d'API et les autres exigences ouverts.

Le graphe de liens n'est pas un pourcentage de jeu fini. Les questions ouvertes ne sont pas toutes des assets manquants. Aucune acceptation d'un champion ou du jeu complet n'est accordée par cette livraison.

Bilan : inspection, compilation/exécution du probe, préparation, contrôle candidat, publication et audit terminés au code 0. Après publication : 98727 sources, 2611 consommateurs, 25827 questions ouvertes, 5517 résolues avec historique. Les 17 consommateurs sans lien actif restent exactement les auxiliaires documentés en V512.
