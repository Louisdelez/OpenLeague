# Camps Map10 : sources et consommateurs — LoL 4.20

Périmètre : SYS-01.2-02/03/05/06, référence PUBLIC 4.20.0.315, EUW/en_GB. Cette étude affine l’inconnue existante Maps/Map10/NeutralMinionSpawn.cs ; elle ne clôture pas le Goal ni la fidélité de la carte.

## Sources et méthodes

Le membre original NeutralMinionSpawn.luaobj et LevelScript.luaobj sont liés aux manifestes exacts sélectionnés. Le lecteur indépendant relit les tableaux d’instructions et les noms CLOSURE/SETGLOBAL. Les expériences utilisent Lua 5.1/Lupa avec conversion de taille de longueur de chaîne seulement : aller-retour 32 bits exact et instructions identiques. Les API sont des observateurs, pas des implémentations du moteur.

La récupération statique existante map10_native_neutrals.json est conservée et reproduite sans exécution Lua : elle s’arrête à pc364, opcode LEN. Elle contenait déjà les positions, orientations et groupes. L’expérience d’initialisation héritée exécute la suite et les callbacks originaux pour demander huit créations de camps. Elle ajoute une observation ; elle ne remplace pas les preuves antérieures.

Deux méthodes CSharp originales complètes, InitializeCamps et GetRespawnTimer, sont extraites par Roslyn puis relues par tranches UTF16 exactes. Elles sont compilées sous .NET 8 avec le vrai enum TeamId et des hôtes d’observation. OnUpdate est extrait et lu, sans exécution du serveur complet. Le paramètre AI omis reçoit un marqueur explicite dans l’hôte ; cela ne qualifie pas le comportement de l’API de création.

L’instantané communautaire modifié est basé sur b37c75483abf66048af7c914e7fab700efaa5e21. Le SHA du fichier précis, son blob d’index et sa provenance sont conservés ; ses octets ne sont pas attribués au commit amont.

## Résultats observés

Les huit camps comprennent 18 membres. Les sept camps du fichier map10_world.json et la relique séparée de map10_interactions.json existent déjà et ont des consommateurs Rust identifiés. Les 18 modèles, positions et hauteurs correspondent aux valeurs natives ; les 17 orientations des camps correspondent aux vecteurs d’orientation source. Aucune orientation de la relique n’est déduite de son consommateur distinct.

| Camp | Champ natif de délai | Initial actuel | Initial CSharp observé | Champ de réapparition natif / actuel |
|---|---:|---:|---:|---:|
| Camps ordinaires 1 à 6 | 15 | 100 | 100 | 50 |
| Relique 7 | 95 | 180 | 115 | 90 |
| Vilemaw 8 | 515 | 600 | 600 | 300 |

L’écart entre les huit valeurs actuelles et le champ natif vaut 85. Cette régularité ne démontre pas l’origine historique de l’horloge, l’unité/point d’application du champ moteur ou un horaire absolu fidèle. La différence de la relique communautaire reste distinguée. Les sources actuelles conservent leurs valeurs ; aucune correction arbitraire n’est faite.

Deux noms uniques CSharp diffèrent des noms produits par le Lua original : TT_NWraith24.1.2f contre TT_NWraith24.1.2 ; TT_NGolem5.1.1f contre TT_NGolem5.1.1. Leurs conséquences d’exécution restent à établir.

Dans deux environnements frais, math.random(100) reçoit explicitement les résultats 1 et 100. Chaque camp d’origine a un groupe de probabilité 100 ; les autres configurations de groupes ne sont pas qualifiées.

- 16 appels SpawnInitialNeutralMinions marquent AliveTracker sans demander de spawn ni de timer dans ces profils.
- 16 fermetures originales de timer demandent 36 SpawnNeutralMinion, avec les identifiants camp/groupe/membre et les données de camp observés.
- 27 appels NeutralMinionDeath comprennent les 18 morts séquentielles, huit répétitions de la dernière mort et un nom inconnu. Ils demandent 16 timers : huit à la dernière mort, puis huit sur sa répétition. Un nom inconnu ne modifie aucun camp.
- Les demandes de timer préservent la fermeture originale, la chaîne de type vide, le champ de réapparition, zéro et false. Aucun timer moteur ni réapparition effective n’est exécuté.

## Liaisons natives et consommateurs

Les noms CreateNeutralCamp, SpawnNeutralMinion et InitNeutralMinionTimer existent dans le PE original. Trois séquences d’enregistrement et leurs enveloppes de conversion sont identifiées par 11 plages de code bornées. InitNeutralMinionTimer fournit le pointeur 0x6a6e80 ; CreateNeutralCamp et SpawnNeutralMinion fournissent tous deux 0x6a7120. Les enveloppes et cibles sont conservées en octets, SHA et désassemblage.

La cible de timer lit notamment 0x14cd1f0 et 0x2d788bc et appelle d’autres fonctions. Ni l’initialisation de ces valeurs, ni les effets de l’ordonnanceur, ni l’enregistrement dynamique ne sont qualifiés. Le pointeur partagé des deux autres fonctions ne prouve pas le comportement d’un serveur historique complet. La première exploration désalignée à 0x6a5888 est exclue ; les plages acceptées partent de frontières d’instruction vérifiées.

Six ancres CSharp relient l’initialisation et les mises à jour de la carte, la transmission et le stockage du timer, sa décrémentation et sa remise à la valeur de réapparition. Quatre ancres Rust relient l’initialisation/réapparition des camps et de la relique aux configurations existantes. Ces ancres sont relues en source ; aucun nouveau test de gameplay Rust n’est revendiqué.

## Vérifications et suite

L’auditeur de référence réussit 59 contrôles : cas nominal, 57 refus de données altérées et un contrôle positif de représentation numérique. Il relit les identités, manifestes, récupération statique, profils, arguments, méthodes entières, enums, consommateurs et plages binaires sans rejouer les expériences.

Les anciennes sources, relations, questions, conditions de résolution et états manuels sont conservés. Les inconnues portent encore sur l’horloge initiale et les fonctions moteur, la production des événements/doublons, les conséquences des noms, l’IA restante et l’équivalence effective Rust/serveur. La résolution exige ces preuves ; elle ne découle pas de la présence des ressources ou de méthodes compilées avec des hôtes d’observation.

Reçu de livraison : docs/fidelity_registry_camp_revision_4_20.json. Journaux et sources de l’étude : E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision42.
