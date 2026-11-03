# AUD-17.5-01-OPTIONS-INCLUDE-POLICY-01

UTC : 2026-10-31T05:35:11.461603+00:00. Parent SYS-17.5-01; exigence OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Portée et fin du lot
Établir le consommateur des includes Options et la propagation de son retour en cas de chargement refusé. Fin documentaire : handler qualifié,chemins normal/refus/limites attestés,consommateurs actuels conservés et sept rubriques relues. Ce sous-lot ne termine ni le graphe de ressources ni le menu fonctionnel.
Audit : producteur terminé,clôture réservée à la relecture séparée. Implémentation : non modifiée. Vérification : analyse statique et intégrité exécutées;aucun jeu,parseur x86,émulation,Rust,GUI ou réseau exécuté. Acceptation humaine : non demandée. Goal et critères inchangés.

## R2 — Sources,identité et réutilisation
PE original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe` — 15973880octets,SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. PE32x86,base préférée0x400000;les VA sont des repères de l’image,pas celles d’un processus.
Root XML : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` — 11444octets,SHA256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de`. Trois XML originaux conservés;aucune reconstruction ni correction d’espace.
Relecture du lot précédent validée et empreintes conservées : analyse de séparation des attributs close,document complet non exécuté. Recherche antérieure de InternalPanel réutilisée dans son périmètre nommé et daté;aucun nouveau scan général ni nouveau contrôle ZIP. Existence dans le même répertoire seulement relue. Aucun recours à une source communautaire sans piste discriminante.

## R3 — Consommateurs réels et chemin natif
838020→838390 à838161 convertit le premier élément sélectionné du document racine. **838390 est le décodeur général**,pas le handler spécifique des includes. Sa boucle de fils compare le nom à la chaîne exacte `include` (10C27A0),puis838519 appelle **838740** sur égalité. Les autres noms passent par la récursion8384E0. La comparaison de cette balise est octet par octet,sans casefold dans cette plage.
838740 cherche l’attribut `filename` (10C26FC) via581ED0,lit sa valeur+2C,construit un document et appelle838270 à8387EF. Ce chargeur conserve les gardes déjà qualifiées : provider+28 faux→false;chemin mappé vide→false;sinon580EA0 puis son bool retourné. Le provider et le choix physique restent indéterminés.
Consommateurs OpenLeague conservés : main.rs607–614 charge les réglages et applique EnvironmentQuality;render_probe.rs8–18 traite F11;native_graphics_options.rs1–9 conserve la couche de lecture entière. Ces fragments ne prouvent pas un éditeur Options. Recherche antérieure réutilisée après vérification de la composition et des empreintes des1168sources.

## R4 — Résultat attendu et observé dans le code
**Chargement d’include faux :**838800 conserve AL;838809 saute à838A7F,puis838A8E détruit le document temporaire. Aucun appel d’ajout à la destination de ce handler n’est atteint sur ce chemin. Après son retour,le caller continue immédiatement à83851E puis avance les frères : aucun test de succès du handler ne rejette explicitement le parent dans cette chaîne normale. Cela ne prouve pas que le nom virtuel est effectivement absent sur cette installation ni que le menu affiché fonctionne.
**Chargement vrai :**le handler sélectionne le premier élément racine,puis ses enfants éléments (574110).838868 les convertit et8389FE les soumet à un appel virtuel destination+3C. Rôle d’ajout déduit des arguments et du contexte;implémentationGFx/effet runtime non exécutés. Les retours tardifs après les premiers ret sont conservés,notamment838AC6 et8385A1;pas de découpage au premier ret.
**Attributs de l’include :**après conversion d’un enfant,la boucle propose les attributs de l’include,à l’exception des noms exacts `include` et `children`. Si le test virtuel+0C indique une propriété déjà présente,l’attribut de l’enfant est conservé;sinon chaîne créée puis affectation via+14. Il n’y a pas d’évaluation de l’expression onlyshowif dans les plages qualifiées. La grammaire et la visibilité effective appartiennent au consommateur frontend encore non qualifié.
7fonctions avec octets/offsets/empreintes et branches directes entièrement bornées;66instructions fixes et7littéraux. Python,pefile,Capstone et sa DLL sont identifiés dans la preuve. Les six cas suivants sont des observations statiques,pas des tests paramétrés du client original :

### I1 — Nominal: loaded include with child elements
- Attendu : After a true loader result and a first root with element children,the handler converts those children and submits each to the destination virtual+3C call.
- Observé : 838809 falls through;838848 locates first element child,838868 recursively converts it;8389FE invokes destination+3C;838A24/4E advance siblings. The original include directive itself is not submitted as a wrapper by this route.
- Limite : Conditional source path;actual GFx virtual implementation,allocation and output rendering not executed. Additional top-level roots and direct include-as-expanded-child semantics not generalized.

### I2 — Applicable refusal: loader returns false
- Attendu : No destination append from this include;temporary XML cleanup;normal return to caller sibling traversal instead of an explicit parent-rejection flag.
- Observé : 838800 saves AL;838807/809 branch to838A7F before expansion;838A8E cleans XML. Caller838519 immediately proceeds83851E and the sibling loop,without testing a handler result.
- Limite : This normal C++ source path is established;it does not prove the virtual filename is refused on this installation,nor absence of exceptions/runtime frontend failure.

### I3 — Missing filename attribute versus empty string
- Attendu : No matching filename attribute returns before document construction. An existing empty value is not equated to a missing attribute.
- Observé : 581ED0 returns0 on no match;8387A3 jumps to838A93. With a match,the value storage pointer at+2C is used;no test of its first byte appears before8387EF. An empty string therefore reaches the loader under those source preconditions.
- Limite : No malformed/missing/empty XML fixture executed;actual result of provider handling an empty virtual filename remains unknown.

### I4 — Absent provider entry,empty mapped path or parser false
- Attendu : Each of these loader refusals reaches the same false-result include path.
- Observé : 8382E1/83831D returnfalse for provider/path branches;83832D calls580EA0 and838332 saves its bool;838365 returns it. Include838809 tests that bool once;it does not classify the failure cause.
- Limite : Provider/root/alias and actual whole-document acceptance not qualified;logs for provider/path are source branches,not live errors.

### I5 — Include attributes and onlyshowif visibility
- Attendu : After child conversion,nonreserved include attributes are offered only if the child lacks the named property;their expression is not evaluated by these C++ spans.
- Observé : 8388CB/838909 skip exact names include/children;83893D tests a child property and838941 skips on true;otherwise838977 creates string value and8389A9 submits property. There is no onlyshowif or locale predicate in the pre-load include path.
- Limite : Virtual roles inferred from arguments/context,not recovered symbols;actual GFx/AS3 expression grammar and visibility for EUW/en_GB remain unqualified. No locale exclusion or optionality inferred.

### I6 — Case-sensitive tag dispatch and child-only expansion
- Attendu : Only a child node whose name exactly equals include follows838740;other nodes recurse through838390. Loaded document with no suitable child appends none.
- Observé : 83849B→8384D0 compares literal bytes to NUL without casefold;8384D9 selects838514 on equality.838813/815 and first-element lookup guard the successful-load expansion.
- Limite : Scope is normal source control flow;unknown tags,root count,recursive cycles/depth and exception behavior are not validated.

Entrées authored conservées :
- Ligne7 : `    <include filename="FoundryOptionsKeybinds.xml" />`
- Ligne184 : `<include filename="FoundryPhreakspace.xml" onlyshowif="locale:en_us,summoner:Riot Phreak|summoner:Phreak" />`
- Ligne185 : `<include filename="FoundryOptionsInternalPanel.xml" />`

## R5 — Manques,limites et reprise
Le root contient un include InternalPanel sans garde authored. Un refus de chargement ne produit pas de rejet parent explicite dans cette boucle;cela ne rend pas son contenu connu ou optionnel pour le périmètre public. Le fichier effectif peut encore dépendre du mapping/provider. Ne pas reconstruire la ressource pour éviter une panne générale supposée.
Le garde Phreak est conservé littéralement et transmis comme attribut candidat : aucune exclusion en_GB,aucune priorité logique et aucun résultat visible ne sont déduits. Une valeur filename vide n’est pas assimilée à un attribut absent;le pointeur de chaîne peut être valide et atteindre le chargeur. Le résultat réel reste à qualifier.
- **OPTIONS-MAPPED-INTERNAL-CONTENT** — Manque : The mapped InternalPanel input,its content,applicability and any native controls it contributes have not been established. Reprise : Require a named provider mapping/container entry or source-attested public applicability/exclusion;reuse pinned filename search and source-open guards,no broad rescan absent a new lead.
- **OPTIONS-FRONTEND-VISIBILITY** — Manque : Actual GFx virtual effects,selected movie and onlyshowif grammar/visibility are unqualified;attributes inherited in C++ are not evaluated here. Reprise : Follow selected physical movie and the consumer of the transferred onlyshowif property;qualify has-property semantics,child precedence and EUW/en_GB conditions from frontend source or explicit local contract.
- **OPTIONS-RUNTIME-AND-CURRENT** — Manque : Original full-document/load/GUI/exception cases and actual current Options editor lifecycle remain unexecuted or unimplemented by this audit. Reprise : Reuse exact XML/native code/actual current settings consumers;separate scope for safe native execution or product correction. Keep parent/global audit open for other HUD controls and requirements.

## R6 — Correction existante et résultat clôturable
**HUD-OPTIONS-XML-INPUTS-01** réutilisée sans modification de sa définition ni du registre. Avancée documentaire : dispatcher/handler,omission sur bool faux et transfert conditionnel d’attributs établis par source. La fiche reste proposée,non appliquée et ouverte pour contenu/mapping/visibilité/contrôles. Aucune nouvelle tâche concurrente.
HUD-OPTIONS-ENTRY-01 et HUD-NATIVE-MOVIE-SELECTION-01 restent ouverts. Prochaine entrée discriminante : source du contenu InternalPanel via provider ou contrat de visibilité onlyshowif dans le movie effectivement sélectionné. Pas de répétition du scan de fichiers déjà acquis sans nouveau conteneur/provider.

## R7 — Livraison,relecture et conservation
Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INCLUDE-POLICY-01\options-include-policy-proof.json`. Script et spécification isolés dans `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INCLUDE-POLICY-01`. Relecture distincte attendue : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-INCLUDE-POLICY-01\delivery-readback.json`;elle seule peut clore ce sous-lot documentaire après examen des sept rubriques.
Cinq registres et25fichiers gelés inchangés;1168sources applicatives identiques;Git HEAD/branche/76modifications antérieures conservés. Originaux et preuves antérieures conservés. Goal,critères,Plan,interface et bases inchangés;application/bases non ouvertes,aucune installation ou migration.
Clôture permise uniquement pour le contrat statique de dispatch et de propagation du retour des includes. Le parent SYS-17.5-01 et le goal SYS-01.2-02 restent ouverts;78contrôles logiques antérieurs inchangés,aucun pourcentage ni jeu/menu fonctionnel déclaré terminé.
