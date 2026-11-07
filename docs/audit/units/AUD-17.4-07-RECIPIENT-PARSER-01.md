# AUD-17.4-07-RECIPIENT-PARSER-01 — Résolution du destinataire et coupure du message

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Tâche fonctionnelle réutilisée : SYS-17.4-07 ; subdivision documentaire antérieure SYS-17.4-07/W1-PARSING.

## 1. Question, frontières et critères de sortie

Question nouvelle issue du lot whisper/reply : que fait le parseur original0x7A4FE0 avant la tentative d’envoi, comment sépare-t-il les noms et le texte, et quels refus sont démontrables ? Le lot précédent conservait explicitement cette grammaire comme inconnue.

Sortie de ce lot : identifier les routes et coupures du parseur, ses gardes et les frontières des résolveurs ; vérifier concrètement les deux helpers originaux de recherche/sous-chaîne ; réutiliser le constat des consommateurs locaux seulement après conservation de leur liste et de leurs octets ; documenter limites, corrections et relecture. Ces critères locaux ne changent ni le goal ni ses critères normatifs.

| Dimension | Résultat limité |
|---|---|
| Audit | Terminé pour les routes de parsing et coupures documentées, après relecture de livraison. |
| Implémentation | Aucun code produit modifié ; aucun parseur ou service de messages ajouté. |
| Vérification | Analyse statique et20appels de helpers originaux en émulation isolée ; pas d’exécution du parseur complet ou du jeu. |
| Acceptation humaine | Non demandée ; aucune validation de la fonctionnalité déduite. |

Sont exclus : population et normalisation des répertoires de comptes, cibles réelles des callbacks de mots-clés, choix du provider en partie, règles de confidentialité serveur, livraison réseau, traitement Unicode/locale exhaustif, allocation et exceptions. Ces clauses restent ouvertes avec leurs conditions de reprise en §5. Ni la tâche fonctionnelle parente ni l’audit global ne sont clôturés.

Arrêt de recherche retenu : aux frontières des providers virtuels et du lookup social ; les rouvrir demande une question distincte et leurs producteurs. Les contrôles précédents d’envoi/écho ne sont pas rejoués.

## 2. Sources originales, provenance et preuves réutilisées

Référence : LoL4.20.0.315, EUW, en_GB ; fr_FR seulement pour comparaison lexicale. Le binaire original n’a jamais été lancé :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les VA ci-dessous désignent les octets de ce fichier.

| Fonction | Intervalle, fin exclusive | Rôle qualifié |
|---|---|---|
| 7A4FE0 | 7A4FE0–7A57D6 | Parseur complet,538instructions ; entrées/sorties et branches. |
| 7A4E80 | 7A4E80–7A4F84 | Préfixes de nom sans guillemets ; récursion et borne24octets. |
| 7A4F90 | 7A4F90–7A4FDF | Lookup du service, puis lookup secondaire gardé. |
| 7A5C80 | 7A5C80–7A5EBA | Premier token, table de mots-clés et callback. |
| 7AAF50 | 7AAF50–7AB015 | Frontière du lookup secondaire. |
| 5C0540 | 5C0540–5C05DF | Recherche d’une séquence d’octets. |
| 5BCA50 | 5BCA50–5BCA87 | Construction d’une sous-chaîne. |
| 564AF0 | 564AF0–564C10 | Copie bornée d’une portion de chaîne ; chemins d’exception non exécutés. |
| 867BC0 | 867BC0–867C0B | Comparaison de longueur et appel du comparateur. |
| 5ED570 | 5ED570–5ED5C9 | Comparaison par octet via fonction CRT0xC98074. |
| C993D7 | C993D7–C99402 | Classification des octets initiaux, table/locale CRT. |

11intervalles,1 240instructions. Le reçu conserve les octets et SHA-256 de chaque intervalle, les instructions, témoins et limites. La routine CRT0xC98074 est également relue directement : branche par défaut a–z vers A–Z, autre branche déléguée à0xC97F30 ; son extrait original est enregistré lors de la relecture finale. Aucun traitement Unicode universel n’en est déduit.

Réutilisation, sans extraction supplémentaire :

- [Audit whisper/reply](F:/OpenLeague/docs/audit/units/AUD-17.4-07-WHISPER-REPLY-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.4-07-WHISPER-REPLY-01/whisper-reply-proof.json), SHA-256 `62e2eee1c6c74ff0f863ace81c93a8566fd743d9052b4e49d5d4202552b01608` : le caller0x7A367F passe une sortie vectorielle et une sortie message initialement vide. Le caller refuse un message restant vide et sépare envoi, écho et statut « traité ».
- [Catalogue des commandes](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/commands-catalogue.json), SHA-256 `567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0` : bindings, locales et table de mots-clés distincte des alias de commandes. Les champs keyword_all/team/enemy contiennent chacun une valeur lexicale, dans les deux locales sélectionnées ; cela ne démontre pas leurs cibles effectives en runtime.
- [Preuve ChatInterrupt](F:/OpenLeague-work/audit-units/AUD-17.4-07-CHAT-INTERRUPT-01/interrupt-static-proof.json), SHA-256 `f901b835c1f68aadeec817e8d57013f25e1094d0725160a5e29eabfd93fe3e17` : helper de découpe0x99A380–0x99A51B. Ses octets actuels sont comparés à l’empreinte héritée ; aucune réanalyse identique.
- Les textes d’aide natifs sont relus par identité du catalogue, avec leurs lignes physiques : whisper aide/usage6198–6200 ; ignore5999–6001. L’aide whisper décrit nom puis message. L’aide ignore décrit aussi `@ChampionName`. Ce texte ne permet pas d’assimiler une sélection@ à un message privé livré.

Outils existants identifiés par empreinte : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et leurs DLL. Aucune installation. Pas de nouvel import REA/Ghidra ou fichier PE d’analyse ; aucune piste nouvelle n’exigeait de répéter ces imports. Les octets du client original suffisent à la question posée.

## 3. Contrat constaté et consommateurs réels

### Prétraitement et sélection de route

0x7A4FE0 reçoit une chaîne, un vecteur de destinataires et un objet de sortie message. Il refuse la chaîne de longueur0. Il copie ensuite la chaîne et retire le préfixe d’octets pour lesquels0xC993D7 retourne non nul ; si elle devient vide, il renvoie faux. Le classifier possède une branche de table avec masque8 et une branche CRT dépendante de l’état de locale. La portée Unicode et la locale effective ne sont pas qualifiées.

Il choisit alors les routes dans cet ordre : premier octet@ ; sinon premier octet guillemet ; sinon mot-clé ; puis fallback de nom sans guillemets. Le résultat booléen signifie ici traitement/résolution du parseur et ne prouve aucun envoi.

### Route@ : sélection depuis un provider, sans découpe de message

Le code prend toute la chaîne après@. Il obtient un provider et parcourt deux groupes via ses méthodes virtuelles. Les candidats sont comparés au nom brut et à sa traduction construite avec le préfixe `game_character_displayname_`. Les comparaisons passent par0x5ED570/0x867BC0 et la fonction CRT de conversion de casse.

Les chaînes de compte correspondant aux candidats sont ajoutées au vecteur. Sur cette route, aucune affectation à la sortie message n’est faite dans la fonction. L’absence de provider ou de correspondance peut donc mener au retour vrai avec un vecteur vide et un message inchangé. Chez le caller whisper précédemment qualifié, un message demeuré vide empêche l’envoi. Ne pas promouvoir cette route partagée en syntaxe d’envoi@ ou en résolution serveur historique complète.

La signification exhaustive des deux groupes, leur population, les doublons éventuels et le choix effectif du provider restent ouverts. Les constantes0x64/0xC8 du chemin sont conservées dans les instructions, sans leur attribuer une politique moderne de groupe.

### Route avec guillemets : premier guillemet littéral et un octet sauté

Le helper0x5C0540 cherche un octet guillemet à partir de l’index1. Aucun guillemet trouvé ou index1, donc nom vide : faux. Le nom entre les deux guillemets est soumis à0x7A4F90. Si cette éligibilité est fausse, aucun nom n’est ajouté et le parseur renvoie faux. Si elle est vraie, le nom est ajouté au vecteur.

Le parseur calcule ensuite index_du_guillemet_fermant+2. Il n’affecte la sortie message que si la longueur dépasse strictement cet index ; il prend alors le suffixe depuis cet index. Aucun test de présence d’un espace après le guillemet n’existe dans cette branche. Aucun état d’échappement par antislash n’est utilisé pour choisir le guillemet fermant. Ces constats ne prouvent pas l’éligibilité réelle d’un nom contenant des caractères atypiques.

Conséquences conditionnelles, si le nom est accepté : `"Bob" hi` produit la coupure vers `hi` ; `"Bob"hi` vers `i` ; `"Bob"  hi` conserve un espace initial dans le message. Nom seul ou suffixe trop court : retour vrai du parseur possible sans affectation du message, puis refus de message vide par le caller whisper. Cette sémantique historique n’est pas une recommandation de modifier silencieusement les entrées.

### Route sans guillemets : mots-clés puis premier préfixe éligible

0x7A5C80 découpe avec l’espace littéral et recherche le premier token dans la table de mots-clés du contexte+0x28. Une entrée trouvée invoque son callback slot+8 avec le vecteur de sortie. Si le suffixe existe, la fonction l’affecte après le premier token et un octet. Elle renvoie vrai sans imposer ici que le callback ait effectivement rempli le vecteur. Ses cibles et leurs audiences sont hors du présent lot.

Si ce chemin renvoie faux,0x7A4E80 essaie des préfixes de plus en plus longs, délimités par les espaces ASCII successifs. Chaque candidat de longueur supérieure à24octets est refusé avant le test d’éligibilité. Le premier préfixe accepté gagne ; le message commence après l’espace correspondant. En l’absence de préfixe éligible, faux.

Exemple déduit des branches, non exécuté contre un vrai répertoire : si Bob et Bob Smith sont tous deux éligibles, `Bob Smith hi` retient le premier candidat Bob et le suffixe Smith hi ; si seul Bob Smith est éligible, la récursion peut l’atteindre. Les guillemets servent à lever cette ambiguïté. La limite24 concerne ce fallback, pas le texte du message ni une règle serveur universelle de longueur des comptes. Aucune séparation de liste par virgules n’est présente dans ce fallback.

### Éligibilité et consommateurs actuels

0x7A4F90 accepte d’abord un lookup du service global0x2D788DC si son résultat diffère de la sentinelle. Sinon, si le global0x2D62D10 est non nul, il appelle0x7AAF50, qui interroge un provider et compare le résultat à une autre sentinelle. Ce sont des décisions côté client, sans preuve d’amitié autorisée, blocage, droit d’audience ou livraison serveur. Le libellé UserNotFound du caller ne remplace pas l’analyse de ces producteurs.

Le constat d’absence locale est repris du lot précédent :1 168fichiers de `crates/*/src` en Rust, de `launcher/src-tauri/src` en Rust et de `launcher/web` en JS/HTML. Liste des chemins et SHA-256 identiques, vérifiés avant réutilisation. La recherche lexicale n’a pas été répétée. Son seul résultat LastWhisper dans un commentaire d’objet n’est pas un consommateur de messages.

Les fragments des vrais consommateurs sont repris dans le reçu : Action/ClientPacket/ServerPacket de `crates/core/src/lib.rs`, Input/ClientMessage/ServerMessage de `crates/core/src/session_transport.rs`, et bridge Tauri réel de `launcher/src-tauri/src/main.rs:72`. Aucun parseur de commandes privées ou routage privé n’y est identifié. Leur transport/session existant est conservé. Ce constat reste borné à ces sources ; pas de conclusion sur tout outil, vendor ou service externe.

## 4. Contrôles réellement exécutés, attendu et observé

Script `verify_recipient_parser.py`, 2026-10-30T16:02:13Z–16:02:16Z, code0 :216/216 contrôles réussis. Ils couvrent les identités, décodages et instructions sélectionnées, les sorties des20appels de helpers, leurs retours et leur pile, les consommateurs réutilisés et les fichiers protégés. Leur nombre ne mesure pas la complétude du jeu.

Méthode d’émulation : le PE original est mappé en mémoire, sans patch de code ni stub de callee. Seules les entrées0x5C0540 et0x5BCA50 sont appelées. Leurs callees exécutés proviennent aussi du PE original et leurs octets/adresses sont enregistrés. Les objets chaîne, buffers et pile sont des fixtures explicites ; chaînes SSO de capacité15 ou données de chaîne longue fournies par le harness ; sous-chaînes de sortie courtes, sans chemin d’allocation testé. Chaque appel doit atteindre sa sentinelle et nettoyer les12octets d’arguments. Les écritures sont limitées aux fixtures et à la pile ; aucune écriture du code/image native, aucun appel OS. Limite100000instructions et2secondes par appel.

| Cas de helper original | Attendu | Observé |
|---|---|---|
| Recherche du guillemet dans `"Bob" hi` depuis1 | index4 | 4 |
| Antislash avant un guillemet intermédiaire | premier guillemet littéral, index3 | 3 ; pas d’échappement dans ce helper. |
| `"" hi` | index1, à refuser par la garde du parseur | 1 |
| Guillemets non fermés | npos | 0xFFFFFFFF |
| Entrée vide ou position au-delà de la fin | npos | 0xFFFFFFFF |
| Nom fermé sans message | index4 | 4 ; cela ne démontre pas d’envoi. |
| Préfixes Bob puis Bob Smith | espaces aux index3 puis9 | 3 puis9 selon position de départ. |
| Aucun espace | npos | 0xFFFFFFFF |
| Fixture UTF-8 `"Élo" hi` | guillemet à l’index5 en octets | 5 ; aucune qualification d’encodage natif déduite. |
| Chaîne en buffer externe avec nom de16octets | guillemet à17 | 17 |
| Sous-chaîne depuis6 dans `"Bob" hi` | hi | hi |
| Sous-chaîne depuis6 dans `"Bob"hi` | i | i |
| Sous-chaîne depuis6 dans `"Bob"  hi` | espace puis hi | espace puis hi |
| Nom avec espace, chaîne en buffer externe, fixture UTF-8 | suffixes courts attendus | hello, hi, hi respectivement. |
| Sous-chaîne à la fin exacte | chaîne vide | vide ; le parseur lui-même saute l’affectation dans ce cas. |

Les13recherches et7sous-chaînes sont distinctes dans le reçu. Les conséquences du parseur sont établies par les branches et appels, combinés aux observations des helpers ; le parseur complet, ses providers et son service n’ont pas été exécutés. Les conditions nom reconnu/inconnu, callbacks et population réelle sont donc des chemins statiques conditionnels, pas des essais en partie.

Contrôles non exécutés : parser complet en émulation, jeu LoL, ActionScript, serveur ou envoi XMPP, tests Rust/build, résolution de vrais comptes, vérification visuelle et acceptation humaine. Aucun ancien test n’est présenté comme nouvellement exécuté.

## 5. Résolu, encore indéterminé et conditions de reprise

Progrès par rapport au lot précédent : les routes de parsing, le fallback récursif, la portée de la borne24octets, les gardes des guillemets, la coupure index+2 et les retours vrais sans message/vecteur sont désormais identifiés. Les comportements des helpers sur les délimiteurs nominaux et malformés ont des observations exécutées. L’ancienne inconnue générale « grammaire » est ainsi réduite aux frontières ci-dessous ; elle n’est pas déclarée intégralement résolue.

| Clause ouverte | Effet | Entrée précise permettant la reprise |
|---|---|---|
| Population/normalisation du lookup0x7A7B10 | L’ensemble réel des noms acceptés n’est pas connu | Producteurs du conteneur du service, comparaison et insertion identifiés ; cas noms égaux par casse/espaces et sentinelle documentés. |
| Provider secondaire0x729C80 et méthodes virtuelles | Éligibilité hors du service social, sélection@ et groupes non qualifiés en runtime | Identité de l’implémentation et xrefs d’alimentation ; deux comptes/candidats nommés, absence et ambiguïté. |
| Callbacks des mots-clés contexte+0x28 | Destinataires exacts de all/team/enemy inconnus | Bindings de leurs callbacks depuis le constructeur puis corps appelés, avec vecteur réellement produit ; ne pas inférer une audience du seul alias. |
| CRT/encodage effectifs | Comparaison et classement des octets non ASCII non qualifiés | Configuration de locale/encodage et table effective démontrées ; cas accents, multioctets, caractères invalides et noms en limites avec sortie attendue explicite. |
| Longues chaînes et erreurs | Allocation, exceptions et durée de vie non testées | Lot spécifique sur les helpers d’allocation/lifetime si requis ; ne pas extrapoler les20appels à tous les objets du client. |
| Messagerie locale et confidentialité | Aucun envoi privé fonctionnel validé | SYS-19.3-05, identité locale et règles sociales disponibles ; messages observés chez destinataire et absence chez un tiers. |
| Reply et réception | Dernier correspondant réel et réception toujours inconnus | Producteur du cache+0x28/+0x2C du service ; deux correspondants et règle d’ordre. Le présent lot ne touche pas ce cache. |

Pas de nouvelle recherche communautaire répétée : les entrées manquantes sont maintenant des fonctions/producteurs précis dans le binaire, ou des contrats locaux à définir pour le service. Une source externe ne sera utile qu’en réponse à une question ou à une absence précisément identifiée.

Les inconnues de registre restent ouvertes et inchangées : SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 ; dépendance de routage privé SYS-19.3-05 → OLU-0debac4f-37e1-5508-b286-7c3e1e3eb361 ; limites SYS-19.3-07 → OLU-e2258914-554a-5b17-bf82-0b270d164ffe. Aucune mutation du registre ou de statut n’est effectuée.

## 6. Corrections et résultats clôturables réutilisés

Les subdivisions sont des propositions documentaires sous les tâches existantes ; aucune nouvelle tâche insérée, aucun critère normatif modifié et aucune correction produit appliquée.

| Référence stable réutilisée | Résultat précis encore à livrer | Critères d’une clôture future |
|---|---|---|
| SYS-17.4-07/W1-PARSING | Définir puis relier un parseur local avec les frontières natives désormais documentées | Cas vide, noms simples/avec espaces, quotes, absence de message, nom inconnu, collision de préfixes et dépassement24octets ; distinction des sorties destinataires/message et refus explicites. La fidélité non qualifiée reste marquée ; les défauts historiques ne sont pas silencieusement corrigés ou inventés. |
| SYS-17.4-07/W2-AVAILABILITY | Relier les commandes au service et à ses états réels | Désactivé/déconnecté : zéro envoi et erreur explicite ; traitement local, tentative d’envoi, écho et accusé séparés. |
| SYS-19.3-05/W3-DELIVERY | Router un message privé vers un compte autorisé | Identité serveur, blocages et audience ; deux comptes et tiers exclu, inconnu/usurpation/session périmée refusés ; aucun faux succès. |
| SYS-19.3-07/W4-LIMITS | Appliquer taille, débit et historique selon un contrat local explicite | Seuils justifiés, borne−1/borne/borne+1, reprise et refus vérifiés ; la borne24octets de nom n’est pas utilisée comme plafond de message. |
| SYS-17.4-07/R1-REPLY | Qualifier le cache de correspondants puis le préremplissage | Producteur et ordre du cache ; vide/deux correspondants ; saisie ouverte/fermée ; aucun envoi avant action explicite ; saisie sans commande de combat. |

Prérequis réutilisés du plan : D17-SYS-17-4 requiert D09-SYS-09-4 ; D19-SYS-19-3 requiert D19-SYS-19-1. Les entrées et tâches héritées sont présentes dans le reçu, pas déclarées réalisées.

Prochain résultat d’audit distinct proposé : corps du handler ignore0x7A3810, déjà relié au même catalogue et au parseur partagé ; distinguer bascule locale d’ignore et autorisations du futur service. Ne pas rouvrir toute la syntaxe ou relancer les recherches de consommateurs inchangés sans nouvelle piste.

## 7. Livraison datée, conservation et relecture

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.4-07-RECIPIENT-PARSER-01.md`.
- [verify_recipient_parser.py](F:/OpenLeague-work/audit-units/AUD-17.4-07-RECIPIENT-PARSER-01/verify_recipient_parser.py), 18 236octets ; SHA-256 `4ba127e9b53c6b0fa5a4097e4cfca71cacd0b16e5709ed3a861a34366fe6454a`.
- [recipient-parser-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-07-RECIPIENT-PARSER-01/recipient-parser-proof.json), 647 438octets ; SHA-256 `53170328f50bffddac9d5c4af456cf7811248f97e06f941e4e366b104ec5bec4`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.4-07-RECIPIENT-PARSER-01\delivery-readback.json`, créée après le rapport, avec extrait CRT complémentaire. Le premier reçu garde audit_scope_closed=false car il précède cette relecture ; le reçu de livraison statue sur la clôture limitée sans l’écraser.

Conservation :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode et2registres JSON comparés aux empreintes héritées. Les1 168fichiers du corpus et sa liste sont inchangés. Git avant/après : HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés ; aucun stage, commit, reset ou nettoyage. Aucun fichier antérieur réécrit.

La relecture contrôle les identités du script, du rapport et des reçus ; les216contrôles et20cas ; la séparation entre branches statiques et helpers exécutés ; les sept rubriques ; les conditions de reprise ; la conservation des sources et protections. Ses résultats effectifs sont enregistrés dans le reçu final.

Le goal, les critères normatifs, l’application de suivi, son interface et ses bases restent inchangés. Aucune base ouverte, installation, migration, relance ou restauration. Aucune fonctionnalité, aucun champion, aucune tâche parente ni le jeu complet n’est déclaré terminé. Bilan : un lot d’audit borné avec une inconnue de parsing précisée et20observations de helpers originales ; zéro fonctionnalité implémentée ou qualifiée en partie. Aucun taux global de jeu terminé calculé.