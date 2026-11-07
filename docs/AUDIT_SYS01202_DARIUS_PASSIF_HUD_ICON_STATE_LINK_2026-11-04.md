# SYS-01.2-02 — Darius : liaison d’Hemorrhage au HUD, V1207

4 novembre 2026. Unité `AUD-SYS-01.2-02-DARIUS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Darius-PASSIF-PRESENTATION-HUD`, `OLF-0b6b79eb-e9c0-5136-9674-e07c038ef2c2`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Darius-PASSIF-NETWORK`. L’inconnue `OLU-a52c80e9-064d-5194-9a6b-8d29ba00df56` reste ouverte.

Ce lot relie ressources, marker/debuff/cumuls et vitesse aux consommateurs HUD inspectés, sans décider leurs audiences ou logique serveur. V562, les autres compteurs et les voies génériques ne transfèrent aucune clôture. Aucune règle physique/Noxian Might plus récente n’est importée dans la référence4.20.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Quatorze identités V562 sont réutilisées, sans rehash des payloads natifs. SOURCE porte20relations/14identités ; HUD deux relations, définition Darius et CharScript : `OLS-ff079866-0bd8-5a42-8803-2df93d4ad59e`, `OLS-10ef20eb-2d3e-57d4-944f-f3705a1a13a1`.

`Passive1LuaName=DariusHemoMarker` et `Passive1Icon=Darius_Icon_Hemorrhage.dds` sont déclarés. Hemo/Internal/Marker/Visual/SpeedKuoManager restent distincts ; les références brutes DeadlyVenom_Internal ne deviennent pas des alias ou des règles importées. Six Lua hérités littéraux sans prototype enfant, CharScript vide et flags PersistsThroughDeath/NonDispellable/DoesntTriggerSpellCasts/IsDeathRecapSource ne prouvent ni serveur, persistance ni bridge de récapitulatif.

Un inventaire exact a précédé la lecture des deux DDS,11232octets :

| Chemin sous DATA | Octets / format | Membre |
|---|---|---|
| Characters/Darius/HUD/Icons2D/Darius_Icon_Hemorrhage.dds | 5616 / 64×64 DXT5,7mips | 0.0.0.172 |
| Spells/Icons2D/Darius_Icon_Hemorrhage.dds | identique | 0.0.0.95 |

Un contenu SHA-256 `788ff3c5583e36e9a298df68a994e0f0ee1032236e57234dca8ce175168237a6`. Taille/MD5 concordent au manifeste sélectionné lol_game_client0.0.1.7. Aucun OLS créé ; priorité, variante, sélection et pixels rendus inconnus.

Le résumé V562 omettait les références littérales des preloads. Après deux lectures documentaires ciblées, la découverte déjà épinglée V562 a été capturée byte-identique sur E,284582octets/SHA `a6f83dac0abe00d25a8c6a4c5658f7c2acd23609c10f48fa7ed769f8bd100c21`. Original F:/OpenLeague-work documenté, non rouvert au gate ; gardes de racines inchangées. Preloads846/1509octets :12références sorts/particules et17particules, dont compteurs01..05/minion. Ce sont des déclarations, pas cinq icônes HUD, un allocator ou un rendu.

Quatre textes exacts du miroir F en_GB,1815/1816/4177/4353, séparent Hemorrhaging/SourceName et Hemorrhage/f1/f2. Ils annoncent dégâts **magiques** sur cinq secondes, cinq cumuls et5%vitesse par champion ennemi ensanglanté. Fournisseurs, cadence, refresh/expiration et état autoritaire restent inconnus. Six rangs absents et descriptions héritées+40/+60/+80%régénération mana ne sont pas des valeurs par défaut ou règles Darius. Provenance font V562/reçu Ahri exact/empreinte F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites de lecteurs SOURCE ne sont pas des producteurs Hemorrhage ou widgets.

Provider/StartupHud et plugins ordinaires sont montés. Quatre QWER principaux, zéro variante et zéro unresolved, ne prouvent pas des capacités implémentées. Les18textes/11barres/14widgets QWER-D/F sélectionnés n’identifient aucun binding Hemo icône/texte/rang/marker/cumul/debuff/vitesse. Buff0, texture BuffIcon0 et BuffStack0 restent liés à Ezreal ; F3/Annie4 et stun conditionnel QWER restent distincts. Recherche .rs core/client/server corroborative après corps, sans absence globale d’alias, code ou assets.

movement/stats consomment vitesse, bottes, effets et caps, sans compter les champions ensanglantés. Ignite possède sa propre voie périodique **True**, avec cadence/remplacement reconstruits : elle n’est pas Hemo magique. mitigate/apply_damage et le récapitulatif Magical agrégé existent ; le panneau conditionnel propriétaire/mort/session affiche «Magique», sans identité capacité/buff ou état Hemorrhage. Le flag natif IsDeathRecapSource ne qualifie pas ce bridge. Sept entrées auxiliaires sélectionnées et leurs helpers directs restent du code/configuration courants, pas une réimplémentation native du passif.

## 4. Attendu, observé et contrôles

Attendu : états autoritaires, cumuls et ressources reliés aux audiences/widgets qualifiés, avec affichage vérifié. Observé : sources identifiées et chemins génériques réels, sans liaison Hemo spécifique dans le trajet inspecté. Sources49/49 et consommateurs37/37 contrôles documentaires ; deux DDS lus, un parse manifeste. Gardes, coûts/rangs, finitude des pools, D/F et omissions lus seulement ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, onze fichiers/22sites V562 et deux readers/six sites SOURCE concordent. Auxiliaires V1200 2/11,V1201 1/3,V1202 2/3,V1203 2/9,V1204 1/2,V1206 3/4 réutilisés ; sept pins/sept fenêtres directes sélectionnés. Inventaire1219 hérité sans census ;1350pins source V562, dont corpus1158, non rehashés globalement. Attentes initiales erronées12fichiers et preload1618octets refusées puis corrigées vers11 et1509, archives exactes conservées ; aucune dérive de source ou corruption DDS inférée.

V562 conserve quatre cas,16impacts physiques ordinaires et quatre fenêtres180ticks après Stop, soit720ticks. Aucun saignement observé ; cinq attaques ne prouvent pas cinq cumuls effectifs. Vitesse340/365 après bottes1001 et MR32.1/57.1 après cape1033 sont contrôles ordinaires : ni bonus natif5%ni mitigation d’un DoT absent qualifiés. Les60refus atomiques restent historiques, sans déclenchement par sort. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté.

## 5. Écarts et inconnues

Substitutions f1/f2/SourceName, formule, cadence/refresh/expiration, cumuls effectifs, sorts, multi-cibles, vitesse/portée/caps, rang, lookup/alias/allocation, audiences, confidentialité, mort/reconnexion et rendu restent ouverts. DoT Ignite, bottes, dégâts/récapitulatif génériques et preloads ne remplacent pas Hemorrhage. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Darius-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20 ; qualifier état source/cible/cumul/durée/vitesse et audiences autoritaires ; intégrer widgets/refus sans faux zéro/activation ; vérifier une à cinq charges effectives, attaques/sorts, multi-cibles/refresh/expiration, mort/reconnexion et confidentialité avec rendu identifié ; séparer Physical/IgniteTrue/bottes/recapMagical/Ezreal/Annie de Hemo ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé ni règle moderne.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_darius_passive_hud_20261104` : source_worker/sourceproof.json, copie historique/capture, reçu consommateur, scripts/journaux/échecs et archives, result.json, finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
