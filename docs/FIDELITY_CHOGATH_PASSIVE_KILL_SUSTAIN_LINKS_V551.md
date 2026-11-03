# SYS-01.2-02 — Cho’Gath : Carnivore, V551

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Chogath-PASSIF-SOURCE, CH-Chogath-PASSIF-SIMULATION-CONTRAT et CH-Chogath-PASSIF-SIMULATION reçoivent21 arêtes vers7 sources natives. Les deux fiches de simulation reçoivent34 liens vers17 points du code courant, qualifiés `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence le lot ; lecteurs et chargeur partagés restent conservés sans promotion en implémentation de Carnivore.

Phases, lots, prérequis et propriétaires des questions sont relevés dans le reçu. Trois questions propres et quatre dépendances sont conservées. Aucun inconnu ajouté ou fermé, aucun statut, critère, case, note ou historique manuel modifié.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Chogath.inibin | OLS-8b685c08-c3ed-56a5-9b51-e35a2066348c |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Carnivore.inibin | OLS-b131aa0f-d5cf-5f48-9b65-d1e2fe922a99 |
| Carnivore.luaobj | OLS-7c9ebe54-6fb1-5a7e-98ef-f2b165a837c6 |
| Carnivore.preload | OLS-1ff06b4c-1be2-5cac-a163-0d767d672d6f |
| CharScriptChogath.luaobj | OLS-e0205a09-e0bb-56a5-87b2-4b0ebaddf78e |
| CharScriptChogath.preload | OLS-bdf93f10-6a50-5125-aaf0-40c4b8fd26ef |

Les7 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets RADS sélectionnés. La découverte du tour précédent est revalidée et réutilisée. La sélection ne démontre pas une absence mondiale de corps serveur original.

La définition et le BuffName concordent sur `Carnivore`, avec l’icône `GreenTerror_TailSpike.dds`. L’INIBIN lie directement `game_buff_tooltip_Carnivore`, ligne1774 : tuer un ennemi restaure f1PV et f2mana. La description liée4175 précise que les valeurs augmentent avec le niveau. **Les fournisseurs f1/f2 et la formule native ne sont pas résolus.** Passive1, la description littérale Passive1Desc et les trois niveaux sondés sont absents ; aucune valeur par défaut n’est inventée.

Deux Lua entièrement parsés, sans prototype de callback enfant. Carnivore déclare nom, icône, PersistsThroughDeath et NonDispellable ; CharScriptChogath ne contient qu’un RETURN. Deux preloads sont conservés, dont `chogath_battlecast_heal.troy` et `globallifesteal_buf.troy`. Ces noms ne prouvent ni soin appliqué, ni vol de vie, ni présentation d’un skin. Trois références communautaires restent distinctes ; leur CharScript C# vide ne devient pas une implémentation serveur originale.

## Consommateurs et exécution

Le chemin inspecté relie join/stats, Attack, tick d’attaque, libération mêlée, impact et vol de vie, dégâts/mort de champion, crédit/récompenses, XP et gain de niveau, soin commun, régénération, tick général, refus de Cast, classification de ressource et témoin Trundle. `world.damage_unit` est également lié comme **chemin statiquement inspecté, non exécuté dans ce diagnostic**.

Deux parties Map10 publiques : Cho’Gath contre Garen, puis Trundle contre Garen comme témoin séparé. Déplacements vers des positions praticables, arrêt, attaques et élimination sont effectués par les commandes normales. Aucune vie, mana, or, XP, position ou dégât injecté ; aucun événement artificiel de soin ou de mort. Garen porte quatre attaques ordinaires au futur tueur pour créer un déficit de PV, puis est arrêté. Le tueur porte14 attaques ordinaires non critiques et obtient une élimination. Les acteurs restent niveau1, le tueur reste vivant et la partie n’est pas terminée.

| Cas | Tick du kill | PV avant | PV après régénération du tick | PV observés après kill | Soin supplémentaire |
|---|---:|---:|---:|---:|---:|
| Cho’Gath |1569|441.1177673|441.1772766|441.1772766|0|
| Trundle témoin |1532|481.2051392|481.2680054|493.5935974|12.3255920|

Cho’Gath possède574.4000244PV maximum : le résultat est observé avec environ133PV manquants, donc sans écrêtage d’un soin par le plafond. Il reçoit165XP et400or, avec niveau et PV maximum inchangés ; le vol de vie vaut0. Le gain de niveau et le vol de vie n’expliquent donc aucun soin du kill. Les30ticks suivants n’ajoutent que la régénération de base. Le diagnostic ne conclut pas à un montant natif précis à partir du supplément0.

Le témoin Trundle reçoit12.325592041015625PV supplémentaires, cohérents à0.002PV près avec sa règle **communautaire actuelle** de2% des616.2800293PV maximum de Garen, soit12.325600624084473. Ce résultat démontre un chemin courant de soin sur mort pour un autre champion ; **il ne qualifie pas Carnivore ni une règle native de Trundle**. Le témoin reste également sous son plafond, sans gain de niveau ni vol de vie. Ses30ticks suivants n’ajoutent que la régénération.

Mana plein avant et après les impacts : **la restauration de mana de Carnivore n’est pas observable et reste non qualifiée**. Les quatre Cast ciblés de Cho’Gath renvoient `champion spell not implemented`. Aucun coût artificiel n’est injecté pour présenter un sort fonctionnel. Les autres routes de dépense, niveaux, morts de sbires/monstres, invocations et attribution indirecte ne sont pas testés.

14 refus publics : cinq par partie (joueur/cible inconnus, cible soi-même, objet inconnu, emplacement de vente invalide), plus les quatre Cast de Cho’Gath. Chaque refus possède sa propre comparaison de snapshot complet inchangé. Au total8 attaques entrantes,28 sortantes,2 kills de champion et60ticks après kill sont observés ; un seul des deux scénarios est un cas Cho’Gath.

## Contrôles et conservation

Build/run0 ; core non-test réutilisé du cache Cargo.1158 entrées source/ressource et anciens artefacts sélectionnés exacts. Identités/checksums du verrou privé alignés sur le Cargo.lock racine. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-chogath-passive-kill-sustain-probe.exe` ;6052352octets ; SHA-256 `5ebedc1970e9234a093c0ac3a4ef897c392334a5e743fccfc14e74dae0345d85`. Commandes, outils, sources, manifestes, verrous et logs sont identifiés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision551_Chogath_passive_probe\OBSERVATIONS.json`. Aucun processus historique, VM originale, GPU, réseau, audio ou contrôle visuel exécuté.

Inspection,prepare,check,publish,audit réussis.72 associations invalides et4 graphes invalides refusés, dont Trundle assimilé à Carnivore, mana plein assimilé à restauration, mort d’unité déclarée exécutée sans preuve, champ absent remplacé, source/binaire modifié, question étrangère et dépendance retirée. Ces contrôles portent sur la traçabilité et sa conservation, pas sur une acceptation du jeu.

Deux bases réelles :4 destinataires actualisés par base,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, intégrité et synchronisation idempotente vérifiés.3 fragments changent,42212 restent exacts ;42211 autres objets tâche/trace conservés. IDs, hiérarchie et inconnus identiques en octets.

Graphe42215 exigences,98880 sources,2942 consommateurs ;26189 questions ouvertes/5517 résolues.2942 ancres et527 fichiers actuels exacts, zéro divergence ;17 auxiliaires conservés. Aucun nouveau recensement physique des98k sources.8336CH au seul chargeur partagé est une file de recherche, pas un taux d’achèvement.

## Fichiers et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/chogath-passive-kill-sustain-links-v551.json ; preuve docs/fidelity_chogath_passive_kill_sustain_links_v551.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Scripts de diagnostic et de livraison archivés. Aucun code de jeu ou asset modifié, aucun stage/reset/commit.

Restent ouverts : corps serveur Carnivore, f1/f2, croissance native par niveau, restauration de mana, cibles non champion, attribution et ordre, mort/réapparition, modificateurs et présentation. V550 et tous les artefacts antérieurs restent conservés.

Continuer SYS-01.2-02 depuis revision552_trace_review/REVIEW.json. V551 Chogath publié/audité :3 fiches,7 sources natives,21 arêtes,34 liens vers17 frontières ;3 questions propres/4 dépendances conservées. Deux parties publiques Chogath/Garen et témoin Trundle/Garen :4 coups entrants puis14 sortants et1 kill chacune,sans injection. Cho au1569 :441.11777PV→441.17728PV exactement par régénération,extra0 avec133PV manquants. Trundle au1532 :extra12.32559PV selon sa reconstruction communautaire2%,pas Carnivore. XP165/or400,niveau1 inchangé,vol de vie0 ;30ticks suivants extra0. Mana plein,restauration non observable ;4Cast Chogath refusés,14refus publics individuels. World-unit death inspecté statiquement,non exécuté. f1/f2,niveaux,cibles/attribution,ordre et présentation ouverts. Aucun gameplay modifié/passif accepté. Ne pas republier ni relancer sans cause nouvelle. Examiner ensuite Alistar/Trample :texte4152 déclenchement sur sort,texte2782 dégâts proches et traversée des unités. Identifier les bindings AlistarTrample/Trample Buff,les règles natives et les consommateurs actuels de Cast,zone/dégâts et collision ;les sorts refusés ne constituent pas un déclencheur exécuté.101 autres contrats/parents de passifs restent à examiner ;8336CH au seul chargeur partagé est une file de recherche,pas un taux de complétion. Goal actif. Découverte Alistar déjà effectuée et revalidée :revision552_Alistar_discovery/OBSERVATIONS.json,8 sources natives,2 bindings de buff,2 Lua sans callbacks enfants,1 preload et5 références communautaires. Deux chemins CharScriptAlistar luaobj/preload absents du répertoire sélectionné,listing conservé ;pas une absence mondiale de serveur. La définition Colossal Strength et son buff sont distincts d’AlistarTrample→Trample Buff. Texte1791 :3s,dégâts magiques par seconde,f1/f2/f3,double dégâts aux sbires et traversée des unités ;fournisseurs/rythme/rayon non qualifiés. Ancien texte de réduction des dégâts de tourelle et niveaux6/12/18 non adoptés. Runtime,inspection qualifiée et publication restent à faire. Inspecter aussi cast_at dans annie_w.rs ;ne pas confondre marche générique,collision de terrain et phasing conditionnel de Trample. Ne pas relancer la découverte sans cause nouvelle.

## Supplément de fraîcheur — contrôle source/consommateur au 2026-11-02

Le reçu V551 et sa preuve de vérification sont toujours byte-identiques (SHA-256 du reçu : d44fd571bacc31b0f8984f37bd4a1f38b5f473fc9afd52cb393b3c2a66a69b9d; preuve passed=true). Chogath.inibin (2 549 octets, SHA-256 0c6e8eba62b143693e8dcceef9cc5f9bb8bfb0dce9a036b2d15e56582d7c7dcf) et Carnivore.inibin (41 octets, SHA-256 bfd8835239197b197ed73d3a9b5dad7bc831ed300131f0ea70980ed1efb99745) conservent leurs pins. Les 17 ancres Rust du reçu sont présentes aux lignes enregistrées et les empreintes des 17 fichiers correspondent encore aux pins V551.

Le contrôle réutilise le diagnostic V551 sans le relancer : après une élimination de champion, Cho’Gath n’a reçu que sa régénération de base malgré un déficit de PV; mana plein, la restauration de mana est restée non observable. Le soin communautaire de Trundle demeure un témoin distinct. La mort d’un sbire/monstre reste inspectée statiquement et non exécutée. Source et frontières courantes sont fraîches; le producteur natif, f1/f2, la règle de niveau, l’attribution sur unités et l’acceptation restent ouverts. Aucun test ni build relancé dans ce supplément. Le premier comparateur d’empreintes a rejeté à tort les pins à cause d’une normalisation incorrecte des séparateurs Windows; la comparaison corrigée confirme 17/17 sans divergence réelle.