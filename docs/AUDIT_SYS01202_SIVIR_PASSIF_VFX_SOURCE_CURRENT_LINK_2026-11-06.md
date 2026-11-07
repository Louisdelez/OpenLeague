# SYS-01.2-02 — Sivir : sources et consommateurs VFX du passif, V1401

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SIVIR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Sivir-PASSIF-PRESENTATION-VFX`, `OLF-54a435e8-176c-5311-afc2-34bf3562a5d7` : relier les effets de Fleet of Foot aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et six consommateurs enregistrés conservés. Inconnues VFX `OLU-71393774-8135-5883-a684-5dc1b8577eab` et SOURCE `OLU-5e9ea252-d476-51a6-a646-71be521e4f10` ouvertes. D06/lot et prérequis consultés sans satisfaction revendiquée. Parent, QWER, passif de R et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/sivir-passive-fleet_of_foot-links-v630.json`, 2624478 octets, SHA `8476b556195741c2f7dd87e559224fafa4e62b7d735b1753b3f5b468126906ef`. UTC documentaire 2026-10-26T18:03:13.636724+00:00, sans heure d’exécution déduite.

V630 : 52 identités natives,156 associations,28 sites ;20 INIBIN,19 Lua,11 preloads,DDF/font. SOURCE52 identités/58 relations héritées. Métadonnées réutilisées sans nouveau décodage natif. CharScript et DDF sont à la racine ;quatre candidats alternatifs absents ne prouvent pas un manque global.

Définition : Passive1LuaName=SivirPassive,icône Sivir_Passive.dds,vitesse335,AD52,040001,PV515,760010,mana284. PARType absent. Ancienne esquive en mouvement,15/20/25% et niveaux1/6/11/16 conservés sans adoption comme progression de Fleet.

Font2654 : toucher un champion ennemi par attaque de base ou capacité donne f1 vitesse pendant deux secondes. État accéléré2655,description4279 distincte ;montant f1,progression,éligibilité,ordre et rafraîchissement inconnus. Sept occurrences BuffData :six résolues,une clé exacte non résolue game_buff_tooltip_SivirRPassiveBuff,aucun alias automatique.

19 Lua :16 initialisations littérales,64 globals,trois limites NEWTABLE,zéro prototype enfant selon reçus. CharScript56 vide. Passive210 déclare nom/icône,persistance et non-dispellable. Speed306 déclare SivirPassiveSpeed et l’effet exact `Sivir_Base_passivehaste.troy`, attaché à `spine`. Ces déclarations ne prouvent pas création,pose ou scénario serveur.

RPassive209 porte aussi BuffName=SivirPassive,mais une icône Sprint. RPassiveBuff/Marker215 utilisent Deadeye ;providers distincts. R/WAttack/WAttackBounce restent limités à NEWTABLE,sans promotion de constantes en globals. Trois chunks exposent cinq champs AutoBuff :effet E_shield,passivehaste/spine et W_Buff/Buffbone_Cstm_Weapon_1,avec casse conservée. Effets E/W et passif ne sont pas fusionnés.

DDF28 lignes/quatre liaisons non vides :SpiralBlade bonusAD×1,SivirQ AD×Effect4,SivirW AD×Effect6/7 ;aucun producteur f1 passif. On The Hunt/Spell Shield avec espaces et alias historiques gardent leurs identités. Références communautaires Q par cônes,deux passes,W partiel/reset/TODO cooldown et E/R par buffs restent un contexte statique, sans moteur C# exécuté.

11 preloads :2053 octets reconstruits exactement en CRLF depuis Discovery conservé,26 références typées (10 particules,15 sorts,un personnage). Passive94 précharge uniquement sivirpassivespeed. Dépendances de chargement et champs effet/os ne qualifient pas le payload Troy ou une recette complète.

Un DDS E relu : Characters/Sivir/HUD/Icons2D/Sivir_Passive.dds,2176 octets,64×64 DXT1/mip0,membre0.0.0.183,SHA6ca51591…. Aucun DDS Sprint/Deadeye/particule ouvert ;identité/en-tête ne prouve pas lookup ou pixels. source_sha256 Mana identifie le StatsJSON communautaire6347 octets/9201a48f…,distinct du natif2441/9ede15c3… ;PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

Seize fichiers relus,dont14 Rust/deux lecteurs Python ;34 ancres exactes. Quinze fichiers de frontières/SOURCE et28 contextes antérieurs concordants. Aucune occurrence nommée Sivir/Fleet sur ces14 Rust,sans absence globale revendiquée.

movement.rs:19–59 combine base+objet,effets existants,slows et softcaps dont l’ordre reste reconstruit. progression.rs:118 exporte cette vitesse ;attacks.rs consomme les projectiles et appelle basic_attack_hit. lifesteal.rs applique le dommage physique ordinaire ;spells.rs:119 refuse les capacités non implémentées. Aucun producteur Fleet identifié sur ces routes.

Quatorze mécanismes VFX communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Matrice fournie par un appelant ou nom de bone ne prouve pas le producteur de pose spine. Recette,registration,horloge,arrêt et pixels restent ouverts ;limites HUDV1273 héritées.

## 4. Attendu et observé

Attendu : état accéléré après impact admissible et effet spine attribuable. V630 conservé :profils base/Bottes1001,12 projectiles/impacts sur Annie,54 refus,six trajets sans reprise,deux ordres de marche mesurée,un achat sans vente/rachat. Aucun sort Sivir accepté.

Relecture :12 paires de dégâts attendus/observés concordent à0,002 PV près (≈43,650391). Les projectiles visent Annie ;aucun bonus supplémentaire observé. Les416 observations pendant les attaques et244 après impact restent à335 ou360. Il s’agit de vitesse de déplacement,aucune vitesse d’attaque qualifiée par ces compteurs.

244 paires de coordonnées avant/après relues,dont60 pas de marche. Sommes recalculées :334,9951171875 et360 unités ;écart du premier cas conservé,tolérance0,01 sur une seconde. Arrêt après30 pas puis attente stationnaire vérifiés. Chaque fenêtre possède61 relevés ;aucun bonus produit ne permet de qualifier son expiration ou rafraîchissement.

41/41 contrôles documentaires,67/67 cohérence même agent,six opérations journalisées réussies. Anciens59/59 et57/57 réutilisés. BUILD/RUN anciens0 ;binaire6118400 octets/SHAe09998b4… inerte. Ancienne découverte progressivir.rs issue d’une substitution trop large conservée,corrigée avant ces audits ;aucun rejeu.

## 5. Écarts et limites

f1/progression,catégories de cibles,dégâts nuls/boucliers,retourQ/rebonds,ordre/softcaps,renouvellement/cumul/expiration et lifecycle ouverts. Payload/recette Troy,lookup,création/owner,bone/pose spine,horloge/arrêt,transport et pixels non qualifiés. Aucun payload Troy lu dans ce lot,sans absence globale déduite. PVcible sortants adjacents absents,soins non vérifiés,refus par flags,garde NPC universelle absente. Aucun nouveau build/jeu/natif/REA/GPU/réseau ;V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX,avec objectifs,prérequis,fins/reprises précises :politique/recette ;bonus autoritaire après impact ;événements réseau ;consommateur passivehaste/spine. Conserver Bottes,projectiles et marches génériques. Reprendre sur source,mapping/callsite,recette/payload/capture précis,dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_sivir_passive_vfx_20261106 :evidence_review/coherence_review,gardes et journaux. next_lot.json cible Skarner,ligne de couverture vérifiée ;chercher un audit équivalent avant reprise.

Une unité de liaison bornée close ;zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER,sans revue indépendante. Rapport et ajouts CURRENT/HANDOFF seulement,après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
