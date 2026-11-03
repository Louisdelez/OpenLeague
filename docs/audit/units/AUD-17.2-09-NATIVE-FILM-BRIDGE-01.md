# AUD-17.2-09-NATIVE-FILM-BRIDGE-01 — Pont natif, film absent et conversion bornée

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Exigences fonctionnelles conservées : SYS-17.2-09 et SYS-17.4-07.

## 1. Question, frontières et critères de sortie

Question issue du buffer natif : quels arguments Add_Message transmet-il au dernier appel du film, que fait le pont quand le film manque et quelle est la portée de sa conversion à capacité fixe ? Le convertisseur actuel doit être inspecté avant de déclarer une implémentation absente.

Sortie du lot : identifier pont/forwarder, disponibilité et readiness séparées ; observer les octets originaux jusqu’à l’appel virtuel sans le simuler ; qualifier les limites propres à la capacité du pont ; réutiliser les preuves de conversion existantes avec leurs dates/écarts d’identité ; documenter consommateurs, inconnues et sept rubriques. Aucun critère normatif du goal ou du plan n’est modifié.

| Dimension | Décision limitée |
|---|---|
| Audit | Terminé pour le pont préparé, son saut film absent et les limites sélectionnées, après reçu de livraison. |
| Implémentation | Aucun code produit modifié. Un convertisseur Rust générique existe déjà ; le consommateur chat/film fonctionnel reste non identifié dans les interfaces conservées. |
| Vérification |117contrôles réussis sur huit cas du pont original. Six cas s’arrêtent avant l’appel virtuel ; deux chemins film absent retournent normalement. Aucune qualification actuelle de tout le convertisseur Rust. |
| Acceptation humaine | Non demandée ; aucun affichage ou fonctionnement du jeu accepté implicitement. |

Exclus : implémentation du moteur de film, lookup et erreurs de la méthode virtuelle, montage et rendu, cycle de chargement complet, validation de tous encodages et appelants, réexécution des anciens tests Rust. La capacité du pont n’est pas déclarée longueur maximale autorisée d’un message de chat.

Un seul lot actif. Arrêt avant l’instruction CALL virtuelle0x79CD5D, frontière explicite. Aucun callee de film factice ; aucune répétition générale des2351anciens cas de conversion, désormais distingués des limites nouvelles du wrapper.

## 2. Sources et preuves identifiées

Client de référence : LoL4.20.0.315, EUW, en_GB. Le processus du client original n’est pas lancé.

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les adresses sont ses VA.

| Source sélectionnée | Intervalle, fin exclusive | Portée |
|---|---|---|
| Pont chaîne large | 793AA0–793B05 |34instructions ; présence film, conversion et forwarder. |
| Forwarder varargs | 79CD40–79CD61 |14instructions ; arguments de la méthode virtuelle. |
| Driver de conversion | 99B230–99B2BE |57instructions ; mode C-string et writer. |
| Writer UTF-16 saturant | 99BE50–99BF46 |91instructions ; intervalle hérité recontrôlé. |
| Lecteur de séquence d’octets | 99C2B0–99C37D |91instructions ; comportement legacy, sans conformité générale ajoutée. |
| Pont chaîne étroite | 7939B0–793A95 |85instructions ; contraste statique%s et diagnostics, non exécuté ici. |
| Getter readiness | 78B360–78B367 |2instructions ; lit l’octet+0x98. |
| Préfixe de constructeur chat | 7AB810–7AB8B0 |31instructions ; vtable concrète et initialisation ; fragment, pas constructeur entier qualifié. |

8intervalles,405instructions. Bornes, continuité et retours sont vérifiés sauf fin de fonction non revendiquée pour le préfixe. Les octets/empreintes sont dans le reçu.

La vtable0x10B8310 posée en7AB853 contient au slot+4 le getter78B360 et au slot+0x28 le drain7ABD50. Le getter lit byte[contexte+0x98]. Le pont793AA0 teste un autre champ, dword[contexte+4]. Leur relation de cycle de vie n’est pas démontrée par ces seules lectures.

Preuves héritées :

- [Buffer natif](F:/OpenLeague/docs/audit/units/AUD-17.2-09-NATIVE-BUFFER-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/native-buffer-proof.json), SHA-256 `62317d47095d3706861c2921281ddbb0888a5f2bb3379564ab5256237883d0e6` : demandes Add_Message puis retrait, guards de readiness/délai et pont AS2. Les28cas du buffer ne sont pas rejoués.
- [Preuve ChatInterrupt](F:/OpenLeague-work/audit-units/AUD-17.4-07-CHAT-INTERRUPT-01/interrupt-static-proof.json) : writer99BE50–99BF46, SHA-256 de l’intervalle `9964cb2931602813b8035ac14a694df5ded86f0b2eb1dd2c2d70e93ecf198a97`, comparé aux octets actuels.
- `data/4.20/audio_announcer_name_narrow_decoder_contract.json`,2351cas,331entrées, fonction99B230 et même PE d’origine ; SHA-256 `efb8dc06f2da335283b72c0d9d5e01b24fcc8b50ae95a61cae62bdd4f49c8fd7`. Capacités historiques0–11,36,64 ; longueur d’entrée maximale35octets. Ces cas ne couvraient pas la capacité fixe0x27FF du pont.
- `docs/announcer_name_encoding_validation.json`, daté2026-10-10T03:56:21Z : ancienne validation, complete=false. Ses tests et autres compteurs sont historiques, non exécutés dans ce lot.
- `CommandParser.as` menu et Menu_SC4 : identités/fragment Add_Message réutilisés du buffer, sans extraction/exécution des films. Montage effectif toujours non qualifié.

Outils existants : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et DLL, identifiés par empreinte. Aucune installation, nouveau PE, import REA/Ghidra ou réexport répété : les octets originaux et les preuves acquises répondent à ce lot.

## 3. Contrat du pont et consommateurs actuels

### Pont large : préparation d’un appel, pas résultat d’affichage

793AA0 réserve un cadre de pile0x5008octets, reçoit nom de méthode et pointeur de texte, puis teste contexte+4. Si ce champ vaut0, il saute conversion et forwarder et retourne normalement. Aucun retour explicite false ou code d’erreur n’est posé par ce chemin. Le registre EAX résiduel observé dépend du cadre ; il ne doit pas devenir un contrat booléen d’échec.

Si le champ est non nul, il appelle99B230 avec le texte, EDX=-1, un buffer de pile et la capacité0x27FF, soit10239unités. Puis il transmet le nom de méthode, le littéral `%ls` et le pointeur du buffer à79CD40, sans contrôler le compte retourné par la conversion.

79CD40 lit le récepteur via wrapper+0x0C et sa méthode virtuelle slot+0xC8. Avant le CALL, les arguments sont : nom de méthode, pointeur résultat nul, format%ls et pointeur de liste varargs dont la première valeur est le buffer UTF-16. C’est cette frontière exacte qui est observée en émulation ; l’implémentation virtuelle et son interprétation effective ne sont pas exécutées.

Le pont étroit7939B0 utilise%s et possède ses diagnostics propres. Il n’est pas assimilé au pont de texte large Add_Message ; ses diagnostics ne sont pas invoqués dans les essais de ce lot.

### Conversion : NUL inclus et saturation des unités

En mode C-string,99B230 inclut le premier NUL dans la plage de conversion. Le writer avance par unités16bits, avec deux unités pour les valeurs supérieures à0xFFFF. Lorsque la capacité est atteinte, les écritures suivantes saturent sur la dernière unité. Le NUL final peut donc y remplacer une unité utile.

À capacité10239, les essais ASCII montrent10238unités visibles et le NUL. La limite porte sur les unités UTF-16 de ce pont, pas sur les points de code, les octets réseau ou une règle de longueur de chat autorisé. Le test long peut être inaccessible dans un parcours ordinaire borné en amont ; cette atteignabilité reste inconnue.

À une frontière de paire de substitution, le NUL peut remplacer l’unité basse en laissant une unité haute isolée. Le comportement du moteur de film face à cette sortie n’est pas observé. Aucun défaut visuel ou vulnérabilité exploitable n’est conclu de ce test isolé.

### Implémentation Rust existante : conserver, ne pas reconstruire

`crates/core/src/audio_announcer_name_encoding.rs` contient déjà narrow_scalar, decoded_size et decode_cstring, puis la composition convert_name_bytes. Le helper decode_cstring gère explicitement la mémoire disponible, le NUL et les écritures saturantes ; il refuse une mémoire d’anticipation manquante avant mutation, au lieu d’inventer du padding. Ce code est un acquis.

`crates/core/src/audio_announcer_name_provider.rs:31` expose converted_name_with_native_encoding, qui appelle convert_name_bytes avec un backend de stockage explicite. Ce consommateur générique ne prouve pas une intégration de chat ou le playback complet de l’audio.

La composition de noms convert_name_bytes effectue préflight, conversion, recoupe/terminaison et retour multibyte/cache. Elle n’est pas le pont chat à capacité fixe. Une future intégration doit réutiliser la primitive correspondante après qualification, pas remplacer le pont par toute cette composition sans preuve.

Empreinte actuelle du module encoding : `6db6fb1487d94852782478b12487e7a38493d1005ee51bc84ffda818ac8d3589`,9801octets. Le reçu du10octobre donnait `ef2acab016df1fd9ba6cff21787155c9289f79716d30a5427594a62aa0cc0f57`. Même après normalisation CRLF→LF, l’empreinte `04c22fc788aaa8f204dc854ece3cd9e8bd7b7b8a256a91fe60636ce225a38897` ne correspond pas. Le provider a lui aussi une identité différente de celle du reçu historique. Cette différence ne démontre pas un bug ; elle interdit de promouvoir les anciens tests en qualification actuelle du module entier. Les deux sources et fragments actuels sont conservés dans le reçu.

### Autres consommateurs inspectés et absence bornée du pont chat

Le corpus1 168fichiers conserve les mêmes chemins et SHA-256 que le lot précédent. Une nouvelle recherche motivée par les fonctions/encodages du pont trouve le module encoding et `crates/client/src/native_font_descriptor.rs:23`. Ce dernier utilise from_utf8/encode_utf16 pour les noms de familles de police : c’est un consommateur distinct, pas un motif pour remplacer sa conversion par le codec legacy.

Les recherches, leurs deux résultats et fragments sont enregistrés. Les interfaces réelles de gameplay/session/bridge Tauri sont réutilisées par conservation : aucun service de messages ou pont de film chat fonctionnel n’y est identifié. Aucun constat d’absence générale d’Unicode ou de convertisseur Rust n’est formulé.

## 4. Contrôles exécutés et attendu/observé

`verify_native_film_bridge.py`, 2026-10-30T16:54:52Z–16:54:55Z, code0 :117/117 contrôles réussis. Les identités,405instructions sélectionnées, preuves héritées, huit cas et protections sont contrôlés ; les2351anciens cas ne sont pas rejoués.

Méthode : objet+4, wrapper+0x0C, récepteur, vtable, nom Add_Message, texte et pile sont des fixtures explicites. Le code original793AA0 et ses vrais callees de conversion/probe de pile/sécurité s’exécutent. Aucun patch ni stub. Pour les six cas avec film, arrêt AVANT CALL79CD5D : la cible de film n’est jamais exécutée. Pour les deux cas sans film, retour normal jusqu’à une sentinelle. Aucun appel OS ; écritures CPU bornées aux fixtures et à la pile, pas d’écriture de l’image native. Limite3millions d’instructions/10secondes par cas.

| Cas | Attendu | Observé |
|---|---|---|
| Film absent, texte valide | Saut conversion/invoke, retour normal | Conforme ; pile nettoyée. EAX résiduel, pas false explicite. |
| Film absent, texte nul, autre cadre | Aucun déréférencement du texte ni conversion/invoke | Conforme ; EAX résiduel différent. Le texte nul avec film présent n’est pas testé comme refus gracieux. |
| Film présent, bonjour | Appel préparé Add_Message, récepteur de fixture, résultat nul, %ls, bonjour UTF-16+NUL | Conforme, arrêt avant invocation. |
| Film présent, Été et emoji | Même marshalling, paire UTF-16 conservée | Conforme, six unités visibles et NUL. |
| Texte ab\0cd | Premier NUL termine la C-string | Buffer ab puis NUL ; cd non transmis. |
|10238A | Capacité10239 avec NUL |10238unités A, puis0 ; UTF-16 valide. |
|10239A | Saturation de la dernière unité | Même sortie10238A puis0, non pas10239A. |
|10237A suivis d’un emoji | La paire atteint la frontière |10237A, unité haute0xD83D, puis0 ; préfixe non valide en décodage UTF-16 strict. Comportement du film inconnu. |

Les buffers, préfixes/suffixes d’entrée, empreintes et unités finales sont dans le reçu. Les frames avec film n’ont ni retour de la méthode virtuelle ni résultat d’affichage. Les valeurs d’EAX du chemin absent sont observées seulement ; aucun nouveau résultat d’erreur applicatif n’est inventé.

La readiness native est une lecture de byte+0x98, distincte de contexte+4. Le buffer ne teste pas le résultat du pont dans les appels sélectionnés, mais ses gardes de readiness et de délai précèdent ces appels. Sans preuve du cycle de vie et de leur cohérence, aucune perte de messages en fonctionnement n’est déclarée.

Non exécutés : méthode virtuelle du moteur, film/ActionScript, montage, affichage réel, erreurs de lookup de méthode, input/réseau, preuve d’atteignabilité de textes aussi longs dans le chat ordinaire, tests/build Rust et acceptation humaine. La bibliothèque Rust reste un acquis inspecté, avec qualification historique datée et écart d’identité explicite.

## 5. Résolu, encore ouvert et conditions de reprise

Résolu : marshalling du dernier appel, garde film absent, readiness différente, capacité fixe et NUL, comportement à la frontière d’une paire, existence du helper Rust et nécessité de réutiliser son bon niveau de composition. La conversion n’est plus décrite comme absente ; sa qualification actuelle complète reste ouverte.

| Clause ouverte | Impact | Entrée précise et condition de reprise |
|---|---|---|
| Méthode virtuelleC8 et lookup de Add_Message | Pas d’exécution/réussite du film démontrée | Implémentation du récepteur et méthode appelée, film réellement monté ; cas méthode trouvée/absente et succès/erreur observables. |
| Readiness+0x98 contre pointeur+4 | Atteignabilité d’un appel sans film pendant le drain inconnue | Producteurs/écritures de ces champs lors du chargement, remplacement et fermeture ; séquences de cycle de vie cohérentes démontrées. |
| Version actuelle du convertisseur Rust | Les anciens tests ne suffisent pas pour le fichier courant | Comparer les modifications pertinentes au reçu du10octobre et requalifier le module actuel au périmètre utile, en réutilisant les fixtures2351identifiées ; pas de nouveau port du même codec. |
| Adaptateur chat à capacité fixe | Le convertisseur de noms composé n’est pas le bon substitut automatique | Consommateur réel du chat, destination/taille/résultat et garde d’erreur explicites ; primitive decode_cstring réutilisée si qualifiée ; distinction UTF-16 brut et texte UI valide documentée. |
| Frontière de paire et entrées atypiques | Sortie tronquée non valide possible dans la fixture | Atteignabilité en amont, limite de saisie réelle et traitement effectif par le film/UI ; aucune correction silencieuse ou conformité moderne inventée. |
| Validation amont et mémoire | Le codec historique suppose du stockage, y compris lookahead pour certaines entrées malformées | Producteurs du buffer et règles d’encodage/terminaison ; refus explicite de mémoire manquante conservé côté Rust ; pas de padding inventé. |
| Montage et rendu AS2 | Le nom Add_Message et les sources candidates ne prouvent pas l’affichage | Identifier le film sélectionné et ses assets/polices, observer réception, ajout/scroll/clear dans le client réel. |

Inconnues parentes inchangées : SYS-17.2-09 → OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b ; SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. Les conclusions ouvertes ne sont pas converties en fonctionnalité terminée ou en anomalie prouvée.

Prochain lot terminable proposé : cycle de vie des deux champs+4/+0x98 et des callbacks de chargement, ou implémentation du récepteur virtuelC8 avec contrat de lookup, à partir de ces pistes précises. Pas de recherche répétée de nouveaux modèles/outils ou de reconversion générique sans besoin identifié.

## 6. Corrections réutilisées et petits livrables

Propositions documentaires sous les tâches existantes ; aucune insertion dans le plan, modification de critères normatifs ou exécution produit.

| Référence stable | Résultat unique | Critères de fin futurs |
|---|---|---|
| SYS-17.2-09/B1-CONVERTER-REUSE | Relier le bon helper existant au consommateur chat | Version actuelle qualifiée au périmètre utile, mémoire/terminaison explicites, capacité et unité identifiées ; pas de doublon de codec ni substitution de toute la composition de noms. |
| SYS-17.2-09/B2-MOVIE-STATE | Qualifier disponibilité et cycle de vie du récepteur | Film chargé/absent/remplacé, readiness et pointeur reliés ; refus/attente explicites et aucun faux succès d’affichage. |
| SYS-17.2-09/B3-METHOD-DELIVERY | Qualifier l’appel de méthode jusqu’au film | Récepteur et méthode originaux identifiés, argument observé côté film, méthode absente et erreur traitées ; consommation et rendu distincts. |
| SYS-17.2-09/H1-FILTERED-HISTORY | Relier réception du film, historique borné et filtre | Avant/après ignore, autres entrées recensées, taille/clear/reprise/scroll observés ; ni simple conversion ni file native assimilée à l’historique affiché. |

Prérequis hérités : D17-SYS-17-2 requiert D13-SYS-13-3 ; D17-SYS-17-4 requiert D09-SYS-09-4. La preuve d’audio du10octobre reste datée et partielle ; aucune clôture du chat ou de l’audio complet n’en découle.

## 7. Livraison, relecture et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-09-NATIVE-FILM-BRIDGE-01.md`.
- [verify_native_film_bridge.py](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01/verify_native_film_bridge.py),18 498octets ; SHA-256 `64d059cfc1d6bc4b3e294128d655de975ce7ecffa98179ee17b4d88e258ff525`.
- [native-film-bridge-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01/native-film-bridge-proof.json),819 652octets ; SHA-256 `b5695ff3e45da0be7d5a0f2e9dcce78786d082ae43381c987ea2fa9e0759e47b`.
- Reçu final : `F:\OpenLeague-work\audit-units\AUD-17.2-09-NATIVE-FILM-BRIDGE-01\delivery-readback.json`, créé après ce rapport. Le reçu initial garde audit_scope_closed=false car il précède la livraison ; la clôture limitée est portée par le reçu final, sans écraser les preuves.

Le nouveau reçu référence le corpus hérité au lieu d’en recopier les1 168fiches. Chemins et SHA-256 sont intégralement vérifiés avant cette réutilisation. Les19fichiers logiciels gelés,6documents d’instructions/contexte/méthode et2registres JSON sont conservés. Les sources Rust et preuves audio sont seulement lues.

Git : même HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés. Aucun stage, commit, reset ou nettoyage. Aucun fichier antérieur réécrit.

Relecture finale : identités,117contrôles et huit cas, octets des instructions exécutées, frontière virtuelle non exécutée, graphe d’appels observé, source actuelle différente de la validation historique, sept rubriques, conditions de reprise et conservation. Les résultats effectifs sont dans le reçu de livraison.

Aucun changement du goal, de ses critères normatifs, de l’application de suivi, de son interface ou de ses bases. Runtime du suivi non invoqué, bases non ouvertes ; comparaisons d’empreintes seulement sur les fichiers gelés. Aucune installation, migration, relance, restauration ou nouveau binaire. Bilan : un lot d’audit clôturé, aucune fonctionnalité/tâche parente ni totalité du jeu déclarée terminée ; aucun taux global calculé.