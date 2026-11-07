# SYS-01.2-02 — Azir, passif : liaison de l’icône et des états au HUD, V1199

3 novembre 2026. Unité `AUD-SYS-01.2-02-AZIR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis décision racine ; HUD complet, mécanique, interaction SunDisc, rendu et acceptation ouverts.

## 1. Exigence et frontière

`CH-Azir-PASSIF-PRESENTATION-HUD`, `OLF-f5aed756-9ff0-5c18-8934-d4c5ec2efed1`, exige icône, texte, rang et états. Le lot examine séparément les branches CDR→AS et Disque solaire dans le HUD courant. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Azir-PASSIF-NETWORK`. L’inconnue `OLU-f5cf5452-bbda-5a77-8394-5a7e14933e41` reste ouverte.

V559 traite des sources/frontières et V1185 clôt une liaison SOURCE bornée. Ces acquis, les diagnostics anciens et les sélecteurs communs sont réutilisés sans transfert au HUD ni nouveau comptage de leurs clôtures.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. V559 fournit 23 identités natives réutilisées. V1185 distingue le CharScriptAzir racine de 56 octets : SOURCE compte 29 relations/24 identités ; HUD lie Azir.inibin et ce CharScript. L’absence locale de `Azir/Scripts` ne devient pas une absence de ressources ou serveur.

L’INIBIN déclare `Passive1LuaName=AzirPassive`, `Passive1Icon=Azir_Passive.dds`. Onze chunks client n’ont pas de prototype de callback enfant ; huit ont une limite NEWTABLE du lecteur de littéraux. Leurs `globals={}` restent non qualifiés : BuffName, BuffTextureName et PersistsThroughDeath dans la table des constantes ne sont pas des affectations reconstruites. Trois CharScripts ont des globals vides qualifiés. Aucune VM ni corruption déduite ; cinq preloads ne prouvent pas un rendu.

Ressource documentaire nouvelle, sans OLS : `DATA/Characters/Azir/HUD/Icons2D/Azir_Passive.dds`, 2176 octets, 64×64 DXT1, SHA-256 `8d0a0dca04566f5782cabfb69e2652c79aa256f028fa62443697cc27d60f1167`. Chemin/taille/MD5 concordent au manifeste sélectionné lol_game_client 0.0.1.7, membre 0.0.0.249. Priorité, sélection effective, pixels et rendu inconnus.

Quatre textes en_GB : lignes 1697/1698/4160/4336, nom Shurima’s Legacy. Le miroir F correspond à l’identité native héritée ; texte D non rouvert. Will of the Emperor annonce 1,25 % AS pour 1 % CDR ; `@f1@` est le bonus courant affiché, sans fournisseur qualifié. Disc of the Sun décrit ruine cliquable, trois minutes de recharge, une minute de désintégration et exclusions de tourelles ennemies Nexus/inhibiteur. Ces textes ne sont pas une formule exécutée ou des durées mesurées. Les niveaux TowerClicker 1/4/7 ne définissent pas les rangs absents d’Azir.

## 3. Consommateurs courants des deux branches

Le CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` demeure `champion_catalog`, appelé par `Simulation::new` : identité/statistiques sans passif. Azir a 350.56 mana/type Mana local. Le digest du miroir Stats reste distinct du natif ; aucune recherche d’origine répétée.

Provider/StartupHud et plugins normaux existent. Quatre InventoryIcon Azir QWER sont adoptés, aucune entrée unresolved. Les cadres/textes QWER-D/F et le Buff0/BuffStack0 fixé à Ezreal ne fournissent pas un passif Azir.

**CDR→AS :** les formules relues exposent CDR et cadence séparément, sans conversion Azir. Structures Champion/Effects/Snapshot, projections et 18 textes montés ne fournissent ni bonus AS/CDR ni `f1`. Les deux hits client AS/CDR sont des catégories d’objets de boutique, pas un affichage de statistique passive. Aucun fournisseur/binding HUD qualifié dans ces corps.

**SunDisc :** les états disponible/canalisation/recharge/durée et audiences ne sont pas qualifiés dans les payloads/sélecteurs inspectés. Le clic projette le curseur ; picking filtre morts/alliés puis produit Attack, Move ou Cast contextuel. V1185 borne la configuration Map10 et ses spawns/morts ordinaires, sans route de ruine qualifiée. Les descripteurs de modèles SunDisc/TowerClicker et noms de clips SpellP/channel ne créent pas un état HUD. Aucune absence globale d’assets ou de comportement historique par mode n’est déduite.

Mana, F3, Pyromanie d’Annie, modèle/curseur/tour et PV projetés restent distincts de ces deux branches.

## 4. Attendu, observé et contrôles exécutés

Attendu : icône/textes/bonus CDR→AS et états SunDisc reliés au HUD ordinaire avec audiences qualifiées. Observé : ressources et routes génériques établies, aucun binding des deux branches identifié dans les sélecteurs bornés. Sources 32/32 et consommateurs 22/22 contrôles documentaires ; un DDS lu, 2176 octets.

Seize pins/29 fenêtres partagés concordent ; 1219 chemins sont hérités sans recensement. Les 21 fichiers/entrées V1185 incluent les 11 fichiers de frontières V559 ; leurs 24 ancres concordent, sans addition artificielle. Les périodes historiques 58/58/50 ticks, 18 impacts et 51 refus V559 sont héritées/non rejouées. Codex et Dague ne prouvent pas SunDisc ; aucune ruine GUI exercée. Aucun runtime/build/GPU/audio/réseau/REA. Gardes/omissions lues statiquement, aucun refus HUD Azir exécuté, ancien binaire non requalifié.

## 5. Écarts et inconnues

Sélection de l’icône, substitutions/rangs, conversion et plafonds/arrondis, producteur/états/audiences, ruines admissibles, activation/propriété/statistiques, durée/recharge/interruption, lifecycle/reconnexion et rendu restent ouverts. Les constats négatifs sont bornés aux noms/corps/configurations inspectés ; autres alias/runtime non globalement exclus.

## 6. Correction et reprise

Réutiliser `CH-Azir-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : qualifier ressources/textes/f1/rangs des deux branches ; définir états/audiences autoritaires ; intégrer de vrais widgets avec refus des entrées absentes/ambiguës ; vérifier nominal/transitions/confidentialité/fraîcheur/reconnexion/rendu ; séparer QWER/mana/F3/stats/tour/curseur/monde ; obtenir l’acceptation humaine séparée. Reprise sur primaire ou producteur/consommateur précis modifié, sans rejeu identique V559/V1185.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_azir_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux, result.json et relecture indépendante. Vérification statique partielle ; fonctionnelle non exécutée ; acceptation À VALIDER. Publication racine limitée au rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
