# SYS-01.2-02 — Trundle : King's Tribute et consommateurs VFX, V1411

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TRUNDLE-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Trundle-PASSIF-PRESENTATION-VFX`, `OLF-3813e341-c0ec-5ae4-b324-64b915f6345b` : relier les sources retenues, le soin existant et les consommateurs de présentation. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues restent dans initial_scope.json. V533/V534/V535/V641 et HUD V1284 sont conservés. QWER, rendu complet et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/trundle-existing-routes-refinement-v641.json`, 646015 octets, SHA `cbc568fa69ef5cdabade0939efa39d1801a50835931087b3d7c5673c561fd2b9`.

Le reçu V641 ne contient pas de membre native_metadata : l’adaptateur de couverture indiquait no_mapped_lua_view. Les données qualifiées par HUD V1284 sont réutilisées depuis sa capture exacte de l’inspection V641 : 465109 octets, SHA `9e500954f9b96790ce307a96e3126ba0368d6b628ad1a006cd154a23279bb6e3`. Aucun accès F/OpenLeague-work ou natif renouvelé.

Cinq ressources natives sélectionnées : deux INIBIN, deux Lua et font. Définition : TrundleDiseaseOverseer, Trundle_Passive.dds ; Passive1Desc/PARType absents. Les niveaux 1/4/7 restent des métadonnées. Overseer382 : neuf globals littéraux, Trundle_W.dds, persistance/non-dissipation ; CharScript56 vide. Les deux chunks sont consommés sans prototype enfant ni champ AutoBuff reconnu. Aucune recette ou absence d’effet n’en découle.

Buff INIBIN54 : uniquement DynamicTooltip. Bindings font 2796/4291/4467 : soin de f2 % des PV maximum de l’ennemi mort à proximité, description et nom King's Tribute. Producteur natif f2 inconnu. Miroir courant vérifié par identité ; aucune nouvelle analyse des lignes.

Les deux DDS HUD, Trundle_Passive et Trundle_W, sont relus dans E : chacun 2176 octets, 64×64 DXT1, compteur de mips brut0, contenus distincts. SHA `afc957622e845311939379f9d8057dbeababfe17ab503bd608a9dcb157c3e84e` et `354fe3b6c9466731b09ba844825705739eafb359cff12d674d33ec0add4f2c90`. Membership historique conservé. Ce sont des icônes, sans qualification de textures d’effets. **Le lot des cinq ressources ne fournit pas un inventaire preload/Troy.** Provenance Mana antérieure conservée sans nouvelle attribution communautaire.

## 3. Consommateurs réels

Dix fichiers actuels, dont huit Rust et deux lecteurs Python ; 17 ancres vérifiées. Sept sources/routes et 27 contextes hérités inchangés ; 14 entrées communes VFX et deux liens d’animation ordinaire concordants.

damage.rs:135 et world.rs:401 appellent trundle_passive_damage_death. Le récepteur filtre victimes/bénéficiaires, calcule maximum victime × ratio local, puis appelle heal. Table reconstruite 2/3/4/5/6 %, rayon local1000 ; aucun récepteur équivalent recréé.

healing.rs applique les multiplicateurs reçus, borne aux PV maximum et retourne requested/restored. Le récepteur ne conserve pas ce résultat dans un événement de présentation dédié dans le corps inspecté. Le chemin générique Snapshot/PV/HUD reste hérité de V1284 ; il ne prouve aucun effet visuel observé.

annie_r.rs:82–89 met la vie de Tibbers à zéro lors d’expiration/suppression du propriétaire, puis nettoie et continue, sans appel au récepteur dans ce bloc. Lecture statique uniquement. La recherche antérieure dans onze fichiers client est réutilisée après garde d’identité ; recherche fraîche bornée dans projected_live.rs sans liaison nommée. Mécanismes communs et animations ordinaires ne qualifient pas un producteur spécifique de King's Tribute.

## 4. Attendu, observé et contrôles

Attendu : conserver le soin partiel, identifier sa liaison à la présentation et documenter les lacunes. Observé : chemin de soin existant et porteur générique de PV ; recette, déclenchement et rendu spécifiques non établis.

29/29 contrôles documentaires et 43/43 de cohérence séparée du même agent. HUD78/78 et65/65 hérités sans réexécution. Neuf tests Trundle parmi 37 fixtures V534, leur commande et leur portée sont conservés : cas nominal de décès, frontières de rayon, exclusions, clamp/Ignite, bénéficiaires et ordre local. Ni les tests ni les 1158 entrées ne sont recontrôlés ou rejoués aujourd’hui. Binaire historique 787789824 octets, SHA `8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97`, identité inerte.

Refus de heal pour fin de partie, montant invalide, source/cible inconnue ou cible morte relevés statiquement ; non exécutés ici. Ancienne SyntaxError HUD conservée : différence exacte d’une parenthèse revérifiée entre scripts original/corrigé, aucun prédicat changé. Une hypothèse de clé DDS erronée lors du repérage actuel est consignée dans root_context_note.json ; aucun producteur actuel échoué.

## 5. Écarts et inconnues

Un commentaire de trundle_passive.rs présente le rayon1000 comme natif ; sa provenance historique reste non qualifiée. Cet écart documentaire ne modifie pas la politique locale.

Restent ouverts : f2, proximité/catégories historiques, expirations, ordre, présentation attendue, ressources/variantes, attache, transport et pixels. **Présence ou absence d’un effet dédié inconnue.** Requested et restored peuvent différer : aucun besoin d’événement ni règle de déclenchement visuel n’est inventé. Aucun nouveau jeu/build, décodage natif, REA, GPU, audio, réseau ou rendu ; aucune acceptation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses : POLICY-01 qualifie f2/rayon/provenance et le commentaire ; LIFECYCLE-01 conserve le récepteur tout en traitant exceptions/ordre ; NETWORK qualifie les seules données nécessaires ; VFX qualifie la présentation attendue et son consommateur. Chaque clause donne prérequis, critères de fin et condition de reprise. Réutiliser Snapshot/PV et acquis HUD lorsqu’ils suffisent.

Reprendre sur nouvelle source/capture/callsite ou dérive ; correction produit soumise à autorisation distincte. next_lot.json vise Tryndamere : consulter ses audits et V537 avant toute nouvelle association.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_trundle_passive_vfx_20261106` : projections, captures retenues, fenêtres actuelles, identités, corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF, avec sauvegardes exactes et sept registres protégés.

Une unité de liaison close ; zéro tâche VFX, fonctionnalité, inconnue, acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
