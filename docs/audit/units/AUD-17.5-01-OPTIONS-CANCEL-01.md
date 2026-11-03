# AUD-17.5-01-OPTIONS-CANCEL-01

UTC : 2026-10-31T06:28:18.409342+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Annuler et la petite croix de fermeture dans le movie FoundryOptions épinglé :déclenchement,état de référence,restauration et frontière native. Fin documentaire :chaîne et limites relues,consommateurs actuels nommés. Les deux surfaces partagent le handler;elles ne sont pas ajoutées aux78contrôles actuels comme fonctionnalités implémentées.
Audit : producteur terminé,clôture réservée à la relecture séparée. Implémentation : non modifiée. Vérification : exports p-code sélectifs,comparaison des octets originaux et analyse statique exécutés;aucun x86/AS/Rust/jeu/GUI/réseau exécuté. Acceptation humaine : non demandée. Goal et critères inchangés.

## R2 — Sources et identité
Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. XML : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` — SHA256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de`. Le root porte cancelLabel=flash_optionsMenu_cancel,qui rejoint placedButtons[1] puis le label du bouton;aucun rendu/traduction mesuré.
306exports AS3 antérieurs conservés;sept nouvelles classes seulement exportées en p-code avec le Java/JPEXS/JVM existant. Quatorze méthodes sont retrouvées à une occurrence unique des mêmes octets dans le DoABC original. Versions,commandes,logs,empreintes et limites sont dans les reçus. Aucun bytecode exécuté ni installation.
PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. VA préférées0x400000,rôles analytiques,pas symbolesPDB ou adresses d’un processus.

## R3 — Chaîne réelle
ViewApplication branche _cancelButton et _exitButtonSmall au même onCancelClick. Celui-ci appelle seulement CloseMenu,sans undo ni vérification de résultat. ExternalInterface peut appeler un override enregistré;sinon il transmet à flash.external.ExternalInterface.
Le natif enregistre CloseMenu→830140;ce thunk délègue à8244F0. Manager+98 nonnul et actif+30 mène au slot18 de la vtable Options,82E730. Il appelle7841E0 puis la mise à jour habituelle. Hide efface le drapeau actif avant le test de communication;786300 prépare SetVisibility avec isVisible=false et playSounds. La file et ses limites antérieures restent distinctes d’une livraison.
À réception de SetVisibility(false),FoundryOptionsModule appelle ModelApplication.undoChanges→BaseSerializer.undo puis viewApp.deactivate. La branche true active la vue. Ce callback conditionnel est le déclencheur de restauration;le clic seul ne suffit pas.
Consommateurs actuels conservés :main charge les réglages et applique EnvironmentQuality,native_user_settings lit les couches de configuration,native_graphics_options fournit la lecture entière et F11 conserve sa fonction. Recherche des quatre noms exacts de fermeture/undo sur1168sources :zéro occurrence. Cela ne prouve pas l’absence de tout équivalent autrement nommé;aucun éditeur/transaction actuel n’est qualifié ici.

## R4 — Restauration,états et contrôles
Journal régulier :setValue retient la valeur précédente;addSerialize conserve le premier previousValue pour la clé,remplace les éditions intermédiaires et retire l’entrée lors d’un retour à cette valeur. La clé concatène strategy+section+nom. Undo réassigne valueItem et émet CHANGE;les effets de tous les listeners ne sont pas qualifiés.
Journal live :la première entrée conserve getUndoLiveData pour sa clé,basée sur valueSinceLastSave. Les aperçus ultérieurs ne remplacent pas ce baseline. Undo envoie les entrées de restauration via GameSerializer.liveSerializeAction→Update,strategy live,section,entries(key,value). Aucun résultat du bridge n’est consulté;reset suit les appels revenus normalement. Ce n’est pas une preuve de restauration atomique,persistée ou confirmée.
NativeUpdate82FFD0 refuse le conteneur non-array et ignore les éléments de type inadéquat. Le littéral live est associé à la valeur mise en cache puis sélectionne le handler82F880 via831330. L’application de chaque réglage dans ce handler reste ouverte;aucun succès n’est déduit de la seule registration.
Button.handleMouseRelease retourne si désactivé,mais le listener MouseEvent d’Annuler est séparé et son handler n’a pas de garde enabled. Aucune affectation directe _cancelButton.enabled trouvée dans ViewApplication. La politique spécifique,timeline,hit-testing et input physique restent non qualifiés;le retour du handler générique ne prouve pas la suppression des autres listeners.
14méthodes bytecode,8fonctions natives,35instructions fixes,paires de callbacks,vtable et littéraux contrôlés. Cas de source,pas des exécutions paramétrées originales :

### C1
- Attendu : Cancel and small close button request the same close callback without invoking undo directly.
- Observé : Both MouseEvent.CLICK bindings point to onCancelClick;that method calls CloseMenu only. Wrapper may use a registered override;otherwise flash.external is invoked.
- Limite : No physical click or native bridge execution;component/model/sprite prerequisites and overrides remain unobserved.

### C2
- Attendu : An active nonnull Options pointer in the native manager requests hidden visibility and attempts the usual queue flush.
- Observé : 82453B/4541 skip null/inactive;virtual18 maps82E730→7841E0. Native active flag is cleared before queue-null check;payload sets isVisible=false,playSounds argument1. Existing queue guards still apply.
- Limite : Return AL1 from manager is not proof that frontend received false;missing comm/bindings/phase and exceptions are not executed.

### C3
- Attendu : Frontend false visibility triggers undo then deactivate;true visibility activates instead.
- Observé : FoundryOptionsModule.SetVisibility branches on Boolean(isVisible);false calls modelApp.undoChanges→serializer.undo before viewApp.deactivate.
- Limite : No acknowledgement/exception safety inferred;undo throwing would not prove later deactivation.

### C4
- Attendu : Regular changes preserve the first previous value for a key through successive edits and restore that value locally.
- Observé : addSerialize retains old previousValue;returning to that value removes the entry. SerializeData.undo delegates to owner;SerializeableValue.undo assigns previousValue and dispatches CHANGE.
- Limite : Direct implementation has no native write call;all event-subscriber feedback and uniqueness of concatenated keys are not qualified.

### C5
- Attendu : Live previews preserve one undo payload for the key and request its baseline value on cancellation.
- Observé : liveSerialize caches getUndoLiveData only on first key;payload uses valueSinceLastSave. undo calls liveSerializeAction for saved live entries,which sends strategy live through Update.
- Limite : Across-key order/native per-setting effects and atomic success unqualified;only requests are established.

### C6
- Attendu : An empty journal causes no direct restore callback from the two loops;reset still emits change/no-longer-changes events.
- Observé : undo iterates both dictionaries then reset. serialize normal-return path commits/emits then resets,so a later close with no new journal entries has nothing to restore.
- Limite : Save is a boundary comparison only,not a completed Save audit;new asynchronous changes and listener effects may create further entries.

### C7
- Attendu : A normal bridge return is not an acknowledged rollback;native Update has container/type refusals.
- Observé : GameSerializer.liveSerializeAction ignores ExternalInterface return. Native82FFD0 skips non-array argument and unsupported element types;live nominal route selects82F880 via831330. Undo resets after calls return.
- Limite : Actual native per-setting application,partial failures,thrown exceptions and persistence remain unqualified;no atomic transaction guarantee.

### C8
- Attendu : Disabled Button behavior is separated from a Cancel-specific disabled policy.
- Observé : Generic Button.handleMouseRelease returns when !enabled. ViewApplication has no direct _cancelButton.enabled assignment and onCancelClick has no own enabled guard;its MouseEvent listener is separate.
- Limite : Generic release return does not prove other listeners are suppressed. Full Flash hit-testing,timeline values and actual disabled Cancel input are not executed.

## R5 — Manques et conditions de reprise
Prérequis :sprites/contrôles,modèle,serializer,manager et bridge valides;aucun refus sûr inventé pour leur absence. Aucun try/finally ou accusé global n’est établi pour undo. Exceptions,perte de message,traitement partiel,ordre entre clés et feedback des vues restent distincts. Une fermeture native ignorée/inactive ou une file sans communication ne prouve pas que le frontend a reçu false.
- **CANCEL-NATIVE-APPLY-ACK** — Manque : Native per-setting application,persistence,acknowledgements and complete failure/exception/event feedback are not qualified. Reprise : Use Update live dispatch831330→82F880 for one named setting and the existing queue guards;do not treat callback return or frontend journal reset as confirmed restoration.
- **CANCEL-CURRENT-UI-STATES** — Manque : Current Cancel/editor consumer and Cancel-specific disabled/timeline/hit-testing/focus behavior are not established in the inspected scope. Reprise : Reuse exact source searches and existing input/settings audits;separate authorized product work and physical observations from this static audit.
- **OPTIONS-OTHER-CONTROLS** — Manque : Other Options controls,selected movie/context,InternalPanel and complete visible control graph remain open. Reprise : Choose the next independently verifiable control or a named provider/context source;reuse existing306exports and all preserved native contracts.

## R6 — Correction réutilisée
**HUD-OPTIONS-ENTRY-01** conserve sa définition et son statut proposé,non appliqué. Avancée documentaire :contrat Annuler/fermeture,journaux,baseline,requêtes et limites refus/ack. Aucune nouvelle fiche concurrente ni modification du registre. La partie édition/annulation réelle de ce parcours reste ouverte.
Prochain résultat précis :suivre le handler live82F880 pour un réglage nommé,ou qualifier un autre contrôle à partir des exports déjà conservés. Pas de réexport identique,de recherche générale ni de reconstruction de données sans nouvelle piste.

## R7 — Livraison,relecture et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CANCEL-01\options-cancel-proof.json`. Reçus,p-code,logs,scripts et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CANCEL-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CANCEL-01\delivery-readback.json`;elle seule peut clore le sous-lot après sept rubriques.
Cinq registres,25fichiers gelés et1168sources inchangés;Git HEAD/branche/76modifications antérieures conservés. Movie,XML,PE et preuves antérieures conservés. Goal,critères,application de suivi,interface et bases inchangés;aucun accès runtime au suivi/bases,aucune installation ou migration.
Clôture limitée au contrat statique Annuler/fermeture et à ses manques explicités. SYS-17.5-01 et SYS-01.2-02 restent ouverts;aucune fonctionnalité actuelle,annulation confirmée,menu/jeu complet ou acceptation humaine revendiqués.
