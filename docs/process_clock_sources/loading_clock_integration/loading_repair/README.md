# Correction des trois tests Windows de premier nom

Seul candidat : `audio_replay_windows_loading_packets_tests.rs`. Aucun code
applicatif ni fichier de production modifié par cet agent ; aucune compilation
ni exécution de tests effectuée pour ce correctif.

`Runtime::configure_service` construit le vrai service et le publie dans
`Shared.service`, mais le producteur natif de `SERVICE_GLOBAL` (2D787B8) n'est
pas encore porté. L'image initialise ce global à zéro. Les trois tests de
premier nom passent par sa lecture dans `loading::receive` ; leurs anciens
appels directs à `names::service_name` contournaient cette dépendance. Ils
échouaient donc avant le provider, l'UI et l'horloge.

Le helper ajouté effectue une publication diagnostique explicite du pointeur
du service réellement construit. Il vérifie l'identité du pointeur canonique,
la vtable réelle et ses slots +48/+4C. Aucun pointeur de fonction, nom ou
résultat d'horloge n'est simulé. Les slots relus directement dans l'image
installée valent respectivement 72AD90 et 72AE40.

Chaque test restaure le global après destruction du recipient et avant
`close_game_manager`, donc avant la destruction du vrai service. Le test
d'erreur UI conserve l'échec attendu ; les deux autres conservent leurs
assertions sur les données, références, allocations et cleanup. Les messages
d'échec incluent maintenant les erreurs du runtime.

Le mécanisme normal de publication n'est pas qualifié par cette liaison de
test. La racine doit compiler et exécuter les trois chemins réparés. Le reçu
`repair_manifest.json` sépare les vérifications statiques effectuées des tests
non exécutés. `record_repair.py` ne modifie ni le candidat ni la production.
