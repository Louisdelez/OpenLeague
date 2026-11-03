# SYS-01.2-02 — Impacts, resets et projectiles V521

25 octobre 2026 ;F:\OpenLeague ;référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45,fuseau et déploiement non établis. Goal actif. Ce lot relie des sources et consommateurs précis ;il ne termine pas les kits ou le jeu.

## Résultat intégré

300sous-fiches existantes sont traitées (122ONHIT,122RESET,56PROJECTILE),avec le contexte de vol ajouté à l’agrégat existant CH-Gnar-ATTAQUE :301fiches,293liaisons natives de contexte et539liens de consommateurs. Les mêmes champs partagés peuvent être liés à plusieurs champions ;ces nombres ne mesurent pas des fonctionnalités achevées.

Cinq anciens points de code sont réutilisés sans changer leurs rôles globaux. Six points précis sont ajoutés :

| Fichier | Ligne | Qualification |
| --- | ---: | --- |
| crates/core/src/attacks.rs | 257 | Engagement d’un projectile CPU normal ou critique ;composant partiel |
| crates/core/src/spells.rs | 165 | Armement de Garen Q sans reset du compteur à ce point ;frontière |
| crates/core/src/annie.rs | 71 | Annie Q efface le windup sans rééchelonner next_attack ;frontière |
| crates/core/src/ezreal_q.rs | 157 | Ezreal Q efface windup/cache sans rééchelonner next_attack ;frontière |
| crates/core/src/spells.rs | 120 | Refus courant des champions non pris en charge ;frontière |
| crates/core/src/trundle_q.rs | 152 | Consommation de l’armement après un impact Q partagé ;composant partiel |

Les122fiches d’impact reçoivent des composants partagés et deux exemples conditionnels Garen/Trundle, sans prétendre couvrir leurs passifs ou tous leurs effets à l’impact. Pour les resets,une fiche possède le reset partiel explicite Trundle Q ;121reçoivent seulement des frontières Q ou de refus des routes inspectées. Elles ne sont pas transformées en resets implémentés.

Les anciens liens de catalogue restent présents comme contexte de métadonnées. Le reçu et les contextes distinguent partial_component_ids,boundary_only_ids et retained_metadata_context_ids. Cette qualification fine est contrôlée par les gardes de livraison ;le lecteur générique n’en déduit pas une exclusion ou une acceptation de fonctionnalité. Aucune question artificielle n’est créée uniquement pour permettre une exclusion de portée.

## Sources et limites natives

Le composant partagé de vol de vie utilise PercentLifeStealMod de l’objet1053,relit dans son INIBIN natif et comparé au paramètre courant. Son emploi dans basic_attack_hit ne prouve pas tous les déclenchements,on-hit,ordres de callbacks,passifs ou exceptions d’objets. Le calcul local prend post_mitigation×life_steal avant limitation par bouclier/surplus de dégâts ;quatre cas entièrement absorbés par bouclier sont observés. Le surplus létal et toutes les catégories d’effets restent non qualifiés ici.

Les57profils principaux non-mêlée sont vérifiés par IsMelee et par les vitesses MissileSpeed des fichiers normaux et critiques effectivement choisis par les profils courants.293occurrences de champs (partagées entre fiches) sont présentes. La sélection des fichiers et les branches de repli restent locales ;elles ne prouvent pas la priorité des ressources ou les formes historiques.

Le reset Trundle Q est explicitement reconstruit. Les paramètres numériques natifs,le coefficient DDF choisi malgré son conflit avec Effect3 aux rangs1–4,l’armement8secondes et le ralentissement bref issu d’une reconstruction communautaire restent distincts. Le test des cinq rangs n’accepte pas ces politiques comme code serveur Riot. Pour Garen/Annie/Ezreal,les Q inspectés sont des armements/effacements de windup dont le compteur reste inchangé ;ce ne sont ni une qualification de tous leurs sorts ni une preuve d’absence de resets historiques.

## Lacune précise du plan : Gnar

Le générateur historique E:\mapslol3v3\Plan_granulaire_2026-10-20\build_plan.py utilise le prédicat data['stats'].get('attackrange',0)>200 pour créer les sous-fiches PROJECTILE. Seule cette expression AST est rejouée en mémoire sur le catalogue officiel ;le générateur entier,qui écrirait des anciens fichiers,n’est pas exécuté.

Le prédicat reproduit exactement les56fiches actuelles. Gnar a une portée de base recensée150 ;il est donc omis,alors que le profil courant et ses sources portent IsMelee=No et MissileSpeed=1500. Son vol CPU normal/critique est exercé dans les57profils. Les formes,la croissance de portée et la priorité historique restent à qualifier.

L’agrégat existant CH-Gnar-ATTAQUE reçoit les preuves et la lacune,avec pending_named_child_task=CH-Gnar-ATTAQUE-PROJECTILE,named_child_not_created=true et scope_gap_resolved=false. La nouvelle sous-fiche canonique n’est pas créée dans cette livraison. La correction additive du plan et de ses identifiants/compteurs/deux bases reste requise avant clôture du kit ;une note ou un vol local réussi ne la remplace pas. Le générateur est indexé comme source locale de découpage, sans autorité native prétendue.

## Vérifications réellement exécutées

- Inspection :301fiches,293requêtes natives,ancres et fenêtres de code,préconditions des phases/lots et prédicat historique. Les quatre registres restent exacts pendant la collecte.498sources Rust du client sont hachées et recherchées pour des accès directs au champ projectiles :zéro correspondance du motif. Cette recherche bornée n’épuise pas les consommateurs serde,générés,externes ou transitifs ;elle ne prouve pas globalement l’absence d’un renderer. Le consommateur graphique des tirs ordinaires reste à qualifier.
- Premier probe :compilation/exécution0 sur le coreV476 identifié. Un premier contrôle du candidat échoue ensuite au code1 :il comparait la vie attendue à l’impact à la valeur sérialisée deux ticks plus tard,après régénération. Le probe avait bien vérifié l’impact exact puis le suivi,mais son enregistrement mélangeait les instants. Le contrôle échoué et ses sources sont conservés ;les quatre pins de registres sont alors exacts,le publisher non démarré et les reçu/preuve publics absents.
- Probe final :nouvelle compilation/exécution0,avec santé et tick à l’impact enregistrés séparément de la santé après deux ticks de suivi. Les tests ne sont pas assouplis :égalité attendue/observée à l’impact et absence de nouveau dommage au suivi sont vérifiées chacune à leur instant. Core,entrées,dépendances et outilchain correspondent aux octets enregistrés ;aucun nouveau build du core.
-248contextes d’impact/vol de vie :normal et critique pour les122champions,plus quatre Garen/Ashe entièrement protégés par bouclier. Une simulation témoin sans attaque distingue la régénération de l’acteur du vol de vie. La santé observée correspond au calcul local attendu. Ce sont des composants partagés ;pas une validation de chaque proc de champion.
-570contextes de projectiles :57profils×2branches normale/critique×5situations. Vitesse et dégâts bruts au lancement,Stop après lancement,un pas vers une cible déplacée,puis disparition et santé à l’impact sont vérifiés. La mort du tireur avec entrée conservée permet le hit sans le ressusciter malgré son vol de vie ;le retrait administratif du tireur laisse le vol finir mais le hit échoue faute de source ;la mort ou le retrait de la cible supprime le vol. Ces observations sont celles du code local, pas des politiques natives ou réseau.
-944refus de cast pour118champions :quatre slots ciblés et quatre au sol,avec joueurs/tick conservés. Trois Q acceptés (Garen,Annie,Ezreal) laissent next_attack inchangé ;Garen conserve le windup,les deux autres l’effacent. Les rangs,mana,positions et autres paramètres sont explicitement injectés.
-10resets Trundle Q :cinq rangs,pendant windup et pendant récupération après libération. Le compteur revient au tick courant ;un recast immédiat est refusé sans mutation. Cinq impacts Q consomment l’armement et produisent les états locaux de buff/perte/ralentissement. Cinq cas distincts,avec saut explicite d’horloge jusqu’à expiration de l’armement et retrait des objets critiques,montrent que le reset a jeté le résultat critique antérieur. Aucun timing natif ou usage ordinaire n’est déduit du saut de test.
- Candidat final :42 214textes de traçabilité comparés ;301changent et41 913restent exacts.41 912autres objets tâche/trace sont identiques.210refus de livraison contrôlent notamment l’identité,les lecteurs,la distinction composant/frontière,les faux drapeaux natifs/rendu/acceptation,la promotion du catalogue et la fausse clôture de Gnar. Six sources de consommateurs absentes sont refusées par le lecteur public ;deux sélecteurs invalides le sont pendant préparation.302contextes sont précontrôlés.

Les cas tournent sur une grille synthétique plate100×100,avec Map10/interactions désactivés et visibilité contournée dans ce contexte. Items,rangs,mana,niveaux,déplacements,mort/retrait et certaines horloges sont des entrées de test. Aucun match ordinaire,serveur natif,AIR,réseau,GPU,audio ou acceptation humaine. Les NPC,bâtiments,formes et tous les déclenchements conditionnels ne sont pas couverts.

Le lecteur condensé garde ses trois premiers consommateurs :59fiches du lot ont des liens au-delà de ce plafond. Le graphe complet et les reçus sont vérifiés ;le texte condensé n’est pas présenté comme l’intégralité de la qualification.

## Publication et conservation

Le candidat final est préparé,contrôlé,publié et audité indépendamment au code0. Chaque base vérifie302fiches (301+SYS),42 304autres lignes exactes,42 606états/notes et23historiques conservés,intégritéSQLiteOK. Les vrais Store.task/copy_text,rt.resolve et instructions sont utilisés. Les transactions et écritures sont séquentielles ;aucune atomicité globale n’est revendiquée.

Quatre sources sont ajoutées :le reçu,deux observations et le générateur historique inspecté. Six CID et539liens sont ajoutés ;les anciennes sources,CID,critères,dépendances et questions sont conservés. fidelity_unknowns_4_20.json reste exact en octets :aucune question créée,précisée ou résolue. Le défaut de découpage Gnar reste dans le contexte et la prochaine action, sans faux identifiant de tâche déjà intégré. Graphe final :98 755sources,2 633consommateurs,25 827questions ouvertes et5 517résolues avec historique.

Les limitesV512–V520,les17auxiliaires intentionnels,les différences f32,les périodes Azir/Kalista,les ambiguïtés/replis d’animation,Gnar historique et le modèle effectif d’Ezreal restent conservés. Aucun code produit,lecteur,donnée de jeu,asset ou pack modifié.

Livrables du projet :docs/reference_requirement_trace_sources/champion-hit-reset-projectile-links-v521.json ;docs/fidelity_champion_hit_reset_projectile_links_v521.json ;présent rapport. fidelity_sources_4_20.json,fidelity_requirement_trace_4_20.json et completion_tasks_2026-10-20.json reçoivent les seuls ajouts du lot. Couverture,plan de complétion,reprise,CURRENT.md etHANDOFF.md sont actualisés après sauvegarde de leurs versions précédentes.

Travail :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision521_inspection,revision521_runtime_checks etrevision521_runtime_checks_retry,revision521 etrevision521_final. Les premiers essais restent intacts. Recette finale revision521_delivery_final.py,contrôle revision521_check_retry.py,lanceur revision521_command_runner_final.py ;journaux revision521_FINAL_COMMAND_*. Python -X utf8 -E -u -B ;interpréteur,binaires,dépendances,sources et commandes sont pinés. Ne pas relancer une publication exclusive sans vérifier ses marqueurs.

## Suite nécessaire

Corriger par migration additive la lacune nommée CH-Gnar-ATTAQUE-PROJECTILE identifiéeV521 :inspecter d’abord les identifiants stables,le registre de tâches,la traçabilité,le plan phase/lot/dépendances et les vrais lecteurs/deux bases avant tout ajout. Le générateur historique reste immuable ;reprendre les sources/consommateurs de vol déjà vérifiés et garder formes/priorité/rendu ouverts. Ajouter la nouvelle fiche sans état coché ni acceptation,en conservant tous IDs existants,cases/notes/historiques,preuves et agrégat ;réconcilier tous comptes et validations nécessaires. Ne pas republier V521. Poursuivre ensuite les liens encore génériques des chemins/blocages et kits,avec les frontières/limitations actuelles conservées. Goal entier actif.
