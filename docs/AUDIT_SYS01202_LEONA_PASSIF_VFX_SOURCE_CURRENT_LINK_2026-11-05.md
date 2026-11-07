# Leona — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05,V1367 ; `AUD-SYS-01.2-02-LEONA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Leona-PASSIF-PRESENTATION-VFX` ; `OLF-a270f4a2-9473-559e-994d-b7ee693a30ed`. Relier les déclarations applicables aux consommateurs courants et préciser les corrections. Seule cette liaison bornée est clôturée ; tâche VFX complète ouverte.

Audit : terminé pour ce périmètre. Implémentation : Sunlight non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie, runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/leona-passive-sunlight-links-v593.json`, copie E immuable :1045894 octets,SHA-256 `c2b015f7aaee292046c5d3acc792e1a22699c2913da08cb97ae6f78919391b81`.27 identités/rôles, LoL4.20/EUW/en_GB. Chemins D inertes. V1238 source86/86 et consommateurs42/42 hérités.

Neuf Lua structurels et neuf initialisations littérales,31 affectations ; CharScript/BarrierTracker56 vides. Sunlight149 déclare icône et nom de marque ; SunlightPassive218 déclare passif propriétaire, persistence et NonDispellable. Ces flags ne définissent pas la persistence de la marque cible. Q236 et attaque renforcée127 diffèrent par DoesntTriggerSpellCasts ; W298 conserve SpellToggleSlot2.0/TriggersSpellCasts, sans politique exécutée. Zenith343 a deux AutoBuff explicitement vides, contexte E non absence globale. Flare222 garde cinq flags. Aucune limite littérale dans ces neuf vues, aucun callback exécuté.

Description4220 : sorts infligeant des dégâts, marque3.5s, consommation par les dégâts d’un champion allié, bonus magique. Tooltips2206/2207 distinguent cible/passif ; @f2@ reste non résolu. Niveaux1/4/7 non table de dégâts. Quatre lignes DDF SolarBarrier, dont bonusarmor/bonusspellblock×0.2, ne donnent pas la formule Sunlight. Sept métadonnées de sorts et quatre candidats absents conservent leurs rôles historiques.

Huit preloads2949 octets/38 références : trois particules Sunlight champion/cible/tar, passif/tracker, activation Q et attaque, W/R, skin04, root et testcube. root est BBPreloadSpell et testcube BBPreloadCharacter, sans immobilisation ou recette déduite. Absence des preloads non sélectionnés non affirmée. Captures E594727/787282/1454082 vérifiées. Deux DDS identiques2176 octets,64×64/DXT1/mipbrut0,membre37 : deux identités conservées, sans alias runtime, lookup effectif ou pixels. Six lignes de locale et13 références communautaires secondaires.

## 3. Consommateurs réels

Quatorze entrées complètes :13 Rust et annie_q_rules.json ;34 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `regeneration.rs:10` ; `shop.rs:261` ; `shop.rs:215` ; `annie.rs:45` ; `annie.rs:73` ; `world.rs:226` ; `damage.rs:38` ; `annie_passive.rs:9` ; `annie_passive.rs:20` ; `spells.rs:115` ; `spells.rs:120` ; `progression.rs:164` ; `annie_w.rs:49` ; `annie.rs:64` ; `annie.rs:70` ; `annie.rs:87` ; `annie_passive.rs:11` ; `damage.rs:92` ; `damage.rs:97` ; `damage.rs:104` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, contrôle Q dans `data/4.20/`. Les sorts/rangs Leona restent refusés. Les routes de dégâts physiques, attaques et présentation ordinaires existent, sans producteur Sunlight établi dans ces corps.

L’appel cast_annie est gardé par champion=annie. Le Q utilise les statistiques de sa propre source, puis mana/coût/cooldown et projectile ; impact magique accepté suivi du chemin Pyromania, dont le compteur est gardé par propriétaire Annie. Cela ne crée pas de marque Leona. Contrôle JSON355 octets/SHA172e4560… :80brut,60mana,4s et coefficient0.8, propres au Q allié.

apply_damage conserve mitigation, boucliers, PV, contribution et mort ; la contribution générique n’est pas un déclencheur Sunlight. Projection inspectée Annie. Les mécanismes VFX/animation réutilisés ne prouvent pas activation, attache ou rendu du passif.

Recherche Leona/Sunlight : zéro occurrence dans13 Rust sélectionnés, sans absence globale déduite.24 entrées sélectionnées et99 contextuelles chevauchantes fraîchement vérifiées ; une identité binaire héritée gardée inerte parmi100 références. Aucun cumul124 consommateurs ou100 hashes frais revendiqué.14 entrées VFX et2 fichiers d’animation communs réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis, refus et lacunes sans qualifier Sunlight depuis un Q allié ordinaire. Observé :122/122 contrôles documentaires,113/113 cohérence séparée du même agent sur témoins sauvegardés ; aucune acceptation indépendante ou humaine.

Deux cas V593 hérités, Leona propriétaire AP0/20 et équipes0/0/1 : six impacts physiques du propriétaire, six Q alliés,54 refus,360ticks finaux et416ticks d’attente de cooldown. Aucun sort Leona accepté, aucune marque ni consommation. Q80brut/MR30 donne environ61.53846 dégâts ordinaires ;60mana/120ticks enregistrés et assertions historiques, sans snapshots immédiatement après lancement pour recomputer coût/CD. Comparaison AP du propriétaire non mesure du scaling du passif.

Onze snapshots complets/cas : participants vivants/niveau1, équipes et rangs Leona0 vérifiés dans cette portée. Gardes combat/attente/fin distinctes du trajet ; NPC visibles aux snapshots, sans garde universelle déduite. Wait/tail exposent ticks/flags, pas tableaux de santé : régénération seule reste héritée. Tolérance0.002 concerne les contrôles ordinaires en float32, pas précision Sunlight. Tableaux V1238 hérités exactement, non recomputés ; égalité des refus rapportée par la sonde, sans couples bruts avant/après.

Binaire historique6048768 octets/SHA `60a89121a40f100f33686b97b3cf4e84dff353a7c2b43a85e76f3120727593a7`, copie E et chemin F-work inertes. BUILD/RUN0 proviennent des commandes brutes héritées. Inspection OBS passed=true et code0 attesté par MD ; reçu de sortie original absent, code brut non revendiqué. Sources du26octobre distinctes du contrôle actuel. Six opérations documentaires exit0 ; aucun nouveau build, jeu, décodage natif, GPU, REA, probe ou capture.

## 5. Écarts et inconnues

Application, début/durée, refresh, consommation alliée, cibles, dégâts simultanés, formule/niveau/AP, ordre et attribution restent ouverts. Sans marque active, attendre ne prouve pas expiration. Passif propriétaire, marque et contrôle Annie/Pyromania distincts. Recette, sélection, variante, pose, attache, animation et rendu non qualifiés ; imports/icônes/preloads ne les prouvent pas. Inconnues et consommateurs enregistrés conservés ; stockages et binaires non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : sunlight-owner-target-source-formula-and-resource ; authoritative-mark-allied-damage-consumption-and-credit ; target-mark-proc-animation-render-lifecycle. Objectif, prérequis, critères et conditions de reprise précisés ; aucune correction produit implicite.

Prochain lot CH-Lissandra-PASSIF-PRESENTATION-VFX, reçu V594 et identité dans next_lot.json. Reprendre sur source, mapping, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain chiffré mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_leona_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, opérations/journaux, result.json et reçus de publication. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2354 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation restent ouverts.
