# V1506 — Master Yi : contrat connu de Double Strike

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MASTERYI-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-MasterYi-PASSIF-SIMULATION-CONTRAT ; exigence OLF-d8c34334-3f55-575c-8e76-d588d6685f85 ; parent SYS-01.2-02. Audit de 34 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/masteryi-passive-double-strike-links-v601.json du 26 octobre 2026 : 1431982 octets, SHA256 c4dea546a2e980b2728f61d0fad7d964fa4c7c86411a3b7ef1c6ece8bba38004. Rapport FIDELITY_MASTERYI_PASSIVE_DOUBLE_STRIKE_LINKS_V601.md : 16951 octets, SHA256 5ee9755f5f38b56b3c83cc6f1d5649feb80a05e62d51cdc057f9145263e4c8c2. Le candidat du cache correspond au fichier actuel.

54 identités natives, 23 références communautaires séparées et 11 preloads. 23 Lua parcourus historiquement : 14 initialisations littérales, 70 globals, aucun prototype enfant ; neuf limites NEWTABLE, notamment les attaques et MasterYiDoubleStrike. Une limite de lecteur ne prouve pas une corruption. CharScript natif/communautaire vide, sans absence globale de serveur déduite.

MasterYi.inibin lie MasterYiPassive, Passive1.dds et ExtraSpell1 MasterYiDoubleStrike. Buff2278 : quatrième attaque de base consécutive, second coup à 50% des dégâts. Ready1840 annonce le prochain coup double ; Stacks1841 décrit la quatrième attaque ; description4232 reste vague. Treize clés en_GB vérifiées : douze présentes dont MasterYiDoubleStrike11709 vide ; BuffData DoubleStrike absent, sans remplacement automatique. Dix bindings BuffData dont neuf résolus.

Ancien Passive1Desc « chance » conservé sans politique aléatoire adoptée. Six niveaux absents ; mana40/60/80% ne décrit pas la progression du passif. MasterYiDoubleStrike SpellData : portée20, rayon100, coût/délai et coefficients nuls ; aucun dégât secondaire nul déduit. CanCrit et ApplyOnHitEffects absents restent inconnus, jamais false par défaut.

DoubleStrike.luaobj déclare Ready/Passive1 ; Stacks utilise Passive2 ; Stacks et MasterYiPassive persistent et ne sont pas dissipables. Ces métadonnées ne fixent pas le compteur au décès. Seize lignes DDF QWER, deux non vides : AlphaStrike f1=0,6AD et WujuStyle f2=0,1/0,125/0,15/0,175/0,20AD ; aucune formule DoubleStrike déduite. Six chemins candidats absents seulement. Preloads/particules ne prouvent ni invocation, ni rendu ou audio. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

25 entrées concordent avec V601 : 16 Rust, deux lecteurs Python et sept JSON ; avec en_GB, 26 identités vérifiées. 36 fenêtres, dont 32 communes et quatre de récapitulatif. 24 ancres, dont 23 entry_boundary_only/provides_feature_consumer=false ; renvois des branches résolus. Recherche MasterYi/DoubleStrike sur 16 Rust : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

Les attaques prélèvent l’AD à la libération, calculent critique/empowerment et produisent le coup physique ordinaire. Garen et Trundle possèdent leurs branches distinctes ; annulation, ciblage, cadence et présentation sont des acquis conservés. basic_attack_hit applique dégâts, vol de vie et représailles ordinaires. Critique : profil existant et contrôle chance nulle ; SplitMix reconstruit ne qualifie pas la politique historique du second coup. Mitigation, régénération, soins et récapitulatif existent sans producteur DoubleStrike démontré. Learn/Cast/CastAt refusent Master Yi.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer événement de comptage, premier déclenchement, seconde frappe et cycles suivants. Observé : 102/102 contrôles documentaires, 110/110 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V601 hérité : trois parties publiques Map10 MasterYi/Annie, base/épée1036/dague1042. AD60.040000915527344/70.04000091552734/60.040000915527344 ; huit impacts chacun, 24 au total. Sept intervalles par cas : 44/44/38 ticks constants. Épée +10AD et dague +15%AS modifient correctement dégâts et cadence ordinaires, sans démontrer un second coup.

Les coups 4 et 8 restent ordinaires ; aucun impact secondaire entre les coups ou durant 180 ticks après Stop par cas. Windup, cible, libération, mitigation physique et régénération concordent avec un résidu inférieur à 0,002. La fenêtre exerce le premier déclenchement décrit ; elle ne fixe pas les futurs cycles si le second coup contribue lui-même au compteur. Les 540 ticks de fin ne qualifient pas son reset.

81 refus atomiques conservent les snapshots. Mana250.55999755859375 pleine, rangs/recharges nuls, champions vivants niveau1, sans critique, mort ou victoire ; aucun sort Master Yi accepté. Ce refus ne suffit pas à expliquer l’absence de second impact après les attaques réellement exercées. Aucun compteur ou second coup artificiellement injecté.

Exécutable identifié uniquement en données : 6043136 octets, SHA256 892df60cc21a59a4e5ed26d9fdb14cef1a0130d06c3f1e3abf79f4550873bbde. BUILD/RUN0 hérités ; chaîne, lock et 1158 entrées non requalifiés. Aucun défaut produit corrigé ici.

## 5. Écarts et conclusions ouvertes

État initial/comptage/reset, quatrième attaque, contribution du second coup au compteur, identité/délai/cible, dégâts50%/AD, critique/onhit/mitigation/vol de vie, annulations/pertes de cible/contrôles, QWER, niveaux/objets, coexistence/lifecycle, projection et présentation restent à qualifier.

Question propre OLU-79fbf560-6b33-514c-aefc-5b06be10dc75 distincte de SOURCE OLU-8d689413-c349-5963-ae1a-6bdf5869f319. Propriétaires/dépendances conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

34 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MASTERYI-DOUBLESTRIKE-, suffixe -01 : METADATA, LUA, INITIAL-COUNTER, COUNT-BOUNDARY, FOURTH-TRIGGER, SECOND-RECOUNT, CONSECUTIVE-RESET, READY-CAP, TARGET-CLASSES, SECOND-IDENTITY, SECOND-TIMING, SECOND-DAMAGE50, AD-SAMPLING, CRITICAL-POLICY, ONHIT-RECURSION, MITIGATION, LIFESTEAL, REFUSAL-CANCEL, TARGET-LOSS, OVERKILL-CREDIT, CONTROL, SPELL-ADMISSION, Q-INTERACTION, W-INTERACTION, E-INTERACTION, R-INTERACTION, LEVELS-ITEMS, MULTI-OWNER, LIFECYCLE, TICK-ORDER, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Scénarios publics avec vrais compteur/second coup et futurs cycles sourcés, sans injection pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_masteryi_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2492 entrées préexistantes conservées. Prochain MissFortune depuis 122 paires : 62 candidats hors 60 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF, avec sauvegarde préalable et contrôle après écriture. Goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
