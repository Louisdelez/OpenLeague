# Callbacks natifs et scripts communautaires : comparaison de portée

Ce lot affine les références et les recherches de 17 scripts communautaires. Aucun de ces scripts n’est déclaré entièrement fidèle ; les questions existantes, leurs identifiants et leurs historiques sont conservés.

## Sources originales et exécutions

Les 17 fichiers Lua examinés correspondent aux octets des projets sélectionnés par la solution native 4.20 EUW. Ils contiennent 56 prototypes de callback avec une liaison directe `CLOSURE/SETGLOBAL` : huit fonctions URF ne contiennent qu’un retour sans valeur et 48 corps contiennent d’autres instructions. Un callback vide du client ne démontre pas un serveur historique vide.

Le callback `InfernalGuardian.UpdateBuffs` contient sept instructions. Les 16 scénarios réussis du tour précédent sont relus, sans nouvelle exécution. Dans l’environnement explicitement fourni, il demande `SetScaleSkinCoef(paramètre3, paramètre2)` lorsque le troisième paramètre est inférieur à 1 : dix appels sont observés, y compris avec un paramètre négatif fourni. Le véritable producteur des arguments et l’implémentation de cette API restent inconnus. La recherche exacte de son nom dans le PE du jeu n’a pas trouvé d’occurrence ; ce résultat ne porte pas sur tous les binaires ou les mécanismes indirects possibles.

Six callbacks de cartes ont été exécutés dans ce tour, depuis cinq fichiers natifs : Map1, Map8, Map10, Map11 et Map12, avec une variante de tutoriel Map12. Les 552 instructions originales demandent 78 appels à `CreateChildTurret` ou `SpawnTurret`. Les noms, modèles, marqueurs d’équipe fournis et arguments numériques sont comparés à une reconstruction indépendante des arguments constants des instructions originales.

Ces expériences emploient Lua 5.1 fourni par Lupa. Les seules transformations du chunk concernent les longueurs de chaînes `size_t` 32/64 bits : retour 32 bits identique, tableaux d’instructions et constantes numériques conservés. Les fonctions moteur sont des observateurs. Map11 demande le partage `Spawning`, dont le corps n’est pas exécuté ; `SpawnTurret` est fourni explicitement. Les équipes sont des marqueurs symboliques, pas des numéros historiques déduits. Aucune tourelle réelle, VM du jeu, image, animation ou partie n’est qualifiée par ces observations.

## Classes homonymes et métadonnées d’Annie

Les deux classes communautaires `InfernalGuardian` sont distinctes : le sort est dans `Spells`, le buff dans `Buffs`. Le chargeur du sort sélectionne son namespace et le nom du sort ; le chargeur du buff demande `Buffs.<Name>`. Le moteur C# de scripts forme ce nom complet puis cherche son type dans une assembly chargée. Ces chemins sont lus dans leurs vrais consommateurs ; aucune présence d’assembly ni exécution du dispatch n’est déduite.

Quatre métadonnées littérales du sort concordent avec le chunk natif : `NotSingleTargetSpell`, `IsDamagingSpell`, `IsPetDurationBuff` et `SpellDamageRatio=0.5`. Le natif porte `DoesntTriggerSpellCasts=false` et la classe du sort porte `TriggersSpellCasts=true`. Ces booléens ont une polarité littérale cohérente ; les noms ne suffisent pas à prouver toute la sémantique des événements natifs. Le chargement C# enregistre effectivement ses listeners `OnSpellCast` et `OnSpellPostCast` sous sa condition `TriggersSpellCasts`. Il n’y a pas de contradiction déclarée à partir de cette seule paire de noms.

Une recherche des usages directs des quatre autres propriétés dans `GameServerLib` n’a pas renvoyé de correspondance. Elle n’exclut pas une réflexion, une assembly externe ou un autre traitement. Le ratio de métadonnée 0.5 ne remplace pas arbitrairement le coefficient de puissance 0.8 du calcul de dégâts courant : ce sont des champs et des consommateurs différents dont l’équivalence ne doit pas être inventée.

## Une association par nom refusée pour Map10

Le `CreateLevelProps` natif de Map10 demande des tourelles. La classe communautaire `Maps/Map10/CreateLevelProps.cs` appelle `AddLevelProp` pour des décors. Le script de niveau communautaire appelle séparément `LevelScriptObjects.LoadObjects(mapObjects)` et `CreateLevelProps.CreateProps()`. Le premier chemin demande des tourelles via `CreateLaneTurret`.

Le nom de fichier commun ne rend donc pas ces deux fonctions interchangeables. Les cinq candidats natifs des différentes cartes restent distincts ; aucune sélection arbitraire ne résout les cas Map4 ou les autres contextes. Cette distinction ne constitue pas encore une comparaison complète des tours, modèles, positions, protections ou règles de chaque carte.

## Consommateurs actuels et vérification

`tools/project-plan/audit_native_community_callbacks.py` consomme les sources et observations. Il vérifie les fichiers, les manifestes, les prototypes, les formats adaptés, les arguments, les limites et les ancres réelles. Les sources Rust existantes du dispatch d’Annie, de `cast_tibbers` et d’`advance_pet_orders` sont identifiées ; aucun test Rust ni raccordement de `SetScaleSkinCoef` n’est revendiqué.

La qualification passe 36 contrôles, dont 34 refus d’observations altérées et un contrôle positif de représentations JSON entière/flottante d’un même nombre Lua. Les anciens essais erronés sont conservés : booléen supposé d’après son nom, arité moteur supposée et deux ancres C# devinées avant la lecture exacte de `CreateLaneTurret`. Les expériences réussies et les échecs ne sont pas confondus.

Le reçu conserve les commandes, empreintes, versions, instantanés Git et distinctions entre exécutions héritées et nouvelles. Les sources communautaires restent des instantanés modifiés précisément identifiés, pas des octets automatiquement attribués au commit amont. Les cas et notes manuels du plan ne sont pas modifiés.

Restent à démontrer : implémentation native de l’API de coefficient et origine des arguments, dispatch original, corps du partage Map11 et effets moteur, consommateurs effectifs des métadonnées, comparaison complète des règles des 17 scripts et correspondances Rust. Les deux plafonds de maîtrise et les autres objectifs partiels restent également ouverts. Ce lot ne termine ni la fiche, ni un champion, ni le jeu.
