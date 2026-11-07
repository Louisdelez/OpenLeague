# Lucian — liaison de Pistolero et des effets visuels

## 1. Exigence et portée

2026-11-05,V1369 ; `AUD-SYS-01.2-02-LUCIAN-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Lucian-PASSIF-PRESENTATION-VFX` ; `OLF-3db900e4-2eaf-50d2-8e25-fd91b73b527b`. Liaison entre déclarations applicables et consommateurs actuels,avec écarts et corrections. Seul cet audit borné est terminé ; tâche VFX complète ouverte.

Implémentation : double tir non établi dans les corps examinés,acquis génériques conservés. Vérification : statique documentaire réussie,runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot,contrats et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/lucian-passive-lightslinger-links-v595.json`,copie E immuable :1155725 octets,SHA-256 `80bbe5244aff041208f64f89373332f4878c70a079fc3e196c3e46fb8106bad2`.35 identités/rôles ; LoL4.20/EUW/en_GB,catalogue4.20.1 distinct. Chemins D inertes. Audit HUD source102/102 et consommateurs41/41 hérités.

Treize Lua structurels,zéro prototype enfant,quatre initialisations littérales et11 affectations. CharScript56 vide ; Passive200 déclare 25.dds,nom,persistence et NonDispellable ; Buff215 déclare Lucian_Passive.dds,nom,IsDamagingSpell=false et IsDeathRecapSource=true ; E178 conserve Draven_Bloodrage.dds. Ces flags ne prouvent ni cycle de vie ni absence de dégâts. Neuf limites NEWTABLE,aux pc8/8/0/4/8/10/0/0/0 pour PassiveAttack/Shot/Dummy/Q/W/R/Basic/Basic2/Crit : frontières du lecteur,non corruption. Aucun AutoBuff qualifié,non absence globale d’effets.

Tooltip2223 : après fin du sort,prochaine attaque sous6s double ; second tir @f1@ contre champions/structures,on-hit et dégâts complets contre sbires/monstres. Buff2224 distingue l’état armé ; Q2225 répète le passif,non formule Q ; clé E exacte absente malgré fichier présent ; R2226 distinct. Description4225 et nom4401 conservés. @f1@ reste ouvert ; six rangs absents,84 DDF sans formule du passif. Shot/Dummy Coefficient1.2000000000000002 non adopté comme règle. Treize métadonnées de sorts,sept candidats absents bornés et19 références communautaires secondaires.

Six preloads2024 octets/28 noms : buff lucian_p_buf.troy et lucian_p_sound_only.troy,AA/Q/R,trail E et dépendances rageblade/itemhurricaneattack ; noms non recette ou exécution. Captures E696124/883003/769246 vérifiées. Deux DDS différentes2176 octets,64×64/DXT1/mipbrut0,membres172 et25 ; sélection,namespace25/Draven et pixels non qualifiés. Caveat du profil de ressource hérité : chemin natif mais SHAdeb86… communautaire,distinct de définition native d5e40… ; aucune correction JSON implicite.

## 3. Consommateurs réels

Treize Rust complets,34 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `shop.rs:261` ; `shop.rs:215` ; `world.rs:226` ; `damage.rs:38` ; `attacks.rs:26` ; `critical.rs:12` ; `death_recap.rs:184` ; `death_recap.rs:200` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `attacks.rs:167` ; `attacks.rs:218` ; `attacks.rs:257` ; `lifesteal.rs:17` ; `lifesteal.rs:20` ; `critical.rs:15` ; `death_recap.rs:202` ; `damage.rs:92` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/` et projected_live dans `crates/client/src/`. Sorts/rangs Lucian refusés. advance_attacks lance le projectile ordinaire,puis appelle basic_attack_hit à l’impact ; celui-ci applique le physique,le vol de vie et la rétorsion disponibles. critical utilise son catalogue et une sélection reconstruite ; les gardes du récapitulatif concernent session/tick/source connue. Aucun de ces acquis ne constitue le second tir ou son attribution spécifique.

La recherche nominative complète est bornée à ces13 fichiers : aucun hit Lucian/Lightslinger/lucian_p_. Ce n’est pas une absence globale. Le chemin projected_live sélectionne Annie ; les14 mécanismes partagés et les deux chemins d’animation ordinaires sont réutilisés par identités,non qualifiés pour Pistolero. Le catalogue relique ne couvre qu’un sous-ensemble Troy ; pose/attache/événement restent nécessaires.

25 comparaisons sélectionnées,105 contextuelles fraîches et une identité EXE héritée inerte parmi106 ; recouvrement,non131 consommateurs.14 identités communes et deux animations concordantes. Aucun gros registre JSON redécodé,ni analyse REA répétée.

## 4. Attendu et observé

Attendu : conserver provenance,déclarations,acquis/refus et limites,puis relier les écarts aux corrections. Observé :119/119 contrôles documentaires,111/111 de cohérence séparée du même agent ; relecture de témoins E conservés,non décodeur indépendant ou acceptation humaine.

V595 hérité : deux cas base/LongSword1036,six impacts,102 refus et362 ticks d’attente ; AD52.040000915527344→62.040000915527344,mana298.8800048828125 plafonnée. Aucun sort accepté,mana dépensé,armement,second tir ou expiration qualifiés. Stop et offsets179/180/181 ne définissent pas le début des6s. Dix snapshots complets par cas ; gardes combat/attente distincts du trajet. Flags de refus sans paires brutes ; lignes idle sans PV,donc pas de recomputation indépendante « régénération seule ». Tableaux HUD hérités exactement,sans recalcul nouveau.

Binaire6034944 octets,SHA14379fe3… hérité et inerte,ancien dossier revision536_yasuo simple libellé. Inspection passed/MDcode0 sans reçu brut : code numérique non revendiqué ; BUILD/RUN0 hérités de commandes brutes. Deux anciennes tentatives d’inventaire conservées,non rejouées. Ici huit opérations documentaires,six exit0 et deux exit1 initiaux : collect01 attendait14 au lieu de13 métadonnées,coherence01 employait une ancienne clé de projection ; scripts/logs conservés et corrections vérifiées. Lecture root d’un mauvais nom de modèle conservée par transcription. Aucun nouveau build,jeu,natifD,GPU,REA,probe ou capture.

## 5. Écarts et inconnues

Fin de sort/armement,refresh,expiration,consommation,second impact,délai,cible,formule,crit/on-hit,vol de vie et récapitulatif restent à qualifier. Preload Hurricane/Rageblade non interaction prouvée. Recette,lookup effectif,pose/os/attache,animation,rendu/audio et cycle de vie restent ouverts. Inconnues et consommateurs enregistrés conservés ; anciens binaires/stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : completed-cast-armed-state-and-six-second-source-contract ; second-shot-damage-target-classes-and-onhit-policy ; armed-buff-double-shot-presentation-and-lifecycle. Chacune précise objectif,prérequis,critères et reprise,avec autorisation distincte pour le produit.

Prochain lot CH-Lulu-PASSIF-PRESENTATION-VFX,sources exactes dans next_lot.json. Reprise sur source,mapping,appel,événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_lucian_passive_vfx_20261105/`,evidence_review.json,coherence_review.json,corrections_and_restart.json,opérations/journaux,result.json et reçus de publication. Publication et sept rubriques contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2356 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives. Goal,Plan/UI/bases,registres,produit et assets inchangés. Parent,jeu,fonctionnalité et acceptation restent ouverts.
