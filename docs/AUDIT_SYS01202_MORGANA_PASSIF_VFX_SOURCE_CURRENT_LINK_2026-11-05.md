# Morgana — Soul Siphon : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1379 ; `AUD-SYS-01.2-02-MORGANA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Morgana-PASSIF-PRESENTATION-VFX` ; `OLF-60fff2b1-e59f-55ee-bb64-99d873aa1f51`. Audit de liaison borné terminé. Vol de vie ordinaire et API de soin acquis,production Spell Vamp Morgana non établie dans les corps examinés. Vérification documentaire fraîche, simulations historiques réutilisées, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts ; contrat/prérequis/NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Deux reçus distincts, copies E identiques : `F:/OpenLeague/docs/reference_requirement_trace_sources/morgana-passive-soul-siphon-links-v605.json`,2049558octets,SHA `dc1b5e98d64e7247652fc72af97985754ee1ff747fc9b4a42b220d812a3f42b6` ; `morgana-passive-spell-vamp-boundary-links-v555.json`,498698octets,SHA `37fce10b0f480eddbef84add087a1bc26f95bdd1b1ec29ec17530a9d1cad498d`. Référence LoL4.20.0.315/EUW/en_GB,catalogue4.20.1 distinct. Sept identités V555 incluses dans les28V605,tailles/hashes égaux,non35uniques ; deux Lua et valeurs sélectionnées anciennes concordent. Métadonnées et simulations antérieures restent séparées.

V605 :10Lua,trois initialisations/huit affectations,sept limites NEWTABLE non corruption. CharScript natif118 porte persistence/NonDispellable,non vide ; seul CharScript communautaire inspecté vide. EmpathizeAura215 utilise FallenAngel_Empathize.dds/Empathize/persistence/NonDispellable ; SoulShacklesOwner156 est contexteR. Aucun AutoBuff qualifié,non absence globale d’effets.1866 dit@f1@% Spell Vamp ;4236 décrit soin personnel sur dégâts de sorts. Ancien texte de régénération des alliés,mana40/60/80% et rangs null conservés,non politique adoptée. Valeurs sélectionnées Empathize INIBIN null,non zéro.

Neuf métadonnées de sorts,15références communautaires,18contextes NightmareBot exclus,huit absences candidates dont DDF. Aucun champ ddf_rows suppléé. QWER communautaires contiennent du code,non serveur original/Rust ; W commentaire pulse unique contre16timers,W275/natif280 etR600/natif625 conservés distincts. Sept preloads identifiés,2556octets,contenu non qualifié. Découverte attendue762704octets,SHA `056b4eb8ff2235f9f23a6c8730680f55f73a5bc715e0a859dae01a84594dd2b5`,absente des captures sélectionnées,du chemin E historique exact et des blobs de ce SHA dans l’ancien dossier HUD. Reprise précisément identifiée ; ancien F-work et D non consultés,aucune absence globale affirmée.

Trois DDS identiques4224octets,64×64/DXT5/mipbrut0 : EliseSpiderling/Info membre130,Morgana/Info40,Spells25. Alias de nom non priorité de lookup,rendu,pixels ou mécanique Elise. Ressource Mana : hashce2bcc… désigne le JSON communautaire,non INIBIN natifc99edc… ; caveat inchangé. Captures qualifiée1174262/probe1367847 vérifiées ;17entrées historiques,15pinnées/deux ultérieures,dont deuxEXE inertes et15payloads relus. HUD V1249 documentaire46/46/cohérence44/44 hérités. Aucun nouveau décodeur,font ou dépendances de build rouverts.

## 3. Consommateurs réels

16Rust complets,37ancres dans evidence_review.json,racine `F:/OpenLeague/`. Points : `crates/core/src/lifesteal.rs:4,17,20,22`, `healing.rs:9,16,39`, `spells.rs:101,120`, `progression.rs:68,164`, `annie.rs:45,73,87`, `crates/client/src/projected_live.rs:168`.

basic_attack_hit applique des dégâts physiques puis le vol de vie calculé sur post_mitigation,avant appel à heal. heal valide l’événement,applique les modificateurs reçus et plafonne aux PVmax. Ces points sont réutilisables,non producteur de Spell Vamp. Sorts/rangs Morgana refusés ; projected_live filtre Annie. Aucun hit Morgana/Empathize/SpellVamp/SoulSiphon dans les16Rust,absence bornée.17comparaisons sélectionnées recouvrent31fichiers F ; deux identités binaires séparées,hors31.14mécanismes communs/deux animations ordinaires concordent,non recette de soin.

## 4. Attendu et observé

Attendu : liens exacts,acquis/provenance/refus préservés,écarts et reprise vérifiables. Observé :64/64contrôles documentaires,117/117cohérence séparée du même agent,non pair indépendant. Sept opérations documentaires : six exit0,coherence01 exit1 initial conservé avec script/preuve/logs. Son contrôle de reprise comparait encore le hash du lot précédent ; corrigé depuis le pin Morgana,sources intactes.

V605 hérité : base/Tome20AP/Sceptre10AD8% ; AD55.46/55.46/65.46,AP0/20/0,vol de vie0/0/0.08. Neuf attaques sortantes,neuf physiques entrants,troisQAnnie entrants,540ticks d’attente,81refus,sixtrajets. Base/AP : résidus2.086e-6PV par attaque ; Sceptre :4.3925495PV observés contre4.3925514 attendus,vol de vie ordinaire. Neuf paires PV source conservées ; calcul historique soustrait médiane de régénération0.03805542/tick,conditionnel aux scénarios fixes et tolérance0.002. PV cibles immédiatement avant impact absents ; refus sans paires brutes complètes. Aucun sort Morgana accepté,donc déclencheur du passif non exercé.

V555,contexte distinct : Morgana sans/avec1053,puis Annie1053 ;12coups entrants,neuf attaques,41refus,90ticks après attaques. Soins supplémentaires0/4.10614/3.78937PV ; WAnnie sans soin supplémentaire,non compétence Morgana. Aucun cas ancien fusionné aux comptes V605,aucun nouveau calcul/replay. BUILD/RUN V6050 hérités,commandes JSON sauvegardées relues ; OBSpassed non reçu terminal d’inspection. Binaires V6056094848/SHA203e6f95… et V5556047744 inertes ; ancien dossier yasuo simple libellé. Aucun nouveau build,jeu,natifD,GPU,REA,probe ou réseau réel.

## 5. Écarts et inconnues

@f1@,niveaux,cumul,dégâts/cibles éligibles,modificateurs zone/périodiques,base et ordre du soin restent ouverts. Régénération alliée legacy et vol de vie objet non Soul Siphon. Contenu des préchargements,applicabilité VFX,provider/icône,recette/attache,rendu/audio et cycle de vie non qualifiés. Inconnues et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : native-spell-vamp-rate-levels-and-eligible-damage ; authoritative-spell-damage-healing-and-lifecycle ; SoulSiphon-presentation-applicability-resource-provenance-and-cleanup. Objectifs,prérequis,critères et reprise explicites ; correction produit distincte à autoriser.

Prochain candidat `CH-Nami-PASSIF-PRESENTATION-VFX` dans next_lot.json,avec recherche préalable d’audit existant. Reprendre sur entrée nommée,source,événement,appel,dérive ou test précis nouveau ; aucun gain chiffré revendiqué.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_morgana_passive_vfx_20261105/` : evidence_review.json,coherence_review.json,corrections_and_restart.json,journaux,result.json,reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2366 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal,Plan/UI/bases,registres,produit et assets inchangés ; fonctionnalité,tâche complète,parent,jeu et acceptation ouverts.
