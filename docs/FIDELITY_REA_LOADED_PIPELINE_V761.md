# SYS-01.2-02 — Banques chargées vers le décodage, V761

Projet F:/OpenLeague, référence PUBLIC4.20.0.315. Source/consommateur pour SYS-01.2-02 et SYS-02.2-07. Aucun code produit ni asset modifié. Le goal et le jeu restent incomplets.

## Résultat natif

Init, ENV_Map10_SFX_events, NPC_Map10_SFX_events et les trois banques audio ENV_Map10_SFX_audio, ENV_Global_SFX_audio, NPC_Map10_SFX_audio sont chargés entiers par AF9D40. Les cinq banques après Init sont conservées simultanément. Le lecteur produit194Sound et164descripteurs médias de36octets. Les sources intégrées aux Sound à+0x58 et les tableaux de propriétaires sont réellement produits, non fournis par le banc.

B01E00/AF94A0 sélectionnent les médias ; B27D40 crée leurs décodeurs Vorbis. Les31flux résidents produisent9066blocs et4633573échantillons. Chaque hash F32 recalculé correspond exactement à V753. Les anciennes sorties sont réutilisées après cette comparaison pour éviter des copies. Les WAV convertis diffèrent au plus de1unité PCM16.

Avant chargement audio,31recherches rendent pointeur et taille nuls, owner-out conservé : absence attendue, pas un code d’erreur natif. En lecture, références du descripteur et du propriétaire passent1→2. B02040 libère le descripteur ; le banc appelle explicitement AFBFD0 pour l’emprunt propriétaire. Chaque flux restaure l’état chargé. Les cinq banques sont ensuite détachées et détruites ; Init, gestionnaires et caches de noms restent vivants. Le bilan exact figure dans audit.statistics.

## Rust actuel

37modules complets inchangés, Cargo offline/locked, compilation et exécution vérifiées :

- 31recherches sans médias concordent avec le natif.
- 31lookup et31release refusent les descripteurs complets36 avec InvalidAllocation.
- 31comparaisons sélection/références/libération concordent sous projection diagnostique32 déclarée ; cela ne qualifie pas le chargeur courant.
- Les31paires Sound/média concordent avec le catalogue d’ambiance, qui ne fournit pas de fabrique de décodeurs.
- 31WEM refusés ;31WAV convertis entièrement décodés/lus,4633573échantillons comparés, écart maximal1PCM16. Sortie vide et fin de lecture vérifiées.

Cinq rôles existants réutilisés : lookup/release, ambient_contract, decode, Playback::read. Anciennes qualifications conservées, aucun rôle dupliqué.

## REA et preuves

REA6.4.0/Ghidra12.1.4 analysent11fonctions du PE complet parmi12adresses demandées : B226A0,B22AF0,B01E00,B02040,B27D40,B093C0,B3F360,B3F720,B3F620,B09970,AF94A0,AFBFD0. Instructions, références et blocs exécutés recoupés avec le PE ; session exportée et fermée. B3F620 non reconnu comme procédure :seule une instruction est inspectée par REA ;les blocs exécutés sont vérifiés séparément. Détails et nombres dans la preuve JSON.

PE original15973880octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Chemins/hashes des six banques, scripts, modules, binaire Rust et journaux dans docs/fidelity_rea_loaded_pipeline_v761.json. Originaux D inchangés ; nouvelles preuves F.

L’audit relit traces compressées, allocations, sources HIRC et membres DIDX/DATA. Six falsifications rejetées : mauvais pointeur source, descripteur fourni promu, propriétaire non restauré, mauvais pointeur média, chargeur courant promu, refus36 transformé en succès. La première préparation de publication a échoué avant toute écriture produit ; diagnostic conservé dans revision761_preparation_failure.json.

## Portée et livraison

Code x86 original exécuté dans Unicorn isolé. Allocations et API physiques verrou/TLS/atomiques adaptées. Voix, parent, filtres bypass, fréquence, restant=-1, faible latence et offset-8 sont fournis comme en V753. Aucune voix englobante, sortie audible ou exécution du jeu complet qualifiée.

Deux fiches/bases, registres, couverture et reprise enrichis par deltas ciblés. Cases, notes, historiques, inconnues et autres tâches conservés ; aucune copie complète de base. Les reçus VERIFIED, INDEPENDENT_READBACK et FINAL_VERIFIED dans revision761_delivery attestent la publication lorsqu’ils existent et réussissent. Le validateur natif partagé est réutilisé ; identités, inversions des registres et tables des bases sont relues séparément.

Suite : constructeur/propriété de voix, paramètres Sound/parents et libération englobante. Streaming, boucles/seek, génération, mixage, concurrence, provider copié, autres médias/locales, teardown global et sortie physique restent ouverts.
