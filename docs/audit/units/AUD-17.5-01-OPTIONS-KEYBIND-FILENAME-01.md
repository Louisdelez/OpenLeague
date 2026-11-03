# AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01 — chemin du fichier Input.ini

Date : 2026-10-31T09:18:21.925084+00:00. Parent SYS-17.5-01 ; goal SYS-01.2-02 inchangé. OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 ; OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin

Identifier le chemin construit par `8B3CF0`, son caller, les variantes de langue et les frontières de sélection. Huit corps normaux sont examinés ; les helpers communs de dossier et les preuves de locale sont réutilisés. La fin du lot est documentaire : elle ne demande ni exécution du jeu ni migration. Le producteur ne prononce pas sa propre clôture ; la relecture séparée vérifie les sept rubriques.

Audit : chemin et branches établis, contexte effectif encore ouvert. Fonctionnalité : aucune modification. Vérification : octets et sources, avec preuves antérieures conservées à leur portée. Acceptation humaine : non demandée. Parent et goal restent ouverts.

## R2 — Sources et provenance

PE original 4.20, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Initialiseur `8B3CF0..8B3F8B`, résolveur `8B2ED0..8B30CB`, comparateur ASCII et wrapper, mesure et copie bornées, disponibilité des ressources `8B5170` et dispatcher `8B4F60`. Les fins sont exclusives ; les retours précoces et blocs tardifs sont conservés. Les suites reprennent aux fins de décodage antérieures, sans redécoder les préfixes. Le wrapper du comparateur a un tailcall externe explicitement admis ; la copie finit par un saut vers son épilogue.

Contrats anciens : 45 choix de dossier à `8B3840`, 648 initialisations **Game.cfg** à `8B3970`, avec migration commune `8B30D0`. Ils ne constituent pas 693 tests Input.ini. Les limites anciennes sur la racine, le classifieur et la locale ne sont pas considérées comme les dernières connaissances du projet : les preuves plus récentes sont conservées et doivent être réutilisées à la reprise.

La preuve de locale existante exécute le caller et le setter originaux sous un backend fourni en lecture seule : `defaults/Locale.cfg` donne `en_GB`, une copie temporaire omettant la locale donne `en_US`, et un second setter conserve `en_GB`. Ce sont des contextes déclarés, sans qualification du montage historique des providers. Aucun de ces cas n'est rejoué.

Les trois sources Input.ini sont réidentifiées par hash : défaut natif (30938 octets), override du deploy (305 octets), configuration utilisateur (710 octets). Cette dernière est un artefact utilisateur, pas un défaut de 2014. Leur présence physique ne prouve pas leur sélection par le runtime.

## R3 — Contrat et consommateurs

Le caller `8B16C0` consulte le masque `1` de `2D83FF8`. S'il est libre, il le positionne **avant** l'appel `8B3CF0`, puis inscrit un destructeur via atexit. Ce masque ne garantit pas, seul, une initialisation terminée ou thread safe. Le SSO de sortie est `2D85628` ; `2D8563C` est sa **capacité**, conformément à l'erratum antérieur.

L'initialiseur appelle le choix de dossier `8B3840`, puis compose ce dossier avec `Input.ini`. Sous les entrées déclarées des contrats : mode 2 ou accès non nul → `DATA/CFG/Input.ini` ; sinon → base fournie + `/Config/Input.ini`. Ce résultat ne détermine pas la racine, le mode ou les droits effectifs d'un lancement historique.

Il construit séparément `DATA/CFG/Input.ini` et appelle la migration commune vers le chemin de base global. Puis il appelle **deux fois** `8B2ED0` avec le même chemin legacy local et la même extension `.ini`. Les deux résultats sont copiés dans deux SSO distincts et donnés à une seconde migration. Sous un contexte stable, ces résultats coïncident ; la stabilité et le résultat de migration ne sont pas observés. Le code ne justifie pas une affirmation « ancien chemin localisé vers chemin utilisateur localisé ». Les copies localisées ne remplacent pas explicitement le filename global retourné par ce corps.

Le résolveur retourne le chemin d'origine si l'extension est NULL, vide, ou si le flag de locale `2D78DB8` est nul. Sinon il compose préfixe + `_` + buffer de locale `14BEB74` + suffixe original. Dans le cas nominal : `DATA/CFG/Input_en_GB.ini`. Il prépare aussi le nom terminé par le littéral `bin` : `DATA/CFG/Input_en_GB.inibin`.

Il sonde le candidat, puis son alternative `bin` si nécessaire. Un statut zéro suffit à sélectionner le candidat logique **sans** `bin` ; deux statuts non nuls conservent le chemin initial. `8B5170` peut initialiser les providers via `58F880`. `8B4F60` appelle leur méthode virtuelle +4 avec `(path, 0)` dans l'ordre : premier zéro, dernier statut non nul, ou -1 sans provider. Il s'agit de disponibilité à travers ces providers, pas d'un test direct d'existence physique.

Le résultat du comparateur de suffixe `C9CF31` est ignoré : aucune branche ne refuse une extension discordante. Son fallback ASCII calcule une différence sans modifier les chaînes ; la branche CRT locale `C9CF78` reste opaque. Son flag `14AE870` est distinct du flag de locale des fichiers. Le résolveur ne refuse pas localement une locale vide, un filename NULL activé ou une extension plus longue que le filename ; la validité amont reste requise.

La mesure bornée à 511 octets ne modifie pas la chaîne et son résultat est ignoré. La copie suivante utilise 512 octets **NUL compris**, dans le buffer partagé `2D85640`. Ce n'est pas une troncature garantie. 511 octets plus NUL tiennent ; 512 octets non NUL épuisent la capacité, vident le premier octet et entraînent le statut 22h si le gestionnaire de paramètre invalide revient. Les entrées NULL ou la taille nulle conduisent au chemin 16h. Le caller ignore ces retours. Aucun refus, crash ou erreur n'est reproduit dans ce lot.

Les consommateurs actuels inspectés sont les helpers de dossier et le chargement **Game.cfg** dans `native_user_settings.rs`, ainsi que l'input QWER/learn dans `spell_input.rs`. Les helpers de chemin existent ; le chargeur peut créer ou renommer une configuration et n'est donc pas appelé. Ces consommateurs ne constituent pas un éditeur Input.ini configurable et persistant.

## R4 — Attendu et observé

500 instructions dans huit corps, 59 points fixes, quatre littéraux et le caller sont vérifiés sur les octets originaux. Les bornes, prologues voisins, padding et branches sont explicités. Les cas sont qualifiés par leur nature : composition de sources, branche statique ou preuve ancienne ; aucun cas Input natif n'est inventé.

Les cas couvrent : chemin utilisateur, repli DATA/CFG, locale désactivée, variante disponible, variantes absentes, limite 511/512, provenance en_GB/en_US et paire d'appels identiques. Pour chacun, la preuve JSON donne attendu et observé. Corpus de 1168 fichiers, 25 fichiers protégés, cinq registres et état Git vérifiés avant/après. Aucun scan général, profil inchangé, jeu, x86, AS, Rust, GUI, input physique, réseau, installation ou migration exécuté.

## R5 — Manques et reprise

- `FILENAME-SELECTED-CONTEXT` : racine, mode, accès, providers et contexte du cache effectivement choisis. Réutiliser les preuves du classifieur et du cache, puis relier `8ACEF0(filename,0)` à ce caller avant une nouvelle analyse.
- `FILENAME-DUPLICATE-MIGRATION` : stabilité entre les deux résolutions, effet de la migration, erreurs et courses. Réutiliser `8B30D0` ; aucune migration réelle sous l'autorisation documentaire actuelle.
- `FILENAME-MALFORMED-LIFETIME` : validité amont des chaînes, branche CRT, gestionnaire d'erreur et état partagé. Reprendre uniquement avec un producteur ou un cas précis ; la limite 512 et les preuves SSO sont déjà acquises.
- `FILENAME-CURRENT-CYCLE` : chargement, édition, application, annulation, sauvegarde et reprise des bindings/modes actuels. Reprendre les corrections produit sous autorisation distincte.

Chaque manque possède dans la preuve son impact et son entrée de reprise. Aucune absence globale de fichier ou d'alias n'est déduite de cette analyse.

## R6 — Corrections et suite

Les dix corrections de bindings/modes et `HUD-OPTIONS-ENTRY-01` sont conservées, proposées et non appliquées, avec leurs définitions. L'erratum SSO, les frontières de copie et les anciennes clôtures documentaires sont préservés. Aucun nouveau doublon ni changement normatif.

Prochain lot borné : `AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01`. Partir de l'appel direct `8ACEF0(filename,0)` déjà relevé et du reçu existant `original-config-cache-execution.json` ; identifier ce qu'il prouve pour Input.ini et le producteur précis encore nécessaire. Aucun rejeu des 668 profils, recherche d'archives ou examen récursif sans borne.

## R7 — Livraison et vérification séparée

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01\keybind-filename-proof.json` ; SHA256 `f48109ee90786f1a232e0bd9b47215b75fbfb78cbf2ec1fffb7f3f97fe798cae`. Producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01\verify_keybind_filename_v2.py`. Fiche, quatre inspections et scripts sont identifiés dans la preuve. Relecture : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01\verify_delivery.py`, reçu `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

La première synthèse a été refusée par son contrôle de préfixe : un octet attendu avait été transcrit `d8` au lieu de `d7` pour l'adresse `2D78DB4`. Le script et le reçu d'échec sont conservés ; la v2 corrige uniquement cette attente. Aucun défaut du binaire n'en est déduit.

Seuls de nouveaux artefacts documentaires isolés sont écrits. Goal, critères, registres, code, assets, application de suivi, interface, bases et preuves antérieures inchangés. Aucune clôture fonctionnelle, du parent ou du goal global ; aucun pourcentage de jeu calculé.
