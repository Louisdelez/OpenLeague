# SYS-01.2-02 — Portée, cadence et critique des attaques V520

25 octobre 2026 ; projet F:\OpenLeague. Référence LoL PUBLIC4.20.0.315, EUW/en_GB, catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Goal actif. Ce lot traite la liaison des sources et consommateurs de366fiches, sans déclarer les champions ou le jeu complets.

## Résultat intégré

122fiches ATTAQUE-PORTEE,122ATTAQUE-CADENCE et122ATTAQUE-CRITIQUE reçoivent1 464requêtes natives explicites (1 253présentes,211absentes) et1 708liens de consommateurs :488pour la portée,366pour la cadence et854pour le critique. Les dix points de code existants réutilisés restent exacts,avec leurs rôles et portées d’origine. Quatre points précis sont ajoutés :

| Fichier | Ligne | Rôle courant et limite |
| --- | ---: | --- |
| crates/core/src/progression.rs | 96 | CritDamageBonus utilisé comme multiplicateur,plus terme d’objet,avec plancher local1 |
| crates/core/src/attacks.rs | 226 | Dégât brut ordinaire totalAD×multiplicateur critique,après exclusions Garen/TrundleQ locales |
| crates/core/src/attacks.rs | 292 | Décision du critique depuis le résultat conservé ou le générateur local |
| crates/client/src/animation.rs | 691 | Repli du rôle crit vers attack en conservant identité et âge lorsque crit est absent |

Le résultat est relié au reçu complet,au vrai resolve,aux instructions et aux deux catalogues SQLite. Aucun statut d’acceptation,critère,dépendance ou case n’est changé.

## Sources et écarts conservés

La portée lit AttackRange et le rayon corporel de la cible. Les rayons de navigation et de sélection sont interrogés comme contrastes, sans les utiliser à la place du corps. Les89absences de GameplayCollisionRadius et le repli local65 restent explicites. La convention de distance et les variantes/formes natives ne sont pas qualifiées par le succès du code local.

La cadence lit les ticks du catalogue issus de l’ancien pipeline offset officiel→arrondi Python,puis la croissance,les objets,les buffs et Exhaust avec arrondi/plancher Rust. Le producteur est lié à ses preuvesV517 héritées ; il n’est pas rejoué dansV520. Huit croissances d’attaque conservent l’écart de1ULP et la preuve générique antérieure de type2 ; aucun getter original de croissance n’est nouvellement exécuté.

Deux entrées natives explicites donnent une autre période que les ticks actuellement consommés :

| Champion | AttackTotalTime natif | round(30×période) | Ticks de base du catalogue actuel |
| --- | ---: | ---: | ---: |
| Azir | 1.6660000085830688 | 50 | 58 |
| Kalista | 1.519760012626648 | 46 | 48 |

Ce sont deux chemins d’entrée distincts. Leur différence ne suffit pas à prouver la priorité de cadence du serveur historique ni à autoriser une correction automatique. AttackTotalTime reste absent chez120autres champions.

Les122valeurs natives CritDamageBonus valent2 et sont utilisées comme multiplicateur,avec chance et croissance natives plus objets. Elles ne signifient pas «1+2» et ne qualifient pas les passifs ou exceptions de chaque champion. Le champ natif CritAttack est absent chez Braum et Vi ; le choix de leur fichier de critique provient du contrat local d’import conservé, pas d’un nouveau nom natif inventé.

La préparation et les annulations utilisent le cache privé du résultat critique. Le générateur courant est SplitMix64 ; ses règles ne sont pas celles du générateur ou de la correction de série Riot. Les effets GarenQ/TrundleQ et les structures suivent d’autres branches, qui restent distinctes du test ordinaire.

## Animation critique : consommateur réel et limites

Les122fichiers de sort critique sont relus pour SpellData.AnimationName. Le helper de présentation du client choisit un rôle local crit/attack depuis les faits reçus. Le renderer prend attack pour34champions dont le catalogue n’a pas crit, en gardant identité et âge. Il ne lit pas directement AnimationName comme clé de rôle à chaque attaque.

Les122GLB effectivement demandés par le client sont identifiés,hachés et leurs tableaux d’animations comparés au catalogue. Le constructeur Catalog remplace l’asset d’Ezreal par champions/ezreal_joint_identity_local.glb : le modèle par défaut ezreal.glb n’est donc pas supposé être l’entrée courante.

Une recherche exacte du suffixe natif retrouve67index uniques,identiques à l’index sélectionné. Les55autres restent non uniques au regard de cette règle ; ce ne sont pas55assets manquants. Les graphes,alias et variantes natifs peuvent encore déterminer la liaison correcte. Les noms,index et SHA ne prouvent pas les poses,la phase,la qualité visuelle ou le rendu.

Le document local critical_animation_bindings.json existait mais n’était pas indexé dans le registre ; il est ajouté comme preuve documentaire auxiliaire, sans origine native prétendue. Ses67liaisons et55cas ambigus restent exacts. Pour Gnar, son SHA de modèle historique diffère du GLB courant : l’ancien document est conservé,et la comparaison actuelle noms/index/SHA est séparée. Cette différence d’époque ne réattribue pas l’ancienne exécution au modèle actuel.

## Vérifications réellement exécutées

1. Collecte finale :366fiches,1 464requêtes natives,122GLB réels,ancres/fenêtres des lecteurs et prérequis du plan. Les quatre registres restent exacts pendant la collecte. Un premier collecteur s’est arrêté sur une faute de syntaxe avant exécution ;le second sur l’assertion d’appartenance au registre du document auxiliaire non indexé, avant toute publication. Les deux sources sont conservées ;la collecte finale utilise un nouveau dossier et n’invente pas cette appartenance. Quatre arguments numériques invalides sont refusés par le collecteur, pas par une API du jeu.
2. Nouveau probe Rust compilé et exécuté au code0. Il utilise le coreV476 déjà identifié,dont entrées,bibliothèque,dépendances et outilchain correspondent aux octets enregistrés ;aucun rebuild du core. Il compile également le véritable module de production crates/client/src/attack_animation.rs. Ce module std/core est exercé ;le système Bevy et le GPU ne le sont pas.
3.17 568contextes de stats :122champions×18niveaux×4inventaires×2états Exhaust.52 704comparaisons de cadence/chance/multiplicateur f32 passent, sans changement des joueurs par les getters.640observations atteignent le plancher de cadence12. Les données valides ne couvrent pas complètement le plancher de dénominateur0.05,le plafond de chance1ou le plancher de multiplicateur1.
4.366cas de portée utilisent chaque champion comme attaquant et comme cible :dedans,bord et dehors après marge200. Le résultat du vrai command/advance correspond au seuil attendu. La navigation est synthétique plate100×100 ;Map10/interactions sont désactivés et la visibilité est contournée dans ce contexte. Cela ne constitue pas un match ordinaire ou une géométrie native complète.
5.244séquences normales/critiques,avec session publique0 et objets injectés. Répéter le même ordre conserve les joueurs sans mutation. Une modification d’AS après le début change la cadence calculée mais ne rééchelonne pas l’échéance déjà stockée. La seconde attaque commence à l’échéance courante (ou au tick suivant une résolution qui l’atteindrait),puis programme la nouvelle cadence.130premières résolutions mêlée vérifient la vie après mitigation locale ;114lancements à distance vérifient les dégâts bruts et le drapeau critique du projectile. Toutes les interactions/impacts ultérieurs,passifs,formes ou variantes ne sont pas qualifiés.
6.242Stop acceptés annulent et remettent next_attack au tick courant. Après retrait des objets critiques,la reprise conserve le résultat critique mis en cache, malgré une chance courante nulle. Deux Stop de Kalista (normal et critique) sont refusés comme non annulables,sans changement des joueurs ou du tick. Ce comportement local n’est pas présenté comme politique historique d’annulation.
7.244sélections du véritable helper client vérifient rôle crit/attack,identité,origine et progression d’âge sans redémarrage. Les34replis du renderer et les catalogues sont inspectés comme sources ;aucune exécution Bevy/GLB de pose ou capture GPU nouvelle. Aucun réseau,AIR,serveur Riot,audio ou acceptation humaine.
8. Candidat :42 214traces comparées ;366changent et41 848restent exactes.41 847autres objets tâche/trace sont exacts.270refus de livraison couvrent mauvais propriétaire/source/consommateur,modification d’observation,fausse exécution native/rendu/acceptation,ambiguïté déclarée asset manquant,correction automatique de période,confusion de rayons et absence devenue zéro. Quatre sources de consommateurs absentes sont refusées par le vrai lecteur ;deux sélecteurs invalides sont aussi refusés pendant préparation.367contextes sont précontrôlés.

Le lecteur condensé garde ses trois premiers consommateurs. Les fiches complètes possèdent5liens de portée,4de cadence et8de critique en comptant le catalogue conservé. Le graphe resolve,le reçu et les contextes complets sont vérifiés ;le texte condensé n’est pas présenté comme la totalité des champs ou liens. Cette limite de lecteur reste ouverte pour une correction ciblée ultérieure.

## Intégration et conservation

Préparation,contrôle,publication et audit indépendant terminent tous au code0. Dans chaque base :367fiches vérifiées,42 239autres lignes exactes,42 606états/notes et23historiques conservés,intégritéSQLiteOK. Les lecteurs réels Store.task/copy_text,rt.resolve et instructions sont utilisés. Les fichiers et les deux transactions SQLite sont publiés séquentiellement,sans transaction globale atomique revendiquée.

Quatre sources sont ajoutées :le reçu,deux observations et le document local préexistant désormais indexé. Quatre CID et1 708liens sont ajoutés ;les anciennes sources,CID,critères et dépendances sont exacts. fidelity_unknowns_4_20.json reste identique en octets :aucune question créée,précisée ou résolue. Graphe final :98 751sources,2 627consommateurs,25 827questions ouvertes et5 517résolues avec historique.1 464requêtes qualifiées ne signifient pas1 464fonctionnalités acceptées.

Le bilan conserve les limitesV512–V519,les17auxiliaires intentionnels,les défauts de ressources,les différences f32 et les preuves d’origine. Aucun code produit,lecteur,donnée de jeu,asset ou pack n’est modifié. Les anciennes expériences natives et les anciens tests ne sont pas réattribués àV520.

Livrables :docs/reference_requirement_trace_sources/champion-attack-range-cadence-critical-links-v520.json ;docs/fidelity_champion_attack_range_cadence_critical_links_v520.json ;présent rapport. fidelity_sources_4_20.json,fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json reçoivent les seuls ajouts du lot. Couverture,plan,reprise,CURRENT.md etHANDOFF.md sont mis à jour avec sauvegardes.

Scripts,observations,logs et audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision520* ;collecte finale exécutée depuis E:\mapslol3v3\v520_inspection_final.py,copie identique archivée surF:. Python -X utf8 -E -u -B ;interpréteur,exécutable,dépendances et commandes sont pinés. Ne pas rejouer une publication exclusive sans inspecter les marqueurs et résultats existants.

## Suite concrète

Poursuivre SYS-01.2-02 avec122fiches CH-*-ATTAQUE-ONHIT,122RESET et56PROJECTILE. Comparer les56fiches de projectile aux57profils principaux actuellement non-mêlée et inspecter formes,flags et générateur du plan avant de corriger ou d’inventer une fiche. Relier les consommateurs propres réellement présents et leurs sources par champion,conserver les refus/branches non implémentées et inconnues de serveur/passifs. Préserver V512–V520,écarts de période Azir/Kalista,8croissances1ULP,55ambiguïtés d’animation/34replis locaux,Gnar historique distinct,Ezreal modèle effectif,17auxiliaires et tous critères/questions/cases/notes/historiques. Goal entier actif.
