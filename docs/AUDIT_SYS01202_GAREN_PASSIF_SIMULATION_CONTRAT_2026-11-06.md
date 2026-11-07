# V1475 — Garen : contrat connu de Persévérance

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GAREN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Garen-PASSIF-SIMULATION-CONTRAT, exigence OLF-091531f3-01fa-56ab-8b96-a534f2f9237e, parent SYS-01.2-02. Audit borné de quinze branches connues et de leurs consommateurs. Producteur partiel, six composants réels et frontière de table conservés. SOURCE reste partiel_a_terminer ; phase D06 et six prérequis du lot inchangés. Tâche complète, fonctionnalité et goal restent ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/four-passive-local-branch-links-v534.json : 443091 octets, SHA256 c9116863627812751fdde3f6f38cd75bc63d962b9304de9aee2896592bf3f9ed, daté 2026-10-25. Reçu SOURCE champion-passive-source-partial-links-v533.json et rapport FIDELITY_FOUR_PASSIVE_LOCAL_BRANCH_LINKS_V534.md réutilisés, identités dans initial_scope.json. Aucune nouvelle analyse native ou visite D:/F-work/EXE.

Quatre identités natives héritées : Garen.inibin, GarenPassive.inibin, GarenPassive.luaobj, CharScriptGaren.luaobj. Déclaration Passive1LuaName=GarenPassive, icône Garen_Passive.dds ; Passive1Desc absent ne prouve pas une ressource manquante. Le petit INIBIN lie game_buff_tooltip_GarenPassive ; deux chemins Lua ne constituent pas une exécution serveur.

Cinq clés en_GB vérifiées dans le miroir courant : tooltip principal/cooldown/heal, nom et description. Le tooltip dynamique mentionne @f1@, @f2@, @f3@, santé « every 5 seconds », niveaux 11/16 et exemption des monstres non épiques au niveau 11. Fournisseurs et valeurs effectives inconnus ; unité d’affichage de cinq secondes distincte d’une cadence runtime démontrée.

Le catalogue et la description en_GB donnent dix secondes et 0,4 % des PV maximum par seconde. data/4.20/garen_passive_rules.json donne niveaux 1/11/16, délais 9/6/4 secondes et taux 0,004/0,008/0,02. Sa provenance explicite est une republication nerfplz des notes 4.17 attribuées à Riot Pwyff ; historical_runtime_qualified=false. Ce conflit reste ouvert, sans adoption silencieuse ni nouvelle preuve primaire revendiquée.

## 3. Consommateurs réels

Vingt et une identités gardées : dix-neuf sources, table JSON et miroir en_GB. Dix-sept Rust et la table concordent avec V534. Les deux lecteurs Python sont comparés aux preuves communes antérieures, car V534 ne les épingle pas ; aucun faux membership V534 ajouté.

Trente-cinq fenêtres : 32 communes réutilisées et trois lectures ciblées du producteur, de ses tests et d’Exhaust. Huit ancres enregistrées : six composants partiels, une inclusion JSON entry_boundary_only non promue, un catalogue. Mécanismes génériques et vrai producteur Garen restent distincts.

garen_passive.rs:27 retourne zéro pour propriétaire absent, autre champion, mort ou match terminé. Sinon le délai saturating_sub strictement inférieur bloque ; la borne exacte autorise le taux multiplié par p.max_health stocké. join initialise le timestamp à None, donc activation locale immédiate.

note_garen_damage:42 ignore alliés, unités de lane et Kind::Monster à partir du niveau 11 ; Boss reste distinct. damage.rs:99 interrompt sur montant positif après mitigation, avant absorb_shields : un coup entièrement absorbé peut interrompre localement, contrairement au montant zéro. Les règles historiques exactes de boucliers restent inconnues.

regen.rs:42 ajoute le passif à la régénération de base, applique le modificateur de soins reçus, divise par TICK_RATE puis plafonne. record_enemy_ability_hit:68 reçoit seulement une cible : contrôle de fin/mort/identité, aucune source ennemie fournie. Le caller Exhaust:84 valide équipe, visibilité et autres conditions avant l’appel. Cela ne prouve pas tous les autres sorts.

## 4. Attendu, observé et contrôles

Attendu documentaire : conserver le producteur partiel et relier sources, appels, preuves et limites. Observé : 44/44 contrôles documentaires et 77/77 cohérences du même agent ; aucun nouveau build, test Rust, jeu ou REA.

V534 hérité : 37 CPU réussis, dont quatre Garen. Fixtures : seuils 1/11/16 avec horloge directe et borne exacte ; lane/Monster/Boss ; zéro, bouclier et événement ennemi explicite ; trente ticks de régénération après blessure manuelle, mort et fin. Les tests ne modifient pas max_health : leur nom ne prouve pas un achat d’objet ou une progression XP ordinaires. Réaffecter health n’est pas une réapparition publique.

Exécutable V534 identifié uniquement en données : 787789824 octets, SHA256 8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97. Aucun accès ou lancement ; 1158 entrées et 1147 dépendances non rejouées.

Cinq opérations documentaires, quatre réussies : bootstrap01 a échoué sur une hypothèse d’épinglage des lecteurs Python. Original et journaux conservés ; bootstrap02 change uniquement cette portée via bootstrap_reader_scope_qualification.json. Ce défaut de préparation d’audit n’est pas un échec du jeu.

## 5. Écarts et conclusions ouvertes

Restent autorité des délais/taux, fournisseurs dynamiques, variation réelle des PV max, interruptions/boucliers/sources, sorts non dommageables, composition/cadence, activation et transitions de vie, limites numériques, réplication et présentation. lifecycle inspecté ne réinitialise pas ce timestamp ; aucune conclusion native globale déduite.

Question propre OLU-8c1b4252-f1d9-5776-b42d-406d0cf9ce75 et question SOURCE OLU-3c5bee13-934e-5714-a170-a348e854f6fc conservées chez leurs propriétaires. Aucune inconnue ni preuve HUD/VFX fermée.

## 6. Corrections et reprise

Douze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GAREN-PERSEVERANCE-, suffixe -01 : AUTHORITY-TIERS, DISPLAY-RATE, MAX-HEALTH, COOLDOWN-BOUNDARY, SHIELDS, SOURCE-CLASSES, ENEMY-ABILITY, REGEN-COMPOSITION, LIFECYCLE, NUMERIC-LIMITS, PROJECTION, VERIFICATION. Chacune possède objectif, tâche liée, prérequis, travail, fin distincte et condition de reprise. Aucune enregistrée ou implémentée dans ce lot.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Une correction fonctionnelle nécessite son périmètre distinct autorisé.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_garen_passive_simulation_contract_20261106. Réutilisation appliquée selon acceleration_application.json : zéro lecture globale des registres, 32 fenêtres communes gardées, trois spécifiques. Aucun gain temporel mesuré.

Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2461 entrées groupées préexistantes conservées. Prochaine sélection Gnar depuis 122 paires ; 93 candidats hors 29 unités nommées, sans compte complet déduit.

Audit borné terminé après examen des sept rubriques ; tâche complète, implémentation et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans acceptation humaine ni revue indépendante. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés et vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation ou migration.
