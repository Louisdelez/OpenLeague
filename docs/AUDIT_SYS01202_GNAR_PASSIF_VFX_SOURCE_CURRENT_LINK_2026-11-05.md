# Gnar — versions de sources et consommateurs des VFX de Rage Gene

2026-11-05 · V1344 · AUD-SYS-01.2-02-GNAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Gnar-PASSIF-PRESENTATION-VFX, OLF-f341380b-1825-59bc-8407-d46627cb0df5. Relier les deux versions retenues aux consommateurs ; distinguer Mini/Mega, rage initiale/génération, réapparition, statistiques, transformation/fatigue, HUD et effets. Contrat lancement/trajet/impact applicable, dépendance CH-Gnar-PASSIF-NETWORK et prérequis D06/lot conservés sans satisfaction implicite.

Fin : identités/rôles des versions, déclarations, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos ; inventaire, mécanique complète, tâche VFX et acceptation restent ouverts.

## 2. Sources et versions conservées

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Deux reçus V1322 externes E, vérifiés avant interprétation :

- V571 rage-gene :752263 octets, SHA81a7e3ead5505fba27a315e28af96f2014490bd4a0f0336c0172360d35ee0936.
- V572 respawn-rage :960202 octets, SHAc3e80b2a3fdaffaa14b9f121e8492c30cbfc8c239dbae3e4bb9389f880fd72da.

Quinze clés de métadonnées communes sont identiques ; V571 conserve la limite de saturation, V572 ajoute sept champs de contexte après mort/réapparition et conserve24 consommateurs. Aucun gagnant ou ordre de provider déduit du numéro de version. Cadrage95061 octets sans incorporation des documents complets ; ancien HUD corrigé446258 externe également, hook inchangé, accélération non mesurée.

24 ressources natives :7 INIBIN,9 Lua,7 preloads,font. Sept identités preload conservées ; corps complets/références de particules non inspectés ici, sans fichier déclaré absent. Deux inspections E604338/813499 et driver7254 réutilisés par identité ;1425091 octets, originaux F/OpenLeague-work inertes.

Neuf Lua entièrement lus structurellement, aucun enfant ni exécution serveur ; quatre initialisations qualifiées/cinq affectations, CharScript56 vide. GnarPassive180 déclare icône/nom/persistance ; RedVfx90 et RunCycleManager90 seulement persistance. Cinq limites NEWTABLE PC6/8/8/10/10 conservées. Absence AutoBuff dans les initialisations reconnues ne prouve pas absence d’effets. Constantes AutoCooldownByLevel/RocketTristana antérieurement recensées restent sans politique de fatigue adoptée. WProc/Hyper est distinct.

Mini/Mega déclarent GnarPassive/Gnar_Passive.dds, Gnarfury et BaseMP="100.0" ; PARStart/PARMax/PARName/PAREnabled absents. BaseMP n’est pas une preuve de rage initiale. Définitions PV540/610 et QWER identiques en noms ne fournissent pas bonus dynamiques ou transition ; aucune soustraction des définitions adoptée comme formule.

Cinq tooltips en_GB1950/1951/1954/1955/1956 et description4193 : combat/attaques, prochain sort à rage maximale, transformation15s, fatigue et paramètres f1/f2/f3/f4/f5/f7/f8, SourceName non résolus. Producteurs et unités de calcul restent inconnus ; régénération Mega exprimée par5s non convertie arbitrairement.

DDS HUD héritée :2176 octets, SHA f923dc37f1e82479e6851befbb6c6fd05bfd9087060fbbb95da095913b35409b ;64×64 DXT1/mip brut0, membre0.0.0.244 du projet0.0.1.7. Header/membership hérités ; mip0 non corruption, provider/variante/priorité/pixels/rendu ouverts.

## 3. Consommateurs actuels

Onze Rust relus : core lib.rs,attacks.rs,damage.rs,regeneration.rs,lifecycle.rs,progression.rs,spells.rs ; client native_hud_bars.rs,native_hud_widgets.rs,animation.rs,projected_live.rs.22 ancres dont trois de contexte de test, pas22 producteurs Rage Gene.33 identités antérieures concordent, incluant21 comparaisons par version avec chevauchement ;14 mécanismes VFX et deux animations ordinaires concordent.

join initialise mana depuis def.mana. restores_resource limite la régénération à Mana/Energy ; respawn remplit Mana/Energy/Wind et met les autres à zéro. Gnarfury est la classification locale ; son source_sha256 embarqué reste une provenance historique distincte du natif sélectionné, sans corruption déduite. Ces voies expliquent des observations locales, pas la politique native.

stats consomme définition/croissance/objets, sans transition Rage Gene identifiée dans les corps lus. Effects/cast et attaques/dégâts gardent leurs mécanismes ; le chemin champion non implémenté est refusé. HUD bars/MPStat sont gardés par Mana, sans jauge Gnarfury alimentée. projected_live sélectionne Annie.

Recherche large Gnar/RageGene :trois occurrences dans un seul module cfg(test) animation.rs, nom de module/fonction et ligne Gnar spell4/Ashe. Elles ne prouvent pas un producteur de rage, une forme ou un rendu exécuté. L’ancienne recherche plus étroite à une occurrence reste conservée. Animation ordinaire V1336 via V1343 réutilisée par deux gardes, sans nouvelle sémantique/pose/pixels ;12 entrées QWER ne deviennent pas l’icône du passif.

## 4. Attendu, observé et contrôles

Attendu : versions/frontières qualifiées, acquis et limites préservés. Observé :70/70 contrôles documentaires qualifiés,81/81 cohérences séparées du même agent ; gardes33/14/2,22 ancres. V1310 corrigé73/73 et cohérence60/60 hérités, non rejoués.

V571 :trois cas idle/attaques émises/reçues,12 impacts,100/100 avant/après,48 refus,1800 ticks. Saturation :gain non mesurable. V572 :42 impacts publics préparent trois morts, réapparition480ticks à0/100 ; puis0/6/6 impacts, zéro maintenu,54 refus,1800ticks. Observation complémentaire de gain nul dans le Rust testé ; aucune règle native ou transformation qualifiée. Sans transformation atteinte, expiration15s non testée. Refus de connexion GnarBig ne teste pas une transformation interne.

Deux anciens BUILD0/RUN101 de voie aux dégâts non attribuables sont conservés ; successeur déplacé publiquement, sans correction de navigation démontrée. Binaires historiques6035456/ec128b083d2590af2c7ed71960e4b3be051a8ed3f517ca12fe957a65b371d517 et6059520/94b11682bd9e9c5a3361e988862ea1ca19430fcabbaf04db850293b31d3a2b45 inertes, non relus/rejoués.

Collecte initiale69/70/code1 conservée :ancre Mana trop large, production91 et test156. Sélecteur MPStat précisé ;69 contrôles inchangés,70/70,22 ancres. Premier vérificateur de qualification échoué sur comparaison de préfixe incluant l’ancre modifiée, conservé ; successeur compare toutes les identités, autorisant seulement ce needle91 et retrait du doublon156. Aucune source ou fonctionnalité corrigée par ces ajustements.

Sept opérations documentaires journalisées :six réussies, collecte initiale échouée conservée. Aucun nouveau build,jeu,natif D/stat/résolution,décodeur/VM,GPU,REA,réseau ou rendu.

## 5. Écarts et inconnues

Recette/applicabilité/inventaire, rage native initiale/gains/décroissance, événements/seuils/ordre du sort, bonus/formes/collision, fatigue et durée de transformation15s, paramètres, owner/skin/audiences, provider/pose/attache et rendu ouverts. Mort/réapparition/reconnexion et autres médias gardent leurs critères.

Inconnues VFX/SOURCE, consommateurs inscrits et V1322 conservés exactement. Zéro tâche complète,feature,inconnue,acceptation ou goal clos ; aucun pourcentage du jeu ni garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Gnar-PASSIF-PRESENTATION-VFX :rage-gene-visual-applicability-source,rage-form-state-world-link,form-resource-attachment-render-lifecycle. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; six tâches historiques restent distinctes.

Reprendre sur copie attribuable de preload nécessaire, nouvelle source/lecteur/appel/producteur/pose/capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-Gragas-PASSIF-PRESENTATION-VFX via next_lot.json, versions et rôles conservés.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_gnar_passive_vfx_20261105 :versions,cadrage,inspections,gardes,original/corrected,evidence_qualification,coherence_review,échecs et journaux. Relecture du même agent, sans acceptation indépendante/humaine.

Publication :rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2331 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation,migration,suppression,relance ou mutation Git.
