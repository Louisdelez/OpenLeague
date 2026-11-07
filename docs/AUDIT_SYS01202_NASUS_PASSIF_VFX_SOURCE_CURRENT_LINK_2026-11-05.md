# Nasus — Soul Eater : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1381 ; `AUD-SYS-01.2-02-NASUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Nasus-PASSIF-PRESENTATION-VFX` ; `OLF-e5afa89b-4da0-5429-a2d5-9285b83bc2a4`. Audit de liaison borné terminé. Vol de vie des objets et soin générique présents ; bonus Nasus non ajouté dans les corps examinés. Vérification documentaire fraîche, simulations héritées, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat et dépendance NETWORK conservés.

## 2. Sources et provenance

Deux reçus sous `F:/OpenLeague/docs/reference_requirement_trace_sources/` :

- nasus-passive-soul-eater-links-v607.json, 2108031 octets, SHA `67da44a3edb29011d14388b8bba0856b8f24b17151012ae03cdf20fcca5f8dda`.
- nasus-passive-healing-links-v540.json, 433581 octets, SHA `66a1003f8f9bcda9f956f29ffd94c316681afbaf1feceb5c74ba5462589cbf41`.

Copies E identiques. LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct. Les six identités V540 sont un sous-ensemble des32 V607, pas38. HUD V1251 réutilisé :49/49 documentaires,47/47 cohérence historiques.

Douze Lua : sept initialisations,23affectations et cinq limites NEWTABLE. CharScript56 vide ; NasusPassive210 déclare Nasus_Passive.dds/NasusPassive/persistence/NonDispellable. Aucun AutoBuff littéral qualifié, non absence d’effets. Constantes QAttack nassus_siphonStrike_buf.troy/buffbone_cstm_weapon_1 et W GLOBAL_SLOW.TROY restent contexte Q/W ; leurs blocs limités ne deviennent pas recettes du passif. Taunt Chronokeeper/Slow non mécanique étrangère adoptée.

Soul Eater2691 décrit @f1@% bonus Life Steal ; nom4414 et description4238 concordants. Six tooltips, cinq résolus, NasusQ non résolu sans alias automatique. Anciennes descriptions Singed PV/mana et réduction magique10%, textes SoulNexus voisins, rangs manquants et champs INIBIN null restent distincts de la règle Nasus. Dix métadonnées de sorts ;24lignes DDF dont deux Q @stacks/coefficient3, non résolution de @f1@ passif. Seize références communautaires secondaires : Q dégâts de sort immédiats/stacks AD, commentaire E sans réduction appliquée, CharScript vide ; aucune adoption comme serveur original. Cinq absences candidates bornées, aucun manque global d’assets établi.

Découverte qualifiée745953octets/SHA20357009… disponible : sept preloads,3499octets natifs,45références typées. CharScript référence nasus_base_p_lifesteal.troy et nasuspassive. Texte archivé normaliséLF ; reconstructionCRLF retrouve exactement les sept tailles/SHA hérités. Aucun octet natif fraîchement relu ni recipe Troy complète qualifiée. DDS propre2176octets,64×64/DXT1/mip0/membre188 : identité non lookup/pixels/rendu.

Dix-huit captures,16pinnées historiquement/deux ultérieures ;17payloads nonEXE relus. Deux identités d’exécutables Nasus utilisées, dont une capturée en E, restent inertes. Ressource Mana actuelle : source_sha9f9edab3… du JSON communautaire5481octets, distinct de l’INIBIN natif2059/SHA05d13f5d…. Caveat conservé.

## 3. Consommateurs réels

Seize Rust complets,38ancres dans evidence_review.json sous `F:/OpenLeague/`. progression::stats fournit exclusivement items.life_steal.max(0.). lifesteal::basic_attack_hit applique les dégâts physiques, puis post_mitigation×rate et heal pour une cible non structure et un attaquant vivant. heal applique modificateurs reçus et plafondPV ; ce chemin ne produit pas un taux Nasus. Boucliers/surdégâts suivent un contrat communautaire explicite dans les tests lus, non politique native acceptée. Sorts/rangs Nasus refusés, projected_live filtre Annie.

Aucun nom Nasus/SoulEater dans les16corps ; absence bornée.17comparaisons sélectionnées recouvrent31fichiers F contextuels ; binaires Nasus séparés et inertes.14mécanismes communs/deux animations ordinaires concordants, non recette passive.

## 4. Attendu et observé

Attendu : source, consommateur, acquis, écarts et reprise vérifiables. Observé :74/74contrôles documentaires,158/158cohérence séparée du même agent, non pair indépendant. Sept opérations : six exit0, collect01 initial exit1 puis collect02 valide. Échec73/74 : comparaison de fiche minimale à descripteur enrichi, corrigée vers path/taille/SHA ; script,JSON,logs conservés, sources inchangées.

V607 hérité : base/Sword10AD/Sceptre10AD8%, AD59.18/69.18/69.18 et taux0/0/8%. Neuf attaques Nasus, neuf impacts physiques entrants, troisQAnnie,540ticks,81refus et six trajets sans reprise. Attaques candidates réellement exercées malgré refus QWER ; seul le Sceptre soigne environ4.642190PV par coup, attendu4.642174. Base/Sword : résidu9.112e-6. Aucun bonus Nasus qualifié.

Tableaux V1251 hérités sans nouveau calcul : neuf pairesPV source moins médiane de régénération0.06008911/tick, tolérance0.002 dans ce scénario fixe. Attentes avecPV, sans positions ; préimpact adjacent cible/Q et paires brutes des refus absents, NPC non universellement exclus. BUILD/RUN0/0 bruts hérités ; OBSpassed non reçu terminal d’inspection. Binaire V6076117888/SHAea722203… inerte.

V540 distinct : deux cas de six frappes, soin supplémentaire0 contre4.33947754PV ; taux0/8% aux niveaux1–18 via19245événements award_experience par cas. Ces diagnostics ne prouvent ni progression par éliminations ni soins de combat aux niveaux2–18. Ancien binaire5963264/SHA7fe349ed… conservé comme pin seul.

Ancien collecteur DynasuscTooltip et version corrigée conservés ; première inspection signalée exit1 sur l’hypothèse tous-tooltips-résolus, script présent mais reçu terminal brut absent des captures sélectionnées. NasusQ reste non résolu. Aucun nouveau build/jeu/natif/GPU/REA/probe.

## 5. Écarts et inconnues

@f1@, niveaux/cumul, base et dégâts/cibles admissibles, Q renforcée/critiques, boucliers/surdégâts, modificateurs et lifecycle restent ouverts. Applicabilité VFX, lookup/attache/recette, rendu/audio et acceptation non qualifiés. Six trajets Nasus réussis ne corrigent ni V564 ni les deux échecs Ahri/Nami V606. Inconnues, acquis et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : taux/progression/statistiques ; éligibilité/base/soins/lifecycle ; particule/icône/applicabilité/provenance/nettoyage. Objectifs, prérequis, critères et conditions de reprise explicites. Correction produit distincte à autoriser.

Prochain `CH-Nautilus-PASSIF-PRESENTATION-VFX` dans next_lot.json, avec recherche préalable d’audit équivalent. Aucune répétition sans nouvelle entrée précise ; aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_nasus_passive_vfx_20261105/` : evidence_review.json, coherence_review.json, corrections_and_restart.json, journaux, result.json et reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2368 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal/Plan/UI/bases/registres/produit/assets inchangés ; tâche complète, fonctionnalité, parent et jeu ouverts.
