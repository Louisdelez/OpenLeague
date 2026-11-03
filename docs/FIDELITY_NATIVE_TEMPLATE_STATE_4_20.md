# État et durée de vie du template natif — référence 4.20

Le composant original 0x918490/0x9187A0/0x918660/0x918620 construit, réinitialise et détruit le template de 472 octets, vtable 0x10D6B90. Les huit chaînes logiques sont vides à la construction, avec longueur zéro et capacité SSO 15. Le récepteur de callback reste un état explicitement fourni ; le constructeur complet du gestionnaire n'est pas exécuté.

Deux cas de stockage initial zéro/A5 proviennent du tour précédent et sont relus par le consommateur. Ils montrent que 151 octets conservent leur remplissage initial, dont le mot +0x13C. Aucun défaut zéro n'est attribué à ces octets, aucun sens de padding ou de tableau inactif n'est inventé. Le second reset vide donne le même état logique et les mêmes octets ; le destructeur supprimant original libère l'objet.

Six nouveaux contrôles exécutent deux profils de chaînes peuplées et quatre appels de notification optionnelle nulle. Le reset vide les chaînes +0x140/+0x158/+0x170/+0x188, conserve +0xF0/+0x108/+0x120/+0x1A0, et garde les capacités et pointeurs déjà alloués. Le destructeur libère ensuite toutes les chaînes et l'objet. Les collections de groupes de particules restent vides : leur retraite non vide n'est pas qualifiée.

Les callbacks originaux 0x92DD90 et 0x92DDB0 retournent sans modifier le récepteur lorsque les pointeurs optionnels +0x36C/+0x370 sont nuls. Ce profil ne qualifie ni une notification non nulle ni le contexte réel d'un gestionnaire historique.

Au total : huit cas, 6 736 observations d'instructions originales, 517 PC distincts, aucune faute mémoire et aucune allocation invitée restante. Les seuls adaptateurs sont les feuilles d'allocation/libération invitées conservées de V30. Les chaînes, les copies, les branches de reset et les destructeurs s'exécutent dans le code original contrôlé par ses octets. Aucun processus Windows historique n'est lancé.

41 contrôles de qualification passent, dont 36 refus de preuves altérées. Le premier qualificateur a échoué sur une mutation sans effet : le bas octet du pointeur de callback était déjà zéro. Le qualificateur dérivé écrit un octet différent ; l'ancien reçu reste conservé et aucun essai natif n'est relancé. Le lecteur a aussi reçu des gardes de types et de profils explicites avant cette qualification ; sa première version est conservée.

Le consommateur maintenu audit_native_template_state.py est installé et exécuté en lecture seule. Cette preuve de composant enrichit uniquement les trois traces SYS-01.2-02/03/06 et l'inconnue existante de contexte/chargement. Elle n'ajoute pas un constructeur générique aux exigences de chaque champion et ne ferme aucune inconnue.

Restent le contexte/package réel, le cache, les wrappers de lecture, les formats et groupes du backend 0x918E90, le chargement 0x918B30, la retraite de collections non vides et les callbacks non nuls, puis les effets et leurs déclenchements. Aucun code Rust/C de production, asset, état manuel ou acceptation n'est modifié. Les autres objectifs du Goal, dont les caps AIR4312/4313 et les scripts communautaires, restent ouverts.

Preuves : [référence](reference_native_skin_loader_sources/native-template-state-reference.json), [intégration](fidelity_registry_native_template_state_revision_4_20.json).
