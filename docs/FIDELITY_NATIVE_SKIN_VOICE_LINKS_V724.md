# SYS-01.2-02 — Choix natif des voix de skins, V724

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue 4.20.1 distinct.

## Résultat

680 configurations correspondant à 668 identités de skins et 122 champions sont vérifiées. La préparation de chaque cas lit les alias avec le cache, le constructeur de configuration et le parseur INIBIN originaux. Le fragment `UsesSkinVO` utilise ensuite le lecteur de chaînes original et ce cache déjà rempli. Le choix du fichier et de sa section reste une entrée déclarée.

Le flag est actif pour 59 candidats, concernant 59 identités de skins. La valeur absente est conservée dans les preuves et produit le défaut natif `false`. Les configurations alternatives restent distinctes.

## Chaîne vérifiée

1. `964972..964A32` lit `UsesSkinVO` par `8B0630`, avec le défaut `false`, puis compare exactement le résultat à `true`.
2. Le résultat est écrit dans `skinInfo+10`. Le fragment contient aussi une écriture antérieure indépendante vers `+11`, dont l'entrée est explicitement fournie et contrôlée.
3. `56CDBA..56CDC9` transfère le flag dans `definition+864`.
4. `56D850` choisit `SkinAudioNameOverride`, ou `ChampionSkinName` si cet override est vide, quand le flag est actif. Sinon il choisit `CharAudioNameOverride`, ou le nom de personnage déclaré.

Les fragments sont composés en mémoire isolée. Le constructeur complet du héros, la priorité historique des skins, la disponibilité des banques et la sortie audio ne sont pas démontrés par ce test.

## Vérifications exécutées

- 456 fichiers de configuration ;475 sources sélectionnées et 22 ancres actuelles vérifiées.
- 5960 adresses exécutées comparées aux octets du PE original.
- 12 contrôles : casse exacte, chaînes vide/false/numérique, espaces, overrides actifs/inactifs et noms longs.
- 5 gardes du banc pour chemins ou chaînes hors contrat ;4 preuves falsifiées rejetées.
- 669 fiches du registre et leurs instructions copiables dans les deux bases ;états manuels, autres tâches et inconnues conservés.

Exécutable original : `League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Python, modules, bibliothèques et scripts sont identifiés dans le reçu.

## Consommateurs actuels

Le chargeur de modèles actuel reçoit le nom du champion. Le catalogue PCM inspecté charge les ambiances ;l'enregistrement des plugins audio inclut les ambiances et certains sorts d'Ezreal. Ces points d'entrée sont liés avec leur portée exacte. Aucun n'est présenté comme un fournisseur fonctionnel de voix pour les skins.

## Limites

- Native reader964972..964A32 executes original8B0630,cache/constructor,compiled parser and string getters over the declared read-only loose-files backend. File/logical path,section and initial locale context are explicit inputs; historical package precedence and selected skin instance remain open.
- The reader includes a preceding unrelated byte store to skinInfo+11 supplied with AL=165. UsesSkinVO controls skinInfo+10. Original56CDBA..56CDC9 transfers this flag to definition+864;56D850 selects the audio name. Separate spans are composed in isolated memory,not a full hero constructor.
- Character name comes from the supplied champion identity. Alias fields are freshly read through original string query8B0630 and assigned at known definition offsets; full alias-field constructors are not executed here.
- Diagnostics replace the returned string buffer only at9649AB,after the real source query. They prove exact comparison/fallback behavior,not the presence of diagnostic values in historical sources.
- Existing bounded allocator,string storage,read-only file,thread and CRT adapters from OriginalTextConfig remain; selected F module files are pinned despite their legacy E search-path insertions. No complete historical process,skin precedence,loaded-bank membership,media graph,current voice provider or audible output is qualified.
- Ambiguous Renekton bindings and all alternative matching configs remain separate. No source,asset,game code,manual task state or gameplay acceptance is modified.
- Dans chaque cas nominal,les alias sont lus en premier par le cache original,qui charge et parse les fichiers. Le fragment UsesSkinVO interroge ensuite ce cache deja peuple ;le parseur est execute dans la preparation native du cas,pas necessairement de nouveau lors de cette requete.
- Les668taches PRESENT-AUDIO et la fiche SYS sont enrichies sans cocher de case. Les voix de base deja documentees,V721/V722/V723,et la selection AIR restent conservees.
- Le lecteur courant de references cached_string et les frontieres PCM/plugin du client sont lies explicitement. Les consommateurs existants de modele et de configuration restent identifies selon leur role reel ;aucun fournisseur de voix de skin n est promu.
- Les680candidats a identifiant de skin explicite sont tous compares au recensement natif ;les sources non correspondantes sont exclues de ce corpus,sans etre supprimees. Une valeur UsesSkinVO=true choisit un nom ;elle ne prouve ni ressource distincte,ni disponibilite,ni heritage de tous les sons.
- Douze controles diagnostiques remplacent seulement le buffer retourne apres la requete originale. Cinq gardes du banc et quatre falsifications de preuve sont distinguees des refus natifs. Aucune nouvelle compilation Rust ou session graphique/sonore executee.

## Fichiers et preuves

Le [reçu détaillé](fidelity_native_skin_voice_links_v724.json) contient les configurations, requêtes, flags, noms, instructions et limites. Les registres de tâches, de traces et de sources sont enrichis, ainsi que les documents de couverture/reprise et les deux bases du plan.

Les reçus `VERIFIED.json` et `INDEPENDENT_READBACK.json` sont conservés dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision724_delivery/`. Les sauvegardes portent seulement sur les changements ciblés. Aucun code du jeu ou asset modifié. Le goal reste ouvert.
