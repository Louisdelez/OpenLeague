# AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01 — checkbox MinimapMoveSelf

Date : 2026-10-31T10:36:16.121499+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un seul contrôle : `OPT-SRC-78378f533df9d828`, FoundryOptionsMenu.xml ligne133, `[HUD]MinimapMoveSelf`, `strategy=savecfg`, `updateonclick=true`. Identifier son contrat AS, ses sources/fallbacks, les gardes visibles et le chemin de minimap actuel. La fin est documentaire : le rôle exact du subscriber/contrôleur natif, les états rendus et le cycle complet restent ouverts. Relecture séparée avant clôture.

Audit : déclaration, modèle/vue, demandes et consumers actuels inspectés. Implémentation : déplacement local existant, raccord de ce réglage non établi dans son chemin. Vérification : sources et preuves héritées, pas de nouveau runtime. Acceptation humaine : non demandée. Parent et goal ouverts.

## R2 — Sources et provenance

Le recensement gelé relie checkbox→ModelCheckbox→ViewCheckbox→mcCheckBoxWithLabel. Les fragments AS sont vérifiés dans l'export original déjà produit, y compris CheckBox/Button CLIK. Aucun export ou désassemblage nouveau. PE de référence 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; il n'est pas exécuté.

Le Game.cfg de défaut fourni avec le client original et sa copie actuelle sont identiques : SHA256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`, ligne81 `[HUD]MinimapMoveSelf=1`. Cela identifie les octets fournis, pas le fichier effectivement monté en2014 ou au lancement courant. Les candidats de configuration utilisateur/deploy sont relevés séparément, sans les prendre pour des défauts historiques ; les absences sont limitées à leurs chemins exacts. Aucun loader susceptible de créer/renommer des fichiers n'est appelé.

Les audits antérieurs de Save, volume live et minimap sont conservés à leur portée. Leurs 26 anciens cas de composant minimap et sources concordent ; aucun n'est rejoué ni présenté comme un test on/off de MinimapMoveSelf. Le callback MasterVolume ne sert pas de callback minimap.

## R3 — Contrat et consumers

ModelCheckbox utilise `ReadGameCfg(HUD,MinimapMoveSelf,"0")` en environnement ingame ou GFXplayer lorsque section **ou** nom existe. Les chaînes exactes 0/1 sont conservées ; `false` insensible à la casse devient0, toute autre chaîne non nulle devient1. Aucun garde NULL local avant toLowerCase. Hors de cette branche le modèle vaut0. `restoreDefaults` appelle le lecteur de défaut puis setValue/CHANGE **sans** refaire la normalisation d'init.

Utility retourne directement le fallback en GFXplayer. Le preview vaut donc0 avec ce contrat, même si le fichier physique fourni contient1. En ingame, le callback et le provider déterminent la chaîne réelle ; ils ne sont pas observés ici. Ces deux fallbacks ne prouvent pas un bug.

La vue utilise Boolean(Number(value)), éventuellement inversé par NEGATEVIEW. Les cas canoniques0/1 s'appliquent sans négation effective. Le contexte/paramétrage/timeline réel n'est pas supposé. Son clic inverse vers une chaîne canonique0/1 puis appelle setValue et, si updateonclick est vrai, setLiveValue. Le handler de vue n'a pas son propre test enabled.

CLIK CheckBox est toggle=true et autoRepeat=false. Button.enabled demande l'état disabled ; son handler MouseRelease refuse un composant désactivé ou un bouton non primaire **avant** l'émission ButtonEvent.CLICK. Ces branches sont qualifiées dans le code, pas par une interaction physique ou un pixel. L'appel direct du handler de vue ne représente pas cette suppression par le framework.

**updateonclick n'est pas limité au clic** : receiveModelChange appelle aussi applyLiveUpdate, notamment lors de l'initialisation de la vue, d'un défaut, undo ou sync. Le journal conserve savecfg pour la sauvegarde différée, mais setLiveValue construit une demande séparée avec stratégie **live**, sectionHUD, cléMinimapMoveSelf et valeur. GameSerializer l'envoie via Update. Une demande live n'est pas une écriture disque immédiate. Save commit puis batch/reset selon le contrat déjà audité ; Cancel conserve son premier baseline live et son undo normal. Acquittement, ordre effectif, exceptions, subscriber précis et durabilité restent ouverts.

Le chemin courant est réel : Plugin minimap installé, collecteur ordonné, intention Move au press droit frais/éligible, inverse de projection, cellule marchable puis Connection.send_action. Contexte/session/epoch, focus, resize/Esc, shop, inventaire, capture caméra, état de partie et transport imposent leurs gardes. Le geste gauche de caméra est séparé.

La recherche du nom sur 1168 fichiers de code ne trouve aucun hit, mais la conclusion ne repose pas sur ce seul nom : signature d'input, Context, branche de génération et send_action sont inspectés. Ils ne consomment ni Loaded/lookup texte ni paramètre MinimapMoveSelf. Le chargeur générique Game.cfg et ses données existent ; ils ne constituent pas ce raccord. Cette conclusion est bornée au chemin ordinaire inspecté, sans absence globale de toute fonction de configuration. Le rôle natif exact de0/1 ne se déduit pas du nom seul.

## R4 — Attendu et observé

Sept cas documentés :0,1, preview/fallback, normalisation init distincte de restore, guards disabled/nonprimaire, live/save/cancel, et chemin Move courant. La preuve précise pour chacun l'attendu, l'observé dans les sources et les contrôles non exécutés. Factory/XML/export, défaut fourni, consumers, 26 cas anciens et identité des sources vérifiés. Corpus1168, 25 fichiers protégés, cinq registres et Git conservés.

Deux consultations ont refusé un ancien nom de reçu et des optionsrg mal placées ; ces retours n'ont servi de preuve d'absence. La requête Python bornée et l'inspection du chemin effectif sont autoritaires. Aucun jeu, x86, AS, Rust, GUI, OS/IME, input physique, réseau, test ou lecteur ancien, export, archive, installation, migration ou loader productif exécuté.

## R5 — Manques et reprise

- `MMSELF-NATIVE-EFFECT` : sélection du fichier, subscriber live/savecfg et effet exact sur l'input d'origine. Reprendre une référence/contrôleur nommé ; ni le nom ni la valeur physique1 ne suffisent.
- `MMSELF-CURRENT-BRIDGE` : raccord de la configuration à l'entrée minimap et preuve spécifique0/1. Reprise produit distinctement autorisée, avec sémantique native ou contrat local versionné explicitement autorisé.
- `MMSELF-UI-RUNTIME` : environnement, définition, NEGATEVIEW, objets, timeline/frames disabled et input physique/clavier réels. Les guards CLIK restent des preuves de source.
- `MMSELF-LIVE-PERSISTENCE` : application/annulation/défaut, acquittement, fournisseur/fichier utilisateur et reprise durable. Une demande Update ou un journal n'en est pas la preuve.

Chaque manque comporte impact et entrée de reprise. Aucune équivalence native complète ni anomalie visuelle n'est inventée.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01, HUD-MINIMAP-MOVE-STATE-01 et MM-PROJECTION-01 sont réutilisées avec leur définition inchangée. Une seule proposition nouvelle : **HUD-MINIMAP-MOVESELF-SETTING-01**, qualifier puis raccorder ce réglage nommé au chemin d'entrée. Elle est distincte de la qualification d'un geste et du menu générique. Son préalable est de confirmer le rôle natif de0/1 ou un contrat local versionné autorisé ; elle ne présume pas que le nom suffit à définir les gestes. Critères, contrôles et reprise figurent dans la preuve. Proposition documentaire non appliquée, aucun registre ni plan modifié.

Prochain contrôle : **AUD-17.5-01-OPTIONS-MINIMAP-FLIP-01**, `[HUD]FlipMiniMap`, checkbox adjacent ligne132. Réutiliser les classes/gardes/save/live déjà établis, puis inspecter les consumers de disposition avant de conclure à une absence ou à un changement de côté. Aucun nouveau dénominateur ou compteur de contrôles HUD.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01\minimap-moveself-proof.json`, SHA256 `902787bf472e51ddab4cc6e3e13a80cb99cc5a91717f009336f6b7a80d0758f9`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01\verify_minimap_moveself.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01\audit-unit.json`. Relecture `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Nouveaux artefacts documentaires isolés uniquement. Goal, critères, registres, code, assets, suivi, interface, bases, anciennes cases/notes/historiques et preuves antérieures inchangés. Aucun achèvement fonctionnel, du parent ou du goal global.
