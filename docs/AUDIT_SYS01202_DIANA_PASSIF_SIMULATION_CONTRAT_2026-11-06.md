# V1464 — Diana : contrat connu de Moonsilver Blade

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-DIANA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Diana-PASSIF-SIMULATION-CONTRAT, exigence OLF-b7bf668d-dbca-58ac-b7b6-c51b80548325, parent SYS-01.2-02. Audit borné de seize branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts ; SOURCE a_qualifier, phases/lots et dépendances conservés.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Aucune version récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/diana-passive-moonsilver-third-cleave-links-v563.json : 624539 octets, SHA256 a386d23575c330e1d207b2e60df6e659f703173e0393fa34842102d22fbc3473. Rapport FIDELITY_DIANA_PASSIVE_MOONSILVER_THIRD_CLEAVE_LINKS_V563.md : SHA256 efb330351b7d04d7de257e456ba17f37c632b551f4d0342951c67044c55e3025. Acquisition V563 réutilisée ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Treize identités natives, quatre Lua entièrement parsés historiquement, quatre vues littérales/six globals sans prototypes enfants. CharScriptDiana et DianaCombatBuff ont des vues vides qualifiées. DianaPassive et DeathRecap ont des octets identiques, mais leurs rôles restent distincts. BuffName, icône Diana_Passive_LunarBlade.dds et PersistsThroughDeath ne démontrent ni callback, ni récapitulatif, ni persistance réelle.

Quatre lookups en_GB portent sur trois clés uniques : deux bindings INIBIN au même tooltip, description et nom. Ligne1838 : vitesse d’attaque @f3@%, chaque troisième frappe infligeant en zone un supplément @f1@(+@f2@) magique. Description4178 concordante. Coefficients, échantillonnage et géométrie inconnus ; couleur du texte non convertie en ratio AP.

Passive1/Desc absents restent inconnus ; niveaux bruts1/4/7 puis absents, sans adoption. Deux preloads et trois BasicAttack INIBIN restent déclaratifs. Sept références communautaires conservées ; leur CharScript contient de la posture/animation, donc ni vide ni preuve du passif natif. Aucun nouvel accès D/F-work, natif ou ancien EXE.

## 3. Consommateurs réels

Vingt-huit entrées — dix-neuf Rust, deux lecteurs Python, sept JSON — concordent avec les identités V563 ;31identités courantes gardées. Cinq sélections JSON héritées ; movement_rules et collision_profiles sont deux dépendances courantes directes, pas des règles natives du passif ou du cône.

Trente-huit fenêtres :31communes réutilisées, sept supplémentaires pour profil d’attaque, point praticable, rayons, budget/préfixe/annulation de mouvement et test de segment. Vingt-cinq ancres couvrent catalogue et24frontières génériques, sans producteur Moonsilver qualifié.

lib.rs porte commandes/état/tick/snapshot ; progression.rs stats/AP/cadence ; attacks.rs windup et attaques ; lifesteal.rs impact Physical ; damage/world réception et catégories ; shop objets ; critical/shields/lifecycle mécanismes communs. ally_occupancy, collision et pillar_navigation portent les frontières de déplacement inspectées.

La cadence utilise croissance/objets/Trundle/Ezreal/Exhaust, arrondi et plancher12ticks ; aucun fournisseur Diana identifié dans cette formule. L’attaque ordinaire ne produit pas de compteur/cleave qualifié. Recherche textuelle bornée aux19Rust : zéro occurrence Diana/Moonsilver, sans preuve d’absence globale ni rejeu des1158dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, bindings, rôles et limites concordants. Observé :57/57 contrôles documentaires,67/67 cohérences du même agent ; quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V563 principal hérité : base/Tome1052/Dague1042, six impacts chacun,18Physical au total ; AP0/20/0, cadence48/48/42ticks. AD53.0400009, armure29.8799992, résidu maximal0.0000114441 après compensation de régénération. Troisième et sixième coups restent ordinaires. Tome435or/+20AP et Dague450or/+15%AS sont des témoins d’objets, pas des coefficients natifs Moonsilver.

Aux troisième/sixième coups, seconde cible à141.421356 de Diana et144.140930 de la principale, sans dégâts observés. Géométrie précédente273.588989 conservée séparément ; ces deux placements ne qualifient ni cône, rayon, orientation, obstacle ou toutes catégories.

48refus atomiques hérités : quatre joueur/cible/soi/allié et douze Learn/Cast/CastAt par cas. Ils ne sont pas des activations du passif. Binaire principal uniquement identifié en données :6041088octets, SHA256 c8865aaac145fb46a1ab78a81fd6fabcf1660a38b557b8cf4f76e140e2d22a85 ; aucun accès/lancement.

## 5. Écarts et échecs préservés

f1/f2/f3, événement compté, premier proc, reset/expiration, changement de cible, cadence/critique, effets à impact, boucliers, cible principale, catégories, ordre létal, crédit, persistance et vues restent ouverts.

Trois essais bleus V563 : build0/run101 avant combat, dont arrêts3305.1125/4214.1094 et3308.3494/5057.6084. Succès côté opposé ne les répare pas. Préfixe courant : segment_allowed précède TerrainBlocked ; cette branche peut vider path/destination et l’ordre. Sans premier tick d’annulation, segment réel, grille, cercles et budget, elle ne prouve pas la cause historique. Rayons pathfinding35 Diana/Garen et25.7666 Darius ne suffisent pas ; rayon gameplay absent distinct.

Ancienne inspection échouée conservée : script obsolète ciblant le dossier initial sans OBSERVATIONS ; correction d’inspection distincte, sans transformation des échecs en réussites. Aucune corruption de carte/asset déduite.

## 6. Corrections et reprise

Treize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-DIANA-MOONSILVER-, suffixe -01 : AUTHORITY, ATTACK-SPEED, COUNTER, COUNTER-LIFECYCLE, MAGIC-DAMAGE, GEOMETRY, TARGETS, PROC-ORDER, MODIFIERS, ATTACK-CYCLE, PROJECTION, NAVIGATION, VERIFICATION.

Chaque fiche possède objectif, tâche V563 réellement associée, prérequis, travail, fin propre et condition de reprise. NAVIGATION conserve les noms des tâches MOUVEMENT-RAYON/CHEMIN/BLOCAGE cités dans V563, sans requalification de leurs statuts. Reprendre sur source, dérive, contradiction ou trace précise ; correction fonctionnelle/exécution nouvelle sous autorisation distincte. Inconnues et prérequis SOURCE conservés.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_diana_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2450entrées groupées modifiées conservées. Prochaine sélection Draven depuis les122paires existantes, distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité, inconnues et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés ; aucun nouveau runtime, REA, rendu, audio, réseau ou logiciel installé.
