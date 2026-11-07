# V1481 — Irelia : contrat connu de Ionian Fervor

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-IRELIA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Irelia-PASSIF-SIMULATION-CONTRAT, exigence OLF-105662b4-274e-539d-adc0-052d971aa20a, parent SYS-01.2-02. Audit borné de seize branches connues :réduction de durée,comptage ennemi et consommateurs sélectionnés. SOURCE a_qualifier,phase D06,six prérequis du lot et propriétaires d’inconnues conservés ; tâche complète,fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB,date littérale2014-11-17 17:46:45 ; fuseau/déploiement inconnus,catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/irelia-passive-ionian_fervor-links-v577.json :828124octets,SHA256 4a759468cc9cecc0878a88676704be299ce6c4d98ab2ed67ac8d456080f24373,du26octobre2026. Rapport FIDELITY_IRELIA_PASSIVE_IONIAN_FERVOR_LINKS_V577.md :SHA256 dde2d3125c4f391d3d2f13301301ed4f6e1997c584209fd32a730e46a9f35cda. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Huit identités natives aux rôles distincts,sept références communautaires séparées,deux preloads. Deux Lua entièrement parsés historiquement,sans prototype enfant,initialisations littérales et deux globals. Persistance absente non transformée en false ; aucune exécution serveur.

Trois clés en_GB vérifiées :tooltip2022,description4202 et nom. Description :un/deux/trois champions ennemis proches donnent10/25/40% de réduction ; tooltip dynamique f1%. Producteur,portée,conditions de comptage,cas zéro/au-delà de trois,catégories de contrôles,cumuls et arrondis restent non qualifiés.

Passive1LuaName=Voracity dans le personnage ; preload et buff nomment IreliaIonianDuelist. Divergence conservée,sans remplacement automatique ni règle de Katarina adoptée. Icônes Irelia_IonianFervor.dds concordantes,mais rendu non prouvé.

Le DDF contient quatre entrées R/TranscendentBlades,sans producteur du passif. Champs de niveau recherchés absents,sans valeur zéro inventée. Preloads HitenStyle/idle et trois particules du passif ne démontrent ni activation ni rendu.

## 3. Consommateurs réels

Vingt-huit entrées concordent avec V577 :dix-huit Rust,deux lecteurs Python,huit JSON. Avec le miroir en_GB,29identités gardées. Trente-six fenêtres :32communes réutilisées et quatre sur silence,stun,slow et délégation du coup renforcé Garen. Vingt-huit ancres enregistrées,dont27frontières entry_boundary_only,provides_feature_consumer=false pour Ionian Fervor. Tous les renvois de branches aboutissent aux fenêtres contrôlées.

control_duration lit courage_until :si actif,ceil(durée×0.7),sinon durée brute. Le helper ne compte pas les ennemis. apply_silence applique cette durée puis conserve l’échéance maximale ; grant_stun et prepare_slow l’utilisent pour les champions. Slows capturent la durée avant commit,rafraîchissent par tag et expirent séparément des stuns. Aucun producteur Irelia identifié dans ces corps.

stuns::allows_disabled charge réellement disabled_cast_rules.json par include_str,avec douze règles locales et refus explicite d’une politique inconnue. Cette admission ne prouve pas une immunité native d’Irelia ni l’exécution de toutes les branches.

Recherche littérale Irelia/IonianFervor/IonianDuelist sur dix-huit Rust sélectionnés :zéro occurrence,sans absence globale ou inspection des1158dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire :séparer textes natifs,sorts publics,événements serveur et contrôle Courage. Observé :70/70contrôles documentaires et94/94cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build,test Rust,jeu ou REA.

V577 hérité :quatre cas Irelia avec0/1/2/3ennemis du groupe diagnostic,deux contrôles Garen. Aucun changement direct d’état selon les preuves. Ennemi du cas zéro à13261.615234375unités ; autres groupes à150/250.00006103515625/350. Le seuil400 est un regroupement du diagnostic,pas la portée native.

Trois Q publics de Garen produisent chacun45ticks de silence sur Irelia,avec expiration exacte ;135ticks de suivi au total. Les preuves identifient apprentissage,cast,coup renforcé,windup et perte de santé. Ce lot ne requalifie pas tout GarenQ.

Diagnostics serveur distincts :grant_stun et grant_slow25% appliqués ensemble,bruts1/30/90ticks sur chacun des quatre cas Irelia,observés inchangés. Garen sans Courage :90→90 ; Courage appris/lancé publiquement :90→63. Quatorze paires,28événements serveur,suivis637ticks. Ils ne deviennent pas des sorts joueur de stun/slow. L’arrondi de Courage n’est pas adopté comme règle d’Irelia.

Soixante-quatorze refus publics et54refus serveur hérités,snapshots inchangés. États actifs jusqu’au tick précédent l’échéance,puis expirés. Objets de ténacité,visibilité,clones,autres contrôles,sources multiples,niveaux,mort/réapparition et réseau/rendu non qualifiés.

Ancienne inspection KeyError conservée :disabled_cast_rules existait sans entrée de registre ; son identification et son lecteur ont été ajoutés dans V577. Ancien PREPARE code1 conservé :comparaison d’un élément au lieu de la tranche complète des consommateurs ; livraison qualifiée séparée. Aucun échec ancien reclassé en succès ; aucun changement de registre dans ce lot.

Exécutable V577 uniquement identifié en données :6078976octets,SHA256 6a9ecfb00b4aa08c80f555455825186194abd839a9711ba5c7bd878dfb08bd11. Aucun accès/lancement ; verrou,toolchain et1158entrées non revalidés. Défauts de déplacement antérieurs,dont V564,non corrigés.

## 5. Écarts et conclusions ouvertes

Restent fournisseur f1,alias effectif Voracity,portée/comptage,taxonomie des contrôles,instant d’échantillonnage,durées minimales/arrondis,refresh,cumuls avec ténacité,application aux consommateurs,cycle de vie,réplication et présentation.

Question OLU-0f66001b-b09e-5aa5-a6d4-ddb29bc639b0 et dépendances/propriétaires SOURCE conservés ; aucune inconnue fermée. Réussite du contrôle Courage et règles d’admission locales distinctes d’une validation d’Irelia.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json,préfixe COR-SYS-01.2-02-IRELIA-IONIAN-FERVOR-,suffixe -01 :F1-PROVIDER,RADIUS,ENEMY-COUNT,CC-TAXONOMY,ROUNDING,SAMPLING,REFRESH,TENACITY-COMPOSITION,PUBLIC-TRIGGERS,CONTROL-INTEGRATION,DISABLED-CASTS,VORACITY-ALIAS,LIFECYCLE,PROJECTION,PRESENTATION,VERIFICATION. Objectif unique,tâche liée,prérequis,travail,fin distincte et condition de reprise présents pour chacune.

Reprendre sur source nouvelle faisant autorité,fournisseur retrouvé,consommateur modifié ou cas supporté indispensable non couvert ; aucune correction fonctionnelle enregistrée/implémentée ici.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_irelia_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2467entrées groupées préexistantes conservées. Prochain Janna depuis122paires ;87candidats hors35unités nommées,sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète,fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent,sans revue indépendante ni acceptation humaine. Publication :rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal,Plan/UI/bases,registres,produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée,sans gain temporel mesuré.
