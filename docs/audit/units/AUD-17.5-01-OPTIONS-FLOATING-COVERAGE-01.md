# FloatingText — synthèse des douze audits

## R1 — Portée et décision

2026-10-31T18:44:41.618021+00:00 — `AUD-17.5-01-OPTIONS-FLOATING-COVERAGE-01`, SYS-17.5-01 / SYS-01.2-02.

Les douze cases déclarées ont chacune un reçu d’audit documentaire clos. La présente consolidation attend sa relecture séparée. Elle ne clôture ni les fonctionnalités, ni tous les types natifs, ni le parent, ni le goal. Aucune acceptation humaine et aucun pourcentage de jeu terminé.

## R2 — Sources et provenance

XML `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Menu_SC4\FoundryOptionsMenu.xml` SHA-256 `4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de` ; index source et PE original identifiés dans la preuve. Douze anciens produits/reçus/rapports/relectures sont vérifiés par empreinte, sans réexécution. Corpus de 1 168 sources inchangé ; cinq registres, 25 fichiers protégés et Git conservés.

Les callbacks sont rapprochés par leurs instructions et octets déjà publiés, contrôlés contre le PE inchangé. La table de 29 types vient de la preuve Physical déjà relue ; aucun nouveau désassemblage. Les douze déclarations sont INI seules, sans stratégie ni updateonclick propres ; stratégie regular par défaut conditionnelle, fournisseur/définition effectifs non observés.

## R3 — Matrice source / types / acquis

| Case et source | Callback | Types commandés | Preuve |
|---|---|---|---|
| `[FloatingText]PhysicalDamage_Enabled` — ligne 142 | `0x7be400` | PhysicalDamage (16), MagicalDamage (17), TrueDamage (18), PhysicalDamageCritical (6), MagicalDamageCritical (7), TrueDamageCritical (8) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-PHYSICAL-DAMAGE-01.md) |
| `[FloatingText]Heal_Enabled` — ligne 143 | `0x7be4a0` | Heal (2) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-HEAL-01.md) |
| `[FloatingText]Gold_Enabled` — ligne 144 | `0x7be4e0` | Gold (10) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-GOLD-01.md) |
| `[FloatingText]Invulnerable_Enabled` — ligne 145 | `0x7be520` | Invulnerable (0), Countdown (25), Disable (12) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-INVULNERABLE-01.md) |
| `[FloatingText]QuestReceived_Enabled` — ligne 146 | `0x7be570` | QuestComplete (14), QuestReceived (13) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-QUEST-01.md) |
| `[FloatingText]ManaDamage_Enabled` — ligne 147 | `0x7be5c0` | ManaDamage (4), ManaHeal (3) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-MANA-DAMAGE-01.md) |
| `[FloatingText]EnemyPhysicalDamage_Enabled` — ligne 149 | `0x7be450` | EnemyPhysicalDamage (19), EnemyMagicalDamage (20), EnemyTrueDamage (21), EnemyPhysicalDamageCritical (22), EnemyMagicalDamageCritical (23), EnemyTrueDamageCritical (24) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-ENEMY-DAMAGE-01.md) |
| `[FloatingText]Dodge_Enabled` — ligne 150 | `0x7be4c0` | Dodge (5) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-DODGE-01.md) |
| `[FloatingText]Level_Enabled` — ligne 151 | `0x7be500` | Level (11) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-LEVEL-01.md) |
| `[FloatingText]Special_Enabled` — ligne 152 | `0x7be550` | Special (1) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-SPECIAL-01.md) |
| `[FloatingText]Score_Enabled` — ligne 153 | `0x7be5a0` | Score (15) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-SCORE-01.md) |
| `[FloatingText]Experience_Enabled` — ligne 154 | `0x7be5f0` | Experience (9) | [audit](F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-FLOATING-EXPERIENCE-01.md) |

26 types distincts sont commandés par ces douze cases, sans doublon. OMW26, Absorbed27 et Debug28 n’ont pas de case propre dans ce groupe : cela ne signifie ni ressource manquante/corrompue, ni absence d’un consommateur ailleurs.

**[FloatingText]PhysicalDamage_Enabled** — Dégâts et résultats brut/mitigation/bouclier/santé ; faits critiques existants.
Limite : Montant affichable, sujet, audience, profil et vue flottante restent à qualifier.

**[FloatingText]Heal_Enabled** — API de soin demandé/restauré, vrai appel de sort et régénération reconnus.
Limite : Heal2 ne commande pas ManaHeal3 ; ne pas confondre soin/restauration/régénération ou leurs montants.

**[FloatingText]Gold_Enabled** — Vrai montant killer_gold et identité d’événement ; revenus, transactions et portefeuille existent.
Limite : Delta du portefeuille et total GoldStat ne sont pas un événement d’or admis ni toutes les raisons de gain.

**[FloatingText]Invulnerable_Enabled** — Protections de fontaines/bâtiments, refus et consommateurs d’erreur existent.
Limite : La case Status commande trois types ; un refus ou une santé inchangée ne fournit pas un événement Status.

**[FloatingText]QuestReceived_Enabled** — Snapshot/états Map10 et messages existent, sans route Quest nommée dans le corpus.
Limite : Réception/achèvement et applicabilité carte/mode restent à identifier ; ne pas inventer un backend de missions.

**[FloatingText]ManaDamage_Enabled** — Coût de sort, récupérations plafonnées, types de ressource et MPStat/barre sont présents.
Limite : Dépense/perte/récupération/delta net restent distincts ; ManaDamage4/ManaHeal3 ne sont pas Heal2 ou toutes les ressources.

**[FloatingText]EnemyPhysicalDamage_Enabled** — Dégâts, faits critiques, audience historique/visibilité actuelle et consommateurs par joueur existent.
Limite : Enemy ne définit pas entrant/sortant ou permission ; clé critique générique et clés spécifiques ne sont pas normalisées.

**[FloatingText]Dodge_Enabled** — Annulations, validité, résultat mêlée et lancement à distance sont distingués.
Limite : False au lancement à distance ne signifie pas esquive ; producteur Dodge distinct non identifié.

**[FloatingText]Level_Enabled** — Vrais changements de niveau jusqu’à18, croissance, LevelStat et XPbar existent.
Limite : Niveau courant/XP/bootstrap ne définissent pas chaque transition admise, surtout en saut multiple ou reconnexion.

**[FloatingText]Special_Enabled** — États/messages et fonctions préparées de paquets/propriétaire d’effets examinés.
Limite : Sens concret de Special non identifié ; paquets, logs et modules ne prouvent ni notification ni intégration GPU.

**[FloatingText]Score_Enabled** — KDA, événements, roster et résumé final existent ; audit Scoreboard et disponibilité ancienne réutilisés.
Limite : Score15 n’est pas automatiquement KDA, or ou score de mode ; absent ancien n’est pas zéro observé.

**[FloatingText]Experience_Enabled** — API et vrais appels d’attribution/partage/global, montant et XPbar/niveau existent.
Limite : Gain, compteur, barre, niveau et or restent distincts ; toutes les causes/destinataires/parité ne sont pas qualifiés.

## R4 — Vérifications et attendu / observé

474 contrôles frais de rapprochement réussis. Vérifiés : appartenance 12/12 au groupe, identité des livraisons et sources actuelles, clôture et sept rubriques de chaque enfant, octets des callbacks déjà décodés, types uniques, propositions/écarts et invariances. Les anciens nombres de contrôles restent datés par enfant ; ils ne sont pas comptés comme nouveaux tests.

Aucun ancien lecteur/test/recherche/désassemblage/export rejoué, aucun original/x86/AS/Rust/jeu/GUI/entrée système/réseau/émulation/loader exécuté. Aucun rendu ni Save testé ici.

## R5 — Écarts et reprises conservés

Les 48 constats de manque des enfants restent liés à leurs sources, avec manque, impact et entrée de reprise complète dans la matrice JSON. Ils ne deviennent pas 48 nouvelles tâches indépendantes. Les douze propositions précédentes sont conservées une seule fois ; aucune nouvelle correction appliquée.

- Qualify admitted native/local event meaning/amount/subject/identity/time/audience per category, preserving all real current producers.
- Identify effective definition/config/provider/registration-order and independent Cancel/default/Save/reload durability.
- Identify shared worldtext/profile/font/format/clock/owner/view components once, reusing across category bridges.
- Verify actual display/refusal/privacy/lifecycle, then other applicable types/causes; counters and source flags are not pixels.

Points particuliers conservés : ManaHeal est commandé par Mana, pas Heal ; Status commande trois catégories ; Quest deux ; Enemy six, distinctes des six Damage ordinaires. Ancienne clé critique générique et clés spécifiques ne sont pas normalisées. Défauts Mana/XP à0 et utilisateur fourni à1 ne prouvent pas le choix effectif. KDA/score/or, gain/niveau/compteur, refus/annulation/esquive et visibilité actuelle/audience passée restent distincts.

Historique conservé : ancienne hypothèse Heal7BE450 rejetée au profit de7BE4A0 ; Enemy est bien lié à7BE450. Première relecture Status en échec conservée, puis version2 réussie ; méthode protected244–264 (21 lignes) plus contexte265 dans le fragment. Les anciennes preuves et descriptions ne sont pas réécrites.

## R6 — Suite bornée et limites du parent

La section FloatingText de cette définition est rapprochée exhaustivement ; ses fonctionnalités restent non qualifiées comme terminées. Le parent demande les états de chaque contrôle du HUD, au-delà de ces douze cases et du menu examiné : il reste ouvert. Les contrôles conditionnels et rendus réels ne sont pas promus complets.

Prochain lot `AUD-17.5-01-OPTIONS-OSX-MOUSE-ACCELERATION-01` : `OPT-SRC-8665147f945e7123`, ligne 161, `[General]OSXMouseAcceleration`, `onlyshowif=macosx`, `updateonclick=true`. Premier contrôle du panneau Game suivant. Réutiliser les audits de visibilité/hôte/checkbox, qualifier exposition et consommateur sur référence Windows ou manque précis de source Mac. Aucun changement d’OS, de souris ou de configuration système.

## R7 — Livraison et relecture

Matrice `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-COVERAGE-01\floating-coverage-proof.json`, SHA-256 `1c1a493e265a5fa8963195e980c9c1ae6fab54c69320e10d6c35e7e98232deca` ; entrée `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-COVERAGE-01\source-cases.json` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-COVERAGE-01\verify_floating_coverage.py`. Relecture indépendante attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul ce rapprochement documentaire peut être clos.

Seuls de nouveaux fichiers isolés d’audit sont créés. Goal/critères, code/assets, Plan/interface/bases, registres et anciens documents/preuves inchangés.
