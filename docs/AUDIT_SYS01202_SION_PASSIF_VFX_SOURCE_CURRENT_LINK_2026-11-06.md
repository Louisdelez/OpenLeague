# SYS-01.2-02 — Sion : sources et consommateurs VFX du passif, V1400

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SION-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Sion-PASSIF-PRESENTATION-VFX`, `OLF-c11520f3-8373-579a-92ba-8b65c3249d62` : relier les effets applicables de Glory in Death aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et six consommateurs enregistrés conservés. Inconnues VFX `OLU-83dbad56-dc08-56f0-b6e4-b3365593f398` et SOURCE `OLU-d3b93b38-453f-59e3-acbc-dfe83bab6066` ouvertes. D06/lot et prérequis consultés sans satisfaction revendiquée. Parent, QWER, cumul du W et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/sion-passive-glory_in_death-links-v629.json`,4334760 octets,SHA `1b0ca07a579831d8a2242d1dd01916c1258b96c29d1227b09c802ab7f9452bfe`. UTC documentaire2026-10-26T17:43:49.646218+00:00, sans heure d’exécution déduite.

V629 conserve150 identités natives :57 INIBIN,66 Lua,25 preloads,DDF/font ;450 associations/26 sites. SOURCE150 identités/156 relations héritées ; delta et relation ne remplacent pas l’inventaire. Métadonnées reprises sans nouveau décodage natif.

Deux SionPassive.inibin distincts : fichier Spells43 octets/SHA c04b9384… lié au tooltip ; racine1254/SHA b865d50d… . Les définitions racines SionPassive/SionBerserk/SionMax portent420 PV/50 AD, sans sélection de zombie qualifiée. Définition choisie :542,640015 PV,275,600006 mana,59,720001 AD, Passive1LuaName=SionPassive,icône Sion_Passive1.dds. PARType,Passive1/niveaux absents ; CharScript racine56 vide. Quatre candidats absents restent une recherche bornée.

Font2644/4278 : réanimation,mouvement/attaque,PV décroissants,100% vol de vie,bonus physique10% PVmax cible,cap75 contre les monstres et remplacement des quatre sorts par Death Surge. Le cap n’est pas étendu aux sbires. Zombie2646 et Speed2645 distincts.37 occurrences BuffData :19 résolues exactement,18 sans traduction,aucun alias automatique.

66 Lua :45 initialisations littérales,220 globals,21 limites NEWTABLE,zéro prototype enfant selon reçus. Chemins complets conservés. Passive414/Delay413/Speed412 restent limités à pc16,Zombie483 à pc18 : constantes SionPassiveTooltip/Zombie/Speed,PersistsThroughDeath et ZiggsSnowday non promues en globals. Deux BasicAttackPassive115 contiennent LeonaSkin04 à pc0 ;aucune sélection de clip déduite. SoundEnd269 déclare SionWSoundExplosion/toggle1, sans callback de fin prouvé.

Quatre champs AutoBuff de contexte : E/W/WDetonate déclarent l’Event DeathsCaress_buf.troy ; QSlow déclare l’Effect Global_Slow.troy. Event et Effect restent distincts. Death Surge : Cooldown chaîne100,coût0,Effect1=100,Effect2=30,Effect3≈0,15,Effect4=0,1 ; rôles/unités non qualifiés. DDF12 lignes/cinq liaisons QWR,aucune décroissance attribuée. Délai communautaire2s,buff60s,vitesse50%/1,5s et formule de décroissance restent des pistes sans politique native qualifiée.

25 preloads :9655 octets reconstruits exactement en CRLF depuis Discovery conservé,134 références typées (62 particules/70 sorts/deux personnages). Passive156 précharge Delay/Speed ; Delay313 référence Zombie/SoundEnd et sion_base_passive_cas/skin.troy. Zombie729 référence smoke/hand/tar,Sunfire,QWER,Yorick ;Speed304 référence sion_base_passive_speed.troy,darkbinding_tar.troy et vi_q_tar.troy. Ces arêtes ne prouvent ni scénario,ni applicabilité des dépendances étrangères,ni création/attache.

Un DDS E relu : Characters/Sion/HUD/Icons2D/Sion_Passive1.dds,2176 octets,64×64 DXT1/mip0,membre0.0.0.254,SHA93491065…. Aucun payload Passive2/particule ouvert. Identité/en-tête ne prouve pas lookup ou pixels. source_sha256 Mana désigne le StatsJSON communautaire4634 octets/dfe2043c…,distinct du natif1415/881fbc36… ;PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

Quinze fichiers relus,dont13 Rust/deux lecteurs Python ;32 ancres exactes. Quatorze fichiers de frontières/SOURCE et27 contextes antérieurs concordants. Aucune occurrence nommée Sion/Glory sur ces13 Rust,sans absence globale revendiquée.

lib.rs:603 refuse les commandes à PV≤0 ;damage.rs:115 programme la réapparition générique ;lifecycle.rs:33–83 restaure position/pools et efface l’échéance. lifesteal.rs:17 applique le dommage physique ordinaire puis le soin générique ;spells.rs:119 refuse les capacités non implémentées. Aucun producteur réanimé identifié sur ces routes.

Quatorze mécanismes VFX communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence ne qualifie pas recette passive,owner,attache,pose,horloge,arrêt ou pixels ;les limites HUDV1272 restent héritées.

## 4. Attendu et observé

Attendu : transition réanimée,actions/attaques/slots attribuables et effets applicables reliés. V629 conservé : deux profils niveau1 base/Rubis,12 mêlées sortantes,34 impacts physiques entrants,deux morts/réapparitions,six trajets,144 refus dont90 pendant la mort. Un achat Rubis,aucune vente/rachat.

Relecture documentaire :12 paires de dégâts attendus/observés ordinaires concordent à0,002 PV près (≈50,092255).34 paires brutes de PV entrants relues avec régénération,mitigation et clamp létal,tolérance0,002. Rubis ajoute150 PVmax ; AD,cadence44 et vol de vie0 restent génériques.

960 trames relues :479 à zéro PV/position de mort par cas,soit958 ;pools pleins/retour fontaine au tick480. Aucun intervalle réanimé observé.45 refus morts par cas avec erreur champion dead et flags inchangés ;pas de paires brutes de refus déduites. Aucun sort Sion accepté.

46/46 contrôles documentaires,69/69 cohérence même agent,six opérations journalisées réussies. Anciens58/58 et59/59 réutilisés. BUILD/RUN anciens0 ;binaire6149120 octets/SHA2e29db3a… inerte. Ancien décompte18→19,libellé achat seul et échec HUD coherence01=1 corrigé par renommage de liaison sont conservés,avec leurs reçus ;aucun rejeu.

## 5. Écarts et limites

Réanimation non observée ;délai,statistiques initiales,décroissance,cadence/vitesse,ordre,variantes,fin/réentrance,bonus/vol de vie/cap et quatre slots restent ouverts. Applicabilité/recette,lookup,création/owner/attache/horloge/arrêt,transport et pixels non qualifiés. PVcible sortants adjacents absents,soins non vérifiés,refus par flags,garde NPC universelle absente. Aucun nouveau build/jeu/natif/REA/GPU/réseau ;V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX,avec objectifs,prérequis,fins/reprises précises : politique/variantes/recette ;lifecycle réanimé,attaques/soins et Death Surge ;événements réseau ;effets des phases délai/zombie/accélération/fin. Conserver morts/refus génériques et Rubis. Reprendre sur nouvel artefact serveur,mapping/callsite,recette/capture précise,dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_sion_passive_vfx_20261106 : evidence_review/coherence_review,gardes et journaux. next_lot.json cible Sivir,ligne de couverture vérifiée ;chercher un audit équivalent avant reprise.

Une unité de liaison bornée close ;zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER,sans revue indépendante. Rapport et ajouts CURRENT/HANDOFF seulement,après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
