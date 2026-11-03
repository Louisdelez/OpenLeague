# AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01 — première capacité,Options et raccourcis

2026-10-31T08:01:15.579207+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Une famille :première capacité,base/normal/rapide et frontières self/apprentissage. Identifier déclarations,lecture,états frontend,payload et entrée actuelle. Ne pas terminer toutes les commandes,les122 kits ni le menu entier. Producteur non auto-clôturant ;la relecture décide de cette seule portée.

Audit :sources et consommateurs inspectés. Implémentation :entrée Q présente,configuration native des modes/remapping non établie dans ce chemin. Vérification :statique et preuves CPU héritées. Acceptation humaine :non demandée. Parent SYS-17.5-01 et goal restent ouverts.

## R2 — Sources et identité

FoundryOptionsKeybinds.xml :evtCastSpell1 quickbindcomponent ligne18 ;evtNormalCastSpell1 keybindsingle ligne43 ;evtSmartCastSpell1 keybindsingle ligne51. Self,smart+self,learn délimitent la famille lignes59/67/75. Ancêtres physiques game,GameEvents et strategy=input conservés ;aucun arbre actif simulé ni include reconstruit. Les six IDs OPT-SRC et offsets sont dans la preuve. La syntaxe non stricte connue ligne7 reste inchangée ;ce n'est pas un nouveau diagnostic de corruption.

Defaults/Input.ini original SHA930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1,30938octets,identique à la copie actuelle. Base evtCastSpell1=[q],smart=[Shift][q],self=[Alt][q],smart+self non affecté. Aucune ligne littérale evtNormalCastSpell1 dans ce fichier. Le nom dans les Options peut nécessiter un traitement du callback ;son absence physique ne prouve pas une fonction ou un asset manquant.

Trois fichiers d'entrée déjà identifiés sont distingués :defaults de référence,override deploy fourni et configuration utilisateur non historique. Les13 flags de l'override fourni ne deviennent pas des defaults du patch. L'erratum ERR-17.4-01-QUICKBINDS-01 conserve le nom exact [Quickbinds],sans altérer les preuves antérieures.

## R3 — Modèles,vues,payload et consommateurs actuels

ModelQuickBindComponent.populateKeybind attend quatre chaînes du callback Utility.ReadBindFromInputIni :défaut,utilisateur et leurs labels localisés. Il garde le premier binding pour le quickbind ;ModelKeyBind sépare deux alternatives. Le callback HandleReadBindFromInputIniEntry reçoit section/événement sans traduction de nom dans cette méthode AS ;son producteur natif et sa garantie de taille restent ouverts.

Les flags sont lus dans Quickbinds avec suffixes smart/self. Le modèle utilise défaut"0" si absent/vide et sélection utilisateur→défaut→"0",puis compare à la chaîne exacte"1". Ce chargement n'applique pas le test générique makeValueToBool("true") directement à la valeur brute ;ne pas déduire qu'une chaîne"true" charge le flag comme1. Les méthodes explicites couvrent(false,false),(true,false),(false,true),(true,true). Cela ne prouve pas quatre boutons actifs :ViewQuickBindsKeyBind.init relie le bouton smart ;le handler self déclaré ne prouve pas son branchement.

Le binding suit la stratégie input/section physique GameEvents. Les flags utilisent SerializeableValue(strategy=quickbinds,section=evtCastSpell1,key=smart ou self). Les labels localisés sont ignore. GameSerializer groupe par stratégie/section puis Update ;la concaténation native finale vers une clé INI n'est pas établie par ce payload. Modèle et callbacks natifs ne sont pas une preuve d'écriture réussie.

ModelKeyGrid annule sur le token Esc avant applyBind,échoue si aucun modèle actif ou si applyBind refuse,et gère les conflits dans ses enfants après affectation. Le dialogue ne relaie receiveKeyData que lorsque mode actif et grille enregistrée ;Start/EndKeybindInputMode sont des requêtes natives. Save/Cancel/persistance effectifs restent séparés.

Dans le code actuel,spell_input::Plugin est installé. Shortcuts lit KeyboardInput.key_code,conserve Q/W/E/R constants,échantillonne seulement Ctrl pour learn au keydown,garde une intention par slot/priorité QWER,ignore repeat et vide intentions/touches sur perte de focus. Shortcut contient slot et learn ;pas de préférence normal/rapide/self dans ce contrat. Les touches Shift/Alt ne sélectionnent pas un mode de capacité dans ce collecteur. Alt a par ailleurs un usage séparé de contrôle Tibbers au clic droit :pas une preuve de selfcast Q.

main.commands bloque notamment inventaire,shop focus,session non prête et partie terminée. Priorité objets→D/F→Learn→Cast non ciblé→picking ciblé/sol. AnnieQ utilise la cible,EzrealQ la position selon ground_target ;ces routes ne décident pas le mode normal/rapide. Les commandes vont à send_action et ses erreurs au diagnostic existant. Les gardes d'autorité/refus sont réutilisées de l'audit QWER,aucune nouvelle exécution serveur ou physique.

## R4 — Contrôles,attendu et observé

- Six déclarations et lignes,sections/stratégies,identités des trois Input.ini et copie defaults :vérifiées.
- 32 méthodes AS et6 fragments actuels bornés :branches de chargement0/1,quatre états,payload,Esc,focus,slot/gates et action réelle contrôlés sur source.
- Recherche exacte de11 noms dans1168 sources :0 lignes candidates. L'absence lexicale est bornée,elle n'exclut pas les alias ;les consommateurs réels ci-dessus sont inspectés,les noms trouvés ne sont pas des fonctions terminées.
- Audits17.4-01/02,QWER et recensement courant réutilisés avec leurs lecteurs. Les parents17.4-01/02 restent clos documentaires et incomplets fonctionnels. Groupes13 et14 tests CPU hérités,avec sources identiques :ils se recouvrent,ne sont pas additionnés et ne sont pas rejoués.
- Corpus,25 fichiers protégés,5 registres,Git et preuves antérieures inchangés. Aucun produit,AS,x86,Rust,GUI,input physique,réseau,chargeur,migration,installation ou nouvel export exécuté.

## R5 — Écarts et conditions de reprise

- **CAST1-NATIVE-CALLBACK** :Native producer of HandleReadBindFromInputIniEntry four-value result and evtNormalCastSpell1 alias/selection are not established here. Impact :An absent literal default row is not a missing asset or a proved absent normal-cast function. Reprise :Inspect actual callback registration/handler and original input provider under this exact version;qualify four positions,null/short returns,normal alias,default/user/localized selection without calling raw PE matches decoded xrefs.
- **CAST1-CURRENT-MODE** :No configurable normal/rapid mode is supplied to the identified Shortcuts→commands path. Impact :Q/default-target dispatch does not prove native normal or quickcast equivalence. Reprise :Reuse CAST-MODE-MODEL-01/ABILITY-01 and BIND-SPELL-DISPATCH-01 when product work is authorized;qualify press/release/confirm/cancel and targets before changing event timing.
- **CAST1-EDIT-PERSISTENCE** :Actual current edit/apply/cancel/reset/save/restart keymap and mode cycle is not established. Impact :Static HUD labels and generic Game.cfg handling are not Input.ini persistence. Reprise :Reuse BIND-LOAD/SAVE/EDIT-CONFLICTS/RESTART and CAST-MODE-EDIT;separate input strategy from quickbinds payload and preserve unused settings;qualify write errors.
- **CAST1-FOCUS-LAYOUT** :OS/physical delivery,keyboard-layout equivalence and complete UI/chat capture are not verified by retained CPU/source checks. Impact :Current key_code Q is not automatically historical logical [q] on every keyboard;Shift/Alt cast policy not shown. Reprise :Use an authorized physical/GUI scenario with named layout/window/context and current artifacts;retain keydown Ctrl sampling,repeat/focus reset,slot/action priority and no delayed replay.
- **CAST1-ACTUAL-CAST** :Full original key event→normal/rapid/self targeter→authority/result and physical current end-to-end equivalence remain unqualified. Impact :Model smart/self states and generated payload are distinct from server spell execution or acceptance. Reprise :Reuse existing QWER states,range/self audits and precise champion/slot evidence;test one supported ability in an authorized separate execution,not122 champion completion.

Les includes internes manquants ne sont pas recherchés à nouveau. La disposition clavier est explicitement ouverte :KeyCode physique Q et token logique historique[q] ne sont pas automatiquement équivalents pour tous les claviers.

## R6 — Corrections conservées

Dix définitions existantes réutilisées à l'identique :

- BIND-LOAD-01 :Charger une keymap effective de capacités et six slots objets depuis un fichier utilisateur identifié. Statut proposé/non appliqué.
- BIND-SAVE-01 :Sauvegarder une modification de keymap sans perdre les réglages existants. Statut proposé/non appliqué.
- BIND-SPELL-DISPATCH-01 :Appliquer les bindings de capacités et apprentissage à la boucle clavier réelle. Statut proposé/non appliqué.
- BIND-EDIT-CONFLICTS-01 :Éditer une affectation et appliquer une politique explicite de conflit. Statut proposé/non appliqué.
- BIND-RESTART-01 :Qualifier le parcours complet édition→sauvegarde→relancement→commandes. Statut proposé/non appliqué.
- BIND-NATIVE-PROVIDER-01 :Qualifier les priorités/activation du fournisseur historique de raccourcis sans assimiler AIR au jeu. Statut proposé/non appliqué.
- CAST-MODE-MODEL-01 :Définir et relire les préférences normal/rapide par action. Statut proposé/non appliqué.
- CAST-MODE-ABILITY-01 :Appliquer le mode choisi aux quatre capacités sans modifier leurs règles serveur. Statut proposé/non appliqué.
- CAST-MODE-EDIT-01 :Éditer une préférence de lancement et la persister dans le bon fichier utilisateur. Statut proposé/non appliqué.
- CAST-MODE-RELEASE-01 :Distinguer et appliquer l’option de lancement au relâchement. Statut proposé/non appliqué.

HUD-OPTIONS-ENTRY-01 reste conservée pour l'entrée du menu. Les faits nouveaux AS0/1,defaults et payload affinent seulement les preuves :aucune tâche,aucune case,aucun critère normatif changé,aucune correction annoncée implémentée. Les prérequis et limites des audits précédents restent valables.

Prochain résultat précis :AUD-17.5-01-OPTIONS-KEYBIND-NATIVE-READ-01,enregistrement et producteur natif du callback HandleReadBindFromInputIniEntry,quatre sorties et alias evtNormalCastSpell1. C'est une piste nouvelle fournie par les classes inspectées,pas une relance générale d'archives ou de liens.

## R7 — Livraison et relecture

Preuve neuve :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01\keybind-cast1-proof.json` (SHA93eecd44e4ce1da967b508c764f85768c209db8464f2c43b83d1231d1856c548).

Fiche :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01\audit-unit.json` ;script :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01\verify_keybind_cast1.py`. Relecture indépendante :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01\verify_delivery.py` →`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`. Seuls ces artefacts documentaires et ce rapport sont écrits. Goal,critères normatifs,suivi,interface,bases,code,assets et preuves antérieures conservés. Les78contrôles logiques précédents ne sont pas augmentés par ce recensement. Aucun pourcentage du jeu ni achèvement global.
