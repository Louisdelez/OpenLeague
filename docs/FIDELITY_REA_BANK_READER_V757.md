# SYS-01.2-02 — Banques mémoire complètes, V757

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. Association des sources et consommateurs de SYS-01.2-02/SYS-02.2-07. Aucun code produit ni asset modifié ;objectif et inconnues restent ouverts.

## Lecture originale réellement exécutée

AF9D40 appelle AF9960 avec les fichiers originaux entiers et une requête mémoire command0/callback0. Init.bnk est lu dans son ordre BKHD→STMG→HIRC→ENVS. Les sixbanques ENV_Map10_SFX_events,NPC_Map10_SFX_events,Announcer_Global_Female1_VO_events,Announcer_Map8_Female1_VO_events,Announcer_Tutorial2_events et Announcer_Tutorial_events suivent BKHD→HIRC→STID.

Les septlectures retournent1. Les2516objets HIRC sont conservés dans les holders ;11noms STID sont installés avec suffixe.bnk. Les4courbes ENVS/8points sont comparés aux valeurs sérialisées et à la conversion native. Toutes les sections présentes sont dispatchées dans l’ordre source et les fichiers restent intacts. Ces septbanques ne contiennent aucun DIDX/DATA :la lecture des médias ne peut pas être déduite de ce résultat.

Chaque banque est relue :AF9960 retourne69 avant toute nouvelle lecture de corps/allocation,AF9D40 normalise en1. Les sixholders de banques d’événements sont ensuite retirés du cache par B21AA0,leurs objets relâchés par AFC410 et leur mémoire détruite par AFBFD0 avec décrément atomique. Le cache revient au seul Init ;les index reviennent à son état. Le déchargement asynchrone externe n’est pas exécuté.

## Producteur réel du drapeau7C

Le contexte commence avec7C=0. B258E0 s’exécute pendant la première lecture ;son global14A832C est déclaré nul. Le lecteur de bus HIRC8 AFBD40 écrit1 à l’instruction AFBE05. Les79écritures sont tracées avec les79IDs de bus :première transition0→1,puis1→1. Les banques suivantes voient1 et ne passent plus par B258E0.

Le premier audit supposait à tort que7C restait0. L’hypothèse intermédiaire attribuait l’écriture à STMG ;le traçage machine la réfute. Les scripts et observations antérieurs sont conservés comme essais,et leurs limites textuelles sont corrigées ici. La preuve autoritative est revision757_banks_flag_checked/OBSERVATIONS.json. Ce drapeau produit dans Init ne qualifie pas le cas d’un scope global non nul ni tout le démarrage historique.

## Consommateurs Rust actuels

La sonde compile33modules complets inchangés,avec Cargo generate-lockfile --offline puis build --locked --offline ;exécution code0. Les septbanques sont soumises à deux contextes7C et aux deux politiques HIRC et sections :56refus.

- 28refus de contexte avec7C=0,avant lecture des banques.
- Avec7C=1 déclaré :4refus de STMG pour Init,20refus de lecteurs HIRC et4refus du créateur Silence pour Tutorial2.

Les32comparaisons de limites gardent ces arrêts précoces distincts du résultat natif plus tardif. Vingt-quatrecas composent les vrais BKHD/STMG/ENVS/STID ou des contrôles de section :les lecteurs de sections connues restent explicitement non implémentés,même sous la politique de saut des inconnues. Troiscontrôles supportés réussissent et réutilisent leur cache sans rappeler la closure de lecture ;ce ne sont pas des banques originales complètes. Toutes les allocations de ces essais Rust sont libérées et leurs holders/objets sont retirés.

Deuxrôles précis sont ajoutés :load_request_deferred et destroy_empty_holder. Quatrerôles existants sont réutilisés :appel de BKHD,lecteur externe,lecteur HIRC et refus Silence. Les qualifications antérieures sont conservées. Aucun chargeur complet ni jeu n’est annoncé terminé.

## Limites natives contrôlées

Huitcas sur copies :version87→64 ;dernier header tronqué→7 ;section inconnue courte→7 ;section inconnue complète→1 ;allocation holder refusée→52 ;réservation HIRC refusée→2 ;nom STID final tronqué dans un espace de noms frais→56 ;même fichier tronqué avec noms déjà connus→1.

La différence56/1 vient du chemin STID de réemploi :le nom déjà présent est sauté sans valider tous ses octets. Ce succès ne prouve pas l’intégrité d’une source. Le cas frais peut conserver les deux noms précédemment installés ;les objets HIRC et le holder en échec sont bien nettoyés. Les noms appartiennent au gestionnaire,non au holder de cette banque.

Six falsifications sont rejetées :ENVS omis,nom STID modifié,relecture de cache non observée,troncature en cache mal rapportée,chargeur Rust complet indûment promu et nettoyage courant manquant.

Les8321allocations et7990libérations,contrôles inclus,laissent331allocations Init/noms/managers/capacités vivantes. 13décréments atomiques et27994paires de verrous sont tracés. Le teardown global demeure ouvert. Allocateurs,verrous physiques,TLS/last-error,opération atomique et journal sont des transports déclarés ;le code de chargement,copie et destruction est original. Aucun provider disque/concurrence historique,voix,mixage ou sortie physique qualifié. Les banques VO sont en_US,non une couverture exhaustive en_GB.

## REA et identité

REA6.4.0/SDK2.3.1,Ghidra12.1.4,JDK21.0.10.7 :12fonctions,1190instructions et27références vérifiées ;session complète exportée et fermée sans erreur. AF9960,AF9D40,AF8A20,AFB930,AFB320,AFB1E0,AFBFD0,AFCF00,AF7720,B258E0,B25BF0,B25D00. Les1806blocs d’exécution sont comparés au PE.

League of Legends.exe :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk :6890octets,SHA25641d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les huitidentités natives et33modules actuels sont pinés ;originaux sous D:/LeagueOfLegendsV2,nouvelles preuves sous F.

## Livraison et prochaine étape

Preuve docs/fidelity_rea_bank_reader_v757.json ;reçus F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision757_*. Troisregistres,documents de couverture/reprise et deuxfiches dans deuxbases locales enrichis. Deltas compressés ciblés ;aucune copie intégrale de base. Cases,notes,historiques,autres tâches et inconnues conservés. VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED vérifient la livraison.

Suite :résoudre les11dépendances STID,identifier les banques qui contiennent DIDX/DATA et qualifier leurs lecteurs/propriété des médias et consommateurs actuels. Garder séparés chargement des objets,media réellement disponible,voix exécutée et son audible.
