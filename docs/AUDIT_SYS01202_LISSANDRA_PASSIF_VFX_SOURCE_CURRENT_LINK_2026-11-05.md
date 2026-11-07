# Lissandra — liaison du passif historique Iceborn

## 1. Exigence et portée

2026-11-05,V1368 ; `AUD-SYS-01.2-02-LISSANDRA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Lissandra-PASSIF-PRESENTATION-VFX` ; `OLF-e49a786e-c5fb-5362-9be5-dc30a555a4de`. Relier déclarations applicables, consommateurs et corrections. Seule cette liaison bornée est clôturée ; tâche VFX complète ouverte.

Audit : terminé pour ce périmètre. Implémentation : Iceborn non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie, runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/lissandra-passive-iceborn-links-v594.json`, copie E immuable :1110969 octets,SHA-256 `42346eb013b50a07b702444a4c54ae281bce98726c06b7961cd9b0085101e1de`.32 identités/rôles, LoL4.20/EUW/en_GB. Chemins D inertes. V1239 source105/105 et consommateurs40/40 hérités.

Onze Lua structurés, cinq initialisations littérales,17 affectations. CharScript56 vide ; Passive190 et PassiveBuff194 déclarent icône, noms distincts et persistence, sans politique de recharge. Ready259/Q414/W441/E437/R296/WFrozen438 restent limités par NEWTABLEpc6/6/8/16/8/14 ; pas corruption ou absence globale déduite. Slow263 conserve Chronokeeper_Timestop.dds, Slow et GLOBAL_SLOW.TROY ; RSlow344 sept flags dont SpellDamageRatio1.0, sans réduction exécutée. Un AutoBuff qualifié dans le contexte Slow, sans recette Ready inférée.

Description4222 et tooltip2216 : prochain sort gratuit toutes18s, récupération réduite1s par entrave d’une capacité, exclusion des entraves d’objets. Ready2217 distinct de PassiveBuff dont la clé exacte est introuvable. Six rangs passifs absents non remplacés par défaut.24 lignes DDF vides non valeurs numériques ; cinq candidats absents historiquement, dix métadonnées de sorts contextuelles.

Huit preloads2897 octets/37 références : Passive/Ready/Start, trois-sœurs/taunts, W/E/R et variantes. L’espace final dans « lissandra_base_e_skin_flash.troy » est conservé ; lookup non qualifié. Captures E646850/842100/1105606 vérifiées. Une DDS2176 octets,64×64/DXT1/mipbrut0,membre161 : identité/en-tête hérités, sans sélection effective ou pixels. Dix lignes de locale,16 références communautaires secondaires ; Slow2669 lié explicitement, sans substitution à un nom Lissandra.

## 3. Consommateurs réels

Dix-huit entrées :16 Rust et deux JSON ;38 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `shop.rs:261` ; `shop.rs:215` ; `world.rs:226` ; `damage.rs:38` ; `cooldown.rs:11` ; `cooldown.rs:10` ; `slows.rs:41` ; `slows.rs:62` ; `stuns.rs:15` ; `movement.rs:53` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `cooldown.rs:13` ; `progression.rs:88` ; `slows.rs:4` ; `slows.rs:29` ; `slows.rs:57` ; `stuns.rs:5` ; `stuns.rs:17` ; `regeneration.rs:47` ; `lifecycle.rs:16` ; `lifecycle.rs:24` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, configurations dans `data/4.20/`. Sorts/rangs Lissandra refusés. Coûts, mana, régénération plafonnée et CDR ordinaires existent ; aucun producteur Iceborn établi dans ces corps.

cooldown::ticks applique une réduction bornée ; configuration419 octets : maximum0.4, minimum0s. Ce circuit ne qualifie ni gratuité ni réduction1s du passif. Slow stocke tag/fraction/expiration sans source ou origine typées ; Stun a source optionnelle mais pas de classe capacité/objet. Leurs producteurs peuvent connaître cette provenance : état seul insuffisant pour l’exclusion d’objets. Préparation/commit des slows et admission des stuns restent acquis génériques, sans événement Iceborn établi. Projection inspectée Annie.

Profil `champion_resources.json`23018 octets : typeMana, chemin DATA/Characters/Lissandra/Lissandra.inibin, mais source_sha256=23f9… correspond à l’instantané communautaire4226 octets, différent du natif1232 octets/hash0740…. Écart de provenance déjà recensé et confirmé, contrat à clarifier ; pas échec produit reproduit. lifecycle lit type seulement : témoin E6109 octets réutilisé via chaîne vérifiée et SHA actuel, sans rouvrir son corps sur F. Huit configurations restent du contexte local, sans politique native globale inférée.

Recherche Lissandra/Iceborn : zéro occurrence dans16 Rust ; deux lignes positives du profil sont des données.24 entrées sélectionnées et104 contextuelles chevauchantes vérifiées ; une identité binaire héritée inerte parmi105. Aucun cumul129 consommateurs ou105 hashes frais revendiqué.14 entrées VFX et2 fichiers d’animation communs réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis, refus et lacunes sans qualifier Iceborn depuis mana plafonné ou CDR d’objet. Observé :136/136 contrôles documentaires,128/128 cohérence séparée du même agent, témoins sauvegardés ; aucune acceptation indépendante ou humaine.

Deux cas V594 hérités : base et Codex3108, AP0/30, CDR0/environ10%, mana304 ; six attaques à distance,102 refus,1082ticks d’attente. Aucun sort accepté, mana dépensé, gratuit exercé, recharge armée ou entrave de capacité. Stop ne prouve pas le départ du compteur ; offsets539/540/541 sans armement ne qualifient pas18s. Dix snapshots complets/cas, portées de gardes combat/attente distinctes du trajet ; aucun contrôle NPC universel déduit.

Refus stockés sous flags, sans couples bruts avant/après. Idle expose tick/offset/mana/flag, sans tableaux HP pour recomputer « régénération seule ». Tableaux et ancien calcul numérique/tolérance0.002 hérités exactement, non recomputés ; aucune précision passive qualifiée.

Binaire6034432 octets/SHA `87969cf38558b5209af8283e55e6a9ad363c5b447f5f1630e9ad3ff6d1593205`, copie E/F-work inertes. BUILD/RUN0 hérités des commandes brutes. Inspection passed=true/code0 attesté par MD, reçu original absent. Anciennes préparations conservées : échec de relecture Slow puis union fontes/bindings, préflight existant et SyntaxError de quoting. Les deux premiers ont des logs ; le dernier une transcription seulement, code Python individuel inconnu malgré enveloppe0. Aucune relance. Sources du26octobre distinctes du contrôle actuel. Sept opérations documentaires exit0 ; aucun nouveau build/jeu/natif/GPU/REA/probe/capture.

## 5. Écarts et inconnues

Disponibilité initiale, éligibilité/consommation, coût gratuit, armement/recharge, entrave valide, origine et attribution, répétitions, ordre et décès restent ouverts. Persistance, icône et preloads ne prouvent pas état, attache ou rendu. PassiveBuff non aliasé Ready ; contexte Slow/RSlow distinct du passif. Provenance du profil local non corrigée. Inconnues et consommateurs enregistrés conservés ; stockages/binaire non rouverts.

## 6. Corrections et reprise

Quatre clauses dans corrections_and_restart.json : iceborn-passive-buff-ready-source-and-eligibility ; lissandra-resource-profile-provenance, liée aussi à `CH-Lissandra-PASSIF-SOURCE` ; authoritative-freecast-armed-recharge-and-abilityCC-event ; ready-start-resource-animation-render-lifecycle. Objectifs uniques, prérequis, critères et reprise précisés ; aucune correction produit implicite.

Prochain lot CH-Lucian-PASSIF-PRESENTATION-VFX, reçu V595 dans next_lot.json. Reprendre sur nouvelle source, mapping, appel, événement ou dérive ; pas de recensement global ou replay inchangé. Aucun gain chiffré mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_lissandra_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, reused_resource_consumer.json, corrections_and_restart.json, opérations/journaux, result.json et reçus de publication.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2355 entrées sales conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation ouverts.
