# ManaDamage_Enabled — audit de la case Mana

## R1 — Portée et décision

2026-10-31T17:46:41.453212+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-MANA-DAMAGE-01`, SYS-17.5-01 / SYS-01.2-02. Case 147, catégories commandées, dépenses/récupérations et vues actuelles utiles. Le producteur ne clôture pas le lot ; une relecture séparée est attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Sources XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Quest précédent clos : 103 contrôles et 339 de relecture. L’audit Local Pools et les éléments Floating communs sont réutilisés avec leurs limites, sans rejeu des anciens tests.

Nœud `OPT-SRC-33592071f5188140`, `[FloatingText]ManaDamage_Enabled` seul, libellé en_GB « Mana » ligne 760. Stratégie regular par défaut, sans updateonclick déclaré ; définition injectée/fournisseur effectif indéterminés. Dans les deux fichiers par défaut : ManaDamage=0 ligne 207, ManaHeal=0 ligne 206. La configuration utilisateur fournie porte ManaDamage=1 ligne 94 et ManaHeal=1 ligne 95. Aucun remplacement deploy examiné ; le choix effectif n’est pas observé.

Deux régions propres : inscription 0x7BC8A1–0x7BC91E (fin exclue, 125 octets) et callback complet 0x7BE5C0–0x7BE5E1 (33 octets). Clé 0x10BA59C passée à 0x7BC8A3 ; capture du manager et callback via 0x65C4C0. Ce chemin passe les littéraux 1 et 0 à 0x82D410 ; il diffère de l’inscription inline de 387 octets des cases précédentes. La classification interne de cette inscription n’est pas requalifiée ici ; 1 ne prouve pas un updateonclick déclaré.

Le callback convertit deux fois le même argument et écrit uniquement manager+0x34 (ManaDamage, type 4) et +0x33 (ManaHeal, type 3), jusqu’au retour ret4. Health Heal/type2/cache32 n’est pas modifié.

Table29 et six régions d’initialisation/admission communes vérifiées inchangées. Les clés individuelles initialisent les types séparément ; callback groupé, fournisseur, ordre et valeurs contradictoires restent distincts. Pour un type valide, 0 refuse l’entrée et 1 laisse agir les autres gardes, sans garantir des pixels. L’ancien constat de ressource conserve sa date et sa portée ; aucune recherche de paquet/fichier manquant n’a été répétée.

## R3 — Consommateurs réels et acquis

La fonction actuelle de Q d’Ezreal vérifie joueur, état, point, contrôles, cooldown, mana finie/suffisante, session, budget, statistiques et géométrie avant mutation. Un lancement accepté effectue réellement p.mana -= q.cost. Ce coût est une donnée acquise ; il n’est pas automatiquement un événement natif ManaDamage.

La simulation invoque la régénération. Des récupérations de ressource par tick, fontaine et relique existent et sont plafonnées à la capacité. La politique restores_resource autorise Mana ou Energy, alors que uses_mana ne sélectionne que Mana. Un ajout demandé et le montant réellement restauré diffèrent au plafond. Coût, brûlure hostile, régénération, remplissage et remise à zéro ne sont pas interchangeables.

Les DTO/Snapshot conservent mana et capacité ; MPStat et la barre existent déjà et sélectionnent Mana, avec conversions et gardes de valeurs. Leur total ou son delta net ne fournit pas identité, cause, montant, destinataire ou admission d’une notification flottante. Les autres ressources et Health Heal restent séparés.

La recherche précise de préférence/popup Mana est vide dans le corpus inchangé de 1 168 sources Rust/JS/HTML. L’ancienne recherche Floating générique est réutilisée. Cela ne prouve ni absence de données mana ni nécessité d’un nouveau flux réseau ou moteur de ressource.

## R4 — Vérifications et attendu / observé

110 contrôles du producteur réussis : identités, corpus, XML, valeurs/libellé, décodage aligné des deux régions, quatorze instructions attendues, retour et deux écritures/types, source de coût et récupération, vues MP, invariance Git/cinq registres/25 fichiers protégés. Sept cas attendu/observé structurés dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export ni contrôle de rendu ou de persistance rejoué.

## R5 — Écarts et conditions de reprise

- MANA-GROUP-INIT-PROVIDER : identifier fournisseur/définition/configuration effectifs, classification de l’inscription 0x82D410, ordre init individuelle/callback groupé et conflits de valeurs. Défauts 0 et utilisateur 1 ne démontrent pas le choix courant.
- MANA-AMOUNT-EVENT-ADMISSION : nommer un producteur Mana3/4 admis, avec cause, montant réellement payé/perdu/restauré, sujet, ressource, audience et temps. Qualifier coût/perte/brûlure/récupération/régénération/reset séparément, sans déduction du seul delta.
- MANA-CURRENT-FLOAT-VIEW : raccorder l’entrée admise au profil/format/police/horloge et à la vue commune. Les mécanismes de ressource et l’affichage MP sont acquis, sans devenir des textes flottants.
- MANA-RENDER-PERSISTENCE : vérifier 0/1, coût accepté/refusé, récupération partielle/pleine/plafonnée, autres ressources, variations compensées, confidentialité, ordre/doublons/expiration/session/viewport et Annuler/défaut/Save/rechargement.

Chaque manque conserve impact et condition de reprise. Le toggle de présentation ne doit pas changer la consommation, les refus ou la récupération du jeu.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-MANA-SETTING-01. Raccordement précis des types 4/3, réutilisant coûts/récupérations/pools et vue Floating commune. Une première catégorie admise laisse la seconde et les autres causes applicables suivies. Aucun second renderer, nouveau moteur de ressource ou refonte de tous les sorts n’est requis par la recherche vide.

Prochain lot : EnemyPhysicalDamage_Enabled, case 149. Identifier callback/types propres et distinguer source, cible et audience des dégâts adverses en réutilisant les preuves Damage.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-MANA-DAMAGE-01\floating-mana-proof.json`, SHA-256 `e4d1ecf27bb79b9062060c754def3308f1b603f96df981a006bda125938cef73` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-MANA-DAMAGE-01\verify_floating_mana.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-MANA-DAMAGE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
