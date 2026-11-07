# SYS-18.1-02 — images du patcher : audit des sources terminé

2026-11-01T18:09:39.932487+00:00

Audit documentaire terminé. Fonctionnalité d’extraction/intégration non terminée. Le statut normatif reste a_faire;aucun goal,critère,registre,Plan,application ou base modifié.

Extraire les images du patcher depuis les fichiers fournis
Le résultat « Extraire les images du patcher depuis les fichiers fournis » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Résultat concret
Les12LOAD qualifiés contiennent895membres,dont252images raster. Deux DataPackV4 CEF contiennent954PNG(477à100%,477à200%);le troisième contient400ressources de locale,non des images. Les21PE natifs contiennent15imagesICO/BMP exposées en enveloppes par7z et54ressourcesRT_CURSOR. Total1275occurrences de sources:1221rasters décodés,54curseurs non vérifiés pour le rendu. Les rasters ont1106payloads distincts;ce ne sont pas1275images de l’interface publique.
1221rasters: intégrité vérifiée puis chargement RGBA de toutes les frames parPillow,en mémoire seulement. Aucun rendu natif/ICC/GUI/GPU,aucune image individuelle écrite. Les35fauxéchecs de la première collecte sont desGROUP_ICON/GROUP_CURSOR,qualifiés par en-tête/table:54descripteurs au total restent séparés des images.
22polices(dont1SVGfont),731itemsICU,types natifs de métadonnées/dialogue et1BINDATA RIFF/WAVE distingués. Le WAV n’a pas été joué. Les2webm et3ogg du manifeste sont des médias vidéo/audio,hors extraction d’images statiques;pas déclarés manquants. Aucune data:image littérale détectée dans les membres UTF8 inspectés;contenu distant/dynamique non téléchargé.
Toutes les sources natives candidates contrôlées sont conformes au MD5/à la taille de la release lol_patcher0.0.0.11. Le build patcher0.4.0.122 est distinct du build AIR et du jeu4.20.0.315.

## Consommateurs et travail restant
L’outil documentaire tools/project-plan/patcher_reference.py:18 load_members sélectionne encore les7LOAD du contrat existant. main():124..127 décode --member enUTF8 et imprime;ce chemin n’écrit pas les images binaires. Cet audit n’appelle ni verify() ni main(),et ne change pas le contrat.
Le frontend courant index.html/style.css référence9fichiers AIR420(7images/2polices). Une icône native Tauri séparée est comparée comme dixième entrée;build.rs etgenerate_context! sont inspectés,aucune fenêtre n’est exécutée. Aucun match d’octets ou de pixels normalisés avec les sources patcher comparées. Les fichiers générés target ne sont pas pris pour de nouvelles sources.
La requête de noms CEF/LOAD/ressources sur1168fichiers courants retourne0hit(code1,sanserreur)en15lots bornés. Cela ne prouve pas l’absence de tout consommateur possible.217des252imagesLOAD ont une référence de basename dans621membresUTF8;35n’en ont pas. Une présence littérale,unIDPAK ou unRTPE ne prouve pas affichage public,résolution d’URL ou routage.
Chaque occurrence possède source_id,conteneur épinglé,offset ou membre,type,SHA et consommateur borné dans patcher_image_consumer_observations.json. Les sorties de décodage/frames sont dans patcher_image_coverage_observations_v2.json.

## Sources de format
[Chromium DataPack:V4](https://github.com/chromium/chromium/blob/main/ui/base/resource/data_pack.cc),[7-Zip25.01 PE resources](https://github.com/ip7z/7zip/blob/25.01/CPP/7zip/Archive/PeHandler.cpp),[ICU common-data TOC](https://github.com/unicode-org/icu/blob/main/icu4c/source/common/ucmndata.h). Copies textuelles épinglées;commits upstream Chromium/ICU non établis. Les enveloppes ICO/BMP sont dérivées par7z,leurSHA n’est pas présenté comme celui duRTbrut;lePE natif est identifié.

## Vérifications attendues / observées

### SOURCE
Attendu : Qualifier les12LOAD et les images horsLOAD de la release native,avec origine et identités.
Observé : 252rasterLOAD,954PNGdans2PAK,15imagesPE enveloppées par7z et54curseursRT_CURSOR;3PAK/21PE/ICU conformesMD5natif.
Limite : 1275occurrences de sources,1106payloadsraster distincts;aucun nombre ne mesure les écrans publics ou le jeu complet.

### PIXELS
Attendu : Décodage réel de chaque raster,frames comprises;distinguer descripteurs/polices/autresdonnées.
Observé : 1221raster vérifiés et décodés enmémoire;35fauxéchecs corrigés enGROUP_*;54curseurs sanspreuvepixel.22polices et731itemsICU distingués.
Limite : RGBA normalisé parPillow,nativeICC/GUI/GPU/curseurs nonvalidés;pas de fichierimage exporté.

### CONSUMERS
Attendu : Examiner outil d’extraction et consommateur courant sans supposer un manque.
Observé : load_members/--member relus;10assetsfront+icône comparés,0matchoctet/pixel;requêteexacte1168fichiers15lotsaucunhit;217images avecbasenamelittéral.
Limite : Absence bornée aux entrées etmotifsexacts inspectés;pas preuve d’absence sémantique globale ou de rendu.

### REFUSALS
Attendu : Refuser formats nonadmis et borneshorsfichier danslelecteur documentaire.
Observé : FixtureV4admis;entêtetronqué,V5 etoffsethorsbornes refusés;WinError206 préparatoire corrigéavantque rg démarre.
Limite : Refus locaux de l’outil d’audit,pas erreurs originales de LoL ni tests de jeu.

## Manques et conditions de reprise

### PATCHER-IMAGE-INSTALLATION — SYS-18.1-02
Aucun export individuel de ces1275occurrences dans le produit. Le contrat documentaire load_members sélectionne7sources,pas12; --member décode UTF8. Aucune égalité d’octets/pixels avec les10entrées comparées du launcher actuel.
Reprise : Utiliser la matrice source_matrix de ce lot,les12LOAD qualifiés et le manifeste RLSM; choisir explicitement chaque source et sa destination binaire sûre,conserver SHA/provenance/doublons. Distinguer médias UI/CEF/diagnostic et groupes descripteurs. Toute modification produit/contrat reste hors de cette intervention.

### PATCHER-NATIVE-CURSOR-COMPOSITING — SYS-18.1-02
54RT_CURSOR identifiés par module/type/hotspot/DIB; masque,alpha,taille visible et rendu natif non décodés ou validés. Ils ne sont pas déclarés corrompus.
Reprise : Reprendre ces54source_id précis et leurs ressources du PE identifié; matérialiser un curseur et contrôler hotspot,masques,dimensions puis affichage dans un travail autorisé. Les54GROUP_* restent des tables de références,non des images.

### PATCHER-NATIVE-ROUTES-AND-RENDER — SYS-18.1-06..08
217imagesLOAD ont une référence littérale de basename,35n’en ont pas;954imagesPAK et69ressourcesPE ne sont pas automatiquement des écrans publics. Aucun lancement,routage,service,historique d’affichage ou acceptation humaine n’est prouvé.
Reprise : Associer les images aux écrans admis par AUD-18.1-01; résoudre les URL/états et conditions de services exacts avant comparaison de rendu. Ne pas rechercher à nouveau les mêmes archives sans nouvelle piste.

## Échecs conservés et maîtrise du périmètre
La première classification a confondu les tables GROUP_* avec des fichiersICO/CUR;le JSON initial est conservé et la correction est séparée.Les1221décodages réussis ne sont pas rejoués. Une commande rg avec1168chemins dépassait la limite Windows(WinError206)avant lancement;la requête a été répartie en15lots. Une lecture de contexte visait un ancien nom de preuve inexistant;chemin corrigé,sans écriture. Ces erreurs d’outillage ne sont pas des défauts de LoL.
Trois fixtures locales de lecteur refusées(entêtetronqué,V5nonadmis,offsethorsbornes),et une fixtureV4 admise:contrôles du parseur documentaire uniquement. Le lecteur de livraison distinct vérifie identités,liens,comptages,origines et frontières;il ne rejoue pas les anciens lecteurs ou le décodage graphique.

## Sept rubriques
- 1 : Contrat canonique SYS-18.1-02 inchangé;extraction produit/acceptation séparées.
- 2 : Sources natives et12LOADépinglés;formats primaires et895membres qualifiés;aucun downloadrejoué.
- 3 : load_members/--member etfrontendTauri inspectés;absence byte/pixel bornée.
- 4 : Décodage1221raster,ressourcesPE statiques et3refus lecteur réellement exécutés;sans jeu/GUI.
- 5 : Exports,intégration,54curseurs etrendu ouverts avecconditions de reprise.
- 6 : Pas de nouvelle tâche générale;les matrices détaillent SYS-18.1-02 et tâchesécrans existantes.
- 7 : Livrables,provenance,échecs conservés,lecteurdistinct etfichiersprotégés vérifiés.

## Livraison et suite
Ajouts uniquement: F:\OpenLeague-work\audit-units\AUD-18.1-02-PATCHER-IMAGE-COVERAGE-01 etce rapport. Preuve principale patcher-image-proof.json,inputs.json,inventaires et scripts propres au lot,reçus réels du producteur et du lecteur. Aucun fichier existant réécrit;aucune installation,migration,modification produit,goal,Plan oubase.
Clôture documentaire de SYS-18.1-02 sous réserve de relecture distincte;ni jeu/launcher ni fonctionnalité terminés.
Prochain lot : AUD-18.1-03-AIR-IMAGE-ATLAS-ADMISSIBILITY-01 — Qualifier la couverture des images et atlas AIR à partir des SWF natifs,des extractions déjà conservées et du consommateur actuel.
