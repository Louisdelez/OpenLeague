# SYS-01.2-02 — Graves : True Grit, V574

Date UTC : 2026-10-26T01:09:52.650372+00:00. Projet : F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45. Fuseau et date de déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

Les fiches CH-Graves-PASSIF-SOURCE, CH-Graves-PASSIF-SIMULATION-CONTRAT et CH-Graves-PASSIF-SIMULATION reçoivent 45 associations vers 15 ressources natives, avec un rôle précisé pour chacune, et 44 liens vers 22 points de code actuels. SYS-01.2-02 référence le lot. Les trois questions propres, quatre dépendances, états et critères restent conservés. Les prérequis de phase et de lot ont été consultés sans être déclarés satisfaits pour une acceptation du gameplay.

**Les sources décrivant True Grit existent. Le moteur ne produit pas ses bonus défensifs dans les scénarios de combat prolongé exécutés.** Les points de code sont qualifiés `entry_boundary_only`, `provides_feature_consumer=false` pour ce passif. Aucun gameplay ou asset modifié. Une source identifiée ou un test du moteur générique ne signifie pas que Graves est terminé.

## Sources et rôles

| Ressource | Identifiant de source |
|---|---|
| Graves.inibin | OLS-8e9ba3e4-9318-55fe-b152-44bdfdc912d3 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptGraves.luaobj | OLS-66ff4881-2847-5cb7-945d-be8c53f9517c |
| CharScriptGraves.preload | OLS-6455e96d-dd59-5558-aa0e-96c316a5bfb9 |
| GravesPassive.inibin | OLS-dc266919-8ef4-5384-9acd-f8565109c8cd |
| GravesPassive.luaobj | OLS-990ad8cf-5f93-578d-926d-843073147563 |
| GravesPassiveGrit.inibin | OLS-46428cf8-9515-5bcf-88a8-48506668aaf9 |
| GravesPassiveGrit.luaobj | OLS-b2fa7194-4d49-51e8-a500-9f2a4df4f5af |
| GravesPassiveStack.luaobj | OLS-d5241f82-1e5c-5b77-9cf8-8f1e0808e24e |
| GravesPassiveCounter.luaobj | OLS-8ad1b3df-5f83-502d-a32b-064b2f87af70 |
| GravesPassiveCounter.preload | OLS-df9be62b-cc5e-57fd-b70b-232639a26e5e |
| GravesPassiveShotAttack.inibin | OLS-a6f9cb5b-6bbe-58c1-bab5-6cbb27efc081 |
| GravesPassiveShotAttack.luaobj | OLS-6827bef4-98f2-5be5-bdfd-7ef881bbd52c |
| GravesPassiveShotAttack.preload | OLS-3e203244-193e-58a9-a8f6-bf59a4293aa3 |
| GravesPassiveShotAttack.fx | OLS-ff3c974c-eb1b-5006-8f98-27f1a2dbb4fa |

Les 15 identités ont été contrôlées en taille/SHA256 contre le registre et en taille/MD5 contre les manifestes RADS sélectionnés. Cela ne qualifie pas la priorité effective des sources au chargement historique. Les rôles détaillés se trouvent dans `native_metadata.source_roles` du reçu : définition du personnage, texte, métadonnées de buffs, déclarations de préchargement et contexte connexe à qualifier ne sont pas interchangeables.

Graves.inibin lie le passif `GravesPassive`, l’icône `GravesTrueGrit.dds` et la clé de description du personnage. Le tooltip en_GB ligne 1964 annonce un bonus d’armure et de résistance magique `f1` chaque seconde de combat, jusqu’à dix cumuls. Il définit le combat par des dégâts infligés ou reçus pendant les trois dernières secondes. Le binding de GravesPassiveGrit résout la ligne 1965. La ligne 1966, GravesPassiveGritStacks, a également été retrouvée dans le font, mais aucun binding supplémentaire n’est inventé pour elle.

Le montant `f1`, sa progression par niveau et son producteur exact restent à qualifier. Les champs Passive1Level1..6 recherchés sont absents; aucune valeur zéro n’en est déduite. Les descriptions héritées de critique d’alliés et de vitesse d’attaque +10/+15/+20% sont conservées sans adoption comme règles de True Grit.

Six chunks Lua ont été entièrement lus, sans prototype enfant; leurs initialisations littérales ont été reconnues. Aucun callback du serveur historique n’a été exécuté. GravesPassive déclare `PersistsThroughDeath=true`; cela ne prouve pas que les cumuls ou leur délai persistent. GravesPassiveGrit déclare l’effet `GravesTrueGrit.troy`, mais cette référence n’est pas une preuve de rendu.

Les trois preloads ont été conservés. CharScriptGraves précharge GravesPassiveCounter et GravesPassive; le compteur précharge GravesPassiveGrit. Le CharScript Lua contient les noms `Pineapple`/`Pineapple.dds`. GravesPassiveStack contient `RumbleDangerZone`/`Rumble_Junkyard Titan2.dds`. Ces alias sont des données réelles du candidat, pas une raison suffisante pour renommer un fichier ou adopter une logique de Rumble.

ExtraSpell2 référence GravesPassiveShotAttack; son preload référence le tir et GravesPassiveStack. Ces relations justifient de conserver les candidats avec un rôle connexe explicitement non qualifié. Elles ne prouvent pas que ce chemin applique les défenses de True Grit. Le fichier FX binaire est vérifié en identité et appartenance à la release; son format, son exécution et son rendu ne sont pas qualifiés ici.

Dix références communautaires sont pinées séparément. CharScriptGraves.cs est vide. Quickdraw.cs applique un bonus de vitesse d’attaque et reste un buff distinct. Les scripts Q/W/E/R et JSON présents ne démontrent pas un serveur historique complet ni le mécanisme original de True Grit.

## Moteur réellement exercé

Cinq simulations Map10 : repos, attaques émises, attaques reçues, attaques reçues après achat d’une Armure d’étoffe 1029, et attaques reçues après achat d’un Manteau de néant 1033. Graves bleu et Annie rouge atteignent les positions centrales par Move puis Stop. Santé pleine confirmée après déplacement. Chaque cas de combat produit dix impacts. Aucun changement direct de position, santé, niveau, XP, rang, ressource ou effet; aucun événement artificiel de dégâts.

| Cas | Impacts | Armure courante | RM courante | Premier au dernier impact, ticks | Refus | Suivi, ticks |
|---|---:|---:|---:|---:|---:|---:|
| idle | 0 | 24.375999 | 30.0 | None | 15 | 300 |
| outgoing_attacks | 10 | 24.375999 | 30.0 | 432 | 15 | 300 |
| incoming_base | 10 | 24.375999 | 30.0 | 468 | 15 | 300 |
| incoming_cloth_armor | 10 | 39.375999 | 30.0 | 468 | 15 | 300 |
| incoming_null_magic_mantle | 10 | 24.375999 | 55.0 | 468 | 15 | 300 |

Attendu pour qualifier les voies génériques : chaque perte de santé doit correspondre au projectile source/cible observé dans le snapshot précédent et aux dégâts physiques `brut × 100 / (100 + armure)`, après correction de la régénération. Observé : 40 impacts identifiés, aucun critique, résidu inférieur à 0,002. Les variations de santé pendant les 300 ticks de suivi de chaque cas correspondent uniquement à la régénération attendue.

Les achats publics apportent séparément +15 armure et +25 résistance magique. Ce sont des contrôles du chemin des objets, pas des cumuls de True Grit. Les statistiques de Graves restent ensuite strictement identiques, à chaque tick inspecté pendant les attaques et le suivi. Niveau 1 conservé. Aucune augmentation liée au temps de combat observée.

Les dix attaques émises s’étalent sur 432 ticks (14,4 secondes), avec 48 ticks entre impacts. Chaque série de dix attaques reçues s’étale sur 468 ticks (15,6 secondes), avec 52 ticks entre impacts. Ces intervalles sont tous inférieurs aux 90 ticks correspondant aux trois secondes décrites par le texte natif. Le test couvre donc du combat régulier au-delà de dix secondes; dix impacts ne sont pas assimilés à dix cumuls.

Le suivi dure dix secondes par cas, soit 1 500 ticks au total. Comme aucun bonus n’a été créé, ce suivi ne qualifie pas une règle d’expiration native. La résistance magique est observée dans les statistiques; aucun dégât magique n’a été exécuté dans ce lot. La mitigation magique avec True Grit reste à tester après intégration.

Les 75 refus publics couvrent, dans chaque cas, joueur inconnu, attaque de soi, slot invalide et Learn/Cast/CastAt sur les quatre capacités. Les snapshots sont inchangés. Les messages distinguent progression de compétence, sort ciblé et sort au sol non implémentés. Ces refus ne valent pas acceptation du gameplay.

## Consommateurs actuels et écart

Les fonctions reliées couvrent connexion, commandes, statistiques de base/croissance/objets, apprentissage et cast, attaques, dégâts, mitigation, pénétration, contributions aux éliminations, ordre des ticks, régénération, achat, snapshot et cycle de vie. Le calcul actuel des défenses comporte des bonus d’objets et des traitements explicites pour d’autres capacités, mais aucun ajout de cumuls Graves dans les chemins inspectés.

Le registre de contributions aux éliminations mémorise des dégâts pour les récompenses et assistances. Il ne doit pas être présenté comme l’état de combat de True Grit. Le cycle de réapparition a seulement été inspecté statiquement. Les captures de simulation ne qualifient ni le transport réseau, ni le HUD, ni un rendu GPU.

## Identité et contrôles de livraison

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-graves-passive-true-grit-probe.exe`. Taille : 6035968 octets. SHA256 : `124c1fcf7fe842c3153872aadb7113bc377cd9716d548319eab889a57182c536`.

Compilation et exécution : code 0. `openleague_core` non-test, verrou privé aligné sur les identités et checksums du verrou racine. Les 1 158 entrées core/ressources et la chaîne des preuves précédentes sont inchangées, y compris Gragas V573, Gnar V572 et ses diagnostics de voie échoués. Pas de client ou serveur historique exécuté.

Discovery, inspection, prepare, check, publish et audit : code 0. Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments de trace ont changé, 42 212 sont conservés. Deux bases SQLite vérifiées par les lecteurs réels Store.task/copy_text/summary/dépendances et la résolution de trace : quatre destinataires, 42 603 autres lignes du catalogue, 42 607 états manuels et 23 événements historiques conservés. Intégrité et synchronisation normale idempotente vérifiées. Identifiants, hiérarchie et registre des inconnues sont identiques en octets.

Revue globale fraîche : 42 215 exigences, 98 972 sources, 3 402 consommateurs; 3 402 ancres exactes et aucune divergence de leurs fichiers courants. Les 26 189 inconnues ouvertes et 5 517 résolues restent inchangées. Cette revue ne re-hashe pas toutes les sources et ne mesure pas le pourcentage de jeu terminé.

## Travail restant

- Qualifier le producteur de `f1`, les valeurs par niveau et le bonus exact par cumul.
- Définir les sources et cibles de dégâts admissibles : champions, unités, pets, dégâts périodiques, dégâts nuls ou absorbés.
- Qualifier l’entrée en combat, le premier incrément, les frontières d’une seconde/trois secondes, le rafraîchissement et la perte des cumuls.
- Intégrer le compteur, son plafond de dix, les bonus armure/RM et leur emploi dans les dégâts réels.
- Vérifier combat continu/interrompu, niveaux, objets, effets de réduction/pénétration, mort/réapparition et fin de partie.
- Qualifier séparément réseau, HUD, animations, VFX et audio. Aucun asset absent ne se déduit de ces seuls tests de gameplay.
- Conserver le défaut de déplacement V564 ouvert; les routes centrales réussies ne le corrigent pas.

## Fichiers modifiés et reprise

Registres : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/graves-passive-true-grit-links-v574.json. Preuve : docs/fidelity_graves_passive_true_grit_links_v574.json. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases mis à jour avec sauvegardes. Scripts et journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision574_Graves. Aucun statut, case, note, historique ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision575_trace_review/REVIEW.json. GravesV574 publiée/auditée :3fiches,15ressources aux rôles distincts,45associations,22points/44liens limités. Cinq cas publics :repos,attaques émises/reçues et objets1029/1033;40impacts,75refus,1500ticks après arrêt. Combat432/468ticks avec intervalles48/52<90;armure/RM constantes après achat. Bonus objets15armure/25RM distincts. Texte natif incrément1s,cap10,combat décrit sur3s;f1,frontières temporelles,éligibilité et lifecycle ouverts. AliasPineapple/Rumble et cheminShotAttack conservés sans adoption. Préserver INPUTS_BEFORE.previous_artifacts V574 et toute la chaîne. Aucun statut/case/inconnu fermé. Poursuivre un autre passif de la file après inspection réelle,par exemple Hecarim. Défaut déplacementV564 ouvert;goal actif.
