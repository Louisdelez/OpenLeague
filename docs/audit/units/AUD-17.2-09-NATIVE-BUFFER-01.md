# AUD-17.2-09-NATIVE-BUFFER-01 — File native en attente et historique affiché

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Exigences fonctionnelles conservées : SYS-17.2-09 et SYS-17.4-07.

## 1. Question, frontières, critères et décision

Question issue du filtre ignore : que conserve le buffer natif avant la demande d’affichage, comment limite-t-il l’ajout et la consommation, et comment se distingue-t-il de l’historique côté film déjà audité ?

Critères propres à ce lot : identifier layout et chemins natifs d’ajout/retrait ; séparer valeurs du fichier, arguments de secours et configuration effective ; observer les gates et helpers originaux sur cas bornés ; relier Add_Message au consommateur AS2 existant ; réutiliser les consommateurs actuels inchangés ; documenter inconnues, petits résultats restants et sept rubriques. Aucun critère normatif du goal ou du plan n’est modifié.

| Dimension | Décision limitée |
|---|---|
| Audit | Terminé pour la file native en attente, ses gates et retraits sélectionnés, après relecture de livraison. |
| Implémentation | Aucun code produit modifié. Pas de file de chat locale identifiée dans les consommateurs actuels conservés. |
| Vérification |156contrôles réussis, dont28cas de fragments/helpers originaux en émulation. Pas de pipeline natif complet exécuté. |
| Acceptation humaine | Non demandée ; aucun fonctionnement en partie accepté implicitement. |

Exclus : allocation et longues chaînes, throttler complet, horodatage, readiness réelle et scheduler, montage/configuration effectifs, protocole/compte/réseau, exécution du film, rendu et persistance. La tâche « historique de messages borné » n’est donc pas déclarée complètement réalisée ou auditée par ce seul fragment.

Un seul lot actif. Recherche arrêtée aux gates supplémentaires et aux appels du film, identifiés pour reprise en §5. Les limites AS2 et le filtre ignore déjà prouvés ne sont pas réexécutés à l’identique.

## 2. Sources, provenance et identités

Référence : LoL4.20.0.315, EUW, en_GB. Le client original n’a pas été lancé.

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Toutes les adresses sont ses VA.

| Fonction | Intervalle, fin exclusive | Contrat retenu |
|---|---|---|
| 7ACF10 | 7ACF10–7AD4A3 | Ajout natif : capacité, préparation, autres gardes, construction et append. |
| 7ABD50 | 7ABD50–7ABFF6 | Consommation de la file vers le film, chemins normal et bit0x80. |
| 7A1010 | 7A1010–7A1040 | Construction d’une entrée28octets : chaîne24octets et flags4octets. |
| 5FF230 | 5FF230–5FF308 | Append d’entrée28octets. |
| 85A590 | 85A590–85A5CF | Décalage/copie des entrées après retrait. |
| 5D4D00 | 5D4D00–5D4D56 | Destruction des entrées en fin devenue inutilisée. |

6intervalles et751instructions ; décodages contigus, bornes et RET contrôlés, octets et empreintes enregistrés. Le constructeur7A1010 se termine exactement en7A1040 ; la fonction qui commence immédiatement après n’est pas incluse par erreur.

Configuration originale : `DATA/cfg/defaults/GamePermanent.cfg`,23 214octets, SHA-256 `2fac41017961dbeca9e48a473f30da1978f6187f793754beae24c9cc77941f2c`.

| Paramètre [Hacks] | Valeur du fichier natif | Argument de secours fourni au lecteur8B1A80 |
|---|---:|---:|
| MaxChatBufferSize, ligne668 |100 |25, immédiat0x19 en7ACF73. |
| MaxChatsToProcessPerFrame, ligne667 |2 |2, immédiat en7ABEC6. |

Le chemin demandé dans les appels est `Data/CFG/defaults/GamePermanent.cfg`. La capacité est mise en cache à0x2D82744 après le flag d’initialisation0x2D82740 ; le quota est mis en cache à0x2D8273C via0x2D82738. Fichier présent et arguments passés ne qualifient pas la priorité de montage, la première lecture ni les erreurs du lecteur en runtime.

La copie exacte `F:\OpenLeague\data\4.20\configuration\defaults\GamePermanent.cfg` est absente au point de contrôle. Cela ne prouve pas l’absence de cette ressource dans toute archive ou autre emplacement ; la source historique nécessaire à cet audit est disponible sur D. Aucun fichier de configuration n’est copié ou modifié.

Preuves réutilisées :

- [Filtre ignore](F:/OpenLeague/docs/audit/units/AUD-17.4-07-IGNORE-RECEIVE-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-RECEIVE-01/ignore-receive-proof.json), SHA-256 `3a0c0ea2460a247ca899a16aef6e3da04eed9ec44dd71a34d00e24859e72a4f9` : chemin7AA4B0→8287F0→7ACF10 contourné quand l’émetteur est ignoré. Ce fragment ne prouve pas les autres entrées possibles du buffer.
- [Preuve chat/AS2](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json), SHA-256 `b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906` : variantes menu et Menu_SC4, historique affiché borné100 avec retrait des anciens, distinction de visibilité/délai, contexte et sources. Aucun nouveau film extrait/exécuté, aucun ancien test réannoncé comme nouveau.
- Les `CommandParser.as` hérités, identités vérifiées, lignes126 et123 : Add_Message(value) appelle `parseCommand(["hud","addMessage"],value)`. Les démonstrations DEBUG de Main.as ne sont pas traitées comme des entrées de production.

Outils existants identifiés par SHA-256 : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et DLL associées. Aucune installation, aucun nouveau PE d’analyse, aucun import REA/Ghidra ou réexport de films répété sans nouvelle nécessité.

## 3. Consommateurs et contrat établi

### Une file native, pas l’historique conservé à l’écran

L’objet de chat natif contient un vecteur aux offsets+0x104/+0x108/+0x10C : début, fin et capacité réservée. L’entrée fait28octets : représentation chaîne de24octets, puis flags32bits à+0x18. Le nombre d’entrées est calculé par division de la différence fin−début par28. Les helpers de construction, append, décalage et destruction corroborent cette taille.

La fonction7ACF10 prépare une entrée et l’ajoute à cette file ;7ABD50 demande ensuite son affichage par Add_Message puis la retire de la file. Cette structure conserve donc des éléments en attente de consommation. Elle est distincte du tableau d’historique affiché côté AS2, et ne constitue pas une archive serveur/compte.

### Gate d’ajout et gardes supplémentaires

7ACF10 saute le traitement si le pointeur de texte est nul. Après lecture/mise en cache de la capacité, si count>=capacité en comparaison non signée, elle saute également le traitement. La file déjà présente n’est pas évincée par cette garde : c’est le nouveau message qui est écarté.

Un franchissement de cette gate ne suffit pas à prouver un append : préparation du texte, résultat vide, état d’un objet de throttling+0x100, temps et formatage interviennent ensuite. Ces mécanismes ne sont pas remplacés par des hypothèses dans les tests isolés.

Si les autres gardes passent,7A1010 construit la chaîne/flags et5FF230 ajoute l’entrée. Le bit0x80 du bas octet de flags provoque aussi l’incrément du compteur+0xF0. Le sens métier exact de ce bit n’est pas nommé à partir de son seul comportement.

### Consommation normale et chemin marqué0x80

Sur le chemin normal, les gardes de readiness et délai doivent passer. Le code sélectionne min(count,quota_cache) par comparaison non signée ; ouvre la boîte de chat par demande `Chat_Box_Open("1")`, puis prend les premières entrées. Pour chacune, il demande `Add_Message`, décale les entrées suivantes, détruit la dernière désormais inutilisée et recule la fin de28octets. Le quota est un nombre par invocation du consommateur ; le scheduler et sa correspondance effective aux frames ne sont pas exécutés ici.

Un chemin distinct, avec préconditions sur compteur+0xF0 et délai+0xFC, parcourt la file pour la première entrée dont flags&0x80 est non nul. Il peut donc sélectionner une entrée au milieu plutôt que la tête. Après demande au film, il la retire en conservant l’ordre des autres, décrémente+0xF0 et inscrit le flottant3.0 à+0xFC. Le code d’update diminue ce champ via une valeur de delta amont ; ni l’horloge effective ni un délai mural complet ne sont qualifiés.

Les demandes d’affichage précèdent le retrait ; aucun accusé d’affichage n’est vérifié par les appels sélectionnés du consommateur. L’exécution ou la réception réelle de ces demandes par le film n’est pas revendiquée.

### Pont AS2 et consommateurs locaux actuels

Les littéraux natifs Chat_Box_Open et Add_Message sont reliés aux méthodes déjà extraites du film. Add_Message→hud/addMessage rejoint le consommateur d’historique audité auparavant. Le montage effectif entre menu et Menu_SC4 reste inconnu ; leurs priorités ne sont pas déduites de la présence des deux fichiers.

Le100 du fichier de capacité native et le100 de l’historique AS2 sont des bornes de mécanismes différents, sans couplage démontré. Le quota2 de consommation ne remplace pas une politique serveur de taille/fréquence/historique.

Les consommateurs locaux sont réutilisés par conservation de la liste et des SHA-256 des1 168sources de `crates/*/src` Rust, `launcher/src-tauri/src` Rust et `launcher/web` JS/HTML. Les fragments réels Action/ClientPacket/ServerPacket, Input/ClientMessage/ServerMessage et bridge Tauri du launcher restent ceux de la preuve précédente. Aucune nouvelle file/commande de chat n’y est identifiée. Aucune recherche lexicale identique répétée. Ce constat n’est pas étendu à tous outils, dépendances ou ressources générées.

## 4. Vérifications réellement exécutées et résultats

`verify_native_buffer.py`, 2026-10-30T16:37:25Z–16:37:28Z, code0 :156/156 contrôles réussis. Ils comprennent identités, décodages et témoins, configuration, pont AS2, observations des28cas, conservation des sources et protections. Ils ne mesurent pas la complétude du jeu.

Méthode d’émulation : octets originaux uniquement, sans patch de code ou stub de callee ; pas d’appel OS. Des fragments de gate/quota/sélection/retrait sont démarrés sur leurs frontières exactes avec un contexte/pile explicites. Les helpers de construction et append sont appelés par leur entrée. Les demandes au film ne sont jamais exécutées ni simulées : les fragments de retrait commencent après ces appels.

Les caches globaux de capacité/quota et le flag « déjà initialisé » sont des overrides de DONNÉES fournis par le harness, explicitement recensés ; ils ne prouvent pas les valeurs chargées par le runtime. Une chaîne d’exception à0 sert de fixture pour le helper append qui la restaure. Les écritures CPU sont limitées à cette fixture, aux objets et à la pile ; aucun octet de code/image native écrit par les routines exécutées.

Les tests de contenu utilisent des chaînes ASCII SSO de15octets maximum et un vecteur réservé de160entrées, sans allocation/réallocation. Les cas de capacité/quota ne requièrent que les métadonnées de comptage : ils ne constituent pas100messages réellement présentés. Chaque invocation est limitée à100000instructions/2secondes. La relecture compare chaque instruction observée au PE original.

| Groupe | Cas et attendu | Observé |
|---|---|---|
| Capacité,9cas | count0/99 sous100 admis par cette gate ;100/101 refusés ;24 sous25 admis et25 refusé ; capacité0 refuse ; pointeur nul refuse | Conforme ; la fin de file n’est pas modifiée. |
| Cache brut0xFFFFFFFF, inclus dans les9cas | La comparaison non signée laisse passer count100 | Conforme. Ce n’est pas une preuve d’acceptation d’une valeur négative par le lecteur de configuration. |
| Quota,8cas | Avec quota2 : count0→0,1→1,2→2,5→2 ; quota0→0,1→1,100→5,0xFFFFFFFF→5 sur count5 | Conforme au min non signé. Aucune politique de validation du fichier déduite. |
| Construction d’entrée,4cas | Chaîne hello conservée et flags1/0x80/0x180/0xFFFFFFFF copiés | Conforme ; aucune interprétation métier des flags ajoutée. |
| Append réservé,1cas | first,second puis third avec bit0x80 ; entrée28octets copiée | Conforme ; pile et chaîne d’exception restaurées. |
| Retrait normal,2cas | Retrait de l’unique entrée ; puis tête a dans a,b,c | [] puis b,c ; flags et ordre conservés. |
| Sélection marquée,3cas | Première entrée0x80 en tête/milieu/fin | Index0/1/1 selon fixtures. Préconditions du chemin spécial explicitement supposées. |
| Retrait marqué,1cas | a,marked1,b,marked2 ; retirer marked1 | a,b,marked2 ; compteur2→1 ; délai+0xFC=3.0 ; pile équilibrée. |

28cas. Le retrait et la sélection marqués ne qualifient pas le scheduler/horloge complet. Un message peut franchir la capacité puis être refusé par une autre garde. Aucun rendu, ACK, consommation réelle du film ou fil serveur n’est simulé.

Non exécutés : ajout/vidage complets avec providers, throttler/formatage/horodatage complets, chargement de configuration, parseur négatif, allocation/free longues chaînes, premier montage, ActionScript, jeu LoL, simulation Rust, build/tests Rust, réseau, rendu, accessibilité et acceptation humaine. Les contrôles historiques ne sont pas présentés comme fraîchement exécutés.

## 5. Résolu, limites ouvertes et conditions de reprise

Résolu : rôle de file en attente, layout28octets, refus du nouvel ajout à capacité, distinction100 fichier/25 argument de secours, quota2, demandes puis retrait, ordre normal et sélection0x80, lien source vers Add_Message du film. Ce résultat complète le filtre ignore sans transformer un test de gate en fonctionnement global du chat.

| Ouvert | Impact | Entrée précise et condition de reprise |
|---|---|---|
| Chargement/montage/configuration effective |100/2 du fichier et25/2 du code ne sont pas des valeurs runtime observées | Priorité de montage et appel8B1A80 identifiés avec données réellement sélectionnées, cas absence/valeur invalide ; ne pas tirer cette conclusion des overrides du harness. |
| Throttler objet+0x100 et horloge | Autres causes de refus et rythme non qualifiés | Producteur des champs et fonctions d’horloge, gardes et remise à zéro ; cas nominal/refus avec contexte réel. |
| Bits de flags et readiness | Le comportement du bit0x80 est connu, sa catégorie métier et ses entrées non | Producteurs de flags et implémentations virtuelles ; contexte des messages marqués, compteur et délai cohérents. |
| Longues chaînes et allocation | Pas de qualification de toute durée de vie du buffer | Helpers d’allocation/free/réallocation et exceptions, avec ressources d’origine identifiées ; tests nominaux et échecs bornés. |
| Demandes native→film | Le retrait ne prouve pas la prise en charge UI | Consommateur réel793AA0, film monté et erreur/indisponibilité, puis historique et rendu observés. |
| Historique AS2 complet et reprise | Limite du film déjà identifiée mais pas partie complète | Réutiliser la preuve100 existante, relier flux réel, clear, scroll et reprise ; autres entrées/source système recensées. |
| Filtre ignore et autres chemins | Le chemin ignoré précédent contourne7ACF10, pas nécessairement toutes insertions | Appelants supplémentaires de7ACF10 et producteurs du buffer, en distinguant message système, partie et privé. |
| Produit local | Aucune fonctionnalité de chat terminée | Input/service/HUD locaux reliés, contrats de file et historique distincts, puis parcours réel à plusieurs clients et refus observés. |

Inconnues conservées sans mutation : SYS-17.2-09 → OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b ; SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. La source historique est disponible ; les lacunes sont des consommateurs, contextes ou validations précisément nommés, pas une demande générale d’autres assets.

Prochain lot documentaire possible : vérifier le dernier pont793AA0→film puis les erreurs/montage, ou le producteur du throttler+0x100. Ce sont des pistes nouvelles identifiées ; aucune reprise de la capacité ou de l’historique AS2 inchangés n’est nécessaire.

## 6. Corrections précises sous les tâches existantes

Propositions documentaires seulement : aucune insertion dans le plan, aucune modification de critères normatifs et aucune correction produit implicitement exécutée.

| Référence stable réutilisée/proposée | Résultat unique | Critères de fin futurs |
|---|---|---|
| SYS-17.2-09/H2-NATIVE-QUEUE | Relier une file locale en attente distincte de l’historique | Layout/contrat explicite, capacité avant/à/après borne, nouvelle entrée refusée sans effacer les anciennes, quota0/1/normal, ordre et retrait observés dans le vrai consommateur. Sources et différences locales documentées. |
| SYS-17.2-09/H3-FLAGS-AND-TIMING | Qualifier les entrées marquées et leur cadence | Producteur du bit0x80 et horloge nommés ; tête/milieu, compteur et délai, absence de perte/doublon par reprise ; aucune catégorie inventée. |
| SYS-17.2-09/H1-FILTERED-HISTORY | Relier l’historique visible au filtre et au flux effectif | Ajout avant/après ignore, aucun ajout par le chemin filtré, autres entrées inventoriées, taille/clear/reprise et défilement observés ; la file native n’est pas l’historique affiché. |
| SYS-17.4-07/I5-RECEIVE | Relier le filtrage local à la présentation | Émetteur/message identifié, présenté avant, absent après ajout, rétabli après retrait ; autre émetteur inchangé ; transport/identité distincts de la décision locale. |

Prérequis hérités : D17-SYS-17-2 requiert D13-SYS-13-3 ; D17-SYS-17-4 requiert D09-SYS-09-4. Les fiches et dépendances sont réutilisées dans le reçu, pas déclarées réalisées. Une limite de paquet ou une configuration native n’est pas substituée à une politique serveur d’audience et de rétention.

## 7. Livraison datée, preuves et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-09-NATIVE-BUFFER-01.md`.
- [verify_native_buffer.py](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/verify_native_buffer.py),19 369octets ; SHA-256 `f9255c5c43c4bcac336e016dac749c7b0bd913242710ef247e787bda298dfd08`.
- [native-buffer-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/native-buffer-proof.json),730 886octets ; SHA-256 `62317d47095d3706861c2921281ddbb0888a5f2bb3379564ab5256237883d0e6`.
- Reçu final : `F:\OpenLeague-work\audit-units\AUD-17.2-09-NATIVE-BUFFER-01\delivery-readback.json`, créé après ce rapport. Le premier reçu conserve audit_scope_closed=false car il précède la relecture ; la décision limitée de livraison est conservée séparément sans écraser les preuves.

Conservation :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode et2registres JSON comparés aux identités héritées ; même liste et mêmes SHA-256 des1 168sources. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés ; aucun stage, commit, reset ou nettoyage. Aucun fichier antérieur réécrit.

Relecture finale : identités,156contrôles et28cas, octets des instructions réellement exécutées, appels observés et absence d’exécution du film, overrides de données explicités, pont AS2/configuration conservés, sept rubriques et conditions de reprise. Le reçu de livraison donne les résultats effectifs.

Aucune modification du goal, de ses critères normatifs, de l’application de suivi, de son interface ou de ses bases. Le runtime du suivi n’est pas invoqué, les bases ne sont pas ouvertes ; les fichiers gelés sont seulement lus pour empreinte. Aucune installation, migration, relance, restauration ou nouvelle copie d’assets. Bilan : un lot d’audit clôturé, aucune fonctionnalité, tâche parente ou totalité du jeu déclarée terminée ; aucun taux global calculé.