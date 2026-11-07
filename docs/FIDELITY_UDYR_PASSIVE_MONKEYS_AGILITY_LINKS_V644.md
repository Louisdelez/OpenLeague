# SYS-01.2-02 — Udyr / Monkey's Agility, V644

Date UTC 2026-10-26T23:03:11.184329+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue 4.20.1 distinct.

V644 Udyr / Monkey's Agility : 15 sources natives reliées aux trois fiches,45 associations,13 points actuels et26 liens de frontière. Texte natif : +10% vitesse d’attaque et +5 déplacement pendant5secondes,maximum3cumuls à l’entrée en posture. Quatre postures à cinq rangs ;coûts47/44/41/38/35 et délais6secondes. Marqueur permanent etbonus temporaire distincts. Aux niveaux1/18,34 commandes sont refusées sans mutation ;les postures ne peuvent pas être activées. Témoin Garen Q :345→455,6→345 de déplacement,expiration tick45 sur46ticks ;deux refus supplémentaires. Un apport XP serveur explicite,aucune injection directe d’état. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié,aucune case ou question fermée.

## Résultat intégré

Trois fiches CH-Udyr-PASSIF-SOURCE, CH-Udyr-PASSIF-SIMULATION-CONTRAT et CH-Udyr-PASSIF-SIMULATION reçoivent les sources, preuves et instructions détaillées. SYS-01.2-02 reçoit la synthèse. Quinze sources natives donnent 45 associations ; treize points de code donnent 26 liens sur les deux fiches de simulation. Ce sont des frontières vérifiées, pas une implémentation du passif. Les lecteurs de sources antérieurs conservent leur rôle.

Statuts, critères, dépendances, anciennes preuves et acceptations sont conservés. Trois questions propres et quatre dépendances restent inchangées ; aucune case cochée. Les registres des inconnues, identifiants et hiérarchie sont identiques octet par octet. Les prérequis de phase, lot et tâche sont conservés dans le reçu ; cette analyse ne les déclare pas achevés.

## Sources et valeurs natives

La découverte vérifie 93 fichiers natifs et 33 références communautaires par leurs tailles et SHA du registre ; les fichiers natifs correspondent au manifeste RADS sélectionné. Huit candidats hors périmètre sont exclus explicitement. Quinze fichiers utiles au passif ou à son déclenchement par les postures sont reliés ; les 78 autres restent du contexte voisin dans les observations complètes.

| Ressource native reliée | Octets | SHA-256 |
|---|---:|---|
| Udyr.inibin | 2178 | 09be026ba809cfcd89b3e8bf3270cb11e1e8945179b24df3384c25a4eb8c97c1 |
| Udyr.ddf | 234 | c7ceb830f756528be823c7d71e95c2e752bae42cefafa769bb8a120ed447a93a |
| CharScriptUdyr.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptUdyr.preload | 1522 | 1038425f3b38be8532696a3a5f1400bdbc3a16350435b5e5fc01cd40fde16095 |
| UdyrMonkeyAgility.luaobj | 387 | 0621cace2e83aa67589b61772e564dd7b7abf5460efdd1619439d6f10f54a0cd |
| UdyrMonkeyAgility.preload | 179 | 8bab2ef50c77abd6a0302e2cf4704fcfeddc0a9861d27696e566b45e73398ca4 |
| UdyrMonkeyAgilityBuff.inibin | 60 | 21b31077dc120c8b5d63f7994eb03ca3635c432684ca0c73c307c5803310fd0c |
| UdyrMonkeyAgilityBuff.luaobj | 329 | d8213b3f1fce8af94482a93b3d6e27c386f9213f1f4c1242aa95fdf1a5ecb22d |
| UdyrMonkeyAgilityBuff.preload | 93 | 9b50b3a8dd739c825d2c8b077830473c1c1ea98adea991a9fe278ff6a33145df |
| UdyrPassiveBuff.inibin | 47 | fe493bc279c479cd6f38832068ac81cf4ce75e333ce6e84388e82bd3bdb3e94e |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| UdyrTigerStance.inibin | 1315 | a43d258690a0258b43352369248066d103dca7602e49e2b557cdf7c21df6d2f9 |
| UdyrTurtleStance.inibin | 1274 | 376fb950231a80d63d28f4a7652967fb18af89d28345fb3d708016846dd56029 |
| UdyrBearStance.inibin | 1202 | e11e8dcd26d6894d73093ea6b65d8092fb5d691fe9fab430c1916283b525fef6 |
| UdyrPhoenixStance.inibin | 1300 | 6e8cfd308228d017edee2559098c5fa1cceed1846a5c1225f91b22a9e30fe56c |

Udyr.inibin indique Passive1LuaName=UdyrPassiveBuff et l’icône Udyr_MonkeysAgility.dds. Les clés localisées du personnage et les deux BuffData aboutissent exactement aux textes anglais. À la ligne 2826 du fontconfig, le marqueur décrit 10% de vitesse d’attaque et 5 unités de déplacement pendant 5 secondes, jusqu’à 3 cumuls à l’entrée en posture. La ligne 2825 décrit l’effet temporaire ; la description de personnage est à la ligne 4296. Passive1, Passive1Desc et les six champs Passive1Level sont absents, pas zéro.

MaxLevels=[5,5,5,5]. Les quatre postures Tiger, Turtle, Bear et Phoenix ont les mêmes ManaCost1..5=47/44/41/38/35 et Cooldown1..5=6 secondes. Les champs de rang 6 sont absents. Le délai partagé entre postures et les portes d’apprentissage ne sont pas prouvés par ces seuls champs. Appliquer à Phoenix les trois rangs d’un ultime classique serait une supposition non autorisée.

CharScriptUdyr.luaobj contient une initialisation vide. UdyrMonkeyAgility.luaobj déclare BuffName=UdyrPassiveBuff, PersistsThroughDeath=true, NonDispellable=true et une texture BlindMonk_FistsOfFury.dds. UdyrMonkeyAgilityBuff.luaobj porte son propre nom et la texture Udyr_MonkeysAgility.dds, sans flag de persistance parmi les littéraux lus. Ces objets restent distincts : la persistance du marqueur ne qualifie pas la persistance des cumuls temporaires.

Les 36 Lua inspectés n’ont pas de fonction enfant ; 22 initialisations de contextes voisins rencontrent la limite NEWTABLE du lecteur de littéraux. Les fichiers directs du passif sont analysés séparément et ne fournissent pas le corps serveur du mécanisme. Les preloads relient le marqueur au buff temporaire, à udyrbuff.troy et à une particule audio Spirit Guard ; ce sont des dépendances, pas une validation de rendu ou de son. Le DDF contient quatre entrées Tiger, dont deux coefficients AD (.15 et 1.2/1.3/1.4/1.5/1.6), sans producteur de cumuls du passif.

## Communauté et code actuel

Le CharScript communautaire est vide. Les scripts Q/W/E/R retirent les autres marqueurs de posture puis ajoutent le leur pour 5 secondes. Ils ne constituent pas le producteur du passif. Aucune occurrence UdyrMonkeyAgility ou UdyrPassiveBuff n’est trouvée dans le sous-arbre C# inspecté ; aucune occurrence Udyr ou MonkeyAgility dans les sources Rust du moteur inspectées. Ce sont des recherches bornées, pas une preuve d’absence dans toute archive possible. Les commentaires communautaires ne sont ni une exécution ni une règle native acceptée.

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
| crates/core/src/movement.rs:53 | pub fn movement_speed( |
| crates/core/src/movement.rs:38 | fn effective_speed_with_slow( |
| crates/core/src/movement.rs:19 | pub fn soft_cap( |

next_rank limite actuellement la progression prise en charge à Garen, Annie, Trundle et Ezreal. Les chemins cast et cast_at refusent Udyr. Les statistiques courantes utilisent la croissance, les objets et des bonus de champions déjà implémentés ; les routes de déplacement et de vitesse d’attaque ne montrent pas de producteur Udyr dans le périmètre inspecté. Les points génériques liés ici ne sont pas promus en implémentation de Monkey's Agility.

## Diagnostic exécuté et résultats

Le vrai moteur non-test est compilé avec le verrou de dépendances du projet. Deux instances Udyr sont examinées aux niveaux 1 et 18. Le niveau 18 provient d’un appel serveur explicite award_experience(100000), pas d’une progression naturelle ; aucun état de PV, mana, rang, position ou horloge n’est injecté directement.

Pour chaque niveau : les quatre Learn refusent « champion skill progression not implemented », les quatre Cast refusent « champion spell not implemented », les quatre CastAt refusent « champion ground spell not implemented ». Cinq frontières invalides supplémentaires sont vérifiées : les trois commandes avec emplacement 4, joueur inconnu, point NaN. Les 34 refus préservent le snapshot et les statistiques dérivées. Les rangs restent à zéro ; la vitesse de déplacement reste 345, et la cadence de base observée vaut 46 ticks au niveau 1, 32 au niveau 18.

Attendu de l’état actuel : refus explicites sans mutation. Observé : conforme. Attendu pour pouvoir vérifier le passif : une posture réellement activée. Observé : activation indisponible. Aucune durée d’Udyr, aucun rafraîchissement et aucun cap de cumul ne sont donc présentés comme testés.

Un témoin distinct utilise Garen Q par commandes publiques Learn puis Cast : déplacement 345 → 455.600006 → 345, retour à la valeur de base au tick 45, observation sur 46 ticks. Deux refus supplémentaires vérifient Q non appris puis son délai actif, sans mutation. Ce témoin valide l’observation d’un bonus temporaire courant ; il n’est ni une posture Udyr ni une preuve de durée historique native. Il ne teste pas un bonus de vitesse d’attaque d’Udyr.

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-udyr-monkeys-agility-probe.exe ; 6010880 octets ; SHA-256 16d599de2aae5df4d28cf3eb2e320ddb55e932acf653a3247b43c5c9e350f559. L’artifact compilateur pointe sur F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false ; identités/checksums de dépendances conformes au Cargo.lock racine. Les 1158 entrées du moteur et ressources littérales sont identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de l’intégration

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | fe4bc3d49a0117710478e750751c21fadc283ffbe853d3fe5d94e73c1ad27a30 |
| RUN | 0 | afc0558d7a5514e1e9c42cae730c70484f189b207454e8eeca40be906a1474cf |
| prepare | 0 | 7021b79751256563259093b0346e7609202ef985950ce89b44877afdc816ce74 |
| check | 0 | ae7eb022753b2acad4429804847dd5faee4470c285935ddefcc4e34855474f9c |
| publish | 0 | 09216e71476e34c7a06a51dba89fed98decced0f0778ef6c9b8f7e76b4e75744 |
| audit | 0 | 02e86a064e2e2b7a9047b111e58d0a1dae03f3fa516bb797d349ea0634af8c55 |

Les 60 associations volontairement incorrectes sont refusées par la garde de livraison ; quatre graphes incorrects sont refusés par le validateur réel. Store.task/copy_text relit les quatre tâches cibles avec leurs instructions complètes, puis la résolution des sources, questions et dépendances. Trois fragments courts changent et 42212 restent identiques.

Les deux bases sont contrôlées : quatre destinataires actualisés, 42603 autres lignes de catalogue, 42607 états manuels et 23 historiques conservés. La synchronisation ordinaire est idempotente. La revue indépendante confirme 5068 ancres et empreintes de consommateurs sans divergence, sur 99251 sources enregistrées. Elle ne rehache pas l’intégralité des sources et ne représente pas un taux d’achèvement du jeu.

## Livrables, conservation et limites

Fichiers modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json ; docs/reference_requirement_trace_sources/udyr-passive-monkeys-agility-links-v644.json ; docs/fidelity_udyr_passive_monkeys_agility_links_v644.json ; runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision644_Udyr_discovery\OBSERVATIONS.json. Diagnostic : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision644_Udyr_passive_probe\OBSERVATIONS.json. Inspection destinée au plan : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision644_Udyr_inspection_scoped/OBSERVATIONS.json. L’inspection complète initiale est conservée avec son SHA ; seul l’extrait de native_spells_420 utilisé dans le plan a été limité au Garen Q du témoin, au lieu de recopier tous les sorts. Aucune preuve ni source n’a été retirée. Audit : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision644_Udyr/DELIVERY_AUDIT.json. Revue globale : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision645_trace_review\REVIEW.json. Une lecture exploratoire visait garen_spells.json, inexistant ; le consommateur réel native_spells_420.json a ensuite été identifié et utilisé.

Neuf copies de validation privées ont été archivées en gzip après audit, avec SHA du contenu décompressé vérifié avant retrait des seuls doublons bruts. Gain logique : 2406016011 octets. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision644_Udyr/snapshot-archives/VERIFIED.json. Sources enregistrées, binaires, preuves et bases actives conservés. Restauration explicite disponible dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision644_restore_validation_snapshots.py pour les lecteurs qui exigent les copies brutes ; cette restauration n’a pas été exécutée après archivage.

Restent ouverts : producteur natif des cumuls, expiration commune ou indépendante, rafraîchissement et quatrième activation, délai partagé et portes de progression, distinction des bonus de posture, calcul avec objets/ralentissements/plafonds, mort/retour/purge/déconnexion, implémentation actuelle des postures et du passif, scénarios nominaux et réseau. Interface, icônes, effets, animation, audio et client graphique ne sont pas exécutés ici. Les trois questions propres restent ouvertes.

Continuer SYS-01.2-02 depuis revision645_trace_review/REVIEW.json. V644 Udyr publié et audité :15 sources natives,45 associations,13 frontières et26 liens ;34 refus publics niveaux1/18,postures non activables ;témoin Garen Q distinct,46ticks/deux refus. Native 10%AS,+5MS,5s,max3 ;quatre postures à cinq rangs etcoûts47/44/41/38/35 ;marqueur permanent différent du bonus temporaire. Cumul,rafraîchissement,expiration,mort etglobal cooldown restent ouverts. Prochain lot :Urgot PASSIF Zaun-Touched Bolt Augmenter,contrat encore au chargeur partagé ;examiner sources etréduction de dégâts actuelle avant diagnostic. Ne pas dupliquer les lots précédents. Snapshots V644 en gzip vérifié ;restauration explicite via revision644_restore_validation_snapshots.py pour les lecteurs de copies brutes. Bases etpreuves conservées ;goal actif. Prélecture Urgot : fontconfig_en_GB lignes2844 et4298 disent2,5s,ligne2845 dit3s ;conserver cette divergence etétablir les alias effectifs. Le chemin de dégâts courant appelle exhaust_damage_multiplier,qui ne doit pas être assimilé au passif Urgot.
