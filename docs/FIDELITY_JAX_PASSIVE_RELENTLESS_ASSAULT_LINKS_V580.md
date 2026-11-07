# SYS-01.2-02 — Jax : Assaut implacable, V580

Date UTC : 2026-10-26T02:50:37.446573+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

Les trois tâches CH-Jax-PASSIF-SOURCE, CH-Jax-PASSIF-SIMULATION-CONTRAT et CH-Jax-PASSIF-SIMULATION reçoivent 63 associations vers 21 ressources natives, avec contexte R explicitement distinct, et 44 liens vers 22 points du code courant. SYS-01.2-02 référence le lot. Quatre inconnues propres, quatre dépendances, critères et statuts conservés ; prérequis de phase et lot consultés.

**Aucune accélération cumulative n’apparaît dans les attaques courantes de Jax.** Huit attaques ininterrompues restent espacées de 47 ticks, ou 41 avec une Dague. Les consommateurs restent `entry_boundary_only`, `provides_feature_consumer=false`. Aucun gameplay ou asset modifié : ce lot établit les sources, les consommateurs actuels et l’écart restant.

## Sources et rôles

| Ressource | Identifiant |
|---|---|
| Jax.inibin | OLS-16c2ec85-611e-519d-bf1a-f57d1b810017 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptJax.luaobj | OLS-fb8d53a4-59f7-537c-9641-19ca97ae1cf8 |
| CharScriptJax.preload | OLS-0556cebc-974c-5b93-b9bd-e3abbc9913a3 |
| JaxPassive.inibin | OLS-df1684e3-9406-59a7-9dac-32a972f06b83 |
| JaxPassive.luaobj | OLS-d87bc489-09b8-5d5b-bebe-c046c8575baf |
| JaxPassive.preload | OLS-64789f51-cc67-503c-8a12-100ea465574f |
| JaxRelentlessAssault.inibin | OLS-f5b21ba6-3ecf-5549-9892-72716797c51e |
| JaxRelentlessAssault.luaobj | OLS-0a771f64-0b3e-5583-b6bf-8248b113dc15 |
| JaxRelentlessAssault.preload | OLS-23f53c59-0aeb-5e1e-9661-dda9023a57b2 |
| JaxRelentlessAssault.fx | OLS-597f8625-ea20-56ba-8c7e-9f4b7b31855e |
| JaxRelentlessAssaultAS.inibin | OLS-a0845d5b-b3c4-5313-97e2-f902ce4b5d63 |
| JaxRelentlessAssaultAS.luaobj | OLS-a6c44940-213f-5637-9828-a328ef39a0ee |
| JaxRelentlessAssaultSpeed.luaobj | OLS-5eac2242-d53e-5b5a-9588-bc93e74656ca |
| JaxRelentlessAssaultSpeed.preload | OLS-d5bf10bc-d520-5bc4-9981-774184f8ce70 |
| JaxRelentlessAssaultDebuff.luaobj | OLS-4b2f08d5-5af2-5a16-8e19-6afb5fc8be27 |
| JaxRelentlessAttack.inibin | OLS-33730220-5910-5b6c-9f7a-a4a66c85e997 |
| JaxRelentlessAttack.luaobj | OLS-d3510632-eaee-5110-932f-32279fae4ca5 |
| JaxRelentlessAttack.preload | OLS-59ffa15a-d95e-579f-9b95-f3a9fcb5f0c4 |
| JaxRelentlessAttack.fx | OLS-0bcab88a-b5c3-5c5f-9a27-83f6112c6dfb |
| Jax.ddf | OLS-c4acaa83-333b-5cfb-853b-3322d30ed2b5 |

Les 21 ressources sont vérifiées par taille/SHA256 contre le registre et taille/MD5 contre les manifestes RADS sélectionnés. Leur appartenance ne démontre pas l’ordre effectif de montage historique.

Le personnage désigne JaxPassive. Son tooltip ligne 2096 annonce un bonus @f1@ % de vitesse d’attaque pendant 2,5 secondes, cumulable six fois ; le coefficient reste non résolu. La description personnage ligne 4205 décrit une accélération par attaques consécutives. Les champs Passive1=9 et Passive1Level1..4=3/7/11/15 sont conservés sans devenir une formule ; les niveaux 5/6 sont absents. Les anciennes chaînes « dégâts supplémentaires des objets AD » et régénération de mana ne sont pas adoptées comme règle du passif.

La séparation avec le R est vérifiée : Spell4=JaxRelentlessAssault, ExtraSpell3=JaxRelentlessAttack. Les textes natifs description 9508, nom 10220 et tooltip 11604 identifient Grandmaster’s Might, un troisième coup magique et une activation défensive. Le DDF contient 12 entrées R/Q/E, notamment les liens spéciaux armure/MR du R ; aucune entrée JaxPassive. Les noms historiques et preloads partagés ne justifient pas de fusionner passif AS et troisième coup du R.

Quatre bindings de buff sont inspectés : JaxPassive 2096, JaxRelentlessAssaultAS 2098 et JaxRelentlessAttack 2099 se résolvent. **game_buff_tooltip_JaxRelentless_Assault ne se résout pas**. La clé ressemblante sans underscore existe ligne 2097, mais n’est pas substituée automatiquement. Le texte similaire reste une référence séparée, pas une preuve d’alias historique.

Sept chunks Lua sont entièrement lus, sans prototype enfant ; six initialisations littérales sont reconnues. Le lecteur littéral atteint sa limite NEWTABLE pc6 dans JaxRelentlessAttack, sans corruption démontrée. CharScriptJax a des globals vides ; le buff JaxPassive déclare PersistsThroughDeath=true. Le buff AS ne donne pas cette propriété, sans valeur par défaut inventée. Les flags TriggersSpellCasts/DoesntTriggerSpellCasts restent des métadonnées, pas une preuve d’exécution.

Le personnage et le buff AS référencent Armsmaster_MasterOfArms.dds, tandis que JaxPassive utilise Armsmaster_CoupDeGrace.dds. Les rôles visuels restent à qualifier sans écraser une référence. Le fichier JaxRelentlessAssaultSpeed déclare BuffName=RelentlessBarrier et un effet défensif ; son nom ne prouve pas une accélération. Le fichier Debuff ne déclare pas de BuffName et contient IsDebugMode=true ; aucun nom manquant n’est inventé.

Cinq preloads et deux FX sont identifiés. Les FX ne sont ni décodés ni rendus. Dix références communautaires sont conservées séparément ; CharScriptJax.cs est vide. Les autres scripts approximatifs ne deviennent pas le serveur historique.

## Tests réellement exécutés

Deux simulations publiques Map10 : Jax contre Annie, avec ou sans achat initial de Dague 1042. Déplacement public vers le centre, attaques et Stop. Aucune injection de position, santé, XP, rang ou effet ; aucun PNJ supprimé. Les acteurs restent vivants et niveau 1.

Chaque cas comporte huit impacts ininterrompus, 120 ticks de pause, un nouvel impact, puis 90 ticks de suivi. Chaque impact est associé au windup de sa source, à sa cible et à son tick de libération ; aucun critique. La régénération de la cible est prise en compte pour isoler les dégâts.

| Cas | Cadence de base | Cadence observée | Impacts | Refus | Résidu maximal des dégâts |
|---|---:|---:|---:|---:|---:|
| base | 47 | 47 | 9 | 15 | 0.00001144 |
| dagger | 47 | 41 | 9 | 15 | 0.00001144 |

Les sept intervalles entre les huit premiers impacts valent tous 47 ticks sans objet et 41 avec Dague. La cadence ne change à aucun tick observé et reste identique au coup suivant la pause. Le contrôle Dague applique son bonus local de 15 % : arrondi de 47 / 1,15 = 41 ticks. Ce contrôle ne qualifie ni les arrondis ni le plafond historiques du passif.

Au total : 18 impacts ordinaires, 30 refus atomiques et 420 ticks de pause/suivi. Les dégâts correspondent à AD × 100 / (100 + armure), résidu inférieur à 0,002. Les autres ticks ne montrent que la régénération attendue. Les refus couvrent joueur inconnu, attaque de soi, slot invalide et Learn/Cast/CastAt pour les quatre capacités, avec snapshots inchangés.

La pause dépasse les 2,5 secondes annoncées, mais **aucun cumul n’étant présent, elle ne prouve pas l’expiration native**. Huit attaques n’acceptent pas davantage le plafond natif de six cumuls. Aucun R, troisième coup appris, autre niveau, changement de cible, annulation de windup, mort/réapparition, réseau ou rendu testé.

## Consommateurs

Les 22 points couvrent initialisation, commandes, statistiques, progression, refus de capacités, ordre des ticks, validité de cible, cadence/windup, attaques, impact physique, mitigation, régénération, achat et bonus d’objets, snapshots ; respawn et départ sont seulement des frontières statiques.

Le calcul courant de cadence prend croissance, objets et les modificateurs implémentés pour d’autres fonctions, sans contribution des cumuls de Jax. Les attaques ordinaires utilisent cette cadence et n’ajoutent pas d’état de passif Jax dans les chemins inspectés. Les snapshots de simulation ne constituent pas une preuve réseau.

## Identité et livraison

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-jax-passive-relentless-assault-probe.exe`. Taille : 6018048 octets. SHA256 : `472a02372d57fd1a7574c3cab3ad83600beb380a06967c4c1e36fda3ce0356ab`.

BUILD/RUN code 0, core courant non-test, verrou privé aligné sur les identités/checksums du verrou racine. Les 1 158 entrées core/ressources et la chaîne précédente sont inchangées. Les preuves V579, y compris son inspection initiale échouée et sa correction, sont conservées par identité ; elles ne sont pas présentées comme réexécutées ici.

Discovery, inspection, prepare, check, publish, audit et revue globale réussis. Ces étapes ont réussi. Le premier finisher a ensuite refusé un compteur hérité indiquant trois inconnues propres au lieu de quatre. Les quatre IDs et leurs objets avaient toujours été conservés dans les associations, registres et bases. La preuve publique corrige ce compteur à quatre, avec copie exacte de l’ancienne preuve dans PROOF_BEFORE_QUESTION_COUNT_CORRECTION.json. Les anciens PREPARED/CANDIDATE_CHECK/DELIVERY_AUDIT conservent leur compteur erroné trois ; QUESTION_COUNT_CORRECTION.json en documente la correction par relecture des quatre IDs. Le script initial et son échec sont conservés. Aucun runtime n’a été relancé pour cette correction documentaire. 72 associations invalides et quatre graphes invalides sont refusés. Trois fragments de trace enrichis, 42 212 autres inchangés.

Les lecteurs Store.task/copy_text/summary, dépendances et résolution de trace sont vérifiés dans les deux bases. Chacune conserve 42 603 autres lignes, 42 607 états manuels et 23 historiques ; quatre destinataires enrichis, intégrité et synchronisation idempotente vérifiées. Identifiants, hiérarchie et inconnues identiques en octets. Aucune case ni tâche acceptée automatiquement.

Revue globale fraîche : 42 215 exigences, 98 997 sources, 3 546 consommateurs ; 3 546 ancres exactes, aucune divergence. 26 189 inconnues ouvertes et 5 517 résolues conservées. Cette revue structurelle ne re-hashe pas tout le corpus et ne mesure pas l’avancement du jeu complet.

## Travail restant

- Qualifier coefficient @f1@, progression par niveau, déclencheur et portée des cibles admissibles.
- Établir cumul, rafraîchissement, durée et expiration, puis intégrer le bonus aux statistiques, à la cadence et au windup.
- Vérifier plafond, niveaux, objets, ralentissements, limites de vitesse, attaques annulées, changement de cible et reprise après pause.
- Qualifier mort/réapparition, disparition, déconnexion et fin de partie.
- Conserver le R et son troisième coup dans leurs tâches distinctes ; ne pas adopter le DDF défensif comme formule AS.
- Résoudre ou conserver explicitement la clé de tooltip manquante, les icônes de rôles distincts et les champs hérités.
- Qualifier séparément HUD, animations, VFX, audio et réseau.
- Conserver les anomalies antérieures, notamment le déplacement V564.

## Fichiers et reprise

Registres modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Reçu : `docs/reference_requirement_trace_sources/jax-passive-relentless_assault-links-v580.json`. Preuve : `docs/fidelity_jax_passive_relentless_assault_links_v580.json`. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts et journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision580.

Continuer SYS-01.2-02 depuis revision581_trace_review/REVIEW.json. JaxV580 publié/audité :3fiches,21natives et contexte R distinct,63associations,22points/44liens limités. Deux cas publics base/Dague,18impacts,30refus,420ticks de suivi;8attaques continues/cas gardent47/41ticks entre coups,puis cadence identique après120ticks. Passif AS non intégré. Texte2.5s/max6,@f1@ coefficient ouvert;champs3/7/11/15non formule. R troisième coup et DDF R/Q/E distincts;clé underscore manquante non aliasée;icônes personnage/buff différentes;Speed=RelentlessBarrier;NEWTABLEpc6limitelecteur;FXsans rendu. BUILD/RUN et delivery0. Finisher initial1 sur compteur hérité3 au lieu de4inconnues propres;les4étaient conservées. Preuve corrigée à4,anciennepreuve/AUDIT/finisher conservés,QUESTION_COUNT_CORRECTION vérifiée. Préserver INPUTS_BEFORE.previous_artifacts incluant V579 et son inspection initiale échouée,ainsi que la preuve initiale V580 et sa correction de compteur. Aucun statut/case/inconnu fermé. Poursuivre autre passif après inspection réelle,par exemple Jayce. Défaut déplacementV564 ouvert;goal actif.
