# V1161 — lien macros → producteurs shader → draw terrain Map10

Date : 2026-11-03  
Unité bornée : `AUD-SYS-01.2-02-MAP10-REA-MACRO-LINK-01`  
PE de référence : 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`  
Nouvelle session REA : **INCOMPLETE**  
Lien structurel : **PROVEN_STATIC**, par la preuve statique indépendante V1161  
Vecteur de macros historique exact : **UNRESOLVED_RUNTIME_INPUTS**  
Admission des candidates A/B comme vecteur original au draw Map10 : **REFUSED**

## Question et décision

Le lot devait relier le builder de macros dynamiques `0x9593C0` aux producteurs
pixel/vertex `0x98C070` et `0x98D960`, puis au consommateur terrain
`0x95A730` avant le draw piloté par `0x95AFC0`.

La chaîne structurelle est établie. En revanche, une analyse statique ne fixe
pas les valeurs runtime qui déterminent la palette, la qualité, les ombres, les
options globales et le mode de fog. Les permutations candidates V1161 ne
reproduisent pas l'ordre historique prouvé et omettent des macros
conditionnelles ou leurs compagnes. Elles ne peuvent donc pas être qualifiées
comme `macro-vector original`.

Cette décision ferme la question bornée sans déclarer shader, frame, Map10,
fonction graphique, SYS-01.2-02 ou jeu complet terminés.

## Réutilisation des preuves REA existantes

Le dossier `audit_map10_rea_resource_identity_20261103` a été réutilisé avant
toute nouvelle analyse. Sa session REA 6.4.0 / Ghidra 12.1.4 a déjà produit :

- `006-analyze_function-response.json`, 3 723 142 octets, SHA-256
  `2ba1c4881976d7cb9af3a275b75537786c0e8fc5893617215e1a2e039491c5a0`,
  pour `0x98C070` ;
- `007-analyze_function-response.json`, 3 490 938 octets, SHA-256
  `f60bf34798dc2f101e08eb57b9daac854e2a617b59889485f7614a14adb55f5a`,
  pour `0x98D960` ;
- un bundle REA de 4 973 996 octets, SHA-256
  `ae9e6ad3f0723f9e4293db34c171d0f659dd4100efb448178004cfcd523e582a` ;
- une validation REA indépendante `34/34`, `passed=true`, SHA-256
  `50914acbe0a1b3e8511feff84086580b0a533fdc0815d01ea87fc8b25d2bcb32`.

Cette preuve antérieure confirme les producteurs, leurs handles publiés et les
appels d'enregistrement `0x95A071 → 0x98C070` et
`0x95A24E → 0x98D960`. Elle ne fixe pas les entrées runtime du builder.

## Tentative REA 1 — échec conservé

Périmètre exact : `0x9593C0`, `0x98C070`, `0x98D960`, `0x95A730` et
`0x95AFC0`, un batch, cinq PC, au plus trente appels fonctionnels. Le bridge
raw-FD déjà testé a été relu puis réutilisé ; aucun logiciel n'a été installé.

REA 6.4.0 initialise la session et `open_binary` accepte la copie exacte du PE.
Le contrôle `list_segments` s'arrête ensuite sur :

```text
provider_timeout; operation=list_segments; timeout_ms=600000
```

Résultat observé : zéro appel fonctionnel, zéro procédure résolue. L'export du
bundle échoue logiquement faute de preuve fonctionnelle. `close_binary`, la
fermeture client et la fermeture transport sont acquittées. Le bridge termine
avec zéro ligne reçue/transmise, EOF observé, thread arrêté et aucune erreur.
L'inventaire final des processus est vide.

Reçus :

- session : 8 460 octets, SHA-256
  `014589c6667e272078c323013f86ed0fc327a714284a362717fd4243274928b5` ;
- driver : 2 726 octets, SHA-256
  `3afda71065cf4e49661d293d6bf2c4689bd74d0d69254286bf0c132333306187` ;
- réponse d'échec : 469 octets, SHA-256
  `db7e3a68324223e75f93cb02f50297e586e3be9e4511b4923d91017b8371fc7e`.

Cette tentative n'est ni qualifiée ni complète.

## Tentative REA 2 — interruption bornée conservée

Une seule relance a été admise parce que l'écart précis était le timeout du
provider. Le périmètre, les cinq adresses et les budgets restent identiques ;
seuls le timeout de démarrage Ghidra (`900000 ms`) et le timeout d'appel
(`960000 ms`) augmentent.

REA initialise de nouveau la session. `open_binary` accepte le même PE x86 et
le même SHA. La requête `list_segments` est écrite à
`2026-11-03T11:50:14.9906931Z`. Avant son retour, la preuve statique
indépendante atteint la condition d'arrêt et rend inutile une nouvelle attente
du provider. Le groupe est donc interrompu extérieurement.

État conservé, sans embellissement :

- zéro appel fonctionnel terminé ;
- aucune réponse `list_segments` et aucun reçu runner/driver final ;
- code de sortie contrôleur observé `1` ;
- `close_binary` non acquitté, fermeture client/transport non observée : la
  fermeture protocolaire est **non vérifiée** ;
- après interruption, aucun processus Node/Java/Javaw n'est présent et le
  fichier `ownership.json` est lisible, 596 octets, SHA-256
  `f3ed2e1875ab3242ad5d5d055aba83f9780292e0a8f896ee5fbe621af1a85b94`.

Le reçu `attempt2_cancellation_receipt.json` qualifie cette tentative comme
observation interrompue, jamais comme session REA réussie ou fermée proprement.
Aucun troisième essai n'est autorisé dans ce lot.

## Preuve structurelle décisive

La preuve qui ferme le lien ne provient pas des deux tentatives ci-dessus. Elle
se trouve dans `audit_map10_v1161_static_macro_link_20261103` et reparse le PE
épinglé indépendamment : deux runs, même digest d'évidence
`2f9f20dd2d75e65e712e377ddd87a85b56cd5d44e24b056af4ac08c280b0ab51`,
validation `22/22`.

Chaîne observée :

1. `0x959D30` initialise un vecteur pile, passe son adresse à `0x9593C0` à
   `0x959D9B`, ajoute la palette, puis appelle `0x987830` pour le suffixe fog
   conditionnel.
2. `0x6F1820` copie le préfixe dynamique, dans le même ordre, vers les records
   pixel et vertex distincts ; `0x98F1E0` ajoute ensuite leur suffixe statique.
3. Le record pixel entre dans `0x98C070` à `0x95A071` et publie le handle
   compilé en `record+4` à `0x98C2B9`.
4. Le record vertex entre dans `0x98D960` à `0x95A24E` et publie le handle
   compilé en `record+4` à `0x98DBA9`.
5. Sur le chemin ordinaire selector 0, `0x95A730` sélectionne
   `Environment_LIT_FOUR_BLEND_VS/PS` pour le matériau terrain type 3 lorsque
   le bit de sélection applicable est clair. Les indices, le manager/device et
   les handles doivent être valides ; le remapping pixel death-screen doit être
   inactif pour conserver l'identité PS sélectionnée.
6. `0x95AFC0` appelle `0x95A730` à `0x95B046`, avant l'appel de draw indirect à
   `0x95B112`.

Les records pixel et vertex ne sont pas la même allocation. La preuve porte
sur la copie ordonnée commune et le chemin de consommation, pas sur une alias
d'adresse.

Les artefacts décisifs sont :

- run 1 : 227 577 octets, SHA-256
  `13705f6f49a98053575fe77bc9f20d37637a4740f3b5e6643fc2992df9e08287` ;
- run 2 : 227 577 octets, SHA-256
  `627281257179b42b555403fdb1030521223c22ce88a39feb9e39803117ad0a0f` ;
- validation : 4 673 octets, SHA-256
  `591a7418bb8ff4e8017589df198f08fa19f4a75e35cf1df17db36a8ecc590b6a`.

## Pourquoi les candidates A/B restent refusées

Le builder prouve l'ordre relatif suivant : options dynamiques, puis
`USE_HEIGHT_BLEND=1`, `MOD2X_COLORMAP=1`, options terrain éventuelles, une
`COLORPALETTE_*`, le groupe fog éventuel, puis le suffixe statique
`DISABLE_EMISSIVE=1`, `FOUR_BLEND=1`.

La candidate A commence au contraire par `COLORPALETTE_DEFAULT`, puis place le
suffixe statique avant `USE_HEIGHT_BLEND` et `MOD2X_COLORMAP`. Elle omet aussi
`PCF_MODE` et les branches conditionnelles. La candidate B ajoute seulement
`FOG_PIXELSHADER_BLEND` à la fin ; l'original le place avant le suffixe
statique et, selon le mode, lui associe `FOG_QUALITY_LOW` ou
`FOG_TEXTURED_OPACITY`. La présence des macros fixes Map10 ne suffit donc pas à
établir l'identité du vecteur complet.

## Inconnues runtime et condition de reprise

Restent à épingler dans une même exécution originale Map10, avant les appels
producteurs :

- `0x12258F4` pour les ombres et `0x12258D8` pour la qualité ;
- `0x2D78FAC` / `0x123F5F8` pour l'animation FoW ;
- `0x123F7E0` pour les nuages ;
- `0x2D78FB0` pour les options globales terrain et la sélection FOUR_BLEND ;
- `0x2D79058` pour la palette ;
- `0x14BE79F` et `0x1225904` pour l'activation et le mode fog.
- l'état de remapping pixel death-screen à `0x95A574..0x95A59C` pour
  l'identité de bind PS ordinaire.

Reprendre uniquement avec une capture originale, même-run et horodatée, qui
enregistre ces entrées et le vecteur complet ordonné transmis aux deux records
avant `0x98C070` / `0x98D960`, puis relie ces records au passage
`0x95A730 → 0x95AFC0`. Sans cette entrée, le verdict reste
`UNRESOLVED_RUNTIME_INPUTS`; une nouvelle analyse statique REA des mêmes
adresses n'apporterait aucune information nouvelle.

## Frontières et intégrité

- aucun lancement du jeu original ;
- aucune installation ou migration ;
- aucune écriture produit, Plan, Goal, UI, base ou registre ;
- aucune écriture sur `F:` par ce lot ;
- hashes protégés `completion_plan`, `resume_checkpoint`,
  `fidelity_requirement_trace_4_20`, `fidelity_sources_4_20` et
  `fidelity_unknowns_4_20` inchangés ;
- aucune compilation shader, création D3D9, liaison réelle, commande Draw,
  Present, readback ou preuve pixel ;
- aucune acceptation humaine ou fonctionnelle.

La validation finale machine-readable est dans
`rea_macro_link_validation.json`; sa relecture sans écriture doit réussir sur
les mêmes octets.
