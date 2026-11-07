# Nautilus — Staggering Blow : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1382 ; `AUD-SYS-01.2-02-NAUTILUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Nautilus-PASSIF-PRESENTATION-VFX` ; `OLF-0bd69f97-1eb1-5da3-a010-3a8a997ca3ff`. Audit de liaison borné terminé. Attaques et contrôles génériques présents ; producteurs du bonus, de root et d’immunité par cible non qualifiés. Vérification documentaire fraîche, simulations héritées, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat et dépendance NETWORK conservés.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/nautilus-passive-staggering-blow-links-v608.json`, 2580470octets, SHA `c94e7360215086821b06ee04ed20dd1c8bfecd0b11f5170a7319a53fd2a7c48a` ; copie E identique. LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.79payloads V608 ; la fiche SOURCE possède82identités dont trois candidats BuffName supplémentaires, pas82payloads V608. LuluFaerieOverrideTemp, MalzaharVoidlingDanceOverride et MordekaiserCOTGDanceOverride restent contexte littéral hérité, non alias d’exécution. HUD V1252 :51/51documentaires et52/52cohérence historiques réutilisés.

33Lua :23initialisations/123affectations,10limites NEWTABLE. CharScript56 vide. Passive211 : icône3114_Malady, nomNautilusPassive/persistence/NonDispellable ; Root256 : StaggeringBlow/PopupSnared/persistence ; Check478 : nom et six champs AutoBuff vides/persistence/NonDispellable.15champs AutoBuff au total, effets BackswingLuxShield/Naut_Shield et autres QWER distincts. Vide ne signifie pas absence globale d’effets ; alias Malady/Lux non mécanique étrangère adoptée.

Onze tooltips résolus.2340 : bonus physique@f1@, immobilisation@f2@secondes, même cible au plus une fois toutes@f3@secondes ;2341immunité temporaire,2342immobilisation. Description4239/nom4415 concordants. Passive1=9,rangs3/7/11/15 puis absents, textes Jax/AD et mana40/60/80% conservés sans politique déduite.24métadonnées de sorts, huit DDF dont seuls Q0.5×special et W0.1×bonushealth non vides, non formules passives.30références communautaires secondaires : QRoot0.5s sans hook établi,Wdelegate,Rtimer1s,E3timers ; non serveur original. Cinq absences candidates bornées, aucun manque global d’assets établi.

Découverte1024914octets/SHA38e0ced0… disponible :19preloads,7995octets natifs,99références typées. PassiveRoot référence root, particules lv1/lv6/lv11/lv16 et variantes ; noms non paliers/durées. Texte capturé normaliséLF, reconstructionCRLF conforme aux19tailles/SHA hérités. Aucune lecture native fraîche ni exécution de root/recette Troy qualifiée.

Quatre DDS2872octets,64×64/DXT1/mip7 : StaggeringBlow identiques info/Spells membre77 ; Malady identiques Items/Spells membre25, différents de StaggeringBlow. Identité non lookup/pixels/rendu. Quinze captures,13pinnées historiquement/deux ultérieures ;14payloads nonEXE relus, binaire inerte. Ressource actuelle source_sha29a536ca… du JSON communautaire7382octets, distinct de l’INIBIN natif2654/SHAe61269d0… ; caveat conservé.

## 3. Consommateurs réels

17Rust complets,41ancres dans evidence_review.json sous `F:/OpenLeague/`. Attaques→basic_attack_hit→dégâts physiques, soin générique des objets et plafondPV acquis. Aucun bonus Nautilus identifié. stuns::grant_stun est une API serveur : annule présentation d’attaque et windup, gère durée et nettoyage ; aucun producteur de root Nautilus ou timer par cible établi. Ce contrôle n’est pas un substitut de root. Sorts/rangs Nautilus refusés ; projected_live filtre Annie.

Aucun nom Nautilus/StaggeringBlow dans ces17corps, absence bornée.18comparaisons sélectionnées recouvrent32fichiers F contextuels ; binaire séparé, inerte.14mécanismes communs/deux animations ordinaires concordants, non recette du passif.

## 4. Attendu et observé

Attendu : liens, provenance, acquis, écarts et reprise vérifiables. Observé :85/85contrôles documentaires,213/213cohérence séparée du même agent, non pair indépendant ; six opérations documentaires exit0.

V608 hérité : deux cas base/Épée10AD, AD57.544/67.544, AP0/voldevie0, PVmax576.47998/manamax284. Six attaques Nautilus, six physiques entrants, deuxQAnnie,360ticks d’attente,54refus, quatre trajets sans reprise. Premier coup et suivants : dégâts ordinaires seuls, environ48.26707/56.65492 après mitigation ; aucun bonus qualifié. Attaques candidates exercées, refus des sorts propres non explication suffisante.

Trois paires de positions après premier impact par cas, offsets1/2/3 :11.1665039unités par tick, vitesse335, listesstuns vides. Cela prouve mouvement dans ces six observations, non absence universelle de root ni durée native. Sans bonus initial qualifié, délai@f3@non testé.

Tableaux V1252 hérités sans recalcul : attentes avecPV sans positions ; préimpact adjacent cible/Q et paires brutes de refus absents, exclusion universelle NPC non qualifiée. BUILD/RUN0/0 bruts hérités ; OBSpassed non reçu terminal d’inspection. Binaire6131200octets/SHAe1a737e4… inerte, ancien dossier yasuo simple libellé. Aucun nouveau build/jeu/natif/GPU/REA/probe ;1158dépendances non rejouées.

## 5. Écarts et inconnues

@f1@/@f2@/@f3@, progression, cibles, ordre dégâts/critique, actions pendant root, cumul/tenacité et cycle par couple d’acteurs ouverts. Rangs3/7/11/15 et noms lv1/6/11/16 ne sont pas une loi qualifiée. Applicabilité, recette/lookup/attache, rendu/audio et acceptation ouverts. Quatre trajets réussis ne ferment ni V564 ni échecs V606. Inconnues et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Quatre clauses de la tâche existante dans corrections_and_restart.json : bonus physique/événement ; durée root/politique des actions ; immunité par cible/lifecycle ; présentation des trois états/ressources/nettoyage. Objectifs, prérequis, critères et reprise précis. Correction produit distincte à autoriser.

Prochain `CH-Nidalee-PASSIF-PRESENTATION-VFX` dans next_lot.json, après recherche d’audit équivalent. Réutiliser les preuves inchangées ; nouvelle investigation seulement sur entrée ou question précise. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_nautilus_passive_vfx_20261105/` : evidence_review.json, coherence_review.json, corrections_and_restart.json, journaux, result.json et reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2369 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal/Plan/UI/bases/registres/produit/assets inchangés ; tâche complète, fonctionnalité, parent et jeu ouverts.
