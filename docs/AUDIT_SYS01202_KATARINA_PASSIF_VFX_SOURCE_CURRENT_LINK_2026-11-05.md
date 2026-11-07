# Katarina — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1360 ; `AUD-SYS-01.2-02-KATARINA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Katarina-PASSIF-PRESENTATION-VFX` ; `OLF-d7d07d52-b3a9-587c-b218-3bee432c54a1`. Relier les déclarations applicables aux consommateurs courants et préciser les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète demeure ouverte.

Audit : terminé pour ce périmètre. Implémentation : Voracité non établie dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/katarina-passive-voracity-links-v586.json`, copie E immuable référencée dans initial_scope.json : 897662 octets, SHA-256 `e69699b790793c192d1f89077721a9720bfc5638cb609b9a7a1ce70e996a25b6`. Douze identités et rôles ; référence LoL4.20/EUW/en_GB. Les chemins D restent des données, sans accès direct. V1231 source69/69, consommateurs67/67 et intégration40/40 restent historiques.

Deux Lua structurels, deux initialisations et sept affectations. CharScript56 vide ; KatarinaPassive322 déclare son nom, Katarina_Voracity.dds, flags de sorts, persistence et NonDispellable. Aucun AutoBuff reconnu ne prouve une absence globale d’effet. Aucun callback serveur exécuté.

Voracity déclaré par le personnage n’est pas automatiquement KatarinaPassive. Description4213 liée : éliminations/assistances réduisent tous les délais de15s ; buff2922 : Death Lotus réduit de10s et sorts de base rafraîchis. Priorité historique non prouvée : conserver le conflit. Deux bindings MaliceAndSpite sans correspondance, trois candidats absents et28 lignes DDF dont coefficients AD5/3 ne résolvent pas le remboursement. R90/60/45 et rangs supplémentaires restent distincts de la politique passive.

Deux preloads,277 octets/trois références : katarinapassive et katarina_spell_refresh_indicator.troy sont déclarés, pas activés par ces preuves. Captures E443795/628713 vérifiées. Deux DDS2872 octets identiques,64×64/DXT1/mip7, membres116 ; sélection effective et pixels non vérifiés ici. Trois chaînes de locale et sept références communautaires secondaires conservées.

Contexte complémentaire existant V671 : `docs/reference_requirement_trace_sources/Katarina-passive-audio-chain-v671.json`,7941 octets/SHA `e980512a1df285143e0a644d647b388a1f427b75c47b7eb3629456e296dc3a0b`, et rapport audio conservé avec identité. Six liens audio relient preload, particule, événement3296454057 et quatre médias déjà décodés. Ces disponibilités, les11 contrôles/cinq refus anciens et leurs limites sont hérités ; banques, WAV, décodeur, observations privées et bases non rouverts. Aucun nouvel audit AUDIO ou test d’écoute clôturé.

## 3. Consommateurs réels

Dix-neuf entrées complètes :17 Rust et deux JSON locaux,35 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `champion_kills.rs:26` ; `champion_kills.rs:32` ; `champion_kills.rs:19` ; `cooldown.rs:11` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `passive_gold.rs:16` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `damage.rs:136` ; `champion_kills.rs:29` ; `champion_kills.rs:34` ; `ezreal_q.rs:190` ; `ezreal_q.rs:243` ; `ezreal_q.rs:225` ; `lifecycle.rs:83` ; `projected_live.rs:168` ; `progression.rs:164` ; `audio_release.rs:5` ; `audio_release.rs:16` ; `map_audio_requests.rs:132` ; `map_audio_requests.rs:89`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live/map_audio_requests dans `crates/client/src/`, règles dans `data/4.20/`. Le chemin létal appelle le crédit générique ; champion_kills conserve contributions, éliminations, assistances, or, XP et événement public. Sa fenêtre15s ne constitue pas le remboursement15s du texte de Voracité. Casts/rangs Katarina refusés dans les corps inspectés.

Le CDR générique est appliqué lors du lancement, plafond0.4. Le remboursement EzrealQ existe, avec garde propriétaire/équipe/session chez ses appelants ; ce n’est pas Voracité. Régénération, or ambiant, attaques et nettoyage restent des acquis distincts. Les deux JSON2457/419 octets indiquent leurs limites de reconstruction serveur.

La projection inspectée vise Annie. Le filtre audio réel exige Audio-Emitter_ et exclut donc la particule de rafraîchissement ; son lookup renvoie « unqualified ambient particle » pour les noms non admis. Hachage et nom Stop candidat ne créent pas un effet. Ces corps actuels sont inspectés statiquement, sans rejouer la sonde V671.

Recherche bornée Katarina/Voracity/refresh_indicator : zéro occurrence dans ces19 textes, sans absence globale déduite.24 comparaisons sélectionnées et118 contextuelles chevauchantes concordent ;14 mécanismes VFX et deux animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis, refus et limites sans résoudre artificiellement le conflit natif. Observé :102/102 contrôles documentaires et106/106 de cohérence séparée du même agent, sur témoins sauvegardés. Aucune relecture indépendante ou validation humaine.

Quatre cas V586 hérités :45 impacts MELEE avec témoins Windup.release,112 refus inchangés,720 ticks finaux plus451 ticks d’attente expirée et quatre événements d’élimination ordinaires. Deux cas indépendants créditent400 chacun ; assistance après113 ticks :86.875 ; contribution expirée après612 ticks :0. Ils ne représentent pas une série de primes. Tous les rangs/délais Katarina restent zéro : aucun délai armé, donc aucun montant ni échec isolé du remboursement mesuré. Codex10%CDR ne crée pas un délai.

Premier BUILD101 de sonde privée : champ releases incorrect, corrigé en release ; BUILD/RUN0 qualifiés et preuves initiales conservés, moteur inchangé. Binaire historique6284800 octets/SHA `60bc0f173d205ffe555dc7f21a19beb3a63f21ac591cea92249da055b164658f`, inerte ici. Dates documentaires et contrôle actuel distincts ; anciens CHECK1/stockage/Jax/V564 conservés par pointeur. Aucun nouveau build, jeu, décodage natif, GPU, REA, sonde ou audio joué.

## 5. Écarts et inconnues

Alias, priorité des textes, crédit éligible, montant, ordre, arrondi, borne, relances, cycle de vie et événement restent ouverts. Recette complète, création, sélection, attache, pose et rendu non qualifiés. Chaîne audio existante non équivalente à activation, sélection de médias, arrêt ou écoute ; aucun tirage uniforme inventé. Inconnues et V564 conservés ; binaires/stockages inertes, sans récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : voracity-alias-rule-and-visual-source ; qualified-credit-armed-cooldown-presentation-event ; refresh-indicator-resource-attachment-render. Objectifs, prérequis, critères et conditions précis. Aucune correction produit implicite.

Prochain lot : CH-Kayle-PASSIF-PRESENTATION-VFX, identité et reçu dans next_lot.json. Reprise sur source, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain temporel chiffré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_katarina_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2347 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
