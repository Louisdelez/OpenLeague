# EnemyPhysicalDamage_Enabled — audit de la case Enemy Damage

## R1 — Portée et décision

2026-10-31T17:54:30.186559+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-ENEMY-DAMAGE-01`, SYS-17.5-01 / SYS-01.2-02. Case 149, catégories commandées, données de dégâts et frontière de visibilité. Le producteur ne clôture pas le lot ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte dans la preuve. Mana précédent clos :110 contrôles et356 de relecture. Table29/init/admission et sources Damage/Physical réutilisées avec leurs limites.

Nœud `OPT-SRC-623a4261cf143ecb`, INI seul `[FloatingText]EnemyPhysicalDamage_Enabled`, libellé en_GB « Enemy Damage » ligne 745. Regular par défaut, aucun updateonclick déclaré ; définition injectée/fournisseur effectif non observés. Défauts : EnemyPhysical/Magical/TrueDamage=1 lignes 191–193, clé générique EnemyCriticalDamage=1 ligne 194. Utilisateur et deploy portent trois clés critiques spécifiques à 1 (lignes 87–89 et 71–73). La clé générique ne correspond à aucun nom des 29 types ; son éventuel alias externe n’est pas qualifié et n’est pas normalisé silencieusement.

Deux régions propres : inscription 0x7BC92F–0x7BC995 (fin exclue, 102 octets), callback complet 0x7BE450–0x7BE49C (76 octets). Clé 0x10BA5C0 passée à 0x7BC92F ; callback 0x7BE450 via 0x65C4C0 puis 0x82D410 avec littéraux 1/0. Le préfixe démarre au vrai push de clé, sans recopier une longueur/borne du voisin. Classification interne de l’inscription, ordre et lifetime non requalifiés ; 1 n’est pas un updateonclick déclaré.

Le callback convertit six fois le même argument et écrit uniquement manager+0x43 à+0x48 : EnemyPhysicalDamage 19, EnemyMagicalDamage 20, EnemyTrueDamage 21, puis leurs variantes critiques 22/23/24. Retour complet ret4. Les six catégories ordinaires Physical/Magical/True et critiques 6–8/16–18 restent distinctes. Cette callback 7BE450 est celle d’Enemy, pas la callback Heal 7BE4A0.

Table et six régions communes contrôlées inchangées. Initialisation par clés individuelles et callback groupé coexistent ; priorité/fournisseur/conflits restent ouverts. Pour une entrée valide, 0 refuse le type et 1 laisse agir les autres gardes, sans garantir des pixels. Anciennes observations de ressources gardées avec date et portée ; aucune recherche de paquet/fichier manquant répétée.

## R3 — Consommateurs réels et acquis

DamageOutcome expose source, cible, type et plusieurs montants : brut, après mitigation, bouclier absorbé et santé retirée. Application réelle, refus, récapitulatif privé et vues HP sont conservés. Les faits d’attaque comprennent Critical et hit_succeeded ; ce succès ne signifie pas dégâts positifs. Leur Event n’expose pas de montant numérique ni de cible ; cela ne prouve pas que tous les autres messages sont dépourvus de ces données. Aucun rapprochement par projectile courant ou delta HP n’est inventé.

Le vrai producteur d’audience exige source ET cible visibles pour chaque équipe au moment capturé. events_for exige ensuite audience historique admise ET source actuellement visible, refuse une équipe invalide et déduplique par séquence. snapshot_for filtre les acteurs et faits d’attaque ; l’identité de windup ne peut contourner l’audience historique. La projection atomique ajoute le récapitulatif propre privé. Les vrais consommateurs sont présents : ancien envoi par joueur et route de session atomique par identité de participant.

Ces politiques sont des acquis locaux. Elles ne déterminent pas à elles seules quel appel natif choisit un type Enemy, si le texte est entrant/sortant, son montant, sa cible d’ancrage ou ses destinataires. Voir un acteur maintenant n’autorise pas un événement caché du passé. La préférence d’affichage ne doit pas élargir l’audience serveur.

Recherche précise de préférence/popup Enemy vide dans le corpus inchangé de 1 168 sources Rust/JS/HTML. L’ancienne recherche Floating générique est réutilisée. Aucune absence globale de dégâts/données réseau ni nécessité d’un nouveau flux générique n’est déduite.

## R4 — Vérifications et attendu / observé

122 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, 22 instructions attendues, retour complet/six écritures/types, vraies données et projections/audience, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien test/lecteur/export, contrôle visuel ou de persistance rejoué.

## R5 — Écarts et conditions de reprise

- ENEMY-CATEGORY-AMOUNT-AUDIENCE : nommer un appel natif/local qui choisit Enemy 19–24 par rapport aux catégories ordinaires, avec relation observateur/source/cible/mode, identité/temps, étape du montant et audience autorisée. Le libellé seul ne suffit pas.
- ENEMY-GROUP-INIT-PROVIDER : identifier configuration/fournisseur effectifs, classification/priorité d’inscription, clés spécifiques et rôle éventuel de la clé critique générique, profils/format/police/horloge. Aucun alias ni ordre effectif n’est inventé.
- ENEMY-CURRENT-FLOAT-VIEW : raccorder un événement admis à la vue commune en réutilisant dégâts et autorité existants. Garder suivies les cinq autres catégories ; pas de second moteur de dégâts/renderer.
- ENEMY-RENDER-PERSISTENCE : vérifier six catégories/0/1/zéro/bouclier/refus/source absente/acteur caché/visibilité tardive/historique/privé, puis ordre/doublons/expiration/viewport/session et Annuler/défaut/Save/rechargement.

Chaque manque conserve son impact et une entrée de reprise précise. Cache, HP ou visibilité actuelle ne deviennent pas un texte flottant admis.

## R6 — Correction proposée et suite

Une proposition documentaire, non appliquée : HUD-FLOATING-ENEMY-DAMAGE-SETTING-01. Elle couvre la liaison spécifique des six types et leur admission observateur/source/cible, sur les composants Floating communs. Menu/HUD local/Physical conservés. Une première catégorie admise ne clôture pas les cinq autres. Aucun nouveau moteur de combat/texte ou flux générique n’est justifié par une recherche vide.

Prochain lot borné : Dodge_Enabled, case 150. Identifier callback/type et évitement ou refus actuels utiles, sans déduire une esquive d’un zéro de dégâts ou d’une attaque annulée.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-ENEMY-DAMAGE-01\floating-enemy-damage-proof.json`, SHA-256 `25df79513271af9afbb63163abc99301bd0d0563d90f745d37e6f303df319699` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-ENEMY-DAMAGE-01\verify_floating_enemy_damage.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-ENEMY-DAMAGE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
