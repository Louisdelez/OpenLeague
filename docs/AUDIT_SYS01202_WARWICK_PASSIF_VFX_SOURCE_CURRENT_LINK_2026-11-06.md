# SYS-01.2-02 — Warwick : Eternal Thirst et consommateurs VFX, V1424

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-WARWICK-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Warwick-PASSIF-PRESENTATION-VFX`, `OLF-3b3a3d23-3c66-5882-b7f7-ff8d4c4a02bd` : relier attaques,soin,cumuls et dépendances visuelles aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues préservés dans initial_scope.json. V539/HUD V1297 et corrections existantes conservés. Cette liaison ne termine ni passif,QWER,fonctionnalité ou goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/warwick-passive-healing-links-v539.json`,369225octets,SHA `7b6b11491b136855af84bdcbdd2b328158bad53ab8e515502f2ef05bd9e8ed76`,UTC documentaire2026-10-25T16:40:29.824787+00:00. Copies retenues dans E ; aucun accès renouvelé D ou F/OpenLeague-work.

V539 et l’inspection qualifiée n’ont pas native_metadata ;le primaire n’a pas phases. Découverte archivée distincte :champs et trois Lua comparés exactement aux métadonnées HUD réutilisées. Phases/lots issus du cache de contrats,non inventés dans V539. Neuf primaires :trois INIBIN,trois Lua,deux preloads,font. Six fichiers WarwickBot exclus,non promus.

Définition3004octets,SHA `079c090e5e280436984cc7548636bbfc8f7d24581373f8312ff4a124e5828259` :Passive1=1,alias exact `Eternal Thirst`,icône Warwick_InnerHunger.dds. Description d’attaques successives contre la même cible. Font4483 pour le nom ;clés INIBIN vers1874/Eternal_Thirst et1876/EternalThirstBuff. Texte :dégâts magiques supplémentaires@f1@,soin égal,cumul jusqu’à trois frappes. Clé voisine EternalThirsted1877 distincte ;f1/formule/niveaux/expiration inconnus. Miroir font vérifié par identité,sans nouvelle lecture sémantique complète.

Lua Buff159,Icon218,CharScript114 :lecture antérieure complète,trois initialisations littérales/sept globals,zéro prototype enfant. Tous nomment Wolfman_InnerHunger.dds. BuffName EternalThirstBuff et Eternal Thirst restent distincts ;Icon déclare persistance/non-dissipation. CharScript contient une déclaration d’icône,donc n’est pas vide. Aucun AutoBuff reconnu dans ces vues ;aucune absence globale d’effet déduite.

Deux preloads,332octets,décodages conservés dans la découverte relus :Icon104/SHA `07ceec2551f80464167e69a728aeda601c2b32230f91cf09c40944396567ba55` déclare BBPreloadParticle globallifesteal_buf.troy ;Char228/SHA `a900be61dedabf975d9e08636b7d6f93a4c445f14ed612d819894773934f262c` déclare BBPreloadSpell eternalthirsticon,apbonusdamagetotowers,bloodscent_internal. Quatre appels littéraux,aucun exécuté ni résolution typée complète. Chaîne Char→Icon→particule identifiée ;deux autres contextes non promus en passif,préchargement distinct de création.

Deux DDS relus dans E,4224octets chacun,64×64/DXT5/mips brut0 :Warwick propre,SHA `0af606058f72f1705827732cca08d8331418880b1a9a2c112f9f0f9feafb0ac4`,membre0.0.0.40 ;Wolfman partagé,SHA `364deb386bd97b165a4d6a75fd1426b84eefffe4a337b3f18a92aca4457a971d`,membre0.0.0.25. Membership core0.0.1.7 hérité. Contenus différents,pas de substitution automatique ou priorité provider qualifiée.

## 3. Consommateurs réels

Neuf fichiers actuels,sept Rust/deux Python ;14ancres. Huit sources/frontières et28contextes concordants ;14entrées VFX partagées et deux animations ordinaires inchangées.

Attack→attacks→basic_attack_hit applique le physique puis soigne de outcome.post_mitigation×rate ;progression fournit le taux des objets,healing les gardes/modificateurs/plafond. lib.rs739 advance_regeneration précède742 advance_attacks. Les chemins génériques sont préservés,non producteurs démontrés de dégâts magiques ou cumuls Warwick. Aucun producteur nommé dans les sept préfixes Rust examinés,conclusion bornée.

HUD health/max_health et HPStat acquis après garde d’identité,ressource locale Mana ;source_sha256 distinct de l’INIBIN natif. Aucun binding f1/cumul ou rendu Eternal Thirst qualifié. Owner/projection et animations génériques ne créent pas l’effet natif.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus et reprise. Observé :dépendances et consommateurs reliés,producteur dédié/rendu non établis. **27/27 contrôles documentaires,51/51 de cohérence qualifiés du même agent.** HUD68/68 et66/66 hérités.

Deux cas L1,sans objet/achat public1053. Douze ensembles de paires PV source/cible relus :six attaques non critiques,même cible,aux899/943/987/1031/1075/1119. Source vivante/blessée/non plafonnée,cible vivante/sans target ni windup. Dix relevés hors frappe relus,six blessures préparatoires héritées,quatre mouvements publics,sans injection. Inventaires/or825sans objet et25avec1053 concordent,prix800. Six refus enregistrés,non six paires brutes individuelles.2238ticks ne sont pas2238frames archivées.

Calculs f32 antérieurs réutilisés,sans recalcul :AD62,4300003/72,4300003,taux0/0,0799999982,armure27,5359993,physique48,9508858/56,7918091,régénération1,6787999868PV/s. Physique/vol de vie/régénération avant attaques expliquent les deux acteurs,plafond de la cible pleine avant la première frappe conservé. Résidus relus :six fois0 sans objet,six fois4,5433349609375avec Sceptre ;hors frappe0. Ce témoin ne qualifie ni formule magique,f1,cumul ou soin natif.

RUN101463octets et1158entrées non rouverts. Binaire5943808octets/SHA `7a117a4f96b37574cde33efb760f431f1177b2380d5bc958293e32fd563719b0` :identité inerte. Aucun nouveau build,jeu,natif,REA,GPU ou réseau.

Ancien refus d’inspection rapporté pour une chaîne erronée ;script qualifié6489octets/SHA459fca9f relu comme donnée,avec ancre réelle self.basic_attack_hit(id,w.target,raw). Script/erreur bruts avant correction non récupérés,aucune exécution ou correction du jeu.

Présente cohérence50/51 :attente MonkeyKing héritée de l’ordre HUD,alors que couverture VFX figée sélectionne Xerath. Qualification d’un seul prédicat contre cette couverture,50autres contrôles et tous témoins/sources inchangés. Six productions réussies,un échec conservé.

## 5. Écarts et inconnues

f1,niveaux,producteurs magiques/soin,cumuls/expiration/changement de cible,mort,modificateurs,audiences et recette/owner/attache/provider/variante restent ouverts. **Le rendu Eternal Thirst reste non qualifié.** Pas de test supérieur,critique,overkill,bouclier ou acceptation indépendante/humaine. Aucun inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/ON-HIT/NETWORK/VFX,avec préconditions,fins et reprises. STACK-STATE,ICON-PROVIDER-PATH et HUD-BINDINGS existants préservés. Piste précise :Icon.preload104/globallifesteal_buf.troy ou capture/callsite attribué,non nouveau recensement global. Implémentation sous autorisation distincte. next_lot.json vise Xerath selon couverture VFX ;un rapport MonkeyKing existe déjà,sans nouvelle qualification de celui-ci ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_warwick_passive_vfx_20261106` :coherence_review_corrected.json fait autorité,original50/51 conservé,découverte/préchargements/fenêtres/témoins/corrections/journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
