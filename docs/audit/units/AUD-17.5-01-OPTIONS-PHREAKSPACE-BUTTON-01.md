# AUD-17.5-01-OPTIONS-PHREAKSPACE-BUTTON-01

Date UTC : 2026-11-01T08:50:06.919503+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Portée et statuts

Une source : OPT-SRC-fc17d39151a0b9ac,ligne12,button label="Get myself on my own level",slot7 du groupe header. Aucun effet de niveau ou de gameplay établi. Audit documentaire prêt pour relecture distincte ; implémentation précise partielle/non qualifiée,vérification documentaire,acceptation humaine non demandée. Parent et goal ouverts.

## 2. Sources et identités

XML4.20,index physique,fabriques,PE/GFX et exports AS identifiés. Attribut label seul : aucune action,clé de préférence ou stratégie propre. Quatorze fenêtres nouvelles bornées couvrent modèle/vue/template,événement,parent,son et pression souris ; contrats communs de valeur et input conservés. Aucun export ou désassemblage nouveau.

mcGenericButton porte le sélecteur d’export symbol312 et son enfant FoundryButtonDetailed symbol56. Ce sont des sélecteurs d’export,pas des IDs natifs ou pixels prouvés. Le template affecte notamment autoRepeatfalse,autoSizeleft,enabledtrue,focusablefalse,label Restore Defaults,togglefalse. La vue remplace ce label par la chaîne du modèle,puis validateNow : une légende de template ne définit pas une action Defaults.

## 3. Consumers et contrat

ModelButton dérive d’InteractiveModelComponent et n’override pas init : un objet de valeur hérité est construit,avec sa sentinelle chaîne null avant sync externe. Il n’est pas initialisé artificiellement comme les checkbox0 ou le slider75. Le handler PRESS n’appelle directement ni setValue ni setLiveValue ni sérialisation numérique. Ce constat local ne qualifie pas toute synchronisation ou effet externe.

ViewButton écoute ButtonEvent.PRESS (buttonPress),affecte le label directement et lit ACTION,qui vaut la clé action. Si getAttrib(ACTION) renvoie ATTRIB_ERROR (chaîne null),le bloc de payload n’est pas exécuté dans le profil historique sans action. Si une action est fournie,un Dictionary onEventName est transmis dans PayloadEvent ViewApplicationEvent,bubbling et cancelable. ViewApplication lit ce nom puis processMessage ; sa base transmet aux vues enfants. Ce n’est pas un appel direct à GameSerializer.Update et aucune action n’est déduite du label.

playSoundOnChange est placé après la garde d’action ; le défaut de modèle est Options_Click2 et la base demande GameAudio.playSound uniquement dans les contextes source INGAME/GFXPLAYER. Une demande conditionnelle n’est pas une preuve de son audible. Le vendor MousePress filtre les boutons non primaires,met à jour son bit de souris puis conditionne PRESS à enabled. Le handler ViewButton n’a pas sa propre garde enabled : les autres entrées,focus et pressions programmatiques restent non observés.

Les18contrôles construits partagent un profil de paramètres d’identité manquants sous ces descripteurs,mais les pressions de ce bouton ne sont pas assimilées aux17chemins d’édition numérique. Les9fenêtres courantes réutilisées sont revérifiées. Une seule recherche nouvelle des alias ModelButton/ViewButton dans les1168sources inchangées renvoie zéro occurrence ; aucune absence globale d’infrastructure de bouton/message n’est déduite.

## 4. Attendu et observé

- Source label seul — attendu : Conserver identité,label,parent et absence d’action ; aucune commande dérivée. Observé : Ligne12/slot7,attribut label seul et chaîne exacte vérifiés ; provider effectif non qualifié.
- Pression et événement — attendu : Tracer PRESS,garde action et chemin parent conditionnel,sans confondre Update ou click. Observé : Source sans action : pas de payload applicatif de ce handler ; demande de son après garde selon contexte. Aucun press,son ou dispatch réel exécuté.
- Modèle,template et input — attendu : Distinguer valeur héritée,sentinelle,caption de template et gardes de chemin. Observé : InteractiveModel hérité sans setValue direct au press ; template Restore Defaults écrasé,MousePress primaire/enabled borné ; pas de garantie globale d’input ou de rendu.
- Consumers et suite — attendu : Nouvelle recherche limitée aux deux alias et réemploi des preuves communes ; préparer la réconciliation distincte. Observé : 1168sources inchangées,zéro alias ;9fenêtres réutilisées. Les36rôles candidats seront réconciliés dans le lot suivant,aucun menu ou jeu déclaré terminé.

Contrôles réels : XML/octet/attributs/parenté,sources nouvelles et refs héritées,lookup borné d’une classe,requête actuelle2alias,18profils de construction,consumers,corpus/Git/25fichiers protégés/5registres avant/après. Producteur et lecteur documentaire distincts avec sorties et codes actuels. Aucun jeu/AS/Rust/GUI/réseau,émulation,press,son,rendu ou test produit exécuté.

## 5. Écarts et reprise

- BUTTON-ACTION-PAYLOAD — Le fichier ne déclare pas d’action et le handler source ne produit pas de payload applicatif dans ce profil. Payload effectif,action injectée et destinataire local éventuels restent non qualifiés ; le label ne fournit pas de commande. Reprise : Payload/provider et chaîne action/destinataire processMessage précisément liés,ou contrat local versionné de profil sans action ; ne pas inventer niveau ou Defaults à partir du texte.
- BUTTON-INPUT-RENDER — Pressions,zone/caption,focus/disabled,état down,son et ressources/timeline ne sont pas observés. La garde MousePress n’est pas une garantie pour les autres entrées et le handler de vue n’a pas sa propre garde enabled. Reprise : Menu/renderer/viewport/assets et correction autorisés ; souris primaire/non primaire,clavier/focus,désactivation,dispatch direct et ressource absente avec attendu/observé distincts.
- BUTTON-CURRENT-CONSUMER — Les deux alias nouveaux ne sont pas trouvés dans le corpus courant ; une infrastructure générique de bouton/message peut exister mais son raccord précis reste non qualifié. Les profils numériques ne prouvent pas un journal de pressions de ce bouton. Reprise : Consumer et routage courant précis,avec modèle/journal/vue/backend séparés et source unique conservée ; ne pas relancer cette requête sans nouvelle piste.

Précision INPUT-LABEL-RELEASE-BRIDGE-01 : le relais de label des checkbox passe par MouseEvent.CLICK enregistré dans Button.configUI vers handleMouseRelease,qui applique enabled/primary et conditionne ensuite buttonClick à isRepeating. La livraison au handler est donc conditionnelle. La phrase antérieure affirmant que les clics aboutissent au handler et la consigne générale de ne pas reprendre les gardes release pour le label étaient trop larges. Le raccord précis et ses gardes sont maintenant sourcés ; cela ne valide pas tous les dispatchs programmatiques ou les résultats d’input réels. Ancien rapport,définition et critères restent intacts et identifiés dans la preuve.

Tous les gaps antérieurs de modèle,provider,includes,identité et rendu restent conservés par références ; aucune clôture de parcours n’est déduite des36rôles.

## 6. Correction distincte

HUD-OPTIONS-GENERIC-BUTTON-01 est proposée,non appliquée,pour ce bouton : PRESS,label,garde d’action,routage local et résultats séparés. ENTRY et cycles communs sont conservés ; les critères des objets numériques ne sont pas transférés ou remplacés.

- La source unique est reliée au bon consumer,aux actifs et au texte exact ; press,état visuel et demande/lecture du son ont attendu/observé séparés.
- Action absente respecte le contrat de garde sans action fabriquée ; action fournie/invalide/inconnue n’est annoncée prise en charge qu’avec destinataire et résultat précis,ou refus local versionné explicite.
- Souris primaire/non primaire,désactivation,focus/clavier,dispatch programmatique et ressource absente ont résultats observés ; les gardes du seul chemin MousePress ne sont pas généralisées à toutes les entrées.
- Modèle,journal,view-message et backend sont distingués ; aucun niveau,Defaults ou effet évoqué par le label n’est déclaré implémenté depuis une légende de bouton.

Reprise : Correction produit autorisée séparément,menu/provider/renderer/assets identifiés ; pour une action réelle,apporter la chaîne et le destinataire processMessage liés à ce descripteur,ou garder explicitement le profil sans action.

## 7. Preuves et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-PHREAKSPACE-BUTTON-01. Preuve phreak-button-proof.json,scripts audit_phreak_button.py/verify_delivery.py,reçus producer-execution.json/reader-execution.json,relecture delivery-readback.json. Le producteur ne s’auto-clôture pas ; le lecteur examine les sept rubriques et clôture seulement ce rôle documentaire.

35rôles Phreakspace antérieurs +1bouton =36rôles candidats. La réconciliation exacte des propriétaires et de leurs gaps est un lot distinct : AUD-17.5-01-OPTIONS-PHREAKSPACE-RECONCILIATION-01. Aucune fonctionnalité complète,menu ou jeu terminé n’est déclaré.

Goal,critères normatifs,Plan,UI,bases,registres,ressources et modifications antérieures inchangés. Aucune installation,migration,relance,restauration ou suppression.
