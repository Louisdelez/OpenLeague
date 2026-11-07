# Liaison des donnees de progression natives aux consommateurs OpenLeague 4.20

Date de l'audit : 2026-11-02  
Goal : SYS-01.2-02 — relier les exigences aux sources natives et aux consommateurs actuels.  
Lot : associations existantes SYS-04.1-01 (croissance de Garen) et SYS-04.1-06 (seuils XP Map10).  
Nature : audit statique des liens de données. Ce document ne qualifie pas toute la progression comme fonctionnelle ou fidèle au serveur historique.

## SYS-04.1-01 — croissance de Garen

### Source et import

Le registre docs/reference_stat_sources/stat-links.json associe les champs natifs HPPerLevel, MPPerLevel, DamagePerLevel, ArmorPerLevel, SpellBlockPerLevel et AttackSpeedPerLevel à DATA/Characters/Garen/Garen.inibin. Son reçu identifie la source fournie à D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Garen\Garen.inibin, 1 065 octets, SHA-256 17268558d84561f9b59e89a312dfdf2888971c9202a7abc0a7a6f1c97b0105d5, MD5 cb7169437a37ad05157265c3596e88aa. Le manifeste retenu associe le membre DATA/Characters/Garen/Garen.inibin au projet lol_game_client 0.0.1.7 et au même MD5/taille.

Le reçu existant distingue explicitement ces taux écrits dans la ressource du coefficient de croissance local 0.685/0.035 : la ressource native ne prouve pas, à elle seule, la formule du serveur. Le registre rapporte huit valeurs de croissance Garen comparées aux nombres importés avec une tolérance 1e-5; cette comparaison est un résultat hérité et n'a pas été rejouée.

### Consommateur actuel constaté sur F

data/4.20/champion_growth_420.json (37 058 octets, SHA-256 46026BF747CEFEDE84DD190DC2C6B25EAC1F738EBD4A4A22B75BD51B2E2D2710) contient notamment les valeurs Garen suivantes : vie 96, mana 0, dégâts 3.5, armure 2.7, résistance magique 1.25, vitesse d'attaque 2.9 %, régénération de vie 1.568 et croissance de régénération de vie 0.1.

crates/core/src/lib.rs charge ce JSON avec include_str! dans Simulation.growth. Le fichier courant crates/core/src/progression.rs (8 632 octets, SHA-256 eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766, identique à l'empreinte de code du registre) consomme ensuite l'entrée du champion :
- growth_total borne le niveau entre 1 et 18 et calcule le facteur 0.685*n + 0.035*n*(n+1)/2;
- Simulation::stats l'applique aux dégâts, à l'armure, à la résistance magique, à la vie max et à la vitesse d'attaque, entre autres champs;
- attack_damage_components réutilise ce facteur pour le dégât d'attaque.

Résultat attendu / observé : le manifeste sélectionné doit contenir la ressource native identifiée et le runtime actuel doit atteindre les nombres importés par le chemin Simulation.growth → progression::stats/attack_damage_components. L'appartenance au manifeste est matches_selected_project_manifest dans le registre; le chemin d'inclusion et les appels sont présents dans le code courant. Le chemin de copie data/4.20/recovered_client_assets/DATA/Characters/Garen/Garen.inibin n'existe pas sur F, vérifié lors de cet audit; l'identité et la comparaison des octets natifs reposent donc sur le reçu préexistant, pas sur une relecture du binaire D ce tour-ci.

Limites / reprise : l'arithmétique historique exacte, l'arrondi float32, l'ordre des modificateurs et les unités des régénérations restent à qualifier. Le reçu note que certaines requêtes BaseHPRegen/BaseMPRegen et alias n'ont pas retourné de valeur; elles ne sont ni des discordances ni une preuve d'absence globale. La présence d'un chemin de données et d'un consommateur statique ne valide pas son exécution dans une partie.

## SYS-04.1-06 — seuils d'expérience Map10

### Source et import

Le registre identifie LEVELS/Map10/ExpCurve.inibin à D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\Map10\ExpCurve.inibin, 200 octets, SHA-256 88c26d8999f8e95a6b2bc8e453a5a4186229ea4ef88f3e8e37e8c1dde8a22561, MD5 855ba80470b478d61fddec62235c7cbf. L'appartenance rapportée correspond au membre LEVELS/Map10/ExpCurve.inibin de lol_game_client 0.0.1.7, payload 0.0.0.172, mêmes taille et MD5.

Le sélecteur du reçu est limité aux valeurs EXP pour les niveaux 2 à 18. Il rapporte 17 correspondances numériques avec la table importée. Level1 est absent et n'est pas fabriqué comme un seuil.

### Consommateur actuel constaté sur F

data/4.20/experience_curve_map10.json (989 octets, SHA-256 BA484FA71447CD59E02396F555B92F0E9B6145CF71AEEEA768F7DE729D9AD5D6) contient les valeurs de la courbe. progression::threshold la lit via include_str! et cherche Values.EXP.LevelN. Simulation::award_experience refuse les montants non finis ou non positifs ainsi que les identifiants de joueur inconnus, ajoute l'XP, fait progresser jusqu'au niveau 18 selon threshold(level+1), puis actualise la vie max; pour un joueur vivant, elle actualise aussi vie courante et mana à partir du delta de croissance.

Résultat attendu / observé : pour chaque seuil historique sélectionné, la valeur importée doit être numériquement équivalente et le consommateur doit la consulter pendant le franchissement de niveau. Le reçu indique 17/17 valeurs (niveaux 2-18) correspondantes; le chargement et la boucle limitée à 18 sont observables dans le code F. Le reçu n'a pas qualifié une recalculation complète de toutes les stats.

Limites / reprise : la source d'XP n'établit pas le comportement historique de toutes les transitions. Restent à qualifier les gains multi-niveaux, les joueurs morts/vivants, le rafraîchissement des autres stats et les formes/transformation. Le reçu signale native_server_policy_qualified=false, current_application_executed=false et full_task_scope_complete=false; aucun test, client ou build n'a été exécuté pendant le présent audit.

## Clôture de ces deux liaisons

Le lien source native → entrée importée → consommateur Rust est identifié pour ces champs de croissance Garen et ces 17 seuils XP Map10. C'est une clôture d'audit bornée de provenance/consommateur, pas la clôture des fonctionnalités D04, de leur fidélité complète, ni du goal SYS-01.2-02. Les inconnues OLU-1f10098e-cf58-5e5c-94eb-2747d97c3d8b et OLU-fa030783-be0d-5d86-ad90-bc7312f7b150 restent ouvertes pour les limites précitées.

## Contrôles de ce tour

- Lecture du registre stat-links.json pour les associations et reçus existants.
- Lecture ciblée de progression.rs et lib.rs, extraction des valeurs Garen et calcul SHA-256 des deux fichiers de données/code sur F.
- Vérification que la copie Garen sous recovered_client_assets est absente.
- Aucun test, build, lancement du jeu, inspection GPU ou re-hachage des binaires natifs sur D.
- git status a échoué avec « this operation must be run in a work tree » alors que git rev-parse --show-toplevel retourne F:/OpenLeague; l'état Git avant cette note n'a donc pas pu être confirmé par status. Aucun fichier de code ni données de jeu n'a été touché.

Aucune implémentation de fonctionnalité, modification de goal, de l'application de suivi ou de ses bases n'est incluse dans ce lot.
## SYS-04.1-03 — Garen W et séparation locale base/bonus

### Lien natif vers le consommateur W

Le reçu dans docs/reference_stat_sources/stat-links.json identifie DATA/Characters/Garen/Spells/GarenW.inibin (1 105 octets, SHA-256 41280df3ed0fe881ef02bb1a05bd4685eafb1739b8f44f2cfc76a089efdb86e4, MD5 3ff47ced911b5d03b89fc140e2814181) comme membre correspondant du manifeste lol_game_client 0.0.1.7, release 0.0.0.181. Le reçu rapporte Effect1Level1..5Amount=20.

Sur F, native_spells_420.json contient la ligne Garen/slot 1/GarenW, ressource DATA/Characters/Garen/Spells/GarenW.inibin, et les cinq valeurs Effect1Level1Amount à Effect1Level5Amount sont chacune 20.0000. La ligne indique mechanics_validated=false. Son chemin source déclaré output/Champions_4_20/champions/Garen/spell_data/GarenW/GarenW.json et son empreinte SHA-256 6f35b13eb8c0019580d15b2a60743861fbd510635d598b7217115797e3cb9dc3 sont dans les métadonnées de la ligne, mais le fichier dérivé n'existe pas sous data/4.20 sur F. La liaison de la ressource native à l'entrée agrégée est donc étayée par le registre et les références de la ligne, sans possibilité de rejouer localement toute la conversion à partir du fichier dérivé manquant.

spells::garen_value charge native_spells_420.json, choisit le champion Garen et le slot 1, puis résout la clé Effect1Level{rank}Amount. Dans progression::stats, si le joueur est Garen et son rang W est supérieur à zéro, bonus_defense vaut 1 + valeur W / 100, soit 1.2 pour les rangs 1 à 5 observés. Cette valeur multiplie le bonus d'armure et de résistance magique des objets; croissance de niveau, défense Annie et réduction Exhaust sont traitées séparément dans la formule courante. Le code ne multiplie donc pas la défense de base par cette branche.

### Décomposition locale de l'attaque

progression.rs définit aussi ad_components : il calcule un total avec base, croissance, bonus d'objet et multiplicateur d'autel, puis un bonus signé relatif à la base de niveau; la branche d'ajustement peut imposer un plancher à zéro. Ce consommateur local est visible mais la ressource Garen W ne qualifie pas l'ordre historique de ces opérandes. Le reçu laisse le contrat base/bonus global ouvert.

Résultat attendu / observé : les cinq montants du membre natif sélectionné doivent être présents dans la ligne de données utilisée par le lookup W; c'est le cas dans la table F et le lookup/consommateur statique sont présents. Cette vérification confirme une liaison et une valeur d'entrée, pas la validation mécanique du sort ni la politique historique des bonus.

Limites / reprise : fichier dérivé de conversion absent, mechanics_validated=false, priorité effective des sources non qualifiée, sémantique native complète de base versus bonus non établie, runtime non exécuté. L'inconnue OLU-9d166d5f-e881-5f0e-8860-403149521365 reste ouverte. Réouvrir la provenance de conversion si le fichier de sortie correspondant ou un reçu reproductible de conversion devient disponible.

## SYS-04.1-04 — plafonds de réduction du cooldown

Le reçu existant attribue à LEVELS/Map10/Constants.var (D, 19 433 octets, SHA-256 178d86117826819d02af09477083eae625d418ee4b0b8bff4763a1a56c7b2be2, MD5 a62149a5f1fcf4316ea11665a55f5142) le membre retenu du manifeste lol_game_client 0.0.1.7, release 0.0.0.248. Les valeurs sélectionnées sont gcd_PercentCooldownModMinimum=-0.4 et gcd_CooldownMinimum=0; d'autres constantes d'attaque sont séparées et ne sont pas un contrat de cooldown.

Sur F, data/4.20/cooldown_rules.json (SHA-256 F35A4CE2AEE181900555993D6824FD17C61C22A2D0E63B0EBB6D613F42E68805) contient maximum_reduction=0.4 et minimum_seconds=0. crates/core/src/cooldown.rs charge ces deux champs; ticks refuse par assertion les secondes de base négatives/non finies et les réductions non finies, borne la réduction positive à [0, maximum_reduction], applique le minimum, puis convertit en ticks. progression::stats borne également la réduction d'objet à cette convention positive avant que spells.rs ne passe la valeur à cooldown::ticks. Le chemin de copie F de Constants.var sous recovered_client_assets est absent; identité et membership reposent sur le reçu existant.

Résultat attendu / observé : la limite native signée -0.4 doit avoir un correspondant local si la convention de réduction est positive; le maximum local est +0.4 et le minimum de secondes vaut zéro. Le code de stats et le calcul de cooldown consomment ces limites. La correspondance des bornes est établie, ainsi que la distinction de signe et de couche.

Limites / reprise : cette association ne démontre pas la conversion historique du signe, la priorité runtime des configurations, tous les comportements de réduction négative, les bornes de chaque statistique, ni l'ordre complet des clamps. Le JSON local précise que les descriptions d'objets et la déduplication sont reconstruites et que les corps natifs de scripts d'objet ne sont pas récupérés. L'inconnue OLU-7eb79b88-be8f-5c3d-b33b-2eea0ecf3aa5 reste ouverte. Aucun test ni lancement n'a été effectué dans ce lot.

## SYS-04.1-07 — Trundle R : fraction importée et état courant

Le reçu de provenance lie DATA/Characters/Trundle/Spells/TrundlePain.inibin (D, 1 238 octets, SHA-256 4d9670b43927dc1ebbc9fba3097bbb8a426d9768593a393714e0b424b292a716, MD5 9072a356b1a1c3a79044ab0d359268d2) au membre du manifeste lol_game_client 0.0.1.7, release 0.0.0.161. Le sélecteur retient Effect2Level1..3Amount=40. Sur F, la ligne Trundle/slot 3/TrundlePain de native_spells_420.json marque la même ressource et donne 40.0000 aux trois rangs; mechanics_validated=false. Le fichier de conversion déclaré dans la ligne n'existe pas sous data/4.20/output et la ressource native n'existe pas sous recovered_client_assets; l'identité de membre et la valeur source s'appuient sur les reçus existants.

Le consommateur Rust est borné et réel : trundle_r::rules parse l'entrée agrégée, exige le champion, slot et identifiant attendus, valide les champs de chaque rang dont Effect2=40, puis construit Rank avec defense_fraction=0.4. Lors du cast, trundle_r.rs lit les stats courantes du lanceur et de la cible; calcule les fractions d'armure et de résistance magique; et stocke ces résultats, le dégât brut, le rang et l'horloge dans Drain. stats() consomme ensuite les ajustements pendant la durée de l'effet. À titre de contraste d'ancre, trundle_q_attack_hit calcule son dégât à l'impact avec self.stats(source).damage; cette route lit l'AD actuel et n'est pas la preuve de la politique native générale de snapshot.

Résultat attendu / observé : la valeur native 40 à chaque rang doit correspondre à la fraction locale 0.4 et le chemin courant doit la valider puis l'employer dans les transferts stockés. Les trois valeurs de la table et les garde-fous du parseur, ainsi que les champs de Drain, sont observés statiquement. Le reçu et le commentaire du module qualifient explicitement pulses, snapshots, timing et ordre comme politiques reconstruites localement.

Limites / reprise : la ressource et le fichier de conversion ne sont pas récupérés sous les emplacements F inspectés; aucun lancement ne confirme l'effet. Le taux 40 ne tranche pas si le serveur historique prenait un snapshot ou relisait les stats à chaque pulsation, ni timing, décès, rafraîchissement ou ordre pour les autres effets. L'inconnue OLU-3f66afa2-c02f-5024-9fd7-c225694fcfa5 reste ouverte. Réouvrir l'origine de conversion sur fichier exact ou reçu reproductible; réouvrir la sémantique d'effet sur source primaire du callback/politique historique.

## SYS-04.1-02 — ordre local des bonus AD, sans source native liée

Le registre associe SYS-04.1-02 à progression.rs:42 et shop.rs:215, mais l'objet ne porte aucune liaison native (native binding count zéro). La source locale d'objets consommée par shop.rs est data/4.20/shop_foundation.json (30 123 octets, SHA-256 504AD86B20157B91B4AEE8C174DBEE43A5689DCB2CDEE3975E8DBBDF804852AE); sa racine expose starting_gold, shops, shop_radius et items, sans liaison de provenance native dans ce lot.

Résultat attendu / observé : l'audit doit établir le comportement local et signaler la source historique manquante. shop::bonuses agrège les bonus d'objet, somme l'AD, et déduplique certains bonus de cooldown/pénétration selon l'identité de l'objet. ad_components calcule level_base = base + growth*factor, puis existing = (base + growth*factor + item)*altar; un ajustement signé non nul est ensuite ajouté avec plancher local à zéro, et bonus = total - level_base. attack_damage_components appelle cette fonction avec les données champion, croissance, inventaire, autel et ajustement Trundle Q. Le chemin local est confirmé dans les fichiers F (shop.rs SHA-256 3DB7B79F20D15E95B6B92AFFE0087E730C9110D876EA41CC36416435159A2CD0; progression.rs SHA-256 EAB515371EDAFB139B439028AD9F2828ED31CBFC90BB6D8AD54441FCC903F766). Le reçu existant rapporte six cas isolés de l'ordre local; aucun n'a été rejoué ce tour.

Limites / reprise : faute d'une source primaire liée pour ce contrat, l'ordre historique complet « flat puis multiplicateur », les autres catégories de stat, buffs/passifs et le statut des bonus négatifs restent inconnus. Le résultat est une liaison entre données locales et consommateur, plus un constat d'absence de source native pour l'ordre; ce n'est pas une validation de la politique serveur. L'inconnue OLU-2fb08e37-49f6-5024-8bcb-857f472779fe reste ouverte. Condition de reprise : identifier un fichier/contrat natif 4.20 précis qui spécifie les opérandes et leur ordre, ou un reçu de conversion avec source primaire et ancrages. Aucun test n'a été exécuté.

## SYS-04.1-05 — achat/vente : rafraîchissement local des pools

Le registre n'attache aucune source native à SYS-04.1-05. Les ancres shop.rs:261, :294 et :314 pointent vers buy_item, sell_item et refresh_item_caps. Dans le code F, les contrôles d'achat précèdent la mutation d'inventaire/or puis appellent refresh_item_caps; la vente vérifie emplacement, présence et prix de retour avant mutation, puis appelle le même rafraîchissement. Celui-ci recalcule Simulation::stats, affecte le nouveau max_health et borne les valeurs absolues de vie et mana courantes à leurs nouveaux plafonds.

Résultat attendu / observé : après un achat/une vente acceptés, le consommateur local doit rafraîchir les plafonds et conserver les pools courants dans leurs nouvelles bornes; les appels et opérations sont directement observables dans shop.rs. Les refus précèdent les écritures d'inventaire correspondantes dans les branches inspectées. Il s'agit d'une inspection statique, sans simulation ni scénario achat/vente exécuté ce tour.

Limites / reprise : aucune source primaire liée ne tranche si le serveur 4.20 conserve les pools absolus, ajuste leur valeur proportionnelle ou applique un autre ordre lorsque les caps changent. Les autres effets persistants et statuts de refus complets restent hors de cette liaison. L'inconnue OLU-ed710f30-0fbf-57c0-8385-54d87c2fdc0b reste ouverte. Condition de reprise : archive exacte ou callback/contrat natif qui spécifie les deltas de vie/mana et l'ordre de rafraîchissement à l'achat/vente. Aucun test, build ou jeu exécuté.

## Liaison adjacente — Trundle Q, source brute présente mais membre non qualifié

Une piste nouvelle est apparue dans la ligne Trundle slot 0 de data/4.20/native_spells_420.json : elle nomme DATA/Characters/Trundle/Spells/TrundleTrollSmash.inibin, les valeurs Effect1 20/40/60/80/100 et une source de conversion JSON déclarée sous output/Champions_4_20. Le fichier JSON de conversion déclaré (SHA-256 1a9046e95b7934aac416d922de57d9f65d6b988cae7d5b3f073da8c232104f32) est absent de data/4.20 sur F. La ligne agrégée indique mechanics_validated=false.

Le binaire natif à l'emplacement déployé fourni sur D est présent et a été haché ce tour : 1 432 octets, MD5 7F8DFFA55FF63416F2A62139BD0E9699, SHA-256 6145A2E3A7756AC837DF619D8BFC9AA7307CDB31A45EBB1AD6DB60E19276E62C. Aucun reçu structuré consulté ce tour ne lie encore ces octets au membre du manifeste sélectionné lol_game_client 0.0.1.7; une correspondance textuelle dans le manifeste binaire n'est pas une preuve de membership.

Le consommateur courant trundle_q::rules charge la ligne Trundle/slot 0 de native_spells_420.json et vérifie les champs ManaCost, Cooldown, Effect1, Effect2, CastRange et Effect3 pour les cinq rangs. Le callsite trundle_q_attack_hit calcule le dégât attendu avec le bonus d'AD local et self.stats(source).damage au moment de l'impact. La coefficient AD locale [0.8,0.9,1.0,1.1,1.2] est sélectionnée depuis la source DDF commentée par le module; ce choix est explicitement reconstruit et le commentaire indique un conflit avec Effect3 aux rangs 1-4.

Résultat attendu / observé : le consommateur doit charger une ligne Q cohérente et relire l'AD au hit; le code F le fait statiquement et la ligne contient les valeurs d'Effect1 observées. Le lien entre le binaire brut, le membre sélectionné et le JSON agrégé n'est pas assez prouvé pour déclarer la provenance fermée.

Limites / reprise : membership du binaire au manifeste 0.0.1.7 non établi, JSON dérivé absent, mechanics_validated=false, coefficient DDF et conflit d'Effect3 non requalifiés dans ce lot, runtime non exécuté. Réouvrir seulement avec le reçu du lecteur de manifeste qui associe exactement le chemin logique, 1 432 octets et les empreintes ci-dessus au membre 0.0.1.7, plus le JSON de conversion exact ou un reçu reproductible. Ne pas inférer la complétude de Q à partir de la seule ligne agrégée.

## Mise à jour corrective — Trundle Q : membership et champs vérifiés (2026-11-02)

Ce supplément corrige l’ancien constat « membre non qualifié » et la condition « JSON dérivé absent ». Il conserve l’historique du premier contrôle, sans effacer l’écart alors observé.

### Source native et membership RADS

Le source registry lie le fichier D suivant à OLS-f0c7233f-9599-5c46-8ae4-1af8b6bfab8f : DATA/Characters/Trundle/Spells/TrundleTrollSmash.inibin, version client 4.20.0.315, 1 432 octets, SHA-256 6145a2e3a7756ac837df619d8bfc9aa7307cdb31a45ebb1ad6db60e19276e62c, MD5 7f8dffa55ff63416f2a62139bd0e9699. Ces octets ont été rehachés dans ce lot.

Le reçu de membership OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d, conservé dans E:/OpenLeague/docs/reference_native_skin_loader_sources/native-release-membership.json, a été rehaché : 11 076 027 octets et SHA-256 8cfb03b7e8c928135dc485b5fc02a5761568818a100f793d85492808059ce6e2. Le repere 570 du tableau relie exactement le chemin logique au projet lol_game_client 0.0.1.7, release membre 0.0.1.2, MD5, taille et octets compressés 1 068; statut matches_selected_project_manifest. Le contenu de cette ligne concorde avec le fichier D actuel. L’ancienne affirmation d’absence de preuve de membership est donc périmée.

### Export et consommateur actuel

Le JSON déclaré par OLS-af31ac6d-ec29-582e-9ff7-77c6949dde6f existe sur E, sous output/Champions_4_20/champions/Trundle/spell_data/TrundleTrollSmash/TrundleTrollSmash.json : 6 552 octets, SHA-256 1a9046e95b7934aac416d922de57d9f65d6b988cae7d5b3f073da8c232104f32. Il est absent de l’emplacement F data/4.20/recovered_client_assets; en revanche la ligne Trundle/slot 0 intégrée à F data/4.20/native_spells_420.json conserve le même hash source et les valeurs utilisées. Le JSON agrégé F a été rehaché à 0cae6f5c167aa852e8f86e7f3298d7c797727d5cc92616dcb856ac15c8af5d14; son source ID est OLS-92cd8d55-8ff0-5a89-8b4c-84a6cfcbc4ec.

Deux lecteurs INIBIN — tools/project-plan/reference_inibin.py et la copie locale de lolpytools_inibin2 — ont décodé le binaire D. Pour les cinq rangs, les 30 champs que rules() exige (ManaCost, Cooldown, CastRange, Effect1, Effect2 et Effect3) ont la même représentation float32 que dans le JSON E et la ligne agrégée F. Coefficient, comparé en plus, correspond aussi : 31 champs sur 31 concordent bit à bit. Un premier appel du lecteur communautaire avec BytesIO a échoué parce que ce lecteur appelle os.fstat; l’appel correct via from_file sur le fichier réel a réussi, sans écriture. Cela vérifie la correspondance des champs sélectionnés, pas la totalité de l’outil de conversion : le registre indique toujours conversion_tool_version=null et conversion_chain_not_fully_qualified=true.

Le code F crates/core/src/trundle_q.rs, source ID OLS-378e911e-60d5-58f5-b29b-c0ba5be024c6, SHA-256 actuel a28dc2a5f061e0c25df613b37d8fc75ecae50ab41eb9fb599331e2de05440e73, charge cette ligne et valide les 30 champs sur cinq rangs. À l’impact, il calcule base + coefficient_AD * AD courant. Le coefficient choisi localement vient du DDF client exact DATA/Characters/Trundle/Trundle.ddf : source ID OLS-553012cd-e16e-5c26-8705-9e998538b941, 931 octets, SHA-256 1cd1d4183ee97b2e56d1b065eaf5a6cd54bb39d41c8bedc9fd7756cccdffd296; le fichier D rehashé contient TrundleTrollSmash;f1, link attackdamage, coefficients 0.8/0.9/1.0/1.1/1.2. La table locale reprend ces valeurs.

Une autre copie JSON sous GameServer/Content/LeagueSandbox-Default est classée community_native_data_mirror par le registre et a le même hash que l’export E; elle n’est pas traitée comme code serveur Riot ni comme autorité de comportement historique.

### Décision et limites maintenues

Clôture d’audit limitée : l’identité et le membership RADS de l’INIBIN, les valeurs sélectionnées de l’export et leur lien statique au consommateur courant sont maintenant établis. L’affirmation précédente « source membre non qualifiée / JSON dérivé introuvable » est supersédée pour ces seuls faits.

La fonctionnalité Trundle Q n’est pas validée. mechanics_validated reste false. L’INIBIN contient aussi Coefficient=0.4 et Effect3=100..120; le code les valide séparément, mais retient le DDF 0.8..1.2 pour son coefficient AD. La raison serveur historique de ce choix, les priorités runtime, l’arrondi et l’ordre complet restent inconnus. Le code et ses refus n’ont pas été exécutés dans ce lot; aucun test Cargo, build ou client n’a été lancé.

À la reprise, ne pas refaire hashes/membership/décodage inchangés. Reprendre seulement sur une source primaire du comportement serveur, une règle native qui tranche Effect3/Coefficient/DDF, une preuve nouvelle de priorité runtime ou la chaîne exacte de conversion. Les sources et consommateurs concernés restent liés aux IDs OLS ci-dessus; aucun statut, registre de tâches, coverage, plan, goal ou base n’a été modifié.
