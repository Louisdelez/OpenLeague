# Level_Enabled — audit de la notification de niveau

## R1 — Portée et décision

2026-10-31T18:07:51.495403+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-LEVEL-01`, SYS-17.5-01 / SYS-01.2-02. Case 151, type natif et vrais changements/compteurs actuels. Le producteur ne clôture pas le lot ; une relecture séparée est attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Dodge précédent clos : 107 contrôles et 363 de relecture. Local Pools et éléments Floating communs réutilisés avec leurs limites, sans rejeu des anciens tests.

Nœud `OPT-SRC-a058b3b6c687586a`, INI seul `[FloatingText]Level_Enabled`, libellé en_GB « Level » ligne 758. Regular par défaut, aucun updateonclick déclaré ; définition injectée/fournisseur effectif non observés. Les deux fichiers par défaut portent Level=1 ligne 198, sans remplacement dans les fichiers utilisateur/deploy examinés.

Deux régions propres : inscription 0x7BCA1D–0x7BCA83 (fin exclue, 102 octets), callback complet 0x7BE500–0x7BE516 (22 octets). Clé 0x10BA68C passée à 0x7BCA1D ; callback via 0x65C4C0 puis 0x82D410 avec littéraux 1/0. Classification/ordre/durée d’inscription non requalifiés ; 1 ne signifie pas un updateonclick déclaré.

Le callback appelle le convertisseur booléen commun et écrit uniquement manager+0x3B : type Level11, jusqu’au retour ret4. Experience9/cache39 reste séparé. Table et six régions communes init/admission contrôlées inchangées ; init et callback Level visent le même cache. Pour une entrée valide, 0 refuse Level11 et 1 laisse agir les autres gardes, sans garantir événement ou pixels. Anciennes observations de ressources conservées avec date et portée, sans recherche répétée de paquets/fichiers.

## R3 — Consommateurs réels et acquis

L’API actuelle award_experience refuse les montants non finis/non positifs et le joueur inconnu, ajoute réellement l’XP puis franchit les seuils dans une boucle plafonnée au niveau 18. Un gain peut franchir plusieurs niveaux. La croissance ajuste la capacité de santé ; les ajouts à la santé courante et à la ressource sont conditionnés au joueur vivant. Elle renvoie Result<(),String>, sans événement de transition sérialisé dans cette fonction.

LevelStat affiche déjà le niveau courant. La barre d’XP utilise expérience et courbe faisant autorité, refuse des valeurs invalides et affiche le niveau 18 plein. DTO/Snapshot et réception sont présents. Ces acquis ne sont pas des notifications de passage de niveau. Un gain d’XP peut ne pas changer le niveau ; un snapshot initial, une reconnexion, un retour à la visibilité ou des états intermédiaires omis ne définissent pas tous les passages individuels.

L’audit ne qualifie pas toutes les sources d’attribution d’XP, la parité native de la progression ni tous les rangs de sorts. Ces règles restent leurs propres périmètres. La préférence de texte ne doit pas modifier progression, statistiques, compteur de niveau ou barre d’XP.

Requêtes précises de préférence/popup et de noms level_up/levelup vides sur les 1 168 sources Rust/JS/HTML inchangées. Les mutations réelles sont néanmoins présentes : l’absence de ces noms ne signifie pas absence de progression. Recherche Floating générique et ancien constat de ressource réutilisés ; aucun nouveau flux ou moteur d’XP n’est déduit.

## R4 — Vérifications et attendu / observé

109 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, douze instructions attendues, retour/unique écriture/type11, progression réelle/seuils/capacité/conditions, LevelStat/XP et courbe, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé structurés dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export, contrôle de rendu ou de persistance rejoué.

## R5 — Écarts et conditions de reprise

- LEVEL-TRANSITION-ADMISSION : nommer un producteur Level11 natif/local avec niveaux avant/après, sujet, identité/temps, audience et texte. Qualifier passages simples/multiples, absence de changement, maximum 18, mort et arrivée tardive. Les compteurs ne suffisent pas.
- LEVEL-PROVIDER-PROFILE : identifier configuration/définition/fournisseur effectifs, inscription/notification, texte/profil/police/horloge et vue commune. Défaut 1 et cache3B ne prouvent pas format, choix courant ou durabilité.
- LEVEL-CURRENT-FLOAT-VIEW : raccorder une vraie transition admise à la vue commune, en conservant les producteurs et compteurs actuels. Aucun nouveau moteur d’XP, renderer ou refonte de tous les rangs n’est requis.
- LEVEL-RENDER-PERSISTENCE : vérifier transitions simples/multiples, aucun changement, max18, entrées invalides, joueur inconnu/mort, arrivée/reconnexion/visibilité, confidentialité, ordre/doublons/expiration/viewport/session, 0/1 et Annuler/défaut/Save/rechargement.

Chaque manque conserve impact et entrée de reprise précise. Experience9 et gain d’XP restent distincts de Level11.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-LEVEL-SETTING-01. Elle utilise la vraie progression et les composants Floating communs pour une transition admise. Menu/HUD local/Physical conservés. Pas de notification fabriquée depuis le premier niveau observé ou un simple gain d’XP ; pas de second moteur de progression/texte.

Prochain lot : Special_Enabled, case 152. Identifier callback/type et producteur/consommateur utile sans inventer des événements spéciaux depuis le libellé.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-LEVEL-01\floating-level-proof.json`, SHA-256 `da2c32c4fbfc14c0a31dc0aa927cb94fa6d11fb0db8864df8c2d1dc357c18d2d` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-LEVEL-01\verify_floating_level.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-LEVEL-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
