# SYS-01.2-02 — Gain et sortie audio avant effacement, V766

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB. Tâches SYS-01.2-02 et SYS-02.2-07 restent partielles.

## Résultat mesuré

REA6.4.0/Ghidra12.1.4 analyse12 fonctions : B170C0,B16C10,B0D200,B16540,B0D250,B0C1A0,B277F0,B27AD0,B26430,B264C0,B168E0 et B18530. Les instructions et références sont revérifiées dans le PE original SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le reçu conserve les demandes/réponses et la fermeture de session.

Une sonde passive reprend les31 cycles de voix et les refus déjà étudiés. Les états,allocations,destructions,gates et blocs exécutés sont identiques à V765. Elle ajoute des captures avant B277F0,au dispatch de sortie et avant B27AD0. Aucun gain,drapeau ou temps n’est forcé pour obtenir un résultat positif.

31 médias produisent62 frames actives et31 frames d’arrêt. Les93 passages suivent B0C1A0 → B277F0 → B264C0 → B27AD0. Le bus et le device contiennent déjà8192octets nuls,avec compte de frames0,avant l’effacement. B26430 n’est pas appelé dans ces profils ;B264C0 traite le cas sans frames. Le recorder est nul. Il n’y a ni appareil audio physique ni écoute réelle.

Sur62 décisions B171F0/B170C0,le wrapper unique de clé0/0 a un gain+0x258 nul. Le seuil121022C reste0x37806fd9 (environ1.5310872e-5),tandis que parent+0x20 est positif et parent+0x18 vaut1. Parent+0x10 est nul. Les58 refus de gate et4 admissions restent identiques. Ces mesures éliminent l’explication « signal positif seulement effacé à la fin » pour les tampons observés ;elles ne qualifient pas tous les états intermédiaires ni le producteur du gain.

## Consommateurs actuels

Le setter audio_global_float_configuration::set existe déjà,avec dépendance power explicite. audio_normal_frame::run_locked délègue les phases Post::A/B/C/D à Services::post. audio_fallback_device::Runtime::configure alloue et met à zéro le tampon ;sa présence ne prouve pas la soumission ou le mixage final. Deux points précis sont ajoutés au registre et configure est réutilisé. Cette révision vérifie leur source exacte ;elle ne compile ni n’exécute de nouveau le Rust. Les preuves et tests antérieurs restent distincts.

## Vérifications et limites

Les31 cycles,la restauration des références,les refus objet/nœud/position/parent et4265 blocs natifs sont relus par le validateur existant.2390 allocations et767 libérations laissent1623 allocations de banques,sorties et capacités. La nouvelle vérification contrôle l’ordre des captures,les octets des descripteurs,les comptes,les SHA des tampons et les gains. Le premier transfert initialise root+428/+42C à partir de+434/+438 respectivement,avec tampons inchangés. Le premier contrôle trop strict de tous les octets du bus a échoué ;son diagnostic et le validateur corrigé sont conservés séparément. Huit falsifications sont rejetées :signal inventé,empreinte de tampon altérée,chemin de soumission inventé,gain inventé,seuil changé,code natif changé,facteur de source altéré et capture producteur manquante.

Le client original n’est pas lancé :x86 isolé,allocateur/verrous/TLS/atomiques et clock1000 adaptés. Positions nulles,IDs de test,managers/capacités et contexte événement/listener restent fournis. Le bootstrap historique,le temps avancé,le streaming,seek,boucles,concurrence,autres médias/locales et sortie physique restent ouverts. Aucun code produit ni asset modifié ;aucune case manuelle cochée ;aucun jeu/champion déclaré terminé.

Correction documentaire :0x328 vaut808octets,et non828 comme écrit dans la prose V765. Le code exécuté et les captures V765 utilisaient déjà808octets ;leurs preuves restent intactes.

## Preuves et suite

Preuve structurée : docs/fidelity_rea_audio_output_v766.json. Captures : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision766_gain_producer_observation/OBSERVATIONS.json (première capture séparée conservée). Audit : revision766_output_associations_final/OBSERVATIONS.json. Publication et relecture : revision766_delivery/VERIFIED.json et INDEPENDENT_READBACK.json.

B16540 est exécuté62fois avec une source :facteur source+0x14=0,gains parent+0x20 et bus+0x4E0 positifs,wrapper non exclu et branche de drapeau16 désactivée. Il produit bien wrapper+0x258=0. Poursuivre le producteur du facteur source dans B16C10/AEC6E0/B199D0 et les entrées listener/événement,avant de conclure sur le mixage. Préserver les inconnues et les validations manuelles.
