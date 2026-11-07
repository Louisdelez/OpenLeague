# SYS-01.2-02 — Irelia : liaison de Ionian Fervor au HUD, V1222

4 novembre 2026. Unité `AUD-SYS-01.2-02-IRELIA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Irelia-PASSIF-PRESENTATION-HUD`, `OLF-76db013e-e41a-5307-860f-3b7fced1175f`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-48dcdb33-39a7-5156-a648-61ccbc4c7889` reste ouverte.

Ce lot distingue nombre d’ennemis proches, réduction des durées, état du buff, contrôle Courage et états génériques. Événements serveur, sorts publics, table locale d’admission et métadonnées natives ont des portées distinctes.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V577 UTC2026-10-26T01:52:01.592594+00:00 ; MD01:59:23.517447, dates documentaires distinctes sans date d’exécution déduite.

Huit identités datées réutilisées sans relire métadonnées, font, Lua ou DDF D. Vingt-quatre associations historiques concernent trois tâches. HUD possède une relation native, définition `OLS-c954ba82-b292-501b-b83b-b94406ad1053`.

Passive1Name et PassLev1Desc1 lient nom et description ; Passive1Desc est un autre hash, null. Niveaux recherchés non retrouvés : aucun zéro/rang déduit. Passive1LuaName=Voracity demeure distinct du preload/buff IreliaIonianDuelist ; usage effectif/hérité inconnu, sans substitution Katarina.

Description4202 : un/deux/trois champions ennemis proches donnent10/25/40%. Tooltip2022 : f1% de durée de contrôles en moins, avec SourceName. Producteur f1, portée, comptage, zéro/quatre ennemis et plus, visibilité/clones/morts, catégories éligibles/exclues, cumuls et arrondis restent à qualifier. La formulation générale du texte ne suffit pas à établir les exceptions.

Deux Lua entièrement parsés, initialisations littérales sans prototype enfant ; CharScript globals vides, buff identité/icône. Persistance absente ne vaut ni false ni politique de mort. Deux preloads : contexte HitenStyle/idle et trois particules passives distinctes, sans preuve d’activation/rendu. DDF4 entrées R sans passif seulement dans ce fichier ; coefficient0.6 d’AD bonus ne fournit pas f1. Sept références communautaires et CharScript vide restent secondaires ; JSON Voracity conservé sans adoption.

Observations historiques capturées exactement E, origines F-work inertes. Chaînes en_GB et témoin Ahri réel vérifiés sur miroir F, sans relire font D ; locale effective ouverte. Inventaire exact avant lectures DDS :

| Chemin | Octets / format | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Irelia/Info/Irelia_IonianFervor.dds | 2872 / 64x64 DXT1, mip brut=7 | 0.0.0.25 |
| DATA/Spells/Icons2D/Irelia_IonianFervor.dds | 2872 / 64x64 DXT1, mip brut=7 | 0.0.0.25 |

Deux chemins/5744octets/un contenu, SHA256 `bc77c151d54a39e3e5016c43eae03096aaff82c4906d92fb1eec0d94af1e010a`. Tailles/MD5 conformes au manifeste ; aucun OLS créé. Basename et octets communs ne prouvent ni priorité, alias, lookup, pixels ou rendu. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE : quatre sites/deux fichiers, catalogue et trois helpers INIBIN ; aucun site Lua enregistré dans cette clause. Rôles conservés sans promotion en HUD. V57727sites/11fichiers, unionSOURCE12.

control_duration teste courage_until puis applique ceil(duration*0.7), sinon durée brute. Ce getter n’a pas de garde champion ; la voie publique productrice Courage inspectée est dispatchée Garen. Aucun comptage Irelia identifié dans les corps inspectés. Stun/slow et silence possèdent applications/échéances réelles, sans qualification du passif.

allows_disabled charge disabled_cast_rules.json via include_str, politique locale identifiée `OLS-40ae19ee-0962-56b3-a7a7-6d6a5d6f34ae`, pas immunité native. Provider/StartupHud, barres, QWER, Buff0 Ezreal et F3/Annie existent sans liaison IonianFervor icône/texte/rang/f1/état établie. Snapshot/projection/session/horloges ne prouvent pas un payload spécifique ; aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : état de comptage/réduction qualifié, données autoritaires et ressources reliées aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources59/59, consommateurs60/60, contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;11fichiers/27ancres V577 et quatreSOURCE ;8 pins/19 fenêtres directes. Entrées, fenêtres et configurations vérifiées ; diagnostics historiques non rejoués. Source :57/58 au premier producteur, motif de classe communautaire vide trop strict ; script/contrôles/journal archivés, regex whitespace corrigée, puis59/59 et relecture49/49. Deux productions documentaires, sans relecture native lors de la correction. Consommateur :une exécution60/60, relecture10/10, aucun retry. Créations refusées Windows206 et SyntaxError avant démarrage/écriture du bloc ; chemin primaire hérité corrigé avant collecteur, script archivé. Quatre icônes QWER primaires, zéro variante/non résolue dans l’import courant.

V577 hérité : quatre cas Irelia avec0/1/2/3 ennemis groupés et deux contrôles Garen. Regroupement400unités diagnostic uniquement ; distances150/250/350 ou13261.615, pas portée native. Trois silences Q publics Garen gardent45ticks,135ticks de suivi distincts. Impacts reliés au windup renforcé et à la perte de santé, sans requalifier tout GarenQ.

Quatorze paires serveur explicites grant_stun/grant_slow,28événements : Irelia conserve1/30/90ticks ; Garen90, ou63 avec Courage. Ralentissement25% et stun ont des états/échéances distincts,637ticks de suivi serveur ; expirés exactement à l’échéance.74refus publics et54serveur conservent les snapshots. Ces événements ne sont pas des sorts lancés par joueur ;90vers63 ne qualifie ni arrondi ni règle Irelia.

Inspection initiale échouée sur entrée de registre disabled_cast_rules absente, puis PREPARE échoué sur comparaison d’un élément plutôt qu’une tranche : originaux et chaîne qualifiée distincte conservés. Aucun ancien échec promu. Binaire hérité6078976octets, SHA256 `6a9ecfb00b4aa08c80f555455825186194abd839a9711ba5c7bd878dfb08bd11`, BUILD/RUN0 historiques seulement. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ; V564 reste ouvert.

## 5. Écarts et inconnues

Voracity effectif, f1, portée/comptage, catégories de contrôles/exceptions, cumuls/objets, arrondis/minima, niveaux, visibilité/lifecycle, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Les dix/vingt-cinq/quarante pour cent déclarés ne définissent pas seuls tous ces contrats. Aucun transfert de Courage ou d’une politique Katarina.

## 6. Correction et reprise

Réutiliser `CH-Irelia-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs, f1 et divergence Voracity ; définir comptage/portée/cibles et réduction par contrôle, exceptions/cumuls/arrondis/minima ; produire état autoritaire et applications réelles sans importer Courage ; qualifier identité/session/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier0/1/2/3/4+ennemis, frontières qualifiées, vrais déclencheurs de sorts, objets/niveaux/mort/reconnexion et rendu identifié. Préserver témoins génériques, diagnostics serveur/échecs historiques et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_irelia_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Préparateur f9c314 :tous current_input_pins et copies archivées vérifiés, sorties exclues au niveau courant seulement. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
