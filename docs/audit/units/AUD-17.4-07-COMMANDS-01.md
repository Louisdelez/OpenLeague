# AUD-17.4-07-COMMANDS-01 — Registre statique et alias de commandes

2026-10-30 ; F:\OpenLeague ; parent SYS-01.2-02, tâche SYS-17.4-07, inconnue OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB, catalogue4.20.1.

## 1. Question, sortie et clôture

Question : quelles familles sont construites par l’initialisation0x857530, quels callbacks leur sont attachés et quelles valeurs lexicales peuvent fournir leurs alias ?

Le tour précédent est un **progrès** : AUD-17.4-07-CHAT-INTERRUPT-01 a identifié cette entrée et la frontière du répartiteur. Nouveau lot unique, arrêté au catalogue de ce constructeur et à ses lecteurs de langue. Sortie : chaîne d’initialisation, inventaire exhaustif de ses18descripteurs, callbacks distingués, conditions conservées, alias source dédoublonnés et consommateurs actuels inspectés.

**Audit terminé pour les inscriptions statiques du constructeur0x7A1510.** Cela ne constitue pas le catalogue global des commandes disponibles dans tous les modes et chemins. SYS-17.4-07 et le goal restent ouverts. Implémentation : aucun ajout ; mécanismes existants préservés. Vérification : statique seulement. Acceptation humaine : non demandée.

Prérequis réutilisés après contrôle d’identité des registres de tâches et lots : D17-SYS-17-4 requiert D09-SYS-09-4, encore recensé a_faire. Aucun achèvement de ce prérequis ni aucun changement de statut. Les sources nécessaires à cette lecture sont présentes.

## 2. Sources et méthode

PE original : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ;15973880octets ; SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**.

Lecteurs de données : DATA\menu\fontconfig_en_GB.txt et fontconfig_fr_FR.txt sous ce même déploiement. SHA-256 respectifs 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 et47429564a76830c2cb5a05f7cdad0c62e987532a71789347dccef8322f4d4562. Le profil de référence demeure en_GB ; fr_FR est une comparaison de ressources, sans changement de locale.

Réutilisés : F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-contract-proof.json (SHA b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906) et AUD-17.4-07-CHAT-INTERRUPT-01\interrupt-static-proof.json sous le même dossier audit-units (SHA f901b835c1f68aadeec817e8d57013f25e1094d0725160a5e29eabfd93fe3e17). Aucun nouvel export des films ni test ancien relancé.

Outils existants Python, pefile et Capstone, avec modules/DLL identifiés dans la preuve. Lecture directe du PE et des lignes physiques des locales. Onze fonctions sont décodées, dont le constructeur complet0x7A1510–0x7A2F68 :2463instructions au total. Aucun jeu, code natif, émulateur ou ActionScript exécuté. Aucun nouveau PE, installation ou nouvelle session REA ; les résultats antérieurs sont utilisés seulement pour leurs frontières déjà qualifiées.

## 3. Consommateurs et catalogue établi

Chaîne :0x857530 vérifie le singleton,0x85D620 alloue puis appelle0x7A1510 si l’allocation réussit. Le constructeur prépare16descripteurs sur son chemin normal ; equalize et noequalize sont derrière la garde0x7A2414, fondée sur le bit0 de [*[0x2D79104]+0x10]. La valeur et le sens historique de ce bit restent inconnus. Aucun mode ou droit n’est déduit de son seul emplacement.

Chaque descripteur contient un nom et deux champs de callback, offsets0x18 et0x1C. Les factories0x852090/140/1F0, le constructeur0x7A11F0, la copie0x7A3330, le clone0x856850 et l’invocation0x8568C0 établissent ces liens. Le chemin ChatInterrupt déjà audité utilise le champ0x1C. Le champ0x18 et les effets concrets de ses handlers ne deviennent pas validés par cet inventaire.

Alias ci-dessous : valeurs lexicales en_GB distinctes, sans préjuger leur inscription effective par le fournisseur de traduction en partie.

| Famille | Alias source en_GB | Callback0x18 | Callback0x1C |
|---|---|---|---|
| whisper | whisper,w,msg,tell,m | 0x7A35C0 | 0x7A11B0 |
| ignore | ignore,ig,mute,squelch | 0x7A3810 | 0x7A11B0 |
| reply | reply,r,rep | 0x7A11B0 | 0x7A39F0 |
| allchat | all,allchat | 0x7A3BE0 | 0x7A11B0 |
| surrender | surrender,forfeit,ff,concede | 0x7A3CB0 | 0x7A11B0 |
| nosurrender | nosurrender,noforfeit,noff,noconcede | 0x7A3DA0 | 0x7A11B0 |
| help | help,h,? | 0x7A4630 | 0x7A11B0 |
| pause | pause,p | 0x7A4060 | 0x7A11B0 |
| resume | resume,unpause | 0x7A4130 | 0x7A11B0 |
| dance | dance,d | 0x7A4200 | 0x7A11B0 |
| taunt | taunt,t | 0x7A4290 | 0x7A11B0 |
| laugh | laugh,l | 0x7A43B0 | 0x7A11B0 |
| joke | joke,j | 0x7A4320 | 0x7A11B0 |
| chatfilter | togglechatfilter,chatfilter | 0x7A4DB0 | 0x7A11B0 |
| note | note,n | 0x7A4440 | 0x7A11B0 |
| allcommands | allcommands,allcmds | 0x7A4AD0 | 0x7A11B0 |
| equalize, conditionnel | equalize,balance,eq | 0x7A3EA0 | 0x7A11B0 |
| noequalize, conditionnel | noequalize,nobalance,noeq | 0x7A3F60 | 0x7A11B0 |

Le callback commun0x7A11B0 libère l’argument possédé si nécessaire et retourne normalement1. Il est distinct du traitement spécialisé reply. Cela précise pourquoi l’événement de saisie ne valide pas l’exécution des autres actions.

Le constructeur parcourt les indices1à9 pour former game_console_chatcommand_<famille>_<indice>. Il appelle un fournisseur virtuel de traduction ; retour faux ou résultat égal à la clé conduit à ignorer l’entrée. Les insertions d’alias passent par la table owner+0x20. La présence de la ligne dans fontconfig ne prouve pas le retour effectif du fournisseur.

Chaque langue contient383entrées sous ce préfixe, dont162champs d’alias pour les18familles. Après dédoublonnage des valeurs par famille : en_GB49couples famille/alias (43sur les16familles normales), fr_FR79(69normaux). Aucune collision de valeur entre ces18familles dans chacun des deux fichiers. Ce sont des comptes lexicaux, pas un pourcentage ou un nombre de commandes opérationnelles.

La table de mots-clés owner+0x28 traite séparément all,team,enemy et leurs trois clés keyword_*_1 présentes. Ces mots-clés ne sont pas trois nouvelles familles de commandes. Quinze familles numériques figurent dans les textes sans descripteur dans ce constructeur : advshader,anim,announce,botcheat,cheat,crit,draw,enemychat,goldsources,location,loctest,repeatanim,stingervolume,teamchat,teleport. Leur disponibilité dans d’autres chemins reste indéterminée ; elles ne sont pas promues en commandes disponibles.

Consommateurs Rust : les six fichiers client/core des unités précédentes sont identiques. Un complément nommé a inspecté la pause : F:\OpenLeague\crates\client\src\ordinary_pause.rs:60–77 appelle send_pause_tracked ; session_connection.rs:150–160 émet PauseRequest sécurisé ou ancien ; F:\OpenLeague\crates\server\src\session_host.rs:136–139 et main.rs:116–122 appliquent allow_pause et le refus de partie finie. main.rs client branche ordinary_pause::Plugin ; une touche Pause et une interface existent. Cet acquis est préservé. Il ne prouve pas une liaison /pause ou /resume ni la politique historique de tournoi. Les autres mécaniques ne sont pas déclarées absentes sur leur seul nom.

## 4. Contrôles réellement exécutés

Scripts isolés sous F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMANDS-01, lancés avec le Python existant et les options -X utf8 -E -B : verify_catalogue.py puis verify_current_pause.py. Résultats : **code0 dans les deux cas ;166contrôles statiques/d’identité et6contrôles de câblage réussis**. Ce ne sont pas des tests de commandes jouables.

| Cas | Attendu | Observé et portée |
|---|---|---|
| Constructeur nominal | Relier noms, factories et deux callbacks | 18liaisons uniques, ordre et pointeurs conservés ; aucune interprétation d’effet fondée sur le nom |
| Condition native non satisfaite | Exclure les deux descripteurs concernés | Branche JE saute equalize/noequalize ; état historique du bit non observé |
| Alias nominal | Relier indices1à9 aux sources | 162clés par langue, valeurs et lignes identifiées ; fournisseur non exécuté |
| Traduction manquante ou clé inchangée | Ne pas déclarer l’alias ajouté | Branches de saut identifiées ; aucun test dynamique du fournisseur |
| Doublons de texte | Éviter de compter neuf commandes par famille | Valeurs dédoublonnées, collisions inter-familles recensées ; ordre effectif du runtime non qualifié |
| Texte sans descripteur | Ne pas inventer de disponibilité | 15familles explicitement classées hors de ce constructeur |
| Pause actuelle | Conserver le consommateur réel | Chaîne interface/touche→transport→serveur identifiée, refus locaux présents ; ni réseau ni syntaxe /pause testés |
| Conservation | Préserver le cadrage et le logiciel gelé | 19fichiers gelés, six contextes, registres, reçus et consommateurs contrôlés inchangés |

Non exécuté : tests Rust/Cargo, jeu, ActionScript, émulation, réseau, commandes saisies, rendu/capture, application de suivi, base de données, installation ou migration. Une lecture exploratoire trop large des locales avait une sortie terminal tronquée ; le catalogue est produit depuis les fichiers complets par sélecteurs délimités et n’utilise pas cette sortie comme preuve.

## 5. Écarts et inconnues

Résolu : inventaire statique de ce constructeur, garde conditionnelle, deux callbacks par famille, boucle d’alias, valeurs lexicales et exclusions. Consommateur de pause existant conservé.

Ouvert : valeur/mode du bit natif ; allocation et exceptions réelles ; fournisseur/ordre de montage de traduction ; registre final en mémoire ; autres chemins d’inscription ; effets, arguments et droits de chaque handler ; contrôles serveur, livraison et erreurs visibles ; liaisons de commandes dans Rust. Les mots-clés de paramètres et les noms de famille restent distincts.

Conditions de reprise : trace ou chaîne qualifiée pour le bit et le fournisseur ; recherche d’insertions supplémentaires dans la table nommée, avec bornes précises ; audit d’un handler identifié dans le tableau puis de son consommateur OpenLeague réel. Aucun inventaire de noms ne clôture une implémentation ni un droit serveur.

## 6. Corrections et petits lots suivants

Réutiliser SYS-17.4-07/K1,K2 et son inconnue existante ; aucun doublon dans le plan. Sous-lots documentaires proposés :

- K1-alias-runtime : qualifier le retour du fournisseur et l’inscription d’un alias nommé ; nominal, absence et clé inchangée, source/trace identifiée. Garder la généralisation aux autres alias ouverte jusqu’à preuve.
- K1-condition : qualifier la valeur et le rôle du bit des deux familles conditionnelles ; ne pas les activer par défaut dans Rust.
- K2-<famille> : un lot par chacune des18familles du catalogue, avec cible exacte dans le tableau. Lire les deux callbacks utiles et les consommateurs actuels ; établir arguments, droits, effet/refus et dépendances. Décrire ensuite la correction nécessaire. Terminer par nominal et refus au consommateur réel lorsqu’une implémentation distincte est autorisée ; aucun succès fictif pour commande non supportée.
- K2-pause/K2-resume : réutiliser le mécanisme client/serveur existant ; qualifier les handlers natifs avant d’ajouter une éventuelle syntaxe de chat. Préserver les refus du serveur et la corrélation des requêtes ; ne pas réécrire cette mécanique sur un constat d’absence du parseur.
- K1-autres-inscriptions : examiner les15familles de textes seulement si une référence d’insertion ou une condition nouvelle les relie à un consommateur. Pas de recherche répétée à partir de leur seule présence lexicale.

Chaque lot doit distinguer audit, implémentation, vérification et acceptation. Aucune correction fonctionnelle exécutée ici. Arrêt du présent lot après catalogue et comparaison aux consommateurs nommés.

## 7. Livraison, identités et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.4-07-COMMANDS-01.md. Autres fichiers nouveaux isolés dans F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMANDS-01 : les deux scripts et trois JSON suivants.

- commands-catalogue.json :219850octets ; SHA-256 **567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0**. Catalogue machine, sources, champs et limites.
- catalogue-proof.json :435119octets ; SHA-256 **4bc80b8964da042900b4ff8331054051e9276502a76d25c5212b22bf019e9a95** ; contrôle2026-10-30T14:44:41.381761+00:00. Producteur verify_catalogue.py :11901octets, SHA234bab627e4b0fed4ad7a776c9fc6af77ae485a7a8174fccaa2c1decdcb30c2b.
- current-pause-consumer-proof.json :14040octets ; SHA-256 **070776c25efde3d285ac8677eb6b40a88bf2303f588412615d87fe25a67fb406**. Sources et fragments du complément pause, producteur identifié.

Git observé avant écriture : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76modifications suivies préexistantes (-uno). Aucun add/commit/reset/checkout/clean. Les sources et preuves antérieures sont conservées. Goal, critères normatifs, application de suivi, registres, bases et fichiers gelés restent inchangés ; aucune base ouverte ni application relancée.

Relecture des sept rubriques : portée précise, provenance/identités, consommateur et catalogue réels, attendu/observé/non-exécuté, inconnues et reprises, corrections existantes atomisées, livrables et conservation. **Seul cet inventaire statique est clos ; aucune commande, le chat, le jeu ou le goal global n’est déclaré terminé.**