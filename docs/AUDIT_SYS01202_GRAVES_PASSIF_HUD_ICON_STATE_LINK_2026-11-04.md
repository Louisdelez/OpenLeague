# SYS-01.2-02 — Graves : liaison de True Grit au HUD, V1219

4 novembre 2026. Unité `AUD-SYS-01.2-02-GRAVES-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Graves-PASSIF-PRESENTATION-HUD`, `OLF-cde9c15c-4f0f-531a-8182-bba97c5abd2b`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. L’inconnue `OLU-ce71a40c-ced4-544e-adbc-fc0e9aad2e90` reste ouverte.

Ce lot distingue combat, cumuls et défenses de True Grit, objets, pénétration, réductions de défense et contributions aux éliminations. Quickdraw et ShotAttack ne sont pas automatiquement des producteurs du passif ; une version moderne ne remplace pas la référence 4.20.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Reçu V574 UTC2026-10-26T01:02:34.186991+00:00 ; MD01:09:52.650372, date documentaire distincte sans date d’exécution déduite.

Quinze identités datées réutilisées sans relire métadonnées, font, Lua ou FX D. Les45 associations historiques concernent trois tâches. HUD possède une relation native, définition `OLS-8e9ba3e4-9318-55fe-b152-44bdfdc912d3`.

Passive1LuaName=GravesPassive, icône GravesTrueGrit.dds ; PassLev1Desc1 lie la description. Niveaux Passive1Level1..6 recherchés non retrouvés : aucun zéro ou rang déduit. Anciennes descriptions de critique d’alliés et vitesse d’attaque +10/+15/+20% restent non adoptées.

Tooltip1964 : gain d’armure/RM chaque seconde de combat, maximum dix cumuls, combat défini par dégâts infligés/reçus dans les trois dernières secondes. Tooltip1965 : bonus affiché et SourceName. Leurs f1 restent deux contextes distincts, sans producteur commun ou égalité déduite. Ligne1966 GravesPassiveGritStacks retrouvée, candidate sans binding supplémentaire. Description4197 et nom4373 conservés.

Six Lua intégralement lus et littéraux, sans prototype enfant ; deux bindings, trois preloads. PersistsThroughDeath déclaré ne qualifie pas les cumuls à la mort. Références GravesTrueGrit.troy et chaînes de preload ne prouvent ni application ni rendu.

CharScript Pineapple/Pineapple.dds et Stack RumbleDangerZone/Rumble_Junkyard Titan2.dds sont des données conservées, pas des règles True Grit. ExtraSpell2/ShotAttack, son preload/Stack et FX restent du contexte non qualifié ; FX identifié sans format/rendu qualifié. Dix références communautaires, CharScript vide et Quickdraw vitesse d’attaque restent séparés.

Cinq chaînes en_GB brutes, provenance V574/Ahri et miroir F vérifiés sans relire font D. Locale effective et substitutions ouvertes. Inventaire exact avant les deux lectures DDS :

| Chemin | Octets / format / mip brut | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Graves/Info/GravesTrueGrit.dds | 5616 / 64×64 DXT5 / 7 | 0.0.0.52 |
| DATA/Spells/Icons2D/GravesTrueGrit.dds | 5616 / 64×64 DXT5 / 7 | 0.0.0.52 |

Deux contenus distincts : SHA256 Info `2e6301179f4a14eb376a8b9434db9deb4682fb0f02b3c54dbc60ac1dc423f18f`, Spells `9128e5751ebd8f2d185d11718095cfd055824761e0ceb217ad996762b6b60c38`. Captures E exactes, tailles/MD5 conformes au manifeste ; aucun OLS créé. Identité ne décide ni priorité, alias, choix de variante ou pixels/rendu.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par Simulation::new. SOURCE réel : six sites dans trois fichiers, catalogue plus cinq helpers dans deux lecteurs. Qualifications conservées sans promotion en HUD.

Stats calcule armure/RM de base, croissance, objets et traitements Garen/Annie/Exhaust/Trundle. Dégâts consomme ces défenses et la pénétration avant boucliers/HP. Aucun producteur de bonus True Grit identifié dans ces corps. Les contributions mémorisées pour récompenses/assistances ne définissent pas son combat de trois secondes.

Garde de note_garen_damage exclut Graves avant mutation. Régénération et cycle de vie réels ne fournissent pas ses cumuls. Provider/StartupHud et plugins ordinaires existent, mais les sélecteurs inspectés ne relient pas icône, texte, rang, combat, cumuls, bonus ou durée True Grit. QWER, Buff0 Ezreal fixe et F3/Annie restent distincts. Snapshot/projection/session/horloges ne qualifient pas un payload Graves. Aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : état de combat/cumuls/défenses autoritaire relié aux widgets et audiences qualifiés. Observé : déclarations et chemins génériques réels, liaison spécifique non établie. Sources65/65, consommateurs51/51 contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;13 fichiers/22 ancres V574 et six SOURCE ;6 pins/12 fenêtres directes. Comptage SOURCE initial «sept» refusé avant sortie puis corrigé, literal_globals déjà inclus. Archives exactes avant correction, ajout de la garde Garen et précision des16 configurations déjà épinglées. Aucun échec produit déduit.

V574 hérité : repos, attaques émises/reçues, puis objets1029/1033 ;40 impacts physiques,75 refus,1500 ticks de suivi. Armure24.375999/RM30, objets +15armure/+25RM ; statistiques ensuite constantes. Résidu physique après régénération<0.002, aucun critique. Combat432/468 ticks, intervalles48/52 inférieurs aux90 ticks du probe pour trois secondes : combat régulier au-delà de dix secondes, pas dix impacts=dix cumuls.

Sans bonus créé, suivi sans qualification d’expiration. RM observée sans dégât magique : mitigation magique True Grit non testée. Niveau1, autres niveaux ouverts. V564 et la chaîne des diagnostics précédents restent conservés. Binaire hérité6035968octets, SHA256 `124c1fcf7fe842c3153872aadb7113bc377cd9716d548319eab889a57182c536`, build/run0 historiques. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ici.

## 5. Écarts et inconnues

f1 par niveau/incrément/bonus affiché, sources/cibles admissibles, dégâts nuls/absorbés/périodiques, premier incrément, frontières1s/3s, refresh/perte, plafond, mort/réapparition, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Bonus objets et historique d’assistances ne remplissent pas ces contrats. Aucun besoin de reconstruction graphique établi.

## 6. Correction et reprise

Réutiliser `CH-Graves-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs et paramètres ; définir puis produire combat, incréments/plafond dix et bonus défensifs, avec éligibilité/timing/refresh/perte ; qualifier identité/session/fraîcheur/audiences et transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier combat continu/interrompu, niveaux, objets, dégâts physiques/magiques, pénétration/réductions/boucliers, mort/reconnexion et rendu identifié ; préserver témoins et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_graves_passive_hud_20261104`. Scripts/captures/originaux source dans stage/source_worker ; trois JSON canoniques source_worker sont des miroirs byte-identiques, reçus dans stage/source_worker/canonical_copy_receipt.json. Aucun déplacement ou replay pour ce raccord.

Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback. Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
