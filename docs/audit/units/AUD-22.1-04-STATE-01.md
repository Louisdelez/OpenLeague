# AUD-22.1-04-STATE-01 — Stockage et relecture du traducteur

Contrôle : 2026-10-30T11:46:50.875738+00:00. Parent SYS-22.1-04 ; suite MOUNT-STORE-01 / PROVIDER-MOUNT-01. Audit isolé uniquement ; aucun changement du Goal, du suivi, des bases ou du jeu.

## 1. Question, critère de fin et décision

Question : après application d'un profil, les vraies fonctions natives stockent-elles son traducteur et le rendent-elles par GetState(1) ? Critère de fin de ce lot : vérifier cette identité, le remplacement, la suppression et l'état absent dans un contexte StateBag initialisé et déclaré ; expliciter références, environnement et limites.

**Audit terminé pour les états déjà présents dans une table préallouée.** Le même pointeur de traducteur est écrit puis relu par les fonctions natives. Suppression, état absent, références rendues au demandeur et repli vers un parent sont vérifiés. Les réponses de stockage et de lecture ne sont plus adaptées : seules trois primitives système le sont.

| Dimension | État |
|---|---|
| Audit | Terminé dans le contexte initialisé et pour les branches annoncées |
| Implémentation | Stockage natif présent ; raccordement du service de texte au Rust toujours ouvert |
| Vérification | Partielle : stockage, lecture et helpers originaux exécutés ; première insertion/allocation, concurrence et démarrage historique non exécutés |
| Acceptation humaine | Non demandée |

La première insertion et le montage historique demeurent ouverts. Ce résultat ne clôture ni SYS-22.1-04 ni la fonctionnalité de localisation complète.

## 2. Sources et preuves réutilisées

PE source : PUBLIC4.20.0.315 fourni, 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le chemin exact est conservé dans state-proof.json. Aucune ressource reconstruite.

MOUNT-01 a identifié l'appel SetState(1,profil+0x20) mais adaptait le récepteur. Son reçu mount-proof.json, SHA256 17d5a986458a93baa011e3dee20ac71e5360344b328d057b92dbe42ceb0471bd, est réutilisé et inchangé. Ses neuf contrôles de chargement/repli ne sont pas rejoués. La présente preuve qualifie une autre frontière, le stockage/retrait/retrieval réels.

Les constructeurs 0xD00D90 et 0x9D3A10 et les tables du PE fournissent les champs du contexte initialisé. Ils sont des sources de disposition mémoire ; leur exécution et leur durée de vie complète ne sont pas déduites de cette initialisation contrôlée.

## 3. Consommateurs réels

La chaîne originale exécutée comprend :

- Loader, table 0x1110EB0 : SetState 0x9D0720 et GetState 0x9D0740.
- Relais de l'implémentation par 0xCE7090 puis 0x9DAC60 ; tables 0x111194C et 0x1111550.
- Stockage 0x9D3BC0 et lecture 0x9D3C70.
- Mise à jour 0x9D8680, suppression 0x9D8710, comparaisons 0x9D96C0 / 0x9D9730 et retrait d'une entrée 0x9D71D0.
- Application originale du profil 0x796070 pour les cas concernés, avec liste de bibliothèques de polices vide, périmètre déjà explicité dans MOUNT-01.

Ces fonctions accèdent et modifient les nœuds de la table dans la mémoire isolée. Aucun adaptateur ne retourne un objet de StateBag ou un indice de recherche à leur place.

Consommateur courant : le chemin Rust de police et le widget de boutique restent ceux établis dans RESP-01/SEARCH-01. Une recherche délimitée dans crates/**/*.rs de StateBag, 9D3BC0, 9D3C70 et 1111550 n'a trouvé aucun candidat ; rg retourne 1, résultat attendu sans correspondance. La recherche de noms de fichiers state*bag / font*config / localiz ne trouve que native_hud_font_configuration.rs. Cela ne démontre pas une absence globale de mécanisme équivalent sous un autre nom ; l'écart de branchement repose sur la configuration maps/libraries et les affectations UI déjà inspectées.

## 4. Attendu, observé et contrôles exécutés

Commande : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-STATE-01/verify_state.py`. Code 0, dix cas réussis. Versions et empreintes de Python, pefile, Capstone et Unicorn conservées dans le reçu.

Contexte déclaré : table préallouée de 32 nœuds, types 17/19/1 déjà présents, références initiales fixées à 100 pour conserver les destructeurs hors périmètre ; hiérarchie parent fournie seulement dans le cas dédié. Les objets et tables sont initialisés selon les champs lus dans le code, sans exécution de leurs constructeurs. Aucun fichier historique n'est modifié pour fabriquer ce contexte.

Seuls les imports KERNEL32 InterlockedExchangeAdd, EnterCriticalSection et LeaveCriticalSection sont adaptés. Le premier met à jour le compteur mémoire et rend sa valeur précédente ; les deux autres contrôlent une exclusion sérielle déclarée et sa balance. Les pointeurs IAT ne sont adaptés que dans l'image émulée, pas dans le PE sur disque. Ce n'est pas une exécution des verrous Windows ni une preuve de concurrence.

| Cas | Attendu et observé |
|---|---|
| Profil appliqué puis GetState(1) | Même pointeur neuf 0x50004800, table de 2 états après retrait du type 17 |
| Remplacement direct puis lecture | Pointeur neuf retrouvé ; ancienne référence diminuée de 1 |
| Suppression directe puis lecture | Pointeur nul, entrée type 1 retirée |
| Type absent | Pointeur nul, aucune référence modifiée |
| Deux lectures du même traducteur | Deux retours identiques ; deux références rendues au demandeur |
| Suppression locale avec parent | GetState(1) rend l'objet du parent 0x50004A00 |
| Profil avec traducteur nul | Suppression du type 1 existant ; GetState(1) rend null sans parent |
| Loader sans implémentation | Pointeur nul, aucune entrée consultée ou modifiée |
| État présent sans modification | Ancien pointeur rendu avec une référence supplémentaire |
| Retrait d'un type absent | Table inchangée ; lecture de ce type nulle |

Exemple de comptage nominal : anciennes références 100→99, nouveau traducteur 100→101 pour la table puis 101→102 après GetState. Deux lectures conduisent à 103. Les références rendues au demandeur restent explicitement détenues dans le diagnostic ; elles ne sont pas déclarées libérées. Chaque cas vérifie les compteurs attendus/observés et le nombre d'entrées. Les appels de verrouillage sont équilibrés, la pile et la chaîne FS sont restaurées.

Non exécutés : insertion d'un type non nul absent, allocation/réallocation, déplacement après collision, destructeurs arrivant à zéro, constructeurs complets, libération finale, concurrence Windows, chargement historique et rendu. Les collisions du dictionnaire de textes vérifiées dans PROVIDER-01 ne qualifient pas les collisions de cette autre table.

## 5. Résolu et limites restantes

Résolu : la frontière SetState/GetState n'est plus seulement observée par un adaptateur. Les instructions originales remplacent/retirent l'entrée et la relisent, avec identité du pointeur et références contrôlées. Le repli vers un parent est établi pour la hiérarchie déclarée, pas comme ordre historique d'overlays de fichiers.

MOUNT-01 conserve ses limites de chargement ; ce reçu ultérieur apporte la preuve de stockage pour la table déjà initialisée. Les anciens résultats ne sont pas réécrits et ne deviennent pas rétroactivement des exécutions de stockage.

Restent ouverts : première insertion/allocation, collisions et croissance de la table, durée de vie complète, environnement concurrent, point d'appel et instance effective au démarrage historique, copie/encodage et texte visible. La mise en place initiale du traducteur dans un Loader neuf n'est donc pas qualifiée par ce seul cas de remplacement.

Les références et inconnues parentes sont conservées. Aucun manque d'asset n'est démontré ; le manque de réalisation courant reste le service de texte branché à la langue sélectionnée et à ses consommateurs.

## 6. Actions et reprise

Précisions documentaires sous les tâches existantes, sans création de tâche dans l'application :

| Action | Critère de fin | Entrée de reprise |
|---|---|---|
| STATE-INSERT-01, suite MOUNT-STORE-01 | Vérifier SetState d'un type initialement absent puis GetState, création/croissance, collision et refus d'allocation applicables ; ne pas adapter le résultat de recherche. | Branche d'insertion 0x9D9440 appelée depuis 0x9D8680, initialisation/allocation du conteneur et helpers associés ; primitives d'environnement déclarées |
| STATE-LIFETIME-01, même rattachement | Vérifier références rendues puis libérées, remplacement jusqu'à zéro et destruction, avec ressources réellement observées. | Constructeurs/destructeurs et environnement propriétaire identifiés ; les références initiales artificiellement élevées ne suffisent pas |
| MOUNT-BOOT-01, réutilisée | Identifier l'appel de montage et l'instance/profil effectif dans le démarrage retenu, avec overrides et limites. | Nouvelle preuve d'appel ou d'instance ; ne pas rejouer les cas de remplacement inchangés |
| PROVIDER-COPY-01, réutilisée | Qualifier copie/encodage puis le texte visible séparément du stockage. | Sources déjà identifiées dans PROVIDER-01 |

Aucune correction du jeu n'est exécutée dans cet audit. La correction fonctionnelle devra fournir le contrat de résolution des textes dans le consommateur Rust adapté ; elle n'est pas une conséquence implicite de l'existence de cette StateBag native.

## 7. Livraison et relecture

Fichiers créés : ce rapport ; `F:/OpenLeague-work/audit-units/AUD-22.1-04-STATE-01/verify_state.py` ; son résultat state-proof.json, 239787 octets, SHA256 a834fba81fa1cb8e4fcf6e5745ea6ce0f34f30966bbec821b6e68c42f73dd0f4. Le reçu conserve les 13 plages d'instructions, imports, objets/tables déclarés, dix traces, opérations mémoire et compteurs, outils et limites.

Les sept rubriques sont couvertes pour le contexte annoncé. Stockage natif exécuté ne signifie pas création du Loader exécutée ; verrous adaptés ne signifient pas concurrence Windows validée ; références comptées ne signifient pas durée de vie complète prouvée ; audit clos ne signifie pas localisation du jeu terminée. Aucun processus de jeu ou Flash lancé, aucune base ouverte, aucune installation/migration et aucune modification du Goal ou du suivi.
