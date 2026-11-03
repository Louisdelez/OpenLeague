# AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01 — FlipMiniMap

Date : 2026-10-31T10:54:20.149366+00:00. SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un seul contrôle : OPT-SRC-745ee2272040ee09, FoundryOptionsMenu.xml ligne132, `[HUD]FlipMiniMap`, updateonclick=true. Fin : déclaration/défaut, ressources, consommateurs réels et manques documentés puis relus. Audit clôturable ; fonctionnalité, parent, goal et acceptation humaine restent ouverts. Aucune modification du produit autorisée dans ce lot.

## R2 — Provenance réutilisée

Recensement physique, export AS existant et lot MinimapMoveSelf relu réutilisés. Le PE4.20 et FoundryOptions.gfx sont identifiés sans exécution. Deux Game.cfg de défaut identiques contiennent `FlipMiniMap=0` ligne84. Les mêmes candidats utilisateur/deploy sont relus pour cette clé ; l'absence du chemin F exact ne désigne pas le provider runtime ni le montage historique.

Le libellé en_GB fourni, ligne750, est « Show Minimap on left » ; fr_FR confirme le placement à gauche. Data.as et fillInLabel expliquent la clé générée sous condition de contexte sans override. Le sens est un placement de l'interface ; aucune réflexion des coordonnées du monde n'en est déduite.

HUD.zip courant et original fourni sont identiques (122169 octets, SHA256 76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c). Lecture ciblée de cette seule archive, sans extraction ni scan global. Les ressources Left (8355 octets, SHA256 426a3097cf85078d102c88493e5911cca0842e0f832da0ac65ce5e44459b5604) et Right (8367 octets, SHA256 da2980e377c069ee609f00bb11a685081058661d461e18c13af41af8e7105433) existent. Pas de reconstruction d'asset justifiée ici.

## R3 — Contrat et consommateurs

Les branches checkbox/CLIK, init0/1 et autres chaînes, fallback0, restore distinct, disabled/nonprimaire et demande live sont réutilisées. updateonclick agit aussi lors des synchronisations/default/undo. Live utilise stratégie live ; le checkbox Flip et ses ancêtres physiques n'imposent pas savecfg. SerializeableValue démarre regular, puis accepte une stratégie effective : regular reste conditionnel au contexte/injection/héritage réel. Ne pas transférer savecfg du checkbox voisin. Aucune preuve d'acquittement ou de persistance propre à Flip.

FastHUD [ShadowIsles] nomme ElementsListNormal et ElementsListFlipped. Les deux listes comportent32 entrées et quatre substitutions :

| Ligne | Normal | Flipped |
|---|---|---|
|22|ShadowIslesMinimapRight.ini|ShadowIslesMinimapLeft.ini|
|23|ShadowIslesChampionLeft.ini|ShadowIslesChampionRight.ini|
|24|ChampionLeft_Stats.ini|ChampionRight_Stats.ini|
|32|VisionSlot.ini|VisionSlot_Right.ini|

Les huit membres existent. Les neuf enregistrements lexicaux sélectionnés par côté (contenu, cadre, pilier et six icônes caméra) ont Anchor0,1 à gauche et1,1 à droite. Leurs Rect diffèrent : les octets exacts sont conservés, sans remplacer le parseur natif par cette lecture lexicale ni promettre une simple translation ou symétrie parfaite.

Le consommateur actuel est identifié : native_zip_provider::startup_hud choisit uniquement ElementsListNormal. native_minimap sélectionne ShadowIslesMinimapRight ; camera_lock_ui sélectionne aussi ce fichier pour ses six états. Six autres fichiers comportent des sélecteurs ShadowIslesChampionLeft. Basculer uniquement la liste ferait manquer les enregistrements attendus par ces sélecteurs fixes. Les deux autres substitutions doivent être suivies dans les consommateurs réels avant intervention ; une absence de nom exacte n'est pas une absence de toute fonction.

Le renderer produit le rectangle depuis le Node, l'utilise pour les marqueurs puis le publie dans Live.rect. L'entrée de minicarte utilise ce même rectangle avec inverse, limites finies/demi-ouvertes et gardes de contexte/focus/session/UI/terrain. Les bits du rectangle entrent dans l'identité de capture et annulent une capture périmée. Ces mécanismes existent ; ils ne prouvent pas un basculement testé. La recherche exacte bornée sur1168 fichiers ne trouve ni FlipMiniMap ni ElementsListFlipped, et la conclusion est étayée par les chemins réels ci-dessus.

## R4 — Attendu et observé

Sept cas : défaut0, libellé gauche, quatre paires de listes, ancrages, stratégie conditionnelle, sélecteurs réels et gardes/refus réutilisés. Les attendus/observés et toutes les identités figurent dans la preuve. Les26 anciens cas CPU ont les mêmes sources et données ; ils ne sont pas rejoués et ne deviennent pas des tests Flip. Corpus1168,25 fichiers protégés, cinq registres et Git vérifiés avant/après. Resume est lu sans mutation ; aucun loader productif, export, disassembly nouveau, x86, AS, Rust, jeu, GUI, input physique, réseau, installation ou migration exécuté.

## R5 — Manques et reprise

- MMFLIP-NATIVE-CONTROLLER : subscriber, sélection effective0/1, stratégie/contexte et provider natifs. Reprendre un contrôleur nommé ou un contrat local versionné explicitement autorisé.
- MMFLIP-CURRENT-LAYOUT-BRIDGE : sélection et consommateurs des quatre paires, bouton caméra et zones d'entrée cohérents. Reprise produit autorisée avec contrat précédent ; ressources déjà disponibles.
- MMFLIP-TRANSITION-QUALIFICATION : géométrie affichée/marqueurs/input des deux côtés, DPI, capture périmée, focus/session et états UI. Reprise sur build/scénario identifiés ; gardes source seules insuffisantes.
- MMFLIP-LIVE-PERSISTENCE : init/live/default/cancel/save/reload, effet et acquittement, provider/fichier durable. Reprise avec stratégie et subscriber précis ; Update n'est pas un succès durable.

## R6 — Correction et suite

Réutilisation des corrections de menu, geste Move, projection, caméra et bouton caméra, définitions conservées. Une proposition distincte : HUD-MINIMAP-FLIP-LAYOUT-01, qualifiant puis raccordant ce réglage à la disposition complète. Critères : quatre paires, image/marqueurs/rectangle/input et bouton caméra cohérents, captures périmées refusées, cycle de configuration vérifié. Proposition documentaire non appliquée ; aucun registre, plan ou critère normatif modifié.

Prochain lot borné : MinimapScale, slider ligne95, Globals/MinimapScale et MinimapScaleDatasource. Examiner son datasource et le scale actuel avant de conclure ; ne pas répéter l'inventaire d'archives.

## R7 — Livraison et relecture

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01\minimap-flip-proof.json`, SHA256 `7738ab2a0a6df6027a3ab248726a8a31c6c0071cc092f8d95888e7273e042b5e`. Producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01\verify_minimap_flip.py`. Fiche : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; le producteur seul ne clôt pas le lot.

Nouveaux documents isolés uniquement. Goal, critères, registres, code, assets, application de suivi, interface, bases, historiques et preuves antérieures conservés. Aucune fonctionnalité ni jeu complet déclaré terminé.
