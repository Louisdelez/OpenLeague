# V1459 — Caitlyn : contrat connu de Headshot

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-CAITLYN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Caitlyn-PASSIF-SIMULATION-CONTRAT, exigence OLF-6a161d9d-e7d5-5483-ae8f-310aa5830d45, parent SYS-01.2-02. Audit borné de seize branches connues face aux consommateurs sélectionnés. La tâche complète, le passif et le goal restent ouverts. Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

La dépendance CH-Caitlyn-PASSIF-SOURCE reste a_qualifier. La projection fournie contient un rapport V560 ; elle ne fournit pas de relecture SOURCE comparable aux derniers lots. Un chemin SOURCE daté supposé absent ne démontre aucune absence globale. Ce lot ne crée ni ne clôture une unité SOURCE.

## 2. Sources et provenance

Reçu docs/reference_requirement_trace_sources/caitlyn-passive-headshot-brush-minion-links-v560.json : 593 744 octets, SHA256 50199459f84f29eb1107729191bee705c801d1624aec06fcebe6232dd2f9a27c. Rapport V560 : SHA256 8792a065c9d97af11f3709616820aca554bc365fc9cd24d450fcf4499650133d. Identités et conclusions retenues, sans republication de V560.

Quinze identités natives sélectionnées ; cinq Lua entièrement parsés historiquement, sans prototype enfant. Trois vues littérales donnent six globals, dont une vue CharScript vide qualifiée. Headshot pc4 et Missile pc0 échouent au lecteur littéral sur NEWTABLE : globals inconnus, raw {} conservés, constantes non adoptées comme assignments. Aucune corruption déduite.

Passive1LuaName et BuffName concordent sur Headshot Marker ; icône Caitlyn_Headshot.dds. Passive1, Passive1Desc et les trois niveaux absents ne deviennent pas zéro. PersistsThroughDeath et NonDispellable sont des métadonnées, sans preuve de persistance exécutée. Quatre preloads et six références communautaires restent le contexte hérité de V560 ; aucun gameplay ni skin validé par leur présence. Aucun accès D, F-work ou EXE ; les identités historiques restent inertes.

Six clés en_GB sont retrouvées dans le miroir F identifié : cinq bindings V560 et le nom du passif issu de la déclaration. Identité du fichier partagée uniquement ; fournisseur effectif, aliases et locale historique restent non qualifiés.

## 3. Consommateurs réels

Vingt-trois entrées sélectionnées — quinze Rust, deux lecteurs Python et six JSON — concordent avec V560. Vingt-six identités courantes sont gardées. Trente-cinq fenêtres sont examinées : 27 réutilisées depuis le lot Braum, huit nouvelles pour critique, buisson/visibilité, projection, achats, initialisation/spawn/vagues et présentation générique.

lib.rs porte état, commandes, tick et snapshot ; progression.rs les statistiques ; attacks.rs le windup, lancement ET déplacement/impact des projectiles ; lifesteal.rs, damage.rs, penetration.rs, shields.rs et world.rs les réceptions. critical.rs, vision.rs, shop.rs et lifecycle.rs délimitent critique, buisson, bonus et cycle de vie. spells.rs et annie_w.rs portent les frontières de refus. Le fichier supposé projectiles.rs n’existe pas au chemin essayé ; le consommateur réel est advance_attacks.

Les 23 ancres enregistrées représentent catalogue et 22 frontières génériques, sans producteur Headshot qualifié. Recherche textuelle bornée à quinze Rust sélectionnés : zéro occurrence Caitlyn/Headshot. Ce résultat complète l’inspection des corps ; il ne prouve pas une absence globale.

## 4. Attendu, observé et contrôles

Attendu documentaire : mêmes identités, bindings et rôles que les preuves admises, avec écarts explicites. Observé : 47/47 contrôles, 61/61 cohérences du même agent. Cinq opérations journalisées : quatre réussies ; bootstrap01 refusait les chemins relatifs avant lecture des consommateurs. bootstrap02 change uniquement leur jonction lexicale à F ; garde et sources inchangées. Échec, deux scripts et qualification conservés. Deux chargements de la projection familiale, échec inclus ; aucun registre global reparsé.

V560 est hérité, non rejoué : trois cas, 36 lancements ordinaires non critiques à 50.0400009155 dégâts bruts. Douze impacts champion hors buisson, douze depuis buisson ; flags source respectivement 0 et 1. Armure/régénération expliquent ces 24 impacts, erreur maximale 0.0000190735. Aucun Headshot observé dans ces séquences.

Cas sbires : achats publics 1028/1029 pour 700 or, sans bonus AD ; quatre ordres Melee/Caster, douze lancements, onze retraits de projectile et dernier encore en vol. Dégâts nets sbires non isolés : ne pas compter douze impacts qualifiés. Les 51 refus atomiques antérieurs et leurs snapshots inchangés ne testent pas un compteur absent. Aucun test, build ou jeu exécuté aujourd’hui.

## 5. Contrat connu et inconnues

Texte : accumulation d’attaques, buisson compte double, état chargé, prochaine attaque à 150 % des dégâts sur champion ou 250 % sur sbire. Ces nombres ne signifient pas +150 %/+250 %. Le marqueur dit f1 attaques ; la description missile dit huit. Fournisseur, seuil effectif et niveaux restent inconnus ; huit n’est pas adopté.

Les seize branches couvrent identité/admission, seuil, événement de comptage, buisson, disponibilité/consommation, dégâts champion, dégâts sbire, autres cibles, critique/modificateurs, missile/annulation, refus, mort/dispel, présentation, limites de lecteur, données numériques et vérification. Restent ouverts : base des dégâts, ordre, arrondis, snapshot AD, monsters/structures/pets, perte de cible/vision, persistance, réarmement, audiences et rendu. Critique générique à chance zéro/multiplicateur deux ne vaut pas Headshot.

## 6. Corrections et reprise

Onze fiches documentaires dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-CAITLYN-HEADSHOT-, suffixe -01 :

- AUTHORITY : résoudre autorités, seuil f1/huit et aliases.
- COUNTER : événement, compteur, disponibilité et consommation.
- BRUSH : moment d’échantillonnage et contribution double.
- CHAMPION-DAMAGE : base, montant et ordre sur champion.
- MINION-DAMAGE : montant et impacts nets isolés sur sbires.
- OTHER-TARGETS : exceptions documentées par catégorie.
- CRITICAL : critique, modificateurs et capture AD.
- ATTACK-CYCLE : annulation, trajectoire, refus et état.
- LIFECYCLE : mort, dispel, réapparition et reset.
- PROJECTION : audiences et contrat synchronisé.
- VERIFICATION : parcours sourcé, nominal/refus/bornes.

Chaque fiche a une tâche liée, des prérequis, un travail, un critère de fin propre et une condition de reprise. Reprendre sur source précise, dérive ou contradiction ; correction fonctionnelle sous autorisation distincte. Dépendances et inconnues conservées. Prochaine sélection : Cassiopeia dans les 122 paires existantes ; sélection ne signifie pas clôture.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_caitlyn_passive_simulation_contract_20261106, matrices, reçus, identités, limites de découverte et qualification des chemins. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2 445 entrées groupées modifiées au resume, conservées.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et inconnues ouvertes. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés et vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés. Aucun gain de vitesse chiffré revendiqué.
