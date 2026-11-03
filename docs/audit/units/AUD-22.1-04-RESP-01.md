# AUD-22.1-04-RESP-01 — Responsabilité des textes de boutique

Contrôles : 2026-10-30T10:54:57.928726+00:00. Parent : SYS-22.1-04. Cette unité reprend l'action documentaire TR-RESP-01 définie dans AUD-22.1-07-TR-01, pour le chemin limité décrit ici. Aucun changement de Goal, d'application de suivi, de base ou de code.

## 1. Résultat et portée

**Audit terminé pour la séparation entre chargement de polices et deux textes de la boutique : recherche et nom de l'objet sélectionné.** Le démarrage sélectionne un profil de polices selon la locale. Il ne fournit pas un dictionnaire de traductions à la boutique. Celle-ci affecte aux textes un littéral français et un nom déjà stocké en français dans le catalogue.

| Dimension | État |
|---|---|
| Audit | Terminé pour ce chemin et ces deux rôles UI |
| Implémentation | Profil de polices et textes de boutique présents ; raccordement de ces textes à la locale sélectionnée absent dans le chemin inspecté |
| Vérification | Partielle : code et ressources actuels contrôlés ; preuves de chargement V795 réutilisées ; aucune exécution graphique ni nouveau test Rust |
| Acceptation humaine | Non demandée |

TR-RESP-01 n'est pas clôturée globalement pour tous les textes HUD par cette seule unité. SYS-22.1-04 et SYS-22.1-07 restent ouverts. Aucune conclusion d'absence globale de localisation dans le jeu.

## 2. Sources et disponibilité réelle

La référence reste PUBLIC4.20.0.315 EUW/en_GB. L'entrée locale actuelle `data/4.20/font_configuration/locale.cfg` contient exactement `[General]` puis `LanguageLocaleRegion=en_GB`.

Le fichier importé `data/4.20/font_configuration/menu/fontconfig_en_GB.txt` est identique au fichier historique sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/fontconfig_en_GB.txt`. La ligne 7387 contient la clé `game_item_displayname_1001`, valeur `Boots of Speed`. Le catalogue courant contient pour 1001 `Bottes de vitesse`, concordant avec le fichier historique français, comme vérifié dans AUD-22.1-07-KEY-01.

Les ressources anglaise et française sont disponibles. Aucun téléchargement ou outil supplémentaire n'est nécessaire pour établir cet écart. Leur présence ne constitue pas une preuve qu'un dictionnaire est consommé à l'exécution.

Preuve native réutilisée : V795 établit l'enregistrement de `HandleLocalizeText`, callback 0x7879A0, par 0x786E20. Le corps de ce callback et le traitement natif exact d'une clé absente restent non qualifiés. Le lecteur 0x796350 n'est pas réanalysé : aucune piste nouvelle ne justifie de refaire son analyse.

## 3. Chaînes de consommation établies par lecture

| Étape | Consommateur réel et rôle |
|---|---|
| Locale → profil | `native_hud_font_configuration.rs:37-51` lit locale.cfg, sélectionne un profil du manifeste, puis appelle parse |
| Profil → configuration | Même fichier, lignes 5 et 13-35 : Configuration ne contient que maps et libraries ; les déclarations tr ne produisent aucune traduction |
| Configuration → police | `native_zip_provider.rs:116-118` transmet les maps à `native_hud_font_assets::selected` et conserve Loaded dans StartupHud |
| Police → asset moteur | `native_hud_font_assets.rs:40-55` choisit la famille puis enregistre les octets et les handles de Font ; aucun dictionnaire de texte n'en sort |
| Locale → journal | `main.rs:604` journalise locale et chemin du profil ; aucune valeur de traduction n'est transmise par cette ligne |
| Catalogue → nom sélectionné | `core/src/shop.rs:36-47` charge shop_foundation.json ; `shop_ui.rs:423` affecte directement i.name.clone() à NativeText::SelectedName |
| Littéral → recherche | `shop_ui.rs:421` choisit Rechercher un objet... ou la saisie ; aucun accès à une clé native |
| Systèmes UI | `shop_ui.rs:194` et 298-303 : signatures setup/update sans service de traduction ; `main.rs:809,825` enregistre les deux systèmes |

Le type NativeText est un rôle de widget, pas une clé native. La police de boutique est également chargée par `native_font`, lignes 149-150, à partir de foundry::FONT_PATH ; ne pas assimiler automatiquement les handles du plugin de polices à la police de tous les widgets.

## 4. Recherche délimitée et contrôles

Recherche textuelle en lecture seule dans les crates Rust, puis lecture des candidats : `localiz`, `fontconfig_`, `game_item_displayname`, `HandleLocalizeText`, `text_key`, usages de shadow_isles_font_configuration et LanguageLocaleRegion. Les recherches larges sur translation ont rencontré des transformations 3D ; elles ne sont pas utilisées comme preuve de localisation.

Contrôle complémentaire des 498 fichiers .rs sous crates/client/src : aucune occurrence littérale de `game_item_displayname_`, `HandleLocalizeText`, `translations.get` ou `translations.as_ref`. C'est une recherche bornée avec ces expressions, pas une preuve par le nom de toutes les implémentations possibles. La conclusion locale repose surtout sur les structures, les signatures et les affectations directes ci-dessus.

Les candidats `audio_announcer_*` dans core ne sont pas ignorés : ils exposent des callbacks Backend::localize. Le fournisseur qui lit un BTreeMap de traductions dans `audio_announcer_ordered_formatter.rs:134-187` est sous `#[cfg(test)]`, ligne 127. Il ne prouve pas l'existence d'un résolveur HUD branché sur la boutique. Les autres backends et l'intégration complète des annonces sortent du présent lot. `native_config_cache_reload.rs:15-29` traite des suffixes et chemins de ressources localisés ; ce n'est pas la résolution des deux rôles UI inspectés.

| Cas | Attendu / question | Résultat observé et limite |
|---|---|---|
| Configuration actuelle | Identifier la locale réellement enregistrée | Octets lus : en_GB ; fichier inchangé |
| Ressource anglaise | Vérifier que le nom de l'objet 1001 est disponible | Clé et valeur Boots of Speed présentes ; copie importée identique à l'original |
| Nom sélectionné | Déterminer de quelle donnée dépend le texte | Lecture directe du nom français du catalogue, sans entrée de locale dans ce chemin ; constat statique |
| Champ de recherche | Déterminer si une clé native est résolue | Littéral français dans le match NativeText ; constat statique |
| Chargement fr_FR / en_GB | Ne pas refaire un diagnostic identique | V795 avait exécuté les deux chargements de profils parmi les 38 cas. Aucun résultat de traduction de widget n'était produit par ce diagnostic |
| Clé manquante | Identifier une réponse actuelle/historique vérifiée | Aucun refus à l'usage de ces deux rôles qualifié ; callback natif non qualifié ; aucun cas rejoué |

Les lectures Python avec -X utf8 -E -B, les comparaisons d'octets et SHA256 et les recherches rg ont terminé avec code 0. Aucun texte affiché à l'écran n'est présenté comme une observation de cette unité.

## 5. Écarts et inconnues

L'écart établi est l'absence de raccordement à la locale sélectionnée dans ces deux rôles de boutique. La table native anglaise n'est pas manquante. La responsabilité de parser les textes et de résoudre une clé n'est pas remplie par le lecteur de polices actuel. Définir son API, sa politique de clé absente et ses usages reste du travail fonctionnel.

Restent ouverts : les clés natives correspondant au prompt de recherche et aux autres littéraux ; la grammaire complète des tr et du formatage ; le callback natif 0x7879A0 ; le comportement sur clé absente ou valeur vide ; les autres widgets HUD ; les débordements ; l'observation graphique. Les anciens liens de SYS-22.1-04 restent conservés avec full_task_scope_complete=false et l'inconnue OLU-f7d57a9f-32d2-5d02-8b33-c903cdac74e8. Aucun registre n'est réécrit.

## 6. Corrections nécessaires et conditions de reprise

Aucune correction implémentée dans ce lot documentaire. La sélection de police existante et les noms français concordants doivent être conservés.

| Action documentaire | Critère de fin précis | Entrée de reprise |
|---|---|---|
| RESP-ITEM-01 sous SYS-22.1-04 | Définir puis brancher la résolution de game_item_displayname_<id> pour le nom d'objet ; vérifier 1001 en en_GB et fr_FR, puis clé absente et valeur vide selon un contrat explicite. Conserver ID et sémantique d'achat. | Sources natives déjà présentes ; responsabilité/API de résolution définies ; instruction autorisant la réalisation fonctionnelle |
| RESP-SEARCH-01 sous SYS-22.1-04 | Identifier le texte natif de recherche ou établir qu'aucune correspondance n'est qualifiée, puis conserver une distinction explicite entre contrat local et source historique. Fin : source+consommateur et contrôle nominal/limites. | Recherche ciblée sur les ressources ItemShop/fontconfig ou nouvelle preuve native ; ne pas déduire une clé du seul texte ressemblant |
| TR-CONTRAT-01 et KEY-DIAG-01 sous SYS-22.1-07, réutilisés | Qualifier la politique de texte absent dans la couche responsable, puis documenter le diagnostic requis, sans confondre ID d'objet absent et clé de traduction absente. | Nouvelle question ciblant 0x7879A0/0x795D10 ou source équivalente ; ne pas répéter 0x796350 sans nouvelle piste |

La reprise documentaire immédiate possible, sans réalisation fonctionnelle, est l'audit limité des contraintes de taille et des diagnostics de débordement dans shop_ui.rs. Sa clôture exige des contrôles de layout et la distinction entre clipping/wrapping configurés et détection explicite d'un débordement.

## 7. Identités et livraison

| Fichier | Octets | SHA256 |
|---|---:|---|
| data/4.20/font_configuration/locale.cfg | 37 | 053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f |
| fontconfig_en_GB.txt original et importé | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| crates/client/src/native_zip_provider.rs | 19264 | 84f31115bf4413eb2617aa7eedf353d0fd36ee18d8afd2b5d4b35475eceacb6c |
| crates/client/src/native_hud_font_assets.rs | 6727 | db8696ce4c94b4162ece2c742d8af0cd209ec731aee13b0666928c496d463ed0 |
| crates/client/src/native_config_cache_reload.rs | 5504 | a6148a0384f70ffb730288d90b0ce8271e4c779d53adddaae29143df833e2b96 |
| crates/core/src/audio_announcer_ordered_formatter.rs | 30817 | c591797c36670d042a90a84a162b3109911feb08c4553e535eee97fd0f438e03 |

Identités de shop_ui.rs, shop.rs, main.rs et du catalogue : AUD-22.1-07-KEY-01, même session, mêmes fichiers. Identité du lecteur de polices et reçu V795 : AUD-22.1-07-TR-01. Aucun binaire nouvellement produit ou exécuté. Le seul fichier créé pour cette unité est ce compte rendu ; les preuves antérieures sont conservées.

Relecture : source disponible ne signifie pas source consommée ; chargement de police ne signifie pas traduction du widget ; fournisseur de test ne signifie pas branchement en production ; écart établi statiquement ne signifie pas reproduction graphique. Les sept rubriques sont couvertes pour la frontière définie.
