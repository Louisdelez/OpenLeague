# V1498 — Leona : contrat connu de Sunlight

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LEONA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Leona-PASSIF-SIMULATION-CONTRAT, exigence OLF-f39d325c-4bfa-5c77-8b08-5637091293fe, parent SYS-01.2-02. Audit borné de26 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/leona-passive-sunlight-links-v593.json du26 octobre2026 :1045894 octets, SHA256 c2b015f7aaee292046c5d3acc792e1a22699c2913da08cb97ae6f78919391b81. Rapport FIDELITY_LEONA_PASSIVE_SUNLIGHT_LINKS_V593.md :15688 octets, SHA256 ff3589804b90b658fb01de7181a7f0065a8ab19a19558c9ec8e784a9c162c795. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

27 identités natives,13 références communautaires distinctes, huit preloads sélectionnés. Neuf Lua entièrement parsés historiquement, zéro prototype enfant, neuf initialisations littérales et31 globals. CharScript/SolarBarrierTracker ont des initialisations vides ; aucune absence de callback serveur déduite. CharScript communautaire vide, sans autorité du serveur Riot.

Six clés en_GB présentes vérifiées. Description4220 : sorts infligeant des dégâts appliquent Sunlight3,5 secondes ; les dégâts de champions alliés consomment la marque pour ajouter des dégâts magiques. Buff cible2206 et passif2207 liés ; montant f2 non résolu. Aucun montant moderne ou communautaire adopté.

LeonaSunlightPassive est le passif permanent : nom/icône, PersistsThroughDeath et NonDispellable. LeonaSunlight, marque cible, ne porte dans les littéraux retenus que nom/icône. Persistance du passif distincte de politique de persistance de la marque ; champ absent ne devient pas false.

Q activation DoesntTriggerSpellCasts=false, attaque renforcée=true ; événements et preloads distincts, sans ordre serveur démontré. SpellToggleSlot2 de W reste une métadonnée, sans conversion automatique en index Rust. Le DDF contient quatre lignes SolarBarrier : bonusarmor0,2, bonusspellblock0,2, deux entrées vides. Son f2 appartient à SolarBarrier, sans mapping vers Sunlightf2.

Niveaux passifs bruts1/4/7/absent/absent/absent conservés, sans table de dégâts déduite. Quatre chemins candidats absents limités : CharScript existe sous Scripts, Sunlight globalement et tracker Lua présent. Dépendances de particules cibles/activation sont des déclarations, sans qualification visuelle/audio ou callbacks. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

27 entrées concordent avec V593 :17 Rust, deux lecteurs Python, huit JSON. Avec le miroir en_GB,28 identités gardées.34 fenêtres dont32 communes réutilisées ; ajouts annie.rs45–94 et annie_passive.rs1–25.23 ancres enregistrées dont22 entry_boundary_only/provides_feature_consumer=false ; tous les renvois de branches résolus.

Learn/Cast/CastAt refusent Leona. Attaques, stats/objets, target_info/équipes, dégâts physiques/magiques, pénétration, boucliers et régénération expliquent les contrôles ordinaires. Ils ne constituent pas une production/consommation de Sunlight.

Le Q allié d’Annie vérifie cible ennemie, portée, visibilité, mana et délai ; déduit son coût, arme son délai puis le missile appelle apply_damage Magical. Pyromania est un mécanisme propre à Annie : quatre charges, puis consommation offensive. Ces acquis restent présents. Trois Q par scénario ne produisent pas son stun et ne deviennent pas des procs Sunlight.

Recherche Leona/Sunlight sur17 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer application admissible, marque active, dégâts alliés, consommation et dégâts supplémentaires. Observé :91/91 contrôles documentaires,99/99 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V593 hérité : deux parties publiques Map10, Leona/Annie alliées équipe0, Ahri adverse équipe1. Second cas : Tome1052 acheté par Leona, AP0 puis20. Annie apprend Q publiquement ; aucune injection de santé, position, temps, rang ou marque. Positions centrales effectivement atteintes enregistrées.

Trois attaques Leona puis Stop, trois Q Annie par cas. Total six impacts physiques avec windup Leona→Ahri/release non critique et six impacts magiques avec missile Annie→Ahri témoin. Contrôles AD/armure et magie/RM/régénération dans la tolérance0,002. Q ordinaire80 bruts,60 mana,120 ticks de recharge ; aucun stun observé. AP du propriétaire Leona ne change pas les Q ordinaires d’Annie ; aucune conclusion de scaling Sunlight.

54 refus atomiques avant/après séquences : joueur inconnu, attaque d’un allié, slot invalide, Learn/Cast/CastAt Leona ; snapshots inchangés. Rangs/recharges Leona0, aucun sort dommageable accepté.416 ticks d’attente des Q et360 ticks après séquences ; participants vivants niveau1, sans mort/fin de partie, régénération ordinaire conforme.

Attendu du passif : vrai sort Leona appliquant la marque puis événement allié admissible la consommant. Précondition d’application absente ; les Q alliés frappent des cibles sans marque. Aucun déclencheur de consommation valide exercé, aucune expiration qualifiée par une attente sans marque, aucun test du montant f2 ou d’un scaling AP. Snapshots locaux, transport/HUD/animations/audio non qualifiés.

Exécutable V593 identifié uniquement en données :6048768 octets, SHA256 60a89121a40f100f33686b97b3cf4e84dff353a7c2b43a85e76f3120727593a7. BUILD/RUN0 hérités, sans accès/lancement actuel ; toolchain/lock/1158 entrées non requalifiés. Échecs antérieurs conservés.

## 5. Écarts et conclusions ouvertes

Restent formule f2, identités/permanence, admission et événements Q/W/E/R, état/rafraîchissement/propriétaires multiples, alliés/pets/DoT/Leona elle-même, consommation, durée3,5, dégâts/niveaux/AP/attribution, récursion/concurrence/ordre, lifecycle, intégration, réseau et présentation.

Question propre OLU-1a3d4eea-c7a0-5374-8fd8-e88df709e5dc distincte de SOURCE OLU-ef69d9f5-b1d7-5414-bf33-26eaf3c2341c. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

26 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-LEONA-SUNLIGHT-, suffixe -01 : SOURCE-DAMAGE, MARK-IDENTITY, SPELL-ADMISSION, Q-APPLICATION, W-APPLICATION, E-APPLICATION, R-APPLICATION, MARK-STATE, REFRESH-STACK, MULTI-OWNER, ALLY-ELIGIBILITY, PET-DOT, CONSUMPTION, LIFETIME35, DAMAGE-COMPOSITION, LEVEL-SCALING, AP-SCALING, CREDIT, RECURSION, SIMULTANEOUS, TICK-ORDER, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : véritable application par Q renforcé/W/E/R, consommation alliée et extra-dégâts, plusieurs niveaux/propriétaires/cibles ; contrôles sans marque, expirée, mauvais propriétaire/équipe, Leona elle-même, boucliers et refus. Pas d’injection d’état pour déclarer la fidélité. Aucun f2 d’une autre capacité réutilisé par son seul nom. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_leona_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2484 entrées groupées préexistantes conservées. Prochain Lissandra depuis122 paires ;70 candidats hors52 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
