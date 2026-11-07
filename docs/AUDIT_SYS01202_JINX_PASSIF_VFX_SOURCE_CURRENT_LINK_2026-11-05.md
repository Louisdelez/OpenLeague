# Jinx — liaison bornée de Get Excited et des effets visuels

## 1. Exigence et portée

2026-11-05, V1355 ; `AUD-SYS-01.2-02-JINX-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; SYS-01.2-02 ; `CH-Jinx-PASSIF-PRESENTATION-VFX` ; `OLF-f759581a-33f2-5ef5-a2e1-455cc0956acd`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; tâche complète, inventaire, fonctionnalité et acceptation ouverts.

Implémentation : producteur Get Excited, état de vitesse et activation visuelle non établis dans les corps inspectés. Vérification documentaire réussie ; essais historiques hérités sans nouvelle exécution du jeu. Acceptation humaine non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/jinx-passive-get_excited-links-v582.json`, copie E externe921588octets, SHA256 `2a884ae7135cf251c8903f57fc649e41e7f1e33b6747f52e5deba91cb4c82d16`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Quinze ressources/rôles,45 associations historiques sur trois tâches. Aucun accès D, chemins natifs inertes.

Six Lua structurels sans enfants, six initialisations/11 affectations, aucune limite du lecteur littéral. CharScript56 vide ; Kill214 déclare Jinx_Passive et AutoBuff=Jinx_Passive_Buff.troy,sans champ bone/persistence. Marker192 déclare Bowmaster_Bullseye,persistence=true ; moniteur179 déclare JinxCatchMe/Jinx_Hidden. KillMarker et RunCycleManager90 déclarent seulement persistence. Ces champs ne prouvent pas le cycle effectif.

Quatre preloads1881octets/26 références comparés aux captures E447693/627466octets. La particule jinx_passive_buff_onkill.troy préchargée reste distincte de l’AutoBuff ;root est BBPreloadSpell,non preuve d’immobilisation. Références sociales,Caitlyn/Vi,capacités,sons/skins etQ/minigun restent contextuelles. DDF72 dont16lignes Vi,sans entrée JinxPassive,ne prouve pas une absence globale de formule. Huit références communautaires secondaires.

Buffs2114/2115 liés exactement : contribution sur champion,tour ou inhibiteur dans les3secondes avant mort/destruction ;175%vitesse décroissant sur4secondes. Courbe et attribution serveur ouvertes. Description4207 recherchée par clé explicite ;PassLev1Desc1 et six rangs absents,sans liaison ou valeur inventée. Quatre lignes en_GB héritées.

Trois DDS distincts64×64,mipbrut0 : Hidden2176/DXT1 etPassive2176/DXT1,membres181 ;Bowmaster_BullsEye4224/DXT5,membre25. SHA respectifs `1c5bcc4cf8c5d35ce6455b21b5f6c63f8cce75ac6fa2a6a230c0d9a7f4d464d8`, `afdcaff341e95dde675be4636a004a0e71db8fe64b932b469cddd0e3e9c072f7`, `d9a843e53ce1ad00fd295ab8554afd53e87feec91919b0d25185ae5b8f06c9eb`. Casse déclarée Bullseye/fichier BullsEye conservée sans alias automatique. Homonymes Zyra contextuels non lus ;lookup,variante,pixels ouverts,aucun asset3D manquant déduit.

## 3. Consommateurs réels

Vingt Rust et un JSON local complets,43 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:46` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `movement.rs:53` ; `movement.rs:38` ; `movement.rs:19` ; `shop.rs:215` ; `shop.rs:261` ; `ally_occupancy.rs:635` ; `lib.rs:744` ; `lifecycle.rs:33` ; `attacks.rs:157` ; `damage.rs:53` ; `champion_kills.rs:26` ; `champion_kills.rs:32` ; `champion_kills.rs:13` ; `world.rs:355` ; `passive_gold.rs:16` ; `movement.rs:39` ; `movement.rs:44` ; `movement.rs:46` ; `movement.rs:55` ; `movement.rs:60` ; `interactions.rs:48` ; `trundle_w.rs:78` ; `trundle_w.rs:88` ; `trundle_e.rs:75` ; `slows.rs:9` ; `summoner_heal.rs:21` ; `lifesteal.rs:4` ; `champion_kills.rs:29` ; `champion_kills.rs:34` ; `champion_kills.rs:44` ; `damage.rs:136` ; `world.rs:410` ; `projected_live.rs:168` ; `lifecycle.rs:83`.

Racines `F:/OpenLeague/crates/core/src/`,sauf projected_live dans client/src et règle dans data/4.20. Les chaînes attaques/projectiles,dégâts,mort,contributions/récompenses,structures,XP,or ambiant,réapparition et vitesse sont réelles. Contribution avant retrait PV puis récompense de mort ne produit pas Get Excited dans les corps inspectés. Destruction de structure inspectée statiquement seulement.

champion_kill_rules.json2457octets/SHA `a0f7876db8e7f565dc23f2ff5606b72dc6d5d4ef423be8909625ae639fb8969c` fixe15s d’assistance,300or et100premier sang ;ses limites déclarent l’algorithme serveur non récupéré. Record/reward consomment cette fenêtre,distincte du critère Jinx3s. Vitesse base/objets,GarenQ,Soin,relique,Trundle,ralentissements/plafonds et projection Annie restent distincts.

Recherche Jinx/GetExcited sur21textes : zéro hit,sans absence globale déduite.32 comparaisons sélectionnées et96 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés,sans rendu passif qualifié.

## 4. Attendu, observé et contrôles

Attendu : distinguer contribution3s,assistances15s,récompenses,décroissance et rendu. Observé :101/101 contrôles documentaires,112/112 de cohérence séparée du même agent. V1227 source65/65,consommateurs62/62,intégration40/40 hérités,non rejoués. Pas de décodeur indépendant.

V582 hérité :deux cas publics Jinx/Annie base/bottes1001 ;48impacts avec témoins de projectiles,quatre kills,34refus sans mutation,720ticks après kills,20pas. Vitesses325/350 inchangées ;récompenses400 puis300 par cas,or ambiant séparé. XP/niveaux ordinaires non supposés constants. Respawn naturel d’Annie entre kills,non cycle du buff Jinx.

Chaque fenêtre post-kill180ticks/six secondes comporte cinq pas puis175ticks après Stop,résidu<0.005. Sans buff créé,elles ne qualifient pas la courbe/expiration4s. Assistance,tours et inhibiteurs non exercés. Troisième capture E2261324octets confirme le résumé, sans replay.

Binaire6056960octets/SHA `73641609917d7aab84f0acc1650d89a0a7d4e54e30c8dbc933c70f3f1e1b1ea1`,BUILD/RUN0 historiques,jamais rouvert. Anciennes corrections de remplacement config/branche morte conservées. Stockage :anciens PREPARE/récupérations/nettoyage conservés comme données de reçus,aucune base,sauvegarde ou cache rouvert/copîé/nettoyé. Six opérations documentaires journalisées réussies ;aucun nouveau build,jeu,natif,GPU,REA,probe ou réseau. V564 ouvert.

## 5. Écarts et inconnues

Frontières3s,attribution/invocations/assistance,catégories,courbe175%/4s,basis,ordre/plafonds/arrondis,répétition/refresh et lifecycle ouverts. Applicabilité,lookup/casse,activation,recette,pose,attache,pixels et audiences restent à qualifier. Récompense,niveau,persistence ou preload ne remplacent pas un événement passif autoritaire. Aucun inventaire complet,tâche VFX,inconnue ou acceptation fermé.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json :get-excited-effect-resource-applicability,death-contribution-decay-authoritative-state,passive-resource-attachment-render-lifecycle. Chacune possède objectif,prérequis,critères et reprise. Préserver175%/4s/3s ;qualifier courbe et attribution avant correction du jeu. Ne pas réutiliser la fenêtre15s ou les récompenses comme règle Jinx.

Prochain lot CH-Kalista-PASSIF-PRESENTATION-VFX ;sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs,sans recensement global ni replay inchangé.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_jinx_passive_vfx_20261105/` :evidence_review,coherence_review,corrections_and_restart,operations/journals,reçus. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée close ;tâche complète,feature,inconnues et goal ouverts. Publication :rapport et ajouts CURRENT/HANDOFF avec archives exactes ;goal/Plan/UI/bases/registres/code/assets inchangés.
