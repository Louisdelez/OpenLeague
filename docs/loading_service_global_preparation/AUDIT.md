# Producteur réel de SERVICE_GLOBAL et cycle de vie du chargement

Audit statique borné du PE 4.20, sans exécution native, compilation ou modification de production. Source `League of Legends.exe` SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Les adresses sont des VA x86, base `00400000`.

Le producteur normal de `[02D787B8]` est **58FCB0**, appelé par le propriétaire de processus **592E80**. Il construit le service par **72A3B0**, puis le publie à **58FE54**. Ce n'est pas le constructeur72A3B0 lui-même qui publie le global. La fermeture normale est **590E70**, appelée ultérieurement par592E80 : elle appelle le service vivant, le détruit, puis efface le global.

## Preuves enregistrées

- `bytes/` contient17 régions extraites du PE :16 régions de code et1 table virtuelle, toutes avec SHA256 dans `source_manifest.json`.
- `source_disassembly.txt` est décodé depuis les entrées des fonctions, jusqu'aux bornes exclusives enregistrées. Couverture intégrale des octets de chaque région de code vérifiée par le script.
- `callgraph.json` contient19 appels directs vérifiés à leurs frontières d'instructions et4 appels virtuels pertinents. Les autres candidats E8 sont explicitement marqués comme pistes brutes.
- `global_writers.json` contient les octets exacts des écritures absolues retrouvées. Le scan couvre les12 201 984 octets bruts de `.text`, avec657 occurrences du littéral02D787B8. Deux destinations absolues écrites ont été confirmées depuis leurs entrées de fonctions. Cela n'exclut pas les écritures indirectes, du code extérieur à `.text`, ou une modification du programme à l'exécution.
- `data_evidence.json` conserve la vtable10AFE8C, les constantes textuelles et l'import pertinent. `evidence_index.json` lie les fichiers par leurs hashes. `extract_service_global_preparation.py` permet de refaire l'extraction et les assertions sans compiler ni exécuter le jeu.
- Les fichiers existants `docs/replay_loading_screen_preparation/*` et les sources Rust citées dans le manifeste sont référencés avec leurs hashes au moment de lecture. Leurs anciens reçus ne sont pas présentés comme une nouvelle qualification ni comme l'état de tous les travaux actuels.

## Construction et publication du service

L'ordre source dans58FCB0 est plus large qu'une affectation de pointeur :

1. Accès/construction des objets d'horloge2D791A8 et2D791A4, via99C410 et99C810. Le compteur993CE0 est également consulté. Ce sont des propriétaires supplémentaires, distincts du compteur canonique récemment porté.
2. Construction d'un objet de32 octets, publication dans2D788BC, initialisation de valeurs temporelles et vtable finale108D308.
3. Appel de l'import **USER32!LoadIconA**, IATFA45B4, résultat publié dans2D787C8. Écriture du titre `League of Legends (TM) Client` dans1223E68, du flag2D787C1=1, et interrogation `[General] Windowed` via8B1C20, résultat destiné à2D787C4.
4. `58FE22 push188`, `58FE2C call9933E0`, puis à58FE3E test du pointeur alloué. S'il est non nul, `58FE44 call72A3B0`; sinon58FE4B metEAX à zéro.
5. **`58FE54 A3 B8 87 D7 02`** écrit le résultat dans `[02D787B8]`. La comparaison du flag2D78588 à58FE4D précède cette écriture mais ne conditionne pas sa réalisation. Les diagnostics suivants ne retardent pas la publication.

La publication arrive donc **après le retour du constructeur**, avec l'identité exacte retournée. Aucune destruction/remplacement d'un ancien service n'est effectuée ici : la source attend le contexte du démarrage du processus. Le constructeur peut lire les globals précédents pendant qu'ils ont encore leurs valeurs antérieures.

La branche d'allocation nulle publie zéro dans ce fragment natif. Elle ne rend pas le reste du démarrage sûr : d'autres fonctions, notamment l'arrêt ci-dessous, déréférencent le service sans garde initiale. Un résultat hôte `Err` pour une allocation impossible doit être présenté comme une adaptation de sûreté et non comme une réussite native avec un service vide.

`audio_game_service_lifecycle.rs` porte déjà72A3B0 et72A530. `audio_replay_windows_service.rs::configure_service` crée actuellement un propriétaire privé avec des ressources suivies, puis renvoie un handle. Il ne réalise pas les étapes de publication ci-dessus. Les tests `audio_replay_windows_loading_packets_tests.rs` bindent explicitement le global pour leurs diagnostics, conformément à leur commentaire aux lignes108–109 lors de cet audit. Ce binding de test doit rester explicite tant que le vrai cycle extérieur n'est pas porté.

## Ordre prouvé jusqu'à l'écran de chargement

```text
592E80 propriétaire du processus
  592F88 -> 58FCB0
      58FE44 -> 72A3B0
      58FE54 -> [SERVICE_GLOBAL] = EAX
  59307A -> 58FF50
  si AL != 0 : 593085 -> 5910C0
      branche de chargement : 591E52 -> 58E550
          58E5AE -> 58D7B0
              58D9E7 -> 577D10
                  si [14C761C] == 0 :
                      577D5E -> 576280 (wrapper128)
                      577D6F -> 5C7E30 -> 5D7750 (control16)
                  577D7B -> 5765F0 (sélection destinataire)
                  577DD5 -> 5768E0 (activation/layout)
          boucle : 58E676 -> 58D550 -> 58CB20
          58E9CE -> 577DF0 (reset de la paire chargement)
  5930EF -> 590E70 (arrêt du processus)
```

Les appels591E52 et593085 appartiennent à des branches, pas à un chemin inconditionnel sur toutes les entrées. Ce graphe prouve l'ordre lorsque la branche normale de chargement est atteinte ; il ne qualifie pas les nombreux services de rendu, la connexion réseau, les données de partie ou la boucle de simulation appelés entre ces points.

La sélection5765F0, les factories et les destinataires ont déjà leur audit dans `E:\OpenLeague\docs\replay_loading_screen_preparation\AUDIT.md`. Cette préparation ne les redécouvre pas et ne déclare pas leurs frontières UI résolues. Le point nouveau est leur position **après la publication du service**.

À577DAB, le service est relu depuis2D787B8, et son slot+0xB0 est appelé. Pour la vtable10AFE8C, ce slot vaut718AD0, dont le corps est exactement `mov al,[ecx+122]; ret`. L'accès au mode ne doit donc pas devenir une valeur inventée par le code hôte.

## Publication et reset de la paire chargement

La publication5C7E30 était déjà identifiée. Les octets vérifiés ici confirment son ordre :

- 5C7E4C construit le nouveau contrôle via5D7750 ;
- 5C7E5A publie le contrôle dans14C7620 ;
- 5C7E62 publie l'objet dans14C761C ;
- puis seulement l'ancien contrôle est relâché.

Le reset réel est **577DF0**, distinct d'une simple destruction directe du wrapper :

1. `577E0A -> 5CC140` prend une copie temporaire possédante de la paire globale.
2. Si l'objet de cette copie est **non nul**, il relit le contrôle global à577E18, met14C7620=0 à577E1E, puis14C761C=0 à577E28.
3. Il relâche alors le contrôle global ancien, avec forte puis éventuelle faible et leurs callbacks.
4. Il relâche ensuite le contrôle de la copie temporaire, à partir de577E59.

Les callbacks de destruction voient donc une paire globale nulle sur ce chemin. La copie temporaire maintient le wrapper vivant jusqu'au dernier relâchement. Si l'objet temporaire vaut0, les deux écritures globales sont sautées : ne pas transformer cela en effacement inconditionnel d'une paire incohérente.

Deux appels directs à577DF0 ont été retrouvés :

- **58D1FE**, dans58CB20, lorsque le slot+0xBC du service retourné par la lecture précédente donneAL=0 sur cette branche.58CB20 est appelé par58D550, lui-même dans la boucle58E550 à58E676.
- **58E9CE**, après la boucle de58E550 et l'appel58D5F0. Cette route est atteinte avant le retour de58E550, donc avant le futur appel de590E70 par592E80.

Ce constat ne prouve pas un cleanup identique pour toutes les exceptions SEH ou toutes les sorties anticipées.590E70 ne contient pas d'appel direct à577DF0 dans la région auditée. Une intégration Windows doit annoncer ses garanties de fermeture sur erreur au lieu de supposer que l'existence de la destruction du service couvre tous les propriétaires de chargement.

## Arrêt du service : deux callbacks puis effacement

Dans590E70, après d'autres ressources de processus :

| Site | Opération source |
| --- | --- |
|590F03|LitECX depuisSERVICE_GLOBAL.|
|590F0E|Appelle `[vtable+20]`, sans garde de pointeur nul préalable. La vtable10AFE8C donne72A9F0.|
|590F11|**Relit** SERVICE_GLOBAL après ce callback.|
|590F17–590F1F|Si ce pointeur relu est non nul, appelle son slot0 avecflags=1. La vtable normale donne72A530.|
|590F27|**`C7 05 B8 87 D7 02 00 00 00 00`**, metSERVICE_GLOBAL à zéro.|
|590F31 et suite|Poursuit la destruction de2D788BC, puis de la string2D78D08 et des autres propriétaires du processus.|

Le global reste publié pendantStop et pendant le destructeur, sauf mutation effectuée par un callback. La relecture de590F11 est observable : mettre le global à zéro avantStop, conserver une copie unique du pointeur pour les deux callbacks, ou supprimerStop au motif qu'un destructeur existe change le comportement.

**72A9F0**,58 octets, est un port concret court à réaliser :

1. Conserve`this`, puis journalise `ClientFacade::Stop\n` via5FA170, avec arguments3,1,0.
2. Relit le byte`this+122` **après** le journal ; s'il est nul, revient.
3. Relit le pointeur`this+CC` ; s'il est nul, revient.
4. Relit sa vtable et appelle son slot+30 sans argument supplémentaire explicite.

La cible de ce dernier slot reste dynamique. L'audit ne prétend pas avoir qualifié un objet concret àthis+CC, ni autoriser un callback vide. Une erreur de frontière doit demeurer une erreur vérifiable.

## Port suivant proposé, borné et vérifiable

Créer un module de **cycle extérieur du service**, distinct du constructeur et du propriétaire privé actuel, avec les séquences suivantes :

1. **Construction/publication** : extraire la composition d'appels de58FE22–58FE59, avec allocation188, constructeur72A3B0 existant, publication seulement après son retour. Conserver la provenance du contexte extérieur58FCB0. Les prérequis horloges/objet32, titre/icone et configuration `[General] Windowed` doivent être des frontières explicites tant que leur intégration n'est pas qualifiée.
2. **Stop72A9F0** : journal réel, lectures ordonnées et dispatch réel du slot+30 conditionnel. Réutiliser les traits de lecture, journal et objet existants si leurs signatures conviennent exactement ; ne pas écrire un modèle réseau fictif.
3. **Arrêt extérieur** : porter590F03–590F31 en conservant la relecture et l'effacement final. Le handle d'origine doit gérer la transition de propriété avec les éventuelles mutations par callback et les erreurs hôtes ; ne pas répéter un destructeur partiellement consommé sur simple retry sans reçu de phase.
4. **Paire chargement** : porter577DF0 avec les primitives de paire partagée etControlBoundary déjà disponibles. Ce reset est la fermeture normale du wrapper et doit précéder la destruction du service sur la route complète qualifiée.

La première intégration peut exposer une entrée de cycle de processus explicitement distincte de`configure_service`. Elle ne doit pas publier arbitrairement le global au milieu du constructeur privé, ni déclarer58FCB0 ou592E80 intégralement portés si leurs autres dépendances sont encore des frontières.

Pour qualifier cette tranche, les futurs oracles doivent observer au minimum : publication après constructeur ; aucune publication si le constructeur échoue ; branche d'allocation nulle explicitement distinguée ; global observé parStop et par le destructeur ; callbackStop mutateur démontrant la relecture ; callback de journal mutateur démontrant les lectures tardives de72A9F0 ; branches mode0, pointeur imbriqué0 et slot+30 actif ; reset de paire nulle/non nulle avec référence temporaire et ordre de destruction ; erreurs d'un callback et erreurs de cleanup conservées sans double libération. Ce sont des **cas proposés**, aucun n'a été exécuté dans cette préparation.

## Limites

Cette livraison est une identification statique du vrai producteur et de ses consommateurs, accompagnée des octets vérifiables. Aucun port Rust, fixture native exécutée, test Windows, build ou modification de production n'est inclus. Elle ne prouve ni démarrage réseau fonctionnel, ni écran visible, ni partie jouable. Les tests de chargement doivent continuer à déclarer leur binding explicite tant qu'un propriétaire de processus réel n'est pas raccordé et qualifié.
