# AUD-17.5-01-OPTIONS-LOSS-OF-CONTROL-SETTING-01 — LossOfControlEnabled

## R1 — Portée et décision

Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Un checkbox ligne100, sa stratégie, son flag natif et le chemin actuel ressources/effets/affichage. Le producteur ne clôt pas le lot ; relecture séparée attendue. Implémentation de cette activation partielle/absente dans les chemins inspectés, vérification fonctionnelle non exécutée, acceptation humaine non demandée.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index, export AS antérieur et en_GB759 épinglés. Deux default Game.cfg39=1 ; autres fichiers fournis sans clé exacte ; candidat F:/OpenLeague/Config/Game.cfg absent à ce chemin seulement. Provider/runtime effectif non observé. ShowSummonerNames, checkbox/Save et audit buff-duration réutilisés par empreintes, aucun ancien test/lecteur/export relancé.

Deux HUD.zip identiques épinglés ; membres LossOfControlUI.ini8007bytes et LossOfControlUI_AbilityOverlay.ini12177bytes présents. Le premier conserve la réparation antérieure BaseOffset:0,0 (+17bytes=8024), octets comparés, pas reconstruite ici. Ancien file-loop : original header0/live0 ; réparé header2/live25/effects8 avec2warnings, limites conservées. L’overlay de réparation OpenLeague est explicite et conditionné aux octets originaux/restaurés qualifiés.

## R3 — Contrat et consommateurs

**Stratégie.** Le contrôle et ses ancêtres physiques n’ont ni strategy ni updateonclick. InteractiveModelComponent passe getAttrib(STRATEGY) à SerializeableValue ; missing retourne la chaîne null et le constructeur ne remplace sa valeur initiale regular que si différente du sentinel. La stratégie effective du document fourni est donc regular, pas savecfg par analogie. Les deux nouveaux fragments de stratégie complètent19fragments checkbox et3constantes réutilisés. Journal normal/canonique0/1, GFXfallback0, NEGATEVIEW et guards CLIK conservés ; absence de live via makeValueToBool(null-string). Runtime injecté non observé.

**Natif.**82CA14 associe la clé complète à82D090 via5BD730 ;82CF3C associe le même callback par un second chemin82D410.82D090 appelle6F5930 puis écrit owner+5E, via receiver+4.7EF5CF initialise le word5E à0101 :5E et5F valent1, sans donner de rôle à5F. Bool ASCII/locale réutilisé avec limites, pas exécuté.

Un lecteur réel est identifié :7C3050 charge le global2D78D24 et son byte5E ; si faux ou LossOfControl/HeroHealthBar faux, branche7C3106. HeroMode lu avec argument7 sélectionne les masques1/2/4 pour sélecteurs0/1/2. Le domaine exact de ces sélecteurs, le chemin aval et tout le renderer LossOfControlUI restent ouverts ; aucune équipe/catégorie devinée. Ce préfixe ne suffit pas à définir toutes les barres/overlays. Le dispatch regular commun est réutilisé ; l’écriture du flag ne prouve pas la persistance savecfg ou Close/reload.

**Ressources et courant.** Les listes ShadowIsles Normal/Flipped contiennent les deux fichiers de contrôle ;61définitions (25+36) ont Enabled0 et requièrent sélection/activation dynamique. native_zip_provider.startup_hud charge les32fichiers Normal, applique les réparations gardées, structure/binde les éléments et textures. Le startup ordinaire l’appelle. Présence/chargement/binding n’est pas sélection d’un effet et dessin du contrôle.

Les rendus réels restent sélectifs : native_hud_widgets accepte18textes numériques, native_hud_panels trois cadres, native_hud_spells les14icônes/overlays QWER/D/F depuis leurs layouts nommés. Leurs sélecteurs n’activent pas les définitions LossOfControl. Un bool global de GUI ne doit pas remplacer les critères natifs par-effet.

Le gameplay de stun existe : Stun(tag,source,expires_at), API serveur avec refus/expiry ; commandes move/attack et casts ont des gardes, avec exceptions de code nommées. L’état visuel des sorts d’invocateur utilise stuns::active/allows_disabled. Ces acquis sont distincts de l’UI LossOfControl et conservés ; le réglage d’affichage ne doit pas changer leurs effets ou refus. Aucun crowd control, catalogue ou asset déclaré globalement absent.

## R4 — Attendu et observé

Huit cas dans la preuve : stratégie, défaut, live/refus, callback/flag, lecteur/gates, ressources/réparation, fonctions présentes, application/persistance restant ouvertes. Cinq fenêtres statiques et25instructions attendues nouvelles ; trois bool spans réutilisés par octets. Archive lue en mémoire seulement,61records repris de la preuve native antérieure et comparaisons bytes du file-loop/repair ; aucune ancienne exécution natif/parser requalifiée comme nouvelle.

Regex sur1168fichiers : seul alias LossOfControlUI.ini au provider126 ; réglage exact et préfixes de widgets absents des fichiers bornés. Conclusion complétée par leurs vrais sélecteurs et signatures, pas une preuve d’absence globale. Corpus/Git/cinq registres/25fichiers protégés inchangés. Aucun x86/AS/Rust/jeu/GUI/input physique/réseau/loader productif, installation, migration, restart ou export exécuté. Source des gardes ≠ refus exercés.

## R5 — Manques et reprise

- LOC-NATIVE-FULL-SCOPE : aval du reader5E, rôles0/1/2, priorité/label/clock et provider ouverts. Reprise sur consommateur natif nommé ou contrat local explicitement autorisé ; pas refaire callback intact.
- LOC-CONTROL-CONSUMER : sélection et affichage autorisés de contrôle non complets. Réutiliser BUFF-LOSS-CONTROL-01 avec source/priority/time/renderer, pas recréer les ressources présentes ou tous les CC.
- LOC-SETTING-BRIDGE : activation regular→consommateur réel manquante dans les chemins inspectés. Après qualification/autorisation produit, raccorder seulement0/1 avec owner/visibilité/session/recovery et gameplay conservé.
- LOC-REGULAR-PERSISTENCE : Update/Close/cancel/default/Save/reload, fichier/provider durable et UI refusals non exécutés. Cycle contrôlé/build identifié requis ; aucune égalité entre flag modifié et persistance durable.

Impacts et entrées précises dans la preuve, toujours ouverts après le seul audit documentaire borné.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et BUFF-LOSS-CONTROL-01 conservées textuellement. Une proposition distincte HUD-LOSS-CONTROL-SETTING-01 couvre seulement l’activation du réglage, dépend du consommateur déjà planifié et n’en duplique ni catalogue ni renderer. regular/no-live, défaut,0/1 appliqués sans mutation des stuns, restauration/Close/reload et limites ont des critères précis. Proposition non appliquée, aucun registre de plan modifié.

Prochain lot : ShowSlows ligne101, savecfg explicite ; distinguer ralentissement effectif et affichage d’un contrôle. Réutiliser le présent réglage et les preuves buff au lieu d’un nouvel audit général des CC. Ce prochain lot n’est pas exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LOSS-OF-CONTROL-SETTING-01\loss-of-control-setting-proof.json` SHA256 `839c38190ca1b314b5d0e6783cbc0a0e459907060a847140874c766c452d5966` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LOSS-OF-CONTROL-SETTING-01\verify_loss_of_control_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LOSS-OF-CONTROL-SETTING-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md. Seule cette relecture peut clore le périmètre documentaire ; fonctionnalité/parent/goal restent ouverts. Nouveaux documents isolés seulement ; goal/critères, code/assets, suivi/interface/bases, registres et preuves antérieures inchangés.
