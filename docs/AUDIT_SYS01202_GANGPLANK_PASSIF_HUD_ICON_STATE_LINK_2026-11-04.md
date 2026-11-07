# SYS-01.2-02 — Gangplank : liaison de Grog-Soaked Blade au HUD, V1216

4 novembre 2026. Unité `AUD-SYS-01.2-02-GANGPLANK-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Gangplank-PASSIF-PRESENTATION-HUD`, `OLF-da84a9f5-f17c-5ddb-ad93-6afcb8246ac9`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. L’inconnue `OLU-ab921547-33a6-549e-9658-20baa424746b` reste ouverte.

Ce lot distingue propriétaire Scurvy, cible ScurvyStrike, poison/ralentissement/cumuls, Parley Q et RemoveScurvy W. Dégâts physiques ordinaires, Embrasement et Épuisement ne qualifient pas le passif. Les versions modernes ne sont pas la référence.

## 2. Sources, identité et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V570 UTC2026-10-26T00:06:19.737953+00:00 ; MD00:13:07.554528, date documentaire distincte sans date d’exécution déduite.

Treize identités natives parmi dix-sept candidats réutilisées et datées, sans relire les métadonnées D. Les39 associations historiques concernent trois tâches. HUD possède deux relations natives : définition `OLS-e69ab4bf-6fe7-57b3-846a-5e15f96ed21b` et CharScript `OLS-5b1c481f-9bc6-50d3-bf73-ec0a38a60876`, métadonnée client sans corps serveur original.

Passive1LuaName=Scurvy, icône Pirate_GrogSoakedBlade.dds ; Parley et RemoveScurvy occupent les slots1/2. Passive1=1, niveaux1/9/17 et trois champs null restent sans politique de rang déduite. Quatre descriptions pointent vers la même clé.

Scurvy2595 décrit7% de ralentissement, dégâts magiques @f1@ par seconde pendant3 secondes, maximum3 cumuls. ScurvyStrike2596 décrit la cible et @SourceName@ ; description4189 cite attaques et Parrrley ; nom4365 conservé. Description ScurvyStrike9750 annonce une progression avec le niveau sans formule. Ces cinq clés ne résolvent ni substitutions, ni cadence, ni combinaison : aucun21% calculé automatiquement.

Cinq Lua entièrement parsés, quatre initialisations littérales reconnues, aucun prototype enfant. Parley NEWTABLE au pc12 dépasse le lecteur littéral : aucune corruption déduite. Scurvy propriétaire déclare IsDamagingSpell=false et persistance/non-dissipation ; ScurvyStrike cible déclare IsDamagingSpell/IsDeathRecapSource=true. Ces flags, Particle/Global_Slow et l’icône ne prouvent pas les callbacks ; les flags propriétaire ne définissent pas le cycle/purge cible. Deux bindings/deux preloads conservés. PirateScurvy et RemoveScurvy sont exclus de l’autorité du poison.

Douze références communautaires restent secondaires : CharScript vide ; Q avec dégâts physiques/critique, or/mana et TakeDamage ATTACK, création de projectile commentée. Observations historiques pinées capturées exactement E ; origine F-work inerte, gardes inchangées.

Inventaire exact avant les lectures DDS nécessaires :

| Chemin | Octets / format | Membre, projet sélectionné core0.0.1.7 |
|---|---|---|
| DATA/Characters/Gangplank/HUD/Icons2D/Pirate_GrogSoakedBlade.dds | 4224 / 64×64 DXT5, mip brut=1 | 0.0.0.169 |

SHA-256 : `36c57745c0282476bc6f9921ac305307d8cae0b1ed4085b3031ddd55478c1a0b`. Captures E exactes, tailles/MD5 conformes au manifeste ; aucun OLS créé. Identité ne prouve ni alias, priorité, pixels ou rendu. Textes bruts et substitutions conservés ; provenance V570 et vrai reçu Ahri comparés au miroir F, font D non relu. Locale effective ouverte.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. Les autres lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires existent. Sélecteurs, textes, barres, QWER-D/F et payloads inspectés n’établissent aucun binding Grog-Soaked Blade/Wound pour icône, texte, rang, cumuls, durée ou source/cible. InventoryIcon et rangs QWER ne prouvent pas un rang passif. Buff0 Ezreal et F3/Annie restent distincts ; leur compteur ne démontre pas un plafond3 Gangplank. Recherche corroborative bornée, sans absence globale déduite.

Attaques, dégâts/résistances, régénération, slows, vitesses, expiration et invocateurs sont inspectés. Le choix du ralentissement le plus fort et les événements périodiques génériques existent sans producteur Scurvy identifié dans ces corps. grant_slow est une API d’événement serveur ; le contrôle public passe par SummonerTarget/Épuisement. Projection, session et horloges ne qualifient pas un état de poison transmis.

## 4. Attendu, observé et contrôles

Attendu : ressources et états autoritaires propriétaire/cible/source reliés aux audiences/widgets qualifiés. Observé : déclarations et mécanismes génériques réels, liaison spécifique non établie. Sources 55/55, consommateurs 53/53 contrôles documentaires ; aucun nouveau scénario HUD nominal/refus exécuté.

Seize fichiers/29 extraits communs ;13 fichiers/28 sites V570, deux lecteurs/six sites SOURCE comparés ;3 nouveaux pins/7 fenêtres nécessaires. Couverture des chemins contrôlée avant assemblage ; mécanismes communs inchangés réutilisés sans census ni replay.

Le contrôle racine a détecté un reçu préparatoire Galio omis du gate initial. Préparations exactes archivées ; ajout d’une ligne intégrant tous les current_input_pins, sans élargir les racines ni modifier les gardes. Union vérifiée :94→95 entrées,77/77 entrées consommateur couvertes. Sources/consommateurs inchangés, aucun collector rejoué.

V570 hérité : quatre simulations publiques sans injection,1/3/4/4 attaques,12 impacts non critiques,60 refus et720 ticks après arrêt. Brut59.04, mitigation physique ordinaire après régénération, résidu<0.002 ; vitesse cible335 et aucun poison observé. MR30/55 ne qualifie pas une mitigation magique du poison absent. Trois premiers coups espacés de46 ticks couvrent92 ticks : trois charges simultanées non garanties. Parley refusé, déclenchement par Q ouvert ; V564 non corrigé.

Cinquième simulation publique distincte : Épuisement335→234.5→335 sur75 ticks ; Embrasement5 applications de14 dégâts bruts,70 au total, première immédiate, suivi150 ticks et régénération corrigée. Quatre refus supplémentaires. Ces contrôles ne valident ni poison, ni cumul, ni déverrouillage natif du compte.

Premier diagnostic refusé à la compilation E0559 : Summoner avec target au lieu de SummonerTarget ; aucun essai exécuté. Ancien programme/log conservés ; successeur qualifié build/run0. Binaire6067712 octets, SHA256 `7ad0d1f901bc353b3de406515d9daffa69507027e161db940fa9bafcb85936ed`. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ici.

## 5. Écarts et inconnues

f1/niveaux, rang applicable, premier tick/cadence/durée, cumul/rafraîchissement/expiration, ralentissements combinés, multiples auteurs, purge/mort, résistances/boucliers, Parrrley, lookup, audiences/reconnexion et rendu restent ouverts. Présence d’assets et positifs génériques ne sont pas une implémentation Scurvy. Aucun besoin de reconstruction graphique établi.

## 6. Correction et reprise

Réutiliser `CH-Gangplank-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs et substitutions ; produire poison/slow/cumuls autoritaires avec cadence, catégories et déclencheurs attaques/Parrrley ; qualifier source/cible, audiences, retrait et sessions ; intégrer les widgets sans compteur/rang/timer fictif ; vérifier cumuls simultanés/rafraîchissement, multi-auteurs, purge/mort/reconnexion, résistances/boucliers et refus de données invalides/périmées/non autorisées avec rendu identifié ; séparer positifs invocateurs et acceptation humaine. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé ni politique inventée.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_gangplank_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux, result/finalpeer. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
