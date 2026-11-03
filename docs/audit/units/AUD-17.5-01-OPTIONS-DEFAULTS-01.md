# AUD-17.5-01-OPTIONS-DEFAULTS-01

UTC : 2026-10-31T06:55:51.878804+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin
Bouton Restaurer les valeurs par défaut :panneau actif,traversal,origines des valeurs et callback de lecture immédiat. Audit terminé côté producteur;clôture réservée à la relecture indépendante. Fonctionnalité actuelle non modifiée;vérification statique seulement;acceptation humaine non demandée. Chaque widget,menu complet et comportement physique restent distincts.

## R2 — Sources et identité
PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Movie : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptions.gfx` — SHA256 `77b99d636e8f22bdf3249a250342cf4d0cc96fd4d18a752c12b65ca6e976a74b`. XML : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` — SHA256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de`. VA préférées0x400000,rôles analytiques,pas symboles PDB ou adresses live.
306exports AS3 conservés;méthodes pertinentes lues sans réexport. Quatre nouvelles méthodes sont retrouvées dans le DoABC par octets uniques. Les autres méthodes sont des sources de l’export identifié,pas une nouvelle comparaison brute de chacune. Python,pefile,Capstone/DLL et scripts/helpers sont identifiés.

## R3 — Consommateurs réels
defaultsLabel=flash_optionsMenu_defaultsLabel rejoint placedButtons[4] et _defaultsButton. Le clic ne traite que activePanel.revertChildrenToDefaults. ViewPanel délègue au modèle;UnifBaseModel parcourt les enfants instanciés. Ce n’est pas un reset de tous les panneaux ni du XML brut. Sans panneau,le bloc restauration/désactivation/son est sauté.
Après retour normal de la restauration,le bouton est désactivé. activatePanel et handleSerializerDataChanged le réactivent. Le handler n’a pas de garde enabled propre;événements,réentrance,focus et suppression physique des clics désactivés restent non qualifiés.
Huit overrides ordinaires recensés :checkbox,input,graphics slider,slider,dropdown,sound slider,keybind et quickbind. Checkbox/input/graphics utilisent le lecteur config avec leurs fallbacks;slider peut préférer un default datasource truthy et applique son scale;dropdown peut préférer defaultIndexFromDatasource. SoundSlider restaure son slider et mute séparés. KeyBind parcourt ses userKeys et copie les defaults déjà stockés;QuickBind utilise defaultKey/defaultLocalizedKey puis defaultCastOnly. Les producteurs de ces données et tous leurs effets ne sont pas qualifiés.
Utility.ReadGameCfgDefault renvoie directement le fallback en ENV_GFXPLAYER. Sinon il appelle HandleReadGameCfgDefaultEntry;les modèles possèdent aussi leurs branches d’environnement et leurs valeurs debug. Les tests d’attributs gardent leur OR exact;aucune validation des deux attributs n’est inventée.
786E20 enregistre HandleReadGameCfgDefaultEntry→787290 et le lecteur courant→7871A0. Le callback default décompacte trois arguments GFx et appelle8B0630 avec DATA/CFG/defaults/Game.cfg,buffer partagé2D86D98,capacité13A0 et drapeau final0. Il construit ensuite la réponse depuis ce buffer. Le lecteur courant emploie8B15D0. Aucun refus sûr des arguments absents/malformés ni résultat effectif n’est établi.
Fichiers defaults natif et actuel :14789octets,SHA256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`,identiques. Les lignes natives153/216 portent MasterVolume=1.0 et EnvironmentQuality=3. Ce sont des valeurs rédigées dans les fichiers,pas des résultats runtime ou des effets appliqués.
Consommateurs actuels conservés :environment_default et lecture des defaults au démarrage. Le vrai chargeur peut migrer;il n’est pas exécuté. Recherche des quatre noms exacts du bouton sur1168sources :aucun résultat,ce qui n’exclut pas un équivalent autrement nommé.

## R4 — Cas et contrôles exécutés
4méthodes bytecode,3fonctions natives complètes,23instructions fixes et huit overrides AS vérifiés. Aucun x86,AS,Rust,GUI,input physique,réseau,émulation,appel de getter original ou écriture de configuration exécuté.

### C1
- Attendu : The Defaults label and click select the instantiated active panel subtree rather than resetting the entire menu or raw XML.
- Observé : Root defaultsLabel reaches placedButtons[4]. handleDefaultsClick checks activePanel then ViewPanel delegates to modelClass.restoreDefaults;UnifBaseModel recursively calls only its instantiated children.
- Limite : Model construction/filtering and all dynamic children are not executed. Other panel siblings and unseen resources are not assumed covered.

### C2
- Attendu : Without activePanel,the click performs no panel restore,button-disable or sound call in its own body.
- Observé : The full restore/disabled/sound block is under if(activePanel). With normal return,restore precedes enabled=false. Panel activation and serializer-data-change handlers reenable the button.
- Limite : Property transitions only;physical disabled click suppression,focus,reentrancy and asynchronous events are not qualified.

### C3
- Attendu : Restoration keeps widget-specific default sources separate instead of forcing a universal numeric or config value.
- Observé : Eight override methods exist:checkbox/input/graphics/slider/dropdown/sound/keybind/quickbind. Slider/dropdown can prefer datasource defaults;key handlers restore their loaded defaults,while config readers use per-widget fallback.
- Limite : All scalar conversions,normalization,default datasource/key producers,indirect subclasses and actual results per widget remain unqualified.

### C4
- Attendu : GFXPLAYER read fallback is separated from native default-file access and from other environment branches.
- Observé : Utility.ReadGameCfgDefault returns param3 directly for ENV_GFXPLAYER;otherwise it calls HandleReadGameCfgDefaultEntry. Models separately gate on environments/attributes or use debug/data defaults.
- Limite : Effective environment was not observed. Attribute tests use the exact authored OR expression,not a proven requirement that both attributes are valid.

### C5
- Attendu : The native default callback has a precise registration and a distinct getter request from the ordinary config callback.
- Observé : 786E20 registers default→787290 and ordinary→7871A0. Default unpacks3GFx arguments and calls8B0630 with DATA/CFG/defaults/Game.cfg,buffer2D86D98,capacity13A0 and trailing0;ordinary calls8B15D0.
- Limite : The callback does not establish safe rejection of missing/malformed arguments. Effective provider/cache,flags semantics and original getter results are not newly qualified.

### C6
- Attendu : An existing defaults file copy and its authored entries are source evidence,not proof of actual applied or returned defaults.
- Observé : Native/current Game.cfg are identical14789bytes,SHA02c41c...;authored MasterVolume1.0 and EnvironmentQuality3 are present. Native callback builds a response from the shared buffer after the getter call.
- Limite : No original getter executed here. Shared buffer ownership,concurrency,truncation,overlays and runtime output are unobserved.

### C7
- Attendu : Defaults modifications participate in the existing edit journal and may later be canceled or saved;the button is not a journal reset or direct save.
- Observé : Restore overrides call setValue;InteractiveModelComponent delegates to SerializeableValue. Existing addSerialize keeps first previousValue. Defaults handler has no serialize/reset/close/native-write call;Cancel/Save are separately pinned.
- Limite : Restored value equal to baseline can remove a journal entry. Event/listener feedback,live preview and actual persistence remain separate;no atomic rollback guarantee.

### C8
- Attendu : Current default readers and matching data are preserved without declaring a panel Defaults UI implemented.
- Observé : Exact query over1168sources has no Defaults hook names. Real environment_default and startup default-path/config readers exist;the identical current Game.cfg copy is retained.
- Limite : Exact names do not prove universal absence. No loader,Rust,GUI,input or configuration write executed;current feature,parent and game remain open.

## R5 — Écarts et reprise
Les appels setValue rejoignent le journal existant;le handler Defaults ne vide pas ce journal,ne sauvegarde pas et ne ferme pas directement. Une valeur égale au baseline peut retirer une entrée. Les effets indirects des listeners,previews et widgets ne sont pas entièrement qualifiés;les limites d’Annuler/Save restent héritées.
- **DEFAULTS-PROVIDER-CONTEXT** — Manque : Native8B0630 effective provider/cache/overlay selection,callback argument safety,shared buffer lifetime/concurrency and actual returned defaults are unobserved. Reprise : Use a named setting and explicit provider/cache context with prior getter evidence;qualify actual result/truncation separately and never convert authored Game.cfg values into runtime measurements.
- **DEFAULTS-WIDGET-TREE** — Manque : Effective model-tree membership,all8family effects,datasource/key producers,event/live-preview feedback and disabled/focus behavior remain unqualified. Reprise : Choose one named widget/source producer with existing exports;reuse traversal and known journal contracts rather than re-scanning the whole client. Physical UI checks require a separate authorized runtime scope.
- **DEFAULTS-CURRENT-EDITOR** — Manque : Current active-panel Defaults editor,its Cancel/Save integration,persistence and complete menu coverage remain open. Reprise : Reuse HUD-OPTIONS-ENTRY-01 with preserved readers/data;verify one panel,unmodified other panels,equality/no-change,invalid inputs,Cancel,Save and focus as separate observable criteria.

## R6 — Correction réutilisée
HUD-OPTIONS-ENTRY-01 garde sa définition,son statut proposé et ses critères inchangés. Avancée documentaire :portée du bouton,états,récursion,huit familles et lecteur de défaut. Aucune nouvelle correction concurrente,modification de registre ou reconstruction implicite du produit.
Une future implémentation doit conserver les lecteurs/données et qualifier un panneau,ses widgets,les autres panneaux inchangés,les égalités/no-change,Annuler,Save et le focus. Aucun reset global ou valeur fournie à la place d’une source manquante.

## R7 — Livraison et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DEFAULTS-01\options-defaults-proof.json`. Spécification/scripts isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DEFAULTS-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DEFAULTS-01\delivery-readback.json`;elle seule clôt le sous-lot après sept rubriques.
Cinq registres,25fichiers gelés,1168sources,Git HEAD/branche/76modifications antérieures,PE/movies/XML et deux Game.cfg conservés. Goal,critères,Plan/UI/bases inchangés. Aucune installation,migration,restart du suivi ou exécution du chargeur productif.
Clôture limitée au contrat statique Defaults et à ses manques nommés. SYS-17.5-01 et SYS-01.2-02 restent ouverts;aucune fonctionnalité actuelle,origine effective de chaque default,menu ou jeu complet déclaré terminé.
