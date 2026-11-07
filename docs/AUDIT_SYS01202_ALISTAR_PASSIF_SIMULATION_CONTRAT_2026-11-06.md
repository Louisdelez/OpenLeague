# Alistar — branches connues de Trample et écarts de simulation

6 novembre 2026 · V1449 · AUD-SYS-01.2-02-ALISTAR-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Alistar-PASSIF-SIMULATION-CONTRAT, OLF-8af99190-251c-55ad-acb6-5ed203970f8e, parent SYS-01.2-02. Décrire les branches établies par les preuves conservées et leurs consommateurs actuels. **L’audit borné des déclarations connues et des écarts statiques est terminé ; la tâche complète reste ouverte.** Les politiques historiques inconnues, le gameplay, le réseau, la présentation et l’acceptation ne sont pas fermés. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

V552 associait déjà cette tâche : docs/FIDELITY_ALISTAR_PASSIVE_CAST_TRAMPLE_LINKS_V552.md, SHA 1581252946b1c5469b1593e82a194a695def573320a96a329fff7708121e4b8a. Reçu docs/reference_requirement_trace_sources/alistar-passive-cast-trample-links-v552.json, 496595 octets, SHA 3a29ec4ae56390affd872a54217244bb8816168a6511b176fa05d23f3498c8ef : huit sources natives, deux bindings, deux Lua littéraux, un preload et cinq références communautaires distinctes. Identités et décodages natifs hérités, non rejoués.

Alistar.inibin est identifié antérieurement : 2091 octets, SHA a28be95a739ed43258abc5a0d5c9c10f6746a647c8af6de2a1c74e480e2adae5. Le miroir en_GB courant est relu, 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Trois chaînes exactes aux lignes1791,2782,4152 ; identité native/mirroir héritée de la preuve commune du même fichier, sans réutiliser du gameplay Ahri. Locale effective en exécution inconnue.

## 3. Branches et consommateurs

contract_review.json décrit onze branches : identité/alias ; déclenchement après sort ; durée/rafraîchissement ; zone/cibles ; dégâts magiques par seconde ; double dégâts aux sbires ; traversée conditionnelle ; valeurs/progression ; propriétaire/cycle de vie/recap ; métadonnées/preload ; refus et contrôle historique.

Le texte Colossal Strength décrit une activation après chaque sort, la traversée des unités, des dégâts magiques par seconde sur les ennemis/bâtiments proches pendant trois secondes et le double contre les sbires. f1 est affiché comme total, f2 comme base, f3 comme contribution AP ; fournisseurs et formule restent inconnus. Le buff actif et la description du champion conservent leurs formulations distinctes.

Dix-neuf ancres enregistrées sont retrouvées dans neuf fichiers actuels, identiques aux entrées correspondantes de V552. Dix-huit fenêtres, dont treize communes réutilisées après égalité d’identité, relient commande, refus Learn/Cast/CastAt, dégâts, phases et régénération. Annie W reste un autre sort.

Les fenêtres movement.rs:37–80, ally_occupancy.rs:79–90 et635–688, collision.rs:1–32 distinguent vitesse, filtrage des alliés, occupation et rayons. La boucle réelle appelle advance_allied_motion ; son préfixe construit les corps et utilise pathfinding_radius. Cela ne prouve pas un passage conditionnel de Trample. Les rayons Alistar50/145/80 correspondent au cheminement/sélection/corps, pas à la portée du passif. Le cône d’Annie ne fournit pas non plus sa zone.

La recherche négative porte sur huit fenêtres nommées, dont seulement le préfixe de l’occupation. Aucun hook Alistar/Trample/Colossal nommé dans ces fenêtres ; aucune absence globale ni analyse complète du graphe d’appels revendiquée.

## 4. Attendu, observé et contrôles

Attendu : source, politique inconnue et consommateur ou manque précis pour chaque branche. Observé : onze branches uniques, dix-huit fenêtres, dix-neuf ancres et dix-huit identités courantes ; **43/43 contrôles documentaires et 30/30 cohérences du même agent**. Quatre opérations journalisées réussies.

V552 reste hérité : Alistar, dix-sept refus, aucun impact pendant91ticks817→908 ; Annie, sept refus, W805→813, un impact. Les dégâts nets52.9379272 après régénération sont distincts des52.9901581 avant celle du même tick. Ces deux cas et vingt-quatre refus ne testent ni un déclenchement Trample, ni sa durée, ni le phasing. Identité de l’ancien binaire inerte : 6002176 octets, SHA 08a61924bd3fd3330e7610eb99b835bf9e6063424497c370fa03ca995fd2faa3.

Aucun nouveau build, test Rust, runtime, réseau, Lua, accès D/F-work/EXE, REA, GPU ou capture. Les1158dépendances historiques ne sont pas recensées. Les anciens échecs de compilation/contrôle V552 restent dans leurs preuves historiques. Une lecture exploratoire root supposait un champ HUD pin ; le schéma réel diffère. La qualification commune du fichier de langue a été réutilisée explicitement, sans source manquante déduite.

## 5. Écarts et conclusions ouvertes

Restent inconnus : événement de cast admissible, début/refresh/expiry, fournisseurs f1/f2/f3, progression/AP, cadence/rayon/contact, cibles, classification des sbires, ordre des multiplicateurs, phasing allié/ennemi/PNJ/terrain, chevauchement à l’expiration et transitions de mort/reconnexion.

Deux chunks donnent sept globals littéraux sans prototype enfant ni serveur exécuté. Colossal Strength et Trample Buff restent distincts. PersistsThroughDeath, NonDispellable et IsDeathRecapSource ne prouvent pas une politique hôte. Passive1 absent ne reçoit aucun défaut ; anciens textes de réduction des tourelles/bonusPV et niveaux6/12/18 non adoptés.

Audit borné terminé ; implémentation Trample non établie dans les fenêtres ; runtime non exécuté ici ; acceptation humaine non donnée. Prérequis SOURCE, dépendances et inconnues conservés.

## 6. Corrections et reprise

corrections_and_restart.json propose six objectifs documentaires COR-SYS-01.2-02-ALISTAR-TRAMPLE : SEMANTICS-01, TRIGGER-01, DAMAGE-01, PHASING-01, LIFECYCLE-01 et VERIFICATION-01. Chaque fiche précise entrées, travail, fin et reprise. Aucun registre modifié ni correction produit implicite.

Reprendre sur source serveur, fournisseur, capture, callsite ou dérive précis. Les corrections fonctionnelles nécessitent une politique sourcée et une autorisation adaptée. Prochaine paire réelle : Amumu SIMULATION-CONTRAT dans next_lot.json, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_alistar_passive_simulation_contract_20261106 : contrat, onze branches, ancres, identités, journaux, corrections et reprise. Projection familiale existante réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2435entrées groupées conservées. Relecture du même agent, sans revue indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité, inconnue ou acceptation fermée.
