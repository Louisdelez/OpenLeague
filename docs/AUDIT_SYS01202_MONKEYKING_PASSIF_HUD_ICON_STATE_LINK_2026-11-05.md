# SYS-01.2-02 — V1298 Wukong / MonkeyKing : Stone Skin et HUD

## 1. Périmètre et prérequis

2026-11-05,F:/OpenLeague. Unité `AUD-SYS-01.2-02-MONKEYKING-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-MonkeyKing-PASSIF-PRESENTATION-HUD`, exigence `OLF-19836c42-2cc0-5e35-b431-b09d0b1139ae`, inconnue `OLU-d888fa7c-70c3-5199-9dde-9b05ff2edfb1`. Audit documentaire borné terminé ; six contrats/questions conservés,HUD a_faire/implementation_complete=false/acceptance_complete=false,dépendance NETWORK ouverte. D06/D06-CH-MonkeyKing et prérequis D01 dans phase_package_prerequisites.json,sans acceptation de phase présumée. Goal SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Aucun Plan/UI/base/registre/goal/code produit/asset modifié.

## 2. Sources, provenance et limites natives

[V603 conservé](reference_requirement_trace_sources/monkeyking-passive-stone-skin-links-v603.json),1638923octets/SHA `6f664a92eef3bc0b451a932b915788fcfe56fa73f613d700fad9f723e562c98c`,UTC hérité `2026-10-26T09:30:34.391604+00:00`. SOURCE67relations/64IDs :19INIBIN,27Lua,16preload,DDF et font ; memberships antérieurs concordants. MonkeyKing.inibin2872octets/SHA `98c290c3cca5df7cb44b1e20bc6596a47145e1564136a414cbb6bbcbedca569f`. Vingt-trois NightmareBots restent exclus.

Alias MonkeyKingPassive,icône MonkeyKingStoneSkin.dds,nom4410/description4234 ; BuffData lie2303 :armure et RM supplémentaires par champion ennemi proche,@f1@. Montant,niveaux,rayon et éligibilité restent inconnus. Quinze champs SpellData interrogés du passif sont absents,non remplacés par0 ; Passive1/Desc,niveaux et descriptions secondaires aussi. Les défenses de base24,87999916/32,09999847 ne sont pas des valeurs de Stone Skin.

CharScript56vide ; Passive227 déclare Cassiopeia_PetrifyingGaze.dds,nom MonkeyKingPassive et persistance/non-dissipation. Les27Lua sans callback enfant et10limites NEWTABLE ne prouvent ni corruption ni exécution serveur. Six BuffData et leurs textes sont résolus ; QWER/clones,alias Akali/Wolfman,16lignes DDF et preloads restent du contexte. Les six chemins candidats absents ne prouvent aucune absence globale.

resource_provenance :deux chemins StoneSkin,4352octets,64×64 DXT1/mip1,membres0.0.0.40 du manifeste choisi0.0.1.7,même SHA `19cb76dfc570b45dcea242861c9ffaebea7a07d60df3f7d3fdfaebb1af1740e8`. Chemin propre Info2176octets lu exactement par SOURCE après sélection E ; chemin partagé2176 réutilisé depuis Vi V1293,empreintes de la capture E et membership vérifiés,aucun nouveau stat/read du fichier D correspondant. Identité commune ne prouve pas priorité/rendu. Pas de métadonnée native relue ni énumération D par root.

Le basename Cassiopeia existe dans le manifeste sous DATA/Characters/Cassiopeia/HUD/Icons2D,4224octets,membre0.0.0.248. Ce candidat étranger n’est pas ouvert ; résolution propre/partagée et choix effectif restent inconnus. Ce fichier n’est pas déclaré globalement manquant et aucune mécanique de Cassiopeia n’est adoptée.

## 3. Consommateurs réels

Trente-quatre ancres héritées sur18fichiers,43fichiers code/configuration ;16communs et31identités V603 inchangés. Stats,défenses des objets,commandes/déplacements,projectiles,AnnieQ,visibilité et snapshots existent. Les calculs courants ne montrent aucun producteur Stone Skin dans la portée examinée. L’unique occurrence Rust "wukong" relevée est un test de refus d’alias dans attacks.rs ; identifiant interne MonkeyKing/monkeyking conservé.

Barres natives et HPStat consomment health/max_health ; ressource locale Mana,provenance source_sha256 distincte de l’INIBIN natif. Ces consommateurs génériques sont conservés,sans liaison qualifiée de f1/compteur/état ou rendu de l’icône du passif.

## 4. Attendu, observé et contrôles

134/134 contrôles documentaires corrigés,127/127 cohérence séparée du même agent. Vingt archives8666260octets ; RUN conserve16diagnostics TRAVEL_START et un JSON final identique à OBS. BUILD/RUN0 final hérité ; binaire6129664octets/SHA `f9089daa656c4671ef681d34e66f78784eb91d4aa90cc72486e1eb54d2aec27d`,non relu/rejoué ;1158dépendances non requalifiées. Aucun nouveau build,jeu,VM native,REA,GPU ou réseau.

Deux cas publics à six joueurs,niveau1,vivants :base et objets1029/1033,+15armure/+25RM. Séquence d’ennemis0/0/1/2/3/3/2/1/0,alliés0puis2. Rayon600 choisi par l’observateur,non natif. Comptages recomputés aux36snapshots de début/fin de phase ;540relevés statistiques portent défenses/tick/flag de régénération,seuls les endpoints contiennent les positions. Défenses constantes24,879999/32,099998 et39,879997/57,099998,aucun bonus Stone Skin observé.

Vingt-huit destinations représentées par18reçus de déplacement :arrivées recomputées à moins d’une unité ; quatre reprises Stop/Move durant les mises en place,non réparation de navigation. Cinquante-quatre refus atomiques ont des flags d’invariance,non tous les snapshots bruts avant/après. Les5008ticks ne sont pas tous des frames archivées.

Six projectiles physiques non critiques :attentes recalculées40,3667526/36,0380325,délais/résidus archivés concordants à0,002près. Pas de pairesPV brutes pré-impact pour ces six mesures dérivées. Deux Q Annie acceptés,raw80/coût60 :attentes60,5601807/50,9229774 ; les deux paires de snapshots encadrant12ticks de régénération/impact sont reproduites par arithmétique f32. Il ne s’agit pas de douze framesPV archivées par Q. Aucun sort MonkeyKing accepté,aucune fidélité native du passif déduite.

## 5. Échecs et inconnues conservés

Trois mises en place antérieures BUILD0/RUN101 conservées avec sources,commandes et logs ; troisième essai :SETUP_FAILED,quatre arrivées sur six. Le scénario final réussi et ses quatre reprises ne clôturent pas la navigation.

Vérificateur actuel initial132/134 :classifier distinguant mal SETUP_FAILED de TRAVEL_FAILED et arrondi de l’armure effectué après une addition en f64. Qualification distincte :base désérialisée en f32 avant ajout de l’objet,concordante avec INIBIN et270frames du témoin. Deux contrôles et un champ dérivé d’armure corrigés ;132autres contrôles et tous autres champs exacts,originaux conservés,aucun replay matériel/jeu.

f1/rayon/niveaux/visibilité/éligibilité/clones,mort,synchronisation et présentation restent ouverts. Les essais ne prouvent pas une absence universelle de mécanisme natif.

## 6. Corrections et reprise

- `COR-MONKEYKING-STONE-SKIN-POLICY-01` :qualifier f1,rayon,niveaux,éligibilité et visibilité sur source/contrat versionné ; garder600 observationnel.
- `COR-MONKEYKING-NEARBY-COUNT-01` :produire le compte admissible,exclure alliés et gérer entrées/sorties ; vérifier les transitions selon politique qualifiée.
- `COR-MONKEYKING-DEFENSE-BONUS-01` :lier compte/formule aux deux défenses,conserver objets/base ; vérifier réduction physique/magique et retour au repos.
- `COR-MONKEYKING-ICON-PROVIDER-01` :établir le choix StoneSkin/Cassiopeia sur source/trace de chargement avant toute substitution.
- `COR-MONKEYKING-HUD-BINDINGS-01` :relier f1/compteur/icône à l’état réel ; vérifier transitions/rendu,préserver barres/HPStat.
- `COR-MONKEYKING-SETUP-REPRO-01` :rattacher les arrêts prématurés/reprises à la correction de navigation et vérifier la reproduction ; le passif ne clôture pas cette correction.

Reprendre sur source primaire nouvelle,consommateur modifié ou test nécessaire autorisé. Prochain candidat :Xerath.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_monkeyking_passive_hud_20261105 :evidence_review original/corrected,qualification,coherence_review,captures/réutilisation DDS,histoire,journaux,result/publication/postpublication. Journaux limités aux producteurs Python instrumentés ; contexte exploratoire,dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2285entrées sales groupées conservées. Zéro tâche complète,inconnue,feature ou acceptation close ; revue du même agent,sans acceptation indépendante/humaine.
