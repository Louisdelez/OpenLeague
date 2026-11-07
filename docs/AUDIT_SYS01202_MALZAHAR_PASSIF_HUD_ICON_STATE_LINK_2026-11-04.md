# SYS-01.2-02 — Malzahar : liaison de Summon Voidling au HUD, V1244

4 novembre 2026. Unité `AUD-SYS-01.2-02-MALZAHAR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit de liaison statique ; fonctionnement du passif et acceptation distincts.

## 1. Exigence et périmètre

`CH-Malzahar-PASSIF-PRESENTATION-HUD`, `OLF-c6dde872-3c10-5c63-9511-908d5cef8207` : icône, texte, rang applicable, compteur, état prêt et phases de créature. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. Inconnue `OLU-923b0c48-70d7-5285-8e74-ef1bdd8d0a75` ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs inconnues ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/malzahar-passive-summon-voidling-links-v599.json`,1567772 octets, SHA `98933be5a2f3e3d3cd8e211c7ee6907c077a571fc0257eac8004e726571af761`. UTC documentaire2026-10-26T08:11:33.994649+00:00 ; MD08:19:20.895197+00:00. Aucune date d’exécution déduite.

V599 :57 identités natives/171 associations/trois tâches,29 sites/58 liens. SOURCE :60 relations/57 identités ; HUD :une définition. Métadonnées, INIBIN, Lua, preloads et font D réutilisés sans relecture ; historique Malzahar ciblé copié sur E.

AlZaharSummonVoidling/AlZahar_SummonVoidling.dds, six niveaux absents. Personnage4229 :quatre sorts, créature incontrôlable21s ; PV200+50×niveau, dégâts20+5×niveau ; croissance7s(+50%dégâts/armure), frénésie14s(+100%vitesse d’attaque). Buffs1680–1685 :compteur, prêt au prochain sort, créature/phases et `@f1@`/`@f2@`/`@f3@`. Décompte, événement déclencheur et variables restent non résolus ; aucune politique quatrième/cinquième sort choisie.

MalzaharVoidling statique :PV200/HPPerLevel0/dégâts20/armure30/RM50/portée125/vitesse460/rayons20-10. Ces bases ne prouvent pas les statistiques invoquées ni l’héritage de l’AD. Vingt-trois Lua entièrement consommés en initialisations littérales, zéro enfant/limite NEWTABLE ; ni VM ni callbacks serveur qualifiés. CharScript natif et communautaire vides. Treize preloads relient sorts, compteur, invocation et effets de phases, sans production/rendu démontré.

Aliases conservés :SummonVoidling→Ready, Count→SummonVoidlingBuff, Detonation→SummonVoidling persistant. DanceOverride/NautilusPassive/Malady et missileQ/EzrealEssenceFluxDebuff/FallenAngel sont du contexte, sans substitution. Neuf bindings BuffData résolus, dont attraction Malefic Visions sans IA complète. Vingt-cinq références communautaires, CharScript seul établi vide ; treize NightmareBot exclus. Six chemins candidats absents, dont Malzahar.ddf et Lua dédiés Buff/Ready ; aucun DDF inventé ou manque global d’assets déduit.

Inventaire avant payload ; 3 chemins/8616 octets/3 contenus :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Spells/Icons2D/AlZahar_SummonVoidling.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.25 |
| DATA/Spells/Icons2D/AlZahar_VoidlingCharging.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.25 |
| DATA/Spells/Icons2D/AlZahar_VoidlingReady.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.25 |

Passif,Charging,Ready distincts :trois DXT1,64×64,mip brut7,membre0.0.0.25. Namespaces/priorité runtime ouverts ; QWER/aliases hérités/particules/modèles non relus. Membership/MD5/SHA identifiés, sans lookup, pixels ou GPU qualifiés. Texte relié au témoin/mirror Ahri ; font D non relu, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :6 sites/3 fichiers, lecteurs INIBIN/Lua compris. V599 :29 sites/13 fichiers et deux lecteurs ; union15 fichiers/35 ancres. Initialisation, Action/Step/Snapshot, progression, attaques ordinaires, mitigation, régénération et LongSword examinés.

WorldDefinitions insère Tibbers ; constructeur d’entité, Unit.pet/AnniePet et fonctions AnnieR(spawn, statistiques, IA, expiration) restent des acquis Annie/génériques. Aucun appel artificiel d’invocation ni producteur Malzahar établi dans ces chemins. HUD/provider/barres/QWER partiels :4 enregistrements QWER/0 non résolus ne constituent pas compteur/prêt/phases ou état de créature autoritaire.

## 4. Attendu, observé et contrôles

Attendu :lancers admissibles, compteur et état prêt cohérents, création d’une créature puis phases depuis son véritable âge. Observé hérité :deux parties Map10 Malzahar→Annie, base/LongSword(+10AD54,7→64,7), six impacts physiques non critiques avec projectiles du propriétaire, mitigation/régénération et résidu inférieur à0,002. Aucun sort Malzahar accepté ; pas de déclencheur de compteur/invocation qualifié. Le contrôle AD ordinaire ne prouve pas des dégâts de créature.

246 refus,1262 ticks d’attente, mana plafonné325,600006. Offsets209/210/211,419/420/421,629/630/631 depuis Stop ; aucune horloge de créature armée, croissance/frénésie/expiration non exercées. 32 snapshots complets conservés :pet:none et aucune définition contenant voidling, avec NPC18→42 présents. Gardes combat/attente plus fortes que trajets ; prédicats ne remplacent pas une série brute globale. Refus :snapshot_unchanged sans paires brutes ; HP d’attente absents, régénération attestée par flags/assertions. BUILD/RUN bruts0 ; inspection OBS passée, code numérique inconnu.

Sources95/95, relecture E173/173 ; consommateurs36/36, relecture E20/20. C134 courants/24 génération/union134 ; 100 fenêtres/35 ancres/21 configurations/62 chemins matériels. SOURCE :huit commandes enveloppées0/production0 ; incident du lanceur avant shell conservé séparément, sans processus ni brut inventé. Bootstrap déplacé sans altérer ses octets/argv historiques. C :collecte[1,0], erreur avant sorties sur comparaison fraîche null, corrigée en distinguant13 anciens pins/5 lectures supplémentaires ; succès non rejoué, relecture0. Resource SHA87eb0d7e… désigne le JSON communautaire6136 octets, distinct du natif61b6122d…/1806 octets. Les24 inputs de génération C sont déjà courants.

Binaire historique6057472 octets, SHA `9de2b41239abe6ede81fa6941f71ff40386a8488c88548a5054f8c125e6b41f9`, inert ; ancien répertoire revision536_yasuo conservé. Aucun nouveau build, jeu, VM, REA, réseau, rendu, audio ou GPU.

## 5. Écarts et inconnues

Admission/décompte des lancers, état initial, refus/interruptions/doublons/simultanéité et événement prêt→invocation restent ouverts. Variables dynamiques, niveau/AD propriétaire, capture/recalcul des statistiques non qualifiés. Identité/propriétaire/équipe/position/coexistence, phases7/14/21 et horloge réelle restent à établir. IA incontrôlable/priorité Malefic Visions, déplacement/collision, portée/cadence, combat/protections/contrôles/attribution/récompenses, lifecycle et multi-propriétaires distincts. Icônes, HUD, modèles/animations/particules/sons et réplication non acceptés.

## 6. Correction et reprise

Réutiliser `CH-Malzahar-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Qualifier compteur, état prêt, sort déclencheur et reset sur événements réels, sans adopter les aliases comme politique. Produire une créature autoritaire avec statistiques qualifiées ; vérifier phases avant/à/après7/14/21s depuis son invocation, interruptions et simultanéité. Couvrir ciblage/IA, déplacements/combat, coexistence/lifecycle et transport de l’état ; relier HUD fiable et invalider données périmées/non autorisées. Séparer rendu/audio/réseau et acceptation humaine. Reprise uniquement sur nouvelle preuve, mapping/producteur/consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_malzahar_passive_hud_20261104`, sourceproof/current_consumer_review, manifestes, scripts, commandes, journaux, archives, result/finalpeer. Préparateur57f8545c/gate19cac4e4 byte-exacts V1243 ; inputs courants/génération/archives vérifiés. Publication après revue :rapport et ajouts CURRENT/HANDOFF, deux sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
