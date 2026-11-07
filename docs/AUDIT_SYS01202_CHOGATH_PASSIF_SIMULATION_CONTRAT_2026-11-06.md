# V1461 — Cho’Gath : contrat connu de Carnivore

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-CHOGATH-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Chogath-PASSIF-SIMULATION-CONTRAT, exigence OLF-96064aa7-27c5-55a0-967f-683f2029898f, parent SYS-01.2-02. Audit borné de quatorze branches connues et des consommateurs sélectionnés. Tâche complète, passif et goal restent ouverts. SOURCE reste a_qualifier ; phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Aucune formule récente substituée à la référence.

## 2. Sources, provenance et limites

Reçu docs/reference_requirement_trace_sources/chogath-passive-kill-sustain-links-v551.json : 509 602 octets, SHA256 d44fd571bacc31b0f8984f37bd4a1f38b5f473fc9afd52cb393b3c2a66a69b9d. Rapport V551 avec supplément de fraîcheur du 2026-11-02 : SHA256 675c57586dc7992957dc4d4298c66fb9f2a200b4cb15cc36e7275185bf6bf7f5. Le supplément et son ancien faux rejet de séparateurs Windows sont conservés comme preuves héritées, sans nouvel audit SOURCE.

Sept identités natives sélectionnées. Définition et buff concordent : Carnivore, GreenTerror_TailSpike.dds. Deux Lua entièrement parsés historiquement, deux vues littérales et quatre globals ; CharScript vide qualifié, sans prototype enfant. PersistsThroughDeath et NonDispellable ne démontrent pas leur exécution. Deux preloads, dont chogath_battlecast_heal.troy et globallifesteal_buf.troy, ne prouvent ni soin, ni vol de vie, ni skin affiché.

Trois clés en_GB retrouvées dans le miroir F identifié : deux bindings V551 et le nom déclaré. Ligne 1774 : f1 PV/f2 mana sur élimination ; description 4175 : montants croissant avec le niveau. Fournisseurs et formule non résolus. Passive1, Passive1Desc et les trois niveaux absents ne deviennent pas zéro. Lookup ne qualifie pas le fournisseur effectif ni la locale historique.

Le hash 557011… de champion_resources désigne le JSON communautaire Stats, distinct de l’INIBIN natif 0c6e8e…. Les domaines sont conservés ; aucune corruption déduite. Aucun nouveau fichier natif, chemin D/F-work ou binaire historique ouvert.

## 3. Consommateurs actuels

Vingt-deux entrées — quatorze Rust, deux lecteurs Python et six JSON — concordent avec V551 ; vingt-cinq identités courantes gardées. Vingt-neuf fenêtres : 27 communes réutilisées et deux nouvelles, crédit de mort champion et témoin Trundle. Dix-huit ancres enregistrées représentent catalogue et 17 frontières génériques ; elles ne sont pas des producteurs Carnivore.

lib.rs couvre état, commandes, tick et snapshot ; attacks.rs/lifesteal.rs l’attaque et l’impact ; damage.rs/world.rs les transitions de mort ; champion_kills.rs le crédit, l’or et l’XP ; healing.rs la réception des soins ; regeneration.rs la régénération ; progression.rs les niveaux ; lifecycle.rs la réapparition et la classification de ressource.

restores_resource renvoie un booléen à partir du champ type. Cette fonction n’applique aucun montant de mana et ne lit pas source_sha256. Le soin commun, le remplissage à la réapparition et la croissance des pools au niveau ne sont pas Carnivore.

Recherche textuelle bornée sur les quatorze Rust sélectionnés : zéro occurrence Chogath/Carnivore, en complément de l’inspection des corps. Pas de conclusion d’absence globale ni de nouveau recensement des 1 158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : mêmes identités, lignes, bindings et rôles, avec limites explicites. Observé : 49/49 contrôles documentaires et 58/58 cohérences du même agent. Quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V551 hérité : deux parties publiques contre Garen, une Cho’Gath et un témoin Trundle. Chacun reçoit quatre attaques puis en porte quatorze et obtient une élimination. Total huit coups entrants, 28 sortants, deux kills et 60 ticks après kill ; ces nombres ne sont pas tous attribuables à Cho’Gath.

Cho’Gath au tick 1569 : 441.1177673 PV avant, 441.1772766 après régénération et après kill, supplément zéro, maximum 574.4000244. Plus de 133 PV manquent : le plafond ne masque pas le résultat. Niveau 1 inchangé, vol de vie zéro ; +165 XP/+400 or ne produisent pas de gain de niveau. Trente ticks suivants : régénération seule. Le supplément zéro ne donne pas une valeur native f1=0.

Trundle au tick 1532 reçoit 12.3255920 PV supplémentaires, conformes à sa reconstruction communautaire actuelle de 2% des PV maximum de Garen, tolérance 0,002. Son récepteur vise les Trundle proches d’une mort adverse, sans exiger le crédit du kill ; cette règle n’est pas transférable à Carnivore.

Mana plein dans les deux cas : restitution non observable. Quatre Cast Cho’Gath refusés ; quatorze refus publics antérieurs possèdent leurs snapshots individuels inchangés. Morts de sbires/monstres inspectées statiquement, non exécutées ; autres niveaux, cibles et ordres natifs non qualifiés. Identité de l’ancien EXE conservée en données : 6 052 352 octets, SHA256 5ebedc1970e9234a093c0ac3a4ef897c392334a5e743fccfc14e74dae0345d85 ; aucun accès ni exécution.

## 5. Contrat connu et écarts

Carnivore restaure PV et mana après une élimination, avec progression selon le niveau. Valeurs f1/f2, catégories exactes, attribution directe/indirecte, pets, assist/exécution et moment de lecture du niveau restent inconnus.

Les quatorze branches couvrent identité, crédit du kill, niveaux, PV, mana/classification, ordre des restitutions, cibles, sources de dégâts, cycle de vie, refus, projection, témoin Trundle, observabilité et provenance. Restent notamment ouverts : modificateurs de soin, plafonds, retour posthume, source supprimée, mort répétée, transaction PV/mana, simultanéité et ordre avant/après récompenses/régénération.

Aucun manque d’asset n’est inventé. Le manque constaté est un producteur Carnivore qualifié sur les chemins sélectionnés, avec une règle native encore partielle.

## 6. Corrections et reprise

Dix fiches documentaires dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-CHOGATH-CARNIVORE-, suffixe -01 :

- AUTHORITY : fournisseurs f1/f2 et formule de niveau.
- KILL-CREDIT : propriétaire et élimination admissible.
- HEALTH-RESTORE : soin effectif et modificateurs/plafond.
- MANA-RESTORE : producteur de mana et déficit observable.
- LEVEL-ORDER : niveau échantillonné et effets du gain XP.
- TARGETS : exceptions par catégorie de victime.
- PROC-ORDER : ordre, atomicité et refus.
- LIFECYCLE : mort, suppression, équipes et reprise.
- PROJECTION : pools et événements partagés.
- VERIFICATION : parcours réels avec témoins séparés.

Chaque fiche relie une tâche V551 existante, ses prérequis, travail, fin propre et reprise sur source précise, dérive ou contradiction. Pour le mana, rechercher une dépense publique réellement supportée ; si elle manque, garder cette limite ouverte. Ne pas fabriquer un déficit ni assimiler le mana plein à une preuve. Correction fonctionnelle sous autorisation distincte.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_chogath_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2 447 entrées groupées modifiées au resume, conservées. Prochaine sélection : Corki depuis les 122 paires existantes, sans assimilation à une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et inconnues ouvertes. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés. Aucun nouveau runtime, REA, rendu, audio ou réseau.
