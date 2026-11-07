# AUD-22.1-04-MOUNT-01 — Application du profil au Loader

Contrôle : 2026-10-30T11:36:52.142556+00:00. Parent SYS-22.1-04 ; précision de PROVIDER-MOUNT-01. Résultat d'audit uniquement : aucun changement du Goal, du jeu, du suivi ou des bases.

## 1. Question, critère et décision

Question : où le traducteur du profil est-il transmis au Loader, et quels chemins appliquent ou n'appliquent pas le profil ? Critère de fin : identifier le point d'application, vérifier les arguments réellement produits et les limites de sélection/repli ; distinguer transmission, stockage et instance historique.

**Audit terminé pour le protocole d'application et ses appels.** Le gestionnaire applique le premier profil après un chargement déclaré réussi. Le profil transmet son objet +0x20 au Loader comme état de type 1. Les chemins de repli et d'échec sont établis. Le stockage de l'état et son utilisation historique effective ne sont pas déclarés vérifiés.

| Dimension | État |
|---|---|
| Audit | Terminé pour sélection/repli et transmission des arguments |
| Implémentation | Protocole natif présent ; raccordement des textes au Rust inchangé et toujours partiel |
| Vérification | Partielle : méthodes originales de contrôle exécutées en émulation, avec frontières de chargement et stockage explicitement adaptées |
| Acceptation humaine | Non demandée |

PROVIDER-MOUNT-01 demeure ouverte pour le stockage/relecture et l'instance effective. Cette unité ne clôture pas SYS-22.1-04 ou la localisation complète.

## 2. Sources et réutilisation

Source : League of Legends.exe PUBLIC4.20.0.315 du déploiement fourni, 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le chemin complet et les octets des méthodes sont dans mount-proof.json.

PROVIDER-01 est réutilisée pour le constructeur du profil, son traducteur à +0x20 et sa vtable. La preuve de dictionnaire est conservée avec son SHA256 e56f20e4e4fc20b10617ab17990b92c799342590266fea2debeb6bbadfdd14bc ; ses 12 cas ne sont pas rejoués.

L'analyse REA V795 de 0x790E20 fournit déjà ses appels entrants à 0x791327 et 0x791347, dans 0x791310. Elle est consultée pour cette nouvelle question ; le lecteur 0x796350 et l'extraction FFDec ne sont pas relancés. Aucun nouveau logiciel ni ressource n'est téléchargé.

## 3. Consommateurs et chaîne native

Trois identités de dispatch sont confirmées par les données du PE :

| Table et entrée | Méthode |
|---|---|
| Gestionnaire 0x10B68B4, +0x74 | 0x791310 : chargements, replis et application du profil |
| Profil 0x10B6BDC, +0x04 | 0x796070 : application au Loader |
| Loader 0x1110EB0, +0x08 | 0x9D0720 : frontière SetState |

0x791310 tente successivement 0x790E20 et 0x791040 pour la locale demandée, puis les deux mêmes chemins pour le littéral natif `en_us`. Si toutes les tentatives échouent, il demande la journalisation de `Failed to load any localizations!`. Aucun profil n'est appliqué dans cette branche.

Après un succès, 0x79137C teste le nombre de profils à this+0x28. Si non nul, il charge le premier pointeur de la liste this+0x24 et appelle sa méthode +0x04, à 0x79138E. Les arguments sont le Loader intégré à this+4 et un contexte issu du global 0x2D78F1C +0x38.

Dans 0x796070, les trois premiers appels au slot SetState transmettent successivement : type 17, null ; type 19, profil+0x1C ; type 1, profil+0x20, à 0x7960DB. Cette transmission est antérieure au traitement des bibliothèques de polices. Les arguments traducteur/profil vérifiés sont donc directement reliés au point de montage trouvé.

Le chemin de stockage, identifié statiquement pour la reprise, comporte plusieurs objets : 0xCE7090 relaie le Loader vers son implémentation ; la table 0x111194C utilise 0x9DAC60, qui relaie vers l'objet interne ; la table interne 0x1111550 conduit à SetState 0x9D3BC0 et GetState 0x9D3C70. Les constructeurs 0xD00D90 et 0x9D3A10 établissent ces tables et champs. Aucun de ces relais ou stockages n'est présenté comme exécuté par le diagnostic actuel.

Le consommateur Rust demeure celui audité dans RESP-01 et SEARCH-01. Son code n'a pas été modifié ; une application correcte du profil dans le client original ne prouve pas que le Rust résout actuellement les textes.

## 4. Exécution, attendu et observé

Commande exécutée avec code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-MOUNT-01/verify_mount.py`. Neuf cas réussis. Les outils déjà présents, leurs versions et empreintes sont identifiés dans le reçu.

Le diagnostic exécute la méthode originale complète 0x791310 et 0x796070 dans le cas contrôlé où la liste de bibliothèques de polices est vide. La branche normale du contrôle de cookie original est également exécutée ; la chaîne FS de contrôle est restaurée. Les entrées et objets sont déclarés, pas extraits d'un processus historique.

Frontières adaptées et conservées comme telles : 0x790E20 / 0x791040 renvoient des résultats de chargement déclarés et fournissent la liste contrôlée de profils ; 0x9D0720 enregistre les arguments puis retourne, sans stocker d'état ; 0x5FA170 enregistre une demande de journalisation, sans exécuter le logger original. Aucune réponse de ces frontières n'est présentée comme une observation de chargement ou de stockage natif réel.

| Cas | Attendu et observé |
|---|---|
| Premier chemin réussi | Une demande en_GB, application du profil fourni |
| Second chemin réussi | Deux demandes en_GB, application après la seconde |
| Troisième chemin réussi | Deux échecs en_GB puis succès du premier chemin en_us |
| Quatrième chemin réussi | Deux demandes en_GB et deux en_us, application après la quatrième |
| Échec des quatre chemins | Aucune application, une demande de journalisation du message natif |
| Succès déclaré sans profil | Aucune application et aucune demande d'erreur par ce wrapper ; cas limite déclaré, pas un fichier historique qualifié |
| Deux profils fournis | Seul le premier est appliqué |
| Traducteur nul dans le profil | L'argument type 1 transmis est nul ; son acceptation ou effet par le stockage n'est pas vérifié |
| Échecs avec liste antérieure fournie | Aucune application par cette branche du wrapper ; aucune conclusion sur les effets internes des vrais chargeurs |

Pour chaque application, le récepteur observé est exactement le Loader du gestionnaire. Le pointeur du traducteur transmis est exactement celui du premier profil sélectionné. Les traces et arguments sont conservés dans mount-proof.json.

La liste de polices vide est un contrôle isolant cette frontière ; elle ne remplace pas le profil fontconfig historique comportant sa bibliothèque. Aucun chargement de fichier, branche d'allocation de bibliothèques, stockage/relecture natif, rendu, réseau ou processus de jeu/Flash n'est exécuté.

## 5. Résolu et ouvert

Résolu : point d'application retrouvé ; identité du profil choisi et du Loader reliée par les appels natifs ; traducteur transmis sous type 1 ; ordre des replis, absence d'application en échec et cas limites vérifiés dans le contrôleur original.

Ouvert : stockage et relecture du pointeur via la vraie StateBag ; remplacement/suppression et références ; bibliothèques de polices ; état historique effectif, overlays et point d'appel de la méthode du gestionnaire au démarrage ; rendu et diagnostic Rust. Une demande SetState observée ne constitue pas un état enregistré ou un GetState réussi.

Le repli natif porte ici le texte exact en_us, distinct de la référence demandée en_GB. Aucun en_GB réellement introuvable n'est simulé comme un fait historique. Aucune interprétation du registre EAX comme drapeau de succès général de la méthode n'est inventée.

Les inconnues parentes et les anciens reçus sont conservés sans écriture dans les registres. Aucun asset manquant n'est démontré par ces cas.

## 6. Actions et conditions de reprise

Précisions documentaires sous SYS-22.1-04 :

| Action | Critère de fin | Entrée de reprise |
|---|---|---|
| MOUNT-STORE-01, suite de PROVIDER-MOUNT-01 | Vérifier que SetState puis GetState retrouvent le même objet sous type 1 ; distinguer remplacement, suppression par null et état absent. Conserver les références et déclarer tout adaptateur d'environnement. | Méthodes 0x9D3BC0 / 0x9D3C70, table 0x1111550 et contexte StateBag initialisé. Les helpers de conteneur et verrouillage doivent être qualifiés avant de leur attribuer un résultat ; aucun GetState ne doit être remplacé par une réponse fabriquée |
| MOUNT-BOOT-01, même rattachement | Qualifier l'appel de la méthode +0x74 et le profil effectivement appliqué dans le contexte de démarrage retenu. Fin : entrée/locale, objet et éventuels overrides identifiés avec limites historiques explicites. | Nouveau point d'appel ou observation d'instance ; ne pas refaire les neuf contrôles du wrapper inchangé |
| PROVIDER-COPY-01, réutilisée | Qualifier la copie/encodage puis le texte visible séparément du montage. | Sources déjà identifiées dans PROVIDER-01 ; exécution dédiée |

Aucune correction fonctionnelle n'est exécutée. Le résultat de cette unité répond à son critère de transmission ; les autres travaux restent explicitement ouverts, sans les redéfinir comme terminés.

## 7. Livraison et relecture

Fichiers créés : ce rapport ; `F:/OpenLeague-work/audit-units/AUD-22.1-04-MOUNT-01/verify_mount.py` ; `mount-proof.json`, 78822 octets, SHA256 17d5a986458a93baa011e3dee20ac71e5360344b328d057b92dbe42ceb0471bd. Le reçu conserve identité du PE, producteur, outils, instructions, arguments et neuf traces, avec les limites explicites des adaptateurs.

Les sept rubriques sont couvertes pour le protocole. Contrôleur original exécuté ne signifie pas chargeur de fichiers original exécuté ; argument observé ne signifie pas stockage accepté ; contexte contrôlé ne signifie pas démarrage historique complet. Aucun code du jeu ou du suivi changé, aucun binaire du jeu lancé, aucune base ouverte, aucune installation/migration et aucune modification du Goal.
