# V1482 — Janna : contrat connu de Tailwind

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-JANNA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Janna-PASSIF-SIMULATION-CONTRAT, exigence OLF-5ecff11e-f13b-57e0-b2c7-3fac0534d327, parent SYS-01.2-02. Audit borné de seize branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/janna-passive-tailwind-links-v578.json du 26 octobre 2026 : 847619 octets, SHA256 b80ba782d7f5585d0c3d85a0c2dd59cc1f4c210894871b82a49bd716e9009ecd. Rapport FIDELITY_JANNA_PASSIVE_TAILWIND_LINKS_V578.md : SHA256 7f5a88a364f18704e952fa65dcc9d8ad9f6f26b26c191b8e03133b341c232923. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Treize identités natives aux rôles distincts, dix références communautaires séparées, deux preloads. Quatre Lua entièrement parsés historiquement, sans prototype enfant ; trois initialisations littérales et six globals. NEWTABLE au pc18 de SowTheWind limite le lecteur littéral, sans corruption démontrée ni exécution serveur.

Cinq clés en_GB vérifiées, dont trois bindings de buffs : Tailwind ligne 2745 écrit +5 %, TailwindSelf ligne 2746 vise Janna et ses alliés proches, Zephyr ligne 2997 concerne le W et le passage à travers les unités. La description du personnage ligne 4203 vise tous les alliés. Politique globale ou locale, portée effective et auto-application demeurent inconnues.

TailwindSelf est déclaré par le personnage ; les deux buffs et son icône concordent sur Janna_Tailwind.dds. Source PersistsThroughDeath/NonDispellable=true ; champs absents du buff reçu non convertis en false. Le DDF contient quatre entrées W, sans formule du passif. Zéros littéraux de niveau, champs absents et ancienne chaîne « 5 Astral Spirts » ne définissent pas la force du passif. Preloads et métadonnées ne prouvent ni déclenchement ni rendu.

## 3. Consommateurs réels

Trente et une entrées concordent avec V578 : vingt Rust, deux lecteurs Python, neuf JSON. Avec le miroir en_GB, 32 identités gardées. Trente-huit fenêtres, dont 32 communes réutilisées et six sur vitesse, rayons, corps alliés, déplacement, Soin et admission des sorts d’invocateur. Vingt-trois ancres enregistrées, dont 22 frontières entry_boundary_only/provides_feature_consumer=false. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

movement_speed calcule base et objets, modificateurs courants, ralentissements, plafonds puis pénalité de traversée Garen. Aucun terme Tailwind dans ce calcul. stats utilise ce même lecteur ; advance_allied_motion en tire son budget vitesse/30. living_bodies sélectionne des corps pour la géométrie, pas des destinataires d’aura. Soin conserve un bonus temporaire distinct.

Recherche littérale Janna/Tailwind/SowTheWind/Zephyr sur vingt Rust sélectionnés : zéro occurrence. Ce constat ne prouve ni absence globale ni inspection des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer textes natifs, aura, W et contrôles bottes/Soin. Observé : 68/68 contrôles documentaires, 99/99 cohérences du même agent et quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V578 hérité : quatre cas publics combinent bottes 1001 et Soin. Ahri alliée se trouve à 250 puis 1249.99951171875 unités ; ces distances ne sont pas des frontières natives qualifiées. Sans Soin, vitesse 330 ou 355 avec bottes. Soin donne 426.20001220703125 ou 452.20001220703125, puis retour à 330/355 au tick 30. Janna et Annie restent à 335. Aucun bonus Tailwind observé dans ces cas, sans conclusion d’aura native nulle.

240 ticks, 40 pas mesurés, résidu vitesse/30 inférieur à 0,005 unité ; après Stop, déplacement nul. Soixante-dix refus avec snapshots inchangés : 60 refus Janna, huit cibles Soin invalides, deux cooldowns. Aucune injection d’état ni activation W. Les plafonds locaux restent historiquement non qualifiés ; Soin conserve son conflit 240/300 secondes, sans autorité sur Tailwind.

Exécutable V578 identifié uniquement en données : 6031872 octets, SHA256 71373f316991eec8cc40245a8bd8bdccda96b5a8ce549b87f8523ef62cac7d3b. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés. Échecs antérieurs Irelia/Heimerdinger conservés, non rejoués. Une invocation initiale du répartiteur omettait le rôle ; refus avant tout producteur, documenté dans root_dispatch_failure.json, puis invocation complète réussie. Ce refus n’est pas un échec moteur ni une cinquième opération productrice.

## 5. Écarts et conclusions ouvertes

Restent politique globale/proche, auto-application, portée, destinataires, base du pourcentage, ordre avec bonus/ralentissements/plafonds, cadence, refresh, sources multiples, recomposition après achats, cycle de vie, réplication et présentation. W/Zephyr demeure séparé.

Question OLU-ef8dd5c4-547b-5d26-b6a2-4ae079437b4a, dépendances et propriétaires SOURCE conservés. Aucune inconnue fermée ; défauts antérieurs de déplacement, dont V564, non corrigés.

## 6. Corrections et reprise

Seize fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-JANNA-TAILWIND-, suffixe -01 : SCOPE, SELF, RADIUS, RECIPIENTS, PERCENTAGE-BASE, COMPOSITION, SAMPLING, REFRESH, MULTISOURCE, ITEM-RECOMPUTE, TEMPORARY-EFFECTS, W-SEPARATION, LIFECYCLE, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_janna_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2468 entrées groupées préexistantes conservées. Prochain JarvanIV depuis 122 paires ; 86 candidats hors 36 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
