# SYS-01.2-02 — Sejuani : Frost Armor et HUD, V1267

4 novembre 2026. Unité `AUD-SYS-01.2-02-SEJUANI-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; implémentation, vérification du jeu et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Sejuani-PASSIF-PRESENTATION-HUD`, `OLF-e5bad71b-e579-5b4b-be34-eced46b2f0d0` : relier icônes, texte, armure et réduction des ralentissements aux consommateurs et au HUD. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-bcf709c2-08a2-5105-8888-0b772fab2fa8` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE, phase D06/lot D06-CH-Sejuani et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts ; QWER distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/sejuani-passive-frost-armor-links-v623.json`, 3190776 octets, SHA `378bb20cec5658386dc9d88a893aba039c7c4aaad8fd7bea482de8f32c52ded0`, UTC documentaire 2026-10-26T15:50:40.232089+00:00, sans attribution à une heure d’exécution.

HUD : deux sources/un catalogue. SOURCE :97relations/91identités,six sites/trois fichiers. V623 :91sources/273associations,30sites/60liens/15fichiers. Union17fichiers/36ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans lecture D :30INIBIN,40Lua,19preloads,DDF et font.

Définition SejuaniPassive,icône Sejuani_Passive.dds ; buff Sejuani_passive.dds, différence de casse conservée. PARType,Passive1 et six niveaux absents,BaseMP287.20001220703125. Héritage critiques alliés/AttackRate10/15/20% non adopté. Buff2607 et description4270 : infliger des dégâts par attaque ou sort donne f1 armure et réduit les ralentissements de f1% pendant2s ; si déjà actif, durée augmentée de2s. Producteur f1, progression et plafond non qualifiés. Frost Armor propre reste distinct de Frost, marque ennemie d’E, malgré nom localisé « Frost ».

Seize BuffData :10résolutions,six clés absentes :SejuaniArcticAssault,SejuaniNewE,SejuaniPassiveDisplay,EliseHumanEHeal,SejuaniPassiveStacks,SejuaniPassiveHitBuff. Aucune réécriture. PassiveHeal expose EliseHumanEHeal/EliseHumanE.dds ; aucun soin ou shield déduit. PassiveStacks expose BuffName SejuaniPassiveMS, sans compteur ou plafond prouvé. PersistsThroughDeath et preloads ne sont pas une politique serveur.

40Lua :32littéraux/huit limites NEWTABLE, aucun callback qualifié. CharScript natif56octets et communautaire vides. DDF20lignes : seule liaison W bonushealth×0.1, distincte du f1 passif. Quatre candidats absents ne prouvent aucune absence globale. 35références communautaires comparatives ; divergences Q/dash/PVmax,W/PVbonus,E/zone-marques,R/collision conservées.

Deux DDS nécessaires,6400octets,deux contenus64×64 :

- `DATA/Characters/Sejuani/HUD/Icons2D/Sejuani_Passive.dds` : 2176 octets,DXT1/mip brut0,membre0.0.0.161,SHA `96024a049aeef212d12b33dd426ae0950ba7b7e6f711d60a29268db0552e22ce`.
- `DATA/Spells/Icons2D/Sejuani_Frost.dds` : 4224 octets,DXT5/mip brut1,membre0.0.0.68,SHA `35dd0f61b7f3e78a874243543d6879a4dab9398aac0c16bb75e93854c10024a9`.

Manifeste lol_game_client0.0.1.7,tailles/MD5 concordants. Un alias particule homonyme22000octets reste manifeste seulement : sélection restreinte HUD/Icons2D et Spells/Icons2D avant deux lectures SOURCE, sans reparsing du manifeste. Aucun DDS Elise ou particule lu ; inventaire initial et qualification conservés. Lookup/provider/pixels ouverts. Font miroir inchangé,témoin Ahri réutilisé.

Mana courant distinct du PARType natif absent :source_sha256 correspond au StatsJSON communautaire 5011 octets/SHA `5803cb911f8a2d0939c1c2c300f4664915faedff1b1dd53af5666d2faa5f8e4c`, distinct de l’INIBIN natif 1807 octets/SHA `610a02fd3a0f685045d6325645efc65a81933cff325dfe37a4afba13f1e847ff` (`resource_provenance.json`).

## 3. Consommateurs actuels

36ancres exactes,16entrées communes et32fichiers code/configuration vérifiés. Aucun producteur nommé Sejuani/FrostArmor dans les fichiers Rust sélectionnés ; recherche bornée. Progression calcule armure base/croissance/objets/effets existants et Exhaust ; basic_attack_hit applique dégâts physiques/soin génériques. Slows choisit le plus fort ralentissement non expiré,movement l’applique avec les règles courantes :aucune branche Frost Armor identifiée.

Mana/santé et leurs chemins HUD sont acquis. Ces ressources/statistiques génériques ne produisent pas l’état propre,son texte,son f1 ou sa durée. Aucune absence globale d’UI ou de gameplay revendiquée.

## 4. Attendu et observé

Attendu :dégâts admissibles déclenchent le buff propre, puis armure/réduction des ralentissements/durée et HUD attribuables. V623 :trois profils base/Tissu1029+15armure/Bottes1001+25vitesse,18mêlées,neuf physiques entrants,trois Q Annie,84refus,six trajets sans reprise,neuf relevés boutique/six transactions buy/sell/rebuy.

AD57.544 ; armure29.54/44.54/29.54 et vitesse340/340/365. 647échantillons d’armure pendant deux séries d’attaques restent génériques, sans bonus observé. Les attaques infligeant des dégâts exercent le déclencheur candidat ; aucun sort Sejuani accepté. La magnitude native manquante demeure inconnue,car f1 non résolu.

Exhaust appliqué au même tick que le dernier impact de première série :228échantillons,elapsed0..75 par cas. Armure−10,ralentissement0.3,vitesse238/238/255.5 jusqu’à expiration75, puis valeurs de base. Aucun supplément d’armure/réduction du slow observé. 543échantillons d’attente supplémentaires restent génériques ;771échantillons explicites au total, sans qualification d’expiration d’un buff Frost Armor jamais produit.

Dégâts ordinaires recalculés à tolérance0.002 :sortants48.267059,entrants38.914612 ou34.876160 avec Tissu,Q≈60.560173 via MR. Valeurs dérivées conservées, sans paires PVcible adjacentes brutes ; healing_checked=false,refus flags seulement,pas de garde NPC universelle. Qsansshield, aucune preuve de soin Elise.

Historique19fichiers/76059888octets,17ancienshashes concordants/deux identités nouvelles. Premier BUILD101 conservé :deux E0559,Summoner n’a pas target. Version _target utilisant SummonerTarget,BUILD/RUN bruts0. Binaire 6153728 octets/SHA `d394459073f543ed572dcf14fc8a272fe633a9d0fd49fba0f11dbec1395ac63d` inerte. Contrôles72/72,cohérence séparée69/69,même agent ;aucune opération matérielle actuelle échouée. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

f1/progression,événement et unités admissibles,ordre armure/slow,clamps,prolongation/plafond,expiry,mort/respawn,bindings/provider et rendu/transport ouverts. Marque ennemie et buff propre distincts ;V564/Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Sejuani-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-SEJUANI-FROST-ARMOR-POLICY-01` :qualifier f1,événements,cibles,horloge,extension/cap,ordre et lifecycle. Fin :contrat4.20 sourcé,incertitudes explicites,aucune substitution du DDF de W ou d’Elise.

`COR-SEJUANI-FROST-ARMOR-STATE-STATS-01` :produire le buff sur dégâts admissibles,armure/résistance aux ralentissements,durée2s et prolongation2s. Fin :attaque et capacité acceptées,refus/absence de dégâts,application pendant buff actif,frontières d’expiration/cap,mort/respawn vérifiés selon politique qualifiée. Préserver contrôles Tissu/Bottes/Exhaust.

`COR-SEJUANI-FROST-ARMOR-HUD-BINDINGS-01` :relier icônes/texte/f1/expiration au bon état propre. Fin :bindings distincts,clé absente signalée,armure/slow/durée et transport observés,pixels vérifiés. Reprendre sur nouveau mapping/source/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_sejuani_passive_hud_20261104` :evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json,journaux et qualification de sélection. Hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées. Rapport et ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif,goal/Plan/UI/bases/registres/produit inchangés.
