# Karthus — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1358 ; `AUD-SYS-01.2-02-KARTHUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Karthus-PASSIF-PRESENTATION-VFX` ; `OLF-ae42e710-0790-569a-8391-bbdeb76d3cfd`. Relier les déclarations applicables aux consommateurs courants et décrire les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète demeure ouverte.

Audit : terminé pour ce périmètre. Implémentation : état spirituel non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/karthus-passive-death_defied-links-v584.json`, copie E immuable référencée dans initial_scope.json : 1028232 octets, SHA-256 `79e51616d286e7e5a43e6ad19f44c2fae734423322becb90de5899e6fb5d225e`. V584 conserve 27 identités et rôles, référence LoL4.20/EUW/en_GB. Les chemins D restent des données, sans accès direct. V1229 source64/64, consommateurs67/67 et intégration40/40 sont hérités, non réexécutés.

Huit Lua structurels, sept initialisations et 29 affectations. CharScript56 est vide. Buff217 déclare Karthus_Passive.dds, « Death Defied Buff », persistence et NonDispellable ; ces flags ne constituent pas un cycle de vie exécuté. Trois Q post-mortem222 ont cinq flags identiques, Wall161 trois, Defile317 sept dont SpellToggleSlot3.0. FallenOne398 reste limité par NEWTABLEpc12 : limite du lecteur, pas corruption. Aucun AutoBuff reconnu dans ces huit vues ne prouve une absence globale d’effet.

Passive1LuaName conserve « Death Defied », description4211 liée ; texte1823 décrit les sorts gratuits pendant sept secondes après dégâts létaux. La clé game_buff_tooltip_Defile reste sans correspondance, distincte de KarthusDefile. Cinq candidats absents et le DDF sélectionné absent sont des observations historiques bornées, sans nouvelle recherche. Mana1 absent dans sept métadonnées de sorts ne vaut pas gratuité. NightmareBot/Lich_Defied et les variantes normales gardent des rôles distincts.

Huit preloads, 4064 octets et 55 références : avatar, distorsion, explosion, fade, Defile, sorts alternatifs et restauration des sorts vivants ; root est une référence BBPreloadSpell, pas une immobilisation démontrée. Captures E536170/713614 vérifiées ; testcube et NightmareBot ne sont pas promus en comportement normal. Une DDS2176 octets,64×64/DXT1/mipbrut0, membre0.0.0.235 : en-tête hérité, ni sélection effective ni pixels actuels. Six lignes de locale et neuf références communautaires secondaires conservées.

## 3. Consommateurs réels

Quinze entrées complètes :14 Rust et death_times_map10.json.35 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `champion_kills.rs:26` ; `champion_kills.rs:32` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `lifecycle.rs:33` ; `lifecycle.rs:6` ; `lifecycle.rs:24` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `attacks.rs:103` ; `lib.rs:603` ; `damage.rs:115` ; `damage.rs:111` ; `damage.rs:136` ; `damage.rs:130` ; `lifecycle.rs:76` ; `lifecycle.rs:83` ; `regeneration.rs:36` ; `spells.rs:120` ; `progression.rs:164` ; `animation.rs:792` ; `animation.rs:790` ; `attack_animation.rs:161` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, fichiers animation/attack_animation/projected_live dans `crates/client/src/`, table dans `data/4.20/`. La commande publique refuse un champion mort avant dispatch ; sorts directs et au sol ont leurs propres gardes, puis refusent Karthus vivant comme non implémenté. Aucun état spirituel établi dans ces corps.

Les dégâts létaux effacent les effets et actions, créent immédiatement le délai ordinaire, annulent la présentation d’attaque et attribuent la récompense générique. La régénération ne vise que les vivants. Réapparition : restauration des ressources et nettoyage génériques. Le JSON1014 octets donne16s au niveau1 ; le lecteur borne les niveaux1..18, convertit à30Hz et laisse la variation de fin de partie non qualifiée. Ce délai n’est pas la durée du passif.

Le client sélectionne death lorsque les PV sont non positifs, après la priorité idle de cérémonie Nexus ; la lecture dépend du rôle présent. Les attaques sont interrompues pour un acteur mort. Cela ne fournit ni sorts d’esprit ni effet passif. La projection inspectée cible Annie. Recherche bornée Karthus/DeathDefied : zéro occurrence dans ces15 textes, sans absence globale déduite.21 comparaisons sélectionnées et85 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : source, acquis, refus et lacunes précis reliés sans promouvoir métadonnées ou animation ordinaire en Death Defied. Observé :115/115 contrôles documentaires et105/105 de cohérence séparée du même agent, sur témoins sauvegardés. Aucune relecture indépendante ou validation humaine.

Deux cas V584 hérités : Karthus victime/Annie attaquante,516HP puis666HP avec Ruby1028 ;31 impacts, deux morts ordinaires,164 refus dont110 en état mort,960ticks observés et deux réapparitions après480ticks. Aux offsets0/1/209/210/211, quatre Cast, quatre CastAt, Move/Attack/Stop sont refusés. Mana inchangé sous refus ne démontre pas des sorts gratuits acceptés. Sans état spirituel initial, ces observations ne qualifient pas son expiration. Déplacement après réapparition et récompenses ordinaires restent des contrôles distincts.

Binaire historique6031872 octets/SHA `f527d4c1a50cc57602770e26876eb94c52cde364f052ca3a7913d8d3cd1b4a45`, BUILD/RUN0 conservés comme données ; aucun binaire rouvert. Dates documentaires V584 et contrôle actuel distincts. Anciens refus préparatoires du finisseur et corrections de schéma/contrat V1229 conservés. Aucun nouveau build, jeu, décodage natif, GPU, REA ou probe.

## 5. Écarts et inconnues

Transition, bornes temporelles, canalisations, toggle, ciblage, coûts, cooldowns, ordre, attribution et articulation avec réapparition restent ouverts. Recette, création, sélection effective, pose, animation et rendu du passif non qualifiés. Les flags persistence et l’icône ne résolvent pas ces règles. V564 et inconnues enregistrées conservés ; anciens stockages Karma/Jinx/Jax inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses précises de la tâche existante dans corrections_and_restart.json : death-defied-visual-applicability-source ; authoritative-spirit-transition-and-cast-event ; spirit-resource-animation-render-lifecycle. Chacune a objectif, prérequis, critères et conditions de reprise. Aucune correction produit implicite.

Prochain lot : CH-Kassadin-PASSIF-PRESENTATION-VFX, reçu V585 et identité dans next_lot.json. Reprendre sur source, appel, événement ou dérive précise ; pas de nouveau recensement global ou replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_karthus_passive_vfx_20261105/`, notamment evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2345 entrées sales groupées conservées. Publication : un nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
