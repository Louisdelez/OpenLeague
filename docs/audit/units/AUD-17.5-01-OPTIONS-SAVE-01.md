# AUD-17.5-01-OPTIONS-SAVE-01

UTC : 2026-10-31T06:47:15.189975+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et clôture
Bouton Enregistrer :label,états enabled,commit/envoi/fermeture et stratégies regular/savecfg. Les autres boutons et le menu complet restent séparés. Audit terminé côté producteur;clôture réservée à la relecture indépendante. Implémentation non modifiée;vérification statique seulement;acceptation humaine non demandée.

## R2 — Sources et preuves
PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. XML : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` — SHA256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de`. VA préférées0x400000,rôles analytiques,pas symboles PDB ou adresses live.
Exports AS3/p-code antérieurs réutilisés;aucun réexport ni installation. Huit nouvelles méthodes Save sont retrouvées par octets uniques dans le DoABC original. Le journal Annuler et le dispatcher MasterVolume restent des preuves héritées,conservées. Python,pefile,Capstone,DLL,producteur et helpers sont épinglés.

## R3 — Consommateurs réels
saveLabel=flash_optionsMenu_save rejoint placedButtons[0],puis _saveButton.label. Le clic MouseEvent appelle onSaveClick. Le bouton commence désactivé;les événements NOW_HAS_CHANGES et NO_LONGER_HAS_CHANGES le rendent actif/inactif. Le handler n’a pas sa propre garde enabled. Le retour du handler générique Button désactivé ne prouve pas la suppression du listener MouseEvent séparé.
onSaveClick appelle ModelApplication.serializeData puis CloseMenu. BaseSerializer.serialize commit chaque owner avant serializeAction,finalizeSerialization puis reset. GameSerializer regroupe par strategy et section;IGNORE est exclu après commit local. Il vide ses dictionnaires de construction avant Update. Sans exception,reset vide les deux journaux,puis le handler demande CloseMenu. Une synchronisation de modèle peut aussi appeler serialize;le clic n’est pas son unique entrée.
Le natif distingue regular→82F100 et savecfg→82F4B0 via831330. Regular notifie la table0 des souscripteurs par clé[section]nom. Clé absente et liste vide ont des chemins distincts;aucun résultat de callback n’est consulté. Ce handler n’est pas à lui seul une preuve de persistance.
Savecfg reçoit le nom utilisateur retourné par8B2E00;le littéral defaults/Game.cfg poussé séparément n’est pas une preuve du fichier écrit. Le callback appelle8B2B10 avant de rechercher/notifier la table0. Ainsi,absence de souscripteur ne prouve ni absence d’une requête d’écriture ni retour en arrière.
8B2B10 prépare le chemin et appelle8B1060. Ce dernier ouvre/lit par8B08A0,modifie le buffer via8B0F50,puis demande8B0960. Le writer passe modewb au provider8B4FB0,teste pointeur/slot0C,invoque slot28 puis la libération. Le résultat de slot28 et celui de libération ne sont pas vérifiés avant AL1. Le lecteur emploie modeab+;les modes sont des chaînes source,pas une observation du backend réel.
Options_close appelle aussi836660 après hide/update. Cette fonction possède une garde globale et parcourt plusieurs tables typées vers des setters de configuration. Elle est conservée comme chemin supplémentaire à qualifier;elle n’est ni ignorée ni déclarée preuve que tous les réglages regular sont persistés.
Consommateurs actuels conservés :load_using et appel de démarrage lisent la configuration;leur migration existante n’est pas exécutée. La recherche des cinq noms exacts Save sur1168sources n’a aucun résultat. Elle n’exclut pas un équivalent autrement nommé.

## R4 — Vérifications exécutées et cas
8méthodes p-code/8fonctions natives complètes et52instructions fixes relues,littéraux et imports vérifiés. Aucun x86,AS,Rust,GUI,input physique,réseau,configuration ou écriture de fichier du client exécuté. Les appels GetFileAttributesA/RemoveDirectoryA sont identifiés par IAT;ils ne sont pas invoqués.

### C1
- Attendu : The Save surface has a source-backed label,click handler and enabled state driven by journal change events.
- Observé : Root saveLabel reaches placedButtons[0];Save starts disabled;NOW_HAS_CHANGES enables and NO_LONGER_HAS_CHANGES disables. onSaveClick itself has no enabled guard.
- Limite : Declared property state only;separate Button MouseEvent listener,hit testing,focus and physical disabled input not executed.

### C2
- Attendu : Normal Save commits local values before constructing/sending the grouped batch,then clears journals and requests close.
- Observé : BaseSerializer.serialize calls owner.commitToValue before serializeAction;finalizeSerialization clears build dictionaries before Update;reset follows normal bridge return;onSaveClick then calls CloseMenu.
- Limite : No success/ack checked;exceptions can prevent later reset/close,while silent native failure can leave committed baselines. No atomic transaction claimed.

### C3
- Attendu : Empty and ignore-only serialization must not be mistaken for a successful native file write.
- Observé : Empty journal still calls finalizeSerialization with an empty array. IGNORE entries commit locally but serializeAction excludes them. Existing Update array loop skips zero entries.
- Limite : Physical Save is normally disabled without changes;direct handler invocation and all event-side changes are separate. No original case executed.

### C4
- Attendu : regular strategy invokes the regular keyed subscribers;missing subscribers do not imply application or persistence.
- Observé : 831128 selects82F100 through831330;that handler uses dispatcher table0 with key[section]name. Missing key logs No subscribers;empty list skips callbacks;returns are not checked.
- Limite : Specific subscriber identities,allocation/map lifetime and effects remain unqualified. Other close-time saving can exist and is separately recorded.

### C5
- Attendu : savecfg strategy requests a configuration mutation before notifying regular subscribers,with a distinct filename source.
- Observé : 83114E selects82F4B0;8B2E00 returns the user filename global after lazy init. Handler calls8B2B10 before table0 lookup,so notification failure does not prove write failure or undo a prior request.
- Limite : The pushed defaults literal is not proof of selected output. Actual filename/layout/locale/provider and output bytes remain unobserved.

### C6
- Attendu : Configuration read/mutation/write gates have local success/failure paths without overclaiming complete physical I/O.
- Observé : 8B1060 requires8B08A0,updates a buffer via8B0F50,then calls8B0960. Writer opens through8B4FB0(modewb),requires nonnull/slot0C,invokes slot28 and releases the object.
- Limite : Slot28 and destruction return values are not checked before AL1;provider backend identity,write count,flush/durability,partial writes and safe failure cleanup not qualified.

### C7
- Attendu : A local configuration failure is distinguished from what the Save menu learns about that failure.
- Observé : 8B2B10 tests mutation result,diagnoses Failed to write and returns0 on that path.82F4B0 ignores that return and continues its notification path. AS serialization also ignores bridge result.
- Limite : Diagnostic is a source path,not an observed write failure. Logger/assert behavior,exceptions and cache invalidation effects are outside this static qualification.

### C8
- Attendu : Closing the menu may run additional saving work and must not be collapsed into a single SaveCfg acknowledgement.
- Observé : Options_close82E730 calls836660 after hide/update.836660 has a global-byte bypass and iterates typed tables through value/name/file helpers and configuration setters.
- Limite : Typed-table schemas,option ownership/IDs,full helper effects and exact closed-state context remain unqualified;the source path is not durable persistence proof.

### C9
- Attendu : Current settings readers and previous audits are preserved;source audit closure does not implement a Save UI.
- Observé : Verified1168source exact-name query has no Save hook match. Startup load_using and its existing migration condition remain real consumers and were not invoked.
- Limite : Bounded query only;differently named behavior may exist. Current editor,persistence/read-after-restart,complete parent and game remain open.

## R5 — Manques et reprise
Le commit local et la suppression des journaux ne sont pas un accusé d’écriture. Exceptions,réentrance/feedback des événements et résultats des overrides ne sont pas qualifiés. Une erreur native silencieuse n’est pas testée par le menu;une exception peut empêcher les étapes suivantes.
8B1060 retourne faux si ses gates de lecture/écriture échouent. 8B2B10 produit alors Failed to write et retourne0;82F4B0 n’examine pas ce retour avant de poursuivre. Les diagnostics sont des chemins statiques,pas des pannes observées. Le succès local du writer ne prouve pas écriture complète,flush,atomicité,persistance ni relecture après redémarrage.
- **SAVE-DURABLE-PROVIDER** — Manque : Selected8B4FB0 provider,slot28 result/partial writes,destructor/flush,durable output,actual user filename and cache invalidation are not observed. Reprise : Identify the provider/vtable and a controlled named output path;separate authorized write/readback/restart evidence from local AL1 and from unchanged configuration-reader tests.
- **SAVE-CLOSE-TABLES** — Manque : 836660 typed-table identities,836C40/836F70 helpers,individual callbacks and complete quickbinds/input effects remain unqualified. Reprise : Use one named option/table with source-backed identity;reuse the pinned close function and separate control-specific application from savecfg and from physical persistence.
- **SAVE-CURRENT-INPUT** — Manque : Current Save editor,physical disabled/focus policy,exception/event feedback and acknowledged or explicitly one-way transaction behavior remain open. Reprise : Reuse HUD-OPTIONS-ENTRY-01 criteria under a separate authorized product scope;retain existing readers/migration logic and qualify unwanted writes,invalid inputs and read-after-restart independently.

## R6 — Correction existante
HUD-OPTIONS-ENTRY-01 conserve son ID,sa définition et son statut proposé,non appliqué. Avancée documentaire :Save,états locaux,ordre des opérations,branches regular/savecfg et frontières de retour/persistance. Aucune correction concurrente ni changement de registre,critère ou état manuel.
Une future correction doit conserver les lecteurs et expliciter le contrat historique à sens unique ou une reconstruction locale versionnée;écriture voulue,persistance,refus,focus/session et annulation doivent être vérifiés séparément. Les critères actuels de la fiche restent inchangés.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SAVE-01\options-save-proof.json`. Spécification/producteur/relecteur isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SAVE-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SAVE-01\delivery-readback.json`;elle seule clôt ce sous-lot après sept rubriques.
Cinq registres,25fichiers gelés,1168sources et Git HEAD/branche/76modifications antérieures conservés. PE,movie,XML et preuves antérieures conservés. Goal,critères,Plan/UI et bases inchangés;aucune installation,migration,reprise du suivi ou chargeur productif exécuté.
Clôture limitée au contrat statique Save et à ses frontières documentées. SYS-17.5-01 et SYS-01.2-02 restent ouverts;aucune fonctionnalité actuelle,écriture durable,menu ou jeu complet déclaré terminé.
