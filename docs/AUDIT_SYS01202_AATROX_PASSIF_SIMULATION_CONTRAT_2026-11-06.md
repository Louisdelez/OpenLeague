# Aatrox — branches connues de Blood Well et écarts de simulation

6 novembre 2026 · V1447 · AUD-SYS-01.2-02-AATROX-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et périmètre

CH-Aatrox-PASSIF-SIMULATION-CONTRAT, OLF-ef8bf5f4-465e-5222-803e-a00c33d0f5de, parent SYS-01.2-02. Décrire les effets et branches établis par les preuves conservées, leurs limites et les consommateurs actuels. L’audit borné des branches textuelles connues et des écarts du code inspecté est terminé. La tâche complète reste ouverte : toutes les politiques historiques ne sont pas établies. Aucune nouvelle clôture SOURCE, HUD ou VFX.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 en_US distinct.

V456 reliait déjà cette exigence : docs/FIDELITY_AATROX_PASSIVE_SOURCE_BOUNDARIES_V456.md, SHA 9b7d311d954427e00ee8d532d87f2f3b552494f166b66b69a97b2742319ebed6. Reçu de 116072 octets, SHA 82f927382e0e049d7e42c4510eeade78a1504aa0892af19f05b1aeaeca2e6fb5 : dix fichiers natifs, cinq chunks, 39 mots, 17 affectations littérales, aucun CALL/callback. Identités et décodages hérités, sans nouvel accès natif. Aatrox.inibin : 1997 octets, SHA 4d1949dc1ddbd27fd37c2b5dc6d2aa635a738f7bf4547314ae4ddc445eac2483 ; PARType=BloodWell.

Cinq chaînes en_GB sont reprises de la preuve VFX qualifiée. Le miroir F, fontconfig_en_GB.txt, 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3, est relu et vérifié ; lignes 1644–1646, 4149 et 4325 exactes. L’identité native avait été qualifiée antérieurement ; la locale effective à l’exécution reste inconnue.

## 3. Consommateurs et branches

contract_review.json contient dix branches, leurs clés sources, inconnues, corrections et quatorze fenêtres de code. Les trois consommateurs enregistrés sont retrouvés : champion_catalog (OLC-93924678-ea15-5516-8f55-08616c5450cc), apply_damage (OLC-68c82898-e3d0-50b7-aa35-c58c982e7ddc) et advance_respawns (OLC-81087896-b97f-51ae-bdc3-de1f3db15992). Leurs octets concordent avec V456.

Les textes natifs décrivent : dépôt de 100 % des dégâts auto-infligés lors d’une capacité coûtant de la vie ; décroissance de 2 % par seconde hors combat ; vitesse d’attaque selon le remplissage ; extraction du contenu plus 35 % du pool total en soins sur trois secondes ; stase de trois secondes ; recharge de 225 secondes. La description mentionne 1 % de vitesse pour 2 % de remplissage, tandis que l’infobulle conserve @f2@. Ce sont des déclarations textuelles, pas un programme serveur observé.

Dans crates/core/src : damage.rs:53–150 applique la mort ordinaire ; lifecycle.rs:33–90 réapparaît à la fontaine ; progression.rs:68–129 calcule les statistiques génériques ; spells.rs:101–121 et annie_w.rs:29–49 refusent les sorts Aatrox. next_rank refuse sa progression. heal refuse une cible morte. Régénération, fontaine et relique ne restaurent pas BloodWell comme Mana/Energy. Ces consommateurs ne prouvent donc ni dépôt, ni stase, ni résurrection du passif. Les recherches négatives portent sur six fenêtres nommées, sans conclusion d’absence globale.

## 4. Attendu, observé et vérifications

Attendu : séparer chaque déclaration sourcée, sa politique non résolue et l’état réel des consommateurs. Observé : dix branches uniques, quatorze fenêtres exactes, seize identités courantes concordantes ; **42/42 contrôles documentaires, 25/25 contrôles de cohérence du même agent**.

Les refus de sort, progression, dégâts invalides et soins sur cible morte sont établis statiquement ; ils ne sont pas exécutés ici. Les anciens contrôles V456 restent hérités. Aucun build, jeu, réseau, runtime natif, REA, GPU ou capture nouveau. Deux recherches exploratoires ont supposé des noms de fichiers inexistants : resources.rs, puis make_report.py ; les consommateurs réels et prepare_documentation.py ont été retrouvés. Ces erreurs ne démontrent aucun manque fonctionnel.

## 5. Écarts et inconnues

Capacité et initialisation du puits, coûts admissibles, ordre des événements, dénominateur et cadence de décroissance, fournisseur f2, conditions de disponibilité, soins/modificateurs, ciblabilité en stase, crédit de mort et transitions de recharge restent inconnus. Ne pas fixer f2=50 par déduction. OnPreDamagePriority=4 est une métadonnée, sans ordre moteur établi. Death/Ready identiques ne prouvent pas une machine d’états. Les champs Disintegrate ne sont pas adoptés comme dégâts Aatrox.

Le SHA de l’export de classification des ressources diffère du binaire natif : provenance distincte conservée, aucune corruption déduite. Audit borné terminé ; implémentation Blood Well non établie dans les fenêtres ; vérification runtime non exécutée ; acceptation humaine non donnée. Inconnues SOURCE et contrat conservées.

## 6. Corrections et reprise

corrections_and_restart.json propose trois objectifs documentaires : COR-SYS-01.2-02-AATROX-BLOOD-WELL-SEMANTICS-01 pour les politiques manquantes, STATE-01 pour l’implémentation après autorisation fonctionnelle, VERIFICATION-01 pour les cas nominaux et limites. Le prérequis CH-Aatrox-PASSIF-SOURCE reste ouvert. Chaque fiche précise entrées, travail, fin et reprise ; aucun registre modifié.

Reprendre seulement sur artefact serveur, mapping, trace, callsite ou dérive précis. Le prochain lot Ahri possède sa paire exacte dans la projection ; consulter ses preuves existantes avant toute nouvelle recherche. Les mécanismes partagés déjà audités sont réutilisés.

## 7. Preuves et décision

Preuves : E:/mapslol3v3/audit_sys01202_aatrox_passive_simulation_contract_20261106, contract_review.json, coherence_review.json, identités, journaux et corrections. Projection des 122 contrats/SOURCE : 19627707 octets, SHA c37ef63de769b7f142e0b028a72d8f4d3497639172981c7e17c3788f0c87d06c ; préparation, pas 122 audits. Aucun grand registre rechargé. Aucun gain temporel mesuré.

Publication : ce rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes. Sept registres, goal, Plan/UI, bases, produit et assets préservés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2433 entrées groupées conservées. Relecture par le même agent, sans acceptation indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité ou inconnue close.
