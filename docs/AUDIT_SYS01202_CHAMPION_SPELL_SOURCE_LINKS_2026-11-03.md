# Audit de traçabilité — ressources Q/W/E/R du catalogue de champions (2026-11-03)

## Périmètre et décision

Unité AUD-SYS-01.2-02-CHAMPION-SPELL-SOURCE-LINKS-01. Question : les fiches CH-<champion>-<Q/W/E/R>-… pointent-elles vers la ressource native indiquée par l'export local pour ce couple, et les fichiers natifs correspondants ont-ils toujours les identités enregistrées ? L'audit de cette correspondance et de ces octets est clos pour le snapshot identifié. Il ne clôt aucune mécanique de champion, aucun audit complet de source individuelle et aucune acceptation.

## Entrées et liens

Référence du projet : client PUBLIC 4.20.0.315 EUW/en_GB; data/4.20/native_spells_420.json est un export local de référence, pas le serveur original. La sélection a lu toutes les exigences du registre correspondant à `^CH-(.+?)-(Q|W|E|R)-(.+)$` sans distinguer majuscules/minuscules; l'export est indexé par champion et slot 0/1/2/3. Cela produit 7 082 fiches et 488 couples distincts (122 champions × quatre slots); Q/W/E ont chacun 1 830 fiches et R en a 1 592. Les fiches comprennent des parents et des sous-tâches : ne pas les additionner comme 7 082 audits atomiques terminés ou utiliser ce chiffre comme progression du jeu.

Chaque fiche sélectionnée a exactement une liaison native_inputs de rôle native_spell_data. Son source_id pointe vers un chemin dont le suffixe, après normalisation des séparateurs et de la casse, correspond au champ native_resource de l'export pour le même champion et slot. Résultat attendu et observé : 7 082/7 082 correspondances, 488 couples et 488 source_id/chemins distincts, aucune ambiguïté dans ce périmètre. Un suffixe synthétiquement modifié ne passe pas le comparateur, en mémoire uniquement. Le résultat individuel par task_id, requirement_id et source_id est enregistré dans resultats.json.

Les chemins sont ceux du registre ; ils ont été résolus et limités à D:/LeagueOfLegendsV2/4.20 avant lecture. Les 488 fichiers ont été relus et leurs tailles et SHA-256 comparés aux identités enregistrées : 488/488 concordent, total 682 480 octets. Les chemins, tailles, hashes, noms d'export et ID sont dans la section pairs du reçu. Leurs octets concordent avec le registre; cela ne valide pas indépendamment leur provenance ni le contenu sémantique du fichier. Cette comparaison complète, pour ce périmètre, les identités partielles déjà reçues sans modifier les registres.

## Contrôle effectué et limites

Commande réellement exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/champion_spell_source_link_audit/probe.py`, code 0; lecture seule sur le projet et les sources D:, sortie dans E:/mapslol3v3. Aucun téléchargement, installation ou modification d'application/base. La sélection, les liaisons, identités, résultats individuels et exclusions sont reproductibles dans le script et le reçu.

Ce test compare deux artefacts locaux (trace et export), puis vérifie les octets du fichier associé. Il ne décode pas les 488 fichiers, ne prouve pas que les valeurs sont celles utilisées par un serveur historique et ne vérifie pas la correspondance de chacune des clauses avec sa sémantique. Aucune mécanique de sort, aucun client, aucun serveur et aucun GPU ne sont exécutés. Le contrôle de refus groupé V1110 montre séparément que, pour 118 champions, les quatre slots refusent les commandes testées; il ne dit rien sur l'authenticité de la ressource historique ni sur les quatre exceptions.

## Preuves

Entrées SHA-256 : docs/fidelity_requirement_trace_4_20.json 05e82921fde916bc1b576db7f9801b87e8223b866ad1bf1205a8d3e670e60a05; docs/fidelity_sources_4_20.json d8283f8872339087d5e2134f9342b06bc3e67d21514ce4149a1bf42b388fcc38; data/4.20/native_spells_420.json 0cae6f5c167aa852e8f86e7f3298d7c797727d5cc92616dcb856ac15c8af5d14. E:/mapslol3v3/champion_spell_source_link_audit/probe.py SHA-256 ecd37401642144ab67eac386d1eca4ed61a447295fb79d1580e248bfed2829e5; resultats.json 3531d928bbb243d3a2d18d338c1e5ff8ae06034fd8906af4f4e723a4f4d0b801. Tous les SHA de sources natives sont conservés un par un dans le reçu; ils constituent des comparaisons au registre, pas une certification externe.

## Écarts et reprise

Aucune correction de ces liaisons/identités n'est nécessaire sur le snapshot contrôlé. Réutiliser les tâches SOURCE et SIMULATION-CONTRAT de chaque capacité pour qualifier les champs et le comportement historique, puis SIMULATION, NETWORK, PRESENTATION et ACCEPTANCE pour le travail distinct sur le jeu. Reprendre une fiche en présence d'une source serveur attribuable, d'une capture historique mesurée, d'un mapping de champs ou d'un consumer courant nouveau; rejouer le contrôle de chemins/empreintes uniquement après modification ou anomalie. Les rôles de refus générique et les statuts des tâches ne sont pas modifiés.

Audit du lien de chemin et de l'identité des 488 fichiers terminé; implémentation et vérification du jeu non évaluées par ce lot, acceptation humaine non demandée. Parent SYS-01.2-02 toujours ouvert. Aucun goal, registre, application de suivi, base ou code produit modifié.
