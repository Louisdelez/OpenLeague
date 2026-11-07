# SYS-01.2-02 — ITEM-3116-SCOPE : Rylai's Crystal Scepter

Audit documentaire du 2026-11-03. Exigence parente : OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Périmètre de ce lot : relier la source native, la référence 4.20.1 et le consumer de boutique courant pour l’ID 3116. La tâche ITEM-3116-SCOPE reste a_qualifier; aucune fonctionnalité n’est déclarée terminée.

## Critère de fin du sous-lot

Établir l’identité et les valeurs reçues, les comparer à une source versionnée, relever la présence ou l’absence dans les données réellement chargées et établir le résultat statique du consumer. Séparer explicitement cette liaison de la disponibilité historique Map10 sur le client PUBLIC 4.20.0.315.

## Prérequis et périmètre

Le registre classe ITEM-3116-SCOPE en D07, sans dépendance de tâche. Le paquet D07-ITEM-3116 indique depends_on=[] et requires_packages=[]; la phase D07 n’a pas de dépendance de phase. Cela permet ce sous-audit documentaire, sans satisfaire ni contourner les gates globaux du goal.

Inclus : identité, valeurs natives reçues, comparaison au catalogue officiel 4.20.1, données de boutique actuelles, chemin statique de refus. Exclus : implémentation des statistiques, passif de ralentissement, achat/vente runtime, affichage, réseau, comparaison du client exact au runtime et acceptation humaine.

## Sources et valeurs

Preuve native réutilisée sans rehash depuis docs/reference_item_shop_sources/item_shop-links.json, facts.native_items.3116 :

- Source enregistrée : DATA/Items/3116.inibin, 527 octets, SHA-256 f90f5d694a1058fb252f634644b1ed9d506128f0bbaaaabbf70a4effd32c2b1b, MD5 04075450e0fa8bb67c81e17be701da74.
- Membership enregistré : membre DATA/Items/3116.inibin de lol_game_client projet 0.0.1.7, version du membre 0.0.0.243; taille et MD5 concordants. Le fichier enregistré à l’emplacement source D: est présent au contrôle de reprise. La précédence effective du provider runtime n’est pas qualifiée.
- Champs natifs consignés : Price=605, InStore=1, CanBeSold=1, UseEffect=0, UseWhenAcquired=0, MaxStack=1, recette 1026+1052+1011. Le reçu ne donne pas de décision par carte.

Référence officielle comparative : [Data Dragon 4.20.1, item.json](https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/item.json). La version et l’entrée 3116 ont été vérifiées à l’URL officielle. La preuve locale de source complète conserve SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1 dans l’en-tête de data/4.20/map10_shop_admission.json; ce hash est réutilisé, non recalculé ici. L’entrée indique Rylai's Crystal Scepter, base 605, total 2900, vente 2030, composants 1026/1052/1011, +400 Health, +100 Ability Power et ralentissement décrit à 35 % pendant 1,5 s (15 % pour les sorts multi-cibles et dégâts sur la durée). L’entrée individuelle 3116 ne porte pas de champ maps; les valeurs maps de l’objet basic ne constituent pas une qualification spécifique de cet item.

La référence officielle est 4.20.1. Elle sert de comparaison, pas de preuve équivalente au build client PUBLIC 4.20.0.315, à la date exacte du build ni à son déploiement régional.

## Consumer actuel et résultat attendu / constaté

Contrôle statique des fichiers consommés :

- data/4.20/shop_foundation.json contient 33 définitions et aucune entrée id=3116.
- data/4.20/map10_shop_admission.json contient 33 admissions et aucune entrée id=3116. Son en-tête référence Data Dragon 4.20.1; il ne prouve pas une admission historique du client.
- Dans crates/core/src/shop.rs, quote_with_counts fait le lookup de l’objet et renvoie item behavior not implemented si sa définition manque (ligne 86). Simulation::buy_item vérifie d’abord le shop guard, puis fait le même lookup (lignes 261–263). Si une définition était ajoutée sans décision d’admission, le chemin atteindrait ensuite item map availability not qualified (lignes 266–270).

Attendu comparatif si l’objet est historiquement autorisé, correctement intégré et acheté : recette 1026+1052+1011, coût total catalogue 2900, valeur de vente catalogue 2030 et statistiques/passif décrits ci-dessus.

Constat actuel observé par lecture des deux tables et du code : définition et admission absentes; le refus item behavior not implemented est le résultat statique prédit pour une requête qui satisfait le shop guard. Aucun achat direct ni exécution de ce chemin n’a été effectué; ce n’est pas un résultat runtime observé.

## Écarts et condition de reprise

L’INIBIN prouve une entrée générique vendable en magasin (InStore=1), mais ne nomme pas Map10. Le JSON 4.20.1 ne fournit pas de propriété maps spécifique à 3116. L’absence dans OpenLeague prouve un manque d’implémentation/admission locale, non une interdiction historique. La mécanique de ralentissement, ses interactions et les exceptions par type de sort restent non qualifiées dans le serveur OpenLeague.

Reprendre la disponibilité Map10 uniquement avec une table native de marchand/admission reliée au build 4.20.0.315, un lecteur/callsite de cette table identifié, une source Riot datée qui tranche cette carte, ou une observation reproductible du client exact. Reprendre le passif seulement avec une source primaire de comportement ou un callsite serveur/client interprété. Ne pas refaire les hashes, le contrôle générique du shop ou une recherche inchangée sans indice nouveau.

Les corrections de statistiques, passif, shop, icône, texte, prix, recette et acceptation sont des objectifs distincts déjà représentés dans le paquet D07; aucun n’est clos ici.

## Vérifications exécutées et décision

Exécuté le 2026-11-03 : lecture ciblée de la tâche et du paquet D07; réutilisation du reçu natif/membership; contrôle de présence du fichier source; lecture directe de la référence officielle 4.20.1; comptage des deux tableaux et recherche de l’ID 3116; inspection du lookup/refus dans shop.rs. Résultat : la liaison statique source → référence → consumer est établie pour ce périmètre.

Non exécuté : rehash ou redécodage, test direct, build, lancement client, achat, passif, rendu, réseau ou acceptation humaine. git status a échoué avec Permission denied lors de la lecture; aucun staging, reset, fetch ou autre opération Git n’a été lancé.

Décision : sous-audit statique de cette liaison terminé. Qualification complète de ITEM-3116-SCOPE non terminée, car l’admission Map10 exacte reste inconnue. Implémentation, vérification runtime et acceptation humaine non terminées/non exécutées. Le goal parent SYS-01.2-02 reste partiel.

Aucun code, registre de tâches, plan, goal, application de suivi, base de données, installation ou migration n’a été modifié.

## Addendum V1074 — indice natif sur les items Map10 et ambiguïté du format (2026-11-03)

### Nouvelle preuve limitée

Le reçu natif Map10 déjà établi en V1025 est réutilisé sans rehash : deploy/LEVELS/Map10/Items.inibin, 657 octets, SHA-256 2E0E874E036429FEE1BDA6C5D1942F8E217EDA7468B6B5BEA5EAC0A4288456F7, MD5 FE5E2701DD444CDAA118C5A922DBA9D5. Une lecture ciblée avec le décodeur existant tools/project-plan/reference_inibin.py retourne 98 paires et 95 valeurs intégrales distinctes; aucune valeur scalaire ou composante de liste ne vaut 3116. Cette lecture répond à la présence du nombre dans ce fichier, pas à la sémantique des clés.

Le recensement V996–V997 réutilisé dans le rapport V1025 relève que les 85 IDs dont Data Dragon 4.20.1 marque explicitement maps[10]=false sont tous présents dans cette liste, alors qu’aucun item explicitement maps[10]=true ne l’est. Ce résultat avait suggéré une liste d’exclusion, mais n’identifie ni le nom de la propriété ni son consommateur natif.

### Indice direct dans le PE

REA 6.4.0/Ghidra a ouvert le client natif League of Legends.exe comme PE x86; l’identité retournée est SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, cohérente avec le reçu antérieur. Une lecture ciblée des octets PE32 trouve en .rdata, offset fichier 0xC7F218 / adresse 0x107F218, le texte : “Only the items explicitly listed in LEVELS\[MapName]\Items.ini will be in the store.” Elle trouve aussi la chaîne map10 en .rdata, offset 0xC8D234 / adresse 0x108D234. Une référence absolue au pointeur 0x108D234 apparaît en section .text à l’offset 0x199A25 / adresse 0x599A25 pour opcode push imm32 (68 34 D2 08 01); immediat a 0x199A26 / 0x599A26. Cela confirme une référence de code à la chaîne map10, sans identifier sa fonction.

Le texte parle de Items.ini, alors que le seul fichier trouvé par la recherche bornée aux noms sous deploy/LEVELS est Items.inibin pour Map1, Map8, Map10, map11 et Map12; aucun Items.ini n’y a été trouvé. Le balayage direct du PE n’a pas trouvé le littéral Items.inibin en ASCII ou UTF-16. Le lien entre le contrat textuel Items.ini, le fichier binaire Items.inibin et les 98 paires décodées reste donc à démontrer.

### Tentative REA et limite constatée

Trois appels REA n’ont pas retourné de résultat exploitable : search_strings sur Items.inibin, xrefs de 0x107F23C et resolve_containing_procedure pour 0x599A26 ont chacun expiré après leur délai de 180 s. Dans chaque session, open_binary a confirmé le même SHA/architecture et close_binary a accusé fermeture. Le jeu n’a pas été exécuté. Les reçus sont conservés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/ :
- revision1074_item3116_map10_rea/receipt.json
- revision1074_item3116_map10_rea_xrefs/receipt.json
- revision1074_item3116_map10_mapname_ref/receipt.json

Un délai dépassé n’est pas un xref vide ni une preuve d’absence. Les mêmes requêtes REA n’ont pas été relancées.

### Conclusion et reprise

Le texte PE suggère une whitelist Items.ini; l’ancien rapprochement de la liste Items.inibin suggère plutôt une exclusion. Ces deux indices portent des formats dont le lien n’est pas établi et ne doivent pas être fusionnés. L’absence de la valeur 3116 dans Items.inibin ne permet donc de conclure ni que Rylai est absent du magasin Map10, ni qu’il y est admis. La disponibilité sur le client exact PUBLIC 4.20.0.315 demeure inconnue; ITEM-3116-SCOPE reste a_qualifier.

Reprendre uniquement avec l’Items.ini original de Map10 attribuable au build, une correspondance vérifiable entre le format INI et les champs de l’INIBIN, un callsite natif du loader obtenu sans répéter les mêmes appels REA expirés, ou une observation reproductible du client/serveur exact. Ne pas refaire le hash, le census V996–V997, ni la recherche générique du consumer shop. Aucun statut n’est modifié.

### Recherche exacte des sources Items.ini

Recherche de noms avec rg --files --hidden --no-ignore -g **/Items.ini dans D:/LeagueOfLegendsV2/4.20, F:/OpenLeague et F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : zéro chemin retourné. Cette borne ne couvre pas les autres volumes ni des archives non extraites. Recherche GitHub ciblée : LeagueSandbox/GameServer pour Items.ini et LeagueSandbox/LeagueSandbox-Default pour Items.inibin Map10, zéro résultat. Les recherches Web exactes sur LEVELS/Map10/Items.ini et le texte de whitelist n’ont pas retourné de résultat. Ces réponses négatives ne prouvent pas l’absence d’une copie ailleurs; elles confirment seulement que la ressource n’est pas récupérée dans les emplacements et index consultés. Reprise sur une copie originale attribuable à Map10/4.20.0.315 ou une source primaire qui documente la conversion INI→INIBIN.

## Addendum V1075 — listes natives distinctes et correction V1074 (2026-11-03)

Les preuves de V1074 sont conservées; leur interprétation et deux adresses sont corrigées ici. Le texte complet du PE commence à l’offset 0xC7F218 / VA 0x107F218; 0xC7F23C / VA 0x107F23C désigne le mot LEVELS à l’intérieur de cette chaîne. Les deux antislashs de son chemin ont été rétablis dans la citation. La référence à map10 est un push imm32 dont l’opcode commence à 0x199A25 / VA 0x599A25; 0x199A26 / VA 0x599A26 est le début de son immédiat. Les requêtes REA de V1074 visaient bien les adresses alors enregistrées et restent des délais dépassés, sans résultat de résolution.

### Vérification des clés Map10

La ressource LEVELS/Map10/Items.inibin reste celle du reçu V1025 : 657 octets, SHA-256 2E0E874E036429FEE1BDA6C5D1942F8E217EDA7468B6B5BEA5EAC0A4288456F7, non rehashée dans ce lot. Le lecteur tools/project-plan/reference_inibin.py donne 98 paires. Les 98 clés calculées par hashkey('UnpurchasableItemList','ItemN'), pour N de 0 à 97, correspondent exactement aux 98 clés du fichier : zéro clé attendue manquante, zéro clé supplémentaire, 98 hachages distincts. Exemples : Item0=1062, Item1=1063, Item2=2043 et Item97=2048. Aucune valeur normalisée ne vaut 3116. Une lecture indépendante avec tools/references/lolpytools/lolpytools_inibin2.py concorde sur les 98 clés et les valeurs normalisées.

### Chaînes et références du PE

Le PE client identifié en V1074 contient les chaînes distinctes ItemInclusionList, UnpurchasableItemList, Item%d, it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly. Les octets du code contiennent des push vers ItemInclusionList à 0x5B6764 et UnpurchasableItemList à 0x5B67D5; les séquences proches appellent toutes deux l’adresse 0x8B1A80. Les push de Item%d sont à 0x5B6737 et 0x5B67A8. Les noms des deux paramètres d’inclusion sont référencés à 0x4F29F4 et 0x4F2A74. Ce contrôle établit les références statiques et le rapprochement des hachages; il ne qualifie ni l’exécution du helper ni la décision finale du magasin.

Le texte de liste d’inclusion et la liste UnpurchasableItemList peuvent donc coexister : l’opposition supposée en V1074 ne constitue pas une contradiction démontrée. L’absence de 3116 de la seconde liste indique seulement qu’il n’est pas listé dans cette ressource comme item non achetable; elle ne suffit pas à prouver l’admission complète.

### Résultat et reprise

Une recherche ciblée des noms des paramètres dans les fichiers ini, cfg, lua et txt du deploy sélectionné n’a pas trouvé leur valeur. Le contrôle des sections candidates Data, Globals, Game, Map, ItemShop, Items, ItemData et des sections de listes dans l’INIBIN Map10 n’a pas retrouvé ces clés. D’autres sections, providers et valeurs par défaut restent possibles; aucune valeur effective n’est déduite des octets voisins.

Sous-audit statique de l’identité des clés et des références de listes terminé. Valeurs effectives des paramètres d’inclusion, montage runtime, liste d’inclusion et achat historique restent ouverts; ITEM-3116-SCOPE demeure a_qualifier, sans acceptation ni implémentation déclarées. Reprendre sur un constructeur/consumer ou une configuration primaire établissant ces valeurs, ou sur une observation reproductible du client/serveur exact. Ne pas rejouer les appels REA expirés, rehash ou reprendre le census inchangé sans indice nouveau. Les fichiers de suivi, statuts et goal ne sont pas modifiés.

## Addendum V1076 — ITEM-3116-SHOP-ICONE : liaison et fidélité de l’asset (2026-11-03)

Exigence de traçabilité : OLF-453ac110-0569-50b9-9b28-27533e9717c3. Lot limité à l’identité de l’icône native, aux copies locales et au chemin statique de la boutique. La tâche ITEM-3116-SHOP-ICONE est a_faire, dépend de ITEM-3116-SCOPE et conserve implementation_complete=false et acceptance_complete=false.

### Source et comparaison

Le lecteur INIBIN existant donne Data/InventoryIcon = 3116_Rylais_Sceptre.dds pour DATA/Items/3116.inibin. Le DDS correspondant est dans deploy/DATA/Items/Icons2D; 4 224 octets, SHA-256 3fa88365cb7f2092c4f0a833849d82f6296bfac7b0389941eb598e9d61b2c8e2, MD5 0f4d901b29bfb2f438de6c3f4393b874. Le registre source OLS-99067420-4c23-5bf5-9bff-e1b4c790c136 consigne la correspondance avec le projet lol_game_client 0.0.1.7, membre 0.0.0.25, et ce MD5; le manifeste n’a pas été reparsé dans ce lot et la précédence runtime reste non qualifiée.

Les copies assets/ui/items/3116.png et assets/ui/sc4/runtime/Items/Icons2D/3116.png sont chacune de 6 536 octets et ont le même SHA-256 3b46b38d190cdf4edf1bc5300756901150f7cb7e93911f3991f5867b8b9f3035. Les trois images mesurent 64×64. Le décodage réel avec FFmpeg 8.1 en RGBA a retourné le code 0 pour chacune, 16 384 octets par image, même SHA-256 des pixels 683101bef4163ea15419826014a662e17cc3b275c899c5c47e547378de86b20b et comparaison directe égale. Ce contrôle porte sur les pixels décodés; il ne prouve pas un rendu écran.

### Consommateur, attendu et observé

crates/client/src/shop_ui.rs:57–60 construit le catalogue à partir des objets dont map10_available vaut Some(true). Les lignes 228–233 créent ensuite CatalogIcon avec ui/items/{id}.png; crates/client/src/main.rs:809 et :825 enregistrent setup et update. Le chemin SC4 est une copie distincte; sa présence ne démontre pas son utilisation par cette boutique.

Attendu pour une ligne 3116 admise et rendue : charger la PNG associée à 3116, dont les pixels correspondent au DDS natif. Observé statiquement : shop_foundation et map10_shop_admission contiennent chacun 33 entrées et omettent 3116; la ligne de catalogue et son chargement ne sont donc pas atteints pour cet ID dans ce chemin. native_inventory_icons.json comporte aussi 33 entrées et omet 3116; ce manifeste est un chemin d’inventaire distinct. Aucun affichage ni refus UI en runtime n’a été observé.

### Clôture limitée

Exécuté : lecture du champ natif, recalcul des SHA/MD5 des trois assets, trois décodages FFmpeg et comparaison RGBA, inspection des tables et du code réellement consommateur. Réutilisé : membership RADS enregistré, sans nouveau parsing de manifeste. Non exécuté : lancement OpenLeague ou client historique, rendu GPU, achat, contrôle de taille/filtrage à l’écran, réseau ou acceptation humaine.

Audit statique de fidélité des pixels et liaison au chemin boutique terminé. Disponibilité Map10 historique, définition/admission 3116, affichage réel, fonctionnalité et acceptation restent ouverts. Reprendre après qualification de ITEM-3116-SCOPE et intégration de l’entrée : observer la ligne et l’icône en runtime, vérifier les refus et comparer le rendu à la référence. Aucun statut, code, goal, plan, application de suivi ou base modifié.

## Addendum V1077 — ITEM-3116-SHOP-TEXTE : source en_GB et consumer (2026-11-03)

Exigence OLF-2f009f0d-2011-50fe-afaa-35f92d462fe1; tâche ITEM-3116-SHOP-TEXTE a_faire, dépendant de ITEM-3116-SCOPE. Audit limité à la liaison statique entre les clés natives 3116, les chaînes en_GB et le consumer de boutique actuel.

Le lecteur INIBIN existant a été exécuté en lecture seule sur DATA/Items/3116.inibin. Les champs Data/DisplayName, Data/Description et Data/DynamicTooltip donnent respectivement game_item_displayname_3116, game_item_description_3116 et game_item_tooltip_3116. Le fichier natif deploy/DATA/menu/fontconfig_en_GB.txt porte ces clés aux lignes 7532, 6768 et 8570. Son identité enregistrée OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d : 2 220 957 octets, SHA-256 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3, membre du projet lol_game_client 0.0.1.7. Ce reçu est réutilisé sans rehash ni qualification de précédence runtime.

La source en_GB décrit Rylai's Crystal Scepter, +400 Health, +100 Ability Power, un ralentissement de 35 % pendant 1,5 seconde et 15 % pour les sorts multicibles ou dégâts sur la durée. Le tooltip contient aussi le jeton de vente @Value@. Ces chaînes décrivent une référence client; elles ne prouvent pas la mécanique serveur ni le remplacement effectif du jeton.

Dans crates/client/src/shop_ui.rs:57–60, le catalogue est filtré par admission Map10; :228–234 crée les lignes à partir de item.name et du prix. Le détail :420–427 affiche i.description provenant du catalogue et ne remplace explicitement que {regen_5s}. Les libellés génériques du chemin inspecté sont français. La recherche bornée dans crates/client/src, launcher/src et launcher/src-tauri/src ne trouve ni les trois clés 3116 ni fontconfig_en_GB : elle ne couvre pas tous les consommateurs possibles de l’application. 3116 est absent des deux tables shop_foundation et map10_shop_admission; aucune ligne 3116 n’est construite par ce chemin normal.

Attendu de référence : nom, description et tooltip en_GB de la source native, y compris une valeur de vente correctement injectée si le tooltip original est reproduit. Observé statiquement : les clés et chaînes natives existent, mais le consumer courant utilise les champs du catalogue local; la ligne 3116 manque et la résolution de @Value@ n’est pas établie. Aucun affichage ni remplacement dynamique n’a été exécuté.

Vérifié : lecture directe des trois champs et des trois lignes de locale, inspection du consumer et des tables, recherche bornée des consommateurs et des rapports antérieurs. Réutilisé : identité et membership de la locale; le reçu collectif item33 ne couvre pas 3116. Non exécuté : interface runtime, rendu de texte, injection de valeur, comportement serveur et acceptation humaine.

Audit statique de liaison terminé. La tâche texte reste a_faire; admission historique, entrée catalogue, stratégie de locale, tooltip dynamique, rendu et acceptation restent ouverts. Reprendre après ITEM-3116-SCOPE et intégration de 3116 : relier la locale ou qualifier une autre stratégie, puis vérifier nom, description, valeur de vente et refus dans le runtime. Aucun registre, statut, goal, plan, application de suivi ou base modifié.

## Addendum V1078 — paramètres natifs de la liste d’inclusion (2026-11-03)

Question ciblée : les zéros de construction des deux paramètres suffisent-ils à établir la règle Map10 effective ? Source : League of Legends.exe PE x86 identifié par REA au SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 en V1074. Ce SHA est réutilisé; aucun jeu n’a été exécuté. Les instructions ont été lues depuis ce PE avec Capstone 5.0.6 déjà présent dans E:/mapslol3v3/tools/capstone-5.0.6, via Python du dépôt et les sections PE. Aucun logiciel n’a été installé.

Les constructeurs à 0x4F29F0 et 0x4F2A70 référencent respectivement it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly. Ils écrivent zéro à 0x4F2A56 dans le champ 0x12396EC et à 0x4F2AD6 dans 0x12396FC. Ce sont des valeurs d’initialisation, pas des valeurs effectives observées en partie.

Le code à partir de 0x5B6600 compare ces deux champs à zéro à 0x5B666A et 0x5B6673. Le byte 0x14CD2D1 est mis à 1 si le premier champ est non nul, ou si le second est non nul et que la comparaison entre la chaîne fournie par 0x5B26E0 et TUTORIAL retourne zéro. Le constructeur 0x4F1770 initialise la chaîne globale à partir du littéral TUTORIAL à 0x10863BC. Le comparateur possède un chemin de comparaison ASCII insensible à la casse et un chemin dépendant de la locale; la provenance et le sens runtime de la chaîne fournie par 0x5B26E0 restent à qualifier.

À 0x5B6724, ce byte commande l’entrée dans la boucle utilisant ItemInclusionList; la boucle UnpurchasableItemList commence séparément à 0x5B679F. Cela précise les références V1075 et explique comment les deux listes peuvent coexister.

Une modification indirecte est possible : les deux objets à 0x12396E0 et 0x12396F0 reçoivent la table 0x1084F24, dont la première entrée pointe sur 0x574A30. Cette procédure appelle 0xC98A11 avec le format %d puis, si le retour vaut 1, écrit la valeur temporaire au décalage +0xC de l’objet à 0x574A53, qui correspond aux champs ci-dessus. Le dispatch vers cette méthode, le contenu d’entrée et la source de configuration n’ont pas été établis.

Contrôle borné des références directes : la recherche des quatre octets little-endian de chaque adresse dans la section .text brute [0x1000, 0xBA4000) trouve le premier champ aux VA 0x4F2A58 et 0x5B666C, et le second aux VA 0x4F2AD8 et 0x5B6675. Cette recherche ne couvre ni alias ni écriture indirecte et ne prouve pas que les zéros persistent.

Résultat : les constructeurs, le lecteur conditionnel et un setter indirect potentiel sont reliés statiquement. Les paramètres effectifs de Map10, le chargement de configuration, la liste d’inclusion active et l’achat 3116 restent inconnus. Reprendre sur une source primaire ou un callsite établissant le dispatch et la valeur injectée, ou sur une observation reproductible du client exact. Ne pas transformer les zéros initiaux en admission historique et ne pas répéter les appels REA expirés sans nouvel indice. ITEM-3116-SCOPE reste a_qualifier; aucun test de jeu, build, statut, goal, plan, application ou base modifié.

## Addendum V1079 — ITEM-3116-SHOP-PRIX : prix de base et prix total (2026-11-03)

Exigence OLF-8571ced0-76fa-5b9c-b041-126bdcaa2467; ITEM-3116-SHOP-PRIX est a_faire et dépend de ITEM-3116-SCOPE. Ce lot relie les données de prix à la logique de boutique actuelle; il ne valide pas une transaction historique.

La lecture directe de DATA/Items/3116.inibin donne Data/Price=605, CanBeSold=1 et RecipeItem1/2/3=1026/1052/1011; RecipeItem4 vaut 0. Le hash cherché pour Data/SellBackModifier est absent des paires décodées; cela ne prouve pas l’absence de toute règle de revente. L’identité native et son membership consignés en V1073 sont réutilisés. Le catalogue officiel comparatif 4.20.1, source OLS-b3343643-2fe6-513b-b286-7c03b86b8409, donne base=605, total=2900 et sell=2030.

Les reçus natifs des composants et les données locales donnent 1026=860, 1052=435 et 1011=1000; leurs recettes locales sont vides. Le calcul 605+860+435+1000=2900 concorde avec le catalogue 4.20.1. Cela étaye l’interprétation de 605 comme coût de combinaison dans cette référence, sans établir à lui seul la sémantique serveur du build 4.20.0.315.

Le code actuel crates/core/src/shop.rs:99–171 valide la recette et traite Item.price comme prix total, puis déduit le prix des composants possédés. Si une définition 3116 à 2900 et les trois composants étaient intégrés, la lecture statique prédit 2900 avec inventaire vide et 605 avec les trois composants. Une définition à 605 avec cette recette serait refusée comme invalid recipe price car 2295 dépasse 605. Ces cas sont conditionnels et n’ont pas été exécutés. buy_item vérifie d’abord shop_guard; sell_item exige un sell_price explicite et refuse une valeur absente. La valeur comparative 2030 ne provient pas du champ natif SellBackModifier interrogé.

Observé statiquement : 3116 manque des 33 définitions et des 33 admissions locales; quote_with_counts refuse sa définition absente par item behavior not implemented, avant tout calcul de prix. Le consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b enregistré pointe vers ce refus à shop.rs:86; les chemins plan_in, buy_item et sell_item cités ici sont des ancres supplémentaires documentées, sans modification du registre.

Vérifié : lecture du champ natif et des composantes, lecture de la référence enregistrée, inspection de la recette et des fonctions réelles. Réutilisé : reçus et hashes natifs des composants, sans rehash. Aucun achat, vente, test de jeu, build ou acceptation n’a été exécuté. Sous-audit statique de la liaison prix/consumer terminé; décision Map10 exacte, intégration des données, comportement serveur et vérification runtime restent ouverts. Les statuts, goal, plan, application et bases restent inchangés.

## Addendum V1080 — Constants.var Map10 et dispatch natif (2026-11-03)

Question : une source native attribuable au client contient-elle les deux paramètres, et comment leurs valeurs peuvent-elles atteindre les champs lus par la boutique ? Le paquet D01-SYS-01-2 requiert D01-SYS-01-1, dont les sept tâches sont a_valider et sans acceptation; cette recherche reste documentaire.

### Source Map10

Le fichier sélectionné deploy/LEVELS/Map10/Constants.var existe; 19 433 octets, SHA-256 178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2, MD5 a62149a5f1fcf4316ea11665a55f5142, recalculés dans ce lot. Les lignes 12 et 13 contiennent chacune une affectation : it_UseExplicitItemInclusion = 0 et it_UseExplicitItemInclusionTutorialOnly = 0.

Le registre source OLS-687ba5a2-460e-57d9-9e82-244a7d49b8c1 associe ce fichier à lol_game_client projet 0.0.1.7, membre 0.0.0.248, logical path LEVELS/Map10/Constants.var et MD5 de manifeste identique. Cette appartenance est réutilisée du registre; le manifeste n’a pas été reparsé ici. Le registre conserve runtime_precedence_qualified=false.

### Chaîne native statique

Le PE x86 de SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 est celui déjà identifié en V1074; ce hash est réutilisé. Capstone 5.0.6 existant a servi à lire les instructions, sans exécuter le PE.

L’appel direct 0x591E08 vise 0x6A2BC0. Cette procédure appelle à 0x6A2C05 le résolveur 0x6A2930, qui manipule les littéraux Constants et .var, une chaîne fournie par 0x5B26E0 et un résolveur virtuel. À 0x6A2C4C, elle appelle le lecteur 0x6A27D0 avec le chemin résultant. Le chemin effectivement retourné et le provider ne sont pas observés.

Le lecteur ouvre en mode rt, lit les lignes, ignore celles dont le premier caractère est un point-virgule et utilise le format %s = %s. Il recherche le premier champ dans le registre d’objets via 0x6A2770; ce dernier compare le nom au champ objet +4. Pour un objet trouvé, 0x6A28FA appelle la première méthode virtuelle avec le second champ. Les constructeurs des deux paramètres enregistrent leurs objets dans ce registre et installent la table dont la première entrée est 0x574A30. Comme décrit en V1078, ce setter accepte une entrée numérique via le format %d et écrit le champ +0xC si le parseur retourne 1.

### Attendu, constat et limites

Attendu conditionnel : si le résolveur sélectionne ce Constants.var Map10, si les objets enregistrés sont ceux inspectés et si aucune écriture ultérieure ne les modifie, les deux affectations à 0 alimentent les champs d’inclusion et la boucle ItemInclusionList reste désactivée. 3116 est absent de la liste UnpurchasableItemList décodée en V1075. Ces faits décrivent un chemin statique et ne suffisent pas à prouver une transaction autorisée : sélection du chemin/provider, ordre d’initialisation, surcharges, restrictions serveur et valeurs finales n’ont pas été observés.

Observé : deux lignes à 0 dans la copie Map10 identifiée, hashes concordants avec le registre, et chaîne d’appels/instructions permettant le dispatch d’une configuration. Aucun parseur natif ni jeu n’a été exécuté. Aucun résultat d’achat ou de valeur effective n’est revendiqué.

Reprendre sur la résolution effective de 0x6A2930 et la priorité des providers/overlays, l’ordre des écritures avant 0x5B6600, ou une observation reproductible du client/serveur exact. Ne pas rehash ce fichier, refaire le balayage ou rejouer les REA expirés sans indice nouveau. ITEM-3116-SCOPE reste a_qualifier; implémentation, runtime et acceptation restent ouverts. Aucun registre, statut, goal, plan, application ou base n’a été modifié.

## Addendum V1081 — nom demandé et repli du fournisseur (2026-11-03)

Lot statique faisant suite à V1080 : préciser le nom construit pour la configuration et le repli du fournisseur, sans supposer la ressource retenue en partie. Source PE x86 de SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, identité REA V1074 réutilisée sans rehash. Instructions inspectées en lecture seule avec Capstone 5.0.6 existant et Python du dépôt.

Dans 0x6A2930, le texte Constants, la chaîne fournie par 0x5B26E0 et le texte .var sont assemblés par 0x5FA560 puis 0x5F8350. Le nom demandé a la forme Constants{suffixe}.var. La copie Constants.var identifiée en V1080 correspond au nom directement construit si le suffixe est vide; une résolution ultérieure ou un autre mécanisme éventuel reste à démontrer. Le suffixe effectivement fourni en partie n’est pas établi.

Le fournisseur est obtenu par 0x90AEF0 à partir d’un arbre. Une entrée déjà présente est retournée; sa vtable et son état effectifs ne sont pas qualifiés. Dans la branche qui crée un nouvel objet via 0x90ADE0/0x90A1B0, la vtable installée est 0x10D6380. Son slot +0x1C pointe sur 0x90A480 et son slot +0x2C sur 0x905000. L’appel 0x90AE99–0x90AEA0 transmet l’adresse manager+0x80 au slot +0x2C; 0x905000 la stocke à provider+0x10.

Pour cet objet nouvellement créé, 0x90A480 transmet le nom, la structure locale à provider+8 et le pointeur provider+0x10 à 0x905CA0. Celui-ci cherche d’abord le nom dans la structure locale; si la recherche échoue et que le pointeur de repli est non nul, 0x905D52–0x905D5C transmet le même nom au slot virtuel +0x1C du repli. Si le pointeur est nul, 0x905D68 retourne une chaîne globale vide. Ce chemin établit un repli conditionnel entre objets de résolution; il ne montre pas de suppression du suffixe et ne prouve pas l’ordre des couches de fichiers ou le provider choisi en runtime.

Dans le deploy sélectionné, la recherche bornée des fichiers var sous LEVELS/Map10 n’a trouvé que Constants.var. Cette présence et les deux zéros V1080 ne prouvent pas que la chaîne construite, le fournisseur effectif et les éventuelles surcharges convergent vers ce fichier. Aucun client, parseur natif ou achat n’a été exécuté.

Résultat : la forme du nom demandé et un mécanisme de repli conditionnel sont reliés statiquement. Suffixe effectif, provider déjà présent, identité du repli et priorité des ressources restent ouverts; ITEM-3116-SCOPE demeure a_qualifier. Reprendre sur le producteur de la chaîne 0x5B26E0, le contenu réel de l’arbre fournisseur et la résolution finale, ou sur une observation reproductible du client exact. Ne pas refaire les hashes, le census ou les appels REA expirés sans indice nouveau. Goal, registres, plan, application de suivi et bases inchangés.

## Addendum V1082 — ITEM-3116-SHOP-RECETTE : préparation et refus (2026-11-03)

Exigence OLF-2c5f5aa7-b896-5d13-ab38-6f047dbabf9a. La tâche ITEM-3116-SHOP-RECETTE reste a_faire et dépend de ITEM-3116-SERVER, lui-même a_implementer_ou_integrer et dépendant des statistiques et du passif. Le paquet D07-ITEM-3116 ne déclare pas de paquet requis. Ce lot relie statiquement la recette et le consumer; il ne réalise pas la fonctionnalité.

La recette native DATA/Items/3116.inibin, source OLS-d61b2678-9a72-5984-8348-d006302ed5d8, et la référence comparative 4.20.1, source OLS-b3343643-2fe6-513b-b286-7c03b86b8409, donnent 1026 + 1052 + 1011. Les identités et valeurs relevées en V1073 et V1079 sont réutilisées; aucun hash natif n’est recalculé. Les composants locaux ont respectivement les prix 860, 435 et 1000 et des recettes vides. Le total comparatif 3116 est 2900.

Dans crates/core/src/shop.rs:99–171, plan_in valide les références, cycles, profondeur, budget et prix. La fonction credit retire les composants trouvés d’une copie locale de l’inventaire; elle utilise ensuite une case libre de cette copie pour le résultat. buy_item :261–292 applique le plan seulement après shop_guard, définition, admission, groupe, calcul et contrôle des fonds. shop_ui.rs:428–431 construit les textes de composants et de transformations depuis i.recipe. Le consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b déjà enregistré cible le refus de définition absente; ces chemins de recette sont des ancres supplémentaires documentées ici, sans modification du registre.

Cas nominal attendu sous hypothèses : définition 3116 et admission intégrées, shop_guard satisfait, inventaire contenant un 1026, un 1052 et un 1011, au moins 605 pièces. La lecture statique prédit le crédit des trois composants, leur retrait de la copie, le placement de 3116 dans une case libérée et un coût de 605. Aucun de ces résultats n’a été exécuté pour 3116.

Limites statiques : si les six cases sont occupées et qu’aucun composant ne libère de place, plan_in renvoie inventory full. Si le plan est produit mais que les fonds sont insuffisants, buy_item renvoie insufficient gold avant les affectations de cette transaction. Un graphe cyclique ou hors limites, une définition absente ou un prix invalide reçoit un refus propre au chemin inspecté. Les erreurs explicites précèdent les affectations d’or, inventaire et compte; celles-ci et refresh_item_caps sont toutefois successives, sans rollback démontré en cas de panic ou interruption. Cela ne prouve pas une atomicité générale.

Observé dans les données courantes : 3116 est absent des 33 définitions et des 33 admissions Map10; quote_with_counts prédit item behavior not implemented avant la construction de son plan. Les tests génériques existants de shop.rs ont été inspectés seulement; aucun n’est une preuve de la recette 3116 actuelle. Aucun achat, refus runtime, build ou acceptation humaine exécuté.

Sous-audit de liaison et des limites statiques terminé. Intégration de la recette, disponibilité historique, cas nominaux et refus en runtime, atomicité face aux interruptions et acceptation restent ouverts. Reprendre après ITEM-3116-SERVER et la qualification de la carte, avec des cas directs sur inventaire, fonds, graphe et rendu; réutiliser les reçus existants. Aucun registre, statut, goal, plan, application ou base modifié.

## Addendum V1083 — ITEM-3116-SERVER-STAT-FlatHPPoolMod (2026-11-03)

Exigence OLF-6f0708c4-bd90-5dbc-af6e-2f5c647fbee9. La tâche reste a_faire et dépend de ITEM-3116-SCOPE. Sous-lot : relier la valeur de santé native aux consommateurs actuels, sans qualifier une transaction ni la règle serveur historique.

Le lecteur reference_inibin.py lit Data/FlatHPPoolMod, hash 1993475205, comme chaîne décimale « 400 » dans DATA/Items/3116.inibin. Le second lecteur lolpytools_inibin2.py normalise cette chaîne en entier 400; les représentations brutes ne sont pas identiques, mais les valeurs normalisées concordent. Le catalogue comparatif 4.20.1 donne aussi 400. Identité native OLS-d61b2678-9a72-5984-8348-d006302ed5d8, SHA-256 f90f5d694a1058fb252f634644b1ed9d506128f0bbaaaabbf70a4effd32c2b1b et membership V1073 réutilisés, sans rehash.

Dans crates/core/src/shop.rs:215–245, bonuses additionne i.bonuses.health des objets reconnus; progression.rs:117 ajoute items.health à max_health. shop.rs:314–320 recalcule le maximum et borne la santé courante à ce maximum. Si une entrée 3116 portant health=400 était intégrée et acquise, la formule locale prédit +400 de maximum pour cette entrée. Elle ne démontre pas le traitement historique de la santé courante.

Observé statiquement : 3116 manque des définitions et admissions actuelles; aucun bonus 3116 n’atteint ce chemin par achat normal. Le consumer enregistré OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b pointe au refus shop.rs:86; les ancres de calcul de santé ci-dessus sont des observations supplémentaires, sans modification du registre. Un test existant sur l’objet 1028 a été seulement lu et ne prouve pas 3116.

Lecture directe des deux lecteurs et du code effectuée; aucun achat, test de jeu, build ou acceptation exécuté. Audit statique source→consumer terminé; scope Map10, intégration 3116, santé courante historique, runtime et acceptation restent ouverts. Reprendre après décision du scope et intégration, avec vérification directe de la santé maximale et courante à l’achat et à la vente.

## Addendum V1084 — ITEM-3116-SERVER-PASSIF : valeurs et ralentissement (2026-11-03)

Exigence OLF-03709130-bd71-5ed1-8a46-a5b0dce4a311. La tâche reste a_faire et dépend de ITEM-3116-SCOPE. Sous-lot : relier les valeurs natives et la description aux consommateurs de combat actuels, sans revendiquer le passif complet.

La lecture directe de DATA/Items/3116.inibin donne Data/Effect1Amount=-0.3499999940395355, Effect2Amount=-0.15000000596046448 et Effect3Amount=1.5. Ces nombres concordent numériquement avec la description client en_GB et le catalogue 4.20.1 : ralentissement de 35 %, ou 15 % pour les sorts multicibles et dégâts sur la durée, pendant 1,5 seconde. L’association aux règles vient du texte; les nombres seuls ne prouvent ni le déclenchement ni les unités runtime. Le hash Data/SpellName interrogé est absent; UseEffect et UseWhenAcquired valent 0. Ces faits et MaxStack=1 ne déterminent pas le déclenchement ni le cumul du passif.

Dans crates/core/src/slows.rs:9–22, le mécanisme générique garde le ralentissement le plus fort et remplace les entrées de même tag; :41–76 prépare et applique les événements. movement.rs:47 consomme strongest. La signature damage.rs:53 transporte source, cible, dégâts bruts et DamageKind, sans catégorie cible unique/multicible/dégâts sur la durée dans cette signature. Une recherche bornée dans crates/core/src et crates/client/src ne trouve ni 3116 ni Rylai comme identifiant exact; elle ne prouve pas l’absence de tout mécanisme indirect. La politique NPC locale bornée ne prouve aucune immunité native.

La prévalidation locale exige une fraction finie supérieure à 0 et au plus égale à 1. Lui transmettre directement les nombres natifs négatifs prédirait le refus invalid slow; aucune conversion de signe ou unité 3116 n’est encore qualifiée. Le TICK_RATE local vaut 30 : 1,5 seconde correspond arithmétiquement à 45 ticks, sans preuve d’un producteur ou d’une règle d’arrondi 3116.

Observé statiquement : 3116 manque des 33 définitions de boutique; le consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b enregistré correspond au refus shop.rs:86, non à un producteur du passif. La trace existante sans unknown_ids ne démontre pas le déclenchement, les catégories ou le cumul. Aucun sort, ralentissement, test de jeu, build ou acceptation n’a été exécuté.

Audit statique des valeurs et consommateurs identifiés terminé; intégration, producteur, conversion, catégories, cumul, durée effective et admission Map10 restent ouverts. Reprendre sur une source primaire de comportement ou un callsite natif/serveur, puis vérifier les cas directs, multicibles, dégâts sur la durée, refus, expiration et cumul. Aucun statut, registre, goal, plan, application ou base modifié.

## Addendum V1085 — origine statique possible du suffixe Constants (2026-11-03)

Question : que retourne 0x5B26E0 au résolveur V1081, et quels chemins peuvent modifier cette chaîne ? Source : PE x86 identifié au SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 en V1074, hash réutilisé. Désassemblage en lecture seule avec Capstone 5.0.6 existant et Python du dépôt; aucun PE ni client exécuté.

Le constructeur 0x5B2280 initialise le champ chaîne this+8 vide : longueur this+0x18=0 et premier octet nul. 0x5B2300 publie l’objet dans le global 0x2D7878C. Le setter 0x5B2590 copie son premier argument dans this+8 avant de le comparer à plusieurs littéraux reconnus, dont CLASSIC, ODIN et TUTORIAL. Le getter 0x5B26E0 renvoie ce champ. La chaîne vide est donc un état initial; elle peut être remplacée ultérieurement.

Un balayage des appels directs E8 rel32 dans la section .text brute [0x1000,0xBA4000) donne deux candidats vers 0x5B2590, tous deux vérifiés par désassemblage :
- À 0x5753C9, un chemin lit les noms de paramètres -mapID et -missionMode. Le setter est appelé lorsque la valeur mapID obtenue est différente de -1 et que la chaîne missionMode est non vide.
- À 0x58A516, un chemin transmet au setter l’adresse du champ +0x986 d’une structure d’entrée. Dans le dispatch 0x588290, CX=0x54 indexe la table vers le bloc 0x589FD0 contenant ce chemin. 0x72B398 transmet le discriminant et la structure à ce dispatch. Le type, le producteur et la valeur de cette structure ne sont pas identifiés; 0x54 n’est pas nommé comme protocole.

Le balayage des appels directs ne couvre pas les appels indirects. Aucun des deux chemins n’a été exécuté et leur ordre effectif reste inconnu. Si le setter reçoit exactement CLASSIC et que la chaîne demeure inchangée, le résolveur V1081 construit ConstantsCLASSIC.var; cela ne prouve pas que Map10 reçoive cette valeur ou que le provider final choisisse cette ressource. Le deploy/LEVELS/Map10 examiné ne contient que Constants.var parmi ses fichiers var; les autres providers et surcharges restent ouverts.

Résultat : initialisation, stockage et deux producteurs statiques possibles du suffixe sont identifiés. Valeur effective Map10, ordre des producteurs, contenu de la structure, provider et fichier finalement chargé restent inconnus. Reprendre sur la source des paramètres effectifs ou le producteur de la structure, puis qualifier la résolution et les écritures; ne pas déduire la valeur runtime du seul état initial. ITEM-3116-SCOPE demeure a_qualifier; aucun test de jeu, statut, goal, plan, application ou base modifié.

## Addendum V1086 — ITEM-3116-SERVER-STAT-FlatMagicDamageMod (2026-11-03)

Exigence OLF-d6abafb0-1651-5614-b2b5-4a6bcb75a974. La tâche reste a_faire, dépend de ITEM-3116-SCOPE et conserve implementation_complete=false et acceptance_complete=false. Sous-audit limité à la liaison statique de la puissance de l’objet.

Data/FlatMagicDamageMod, hash 3524488927, est lu comme chaîne « 100 » par reference_inibin.py et comme entier 100 par lolpytools_inibin2.py; les valeurs concordent après normalisation, pas les types bruts. Le catalogue comparatif 4.20.1 donne 100. Identité native OLS-d61b2678-9a72-5984-8348-d006302ed5d8 et reçu SHA-256 f90f5d694a1058fb252f634644b1ed9d506128f0bbaaaabbf70a4effd32c2b1b réutilisés de V1073, sans rehash.

Dans crates/core/src/shop.rs:224, bonuses additionne ability_power des objets reconnus. progression.rs:87 multiplie items.ability_power par altar_damage_multiplier; altars.rs:132–136 renvoie 1 sauf si exactement deux autels appartiennent à l’équipe, auquel cas il utilise 1+two_altar_damage_percent. data/4.20/altars_map10.json donne 0.1. Pour une entrée 3116 hypothétique et seule source de puissance d’objet, la lecture statique prédit 100 sans exactement deux autels et 110 avec deux. Ce n’est ni une exécution ni une règle historique validée. À titre de consumer en aval, annie_r.rs:39 utilise stats.ability_power; cela ne qualifie pas les capacités des autres champions.

3116 est absent des 33 définitions et 33 admissions locales. La trace existante associe OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b au refus shop.rs:86; les ancres shop/progression/autels ci-dessus sont des observations supplémentaires, sans modification du registre. Les deux lecteurs et les données/consommateurs ont été lus; aucun achat, sort, test de jeu, build ou acceptation n’a été exécuté.

Audit statique de la liaison terminé; scope Map10, intégration, multiplicateur historique, effets de sorts et runtime restent ouverts. Reprendre après qualification de ITEM-3116-SCOPE et intégration de l’entrée, avec contrôles de statistique et de sort aux états d’autels pertinents.

## Addendum V1087 — ITEM-3116-SERVER-PASSIF : préchargements et chunks Lua natifs (2026-11-03)

Ce complément précise V1084 sans attribuer un déclencheur non prouvé. DATA/Items/3116.preload, source OLS-b24f8ef3-9bc2-59b6-8a22-fa359bd10189, 209 octets, SHA-256 12954fe1e89bbf420f31e0fb318a157636cd81ffa8e2bde546897c12f2dec4e0, précharge internal_35slow, itemslow et internal_15slow. Son MD5 recalculé correspond à celui enregistré pour le membre 0.0.0.254 du projet lol_game_client 0.0.1.7; le manifeste lui-même n’a pas été reparsé et la précédence runtime reste non qualifiée.

Les trois noms ont des fichiers DATA/Spells dans le client sélectionné. La lecture statique Lua 5.1 avec tools/native_lua.py, sans exécution des chunks, couvre :
- DATA/Items/3116.luaobj, source OLS-cbe97fcb-1392-5bc3-beab-fe5ad3c3bcc7, membre 0.0.0.254;
- Internal_15Slow.luaobj, OLS-f5ac81c0-57c3-5f6a-b3a8-d2542e6641f1, et Internal_35Slow.luaobj, OLS-aaa4add5-f512-5cbb-b51f-c62d94bb29df, membres 0.0.0.25.

Ces trois chunks distincts ont chacun 56 octets et le même SHA-256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 : un seul opcode RETURN, aucune constante ni fonction enfant. ItemSlow.luaobj, OLS-829053ae-e161-5f2c-933f-bb72d1c1f14e, membre 0.0.0.130, 217 octets et SHA-256 42a4a22679b1838d9685687d454ca9683e72974ca759c1821212141e8fb9172a, initialise seulement BuffTextureName=122_Frozen_Heart.dds, BuffName=Frozen Mallet Slow et AutoBuffActivateEffect=GLOBAL_FREEZE.TROY; aucune fonction enfant ni appel dans ce chunk. Les MD5 recalculés concordent avec les valeurs de manifeste enregistrées; le manifeste n’a pas été reparsé.

Ces noms établissent des dépendances de préchargement client, pas le déclenchement, la catégorie de dégâts ou l’attribution automatique des métadonnées ItemSlow au passif Rylai. La recherche bornée des trois noms dans crates/core/src et crates/client/src ne trouve aucun consumer Rust correspondant; leur présence dans un inventaire de ressources n’est pas un comportement de gameplay. Le mécanisme générique et la limite de signe restent ceux de V1084.

Lecture et empreintes des ressources effectuées, chunks non exécutés. Le producteur serveur/natif, les catégories, la conversion, le cumul, la durée effective et le runtime restent ouverts; ITEM-3116-SERVER-PASSIF demeure a_faire. Reprendre sur un script serveur ou callsite primaire liant l’événement de dégâts aux ralentissements; ne pas rehash ni relire les chunks inchangés sans nouvel indice. Aucun statut, registre, goal, plan, application ou base modifié.

## Addendum V1088 — objet appelant du dispatch de suffixe (2026-11-03)

Complément limité à V1085. Dans le PE x86 de SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 déjà identifié en V1074, la table 0x10AFDD0 contient au slot +0xF0 le pointeur 0x72B2D0. Ce wrapper transmet ses deux arguments à 0x72B2F0 au call 0x72B2DC; ce dernier peut transmettre un discriminant et une structure au dispatch 0x588290 décrit en V1085.

Le constructeur 0x730560 installe la table 0x10AFDD0 dans l’objet à 0x7305C6; la fabrique 0x72F540 appelle ce constructeur à 0x72F5B2 après allocation de 0x10 octets. Un balayage des appels directs E8 dans la section .text vers 0x72B2F0 a trouvé le wrapper comme seul candidat direct, vérifié par désassemblage. Ce balayage ne couvre pas les appels indirects.

Le type de l’objet, le producteur et le contenu de la structure, l’appelant virtuel effectif et la valeur du suffixe restent inconnus. Une chaîne voisine ou un nom de registre non relié à ce champ ne suffit pas à identifier la structure. Capstone 5.0.6 existant a été utilisé en lecture seule; le PE n’a pas été exécuté, et son hash antérieur a été réutilisé.

Résultat : une table virtuelle, un constructeur et une fabrique sont reliés statiquement au wrapper du dispatch. Reprendre sur un callsite virtuel ou producteur primaire qui identifie et remplit la structure utilisée au cas 0x54; ne pas assimiler ce cas à un protocole ni à une valeur Map10. ITEM-3116-SCOPE demeure a_qualifier; aucun statut, goal, plan, application ou base modifié.

## Addendum V1089 — ITEM-3116-SERVER : parcours de commande actuel (2026-11-03)

Exigence OLF-1fabef61-8afd-5a92-850d-22a09b7b6936. ITEM-3116-SERVER reste a_implementer_ou_integrer et dépend des tâches santé, puissance et passif, toutes ouvertes. Ce lot relie le chemin ordinaire actuel à leurs preuves existantes; il ne valide ni comportement historique ni intégration serveur.

La trace associe la source DATA/Items/3116.inibin et la référence comparative 4.20.1 au consumer OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b, qui désigne le refus de définition absente à shop.rs:86. Les champs et sources sont réutilisés des addenda V1083–V1087 : +400 Health, +100 Ability Power et valeurs de ralentissement; leurs consommateurs génériques ne constituent pas un producteur du passif 3116. Une trace sans unknown_ids ne démontre pas le déclenchement ni une acceptation.

Dans crates/server/src/session_host.rs:121–149, Host::handle prépare et valide une entrée de session, puis commit cette entrée avant de traiter la commande. Une pause retourne match is paused; sinon game.command est appelé et son erreur devient SessionGameplayRejected avec contexte et séquence. Dans crates/core/src/lib.rs:598–613, Simulation::command vérifie partie, joueur et santé, puis dirige Action::Buy vers buy_item. shop.rs:248–270 vérifie notamment la distance à la boutique alliée, puis la définition avant la règle Map10.

Attendu conditionnel dans le code courant : une commande d’achat 3116 qui franchit les contrôles de session, de partie, de joueur et de boutique atteint item behavior not implemented, puisque la définition est absente. Une erreur antérieure peut prévaloir. Ce résultat est prédit par lecture du code et des données, non observé en exécution. Le commit d’entrée de session précède le refus de gameplay; une erreur de gameplay ne démontre pas que la séquence de session reste inchangée.

Vérifié : lecture des gardes, dispatch et erreurs du chemin sécurisé; réutilisation des sources et preuves de 3116 précédentes. Aucun paquet, achat, sort, test réseau, client historique ou acceptation n’a été exécuté. Les refus et étapes du serveur local ne qualifient pas le protocole Riot historique.

Audit statique de liaison du chemin serveur terminé; définition, admission, santé/puissance intégrées, producteur du passif, conversion, catégories, cumul et comportement runtime restent ouverts. Reprendre sur la qualification Map10 et l’intégration autorisée, puis vérifier sessions valides/invalides, pause, fin/mort/distance, définition et admission absentes, achat, stats et passif monocible/multicible/dégâts sur la durée. Statuts et registre inchangés.

## Addendum V1090 — ITEM-3116-SHOP : parcours intégré et critères (2026-11-03)

Exigence OLF-b27445fb-e18a-5394-a497-7565a4e267dd. ITEM-3116-SHOP reste a_implementer_ou_integrer et dépend du serveur, de l’icône, du texte, du prix et de la recette; la classification historique reste conditionnelle à ITEM-3116-SCOPE. Les sources natives et comparaisons de ces sous-lots sont réutilisées de V1076–V1082, sans rehash ni nouveau test d’asset.

Dans crates/client/src/shop_ui.rs:264–280, selected_action exige une connexion prête, boutique ouverte, joueur, admission Map10 et devis valide avec fonds suffisants avant de produire Action::Buy. L’ID 3116 absent de l’admission ne produit donc pas cet achat par ce chemin UI. Les interactions :330–352 appellent connection.send_action lorsqu’une action existe. session_connection.rs:131–142 émet soit Input::Command par la session sécurisée, soit ClientPacket::Command JSON; un envoi réussi n’établit pas l’acceptation du serveur. Les chemins serveur sécurisé et JSON aboutissent à game.command et leurs réponses de rejet restent distinctes; V1089 décrit les gardes du cœur.

ShopControl::Undo est désactivé par le calcul d’état :392 et son gestionnaire :352 ne fait rien. C’est un constat du client local, non une description de la règle historique. Le HUD d’inventaire est un second consumer : native_hud_inventory.rs:17–23 refuse un ID absent du catalogue; son manifeste charge les DDS aux lignes 80–87 et le rendu refuse une icône non chargée aux lignes 100–105. 3116 manque aussi de ce manifeste. Aucun snapshot forcé ni rendu HUD n’a été exécuté.

Le titre de la tâche demande icône, texte, recette, achat, vente, annulation et inventaire, tandis que son critère actuel porte sur modèles, animation, VFX, audio et HUD sans énoncer précisément ces transactions. Cette divergence est documentée sans modifier le registre. Pour une clôture future, les preuves doivent couvrir au minimum achat sans et avec composants, fonds et places insuffisants, vente et valeur créditée, annulation selon un contrat historique établi, état d’inventaire/HUD et réponse du serveur. Les captures et comparaisons visuelles restent séparées de ces comportements.

Audit statique de liaison UI→transport local→cœur et du HUD terminé dans les bornes décrites. Aucun achat, vente, annulation, paquet, rendu, test de jeu ou acceptation n’a été exécuté; absence du catalogue, qualification Map10, Undo, critères transactionnels et fonctionnalités restent ouverts. Statuts, goal, plan, application de suivi et bases inchangés.

## Addendum V1091 — identité probable du champ de synchronisation (2026-11-03)

Le dispatch natif 0x54 et le passage du champ à +0x986 au sélecteur de suffixe avaient été reliés en V1085–V1088 sans identifier le champ. La source communautaire 4.20 ci-dessous fournit une correspondance forte, sans être un serveur Riot ni une capture historique :

- https://github.com/MiscellaneousStuff/LeagueSandbox-RL-Learning/blob/c5289e99a951bf8b779192706a41560f1ad5b793/PacketDefinitions420/PacketDefinitions/S2C/SynchVersionResponse.cs (blob 22c553a770394b93c5367d54b8116e0fe45bf560), classe SynchVersionResponse;
- https://github.com/MiscellaneousStuff/LeagueSandbox-RL-Learning/blob/c5289e99a951bf8b779192706a41560f1ad5b793/PacketDefinitions420/PacketDefinitions/PacketCmd.cs : identifiant communautaire PKT_S2C_SYNCH_VERSION = 0x54;
- https://github.com/MiscellaneousStuff/LeagueSandbox-RL-Learning/blob/c5289e99a951bf8b779192706a41560f1ad5b793/PacketDefinitions420/PacketDefinitions/BasePacket.cs et https://github.com/MiscellaneousStuff/LeagueSandbox-RL-Learning/blob/c5289e99a951bf8b779192706a41560f1ad5b793/PacketDefinitions420/Packet.cs pour la sérialisation;
- https://github.com/MiscellaneousStuff/LeagueSandbox-RL-Learning/blob/c5289e99a951bf8b779192706a41560f1ad5b793/PacketDefinitions420/PacketNotifier.cs : émission communautaire avec CLASSIC codé en dur.

Comparaison statique : la définition communautaire écrit un en-tête de 5 octets, un octet de flags, quatre octets de carte, douze entrées joueur de 181 octets et 256 octets de version avant le champ gameMode. Pour des champs texte ASCII, 5 + 1 + 4 + 12 × 181 + 256 = 2438 = 0x986. La preuve native déjà conservée dans docs/replay_service_receive_sources/receive/packet_switch_map.json montre des lectures à +5 et +6, un début d'entrées à +0xA, une boucle de douze avec pas 0xB5, et le passage de +0x986 à 0x58A50F–0x58A516. Ces correspondances étayent fortement une réponse de synchronisation de version serveur vers client et un champ mode, sans établir une identification absolue ou la valeur du paquet historique.

Limite du modèle communautaire : WriteConstLengthString calcule le remplissage sur le nombre de caractères alors que la chaîne est encodée en UTF-8; la taille annoncée n'est donc pas garantie pour du texte non ASCII. Aucun paquet n'a été capturé ni exécuté ici. La valeur CLASSIC est celle de l'émulateur, pas une preuve de la valeur envoyée par Riot pour Map10 EUW 4.20.

Sous-audit statique de correspondance terminé; admission de 3116 et valeur effective du mode restent ouvertes. Reprendre si une capture/enregistrement 4.20 EUW fiable du paquet, une source primaire sur la valeur ou une preuve native complémentaire devient disponible; vérifier alors son contexte, sa provenance et la valeur réellement transmise. Ne pas déduire la disponibilité de l'objet de la seule structure du paquet.
