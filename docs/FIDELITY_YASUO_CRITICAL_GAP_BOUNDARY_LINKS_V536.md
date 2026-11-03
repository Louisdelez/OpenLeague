# SYS-01.2-02 — Yasuo : écart critique et frontières réelles, V536

25 octobre 2026 — F:/OpenLeague. Ce lot relie les sources et consommateurs actuels. **Le passif n'est pas corrigé et reste non accepté.** Référence native PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ;fuseau/déploiement inconnus. Catalogue officiel4.20.1 en_US distinct,identifié par son fichier et son SHA.

## Résultat intégré au plan

Deux fiches, **CH-Yasuo-PASSIF-SIMULATION-CONTRAT** et **CH-Yasuo-PASSIF-SIMULATION**, relient trois entrées natives chacune à six frontières de code actuelles et aux diagnostics mesurés. **12 liens de frontières**, **6 nouveaux CID**, **6 arêtes natives** et **6 documents de preuve** sont ajoutés. Aucun nouveau code ou asset produit ;tous les anciens descripteurs restent exacts et aucun lecteur générique n'est reclassé globalement.

Une anomalie ouverte **OLU-3d44985d-0113-56a4-8aca-84bc19629ae7** est ajoutée **chez le parent SIMULATION uniquement**. Le contrat y fait référence sans l'adopter. Les deux anciennes questions propres,les trois occurrences de questions des dépendances et les trois dépendances sont conservées. La fiche SOURCE et les117autres contrats/parents restent identiques. Statuts,critères,acceptations,cases,notes et historiques sont préservés ;aucune question fermée.

## Attendu, observé et contrôles

La description officielle4.20.1 du passif indique le doublement des chances de critique et décrit un bouclier lié au déplacement. La comparaison ci-dessous couvre **seulement le doublement**,avec le composant courant1051 de8 % ;elle ne qualifie pas le comportement exécuté du serveur4.20.0.315.

Le diagnostic importe **le vrai crate openleague-core par chemin**,charge navigation et monde TT réels,joint Yasuo et Garen par l'API publique,vérifie les identités dans les snapshots et utilise **Simulation.command(Action::Buy/Action::Sell)**. Aucun champ joueur injecté ni donnée de source remplacée. Trente ticks normaux sont avancés après la jonction et après chaque opération ;Stats est ensuite lu publiquement.

| Tick | Étape | Attendu du catalogue4.20.1 | Observé dans le core |
| --- | --- | --- | --- |
| 60 | one_glove | 16 % | 8 % |
| 90 | two_gloves | 32 % | 16 % |
| 120 | one_glove_after_sell | 16 % | 8 % |

Valeurs exactes f32 conservées dans les JSON. Le témoin Garen obtient8 % avec un gant ;Yasuo et Garen partent de0 %. Le joueur inconnu est refusé avec « unknown player ». Collecte et contrôles réussissent ;**les trois comparaisons de doublement échouent**. Une collecte code0 ne signifie pas que le passif est accepté.

## Chemins actuels examinés

- critical.rs:12 :lookup du profil par champion dans le vrai JSON compilé. Les122profils ont chance0,croissance0,multiplicateur2 ;ces scalaires ne prouvent pas la présence ou l'absence globale d'un passif.
- progression.rs:92 :addition du profil,de sa croissance et des bonus d'objets,puis clamp0..1. Le résultat observé n'applique pas le doublement décrit dans les cas mesurés.
- shop.rs:241 :somme des chances de critique des objets réels de l'inventaire ;le1051 courant vaut0.07999999821186066.
- lib.rs:613/614 :dispatch public d'achat/vente ;lib.rs:685 :entrée du tick normal,réellement utilisée par le diagnostic.

Ces **six descripteurs portent provides_feature_consumer=false et qualification_kind=entry_boundary_only** :ils identifient le trajet de l'anomalie,ils ne déclarent pas une implémentation du doublement ou du bouclier. Les anciennes descriptions génériques restent conservées dans leur portée.

## Ressources natives et recherche des118contrats

Yasuo.inibin déclare Passive1LuaName=YasuoPassive et l'icône Yasuo_Passive.dds. Les valeurs absentes restent absentes. Les candidats natifs de la fiche SOURCE sont conservés avec leurs identités. Le chunk client YasuoPassive.luaobj relu possède des initialisations littérales et aucun prototype enfant/CALL/TAILCALL dans cette lecture. Cela **ne prouve ni récupération des callbacks serveur ni absence globale de leurs sources**.

La recherche qualifiée des118autres contrats conserve118questions propres et118références de questions SOURCE.175chunks natifs parsés,sans erreur,prototype enfant ou CALL/TAILCALL dans la sélection. Le premier balayage avait26mentions de quatre noms ;l'examen les a toutes situées dans des fixtures de test. La version qualifiée masque1139éléments de test et exclut198fichiers explicitement de test parmi1149fichiers Rust pinés ;zéro candidat de chaîne ID subsiste. Quatre diagnostics lexicaux synthétiques réussissent ;11attributs cfg de test composés restent signalés comme non traités.

Le masque lexical n'est pas un parseur Rust ni une preuve d'activation de configuration. Les chemins pilotés par JSON/RON,alias,macros,includes ou IDs dynamiques restent à examiner. **Zéro hit lexical n'établit aucune absence de mécanique.** C'est précisément la lecture des producteurs JSON et de leurs consommateurs qui a mené au diagnostic Yasuo ci-dessus. Les117autres contrats restent ouverts et inchangés ;aucune validation en masse n'en est déduite.

## Identités des diagnostics et dépendances

Le premier projet privé a réussi sa compilation et sa collecte avec **quatre versions de dépendances différentes du verrou racine** ;ses fichiers,résultats et logs restent conservés comme preuve initiale limitée. Un second projet privé a ensuite épinglé ces quatre versions hors réseau :toutes ses identités de dépendances appartiennent au Cargo.lock racine,à l'exception de son propre paquet diagnostic. Le troisième diagnostic utilise ce même sous-ensemble verrouillé et ajoute les ticks normaux.

Les builds utilisent --locked --offline. Le dernier réutilise l'artefact core validé (fresh=true) et compile seulement le nouveau pilote dans un exécutable distinct. L'exécutable,le manifeste,le verrou,la source et les artefacts du diagnostic précédent sont inchangés. Les1158entrées de code/ressources du core sont rehachées et exactes. Les journaux des opérations réelles sont identifiés dans chaque OBSERVATIONS.json. Ils ne sont pas relancés pendant cette publication documentaire.

- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe\cargo-target\debug\openleague-yasuo-source-probe.exe ;5410304octets ;SHA-256 f06d40b06196deb37372cf8c4179edf603529a99a7578e8ecc3096a8f61d3173.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-yasuo-source-probe.exe ;5410304octets ;SHA-256 bb0795ac31d89620ff71508dc49f3155b7b1de3e29ddf2899d4d0b0586f0fe21.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-yasuo-tick-probe.exe ;5967360octets ;SHA-256 eead663ce771e3040473237389c457b9c46ff648fe58c1e1ef589251f17887f4.

Aucun serveur local,client historique,VM Lua,GPU,réseau ou partie multiclient exécuté par ces diagnostics. Le binaire core utilisé est identifié depuis la sortie réelle compiler-artifact ;ce n'est pas l'exécutable livré du serveur. Les37tests CPU V534 restent des preuves héritées distinctes,pas un résultat de ces diagnostics ni une nouvelle exécution de V535.

## Contrôles de livraison et conservation

Le premier essai d'inspection refuse une ancre critical.rs décalée d'une ligne **avant tout changement de registre/base**. Le script et le log code1 sont conservés. La nouvelle inspection qualifiée utilise la ligne12 constatée. Le premier contrôle négatif a aussi interrompu le pilote sur StopIteration pour le faux propriétaire ;échec et pilote conservés. Un pilote privé qualifié rejette explicitement ce propriétaire avant la recherche,sans changer le candidat préparé ni les registres. Inspection qualifiée,préparation,contrôle privé qualifié,publication et audit séparé :codes0.

**26 faux constats refusés** :mauvais propriétaire,frontière manquante,lecteur générique présenté comme passif,zéro recherche déclaré absence,écart déclaré corrigé,bouclier ou passif accepté,serveur/natif fictif,observation ou SHA binaire altéré,dépendance supprimée et question enfant adoptée. Quatre refus du lecteur public couvrent consommateur/source absents,acceptation inventée et question du parent adoptée par le contrat.

Deux extraits de trace changent ;**42 213autres extraits exacts**, **42 212autres objets tâche/trace exacts**. IDs et hiérarchie identiques en octets. **31 703anciens objets inconnus identiques**,un ajout chez le parent. Dans chacune des deux bases :**3destinataires**, **42 604autres lignes catalogue**, **42 607états manuels** et **23historiques exacts**. Store.task,copie complète,résolution,dépendances,propriétaires,intégrité et sync normale idempotente vérifiés. Le texte copiable contient le constat précis,les résultats attendus/observés et les limites du bouclier.

Réexamen global après publication :**42 215exigences**, **98 819sources**, **2 770CID**, **527fichiers consommateurs actuels**,ancres et identités exactes,zéro divergence. **26 187questions ouvertes**, **5 517résolues**, **17auxiliaires conservés**. Les8 368fiches CH au seul chargeur partagé restent une file d'examen ;ce nombre ne mesure pas une complétion du jeu. Aucun nouveau recensement physique de toutes les98 819sources revendiqué.

## Limites ouvertes et travail restant

Le **doublement mesuré n'est pas corrigé**. Le bouclier de mouvement,sa génération,sa consommation,les autres niveaux,le plafond critique,les runes/maîtrises et les interactions n'ont pas été qualifiés ici. Les dégâts critiques et leurs règles particulières ne se déduisent pas d'une seule mesure de chance. Une règle du catalogue4.20.1 ne remplace pas l'exécution serveur historique4.20.0.315.

Les sources/consommateurs sont reliés dans leur portée ;la tâche SYS-01.2-02,les fiches Yasuo et le Goal restent **ouverts**. La liaison n'autorise aucune déclaration de champion ou de jeu terminé. Les autres sources,questions et preuves restent conservées.

## Fichiers et suite

- Modifiés :docs/completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,fidelity_unknowns_4_20.json ;trois lignes données/consignes dans chacune des bases projet et application de bureau.
- Reçu :docs/reference_requirement_trace_sources/yasuo-critical-gap-boundary-links-v536.json ;preuve :docs/fidelity_yasuo_critical_gap_boundary_links_v536.json.
- Inspection :revision536_yasuo_inspection_qualified/OBSERVATIONS.json ;sauvegardes/candidat/refus/audit :revision536_yasuo ;commandes revision536_yasuo_COMMAND_*.json/.log ;premier échec conservé.
- Diagnostics :revision536_yasuo_crit_probe,revision536_yasuo_crit_probe_aligned,revision536_yasuo_tick_probe ;recherche :revision536_other_passive_contract_discovery_qualified ;réexamen :revision537_trace_review/REVIEW.json.
- Couverture,plan documentaire,reprise,CURRENT et HANDOFF actualisés,avec sauvegardes et conservation de tous les anciens champs. Aucun code ou asset du jeu modifié,aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision537_trace_review/REVIEW.json et revision536_other_passive_contract_discovery_qualified/DISCOVERY.json.8368fiches CH au seul chargeur partagé restent une file de recherche,sans pourcentage ni absence inférée. Les117autres PASSIF-SIMULATION-CONTRAT restent à inspecter,notamment les chemins pilotés par JSON/RON,alias et macros que la recherche de chaînes ne couvre pas. Examiner les comportements Focus Ashe et Fury Tryndamere depuis leurs sources et leurs consommateurs exacts avant de proposer un lien ou un manque ;ne pas inférer l’absence depuis un profil critique générique. V536 Yasuo est publié/audité :6frontières/12liens et6arêtes natives,deux fiches reliées,écart8/16/8 contre16/32/16 % reproduit en API publique et après ticks,une nouvelle question chez le parent seulement. Le doublement n’est pas corrigé ;bouclier,plafond,autres niveaux et serveur historique restent ouverts. V535 quatre parents est livré et V53437tests hérités ne sont pas relancés. Ne pas republier les lots ni recompiler sans cause nouvelle. Préserver anciennes questions,statuts,critères,checks,notes,historiques,17auxiliaires et preuves de modèles/textures/rig/matériaux. Goal actif.
