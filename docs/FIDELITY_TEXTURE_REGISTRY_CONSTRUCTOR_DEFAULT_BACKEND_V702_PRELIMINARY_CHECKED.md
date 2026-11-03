# SYS-01.2-02 — Constructeur et backend initial : V702 préliminaire

UTC : 2026-10-27T23:32:18.331010+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Essais exécutés et revus ;**associations au registre et aux deux fiches/bases encore à intégrer**. Dernière intégration V701 :99855sources/5613consommateurs,42215exigencesactives,26189inconnuesouvertes.

## Attendu et observé

Attendu : poursuivre le constructeur original9783D0 avec le sélecteur1225B04 lu dans le PE, sans le remplacer par un backend choisi ;observer son retour,le résultat de978660 et les allocations, puis distinguer un retour de fonction d'une création graphique réussie.

Observé : les octetsPE02000000 valent2 et restent inchangés. Le constructeur publie lui-même le manager80 via978457,appelle978660 et la routine99B170 dans son vrai flux. La fabrique lit1225B04 à978713,passe par97873A/978807 et retourne un objet nul via978816. Ni978733→9BF2D0 ni978759→9B17E0 ne sont exécutés. Le constructeur poursuit9784CB et retourne réellement à978506 avec pile équilibrée. Il ne crée pas de texture par défaut ;le slot4C reste0,le conteneur de noms compte1entrée et le second0.

Huit blocs328octets restent suivis :80+16+64+16+64+32+16+40. Le bloc40 est conservé dans l'observation ;son ownership et son teardown ne sont pas qualifiés. Ce constat isolé ne le classe pas comme fuite du jeu historique. Aucun manager prêt à l'inscription ou rendu normal n'est déduit du seul retour.

Les instructions natives sont comparées aux octets du PE. L'allocateur CRT à blocs nuls,free et la feuille de cookie sont des adaptateurs explicites ;le bootstrap historique et les échecs d'allocation ne sont pas reconstitués. Le résultat décrit un contexte d'image initiale non configurée, pas les paramètres effectifs d'une partie historique.

## Producteurs de backend encore à qualifier

Une recherche de motifsMOV directs trouve deux candidats :

| Adresse candidate | Instruction décodée |
|---|---|
| 0x9b410f | mov dword ptr [0x1225b04], 1 |
| 0x9c16c5 | mov dword ptr [0x1225b04], 0 |

Une lecture supplémentaire depuis les prologues9B3D00 et9C1430,précédés de padding,confirme que ces écritures sont sur des frontières d'instruction décodées. Un parcours statique peut les atteindre en supposant le retour des appels ;il ne prouve pas leurs préconditions réelles. Les candidats d'appels directs sont9B6506→9B3D00 et9C40A4→9C1430. Ces fonctions et leur ordre au démarrage ne sont pas exécutés. Les28occurrences brutes de l'adresse dans les sections exécutables ne prouvent pas28références de contrôle valides. Les écritures indirectes/aliases ne sont pas exhaustivement recensées. Le désassemblage de978660..978819 est borné ;il ne fournit pas une signature complète ou le sens historique de chaque backend. Ce sélecteur1225B04 reste distinct du copy-mode1225C58.

## Contrôles, refus et identités

Cinq falsifications sont refusées :sélecteur prétendument remplacé,texture par défaut prétendue,appel de créationbackend prétendu,manager déclaré prêt et retouroriginal manquant. Aucune mémoire invalide,guard conservé,pile de retour vérifiée ;code0 attendu/reçu pour les quatre étapes.

| Étape | Attendu | Observé | SHA-256 journal |
|---|---:|---:|---|
| V702_DEFAULT_BACKEND_CTOR | 0 | 0 | a2b112f6de292ced45201a816f31a9aca0b7b30578985a1dca57d0a5095f2b36 |
| V702_SELECTOR_STATIC | 0 | 0 | a4210b7ec53e202058614d6ed57d43b04c52731e36996c38f15613c8dd208292 |
| V702_CTOR_REVIEW | 0 | 0 | 8294d8ff93d81770bf053b1fe25dbfd809f033eab6a59f629b7263d23f4c98c6 |
| V702_SELECTOR_PRODUCER_CONTEXT | 0 | 0 | ce5f9d321f74eede09c11a1a5ad093b49c0dc5a2184fd84dd8f00970e4597306 |
| V702_CONSTRUCTOR_CHECKPOINT_FIRST_FAILED | 0 | 1 | 693abec1d8b9e0ef222daf0f7f6c5fc397df4b944ed00370867b6945791c2010 |

PE source15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Python3.12.14 x64 et Unicorn2.1.4 émulentx86/32bits. Les fichiers de runtime identifiés par V700 sont rehachés ;cela ne constitue pas une capture en direct des bibliothèques du processus V702 terminé. AucunAPI/GPU,frame ou test Rust n'est exécuté.

Le premier script d'enregistrement du checkpoint a échoué avec NameError,importgzip manquant,avant la première sauvegarde ou modification des documents de travail. Le script suivant importe explicitementgzip/hashlib/os/shutil. Le premier script,son journal code1 et ses deux brouillons de rapport/preuve sont conservés et pinés. Ce rapport et cette preuve distincts constituent le checkpoint corrigé ;les quatre étapes natives/statiques/revue restent code0. Les brouillons précédents ne constituent pas une mise à jour réussie du plan.

## Livraison et limites

Script natif :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_constructor_default_backend.py. Observation :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_constructor_default_backend\OBSERVATIONS.json. Candidatsstatiques :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_backend_selector_static\OBSERVATIONS.json. Contexte statique :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_selector_producer_context\OBSERVATIONS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_constructor_review\REVIEW.json. Rapport et preuveJSON ajoutés ;couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF actualisés avec sauvegardes et anciens champs conservés. Aucune base ou fiche canonique n'est changée par ce checkpoint,aucune case cochée,aucuncode/asset de production modifié. V701 et les preuves anciennes conservent leur état daté.

Restent ouverts :intégration de V702,producteur/ordre effectif du backend,création de secours dans un contexte configuré,inscription978820/signature/ownership,nom normal des portraits,UV/couleur/sampler,transportactuel,collisions/croissance/concurrence/échecs etcleanup. AcquisARGB8/DXT et limites résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V701 publié/audité : V700manager/noms intégrés,99855sources/5613consommateurs,2fiches/2bases et donnéesmanuelles conservées. V702 exécuté/revu mais associations canoniques àfaire :constructeur9783D0 retourne réellement avec1225B04=2 initialPE inchangé ;978660 appelle99B170,puis prend978807 et renvoie objetnul,slot4C reste0,8blocs328 détenus. Retourconstructeur ne prouve pas création de texture ou manager prêt. Deux candidatsstatiques écrivent1 à9B410F et0 à9C16C5 ;qualifier leurs fonctions/callers et ordre de bootstrap avant de tester un contexte configuré,ne pas forcerbackend. Associer d’abord V702 au registre et2fiches/bases avec historique de la même question,préserver limites et8consommateurs. Puis qualifier producteur1225B04,création normale0/1,inscription978820/signature/ownership,nomportrait réel/UV/couleur/sampler/transportactuel etcleanup. Copymode1225C58/provider90AD00 distincts. Garder40bytebloc nonclassé :ownership/teardown nonqualifiés,pasdéclaration de fuite. AcquisARGB8/DXT/résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Réserve4GiBF/scratchprivé requise avantprepare ;aucunesuppression/casepromue. Goal actif,aucunécran/jeuaccepté.
