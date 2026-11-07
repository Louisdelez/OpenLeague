# AUD-22.1-07-TR-01 — Déclaration tr invalide dans le lecteur de fontes

Date de vérification : 2026-11-02  
Exigence parente : SYS-01.2-02 / OLF-3a11ace9-485c-55ae-8dff-2533902a5839  
Sous-lot : AUD-22.1-07-TR-01, proposé dans docs/audit/AUDIT_METHOD.md, parent fonctionnel SYS-22.1-07  
Décision : audit terminé pour le comportement du lecteur Rust courant et la comparaison aux indices natifs disponibles. La grammaire native de tr reste inconnue; le parent et SYS-01.2-02 restent ouverts.

## 1. Exigence et frontières

Question : le lecteur courant de configuration de fonte détecte-t-il une déclaration tr non terminée? Comparer son comportement aux indices disponibles du client 4.20. Ce lot ne couvre pas le parseur de traduction complet, le callback de texte, les recherches de chaînes, les widgets, les glyphes ni le rendu.

Critère de fin : identifier source et consommateur, observer le comportement courant sur le cas nominal et le cas de frontière déjà exécutés, confronter les indices natifs sans prétendre connaître la grammaire native, conserver les inconnues et une condition de reprise.

## 2. Source native et provenance

La ressource sélectionnée est DATA/Menu/fontconfig_en_GB.txt dans lol_game_client 0.0.1.7, release 0.0.1.7. Le reçu V795 l'identifie à D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt, 2 220 957 octets, SHA-256 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3, MD5 a5cebda5ff38fc64ccd4eb5a79c126a8. Membership au manifeste sélectionné : matches_selected_project_manifest. La copie F data/4.20/font_configuration/menu/fontconfig_en_GB.txt a la même taille et SHA-256, vérifiés ce tour.

Le fichier natif contient des déclarations tr; l'inventaire antérieur compte 12 704 lignes à clés lexicales uniques. Un exemple courant de texte Annie est présent ligne 4158. Le cas malformé testé plus bas est une entrée synthétique du harnais, pas une ligne attestée du fichier natif.

## 3. Consommateur actuel

Le consommateur F est crates/client/src/native_hud_font_configuration.rs, 5 807 octets, SHA-256 500ea12ef4fffd40ccf856169d59b2a9c17194620c22bacbe7c7422fc329bf14, empreinte identique à l'entrée source du reçu d'exécution V795. load choisit la configuration de fonte à partir du profil de locale. Dans parse, une ligne commençant par tr est rejetée si elle est hors section; dans une section déjà ouverte, le lecteur ne valide ni guillemets, clé, signe égal, valeur, échappements ni contenu. Il ne retourne que maps et libraries; il ne produit pas de dictionnaire de traductions.

## 4. Résultat attendu et observé

Le reçu d'exécution hérité, vérifié contre ses empreintes, compile les vrais modules Rust ciblés et exécute un harnais isolé avec des copies explicitement fournies; ses deux commandes ont code 0. Le binaire du jeu n'est pas exécuté.

- Nominal : 38 profils de locale chargés; chacun choisit le fichier déclaré et retourne les alias/fontlibs attendus.
- Refus : 3 erreurs de chargement et 4 refus du parseur local (directive inconnue, map hors section, encodage invalide, alias répété).
- Frontière tr : le harnais fournit une section valide, quatre maps et une fontlib, puis la ligne incomplète tr "unterminated. Observé : accepted=true, error=null, aucune traduction retournée. Le reçu compte un cas invalid_translation_accepted.
- Le lecteur accepte également les 12 704 lignes tr des configurations nominales parce qu'il les laisse hors de son domaine de fonte; cela ne signifie pas qu'il les a analysées.

Les reçus existants sont docs/fidelity_rea_locale_text_v795.json (398 490 octets, SHA-256 C2F7946F3D5717D6B9D1D0F4279716036CEA9226FCE5C14FE917EF9875859F74), OBSERVATIONS_VERIFIED.json (369 252 octets, SHA-256 C7BCF7AEA8573764015A91F8DD82507CB58DF550AC7CDC5C33E740B5AA0C7958), et CURRENT_RECEIPT.json (31 240 octets, SHA-256 D533E67E245F57821A1309F8FE91249B47D34215B82C43C7A6652C45C3839A5E). Le harnais compilé est identifié par current_locale_observation.rs, 2 388 octets, SHA-256 37f18600e28a92e3559be121dfbeba5b3bcc64fcdc4b77e192297c840e656452. Le reçu date du 2026-10-30; aucune commande n'a été rejouée ce tour.

## 5. Indices natifs et limites

Le reçu REA statique réutilisé porte sur le PE 4.20 fourni (15 973 880 octets, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862), analysé par REA 6.4.0/Ghidra le 2026-10-30; le reçu de session fait 13 249 octets, SHA-256 7e40455146132a1862f82ef6b45f4e7562d87bd7cb337cc7ca3b1340f3cfbfef.

L'analyse statique recoupe : le loader 0x790e20 forme le nom fontconfig et appelle le parseur 0x796350; 0x796350 reconnaît le littéral tr, appelle le token parser 0x795d10 et référence Localization_Errors.txt. Cette preuve indique un chemin natif distinct de la lecture des fontes. Elle ne révèle pas la grammaire de 0x795d10, son comportement sur cette entrée synthétique, ni le stockage/rejet des traductions. Le callback HandleLocalizeText 0x7879a0 est enregistré, mais son corps et sa recherche ne sont pas analysés. REA est statique ici; aucun code original n'a été exécuté.

Conclusion comparative : le parseur Rust ne détecte pas cette entrée tr invalide dans son chemin de fontes. Les indices du client original montrent qu'un parseur de tokens séparé reçoit tr et qu'un rapport d'erreurs existe, mais ils ne prouvent pas que l'original rejette précisément cette séquence. Il n'y a donc pas de verdict de divergence historique.

## 6. Écart, correction et reprise

L'écart courant est une limite de responsabilité : le lecteur Rust de fontes ignore le domaine des traductions et peut accepter une directive tr malformée sans erreur. Aucun code de production n'est modifié. Ajouter une validation ou un dictionnaire ici sans connaître la grammaire native inventerait une règle; la correction n'est pas justifiée par les preuves disponibles.

Réutiliser SYS-22.1-07 pour le lot suivant d'analyse du token parser 0x795d10 et de sa chaîne d'erreur. Condition de reprise : obtenir un décodage contrôlé de cette fonction et des appels directs nécessaires, puis comparer l'entrée synthétique et un échantillon source. Ne pas répéter l'analyse inchangée des fonctions 0x790e20 et 0x796350. Aucun outil REA/Ghidra, désassembleur natif, Capstone, pefile ou LIEF n'est disponible dans l'environnement inspecté; aucune installation n'a été effectuée.

## 7. Preuves, contrôles et clôture

Contrôles réellement effectués le 2026-11-02 : hash du lecteur Rust et de la copie F; relecture ciblée des reçus V795 et du harnais; confirmation que le reçu source-pinne le même lecteur et que build/run historiques ont réussi; vérification d'une ligne tr réelle dans la fonte en_GB; inventaire ciblé des outils d'analyse disponibles. Aucun test relancé, aucun build, aucun client, aucun rendu, aucune nouvelle session REA.

Le sous-lot AUD-22.1-07-TR-01 est clos comme audit de comportement courant et de liaison source/consommateur avec comparaison native bornée. La validité historique d'une déclaration tr reste inconnue; SYS-22.1-07, les fonctionnalités de localisation et SYS-01.2-02 ne sont pas clos. Aucune application de suivi, goal, base, installation ou migration modifiée.