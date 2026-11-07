# Nocturne — Umbra Blades : sources, consommateurs et écarts

## 1. Exigence et portée

Date UTC2026-11-05, V1384 ; `AUD-SYS-01.2-02-NOCTURNE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Nocturne-PASSIF-PRESENTATION-VFX` ; `OLF-1e662376-8a08-5007-8739-25b1b5eb3519`. Audit de liaison borné terminé. Attaques/soins génériques présents ; état prêt, dégâts de zone, soin natif et recharge non qualifiés. Vérification documentaire fraîche, simulations héritées, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat et dépendance NETWORK conservés.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/nocturne-passive-umbra-blades-links-v610.json`, 2313245octets, SHA `01fec5b05f56657b7596864784c758048b3dfe8b755d49f202d4c48dd509e912` ; copie E identique. LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.59sources :16INIBIN/26Lua/15preloads/DDF/font. HUD V1254 :65/65documentaires,50/50cohérence historiques réutilisés.

26Lua :10initialisations/38globals/16limites NEWTABLE. CharScript114 expose seulement Wolfman_InnerHunger.dds ; il n’est pas vide, contrairement au CharScript communautaire inspecté. Tooltip90 persistence distinct d’Umbra407, qui expose NocturnePassiveReady.troy aux paumesL/R. Cooldown173 porte le nom avec espaces ; Marker341 possède quatre champs AutoBuff vides. Douze champs AutoBuff au total, deux AutoBuffActivateEvent DeathsCaress de contextesR conservés distincts des effets passifs. Alias Wolfman non règle Warwick adoptée.

Dix tooltips résolus.2391réduction1s par attaque ;2398prêt120%physiques/soin@f1@par cible ;2399cycle10s ; description4241/nom4417 concordants. Passive1=1,rangs1/6/11/16 puis absents, anciens textes Warwick/mana40/60/80% non progression adoptée. Quinze métadonnées de sorts ; UmbraAttack CastRadius100/CastRange125/Cooldown0 ne définissent pas rayon/délai natifs. Douze DDF dont QbonusAD0.75/RbonusAD1.2 et quatreUmbra vides, non montant du soin.

Le fichier «Nocturne Passive Cooldown.inibin» existe avec espaces ; l’absence du candidat compact ne signifie pas données manquantes ni résolution runtime qualifiée. Cinq absences candidates bornées, aucun manque global d’assets établi.21références communautaires secondaires : QtotalAD contre DDFbonusAD,Ecallbacks sans distance,Rdirect non dash/vision ; non serveur original.

Découverte835533octets/SHA95b9f4f9… disponible :15preloads/6793octets natifs/84références, dont cooldown/marker/UmbraAttack/nocturneumbrablades_tar.troy/ifhasbuffcheck. Texte normaliséLF, reconstructionCRLF conforme aux15tailles/SHA hérités. Aucun accès natif frais ni recette/lookup/exécution de dépendance qualifiée.

Deux DDSnormaux2872octets/64×64/DXT1/mip7/membre25 identiques ; gris2176/mip1/membre79 distinct. Wolfman reste contexte de manifeste hérité, non DDS fraîchement capturé. Quinze captures,13pinnées historiquement/deux ultérieures ;14payloads nonEXE relus, binaire inerte. Ressource actuelle source_shac0809e89… du JSON communautaire9054octets, distinct de l’INIBIN natif3723/SHAf0b1f433… ; caveat conservé.

## 3. Consommateurs réels

Seize Rust complets,37ancres dans evidence_review.json sous `F:/OpenLeague/`. Attaques→basic_attack_hit→dégâts physiques puis postmitigation×voldevie des objets→heal/plafondPV acquis. Aucun producteur Umbra qualifié. Sorts/rangs Nocturne refusés ; projected_live filtre Annie. Aucun nom Nocturne/Umbra dans ces16corps, absence bornée.

Seize fichiers réels de SOURCE/frontières recouvrent30fichiers F contextuels : SOURCE cite lib.rs et reference_inibin.py, pas lua51_reference.py. Binaire séparé, inerte.14mécanismes communs/deux animations ordinaires concordants, non recette du passif.

## 4. Attendu et observé

Attendu : liens précis, acquis, limites et reprise vérifiables. Observé :79/79contrôles documentaires,195/195cohérence séparée du même agent, non pair indépendant. Huit opérations journalisées : sept exit0, current01initial1 puis current02valide. Nom réel inspection_qualified retrouvé dans historique ; autre garde autonome échouée sur lecteur supposé absent de l’ancien contexte, corrigée vers union SOURCE/frontières. Scripts et échecs conservés, garde autonome sans journaux bruts disponibles. Un contrôle Event initial auto-comparatif a été renforcé vers attentes explicites ; ancien passage réussi et preuves conservés, aucune source altérée.

V610 hérité : base/Sword10AD/Sceptre10AD8%, AD59.208/69.208/69.208,taux0/0/8%.18attaques Nocturne, neuf physiques entrants, troisQAnnie,1806ticks d’attente,81refus,six trajets sans reprise. Deux attentes301ticks par cas ; ancien libellé540conservé comme historique erroné, non décompte courant. Attaques candidates exercées, dégâts ordinaires seuls, bonus120% non observé ; refus propresorts non explication suffisante.

Soin hérité : base/Sword résidu−1.295e-5PV ; Sceptre4.644030PV attendu4.644053.18pairesPVsource moins médianeregen0.05505371/tick,tolérance0.002, reconstruction héritée sans nouveau calcul. Une seule cible : zone, soin par cible et réduction du délai non qualifiés. Attendre sans état prêt observé ne vérifie pas son timer.

Préimpact adjacent cible/Q et paires brutes de refus absents, NPC non universellement exclus. BUILD/RUN0/0 bruts hérités ; OBSpassed non reçu terminal d’inspection. Binaire6153216octets/SHA79b78669… inerte, ancien dossier yasuo simple libellé. Aucun nouveau build/jeu/natif/GPU/REA/probe ;1158dépendances non rejouées.

## 5. Écarts et inconnues

@f1@, progression, géométrie/cibles, base120%/critiques, recharge/réduction/consommation et lifecycle ouverts. Présence du cooldown avec espaces n’établit pas son résolveur. Applicabilité/recette/attache/lookup,rendu/audio et acceptation ouverts. Six trajets réussis ne ferment ni V564 ni les échecs V606. Inconnues et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Quatre clauses de la tâche existante dans corrections_and_restart.json : readiness10s/réduction1s ; zone/dégâts120% ; soin@f1@par cible/modificateurs ; présentation/provenance/nettoyage. Objectifs, prérequis, critères et reprise précis. Correction produit distincte à autoriser.

Prochain `CH-Nunu-PASSIF-PRESENTATION-VFX` dans next_lot.json, après recherche d’audit équivalent. Lire noms exacts de captures/source_sites avant adaptation ; réutiliser les preuves inchangées. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_nocturne_passive_vfx_20261105/` : evidence_review.json, coherence_review.json, corrections_and_restart.json, journaux, result.json et reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2371 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal/Plan/UI/bases/registres/produit/assets inchangés ; tâche complète, fonctionnalité, parent et jeu ouverts.
