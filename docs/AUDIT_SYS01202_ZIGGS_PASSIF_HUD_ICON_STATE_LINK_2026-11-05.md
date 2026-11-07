# SYS-01.2-02 — V1305 Ziggs : Short Fuse, disponibilité, recharge et icône

## 1. Périmètre et prérequis

2026-11-05,F:/OpenLeague. Unité `AUD-SYS-01.2-02-ZIGGS-PASSIF-HUD-ICON-STATE-LINK-01`,tâche `CH-Ziggs-PASSIF-PRESENTATION-HUD`,exigence `OLF-b6624676-f84b-50e6-8751-439aefd7c988`,inconnue `OLU-3938f46a-4f5f-5cb2-b222-39e30638c206`. Audit documentaire borné du lien HUD terminé ;six contrats/questions conservés,HUD a_faire,implémentation/acceptation false,NETWORK ouvert. D06/D06-CH-Ziggs,prérequis dans phase_package_prerequisites.json,sans acceptation présumée. Parent SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Goal/Plan/UI/bases/registres/produit conservés.

## 2. Sources et provenance native

[V656](reference_requirement_trace_sources/ziggs-passive-short_fuse-links-v656.json),5206685octets/SHA `4b36a42ed640a6d42ec668fffd9a29202f10f2429b121f32d2f9ba2e01fe0087`,UTC hérité `2026-10-27T03:46:09.757396+00:00`. SOURCE16relations/14IDs :5INIBIN,5Lua,3preload,font. Memberships conservés concordants. Ziggs.inibin2415octets/SHA `75b525f7279444d9f630c9c0d7f5e386f12ed6605e295ff58f955cd3cdbc2d0a` :ZiggsPassiveBuff/ZiggsPassiveReady.dds ;Passive1/Desc/Level1..6 null,pas zéro.

Neuf liaisons font miroir exact :4495/4319/3001–3003/9970/10700/11367/12061. Texte12secondes,réduction4secondes par compétence,150%sur structures,@f1@(+@f2@). Deux PLACEHOLDER préservés. Aucun fichier ShortFuseCooldown correspondant ni DDF dans le seul périmètre découvert ;aucune absence globale affirmée.

29Lua entièrement consommés,sans fonctions enfants,17limites NEWTABLE. CharScript56vide ;PassiveAttack499/PassiveBuff416/ShortFuse710 contiennent des constantes,bombes/attaches/skins,persistance ;leurs globals n’ont pas été interprétés avec succès. Pas de callback serveur qualifié. BuffData reste distinct du SpellData Disintegrate/ZiggsW et de cinq Effect1=12 ;aucune formule du passif adoptée. Preload apbonusdamagetotowers conservé comme dépendance distincte.

resource_provenance :DDS propre DATA/Characters/Ziggs/Info/ZiggsPassiveReady.dds et partagé DATA/Spells/Icons2D/ZiggsPassiveReady.dds,2176octets chacun,64×64 DXT1/mip1,membre0.0.0.71,même SHA `22eef7e15b6bf77e05d0c0b4e565914f87d07b2d35b932ec0022863b6509171d`. Taille/MD5/en-têtes concordent au manifeste0.0.1.7. Propre lu SOURCE après sélection E ;partagé réutilisé du lot Zed avec chemin/identité vérifiés,sans nouveau Dstat/read. Métadonnées natives non relues ;montage/priorité/pixels/GPU ouverts.

## 3. Consommateurs actuels

26ancres sur12fichiers hérités ;34fichiers code/configuration,16communs et22identités V656 inchangés. Routes commande→windup→projectile→basic_attack_hit→apply_damage,armure/mitigation,régénération,boutique/AP présentes. L’ordre réel est AnnieQ→régénération→attaques ordinaires.

Aucun hook Ziggs/ShortFuse dans les seuls fichiers Rust examinés. HP/Mana HUD existant,ressource locale Mana conservée ;ni icône prête/recharge ni f1/f2 ne sont reliés à un état autoritaire Short Fuse. La présence du DDS ne prouve pas ce binding. Chargeur/statistiques/AnnieQ ne sont pas promus producteurs du passif.

## 4. Attendu, observé et vérifications

162/162 contrôles documentaires,128/128 cohérence séparée du même agent. Sept archives5515259octets,RUN JSON intégral identique à OBS. BUILD/RUN0 corrigés hérités ;premier BUILD0/RustRUN101 et enveloppe1 conservés. Diff des deux collecteurs archivée :erreur de clamp corrigée côté diagnostic,sans changer le moteur. Binaire corrigé6094848octets/SHA `0dad4a3ab220a06e57d336f7e5c07d6a5590e4a94f33af96b934d04657243d94`,ancien6086144/b80ecbb6… hérités,non relus/rejoués ;1158entrées non requalifiées.

Quatre cas Ziggs1/18×AP0/20 contre Annie18 :douze résumés d’impacts ordinaires,reliés chacun au windup/projectile/impact ;physique moteur28,9541721/57,1028786,respectivement. La formule du collecteur diffère d’un ULP au niveau1,écart expliqué en f32. Aucun supplément magique observé. **Aucune paire PV brute pré/post-impact dans ces douze résumés** ;endpoints reconstruits depuis start/régénération/impacts,comparés aux douze snapshots359/360/361 et aux quatre endpoints finaux. Pas toutes les frames.

Impacts relatifs0/46/380 au niveau1,0/34/378 au niveau18. Sans proc initial,attendre360ticks ne qualifie pas l’expiration native. Sorts Ziggs refusés :aucune réduction4s exercée. Structures non testées.

Deux contrôles publics AnnieQ distincts,AP0/20 :80/96bruts,coût60,libération8ticks,recharge120ticks. Deux paires PV brutes avant/final recalculées avec dégâts avant régénération :1884,4000244→1822,9713135/1810,6635742. Le calcul initial pré-plafonné diffère d’environ0,10974PV. Ces contrôles ne valident ni Short Fuse ni Annie complète.

118refus publics par flags d’invariance,sans toutes les paires de snapshots ;12arrivées Move/Stop sans reprise,huit attributions XP diagnostiques,trois achats publics1052 (435or,20AP). 13272ticks=2×2341+2×2337+2×1958,sans autant de frames brutes.

## 5. Écarts et limites

Restent f1/f2,paliers/AP,cibles/structures,ordre et consommation lancement/impact,disponibilité initiale,recharge et réduction par chaque compétence/toggle/plancher,annulation,critique,blocage,boucliers,mort/reconnexion. HUD,particules,animations,audio/réseau restent distincts. Invocation dds01 rejetée code2 pour rôle SOURCE avant installation du journal/script ;dds02 source réussit,originaux conservés. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

## 6. Corrections et conditions de reprise

- `COR-ZIGGS-NATIVE-PASSIVE-POLICY-01` :qualifier f1/f2,niveaux/AP,cibles,ordre et exceptions sur source versionnée ;garder les inconnues.
- `COR-ZIGGS-MAGICAL-ONHIT-01` :relier impact admissible et bonus qualifié ;vérifier paires PV,mitigation et témoins physiques/Annie sans substitution.
- `COR-ZIGGS-READINESS-CD-01` :produire disponibilité/consommation/recharge12s ;vérifier d’abord un proc,puis359/360/361,annulation et lifecycle.
- `COR-ZIGGS-ABILITY-CD-REDUCTION-01` :relier chaque événement de compétence qualifié à la réduction4s/plancher ;vérifier Q/W/E/R séparément,refus sans réduction.
- `COR-ZIGGS-STRUCTURE-DAMAGE-01` :qualifier150% par catégorie et interaction APdes tours ;vérifier structures et témoins non-structures.
- `COR-ZIGGS-ICON-PROVIDER-PATH-01` :établir montage/sélection Info/partagé et état affiché ;vérifier chemin exact sans corruption supposée.
- `COR-ZIGGS-HUD-BINDINGS-01` :lier f1/f2,icône/tooltip prêt-recharge à l’état autoritaire ;vérifier transitions/rendu en préservant HP/Mana.

Reprendre sur nouvelle source,consommateur modifié ou contrôle nécessaire autorisé. Prochain candidat :Zilean.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF ;octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_ziggs_passive_hud_20261105 :evidence_review,coherence_review,invocation_qualification,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2292entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ;même agent,sans acceptation indépendante/humaine.
