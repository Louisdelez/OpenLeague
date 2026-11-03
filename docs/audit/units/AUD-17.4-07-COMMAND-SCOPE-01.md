# AUD-17.4-07-COMMAND-SCOPE-01 — Commandes historiques et consommateurs

Date : 2026-10-30. Projet : F:\OpenLeague. Goal SYS-01.2-02. Tâche SYS-17.4-07 ; exigence OLF-19cedfbd-1d0c-5be1-9e43-e4fae8f453cd ; inconnue OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38.

## 1. Exigence et portée de clôture

Exigence entière examinée : « Implémenter les commandes de chat historiquement applicables au serveur local ». Son critère produit original requiert intégration au vrai consommateur, référence4.20, succès/refus/limites. Il demeure inchangé et non satisfait comme fonctionnalité complète.

Ce lot consolide l’audit : classer les18familles du constructeur déjà identifié, préserver les fonctions actuelles, relier les sources et préciser l’applicabilité inconnue. Il examine les handlers restants note/help/allcommands/chatfilter/equalize/noequalize et leurs frontières sûres. Arrêt avant IO de notes, mutations de filtre, rendu/aide réelle et requêtes non qualifiées. Sources, consommateurs, vérifications, lacunes, corrections et conservation doivent remplir les sept rubriques. Ces critères bornent ce lot documentaire et ne modifient aucun critère normatif.

| Dimension | Conclusion |
|---|---|
| Audit de l’exigence | Terminé avec preuves pour l’état courant après relecture finale ; l’exhaustivité du catalogue runtime et l’applicabilité locale de toutes les commandes restent indéterminées et nommées. |
| Implémentation | Mécanisme de pause/reprise présent ; liaison slash non identifiée. Ressources d’émotes partielles ; autres consommateurs précis de commandes non identifiés dans le périmètre inspecté. |
| Vérification |162 contrôles sur18cas bornés ; cinq chemins complets vides/sans action et13fragments ; aucun IO, filtre modifié, réseau ou sortie du jeu exécuté. |
| Acceptation humaine | Non demandée ; aucune validation produit inférée. |

La clôture de l’audit ne coche pas la tâche, ne ferme pas l’inconnue open, ne choisit pas automatiquement les commandes applicables et ne déclare pas le jeu ou le goal complet. Une absence d’implémentation n’est pas une preuve de non-applicabilité permettant d’écarter une commande du projet.

## 2. Sources et identité de la référence

LoL4.20.0.315, EUW, en_GB. PE original :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les adresses sont des VA ; fins exclusives.

Le [catalogue antérieur](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/commands-catalogue.json), SHA-256 `567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0`, relie857530→85D620→constructeur7A1510. Ses18familles comprennent16inscriptions normales et equalize/noequalize sous `([*[0x2D79104]+0x10]&1)!=0`. Le sens et le contexte effectifs de ce bit ne sont pas qualifiés. Les deux slots de callback18/1C sont revérifiés directement dans les octets originaux pour chaque famille ; ils ne sont pas interchangeables.

Alias lexicaux hérités : en_GB49paires alias/rôle, dont43normales ; fr_FR79/69. Ce ne sont pas49/79commandes ni une preuve d’alias effectivement enregistrés. La présence d’une chaîne ne décide ni syntaxe complète, ni permission, ni applicabilité. Le catalogue ne prétend pas couvrir tous les ajouts dynamiques du runtime.

Six fonctions nouvellement examinées, contiguës, fins RET,876instructions :

| Source | Instructions | Frontière |
|---|---:|---|
|7A4440–7A462E|139| note : chaîne vide/information ou chemin de fichier local |
|7A4630–7A4ACA|321| help : tokens/lookup/formatage localisé ; seuls gates préparés exécutés |
|7A4AD0–7A4DAF|224| allcommands : arbre courant à context+0x20, sortie localisée |
|7A4DB0–7A4E7F|63| chatfilter : état, message puis demande de setter |
|7A3EA0–7A3F51|58| equalize : prédicat de contexte/HUD puis requête824C50 |
|7A3F60–7A4059|71| noequalize : prédicat puis requête opaque ; acceptation non qualifiée |

Les139+321+224+63+58+71instructions sont enregistrées avec leurs octets et empreintes. Littéraux identifiés : ../MyNotes.txt, game_chat_note_message, game_chat_note_no_notes, game_console_chatcommand_chatfilter_enabled/disabled, préfixe game_console_chatcommand_ et suffixe _short.

Preuves héritées épinglées : whisper/reply (`62e2eee1c6c74ff0f863ace81c93a8566fd743d9052b4e49d5d4202552b01608`), ignore (`21f90ad5ef2f81d9e3164547a87dddad9ec492af7cc4e6fb4fd6357cb576754a`), pause/reprise (`ae939401c1427d1f0a49a1a412fb5a3d5674c63610d33da28fcad149e24b2984`), émotes-v2 (`c41a86e0f420876cb063913861241617dec97bf18453d2072443572522e743c3`), surrender (`731c41507851f8305f0eec26494ebd5a355169026c24a4a718cb878057a18354`) et équipe/global (`48877ea06d9a4445be78736944bc3a88eb50c11e1f950535bff9c5b9cbea1b22`). Les chemins complets sont dans le reçu principal.

L’[erratum d’interprétation de recherche des émotes](F:/OpenLeague-work/audit-units/AUD-17.4-07-EMOTES-01/search-interpretation-correction.json), SHA-256 `58d6cbf01e6c6af5f32bb83fc75828d59e939505112194a3255d78765c18a7bc`, est conservé : ne pas répéter la fausse conclusion de regex défectueuse. Les cas anciens ne sont pas rejoués.

Outils existants : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et DLL identifiées ; aucun téléchargement, installation, nouveau PE ou import REA/Ghidra.

## 3. Chaque famille et son consommateur actuel

Le tableau couvre exactement les18familles de ce constructeur, pas un ensemble runtime exhaustif. Les emplacements sont callback18 / callback1C. Chaque ligne conserve son travail restant ; aucun état « absent » ne devient « non applicable ».

| Famille | Callbacks natifs | Source et état | Reprise précise |
|---|---|---|---|
| whisper | 0x7a35c0 / 0x7a11b0 | Service de messages privés, texte/connexion/parseur partiellement sourcés | Relier destinataire et livraison privés réels ; compte/permissions et erreurs restent ouverts. |
| ignore | 0x7a3810 / 0x7a11b0 | État local en jeu et demande sociale distincts ; filtre de présentation sourcé | Relier commande au vrai consommateur, état/filtre/refus ; aucun accusé ou blocage persistant inféré. |
| reply | 0x7a11b0 / 0x7a39f0 | Callback de saisie slot1C, préremplissage plutôt qu’envoi | Identifier le producteur de cache de destinataire et le vrai champ ; ne pas utiliser le slot18 commun qui ne fait pas cet effet. |
| allchat | 0x7a3be0 / 0x7a11b0 | Route globale et préférence ShowAllChannelChat sourcées | Relier parser/service, destinataires et permissions ; distinguer visibilité client et droits serveur. |
| surrender | 0x7a3cb0 / 0x7a11b0 | Requête native sourcée ; vote serveur non qualifié | Implémenter/qualifier vote d’équipe, quorum/temporisation et fin ; abandon de session individuel distinct. |
| nosurrender | 0x7a3da0 / 0x7a11b0 | Requête négative native sourcée | Même vote serveur que surrender ; refus, identité et double vote observés. |
| help | 0x7a4630 / 0x7a11b0 | Lookup/aide localisée côté client, tokens/registre | Relier grammaire et registre des commandes réellement applicables, aide trouvée/absente, erreur et sortie réelle. |
| pause | 0x7a4060 / 0x7a11b0 | Mécanisme actuel présent ; liaison slash absente du périmètre inspecté | Réutiliser send_pause_tracked(true), permissions et retours existants ; ne pas remplacer par le toggle UI. |
| resume | 0x7a4130 / 0x7a11b0 | Même mécanisme actuel présent ; liaison slash non identifiée | Réutiliser send_pause_tracked(false), ordre/refus/états existants ; pas de toggle inversant un état déjà repris. |
| dance | 0x7a4200 / 0x7a11b0 | Émote native et métadonnées d’animation, pas commande jouable complète | Relier intention/diffusion et rôle d’animation effectif par acteur ; vie/état/interruption et refus. |
| taunt | 0x7a4290 / 0x7a11b0 | Même frontière d’émote, index source distinct | Même consommateur d’émote, rôle taunt observé et refus nommés. |
| laugh | 0x7a43b0 / 0x7a11b0 | Même frontière d’émote, index source distinct | Même consommateur d’émote, rôle laugh observé et refus nommés. |
| joke | 0x7a4320 / 0x7a11b0 | Même frontière d’émote, index source distinct | Même consommateur d’émote, rôle joke observé et refus nommés. |
| chatfilter | 0x7a4db0 / 0x7a11b0 | Lecture/branche d’un réglage et demande de changement ; sortie localisée | Qualifier la valeur du réglage, son setter et le texte réellement filtré ; pas de permission/modération serveur déduite. |
| note | 0x7a4440 / 0x7a11b0 | Route locale vers ../MyNotes.txt et messages de statut | Qualifier IO/échec/contenu et emplacement effectif dans un lot autorisé ; aucun fichier écrit ici. |
| allcommands | 0x7a4ad0 / 0x7a11b0 | Énumération de l’arbre courant de descripteurs | Observer population, commandes ajoutées/masquées, liste/aide locale et branches vides ;18n’est pas un inventaire runtime prouvé. |
| equalize | 0x7a3ea0 / 0x7a11b0 | Inscription sous bit conditionnel et autre prédicat runtime opaques | Entrées précises : producteur du bit et du prédicat, request824C50, sens/permissions/retours du serveur. |
| noequalize | 0x7a3f60 / 0x7a11b0 | Même inscription conditionnelle ; requête opaque source | Qualifier la requête et son destinataire ; retour traité1 sur voie sans action ne prouve aucune acceptation. |

Les sources note/aide/filtre décrivent des fonctions client. Cela n’autorise pas à les retirer du périmètre global du jeu ; leur consommateur relève du client et ne doit pas être inventé comme API serveur. Les deux familles conditionnelles ne sont ni adoptées automatiquement ni déclarées inutiles.

### Acquis de pause à conserver

Le [reçu du consommateur actuel](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/current-pause-consumer-proof.json), SHA-256 `070776c25efde3d285ac8677eb6b40a88bf2303f588412615d87fe25a67fb406`, et chaque fichier/fragment courant sont revérifiés. Le contrôleur ordinary_pause existe, avec touche/UI, transports typés et permissions du serveur local. Son action ordinaire choisit un toggle à partir de l’état observé ; la correction slash déjà proposée est absolue : pause→send_pause_tracked(true), resume→send_pause_tracked(false). Il ne faut ni reconstruire ce mécanisme ni brancher les deux commandes sur son toggle.

Cela reste une proposition de liaison, non implémentée ici. Les tests anciens ne deviennent pas des tests courants de commande slash et la politique locale de pause ne prouve pas celle des tournois historiques.

### Autres frontières actuelles

Les interfaces core/session et le corpus de chat sont réutilisés par empreintes : configuration Chat.ini chargée, consommateurs de chat/historique/focus non identifiés dans ces routes. Les ressources/animations d’émotes ne constituent pas un ordre social avec réplication. L’abandon individuel de session n’est pas le vote d’équipe de surrender. Les résultats de match fondés sur le Nexus restent conservés.

Les1 168sources Rust/JS/HTML gardent leurs identités. Une seule recherche nouvelle vise les six handlers restants et les littéraux chatfilter/MyNotes : aucun adaptateur exact trouvé, témoins positifs/négatif réussis. Les recherches de chat générales et les analyses inchangées des autres familles ne sont pas réexécutées. La conclusion d’absence est bornée aux sources/interfaces inspectées, sans nier tous les mécanismes du projet.

## 4. Attendu, observé et vérification exécutée

Python existant, `-X utf8 -E -B verify_command_scope.py`, code0 :162/162 contrôles sur18cas. Dates exactes dans le reçu. Octets originaux sans patch/stub. Le cache de prédicat2D789B4 et le propriétaire2D77E54 sont des données fournies ; chaînes/tokens, arbre vide, pile/exception sont des fixtures. Aucune écriture CPU de l’image PE. Limites100000instructions/deux secondes.

| Groupe | Cas | Attendu/observé | Limite |
|---|---:|---|---|
| chatfilter après getter supposé |3| valeur1 choisit la clé enabled ;0/2 la clé disabled | arrêt avant localisation ; getter, sortie et mutation non exécutés |
| help sur tokens préparés |4| vector vide ou premier token vide unique→branche sans aide ; autres cas sélectionnés→traitement | tokenizer/lookup et grammaire réels non exécutés |
| note, chaînes inline/indirectes vides/non vides |4| vide→information ;non vide→chemin de construction de fichier | arrêt avant IO ; aucune création ou écriture de MyNotes |
| allcommands, arbre vide fourni |1| retour AL1 sans entrée à afficher | chemin complet, aucun inventaire réel de commandes issu de cette fixture |
| equalize |4| prédicat actif ou HUD absent→AL0 ; sinon requête atteinte avec argument1 | trois retours complets ; un arrêt avant824C50 ; aucune acceptation serveur |
| noequalize |2| prédicat actif→AL1 sans action ; sinon continuation de préparation | un retour complet ; un préfixe arrêté avant la requête |

Cinq chemins complets ne sont pas cinq fonctionnalités terminées. Treize cas sont des fragments/préfixes. Les valeurs du getter et les formes inline/indirectes ne démontrent pas leur production dans le client initialisé. Les traces stockent les instructions distinctes observées et leurs octets ; elles ne sont pas toute la chronologie des répétitions.

Analyse statique utile : le filtre lit un état, choisit le message enabled et demande0 quand l’état vaut1 ; sinon message disabled et demande1. Le sens complet de cette valeur n’est pas inventé comme booléen de permission. Le setter835730 reste à qualifier. allcommands parcourt l’arbre courant, ce qui interdit de présenter18comme un total runtime prouvé.

Contrôles frais : identités,36stores de callback, sources des deux locales, six décodages, témoins,18cas, vraie pause courante, recherche ciblée et conservation. Non exécutés : IO des notes, localisation/rendu, getter/setter réels du filtre, égalisation envoyée ou acceptée, parser slash du jeu courant, réseau/serveur, tests/build Rust, client complet et acceptation humaine. Les tests et observations précédents sont hérités.

## 5. Inconnues et conditions de reprise

L’inconnue du registre reste open et sa formulation ancienne « Chat.ini resource load only » ne reflète pas toutes les sources désormais identifiées. Le reçu isolé conserve ce décalage ; aucun registre n’est réécrit. Les conditions d’autorité, de runtime et de portage restent ouvertes.

| Manque | Entrée/résultat nécessaire à la reprise |
|---|---|
| Catalogue réellement applicable | Population des registres, ajouts dynamiques, modes et producteurs des drapeaux ; fiche par famille/alias avec argument/acteur/droit/effet/refus. Ne pas exclure une absence pour réduire le travail. |
| Parser et dispatch slash actuels | Vrai champ de saisie, grammaire fermée et consommateur final ; commande inconnue, argument invalide, droit refusé et succès observés ; aucun retour fictif pour une commande absente. |
| Pause/reprise | Adapter les intentions absolues au transport existant ; état déjà en pause/repris, refus et répétition observés ; aucun toggle involontaire. |
| Familles sociales, affichage et ignore | Destinataire/cache/identités et consommateur réel ; envoi/réception, filtrage et retour HUD distincts ; serveur/persistance non déduits du seul client. |
| Votes et émotes | Protocole/permissions/états serveur et consommateurs d’acteur ; distinguer vote d’équipe, abandon individuel, métadonnées et animation effectivement jouée. |
| Notes/filtre/aide | IO et mode exact du fichier, échecs et sortie locale ; producteur/contrat835180/835730 ; arbre/langue/lookups effectifs. Aucune IO autorisée implicitement par cet audit. |
| equalize/noequalize | Producteurs des deux prédicats, contexte d’inscription et implémentation824C50/service ; portée exacte de la requête, droits et erreurs serveur. |

Les sources partielles, l’état actuel et les entrées manquantes sont précisément documentés. Aucune entrée indispensable n’empêche de remplir les sept rubriques d’audit ; les inconnues empêchent de déclarer la fidélité et la fonctionnalité complètes. L’audit documentaire de l’état courant peut se clore ; le goal global reste actif et incomplet.

Les mêmes sources/gardes ne doivent pas être recherchées ou rejouées sans nouveau contexte, code modifié ou observation pertinente. Les prochaines actions doivent porter sur les consommateurs/callers nommés ou une autre exigence à auditer.

## 6. Corrections petites sous K1/K2

Réutiliser SYS-17.4-07/K1 et K2. Aucune fiche n’est ajoutée dans le plan ; les propositions sont documentaires et les critères normatifs demeurent inchangés.

| Référence | Objectif unique | Critères futurs |
|---|---|---|
| K1/famille, pour chacune des18lignes | Contrat et applicabilité d’une seule famille | Syntaxe/alias/arguments, propriétaire client/serveur, acteur/droits, effet et refus sourcés ; inconnues explicitement conservées. |
| K2/famille retenue | Liaison réelle d’une seule famille | Parser→handler autorisé→consommateur ; nominal, mauvais argument, inconnu et refus ; preuve sans succès fictif. |
| K2/pause et K2/resume, existants | Deux intentions absolues sur mécanisme conservé | true et false, cas idempotents, erreurs, demande en attente et reconnexion ; source/versions et vrai serveur observés. |
| K1/notes, K1/filtre, K1/aide | Trois contrats client séparés | IO/échec, valeur du filtre/texte produit, lookup/liste/aide ; aucune capacité serveur inventée. |
| K1/conditionnelles | Décision sourcée pour equalize puis noequalize | Contextes/prédicats, autorité et requête identifiés ; pas d’adoption depuis le seul nom ou d’exclusion sans preuve. |

Ces libellés détaillent les tâches existantes et ne renumérotent pas les anciennes preuves whisper/ignore/pause/emotes/surrender. D17-SYS-17-4 requiert D09-SYS-09-4 ; autres dépendances de confidentialité/transport conservées, non déclarées terminées ici. Les18familles ne deviennent pas un dénominateur de jeu achevé.

## 7. Livraison et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.4-07-COMMAND-SCOPE-01.md`.
- [verify_command_scope.py](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMAND-SCOPE-01/verify_command_scope.py),18 824octets ; SHA-256 `63318d35c24b7df682fa33c6d59ee27e7243de44971c856756adfab006a6e4de`.
- [command-scope-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMAND-SCOPE-01/command-scope-proof.json),306 987octets ; SHA-256 `20dedf3b158377b2db40ba907810c1a60907745fa88d6de63a56061e67d2307b`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMAND-SCOPE-01\delivery-readback.json`. Le reçu principal antérieur garde audit_scope_closed=false ; la relecture finale porte la clôture documentaire après les sept rubriques.

Elle vérifie les162contrôles,18familles et18cas distincts, séparation5/13, octets originaux, consommateurs et pause conservée, limites/applicabilité, corrections, empreintes et conservation. Aucun pourcentage d’achèvement du jeu n’est inféré.

Conservés :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode, registres, preuves et1 168sources ; HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés. Aucun stage, commit, reset, nettoyage ou restauration.

Aucune modification du goal, de ses critères, du plan, du suivi, de son interface ou de ses bases. Runtime non invoqué, bases non ouvertes ; aucune installation, migration, relance ou nouveau binaire. Le lot précédent est une progression vérifiée ; la présente clôture d’audit ne termine aucune commande ou jeu à elle seule.
