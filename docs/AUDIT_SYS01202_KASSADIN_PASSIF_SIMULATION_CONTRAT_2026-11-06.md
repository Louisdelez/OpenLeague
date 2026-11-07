# V1490 — Kassadin : contrat connu de Void Stone

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KASSADIN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Kassadin-PASSIF-SIMULATION-CONTRAT, exigence OLF-0049548d-accc-5816-9ded-06fdd137c529, parent SYS-01.2-02. Audit borné de19 branches connues : réduction magique et passage des unités, contextes et limites. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/kassadin-passive-void_stone-links-v585.json du26 octobre2026 :919473 octets, SHA256 7c3bd397f271c6d8cd7a7053e46f01d85664161d0859ab468a1a4d8064634fa6. Rapport FIDELITY_KASSADIN_PASSIVE_VOID_STONE_LINKS_V585.md :15538 octets, SHA256 86961d3492e1b7e3026a75804d6677635590d2e17a0e21c41649b77786614516. Liste de rapports du cache vide, mais MD existant retrouvé au chemin explicite et épinglé ; aucun cache modifié ni asset déclaré absent sur cette seule base.

Treize identités natives aux rôles distincts, neuf références communautaires séparées, trois preloads. Cinq Lua entièrement parsés historiquement, sans prototype enfant, cinq initialisations littérales et19 globals, sans exécution serveur. CharScript communautaire vide ne prouve pas une mécanique native.

VoidStone est nommé par le personnage ; PassLev1Desc1 lie directement la description ligne4212. Cinq clés en_GB vérifiées, toutes présentes, dont trois bindings de buffs. Tooltip2909 et description annoncent15 % de réduction magique et absence de collision avec les unités. Six champs de niveaux absents.

VoidStoneEmpowered ligne2910 décrit @f1@% de vitesse d’attaque ; son helper déclare le même BuffName, sans preuve d’adoption comme passif actif. NullLance ligne2404 décrit un bouclier magique du Q, distinct du multiplicateur passif ; son helper d’annulation ne prouve pas cette politique.

Rôles d’icônes conservés : personnage/helper Empowered Voidwalker_Netherburn.dds, buff Kassadin_VoidStone.dds, CharScript Teemo_EagleEye.dds, NullLance Averdrian_AstralBeam.dds. Persistance, non-dissipation et preloads ne prouvent ni callbacks ni présentation. Quatre chemins candidats absents dans l’inspection retenue, dont DDF et fichiers Empowered ; VoidStone global et helper AttackSpeedBoost identifiés séparément. Pas d’absence universelle ni valeur zéro inventée.

Résistance magique native30, croissance0 ; rayon de navigation35, rayon gameplay absent. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

Trente entrées concordent avec V585 : dix-neuf Rust, deux lecteurs Python, neuf JSON. Avec le miroir en_GB,31 identités gardées. Trente-huit fenêtres dont32 communes réutilisées ; six supplémentaires couvrent vitesse, rayons, sélection/routage/mouvement des alliés et Q Annie. Vingt-cinq ancres enregistrées dont24 entry_boundary_only/provides_feature_consumer=false ; tous les renvois des branches aboutissent aux fenêtres contrôlées.

apply_damage applique pénétration, résistance, réductions supportées et boucliers. mitigate conserve des branches typées magique/physique/vrai. Aucune contribution VoidStone identifiée ; MR et boutique constituent de vrais mécanismes partiels, conservés séparément du passif. Q Annie produit les impacts magiques témoins ; basic_attack_hit fournit le contrôle physique.

allies filtre par équipe ; route utilise ce filtre et advance_allied_motion construit des corps avec les rayons de navigation. Ces chemins expliquent les contrôles alliés/ennemis ; ils ne constituent pas une exception Kassadin. Terrain, piliers et corps gameplay restent distincts. Learn/Cast/CastAt refusent les sorts de Kassadin.

Recherche littérale Kassadin/VoidStone sur19 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer réduction passive, MR ordinaire, bouclier Q et politique de collision. Observé :91/91 contrôles documentaires,101/101 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V585 hérité : quatre simulations publiques Kassadin/Ahri sans/avec Cape1033, achat500or/+25MR. Huit impacts magiques Q Annie et huit physiques, avec témoins source/cible ;44 refus sans mutation et360 ticks après attaques. Aucune mort, progression de niveau ou bouclier actif observé.

Q brut80 : dégâts magiques corrigés de régénération conformes à80×100/(100+MR), soit61,5385 à30MR et51,6129 à55MR pour Kassadin comme Ahri ; résidu inférieur à0,002. Comparaison illustrative au facteur0,85 :52,3077/43,8710, écart9,2308/7,7419. Cela établit l’écart dans ces cas, sans qualifier l’ordre historique de toutes les réductions. Régénération corrigée après magie, avant attaques physiques ; contrôles physiques conformes au calcul ordinaire.

Quatre simulations de mouvement distinctes Kassadin/Garen : allié bloque les deux à65, destination non atteinte. Ennemi traversé par les deux ; distances minimales0,673828/3,004350 et destination250 atteinte. Passage générique non spécifique, sans acceptation de Void Stone ou des autres catégories d’unités. Somme de rayons de navigation, sans assimilation au corps gameplay.

NullLance n’est jamais lancé ; dégâts vrais, sbires, monstres, pets, déplacements forcés et embouteillages non exercés. Exécutable V585 identifié uniquement en données :6093824 octets, SHA256 56706f2ff59760215179c816a06feec36419c55770f6c7023341f85060f26806. Aucun accès/lancement ; verrou, toolchain et1158 entrées non revalidés.

Ancien CHECK initial code1 pour omission du nom NullLance dans la consigne SYS, puis livraison qualifiée conservée ; compteur rectifié avant première exécution de l’ancien script. Aucun ancien échec reclassé ou rejoué.

## 5. Écarts et conclusions ouvertes

Restent multiplicateur et ordre des dégâts, types/sources/arrondis, bouclier Q, catégories/équipes, corps mobiles/poursuite, terrain/rayons, contexte Empowered, icônes, lifecycle, intégration, réplication et présentation.

Question propre OLU-459008e0-536b-5dd4-9014-34a91a418e9c distincte de SOURCE OLU-3ace6b6f-f5d2-579e-966c-76e78fa4108b. Dépendances/propriétaires conservés ; aucune inconnue fermée, V564/BattleTraining non corrigés.

## 6. Corrections et reprise

19 propositions corrections_and_restart.json, préfixe COR-SYS-01.2-02-KASSADIN-VOID-STONE-, suffixe -01 : MAGIC-MULTIPLIER, DAMAGE-ORDER, DAMAGE-TYPES, NUMERIC, DAMAGE-SOURCES, SHIELD-COMPOSITION, UNIT-CATEGORIES, TEAM-COLLISION, MOVING-BODIES, CHASE, TERRAIN-SEPARATION, RADII, EMPOWERED-CONTEXT, ICON-ROLES, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION.

La relecture précise leurs19 critères positifs dans coherence_review.json/correction_finish_assessments, par identifiant stable. Exemples : mesure du15 % sur les hits publics isolés, passage d’un allié avec contrôle générique distinct, vrai Q accepté avant de qualifier son bouclier, terrain séparé des corps. Objectifs, tâches liées, prérequis, travail, fins distinctes et conditions de reprise conservés.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_kassadin_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2476 entrées groupées préexistantes conservées. Prochain Katarina depuis122 paires ;78 candidats hors44 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucune installation/migration, aucun gain temporel mesuré.
