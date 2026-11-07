# AUD-17.5-01-OPTIONS-GLOBAL-HUD-SCALE-01 — GlobalScale

Date : 2026-10-31T11:21:18.198888+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un slider : OPT-SRC-aab6b853f2cfce82 ligne93, `[Globals]GlobalScale`, scale1, datasource GlobalHudScaleDatasource. Auditer source, conversion, consommateurs et limites ; relecture séparée avant clôture documentaire. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Provenance et preuves réutilisées

Déclaration/factory/export AS identifiés. Contrat slider/live/serializer du lot MinimapScale réutilisé sans répétition d'export ou de tests. en_GB ligne753 : HUD scale. Les quatre candidats Game.cfg fournis ne contiennent aucune ligne Globals/GlobalScale ; chemin F exact absent. Sélection historique/provider/overlay non déduits.

Audit ancien AUD-17.1-01-LAYOUT-01 relu par identité, avec contrats natifs layout, bounds, owner et viewport. Leurs fixtures emploient des états fournis et n'établissent pas ce réglage ou un changement courant. PE4.20 et outils statiques existants épinglés ; aucun logiciel installé.

## R3 — Contrat et consommateurs

**AS réutilisé.** scale1/100 donne0.01 : affichage0..100 et valeur normalisée sont distincts du facteur brut propriétaire. Datasource supprime la lecture d'init du modèle, puis la vue demande le callback à l'activation. Numeric0 et chaîne0 diffèrent par les tests de vérité ; uint/arrondi, live, journal/save/cancel et stratégie regular conditionnelle conservent les limites du lot précédent. Les données FlashPlayer debug defaultValue0.3/value0.6 sont séparées des propriétés du helper natif, dont defaultValue=1. Définition/timeline, snapping et événements physiques restent non observés.

**Natif statique.**82FDAA associe le nom à8303D0. Ce callback lit le facteur brut de [contexte+0x94], le divise par le maximum renvoyé par7F8F50, puis appelle le helper objet830230 déjà audité. Il ne copie pas la formule de MinimapScale.

Le corps complet7F8F50 lit les deux dimensions Game20328/2032C et possède trois sorties : maximum float32 environ0.84,1.03 ou1.15 selon le rapport largeur/hauteur. Les seuils épinglés sont1.2510000467300415 et1.3343333005905151. La première comparaison conserve un ratio en précision x87, la seconde utilise son stockage float32 ; aucune équivalence de frontière sur un autre mode FP n'est déclarée. Le helper ne montre pas de garde pour zéro/dimensions invalides ; le contexte et son producteur effectif restent à qualifier.

7F8566 associe [Globals]GlobalScale au subscriber7F9120. Pour les entrées finies, il sélectionne au moins float32(0.01), multiplie par le maximum courant et stocke ce facteur brut. La portion ne borne pas en haut avant les effets suivants. Une autre routine, préfixe7F8FD0, peut plafonner le facteur au maximum lors d'une réapplication ; sa présence ne prouve pas l'ordre complet du bootstrap/resize. Le callback met à jour deux propriétaires+0x18, un propriétaire+8, un flag dirty global et le facteur caché+0x28, puis appelle éventuellement825E90. C'est une propagation de source, sans fenêtre ou framebuffer exécuté.

Le lecteur reçoit un fallback brut1 pour Globals/GlobalScale. Le helper de sauvegarde borne un brut non positif à float32 environ0.001, formate le brut avec `%.4f` et choisit une clé selon le mode. La branche GlobalScale et sa demande8B2B10 sont conservées ; ni le mode réellement sélectionné ni la durabilité/ack/restart ne sont observés. DefaultValue normalisé1, fallback brut1 et facteur dépendant de l'aspect sont trois rôles distincts.

**Courant.** native_hud_viewport démarre scalar1. Le facteur est transmis au payload/layout et aux bounds ; la formule générique est owner_scalar*0.5+0.5, sauf KeepMaxScale. Les panneaux statiques possèdent déjà une signature contenant les bits du facteur. Toutefois le refresh viewport s'arrête lorsque les dimensions sont inchangées, et le cache de groupe ne se recalcule qu'avec son dirty bit2. Le raccord d'un réglage doit donc mettre à jour les propriétaires et invalider/recalculer les bounds même sans resize. Aucun bug de cache provoqué par ce réglage n'est affirmé : le réglage nommé n'est pas encore raccordé dans les chemins inspectés. Recherche bornée sur1168 fichiers et chemins réels examinés, sans absence globale inférée d'un nom seul.

## R4 — Attendu et observé

Sept cas : déclaration/AS, datasource, aspect/domaines, config/limites, propagation, cache courant et réutilisation. Neuf fenêtres d'instructions et leurs constantes sont épinglées. Douze scénarios finis sont dérivés en Python des instructions ; ce ne sont ni un parseur exécuté, ni une preuve des seuils FP exacts, du bootstrap ou de la géométrie après refresh. Aucun x86/AS/Rust/jeu/GUI/input physique/réseau/loader productif, export ou ancien test relancé. Corpus1168,25 fichiers protégés, cinq registres et Git contrôlés avant/après.

Une consultation préliminaire avait traité un dictionnaire de fragments ancien comme une liste ; ce KeyError n'a pas servi de preuve d'absence. Les champs réels et la livraison ancienne ont été relus.

## R5 — Manques et reprise

- GLOBALSCALE-EFFECTIVE-CONTEXT : producteur dimensions, propriétaire/provider, parseur/FP/erreurs et ordre réel. Reprendre un contexte nommé ou contrat local versionné autorisé ; les noms et producteurs statiques sont maintenant identifiés.
- GLOBALSCALE-CURRENT-BRIDGE : valeur normalisée vers facteur propriétaire dépendant de l'aspect. Reprise produit autorisée ; correction existante HUD-LAYOUT-SCALAR-01.
- GLOBALSCALE-BOUNDS-INVALIDATION : scalar-only dirty/recompute et cohérence géométrie/zones d'entrée à dimensions fixes. Reprise avec corrections scalar/resize existantes et scénario identifié.
- GLOBALSCALE-RUNTIME-CYCLE : UI effective, deux dispositions, aspect/DPI, défaut/annulation/save/reload et provider durable. Reprise sur build/assets/menu/stratégie identifiés ; les fixtures ne suffisent pas.

## R6 — Correction existante et suite

**Aucune nouvelle fiche de correction.** HUD-LAYOUT-SCALAR-01 couvre exactement le raccord du réglage au propriétaire. Sa définition et ses critères antérieurs restent inchangés ; la preuve présente documente le producteur nommé désormais partiellement qualifié et le travail restant. HUD-LAYOUT-RESIZE-LIFECYCLE-01, HUD-LAYOUT-ASPECT-RANGE-01 et HUD-OPTIONS-ENTRY-01 sont également réutilisées, sans application ni changement de registre. Ne pas transférer ce facteur dans le contrôleur propre à la minicarte ou ignorer KeepMaxScale.

Prochain réglage : ChatScale ligne94, savecfg/scale100 et attribut authored updateonfirsclick. Vérifier sa lecture réelle avant de parler de faute de frappe ou d'absence ; réutiliser les contrats communs.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-GLOBAL-HUD-SCALE-01\global-hud-scale-proof.json`, SHA256 `93ae9a80cb0f1bc095fbf805e3b7557a0bfe66d84b9ba54306e710065529a866`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-GLOBAL-HUD-SCALE-01\verify_global_hud_scale.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-GLOBAL-HUD-SCALE-01\audit-unit.json`. Relecture séparée dans delivery-readback.json et INDEPENDENT-REVIEW.md ; le producteur seul ne clôt pas le lot.

Nouveaux documents isolés uniquement. Goal, critères, registres, produit, assets, application de suivi, interface, bases et preuves antérieures conservés. Aucune installation/migration/reprise d'application ni clôture fonctionnelle ou globale.
