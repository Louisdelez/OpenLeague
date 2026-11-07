# Revue indépendante finale — V1161 REA macro link

Date de revue : 2026-11-03  
Lot relu, sans modification : `E:\mapslol3v3\audit_map10_v1161_rea_macro_link_20261103`  
Preuve statique reliée : `E:\mapslol3v3\audit_map10_v1161_static_macro_link_20261103`  
Verdict de revue : **PASS_BOUNDED_REA_EVIDENCE_ONLY**

## Conclusion

Le lot est cohérent et vérifiable dans sa portée bornée. Les deux tentatives
REA ne constituent pas une extraction fonctionnelle réussie : leur verdict
reste **INCOMPLETE**. Le lien structurel
`0x9593C0 -> 0x98C070 / 0x98D960 -> 0x95A730 -> 0x95AFC0` est néanmoins
**PROVEN_STATIC**, exclusivement grâce à la preuve statique indépendante V1161
corrigée. Cette séparation est correctement conservée dans le rapport et dans
la validation finale.

Le vecteur historique complet reste **UNRESOLVED_RUNTIME_INPUTS**. Les
candidates A/B restent **REFUSED**. Aucun shader, bind D3D9, draw, pixel,
frame, Map10, SYS-01.2-02, carte ou jeu complet n'est déclaré terminé.

## Tentative REA 1

- Cinq PC exacts : `0x9593c0`, `0x98c070`, `0x98d960`, `0x95a730`,
  `0x95afc0`.
- Le PE copié correspond au PE de référence x86 : SHA-256
  `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- `list_segments` retourne `provider_timeout`, opération `list_segments`,
  budget `600000 ms`.
- Zéro appel fonctionnel, aucune procédure inspectée ou extraite ;
  `qualified=false`, `complete=false`.
- `close_binary`, fermeture client et fermeture transport sont acquittées.
- Le reçu driver rapporte un inventaire final vide et un bridge raw-FD propre :
  zéro ligne reçue/transmise, EOF, thread arrêté, aucune erreur.
- Reçus épinglés : session
  `014589c6667e272078c323013f86ed0fc327a714284a362717fd4243274928b5`,
  driver
  `3afda71065cf4e49661d293d6bf2c4689bd74d0d69254286bf0c132333306187`,
  réponse timeout
  `db7e3a68324223e75f93cb02f50297e586e3be9e4511b4923d91017b8371fc7e`.

Conclusion indépendante : échec REA proprement conservé, non qualifié et non
complet.

## Tentative REA 2

- Même périmètre de cinq PC ; budgets bornés `1 batch / 5 PC / 30 appels`,
  démarrage `900000 ms`, appel `960000 ms`.
- `open_binary` acquitte le même PE x86 et le même SHA-256.
- La requête `list_segments` est conservée, sans réponse correspondante.
- Interruption externe après satisfaction de la condition d'arrêt par la
  preuve statique indépendante ; zéro appel fonctionnel terminé.
- Aucun reçu final runner ou driver n'est présent, ce qui empêche toute fausse
  qualification de succès.
- `close_binary` n'est pas acquitté ; fermeture client et transport non
  observées. La fermeture protocolaire reste **non vérifiée**.
- Le reçu d'interruption rapporte un inventaire Node/Java/Javaw vide et un
  `ownership.json` lisible, SHA-256
  `f3ed2e1875ab3242ad5d055aba83f9780292e0a8f896ee5fbe621af1a85b94`.
- La revue courante observe également zéro processus Node/Java/Javaw.
- Des résidus de verrouillage Ghidra sont toujours présents dans le répertoire
  privé de la tentative 2 : `parallel.lock` (0 octet),
  `rea-project.lock` (245 octets, SHA-256
  `a8d65e789de76c2b37bf860f522d5f7757c32f67758cebb137c34ef081c64893`)
  et `rea-project.lock~` (0 octet). Leur présence ne prouve pas un processus
  actif et ne permet pas de revendiquer une fermeture propre ; ils ont été
  laissés intacts.

Conclusion indépendante : observation interrompue, non qualifiée, non
complète et sans preuve de fermeture protocolaire gracieuse.

## Validation finale et non-mutation

Le validateur source a été parsé puis réexécuté depuis son emplacement :

`powershell.exe -NoProfile -ExecutionPolicy Bypass -File E:\mapslol3v3\audit_map10_v1161_rea_macro_link_20261103\validate_rea_macro_link.ps1`

Résultat observé : code `0`, `passed=true`, **43/43**. Le SHA-256 de sa sortie
standard capturée est
`860f4a2302efaf854162d6e1321a1dac9fbba0f5b32fddaee71ee517ff64cd80`.
Les 21 artefacts suivis avant/après l'exécution sont restés identiques. Le
validateur est donc non-mutant pour cet ensemble observé.

L'échec initial conservé (`37/43`) est cohérent avec une preuve statique alors
encore obsolète ; il a détecté les pins/digest/compteurs antérieurs. Il n'est
pas masqué. Après correction de la preuve statique et de sa chaîne, la
validation finale actuelle réussit 43/43.

Les cinq hashes protégés relus sont inchangés :

- `completion_plan.json` :
  `f197caf421f204768d77640cc9a0c95de375b5e3c06df29bf294d403afb30c78` ;
- `resume_checkpoint.json` :
  `2142206697b792d4b47e221018a6f39eb92c21a703d771c26f048790c145098e` ;
- `fidelity_requirement_trace_4_20.json` :
  `05e82921fde916bc1b576db7f9801b87e8223b866ad1bf1205a8d3e670e60a05` ;
- `fidelity_sources_4_20.json` :
  `d8283f8872339087d5e2134f9342b06bc3e67d21514ce4149a1bf42b388fcc38` ;
- `fidelity_unknowns_4_20.json` :
  `e5b0d386687427a7ef328cab8d912747f9b6394ce16eb29dbdc53259f4708cf2`.

## Relation exacte avec la preuve statique corrigée

La décision `PROVEN_STATIC` ne provient d'aucune des deux sessions REA de ce
lot. Elle est reliée aux artefacts indépendants corrigés suivants :

- rapport statique :
  `27f7fcdadbb9a5c1f9b64b0e62def6c2d6a095f341a6308f7be0ab569494ef9a` ;
- manifeste statique :
  `1f490b89bdc5c691af166034103af32bce1f28cd80335de9aa3e34083e224c30` ;
- run 1 :
  `13705f6f49a98053575fe77bc9f20d37637a4740f3b5e6643fc2992df9e08287` ;
- run 2 :
  `627281257179b42b555403fdb1030521223c22ce88a39feb9e39803117ad0a0f` ;
- validation statique :
  `591a7418bb8ff4e8017589df198f08fa19f4a75e35cf1df17db36a8ecc590b6a`,
  `passed=true`, **22/22** ;
- digest d'évidence déterministe des deux runs :
  `2f9f20dd2d75e65e712e377ddd87a85b56cd5d44e24b056af4ac08c280b0ab51`.

La chaîne prouvée est structurelle : builder dynamique, copie ordonnée vers
deux records distincts, compilation/publication des handles pixel et vertex,
sélection terrain, puis appel du consommateur avant le draw indirect.

## Conditions de bind et death-screen

Le bind n'est pas inconditionnel. La conclusion vaut sur la route ordinaire
`selector=0`, pour `material_type=3`, lorsque `global_options & 4 == 0`, avec
lookup, manager, device, indices et handles `record+4` valides. Le remapping
pixel death-screen à `0x95A574..0x95A59C` doit rester inactif pour conserver
l'identité PS sélectionnée. Une activation de ce remapping peut choisir un
autre index pixel ; elle reste hors du contrat prouvé.

## Candidates A/B

Le refus est justifié : l'ordre des macros, les branches conditionnelles et
les compagnes fog prouvées par le builder ne correspondent pas aux candidates.
Les macros fixes Map10 seules ne suffisent pas à établir l'identité du vecteur
historique complet. Le verdict reste `REFUSED` jusqu'à une capture originale,
même-run et horodatée des entrées runtime et du vecteur ordonné complet.

## Frontières d'écriture et limites

- Les sources du lot relu n'ont pas été modifiées par cette revue.
- La revue a créé uniquement ce dossier de revue sous `E:\mapslol3v3`.
- Aucun jeu original n'a été lancé ; aucun installateur ni migration exécuté.
- Aucune écriture produit, Plan, Goal, UI, base ou registre n'a été effectuée.
- Aucune écriture sur `F:` n'a été effectuée ; les cinq fichiers protégés y ont
  seulement été relus pour leurs hashes.
- Ces frontières reposent sur les reçus, les chemins contrôleurs relus et les
  opérations de cette revue ; elles ne constituent pas une télémétrie système
  globale rétroactive.
- Aucune valeur runtime historique, aucune liaison D3D9 réelle, aucun draw,
  Present, readback ou pixel n'a été observé.
- La fermeture historique de la tentative 2 reste non vérifiée malgré
  l'absence actuelle des processus et la présence de métadonnées/résidus de
  verrouillage.

Le reçu machine-readable, le manifeste et la liste des commandes se trouvent
dans le même dossier que ce rapport.
