# AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01 — lecture native des bindings

2026-10-31T08:13:46.637275+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un callback :HandleReadBindFromInputIniEntry,son ordre de sorties et les frontières directement nécessaires à l'alias evtNormalCastSpell1. Trois corps normaux inspectés,aucune boucle input reconstruite. Producteur non auto-clôturant ;la relecture indépendante décide de la portée documentaire.

Audit :producteur et frontières identifiés. Implémentation :aucun changement,remapping/modes/persistance courants non terminés. Vérification :statique seulement,preuves existantes réutilisées. Acceptation humaine :non demandée. Parent et goal restent ouverts.

## R2 — Sources et provenance

PE original LoL4.20,15973880octets,SHA402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862,PE32x86 base400000. Le span d'enregistrement commun786E20..786F13 est réutilisé du lot Defaults ;push callback787390 à786E83,push nom10B6EC0 à786E88,call78D610 à786E8D. Le nom est lu dans les octets originaux ;aucune adresse devinée par proximité.

Le petit extracteur de découverte reconnaît sept sites push/push/call adjacents,donc pas un nouveau recensement complet des huit enregistrements :le premier site ReadGameCfg comporte une instruction intercalée et reste dans le span conservé.

Corps normaux qualifiés par prologue,flux de branches internes,épilogue/RET,padding et prologue voisin :787390..78781D,786F20..787146,8B16C0..8B17A7. Les deux fenêtres exploratoires restent intactes ;les fonctions voisines de8B17B0/8B1850 n'ont pas été fusionnées avec le getter. L'unwind SEH et les sous-appels restent hors de la qualification complète.

## R3 — Contrat natif et consommateurs

Le callback lit le pointeur d'arguments àcontexte+8,puis les données des deux premiers GFxValue (espacement de24octets),en suivant l'indirection du bit40h. Il ne montre pas de garde locale du nombre d'arguments ni du type de base avant ces lectures. Le proxy,le caller AS et les interfaces virtuelles peuvent avoir d'autres règles :aucune invocation invalide exécutée.

Première lecture :8B0630 avec section/événement reçus,DATA/CFG/defaults/Input.ini,repli vide etbuffer2D86D98/capacité13A0. Le texte est copié en SSO. Deuxième lecture :8B16C0 avec les mêmes pointeurs et le défaut comme fallback,puis copie du résultat. Aucun renommage explicite normal→base dans ces corps ;le getter construit un descripteur(section,événement,résultat8E51A0),appelle8B0750 sur le défaut,puis sur le filename SSO2D85628 initialisé par8B3CF0,avec résultat final enbuffer2D859F8. Les sémantiques des lecteurs/providers restent à qualifier.

Le chemin normal crée un carrier via movie.virtual9C,produit les chaînes viavirtual90/786F20,ajoute quatre éléments parvirtual3C,puis transmet le carrier àmovie.virtual84. Les rôles de ces slots sont recoupés avec Utility.ReadBindFromInputIni et les modèles AS existants,qui attendent un Array àquatre chaînes ;aucun objet retourné observé en runtime.

| Index | Valeur | Append natif |
|---:|---|---|
|0|Texte du défaut|787564|
|1|Texte effectif,avec repli possible sur le défaut|7875B9|
|2|Libellé localisé du défaut|7875FA|
|3|Libellé localisé effectif|78763B|

La position1 est appelée user côté AS,mais ce getter compose déjà un fallback :elle n'est pas forcément un override brut. Cette précision est intégrée à la preuve sans réécrire l'ancien rapport.

786F20 conserve une branche de marqueur[<Unbound>] sur retour0 de comparaison5FA720. Sinon,service2D77E80→virtual04→virtual6C produit une collection d'éléments24octets ;la branche count>1 convertit les deux premiers via6D77E0,avec virgule entre eux,sinon le premier. Aucune garde locale count0 avant la conversion du premier n'est démontrée. Traductions,layout,service concret et convertisseur restent ouverts.

Les consommateurs actuels et la recherche de noms du lot CAST1 sont réutilisés après vérification du corpus1168 :Q/Ctrl local,focus/gates etAction ne deviennent pas des modes natifs/remapping configurables. Aucun nouveau scan lexical ou test CPU inchangé. Les dix corrections et les audits précédents restent conservés dans leurs dimensions séparées.

## R4 — Attendu,observé et contrôles

- Nom exact et lien d'enregistrement :concordants dans le span aligné et les littéraux originaux.
- Trois corps normaux,519 instructions,35 points fixes vérifiés dans les octets ;fin/voisinage et branches contrôlés. Aucun x86/AS exécuté.
- Quatre append sites dans l'ordre indiqué et transmission finale ;rôle Array/chaînes qualifié par recoupement AS,garantie d'échec/exception non qualifiée.
- Défaut,effectif,branche du marqueur et une/deux alternatives :analyse statique nouvelle. Aucun test d'argument invalide ni de valeur réellement sélectionnée.
- Corpus1168,25 fichiers protégés,5 registres,Git et preuves antérieures conservés. Aucun produit,GUI,input physique,Rust,réseau,chargeur de configuration,installation,migration ou réexport lancé.

## R5 — Limites et reprises précises

- **KREAD-DESCRIPTOR-ALIAS** :Descriptor processing8E51A0 and common lookup8B0750/its providers may determine how the normal event is resolved. Impact :Literal absence of normal alias in defaults cannot be promoted to missing functionality. Reprise :Inspect the two directly called entries and their descriptor consumers on these pinned bytes;compare canonical/base event names only with a declared original source context. Stop at a precise downstream boundary.
- **KREAD-SELECTED-INPUT** :Lazy filename initialization8B3CF0 and effective native provider/cache/localized selection are not qualified for this callback. Impact :Default/effective order known,but exact runtime text remains unknown. Reprise :Reuse existing config/provider audits;identify actual SSO filename and inputs for a permitted context before any execution. Never treat supplied user files as2014defaults.
- **KREAD-ABI-FAILURES** :Argument count/type,allocation/virtual-method failures,EH and return guarantee for malformed invocations are not observed. Impact :Four outputs are a normal-path construction,not an unconditional safe return promise. Reprise :Identify proxy78D610 and movie interface contracts or execute a separately authorized isolated ABI probe;label null/short/invalid cases and outcomes precisely.
- **KREAD-DISPLAY-CONTEXT** :Service2D77E80,virtual6C,6D77E0 and zero-vector behavior,keyboard layouts and translations remain unqualified. Impact :Localized labels do not prove native key delivery or actual translated UI. Reprise :Reuse this bounded helper body;inspect the concrete service/vtable or qualified display converter with a new precise context;no whole-export repetition.
- **KREAD-BUFFER-LIFETIME** :Shared buffers2D86D98/2D859F8 termination,ownership,concurrent calls and native cache lifetime are not qualified here. Impact :Callback strlen/SSO copies and absence of local status checks are not bounds/reentrancy guarantees. Reprise :Reuse generic reader contracts and investigate only a concrete buffer/provider/thread lead;separate source caller assumptions from observed runtime failures.
- **KREAD-CURRENT-INTEGRATION** :Current configurable binding/mode editor and native-equivalent dispatch/persistence remain unestablished in identified consumers. Impact :Native read audit is not completion of the current Options functionality. Reprise :Reuse the ten binding/mode corrections from CAST1 and HUD-OPTIONS-ENTRY-01 when product work is authorized;preserve existing Q/Ctrl/focus semantics.

Les sorties sont établies sur le chemin normal,avec hypothèses de services/callers explicites ;aucune réussite ou refus inventé pour les autres contextes. L'absence littérale de evtNormalCastSpell1 dans le defaults ne devient pas une absence d'asset. La frontière précise est8E51A0/8B0750 et leurs consommateurs,avec8B3CF0 pour le filename. Les recherches d'archives/includes manquants ne sont pas relancées.

## R6 — Corrections et prochain résultat

BIND-LOAD/SAVE/SPELL-DISPATCH/EDIT-CONFLICTS/RESTART/NATIVE-PROVIDER etCAST-MODE-MODEL/ABILITY/EDIT/RELEASE restent proposées/non appliquées,définitions inchangées. HUD-OPTIONS-ENTRY-01 reste conservée. Le producteur natif et son ordre de sorties enrichissent ces preuves ;aucun doublon de tâche ni critère normatif changé.

Prochain lot :AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01,deux entrées8E51A0/8B0750,leur descripteur et traitement du nom de clé. Arrêt sur une frontière identifiée,pas de graphe natif global,d'exécution originale ou de nouvelle recherche générale sans piste.

## R7 — Livraison et relecture

Preuve :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\native-keybind-read-proof.json` (SHA245224af0870568f8a130315f7987aae93e150b282cf8abdd737cb52ba7afa08).

Découvertes conservées :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\native-read-static-inspection.json` et`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\native-read-callees-inspection.json` ;leurs deux scripts sont identifiés dans les reçus. Script de synthèse :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\verify_native_keybind_read.py`. Fiche :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\audit-unit.json`. Relecture séparée :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\verify_delivery.py` →`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01\delivery-readback.json` et`INDEPENDENT-REVIEW.md`.

Seuls ces nouveaux artefacts documentaires et ce rapport sont écrits. Goal,critères,registres,produit,assets,suivi,interface,bases etpreuves antérieures inchangés. Pas d'achèvement global ni de pourcentage de jeu.
