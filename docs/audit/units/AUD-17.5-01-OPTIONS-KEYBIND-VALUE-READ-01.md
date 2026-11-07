# AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01 — valeur et statut de lecture des bindings

Date : 2026-10-31T08:48:16.152737+00:00. Parent : SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal : SYS-01.2-02, inchangé.

## R1 — Portée et fin

Qualifier le lecteur `8B01C0`, son statut `AL`, les sources de sa chaîne de sortie et leurs limites directes. Le lot couvre quatre corps normaux, dont le convertisseur et ses branches après un premier `RET`. Il ne clôture pas le provider, le système d'input ou l'éditeur des Options. Le producteur ne prononce pas sa propre clôture : voir la relecture indépendante.

Audit : contrats et frontières établis. Implémentation : aucune modification ; primitives de configuration présentes, cycle Input.ini non qualifié. Vérification : statique, avec preuves d'exécution antérieures conservées à leur portée. Acceptation humaine : non demandée. Le parent et le goal restent ouverts.

## R2 — Sources et versions

PE original 4.20 : SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Corps examinés : `8B01C0..8B02F6`, `8AE0E0..8AE17A`, `8AE6A0..8AEB68`, `8AF290..8AF32F` (bornes de fin exclusives).

Les continuations du convertisseur reprennent exactement aux fins de décodage précédentes. Aucun préfixe déjà décodé n'est rejoué. Le bloc après `RET 8AEA48` et le retour d'absence `8AEB61` sont inclus ; le corps finit par un saut interne vers son épilogue. Les voisins sont exclus selon leurs prologues, le padding et les branches.

Les 1440 cas antérieurs du lecteur entier `8AF830` servent d'analogue pour les flags et statuts ; ils ne valident pas ce nouveau lecteur de chaînes. Le reçu natif existant des ressources fournit la provenance de `typed_string 8AF290`, `typed_integer 8AF330` et `typed_float 8AF470`. Aucun profil n'est rejoué. Les preuves et l'erratum SSO antérieurs sont conservés.

## R3 — Contrat et consommateurs réels

`8B01C0` reçoit l'objet dans ECX, la sortie SSO à `[EBP+8]`, le hash à `[EBP+14h]` et le repli à `[EBP+18h]`. Un repli NULL devient une chaîne vide. Les flags du contexte commandent les lectures :

| Conditions | Lectures | Statut AL |
|---|---|---|
|14A=0, 148=0|Copie du repli|0|
|14A=0, 148=1|Représentations typées ; repli si absence|typed_match|
|14A=1, 149=0|Table texte ; repli si absence|text_present|
|14A=1, 149=1|Typé dans un temporaire, puis texte avec ce temporaire comme repli|typed_match OR text_present|

Ce statut ne signifie ni chaîne non vide, ni écriture disque, ni acquittement d'une opération. Dans le caller `8B0750`, une correspondance typée seule ou une entrée texte présente mais vide dans objet+4 suffit à éviter objet+0. Une simple copie du repli, sans correspondance, retourne 0 et laisse consulter l'autre objet.

Le lecteur texte `8AE0E0` appelle `5C6830` avec le hash et compare le résultat au sentinel objet+4. Une entrée présente copie la chaîne node+0Ch, sauf auto-affectation, puis retourne 1. Une entrée absente copie le repli, ou vide la sortie si le repli est NULL, puis retourne 0. Une valeur vide présente reste donc distincte d'une absence.

Le getter typé `8AF290` exige une plage de 4 octets renvoyée par `8BCB90`. Une autre cardinalité retourne 0 sans modifier la sortie dans ce corps. Si la plage correspond, un index sélectionne un offset uint16 dans objet+118h, ajouté à la pool objet+13Ch ; les octets jusqu'au NUL sont copiés. Une chaîne présente mais vide retourne aussi 1. La validité des plages, de la pool et la création des entrées restent des garanties amont.

`8AE6A0` essaie, dans l'ordre : chaîne, entier, float32, booléen, puis deux, trois ou quatre composantes float. Le premier getter positif conduit à une conversion et au retour 1 ; aucune correspondance retourne 0. Le getter de chaîne conserve le temporaire sur absence ; les autres getters écrivent des valeurs intermédiaires locales avant conversion. Les booléens choisissent les littéraux `"0"` et `"1"` ; les composantes utilisent un espace. La précision, la locale et les erreurs des helpers de formatage ne sont pas entièrement qualifiées. Le statut 1 ne valide pas séparément chaque octet formaté.

Ces littéraux booléens concordent avec le chargement exact `"1"` du modèle Quickbind. Une entrée texte `"true"` reste en revanche une chaîne ; elle n'est pas transformée ici en `"1"`. Aucune préférence effectivement sélectionnée n'est observée dans ce lot.

Les consommateurs actuels `Parsed.lookup` et `read_integer_value` portent respectivement les primitives présence/repli et composition des statuts. Ils servent à Game.cfg et au chargement courant inspecté. Ils ne prouvent pas un lecteur de chaînes typées complet, un éditeur Input.ini ou des modes normal/rapide persistants. Le chargeur productif, qui peut créer ou renommer une configuration, n'est pas exécuté.

## R4 — Attendu, observé et contrôles

- Quatre corps normaux, 579 instructions et 44 points fixes vérifiés dans les octets ; retours, blocs tardifs et voisinages identifiés.
- Flags, composition OR, valeur vide présente, absence avec repli, cardinalité du getter typé, ordre des sept getters et littéraux vérifiés statiquement. Aucun état natif inventé ou exécuté.
- Aucun plafond `13A0h` dans ces quatre corps : les chaînes sont affectées entières ou après un scan NUL. La contrainte « compte + NUL » et l'adresse maximale du caller, documentées précédemment, restent ouvertes faute de borne amont et d'observation runtime. Aucun incident mémoire reproduit.
- Primitives actuelles inspectées. Les 1440 cas entiers et la preuve des ressources sont réutilisés, sans nouveau test. Les anciens scans de noms et d'archives ne sont pas relancés.
- Corpus de 1168 fichiers, 25 fichiers protégés, cinq registres et état Git conservés. Aucun jeu, x86, AS, Rust, GUI, input physique, réseau, installation, migration ou chargeur productif exécuté.

## R5 — Écarts et conditions de reprise

La preuve structurée fournit, pour chacun des identifiants suivants, le manque exact, son impact et l'entrée de reprise :

- `VREAD-ENTRY-MATERIALIZATION` : recherches par hash et producteurs des tables, dont une éventuelle entrée pour l'alias normal. Réutiliser les preuves du parser/cache avant toute analyse nouvelle.
- `VREAD-SELECTED-FILENAME` : initialiseur `8B3CF0`, fichier Input.ini sélectionné et contexte des providers/overlays. Inspecter ce caller direct sans lancer le chargeur.
- `VREAD-CONVERSION-DETAILS` : stockage des types non textuels, précision, locale et erreurs de formatage. N'ouvrir qu'une branche justifiée par un réglage ou un contexte précis.
- `VREAD-BOUNDS-LIFETIME` : validité et terminaison des pools, bornes amont, réentrance et atteignabilité de la copie maximale. Conserver le calcul du caller sans prétendre avoir reproduit un incident.
- `VREAD-CURRENT-CYCLE` : édition, application, annulation, sauvegarde, reprise et équivalence physique/native. Reprendre les corrections existantes sous une autorisation produit distincte.

## R6 — Corrections conservées

Les dix corrections de bindings/modes et `HUD-OPTIONS-ENTRY-01` restent proposées, non appliquées, avec leurs définitions inchangées. Les contrats présence/vide/repli/conversion précisent leurs entrées. Aucun doublon ni critère normatif modifié. Les limites de domaine d'octets et de copie du lot précédent sont conservées.

Prochain lot : `AUD-17.5-01-OPTIONS-KEYBIND-FILENAME-01`, sur l'initialiseur `8B3CF0` du filename utilisé par `8B16C0`. Un pointeur et des flags ne suffisent pas à identifier le fichier historique effectivement lu. Réutiliser les preuves de provider/locale ; aucune recherche générale ou exécution du chargeur.

## R7 — Livraison et relecture

Preuve neuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01\keybind-value-read-proof.json` (SHA256 `78ebe4ec98c80355ccbb5928e42921d7eee5ad10f8c48fe7eda1ed0691db6fae`).

Fiche : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01\audit-unit.json`. Synthèse : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01\verify_keybind_value_read.py`. Les cinq reçus d'inspection et leurs scripts sont identifiés dans la preuve, avec les continuités de bornes. Relecture séparée : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Seuls ces nouveaux artefacts documentaires et ce rapport sont écrits. Goal, critères, registres, produit, assets, suivi, interface, bases et preuves antérieures inchangés. Aucun achèvement fonctionnel, du parent ou du goal global ; aucun pourcentage de jeu calculé.
