# SYS-01.2-02 — Derniers champs de statistiques d'identité V517

25 octobre 2026 ; F:/OpenLeague. Cette livraison précise les 976 fiches MOVESPEED, ATTACKRANGE, CRIT/CRITPERLEVEL, ATTACKDAMAGE/ATTACKDAMAGEPERLEVEL et ATTACKSPEEDOFFSET/ATTACKSPEEDPERLEVEL des 122 champions. Elle complète les liens détaillés des 20 champs de statistiques d'identité, sans accepter leur comportement historique complet, un champion ou le jeu.

Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; date littérale 2014-11-17 17:46:45, fuseau et déploiement inconnus. Le catalogue officiel 4.20.1 reste distinct du client AIR 0.0.1.119. Le projet actif est sur F ; les fichiers et chemins historiques E sont conservés.

## Consommateurs intégrés

| Famille | Point courant | Qualification |
| --- | --- | --- |
| Déplacement | movement.rs:55 ; CID OLC-b785668b-54e6-586f-90af-bf1b21ecc695 | Base + vitesse plate d'objets, puis règles locales de déplacement |
| Portée, poursuite | combat.rs:25 ; CID OLC-3889628c-541f-537c-b6d1-81160d201640 | Portée de définition + rayon de corps courant |
| Portée, début d'attaque | attacks.rs:155 ; CID OLC-4f309cf2-c9ff-5089-9a71-e04c29b94029 | Même entrée de portée dans la garde réelle de début d'attaque |
| Cadence | progression.rs:119 ; CID OLC-7889a3f2-d6a8-55e9-ae7b-7af0b7921369 | Ticks de base dérivés, croissance %, objets/effets, arrondi Rust et minimum 12 |
| Dégâts | progression.rs:42 ; CID existant OLC-867bbf41-0f02-529b-8d0e-c9c1a9c0ac8a | Expression locale base/croissance/objets/altar, appelée par stats |
| Critique | progression.rs:92 ; CID existant OLC-681a483c-6ee7-5041-b693-f7d19fad5ac9 | Chance et croissance issues du contrat critique, puis objets et clamp |

Quatre nouveaux CID sont ajoutés. Les deux CID réutilisés gardent exactement leurs anciens rôles et portées ; les nouvelles preuves de champ ne remplacent pas leurs anciennes qualifications partielles. La portée reçoit ses deux points de lecture. Total : 1098 liens de consommateur et 1098 liaisons natives pour les 976 fiches. Les anciens liens Data/data_loader et toutes les références antérieures restent présents.

Les fiches CRIT sont maintenant reliées à critical_contracts.json/chance ; CRITPERLEVEL à chance_growth. Les références génériques au catalogue et à la croissance, insuffisantes pour identifier ce contrat critique, sont conservées avec les nouvelles références précises. Les autres familles pointent leurs vrais champs dans champions.json ou champion_growth_420.json.

## Sources natives, comparaisons et conversions

Les 122 INIBIN sont relus avec reference_inibin.py ; chaque identité et propriétaire est contrôlé. Champs directs : MoveSpeed, AttackRange, BaseCritChance, CritPerLevel, BaseDamage, DamagePerLevel, AttackSpeedPerLevel.

854 fiches portent sur une valeur scalaire courante directe : 834 conversions analytiques en f32 sont égales et 20 différences d'un ULP sont conservées. Les 122 autres fiches sont des relations de conversion vers des ticks, pas des comparaisons entre deux valeurs de même unité.

Les champs BaseCritChance et CritPerLevel sont présents pour les 122 champions. Le défaut zéro de leur importeur n'est donc pas invoqué pour qualifier une absence. Cela ne prouve ni les passifs de critique, ni les exceptions, ni le tirage pseudo-aléatoire du serveur d'origine.

### Provenance réelle des ticks d'attaque

La requête native AttackSpeedOffset est absente des 122 fichiers. La contrepartie identifiée est Data.AttackDelayOffsetPercent ; elle concorde en binary32 avec stats.attackspeedoffset du catalogue officiel. Le Rust courant ne lit pas un offset brut : il lit attack_cooldown_ticks, déjà converti.

Les producteurs existants ont été retrouvés :

1. E:/mapslol3v3/tools/prepare_rust_integration.py:125 calcule speed = .625 / (1 + offset), puis max(1, round(30 / speed)) avec l'arrondi Python, et produit champions.ron.
2. E:/mapslol3v3/tools/bootstrap_openleague.py:24..30 relit le RON, multiplie déplacement/portée par 20 et recopie les ticks en entier dans champions.json.

Les seules boucles de conversion sont extraites de leurs AST et rejouées en mémoire avec le catalogue officiel déjà enregistré. Les projections nom/statistiques concordent avec l'entrée historique roster_source.json. Le RON courant est identique après normalisation des fins de ligne ; les 122 objets du catalogue et son texte normalisé sont exacts. Les octets bruts ne sont pas déclarés identiques : le RON contient 125 CRLF et le JSON 1465 CRLF.

Aucun script d'installation complet n'est lancé, aucun fichier du produit remplacé. Cette reconstitution qualifie la provenance et la règle locale existante. L'arrondi Python du producteur et l'arrondi Rust de cadence restent distincts ; aucun arrondi ou timing du serveur Riot n'est déduit de leur concordance locale. Les 122 fiches explicitent la contrepartie native, l'alias absent et le lecteur de ticks dérivés.

### Vingt précisions de croissance conservées

- Dégâts par niveau : Cho'Gath, Graves, Kha'Zix, Lulu, Nami, Nocturne, Orianna, Renekton, Skarner, Talon, Urgot, Ziggs.
- Vitesse d'attaque par niveau : Akali, Evelynn, Fizz, Quinn, Sion, Skarner, Xin Zhao, Zed.

Les stockages natifs compressés de type 2 sont relus ; les octets utilisés sont 13, 21, 26, 31, 36 et 42. Les données courantes correspondent aux anciens vecteurs du parseur générique V16, sous contexte FP déclaré, alors que le lecteur analytique normalisé puis converti en f32 diffère d'un ULP.

Le reçu original-compressed-byte-precision.json et les entrées concernées sont pinés. Les anciennes observations portent sur MeshSkin.SkinScale, pas sur de nouveaux appels originaux aux champs de croissance. Aucun parseur original réexécuté, aucune normalisation des données courantes. Les six cas d'armure V516 et les quatre cas de régénération de ressource restent séparés.

## Exécution fraîche du code courant

Un nouveau probe Rust est compilé et exécuté au code 0 sur la bibliothèque core V476 après comparaison de toutes ses entrées, dépendances et outils. Aucun rebuild du core. Bibliothèque : 278165670 octets, SHA-256 2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c. Binaire, scripts, commandes et logs sont pinés dans CURRENT_REMAINING_STATS.json.

Les attentes sont les expressions locales f32 et les règles de mouvement courantes, dont la provenance communautaire et la qualification historique négative restent conservées. Les additions d'objets sont effectuées en f32 dans l'ordre des slots ; elles ne sont pas remplacées par une somme en double précision.

| Essais | Attendu / observé |
| --- | --- |
| Niveaux légaux, six inventaires, deux états déclarés | 26352 relevés conformes de dégâts, critique, cadence et déplacement |
| Niveaux injectés 0/19/255 | 4392 relevés conformes aux bornes 1..18 du facteur |
| Total des quatre champs | 30744 relevés, 122976 comparaisons scalaires conformes |
| Getter direct de déplacement | 30744 égalités avec stats.move_speed ; joueurs et tick inchangés par les getters |
| Minimum de cadence | 844 observations au minimum courant de 12 ticks |
| Portée intérieure, bord exact et extérieure | 366 contextes réels commande Attack + un advance ; windup commencé à l'intérieur/au bord, absent à l'extérieur après le mouvement du tick |
| Cibles alliée, morte ou absente | 366 erreurs attendues, joueurs et tick inchangés |
| Propriétaire absent de commande | Un refus "unknown player" |
| Propriétaire absent de stats/movement | Deux panics attendus capturés et logués, pas de refus propres Result/Option |

Inventaires injectés : vide ; composants 1036/1042/1051/1001 ; six 1018 ; six 3101 ; six 3020 ; deux 3020. Ce ne sont pas des achats, et la légalité de ces inventaires en boutique n'est pas prouvée. L'état pénalisé combine une durée Exhaust pour la vitesse d'attaque et un slow distinct de 60 % accordé par l'API serveur grant_slow ; il ne prétend pas reproduire un cast Exhaust. Les niveaux sont assignés directement pour les getters.

La borne haute de chance critique à 1 n'est pas atteinte avec le catalogue injecté (zéro observation) ; la garde basse de dénominateur AS à .05 n'est pas entièrement exercée. L'application des passifs, tous les effets combinés, l'ordre historique et la correction de séries de critique restent non qualifiés.

### Portée : avance réelle, contexte synthétique

Ces cas utilisent une navigation plate synthétique 100x100, Map10 et interactions désactivées. La visibilité est alors contournée par le contrat courant. La cible Garen n'a pas de GameplayCollisionRadius natif explicite : le rayon courant 65 est un défaut local, distinct des rayons de sélection/pathfinding et sans qualification native ici.

Les distances sont portée + rayon -1, égales à portée + rayon, et portée + rayon +200. Le cas extérieur reste extérieur après une avance ; il n'est pas artificiellement immobilisé pour obtenir le résultat attendu. Au début du windup, aucune perte de santé n'est observée. Libération, projectile, impact, dégâts et présentation complète ne sont pas qualifiés par ce seul tick.

Aucun match ordinaire, rendu GPU, audio, exécutable original ou session réseau n'est exécuté. Les essais de portée avancent effectivement les ticks des simulations concernées ; les autres relevés sont des getters à tick fixe. La preuve ne les regroupe pas sous une fausse absence globale d'avancement.

## Contrôles, intégration et conservation

Le candidat est reconstruit depuis les quatre baselines. Sur 42214 traces : 976 changées, 41238 exactes. Les 977 contextes, dont SYS-01.2-02, sont précontrôlés ; SYS ne récupère pas les CID de gameplay des fiches. Les 41237 autres objets tâche/trace et tous les anciens enregistrements de sources/consommateurs restent exacts. Le document des questions reste identique, avec ses propriétaires, statuts et historiques.

1513 identités, le pin de plan et les quatre registres sont vérifiés avant publication. Six refus d'inspection couvrent opérandes manquants/non finis et admission explicite d'offset ; ils ne sont pas attribués aux anciens producteurs. Deux cent quarante-six gardes de livraison couvrent propriétaire, famille, nom/source, précision masquée, fausse exécution originale, faux arrondi natif ou achèvement, et confusion entre offset brut et ticks. Quatre refus du lecteur public couvrent une source de consommateur absente.

Le contrôle vérifie les 122976 valeurs du reçu de runtime, les 30744 cohérences de déplacement, les 366 contextes de portée et leurs refus. Les familles de 122 fiches sont complètes ; les 122 conversions de ticks et 20 précisions restent explicitement différentes des 834 comparaisons scalaires directes égales.

Après publication séquentielle, l'audit reconstruit les postimages et relit les deux bases avec Store.task/copy_text et rt.resolve. Dans chacune : 977 fiches vérifiées ; 41629 autres lignes de catalogue, 42606 états/notes et 23 historiques exacts ; intégrité SQLite OK. Aucune case manuelle cochée, aucune inconnue créée, précisée ou résolue. Ces opérations ne constituent pas une transaction globale entre fichiers et bases.

Une requête exploratoire avec un glob Windows passé comme chemin littéral a été refusée en lecture seule. La recherche dans les vrais répertoires a retrouvé les producteurs ; cet échec ne démontrait pas une source manquante. Les premières comparaisons de bytes ont aussi montré les CRLF : la qualification finale distingue égalité d'objets/texte normalisé et égalité brute.

## Livrables et suite

Registres modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json. Le registre des questions reste identique. Reçu : docs/reference_requirement_trace_sources/remaining-stat-source-links-v517.json ; preuve : docs/fidelity_remaining_stat_source_links_v517.json.

Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Documents : ce rapport, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md, avec sauvegardes des versions précédentes et conservation de leurs autres champs.

Travail sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision517_inspection/OBSERVATIONS.json ; revision517_runtime_checks/CURRENT_REMAINING_STATS.json et OBSERVED_REMAINING_STATS.json ; revision517/BASELINE.json, SOURCE_LINK_RECEIPT.json, PREPARATION.json, CANDIDATE_CHECK.json et DELIVERY_AUDIT.json. Les scripts revision517_inspection.py, revision517_probe.rs, revision517_runtime.py, revision517_delivery.py et revision517_check.py identifient le travail exact. Le wrapper conserve les commandes Python -X utf8 -E -u -B, leurs codes et logs à création exclusive.

Quatre nouveaux CID, deux CID réutilisés sans modification, trois preuves supplémentaires. Aucun code produit, lecteur, asset, pack ou fichier de données de jeu modifié ; aucune ancienne exécution présentée comme fraîche. Les 17 sources auxiliaires justifiées V512 sont conservées.

Les 2440 fiches des 20 champs statistiques disposent maintenant de liens précis de source/conversion/consommation ou de branche d'inapplicabilité ; ce constat ne qualifie pas 2440 fonctionnalités de jeu. Les 30 champs de régénération à garde inactive, les conversions de ticks et les différentes questions d'arrondi gardent leurs limites.

Suite : actualiser l'audit transversal des 42214 exigences après ces lots. Rechercher les liens restant génériques, les frontières non implémentées et les entrées natives encore absentes, en distinguant contrats locaux légitimes, recherches sans résultat et véritables ressources manquantes. Vérifier les consommateurs réels avant toute nouvelle association ; conserver les acceptations et inconnues existantes. Le Goal et SYS-01.2-02 restent actifs, sans pourcentage de jeu terminé déduit du graphe.

Bilan : inspection, compilation/exécution du probe, préparation, contrôle, publication et audit au code 0. Graphe : 98736 sources, 2620 consommateurs, 25827 questions ouvertes et 5517 résolues avec historique. Questions identiques en octets à la baseline ; les 2440 champs et les 17 auxiliaires sont vérifiés comme décrit.
