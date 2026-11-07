# V1491 — Katarina : contrat connu de Voracity

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KATARINA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Katarina-PASSIF-SIMULATION-CONTRAT, exigence OLF-5bb5f097-25ef-5104-aa7c-31bae2c17227, parent SYS-01.2-02. Audit borné de20 branches connues, distinct de la résolution de tous les contrats historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/katarina-passive-voracity-links-v586.json du26 octobre2026 :897662 octets, SHA256 e69699b790793c192d1f89077721a9720bfc5638cb609b9a7a1ce70e996a25b6. Rapport FIDELITY_KATARINA_PASSIVE_VORACITY_LINKS_V586.md :14723 octets, SHA256 d81469a05d17ff6ab39dc9f4866e6a9ae8145ace21ffb4ad60e3d147028b65b9. Cache de rapports vide, mais MD existant retrouvé et épinglé au chemin explicite ; aucun cache modifié ni asset déclaré absent sur cette seule base.

Douze identités natives aux rôles distincts, sept références communautaires séparées, deux preloads. Deux Lua entièrement parsés historiquement, sans prototype enfant, deux initialisations littérales et sept globals. CharScript vide ; aucune exécution serveur ni priorité de montage qualifiée.

Cinq clés en_GB vérifiées : trois présentes, deux MaliceAndSpite absentes. PassLev1Desc1 lie directement la description4213 : éliminations/assistances réduisent les délais de15 secondes. BuffData lie Voracity2922 : réduction de10 secondes sur DeathLotus et rafraîchissement des sorts de base. Les deux liaisons existent ; contradiction et priorité restent non résolues. Ni ordre des lignes, ni facilité de test ne choisit la règle.

Passive1LuaName=Voracity, BuffName=KatarinaPassive et preload katarinapassive gardent leurs identités. Trois chemins candidats absents dans l’inspection retenue ; global KatarinaPassive identifié séparément. DynamicTooltip/Description SpellData visent les clés MaliceAndSpite manquantes, sans substitution silencieuse.

Icône Katarina_Voracity.dds, persistance, non-dissipation, flags et indicateur katarina_spell_refresh_indicator.troy sont des métadonnées/dépendances, sans preuve de callback ou d’affichage. DDF28 lignes, sans formule passive ; coefficients bonusAD5 de DeathLotus et3 de KatarinaR ne sont pas des remboursements.

Délais normaux Q10/9,5/9/8,5/8, W4, E12/10,5/9/7,5/6, R90/60/45 conservés. Champs hors rang normal non adoptés. Six champs de niveaux passifs et coûts inspectés absents ; PARType=None et mana0 ne remplacent pas les champs absents par des valeurs inventées. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

Trente entrées concordent avec V586 : dix-huit Rust, deux lecteurs Python, dix JSON. Avec le miroir en_GB,31 identités gardées. Trente-cinq fenêtres dont32 communes réutilisées, plus création de délai, crédits et or ambiant. Vingt-trois ancres enregistrées dont22 entry_boundary_only/provides_feature_consumer=false ; tous les renvois des branches aboutissent aux fenêtres contrôlées.

apply_damage enregistre les contributions et appelle reward_champion_death. Score, attribution, or et XP ordinaires sont de vrais mécanismes conservés. assist_pool_fraction et l’or ambiant restent séparés du passif. Le registre générique utilise15 secondes, soit450 ticks locaux, pour les contributions éligibles : durée distincte des15 secondes de réduction d’un texte natif, sans équivalence de politique démontrée.

cooldown::ticks applique la CDR à la création d’un délai, sans produire un remboursement Voracity. Learn/Cast/CastAt refusent Katarina ; aucun délai n’est armé. Le vrai champ Windup.release est conservé. Lifecycle et départ restent du contexte statique.

Recherche littérale Katarina/Voracity/MaliceAndSpite sur18 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer crédits, priorité du contrat, admission des sorts et modification de délais actifs. Observé :89/89 contrôles documentaires,99/99 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V586 hérité : quatre parties publiques,45 impacts de mêlée avec windup source/cible non critique et release au tick du dégât, quatre morts ordinaires. Deux kills directs Katarina, chacun400or ; une assistance à113 ticks,86,875or ; aucune assistance à612 ticks après451 ticks d’attente supplémentaire, crédit0. Fenêtre générique450 ticks, or ambiant séparé du crédit.

112 refus sans mutation,720 ticks après crédits et451 ticks d’attente distincts. QWER/apprentissage refusés avant/après crédits, rangs/délais toujours `[0,0,0,0]`. Codex3108 donne10 % CDR dans le second kill mais n’arme aucun délai. Aucun remboursement de délai actif exercé : zéro ne prouve ni10, ni15 secondes, ni refresh.

Inférence limitée aux délais normaux : QWE sont inférieurs à15 secondes ; leur mise à zéro ne distingue pas seule refresh et soustraction de15. Un R avec délai restant suffisant distingue les montants, après résolution primaire de la règle ; un test de notre moteur ne tranche pas sa priorité historique.

Exécutable V586 qualifié identifié uniquement en données :6284800 octets, SHA256 60bc0f173d205ffe555dc7f21a19beb3a63f21ac591cea92249da055b164658f. Ancien BUILD101 sur Windup.releases conservé ; diagnostic distinct corrigé vers release, BUILD/RUN0. Aucun code moteur corrigé par ce diagnostic. Aucun accès/lancement actuel ; verrou, toolchain et1158 entrées non revalidés.

Lecture exploratoire actuelle : AttributeError en traitant les champs scalaires comme objets ; observation corrigée, consignée dans root_inspection_shape_note.json. Hors productions journalisées, sans mutation ni échec du jeu déduit.

## 5. Écarts et conclusions ouvertes

Restent priorité15/10+refresh, mapping des noms, sorts armant des délais, kills/assists éligibles, fenêtre/propriété des contributions, slots/montants, CDR/plancher, crédits simultanés/en chaîne, ordre temporel, canalisation R, rangs/ressources, lifecycle, intégration, transport et présentation.

Question propre OLU-40833857-c1c5-57c4-a1a2-0765387c516c distincte de SOURCE OLU-db12bc4f-4f72-5506-a658-6e31cbb59b54. Dépendances/propriétaires conservés ; aucune inconnue fermée, V564/BattleTraining non corrigés.

## 6. Corrections et reprise

20 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KATARINA-VORACITY-, suffixe -01 : CONTRACT-PRECEDENCE, NAME-BINDINGS, SPELL-ADMISSION, KILL-TRIGGER, ASSIST-TRIGGER, CREDIT-WINDOW, OWNERSHIP, AMOUNT-SLOTS, CDR-COMPOSITION, FLOOR, SIMULTANEOUS, CHAINED-CREDITS, TICK-ORDER, CHANNEL-R, RANKS-RESOURCES, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, fin positive distincte et reprise pour chacune.

Priorité des textes et mapping sont préalables au choix du remboursement à implémenter. Reprendre sur source primaire/fournisseur nouveau, consommateur modifié ou cas indispensable non couvert. Futur scénario : vrais sorts lancés, délais actifs et crédits publics avec refus/exclusions ; aucune injection de timers pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_katarina_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2477 entrées groupées préexistantes conservées. Prochain Kayle depuis122 paires ;77 candidats hors45 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucune installation/migration, aucun gain temporel mesuré.
