# SYS-01.2-02 — V1303 Zac : Cell Division, fragments, renaissance et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-ZAC-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Zac-PASSIF-PRESENTATION-HUD`, exigence `OLF-1261ca21-c4cc-521e-9b2b-7859ee2e0d1f`, inconnue `OLU-a2e863a2-67cb-5028-82a9-15fe0f00d130`. Audit documentaire borné du lien HUD terminé ; six contrats/questions conservés, HUD a_faire, implémentation/acceptation false, NETWORK ouvert. D06/D06-CH-Zac et prérequis dans phase_package_prerequisites.json, sans acceptation présumée. Parent SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Plan/UI/bases/registres/goal/produit conservés.

## 2. Sources et provenance native

[V654](reference_requirement_trace_sources/zac-passive-cell-division-links-v654.json),2970921octets/SHA `5e92fe49daa21e039fdde16f8b72fa06951c86e166e3225b4bd4234cd1311960`, UTC hérité `2026-10-27T03:06:42.449240+00:00`. SOURCE45relations/39IDs :8INIBIN,15Lua,14preload,DDF,font ; memberships conservés concordants. Suivi des personnages ZacRebirthBloblet et TestCubeRender10Vision réutilisé, skins distinctes non promues en producteurs.

Zac.inibin1752octets/SHA `1d9956957570def9ed28850d06007b010d21fa571dd9ac982487dbe358bd2d13` : alias ZacPassiveChunkDrop,icône ZacPassive.dds. Passive1Desc parle de Jax : anomalie conservée, sans autorité mécanique. Valeurs brutes Passive1/Level1..6 :9/3/7/11/15/null/null, sans formule passive déduite.

29Lua entièrement consommés,sans fonction enfant ; deux limites NEWTABLE. CharScript56octets vide,ChunkDrop186,SpawnChunk56. Rebirth237 déclare texture Cryophoenix_Rebirth_Charging,PersistsThroughDeath et OnPreDamagePriority4 ; Active105,Blob56,Cooldown193,Ready182 sont métadonnées, sans callbacks démontrés. DDF sans liaison peuplée.

Font miroir exact :4493/4317/2978/2980/2981/2982/2983. Texte : fragment après impact d’une capacité,soin4%PVmax,@f1@ ; dégâts fatals→4bloblets,8secondes,reprise10–50%PV selon survivants,chaque bloblet12%PVmax et50%armure/RM,cooldown5minutes. Producteurs f1,disponibilité et formule de recombinaison restent inconnus. Le preload du fragment mène à TestCubeRender10Vision,celui de renaissance à ZacRebirthBloblet ; sa base1PV n’est pas la statistique finale12%.

resource_provenance : trois DDS sélectionnés E avant lectures SOURCE,9272octets,64×64. Propre ZacPassive2176 DXT1/mip0,SHA db39a6a61468eb15040778657e1634138b267080d3cb18bfacb63e631f170ab1 ; Inactive2872 DXT1/mip7,SHA32ef628d0c995886b3ebe251af4e8b2b6cefb5e3dfbf3392faa0597aba4e3d2e,membres0.0.0.155. Charging partagé4224 DXT5/mip1,SHA430c2239f929302bef757df8d824952cc29d60cf6faa1a9aadf968f6bd526201,membre0.0.0.107. Taille/MD5/en-têtes concordants au manifeste0.0.1.7. Métadonnées natives non relues ; montage/pixels/GPU ouverts.

## 3. Consommateurs actuels

28ancres sur13fichiers hérités ;34fichiers code/configuration plus native_hud_respawn.rs,16communs et22identités V654 inchangés. damage::apply_damage,healing::heal,regeneration et lifecycle expliquent soins,décès et réapparitions ordinaires. map10_world ne contient aucune clé Zac/blob/TestCube ; aucun hook Zac/CellDivision/Rebirth dans les seuls fichiers Rust examinés,pas d’absence universelle affirmée.

HPBar/HPStat existants ; ressource locale None,donc pas d’alimentation des éléments Mana. native_hud_widgets appelle native_hud_respawn::countdown : fonction pub(crate),garde joueur mort fini,respawn_at.saturating_sub,ticks arrondis à la seconde supérieure. La visibilité vérifie aussi connexion/session et fin de partie. Source4926octets/SHA9679823839140de95f06d109890ee970fe02e5c454360a2a2ff9c63e08e2892e. Calculs de compteur dérivés des snapshots seulement ; aucune fonction Rust extraite ni scène Bevy exécutée. Ce chemin ne constitue pas un état Cell Division.

## 4. Attendu, observé et vérifications

148/148 contrôles récupérés,147/147 cohérence séparée du même agent. Six archives3752729octets,RUN JSON intégral identique à OBS,BUILD/RUN0 hérités. Binaire6098944octets/SHA `611f4c2643a27814789b1b0758bf5e1fd985d888e98b144c4e032e0ba2cfef24` hérité,non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

Quatre cas Zac/Annie niveaux1/18,quatre Move arrivés sans reprise,deux attributions XP diagnostiques. API serveur :100dégâts bruts puis40soin,endpoint combiné vérifié ; pas de snapshots intermédiaires séparés pour chacune de ces deux actions.120paires PV brutes de régénération (30/cas) recalculées exactement en f32. Quatre paires de plafonnement :100000 demandés,restauration égale au déficit,PV au maximum avant le premier dommage fatal. Ce soin API ne prouve pas un ramassage4%.

Huit paires PV avant/après dommage fatal API,64snapshots de décès/réapparition. Échantillons0/1/239/240/241/délai−1/délai/délai+1 : aucun blob,PV0 à240ticks,retour au spawn et PVmax après480ticks niveau1 ou1110 niveau18,comme Annie. Aucun état de disponibilité natif qualifié ; ces observations ne concluent pas sur tous les cas de renaissance historique.

72refus publics :24sorts Zac vivant,48commandes mort ;36refus API :20soins invalides,16soins/dégâts sur morts. Invariance sous forme de flags,sans tous les snapshots individuels.10384ticks =1966+3226+1966+3226,sans toutes les frames. Aucun impact de capacité ou ramassage de fragment exécuté.

## 5. Écarts et contrôles corrigés

Premier générateur interrompu par un set non sérialisable JSON : fichier partiel conservé,reprise sur seules captures déjà retenues,préfixe sérialisé original intégralement identique,zéro relecture matérielle F/D dans cette reprise. Liste triée des deux rôles remplace la représentation set,sans affaiblir l’attendu. Premier relevé du compteur cherchait pub fn au lieu de pub(crate) fn : corrigé sur capture E,sans relecture F. Deux codes1/journaux conservés ; aucun changement du produit.

Fragments,récolte,bloblets,disponibilité,cooldown,recombinaison,données répliquées et HUD spécifique restent ouverts. Réapparition normale,soin API et texte client ne valent pas renaissance native acceptée.

## 6. Corrections et conditions de reprise

- `COR-ZAC-CHUNK-POLICY-01` : qualifier impact admissible,production/éligibilité du fragment et f1 sur source versionnée ; garder les inconnues.
- `COR-ZAC-CHUNK-SPAWN-01` : produire un fragment possédé après déclencheur qualifié ; vérifier apparition,limites et expiration.
- `COR-ZAC-CHUNK-PICKUP-01` : relier ramassage au soin qualifié ; vérifier portée,refus et plafond avec paires PV.
- `COR-ZAC-REBIRTH-READINESS-01` : produire disponibilité/consommation/recharge5minutes et politique de mort ; vérifier transitions sans remplacer arbitrairement lifecycle.
- `COR-ZAC-REBIRTH-BLOBLETS-01` : créer les quatre unités/attributs qualifiés ; vérifier propriété,dommages et destruction,sans adopter base1PV.
- `COR-ZAC-REBIRTH-RECOMBINATION-01` : qualifier puis produire règle8secondes/PV survivants ; vérifier0/1/plusieurs survivants et échec complet.
- `COR-ZAC-ICON-PROVIDER-PATH-01` : qualifier montage des trois variantes et alias,sans substitution.
- `COR-ZAC-HUD-PASSIVE-STATES-01` : relier icônes,disponibilité,recharge et reconstruction à l’état autoritaire ; vérifier transitions/rendu,en conservant HP et compteur normal.

Reprendre sur nouvelle source,consommateur modifié ou vérification nécessaire autorisée. Prochain candidat : Zed.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés contrôlés avant/après. Preuves E:/mapslol3v3/audit_sys01202_zac_passive_hud_20261105 :evidence_review partiel/recovered,qualification,respawn_consumer,cohérence,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2290entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ; même agent,sans acceptation indépendante/humaine.
