# AUD-22.1-04-SEARCH-01 — Source du placeholder de recherche

Contrôle : 2026-10-30T11:07:09.369701+00:00. Parent SYS-22.1-04. Lot issu de RESP-SEARCH-01. Documentation et preuve statique uniquement ; aucun changement du Goal, du jeu, du suivi ou des bases.

## 1. Question, sortie et décision

Question : quelle source native fournit le placeholder de recherche de la boutique, et que consomme le widget Rust actuel ? Sortie attendue : une liaison établie par les sources, pas un rapprochement de noms.

**Audit terminé pour la clé simple, son chemin de transport et le consommateur actuel.** La clé est `flash_itemShop_search_placeholder`. Le binaire la référence dans le chemin qui construit `SetSearchPlaceholderText`, propriété `text`. Les scripts exportés relaient cette propriété jusqu'à `txtPlaceholder.text`. Rust utilise à la place un littéral français.

| Dimension | Conclusion |
|---|---|
| Audit | Terminé pour cette liaison statique et son écart courant |
| Implémentation | Placeholder actuel présent ; liaison à cette clé et à la locale absente dans le module inspecté |
| Vérification | Partielle : ressources, instructions x86 et scripts vérifiés ; aucun jeu, Flash ou rendu exécuté |
| Acceptation humaine | Non demandée |

Le choix des variantes avec raccourcis, le résolveur natif complet et les autres textes HUD restent hors clôture. Les parents SYS-22.1-04 et SYS-22.1-07 restent ouverts.

## 2. Sources et preuves réutilisées

Référence : PUBLIC4.20.0.315, EUW/en_GB. Sources présentes dans le déploiement original sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/` : le PE, DATA/Menu_SC4/FoundryItemShop.gfx et les deux fontconfig en_GB/fr_FR.

Les quatre scripts ItemShopModule.as, ItemShopRoot.as, SearchArea.as et Language.as proviennent de l'extraction FFDec existante du 2026-10-14, terminée avec code 0. Leur taille et SHA256 concordent avec ce reçu. L'extraction n'est pas relancée. Le rapport V80, daté du 2026-10-22, fournit la provenance du GFX et son appartenance au manifeste sélectionné ; ce contrôle de manifeste reste hérité.

| Clé, lignes 368-370 des fontconfig | en_GB | fr_FR |
|---|---|---|
| flash_itemShop_search_placeholder | Click Here to Search | Cliquez ici pour rechercher |
| flash_itemShop_search_placeholder_1key | @k1@ to Search | @k1@ pour rechercher |
| flash_itemShop_search_placeholder_2key | @k1@ or @k2@ to Search | @k1@ ou @k2@ pour rechercher |

Chaque déclaration est présente une fois dans chacun des deux fichiers. La disponibilité des variantes ne prouve pas leur condition de sélection.

## 3. Consommateurs natifs et courant

Nouveau contrôle statique du PE avec les outils déjà présents, sans installation :

- La chaîne simple est à VA 0x10BF3D8. À 0x81AC4D, le code pousse cette adresse, construit un objet chaîne à 0x81AC55, puis appelle 0x844AE0 à 0x81AC62.
- Le chemin pousse SetSearchPlaceholderText, VA 0x10BF128, à 0x81AC67, puis appelle 0x785EA0. Il réutilise le tampon de chaîne et renseigne la propriété littérale text, VA 0x10BF1D4, à 0x81ACD5 ; un appel de transmission suit à 0x81ACEA vers 0x7971E0. Le sens complet des helpers et des gardes n'est pas inféré de ces seuls appels.
- Dans les exports, ItemShopModule.as:80 lie la cible ; :442-444 relaie param1.text à ItemShopRoot.as:507-509 ; SearchArea.as:161-163 affecte directement txtPlaceholder.text. Ce setter reçoit un texte déjà fourni, sans résoudre lui-même une clé.
- Dans Rust, shop_ui.rs:216 initialise le texte à Rechercher un objet..., et :421 conserve ce littéral quand la saisie est vide et sans focus. Sinon le code affecte la saisie, avec son marqueur de focus. Aucune des trois clés ni la cible SetSearchPlaceholderText ne figure dans ce module. L'absence de raccordement repose sur cette affectation directe, pas sur une simple absence de nom.

Témoin complémentaire borné : à 0x8183BF/0x8183C7, le binaire associe getLocalizedText au callback 0x7879A0, puis appelle 0x5BFF70. Cela précise la frontière vue dans V795, sans qualifier toute la sémantique du callback. Les noms getLocalizedText et HandleLocalizeText ne sont pas assimilés sur leur seule ressemblance.

## 4. Vérifications attendues et observées

Commande réellement exécutée : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-SEARCH-01/verify_source.py`. Python et les bibliothèques ont été identifiés dans la preuve. Résultat : code 0, passed=true.

| Cas / contrôle | Observé | Limite |
|---|---|---|
| Identité des sources | Empreintes attendues du PE, GFX, reçu, quatre exports, deux locales et shop_ui concordantes | Appartenance historique héritée, pas redémontrée |
| Clé et valeurs nominales | Six déclarations uniques, valeurs du tableau ci-dessus | Lecture de données, pas rendu |
| Liaison binaire | 12 témoins d'instruction vérifiés, octets conservés, deux plages décodées sans trou | Statique uniquement, aucune couverture de toutes les branches revendiquée |
| Placeholder courant | Littéral français différent des deux valeurs natives simples | Écart de code/données ; non reproduit graphiquement |
| Focus | Source Flash masque le placeholder à la prise de focus et le réaffiche si vide à la libération ; Rust conditionne son littéral à vide/sans focus | Lecture des branches, aucun événement clavier exécuté |
| Variante _1key / _2key | Sources présentes, choix et substitution non vérifiés | Aucun raccourci inventé |
| Clé absente / refus | Non exécuté dans le consommateur natif ou Rust | Le présent lot ne résout pas la politique de clé manquante |

Le chemin setupFlashPlayer de ItemShopModule.as:276-299 contient un callback de démonstration qui retourne la clé. Son exemple de placeholder ligne 221 est également un exemple Flash. Ils ne sont pas utilisés comme résultats du client historique en jeu. Language.as:73-87 contient un cache puis un appel externe, avec retour de la clé si null ; cela ne prouve pas à lui seul ce que renvoie le backend natif.

## 5. Manques et clôture limitée

RESP-SEARCH-01 obtient ici sa réponse documentaire : la clé simple, le transport natif et le champ destinataire sont identifiés. Le manque ne porte pas sur un fichier à récupérer. Le texte courant est local et diffère même de fr_FR natif.

Restent indéterminés : résolution complète de 0x844AE0, sélection des variantes à raccourcis et substitution de @k1@/@k2@, contexte effectif de chargement GFX, réponse native sur clé absente, affichage final et dépassement des cadres. L'incertitude n'empêche pas de conclure le lien simple, mais interdit de déclarer la fonctionnalité fidèle et terminée.

La recherche est arrêtée à cette sortie. Refaire l'extraction FFDec, les chargements de profils V795 ou l'analyse 0x796350 n'apporterait rien à la question clôturée. Les anciens reçus et les inconnues OLU-f7d57a9f-32d2-5d02-8b33-c903cdac74e8 / OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f sont conservés, sans écriture dans les registres.

## 6. Actions restantes et reprise

Ces précisions restent documentaires sous les tâches existantes, sans création ni modification dans l'application.

| Action | Résultat et critère de fin | Condition de reprise |
|---|---|---|
| SEARCH-TEXT-01 sous SYS-22.1-04 | Raccorder le placeholder simple à la locale via la couche de texte retenue ; vérifier en_GB et fr_FR, vide/sans focus, focus et saisie non vide. Conserver le comportement existant de saisie. | Instruction autorisant la réalisation fonctionnelle ; sources déjà présentes ; API du résolveur définie |
| SEARCH-KEYS-01 sous SYS-22.1-04 | Qualifier le choix des variantes et la substitution des raccourcis. Fin : source/branche de sélection, valeurs attendues/observées et limites, sans afficher @k1@ non remplacé comme un résultat fini. | Question nouvelle ciblant 0x844AE0 et ses producteurs de métadonnées, ou preuve équivalente ; aucune répétition du lecteur de polices |
| KEY-DIAG-01 sous SYS-22.1-07, réutilisé | Établir puis vérifier la réponse à une clé absente dans la bonne couche, distincte d'un ID d'objet absent. | Qualification du résolveur/callback ; l'exemple Flash ne peut pas servir d'oracle natif |

Aucune correction fonctionnelle exécutée. Les textes et contrôles de saisie actuels restent conservés.

## 7. Livraison, identités et relecture

Nouveaux fichiers de cette unité : ce rapport ; le script de preuve et son résultat `source-proof.json` dans `F:/OpenLeague-work/audit-units/AUD-22.1-04-SEARCH-01/`. Ce JSON contient les chemins exacts, tailles et SHA256 de toutes les entrées, les octets des témoins, les versions des outils et les limites. SHA256 du résultat : bf66a79645cf7909b73be3743f92cb0ea341ed69fa68409c21b53fc15a3830a7, 12023 octets.

PE : 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. GFX : 4aa0368dcd3713d2ccf40439a9482166b597422e8090ae0eff21c4b65063fbee. Reçu d'extraction : b7d24d16ccb5a3beec6d1bde365aeeb28def3ba217c044ea48dd86b98059ae1d. Les identités détaillées antérieures ne sont pas recopiées en masse.

Relecture des sept rubriques : périmètre explicite ; sources identifiées ; consommateurs réels ; contrôles et non-exécutions séparés ; manques bornés ; corrections et reprise définies ; preuve datée. Aucun nouveau binaire produit, aucun processus de jeu/Flash lancé, aucune installation/migration, aucune base ouverte et aucun objectif ou statut du Goal modifié. La clôture concerne l'audit de cette liaison, pas la fonctionnalité complète.
