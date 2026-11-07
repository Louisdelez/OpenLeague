# SYS-01.2-02 — Shaco : Backstab et HUD, V1268

4 novembre 2026. Unité `AUD-SYS-01.2-02-SHACO-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; implémentation, vérification du jeu et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Shaco-PASSIF-PRESENTATION-HUD`, `OLF-eb7538ba-e9b7-5858-9f7b-f0d5c21d91ba` : relier icône, texte et condition de frappe dans le dos aux consommateurs de géométrie/dégâts et au HUD. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-cfffd321-be71-5d14-b7a4-e4be7348d250` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/lot D06-CH-Shaco consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts ; QWER distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/shaco-passive-backstab-links-v624.json`,3266853octets,SHA `a153b0745fe68f67cd24bd422b9c87f493a0e62d836e3a0c3fafa745438d9ac9`,UTC documentaire 2026-10-26T16:07:27.661336+00:00,sans attribution à une heure d’exécution.

HUD :deux sources/un catalogue. SOURCE :68relations/62identités,six sites/trois fichiers. V624 :62sources/186associations,28sites/56liens/14fichiers. Union16fichiers/34ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans lecture D :19INIBIN,28Lua,13preloads,DDF et font.

Définition/buff Backstab,icône Jester_CarefulStrikes.dds. Buff1702 et description4271 concordent sur20% de dégâts supplémentaires depuis le dos. « attacking » et « striking a unit » ne fixent pas le secteur angulaire,l’instant du test,les catégories de dégâts,cibles,critiques,clones ou ordre. PARType,Passive1 et six niveaux absents,BaseMP297.20001220703125. Héritage régénération mana+40/+60/+80% non adopté.

Six BuffData exactement résolus. 28Lua entièrement parcourus,sans sous-fonction/limite NEWTABLE ; cela ne démontre aucun serveur complet. CharScriptShaco,FromBehind et CastFromBehind exposent des initialisations vides. Backstab expose nom/icône/PersistsThroughDeath/NonDispellable,non prédicat ou callback. Preloads frombehind/castfrombehind/twoshivpoison et particules ne prouvent aucune activation/rendu. DDF8lignes :unique lien E bonusattackdamage×1.0,non formule Backstab. Variantes espacées W/E conservées sans alias. Quatre candidats absents ne prouvent aucune absence globale.

Spell4 exact=HallucinateFull,ExtraSpell1=Hallucinate :ancienne prose de découverte corrigée à partir du champ,preuve initiale conservée. Aucun mélange des variantes. 24références communautaires comparatives :Q délégué,W incomplet,E divergent,R explosion8s distinct du clone contrôlable18s ;aucune autorité serveur déduite.

Deux DDS nécessaires,8448octets/un contenu :

- `DATA/Characters/Shaco/HUD/Icons2D/Jester_CarefulStrikes.dds` :4224octets,64×64 DXT5/mip brut0,membre0.0.0.153,SHA `acc3d18619469bce01668d85172e22bec244907a3e7c58022eaaa961d8932183`.
- `DATA/Spells/Icons2D/Jester_CarefulStrikes.dds` :4224octets,64×64 DXT5/mip brut0,membre0.0.0.25,SHA `acc3d18619469bce01668d85172e22bec244907a3e7c58022eaaa961d8932183`.

Manifeste lol_game_client0.0.1.7,tailles/MD5 concordants ;sélection E HUD/Icons2D et Spells/Icons2D avant deux lectures SOURCE. Aucun alias de champion étranger ou particule ouvert. Lookup/provider/pixels ouverts. Font miroir inchangé,témoin Ahri réutilisé.

Mana courant distinct du PARType natif absent ;source_sha256 correspond au StatsJSON communautaire 4865octets/SHA `9e389785cb1a2dd9d65b1c6bdfc4ec1daf750e86b786652e96019ff71c688baf`,distinct de l’INIBIN natif 2171octets/SHA `87fd3a1e69ca50baafd8639fe2460067056a10193ee4cc9cb77177b16e637523` (`resource_provenance.json`).

## 3. Consommateurs actuels

34ancres exactes,16entrées communes et29fichiers code/configuration vérifiés. Aucun producteur nommé Shaco/Backstab dans les fichiers Rust sélectionnés ;recherche bornée. Basic_attack_hit applique le dommage physique/soin génériques,sans test de facing. Capture_facing accepte seulement Garen/Trundle ;les sites réels mouvement/attaque et la conversion de direction en yaw sont présents. Shaco conserve facing absent,non remplacé par zéro.

Mana/santé et leurs chemins HUD sont acquis. L’orientation publique de la cible et les ressources génériques ne prouvent pas le bonus,déclencheur,icône/texte rendus ou feedback historique du passif. Aucune absence globale d’UI ou gameplay revendiquée.

## 4. Attendu et observé

Attendu :condition arrière qualifiée,dommage modifié et présentation attribuable. V624 :quatre cas base_face/base_dos/Épée1036+10AD_face/dos,24mêlées non critiques,724ticks d’attente,108refus,12trajets sans reprise,dix relevés boutique/six transactions buy/sell/rebuy.

Cible Garen orientée par un déplacement public réel,dernier vecteur[8,0],yaw≈−89.999992°. Sur24frappes,positions source/cible,dernier vecteur et heading concordent ;cosinus recalculés+1 en face/−1 au dos. Géométrie actuelle établie,sans qualification du prédicat angulaire natif ni de son instant. Facing Shaco omis dans la sérialisation ;inconnu préservé.

AD57.580002/67.580002. Dégâts ordinaires45.148041–45.148071 ou52.988953,identiques face/dos à équipement égal. Recalcul avec armure Garen,tolérance0.002. Comparaison illustrative×1.2≈54.177646/63.586752 ;ce n’est pas une formule native complète. Aucun bonus arrière observé dans ces contrôles. Les valeurs dérivées ne remplacent pas des paires PVcible adjacentes brutes ;healing_checked=false,refus flags seulement,pas de garde NPC universelle.

Aucun sort Shaco accepté. Mana plein et181ticks d’attente/cas ne qualifient ni consommation d’un sort ni lifecycle du passif. Ancien collecteur :KeyError facing consigné dans le reçu,champ optionnel omis,script initial conservé. Relecture historique sur le même RUN réussi,observations égales au JSON brut ;aucun rejeu. Correction de prose Hallucinate distincte de cette reprise.

Historique16fichiers/12077264octets,14ancienshashes concordants/deux identités nouvelles. Binaire 6138880octets/SHA `f9338438c46e0ab31561bbc62455fb3f52aecc5006e66be4efbd9b884574f2bb` inerte,BUILD/RUN bruts0. Contrôles69/69,cohérence séparée63/63,même agent ;aucune opération matérielle actuelle échouée. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

Secteur/seuil,instant attaque/dégâts,orientation requise et indisponible,types de cible,dégâts/sorts/clone,critiques/réductions,ordre/clamps,lifecycle,provider et rendu/transport ouverts. QWER,HallucinateFull/Hallucinate et V564/Nami distincts.

## 6. Corrections et reprise

Réutiliser `CH-Shaco-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-SHACO-BACKSTAB-POLICY-01` :qualifier géométrie/temps,orientation absente,éligibilité,ordre et lifecycle. Fin :contrat4.20 sourcé,sans déduire un secteur exhaustif des deux cosinus ni inventer un heading par défaut.

`COR-SHACO-BACKSTAB-ONHIT-01` :appliquer20% aux événements admissibles. Fin :face/côté/dos,frontières angulaires et temporelles selon politique qualifiée,cible mobile/heading absent,Épée,critiques/shields/refus et catégories établies vérifiés ;conserver les contrôles géométriques existants.

`COR-SHACO-BACKSTAB-HUD-BINDINGS-01` :relier icône/texte et présentation établie au bon événement. Fin :bindings exacts,impact normal/arrière attribuable,transport/rendu vérifiés,feedback non sourcé laissé inconnu. Reprendre sur nouveau mapping/source/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_shaco_passive_hud_20261104` :evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées. Rapport et ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif,goal/Plan/UI/bases/registres/produit inchangés.
