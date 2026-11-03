# Méthode d’audit OpenLeague — documentation uniquement

Référence normative : AUDIT_CHARTER.md. Aucun changement d’application,interface,base,installation ou migration dans ce lot.

## Lot terminable

Avant de commencer,consigner : ID de l’unité,exigence parente,périmètre exact,question,résultat attendu,critères de sortie,entrées nécessaires,preuves déjà acquises et condition d’arrêt. Garder un seul lot actif ; deux seulement s’ils sont indépendants et explicitement recensés. Conclure le lot avant de changer de sujet.

Exécuter ensuite : lire les sources et consommateurs réels ; effectuer seulement les actions autorisées ; vérifier les cas pertinents ; enregistrer les preuves ; relire les sept rubriques ; clore uniquement le périmètre établi ; nommer les autres clauses ouvertes.

Une correction révélée par l’audit est une fiche documentaire ou une référence à une tâche existante. Ne pas modifier les registres ou bases du plan sous la restriction actuelle et ne pas exécuter cette correction implicitement.

## Fiche de correction

Réutiliser d’abord une tâche existante correspondant réellement au même objectif. Sinon proposer un ID stable et un objectif unique,avec comportement attendu,sources et limites,fichiers/consommateurs inspectés,prérequis,dépendances,travail,critères de fin,contrôles,preuves attendues et condition de reprise. Découper par champion,mécanique,ressource ou comportement livrable indépendamment. Conserver les autres tâches et leurs preuves.

## Contrat de recherche et usage de REA

Pour chaque recherche :

- Question exacte.
- Preuves déjà disponibles,avec date et limites.
- Nouvel élément recherché et raison de sa nécessité.
- Décision que ce résultat permettra de prendre.
- Condition d’arrêt ou de réorientation.

REA est pertinent lorsque le client original peut répondre à cette question. Privilégier les ressources natives disponibles. Ne pas répéter une analyse ou un test inchangé sans nouvelle source,modification,anomalie ou hypothèse. Une piste sans résultat exploitable reçoit une limite et une condition précise de reprise. Distinguer analyse statique,exécution native isolée,simulation Rust,réseau et rendu du client réel.

## Interpréteur et portée de requirement_trace

Utiliser l’interpréteur déjà installé du dépôt pour les validations complètes : `.ai-tools/.venv/Scripts/python.exe` sur Windows (Python 3.12+). Dans cette reprise, Python système 3.10.11 échoue dans `source_versions.py` sur `Path.is_junction`; l’environnement du dépôt est Python 3.12.14 et réussit la validation structurelle. Ne pas installer un autre interpréteur pour contourner ce problème.

Nommer explicitement la portée du contrôle : `requirement_trace.validate(..., verify_files=False)` vérifie les schémas, identités, liens, comptes et conditions de version; son résultat `source_hashes_verified=0` ne prouve pas les octets ni les ancres sur disque. `verify-files` ajoute les vérifications d’ancres et de SHA-256 pour chaque source, uniquement dans les racines autorisées par le code. Si le registre référence une racine hors allowlist, ne pas l’ajouter par supposition; consigner le nombre et laisser ces fichiers non vérifiés jusqu’à une décision de provenance/périmètre. Une vérification structurelle réussie ne clôt pas les questions sémantiques ou gameplay.

## Parcours complets à qualifier dans des audits distincts

| Parcours | Prérequis | Critères observables minimaux |
|---|---|---|
|Sélection|Launcher et catalogue identifiés|Choix conservé,entrée invalide refusée,commande correcte transmise|
|Chargement|Serveur,versions des binaires et assets identifiés|Carte et champion chargés,erreurs de ressources signalées|
|Entrée en partie|Deux clients et serveur locaux prêts|Admission unique,équipes et état partagé observés|
|Déplacement et combat|Clients admis,champion et capacité nommés|Déplacement,collision,attaque,sort et synchronisation observés|
|Mort et réapparition|Combat disponible,règle temporelle explicite|Mort,refus pendant la mort,délai et réapparition synchronisée|
|Déconnexion et reconnexion|Session et identifiants observés|Perte,reprise,sans double admission,état réconcilié|
|Fin de partie|Condition de victoire définie|Victoire,résultat,refus des commandes finales et retour du launcher|

Chaque audit précise ses propres versions,étendue,critères et limites. Ces lignes sont des définitions de parcours ; aucune n’est déclarée exécutée ici. Un test isolé ou un fragment ne valide pas tout un parcours réel.

## Gabarit de compte rendu

- ID et exigence parente ; portée et clauses exclues.
- Audit / implémentation / vérification / acceptation humaine,avec justifications distinctes.
- Sources ou recherches infructueuses ; identités,provenance et limites.
- Consommateurs réels ou recherche d’absence,avec chemins et bornes.
- Attendu / observé / contrôles exécutés / contrôles non exécutés.
- Écarts,conclusions indéterminées et entrée nécessaire à la reprise.
- Corrections réutilisées ou proposées,leurs critères et dépendances.
- Preuves datées ; relecture des sept critères ; décision de clôture limitée à la portée établie.

Le bilan hebdomadaire compare des résultats identifiés : audits clos,écarts corrigés,parcours vérifiés,blocages levés et lacunes nouvelles. Ajouter réouvertures et changements de dénominateur ; ne pas remplacer les résultats par un volume de documents ou de liens.

## Contrôle des géométries dessinées

Un recensement par motifs de propriétés (`x/y`, `width/height`, `setSize`, `layout`, etc.) n’est pas un détecteur exhaustif de géométrie. Un résultat `geometry_hits = 0` signifie uniquement « aucun hit du motif enregistré » ; ne pas conclure à l’absence de dessin, de taille ou d’écran avant le contrôle ciblé des méthodes.

Pour chaque source de composant d’écran, relever aussi les appels vectoriels/dessin tels que `Graphics.drawCircle`, `drawEllipse`, `drawRect`, `drawRoundRect`, `moveTo`, `lineTo`, `curveTo`, `beginFill` et `lineStyle`, ainsi que les dessins de sprite/chemin et les placements de timeline. Élargir aux primitives réellement utilisées par la source. Épingler les fenêtres de méthodes et l’empreinte source; préciser centre, rayon, bornes, pas angulaire, couleurs et unités locales quand le code les définit.

Pour toute géométrie paramétrée, suivre uniquement les interfaces/appels directs nécessaires afin d’établir le type, la plage, les gardes finies/NaN, l’état et le cadenceur. Une plage ou un producteur non retrouvé reste inconnu; un risque statique ne devient pas un échec reproduit. Séparer les unités Graphics locales des twips, pixels écran et mesures DOM; ne pas convertir sans preuve des transformations, DPI, scale et clipping.

Si une primitive non couverte révèle un faux négatif, conserver le census antérieur, rédiger un supplément limité au composant concerné et réouvrir les conclusions de famille qui reposaient sur l’absence de hit. Ne pas relancer toute l’extraction : étendre le contrôle aux classes sources nommées par la même piste, puis clore seulement les lots effectivement vérifiés.

Déclencheur de cette règle : le 2026-11-02, `LoginQueueStatusPane.drawPieGraphics` du client 4.20 dessinait un cercle/secteur alors que le motif du census ignorait les primitives `Graphics`; voir l’unité `AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01-009-LOGIN-STATUS-PIE-GRAPHICS-CONTRACT-01`.
## Méthode de reprise après le lot de traçabilité — 2026-11-02

AUD-SYS-01.2-02-TRACE-ANCHORS-01 est clos uniquement pour la structure du registre et la présence de ses ancres. Il ne qualifie ni la pertinence des liens, ni les octets de tout le corpus source, ni le runtime. Les résultats, commandes, inconnues et conditions de reprise sont consignés dans docs/AUDIT_SYS01202_TRACE_ANCHORS_2026-11-02.md.

Pour le prochain lot, choisir une seule exigence ouverte qui n’a pas déjà une preuve complète. Réutiliser d’abord ses reçus existants; vérifier seulement les deux extrémités précises nécessaires à la question. Définir avant recherche le résultat attendu, les refus/limites utiles et la condition d’arrêt. Clore l’audit si les sept critères sont satisfaits, même si la fonctionnalité manque, mais laisser distincts les états d’audit, d’implémentation, de vérification runtime et d’acceptation humaine. Si source ou consommateur manque, enregistrer l’ID, le chemin, les recherches bornées réellement faites et l’élément exact qui permettrait une reprise. Ne pas rejouer une commande ou recherche inchangée sans nouvelle piste.

La vérification globale d’ancres ne doit être répétée qu’après une modification du registre, de la source ou une anomalie nouvelle. Les chemins historiques hors racines admises restent non vérifiés jusqu’à preuve de leur identité et d’une politique de référence explicite; ne pas modifier cette politique par supposition. Le parent SYS-01.2-02 reste actif et partiel.
## Audit de traçabilité par champion — unité et preuve

Traiter un champion et une capacité à la fois. Séparer les ressources client, les scripts serveur, les tooltips du catalogue, les données statistiques locales et les consommateur(s) de jeu courant. Revalider l’identité/taille/empreinte du seul fichier source nécessaire et réutiliser le membership ou les reçus déjà vérifiés. Si un lecteur existant convient, l’exécuter en lecture seule sur la ressource nommée; un deuxième lecteur n’est utile que pour lever un doute de décodage concret.

Inspecter la structure des données et l’appel du code courant. Un chargeur de statistiques ne prouve pas un passif; une référence d’asset, une fixture ou une description officielle ne prouve pas la mécanique serveur. Une recherche négative nomme son périmètre et les occurrences non comportementales. Clore l’audit lorsque le consommateur exact ou son absence est établi, même si l’implémentation manque. Garder séparées les questions d’identité native, de sémantique, de runtime et d’acceptation. Reprendre une recherche seulement à l’apparition d’un artefact serveur, d’un mapping de clés ou d’un nouveau callsite.