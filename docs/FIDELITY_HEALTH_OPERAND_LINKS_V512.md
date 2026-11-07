# SYS-01.2-02 — Provenance de18 consommateurs et liens précis de régénération V512

25 octobre2026 ; F:\OpenLeague ; Goal actif. Le périmètre reste la liaison des exigences aux sources natives ou contrats locaux explicites et aux consommateurs actuels. Aucun champion ni jeu complet n’est accepté par cette livraison.

## Résultat

Les18 consommateurs sans lien direct actif recensés par V510 sont maintenant examinés individuellement :

- Un consommateur de production, regeneration.rs:16, lit les opérandes health_regen et health_regen_growth. Il était enregistré mais absent des exigences correspondantes. Il est relié aux244 fiches HPREGEN/HPREGENPERLEVEL des122 champions, en complément du chargeur déjà lié.
- Seize entrées sont des sources de tests bornés :8Annie et8World. Leurs chemins, lignes, aiguilles et empreintes correspondent à leurs symboles d’origine V240/V249 dans les reçus V241/V250. Ces symboles étaient intentionnellement absents des associations de production. Ils restent des preuves auxiliaires, sans nouvel appel de tests ni promotion en consommateurs de fonctionnalités.
- Une entrée world.rs:192 ajoute la définition annietibbers, distincte des27 définitions qualifiées par V250. Son contexte reste séparé ; elle n’est pas ajoutée aux27entités par analogie.

Tous les18enregistrements, identifiants et rôles globaux sont conservés. Le nombre structurel de consommateurs sans lien direct actif passe de18à17 : ce reste est justifié, pas supprimé ou masqué pour obtenir zéro. Le reçu conserve le corps courant, la provenance exacte, le type, l’absence d’association de production et la décision de chaque entrée.

## Contrat natif et chaîne actuelle

Référence : PUBLIC4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct d’AIR0.0.1.119. AGENTS.md, CURRENT.md, HANDOFF.md, DECISIONS.md, l’objectif joint du Goal, phases et lots des244 fiches et D01-SYS-01-2 sont consultés. Les contrôles V510/V511 sont des acquis datés, pas des exécutions rejouées.

Les deux propriétés sont identifiées sur les sources et le code existants :

| Exigence | Propriété native Data | Entrée actuelle | Lecture effective |
| --- | --- | --- | --- |
| HPREGEN | BaseStaticHPRegen | champion_growth_420.json/<champion>/health_regen | growth.health_regen |
| HPREGENPERLEVEL | HPRegenPerLevel | champion_growth_420.json/<champion>/health_regen_growth | growth.health_regen_growth * growth_total(level) |

Les122 INIBIN de définition de champion sont relus par le lecteur v2 existant. Les244 valeurs décodées sont comparées après conversion en f32, type de Growth dans Rust :244 correspondances exactes de bits, aucun défaut remplacé par zéro ni valeur manquante. Le type Python décodé, la valeur originale, le hash de propriété, le champ/pointeur courant et les bits sont conservés. Cela ne prétend pas que le stockage natif était nécessairement lui-même un float32 : chaîne, valeur empaquetée et valeur flottante restent des représentations possibles du décodeur.

La provenance des entrées courantes est contrôlée par taille/SHA contre le source_id déjà lié. Les copies historiques E et les fichiers actifs F sont identifiés séparément ; égalité d’octets ne signifie pas même fichier. Les deux champs sont ensuite désérialisés par progression::Growth depuis le include_str! de Simulation::new. regeneration_rates les lit, applique le facteur local de niveau et le multiplicateur d’objets, puis borne le résultat à zéro. advance_regeneration et le caller de Simulation::advance sont relus comme chaîne de code, sans qualifier ici leur timing natif.

Les anciennes associations natives génériques Data restent en préfixe.244 liaisons natives précises sont ajoutées avec la propriété, son hash et les bits courants.244 liens vers le consommateur existant OLC-2cd67c31-acd3-5324-85dd-0cf5fca2c6e4 sont ajoutés. Aucun nouveau consommateur n’est créé et ce CID n’est pas lié aux champs MPREGEN, aux tests ou à l’ensemble d’un kit de champion.

## Vérification CPU actuelle

Un probe Rust est compilé et exécuté à neuf. Il appelle réellement Simulation::regeneration_rates dans la bibliothèque du core V476, après vérification de toutes ses entrées, de sa toolchain, de sa bibliothèque et des dépendances réutilisées. Le JSON de croissance fait explicitement partie des entrées vérifiées. Il n’y a pas de nouvelle compilation du core ; le binaire du probe est nouveau et identifié.

Chaque champion utilise une nouvelle simulation avec navigation synthétique20x20 et un seul joueur. Le niveau est assigné directement :

- Les18 niveaux légaux sont contrôlés pour chacun des122 champions :2196 taux de base/growth exacts en bits.
- Les niveaux0,19et255 vérifient les bornes du modèle local :366 observations.
- Un identifiant de joueur absent renvoie None dans les122 simulations.
- L’appel du getter ne modifie ni les joueurs ni le tick.

L’attendu est explicitement le modèle f32 du Rust actuel, avec son growth_total local. Il vérifie le routage des données et le calcul courant ; une formule recopiée dans le probe ne prouve pas la formule, les unités ou l’arrondi du serveur Riot. Aucun tick de monde n’est avancé, Map10 n’est pas activée, aucun match, déplacement, soin effectivement appliqué, mana/énergie, passif, item non vide, réduction de soins, réseau, rendu ou audio n’est qualifié. Les16 tests historiques Annie/World ne sont pas rejoués.

## Attendus, observations et refus

| Contrôle | Attendu | Observé |
| --- | --- | --- |
|18provenances | Distinguer production, test et contexte séparé |1calcul,16 tests,1contexte Tibbers ; tous conservés |
|244 valeurs | Propriété exacte, pas de défaut inventé |122 fichiers natifs,244conversions f32 identiques |
| Sélection de champ | Refuser mauvaise famille, source absente/dupliquée, pointeur ou opérande absent |6 refus contrôlés |
| Garde de liaison | Refuser mauvaise valeur/propriété/source, test substitué au calcul, faux propriétaire ou fausse complétude |16 refus sur les deux types de champ |
| Comparaison globale | Changer les seuls fragments concernés |42214 traces :244changées/41970exactes |
| Conservation | Autres fiches, sources, rôles et inconnues exacts |41969autres tâches/fiches exactes ; tous les anciens sources/consommateurs et toutes les questions exacts |
| Contexte de copie | Associations et IDs cohérents avant publication |245 contextes précontrôlés dont SYS |
| Sources d’exécution | Bibliothèque et entrées réutilisées identiques, nouveau probe identifié |1376 identités pinées contrôlées ; compilation/exécution du probe réussies |
| Deux bases | Mise à jour documentaire, suivi conservé |245 fiches par base ;42361autres lignes,42606 états/notes et23 historiques exacts ;intégritéOK |

La garde de livraison vérifie la correspondance champ/source/consommateur. Le validateur générique de graphe vérifie ses propres invariants structurels ; il n’est pas présenté comme vérifiant à lui seul la propriété sémantique d’un champ ou qu’un test est un consommateur de jeu.

## Préparations conservées

La première préparation a été refusée avant toute écriture de registre ou connexion DB : une référence était ajoutée à la copie mémoire avant le contrôle de conservation du préfixe. L’ordre est corrigé dans une recette distincte ; l’original et ses sauvegardes restent intacts. Les quatre empreintes sont comparées aux registres actifs pour prouver l’absence de mutation de ce premier essai.

Un premier contrôle de copie cherchait l’aiguille du code dans les instructions, alors que le lecteur affiche le rôle, le chemin et la ligne. Le contrôle corrigé vérifie l’emplacement réellement copié ; l’aiguille est contrôlée séparément dans le vrai fichier par l’inspection. Aucun code produit ni assertion de gameplay n’est modifié pour faire passer le contrôle.

Une préparation intermédiaire réussie est conservée, puis la recette finale précise ses compteurs d’exécution :122 cas CPU,2196 calculs légaux,366bornes et122 refus d’identifiant. Seuls revision512_final et revision512_delivery_final.py servent à la publication. Aucun essai de préparation n’est présenté comme une publication. Les contrôles finaux et les retours réels de publication/audit sont consignés séparément.

## Livrables et fichiers

Dans F:\OpenLeague : docs/reference_requirement_trace_sources/health-operand-consumer-links-v512.json, docs/fidelity_health_operand_links_v512.json et ce rapport. Les registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json reçoivent les trois preuves, les244 liaisons précises et le bilan SYS. fidelity_unknowns_4_20.json reste identique. Couverture, plan de complétion, reprise, CURRENT.md et HANDOFF.md sont actualisés après audit, avec sauvegardes des versions précédentes. Aucun code de jeu, code du plan, pack ou asset de distribution n’est modifié.

Sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20 : revision512_inspection.py et revision512_inspection/OBSERVATIONS.json ; revision512_probe.rs, revision512_runtime.py et revision512_runtime_checks/{CURRENT_HEALTH_REGENERATION.json,OBSERVED_HEALTH_REGENERATION.json,probe.rs,health_regeneration_probe.exe,logs et reçus de sortie} ; recettes et contrôles initiaux/retry/final ; revision512_final/{BASELINE.json,before,PREPARATION.json,CANDIDATE_CHECK.json,SOURCE_LINK_RECEIPT.json,DELIVERY_AUDIT.json}. Les logs complets des commandes finales sont conservés à côté avec préfixe revision512_final_COMMAND_. Le wrapper conserve commande, code et SHA du journal sans tronquer les mappings.

Commandes de livraison finale : Python -X utf8 -E -u -B revision512_command_runner_final.py prepare|publish|audit et revision512_check_final.py. Les publications et logs sont à création exclusive : ne pas les relancer aveuglément. L’identité de l’interpréteur, du probe, des scripts, de la bibliothèque, des entrées et de la toolchain est dans les reçus d’exécution et EXECUTION_ENVIRONMENT.json.

## Limites et suite

Cette amélioration relie précisément des champs déjà présents à leur calcul réel et classe des sources auxiliaires. Elle n’accepte pas la régénération complète, ses interactions ou un champion à100%. Les unités et timings natifs effectifs, la formule de niveau et ses arrondis serveur, les passifs et l’application de soins restent séparés. Aucun comportement d’origine n’est inventé à partir d’une égalité numérique.

Poursuivre SYS-01.2-02 sur les champs MPREGEN/MPREGENPERLEVEL. Inspecter les122 champions, leurs propriétés natives et les gardes restores_resource/uses_mana avant de lier un lecteur : distinguer opérande réellement consommé, branche inapplicable et source manquante, sans transférer le CID de santé à la ressource. Conserver les17 sources auxiliaires justifiées, la version de lecteur V511, les preuves CPU bornées et toutes les inconnues. Le Goal reste actif ; aucun pourcentage du jeu n’est déduit de ces244 liens.

Bilan final : inspection, compilation et exécution du probe, préparation finale, contrôle final, publication et audit terminent au code0.245fiches par base,42361autres lignes/42606états-notes/23historiques exacts,intégritéOK. Graphe après publication : 98721sources/2609consommateurs/25827questions ouvertes/5517résolues avec historique.17consommateurs sans lien direct sont exactement les16sources de tests etle contexte séparé documentés. Les deux refus de préparation/contrôle restent conservés ;aucune republication ou réparation de données n’a été nécessaire.
