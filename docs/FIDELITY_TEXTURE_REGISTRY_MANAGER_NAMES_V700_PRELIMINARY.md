# SYS-01.2-02 — Gestionnaire de textures et noms, V700 préliminaire

UTC : 2026-10-27T23:13:05.445323+00:00. Projet : F:/OpenLeague. Source : client PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Les essais ci-dessous sont exécutés et revus, **leurs associations au registre canonique et aux deux fiches/bases restent à intégrer**. Dernier audit publié : V699, 99 826 sources/5613 consommateurs,42 215 exigences actives,26 189 inconnues ouvertes.

## Création et publication réellement parcourues

Le vrai préfixe9783D0 du PE identifié est exécuté dans une mémoire isolée. Il alloue le gestionnaire de80 octets, appelle deux initialisations de conteneurs et écrit lui-même le pointeur dans le global2D79030 à978457. Le host n'invente ni n'écrit ce pointeur. Les allocations CRT sont des adaptateurs explicites à blocs initialement nuls ;le bootstrap historique,les échecs d'allocation et l'allocateur réel ne sont pas qualifiés.

La revue confirme cinq blocs suivis :80+16+64+16+64=240 octets. Les deux headers de32 octets ont un compteur0,des régions suivies16/64 octets,masque7,capacité8 et mot0x3F800000. Les quatre derniers mots du gestionnaire sont0. Ces états ne prouvent pas qu'il est prêt à tous les appels.

Une seconde composition reprend le constructeur jusqu'au nom source poussé à978479 : **texture_registry_system_default**,littéral à10DB9A8. Elle s'arrête avant978482,appel vers978660. La fabrique de texture de secours et la fin du constructeur ne sont pas exécutées. Les11 mots de pile conservés sont bruts ;leur capture n'établit pas une signature de11 arguments.

## Routine de noms exécutée séparément

Le même conteneur construit par le code original est utilisé pour appeler99B170. Il s'agit d'une composition contrôlée séparée, pas du déroulement complet du constructeur. Deux appels emploient le nom réel par défaut du code ;cinq autres sont des contrôles explicitement synthétiques. Ils ne remplacent aucun asset ou nom ordinaire de portrait.

Attendu : retour de la méthode,données d'entrée inchangées,chaîne détenue égale aux octets demandés,pas d'allocation supplémentaire lors des répétitions et état du second conteneur inchangé. Observé :sept retours réussis,cinq identités distinctes,répétitions à la même adresse sans nouvelle allocation. Le premier conteneur passe de0 à5 entrées ;le second reste à0 et le slot4C reste nul. Quinze blocs/389 octets restent détenus dans le tas suivi ;aucun teardown n'est revendiqué.

| Appel | Octets d'entrée,hex | Adresse retournée | Hash natif observé à l'insertion | Nouveaux blocs |
|---|---|---|---|---:|
| native_default | 746578747572655f72656769737472795f73797374656d5f64656661756c74 | 0x408000f0 | [2410742636] | 2 |
| native_default_repeat | 746578747572655f72656769737472795f73797374656d5f64656661756c74 | 0x408000f0 | [] | 0 |
| control_upper | 4f70656e4c656167756550726f626541 | 0x40800120 | [3937439165] | 2 |
| control_lower | 6f70656e6c656167756570726f626561 | 0x40800150 | [928743741] | 2 |
| control_empty |  | 0x40800180 | [2166136261] | 2 |
| control_unsigned_ff | ff | 0x408001a0 | [2047574606] | 2 |
| control_empty_repeat |  | 0x40800180 | [] | 0 |

**99B170 renvoie une adresse de chaîne internée, pas la valeur du hash.** La boucle d'insertion observée est confrontée à un calcul indépendant FNV-1a32. Les variantes de casse exercées donnent des adresses et valeurs FNV distinctes. La chaîne vide et l'octetFF sont des contrôles ;ils ne qualifient pas tous les encodages ou règles de collision.

## Deux contrats de hash à conserver séparément

Le module courant crates/client/src/relic_texture_name.rs porte8E50F0 :multiplication65599,minusculesASCII et octets signés. Il ne résout pas les chemins/VFS. Les calculs de la colonne65599 ci-dessous proviennent de ce source ;ce ne sont pas de nouvelles exécutions Rust ou8E50F0. Aucun code de production n'est remplacé.

| Entrée | Calcul FNV-1a32 confronté à la boucle native | Calcul du contrat65599 porté |
|---|---:|---:|
| native_default | 2410742636 | 541137391 |
| native_default_repeat | 2410742636 | 541137391 |
| control_upper | 3937439165 | 1235798506 |
| control_lower | 928743741 | 1235798506 |
| control_empty | 2166136261 | 0 |
| control_unsigned_ff | 2047574606 | 4294967295 |
| control_empty_repeat | 2166136261 | 0 |

Les deux variantes de casse ont la même valeur65599 et des valeursFNV distinctes. Cela ne transforme pas le consommateur de cache de fichiers en consommateur de99B170 ou978820. Une association exacte à l'internement et à l'inscription reste à qualifier ;aucune absence globale de code n'est déduite d'une recherche textuelle.

Le vrai nom par défaut est une clé logique interne, pas un fichier VFS. Les termesVFS des notesV698/V699 doivent donc être précisés selon le caller. Le nom ordinaire des portraits et son producteur restent ouverts ;un label technique du banc ne devient pas un nom normal par cette observation.

## Vérifications et binaires

Les revues refusent chacune cinq falsifications :publication manquante,taille/état de conteneur modifiés,constructeur prétendument terminé ;puis nom source remplacé,fabrique prétendument exécutée,hash de fichier substitué au hash interne et identité de répétition changée. Les quatre commandes V700_MANAGER_PREFIX,V700_MANAGER_REVIEW,V700_NAME_INTERN,V700_NAME_REVIEW ont code attendu/reçu0. La revue du préfixe conserve un SyntaxWarning Python nonfatal sur l'écriture0and ;les assertions s'exécutent et son journal est conservé. Aucun échec n'est masqué comme réussite.

Le PE source est identifié par SHA-256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les instructions parcourues sont comparées aux octets originaux. Unicorn2.1.4 émulex86/32bits ;le checkpoint identifie actuellement l'installation et sa bibliothèque native :{'path': 'F:\\OpenLeague\\tools\\pythonlibs\\unicorn\\lib\\unicorn.dll', 'bytes': 9598976, 'sha256': '010d85dce84b8f6ffaec3d5420f1b5f7768f859eb831be574c7da23e656ee8f1'}. Il ne prétend pas capturer en direct une bibliothèque d'un processus déjà terminé.

Aucun nouvel appel graphiqueAPI/GPU,jeu ou rendu n'est exécuté. Le nom par défaut,l'allocateur adapté,les structures et les contrôles sont séparés des entrées historiques effectives encore inconnues.

## Livraison et limites

Préfixe :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision700_registration_constructor_prefix\OBSERVATIONS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision700_manager_prefix_review\REVIEW.json. Noms :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision700_native_name_intern\OBSERVATIONS.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision700_name_intern_review\REVIEW.json. Scripts,reçus,journaux et états bruts restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Ce rapport,preuveJSON,couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF sont ajoutés/actualisés avec sauvegardes et conservation des anciens champs. Le registre canonique,les tâches,inconnues et bases ne sont pas modifiés par ce checkpoint. Aucune case cochée et aucun code/asset de production changé.

Restent ouverts :fin du constructeur,fabrique978660 et sélecteur de backend1225B04,inscription978820 et ownership,nom ordinaire des portraits,collisions,croissance au-delà de8buckets,concurrence,échecs d'allocation et teardown. Le sélecteur1225B04 n'est pas le copy-mode1225C58. Les preuves V699 et antérieures,ARGB8/DXT,résiduscompression83 non acceptés,alphaopaque,DLL2014,Kalista288octets et12noms restent conservés. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V699 intégré/audité :12continuations après pontS_OK déclaré,TLS1,surface0,texture publiée,wrapper20 détenu,arrêt avant98964D→978820 ;99826sources/5613consommateurs,deuxfiches/bases et données manuelles conservées. V700 exécuté/revu mais associations canoniques àfaire :vrai constructeur9783D0 publie manager80 via978457,initialise deux headers32/cinq blocs240,puis pousse le nom source texture_registry_system_default à10DB9A8 avant978482→978660 non exécuté. Routine99B170 appelée séparément sept fois sur ce nom réel et contrôles explicites :retouradresseCstring stable,5identités,répétitions sansallocation,casse distincte,FNV1a observé en insertion. Quinze blocs389 encore détenus,secondconteneur etslot4C restent0,constructeurcomplet non terminé. Cette routine ne renvoie pas le hash :FNVsert en interne ;le hashfichier8E50F0/65599minuscule est un autre contrat et reste inchangé. Le nom par défaut est une clé logique interne,pas un cheminVFS :corriger/préciser avec historique la condition trop générale de nomVFS dans les notesV698/V699 ;qualifier le nom issu du vrai producteur par caller,portraits encore ouverts. Associer d’abord ces preuves V700 au registre et aux deuxfiches/bases,conserver8descripteurs sans inventer un consommateur global de978820. Puis qualifier la suite978660 et son sélecteur1225B04,constructeur complet/fabrique de secours,inscription/ownership,nom des portraits/UV/couleur/sampler ettransportactuel. Ne pas forcer un backend ;copymode1225C58 distinct. Collisions,croissance>8buckets,concurrence,allocateur en échec et teardown restent non qualifiés. Les calculs65599 du lecteur sont source-derived,pasnouvelle exécutionRust ou8E50F0. La revue préfixe a un SyntaxWarning nonfatal conservé dans son journal. AcquisARGB8/DXT,résidus83 non acceptés,alphaopaque,DLL2014,Kalista288octets et12noms ouverts conservés. Avantprepare vérifier réserve4GiBF et scratch privé ;aucune suppression/case automatique. Goal actif,aucunécran/jeuaccepté.
