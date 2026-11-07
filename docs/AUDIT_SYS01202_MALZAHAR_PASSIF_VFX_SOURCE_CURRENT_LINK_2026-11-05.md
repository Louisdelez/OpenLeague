# Malzahar — liaison du passif historique et des êtres du Néant

## 1. Exigence et portée

2026-11-05, V1373. `AUD-SYS-01.2-02-MALZAHAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Malzahar-PASSIF-PRESENTATION-VFX` ; `OLF-54041e9e-5322-59d6-a153-249351cbdcce`. Audit de liaison des déclarations,consommateurs et écarts. Seul ce périmètre est terminé ; tâche VFX complète ouverte.

Implémentation : mécanismes de familiers présents, compteur/invocation/phases propres à Malzahar non établis dans les corps examinés. Vérification documentaire réussie, runtime hérité. Acceptation humaine non demandée. Prérequis,contrats et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/malzahar-passive-summon-voidling-links-v599.json`,1567772octets,SHA `98933be5a2f3e3d3cd8e211c7ee6907c077a571fc0257eac8004e726571af761`. Copie E identifiée,57identités/rôles ; référence LoL4.20.0.315/EUW/en_GB,catalogue4.20.1 distinct. Chemins D inertes. Audit HUD source95/95 et consommateurs36/36 hérité. Manifest initial42954octets/SHAf5b6a892… vérifié ; capture d’origine et relocalisation byte-exact des fichiers initiaux conservées,anciens chemins non réécrits et opérations non rejouées.

23Lua, zéro prototype enfant,23initialisations/80affectations,aucune limite littérale. Six Lua56 vides : CharScript,CallR,DeathParticle et trois attaques de Voidling ; aucune absence d’animation déduite. Seul le CharScript communautaire inspecté est déclaré vide.

Ready259 utilise icône Ready,nom AlZaharSummonVoidlingReady,Voidling_Ready.troy et NonDispellable ; Count200 utilise Charging/AlZaharSummonVoidlingBuff,sans persistence ajoutée. Detonation227 utilise Ready/AlZaharSummonVoidling et persistence. Phase2,InCombat et NetherGraspOn166 partagent le nom Phase2,sans callback déduit. Phase3 déclare deux AlzaharVoidling_speed.troy sur BUFFBONE_GLB_HAND_R/L.11champs AutoBuff non vides incluent les contextes E/R ; casse des attaches préservée. Nautilus/Malady et Ezreal/FallenAngel restent littéraux ; canalR2.5s distinct de l’âge du familier.

Tooltips1677–1685 et description4229 : quatre sorts,créature incontrôlable21s,croissance7s(+50%AD/armure),frénésie14s(+100%AS). Description : PV200+50×niveau,AD20+5×niveau ; @f1@/@f2@/@f3@ et producteur effectif/niveau/bonusAD restent ouverts. Ready dit « prochain sort » : mapping quatrième/cinquième non qualifié. MaleficVisions attire les créatures,sans donner toute leur IA. Bases du fichier : HP200,HPPerLevel0,AD20,armure30,MR50,portée125,vitesse460,radius20 ; non statistiques finales créées.

18métadonnées de sorts,six candidats absents bornés,13contextes NightmareBot exclus,25références communautaires secondaires. Aucun champ DDF dans ce reçu,aucune valeur suppléée.13preloads3643octets/48noms : personnage malzaharvoidling,Count/Ready,ifhasbuffcheck,flash/transform/evo et QWER ; liens non création ou recette. Captures E876027/1111348/1800566 vérifiées. Trois DDS différentes2872octets,64×64/DXT1/mips7,membre25 : normale/Charging/Ready,sans lookup ou pixels qualifiés. Contextes modèle/particules non ouverts,non absence globale. Aucun champ de caveat de provenance de ressource dans ce reçu ; aucun incident inventé ou réputé résolu.

## 3. Consommateurs réels

14Rust complets,41ancres dans evidence_review.json. Racine `F:/OpenLeague/`. Points principaux : `crates/core/src/spells.rs:101`, `progression.rs:150,159`, `attacks.rs:157`, `annie_r.rs:20,23,26,62,82`, `annie_w.rs:47`, `annie_r.rs:69,71`, `crates/client/src/projected_live.rs:168`.

Sorts/rangs Malzahar refusés ; attaques/projectiles/physique et attribution ordinaires acquis. combat_owner,tibbers et ordres de familiers fournissent des points de réutilisation ; la branche cast_at vers cast_tibbers exige Annie/slot3 ; advance_annie_r crée annietibbers à la libération,avec Pet/propriétaire/durée. Elle n’établit pas un producteur Voidling,un compteur de sorts ou l’IA native. projected_live sélectionne Annie.

Recherche complète bornée aux14Rust : aucun hit Malzahar/voidling/alzahar,non absence globale d’assets.28comparaisons sélectionnées,133contextuelles fraîches et une identité EXE héritée inerte parmi134 se recouvrent ; pas162consommateurs.14mécanismes communs et deux animations ordinaires réutilisés,non phases/recette du familier. Aucun gros registre JSON redécodé ni analyse REA répétée.

## 4. Attendu et observé

Attendu : préserver provenance,acquis/refus et limites,puis relier les écarts aux corrections. Observé :156/156 contrôles documentaires,128/128 de cohérence séparée du même agent. Témoins E relus ; aucun décodeur indépendant ou acceptation humaine.

V599 hérité : base/LongSword1036,AD54.70000076293945/64.69999694824219,six impacts/six projectiles ordinaires,246refus/1262ticksidle,mana325.6000061035156 plafonnée. Aucun sort accepté,invocation ou âge armé ; les attaques ordinaires ne comptent pas comme sorts. Offsets209/210/211,419/420/421,629/630/631 après Stop ne qualifient ni croissance ni frénésie ni expiration.

16snapshots complets/cas ; gardes combat/idle distincts du trajet,observations NPC bornées. Paires brutes de refus,PVidle/entre impacts et snapshots complets idle absents ; comptes de familiers zéro et tableaux hérités,sans nouveau calcul. L’absence de familier observé ne prouve pas que ses modèles/textures/animations manquent globalement. Binaire6057472octets/SHA9de2b412… inerte,ancien dossier yasuo simple libellé. OBSpassed non reçu terminal,code brut null ; BUILD/RUN0 hérités. Six opérations documentaires exit0 ; aucun nouveau build,jeu,natifD,GPU,REA ou probe.

## 5. Écarts et inconnues

Compteur/sorts éligibles,sort exact d’invocation,reset/persistence,création,statistiques effectives/bonusAD,niveau/âge,phases,expiration,IA et attribution restent ouverts. Formules textuelles conservées ; bases statiques non substituées au producteur. Icônes/preloads ne qualifient pas modèle animé,attache,recette,lookup,rendu/audio ou cycle de vie. Inconnues et consommateurs enregistrés conservés ; binaires/stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : eligible-cast-counter-ready-and-summon-source-contract ; authoritative-voidling-stats-age-phases-AI-and-damage ; counter-ready-pet-phases-animation-effects-and-lifecycle. Objectifs,prérequis,critères et reprise explicites ; aucune correction produit implicite.

Prochain lot CH-Maokai-PASSIF-PRESENTATION-VFX,sources dans next_lot.json. Reprendre sur source,appel,mapping,événement ou dérive précise ; pas de replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_malzahar_passive_vfx_20261105/`,evidence_review.json,coherence_review.json,corrections_and_restart.json,opérations/journaux,result.json et reçus de publication. Publication et sept rubriques vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2360 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives. Goal,Plan/UI/bases,registres,produit et assets inchangés. Parent,jeu,fonctionnalité et acceptation ouverts.
