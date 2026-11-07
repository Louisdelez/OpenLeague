# V1514 — Nidalee : contrat connu de Prowl / Hunt

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-NIDALEE-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Nidalee-PASSIF-SIMULATION-CONTRAT ; exigence OLF-b8714313-7b7c-5947-b357-e496e5498b84 ; parent SYS-01.2-02. Audit de 44 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/nidalee-passive-prowl-links-v609.json du 26 octobre 2026 : 2829257 octets, SHA256 053eb62e2c4193a62375d6b2c71eb4fb46931c623c36ea875bcab542565e0936. Rapport FIDELITY_NIDALEE_PASSIVE_PROWL_LINKS_V609.md : 18482 octets, SHA256 f583c58b00d6e74b14e0b7154e441b037de18cd3e0e5275a369dc49f895ebfd4. Candidat du cache retrouvé aux mêmes octets.

72 identités natives : 33 INIBIN, 23 Lua, 14 preloads, un DDF, un font ; 33 références communautaires distinctes. source_roles contient 68 étiquettes par nom de fichier : quatre noms Cougar ont chacun deux chemins. Les huit identités restent séparées, SHA déclarés égaux par paire, priorité runtime inconnue.

Lua parcourus historiquement : douze initialisations littérales, 41 globals, aucun enfant/exécution ; onze limites NEWTABLE sans corruption déduite. CharScripts humains/Cougar et communautaire vides. Nidalee lie NidaleePassiveHunt ; Cougar partage nom/description/icône mais sans Passive1LuaName : aucune absence voulue de passif déduite.

Quinze clés en_GB vérifiées, treize présentes : onze BuffData dont neuf résolus, deux clés générales et deux SpellData supplémentaires. BrushPassive/Bushwhack restent absentes sans renommage. Texte : 10% en buisson pendant 2s, 30% vers champion ennemi visible à 5500 ; JavelinToss/Bushwhack déclenchent Hunt4s avec vision et avantages Cougar.

Buff2351 inclut Takedown/Pounce/Swipe renforcés ; description4240 et SpellTooltip11745 citent seulement les premiers Takedown/Pounce. Ces deux textes ont été comparés directement au font actuel identique. SpellDescription9651 vaut Prowl. CastRange5900 contredit la portée textuelle5500 ; sens de rayon/marge non choisi arbitrairement.

Six niveaux absents, anciens textes critique alliée/AttackRate10/15/20% non adoptés ; 32 lignes DDF vides ne deviennent pas zéro. Prowl/BrushPassive/Hunt/Hunted/Hunting/Scent déclarent noms, particules et persistance sans produire vitesse, révélation ou forme. Casse des noms de particules conservée. Cinq chemins candidats absents seulement, sans manque global d’assets établi.

Q communautaire a le projectile commenté, sans application Hunted ; W définit Pounce, pas la trappe humaine ; E soigne/délègue un buff ; R alterne un buff999999 sans conversion complète qualifiée. Aucun serveur original ou consommateur Rust adopté. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

32 entrées actuelles concordent avec V609 : 19 Rust, deux lecteurs Python et onze JSON ; avec en_GB, 33 identités vérifiées. 38 fenêtres dont 32 communes, mouvement1–82, vision1–220 hors tests, Navigation330–444, AnnieQ45–94 et occupation517–558/635–785. 29 ancres dont 28 frontières.

Navigation::load retient hauteur finie et flags NOT_PASSABLE ; l’octet exporté open ne détermine pas ici la praticabilité. flags/line_of_sight lisent les buissons ; visible_to/visible_point_to et snapshot_for filtrent la vision générique. snapshot_for_atomic conserve ses autres projections actuelles sans preuve de transport Hunt.

movement_speed compose base, boutique et modificateurs existants. stats.move_speed appelle ce même producteur, sans mesure indépendante. Caps220/415/490 reconstruits, historical_qualification=false ; leur ordre natif reste ouvert. Ces acquis ne produisent pas Prowl ou Hunt. Learn/Cast/CastAt refusent Nidalee. Recherche bornée sur 19 Rust : aucun Nidalee/Prowl/Hunted ; relevé639 fichiers hérité, sans recherche globale répétée ou relecture des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer buisson effectivement exercé, Hunt et transformation non exercés. Observé : 151/151 contrôles documentaires qualifiés, 150/150 cohérences du même agent. Cinq opérations : quatre réussites, un échec conservé. Aucun nouveau build, test Rust, jeu, REA ou capture.

contract01 a réellement échoué1 : mon contrôle assimilait 72 identités par chemin à 68 étiquettes par nom. Script et journaux conservés. contract02 remplace uniquement cette hypothèse, vérifie tous les noms et conserve les chemins. source_role_counts_qualification.json identifie les deux scripts et l’échec ; aucune source, règle native ou trace modifiée.

V609 hérité : deux parties publiques Nidalee/Annie, base/Bottes1001+25 vitesse ; vitesse335/360. Vivants niveau1, sans victoire/contrôle ; mana pleine, rangs/recharges nuls. Aucun déplacement, buff, dégât, niveau ou visibilité injecté.

Huit trajets mesurés aboutissent : 280 pas, 272 à pleine vitesse, 158 échantillons en buisson dont 76 vers un ennemi visible à moins de5500 et 82 en éloignement. Chaque pas respecte la vitesse ordinaire/30 à0,003 près. Aucun bonus Prowl observé ; le déclencheur buisson a été exercé, donc le refus des sorts propres ne suffit pas à expliquer l’écart. Aucun ordre natif des caps ou angle exact déduit de ces échantillons.

Quatre trajets de préparation, 244 ticks d’attente, deux Q Annie raw80/coût60 et 54 refus atomiques avec snapshots conservés. Correction de régénération sous0,002. Q Annie ne déclenche pas Hunt. Offsets59/60/61 ne sont pas l’âge d’un buff actif : aucune expiration Prowl/Hunt qualifiée. Aucun JavelinToss, Bushwhack ou changement de forme accepté ; Hunt4s, révélation et capacités Cougar renforcées restent non exercés.

Binaire seulement identifié en données : 6060544 octets SHA256 b0bf5b692d6ed620bc817b7a86cbb3e0d44b9e9feec15d1957ba8d67a21d5800. BUILD/RUN/inspection0 hérités ; chaîne, lock et 1158 entrées non requalifiés. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Direction/portée/visibilité, durée/rafraîchissement/cumul, ordre des modificateurs, producteurs Hunt, révélation, transformations, consommation des capacités et conflits Swipe/5500–5900 restent ouverts. Deux clés non résolues et priorité des ressources Cougar conservées.

Propre OLU-2434ccd8-379b-595f-be74-b2fd83d979dc distincte de SOURCE OLU-1ccc8866-e2ed-5df5-b7dd-e1cc28dfb52a. Propriétaires/dépendances conservés ; aucune inconnue fermée. Trajets réussis ne corrigent ni V564 ni les échecs Nami V606. Battle Training et anciens échecs non requalifiés.

## 6. Corrections et reprise

44 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-NIDALEE-PROWLHUNT-, suffixe -01. Objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise distincts. Elles séparent buisson/direction/portée/persistance, Hunt Q/W/vision, propriétaires/cibles, Takedown/Pounce/Swipe, forme/statistiques/ressources, interactions/lifecycle et chaque canal de présentation.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec bonus, marques et transformation sourcés ; aucun buff injecté ou conflit tranché par défaut pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves E:/mapslol3v3/audit_sys01202_nidalee_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2500 entrées préexistantes conservées. Prochain Nocturne depuis 122 paires : 54 candidats hors 68 unités nommées, sans compte global.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF avec sauvegarde/relecture ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
