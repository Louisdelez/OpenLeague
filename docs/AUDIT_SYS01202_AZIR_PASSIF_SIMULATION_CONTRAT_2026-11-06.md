# Azir — contrat connu de Shurima’s Legacy et écarts actuels

6 novembre 2026 · V1455 · AUD-SYS-01.2-02-AZIR-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Azir-PASSIF-SIMULATION-CONTRAT, OLF-42dbfd27-9da4-5809-95ac-c2c07c12424d, parent SYS-01.2-02. Décrire les branches connues CDR→AS et Disque solaire, leurs consommateurs et limites. **Audit borné terminé ; tâche complète et fonctionnalité ouvertes.** Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Prérequis SOURCE, phase et lot conservés sans satisfaction implicite.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct.

Le reçu docs/reference_requirement_trace_sources/azir-passive-cdr-attack-speed-sundisc-links-v559.json associait déjà ce contrat : 658239 octets, SHA 4c221c14dd3b9ed0c70c822f8963a7925f3148cdbe2c0bccc473250bd86f35b0. Rapport V559 et SOURCE V1185 réutilisés, avec publication, sous-reçus et résultat SOURCE SHA cb1e6f3c2420f448f4b99240d61e82f05250e68634c6ba11b8d9fcd5d001b3a4. Ses14contrôles restent antérieurs.

V559 sélectionnait23ressources natives ; SOURCE recense24identités, dont le CharScriptAzir racine supplémentaire de56octets. Ce chemin ne contredit pas l’absence de l’ancien sous-dossier Scripts interrogé ; aucun décodage supplémentaire.

Onze chunks intégralement parsés autrefois : trois vues littérales vides qualifiées et huit limites NEWTABLE. Ces huit projections restent inconnues, globals=null et raw globals={} conservés ; ni absence de globals ni corruption déduite. Les constantes ne deviennent pas des affectations/callbacks. Cinq preloads et six références communautaires gardent leurs rôles.

Quatre chaînes en_GB relues, lignes1697/1698/4160/4336 ; miroir2220957octets, SHA1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Lookup lexical, binding effectif et locale runtime distincts ; identité partagée du fichier seulement, aucun transfert du gameplay Ashe.

## 3. Branches et consommateurs

Seize branches dans contract_review.json : identité ; coefficient CDR ; plafond/ordre/arrondis ; objets/niveaux ; attaques ordinaires ; ruines ; activation ; canalisation/interruption ; création/propriétaire/stats ; combat ; désintégration ; recharge ; lifecycle/synchronisation ; présentation ; lecteur ; vérification historique.

Texte1697 :1,25%AS pour1%CDR ; f1 est le bonus AS courant affiché, pas un taux d’accumulation. SunDisc depuis ruine toutes les3minutes, désintégration sur1minute, exclusion des ruines de tourelles Nexus/inhibiteur ennemies. Ruines alliées/ennemies et disponibilité sont décrites par les autres chaînes. Durées écrites, sans chronométrage natif.

25ancres retrouvées : catalogue et24frontières génériques, aucune promue en producteur du passif.21entrées sélectionnées concordent avec V559/SOURCE :12Rust,7JSON,2lecteursPython.25fenêtres réutilisées après contrôle d’identité/lignes :20SOURCE et5communes.

CDR et AS sont agrégées séparément ; la cadence inspectée ne lit aucun terme CDR/Azir, mais croissance, AS d’objet et modificateurs nommés. Démoninateur minimal0,05, ticks arrondis, minimum12 : politiques locales, pas recette historique complète. Le projectile2600 de l’attaque ordinaire Azir ne représente ni soldats ni SunDisc.

Picker : ennemis vivants ; client : Attack/Move/sorts contextuels. Action et handlers inspectés sans trajet SunDisc qualifié. Map10 :27définitions/18structures, sans clé exacte AzirSunDisc ; enable_map10 ajoute Tibbers. spawn_unit exige une définition avant allocation d’ID. « unknown NPC definition » est lu, non nouvellement exécuté. Structures mortes, inhibiteur240s et spawn générique ne réalisent pas le Disque.

## 4. Attendu, observé et contrôles

Attendu : source, chemin courant, inconnue et correction par branche décrite. Observé :16branches,25fenêtres,25ancres,25identités ; **43/43 contrôles documentaires,44/44 cohérences du même agent**. Quatre producteurs journalisés réussis : bootstrap01,contract01,coherence01,documentation01.

V559 hérité : sans objet/Codex3108/Dague1042, cadences58/58/50ticks,18impacts,51refus. Codex10%CDR/30AP sans accélération observée ; AS Dague témoin positif distinct. Impacts deux ticks après lancement dans ces cas. Aucun clic de ruine ou SunDisc exercé ; refus de sort et AS d’objet ne qualifient pas le passif.

Ancien binaire inerte :6009856octets, SHA777af6cb004d4c46905d51a1b40bb6c0044735fb695c8d7f133ae54d3235225f. Aucun accès au payload, nouveau build/testRust/runtime/probe/VM Lua/D/F-work/EXE/REA/réseau/GUI/GPU/capture. Recherche SOURCE neuf chemins et1158entrées historiques non rejouées ; concordance sélectionnée distincte de provenance complète de compilation.

Un précontrôle root du gabarit documentaire a rejeté raw{} dans une f-string avant création du fichier ou lancement du job. Cause/fragment conservés dans root_documentation_preflight.json ; gabarit remplacé par chaînes ordinaires, sans changement de conclusion ou produit. Le candidat intégral rejeté n’a pas été sauvegardé.

## 5. Écarts et inconnues

Restent ouverts : f1/unités/plafond/ordre/arrondis/niveaux ; objets et attaques en cours ; ruines/commande autoritaire ; disponibilité/canalisation/interruption ; création/propriétaire/placement/stats finaux ; AI/attaques/crédit ; désintégration/destruction ; début/portée de recharge ; mort/reconnexion/multiplesAzir ; synchronisation et présentation.

Champs SunDisc bruts distincts des stats finales exécutées ; niveaux Azir absents et TowerClicker1/4/7 non transférés. Aucun asset globalement absent déduit du manque de producteur qualifié dans ces corps. Provenances des descripteurs conservées sans nouveau défaut de hash inventé.

Inconnue propre OLU-e163ff78-0ec7-5f6f-a6b4-8069f48267f2 et inconnue SOURCE OLU-eac5b3b2-6c9e-5d8d-a11b-83ec748e7c9b inchangées. Audit, implémentation, runtime et acceptation restent séparés.

## 6. Corrections et reprise

corrections_and_restart.json conserve les trois rôles SOURCE existants et propose neuf sous-objectifs COR-SYS-01.2-02-AZIR-LEGACY : CDR-POLICY,CDR-CONSUMER,RUIN-ACTIVATION,SUNDISC-SPAWN,SUNDISC-COMBAT,SUNDISC-LIFETIME,SUNDISC-COOLDOWN,STATE,VERIFICATION, suffixés-01. Chaque fiche précise objectif unique, tâche liée, entrées, travail, fin et reprise ; aucun registre modifié.

Reprendre sur autorité serveur, fournisseur, trace, callsite, dérive ou observation précise. Corrections produit sous autorisation adaptée. Vérifier séparément conversion effective et trajet ruine→création→combat→désintégration→réutilisation, refus sans mutation et provenance de build. Prochaine paire réelle : Blitzcrank SIMULATION-CONTRAT, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_azir_passive_simulation_contract_20261106 : contrat, branches, ancres, identités, cohérence, journaux et corrections. Projection existante122paires réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2441entrées groupées conservées. Même agent, sans acceptation indépendante/humaine. Une unité bornée close ; aucune tâche complète, inconnue ou fonctionnalité fermée.
