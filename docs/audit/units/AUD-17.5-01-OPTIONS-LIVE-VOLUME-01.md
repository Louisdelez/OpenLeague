# AUD-17.5-01-OPTIONS-LIVE-VOLUME-01

UTC : 2026-10-31T06:37:51.144532+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Un seul réglage nommé : [Volume]MasterVolume. Le contrat de dispatch live,sa souscription et son appel natif immédiat sont audités. Les autres volumes,mute et menu complet restent distincts. Audit terminé côté producteur;clôture réservée à la relecture séparée. Fonctionnalité actuelle non modifiée;acceptation humaine non demandée.

## R2 — Sources,provenance et vérification
PE original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. XML : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` — SHA256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de`. VA préférées0x400000;les rôles sont des interprétations analytiques,pas des symboles PDB.
306exports AS3 antérieurs réutilisés par identité;aucun réexport ni bytecode exécuté. Les nouvelles méthodes sont lues dans cet export;les14comparaisons bytecode de l’annulation restent héritées,pas de nouvelle prétention de comparaison brute de chaque méthode ici. PE/XML/movie,versions Python/pefile/Capstone/DLL et scripts sont épinglés.

## R3 — Ressource et consommateurs réels
XML ligne75 : `<mastersoundslider scale="1" ini="[Volume]MasterVolume" muteini="MasterMute" playsoundonchange="Options_Click2" updateondrag="true">`.
ModelFactory associe mastersoundslider à ModelMasterSoundSlider,qui hérite ModelSoundSlider. Celui-ci possède un ModelSlider pour le volume et un SerializeableValue distinct pour mute. ViewFactory crée ViewMasterSoundSlider;ViewSoundSlider relie le ModelSlider à ViewSlider. Le handler live appelle setLiveValue puis le serializer existant.
Le scale1 est divisé par100;la valeur live suit round(value*scale*1000)/1000. L’exemple50→0.5 est un calcul analytique,pas une exécution AS. Le baseline d’annulation et Update sont ceux du sous-lot précédent,conservé.
831330 lit data/section/entries/key/value puis appelle le handler choisi. 82F880 forme la clé [section]nom,consulte le dispatcher global2D78568,table+8,et appelle virtual08 sur chaque souscripteur. Aucune validation complète des propriétés imbriquées n’est déduite des seuls tests de type de l’enveloppe.
Le préfixe6F96D0..6F97A0 construit [Volume]MasterVolume et un callback(vtable1086078,ownerESI,cible6FA030),puis appelle82D410 mode2. Ce mode réplique la demande pour les tables0 et8. Le clonage et le thunk virtual08 conservent/délèguent la cible. La souscription effective et toute la fonction d’initialisation ne sont pas observées.
6FA030 convertit la chaîne viaC9BB65,passe un float32 à6F7AD0 avec catégorie0. Ce dernier interroge le backend global2D78B98 au slot0C;seul retour1 poursuit. La catégorie est obtenue au slot4C,puis sa valeur est demandée au backend par slot88. La cible réelle du backend et l’effet audible restent inconnus.
Consommateurs actuels :lecteur Game.cfg et son appel de démarrage conservés;le vrai lecteur audio optionnel R Ezreal utilise LOCAL_GAIN0.20 et une atténuation locale. La recherche insensible à la casse de MasterVolume/master_volume/master volume sur1168sources n’a aucun résultat. Cela ne prouve pas l’absence universelle d’un équivalent autrement nommé.

## R4 — Cas attendus et observations
14plages alignées :13fonctions complètes et un préfixe explicitement partiel. 57instructions fixes,littéraux,vtable et scalaire1.0 sont vérifiés. Analyse statique exécutée;aucun client,AS,x86,Rust,GUI,entrée physique,audio ou réseau exécuté. Les diagnostics ne sont pas des pannes observées.

### C1
- Attendu : The named master sound slider routes live values to Volume/MasterVolume and keeps mute on a separate SerializeableValue.
- Observé : XML scale1/updateondrag true,ModelSoundSlider owns ModelSlider;ViewSlider.onLiveChange delegates through ModelSlider and InteractiveModelComponent into SerializeableValue.liveSerialize.
- Limite : Source wiring only;actual selected movie,sprites,enabled state,event ordering,mute cascade and physical drag unobserved.

### C2
- Attendu : UI nominal value50 is converted using the authored scale before an Update request;Cancel uses the previously qualified first baseline.
- Observé : SCALE_MODIFIER100,scale1,round(value*0.01*1000)/1000 gives0.5 as an analytical example. Existing live journal stores first valueSinceLastSave and sends Update on undo.
- Limite : Arithmetic example is not AS execution or an observed original value. Invalid/nonfinite conversion and event feedback remain unqualified.

### C3
- Attendu : Live data entries reach the matching subscriber key and a nonempty callback list is iterated.
- Observé : 831330 reads data/section/entries/key/value and invokes selected handler;82F880 constructs [section]key,looks up dispatcher+8 and calls each stored callback virtual08 with the value string.
- Limite : Container/type guards from prior audit remain distinct. Current historical map membership,template allocation correctness and all dynamic subscribers not executed.

### C4
- Attendu : Missing key or an empty subscriber list does not prove applied volume and does not synthesize an acknowledgement.
- Observé : Missing key jumps82FB6E to No subscribers diagnostic;empty list jumps82FB8A cleanup. Callback results are not checked by this notification loop.
- Limite : Diagnostic is a static string/path,not an observed failure. Corrupt/null callback entries and exceptions are not proven safe refusals.

### C5
- Attendu : MasterVolume has an identifiable registration candidate and immediate volume callback under successful construction/subscription.
- Observé : 6F96D0 prefix builds [Volume]MasterVolume,callback vtable1086078 with owner and6FA030,then calls82D410 mode2. Mode2 requests both maps;virtual08 thunk delegates to stored member target.
- Limite : Prefix only,not whole initializer. Allocation/clone failure is visible but safe null handling,registration execution and lifetime are not qualified.

### C6
- Attendu : The master callback converts the value and requests category0 volume only after the backend gate returns1.
- Observé : 6FA030 calls numeric wrapperC9BB65 then passes float32 with ECX0 to6F7AD0. That function checks backend virtual0C==1,obtains category via virtual4C,and calls backend virtual88.
- Limite : Virtual names are analyst roles. Pointer validity,actual backend target,audibility and numeric lexical semantics remain unobserved.

### C7
- Attendu : Finite values below0/above1 are replaced with0/1 before the backend request;local apply failure is diagnosed.
- Observé : Two COMISS branches select writes0/3F800000 with matching diagnostics. Slot88 false reaches unsuccessfully diagnostic;the master callback does not inspect an application result.
- Limite : Finite comparison contract only;unordered floats/parser behavior,assert/logger effects and frontend confirmation are not qualified.

### C8
- Attendu : Existing current configuration/audio consumers are preserved without falsely qualifying a current MasterVolume editor.
- Observé : Verified1168source query has no exact MasterVolume spelling. Real config startup and fixed LOCAL_GAIN0.20 audio gain still exist;prior SYS-16.4-02/03 gaps are reused.
- Limite : Exact-name absence is bounded. No current code,config,migration,Rust execution,physical playback or tracker/database access performed.

## R5 — Écarts et conditions de reprise
Clé absente :82FB6E mène au diagnostic No subscribers. Liste vide :82FB8A nettoie sans invocation. Ces chemins ne constituent pas un refus sûr des pointeurs nuls,callbacks malformés ou exceptions. Les allocations/clone peuvent échouer;aucune garantie de récupération n’est inventée.
Pour les valeurs finies,les comparaisons natives bornent à0/1 et produisent les diagnostics correspondants. La grammaire numérique,la locale et les NaN/inf ne sont pas qualifiés. Un backend non prêt saute l’appel;le backend lui-même est déréférencé avant ce test,donc aucune sécurité de pointeur nul n’est établie.
Slot88 faux mène au diagnostic unsuccessfully. Ce résultat local n’est ni contrôlé par le callback de volume ni transformé en accusé frontend. Aucun effet audible,rollback confirmé,écriture de configuration ou persistance n’est établi.
- **MASTER-RUNTIME-BACKEND** — Manque : Historical subscription and backend2D78B98 identity,ready state,slot88 implementation,physical output and acknowledgement remain unobserved. Reprise : Use the pinned category0 callback and identify the actual backend/vtable plus an explicitly authorized device/runtime fixture;do not use a callback return or local log as audible success.
- **MASTER-CONVERSION-PERSISTENCE** — Manque : Complete numeric lexical/locale/nonfinite semantics,all event feedback,regular/savecfg persistence and allocation/lifetime failure safety are not qualified. Reprise : Trace C9BB65→C9BA4E for a named conversion question or separate savecfg contract for persistence;do not rerun unchanged journal/disassembly or claim atomic rollback.
- **MASTER-CURRENT-CONTROLS** — Manque : Current MasterVolume editor/category application and the other Options controls remain open;existing fixed gain and general config loader are partial consumers. Reprise : Reuse SYS-16.4-02/03 plus HUD-OPTIONS-ENTRY-01 criteria with separately authorized product work;keep local audio,input,focus and persistence checks independent.

## R6 — Corrections réutilisées
HUD-OPTIONS-ENTRY-01 garde sa définition et son statut proposé,non appliqué. SYS-16.4-02 et SYS-16.4-03 existent pour réglages audio/mute;leurs fiches et inconnues sont recopiées par référence dans la preuve,pas modifiées. Le reçu audio V120 est réutilisé :ses anciens tests ne sont pas de nouvelles exécutions.
Avancée :le destinataire natif d’un réglage live est nommé;appel,garde,borne finie et retour local sont distingués de l’application confirmée. Aucune fiche concurrente ni modification de registre. Les autres contrôles et l’implémentation restent ouverts.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIVE-VOLUME-01\options-live-volume-proof.json`. Spécification/scripts isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIVE-VOLUME-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIVE-VOLUME-01\delivery-readback.json`;elle seule clôt ce sous-lot après contrôle des sept rubriques.
Cinq registres,25fichiers gelés et1168sources conservés par empreinte;Git HEAD/branche/76modifications antérieures inchangés. Goal,critères,suivi,interface et bases inchangés. Aucune installation,migration,modification produit ou exécution d’un chargeur de configuration.
Clôture limitée au contrat statique MasterVolume et à ses manques nommés. SYS-17.5-01,SYS-16.4-02/03 et SYS-01.2-02 restent ouverts;aucun contrôle actuel,menu,backend ou jeu complet déclaré terminé.
