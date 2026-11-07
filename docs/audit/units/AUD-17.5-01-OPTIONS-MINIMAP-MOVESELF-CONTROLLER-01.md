# MinimapMoveSelf — complément du contrôleur natif

## R1 — Portée et décision

Date 2026-10-31T15:59:40.067030+00:00, AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-CONTROLLER-01, parent SYS-17.5-01, goal SYS-01.2-02. Delta MMSELF-NATIVE-EFFECT du lot MoveSelf133 déjà relu. Fin : propre callback/cache et un effet conditionnel utile, ou limite exacte ; pas un nouvel audit identique. Producteur non clôturant ; relecture séparée requise. Fonctionnalité, parent, goal et acceptation ouverts.

## R2 — Sources et réutilisation

PE4.20 SHA `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/export/19checkboxfragments/3constantes, Save/live/bool/subscriber épinglés. XML133 savecfg+updateonclicktrue. Sources actuelles8fragments et26ancienscasCPU/receipts/logs/data identiques, non rejoués ; query nommée ancienne réutilisée après corpus1168inchangé. Pas de nouvelle archive ou extraction, pas de doublon de correction.

Defaults original/copieF : HUD/MinimapMoveSelf=1 ligne81. User/deploy : aucun des deux noms. Aucun DisableMinimapMovement dans ces quatrefichiers. Source physique nouvelle != provider/historique effectif. Garder les deux identités et polarités, pas de remplacement de clé ou migration appliquée.

## R3 — Résultat et consommateurs

82020E nomme [HUD]MinimapMoveSelf, captureEDI avec callback820AE0, mode2 normal/live. Callback bool6F5930 puis TEST/SETE→ownerF5 : valeur canonique1 désactive le drapeau de désactivation,0 l’active. SourceUI/live/undo ne prouve pas application ni Save.

Init81F114 lit au contraire [HUD]DisableMinimapMovement via8B1910 fallback0/selector0, stockeF5 directement.834D96 lit cette ancienne clé en entier0, NEG/SBB/INC produit1 pourzero/0 pournonzero, demande écriture8B2990 de la nouvelle clé. Contexte extérieur/ordre/provider/durabilité non qualifiés ; ce code n’a pas été exécuté. Ne pas confondre integerzero-test, boolgetter et sharedbool du callback.

Identité statique :81F070..820216, 4518octets décodés, une seule écriture expliciteEDI à81F0A4 depuisglobal2D77E54, aucunRET avant capture. Correspondance source sous ABI x86 ordinaire callee-saved, pas une preuve d’identité/session/lifetime en exécution. Les recherches de champs ont d’abord été bornées puis élargies une seule fois à un motif direct8bits, car le consommateur était hors du module inspecté ; les candidats Reset8249C0 sont des objets enfants, non attribués à ce flag.

7DF710 complet : globalnull ou helper825D60false continue à7DF829 ; sinon globalF5nonzero saute au cleanup7DF95B avant écriturescoordonnées/demande620190(code2)/callbacks ultérieurs. F5zero autorise les autres conditions, sans garantir une action. RetourALzero commun n’est pas un acquittement de refus/succès. Le code2 n’est pas déclaré identique à RustActionMove sans contrat supplémentaire ; bouton physique/caméra/pings/autresgestes ouverts.

825D60 complet : globalD4 optionnel, flagsA64nonzero/BCzero ou prédicat78C380false retournent0. Sinon requête807020/convert8009F0 puis1. Corps/sens des flags/predicate/transform et événement amont ne sont pas reconstruits depuis leurs offsets. Le nullguard du caller n’est pas supposé présent partout.

Actuel : camera/Move, inverse, Live.rect, capture fraîche/identité, focus/session/UI/terrain/transport existent. Input réel n’utilise pas le réglage, ses26ancienscasCPU ne qualifient pas le toggle. Aucun changement de mouvement ou de ressources créé ici.

## R4 — Attendu et observé

Sept cas dans preuve : réutilisation, polarité, init/conversion, refus conditionnel, gardeshelper, acquisactuels et application/Save non exécutés. 6fenêtres/44attentes nouvelles, traceEDI bornée et helpers partagés vérifiés. Fenêtres exploratoires horsfrontière ne sont pas retenues : livraison utilise seulement bornes alignées contrôlées.

Analyse statique/Python/hash readonly uniquement. Pas de jeu/x86/AS/Rust/GUI/OSinput/réseau/loader/exécution ou émulation originale, ancien test/lecteur/export, install/migration/restart. Toggle0/1/conflictoldnew/cancel/default/liveundo/Save/reload, événements physiques/refus/state/session/window/transport non exercés. Cinq registres/25protégés/corpus/Git conservés.

## R5 — Manques et reprise

- MMSELF-NATIVE-EFFECT : callback/polarité/init/conversion et un gate natif identifiés ; restent provider/ordre des clés/definition, event/button/code2 et helpers/flags. Reprendre un seul caller amont ou corps807020/78C380/8009F0 ou provider discriminant, sans refaire un scan global.
- MMSELF-CURRENT-BRIDGE : input ne consomme pas le réglage malgré Move existant. Reprise produit distincte autorisée, contrat0/1qualifié/explicite et gardes actuelles conservées.
- MMSELF-UI-RUNTIME : définition/NEGATEVIEW/timeline/disabled/événements physiques non exécutés ; build/menu/owner/scénario autorisés nécessaires.
- MMSELF-LIVE-PERSISTENCE : subscriber trouvé, file/provider durable et cycle/appliedack/oppositelegacynew/conflicts ouverts ; aucune migration implicite.

Chaque manque garde ID, impact et condition de reprise. Un gate sous conditions ne prouve pas toute l’entrée ou le jeu.

## R6 — Correction conservée et suite

HUD-MINIMAP-MOVESELF-SETTING-01 exacte et autres corrections acquises conservées, source ajoutée seulement ; aucune nouvelle correction appliquée ni registre modifié. Ne pas recoder camera/navigation pour combler ce seul raccord.

Suite : ShowTimestamps137, d’abord audit chat existant AUD-17.2-08-CHAT-01 ; propre préférence/consumer ou limite, pas d’inventaire chat répété.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-CONTROLLER-01\minimap-moveself-controller-proof.json` SHA `21403fb21e215b628c2e3818dea838f9e04b8dd41c6661f297ee78a3eba8a598`, producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-CONTROLLER-01\verify_minimap_moveself_controller.py`, fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-CONTROLLER-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json/INDEPENDENT-REVIEW.md. Seul complément documentaire peut être clos ; Goal/critères, code/assets, Plan/UI/bases, registres/anciensdocuments/preuves inchangés, nouveaux fichiers isolés seulement.
