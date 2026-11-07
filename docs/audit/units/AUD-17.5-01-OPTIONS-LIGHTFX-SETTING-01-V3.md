# AUD-17.5-01-OPTIONS-LIGHTFX-SETTING-01 — EnableLightFx

## R1 — Portée et décision

Version3 : corrige le seul décompte textuel de12API, avec contrôles de nombre ; proof/reportv2 non relus et conservés, non clôturés. Une option d’éclairage matériel externe : checkbox112, groupe111 onlyshowif=alienware. Audit source/admission/préférence/requête/consommateurs ; fonctionnalité matérielle, parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur non clôturant, relecture séparée attendue. Pas d’acceptation humaine ni de résultat global.

## R2 — Sources et provenance

PE4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export AS épinglés. en_GB743 Enable Alienware LightFX et847 Alienware Options. Defaults20=0, user11=0, deploy9=0 ; deux getters natifs argument0. Provider effectif non observé.

Audits visibilité, checkbox19fragments/3constantes, Save/live et indexed-update/bool réutilisés sans ancien lecteur/test/export rejoué. Prédicat exact, environnement runtime distinct du debug et rejet de groupe/descendants déjà établis ; aucun trim/casefold inventé. Empreintes et corps utiles revérifiés.

## R3 — Contrat et consommateurs réels

**Menu.** regular par défaut, updateonclick=true ; sync et clic passent le gate live. Baseline/journal/undo et Save sont des mécanismes acquis, pas une preuve de restauration du matériel ou persistance. Mode2 de souscription → map8 réutilisé, callback837C20 → bool partagé → indexed9. Initialisation835A77slot9, clé836DAD et table dispatch9→83779B concordent. Helper partagé saute la même valeur, copie la configuration avant postdispatch ; pas d’absence d’effet natif déduite d’un callback court.

**Capacité.**82DD9A tente LoadLibraryA(LightFX.dll), saute le candidat alienware si null ; sinon FreeLibrary puis ajout de token dans l’objet GFx courant. Pas de test API/init/périphérique dans cette fenêtre. Le transfert complet vers InitializationData.environment et movie/provider effectifs restent à qualifier. Ne pas confondre groupe affichable, DLL chargeable et matériel compatible. Aucun LoadLibrary exécuté ici, même pour inspecter une DLL.

**Préférence et demandes.**51A800 lit General/EnableLightFx et stocke2D5F5C8. Slot9true écrit préférence1 et demande enable2D78AE8=1 ; false écrit préférence0 et demande disable2D78AE0=1. Ces branches ne purgent pas le flag opposé et ne renvoient pas un acquittement matériel.6CC270 consomme la demande enable via6CBEF0 puis l’efface ; si initialized2D78AE9, appelle6CBB40 ; côté false consomme6CBE80 puis efface disable. Cadence/caller/rafales de changements et couleurs/séquences complets non qualifiés.

**Adaptateur natif.**6CBEF0 lit préférence/initialized, charge la DLL, résout12noms LFX_* via GetProcAddress, vérifie des pointeurs requis, appelle LFX_Initialize et suit sa branche retour0. Puis Reset, mutex, appel GetNumDevices ; ce dernier teste EAX de retour, pas output-count>0. Initialized=1 ne prouve donc pas un périphérique positif ou un effet visible. Échecs DLL/API/init/retourGetNumDevices ont des branches distinctes ; noms de codes SDK non inventés.6CBE80 contient des appels Reset/Update sous garde, initialized=0, helper et Release conditionnel ; reprise détaillée des séquences/lifetime/restauration reste ouverte.

**Courant.** Startup, config générique/texte fusionné, map typée EnvironmentQuality16 et état de matériaux du monde existent. Conserver une clé dans du texte n’applique pas LightFX. Aucun nom LightFX/alienware/API dans1168fichiers inspectés ; cette borne et les consommateurs réels ne prouvent pas une absence générale d’éclairage. Les chemins exacts deploy/LightFX.dll, deploy/Data/Cfg/LightFX.ini et copieF/defaults/LightFX.ini sont absents ; cela ne recherche ni le système, ni tous les packs, ni le chemin DLL choisi. Pas d’installation de pilote/SDK proposée comme résultat de cet audit.

## R4 — Attendu et observé

Échec documentairev1 conservé : borne8377CD tronquait ret4 à8377CC, contrôle49 !=50 refusé. v2 corrige la borne en8377CF ; ni résultat fonctionnel ni preuve antérieure écrasée. Sept cas : déclaration/condition, défaut, souscription9/live, capacité, demandes différées, acquis actuels et cas appliqués non exécutés. Dix fenêtres natives nouvelles, 44instructions attendues, table slot9 et trois imports Kernel32 ; fragments/natif partagés vérifiés par identité/octets, pas réexportés.

Python/source seulement. Pas de DLL chargée, API/device/jeu/GUI/input/réseau/loader productif exécuté, ni ancien test/lecteur/export, install/migration/restart. Nominal physique,0/1/refus/rapid-toggle/release/annulation/Save n’ont pas d’observation runtime. Une branche source ou un message log n’en tient pas lieu. Cinq registres,25fichiers protégés, corpus et Git conservés.

## R5 — Manques et reprise

- LIGHTFX-CAPABILITY : handoff complet, DLL/SDK/ABI et appareil sélectionnés inconnus. Token chargeable ≠ API/appareil/effet. Reprendre sur branche nommée d’environnement ou politique locale explicite et identité sélectionnée ; pas de recherche globale répétée.
- LIGHTFX-ADAPTER : pas de route matérielle nommée actuelle. Raccord autorisé d’un adaptateur/résultat indisponible précis, en réutilisant texte config/menu ; pas le renderer de carte.
- LIGHTFX-SEQUENCES : LightFX.ini/provider et event/couleur/cadence complets ouverts. Nouvelle entrée utile : ressource exacte/provider ou caller nommé6CBB40 ; aucun motif lumineux inventé.
- LIGHTFX-LIFECYCLE-SAVE :0/1/rafales, échec/absence API/init/device, release/close/session, undo/default/Save/reload non exécutés. Build/provider/adapter identifiés et matériel autorisé ou indisponibilité explicite requis ; pas de réussite par flag ou compte non lu.

Chaque manque garde impact et entrée discriminante dans la preuve. Ils n’empêchent pas de clore le présent audit limité, sans clore la fonctionnalité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et HUD-OPTIONS-XML-INPUTS-01 conservées textuellement ; seule nouvelle proposition HUD-LIGHTFX-SETTING-01, capacité/préférence/adaptateur/résultat d’un chemin identifié, distinct du rendu de carte. Dépendance menu, contrat SDK/ABI/device ou refus indisponible explicite ; tests appliqués et lifecycle/Save précisés, autres séquences suivies séparément. Proposition non appliquée, aucun registre modifié.

Prochain lot nommé : AutoDisplayTarget ligne116. Réutiliser l’audit target/picking, ne pas assimiler sélection/intention/panneau. Non exécuté dans ce lot.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIGHTFX-SETTING-01\lightfx-setting-proof-v3.json` SHA256 `2c5251e33280507bbfc8b16be9d7b159b472d4048ec8cf376ac3b730d1c55fc5` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIGHTFX-SETTING-01\verify_lightfx_setting_v3.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-LIGHTFX-SETTING-01\audit-unit.json`. Relecture distincte attendue : delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos. Nouveaux documents isolés ; goal/critères, produit/assets, suivi/interface/bases, registres et anciennes preuves inchangés.
