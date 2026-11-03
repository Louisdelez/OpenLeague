# AUD-17.5-01-OPTIONS-MENU-INCLUDE-BOUNDARIES-01

Date UTC : 2026-11-01T07:19:38.196317+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Portée et décision

Trois directives include physiques du Menu principal. Audit documentaire prêt pour relecture distincte ; implémentation partielle/non qualifiée, vérification documentaire, acceptation humaine non demandée. Les192nœuds Keybinds déjà audités ne sont pas recomptés ; les36nœuds Phreakspace ne reçoivent ici aucune clôture de comportement. Le parent et le goal restent ouverts.

## 2. Sources et identités

|Ligne|ID|Fichier demandé|Voisin exact|Condition propre|
|---:|---|---|---|---|
|7|OPT-SRC-76e255ddd5e968ad|FoundryOptionsKeybinds.xml|identifié|None|
|184|OPT-SRC-12140a082818104e|FoundryPhreakspace.xml|identifié|locale:en_us,summoner:Riot Phreak&#124;summoner:Phreak|
|185|OPT-SRC-1cb7a4e4a6801410|FoundryOptionsInternalPanel.xml|absent au chemin contrôlé|None|

La preuve lie les octets XML4.20, le catalogue357nœuds, les PE/GFX et les exports AS antérieurs. Les deux fichiers connus sont identifiés par chemin/taille/SHA256 : Keybinds192nœuds et Phreakspace36nœuds physiques. Leurs racines data ont respectivement2et1enfants directs selon l’inventaire lexical. Le reader XML strict ElementTree rejette Keybinds ligne7/colonne28 ; Phreakspace se parse avec36éléments. Ces comptes ne prouvent pas l’instanciation ou l’acceptation du lecteur historique.

La troisième cible est contrôlée uniquement comme voisin Menu_SC4. La même absence était déjà recensée ; aucune nouvelle recherche d’archives ou de contenu virtuel. FoundryOptionsInternalKeybinds.xml est une autre frontière déjà documentée, conservée distincte.

## 3. Consommateurs et raccords

Le parser auxiliaire XMLDeseralizer/URLLoader est appelé par le chemin GFXPlayer/loadGameFiles avec TraceSerializer et environnement de debug. Il met les includes en file avant le filtrage des modèles. Après lecture, il prend les enfants de la racine incluse, sans ses attributs racine, puis les insère à la place de la directive. Les attributs de l’include, sauf filename/children, ne sont copiés que si l’enfant n’a pas déjà la propriété.

IO_ERROR saute readData puis poursuit la file/prune ; le guard de nom courant/top peut retourner avant COMPLETE. Ces branches source n’établissent ni optionnalité native, ni réussite d’I/O, ni sécurité de cycle sur tout le graphe. Aucun de ces chemins n’est exécuté ou émulé dans ce lot.

Le chemin de production est le callback InitializationData qui transmet param1.xml as Object, GameSerializer et param1.environment à buildOptionsMenu. Il ne devient pas le chargeur auxiliaire par déduction. Le prédicat source modèle fait AND entre groupes séparés par virgule, OR entre alternatives séparées par pipe, puis recherche des tokens exacts. Pour Phreakspace : locale:en_us ET (summoner:Riot Phreak OU summoner:Phreak). La casse et l’espace restent conservés. L’admission effective en EUW/en_GB n’est pas observée.

Les9fenêtres de consommateurs actuels restent identifiées et vérifiées. Une seule requête nouvelle cherche les trois noms de fichier, en sous-chaînes sans distinction de casse, dans le corpus1168inchangé : zéro occurrence. Cela ne prouve pas l’absence d’un provider générique ou d’un comportement équivalent. Aucun ancien test, lecteur ou recherche globale relancé.

## 4. Attendu et observé

- Deux fichiers voisins connus — attendu : Identités 4.20 et parentés physiques conservées, sans nouveau crédit de comportements. Observé : Keybinds192nœuds lexicaux/2enfants racine mais rejet XML strict ligne7/28 ; Phreakspace36nœuds parsés/1enfant racine. Aucun arbre natif effectif observé.
- Fichier interne non retrouvé au voisin exact — attendu : Absence précisément bornée, aucune règle optional/native inventée. Observé : Même absence que l’index physique sur le chemin exact ; archives globales et contenu virtuel non réinspectés, reprise nommée.
- Condition et chemins auxiliaire/production — attendu : Conserver le prédicat exact et différencier chargement, queue et admission. Observé : Sources réutilisées : queue XML auxiliaire, copie sous condition de propriété et callback de production distinct ; ni gate effectif ni I/O exécuté.
- Consommateur actuel — attendu : Requête nouvelle limitée aux trois fichiers ; inspection des consumers existants ; aucune absence globale déduite. Observé : 1168sources inchangées, zéro occurrence nominale ; les9fenêtres courantes héritées sont vérifiées, provider effectif non qualifié.

Un premier producteur a échoué sur le parsing strict de Keybinds avant toute requête actuelle. Sa sortie, son code1 et son script sont conservés. La version2 enregistre le refus et reprend l’indice d’attribut adjacent déjà recensé, sans altérer la source.

Contrôles réels : identités/octet des3directives, parentés, voisins exacts et XML connus ; champs et fenêtres sources hérités ; nouvelle requête nominale ; corpus, Git,25fichiers protégés et5registres avant/après. Producteur puis lecteur documentaire distincts ont leurs scripts, sorties et codes réels. Pas de cas produit, rendu, I/O AS, exécution native/Rust/GUI/réseau ou émulation.

## 5. Manques et reprise

- INCLUDE-KEYBINDS-SYNTAX — Le fichier Keybinds historique contient deux attributs adjacents sans séparateur à la ligne7 ; ElementTree rejette ligne7/colonne28. Les192nœuds sont un inventaire lexical, pas une preuve de parsing réussi. Le résultat du lecteur Flash/natif reste inconnu. Reprise : Qualifier le reader historique nommé ou obtenir une variante officielle identifiée ; toute copie corrigée locale doit conserver source/hash, changement exact et choix de compatibilité versionné, sans réécrire la référence ni inférer un échec natif.
- INCLUDE-INTERNAL-PANEL-CONTENT — FoundryOptionsInternalPanel.xml n’est pas un fichier au voisin Menu_SC4 contrôlé. Contenu virtuel, emplacement alternatif et politique native required/optional non qualifiés. Reprise : Membre exact de manifeste/archive/backend ou caller/log natif nommé pour ce fichier, avec octets/hash ; à défaut, contrat local versionné de refus, sans invention ni nouvelle recherche globale inchangée.
- INCLUDE-PRODUCTION-EXPANSION — Les deux XML connus et la règle du parser auxiliaire ne prouvent pas l’expansion, la propagation des conditions ou l’admission réelle par le producteur de production. Reprise : Producteur InitializationData.xml, provider, schéma et environnement effectif nommés ; observation autorisée du payload/arbre et des contextes, sans transposer TraceSerializer/debug au natif.
- INCLUDE-CURRENT-ADAPTER — La recherche nominale nouvelle ne trouve pas ces trois fichiers dans le corpus courant ; la présence d’un provider générique ou son équivalence ne s’en déduit pas. Le parcours d’inclusion courant reste non qualifié. Reprise : Consommateur/provider précis ou correction partagée autorisée ; cas positif, refus et échecs identifiés de HUD-OPTIONS-INCLUDE-PROVIDER-01, avec mêmes sources et sans répéter la requête inchangée.

## 6. Correction précise

Proposition non appliquée HUD-OPTIONS-INCLUDE-PROVIDER-01 : Relier les trois frontières include du Menu à un provider nommé avec contenu, contexte et refus explicites. Elle réutilise les objectifs ENTRY et PANELS et conserve la frontière interne Keybinds existante ; aucune modification des registres ou de leurs critères.

- Chaque frontière a une identité et une décision observable chargé/refusé/indisponible avec source et contexte ; aucun faux succès à partir d’un is_file ou d’une file de callbacks.
- Contenu absent, XML invalide, type/arbre incompatible, condition inconnue, inclusion répétée/cyclique et ressource absente ont une politique explicite et attendus/observés ; ne pas présenter le guard auxiliaire comme une sécurité générale.
- Les conditions Phreakspace conservent casse, espaces, virgule et alternative pipe ; aucun accès admis en déduisant seulement la locale de référence.
- Le parcours effectif du Menu est observé séparément, avec actifs/providers/version identifiés ; 192/36 restent des comptages physiques et le contenu inconnu n’est pas inventé.

Reprise : Autorisation produit distincte et provider/schéma nommés ; pour le contenu interne, apporter un membre de manifeste/backend, ses octets identifiés ou un contrat local versionné de refus/optionnalité. Aucun scan global inchangé.

## 7. Preuves et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MENU-INCLUDE-BOUNDARIES-01. Preuve menu-include-boundaries-proof.json, scripts audit_menu_includes_v2.py et verify_delivery.py, reçus producer-execution-v2.json (réussite) et reader-execution.json ; producer-execution.json conserve le premier échec, relecture delivery-readback.json. Le producteur ne s’auto-déclare pas clos : le lecteur distinct examine les sept rubriques et décide de la clôture documentaire limitée.

Partition physique Menu : 67contrôles +32descripteurs +5panneaux +19structures +3frontières +3présentations =129. Aucun pourcentage de jeu terminé. Prochain lot : AUD-17.5-01-OPTIONS-MENU-PRESENTATION-01. Les36nœuds Phreakspace et le parcours réel du menu restent séparés.

Goal, critères normatifs, Plan, UI, bases et registres inchangés ; aucun logiciel installé, aucune migration, relance, restauration, suppression ou modification de gameplay.
