# SYS-18.1-05 — couverture des rôles médias externes

2026-11-02T00:25:18.401984+00:00

Revue des2750chemins terminée avec bornes, sous réserve de relecture indépendante. Les rôles indéterminés,le fonctionnement audio/vidéo et les autres clauses du parent restent ouverts.

## Résultat
19familles de répertoires,18locales,2748MP3 et deuxFLV. Chaque chemin garde son identité native,son rôle ou sa recherche bornée,sa relation aux déclarations/noms et son admission de source séparée. Les140admissions antérieures sont conservées ; aucun téléchargement.
Les déclarations XML couvrent122candidats natifs déjà revus,288autres correspondances de template de locale et72variantes de casse. Le routage des noms natifs couvre1536chemins exacts et653associations de casse ;30autres noms de fichiers n’ont pas de producteur de nom établi. Une association insensible à la casse ne démontre pas File.exists historique.
59chemins restent sans liaison de rôle établie dans les périmètres décrits :30noms vocaux,26autres fichiers,un Gnar à la racine pl_PL et deux fichiers tutoriel hors nom XML. Leurs identités,recherches sauvegardées,conditions de reprise et59IDs documentaires stables figurent dans les matrices. Aucun fichier n’est déclaré globalement inutilisé/corrompu ou renommé.
Les dix clés seulement constantes dans la revue XML restent bornées ; une déclaration de fichier ne devient pas automatiquement un parcours fonctionnel.

## Deux nouveaux consommateurs de thème identifiés
Deux SWF natifs déjà admis ont été décompilés statiquement avec Java/JPEXS existants :132scripts exportés,huit classes examinées. Aucun code ActionScript,codec ou média exécuté.
La propriété themeWatchPath mène à la liste du répertoire flv. Le type loop est transmis à addPrimaryClip puis à FLVMovieClip et DataLoader au format binaire via un chemin relatif. La base URL effective et le contexte host restent ouverts. La branche localizedIntro construit HowlingAbyss/lore.mp3 avec lang ;18chemins natifs correspondent à cette famille,mais les deux thèmes n’ont que login-loop.flv dans le manifeste sélectionné. Des fichiers physiques additionnels restent possibles sur le host.
Quatre MP3 de thème ont aussi une demande directe conditionnelle dans ces scripts. Les fichiers ambient de même basename ne leur sont pas substitués. Deux références optionnelles music/LoginScreenSFX.mp3 ne sont pas listées : elles restent sans payload,avec la garde File.exists et une condition de reprise. Elles s’ajoutent séparément aux neuf candidats XML non listés.

## Limites et reprise
Le rôle/la recherche bornée,les octets disponibles,l’implémentation et l’acceptation sont quatre faits distincts. Les2610payloads non admis gardent leurs identités ; leur récupération ne résout pas à elle seule les59inconnues de rôle ou les725bornes de casse.
La recherche actuelle frontend/Tauri est réutilisée à identité inchangée et garde son périmètre. Elle ne démontre aucune absence de tout le moteur. Les transitions,streams embarqués,scènes et cycles réels ne sont pas validés par cette revue.
Prochain lot : contrat de cycle FLV des deux thèmes,avec URL/base,DataLoader,callbacks,appendBytes,boucle,flags son/VO et nettoyage. Les132scripts sont déjà disponibles ; aucune nouvelle décompilation/téléchargement sans question justifiée.

## Contrôles et écritures
Matrice native intégrale,identités et fenêtres exactes,réutilisation des reçus sélectionnés,corpus actuel et fichiers protégés contrôlés. Le lecteur indépendant vérifie les classifications et les exclusions de jointure par basename/casse. Reçus séparés ; accepted-delivery.json sélectionne la preuve technique.
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-05-EXTERNAL-MEDIA-ROLE-COVERAGE-01 et ce rapport,plus préparations/exports texte E. Aucun goal,critère,registre,code produit,Plan ou base modifié ; aucune installation,migration,relance,suppression ou écoute.
