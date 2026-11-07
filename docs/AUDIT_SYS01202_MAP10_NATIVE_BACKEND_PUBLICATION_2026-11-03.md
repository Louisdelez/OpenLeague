# SYS-01.2-02 — V1144 — publication du backend natif du terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-PUBLICATION-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé pour la chaîne statique de publication dans `renderer+0x14`**  
Verdict fonctionnel : **aucune exécution composée du caller à la factory ; publication runtime historique et chemin nominal non terminés**  
Acceptation humaine : **non demandée**

## 1. Exigence et frontières

V1143 exécute les trois DDS terrain jusqu'à `0x9BB247`, où le consommateur résout le slot virtuel backend `+0x60` vers `0x9C2D40`, sans appeler cette méthode. V1144 traite seulement le maillon de provenance de cet objet : déterminer comment le bootstrap original choisit le provider graphique, passe l'adresse de `[0x2D79078]+0x14` comme sortie de factory et relie cette sortie au backend D3D9 à vtable `0x10E2F30`.

Le lot distingue strictement :

- la chaîne d'adresses et d'arguments démontrée statiquement dans le PE 4.20 ;
- l'exécution V714 antérieure du choix de provider, réutilisée sans la rejouer ;
- l'exécution V716 antérieure de la factory et du constructeur D3D9, réutilisée sans la rejouer ;
- l'absence d'une exécution unique et composée `caller renderer → factory → store` ;
- le chemin conditionnel V716 sous refus pilote synthétique, distinct du chemin nominal historique.

Sont exclus : relecture des DDS, provider RADS, nouvelle exécution Direct3D/COM, appel privé au pilote, upload, draw, pixels, correction produit, modification du client original, des assets, registres, goal, Plan, application de suivi ou bases.

## 2. Sources, identités et preuves réutilisées

### Source native

- Exécutable : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Le script V1144 remappe directement les sections PE32, rehache ce fichier, puis ne désassemble avec Capstone que les fenêtres d'adresses héritées. Les recherches de dwords sont des candidats d'inventaire et ne sont pas promues seules en références d'instructions.

### Preuves antérieures réutilisées, non rejouées

- V714, rapport `FIDELITY_GRAPHICS_PLATFORM_SELECTION_V714.md`, SHA-256 `7a0ad8c3e5ac26865530fca889c479b442a676f107a90be81f816353dd38632a` ; reçu `fidelity_graphics_platform_selection_v714.json`, SHA-256 `b7d983a065ed97e2756b53085410f78dc277ccb0278c12c233716bde437bf090`. V714 exécute le choix `x3d_platform=0`, la factory provider `0x9B7590` et la publication à `renderer+0x10` par `0x9808F8`. Il n'exécute pas le constructeur du device.
- V716, rapport `FIDELITY_NATIVE_D3D9_DEVICE_V716.md`, SHA-256 `8b1ec486093b4f432bb1395d077265f4103830f756c6fbd1908d97078fdd43a7` ; reçu `fidelity_native_d3d9_device_v716.json`, SHA-256 `630e696bf6d15c68fce9de7dfd0eed284e76621890ae1bfdb7f13aa89b259a96`. V716 exécute directement `0x9C3E30 → 0x9C1430` avec un pointeur de sortie adapté. Le profil conditionnel `escape_refusal` retourne un objet à vtable `0x10E2F30`; le parcours nominal s'arrête avant `0x48AC16`.
- Copie readonly du probe V716 : `revision716_final_device_probe.readonly_copy.py`, SHA-256 `31919fcb6a24ee9235e062d2207cfa1baa708df99ea15cb661ceac2826b8e4bb`, identique au hash enregistré dans le reçu V716. Cette copie n'a pas été exécutée dans V1144.
- V1143 reste le consommateur aval : `[0x2D79078]+0x14 → request+0x20 → [vtable+0x60]` à `0x9BB247`.

### Artefacts V1144

- `perimetre.md`, SHA-256 `06901b22a31cd920a383e64beaffcdca47a965c7151aaa3b1cd81032305ffa95` ;
- `inspect_backend_publication_bounded.py`, SHA-256 `3d33e235f979a8ed58d0c4134eed684067c745b11cfd65c82be4fbae8ab5df35` ;
- `native_backend_publication_static.json`, SHA-256 `a3d9e5bf4049ee2fe855f6ec4d8d09b3ae4dea3832d3674aae9e0e30f4352c02` ;
- `factory_execution_reuse_assessment.json`, SHA-256 `f84e002ad1fa4138bc4e149c50d56dc86d50ce1c15845b50f09ab3800f969a92`.

## 3. Chaîne originale démontrée

### Initialisation et provider

Le constructeur du renderer initialise `renderer+0x14` à zéro à `0x981A20`. Pour le choix D3D9 qualifié par V714 :

1. `0x9808E8` appelle la factory provider `0x9B7590` ;
2. le provider obtenu porte la vtable `0x10E2E2C` ;
3. `0x9808F8` écrit ce provider dans `[ebx+0x10]`, soit `renderer+0x10`.

Le slot `provider+0x10` se trouve à `0x10E2E3C` et contient exactement `0x9C3E30`.

### Passage de `renderer+0x14` comme sortie

Le caller original prépare ensuite la sortie de la factory :

| Adresse | Instruction | Rôle démontré |
|---:|---|---|
| `0x981102` | `mov ecx,[ebx+0x10]` | charge le provider publié par V714 |
| `0x981105` | `lea edi,[ebx+0x14]` | calcule l'adresse du champ backend |
| `0x981108` | `push edi` | passe cette adresse comme cinquième argument / pointeur de sortie |
| `0x981110` | `mov eax,[ecx]` | charge la vtable provider |
| `0x981119` | `call [eax+0x10]` | appelle le slot qui résout `0x9C3E30` |

Cette séquence ferme la liaison statique qui manquait : l'appelant original passe bien `&renderer+0x14` au provider D3D9.

### Factory et backend D3D9 réutilisés depuis V716

V716 démontre séparément, sur le même PE :

- entrée dans la factory `0x9C3E30` ;
- appel `0x9C40A4 → 0x9C1430` du constructeur ;
- publication de la vtable backend `0x10E2F30` par le constructeur ;
- store original `0x9C40C8` dans le pointeur de sortie fourni par le caller ;
- sous le profil conditionnel `escape_refusal`, objet retourné `0x40800010`, vtable `0x10E2F30`, après 3 329 adresses d'instructions originales ;
- vtable backend : `+0x60=0x9C2D40`, `+0xF0=0x9C3A40`.

V716 fournissait toutefois directement l'adresse adaptée `0x40002000` comme sortie. V1144 relie statiquement la vraie sortie du caller, mais n'exécute pas le caller et la factory dans le même run. La composition de preuves ferme donc la chaîne statique, pas la publication runtime historique.

## 4. Contrôles exécutés, attendu et observé

### Inspection bornée V1144

Commande réellement exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_backend_publication_20261103\inspect_backend_publication_bounded.py
```

Résultat : code `0`. Le script a rehaché le PE, résolu `0x10E2E3C → 0x9C3E30`, vérifié l'appel `0x9C40A4 → 0x9C1430`, la vtable `0x10E2F30` et ses slots `+0x60/+0xF0`, puis affirmé les six instructions du caller `0x9808F8`, `0x981102`, `0x981105`, `0x981108`, `0x981110`, `0x981119` avec leurs opérandes exacts.

Attendu : retrouver une chaîne statique où le provider original publié à `renderer+0x10` reçoit explicitement `&renderer+0x14` comme sortie de sa méthode `+0x10`, sans prétendre avoir exécuté le chemin complet.

Observé : conforme. Le reçu porte `audit_complete_for_declared_static_boundary=true`, `backend_publication_static_chain_complete=true` et `backend_publication_feature_complete=false`.

### Validation indépendante des deux reçus

Une relecture PowerShell indépendante a vérifié : verdicts statique/fonctionnel, cible factory `0x9C3E30`, constructeur `0x9C1430`, store V716 `0x9C40C8`, vtable retournée `0x10E2F30`, slot `+0x60=0x9C2D40`, et absence de run composé. Résultat : `INDEPENDENT_V1144_VALIDATION=PASS`.

Le reçu de réutilisation a aussi vérifié les hashes actuels du rapport et du reçu V716. Une tentative initiale de rehachage de toutes les grosses sources F: a été arrêtée en raison de latences de lecture, sans mutation. Le PE a ensuite été rehaché directement avec succès par le script statique et la copie readonly du probe V716 conserve exactement le hash enregistré par V716.

Aucune nouvelle exécution native D3D, COM, pilote, GPU ou texture n'a été lancée dans V1144. Ce choix évite de répéter V716 sans piste nouvelle.

## 5. Résolu et ouvert

### Résolu par V1144

1. Le provider D3D9 à vtable `0x10E2E2C` est relié à `renderer+0x10`.
2. Le caller original calcule explicitement `&renderer+0x14` et le passe à la méthode provider `+0x10`.
3. Le slot `0x10E2E3C` résout de manière exacte `0x9C3E30`.
4. La preuve V716 réutilisée relie cette factory au constructeur `0x9C1430`, au store `0x9C40C8` et à la vtable backend `0x10E2F30`.
5. Le backend ainsi identifié est celui dont V1143 consomme le slot texture `+0x60=0x9C2D40`.

L'audit V1144 est donc terminé pour sa frontière statique de publication.

### Toujours ouvert

1. **Exécution composée** : aucun run unique n'a exécuté `0x981102 → 0x981119 → 0x9C3E30 → 0x9C1430 → 0x9C40C8` et observé l'écriture effective de `renderer+0x14`.
2. **Chemin nominal pilote** : V716 s'arrête avant l'appel privé `0x48AC16`. Le contrat, la requête et la réponse historique de `D3DKMTEscape` ne sont pas qualifiés.
3. **Preuve historique runtime** : le seul retour complet V716 repose sur l'injection déclarée de `STATUS_INVALID_PARAMETER (0xC000000D)` à cette frontière ; il qualifie une branche conditionnelle, pas le comportement nominal 2014.
4. **Graphique fonctionnel** : aucun appel COM/GPU, upload des DDS terrain, draw, pixel ou comparaison visuelle n'est exécuté dans ce lot.

La fermeture de la chaîne statique n'est pas une déclaration de fonctionnalité terminée, de device historique nominal, de rendu ou de fidélité visuelle.

## 6. Conditions de reprise

Les clauses `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucun correctif produit n'est appliqué.

Reprendre seulement avec une entrée qui dépasse la frontière actuelle :

1. composer le span original minimal depuis `0x981102` jusqu'au retour de `0x9C3E30`, en réutilisant le provider V714 et le profil conditionnel V716, puis vérifier que `0x9C40C8` écrit un objet à vtable `0x10E2F30` dans le vrai champ `renderer+0x14` ;
2. conserver ce test conditionnel séparé du chemin nominal ;
3. pour le nominal historique, identifier le contrat privé à `0x48AC16` ou capturer une réponse runtime qualifiée, sans transmettre une requête inconnue au pilote ;
4. seulement après publication composée, reprendre le backend texture `0x9C2D40` et la chaîne d'upload Map10 déjà délimitée par V1143.

Ne pas répéter V714, V716, les I/O DDS V1143, le scan des mêmes dwords ou la simple résolution de `+0x60` si le PE et les reçus n'ont pas changé.

## 7. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_backend_publication_20261103/`.

- `perimetre.md`
- `inspect_backend_publication_bounded.py`
- `native_backend_publication_static.json`
- `factory_execution_reuse_assessment.json`
- `revision716_final_device_probe.readonly_copy.py`
- `AUDIT_SYS01202_MAP10_NATIVE_BACKEND_PUBLICATION_2026-11-03.md`

Décision : **V1144 est terminé pour la chaîne statique de publication du backend D3D9 dans `renderer+0x14`. La publication runtime composée, le chemin nominal bloqué à `0x48AC16`, COM/GPU, upload, draw et pixels restent incomplets.** Le parent `SYS-01.2-02`, les corrections terrain et l'acceptation humaine restent ouverts.

Fichiers créés ou modifiés par V1144 : les artefacts de preuve listés ci-dessus dans E:. Aucun fichier F:, client original, source produit, asset, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié.
