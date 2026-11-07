# AUD-17.5-01-OPTIONS-NEUTRAL-CAMPS-SETTING-01 — ShowNeutralCamps

## R1 — Portée et décision

Checkbox131 et chemin des marqueurs de camps neutres, distinct des monstres/gameplay et de tout FoW/minimap. Audit documentaire limité, producteur non clôturant/relecture séparée requise. Fonctionnalité, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Aucune acceptation humaine ou validation globale.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS épinglés. enGB786 Show Neutral Camps. Deux sections source : General27=1 etHUD85=1 dans defaults/copieF, aucun override exact user/deploy. Garder leurs identités séparées, fallbacknatif1/GFX0/provider effectif distincts. Contrairement au dropdown précédent,19fragments checkbox repris depuis AttackRadius ; savecfg explicite + updateonclicktrue. Save/live/undo/subscriber/bool acquis réutilisés, aucune ancienne exécution rejouée.

Audits minimapentités etFoW/readbacks propres réutilisés ; nativeINI17707bytes SHA197b401b... et anciens assets/champs restent preuves d’entrée, pas de sélecteurMap10 retrouvé. Six tests marqueurs pertinents sur19CPU/10pins conservés, non rejoués, ni preuve de camps/GPU ou toutes dépendances.

## R3 — Contrat et consommateurs réels

**Réglage.**804073 litglobal2D79104/objet10bit2. Si set : HUD/ShowNeutralCamps via8B1910 ; sinon General/ShowNeutralCamps via8B17B0/receiverEBX. Deux chemins exclusifs, pas General→HUDoverride. Les deux ont fallback1 et stockentF1 ; sensflag/provider effectif ouverts.7FF3AF captureEDI/807510, mode2 normal/live partagé. Callback complet6F5930→ownerF1, sans clearqueue ou ackdraw/save synchrone. Source checkbox live/sync/click et baseline/undo ne prouvent pas restauration de marqueur ou persistance.

**Collection.**8023F0 préfixe réinitialise91C/service64 puis flagF1false saute première collection vers802573 ; le reste de minimap continue horsfenêtre. Tree2D78910 : entry160 doit être non nul et chaîne12C de taille13C non vide. Ce n’est pas un test santé ou une règle de visibilité identifié. Nom→806950 : cache owner8C0 renvoie node28 si trouvé ; missprefix alloue7C/7FC780, chargement/fallback/provider/lifetime restent ouverts.

**Taille et sortie.** Pour valeurs finies ordonnées/C8nonzero seulement : r=(ownerB4×float1138A14)×(float1138C74/ownerC8), choisi=min(max(r,style38),style34). Constantes exactes1.0 et0.001168224262073636 ; dimensions style2C/30 multipliées. Rôles owner/style/invalides/NaN/bornes inversées non qualifiés, pas de test numérique natif. Virtual14→payload puis803380queue, pas de preuve de flush/position/texture/pixels ou disparition immédiate. Ce fragment enrichit la tâche existante MM-MARKER-SCALE sans la clore.

**Courant.** Camps et scheduler privés existent : membres/spawn_at, mort complète puis respawn d’unités team2 ; UnitDTO porte camp:Optionu8. Le renderer réel filtre Monster/Boss par kind et n’admet que team0/1 ; ajout d’un style seul insuffisant. Joueurs/unités/relique, projection, assets, viewport/session/ownedretirement existent ; relic→HealthPack reste bridge local distinct. Camp connu/clear/respawn/autorisation de marqueur non prouvés par existence ou absence d’un body Snapshot filtré. Ne pas exposer spawn_at privé ou déduire mort depuis brouillard. ShaderFoW n’est pas une autorité d’étatcamp. Aucune reconstruction des monstres/assets motivée par ce seul raccord manquant.

Recherche bornée1168fichiers sans route nommée ShowNeutralCamps/ResMutLoaded, complétée par vrais bodies/source cfg ; pas d’absence globale de mobs, ressources, vision ou état mutable.

## R4 — Attendu et observé

Sept cas : déclaration/défauts, callback/live, admission collection, style/taille, acquis actuels, reprise d’évidence et application/Save ouverts. 5fenêtres/38instructions nouvelles et deux constantes ; helpers partagés/19fragments et sources actuelles vérifiés. Cinq registres/25protégés/corpus/Git inchangés.

Python/source documentaire seulement. Pas d’AS/x86/Rust/jeu/GUI/input/réseau/loader, ancien test/lecteur/export, install/migration/restart. Nominal0/1/liveundo/default/cancel/Save/reload, divergencesGeneral/HUD, hidden/dead/respawn/ressource/viewport/session/owner non exécutés ; cachedbyte/queue/source/CPUne valent pas rendu ou fidélité du savoir historique.

## R5 — Manques et reprise

- NEUTRALCAMPS-NATIVE-PRODUCER : bit2/provider, collection/name12C/flag160 etMap10/knownstate ouverts. Reprise producteur nommé ou contrat local autorisé, pas de nouvel inventaire global.
- NEUTRALCAMPS-CURRENT-MARKERS : Monster/Boss etteam2 non raccordés malgré gameplay/campID/scheduler existants. Reprendre état de camp admis et MM-MONSTER/BOSS ; ne pas déclarer flux générique manquant ni utiliser timer privé/absencebody comme vérité publique.
- NEUTRALCAMPS-STYLE-OUTPUT : nom→style/provider/fallback/coordonnées/queueflush/draw etsens des champsscale ouverts. Reprise entrée nommée806950/803380 et MM-MARKER-SCALE/STYLE, pas d’aliasEpic/Baron→Vilemaw ou texture inventée.
- NEUTRALCAMPS-LIVE-SAVE-LIFECYCLE : effets0/1/liveundo/durable, branchesGeneral/HUD etcas hidden/death/respawn/viewport/session/services non exécutés. Build/assets/provider/famille autorisés requis, source/CPU/GPU séparés.

Impacts et conditions discriminantes dans preuve ; limites ouvertes après seul audit borné.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY, MM-MONSTER/BOSS/MARKER-SCALE/STYLE-MODES conservés textuellement. Seule proposition HUD-NEUTRAL-CAMPS-SETTING-01 : préférence et marqueurs admis, une famille ordinaire d’abord, autres familles suivies jusqu’à qualification/suppression justifiée. Pas de réécriture du gameplay/AI ou de toute FoW, aucun registre modifié, proposition non appliquée.

Prochain FlipMiniMap132 : disposition/orientation/interactions distinctes, layout/projection/input existants d’abord. Non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NEUTRAL-CAMPS-SETTING-01\neutral-camps-setting-proof.json` SHA256 `7308ec536bc9f90abd33e16b139b93c50255464bfebfb5a32fd6567012c9d1f6` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NEUTRAL-CAMPS-SETTING-01\verify_neutral_camps_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NEUTRAL-CAMPS-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json/INDEPENDENT-REVIEW.md. Seul périmètre documentaire pourra être clos ; Goal/critères, code/assets, Plan/UI/bases, registres/anciennes preuves inchangés, nouveaux documents isolés seulement.
