# V1496 — LeBlanc : contrat connu de Mirror Image

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LEBLANC-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Leblanc-PASSIF-SIMULATION-CONTRAT, exigence OLF-0c7fa8f6-818a-5749-b10a-417e4d8c6cf7, parent SYS-01.2-02. Audit borné de27 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/leblanc-passive-mirror_image-links-v591.json du26 octobre2026 :1499582 octets, SHA256 ca4875eb0394e50c57e748e1667697d22b96cabc3a87b886243e6c30d851bdef. Rapport FIDELITY_LEBLANC_PASSIVE_MIRROR_IMAGE_LINKS_V591.md :14960 octets, SHA256 8de7cfad2a90d7da1566820c6d364c347eda6f4a27b7be2d866505f4d208f8cd. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

14 identités natives, huit références communautaires séparées, quatre preloads. Six Lua entièrement parsés historiquement, zéro prototype enfant, six initialisations littérales et neuf globals. CharScript/MIFull/MIStealth ont des initialisations vides ; MIApplicator déclare la persistance. Aucune exécution serveur déduite. CharScript communautaire vide, sans autorité implicite du serveur Riot.

Quatre clés en_GB présentes vérifiées. Description4218 et buff2198 concordent : passage sous40 % de santé, invisibilité1 seconde, clone sans dégâts durant au plus8 secondes, recharge1 minute, contrôle Alt+clic droit. Ces textes ne résolvent pas toutes les politiques serveur, notamment égalité exacte, dégâts létaux, interruptions et réarmement.

BuffName=LeblancNoxianCruelty, icône LeblancMirrorImage.dds, persistance et Nondispellable. Le cooldown porte LeblancPassiveCooldown, icône LeblancMirrorImage_Charging.dds et NonDispellable avec une casse différente. Aucune normalisation silencieuse ; conséquence sur le consommateur historique ouverte. Titre Schism2199 lié au bon buff ; contexte NightmareBot non adopté.

Six niveaux passifs absents ; champs SpellData interrogés des deux INIBIN absents, sans défaut inventé. Six chemins candidats absents, dont DDF ; Lua/preloads réels restent présents. Dépendances de furtivité, images et mort sont des déclarations, sans callbacks/acceptation visuelle. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

32 entrées concordent avec V591 :18 Rust, deux lecteurs Python, douze JSON. Avec le miroir en_GB,33 identités gardées.38 fenêtres dont32 communes réutilisées ; ajouts : rayon/LOS/vision/projection, annie_r1–118 et movement1–81.25 ancres enregistrées dont24 entry_boundary_only/provides_feature_consumer=false ; renvois de branches résolus.

apply_damage applique mitigation, boucliers et santé ; la régénération ordinaire remonte naturellement la santé. visible_to/visible_point_to et snapshot_for expliquent visibilité/projection courantes. Learn/Cast/CastAt de LeBlanc restent refusés. Ces mécanismes réels ne constituent pas Mirror Image.

Le code de familier est un acquis distinct : la création invoque explicitement annietibbers, avec dégâts, ordres et expiration. La recherche tibbers, lignes23–25, filtre propriétaire/vie/expiration sans vérifier la définition. Réutiliser ce store pour des clones demandera une qualification d’isolation ; risque statique, aucun échec de clone reproduit. La correction MULTIPLE-CLONES couvre cette isolation. Fonctions Tibbers inspectées comme contexte, non comme appels de clone exercés.

Recherche Leblanc/MirrorImage/mirror_image/NoxianCruelty sur18 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer seuil, vrai déclenchement, clone, furtivité, expiration et recharge. Observé :98/98 contrôles documentaires,105/105 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V591 hérité : deux premières exécutions BUILD0/RUN non nul conservées. Pendant l’attente voie basse, offset1778, tick3774→3775, santé291,0956→272,2741 au lieu de régénérer ; trois Red_Minion_Wizard ciblent LeBlanc. Le snapshot ne désigne pas l’impact exact responsable. Aucune attribution inventée ni ancien échec transformé en réussite.

Reprise qualifiée par déplacements publics vers la zone centrale, z=7000 demandé, positions atteintes enregistrées ; mêmes durées/franchissements, contrôle supplémentaire d’absence de NPC ciblant les participants. Ancienne erreur de parenthèse du générateur d’inspection et copie sans script conservées séparément ; inspection ensuite0, aucun gameplay corrigé.

Deux parties publiques LeBlanc/Annie, base516HP puis Rubis1028 donnant666HP.11 puis13 projectiles Annie→LeBlanc témoins,24 impacts, quatre passages santé avant≥40 % puis après<40 %. Égalité exacte40 % non exercée. Après premier passage,attente1810 ticks avec régénération revenant au-dessus du seuil ; seconde séquence puis241 ticks, total4102 ticks d’attente.

À chaque tick : deux joueurs vivants niveau1, aucune mort/fin de partie, aucun NPC ciblant les participants ; aucune unité de définition LeBlanc ni familier possédé par elle observé ; original visible et présent dans la projection adverse. Cette recherche couvre les représentations exposées actuellement, pas toutes les représentations historiques possibles.

Offsets29/30/31,239/240/241 et1799/1800/1801/1810 encadrent1/8/60 secondes à30Hz locaux, sans qualifier l’horloge historique.54 refus sans mutation avant/après séquences. Aucun clone ni invisibilité observés ; recharge jamais armée, donc minute d’attente non probante. Sans clone actif, durée, contrôle et dégâts nuls ne sont pas vérifiés. Snapshots locaux, transport/UI/audio non exercés.

Exécutable qualifié V591 identifié uniquement en données :6124544 octets, SHA256 560aa21ef402b3388f3b6f015e94b0f23099402b0be9556cf15c958cd271a401. BUILD/RUN0 qualifiés hérités, deux RUN échoués distincts ; aucun accès/lancement actuel, toolchain/lock/1158 entrées non requalifiés.

## 5. Écarts et conclusions ouvertes

Restent métadonnées/casse, seuil/ordre/readiness, déclenchement unique, furtivité/révélations, identité/statistiques/placement du clone, commandes/IA, dégâts nuls, durée/récompenses, recharge/réarmement, santé maximale/niveaux, coexistence, persistance, lifecycle, ordre, intégration, réseau et présentation.

Question propre OLU-08bfdb44-e1fe-53de-b5ab-c94c8bbfe477 distincte de SOURCE OLU-72bce4c7-ad0a-5fbc-9e41-fab61bff5da8. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564 et limites BattleTraining non corrigés.

## 6. Corrections et reprise

27 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-LEBLANC-MIRRORIMAGE-, suffixe -01 : METADATA-BINDINGS, THRESHOLD, DAMAGE-ORDER, INITIAL-READINESS, TRIGGER-ONCE, STEALTH-DURATION, STEALTH-BREAK-REVEAL, CLONE-IDENTITY, CLONE-STATS, CLONE-SPAWN-COLLISION, CONTROL-AUTHORITY, CLONE-AI, ZERO-DAMAGE, CLONE-LIFETIME, CLONE-DEATH-REWARD, COOLDOWN, REARM, MAXHEALTH-LEVELS, MULTIPLE-CLONES, PERSISTENCE, OWNER-LIFECYCLE, SESSION-LIFECYCLE, TICK-ORDER, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : véritable proc public isolé des NPC, égalité/létal/boucliers, clone actif, commandes propriétaires, dégâts nuls, expiration et recharge réellement armée. Pas d’injection de clone/timer/santé pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_leblanc_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2482 entrées groupées préexistantes conservées. Prochain LeeSin depuis122 paires ;72 candidats hors50 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
