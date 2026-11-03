# AUD-17.4-07-WHISPER-REPLY-01 — Messages privés : envoi et préremplissage

Date : 2026-10-30. Goal parent : SYS-01.2-02. Projet courant : F:\OpenLeague.

## 1. Périmètre précis et décision limitée

Question : quels chemins utilisent les handlers 4.20 `/whisper` et `/reply`, quelles gardes distinguent saisie, tentative d’envoi, présentation et retour « traité », et quels consommateurs locaux existent réellement ?

Critères de sortie de ce lot : identifier les octets et les callbacks sélectionnés ; qualifier leurs gardes et leurs sorties normales ; examiner les interfaces locales et une recherche de sources bornée ; rattacher les manques aux tâches existantes ; fournir les sept rubriques et une relecture de conservation. Ces critères décrivent ce lot et ne modifient aucun critère normatif du goal ou du plan.

| Dimension | Décision et portée |
|---|---|
| Audit | Terminé pour les frontières documentées de ces deux handlers, après le reçu de relecture. |
| Implémentation | Aucun code de jeu modifié. Pas de consommateur de messagerie privée identifié dans les sources et interfaces courantes inspectées. |
| Vérification | 175 contrôles statiques réussis ; aucune qualification fonctionnelle du service. |
| Acceptation humaine | Non demandée ; aucune acceptation de la fonctionnalité ou du jeu déduite. |

Sont exclus : la grammaire complète du parseur de destinataires, le producteur du cache de réponse, la réception complète des messages, les algorithmes serveur Riot, le protocole réseau XMPP complet et la livraison réelle. Leurs inconnues sont précisément conservées en §5. Les tâches parentes SYS-17.4-07, SYS-19.3-05 et SYS-19.3-07 demeurent ouvertes.

Un seul lot actif. Arrêt de cette recherche à la frontière de l’appel de parsing et du sink virtuel : les franchir demanderait un lot distinct sur leurs propres producteurs et contrats. Aucun nouvel export, import Ghidra ou lancement de jeu n’est nécessaire pour la question retenue.

## 2. Sources, provenance et identités

Référence : LoL 4.20.0.315 ; région EUW ; locale en_GB. Les données fr_FR servent uniquement à comparer les clés lexicales, sans changer la référence.

Binaire original lu, jamais exécuté : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase 0x400000. Les adresses ci-dessous sont des VA de ce fichier.

| Fonction sélectionnée | Intervalle, fin exclusive | Instructions |
|---|---|---:|
| `/whisper`, callback d’action slot18 | 0x7A35C0–0x7A3802 | 172 |
| `/reply`, callback de saisie slot1C | 0x7A39F0–0x7A3BDC | 140 |
| Adaptateur des deux chaînes vers le service | 0x7A0E90–0x7A1001 | 111 |
| Enveloppe, lookup destinataire et sink | 0x7A7D00–0x7A7E6F | 119 |
| Présentation locale de l’envoi | 0x7A79E0–0x7A7B08 | 91 |

Total : 633 instructions décodées depuis les entrées connues, avec vérification des longueurs contiguës et des fins RET. Les octets, empreintes de chaque intervalle, instructions et adresses témoins sont dans le reçu JSON.

Preuves réutilisées, sans relancer leur extraction ou leurs anciens tests :

- [Catalogue des commandes](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/commands-catalogue.json), SHA-256 `567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0` : slots distincts, familles et alias. `/whisper` : whisper,w,msg,tell,m ; `/reply` : reply,r,rep en en_GB. Le callback normal slot18 de reply est le callback commun, et son traitement spécifique est slot1C.
- [Preuve chat précédente](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json) et [reçu d’extraction](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-extraction-receipt.json) : variantes menu et Menu_SC4. Leurs `CommandParser.as`, lignes138 et135 respectivement, exposent `Chat_SetInputText` vers `parseCommand(["hud","setChatInputText"],value)`. Les deux fichiers réutilisés correspondent aux identités enregistrées antérieurement. Aucun film ActionScript exécuté. La priorité de montage entre les variantes reste inconnue.
- `docs/reference_local_services_4_20.json`, daté 2026-10-20 : familles chat/social et remplacement local ; son état historique est corroboré par les consommateurs actuels du §3, sans le présenter comme un nouveau test réseau.
- Snapshot AIR `docs/reference_local_services_sources/air/lib__ClientLibServices_dat/scripts/com/riotgames/platform/common/services/ChatService.as`, 2 780 octets, SHA-256 `45680629260587bc89bf06b11fba7ed933e84f8f51c2edac42f06f53c27ed6ee` : interface `sendBuddyMessage`, `sendMessage`, connexion XMPP. Provenance conservée : revue de `lib/ClientLibServices.dat`. Cette interface n’est pas l’implémentation du serveur.

Le fichier original `DATA/cfg/defaults/Game.cfg` et la copie `data/4.20/configuration/defaults/Game.cfg` portent la même empreinte et la ligne21 `EnableXMPPChat=1`. Ce défaut distribué ne démontre pas la priorité de chargement effective ou une connexion active. Les quatre clés effectivement demandées par ces chemins sont relevées dans les deux fichiers de locale originaux : Disabled ligne196, Not_Connected ligne212, To ligne218, UserNotFound ligne219. Les valeurs et identités complètes sont dans le reçu. La clé voisine UserNotFoundAnywhere n’est pas attribuée à ce handler.

Outils réellement utilisés : Python existant, pefile2024.8.26 et Capstone5.0.7 existants. Le reçu identifie le Python, les modules et la DLL Capstone. Lecture et désassemblage statiques uniquement. REA/Ghidra n’a pas été relancé : aucune nouvelle question n’exigeait de répéter les imports précédents, et aucun nouveau binaire d’analyse n’a été créé.

## 3. Consommateurs natifs et consommateurs locaux actuels

### Chemin natif whisper

`0x7A35C0` lit `General/EnableXMPPChat` par 0x8B1C20. Si le résultat vaut0, il demande `flash_hud_Chat_Disabled`. Sinon, le service global 0x2D788DC doit exister et son octet+0x64 doit être non nul ; à défaut il demande `flash_hud_Chat_Not_Connected`.

Le handler appelle ensuite 0x7A4FE0 avec la saisie originale, une sortie vectorielle et une sortie message. Faux au retour : `flash_hud_Chat_UserNotFound` et retour normal0. Message de longueur nulle : aucun appel d’envoi, retour0. Le sens complet des formes d’entrée acceptées par ce parseur reste hors périmètre.

Pour chaque entrée de24octets du vecteur, il appelle 0x7A0E90 avec le destinataire et le message. Si l’adaptateur renvoie faux, la boucle s’arrête et demande UserNotFound. Les tentatives précédentes ne sont pas annulées dans ce handler. Si l’adaptateur renvoie vrai, 0x7A79E0 construit une présentation locale à partir de `flash_hud_Chat_To`, du destinataire, de `: ` et du message, puis appelle 0x7A7890 avec le type0x21. Ce type n’est pas transformé ici en règle d’audience serveur.

L’adaptateur 0x7A0E90 construit deux chaînes et appelle 0x7A7D00. Ce dernier prépare une enveloppe avec les littéraux `sndMessage`, `summoner`, `message`, appelle le lookup0x7A7B10, compare le résultat à la sentinelle du conteneur et refuse en renvoyant faux si elle correspond. Sinon il appelle un sink virtuel slot+4, puis met son résultat local à1. Ni retour de livraison du destinataire ni accusé serveur n’est vérifié à cet endroit. Les littéraux de l’enveloppe ne sont pas une qualification du wire XMPP.

### Chemin natif reply

Le callback0x7A39F0 commence par le littéral `/msg`. Si le vecteur du service aux offsets+0x28/+0x2C est vide, il ajoute un espace ; sinon il prend la dernière entrée à fin−24 et assemble les fragments espace/guillemet, nom en cache, guillemet/espace. Cette lecture ne prouve pas que l’entrée est le dernier expéditeur reçu.

Il ne demande `Chat_SetInputText` que si le HUD, son objet chat+0x110 et l’octet d’ouverture de saisie+0xE9 sont présents/non nuls. Les chemins normaux retournent1 même lorsque cette écriture est sautée. Aucun appel aux deux fonctions d’envoi sélectionnées n’est présent dans ce callback. Le service global est déréférencé avant ces gardes : aucun refus gracieux d’un service nul n’est affirmé.

### Consommateurs actuels inspectés

Recherche reproductible et bornée : tous les `.rs` sous `crates/*/src`, les `.rs` de `launcher/src-tauri/src` et les fichiers `.js`/`.html` de `launcher/web`, soit1 168fichiers identifiés avec leurs SHA-256. Motif et contrôles positifs/négatifs enregistrés dans le reçu : `whisper|xmpp|private.?message|reply.?message|chat.?message|sendBuddyMessage`, insensible à la casse. Un seul résultat : `crates/core/src/penetration.rs:1`, commentaire d’objet LastWhisper, sans consommateur de messagerie.

La recherche lexicale est corroborée par la lecture des interfaces réelles :

- `crates/core/src/lib.rs` : Action ligne280, ClientPacket ligne303, ServerPacket ligne321 ; aucune variante de message privé identifiée.
- `crates/core/src/session_transport.rs` : Input, ClientMessage et ServerMessage ; commandes de jeu, sessions, horloge et rejets existants, sans commande/livraison privée identifiée.
- `launcher/src-tauri/src/main.rs:72` : bridge réel limité à roster,play,join_local,session_status,resume_session,abandon_session ; aucune commande sociale exposée.
- Les autres sources Rust du launcher, son JavaScript et son HTML appartiennent au corpus recherché ; aucun service privé supplémentaire identifié.

Les fonctionnalités de session et de transport existantes sont conservées. Ce constat d’absence est limité à ces sources et interfaces, pas à tout fichier généré, outil, dépendance externe ou serveur non inspecté. Les outils de suivi ne sont pas des consommateurs du jeu et n’ont pas été exécutés.

## 4. Attendu, observé et vérifications réellement exécutées

Exécution : `verify_whisper_reply.py`, du 2026-10-30T15:49:09Z au 15:49:21Z, code0. Reçu : 175/175 contrôles statiques réussis. La table présente des chemins raisonnés sur le code original, jamais des scénarios exécutés dans le jeu.

| Cas statique | Attendu | Observé dans les octets sélectionnés |
|---|---|---|
| W1 : configuration désactivée | Pas d’envoi ; statut Disabled | Branche3636 vers375B ; statut type4 ; BL=1 au retour « traité ». |
| W2 : service absent/non connecté | Pas d’envoi ; statut Not_Connected | Branches3647/3652 vers3756 ; même retour « traité ». |
| W3 : parseur faux | UserNotFound et retour0 | Branche3686 vers36DD ; BL effacé en36F7. |
| W4 : message vide | Pas d’envoi ni d’écho | Branche368C vers36F4 ; retour0. |
| W5 : sorties de parsing valides, adaptateurs vrais | Un envoi tenté puis un écho par entrée | Appels36B9 et36C7 ; pas24octets ; fin de boucle BL=1. |
| W6 : lookup à la sentinelle | Refus de l’adaptateur et arrêt de la boucle | 7DFF efface BL ;36C0 rejoint l’erreur UserNotFound. Pas de rollback montré des tentatives précédentes. |
| W7 : lookup trouvé | Appel du sink ; succès local | Appel indirect7E0B, suivi de BL=1 indépendamment du retour du sink ; aucune preuve de livraison. |
| W8 : sortie hypothétique sans destinataire mais avec message | Aucun envoi, retour « traité » | Branche3696 vers36D9. La possibilité réelle que le parseur produise cette sortie reste inconnue. |
| R1 : cache vide et saisie ouverte | Préremplir `/msg `, sans envoi | Branche3A59, espace littéral, appel3B46. |
| R2 : cache non vide et saisie ouverte | Préremplir la commande avec nom en cache | fin−24, fragments de guillemets, appel3B46. Échappement des noms atypiques non qualifié. |
| R3 : HUD/chat absent ou saisie fermée | Sauter le préremplissage | Branches3B1D/31/3A ; retour normal1. |
| R4 : service nul pour reply | Ne pas inventer un refus gracieux | Déréférencement direct3A53 après lecture du global ; aucune exécution tentée. |

Le reçu contient les témoins d’instruction pour chaque cas, les constantes, les gardes de conservation et les fragments des consommateurs. Les cas W5/R1/R2 supposent explicitement leurs préconditions ; ils ne prouvent pas que les données de ces préconditions sont réellement produites en jeu.

Non exécutés : CPU natif ou émulé, jeu LoL, ActionScript, serveur de jeu, XMPP, envoi entre comptes, tests Rust, build, tests visuels ou d’accessibilité, acceptation humaine. Aucun ancien test n’est présenté comme fraîchement réussi.

## 5. Écarts ouverts et conditions précises de reprise

| Manque ou limite | Impact | Entrée/condition de reprise |
|---|---|---|
| Grammaire de0x7A4FE0 et helpers | Syntaxe des noms, quotes, nombre de destinataires, erreurs exactes non qualifiés | Lot borné sur cette fonction originale et ses sorties ; cas noms simples/espaces/quotes, message absent, nom inconnu et faux retour. Pas de nouvelle recherche communautaire sans échec/piste précise. |
| Producteur du cache+28/+2C | Impossible d’affirmer « répondre au dernier expéditeur » ou son ordre | Xrefs d’écriture aux champs du service et un consommateur de réception/sortie identifié ; cache vide, deux correspondants et mise à jour documentés. |
| Lookup0x7A7B10 et population du conteneur | Normalisation des noms et politique amis/non-amis indéterminées | Qualifier comparaison, clés, insertion et source des comptes ; distinguer erreurs de lookup et refus d’autorisation. |
| Sink virtuel et réception complète | Livraison, accusé, retries et portée du message non prouvés | Identifier son implémentation originale ou spécifier explicitement un contrat local ; observer ensuite deux destinataires locaux et un tiers exclu. |
| Service local de messages privés | Aucune fonctionnalité à déclarer terminée | Exécution distincte de SYS-19.3-05 avec identité locale et permissions prêtes ; pas d’implémentation implicite dans le présent audit. |
| Taille, fréquence, historique et blocages | Ni la taille du vecteur ni les bornes de paquets ne définissent ces politiques | Règles locales explicites sous SYS-19.3-07 et dépendances sociales, avec limites justifiées et refus observables. |
| Valeurs de configuration et ressources UI | Défaut distribué et deux films ne prouvent pas le montage effectif | Preuve de priorité du runtime si nécessaire pour une future qualification intégrée. |

Inconnues existantes conservées, sans mutation du registre : SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 ; SYS-19.3-05 → OLU-0debac4f-37e1-5508-b286-7c3e1e3eb361 ; SYS-19.3-07 → OLU-e2258914-554a-5b17-bf82-0b270d164ffe. Ces inconnues empêchent de clôturer les fonctionnalités parentes, pas la conclusion limitée du présent lot.

## 6. Corrections réutilisées et petits résultats clôturables proposés

Aucune nouvelle exigence concurrente. Les subdivisions suivantes sont des propositions documentaires sous les tâches existantes, sans insertion dans le plan, sans modification de critères normatifs et sans exécution de code produit.

| Référence stable de subdivision | Objectif unique et dépendances | Critères précis d’un futur résultat |
|---|---|---|
| SYS-17.4-07/W1-PARSING | Qualifier les entrées de whisper ; source0x7A4FE0 et helpers | Nom simple et avec espaces, quotes, texte absent, utilisateur inconnu : attendu/observé et sorties ; formes non qualifiées explicitement refusées ou conservées inconnues. Aucun parseur inventé déclaré historique. |
| SYS-17.4-07/W2-AVAILABILITY | Relier l’entrée de commande à l’état réel du service local | Activé/connecté, désactivé, déconnecté : aucun faux envoi ; résultat « traité », rejet local et accusé de livraison distincts. Dépend du contrat du service. |
| SYS-19.3-05/W3-DELIVERY | Router un message privé vers son destinataire autorisé | Identité serveur ; deux comptes reçoivent le parcours attendu ; un tiers ne reçoit rien ; compte inconnu, usurpation, blocage et session périmée refusés sans fuite. Dépend de D19-SYS-19-1 et des règles sociales applicables. |
| SYS-17.4-07/R1-REPLY | Qualifier puis relier le cache de réponse au préremplissage | Producteur du cache identifié ; cas vide/deux correspondants ; saisie ouverte/fermée ; nom avec espaces/quotes ; aucun envoi avant action explicite ; aucune action de combat issue de la saisie. Dépend du HUD et du service réel. |
| SYS-19.3-07/W4-LIMITS | Appliquer une politique locale de limites de messages | Seuils et unité explicites ; bornes−1/borne/borne+1 ; débit et historique bornés ; reprise et refus observés. Aucun seuil historique déduit des seuls helpers ou paquets. |

Prérequis lus dans le plan existant : D17-SYS-17-4 requiert D09-SYS-09-4 ; D19-SYS-19-3 requiert D19-SYS-19-1. Leurs fiches sont conservées dans le reçu ; elles ne sont pas déclarées terminées. Aucun retrait des préparations Plan gelées n’est entrepris.

## 7. Livraison, conservation et relecture

Fichiers nouveaux uniquement :

- Rapport présent : `F:\OpenLeague\docs\audit\units\AUD-17.4-07-WHISPER-REPLY-01.md`.
- Script reproductible : [verify_whisper_reply.py](F:/OpenLeague-work/audit-units/AUD-17.4-07-WHISPER-REPLY-01/verify_whisper_reply.py), SHA-256 `f5723affa936a72eb50e1b543a7f0fe0a35e0209d9b71eefb0cd0d0e87b776f4`.
- Reçu : [whisper-reply-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-07-WHISPER-REPLY-01/whisper-reply-proof.json), 448 441octets, SHA-256 `62e2eee1c6c74ff0f863ace81c93a8566fd743d9052b4e49d5d4202552b01608`.
- Relecture indépendante : `F:\OpenLeague-work\audit-units\AUD-17.4-07-WHISPER-REPLY-01\delivery-readback.json`, créé après le rapport. Le booléen audit_scope_closed=false du premier reçu signifie que ce reçu statique précédait cette relecture ; la clôture limitée est portée par le reçu de livraison, sans écraser le premier.

Le script contrôle les19fichiers logiciels gelés, les6documents d’instructions/contexte/méthode, les2registres JSON lus et l’identité du client original. Git avant/après : HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés ; rien indexé, nettoyé, annulé ou commité. Les preuves antérieures sont conservées. Les nouvelles preuves sont créées exclusivement, avec refus d’écrasement.

Relecture attendue : identité du rapport/script/reçu, succès des contrôles statiques, sept rubriques présentes, correspondance des snapshots AS2 avec les preuves héritées, conservation des fichiers protégés, sources et registres, distinction explicite audit/fonctionnalité, limites et conditions de reprise. Le reçu de livraison donne les résultats effectivement observés.

Aucun appel de mutation du goal, aucune modification de l’application de suivi ou de ses bases, aucune installation, migration, restauration ou relance. Les bases n’ont pas été ouvertes ; aucune vérification de leur contenu n’est revendiquée. Le bilan porte sur une unité d’audit clôturée, zéro fonctionnalité implémentée ou qualifiée en runtime, zéro clôture parente. Aucun pourcentage global de jeu terminé n’est calculé.