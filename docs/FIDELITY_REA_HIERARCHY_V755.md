# SYS-01.2-02 — Hiérarchies audio et paramètres hérités, V755

F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Travail limité à l’association des sources et consommateurs de SYS-01.2-02 et SYS-02.2-07. Aucun code produit ni asset modifié. Goal et inconnues conservés ouverts.

## Résultat nouveau

Les 587 sons sélectionnés en V754 ont tous leur parent HIRC5 dans la même banque : aucun parent manquant dans ce sous-ensemble. Le lot charge plus largement tous les objets des types2,5,7 de ces six banques dans leur ordre original : 739 Sound,524 conteneurs et28 acteurs, soit1291 objets. Les 1269 liens parent-enfant sont vérifiés dans les deux sens. Les chaînes des sons ont une profondeur2 pour2sons,3 pour570sons et4 pour167sons. Aucun ID de parent demandé dans ce parcours ne reste sans lien.

Avant ces banques, le lecteur original STMG installe ses données et les lecteurs HIRC1/8 chargent4 états et79bus de Init.bnk. Les parents utilisant ces bus sont donc réellement attachés. Les constructeurs et lecteurs Sound B226A0/B22AF0, conteneur B1D610/B1E5C0 et acteur B22BE0/B22C60 exécutent leurs instructions originales ;B00A50 et AE1970 consomment les paramètres et enfants. Chaque corps termine exactement au dernier octet. Les tableaux d’enfants sont comparés aux IDs sérialisés ;les données sources restent inchangées.

AFF450 traverse les liens natifs réels. Ses1478 mots float32 et ses parcours sont conservés. Par rapport aux mêmes587sons isolés de V754,82paires changent :32ENV,2NPC,26Global,1Map8,3Tutorial2 et18Tutorial. Exemple : le son258704465 passe de50 à35 pour le premier paramètre lorsqu’il hérite de sa chaîne chargée. V754 reste une preuve valide de contexte sans parents ;elle n’est pas une preuve de valeur finale en jeu.

## Rust actuel et limites d’intégration

Deux programmes privés compilent11 et32modules inchangés,36fichiers distincts. Les commandes Cargo generate-lockfile --offline, build --locked --offline et les deux exécutables terminent avec le code0 ;identités des sources,manifestes,verrous,depfiles et exécutables conservées.

Une projection explicite des chaînes natives fournit les entrées à audio_pair_controls::evaluate. Les739calculs,1478mots et traces de traversée correspondent exactement au natif. Les587sons et478conteneurs issus des catalogues Rust conservent leurs propriétés,parents immédiats et ensembles d’enfants natifs. Catalog::plan résout470événements et545alternatives.

Cette projection appartient au banc. Les types de catalogue actuels ne contiennent pas la structure complète des acteurs ancêtres ni leurs flags natifs. Le véritable load_section refuse les1291corps HIRC2/5/7 sous chacune des politiques Reject et SkipNativeDefaults :2582refus explicites,corps non consommé,référence holder0 et une place réservée. Ni ce refus ni les champs absents du contrat courant ne prouvent une corruption des assets. Le calcul de paramètres est vérifié ;le producteur de la hiérarchie dans le jeu actuel reste à réaliser/qualifier.

Cinq rôles existants sont réutilisés :catalogue annonceur,contrat ambiance,planification annonceur,chargeur de section et calcul de paire. Leurs anciennes qualifications ne sont pas réécrites ;aucun rôle dupliqué ni exigence promue terminée.

## REA et identité originale

REA6.4.0,SDK2.3.1,Ghidra12.1.4,JDK21.0.10.7 :une session réelle sur le PE complet,11fonctions,605instructions et103références contrôlées. Fonctions AF87E0,B1D610,B1D370,B1DD80,B1E5C0,AE1970,AF6480,AF9530,AFF450,B22BE0,B22C60. Analyse,export et fermetures du binaire/client/transport réussis. REA statique et exécution isolée sont des preuves distinctes.

League of Legends.exe :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, sous D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy. Init.bnk :6890octets,SHA25641d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les six autres banques et leurs membres sont identifiés par offsets,tailles et SHA256 dans les reçus. Les banques VO sont en_US ;pas de couverture exhaustive en_GB. Les nouvelles preuves sont sur F.

## Contrôles,échecs conservés et durée de vie

Deux refus natifs expliqués :parent6927 sans ses enfants→15 ;acteur235249546 sans son bus Init3391474257→2. Les deux essais libèrent leurs objets et reviennent à un état d’allocations vide. Avec les enfants dans l’ordre natif et Init chargé,les mêmes ressources passent. Un premier assemblage du banc Init passait le holder au lieu de son membre+0x34 à AFF610 ;l’échec est conservé. Le récepteur a été corrigé conformément au caller AFB630,aucune donnée originale modifiée.

Cinq refus Rust :hiérarchie vide,valeur non finie,banque inconnue,événement inconnu et parent de son incorrect. Six falsifications du reçu sont rejetées :corps incomplet,parent supprimé,paramètre modifié,libération manquante,projection privée promue et chargeur non implémenté promu.

Les1291références détenues par le banc sont libérées par le code original ;l’index normal revient à zéro après chaque banque et aucun des objets de cette banque ne reste alloué. 4954allocations et4668libérations sont tracées. Les286allocations finales appartiennent au contexte encore vivant Init/managers/capacités ;elles ne sont pas annoncées libérées par le moteur. La fermeture de l’émulateur libère son espace privé,mais ne qualifie pas le teardown historique. Les1199blocs machine observés sont contrôlés contre le PE. L’allocateur,les verrous physiques et trois feuilles Windows TLS/last-error sont adaptés ;la copie mémoire native exécute ses instructions. Aucune concurrence historique qualifiée.

## Périmètre restant

Le banc appelle directement les constructeurs/lecteurs2/5/7 dans l’ordre original ;il n’exécute pas encore le lecteur complet de section AFB630 pour ces banques. Les autres types HIRC,les effets19 et ENVS d’Init sont exclus. Le gestionnaire RTPC réel est initialisé ;aucune chaîne sélectionnée n’active RTPC8 pour ce calcul. Pas de voix active,lecture audio,mixage ou son audible vérifié ici.

Suite :lecteur complet de section et wrappers,autres classes HIRC/actions/événements/atténuations/effets,propriété/unload du holder,dispatch et producteurs actuels. Puis voix,DIDX,streaming,boucles/seek,génération,mixage,autres locales et sortie physique.

## Livraison

Preuve docs/fidelity_rea_hierarchy_v755.json ;détails F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision755_*. Trois registres et documents coverage/completion_plan/resume_checkpoint enrichis. Deux fiches/deux bases avec deltas compressés ciblés ;cases,notes,historiques,autres tâches et inconnues conservés. VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED consignent les vérifications sans déclarer le système audio ou le jeu terminé.
