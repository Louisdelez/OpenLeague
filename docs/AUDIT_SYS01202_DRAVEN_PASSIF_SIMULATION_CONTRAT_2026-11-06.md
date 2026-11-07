# V1465 — Draven : contrat connu de League of Draven

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-DRAVEN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Draven-PASSIF-SIMULATION-CONTRAT, exigence OLF-48e31e03-419c-5cd8-92f6-f308144eece6, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts ; SOURCE a_qualifier, phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/draven-passive-adoration-gold-links-v565.json : 612571 octets, SHA256 45becb8239bd71692b26fc6d61069ba90cdbac466f179a8fdb75f04af408b691. Rapport FIDELITY_DRAVEN_PASSIVE_ADORATION_GOLD_LINKS_V565.md : SHA256 47ce85a7cec7e7d29c7b69631a6e398edef96eb5b2b711144a0b69fe37c0ca4c. Vérification publiée fidelity_draven_passive_adoration_gold_links_v565.json : 3134 octets, SHA256 39ed90d4b966259f253560afd4b31f7fee68cc2b0ec0ff37b9fc4ffbeb6d00d5. Preuves réutilisées ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Treize identités natives, cinq Lua entièrement parsés historiquement sans prototypes enfants. Quatre vues littérales qualifiées/neuf globals ; CharScript vide qualifié. Spinning refuse NEWTABLE atpc10 : globals inconnus, raw{} conservé, sans corruption déduite. Passive et PassiveStacks déclarent noms distincts, icône, persistance/non-dispel ; ReturnCatch déclare persistance. Aucune déclaration ne démontre compteur, rattrapage ou règle de moitié.

Cinq clés en_GB retrouvées : trois tooltips distincts, description et nom ; quatre bindings V565 conservés. Ligne 1848 : une charge au rattrapage de hache ou kill de sbire, monstre, tour ; kill de champion ennemi donnant f4 fixe plus f1 par charge consommée ; mort retirant la moitié. f2 « Total Gold Earned » et f3 « Highest Reward » sont des libellés sans fournisseur qualifié. Le tooltip Spinning ligne 1850 concerne Q ; aucune réécriture d’alias.

Passive1/Desc et six niveaux absents restent inconnus. Deux preloads et sept références communautaires restent déclaratifs ; CharScript communautaire vide et Q simplifié avec buff/particule ne prouvent pas les règles natives. Aucun nouvel accès natif, D/F-work ou ancien EXE.

## 3. Consommateurs réels

Vingt-sept entrées — dix-huit Rust, deux lecteurs Python, sept JSON — concordent avec V565 ; 31 identités courantes gardées, incluant le reçu de qualification des observations. Les sept sélections JSON sont héritées, dont règles ordinaires de récompense et d’or ambiant.

Trente-cinq fenêtres : 32 communes réutilisées et trois supplémentaires champion_credit_and_reward, ambient_gold, altar_reward. Vingt-cinq ancres couvrent catalogue et 24 frontières génériques, sans producteur Adoration qualifié.

lib.rs porte état/commandes/tick/snapshot ; attacks/lifesteal les attaques ordinaires ; damage/world les dégâts, morts et crédit ; champion_kills les récompenses ; passive_gold le revenu ambiant ; altars le bonus d’autel ; lifecycle les réapparitions ; shop les achats. Stats, critique, boucliers et lecteurs restent des mécanismes communs.

reward_champion_death attribue base_gold plus first_blood_bonus, met à jour or/score/XP et événement. world.damage_unit attribue gold plus altar_bonus via combat_owner. Le revenu ambiant suit une horloge reconstruite ; aucun de ces corps inspectés ne produit le compteur ou la conversion Adoration. Recherche bornée aux dix-huit Rust : zéro occurrence Draven/Adoration, sans preuve d’absence globale ni rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, rôles, valeurs et limites concordants. Observé : 55/55 contrôles documentaires, 68/68 cohérences du même agent ; quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V565 hérité : Draven frais, Caitlyn témoin, Draven après trois sbires crédités. Six kills de champions, deux par cas : 400 puis 300 or net, supplément zéro ; 45 refus atomiques. Ticks des kills : 2322/3943, 2399/4049 et 9578/11261. Réapparitions naturelles des victimes ; décès de Draven et perte de moitié non testés.

Trois récompenses de sbires : ticks 3685/4120/8611, montants 13.8000031/18.9999847/19.2000122. Elles ne démontrent pas trois charges internes. L’ancien champ hits totalise 123 baisses de santé, dont 71 avec projectile du joueur dans le snapshot précédent et 52 sans ; aucune attribution exclusive aux attaques du joueur revendiquée. Le reçu publié qualifie explicitement cette sémantique sans modifier les observations.

Les règles courantes donnent 300 plus 100 de premier sang ; revenu ambiant 8 à partir de 75 secondes puis toutes les cinq secondes. Les paiements ambiants avaient été retranchés par tick dans V565. Ces valeurs et le bonus d’autel sont distincts de f1/f4.

Binaire ancien identifié uniquement en données : 6084096 octets, SHA256 d99d2f34c5880f84aa44ea903052da8606b15d6ebaaa91d3fb8ef04fd0a9eeb3. Aucun accès, hash ou lancement.

## 5. Écarts et conclusions ouvertes

f1/f2/f3/f4, éligibilité/crédit, compteur/cap/lifetime, rattrapage, catégories monstre/tour, consommation, arrondi de moitié, ordre simultané kill/mort, statistiques et projections restent ouverts. f2 n’est pas assimilé à player.gold ; f3 n’est pas doté d’une formule inventée. PersistsThroughDeath ne contredit ni ne démontre la perte partielle décrite.

Les parcours réussis V565 ne réparent pas les annulations de déplacement V564, ni les échecs et diagnostics antérieurs conservés. Aucun nouvel audit de ces incidents ou de textures ; aucune absence d’asset déduite des lacunes de gameplay.

## 6. Corrections et reprise

Quinze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-DRAVEN-ADORATION-, suffixe -01 : AUTHORITY, AXE-CATCH, MINION, MONSTER, TOWER, STACK-STATE, CASHOUT, DEATH-HALF, PROC-ORDER, CREDIT, TOTAL-GOLD, HIGHEST-REWARD, REWARD-SEPARATION, PROJECTION, VERIFICATION.

Chaque fiche possède objectif, tâche V565 réellement associée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source précise, dérive, contradiction ou comportement supporté non vérifié ; correction fonctionnelle et nouvelle exécution sous autorisation distincte. Garder les refus, observations qualifiées et inconnues.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_draven_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2451 entrées groupées modifiées conservées. Prochaine sélection DrMundo depuis les 122 paires existantes, distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité, inconnues et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés ; aucun nouveau runtime, REA, rendu, audio, réseau ou logiciel installé.
