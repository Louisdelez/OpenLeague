# AUD-17.5-01-OPTIONS-LINE-MISSILE-VIS-SETTING-01 — EnableLineMissileVis

## R1 — Portée et décision

Checkbox117 et option33 : source de préférence, propagation d’un flag dans deux contextes d’affichage, consommateurs actuels. Audit borné seulement, producteur non clôturant ; relecture distincte requise. Fonctionnalité, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Pas de validation humaine ou de résultat global sur les sorts.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS épinglés. en_GB744 Enable line missile display. Defaults140=1/user34=1/deploy36=1 ; read32 initial avec arguments0/0 et GFXfallback0 distincts du provider effectif non observé. La première occurrence de la sous-chaîne clé est dans la clé complète ; clé indépendante10C25C0 et références836365/836D71 vérifiées, pas d’absence déduite du premier pointeur sans ref.

19fragments/3constantes checkbox et champ SerializeableValue24strategy=regular relus ; aucun strategy/updateonclick sur contrôle/ancêtres. Save, bool, subscriber et indexed update réutilisés. Ancien audit range-preview : matrice488sources/septDDS et20CPUtests antérieurs à sources identiques conservés, aucun decoder/DDS/PNG/export/test/lecteur ancien rejoué. Deux CastRange absents, écartVarusf32 et alias DefaultRangeIndicator restent dans leur portée existante.

## R3 — Contrat et consommateurs réels

**Menu et abonnement.** regular par défaut/no-live.8343FC capture837C40, mode2 ;82D410 réutilisé développe2 vers0 et1, map normale0 et live+8. Ce n’est pas live-only et cela ne rend pas updateonclick implicite. Callback bool6F5930→835440(33,bool). Helper partagé ignore même valeur, copie la configuration avant postdispatch ; table33→837837retour simple, donc pas d’absence d’effet natif déduite de ce retour.

**Valeur.**83634C initialise33, lit HUD/EnableLineMissileVis via8B1C20 arguments0/0 et stockeEAX32 ; différent du getterbool et du callback. Keytable33→836D71→10C25C0.835080 renvoie node14 si trouvé ; sinon991E60diagnostic puis0 si cet appel retourne. Invalides/overlays, lifetime/host et caractère nonfatal du diagnostic non qualifiés.

**Deux chemins réels.**7749C0 et774AC0 lisent33, testentEAX non nul et placent le bool au byteD d’un contexte local : EBP−0F relativement à EBP−1C, ESP+2D relativement à ESP+20. Pointeur passé à virtual+4 des enfants. Premier chemin appelle aussi virtual+10/+14 et fonctions géométriques ; second parcourt lookup/collections, avec gates empty/missing. False n’évite pas ces boucles externes : le child décide du rôle exact deD. Vtable concrète/lectureD, phase/caller/profil, géométrie/texture et draw final ouverts. Ne pas qualifier preview-only, masquage de tous projectiles, mode de lancement ou collision depuis le nom.

**Courant.** Audit preview repris : vrai spell_input/dispatch avec send_action, terrain/ray/caméra et guards, projections Annie et EzrealR après lancement, E display-range utilisé par gameplay et Q géométrie existent. Précisément, ces routes ne démontrent pas un aperçu avant confirmation ni l’effet du flag33. Rawcfg et map générique présents ; startup mappe EnvironmentQuality16. Recherche nommée bornée1168fichiers sans route EnableLineMissileVis ; pas d’absence générale des projectiles/ressources ou de leur rendu. Ne pas convertir le flag en collision serveur ou supprimer des VFX après lancement par analogie.

## R4 — Attendu et observé

Sept cas : déclaration/défauts, abonnement, lecture/missing diagnostic, propagation de contexte, acquis actuels, reprise des preuves et application/Save non exécutés. 8fenêtres et36instructions attendues nouvelles ; tables33, bool/subscriber/indexed partagés vérifiés par octets/identités. Actuelles sources7 correspondent aux anciens20CPUtests, sans réexécution ou promotion en GUI. Cinq registres,25protégés, corpus et Git conservés.

Python/source documentaire uniquement. Aucun x86/AS/Rust/jeu/GUI/input/réseau/config loader, ancien test/lecteur/export, installation/migration/restart. Nominal visuel0/1, refus/missing-context/owner/focus/session et cancel/default/Save/reload non observés. Map/byteD/branche statique ne tiennent pas lieu de résultat visible ou durable.

## R5 — Manques et reprise

- LINEVIS-NATIVE-TEMPLATE : child virtual+4/contextD, phase/profil/geometry/resource/draw ouverts. Reprendre un enfant de774A3C ou774BB6 et son caller, sinon contrat local explicite autorisé ; PREVIEW-NATIVE-CONTROLLER conservé, pas d’inventaire global répété.
- LINEVIS-CURRENT-BINDING : pas de route nommée actuelle malgré cfg/map/input/projections présents. Raccord autorisé d’un typedflag et profil/render/owner qualifiés ; intention/surface preview seulement si sa phase est établie.
- LINEVIS-RESOURCE-APPLICABILITY : profil/alias/provider/width/range précis non liés au child. Réutiliser488matrice/septDDS/anciens manques, pas de fallback au hasard ou second décodage général. PREVIEW-RESOURCE/SURFACE restent distincts.
- LINEVIS-LIFECYCLE-SAVE :0/1/same/missing/context/profil, teardown/focus/session/owner et cancel/default/Save/reload non exécutés. Build/assets/provider/profil et autorisation produit requis, preuves source/CPU/GUI séparées.

Impacts et conditions discriminantes dans la preuve. Ces limites restent ouvertes après le seul audit limité, sans maintenir artificiellement celui-ci ouvert faute de fonctionnalité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY et PREVIEW-NATIVE-CONTROLLER/INTENT/RESOURCE/SURFACE conservés textuellement. Proposition HUD-LINE-MISSILE-VIS-SETTING-01 : un profil nommé, préférence33→contexteD→effet0/1 qualifié, avec refus/lifecycle/Save réels ; pas les488sorts, collision ou tous VFX. Réutilisation preview conditionnée à la phase réellement qualifiée, aucune équivalence forcée. Proposition non appliquée, aucun registre modifié.

Prochain lot ShowAttackRadius118 : portée affichée, portée/collision d’attaque et aperçu de sort distincts ; preuves existantes d’abord. Non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LINE-MISSILE-VIS-SETTING-01\line-missile-vis-setting-proof.json` SHA256 `94bcdccfda6e58203632968be812f650c95a1cee7c10a93c42c89d150f4de35f` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LINE-MISSILE-VIS-SETTING-01\verify_line_missile_vis_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LINE-MISSILE-VIS-SETTING-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés, nouveaux documents isolés uniquement.
