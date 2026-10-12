# Oracle natif des records existants d'écran de chargement

**Préparation du prochain lot uniquement. Aucun code applicatif Rust ajouté ou intégré.** Cette qualification ne doit pas être ajoutée au nombre de tests Rust moteur/client du jalon courant.

`probe_existing_records.py` exécute les instructions originales du PE4.20 :

- `57D650` et son lookup `5BE170` pour l'écran standard ;
- `5B3230` et son lookup `5BE1F0` pour le tutoriel ;
- `C975F5`, contrôle du cookie de pile, exécuté également sans remplacement.

Il n'y a **aucun adaptateur de provider UI, allocateur ou callback**. Le hook de contrôle refuse toute adresse d'instruction en dehors de ces cinq régions ; il refuse explicitement l'entrée dans la branche de clé absente et celle des providers. Aucun exécutable réseau n'est lancé.

## Résultats exécutés

**1 600 appels passent : 800 standard, 800 tutoriel.** Chacun retourne normalement, restaure la chaîne SEH et dépile les quatre octets d'argument plus l'adresse de retour.

- Fills mémoire `00` et `A5`.
- Les **256 valeurs** de l'octet flags sont toutes exécutées pour chaque consumer et chaque fill.
- Neuf clés : `0`, `1`, `7FFFFFFE`, `7FFFFFFF`, `80000000`, `80000001`, `DEADBEEF`, `FFFFFFFE`, `FFFFFFFF`.
- Quatre motifs de payload25 : octets variables, tous les bits à1, motifs IEEE zéros signés/infinis/NaN, autres motifs incluant NaN signalant et valeurs hautes. Le chemin testé ne convertit pas ces motifs en flottants.
- Matrice complémentaire complète clés × flags `00/01/80/FF` × quatre motifs, pour chaque consumer/fill.
- **16 384 octets comparés intégralement à chaque appel**. Les autres records, les nœuds, leurs liens, le recipient, les payloads et le padding restent inchangés.
- Ordre exact des écritures comparé : six mots32, un octet, puis seulement si flags.bit0=1 une écriture zéro de quatre octets à record+10.
- Traces ordonnées des lectures du lookup et du record, et de toutes les écritures dans le contexte ; **153 adresses d'instructions natives distinctes** observées.
- **0 appel UI, 0 allocation** et aucune écriture externe au contexte, à la pile ou à la chaîne SEH.

La fixture exacte est `replay_loading_existing_record_probe.json`. `native_result.json` contient le compte rendu compact. `loading_record_sources.json` contient les octets et empreintes des cinq régions réellement exécutables du harnais.

## Contexte explicite et limites

Le recipient et les arbres sont **des contextes de test préparés**, pas des objets construits par les vrais constructeurs. Chaque arbre contient neuf clés, des liens parent/enfants cohérents, une sentinelle noire et un coloriage rouge/noir valide ; le script vérifie l'ordre strict, les parents, l'égalité des hauteurs noires et l'absence de lien rouge→rouge avant exécution.

La string du record vaut réellement `present`, longueur7, capacité15, aux offsets record+30 (standard) et +28 (tutoriel). Leurs champs de longueur+40/+38 sont donc non nuls, ce qui sélectionne le retour natif après mise à jour du payload. Ce sont des strings valides du contexte, **aucune réponse UI inventée** n'est utilisée pour atteindre ce chemin.

Les allocations, insertions/rotations, destruction des records, constructeurs recipients, première initialisation UI, providers de noms/assets, réception réseau, rendu et concurrence **restent non qualifiés**. Le remplissage des champs qui ne sont pas lus reste volontairement opaque. La comparaison de copie préserve tous les bits ; aucune sémantique gameplay n'est attribuée aux mots opaques.

Prochaine étape : porter le chemin réellement prouvé sans présenter les branches de clés absentes/UI comme terminées, puis produire leurs propres oracles et connecter leurs véritables dépendances. Les audits et le port précédemment gelés n'ont pas été modifiés ; cette invariance est vérifiée par leurs empreintes dans `loading_record_manifest.json`.

Source PE : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` ; SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
