# Ahri — branches connues d’Essence Theft et écarts de simulation

6 novembre 2026 · V1448 · AUD-SYS-01.2-02-AHRI-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Ahri-PASSIF-SIMULATION-CONTRAT, OLF-9842c7dd-4bfb-5c85-99f8-cb1da0bb03af, parent SYS-01.2-02. Examiner les branches établies par les sources conservées et leurs consommateurs actuels. **L’audit borné des déclarations connues et des écarts statiques est terminé ; la tâche complète reste ouverte.** Les politiques historiques non établies, le gameplay, le réseau, la présentation et l’acceptation ne sont pas fermés. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

V556 associait déjà cette tâche : docs/FIDELITY_AHRI_PASSIVE_SPELL_HIT_CHARGES_HEAL_LINKS_V556.md, SHA 1494b58a9f5e54b6b75d703afac3db5c66ab3b52f960c176cb1f7befe8da3910. Reçu docs/reference_requirement_trace_sources/ahri-passive-spell-hit-charges-heal-links-v556.json, 583539 octets, SHA 0ff0997c993affb449699c63822b3678d941d85ddcd3a62c6e084e823b5b3bcb : dix-huit sources natives, quatre bindings, huit Lua littéraux, quatre preloads et six références communautaires distinctes. Identités/décodages natifs hérités, non rejoués.

Le miroir en_GB courant est relu : 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Cinq chaînes exactes aux lignes 1660, 1663–1665 et 4150 ; l’égalité native/mirroir est héritée de l’audit HUD qualifié. La locale effective en exécution reste inconnue.

## 3. Branches et consommateurs

contract_review.json décrit onze branches : identité ; impact de sort admissible ; plafond par sort ; seuil de préparation ; prochain sort et consommation ; soin par touche ; valeurs/progression ; formulation du compteur ; propriétaire/cycle de vie ; variantes de métadonnées ; frontière des refus et contrôles.

Les textes décrivent une charge par impact de sort sur un ennemi, trois charges au maximum par sort, puis un prochain sort soignant à chaque touche après neuf charges. Counter dit « neuf sorts » ; cette formulation n’est pas remplacée par « neuf charges ». f1/f2 restent des paramètres non résolus. Les anciens textes de critique allié/Attack Rate ne sont pas adoptés ; Passive1 et niveaux absents ne reçoivent aucun défaut.

Dix-neuf ancres enregistrées sont retrouvées dans onze fichiers actuels, identiques aux entrées correspondantes de V556. Dix-huit fenêtres sont examinées, dont onze communes réutilisées de V1447 après égalité d’identité. Les appels de commande mènent aux refus Learn/Cast/CastAt d’Ahri. damage/heal/régénération sont génériques ; basic_attack_hit produit du vol de vie d’attaque. pyromania_spell, annie_passive.rs:9–24, exige explicitement Annie ; advance_annie_w appelle ce compteur distinct.

La recherche négative nomme sept fenêtres de structures/méthodes : état, Effects, dégâts, ordre des phases, régénération, attaque et commande. Aucun hook Ahri nommé dans ces fenêtres ; aucune absence globale ni analyse exhaustive du graphe d’appels revendiquée.

## 4. Attendu, observé et contrôles

Attendu : chaque déclaration conserve sa source, ses inconnues et son consommateur ou manque précis. Observé : onze branches uniques, dix-huit fenêtres, dix-neuf ancres, dix-sept identités courantes ; **41/41 contrôles documentaires et 30/30 cohérences du même agent**.

Les observations publiques V556 restent héritées : Ahri, dix-sept refus, aucun sort accepté ; Annie, sept refus, W au tick968 et Pyromania0→1. Trente ticks par cas, soixante au total, régénération ordinaire sans soin supplémentaire ; vingt-quatre refus. Ces résultats ne testent pas l’activation d’Essence Theft. L’identité de l’ancien binaire reste une donnée inerte : 6017024 octets, SHA 475e9e8d34462f954bbc177e056d851236d25f15d76c5d2b99fa80199a88ae99.

Cinq opérations journalisées : quatre réussies, contract01 arrêté sur un nom de champ de preuve. Le miroir était déjà épinglé dans native_localization_inherited.F_text_identity ; contract02 ajoute seulement un alias local, sans changer sources, critères ni témoins. Script et échec initiaux conservés. Une exploration root a également supposé registered_trace au lieu de trace dans un prérequis ; schéma corrigé, aucune source manquante déduite.

Aucun nouveau build, test Rust, runtime, réseau, Lua, accès D/F-work/EXE, REA, GPU ou capture. Les 1158 dépendances historiques ne sont pas recensées à nouveau.

## 5. Écarts et conclusions ouvertes

Restent inconnus : catégories de cibles/impacts, unité d’instance de sort, touches multiples/retour/recast, dépassement du seuil, choix et consommation du prochain sort, ordres simultanés, fournisseurs f1/f2, progression, ratio AP, arrondis, modificateurs de soin et états de mort/reconnexion.

Les huit chunks donnent trente-huit globals littéraux sans prototype enfant ni exécution serveur. SoulCrusher2/3/4 emploient des noms Egitai/potions ; SoulCrusher5 conserve ses chaînes vides. Aucune conversion en rangs ou variante active. PersistsThroughDeath/NonDispellable sont des déclarations, sans politique hôte démontrée.

Audit borné terminé ; implémentation du passif non établie dans les fenêtres ; vérification runtime non exécutée ici ; acceptation humaine non donnée. Prérequis SOURCE, dépendances et inconnues conservés.

## 6. Corrections et reprise

corrections_and_restart.json propose six objectifs documentaires COR-SYS-01.2-02-AHRI-ESSENCE-THEFT : SEMANTICS-01, HITS-01, CONSUMPTION-01, HEAL-01, LIFECYCLE-01 et VERIFICATION-01. Chaque fiche possède objectif, entrées, travail, fin et reprise. Aucun ajout au registre ni correction produit implicite.

Reprendre une investigation sur un artefact serveur, fournisseur, capture, callsite ou dérive précis. Les futures corrections fonctionnelles nécessitent leurs sources et une autorisation adaptée. Prochaine paire réelle : Alistar SIMULATION-CONTRAT dans next_lot.json, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_ahri_passive_simulation_contract_20261106 : contrat, onze branches, ancres, identités, journaux, qualification de schéma, corrections et reprise. Projection familiale existante réutilisée, zéro grand registre chargé, aucun gain temporel chiffré.

Publication limitée au présent rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2434 entrées groupées conservées. Relecture du même agent, sans revue indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité, inconnue ou acceptation fermée.
