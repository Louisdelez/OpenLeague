# V1467 — Elise : contrat connu de Spider Swarm

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-ELISE-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Elise-PASSIF-SIMULATION-CONTRAT, exigence OLF-8eb38a5d-af52-53d8-a0d8-1f5b79c86235, parent SYS-01.2-02. Audit borné de vingt branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts ; SOURCE a_qualifier, phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/elise-passive-spider-swarm-links-v566.json : 931402 octets, SHA256 5b5889504979d6e212461a79aed53daa7aed2ef79b3b04c6572f88825f1b18d7. Rapport FIDELITY_ELISE_PASSIVE_SPIDER_SWARM_LINKS_V566.md : SHA256 aaac9920222f40f73359f6ed758303513f2b3cd0d9c49990391a77492cfeade2. Acquisition V566 réutilisée ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Quarante-et-une identités natives ; trois configurations distinctes humaine/araignée/araignée invoquée. Portées brutes «550»/125/175, vitesses 335/345/345, slots humains Q/W/E/R et slots araignée SpiderQCast/SpiderW/SpiderEInitial/RSpider. Ces déclarations ne prouvent pas une sélection effective de forme. HP80 chaîne et dégâts0 du petit familier restent des valeurs brutes, pas ses statistiques finales qualifiées.

Vingt-cinq Lua complètement parsés historiquement, 96 globals littéraux, sans prototypes enfants. Vues PassiveSpawn/IsSpiderling/Fade vides qualifiées ; elles ne démontrent pas une absence d’événements serveur. Six preloads et quatorze références communautaires restent distincts du gameplay. CharScript communautaire vide, R communautaire limité à un marqueur/particule.

Trois clés en_GB retrouvées : tooltip, description, nom ; deux bindings V566 conservés. Lignes1853/4182 : touche d’un sort humain préparant une araignée, plafond f3 ; forme araignée invoquant les araignées contre les ennemis proches. f3 reste inconnu : Spider1..5 ne prouve pas plafond5.

Régénération alliée/Morgana et métadonnées Swain/Akali/Twitch conservées sans réécriture ni adoption. Persistance, bascule de slot et flags de dégâts ne sont pas des callbacks exécutés. Aucun nouvel accès natif, D/F-work ou ancien EXE.

## 3. Consommateurs réels

Vingt-six entrées — seize Rust, deux lecteurs Python, huit JSON — concordent avec V566 ; vingt-neuf identités courantes gardées. Sélections héritées : définitions/croissance/attaque/critique Elise, Tome1052, courbe XP et règles/définition Tibbers.

Trente-six fenêtres : 32 communes réutilisées depuis Draven, quatre supplémentaires pour fabrique d’unités, propriétaire/sélecteur de familier, cast/invocation Annie, ordres/aura. Vingt-cinq ancres couvrent catalogue et 24 frontières génériques ou Annie, sans producteur Spider Swarm qualifié.

spawn_unit exige une définition connue, initialise pet=None puis insère l’unité. enable_map10 enregistre annietibbers ; advance_annie_r le crée et installe son état Pet. Le dispatch public CastAt route Annie/slot3 vers cast_tibbers ; le corps interne n’est pas présenté comme possédant une garde Elise. Les autres chemins inspectés ne produisent pas une forme, réserve ou invocation Elise qualifiée.

combat_owner et tibbers parcourent les propriétaires ; les ordres, expiration, régénération et aura du chemin existant utilisent les règles Annie. Ces mécanismes ne deviennent pas les politiques natives des araignées par réutilisation. Rangs initiaux [0;4], award_experience événement serveur et snapshot restent des frontières distinctes.

Recherche bornée aux seize Rust : zéro occurrence Elise/Spiderling, sans preuve d’absence globale ni rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, formes, rôles et limites cohérents. Observé : 56/56 contrôles documentaires, 66/66 cohérences du même agent ; quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V566 public hérité : base/Tome1052, AP0/20, six impacts physiques isolés chacun, 34 refus atomiques, zéro familier Elise. Le rapport identifie un projectile du joueur précédant chaque impact. Aucun sort humain accepté ni forme araignée atteint : les autoattaques ne sont pas le déclencheur décrit. Zéro familier durant ces coups ne suffit pas à tester le passif après un déclencheur admissible.

Contrôles préparés séparés : award_experience(id,2525), niveau6, seuil Values.EXP.Level6 de la courbe actuelle. Elise : douze Learn/Cast/CastAt refusés, aucune invocation après120ticks. Annie : R non appris refusé, puis LearnR/CastAtR acceptés, un annietibbers appartenant à Annie. Cette XP n’est pas une progression ordinaire ; Tibbers n’est pas une araignée Elise.

Binaire historique identifié uniquement en données : 6068736 octets, SHA256 fc9546c19e9aa1d729a8e18a2bdb0e3df6ae2ddd3b3d37985b83ce0283e15cd9. Aucun accès, hash ou lancement.

## 5. Écarts et conclusions ouvertes

Restent ouverts : fournisseurs f3, touche humaine admissible/multiple, réserve/cap/overflow, rangs spéciaux, transition/profils/slots, consommation/refill, création et placement multiple, statistiques/scaling, IA/ordres/collisions, attaques/modificateurs, soin et relations W/leap/fade, cycle de vie, propriétaire/crédit et simultanéité.

Les noms de ressources ne définissent pas leurs événements. Les configurations humaines, araignée et familier ne sont pas fusionnées. Les métadonnées étrangères ne prouvent pas une corruption d’assets. Les refus Elise et le succès Annie préparé ne valident pas Spider Swarm.

Le défaut de déplacement V564 et ses diagnostics antérieurs restent distincts, non corrigés et non réaudités. Aucun audit SOURCE/HUD/VFX antérieur requalifié par ces contrôles.

## 6. Corrections et reprise

Quinze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-ELISE-SPIDER-SWARM-, suffixe -01 : AUTHORITY, FORM-STATE, HUMAN-TRIGGER, RESERVE-CAP, TRANSITION-SPAWN, PET-STATS, PET-AI, PET-ATTACKS, PET-SPELL-INTERACTIONS, LIFECYCLE, OWNERSHIP, HEALING, PROC-ORDER, PROJECTION, VERIFICATION.

Chaque fiche possède objectif, tâche V566 réellement associée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source précise, dérive, contradiction ou comportement supporté non vérifié ; correction fonctionnelle et nouvelle exécution sous autorisation distincte. Conserver les témoins Annie et les preuves publiques/préparées séparément.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_elise_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2453 entrées groupées modifiées conservées. Prochaine sélection Evelynn depuis les 122 paires existantes, distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité, inconnues et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés ; aucun nouveau runtime, REA, rendu, audio, réseau ou logiciel installé.
