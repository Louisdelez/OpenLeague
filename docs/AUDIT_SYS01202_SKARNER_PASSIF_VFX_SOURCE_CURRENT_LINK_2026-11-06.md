# SYS-01.2-02 — Skarner : sources et consommateurs VFX du passif, V1402

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SKARNER-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Skarner-PASSIF-PRESENTATION-VFX`, `OLF-7cdebb3e-c7c0-5041-bf79-67f84f8c7b88` : relier les effets de Crystallizing Sting aux sources et consommateurs réels. Contrat a_faire,implémentation/acceptation false,dépendance NETWORK et six consommateurs enregistrés conservés. Inconnues VFX `OLU-a67df88f-bd29-500d-9c4d-3103d6e8e932` et SOURCE `OLU-36e0f44b-e996-5d99-b801-20c900cf047f` ouvertes. D06/lot et prérequis consultés sans satisfaction revendiquée. Parent,QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315,EUW/en_GB ;build littéral 2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/skarner-passive-crystallizing_sting-links-v631.json`,2850374 octets,SHA `87d8663b848ee1915fc3dc674f2c9645a308141aac2bcf2b21d2d356d96930ce`. UTC documentaire2026-10-26T18:18:33.165673+00:00,sans heure d’exécution déduite.

V631 :68 identités natives,204 associations,26 sites ;21 INIBIN,28 Lua,17 preloads,DDF/font. SOURCE68 identités/74 relations héritées. Métadonnées réutilisées sans nouveau décodage natif. Définition :SkarnerPassive/Skarner_Passive.dds,PV601,280029,mana272,200012,AD61,155998. PARType,Passive1/description/niveaux absents. CharScript/DDF à la racine ;quatre candidats alternatifs absents ne prouvent pas un manque global.

Font2663/4280 :sorts infligeant des dégâts appliquent des charges de Crystal Venom pendant cinq secondes,maximum trois. L’attaque suivante à trois charges inflige f1 dégâts magiques et étourdit pendant f2 secondes ;nouvelle application interdite sur cette cible pendant six secondes après l’étourdissement. Cinq secondes concernent les charges ;f2 reste inconnu. PassiveBuff2664,Cooldown2665,Stun2666 distincts.13 occurrences BuffData :12 résolues,une clé étrangère game_buff_tooltip_SionWPassive non résolue,sans alias.

28 Lua :14 initialisations littérales,39 globals,14 limites NEWTABLE,zéro prototype enfant selon reçus. Chemins complets conservés. Passive186 déclare nom/icône/persistance ;Cooldown160 et Stun156 ont des noms distincts. PassiveAttack425/pc12 et PassiveBuff259/pc4 restent non qualifiés ;SkarnerSkin03/FX/VO sont des constantes,aucune sélection prouvée. Quatre scripts56 vides ne prouvent ni Flash ni résurrection particulière. ImpaleVO/VarusQ reste un contexte étranger.

Trois chunks exposent huit champs AutoBuff :FractureSlow et VirulentSlashSlow déclarent GLOBAL_SLOW.TROY ;QEnergy1 déclare trois Skarner_Base_Q_Buf.troy sur L_crystals,R_crystals,tail_t. Ces effets Q/E ne deviennent pas les charges de Crystal Venom.

PassiveAttack.Cooldown10,réduction du propre délai Q de0,5s doublée contre champion,consommation des charges par R et proc d’attaque restent séparés. Ancien texte Fracture « prochain coup/marque » distinct du projectile/slow. DDF quatre lignes,un lien Q bonusAD×0,8 ;aucun f1/f2 passif. Communauté Q×0,5bonusAD,W/E délégués et R deux impacts sans drag/consommation prouvés :contexte statique,sans moteur C# exécuté.

17 preloads :6709 octets reconstruits exactement en CRLF depuis Discovery conservé,84 références typées (56 particules,28 sorts). Buff459 référence stack_1/2/3 et deux noms stack_3_sound. Attack403 référence e_tar_consume,passive_impact,Stun,Cooldown et fracture_heal. Stun184 référence p_tar et p_crystal_tar. Dépendances et noms de sons/soins ne prouvent pas création,attache,scénario,audio ou soin réel.

Deux DDS E relus :Characters/Skarner/HUD/Icons2D et Spells/Icons2D,2176 octets chacun,membres0.0.0.249/237. Un contenu commun,64×64 DXT1/mip0,SHA32919eee…. Identité ne prouve pas alias de lookup. Aucun payload Varus/Troy ouvert ;rendu non qualifié. source_sha256 Mana désigne le StatsJSON communautaire4418 octets/1fa0999f…,distinct du natif1636/4d1b37e3… ;PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

Seize fichiers relus,dont14 Rust/deux lecteurs Python ;32 ancres exactes. Quinze fichiers de frontières/SOURCE et28 contextes antérieurs concordants. Aucune occurrence nommée Skarner/Crystallizing/CrystalVenom sur ces14 Rust,sans absence globale revendiquée.

stuns.rs:15 expose grant_stun autoritaire,contrôle de durée/interruption ;ligne37 expire les états génériques. Il ne devient pas un producteur Crystal Venom. spells.rs:119 refuse les capacités non implémentées ;lifesteal.rs applique le dommage physique ordinaire ;shop.rs:212–232 accumule les AP d’objet. Aucun producteur de charges identifié sur ces routes.

Quatorze mécanismes VFX communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence ne qualifie ni recette passive,lookup,création/owner,attache/pose,horloge/arrêt ou pixels ;limites HUDV1274 héritées.

## 4. Attendu et observé

Attendu :états0/1/2/3,consommation,proc,stun/verrou et effets attribuables. V631 conservé :profils base/Tome1052,12 attaques ordinaires,362 relevés d’attente,54 refus,quatre trajets,cinq relevés boutique/trois transactions achat/vente/rachat.

Relecture :12 paires de dégâts attendus/observés concordent à0,002 PV près (≈51,296753). Douze paires de mana source restent pleines/identiques ;362 relevés gardent mana272,200012 et AD61,155998. Restitution sous plafond non exercée.

Cinq relevés boutique relus :inventaire vide→Tome→vide→Tome et AD/armure stables. AP0/20 enregistré au résultat final des cas,absent de chaque relevé boutique ;aucun scaling passif déduit. Aucun sort Skarner accepté,aucune charge native appliquée. L’attente181ticks/cas ne qualifie ni expiration5s des charges,ni verrou6s,ni stunf2 d’un proc non amorcé.

43/43 contrôles documentaires,66/66 cohérence même agent,six opérations journalisées réussies. Anciens55/55 et61/61 réutilisés. BUILD/RUN anciens0 ;binaire6077952 octets/SHA4c220f87… inerte. La correction héritée de formulation est revérifiée :seule la conclusion change,cinq secondes=charges/stun=f2/verrou=six secondes,61 contrôles identiques ;ancien JSON et reçus conservés. Aucun rejeu.

## 5. Écarts et limites

f1/f2/progression,éligibilité,cibles,ordre,renouvellement,expiration,propriétaires multiples,consommation R/attaque,tenacité et lifecycle ouverts. Recette/payload,lookup,création/owners/attaches/horloges/arrêts,transport et pixels non qualifiés. Aucun payload Troy lu dans ce lot,sans absence globale déduite. PVcible sortants adjacents absents,soins non vérifiés,refus par flags,garde NPC universelle absente. Aucun nouveau build/jeu/natif/REA/GPU/réseau ;V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX,avec objectifs,prérequis,fins/reprises précises :politique/recette ;charges par sorts puis proc ;événements propriétaire/cible ;effets stack/proc/stun. Sorts d’application acceptés requis pour les essais amorcés. Conserver Tome et attaques ordinaires. Reprendre sur source,mapping/callsite,recette/payload/capture précis,dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_skarner_passive_vfx_20261106 :evidence_review/coherence_review,gardes et journaux. next_lot.json cible Sona,ligne de couverture vérifiée ;chercher un audit équivalent avant reprise.

Une unité de liaison bornée close ;zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER,sans revue indépendante. Rapport et ajouts CURRENT/HANDOFF seulement,après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
