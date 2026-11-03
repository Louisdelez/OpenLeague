# SYS-01.2-02 — Attaques et reset des monstres Map10, V497

Projet F:/OpenLeague. Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; catalogue4.20.1 distinct. Le build porte2014-11-17 à17:46:45, fuseau et déploiement non établis. Cette livraison concerne les liens sources/consommateurs et leurs preuves. Aucun monstre ni le jeu ne sont déclarés terminés.

## Résultat intégré

Les14fiches AI-ATTAQUE et AI-RESET des7types de monstres sont enrichies : TT_NGolem, TT_NGolem2, TT_NWolf, TT_NWolf2, TT_NWraith, TT_NWraith2 et TT_Spiderboss. Les42fiches antérieures de camps, sources, récompenses, ciblage et poursuite, ainsi que leurs questions, restent exactes.

97liens natifs et112liens consommateurs ajoutés ;11ancres documentaires décrivent les chemins déjà implémentés : portée, temps de trajet, récupération, capture du coup, libération du projectile, garde de source, application, armure, interruption, arrêt du retour à5unités et refus du stun de boss.3sources de preuves et14questions propres ouvertes. Aucun code du moteur ou asset modifié.

## Sources relues

91observations de champs de personnages sont relevées dans les sept INIBIN. Les comparaisons de dégâts/portée et les formules locales compatibles de cooldown/windup sont conservées séparément d’une qualification de l’horloge native.17INIBIN de sorts candidats sont lus, dont des variantes d’attaque et des auxiliaires de Vilemaw. Les17Lua de Vilemaw présents dans le dossier de sorts sont identifiés et parsés ; ils ne sont pas exécutés ni déclarés raccordés au dispatcher actuel.

Six scripts d’IA/régénération sont reparsés avec comparaison des instructions, constantes et empreintes : Leashed, Aggro, Idle, AIComponentSystem, AIComponentOutOfCombatRegen et NeutralMinionSpawn. Le montage effectif, les helpers et les variantes choisies par le moteur historique restent ouverts.

| Type | Cooldown local, ticks | Windup local, ticks | Vitesse projectile locale |
| --- | ---: | ---: | ---: |
| TT_NGolem |49|20|0|
| TT_NGolem2 |49|20|0|
| TT_NWolf |45|19|0|
| TT_NWolf2 |46|18|0|
| TT_NWraith |48|9|750|
| TT_NWraith2 |48|18|750|
| TT_Spiderboss |46|30|0|

Écarts de sélection explicites : TT_NWraith2BasicAttack porte750, ses variantes BasicAttack2/3 portent0. TT_SpiderbossAttack et Vortex portent1300 ; Attack2/3 portent environ347,79999 ; AttackDebuff n’a pas de champ MissileSpeed retrouvé dans cette lecture. Le chemin générique local de Vilemaw reste à0. Ces valeurs de ressources ne suffisent pas à décider quelle attaque est choisie, si son missile est activé ni comment elle est produite. Aucun remplacement automatique par une vitesse candidate n’est effectué.

## Exécution actuelle :97cas d’attaque

Une sonde Rust est compilée et exécutée contre la bibliothèque coreV476, après revalidation de ses entrées actuelles et outils. La bibliothèque core n’est pas recompilée. Le programme réussi se trouve dans revision497_runtime_checks_retry ; commandes, codes0, scripts, binaire, bibliothèque et ressources sont identifiés par taille/SHA-256.

Les sept définitions sont utilisées dans des instances clonées explicitement contrôlées : santé5000, dégâts de base locaux, cibles Unit sélectionnées, AI/home/camps supprimés pour isoler le chemin de frappe. La vraie navigation est chargée. Cela ne constitue ni une naissance ordinaire de monstre pour ces cas d’attaque, ni un combat complet, ni une comparaison de renderer.

13cas pour les cinq profils sans projectile local et16pour chacun des deux spectres avec projectile, total97. Les timelines vérifient :

- Deux impacts au windup puis à la récupération attendus.
- Portée+rayon cible48 incluse et refus d’engagement à+1.
- Cible déplacée ou nouvelle cible sélectionnée après préparation : le coup capturé garde sa cible et son délai.
- Dégâts de source modifiés après préparation : le montant capturé reste utilisé.
- Armure0/100 ou changement après préparation : l’armure courante est lue à l’impact.
- Stun, mort ou retrait administratif de source avant libération : suppression du coup observée, sous réserve du refus explicite de stun du boss.
- Cible morte ou retirée : aucun dommage observable supplémentaire ; cela ne prouve pas à lui seul toute la file interne.
- Spectres après libération : le projectile numérique survit au stun/mort si l’entrée source reste présente ; son retrait administratif empêche le coup observé.

Pour Vilemaw, le cas de stun ne contourne pas l’API : grant_stun retourne exactement « boss stun policy not qualified ». Aucun état de stun n’est ajouté ; le coup déjà prévu se produit normalement. Ce refus signifie que la politique reste non qualifiée, sans conclure à une immunité native.

## Exécution actuelle :21cas de reset

Les cas de retour utilisent des membres effectivement créés par le scheduler de camps, après saut à l’échéance initiale. Un joueur rejoint, inflige un dégât par API publique puis est retiré par remove_player. Les autres NPC sont gelés et les attaques désactivées. Le monstre est placé artificiellement au home ou sur un point praticable choisi près d’un décalage demandé300/900. Le point effectivement choisi, sa distance, le chemin et chaque tick sont conservés ; un décalage demandé ne signifie pas une distance exacte.

Trois cas par type, total21 :

- Sept cas commencent déjà au home et atteignent l’état terminal sans chemin.
- Douze parcours déplacés des six types mobiles reviennent dans le seuil local5avec chemin et destination vides.
- Deux cas de Vilemaw déplacé ne reviennent pas pendant les120ticks observés. Sa vitesse locale est0 ; sa position reste le point forcé, alors que la santé est restaurée et un chemin reste demandé.

La santé maximale, la suppression de cible et la conservation de next_attack sont vérifiées. Le retour n’efface donc pas automatiquement toute la récupération d’attaque dans le contrat observé. Le grand spectre, sur le parcours demandé900, s’arrête à3,264643unités du home : le seuil5est observé ; une arrivée exactement au centre n’est pas revendiquée.

Les points forcés de Vilemaw sont à environ273,86 et592,05unités de son home après sélection praticable. Ce scénario artificiel ne prouve ni qu’un tel déplacement est autorisé dans une partie native ni une règle historique de téléportation/immunité. Les deux non-retours restent des limites ouvertes.

## Contrôles et limites

1352identités de fichiers directement revérifiées.42214instructions comparées :14modifiées,42200inchangées. Les42fiches et questions héritées restent exactes, ainsi que les dépendances et critères de fin.15sélecteurs nominaux,16sélecteurs invalides refusés ;22refus du collecteur (18Lua altérés,2INIBIN altérés,2sélections de profil) et3refus du lecteur public (mauvais propriétaire, faux statut résolu, condition de résolution absente).

La publication et l’audit indépendant lisent les deux bases avec le vrai Store.task/copy_text. Les cases/notes des42606lignes et23historiques sont conservés. Aucun test GPU, audio, réseau, serveur historique ou validation humaine exécuté.

Restent explicitement ouverts : choix effectif des variantes et sorts spéciaux, formules/horloges natives, modifiers, contrôles et annulations complets, montage de scripts, politique du boss déplacé, terrain complet, retour après combat ordinaire, reset de tous les effets/timers/orientations et critères de partie réelle. Les preuves privées et le buildV476 sont des dépendances locales, dont la portabilité n’est pas démontrée. Aucun asset manquant n’est déduit de ces absences de qualification.

## Essai initial conservé

La première sonde a été compilée mais son exécution s’est arrêtée sur une attente incorrecte de succès du stun de boss. Le journal et code non nul sont conservés dans revision497_runtime_checks, avec script, source et binaire originaux. Ce passage n’est pas compté comme97cas réussis.

La reprise utilise un nouveau dossier revision497_runtime_checks_retry et des scripts distincts. Elle vérifie le refus, l’absence de mutation du stun et la poursuite de l’attaque. Le moteur n’a pas été modifié et les observations initiales n’ont pas été réécrites. Tous les97cas et21trajectoires du passage corrigé réussissent selon leurs assertions bornées, avec les deux non-retours du boss explicitement attendus et ouverts.

Une lecture exploratoire du chemin navigation.rs a été impossible : Navigation est défini dans lib.rs. Le vrai fichier et le chemin public Navigation.path ont ensuite été inspectés. Aucun effet sur le projet.

## Livrables

- docs/reference_monster_behavior_sources/monster-attack-reset-v497.json :associations, champs natifs, variantes,97cas,21trajectoires, identités, refus et limites.
- docs/fidelity_monster_attack_reset_v497.json :preuve de publication et des bases.
- docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json :registre enrichi, historique conservé.
- docs/coverage.json, completion_plan.json, resume_checkpoint.json et docs/ai/CURRENT.md, HANDOFF.md :couverture et reprise.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision497_runtime_checks et revision497_runtime_checks_retry :échec initial et exécution corrigée distincts.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision497 :baselines, préparation, contrôles candidats, audit, sauvegardes et point de reprise.

Aucun code ou asset du jeu modifié, aucune case cochée. Le goal SYS-01.2-02 reste actif. Suite :les7agrégats AI de monstres, en conservant les cinq facettes et toutes leurs limites plutôt qu’en les convertissant en acceptation de comportement complet.

Bilan final vérifié :97liens natifs,112liens consommateurs,11ancres,3sources,14questions ouvertes,0résolution. Graphe :98677sources/2554consommateurs/25774inconnues ouvertes/5517résolues avec historique. Deux bases :15lignes documentaires actualisées,42591autres lignes exactes,42606états/notes et23historiques conservés,intégritéok. Sous-inventaire77à reprendre,431partielles,32exclusions ouvertes ;aucun pourcentage de jeu terminé. Publication et audit réussis.
