# V1502 — Lux : contrat connu d’Illumination

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LUX-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Lux-PASSIF-SIMULATION-CONTRAT, exigence OLF-4f209bc8-e9bd-5d4a-ab04-ae40b3aa9746, parent SYS-01.2-02. Audit de 32 branches connues ; SOURCE reste a_qualifier. Phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/lux-passive-illumination-links-v597.json du 26 octobre 2026 : 1205536 octets, SHA256 1f21dc5a6d6e407b2d61fa4ee811fa31df708ed016f834d622ce940a901acc72. Rapport FIDELITY_LUX_PASSIVE_ILLUMINATION_LINKS_V597.md : 16766 octets, SHA256 dd50a8283c9cf673631089eb7ae6e24ace4a8e5b48cdd570e61da3022a89bcca. Rapport existant retrouvé malgré la liste vide du cache ; aucune absence d’asset déduite.

37 identités natives, 20 références communautaires séparées, sept preloads. 14 Lua parcourus historiquement, sans prototype enfant : deux initialisations littérales, six globals, douze limites NEWTABLE (attaques0, marque8, Q14/Dummy0/Mis10, E6/Toggle2, R6/Mis6, W2). Limites du lecteur, sans corruption ou callback serveur déduit. CharScript natif littéral vide et communautaire vide, rôles distincts.

26 clés en_GB distinctes vérifiées, 16 présentes et dix absentes : six clés d’attaques et quatre SpellData du passif/marque. Les quatre bindings BuffData sont présents ; aucune substitution. 26 lignes de bindings SpellData vérifiées sans réécriture. Description4227 mentionne six secondes et niveau de Lux. Passif2241 : sorts infligeant des dégâts, marque six secondes, attaque de Lux causant @f1@/@f2@ magiques et consommant la marque ; variables non résolues. Marque cible2240 distincte du passif porteur. EEnd2239 et QMis2242 restent contextuels. R11700/9606 décrit déclenchement et rafraîchissement, sans ordre des événements établi.

Le passif porteur déclare DoesntBreakShields=false, DoesntTriggerSpellCasts=true, persistance et non-dissipation. Ces littéraux ne définissent ni interactions exécutées ni durée de marque cible. Les deux INIBIN passif/marque portent Coefficient/2=0, coût/recharge0, portée622.7000122070312, rayon100 et vitesse1400 ; zéro coefficient ne démontre pas zéro dégât.

R principal : coefficient0.75, recharge80, coût100, portée25000, rayon250. RMis : coefficient0.7000000000000001, recharge60, coût0, portée3500, rayon299.29998779296875. Vitesse3000 commune ; aucune fusion arbitraire de ces ressources.

Six niveaux passifs absents. Cinq chemins candidats absents, dont Lux.ddf au chemin inspecté ; aucune absence globale de DDF déduite. 26 fichiers NightmareBotLux exclus du contrat standard, sans qualification nouvelle de leurs contenus. Preloads et luxpassive_tar.troy restent dépendances, sans rendu accepté. Aucun nouvel accès D:, F-work ou EXE ni décodage natif.

## 3. Consommateurs réels

26 entrées concordent avec V597 : 17 Rust, deux lecteurs Python et sept JSON ; avec en_GB, 27 identités vérifiées. 39 fenêtres dont 32 communes, quatre récapitulatif et trois EzrealW (état1–62, buff182–211, nettoyage214–226). 23 ancres dont 22 entry_boundary_only/provides_feature_consumer=false ; renvois des branches résolus.

Learn/Cast/CastAt refusent Lux. Attaques/projectiles physiques, critiques, mitigation, pénétration, boucliers, vol de vie, crédit et récapitulatif sont des acquis conservés. Les branches Garen/Trundle ne produisent pas Illumination.

EzrealW actuel est Essence Flux4.20 : état par cible avec session/propriétaire/équipe/début/fin, bonus de vitesse d’attaque allié, contrôles de propriétaire Ezreal et nettoyage. Ses 150 ticks locaux et sa sélection du bonus maximal ne sont pas une règle de marque Lux. Ces gardes fournissent des exemples de structure ; aucune réutilisation fonctionnelle ou équivalence avec une marque d’une version récente n’est démontrée.

Recherche Lux/Illumination/Fraulein sur 17 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer application, disponibilité, consommation, expiration et R sur cible marquée/non marquée. Observé : 125/125 contrôles documentaires, 151/151 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V597 hérité : deux parties publiques Map10 Lux/Annie, base puis ouvrage1052 donnant20AP. AD53.54399871826172 inchangé, AP0/20. Six impacts physiques et six identités de projectile Lux→Annie, sans critique ; mitigation/régénération dans la tolérance0,002. Aucun dégât supplémentaire observé ; joueurs vivants niveau1, sans contrôle, mort ou fin de partie.

54 refus atomiques avec snapshots inchangés : commandes invalides et Learn/Cast/CastAt QWER avant attaques puis après attente. Rangs et recharges nuls, Mana plafonné334. 180 ticks après Stop par cas, soit360. Aucun sort Lux accepté et aucune marque appliquée : attaques ordinaires sans marque ne vérifient ni consommation ni formule. Attendre depuis Stop n’exerce pas l’expiration six secondes d’une marque réelle. R déclenchement/rafraîchissement non exercé. Tome20AP ne qualifie pas le coefficient passif.

Exécutable identifié uniquement en données : 6039552 octets, SHA256 94d0ce38507fc777d5f8526c05dc2620cbecab3c2ee96363e33c5859235a908f. BUILD/RUN0 hérités, sans accès actuel ; chaîne/lock/1158 entrées non requalifiés. Anciens échecs conservés ; aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Restent admission/éligibilité des sorts, état par cible/propriétaire, application/renouvellement/six secondes, consommation et annulations, formules/niveau/AP, R marqué/non marqué/ressources, E détonation, cibles/propriétaires multiples, défenses/critiques/procs, attribution, ordre/lifecycle et intégration/présentation.

Question propre OLU-3f8de764-c7d3-5017-b901-745e48dabb32 distincte de SOURCE OLU-218dcb80-5678-5efd-9819-73a70fbcd200. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

32 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-LUX-ILLUMINATION-, suffixe -01 : METADATA, LUA, SPELL-ADMISSION, SPELL-ELIGIBILITY, MARK-APPLICATION, MARK-OWNERSHIP, MARK-REFRESH, DURATION6, ATTACK-ELIGIBILITY, CONSUMPTION-BOUNDARY, REFUSAL-CANCELLATION, FLIGHT-TARGET-LOSS, DAMAGE-FORMULA, LEVEL-AP-SAMPLING, R-NO-PRIOR-MARK, R-CONSUME-REFRESH, R-RESOURCE-ROLES, E-DETONATION, MULTITARGET, MULTI-OWNER, MAGICAL-DEFENSES, CRITICAL, ONHIT-ITEMS, RECURSION, LIFESTEAL, ATTRIBUTION-RECAP, TICK-ORDER, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios avec vrais sorts publics, marque observée, attaque consommatrice, frontières six secondes depuis application et R marqué/non marqué avec rafraîchissement ; aucune marque injectée pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_lux_passive_simulation_contract_20261107. Date documentaire Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2488 entrées groupées préexistantes conservées. Prochain Malphite depuis122 paires : 66 candidats hors56 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, aucune installation/migration.
