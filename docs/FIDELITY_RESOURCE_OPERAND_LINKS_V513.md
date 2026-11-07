# SYS-01.2-02 — Valeurs de régénération de ressource et consommateurs conditionnels V513

25 octobre 2026. Projet actif : F:/OpenLeague. Cette livraison relie les sources et les points de code des 244 fiches MPREGEN/MPREGENPERLEVEL des 122 champions. Elle ne termine ni la tâche globale SYS-01.2-02 ni le jeu.

Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; date littérale 2014-11-17 17:46:45, fuseau et déploiement inconnus. Le catalogue officiel 4.20.1 et le client AIR 0.0.1.119 restent des identités distinctes.

## Résultat intégré

Les fiches conservent leurs sources natives, consommateurs, questions et références antérieurs. Deux nouvelles liaisons natives par fiche précisent le champ numérique et la recherche PARType, soit 488 liaisons. Une absence de PARType est enregistrée comme absence dans le fichier inspecté.

Le vrai consommateur courant possède deux rôles distincts dans crates/core/src/regeneration.rs :

- Ligne 19 : garde lifecycle::restores_resource, CID OLC-5658c9ae-9a25-51f8-9c23-2d333909a1d8. Cette frontière figure sur les 244 fiches ; elle ne suffit pas à démontrer la lecture d'un opérande.
- Ligne 20 : expression mana_regen + mana_regen_growth * factor, CID OLC-fc5967e7-9d4c-5814-bc3a-78b41120f81e. Elle est reliée uniquement aux 214 fiches dont la garde locale est active.

Les 30 fiches des 15 champions à garde inactive ne reçoivent pas de faux lien vers l'expression. Elles conservent la garde et l'observation du retour zéro. Total : 458 nouveaux liens vers deux nouveaux consommateurs ; aucun ancien rôle ou CID de santé réutilisé.

Le lecteur réel du plan expose ces précisions dans les instructions copiables et les deux bases locales. Les 244 textes de trace concernés changent ; les 41970 autres textes restent identiques. La tâche SYS reçoit le contexte de livraison, sans importer les consommateurs de gameplay dans ses propres liens. Les 245 contextes sont précontrôlés.

## Sources natives et données courantes

Les 122 fichiers de champion sous le deploy 0.0.1.68 sont relus sans écriture, avec leur identité déjà enregistrée. Champs : Data.BaseStaticMPRegen et Data.MPRegenPerLevel, plus la recherche distincte Data.PARType. Les exports Stats décodés et MetaData.ResourcePath sont rapprochés des fichiers natifs.

Les champs courants mana_regen/mana_regen_growth proviennent de data/4.20/champion_growth_420.json. La classification courante est lue dans data/4.20/champion_resources.json ; les gardes effectives sont dans lifecycle.rs. Le source_sha256 de champion_resources identifie le JSON Stats décodé, jamais son INIBIN natif.

Résultats pour les types :

- 102 Mana : PARType absent des fichiers inspectés, type Mana fourni par le défaut local. Le défaut du moteur historique n'est pas qualifié par cette observation.
- 5 Energy : type natif explicite et garde de régénération locale active ; les pourcentages d'items de mana ne s'appliquent pas dans le getter courant.
- 15 autres : type natif explicite, garde locale inactive. La chaîne native "None" de six champions reste distincte d'un champ absent.

Le contrat antérieur docs/reference_resource_hud_sources/resource_hud-links.json reste identifié et conservé. Les questions SYS sur les types conservent leurs propriétaires et leurs statuts ; aucune question étrangère n'est insérée dans une fiche champion.

## Précision : quatre écarts conservés

Sur 244 comparaisons de conversion des valeurs analytiques en f32, 240 sont identiques aux valeurs courantes. Les quatre autres concernent BaseStaticMPRegen pour Janna, Nami, Sona et Soraka.

Le stockage natif est de type compressé 2, octet brut 18. L'analyse normalisée puis convertie en f32 donne les octets little-endian 6666e63f ; la donnée courante donne 6766e63f, soit un ULP de différence. La donnée courante est conservée.

Cette valeur courante concorde avec une observation V16 du parseur compressé original générique sous contexte FP déclaré (x87 CW 0x37f, MXCSR 0x0). Cette preuve héritée porte sur un champ MeshSkin.SkinScale dans une entrée synthétique. Elle n'est ni une nouvelle exécution de ce parseur ni un appel original BaseStaticMPRegen. Identité conservée : E:/OpenLeague/docs/reference_native_skin_loader_sources/original-compressed-byte-precision.json, 901036 octets, SHA-256 be8f65c40698c26293f0697c39562f70f30c3575d195d09f9daa5af044784d20.

Aucun arrondi historique de gameplay, défaut natif ou équivalence serveur n'est déclaré résolu.

## Exécution fraîche du getter courant

Un nouveau probe Rust est compilé puis exécuté. Il appelle Simulation::regeneration_rates(...).resource_per_second avec un joueur isolé par champion, navigation synthétique 20x20 et niveau assigné directement. Trois inventaires sont injectés : vide, item 1004 (+25 %), item 3114 (+60 % selon les données courantes).

Attendu : calcul f32 du moteur courant, garde Mana/Energy locale et bonus d'items uniquement pour Mana. Observé :

- 6588 taux aux niveaux légaux : 122 champions × 18 niveaux × 3 inventaires, tous conformes à cet attendu local.
- 1098 observations aux niveaux 0/19/255, avec les bornes attendues.
- 122 identifiants de joueur absents : None, conformément au contrat courant.
- 107 champions à lecture active et 15 inactifs ; zéro pour chaque observation inactive, configurations identiques pour Energy malgré les items de mana.
- Aucun changement d'état du joueur ni de tick par le getter.

La bibliothèque core V476 est réutilisée après comparaison de toutes ses entrées, dépendances et outils. Ce n'est pas une nouvelle compilation du core. La bibliothèque de 278165670 octets conserve le SHA-256 2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c.

Compilation du probe et exécution : codes 0. Le reçu de runtime garde un libellé de schéma hérité suffixé /v512 ; son chemin, son script, son binaire, ses entrées et les observations resource de cette exécution V513 sont explicitement identifiés et pinés. Le fichier immuable n'est pas réétiqueté après publication.

Limites : aucun match ordinaire, monde avancé, achat d'item, Map10 activée, soin appliqué, timing serveur, GPU ou audio. L'attendu numérique vérifie le comportement local ; il n'est pas une formule indépendante récupérée du serveur Riot.

## Contrôles de liaison et conservation

Le contrôle candidat couvre les 42214 traces, 1497 identités d'entrée et les 245 contextes. Cinq refus de classification couvrent type courant manquant, défaut Mana abusif sur un autre type, désaccord d'un type explicite, NaN et infini. Cinquante-quatre refus propres à la livraison rejettent notamment mauvais propriétaire, champ santé substitué, défaut natif inventé, lien d'expression dans une branche inactive, écart de précision caché ou faux achèvement. Deux refus du lecteur public rejettent une frontière promue en fonctionnalité et une source de consommateur absente. Ces contrôles restent distincts.

Le contrôle candidat est enregistré passed=true. Son retour terminal a été perdu lors d'une troncature du contexte ; aucun code terminal n'est inventé et le contrôle à création exclusive n'est pas relancé. Le contrôle indépendant après publication compare les postimages au candidat construit depuis les baselines immuables.

Les 41969 autres objets tâche/trace, tous les anciens enregistrements de sources et consommateurs, et le document complet des questions restent exacts. Trois nouvelles preuves sont enregistrées, aucune question créée ou résolue. Les 17 consommateurs auxiliaires justifiés en V512, ainsi que les liaisons santé et la modification de lecteur V511, sont conservés sans nouvelle attribution de leurs anciens tests.

Dans chaque base du projet et de l'application de bureau : 245 fiches cibles vérifiées avec les vrais lecteurs Store.task/copy_text et rt.resolve ; 42361 autres lignes de catalogue exactes ; 42606 états et notes, 23 historiques exacts ; intégrité SQLite OK. Aucun état manuel n'est coché.

## Livrables et commandes

Fichiers publiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json ; le registre des inconnues reste identique. Reçu : docs/reference_requirement_trace_sources/resource-operand-conditional-links-v513.json. Preuve : docs/fidelity_resource_operand_links_v513.json. Bases : runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Aucun code produit, asset ou pack de distribution modifié.

Documents de couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md, avec sauvegarde des versions précédentes. Leurs champs antérieurs restent conservés hors date et prochaine action.

Travail détaillé sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision513_inspection/OBSERVATIONS.json ; revision513_runtime_checks/CURRENT_RESOURCE_REGENERATION.json ; revision513/BASELINE.json, PREPARATION.json, CANDIDATE_CHECK.json, SOURCE_LINK_RECEIPT.json, DELIVERY_AUDIT.json et contrôles documentaires. Les scripts revision513_inspection.py, revision513_runtime.py, revision513_probe.rs, revision513_delivery.py et revision513_check.py identifient le travail exact.

Le wrapper revision513_command_runner.py conserve les commandes complètes, logs et codes pour prepare, publish et audit. Chaque opération utilise le Python local avec -X utf8 -E -u -B. Les mutations sont séquentielles ; elles ne constituent pas une transaction globale entre fichiers et bases. Pas de republication nécessaire si l'audit confirme les postimages.

## Suite et limites restantes

Poursuivre les liens des opérandes de capacité de ressource BaseMP/MPPerLevel dans leurs vrais consommateurs. Examiner leur chargement, la croissance, les plafonds et la classification indépendamment des gardes de régénération ; une branche sans régénération n'implique pas une capacité nulle. Conserver les défauts natifs inconnus, les quatre écarts de précision et les autres questions de fidélité ouverts.

Les 25827 questions ouvertes ne sont pas un décompte d'assets manquants. Le nombre de liens ne mesure pas un pourcentage de jeu achevé. SYS-01.2-02 et le Goal restent actifs, sans acceptation d'un champion ou du jeu complet.

Bilan après relecture : prepare/publish/audit terminent au code 0. Les deux bases passent les contrôles décrits ci-dessus. Graphe : 98724 sources, 2611 consommateurs, 25827 questions ouvertes, 5517 résolues avec historique. Les 17 consommateurs sans lien actif sont exactement les auxiliaires justifiés en V512.
