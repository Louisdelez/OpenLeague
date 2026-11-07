# AUD-17.5-01-OPTIONS-HEALTH-BARS-SETTING-01 — DrawHealthBars

Date : 2026-10-31T12:12:20.006195+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un checkbox ligne98, OPT-SRC-29d9e7ba2395d78a : HUD/DrawHealthBars, stratégie savecfg. Fin documentaire : déclaration/défauts, demandes, flag natif identifié, chemins réels actuels, limites/reprise et relecture. Le lecteur natif final du flag et son effet graphique restent une inconnue explicite ; aucune équivalence complète de visibilité promise. Fonctionnalité, parent, goal et acceptation humaine ouverts.

## R2 — Sources et provenance

XML/factory/export AS réidentifiés.19fragments checkbox/CLIK/serializer et Save réutilisés. Deux défauts identiques ont DrawHealthBars=1 ligne74 ; deux candidats utilisateur/deploy sans clé ; chemin F exact absent. Sélection historique/provider non observés. en_GB ligne738 : Show Health Bars. Audit des pools locaux et preuves caméra historiques conservés sans rejeu. PE4.20 et outils statiques existants identifiés.

## R3 — Contrat et consommateurs

Le contrat modèle/vue/CLIK est réutilisé : chaînes0/1 canoniques, false case-insensitive, fallback0 et restore distinct, NEGATEVIEW conditionnel ; guards MouseRelease disabled/nonprimaire lus dans la source. Le défaut physique1 et le GFXplayer fallback0 restent des contrats séparés.

**Pas de live déclaré ici.** updateonclick n'est présent ni sur le checkbox ni sur ses ancêtres physiques. getAttrib retourne la chaîne sentinelnull et makeValueToBool ne reconnaît que1/true. applyLiveUpdate est appelé par clic/sync mais sa condition est fausse sur cette déclaration ; aucun setLiveValue demandé par ce chemin. Le journal normal savecfg et la source Save config/notification sont conservés. Ne pas ajouter un aperçu immédiat sans contrat source. Définition/timeline réelle, application et durabilité restent non exécutées.

**Natif statique.**7EF597 appelle8B1910 pour HUD/DrawHealthBars avec arguments1/0 et stocke AL au byte+5D.82C888 associe [HUD]DrawHealthBars à82D070. Ce callback convertit une chaîne via6F5930 puis écrit le même offset sur le propriétaire référencé par receiver+4. Le lecteur de ce byte, son identité propriétaire et les catégories de barres qu'il contrôle ne sont pas qualifiés par ce lot : ne pas assigner par déduction toutes les barres monde ou les jauges locales à ce flag.

Le helper bool retourne faux pour la chaîne C exacte0, sinon pour un résultat nul de comparaison à false. Le wrapper choisit le chemin ASCII A..Z case-fold quand le global14AE870 est0 ; son autre branche locale reste ouverte. Les prédicats0/1/false en contexte ASCII valide sont établis par instructions, pas exécutés ; NULL, stockage, locale et erreurs restent ouverts.

Une autre référence834DF2 lit la même clé avec arguments0 puis, si faux, demande un setter1. Contexte/mode/caches/notification de ce writer non qualifiés : ce n'est pas une preuve de tutoriel, de défaut historique ou d'override réellement déclenché. Source native bornée à ces références et dépendances utiles ; aucune recherche d'absence globale du lecteur+5D n'est revendiquée.

**Courant.** health::update dessine des barres écran pour players/units depuis positions/HP autoritaires, après CameraUpdateSystems avant UI Prepare. Projection/HP positif déterminent l'affichage ; winner cache les racines, acteurs disparus sont retirés. Absence snapshot/caméra/transform retourne tôt sans politique clear/retain nouvellement qualifiée. Le style48x5/coloré est un chemin local existant, pas la fidélité graphique native complète.

native_hud_bars est un autre chemin :11éléments locaux HP/Mana/fonds, ressources et fractions, sources/atlas natifs. Les signatures des deux chemins ne lisent pas Loaded/DrawHealthBars ; leurs consommateurs et schedules sont identifiés au-delà de la recherche de nom vide. Un chargement Game.cfg n'est pas un raccord de visibilité. Ces deux rendus existent, avec leurs limites ; aucun asset déclaré entièrement absent.

## R4 — Attendu et observé

Sept cas : défaut/UI, absence live, prédicats bool, cache/autre writer, deux rendus, limite caméra historique et Save/refus. Sept fenêtres natives et26 instructions attendues identifiées. Source guards/nominal0/1 conditionnels, aucun programme original ou rendu exécuté.

L'ancien log correspond à son hash et rapporte14passes caméra, avec un test health camera-motion. Mais health.rs,main.rs et projected_live.rs ont tous des hashes actuels différents de son manifeste. Les anciens scénarios/captures restent historiques ; ils ne prouvent ni le build courant ni DrawHealthBars0/1. Aucun ancien test rejoué. Corpus1168,25 fichiers protégés, cinq registres et Git contrôlés avant/après. Aucun x86/AS/Rust/jeu/GUI/input physique/réseau/loader productif, installation ou migration exécuté.

## R5 — Manques et reprise

- DHB-NATIVE-SCOPE : lecteur byte+5D/propriétaire, barres affectées, autre writer834DF2, provider/locale/erreurs. Reprendre une source nommée de lecture et le contexte du writer, ou un contrat local versionné explicitement autorisé.
- DHB-CURRENT-BRIDGE : raccorder seulement les barres concernées, après qualification de périmètre. Reprise produit séparément autorisée ; ne pas confondre les deux rendus ou le chargeur générique avec ce raccord.
- DHB-STATE-QUALIFICATION : états UI et visibilité appliquée, owner/snapshot/caméra/death/winner/resize/DPI et recovery sur build/assets actuels. Les14passes anciennes et leurs sources divergentes ne suffisent pas.
- DHB-PERSISTENCE : Save/notification/rendu, cancel/default, provider/fichier durable et interaction du writer conditionnel. Reprise sur cycle complet nommé, sans prétendre à un live non déclaré.

## R6 — Correction et suite

HUD-OPTIONS-ENTRY-01 et HUD-LOCAL-RENDER-01 sont conservées. Une proposition distincte HUD-HEALTH-BARS-SETTING-01 porte la qualification du lecteur natif puis le raccord du réglage aux rendus existants concernés. Elle ne reconstruit pas toutes les barres et ne remplace pas leur audit de fidélité locale. Prérequis, critères0/1/refus/récupération, Save et reprise sont dans la preuve ; proposition non appliquée et hors registre normatif.

Prochain contrôle : ShowSummonerNames ligne99, checkbox savecfg. Réutiliser les contrats communs et distinguer données de roster/noms et affichage/nameplates effectif avant de conclure.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HEALTH-BARS-SETTING-01\health-bars-setting-proof.json`, SHA256 `8a020b073702341daa9f55cb304589676e212dfbb6dfdd0061762036faedf6f5`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HEALTH-BARS-SETTING-01\verify_health_bars_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-HEALTH-BARS-SETTING-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md ; le producteur seul ne clôt pas le lot.

Nouveaux documents isolés uniquement. Goal, critères, registres, code, assets, application de suivi, interface, bases, historiques et preuves antérieures inchangés. Aucune installation, migration, application redémarrée ou clôture fonctionnelle/globale.
