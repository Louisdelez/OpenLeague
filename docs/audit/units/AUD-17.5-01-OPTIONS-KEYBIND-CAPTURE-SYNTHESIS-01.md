# AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01 — couverture et reprise de la capture

Date : 2026-10-31T10:12:34.697933+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Consolider les associations déjà prouvées et leurs limites, sans nouvelle fonction ou exécution. Neuf unités closes sont réutilisées ; aucune addition de leurs tests ou instructions. Les 16 clauses ci-dessous sont une vue descriptive de cet audit, **pas** de nouvelles exigences, tâches, contrôles HUD ou dénominateur de projet. La clôture concerne seulement la cohérence de cette consolidation ; ni la capture complète, ni le parent ne sont déclarés audités intégralement ou implémentés.

Audit : associations et reprises réconciliées. Implémentation : primitives actuelles et écarts conservés. Vérification : contrôle d'identité/cohérence, preuves natives/CPU héritées sans rejeu. Acceptation humaine : non demandée. Le goal reste ouvert.

## R2 — Preuves conservées et version

Les unités CAST1, NATIVE-READ, DESCRIPTOR, VALUE-READ, FILENAME, CACHE-CONTEXT, CAPTURE, CAPTURE-PAYLOAD et DATA-PAYLOAD sont réidentifiées avec leurs lecteurs et rapports. Chacune conserve sa clôture documentaire limitée et son parent ouvert. PE original 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; sources actuelles, registres et critères hérités inchangés.

Les anciennes listes « unqualified » et l'abréviation hash(event) ne sont pas considérées comme l'état global le plus récent : la nouvelle vue effective relie section + * + event, AL présence, capacité SSO et construction du filename aux preuves ultérieures. Les anciens objets restent inchangés. Les errata de littéraux, scopes, capacité et lecteurs effectifs restent attachés à leurs unités, avec les échecs conservés. Aucun fait de runtime n'est créé par agrégation.

## R3 — Matrice de clauses et consommateurs

Chaque ligne possède dans le JSON ses chemins exacts de faits, hashes, sources, preuves actuelles, groupes ouverts et corrections réutilisées.

| Clause descriptive | Acquis et limite | Reprise ouverte |
|---|---|---|
| BCAP-DECL — Déclarations et stratégies des bindings | Déclarations physiques et payload AS identifiés ; pas d’héritage effectif ou de mode courant supposé. | INPUT-SELECTION, CURRENT-CYCLE |
| BCAP-READ — Quatre valeurs de lecture | Ordre défaut/effectif et leurs affichages qualifié ; le second champ est déjà composé avec repli. | INPUT-SELECTION, READ-BOUNDS |
| BCAP-HASH — Descripteur, alias et domaine des octets | Hash de section + * + event, sans renommage local ; alias effectif ouvert, différence signed/unsigned non ASCII documentée. | INPUT-SELECTION, CURRENT-CYCLE |
| BCAP-VALUE — Présence, vide et repli | AL signifie correspondance/présence ; vide présent peut arrêter le repli, ce n’est pas un acquittement I/O. | INPUT-SELECTION, READ-BOUNDS |
| BCAP-FILE — Chemin et variantes de langue | Construction et branches connues ; fichier physique effectivement monté et erreurs/lifetime restent ouverts. | INPUT-SELECTION, READ-BOUNDS |
| BCAP-CACHE — Cache et contexte sélectionné | Flag0 et priorité connus ; suites communes non promues en tests Input ni comptées deux fois. | INPUT-SELECTION, READ-BOUNDS |
| BCAP-START — Entrée et refus du mode natif | Guards, mode7 et pré-effets du refus établis ; AL1 ne vérifie pas le post-état virtuel. | INPUT-SERVICE, UI-LIFECYCLE |
| BCAP-END — Sortie du mode natif | Demande mode6 et appels conditionnels identifiés, sans effet opaque inventé. | INPUT-SERVICE, UI-LIFECYCLE |
| BCAP-MODEPAYLOAD — Payload du booléen | SetKeybindInputMode/value et insertion connus ; membres effectifs et livraison non observés. | GFX-MEMBERS, QUEUE-DELIVERY |
| BCAP-KEYDATA — Producteur et données des touches | keys/localizedKeys, trois gardes, SSO et caller82E990 qualifiés ; source physique/ownership ouverts. | INPUT-SERVICE, GFX-MEMBERS, QUEUE-DELIVERY |
| BCAP-RECEIVE — Garde de réception AS | Receiver enregistré, conversions et actif+grille établis ; pas de réception runtime supposée. | QUEUE-DELIVERY, CURRENT-CYCLE |
| BCAP-EDIT — Esc, application, refus et conflits | Branches du modèle établies, avec Esc avant apply dans sa propre méthode ; parcours courant non implémenté par ces sources. | CURRENT-CYCLE |
| BCAP-DIALOG — États terminaux et délais | Succès/unbound/échec/annulation/interruption et chemin invalide distingués ; timers/stage non exécutés. | UI-LIFECYCLE, CURRENT-CYCLE |
| BCAP-CLOSE — Fermeture et flag local | End dépend du flag local ; fermeture le vide avant annulation, ordre host encore indéterminé. | UI-LIFECYCLE, INPUT-SERVICE |
| BCAP-CURRENTINPUT — Gates courants focus/repeat | Collecteur et preuves CPU à leurs versions conservés ; ces gates ne constituent pas la capture configurable. | CURRENT-CYCLE, INPUT-SERVICE |
| BCAP-SAVE — Sérialisation, édition et reprise | Contrat de sérialisation AS conservé ; cycle UI/persistance/commandes et règles des capacités restent séparés. | CURRENT-CYCLE, OUTSIDE-CAST |

Les consumers courants sont ceux déjà inspectés : collecteur QWER/focus/repeat, gates de commandes, lecteurs Game.cfg et helpers partiels. Leur code n'est pas remplacé par le modèle AS historique. Les recherches lexicales sont réutilisées uniquement sur corpus identique ; elles ne prouvent pas une absence dynamique globale ou un éditeur de capture complet.

## R4 — Contrôles et résultats

Neuf preuves et relectures clôturées réidentifiées ; faits de la matrice résolus par chemin et hash ; définitions des dix corrections conservées. Les 41 anciens objets de manque des unités sélectionnées sont conservés et affectés une seule fois à huit groupes de reprise. Cinq vues d'inconnues composées distinguent parties statiquement résolues et reliquat ouvert, sans modifier leur registre ni les déclarer entièrement closes.

Attendu : aucune perte ou duplication de manque, aucune référence orpheline, pas de double comptage ou de promotion de portée. Observé : contrôles structurés dans la preuve et relecture séparée. Les suites de cache déjà reconnues comme identiques ne sont pas rejouées ni additionnées ; les mêmes captures/profils/CPU ne sont pas recomptés comme nouveaux résultats. Corpus 1168, 25 fichiers protégés, cinq registres et état Git vérifiés avant/après.

Aucun nouveau désassemblage, export, test natif/Rust/AS, lecteur ancien, jeu, GUI, OS/IME, input physique, réseau, archive, installation, migration ou loader productif exécuté.

## R5 — Manques regroupés et conditions de reprise

Les huit groupes, avec tous leurs identifiants d'origine, sont dans la matrice :

1. **INPUT-SELECTION** : paire Input, flags/streams/valeurs et contexte historique déclarés ; alias normal reste ouvert. Le callback et le hash ne sont plus à redécouvrir.
2. **READ-BOUNDS** : entrée/cas précis pour ABI, pools, limites, conversion et lifetime. AL, capacité et calcul de copie restent acquis ; aucun incident mémoire reproduit.
3. **INPUT-SERVICE** : objet/vtable/setter +30 et helpers physiques identifiés dans un contexte versionné ; ne pas assimiler flags natifs et AS.
4. **GFX-MEMBERS** : base/import/member/ownership correspondant ; les noms et demandes sont connus, leurs succès ne sont pas inférés.
5. **QUEUE-DELIVERY** : un propriétaire et consommateur de queue/frame/flush, puis réception ; l'append de 56 octets ne vaut pas livraison.
6. **UI-LIFECYCLE** : ordre host, stage et temporisations réelles sous observation distincte ; aucune anomalie de fermeture affirmée sans cette entrée.
7. **CURRENT-CYCLE** : corrections produit autorisées séparément. La différence de hash non ASCII est documentée ; les primitives présentes sont conservées, sans éditeur ou persistance inventés.
8. **OUTSIDE-CAST** : les sémantiques complètes des capacités et règles serveur restent dans leurs fiches, hors capture ; aucune clôture par effet de bord.

Ces groupes sont des pointeurs de reprise, pas de nouvelles tâches ou une réécriture des inconnues. La comparaison de parties résolues ne ferme pas les reliquats et ne supprime aucune preuve.

## R6 — Corrections et prochain contrôle

Réutilisation des dix corrections BIND/CAST et de HUD-OPTIONS-ENTRY-01 avec leurs objectifs et critères inchangés, proposées et non appliquées. Aucune nouvelle correction doublon. La matrice relie chaque clause aux IDs pertinents ; le volume documentaire ne mesure pas le jeu terminé.

Prochain lot : **AUD-17.5-01-OPTIONS-MINIMAP-MOVESELF-01**, un seul checkbox déjà recensé : `OPT-SRC-78378f533df9d828`, FoundryOptionsMenu.xml ligne 133, `[HUD]MinimapMoveSelf`, `strategy=savecfg`, `updateonclick=true`. Ses consumers réels doivent être inspectés ; aucune absence, valeur effective, héritage ou état rendu n'est présumé à partir de la déclaration. Aucune nouvelle chaîne de fonctions de capture n'est ouverte faute d'entrée nouvelle.

## R7 — Livraison et relecture

Matrice `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\capture-coverage-matrix.json`, SHA256 `2062ff84299682139fb79919810760c15164042d5f85e1adfbf9e46add18d8c0`. Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\capture-synthesis-proof.json`, SHA256 `dd67552d837dabf9be88e5bea8fef6a465cab271022e3a24dddc267f6f83d082`. Producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\verify_capture_synthesis.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\audit-unit.json`. Relecture `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-SYNTHESIS-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Nouveaux artefacts documentaires isolés uniquement. Goal, critères, registres, code, assets, suivi, interface, bases, anciennes cases/notes/historiques et preuves antérieures inchangés. Aucun achèvement fonctionnel, du parent ou du goal global ; aucun pourcentage calculé.
