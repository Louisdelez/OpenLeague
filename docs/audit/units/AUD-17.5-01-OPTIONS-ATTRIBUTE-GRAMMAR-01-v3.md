# AUD-17.5-01-OPTIONS-ATTRIBUTE-GRAMMAR-01

UTC : 2026-10-31T05:27:37.691467+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et critère de fin
Qualifier par analyse statique la séparation entre attributs après un guillemet fermant dans le parseur natif relié à Options. Fin limitée : boucle et retours alignés,ligne originale identifiée,cas nominaux/refus/limites documentés et relecture distincte. Aucun changement du goal ni de ses critères.
Audit : producteur terminé,clôture du seul sous-lot soumise à la relecture séparée. Implémentation : non modifiée. Vérification : analyse statique et contrôles de fichiers exécutés;parseur x86 original,émulation,Rust,jeu,GUI et réseau non exécutés. Acceptation humaine : non demandée. Aucun contrôle logique ajouté aux78 déjà recensés.

## R2 — Sources et provenance
PE original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — 15973880 octets,SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Image PE32 x86,base préférée0x400000;les VA de ce rapport ne sont pas des adresses d’un processus lancé.
XML original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsKeybinds.xml` — 13896 octets,SHA256 `2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e`. Ligne7 à l’offset fichier236,sans modification :
```xml
    <group onlyshowif="game"paddingbottom="7">
```
Refus Python7:28 réutilisé sur la même empreinte,aucune répétition du test strict. Il prouve seulement le résultat de ce lecteur strict. Trois XML antérieurs sont conservés. Les preuves et l’échec de formulation de la première relecture antérieure sont préservés;la relecture v2 demeure la référence effective de ce lot antérieur.

## R3 — Consommateurs réels
Raccordement natif : le wrapper XML838270 appelle580EA0 (preuve antérieure conservée);580EA0 charge le flux via581020;581020 appelle le slot+8 du document à581292;vtable1084F54 donne582F80. Ce dernier identifie le nœud via5832B0 puis appelle son slot+8. L’élément construit à580270 écrit1082FF8→583920;son attribut construit à574180 écrit10850C0→584320. Le chaînage est statique;le provider et le chargement réel ne sont pas exécutés.
Consommateurs OpenLeague conservés : main.rs607–614 charge les réglages et applique EnvironmentQuality;render_probe.rs8–18 traite F11;native_graphics_options.rs1–9 définit la couche entière. Aucun de ces fragments ne prouve un éditeur Options ni l’acceptation de cet XML. Recherche précédente sur le corpus1168 fichiers réutilisée uniquement après vérification de toute sa composition et de ses empreintes.

## R4 — Attendu,observé et contrôles
18 fonctions contiguës sauvegardées avec octets/offsets/empreintes et tous leurs retours,68 instructions fixes,3vtables,2délimiteurs et table de classification par défaut vérifiés. L’analyse Capstone et ses DLL sont identifiées;aucun octet x86 du jeu n’est exécuté.
Chaîne discriminante :5843E7 lit la valeur entre guillemets via582C30 avec condensation=0.582D89 renvoie le curseur après le délimiteur.583B04 le conserve;si attribut valide et unique,583B2B l’ajoute puis583B34 revient à583A64.583A71 saute des blancs via5827A0;58281F peut rendre le même curseur sans incrément. Aucune garde ne demande un nombre de blancs supérieur à zéro. Si le caractère est p,les tests slash et chevron ne l’excluent pas;la boucle tente l’attribut suivant. La table initiale nomme ces lettres comme caractères de nom et p comme non-blanc;la locale CRT effective n’est pas qualifiée.
Conclusion de source : le manque d’espace entre `"game"` et `paddingbottom` n’est pas un motif de refus attesté par cette boucle native. Cette conclusion ne constitue pas une acceptation native du document complet.
Les cas ci-dessous sont des chemins dérivés des instructions,pas des exécutions paramétrées originales :

### S1 — Nominal authored spaced attributes
- Attendu : After the closing quote the element loop may skip a blank then starts the next attribute.
- Observé dans la source : 583B04 retains the returned cursor,583B34 returns to583A64;583A71 calls5827A0,whose increment is conditional on whitespace. No minimum skipped count is tested.
- Limite : Source-derived path only; no parse execution or full document success.

### S2 — Exact authored adjacent attributes
- Attendu : If the returned cursor is p after the closing quote, a zero-length whitespace skip is admitted; adjacency itself has no refusal guard.
- Observé dans la source : 582D89 returns delimiter-end cursor;5843E7 returns it unchanged;583B34 loops.58281F returns the same non-whitespace cursor.583A82/8C/95 do not reject p; constructor574180 selects attribute parser584320. Default ctype recognizes its actual name characters.
- Limite : Conditional static path assumes successful allocation/string operations and ordinary admitted ASCII characters; not actual full Keybind acceptance or game rendering.

### S3 — Applicable refusal: missing equals
- Attendu : A nonempty next token other than = after a parsed name takes the attribute-error branch.
- Observé dans la source : 5843A0 compares0x3D;5843A3 jumps58444B on mismatch;with owner document,584457 passes error7 to583230 and returns0. This is a source branch, no malformed XML fixture was executed.
- Limite : Analytical refusal condition, not a live/native parameterized rejection; with null owner no document error recording is inferred.

### S4 — Applicable refusal: invalid/empty attribute name
- Attendu : Name reader zero or end-of-string takes the attribute error branch.
- Observé dans la source : 584374 tests read-name result and58437C tests first byte;584467/584473 set error7 when owner exists;returns0. Alternate CRT locale branch remains separately unqualified.
- Limite : Static branch only; no claim about all malformed quotes, duplicate names, entity decoding or encoding failures.

### S5 — Boundary: delimiter termination is not full-document success
- Attendu : Do not infer successful document or include build from an attribute cursor.
- Observé dans la source : Document582F80 links nodes, records error flags and may return0 on multiple branches;stream581020 reads document+40 for its bool. The qualified absence of a separator guard says nothing about remaining source bytes/includes.
- Limite : Original document/parser/stream not executed; missing closing quote, trailing garbage, repeated attributes and include policy not qualified by this lot.

## R5 — Manques et conditions de reprise
Aucun espace ajouté,aucun parseur de remplacement écrit. Ne pas qualifier la source de corrompue sur ce seul refus Python. Allocation,chaînes,locale runtime,document entier,entités,quotes incomplètes et doublons ne sont pas validés par une absence de garde de séparation. La lecture après délimiteur seule ne prouve pas le succès global.
InternalPanel reste un include authored sans garde;son nom ne prouve pas optionnalité. Le graphe complet des includes et les conditions onlyshowif ne sont pas fermés. Les129 éléments racine ne deviennent pas129 contrôles actifs.
- **OPTIONS-NATIVE-DOCUMENT-RESULT** — Manque : Observed whole-document result on exact Keybind XML and other inputs;native parser error/consumption details were not executed. Reprise : Use already saved582F80/583920/584320 and exact pinned13896-byte source;separately scoped safe execution/ABI qualification required before calling an observed native parse result.
- **OPTIONS-INCLUDE-POLICY** — Manque : Mapped source or native missing-input policy for the unconditional InternalPanel include;onlyshowif evaluation and complete selected graph. Reprise : Follow native include handler838390 and decoder838020 from existing aligned callers;no repeated global filename scan without a new container/provider lead.
- **OPTIONS-CURRENT-FUNCTIONALITY** — Manque : Actual Options entry/editor callbacks,apply/cancel/persistence/focus and physical movie/provider selection. Reprise : Reuse HUD-OPTIONS-ENTRY-01/HUD-NATIVE-MOVIE-SELECTION-01 and existing settings consumers;any product change requires separate scope. Parent78control census/global audit stay open.

## R6 — Correction réutilisée
**HUD-OPTIONS-XML-INPUTS-01** conservée telle que proposée,pas appliquée ni clôturée. Sous-question résolue par source : absence d’une garde imposant un séparateur après valeur quotée. Les autres critères de cette fiche restent ouverts. Aucune fiche concurrente ni tâche normative créée. HUD-OPTIONS-ENTRY-01 et HUD-NATIVE-MOVIE-SELECTION-01 restent ouverts.
Prochain résultat clôturable : suivre838390 et ses callers pour établir le traitement d’un include absent;réutiliser les recherches de fichiers déjà réalisées,ne les répéter qu’avec un nouveau provider ou conteneur discriminant. Une correction produit exige un périmètre distinct. Aucun changement de critères de fin du goal.

## R7 — Livraison et conservation
Preuve producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTRIBUTE-GRAMMAR-01\options-attribute-grammar-proof-v3.json`. Script et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTRIBUTE-GRAMMAR-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ATTRIBUTE-GRAMMAR-01\delivery-readback.json`;elle seule peut clore ce sous-lot documentaire après sept rubriques vérifiées.
Deux essais conservés : empreinte antérieure mal recopiée,puis sérialisation JSON refusant des octets bruts dans cinq observations. Version v3 : empreinte correcte et octets encodés en hexadécimal;critères techniques identiques. Aucune preuve partielle ouverte et aucun rapport écrit lors des essais refusés.
Avant/après : cinq registres et25 fichiers gelés inchangés,1168 sources applicatives identiques,Git HEAD/branche/76 modifications antérieures conservés. Originaux XML/PE et preuves antérieures conservés. Application de suivi,interface et bases non ouvertes ni modifiées;aucune installation ou migration. Goal et critères inchangés.
La clôture permise est celle de la seule analyse statique de séparation des attributs. SYS-17.5-01 et le goal SYS-01.2-02 restent ouverts;aucune fonctionnalité,jeu,parcours UI ou acceptation humaine déclaré terminé.
