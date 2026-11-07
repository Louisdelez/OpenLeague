# Akali — branches connues de Twin Disciplines et écarts de simulation

6 novembre 2026 · V1451 · AUD-SYS-01.2-02-AKALI-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Akali-PASSIF-SIMULATION-CONTRAT, OLF-8717caaf-ac26-585c-9ad5-8903af41ef78, parent SYS-01.2-02. Décrire les branches établies par les preuves conservées et leurs consommateurs actuels. **L’audit borné des déclarations connues et des écarts statiques est terminé ; la tâche complète reste ouverte.** Les politiques historiques inconnues, le gameplay, le réseau, la présentation et l’acceptation ne sont pas fermés. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

V557 associait déjà cette tâche : docs/FIDELITY_AKALI_PASSIVE_TWIN_DISCIPLINES_LINKS_V557.md, SHA ac0c96c2dff5640067541b285a8d2f9935a7cf60cf9209176281a0d4b34eef2c. Reçu docs/reference_requirement_trace_sources/akali-passive-twin-disciplines-links-v557.json,568511octets, SHA 657e9de21914225f53d11bf2e4b69d81e9d9f3f7be137dcf94fdf50d63e7b2af : treize sources natives, trois bindings, quatre Lua, trois preloads et cinq références communautaires distinctes. Identités/décodages natifs hérités, non rejoués. AkaliTwinAP.lua.inibin et AkaliTwinAP.inibin conservent leurs chemins distincts.

Le miroir en_GB courant est relu :2220957octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Quatre chaînes exactes aux lignes1672–1674 et4151 ; identité native/mirroir héritée de la preuve commune du même fichier, sans gameplay Ahri réutilisé. Locale effective en exécution inconnue.

## 3. Branches et consommateurs

contract_review.json décrit onze branches : identité/paramètres ; attaque Force ; conversion AP ; composante magique ; conversion AD bonus Might ; dégâts de capacité admissibles ; soin ; initialisation/progression/cycle de vie ; métadonnées ; référence communautaire ; limites des contrôles.

Les textes décrivent un supplément magique de6%, augmenté de1% par6AP, sur les attaques ; puis6% de Spell Vamp, augmenté de1% par6AD bonus. Les bases de pourcentage, fournisseurs, unités, seuils et arrondis restent inconnus. Les paramètres sont propres au binding : dans TwinDisciplines,f1 affiche le supplément magique et f2 le Spell Vamp ; dans TwinDmg,f1 est le pourcentage de soin. Aucun fournisseur global unique de f1 n’est présumé.

Dix-huit ancres enregistrées sont retrouvées dans dix fichiers courants concordant avec V557. Vingt-et-une fenêtres, dont dix-neuf communes réutilisées après égalité d’identité, relient commande, attaques, dégâts, statistiques, objets, soins et régénération. Les routes Learn/Cast/CastAt d’Akali refusent le support. basic_attack_hit applique le chemin physique puis le vol de vie d’objet ; heal est un récepteur générique.

Deux fenêtres complémentaires de progression.rs sont examinées :16–34 pour Stats et35–67 pour AD_components. La décomposition locale base/croissance/bonus inclut les ajustements courants ; elle ne fournit pas l’autorité historique de Might. Les recherches négatives portent sur neuf fenêtres nommées uniquement : aucun hook Akali/TwinDisciplines/SpellVamp nommé dans ces fenêtres. Aucune absence globale ni inspection complète du graphe d’appels revendiquée.

## 4. Attendu, observé et contrôles

Attendu : source, politique inconnue et consommateur ou manque précis pour chaque branche. Observé : onze branches uniques, vingt-et-une fenêtres, dix-huit ancres et dix-sept identités courantes ; **40/40 contrôles documentaires et33/33 cohérences du même agent**. Quatre opérations journalisées réussies.

V557 reste hérité : quatre cas sans objet/1052/1036/1053, douze attaques sortantes aux ticks947/990/1033 et120ticks après arrêt ;32refus publics. Avec20AP, les prédictions physiques restent45.7721748 ; avec10AD supplémentaires,53.6130981. Aucun supplément magique n’est qualifié. L’objet1053 restaure4.2890625PV par attaque via le vol de vie ordinaire. Cela ne qualifie pas Discipline of Might. Aucun sort Akali accepté dans les routes testées.

Identité de l’ancien binaire inerte :6040576octets, SHA 2fe58febcfc321babe6bf7d13295edd0d6a2913a5df0fde6d473829e1124becf. Aucun nouveau build, test Rust, runtime, réseau, Lua, accès D/F-work/EXE, REA, GPU ou capture. Les1158dépendances historiques ne sont pas recensées à nouveau. La revue VFX49contrôles reste une preuve antérieure distincte.

## 5. Écarts et conclusions ouvertes

Restent inconnus : f1/f2 par binding, base et calcul des pourcentages, progression, AP/AD bonus effectifs, événement d’impact, composante magique/critique, dégâts admissibles au Spell Vamp, zone/persistance, cibles, modificateurs de soin, ordre et cycle de vie.

Quatre chunks donnent vingt globals littéraux ; CharScript n’en donne aucun. Les références R_hand/L_hand restent des déclarations. L’icône33.dds diffère de Passive1Icon ; Nondispellable et NonDispellable ne sont pas unifiés. Passive1, description brute et niveaux absents ne reçoivent aucun défaut.

Le C# communautaire conservé contient6+bonusAd%6. Sa provenance est celle d’un snapshot modifié, sans autorité native ; ni le modulo ni ses unités ne sont adoptés. Audit borné terminé ; implémentation du passif non établie dans les fenêtres ; runtime non exécuté ici ; acceptation humaine non donnée. Prérequis SOURCE, dépendances et inconnues conservés.

## 6. Corrections et reprise

corrections_and_restart.json propose cinq objectifs documentaires COR-SYS-01.2-02-AKALI-TWIN-DISCIPLINES : SEMANTICS-01, FORCE-01, MIGHT-01, LIFECYCLE-01 et VERIFICATION-01. Chaque fiche précise entrées, travail, fin et reprise. Force et Might possèdent leurs intégrations distinctes. Aucun registre modifié ni correction produit implicite.

Reprendre sur artefact serveur, fournisseur, capture, callsite ou dérive précis. Les corrections fonctionnelles nécessitent leur politique sourcée et une autorisation adaptée. Prochaine paire réelle : Anivia SIMULATION-CONTRAT, première ligne alphabétique hors des unités précédentes/courante de cette série. La sélection sur122paires n’est pas une qualification des audits anciens ni un taux de clôture.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_akali_passive_simulation_contract_20261106 : contrat, onze branches, ancres, identités, journaux, corrections et reprise. Projection familiale existante réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2437entrées groupées conservées. Relecture du même agent, sans revue indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité, inconnue ou acceptation fermée.
