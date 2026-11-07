# V1497 — Lee Sin : contrat connu de Rafale / Flurry

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LEESIN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-LeeSin-PASSIF-SIMULATION-CONTRAT, exigence OLF-74902db4-cbc2-529c-9ac9-63534000d9cc, parent SYS-01.2-02. Audit borné de24 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/leesin-passive-flurry-links-v592.json du26 octobre2026 :1048053 octets, SHA256 9b0ab6f17faa4fdf61e555b576c682f5f352c529b02c724fc3d3c2ff401e2a15. Rapport FIDELITY_LEESIN_PASSIVE_FLURRY_LINKS_V592.md :15446 octets, SHA256 6eb2dd951dca2c5304a9ddf75ba23c6035b5950411d9c46211e9129ebea903ac. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

25 identités natives, dont marqueur Shen comme preuve contradictoire, pas contrat adopté ;14 références communautaires distinctes. Un preload sélectionné, sans absence déduite pour les autres. Onze Lua entièrement parsés historiquement, zéro prototype enfant : quatre initialisations littérales,22 globals, sept limites NEWTABLE aux positions BasicAttack0/QOne12/QTwo6/WOne8/WTwo12/EOne18/RKick18. Limites du lecteur, sans corruption ou absence de callbacks déduite. CharScript communautaire vide, sans autorité du serveur Riot.

Quatre clés en_GB présentes vérifiées. Description4219 : après utilisation d’une capacité, les deux prochaines attaques de base gagnent40 % de vitesse d’attaque et rendent15 énergie chacune. Flurry1724 lie vitesse et restitution15. Ces textes ne résolvent pas consommation, durée, réactivation et composition des effets.

Le personnage conserve Passive1LuaName=Shen Passive Marker et Passive1=9 ; fichier exact présent, tooltip2622 Ki Strike décrivant Shen. Aucun transfert de sa recharge ou de ses dégâts vers Lee Sin. Passive1Desc décrit Jax ; PassLev1Desc2..4 annoncent+40/+60/+80 % de régénération Mana. Niveaux bruts3/7/11/15/absent/absent conservés, sans progression Rafale adoptée. Sélection historique effective encore ambiguë ; aucune correction silencieuse.

PARType=Energy, BaseMP200, BaseStaticMPRegen10. Icône personnage LeeSinPassive.dds distincte du buff BlindMonkPassive.dds. BlindMonkPassive et cosmetic ont les mêmes littéraux : BlindMonkFlurry, particule blindMonk_passive_buf.troy aux mains L_hand/R_hand ; égalité de métadonnées distincte d’égalité gameplay. ETwo déclare TriggersSpellCasts=true/DoesntTriggerSpellCasts=false, sans qualification du déclenchement lors de sa réactivation.

DDF16 lignes QWER sans formule Flurry, six chemins candidats absents limités ; fichiers présents conservés. Preloads, flags et ressources visuelles ne prouvent ni callbacks serveur ni rendu. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

24 entrées concordent avec V592 :15 Rust, deux lecteurs Python, sept JSON. Avec le miroir en_GB,25 identités gardées.33 fenêtres dont32 communes réutilisées ; ajout shop314–322, rafraîchissement des plafonds.21 ancres enregistrées dont20 entry_boundary_only/provides_feature_consumer=false ; renvois de branches résolus.

Learn/Cast/CastAt refusent Lee Sin. stats calcule la cadence avec croissance/objets, Trundle W, Ezreal W/passif et Exhaust ; arrondi et plancher local12 ticks. Ces contributions réelles restent préservées, sans qualification native de ce plancher ni terme Flurry trouvé dans le périmètre.

windup_ticks et le traitement de release conduisent aux attaques ordinaires. uses_mana exclut le bonus de mana pour Energy ; restores_resource autorise sa régénération. refresh_item_caps préserve les pools absolus et les borne aux nouveaux maxima ; aucun remboursement passif. Les récepteurs d’énergie/cadence sont présents, le déclencheur admissible reste absent des essais.

Recherche LeeSin/BlindMonk/Flurry/Shen Passive Marker sur15 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer sort accepté, charges, deux attaques accélérées, restitution et contrôles ordinaires. Observé :91/91 contrôles documentaires,94/94 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V592 hérité : trois parties publiques Map10 Lee Sin/Annie, base puis Saphir1027 puis Dague1042. Six attaques par cas,18 impacts physiques avec windup source/cible, release au tick d’impact, non critiques ; dégâts après mitigation/régénération dans la tolérance0,002. Cinq intervalles par cas :46/46/46/46/46,46/46/46/46/46,40/40/40/40/40 ticks. Les40 ticks de Dague ne sont pas les40 % de Rafale.

81 refus atomiques avant/après attaques : joueur inconnu, soi-même, slot invalide, Learn/Cast/CastAt QWER ; snapshots inchangés. Rangs/recharges0, aucun sort accepté.540 ticks après Stop, participants vivants niveau1, sans mort/fin de partie. Énergie toujours au plafond200, taux calculé10/s ; aucune récupération depuis déficit mesurée. Saphir ne change pas le plafond ; aucune preuve des15 énergie rendues par attaque.

Attendu du passif : effet après un sort admissible accepté. Précondition non satisfaite ; ces attaques ordinaires ne constituent donc pas un essai de déclencheur valide échoué, ni un cas nominal Flurry. Charges, consommation, vitesse40 %, durée et restitution restent non exercées. Snapshots locaux, réseau/rendu/audio non qualifiés.

Exécutable V592 identifié uniquement en données :6042112 octets, SHA256 e7fbd0c0e55e2124ffe6658ea8af6ad66d1d39801d75f44125478cc7785f72ea. BUILD/RUN0 hérités, sans accès/lancement actuel ; toolchain/lock/1158 entrées non requalifiés.

Premier contrôle historique d’inspection code1 : hypothèse erronée de six niveaux absents. Ancien script conservé ; nouvelle inspection qualifiée vérifie3/7/11/15 et descriptions contradictoires. Ce correctif documentaire n’a modifié aucun gameplay ; essais Rust déjà réussis non relancés. Aucun ancien échec reclassé.

## 5. Écarts et conclusions ouvertes

Restent sélection du passif, Lua/tables, admission/événements Q1/Q2/W1/W2/E1/E2/R, deux charges, consommation/rafraîchissement/durée, vitesse/composition/retour normal, remboursement/plafond, cibles/concurrence/ordre, niveaux, lifecycle, intégration, réseau et présentation.

Question propre OLU-45b97f69-8251-569e-808e-4dc185d96e1a distincte de SOURCE OLU-01beee20-c968-5367-81db-b47499dc74c2. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

24 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-LEESIN-FLURRY-, suffixe -01 : BINDING-PRIORITY, LUA-METADATA, SPELL-ADMISSION, FIRST-CAST-TRIGGERS, RECAST-TRIGGERS, TWO-CHARGES, CONSUMPTION, REFRESH-STACKING, LIFETIME, ATTACKSPEED40, AS-COMPOSITION, RETURN-BASE, ENERGY15, ENERGY-CAP, TARGETS, SIMULTANEOUS, TICK-ORDER, RANKS-LEVELS, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, ICON-COSMETIC, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : vrais sorts acceptés, dépense publique d’énergie, deux attaques chargées puis troisième normale, plafonds, annulations/réactivations et refus. Aucun état de charge/énergie injecté pour déclarer la fidélité. Résoudre les identités contradictoires avant de choisir la politique. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_leesin_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2483 entrées groupées préexistantes conservées. Prochain Leona depuis122 paires ;71 candidats hors51 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
