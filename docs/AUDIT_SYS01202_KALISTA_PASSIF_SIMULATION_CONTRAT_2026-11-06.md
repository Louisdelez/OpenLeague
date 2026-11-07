# V1487 — Kalista : contrat connu de Martial Poise

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KALISTA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Kalista-PASSIF-SIMULATION-CONTRAT, exigence OLF-556a1781-a664-534c-ae98-36efbcfb48b2, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Le verrou natif d’annulation est un acquis partiel préservé, sans nouvelle implémentation. Tâche complète, fonctionnalité et goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/kalista-passive-martial_poise-links-v663.json du 27 octobre 2026 : 4917535 octets, SHA256 04c682946b734f5447451199cb88d51b6d7fffa2389deaf422ea54eab61a6572. Rapport FIDELITY_KALISTA_PASSIVE_MARTIAL_POISE_LINKS_V663.md : 23091 octets, SHA256 2822b908fd036b80e7903f292f5cc98bf109ae614c6dd0d1c9d3290430920328. Réutilisation sans nouveau décodage ni accès D:/F-work/EXE.

Vingt-cinq ressources natives sélectionnées, cinq preloads et onze Lua identifiés dans leur appartenance conservée. Ces onze chunks étaient entièrement parsés, sans prototype enfant : dix initialisations littérales, 31 globals, une limite NEWTABLE pc8 dans MysticShot, sans corruption démontrée. L’inventaire hérité de 114 Lua/24 limites, 241 candidats natifs et 69 références communautaires reste distinct de cette sélection.

Cinq recherches en_GB : nom Martial Poise, BuffData ligne 2132, description présente mais non liée par PassLev1Desc1, CardMasterBasicAttack absent et ShenShadowDash présent sans adoption de sa formule. Les champs absents de passif/niveaux ne reçoivent aucune valeur inventée.

Le texte décrit attaque non annulable, échec lors de perte de vision, bond au lancement d’attaque ou de Pierce après ordre Move pendant la préparation, distance selon bottes et +25 % vers l’arrière. Distance/vitesse numériques restent inconnues. DDF8 lignes vides ; preloads, persistance et icônes sont des métadonnées, sans callbacks ou présentation exécutés.

Le C# communautaire non vide décrit OnPreAttack/OnLaunchAttack/OnMoveEnd, baseDistance250, speed1025, bottes et angle, avec spéculations/TODO. Il n’est ni exécuté par Rust ni adopté comme serveur historique. Aliases TalentReaper/Rumble/Shen et contexte Oathsworn/W/R restent séparés.

## 3. Consommateurs réels

Vingt-cinq entrées concordent avec V663 : dix-sept Rust, deux lecteurs Python, six JSON. Avec le miroir en_GB, 26 identités gardées. Trente-cinq fenêtres, dont 32 communes réutilisées et trois sur vitesse, visibilité et boucle de projectiles libérés. Vingt-sept ancres enregistrées, dont 26 qualifications entry_boundary_only conservées ; elles n’acceptent pas Martial Poise complet. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

Acquis réel : attack_contracts.json contient cant_cancel=true, missile_speed2600, période1.519760012626648, windup0.550000011920929, ratio0.5 ; natif CantCancelWhileWindingUp=1. Le lecteur générique charge ce profil et crée cancelable=false. cancel_windup refuse Stop/Move ; command ne mémorise donc pas le bond. Il faut préserver le tir non annulable en ajoutant le traitement de déplacement manquant.

La recherche de noms Kalista/MartialPoise sur dix-sept Rust est négative, mais ne nie pas ce consommateur générique réel. Aucun constat d’absence globale ni inspection des 1158 dépendances.

attack_target_valid vérifie visible_to avant lancement. La boucle de projectiles libérés, lignes157–173, ne revérifie pas cette visibilité. Constat statique ; aucun échec Kalista de perte de vision reproduit dans ce lot.

## 4. Attendu, observé et contrôles

Attendu documentaire : conserver le verrou partiel, identifier la mise en attente du bond manquante, distinguer marche et hop. Observé : 69/69 contrôles documentaires, 104/104 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V663 hérité : huit simulations Kalista/Annie × niveaux1/18 × sans/avec bottes1001. Vingt impacts physiques : seize Kalista, quatre Annie. Vingt-quatre essais pendant windup, Stop/Move avant/Move arrière. Kalista refuse douze ordres, dont huit directionnels, avec snapshots inchangés ; tir conservé, aucun bond jusqu’au lancement+30ticks, aucune destination différée observée. Annie accepte ses douze ordres, annule le windup, puis marche normalement. Stop après impact réussit.

132 refus publics :120 Kalista et12 Annie, incluant ces douze refus de windup. 16860 ticks, douze apports XP serveur, quarante trajets publics sans réémission. Les apports XP qualifient la préparation diagnostique des niveaux, pas une progression publique complète. Aucun ajout direct de position/PV/horloge/inventaire/statistique ni appel de dégâts/soin API dans le diagnostic conservé.

Quatre achats publics de bottes consomment325or et ajoutent25 de marche ; ils ne valident pas la distance du bond absent. Q/Pierce accepté, perte de vision, cible disparue, autres bottes, terrain du hop, contrôles, mort/réapparition, réseau et rendu non exercés. Le contrôle Annie ne devient pas un passif Kalista.

Exécutable V663 identifié uniquement en données :6100992 octets, SHA256 ea5371890bf03abc400ee4384f1dbaf5157720c22bba20a63a695fb3e38a4de3. Aucun accès/lancement ; verrou, toolchain et1158 entrées non revalidés. Neuf archives privées et leurs reçus conservés ; aucune restauration, compression ou vérification des bases historiques relancée.

## 5. Écarts et conclusions ouvertes

Restent ordre Move mémorisé, lancement du bond, fenêtre de commande, distance/vitesse, paliers de bottes, direction/arrière25 %, terrain/collision, ralentissements/contrôles, Pierce, vision et projectiles, changements de cible, lifecycle, présentation et réplication. Oathsworn/W/R restent dans leurs exigences propres.

Question OLU-1e6c64cc-3575-5901-906e-1526c9dea294 et propriétaires/dépendances SOURCE conservés. Aucune inconnue fermée, aucun acquis cant_cancel effacé, déplacement V564 non corrigé.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KALISTA-MARTIAL-POISE-, suffixe -01 : KEEP-NONCANCEL, MOVE-QUEUE, LAUNCH-TIMING, DISTANCE, HOP-SPEED, DIRECTION, BOOT-TIERS, TERRAIN, CONTROLS, PIERCE-Q, VISION-MISS, TARGET-CHANGES, ALIASES-COMMUNITY, LIFECYCLE, OATH-SEPARATION, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_kalista_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2473 entrées groupées préexistantes conservées. Prochain Karma depuis122paires ;81candidats hors41unités nommées, sans compte complet déduit. L’ancienne suggestion réseau Aatrox ne remplace pas cette sélection courante.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
