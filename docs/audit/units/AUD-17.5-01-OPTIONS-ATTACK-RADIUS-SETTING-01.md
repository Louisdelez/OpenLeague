# AUD-17.5-01-OPTIONS-ATTACK-RADIUS-SETTING-01 — ShowAttackRadius

## R1 — Portée et décision

Checkbox118 : source d’une préférence d’affichage de portée, distincte de la portée serveur/collision, attack-move et aperçu de sort. Audit source/current limité, producteur non clôturant ; relecture séparée requise. Fonctionnalité, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts, aucune acceptation humaine ou résultat global.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS épinglés. en_GB784 Show Attack Range. Defaults83/user31/deploy33=1, ctorboolargument0 et read32indexed0/0 séparés du provider non observé. regular par défaut, champ24source, pas de strategy/updateonclick hérité ; Save/subscriber/bool/indexed partagés repris.

Audits attackmove et range-preview propres réutilisés, sources/consommateurs concrets inspectés. Neuf anciensCPUtests/10sources identiques retenus, aucun ancien test/lecteur/export/decoder ou inventaire de ressources rejoué. Un premier appel de diagnostic shell avait un chemin Python erroné : aucune analyse n’y a exécuté ; outil corrigé vers runtime existant, aucune installation. La recherche locale initiale de lecture341 était trop courte ; une recherche exacte de l’opérande dans .text fournit7ED15D, ensuite validé dans fonction alignée7ED110, pas d’absence déduite du premier résultat vide.

## R3 — Contrat et consommateurs réels

**États distincts.**7EA567 litbool HUD/ShowAttackRadius vers cache341.8362B8 lit32vers index39 ; keytable39→836D5D.8201AA captureEDI/contexte vers855130/callback820A90, mode2 ; adapter/thunk/receiver/lifetimes non entièrement qualifiés, aucune règle receiver+4 copiée par analogie. Callback complet : source inline/heap selon capacity14>=16, C998CC→835440(39,EAX), puis6F5930 séparé→controllerFC/341 si présent. Controller nul saute seulement le cache après changement de l’index. C998CCtail appelleC9B9FA avec10/null ; grammaire/invalides/overflow non qualifiés ni assimilés au bool. Helpers partagés et mode2normal+live0/+8 vérifiés, pas de dispatchlive implicite dans AS. Post39retour après changehelper ne prouve pas absence d’effet.

**Admission7ED110.**76DD00 non nul saute toute sortie. Primaire si virtual360 vrai OU cache338 non nul OU (context8/30==2 ET cache341 non nul). Donc off n’interdit pas universellement l’affichage. Noms des états360/338/type2 ouverts : ne pas appeler ce type attack-move ou inventer une règle maintien/curseur. Après primaire, virtual364 contrôle une seconde sortie indépendamment de341.

**Arguments.** Primaire : vecteur acteur virtual14, composante centrale+.1binary32 bits3DCCCCCD ; rayon = résultat x87virtual8C + actor770 ; base direction3E0.v20/champs20/24/28 ; pointeurpalette123EF98 transmis à775170. Identité/unités des contributions et format palette ne sont pas déduits des offsets. Mot brutFFFFFFFF enregistré, pas interprété comme floats/couleur complète. Prefix775170 garde service2D79078 puis prépare géométrie/call774C70 ; reste, shape/matériau/provider/rendu non qualifiés. Secondaire : même somme/vecteur mais garde2D77E54 puis+D4 avant804770. Deux consommateurs distincts, pas une équivalence de rendu prouvée. Aucune observation d’un cercle ou GPU.

**Courant.** Move/Attack/Stop, poursuite d’une cible choisie, contraintes santé/équipe/protection/visibilité, sélection ray/radius et transport viewer existent. Poursuite/attaque valident attack_range+rayon de la cible ; cela ne qualifie pas la somme visuelle native8C+770 et ne doit pas être réutilisé silencieusement comme cercle. Config générique/mapstartup16 présents ; pas de route nommée ShowAttackRadius/display dans1168fichiers inspectés. Conclusion complétée par13vrais fragments attackmove, pas une absence générale de portée/combat/collision ou de tous les visuels. Le loader productif n’a pas été appelé.

## R4 — Attendu et observé

Sept cas : déclaration/défaut, callback à deux voies, admission/bypass/refus, sorties/arguments, acquis actuels, preuves reprises et application/Save non exécutés. 8fenêtres et45instructions attendues nouvelles ; tables39, lift.1 et motpalette bruts ; helpers partagés par octets. Cinq registres,25protégés, corpus et Git conservés.

Python/source documentaire seulement. Pas de x86/AS/Rust/jeu/GUI/input/réseau/loader, ancien test/lecteur/export, installation/migration/restart. Nominal visuel0/1/forced-state, controller/service absent, modified-range, invalides/lifecycle/focus/session et cancel/default/Save/reload non exécutés. Callback/map/cache/call ne prouvent ni effet visible ni disponibilité ou persistance.

## R5 — Manques et reprise

- ATTACKRADIUS-NATIVE-PREDICATE : significations360/338/type2/364, adapter/receiver et contributions/unités8C+770 ouverts. Reprise sur producteur/getter nommé7ED110 ou855130, sinon contrat local explicite autorisé ; pas de nouvel inventaire global.
- ATTACKRADIUS-CURRENT-DISPLAY : pas de raccord nommé malgré commandes/poursuite/portée existantes. Reprise typed preference/cache et actor/session/owner/profile/render qualifiés, sans modifier l’autorité d’attaque ou inventer attaque-déplacement.
- ATTACKRADIUS-RESOURCE : continuation775170/matériau/shape/palette et804770/provider/draw ouverts. Reprise d’une primitive/ressource ou référence réelle identifiée ; ne pas déclarer texture manquante ou cercle conforme depuis arguments/septDDS existants.
- ATTACKRADIUS-SAVE-LIFECYCLE :0/1/bypass/null-controller/noncanonical/modified-range, focus/session/end/death et cancel/default/Save/reload non exécutés. Build/assets/provider/profile autorisés requis ; résultats physiques distincts des9anciensCPUtests.

Impacts et entrées de reprise précis dans la preuve. Ces limites restent ouvertes après le seul audit borné, sans clore la fonctionnalité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY, PREVIEW-NATIVE-CONTROLLER/SURFACE et CONTROL-NATIVE-ACTION conservés textuellement, avec applicabilité bornée. Une proposition HUD-ATTACK-RADIUS-SETTING-01 porte ce réglage/prédicat/rayon/affichage0/1 qualifié ; pas tous les sorts, ordres attackmove ou correction de la formule serveur. Critères et refus/lifecycle/Save décrits, non appliqués, aucun registre modifié.

Prochain lot dropdown NumericCooldownFormat122/options0..3 ; vrais formateurs/recharges existants d’abord. Non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTACK-RADIUS-SETTING-01\attack-radius-setting-proof.json` SHA256 `1185ad6a1da51287658ad797a55209a21d052b3e5e2065569418512e82f4b29a` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTACK-RADIUS-SETTING-01\verify_attack_radius_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTACK-RADIUS-SETTING-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos. Goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés ; nouveaux documents isolés uniquement.
