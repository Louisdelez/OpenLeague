# V1510 — Morgana : contrat connu de Soul Siphon

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MORGANA-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Morgana-PASSIF-SIMULATION-CONTRAT ; exigence OLF-45e485b5-023e-53b8-ad26-91e42607896f ; parent SYS-01.2-02. Audit de 34 branches connues réunissant V605/V555 sans remplacer leurs preuves. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçus docs/reference_requirement_trace_sources : morgana-passive-soul-siphon-links-v605.json, 2049558 octets, SHA256 dc1b5e98d64e7247652fc72af97985754ee1ff747fc9b4a42b220d812a3f42b6 ; morgana-passive-spell-vamp-boundary-links-v555.json, 498698 octets, SHA256 37fce10b0f480eddbef84add087a1bc26f95bdd1b1ec29ec17530a9d1cad498d. Dates26/25octobre2026. Rapports FIDELITY_MORGANA_PASSIVE_SOUL_SIPHON_LINKS_V605.md et FIDELITY_MORGANA_PASSIVE_SPELL_VAMP_BOUNDARY_LINKS_V555.md :17634/9797octets, SHA256 2fae1e0fb54a0c7e358a3a92b4a150ce30d65be65e905f69819a2ea3cd95b55c / b9e5b6916b6ef23b9bb78ba1bf3f72537826b97e6a9088cacc61f5e8045301b1. Deux candidats du cache retrouvés.

V605 :28 identités natives, dont les sept V555 aux identités déclarées concordantes ; sept preloads,18 liens communautaires pour15 identités uniques conservés,18 NightmareBot exclus. Dix Lua parcourus historiquement : trois initialisations littérales, huit globals, aucun prototype enfant, sept limites NEWTABLE sans corruption déduite.

Trois clés natives vérifiées : nom4412 Soul Siphon, description4236 soin personnel sur dégâts de sorts, buff1866 @f1@% bonus Spell Vamp. Quinze champs SpellData Empathize et six niveaux passifs absents, sans zéro inventé. f1, progression et modificateurs de cibles/zone/périodiques restent ouverts. Ancien texte de régénération alliée et mana40/60/80% conservés sans adoption.

CharScriptMorgana natif n’est pas vide : PersistsThroughDeath et NonDispellable, sans callback. Le C# communautaire est vide. EmpathizeAura déclare buff/icône/persistance ; son nom ne prouve pas une aura alliée ni la règle au respawn. Huit chemins candidats absents dont DDF ; aucune absence globale d’assets déduite.

QWER communautaires codés, sans exécution ou équivalence serveur/Rust qualifiée. W comporte16timers espacés0,3125s malgré commentaire « single pulse » ; rayon275 contre CastRadius280 natif. R communautaire600 contre CastRadius625. Conventions et adoption restent ouvertes. Coefficients Q0,9AP, W0,22/0,33AP, E/R0,7AP ne produisent pas f1. Preloads idle/base/skin05 ne prouvent ni soin ni rendu. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

29 entrées actuelles concordent avec V605 et V555 :18 Rust, deux lecteurs Python et neuf JSON, dont AnnieW ajouté précisément pour l’ancien contrôle. Avec en_GB :30 identités vérifiées. 40 fenêtres dont32 communes, quatre récapitulatif, AnnieQ45–94, AnnieW64–83 hors tests et occupation517–558/635–785. 46 ancres dont45 entry_boundary_only/provides_feature_consumer=false ;18 anciennes conservées.

basic_attack_hit applique des dégâts physiques puis vol de vie après mitigation et heal. heal possède plafond/refus et multiplicateurs Ignite/Trundle ; ceux-ci ne sont pas exercés comme interactions Soul Siphon. AnnieW appelle directement les dégâts magiques, sans basic_attack_hit/soin ordinaire. Ce sont des acquis distincts du passif. Learn/Cast/CastAt refusent Morgana.

Recherche actuelle sur18 Rust : zéro occurrence des variantes Morgana/Empathize/SoulSiphon/SpellVamp. Le relevé V605 de639 fichiers sans hit est réutilisé, sans nouvelle recherche globale ou relecture des1158 dépendances. Aucun consommateur complet du passif démontré.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer régénération, vol de vie d’objet, dégâts de compétence et Spell Vamp. Observé :157/157 contrôles documentaires,133/133 cohérences du même agent ; quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V605 hérité : trois parties publiques base/Tome1052+20AP/Sceptre1053+10AD8%vol de vie ; prix435/800 dans825or. AD55,46/55,46/65,46, AP0/20/0. Neuf attaques sortantes, neuf physiques entrantes, trois Q Annie raw80/coût60,81refus atomiques,540ticks et six trajets sans reprise. PVmax547.47998046875, mana340.79998779296875 pleine, rangs/recharges nuls, champions vivants niveau1. Aucun état/dégât/soin/niveau injecté.

Hors régénération, soin attendu0 dans base/Tome, résidu observé0,000002. Avec Sceptre :4.392551422119141 attendu,4.392549514770508 observé par impact, trois fois ; tolérance0,002. PV manquants suffisants. Cela ne qualifie ni PV pleins, anti-soin, amplification, surdégâts ou boucliers.

V555 hérité, contextes distincts : Morgana sans/avec1053 puis Annie avec1053 ; neuf attaques ordinaires, douze reçues,41refus et90ticks finaux. Soins0 /4.10614013671875 /3.78936767578125 par impact, conformes au vol de vie à0,002près. W Annie coûte70mana, impact1087, dégâts nets52.9378662109375 et soin supplémentaire0. Ce témoin n’est pas un sort Morgana. Montants non interchangeables avec V605 malgré les identités communes ; aucune régression déduite de protocoles différents.

Aucun sort Morgana accepté dans les deux reçus : déclencheur admissible non exercé. Les attaques ordinaires ne prouvent pas un échec du passif. Binaires uniquement identifiés en données : V6056094848octets SHA256 203e6f9527c900647a58ad17edc97e23013e8f420aa4e12eaf1ce3f243e3e32e ; V5556047744octets SHA256 7bff74adad2017ee4aa6e7a9f3c2a3b73d8686f4fb3e8089fab85cbe746592ae. BUILD/RUN0 hérités ; chaîne/lock/1158 entrées non requalifiés. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

f1/niveaux, sorts/admissibilité/base de dégâts, classes/zone/périodiques, modificateurs et plafonds de soin, surdégâts/mort/ordre, coexistence/lifecycle et projection/présentation restent ouverts. Conflits communautaires non résolus.

Propre OLU-45c6372b-d0ce-591e-8c35-8e70970477d4 distincte de SOURCE OLU-96dfbc8e-24d9-5cb4-9acc-05ac481e8ca8. Propriétaires/dépendances conservés dans les deux versions ; aucune inconnue fermée. V564/BattleTraining et anciens échecs non requalifiés.

## 6. Corrections et reprise

34 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MORGANA-SOULSIPHON-, suffixe -01 : METADATA, LUA, F1-RATE, LEVELS, SPELL-ADMISSION, DAMAGE-ELIGIBILITY, DAMAGE-BASIS, TARGET-CLASSES, AOE-SCALING, PERIODIC-SCALING, Q-CONTROL, W-CONTROL, R-CONTROL, E-NEGATIVE, MULTI-TARGET, ITEM-COMPOSITION, HEAL-CAP, ZERO-IMMUNITY, OVERKILL, CASTER-DEATH, TARGET-DEATH, TICK-ORDER, HEAL-MODIFIERS, RECURSION, ATTRIBUTION, REFUSAL-ATOMICITY, STAT-SAMPLING, LIFECYCLE, MULTI-OWNER, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION, COMMUNITY-CONFLICTS. Objectif unique, tâche liée, prérequis, travail, critère positif et reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec vrais dégâts de sorts Morgana puis soin, sans injection pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_morgana_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2496 entrées préexistantes conservées. Prochain Nami depuis122 paires :58 candidats hors64 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF avec sauvegarde/relecture ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
