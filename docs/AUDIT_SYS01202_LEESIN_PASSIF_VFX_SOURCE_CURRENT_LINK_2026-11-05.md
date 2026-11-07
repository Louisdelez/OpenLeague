# Lee Sin — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05,V1366 ; `AUD-SYS-01.2-02-LEESIN-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-LeeSin-PASSIF-PRESENTATION-VFX` ; `OLF-d3644d62-0db3-5143-bbf2-d9403176e850`. Relier les déclarations applicables aux consommateurs courants et préciser les corrections. Seule cette liaison bornée est clôturée ; tâche VFX complète ouverte.

Audit : terminé pour ce périmètre. Implémentation : Rafale non établie dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie, runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/leesin-passive-flurry-links-v592.json`, copie E immuable :1048053 octets,SHA-256 `9b0ab6f17faa4fdf61e555b576c682f5f352c529b02c724fc3d3c2ff401e2a15`.25 identités/rôles, LoL4.20/EUW/en_GB. Chemins D inertes. V1237 source77/77 et consommateurs43/43 hérités.

Onze Lua structurels, quatre initialisations littérales,22 affectations. CharScript56 vide ; Passive et cosmetic372 identiques déclarent BlindMonkFlurry, BlindMonkPassive.dds et deux blindMonk_passive_buf.troy attachés à L_hand/R_hand. Égalité des octets non équivalence de gameplay. ETwo429 déclare dix champs dont TriggersSpellCasts=true, DoesntTriggerSpellCasts=false et L_Hand/R_Hand ; ni recast accepté ni alias de casse démontrés. Dix champs AutoBuff au total. Sept NEWTABLE restent limites du lecteur : BasicAttackpc0,QOne12,QTwo6,WOne8,WTwo12,EOne18,RKick18, sans corruption ou callback exécuté.

Description4219 : après capacité, deux attaques avec40%AS et15énergie chacune ; tooltip1724 cohérent. Pourtant Passive1LuaName conserve « Shen Passive Marker », tooltip2622 Ki Strike ;25e identité contradictoire, pas contrat LeeSin. Passive1=9, description Jax, textes de régénération mana et niveaux3/7/11/15 restent des champs hérités non adoptés. PARType=Energy, PARMax/PARStart absents : aucun plafond natif déduit.16 lignes DDF QWER ne constituent pas une formule de Rafale.

Un preload sélectionné364 octets/cinq références BBPreloadSpell : blindmonkrroot, passif, cosmetic, dégâts aux tours et rappel ; aucune absence des preloads non sélectionnés affirmée. Six candidats absents historiquement. Captures E642772/801010/1008574 vérifiées depuis historical_capture/files/capture_pin. Deux DDS identiques2872 octets,64×64/DXT1/mip7,membres188/25 : rôles définition LeeSinPassive/buff BlindMonkPassive conservés, sans alias runtime ni pixels. Quatre lignes de locale et14 références communautaires secondaires.

## 3. Consommateurs réels

Douze entrées complètes :11 Rust et champion_resources.json ;32 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `attacks.rs:26` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `lifecycle.rs:16` ; `lifecycle.rs:24` ; `shop.rs:261` ; `shop.rs:215` ; `shop.rs:314` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `progression.rs:119` ; `progression.rs:112` ; `regeneration.rs:47` ; `regeneration.rs:36` ; `lifecycle.rs:30` ; `attacks.rs:167` ; `attacks.rs:243` ; `attacks.rs:285` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, profil dans `data/4.20/`. Sorts directs/au sol et rangs LeeSin refusés. Les chemins de cadence, windup, attaque/impact et présentation ordinaires existent ; aucun producteur Rafale établi dans ces corps.

stats combine croissance, objets, TrundleW, EzrealW/passif et Exhaust, borne le dénominateur à0.05 puis arrondit et impose12ticks minimum. basic_attack_hit traite les dégâts physiques et le vol de vie, pas une restitution LeeSin établie. Les mécanismes d’animation et d’attache réutilisés ne prouvent ni activation ni liaison des effets aux mains. Projection inspectée Annie.

Profil23018 octets/SHA364f3e74… : leesin.type=Energy et référence native enregistrée ; aucune capacité/régénération/restitution dans cette ligne. uses_mana exclut l’énergie des bonus mana d’objets ; restores_resource inclut Energy. Régénération des vivants plafonnée par stats.max_mana, distincte du gain par attaque.

Recherche LeeSin/BlindMonk/Flurry/marker : zéro occurrence dans11 Rust ; deux lignes positives de profil sont des données.22 entrées sélectionnées et100 contextuelles chevauchantes fraîchement vérifiées ; une identité binaire héritée reste inerte parmi101 références de contexte. Aucun cumul123 consommateurs ou101 hashes frais revendiqué.14 entrées VFX et2 fichiers d’animation communs réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis, refus et lacunes sans qualifier Rafale depuis un contrôle d’objet. Observé :109/109 contrôles documentaires,106/106 cohérence séparée du même agent sur témoins sauvegardés ; aucune acceptation indépendante ou humaine.

Trois cas V592 hérités : base,Sapphire1027,Dagger1042 ;18 impacts,81 refus,180ticks finaux par cas. Cadences46/46/40 : Dague15%AS ordinaire, pas Rafale40%. Énergie200 toujours plafonnée, taux déclaré10/s ; Sapphire mana ne modifie pas sa capacité. Aucun sort accepté, aucun déficit pour mesurer15énergie. Frames240/240/209 et six snapshots complets par cas : vie/niveau1/rangs0/NPC/victoire observables aux snapshots ; compactframes ne portent pas ces champs. Tableaux V1237 hérités exactement, non recomputés ; snapshot_unchanged rapporté, sans snapshots de refus appariés pour reproduire l’égalité.

Binaire historique6042112 octets/SHA `e7fbd0c0e55e2124ffe6658ea8af6ad66d1d39801d75f44125478cc7785f72ea`, BUILD/RUN0 hérités. Copie E et chemin F-work restent des identités documentaires, sans réouverture du binaire. Ancienne inspection supposant tous les rangs absents corrigée en3/7/11/15 ; scripts identifiés, code1 rapporté par MD, sortie originale indisponible, sans replay. Sources datées du26octobre distinctes du contrôle actuel.

Une requête root avait supposé historical_documentary_capture ; corrigée vers le vrai schéma historical_capture, erreur conservée. Six opérations documentaires exit0. Aucun nouveau build, jeu, décodage natif, GPU, REA, probe ou capture.

## 5. Écarts et inconnues

Liaison applicable malgré le marker Shen, capacité/recast éligible, création, charges, consommation, refresh, ordre et durée éventuelle restent ouverts. Deux attaques/+40%/+15 ne sont pas mesurés par ces essais sans déclencheur. Recette, sélection, variante, squelette, attache, animation et rendu non qualifiés ; compteurs/imports/icônes ne les prouvent pas. Inconnues et consommateurs enregistrés conservés ; stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : flurry-applicable-binding-and-bilateral-resource ; authoritative-cast-two-attacks-AS-and-energy-event ; bilateral-hand-effects-animation-render-lifecycle. Objectif, prérequis, critères et conditions de reprise précisés ; aucune correction produit implicite.

Prochain lot CH-Leona-PASSIF-PRESENTATION-VFX, reçu V593 et identité dans next_lot.json. Reprendre sur source, mapping, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain chiffré mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_leesin_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, opérations/journaux, result.json et reçus de publication. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2353 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation restent ouverts.
