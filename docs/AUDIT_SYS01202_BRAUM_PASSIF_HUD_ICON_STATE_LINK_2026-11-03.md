# SYS-01.2-02 — Braum : liaison du passif au HUD, V1202

3 novembre 2026. Unité `AUD-SYS-01.2-02-BRAUM-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Braum-PASSIF-PRESENTATION-HUD`, `OLF-91a2c1b9-3cbe-59f4-9b15-f033f6ab381b`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Braum-PASSIF-NETWORK`. L’inconnue `OLU-a8e19ab0-ba65-50a5-a198-9b7483e0d8e3` reste ouverte.

Ce lot rapproche les ressources déclarées du HUD courant, en séparant passif, marque, tracker, compteur, diminution, stun, immunité et bonus. Leurs noms ne décident pas les audiences autorisées. Les périmètres SOURCE V1188 et V660 restent distincts, sans transfert de clôture.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. V660/V1182/V1188 fournissent 26 identités natives réutilisées, 32 relations SOURCE et deux relations HUD : définition Braum et métadonnées Lua, `OLS-8a610426-4819-5c80-9f61-aefb86241db1` et `OLS-667544ae-d63a-5a97-89c4-3f80fa6e13ed`.

La définition déclare `Passive1LuaName=BraumMarkDamageTracker` et `Passive1Icon=Braum_Passive.dds`. Les littéraux de marque/stun/immunité emploient cette texture ; tracker/compteur/diminution référencent Kennen_MarkOfStorm, BraumPassive référence LeonaShieldOfDaybreak. Ces déclarations clientes ne substituent aucune règle Kennen/Leona à Braum. Q/GemKnight_Shatter/MaokaiTrunkSmash restent contexte séparé.

Quatre fichiers explicitement référencés, chacun 2176 octets, 64×64 DXT1, donnent trois contenus :

| Chemins sous DATA | SHA-256 | Release membre |
|---|---|---|
| Characters/Braum/HUD/Icons2D/Braum_Passive.dds | `7ea4245f3dd5261c927a84ac8bf25deae872a98f545d27a29a4aa0006f8546a7` | 0.0.0.228 |
| Characters/Kennen/Info et Spells/Icons2D/Kennen_MarkOfStorm.dds | `a18bc452c0c18e7cb045ed90d52a9d862be3cb8512cec0d82efc84a7dba54d1f` | 0.0.0.25 |
| Spells/Icons2D/LeonaShieldOfDaybreak.dds | `81b2d58ee8a4ed690c317fdee71ab2eb2a9c3ef99605780c11c315d547b94c68` | 0.0.0.37 |

Taille/MD5 concordent au manifeste sélectionné lol_game_client 0.0.1.7. Priorité, variante/état sélectionné et pixels rendus inconnus ; aucun OLS créé.

Sept textes en_GB, lignes 1743/1744/1745/1748/4168/4344/11431 du miroir F qualifié, décrivent première marque par Braum/Q, attaques alliées après celle-ci, quatre marques, durée annoncée quatre secondes, puis stun/immunité/bonus. Quatre marques ne prouvent pas quatre icônes récupérées ou un ordonnanceur. `f1` dégâts, `f2` stun, `f3` immunité, `f5` bonus et `SourceName` restent sans fournisseurs qualifiés. La clé `game_buff_tooltip_BraumMarkDiminish` est absente, sans réécriture. Le texte Q11432 et les bindings répétés aux mêmes clés ne sont pas comptés comme nouveaux textes passifs.

Dix chunks non-Deprecated sont détaillés ; l’inventaire hérité porte 125 Lua sans prototype enfant et 45 limites NEWTABLE, sans décodeur rejoué. BasicAttackPassiveOverride NEWTABLEpc0 laisse ses globals non qualifiés ; LeonaSkin04 reste une constante. Champs de rang absents, DDF ancien, 181 Deprecated et six basenames E/Q/W doubles ne déterminent ni callback, rang, rendu ni variante admise.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et lecteurs INIBIN/Lua ne deviennent pas des producteurs de capacité.

Provider/StartupHud et plugins ordinaires existent. Quatre icônes QWER BraumQ/W/E/RWrapper sont configurées, zéro unresolved ; leur chargement ne prouve pas l’exécution des sorts. Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés n’identifient pas de binding passif Braum icône/texte/rang/compteur/état. Buff0, texture BuffIcon0 et BuffStack0 restent liés à Ezreal. Conclusion bornée aux corps/configurations lus, pas absence globale d’alias ou d’assets.

**Un consommateur générique de stun existe.** `native_hud_spells.rs` lit `p.stuns`/`expires_at` pour allowed ; `player_states` est appelé par all_states puis update, qui applique color à l’overlay. L’ordre exact est unavailable→cooldown→rank0→!allowed→resource : stun conduit au code disabled seulement si les priorités antérieures ne s’appliquent pas. Cela ne qualifie ni f2 ni un proc Braum. F3, masqué par défaut, affiche un timer générique ; transport des stuns/Effects et HP/Mana ne fournissent pas un compteur ou une immunité Braum.

## 4. Attendu, observé et contrôles

Attendu : ressources, compteur et états reliés à une autorité et des audiences qualifiées, avec affichage vérifié. Observé : déclarations identifiées, chemin stun générique réel, sans liaison spécifique établie dans le HUD inspecté. Sources 43/43 et consommateurs 24/24 contrôles statiques ; quatre DDS lus, 8704 octets.

Seize pins/29 fenêtres communs et 28 entrées V1188 couvrant dix fichiers/22 ancres V660 concordent ; auxiliaires hérités identifiés dans le reçu. Inventaire 1219 chemins hérité sans recensement. Chargement/omission, calcul d’état et refus Learn/Cast/CastAt Braum lus statiquement, sans nouveau refus exécuté.

V660 conserve quatre cas, deux Braum et deux Garen : 52 impacts/huit quartets, répartis également ; quatre API40 magiques et quatre stuns60 ticks sont des diagnostics distincts. Les 92 refus publics/28 API, 14809 ticks et dix XP restent historiques. Quartets110ticks et attente121 ne prouvent ni marques, proc, expiration ni immunité. Aucun build, test produit, VM, REA, runtime, GPU, rendu, audio ou réseau rejoué.

## 5. Écarts et inconnues

Sélection des textures, rangs, substitutions, compteur, source, états et audiences, timing/refresh/cumul/multi-Braum, cycle d’immunité/bonus, confidentialité, mort/reconnexion et rendu restent ouverts. Une déclaration native, un stun générique ou son overlay ne prouve pas l’intégration du passif. Disponibilité historique et paramètres serveur restent indéterminés.

## 6. Correction et reprise

Réutiliser `CH-Braum-PASSIF-PRESENTATION-HUD`, NETWORK et ses dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup ; qualifier autorité/états/audiences ; intégrer vrais widgets/refus ; vérifier nominal, limites, compteurs/transitions, confidentialité, fraîcheur, mort et reconnexion avec rendu identifié ; séparer stun générique/F3/QWER/Ezreal/monde et règles étrangères ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, producteur/consommateur pertinent ou dérive précise, sans rejeu inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_braum_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux, result.json et finalpeer_review.json. Publication racine limitée au rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées contrôlées avant/après puis relues.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
