# V1492 — Kayle : contrat connu de Holy Fervor

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KAYLE-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Kayle-PASSIF-SIMULATION-CONTRAT, exigence OLF-c451c3ca-c039-5b40-91da-a8e29903098d, parent SYS-01.2-02. Audit borné de22 branches connues : réduction des résistances, cumuls, contextes et limites. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/kayle-passive-holy_fervor-links-v587.json du26 octobre2026 :900010 octets, SHA256 47a42e98470c0b17f549dd4d069ee23d5742b9776bbbafc2d561beb877884d7d. Rapport FIDELITY_KAYLE_PASSIVE_HOLY_FERVOR_LINKS_V587.md :13093 octets, SHA256 a5772cbf2e2626a42f0700c0f28a9ffae40d8f52160a54fd3a48f0017c6d18d0. Liste de rapports du cache vide, mais MD existant retrouvé au chemin explicite et épinglé ; aucun cache modifié ni asset déclaré absent sur cette seule base.

Quinze identités natives aux rôles distincts, dix références communautaires séparées, trois preloads. Cinq Lua entièrement parsés historiquement, sans prototype enfant ; trois initialisations littérales et huit globals. Reckoning NEWTABLE pc14 et RighteousFury pc18 dépassent le lecteur littéral, sans corruption établie. Aucune exécution serveur ; CharScript natif et communautaire vides ne démontrent pas une mécanique.

Passive1LuaName=JudicatorHolyFervor ; PassLev1Desc1 lie directement la description4214. Six clés en_GB vérifiées, toutes présentes, dont quatre bindings de buffs. Description et buff2121 : quand Kayle attaque un champion, celui-ci perd3 % d’armure et de RM pendant cinq secondes, jusqu’à cinq cumuls. Les textes ne tranchent ni composition ni renouvellement ni ordre du premier impact.

Debuff2122 décrit des résistances réduites, Q2124 un ralentissement et E2125 une portée accrue avec splash. L’ancienne aura de vitesse d’attaque et les trois descriptions de régénération mana sont conservées sans remplacer la description liée. Six champs de niveaux absents, sans valeur inventée.

Buff Judicator_DivineBlessing.dds distinct du personnage/debuff Kayle_Passive.dds. Le buff déclare persistance/non-dissipation ; la métadonnée de persistance du debuff est absente, sans valeur false ajoutée. Preload Q citant le debuff ne prouve pas son déclenchement ; effets skin07 du preload E ne qualifient pas le skin de base. DDF8 lignes Q/E, sans formule passive ; coefficients de dégâts non assimilés à une réduction des résistances.

Trois chemins candidats absents dans l’inspection retenue, fichiers globaux du passif présents séparément : aucune absence universelle déduite. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

Vingt-cinq entrées concordent avec V587 : seize Rust, deux lecteurs Python, sept JSON. Avec le miroir en_GB,26 identités gardées. Trente-trois fenêtres dont32 communes réutilisées, plus Q Annie. Vingt-trois ancres enregistrées dont22 entry_boundary_only/provides_feature_consumer=false ; tous les renvois des branches aboutissent aux fenêtres contrôlées.

stats calcule les défenses depuis base, croissance, objets et modificateurs existants, dont l’ajustement Trundle. apply_damage consulte les défenses cibles, la pénétration et les boucliers. basic_attack_hit fournit l’impact physique ; Q Annie fournit le contrôle magique allié. Ces mécanismes partiels sont réels et conservés ; aucun producteur/cumul HolyFervor identifié dans ces chemins.

Learn/Cast/CastAt refusent Kayle, donc Q/E n’exercent aucun déclenchement. Lifecycle et départ sont des frontières statiques, sans qualification du cycle du passif. Recherche littérale Kayle/HolyFervor/Judicator sur16 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer attaque, application du debuff, résistances, cumul et expiration. Observé :86/86 contrôles documentaires,94/94 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V587 hérité : deux parties publiques Kayle contre Ahri, Annie alliée comme témoin magique. Cible de base20,879999armure/30RM ou défendue35,879997armure/55RM, après Cloth1029(+15armure,300or) et Cloak1033(+25RM,500or).

Chaque cas comporte six attaques Kayle successives, un Q Annie frappant14 ticks après la sixième, attente jusqu’à181, septième attaque et second Q. Quatorze impacts physiques avec windup/cible/release non critique, quatre projectiles AnnieQ source/cible identifiés. Mitigation ordinaire et régénération au tick prises en compte, tolérance0,002 ; armure/RM inchangées à chaque tick. Tous restent vivants et niveau1.

34 refus sans mutation, Q/E Kayle refusés. Attente seule167 ticks par cas,334 au total, distincte des180 ticks finaux par cas,360 au total. Checkpoints149/150/151/181 inspectés après la sixième attaque sur l’horloge locale. Ces observations ne qualifient ni expiration d’un debuff absent, ni plafond de cinq cumuls, ni renouvellement. Six attaques sans réduction ne prouvent pas le fonctionnement du plafond.

Exécutable V587 identifié uniquement en données :6059520 octets, SHA256 5fb07c28ffd802f24856ea915cd548535b59e8a1c480f265c50a6f7a164e8cba. Aucun accès/lancement actuel ; verrou, toolchain et1158 entrées non revalidés. Échecs antérieurs Katarina/Kassadin/stockage conservés, non rejoués ou reclassés.

## 5. Écarts et conclusions ouvertes

Restent événement de déclenchement, catégories, base/bonus/total des résistances, composition additive/multiplicative, plafond, refresh global/individuel, expiration, ordre du premier hit, pénétration/autres réductions, dégâts alliés, propriétaires/cibles multiples, annulation/retarget, Q/E/splash, limites numériques, lifecycle, intégration, transport et présentation.

Question propre OLU-e05f41b6-0b75-50dd-bc25-6340021a5cd4 distincte de SOURCE OLU-d1e4dbc2-5186-5f54-a3d4-e01744ffae8a. Dépendances/propriétaires conservés ; aucune inconnue fermée, V564/BattleTraining non corrigés.

## 6. Corrections et reprise

22 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KAYLE-HOLY-FERVOR-, suffixe -01 : TRIGGER-HIT, TARGET-CATEGORIES, AMOUNT-BASIS, STACK-COMPOSITION, STACK-CAP, REFRESH-POLICY, EXPIRY, HIT-ORDER, PENETRATION-ORDER, OTHER-REDUCTIONS, ALLY-DAMAGE, MULTITARGET, CANCEL-RETARGET, Q-TRIGGER, E-RANGED-SPLASH, NUMERIC, LEGACY-CONTEXT, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, fin positive distincte et reprise pour chacune.

Composition, base des résistances, refresh et ordre doivent être sourcés avant adoption. Reprendre sur source primaire/fournisseur nouveau, consommateur modifié ou cas indispensable non couvert. Futurs contrôles : debuff réellement appliqué, hits1à6, cibles séparées, horloges décalées et restauration des défenses ; aucune règle15 % ou0,97^n inventée à partir du seul plafond. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_kayle_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2478 entrées groupées préexistantes conservées. Prochain Kennen depuis122 paires ;76 candidats hors46 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucune installation/migration, aucun gain temporel mesuré.
