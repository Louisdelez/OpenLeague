# AUD-17.5-01-OPTIONS-MINIMAP-SCALE-01 — MinimapScale

Date : 2026-10-31T11:07:57.249649+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un contrôle : OPT-SRC-acc6fd8737993f0d, slider ligne95, `[Globals]MinimapScale`, scale1, datasource MinimapScaleDatasource. Fin documentaire : déclaration, domaines de valeur, fournisseur nommé, consommateurs actuels, limites et reprise relus. Le parent, la fonctionnalité et le goal demeurent ouverts ; aucune acceptation humaine déduite.

## R2 — Sources et provenance

Recensement/export AS et contrat slider du lot LIVE-VOLUME réutilisés, avec save/live/checkbox communs du dernier lot. PE4.20 (SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862) et outils statiques existants identifiés ; aucune installation. Locale en_GB ligne765 : Minimap scale. Les quatre candidats Game.cfg fournis ne contiennent aucune ligne Globals/MinimapScale ; le chemin F exact reste absent. Ce constat n'établit pas la réponse du provider historique.

## R3 — Contrat et consommateurs réels

**AS.** scale1 est divisé par100 : appliedScale0.01. Le modèle convertit l'affichage en valeur normalisée, arrondit à trois décimales et affiche un uint du ratio. Le ViewSlider fixe minimum0, maximum100, snapInterval1 par défaut ; ce dernier n'active pas snapping, dont le défaut de classe est false. Définition/timeline effectives non observées. Le datasource déclaré supprime la lecture initiale ReadGameCfg du modèle. La vue demande le callback nommé à sa première activation, transmet l'objet au modèle et marque la demande traitée ; aucun retry/validation d'objet complet n'est déduit de ce chemin.

Le modèle teste la vérité de defaultValue et value : le nombre0 est ignoré, la chaîne0 est traitée ; l'événement CHANGE demeure envoyé. Restore préfère le défaut de datasource déjà conservé, sinon le lecteur de défaut avec fallback0, et normalise différemment d'un simple événement. Sync et getValue ont leurs conversions propres. Les setters du modèle ne constituent pas un validateur général des limites d'UI.

Les flags LiveUpdateSlider de premier clic/pendant drag sont false par défaut ; endDrag et trackPress émettent un live event après leur super appel. Les branches du composant CLIK, ses enfants enabled et la frame disabled sont lues dans les sources, sans prétendre avoir exécuté un événement physique ou un état rendu. L'affectation programmatique de valeur et le refus d'input sont distincts. Le cycle de journal/save/undo est hérité ; normal strategy regular est conditionnelle au contexte réel, sans savecfg explicite sur ce contrôle ou ses ancêtres physiques.

**Natif statique.** La séquence82FDBC lie le nom à830430. Ce callback lit le champ physique+4 de l'objet [contexte+0x94] et calcule `(physique - 0.5) * 2`. Le helper830230 construit des propriétés numériques value et **defaultValue=1**. Les valeurs debug0.9/0.2 viennent d'un autre chemin FlashPlayer ; elles ne sont ni le résultat du callback natif ni des défauts historiques acceptés.

L'initialisation7F82F2 passe un fallback physique1 à8B1F50 pour Globals/MinimapScale et montre une borne physique finie0.5..1 avant stockage. Le subscriber nommé est associé statiquement à7F91C0. Il appelle le parseurC9BB65 puis borne les valeurs finies en bas à **float32(0.01)** ; il stocke ensuite `(valeur + 1) * 0.5`, en opérations float32, avant les appels7F8C40/7F8D30 et éventuellement825E90. Aucune borne supérieure ne figure dans cette portion d'affectation. Le cas0 donne donc environ0.505 avant les appels suivants, et1 donne1 ; ne pas le remplacer par une formule générique0.5+0.5*x sans cette borne. Les exemples calculés en Python sont dérivés des instructions, pas des exécutions du parseur ou du callback. NaN/inf, grammaire/locale, contexte et effets après ces appels restent ouverts.

7F8C40 lit le champ physique+4, formate `%.4f` et demande au setter8B2B10 d'écrire Globals/MinimapScale. Cette demande ne prouve ni disque, ni acquittement, ni reprise après redémarrage.

**Courant.** native_hud_viewport initialise scalar1 et rafraîchit sur changement de dimensions. native_minimap et camera_lock_ui utilisent le payload générique avec ce facteur. native_hud_layout ignore son facteur propriétaire dans la branche KeepMaxScale ; les neuf enregistrements minicarte/caméra par côté portent KeepMaxScale1 dans les sources déjà relevées. Affecter aveuglément Viewport.scalar n'implémenterait donc pas ce réglage et risquerait de viser d'autres panneaux. Un contrôleur propre à la minicarte et sa propagation restent à qualifier.

Le rectangle produit alimente déjà marqueurs et Live.rect ; l'entrée inverse utilise ce même rectangle et ses bits de contexte annulent les captures périmées. Gardes de dimensions, valeurs finies, hors rectangle, focus/session/UI/terrain conservées. Recherche de noms sur1168 fichiers et inspection des chemins réels : aucune consommation nommée MinimapScale ni raccord trouvé dans ces chemins, sans conclure à l'absence de toute fonction HUD/configuration.

## R4 — Attendu et observé

Sept cas couvrent déclaration/domaines, datasource et zéro, formules natives finies, configuration/fallback, live/save/limites, géométrie courante et frontières de preuve. Les sept fenêtres d'instructions et constantes sont conservées octet par octet. Analyse statique nouvelle et algèbre descriptive ; aucune instruction originale, AS, Rust, jeu, GUI, input physique, réseau ou loader productif exécuté. Les26 anciens cas CPU sont réutilisés sur les mêmes sources et données, sans devenir des tests de changement d'échelle. Corpus1168,25 fichiers protégés, cinq registres et Git contrôlés avant/après.

## R5 — Manques et conditions de reprise

- MMSCALE-NATIVE-CONTEXT : contexte/provider effectifs, parseur et dispatch réels. Reprendre un contexte nommé ou une politique locale versionnée autorisée ; ne pas recommencer la recherche du nom déjà résolue.
- MMSCALE-GEOMETRY-BRIDGE : propagation native7F8D30/825E90 et contrôleur courant propre à la minicarte. Reprise produit distinctement autorisée et source géométrique ou contrat local explicite.
- MMSCALE-UI-TRANSITION : définition/timeline/snapping, zéro numérique/chaîne, états physiques/disabled, deux côtés et viewport/DPI. Reprise sur menu/build/scénario identifié ; gardes source seules insuffisantes.
- MMSCALE-PERSISTENCE : init/live/default/cancel/save/reload, provider/fichier durable et stratégie effective. Reprise sur cycle complet, séparée des demandes Update/setter.

## R6 — Correction et suite

Corrections menu, Move, projection et caméra réutilisées inchangées. Dépendance au lot Flip conservée. Une seule proposition nouvelle : HUD-MINIMAP-SCALE-SETTING-01. Elle décrit le datasource nommé et le contrôleur propre à la minicarte, les domaines exacts, les deux dispositions, image/cadre/caméra/marqueurs/input cohérents, capture périmée refusée et cycle de configuration. Elle ne duplique pas le geste ou le changement de côté. Prérequis, critères et reprise figurent dans la preuve ; aucune application ni écriture dans un registre normatif.

Prochain réglage : GlobalScale/GlobalHudScaleDatasource, slider93 ; réutiliser ce contrat slider et le helper objet commun, examiner seulement le nouveau callback et ses consommateurs.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-SCALE-01\minimap-scale-proof.json`, SHA256 `7b02c8d766bfe3368ad309b82ad044ca1f40b01e16be753ff2c52154a8cf3572`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-SCALE-01\verify_minimap_scale.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-SCALE-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md. Le producteur seul ne clôt pas le lot.

Nouveaux documents isolés uniquement. Goal, critères, registres, produit, assets, application de suivi, interface, bases, notes/historiques et preuves antérieures inchangés. Aucune installation, migration, reprise d'application ou clôture fonctionnelle/globale.
