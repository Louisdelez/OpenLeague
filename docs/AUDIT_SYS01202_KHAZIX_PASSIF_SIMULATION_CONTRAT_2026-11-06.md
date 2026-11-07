# V1494 — Kha’Zix : contrat connu d’Unseen Threat

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KHAZIX-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Khazix-PASSIF-SIMULATION-CONTRAT, exigence OLF-69d89ded-d891-5606-8dee-c8fd682083f5, parent SYS-01.2-02. Audit borné de24 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/khazix-passive-unseen_threat-links-v589.json du26 octobre2026 :1352627 octets, SHA256 1b039a0cf78f903a873c163203c16a332a222245147430c69c8877c0343b6f3c. Rapport FIDELITY_KHAZIX_PASSIVE_UNSEEN_THREAT_LINKS_V589.md :15622 octets, SHA256 3cc7789c689c8998ba8b50b4578702c39c0565293ecea55e9d31fa19eefd0a6a. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

29 identités natives,15 références communautaires séparées, six preloads. Onze Lua entièrement parsés historiquement, zéro prototype enfant. Deux initialisations littérales vides, CharScript et RInternalCD ; neuf limites NEWTABLE : Passive/PDamage pc16, PSlow pc14, R/REvo pc18, RStealth pc6, trois attaques pc0. Limite du lecteur ne signifie ni corruption ni absence de globals/callbacks dans ces neuf scripts. Le buff passif n’est pas qualifié par le lecteur littéral. CharScript communautaire vide ; aucune exécution serveur.

Dix clés en_GB vérifiées, sept présentes et trois SpellData absentes, dont GreenTerrorBasicAttack. Cinq buffs directement liés. Description4216 : hors visibilité de l’équipe ennemie, prochaine attaque de base contre un champion ennemi renforcée par dégâts magiques et ralentissement. Buff2174 : durée2 secondes, placeholders f1/f2/f3 non résolus. PDamage2175 décrit l’attaque préparée. R/REvo évoquent furtivité, charges et trois utilisations avec durée augmentée ; ces contextes ne donnent pas les formules du passif.

DDF40 lignes, quatre PDamage avec link/coeff vides : aucune formule nulle déduite. Effect1..4=3/35/4/3 et Coefficient0 sans mapping f1/f2/f3 ; aucun montant ou pourcentage adopté.

KhazixPassive, icône Khazix_P.dds, ExtraSpell4=KhazixPAttack. Ancienne description, six niveaux passifs et PARType interrogés absents, sans défaut inventé. CharScript réellement à la racine du personnage, sorts sous Spells ; six chemins candidats absents ne rendent pas ces ressources manquantes. Aucune substitution des clés absentes. Preloads, isolation Q et chasse Rengar restent des dépendances/contextes distincts. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

30 entrées concordent avec V589 :18 Rust, deux lecteurs Python, dix JSON. Avec le miroir en_GB,31 identités gardées.38 fenêtres dont32 communes réutilisées ; ajouts : sélection de rayon vision23–43, ligne de vue44–77, vision partagée78–136, projection137–204, slows1–82 et movement1–81.30 ancres enregistrées dont29 entry_boundary_only/provides_feature_consumer=false ; renvois de branches résolus.

visible_to/visible_point_to utilisent équipes, champions/unités vivants, rayons, navigation, buissons, tours/pets, autels et révélation Ignite selon les règles courantes. snapshot_for filtre joueurs/unités et effets ; observation interne distincte du transport. Le contrôle d’attaque consulte la visibilité. Ce sont des mécanismes réels, sans fidélité native globale établie.

prepare_slow valide sans mutation, commit_slow_for_surviving_target omet les cibles mortes et contrôle la définition/le type des unités ; grant_slow est une API d’événement serveur, non une commande réseau. Rafraîchissement par tag, sélection du plus fort, durée modifiée et nettoyage existent. movement compose ralentissements et plafonds avec les effets déjà présents, dont Trundle. Aucun producteur UnseenThreat ainsi ajouté. Learn/Cast/CastAt de Kha’Zix restent refusés.

Recherche Khazix/UnseenThreat/unseen_threat sur18 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer vision courante, armement, vraie attaque renforcée et formule historique. Observé :102/102 contrôles documentaires,117/117 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V589 hérité : deux parties publiques Kha’Zix/Ahri, AP0 puis20 avec achat public du Tome1052. Par cas :30 ticks cachés initiaux, retour visible et deux attaques, retrait hors vision par distance,90 ticks cachés puis retour et deux attaques,180 ticks finaux visibles. Total240 ticks cachés immobiles et360 finaux, distincts des trajets/attaques.

Visibilité ennemie comparée à snapshot_for pendant trajets/attentes ; propre projection toujours présente. Attaque adverse sur Kha’Zix caché refusée sans mutation. Ligne de vue dégagée, perte de vision par distance, aucune furtivité R exécutée.

Huit impacts de mêlée, windup source/cible non critique avec release au tick du dégât ; dégâts totaux physiques ordinaires dans la tolérance0,002 avec régénération. Aucun bonus magique ni entrée de ralentissement ; vitesse cible inchangée. Quatre champions vivants niveau1.32 refus publics sans mutation, dont QWER/apprentissage ; R/évolutions refusés.

Attendu du diagnostic local conforme : visibilité/projections/refus et dégâts ordinaires. Effets du passif non observés avec cette vision courante. Cela ne mesure ni leurs valeurs historiques ni l’équivalence de ce déclencheur à4.20.

Exécutable V589 identifié uniquement en données :6120960 octets, SHA256 13e1b546ed5a5b4defae0fef81f979a9a6a6fe09d612a86bcddf879e938e7f64. BUILD/RUN0 hérités, sans accès/lancement actuel ni requalification toolchain/lock/dépendances. Échecs antérieurs conservés. Affichage exploratoire CP1252 échoué sur une flèche Unicode, corrigé via sortie JSON ; erreur d’affichage consignée séparément, sans échec du jeu déduit.

## 5. Écarts et conclusions ouvertes

Restent mappings/formules, visibilité historique, armement/maintien/consommation/réarmement, cibles/annulations, événements concurrents, dégâts et ralentissement, furtivité/évolution R, ordre temporel, niveaux/ressources, lifecycle, intégration, réseau et présentation.

Question propre OLU-4b7ad51f-3e11-5342-93cf-aa16836c3823 distincte de SOURCE OLU-6f337c9e-5bd3-575a-888e-8ceaf173d735. Propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

24 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KHAZIX-UNSEENTHREAT-, suffixe -01 : NAME-BINDINGS, DAMAGE-FORMULA, SLOW-FORMULA, LUA-METADATA, VISION-PREDICATE, ARM, HOLD, CHAMPION-TRIGGER, CONSUMPTION, REARM, TARGET-ISOLATION, SIMULTANEOUS, DAMAGE-ORDER, SLOW-DURATION, SLOW-COMPOSITION, R-STEALTH, R-EVOLUTION, TICK-ORDER, RANKS-RESOURCES, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : vision qualifiée, vrai armement puis attaque publique, bonus magique/slow, réarmement, annulations/nonchampions et révélations ; pas d’injection d’état pour déclarer la fidélité. Aucun chiffre moderne substitué. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_khazix_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2480 entrées groupées préexistantes conservées. Prochain KogMaw depuis122 paires ;74 candidats hors48 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
