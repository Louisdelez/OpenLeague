# SYS-01.2-02 — Générateur Silence, V735

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Les cinq banques examinées restent des candidates en_US, sans sélection historique établie.

## Résultat

Les 320 ressources HIRC19 Silence possèdent toutes les paramètres originaux (1,0,0). Le code original enregistre les créateurs, charge ces paramètres, crée la source via B3ED70 et utilise sa vtable FF3714. Le générateur écrit réellement des octets nuls dans les tampons et conserve les octets au-delà de la plage produite.

Le profil nominal déclare un format à 48000, un facteur de taille 4, un mot de répétition 1 et une graine CRT 1. Les méthodes B3EF80/B3F050/B3F090/B3F170/B3F1E0/B3F1D0/B3F020 sont exécutées ; les instructions CRT C9BB7A et CA1D00 le sont aussi. Les formats et répétitions viennent du banc, pas d’un appelant historique qualifié.

## Attendu et observé

| Cas | Attendu et observé |
|---|---|
| Création | Allocation36 octets ; pointeur FF3714 ; progression à+0C laissée intacte jusqu’au reset |
| Initialisation/reset | Paramètre et contexte conservés ; durée 1 ; reset remet progression à 0 |
| Premier tampon | 256 unités, statut 45 ;1024 octets nuls ; reste du tampon8192 octets intact |
| Position exactement en fin | Refus 2 et état conservé |
| Position 47900 puis tampon 256 | 100 unités restantes, statut 17 ;400 octets nuls ; reste intact |
| Tampon suivant | 0unité, statut 17 ; aucune donnée écrite |
| Retrait | Destructeur natif puis appel de libération observé via allocateur fourni |

320 parcours complets donnent960 appels Execute. Onze diagnostics couvrent répétition 0 et 2, formats déclarés supplémentaires, réduction de boucle, requête 0, informations avec fin intacte, Term sur pointeur nul, allocation refusée et deux autres grainesCRT. Trois refus d’entrée du banc restent distincts des refus natifs. Quatre falsifications de preuve sont rejetées. 828 adresses exécutées sont comparées aux octets du PE original.

La mémoireCRT et le retour du getter de contexte sont fournis explicitement ; la récurrence aléatoire originale s’exécute. Les plages aléatoires des320 sources sont nulles : aucun comportement de plage non nulle n’est qualifié. Le CRT memset original s’exécute ; seules les interfaces d’allocation, verrous, libération logique, contexte et accès à l’étatCRT ont les frontières déclarées.

## Consommateur actuel et intégration

Le composant Rust V734 est relancé avec ses sources et son exécutable vérifiés inchangés :320 créateurs de paramètres Silence restent refusés, deux ressources Delay restent sans correspondance. Il n’est pas recompilé ici et aucune implémentation Silence n’est ajoutée. Le rôle existant voice_current_silence_creator_refusal et les autres consommateurs réels restent liés ; aucun nouveau consommateur artificiel n’est créé.

32 fiches sont enrichies : SYS,16 skins et15 voix de champions. Les31 fiches concernent Nidalee,Quinn,Swain,Udyr,Warwick. Les1247autres fiches audio V733, dont les dix fiches Delay de Sion, sont conservées. L’appartenance à une banque candidate ne prouve pas qu’une action choisit chaque ressource. Registres, instructions copiables, deux bases et documents de couverture/reprise sont synchronisés sans changer les cases, notes, historiques ou inconnues.

Le premier probe exploratoire avait conservé le libellé supplied_empty=true du lecteur V733 malgré deux entrées réelles. Le relevé vérifié V735 écrit false et l’audit rejette toute réintroduction de ce libellé. L’ancien probe reste conservé comme exploration ; il n’est pas utilisé comme preuve finale de registre vide.

## Limites et suite

Pas de démarrage historique, appelant réel complet, assemblage des banques, mélange, périphérique audio ou son audible qualifié. Le retrait est une libération logique observée, pas une mesure de récupération mémoire du système. Les getters non exercés de la vtable, plages aléatoires non nulles et formats arbitraires restent ouverts. Qualifier les appelants/formats, HIRC14/bus, Delay puis médias et lecteur actuel. Aucun champion ou jeu complet déclaré terminé.

[Reçu](fidelity_silence_source_links_v735.json). Corpus F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision735_silence_source_verified et revision735_silence_associations ; livraison revision735_delivery/VERIFIED.json.


## Relecture finale et fichiers modifiés

La relecture indépendante confirme les 32 fiches, les deux bases et les sorties natives sur les 320 ressources originales. Les empreintes des trois registres précédents sont retrouvées par inversion exacte des seuls fragments modifiés. Les autres tâches, états, notes et historiques sont conservés. Les contrôles d’intégrité SQLite retournent `ok` pour chaque base.

Fichiers de registre : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Suivi : `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`. Preuve publique : `docs/fidelity_silence_source_links_v735.json` et ce rapport. Bases ciblées : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3`. Scripts, journaux et deltas réversibles sont dans le corpus V735 sur F. Aucun code de jeu ni ressource originale modifié.

Contrôles réellement exécutés : parcours natifs, diagnostics et gardes du banc, comparaison des instructions au PE, vérification des sources et consommateurs, relance du composant Rust V734 identifié, livraison avec inversion des deltas et relecture indépendante. La tâche globale reste ouverte. Reçu : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision735_delivery\INDEPENDENT_READBACK.json`.
