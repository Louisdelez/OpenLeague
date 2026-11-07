# FlipMiniMap — complément du contrôleur natif

## R1 — Portée et décision

Date 2026-10-31T15:47:00.121520+00:00. Unité AUD-17.5-01-OPTIONS-FLIP-MINIMAP-SETTING-01, SYS-17.5-01, goal SYS-01.2-02. Le lot antérieur AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01 couvre déjà XML132, ressources, quatre paires et vrais consommateurs. Seul delta : source du contrôleur manquant MMFLIP-NATIVE-CONTROLLER. Producteur non clôturant, relecture séparée requise. Fonctionnalité, parent, goal et acceptation ouverts.

## R2 — Sources réutilisées

PE4.20 SHA `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/export AS et19fragments checkbox/3constantes épinglés. Ancien Flip/readback/rapport, deux archives HUD.zip et sources actuelles inchangés ; pas de nouvelle extraction ni recherche d’assets. Defaults/user/deploy FlipMiniMap0, libellés enGB/frFR750 repris. Regular est un défaut conditionnel à la définition réelle ; updateonclicktrue est explicite, pas savecfg du voisin. Save/live/boolean/indexedread/scalar partagés réutilisés sans runtime. Les26ancienscasCPU/logs/inputs sont conservés, non rejoués, non qualifiants pour Flip.

## R3 — Nouveau lien et consommateurs réels

82012C nomme [HUD]FlipMiniMap et capture820A40, mode2 normal/live. Callback : conversion scalarC998CC, demande index32→835440, puis bool6F5930→824F40. Initialisation83626A lit HUD/FlipMiniMap fallback0/selector0, crée index32 ;81F0DE lit32 et initialiseowner1EA selon nonzero. Hors chaînes canoniques0/1, scalar et bool ne sont pas assimilés ; pas de test CRT/locale.

824F40 complet : service2D787B8 virtualB0true retourne avant1EA/propagation, après demande index32 du callback. Sinon1EA est stocké et enfantsFC/110/D4/108 optionnels reçoivent mises à jour ; D4→8047C0 est le consommateur minimap nommé. Autres offsets/calls restent numériques, pas une attribution inventée de toutes les paires de panels.

8047C0 complet : mêmeF2 retourne ; valeur changée stockeF2 puis virtualB0 peut sauter la demande de liste. Sinon F2zero→ElementsListNormal, nonzero→ElementsListFlipped, service9A7010. Les deux chemins changés appellent ensuite803F80/800550 ; corps/ack/fallback/provider non suivis ici. Cache changé ou appel ne prouvent pas basculement/flush/transaction/réessai.

Startup81F212 : virtualB0true et static2D82810zero choisit ElementsListSpectator ; sinon cmove depuisowner1EA choisit Normal/Flipped vers9A6760. Sens du prédicat/flag, provider et applicabilité par mode restent ouverts. Le nom Spectator ne suffit pas à baptiser le virtualB0.

Quatre substitutions FastHUD déjà acquises : minimapRight/Left, ChampionLeft/Right, StatsLeft/Right, VisionSlot/Right. Cela sélectionne une disposition UI, pas une réflexion du monde. Actuellement loaderNormal, minimap/cameraRight et six consommateursChampionLeft fixes persistent. Partage Live.rect, projection/inverse, capture périmée et gardes existent ; aucun raccord ni test de bascule n’est créé dans cet audit. Queries exactes héritées réutilisées après identité du corpus1168, sans rescan identique.

## R4 — Attendu et observé

Sept cas dans preuve : réutilisation sans doublon, init0/index32, propre callback/live, sélection des listes, gardes/refus, acquis actuels et application/Save ouverts. 8fenêtres alignées et 51attentes d’instructions nouvelles. Des fenêtres exploratoires ont commencé horsfrontière d’instruction ; elles n’établissent aucune preuve et sont remplacées dans la livraison par les frontières formelles vérifiées.

Contrôles documentaires Python/hash/PE readonly uniquement ; ni anciens lecteurs/tests/export, ni exécution AS/x86/Rust/jeu/GUI/input/réseau/loader, ni installation/migration/restart. Pas de tests réels de toggle, cadre/pixels/marqueurs/input/DPI/owner/default/undo/Save/reload. Cinq registres,25protégés,corpus et Git conservés.

## R5 — Écarts et conditions de reprise

- MMFLIP-NATIVE-CONTROLLER : lien nommé/cache/choix liste désormais identifié ; restent définition/stratégie/provider, producteurs virtualB0/staticflag, initF2 et services/enfants. Reprise par un seul producteur/consumer nommé9A7010/9A6760 ou mode identifié, sans refaire archives.
- MMFLIP-CURRENT-LAYOUT-BRIDGE : inchangé, quatre paires et sélecteurs/input cohérents à raccorder sous autorisation produit distincte.
- MMFLIP-TRANSITION-QUALIFICATION : 0/1/context/missingchild/service/samevalue, deux côtés, DPI/input/capture/focus/session/pixels non exécutés ; build/assets/scénario autorisés requis.
- MMFLIP-LIVE-PERSISTENCE : subscriber identifié, mais définition/provider/fichier durable et accord scalar/bool/effet/undo/Save ouverts. Update index32 précède le refus display, il n’est pas un succès.

Chaque manque conserve impact, statut précis et entrée de reprise dans preuve. Seul résultat documentaire partiel est résolu ; ancienne fonctionnalité reste proposée.

## R6 — Correction conservée et suite

HUD-MINIMAP-FLIP-LAYOUT-01 et ses dépendances/critères conservés textuellement ; ajout de source seulement. Zéro nouvelle correction, aucun registre modifié. Les quatre paires ne sont pas reconstruites et leurs autres consommateurs ne sont pas déclarés qualifiés par une seule branche.

Suite : compléter le seul MMSELF-NATIVE-EFFECT de MinimapMoveSelf133 à partir de son audit existant ; un callback/un effet utile ou limite, sans refaire26CPUcases/AS/archives.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLIP-MINIMAP-SETTING-01\flip-minimap-controller-proof.json` SHA `ff94b8bcd957004454ee5c8ab3c9c051a0230545753f904a4daae293c1944d47`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLIP-MINIMAP-SETTING-01\verify_flip_minimap_controller.py`, fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLIP-MINIMAP-SETTING-01\audit-unit.json`. Lecteur séparé et INDEPENDENT-REVIEW attendus ; seul ce delta documentaire peut être clos. Goal/critères, code/assets, Plan/UI/bases, registres, documents/preuves antérieurs inchangés ; nouveaux fichiers isolés seulement.
