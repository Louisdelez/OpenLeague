# SYS-01.2-02 — Fiddlesticks : Dread, Paranoia et résistance magique, V568

Date UTC 2026-10-25T23:40:55.210946+00:00. F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et date de déploiement inconnus ; catalogue officiel4.20.1 distinct.

## Résultat intégré

Trois fiches : CH-FiddleSticks-PASSIF-SOURCE, CH-FiddleSticks-PASSIF-SIMULATION-CONTRAT et CH-FiddleSticks-PASSIF-SIMULATION.27 associations vers9 sources natives retenues ;48 liens vers24 points de code dans les fiches de simulation. SYS-01.2-02 référence ce lot. Les points restent `entry_boundary_only`, `provides_feature_consumer=false` pour Dread. Trois questions propres et quatre dépendances conservées.

Le moteur agrège les résistances de base, les objets et certains effets spécifiques déjà présents. Aucun consommateur de l’aura de Dread n’est identifié dans les chemins inspectés de statistiques, dispatch, pénétration et dégâts. Les phases publiques et diagnostics ci-dessous établissent leurs comportements actuels ; ils ne qualifient pas le passif historique. Aucun gameplay ou asset modifié.

## Sources retenues et exclusions

| Ressource | Identifiant |
|---|---|
| FiddleSticks.inibin | OLS-1c3d6951-d205-57dd-87b6-aff191d268f4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptFiddlesticks.luaobj | OLS-d5fa997d-e474-5377-b869-584114d10db1 |
| CharScriptFiddlesticks.preload | OLS-2b140468-c0db-53d6-bf7e-0f338506d8c0 |
| Paranoia Aura.inibin | OLS-70bdb06a-31d5-5ca6-8546-589636c9291f |
| Paranoia.inibin | OLS-d4e12686-d0ef-57df-8271-30d763ea65e6 |
| Paranoia.luaobj | OLS-bd0dc53e-04d5-531a-b786-d79124be4917 |
| ParanoiaMissChance.luaobj | OLS-c31b5fa6-fc28-57bc-a3dc-bfdc91935d36 |
| ParanoiaMissChance.preload | OLS-6198389c-1ffe-5b40-acc7-270fa6293827 |

Dix candidats ont été examinés ; neuf sont reliés au passif. Leurs tailles/SHA256 correspondent au registre et leurs tailles/MD5 aux projets RADS sélectionnés. Cette appartenance n’établit pas la priorité du chargeur historique. Les scripts se trouvent dans Characters/FiddleSticks/Scripts et les fichiers Paranoia dans DATA/Spells.

FiddleSticks.inibin lie Passive1LuaName à **Paranoia** et l’icône à Fiddlesticks_Paranoia.dds. Paranoia.inibin lie game_buff_tooltip_Paranoia ; Paranoia Aura.inibin lie game_buff_tooltip_Paranoia_Aura. Le tooltip en_GB ligne2449 dit que les unités ennemies proches de Fiddlesticks perdent10 points de résistance magique. La ligne2450 décrit l’effet sur la cible ; la description de personnage ligne4185 concorde et le nom ligne4361 vaut Dread. PassLev1Desc1 est absent du profil décodé : la description trouvée reste un candidat de localisation, pas une liaison de champ inventée.

Trois Lua retenus sont lus complètement, avec initialisations littérales reconnues et aucun prototype enfant. Le CharScript ne fournit ici aucun global littéral. Paranoia déclare PersistsThroughDeath et NonDispellable ; ces métadonnées ne prouvent pas la politique serveur à la mort. **ParanoiaMissChance** déclare BuffName="Paranoia Aura" ; son nom de fichier ne prouve pas un effet de raté. Deux preloads sont conservés. Les deux INIBIN de buff contiennent leur liaison de tooltip ; aucune valeur de rayon n’en est déduite.

Fearmonger_marker.luaobj, dixième candidat, déclare BuffName="Drain" et une particule Fearmonger_cas.troy. Il est conservé dans la découverte et ses empreintes, mais exclu des sources faisant autorité pour Dread. Les résultats de recherche large contenant NocturneParanoia ou NightmareBotSpiritNocturneParanoia ne sont pas utilisés comme liaisons de ce passif.

Huit références communautaires locales : CharScript, Q/W/E/R, statistiques et deux profils Paranoia. Le CharScript est vide. Leur provenance reste communautaire ; leur présence ne reconstitue pas le corps du serveur original.

## Phases publiques de proximité

Trois simulations utilisent le vrai openleague_core non-test et Map10. Les acteurs se déplacent par commandes publiques, puis s’arrêtent à250 unités. Aucun changement direct de position, santé, mana, or, XP, rang ou effet pendant ces phases. Dans le contrôle objet, Annie achète publiquement l’objet1033, qui ajoute25 de résistance magique.

| Acteur voisin | Objet de la cible | RM initiale et durant300ticks | Refus publics |
|---|---|---:|---:|
| fiddlesticks | None | 30.0 | 15 |
| fiddlesticks | 1033 | 55.0 | 15 |
| garen | None | 30.0 | 3 |

La cible est Annie rouge ; l’acteur voisin est bleu.300 ticks représentent10 secondes au taux courant de30Hz. La résistance est vérifiée à chaque tick et des snapshots sont conservés tous les30 ticks. Les refus portent sur joueur inconnu, attaque de soi, slot invalide, puis douze Learn/Cast/CastAt de Fiddlesticks par scénario concerné. Les33 refus conservent le snapshot entier.

La résistance de la cible reste30 près de Fiddlesticks comme près de Garen ; elle vaut55 avec l’objet1033. L’objet prouve que le chemin de statistiques n’est pas simplement figé. **250 est une distance d’essai, pas le rayon natif établi de Dread.** Le résultat de proximité est confronté au code actuel ; il ne remplace pas la qualification du rayon, des cibles, de la cadence ou des cas particuliers natifs.

## Diagnostics de dégâts séparés

Après chaque phase publique, le script appelle explicitement l’API d’événement serveur `Simulation::apply_damage(source,target,100,Magical)`. Cet événement est préparé par le diagnostic : il ne représente pas un sort public réussi de Fiddlesticks, un projectile accepté ou une preuve du déclencheur natif. Les rubriques du runtime séparent les deux phases.

| Résistance de la cible | Dégât magique brut de diagnostic | Dégât après mitigation observé |
|---:|---:|---:|
|30|100|76.92308044|
|55|100|64.51612854|
|30, contrôle Garen|100|76.92308044|

Les résultats correspondent au calcul courant100×100/(100+RM), avec tolérance float32 ; la santé retirée est contrôlée et la résistance reste inchangée. Trois refus par simulation — brut non fini, brut négatif, cible inexistante — conservent le snapshot, soit9 refus de diagnostic. Ces preuves portent sur le chemin de mitigation actuel, pas sur une amplification native due à Dread.

Les24 points relient initialisation, actions, refus de sorts, statistiques, achat/bonus, cible, tick, snapshot, dégâts et pénétration. Les ajustements d’Exhaust, TrundleR et bouclier d’Annie sont identifiés comme composants distincts ; aucun n’est promu en implémentation de Dread. La réduction de résistance de la cible ne doit pas être confondue avec une pénétration propre au seul lanceur.

## Exécutions et conservation

Premier essai : compilation code0, exécution code101. Le script cherchait la résistance de l’objet sous `bonuses.magic_resist`, alors que le JSON réel expose `magic_resist` au niveau de l’objet. Cet échec, ses sources, verrou, binaire, journaux et commandes sont conservés. Un dossier et un exécutable distincts corrigent uniquement cette lecture du diagnostic.

Exécutable corrigé `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-fiddlesticks-passive-dread-probe-qualified.exe` ; 6066688 octets ; SHA256 `72b41ff21a6ebc08f85967fb4c344db2d8bfbd46f2ce57cd862f361b062750a0`. Build/run code0. Cargo.lock privé aligné avec le verrou racine ;1158 entrées core/ressources et chaîne historique inchangées. Le runtime conserve V567 et la chaîne antérieure, ainsi que l’essai initial V568. Aucun client ou serveur historique exécuté.

Inspection/prepare/check/publish/audit code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite :4 destinataires,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques préservés. Lecteurs réels Store.task/copy_text/summary/dépendances et résolution de trace vérifiés ; intégrité et synchronisation idempotente contrôlées. Identifiants, hiérarchie et inconnues identiques en octets ;3 fragments de trace changés,42212 conservés.

Revue courante :42215 exigences,98948 sources,3280 consommateurs ;3280 ancres exactes,zéro divergence constatée.26189 questions ouvertes et5517 résolues inchangées. Ce contrôle structurel ne re-hashe pas toutes les98948 sources et ne mesure pas un taux d’achèvement du jeu. Les empreintes sélectionnées sont vérifiées séparément.

## Manques et limites

- Rayon exact, cibles éligibles, cadence de l’aura, délai après sortie du rayon, mort/réapparition et cumul de plusieurs Fiddlesticks.
- Politique serveur native des10 points, ordre avec les autres modificateurs et cas de résistance négative.
- Consommateur effectif de l’aura dans le moteur : résistance de la cible et conséquences sur les dégâts infligés par les alliés.
- Sorts propres au champion, projection réseau réelle, HUD, animation, VFX et audio à qualifier séparément.
- Défaut de déplacementV564 toujours ouvert. Aucun manque de modèle ou texture n’est prouvé par ce lot.

## Fichiers actualisés

completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json ; reçu reference_requirement_trace_sources/fiddlesticks-passive-dread-links-v568.json et preuve fidelity_fiddlesticks_passive_dread_links_v568.json. Couverture, plan, checkpoint,CURRENT,HANDOFF et deux bases locales actualisés avec sauvegardes. Scripts et journaux dans revision568_FiddleSticks sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun statut ou case fermé automatiquement.

Continuer SYS-01.2-02 depuis revision569_trace_review/REVIEW.json. V568 FiddleSticks publiée/auditée:3fiches,9sources retenues parmi10candidats,27associations,24points/48liens limités. Trois phases publiques à250unités pendant300ticks:RM30/55/30,33refus. Trois événements serveur séparés apply_damage(100,Magical):76.9231/64.5161/76.9231,9refus;ne pas les présenter comme sorts ordinaires. Le tooltip natif décrit10points de réduction;rayon,éligibilité,cumul,persistance et politique serveur restent ouverts. ParanoiaMissChance lie Paranoia Aura,aucun effet de raté déduit. Fearmonger/Drain et Nocturne exclus de Dread;PassLev1Desc1 absent non inventé. Runtime initial build0/run101 (mauvais chemin JSON objet) conservé;qualified build/run0. Préserver INPUTS_BEFORE.previous_artifacts du runtime qualifiedV568,qui conserveV567 et la chaîne antérieure. Aucun statut/case/inconnu fermé. Reprendre le prochain passif restant dans la file du lecteur générique,par exemple Fizz,après inspection réelle;les composants existants ne valent pas passif intégré. Défaut de déplacementV564 ouvert;goal actif.
