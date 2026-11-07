# SYS-01.2-02 — builders,PCM actuel et limites de construction intégrés (V214)

SYS02.5-04 relie21textures des fonctions terrain/Foundry/matériaux,31WAV courants et leurs31WEM identiques aux payloadsDIDX/DATA natifs. Les trois banques correspondent aux manifestes sélectionnés. Le nuageKTX2 conserve11niveaux BC1 du DDS source. Sept refus ciblés passent ;la conversion WEM→WAV n’a pas été réexécutée et les réglages GPU restent ouverts.

Le test actuel pcm_audio::catalog_tests::real_catalog_reaches_bevy_decoders_with_exact_frame_counts passe avec cargo test --locked --offline sous Rust1.96.1 :1test,0échec,1542autres filtrés. Il charge31PcmAudio dans Assets,contrôle canaux/fréquences et compte les échantillons des décodeurs. Code de sortie0,journal,exécutable et outils épinglés ;trois copies d’identité conservent les octets après futures recompilations. Les six entrées protégées sont inchangées. Les199avertissements préexistants restent au journal. Aucune écoute,GPU ou partie exécutée.

SYS03.1-01 reçoit l’observation locale précise :Rust1.94refusé,Bevy0.19etbevy_ecs0.19déclarent minimum1.95,Rust1.96.1réussit sur un artefactPE x64. Le workspace déclare1.90 et n’a pas de fichier de verrouillage de toolchain. Cette tâche reste ouverte ;aucune version de dépendance n’a été changée et aucune matrice de cibles complète qualifiée.

SYS03.3-01 reçoit le site exact load_ambient qui construit la racine depuis CARGO_MANIFEST_DIR à la compilation. Le test ne prouve pas une installation déplacée et cette dépendance n’a pas été supprimée. Les consommateurs sont répartis selon leur objectif ;les tâches de build/portabilité ne reçoivent pas de nouveaux liens natifs sans rapport.

Livraison :4fiches/copies/traces par base,4pointeursJSON+2refus,ancres et identités contrôlées.42606états manuels et historique conservés ;anciens graphes,inconnues et autres champs de tâche conservés. Validation globale structurelle sans rehash complet du catalogue.

Preuves : docs/fidelity_builder_ambient_graph_v214.json ; docs/reference_event_lookup_sources/builder-ambient-v214.json. Registres sources/trace/tâches et les deux bases actualisés. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision214/before-builder-ambient-graph. V210refusRust,V211journal/erreurcollecteur,V212testcomplet etV213vérificationssources conservés. Sources du jeu,assets,packs et acceptations inchangés.

Restent ouverts :autres familles et chargements,conversion audio complète,équivalence du mix/rendu,verrouillage Rust/cibles et portabilité. Aucun jeu ou tâche générale déclaré terminé.
