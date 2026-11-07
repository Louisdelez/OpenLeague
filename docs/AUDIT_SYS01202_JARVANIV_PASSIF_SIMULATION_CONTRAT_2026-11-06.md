# V1483 — Jarvan IV : contrat connu de Martial Cadence

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-JARVANIV-PASSIF-SIMULATION-CONTRAT-01, tâche CH-JarvanIV-PASSIF-SIMULATION-CONTRAT, exigence OLF-47b4fa97-f1f4-5def-b73c-a4a0e4fa3204, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/jarvaniv-passive-martial_cadence-links-v579.json du 26 octobre 2026 : 860174 octets, SHA256 efc6cc643fd18964506f391875a7ef79d30550f2862b0293dc0214b33bb28745. Rapport FIDELITY_JARVANIV_PASSIVE_MARTIAL_CADENCE_LINKS_V579.md : SHA256 6bd71a723d22d8040501cba3a561d7ba8e2584eac870b739572eb13d925d4424. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Treize identités natives aux rôles distincts, neuf références communautaires séparées, deux preloads. Quatre Lua entièrement parsés historiquement, sans prototype enfant ; trois initialisations littérales et cinq globals. NEWTABLE au pc0 de MartialCadenceAttack limite le lecteur littéral, sans corruption démontrée ni exécution serveur. CharScript natif et classe communautaire vides ne prouvent pas une mécanique serveur.

Quatre clés en_GB vérifiées. Le tooltip source ligne 2091 décrit première attaque, bonus physique de 10 % des PV actuels, maximum 400 et délai par ennemi @f1@ non résolu. Le buff cible ligne 2092 mentionne un délai court sans nombre ; description personnage ligne 4204 et nom conservés séparément.

Le personnage nomme JarvanIVMartialCadence et ExtraSpell1=JarvanIVMartialCadenceAttack ; les deux buffs concordent sur JarvanIV_MartialCadence.dds. Persistance source true ; champ absent de la cible non converti en false. DDF : vingt entrées, dont quatre du passif avec link/coeff vides, sans durée déduite. AnimationName=Passive et Cooldown/Cooldown1..6 à zéro ne définissent pas le verrou par cible. FX identifié sans décodage/rendu ; particule jarvincritattack_tar et buff Check déclarés en preload, sans activation prouvée. Anciennes chaînes Master Yi/mana et six champs de niveau absents restent sans adoption.

## 3. Consommateurs réels

Vingt-quatre entrées concordent avec V579 : quinze Rust, deux lecteurs Python, sept JSON. Avec le miroir en_GB, 25 identités gardées. Les 32 fenêtres communes sont réutilisées après comparaison des octets et lignes. Vingt-trois ancres enregistrées, dont 22 frontières entry_boundary_only/provides_feature_consumer=false. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

advance_attacks échantillonne l’AD et livre le coup mêlée par basic_attack_hit. Celui-ci appelle apply_damage physique ; pénétration/mitigation précèdent boucliers et PV, puis le vol de vie générique utilise post_mitigation. Le prochain coup dépend de next_attack, pas d’un verrou Martial Cadence propre à la paire source/cible. Aucun bonus de PV actuels dans ces chemins. Ces règles locales ne deviennent pas l’ordre natif du passif.

Recherche littérale Jarvan/MartialCadence sur quinze Rust sélectionnés : zéro occurrence. Pas d’absence globale ni d’inspection des 1158 dépendances revendiquée. remove_player et respawn sont inspectés statiquement, sans validation du cycle de vie du passif.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer texte natif, dégâts ordinaires, contrôle Épée longue et état par cible. Observé : 66/66 contrôles documentaires, 92/92 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V579 hérité : deux cas publics base/Épée longue 1036, huit coups chacun sur deux Annie ennemies, ordre A A B B A B A B. AD brut 55.71200180053711 puis 65.71200561523438 ; les 16 impacts correspondent aux dégâts ordinaires, résidus maximaux 0.00000762939453125 et 0.000011444091796875, inférieurs à 0,002. Cibles survivantes, acteurs niveau 1, sans critique ni injection d’état. Régénération et cible non frappée suivies à chaque tick.

Au premier impact, cible à 511.67999267578125 PV ; le texte suggère environ 51,168 bruts supplémentaires, absents du résultat courant. Ce calcul indicatif ne qualifie ni le moment de lecture des PV ni l’ordre natif de mitigation. Le changement de cible ne démontre aucun délai natif. Maximum 400 non atteint.

Trente-deux refus atomiques avec snapshots inchangés ; après Stop, 180 ticks cumulés de régénération seule. Sbires/monstres/structures, seuil minimum, niveaux supérieurs, boucliers, critique, annulations et lifecycle non exercés.

Exécutable V579 identifié uniquement en données : 6028288 octets, SHA256 18374d860f2adc88a15c6aa1af67432ad07bb06c3bf165817c06043d00e2af64. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés. Inspection initiale échouée par conversion de clés hash textuelles en entiers conservée ; inspection qualified réussie séparément. Ancien défaut de syntaxe du générateur et commande PowerShell conservés comme erreurs documentaires, sans corruption des assets ni nouvel échec moteur allégué.

## 5. Écarts et conclusions ouvertes

Restent fournisseur f1 et niveaux, cibles, lecture des PV, ordre du bonus, maximum/minimum, propriété du verrou source/cible, expiration/refresh, annulations, boucliers, critique, effets au contact/vol de vie, précision, cycle de vie, réplication et présentation.

Question OLU-3b277404-7ed8-5c41-9788-f94bf414ff5d, dépendances et propriétaires SOURCE conservés. Aucune inconnue fermée ; défaut de déplacement V564 non corrigé.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-JARVANIV-MARTIAL-CADENCE-, suffixe -01 : F1-COOLDOWN, LEVEL-SCALING, TARGETS, CURRENT-HP-SAMPLING, DAMAGE-COMPOSITION, CAP-MINIMUM, SOURCE-TARGET-STATE, LOCKOUT-EXPIRY, ATTACK-CANCEL, SHIELDS, CRITICAL, ONHIT-LIFESTEAL, LIFECYCLE, NUMERIC, RUNTIME-INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_jarvaniv_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2469 entrées groupées préexistantes conservées. Prochain Jax depuis 122 paires ; 85 candidats hors 37 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
