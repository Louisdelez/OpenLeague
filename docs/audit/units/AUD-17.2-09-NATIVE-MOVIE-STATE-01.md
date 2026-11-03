# AUD-17.2-09-NATIVE-MOVIE-STATE-01 — Participation aux entrées et pointeur de film

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Tâches fonctionnelles conservées : SYS-17.2-09 et SYS-17.4-07.

## 1. Question précise, critères et décision limitée

Question issue du pont natif/film : que signifie réellement l’octet+0x98 utilisé comme prédicat par le vidage du chat, et comment se distingue-t-il du pointeur de film+4, du suivi des abonnements+0x80 et du marqueur de chargement+0xE5 ?

Critères du lot : identifier les écritures et la vtable concrète ; appuyer le sens des transitions par les fonctions/diagnostics d’entrée ; qualifier les frontières initialisation/création/libération du pointeur ; observer des chemins sûrs et distinguer chaque fragment post-callee ; conserver sources et preuves ; documenter sept rubriques et reprises. Aucun critère normatif du goal ou du plan n’est modifié.

| Dimension | Résultat limité |
|---|---|
| Audit | Terminé pour les champs et transitions source sélectionnés, après relecture de livraison. |
| Implémentation | Aucun code produit modifié. Aucun adaptateur exact de ces états historiques du chat identifié dans le corpus actuel inspecté. |
| Vérification |130contrôles réussis,26cas :13chemins natifs complets bornés et13fragments/arrêts explicites. Pas de dispatcher ou moteur de film réel exécuté. |
| Acceptation humaine | Non demandée ; aucun parcours du jeu accepté implicitement. |

La sémantique est précisée sans réécrire les anciens rapports : le terme « readiness » utilisé pour désigner mécaniquement le prédicat du drain ne signifiait pas une disponibilité de film prouvée. Le présent lot établit son lien avec les demandes d’activation/désactivation des entrées. Il ne qualifie pas toute la machine de chargement ou ses invariants en fonctionnement.

Exclus : vrais abonnements/dispatchers, appels Windows, création/rendu de film, résolution SWF/GFX et montage, scheduler, séquences de fermeture/reconnexion complètes et atteignabilité réelle de toutes les combinaisons de fixtures. Un seul lot actif, arrêté aux appels externes non exécutés et aux dépendances nommées en §5.

## 2. Sources, provenance et identités

Référence : LoL4.20.0.315, EUW, en_GB. Le client original est lu, jamais lancé.

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les adresses ci-dessous sont ses VA.

| Source | Intervalle, fin exclusive | Portée qualifiée |
|---|---|---|
| Initialisation de base | 792190–7922BA |72instructions ; écritures de base sélectionnées. |
| Initialisation de fenêtre dérivée | 78AE80–78B08A |135instructions ; champ+0x98 et traitement du retour de chargement. |
| Handoff de création de film | 792580–792C17 |475instructions décodées ; frontières de pointeur/résultat seulement, pas tout le moteur. |
| Frontière de libération | 7923F0–79247E |52instructions ; appel release, mise à zéro et nettoyage source. |
| Demande d’abonnement aux entrées | 794280–794737 |289instructions ; gardes, inscriptions, diagnostic et suivi. |
| Demande de désabonnement | 794740–794BD4 |259instructions ; gardes plateforme/film, retraits et suivi. |
| Wrapper d’activation | 78B300–78B31A |8instructions ; garde puis état demandé. |
| Wrapper chat de désactivation | 7AC000–7AC026 |11instructions ; garde de délai et état demandé. |
| Getter d’état brut | 78B360–78B367 |2instructions ; lit uniquement l’octet+0x98. |

9intervalles,1 303instructions ; bornes, décodages contigus et fins RET vérifiés. Octets et empreintes par intervalle dans le reçu. Un décodage complet n’est pas une qualification fonctionnelle de chaque callee.

Vtable concrète du chat0x10B8310, héritée du lot précédent : slot+4→78B360 ;+0x28→7ABD50 drain ;+0x2C→78B300 ;+0x30→7AC000. Les demandes d’entrée sont donc reliées au même objet concret, pas déduites de seuls noms de fonctions.

Littéraux source identifiés : HudChat.swf à0x10C119C ; diagnostic d’activation déjà effective/dispatcher non enregistré à0x10B6D78 ; diagnostic de désactivation sans dispatcher à0x10B7AD4 ; échec de CreateInstance de sGFxMovie::Load à0x10B7808. Les valeurs complètes sont dans le reçu.

Preuves réutilisées, sans replay :

- [Pont natif/film, livraison2](F:/OpenLeague/docs/audit/units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01-v2.md), [preuve principale](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01/native-film-bridge-proof.json), SHA-256 `b5695ff3e45da0be7d5a0f2e9dcce78786d082ae43381c987ea2fa9e0759e47b`, et [relecture2](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01/delivery-readback-v2.json), SHA-256 `5a2e266bae2737308d9237df6d83c836b4bb162d1aa9964b0f5c6b83c03c3c6d` : distinction champ+4/getter et dernière frontière d’appel. Les huit cas du pont et les tests de conversion ne sont pas rejoués. La première relecture en échec de ce lot précédent est conservée.
- [Buffer natif](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/native-buffer-proof.json), identité héritée conservée : call du getter dans le drain, champ de délai+0xFC et consommation. Les28cas du buffer ne sont pas réexécutés.
- Inventaire complet des1 168sources et interfaces gameplay/session/launcher : réutilisation par chemin et SHA-256, sans copie supplémentaire de toutes les fiches.

Outils existants identifiés : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et DLL. Aucune installation, nouveau PE, import REA/Ghidra ou reconstruction de ressource. La nouvelle piste est l’écriture de ces champs dans le client original.

## 3. Quatre champs distincts et leurs consommateurs

### Pointeur de film+4

792190 initialise le champ à0. Le constructeur dérivé78AE80 peut appeler792580 ; le helper appelle la factory790210 puis stocke son résultat dans+4 en79284D. Un résultat nul conduit au chemin de diagnostic et à un retour false sélectionné ; le chemin de succès sélectionné retourne true après ses opérations de configuration. Ces retours sont constatés statiquement ; les objets du moteur/factory et les diagnostics ne sont pas exécutés ici.

Le helper7923F0 teste le pointeur. S’il est nul, il retourne sans libération. Sinon il appelleCFBB70 sur le pointeur, le met à0 après le retour, puis effectue des appels au manager et du nettoyage des callbacks/collections. Le corps sélectionné ne remet pas explicitement+0x98 à0 ; les callees et le retrait du manager peuvent toutefois modifier l’état ou empêcher tout nouvel accès. Aucune utilisation après libération ou perte de messages en fonctionnement n’est conclue.

### État demandé de participation aux entrées+0x98

78AE80 initialise cet octet à1 avant le handoff de chargement. Le wrapper78B300 ne fait rien s’il est déjà non nul. Sinon il appelle794280 puis inscrit1, sans contrôler un code de succès. Le wrapper chat7AC000 diffère la désactivation si+0xFC est positif ; si le délai permet et+0x98 est non nul, il appelle794740 puis inscrit0, sans contrôler un succès d’abonnement/retrait.

Le getter78B360 ne lit que cet octet. Il ne consulte ni+4, ni+0xE5, ni la réception d’une méthode du film. L’objet l’utilise aussi comme prédicat du drain : c’est une dépendance source établie, pas une garantie de disponibilité du moteur.

### Suivi interne des abonnements+0x80

Le constructeur de base initialise+0x80 à0. Dans794280, les gardes portent sur ce champ et sur le dispatcher. Le corps prépare11demandes d’inscription via6E8B40, notamment événements de souris/clavier, puis inscrit+0x80=0. Dans794740, le corps prépare11demandes de retrait via6E89F0 puis inscrit+0x80=1. Les diagnostics parlent explicitement d’enable/disable input et de dispatcher non enregistré.

Les compteurs11sont bornés à ces deux fonctions, sans y mélanger les autres inscriptions du loader792580. Ils prouvent des demandes dans le code, pas que des abonnements actifs ont été observés.

794740 retourne précocement si le global plateforme0x2D77E80 est nul ou si+4 est nul. Le wrapper chat peut ensuite modifier+0x98 après ce retour, alors que le corps de retrait n’a pas tourné. Ce sont des chemins contrôlés observés en émulation, pas une erreur fonctionnelle démontrée dans le client initialisé.

### Marqueur d’échec+0xE5

Dans le constructeur dérivé, l’absence de source ou le retour de chargement false conduit à écrire1 à+0xE5. Cette écriture ne remet pas explicitement+0x98 à0 dans le fragment observé. Le filtrage ultérieur par le manager/scheduler et la portée exacte de ce marqueur sont à qualifier.

Le littéral du constructeur concret est HudChat.swf. La résolution de ce nom vers les ressources SWF/GFX et leur priorité ne sont pas exécutées ici ; la différence d’extension avec les ressources GFX déjà recensées ne démontre pas un asset manquant et ne motive aucune reconstruction automatique.

### Consommateurs actuels inspectés

Les1 168fichiers de `crates/*/src` Rust, `launcher/src-tauri/src` Rust et `launcher/web` JS/HTML sont identiques à l’inventaire hérité. La nouvelle recherche cible les adresses de ces fonctions, input_dispatcher/enable_input/disable_input et HudChat.swf ; contrôles positifs/négatif enregistrés. Zéro occurrence dans ce corpus.

Les interfaces réelles précédemment inspectées restent la corroboration : Action/ClientPacket/ServerPacket, Input/ClientMessage/ServerMessage et bridge Tauri du launcher. Aucun adaptateur historique exact de ces états du chat n’y est identifié. Les entrées Bevy/gameplay, le focus de boutique et les autres systèmes présents sont conservés ; absence d’un nom historique ne signifie pas absence de tout système d’entrée. Un futur consommateur Rust peut adapter ce contrat sans reconstruire intégralement le moteur de film.

## 4. Contrôles réellement exécutés, attendu et observé

`verify_native_movie_state.py`, 2026-10-30T17:14:02Z–17:14:05Z, code0 :130/130 contrôles réussis. Ils couvrent sources, vtable, littéraux, témoins,26cas et conservation, pas toute la fonctionnalité.

Méthode : octets originaux, aucun patch ni stub. Contextes, pile et chaîne d’exception à0 sont des fixtures. Le global0x2D77E80 est un override de DONNÉES explicite uniquement pour exercer les gardes d’absence plateforme/film. Les écritures CPU sont limitées aux fixtures/pile, aucune écriture de l’image native. Limites100000instructions/2secondes par invocation. Chaque instruction observée est comparée au PE lors de la relecture.

13cas exécutent un chemin de fonction original jusqu’au retour ;13sont des préfixes, arrêts avant callee ou fragments après retour SUPPOSÉ d’un callee. Aucun résultat de création, libération ou inscription réel n’est inventé. La copie des champs d’un objet ne prouve pas qu’une combinaison est atteignable après initialisation complète.

| Groupe | Attendu | Observé et limite |
|---|---|---|
| Getter,4cas |+0x98 retourné pour0/1, indépendamment de+4 nul/non nul | Conforme ; aucun autre champ consulté. Les pointeurs non nuls sont des valeurs de fixture, pas un film chargé. |
| Activation déjà non nulle,2cas | Aucun appel à794280 ; valeur1 ou2 conservée | Conforme sur les chemins complets. La fixture2 ne qualifie pas la production d’états non canoniques. |
| Activation inactive,1cas | Atteindre le CALL de demande, sans changer encore+0x98 | Arrêt avant78B30C, état0. Dispatcher non exécuté. |
| Après retour supposé d’activation,1cas | Écriture1 sans test du registre EAX fourni0 | Conforme au fragment78B311 ; ce n’est pas une activation réussie du dispatcher. |
| Désactivation déjà inactive | Ne pas appeler794740 | Retour complet, état0. |
| Délai positif3.0 | Reporter la désactivation | État1 conservé, pas de callee. |
| Plateforme absente ou film nul | Retour précoce du vrai794740 puis état demandé0 | Deux chemins complets conformes ; aucun appel Windows/dispatcher. Le champ+0x80 reste0. |
| État non nul2 et délai−1 | Traiter comme participation active et désactiver sur garde plateforme absente | État0, callee gardé exécuté. |
| DélaiNaN | Saut prévu par COMISS/JB, sans désactivation | État1 conservé ; pas de politique de validation des délais déduite. |
| Initialisation de base,2cas | Mettre+4 à0 sans modifier la fixture+0x98 | Conforme sur le préfixe, avant l’allocateur. |
| Initialisation dérivée,1cas | Inscrire+0x98=1 avec+4 toujours0 au fragment | Conforme ; pas constructeur entier ni rendu. |
| Affectation du résultat factory,4cas | Résultat0/non nul stocké ;+0x98 conservé0/1 ; bonne branche sélectionnée | Conforme ; factory non exécutée. |
| Retour de chargement supposé,2cas | False marque+0xE5=1 ; true conserve0 ;+0x98 reste1 | Conforme ; aucune création/réception de film revendiquée. |
| Release sur nul,1cas | Retour complet, aucun effet sur+0x98 | Conforme. |
| Release non nul avant call,1cas | Pointeur correct transmis àCFBB70 | Arrêt avant792400 ; release réel non exécuté. |
| Après retour supposé du release,1cas | Mise à0 de+4, +0x98 conservé | Conforme au fragment ; arrêt avant retrait du manager. |

Les six cas de désactivation sont séparés dans le reçu. Les13fragments/arrêts n’ont pas été comptés comme13opérations externes réussies.

Non exécutés : vrais appels Windows, corps d’inscription/retrait d’événements, factory/moteur de film, release externe, pipeline complet de chargement/destruction, manager/scheduler réel, rendu, jeu LoL, ActionScript, réseau, tests/build Rust et acceptation humaine. Les anciens cas de pont, buffer et conversion ne sont pas réannoncés comme fraîchement exécutés.

## 5. Résolu, encore ouvert et conditions de reprise

Résolu : l’assimilation du prédicat+0x98 à « film chargé » est écartée ; les écritures et appels établissent un état demandé lié aux entrées. Les champs de film, d’abonnements et d’échec sont distincts. Les frontières de création/libération et les retours gardés de désactivation sont identifiés et leurs effets sélectionnés observés.

| Clause ouverte | Impact | Entrée précise et condition de reprise |
|---|---|---|
| Dispatcher et subscriptions réels | Un état demandé ne prouve pas les handlers actifs | Resolver du dispatcher,6E8B40/6E89F0 et cycle du manager, callback effectif et refus observés. |
| Factory790210 et wrapper de film | Un pointeur affecté ne prouve pas un objet monté/rendu | Producteur réel, résolution HudChat.swf vers la ressource, ownership et erreurs ; conserver les sources GFX disponibles. |
| Méthode virtuelleC8 | La réception de Add_Message reste inconnue | Implémentation du récepteur/méthode, lookup trouvé/absent, résultat et observation dans le film. |
| Manager/scheduler après échec ou release | Atteignabilité d’un drain avec film absent encore indéterminée | Retrait du manager, marqueur+0xE5 et sites d’update ; chargement échoué/remplacement/fermeture sans nouvel accès invalide. Aucun bug de perte de messages conclu ici. |
| Cohérence des champs en séquence | Les fixtures ne sont pas des cycles réels | Constructeur complet, actualisations, enable/disable, erreur et destruction avec identités de binaires/ressources et état observé. |
| Focus chat contre combat | L’état générique d’entrée n’est pas le focus de saisie | Consommateur de saisie chat et gardes des commandes de combat, conservant les preuves antérieures du focus de boutique distinct. |
| Version actuelle du convertisseur | Toujours ouverte depuis le pont précédent | Comparer/requalifier le module courant avec les fixtures identifiées ; pas de nouveau codec et pas de replay général inchangé sans nécessité. |

Inconnues conservées sans mutation : SYS-17.2-09 → OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b ; SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. La disponibilité du film, son exécution, l’implémentation locale et l’acceptation humaine restent ouvertes.

Prochain lot terminable : factory790210 et pointeur du récepteurC8, ou filtrage du manager/scheduler par le marqueur+0xE5 après échec. Ce sont des pistes nommées ; pas de nouvelle recherche générale ni de répétition des gates d’entrée inchangées.

## 6. Corrections précises et réutilisation

Propositions documentaires sous les tâches existantes seulement. Aucun registre, statut, critère normatif ou logiciel modifié.

| Référence stable | Résultat encore à livrer | Critères de fin futurs |
|---|---|---|
| SYS-17.2-09/B2-MOVIE-STATE | Représenter séparément état demandé d’entrée et disponibilité du film | Chargement réussi/échoué, entrée activée/désactivée, remplacement et fermeture ; sources des transitions identifiées ; aucun succès d’affichage déduit de+0x98 seul. |
| SYS-17.2-09/B2-INPUT-REGISTRY | Qualifier les abonnements effectifs, pas seulement leur demande | Dispatcher et callback réels ; inscription/retrait idempotents et refus, état demandé/état effectif distincts ; aucune interface factice promue en produit terminé. |
| SYS-17.2-09/B2-LIFETIME | Qualifier manager et ownership après échec/release | Pointeur/identité remis à jour, retrait d’update prouvé, absence de réutilisation ; conservation ou refus des messages explicitement décidé et observé. |
| SYS-17.2-09/B3-METHOD-DELIVERY | Aller du pointeur au vrai consommateur Add_Message | Méthode identifiée, cas absent/erreur/succès et réception dans le film, rendu séparé. |
| SYS-17.2-09/B1-CONVERTER-REUSE | Conserver et qualifier le helper Rust déjà identifié | Version actuelle et capacité/stockage utiles vérifiés ; pas de duplication du codec audio ni de substitution de sa composition complète au pont de chat. |

Prérequis hérités : D17-SYS-17-2 requiert D13-SYS-13-3 ; D17-SYS-17-4 requiert D09-SYS-09-4. Aucun n’est déclaré terminé par ce lot. L’implémentation Rust peut adapter ce contrat aux consommateurs existants ; la reproduction de tous les offsets/classes du moteur historique n’est pas un critère ajouté au plan.

## 7. Livraison, relecture et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-09-NATIVE-MOVIE-STATE-01.md`.
- [verify_native_movie_state.py](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-MOVIE-STATE-01/verify_native_movie_state.py),19 536octets ; SHA-256 `70872fbb2f65baf8e5b24488702e400ab1c90d17de2b610ddaaa72ff1691be1e`.
- [native-movie-state-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-MOVIE-STATE-01/native-movie-state-proof.json),502 419octets ; SHA-256 `9878a6ddc5aff238f289ef00764e6914e6f5c82bdf03e1adb05b130f934fa5c1`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.2-09-NATIVE-MOVIE-STATE-01\delivery-readback.json`, créée après le rapport. Le premier reçu conserve audit_scope_closed=false car il précède la livraison ; la clôture limitée est portée par la relecture finale, sans réécrire les preuves.

Conservation :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode,2registres JSON et corpus1 168sources par références/empreintes. Les preuves antérieures, y compris les premières relectures en échec conservées du pont, sont intactes. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés ; aucun stage, commit, reset ou nettoyage.

La relecture contrôle identités,130contrôles et26cas, séparation des13chemins complets/13fragments, octets exécutés, absence des callees non qualifiés, sept rubriques, empreintes citées et conditions de reprise. Les résultats effectifs sont enregistrés dans le reçu final.

Aucune modification du goal, de ses critères normatifs, de l’application de suivi, de son interface ou de ses bases. Runtime du suivi non invoqué, bases non ouvertes ; les fichiers gelés sont seulement lus pour empreinte. Aucune installation, migration, relance, restauration ou nouveau binaire. Bilan : un lot d’audit clôturé, aucune fonctionnalité, tâche parente ou totalité du jeu déclarée terminée ; aucun taux global calculé.