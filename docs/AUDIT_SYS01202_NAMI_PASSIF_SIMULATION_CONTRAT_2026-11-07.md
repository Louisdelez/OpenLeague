# V1511 — Nami : contrat connu de Surging Tides

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-NAMI-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Nami-PASSIF-SIMULATION-CONTRAT ; exigence OLF-d1bfd64c-e05e-52bb-a064-2fb6d3b2647b ; parent SYS-01.2-02. Audit de 36 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/nami-passive-surging-tides-links-v606.json du26octobre2026 :2736464octets, SHA256 db571e21224ee2e4622b8df70b44d9de061af2db9d70577405b1c1b30ea37bf4. Rapport FIDELITY_NAMI_PASSIVE_SURGING_TIDES_LINKS_V606.md :21349octets, SHA256 1f254c7d355b16054091f75fb7ecd7f7bc9e3f2a7358c523f0f8d467ab6d3813. Candidat du cache retrouvé aux mêmes octets.

63 identités natives :23INIBIN,26Lua,12preloads,unDDF et unfont ;28 références communautaires distinctes. Lua parcourus historiquement sans enfant ni exécution :12initialisations littérales,50globals,14limites NEWTABLE sans corruption déduite. CharScript natif et communautaire vides, sans absence globale de serveur déduite.

Neuf clés en_GB vérifiées, sept BuffData résolus une fois. Buff2326 : contact d’une compétence avec un champion allié,40+f1 vitesse pendant1,5seconde ; destinataire2327, description4237, nom4413. f1, progression, éligibilité et renouvellement restent inconnus. Passive1Desc vide ; niveaux1–4 chaînes «0»,5–6 absents, sans progression numérique adoptée.

NamiPassive/NamiPassivett :15champs SpellData sélectionnés chacun absents, sans zéro par défaut. Les24lignes DDF sont vides, dont quatreNamiPassive ; aucun f1 nul déduit. Coefficients Q0,5/W0,5et0,3/E0,2/R0,6 ne résolvent pas le passif.

NamiPassive.luaobj lie Janna_Tailwind à NamiPassive, avec DoesntTriggerSpellCasts/PersistsThroughDeath/NonDispellable. Le destinataire NamiPassivett utilise NamiPassive.dds et Nami_Base_P_buf.troy ; le nom Debuff ne démontre aucun malus. NamiRunSpeed contient seulement PersistsThroughDeath. Icônes Janna/Minotaur et clé Zyra ligne3010 conservées sans politique étrangère ni règle de respawn.

Sept chemins candidats absents seulement ; ressources présentes sous Characters/Nami/Spells, CharScript à la racine du personnage. Aucun manque global d’assets déduit. Preloads ne prouvent ni déclenchement ni rendu/audio. QWER communautaires codés sans équivalence serveur/Rust :W cible unique malgré commentaire de rebond, E NamiTidecaller, Q temporise1,5s avant contrôle ennemi, R filtre angulaire instantané. Ces comportements ne prouvent pas les contacts alliés. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

25 entrées actuelles concordent avec V606 :17Rust, deux lecteurs Python, sixJSON ; avec en_GB,26identités vérifiées. 36fenêtres dont32communes, mouvement1–82 et occupation517–558/559–634/635–785. 22ancres dont21 entry_boundary_only/provides_feature_consumer=false. Recherche bornée sur17Rust :aucun mot Nami/NamiPassive/SurgingTides, avec limites évitant «dynamic». Ancien relevé639fichiers réutilisé, sans nouvelle recherche globale ou relecture des1158dépendances.

Learn/Cast/CastAt refusent Nami. movement_speed compose base et boutique, puis modificateurs existants Garen/Heal/relique/Trundle/ralentissements et crossing. stats.move_speed appelle ce même producteur :ce n’est pas une mesure indépendante. Caps220/415/490 reconstruits, historical_qualification=false ;335/360/330 ne les qualifient pas. fit_step borne le budget, note_ally_move conserve l’ordre et advance_allied_motion gère les déplacements. Ces acquis ne forment pas un producteur SurgingTides. Dégâts, soins, vol de vie et régénération existants conservés.

## 4. Attendu, observé et contrôles

Attendu documentaire :séparer contact admissible, bonus actif, déplacement ordinaire et critères d’arrivée. Observé :101/101contrôles documentaires,127/127cohérences du même agent ;quatreproductions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V606 hérité :deux parties publiques Map10 Nami21/Ahri23 alliées, Annie22 ennemie ;base puis Bottes1001+25vitesse/Tome1052+20AP,760or dans825. Vitesses Nami335/360, Ahri330 ;AP0/20, mana377.239990234375 pleine, rangs/recharges nuls, vivants niveau1 sans ralentissement, étourdissement, mort ou victoire. Aucun état/position/dégât/soin/XP injecté.

102refus atomiques conservent les snapshots, avec soi/allié/ennemi/sanscible/sol et apprentissage. Six trajets de préparation réussissent,1037ticks par cas, sans reprise Move. 184ticks d’attente ;offsets44/45/46 autour de1,5s à30Hz local ne sont pas l’âge d’un buff actif. Aucun sort Nami accepté, aucun contact allié exercé :aucun échec du passif sur déclencheur admissible ni expiration qualifiée.

Huit trajets mesurés :six réussis et deux échoués ;512échantillons,198à pleine vitesse, aucun dépassement du budget vitesse/30 à0,003près ;correction régénération sous0,002. Critère conservé :arrivée à moins de1unité et au moins10pas à pleine vitesse. Deux allers Ahri échouent à36unités du but, destination supprimée,24pas pleins puis156nuls sur180. Retours Ahri et quatre trajets Nami passent. Collecte finale0 signifie collecte aboutie ;nominal_walk_checks_all_passed et movement_fidelity_accepted restent false.

Trois essais antérieurs BUILD0/RUN101 restent des échecs :deux installations successives bloquées puis un trajet mesuré interrompu. Installation simultanée finale et collecte complète ne réparent pas ces échecs. Cause précise ouverte, sans attribution automatique à V564.

Binaire final identifié seulement en données :6086144octets SHA256 2c869cb5bbf12223895cb7a11c7f5adfb9f9346383604ed4daf0ccf153cef9e4. Chaîne/lock/1158entrées et exécution historique non requalifiés. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Formule f1/capture/niveaux, contacts QWER/soi/alliés, durée/renouvellement/cumul, ordre/caps/ralentissements, lifecycle, attribution/projection et présentation restent ouverts. Les deux échecs de navigation restent explicitement recensés.

Propre OLU-796327eb-a5eb-509b-8c33-ffd105142b86 distincte de SOURCE OLU-b4e7b166-fe56-5681-9309-05d4ccdf8d1c. Propriétaires/dépendances conservés ;aucune inconnue fermée. V564/BattleTraining et anciens échecs non requalifiés.

## 6. Corrections et reprise

36fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-NAMI-SURGINGTIDES-, suffixe -01 :METADATA,LUA,F1-FORMULA,STAT-SAMPLING,LEVELS,CONTACT-EVENT,ALLY-ELIGIBILITY,SELF-ELIGIBILITY,Q-CONTACT,W-BOUNCE,E-CONTACT,R-TRAVERSAL,ENEMY-NEGATIVE,SPELL-ADMISSION,APPLY-STATE,DURATION,EXPIRY-ORDER,REFRESH,STACKING,MULTI-OWNER,FLAT-PERCENT,CAPS,SLOWS,ITEMS,CONTROL,TARGET-LOSS,CANCEL-REFUSAL,LIFECYCLE,NAVIGATION,INTEGRATION,PROJECTION,HUD,VFX,AUDIO,VERIFICATION,COMMUNITY-CONFLICTS. Chacune possède objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Scénarios publics avec véritables contacts et bonus actifs, sans injection pour déclarer fidélité ;diagnostic navigation sous critères conservés. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves E:/mapslol3v3/audit_sys01202_nami_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2497 entrées préexistantes conservées. Prochain Nasus depuis122paires :57candidats hors65unités nommées, sanscompteglobal.

Audit borné terminé après sept rubriques ;tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF avec sauvegarde/relecture ;goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
