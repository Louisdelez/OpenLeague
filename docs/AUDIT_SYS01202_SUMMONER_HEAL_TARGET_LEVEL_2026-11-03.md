# SYS-01.2-02 — Heal : cible et niveau des bénéficiaires

Date : 2026-11-03. Unité : AUD-SYS-01.2-02-SUMMONER-HEAL-TARGET-LEVEL-01. Exigence parente d'audit SYS-01.2-02; tâches existantes SUMMONER-SummonerHeal-SCOPE (OLF-8c849c07-a700-52df-9178-4649ad93607e) et SUMMONER-SummonerHeal-SERVER (OLF-e5c274c7-549b-5f86-b84d-cd893efebec8).

## Contrat, critères et frontières

Question : identifier la source disponible et le chemin courant de sélection de l'allié et de calcul selon le niveau, y compris cible explicite non valable. Critère de ce sous-audit : présenter source et provenance, code réellement emprunté, cas nominal et refus sous forme de prédictions ou résultats explicitement qualifiés, écart ou incertitude et tâches de reprise. Exclure la vérification intégrale de Heal, les autres sorts, le cooldown déjà audité et toute acceptation en jeu.

## Sources et provenance

- OLS-8416fad1-d71b-5047-a23d-2c7337858a11 : client fourni 4.20.0.315 EUW/en_GB, deploy/DATA/Spells/SummonerHeal.inibin, 1 567 octets, SHA-256 ef988a5b19ad8fc4db3e210fb76fae4c826562f21c82128c891dd0332e5bb8c5. Le reçu natif docs/reference_native_skin_loader_sources/native-release-membership.json lie taille et MD5 449abf0e36630d2730d80cfa258d89dd au projet lol_game_client 0.0.1.7, fichier 0.0.0.249. Preuves héritées du 2026-11-02 : AUDIT_SYS01202_SUMMONER_HEAL_COOLDOWN_LINK_2026-11-02.md. Cette identité et le cooldown décodé ne démontrent pas la politique serveur de cible ou de niveau; priorité runtime non qualifiée.
- OLS-22f06d52-9752-5b89-863b-92b0614a555e : copie de catalogue officiel 4.20.1 en_US, distincte du client EUW/en_GB exact, data/4.20/native_summoners_420.json:1, entrée /data/SummonerHeal. Son tooltip décrit un soin du lanceur et d'un allié, un repli vers l'allié le plus blessé à portée, une portée de 850 et une table de 90 à 345 associée à @player.level. Il ne tranche pas explicitement le niveau utilisé par le calcul serveur de chaque bénéficiaire, le critère numérique du plus blessé ni l'égalité. Il ne permet pas de déduire seul la règle historique pour une cible explicite invalide.
- data/4.20/heal_rules.json:3–5,12 définit portée 850, base 90 et +15 par niveau; la politique de niveau du bénéficiaire y est qualifiée d'interprétation communautaire non validée en runtime original. Ce n'est pas une preuve primaire serveur.

Le reçu existant de source et le cooldown n'ont pas été réexécutés ni rehashés : aucune modification de ces fichiers ni nouvel indice d'identité n'a été établie ici.

## Consommateurs courants et contrôles

Lecture du registre par .ai-tools/.venv/Scripts/python.exe -B tools/project-plan/requirement_trace.py --root F:/OpenLeague --task SUMMONER-SummonerHeal-SERVER : sortie 0; liens natif/catalogue et OLC-a1d7c55a-749b-518a-9fd0-b2654f72a3b1 / summoners.rs:47 relevés. L'absence d'unknown_ids et le statut associated_sources_and_current_entrypoints ne démontrent pas une mécanique résolue; game_behavior_accepted est false. Le registre n'a pas été modifié.

Dans le code source courant, lib.rs:619–620 dirige les actions Summoner et SummonerTarget vers summoners.rs:44–73, qui vérifie notamment partie, slot, joueur, état et recharge avant cast_heal. Le client main.rs:1394–1434 peut produire SummonerTarget avec une cible alliée sous le pointeur, ou aucune cible dans certaines conditions. Aucun événement n'a été envoyé pour ce lot.

summoner_heal.rs:36–83 choisit une cible explicite si elle existe et est vivante, alliée, distincte du lanceur et à 850 unités ou moins; elle peut être à pleine santé. Une cible absente de players rend unknown heal ally; une cible ennemie, morte, soi-même ou trop loin rend invalid heal ally. Ces refus surviennent avant le soin et la recharge dans cette fonction, sous réserve des gardes amont.

Si target=None, le code choisit parmi les alliés vivants et blessés à portée le plus petit ratio santé/santé maximale; en cas d'égalité, le plus petit identifiant. Si aucun ne correspond, seul le lanceur est retenu. Chaque bénéficiaire est ensuite évalué séparément : 90 + 15 × (niveau borné à 1–18 − 1), avant multiplicateur de soin récent. healing.rs:8–13,38–39 applique ensuite les modificateurs de soin reçu et borne les PV au maximum.

## Cas et résultat observé

- Cas nominal conditionnel prédit par lecture : lanceur niveau 18 et allié niveau 1 explicitement sélectionné, valides, sans soin récent ni autre modificateur, tous deux assez blessés : montants demandés 345 et 90. Le test existant summoner_heal.rs:158–164 attend respectivement 445 et 190 PV à partir de 100; il a été lu, pas exécuté ici. Les niveaux différents montrent le choix local du bénéficiaire, sans prouver la fidélité historique.
- Refus conditionnel prédit : ID absent, ou cible ennemie/morte/soi/hors portée, retourne l'une des erreurs ci-dessus avant soin et cooldown; les tests existants :143–155 couvrent plusieurs de ces entrées, sans avoir été exécutés ici. La santé pleine est acceptée comme cible explicite dans ce code alors qu'elle est exclue de la recherche automatique.
- Le catalogue décrit un repli si aucune cible n'est trouvée. Le refus local d'une cible explicite invalide est une différence potentielle d'interprétation, pas une contradiction historique prouvée : le contrat exact de sélection et les conversions client/serveur restent à établir.

## Écarts, corrections et reprise

Audit statique de cette liaison terminé dans ses seules frontières. Implémentation locale partielle; vérification runtime non exécutée; acceptation humaine non donnée. Les tâches SCOPE et SERVER restent a_qualifier avec implementation_complete=false et acceptance_complete=false; NET reste à qualifier. La sélection historique, les égalités, le niveau retenu, le traitement d'une cible invalide et les conditions de carte restent ouverts.

Réutiliser SUMMONER-SummonerHeal-SCOPE pour qualifier la disponibilité et les règles historiques; SUMMONER-SummonerHeal-SERVER pour appliquer le contrat démontré et tester niveau du lanceur différent de celui de l'allié, blessure absolue/relative, égalités, portées limites et cibles explicites invalides; SUMMONER-SummonerHeal-NET pour qualifier transmission et réplication. Ces corrections ne sont pas appliquées ici. Reprendre la décision historique sur une source serveur 4.20 attribuable ou une observation/capture historique fiable permettant de distinguer niveau, choix d'allié et traitement des refus. Ne pas répéter les hashes ou la lecture du même code sans modification ou piste nouvelle.

Relecture : exigence et limites, provenance, consommateurs, attendu/observé, écarts, tâches existantes et preuves datées sont renseignés. Aucun build, test Rust, exécutable de jeu, émission réseau, modification de code, registre, goal, application de suivi ou base n'a été exécuté ou modifié dans ce lot.
Contrôle complémentaire du 2026-11-03 : script Python en lecture seule, sortie 0, a vérifié les champs de portée/table du catalogue et des règles, les ancres de sélection/refus du code courant, les statuts inchangés des deux tâches, l'unicité des repères du rapport et des deux notes, ainsi que le calcul arithmétique 345/90. Il ne lance pas le code Rust et ne valide pas le gameplay.
