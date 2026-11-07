# V1512 — Nasus : contrat connu de Soul Eater

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-NASUS-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Nasus-PASSIF-SIMULATION-CONTRAT ; exigence OLF-ff0bec1f-3eed-58c5-a704-667cd0af1017 ; parent SYS-01.2-02. Audit de37branches connues, réunissant V607/V540 sans remplacer leurs preuves. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçus docs/reference_requirement_trace_sources :nasus-passive-soul-eater-links-v607.json,2108031octets SHA256 67da44a3edb29011d14388b8bba0856b8f24b17151012ae03cdf20fcca5f8dda ;nasus-passive-healing-links-v540.json,433581octets SHA256 66a1003f8f9bcda9f956f29ffd94c316681afbaf1feceb5c74ba5462589cbf41. Dates26/25octobre2026. Rapports FIDELITY_NASUS_PASSIVE_SOUL_EATER_LINKS_V607.md et FIDELITY_NASUS_PASSIVE_HEALING_LINKS_V540.md :17438/11394octets, SHA256 2c376679134ceb592eec2ea42a31a36ab7fb44ad64eb44146b41e8a836cf3ad8 / ef84f72d32b7f94085c5bd1869adc600f59f79033a3f89375f90edb2fa02fc8c. Deux candidats du cache retrouvés.

32identités natives incluant les six V540 aux tailles/SHA déclarés concordants ;septpreloads,19liens communautaires pour16identités uniques conservés. DouzeLua parcourus historiquement, septinitialisations littérales,23globals, aucun enfant/exécution ;cinqlimites NEWTABLE sans corruption déduite.

Dixclés natives vérifiées dont neuf présentes :SoulEater2691 annonce @f1@% bonus Life Steal, description4238 et nom4414. SixBuffData dont cinq résolus ;game_buff_tooltip_NasusQ reste absent, sans renommage automatique. Anciennes chaînes Singed PV/mana et réduction magique10%, SoulNexus2692/compteur2693 conservés sans adoption.

Sixniveaux et15champs SpellData NasusPassive absents, sans zéro inventé.24lignes DDF dont deux Q/SiphoningStrikeNew @stacks coefficient3 ;ces f1 ne résolvent pas SoulEater. Pourcentage, progression et combinaison restent inconnus.

CharScript natif/communautaire vides ;NasusPassive déclare icône/nom/PersistsThroughDeath/NonDispellable, sans callback de soin ni politique de respawn. Icône Chronokeeper/nom Slow de NasusTauntRenekton non adoptés. Cinqchemins candidats absents seulement ;ressources réelles dans le personnage. Preloads et nasus_base_p_lifesteal.troy ne prouvent ni chargement, rendu ou audio.

Q communautaire inflige des dégâts de sort immédiats et augmente l’AD global à la mort ;E annonce une réduction d’armure sans application dans le corps lu. R communautaire défensif/timers ne qualifie pas la conversion native dégâts→AD. Aucun serveur original ou consommateur Rust déduit de ces fichiers. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

29entrées actuelles concordent avec V607 et V540 :18Rust, deuxlecteurs Python et neufJSON ;avec en_GB,30identités vérifiées. Courbe XP989octets SHA256 ba484fa71447cd59e02396f555b92f0e9b6145cf71aeeea768f7de729d9ad5d6 ajoutée précisément pour le diagnostic ancien.39fenêtres dont32communes, quatre récapitulatif, AnnieQ45–94 et occupation517–558/635–785.38ancres dont37frontières ;dixanciennes conservées.

stats.life_steal vaut exclusivement items.life_steal.max(0). basic_attack_hit applique dégâts physiques, puis post_mitigation×taux et heal si lanceur vivant/cible non structure. heal possède plafond/refus et multiplicateurs Ignite/Trundle, non exercés comme interactions SoulEater. Attaques Garen/Trundle, critiques, mitigation, soins, régénération et récapitulatif restent des acquis. Aucun producteur du bonus Nasus démontré.

Learn/Cast/CastAt refusent Nasus. Recherche actuelle Nasus/SoulEater sur18Rust :zérooccurrence ;relevé639fichiers hérité, sans nouvelle recherche globale ni relecture des1158dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire :séparer bonus natif, vol de vie d’objet, régénération et diagnostic XP. Observé :178/178contrôles documentaires,156/156cohérences du même agent ;quatreproductions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V607 hérité :troisparties publiques Nasus/Annie base/Épée1036+10AD/Sceptre1053+10AD8% ;AD59.18000030517578/69.18000030517578/69.18000030517578, AP0. Neufattaques mêlée, neufphysiques reçues, troisQ Annie raw80/coût60,81refus atomiques,540ticks et sixtrajets sans reprise. PVmax561.2000122070312, mana275.6000061035156 pleine, rangs/recharges nuls, vivants niveau1 sans critique/bouclier/contrôle/mort/victoire. Aucun état/dégât/soin/niveau injecté.

Hors régénération :base/Épée attendu0, observé0.00000911206 par coup ;Sceptre attendu4.642173767089844, observé4.642190456390381, troisfois ;tolérance0,002. PVmanquants suffisants. Cela ne qualifie pas PVpleins, anti-soin, amplification, surdégâts ou boucliers.

V540 hérité, protocole Nasus/Garen distinct :douzefrappes, sixparcas, ticks899/946/993/1040/1087/1134 ;soin0 sansobjet et4.3394775390625 avecSceptre. Régénération1.80239999294281PV/s et échantillons horsfrappe séparés. Aucune équivalence numérique ou régression déduite entre protocoles malgré les29identités communes.

Deuxautres diagnostics V540 relèvent36lignes niveaux1–18,19245événements award_experience(+1) chacun ;taux0/0.07999999821186066 constants. Huitrefus XP0/négative/NaN/joueurabsent conservés. API serveur explicite, sans mutation directe ni action réseau :aucune progression par éliminations ou mesure de soin en combat niveaux2–18 qualifiée. Seuils locaux2–18 concordants ;Level1 absent de la courbe, XPinitiale0 observée, sans défaut inventé. Producteur local plafonné18 ;entrées19/20 non exercées.

Attaques ordinaires réellement exercées :le refus des sorts propres n’explique pas seul l’absence du bonus. Son déficit historique n’est pas chiffré faute de f1. Q renforcée et combinaisons restent ouvertes.

Binaires seulement identifiés en données :V6076117888octets SHA256 ea72220339e31457412145cd44d824d7a247a64a74fca2b02cf9deb088ac01b3 ;V5405963264octets SHA256 7fe349edde04453d0d42ac0b35a9aa6bfefa96c24ed245c6074579ad540c1db3. BUILD/RUN0 hérités ;chaîne/lock/1158entrées non requalifiés.

## 5. Écarts et conclusions ouvertes

f1/niveaux, combinaison objets/runes/maîtrises, dégâts/cibles/Q/critique, plafonds/modificateurs/boucliers/surdégâts, ordre/mort/lifecycle et présentation/réseau ouverts.

Première collecte V607 sortie0 mais DynamicTooltip altéré en DynasuscTooltip :script/relevé conservés, nouvelle collecte qualifiée. Première inspection sortie1 sur l’hypothèse de toutes clés résolues ;nouvelle inspection constate NasusQ absent sans le résoudre. Ancienséchecs Nami/V564/BattleTraining non requalifiés ;sixtrajets Nasus ne les corrigent pas.

Propre OLU-3b731202-8801-570b-90f1-5127e6dba83f distincte de SOURCE OLU-2f4c1a98-9b1b-536c-bf4d-1e644a691123 ;propriétaires/dépendances conservés, aucune inconnue fermée.

## 6. Corrections et reprise

37fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-NASUS-SOULEATER-, suffixe -01 :METADATA,LUA,F1-RATE,LEVEL-PROGRESSION,XP-DIAGNOSTIC,STATS-INTEGRATION,ITEM-COMPOSITION,RUNES-MASTERIES,DAMAGE-ELIGIBILITY,DAMAGE-BASIS,AD-SAMPLING,CRITICAL,TARGET-CLASSES,Q-EMPOWERED,W-INTERACTION,E-INTERACTION,R-INTERACTION,HEAL-CAP,ZERO-IMMUNITY,SHIELDS,OVERKILL,HEAL-MODIFIERS,CASTER-DEATH,TARGET-DEATH,TICK-ORDER,RECURSION,ATTRIBUTION,CANCEL-REFUSAL,MULTI-OWNER,LIFECYCLE,PROJECTION,HUD,VFX,AUDIO,TOOLTIP-Q,COMMUNITY-CONFLICTS,VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec bonus natif sourcé et vrais événements, sans soin injecté ni assimilation du diagnostic XP au combat. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves E:/mapslol3v3/audit_sys01202_nasus_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2498 entrées préexistantes conservées. Prochain Nautilus depuis122paires :56candidats hors66unités nommées, sanscompteglobal.

Audit borné terminé après sept rubriques ;tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF avec sauvegarde/relecture ;goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
