# SYS-01.2-02 — Zyra : Rise of the Thorns, sources et consommateurs VFX, V1433

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-ZYRA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

Tâche `CH-Zyra-PASSIF-PRESENTATION-VFX`, exigence `OLF-29bebc84-b65e-545c-befc-e0e6661af2cc` : relier mort,forme,entrée/tir et effets déclarés aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues dans initial_scope.json. V658/HUD V1307 et corrections conservés. Cette liaison ne termine ni passif,QWER,fonctionnalité ou goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus,catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/zyra-passive-rise_of_thorns-links-v658.json`,4064403octets,SHA `0544dc4753ae5c3996d4e587d3425b8398b614fd1a7be51062f18c4f9947b735`,UTC hérité2026-10-27T04:24:46.452268+00:00. Copies E retenues ;aucun nouvel accès D ou F/OpenLeague-work.

39primaires :12INIBIN,15Lua,10preloads,DDF,font ;90identités liées non promues. Zyra.inibin2472/SHA `b96ea240a1c0b622ad98f2aba59e4a9b5f08571a4cc9820c5ff4bd77acc060ec` :ZyraPassiveDeathDisplay/ZyraP.dds. Passive1/Desc/Level1..6 absents,non zéro.

56vues Lua consommées entièrement antérieurement,zéro prototype enfant ;35littérales,118globals,21limites NEWTABLE. Quinze chunks directs conservés par chemin complet ;deux CharScriptZyraThornPlant56 vides restent distincts sous ZyraPassive et ZyraThornPlant. Huit vues de dépendances de personnages :deux scripts,deux preloads,quatre INIBIN,non huit apparitions vérifiées. Base6PV/−2AD de ZyraPassive non dégâts f1.

DeathDisplay397 déclare KogMaw_IcathianSurprise,persistance/non-dissipation ;Ready217 associe icône ZyraP à BuffName KogMawIcathianSurpriseReady. Quatre chunks214/436/455/600 non interprétés gardent les constantes étrangères et limites :DarkBinding/CyberEzreal,Akali/ChainMissileParameters/MaximumHits,skins. Aucune association propriété-valeur,recette ou callback déduite de leurs constantes. Les références KogMaw/Akali/Morgana/Ezreal/Caitlyn restent intactes.

Six vues AutoBuff littérales,18champs,dont12vides conservés. VengefulPlant320 nomme Temp_Zyra_Plant_Enrage.troy/Vine_5 ;Slow/Indicator/DR/Vision sont des contextes distincts. Nom de bone déclaré distinct d’une pose ;aucune recette universelle ou absence d’effets déduite.

Dix preloads3201octets/43appels littéraux relus dans découverte et suivi,origine épinglée par enregistrement. Les homonymes224/295 restent distincts. Ready→Queen→Spawn/Managers/Expiration et personnages ;preloads citent caitlyn_peacemaker_tar_02,ezreal_mysticshot_tar,skin02_ground/fade,Enrage. Char563 et Queen1112 conservent leurs contextes QWER/recall/autres. Textes/identités complets dans evidence_review.json. Déclarations distinctes de sélection,création,owner/attache/horloge et rendu.

Font4497/4321/3007/3008/12069/12070 :forme après mort,tir vers curseur après2s,@f1@dégâts bruts aux ennemis traversés,durée8s. Fire!/0mana/0seconde ne prouvent pas disponibilité/recharge. Deux Absolute_Zero_Slow absents de ce font exact,aucune réécriture. DDF44lignes,seul ZyraSeed;f1=17/16/15/14/13,distinct du passif. Font gardée par identité,sans reparcours sémantique.

Deux DDS ZyraP2872 chacun,64×64/DXT1/mip7,même SHA `0eb88fa1925807ac7b1d2a8c342b2c25276553a21213f12b6b76bddd23cef9a2`,relus dans E,membre111/core7 hérités. KogMaw non résolu sous sélection own/shared ;deux candidats étrangers manifest-only non ouverts/promus. Aucun montage/priorité/pixel qualifié.

## 3. Consommateurs réels

Seize fichiers actuels,quatorze Rust/deux Python,28ancres. Quatorze sources/frontières,34contextes,14entrées VFX communes,deux animations ordinaires concordants. command refuse le mort avant dispatch ;apply_damage/heal,lifecycle/respawn,placement et régénération présents. Aucun hook Zyra/PQueen/RiseoftheThorns dans les quatorze préfixes Rust examinés,conclusion bornée.

HP/Mana et compteur ordinaire acquis après garde. native_hud_respawn4926/SHA96798238 :mort/fin,respawn_at−tick saturé,arrondi supérieur ;connexion/session pour visibilité. Source actuelle relue,ancien calcul conservé,sans exécution Rust/Bevy. Ce chemin ne produit pas forme,prêt,tir ou f1 ;owner/projection/animations génériques non substitués.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus/reprise. Observé :dépendances et frontières reliées,producteur/rendu spécifiques non établis. **35/35 contrôles documentaires,62/62 de cohérence séparée du même agent.** HUD342/342 et310/310 hérités.

Quatre cas Zyra/Annie1/18 :huit paires PV fatales API100000True relues,huit réapparitions ordinaires480/1110ticks,huit arrivées et six XP diagnostiques hérités. Première mort près de l’ennemi,seconde au spawn ;seconde mort sans activation qualifiée ne valide pas la recharge.

88états relus aux offsets0/1/59/60/61/239/240/241/délai−1/délai/délai+1 :PV0 avant délai,puis PVmax,plantes absentes aux points conservés. 88PV ennemis retenus ;reconstruction f32 de régénération/plafond héritée,sans recalcul. Assertions par tick d’absence plante/projectile non toutes frames brutes ni capture visuelle. Forme visuelle non inspectée.

672refus publics morts et48vivants,16API morts et12True invalides :748flags,sans748paires individuelles. Stop après respawn est un flag hérité. Quatre paires PV API40True relues,sans mitigation ni avance du tick,distinctes du projectile natif.14076ticks=2904+4164+2874+4134,non toutes frames.

Six productions actuelles réussies,sans échec propre. RUN956897octets/1158entrées non rouverts ;binaire6085120/SHA `9da4d1eaa170dd56cac37fcce3b5de325435b7e0220cf79a46da81d5f038cf43` inerte. Aucun nouveau build,jeu,natif,REA,réseau ou GPU.

## 5. Écarts et inconnues

f1/niveaux,origines/bornes2s/8s,forme/entité,slots/curseur après mort,consommation unique,trajectoire/portée/vitesse/largeur/collisions/traversée,cibles/boucliers,disponibilité/recharge,lifecycle et réseau restent ouverts. **Le rendu Rise of the Thorns reste non qualifié.** Animations,particules,skins,audio et ressources physiques distincts des métadonnées. Aucune mécanique récente substituée,inventaire secondaire complet ou acceptation indépendante/humaine qualifiés.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/FORM/NETWORK/VFX,préconditions,fins/reprises ;six dépendances INPUT/PROJECTILE/TRUE-DAMAGE/LIFECYCLE/ICON/HUD conservées. Reprendre sur script/Troy/capture/callsite attribué ou consommateur modifié ;autorisation distincte pour implémenter.

Zyra est le dernier des122IDs du tableau figé,pas une preuve d’achèvement de la série. next_lot.json prévoit le rapprochement des122IDs avec les audits réellement publiés,périmètres/preuves/manques,sans doublecompte,puis sélection du prochain lien non audité. Réutiliser V1322 ;COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 et clauses secondaires restent ouverts. Aucun changement du goal.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_zyra_passive_vfx_20261106` :sources,préchargements à deux origines,homonymes,fenêtres,états/API,cohérence,corrections et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés. Journal Python des producteurs seulement ;contexte/dispatch/gardes/empaquetage exclus,sans garantie OS/TOCTOU.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
