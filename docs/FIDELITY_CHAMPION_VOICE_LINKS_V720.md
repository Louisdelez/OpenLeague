# SYS-01.2-02 — Sources et consommateurs des voix, V720

Projet F:/OpenLeague. Reference PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

V720 : les 732 fiches de voix des 122 champions sont reliees aux banques natives et aux limites precises des entrees actuelles.367 fichiers parses,2109 evenements,6246 entrees media,118 tables CSV et499 sources verifies. Six ancres actuelles sont des frontieres inspectees,aucune ne fournit les voix demandees. Deux tests PCM actuels passent sur31ambiances ; aucune voix de champion ni sortie sonore acceptee.

## Resultat

Les732fiches ne pointaient que vers champion_catalog. Elles contiennent maintenant les banques exactes et les points du launcher/client inspectes, avec une limite explicite : aucun fournisseur des voix demandees n est identifie par cet audit. Les122parents conservent leurs cinq sous-taches.

| Controle | Attendu | Observe |
|---|---|---|
| Identites de sources | Octets et SHA conformes au registre |499 conformes |
| Banques de base | Lecture bornee,version et tables coherentes |244 BNK v88,123 WPK v1 |
| Evenements | References Action presentes dans le meme ensemble champion |2109 evenements,aucune reference Action non resolue |
| Tables de correspondance | Conserver voix et effets distincts |118 CSV,120 lignes VO et986 SFX/autres |
| Refus de fausses preuves | Rejeter donnees tronquees/invalides et promotion de portee |6 refus observes |
| Catalogue PCM actuel |31ambiances valides,refus fichier absent/metadonnees fausses |2 tests passes |

## Limites et travail restant

- Les 244 BNK et123 WPK sont des conteneurs de voix de base. Les6246 entrees ne sont pas un nombre de repliques uniques. Lissandra possede deux WPK conserves distincts. Aucun decodage,ecoute ou comparaison de repliques de champion execute.
- Lecture bornee de BKHD v88,HIRC et index DIDX/r3d2 v1. Les2109evenements pointent vers des objets Action de type3 presents dans les banques de base du meme champion. Le contenu des autres objets reste opaque ; leur presence ne qualifie ni graphe de selection, ni priorites, ni temporisation, ni liaison aux medias effectivement joues.
- Les118 tables CSV contiennent986 lignes SFX/autres et120 lignes nommees Play_vo. Les effets de danse/mort ne sont pas automatiquement des voix parlees. Azir,FiddleSticks,Kalista,KogMaw ne correspondent pas au motif de table de base recherche dans le registre ; ce resultat ne prouve pas une absence globale de sources ou de voix.
- Le nom de repertoire en_US est conserve. Les sources sont deja recensees comme payload du projet en_GB selectionne ; leurs octets sont reverifies ici. Ni l appartenance RADS historique ni le choix de locale effectif ne sont rejoues dans cet audit.
- Selection : le cue AIR specifique reste non identifie dans cet audit ; les banques VO du jeu sont un contexte candidat, sans equivalence supposee avec la voix de selection. Deplacement,attaque,mort et emotes : mapping role/evenement original a qualifier.
- Le launcher remplit la liste des champions et lance la session ; les commandes et snapshots du jeu exposent des entrees possibles. Le catalogue PCM inspecte ne charge que31ambiances ; les autres chemins audio identifies concernent la carte et quatre sons de sorts Ezreal. Aucun de ces composants n est promu en fournisseur des732fiches de voix.
- Recherche de sources dans1147fichiers actuels et inspection des points d entree : ce n est pas une preuve universelle d absence. Les six nouveaux consommateurs ont provides_feature_consumer=false. Le chargeur generique historique et les preuves precedentes restent conserves.
- Deux tests existants ont ete executes sur le binaire V719 dont les1275sources/manifests sont inchanges :31PCM reels et refus de fichier absent ou de metadonnees modifiees. Pas de nouvelle compilation,client natif,peripherique audio ou ecoute ; dependances du build V719 en cache.
- Le premier essai prive s est arrete sur un script auxiliaire absent du registre de sources. La version corrigee conserve ce script comme provenance verifiee separee ; ce n etait pas une ressource audio corrompue. Aucune publication de cet essai.
- Aucun etat manuel,acceptation,inconnu ou prerequis n est ferme. Skins,variantes,langues,annonces et branchement complet restent ouverts.

## Integration et conservation

Les732fiches et SYS-01.2-02 sont enrichies dans completion_tasks,fidelity_requirement_trace et les deux bases SQLite du plan. Six ancres de code sont ajoutees au registre sans revendiquer de fonctionnalite. Le rapport et [recu detaille](fidelity_champion_voice_links_v720.json) sont lies aux fiches et a leur texte copiable.

Le script verifie la coherence des liens,les deux lecteurs Store.task/copy_text,la synchronisation idempotente,PRAGMA quick_check et la conservation des autres lignes,cases,notes et historiques. Resultat terminal dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision720_delivery/VERIFIED.json.

Fichiers modifies : rapport,recu,completion_tasks,fidelity_requirement_trace,fidelity_sources,coverage,completion_plan,resume_checkpoint,CURRENT,HANDOFF et les deux bases du plan. Scripts,tests,observations et deltas cibles restent sur F:/OpenLeague-work. Aucun code du jeu,asset ou fichier original modifie ; aucune copie integrale des bases.

Le goal et les fiches restent ouverts. Cette livraison ne termine pas l audio des champions ou le jeu.
