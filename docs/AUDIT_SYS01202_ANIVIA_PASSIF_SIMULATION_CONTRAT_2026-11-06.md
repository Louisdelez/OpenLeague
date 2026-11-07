# Anivia — branches connues de Rebirth et écarts de simulation

6 novembre 2026 · V1452 · AUD-SYS-01.2-02-ANIVIA-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Anivia-PASSIF-SIMULATION-CONTRAT, OLF-aadd13ec-9ca0-55ed-a6b3-021dde8c17ca, parent SYS-01.2-02. Décrire les branches établies par les preuves conservées et leurs consommateurs actuels. **L’audit borné des déclarations connues et des écarts statiques est terminé ; la tâche complète reste ouverte.** Les politiques historiques inconnues, gameplay, réseau, présentation et acceptation ne sont pas fermés. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

V558 associait déjà cette tâche : docs/FIDELITY_ANIVIA_PASSIVE_REBIRTH_LETHAL_EGG_LINKS_V558.md, SHA 656ad3df0347d8a7e0a624304d7918a52530578fee4d0e11c556e485ed43f13b. Reçu de 607016 octets, SHA 1a503ec0ee8993e16913ebf752815607a83d19b1fab9de337912c42bafb888f8 : dix-huit sources natives, quatre bindings, sept Lua et quatre preloads ; références communautaires distinctes. Identités/décodages natifs hérités, non rejoués.

L’audit SOURCE V1183, docs/AUDIT_SYS01202_ANIVIA_PASSIF_SOURCE_CONSUMER_2026-11-03.md, est réutilisé avec sa publication, son résultat SHA 4c1a19e24f75728dfc4485724de103a8f79c6575d7b81ea9bd4507d2ed115bd2 et sa revue de consommateurs épinglée. Ses 14 contrôles restent antérieurs. La fiche SOURCE demeure ouverte.

Le miroir en_GB courant est relu : 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Cinq chaînes exactes aux lignes 2515–2518 et 4156 ; identité native/mirroir héritée de la preuve commune du fichier. Aucune réutilisation du gameplay Ahri ; locale effective en exécution inconnue.

## 3. Branches et consommateurs

contract_review.json décrit dix branches : identité/disponibilité ; interception létale ; état œuf/vie/commandes ; défenses/niveaux ; survie et retour ; destruction de l’œuf ; recharge ; persistance/propriétaire ; métadonnées ; contrôle historique.

Le texte lié annonce : dégâts fatals → œuf et pleine vie ; réception de @f1@ armure/MR ; survie de six secondes → renaissance ; recharge de quatre minutes. Fournisseur f1, conditions et ordre restent inconnus. Les niveaux 1/4/7 d’AniviaEgg ne deviennent pas des rangs du passif Anivia.

Vingt-et-une ancres enregistrées sont retrouvées. Quatorze fichiers Rust sélectionnés concordent avec V558 et V1183. Vingt fenêtres sont réutilisées après vérification d’identité et de lignes : dix-sept du reçu SOURCE, trois de la revue commune récente. Elles relient attaques, dégâts, boucliers, crédit de mort, placement, ressources, refus et réapparition.

Le chemin courant ramène la vie à zéro, efface l’état transitoire puis programme base_death_ticks. advance_respawns attend l’échéance et restaure le champion à sa fontaine. Le crédit ordinaire et le soin de mort de Trundle restent distincts de Rebirth. Le refus des commandes à zéro vie et la régénération réservée aux vivants ne définissent pas un état œuf.

La recherche négative porte sur sept fenêtres nommées, sans replay de l’ancien recensement de 1149 fichiers Rust. Aucune absence globale ni preuve visuelle déduite.

## 4. Attendu, observé et contrôles

Attendu : une source, une politique inconnue et un consommateur ou manque précis par branche. Observé : dix branches, vingt fenêtres, vingt-et-une ancres et vingt-trois identités courantes ; **58/58 contrôles documentaires et 34/34 cohérences du même agent**. Quatre opérations journalisées réussies.

V558 reste hérité : Anivia meurt au tick 1321 après onze attaques, reste morte à 1501 et revient à la fontaine à 1801 ; Ahri, contrôle distinct, 1356/1536/1836 après douze attaques. 960 ticks postmortem et 32 refus conservés. Les 180 ticks de l’observation « six secondes » et les 480 ticks du retour ordinaire appartiennent au diagnostic local ; aucune activation, survie d’œuf ou recharge native n’y est qualifiée.

Ancien binaire identifié comme donnée inerte : 6078464 octets, SHA 05d5af32d8275cba390a06286787b10ab32b14934b39116efd7a946a2a1fda21. Aucun nouveau build, test Rust, runtime, réseau, Lua, accès D/F-work/EXE, REA, GPU ou capture. Les 1158 dépendances historiques ne sont pas recensées. La revue VFX 31 contrôles reste une preuve antérieure distincte.

## 5. Écarts et conclusions ouvertes

Restent inconnus : disponibilité initiale, interception létale/ordre des dégâts, transfert d’identité/vie/ressources/effets, ciblabilité/commandes, f1/niveaux/défenses, frontière des six secondes, destruction/interruption, vie au retour, crédit de mort, début/reset de recharge et reconnexion.

Sept chunks parsés : six vues littérales, 36 globals ; Rebirth.luaobj conserve sa limite NEWTABLE pc16. Sa vue limitée reste inconnue, pas une absence de globals établie. Priorité 8 et noms AnimationPlay/Reset ne prouvent ni callback ni animation. Les flags de persistance ne prouvent pas la politique hôte.

La provenance déjà résolue par SOURCE est conservée : source_sha256=086d… désigne le miroir JSON communautaire, tandis que 7ed25b… désigne l’INIBIN natif. La ligne courante concorde ; aucune corruption ni source manquante déduite, aucune recherche de provenance répétée.

Audit borné terminé ; implémentation Rebirth non établie dans les fenêtres ; runtime non exécuté ici ; acceptation humaine non donnée. Prérequis SOURCE, corrections antérieures, dépendances et inconnues conservés.

## 6. Corrections et reprise

corrections_and_restart.json propose six sous-objectifs documentaires COR-SYS-01.2-02-ANIVIA-REBIRTH : SEMANTICS-01, INTERCEPT-01, EGG-01, SURVIVAL-01, COOLDOWN-01 et VERIFICATION-01. Chaque fiche renvoie à SOURCE ou SIMULATION et précise entrées, travail, fin et reprise. Aucun registre modifié ni correction produit implicite.

Reprendre sur artefact serveur, fournisseur, capture, callsite ou dérive précis. Les corrections fonctionnelles nécessitent une politique sourcée et une autorisation adaptée. Prochaine paire réelle : Annie SIMULATION-CONTRAT, preuves d’implémentation partielle comprises. La sélection dans les 122 paires n’est ni une qualification des audits anciens ni un taux de clôture.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_anivia_passive_simulation_contract_20261106 : contrat, dix branches, ancres, identités, reprise SOURCE/provenance, journaux et corrections. Projection familiale existante réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2438 entrées groupées conservées. Relecture du même agent, sans revue indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité, inconnue ou acceptation fermée.
