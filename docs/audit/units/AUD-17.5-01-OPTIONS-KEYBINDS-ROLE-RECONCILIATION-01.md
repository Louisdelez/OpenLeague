# AUD-17.5-01-OPTIONS-KEYBINDS-ROLE-RECONCILIATION-01

## 1. Périmètre et décision

Réconciliation documentaire de192déclarations lexicales Keybinds :157feuilles,13conteneurs,21structures et1include. Ce lot met à jour la réunion des preuves existantes,sans modifier leurs définitions ni clôturer SYS-17.5-01 ou le goal.

Audit : partition clôturable après relecture. Implémentation : limites des owners conservées,menu courant complet non qualifié. Vérification : sources/liaisons/reçus/cohérence statiques ;0cas produit. Acceptation humaine : non demandée.

## 2. Sources et provenance

D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsKeybinds.xml ; 13896octets,SHA256 2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e. Les192identités sont vérifiées sur les octets de début de déclaration,attributs lexicaux,lignes et parentés de l’index. Aucune réparation de référence historique.

Partition antérieure154feuilles +overlay3ajouts =157. Quatre lots ultérieurs traitent les13conteneurs et les22structures/include. Les anciens rapports,programmes,reçus et conditions de reprise sont identifiés par empreinte. Les anciens receipts manquants ne deviennent pas des succès d’exécution : l’ancienne bibliothèque garde leur disponibilité exacte.

## 3. Consommateurs et limites de rattachement

Les31owners correspondent à24owners de feuilles hérités,3feuilles tardives et4lots de conteneurs/structure. Chaque source rejoint uniquement son champ target_declaration(s),jamais une mention de descendant,une future tâche ou un parent. La matrice permet la reprise par ID.

Les références de consumers,requêtes,contrats et corrections de chaque owner sont conservées par pointeurs et empreintes. Aucune recherche nouvelle ni réexécution de query/reader/test ancien. Les cas de capture,bulk,collapse,layout et include ne sont pas déduits de leurs seuls enfants ; leurs audits propres sont repris. Aucun raccord courant complet ni absence globale d’infrastructure générique n’est prouvé.

## 4. Attendu et observé

Attendu :157+1keygrid+1quickbindlayout+11sections+21structures+1include =192sources uniques,rattachées aux champs explicitement audités. Observé :partition complète,sans source oubliée ni chevauchement entre feuilles et rôles de conteneur/structure. Les preuves/relectures/reçus des nouveaux owners sont vérifiés,sans relance.

Contrôles de limites : arrêt sur dérive d’empreinte,propriétaire non explicite,ID doublé,source non rattachée ou parenté incohérente. Le rejet XML existant reste un rejet ;aucun parsing réussi du client historique n’est déclaré.

Non exécutés :parser strict déjà contrôlé,Flash/natif,jeu,Rust,UI,input,son,rendu,réseau,backend et reprise de session. Le resume du projet est lecture seule,code0,sans dérive des76fichiers suivis modifiés.

## 5. Écarts et reprise

- Couverture des3feuilles : comblée par ChampionOnly,ChampSwap et BindSysKeys ;leurs écarts fonctionnels restent ouverts.
- Couverture des13conteneurs : traitée par les audits keygrid,quickbindlayout et11sections ;focus,capture,conflits,persistance et rendu restent aux corrections originales.
- Structure/include :21structures et1frontière auditées ;les bytes de l’include interne ne sont toujours pas récupérés. Reprise :backend/manifeste/membre ou caller/log nommé ;ne pas relancer un scan inchangé.
- Syntaxe :deux attributs adjacents sans séparateur à la ligne7. Le contrôle strict hérité rejette ligne7,colonne28. Reprise :reader historique identifié ou variante officielle,ou adaptation locale versionnée conservant la référence intacte ;ne pas inférer le comportement natif.

Chaque gap original et sa condition précise de reprise reste accessible via original_scope_fields_retained et old_leaf_library_reused.scope_fields. Aucun gap fonctionnel résolu par cette jointure. Le provider InitializationData.xml et les consumers de backend/admission effectifs restent distincts du chargeur auxiliaire.

## 6. Corrections

Aucune correction nouvelle : réconciliation seulement. Les définitions existantes sont conservées par empreinte,avec leur source,work,critères,checks et conditions de reprise. BIND-EDIT-CONFLICTS,KEYGRID-STRUCTURE,KEYSECTIONS,QUICKBIND-BULK et ENTRY ne sont ni dupliqués ni appliqués par ce lot. Les critères normatifs et listes originales restent inchangés.

## 7. Preuves et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBINDS-ROLE-RECONCILIATION-01. key-role-reconciliation-proof.json,audit_key_roles.py,verify_delivery.py,producer-execution.json,reader-execution.json et delivery-readback.json. Le producteur ne s’auto-clôture pas ;le lecteur examine les sept rubriques et clôture seulement la partition.

Mesure :192associations documentaires/192déclarations physiques lexicales,contenu expansé exclu.0nouveau cas produit,0nouvelle correction,0gap fonctionnel résolu. Aucune conversion en jeu terminé.

Suite : AUD-17.5-01-OPTIONS-AUTHORED-ROLE-RECONCILIATION-01 ; Join exact129Menu+192Keybinds+36Phreakspace physical identities without expanding includes or closing native providers,current complete menu,or global requirement.

Goal,critères normatifs,application,Plan,UI,bases,registres,ressources et acquis inchangés. Aucune installation,migration,relance,retrait ou suppression.
