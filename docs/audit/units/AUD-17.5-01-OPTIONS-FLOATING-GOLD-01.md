# Gold_Enabled — audit de la préférence et des gains d’or

## R1 — Portée et décision

2026-10-31T17:22:58.874883+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-GOLD-01`, SYS-17.5-01, goal SYS-01.2-02.

Ce lot couvre la case 144, son type natif Gold et les sources actuelles de gains. Il distingue événement de récompense, portefeuille, transactions, affichage du total et texte flottant. Le producteur ne clôture pas le lot : une relecture séparée vérifie les sept rubriques. La fonctionnalité, le parent et le goal restent ouverts.

## R2 — Sources et provenance

Exécutable original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML, GFX, export AS antérieur, traductions, configurations et outils existants sont identifiés par empreinte dans la preuve. Aucun export ni exécutable historique n’a été lancé.

Le nœud `OPT-SRC-3d42ef3bf8a80179` porte uniquement `[FloatingText]Gold_Enabled`. La stratégie AS par défaut est regular ; aucun updateonclick n’est déclaré. Cela ne qualifie pas une éventuelle définition injectée ni le fournisseur effectif. Les deux fichiers de valeurs par défaut portent 1 à la ligne 197. Aucun remplacement Gold n’a été trouvé dans les fichiers utilisateur/deploy examinés. Le libellé en_GB « Gold » est à la ligne 754. Le fichier candidat F Config/Game.cfg est absent ; cela ne démontre pas l’absence d’une configuration effective.

Deux régions nouvelles seulement : inscription 0x7BC379–0x7BC4FC (fin exclue, 387 octets), callback complet 0x7BE4E0–0x7BE4F6 (22 octets). La clé à 0x10BA550 est passée à l’inscription à 0x7BC37B, qui utilise 0x7BE4E0. Le callback appelle le convertisseur booléen partagé 0x6F5930 et écrit uniquement manager+0x3A.

La table de 29 types, les six régions d’initialisation/admission, l’adaptateur et les alias de pile sont réutilisés avec contrôle des octets, sans nouvelle analyse intégrale. Gold est le type 10 : 0x30 + 10 = 0x3A. Pour une entrée valide, 0 refuse ce type ; 1 laisse agir les autres gardes acteur/mode/profil. Un bit actif ne garantit pas un texte visible. L’inscription dans le premier conteneur avec valeur 1 n’est pas requalifiée en mode live/mode 2.

Le candidat de ressource ancien et ses inconnues de profil/police/horloge restent datés dans la preuve commune ; aucune recherche de paquet ou de fichier manquant n’a été répétée.

## R3 — Consommateurs réels et acquis

`champion_kills.rs` crédite réellement le tueur et les assistants. Son événement sérialisé conserve séquence, tick, victime, tueur, assistants, premier sang et killer_gold. Le Snapshot publie cet historique borné à 128 événements. killer_gold est une donnée de récompense réelle réutilisable, sous réserve de qualifier son destinataire et son admission ; elle ne fournit pas le montant des assistants ni toutes les raisons de gain. Les limites déjà déclarées sur séries, supports, familiers et primes sont conservées.

`passive_gold.rs` est réellement invoqué par la simulation. Les bornes globales sont une reconstruction locale, sans rattrapage historique à la connexion ; règles de mort et modificateurs gardent leurs limites. `world.rs` contient les gains d’unités, d’autels et d’équipe. L’audit Shop existant fournit les gardes et mutations d’achat/vente ; il ne démontre pas de popup.

`native_hud_widgets.rs` choisit le joueur demandé, refuse les valeurs invalides et affiche GoldStat comme total arrondi vers le bas. Ce total ne définit ni le montant ni le format d’un gain flottant. Plusieurs gains, dépenses ou remboursements peuvent se compenser : le delta du portefeuille n’est pas un événement Gold fiable.

Le corpus inchangé de 1 168 sources est identifié. La recherche nouvelle et limitée `Gold_Enabled|gold_enabled|gold_popup|floating_gold` n’a aucun résultat. La recherche générique antérieure est réutilisée. Cela établit l’absence d’un consommateur nommé dans ce périmètre, pas l’absence de données économiques, ni la nécessité d’un nouveau flux réseau générique.

## R4 — Vérifications et attendu / observé

109 contrôles du producteur, tous réussis. Vérifiés : empreintes des sources et preuves réutilisées, appartenance du corpus, XML et valeurs, douze instructions attendues, décodage aligné des deux régions, unique écriture 0x3A, table et régions communes, producteurs économiques et vues actuelles, invariance Git et fichiers protégés. Les cas détaillés sont dans expected_observed_cases.

Deux reçus réseau économiques du 4 octobre sont conservés avec passed=true et complete=false, dates, empreintes du serveur historique et limites. Ils n’ont pas été rejoués et ne qualifient ni le binaire actuel ni Gold_Enabled. Aucun original, Rust, jeu, GUI, entrée système, réseau ou émulation n’a été exécuté. Aucun test visuel ou de persistance n’est revendiqué.

## R5 — Écarts et conditions de reprise

- GOLD-EVENT-ADMISSION : qualifier une entrée Gold10 avec montant réellement crédité, raison, sujet, destinataire, audience et temps. Reprendre avec un appel natif nommé ou une projection actuelle explicitement admise ; traiter ensuite chaque autre raison applicable. Le montant des assistants ne doit pas être inventé côté client.
- GOLD-CFG-PROFILE-PROVIDER : identifier la définition/configuration effective et le profil, format, police, horloge, propriétaire de la vue. Reprendre sur un fournisseur et un consommateur précis ; ne pas recréer une ressource depuis l’ancienne absence d’un fichier candidat.
- GOLD-CURRENT-FLOAT-VIEW : les données et mutations existent, mais le raccordement Gold10 et sa vue flottante restent non identifiés. Reprendre avec une entrée autorisée et la vue commune ; aucun nouveau moteur économique n’est justifié par ce constat.
- GOLD-RENDER-SETTINGS-LIFECYCLE : vérifier réellement 0/1, récompense, zéro, absence de tueur, assistants, passif, remboursement, variations compensées, confidentialité, ordre, déduplication, historique, expiration, session et viewport. Annuler/défaut/Save/rechargement restent des contrôles distincts.

Chaque manque conserve son impact et son entrée de reprise structurée dans la preuve. Ces manques fonctionnels ne deviennent pas des réussites par la clôture documentaire.

## R6 — Correction proposée et prochain lot

Une seule proposition, non appliquée : HUD-FLOATING-GOLD-SETTING-01, raccordement Gold10 et gains admis sur les composants de texte flottant communs. Menu, HUD local, économie et Shop sont réutilisés. Commencer par une récompense réelle dont la source est suffisante ; garder suivies les autres raisons applicables, sans déclarer Gold complet depuis une seule élimination. Aucun registre normatif n’a été changé.

Prochain lot borné : Invulnerable_Enabled, case 145. Réutiliser les mêmes éléments communs, puis identifier son propre callback/type et ses états ou refus actuels. Aucun texte ne doit être inféré d’une santé inchangée.

## R7 — Livraison et relecture

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-GOLD-01\floating-gold-proof.json`, SHA-256 `0540b8a34bb21c088bd2952b4885b76434912a416b787e4686850aa316c97989`. Producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-GOLD-01\verify_floating_gold.py`. Fiche : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-GOLD-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers d’audit isolés sont créés. Goal et critères, code et assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
