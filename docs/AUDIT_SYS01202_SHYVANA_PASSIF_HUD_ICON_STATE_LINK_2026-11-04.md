# SYS-01.2-02 — Shyvana : Dragonborn et HUD, V1270

4 novembre 2026. Unité `AUD-SYS-01.2-02-SHYVANA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; implémentation, vérification du jeu et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Shyvana-PASSIF-PRESENTATION-HUD`, `OLF-6c88c78b-3ae9-55d2-9f06-3e52bedf734a` :relier icônes/texte,bonus défensif et état dragon aux consommateurs et au HUD. Contrat a_faire,implémentation/acceptation false,dépendance NETWORK ;inconnue `OLU-c0b62337-da52-5554-b64e-0a52a1fa2c00` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/lot D06-CH-Shyvana consultés,sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts ;QWER/Furie dans leurs tâches distinctes.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/shyvana-passive-dragonborn-links-v626.json`,2828457octets,SHA `289961f64564ae6bf9be8cb1261ee093c63d0e0513fda9ca4c788112cca2f42a`,UTC documentaire 2026-10-26T16:42:29.899549+00:00,sans attribution à une heure d’exécution.

HUD enregistré :une définition/un catalogue. SOURCE :69relations/66identités,six sites/trois fichiers. V626 :66sources/198associations,24sites/48liens/12fichiers. Union14fichiers/30ancres. Aucun ID SOURCE supplémentaire ;liaisons complémentaires documentées ici,registre gelé conservé. Métadonnées réutilisées sans lecture D :26INIBIN,23Lua,15preloads,DDF et font.

Sorts dans DATA/Spells,CharScript dans Characters/Shyvana/Scripts. Ancienne recherche Characters/Shyvana/Spells arrêtée puis ressources retrouvées :aucune absence globale déduite. PARType=Dragonfury,BaseMP chaîne100.0,BaseStaticMPRegen0,PARStart/PARMax absents. Passive1LuaName=ShyvanaPassive,icône ShyvanaReinforcedScales.dds,Passive1/six niveaux absents. Héritage MasterYi/régénération mana40/60/80% non adopté.

Buff2635 et description4275 :bonus f1 d’armure et résistance magique,doublé en dragon. Producteur f1/progression non résolus,aucune valeur supposée. DragonScales décrit une hausse temporaire,sans équivalence de provider ou durée établie avec Dragonborn. Huit BuffData exactement résolus. 23Lua :14littéraux/neuf limites NEWTABLE,aucun callback serveur qualifié ;CharScript et TransformCheck vides. TransformLeap/JarvanIVCataclysm et TransformDamage/Move/Minotaur restent métadonnées étrangères,non règles de déplacement/vol/dégâts. Drapeaux de persistance/preloads ne prouvent ni lifecycle ni rendu.

DDF8lignes :W bonusattackdamage×0.2,Q attackdamage×0.8/0.85/0.9/0.95/1.0,non f1 défensif. R sélectionné ShyvanaTransformCast ;rangs1–3 :coût5Furie/s,seuil100,génération Effect3=1/2/3 toutes1.5s selon tooltip,Effect2=2 par attaque. Description « par seconde » distincte ;valeurs résiduelles4–5 non adoptées comme rangs accessibles. Compteur100 ne démontre pas une forme active. Variantes E4s/5s/ancien shred,DragonScales et Transform restent distincts. Quatre candidats absents ne prouvent aucune corruption. 31références communautaires comparatives,divergences Q/W/E/R conservées.

Deux DDS nécessaires,4352octets/deux contenus :

- `DATA/Spells/Icons2D/ShyvanaDragonsDescent.dds` :2176octets,64×64 DXT1/mip1,membre0.0.0.56,SHA `6847ae3b9cdc6ce2ed1a30a224a3167dfb4b05adc22c3afd32a74f8e87a155ac`.
- `DATA/Spells/Icons2D/ShyvanaReinforcedScales.dds` :2176octets,64×64 DXT1/mip1,membre0.0.0.56,SHA `2ccf22e59a5030afc5a60538063b37e2851bcb74938226c6c8c2e70c630e40d6`.

Manifeste lol_game_client0.0.1.7,tailles/MD5 concordants ;sélection E avant deux lectures SOURCE,chemins partagés Icons2D uniquement. Passive/DragonScales/Transform justifient ces icônes ;aucun DDS Jarvan/Minotaur/particule lu. Lookup/provider/pixels ouverts. Font miroir inchangé,témoin Ahri réutilisé.

Dragonfury courant concorde au PARType,mais source_sha256 correspond au StatsJSON communautaire 8593octets/SHA `88860f3ba22799976ae0a1d0b68dbd0d6ac5eabd615641d7456517202b9aefc8`,distinct de l’INIBIN natif 3107octets/SHA `cf408bdf4fcb757f44cb3cb269a82b64a494ec66ccf53cacc79f664bbf32045f` (`resource_provenance.json`).

## 3. Consommateurs actuels

30ancres exactes,16entrées communes et27fichiers code/configuration vérifiés. Aucun producteur nommé Shyvana/Dragonborn dans les fichiers Rust sélectionnés ;recherche bornée. Progression produit défenses base/croissance/objets et autres effets existants ;aucune branche du passif ou doublement identifiée. Basic_attack_hit applique dommage physique/soin génériques sans mutation de Furie.

Classification Dragonfury,max100 et chemins de défense/objet conservés. Restauration périodique générique limitée à Mana/Energy,exclusion du mana d’objet pour Dragonfury ;ces règles statiques ne qualifient pas le moteur de Furie de R. Native_hud_bars.rs:11 produit resource seulement pour Mana ;widgets.rs:91 produit MPStat seulement pour Mana :jauge/chiffres Furie omis par ces routes. Santé/statistiques génériques ne complètent pas Dragonborn.

## 4. Attendu et observé

Attendu :bonus défensif sourcé,forme active et doublement attribuable,HUD correct. V626 :trois profils sans transformation base/Tissu1029+15armure/Manteau1033+25RM,neuf mêlées sortantes,neuf physiques entrants,trois Q Annie,543ticks d’attente,81refus,six trajets sans reprise,neuf relevés boutique/six transactions buy/sell/rebuy.

Défenses27.628/32.1,42.627998/32.1,27.628/57.1 :base+objets uniquement dans ces contrôles. Aucun déficit numérique historique précis déduit,f1 restant inconnu. Dégâts sortants50.924347,physiques entrants39.497620 ou35.343689,Tissu efficace ;Q60.560192 ou50.922985,Manteau efficace. Calculs ordinaires recalculés,tolérance0.002.

Neuf paires brutes Furie100→100,maximum100 et181échantillons d’attente/cas inchangés. Plafond ne permet pas de qualifier gain/production. Aucun sort Shyvana accepté ;dragon_form_exercised=false :forme/doublement non exercés. Valeur100 n’est pas un indicateur de transformation. Entrée/sortie,consommation,génération et rangs R ouverts.

Dégâts dérivés sans paires PVcible adjacentes brutes ;healing_checked=false,refus flags seulement,pas de garde NPC universelle. Qsansshield,n’exerce aucun contrôle de bouclier propre. Historique15fichiers/11535888octets,13ancienshashes concordants/deux identités nouvelles. Binaire 6138368octets/SHA `b46a557caf849823e397fb743765a70eb5e004913c84a1fc179a75da1733bf7a` inerte,BUILD/RUN bruts0. Contrôles69/69,cohérence séparée61/61,même agent ;aucune opération matérielle actuelle échouée. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

f1/progression,ordre/addition/doublement,provider DragonScales/Passive,activation/fin de forme,Furie sous plafond/horloge1.5s ou1s,lifecycle,bindings,rendu/transport ouverts. Champs legacy/variantes E/R et V564/Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Shyvana-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-SHYVANA-DRAGONBORN-POLICY-01` :qualifier f1,progression,ordre/providers et forme/lifecycle. Fin :contrat4.20 sourcé,sans confondre base et bonus ni faire de Furie100 une preuve de dragon.

`COR-SHYVANA-DRAGONBORN-FORM-STATS-01` :produire le bonus puis doubler le seul bonus Dragonborn en forme admissible. Fin :profils normaux/dragon,entrée/sortie réelle,progression,armure/RM/objets,refus et lifecycle vérifiés selon politique qualifiée ;préserver les contrôles Tissu/Manteau. Prérequis :transformation R acceptée ;génération/consommation dans les tâches R/Furie existantes,avec jauge entamée.

`COR-SHYVANA-DRAGONBORN-HUD-BINDINGS-01` :relier icônes/texte/f1,forme et jauge au bon état. Fin :liaisons distinctes,valeurs normales/doublées,transitions/transport et pixels observés,affichage Furie partagé réutilisé lorsque disponible. Reprendre sur nouveau mapping/artefact serveur/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_shyvana_passive_hud_20261104` :evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées. Rapport et ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif,goal/Plan/UI/bases/registres/produit inchangés.
