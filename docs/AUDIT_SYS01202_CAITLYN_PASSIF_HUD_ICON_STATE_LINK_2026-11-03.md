# SYS-01.2-02 — Caitlyn : liaison de Headshot au HUD, V1203

3 novembre 2026. Unité `AUD-SYS-01.2-02-CAITLYN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Caitlyn-PASSIF-PRESENTATION-HUD`, `OLF-24ddbdb4-a9ca-5aca-b9a5-3d78dd54f37a`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Caitlyn-PASSIF-NETWORK`. L’inconnue `OLU-a01dba49-1d42-5f15-a09c-62300bef4103` reste ouverte.

Ce lot relie ressources et consommateurs HUD inspectés, en séparant passif, Count, Ready, Headshot Marker et missile. Ni leurs noms ni les descriptions ne décident les audiences. V560 reste une preuve datée distincte, sans transfert de clôture au HUD ou recomptage d’anciens essais.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Quinze identités V560 sont réutilisées et comparées au snapshot, sans rouvrir leurs payloads natifs. Une empreinte documentaire actuelle ne constitue pas un hash D frais. SOURCE porte 20 relations/15 identités ; HUD deux relations, définition Caitlyn et métadonnées Lua : `OLS-b0e4afc8-c608-5188-9e7c-3e383bb14ea2`, `OLS-dc32578f-73a2-543e-b8b0-72286bba30b2`.

La définition déclare `Passive1LuaName=Headshot Marker` et `Passive1Icon=Caitlyn_Headshot.dds`. Count et marker ont des affectations littérales qualifiées. `CaitlynHeadshot.luaobj` contient Caitlyn_Headshot2.dds/CaitlynHeadshotReady comme **constantes candidates** : NEWTABLEpc4 laisse leurs affectations non qualifiées. Le missile NEWTABLEpc0 et CaitlynSkin06 restent distincts. Cinq Lua hérités sans prototype enfant et quatre preloads ne démontrent aucun callback serveur ou rendu. PersistsThroughDeath/NonDispellable du marker ne prouvent pas persistance/reset exécutés ; champs de rang interrogés absents sans défaut inventé.

Quatre DDS vérifiés donnent deux contenus, tous 2872 octets, 64×64 DXT1, sept mipmaps :

| Texture et statut | Chemins sous DATA | SHA-256 |
|---|---|---|
| Caitlyn_Headshot.dds, déclaration primaire | Characters/Caitlyn/HUD/Icons2D ; Characters/LuluFaerie/Info ; Spells/Icons2D | `d8f70cc29218556c1b95974eccea9c398066a035a7bb66c9d84948faac0ca232` |
| Caitlyn_Headshot2.dds, constante candidate, affectation non qualifiée | Spells/Icons2D | `03dbccc572064f3080bffc75fb7ad8a1c0ed2eb78fc3f394d1a79fe541a6ddef` |

Taille/MD5 concordent au manifeste sélectionné lol_game_client 0.0.1.7 ; membres respectifs 0.0.0.228, 0.0.0.80, 0.0.0.25 et 0.0.0.25. Aucun OLS créé. Copies identiques ne décident pas priorité/résolveur ; aucun rôle Lulu adopté. Headshot2 présente physiquement ne qualifie pas un état Ready ni une séquence d’icônes.

Six textes exacts du miroir F en_GB, lignes 1762/1763/1979/4169/4345/9345, comprennent les trois bindings Count/Ready/Marker, nom/description passive et description missile. Le marker utilise `f1`, le missile mentionne huit attaques ; les textes annoncent contribution doublée en buisson et 150 % sur champion/250 % sur sbire. Fournisseurs `f1`/`SourceName`, articulation des textes, rangs, catégories et politique exécutée restent inconnus. Font D non relu ; locale effective et rendu non qualifiés.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq lecteurs SOURCE ne deviennent pas des producteurs Headshot ou des widgets.

Provider/StartupHud et plugins ordinaires existent. Quatre icônes QWER Caitlyn sont configurées, zéro unresolved ; leur présence ne prouve pas les capacités implémentées. Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés ne fournissent aucun binding Headshot/Count/Ready/Marker identifié. Buff0, texture BuffIcon0 et BuffStack0 restent liés à Ezreal ; Annie4, HP/Mana, F3 et état conditionnel de stun restent distincts. Les recherches négatives sont corroboratives après lecture des corps/configurations, sans absence globale d’alias, code ou assets.

`advance_attacks`, basic_attack_hit et apply_damage relient AD, critique ordinaire et projectiles/dégâts génériques. Les configurations attaque/critique sont effectivement consommées ; elles ne fournissent pas un compteur Headshot. Navigation/line_of_sight utilisent le buisson pour la visibilité. Ni critique ni flag buisson ne qualifient charge, état prêt, consommation ou présentation du passif.

## 4. Attendu, observé et contrôles

Attendu : compteur/Ready/marker autoritaires reliés aux bonnes ressources, textes et audiences, avec affichage vérifié. Observé : ressources et limites identifiées, consommateurs ordinaires réels, sans liaison Headshot spécifique établie dans le trajet inspecté. Sources 37/37 et consommateurs 23/23 contrôles statiques ; quatre DDS lus, 11488 octets.

Seize pins/29 fenêtres communs, douze fichiers/22 ancres V560 et deux lecteurs/six ancres SOURCE concordent. Auxiliaires V1200 deux pins/11 fenêtres et V1202 un pin/deux fenêtres réutilisés ; deux configurations et quinze fenêtres supplémentaires identifiées. Inventaire 1219 chemins hérité sans recensement. Gardes/omissions et refus Learn/Cast/CastAt lus seulement ; aucun nouveau nominal/refus HUD exécuté.

V560 conserve 36 lancements ordinaires non critiques, 24 impacts champion contrôlés — douze ouverts/douze depuis buisson — et douze tirs vers sbires. Onze retraits sont enregistrés, dernier projectile encore en vol ; dégâts nets sbires non isolés, pas douze impacts qualifiés. Les 51 refus restent historiques. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté.

## 5. Écarts et inconnues

Ressources/variants/lookup, f1 versus huit attaques, contribution du buisson, multiplicateurs et catégories, rangs, compteur/Ready/consommation, critique/projectile/annulation, persistance/reset, audiences, fraîcheur/reconnexion et rendu restent ouverts. Métadonnées, projectiles ordinaires et présence DDS ne les remplacent pas. Aucun défaut ou besoin de reconstruction graphique n’est démontré.

## 6. Correction et reprise

Réutiliser `CH-Caitlyn-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/substitutions/rangs/lookup ; qualifier états autoritaires et audiences ; intégrer widgets et refus sans faux compteur zéro/prêt ; vérifier nominal, limites, buisson, cibles, projectile/annulation, mort/reconnexion et confidentialité avec rendu identifié ; séparer critique/buisson/attaques/QWER/F3/Ezreal/Annie des états Headshot ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire ou producteur/consommateur pertinent, contrat d’audience ou dérive précise, sans rejeu inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_caitlyn_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux et préparation conservée, result.json, finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes, sept protégés contrôlés avant/après et relecture finale.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
