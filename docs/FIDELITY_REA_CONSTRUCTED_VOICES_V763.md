# SYS-01.2-02 — Constructeurs et durée de vie des voix, V763

Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB. Association de sources et de consommateurs pour SYS-01.2-02 et SYS-02.2-07 ;ces tâches et le jeu restent partiels.

## Résultat et preuve originale

REA 6.4.0 avec Ghidra 12.1.4 analyse le PE original complet :12 procédures,689 instructions et17 références. Le reçu confirme export et fermeture de session sans erreur. Les fonctions inspectées sont B15BC0,B15C60,B15AF0,B2B410,B17810,B17840,B0CE90,B163B0,B176E0,B16030,AEE790 et AECF80. AEE7C9 est résolue dans AEE790. AFD530/AEBE20 ont été retrouvées par désassemblage direct du même PE et exécutées ;elles ne font pas partie de cette série REA.

B15BC0 construit réellement le parent de960octets avec vtable FF166C. AFD530/AEBE20 allouent et construisent les voix de424octets,avec vtable FF0CDC,référence Sound,référence secondary et insertion dans la liste propriétaire. La méthode virtuelle30 du parent est donc réelle :le blocage AEE7C9 de V762 est dépassé.

Les six banques originales,dont Init,produisent194 Sound et les descripteurs des médias utilisés. Pour31 médias résidents,B16380/B163B0 initialise le décodeur FF3748 ;fréquence et nombre de frames concordent avec le manifeste.29 recalculs AEE790 sont exécutés ;deux profils dont parent+30 vaut0 n’en déclenchent pas. Les31 réacquisitions AECF80 du même média/banque réussissent et conservent les références. Son résultat pertinent est AL ;les bits supérieurs d’EAX ne sont pas une valeur booléenne.

B17850 arrête le décodeur,AECEE0/AF36B0 publie une notification,puis AF3AA0 exécute AEEF20 et AEC160. Les32 cycles,refus de décodeur inclus,restaurent les références média,banque,Sound et secondary ;voix,parent et nœud de file sont libérés.2114 allocations et504 libérations :1610 allocations de banques,managers,noms et capacités restent vivantes.2800 blocs exécutés sont recoupés avec le PE. Aucun nouveau PCM calculé ;V761 reste une preuve distincte.

## Limites et refus vérifiés

Une allocation260octets/pool19 refusée une fois donne le statut2 du constructeur de décodeur ;la fabrique originale publie elle-même l’échec et le nettoyage s’achève. Une allocation424octets/pool17 refusée renvoie une voix nulle sans mutation du registre d’allocations. Sans parent,AECF80 renvoie AL0.

Le refus de toutes les allocations n’est pas un échec correctement géré :après le décodeur,les deux allocations du nœud de notification échouent aussi ;le code natif atteint AF36DC avec une écriture non mappée. Cet essai et les autres échecs sont conservés. Le test ponctuel réussi ne masque pas cette limite.

Contexte encore fourni :allocation physique du parent avec taille/pool observés dans B0CE90,secondary256octets avec référence1,requête/query123,priorité nulle,manager de query vide,table de chemins32 et capacité64 de file. Les corps natifs sont exécutés dans Unicorn ;allocation,verrous,TLS et atomiques sont adaptés. Aucun processus de jeu historique,périphérique audio ou concurrence réelle. Le caller B0CE90 complet et le producteur du contexte événement restent ouverts.

## Consommateurs Rust actuels

22 modules complets inchangés compilés avec Cargo locked/offline,puis sonde exécutée avec code0.29 comparaisons de recalcul concordent sur bloc84octets,drapeaux,entrées,paramètres dérivés et spatial. Les sorties des callbacks natifs sont importées explicitement ;les services backend complets ne sont pas reconstruits par ce test.29 absences du service de paramètres sont refusées sans valider le cache.

32 publications concordent sur la file,le nœud20octets et tous les424octets de voix ;32 absences du service de drainage sont refusées.32 destructions concordent sur tous les424octets ;le transport delete vérifie les octets,avec ressource optionnelle44 nulle dans ces profils. Trois consommateurs précis sont liés :State::refresh,immediate_action et Runtime::destroy. Aucun code produit ni asset modifié.

## Audit et conservation

Six altérations de preuve sont rejetées :mauvais propriétaire,référence Sound non restaurée,échec décodeur masqué,octets PE modifiés,intégration backend indûment déclarée et refus de drainage caché. Le premier audit regardait la première libération de toute la séquence,qui appartient à la réacquisition ;le contrôle corrigé vérifie l’ordre dans la phase de fermeture. Script initial conservé.

Les essais antérieurs avaient un drapeau de musique liée fourni à tort,un callback simulé de notification hérité,une capacité de file nulle et une attente erronée de31 recalculs. Le banc livré utilise le constructeur original et le corps réel AECEE0 ;aucun callback de succès artificiel ne remplace ces opérations.

## Livraison

Preuve :docs/fidelity_rea_constructed_voices_v763.json. Dossier de travail :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision763*. Source PE SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les reçus épinglent scripts,banques,sources Rust,commandes,exécutable et journaux.

Registre,trace,deux fiches/deux bases,couverture et reprise sont enrichis par deltas ciblés. Cases,notes,historiques,autres tâches,inconnues et prérequis restent conservés. VERIFIED et INDEPENDENT_READBACK ne valent confirmation que s’ils existent et réussissent. La relecture partage le validateur natif et vérifie indépendamment les inversions de fichiers et tables.

Suite :caller B0CE90 et contexte événement,réacquisition vers un autre propriétaire,puis streaming,boucles/seek,génération,mixage et sortie physique. Aucun moteur audio complet ni jeu complet qualifié.
