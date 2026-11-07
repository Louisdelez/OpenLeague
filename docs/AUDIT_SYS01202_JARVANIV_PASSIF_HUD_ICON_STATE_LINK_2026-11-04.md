# SYS-01.2-02 — Jarvan IV : liaison de Cadence martiale au HUD, V1224

4 novembre 2026. Unité `AUD-SYS-01.2-02-JARVANIV-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-JarvanIV-PASSIF-PRESENTATION-HUD`, `OLF-1d72d1b7-ae88-5242-be21-2f1231470738`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-b8a86269-75fe-55c2-88af-b4ed6c21f531` reste ouverte.

Ce lot distingue bonus physique des PV actuels, état par source/cible, délai f1, AD ordinaire, cadence d’attaque et présentation ExtraSpell. Changement de cible et temps d’attente génériques ne qualifient pas un verrou passif.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V579 UTC2026-10-26T02:28:06.103876+00:00 ; MD02:35:14.472171, dates documentaires distinctes sans date d’exécution déduite.

Treize identités datées réutilisées sans relire métadonnées, font, Lua, DDF ou FX D. Trente-neuf associations historiques concernent trois tâches. HUD possède une relation native, définition `OLS-27b089a1-a481-595c-a79c-1ca40e6a7d70` ; SOURCE16relations/13identités, portée distincte.

Passive1LuaName=JarvanIVMartialCadence ; définition, source, buff cible et ExtraSpell1 déclarent JarvanIV_MartialCadence.dds. Passive1Name et PassLev1Desc1 lient nom/description. Passive1Desc évoque Master Yi, autres descriptions une régénération de mana : anciens champs conservés sans adoption. Six niveaux absents ne fournissent ni zéro ni rang.

Tooltip2091 : premier coup,10% des PV actuels en bonus physique,max400,réactivation par cible après f1 secondes non résolu. Tooltip2092 : buff cible/SourceName et délai court sans valeur. Description4204 confirme première attaque/restriction par cible. Catégories, minimum, ordre de lecture des PV/mitigation et progression restent inconnus.

Quatre Lua entièrement parsés sans prototype enfant, trois initialisations littérales ; CharScript globals vides. Attack NEWTABLEpc0 est une limite du lecteur, sans corruption déduite. Source PersistsThroughDeath=true ; champ absent sur cible, sans false ni politique de cycle de vie déduits. Deux preloads conservent jarvincritattack_tar et buff de contrôle par cible, sans preuve d’activation.

DDF20 entrées, dont quatre MartialCadenceAttack avec link/coeff vides : aucun f1 récupéré ni durée zéro déduite. AnimationName=Passive et Cooldown/Cooldown1..6=0 sont déclarations ExtraSpell, pas délai par cible. ApplyAttackDamage0/CanCastWhileDisabled1/CastRange20 ne définissent ni bonus nul, immunité ou portée d’attaque native. AnnieBasicAttack_mis/BloodSlash/globalhit et FX binaire identifié ne prouvent pas le rendu. Neuf références communautaires et CharScript vide restent secondaires.

Observations historiques capturées exactement E, origines F-work inertes. Chaînes en_GB et témoin Ahri réel vérifiés sur miroir F, sans relire font D ; locale effective ouverte. Inventaire exact avant lectures DDS :

| Chemin lu | Octets / format | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/JarvanIV/Info/JarvanIV_MartialCadence.dds | 2872 / 64x64 DXT1, mip brut=7 | 0.0.0.25 |
| DATA/Spells/Icons2D/JarvanIV_MartialCadence.dds | 2872 / 64x64 DXT1, mip brut=7 | 0.0.0.25 |

Deux chemins lus/5744octets, 1 contenu(s), SHA256 `44d80cf4e9a9f9409b500138ca965c4fee93fc0e0e2a16d49d6fea6bcfd5efd9`. Tailles/MD5 conformes au manifeste ; aucun OLS créé. Un troisième candidat manifeste homonyme sous ZyraGraspingPlant/Info,membre111,même MD5, est conservé contextuel non lu :3candidats/8616octets indexés ne deviennent pas3lectures. Priorité, alias, lookup, pixels et rendu restent non qualifiés.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE : six sites/trois fichiers, catalogue et cinq helpers INIBIN/Lua, rôles non promus en HUD. V57922sites/10fichiers ; unionSOURCE12.

Libération ordinaire : AD, critique applicable et branches Garen/Trundle distinctes ; basic_attack_hit transmet Physical, puis vol de vie/retaliation génériques. Mitigation/régénération/achat1036 existent. Aucun bonus de PV actuels ni verrou MartialCadence source/cible identifié dans les corps inspectés. Cadence/windup ordinaires ne fournissent pas f1.

Provider/StartupHud, barres, QWER, Buff0 Ezreal et F3/Annie existent sans liaison MartialCadence source/cible, icône/texte/rang/f1/état établie. Snapshot/projection/session/horloges génériques ne prouvent pas un payload spécifique ; aucune absence globale déduite. Une perte de PV ne reconstitue pas un état passif autoritaire.

## 4. Attendu, observé et contrôles

Attendu : bonus/verrou par source/cible qualifiés, données autoritaires et ressources reliées aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources64/64, consommateurs63/63, contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;10fichiers/22ancres V579 et sixSOURCE ;7 pins/14 fenêtres directes. Entrées, fenêtres et configurations vérifiées ; diagnostics historiques non rejoués. Capture historique :suffixe v578 refusé avant copie/payload, puis v579 réussi. Producteur source :nom MD hérité refusé avant contrôles/livrables, correction archivée puis64/64/relecture52/52, sans relire DDS. Collecteur :62/63 refusé sur identifiants OLF/OLU hérités, quatre artefacts archivés, puis63/63/relecture10/10 ;deux exécutions/un retry statique. Préfixes conservés et fenêtres complétées avant première collecte. Quatre icônes QWER primaires,zéro variante/unresolved.

V579 hérité : deux cas publics base/Épée longue1036 ;huit impacts chacun sur deux Annie dans l’ordre AABBABAB,16total,32refus,180ticks après Stop. AD55.7120018/65.7120056 ; chaque hit correspond au windup/cible, sans critique, dégâts ordinaires AD*100/(100+armure), régénération comptée, résidu<0.002. Cible non frappée :régénération seule.

Première cible511.679993PV :10% suggère51.167999 brut selon texte, absent du résultat courant ; calcul indicatif sans qualification de l’instant de lecture ou de l’ordre natif. Longsword+10AD n’est pas le passif. AABBABAB ne prouve pas un verrou ;90ticks par cas ne testent pas son expiration si aucun état n’a été créé. Cap400 non atteint, autres cibles/niveaux/boucliers/critique non qualifiés. Refus et snapshots inchangés conservés.

Binaire hérité6028288octets, SHA256 `18374d860f2adc88a15c6aa1af67432ad07bb06c3bf165817c06043d00e2af64`, BUILD/RUN0 historiques seulement. Inspection initiale échouée par conversion des clés hash string→int, puis lecteur qualifié corrigé sans rerun du probe ; générateur/lecture PowerShell échoués restent préparations, pas corruption native. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ; V564/chaîne antérieure conservés.

## 5. Écarts et inconnues

f1/par cible/niveaux, admissibilité/max400/minimum, instant PV et ordre attaque/bonus/armure/pénétration/réduction/bouclier/critique/vol de vie, annulation/refresh/changement de cible, mort/disparition/respawn, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Aucun transfert de Yi/mana ni de Cooldown0.

## 6. Correction et reprise

Réutiliser `CH-JarvanIV-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs et f1 ; définir bonus/cap/minimum/cibles/ordre et état par source/cible/session avec activation/expiration/annulation/cleanup ; intégrer les applications réelles sans confondre AD/cadence/ExtraSpell ; qualifier identité/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier premiers coups/répétitions/expiration/retours sur cible/sources multiples, catégories/HP/autres modificateurs, achats/ventes/niveaux/mort/reconnexion et rendu identifié. Préserver témoins génériques, références contextuelles et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_jarvaniv_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Préparateur f9c314 :tous current_input_pins et copies archivées vérifiés, sorties exclues au niveau courant seulement. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
