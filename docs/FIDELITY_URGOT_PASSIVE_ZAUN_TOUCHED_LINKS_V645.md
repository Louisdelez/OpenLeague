# SYS-01.2-02 — Urgot / Zaun-Touched Bolt Augmenter, V645

Date UTC 2026-10-26T23:22:32.033332+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue 4.20.1 distinct.

V645 Urgot / Zaun-Touched Bolt Augmenter :12 sources natives,36 associations,20 points actuels et40 liens de frontière. Réduction native de15%,avec durée contradictoire2,5s/3s conservée. Un projectile ordinaire touche Annie aux niveaux1/18 ;aucune baisse de ses dégâts sortants n’est observée dans les mesures API serveur,avant etaux temps0/74/75/89/90/91 après impact. Témoin Épuisement distinct :facteurs0,6 physique/magique et1 brut,expiration75ticks. 66mesures de dégâts,62refus,4207ticks,quatre déplacements sans réordre etdeux apports XP serveur explicites. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié,aucune case ou question fermée.

## Intégration et prérequis

Les fiches CH-Urgot-PASSIF-SOURCE, CH-Urgot-PASSIF-SIMULATION-CONTRAT et CH-Urgot-PASSIF-SIMULATION reçoivent les sources, preuves et instructions détaillées. SYS-01.2-02 reçoit la synthèse. Douze sources natives donnent 36 associations ; vingt points courants donnent 40 liens sur les deux fiches de simulation. Ces points sont qualifiés comme frontières ou témoin Épuisement, pas comme implémentation d’Urgot. Les lecteurs de sources antérieurs conservent leur rôle.

Les anciens liens, statuts, critères, dépendances et acceptations sont conservés. Trois questions propres et quatre dépendances restent inchangées. Les registres d’inconnues, d’identifiants et de hiérarchie sont identiques octet par octet. Les prérequis de phase, lot et tâche sont inclus dans le reçu ; cette analyse ne les déclare pas achevés et ne coche aucune case.

## Sources natives et divergence

La découverte vérifie 56 fichiers natifs et 24 références communautaires par taille/SHA du registre ; les natifs correspondent au manifeste RADS sélectionné. Huit candidats hors périmètre sont exclus explicitement. Douze fichiers utiles au passif et à son déclencheur Q sont reliés ; les autres restent du contexte dans la découverte conservée.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Urgot.inibin | 1930 | e2c187fdf86299529100f7337b4f0019f01fc6b1a80306c06b17f7d713877e55 |
| Urgot.ddf | 440 | a55cf52814d381ebff503edcfc8f83c9cc96f52f545d79adaca8df31aed985c7 |
| CharScriptUrgot.luaobj | 109 | 7dcb851111fac642e2e2f7703dd1b924d7e2e08f8db72204ddb3bedfabd1b5cb |
| CharScriptUrgot.preload | 229 | d694760262c2e593c1c5327c014f214f32802ed8b416e7d57a480c6ccda3f0af |
| UrgotEntropyDebuff.inibin | 50 | d73e732eae3728775eacbb98a1635e334244e4a2f9e6ffd66083341a20e5c81f |
| UrgotEntropyPassive.inibin | 992 | 9dce87ecfac2e73584e5dfe12491961164bbc0a29546c3c3f9eaaa9249cdedf1 |
| UrgotEntropyPassive.luaobj | 225 | 855e41f753ca448fd4cb1e08f9d69610aea5b72ca12c449a0252944e4522a684 |
| UrgotEntropyPassive.preload | 101 | ed5820f39b5ef54187f64dffaebb94abee83568343d3356c63cb690808d86389 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| UrgotHeatseekingMissile.inibin | 1146 | cd2cebbedb98eaef638e36078a2becaad0744bb123a0c3b68b895c8dbe440cf7 |
| UrgotHeatseekingHomeMissile.inibin | 1671 | 7e422f2bce5f2d5852df14d3903b2641514c27afe410889a9deb723ba4c8ada4 |
| UrgotHeatseekingLineMissile.inibin | 1382 | 7cfd9e2213f16addf4b23c4dbdeb44885be9ed39409c18a859695d0a6ab3b2b2 |

Urgot.inibin nomme UrgotEntropyPassive et Urgot_Passive.dds. Son Passive1Desc dit seulement que les dégâts des cibles attaquées sont réduits ; Passive1 et les six champs Passive1Level sont absents, pas zéro. Le Lua UrgotEntropyPassive nomme pourtant son buff UrgotEntropyDebuff. Ces identités restent distinctes et reliées par leur valeur exacte.

Les deux BuffData possèdent leur traduction anglaise exacte. Ligne 2844 du fontconfig : UrgotEntropyDebuff / Zaun-Touched Bolt Augmenter indique 15% pendant 2,5 secondes. Ligne 2845 : UrgotEntropyPassive / Degenerative Bolt indique 15% pendant 3 secondes, appliqué par les attaques et Acid Hunters. Ligne 4298 : la description de personnage indique à nouveau 15% pendant 2,5 secondes. La priorité effective et le producteur de durée restent inconnus ; aucune valeur n’est choisie silencieusement.

CharScriptUrgot.luaobj ne contient qu’un littéral de texture Teemo_EagleEye.dds. UrgotEntropyPassive.luaobj fournit le nom du debuff, l’icône et deux flags, sans corps serveur récupéré. Les 19 Lua inspectés n’ont pas de fonction enfant ; sept initialisations voisines de Q/W/R rencontrent la limite NEWTABLE du lecteur. Les preloads lient le CharScript à Entropy et ce dernier à urgotentropy_buf.troy ; cela ne démontre pas l’exécution ni le rendu. Le DDF contient huit entrées Q/E, dont seule PlasmaGrenade;f1=0,6 bonusAD est renseignée : ce n’est pas le taux du passif.

Le Q natif décrit des dégâts physiques avec CharTotalPhysical et un remboursement de la moitié du coût en cas de mise à mort. Les variantes Home et Line restent des contextes distincts de verrouillage/collision, sans qualification du Q complet. Le coefficient brut du fichier principal vaut environ0,85 ; sa présence ne permet pas à elle seule de conclure au calcul effectif de tous les composants du sort.

## Références communautaires et consommateurs

Le CharScript communautaire est vide. Le Q communautaire utilise un missile ciblé, calcule -20 + rang*30 + 0,85 AP puis inflige des dégâts physiques ; aucun AddBuff n’y est trouvé. L’échelle AP diffère du texte natif CharTotalPhysical. Les recherches bornées Urgot/Entropy dans les sources Rust et des deux alias Entropy dans les scripts C# ne donnent aucune occurrence. Elles ne prouvent pas une absence dans toute archive possible. Aucun C# n’a été exécuté ni promu comme règle native ou consommateur Rust.

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/summoners.rs:32 | pub fn join_with_summoners( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/summoners.rs:47 | pub fn cast_summoner_on( |
| crates/core/src/summoner_exhaust.rs:55 | pub(crate) fn cast_exhaust( |
| crates/core/src/summoner_exhaust.rs:38 | pub(crate) fn exhaust_damage_multiplier( |
| crates/core/src/summoner_exhaust.rs:23 | pub fn defense_reduction( |
| crates/core/src/summoner_exhaust.rs:30 | pub fn attack_speed_bonus_penalty( |

Le projectile ordinaire passe par basic_attack_hit et apply_damage. Le calcul de dégâts sortants inspecté applique exhaust_damage_multiplier : cette fonction réduit actuellement les dégâts physiques et magiques d’un champion sous Épuisement et laisse passer les dégâts bruts. Les réductions de défense et vitesse d’attaque d’Épuisement sont des effets distincts. Ces chemins actuels ne valent pas implémentation de Zaun-Touched Bolt Augmenter.

## Diagnostic réellement exécuté

Deux simulations Map10 utilisent Urgot et Annie, aux niveaux 1 puis 18. Quatre trajets publics Move, sans réordre, les placent à portée. Au niveau 18, deux appels serveur explicites award_experience(100000) donnent l’XP ; ce n’est pas une progression naturelle. Aucune position, PV, rang, or ou horloge n’est injecté directement.

Dans chaque cas, Urgot lance une commande publique Attack. Un projectile identifié touche Annie ; son dommage correspond au physique attendu, régénération soustraite. Stop est envoyé après cet impact et aucun projectile ne reste. La riposte est ensuite sondée par appels serveur apply_damage d’Annie vers Urgot avec raw=10, pour les types physique, magique et brut ; ce ne sont pas des attaques ordinaires de riposte. Les résistances courantes et l’absence de bouclier sont prises en compte.

| Fenêtre | Résultat attendu du chemin courant | Résultat observé |
|---|---|---|
| Avant l’attaque d’Urgot | dégâts de base après résistances | conforme |
| Après impact, ticks relatifs 0/74/75/89/90/91 | mesurer un éventuel facteur0,85 | facteur1 pour les trois types, aucun supplément de réduction observé |
| Épuisement distinct, ticks0/74 | facteur0,6 physique/magique,1 brut | conforme |
| Épuisement distinct, ticks75/76 | retour facteur1 | conforme |

La mesure immédiatement après impact établit un écart dans ce scénario. L’absence d’effet aux frontières 75 et90 ticks ne valide ni 2,5 ni 3 secondes pour un passif absent. La règle native d’Urgot concernant les dégâts bruts reste inconnue ; le passage des dégâts bruts sous Épuisement est seulement le comportement du témoin courant.

Chaque niveau comporte 33 sondes de dégâts serveur, soit 66 au total. Les 62 refus conservent le snapshot :27 par cas pour les commandes Urgot, quatre par cas pour les cibles invalides ou le délai d’Épuisement. Total :4207ticks, incluant les déplacements, deux impacts ordinaires et les fenêtres d’observation. Aucune mort de champion ni fin de partie observée.

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-urgot-zaun-touched-probe.exe ; 6072832 octets ; SHA-256 f31916c0b490114fd1149f3524da8a1f5d4ca939fd397f2b07b87d307bf3cf05. Le compilateur identifie F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Identités/checksums des dépendances alignés sur Cargo.lock ;1158 entrées moteur et ressources littérales identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification du plan et des bases

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | a7f3b7211cab235a3a2eebc52b240633ea6a2fc800436f077703e6654edb8da9 |
| RUN | 0 | 70344f8f35ef33016bd9fa3f9f6438268959c113d699a83246130e0f7b90b28d |
| prepare | 0 | 3113c89d9553b4ae11f8047b980859adf991787f89143adc772c6bb16ddcb5a4 |
| check | 0 | 70d2a696bfcdf6fbe02765bb0473eff4cc77dbb372326d56be52e53cb226d22c |
| publish | 0 | 560fffcc6602b9de8aec9f5efa4b2975d03fb0ebdcd37ecb3ac0ec68ece966d4 |
| audit | 0 | 261104be514240c465b0e73d98c74f6215166fbcd23a8f26f5b518d3d061d7d2 |

Les60 associations invalides sont refusées par la garde de livraison et quatre graphes invalides par le vrai validateur. Store.task/copy_text relit les instructions complètes des quatre destinataires ; sources, questions et dépendances sont résolues. Trois fragments courts changent,42212 restent identiques.

Deux bases vérifiées :quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Revue indépendante :5088 ancres et empreintes de fichiers consommateurs sans divergence,99255 sources enregistrées. Cette revue ne rehache pas toutes les sources historiques et ne représente pas un taux d’achèvement du jeu.

## Fichiers et conservation

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu :docs/reference_requirement_trace_sources/urgot-passive-zaun-touched-links-v645.json. Vérification :docs/fidelity_urgot_passive_zaun_touched_links_v645.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision645_Urgot_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision645_Urgot_passive_probe\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision645_Urgot_inspection/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision645_Urgot/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision646_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

Neuf copies privées de validation sont archivées en gzip vérifié après audit, avec comparaison du SHA décompressé avant retrait des seuls doublons bruts. Gain logique :2414272951 octets. Reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision645_Urgot/snapshot-archives/VERIFIED.json. Sources enregistrées, binaires, preuves et bases actives sont conservés. La restauration explicite F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision645_restore_validation_snapshots.py est disponible pour les lecteurs qui exigent les copies brutes ; elle n’a pas été exécutée après archivage.

## Manques et prochaine action

Restent ouverts :durée native effective, producteur et application du debuff, rafraîchissement, sources multiples, applicabilité aux dégâts bruts, ordre des réductions, boucliers/immunités/purge, mort/retour/déconnexion, cibles non championnes et familiers, Q réel et ripostes jouées normalement. Interface, icône, particule, animation, audio, client graphique, réseau et serveur historique non exécutés ici. Les trois questions propres restent ouvertes.

Continuer SYS-01.2-02 depuis revision646_trace_review/REVIEW.json. V645 Urgot publié/audité :12 sources,36 associations,20 points/40liens ;deux projectiles ordinaires niveaux1/18,sans réduction des dégâts sortants sondés par API serveur. Témoin Épuisement distinct0,6/0,6/1 puis retour1 au tick75 ;66sondes,62refus,4207ticks,quatre déplacements sans réordre,deux apports XP. Durée native2,5s contre3s non arbitrée,politiques de dégâts bruts/refresh/lifecycle ouvertes,Q communautaire AP différent du texte totalphysique natif. Prochain lot :Varus PASSIF Living Vengeance,contrat encore au chargeur partagé ;inspecter mises à mort etvitesse d’attaque avant diagnostic. Snapshots privés V645 en gzip vérifié,restauration explicite via revision645_restore_validation_snapshots.py pour les lecteurs des copies brutes. Ne pas dupliquer les lots précédents ;goal actif.
