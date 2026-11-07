# SYS-01.2-02 — Anivia, passif : liaison des icônes et états au HUD, V1198

3 novembre 2026. Unité `AUD-SYS-01.2-02-ANIVIA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis décision racine ; HUD complet, mécanique Rebirth, rendu et acceptation ouverts.

## 1. Exigence et frontière

`CH-Anivia-PASSIF-PRESENTATION-HUD`, `OLF-12746cf7-4def-51f7-8d89-4f60dfd1ef24`, exige icône, texte, rang et états. Le lot établit les déclarations natives et leur lien au HUD propriétaire courant. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Anivia-PASSIF-NETWORK`. L’inconnue `OLU-1d114bd2-7513-5949-b4fb-e32548296682` reste ouverte.

V1183 clôt seulement une liaison SOURCE bornée ; V558 traite des frontières létales/œuf et du retour ordinaire. Aucun statut SOURCE, diagnostic, périmètre partagé ou ancienne clôture n’est transféré au HUD ni recompté.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. La trace HUD ne lie directement qu’Anivia.inibin, OLS-621265ef-9b55-5c59-a12f-80dcec45ce41. Dix-huit identités/memberships V558 sont réutilisés sans hachage de métadonnées ni inspecteur rejoué.

`Passive1LuaName=Rebirth Marker`, `Passive1Icon=Cryophoenix_Rebirth.dds`. Marker/Ready déclarent l’icône principale ; AnimationPlay/Reset/Cooldown déclarent la variante Charging et BuffName RebirthCooldown. Noms, flags et priorité littérale8 ne prouvent aucun alias, callback, ordre ou animation exécutée. Sept chunks Lua sont parsés historiquement sans prototype de callback enfant ; NEWTABLEpc16 reste une limite du lecteur de littéraux. AniviaEgg1/4/7 ne fournit pas les rangs absents du passif Anivia.

Six fichiers DDS documentaires, sans nouveaux OLS, donnent deux contenus :

| Contenu | Fichiers | SHA-256 |
|---|---:|---|
| `Cryophoenix_Rebirth.dds` | 5 | `7db581b4301dbb412599d99f5cfe42b8af9afb8503805f473e940345b8b31e09` |
| `Cryophoenix_Rebirth_Charging.dds` | 1 | `430c2239f929302bef757df8d824952cc29d60cf6faa1a9aadf968f6bd526201` |

Tous font4224octets,64×64 DXT5. Taille/MD5 correspondent aux chemins du manifeste sélectionné lol_game_client0.0.1.7. Base : Anivia/AniviaEgg/SwainBeam/SwainRaven sous Characters/…/Info, membres0.0.0.40 ; copie Spells/Icons2D membre0.0.0.25. Charging : Spells/Icons2D, membre0.0.0.107. Ni priorité, ni mécanique Swain, ni sélection effective ou pixels rendus déduits.

Six textes Anivia en_GB : lignes2515–2518,4156,4332 ; deux textes AniviaEgg restent séparés. Le champ historique `selected_four_strings` contient explicitement six lignes, pas quatre. Le miroir F correspond à l’identité native héritée ; texte D non rouvert. `@f1@` et `@SourceName@`, défenses, porteurs/audiences et timers effectifs restent inconnus. Œuf/pleinPV/6secondes/4minutes sont des énoncés client, pas des observations natives.

## 3. Consommateurs courants

Le CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` demeure `champion_catalog`, appelé par `Simulation::new` : identité/statistiques sans passif. Anivia a346.04mana et le type Mana local. V1183 a déjà identifié le digest086d… du miroir communautaire Stats/Anivia.json, distinct du natif7ed… ; aucune recherche de provenance ou corruption répétée.

Provider/StartupHud et plugins normaux existent. Les sélecteurs standards chargent cadres/textes/QWER-D/F ; quatre InventoryIcon Anivia sont adoptés, aucune entrée Anivia unresolved. Le seul Buff0/BuffStack0 de ces branches reste fixé à Ezreal. Structures Champion/Effects/Snapshot et projections sont examinées ; aucun binding Rebirth n’est identifié. Catalogue ou recherche lexicale seuls ne prouvent pas une absence globale.

RespawnTimer lit le propriétaire, la session, HP≤0 et respawn_at. Il suit le décès ordinaire, sans état œuf ou recharge Rebirth qualifié. Le catalogue modèle contient AniviaEgg et des clips portent des noms évocateurs ; le vrai Catalog lit animation_manifest/world_animation_manifest, ce dernier sans ligne Anivia. Descripteurs et noms ne créent ni transformation, ni HUD. Mana, F3, Pyromanie et barres monde restent distincts.

## 4. Attendu, observé et contrôles exécutés

Attendu : icône passive reliée à un état Rebirth et à ses audiences qualifiées. Observé : ressources et routes ordinaires identifiées, aucun binding passif établi dans les sélecteurs examinés. Sources35/35, consommateurs20/20 contrôles documentaires. Six DDS lus,25344octets, deux contenus ; zéro lecture native exploratoire.

Seize pins/29fenêtres partagés concordent ;1219chemins sont hérités sans recensement. Douze fichiers/20ancres V558 concordent aujourd’hui, sans qualifier la compilation de l’ancien binaire. Ses960ticks/32refus restent datés/non rejoués : Anivia1321→1501encore morte→1801fontaine ; Ahri1356/1536/1836. Retour ordinaire480ticks/16s distinct de l’œuf6s et de la recharge4min. Aucun runtime/build/GPU/audio/réseau/REA ; gardes et omissions lues statiquement, aucun refus HUD Anivia exécuté.

## 5. Écarts et inconnues

Résolveur des copies, bascule Base/Charging/Ready, substitutions/rang, producteur autoritaire, porteurs/audiences, disponibilité initiale, transformation/œuf/renaissance, lifecycle/reconnexion et rendu restent ouverts. Les constats négatifs sont bornés aux corps/configurations inspectés ; aucun autre alias/runtime n’est globalement exclu.

## 6. Correction et reprise

Réutiliser `CH-Anivia-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : qualifier ressources/variantes/textes/f1/rangs ; définir états et audiences autoritaires ; intégrer les vrais widgets avec refus des entrées absentes/ambiguës ; vérifier nominal/transitions/confidentialité/fraîcheur/reconnexion/rendu ; séparer QWER/mana/F3/mort/monde/Rebirth ; obtenir l’acceptation humaine séparée. Reprise sur source primaire ou producteur/consommateur précis modifié, sans rejouer V558/V1183 ni les mêmes analyses.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_anivia_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux, result.json et relecture indépendante. Vérification statique partielle ; fonctionnelle non exécutée ; acceptation À VALIDER. Publication racine limitée au rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
