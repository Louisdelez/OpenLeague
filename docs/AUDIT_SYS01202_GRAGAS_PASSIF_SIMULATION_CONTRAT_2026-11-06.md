# V1477 — Gragas : contrat connu de Happy Hour

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GRAGAS-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Gragas-PASSIF-SIMULATION-CONTRAT, exigence OLF-be5db929-5179-5cbf-82f7-6eba8bd30ecc, parent SYS-01.2-02. Audit borné de dix-huit branches connues : événements de sort, soin, délai et consommateurs sélectionnés. SOURCE a_qualifier, phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/gragas-passive-happy-hour-links-v573.json : 875740 octets, SHA256 c27c66f723d83b10f76e29c0685cacb754c44fd80349e92a263b168f8aa6a968, du 26 octobre 2026. Rapport FIDELITY_GRAGAS_PASSIVE_HAPPY_HOUR_LINKS_V573.md : SHA256 d4a0652c8f29ccb58291fa1e9a7879329e463074bfd4363fb0fd3b5c0918dd07. Identités et preuves réutilisées sans nouvelle analyse native ni accès D:/F-work/EXE.

Seize identités natives retenues parmi vingt candidats, quatorze références communautaires séparées. Passive1LuaName=GragasPassive, icône GragasPassiveHeal.dds. BuffName et icône concordent ; PersistsThroughDeath=true ne démontre pas le maintien du délai après la mort.

Sept Lua entièrement parsés historiquement sans prototype enfant ; six initialisations littérales qualifiées et trente globals. GragasW dépasse le lecteur littéral sur NEWTABLE pc16 : limite conservée, aucune corruption ou exécution serveur démontrée.

Six clés en_GB interrogées : quatre présentes, deux absentes. Tooltip GragasPassive ligne1960 et description ligne4196 annoncent 4 % des PV maximum lors d’un lancement de sort, au plus une fois toutes les huit secondes. f1 affiche le montant ; fournisseur, échantillonnage et calcul runtime restent inconnus.

GragasQ résout un texte ; GragasW et GragasE ne résolvent pas leurs clés dans ce font. Ces deux bindings sans texte ne prouvent pas des fichiers absents. Les quatre candidats WAttackBuff/WSelf INIBIN/Lua sont exclus de l’autorité du passif ; leurs textes ne remplacent pas ces clés automatiquement.

Q déclare DoesntTriggerSpellCasts=false, QToggle=true. QToggle conserve Flash Frost/Cryophoenix_FrigidOrb.dds ; la définition conserve un texte Alistar, +400/+600 PV et niveaux10. Ces données héritées ne sont ni réécrites ni adoptées comme règles de Happy Hour. Un preload référence gragaspassive, apbonusdamagetotowers et rengar_base_w_heal.troy, sans preuve de soin ou de rendu.

## 3. Consommateurs réels

Vingt-sept entrées concordent avec V573 : dix-sept Rust, deux lecteurs Python, huit JSON. Avec le miroir en_GB, 28 identités gardées. Trente-quatre fenêtres : 32 communes réutilisées, deux ciblées sur le dispatch des invocateurs et Soin. Vingt et une ancres enregistrées, dont vingt frontières entry_boundary_only, provides_feature_consumer=false pour Happy Hour.

Les chemins learn/cast/cast_at inspectés et les essais hérités refusent Gragas ; aucun événement de sort Gragas accepté n’est établi. Simulation::heal est un mécanisme générique distinct : fin de partie, quantité non finie/négative, source inconnue et cible morte/inconnue sont gardées statiquement. Le soin applique received_multiplier puis plafonne à max_health. Ignite et TrundleW participent à ce multiplicateur ; leur effet sur Happy Hour n’est pas exécuté ici.

Action::Summoner passe par cast_summoner_on puis cast_heal. Ce contrôle calcule un montant par niveau du destinataire et une éventuelle réduction de Soin récent, appelle heal et met son propre cooldown. Il ne constitue pas un déclencheur de Happy Hour. La régénération ordinaire est un autre chemin.

Recherche littérale Gragas/HappyHour sur dix-sept Rust sélectionnés : zéro occurrence ; aucune absence globale, analyse de tous les modules ou revue des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : relier les sources aux consommateurs et distinguer cast refusé, soin générique et passif réussi. Observé : 64/64 contrôles documentaires et 87/87 cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V573 hérité : deux simulations publiques Gragas/Annie niveau1, sans injection directe selon les preuves. Cinq attaques reçues chacune, dix impacts physiques avec projectiles témoins ; quarante refus atomiques et six cents ticks de suivi. La correction de régénération concorde avec la mitigation physique selon V573, résidu inférieur à0.002, sans nouveau recalcul des séries float32.

Cas base : maxHP583.52001953125 ; achat public du Cristal1028 : maxHP733.52001953125, soit +150. Blessure supérieure à90PV ; Soin restaure exactement90PV dans les deux cas. Le contrôle démontre Soin et l’effet de l’objet, pas un soin de4 % après capacité Gragas réussie.

heal_rules.json donne niveau1=90, +15 par niveau, cooldown240s/7200ticks ; le conflit natif300s et l’interprétation communautaire par niveau sont conservés. Ces valeurs ne sont pas l’autorité du délai8s du passif. Les300ticks par cas ne vérifient pas l’expiration d’un Happy Hour jamais déclenché.

Exécutable V573 identifié uniquement en données : 6018048 octets, SHA256 d12672adae3aa86b35a7ea5a0929453219a6300262e4ce6564605802f25565d5. Aucun accès/lancement ; verrou, toolchain, 1158 entrées et dépendances non revalidés. Ancien préparateur de livraison ayant refusé un remplacement trop large conservé : ce n’est pas un échec de compilation du moteur.

## 5. Écarts et conclusions ouvertes

Restent événements éligibles Q/W/E/R/recasts, ordre/annulation, fournisseur f1, arrondis, mesure des PVmax, délai et disponibilité initiale, santé pleine, modificateurs, mort/réapparition, transitions de session, réplication et présentation. Le succès du contrôle Soin ne clôt aucune de ces questions.

Question propre OLU-367f6204-98da-5a49-9d2c-86ebcd46647d et SOURCE OLU-f02e8416-c02a-5081-8856-c28af71e1706 conservées chez leurs propriétaires ; aucune inconnue fermée. Défaut déplacement V564 non corrigé par les trajets réussis.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GRAGAS-HAPPY-HOUR-, suffixe -01 : CAST-ELIGIBILITY, RECAST, CAST-ORDER, AMOUNT-F1, MAX-HEALTH-SAMPLE, COOLDOWN, INITIAL-READINESS, CAP-ZERO, HEAL-MODIFIERS, DEATH, SESSION, PROJECTION, PRESENTATION, TOOLTIP-BINDINGS, ALIAS-AUTHORITY, VERIFICATION.

Objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise présents pour chacune. Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert ; aucune correction enregistrée/implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_gragas_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2463 entrées groupées préexistantes conservées. Prochain Graves depuis 122 paires ; 91 candidats hors31 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans acceptation humaine ni revue indépendante. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Analyses communes réutilisées, aucun gain temporel mesuré.
