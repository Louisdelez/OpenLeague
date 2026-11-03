# SYS-01.2-02 — Enregistrement des voix et sortie audio, V764

Projet F:/OpenLeague ; référence PUBLIC 4.20.0.315 EUW/en_GB. Deux fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Aucune tâche globale ni jeu complet déclaré terminé.

## Résultat

REA 6.4.0, Ghidra 12.1.4 : 10 procédures, 855 instructions et 182 références recoupées avec le PE original. Fonctions B0CE90, B0D900, B0CC40, B160D0, B0DDF0, B17F50, AEE0F0, AFD530, AEBE20 et B16380. Les références aux globals de sortie et de registre sont incluses. Session exportée, fermée sans erreur. AF5CE0 et B0C6B0 ont été suivies par désassemblage direct et exécution du même PE ;elles ne font pas partie des dix décompilations REA de ce lot.

Six banques originales, dont Init, fournissent194 Sound. Le caller B0CE90 alloue les parents de960octets, initialise les décodeurs et passe par B0D900/B160D0/B0DDF0. Les31 médias résidents sont inscrits chacun dans la liste native :count1,head=tail=parent. Le packet de requête indique succès par son octet12. La sortie fallback et son graphe sont créés par B0C6B0 avec masque3,48000Hz et tampon8192octets.

Le constructeur AF5CE0 initialise réellement le contexte secondaire :taille écrite100octets,drapeaux C0000001,gains1.0 et masque listener1. Il remplace les valeurs manuellement fournies qui provoquaient une lecture invalide dans AEC7B4. La mémoire256octets de stockage et l’identifiant123 restent fournis ;la fabrique amont B09BF0 n’a pas été exécutée.

Deux appels B0DFC0 par voix,soit62 frames,sont exécutés après B17A30. Tous les tampons observés contiennent2048float nuls. Cela ne valide pas un mixage audible. Quatre passages B0ED50/B17830 sont observés ;les autres chemins et le contexte de temps/listener restent à qualifier.31 recalculs AEE790 sont observés dans ces cycles.

B17E00 demande l’arrêt ;la frame retire le parent du registre puis B0CC40/B17F50 libère ses dépendances. AF3AA0 consomme les notifications et détruit la voix :références Sound,banque,média et partie basse30bits du secondaire restaurées. Deux nœuds de file sont présents après frame active puis arrêt,et sont drainés à0.32 cycles de fermeture incluent le refus du parent.2275 allocations,635 libérations,1640 allocations de banques/managers/sorties/capacités encore vivantes.4107 blocs exécutés correspondent aux octets du PE.

## Refus et erreurs conservés

Refus ponctuel de l’allocation960octets/pool19 :B0CE90 renvoie2,aucun parent inscrit,notification native puis nettoyage complet de la voix. Le test laisse les allocations de notification disponibles ;il ne remplace pas le refus global déjà documenté en V763.

Essais conservés :collision entre adresses d’adaptateurs clock/atomic ;registre callback manquant ;drapeaux de secondaire fournis incorrects ;assertion de sonde qui attendait un seul nœud de file malgré la notification produite par la frame. Ces erreurs de banc ne sont pas présentées comme défauts du jeu historique. Le banc final utilise les corps natifs et les contextes déclarés corrigés.

## Consommateurs actuels

22 modules Rust inchangés compilés hors ligne avec Cargo locked ;exécutable de sonde terminé code0. audio_device_factory::Runtime::create appelle audio_fallback_device::Runtime::configure via un adaptateur explicite propre à la sonde. Les44octets du descripteur et8192octets du tampon initial concordent avec le résultat natif. Deux consommateurs précis sont liés dans le registre.

Cinq cas limites :clock absent,buffer désaligné,allocation buffer refusée,allocation device refusée,type non qualifié. Les deux premiers renvoient une erreur mais conservent le descripteur dans le runtime ;ils ne constituent pas un nettoyage complet. Le refus d’allocation buffer retire le descripteur ;les deux autres renvoient0 sans objet créé. Aucun effet matériel ni lecture sonore actuelle prouvé.

La composition produit audio_factory_fallback existe et a été inspectée ;ses anciens tests ne sont pas réexécutés ici. La présente sonde ne qualifie pas cette composition complète,le registre des parents courant ni le mixer courant. Aucun code produit ni asset modifié.

## Limites et suite

Exécution native isolée Unicorn ;allocations physiques,verrous,TLS,atomiques et clock adaptés. Clock fixé1000,aucune progression du scheduler. Registre callback36octets vide,contexte engine64octets,query manager vide,requête123,priorité nulle,file capacité64 et table de chemins32 fournis. Pas de bootstrap historique complet,concurrence,périphérique physique ni teardown global.

Prochaine investigation :B09BF0 et le manager d’objets,événement/listener,puis décision B17A60 et scheduler. Streaming,seek/boucles,génération,autres médias/locales,provider et sortie audible restent ouverts. Les64bits de pointer/context ne doivent pas être inventés à partir des seuls snapshots32bits.

## Vérification et livraison

Six mutations refusées :propriétaire média erroné,référence Sound non restaurée,refus parent transformé en succès,octets exécutables altérés,échantillons positifs inventés,refus clock masqué. Empreintes des scripts,binaires,banques et modules conservées. PE SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Preuve :docs/fidelity_rea_registered_voices_v764.json. Travail :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision764*. Les registres,trace,deux bases,documents de couverture et reprise sont enrichis par deltas réversibles. Autres tâches,cases,notes,historiques,inconnues et prérequis conservés. VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED confirment la livraison seulement lorsqu’ils existent et réussissent ;le validateur natif est partagé,les contrôles de publication sont indépendants.
