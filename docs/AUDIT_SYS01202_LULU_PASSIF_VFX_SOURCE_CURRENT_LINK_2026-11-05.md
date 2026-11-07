# Lulu — liaison de Pix et des effets visuels

## 1. Exigence et portée

2026-11-05,V1370 ; `AUD-SYS-01.2-02-LULU-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Lulu-PASSIF-PRESENTATION-VFX` ; `OLF-94819f69-9168-5201-8850-c554de28975b`. Liaison des déclarations applicables aux consommateurs actuels,avec écarts et corrections. Seul cet audit borné est terminé ; tâche VFX complète ouverte.

Implémentation : Pix,salve et transfert non établis dans les corps examinés,acquis génériques conservés. Vérification : documentaire statique réussie,runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot,contrats et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/lulu-passive-pix-links-v596.json`,copie E immuable :1443220 octets,SHA-256 `deee809f5a20da12cab7ff2221f07b207a2aa584e0f091ef6bb284a8e0e39c20`.60 identités/rôles ; LoL4.20/EUW/en_GB,catalogue4.20.1 distinct. Chemins D inertes. Audit HUD source101/101 et consommateurs42/42 hérités.

29 Lua structurels,zéro prototype enfant,25 initialisations littérales/102 affectations,dont deux CharScripts56 vides. Burn205/Shield459/QMissile412/QMissileTwo412 limités par NEWTABLEpc4/16/12/12,non corruption. Passive/Spawn/Backup/Off/Run157 ont même nom/persistence/NonDispellable,aucun BuffTextureName ; identité de métadonnées non cycle exécuté.

16 champs AutoBuff :12 vides et4 non vides. EVision350 déclare global_Watched.troy,os C_BUFFBONE_GLB_HEAD_LOC et Lulu_E_tar_pix_vision.troy ; R310 déclare lulu_R_tar_buf.troy. Ce sont des contextes E/R,non recette complète Pix. AttackAid/Linger491 ont priorité3 et ordre d’expiration,IsDamagingSpell=false et icône Orianna ; Burn/ShieldController243 conservent Sunfire,OverrideTemp254 Nautilus/Malady,Root355 RunePrison/Ryze/Snared. Missile376 et Controller391 conservent LuluShred/FallenAngel,flags de dégâts et récapitulatif distincts ; noms/flags non effets exécutés.

Tooltips2230/2231 : porteur révélé ou protégé,Pix aide le porteur au lieu de Lulu ;2232 : trois tirs magiques guidés,bloqués par d’autres unités,total @f1@(+@f2@). R2234 distinct,description4226/nom4402. @f1@/@f2@ ouverts,six rangs absents. Quatre DDF Q dont spelldamage0.133,Missile/ControllerCoefficient1.2000000000000002 et petBaseDamage24 ne donnent pas la formule du passif. Pet conserve description Caitlyn,AttackRange/SelectionHeight chaînes0. Quatorze métadonnées et22 bindings conservent les références Lux/Ezreal/Ashe,non réécrites ; six candidats absents bornés,21 références communautaires secondaires.

13 preloads3625 octets/49 noms : lulufaerie est un personnage,root un sort ; spawn/backup,buddy/robot,variantes allié/ennemi,blink,E shield/vision,Q et lulubasicattack_tar.troy ne constituent pas une recette. Captures E877199/1071804/552660 vérifiées. Une DDS5616 octets,64×64/DXT5/mips7,membre80 ; textures contextuelles héritées non ouvertes,non absence globale. Caveat de ressource hérité : SHA2c2e… communautaire malgré chemin natif,distinct du natif a266… ; aucune adoption ou correction JSON nouvelle.

## 3. Consommateurs réels

Quatorze Rust complets,39 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `shop.rs:261` ; `shop.rs:215` ; `world.rs:226` ; `damage.rs:38` ; `attacks.rs:26` ; `critical.rs:12` ; `death_recap.rs:184` ; `death_recap.rs:200` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `attacks.rs:167` ; `attacks.rs:218` ; `attacks.rs:257` ; `lifesteal.rs:17` ; `lifesteal.rs:20` ; `critical.rs:15` ; `death_recap.rs:202` ; `damage.rs:92` ; `projected_live.rs:168` ; `annie_w.rs:47` ; `annie_r.rs:20` ; `annie_r.rs:23` ; `annie_r.rs:69` ; `annie_r.rs:71`.

Racines `F:/OpenLeague/crates/core/src/` et projected_live dans `crates/client/src/`. Sorts/rangs Lulu refusés ; attaques,projectiles,mitigation physique,vol de vie,crit et récapitulatif ordinaires acquis. Aucun de ces chemins ne produit une salve Pix établie.

combat_owner et tibbers recherchent le propriétaire ou un familier vivant ; ce lookup générique ne suffit pas. La branche de cast_at vers cast_tibbers exige Annie/slot3 ; advance_annie_r crée annietibbers avec Pet(owner,durée,ordre Follow),non Pix. projected_live sélectionne Annie. Recherche nominative complète sur14 fichiers,sans hit Lulu/Pix/lulufaerie/lulupassive : portée bornée,non absence globale du modèle ou des assets.

25 comparaisons sélectionnées,107 contextuelles fraîches et une identité EXE héritée inerte parmi108 ; recouvrement,non133 consommateurs.14 identités communes et deux chemins d’animation ordinaires concordants ; sous-ensemble Troy et rôle Basic/Critical non salve/attache/recette Pix. Aucun gros registre JSON redécodé ou analyse REA répétée.

## 4. Attendu et observé

Attendu : provenance et déclarations conservées,consommateurs/acquis/refus identifiés,écarts reliés aux corrections. Observé :150/150 contrôles documentaires,120/120 de cohérence séparée du même agent ; relecture de témoins E conservés,non décodeur indépendant ou acceptation humaine.

V596 hérité : base/Tome1052,AP0/20,AD46.36800003051758 inchangé,six impacts et six identités de projectile ordinaires,54 refus/360ticksidle,mana292.3999938964844 plafonnée. L’attaque pertinente pour le déclencheur textuel est observée ; aucune salve Pix ou attribution magique supplémentaire qualifiée,E refusé donc transfert non exercé. Attente180 après Stop non durée native du passif. Sept snapshots complets/cas ; gardes combat/idle distincts du trajet,observations NPC bornées. Refus sans paires brutes,PVidle/entre impacts absents : assertions héritées,non recomputation indépendante. Tableaux HUD conservés exactement,sans nouveau calcul.

Binaire6039040 octets,SHA27280e4f… hérité et inerte,ancien dossier revision536_yasuo simple libellé. OBS d’inspection passed ne donne pas un reçu terminal : code brut null ; BUILD/RUN0 hérités de commandes brutes. Six opérations documentaires exit0,aucun nouveau build,jeu,natifD,GPU,REA,probe ou capture.

## 5. Écarts et inconnues

Création/porteur/transfert/retour de Pix,déclenchement,salve,timing,interception,classes de cibles,formule/niveau/AP et attribution restent à qualifier. Import ou icône non modèle animé/recette/rendu. Pose/os/attache,visibilité,variantes,rendu/audio et cycle de vie ouverts. Inconnues et consommateurs enregistrés conservés ; binaires et stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : companion-creation-carrier-and-source-contract ; three-bolts-interception-damage-and-attribution ; companion-bolts-and-carrier-effects-presentation-lifecycle. Chaque clause précise objectif,prérequis,critères et reprise ; correction produit soumise à autorisation distincte.

Prochain lot CH-Lux-PASSIF-PRESENTATION-VFX,sources exactes dans next_lot.json. Reprise sur source,mapping,appel,événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_lulu_passive_vfx_20261105/`,evidence_review.json,coherence_review.json,corrections_and_restart.json,opérations/journaux,result.json et reçus de publication. Publication et sept rubriques contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2357 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives. Goal,Plan/UI/bases,registres,produit et assets inchangés. Parent,jeu,fonctionnalité et acceptation ouverts.
