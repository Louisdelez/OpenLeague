# SYS-01.2-02 — Gnar : Rage Gene, V571

Date UTC 2026-10-26T00:25:21.621770+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue officiel4.20.1 distinct.

## Résultat intégré

Trois fiches enrichies : CH-Gnar-PASSIF-SOURCE, CH-Gnar-PASSIF-SIMULATION-CONTRAT et CH-Gnar-PASSIF-SIMULATION.72 associations vers24 sources natives et48 liens vers24 points de code. SYS-01.2-02 référence le lot. Trois questions propres et quatre dépendances conservées ; prérequis de phase/lot inspectés sans les déclarer satisfaits pour une acceptation de gameplay. Les consommateurs gardent `entry_boundary_only` et `provides_feature_consumer=false` pour Rage Gene. Aucun gameplay ou asset modifié.

Le moteur initialise Gnar avec une ressource à100/100. Les attaques et la progression des ticks ne changent pas ses statistiques dans les scénarios testés ; ses sorts sont refusés. Cette jauge déjà pleine empêche de mesurer un gain de rage. Le test ne prouve ni absence globale de génération ni valeur initiale native correcte. Le chemin inspecté de réapparition met les ressources de ce type à zéro, mais n’a pas été exécuté dans ce lot : il constitue la prochaine vérification utile.

## Sources et limites natives

| Ressource sélectionnée | Identifiant |
|---|---|
| Gnar.inibin | OLS-e6901a32-d51d-5ddb-bf1e-2920dbf9984d |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptGnar.luaobj | OLS-925c06f0-b968-5364-a40f-d3beb2dd593d |
| CharScriptGnar.preload | OLS-a8700f23-c1b1-5ae9-a84a-c5e69dfff046 |
| GnarFuryGeneration.luaobj | OLS-045c6680-b5e5-5ab2-b1fd-9ade08e5ce52 |
| GnarFuryGeneration.preload | OLS-e93884ca-4954-5095-98a8-c99eb8ca9280 |
| GnarFuryHigh.inibin | OLS-d8e49d3f-3654-5158-84c8-cf303c59461d |
| GnarFuryHigh.luaobj | OLS-ed4ebecb-e71b-5054-a56c-1bc7da815794 |
| GnarFuryHigh.preload | OLS-7ffd4cd4-dd04-50f1-ac90-4b0e6be56005 |
| GnarPassive.inibin | OLS-ff457186-35c7-5bcc-87bf-c9cffcf28311 |
| GnarPassive.luaobj | OLS-4d97e311-6701-5409-b848-9626f9bf6f4f |
| GnarRedVfx.luaobj | OLS-4313483d-de7a-5696-a965-8d48c2ccc570 |
| GnarRedVfx.preload | OLS-fb0823b4-fb56-58d8-9168-90c821b3d670 |
| GnarRunCycleManager.luaobj | OLS-0a72b00d-6c73-5646-a665-8bc4c03a86b5 |
| GnarRunCycleManager.preload | OLS-c6065841-eccd-5c33-ac53-50872999a27d |
| GnarTransform.inibin | OLS-337d5947-9afb-5451-9507-91b20d616e4a |
| GnarTransform.luaobj | OLS-be15a4de-76a0-54b2-bcb8-434a1ff4f76c |
| GnarTransform.preload | OLS-12b93f84-51f1-54e1-8cfb-7180ace7a746 |
| GnarTransformSoon.inibin | OLS-8627d81e-8676-5444-96b3-4bf10dc1ebd6 |
| GnarTransformSoon.luaobj | OLS-d72e5d61-9a62-5adf-bbf5-e56fc0bf742e |
| GnarTransformSoon.preload | OLS-8cf30f83-0d16-50fc-8911-e6c25623ac0c |
| GnarTransformTired.inibin | OLS-9530851c-13a2-5aa4-b61d-286eee258465 |
| GnarTransformTired.luaobj | OLS-fdcd8ef1-1c3f-50b8-b0fc-1da52d780a54 |
| GnarBig.inibin | OLS-4012654b-02fd-5ae1-9439-2c69d5ae271b |

26 candidats examinés,24 retenus. Tailles/SHA256 égaux au registre et tailles/MD5 égaux aux manifestes RADS sélectionnés ; la priorité effective du chargement historique reste distincte. Les candidats exclus restent pinés et documentés.

Gnar.inibin et GnarBig.inibin déclarent Passive1LuaName=GnarPassive, l’icône Gnar_Passive.dds et PARType=Gnarfury. BaseMP est littéralement100.0 ; le champ recherché PARStart est absent. Une capacité de ressource n’est pas une preuve de sa quantité au début d’une partie.

Le tooltip natif en_GB ligne1951 indique génération de rage au combat et à l’attaque, transformation via la prochaine capacité à rage maximale, et modification des sorts/statistiques pendant **15 secondes**. Mini Gnar : vitesse f1,portée f2,vitesse d’attaque f3. Mega Gnar : santé f4,armure/résistance magique f5,régénération de santé par5 secondes f8,dégâts d’attaque de base f7. Les producteurs et formules de ces paramètres ne sont pas qualifiés. Les textes Enraged,No Going Back et Tired décrivent des états associés ; leurs seuils,délais et transitions exacts restent à établir.

Neuf Lua sélectionnés sont entièrement lus et ne contiennent aucun prototype enfant. Quatre initialisations littérales sont reconnues. Les cinq suivantes dépassent le lecteur littéral sur NEWTABLE : FuryGeneration(pc6),FuryHigh(pc10),Transform(pc8),TransformSoon(pc8),TransformTired(pc10). Ces limites ne prouvent pas une corruption. Les constantes de ces cinq chunks contiennent AutoCooldownByLevel et la série20/18/16/14/12,ainsi que SpellFXOverrideSkins et RocketTristana. Le lecteur ne qualifie pas leur affectation complète ni leur utilisation :elles ne sont pas adoptées comme durée de fatigue ou règles de transformation,et le nom hérité reste conservé. Aucune exécution des callbacks du serveur historique.

Sept preloads et cinq bindings de tooltip sont conservés. GnarTransform.preload référence explicitement gnarbig,gnarbigq,gnarbigw,gnarbige,gnartransformtired et les sorts Mini. Cela ne prouve pas le remplacement effectif des sorts. Dans GnarBig.inibin,Spell1..4 restent GnarQ/GnarW/GnarE/GnarR ; ces champs seuls ne réalisent donc pas la transition. Les preloads de VFX ne constituent pas une validation du rendu ou du son.

Quelques valeurs de définition illustrent la distinction : santé540/610,dégâts48/54,armure23/26.5,résistance magique30/33,rayon navigation30/50,rayon gameplay55/80,IsMelee No/Yes pour Gnar/GnarBig. Les deux déclarent portée150 et vitesse325. Il ne faut pas remplacer les bonus dynamiques f1..f8 par une simple soustraction de ces valeurs ni appeler portée150 la portée Mini finale sans qualifier f2.

GnarWProc.inibin/.luaobj sont exclus de l’autorité de Rage Gene : ils désignent Hyper,un effet lié au W,avec icône Gnar_W_Debuff.dds. Leur présence dans le preload du personnage ne les transforme pas en mécanisme de rage. Treize références communautaires sont conservées séparément ; le CharScriptGnar est vide. Les fragments Q/W/E/R communautaires ne sont pas une preuve de serveur historique complet.

## Vérification du moteur réel

Trois simulations Map10 : Gnar bleu et Annie rouge, positions atteintes avec Move puis Stop. Aucun changement direct de position,santé,ressource,XP,rang ou effet ; aucun événement artificiel de dégâts. Un cas au repos,un cas où Gnar attaque six fois et un cas où Annie l’attaque six fois.

| Cas | Impacts | Ressource initiale/finale | Refus publics | Suivi après arrêt |
|---|---:|---|---:|---:|
| idle | 0 | 100.0/100.0 | 16 | 600 |
| outgoing_attacks | 6 | 100.0/100.0 | 16 | 600 |
| incoming_attacks | 6 | 100.0/100.0 | 16 | 600 |

Les12 impacts ont chacun un projectile source/cible présent dans le snapshot précédent. La perte de santé corrigée de la régénération correspond aux dégâts physiques ordinaires brut×100/(100+armure), avec résidu inférieur à0.002. La ressource reste100 et les statistiques observées — santé maximale,capacité de ressource,dégâts,armure,résistance magique,vitesse,cadence et régénération — restent identiques. Chaque cas est suivi sur600 ticks,soit20 secondes. Aucun changement de forme observé ; il ne s’agit pas d’une vérification d’expiration d’une transformation qui aurait réellement commencé.

Les48 refus atomiques comprennent45 commandes rejetées (joueur inconnu,attaque de soi,slot invalide et douze Learn/Cast/CastAt par cas) et trois tentatives de rejoindre la partie comme gnarbig. Les snapshots restent identiques. GnarBig est une définition alternative native ; son rejet comme champion de connexion ne constitue ni une erreur prouvée du roster ni un test du changement de forme interne. Aucun déclenchement de transformation par capacité réussi.

Les consommateurs courants relient l’initialisation générique `mana: def.mana`,les statistiques de base/croissance,les commandes,les attaques,les dégâts,la régénération et le cycle de vie. La régénération courante de ressource vaut0 pour Gnarfury : restores_resource ne retient que Mana/Energy. Cela est distinct d’un mécanisme de génération de rage à l’impact. Les profils de collision et d’attaque restent statiques pour le nom du champion dans les chemins inspectés.

## Identité, contrôles et conservation

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-gnar-passive-rage-gene-probe.exe`,6035456 octets,SHA256 `ec128b083d2590af2c7ed71960e4b3be051a8ed3f517ca12fe957a65b371d517`. Compilation/exécution code0. openleague_core non-test ; verrou privé aligné avec les identités/checksums du verrou racine.1158 entrées core/ressources et chaîne des preuves antérieures inchangées,y compris V570 corrigée et son premier build échoué. Aucun processus du jeu ou serveur historique exécuté.

Inspection,prepare,check,publish,audit : code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite :4 destinataires,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques conservés. Store.task/copy_text/summary/dépendances,résolution de trace,intégrité et synchronisation idempotente contrôlés. Identifiants,hiérarchie,inconnues inchangés en octets ;3 fragments de trace modifiés,42212 conservés.

Revue globale fraîche :42215 exigences,98960 sources,3360 consommateurs ;3360 ancres exactes,zéro divergence.26189 questions ouvertes et5517 résolues inchangées. Cette revue ne re-hashe pas toutes les sources et ne mesure pas le pourcentage de jeu terminé. Les sources sélectionnées ont leurs preuves d’identité séparées.

## Travail restant

- Mesurer le comportement à ressource non saturée via une mort/réapparition publique, puis attaques et combat ; séparer la quantité initiale native du comportement actuel.
- Retrouver/qualifier f1/f2/f3/f4/f5/f7/f8,les valeurs par niveau et les règles de rage : génération,décroissance,seuils,déclenchement,durée,fatigue,mort et réapparition.
- Intégrer la transition de forme,les statistiques,la portée,les profils de collision/mêlée-distance et le remplacement effectif des capacités.
- Qualifier séparément réseau,HUD,animations,VFX et audio ; aucune preuve d’asset absent n’est déduite de ces seuls essais.
- Garder le défaut de déplacementV564 ouvert ; les routes réussies ici ne le corrigent pas.

Registres modifiés : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Reçu reference_requirement_trace_sources/gnar-passive-rage-gene-links-v571.json ; preuve fidelity_gnar_passive_rage_gene_links_v571.json. Couverture,plan,checkpoint,CURRENT,HANDOFF et deux bases mis à jour avec sauvegardes. Scripts et journaux :revision571_Gnar* sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun statut ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision572_trace_review/REVIEW.json. V571 Gnar publiée/auditée :3 fiches,24 sources parmi26 candidats,72 associations,24 points/48 liens limités. Trois scénarios publics :repos,6 attaques émises et6 reçues,48 refus,1800 ticks de suivi,ressource100/100 et statistiques inchangées. La saturation initiale interdit de conclure sur le gain de rage;aucune transformation observée,sorts refusés. Prochaine vérification utile :obtenir une ressource non saturée par mort/réapparition publique puis exercer attaques et combat,sans injection;le chemin de respawn a été seulement lu dansV571. Les données GnarBig existent;f1/f2/f3/f4/f5/f7/f8 et transitions restent ouverts.5Lua limités par NEWTABLE,pas corrompus. WProc/Hyper distinct. Préserver INPUTS_BEFORE.previous_artifacts V571,qui conserve qualifiedV570 et le build initial E0559 avec toute la chaîne antérieure. Aucun statut/case/inconnu fermé. Défaut déplacementV564 ouvert;goal actif.
