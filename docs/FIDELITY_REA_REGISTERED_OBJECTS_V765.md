# SYS-01.2-02 — Objets audio enregistrés, V765

Projet F:/OpenLeague ; référence PUBLIC 4.20.0.315 EUW/en_GB. Association de sources et consommateurs pour SYS-01.2-02 et SYS-02.2-07. Tâches et jeu restent partiels.

## Progrès vérifié

REA6.4.0/Ghidra12.1.4 :12 procédures,1147 instructions,138 références. B09A90,B09BF0,B09D10,B09D90,AF5CE0,AF6270,AF6400,AF5D80,B17A60,B171F0,B0D010 et B09B60. Session exportée et fermée sans erreur. B09FE0,B0A0C0,B0A080 et leurs dépendances ont également été suivis par désassemblage/exécution du même PE ;ils ne font pas partie des douze décompilations REA de ce lot.

Le manager réel B09A90 initialise193 buckets et l’objet réservé0,avec masque255 et une source nulle de24octets. B09BF0 alloue les objets100octets et leurs nœuds12octets.32 identifiants de test123+193*i produisent volontairement une chaîne de collision dans le bucket123. Leur origine est un contexte déclaré de test,non une série d’identifiants historiques du jeu.

31 médias résidents passent les voix/parents réellement construits,enregistrés et arrêtés ;un refus ponctuel du parent960octets complète les32 cycles. Les objets proviennent maintenant du registre natif au lieu d’une mémoire secondaire fournie. La position nulle est appliquée par B09FE0/AF6400/AEEDC0. Les références voix sont acquises puis restituées aux objets.

Le retrait global B0A0C0 détruit les32 objets ordinaires et conserve l’objet0. B0A080 retire ensuite ce dernier et la capacité initiale96octets.34 destructions AF5D80 sont capturées :33 objets enregistrés et un objet temporaire dont le nœud a été refusé.2390 allocations/767 libérations ;1623 allocations de banques,sorties et autres capacités restent vivantes. Le manager d’objets est retiré,le moteur entier ne l’est pas.4265 blocs exécutés concordent avec le PE.

## Refus et comportement inhabituel

Allocation objet100octets refusée :pointeur nul,table inchangée. Allocation nœud12octets refusée :objet temporaire détruit/libéré,table inchangée. Réenregistrer un objet existant ne réalloue rien ;masque0x181 tronqué à0x81 et drapeau dirty positionné.

Position d’objet absent :statut2,sans mutation. Passage d’une à deux sources avec allocation48octets refusée :l’ancien stockage est libéré,AEEDC0 renvoie52,mais B09FE0 renvoie1. Le pointeur et le nombre de sources deviennent0 ;mode7 et dirty sont néanmoins appliqués. Le résultat public seul ne prouve donc pas le stockage de la position.

Les62 décisions B17A60 sont capturées :58 refusent,4 autorisent la suite. Les62 tampons de sortie demeurent entièrement nuls. Le registre d’objets correct ne suffit pas à qualifier le mixage audible. Les gains du wrapper,leur seuil,les listeners et le transfert de sortie restent à suivre.

## Consommateurs Rust existants

Cinq modules complets inchangés sont compilés avec Cargo locked/offline. La sonde termine avec code0.33 enregistrements et applications de position,32 acquisitions de référence,quatre cas limites,32 retraits globaux et le retrait réservé0 concordent sur les champs représentés :identifiant,sources,mode,masque et bits dirty/référence.

Les snapshots natifs avant limites/retrait sont importés explicitement pour représenter les effets des frames. Le Rust de frame/mixage n’est pas exécuté dans cette sonde. Les pointeurs,nœuds physiques,pools,gains et libérations natives ne sont pas représentés par ces interfaces logiques ;leur concordance n’est pas revendiquée.

Deux tests existants sont relancés séparément :120 cas de registre et768 cas de stockage de sources. Chacun termine avec1 test réussi,0 échec. Le refus de position fraîchement capturé ne peut pas être injecté directement par l’API publique apply_registered ;le test privé historique d’allocation refusée reste une preuve distincte. Cette limite est conservée.

Le consommateur register déjà indexé est réutilisé. Trois consommateurs précis sont ajoutés :acquire,unregister et apply_registered. Aucun code produit ni asset modifié. Deux fixtures de tests existantes sont indexées comme sources locales de comparaison,sans autorité native :elles n’étaient pas encore présentes dans le registre. Le premier audit s’est arrêté sur ce manque d’index ;sa preuve d’échec est conservée.

## Périmètre et vérification

Exécution isolée Unicorn,avec allocations physiques,verrous,TLS,atomiques et clock adaptés. Manager828octets de stockage fourni ;constructeur et sous-allocations natifs exécutés. Requête/identifiants de test,priorité,query manager,callback registry,contexte engine,table de chemins32 et file64 restent explicites. Clock fixé1000 ;aucun scheduler historique complet,périphérique physique ni concurrence.

Six mutations de preuve refusées :mauvais propriétaire média,référence Sound non restaurée,refus parent transformé en succès,octets PE altérés,sortie positive inventée,refus de nœud Rust masqué. PE SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Reçus épinglés :sources,banques,scripts,modules,fixtures,commandes et exécutables.

## Livraison et suite

Preuve :docs/fidelity_rea_registered_objects_v765.json. Dossier F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision765*. Registre,trace,deux bases,couverture et reprise enrichis par deltas réversibles. Autres tâches,cases,notes,historiques,inconnues et prérequis conservés. Les reçus VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED confirment seulement les étapes réellement réussies ;validateur natif partagé,contrôles de publication indépendants.

Suite :B171F0,gain wrapper+258,seuil121022C,producteurs de gains/listeners,B170C0,transfert de sortie et scheduler. Streaming,seek/boucles,génération,provider,concurrence,autres médias/locales,sortie physique et intégration complète restent ouverts.
