# V1485 — Jayce : contrat connu de Hextech Capacitor

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-JAYCE-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Jayce-PASSIF-SIMULATION-CONTRAT, exigence OLF-eeacceef-6e3b-5519-bcce-40700282a1c4, parent SYS-01.2-02. Audit borné de dix-sept branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/jayce-passive-hextech_capacitor-links-v581.json du 26 octobre 2026 : 1170734 octets, SHA256 cdd05b959b236bd30f6821f3883ff934ef40c5114077f75d6a6b0f0b0fe94e54. Rapport FIDELITY_JAYCE_PASSIVE_HEXTECH_CAPACITOR_LINKS_V581.md : SHA256 6df8f92cc8231f2a0911f7eb6ec77359324eb8f8c889c41e5e51cf271be5cea7. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Trente-sept identités natives aux rôles distincts, quatorze références communautaires séparées et dix preloads. Seize Lua entièrement parsés historiquement, sans prototype enfant ; quatorze initialisations littérales et 89 globals. Deux transformations dépassent le lecteur littéral sur NEWTABLE pc14, sans corruption démontrée. CharScript vide et flags de sorts ne prouvent pas l’exécution serveur.

Quatorze recherches exactes en_GB : treize clés résolues, game_buff_tooltip_JaycePassive absent sans alias automatique. Les six bindings de buffs donnent cinq textes, lignes 2102–2106. Six bindings de transformation complètent description et nom du personnage.

Description ligne 4206 : 40 de vitesse pendant 1,25 seconde et passage à travers les unités à chaque Transform. Spell4=JayceStanceHtG ; les preloads GtH/HtG lient Haste et leurs formes. Attaques chargées mêlée magique/rangée avec réduction des défenses restent séparées. DDF40 entrées de sorts/formes, sans formule de vitesse du passif.

Passive1LuaName=GarenRecouperate, noms ApolloPassive/ApolloPassiveActive et JarvanIVDemacianStandard conservés sans adoption. Haste/Summoner_haste.dds ne qualifient pas Fantôme ; CastTime=0.115 des anciens managers ne définit pas la durée du bonus. Niveaux 1/4/7 puis champs absents ne deviennent pas une progression de vitesse.

Jayce_Passive.dds, JayceManOfTomorrow.dds, icônes des formes/attaques et 14.dds gardent leurs rôles distincts. Persistance/non-dissipation déclarées des formes ne prouvent pas leur cycle de vie. Preloads et métadonnées ne démontrent ni chargement effectif ni animation, VFX ou audio.

## 3. Consommateurs réels

Trente et une entrées concordent avec V581 : vingt Rust, deux lecteurs Python, neuf JSON. Avec le miroir en_GB, 32 identités gardées. Trente-huit fenêtres, dont 32 communes réutilisées et six sur vitesse, rayons, corps alliés, déplacement, Soin et admission des sorts d’invocateur. Vingt-trois ancres enregistrées, dont 22 frontières entry_boundary_only/provides_feature_consumer=false. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

Le dispatch cast ne prévoit aucun chemin Jayce accepté et renvoie « champion spell not implemented ». movement_speed applique base/objets et modificateurs actuels, sans terme Hextech identifié ; le budget de déplacement utilise vitesse/30. La sélection des corps alliés reste une règle géométrique locale. Soin dispose d’une échéance séparée.

Recherche littérale Jayce/HextechCapacitor sur vingt Rust sélectionnés : zéro occurrence. Pas d’absence globale ni d’inspection des 1158 dépendances revendiquée. Les politiques de Garen ne sont pas requalifiées par ce lot.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer déclencheur Transform, bonus écrit, contrôles vitesse/occupation et attaques chargées. Observé : 74/74 contrôles documentaires, 113/113 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V581 hérité : quatre cas publics vitesse, bottes 1001 et/ou Soin. Base 335 ou 360 ; Soin atteint 431.39996337890625 ou 457.39996337890625 puis retour à la base au tick 30. 240 ticks et vingt pas mesurés, résidu vitesse/30 inférieur à 0,005 ; Stop immobilise. Plafonds locaux historiquement non qualifiés et cooldown Soin 240/300 distincts du passif.

Transform slot 3 sans cible est refusé avant/après 60 ticks, snapshots inchangés. Les quatre cas comptent 70 refus publics. Attendre après un refus ne démontre pas l’expiration du passif ; aucun déclencheur natif exercé, aucune aura nulle déduite.

Quatre cas d’occupation Jayce/Garen : alliés bloqués à 65 unités, somme des rayons de navigation ; ennemis traversés par les deux, distances minimales respectives 4.3369140625 et 3.004350423812866, destinations atteintes à environ 250 unités au-delà du centre. Deux refus Transform supplémentaires : 72 refus publics au total. Les 72 associations invalides refusées par les anciens contrôles documentaires constituent une mesure distincte.

Traverser l’ennemi comme Garen ne démontre pas le passage temporaire de Jayce. Les 65 unités ne sont pas une portée native du passif. Aucune injection d’état ; transformations acceptées, bonus actif, expiration, annulation, autres niveaux et lifecycle non exercés.

Exécutable V581 identifié uniquement en données : 6056960 octets, SHA256 a039135e06e854df559892923f35fd8de2c1ebe95d4cff11af929e4d7d3ea297. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés. Preuve initiale Jax, correction du compteur et finisher échoué conservés, sans rejeu ni reclassement des échecs.

## 5. Écarts et conclusions ouvertes

Restent deux transitions de forme, déclencheur, intégration des 40 de vitesse, durée/arrondis, refresh/cumuls, unités traversables et sécurité en fin d’effet, composition, attaques chargées séparées, aliases, tooltip, icônes, lifecycle, synchronisation et présentation.

Question OLU-c9276e60-dc8f-5bc3-96f5-fcc016976aa5, dépendances et propriétaires SOURCE conservés. Aucune inconnue fermée ; déplacement V564 non corrigé.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-JAYCE-HEXTECH-CAPACITOR-, suffixe -01 : TRANSFORM-GTH, TRANSFORM-HTG, TRIGGER, SPEED, DURATION, REFRESH, BODY-PASSING, BODY-SAFETY, COMPOSITION, CHARGED-SEPARATION, ALIASES, TOOLTIP, ICON-ROLES, LIFECYCLE, NUMERIC, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_jayce_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2471 entrées groupées préexistantes conservées. Prochain Jinx depuis 122 paires ; 83 candidats hors 39 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
