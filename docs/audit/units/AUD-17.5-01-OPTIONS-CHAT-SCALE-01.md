# AUD-17.5-01-OPTIONS-CHAT-SCALE-01 — ChatScale

Date : 2026-10-31T11:37:48.270946+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un slider ligne94, OPT-SRC-ab8c0b9de9df3c27 : HUD/ChatScale, scale100, stratégie savecfg, updateonfirsclick=true. Fin : reconnaître l'attribut, relier init/live/save et consommateur natif/courant, borner les manques et relire. Audit documentaire uniquement ; fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et preuves réutilisées

Index/factory et export AS3 existants vérifiés. Contrats slider/serializer et Save réutilisés ; aucun export ou test ancien relancé. Défauts original et copie identiques : ChatScale=100.0 ligne86 ; candidat utilisateur fourni100 ligne39 ; override deploy sans clé ; chemin F exact absent. Sélection historique/provider non observés. en_GB ligne735 : Chat scale.

Audit chat/score d'absence et son reçu relus : même corpus1168 et mêmes registres, témoins courants aux mêmes hashes. Exports AS2 HudChat menu et Menu_SC4 existants épinglés et variantes conservées, sans nouveau scan d'archives. PE4.20 et outils statiques identifiés ; aucun logiciel installé.

## R3 — Contrat et consommateurs réels

**L'attribut est reconnu.** DataAttrib.SLIDERUPDATEONFIRSTCLICK vaut exactement updateonfirsclick. ViewSlider teste sa présence contre ATTRIB_ERROR et active sendEventOnFirstClick ; pas de correction orthographique à appliquer. Une valeur textuelle false présente suivrait encore ce test de présence ; la déclaration fournie est true. Une absence laisse le flag de classe false. L'état effectif du sprite/timeline reste non exécuté.

scale100/100 donne appliedScale1. Le domaine du réglage est donc le pourcentage0..100, distinct des valeurs normalisées des deux autres sliders de taille. Aucun datasource n'est déclaré. ModelSlider lit cfg(...,"0") en ingame/GFXplayer ; un retour100 donne modèle/affichage100. Utility retourne directement fallback0 en GFXplayer ; les autres environnements emploient DEBUG_DEFAULT75. Restore a sa lecture de défaut et floor. Le fichier physique100 et le preview0 ne sont pas une contradiction ou une preuve de bug.

Le premier beginDrag peut émettre un live event grâce au flag. endDrag et trackPress en émettent aussi après le super appel. Le live custom pendant chaque mouvement est un flag distinct, false par défaut. liveDragging, snapping, disabled et clavier du composant sont des propriétés distinctes : ordre réel VALUE_CHANGE/journal/live non qualifié par les seules déclarations. LiveUpdateSlider.value effectue lock/draw sans l'événement du setter de base ; receiveModelChange du ViewSlider change l'affichage sans setLiveValue. Ne pas lui transférer la sémantique live-on-sync du checkbox.

Le journal normal est explicitement savecfg ; l'événement live emploie live Update. La source Save générique et son ordre config/notification restent hérités. Application/annulation effective, fichier sélectionné, acquittement et durabilité propres à ChatScale ne sont pas prouvés.

**Natif statique.**7F83AF passe100.0 au lecteur8B20F0 pour HUD/ChatScale et stocke le champ+8. L'association [HUD]ChatScale pointe vers7F9240. Ce callback demande d'abord Chat_Box_Open avec1 via7939B0 sur le propriétaire+0x110, puis appelle le parseurC9BB65, stocke la valeur et transmet le même float aux deux axes via7ABCC0. Aucun clamp numérique fini/range n'apparaît dans ce corps ; la comparaison de taille de chaîne n'en est pas un. Contexte, parseur/locale, erreurs et invalides restent ouverts.

7ABCC0 formate chaque argument avec %f dans un buffer32 et demande SetChatScaleX/Y. Les deux variantes AS2 passent vers hud.chatScaleX/Y ; les méthodes Hud affectent `ceil(parseInt(value)*0.5+50)` à scaleX/Y du chat. L'héritage est vérifié : menu ChatBox → DisplayObjectContainer ; SC4 ChatBox → ChatBoxGraphicBase → DisplayObjectContainer ; puis DisplayObject. Les setters hérités placent l'échelle dans une file de redraw. Pour les entiers déclarés0,1,50,100, l'algèbre donne50,51,75,100 pour cent. Ce n'est ni l'exécution du formatteur/parseInt ni une mesure de pixels. Décimales, bornes hors UI, NaN/inf et horloge de redraw ne sont pas qualifiés.

La demande Chat_Box_Open d'aperçu ne signifie pas Text_Entry_Open, focus de saisie ou capture clavier. Le contrat de focus et l'absence actuelle de chat jouable restent ceux des tâches existantes.

**Courant.** Les chemins effectifs préservés chargent Chat.ini et en journalisent les octets ; les catalogues fermés Input/Action et la garde d'entrée inspectée ne fournissent pas un frontend de chat. Le chargeur Game.cfg et les autres widgets de texte ne sont pas ce consommateur. L'ancienne absence est réutilisée sur un corpus complet inchangé ; quatre recherches nouvelles de clés/API confirment le raccord nommé absent dans ce périmètre, sans conclusion globale fondée uniquement sur un nom.

## R4 — Attendu et observé

Sept cas : attribut, défaut/domaine, événements, deux axes natifs, conversion AS2, absence courante réutilisée, save/limites. Quatre fenêtres natives et23 instructions attendues sont identifiées ; sources AS3/AS2, héritage et copies vérifiés. Algèbre de quatre entiers seulement, pas de programme original exécuté. Aucun AS, x86, Rust, jeu, GUI, input physique, réseau, loader productif, export ou ancien lecteur/test relancé. Corpus1168,25 fichiers protégés, cinq registres et Git contrôlés avant/après.

## R5 — Manques et reprise

- CHATSCALE-NATIVE-CONTEXT : propriétaire/provider/movie/namespace effectifs, parser/format/dispatch/erreurs et horloge de redraw. Reprendre un contexte identifié ou politique locale autorisée ; les noms et chemins statiques sont déjà établis.
- CHATSCALE-CURRENT-CHAT-CONSUMER : chat jouable/propriétaire et raccord d'échelle. Réutiliser SYS-17.2-08 et SYS-17.4-08 ; reprise produit autorisée avec consommateur réel, sans substituer un autre widget.
- CHATSCALE-EVENT-FOCUS : premier clic/drag/track/journal, flags SWC/disabled/clavier, aperçu et propriétaire focus/session. Reprise sur build/assets/scénario identifié et comparaison des conflits d'entrée.
- CHATSCALE-PERSISTENCE : apply/cancel/default/save/reload, provider durable et acquittement. Reprise sur cycle propre au réglage, distinct du journal ou de la demande live.

## R6 — Correction et suite

HUD-OPTIONS-ENTRY-01 et tâches de chat existantes sont conservées. Une proposition documentaire distincte : HUD-CHAT-SCALE-SETTING-01, uniquement le raccord d'échelle et son cycle, dépendant du chat jouable SYS-17.2-08 et du focus SYS-17.4-08. Elle ne recrée pas une seconde tâche d'implémentation complète du chat ni le facteur HUD global. Critères, refus et reprise figurent dans la preuve ; aucune application ou modification d'un registre normatif.

Les trois sliders du groupe taille ont maintenant un audit individuel. Prochain lot : consolidation bornée de leurs déclarations exactes, domaines/stratégies distincts, preuves et manques ; aucune nouvelle recherche native ni conversion en pourcentage de jeu.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CHAT-SCALE-01\chat-scale-proof.json`, SHA256 `c0a33e6b994e8daebb4d24633d4ef881b762b079e3908cd8930f1e77fb7b254e`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CHAT-SCALE-01\verify_chat_scale.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CHAT-SCALE-01\audit-unit.json`. Relecture séparée attendue : delivery-readback.json et INDEPENDENT-REVIEW.md ; le producteur seul ne clôt pas le lot.

Nouveaux documents isolés uniquement. Goal, critères, registres, produit, assets, application de suivi, interface, bases, historiques et anciennes preuves inchangés. Aucune installation, migration, application redémarrée ou clôture globale/fonctionnelle.
