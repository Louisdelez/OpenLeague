# AUD-17.4-07-PAUSE-RESUME-01 — Requêtes pause/reprise et raccordement local

Contrôle2026-10-30, projet F:\OpenLeague, goal parent SYS-01.2-02. Tâche réutilisée SYS-17.4-07 ; inconnue OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. Référence LoL4.20.0.315 PUBLIC/Releases/4.20, EUW/en_GB, catalogue4.20.1.

## 1. Question, critères et décision

Question : que font les callbacks pause/resume du catalogue natif, et quel raccordement précis manque au mécanisme actuel d’OpenLeague ?

Le tour précédent est un **progrès** : catalogue statique18familles, callbacks et alias établis, pause locale déjà identifiée. Le nouveau lot couvre le couple pause/reprise, les champs préparés par ses deux callbacks et les consommateurs Rust existants. Sortie : source exacte, distinction requête/directive, refus et écarts de raccordement documentés. Exclusions : implémentation du parseur de chat, transport historique complet, autorité du serveur Riot, exécution/rendu/réseau.

**Audit terminé pour ce déclenchement et ce raccordement.** Implémentation : mécanisme local présent, aucune commande ajoutée. Vérification : statique et identités seulement. Acceptation humaine : non demandée. La fonctionnalité complète de commandes et SYS-17.4-07 restent ouvertes ; le goal global reste actif et inchangé.

Prérequis : le registre de tâches et l’ordre des lots sont identiques aux entrées antérieures ; D17-SYS-17-4 requiert D09-SYS-09-4. Aucun prérequis d’implémentation n’est déclaré acquis par cet audit. Les sources nécessaires à la question sont disponibles.

## 2. Sources et preuves réutilisées

PE original : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ;15973880octets ; SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**.

F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMANDS-01\commands-catalogue.json est réutilisé avec son SHA567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0. Il lie pause au callback0x7A4060 et resume à0x7A4130 dans le champ0x18. Le champ0x1C est le callback commun de nettoyage/retour1, distinct du déclenchement d’action.

Les deux locales natives du même déploiement sont relues contre leurs identités du catalogue. Leurs clés sont précisément game_console_chatcommand_pause_sent et game_console_chatcommand_resume_sent, présentes une fois par langue. en_GB fournit « Sending a pause request... » et « Sending a resume request... » ; fr_FR fournit les messages d’envoi correspondants. Source lexicale et usage de la clé ne prouvent pas un rendu actuel ni la sélection effective du fournisseur.

Héritage conservé : F:\OpenLeague\docs\native_pause_incoming_progress.json, native_pause_budget_progress.json, native_game_clock_pause_progress.json, server_pause_progress.json et server_pause_udp_v1.json. Leurs identités et contenu sont recensés dans la preuve. Ces cinq résumés n’ont pas de date interne d’exécution ; aucune date de test ne leur est inventée. Leurs passed=true et ancien SHA de serveur b81a1d08d529149b34fcdc18f82128021db2e273f1618c24dc63f8926017916c restent des affirmations historiques, sans qualification du runtime actuel. Ils ne sont pas réexécutés.

F:\OpenLeague\data\4.20\game_clock_pause_incoming_contract.json est réutilisé : son native_sha256 correspond au PE relu. Ses séquences et les anciennes preuves de budget/horloge ne sont pas des preuves de permission serveur originale.

Outils : Python, pefile et Capstone déjà installés ; producteurs, versions, modules et DLL identifiés. Aucun téléchargement, installation, nouveau PE ou session REA. Lecture directe de119instructions originales,60pour pause et59pour resume. Les bornes incluent les deux sorties de nettoyage de chaque fonction.

## 3. Contrat natif et consommateurs actuels

### Préparation de requêtes sortantes

Pause0x7A4060–0x7A412B et resume0x7A4130–0x7A41F4, fins exclues : les callbacks demandent leur texte de statut via0x78D0D0 puis0x7A7890 **avant** l’appel de transport. Ensuite, le récepteur est lu depuis0x2D787B8 et la méthode vtable+0x30 est appelée avec longueur,tampon,1,0.

| Champ relatif au tampon | Requête pause | Requête reprise |
|---|---|---|
| Taille poussée |14octets|10octets|
| Octet0 |0xA1|0x0A|
| Octets1–4 |Dword lu à0x2D62CBC|Même source globale|
| Octets5–8 |Zéro|Zéro|
| Octets9–12 |Zéro|Hors de ce tampon|
| Dernier octet |Bit0 mis à0 par AND0xFE à l’offset13|Bit0 mis à0 par AND0xFE à l’offset9|

L’identité sémantique du global0x2D62CBC n’est pas qualifiée ici. Les sept autres bits du dernier octet ne sont pas explicitement initialisés par ces stores ; la preuve conserve un masque de bits connus, sans inventer un tampon entier déterministe.

Le code retourne normalement AL=1 après l’appel et le nettoyage de la chaîne possédée. Le résultat de l’appel de transport ne devient pas un accusé d’acceptation vérifié. Aucun contrôle d’argument ou d’autorisation n’est identifié dans ces deux corps avant l’appel ; les helpers et le serveur peuvent imposer d’autres règles. Aucun essai avec argument invalide n’a été exécuté.

### Direction et portée des messages

Les anciens contrats **entrants** traitent aussi A1/0A, mais décrivent des directives reçues : temps restant, marqueur, reprise différée et notifications. Les tailles/opcodes communs ne rendent pas leur rôle identique aux requêtes de ces callbacks. Les zéros du tampon sortant ne prouvent ni budget autorisé, ni arrêt immédiat, ni reprise sans délai décidée par le serveur.

Le protocole local Rust transporte au contraire une intention typée PauseRequest{paused}. Le serveur produit ensuite des messages ClockControl avec les champs de son adaptateur. F:\OpenLeague\crates\server\src\pause.rs:10–13 précise que son préfixe zéro est du stockage local et que le framing natif n’est pas reconstruit. Les requêtes historiques ne doivent pas être confondues avec ces messages serveur→client.

### Mécanisme actuel conservé

- F:\OpenLeague\crates\client\src\session_connection.rs:150–161 possède send_pause_tracked(paused:bool), refuse un bootstrap non prêt et émet l’enveloppe sécurisée ou l’ancienne requête locale avec séquence.
- F:\OpenLeague\crates\client\src\ordinary_pause.rs:60–77 choisit une **bascule** selon l’état observé : Running→true,Paused→false. Cet usage du bouton reste conservé. L’affichage suit les ordinals d’horloge reçus ; une requête envoyée ne transforme pas immédiatement l’état affiché en pause acceptée.
- F:\OpenLeague\crates\server\src\session_host.rs:136–139 et main.rs:116–122 refusent la pause désactivée par l’hôte et la partie déjà finie. Le mode serveur local et les permissions Riot historiques ne sont pas assimilés.
- F:\OpenLeague\crates\server\src\pause.rs:19–38 distingue pause/reprise, budget, reprise déjà programmée et fin effective. Le délai de reprise courant est5secondes ; le budget initial courant est1800secondes. Ces règles locales et les valeurs natives de constructeur héritées ne prouvent pas des overrides ou droits effectifs historiques.
- F:\OpenLeague\crates\server\src\clock_delivery.rs conserve les messages ordonnés ; les schémas core/session_transport portent les intentions et réponses locales. Leur cycle complet n’est pas réaudité ici.

Le raccordement proposé est donc explicite : **/pause→send_pause_tracked(true)** ; **/resume→send_pause_tracked(false)**. Il faut préserver pending, corrélation et refus, tout en conservant le bouton à bascule. Cette proposition est documentaire ; aucun parseur ni système d’entrée n’est modifié.

## 4. Attendu/observé et contrôles exécutés

Commande : Python existant avec -X utf8 -E -B sur F:\OpenLeague-work\audit-units\AUD-17.4-07-PAUSE-RESUME-01\verify_pause_resume_contract.py. Résultat au2026-10-30T14:57:28.995248+00:00 : **code0 ;83contrôles statiques/d’identité réussis ; aucun échec**.

| Cas | Attendu | Observé et limite |
|---|---|---|
| Liaison du catalogue | Les deux callbacks correspondent aux noms | Champ0x18 vers0x7A4060/0x7A4130 ; identité du catalogue inchangée |
| Déclenchement nominal | Préparation et frontière d’envoi précises | Op,tailles,stores et appel indirect identifiés ; aucune livraison exécutée |
| Statut d’envoi | Ne pas qualifier une acceptation | Clé « request » demandée avant transport ; résultat de réception absent |
| Bits et identité inconnus | Conserver les inconnues | Global non renommé et sept bits du dernier octet non inventés |
| Pause répétée et budget | Conserver les refus existants | Source serveur contient match is already paused et pause budget exhausted ; aucun test serveur lancé |
| Reprise hors pause ou déjà programmée | Conserver les refus existants | Source contient match is not paused et resume already scheduled |
| Hôte/bootstrap/fin de partie | Respecter les portes actuelles | Gardes identifiées client et serveur ; autorisation historique non qualifiée |
| Requête/affichage | Conserver la séparation intention/état reçu | Booléen typé et mode observé identifiés ; aucun test d’horloge/rendu |
| Preuves antérieures | Éviter une nouvelle exécution inchangée | Résumés/contrat relus, références identifiées, limites historiques explicites |
| Conservation | Préserver le logiciel gelé et le cadrage |19fichiers gelés, six contextes et registres contrôlés inchangés|

Non exécuté : jeu original/local, code natif isolé, ActionScript, tests Rust/Cargo, UDP, deux clients, simulation temporelle, rendu/captures et acceptation humaine. Le tableau décrit des branches et du câblage lus, pas des refus observés en partie.

## 5. Résolu, limites et reprise

Résolu : producteurs de requêtes natifs retrouvés ; champs sortants et statut d’envoi distingués des directives entrantes ; mécanisme local préservé ; différence bascule/intention explicite établie ; correction de raccordement précisément définie.

Restent ouverts : implémentation du chat et du parseur ; sélection effective d’alias ; erreurs présentées à l’utilisateur ; arguments historiques ; classe/transport et framing natifs complets ; identité du global et bits non définis ; permissions serveur/mode/joueur et overrides de configuration ; parcours réseau/rendu actuel. La présence d’un résumé historique ne résout pas ces clauses.

Entrées de reprise : contrat de parseur/alias qualifié pour les commandes ; consommateur final des réponses/erreurs de chat ; observation ou chaîne native précise du transport si sa fidélité est recherchée ; règles serveur originales identifiées ou politique locale explicitement nommée. La mention ancienne « UI/chat not yet wired » reste intacte dans son reçu : la partie UI a depuis un consommateur actuel identifié ; la liaison chat reste ouverte. Aucune limite ancienne n’est automatiquement présentée comme l’état courant.

## 6. Corrections atomiques réutilisées

Sous-lots documentaires de SYS-17.4-07/K2, sans changement du plan :

| Sous-lot | Travail et consommateurs | Critères de fin proposés |
|---|---|---|
| K2-pause | Relier l’alias qualifié à l’intention true via le transport existant | En marche : une seule intention true et séquence correcte ; déjà en pause : refus conservé, aucune reprise involontaire ; aucun état accepté annoncé avant réponse |
| K2-resume | Relier resume/unpause qualifié à false | En pause : une seule intention false ; hors pause et reprise déjà programmée : erreurs distinctes ; affichage attend la directive finale |
| K2-pause-feedback | Relier l’issue au consommateur de chat/retour utilisateur | Hôte désactivé,partie finie,bootstrap indisponible,budget épuisé,timeout et rejet corrélés clairement ; intention envoyée séparée du succès |
| K2-pause-session | Préserver les gardes d’identité,pending et séquence | Événement répété,changement de session et réponse ancienne ne provoquent ni double demande ni fausse transition ; mécanisme du bouton conservé |

Les critères sont propres aux corrections futures, pas une modification du goal ou des critères normatifs. Leur exécution requiert une tâche fonctionnelle autorisée séparément. Aucun nouveau service de pause n’est justifié par l’absence actuelle d’une commande textuelle. Pas de réécriture, migration ou test inchangé lancé dans ce lot.

## 7. Livraison et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.4-07-PAUSE-RESUME-01.md.

Nouveaux fichiers isolés sous F:\OpenLeague-work\audit-units\AUD-17.4-07-PAUSE-RESUME-01 :

- verify_pause_resume_contract.py :11008octets ; SHA-256 ad1eef42acd90a03bc8d73577b90e5c2ddb569f2232a81bb72cfc6dfeecb0611.
- pause-resume-proof.json :85753octets ; SHA-256 **ae939401c1427d1f0a49a1a412fb5a3d5674c63610d33da28fcad149e24b2984**. Contient sources,119instructions,masques de champs,clés de langue,résumés hérités,fragments Rust et contrôles.

Git avant écriture : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76modifications suivies préexistantes (-uno). Aucun add/commit/reset/checkout/clean. Les anciens fichiers et reçus sont conservés. Les19fichiers gelés et les six fichiers de cadrage/contexte restent identiques. Goal,critères normatifs,application de suivi,registres et bases inchangés ; aucune base ouverte ni application relancée.

Les sept rubriques sont relues : périmètre/critères limités,sources et identités,consommateurs réels,attendu/observé/non-exécuté,écarts/reprise,corrections atomiques existantes,livrables/conservation. La clôture de cette unité ne termine ni les commandes,ni la fidélité complète de pause,ni le jeu,ni le goal global.