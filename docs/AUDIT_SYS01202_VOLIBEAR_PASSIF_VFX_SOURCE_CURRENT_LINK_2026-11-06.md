# SYS-01.2-02 — Volibear : Chosen of the Storm et consommateurs VFX, V1423

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VOLIBEAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Volibear-PASSIF-PRESENTATION-VFX`, `OLF-1d223688-6ce4-5d1f-9565-e91a60aa0d17` : relier prêt/soin/recharge, franchissement du seuil et dépendance visuelle aux consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues préservés dans initial_scope.json. V541/HUD V1296 et corrections existantes conservés. Liaison close ne signifie ni passif ni QWER ni goal terminés.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/volibear-passive-healing-links-v541.json`,410323octets,SHA `07fb259c26b5d63d4b9236310b4bfe15c4471bd758b2f8adc624874e65924ce4`,UTC documentaire2026-10-25T17:08:25.679166+00:00. Copies retenues dans E ; aucun accès renouvelé D ou F/OpenLeague-work.

Treize ressources primaires : quatre INIBIN,cinq Lua,trois preloads,font. Définition2574octets,SHA `ba743bd501478c0766e1c3a3f159b8dd93cf4421ec11658d589cee398fed9390` ; alias VolibearPassiveBuff,icône VolibearPassive.dds. Passive1/Name/Desc/PassLev1Desc1 absents,non inventés.

Cinq chunks hérités,lecture antérieure complète,zéro prototype enfant,16globals littéraux. Buff220 déclare exactement `VolibearPassive.dds ` avec espace final et persistance/non-dissipation. CD221 déclare VolibearPassiveGray.dds. Heal253 déclare l’icône normale et **AutoBuffActivateEffect=volibear_passive_heal.troy** : dépendance nommée,pas création/lookup/rendu qualifiés. HealCheck221 porte Blitzcrank_ManaBarrier.dds et OnPreDamagePriority=8 ; ni callback exécuté ni bouclier Volibear déduits. CharScript56 est vide. Métadonnées persistantes distinctes du lifecycle.

Font2914/2915/2916 décrit passage sous30%PV,soin de@f1@%PVmax sur6secondes,recharge2minutes. f1 et disponibilité initiale inconnus ;120secondes reste conversion du texte. Identité du miroir vérifiée sans nouvelle lecture sémantique complète.

Trois preloads,813octets :CD101/SHA2a05d9c5,HealCheck293/SHA007da2f4,Char419/SHA03db2293 ;identités complètes dans evidence_review.json. Texte brut et références typées non reconstitués dans les copies sélectionnées ;aucun producteur serveur ou recette effective déduit.

Trois DDS relus uniquement dans E,64×64/DXT5 :deux normaux5616octets/mip7,même SHA `39431236702c5826a1fa819450985302fb69d98d9059233a264d607a12c577dd` ;gris4224/mip1,SHA `2852ff208c1ffea4b458705f3cac2c08b4ef376d5d22b5d14d9ac011a301d1c2`. Membership hérité core0.0.1.7,membres0.0.0.62. Espace absent comme basename exact du seul manifeste70286membres,non-absence universelle. Aucun trim ni lecture de l’icône Blitzcrank. Définition/Heal justifient indépendamment le nom normal. Deux contenus ne prouvent ni provider,ni variante,ni pixels.

## 3. Consommateurs réels

Neuf fichiers actuels,sept Rust/deux Python ;16ancres. Huit sources/frontières et27contextes concordants ;14entrées VFX partagées et deux animations ordinaires inchangées.

Action::Attack→attacks→lifesteal::basic_attack_hit→damage::apply_damage produit la perte PV. tick→regeneration_rates/advance_regeneration et UseItem→use_item/advance_consumables produisent régénération/potion génériques. Branche Garen existante conservée. Aucun producteur Volibear nommé dans sept préfixes Rust examinés,conclusion bornée.

Le contrôle HUD générique déjà qualifié est réutilisé après garde des fichiers :health/max_health et HPStat existent,ressource locale Mana. Source_sha256 distinct de l’INIBIN natif,provenance non confondue. Ces capacités et consommateurs ne qualifient pas les trois états du passif,le fournisseur f1 ou l’activation Troy.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus et reprise. Observé :liaison établie,producteur et présentation dédiés non qualifiés. **29/29 contrôles documentaires,49/49 de cohérence qualifiés du même agent.** HUD86/86 et70/70 hérités.

Deux cas archivés niveau1,ordinaire et potion2003 témoin. Vingt paires brutes d’impacts ordinaires non critiques relues,windup/release concordants. Neuf frappes avant fenêtre puis une après par cas ;au tick1364,203,260986328125→157,51654052734375PV sur584,47998046875,soit34,77638125%→26,94986070%,sans injection directe.

Quatre fenêtres180ticks :720calculs PV/f32 antérieurs réutilisés sans recalcul ;nouvelle relecture des huit premières/dernières paires et des bornes. Sous le seuil,ordinaire157,5165405→167,2257080PV ;potion→227,2247925PV. Résidu ordinaire0,potion0,3333282470703125 aux bornes ;somme héritée59,99908447265625. Taux de base1,618399977684021PV/s. Au-dessus du seuil,résidus antérieurs nuls.

Potion utilisée publiquement au1364,compteur449→270 :expiration non atteinte. Aucun soin natif supplémentaire observé dans ce scénario ;disponibilité initiale non prouvée,donc aucune absence universelle de déclenchement. Égalité30%,f1,recharge120s et réactivation non testés. Huit refus hérités,non huit paires brutes individuelles ;empty inventory slot/health already full distincts. Quatre mouvements,achat/usage de potion séparés ;3088ticks ne sont pas3088frames archivées. Arrêt des attaques/absence de fin restent assertions du collecteur.

RUN296420octets et1158entrées non rouverts. Binaire5943808octets/SHA `f080fab31c970b35875a1f371631b06ecb1a2d8476677fcd0a90631ae697f7a7` :identité inerte. Aucun nouveau build,jeu,natif,REA,GPU ou réseau.

Une erreur actuelle48/49 est conservée :le champ moves contient toutes les commandes,potion comprise. Qualification d’un seul prédicat pour compter action==Move ;48autres contrôles et tous témoins/sources inchangés. Six productions réussies,un échec conservé. L’ancien nom de vérificateur lifesteal n’ajoute aucun test de vol de vie.

## 5. Écarts et inconnues

Disponibilité,f1,égalité/priorité/ordre des dégâts,modificateurs,mort,soin,recharge/réactivation,audiences,recette Troy,owner/attache,provider/variante et pixels restent ouverts. **Le rendu du soin Volibear reste non qualifié.** Icônes,persistance,priorité8 et potion ne remplacent pas le passif. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/HEAL/NETWORK/VFX avec préconditions,fins et reprises. DAMAGE-TRIGGER,COOLDOWN-STATE,TEXTURE-PATH et HUD-BINDINGS existants préservés. Rechercher précisément recette volibear_passive_heal.troy,préchargement/capture/callsite attribué ;pas de recensement global répété. Implémentation sous autorisation distincte. next_lot.json vise Warwick :consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_volibear_passive_vfx_20261106` :coherence_review_corrected.json fait autorité,original48/49 conservé,source/fenêtres/témoins/corrections/journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
