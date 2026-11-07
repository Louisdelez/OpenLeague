# Special_Enabled — audit de la catégorie Special

## R1 — Portée et décision

2026-10-31T18:14:34.623667+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-SPECIAL-01`, SYS-17.5-01 / SYS-01.2-02. Case 152, type natif et données/consommateurs actuels utiles à une entrée spéciale. Le producteur ne clôture pas le lot ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Level précédent clos : 109 contrôles et 343 de relecture. Table/init/admission et composants Floating communs réutilisés avec leurs limites, sans ancien test rejoué.

Nœud `OPT-SRC-c0155ff4f9a96ae9`, INI seul `[FloatingText]Special_Enabled`, libellé en_GB « Special » ligne 793. Regular par défaut, sans updateonclick déclaré ; définition injectée/fournisseur effectif non observés. Les deux fichiers par défaut portent Special=1 ligne 202 ; aucun remplacement dans les fichiers utilisateur/deploy examinés.

Deux régions propres : inscription 0x7BCA94–0x7BCAFA (fin exclue, 102 octets), callback complet 0x7BE550–0x7BE566 (22 octets). Clé 0x10BA634 à 0x7BCA94, callback via 0x65C4C0 puis 0x82D410 avec littéraux 1/0. Classification interne, ordre et durée d’inscription non requalifiés ; 1 ne prouve pas un updateonclick déclaré.

Le callback appelle le convertisseur booléen commun et écrit uniquement manager+0x31 : type Special1, jusqu’au retour ret4. Table et six régions communes d’init/admission contrôlées inchangées, init/callback même cache. Pour une entrée valide, 0 refuse Special1 et 1 laisse agir les autres gardes, sans définir le sens des événements ni garantir des pixels. Anciennes observations de ressources datées et limitées conservées ; aucune recherche de paquet/fichier répétée.

## R3 — Consommateurs réels et acquis

Snapshot et réception contiennent de vrais états et faits typés. Incoming et le rapporteur de session gèrent état, horloge, admission/refus et stockent/journalisent les raisons. Ces contrats ne définissent pas la catégorie Floating Special.

Les candidats examinés existent : fonctions de champs/visibilité/alpha des paquets HUD Effect, et arrêt d’un propriétaire de huit références faibles d’effets. Leurs modules sont déclarés dans le client. Le premier indique explicitement allocation/pont GPU en attente ; le second sépare création/appelant/mise à jour du manager. Cette présence de fonctions/modules ne démontre pas une intégration de rendu ni une entrée Special. Le mode 1 d’un paquet, son kind 2 et le bit d’arrêt 0x400 sont des domaines distincts du type Floating Special1.

La recherche précise de préférence/popup/texte Special est vide sur les 1 168 sources Rust/JS/HTML inchangées. Aucun producteur ou consommateur Special1 nommé n’est identifié dans ce périmètre. Cela ne démontre pas l’absence de tous les effets, états, sorts spéciaux, données Lua/assets/AIR ou autres langages. Aucun catalogue de messages/buffs ni exemple arbitraire n’est inventé depuis le libellé.

## R4 — Vérifications et attendu / observé

103 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, douze instructions attendues, retour/unique écriture/type1, vrais états/messages et candidats de fonctions/modules, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export, contrôle visuel ou de persistance rejoué. Ancienne recherche Floating générique réutilisée.

## R5 — Écarts et conditions de reprise

- SPECIAL-ENTRY-SEMANTICS : identifier un producteur Special1 natif/local avec sens concret, contenu/texte, sujet/source, identité/temps, audience, mode et refus. La case et le nom de type ne fournissent pas cette taxonomie.
- SPECIAL-PROVIDER-PROFILE : qualifier configuration/définition/fournisseur effectifs, inscription/notification, texte localisé/profil/police/horloge et vue commune. Les fonctions de paquets/effets gardent leurs limites d’intégration séparées.
- SPECIAL-CURRENT-FLOAT-VIEW : raccorder une entrée réellement admise à la vue commune. Les états, messages et fonctions existants ne sont ni supprimés ni renommés en événements Special.
- SPECIAL-RENDER-PERSISTENCE : vérifier entrée nommée/0/1, non mappée/invalide/privée/périmée/aucun événement/autres catégories, ordre/doublons/expiration/viewport/session et Annuler/défaut/Save/rechargement.

Chaque manque conserve son impact et une entrée de reprise précise. Cache, déclaration de module, mode de paquet ou journal d’erreur ne deviennent pas une notification spéciale affichée.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-SPECIAL-SETTING-01. Identifier d’abord une vraie entrée Special1, puis raccorder préférence et texte aux composants Floating communs. Menu/HUD local/Physical conservés. Pas de moteur universel de messages/effets, de second renderer ou de flux générique déduit de la recherche vide.

Prochain lot : Score_Enabled, case 153. Identifier callback/type et vraies données/événements de score, distincts du tableau de score et du portefeuille.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SPECIAL-01\floating-special-proof.json`, SHA-256 `ecef655abf2cc75cd15a8d11777c066cd864e6414614a2715e1625ac8383167c` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SPECIAL-01\verify_floating_special.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-SPECIAL-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
