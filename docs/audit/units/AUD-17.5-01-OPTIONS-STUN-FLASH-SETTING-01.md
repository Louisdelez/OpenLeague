# AUD-17.5-01-OPTIONS-STUN-FLASH-SETTING-01 — FlashScreenWhenStunned

## R1 — Portée et décision

Checkbox ligne107, source du flash de perte de contrôle et consommateurs actuels. Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur seul non clôturant, relecture séparée attendue ; fonctionnalité incomplète, exécution/rendu non vérifiés, acceptation humaine non demandée. Ne pas réduire l’étiquette native loss of control à tous les éléments du seul type Rust Stun.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index/export AS épinglés. en_GB749 : Screen flash on loss of control. Defaults fournis sans clé, user37=1, autre override sans clé ; constructeur argument1/0 et GFXfallback0 distincts, provider effectivement choisi inconnu.

Texture native `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Images\Vision\LoL_InGame_Stun.dds`,786560bytes/SHA256 `e13f0aec60064770d6b3e1d44cd33e5ec8e56e58f24f52d2428b2dd8ab52bd7b`, DDS1024x768DXT3. Record OLS-8d790391-1606-5e68-bc26-e0ea577bef3b correspond aux octets/SHA/MD5 de membre sélectionné core0.0.1.7/contenu0.0.0.142 ; précédence runtime non qualifiée. Différente de Hit. Basename exacte absente seulement dans cinq ZIPs actuellement sélectionnés, pas dans tous packs/alias par conclusion globale. Aucun décodage, conversion, copie ou reconstruction.

Damage/relecture411, checkbox19fragments/3constantes/Save/bool et audit LossOfControlEnabled/relecture422 réutilisés par identités. Aucun ancien lecteur/test/export natif rejoué. Méthodes et offsets damage ne sont pas appliqués par ressemblance au Stun.

## R3 — Contrat et consommateurs réels

**Menu.** savecfg explicite, aucun updateonclick ; chaîne null manquante ne satisfait pas le gate live. Contrat canonique0/1/NEGATEVIEW/CLIK et journal/Save réutilisés, sans clic physique ou acquittement de rendu/persistance inféré.

**Natif.**82C700 associe82D050 ; callback bool6F5930, owner+10→screen object preference19.7E0F10 charge LoL_InGame_Stun.dds au champ14 et lit HUD/FlashScreenWhenStunned avec argument1. active18 est séparé, contrairement à damage owner0C/preference11/active10/texture0C.

7E0F80 active18 sans garde positive directe, stocke premier argumentD au champ4 et temps GameClock au0, puis paramètres8=200,C=130,10=.25. Deuxième slot de pile non lu dans le corps malgré ret8 ; ne pas lui inventer un bool/événement. Invariant GameClock initialisé requis, voie diagnostic/write0 jamais exécutée.

7E1000 teste préférence19/active18 avant temps. Pour entrées finies ordinaires, t=elapsed/(D+.25),u=1−t ; forme algébrique alpha=200u³+3×130u²t+3×130ut², terme final0. Ordre d’opérations float conservé dans la preuve, pas de test numérique natif ou promesse de parité hôte. Conversion entier/octet bas ; trois autres octetsFF, texture14 et rectangle986AD0. Expiration stricte elapsed>D+.25 ; égalité atteint alpha0/draw. Ce n’est pas le fade linéaire damage. Off ne prouve pas clear/reset/pause car retour avant temps ; UV/blend/projection/clock discontinuities et pixel parity ouverts.

Le préfixe caller7D8D25 compare un candidat flottant à max(0,Dprécédent−temps écoulé). Seulement si plus grand, switch des IDs2..11, tous sauf7, vers7E0F80. Cela démontre une règle durée/restant/retrigger et non un blink inconditionnel chaque frame. Noms de catégories, producteur candidat, sujet/profil, horloge et entrée complète7D8620 non qualifiés ; ne pas nommer7 comme slow/stun/silence sans preuve.

Un candidat brut de référence de la clé à5EBE62 est explicitement rejeté : les quatre octets du pointeur recouvrent opcode/displacement d’un call5FCA80. Ce n’est pas une lecture de l’adresse de chaîne. L’exploration5EBE61 non alignée ne constitue aucune preuve de consommateur ou d’absence ; aucune recherche de ce faux chemin poursuivie.

**Courant.** Stun(tag,source,expires_at), active, API serveur/gardes/expiry, refus move/attack/cast existent. DTO Snapshot clonent les corps stuns, filtrés par destinataire et reçus/committés ; QWER/D/F utilisent déjà des états d’autorisation et le debug affiche du restant de stun. Le contexte authentifié owner/epoch/readiness est disponible pour UI, EffectClock existe ; sa correspondance avec deadlines/tick n’est pas établie pour ce flash.

Ces états sont des acquis à réutiliser. Ils ne qualifient pas le mapping de toutes catégories natives, le retrigger ou le rendu écran. On ne réclame pas d’emblée un nouveau flux d’événements générique : décider après qualification de la règle native et de ce que les états courants fournissent réellement. Pas de route nommée trouvée dans1168fichiers, conclusion complétée par producteurs/DTO/consommateurs réels, sans absence globale de CC/VFX.

## R4 — Attendu et observé

Sept cas : configuration/label, Save, état propre, caller/curve, fauxxref, ressource/acquis courants et application/refus ouverts. Sept fenêtres natives nouvelles,46instructions attendues, constantes1/3 et table numérique explicites ; bool commun par octets. DDS/header/SHA/MD5/record et cinq central directories exactes vérifiés sans extraction. Corpus/Git, cinq registres et25fichiers protégés conservés.

Contrôles documentaires Python seulement. Aucun x86/AS/Rust/jeu/GUI/input/réseau/loader productif, ancien test/lecteur/export, installation/migration/restart exécuté. Types natifs/invalid/direct-call/nonfinite, clock/pause, vrais événements/états reçus et rendu ne sont pas validés par les contrôles de source.

## R5 — Manques et reprise

- STUNFLASH-NATIVE-CATEGORY : producteur7D8620, nomsIDs/sujet/profil/durée/retrigger/clock/GPU ouverts. Reprise sur un candidat/type nommé ou trace discriminante, contrat local explicite autorisé possible ; fauxxref5EBE62 exclu.
- STUNFLASH-CURRENT-TRANSITION : Stun/deadlines présents, mapping de catégorie/durée et clock manquant pour cette UI. Réutiliser l’état supporté pour un sujet authentifié et établir s’il faut des métadonnées d’événement, sans les inventer d’avance.
- STUNFLASH-CURRENT-DRAW : préférence/active/curve et DDS sélectionné non raccordés au vrai rendu. Source DDS déjà présente ; route asset/manifest/clock/viewport et comparaison à qualifier sous autorisation produit, pas copier le fade linéaire damage.
- STUNFLASH-APPLIED-SAVE :0/1/candidat court-long/refresh/compétition/expiry/refus/owner/dead/session/window et Save/cancel/default/reload non exécutés. Build/assets/provider et cycle contrôlé requis, pas une clôture fonctionnelle depuis le code lu.

Impacts et conditions précises dans la preuve ; manques toujours ouverts après le seul audit borné.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01, BUFF-LOSS-CONTROL-01 et HUD-DAMAGE-FLASH-SETTING-01 réutilisées textuellement comme périmètres liés, sans imposer toute la future UI d’icônes comme prérequis. Proposition HUD-STUN-FLASH-SETTING-01 limitée à catégorie/transition qualifiées, état/clock et son écran/réglage distincts. Pas de deuxième moteur CC, all-stun/all-CC ou flux générique fictif. Critères source/current et rendu/refus/lifecycle/Save réellement exercés détaillés ; proposition non appliquée et aucun registre modifié.

Prochain lot : ObjectTooltips ligne108. Distinguer tooltips monde/cible/objet des tooltips de sorts/boutique déjà présents avant toute conclusion. Lot suivant non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-STUN-FLASH-SETTING-01\stun-flash-setting-proof.json` SHA256 `33a875b52b420ec89c6f857010b14e9b50b732e5f4a09dbda8ef20c6a7858999` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-STUN-FLASH-SETTING-01\verify_stun_flash_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-STUN-FLASH-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; fonctionnalité/parent/goal ouverts. Nouveaux documents isolés seulement ; goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés.
