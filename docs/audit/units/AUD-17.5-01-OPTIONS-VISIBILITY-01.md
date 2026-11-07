# AUD-17.5-01-OPTIONS-VISIBILITY-01

UTC : 2026-10-31T05:47:27.496397+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Qualifier le consommateur frontend de onlyshowif et sa règle de filtrage dans FoundryOptions.gfx. Fin documentaire : propriété,factory,entrée d’environnement,sortie des enfants refusés,octets originaux et limites relus. Le movie réellement sélectionné et la visibilité native effective restent distincts.
Audit : producteur terminé,clôture réservée à la relecture distincte. Implémentation : non modifiée. Vérification : export statique Java/JPEXS,comparaison de bytecode et intégrité exécutés;ActionScript,x86 du jeu,Rust,GUI et réseau non exécutés. Acceptation humaine : non demandée. Goal et critères inchangés.

## R2 — Sources et dérivation
Trois ressources originales épinglées : menu/Options.gfx,Menu_SC4/Options.gfx et Menu_SC4/FoundryOptions.gfx. La chaîne onlyshowif apparaît une fois dans le corps décompressé Foundry et zéro fois dans les deux autres;absence lexicale seulement,pas équivalence de fonctions ni choix actif.
Foundry : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — 132101octets,SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. DoABC82 nomméframe1,version46.16. Le préfixe logique défini par la longueur d’en-tête se termine exactement au tagEnd;895octets Foundry et2792octets SC4/Options gonflés supplémentaires,non tous nuls,sont conservés. Aucun diagnostic de corruption depuis cet écart seul.
Outils existants Java,JAR JPEXS26.2.1,JVM identifiés depuis un reçu antérieur puis réhachés.306scripts AS3 et6classes en p-code hex exportés;aucun bytecode exécuté,aucune installation. Les classes unitTest et DEBUG sont des sources intégrées,pas des fonctions publiques validées ni des tests exécutés.
Commande d’export documentée par le [projet JPEXS](https://github.com/jindrapetrik/jpexs-decompiler/wiki/Commandline-arguments);aide de la version locale consultée,la version en ligne étant différente. Résolveur d’import limité aux ressources locales;logs et limites conservés.

## R3 — Consommateurs et chaîne
`dataConsts.DataAttrib.ONLYSHOWIF = "onlyshowif"`→`factories.ModelFactory.create`. Le callback lié sous InitializationData reçoit xml et environment;ce dernier Array est converti en Vector<String> et passé à ModelFactory. Le chemin handleLoadGameFiles utilise séparément Data.DEBUG_ENVIRONMENT;ce tableau n’est pas une preuve d’environnement natif.
UnifBaseModel.createChild applique son héritage limité,puis appelle la factory;un résultat null n’est ni initialisé ni ajouté par createAllChildren. L’héritage ordinaire du modèle ne liste que inisection,strategy,prependnolabelevents;le transfert des attributs d’un include dans le C++ est une règle distincte déjà qualifiée.
Les consommateurs actuels de réglages et F11 restent conservés. Aucun des trois noms onlyshowif,ONLYSHOWIF,InitializationData n’apparaît dans le corpus exact1168sources actuel. Cette recherche précise ne prouve pas l’absence d’un équivalent autrement nommé et ne supprime aucun acquis.

## R4 — Règle attestée et vérifications
**Virgule = ET entre groupes;barre verticale = OU dans chaque groupe.** Le prédicat compare les termes complets par Vector<String>.indexOf. Aucun trim,casefold ou découpage du deux-points dans ce prédicat. Une propriété onlyshowif absente ou non String contourne ce filtre;un type de modèle inconnu retourne null avant ce filtre. La construction ou le rendu effectif ne s’en déduit pas.
Cinq méthodes exportées,leurs instructions et branches sont reliées à une occurrence unique des mêmes octets dans le DoABC original. create fait248octets;InitializationData49. P-code et source corroborent les séparateurs,les boucles,le test strict contre-1 et le retour null. Aucun parseur de remplacement ni simulation fonctionnelle ajouté.
Les cas suivants sont des conséquences analytiques avec vecteurs hypothétiques,pas des exécutions AS/native :
|Cas|Garde|Environnement hypothétique|Type connu|Éligible à construction après ce filtre|
|---|---|---|---|---|
|V1|"game"|["game"]|True|True|
|V2|"game"|["windows"]|True|False|
|V3|"locale:en_us,summoner:Riot Phreak&#124;summoner:Phreak"|["locale:en_us", "summoner:Phreak"]|True|True|
|V4|"locale:en_us,summoner:Riot Phreak&#124;summoner:Phreak"|["locale:en_gb", "summoner:Phreak"]|True|False|
|V5|"game,windows&#124;mac"|["game", "mac"]|True|True|
|V6|"game, windows"|["game", "windows"]|True|False|
|V7|"GAME"|["game"]|True|False|
|V8|""|[]|True|False|
|V9|null|[]|True|True|
|V10|123|[]|True|True|
|V11|"game"|["game"]|False|False|

Expression Phreak authored : `locale:en_us,summoner:Riot Phreak|summoner:Phreak`. Elle exige le terme exact locale:en_us et l’un des deux termes summoner. Le cas V4 n’établit pas le tableau réellement émis par le client en_GB;aucune visibilité effective n’est revendiquée.

## R5 — Manques et reprise
Un environnement absent,null ou d’un autre type n’est pas validé par ces cas;aucun résultat d’exception/runtime inventé. Le filtre de modèle n’est pas une preuve de rendu complet,de permissions serveur ou de sélection de ressource. Les306exports ne valent pas306contrôles actifs.
- **OPTIONS-NATIVE-ENVIRONMENT-PRODUCER** — Manque : The host producer and actual value of InitializationData.environment for the supplied EUW/en_GB client are not established. Reprise : Start from the new exact InitializationData/environment/xml property names and native Options caller82D770/82E5D0 and their real dispatches;qualify emitted vector values,context and errors without substituting debug data.
- **OPTIONS-RESOURCE-CONTROL-GRAPH** — Manque : Actual physical movie/provider choice,InternalPanel content/applicability and full selected widget/callback graph remain open. Reprise : Use pinned variants and actual provider mapping/container or public applicability proof;do not repeat filename scans or choose a movie from its basename alone.
- **OPTIONS-RUNTIME-CURRENT-LIFECYCLE** — Manque : Native AS/runtime/GUI/exception outcomes and a current functional Options editor with apply/cancel/focus/persistence are not qualified. Reprise : Keep audit and implementation separate;reuse source chains and precise existing corrections. Product work and safe execution require their own scope;parent/global audit remain open.

## R6 — Correction réutilisée
**HUD-OPTIONS-XML-INPUTS-01** conservée sans changement de définition ni de registre. Sous-question frontend maintenant liée à un consommateur et une grammaire attestés;fiche toujours proposée,non appliquée,ouverte pour environnement natif/contenu/mapping/graphe complet. Aucune fiche concurrente.
Prochain résultat discriminant : producteur natif de InitializationData.environment et xml. Ne pas exporter à nouveau ces scripts à l’identique;réutiliser leurs empreintes et p-code. Ne pas reprendre les scans de fichiers sans nouveau provider/conteneur. HUD-OPTIONS-ENTRY-01 et HUD-NATIVE-MOVIE-SELECTION-01 restent ouverts.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-VISIBILITY-01\options-visibility-proof.json`. Exports,logs,reçus,scripts et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-VISIBILITY-01`. Relecture attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-VISIBILITY-01\delivery-readback.json`;elle seule peut clore le présent audit documentaire après les sept rubriques.
Cinq registres,25fichiers gelés et1168sources inchangés;Git HEAD/branche/76modifications antérieures conservés. Originaux et preuves antérieures conservés. Goal,critères,application de suivi,interface et bases inchangés;aucun accès runtime au suivi/bases,aucune installation ou migration.
Clôture limitée au consommateur et à la règle de filtrage frontend. SYS-17.5-01 et SYS-01.2-02 restent ouverts;78contrôles logiques antérieurs inchangés,aucune fonctionnalité/menu/jeu complet ou acceptation humaine déclaré terminé.
