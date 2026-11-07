# Lux — liaison d’Illumination et des effets visuels

## 1. Exigence et portée

2026-11-05,V1371 ; `AUD-SYS-01.2-02-LUX-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Lux-PASSIF-PRESENTATION-VFX` ; `OLF-bcbb3f08-d34e-56e4-bc62-498a69579990`. Liaison des déclarations applicables aux consommateurs actuels,avec écarts et corrections. Seul cet audit borné est terminé ; tâche VFX complète ouverte.

Implémentation : marque,consommation et interaction R non établies dans les corps examinés,acquis génériques conservés. Vérification : documentaire statique réussie,runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot,contrats et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/lux-passive-illumination-links-v597.json`,copie E immuable :1205536 octets,SHA-256 `1f21dc5a6d6e407b2d61fa4ee811fa31df708ed016f834d622ce940a901acc72`.37 identités/rôles ; référence LoL4.20.0.315/EUW/en_GB,catalogue4.20.1 distinct. Chemins D inertes. Audit HUD source107/107 et consommateurs43/43 hérités.

14 Lua structurels,zéro prototype enfant,deux initialisations littérales/six affectations. CharScript56 vide ; Passive299 déclare DoesntBreakShields=false,DoesntTriggerSpellCasts=true,icône,nom,persistence et NonDispellable. Ces flags du propriétaire ne définissent pas la marque cible. Douze limites NEWTABLE : Basic/Basic2/Crit et BindingDummy pc0 ; cible Fraulein pc8,Binding14,Mis10,Kugel6,Toggle2,R/RMis6,PrismaticWave2. Frontières du lecteur,non corruption ou callback exécuté. Aucun AutoBuff qualifié,non absence globale d’effets.

BuffData2239/2240/2241/2242 distingue détonation E,marque cible,passif propriétaire et immobilisation Q. Texte : sorts dommageables marquent6s,attaque de Lux inflige @f1@(+@f2@) magique et consomme ; description4227 lie le bonus au niveau,nom4403 conservé. TexteR11700/9606 dit déclencher et renouveler Illumination,sans démontrer l’ordre serveur. Quatre clés SpellData exactes sans correspondance ne nient pas les quatre textes BuffData résolus.

@f1@/@f2@ et formules ouverts,six rangs absents,coefficients0 des deux fichiers passifs non dégâts0. Rmain conserve Coefficient0.75/CD80/coût100/range25000,RMis0.7000000000000001/CD60/coût0/range3500 ; pas de fusion ou choix implicite. Quatorze métadonnées/26bindings,cinq candidats absents bornés,20 références communautaires secondaires. Aucun DDF trouvé dans le chemin inspecté,aucune ligne inventée ;26 fichiers NightmareBot exclus du baseline,non substitués.

Sept preloads2284 octets/30noms : luxpassive_tar.troy,liaisons Q/E et marque cible,R beam/ball/deathfix/expirationtimer,testcuberender,SteelLegion et boucliers W. Rmis référence la particule cible et luxilluminatingfraulein ; ces liens ne donnent pas recette ou ordre d’événements. Captures E756777/946546/548018 vérifiées. Une DDS2872 octets,64×64/DXT1/mips7,membre25 ; contexte QWER/modèle/particules/NightmareBot non ouvert,non absence globale. Caveat ressource hérité : SHA15a64… communautaire malgré chemin natif,distinct du natif5239… ; aucune adoption ou correction JSON nouvelle.

## 3. Consommateurs réels

Treize Rust complets,34 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `shop.rs:261` ; `shop.rs:215` ; `world.rs:226` ; `damage.rs:38` ; `attacks.rs:26` ; `critical.rs:12` ; `death_recap.rs:184` ; `death_recap.rs:200` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `attacks.rs:167` ; `attacks.rs:218` ; `attacks.rs:257` ; `lifesteal.rs:17` ; `lifesteal.rs:20` ; `critical.rs:15` ; `death_recap.rs:202` ; `damage.rs:92` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/` et projected_live dans `crates/client/src/`. Sorts/rangs Lux refusés. advance_attacks lance le projectile ordinaire,puis basic_attack_hit applique le physique et les mécanismes de vol de vie/rétorsion disponibles. Mitigation,profil critique et attribution au récapitulatif existent,sans producteur d’Illumination établi. Ces acquis ne constituent pas un bonus magique ou une consommation de marque.

Recherche nominative complète sur13 fichiers,sans hit Lux/Illumination/luxpassive/luxilluminat : portée bornée,non absence globale. projected_live sélectionne Annie ;14 mécanismes communs et deux chemins d’animation ordinaires réutilisés,non recette/attache Lux. Le catalogue relique reste un sous-ensemble Troy.

25 comparaisons sélectionnées,114 contextuelles fraîches et une identité EXE héritée inerte parmi115 ; recouvrement,non140 consommateurs.14 identités communes et deux animations concordantes. Aucun gros registre JSON redécodé ou analyse REA répétée.

## 4. Attendu et observé

Attendu : conserver provenance,déclarations,acquis/refus et limites,puis relier les écarts aux corrections. Observé :126/126 contrôles documentaires,110/110 de cohérence séparée du même agent ; relecture de témoins E conservés,non décodeur indépendant ou acceptation humaine.

V597 hérité : base/Tome1052,AP0/20,AD53.54399871826172 inchangé,six impacts/six identités de projectile ordinaires,54refus/360ticksidle,mana334 plafonnée. Tous sorts refusés,aucune marque appliquée,consommation ou interactionR qualifiée. La conclusion Lulu sur le déclencheur ordinaire n’est pas transférée : une attaque sans marque ne peut démontrer son déclenchement. Attente180 après Stop sans origine d’application non expiration6s.

Sept snapshots complets/cas ; gardes combat/idle distincts du trajet,observations NPC bornées. Refus sans paires brutes,PVidle/entre impacts absents : assertions héritées,non recomputation indépendante. Tableaux HUD conservés exactement,sans nouveau calcul. Binaire6039552 octets,SHA94d0ce38… hérité et inerte,ancien dossier revision536_yasuo simple libellé. OBSpassed d’inspection non reçu terminal,code brut null ; BUILD/RUN0 hérités de commandes brutes. Six opérations documentaires exit0,aucun nouveau build,jeu,natifD,GPU,REA,probe ou capture.

## 5. Écarts et inconnues

Application/instant initial,refresh/expiration,formule/niveau/AP,consommation propre à Lux,interactionR,ordre/attribution et protections restent à qualifier. Passif propriétaire et marque cible distincts ; imports/icône/preloads ne prouvent pas recette,lookup,pose/os/attache,animation,rendu/audio ou cycle de vie. Inconnues et consommateurs enregistrés conservés ; binaires et stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : owner-target-mark-source-formula-and-resource-contract ; mark-consumption-R-ignite-refresh-and-damage-attribution ; target-mark-ignite-refresh-presentation-and-lifecycle. Chaque clause précise objectif,prérequis,critères et reprise ; aucune correction produit implicite.

Prochain lot CH-Malphite-PASSIF-PRESENTATION-VFX,sources exactes dans next_lot.json. Reprise sur source,mapping,appel,événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_lux_passive_vfx_20261105/`,evidence_review.json,coherence_review.json,corrections_and_restart.json,opérations/journaux,result.json et reçus de publication. Publication et sept rubriques contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2358 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives. Goal,Plan/UI/bases,registres,produit et assets inchangés. Parent,jeu,fonctionnalité et acceptation ouverts.
