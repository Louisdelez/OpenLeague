# SYS-01.2-02 — Références du mode classé en équipe, V445

Les quatre contrats de source SELECT, RULES, RANK et RESULT sont reliés aux fiches Team et à leur union SYS-01.2-02. Les cinq fiches, leurs traces et leurs instructions copiables ont été mises à jour dans les deux bases réelles du plan. Un reçu est ajouté ; aucun consommateur de jeu ni lien vers un corps de jeu n’est inventé. Les contrats SCOPE411/415 et les acquis Solo444/446 sont conservés.

## Référence et sources

Référence : League of Legends 4.20.0.315, PUBLIC/Releases4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45. Fuseau et date de déploiement non établis. Catalogue4.20.1 et client AIR0.0.1.119 sont des identités distinctes. Travail sur F:/OpenLeague ; chemins historiques E conservés.

Le reçu `docs/reference_ranked_team_mode_roles_sources/ranked-team-mode-roles-source-contract-v445.json` conserve 15 autorités AIR, 69 groupes d’exports dérivés, 483 ancres et 202 fenêtres. Une copie de code extraite n’est pas reclassée comme binaire officiel.

| Fiche | Sources et revue | Sélecteur |
|---|---|---|
| MODE-RANKED-TEAM-SELECT |438 /439 |/associations/0 |
| MODE-RANKED-TEAM-RULES |440 /442 |/associations/1 |
| MODE-RANKED-TEAM-RANK |433 /435, sous-contrat Team |/associations/2 |
| MODE-RANKED-TEAM-RESULT |441 /443, sous-contrat Team |/associations/3 |
| SYS-01.2-02 |Union exacte des quatre contrats |/associations |

438/433 sont attribués à FreshCustom ;440/441 à Combat, également auteur de la préparation445 ;439/443 à Spell ;435 à Current et442 à ROOT. L’assemblage ne devient pas une nouvelle revue indépendante des propres travaux de son auteur. Les compteurs de chaque étape restent séparés.

## Portée précise

- **Sélection** : les littéraux RANKED_TEAM_GAME et RANKED_GAME_PREMADE restent distincts. Le prédicat isRanked ne constitue pas un classifieur teamOnly. Les paramètres et demandes de sélection humaine ne prouvent ni un roster valide ni une réponse effective du serveur. Les gardes de spectateur, phase, wildcard, tutorialPickOverride et les relectures des champs restent à leurs points respectifs.
- **Règles** : le prédicat PREMADE avec minimum supérieur à1 n’est pas le prédicat config non nulle/ranked/teamOnly du gestionnaire d’invitation. La configuration capturée ne capture pas les lectures ultérieures d’ID. Le défaut ServiceEnabled=true ne prouve pas la valeur effective. ConfigModel.getBoolean emploie l’égalité lâche avec le texte "true" ; aucune garde isString n’est ajoutée. Le paramètre true de processLobbyStatus ne supprime pas l’appel antérieur à getCurrentGame. Le chemin vers createArrangedRankedTeamLobby transporte ID et nom ; il ne prouve ni ownership ni succès réseau.
- **Classement** : seul le sous-contrat Team des services partagés est retenu. L’ajout conditionnel à myLeagues précède l’ajout à myTeamLeagues. Un DTO invalide peut bloquer une mise à jour sans bloquer toutes les opérations suivantes. Des effets de LEAGUE_POINTS_UPDATE/NOT_YET_SEEDED précèdent certains retours false. Les champs LP ne révèlent pas la formule MMR/LP.
- **Résultat** : trois prédicats WIN, le slot0 et les OR restent littéraux. Le reset à la désactivation est distinct du cleanup vide. Les cas Team2451 et Premade2452 appellent restartRankedTeam2498 : la garde Solo2471 et un write isSolo=false absent ne sont pas importés. Initialisation et mapContinue précèdent la lecture teamName2506. Dix-huit sites de résultat propres à Solo sont exclus.

Toutes ces chaînes décrivent du code sous réserve de retours normaux et d’absence d’intervention pertinente externe, réentrante, de notification ou de cycle de vie. Providers, DTO effectifs, serveur, admission, équipe, roster, MMR/LP et disponibilité EUW restent non qualifiés.

## Consommateurs réellement livrés et conservation

Le lookup borné a comparé les identités current/history/origin et les corps candidats sur une capture unique post444/446 :4 776 comparaisons,401 fichiers rehashés. Il ne justifie aucun nouveau consommateur local Team dans ce lot et ne démontre pas une absence globale de code. Les listes existantes de consommateurs sont strictement conservées.

Les vrais consommateurs de cette livraison sont les lecteurs du plan : Store.task, Store.copy_text, requirement_trace.resolve et make_instruction. Les contextes référencent des chemins absolus et le sélecteur propre à la fiche. Les quatre entity.map=null restent distincts de SYS.entity=null.

Les huit questions Team restent ouvertes. Les préfixes d’inputs, anciens enregistrements, origines, versions, statuts, flags, assessments, cases et notes sont conservés. Les autres42 209 exigences actives sont identiques. Le graphe passe de98 587 à98 588 sources et conserve2 408 consommateurs,25 321 questions ouvertes et5 517 résolues.

## Contrôles réellement exécutés

Le registrar puis l’audit séparé ont renvoyé code0. Les observations exactes, commandes, scripts, copies brutes et retours sont conservés sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision445/ROOT_COMMAND_OBSERVATIONS.json` et `ROOT_EXECUTION_RECEIPT.json`.

- Attendu : delta limité aux cinq fiches et à un reçu. Observé : reconstruction intégrale depuis les sauvegardes égale aux registres livrés, anciens sources/consommateurs conservés, registre des inconnues identique.
- Attendu : les cinq sélecteurs corrects sont acceptés ; les sélecteurs étrangers, incomplets ou modifiés sont refusés. Observé :5 nominaux,28 refus de sélecteur et27 refus de contenu, dont bool imbriqué à la place d’un entier.
- Sources :2 180 contrôles,295 identités ciblées,483 ancres/202 fenêtres. Ces contrôles sont distincts des4 776 comparaisons du lookup, des54 contrôles AST/métadonnées/RAM, du sceau et de son compagnon.
- Bases : les cinq fiches sont relues via les lecteurs réels dans `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et la base desktop désignée par `C:/Users/loicd/AppData/Local/OpenLeague Plan/connection.json`. Dans chacune :intégrité ok,42 606 états et notes inchangés,23 lignes d’historique identiques,42 601 autres lignes de catalogue identiques.
- Les six scripts ont été analysés syntaxiquement. Dix définitions du validateur de métadonnées ont été comparées par AST aux sources courantes. Son commentaire de provenance hérité444 n’est pas pris pour un nouveau fichier445.

Le compteur structurel source_hashes_verified=0 ne signifie pas un rehash global ; les rehashs ciblés sont consignés séparément. Aucun test de gameplay, programme AIR, VM, jeu original, Rust ou GPU n’a été exécuté. Les contrôles de sélecteurs ne prouvent pas le fonctionnement du mode classé.

La publication est sauvegardée mais séquentielle :trois remplacements JSON, puis deux transactions DB. Aucune atomicité globale n’est revendiquée. La preuve brute après enregistrement est conservée avant l’ajout de l’audit et du rapport.

## Écarts corrigés et suite

Une erreur de syntaxe and2468 a été refusée avant exécution et corrigée en V3. Le schéma du checkpoint446 et la comparaison JSON typée ont été corrigés avant publication ; V2 est conservée. Le refus bool/int imbriqué vérifie la correction. Les autres refus historiques restent attribués à leurs propres étapes.

Fichiers modifiés :les trois registres de sources, traces et tâches ;les deux catalogues SQLite ;le reçu, la preuve et ce rapport ;coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md. Les sauvegardes brutes précèdent les modifications documentaires. Le registre des inconnues et le code de jeu restent inchangés.

Revue documentaire447 encore à acquérir, puis contrat Tutorial input-lock450/451 et liens ITEM33 déjà préparés en privé. Aucun statut de tâche, champion, mode ou jeu complet n’est validé par cette seule livraison. SYS-01.2-02 et le goal restent ouverts.
