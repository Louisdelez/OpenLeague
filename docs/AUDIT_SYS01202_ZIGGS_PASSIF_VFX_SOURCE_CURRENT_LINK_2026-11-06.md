# SYS-01.2-02 — Ziggs : Short Fuse, sources et consommateurs VFX, V1431

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-ZIGGS-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

Tâche `CH-Ziggs-PASSIF-PRESENTATION-VFX`, exigence `OLF-3e85521f-04c3-5662-b58b-e5c1562348e9` : relier disponibilité, recharge, attaque/impact et effets déclarés aux consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. V656/HUD V1305 et corrections réutilisés. Cette liaison ne termine ni le passif, ni QWER, ni le goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/ziggs-passive-short_fuse-links-v656.json`,5206685 octets,SHA `4b36a42ed640a6d42ec668fffd9a29202f10f2429b121f32d2f9ba2e01fe0087`, UTC hérité2026-10-27T03:46:09.757396+00:00. Copies E retenues ; aucun nouvel accès D ou F/OpenLeague-work.

Quatorze primaires :5INIBIN,5Lua,3preloads,font ;60 identités liées non promues. Ziggs.inibin2415/SHA `75b525f7279444d9f630c9c0d7f5e386f12ed6605e295ff58f955cd3cdbc2d0a` :ZiggsPassiveBuff/ZiggsPassiveReady.dds. Passive1/Desc/Level1..6 absents, sans conversion en zéro.

29vues Lua consommées entièrement antérieurement, zéro prototype enfant ;12littérales,33globals,17limites NEWTABLE. CharScript56 vide. BasicAttack167/PassiveAttack499/PassiveBuff416/ShortFuse710 sont non interprétés par le lecteur littéral. Leurs globals vides ne démontrent pas l’absence de propriétés ou de callbacks.

Les constantes de ShortFuse nomment ZiggsPassive.troy, AutoBuffActivateEffect/Effect2, Bomb/Bomb_b, SpellToggleSlot/2, PersistsThroughDeath et trois skins MadScientist/PoolParty/Snowday. **Aucune association propriété-valeur, recette, pose ou sélection effective n’est déduite de cette liste.** Candidates et limites exactes sont dans evidence_review_corrected.json ; pas de nouveau décodage natif. SpellData Disintegrate/ZiggsW et cinq Effect1=12 ne sont pas la formule BuffData du passif.

Trois preloads relus depuis découverte :Char222/SHA b339140c, PassiveAttack101/SHAee0b8dcf, PassiveBuff91/SHA7c818a30 ;414octets/cinq appels littéraux. Char→PassiveBuff/ShortFuse et apbonusdamagetotowers distinct ;Buff→ShortFuse ;Attack→ziggspassive_tar.troy. Textes/identités complets en preuves. Préchargement distinct de création, owner et horloge.

Neuf liaisons font4495/4319/3001–3003/9970/10700/11367/12061 :12s,retrait4s par compétence,150%sur structures,@f1@(+@f2@). Deux PLACEHOLDER préservés. DDF et fichier ShortFuseCooldown non retrouvés dans le seul périmètre découvert, sans absence globale affirmée. Font gardée par identité, sans reparcours sémantique.

Deux DDS2176 chacun,64×64/DXT1/mip1, même SHA `22eef7e15b6bf77e05d0c0b4e565914f87d07b2d35b932ec0022863b6509171d`. Propre Info et partagé Icons2D,membre71/core7 hérités ; capture partagée issue du lot Zed réutilisée sans Dstat/read. Les deux sont relus dans E. Même contenu ne prouve ni provider/montage/priorité, ni pixels.

## 3. Consommateurs réels

Treize fichiers actuels,douze Rust/un Python,26ancres. Douze sources/frontières,34contextes,14entrées VFX communes et deux animations ordinaires concordants. command→windup→projectile→basic_attack_hit→apply_damage, mitigation, boutique/AP et stats présents. Ordre actuel AnnieQ→régénération→attaques ordinaires vérifié sur fenêtres de code retenues.

Aucun hook Ziggs/ShortFuse dans les douze préfixes Rust examinés ; conclusion bornée, sans absence universelle. HP/Mana HUD acquis, ressource Mana de provenance distincte. Ni état prêt/recharge ni f1/f2 qualifiés. Chargement DDS, owner/projection/animation génériques et AnnieQ ne produisent pas le passif.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus/reprise. Observé :pistes et consommateurs reliés,producteur/rendu spécifiques non établis. **30/30 contrôles documentaires qualifiés,60/60 de cohérence séparée du même agent.** HUD162/162 et128/128 hérités.

Quatre cas Ziggs1/18×AP0/20 contre Annie18 :douze résumés d’impact, avec windup/projectile/libération non critiques concordants. Aucune paire PV brute pré/post-impact disponible. Calculs f32 et douze endpoints reconstruits antérieurement conservés,sans recalcul ;physique moteur28,9541721/57,1028786,écart d’un ULP au1 hérité. Douze snapshots359/360/361 et quatre endpoints finaux relus, sans toutes les frames intermédiaires.

Sans proc qualifié,ces fenêtres ne démontrent pas l’expiration12s. Refus des sorts Ziggs ne prouvent pas réduction4s ;structures non exercées. Impacts relatifs0/46/380 au1,0/34/378 au18 hérités.

Deux contrôles AnnieQ distincts contre Ziggs :80/96bruts,coût60,libération8ticks,recharge120. Deux paires PV avant/final relues :1884,4000244→1822,9713135/1810,6635742. Calculs hérités,ordre dégâts puis régénération ;pas une preuve Short Fuse. Ancien collecteur clampait avant dégâts ;diff exact des deux sources retenues confirme la correction diagnostique,sans modifier le moteur. BUILD0/RUN101 initial et binaire ancien6086144/SHA b80ecbb6 conservés comme métadonnées.

118refus à flags,non118paires individuelles ;huit XP diagnostiques,trois achats1052/20AP/435or,douze arrivées héritées.13272ticks=2×2341+2×2337+2×1958,non toutes frames. Deux RUN183/738095octets et1158entrées non rouverts. Binaire corrigé6094848/SHA `0dad4a3ab220a06e57d336f7e5c07d6a5590e4a94f33af96b934d04657243d94` inerte.

Collect01 avait29/30 :identification inversée des collecteurs. SHA du probe et diff exact établissent history1=correct10053,history4=initial9356. Un seul prédicat qualifié,29autres et tous témoins/labels bruts inchangés ;échec et qualification conservés. Ancien rôle SOURCE rejeté avant acquisition,source suivant réussi,preuve conservée. Erreurs root de préparation/consultation archivées séparément,aucun échec moteur déduit. Six productions actuelles réussies et un collect01 échoué conservé ;aucun nouveau build,jeu,natif,REA,GPU ou réseau.

## 5. Écarts et inconnues

f1/f2,niveaux/AP,cibles/structures,consommation lancement/impact,disponibilité,réductions QWER/toggles/plancher,annulation,critique,boucliers,lifecycle,owner/attache/provider/variantes et son restent ouverts. **Le rendu Short Fuse reste non qualifié.** Constantes,préchargement,AnnieQ et icône ne remplacent pas le passif. Inventaire secondaire complet et acceptation indépendante/humaine non qualifiés.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/ONHIT/NETWORK/VFX,préconditions,fins/reprises ;cinq dépendances READINESS-CD/ABILITY-CD-REDUCTION/STRUCTURE-DAMAGE/ICON/HUD conservées. Reprendre sur script/Troy/capture/callsite attribué ou consommateur modifié ;autorisation distincte pour implémenter. next_lot.json vise Zilean,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_ziggs_passive_vfx_20261106` :sources,constantes non interprétées,textes,fenêtres,résumés/AnnieQ,cohérence,qualifications et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés. Journal Python des producteurs seulement ;contexte/dispatch/gardes/empaquetage exclus,sans garantie OS/TOCTOU.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
