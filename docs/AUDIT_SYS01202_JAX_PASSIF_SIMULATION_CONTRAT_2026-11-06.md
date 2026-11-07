# V1484 — Jax : contrat connu de Relentless Assault

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-JAX-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Jax-PASSIF-SIMULATION-CONTRAT, exigence OLF-d9ef78c3-776b-5347-9db8-c8f944aa491b, parent SYS-01.2-02. Audit borné de dix-sept branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/jax-passive-relentless_assault-links-v580.json du 26 octobre 2026 : 949177 octets, SHA256 0959092692f046b63be383d0113650ddbf2cff38e20a2a2226d927ed735ba04d. Rapport FIDELITY_JAX_PASSIVE_RELENTLESS_ASSAULT_LINKS_V580.md : SHA256 351cda621e6556a3584732572c762cd756750bfce85d6c78045d7. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Vingt et une identités natives aux rôles distincts, références communautaires séparées, cinq preloads et deux FX identifiés sans rendu. Sept Lua entièrement parsés historiquement, sans prototype enfant ; six initialisations littérales et 24 globals. NEWTABLE au pc6 de JaxRelentlessAttack limite le lecteur littéral, sans corruption démontrée. Globals CharScript vides et flags de sorts ne prouvent pas l’exécution serveur.

Dix recherches exactes en_GB : neuf clés résolues et game_buff_tooltip_JaxRelentless_Assault absent. La clé ressemblante sans underscore, ligne 2097, reste séparée. JaxPassive ligne 2096 annonce @f1@ % pendant 2,5 secondes, maximum six cumuls. Coefficient, déclencheur et politique des cumuls restent inconnus. Description personnage ligne 4205 et nom conservés.

Spell4=JaxRelentlessAssault et ExtraSpell3=JaxRelentlessAttack concernent le R. Ses trois bindings 9508/10220/11604 décrivent Grandmaster’s Might, troisième coup magique et défense active ; DDF12 entrées R/Q/E, sans JaxPassive. Aucun coefficient défensif adopté comme bonus AS.

Icône personnage/buff AS Armsmaster_MasterOfArms.dds distincte de JaxPassive Armsmaster_CoupDeGrace.dds, sans écrasement. Persistance source true ; champ absent du buff AS non complété. Speed nomme RelentlessBarrier ; Debuff porte IsDebugMode=true sans BuffName inventé. Passive1=9 et niveaux 3/7/11/15, niveaux absents 5/6 et anciennes chaînes dégâts d’objets/mana ne deviennent pas une formule.

## 3. Consommateurs réels

Vingt-quatre entrées concordent avec V580 : quinze Rust, deux lecteurs Python, sept JSON. Avec le miroir en_GB, 25 identités gardées. Les 32 fenêtres communes sont réutilisées après comparaison des octets et lignes. Trente et un descripteurs enregistrés, dont trente frontières entry_boundary_only/provides_feature_consumer=false, correspondent à 29 lignes distinctes ; leurs rôles hérités sont conservés. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

stats calcule la cadence depuis croissance, objets et modificateurs actuellement implémentés, sans contribution de cumuls Jax. Le dénominateur est borné à 0,05, le quotient arrondi puis borné à douze ticks. advance_attacks utilise cette cadence pour le windup et next_attack ; basic_attack_hit livre le physique sans mise à jour Jax identifiée. Ces limites locales ne sont pas une qualification native.

Recherche littérale Jax/Relentless sur quinze Rust sélectionnés : zéro occurrence. Pas d’absence globale ni d’inspection des 1158 dépendances revendiquée. Réapparition et départ sont inspectés statiquement, sans validation du lifecycle du passif.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer passif AS, R, contrôle Dague et mesures entières. Observé : 78/78 contrôles documentaires, 109/109 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V580 hérité : deux cas publics Jax/Annie, base ou Dague 1042. Chacun produit huit impacts ininterrompus, 120 ticks de pause, un impact, puis 90 ticks de suivi. Sept intervalles constants de 47 ticks sans objet, 41 avec Dague ; même cadence après pause. Les dix-huit impacts sont ordinaires, sans critique, acteurs vivants au niveau 1, sans injection d’état. Résidu maximal physique 0.000011444091796875, inférieur à 0,002, après prise en compte de la régénération.

Dague ajoute localement 15 % et donne arrondi(47/1,15)=41. Ce contrôle ne valide ni coefficient ni arrondi ni plafond natifs. Une cadence entière constante peut masquer de petits gains ; le code inspecté ne contient toutefois aucune contribution Jax. Huit attaques ne qualifient pas six cumuls. La pause excède 2,5 secondes, mais sans cumul actif elle ne prouve pas son expiration.

Trente refus atomiques avec snapshots inchangés ; 420 ticks cumulés de pause/suivi. Niveaux supérieurs, R appris, changement de cible, annulation, mort/réapparition, réseau et rendu non exercés.

Exécutable V580 identifié uniquement en données : 6018048 octets, SHA256 472a02372d57fd1a7574c3cab3ad83600beb380a06967c4c1e36fda3ce0356ab. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés. V580 documente un ancien finisher refusant le compteur trois au lieu de quatre inconnues propres, corrigé séparément avec originaux conservés et sans rejeu runtime. Cette histoire n’est pas une nouvelle clôture d’inconnues ; preuve initiale, correction et erreurs Jarvan antérieures restent conservées.

## 5. Écarts et conclusions ouvertes

Restent coefficient/niveaux, déclencheurs/cibles, accumulation, refresh/expiration, intégration cadence/windup, composition et plafonds, précision/arrondis, idle/switch/cancel, cycle de vie, clé effective, rôles d’icônes, réplication et présentation. R reste séparé.

Question OLU-fa664b02-1389-5682-ae97-aeafcae121e7, dépendances et propriétaires SOURCE conservés. Aucune inconnue fermée ; déplacement V564 non corrigé.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-JAX-RELENTLESS-ASSAULT-, suffixe -01 : F1-PROVIDER, TRIGGERS-TARGETS, STACK-STATE, REFRESH-EXPIRY, CADENCE-INTEGRATION, COMPOSITION, NUMERIC, IDLE-SWITCH, ATTACK-CANCEL, LIFECYCLE, R-SEPARATION, TOOLTIP-ALIAS, ICON-ROLES, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_jax_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2470 entrées groupées préexistantes conservées. Prochain Jayce depuis 122 paires ; 84 candidats hors 38 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
