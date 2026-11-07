# Kog’Maw — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1364 ; `AUD-SYS-01.2-02-KOGMAW-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-KogMaw-PASSIF-PRESENTATION-VFX` ; `OLF-05256100-acbd-5d01-a278-df6ffb57e18f`. Relier les déclarations applicables aux consommateurs courants et préciser les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète reste ouverte.

Audit : terminé pour ce périmètre. Implémentation : état post-mortem et explosion non établis dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime hérité. Acceptation humaine : non demandée. Prérequis de phase/lot et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/kogmaw-passive-icathian_surprise-links-v590.json`, copie E immuable référencée :1011796 octets, SHA-256 `d8cea6207e3bd55e2fa0062e61c3a61fdd45bef47fa965fb40c275723d17e790`. Dix-huit identités/rôles, référence LoL4.20/EUW/en_GB. Chemins D inertes. V1235 source63/63, consommateurs51/51 et intégration40/40 hérités.

Six Lua structurels, cinq initialisations,18 affectations ; CharScriptKogMaw et Dead56 vides. Ready235 : icône, nom, persistence/NonDispellable ; Sound173 : deux champs, persistence non déclarée, sans défaut inventé. Display518 :12 champs dont trois AutoBuff explicitement vides et IsDamagingSpell=false ; cela ne prouve ni absence globale d’effet ni absence d’explosion. Surprise722 reste limité par NEWTABLEpc26, sans corruption déduite ou callback exécuté.

Passive1LuaName=KogMawIcathianDisplay ; description4217 : mouvement accéléré, explosion après4s,100+25niveau dégâts bruts. Tooltips2186/2187/2188 gardent leurs rôles et @f1@ non résolu. Trois textes de sort9568/11663/10992 indiquent160+30niveau magiques : conflit ouvert. KogMawDead déclare Surprise et MoveSpeed330 ; aucune transformation ou multiplicateur démontré. CastRadius1000, CastRange1600, Coefficient0.7,8s/70mana, missileQ et Sion.wav ne deviennent pas des règles du passif. Quatre candidats absents et20 lignes DDF sans formule restent des constats datés.

Quatre preloads1546 octets/20 références : proc, backbeam, idle/explosion base et skin08 ; Ready contient skin04/deepsea. KogMawDead est BBPreloadCharacter ; untargetable/unlockanimation sont BBPreloadSpell, sans politique serveur déduite. Captures E500413/693659 vérifiées. Deux DDS identiques2872 octets,64×64/DXT1/mip7,membres0.0.0.252/251 : en-têtes hérités, sans pixels ni sélection effective. Huit lignes de locale et dix références communautaires secondaires conservées.

## 3. Consommateurs réels

Seize entrées complètes :15 Rust et death_times_map10.json.38 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `champion_kills.rs:26` ; `champion_kills.rs:32` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `lifecycle.rs:33` ; `lifecycle.rs:6` ; `lifecycle.rs:24` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `attacks.rs:103` ; `movement.rs:53` ; `lib.rs:603` ; `damage.rs:115` ; `damage.rs:111` ; `damage.rs:136` ; `damage.rs:130` ; `lifecycle.rs:76` ; `lifecycle.rs:83` ; `regeneration.rs:36` ; `spells.rs:120` ; `progression.rs:164` ; `animation.rs:792` ; `animation.rs:790` ; `attack_animation.rs:161` ; `projected_live.rs:168` ; `damage.rs:43` ; `animation.rs:855`.

Racines `F:/OpenLeague/crates/core/src/`, animation/attack_animation/projected_live dans `crates/client/src/`, table dans `data/4.20/`. La commande publique refuse le mort avant dispatch, donc Move également. Sorts/rangs de Kog’Maw vivant restent refusés. Les dégâts létaux effacent actions, effets et chemin, programment immédiatement la réapparition et attribuent la récompense ordinaire. La régénération vise les vivants ; les ressources et effets sont réinitialisés à la réapparition.

La table1014 octets donne16s au niveau1, convertis en480ticks à30Hz ; variation tardive non qualifiée. Aucun lien au compte à rebours du passif. Le traitement générique DamageKind::True conserve raw dans mitigate ; il ne produit pas l’explosion.

Le client choisit death après la priorité idle de cérémonie Nexus ; rôle absent : continue. Les attaques sont interrompues pour un acteur mort. La projection inspectée cible Annie. Recherche bornée KogMaw/Icathian : zéro occurrence dans ces16 textes, sans absence globale déduite.24 comparaisons sélectionnées et95 contextuelles chevauchantes concordent ;14 entrées VFX et2 fichiers d’animation ordinaires inchangés réutilisés.

## 4. Attendu, observé et contrôles

Attendu : source, acquis, refus et lacunes reliés, sans promouvoir métadonnées ou mort ordinaire en passif. Observé :112/112 contrôles documentaires et109/109 de cohérence séparée du même agent sur témoins sauvegardés ; aucune acceptation indépendante ou humaine.

Deux cas V590 hérités :546.159973HP puis696.159973HP avec Ruby1028 ;32 impacts physiques d’Annie, deux morts,164 refus dont110 morts,960ticks observés, deux réapparitions à480ticks. Aux offsets0/1/119/120/121, quatre Cast, quatre CastAt et Move/Attack/Stop refusés. Ennemi à100 unités conservé à pleine santé ; ni déplacement post-mortem ni explosion observés. Après réapparition, mouvement repris,12 refus Learn/Cast/CastAt par cas. Attribution unique/400gold et champs stables conservés ; tableaux V1235 hérités exactement, non recomputés. snapshot_unchanged reste une comparaison rapportée par la sonde, sans couples de snapshots par refus pour la reproduire.

Binaire historique6043136 octets/SHA `3b8eb3abde50f1190def29204d6bc8d734ade0ec1412d9f267c2941d06c5b73f`, BUILD/RUN0 hérités, chemins inertes. Sources documentaires du26octobre distinctes du présent contrôle. Aucun nouveau build, jeu, décodage natif, GPU, REA, probe ou capture.

## 5. Écarts et inconnues

Applicabilité des formules, vitesse, rayon, transition, ciblage, état, ordre et bornes restent ouverts. Une cible à100 ne définit pas le rayon natif. Sans passif activé, les offsets119/120/121 ne prouvent pas son expiration. Persistence, icône et preloads ne qualifient pas création, attache, transformation, sélection, animation ou rendu. Inconnues et consommateurs enregistrés conservés ; stockage et binaires historiques non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : icathian-surprise-applicable-source-and-resource ; authoritative-postmortem-movement-explosion-and-credit ; postmortem-resource-animation-render-lifecycle. Objectif, prérequis, critères et conditions de reprise précisés pour chacune ; aucune correction produit implicite.

Prochain lot : CH-Leblanc-PASSIF-PRESENTATION-VFX, reçu V591 et identité dans next_lot.json. Reprendre sur source, mapping, appel, événement ou dérive précise ; pas de nouveau recensement global ou replay inchangé. Aucun gain chiffré d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_kogmaw_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations/journals, result.json et reçus de publication. Sept rubriques et publication contrôlées séparément. Scripts de collecte/relecture, vérifications d’identité et préparation documentaire sont les seuls ajouts préparatoires.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2351 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation restent ouverts.
