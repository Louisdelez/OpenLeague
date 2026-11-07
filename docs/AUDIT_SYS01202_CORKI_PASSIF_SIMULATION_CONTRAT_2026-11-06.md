# V1462 — Corki : contrat connu de Hextech Shrapnel Shells

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-CORKI-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Corki-PASSIF-SIMULATION-CONTRAT, exigence OLF-1f44c791-a60d-502a-8a5c-1754b3261770, parent SYS-01.2-02. Audit borné de quinze branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts. SOURCE reste a_qualifier ; phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Contrat historique Hextech Shrapnel Shells, alias RapidReload ; aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/corki-passive-rapidreload-true-damage-links-v561.json : 534 532 octets, SHA256 596b85754104799c2e5ae085536e11f9b01cae9ef9a20ca92694c9efa561a21a. Rapport V561 : SHA256 90feae41a6e3aea58d134b0107426406f34f2ac7d3a26085a1b14b8473a47361. Preuves qualifiées réutilisées sans republication de V561 ni nouveau lot SOURCE.

Six identités natives, deux Lua entièrement parsés historiquement, deux vues littérales/quatre globals, sans prototype enfant. CharScript vide qualifié ; RapidReload déclare nom, icône Corki_RapidReload.dds, PersistsThroughDeath et NonDispellable. Ces déclarations et le preload ne prouvent ni callbacks, ni persistance, ni rendu de skin.

Trois clés en_GB retrouvées dans le miroir F identifié : deux bindings V561 et le nom déclaré. Ligne 2510 : attaques de base avec supplément de dégâts vrais égal à 10% de l’AD total, structures exclues. Description 4176 : sbires, monstres et champions. Ce coefficient est écrit dans la source ; le moment de lecture de l’AD et l’ordre des effets restent ouverts. Lookup ne qualifie pas le fournisseur actif ni la locale historique.

Passive1 absent ne devient pas zéro. Passive1Desc conserve la phrase Annie ; niveaux bruts 1/4/7/«10»/13/16 conservés sans adoption. Aucun effacement ni normalisation silencieuse. Aucun accès nouveau aux ressources natives, aux chemins D/F-work ou à l’ancien EXE.

## 3. Consommateurs réels

Vingt-trois entrées — quinze Rust, deux lecteurs Python, six JSON — concordent avec V561 ; vingt-six identités courantes gardées. Trente-et-une fenêtres : 27 communes reprises, quatre nouvelles pour critique, initialisation du monde, CastAt et achats/ventes. Vingt-trois ancres enregistrées représentent catalogue et 22 frontières génériques, sans producteur Corki qualifié.

lib.rs porte commandes/état/tick/snapshot ; progression.rs les stats ; attacks.rs les départs/projectiles ; lifesteal.rs appelle basic_attack_hit→apply_damage Physical. damage.rs sépare mitigate et l’événement apply_damage ; world.rs décrit catégories/protection/dégâts aux unités ; critical.rs le profil ordinaire ; shop.rs les achats et bonus ; healing.rs les soins communs ; lifecycle.rs le cycle de vie.

Le chemin courant ne produit pas le supplément True dans les corps inspectés. mitigate True retourne raw, mais apply_damage possède aussi gardes, modificateurs sortants, boucliers, PV et morts. Le vol de vie courant s’appuie sur post_mitigation de la composante physique, avec exclusion des structures. Ces politiques génériques ne sont pas automatiquement celles du bonus natif.

Recherche textuelle bornée aux quinze Rust : zéro occurrence Corki/RapidReload/Hextech Shrapnel. Ce complément aux corps inspectés ne prouve aucune absence globale. Aucun nouveau recensement des 1 158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, bindings, rôles et limites cohérents avec les preuves admises. Observé : 50/50 contrôles documentaires, 59/59 cohérences du même agent ; six opérations journalisées : cinq réussies et un échec de sélecteur rédactionnel conservé. Aucun build ni essai de jeu relancé.

V561 hérité : base, Épée longue1036, cible avec Armure d’étoffe1029, tourelle extérieure Turret_T2_R_02. Dix-huit impacts champion, deux tourelle ; dégâts physiques seuls, résidu maximal 0.0000228882. AD 51.2400017 puis 61.2400017, armure champion 27.5359993 puis 42.5359993. Les suppléments 5.124/6.124 décrits par le texte ne sont pas observés.

Tourelle TT_ChaosTurret2, armure 67 : deux impacts physiques de 30.6826172. Ce résultat est compatible avec l’exclusion, mais ne la valide pas : le bonus manque aussi sur les cibles positives. Sbires, monstres, autres structures et critiques non qualifiés.

Calcul pur distinct : raw100 en True donne100 avec armure0/100/1000 et réduction0,7 ; trois invalides rejetés. Aucun apply_damage ni événement True en jeu démontré par ce calcul.

Les 68 refus publics incluent huit Buy/Sell hors boutique et 48 Learn/Cast/CastAt. Première analyse historique échouée : elle attendait erreur objet/emplacement, avant de constater outside allied shop. L’analyse seule avait été corrigée sans rejouer build/combats. Wrapper initial et huit écarts conservés dans historical_analysis_repair_inherited. Le code courant confirme shop_guard avant item/slot ; ces refus ne testent donc pas les gardes internes.

Ancien binaire identifié en données seulement : 6 067 712 octets, SHA256 e1c15164c521ade9502f606329fa99594b91d42915366c370539f7571c3a1efe. Aucun accès, hash ou lancement de ce binaire.

## 5. Contrat connu et écarts

Supplément de 10% AD total en dégâts vrais, en plus de l’attaque physique, sur catégories positives et hors structures. Restent à qualifier : événement accepté, moment d’échantillonnage de l’AD, arrondis, critique, réductions/boucliers, vol de vie, état de cible et source durant le projectile, décès, refus et crédit.

Les quinze branches séparent identité, déclencheur, AD, composantes, catégories positives, structures, calcul/réception, critique, vol de vie, trajectoire/annulation, ordre létal, persistance, projection, analyse des refus et couverture historique. Un premier composant létal et un second événement refusé sur cible morte constituent une question d’ordre à résoudre, pas un échec Corki reproduit ici.

La phrase Annie et les niveaux hérités ne sont pas des règles adoptées. Aucun bonus magique converti ni formule récente introduits. Présence des assets et calcul True n’équivalent pas à une fonctionnalité terminée.

## 6. Corrections et reprise

Onze fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-CORKI-SHRAPNEL-, suffixe -01 :

- AUTHORITY : compléter les sémantiques natives encore ouvertes.
- TRIGGER : appel automatique depuis l’attaque acceptée.
- DAMAGE : supplément True de 10% AD total.
- TARGETS : catégories positives et exclusion des structures.
- MODIFIERS : critique, réductions et boucliers.
- LIFESTEAL : participation du bonus au soin.
- ATTACK-CYCLE : lancement, trajet et annulation.
- PROC-ORDER : composantes, létalité et atomicité.
- LIFECYCLE : propriétaire, mort et réinitialisation.
- PROJECTION : composants et événements partagés.
- VERIFICATION : parcours réel et témoins distincts.

Chaque fiche relie une tâche V561 existante, des prérequis, un travail, une fin propre et une condition de reprise. Reprendre sur source précise, dérive ou contradiction ; correction fonctionnelle sous autorisation distincte. Conserver l’ancienne analyse échouée et le contrôle arithmétique dans leurs périmètres.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_corki_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2 448 entrées groupées modifiées au resume, conservées. Prochaine sélection : Darius depuis les 122 paires existantes, sans assimilation à une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et inconnues ouvertes. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés. Aucun nouveau runtime, REA, rendu, audio ou réseau.
