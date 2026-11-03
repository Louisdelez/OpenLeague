# Experience_Enabled — audit du texte de gain d’XP

## R1 — Portée et décision

2026-10-31T18:31:19.875887+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-EXPERIENCE-01`, SYS-17.5-01 / SYS-01.2-02. Case 154, type natif et vraies attributions/présentations actuelles d’XP. Le producteur ne clôture pas le lot ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation humaine restent ouverts.

## R2 — Sources et provenance

PE original `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. XML/GFX/AS/configuration/traduction et outils existants identifiés par empreinte. Score précédent clos : 106 contrôles et 340 de relecture. Audit Level/Local Pools et éléments Floating communs réutilisés avec leurs limites, sans ancien lecteur/test rejoué.

Nœud `OPT-SRC-d25073586fe71337`, INI seul `[FloatingText]Experience_Enabled`, libellé en_GB « Experience » ligne 747. Regular par défaut, sans updateonclick déclaré ; définition injectée/fournisseur effectif non observés. Les deux fichiers par défaut portent Experience=0 ligne 208 ; la configuration utilisateur fournie porte 1 ligne 90, aucun remplacement deploy examiné. Ce n’est pas une observation du choix courant.

Deux régions propres : inscription 0x7BCB82–0x7BCBE8 (fin exclue, 102 octets), callback complet 0x7BE5F0–0x7BE606 (22 octets). Clé 0x10BA6CC à 0x7BCB82, callback via 0x65C4C0 puis 0x82D410 avec littéraux 1/0. Le tampon de nom utilise ici ESP+0x4C puis l’argument ESP+0x50, distinct des voisins ; ces offsets ne sont pas recopiés depuis le précédent. Classification/ordre/durée d’inscription non requalifiés ; 1 ne prouve pas un updateonclick déclaré.

Une conversion booléenne et unique écriture manager+0x39 : Experience9, jusqu’au ret4. Level11 reste distinct. Table/six régions communes init/admission contrôlées inchangées, init/callback même cache. Pour une entrée valide, 0 refuse XP9 et 1 laisse agir les autres gardes, sans qualifier l’attribution ou les pixels. Le fallback de configuration 1 n’est pas le défaut physique Experience=0. Anciennes observations de ressources datées et limitées conservées, sans recherche répétée de paquets/fichiers.

## R3 — Consommateurs réels et acquis

L’API award_experience contrôle un montant fini/positif et un joueur connu, ajoute réellement ce montant, gère les seuils/niveaux et la croissance puis renvoie Result<(),String>. Elle ne fournit pas dans cette méthode un événement d’XP sérialisé avec identité/temps/audience. Les propriétés globales de toutes les bornes/règles d’XP ne sont pas démontrées par cette lecture.

Les appels réels existent : XP du tueur via base_experience, XP de monstre/boss attribuée au propriétaire crédité, partage par équipe vivante dans un rayon pour le chemin d’unités examiné, puis XP globale d’équipe si définie. Ces politiques locales, partages, modificateurs et parité complète de récompenses gardent leurs limites ; un exemple d’élimination ne qualifie pas toutes les causes ou tous les destinataires.

XP totale, DTO/Snapshot/réception, courbe, barre d’XP et niveau courant sont acquis. Le niveau 18 remplit la barre, sans décider si une attribution doit être affichée. Montant attribué, delta net du total, remplissage, passage de niveau et récompense en or ne sont pas interchangeables. Aucun événement flottant n’est inféré de killer_gold ou d’un premier snapshot/reconnexion/retour à la visibilité.

La recherche précise de préférence/popup XP est vide sur les 1 168 sources Rust/JS/HTML inchangées. Les montants et producteurs existent malgré cette absence de nom. Aucune absence globale de progression ni besoin de nouveau moteur d’XP/flux générique n’est déduit.

## R4 — Vérifications et attendu / observé

108 contrôles du producteur réussis : identités/corpus/XML/configuration/libellé, décodage aligné, douze instructions attendues, retour/unique écriture/type9, API et appels/partage/attributions réels, vues/courbe et Level réutilisés, invariance Git/cinq registres/25 protégés. Sept cas attendu/observé dans la preuve.

Aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun ancien lecteur/test/export, contrôle visuel ou de persistance rejoué. Ancienne recherche Floating générique réutilisée.

## R5 — Écarts et conditions de reprise

- EXPERIENCE-AWARD-ADMISSION : identifier un producteur Experience9 natif/local avec montant réellement affichable, cause, destinataire/sujet, identité/temps, audience/carte-mode et refus. Qualifier causes/partages/niveau maximal séparément ; les sources actuelles sont des acquis, pas toute la parité native.
- EXPERIENCE-PROVIDER-PROFILE : qualifier configuration/définition/fournisseur effectifs, inscription/notification, profil/format/texte/police/horloge et vue commune. Défaut 0/utilisateur 1 ne résolvent pas le choix courant.
- EXPERIENCE-CURRENT-FLOAT-VIEW : raccorder une attribution admise aux composants communs, en réutilisant API/appels/données existants et en gardant Level11 séparé.
- EXPERIENCE-RENDER-PERSISTENCE : vérifier gain réel/0/1/aucun événement/zéro/négatif/non fini/joueur inconnu/max18/plusieurs gains/partages/destinataires/absence de tueur, arrivée/reconnexion, confidentialité/péremption, ordre/doublons/expiration/viewport/session et Annuler/défaut/Save/rechargement.

Chaque manque conserve impact et entrée de reprise précise. Un premier gain affiché laisse toutes les autres causes applicables suivies ; pas de fonctionnalité XP complète depuis ce seul exemple.

## R6 — Correction proposée et suite

Proposition unique, non appliquée : HUD-FLOATING-EXPERIENCE-SETTING-01. Relier une attribution admise aux composants Floating communs et à la préférence exacte ; préserver progression, barre et Level. Menu/HUD local/Physical et proposition Level conservés. Aucun second moteur d’XP/texte ni refonte de toutes les règles n’est requis par la recherche vide.

Prochain lot borné : consolider les douze cases FloatingText déjà auditées, leurs liaisons et preuves, corrections et conditions de reprise. Réutiliser les lecteurs/preuves sans les rejouer ; distinguer couverture documentaire des cases, types exposés et fonctionnalités non terminées. Le parent et le goal ne seront pas clôturés depuis ce seul groupe.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-EXPERIENCE-01\floating-experience-proof.json`, SHA-256 `54f49e214a729a89adb9ff795c31f5af5e8129588c0aba8350874e228fcf63ad` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-EXPERIENCE-01\verify_floating_experience.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-EXPERIENCE-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md ; elle seule peut clôturer ce périmètre documentaire.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres, documents et preuves antérieurs sont conservés.
