# SYS-01.2-02 — Janna : liaison de Tailwind au HUD, V1223

4 novembre 2026. Unité `AUD-SYS-01.2-02-JANNA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Aura, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Janna-PASSIF-PRESENTATION-HUD`, `OLF-538ce9a7-9eee-52e7-a0eb-b30fc115a7fc`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-456910e6-474d-55b4-8f04-9556ad9f2262` reste ouverte.

Ce lot distingue source TailwindSelf, buff reçu Tailwind, bonus allié de vitesse, vitesse personnelle W/Zephyr, bottes/Soin et plafonds locaux. La divergence globale/proche reste indéterminée.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V578 UTC2026-10-26T02:09:04.736979+00:00 ; MD02:17:00.605653, dates documentaires distinctes sans date d’exécution déduite.

Treize identités datées réutilisées sans relire métadonnées, font, Lua ou DDF D. Trente-neuf associations historiques concernent trois tâches. HUD possède deux relations natives : définition `OLS-725c4ad7-7c45-59a3-b76f-bcb536e09ed7` et CharScript `OLS-0250a997-2e51-58a9-907e-d00020a554ac`, métadonnées client sans corps serveur original.

Passive1LuaName=TailwindSelf ; définition, source et destinataire déclarent Janna_Tailwind.dds. Passive1Name et PassLev1Desc1 lient nom/description ; Passive1Desc est une chaîne vide sous un autre hash. Passive1 et Passive1Level1..4 sont littéralement chaînes zéro, niveaux5/6 absents : ni bonus nul ni rang connu déduits. PassLev1Desc2 «5 Astral Spirts» demeure ancien champ non adopté.

Tailwind2745 annonce5% et SourceName ; TailwindSelf2746 précise Janna et champions alliés proches. Description4203 dit tous les champions alliés. Le5% est attesté ; portée, catégories, auto-application et politique effective restent ouvertes. Textes littéraux sans paramètre passif f1 : aucun producteur f1 inventé. Zephyr2997 décrit vitesse personnelle et passage entre unités, contexte W distinct.

Quatre Lua entièrement parsés sans prototype enfant, trois initialisations littérales ; CharScript globals vides. SowTheWind NEWTABLEpc18 est une limite du lecteur, sans corruption déduite. TailwindSelf déclare PersistsThroughDeath/NonDispellable=true ; champs absents sur Tailwind ne valent ni false ni politique de cycle de vie. Deux preloads conservent Tailwind/Self, W, ForecastJannaVO/taunts et particules, sans preuve d’activation/rendu.

DDF4 entrées W : coefficients0.02/0.06 de puissance ne fournissent pas une règle Tailwind ; absence passive limitée à ce fichier. Dix références communautaires et CharScript vide restent secondaires. Observations historiques capturées exactement E, origines F-work inertes. Chaînes en_GB et témoin Ahri réel vérifiés sur miroir F, sans relire font D ; locale effective ouverte.

Inventaire exact avant lectures DDS :

| Chemin | Octets / format | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Janna/HUD/Icons2D/Janna_Tailwind.dds | 4224 / 64x64 DXT5, mip brut=1 | 0.0.0.161 |
| DATA/Spells/Icons2D/Janna_Tailwind.dds | 4224 / 64x64 DXT5, mip brut=1 | 0.0.0.25 |

Deux chemins/8448octets/un contenu, SHA256 `dc876dae6e7e32f90ff6c80acc420bf3cf2525184cede3b4e1025a96160dee64`. Tailles/MD5 conformes au manifeste malgré membres différents ; aucun OLS créé. Identité des octets ne prouve ni priorité, alias, lookup, pixels ou rendu. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE : six sites/trois fichiers, catalogue et cinq helpers INIBIN/Lua ; rôles conservés sans promotion en HUD. V57822sites/11fichiers ; unionSOURCE13.

movement_speed ajoute base/bottes ; effective_speed combine GarenQ, Soin, relique, TrundleW, ralentissements/TrundleE puis plafonds, avant multiplicateur de traversée propre à GarenE. Aucune contribution Tailwind identifiée dans les corps inspectés. Mouvement, budget de vitesse, occupation alliée et Stop sont réels, sans qualifier aura ni passage W.

Provider/StartupHud, barres, QWER, Buff0 Ezreal et F3/Annie existent sans liaison Tailwind source/destinataire, icône/texte/rang/état établie. Snapshot/projection/session/horloges génériques ne prouvent pas un payload spécifique ; aucune absence globale déduite. Vitesse affichée ne reconstitue pas une aura autoritaire.

## 4. Attendu, observé et contrôles

Attendu : politique de bonus qualifiée, états autoritaires source/destinataire et ressources reliés aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources63/63, consommateurs60/60, contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;11fichiers/22ancres V578 et sixSOURCE ;15 pins/18 fenêtres directes. Entrées, fenêtres et configurations vérifiées ; diagnostics historiques non rejoués. Une production source63/63 puis relecture43/43 ; préflight affiné aux trois chemins courants, car un ban global refusait des références historiques nécessaires, scripts inchangés. Un collecteur60/60 puis relecture10/10, aucun retry. Assemblage initial refusé sur nom MD hérité, corrigé avant création du collecteur, ancien assembleur archivé ; fenêtre slows étendue1..12vers1..19 avant assemblage, préfixe conservé. Six icônes QWER :quatre primaires/deux variantes Q-W/zéro unresolved, distinctes du passif.

V578 hérité : quatre cas publics Map10,70refus,240ticks,40pas mesurés. Ahri330 ou355 avec1001(+25), à250 puis1249.999512unités ; Janna/Annie335. Soin public sur Ahri donne426.200012/452.200012 puis retour330/355 au tick30, sans attribuer un effet à Janna. Chaque phase30ticks contient5pas Move puis Stop ; déplacement=vitesse/30, résidu<0.005, après Stop déplacement nul. Résidu vitesse<0.001.

Ces distances ne définissent ni portée native ni aura nulle. Soin30%/30ticks et plafonds locaux ne qualifient pas cumul, base ou arrondi Tailwind ; conflit cooldown240/300s conservé.70refus=60Janna,8cibles Soin invalides,2cooldowns ; snapshots inchangés. Aucun W/passage entre unités exercé.

Binaire hérité6031872octets, SHA256 `71373f316991eec8cc40245a8bd8bdccda96b5a8ce549b87f8523ef62cac7d3b`, BUILD/RUN0 historiques seulement. Chaîne antérieure Irelia/Heimer et échecs conservés inertes. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ; V564 reste ouvert.

## 5. Écarts et inconnues

Politique globale/proche, portée/cibles/auto-application, sources multiples, cumul, base du pourcentage, ordre ralentissements/plafonds, arrondis/niveaux, mort/respawn/dispel/perte de source, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Les champs zéro et les booléens déclarés ne décident pas ces politiques. Aucun transfert de W, Soin ou d’une mécanique moderne.

## 6. Correction et reprise

Réutiliser `CH-Janna-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : résoudre portée/cibles/auto-application et divergence des textes sur primaire effectif ; qualifier ressources/lookup/rangs et bonus5% sans f1 inventé ; produire état source/destinataire et intégrer bonus à vitesse/déplacements avec base/cumuls/objets/ralentissements/plafonds/arrondis qualifiés ; qualifier identité/session/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier frontières qualifiées, plusieurs sources, achats/ventes/effets temporaires/niveaux/mort/dispel/reconnexion et rendu identifié. Préserver témoins génériques, W séparé et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_janna_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Préparateur f9c314 :tous current_input_pins et copies archivées vérifiés, sorties exclues au niveau courant seulement. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
