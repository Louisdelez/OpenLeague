# SYS-01.2-02 — Singed : sources et consommateurs VFX du passif, V1399

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SINGED-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Singed-PASSIF-PRESENTATION-VFX`, `OLF-585ed75d-fc5b-5df0-9dad-8c5b00b1ea48` : relier les effets applicables du passif aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et six consommateurs enregistrés conservés. Inconnues VFX `OLU-697759cc-495e-542c-9162-73194a58fd39` et SOURCE `OLU-c877b812-d034-570f-8616-fda500eaed3e` ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. Conversion, HUD et QWER gardent leurs clauses propres ; parent et goal ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct.

Trois reçus conservés sous docs/reference_requirement_trace_sources : `singed-passive-conversion-links-v543.json` (420876 octets, SHA e8d904cb…), `singed-passive-empowered_bulwark-links-v627.json` (3423295, SHA 47e1751e…) et `singed-passive-empowered_bulwark-links-v628.json` (5800797, SHA `56ac3b2da2856a917b7b7d2344f59f5b65ffa760c961d112d5d0470b62024d67`). Identités complètes dans initial_scope.json et result.json. Horodatage documentaire V628 : 2026-10-26T17:13:41.756911+00:00, sans heure d’exécution déduite.

V543 contient six identités, V627 trente-deux, V628 une addition : union de 33 ressources, comprenant 10 INIBIN, 14 Lua, huit preloads et la font. Les six anciennes sont incluses dans l’union. Le delta V628 ne représente pas tout l’inventaire.

`DATA/Spells/Empowered Bulwark.inibin`, avec espace : 49 octets, SHA eb11bb55…, membre 0.0.0.120. Le hash 2287725201 lie le tooltip exact. Omission du filtre V627 déjà corrigée en V628 ; fichier déjà cité en V543. Le candidat sans espace reste distinct, sans normalisation du loader prouvée.

Définition : Passive1LuaName="Empowered Bulwark", icône Singed_Passive.dds ; Lua230 : même BuffName, ChemicalMan_EmpoweredBulwark.dds, persistance/non-dispellable déclarés. PARType, Passive1 et niveaux absents ; vieux texte de réduction magique 10% non adopté. Tooltip1867 : f2 PV pour f3 mana, bonus affiché f1 ; description4277 : 25 PV/100 mana. Assiette, producteurs, arrondis et lifecycle inconnus.

Quatorze Lua inchangés entre V627/V628 : 11 initialisations littérales, 28 globals, trois limites NEWTABLE, zéro prototype enfant selon reçus. CharScript et deux scripts de contexte font56 octets sans globals ; aucune absence serveur déduite.

Trois chunks exposent cinq champs AutoBuff : W/global_slow, Q/Global_Poison attaché à C_BUFFBONE_GLB_HEAD_LOC et deux champs vides de QApplicator. Aucun AutoBuff reconnu dans EmpoweredBulwark. Q/W/R restent limités à NEWTABLE pc10/4/8 ; constantes skin06, RunePrison_tar et toggle restent non mappées. EFlashLock/Haste ne qualifie pas Flash ni le passif.

Huit preloads : 1830 octets reconstruits exactement en CRLF depuis Discovery conservé, 24 références typées (9 particules, 13 sorts, deux personnages testcube). CharScript224 précharge empoweredbulwark/apbonusdamagetotowers/singedeflashlock. Ressources poison, flaques vertes/rouges, racines base/skin06, Fling et InsanityPotion distinctes. Aucune recette passive complète ni création prouvée par ces dépendances.

Deux DDS capturés sur E relus : ChemicalMan,4224 octets/DXT5/mip0/membre25/SHA41d0b90c… ; Singed_Passive,2176/DXT1/mip0/membre0.0.1.2/SHA709a45ff…. Tous deux64×64, contenus distincts. Identité/en-tête ne prouve pas lookup ou pixels. Source_sha256 Mana identifie le JSON communautaire8122 octets/1b1345f6…, distinct du natif3060 octets/584bdbd0… ; PARType absent ne signifie pas chaîne Mana.

## 3. Consommateurs actuels

Quinze fichiers relus, dont13 Rust et deux lecteurs Python ; 33 entrées d’ancre,32 uniques, concordantes. Quatorze fichiers de frontières/SOURCE et27 contextes antérieurs inchangés. Aucune occurrence nommée Singed/Bulwark dans ces13 Rust, sans absence globale revendiquée.

progression.rs:110–117 calcule séparément mana et PVmax ; PVmax=base+croissance+PV des objets, sans terme mana sur cette route. shop.rs:314 conserve les pools courants et les plafonne. spells.rs:119 refuse les sorts non implémentés. Régénération générique conservée. Quatorze mécanismes VFX communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ; aucune création, attache, pose ou recette passive qualifiée par leur présence.

## 4. Attendu et observé

Attendu : conversion sourcée, état attribuable et effets applicables reliés. V627/V628 conservent exactement les observations du même RUN : trois profils niveau1, 18 attaques ordinaires,543 relevés d’attente,81 refus,six trajets,neuf relevés boutique/six transactions. Aucun sort Singed accepté.

Relecture documentaire : 18 paires dégâts attendus/observés concordent à0,002 PV près (≈52,273102). Dix-huit paires source gardent mana/plafonds ;543 relevés restent au plafond. Régénération sous plafond non exercée.

Neuf relevés boutique relus : Rubis ajoute150 PVmax ; Saphir ajoute200 mana maximal sans hausse des PVmax. Achat/vente/rachat conservent immédiatement les pools courants. Capacités PV/mana :542,76001/290,60001 ;692,76001/290,60001 ;542,76001/490,60001. V543/Singed et Ahri restent des essais antérieurs séparés. L’illustration textuelle +50 PV n’est pas une formule serveur qualifiée.

42/42 contrôles documentaires,67/67 cohérence même agent ; six opérations journalisées réussies. Anciens72/72 et60/60 réutilisés. BUILD/RUN anciens0 ; identité binaire6093824 octets/SHA3df7aa3c… inerte. Collecteur ancien1 sur hypothèse de mana incomplet conservé, relecture du même RUN0. Anciennes erreurs CHECK restent héritées. Une lecture initiale d’un helper inexistant est décrite dans root_context_note.json ; aucun incident masqué.

## 5. Écarts et limites

Conversion absente de la route PVmax inspectée ; f1/f2/f3, assiette, ordre, arrondis, lifecycle et résolution effective des noms ouverts. Applicabilité/recette VFX, création/owner/attache/horloge/arrêt, pixels et transport non qualifiés. Dommages dérivés sans PVcible adjacents ; soins non vérifiés, refus par flags, garde NPC universelle absente. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; limites V564/Nami et QWER conservées.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX, avec objectifs, prérequis, fins et reprises précises : politique/recette, conversion autoritaire, événements réseau, effets applicables. Conserver les contrôles Rubis/Saphir. Reprendre sur nouvelle preuve native, mapping/callsite, recette/capture précise, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_singed_passive_vfx_20261106 : evidence_review/coherence_review, journaux, gardes et identités. next_lot.json cible Sion, ligne de couverture vérifiée ; chercher un audit équivalent avant reprise.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER, sans revue indépendante. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept protégés contrôlés. Goal/Plan/UI/bases/registres/produit conservés.
