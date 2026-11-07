# V1501 — Lulu : contrat connu de Pix

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LULU-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Lulu-PASSIF-SIMULATION-CONTRAT, exigence OLF-ad824a37-50b8-5fab-81ff-b66e6042964c, parent SYS-01.2-02. Audit de 34 branches connues ; SOURCE reste a_qualifier. Phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/lulu-passive-pix-links-v596.json du 26 octobre 2026 : 1443220 octets, SHA256 deee809f5a20da12cab7ff2221f07b207a2aa584e0f091ef6bb284a8e0e39c20. Rapport FIDELITY_LULU_PASSIVE_PIX_LINKS_V596.md : 19169 octets, SHA256 3306e3a677c42a0eb0e36319c2c94c6a536aaf50d7b154554a03262f9500f5c5. Son candidat déjà présent dans le cache correspond exactement au fichier ; aucune fausse absence déduite.

60 identités natives, 21 références communautaires séparées et 13 preloads. 29 Lua parcourus historiquement, sans prototype enfant : 25 initialisations littérales, 102 globals, quatre limites NEWTABLE (FaerieBurn4, FaerieShield16, QMissile12, QMissileTwo12). Limites du lecteur, sans corruption déduite. Deux CharScript littéraux vides, CharScript communautaire vide sans autorité serveur Riot.

24 clés en_GB distinctes vérifiées, 20 présentes. Quatre clés anciennes LuxBasicAttack/LuxCritAttack absentes, six lignes de bindings concernées ; aucune réécriture. Les quatre buffs sont résolus. Passif2232 : trois projectiles magiques guidés, interceptables par d’autres unités, dégâts totaux @f1@/@f2@ non résolus. Description4226 lie les attaques propres de Lulu. EShield2231 déplace l’assistance vers le porteur ; EBurn2230 révèle l’unité suivie à ses alliés. Missile11694 mentionne le champion suivi ; E11693 distingue unité alliée et bouclier de champion. Éligibilité exacte du porteur encore à qualifier. Q11695 impose un seul dégât par ennemi malgré deux origines, contexte distinct.

Passive/Run/Off/Spawn partagent BuffName et persistance sans règle de lifecycle démontrée. Anciens noms/icônes FallenAngel/LuluShred, Orianna/LuluShield, Malady/NautilusPassive, Sunfire et RunePrison conservés. Priorité3, popup Snared et IsDeathRecapSource ne prouvent aucun effet exécuté.

LuluFaerie déclare description Caitlyn, BaseDamage24, portée/hauteur de sélection chaînes0, rayon absent ; aucune formule de projectile déduite. Missile : vitesse900/portée25000 ; contrôleur1000/350, coefficient1.2000000000000002 et coût/recharge nuls distincts. Alias Ezreal/Ashe des ressources conservés, Q950/1000 distincts. Quatre DDF LuluQ dont spelldamage×0.133, sans formule passive adoptée. Six niveaux passifs absents ; six chemins candidats absents seulement. Preloads non assimilés à création/rendu. Aucun nouvel accès D:, F-work ou EXE ni décodage natif.

## 3. Consommateurs réels

28 entrées concordent avec V596 : 19 Rust, deux lecteurs Python et sept JSON ; avec en_GB, 29 identités vérifiées. 42 fenêtres dont 32 communes réutilisées, quatre récapitulatif, une familier Annie1–118, une géométrie linéaire1–208 et quatre vision23–204. 23 ancres dont 22 entry_boundary_only/provides_feature_consumer=false ; toutes les branches renvoient à une fenêtre.

Attaques/projectiles physiques, critiques, mitigation, pénétration, boucliers, vol de vie et crédit sont des acquis conservés. Learn/Cast/CastAt refusent Lulu. Les branches Garen/Trundle ne produisent pas Pix.

Annie crée explicitement annietibbers. Son entrée Pet contient owner, sans porteur distinct. tibbers() sélectionne propriétaire/expiration sans définition ; advance_pet_orders traite les entrées pet avec régénération/IA/téléportation Annie. Une future réutilisation pour Pix exige isolation ; aucun défaut reproduit ou défaut global du système existant revendiqué.

Le noyau linéaire fournit FirstContact/Pierce, tri des contacts et paramètres fournis par l’appelant ; sa direction fixe n’est pas un guidage, il n’applique ni dégâts ni éligibilité. Vision existante : rayons/LOS/équipes/Ignite/projection, sans transfert E qualifié. Récapitulatif par acteur, sans attribution Pix démontrée. Recherche Lulu/Pix sur 19 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer attaque propre, trois projectiles Pix, interception et transfert. Observé : 126/126 contrôles documentaires et 151/151 cohérences du même agent. Aucun nouveau build, test Rust, jeu, REA ou capture.

V596 hérité : deux parties publiques Map10 Lulu/Annie, base puis ouvrage1052 donnant20AP. AD46.36800003051758 inchangé, AP0/20. Six impacts physiques et six identités de projectile Lulu→Annie, sans critique ; mitigation/régénération dans la tolérance0,002. Aucun dégât supplémentaire observé, participants vivants niveau1, sans contrôle, mort ou fin de partie.

54 refus atomiques avec snapshots inchangés : commandes invalides et Learn/Cast/CastAt QWER avant attaques puis après attente. Rangs et recharges nuls ; Mana plafonné292.3999938964844. 180 ticks après Stop par cas, soit360 : observation locale, aucune durée passive native attribuée.

La précondition d’attaque ordinaire est exercée. L’absence de sort accepté n’explique pas l’absence de salve sur les attaques propres ; elle bloque séparément le transfert E. Salve/interception, porteurs, critiques/procs, classes de cibles et transport/rendu restent non qualifiés. Tome20AP ne résout pas la formule.

Exécutable identifié uniquement en données : 6039040 octets, SHA256 27280e4fc7f54185a056dc7a2c5ad0ef7f99ea71df96c0d1ce3eefb7f6e00dff. BUILD/RUN0 hérités, sans accès actuel ; chaîne/lock/1158 entrées non requalifiés. bootstrap01 avait repris à tort une liste de rapports vide : échec et script conservés, bootstrap02 qualifié réussi. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Restent création/isolation de Pix, déclencheur/salve, formules/partage, guidage/interception, cibles/porteurs/transferts/retour, Q, critiques/procs/récursions, défenses/attribution, concurrence/ordre/niveaux/contrôles/lifecycle et intégration/présentation.

Question propre OLU-de7e1432-6113-5a6b-9dfb-47d360031cf3 distincte de SOURCE OLU-253ae6a0-0d1d-5419-b904-49a346fbe68f. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

34 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-LULU-PIX-, suffixe -01 : METADATA, LUA, PET-SPAWN, PET-ISOLATION, ATTACK-TRIGGER, BARRAGE-SCHEDULE, DAMAGE-FORMULA, DAMAGE-SPLIT, PROJECTILE-HOMING, INTERCEPTION, TARGET-CLASSES, TARGET-LOSS, CARRIER-ELIGIBILITY, ALLY-TRANSFER, ENEMY-REVEAL, RETURN-EXPIRY, TRANSFER-INFLIGHT, Q-ORIGINS, CRITICAL, ONHIT-ITEMS, RECURSION, MAGICAL-DEFENSES, LIFESTEAL, ATTRIBUTION, RECAP, MULTI-OWNER, TICK-ORDER, RANKS-LEVELS, CONTROL, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios avec attaques publiques, trois vrais projectiles magiques, bloqueurs, E allié/ennemi et porteur observé ; aucun familier injecté pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_lulu_passive_simulation_contract_20261107. Date documentaire Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2487 entrées groupées préexistantes conservées. Prochain Lux depuis122 paires : 67 candidats hors55 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, aucune installation/migration.
