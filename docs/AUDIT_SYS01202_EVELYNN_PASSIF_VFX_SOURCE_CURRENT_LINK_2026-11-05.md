# Evelynn — sources et consommateurs des VFX de Shadow Walk

2026-11-05 · V1339 · AUD-SYS-01.2-02-EVELYNN-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Evelynn-PASSIF-PRESENTATION-VFX, OLF-7bb2924b-7909-5fed-8369-44c8c3037df1. Relier déclarations et consommateurs courants ; distinguer furtivité/détection, état propriétaire, projection adverse, mana, ancien sort, HUD et effets. Contrat : lancement/trajet/impact applicables ; dépendance CH-Evelynn-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin : identité/portée des sources, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos. Mécanismes génériques conservés ; machine de furtivité/rendu spécifique non établis dans les corps inspectés. Vérification statique, acceptation humaine non donnée ; inventaire VFX complet exclu.

## 2. Sources, déclarations et limites

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Reçu V1322 evelynn-passive-shadow-walk-links-v567.json :748345octets, SHAc060a6870a7f4705c35521352c54eca24920f2304b19c146c9c7f6f1fd729545. Source externe retenue vérifiée avant interprétation ; cadrage66402octets sans incorporation du document complet, hook inchangé, gain temporel non mesuré.

/native_metadata/client_lua : dix vues entièrement lues structurellement/littéralement,39affectations, sans prototype enfant ni serveur exécuté. CharScript56octets vide dans Characters/Evelynn/Scripts ; neuf Lua de sorts dans DATA/Spells. Répertoire Characters/Evelynn/Spells absent ne signifie pas ressource manquante.

Passive217octets déclare nom/icône/PersistsThroughDeath/Nondispellable ; casse littérale conservée, sans interprétation du moteur ou persistance exécutée. ShadowWalkRestealthFadeout461octets déclare global_Watched.troy/C_BUFFBONE_GLB_HEAD_LOC aux PC15/17. Ce candidat d’état révélé n’établit pas son applicabilité au passif, son activation, la pose ou le rendu.

Ancien ShadowWalk390octets : slot2/CastTime0.5, alors que Spell2=EvelynnW. Références brutes AnnieBasicAttack_mis.troy/R_hand conservées, sans transfert de règle ou corruption déduite. Passive1/description et six niveaux explicitement nuls restent nuls, sans defaults. BaseMPRegen absent reste distinct de BaseStaticMPRegen1.6216000318527222.

Découverte exacte V1212 capturée E :403451octets, SHAfd2a780804c2a270f3a30b412b24973d841ea2771987302b7bcb73acd14283c2 ; original F/OpenLeague-work inerte. Dix preloads1588octets/19références vérifiés contre cette copie : mana, anneau vert, entrée/sortie invis et avertissement. Noms evelyn/evelynn conservés sans correction d’alias ; aucune invocation/recette/audience ou activation prouvée.

Cinq DDS V1212/17064octets : ShadowWalk Info et Spells ont le même SHAa380518bb0c7c31463e3062b1d5fbf1d059b6fbce99031f9b726ed52d2faa64e ; Gray, OutOfStealth et ReadyToBetray restent distincts. Tous64×64 ; DXT1/2872/mipbrut7 pour ShadowWalk/Gray ; DXT5/4224/mipbrut1 ou0 pour OutOfStealth/ReadyToBetray. Identités/header/membership et SHA détaillés hérités ; mip0 non promu en corruption, lookup/pixels/rendu ouverts. Membres core0.0.0.111/0.0.0.107/0.0.0.25 du projet0.0.1.7.

Six textes en_GB1879/1882/2610/2611/4183/4359 : proximité/vraie vision,1%du mana maximum par seconde furtive, rupture6s après cast/dégâts reçus/infligés. Ancien trueSight-only séparé ; SourceName/markup bruts conservés. Aucune règle récente DemonShade ou mana manquant importée. Dix références communautaires : OnTakeDamage enregistré, SelfWasDamaged vide, pas machine serveur native.

## 3. Consommateurs actuels conservés

Huit Rust relus : crates/core/src/vision.rs, regeneration.rs, interactions.rs, spells.rs, lib.rs ; crates/server/src/main.rs ; crates/client/src/fow_champion_sources.rs, projected_live.rs. Vingt ancres exactes. Dix-neuf entrées antérieures concordent : onze frontières,deux lecteurs SOURCE,six auxiliaires ; quatorze identités communes VFX inchangées.

visible_to/visible_point_to utilisent équipe, Ignite, LOS/rayons/buissons génériques ; interactions=None retourne avant garde équipe, donc refus V567 limités au contexte Map10 actif. Rayon de perception générique ne fournit pas le seuil de détection ShadowWalk. snapshot_for filtre joueurs/unités/événements ; la voie main inspectée appelle ce filtrage puis state_datagrams/send_to, sans transport exécuté.

Le client fow_champion_sources synchronise les sources alliées vivantes et leurs rayons, puis traite les cercles de vision. Ce consommateur réel ne démontre pas dissimulation spécifique ou pixels. regeneration_rates/advance_regeneration composent base/croissance/objets et plafonnent le mana ; impulsions de fontaine séparées. Aucun état furtif ni bonus conditionnel identifié dans ces corps.

Animation ordinaire V1336 réutilisée via preuves précédentes et deux gardes exactes, sans relecture sémantique ; projected_live filtre Annie. Recherche Evelynn/ShadowWalk nulle dans les huit textes complets, sans absence globale. Contexte HUD/audiences antérieur conservé, sans nouvelle qualification UI/réseau.

## 4. Attendu, observé et contrôles

Attendu statique : qualifier déclarations/frontières et préserver les voies existantes en bornant le manque spécifique. Observé :96/96 contrôles documentaires,76/76 cohérences séparées du même agent,20ancres et gardes19/14/2 concordantes. Gardes/refus lus seulement. V1212 source70/consommateur43/intégration34 hérités, non rejoués.

V567 :250/environ899.9995unités,360ticks/12s visibles et projetés côté adverse chacun,24refus atomiques. Ces distances ne sont pas des rayons natifs ; projection exécutée historiquement n’est ni réseau ni rendu acceptés.

Achat1027 après210ticks conserve265.600006mana et porte maximum465.600006. Vingt incréments211–230 entre impulsions de fontaine égalent la base1.62160003/s ;1%du maximum vaut4.65600014/s. Aucun état furtif établi : addition/remplacement/cadence restent inconnus. Anciennes corrections V566→V567 et dateUTC25octobre conservées, sans rejeu.

Une requête d’affichage de contexte a échoué sur selected_six_strings ; root_context_failure.json la conserve, reprise sur selected_strings réel. Une reprise a interrogé trois notes au mauvais chemin docs/ ; root_resume_context_failure.json conserve les erreurs et la lecture corrigée dans docs/ai/. Aucune preuve remplacée. Six opérations documentaires journalisées réussies ; une préparation documentaire échouée sur la casse Fiddlesticks/FiddleSticks reste archivée, sans relance d’analyse. Le sélecteur utilise désormais l’identité canonique du registre ; aucun nouveau replay, build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou pixels.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, proximité/vraie vision, entrée/rupture/redémarrage6s, régénération conditionnelle/composition, rang/SourceName, owner/skin/audiences, mort/réapparition/reconnexion, pose/attache, montage et cycle rendu ouverts. FOW/Ignite/projection/fontaine/mana et anciens sorts ne clôturent pas ces clauses ; mouvement V564 et chaîne antérieure distincts.

Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement. V1322 immuable ; zéro tâche complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; pas de garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Evelynn-PASSIF-PRESENTATION-VFX : shadowwalk-visual-applicability-source, stealth-detection-audience-world-link et bone-concealment-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/animation/mouvement gardent leurs critères distincts.

Reprise sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-FiddleSticks-PASSIF-PRESENTATION-VFX : reçu V568 retenu ; aura Dread, résistance magique et effets à distinguer.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_evelynn_passive_vfx_20261105 : cadrage, inspections, gardes, evidence_review, coherence_review, requête de contexte échouée et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
