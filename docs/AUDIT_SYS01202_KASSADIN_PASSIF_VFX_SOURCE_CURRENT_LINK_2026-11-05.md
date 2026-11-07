# Kassadin — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1359 ; `AUD-SYS-01.2-02-KASSADIN-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Kassadin-PASSIF-PRESENTATION-VFX` ; `OLF-92de781e-3eff-52fe-833d-012c093d6f18`. Relier les déclarations applicables aux consommateurs courants et décrire les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète demeure ouverte.

Audit : terminé pour ce périmètre. Implémentation : règles spécifiques non établies dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/kassadin-passive-void_stone-links-v585.json`, copie E immuable référencée dans initial_scope.json : 919473 octets, SHA-256 `7c3bd397f271c6d8cd7a7053e46f01d85664161d0859ab468a1a4d8064634fa6`. Treize identités et rôles, référence LoL4.20/EUW/en_GB. Les chemins D restent des données, sans accès direct. V1230 source84/84, consommateurs74/74 et intégration40/40 restent historiques.

Cinq Lua structurels, cinq initialisations et19 affectations, sans limite littérale. CharScript109 contient Teemo_EagleEye.dds : il n’est pas vide comme le candidat communautaire. VoidStone212 lie Kassadin_VoidStone.dds, VoidStone, persistence et NonDispellable. Empowered162 lie Voidwalker_Netherburn/AS ; NullLance et QCancelChannels313 sont identiques, Averdrian_AstralBeam/NullLance et AutoBuffActivateEffect=Null_Lance_buf.troy. Deux déclarations AutoBuff dans ce contexte Q, aucune dans VoidStone ; os absent ne signifie pas attache absente. Aucun callback serveur exécuté.

Le texte2909 et la description4212 liée donnent15% de réduction magique et absence de collision d’unités. L’AS @f1@ et le bouclier magique NullLance sont distincts. MR30, rayon de navigation35 et gameplay absent restent séparés. Quatre candidats absents et DDF sélectionné absent sont des observations historiques bornées, sans nouvelle recherche.

Trois preloads913 octets/12 références exactes, dont voidstoneattackspeedboost et kassadinqcancelchannels en minuscules. Q shieldon, turntransparent et R vanish ne sont pas des recettes ou activations prouvées. Captures E416696/632728 vérifiées. Quatre DDS4224 octets64×64/DXT5, trois contenus ; mips bruts0/0/1/0, membres40/25/25/25 conservés. Deux Netherburn identiques ne prouvent pas une priorité de chargement. Cinq lignes de locale et neuf références communautaires secondaires ; aucun pixel ou rendu frais.

## 3. Consommateurs réels

Dix-huit entrées complètes :17 Rust et collision_profiles.json.35 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `damage.rs:38` ; `penetration.rs:9` ; `annie.rs:45` ; `annie.rs:73` ; `lifesteal.rs:4` ; `attacks.rs:157` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `movement.rs:53` ; `ally_occupancy.rs:635` ; `collision.rs:17` ; `ally_occupancy.rs:281` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `damage.rs:45` ; `damage.rs:86` ; `damage.rs:101` ; `shields.rs:12` ; `shields.rs:47` ; `ally_occupancy.rs:85` ; `collision.rs:22` ; `collision.rs:29` ; `lifecycle.rs:83` ; `projected_live.rs:168` ; `progression.rs:164`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, profil dans `data/4.20/`. Les dégâts typés passent par pénétration/résistances, réduction Courage générique, puis boucliers généraux avant HP. Le multiplicateur magique inspecté utilise MR et reduction, sans règle VoidStone établie. Les boucliers courants ne portent pas un type de dégâts : ils ne qualifient pas le bouclier magique NullLance. Casts/rangs Kassadin restent refusés dans les branches inspectées.

Le profil Kassadin existe réellement : pathfinding35, selection120, gameplaynull. L’occupation alliée sélectionne les corps de même équipe et utilise le rayon de navigation ; aucune exemption Kassadin établie. Le défaut communautaire de corps65 n’est pas un rayon gameplay natif récupéré. La projection inspectée vise Annie. Régénération, attaques et nettoyage génériques conservés.

Recherche bornée : zéro occurrence Kassadin/VoidStone/NullLance dans les17 corps Rust ; deux occurrences attendues dans le JSON, ligne de données et provenance. Ce résultat ne démontre aucune absence globale.25 comparaisons sélectionnées/87 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis et lacunes sans confondre MR, bouclier Q, AS ou passage générique avec Void Stone. Observé :104/104 contrôles documentaires et102/102 de cohérence séparée du même agent sur témoins sauvegardés. Aucune relecture indépendante ou acceptation humaine.

V585 hérité : quatre cas Kassadin/Ahri, avec/sans Cloak1033 ; huit impacts AnnieQ magiques bruts80, huit physiques,44 refus et360ticks finaux. MR30/55 donnent61.5385/51.6129 après correction de régénération. Les comparaisons0.85 donnent52.3077/43.8710, illustrent les15% connus et ne prouvent pas tout l’ordre serveur natif. Cloak+25MR reste un contrôle distinct.

Quatre cas d’occupation Kassadin/Garen : alliés bloqués à65, ennemis traversés chez les deux. Pas de preuve spécifique du passif. Aucun bouclier, dégât vrai, AS, mort/réapparition, réseau ou rendu exercé par ces cas. Binaire historique6093824 octets/SHA `56706f2ff59760215179c816a06feec36419c55770f6c7023341f85060f26806`, BUILD/RUN0 conservés comme données, sans réouverture. Dates documentaires et contrôle actuel distincts.

Anciens échecs de casse preload et capture DDS conservés. Le reçu DDS initial erroné reste avec sa correction : trois lectures/deux captures conservées avant refus sur le troisième chemin, tentative suivante sans lecture ; préfixe réutilisé et total attendu corrigé5lectures/21120octets. Ancien CHECK incomplet sur NullLance et correction de compteur conservés par pointeur, sans relance. Aucun nouveau build, jeu, décodage natif, GPU, REA ou probe.

## 5. Écarts et inconnues

Catégories de dégâts/collision, ordre, arrondi, cumul, cycle de vie, événement et présentation restent ouverts. Applicabilité des effets, recette, création, sélection effective, attache, pose et rendu non qualifiés. Ne pas inventer un effet permanent pour compléter artificiellement la tâche. Inconnues et V564 conservés ; anciens stockages et binaires inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : void-stone-visual-applicability-source ; authoritative-magic-collision-state-event ; qualified-resource-render-lifecycle. Objectifs, prérequis, critères et conditions précis. Aucune correction produit implicite.

Prochain lot : CH-Katarina-PASSIF-PRESENTATION-VFX, identité et reçu dans next_lot.json. Reprendre sur source, appel, événement ou dérive précise ; pas de recensement global ou replay inchangé. Aucun gain temporel mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_kassadin_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2346 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
