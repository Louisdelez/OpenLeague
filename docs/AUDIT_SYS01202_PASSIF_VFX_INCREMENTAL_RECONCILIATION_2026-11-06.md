# Passifs VFX — rapprochement incrémental des audits publiés

6 novembre 2026 · V1442 · AUD-SYS-01.2-02-PASSIF-VFX-INCREMENTAL-COVERAGE-RECONCILIATION-01

## 1. Exigence et périmètre

SYS-01.2-02, OLF-3a11ace9-485c-55ae-8dff-2533902a5839 : relier exigences, sources et consommateurs courants. Lot documentaire limité aux122paires task/requirement PASSIF-PRESENTATION-VFX figées et aux sept livraisons V1435–V1441. Phase et prérequis conservés. Attendu : vérifier les correspondances, les preuves actives, les exclusions et les limites, sans recommencer les décisions inchangées.

Rapprochement documentaire terminé ; implémentation non réévaluée ; vérification statique et identités courantes ; acceptation humaine non donnée. Ce lot ne termine ni122fonctionnalités VFX, ni les champions, ni le goal. Aucun audit individuel supplémentaire n’est clôturé par agrégation.

## 2. Sources et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Identités natives héritées, aucun chemin D ni EXE ouvert.

Base publiée V1434 : result SHA921d99ece9df15ec53f0b8fe62c3b07e3dee830e9cea8ad2e0be5edbafd700b7 ; consolidation SHA6d187036cd0972d2aae8e4d2df0defb29e7bfef5bea0dd11445ab0bb8425e7d2. Ses115décisions sont conservées exactement dans les lignes correspondantes, avec leurs preuves et limitations ; leurs contrôles historiques ne sont pas rejoués.

Sept livraisons sélectionnées par les IDs exacts : AhriV1435, AlistarV1436, AmumuV1437, AniviaV1438, BrandV1439, CassiopeiaV1440 et ChogathV1441. Pour chacune : result/publication/post16/material, rapport UTF-8, sélecteur du paquet, preuves actives, corrections et inventaire relus avec empreintes. Les variantes qualified sont choisies par les affectations AST réelles du paquet, sans choisir arbitrairement un fichier vert. Soixante-dix-sept critères de livraison satisfaits.

Leurs analyses Lua, preloads, DDS, probes et scènes historiques restent des preuves héritées, avec leurs limites. Source/version/chemin ne deviennent pas automatiquement recette, comportement serveur ou pixels observés.

## 3. Consommateurs réels

Les325identités courantes sélectionnées correspondent :307chemins de la base et18chemins supplémentaires,254986272octets parcourus en streaming. Aucune dérive ni version attendue contradictoire. Les reçus sources des122lignes et les consommateurs de chaque décision sont couverts par ces identités ; liens et consommateurs enregistrés restent conservés.

Il s’agit d’égalité d’octets, sans nouveau décodage natif ou exécution des consommateurs. Aucun ancien ensemble1158dépendances ou binaire historique rouvert. Les325chemins ne sont ni un census global du dépôt ni une preuve OS/TOCTOU. Aucun rechargement des grands registres globaux.

## 4. Attendu, observé et contrôles

Attendu : une correspondance unique, attribuée et bornée pour chaque ID, ou un écart explicite. Observé : **122correspondances uniques, zéro ligne non rapprochée, zéro revue de livraison en attente** dans les entrées sélectionnées. V1434 en comptait115 :sept enregistrements publiés supplémentaires, pas sept nouvelles clôtures dans ce lot.

**18/18 contrôles documentaires,43/43 cohérences du même agent et sept rubriques relues.** Cinq productions Python journalisées réussies. Trois opérations historiques échouées restent conservées dans Alistar, Amumu et Chogath ; leurs qualifications ciblées ne sont pas réécrites. Anivia conserve aussi ses reçus et limites d’origine. Aucun runtime, build, capture graphique, analyse native, REA, GPU ou contrôle humain nouveau.

Les schémas de contrôle matériel hérités restent distincts :115MATERIAL_PINS et7MATERIAL_INPUTS. Un reçu de réutilisation Maokai demeure exclu du compte individuel ; trois rapports de famille antérieurs restent exclus. Les122unités ne sont comptées qu’une fois.

## 5. Écarts et inconnues

Toutes les inconnues, les sources enregistrées, les corrections et les limites individuelles sont conservées. Les anciens sept écarts de rapprochement sont supersédés par des correspondances documentées, sans suppression de leurs preuves antérieures ni changement de statut fonctionnel.

COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte. Les classes du snapshot V1322 restent103vues partielles,13sans vue mappée dans les reçus sélectionnés et6avec contexte additionnel non mappé. Elles ne sont pas réactualisées par ce rapprochement ; ce ne sont pas des comptes d’assets manquants. Applicabilité exhaustive, ressources/recettes, paramètres, états/réseau, rendu et acceptation restent régis par les clauses de chaque unité.

## 6. Corrections et reprise

corrections_and_restart.json conserve les sept correspondances ajoutées, les corrections individuelles et deux objectifs ouverts : fraîcheur/portée des projections secondaires et corrections fonctionnelles propres aux unités. Aucun ajout aux registres.

next_lot.json sélectionne Annie : confronter sa classe figée « sans vue mappée » à son audit VFX déjà publié. Identifier une adaptation de schéma récupérable par identité/pointeur ou le manque exact ; conserver les autres121IDs et la décision déjà clôturée. Réutiliser d’abord les reçus ; ne pas refaire une extraction native inchangée. Cela précise la fraîcheur de la projection, sans prétendre terminer un autre audit individuel.

Reprise seulement sur une clause nommée, une dérive, une nouvelle source/capture/callsite ou une comparaison de schémas nécessaire. Les travaux d’implémentation restent distincts et soumis au périmètre autorisé. Aucun gain de vitesse, ETA ou pourcentage de jeu terminé déduit de122correspondances.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_incremental_reconciliation_20261106 : contexte/reprise complète, contrat, scope, inspection des sept livraisons, identités, consolidation122lignes, cohérence, corrections, prochain lot et journaux. Scripts exécutés : bootstrap, inspect_deliveries, verify_current_identities, consolidate, review_coherence et prepare_documentation. Vérification d’identités root séparée des cinq producteurs journalisés ; même agent, sans revue indépendante.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2428entrées groupées conservées. Goal, Plan/UI, bases, code, assets et statuts inchangés. Seul ce rapprochement documentaire est clôturable.
