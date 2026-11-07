# SYS-01.2-02 — Recensement des liens et utilisation de REA, V784

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. La tâche reste partielle.

## Résultat

Le recensement traverse les 42 215 exigences, les 5 740 consommateurs enregistrés et leurs 584 fichiers réels. Les empreintes SHA256, les numéros de ligne, les extraits attendus et l’affectation aux tâches concordent tous. Une seconde lecture indépendante du recensement retrouve les mêmes liens. Ce contrôle porte sur leur identité ; il ne valide pas le comportement des 42 215 exigences.

| Contrôle | Attendu | Observé |
| --- | --- | --- |
| Liens actuels | Fichier, empreinte et ligne conformes au registre | 5 740 / 5 740 |
| Ressources du PE original par REA | Identités type/nom/langue, RVA, offset, taille, code page et SHA256 conformes à un second parseur | 10 / 10 |
| Intégrité des preuves | Refuser une empreinte, une ligne ou un extrait falsifiés | 3 refus / 3 |
| Ressource falsifiée | Refuser le SHA256 de payload modifié dans une copie de la réponse | 1 refus / 1 |

Les refus ci-dessus sont des contrôles de preuves ; ils ne sont pas des tests des erreurs du jeu.

## Travail encore partiel recensé

1 964 exigences n’ont que des consommateurs déclarés génériques ou limités à une frontière d’entrée :

| Famille | Exigences |
| --- | ---: |
| Runes | 1 184 |
| Maîtrises | 285 |
| Système | 347 |
| Localisation | 76 |
| Ressources vides | 72 |

Ces catégories proviennent du registre actuel. Elles ne représentent ni un pourcentage de jeu terminé, ni un inventaire exhaustif de tous les défauts. Les autres liens peuvent eux aussi rester partiels sur leur sémantique. Le graphe conserve 19 940 exigences au statut partial_with_open_questions et 26 189 inconnues ouvertes ; aucune n’est clôturée ici.

384 exigences n’ont aucune entrée dans native_inputs. 316 possèdent déjà local_contract_basis. Parmi les 68 restantes figurent les références communautaires, la livraison locale, les contrats de distribution, deux exigences de combat et les cinq exigences Battle Training. Une absence d’entrée native dans le registre ne prouve ni qu’un asset manque sur disque, ni que l’exigence est inapplicable. Les contrats locaux ne doivent pas recevoir une provenance Riot inventée.

Le fichier de recensement contient les listes par identifiant de tâche, leurs consommateurs, les inconnues associées et les catégories d’écart. Les vérifications runes/maîtrises de V57 restent des preuves antérieures ; elles ne sont pas rejouées ni promues en effets de jeu complets.

## REA réellement utilisé

Version locale : rea-agents 6.4.0. Commande exécutée : inspect-pe-resources sur le client original, avec sortie JSON. Code de retour 0. Fournisseur de cette opération : rea-pe-resources. Le résultat est recoupé avec pefile et les octets du PE. Ghidra et les décompilations V783 restent des analyses antérieures, non réexécutées dans cette révision.

Binaire : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.

Taille : 15 973 880 octets. SHA256 avant/après identique : 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Le jeu original n’a pas été exécuté. Aucun nouveau test Rust, aucune capture audio, aucun téléchargement ni installation. Les nouveaux scripts, sorties et temporaires sont sur F. Les installations REA/Ghidra existantes sur E sont réutilisées.

## Sources et livrables

- docs/fidelity_rea_audio_registry_census_v784.json : preuve liée à SYS-01.2-02, sources, prérequis et limites.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision784_registry_census/OBSERVATIONS.json : recensement complet et listes de travail.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision784_rea_resources/RECEIPT.json : commande et fichiers REA identifiés.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision784_associations/OBSERVATIONS.json : recoupement et refus de preuves altérées.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision784_delivery/ : deltas ciblés, résultats de publication et relecture.

La publication ajoute les preuves à une fiche dans les registres et les deux bases du plan. Les cases, notes personnelles, historiques, prérequis et inconnues sont conservés. Le code Rust et les assets restent inchangés. Les fichiers de couverture et de reprise consignent ce contrôle sans promotion de statut.

## Suite

Continuer SYS-01.2-02 sur F avec REA. Exploiter le recensement V784 pour sélectionner les associations précises encore partielles, sans refaire les refus runes/maîtrises déjà prouvés en V57. Les 384 exigences sans native_inputs incluent 316 contrats locaux explicites ; qualifier les 68 autres individuellement sans inventer une source Riot. Pour la chaîne audio V783 : qualifier les trois événements environnementaux à plusieurs actions, leur sélection et leurs voix simultanées ; examiner le caller7067B0 et le chemin706910/704A00 avec les vrais contrats de registre. Garder ouverts les autres écarts recensés, les services physiques et l’intégration du backend. Préserver sources, preuves et états manuels ; ne pas convertir un contrôle d’identité en validation du jeu.
