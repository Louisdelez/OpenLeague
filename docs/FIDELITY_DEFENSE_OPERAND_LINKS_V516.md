# SYS-01.2-02 — Champs de défense, précision et consommateurs V516

25 octobre 2026 ; F:/OpenLeague. Cette livraison relie précisément les 488 fiches ARMOR/ARMORPERLEVEL/SPELLBLOCK/SPELLBLOCKPERLEVEL des 122 champions à leurs champs natifs et aux deux expressions courantes. La tâche globale de traçabilité et le jeu restent partiels.

Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; date littérale 2014-11-17 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 et client AIR 0.0.1.119 distincts. Les chemins historiques E sont conservés ; le projet actif reste sur F.

## Résultat intégré

Deux CID décrivent les lecteurs d'opérandes communs :

- OLC-ea3ac329-2f2f-51ef-9a3f-57543da2765c, progression.rs:101 : base.armor + g.armor * factor + items.armor * bonus_defense, puis bonus Annie et réduction Exhaust ; l'ajustement Trundle suit à la ligne 103.
- OLC-cd8a31a1-871d-559a-9570-e198e9fa5df9, progression.rs:106 : base.magic_resist + g.mr * factor + items.magic_resist * bonus_defense, puis les termes correspondants ; l'ajustement Trundle suit à la ligne 108.

Chaque groupe de 244 fiches reçoit le CID de son axe, avec source et propriété exactes. Total : 488 liens et 488 sélecteurs natifs ajoutés. Les liens génériques Data et data_loader restent présents. Le CID historique OLC-8b327020-d7e0-56f9-bc07-f37e6d1c7a24 à la ligne 101 décrit l'amplification spécifique de Garen ; son rôle et sa portée restent inchangés. Les nouveaux rôles portent sur les lectures communes de base/croissance, sans promouvoir la portée de cet ancien exemple Garen à tout le système.

Les 488 fiches montrent leurs nouveaux points de calcul dans les instructions du lecteur du plan. Le contexte de SYS-01.2-02 reçoit la preuve de livraison sans importer les CID de gameplay dans ses propres liens. Aucune case, condition, dépendance, acceptation ou fonctionnalité de champion n'est déclarée terminée par cette association.

## Sources natives et noms de champs

Les 122 INIBIN de champion du deploy 0.0.1.68 sont relus avec reference_inibin.py. Les champs sont Data.Armor, Data.ArmorPerLevel, Data.SpellBlock et Data.SpellBlockPerLevel. Les deux premiers champs de base ne portent pas le préfixe Base : les 244 requêtes d'alias BaseArmor/BaseSpellBlock sans résultat ne désignent pas des ressources manquantes. Aucun zéro de remplacement n'est inventé.

Armor/SpellBlock sont rapprochés de champions.json[id]/armor et /magic_resist. Les croissances sont rapprochées de champion_growth_420.json[champion]/armor et /mr. Chaque propriétaire, pointeur et identité de fichier est vérifié. Les données et références historiques E sont conservées ; les fichiers courants F de mêmes octets sont comparés en taille/SHA et ne deviennent pas le même fichier par cette égalité.

Les exports Stats et leur MetaData.ResourcePath sont vérifiés séparément des INIBIN ; aucun SHA de JSON n'est attribué à un binaire natif. Les lots de D01/D06, leurs prérequis et les états des tâches requises sont conservés dans le relevé. Le pin du plan est fourni sous la clé plan attendue par le publisher ; aucun critère de sortie de lot ou de phase n'est accepté.

## Six cas de précision conservés

Attendu pour la comparaison analytique : conversion de la valeur native décodée en binary32 égale à la donnée courante. Observé : 482 correspondances exactes et six différences d'un ULP, toutes sur ArmorPerLevel :

| Champions | Octet natif type 2 | Analyse normalisée | Donnée courante | Hex little-endian analytique / courant |
| --- | --- | --- | --- | --- |
| Diana, Gragas, Jarvan IV, Yorick | 36 | 3.6 | 3.60000014 | 66666640 / 67666640 |
| Leona, Tryndamere | 31 | 3.1 | 3.10000014 | 66664640 / 67664640 |

Les six stockages sont relus à leurs offsets physiques. Les valeurs courantes concordent avec les vecteurs génériques byte31/36 du parseur original, sous MXCSR 0x0 et x87 CW 0x37f, conservés en V16. Cette preuve porte sur MeshSkin.SkinScale dans des fichiers synthétiques, pas sur un nouvel appel original ArmorPerLevel. Le reçu original-compressed-byte-precision.json, ses deux entrées de vecteur et son binaire de référence sont pinés. Le parseur original n'est pas réexécuté.

Les valeurs courantes sont conservées. Leur compatibilité avec cette ancienne observation générique ne qualifie pas le contexte FP historique du jeu, une formule de serveur ou tous les modificateurs. Les questions de fidélité existantes restent ouvertes et inchangées ; aucun UID étranger n'est inséré dans les fiches champion.

## Exécution fraîche du calcul courant

Un nouveau probe Rust est compilé et exécuté au code 0. Il appelle réellement Simulation::stats et compare les deux défenses en bits. La bibliothèque core V476 est réutilisée après contrôle de toutes ses entrées, outils et dépendances ; aucun rebuild du core. Bibliothèque : 278165670 octets, SHA-256 2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c. Le nouveau binaire, les commandes, scripts, logs et résultats sont pinés dans CURRENT_DEFENSE_OPERANDS.json.

Les valeurs attendues sont les expressions f32 actuelles avec les entrées déclarées. Elles ne constituent pas une formule indépendante du serveur Riot. Navigation synthétique 20x20, niveaux/inventaires/rangs/horloges/enregistrements d'effets injectés ; aucun monde avancé.

| Essais | Attendu local | Observé |
| --- | --- | --- |
| 122 champions, niveaux 1..18, quatre inventaires, Exhaust inactif/actif | Lecture des deux champs de défense, bonus d'objet et réduction locale de 10 | 17568 paires conformes |
| Niveaux injectés 0/19/255 | Facteur borné à 1..18 | 2928 paires conformes |
| Garen W rangs 0..5, niveaux 9/18, inventaires et Exhaust | Multiplicateur local sur les bonus d'items, pas sur base + croissance | 96 paires conformes |
| Annie E actif, expiré, joueur mort, rangs 0/6 | Bonus seulement dans le cas vivant, actif et de rang admissible | 80 paires conformes |
| Trundle R, tous les champions cibles, deux niveaux, inventaires et Exhaust | Ajustements opposés sur propriétaire/cible ; cas demi/complet, expiré, raw incohérent, propriétaire mort, même équipe | 11712 contextes, soit 23424 paires propriétaire/cible conformes |
| Joueur de statistiques absent | Panic courant, capturé dans le probe | Un message conservé ; pas de refus propre Result/Option |

Total : 44096 paires armure/résistance, soit 88192 comparaisons scalaires conformes. Les joueurs et le tick restent inchangés par chaque appel de stats.

Inventaires : vide ; 1029 (+15 armure) ; 1033 (+25 résistance) ; 1031 (+40 armure) avec 1033. Les objets sont injectés sans achat. Les cinq Effect1Level1..5Amount du GarenW natif sont relus et égaux à 20, comme les données courantes ; ce scalaire ne prouve pas toutes les conventions natives de bonus/base.

Annie utilise les règles locales pinées. Les enregistrements Trundle injectent des snapshots déclarés de 20 armure et 12 résistance, avec les montants raw 50/100 ou 51 pour le cas incohérent. Ces essais vérifient les branches de lecture et validation actuelles ; ils ne sont pas des casts, un relevé de combat d'origine, une simulation des pulses ou une preuve de réseau autoritaire.

Douze contextes Trundle sur Thresh retournent une armure négative, sans résistance magique négative. Exemple : niveau 9, inventaire vide, enregistrement complet, sans Exhaust : armure -4, résistance 18. Le résultat est conservé sans clamp à zéro ; il ne qualifie pas le passif complet de Thresh ni la mitigation des dégâts du moteur original.

Les combinaisons complètes de tous effets, runes, maîtrises, passifs, transformations, achats, casts, timing et ordre du serveur restent non qualifiées. Garen W et Annie E ont des séries séparées ; leurs états actifs combinés avec Trundle ne sont pas tous exercés. Aucun match ordinaire, exécutable de jeu original, rendu GPU ou audio.

## Contrôles du graphe et conservation

Le candidat est reconstruit depuis les quatre baselines. Les 42214 traces sont comparées : 488 changées, 41726 identiques. Les 489 contextes sont précontrôlés, dont SYS. Les 41725 autres objets tâche/trace, toutes les anciennes sources et tous les anciens consommateurs restent exacts, y compris le rôle Garen historique. Le document des questions reste identique, avec la formulation et l'historique V515 de SYS-04.1-01.

1506 identités sont vérifiées. Six refus d'inspection couvrent opérande absent/NaN/infini et mauvais noms de propriété. Cent vingt gardes propres à la livraison sur douze champs de Diana/Leona/Garen empêchent mauvais propriétaire, mauvais axe, consommateur manquant, alias inventé, précision masquée, fausse exécution originale, faux ordre natif ou achèvement, et mauvaise source. Deux refus du lecteur public couvrent une source inexistante pour chacun des nouveaux CID. Ces gardes restent distinctes des contrôles du lecteur public.

Le contrôle recalcule aussi le nombre de paires du reçu de runtime et compare les 88192 résultats attendus/observés, les douze armures négatives et les entrées de tâche de chaque champion. Les quatre registres et le pin du prérequis de plan sont vérifiés avant publication.

L'audit après intégration reconstruit les postimages à partir des baselines puis relit les deux bases via Store.task/copy_text et rt.resolve, en mode ro/query_only. Dans chaque base : 489 fiches vérifiées, 42117 autres lignes de catalogue exactes, 42606 états/notes et 23 historiques exacts, intégrité SQLite OK. Aucun état manuel n'est coché.

Les premières recherches exploratoires ont essayé BaseArmor/BaseSpellBlock et un fichier effects.rs supposé. Les vrais noms et le type spells::Effects ont ensuite été trouvés dans les sources. Ces lectures n'ont modifié aucun fichier du produit et ne démontraient aucune absence d'implémentation. Une tentative de patch de staging a aussi été refusée sur une ligne non trouvée, puis corrigée avant installation ; elle n'a modifié ni registre ni preuve existante.

## Livrables et limites restantes

Registres modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json. Le registre docs/fidelity_unknowns_4_20.json reste identique. Reçu : docs/reference_requirement_trace_sources/defense-operand-consumer-links-v516.json. Preuve : docs/fidelity_defense_operand_links_v516.json.

Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Documentation : ce rapport, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md ; versions précédentes sauvegardées, champs antérieurs conservés hors date/prochaine action.

Travail sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision516_inspection/OBSERVATIONS.json, revision516_runtime_checks/CURRENT_DEFENSE_OPERANDS.json et OBSERVED_DEFENSE_OPERANDS.json ; revision516/BASELINE.json, SOURCE_LINK_RECEIPT.json, PREPARATION.json, CANDIDATE_CHECK.json et DELIVERY_AUDIT.json. Les scripts revision516_inspection.py, revision516_probe.rs, revision516_runtime.py, revision516_delivery.py, revision516_check.py et le wrapper conservent les opérations exactes. Les commandes Python utilisent -X utf8 -E -u -B ; les logs et codes sont conservés à création exclusive.

Publication séquentielle des registres et des deux bases, sans transaction globale entre ces fichiers. Aucun code produit, lecteur du plan, asset ou pack modifié ; aucune ancienne preuve rejouée ou présentée comme fraîche. Trois sources supplémentaires et deux nouveaux CID ; aucune inconnue créée, précisée ou résolue. Les 17 sources auxiliaires justifiées V512 sont conservées.

Il reste 976 autres fiches de statistiques d'identité encore reliées seulement au data_loader : MOVESPEED, ATTACKRANGE, CRIT/CRITPERLEVEL, ATTACKDAMAGE/ATTACKDAMAGEPERLEVEL, ATTACKSPEEDOFFSET/ATTACKSPEEDPERLEVEL. Examiner leurs sources et consommateurs réels par chemin de calcul, sans déduire une capacité de jeu complète d'un champ ou d'un chargeur. Les écarts de maximum de vie V515, les défauts Mana natifs inconnus, les six écarts de croissance d'armure et les quatre écarts de ressource restent documentés.

Le Goal et SYS-01.2-02 restent actifs. Le nombre de liens n'est pas un pourcentage de jeu achevé.

Bilan : inspection, compilation/exécution du probe, préparation, contrôle candidat, publication et audit terminent au code 0. Graphe après intégration : 98733 sources, 2616 consommateurs, 25827 questions ouvertes, 5517 résolues avec historique. Les questions sont aussi identiques en octets à la baseline.
