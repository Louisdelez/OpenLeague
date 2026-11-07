# SYS-01.2-02 — V1300 Xin Zhao : Challenge, armure et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-XINZHAO-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-XinZhao-PASSIF-PRESENTATION-HUD`, exigence `OLF-9cf7d4ab-81b8-5201-998b-bcddd2f8dac0`, inconnue `OLU-77e89d66-250f-5493-be31-f3cf78d511cb`. Audit documentaire borné terminé ; six contrats/questions conservés, HUD a_faire, implémentation/acceptation false. NETWORK reste ouvert. D06/D06-CH-XinZhao et prérequis dans phase_package_prerequisites.json ; aucune acceptation présumée. Parent SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Plan/UI/bases/registres/goal/produit conservés.

## 2. Sources et provenance native

[V652](reference_requirement_trace_sources/xinzhao-passive-challenge-links-v652.json),2794023octets/SHA `84fca0a5015a0defbb11b5095559726a3c57bdfa2da227fee26f30575acaeffe`, UTC hérité `2026-10-27T02:27:48.989165+00:00`. SOURCE17relations/14IDs :6INIBIN,3Lua,3preload,DDF,font ; memberships concordants. Découverte49sources :17INI/17Lua/13preload/DDF/font,22références communautaires. Neuf exclusions précisées : cinq configurations bots et quatre recommandations d’objets.

XinZhao.inibin2756octets/SHA `6a60a99dda517418b3dbdb36b1997e570cfcff938cb7df8b4d8d1c1282f5d58a` : alias XenZhaoPuncture, icône XinZhao_TirelessWarrior.dds. Passive1/Level1..6 null, pas zéro. Passive1Desc contient une ancienne phrase de MasterYi : anomalie conservée, règle non adoptée. Les clés exactes de nom/description donnent Challenge.

Font miroir exact :4489/4313/2946/2953 ; texte15% d’armure pendant3secondes, une cible, attaque ou Audacious Charge. BattleCryPassive2940 décrit le soin de troisième attaque du W, distinct. DDF ne peuple que Q/R (1,25AD/1,0bonusAD), sans producteur de Challenge.

CharScript56octets vide ; Puncture195 et Intimidate163 déclarent textures/BuffName. XenZhaoIntimidate.luaobj déclare XinZhaoIntimidate ; l’INIBIN s’écrit XinZhaoIntimidate. Graphies conservées. PersistsThroughDeath/preloads/particule déclarée ne prouvent pas lifecycle/rendu. Les17Lua sont entièrement consommés, sans fonction enfant,13limites NEWTABLE maintenues ; C# communautaire vide/simplifié sans producteur qualifié.

resource_provenance : deux DDS exacts, sélection E avant lectures SOURCE,4352octets au total,64×64 DXT1/mip1. Propre Info membre0.0.0.40, partagé Icons2D membre0.0.0.111 ;2176octets chacun, même SHA `c629b1cd3a0544f0e3a587c93c76f57e7faee596672942b0720f29f7640ff679`. Taille/MD5/en-têtes concordent au manifeste0.0.1.7. Aucune métadonnée native relue ; priorité de montage/GPU ouverte.

## 3. Consommateurs actuels

28ancres sur13fichiers hérités ;36fichiers code/configuration examinés,16communs et24identités V652 inchangés. Routes : command→advance_attacks→basic_attack_hit→apply_damage→penetrated_defenses/mitigate ; progression.stats et shop.bonuses fournissent armure/AD. Régénération avant attaques dans lib.rs. Ces chemins génériques sont présents.

Barre Mana et MPStat existent dans native_hud_bars.rs/native_hud_widgets.rs ; provenance des ressources communautaires distincte du natif. Aucun hook XinZhao/XenZhao/TirelessWarrior/particule nommé trouvé dans les seuls fichiers Rust examinés ; pas d’absence universelle déduite. Aucun binding Challenge source/cible, état ou texte qualifié. Profil natif de mêlée ; MissileSpeed20 reste une métadonnée, sans projectile démontré.

## 4. Attendu, observé et vérifications

138/138 contrôles documentaires,122/122 en seconde passe séparée du même agent. Six archives3822322octets, RUN JSON intégral identique à OBS, BUILD/RUN0 hérités. Binaire6059520octets/SHA `ff455a74a110ebb1eb79e0ad7c453207359e1e5e5dde6ea3c4add002a6045a4e` hérité, non relu/rejoué ;1158dépendances non requalifiées. Aucun nouveau build,jeu,VM native,REA,réseau/GPU.

Quatre cas : Xin Zhao1/18, Annie18, avec/sans achat public1029. Six attributions XP diagnostiques ; huit Move/Stop arrivent <1, sans reprise. Achat300, solde825→525, armure cible87,22000122070312→102,22000122070312 ; contrôles sans objet restent à825/87,22000122070312. Inventaires et PV conservés à l’achat.

366paires brutes PV/armure, dont douze impacts de mêlée, recalculées exactement avec ordre/arrondis f32 et plafond de régénération avant dégâts. AD57,5439987/113,6439972 ; physique moteur sans/avec objet30,7360325/28,4561348 au niveau1 et60,7007790/56,1981964 au niveau18. La formule du collecteur diffère parfois d’un ULP ; tolérance0,004 respectée, PV exacts expliqués. L’objet réduit effectivement les dégâts à AD constant.

Trois windups non critiques par cas, deuxième impact45/31ticks après le premier (<90). Armure inchangée avant/après toutes les frames. Comparateur « armure totale×0,85 » explicitement diagnostique, sans ordre natif accepté.

Vingt snapshots après combat aux offsets0/89/90/91/95 : armure inchangée, PV expliqués par régénération. Les380ticks intermédiaires sont reconstruits, sans toutes leurs frames brutes.108refus avec flags snapshot_unchanged, sans tous les snapshots individuels ;8334ticks totaux, aucun décès/victoire. Pas d’injection directe.

## 5. Écarts et anomalies conservés

Une fenêtre95ticks sans activation ne vérifie pas l’expiration native à3secondes. Premier impact, base/bonus d’armure, autres réductions/pénétrations, arrondis/armure négative, renouvellement/transfert, plusieurs lanceurs et lifecycle restent ouverts. E,autres catégories de cibles,réseau/rendu non exercés.

V652 décrit un premier refus d’inspection : pub fn au lieu de pub(crate) fn penetrated_defenses. Le script anchorchecked capturé contient l’ancre réelle ; script/erreur bruts avant correction non récupérés ici. Aucune réparation du moteur déduite. Identité DDS ne prouve pas montage/HUD.

## 6. Corrections et conditions de reprise

- `COR-XINZHAO-CHALLENGE-POLICY-01` : qualifier ordre du premier impact, armure admissible et interactions sur source versionnée ; finir avec contrat et limites explicites.
- `COR-XINZHAO-ARMOR-MODIFIER-01` : relier déclenchement ordinaire à la réduction qualifiée ; vérifier armure/PV et témoins1029 en conservant mitigation/pénétration.
- `COR-XINZHAO-CHALLENGE-TARGET-STATE-01` : produire cible unique, renouvellement et expiration ; vérifier activation avant90ticks, transfert et lifecycle selon contrat.
- `COR-XINZHAO-CHALLENGE-E-TRIGGER-01` : relier E accepté au même état autoritaire ; vérifier succès,refus et cible sans substituer le W.
- `COR-XINZHAO-ICON-PROVIDER-PATH-01` : qualifier montage des deux chemins et graphies Xin/Xen sur preuve ; pas de renommage arbitraire.
- `COR-XINZHAO-HUD-BINDINGS-01` : relier icône,source/cible,texte et durée à cet état ; vérifier rendu/transitions et conserver MPStat.

Reprendre sur nouvelle source, consommateur modifié ou vérification nécessaire autorisée. Prochain candidat : Yasuo.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF publiables ; octets antérieurs archivés, sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_xinzhao_passive_hud_20261105 :evidence_review/coherence_review,captures,journaux,result/publication/postpublication. Journaux Python instrumentés seulement, contexte/dispatch/empaquetage exclus, sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2287entrées sales groupées conservées. Aucune tâche complète,feature,inconnue ou acceptation close ; relecture du même agent, sans acceptation indépendante/humaine.
