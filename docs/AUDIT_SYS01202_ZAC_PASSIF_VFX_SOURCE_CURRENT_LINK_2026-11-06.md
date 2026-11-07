# SYS-01.2-02 — Zac : Cell Division et consommateurs VFX, V1429

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-ZAC-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Zac-PASSIF-PRESENTATION-VFX`, `OLF-f75cd83c-e146-5f1b-96b9-bf8aed1b4ed9` : relier fragments,renaissance et effets déclarés aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues dans initial_scope.json. V654/HUD V1303 et corrections conservés. Liaison close ne termine ni passif,QWER,fonctionnalité ou goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus,catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/zac-passive-cell-division-links-v654.json`,2970921octets,SHA `5e92fe49daa21e039fdde16f8b72fa06951c86e166e3225b4bd4234cd1311960`,UTC hérité2026-10-27T03:06:42.449240+00:00. Copies E retenues ;aucun accès renouvelé D ou F/OpenLeague-work.

39sources primaires :8INIBIN,15Lua,14preloads,DDF,font ;26identités liées non promues. Définition1752octets/SHA `1d9956957570def9ed28850d06007b010d21fa571dd9ac982487dbe358bd2d13` :ZacPassiveChunkDrop/ZacPassive.dds. Texte Jax anomal conservé ;Passive1/Level1..6=9/3/7/11/15/null/null,non formule passive.

29vues Lua héritées,consommées entièrement antérieurement,zéro prototype enfant ;27littérales,22globals,deux limites NEWTABLE(E/W). CharScript,SpawnChunk,RebirthBlob,RespawnAnimation56 vides. ChunkDrop186 persistant ;Rebirth237 déclare icône Cryophoenix_Rebirth_Charging,persistance et priorité4,non callback. Active105/Cooldown193/Ready182 distinguent icônes normale/inactive/normale. Aucun AutoBuff reconnu ne prouve l’absence d’effets.

Font4493/4317/2978/2980/2981/2982/2983 :impact d’une capacité→fragment,soin4%PVmax,@f1@ ;fatal→quatre bloblets,huit secondes,retour10–50%PV selon survivants,bloblet12%PVmax/50%armure-RM,recharge5minutes. f1,disponibilité et recombinaison restent inconnus. DDF28lignes sans liaison peuplée. Font contrôlée par identité,sans reparcours sémantique.

14preloads,4882octets,66appels littéraux relus depuis découverte. SpawnChunk161→TestCubeRender10Vision et WGooMove ;WGooMove1434 contient19déclarations,dont18particules :chunk,heal,timeout,death,splat,son et variantes base/skin1/ot. Rebirth92→Start158→Immunity95/Active305 ;Active nomme zacpassiveexplosion.troy,ZacRebirthBloblet,RebirthBlob et zac_rebirth_sound.troy. Ready177 déclare zac_rebirthready.troy et variante_skn1. Cooldown/Immunity/Blob décrivent aussi des dépendances. Déclarations distinctes de sélection,création,owner,attache et horloge ;pas de recette complète qualifiée. Textes/identités entiers dans evidence_review_corrected.json.

Deux définitions de personnages distinctes,deux skins conservées hors producteurs. ZacRebirthBloblet1769/SHAca494ec2 :base1PV non12%final ;TestCubeRender10Vision458 n’est pas un bloblet de renaissance. Provenances complètes réutilisées,sans confondre caractères et skins.

Trois DDS relus dans E,64×64,9272octets :ZacPassive2176/DXT1/mip0/SHA db39a6a61468eb15040778657e1634138b267080d3cb18bfacb63e631f170ab1 ;Inactive2872/DXT1/mip7/SHA32ef628d ;Charging4224/DXT5/mip1/SHA430c2239. Empreintes complètes en preuves,membres155/155/107 et core7 hérités. Aucun montage/provider/pixel qualifié.

## 3. Consommateurs réels

Quinze fichiers actuels,treize Rust/deux Python,28ancres ;13sources/frontières et34contextes concordants,14entrées VFX communes,deux animations ordinaires. native_hud_respawn4926/SHA96798238 également comparé octet/texte.

damage::apply_damage,healing::heal,regeneration,lifecycle::advance_respawns/world::spawn_unit sont présents. Soins plafonnés,refus sur mort ;régénération avant attaques,réapparition normale restaure PVmax. Aucun hook Zac nommé dans les treize préfixes Rust examinés ;absence bornée,non universelle. Monde sans définitions blob réutilisé après garde.

HPBar/HPStat et compteur normal acquis ;ressource None,non Mana,provenance distincte de l’INIBIN natif. countdown dépend de mort/respawn_at,ticks arrondis,visibilité connexion/session/fin. Ce chemin et les primitives owner/projection/animation génériques ne produisent pas Cell Division.

## 4. Attendu, observé et vérifications

Attendu :source exacte,consommateur ou manque borné,refus/reprise. Observé :liens déclaratifs établis,création/rendu spécifiques non établis. **36/36 contrôles documentaires qualifiés,62/62 de cohérence séparée du même agent.** HUD148/148 et147/147 hérités.

Quatre cas Zac/Annie1/18 relus. API100dégâts bruts puis40soin :endpoint combiné seulement,sans paire intermédiaire pour chaque action.120paires de régénération brutes relues,calculs f32 et compteurs HUD antérieurs réutilisés,sans recalcul. Quatre plafonnements100000 restaurent le déficit ;pas un ramassage4%.

Huit paires fatales API/64samples relus,offsets0/1/239/240/241/délai−1/délai/délai+1. Zéroblob,PV0à240ticks,PVmax/réapparition après480au1/1110au18 comme Annie. Disponibilité/recharge non qualifiées ;aucune conclusion universelle sur renaissance native. Quatre Move/arrivées hérités,deux XP diagnostiques.

108refus à flags :24sorts Zac vivant,48commandes mort,36API ;non108paires individuelles.10384ticks=1966+3226+1966+3226,non toutes frames. Aucun impact de capacité,ramassage ou recombinaison exécuté. RUN466315octets/1158entrées non rouverts,binaire6098944/SHA `611f4c2643a27814789b1b0758bf5e1fd985d888e98b144c4e032e0ba2cfef24` inerte. Aucun nouveau build,jeu,natif,REA,GPU ou réseau.

Collect01 a35/36 :attendu65appels au lieu de66,ZacEMove en compte huit. Un seul prédicat corrigé,35autres et tous témoins inchangés ;échec/journaux et qualification séparés conservés. Ancien JSON HUD interrompu sur set non sérialisable :original partiel,préfixe identique et récupération148/148 conservés. Erreur ancienne de sélecteur pub(crate) préservée. Erreurs de consultation root séparées,aucun échec moteur déduit.

## 5. Écarts et inconnues

Impact admissible,f1,fragment/ramassage/expiration,disponibilité/recharge,bloblets/scaling/recombinaison,owner/attache/provider/skin/audiences et son restent ouverts. **Le rendu Cell Division reste non qualifié.** Texte,icône,préchargement,soin API et réapparition normale ne remplacent pas le passif. Inventaire secondaire complet et acceptation indépendante/humaine non qualifiés.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/CHUNK-VFX/REBIRTH-VFX/NETWORK,préconditions,fins et reprises. Sept dépendances existantes SPAWN/PICKUP/READINESS/BLOBLETS/RECOMBINATION/ICON/HUD conservées. Reprendre sur source/callsite/capture attribuée ou consommateur modifié,autorisation distincte pour implémenter. next_lot.json vise Zed,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_zac_passive_vfx_20261106` :sources,préchargements,fenêtres,observations,cohérence,corrections et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés. Journal Python limité aux producteurs ;bootstrap/contexte/dispatch/gardes/empaquetage exclus,sans preuve OS/TOCTOU.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
