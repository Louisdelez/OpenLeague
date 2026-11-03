# AUD-22.1-07-PROVIDER-01 — Dictionnaire natif du profil de langue

Contrôle : 2026-10-30T11:25:04.459058+00:00. Parent SYS-22.1-07 ; action KEY-DIAG-01. Lot d'audit documentaire avec exécution isolée d'instructions. Aucun changement du Goal, du suivi, des bases ou du jeu.

## 1. Question, critère de fin et décision

Question : quel traducteur est construit par le profil fontconfig, et comment sa recherche distingue-t-elle clé présente, clé absente et valeur vide ? Sortie : type concret lié aux sources et résultat de recherches originales sur des entrées explicitement identifiées, avec limites séparées.

**Audit terminé pour le traducteur du profil et sa recherche de table.** La vtable est 0x10B6BC4 ; son entrée +0x10 ajoute les textes via 0x795EC0, son entrée +0x14 traduit via 0x795FB0. La recherche originale 0x79A2F0 / 0x79ABC0 trouve une valeur native vide comme une entrée existante et retourne -1 pour une clé absente dans les tables contrôlées.

| Dimension | État |
|---|---|
| Audit | Terminé pour cette classe et sa recherche, pas pour le choix de l'instance historique effective |
| Implémentation | Dictionnaire natif présent ; raccordement général au widget Rust non réalisé, constat déjà établi dans RESP-01/SEARCH-01 |
| Vérification | Partielle : fonctions originales complètes de recherche/comparaison émulées ; traducteur complet, copie/encodage et rendu non exécutés |
| Acceptation humaine | Non demandée |

SYS-22.1-07 reste ouverte : ce lot n'implémente aucun diagnostic dans le jeu courant et ne qualifie pas tout le parcours historique.

## 2. Sources et réutilisation

PE PUBLIC4.20.0.315 et fontconfig en_GB/fr_FR du déploiement original fourni. Leurs empreintes concordent avec les preuves précédentes. Le résultat lookup-proof.json conserve leurs chemins exacts et identités. Aucune ressource n'est remplacée ni reconstruite.

L'analyse REA V795 de 0x796350 est réutilisée, pas relancée. Son fichier `revision795_rea_locale_text/observations/3da1a10b-9ea3-4074-a537-c57cccca24b6/007-analyze_function-response.json`, SHA256 7130ae9aaa09a944d0e6548eb7da8f511f4dc94e88d70c354d77e21e1d3bfc9e, reste identique. Elle montre le traitement de tr puis l'appel virtuel d'ajout à 0x796BCB, via l'objet du profil à +0x20.

Les deux textes de placeholder proviennent de la ligne 368 ; la valeur vide de `flash_itemShop_categories_searchoverride_Vision` est présente à la ligne 293 dans les deux locales. Le cas de collision utilise la vraie clé `flash_itemShop_categories_back`, valeurs Back / Retour. La clé `openleague_audit_missing_68` est une entrée de contrôle synthétique, dont l'absence dans les fichiers sources a été vérifiée ; elle n'est pas présentée comme une clé historique.

## 3. Consommateurs et chaîne établie

- Le constructeur de profil 0x7838C0 alloue un objet, initialise son type à 1 à 0x783969, pose la vtable 0x10B6BC4 à 0x783977 et conserve cet objet à profil+0x20, à 0x7839AC.
- Dans le lecteur de tr hérité, 0x796BBA charge profil+0x20 et 0x796BCB appelle son entrée +0x10. La vtable conduit à 0x795EC0, qui transmet les données à 0x797350 pour ajout au conteneur.
- L'entrée +0x14 est 0x795FB0. Elle construit la clé, appelle 0x79A2F0 à 0x796004, teste l'indice et, si trouvé, transmet la valeur au copieur 0xD02A10. Après retour de ce copieur, elle prévoit true ; si l'indice est négatif, elle prévoit false.
- 0x79A2F0 calcule le hash sur les octets de la clé et appelle 0x79ABC0. Ce comparateur suit les chaînes de collision et compare les clés octet par octet. Ces deux fonctions, sans réponse de lookup substituée, sont celles exécutées dans ce lot.

Le lien avec le wrapper/callback est documenté dans CALLBACK-01 : le gestionnaire obtient un état de type 1 depuis le Loader GFx et appelle son entrée +0x14. **La pose effective de ce traducteur de profil dans le Loader historique reste non prouvée.** Identifier la classe construite ne suffit pas à affirmer qu'aucune autre instance ou surcharge n'était montée.

Le consommateur courant reste celui inspecté dans RESP-01/SEARCH-01 : le lecteur Rust charge les polices sans produire de dictionnaire tr et shop_ui affecte un littéral français. Aucun consommateur supplémentaire n'est inventé.

## 4. Contrôles exécutés, attendu et observé

Commande exécutée : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-07-PROVIDER-01/verify_lookup.py`. Code 0, 12 cas réussis. Les versions et empreintes de Python, pefile, Capstone et Unicorn sont dans le reçu. Aucun outil installé.

Deux tables contrôlées contiennent chacune six enregistrements réels de la locale correspondante. Les valeurs sont copiées sans modification depuis des lignes simples identifiées du fontconfig. Les allocations, le format mémoire des chaînes et le placement des nœuds sont explicitement construits par le diagnostic. Ce ne sont ni le dictionnaire historique complet, ni un résultat du parseur natif complet.

L'émulateur exécute intégralement 0x79A2F0 et 0x79ABC0 jusqu'au retour, sans callback donnant une réponse de recherche. Le hash, la comparaison et le parcours de collision utilisent les instructions originales. Les cas sont exécutés pour en_GB et fr_FR :

| Cas | Attendu et observé |
|---|---|
| Placeholder présent | Indice 6 ; valeur sélectionnée Click Here to Search / Cliquez ici pour rechercher |
| Clé présente, valeur vide | Indice 1 ; chaîne vide conservée comme valeur existante |
| Autre clé du même bucket | Chaîne de collision parcourue, indice 0 ; Back / Retour |
| Clé absente dans le même bucket | Chaîne parcourue, indice -1, aucune valeur sélectionnée |
| Variante de casse en entrée directe | Indice -1 pour FLASH_ITEMSHOP_SEARCH_PLACEHOLDER dans ces tables |
| Table nulle, contrôle de limite | Indice -1, sans tentative de lire des nœuds |

La valeur sélectionnée est relue directement dans la mémoire de contrôle après la recherche. **La copie native, sa conversion de caractères et l'affichage ne sont pas exécutés.** La variante de casse qualifie la recherche directe par octets, pas une éventuelle normalisation en amont. Le contrôle de table nulle n'est pas une observation d'un échec de chargement du jeu historique.

## 5. Ce qui est résolu et ce qui reste ouvert

Résolu : classe du traducteur de profil, liaison avec l'ajout tr, méthode de traduction et recherche de table identifiées ; clé présente et valeur vide distinguées d'une clé absente ; parcours de collision et retour -1 vérifiés par les fonctions originales. La recherche inspectée ne contient aucun appel de diagnostic pour le cas absent.

La composition avec le repli du wrapper est désormais étayée pour cette classe : indice absent → branche false du traducteur, puis clé d'entrée selon CALLBACK-01. C'est une composition de preuves statiques et d'exécutions isolées, pas un parcours complet exécuté. Les couches externes peuvent encore journaliser des erreurs.

Restent ouverts : instance effective et éventuels overlays au démarrage historique ; conversion/normalisation de clé ; copie de la valeur ; durée de vie du tampon partagé ; résultat graphique ; diagnostic dans le client Rust. Aucun fichier manquant n'est démontré. La valeur vide sourcée ne doit pas être automatiquement assimilée à une traduction manquante sans son contexte d'usage.

L'inconnue parente OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f reste conservée. Aucun registre ou statut n'est réécrit.

## 6. Actions et conditions de reprise

Précisions documentaires sous les tâches existantes :

| Action | Critère de fin | Entrée de reprise |
|---|---|---|
| KEY-DIAG-01 sous SYS-22.1-07, réutilisée | Distinguer clé absente, valeur vide sourcée et ID d'objet absent ; qualifier le diagnostic dans la couche responsable, avec attendu/observé. Aucun fallback silencieux ajouté comme faux succès. | Résolveur Rust défini et instruction autorisant la réalisation fonctionnelle ; les sources nécessaires sont présentes |
| PROVIDER-MOUNT-01 sous SYS-22.1-04 | Relier l'objet profil+0x20 à l'état de type 1 effectivement obtenu par le Loader. Fin : point d'application et instance/état identifiés ; autres fournisseurs ou overrides explicitement distingués. | Nouvelle preuve ciblant l'application du profil / SetState(1,translator) ou une observation de l'instance ; ne pas refaire le lecteur 0x796350 ni la recherche de table inchangés |
| PROVIDER-COPY-01 sous SYS-22.1-04 | Qualifier copie et conversion d'une valeur réelle, puis le texte visible. Fin : source, entrée, sortie et limites pour un cas nominal et un caractère non ASCII, sans confondre extraction et rendu. | 0xCED210 / 0xD02A10 et consommateur graphique accessibles ; exécution distinctement identifiée |

Le lot s'arrête à son critère de fin. Les recherches précédentes ne sont pas répétées sans nouvelle piste. Aucune correction fonctionnelle n'est exécutée ; cette absence est conforme au périmètre d'audit autorisé.

## 7. Livraison et relecture

Nouveaux fichiers : ce rapport ; `F:/OpenLeague-work/audit-units/AUD-22.1-07-PROVIDER-01/verify_lookup.py` ; `lookup-proof.json`, 99552 octets, SHA256 e56f20e4e4fc20b10617ab17990b92c799342590266fea2debeb6bbadfdd14bc. Le reçu conserve sources, sous-ensembles exacts, disposition mémoire, octets et instructions, résultats, traces des collisions, outils et limites. Aucun fichier volumineux antérieur n'est dupliqué.

Les sept rubriques sont couvertes. Tables contrôlées sourcées ne signifient pas dictionnaire natif complet ; fonctions de recherche exécutées ne signifient pas traducteur complet exécuté ; classe identifiée ne signifie pas montage historique prouvé ; audit terminé ne signifie pas fonctionnalité terminée. Aucun processus de jeu/Flash lancé, aucune base ouverte, aucune migration/installation et aucune modification du Goal ou de l'application.
