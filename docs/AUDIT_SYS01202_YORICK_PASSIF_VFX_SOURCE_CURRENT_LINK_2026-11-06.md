# SYS-01.2-02 — Yorick : Unholy Covenant et consommateurs VFX, V1428

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-YORICK-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Yorick-PASSIF-PRESENTATION-VFX`, `OLF-f76dbda4-3fbd-5a75-834e-3b8f3cd0d1e6` : relier compte d’invocations,bonus/réduction et dépendances aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues préservés dans initial_scope.json. V653/HUD V1302 et corrections existantes conservés. Liaison close ne termine ni passif,QWER,fonctionnalité ou goal.

Transition explicite depuis XinZhao V1426 :Yasuo V1427 réutilise le seul audit primaire V1320,44doc/46cohérence hérités,35empreintes F fraîchement revérifiées. Zéro nouvelle clôture Yasuo ;COR-YASUO-PASSIF-VFX-SECONDARY-SOURCE-01 reste ouverte. Reçu et continuation épinglés ;suite Yorick issue de la couverture figée,sans remplacement du goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/yorick-passive-unholy-covenant-links-v653.json`,3395503octets,SHA `ab8415843c823200d6cfb2b75f0b7f50ef67cd3fce6b0aaf89a4e9d175ab9a71`,UTC documentaire2026-10-27T02:45:55.926130+00:00. Copies retenues dans E ;aucun accès renouvelé D ou F/OpenLeague-work.

Trente primaires :13INIBIN,11Lua,quatre preloads,DDF,font.64autres identités restent contextuelles. Définition2803octets,SHA `d4877b8b58833648e82425135864ccab72a3f2107aa9457bd85678580f1c271c` :YorickUnholySymbiosis/YorickUnholyCovenant.dds ;Passive1/Level1..6 absents,non zéro.

41vues Lua héritées,entièrement consommées antérieurement,toutes littérales,123globals,zéro prototype enfant/limite. Quatre CharScript56 vides. Unholy226 porte nom,icône,persistance/non-dissipation ;ni producteur serveur ni lifecycle déduits.

14vues portent28champs AutoBuff :quatre valeurs vides conservées,Slow/Spectral/R/Revenant et variantes distincts. Spectral déclare deux effets yorick_spectralGhoul_attack_buf_self.troy attachés l_hand/r_hand ;ActiveSpectral déclare speed_buf. RDelay vide,RAZombie et variantes citent ult_04/05/revive ;aucune variante universelle ou règle de comptage déduite. Nom de bone déclaré distinct d’une pose observée ;pas de recette passive complète qualifiée.

Font4491/4315/2975 :+5%dégâts d’attaque ordinaire et-5%dégâts reçus par invocation active ;goules à35%AD/PV Yorick. Catégories,plafond,cumul et capture/rafraîchissement inconnus. Trois définitions de personnage,preuves distinctes des homonymes DATA/Spells,donnent60PV/10AD,croissances0,non statistiques finales35%. DDF E1,0bonusAD,divergence AP communautaire conservée ;Revenant communautaire non preuve d’apparition. Font vérifiée par identité,sans nouveau reparcours complet.

Quatre preloads relus depuis découverte :Char236/SHAe7f03e6f,Decayed548/SHA9dca5bcc,Ravenous313/SHAf93c2809,Spectral451/SHA0d8e5281,total1548octets.20appels littéraux :Char→Unholy/lifesteal ;trois BBPreloadCharacter nomment les trois goules,avec logiques,Slow,explosion/mort/spectral. Identités et textes complets dans evidence_review_corrected.json. Aucune exécution/résolution typée complète :préchargement distinct d’apparition,création d’effet,owner ou horloge.

Deux DDS Info/Icons2D relus dans E,2176octets chacun,64×64/DXT1/mips brut1,même SHA `5852ca4ad1449ef76b89be8f96377db56cc01c788ab5bdc32a367cffc02cb5ca`. Membres0.0.0.36,core0.0.1.7 hérité. Même contenu ne prouve ni priorité provider ni montage/pixels.

## 3. Consommateurs réels

Quatorze fichiers actuels,douze Rust/deux Python ;32ancres. Treize sources/frontières et37contextes concordants ;14entrées VFX communes,deux animations ordinaires et35entrées de transition Yasuo inchangées.

command/advance_attacks/basic_attack_hit/apply_damage,penetrated_defenses/mitigate,stats et régénération existent ;régénération avant attaques. cast_tibbers,advance_annie_r,guide_tibbers,advance_pet_orders et world::spawn_unit sont présents. Ces unités Annie ne remplacent pas les goules. Aucun hook Yorick nommé dans les douze préfixes Rust examinés,conclusion bornée ;absence de définitions Yorick dans le monde actuel réutilisée après garde.

Barres HP/Mana et MPStat acquis après garde d’identité ;provenance de ressource distincte de l’INIBIN natif. Compte,bonus/réduction,icône et texte Unholy ne sont pas liés à un état qualifié. Primitives génériques d’owner/projection/animation distinctes du rendu dédié.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus et reprise. Observé :dépendances et consommateurs reliés,producteur/rendu spécifiques non établis. **31/31 contrôles documentaires qualifiés,59/59 de cohérence du même agent.** HUD100/100 et89/89 hérités.

Deux cas Yorick1/18,Annie18,zéro invocation. Six impacts de mêlée non critiques relus sous forme de résumés,non paires PV brutes pré-impact. Calculs physiques hérités :AD57,5800018/117,0800018,physique30,7552643/62,5360565,tolérance0,004. Aucune qualification de5%/35% à compte nul.

Six paires PV brutes d’API serveur relues :20physique,20magique,20brut par cas,sans sort ennemi. f32 antérieur conservé,sans recalcul :15,9938574/15,1400452/20 au1,10,7383709/13,0420599/20 au18,zéro absorption/bouclier. Endpoints PV reconstruits antérieurement,non frames intermédiaires archivées.

Tibbers distinct,rang1 :CastAt public,apparition8ticks,vie1350ticks,1200PV/80AD/30armure,guidage Move accepté. Quatre relevés relus aux1/1349/1350/1351 :owned1/1/0/0,lookup22/22/None/None. L’objet unité reste présent à0PV après expiration,pas de suppression mémoire déduite ;guidage accepté non trajectoire complète qualifiée.

57refus à flags,54Yorick/3Tibbers,sans57paires brutes individuelles. Quatre XP diagnostiques ;5542ticks=2109+2074+1359,non toutes frames. Ancien RUN201330octets/1158entrées non rouverts. Binaire6074368octets/SHA `0809d39d8485f1fb265b4c77c44c955991fe1013dee0a74079e0692e736cf038` inerte. Aucun nouveau build,jeu,natif,REA,GPU ou réseau.

Collecte initiale30/31 :sélecteur cherchait un nom HUD d’un autre reçu. Le prédicat réel Mana_HUD_existing est réutilisé après garde37contextes ;un prédicat/sélecteur corrigé,30autres contrôles et témoins inchangés. Six productions réussies,un échec conservé.

## 5. Écarts et inconnues

Création/cycle de vie des goules/Revenant,compte,5%,35%,capture/refresh,ordre,mort/respawn,transport,recette/owner/attaches/provider/variante et pixels restent ouverts. **Le rendu Unholy Covenant reste non qualifié.** Zéro invocation,Tibbers ou bases60/10 ne prouvent pas les effets Yorick. Aucune revue indépendante/humaine ou inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/COUNT-MODIFIERS/NETWORK/VFX,préconditions,fins et reprises. Trois SPAWN,STAT-SCALING,DAMAGE-REDUCTION,ICON-PROVIDER et HUD-BINDINGS existants préservés séparément. Reprise sur source/capture/callsite ou recette/dépendance attribuée,non recensement global répété. Implémentation sous autorisation distincte. next_lot.json vise Zac,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_yorick_passive_vfx_20261106` :evidence_review_corrected.json fait autorité,original30/31 conservé,transition Yasuo,sources/goules,fenêtres,témoins,cohérence,corrections,journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés.

Une unité Yorick de liaison close,zéro nouvelle clôture Yasuo ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
