# SYS-01.2-02 — Cho’Gath : liaison de Carnivore au HUD, V1205

4 novembre 2026. Unité `AUD-SYS-01.2-02-CHOGATH-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Chogath-PASSIF-PRESENTATION-HUD`, `OLF-ed8327d2-1c71-5c4a-9fad-23c9e1045937`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Chogath-PASSIF-NETWORK`. L’inconnue `OLU-6f2493b3-0627-5c90-8023-21d84b7adfde` reste ouverte.

Le lot relie les ressources Carnivore aux consommateurs HUD inspectés, sans qualifier formule, déclencheur, montants ou audiences. V551, son supplément du 2 novembre et V166 restent des périmètres datés distincts, sans transfert de clôture ni nouvel essai de leurs diagnostics.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Sept identités V551 sont réutilisées. Le supplément Nov2 confirme notamment Chogath.inibin/Carnivore.inibin ; aucun rehash de ces métadonnées n’est revendiqué aujourd’hui. SOURCE porte 10 relations/7 identités ; HUD une relation vers la définition, `OLS-8b685c08-c3ed-56a5-9b51-e35a2066348c`.

`Passive1LuaName=Carnivore` et `Passive1Icon=GreenTerror_TailSpike.dds` concordent avec les littéraux du buff. Deux Lua hérités sans prototype enfant, CharScript limité à RETURN et deux preloads ne prouvent pas le serveur. PersistsThroughDeath/NonDispellable ne qualifient pas décès/reset/persistance ; les trois niveaux passifs interrogés absents ne prouvent ni zéro ni rang non applicable.

Un inventaire du manifeste a délimité les deux DDS avant lecture, 8448 octets au total :

| Chemin sous DATA | Octets / format | Membre |
|---|---|---|
| Characters/Chogath/Info/GreenTerror_TailSpike.dds | 4224 / 64×64 DXT5 | 0.0.0.40 |
| Spells/Icons2D/GreenTerror_TailSpike.dds | identique | 0.0.0.25 |

Un seul contenu SHA-256 `bed31f6628be11f24cb0a9adaaa49f4e4532b969214d8dbfc507824a709dcafb`. Taille/MD5 concordent au manifeste sélectionné lol_game_client0.0.1.7. Aucun OLS créé ; priorité, variante effective, pixels et rendu inconnus.

Trois textes en_GB du miroir F, lignes 1774/4175/4351, identifient Carnivore : tuer un ennemi restaure `f1` PV et `f2` mana, avec croissance annoncée selon le niveau. Fournisseurs, formule, niveaux et catégories éligibles restent non qualifiés. L’identité du miroir est reliée aux preuves datées et à son empreinte F ; Font D non relu, locale effective et rendu ouverts. L’attribution documentaire du reçu source a été corrigée avec archive exacte, sans rejouer les payloads.

V166 concerne le fournisseur d’un Chogath_Skin02_EventLookupTable.csv observé vide dans son contexte fourni ; liaison d’instance+20, ouverture/consommateur et caractère intentionnel restent ouverts. Aucun lien Carnivore/HUD/skin n’en découle. Les noms preload `chogath_battlecast_heal.troy` et `globallifesteal_buf.troy` ne prouvent ni soin, vol de vie ni présentation Battlecast. Cette branche n’est pas rouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq lecteurs SOURCE ne deviennent pas des producteurs Carnivore ou widgets.

Provider/StartupHud et plugins ordinaires existent. Quatre QWER Rupture/FeralScream/VorpalSpikes/Feast sont configurés, zéro unresolved ; cela ne qualifie pas les capacités implémentées. Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés n’identifient aucun binding Carnivore icône/texte/rang/état. Buff0, texture BuffIcon0 et BuffStack0 restent liés à Ezreal ; Annie4, F3 et stun conditionnel QWER restent distincts. HP/Mana ordinaires sont lus par identité de connexion, sans identifier la cause Carnivore.

heal, regeneration, apply_damage/reward/award_experience, Snapshot/Effects et kill_events fournissent soins plafonnés, régénération, crédit/récompenses et croissance des pools. Trundle est une branche distincte. Aucun producteur Carnivore n’est identifié dans les corps nommés. Deux JSON compilés sélectionnés restent des entrées locales/dérivées, pas des identités natives brutes.

La recherche nommée est bornée aux .rs core/client/server après lecture des corps ; zéro hit ne signifie pas absence mondiale. Les noms connus dans animation_scale_reference_cases.json sont une fixture modèle/scale hors requête, sans consumer HUD ou passif.

## 4. Attendu, observé et contrôles

Attendu : ressources et états autoritaires reliés aux audiences et widgets qualifiés. Observé : ressources identifiées et consommateurs ordinaires réels, sans liaison Carnivore spécifique dans le trajet inspecté. Sources 41/41, consommateurs31/31 contrôles documentaires ; deux DDS lus, un parse manifeste. Gardes/omissions et refus Learn/Cast/CastAt lus seulement ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29 fenêtres communs, douze fichiers/17 ancres V551 et deux readers/six sites SOURCE concordent. Le supplément ancien dit «17 fichiers» ; le compte exact est17sites dans12chemins, phrase historique préservée. Auxiliaires V1200 2/11,V1202 2/3,V1203 2/9,V1204 1/5 réutilisés ; deux JSON/sept fenêtres sélectionnés. Inventaire1219 hérité sans census.

V551 conserve deux parties : une Cho’Gath, un témoin Trundle, chacune quatre attaques entrantes puis quatorze sortantes et un kill de champion. Cho ne reçoit que sa régénération, supplément0 avec environ133PV manquants ; cela ne fixe pas un montant natif. Trundle reçoit12.32559PV selon sa reconstruction communautaire2 %, ni Carnivore ni Trundle natif qualifiés. Mana plein : restauration non observable. Niveau1, vol de vie0, trente ticks après chaque kill et14refus restent historiques. world.damage_unit est statique, non exécuté dans ces essais. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté.

## 5. Écarts et inconnues

Sélection/lookup, substitutions f1/f2, formule/niveaux, rang applicable, cibles/crédit/ordre, restauration mana, états, décès/reset, audiences, confidentialité, fraîcheur/reconnexion et rendu restent ouverts. Régénération, soin générique, gains de niveau, vol de vie, témoin Trundle et fichiers disponibles ne remplacent pas Carnivore. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Chogath-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rang/substitutions/lookup ; qualifier kill/crédit/restaurations et états/audiences autoritaires ; intégrer widgets/refus sans faux montant nul/état acquis ; vérifier déficits PV et mana, niveaux/cibles/crédit, ordre/plafonds/modificateurs, mort/reconnexion et confidentialité avec rendu identifié ; séparer régénération/soin/Trundle/niveau/vol de vie/QWER/F3/Ezreal et V166 ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_chogath_passive_hud_20261104` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux et archives, result.json, finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
