# Malphite — liaison du Bouclier de granit et de sa présentation

## 1. Exigence et portée

2026-11-05, V1372. `AUD-SYS-01.2-02-MALPHITE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Malphite-PASSIF-PRESENTATION-VFX` ; `OLF-e93b30b0-4231-5eac-8aff-1ca557b207eb`. Audit de liaison entre déclarations, consommateurs actuels et écarts. Seul ce périmètre est terminé ; tâche VFX complète ouverte.

Implémentation : API générique présente, producteur naturel de Malphite non établi dans les corps examinés. Vérification documentaire réussie, runtime hérité. Acceptation humaine non demandée. Prérequis, contrats et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Deux reçus conservés sous `F:/OpenLeague/docs/reference_requirement_trace_sources/` : malphite-passive-granite-shield-links-v598.json, 1285759 octets, SHA `f74841ed9134cce9e0bcd2f707e6f6a36eb04c244d883a7bf4eef2ce228be4c4` ; malphite-passive-shield-links-v548.json, 519892 octets, SHA `10a7106e12be58df8e8c0a71adfd3d7a768352f9496963494f9b784d3cecd6da`. Copies E identifiées ; chemins D inertes. Référence LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct. Les14 identités V548 sont parmi les39 V598, sans conflit de taille/SHA ; pas53 sources distinctes. Audit HUD source127/127 et consommateurs43/43 hérité.

V598 :13 Lua, zéro prototype enfant, quatre initialisations/10affectations ; CharScript56 vide. Shield221 déclare nom/icône normale/persistence/NonDispellable ; BeenHit202 déclare icône grise et nom « Malphite Shield Cooldown », sans persistence ajoutée. Removal160 déclare AutoBuff vide/persistence/NonDispellable. Neuf limites NEWTABLE : Landslide10, Basic/Basic2/Crit0, Effect8, Obduracy10, Buff12, Q4, R6. Frontières du lecteur, non corruption ou callbacks exécutés.

Tooltips2251/2255/2256/2599 et description4228 distinguent recharge, protection, passif et Q. Texte :10% des PVmax,10s sans être touché ; autre formulation « sans subir de dégâts », @f1@/@f2@ non résolus. Différence de reset ouverte. Passive1=9, texte Jax/mana et niveaux3/7/11/15 restent hérités. Quatre DDF Landslide, dont armor0.3/spelldamage0.2, non formule du bouclier. Onze métadonnées de sorts, six candidats absents bornés,17 références communautaires secondaires.

12 preloads,2539octets/30noms : Shield/BeenHit/Effect/Removal, Obduracy, QWER ; Leona basic-hit dans trois attaques, Malphite_Base_obduracy_off.troy et sort root dans Removal. Liens de ressources, non recette ou priorité native. Captures E787791/1014656/1155573 vérifiées. DDS normale4224/DXT5 et grise2176/DXT1,64×64,mip1,membres25/79, sans lookup/rendu qualifié. Contextes non ouverts, non absence globale. Caveat ressource hérité : SHA5c5ab… communautaire malgré chemin natif, distinct du natif b9a9… ; aucune correction JSON implicite.

## 3. Consommateurs réels

16 entrées complètes :15 Rust et annie_q_rules.json ;41 ancres dans evidence_review.json. Racine `F:/OpenLeague/`. Points principaux : `crates/core/src/shields.rs:12,41,47`, `damage.rs:101,112`, `annie.rs:45,73`, `spells.rs:101` ; présentation `crates/client/src/projected_live.rs:168`.

grant_shield refuse cible morte, valeur invalide et match fini ; remplace le même tag. advance_shields nettoie, absorb_shields trie par expiration puis consomme. apply_damage applique mitigation avant absorption, puis PV et nettoyage létal. Ce comportement générique ne crée pas le passif ou sa recharge. Le Q adverse Annie consomme ses propres mana/recharge puis produit le dégât magique ; contrôle JSON80brut/60mana/4s/0.8, non formule de Malphite.

Recherche complète bornée aux15 Rust : aucun hit Malphite/Granite/malphiteshield, non absence globale. projected_live sélectionne Annie.29 comparaisons sélectionnées,126 contextuelles fraîches et une identité EXE héritée inerte parmi127 se recouvrent ; pas156 consommateurs.14 mécanismes communs et deux animations ordinaires réutilisés, non présentation du bouclier. Aucun gros registre JSON redécodé ni analyse REA répétée.

## 4. Attendu et observé

Attendu : préserver les deux sources, les acquis/refus et leurs limites, puis relier les écarts aux corrections. Observé :147/147 contrôles documentaires,133/133 de cohérence séparée du même agent. Témoins E relus ; aucun décodeur indépendant ou acceptation humaine.

V598 hérité : base/Ruby1028, PVmax574.2000122070312/724.2000122070312,10% théoriques57.42000198364258/72.42000579833984. Six impacts physiques et deux Q magiques adverses acceptés,102refus/602ticksidle ; boucliers vides, offsets299/300/301 vérifiés. Les dégâts reçus exercent le prérequis pertinent : les propres sorts refusés ne suffisent pas à expliquer l’absence du bouclier. Aucun grant artificiel V598, aucune recharge naturelle qualifiée.

V548 hérité, distinct : trois cas, neuf fenêtres de301ticks sans bouclier naturel, neuf refus Attack/cinq refus d’événement. Un seul grant serveur diagnostique au tick1418 fournit57.42000198364258 : absorptions45.11301803588867 puis12.306983947753906, débordement32.8060302734375PV. Preuve du contrôle générique, non passif ni durée native ; aucun replay.

V598 :12snapshots/cas ; gardes combat/idle distincts du trajet et observations NPC bornées. Refus sans paires brutes, PVidle/entre impacts absents ; tableaux hérités sans nouveau calcul. Binaire6056960octets/SHA30c15bba… inerte ; ancien dossier yasuo simple libellé. OBSpassed non reçu terminal, code brut null ; BUILD/RUN0 hérités. Six opérations documentaires exit0 ; aucun nouveau build, jeu, natifD, GPU, REA ou probe.

## 5. Écarts et inconnues

Activation initiale, reset « touché/dégâts » notamment absorbés/nuls, recharge, PVmax/niveau, priorité/durée, mort/réapparition et producteurs dynamiques restent ouverts. Les boucliers génériques temporisés ne fixent pas cette politique. Flags, icônes et preloads ne qualifient pas recette, lookup, attache, variantes/skin06, rendu/audio ou cycle de vie. Inconnues et consommateurs enregistrés conservés ; binaires/stockages non rouverts.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : native-shield-capacity-recharge-reset-and-resource-contract ; authoritative-natural-shield-producer-recharge-and-absorption ; active-hit-recharging-break-effects-and-lifecycle. Objectifs, prérequis, critères et conditions de reprise explicites ; aucune correction produit implicite.

Prochain lot CH-Malzahar-PASSIF-PRESENTATION-VFX, sources dans next_lot.json. Reprendre sur source, appel, mapping, événement ou dérive précise ; pas de replay inchangé. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_malphite_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, opérations/journaux, result.json et reçus de publication. Publication et sept rubriques vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2359 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité et acceptation ouverts.
