# AUD-17.5-01-MOVIE-PROVENANCE-01

UTC: 2026-10-31T04:42:16.604897+00:00. Parent SYS-17.5-01, exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et fin du lot
Inventaire fini des movies présents dans DATA du client original4.20 et des cinq ZIP qui y sont présents;rapprochement avec les littéraux du PE et les preuves déjà disponibles. Question:quelles sources physiques existent,quels noms sont réellement présents dans le binaire,et quelle sélection reste non établie? Fin documentaire:86identités,groupes et limites vérifiés,offsets datés,consommateurs actuels bornés et reprise précise. Aucun contrôle natif interne ni fonctionnalité déclarés terminés;parent et goal restent ouverts.

## R2 — Sources et provenance
Référence4.20.0.315 EUW/en_GB,build2014-11-17 17:46:45,fuseau/déploiement inconnus. PE exact identifié par SHA dans la preuve;root DATA original et commande rg --files conservés.86fichiers gfx,aucun swf physique découvert dans ce périmètre;43dans Menu_SC4,1dans Menu_SC4/featured,42dans menu.75 269 613octets lus pour identification,sans copier les assets ni installer d’outil.

78hashes distincts,54basenames,32paires de mêmes noms et7groupes de doublons exacts.23ressources nommées fonts_*/gfxfontlib et63autres candidats:classement par nom uniquement,pas une preuve de rôle runtime ni23polices chargées. Tous ont le préfixe brut hex434658;aucun parseurCFX,script ou timeline exécuté. Cinq ZIP originaux ont leurs répertoires centraux inspectés,aucune entrée gfx/swf,pas d’extraction.

Neuf audits source existants relus:score,histoire,vote,résultats,boutique,tooltips,mort,retour et focus avec son lecteurv2 effectif. Les liens par ligne prouvent seulement une identité source ou une égalité d’octets déjà conservée dans cet ensemble choisi. Un asset haché dans une ancienne preuve ne signifie pas que tous ses contrôles ont été audités;une ligne non liée ici ne signifie pas absence de tout travail antérieur ailleurs.

## R3 — Correspondances et consommateurs
| Source physique relative | Octets | Classe candidate | Liens d’identité dans les neuf audits choisis |
|---|---:|---|---|
| menu/ChannelBar.gfx | 19646 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/CharacterInfo.gfx | 29833 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/ControlPointDisplay.gfx | 9270 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/DeathRecap.gfx | 26031 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/EndGameResults.gfx | 4030 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/EndOfGame.gfx | 20387 | other_movie_candidate | results |
| menu/fonts_ch.gfx | 5861947 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_cyrillic.gfx | 59840 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_dejavu.gfx | 210806 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_greek.gfx | 55821 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_kr.gfx | 1296852 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_latin.gfx | 47909 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_sg.gfx | 42891 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_th.gfx | 42891 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_tw.gfx | 5901784 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/fonts_vn.gfx | 181817 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/gfxfontlib.gfx | 8014742 | font_named_resource | Non lié dans cet ensemble de preuves |
| menu/HUD2.gfx | 87210 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/HUD2B.gfx | 70858 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/HUD2Test2.gfx | 70883 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/HUD2X.gfx | 70937 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/HudChat.gfx | 25576 | other_movie_candidate | history |
| menu/IME.gfx | 4417 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/ItemShop.gfx | 83406 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/MessageBox.gfx | 20395 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/MessageBoxSmall.gfx | 3174 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/MessageList.gfx | 9173 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/objectiveIndicators.gfx | 41319 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/OdinRespawner.gfx | 3269 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/Options.gfx | 45539 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/QuestTracker.gfx | 11529 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/RadialMenu.gfx | 17257 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/RainboomTooltip.gfx | 5541 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/ReplayUI.gfx | 58446 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/Scoreboard.gfx | 14743 | other_movie_candidate | score |
| menu/ScoreCallOut.gfx | 6183 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/Surrender.gfx | 21068 | other_movie_candidate | vote |
| menu/TipDialogue.gfx | 8454 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/TipTracker.gfx | 9977 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/Tooltips.gfx | 37908 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/UIHighlight.gfx | 7348 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| menu/VictoryPointDisplay.gfx | 15548 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/ChannelBar.gfx | 19538 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/CharacterInfo.gfx | 29310 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/CommTest.gfx | 28627 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/DeathRecap.gfx | 27276 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/EndOfGame_Default.gfx | 45088 | other_movie_candidate | results |
| Menu_SC4/featured/AscensionScore.gfx | 25661 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_ch.gfx | 5862744 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_cyrillic.gfx | 59840 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_dejavu.gfx | 210806 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_greek.gfx | 55821 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_jp.gfx | 7329309 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_kr.gfx | 1290278 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_latin.gfx | 47909 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_sg.gfx | 7329309 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_th.gfx | 7329309 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_tw.gfx | 5899596 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/fonts_vn.gfx | 181817 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/FoundryItemShop.gfx | 103724 | other_movie_candidate | shop, tooltips |
| Menu_SC4/FoundryOptions.gfx | 132101 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/gfxfontlib.gfx | 16086611 | font_named_resource | Non lié dans cet ensemble de preuves |
| Menu_SC4/HudAnimationOverlay.gfx | 40999 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/HudChat.gfx | 29521 | other_movie_candidate | history |
| Menu_SC4/IME_AS2.gfx | 4477 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/IME_AS3.gfx | 5778 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/ItemShop.gfx | 69813 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/ItemShopNew.gfx | 49653 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/MessageBox.gfx | 20550 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/MessageBoxSmall.gfx | 3248 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/MessageDisplay.gfx | 55123 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/MessageList.gfx | 8746 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/Options.gfx | 49442 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/QuestTracker.gfx | 15695 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/RadialMenu.gfx | 15337 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/RainboomTooltip.gfx | 5205 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/ReplayUI.gfx | 67833 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/Scoreboard.gfx | 20167 | other_movie_candidate | score |
| Menu_SC4/ScoreCallOut.gfx | 6255 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/SmartPing.gfx | 29636 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/Surrender.gfx | 21507 | other_movie_candidate | vote |
| Menu_SC4/TipDialogue.gfx | 8069 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/TipTracker.gfx | 10037 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/Tooltips.gfx | 38104 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/UIHighlight.gfx | 7385 | other_movie_candidate | Non lié dans cet ensemble de preuves |
| Menu_SC4/VictoryPointDisplay.gfx | 15704 | other_movie_candidate | Non lié dans cet ensemble de preuves |

43occurrences de suffixes ASCII gfx/swf sont enregistrées dans le PE avec offset fichier et octets exacts;25candidats plus ciblés concernent FoundryOptions,CharacterInfo,MessageBoxSmall,Menu_SC4,FoundryItemShop,HUD2Test2. Les offsets ne sont pas des adresses virtuelles,ni des xrefs/calls qualifiés. Les noms _global.gfx/scaleform.gfx et les autres correspondances ne sont pas automatiquement des requêtes de fichiers.

Les littéraux FoundryOptions.swf,CharacterInfo.swf et MessageBoxSmall.swf ne portent pas l’extension des sources physiques gfx. Une correspondance de stem propose des candidats,pas une résolution de provider/alias. Deux racines avec un même basename ne fixent pas la variante active. Le nom HUD2Test2 ne suffit pas à exclure un fichier comme test;le nom d’un mode ne suffit pas à le déclarer actif sur Map10.

FoundryQuickChat.swf est un littéral présent à offset fichier 0xcc1174. Aucun même-stem parmi les86sources et aucun fichier du même nom via recherche de noms dans toute la racine originale. Les cinq ZIP DATA n’apportent aucune entrée movie. Requis/atteignable/chargé reste inconnu;autres conteneurs non déchiffrés. Ce constat ne déclare pas un asset obligatoire manquant,ni un blocage du jeu.

Recherche client bornée gfx/swf/Scaleform/ExternalInterface/fscommand:un seul hit,commentaire de provenance Foundry dans shop_native_foundry.rs. Les vrais consommateurs inspectés construisent des ButtonBevy à partir de régions/DDS et chargent les images/catalogues terminaux dérivés;le providerHUD lit ses INI. Le manifeste conserve Bevy/flate2 comme contexte,il ne prouve pas à lui seul l’absence absolue d’un backend ou d’un nom dynamique. Aucun loader de movie natif identifié sur ces routes;aucun fonctionnement absent inventé depuis un grep seul.

## R4 — Attendu, observé et contrôles exécutés
Exécuté ici:Python et rg de lecture,empreintes des sources,liste physique/ZIP,comparaisons de groupes,octets/littéraux du PE,fragments exacts et rattachements aux tâches. Aucun REA,JPEXS,ActionScript,CFX,natif,Rust,jeu,GUI ou réseau exécuté;aucun test d’acceptation des movies fourni. Les neuf audits sont des preuves antérieures réutilisées,non des exécutions relancées. Le PE identifié est une source lue,non un binaire lancé.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Finite source inventory with no artificial control count | 86physical gfx files,78distinct hashes,54basenames,32paired names,7duplicate-byte groups;23font-named and63other candidates. | Filename-based roles only;not86menus or78controls or an execution percentage. |
| C2 | Check actual compression-container membership | All5DATA ZIP central directories inspected,no gfx/swf entries;no extraction performed. | Not a scan/decrypt of arbitrary archives outside named DATA/reference filename scope. |
| C3 | Keep request literals separate from physical paths | 43ASCII suffix occurrences include FoundryOptions.swf,CharacterInfo.swf,MessageBoxSmall.swf;physical candidates use gfx and may have two roots. | Raw byte/file offsets,not virtual addresses,loaded calls or qualified alias/provider order. |
| C4 | Do not invent a missing required feature | FoundryQuickChat.swf literal exists;no same-stem source in86inventory or loose filename search of original reference root. | Requiredness,reachability and other container contents not established;no game blocker asserted. |
| C5 | Reuse past source work narrowly | Nine closed source audits inspected;row links reflect actual pinned movie identity/byte equivalence within that selected evidence set. | Pinned artifact in a proof is not an audited full movie control tree;unlinked here does not mean never audited elsewhere. |
| C6 | Keep actual consumer scope | Current bounded literal/API search yields only one Foundry provenance comment;actual shop and terminal routes render Bevy controls/derived images. | No literal request identified does not prove absence of all dynamically named/backend callbacks;no native movie/UI executed. |
| C7 | Precise next source task | Shared selector/provider correction with existing Options/CharacterInfo/MessageBox tasks and a named first menu. | All internal native control trees and parent/global audit remain open;no software migration/install/fix. |

## R5 — Manques et conditions de reprise
Restent inconnus:provider réel,nom virtuel/extension/résolution,ordre classic/SC4/override,conditions d’activation de chaque movie,callbacks et arbre interne des contrôles. Les86assets ne donnent pas le dénominateur de tous les contrôles du HUD;les78IDs courants documentés ne deviennent pas78menus natifs.

Reprise utile:partir d’un caller/xref discriminant des littéraux Options déjà localisés,identifier le provider et une branche de sélection,puis seulement recenser les contrôles du movie effectivement choisi. Ne pas rescanner tous les assets à l’identique. Pour QuickChat,condition/caller/containernouvellement identifié avant recherche supplémentaire;la nécessité du fichier doit précéder toute reconstruction. Pour une politique locale choisie faute de source,nommer/versionner sa différence avec4.20.

## R6 — Réutilisation et prochain petit lot
Fiches conservées:HUD-OPTIONS-ENTRY-01,HUD-CHAMPION-INFO-ENTRY-01,HUD-MESSAGEBOX-LIFECYCLE-01,avec les variantes physiques désormais identifiées. MessageBox.gfx/MessageBoxSmall.gfx ne sont pas les14templates de HUD/Elements/MessageBox.ini. Pas de duplication d’un chantier par fichier ou par police. Six tâches réelles du registre relues,statuts/critères inchangés.

### HUD-NATIVE-MOVIE-SELECTION-01
Qualifier une résolution de nom virtuel SWF vers sa ressource native et le choix de variante pour le menu Options.

Travail:
- Partir des littéraux FoundryOptions.swf/FoundryOptionsMenu et data/Menu_SC4 avec offsets du PE fourni; retrouver les xrefs/callers et le provider,distinguer offset fichier et adresse virtuelle.
- Établir nom virtuel,extension/alias,ordre des racines/overrides et branche de sélection entre Options et FoundryOptions;ne pas choisir la variante seulement depuis son nom ou le build.
- Sur une variante nommée,relier au futur consommateur actuel ou à une politique locale versionnée;réutiliser les fiches Options/Champion Info/MessageBox sans créer un moteur par fichier.
- Pour FoundryQuickChat.swf,qualifier d’abord l’atteignabilité/condition du littéral;aucun asset manquant obligatoire ni fonctionnalité requise inventé depuis ce seul nom.

Fin:
- Source/caller/provider et fichier choisi identifiés avec empreintes;cas nominal et refus/fichier absent/ambiguïté/override ont attendu-observé distincts.
- Alias .swf→.gfx attesté ou explicitement non résolu;un même basename dans menu et Menu_SC4 ne fixe pas le profil actif;pas de succès depuis une simple égalité de nom.
- Le premier menu traité a ses contrôles internes recensés et reliés aux callbacks/états ou manques précis;aucun pourcentage de jeu depuis86assets.

Reprise: Entrée présente:PE exact et25candidats de littéraux avec offsets,sources physiques et neuf audits réutilisés. Reprendre à un caller/provider discriminant pour Options,avec REA existant ou lecture statique autorisée,sans nouvelle recherche générale ni installation. Toute correction produit reste distinctement autorisée.

Proposition non appliquée. Aucun ID de contrôle courant ajouté:78restent78;aucun pourcentage. Reste: Close native movie selection/provider mapping for one named Options route,then reconcile internal native control trees with the existing78current IDs;full-HUD parent open. FoundryQuickChat source/requiredness unknown;stop broad missing-file searches until named caller/condition/container lead is available. Prior source-derived shop release-frame risk remains unexecuted;physical/runtime acceptance and all other resolution/readability requirements stay separate.

## R7 — Livraison et conservation
Nouveaux fichiers seulement:audit-unit.json,verify_movie_provenance.py,movie-provenance-proof.json,verify_delivery.py,delivery-readback.json et ce rapport. Producteur audit_scope_closed=false;relecture séparée des sept rubriques pour clore uniquement la provenance/inventaire fini. parent_documentary_scope_closed=false,fonctionnalité et goal non terminés;acceptation humaine non revendiquée.

Cinq registres,25fichiers protégés,1168sources et état suiviGit conservés. Aucun goal/critère/code produit/Plan/UI/base modifié ni base ouverte;aucune installation,migration,relance,retrait,export massif ou copie d’assets. Toutes les anciennes preuves restent conservées.

Preuve: F:\OpenLeague-work\audit-units\AUD-17.5-01-MOVIE-PROVENANCE-01\movie-provenance-proof.json. Relecture: F:\OpenLeague-work\audit-units\AUD-17.5-01-MOVIE-PROVENANCE-01\delivery-readback.json.
