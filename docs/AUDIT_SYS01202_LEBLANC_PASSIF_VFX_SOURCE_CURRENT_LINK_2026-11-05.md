# LeBlanc — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05,V1365 ; `AUD-SYS-01.2-02-LEBLANC-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Leblanc-PASSIF-PRESENTATION-VFX` ; `OLF-b04a8c90-ba91-5451-b2d8-93aac3ef8779`. Relier les déclarations applicables aux consommateurs courants et préciser les corrections. Seule cette liaison bornée est clôturée ; tâche VFX complète ouverte.

Audit : terminé pour ce périmètre. Implémentation : Image miroir non établie dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie, runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/leblanc-passive-mirror_image-links-v591.json`, copie E immuable :1499582 octets,SHA-256 `ca4875eb0394e50c57e748e1667697d22b96cabc3a87b886243e6c30d851bdef`. Quatorze identités/rôles, LoL4.20/EUW/en_GB. Chemins D inertes. V1236 source95/95 et consommateurs56/56 hérités.

Six Lua entièrement structurés et six initialisations littérales, neuf affectations ; CharScript/MIFull/MIStealth56 vides. Passive223 déclare LeblancMirrorImage.dds, LeblancNoxianCruelty, persistence et Nondispellable. Cooldown234 déclare Charging, LeblancPassiveCooldown, persistence et NonDispellable : casse distincte conservée. Applicator90 ne déclare que persistence. Aucun AutoBuff reconnu ne prouve une absence globale d’effet ; flags et chunks vides ne sont pas des callbacks exécutés.

Passive1LuaName=LeblancPassive ; description4218 et tooltip2198 : sous40%HP, invisibilité1s, clone sans dégâts durant au plus8s, recharge1minute, Alt+clic droit. Schism2199 reste le titre du cooldown, non un autre passif. Deux métadonnées de sorts ont leurs champs sélectionnés absents, sans durée/coût inventés. Six candidats absents et DDF manquant sont des observations historiques bornées ; NightmareBot non adopté.

Quatre preloads1115 octets/15 références : applicator/cooldown, poof/globalstealthscreentint/MIStealth/MIFull, image/root/imagedeath ; root est BBPreloadSpell, non immobilisation démontrée. Trois captures E477721/787206/6903816 vérifiées par rôle, ordre original conservé. Deux DDS distinctes64×64 :2872/DXT1/mip7/membre153 et4224/DXT5/mip1/membre107, sans pixels ni lookup effectif. Quatre lignes de locale et huit références communautaires secondaires conservées.

## 3. Consommateurs réels

Dix-sept Rust complets,41 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `vision.rs:79` ; `vision.rs:137` ; `vision.rs:30` ; `vision.rs:48` ; `annie_r.rs:23` ; `annie_r.rs:62` ; `annie_r.rs:82` ; `movement.rs:53` ; `attacks.rs:103` ; `lib.rs:603` ; `damage.rs:104` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `annie_r.rs:44` ; `annie_r.rs:69` ; `annie_r.rs:71` ; `annie_r.rs:87` ; `main.rs:1390` ; `main.rs:1489` ; `main.rs:1500` ; `vision.rs:83` ; `vision.rs:96` ; `world.rs:5` ; `world.rs:125` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/` et `crates/client/src/`. Les dégâts actuels modifient les PV ; rangs et sorts LeBlanc restent refusés. Aucun producteur de seuil, clone ou invisibilité établi dans ces corps. visible_to et visible_point_to contiennent les deux branches interactions désactivées ; snapshot_for filtre la projection via visible_to ; vision/rayons/LOS/Ignite ne constituent pas une politique de furtivité native.

Tibbers : lookup propriétaire/pet vivant/non expiré, sans garde champion dans ce helper. Création via état AnnieR et annietibbers ; propriétaire, ordre, expiration, suivi et dégâts existent. L’appel cast_at exige Annie et slot3. Le client exige Annie, pet possédé vivant/non expiré et Alt+clic droit, puis CastAt3/send_action. Cela ne fournit pas Image miroir. world::Unit conserve pet:Option<annie_r::Pet> ; animation et projection ordinaires ne créent aucun clone, projection inspectée Annie.

Recherche LeBlanc/MirrorImage/NoxianCruelty : zéro occurrence dans ces17 textes, sans absence globale déduite.29 comparaisons sélectionnées et127 contextuelles chevauchantes concordent ;14 entrées VFX et2 fichiers d’animation communs réutilisés. Onze captures historiques d’échecs et de reprise font partie des identités inchangées.

## 4. Attendu, observé et contrôles

Attendu : relier source, acquis, refus et lacunes sans promouvoir un pet ou un preload en Image miroir. Observé :115/115 contrôles documentaires,113/113 cohérence séparée du même agent sur témoins sauvegardés ; aucune acceptation indépendante ou humaine.

Deux cas V591 hérités :516HP puis666HP avec Ruby1028 ;24 impacts physiques d’Annie,54 refus, quatre franchissements de seuil,4102ticks d’attente. Chaque cas comporte1810 puis241ticks : originelle visible et présente dans la projection ennemie locale, sans clone/pet exposé détecté. HP initialement au-dessus40%, puis inférieurs ; égalité exacte non exercée. Régénération et nouveau franchissement ne qualifient pas la recharge, jamais armée. Détection limitée aux représentations exposées, sans exhaustivité historique, réseau ou rendu. Tableaux V1236 hérités exactement, non recomputés ; snapshot_unchanged reste rapporté par la sonde, sans couples de snapshots par refus.

Binaire historique6124544 octets/SHA `560aa21ef402b3388f3b6f015e94b0f23099402b0be9556cf15c958cd271a401`, BUILD/RUN0 qualifiés hérités, chemins inertes. Deux anciennes tentatives en lane restent BUILD0/RUNnonzero : diagnostic offset1778/ticks3774→3775, trois Red_Minion_Wizard ciblent LeBlanc ; impact exact indéterminé. Reprise centrale demandée z7000, positions réellement atteintes autour6934.24 conservées, durées inchangées. Ancienne erreur de parenthèse : texte MD ligne49 seulement, octets originaux indisponibles. Captures supplémentaires non promues en entrées sémantiques.

Recherche root initiale mal paramétrée corrigée ; current01 arrêté par garde sur chemins relatifs, collect01 échoué sur hypothèse d’un site unique de visibilité. Sources/scripts/résultats/logs initiaux conservés, current02/collect02 réussis. Le diagnostic préparatoire nommant snapshot_for comme second site est rectifié avant publication : il s’agit de visible_point_to. Huit opérations documentaires : six exit0, deux exit1 initiaux. Aucun nouveau build, jeu, décodage natif, GPU, REA, probe ou capture.

## 5. Écarts et inconnues

Seuil exact, ordre létal/simultané, disponibilité, furtivité/révélation, identité, contrôle, zéro dégât, durée et réarmement restent ouverts. Création, sélection, pose, animation, attache, tint et rendu non qualifiés. Attentes sans activation ne prouvent aucune expiration. Flags persistence, icônes et contrôle Tibbers ne résolvent pas ces règles. Inconnues et consommateurs enregistrés conservés ; stockages et binaires non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : mirror-image-applicable-source-and-resource ; authoritative-threshold-stealth-clone-and-control-event ; clone-stealth-resource-animation-render-lifecycle. Objectif, prérequis, critères et conditions de reprise précisés ; aucune correction produit implicite.

Prochain lot CH-LeeSin-PASSIF-PRESENTATION-VFX, reçu V592 et identité dans next_lot.json. Reprendre sur source, mapping, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain chiffré mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_leblanc_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, opérations/journaux, result.json et reçus de publication. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2352 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation restent ouverts.
