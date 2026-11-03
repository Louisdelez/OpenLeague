# SYS-01.2-02 — Constructeur et backend : intégration V703

UTC : 2026-10-27T23:53:17.359484+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. Cette livraison intègre les preuves V702 au registre et aux deux bases du plan. Elle conserve la différence entre retour de fonction et création d'une texture.

## Résultat établi

Le constructeur original9783D0 retourne réellement avec1225B04=2,les octets initialement lus dans le PE. Le host ne remplace pas ce sélecteur. La fabrique978660 appelle99B170 dans son vrai flux,puis prend978807/978816 et retourne un objet nul. Le constructeur poursuit9784CB et retourne978506 avec pile équilibrée. Le conteneur de noms compte1entrée,le second0 et le slot de secours4C reste0.

Attendu/observé :sélecteur inchangé,parcours original et retour vérifiés,aucun appel de création0/1 ouAPI/GPU,pas de texture de secours créée. Huit blocs328octets restent détenus :80+16+64+16+64+32+16+40. Le bloc40 n'est pas classé comme fuite :ownership et teardown sont encore inconnus. Le constructeur retourne,mais le gestionnaire n'est pas qualifié prêt pour l'inscription ou le rendu normal.

Les allocations CRT à blocs nuls,free et feuille de cookie sont des adaptateurs explicites. Ce test décrit un contexte initial non configuré, sans prétendre connaître le backend effectif d'une partie historique. Aucun nouvel appel natif/API/GPU/Rust n'est exécuté par le lecteur d'associations V703.

## Initialisation restant à qualifier

| Prologue candidat | Écriture décodée | Valeur | Appels directs candidats |
|---|---|---:|---|
| 0x9b3d00 | 0x9b410f | 1 | ['0x9b6506'] |
| 0x9c1430 | 0x9c16c5 | 0 | ['0x9c40a4'] |

Le décodage depuis les prologues précédés de padding confirme les frontières des écritures. La traversée statique atteint ces instructions en supposant le retour des appels ;elle ne prouve pas la faisabilité de leurs préconditions ou l'ordre du bootstrap. Les références indirectes ne sont pas exhaustivement identifiées. Le sélecteur1225B04 reste distinct du copy-mode1225C58 et du provider90AD00.

La clé source logique texture_registry_system_default reste connue ;le nom normal des portraits ne l'est pas. Le retour de99B170 est une adresseCString,FNV sert à l'insertion ;le hash de fichiers8E50F0/65599minuscule garde son rôle. Ces contrats et leurs consommateurs actuels ne sont pas fusionnés.

## Registre et deux bases

SYS-17.3-01 et SYS-01.2-02 reçoivent 1 lien natif EXE et 38 sources nouvelles. Huit descripteurs actuels sont revérifiés sur leurs fichiers/lignes et conservés dans leurs rôles ;aucun consommateur de moteur ajouté ou promu.

OLU-ac85c18c-d131-517e-83a7-d0987d643c48 est précisée avec ancien texte et condition en historique. Elle reste ouverte ;propriétaires,aspects,statuts et autres inconnues sont conservés. Graphe :99893sources/5613consommateurs,42215exigencesactives,26189inconnuesouvertes/5517résolues antérieures. Les pins de cette livraison sont vérifiés séparément ;ce compteur n'est pas un rehachage de tout le catalogue.

Cinq falsifications sont refusées :texture prétendue,sélecteur remplacé,producteur historique prétendument exécuté,valeur d'écriture modifiée et manager prétendu prêt. Cinq mutations de candidat sont refusées ;inversion documentaire exacte,inversionSQLite logique et idempotence vérifiées. Les deux bases publiées et auditées conservent chacune42605autreslignes,42607étatsmanuels et23historiques. Aucun prérequis levé ou case automatiquement cochée.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V702_DEFAULT_BACKEND_CTOR | 0 | 0 | a2b112f6de292ced45201a816f31a9aca0b7b30578985a1dca57d0a5095f2b36 |
| V702_SELECTOR_STATIC | 0 | 0 | a4210b7ec53e202058614d6ed57d43b04c52731e36996c38f15613c8dd208292 |
| V702_CTOR_REVIEW | 0 | 0 | 8294d8ff93d81770bf053b1fe25dbfd809f033eab6a59f629b7263d23f4c98c6 |
| V702_SELECTOR_PRODUCER_CONTEXT | 0 | 0 | ce5f9d321f74eede09c11a1a5ad093b49c0dc5a2184fd84dd8f00970e4597306 |
| V702_CONSTRUCTOR_CHECKPOINT | 0 | 1 | 693abec1d8b9e0ef222daf0f7f6c5fc397df4b944ed00370867b6945791c2010 |
| V702_CONSTRUCTOR_CHECKPOINT_CHECKED | 0 | 0 | 141ba46895629e38b36e92dd799ae68f21a0cbbb2271b5d5ecd5060f62e19410 |
| V703_ASSOCIATIONS | 0 | 0 | fe24850bffc8cb7946e3bc195ed39e32c3d838fc349a8f86afcf6d1a83a6bb15 |
| V703_STORAGE | 0 | 1 | a2e862351bd030b3805ecfe4ef33986edfa05c8d8e40f5d3aa5d14cb1cdbbe0a |
| V703_STORAGE_CHECKED | 0 | 0 | dae66f050bc6e8055542bcd92536bab4fc2634c461558e7e69a801395cdb6018 |
| V703_PREPARE | 0 | 0 | 5681b1bcf880f6116bf6361b1e798b6ad56841595e5b5997ced0987db1000205 |
| V703_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V703_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V703_DELIVERY_AUDIT | 0 | 0 | 73b4dd8569f6024267a0fc41e0b0f42aeab01c13f5390ee6f3536d5aeb27b471 |

Le premier checkpoint V702 a échoué avec NameError(importgzip manquant)avant toute sauvegarde/modification du plan. Une source distincte importe les dépendances manquantes et réussit ;le script initial,son code1 et ses deux brouillons restent pinés. Ces brouillons ne sont pas une mise à jour réussie du plan.

Le premier contrôle de réserve disque V703 s'est arrêté avec code1 à3850522624octets libres,avant préparation/publication. Ses cinq compressions préservent les octets. Une source distincte vérifie une ancienne copie candidate V640,publiée/auditée et fermée,puis la compresse sans suppression ou toucher aux bases actives ;le garde4GiB est conservé. Les deux résultats sont conservés.

## Fichiers et limites

Rapport présent,preuve docs/fidelity_texture_registry_constructor_backend_v703.json et reçu docs/reference_requirement_trace_sources/texture-registry-constructor-backend-v703.json ajoutés. REG/TR/SRC/UNK actualisés ;IDS et ordre phases/lots byte-identiques. Couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF actualisés avec sauvegardes et anciens champs conservés. V702 préliminaire garde son état daté ;V703 est son intégration ultérieure. 4 preuves fermées compressées sans perte,taille/SHA et sidecars contrôlés,aucune suppression ou base active touchée ;scratch privéF et garde4GiB conservés.

Lecteur :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision703_constructor_backend_associations\OBSERVATIONS.json. Observation native :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision702_constructor_default_backend\OBSERVATIONS.json. PE15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Exécution V702 héritée :Unicorn2.1.4,x86/32bits,instructions comparées aux octetsPE ;runtime et scripts pinés. V703 n'exécute aucun nouveau test Rust,build moteur ou frame.

Restent ouverts :producteurs/ordre du backend configuré,création de secours normale0/1,inscription978820/signature/ownership,nom normal des portraits,UV/couleur/sampler,transportactuel,collisions/growth/concurrence/échecs etcleanup. AcquisV699/ARGB8/DXT et limites résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V703 a intégré/audité V702 dans le registre et deuxfiches/bases :constructeur9783D0 retourné avec1225B04=2 PE inchangé,fabrique978660 objetnul,slot4C0,8blocs328 dont40nonclassé. Retourconstructeur ne prouve ni texturecréée ni managerprêt. Huitconsommateurs et donnéesmanuelles conservés,questionouverte historisée. Suite :qualifier producteurs9B3D00/9C1430,callerscandidats9B6506/9C40A4 et ordrebootstrap,avantcontextesnormaux0/1 ;aucunbackendforcé. Les écritures1/0 et cheminsstatic sousretourdesappels ne prouvent pas startuphistorique. Comparer séparément configurationRustactuelle DefaultPlugins/WgpuSettings sans réutiliser arbitrairement le rôle matériau de l’ancremain651. Puiscréationsecours,inscription978820/signature/ownership,nomportrait réel/UV/couleur/sampler/transportactuel etcleanup. Garder distinctions1225B04/1225C58/provider90AD00 etCString/FNV/hashfichier8E50F0. ÉcheccheckpointV702/code1 réparé danssource distincte conservé. AcquisV699/ARGB8/DXT,résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Vérifierréserve4GiBF/scratchprivé avantprepare,aucunesuppression/casepromue. Goalactif,aucunécran/jeuaccepté.
