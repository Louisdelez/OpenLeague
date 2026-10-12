# Préparation suivante : ressources du chargement standard

Statut : **préparation non intégrée**. Aucun fichier de production modifié, aucun compilateur ou client exécuté. Les preuves de cache utilisent des **tokens de fixture empruntés**, jamais des providers utilisables. Ni construction ni destruction d’un cache peuplé de vrais providers, ni chargement UI non vide complet ne sont qualifiés par ce lot.

Source : PE 4.20 épinglé, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Les régions, leurs octets, les appels et leurs empreintes sont dans les trois `source_*regions.json`. `resource_xrefs_candidates.json` contient des candidats d’opérandes ; leurs occurrences ne constituent pas toutes des instructions ou des producteurs confirmés.

## Producteur réel du gestionnaire

`592E3A → 90B7C0 → allocation172 → 90A4C0 → publication2D78F1C à90B807`. La branche allocation nulle publie zéro à90B81B ; elle n’est pas exécutée par l’oracle. Le constructeur ne publie pas le global avant de terminer.

Le constructeur172 crée neuf sentinelles : arbres aux offsets `+04,+0C,+14,+1C`, puis arbres des providers embarqués `+2C,+40,+54,+70,+88`. Il inscrit quatre providers embarqués dans l’index de hash `+1C` :

| Provider embarqué | Clé globale | Producteur statique | Chaîne source | Hash natif |
|---|---|---|---|---|
| manager+24 | 2D6EDF0 | 531A50 | [Configuration] | 3CBB5E22 |
| manager+38 | 2D6EDFC | 531B10 | [Interface] | 0F16597F |
| manager+80 | 2D6EDF8 | 531A90 | [Shared] | D553FFBD |
| manager+94 | 2D6EDF4 | 531AD0 | [Forwarding] | 1737ABA5 |

Les adresses de ces quatre producteurs figurent dans la table statique `FA6B74..FA6B80`. Leur exécution complète est incluse. Lire seulement les zéros initiaux du PE ferait se confondre les quatre clés : ce serait un mauvais état de démarrage. Le constructeur qualifié possède quatorze allocations : objet172, neuf sentinelles et quatre nœuds d’index.

Après publication, `592E49..592E6A` écrit les six backpointers `+28,+3C,+50,+6C,+84,+98 = manager`, puis `byte+A8=1`. Ce fragment natif est également exécuté, avec `EAX=manager` comme précondition explicite. Le démarrage entier autour de592E30 n’est pas exécuté.

Le shutdown extérieur lit `2D78F1C` à591038, appelle virtual0 avec `1` à591050, puis efface le global à591058. La table manager `10D6450` donne `90A760 → 90A800 → 90AAB0`. Le destructeur garde le global visible pendant sa propre exécution ; il ne le remet pas à zéro lui-même.

`90AAB0` possède réellement les providers : virtual0 sur les valeurs de l’arbre `+14`, puis virtual0 sur chaque `node+2C` du cache `+0C`, enfin libération des objets32 de l’arbre noms `+04`. Les providers embarqués et les arbres sont ensuite détruits dans90A800. **L’oracle efface d’abord ses nœuds de cache diagnostiques par le vrai5C2AB0 ; il qualifie ensuite la destruction du manager à caches de providers vides.** Il ne remplace pas virtual0 par un succès fictif.

## Contrat exact de90AD00

ECX est le gestionnaire ; arguments `String24* nom`, `u32 skin`, troisième mot opaque ; `ret0C`. Seuls les deux premiers arguments alimentent la recherche.

`99A310` ne fait pas une simple copie : il construit une String24 par564AF0, puis **normalise toute sa longueur en minuscules** via `5FA650 → C98719`. L’oracle exécute la branche C initiale `14AE870==0` : ASCII A–Z est abaissé, les autres octets sont conservés, y compris NUL intégré et octets hauts. La branche d’une autre locale versC985D6 reste non qualifiée.

La clé temporaire est `String24 + skin à+18`. L’arbre `manager+0C` utilise `90D220` puis `901F00` pour confirmer l’égalité. Comparaison des noms par longueur/octets ; skin ordonné comme u32. Le retour d’un hit est **node+2C emprunté**, sans incrément de référence. Le temporaire est libéré par564900 ; les noms de16 octets ou plus peuvent donc allouer et libérer même pour un hit.

Sur miss, `90B520` reçoit le **nom original** et le skin original ; la normalisation n’écrase pas l’entrée. Les huit cas miss s’arrêtent à son entrée avant la première instruction. Une destruction564900 séparée retire le temporaire abandonné, avec pile distincte et restauration explicite de la chaîne FS : ceci ne prouve ni retour normal d’un miss, ni SEH, ni rollback natif d’exception.

## Dépendances du vrai miss et des chemins

Ordre source dans90B520 : nouvelle recherche normalisée ; allocation56 ; `90B4A0 → 90B360 → 903030` pour l’objet32 des répertoires du champion ; construction provider56 par9034D0 ; publication dans le cache `+0C` via90CEF0 ; lecture de l’héritage INI ; assignation parent905000 ; index de hash `+1C` via5BD9B0 ; callback24 enregistré par90B270.

Le constructeur9034D0 reçoit comme premier argument **le global2D78F1C relu**, et non forcément son appelant manager. Son dernier argument est l’objet32 renvoyé par90B4A0. La publication du provider précède les lectures INI et l’enregistrement final : un port ne doit pas transformer arbitrairement ces publications en opération atomique.

Le provider final a la vtable `10D64A8`, treize entrées jusqu’à+30. `+1C=903EE0` résout un chemin, `+28=9041E0` teste sa présence, `+2C=905000` assigne le parent. **903880 est un rafraîchissement, pas un scalar delete.** Après la vtable, `/defaults` est une chaîne ; ce ne sont pas d’autres méthodes.

`90B520` construit `nom + ".ini"`, teste la présence via+28, puis résout via+1C. L’INI consulté est **[Package]FallbackPackage** (`10867F8`/`10D69DC`) par8B0630, et non [Data]. Valeur vide : parent `manager+80` ([Shared]). Valeur non vide : appel récursif90AD00 avec ce nom parent et le même skin, puis assignation905000. Aucun résultat INI ou parent n’est fabriqué dans ce lot.

Les racines utilisent la liste `2D78F20`. Son initialisation9063E0 est appelée à592F27. Elle lit `./ToolsConfig.xml` et `OverlayParenting`, puis construit le contexte par9062A0 ; le défaut absent est déjà préparé dans `E:\OpenLeague\data\4.20\search_context_defaults_contract.json` (preuve antérieure à relire avant raccord).

`903030 → 9030C0` remplit des tables par contexte : d’abord `Shared/GlobalCharacter`, puis `Characters/<nom>`. `906920` joint la racine contexte+64 (défaut DATA), `906A20` la racine+1C (défaut Content/Src). La population par901F60 appelle905620 pour plusieurs sous-répertoires. `character_directory_populate.txt` est une **extraction partielle de2304 octets avec sortie de fenêtre** ; elle n’est pas une qualification de cette fonction entière. Les règles d’alias `.inibin → .ini` et `.dds → .tga`, ainsi que des parseurs INIBIN, existent déjà dans le client ; leur existence ne suffit pas à qualifier le provider champion actuel.

Les méthodes903EE0 et9041E0 ne sont pas de simples lectures d’une table : elles peuvent créer les nœuds des contextes manquants. Elles parcourent d’abord les tables du provider, puis celles de son objet32, puis son parent selon les règles source. Une liste de contexte vide ne permet pas d’inférer un chemin d’asset utilisable.

## Suite de57D775 et producteur de table

Après retour du provider, `57D77A` relit la clé8 dans le payload `+4/+8` puis cherche la première égalité parmi **12 lignes de181 octets**, table `14C7630`. Match : pointeur de ligne emprunté vers record+1C, u16 ligne+8 étendu vers record+48, puis identifiant u32 ligne+0A passé à57C590 avec provider enEDX. La seconde icône prend ligne+0E. Absence : continuation57D901.

Le producteur confirmé est **57C930**, appelé à58A51E avec `ECX=packet+0A`. Il copie exactement180 octets par45movsd puis1movsb pour chacune des12 lignes. Il efface seulement le premier octet du champ rang àligne+97 pour UNRANKED ou BRONZE, comparés sans distinction ASCII de casse parC9CF31/C9CEF8 dans la locale C. L’oracle vérifie les12 lignes, les gardes, la source conservée et des matches0/5/11 ainsi que l’absence. Le paquet complet et son producteur extérieur ne sont pas qualifiés.

La suite déjà auditée dans `loading_standard_ui_preparation` reste nécessaire :57C590 résout les icônes à partir d’identifiants,98A7F0 possède les textures et leur cache,815CF0 résout l’icône de profil,8B0630/localisation donnent le nom, les variantesLoadScreen sont cherchées avec fallback, puis993CE0 renseigne l’horloge. Aucune de ces opérations n’est remplacée par un token dans le chemin normal.

## Résultat borné et prochaine action

- Deux cycles manager natifs, mémoire initiale0 etA5 ;66 hits, huit arrêts avant la factory ;2183 adresses d’instructions exécutées distinctes dans `native_resource_oracle.json`.
- Huit cas publication/sélection de table ;100 adresses exécutées dans `native_table_oracle.json`. Les instructions de frontière avant lesquelles l’émulation s’arrête sont exclues de ces compteurs.
- Tous les octets d’instructions exécutés sont comparés au PE épinglé par le hook. Seules allocation/libération et copies mémoire sont adaptées. Aucune compilation ni exécution du jeu.

La prochaine intégration concrète est le **cycle réel du manager172** avec producteurs statiques, backpointers post-publication, neuf conteneurs et destruction à état vide, puis la recherche90AD00 avec copie normalisée temporaire et retour emprunté. Conserver les noms originaux pour la factory ; ne pas publier un manager partiel depuisconfigure_service.

Pour obtenir un chargement non vide réel, la tranche suivante doit construire l’objet32 et le provider56 sur les vraies racines et listes de fichiers du client4.20, avec le même ordre de population, puis résoudre un INIBIN et unLoadScreen existants par903EE0/9041E0. Reprendre les parseurs/aliases déjà présents seulement après vérification de leurs contrats et de l’ordre. Qualifier le miss complet, l’héritage, les callbacks et la destruction des providers réels avant l’activation du chemin UI. Le port du manager et les hits seuls ne constituent pas cette activation.

Limites communes : allocation en succès ; pas de panne d’allocateur, callbacks mutateurs, concurrence, OOM, SEH, renderer, événement normal de jeu ou écran effectivement affiché. Les cas ne prouvent pas l’intégralité de la simulation/réseau.
