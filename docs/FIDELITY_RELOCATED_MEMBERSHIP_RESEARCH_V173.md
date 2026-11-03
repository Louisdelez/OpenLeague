# SYS-01.2-02 — lecteur RADS et déplacement sur F

Le lecteur installé rads_reference_membership.py refuse F:/OpenLeague avec « Recovered manifest bytes or backing changed » : son catalogue immuable conserve les chemins E:/OpenLeague. Le refus est reproduit après l’erreur initiale d’accès sandbox, distincte. Le catalogue historique n’a pas été réécrit.

Une correction isolée accepte seulement le déplacement déclaré dans docs/project_location.json, avec racines distinctes non imbriquées, même chemin relatif, sources historiques conservées et égalité SHA256/taille des deux copies. Les chemins reparse sont refusés. Les contrôles existants des manifestes sélectionnés restent actifs.

Huit contrôles passent : même chemin, déplacement déclaré et octets identiques, refus des octets actuels modifiés, des octets historiques modifiés, de déclaration absente, d’historique non conservé, de mauvaise racine active et de racines imbriquées. Le candidat lit les deux manifestes réels et examine43 fichiers vides :2 correspondent aux membres sélectionnés,4 ne sont pas listés,37 sont hors du déploiement des deux projets du jeu. Ces37 cas ne sont pas déclarés absents de tous les manifestes.

Le candidat n’est pas installé et le graphe n’est pas modifié. Ni intentionnalité des fichiers vides, ni réparation, ni précédence de chargement ne sont déduites. Les preuves antérieures sont conservées.

Preuves et scripts : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision173/RELOCATED_MEMBERSHIP_QUALIFICATION.json, rads_membership_relocated_candidate.py et qualify.py.

Suite : installer la correction avec versionnement de la source enregistrée, conserver ses anciens octets et liens historiques, puis relier les résultats aux tâches concernées et vérifier les consommateurs du plan. Examiner séparément le périmètre des37 fichiers hors des manifestes du jeu.
