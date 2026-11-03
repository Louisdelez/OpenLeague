# SYS-01.2-02 — Voix et propriété audio, V762

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB. Cette livraison enrichit les liens source/consommateur de SYS-01.2-02 et SYS-02.2-07. Elle ne termine ni ces tâches ni le jeu.

## Résultats vérifiés

REA6.4.0 et Ghidra12.1.4 ont résolu dix procédures,663 instructions et15 références dans le PE original complet. Session exportée et fermée sans erreur. Les adresses intérieures AECFEE/AED054 appartiennent à AECF80 ;AEDBB2 à AEDA10 ;B16389 à B16380 ;AEF09E à AEEF20. Les autres procédures examinées sont AED8D0,AEEA00,AF35A0,B1BA60,B1BA50 et B14010. Cette analyse statique ne qualifie pas à elle seule leur exécution complète.

Les six banques originales, dont Init, sont chargées dans le banc isolé. Elles produisent194 Sound et les descripteurs de médias. Pour31 médias résidents, AEDA10 enregistre la voix et acquiert le média/propriétaire ;AEEF20 retire l’inscription, libère la ressource de chemin, le média via B02040, sa banque via AFBFD0, puis la référence Sound. Les références média,banque et Sound reviennent aux niveaux initiaux. Les512octets de chaque voix sont comparés au résultat Rust. Deux limites :avant chargement audio,statut1 avec pointeur/owner nuls ;query nul,statut2 après inscription,que le cleanup retire.

1832 allocations et222 libérations observées ;1610 allocations restent vivantes, dont les banques,gestionnaires,noms et capacités de propriétaires. Pas de démontage global dans ce profil.1926 blocs exécutés sont recoupés octet par octet avec le PE immuable. Aucun nouveau décodage PCM :la preuve V761 reste héritée et distincte.

## Comparaison Rust

33 modules actuels complets et inchangés compilés avec Cargo locked/offline.33 comparaisons réussissent pour l’ordre des appels et tous les octets de la voix après cleanup. Les services aval sont un transport explicitement piloté par l’oracle natif :leurs effets sur les ressources ne sont pas exécutés dans cette comparaison. Cela vérifie le code d’orchestration, pas le raccordement complet au moteur.

31 refus d’un service média absent conservent le pointeur média et le propriétaire ;aucun appel de libération du propriétaire n’est poursuivi. Une voix de415octets est refusée avant tout appel. Trois contrôles du cache confirment qu’un recalcul absent échoue et qu’un succès de callback seul ne valide pas le cache.

Cinq consommateurs précis ajoutés :Runtime::cleanup,release_registration,Store::refresh_if_needed,configuration de chemin et acquire_recursive. Les deux derniers sont des liens statiques inspectés ;ils n’ont pas été exécutés dans cette nouvelle sonde Rust. Leurs implémentations et preuves antérieures sont conservées.

## Échecs et limites conservés

Les premiers bancs manquaient du gestionnaire de chemins,puis de la méthode virtuelle3C. Après fourniture de la véritable table virtuelle,la fabrique B16380 atteint AEE7C9 et s’arrête sur un contexte absent. Cet essai reste un échec de banc ;aucun cache forcé ou retour de succès artificiel ne le remplace. La fabrique complète,le constructeur de voix et son propriétaire restent ouverts.

La première capture Free était prise après le retour du transport et lisait la mauvaise position de pile. Elle est conservée comme capture intermédiaire incorrecte ;le script final distinct capture les arguments avant retour et les recoupe avec le journal des allocations. Six mutations de preuves sont rejetées par l’audit.

Contexte encore fourni :mémoire de voix,parent,query123/manager vide,table de chemins32,tête intrusive de propriétaire et callback restant=-1. Les incréments Sound et acquisition récursive de propriétaire sont natifs ;le constructeur englobant n’est pas qualifié. Allocations,verrous,TLS et atomiques sont des transports physiques contrôlés. Aucun processus historique,jeu complet ou périphérique audio exécuté.

## Livraison et traçabilité

Preuve :docs/fidelity_rea_voice_lifetime_v762.json. Reçus et scripts :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision762*. Le PE conserve SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les empreintes du PE,banques,sources Rust,exécutable de sonde,commandes et journaux sont référencées dans la preuve.

Registre,trace,deux fiches/deux bases,couverture et reprise enrichis par deltas ciblés. Cases,notes,historiques,inconnues,prérequis et autres tâches restent conservés. Aucun fichier de produit ni asset modifié. VERIFIED et INDEPENDENT_READBACK attestent la publication seulement lorsqu’ils existent et réussissent. Le validateur natif est partagé ;la relecture de publication vérifie indépendamment les inversions et tables.

Suite :constructeur/contexte de voix et recalcul autour de AEE7C9,puis fabrique et raccordement des services réels. Streaming,boucles/seek,génération,mixage,concurrence,provider,autres médias/locales et sortie physique restent ouverts.
