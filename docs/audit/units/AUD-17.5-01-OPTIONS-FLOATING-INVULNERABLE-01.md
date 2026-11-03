# Invulnerable_Enabled — audit de la case Status

## R1 — Portée et décision

2026-10-31T17:31:00.711091+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-INVULNERABLE-01`, SYS-17.5-01 / SYS-01.2-02. La portée couvre la case 145, ses catégories natives et les protections/refus actuels utiles à une notification. Le producteur ne clôture pas le lot ; la relecture séparée est attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

Exécutable original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Sources XML/GFX/AS/configuration/traduction et outils existants sont identifiés par empreinte dans la preuve. Le précédent audit Gold est clos, avec 109 contrôles et 378 vérifications de relecture ; ses limites restent héritées.

Le nœud `OPT-SRC-4861a69e9b3d219d` porte seulement `[FloatingText]Invulnerable_Enabled`. Le libellé en_GB ligne 756 est « Status ». La stratégie AS est regular par défaut, sans updateonclick déclaré ; définition injectée et fournisseur effectif restent indéterminés. Les deux valeurs par défaut examinées portent Invulnerable=1 ligne 199, Countdown=1 ligne 200 et Disable=1 ligne 201. Aucun remplacement de ces clés n’est présent dans les fichiers utilisateur/deploy examinés.

Deux régions propres : inscription 0x7BC531–0x7BC6B4 (fin exclue, 387 octets) et callback complet 0x7BE520–0x7BE54E (46 octets). La clé à 0x10BA5EC est passée à 0x7BC533 et inscrit 0x7BE520. Le callback convertit le même argument trois fois et écrit exactement manager+0x30, +0x49 et +0x3C. Le modèle à une seule écriture des cases Heal/Gold ne s’applique pas ici.

La table et les six régions d’initialisation/admission sont réutilisées avec vérification des octets. Les trois catégories sont Invulnerable (0), Countdown (25) et Disable (12). L’initialisation lit leurs clés individuelles ; ordre des notifications et valeurs contradictoires restent inconnus. Pour chaque type valide, 0 refuse l’entrée, 1 laisse agir les autres gardes acteur/mode/profil. Cela ne prouve pas un rendu. L’inscription au premier conteneur avec record 1 n’est pas qualifiée en mode live 2.

Les observations antérieures de ressources gardent leur date et leur portée limitée ; aucune recherche de paquet/fichier manquant n’a été répétée.

## R3 — Consommateurs réels et acquis

`Simulation::protected` existe : faux pour une identité absente de units, vrai pour une fontaine ; sans monde/règle de bâtiment il renvoie faux. Il évalue ensuite les dépendances de structures par présence d’unités nommées encore en vie. Cela ne constitue pas une implémentation de toutes les invulnérabilités de champions.

`apply_damage` refuse une cible protégée avant les mutations de boucliers, santé ou récapitulatif. `damage_unit` revient sans mutation ; l’admission d’attaque renvoie « target protected », la validité d’attaque répétée exclut la cible et le chemin de sélection Q examiné l’ignore. Ces chemins peuvent éviter une tentative ou un contact : ils ne prouvent pas qu’un événement flottant doit être produit.

Le récepteur GameplayRejected actuel rapporte contexte, séquence et raison ; il ne fournit pas un contrat Status. Les résultats de dégâts, absorption des boucliers, snapshots, santé affichée et récapitulatif privé sont conservés. Une santé inchangée, un zéro, une absorption ou une erreur générique ne suffisent pas à conclure Invulnerable, Countdown ou Disable.

Le corpus inchangé de 1 168 sources est identifié. La recherche précise de la préférence et des noms de popup associés est vide ; l’ancienne recherche FloatingText générique est réutilisée. Ce constat borné ne démontre ni absence de toute protection ni besoin d’un nouveau flux réseau.

## R4 — Vérifications et attendu / observé

115 contrôles du producteur réussis. Empreintes, appartenance du corpus, déclaration, valeurs et libellé vérifiés. Décodage aligné des deux régions, seize instructions attendues, retour complet et trois écritures/type correspondants. Fragments réels de protection/refus et vues relus ; Git, cinq registres et 25 fichiers protégés inchangés. Sept cas attendu/observé structurés dans la preuve.

Aucun original, x86/AS/Rust, jeu, GUI, entrée système, réseau ou émulation n’a été exécuté. Aucun ancien test/lecteur/export ni test de rendu ou de persistance n’a été rejoué.

## R5 — Écarts et conditions de reprise

- STATUS-GROUP-INIT-PROVIDER : identifier la configuration/définition effective et l’ordre entre initialisation individuelle et callback groupé, notamment en cas de valeurs contradictoires. Les trois valeurs par défaut à 1 ne résolvent pas cette priorité.
- STATUS-EVENT-ADMISSION : identifier pour chaque catégorie un producteur admis avec raison, sujet, acteur, audience, temps et texte/profil. Reprendre d’abord avec un appel natif nommé ou un contrat local explicite pour une catégorie ; garder les deux autres suivies.
- STATUS-CURRENT-FLOAT-VIEW : raccorder une entrée admise à la vue flottante commune et à son propriétaire. Les protections et le rapport d’erreur actuels sont des acquis, sans devenir des notifications Status.
- STATUS-RENDER-SETTINGS-LIFECYCLE : exécuter les cas distincts de catégorie/0/1/protection permise ou refusée/absence de tentative/zéro/bouclier/mort/identité inconnue, puis confidentialité, ordre, doublons, expiration, session, viewport et Annuler/défaut/Save/rechargement.

Chaque manque conserve son impact et son entrée de reprise précise. Le toggle d’affichage ne doit pas modifier la protection ou les règles de dégâts du jeu.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-INVULNERABLE-SETTING-01. Elle couvre le raccordement exact des trois catégories Status sur la vue commune. Menu, HUD local, résultats de dégâts et prédicats de protection sont réutilisés. Un premier événement qualifié ne clôture pas les deux autres catégories. Aucun second moteur de texte/dégâts ni catalogue de tous les sorts n’est requis par cet audit.

Prochain lot borné : QuestReceived_Enabled, case 146. Identifier son callback/type et un producteur ou consommateur actuel utile, ou documenter le manque sans inventer un système depuis son libellé.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-INVULNERABLE-01\floating-status-proof.json`, SHA-256 `0da236a0b618b3028723d8454a1298c39a4a40f5a7d70f44a22692b3be061f7c` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-INVULNERABLE-01\verify_floating_status.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-INVULNERABLE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
