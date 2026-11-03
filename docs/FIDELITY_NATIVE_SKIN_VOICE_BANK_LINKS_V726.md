# SYS-01.2-02 — Banques et repli des voix de skins, V726

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue 4.20.1 distinct.

## Résultat et portée

545 conteneurs de voix sont inventoriés : 364 BNK et 181 WPK, en 122 ensembles de base et 60 ensembles de skins. Les 59 skins ayant au moins un flag UsesSkinVO actif ont un ensemble propre. Renekton skin5 possède également des banques, malgré les flags inactifs examinés. Ces deux faits ne prouvent ni inutilité ni absence.

Quinn1 et Skarner3 ont leurs BNK sans WPK propre. Les médias intégrés et leur sélection restent à qualifier ; aucun manque sonore n'est déduit.

Les 680 configurations des 668 skins sont composées avec toutes leurs alternatives de base. Les banques de base et propres sont inscrites dans deux ordres lexicographiques opposés, explicitement déclarés. L'ordre historique reste inconnu.

## Chaîne native exécutée

627890/627990 reçoit le rôle déclaré ;702750/56D850 choisit les alias ;6F72E0/702540 construit le nom ;6F8210/705750/AEA430/AEBDA0/AF9530/B1A800 recherche l'événement. Le repli vers le nom de base est exécuté dans la même image isolée.

Les actions utilisent les constructeurs et inscriptions d'origine ;leurs champs de cible sont fournis depuis les en-têtes sérialisés. Les événements passent B1A960 et B1A760. L'origine de l'événement retenu est contrôlée, y compris en présence d'identifiants dupliqués entre banques.

Les tables de cibles de médias sont vides. La frontière de lecture 6F78A0 enregistre la demande et retourne false. Aucun son n'est joué ni validé.

## Vérifications exécutées

- 704 compositions ;364 contextes de banques ;12672 demandes.
- 8322 demandes trouvent un événement, dont 10 par repli ;4350 restent sans correspondance dans leur contexte.
- 1323 adresses comparées au PE original.
- Six diagnostics : priorité propre, repli, absence des deux noms, flag inactif, backend désactivé et alias identiques absents.
- Six gardes du banc ;quatre preuves falsifiées rejetées.
- 1022 sources et 24 ancres actuelles vérifiées.
- 669 fiches et instructions copiables dans les deux bases ;autres tâches, cases, notes, historiques et inconnues conservés.

PE : League of Legends.exe, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Python, bibliothèques et scripts sont identifiés. Les cas détaillent résultats attendus et observés.

## Consommateurs actuels

Les chargeurs de modèles, lecteurs de références, PCM d'ambiances, plugins d'ambiances/certains sorts et dispatcher sont reliés avec leur portée exacte. Ces points ne constituent pas un fournisseur complet de voix de champions ou de skins dans le jeu actuel.

## Limites

- Original627890/627990,702750/56D850,6F72E0/702540 and6F8210/705750/AEBDA0 availability now execute in the same isolated image. Hero definitions,ordinal,position,cached audio object123 and empty suffix remain declared; aliases/flags are pinned to V724 source observations.
- All matching current/base configuration alternatives are preserved. Each available base/own VO bank group is explicitly registered in forward and reverse lexical order; neither order is claimed historical. Missing own voice directories lead to a declared base-bank context only,not proof of complete sound inheritance.
- Action subtype constructors,registration and event payload loader execute. Action target/category fields remain supplied from headers; target tables are empty. Playback6F78A0 is an explicit recording boundary returning false,so no successful playback is inferred.
- String/CRT storage and formatting,allocation,locks and definition getters use the declared adapters. The imported V725 source is unchanged; only its hook-registration statement is given a local handle to attach the composition hook.
- Voice BNK/WPK containers are parsed and hashed,not decoded or played. en_US directory names do not determine historical effective EUW/en_GB locale. SFX,media graph,current voice wiring,full skin loading,role producers and AIR selection remain separate.
- Renekton skin5 has original voice banks while examined UsesSkinVO flags are inactive. Preserve both facts and all configuration ambiguities; do not call resources unused,missing or corrupted.
- Le corpus volumineux reste dans le recu prive pine sur F,sans seconde copie. Sa presence est necessaire a la relecture detaillee.
- Les deux ordres testes sont declares,pas historiques. Les WPK sont parses sans decodage ni lecture.
- Les668taches PRESENT-AUDIO et SYS sont enrichies sans modifier leurs etats manuels. Aucune inconnue resolue automatiquement,aucune compilation Rust ou session graphique/sonore.
- Le lancement herite n avait aucun recu final ni processus actif. Une tentative a refuse le dossier deja present,puis le banc a refuse un comptage ambigu de sa ligne de branchement. La recherche a ete ancree a la ligne entiere dans une source distincte ;essais conserves.

## Fichiers et preuves

Le [reçu de liaison](fidelity_native_skin_voice_bank_links_v726.json) contient les associations et le chemin/empreinte du corpus privé. Les registres de tâches, traces et sources, les documents de couverture/reprise et les deux bases du plan sont enrichis.

Les scripts et preuves restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision726_*. Reçu natif : revision726_skin_voice_banks_verified/OBSERVATIONS.json. Livraison : revision726_delivery/VERIFIED.json puis INDEPENDENT_READBACK.json. Sauvegardes ciblées, sans copie intégrale des bases. Aucun code du jeu ou asset modifié. Le goal reste ouvert.
