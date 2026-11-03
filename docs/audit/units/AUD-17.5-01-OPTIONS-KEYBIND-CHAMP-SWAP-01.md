# evtUseChampSwap — déclaration TagTeam

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-KEYBIND-CHAMP-SWAP-01, goal SYS-01.2-02, parent SYS-17.5-01. Une identité physique XML81 : OPT-SRC-56ce51176f328b6e. Le précédent lot ChampionOnly est un progrès vérifié. Audit : association clôturable après relecture. Implémentation : raccord TagTeam non qualifié, routes actuelles de join/actions conservées. Vérification : documentaire seulement, zéro cas de jeu. Acceptation humaine : non demandée. Le parent et le goal restent ouverts.

## 2. Sources natives et disponibilité

FoundryOptionsKeybinds.xml:81, SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e : evtUseChampSwap, condition propre mutator:TagTeam, ancêtre game, input/GameEvents. Octets/offsets/index vérifiés. Defaults/Input.ini:373 contient [t] ; son espace final est conservé dans la ligne de preuve. Les overrides deploy/user fournis n’ont aucune entrée de ce nom. Locale en_GB:569 : Swap Champions.

La présence du contrôle et de sa touche ne prouve pas qu’un mode TagTeam était exposé en EUW4.20, ni une permission de swap. Les champs d’environnement natif déjà audités construisent dynamiquement mutator:+chaque chaîne ; leurs valeurs effectives restent inconnues. Aucune disponibilité universelle ou indisponibilité universelle n’est affirmée.

## 3. Conditions et consumers actuels

Le contrat host/ModelFactory déjà acquis est réutilisé : la factory teste les termes de onlyshowif dans le vecteur d’environnement et peut ne pas créer le modèle. InitializationData fournit ce vecteur. Ces fenêtres sont relues, aucune analyse/exécution AS/native nouvelle. Les conditions de parent et de feuille restent distinctes de l’autorisation du serveur. La famille keybind input/capture/Update et ses limites de provider sont conservées.

Une recherche nouvelle bornée au corpus1168Rust/launcher et à neuf graphies explicites de l’événement/mode a produit zéro ligne. Le résultat KeyCode::KeyT du lot Chaos, déjà vide, est réutilisé après vérification du corpus ; il n’est pas relancé. Cela n’établit ni absence sémantique globale ni absence de toute transformation dans le jeu. Les assets/configs et scripts externes ne sont pas exclus par cette recherche de code.

Douze fenêtres concrètes sont inspectées : core/lib.rs:155..174 représente l’identité du champion ; 279..319 définit Action et le join courant ; 533..575 crée un joueur3v3 depuis une définition de champion ; 598..623 applique les gardes et actions. SwapItems/SwapItemsChecked concernent l’inventaire. session_transport.rs:49..58 et79..95 donne les schémas locaux join/session. server/session_host.rs:74..100 et121..145 relie la demande authentifiée au joueur et à game.command. client/main.rs:1366..1394 et1439..1501 produit les commandes ordinaires. Ces points d’entrée ne qualifient pas un swap TagTeam. Le consumer réel UseItem dans consumables.rs:8..23 consulte shop::catalog,qui lit shop_foundation.json dans shop.rs:36..48 ;l’entrée3288 est absente de ses33objets. Ses refus sont lus dans le code,non exécutés. Join, swap d’objets, pet ou transformation de sort ne sont pas assimilés à cet événement. Le protocole local n’est pas le protocole Riot historique.

## 4. Attendu et observé

Attendu : source/gate/binding exacts, inspection du consumer au-delà d’un nom absent et reprise actionnable. Observé : déclaration confirmée ; route et règle TagTeam non qualifiées ; join, commandes et sessions préservés. La recherche ciblée et son collecteur ont un reçu réel avec code0, bornes et empreintes. La recherche de graphies de tâches correspondantes a trouvé quatre occurrences : ce sont les quatre fiches existantes NATIVE-ITEM-3288-SCOPE/DATA/IMPL/ACCEPT,a_faire,consacrées au même objet3288. Elles restent inchangées. Le catalogue natif récupéré associe SpellName=TagTeamSwap à cet objet,InStore=0 et CanBeSold=0 ;le fichier3288.inibin de520octets est présent et son SHA vérifié. La chaîne ASCII est à l’offset484 ;cela ne réexécute pas un lecteur de champ natif. TagTeamSwap.inibin1415octets et TagTeamSwap.luaobj128octets sont présents,épinglés et non exécutés/désassemblés. Leurs paramètres/scripts et le lien événement→objet restent à qualifier. L’absence de3288 du catalogue Data Dragon4.20.1 fourni et du catalogue jouable courant ne prouve pas une indisponibilité historique. Il ne faut plus rechercher ces ressources comme manquantes.

Exécutés : identités, octets XML, lignes de configs/libellé, nouvelle recherche ciblée, fenêtres sources, références et cohérence documentaire. Non exécutés : ancien scan KeyT, anciennes analyses/lecteurs/tests, jeu/Rust/native/AS/GUI/réseau, émulation, touche physique et résultat de swap. Envoi d’une demande, présence d’une enum ou création d’un modèle ne sont pas un acquittement d’un swap réussi. Codes des programmes documentaires et empreintes conservés dans les reçus.

## 5. Manques et conditions de reprise

- TAGTEAM-ITEM-3288-LINK : ressources3288/TagTeamSwap trouvées et quatre tâches existantes reliées ;sémantique compilée et liaison effective au contrôle non qualifiées. Reprise sur ces fichiers précis et leurs handlers/outils qualifiés,avec les tâches existantes,aucune recherche générale d’assets manquants.
- TAGTEAM-AVAILABILITY : exposition/activation effective4.20 EUW, vecteur mutator et contexte autorisé inconnus. Reprise : source native/service/config datée ou trace de provider/callback, ou contrat de reconstruction locale explicitement accepté.
- TAGTEAM-SWAP-SEMANTICS : handler, identités admissibles, état conservé/réinitialisé, timing, autorité et présentation non qualifiés. Reprise : handler/xref/trace propre ou contrat explicite, sans remplacer par join/inventaire/transformation.
- TAGTEAM-INPUT-RUNTIME : décodage[t], priorité focus/session/mode, remap et UI actif/désactivé/refusé, résultat réel non exécutés. Reprise : contexte/provider/consumer qualifiés et scénario isolé autorisé ; aucun nouveau scan général inchangé.

## 6. Travail restant

Les cinq fondations BIND-LOAD/SAVE/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER-01 sont réutilisées dans leurs portées originales. Une fiche documentaire conditionnelle unique **BIND-TAGTEAM-SWAP-01** est proposée pour le seul adaptateur UI/input vers un consumer préalablement qualifié. Elle réutilise les travaux existants ;les tâches de l’objet3288 demeurent adjacentes tant que leur lien avec cet événement n’est pas établi. Elle ne duplique pas l’implémentation ni la validation de cet objet. Elle ne crée aucune tâche normative, n’implémente pas un mode et n’affirme pas sa disponibilité historique.

La fiche complète décrit sources, dépendances, travail, critères, contrôles et preuves. Fin : disponibilité et politique précises sourcées/contrat accepté ; un geste et remap atteignent une seule demande avec résultat autoritaire avant/après ; mauvais mode/mutator/session/owner/cible/capture suit le refus ou comportement qualifié sans mutation étrangère ; transition/échec ne laisse pas d’état partiel silencieux. Si mode/provider manquant, aucun faux succès. Reprise sous autorisation produit distincte, avec nouvelle entrée discriminante ou contrat explicite.

## 7. Livraison et suite

Preuve/rapport et reçus isolés sur F, relecture distincte des sept rubriques et liaison des résultats réels. Ancienne réconciliation conservée : l’identité XML81 était pending ; cette association peut se clore sans déclarer de fonctionnalité terminée. Corpus1168,25fichiers protégés,5registres et Git préexistants inchangés. Aucun goal/critère normatif/Plan/UI/base modifié, aucune installation/migration/redémarrage/loader de production.

Suite : checkbox General/BindSysKeys XML36 sous macosx ; les13conteneurs et l’expansion d’include restent ouverts. Le périmètre complet du goal demeure intact.
