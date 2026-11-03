# AUD-17.5-01-AUX-ENTRIES-01

UTC : 2026-10-31T04:03:34.372178+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 ; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et fin du lot
Comparer les entrées natives Options/Champion Info/Fallback aux consommateurs actuels et établir un recensement fini du panneau droit. Fin documentaire:28ressources classées sans doublon, deux commandes locales décrites, manques et conditions de reprise rattachés aux sources. Aucune implémentation produit ni acceptation fonctionnelle dans ce lot; parent SYS-17.5-01 et goal restent ouverts.

## R2 — Sources réutilisées et nouvelle piste
Référence4.20.0.315 EUW/en_GB, build2014-11-17 17:46:45; fuseau et déploiement inconnus. PE, layout original ShadowIslesMinimapRight.ini8367octets, copies HUD.zip, Input.ini et fontconfig_en_GB sont identifiés par taille/SHA dans la preuve. Comparaison loose/ZIP exacte. Trois audits target/minimap/camera et le précédent chat-score sont relus, pas réexécutés. La recherche ciblée suit les noms exacts de ces boutons et événements nouvellement examinés; pas de nouvelle collecte web ni de répétition générale sans piste.

| Famille | Ressources | Conclusion |
|---|---:|---|
| fallback | 4 | Native visual family present; callback/meaning/Recall association unresolved; no exact current consumer found. |
| minimap | 3 | Three resource records supply already-audited camera pan/move; not three additional controls. |
| ping | 4 | Native family present, no implemented ping entry path in prior audit; states/callback still open. |
| camera | 6 | Six appearances share already-audited single camera lock control. |
| camera_highlight | 1 | Effect metadata; activation/suppression still open, not another input control. |
| champion_info | 3 | Native visual family and own-champion tooltip/declaration; no current menu entry/close/focus/field producer identified. |
| options | 3 | Native visual family and options tooltip/declarations; existing settings loader not a menu; no current entry/edit/apply/cancel flow identified. |
| score | 3 | Native visual family; prior chat-score audit leaves live scoreboard open; terminal table/debug KDA separate. |
| tooltip_template | 1 | Non-input visual template: no independent action inferred from an authored rectangle. |

Dix apparences nouvellement comparées:Fallback/Hover/Clicked/Overlay,ChampionIcon_Off/On/Pressed,OptionsIcon_Off/On/Pressed. Base Enabled1 et alternatives0 sont des valeurs authored; AlwaysRespond/Draggable/UV/Rect/couleurs et variantes conservés dans la preuve. Le survol ou refus effectif ne se déduit pas de ces noms/flags.28ressources de ce panneau ne sont pas28contrôles.

| Déclaration native | Section | Valeur |
|---|---|---|
| evtUseItem7 | GameEvents | [b] |
| evtShowCharacterMenu | GameEvents | [c] |
| evtSysMenu | GameEvents | [Esc] |
| evtSysMenuAlt | GameEvents | [Backslash] |
| evtShowCharacterMenuSpectator | GameEvents | [c] |

Les textes en_GB explicitent Options et une fiche du champion local. Quatre textes de rappel existent:normal,désactivé,Dominion,Showdown. Ils ne relient pas Fallback à un callback:aucune association prouvée. evtUseItem7/B reste son nom source, distinct du slot vision; aucun renommage en rappel par intuition. Les durées décrites8/4.5/6secondes ne qualifient pas les règles Map10.

## R3 — Consommateurs réels et états
Les sélecteurs actuels chargent trois cadres statiques,trois sources minimap et six apparences caméra; ils ne dessinent pas automatiquement tout record structurel accepté. Aucun consommateur exact des noms OptionsIcon/ChampionIcon/Fallback ou de leurs événements n’est identifié dans le corpus1168inchangé. Ce résultat lexical est complété par les enregistrements systèmes, le catalogue Action et les sélecteurs effectifs; il ne prouve pas l’inexistence absolue d’un callback renommé ou d’un mécanisme externe.

Game.cfg possède déjà un vrai lecteur native_user_settings::load_using et EnvironmentQuality est consommé au démarrage. Ces acquis sont conservés; ce lecteur peut avoir des effets de migration, il n’a donc pas été appelé. Les anciennes notes disant user-options non liées ne remplacent pas le code actuel. Un lecteur de configuration ne constitue pas un menu ouvrir/éditer/appliquer/annuler.

| Contrôle local | Entrée et état actif | Désactivé / refus / limites |
|---|---|---|
| LOCAL-PLAYER-DEBUG | F3 : Local bool toggled first; ready+snapshot+own player+no winner selects Flex/None | winner hides; no ready connection shows session_status independently of toggle ; No refusal output; no explicit local focus/window/shop guard; absent snapshot/player leaves existing text/display unchanged |
| LOCAL-WINDOW-MODE | F11 : For each Window: Windowed→BorderlessFullscreen(Current), any other mode→Windowed | No explicit session/winner/shop/focus gate in function; empty Window query makes no change ; No refusal/rollback path; no settings persistence write in this function |

F3 ne lit que connection.id, pas une cible sélectionnée. Le booléen change avant le garde ready; hors connexion le statut apparaît indépendamment du booléen. À la victoire le texte est vidé/masqué; sans snapshot ou sans joueur aucune réinitialisation n’est explicite dans cette fonction. C’est une observation de branche, pas une fuite GUI reproduite. Aucun refus explicite n’est présenté par ce toggle.

F11 est enregistré dans la chaîne Update ordinaire, même si le fichier render_probe contient également une capture opt-in. Il parcourt toutes les Window:Windowed vers BorderlessFullscreen(Current),tout autre mode vers Windowed. Aucune écriture de préférence n’est visible dans ce chemin, ni garde session/focus/shop dans la fonction. L’option screenshot est distincte. Les deux contrôles locaux ne sont ni Champion Info ni menu Options natifs; F3 entre aussi en conflit avec la déclaration native de sélection Ally2 documentée auparavant.

## R4 — Vérifications et preuves
Exécuté maintenant:Python de lecture/empreintes,partition des28noms,égalité ZIP/loose,extraction des cinq déclarations et six textes,fragments de code exacts,identité du corpus et conservation. Quatre tests hérités settings/panels sont retrouvés passants dans le journal terminal code0 et leurs sources restent identiques au manifeste de cette exécution. Aucun test Rust/natif/GUI relancé,aucun clavier physique,binaire,jeu ni fenêtre exécuté. Zéro test d’acceptation des interfaces manquantes et de F3/F11. Binaire de test historique identifié dans la preuve; existence/identité actuelle du binaire non requalifiée.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Recenser exhaustivement ce panneau fini | 28 noms uniques répartis une fois dans neuf familles; dix apparences options/champion/Fallback vérifiées; loose et ZIP identiques. | 28 ressources ne sont ni 28 commandes ni tous les panneaux du HUD. |
| C2 | Ne pas confondre source visuelle et état actif/désactivé | Une base Enabled=1 par famille, survol/pression/overlay à0; Rect/UV/flags conservés. | Aucun callback natif ni règle d’activation/interruption établie par Enabled/AlwaysRespond. |
| C3 | Distinguer les déclarations natives | C, Esc, Backslash et B sont présents avec noms et sections; variante spectator séparée. | Pas de preuve de keymap effective; evtUseItem7 pas automatiquement rappel ou vision. |
| C4 | Ne pas substituer diagnostic à une fiche | PlayerLabel ne cherche que connection.id; F3 enregistré dans Update, aucune sélection de cible. | Aucune entrée native Champion Info ou cycle de focus/close qualifié. |
| C5 | Décrire les branches du diagnostic | F3 toggle avant ready; hors ready affiche statut; winner masque; sans snapshot ou joueur pas de rafraîchissement explicite. | Observation du code, pas reproduction d’une fuite/stale UI physique ni politique native avérée. |
| C6 | Conserver les réglages existants et distinguer F11 | Game.cfg chargé et EnvironmentQuality consommé; F11 ordinaire agit sur Windowed/autre, capture screenshot opt-in séparée. | Pas de menu options ni persistance/apply/cancel prouvés par ces acquis. |
| C7 | Ne pas inventer le rappel depuis la locale | Six textes en_GB incluent Options/Champion Info et rappel normal/désactivé/Dominion/Showdown; aucun callback Fallback trouvé. | Texte8/4.5/6secondes ne qualifie pas Map10 ni les règles effectives; animation Recall seule insuffisante. |
| C8 | Réutiliser les preuves sans élargir leur succès | Quatre tests hérités settings/panels passent dans le journal code0, sources identiques; zéro test F3/F11/options/champion/rappel ajouté ou relancé. | Aucun test GUI ni binaire lancé; métadonnées binaires historiques identifiées, pas qualification binaire courante. |

## R5 — Manques et conditions de reprise
Restent ouverts:callbacks natifs d’entrée,cycle focus/close et états interactifs des menus,contenu autorisé de la fiche locale,association Fallback/rappel et politique précise du mode,qualification physique des deux toggles locaux. Les données de spawn/soin et un clip Recall ne prouvent pas un canal de rappel implémenté. Le catalogue Action actuel n’a pas de variante Recall nommée; aucune commande B de rappel n’a été identifiée dans les consommateurs audités.

Aucune recherche large supplémentaire sans callback/dispatch/provider/trace discriminante. Une politique locale versionnée peut constituer l’entrée de reprise si la source native reste introuvable; elle ne devient pas une valeur4.20 avérée. Les corrections produit restent soumises au périmètre autorisé,et ne sont pas réalisées dans cet audit.

## R6 — Travail clôturable proposé, sans registre modifié

### HUD-OPTIONS-ENTRY-01
Relier une entrée options réelle à un cycle ouvrir/modifier/appliquer/annuler/fermer.

Travail: Conserver les lecteurs Game.cfg et consommateurs existants; nommer le contrat natif ou la politique locale, capture de focus et propriétaire fenêtre/session; pas de chargement avec migration pendant cet audit.

Fin précise: Un parcours UI réel et identifié prouve nominal, annulation, refus/invalide, focus/session; écritures voulues et persistance vérifiées séparément. F11 ne tient pas lieu de menu.

Reprise: Correction produit autorisée + contrat/callback d’entrée natif identifié ou reconstruction explicitement versionnée; consommateurs de réglages présents.

Rattachements existants: SYS-17.5-01, SYS-22.2-07. Statut proposé, non appliqué.

### HUD-CHAMPION-INFO-ENTRY-01
Relier Champion Info à une fiche du champion local distincte du diagnostic et de la cible publique.

Travail: Identifier l’autorité et les champs de la fiche, entrée C/bouton et fermeture sans réutiliser le picker ennemi comme preuve; préciser les états disponibles/refusés.

Fin précise: Réel ouvrir/fermer/reouvrir/focus/session et valeurs liées au champion local qualifiés, aucun acteur privé divulgué; TARGET-01-SELECTION reste un chantier distinct.

Reprise: Source callback/fiche native ou politique locale versionnée + correction produit autorisée.

Rattachements existants: SYS-17.5-01, SYS-17.1-07. Statut proposé, non appliqué.

### HUD-FALLBACK-RECALL-BINDING-01
Établir le contrat du bouton Fallback et, si prouvé, son lien au rappel du mode Map10.

Travail: Relier explicitement le nom du widget, son callback et son événement/commande; qualifier evtUseItem7/B sans le renommer par intuition; distinguer canal, durée, annulation et refus par mode.

Fin précise: Association attestée ou dissociation documentée; si rappel, trajet entrée→host→canal→arrivée/interruption avec horloge et refus du mode choisi; tooltip et animation seules insuffisantes.

Reprise: Nouvelle piste discriminante: callback/dispatch native ou politique locale versionnée. Aucun rescan général sans cette entrée; ne pas imposer 8 secondes à Map10 à partir de la seule locale.

Rattachements existants: SYS-17.5-01, SYS-04.7-07, SYS-11.3-03. Statut proposé, non appliqué.

### HUD-LOCAL-AUX-CONTEXT-01
Qualifier les contextes et transitions des deux commandes locales F3/F11.

Travail: Définir les gardes voulues de focus, capture et session; choisir explicitement le comportement du diagnostic si snapshot/joueur disparaît. Réutiliser éditeur de bindings/conflits existant; F3 entre en conflit avec la déclaration native Ally2.

Fin précise: Entrée réelle nominale, changement de session/focus, overlay, snapshot absent et fermeture vérifiés sans texte obsolète selon le contrat choisi; fenêtre Windowed/Borderless/autre sans faux succès de persistance.

Reprise: Autorisation produit et politique de contexte définie; sources et branchements disponibles, pas de recherche native large nécessaire.

Rattachements existants: SYS-17.5-01, SYS-22.3-03. Statut proposé, non appliqué.

Réutilisation sans duplication:TARGET-01-SELECTION vise la cible publique et reste distinct de Champion Info; BIND-LOAD-01,BIND-EDIT-CONFLICTS-01 et SELF-FOCUS-CONFLICT-01 restent conservés. Les sept tâches liées sont relues avec leurs critères réels dans la preuve; SYS-12.4-07 concerne le rappel/soin/retour en voie de son propre périmètre, pas un substitut au contrat général Map10.

Les76IDs précédemment recensés deviennent78 par LOCAL-PLAYER-DEBUG et LOCAL-WINDOW-MODE, tous deux déjà présents dans le code. Aucun nouveau contrôle produit n’a été créé. Dénominateur HUD complet inconnu, aucun pourcentage ni clôture du parent. SYS-17.5-01 reste ouvert: établir le recensement de tous les autres panneaux/commandes HUD et réconcilier leurs états; 28 ressources du panneau droit ne fixent pas le dénominateur global. Options et fiche du champion local absentes comme parcours UI; Fallback/rappel/callback et règles Map10 non résolus; quatre corrections proposées, aucune appliquée. F3/F11 identifiés comme contrôles locaux, contexte et qualification UI encore ouverts; ne pas clore les autres exigences de résolution/focus/lisibilité depuis ce sous-lot.

## R7 — Livraison, conservation et décision
Nouveaux fichiers uniquement:audit-unit.json,verify_aux_entries.py,aux-entries-proof.json,verify_delivery.py,delivery-readback.json et ce rapport. Producteur audit_scope_closed=false; la relecture séparée des sept rubriques peut clore uniquement le sous-lot. parent_documentary_scope_closed=false,fonctionnalité non terminée,acceptation humaine non revendiquée,goal inchangé et ouvert.

Cinq registres normatifs,25fichiers protégés (19logiciels gelés +6documents),1168sources et état suivi Git conservés. Aucun goal/critère/Plan/UI/base modifié ni base ouverte;aucune installation,migration,relance,retrait de modifications ou écrasement de preuve. Le lecteur de configuration produit n’a pas été appelé.

Preuve: F:\OpenLeague-work\audit-units\AUD-17.5-01-AUX-ENTRIES-01\aux-entries-proof.json. Relecture: F:\OpenLeague-work\audit-units\AUD-17.5-01-AUX-ENTRIES-01\delivery-readback.json.
