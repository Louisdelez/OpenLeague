# SYS-01.2-02 — Vladimir : Crimson Pact et consommateurs VFX, V1422

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VLADIMIR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Vladimir-PASSIF-PRESENTATION-VFX`, `OLF-3edeae70-2f67-524c-a240-9f01b288fb2e` : relier les conversions PV/AP, le marqueur et les dépendances à leurs consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues préservés dans initial_scope.json. V545 et HUD V1295 sont réutilisés. La clôture de cette liaison ne termine ni les conversions, ni QWER, ni le goal.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/vladimir-passive-conversion-links-v545.json`, 458118 octets, SHA `b08147763be77aa64bbce1b7c3d60b83344bdfbe82639696e3f92ebc0d950af4`, UTC documentaire 2026-10-25T18:09:45.799776+00:00. Copies retenues dans E ; aucun nouvel accès D ou F/OpenLeague-work.

Sept ressources primaires : deux INIBIN, deux Lua, deux preloads et font. Définition 3474 octets, SHA `d3e3d3bdc05cc93425fe41f0839e73fbb4a17f7da2894b4a32636d0e54cfefcd`. Passive1 absent ; nom et icône VladimirBloodGorged/Vladimir_BloodGorged.dds. BaseMP numérique0 et MPPerLevel chaîne"0" restent distincts. Le texte Ryze, AP30/45/60 et niveaux1/6/16 ne sont pas adoptés comme règles.

Deux chunks hérités, entièrement lus antérieurement : CharScript56 vide et BloodGorged224, quatre globals littéraux, zéro prototype enfant. BuffName, BuffTextureName, PersistsThroughDeath et NonDispellable ne qualifient ni serveur ni lifecycle. Aucun AutoBuff reconnu dans ces deux vues ; aucune absence globale d’effet déduite.

Font4481/4305/2905 :40PV bonus donnent1AP,1AP donne1,4PV bonus, sans cumul avec lui-même. f1/f2, bases d’entrée, ordre, arrondis et multiplicateurs restent inconnus. Miroir vérifié par identité, sans nouvelle lecture sémantique complète.

Preloads BloodGorged101/SHA `97f05d9b7286e978f3acc710942584bfa8095f904af80a398b31c8ea77e49c59` et Char228/SHA `562bb231067a6eb48c1d17ba25a68dfaee2e9251ae9f738ed0228a2399241868` :329octets d’identités ; texte brut et références typées non reconstitués dans les copies sélectionnées. Aucune création de particule déduite.

Deux DDS Info et Spells/Icons2D relus dans E :2872octets chacun,64×64/DXT1,mips brut7, même SHA `77b487be32f7a92ee47630c378348d1a9d4b395c116e39e6a223d8d9f5d94d7a`. Membership hérité core0.0.1.7, membres0.0.0.25. Deux noms/un contenu ne prouvent ni priorité provider ni pixels. Provenances locales exactes conservées ; source_sha256 du catalogue de ressource distinct de l’INIBIN natif.

## 3. Consommateurs réels

Sept fichiers actuels, cinq Rust/deux lecteurs Python ;16ancres. Six sources/frontières et27contextes concordants ;14entrées VFX communes et deux animations ordinaires inchangées.

join→Buy/Sell→shop::bonuses→stats→refresh_item_caps produit les statistiques ordinaires. shop.rs215 additionne PV/AP séparément ; progression.rs87 applique le multiplicateur d’autel à l’AP des objets ; refresh_item_caps borne les capacités. passive_gold.rs16 finance le scénario. Aucun producteur Crimson Pact nommé dans les cinq préfixes Rust examinés, conclusion bornée.

Le contrôle HUD générique déjà qualifié est réutilisé après garde des fichiers : health/max_health et HPStat existent, ressource locale="None" sans barre de mana. Aucune liaison f1/f2 ou présentation spécifique qualifiée. Owner, projection et animations génériques ne sont pas un effet Crimson Pact.

## 4. Attendu, observé et contrôles

Attendu : source exacte, consommateur ou manque borné, refus et reprise. Observé : liaison établie, conversions et rendu spécifiques non qualifiés. **31/31 contrôles documentaires et49/49 de cohérence séparée du même agent.** HUD114/114 corrigés et76/76 hérités.

Quatre cas archivés L1 : Vladimir puis Ahri, ordres1052→1028 et1028→1052. Les144calculs antérieurs sont réutilisés, sans les recalculer. Nouvelle relecture de32témoins bruts : initial, premier achat, financement, deux objets, première/dernière stabilité, deux ventes. Les120indices de stabilité2401–2430 sont relus ;9720ticks simulés ne sont pas9720frames archivées.

Vladimir observe692,7999877929688PV/20AP, contre prédiction textuelle non récursive720,7999877929688PV/23,75AP :28PV et3,75AP supplémentaires absents. Ahri observe664,4000244140625PV/20AP, sans lui attribuer la règle Vladimir. Les témoins portent zéro supplément et restaurent les capacités initiales après vente. Cette absence stable ne valide pas la politique non récursive.

Six cases d’inventaire vérifiées. Or825, premier achat435 ou400 ; deuxième achat refusé puis financement public8 aux2250/2400, sans injection. Solde6 après achats et591 après ventes. Vingt refus hérités : quatre commandes en groupe puis insuffisance d’or par cas, sans vingt paires brutes individuelles. Tous casL1, sans sort, mort ou progression XP.

Ancien RUN242299octets et1158entrées non rouverts. Binaire6005760octets/SHA `6257760d18d26dfbf10447f89b692f5ff34864220a3f6465b88248714d51f388` : identité inerte, aucun rejeu. Aucun nouveau build, jeu, décodage natif, REA, GPU ou réseau.

Ancienne qualification110/114→114/114 revérifiée : seuls indices71/83/95/107 corrigeaient cinq cases attendues en six ;110autres contrôles et autres champs exacts. Échec historique de descripteur F passive_gold_rules et origine E conservés. Six productions actuelles réussies ; deux erreurs root de consultation/préparation conservées, sans échec de producteur.

## 5. Écarts et inconnues

AP/PV, sources de bonus, ordre/autels, arrondis, non-récursivité, f1/f2, niveaux, mort, audiences et restauration restent ouverts. **Le besoin de présentation et le rendu spécifiques restent non qualifiés.** Une icône ou un marqueur persistant ne prouve pas un effet ; son absence dans deux chunks ne prouve pas son inexistence. Aucune acceptation indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json définit quatre clauses POLICY/CONVERSION/NETWORK/VFX : politique et besoin visuel, calcul réel et réversibilité, transport utile, puis consommateur visuel applicable. Préconditions, critères et reprises précis. STATE-REVERSAL et HUD-BINDINGS existants sont préservés ; aucun nouveau statut ou effet artificiel imposé.

Reprendre uniquement sur nouvelle preuve/capture/callsite ou dérive pertinente ; implémentation sous autorisation distincte. next_lot.json vise Volibear : consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_vladimir_passive_vfx_20261106` : sources retenues, fenêtres,32témoins, qualification historique, corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF, sauvegardes exactes et sept registres protégés.

Une unité de liaison close ; zéro tâche VFX, fonctionnalité, inconnue, acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
