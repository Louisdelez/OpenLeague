# Score_Enabled — audit du texte de score

## R1 — Portée et décision

2026-10-31T18:23:03.346050+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-SCORE-01`, SYS-17.5-01 / SYS-01.2-02. Case 153, type natif, données et consommateurs de score existants. Le producteur ne clôture pas le lot ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Special précédent clos : 103 contrôles et 329 de relecture. Audit Public Scoreboard et éléments Floating communs réutilisés sans ancien lecteur/test rejoué.

Nœud `OPT-SRC-61ad91fcd72d1d39`, INI seul `[FloatingText]Score_Enabled`, libellé en_GB « Score » ligne 778. Regular par défaut, aucun updateonclick déclaré ; fournisseur effectif et définition injectée non observés. Deux fichiers par défaut portent Score=1 ligne 205, sans remplacement dans les fichiers utilisateur/deploy examinés.

Deux régions propres : inscription 0x7BCB0B–0x7BCB71 (fin exclue, 102 octets), callback complet 0x7BE5A0–0x7BE5B6 (22 octets). Clé 0x10BA654 à 0x7BCB0B, callback via 0x65C4C0 puis 0x82D410 avec littéraux 1/0. Classification/ordre/durée d’inscription non requalifiés ; 1 ne signifie pas un updateonclick déclaré.

Une conversion booléenne et unique écriture manager+0x3F : type Score15, jusqu’au ret4. Gold10 reste distinct. Table et six régions communes init/admission contrôlées inchangées ; init/callback même cache. Pour une entrée valide, 0 refuse Score15 et 1 laisse agir les autres gardes, sans définir son sens ni garantir des pixels. Anciennes observations de ressources datées et limitées conservées, sans recherche répétée de paquets/fichiers.

## R3 — Consommateurs réels et acquis

Les compteurs réels Score contiennent kills, morts, assistances et séries ; les mutations d’élimination existent, avec un événement typé conservant séquence/tick/tueur/assistants/récompense. Le Snapshot construit un roster avec Score et publie les événements. Le résultat final capture Score et or restant ; le résumé de fin de partie consomme réellement KDA et or restant. Cela ne qualifie pas toutes les règles de primes, supports/familiers ou statistiques, qui gardent leurs limites précédentes.

L’audit Public Scoreboard est réutilisé dans sa portée propre. Le champ de roster porte serde(default) : dans un ancien message sans Score, le défaut zéro ne signifie pas un vrai 0/0/0 observé. SCORE-LEGACY-AVAILABILITY-01 est conservée telle quelle. SCORE-FIELD-MODE-SCORE-01 traite déjà sa source de colonne ; elle peut être réutilisée si une même autorité applicable est démontrée, sans supposer que colonne et texte flottant sont équivalents. Aucune intégration complète du tableau natif n’est déclarée ici.

Le libellé Score ne prouve ni KDA, ni or, ni score particulier de mode. Il manque l’appel natif/local qui choisit Score15 et définit valeur ou delta, texte, carte/mode, sujet, temps et audience. Un compteur courant, son delta, un événement d’élimination ou un résultat final ne remplace pas ce contrat.

La recherche précise de préférence/popup Score est vide sur les 1 168 sources Rust/JS/HTML inchangées. Les données de score existent malgré ce résultat. Aucune absence globale de score ni besoin de nouveau tableau, système de points ou flux générique n’est déduit.

## R4 — Vérifications et attendu / observé

106 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, douze instructions attendues, retour/unique écriture/type15, Scoreboard et ses corrections réutilisées, vraies données/mutations/roster/consommateur final, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé structurés dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien lecteur/test/export, contrôle visuel ou de persistance rejoué. Ancienne recherche Floating générique réutilisée.

## R5 — Écarts et conditions de reprise

- SCORE-MEANING-EVENT-ADMISSION : identifier un producteur Score15 natif/local et sa signification, carte/mode, valeur/texte, identité/temps, sujet, audience et refus. Aucun alias KDA/or/points n’est inventé.
- SCORE-PROVIDER-PROFILE : qualifier configuration/définition/fournisseur effectifs, inscription/notification, profil/format/texte/police/horloge et vue commune.
- SCORE-CURRENT-FLOAT-VIEW : raccorder une entrée réellement admise aux composants communs, en réutilisant les données applicables. Les tâches existantes d’indisponibilité ancienne et de score de mode restent conservées, sans doublon.
- SCORE-RENDER-PERSISTENCE : vérifier entrée réelle/0/1/carte-mode, absence versus zéro, remise à zéro, états fusionnés, plusieurs événements, absence de tueur, arrivée/reconnexion, confidentialité/péremption, ordre/doublons/expiration/viewport/session et Annuler/défaut/Save/rechargement.

Chaque manque conserve impact et entrée de reprise précise. Les compteurs, colonnes, textes de résultat et flags ne deviennent pas des notifications Score démontrées.

## R6 — Correction proposée et suite

Une proposition documentaire, non appliquée : HUD-FLOATING-SCORE-SETTING-01. Définir une entrée Score15 applicable puis raccorder préférence/texte sur les composants communs ; réutiliser KDA/événements et tâches d’autorité/disponibilité seulement si suffisants. Menu/HUD local/Physical conservés. Pas de refonte globale du score, des colonnes ou de l’économie.

Prochain lot : Experience_Enabled, case 154. Identifier le callback/type et les vraies attributions d’XP, distincts du niveau et de la barre/total d’XP.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SCORE-01\floating-score-proof.json`, SHA-256 `28b1f01358192a95957560c932a644bd525b16b1e180d46870a7f5d9be18f5bd` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SCORE-01\verify_floating_score.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SCORE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
