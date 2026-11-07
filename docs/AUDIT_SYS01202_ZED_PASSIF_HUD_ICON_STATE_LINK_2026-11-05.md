# SYS-01.2-02 — V1304 Zed : Contempt for the Weak, seuil et récupération par cible

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-ZED-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Zed-PASSIF-PRESENTATION-HUD`, exigence `OLF-df112f41-406a-584e-8c23-e3430a15a59f`, inconnue `OLU-a41c2111-4010-5b1f-a410-a12214c03f4d`. Audit documentaire borné du lien HUD terminé ; six contrats/questions conservés, HUD a_faire, implémentation/acceptation false, NETWORK ouvert. D06/D06-CH-Zed et prérequis dans phase_package_prerequisites.json, sans acceptation présumée. Parent SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Plan/UI/bases/registres/goal/produit conservés.

## 2. Sources et provenance native

[V655](reference_requirement_trace_sources/zed-passive-contempt-links-v655.json),3289727octets/SHA `022a8305ff1b4c992b73e0cde26b15006c0aded462831fbb207d72fafd31be8f`, UTC hérité `2026-10-27T03:25:08.172512+00:00`. SOURCE22relations/16IDs :5INIBIN,7Lua,2preload,DDF,font ; memberships conservés concordants. Zed.inibin2028octets/SHA `0fa7bf92de960df7d36cfb257b779c7527e25bf8be4ba73db213d27352ac0d5c` : alias ZedPassiveToolTip,icône shadowninja_P.dds ; Passive1/Desc/Level1..6 null,pas zéro.

Font miroir exact :4494/4318/2988/2987. Texte : attaques sur cible sous50%PV,bonus magique6–10%PVmax,@f1@,une fois par cible toutes10secondes. CD2987 décrit le marqueur de la cible affectée. Strength of the Shadow2996 appartient au W/bonusAD,distinct. DDF conserve des lignes Akali et des coefficients QWER Zed,sans qualification de la formule du passif ou des paliers de niveau.

49Lua entièrement consommés,sans fonction enfant,12limites NEWTABLE maintenues. CharScript56 vide ; ToolTip135 déclare BuffName/persistance,CD148 BuffName/texture ; Passive225 déclare AkaliTwinDisciplines et effet Zed_Passive_Stage1. NewPassive/NewPassive2,112octets chacun,déclarent ZiggsPassiveReady. Ces alternatives ne démontrent ni callback,ni activation,ni priorité d’alias.

resource_provenance : trois DDS sélectionnés E avant lectures SOURCE,7920octets,64×64 DXT1. Propre ShadowNinja_P2872/mip7,membre0.0.0.134,SHA `5c48281ec3b4d3f12bfbcd72156d7d1801252819744fa9ac26cbbd8c464b2ce7` ; partagé AkaliTwinDisciplines2872/mip7,membre0.0.0.25,SHA `3664dcefd028ccb3993d4d257337d1bb8feb49cfdeb338e95906e7a1a9bdd300` ; partagé ZiggsPassiveReady2176/mip1,membre0.0.0.71,SHA `22eef7e15b6bf77e05d0c0b4e565914f87d07b2d35b932ec0022863b6509171d`. Taille/MD5/en-têtes concordants au manifeste0.0.1.7. Graphies shadowninja_P/ShadowNinja_P conservées. Alias Akali/Info,ZedShadow/HUD,Ziggs/Info restent manifeste seulement. Métadonnées natives non relues ; montage/pixels/GPU ouverts.

## 3. Consommateurs actuels

26ancres sur12fichiers hérités ;33fichiers code/configuration,16communs et21identités V655 inchangés. Routes command→advance_attacks→basic_attack_hit→apply_damage,penetrated_defenses/mitigate ; progression.stats et regeneration avant attaques. healing::heal reste présent pour le préparateur diagnostique.

Aucun hook Zed/Contempt dans les seuls fichiers Rust examinés ; pas d’absence universelle affirmée. HPBar/HPStat consomment les PV réels. Ressource locale Energy,qui n’alimente pas les éléments Mana actuels ; cette dépendance ne valide pas le HUD complet. Aucun binding qualifié du bonus f1,de la disponibilité ou du marqueur CD par cible. Les textures présentes ne remplacent pas ces états.

## 4. Attendu, observé et vérifications

142/142 contrôles documentaires,175/175 cohérence séparée du même agent. Cinq archives4722785octets,RUN JSON intégral identique à OBS,BUILD/RUN0 hérités. Binaire6072320octets/SHA `e580595bc1b87ab5f6010e531f0c7f44d8fe269e5dee1c1624f854f9b0ef1d83` hérité,non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

Six cas : Zed1/18 contre Annie18,ratios initiaux60/50/40%. Neuf attributions XP,huit préparations PV par API serveur,explicites ; aucune injection de champ direct. Douze trajets Move/Stop arrivent <1,sans reprise. Préparations before/wanted/after et événements recalculés ; elles ne sont pas des attaques ennemies naturelles.

Dix-huit paires PV d’impacts ordinaires non critiques recalculées en f32 : avant tick→après régénération→après physique. AD54,7120018/112,5120087,armure cible87,2200012 ; physique29,2233753/60,0961494,tolérance0,004. Aucun bonus magique observé. Dans les deux cas50%,la préparation juste avant libération compense la régénération : **PV exactement901,8399658203125 après régénération,avant dégâts physiques**,et PV du début de tick inférieurs à la moitié. Cela ne détermine pas l’ordre du prédicat natif.

Impacts suivants relatifs46/312ticks au niveau1,30/309 au niveau18. Dix-huit snapshots de fenêtre299/300/301ticks,pour une horloge locale30ticks/s,retrouvés par reconstruction entre points conservés. Aucun proc initial n’ayant été qualifié,ces relevés ne prouvent pas l’expiration d’un cooldown du passif. Les intervalles intermédiaires ne sont pas des frames brutes.

Six paires PV supplémentaires : API magique20,sans avance du tick,post-mitigation15,3846158981,variation PV15,3846435547 à cause du f32 ; contrôle distinct du passif. Les comparateurs6–10%PVmax après RM sont diagnostiques,sans paliers/ordre natifs acceptés.162refus publics et18refus API par flags d’invariance,sans tous les snapshots individuels.13362ticks =3×2230+3×2224 ;pas toutes les frames.

## 5. Écarts et limites

f1,paliers,ordre seuil/régénération/physique/magique,cible à égalité,catégories non-champion,exceptions et règles plusieurs Zed restent ouverts. Manquent producteur du bonus,activation et récupération par cible,transfert/changement de cible,mort/reconnexion et bindings HUD. Ni absence d’effet après300ticks,ni contrôle magique API,ni texture CD ne valide la mécanique. Aucun échec nouveau dans les producteurs de ce lot.

## 6. Corrections et conditions de reprise

- `COR-ZED-NATIVE-PASSIVE-POLICY-01` : qualifier f1,paliers,point exact d’évaluation,catégories et ordre sur source versionnée ; conserver les inconnues.
- `COR-ZED-MAGICAL-ONHIT-01` : relier l’impact admissible au bonus qualifié ; vérifier paires PV et témoins physiques/API sans confondre W.
- `COR-ZED-PER-TARGET-CD-01` : produire activation/recharge10secondes et propriété selon politique qualifiée ; vérifier d’abord un proc,puis299/300/301,transfert et plusieurs lanceurs.
- `COR-ZED-TARGET-CD-HUD-01` : relier ZedPassiveCD à la cible et à la source qualifiées ; vérifier apparition,retrait et source affichée.
- `COR-ZED-ICON-PROVIDER-PATH-01` : établir sélection et montage entre ShadowNinja/Akali/Ziggs,avec graphies exactes,sans substitution arbitraire.
- `COR-ZED-HUD-BINDINGS-01` : relier icône/tooltip f1 à l’état autoritaire et au niveau ; vérifier rendu/transitions en conservant HP et la dépendance Energy distincte.

Reprendre sur nouvelle source,consommateur modifié ou vérification nécessaire autorisée. Prochain candidat : Ziggs.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_zed_passive_hud_20261105 :evidence_review,cohérence,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2291entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ; même agent,sans acceptation indépendante/humaine.
