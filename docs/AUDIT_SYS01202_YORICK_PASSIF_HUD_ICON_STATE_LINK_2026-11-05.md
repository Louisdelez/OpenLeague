# SYS-01.2-02 — V1302 Yorick : Unholy Covenant, goules et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-YORICK-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Yorick-PASSIF-PRESENTATION-HUD`, exigence `OLF-dd31b149-e41f-572c-9647-093d65e50dc5`, inconnue `OLU-2b7a2214-6b31-50ad-a828-0bff3cb64280`. Audit documentaire borné du lien HUD terminé ; six contrats/questions conservés, HUD a_faire, implémentation/acceptation false, NETWORK ouvert. D06/D06-CH-Yorick et prérequis dans phase_package_prerequisites.json, sans acceptation présumée. Parent SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Plan/UI/bases/registres/goal/produit conservés.

## 2. Sources et provenance native

[V653](reference_requirement_trace_sources/yorick-passive-unholy-covenant-links-v653.json),3395503octets/SHA `ab8415843c823200d6cfb2b75f0b7f50ef67cd3fce6b0aaf89a4e9d175ab9a71`, UTC hérité `2026-10-27T02:45:55.926130+00:00`. SOURCE33relations/30IDs :13INIBIN,11Lua,4preload,DDF,font ; memberships conservés concordants. Suivi séparé des personnages YorickDecayedGhoul,YorickRavenousGhoul,YorickSpectralGhoul réutilisé ; fichiers homonymes sous DATA/Spells gardés distincts.

Yorick.inibin/SHA d4877b8b58833648e82425135864ccab72a3f2107aa9457bd85678580f1c271c : alias YorickUnholySymbiosis,icône YorickUnholyCovenant.dds. Passive1/Level1..6 null, pas zéro. CharScript56octets vide ; Unholy226 déclare BuffName/texture,PersistsThroughDeath et NonDispellable, sans effet serveur démontré.41Lua entièrement consommés,sans fonction enfant ni limite de littéraux ; quatre CharScript vides.

Font miroir exact : nom4491,description4315 liée par deux champs,tooltip2975. Texte : dégâts d’attaques ordinaires+5% et dégâts reçus-5% par invocation active ; goules à35%AD/PV de Yorick. Catégories,plafond,cumul,statistiques de référence et capture/rafraîchissement restent inconnus. Trois définitions de personnage donnent bases60PV/10AD,croissances0, sans preuve de statistiques finales à35%. DDF E indique1,0bonusAD ; divergence avec AP communautaire conservée. Buff Revenant communautaire et métadonnées R ne prouvent pas une apparition de goule ni une règle de comptage.

resource_provenance : deux DDS sélectionnés sur E avant lectures SOURCE,4352octets au total,2176 chacun,64×64 DXT1/mip1,membre0.0.0.36 pour propre Info et partagé Icons2D. Même SHA `5852ca4ad1449ef76b89be8f96377db56cc01c788ab5bdc32a367cffc02cb5ca` ; taille/MD5/en-têtes concordants au manifeste0.0.1.7. Aucune métadonnée native relue ; priorité de montage,pixels/GPU non qualifiés.

## 3. Consommateurs actuels

32ancres sur13fichiers hérités ;37fichiers code/configuration,16communs et25identités V653 inchangés. Routes réelles : command/advance_attacks/basic_attack_hit/apply_damage,penetrated_defenses/mitigate,progression.stats et regeneration ; régénération avant attaques. Les définitions map10_world ne contiennent aucune clé Yorick/ghoul. Aucun hook Yorick/Unholy dans les seuls fichiers Rust examinés ; aucune absence universelle affirmée.

annie_r::cast_tibbers,advance_annie_r,guide_tibbers,advance_pet_orders et world::spawn_unit existent. Leurs unités Annie ne remplacent pas les goules de Yorick. Les barres HP/Mana et MPStat consomment les snapshots ; ressource locale Mana. Aucun binding qualifié du nombre d’invocations,bonus,réduction,icône ou texte Unholy Covenant.

## 4. Attendu, observé et vérifications

100/100 contrôles documentaires,89/89 cohérence séparée du même agent. Six archives3385721octets,RUN JSON intégral identique à OBS,BUILD/RUN0 hérités. Binaire6074368octets/SHA `0809d39d8485f1fb265b4c77c44c955991fe1013dee0a74079e0692e736cf038` hérité,non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

Deux cas Yorick niveaux1/18 contre Annie18. Quatre Move/Stop arrivent <1,sans reprise. Six attaques de mêlée non critiques à zéro invocation : résumés attendu/observé physiques, sans paires PV brutes pré-impact. AD57,5800018/117,0800018,physique moteur30,7552643/62,5360565,tolérance0,004 respectée.

Six paires PV brutes supplémentaires proviennent explicitement de l’API serveur apply_damage (20physique,20magique,20brut par cas), sans sort ennemi. Recalcul f32 exact des PV,post-mitigation et health_removed. Résultats niveau1 :15,9938574/15,1400452/20 ; niveau18 :10,7383709/13,0420599/20. Zéro bouclier absorbé et zéro invocation. PV finaux des deux acteurs retrouvés par reconstruction des ticks,régénération et impacts ; ces endpoints ne sont pas des frames intermédiaires archivées.

Témoin distinct Annie R rang1 : CastAt public,apparition tick8,1350ticks de vie,1200PV/80AD/30armure,guide Move accepté. Échantillons relatifs1/1349/1350/1351 : propriété1/1/0/0,lookup Tibbers22/22/None/None. L’objet unité reste présent avec0PV après expiration : aucune suppression mémoire déduite. Guidage accepté ne qualifie pas toute la trajectoire.

57refus avec flags snapshot_unchanged (54Yorick,3Tibbers),sans tous les snapshots bruts individuels. Quatre attributions XP diagnostiques ;5542ticks =2109+2074+1359,sans toutes les frames. Aucun échec nouveau dans les producteurs de ce lot.

## 5. Écarts et limites

Zéro invocation ne teste ni le bonus5%,ni la réduction5%,ni les statistiques35%,ni la création/cycle de vie des trois goules ou du Revenant. Les six impacts restent des résumés ; les six paires API ne deviennent pas des attaques ennemies. Tibbers est un témoin du système courant de familiers, sans acceptation native ou Yorick. Comptage/rafraîchissement,cumul,ordre des modificateurs,mort/réapparition,rendu,réseau et acceptation restent ouverts.

## 6. Corrections et conditions de reprise

- `COR-YORICK-COUNT-POLICY-01` : qualifier catégories admissibles,goules/Revenant,plafond et cumul sur source versionnée ; finir avec contrat et inconnues explicites.
- `COR-YORICK-DECAYED-SPAWN-01` : relier le déclencheur qualifié à une DecayedGhoul possédée ; vérifier apparition,refus et fin de vie.
- `COR-YORICK-RAVENOUS-SPAWN-01` : même objectif et contrôles pour RavenousGhoul,avec preuve propre.
- `COR-YORICK-SPECTRAL-SPAWN-01` : même objectif et contrôles pour SpectralGhoul,avec preuve propre.
- `COR-YORICK-GHOUL-STAT-SCALING-01` : produire AD/PV depuis la référence35% qualifiée ; vérifier chaque type,niveau,capture/rafraîchissement sans adopter les bases60/10 comme résultat final.
- `COR-YORICK-ATTACK-BONUS-01` : relier compte admissible au bonus d’attaque ; vérifier0/1/plusieurs et retraits avec paires PV.
- `COR-YORICK-DAMAGE-REDUCTION-01` : relier compte à la réduction qualifiée ; vérifier types/ordre et témoins sans invocation.
- `COR-YORICK-ICON-PROVIDER-PATH-01` : établir montage effectif des variantes,sans substitution arbitraire.
- `COR-YORICK-HUD-BINDINGS-01` : relier compte,statistiques,icône et texte à l’état autoritaire ; vérifier transitions/rendu en conservant HP/Mana.

Reprendre sur nouvelle source,consommateur modifié ou vérification nécessaire autorisée. Prochain candidat : Zac.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés contrôlés avant/après. Preuves E:/mapslol3v3/audit_sys01202_yorick_passive_hud_20261105 :evidence_review,cohérence,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2289entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ; même agent,sans acceptation indépendante/humaine.
