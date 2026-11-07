# SYS-01.2-02 — Brand : liaison du passif au HUD, V1201

3 novembre 2026. Unité `AUD-SYS-01.2-02-BRAND-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à relecture et publication racine. HUD complet, mécanique, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Brand-PASSIF-PRESENTATION-HUD`, `OLF-5003d232-8216-5d73-bb7c-3f0ae0a378f8`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Brand-PASSIF-NETWORK`. L’inconnue `OLU-903fff0c-0796-543f-9d2a-4185b563167e` reste ouverte.

Le lot relie les ressources déclarées aux consommateurs HUD inspectés, sans décider leurs audiences historiques. V1187 SOURCE et V659 restent des périmètres distincts, sans transfert de clôture. BrandBlaze nomme le Q/Sear, Blaze le passif affiché, BrandAblaze un état.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Seize identités natives V659/V1182/V1187 sont réutilisées : SOURCE contient 19 relations/16 identités ; HUD une relation vers Brand.inibin, `OLS-f9747d8c-94c9-5c8c-b512-93396b9cc438`.

La définition déclare `Passive1LuaName=BrandPassive` et `Passive1Icon=BrandBlaze.dds`. Cette déclaration passive reste valide malgré le nom partagé avec Q. BrandPassive et BrandAblaze possèdent des affectations client littérales qualifiées ; leurs flags PersistsThroughDeath/IsDeathRecapSource ne prouvent ni politique exécutée ni liaison HUD. Dix-neuf chunks Lua hérités ont zéro prototype enfant ; neuf limites NEWTABLE laissent leurs globals non qualifiés, sans corruption inférée. Runspeed/persistance et chunks vides Sound/ZombieResurrection ne qualifient pas vitesse, audio ou résurrection.

Deux fichiers explicitement déclarés ont les mêmes octets :

| Chemin sous DATA | Taille et format | SHA-256 |
|---|---|---|
| Characters/Brand/info/BrandBlaze.dds | 2176 octets, 64×64 DXT1 | `8b86137e9316aa48fd92fa5d10547681fe4d76c5f44e1947b1d4d3c92752c381` |
| Spells/Icons2D/BrandBlaze.dds | identique | identique |

Les deux concordent taille/MD5 au manifeste sélectionné lol_game_client 0.0.1.7, membres 0.0.0.26. Deux chemins, un contenu ; priorité, sélection effective et pixels rendus inconnus. Aucun OLS créé.

Quatre textes en_GB, lignes 1740/1741/4167/4343 du miroir F, décrivent Ablaze/Blaze : 8 % des PV maximum magiques sur 4 secondes, maximum annoncé 80/s contre les monstres, dégâts chaque seconde. Ces textes ne qualifient pas l’ordonnanceur serveur. `@SourceName@`, locale effective, rangs et audiences restent inconnus ; six champs de rang absents ne décident pas leur applicabilité. BuffData BrandAblaze possède son texte ; la clé SpellData exacte `game_spell_tooltip_BrandAblaze` est absente, sans alias inventé. Quatre textes QWER contextuels et champs Q-like restent séparés ; aucune explosion ultérieure importée.

## 3. Consommateurs courants

Le CID HUD enregistré, `OLC-93924678-ea15-5516-8f55-08616c5450cc`, est le catalogue appelé par `Simulation::new`, pas un producteur du passif. Provider/StartupHud et plugins ordinaires sont montés. Quatre InventoryIcon QWER Brand sont configurés, zéro unresolved ; Q BrandBlaze utilise BrandSear.dds. Cela ne fournit pas un binding du passif vers BrandBlaze.dds.

Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés, leurs chargeurs/appelants et les payloads lus n’identifient aucun binding BrandPassive/BrandAblaze icône/texte/rang/état. Buff0, sa texture BuffIcon0 et BuffStack0 restent liés à Ezreal. HP/Mana ordinaires et F3 masqué par défaut ne prouvent pas une présentation de Blaze. Les conclusions négatives sont bornées aux corps/configurations nommés, sans absence globale d’alias ou d’asset.

`Effects.ignite` transporte un Burn propre à Ignite ; aucun de ses usages HUD n’est identifié dans les sélecteurs lus. Transport d’Effects, santé cible et effets monde ne qualifient pas une présentation de BrandAblaze.

Le panneau de récapitulatif est normalement monté, puis conditionné par propriétaire/session/epoch, présentation prête, mort/respawn et décodage. `death_recap.rs` Source/Row regroupent sources, catégories et montants health_removed/shield_absorbed, sans identité de sort/buff/DoT. Aucun mapper du flag natif IsDeathRecapSource vers Ablaze n’est identifié dans ce trajet. Aucun affichage en partie n’est revendiqué.

## 4. Attendu, observé et contrôles

Attendu : ressources et états reliés à une autorité, des audiences qualifiées et un vrai HUD. Observé : ressources présentes et consommateurs génériques réels, sans liaison passive spécifique établie dans le trajet inspecté. Sources 38/38 et consommateurs 24/24 contrôles statiques réussis ; deux DDS lus, 4352 octets.

Seize pins/29 fenêtres communs, 26 entrées V1187 couvrant 11 fichiers/22 ancres V659, et deux auxiliaires/11 fenêtres V1200 concordent. Un auxiliaire et quatre fenêtres recap supplémentaires sont examinés. Inventaire 1219 chemins hérité, sans recensement.

Omission/clear HUD, gardes recap et refus Learn/Cast/CastAt Brand sont lus statiquement. V659 conserve quatre attaques, huit API40 magiques, deux AnnieQ, six XP, 70 refus publics/20 API et 9239 ticks. Ces témoins et horizons151 ne testent aucun déclencheur Brand ou HUD. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio ou réseau exécuté.

## 5. Écarts et inconnues

Lookup/variantes, substitutions/rangs, états, source et audiences, timing/refresh/cumul/expiration, confidentialité, mort/reconnexion et rendu restent ouverts. Les règles serveur 8 %/4s/plafond, interactions QWER et disponibilité historique ne sont pas résolues par ces métadonnées. API, Ignite, F3, récapitulatif générique et preloads ne les remplacent pas.

## 6. Correction et reprise

Réutiliser `CH-Brand-PASSIF-PRESENTATION-HUD`, NETWORK et ses dépendances SOURCE/SIMULATION ; aucune nouvelle tâche. Six critères : qualifier ressources/textes/rangs/lookup ; qualifier autorité/états/audiences ; intégrer vrais widgets/refus ; vérifier nominal, transitions, limites, confidentialité, fraîcheur, mort et reconnexion avec rendu identifié ; séparer Q/Blaze/Ablaze/Ignite/recap/F3/Ezreal/monde ; obtenir l’acceptation humaine applicable séparément. Reprise seulement sur primaire, producteur/consommateur pertinent ou dérive précise, sans rejeu inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_brand_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux, result.json et finalpeer_review.json. L’adaptation de collecte des auxiliaires est documentée, original archivé avant résultat. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes, sept protégés et relecture après publication.

Une seule clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal, Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
