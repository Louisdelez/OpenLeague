# AUD-17.5-01-OPTIONS-AUTO-DISPLAY-TARGET-SETTING-01 — AutoDisplayTarget

## R1 — Portée et décision

Checkbox116 : préférence d’affichage automatique du cadre cible sur attaque, distincte de l’inspection explicite et des commandes de combat. Audit limité au contrat source et consommateurs actuels ; producteur non clôturant, relecture distincte requise. Fonctionnalité, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts, aucune acceptation humaine.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS et bool/subscriber épinglés. en_GB731 Show Target Frame on attack. Defaults82=1 dans source/copieF, user/deploy sans clé exacte ; ctorargument1 et GFXfallback0 distincts du provider effectif non observé. savecfg explicite/no updateonclick sur contrôle/ancêtres ; absence stringnull ne passe pas le gate live.

Checkbox19fragments/3constantes et Save réutilisés ; même source ≠ clic physique, ack/backend appliqué ou fichier durable. Ancien audit target et sa relecture clos sur leur propre périmètre :89records57Icon/24Text/8Effect, entrées et limites natives conservées. Aucun ancien décodeur/test/lecteur/export ou inventaire complet d’archives rejoué.

## R3 — Contrat et consommateurs réels

**Réglage.**7F92F9→8B1910 lit HUD/AutoDisplayTarget argument1, écrit byte1E. Registration82CFA5 capture ownerEBX/callback82D0B0, mode0 de82D410. Callback complet : bool6F5930 puis receiver+4→owner+24→byte1E. Aucun null-check, store selected18 ou appel de clear/close ; faux ne supprime pas directement une sélection affichée. Lifetimes/dispatch effectifs non exécutés.

**Admission automatique.**7F9E10 retourne si selected18 non nul ; compare inputID avec un mot obtenu via objet local+124/vtable10, saute égalité ;5BDD80 doit résoudre un objet, puis cache1E vrai et object1C bit12 ou13 requis. Alors7F98C0(inputID). Signification du getter, noms des bits, classes/équipe/visibilité non inventés.7F9B80 emploie la même famille de gate dans un prédicat lié. Ce n’est pas une politique universelle d’inspection.

**Point d’appel et publication.**7FAC40 chemin d’ordre ciblé, branche7FAD41 si objet résolu local présent ;74E9D0 fournit l’ID et module+24 appelle7F9E10. Kind d’action/phase/acceptation serveur/hit non qualifiés : ne pas remplacer par un événement de dégâts ou déclarer une attaque acceptée depuis ce seul appel.7F98C0 écrit selected18 puis teste virtualB0 ; branche admise résout objet/fallback, valeur via128/vtable4, payload tagAF et dispatch virtual30/numeric13/args1et0. Le receiver/UI/TargetBar final n’est pas tracé. Store/request ≠ cadre observé. Helper séparé7F99E0 appelle ce setter avec0 si selected18 existe ; existence du clear ne fixe pas toutes ses politiques mort/brouillard/session.

**Courant.** Provider/repair conservent ressources natives et réparation TargetBar_Buffs ; deux occurrences actuelles sont ce chemin et son test. Les sélecteurs de texte/bar/panels/portrait admettent leurs éléments locaux existants, pas le cadre cible dynamique qualifié. Picker enemy-only→Action::Attack et transport/commit Snapshot existent ; attack_events est déjà projeté avec audience, corps filtrés. Ne pas inventer un flux générique absent ni transformer target_info pub(crate) en API publique. Config générique/initialiseur présents, non exécutés car create/rename possibles.

Recherche bornée1168fichiers : motifs AutoDisplayTarget/selected inspection0, TargetBar/TargetImage2chemins resource/test ; conclusion complétée par les vrais consommateurs. Pas d’absence générale des ressources, textures ou attaques, ni de preuve que les89records parsés sont rendus.

## R4 — Attendu et observé

Sept cas : déclaration/défaut, callback, admission0/1/existing/invalid/masks, state/publication/clear, acquis actuels, ownership/refus et application/Save non exécutés. 8fenêtres et40instructions attendues nouvelles ; source bool/subscriber partagée vérifiée par octets/identités. Registres5, protégés25, corpus et Git conservés.

Contrôles Python documentaires seulement. Aucun x86/AS/Rust/jeu/GUI/input/réseau/config loader, ancien test/lecteur/export, install/migration/restart. Nominal visuel et refus/applied0/1/clear/phase d’attaque, annulation/default/Save/reload restent sans observation runtime ; une branche statique n’en tient pas lieu.

## R5 — Manques et reprise

- AUTOTARGET-NATIVE-EFFECT : ordre/phase, masque12/13, getter et receiver13/AF→frame ouverts. Reprise sur caller7FAD5E/gate7F9E10 ou virtual30 depuis7F98C0, sinon contrat local explicite autorisé ; pas d’inventaire global répété.
- AUTOTARGET-CURRENT-STATE : préférence et identité stable du frame non raccordées ; intent/attack_events déjà présents. Reprendre ownership/session/entity publics et phase qualifiée en réutilisant TARGET-01/02, sans exposer target_info interne.
- AUTOTARGET-FRAME : activation et portrait/champs restent les corrections target existantes ; parsé ≠ rendu. Reprendre TARGET-03 activation/receiver, sans second chantier de tous les champs ni nouvelle recherche de textures déclarées manquantes.
- AUTOTARGET-SAVE-LIFECYCLE :0/1 vide/déjà sélectionné/manuel/clear, invalid/hidden/dead/removed/session et cancel/default/Save/reload non exécutés. Build/assets/provider/state/frame autorisés requis, cas TARGET-10 conservés ; callback faux ne justifie pas fermeture automatique.

Impacts et entrées de reprise précis dans la preuve. Ils restent ouverts après ce seul audit, sans bloquer sa clôture documentaire bornée.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et TARGET-01-SELECTION/02-PUBLIC/03-FRAME/10-LIFECYCLE conservées textuellement. Une proposition HUD-AUTO-DISPLAY-TARGET-SETTING-01 porte seulement préférence/auto-admission/hook et coexistence sélection explicite ; pas de réécriture de tous stats/portrait/inventaire. Dépendance activation du frame TARGET-03 ciblée, pas totalité de ses champs. Critères source/local-policy, état public, nominal/refus/applied/Save détaillés ; non appliquée, aucun registre changé.

Prochain lot EnableLineMissileVis117 : indicateur de ciblage distinct du projectile rendu et de la collision, audits existants d’abord. Non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-AUTO-DISPLAY-TARGET-SETTING-01\auto-display-target-setting-proof.json` SHA256 `6f3a210546e8392256b9692ca1daccc336907b2baa16503b8407318c35ab0ff8` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-AUTO-DISPLAY-TARGET-SETTING-01\verify_auto_display_target_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-AUTO-DISPLAY-TARGET-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos. Goal/critères, produit/assets, suivi/interface/bases, registres et anciennes preuves inchangés ; nouveaux documents isolés uniquement.
