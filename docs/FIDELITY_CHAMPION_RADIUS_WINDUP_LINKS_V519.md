# SYS-01.2-02 — Rayons et préparation des attaques, V519

25 octobre 2026 ; F:\OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB, catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Goal actif. Cette livraison qualifie les liaisons de122fiches MOUVEMENT-RAYON et122fiches ATTAQUE-WINDUP ; elle ne termine pas ces champions ou le jeu.

## Résultat intégré

Les244fiches, auparavant reliées au catalogue général, reçoivent732liens vers les lecteurs précis :488pour les rayons (quatre par champion),244pour les windups (deux par champion).1 586requêtes natives sont explicites :773valeurs numériques présentes et813absences conservées. Aucun zéro ou fichier d’origine n’est inventé pour remplacer une absence.

Trois nouveaux CID :

| Fichier | Ligne | Rôle et limite |
| --- | ---: | --- |
| crates/core/src/collision.rs | 23 | Lecture du rayon de navigation avec gardes locales de finitude,positivité et maximum50 |
| crates/core/src/ally_occupancy.rs | 675 | Rayon de navigation lu pour préparer les corps du mouvement allié |
| crates/core/src/attacks.rs | 303 | Profil normal/critique, durée locale en ticks plafonnée à la cadence avant fixation de l’échéance |

Les trois anciens CID body_radius,target_info et profile_windup_ticks sont réutilisés sans modifier leurs rôles ou portées globaux. La sélection reste un contexte de contraste dans la fiche de déplacement : aucun consommateur de sélection n’est présenté comme mouvement corporel.

## Champs natifs et limites de fidélité

Pour chaque champion, PathfindingCollisionRadius,SelectionRadius et GameplayCollisionRadius sont interrogés dans sa définition native. Les122rayons de navigation et122de sélection sont présents ; seuls33rayons corporels sont présents. Les89absences corporelles restent nulles dans les profils. Le moteur applique alors65comme politique locale. Le repli40pour valeur corporelle non positive est visible dans le code ; il n’est pas exercé par les33valeurs natives présentes, toutes positives. Les getters publics de profils renvoient une panic sur un champion inconnu, distincte du refus Result de join.

Pour le windup, cinq champs normaux et les cinq champs préfixés CritAttack_ sont interrogés : AttackTotalTime,AttackDelayOffsetPercent,AttackCastTime,AttackDelayCastOffsetPercent et AttackDelayCastOffsetPercentAttackSpeedRatio. Les trois valeurs dérivées des122profils normaux et122profils critiques correspondent exactement au contrat numérique local contrôlé. Les constantes1.6,0.3,0et1des replis et l’interpolation/quantification locales ne sont pas déclarées règles du serveur Riot.

AttackTotalTime et AttackCastTime normaux sont absents pour120champions ; seuls Azir (1.6660000085830688 et0.25) et Kalista (1.519760012626648 et0.550000011920929) les portent explicitement. Les versions critiques de ces deux champs sont absentes pour les122champions. Les ratios sont absents pour117profils normaux et117critiques ; six offsets de cast critiques sont absents. Les sélecteurs gardent ces absences et les champs apparentés distincts.

Les recettes import_collision_profiles.py et import_critical_contracts.py sont relues comme textes de provenance locale. Le producteur initial de la table d’attaque normale n’est pas nouvellement retrouvé ou rejoué ici ; le vérificateur de formule locale, la table actuelle et le serveur historique sont des niveaux différents. Aucun parseur ou exécutable natif original n’est exécuté parV519.

Quatre identités actuelles F: (attack_contracts.json,collision_profiles.json et les deux recettes) sont ajoutées. Leurs octets correspondent exactement aux anciennes sources E: enregistrées ; les anciens IDs,chemins et preuves restent conservés. Il s’agit de localiser les entrées réelles du consommateur actuel, pas de nouveaux assets ou d’une réattribution de l’exécution passée.

## Contrôles réellement exécutés

- Inspection :122définitions,244fiches,1 586requêtes,ancres et fenêtres de code actuelles,profils et prérequis du plan. Les quatre registres restent exacts pendant la collecte. Quatre refus d’arguments numériques manquants/non finis/booléens sont ceux du collecteur, pas des APIs du moteur.
- Premier probe : compilation refusée au code1car deux champs internes,attack_roll et projectiles,étaient privés. Le source et le journal sont conservés dans revision519_runtime_checks ; aucun exécutable de ce premier essai n’est accepté.
- Probe corrigé : nouvelle compilation et exécution codes0 sur le coreV476,dont sources,entrées,bibliothèques,dépendances et outilchain sont vérifiés à l’identique. Aucun nouveau build du core. Les seules interfaces publiques sont utilisées. Chaque contexte d’attaque démarre dans une nouvelle Simulation avec session publique0 ; les objets critiques1018 et les trois emplacements de hâte3101 sont injectés selon le cas. Le premier tirage du SplitMix64 local fournit les branches attendues ; cela ne qualifie ni le générateur Riot ni des achats valides ou une requête réseau.
-366observations de champs de profils, dont89absences corporelles ;1 464lectures du getter public windup,avec cadences0,1,2,11,12,13,24,48,90,300,4294967295etU64MAX.126résultats du getter dépassent sa cadence argument : le getter impose un minimum1sans le plafond du caller. Les débuts d’attaque appliquent séparément min(cadence) ; ces deux contrats ne sont pas confondus.
-8 784débuts d’attaque effectifs :122champions×18niveaux×2configurations de hâte×2branches normale/critique. command(Attack) puis un vrai advance vérifient started,release=tick+durée,profil choisi et absence de dégâts au premier tick. Les deux branches n’ont pas nécessairement le même inventaire ou la même cadence. Les expirations,impacts,annulations,variantes,scripts et animations restent hors de ces cas.
-244contextes de portée utilisent chaque champion comme cible,avec le rayon corporel courant explicite ou le repli local65 : au bord,le windup démarre ; après marge extérieure200,il ne démarre pas et reste hors portée après mouvement.122placements de troisième allié vérifient l’écart minimal des rayons de navigation. Ces placements ne qualifient pas toutes les trajectoires,règles de blocage ennemies ou catégories de PNJ.
-Un champion inconnu est refusé par join sans changer les joueurs. Deux panics de getters publics inconnus sont capturées et consignées. La navigation est une grille plate synthétique100×100,Map10/interactions désactivés et visibilité contournée dans ce contexte ; aucun match ordinaire,réseau,GPU ou audio.
-Candidat :42 214traces comparées ;244changent et41 970restent identiques.41 969autres objets tâche/trace sont exacts.72refus sémantiques de propriétaire,champ,consommateur,absence et fausse autorité ; trois refus de source absente par le vrai lecteur ; deux sélecteurs invalides refusés pendant préparation. Tous245contextes sont contrôlés avant publication.

Le lecteur synthétique limite toujours la liste à trois consommateurs. Les122fiches de rayon en possèdent cinq après ajout : les deux suivants restent disponibles dans resolve et le reçu complet. Les listes natives condensées sont également abrégées. Cette limite est explicitement vérifiée ; le lecteur n’est pas changé pour ce lot et le texte condensé n’est pas présenté comme l’intégralité du graphe.

## Publication, conservation et preuves

Préparation,contrôle,publication et audit indépendant terminent au code0. Dans chacune des deux bases,les vrais Store.task/copy_text,rt.resolve et instructions vérifient245fiches (244+SYS),42 361autres lignes exactes,42 606états/notes et23historiques conservés,intégritéSQLiteOK. Les quatre registres sont sauvegardés avant écriture. Les publications de fichiers et transactions des bases sont séquentielles,sans atomicité globale revendiquée.

Sept sources sont ajoutées :le reçu,deux observations et les quatre identités F:. Trois CID,732liens et1 586sélecteurs natifs sont ajoutés,aucune ancienne entrée supprimée. fidelity_unknowns_4_20.json reste exact en octets :aucune question créée,précisée ou résolue. Graphe final :98 747sources,2 623consommateurs,25 827questions ouvertes et5 517résolues avec historique. Aucun code produit,lecteur,donnée de jeu,asset ou pack modifié.

Le rapport ne transforme pas la présence de champs,les conversions locales ou un début d’attaque en fidélité complète. Les anciennes limites de montage historique,précision f32,défauts Mana,santé,services,règles de gameplay et présentation demeurent dans leurs reçus. Les17consommateurs auxiliaires intentionnelsV512 sont conservés.

Fichiers du projet :docs/reference_requirement_trace_sources/champion-radius-windup-links-v519.json ; docs/fidelity_champion_radius_windup_links_v519.json ; présent rapport. fidelity_sources_4_20.json,fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json reçoivent les seuls ajouts du lot. Couverture,plan de complétion,reprise,CURRENT.md etHANDOFF.md sont actualisés après sauvegarde de leurs versions antérieures.

Travail et journaux :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision519* ; collecte initiale exécutée depuis E:\mapslol3v3\v519_inspection.py,copie identique archivée surF:. Options Python -X utf8 -E -u -B. Exécutables Rust,interpréteur,dépendances,sources et commandes sont pinés dans les reçus. Ne pas relancer la publication exclusive sans inspecter les marqueurs.

## Suite

Poursuivre SYS-01.2-02 avec les fiches CH-*-ATTAQUE-PORTEE,CH-*-ATTAQUE-CADENCE etCH-*-ATTAQUE-CRITIQUE : inspecter leurs vrais liens actuels avant tout ajout, réutiliser les sites précisément qualifiés des stats/rayons/windup si applicables, distinguer paramètres et règles de cadence/critique/passifs/variantes historiques. Ne pas recopier les simples data_loader comme preuve de fonction complète. Préserver V512–V519, les17auxiliaires,les critères/questions/cases/notes/historiques et le Goal entier.
