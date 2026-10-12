# Destinataire réel du paquet 0x95 — analyse statique, non intégrée

Cette préparation identifie le destinataire du paquet dans le PE 4.20. **Les nouveaux constructeurs, factories et consumers décrits ici n'ont pas été exécutés ni portés.** Aucun rustc, Cargo, exécutable réseau ou modification de production n'a été effectué pendant cet audit. Le port générique et son reçu dans `replay_packet95_agent` restent gelés ; leurs 340 contrats natifs ne qualifient pas les corps destinataires découverts ici.

Source : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Publication et propriété

`577D10` est le point d'initialisation retrouvé par les xrefs globales. Si `[14C761C] == 0`, il alloue **128 octets** à `577D41/577D46`, appelle le constructeur `576280`, puis publie le wrapper via `5C7E30` à `577D6F`. Il appelle ensuite `5765F0` pour sélectionner le véritable écran.

`576280` initialise d'abord le couple propriétaire aux offsets wrapper+0/+4 à zéro. Le wrapper contient notamment des compteurs/valeurs aux offsets +8..+28, une string24 à +2C, deux conteneurs à +48/+50, des flags +5C/+5D et un verrou initialisé à +68. Les offsets non écrits restent indéterminés ; ce constructeur ne doit pas être remplacé par un memset complet.

`5C7E30 → 5D7750` alloue un contrôle de **16 octets**, fort/faible=1, vtable **1085E5C**, objet possédé à control+0C. La publication globale écrit **control14C7620 puis object14C761C**, avant de libérer l'ancien contrôle. Contrairement à l'acquisition5CC140, un callback de destruction observe donc la nouvelle paire globale.

`1085E5C[0] = 5DDB80` détruit le wrapper par `576410` puis libère sa mémoire via la route active ; `[1] = 5D5B40` libère le contrôle. `576410` appelle virtual+0C du destinataire si wrapper+0C est actif, détruit le verrou et les deux conteneurs, détruit la string +2C, puis libère le couple destinataire aux offsets +0/+4.

`5C7D10 → 5D7680` est la publication de ce **couple interne**, contrôle16/vtable **1085E6C**. Son dispose `5DDB70` appelle **virtual+10 du destinataire avec flags=1**. Il ne faut donc pas employer le contrôle global1085E5C pour le destinataire, ni prendre slot0 pour son destructeur.

## Sélection du destinataire et vtables

`5765F0` lit le mode via `5B26E0`, compare `Tutorial` (1088AD4), puis le nom de carte `Map12` (1088AE0).

| Branche | Création | Vtable finale | Méthode paquet, slot0 |
| --- | --- | --- | --- |
| Tutorial, carte Map12 | alloc0x1F8 ; constructeur5B2BB0, `TutorialSettings.ini` | 10863FC | **5B3230** |
| Autre Tutorial | alloc0x1F8 ; constructeur5B2BB0, nom issu du mode + `ModeSettings.ini` | 10863FC | **5B3230** |
| Écran standard, factory71E9F0 | alloc0x608 ; constructeur578460→base57CD70 | 1084EA4 | **57D650** |
| Variante FirstBlood, factory71EAA0 | alloc0x610 ; constructeur71ECB0→base57CD70 | 10B0220 | **57D650** |
| Variante NightmareBots, factory71EB50 | alloc0x628 ; constructeur7226A0→base57CD70 | 10B0200 | **57D650** |

La branche hors tutoriel lit `Mission.ini` via le provider, puis **[LoadScreen] ScreenToLoad**, valeur par défaut `Default`, à `576827..576843`. Elle ajoute `Settings.ini` au nom obtenu et appelle `[123955C].virtual+18` à `57688F`. Le résultat reçoit `57F160` puis est publié dans le wrapper par `5C7D10` à `5768A2`.

La provenance de la factory est explicite : constructeurs de composants `730460`, `7304E0`, `730560` → descripteur `732E50` → callback `7347F0` → enregistrement **72E2A0** dans la paire globale123955C/1239560. Les composants finaux utilisent10AFDDC/10AFDE8/10AFDD0, dont slot+8 vise71E9F0/71EAA0/71EB50.

Le callback simple publié porte la vtable10AFCE0, slot+18=`730E00`, qui appelle slot+14 du callback imbriqué10AFC74 : `7357E0 → 736440`. Ce dernier acquiert sa référence faible via5BD6F0, reconstitue `this` à partir du propriétaire + ajustement, puis appelle le membre stocké **66A0FF**, thunk vers **virtual+8** du composant. Cela relie les factories aux constructeurs du tableau.

**Limite de sélection active :** l'ordre d'installation/activation des composants n'a pas été exécuté. `72E2A0` peut aussi composer une liste de callbacks via730160. Son slot+18=730240 parcourt des callbacks puis renvoie0. Cet audit ne prétend donc pas connaître le composant effectivement actif dans une session donnée, ni garantir qu'une factory non nulle suffit à produire un écran valide. Le code d'initialisation doit être qualifié avant publication réelle.

## Format effectivement lu : 25 octets de payload

`58A6F2` passe **packet+5**. Les deux méthodes slot0 copient exactement **six mots32 puis un octet**, soit **25 octets** : `57D6AF/57D6B1` et `5B3260/5B3262`. Un destinataire actif exige donc au moins ces25 octets accessibles à partir du payload (30 octets depuis le paquet original pour cette copie). Le port générique nul ne lit pas ces octets ; sa réussite n'est pas une preuve de validité du payload actif.

| Offset payload / record | Observation source, sans nom de champ inventé |
| --- | --- |
| +0..+3 | Clé u32 non signée du conteneur de records. |
| +4..+11 | Deux mots comparés à une entrée de la table globale14C7630, pas0xB5, borne14C7EAC, dans57D650. |
| +0C..+0F | Chargé comme flottant x87 pour une copie ultérieure. |
| +10..+13 | Remis à zéro si le bit0 de l'octet+18 vaut1 ; autrement conservé tel que reçu. |
| +14..+17 | Copié, sémantique non attribuée par cet audit. |
| +18 | Octet entier copié ; bit0 testé. Les sept autres bits ne doivent pas être perdus. |

L'accès record précède la copie. Il peut allouer et rebalance un arbre : on ne peut pas remplacer l'ensemble par une simple écriture dans une structure supposée existante.

## Records et effets UI

**Standard57D650** : arbre à recipient+1C, lookup/insertion **5BE170**, clé node+10, valeur node+14. En absence de clé : **5D32B0→5D5730** alloue **0x8C=140 octets**, puis initialise la valeur par **576000** ; insertion **5D32E0**. La valeur occupe120 octets, avec deux strings24 aux offsets+30/+60. Le constructeur ne nettoie que le bit0 de l'octet+18, ce qui impose des fixtures fill00/A5 pour contrôler les autres bits et le padding.

Après copie/masquage, `57D6C1` teste **record+40**. C'est le champ longueur de la string à+30 d'après576000 ; ce n'est pas un booléen arbitraire « assets prêts ». Si non nul, la méthode rejoint directement l'épilogue57DCE6. Sinon, elle sollicite le provider global2D787B8 virtual+48/+4C, des configurations/caches et textures. Dépendances directes importantes :90AD00,57C590,98A7F0,72E390,815CF0,5CE3A0,98F2F0/9879D0, opérations SSO et diagnostics991E60. Elle copie finalement record+10→+50, +0C→+4C et l'horloge993CE0→+54. Aucun de ces providers/UI n'est remplacé ici.

**Tutoriel5B3230** : arbre à recipient+4, lookup/insertion **5BE1F0**, node+10 key/value+14 ; allocation **5D34F0→5D57B0** de **0x60=96 octets**, initialisation **5E3DA0**, insertion **5D3530**. Valeur76 octets, string24 à+28. Test **record+38** (longueur de cette string). Si zéro, virtual+48 du provider2D787B8 remplit une string temporaire ; si elle est non vide, copie record+10→+44, +0C→+40, horloge993CE0→+48. La string temporaire est détruite par564900. Aucune hypothèse sur son nom utilisateur n'est nécessaire au port.

## Prochaine branche concrète et oracles requis

Porter ensemble **57D650/5B3230** et leurs accès record **5BE170/5BE1F0**. Commencer l'oracle par records déjà présents, avec longueurs+40/+38 non nulles : ce chemin natif vérifie réellement la copie25 et le bit0 sans solliciter les providers UI. Qualifier ensuite les nouvelles clés, rotations, réinsertions, allocations et destruction des strings/records ; ne pas laisser une frontière qui prétend produire une valeur de record fictive.

Les points exigeant exécution native avant raccordement sont : ordre lookup/copie/lecture du flag ; copies x87 et bits spéciaux des flottants ; conservation des bytes de padding ; initialisation de strings et sentinelles ; ownership global/interne lors de remplacement ; constructeurs null/échec allocation ; ordre de teardown UI puis contrôle ; dispatch de factory simple et composée ; disponibilité et véritables retours des providers2D787B8,2D78F1C et assets chargés. La branche première initialisation UI doit rester explicitement indisponible tant que ses consommateurs réels ne sont pas connectés.

Les désassemblages et constantes ci-joints sont des **preuves statiques**, pas des résultats de tests fonctionnels. `recipient_audit_manifest.json` enregistre cette limite, les sources extraites et les empreintes, séparément du jalon packet95 déjà validé.
