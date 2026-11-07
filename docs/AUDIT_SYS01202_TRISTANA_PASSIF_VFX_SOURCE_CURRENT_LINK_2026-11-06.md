# SYS-01.2-02 — Tristana : Draw a Bead, sources et consommateurs VFX, V1410

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TRISTANA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Tristana-PASSIF-PRESENTATION-VFX`, `OLF-7e4a26ff-5086-5c18-a950-53b1fc430388` : relier les sources de Draw a Bead aux consommateurs actuels et déterminer les limites de sa présentation. Contrat VFX, prérequis de phase/lot, consommateurs enregistrés et inconnues conservés dans initial_scope.json. Le HUD V1283 est réutilisé ; QWER, présentation parente et goal restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/tristana-passive-draw-a-bead-links-v640.json`,3547996octets,SHA `e18481aefa95a517a449fb0268f2d6c014630d9f96a56f6dc2916f5e04409698`. Trente membres natifs/90associations,14INIBIN/11Lua/quatrepreloads/font hérités ; recherches DDF négatives bornées conservées. Aucun accès natif renouvelé.

Définition : nom littéral **Draw a Bead**, icône Tristana_DrawABead.dds, AttackRange chaîne550. Champs de progression manquants laissés inconnus. Chunk DrawABead317octets : sept globals, icône/nom/persistance/non-dissipation et TriggersSpellCasts=false. CharScript56vide. Onze chunks consommés sans prototype enfant ; quatre initialisations littérales,sept limites NEWTABLE,15globals. Cela n’établit aucun callback serveur.

Deux contextes AutoBuff/troischamps : ExplosiveShotDebuff a deux chaînes vides ; RocketJumpSlow déclare GLOBAL_SLOW.TROY. RapidFire contient rapidfire_buf.troy/weapon/RocketTristana dans les constantes,avec initialisation non qualifiée. Aucun de ces contextes ne fournit une recette VFX démontrée de Draw a Bead ni un mapping de skin/attache.

Quatre préchargements/1148octets/14références typées : neuf Particle,cinq Spell,zéro Character. Reconstruction CRLF depuis les textes retenus identique aux empreintes historiques. **DrawABead.preload189** référence detonatingshot_buf.troy et tristana_explosiveshot_unit_tar.troy,tous deux également présents dans DetonatingShot.preload375. Dépendance partagée ≠ activation ni alias. BusterShot116 et RocketJump468 conservent leurs contextes R/W.

Font1851 lie attaque/E/R à f1 ;4290 décrit la croissance avec le niveau. Valeurs,f1/Effect1 et cadence d’application non résolus ;aucune formule9parniveau supposée. Six bindings BuffData réutilisés après garde d’identité du miroir courant,sans reparcours sémantique de la font.

DDS propre au HUD :4224octets,64×64 DXT5,compteur de mips brut0,SHA `3aadf2f5989d4e0d91ab84194ea08b763d35a53c75e1b7eebbc9de0878997d0d`. Identité/header relus dans E,membership historique conservé ;aucune texture Troy ou preuve de pixels déduite. Provenance Mana communautaire distincte de l’INIBIN natif conservée.

## 3. Consommateurs réels

Onze entrées actuelles,dont neuf Rust,deux lecteurs Python et24ancres vérifiées. Dix frontières/source et29contextes hérités inchangés ;14entrées communes VFX etdeux liens d’animation ordinaire concordants.

combat.rs:25/36 et attacks.rs:155 utilisent directement définition.attack_range+rayon cible. world.rs:232 appelle collision::body_radius ;collision.rs:29–32 applique le repli local65 si rayon absent,40 si non positif. Aucun accroissement lié au niveau dans ces fenêtres. Aucun hit nommé Tristana/DrawABead dans les neuf Rust sélectionnés ;conclusion bornée.

Les mécanismes communs de ressources,projection,owner/attaches et animations ordinaires restent des liens génériques. Ils ne fournissent pas le producteur Draw a Bead,l’événement de création,une attache de squelette ou une comparaison de rendu. Les deux consommateurs HUD complémentaires restent hérités après garde des29contextes.

## 4. Attendu, observé et vérifications

Attendu historique qualitatif : croissance de portée avec niveau. Diagnostic archivé : Tristana définition550 aux18niveaux ;rangs0000,72Learn/144Cast refusés. Témoin Annie et278refus de commandes/10XP conservés. Phase rangs :36attributions XP par API serveur,zéro tick ;pas de progression naturelle ni de réseau qualifié.

Quatre scènes publiques héritées,niveaux1/18,distance550/650 :immobile avant windup à550 ;déplacement43.33203125 à650,dans les deux niveaux. Seuil615 calculé localement avec repli65 ;aucune frontière empirique exacte615 ou nécessité historique d’attaquer à650 supposée. 7640ticks,huit trajets etquatre lancements archivés ;aucun impact/pixel/E/R qualifié. Sommaires relus sans rejouer leur arithmétique complète.

Contrôles actuels32/32 ;cohérence séparée du même agent 42/42. HUD238/238 et116/116 hérités,sans réexécution. Anciens BUILD0/RUN101 sur unwrap du rayon absent puis diagnostic corrigé BUILD/RUN0 conservés ;deux identités EXE restent inertes. Correction rédactionnelle historique également conservée. Erreur de chemin contextuelle de cette reprise consignée dans root_context_note.json ;aucun échec de producteur actuel.

## 5. Écarts et limites

Progression numérique,f1/Effect1,rayons historiques,ordre/arrondis,portée effective partagée,transport et rendu restent ouverts. **L’existence d’un effet visuel dédié au passif reste inconnue.** Préchargements partagés,chaînes vides et constantes ne suffisent pas à conclure à sa présence ou à son absence. Aucun nouveau jeu/build,décodage natif,REA,GPU,audio,réseau ou rendu exécuté ;aucune revue indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses réutilisant SOURCE,SIMULATION,NETWORK etVFX :qualifier politique numérique/visuelle ;fournir portée effective par instance aux consommateurs ;transporter les valeurs/transitions ;qualifier la présentation réellement attendue et son consommateur. Chaque clause a prérequis,critère de fin et condition de reprise. Un effet absent de la référence ne doit pas être inventé. HUD-BINDINGS et CAST-RANGE existants restent préservés.

Reprendre sur nouvelle source/callsite,dérive ou scène qualifiable ;implémentation soumise à une autorisation distincte. next_lot.json vise Trundle :chercher ses audits existants avant toute acquisition supplémentaire.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_tristana_passive_vfx_20261106` :evidence_review,coherence_review,identités,font,journaux et corrections. Thresh est réutilisé via son reçu vérifié,sans seconde clôture. Publication limitée au présent rapport et aux ajouts CURRENT/HANDOFF,avec sauvegardes exactes et sept registres protégés.

Une unité documentaire de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
