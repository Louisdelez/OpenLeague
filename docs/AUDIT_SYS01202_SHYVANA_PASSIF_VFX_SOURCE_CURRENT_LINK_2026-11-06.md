# SYS-01.2-02 — Shyvana : sources et consommateurs VFX du passif, V1398

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SHYVANA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Shyvana-PASSIF-PRESENTATION-VFX`, `OLF-8fb8e3f8-53f7-5b4d-aa90-ed3fb62967fc` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-4c556d4b-1a88-5298-a05f-8a8e66a160e6` et SOURCE `OLU-18d54556-5b70-51ae-9d80-c482b7904714` ouvertes. Phase D06, lot et prérequis consultés sans satisfaction revendiquée. Parent et goal ouverts ; R/Furie et QWER distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/shyvana-passive-dragonborn-links-v626.json`,2828457 octets,SHA `289961f64564ae6bf9be8cb1261ee093c63d0e0513fda9ca4c788112cca2f42a`. UTC documentaire2026-10-26T16:42:29.899549+00:00, sans heure d’exécution déduite.

66 identités natives :26 INIBIN,23 Lua,15 preloads,DDF/font. V626 conserve198 associations/24 sites. Les23 chunks sont consommés selon les reçus, sans prototype enfant :14 initialisations littérales,73 globals,neuf limites NEWTABLE. Globals conservés par chemin complet. CharScript et TransformCheck56 sont vides, sans politique de transformation déduite. Sorts retrouvés dans DATA/Spells après l’ancienne recherche Characters/Shyvana/Spells : aucune absence globale conclue.

Définition Passive/ShyvanaReinforcedScales.dds,PARType=Dragonfury,BaseMP chaîne100.0,Passive1/niveaux absents. Passive388 et DragonScales227 portent des noms distincts. Buff2635/description4275 : bonus f1 d’armure et RM, seul ce bonus est doublé en dragon. Producteur f1/progression inconnus. DragonScales décrit une hausse temporaire sans équivalence automatique de provider. Huit tooltips exactement résolus. Héritage MasterYi/mana et coefficients Q/W ne fournissent pas f1.

Deux chunks Q exposent12 champs AutoBuff reconnus : DoubleAttack porte quatre effets/quatre os, DoubleAttackDragon deux effets/deux os. R_Hand/L_Hand et la casse des ressources sont conservés ; aucune substitution au passif. Passive/DragonScales n’ont pas d’AutoBuff reconnu, sans absence native inférée.

TransformCast321 reste limité à NEWTABLE pc6. Constante exacte `shyvana_shadow_dargon_transform.troy`, noms de champs de sélection FX/VO et TryndamereDemonsword conservés sans normalisation, mapping ou activation prouvés. TransformLeap/JarvanIVCataclysm et TransformDamage/Move/Minotaur restent des métadonnées étrangères, pas des règles de vol/dégâts. Persistance et flags ne prouvent aucun lifecycle serveur.

15 preloads,6354 octets,75 références typées :43 particules/30 sorts/deux personnages. Discovery1027158 octets/SHAcb852155… conserve les textes ; reconstruction CRLF exacte des15 identités. CharScript225→Passive/apbonus/DragonScales. Passive99 précharge shyvanafireballdragon2. Transform799 précharge shyvanadragon,DragonScales et les dépendances de forme, dont idle/end ; cela ne prouve pas entrée/sortie ou doublement. Ressources QWER et variantes shadow/base gardées distinctes.

Deux DDS E relus,2176 octets chacun,64×64 DXT1/mip1,membre56 : DragonsDescent/SHA6847ae3b… et ReinforcedScales/SHA2ccf22e5…. Chemins Spells/Icons2D ; aucun DDS Jarvan/Minotaur/particule ouvert. Identité/en-tête ne prouve pas lookup/variante/pixels. Source_sha256 Dragonfury=88860f3b… identifie le JSON communautaire8593 octets ; INIBIN natif3107 octets/cf408bdf… distinct.

Sélection R=ShyvanaTransformCast et données Furie héritées conservées : seuil100/coût5 par seconde, générations par attaque et horloge1,5s du tooltip distincte de la description « par seconde ». Ni ces champs ni les rangs résiduels ne prouvent une forme active ou une politique serveur complète.

## 3. Consommateurs actuels

15 fichiers relus, dont13 Rust/deux lecteurs Python ;30 ancres exactes. Quatorze fichiers SOURCE/frontières antérieurs et27 contextes concordants. Recherche Shyvana/Dragonborn sans occurrence dans ces13 Rust, sans absence globale revendiquée.

`progression.rs:99` calcule défenses génériques et mana d’objet seulement pour Mana. `lifecycle.rs:16` distingue Mana et restauration Mana/Energy ; `regeneration.rs:19` s’y conforme. `lifesteal.rs:4` applique le dommage physique ordinaire ; `spells.rs:101` refuse les capacités non implémentées, dont Shyvana. Aucun producteur Dragonborn/doublement identifié ici. Les limites HUD Furie du V1270 restent héritées.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur présence ne qualifie ni recette passive, owner/attache/pose, clip, registration ou pixels.

## 4. Attendu et observé

Attendu : bonus défensif sourcé, forme active et doublement attribuable. Hérité V626/HUDV1270 : trois profils niveau1 sans transformation,base/Tissu1029/Manteau1033 ;neuf attaques sortantes,neuf physiques entrants,trois Q Annie,543 ticks d’attente,81 refus,six trajets sans reprise,neuf relevés boutique/six transactions.

Défenses27,628/32,1 ;42,627998/32,1 ;27,628/57,1. Contrôles base+objets conservés :Tissu ajoute15 armure,Manteau25 RM. Aucun déficit historique chiffré déduit puisque f1 reste inconnu.

Relecture documentaire des neuf paires sortantes et neuf physiques entrantes, plus trois Q : calculs ordinaires et valeurs attendues sauvegardées concordants à0,002PV près. Sortants≈50,924347 ; physiques39,497620 ou35,343689 ; Q60,560192 ou50,922985. Aucun contrôle de bouclier propre exercé.

Neuf paires brutes Furie100→100,max100 ;543 relevés d’attente gardent la Furie pleine et les défenses génériques. Plafond non informatif pour le gain. Aucun sort Shyvana accepté,dragon_form_exercised=false : entrée/sortie de forme et doublement non exercés. Valeur100 ne prouve pas une transformation.

Dommages dérivés sans PVcible adjacents bruts ; soins non vérifiés, refus flags seulement et garde NPC universelle absente restent des limites. Actuel :39/39 documentaires,65/65 cohérence séparée par le même agent. Six opérations réussies ; premier appel documentaire refusé par argparse (rôle collector invalide,exit2), corrigé avec root. Journaux conservés dans operations et documentation_dispatch_correction.json. Anciens69/69 et61/61 réutilisés.

Trois JSON et deux reçus anciens BUILD/RUN0 relus ; binaire6138368 octets/SHAb46a557c… inerte, jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau, aucune expérience ancienne rejouée.

## 5. Écarts et limites

f1/progression, base/bonus/ordre/doublement, provider Passive/DragonScales, activation/fin de forme, Furie sous plafond/horloge1,5s ou1s et lifecycle ouverts. Applicabilité/recette, lookup, attache/horloge/arrêt, pixels, HUD Furie et transport non qualifiés. Trois profils niveau1 sans transformation ne couvrent pas le dragon. Variantes E/R, champs legacy et limites V564/Nami conservés.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants : politique native/forme/recette ; bonus défensif réel selon forme ; événements réseau ; consommateur VFX/ressources. Chacune définit objectif, prérequis, critères de fin et reprise. R accepté et jauge entamée sont des prérequis aux essais de forme/Furie ; conserver Tissu/Manteau. Reprendre sur nouvelle preuve native,mapping/callsite,capture précise,dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_shyvana_passive_vfx_20261106`, evidence_review/coherence_review,gardes et journaux. `next_lot.json` cible Singed,ligne de couverture vérifiée ; chercher d’abord un audit équivalent.

Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
