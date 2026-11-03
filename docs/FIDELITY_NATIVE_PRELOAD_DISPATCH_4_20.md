# Préchargement natif des ressources des graphes — référence 4.20

Le code original 0x5685F0 est exécuté après le fixup, le constructeur et la création des tables du graphe. Les 122 graphes candidats de base restent ceux de V31, y compris le champ Animations commun des deux configurations Renekton ; aucune priorité complète de skin n'est choisie.

Les 751 enregistrements contiennent 1 390 entrées : 1 152 de type2, 18 de type1, 157 de type3 et 63 de type5. Le code sélectionne les 1 147 noms non vides de type2, soit 703 noms distincts exacts. Les cinq autres entrées de type2 ne donnent aucun nom non vide. 1 146 noms portent le suffixe .troy ; Jayce_Range_Q_Buildup est transmis sans extension. Ce nom reste inchangé : aucune règle d'ajout d'extension n'est déduite. Leur présence ne prouve ni la disponibilité du payload, ni un déclenchement par un sort.

Le parcours lit body+0x24/body+0x44, le nombre u16 à record+0xE et les entrées relatives à record+0x14. La sentinelle lue à 0x12395CC vaut 0xFFFFFFFF. Le pointeur de nom type2 est relatif au début de son entrée, pas à son champ. Les trois calculs de base relatifs sont conservés explicitement par le lecteur borné.

Les 1 147 noms, leur ordre, leurs offsets et le mot de contexte transmis au gestionnaire concordent avec les appels observés. Les fonctions originales 0x577AF0 et 0x577C00 encadrent l'appel ; leur getter partagé 0x5CC140 est exécuté. Quatre profils par graphe vérifient gestionnaire présent, DisablePreload mis en cache à vrai, gestionnaire absent et owner nul. Sans gestionnaire, les appels avant/après restent présents. La branche désactivée et l'owner nul n'émettent aucun de ces appels.

Le cache de DisablePreload est fourni à la sonde ; l'initialisation originale par 0x8B1910 et DATA/CFG/defaults/Game.cfg est seulement inspectée statiquement. Les pointeurs de contexte partagé 0x14C761C/0x14C7620 sont fournis nuls. Le gestionnaire, sa vtable et le contexte opaque sont fournis ; sa méthode +8 est une sonde d'observation avec ret8. Cette sonde n'est pas un chargeur de ressources. Le vrai gestionnaire, la branche de contexte partagé non nul et le caller extérieur 0x56D3C0 restent ouverts.

L'expérience exécute 6 512 888 instructions originales à 2 052 PC sous Unicorn avec contrôle des octets du PE. Aucun accès mémoire non mappé n'est observé ; les 8 363 allocations invitées des owners sont libérées. Les feuilles malloc/free restent celles de V30. Aucun processus historique Windows, chargeur ANM, déclenchement d'événement, choix de clip, pose ou playback n'est qualifié.

47 contrôles passent, dont 31 refus d'observations altérées et dix contrôles structurels sur copies en mémoire. Les refus structurels sont ceux du lecteur local borné ; ils ne sont pas présentés comme des refus natifs exécutés. Les sources originales restent inchangées.

Le consommateur actuel tools/project-plan/audit_native_preload_dispatch.py est installé et réellement exécuté. Les 488 exigences de présentation, dix ROLE et trois SYS reçoivent des liens précis. Les 503 inconnues existantes de ces présentations/rôles sont enrichies, toutes ouvertes avec historique et condition de résolution. Les listes sont attachées au graphe du champion ; aucune ressource n'est attribuée à un slot de sort à partir de ce seul préchargement.

Les preuves antérieures, les états manuels et les travaux Rust/C/assets sont préservés. Les autres objectifs du Goal, les divergences AIR4312/4313 et les scripts communautaires restent ouverts. Cette référence ne termine ni le Goal ni le jeu.

Preuves : [référence](reference_native_skin_loader_sources/native-preload-dispatch-reference.json), [intégration](fidelity_registry_native_preload_revision_4_20.json).
