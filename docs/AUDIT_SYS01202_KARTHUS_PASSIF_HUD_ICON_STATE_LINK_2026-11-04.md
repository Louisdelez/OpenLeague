# SYS-01.2-02 — Karthus : liaison de Death Defied au HUD, V1229

4 novembre 2026. Unité `AUD-SYS-01.2-02-KARTHUS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis publication racine. Mécanique, HUD complet et acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Karthus-PASSIF-PRESENTATION-HUD`, `OLF-d8d2f511-07cc-52ba-9b27-989acf0b9c9d`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-4a42c5d1-4d9a-5917-be75-52fa32c1f91c` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, CONTRAT, SOURCE, ACCEPTANCE et leurs six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V584 UTC 2026-10-26T04:01:03.807803+00:00 ; MD UTC 04:07:53.333425. Dates documentaires, sans date d’exécution déduite.

V584 :27 identités natives ordinaires/81 associations sur trois tâches. SOURCE actuel :32 relations/27 identités ; HUD :deux relations, définition/CharScript. Captures historiques conservées exactement sur E avec provenance/empreintes ; chemins F-work inertes. Métadonnées/font/INIBIN/Lua/preloads ne sont pas relus sur D.

Passive1LuaName=`Death Defied`, espaces conservés ; icône Karthus_Passive. Description liée4211 : lancement de sorts mort pendant sept secondes. Death Defied.inibin lie1823, sorts gratuits après dégâts mortels ; Death Defied Buff lie1824, forme spirituelle. Six rangs passifs absents, sans défaut inventé. Cinq bindings de buffs donnent quatre correspondances ; game_buff_tooltip_Defile reste manquant, sans alias vers game_buff_tooltip_KarthusDefile.

Buff Lua : BuffName=`Death Defied Buff`, persistance/non-dissipation déclarées, sans callback/ordonnancement serveur qualifié. Les triplets LayWasteDeadA1/A2/A3, WallOfPain2, Defile2 et FallenOne2 restent distincts des sorts vivants et de leur exécution. SpellToggleSlot=3 de Defile2 conserve sa convention non résolue, sans le renommer R.

Huit Lua ordinaires entièrement parsés sans prototype enfant, sept initialisations littérales ; FallenOne2 dépasse le lecteur littéral sur NEWTABLE pc12, sans corruption démontrée. Globals CharScript natif et classe communautaire CS vides, sans absence globale de serveur déduite. Huit preloads déclarent variantes mortes/restauration des sorts vivants et effets avatar/root/explosion/fade, sans rendu qualifié. Le root cite aussi une dépendance NightmareBot, conservée comme telle. Cinq chemins non retrouvés dans la recherche historique V584 :DDF et quatre candidats KarthusDeathDefied inibin/Lua personnage/global. Le preload exact karthusdeathdefied reste non résolu ; aucun alias vers les noms avec espaces/suffixe Buff.

Deux fichiers NightmareBot Lua/preload restent exclus des liens ordinaires ; leur Lich_Defied.dds n’est ni lu ni adopté. Neuf références communautaires restent secondaires. Inventaire exact avant lecture DDS ordinaire :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Karthus/HUD/Icons2D/Karthus_Passive.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.235 |

Un DDS/2176octets ; Karthus_Passive.dds : `53c44814e35123cf704acaf920d130300f6af6ad71c6b4a5ab4a274cf44ee707`. Taille/MD5/membership vérifiés, aucune variante/lookup/alias/pixels/rendu acceptés. Aucun asset3D manquant n’est déduit de ces limites. Localisation en_GB et témoin Ahri identifiés sur miroir F ; aucune relecture font D, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :six sites/trois fichiers. V584 :21sites/11fichiers, plus deux lecteurs. Garde générale health<=0 avant Action, gardes mort des casts ciblés/au sol et refus Karthus vivant sont réels. Apprentissage/rangs, attaques/projectiles, létal cleanup, crédit de mort/récompense unique, délai de réapparition, régénération et ressources sont inspectés.

Le létal crée immédiatement respawn_at=tick+base_death_ticks ; niveau1=480ticks. La régénération parcourt les vivants ; lifecycle restaure santé/mana et position. Ce cycle ordinaire ne constitue pas l’état spirituel7s. Aucun producteur/postmortem-cast Karthus identifié dans les corps inspectés, sans absence globale déduite.

Provider/StartupHud, barres, QWER, Buff0 Ezreal, F3/Annie et snapshot/session/horloges existent sans liaison Karthus icône/texte/rang/état autoritaire établie. QWER possède quatre icônes primaires, zéro variante/unresolved ; cela ne rend pas exécutables les variantes mortes. Autres mécanismes spécifiques conservés sans transfert.

## 4. Attendu, observé et contrôles

Attendu : état postmortem et commandes/coûts qualifiés, ressources reliées aux widgets/audiences applicables. Observé : déclarations et cycle ordinaire, refus vivant/mort, liaison spécifique non établie. Sources 64/64, relecture E 74/74 ; consommateurs 67/67, relecture 10/10. Seize entrées/29 fenêtres communes,21 ancres V584,six SOURCE et 8 pins/16 fenêtres directes vérifiés. Avant tout producteur, deux projections de schéma ont été corrigées : bindings non résolus objets→clés, critères de correction dictionnaire→clés ordonnées, dictionnaires conservés. Deux originaux archivés exactement. Puis un producteur/readback source et un collecteur/readback consommateurs, sans échec ni retry. Diagnostics hérités et captures inchangés non rejoués.

V584 hérité : deux parties base/Rubis1028 acheté400, HP516/666.31 baisses de santé ont des projectiles Annie→Karthus témoins. Deux morts, chacune une seule première récompense400 dans sa partie indépendante ; victime niveau1.164 refus sans mutation, dont110 morts,960ticks postmortem, deux réapparitions ordinaires480ticks/seize secondes.

Offsets0/1/209/210/211 :quatre Cast,quatre CastAt,Move/Attack/Stop refusés `champion dead`,55/cas. Jusqu’au479, santé0,position/mana/échéance inchangés ;480 :réapparition,ressources restaurées,retour base,puis Move accepté. Refus QWER vivants et après réapparition conservés. La stabilité du mana sous refus ne démontre aucun coût gratuit sur lancement accepté. Ces observations ne qualifient ni durée/borne native7s ni restauration des sorts/postmortem-cast. Attendu du diagnostic de refus/cycle ordinaire satisfait, acceptation historique non satisfaite.

Binaire historique6031872octets, SHA`f527d4c1a50cc57602770e26876eb94c52cde364f052ca3a7913d8d3cd1b4a45`, BUILD/RUN0 hérités. Ancienne garde de préparation documentaire refusant une référence Karma intentionnelle, puis précisée avant création/exécution, conservée. Aucun nouveau build, jeu, VM, REA, réseau, GPU, audio/rendu ; Karma/Jinx-stockage/Jax/V564 préservés sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Admission QWER vivant/mort, transition létale/crédit/chronologie de réapparition, sept secondes/expiration/simultanéité, coûts gratuits/cooldowns/canalisation/Defile, ciblage/mouvement/autres actions, restauration des sorts/cleanup, mort/session/reconnexion/fin, noms manquants/index/rangs/lookup/audiences et rendu restent ouverts. Bot exclu, clé Defile et cinq candidats non retrouvés conservent leur portée exacte.

## 6. Correction et reprise

Réutiliser `CH-Karthus-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION. Qualifier noms/ressources/index/rangs et contrat7s/coûts/restrictions sans alias arbitraire ; intégrer état autoritaire spirituel, admission des variantes et fin d’effet sans altérer arbitrairement les gardes ordinaires. Relier HUD et audiences avec refus/retrait des données absentes, invalides, périmées ou non autorisées. Vérifier lancements réellement acceptés, coûts, bornes/dernier tick, simultanéité/crédit, effets engagés/Defile/canalisation R, plusieurs niveaux/causes de mort, restauration/réapparition/déconnexion et rendu identifié. Garder NightmareBot séparé, témoins ordinaires et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_karthus_passive_hud_20261104`, sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9/vérificateur V1226 réutilisés, toutes entrées/archives incluses. Publication :rapport+ajouts CURRENT/HANDOFF,sauvegardes exactes,sept protégés avant/après/readback.

Une clôture bornée après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
