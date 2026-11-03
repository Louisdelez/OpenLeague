# AUD-17.5-01-OPTIONS-DAMAGE-FLASH-SETTING-01 — FlashScreenWhenDamaged

## R1 — Portée et décision

Checkbox ligne106, source du flash écran et consommateur actuel : dégâts, données reçues, affichage. Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur seul non clôturant ; relecture séparée attendue. Audit distinct de la fonctionnalité incomplète et de la vérification en jeu non exécutée ; acceptation humaine non demandée.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index et export AS épinglés. en_GB748 : Screen flash on damage. Deux defaults fournis sans clé, user40=1, autre override sans clé ; constructeur natif argument1/0, GFXfallback0 et source effectivement sélectionnée séparés.

Texture originale `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Images\Vision\LoL_InGame_Hit.dds` :786560bytes, SHA256 `8dfabe51973327150e968fab114fcabaec79e011c5016d013a745b9360961fb5`, DDS1024x768DXT3. Record OLS-294ade5a-e802-5525-8ba2-54b66205963f : membre exact sélectionné coreprojet0.0.1.7/contenu0.0.0.142 et MD5 concordant, preuve d’appartenance antérieure réutilisée, précédence runtime toujours ouverte. Pas de nouvelle image, copie, décodage ou conversion. La recherche exacte de basename dans les cinq ZIPs du native_zip_catalog courant ne la trouve pas ; ce n’est pas l’absence de toute ressource/alias/pack du projet. Route de sélection actuelle non prouvée.

Checkbox19fragments/3constantes, Save, helpers bool et audit HP local réutilisés par identités. Les anciens tests/lecteurs/exports ne sont pas relancés. Rapports numériques et stuns non assimilés au flash écran.

## R3 — Contrat et consommateurs réels

**Menu.** [HUD]FlashScreenWhenDamaged, savecfg explicite. Aucun updateonclick : chaîne sentinel null ne satisfait pas makeValueToBool. Canonical0/1, NEGATEVIEW et guards CLIK réutilisés ; clic/Save sont des sources, pas des événements ou une persistance exécutés. Défaut physique absent, préférence user1, repli constructeur1 et GFX0 distincts.

**Natif.**82C574 associe la clé à82D030 ; callback bool6F5930, receiver+4→owner+0C→préférence byte11. Constructeur7E0D30 charge LoL_InGame_Hit.dds via98A7F0, stocke texture0C et lit la clé avec argument1. L’état actif byte10 est distinct.

7E0D90 reçoit durée et amplitude : sur durée ordinaire positive, exige GameClock initialisé, stocke temps de départ au champ0, amplitude4/durée8 et active10=1. La voie d’invariant invalide appelle un diagnostic puis écrit à l’adresse0 ; elle n’a pas été exécutée. Durée ordinaire non positive désactive10. Cette méthode ne teste pas la préférence11.

7E0E10 teste11 et10 avant de lire le temps : off/inactif retourne sans draw. Sur entrée finie ordinaire, elapsed>durée expire10 ; égalité atteint le draw avec alpha0. Alpha=amplitude−elapsed/durée×amplitude, conversion entière puis octet basBL, trois autres octetsFF ; pas de clamp/semantics nonfinie inventés. La routine utilise texture0C et986AD0 avec origine0,0 et champs d’étendue du renderer20328/2032C. Sampler/UV/blend/projection/temps/clock discontinuities et équivalence pixel non qualifiés. Off ne prouve pas clear/reset/pause, car le retour précède l’expiration.

Deux préfixes d’arguments63FCD6 et63FF09 conduisent à7E0D90 via global2D78D24+0C. Ratios et globals de durée/amplitude identifiés, mais branche complète63FB60, identité des champs, source/victime, shield/zero/lethal/thresholds et provenance des globals restent ouverts. Ne pas inventer une durée/couleur ou une politique de tous dégâts.

**Courant.** apply_damage serveur possède DamageOutcome(raw,post_mitigation,health_removed,shield_absorbed,lethal), gardes et effets HP/mort ; le résultat revient aux callers et au recap. Snapshot clone les corps HP et transporte des faits par-capacité. La réception remplace state.snapshot puis confirme sa présentation ; aucune route nommée du flash dans ce chemin. Un delta de PV n’identifie pas à lui seul un coup : dégâts/heal/regen peuvent se compenser entre snapshots ; c’est une limite logique, pas un nouveau test de gameplay.

Le recap est local, privé et projeté seulement pendant la mort du propriétaire. Son panneau est un rendu existant, pas un flux live de tous dégâts. Les accepted Q contacts sont produits après damage accepté, mais portent géométrie/target/tick/order, pas un contrat général de montants/flash écran. ezreal_q_flash_events refuse explicitement l’inférence depuis HP/damage/disparition ; son live Simple/QUAD est un effet3D/caméra/FoW, distinct du flash écran. Les barres et textes HP actuels existent. Ces acquis sont conservés, aucun combat/asset/VFX globalement déclaré absent.

## R4 — Attendu et observé

Sept cas consignés : cfg/default, savecfg différé, préférence/activation, fade/expiry, provenance DDS, données/rendus distincts, application/refus restant à vérifier. Sept fenêtres natives nouvelles et43instructions attendues ; bool partagé vérifié par octets. DDS header/SHA/MD5 et record/source inspectés ; cinq central directories sélectionnées, sans extraction. Corpus1168, cinq registres,25fichiers protégés et Git conservés.

Contrôles documentaires Python seulement. Aucun x86/AS/Rust/jeu/GUI/input/réseau/loader productif, installation/migration/restart, ancien test/lecteur ou source export exécuté. Sources des gardes/alpha/draw ≠ événement reçu ou framebuffer observé. Shield/zero/heal/lethal/FP et owner/recovery ne sont pas qualifiés par ce succès documentaire.

## R5 — Manques et reprise

- DAMAGEFLASH-NATIVE-ADMISSION : branche63FB60, globals durée/amplitude, politique de trigger, clock/provider/renderer complets ouverts. Reprise sur un caller63FD11/63FF38 et son producteur ou contrat local explicite autorisé, sans refaire la clé et le fade.
- DAMAGEFLASH-CURRENT-EVENT : flux reçu propriétaire/victime/paramètres du flash non raccordé dans les chemins inspectés. Réutiliser DamageOutcome et faits autoritaires suffisants ; event identity/order/epoch/session minimum, pas de faux coup déduit d’un deltaHP ni divulgation d’attaquant caché.
- DAMAGEFLASH-CURRENT-DRAW : pas de raccord écran/réglage/texture sélectionnée dans ces chemins. DDS natif déjà présent : route pack/manifest et vrai overlay/clock/viewport à qualifier sous autorisation produit, pas recréer la texture.
- DAMAGEFLASH-APPLIED-SAVE :0/1/trigger/expiry/refus/reset/death/respawn/session/window et Save/cancel/default/reload non exécutés. Build/assets/provider et cycle réel contrôlé requis ; source no-live et préférence/active distincts conservés.

Chaque manque possède impact et reprise précise dans la preuve ; toujours ouvert après le seul audit documentaire limité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et HUD-LOCAL-RENDER-01 réutilisées sans modifier leurs définitions. Proposition HUD-DAMAGE-FLASH-SETTING-01 porte un unique trigger autorisé→projection→écran et son réglage. Elle ne reconstruit pas tous dégâts, recap ou effets de sorts. Critères de source/victime, données minimales/dedup, DDS original sélectionné, alpha/viewport/lifecycle et Save réellement exercés détaillés. Proposition non appliquée, aucun registre modifié.

Prochain lot : FlashScreenWhenStunned ligne107, en réutilisant les méthodes/ressources écran lorsque leurs identités correspondent et les mécaniques de stun présentes. Aucun nouvel audit de tous CC. Lot suivant non exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DAMAGE-FLASH-SETTING-01\damage-flash-setting-proof.json` SHA256 `fd3956279233f3137be603ad3b68b68cc966b8ba7254a5dfdac2916847610e42` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DAMAGE-FLASH-SETTING-01\verify_damage_flash_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-DAMAGE-FLASH-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; fonctionnalité/parent/goal ouverts. Nouveaux documents isolés seulement ; goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés.
