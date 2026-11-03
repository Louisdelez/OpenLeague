# SYS-18.1-05 — sources de repli Azir et Braum

2026-11-01T23:43:53.848798+00:00

Audit de deux sources natives terminé, sous réserve de relecture indépendante. Aucun fonctionnement audio ou champion complet déclaré.

## Résolu
- Azir : assets/sounds/en_US/champions/Azir.mp3, contenu0.0.1.106,230194octets,MD52d5dc4a139e951d7548cc4d05035873a.
- Braum : assets/sounds/en_US/champions/Braum.mp3, contenu0.0.1.86,105533octets,MD52a09ed91e4e92bdc3cbde3d426df396e.
- Les fichiers sont conservés sous F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-AZIR-BRAUM-FALLBACK-SOURCES-01\payloads. Les SHA256,descripteurs et sources archive sont dans les preuves JSON. Dix emplacements locaux étaient absents ; aucune admission antérieure n’avait la même taille/MD5.
- Les deux liens natifs réutilisés identifient ChampionGeneratedData -> Champion.skinName -> provider. Les sources en_US sont des candidats conditionnels du repli en_GB, pas une observation de File.exists ou du son.

## Vérifications
Deux correspondances exactes d’index, avec leurs600autres candidats de même basename exclus de la sélection. Releases distinctes conservées. L’heure d’archivage n’est pas utilisée comme date de build.
Deux descripteurs et32chunks composent les335727octets natifs. Quatre réponsesHTTP206,267245octets de corps conservés,aucun échec. La table existante est interrogée pour ces nouvelles identités ; son ancien checksum n’est pas rejoué. Zstandard décompresse l’archive ; aucun codec MP3 ou média n’est exécuté.
Le lecteur indépendant reconstruit les deux fichiers depuis les fragments conservés et vérifie les cas de taille/MD5 altérés en mémoire ; il ne refait aucun téléchargement. Les reçus producteur/lecteur et accepted-delivery.json portent la sélection technique.

## Reste et reprise
Les124admissions précédentes sont préservées :126chemins sur2750ont maintenant des octets admis ;2624restent sans payload admis,214467731octets déclarés sommés par chemin. Ce compteur concerne les sources de référence, pas un pourcentage de jeu terminé.
Le repli effectif,la résolution de casse Leblanc/Velkoz,la page boutique historique,Permission.mp3,les skins/voix en jeu et les autres séquences/transitions restent ouverts. Les conditions de reprise du lot précédent sont conservées.
Prochain lot fini : les deux sources en_GB LeBlanc.mp3 et VelKoz.mp3. Admettre les octets ne démontrera pas la résolution historique de casse ; aucun renommage ou alias implicite.
Les tâches et écarts existants sont réutilisés. La recherche frontend/Tauri déjà qualifiée reste bornée ; elle ne prouve pas une absence dans tout le moteur.

## Écritures
Ajouts uniquement : nouveau dossier de sources F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-AZIR-BRAUM-FALLBACK-SOURCES-01,nouveau lot F:\OpenLeague-work\audit-units\AUD-18.1-05-AZIR-BRAUM-FALLBACK-SOURCES-01 et ce rapport ; sources de travail E conservées. Aucun goal,critère,registre,code produit,Plan ou base modifié ; aucune installation,migration,relance,suppression ou écoute.
