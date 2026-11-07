# AUD-17.5-01-NATIVE-HUD-CENSUS-01

UTC: 2026-10-31T04:13:06.449249+00:00. Parent SYS-17.5-01, exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et critère de fin
Recensement documentaire fini des32fichiers configurés du HUD normal ShadowIsles et rattachement de leurs703ressources aux audits de consommateurs. Compléments ciblés:rappel,partition Evolution,templates équipe/MessageBox et nature automatique du récapitulatif de mort. Fin du lot:liste source exacte,provenance des deux restaurations,consommateurs/absences bornées et corrections réutilisables vérifiés. Ce lot ne termine pas la fonctionnalité ni tous les contrôles du HUD; parent et goal ouverts.

## R2 — Sources, provenance et réutilisation
4.20.0.315 EUW/en_GB,build2014-11-17 17:46:45,fuseau/déploiement inconnus. Le PE et les HUD.zip original/local sont identifiés dans la preuve. FastHUD.ini choisit le profil ShadowIsles/ElementsListNormal dans le consommateur actuel; le fichier de liste est lu directement depuis le ZIP.32membres dans leur ordre exact et703IDs qualifiés par fichier/ordinal sont enregistrés. Il s’agit de lecture lexicale Python,pas d’exécution du parseur ou du chargement produit.

Deux overlays existants conservés:TargetBar_Buffs.ini et LossOfControlUI.ini. Leurs octets/hash sélectionnés restent distincts des originaux. L’audit antérieur établissait703records bruts,702acceptations individuelles et677acceptés dans la boucle native entière; sélection restaurée703états structuraux. Ces résultats sont hérités,aucun analyseur natif relancé. Géométrie/flags acceptés ne signifient pas contrôle actif.

Douze audits source préexistants sont relus par leurs preuves/lecteurs/rapports:layout,learning,death,tooltips,notifications et sept familles SYS-17.1-02..08. Le précédent sous-lot AUX est également conservé. Aucun rescan web ni lien communautaire accumulé.

## R3 — Recensement et consommateurs
| Fichier configuré | Records sélectionnés | Variante | Rattachement / constat |
|---|---:|---|---|
| CenterHUD_Buffs.ini | 160 | original | Durations/icons/hover candidates: old buff and tooltip audits; no new input inferred. |
| CenterHUD_PositioningDummies.ini | 6 | original | Position/layout resources; native activation callbacks are not defined by geometry. |
| CenterHUD_HealthBar.ini | 13 | original | Own HUD values/portrait/inventory/respawn mixed resources; existing per-family consumers retained, not all records rendered. |
| CenterHUD_PARBar.ini | 13 | original | Own HUD values/portrait/inventory/respawn mixed resources; existing per-family consumers retained, not all records rendered. |
| CenterHUD_AbilitiesSpellPassive.ini | 5 | original | Passive visual and hover content; no active cast inferred from Enabled. |
| CenterHUD_AbilitiesSpell0.ini | 12 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| CenterHUD_AbilitiesSpell1.ini | 12 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| CenterHUD_AbilitiesSpell2.ini | 12 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| CenterHUD_AbilitiesSpell3.ini | 12 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| CenterHUD_AbilitiesSpellSummoner0.ini | 10 | original | Existing D/F typed states; no additional control per sprite. |
| CenterHUD_AbilitiesSpellSummoner1.ini | 10 | original | Existing D/F typed states; no additional control per sprite. |
| CenterHUD_AbilitiesSpellRecall.ini | 5 | original | Five authored Recall resources, no current named entry/render/channel path identified; refine existing Recall correction, not Fallback alias. |
| CenterHUD_AbilitiesPipBars.ini | 16 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| ShadowIslesCenterHUD_BG.ini | 2 | original | Position/layout resources; native activation callbacks are not defined by geometry. |
| ShadowIslesCenterHUD_LevelUPBar.ini | 22 | original | Existing QWER cast/learn states; special rank/pips/expanded surfaces stay under existing QWER corrections. |
| TargetBar_Frame_Portrait.ini | 5 | original | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| TargetBar_HealthBar.ini | 9 | original | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| TargetBar_PARBar.ini | 9 | original | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| TargetBar_Stats.ini | 12 | original | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| TargetBar_Items.ini | 12 | original | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| TargetBar_Buffs.ini | 40 | restored | Selected public target remains distinct from own diagnostic/menu; original incomplete effect uses preserved restoration. |
| ShadowIslesMinimapRight.ini | 28 | original | Previous AUX/MINIMAP states census covers all28records; native variants/callbacks remain limited as recorded. |
| ShadowIslesChampionLeft.ini | 68 | original | Own HUD values/portrait/inventory/respawn mixed resources; existing per-family consumers retained, not all records rendered. |
| ChampionLeft_Stats.ini | 18 | original | Own HUD values/portrait/inventory/respawn mixed resources; existing per-family consumers retained, not all records rendered. |
| ShadowIslesTitanBar.ini | 26 | original | Gold/time/score counters and mode-specific templates, not a proved live table/input; Dominion inclusion is not Map10 activation. |
| TitanBarDominion.ini | 8 | original | Gold/time/score counters and mode-specific templates, not a proved live table/input; Dominion inclusion is not Map10 activation. |
| ShadowIslesTeamFrames.ini | 51 | original | 51team templates, five authored indices; current exact portrait/frame consumer not identified; public authority and actual roster mapping required. |
| ShadowIslesEvolutionBar.ini | 22 | original | Eight arrow/frame sprites already render four Learn controls; fourteen other records are unqualified, not proof of a separate champion evolution command. |
| MessageBox.ini | 14 | original | Fourteen border/background/text templates; no authored close/choice button in this file and no current named messagebox lifecycle found. |
| LossOfControlUI.ini | 25 | restored | Control-loss display/masks: spell/status source predicates separately audited; generic accepted metadata is not an input callback; restoration preserved. |
| LossOfControlUI_AbilityOverlay.ini | 36 | original | Control-loss display/masks: spell/status source predicates separately audited; generic accepted metadata is not an input callback; restoration preserved. |
| VisionSlot.ini | 10 | original | Vision source family and mode-admission unknowns already audited; not an additional current item slot. |

Le fichier CenterHUD_AbilitiesSpellRecall.ini contient Recall,RecallHighlight,RecallOverlay,RecallHotKey,RecallHotKeyBG1. Le commentaire original «;Recall» précède immédiatement evtUseItem7=[b]. Cette précision complète le lot précédent sans le réécrire:le libellé voulu est maintenant établi dans le document d’entrée;binding effectif,dispatch,association à Fallback et règles Map10 restent inconnus. Le record Recall est Enabled1 mais Alpha0:aucun bouton visible/prêt ne se déduit de ce seul flag. Le sélecteur actuel de sorts couvre six layouts QWER+D/F,aucun Recall.

EvolutionBar contient22records; native_hud_learning sélectionne seulement huit EvolutionArrow/Frame,soit les quatre contrôles Learn déjà recensés. Quatorze autres titres/icônes/overlays/effets restent non qualifiés. Le mot Evolution ne prouve pas une action d’évolution d’un champion ni sa politique native. HUD-QWER-LEARNING-PANEL-01 couvre déjà ce manque.

Les51records équipe comportent cinq indices de portrait,ce qui n’établit ni une équipe de cinq sur Map10 ni une permission de lire les champs privés. Le sélecteur actuel de texte ne sélectionne pas TeamLevel/TeamRespawnTimer,RecallHotKey ou MB_. Dix fiches numériques d’équipe existaient et sont réutilisées. Aucune chaîne actuelle de cadre/portrait d’équipe n’est identifiée dans la recherche bornée et les sélecteurs effectifs.

MessageBox.ini contient14templates de bordure/fond et texte de base/titre;aucun bouton choix/fermer déclaré dans ce fichier. Aucun cycle de vue MessageBox identifié dans les consommateurs actuels. Ne pas imposer une boîte modale à partir de ces seuls rectangles,ni assimiler une notification,le chat ou Continue final à cette vue.

Le récapitulatif local de mort est une reconstruction automatique séparée de la Flash native. Il lit uniquement l’identité propre acceptée session/epoch,mort/deadline et canal recap;winner/result/invalides le retirent. Shop ouvert le masque. Racine et textes utilisent Pickable::IGNORE et FocusPolicy::Pass;aucune entrée bouton/clavier dans son update. Il n’ajoute donc pas de contrôle utilisateur au compteur. Les autres callbacks/hover candidats ne sont pas rendus fonctionnels par cette exclusion.

## R4 — Attendu, observé et vérifications
Exécuté ici:lectures/empreintes et cohérence Python,contrôle32membres/703IDs/extraction de propriétés,deux overlays,fragments exacts et recherche ciblée suivant les noms de ressources nouvellement repérés. Huit tests CPU hérités death_recap_panel sont retrouvés passants dans le journal terminal code0 et reliés aux sources actuelles identiques au manifeste d’exécution. Ils n’ont pas été relancés et ne qualifient pas les vues manquantes. Binaire historique/ressources identifiés dans la preuve;pas de requalification du binaire actuel.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Reconcile the actual configured finite native list | All32 normal-profile members indexed in original order;703 source-qualified lexical record IDs, two existing overlays retained. | 703 not703actions or global native HUD denominator; structural parser not rerun. |
| C2 | Preserve original vs reconstructed provenance | Original member SHA/size verified; TargetBar_Buffs and LossOfControl overlays retain distinct hashes. | Original native full-loop accepted677 vs selected703 is inherited, not reexecuted nor proof of live bindings. |
| C3 | Resolve the new source intent without an invented callback | Separate five-record Recall layout and immediately preceding ;Recall comment identify authored recall intent for B/evtUseItem7. | Dispatch/effective binding, Fallback alias and mode-specific channel/arrival/interruption remain unqualified. |
| C4 | Distinguish recall asset metadata from a working button | Recall source Enabled1 but Alpha0, texture RecallIcon; no named Recall widget/current input consumer found. | No visible/ready/refused state can be inferred from Enabled alone. |
| C5 | Avoid duplicate controls from Evolution artwork | Eight arrows/frames selected by exact current function are already four Learn controls;14other records remain unqualified. | No new spell/champion evolution mechanic inferred from resource name or old enabled flags. |
| C6 | Do not infer team size or private fields | 51team records,five authored portrait indices; existing ten level/respawn text corrections reused. | Actual Map10 roster-slot authority/callback/view absent; fiveindices not fiveplayers; public-roster-only values remain limited. |
| C7 | Do not invent messagebox actions | 14base/title geometry/text records; no authored choice/close entry in this file. | Current template lifecycle unknown; notifications and terminal continue not substitutes. |
| C8 | Exclude automatic local view from user-control count | Own death panel uses Pickable::IGNORE/FocusPolicy::Pass, hides when shop open; eight matching historical panel tests preserved. | Local reconstructed recap not native Flash or clickable control; no native GUI/UI acceptance proved. |
| C9 | Retain tooltip/current callback limits | Existing tooltip audit and TIP-POPOVER-LIFETIME-01 reused; map all32 resource families to existing audits or precise remaining surface. | No per-icon popover or click handler manufactured; full native Flash/profile/dynamic callback/current-registration census remains open. |

Aucun test Rust,natif,GUI,clavier physique,jeu ou réseau exécuté. Aucun appel du lecteur produit potentiellement migrateur. Zéro test d’acceptation de Recall/cadres équipe/MessageBox fourni.

## R5 — Limites et reprise
Le recensement source des32fichiers est fini;il ne constitue pas le dénominateur de tous les contrôles du HUD natif. Les menus/movies Flash,callbacks dynamiques,autres profils et enregistrements d’entrée UI actuels doivent encore être réconciliés avec les78IDs courants déjà documentés. Les flags Enabled/AlwaysRespond/Draggable ne fixent pas seuls une sémantique d’action ou un refus.

Pour Recall:callback/dispatch attesté ou contrat local versionné,propriétaire et horloge du mode,puis canal/arrivée/interruption/refus observables;la déclaration commentée résout l’intention source,aucun succès runtime inventé. Pour apprentissage:réutiliser le contrat du panneau étendu et des rangs. Pour équipe et MessageBox:reprendre uniquement avec binding/autorité/callback ou politique locale explicitement versionnée. Pas de nouvelle recherche native générale sans cette piste discriminante.

## R6 — Corrections réutilisées et petits lots restants
Réutiliser HUD-FALLBACK-RECALL-BINDING-01 avec les cinq records Recall et le commentaire source désormais établis;Fallback reste une association ouverte. Réutiliser HUD-QWER-LEARNING-PANEL-01 pour les14records Evolution restants et TIP-POPOVER-LIFETIME-01 pour les vrais futurs hover/ancres. Réutiliser dix fiches HUD-COUNTER-TeamLevel*/TeamRespawnTimer*;ne pas dupliquer leur travail numérique. Sept tâches existantes sont relues avec leurs critères,aucun statut changé.

### HUD-TEAMFRAME-OWNER-01
Qualifier la sélection et la présentation d’un cadre allié avec autorité des champs explicite.

Travail: Choisir un slot réellement lié au roster du mode,nommer les champs autorisés et le consommateur; établir séparément si le portrait porte une action native ou reste affichage. Ne pas transformer cinq indices authored en équipe de cinq joueurs.

Fin: Un allié identifié à session/roster présents affiche uniquement les champs autorisés; absent/départ/reconnexion/vivant/mort et éventuel clic/hover prouvent le contrat choisi; pas de lookup privé d’attaquant/adversaire.

Reprise: Source native de binding/callback par slot ou contrat local explicitement versionné; autorisation produit. Réutiliser les dix tâches numériques et le contrat public existants.

Rattachements: SYS-17.1-08, SYS-17.5-01. Proposition non appliquée.

### HUD-MESSAGEBOX-LIFECYCLE-01
Établir l’usage et le cycle de vie du template MessageBox chargé par le profil normal.

Travail: Identifier le propriétaire/provenance du texte et le déclencheur,puis montrer affichage/masquage/invalidation; établir les actions uniquement si une source ou politique locale les définit. Aucun bouton fermer/choix inventé depuis les bordures.

Fin: Nominal et texte indisponible,propriétaire/session retiré,superposition et fermeture/invalidation ont un résultat observé selon le contrat choisi; si inutilisé sur le profil choisi,exclusion justifiée sans prétendre fonction terminée.

Reprise: Callback/trace du message natif ou politique locale versionnée,ancre et propriétaire explicites; autorisation produit pour toute interface.

Rattachements: SYS-17.2-05, SYS-17.5-01. Proposition non appliquée.

Zéro contrôle actuel ajouté:78IDs restent78. Les703ressources ne sont ni703actions ni703fonctionnalités terminées;aucun pourcentage. Reste: Parent SYS-17.5-01 open: reconcile all registered current UI input routes and native Flash/menu/dynamic surfaces with the accumulated control state audits; normal32-file resources alone are not full native/control coverage. Native callbacks,active/refused state producers,mode/profile selection and physical/render qualification remain limited; documented missing implementation does not prevent this finite source-census subunit closing. Reuse existing Recall/learning/tooltip/team numeric work; new owner/lifecycle corrections only for teamframe and generic MessageBox surface.

## R7 — Livraison et conservation
Nouveaux fichiers seulement:audit-unit.json,verify_native_hud_census.py,native-hud-census-proof.json,verify_delivery.py,delivery-readback.json et ce rapport. Producteur audit_scope_closed=false;relecture séparée exigée pour clore seulement ce recensement fini. parent_documentary_scope_closed=false,fonctionnalité et goal non terminés;acceptation humaine non revendiquée.

Cinq registres,25fichiers protégés,1168sources et état suivi Git vérifiés conservés. Aucune modification du goal,de ses critères,du code du jeu,de Plan/UI/bases;aucune base ouverte,installation,migration,relance ou retrait. Anciennes preuves et overlays intacts.

Preuve: F:\OpenLeague-work\audit-units\AUD-17.5-01-NATIVE-HUD-CENSUS-01\native-hud-census-proof.json. Relecture: F:\OpenLeague-work\audit-units\AUD-17.5-01-NATIVE-HUD-CENSUS-01\delivery-readback.json.
