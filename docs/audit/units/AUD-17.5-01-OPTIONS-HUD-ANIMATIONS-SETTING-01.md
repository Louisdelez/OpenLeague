# AUD-17.5-01-OPTIONS-HUD-ANIMATIONS-SETTING-01 — EnableHUDAnimations

## R1 — Portée et décision

Un checkbox ligne102, stratégie/live/undo et trajet HUD inspecté. Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur seul non clôturant, relecture séparée attendue. Animations de champions/effets hors périmètre. Contrat/source audités, raccord fonctionnel incomplet, rendu/runtime non exécuté, acceptation humaine non demandée.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index et export AS épinglés. en_GB742 : Enable HUD animations. Pas de clé exacte dans les deux defaults fournis ; user51=0 et deploy44=0. Source cfg effectivement sélectionnée non observée. Aucune corruption/default1/valeurhistorique déduite de l’absence de clé ou d’une préférence utilisateur.

ShowSlows/relecture336, checkbox19fragments/3constantes, stratégie regular LossOfControlEnabled, Save, abonnement live du volume et helpers natifs partagés réutilisés par empreintes. Le volume ne qualifie ici que le mécanisme live/map8, pas son gain/clamp/backend. Ancien audit layout et corrections motion/group conservés. Aucun ancien export/test/lecteur exécuté.

## R3 — Contrat et consommateurs réels

**AS.** Pas de strategy sur contrôle/ancêtres, getAttrib renvoie stringnull et SerializeableValue conserve regular. updateonclick=true satisfait le gate bool. receiveModelChange et onClick appellent applyLiveUpdate→setLiveValue, donc ne pas réduire le contrat au seul clic ni annoncer un nombre/order exact d’événements rendus. Journal normal regular distinct du live ; BaseSerializer conserve le premier undo par clé strategy+section+iniName, SerializeData copie previousValue comme valeur de rollback. Annulation requiert owner undo et live actions ; Save commit/reset commun. Ce sont des requêtes, pas des acquittements de rendu ou de persistance.

**Natif.**820260 enregistre la clé complète avec callback820BB0 et paramètre2 via82D410. Live/map8 partagé qualifié antérieurement.820BB0 convertit via6F5930 puis835440(index42,bool), avant de tester controller=objet capturé+100. Si nul, retour après mise à jour de l’état. Si vrai,7DC3B0 ; si faux, éventuelle méthode virtuelle18(1) lorsque le contrôleur global2D77E54+CC/state30 le permet, puis7DC410(1) et7D4380.

7DC3B0 gardé par global/controller, éventuellement7DBD70 selon local718 et méthode virtuelle14(1) selon state30, puis7DC410(0) et7D4380. Le reset inspecté est un préfixe d’écriture de champs (dont C2480000 et flag38) ; identité entière du contrôleur, modes7DC410, temps/easing/clock/état visible et géométrie finale restent ouverts. Ne pas qualifier toutes les animations depuis cette clé.

L’initialiseur index42 appelle des requêtes835080 et choisit BL0/1 selon comparaisons à2 ; premier argument de requête hors fenêtre, autres paramètres16/15. Après appel virtuelB0,8B1C20 lit Performance/EnableHUDAnimations avec cette valeur calculée comme défaut. Ce n’est pas un défaut universel ou une classification hardware établie. Le case de retour de nom836DB7 est identifié sans lui attribuer une table de dispatch non suivie. Bool6F5930 et update835440 réutilisés ; invalid/string/locale/provider limits conservés, aucune exécution native.

**Courant.** native_hud_layout::transform supporte offsets d’élément et de parent si include_motion. native_hud_groups mémorise des frames pendant rebind, pas un producteur temporel d’animation. Le provider initial utilise frame0/invalid. native_hud_viewport invalide les unions sur changement de dimensions ; ce n’est pas une progression animée. Les layouts panel/text/recharge passent include_motion=false/group_offset=None ; union bounds statique fait aussi false selon son contrat natif, pas un défaut à corriger par un remplacement global.

Le rendu de recharge continue à consommer snapshot/tick, et un EffectClock canonique existe déjà avec ses limites de scheduling. Ces mécanismes ne prouvent pas le raccord EnableHUDAnimations. Recherche bornée1168fichiers complétée par les chemins réels : pas de réglage nommé trouvé, mais helpers/membership/cache/valeurs dynamiques préservés. Aucun arrêt des clocks de gameplay ou animations des champions autorisé par analogie.

## R4 — Attendu et observé

Sept cas consignés : regular/live, baseline undo, défaut calculé, callback/index42, mécanismes existants, garde controller nul et application/persistance restant ouvertes. Six fenêtres natives nouvelles,38instructions attendues, bool/indexed-update communs relus par octets sans refaire leur analyse. Sources/AS/corpus, cinq registres,25fichiers protégés et Git vérifiés. Aucun x86/AS/Rust/jeu/GUI/input/réseau/loader productif, export, installation/migration/restart ou ancien test/lecteur exécuté. Une mise à jour de map avant retour nul ne vaut pas effet visuel ou succès signalé au frontend.

## R5 — Manques et reprise

- ANIM-NATIVE-CONTROLLER : type owner+100,7DBD70/7DC410 et reset complet/clock/easing/draw ouverts. Reprise sur un contrôleur/transition nommé ou contrat local versionné explicitement autorisé, sans refaire callback42.
- ANIM-CURRENT-TRANSITION : helpers existants, producteur motion/group et raccord de réglage manquants dans les chemins inspectés. Réutiliser HUD-LAYOUT-ELEMENT-MOTION-01/GROUP-OFFSET-01 pour une transition, sans forcer les bounds statiques ou dupliquer un moteur d’animation.
- ANIM-LIVE-RESTORE : requêtes sync/clic, application réelle/annulation/Save, contrôleur absent, interruption/session/window/recovery non exécutés. Build/assets/controller et cycle contrôlé autorisé requis.
- ANIM-DEFAULT-PERSISTENCE : contexte des requêtes de défaut, cfg/provider sélectionné, default/Save/Close/reload durables inconnus. Reprise sur valeurs/contextes nommés et cycle/fichier/acquittement explicites ; missing default key/user0/GFXfallback0 ne suffisent pas.

Chaque manque possède impact et entrée précise dans la preuve ; il reste ouvert après le seul audit documentaire limité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01, HUD-LAYOUT-ELEMENT-MOTION-01 et HUD-LAYOUT-GROUP-OFFSET-01 réutilisées textuellement. Proposition HUD-ANIMATIONS-SETTING-01 porte uniquement le raccord regular/live/undo d’une transition qualifiée et dépend des corrections motion existantes. Aucun deuxième moteur ni audit de toutes les animations. Critères0/1/cancel/interruption/null/recovery et défaut/persistance détaillés ; proposition non appliquée, aucun registre modifié.

Prochain lot : FlashScreenWhenDamaged ligne106, savecfg. Distinguer flash écran, événements de dégâts et effets déjà présents ; pas de nouvel audit de tout le combat. Lot non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HUD-ANIMATIONS-SETTING-01\hud-animations-setting-proof.json` SHA256 `13183f16ec651ded6144ef82538919a23aeaeb2ebd43f6c693c9754f677decde` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HUD-ANIMATIONS-SETTING-01\verify_hud_animations_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HUD-ANIMATIONS-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; fonctionnalité/parent/goal ouverts. Nouveaux documents isolés seulement, goal/critères, code/assets, suivi/interface/bases, registres et preuves antérieures inchangés.
