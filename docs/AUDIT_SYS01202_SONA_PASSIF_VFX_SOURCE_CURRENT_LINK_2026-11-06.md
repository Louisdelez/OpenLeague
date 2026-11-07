# SYS-01.2-02 — Sona : sources et consommateurs VFX du passif, V1403

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SONA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Sona-PASSIF-PRESENTATION-VFX`, `OLF-56cc56cd-4fea-5efb-88c9-ba76ed3ea96a` : relier les effets de Power Chord aux sources et consommateurs réels. Contrat a_faire,implémentation/acceptation false,dépendance NETWORK et six consommateurs enregistrés conservés. Inconnues VFX `OLU-5e99ade5-7b15-542e-8fc4-bf8763290ca1` et SOURCE `OLU-2e3459b8-b95b-5623-bfa7-0f345cb12381` ouvertes. D06/lot et prérequis consultés sans satisfaction revendiquée. Parent,QWER/auras et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/sona-passive-power_chord-links-v632.json`,3303249 octets,SHA `22f4e7b9cf6473db1351cf638edd814b6bc5b6ccd285a68d2f096c05bc579e69`. UTC documentaire2026-10-26T18:36:23.650065+00:00,sans heure d’exécution déduite.

V632 :92 identités natives,276 associations,28 sites ;30 INIBIN,37 Lua,23 preloads,DDF/font. SOURCE92 identités/98 relations héritées. Métadonnées réutilisées sans nouveau décodage natif. Définition :SonaPassive,Sona_Passive_Charged.dds,PV482,359985,mana340,600006,AD50,040001. PARType,Passive1/description absents. Niveaux8/15 non convertis en formule. CharScript/DDF à la racine ;quatre candidats alternatifs absents ne prouvent pas un manque global.

Font2673/2674 :après trois sorts hors ultime,prochaine attaque avec bonus magique f1(+f2),effet selon dernier chant activé. Description4281 omet « hors ultime » ;différence conservée. Count,Ready2676 et Debuff/Diminuendo2675 distincts. Onze occurrences BuffData exactement résolues,sans alias automatique ;compteur initial,AP/progression,ordre et consommation inconnus.

Trois liaisons Q/W/E du HUDV1275 réutilisées après garde d’identité du miroir font :2220957 octets,SHA1dd19dfe…. Aucune nouvelle analyse des lignes de font. Q11874 Staccato→Effect6=50 ;W11877 Diminuendo→base Effect4=20%,supplément f1%,Effect10=3s ;E11871 Tempo→base Effect4=40%,supplément CharAbilityPower2%,Effect8=2s. Ces champs/textes ne fournissent pas la base Power Chord,les producteurs AP ou l’ordre effectif.

37 Lua :11 initialisations littérales,12 globals,26 limites NEWTABLE,zéro prototype enfant selon reçus. Chemins complets conservés. Passive188 déclare Charged/persistance ;Count151 utilise l’icône de base ;PassiveAttack159 déclare BuffName=SonaPassiveReady ;Debuff160 a son propre nom. CharScript et Q/W/EPassiveCheck56 vides ne prouvent pas une absence d’effets. Six vues Attack/Upgrade non évaluées restent des limites ;aucun AutoBuff reconnu ne signifie pas absence native.

DDF16 lignes vides,anciens noms QWER,sans formule passive. Communauté :W35–115 contre soin natif30–110,amplification/bouclier non démontrés ;producteur E SonaSpeedBoost non retrouvé dans les scripts sélectionnés,aucune absence globale ;R par cône plutôt que ligne. Aucun moteur C# exécuté.

23 preloads :5640 octets reconstruits exactement en CRLF depuis Discovery conservé,74 références typées (32 particules,42 sorts). Count94 précharge sonapassiveattack. Q/EPassiveCheck354 référencent corerings,right/left et AttackUpgrade ;WCheck179 référence corerings/Upgrade. Les trois Upgrades préchargent q/w/e_tar_buf ;W référence PassiveDebuff,E slow,avec ifhasbuffcheck et correctifs deathrecap. Attaques ordinaires :ba_tar. Ces arêtes ne prouvent ni état prêt,sélection,création,attache ou recette complète.

Deux DDS E relus :Sona_Passive et Sona_Passive_Charged,sous Characters/Sona/HUD/Icons2D,2176 octets chacun,64×64 DXT1/mip0,membre0.0.0.243. Contenus distincts,SHAe065ea23…/2e5f9c89…. Identité ne prouve pas transition ou pixels. Aucun payload Troy/autre texture ouvert. source_sha256 Mana identifie le StatsJSON communautaire3929 octets/2bebd779…,distinct du natif1018/3af17060… ;PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

Dix-sept fichiers relus,dont15 Rust/deux lecteurs Python ;34 ancres exactes. Seize fichiers de frontières/SOURCE et29 contextes antérieurs concordants ;garde font supplémentaire distincte. Aucun producteur nommé Sona/PowerChord/Staccato/Diminuendo dans ces15 Rust ;recherche Tempo supplémentaire également vide,sans absence globale revendiquée.

slows.rs:74/78 expose application/expiration génériques ;summoner_exhaust.rs:38 réduit les dégâts pendant Exhaust. Ils ne deviennent pas Tempo/Diminuendo. spells.rs:119 refuse les capacités non implémentées ;lifesteal.rs applique le dommage physique ordinaire ;shop.rs accumule les AP d’objet. Aucun producteur compteur/dernier chant identifié sur ces routes.

Quatorze mécanismes VFX communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence ne qualifie pas recette,lookup,création/owner,attache/pose,horloge/arrêt ou pixels ;limites HUD héritées.

## 4. Attendu et observé

Attendu :trois casts admissibles,compteur/prêt,dernier chant,consommation et effets attribuables. V632 conservé :profils base/Tome1052,12 projectiles/impacts ordinaires,362 relevés d’attente,54 refus,quatre trajets,cinq relevés boutique/trois transactions achat/vente/rachat.

Relecture :12 paires de dégâts attendus/observés concordent à0,002 PV près (≈41,972809–41,972839) ;six projectiles uniques dans chaque cas. Douze paires de mana source restent pleines/identiques ;362 relevés gardent mana340,600006 et AD50,040001. Restitution sous plafond non exercée.

Cinq relevés boutique :inventaire vide→Tome→vide→Tome,AD/armure stables. AP0/20 figure au résultat final des cas,pas dans chaque relevé boutique ;aucun scaling Power Chord déduit. Aucun sort Sona accepté,aucune charge native appliquée. Compteur,attaque chargée et variantes non exercés ;attente181ticks/cas sans producteur ne qualifie pas leurs durées ou réinitialisations.

44/44 contrôles documentaires,71/71 cohérence même agent,six opérations journalisées réussies. Anciens61/61 et66/66 réutilisés ;trois bindings de font hérités,sans rejeu sémantique. BUILD/RUN anciens0 ;binaire6073856 octets/SHA52226d50… inerte. Aucun nouveau jeu rejoué.

## 5. Écarts et limites

f1/f2/AP/progression,initialisation/ordre,consommation,cibles,variantes,durée/composition,lifecycle et providers ouverts. Recette/payload,lookup,création/owners/attaches/horloges/arrêts,transport et pixels non qualifiés. Aucun payload Troy lu,sans absence globale déduite. PVcible sortants adjacents absents,soins non vérifiés,refus par flags,garde NPC universelle absente. Aucun nouveau build/jeu/natif/REA/GPU/réseau ;V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX,avec objectifs,prérequis,fins/reprises précises :politique/recette ;compteur/prêt/consommation/variantes ;événements compteur/chant ;effets prêts/cibles QWE. Sorts admissibles acceptés requis pour les essais amorcés. Conserver Tome et attaques ordinaires. Reprendre sur source,mapping/callsite,recette/payload/capture précis,dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_sona_passive_vfx_20261106 :evidence_review/coherence_review,gardes et journaux. next_lot.json cible Soraka,ligne de couverture vérifiée ;chercher un audit équivalent avant reprise.

Une unité de liaison bornée close ;zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER,sans revue indépendante. Rapport et ajouts CURRENT/HANDOFF seulement,après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
