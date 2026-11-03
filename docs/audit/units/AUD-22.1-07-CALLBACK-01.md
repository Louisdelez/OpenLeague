# AUD-22.1-07-CALLBACK-01 — Repli du wrapper de localisation natif

Contrôle : 2026-10-30T11:12:53.076360+00:00. Parent SYS-22.1-07, action KEY-DIAG-01. Résultat d'audit uniquement ; aucune modification du Goal, du jeu, du suivi ou des bases.

## 1. Question et clôture

Question : que retourne le wrapper appelé par le callback de localisation lorsque son backend signale échec ou succès ? **Audit terminé pour ce protocole conditionnel de retour.** Échec du backend : pointeur de clé d'entrée. Succès : pointeur de sortie, y compris si la sortie fournie est vide. Une entrée nulle retourne null.

| Dimension | État |
|---|---|
| Audit | Terminé pour le mécanisme de sélection de retour, pas pour la décision d'un vrai dictionnaire sur une clé absente |
| Implémentation | Mécanisme présent dans l'original ; résolveur général absent du chemin Rust de boutique déjà audité |
| Vérification | Partielle : sources statiques et six cas de fragments originaux émulés ; aucun processus historique ou Rust de jeu exécuté |
| Acceptation humaine | Non demandée |

La question initiale « que fait le traducteur face à une clé réellement absente ? » reste ouverte. La précision obtenue est la frontière entre son résultat et le repli du wrapper. Aucun statut de tâche n'est modifié.

## 2. Sources et provenance

Source : PE PUBLIC4.20.0.315 fourni, `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`, 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Preuve réutilisée : AUD-22.1-04-SEARCH-01/source-proof.json établit les instructions associant getLocalizedText au callback 0x7879A0. Les exports Flash et V795 restent hérités. Aucun nouvel export FFDec, aucune répétition de l'analyse du lecteur 0x796350, aucun téléchargement.

## 3. Consommateurs et limites du chemin natif

- À 0x7879E4, le callback appelle 0x78D0D0.
- Le wrapper teste l'entrée à 0x78D108 ; le chemin nul met EAX à zéro à 0x78D10C.
- Pour une entrée non nulle, il appelle la méthode virtuelle de slot +0x34 à 0x78D174, avec une chaîne d'entrée et un tampon de sortie. Il conserve son résultat dans BL à 0x78D17A.
- À 0x78D181-0x78D19B, BL nul sélectionne le pointeur d'entrée ESI ; BL non nul sélectionne la sortie statique, inline si sa capacité est inférieure à 16, indirecte sinon.
- La construction candidate écrit la vtable 0x10B68B4 à 0x78DF01 ; son slot +0x34 pointe vers 0x78FE30. Cela ne prouve pas à lui seul l'instance historique effectivement montée.
- Dans 0x78FE30, le résultat du vrai traducteur est obtenu par un autre appel virtuel, slot +0x14 à 0x78FF85. AL est comparé à 1. Ce fournisseur concret et sa décision restent à qualifier.

Le littéral `0 != pTranslator`, poussé avant un appel à 0x991E60 lorsque le pointeur de traducteur est nul, concerne une absence de traducteur. Il ne prouve pas un message pour chaque clé absente. Le comportement de cette assertion n'est pas exécuté ni qualifié.

Consommateur courant : les rapports RESP-01 et SEARCH-01 établissent déjà le littéral français et l'absence de résolveur branché dans shop_ui. Ce lot ne répète pas leur recherche et n'implémente pas de callback Rust.

## 4. Attendu, observé et exécution réelle

Commande exécutée avec code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-07-CALLBACK-01/verify_fragments.py`. Outils existants : pefile, Capstone et Unicorn, versions et empreintes identifiées dans le reçu. Aucun logiciel installé.

**Seuls deux fragments d'instructions originales sont exécutés dans Unicorn** : préfixe 0x78D106-0x78D112 pour l'entrée nulle ; suffixe 0x78D181-0x78D19B pour le choix de résultat. La construction des chaînes, le provider, la consultation du dictionnaire et le wrapper complet ne sont pas exécutés. Le résultat du backend et les octets de sortie sont des contrôles synthétiques explicitement fournis, pas des traductions récupérées. Aucune logique Python ne remplace les instructions de sélection dans les fragments émulés.

| Cas contrôlé | Résultat attendu et observé |
|---|---|
| Entrée nulle, préfixe | EAX = 0 |
| Backend false, suffixe | Pointeur d'entrée original, valeur ol_audit_control_key |
| Backend true, capacité 15 | Adresse du tampon inline, valeur Inline text |
| Backend true, capacité 16 | Pointeur de stockage indirect, valeur Heap text |
| Backend true, capacité 31 | Pointeur indirect, valeur Longer controlled text |
| Backend true, sortie vide | Pointeur de sortie non nul, chaîne vide ; aucune substitution par la clé |

Six cas réussis, avec trace d'instructions et attendu/observé dans fragment-proof.json. Les frontières de capacité 15/16 sont testées. Les branches et la vtable ont aussi été relues statiquement dans les octets du PE. Ce résultat ne constitue ni un essai sur un dictionnaire réel, ni un refus visible, ni une exécution du runtime historique.

## 5. Résolu et ouvert

Résolu : le comportement du wrapper dépend du signal du backend, pas seulement de la présence de caractères dans la sortie. Un retour vide et un échec sont distincts. Le repli vers la clé est établi lorsque le backend signale false. Le wrapper inspecté ne produit pas lui-même un diagnostic explicite sur cette branche ; d'autres couches peuvent en produire, elles ne sont pas exclues globalement.

Ouvert : quel résultat le fournisseur concret produit pour une clé inexistante, une valeur native vide et une clé existante ; choix du fournisseur effectif ; diagnostic éventuel de ces couches ; état et durée de vie du tampon partagé ; résultat visible dans le client. Aucun asset manquant n'est établi par ces contrôles.

L'inconnue OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f et SYS-22.1-07 restent ouvertes. Le repli natif ne doit pas être confondu avec Inconnu, qui correspond à un ID d'objet absent dans le Rust actuel.

## 6. Action restante et condition de reprise

KEY-DIAG-01 est réutilisée, sans nouvelle tâche de suivi : identifier le fournisseur réel appelé au slot +0x14 depuis 0x78FE30, puis établir son résultat pour une clé source présente, une clé absente contrôlée et une valeur vide explicitement sourcée. Fin : fournisseur/état d'entrée identifiés, résultat de traduction et diagnostic distingués, attendu/observé, limites et provenance conservées. La capture graphique demeure une vérification séparée.

Entrée de reprise précise : vtable concrète du pointeur renvoyé par la chaîne 0x79CF90 / objet à this+4, ou une preuve équivalente du fournisseur monté. Ne pas attribuer arbitrairement une méthode à cet appel virtuel. Ne pas réexécuter les six fragments inchangés sans modification de source ou anomalie. Une correction fonctionnelle Rust exige une instruction distincte ; aucune n'est faite ici.

## 7. Livraison et relecture

Nouveaux fichiers : ce rapport ; `F:/OpenLeague-work/audit-units/AUD-22.1-07-CALLBACK-01/verify_fragments.py` ; son résultat `fragment-proof.json`, 22912 octets, SHA256 78dc9371cb19516ee87d242a0a4d42fd7a3c07897fa06addfccf3652feeddcb6. Le reçu conserve les plages statiques, les octets, les traces des six cas, les identités d'outils et du producteur et les limites d'exécution.

Relecture : les sept rubriques sont renseignées. « Fragments originaux émulés » ne signifie pas « wrapper complet exécuté » ; « backend false » ne signifie pas « clé réellement absente observée » ; aucun fournisseur artificiel n'est présenté comme natif. La clôture de ce mécanisme ne ferme ni l'audit du dictionnaire ni la fonctionnalité de diagnostic. Les preuves antérieures sont conservées. Aucun binaire du jeu produit ou lancé, aucune base ouverte, aucune migration, aucune modification applicative ou du Goal.
