# Dodge_Enabled — audit du texte d’esquive

## R1 — Portée et décision

2026-10-31T18:01:26.773604+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-DODGE-01`, SYS-17.5-01 / SYS-01.2-02. Case 150, type commandé et résultats d’attaque actuels utiles à une notification. Le producteur ne clôture pas le lot ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Enemy précédent clos : 122 contrôles et 382 de relecture. Sources Damage/Attack/audience et éléments Floating communs réutilisés sans rejouer les anciens tests.

Nœud `OPT-SRC-995ef52e715dcf04`, INI seul `[FloatingText]Dodge_Enabled`, libellé en_GB « Dodge » ligne 737. Regular par défaut, aucun updateonclick déclaré ; fournisseur effectif et définition injectée non observés. Deux fichiers de valeurs par défaut portent Dodge=1 ligne 196 ; aucun remplacement dans les fichiers utilisateur/deploy examinés.

Deux régions propres : inscription 0x7BC9A6–0x7BCA0C (fin exclue, 102 octets), callback complet 0x7BE4C0–0x7BE4D6 (22 octets). Clé 0x10BA670 passée à 0x7BC9A6 ; capture du manager et callback via 0x65C4C0, puis 0x82D410 avec littéraux 1/0. Classification interne, ordre et durée d’inscription ne sont pas requalifiés ; 1 ne prouve pas un updateonclick déclaré.

Le callback appelle le convertisseur booléen commun et écrit uniquement manager+0x35, soit le type Dodge5, jusqu’au retour ret4. Les autres catégories restent distinctes. Table et six régions communes d’initialisation/admission sont contrôlées inchangées : init et callback visent le même cache. Pour une entrée valide, 0 refuse Dodge5 et 1 laisse agir les autres gardes, sans garantir un événement ou des pixels. Les anciennes observations de ressources gardent leur date et leur portée, sans nouvelle recherche de paquets/fichiers.

## R3 — Consommateurs réels et acquis

Les attaques actuelles ont de vraies annulations pour mort, contrôle, autre sort ou cible invalide. La validité vérifie aussi protection, visibilité et portée. Ces résultats ne désignent pas une esquive.

Pour une attaque de mêlée, le booléen de présentation reflète le .is_ok() de l’opération de coup ; il n’est pas une taxonomie de raisons. Pour les attaques à distance examinées, false lors de la libération signifie absence de coup au lancement, pas projectile manqué ou esquive. La résolution clôt le windup avec ce booléen. Cette distinction est explicitement présente dans le code et conservée par l’audit.

Les résultats de dégâts, absorption/baisse de santé, refus, phases d’attaque et annulations existent. Le succès d’une opération n’est pas équivalent à des dégâts positifs. Audience historique source ET cible, visibilité actuelle et consommateurs par joueur sont réutilisés avec leur portée précédente ; ils n’autorisent pas automatiquement un texte Dodge.

Les requêtes exactes de préférence/popup et sémantiques Dodge sont vides sur les 1 168 sources Rust/JS/HTML inchangées. Aucun producteur distinct de notification/esquive nommé n’est identifié dans ce périmètre. Cela ne démontre pas l’absence de tout déplacement d’évitement, collision ou mécanisme natif/Lua/autre langage. Aucun résultat Dodge n’est fabriqué depuis false, zéro, bouclier, refus ou annulation.

## R4 — Vérifications et attendu / observé

107 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, douze instructions attendues, retour complet/unique écriture/type5, vraies annulations et résolution mêlée/lancement à distance, sources d’audience réutilisées, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export, contrôle visuel ou de persistance rejoué.

## R5 — Écarts et conditions de reprise

- DODGE-OUTCOME-ADMISSION : identifier un vrai producteur natif/local de type5 avec résultat distinct, raison, source/sujet, identité/temps, audience, mode et texte. Les résultats génériques actuels ne satisfont pas cette entrée.
- DODGE-PROVIDER-PROFILE : qualifier configuration/définition/fournisseur effectifs, inscription/notification, texte localisé/profil/police/horloge et vue commune. Défaut 1 et cache35 ne démontrent ni mode courant ni persistance.
- DODGE-CURRENT-FLOAT-VIEW : raccorder une entrée admise à la vue commune. Le combat et ses refus sont acquis ; ne pas inventer une chance d’esquive ou un moteur de tous les champions pour satisfaire la case.
- DODGE-RENDER-PERSISTENCE : vérifier vraie esquive et contrôles négatifs distincts (annulation, mort, cible invalide/protégée, zéro, bouclier, lancement à distance, absence de tentative, historique caché), 0/1, ordre/doublons/expiration/viewport/session et Annuler/défaut/Save/rechargement.

Chaque manque conserve son impact et une entrée de reprise précise. Une indisponibilité ou non-applicabilité doit être établie et nommée ; elle ne devient pas une réussite de fonctionnalité.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-DODGE-SETTING-01. Qualifier un résultat Dodge5 réel puis sa présentation sur les composants Floating communs. Menu/HUD local/Physical et politiques d’audience conservés. Aucun second moteur de combat/texte ni flux générique n’est déduit de la recherche vide.

Prochain lot : Level_Enabled, case 151. Identifier le callback/type, les vrais changements de niveau et leur présentation, distincts du compteur courant ou du gain d’XP.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-DODGE-01\floating-dodge-proof.json`, SHA-256 `7fbc28e7209baedb35df72c2623b92b4bb942b9c5b5017867fe1de0c5a9186e5` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-DODGE-01\verify_floating_dodge.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-DODGE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
