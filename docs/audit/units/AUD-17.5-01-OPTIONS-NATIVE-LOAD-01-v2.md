# AUD-17.5-01-OPTIONS-NATIVE-LOAD-01

UTC: 2026-10-31T05:11:25.540669+00:00. Parent SYS-17.5-01, exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et fin du lot
Qualifier statiquement la chaîne de requête OptionsFoundry/FoundryOptions.swf,les gardes du nom et les sources XML associées;écarter le faux lien du chemin image Menu_SC4. Fin documentaire:13plages d’instructions alignées,quatre xrefs validées,vtable et entrées XML identifiées,cas source et reprises précis. Ce fragment ne termine ni le choix du fichier physique,ni le menu,ni tous les contrôles du HUD. Parent et goal ouverts.

## R2 — Sources et outils
PE4.20.0.315 EUW/en_GB conservé;build2014-11-17 17:46:45,fuseau/déploiement inconnus. Relecture précédente MovieProvenance et sources/code1168identiques. Trois variantes physiques Options/FoundryOptions identifiées antérieurement sont conservées,aucune sélection déduite de leur seule présence.

REA:pas de connecteur exposé ni commande retrouvée dans l’inspection bornée projet/PATH;cela ne prouve pas son absence de tout le PC. Analyse en lecture seule avec pefile/Capstone déjà présents dans tools/pythonlibs;Python,sources de bibliothèques et capstone.dll identifiés par empreinte/version dans la preuve. Aucune installation. Capstone a exécuté son analyseur,aucune instruction originale LoL,émulation,jeu,Rust ou GUI exécutée.

Chaque plage conserve VA préférée sur ImageBase400000,offset fichier,octets/hash et instructions;aucune adresse de processus chargé n’est observée. Onze sont des fonctions entières jusqu’au ret final;deux sont des préfixes explicitement bornés. Les rôles sont des interprétations de code,non des symbolesPDB retrouvés. Les contextes exploratoires non alignés ne servent pas de preuve. Pas de compteur de tests natifs exécutés inventé.

## R3 — Consommateurs natifs et actuels
| Plage | Début | Fin exclusive | Portée | Rôle |
|---|---|---|---|---|
| request_prefix | 0x81f070 | 0x81f3af | Préfixe seulement | manager initialization prefix, not entire function; dynamic state not qualified |
| type_initializer | 0x52c8e0 | 0x52ca56 | Fonction entière | OptionsFoundry type registration source |
| callback_registration_thunk | 0x52ca60 | 0x52ca6c | Fonction entière | register constructor for same type definition |
| callback_registry | 0x8496b0 | 0x849746 | Fonction entière | registry callback assignment |
| factory | 0x8583d0 | 0x85843c | Fonction entière | global readiness/type registry lookup and adjusted return |
| allocator | 0x84c0d0 | 0x84c176 | Fonction entière | concrete constructor adapter and plus7C interface return |
| object_constructor | 0x82d640 | 0x82d6cb | Fonction entière | Options object base and secondary vtable writes |
| movie_load | 0x784900 | 0x784b93 | Fonction entière | As3Movie Load body; no original execution |
| filename_helper | 0x7842e0 | 0x7844d3 | Fonction entière | provider/config/override source branches |
| image_protocol_handler | 0x78e610 | 0x78e8e7 | Fonction entière | img protocol handler, not a movie provider alias proof |
| xml_owner_prefix | 0x82d770 | 0x82e091 | Préfixe seulement | native caller containing XML literal; runtime caller/lifecycle not inferred from adjacency |
| xml_build | 0x838020 | 0x838265 | Fonction entière | XML decoder build wrapper |
| xml_open | 0x838270 | 0x838385 | Fonction entière | XML provider existence/path/parser call and false returns |

La requête FoundryOptions.swf est poussée à81F37B,puis virtual+4 est appelé à81F382 sur l’objet issu de8583D0 et stocké au membre+98. La définition OptionsFoundry emploie le global2D6B498;son enregistrement choisit le callback84C0D0,qui construit via82D640 et retourne une interface+7C. La factory soustrait7C. Le constructeur écrit la vtable10C3F78,dont le slot+4 pointe784900. Cette liaison statique suppose la registry/readiness valide;elle ne prouve pas leur état réellement exécuté. Si readiness0 ou entrée absente,la factory retourne0;le caller n’est pas qualifié comme refus utilisateur sûr.

As3Movie Load784900 appelle7842E0 pour le nom. Filename/provider nuls et mapping vide produisent une chaîne vide;Load prend sa branchefalse et pose les flags observés. Attention:le premier appel provider+28 de7842E0 reçoit this+34,non directement le nom demandé;ne pas le simplifier en exists(FoundryOptions.swf). Le virtual+1C reçoit la demande;son implémentation réelle reste à lier.

Le helper lit Data/Cfg/Defaults/GamePermanent.cfg,[Flash]AllowOverrides,et le fichier original contient0à la ligne682. Valeur fusionnée effective/cache non qualifiés. Branche enabled:liste gfx;swf transmise à8B5330;branche disabled:chemin renvoyé par provider recopié;8B51C0 posttraite ensuite. Ni priorité des extensions,ni alias final swf→gfx,ni root/overrideeffectif établis par cette seule liste.

La référence data/Menu_SC4 à78E80D appartient à une fonction qui traite le protocole img://,compare un préfixe de6octets et utilise le format%s/%s. Elle ne prouve pas le provider des movies. Le comparateur et sa sensibilité à la casse ne sont pas exécutés ni devinés.

Un autre préfixe natif contient FoundryOptionsMenu.xml à82E036 et appelle838020,puis XMLOptionsDecoder::OpenXML838270. Le cycle/caller exact de ce préfixe n’est pas inféré depuis sa proximité au constructeur. OpenXML teste provider+28:branchefalse journalise et retournefalse;chemin+1C vide journalise puisfalse;sinon le booléen du parseur580EA0 est retourné. Cette source distingue présence,path et parsing,sans preuve d’acceptation native des fichiers fournis.

Le client actuel conserve son lecteur Game.cfg,EnvironmentQuality et F11 séparé. Les fragments et la recherche bornée de movies précédente sont repris sur les1168sources inchangées;aucun éditeur Options ajouté,aucun chargement produit potentiellement migrateur appelé.

## R4 — Attendu, observé et vérifications
Exécuté:lecture/empreintes,Capstone statique,alignement/longueur/ret et attentes d’instructions,vtable/xrefs,littéraux,parseur XML strictPython et recherche d’entrée manquante. Aucun binaireLoL,natif original,émulateur,Rust,jeu,GUI,clavier physique ou réseau exécuté. Les cas de branches natifs ci-dessous sont des observations de source,pas des exécutions paramétrées originales.

FoundryOptionsMenu.xml:11444octets,129descripteurs,cinq panneaux,trois includes;racine acceptée par le parseur strict. Les descripteurs/32option de dropdown ne sont pas129contrôles actifs. FoundryPhreakspace.xml:36descripteurs;garde onlyshowif conservé littéralement,sans deviner grammaire/priorité ou exclusion pour en_GB.

FoundryOptionsKeybinds.xml:refus strictPython à7:28,ligneconservée `<group onlyshowif="game"paddingbottom="7">`. Aucun octet réécrit. Refus du parseurPython ne prouve ni corruption ni refus natif;la tolérance de580EA0 reste à qualifier.

FoundryOptionsInternalPanel.xml:include sans onlyshowif dans la racine,non retrouvé dans le dossier du menu,la recherche de noms dans la racine originale et les cinq ZIP DATA. Le nom InternalPanel ne prouve pas optionnalité,ni obligation publique;mapping virtuel/autres conteneurs et politique de missing include restent inconnus.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Separate file offsets from VA and validate executable references | Four exact pointer occurrences lie inside saved aligned push instructions;PE32base400000 and .text/rdata mapping retained. | No runtime caller/stack,not arbitrary unaligned decode or proof every code path executes. |
| C2 | Resolve Options type request chain | OptionsFoundry definition→registry callback84C0D0→constructor82D640 writes vtable10C3F78 whose slot4 is784900;manager pushes FoundryOptions.swf and calls virtual4. | Registry readiness/current state not executed;zero factory result not declared safe handled user refusal. |
| C3 | Describe factory refusal boundary | Readiness byte0 or missing registry node returns0;adapter adds7C,factory subtracts7C under valid constructed-object assumptions. | No allocation/registry/runtime simulation or claim native frontend completed. |
| C4 | Keep filename helper conditions exact | Null filename/provider yield empty;provider+28 receives this+34 cached state,not request directly;virtual1C maps request,empty mapped string yields empty. | Do not rename preliminary check as exists(request);provider implementation/filename mapping remains unqualified. |
| C5 | Keep overrides conditional | GamePermanent Flash.AllowOverrides authored0;enabled helper passes gfx;swf to8B5330,disabled copies mapped path;8B51C0 postprocess remains. | Merged value/cache,effective root,extension priority and physical SWF→GFX resolution not established. |
| C6 | Separate image protocol false lead | data/Menu_SC4 use occurs in img:// handler with six-byte prefix comparison and %s/%s fallback. | This root occurrence does not qualify movie provider;comparator/case behavior not executed. |
| C7 | Trace XML source and failures | FoundryOptionsMenu.xml push82E036→838020→838270 OpenXML;provider false/path empty returnfalse,otherwise580EA0 parser bool returned. | Caller lifecycle of owner prefix,include handling and native parsing tolerance remain open. |
| C8 | Check actual XML inputs without modifying them | Root strict XML accepts129nodes/fivepanels/threeincludes;Phreak36nodes;Keybinds rejects7:28;InternalPanel name absent in folder/reference filenames/fiveZIPs. | Strict XML rejection not native corruption;unconditional include not assumed optional/required;conditional guards not evaluated. |
| C9 | Preserve actual current consumers and scope | Startup settings and F11 remain,old bounded current movie-query reused on identical1168source hashes;no editor added. | Audit source chain only;no original/game/Rust/GUI/physical test or complete Options/control census. |

## R5 — Limites et conditions de reprise
La chaîne statique Options request/type/vtable/Load est identifiée. Le fichier physique réellement choisi reste indéterminé:il manque le provider+1C/+28,l’ordre des roots/overrides,l’effet précis de8B5330/8B51C0 et la valeur fusionnée effective. Aucune recherche générale de noms à répéter;partir de ces cibles ou du caller de registry.

Le graphe XML complet n’est pas fermé:Keybinds est seulement refusé par le parseur strict et InternalPanel reste sans contenu physique identifié. Reprise au parseur580EA0/handler des includes/provider ou à un paquet nouveau précisément nommé. Ne pas réparer la grammaire,assumer l’include optionnel ou compter des widgets de rendu depuis ces seuls indices. Tous les contrôles internes/callbacks/états visibles restent hors clôture de ce fragment.

## R6 — Corrections réutilisées et petit lot suivant
HUD-NATIVE-MOVIE-SELECTION-01 reste ouvert avec les nouveaux points d’entrée exacts;HUD-OPTIONS-ENTRY-01 conserve ses critères de vrai menu,current frontend,focus/apply/cancel. Le défaut de configuration et les variantes physiques sont préservés;aucun statut/critère normatif changé.

### HUD-OPTIONS-XML-INPUTS-01
Qualifier les entrées XML d’Options et leur traitement natif avant de prétendre un recensement complet de ses contrôles.

Travail:
- Préserver les trois fichiers originaux et le défaut AllowOverrides;ne pas ajouter silencieusement d’espace dans Keybinds ni reconstruire InternalPanel depuis son seul nom.
- Suivre le provider+28/+1C de XMLOptionsDecoder::OpenXML et le parseur580EA0;qualifier la ligne7 colonne28 et le handler des includes,notamment l’include sans garde InternalPanel.
- Résoudre le chemin/mapping/contenu InternalPanel ou établir par source le comportement en son absence;ne pas déclarer optionnel depuis Internal ni obligatoire pour EUW depuis un include seul.
- Réconcilier les onlyshowif et les includes avec une grammaire/politique nommée;ne pas décider la priorité logique du garde Phreak ni confondre129descripteurs et129contrôles.

Fin:
- Acceptation/refus natif de la syntaxe exacte et des entrées absentes/inconnues a attendu/observé identifiable;le refus du parseurPython reste séparé.
- Le graphe d’entrées réellement choisi est fermé ou ses exclusions sont justifiées par source;callback/autorité/persistance et champs absents gardent des tâches distinctes.
- Aucun octet source ni registre modifié;si une reconstruction doit être autorisée plus tard,provenance,différence et comparaison sont explicites.

Reprise: Entrées précises:XML11444octets,ses includes,refus Python7:28,provider virtuel+28/+1C et580EA0 aux adresses sauvegardées. Nouvelle source/caller/parser/paquet discriminant avant toute autre recherche large;correction produit distinctement autorisée.

Proposition documentaire non appliquée.78IDs courants restent78;aucun nouveau contrôle fonctionnel ni pourcentage. Reste: HUD-NATIVE-MOVIE-SELECTION-01 remains open:resolve virtual provider+1C/+28,8B5330/8B51C0,effective profile/root/override and actual chosen physical movie;do not repeat raw literal scan. Options internal source graph incomplete:Keybind native acceptance and InternalPanel mapping/missing policy unresolved;root129descriptors not full native control denominator. Parent SYS-17.5-01/global audit and implementation/physical acceptance remain open;existing current78IDs unchanged.

## R7 — Livraison et conservation
Nouveaux fichiers seulement:audit-unit.json,verify_options_native_load.py,options-native-load-proof.json,verify_delivery.py,delivery-readback.json et ce rapport. Producteur audit_scope_closed=false;relecture séparée des sept rubriques pour clore seulement les références/branches/source XML bornées. parent_documentary_scope_closed=false,fonctionnalité/goal non terminés,acceptation humaine non revendiquée.

Cinq registres,25fichiers protégés,1168sources et état suiviGit conservés. Aucun goal/critère/code produit/Plan/UI/base modifié ou base ouverte;aucune installation,migration,retrait ou relance. Sources natives et XML laissés intacts.

Preuve: F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NATIVE-LOAD-01\options-native-load-proof.json. Relecture: F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-NATIVE-LOAD-01\delivery-readback-v2.json.

## Correction de livraison — relecture v2

La première relecture attendait la phrase «ne sont pas des exécutions paramétrées originales»,alors que le rapport disait «sont des observations de source,pas des exécutions paramétrées originales». La v2 vérifie cette limite explicite,le flag original_x86_or_emulation_executed=false et la méthode non exécutée de chacun des neuf cas. Aucun fait technique,code ou critère normatif modifié. Premier rapport,script et reçu d’échec conservés;preuve producteur inchangée.

Fichiers complémentaires:reader-attempt-1-failure.json,readback-correction.json,verify_delivery_v2.py,delivery-readback-v2.json et ce rapport-v2. Le rapport original demeure conservé. La clôture documentaire demeure conditionnée à la réussite des sept rubriques de la relecturev2;parent et goal restent ouverts.
