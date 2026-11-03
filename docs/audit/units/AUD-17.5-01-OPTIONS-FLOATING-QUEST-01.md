# QuestReceived_Enabled — audit de la case Quest

## R1 — Portée et décision

2026-10-31T17:39:30.157017+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-QUEST-01`, SYS-17.5-01 / SYS-01.2-02. Case 146, catégories commandées et sources actuelles utiles à une notification de quête. Le producteur ne clôture pas ce lot : relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte dans la preuve. L’audit Status précédent est clos (115 contrôles, relecture v2 370) ; son échec initial de borne et son erratum restent conservés.

Nœud `OPT-SRC-84d7eff41f7b5781`, INI seul `[FloatingText]QuestReceived_Enabled`, libellé en_GB « Quest » ligne 775. Stratégie regular par défaut, sans updateonclick déclaré ; définition injectée/fournisseur effectif indéterminés. Deux fichiers de valeurs par défaut : QuestReceived=1 ligne 204 et QuestComplete=1 ligne 203. Aucun remplacement de ces clés dans les fichiers utilisateur/deploy examinés ; un candidat F Config/Game.cfg absent ne prouve pas l’absence de configuration effective.

Deux régions propres seulement : inscription 0x7BC6E9–0x7BC86C (fin exclue, 387 octets), callback complet 0x7BE570–0x7BE591 (33 octets). Clé à 0x10BA610, inscription à 0x7BC6EB vers 0x7BE570. Deux conversions du même argument écrivent exactement manager+0x3E (QuestComplete, type 14) puis +0x3D (QuestReceived, type 13), jusqu’au retour ret4. La case commande donc les deux catégories.

Table29, six régions d’initialisation/admission, adaptateur et convertisseur booléen communs réutilisés avec contrôle des octets. Les clés individuelles initialisent leurs caches séparément ; ordre et valeurs contradictoires restent ouverts. Pour un type valide, 0 refuse l’entrée et 1 laisse agir les autres gardes, sans garantir un texte. Le premier conteneur/record1 n’est pas requalifié en mode live2. Les anciennes observations de ressources gardent leur date et leur portée ; aucune recherche de paquet/fichier manquant répétée.

## R3 — Consommateurs réels et acquis

Le Snapshot réel contient session, tick, acteurs, événements typés et état Map10. MapState conserve notamment cristal du Nexus, autels, révélations et relique avec disponibilité/dernier ramasseur/tick. Ces acquis ne sont pas des événements QuestReceived/QuestComplete sans producteur et contrat correspondant.

L’énumération Incoming reçoit état, horloge, admission et refus. Le rapporteur réel stocke une raison et la journalise ; GameplayRejected conserve contexte/séquence/raison. Un refus générique n’est pas une notification de quête, et le chemin de réception d’état ne qualifie pas son affichage flottant.

Le corpus courant de 1 168 sources Rust/JS/HTML est identifié et inchangé. Les requêtes exactes de préférence/popup et sémantiques avec limites de mots n’identifient aucun producteur ou consommateur Quest nommé. Le premier essai par sous-chaînes quest/mission capturait request/admission : il est écarté des conclusions et remplacé par une requête délimitée. L’ancienne recherche FloatingText générique est réutilisée. Ce constat ne s’étend pas à tout objectif du jeu, aux Lua/assets/AIR ni à tous les langages.

## R4 — Vérifications et attendu / observé

103 contrôles du producteur réussis : identités des preuves/sources, corpus, XML, valeurs/libellé, décodage aligné, quatorze instructions attendues, retour complet, deux écritures et table correspondante, fragments réels de données/messages, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export ni test visuel ou de persistance rejoué. Présence de code ou cache n’est pas réussite fonctionnelle.

## R5 — Écarts et conditions de reprise

- QUEST-EVENT-MODE-ADMISSION : identifier un producteur natif/local applicable à une carte et un mode nommés, avec identité d’événement/quête, transition réception/achèvement, sujet, audience, raison, temps et texte. La présence de la case ne prouve pas une mécanique de quête active en Map10.
- QUEST-GROUP-INIT-PROVIDER : qualifier fournisseur/définition/configuration effectifs, priorité init individuelle/callback groupé, profils, textes, police et horloge. Les deux défauts à 1 ne résolvent pas les conflits possibles.
- QUEST-CURRENT-FLOAT-VIEW : raccorder une entrée admise à la vue commune et son propriétaire. Aucun nouveau système de missions, moteur de texte ou flux générique n’est justifié par la seule recherche vide.
- QUEST-RENDER-PERSISTENCE : vérifier les deux catégories, absence d’événement, mode inconnu, données invalides/privées/périmées, ordre/doublons/reconnexion/session/viewport/expiration, puis 0/1/autres types et Annuler/défaut/Save/rechargement.

Chaque manque conserve son impact et une entrée de reprise précise. Les autres objectifs/états de carte existants ne sont ni effacés ni renommés en quêtes.

## R6 — Correction proposée et suite

Une proposition documentaire, non appliquée : HUD-FLOATING-QUEST-SETTING-01. Elle qualifie d’abord l’usage carte/mode, puis raccorde les notifications admises des types 13/14 aux composants flottants communs. Menu et HUD local sont réutilisés. Une première catégorie qualifiée ne clôture pas la seconde. Aucun backend de missions ou catalogue global n’est imposé par cet audit.

Prochain lot borné : ManaDamage_Enabled, case 147. Identifier callback/type et sources actuelles de perte ou dépense de ressource, distinctes du total et de la récupération.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-QUEST-01\floating-quest-proof.json`, SHA-256 `ac807c3a17cce0a6ac7a2873061ef54b6b58d88c27bbd8c5e3b3c64016dc5396` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-QUEST-01\verify_floating_quest.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-QUEST-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
