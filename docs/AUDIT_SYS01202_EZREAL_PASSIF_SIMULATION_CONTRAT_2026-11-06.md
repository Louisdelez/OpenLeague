# V1469 — Ezreal : contrat connu de Rising Spell Force

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-EZREAL-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Ezreal-PASSIF-SIMULATION-CONTRAT, exigence OLF-56b95489-c06b-565e-9a30-8722a44cc849, parent SYS-01.2-02. Audit borné de dix-neuf branches connues : neuf contrats locaux V534 et dix relations de source/appels sélectionnées. Cela ne couvre pas toutes les branches historiques possibles.

SOURCE demeure partiel_a_terminer ; tâche, phase D06, six prérequis du lot, dépendances et inconnues conservés. Fonctionnalité, tâche complète et goal restent ouverts. Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/four-passive-local-branch-links-v534.json : 443091 octets, SHA256 c9116863627812751fdde3f6f38cd75bc63d962b9304de9aee2896592bf3f9ed. Rapport FIDELITY_FOUR_PASSIVE_LOCAL_BRANCH_LINKS_V534.md et association SOURCE dans champion-passive-source-partial-links-v533.json réutilisés, sans nouvelle publication de leurs anciens liens.

Membership natif hérité : DATA/Characters/Ezreal/Ezreal.inibin, 2475 octets, SHA256 df9e79cde5b2560bf9a834dfbb332517131fc1c1762aee30e55472169ac608bf ; membre sélectionné lol_game_client0.0.1.7 dans solution68. Aucun nouveau décodage ou accès à D:, F-work ou EXE.

Passive1LuaName désigne EzrealRisingSpellForceBuff, nom game_character_passiveName_Ezreal, icône Ezreal_RisingSpellForce.dds ; Passive1Desc contient une ancienne phrase d’Ashe. Champs/hashes bruts conservés sans autorité mécanique automatique. Les listes Ezreal de candidats INIBIN et Lua inspectés sont vides dans V533 ; cela ne démontre pas une absence globale d’assets ou de callbacks.

Quatre clés en_GB retrouvées dans le miroir identifié : lignes1894/1895/4184/4360. Description et catalogue indiquent +10% vitesse d’attaque pendant six secondes, cinq charges maximum. L’ancien tooltip du Buff indique15%/plafond75% ; l’autre expose @f1@. Ces rôles divergent sans preuve du fournisseur/binding effectif. Ne pas convertir l’ancienne chaîne en règle retenue ni effacer l’anomalie Ashe.

## 3. Consommateurs réels

Treize sources Rust et attack_contracts.json concordent avec V534 ; quinze identités gardées en incluant le miroir en_GB. Seize fenêtres, vingt ancres enregistrées : catalogue et dix-neuf composants réels partiels. Dix-sept descripteurs portent provides_feature_consumer=true ; les deux anciens points compteur/projection restent de vrais consommateurs. Aucun reclassement global en chargeur générique ou producteur absent.

ezreal_passive.rs conserve session, horloge, propriétaire/équipe/vie, plafond5, expiration partagée180ticks à30Hz, budget64propriétaires et historique32fautes. Le hook prune avant attribution ; overflow ou nouveau propriétaire hors budget refusés. Getter non mutateur : zéro après expiration, invalidité ou mort ; prune retire l’état invalide. Cap atteint : refresh commun conservé.

Q/W/E/R appellent réellement le hook : Q après dégâts acceptés, E après impact du projectile et non téléportation seule, R par contact accepté. W accepte dégâts ennemis ou buff allié/soi réellement livré et crédite uniquement le lanceur. L’appelant possède la consommation du contact ; le hook n’est pas un décodeur réseau anti-rejeu.

progression.rs ajoute0.10par charge au calcul de cadence avec croissance/objets/W/Exhaust, puis arrondi/plafonds locaux. Les nouveaux engagements d’attaque fixent cadence/windup ; projectiles déjà lancés suivent leur trajet ordinaire. Départ/réapparition retirent le propriétaire, fin/session/retour d’horloge nettoient ; prune précède Q/W/E/R puis autoattaques.

OwnerPassive ne contient que session/owner/stacks. snapshot_for appelle la projection privée validant propriétaire Ezreal vivant et équipe ; absence de timer/cible/position dans ce DTO. Transport, reconnexion et affichage ne sont pas exécutés ici.

## 4. Attendu, observé et contrôles

Attendu documentaire : sources, contrats, appels, cas et limites concordants. Observé : 63/63 contrôles documentaires et61/61 cohérences du même agent. Quatre opérations productrices journalisées réussies ; aucun build ni jeu relancé.

V534 du25octobre2026 conserve37tests CPU réussis, dont huit du module Ezreal ; l’un vérifie les composants AD, donc pas huit tests purs du passif. Identités et noms concordent aujourd’hui, sans revalidation des1158entrées,1147dépendances, toolchain ou binaire complet.

Fixtures héritées : impacts Q/W/E/R, bouclier absorbant totalement, refus de dégâts par défenseNaN, pas de charge au seul cast ; W allié et soi après repositionnement injecté ; cap/refresh/expiration avant impact du même tick ; cadence future sans retimer attaque engagée ; mort/session/départ et projection privée sans mutation. Scénarios de politique locale, pas parcours multiclient historique.

L’ancien sort libéré peut octroyer une nouvelle charge après retour à la vie du lanceur : choix local explicite sans life-token récupéré. Budgets/overflow/fautes sont inspectés statiquement, sans essai spécifique démontré. DamageOk peut retirer zéroPV après bouclier ; ni immunité complète ni toutes exceptions natives qualifiées.

Exécutable CPU V534 uniquement identifié en données :787789824octets, SHA256 8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97. Aucun accès ou lancement. La reprise sandboxée rendait Git nul ; TypeError du setup conservée, observation Git rétablie par reprise lecture seule autorisée, sans défaut du jeu inféré.

## 5. Écarts et conclusions ouvertes

Restent inconnus : autorité des chaînes/provider, callbacks et exceptions historiques, éligibilité précise par sort, W allié/soi, cycle ancienne/nouvelle vie, consommation/rejeu de tous les chemins, calendrier/refresh et composition native de vitesse. Budgets numériques locaux et toutes gardes ne sont pas entièrement testés. Projection privée locale ne vaut pas fidélité réseau/HUD.

Questions propres OLU-c1540cfc-d0e5-51f2-840a-5f7238e0b3f5 et SOURCE OLU-cf921841-cc56-565f-9a0d-7dd58f18d49a conservées chez leurs propriétaires ; aucune inconnue fermée.

## 6. Corrections et reprise

Douze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-EZREAL-RISING-SPELL-FORCE-, suffixe -01 : AUTHORITY, CONTACT-ELIGIBILITY, W-SELF-ALLY, OLD-LIFE, CONSUMPTION, EXPIRY, AS-COMPOSITION, CLEANUP, OWNER-BUDGET, CLOCK-FAULT, PRIVATE-PROJECTION, END-TO-END.

Chaque fiche a objectif, tâche liée, prérequis, travail, fin distincte et déclencheur de reprise. Reprendre sur source nouvelle, identité modifiée, appel nouveau ou cas nécessaire non couvert ; ne pas relancer les analyses inchangées. Corrections fonctionnelles et essais supplémentaires relèvent d’un périmètre autorisé distinct.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_ezreal_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ;2455entrées groupées modifiées préexistantes conservées. Prochaine sélection exacte FiddleSticks depuis projection122paires ;99candidats hors23unités nommées, aucun compte de tâches complètes déduit.

Audit borné terminé après examen des sept rubriques, sans clôture de la tâche complète. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés ; goal, Plan, interface, bases, registres, produit/assets inchangés. Zéro nouveau runtime/build/REA, installation ou migration.
