# SYS-01.2-02 — Varus / Living Vengeance, V646

Date UTC 2026-10-26T23:47:25.480836+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue 4.20.1 distinct.

V646 Varus / Living Vengeance : 15 sources natives, 45 associations, 19 points actuels et 38 liens de frontière. Texte natif : champion éliminé ou assistance, 6 secondes ; sbire ou monstre éliminé, 3 secondes. Valeurs f1/f2 non résolues. Huit scénarios API serveur aux niveaux 1/18 : récompenses effectives mais aucun bonus de cadence observé ; 46/30 ticks selon le niveau. Témoin Trundle W distinct : bonus 20%, expiration 240 ticks. 146 refus sans mutation, 25689 ticks, quatre apports XP serveur explicites. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ou question fermée.

## Résultat intégré et prérequis

Les fiches CH-Varus-PASSIF-SOURCE, CH-Varus-PASSIF-SIMULATION-CONTRAT et CH-Varus-PASSIF-SIMULATION reçoivent les liens, preuves et instructions détaillées. SYS-01.2-02 reçoit la synthèse. Quinze sources natives donnent 45 associations ; dix-neuf points courants donnent 38 liens sur les deux fiches de simulation. Ce sont des frontières de traitement ou un témoin distinct, pas des implémentations du passif Varus. Les anciens lecteurs conservent leur rôle.

Les prérequis de phase, lot et tâche sont conservés dans le reçu. Trois questions propres et quatre dépendances restent ouvertes ou inchangées ; cette analyse ne déclare pas ces prérequis achevés. Statuts, critères et acceptations antérieurs sont conservés. Les registres d’inconnues, d’identifiants et de hiérarchie restent identiques octet par octet.

## Sources et valeurs non résolues

La découverte vérifie 109 fichiers natifs contre taille/SHA du registre et appartenance au manifeste RADS sélectionné :33 INIBIN,48 Lua,26 preloads,un DDF et le fontconfig. Quatre candidats hors périmètre sont exclus. Les 38 références communautaires sont identifiées séparément. Quinze fichiers utiles au passif sont reliés ; les autres restent du contexte.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Varus.inibin | 3179 | 89384fcbf23e77069070de2949afa3f54f17cc703eee4a7ef43992193dd77336 |
| Varus.ddf | 354 | e129d1667f69740247a824d470a73da5575c4eb9cd3a84669f4f4d86111cdbc0 |
| CharScriptVarus.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptVarus.preload | 274 | f220a646f3245ec4affb085839d1e43be80a81e0d53a597cfb57f2141f7e49c8 |
| VarusPassiveBuff.inibin | 1098 | edb9fb65d9a0c31f22333cf4b41d301be7e4f15badb8def0ac9762950c58e74a |
| VarusPassiveBuff.luaobj | 430 | b0d5afc4906a0875ab2c0f40de05d899c0fed205f4d1a2d738b438420ef1c2b6 |
| VarusPassiveBuff.preload | 306 | 3dfd1a0683e2af3f45d0001441e8f456038e59898454a2f8f5a623fc267e8cff |
| VarusPassiveBuffDisplay.inibin | 1119 | b8d5707eb9187b100a7fe75f5605e252005b22dfb5b64437613a712baf3c1fdf |
| VarusPassiveBuffDisplay.luaobj | 478 | 1efaf933209a37a33e15ddbdd7d8c269777c6f7263d6919e85014e4f4d55783e |
| VarusPassiveBuffDisplay.preload | 327 | bd9325d4d9d6d6bfb15ebd91bbd3f4565f13a3f5c9ac0a43e0c27826a66d8aab |
| VarusPassiveBuffDisplayMinion.inibin | 1071 | 4e461d6b16a55ad63c9629e5b7ea0691cd41ba61fec59fa51bed580b5f0767fa |
| VarusPassiveBuffDisplayMinion.luaobj | 484 | 07ea5b1c8fd76df66fa9893f38cd4d18698c7fc80863d5fa7c1cf5ae9069b2df |
| VarusPassiveBuffDisplayMinion.preload | 263 | 29e3634f5f22f91ef8bed16fd7bca8fd9127d721b5e87a90e9013554af779962 |
| VarusPassiveTracker.luaobj | 301 | 81dcca8529bf68fc2cb62594df121988c23e855dc7b4768137a68b615f9851f2 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Varus.inibin nomme VarusPassiveBuff et VarusPassive.dds. PassLev1Desc1 vise la traduction Varus. Passive1Desc contient pourtant une description d’Ashe et de critique : cette anomalie est conservée, sans en déduire le passif. Passive1 et Passive1Level1..6 sont absents, pas zéro.

L’INIBIN VarusPassiveBuff lie exactement la traduction game_buff_tooltip_VarusPassiveBuff, ligne2853 : champion tué ou assistance → @f2@% de vitesse d’attaque pendant6secondes ; sbire ou monstre tué → @f1@% pendant3secondes. La description de personnage confirme un bonus plus grand contre un champion. **Les producteurs et valeurs effectives f1/f2 restent inconnus.** Le DDF ne fournit que trois coefficients Q/E parmi huit lignes :Q totalAD1,0/1,6 et E bonusAD0,6. Aucun n’est promu comme valeur du passif.

Les SpellData des trois marqueurs contiennent le texte Disintegrate et des champs de sort hérités. Les valeurs80/125/170/215/260 ou le coefficient0,6 ne deviennent pas un bonus de vitesse d’attaque. BuffData.DynamicTooltip est présent pour Buff et Display, absent pour DisplayMinion ; aucune réécriture automatique d’alias n’est effectuée.

Les CharScripts natif et communautaire sont vides. Les48 Lua n’ont pas de prototype de fonction enfant. Le lecteur complet rencontre31 limites NEWTABLE, dont les trois marqueurs du passif au PC18. L’inspection supplémentaire récupère uniquement les affectations littérales aux PC0..17 sur une copie d’analyse terminée par le RETURN original. Les fichiers restent inchangés ; la table finale et le serveur ne sont ni interprétés ni exécutés.

Ce préfixe nomme VarusPassiveBuff avec texture12.dds pour le marqueur. Les deux fichiers Display et DisplayMinion nomment tous deux VarusPassiveBuffDisplay, avec icône VarusPassive.dds et particules différentes VarusPassive.troy / VarusPassiveMinion.troy. Les flags de métadonnées ne qualifient pas le cycle de vie réel du bonus. VarusPassiveTracker déclare VarusQ et SpellToggleSlot=1 : son nom ne prouve pas un producteur de Living Vengeance. Les preloads relient les marqueurs et particules de l’arc ; aucun rendu n’est validé.

## Consommateurs actuels et références communautaires

Les recherches bornées Varus/VarusPassive dans le Rust actuel et VarusPassiveBuff/VarusPassiveTracker dans les scripts C# ne trouvent aucune occurrence. Elles ne prouvent pas une absence universelle dans toutes les archives. Le CharScript C# est vide ; les JSON communautaires sont des références de données, pas un corps serveur original ni une implémentation Rust.

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/world.rs:355 | pub(crate) fn damage_unit( |
| crates/core/src/champion_kills.rs:26 | pub(crate) fn record_champion_contribution( |
| crates/core/src/champion_kills.rs:32 | pub(crate) fn reward_champion_death( |
| crates/core/src/annie_r.rs:20 | pub(crate) fn combat_owner( |
| crates/core/src/trundle_w.rs:93 | pub(crate) fn cast_trundle_w_at( |
| crates/core/src/trundle_w.rs:89 | pub fn attack_speed_bonus( |
| crates/core/src/world.rs:185 | pub fn enable_map10( |
| crates/core/src/world.rs:507 | pub(crate) fn advance_world( |

Le chemin de dégâts attribue contributions, morts et récompenses. Le calcul courant de cadence applique croissance, objets, Trundle W, Ezreal W/passif et Épuisement ; aucun terme Varus n’apparaît dans ce chemin inspecté. Le système de récompenses et les politiques d’assistance actuelles restent des reconstructions documentées. Leur existence ne qualifie pas le passif.

## Diagnostic réellement exécuté

Huit simulations isolées sur la navigation Map10 réelle :aux niveaux1 et18, élimination de champion, assistance de Varus avec élimination par Garen, élimination de monstre, élimination de sbire. Les unités apparaissent par3000ticks ordinaires. Quatre appels serveur explicites award_experience(100000) préparent le niveau18 ; il ne s’agit pas d’une progression naturelle. Aucune injection directe des positions, PV, rangs ou horloge.

Les dégâts non létaux et létaux utilisent apply_damage côté serveur à distance des positions de naissance. Ce sont des diagnostics de chemins de mort/récompense, **pas des attaques ordinaires ni une validation de ciblage ou de portée**. Le score et l’événement de kill/assist sont contrôlés ; pour les unités, la mort et l’augmentation d’or sont contrôlées. Les sbires tués à distance ne donnent pas d’XP au propriétaire hors rayon dans ces cas. La contribution d’assistance précède immédiatement le kill allié : les limites de fenêtre d’assistance ne sont pas testées.

| Cas | Attendu pour vérifier le chemin | Observé |
|---|---|---|
| Champion tué par Varus | mort et crédit de kill | présents aux deux niveaux |
| Contribution Varus puis kill Garen | crédit d’assistance Varus | présent aux deux niveaux |
| Monstre ou sbire tué | mort et récompense d’or | présentes aux deux niveaux |
| Avant, après non-létal et après mort | mesurer un bonus éventuel de cadence | aucun bonus ;46ticks niveau1,30ticks niveau18 |
| Témoin Trundle W appris/lancé publiquement | bonus20%, puis expiration | cadence45→38→45, expiration240ticks |

La cadence est mesurée après événement aux ticks relatifs0/89/90/91/179/180/181, avec comparaison au calcul de base et croissance du moteur courant. L’absence de bonus ne valide ni les valeurs historiques ni une expiration3/6secondes. La cadence calculée est observée ; aucun rythme de tirs successifs n’est exercé.

Les146 refus conservent les snapshots :96 commandes Varus Learn/Cast/CastAt,48 dégâts invalides ou cibles déjà mortes,2 refus Trundle W (non appris/délai). Les commandes conservent aussi la cadence dérivée. Les dommages nuls ne modifient pas le snapshot. Les contributions non létales restent sans bonus de cadence. Total25689ticks, dont241 pour le témoin distinct. Quatre apports XP explicites ; huit événements létaux provoqués par API ; aucune fin de partie.

Binaire :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-varus-living-vengeance-probe.exe ;6073856octets ;SHA-256 23c414eca110dc7f790b20d9a0121f7cf5159043e9ee0db1a1a59e3739103b72. Le compilateur identifie F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Les identités/checksums des dépendances correspondent au Cargo.lock racine ;1158 entrées moteur et ressources littérales sont conservées avant/après. Aucun code de jeu ni asset modifié.

## Contrôles exécutés et conservation du plan

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 97e4f5678cce9bdb746ffc6a72185fe14d1118ec2a0f493df08ecc44d5d33f49 |
| RUN | 0 | a625b29bb5c09be9f8d472efd7cf8b4a0fd035cd980edded66f2b17e85f74d98 |
| prepare | 0 | 3bb6c52f547ec35ae13dafd9299d0ef5ac8eda2d7de46df2555f47313d3adf94 |
| check | 0 | 70c7e7e382805210447fb5c497168eb50fa1ae553965e4dcf57798f39eb42d10 |
| publish | 0 | c72fb63e94a1667dcc2664c92865271e3bad02dc522e11c29dae90cd396790f1 |
| audit | 0 | 7b7df27dce8925fd382d1f93638ab9a1bec8c5a22d613c828cde706cb8a1171f |

Découverte, inspection et reprise :code0. Une recherche exploratoire sur le nom supposé items.rs a échoué ; le vrai calcul a été trouvé dans progression.rs et inspecté. Aucun fichier de jeu n’a été créé pour remplacer ce chemin absent.

La garde de livraison refuse60 associations falsifiées ; le validateur réel refuse quatre graphes invalides. Store.task/copy_text relit les instructions complètes des quatre destinataires et résout sources, questions et dépendances. Trois fragments courts changent ;42212 restent identiques.

Les deux bases conservent42603 autres lignes de catalogue,42607 états manuels et23 historiques ;quatre destinataires sont actualisés. Intégrité vérifiée et synchronisation Store idempotente. Revue indépendante :5107 ancres et empreintes de consommateurs sans divergence ;99259 sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers modifiés et preuves

Registres :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu :docs/reference_requirement_trace_sources/varus-passive-living-vengeance-links-v645.json. Vérification :docs/fidelity_varus_passive_living_vengeance_links_v645.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Anomalie de nommage :les deux chemins de reçu/vérification et la clé de contexte des tâches conservent par erreur le suffixe v645. Le lot, ses schémas, résultats et notices sont V646. Ces chemins effectifs sont conservés pour préserver les preuves et associations déjà publiées ; le présent rapport et la reprise pointent vers les fichiers réels. Il ne s’agit pas d’une preuve Urgot réutilisée ni d’un contrôle Varus antérieur.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision646_Varus_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision646_Varus_passive_probe\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision646_Varus_inspection/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision646_Varus/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision647_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20 ; les anciennes preuves restent conservées.

Neuf copies privées de validation sont archivées après audit en gzip vérifié, avec SHA décompressé identique avant retrait des seuls doublons bruts. Gain logique :2423382349octets. Reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision646_Varus/snapshot-archives/VERIFIED.json. Sources enregistrées, binaires, preuves et bases actives restent intacts. Restauration explicite :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision646_restore_validation_snapshots.py ; non exécutée après archivage.

## Manques et prochaine action

Restent ouverts :f1/f2 et variation selon niveau, producteur et application du bonus, catégories exactes de cibles et d’assistances, rafraîchissement/recouvrement, cumuls et ordre des bonus/réductions, plafonds et arrondis historiques, mort/retour/déconnexion, familiers, soins/boucliers, attaques réelles et changements de cadence pendant un tir. Rendu, icônes, particules, animations, audio, réseau et serveur historique ne sont pas validés. Les trois questions propres demeurent ouvertes.

Continuer SYS-01.2-02 depuis revision647_trace_review/REVIEW.json. V646 Varus publié et audité :15 sources natives,45 associations,19 points actuels/38 liens. Huit cas API serveur kill/assist/monstre/sbire niveaux1/18,sans bonus de cadence ;146 refus,25689ticks,quatre apports XP explicites. Témoin Trundle W distinct45→38→45,expiration240ticks. f1/f2 inconnus ;durées natives6s/3s ;préfixes Lua qualifiés seulement avant NEWTABLE,Tracker décrit Q ;récompense serveur ne prouve pas attaque ordinaire. Prochain lot :Vayne PASSIF Night Hunter,contrat encore au chargeur partagé ;inspecter sources de détection/direction/portée et vitesse de déplacement avant diagnostic. Conserver les preuves précédentes. Snapshots V646 archivés en gzip vérifié ;restauration explicite via revision646_restore_validation_snapshots.py pour les lecteurs de copies brutes. Goal actif.
