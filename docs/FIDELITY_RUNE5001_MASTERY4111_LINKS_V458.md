# SYS-01.2-02 — rune 5001 et maîtrise 4111, V458

Les deux fiches RUNE-5001-SERVER-VALIDATION et MASTERY-4111-SERVER, ainsi que leur union SYS, sont reliées aux sources précises du client et à trois fonctions locales déjà enregistrées. Six liens sont ajoutés ; aucun nouveau consommateur ou comportement. Les dix anciens liens V57, leurs restrictions et les deux questions ouvertes sont conservés.

## Sources et résultats

Référence : PUBLIC 4.20.0.315, EUW/en_GB ; build du 17 novembre 2014 à 17:46:45, fuseau et déploiement non établis. Onze exports AIR existants sont comparés à leur index d'extraction ; leurs six bibliothèques sont vérifiées contre le manifeste 0.0.1.119, par chemin, release, taille, MD5 et SHA-256. Aucun export ou code AIR n'est réexécuté.

- Rune 5001 : DATA/Items/5001.inibin, 498 octets, SHA-256 b9d3a3872aed8770a6c4244c3666d34765cd71e894e11c4adc69f9e9632f1e6d. Data.FlatPhysicalDamageMod vaut exactement 0.5249999761581421 après décodage f32. Le catalogue 4.20.1 en_US indique 0.525, tier1, type red ; il reste distinct du payload des slots et de la locale en_GB.
- Maîtrise 4111 : DATA/Talents/4111.inibin, 99 octets, SHA-256 9d341303c2ddf374ad3a12c7466abde99ab98a54c1e2570f8d69f165bb932411. SpellData.Ranks vaut1. Ce champ ne prouve pas à lui seul le plafond effectif d'un Talent reçu ni son effet serveur.
- DATA/Talents/4111.luaobj : 56 octets, SHA-256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0. Un RETURN, zéro constante et zéro prototype enfant ; données lues par Reader.parse, aucune exécution Lua. Ce fichier ne fournit pas la logique des bonus/malus de dégâts décrits dans le catalogue.

Les origines et appartenances RADS enregistrées restent inchangées. Pour trois bibliothèques déjà enregistrées sous E:, leurs copies F: sont comparées en octets ; leurs identifiants historiques ne sont pas réattribués à F:.

## Contrat client et limites

RuneBookUtils.canAddToSlot compare le type de rune et le niveau minimal du slot. RuneType.equals compare l'identité ou runeTypeId ; les identifiants de couleur disposent de setters. RuneBookController prend la configuration de slots dans session.summonerCatalog.spellBookConfig. Aucun seuil de tier historique n'est inventé depuis le seul catalogue de la rune.

RunesTransportationController vérifie la quantité et la page, puis cherche un slot vide compatible par type et niveau pour le placement automatique. Le placement explicite reçoit un slot : les contrôles de RuneSlotView lors du glisser-déposer restent séparés de cette fonction. Une route UI n'est pas une validation serveur, et aucun tableau de slots EUW effectif n'est récupéré par ce lot.

MasteriesManager transmet l'identité de page au provider. MasteriesController sélectionne la page et sauvegarde le livre via masteryBookService ; son arbre et son budget viennent de la session. increaseTalentRank consomme pointsToActivate, prereqTalentGameCode, maxRank et totalPointsToSpend. Ces contrôles de page n'appliquent pas Double-Edged Sword dans le combat. Les descriptions de pourcentages du catalogue sont conservées comme descriptions, sans formule ou ordre de calcul serveur déduit.

## Consommateurs actuels

Les quatorze consommateurs inspectés comprennent les dix anciens points d'entrée/lecteurs du plan, la branche Host qui appelle join_with_summoners, Simulation.join, stats et apply_damage. Identités physiques historiques et actuelles comparées, ancrages et fenêtres conservés.

La rune reçoit le lien existant vers Host ; la maîtrise reçoit les liens existants vers join et stats. Le chemin de création initialise depuis le champion et le calcul de statistiques inspecté traite base, croissance, objets et effets locaux ; aucune page de maîtrise n'y est identifiée. apply_damage est également inspecté : sa portée générique est conservée dans le reçu, sans le reclasser artificiellement en consommateur de maîtrise.

JoinRequest déclare deny_unknown_fields. Les résultats V57 concernant les champs ignorés par le protocole legacy ou refusés par le type de session restent hérités et explicitement non réexécutés. Un refus de désérialisation ne démontre ni validation de placement/rang, ni réponse serveur, ni effet de jeu.

## Vérifications réalisées

Première préparation : code1, KeyError sur une bibliothèque recherchée sous F: alors que son identité était enregistrée sous E:. Échec avant création du dossier de préparation ou mutation du plan ; premier script conservé. La version2 résout explicitement l'identité historique et vérifie l'égalité des copies. Préparation corrigée, publication et audit séparé : code0. Commandes exactes dans ROOT_COMMAND_OBSERVATIONS.json.

55 identités ciblées ; 32 ancrages AIR et31 fenêtres de méthodes. Trois sélecteurs nominaux et six refus de sélecteur. Trois refus de manifeste : mauvais projet, mauvaise release et membre absent. Le garde-fou réel validate_entry_boundary_coverage accepte les deux associations correctes et refuse six altérations : prétendre la fonctionnalité identifiée, retirer sa question ouverte ou ajouter un consommateur générique incompatible avec cette classification. Aucun résultat de jeu déduit de ces contrôles.

Delta depuis sauvegardes : un reçu et trois fiches enrichies ; 42 211 autres exigences actives identiques. Anciens registres source/consommateur, statuts, flags, évaluations de portée et préfixes des liens conservés ; inconnues identiques en octets. Le compteur structurel source_hashes_verified=0 reste distinct des55 identités ciblées.

Dans chaque base locale : trois fiches et copies relues par Store.task, Store.copy_text, requirement_trace.resolve et make_instruction ; 42 606 états/notes, 23 historiques et 42 603 autres lignes exacts ; intégrité SQLite ok. Trois remplacements JSON puis deux transactions SQLite successives avec sauvegardes, sans atomicité globale revendiquée.

## Livrables et travail restant

Modifiés : les registres sources, traçabilité et tâches, et trois lignes tasks dans chacune des deux bases. Ajoutés : reçu sous docs/reference_rune_mastery_entry_sources/, preuve JSON et ce rapport. Couverture, plan et reprise mis à jour après sauvegarde. Aucun code ou asset de jeu modifié ; aucun Rust, build, sonde de protocole, AIR, VM, jeu, GPU ou réseau exécuté.

Les questions OLU-eb4c07c7-332d-59df-b31d-49fda3fa2f2c et OLU-7abc43c4-a778-57d7-abb2-e533b20294fd restent ouvertes. À établir : slots et règles effectifs, validation serveur des pages, sélection/transmission du loadout, effets et exceptions réels de4111. Les prérequis SCOPE ne deviennent pas complets par cette association. Cases et acceptation inchangées ; SYS-01.2-02 et goal actifs.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision458/SOURCE_LINK_RECEIPT.json, PREPARATION.json, DELIVERY_AUDIT.json et ROOT_EXECUTION_RECEIPT.json.
