# SYS-01.2-02 — Jax : liaison d’Assaut implacable au HUD, V1225

4 novembre 2026. Unité `AUD-SYS-01.2-02-JAX-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Jax-PASSIF-PRESENTATION-HUD`, `OLF-3a1cd045-ca6d-5e14-abc0-1a07214cfde8`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-5340db90-4062-50bd-b527-508578881dfa` reste ouverte.

Six contrats/sept inconnues sont conservés : l’extra `OLU-42e6eefa-da30-5066-9f67-70555a14cf90` appartient uniquement à SIMULATION ; SOURCE/CONTRAT la référencent sans adoption. Passif AS, R/troisième coup et défenses restent distincts.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V580 UTC2026-10-26T02:41:33.369153+00:00, MD02:50:37.446573 ; V538 UTC2026-10-25T16:13:42.394472. Dates documentaires, sans date d’exécution déduite.

V580 :21 identités datées/63associations sur trois tâches ; V538 :14identités/42associations. SOURCE actuel :38relations/22identités en union, RelentlessBarrier.inibin supplémentaire conservé. Aucune relecture métadonnées/font/Lua/DDF/FX D. HUD possède une relation native, définition `OLS-16c2ec85-611e-519d-bf1a-f57d1b810017`.

Passive1LuaName=JaxPassive ; nom/PassLev1Desc1 sont liés. Passive1=9 et niveaux3/7/11/15,5/6absents ne deviennent ni coefficient ni calendrier d’activation. Anciennes descriptions AD d’objets/régénération mana restent non adoptées.

Tooltip2096 annonce f1% AS,2.5s,max6cumuls ; coefficient, déclencheur, refresh et politique restent inconnus. AS2098 affiche un f1/SourceName, sans producteur commun prouvé. Clé déclarée game_buff_tooltip_JaxRelentless_Assault absente de la recherche en_GB ; voisine2097 sans underscore conservée séparément, sans alias automatique ni absence globale de ressources déduite.

Spell4=JaxRelentlessAssault et ExtraSpell3=JaxRelentlessAttack ; textes9508/10220/11604 identifient Grandmaster’s Might, troisième coup magique et défense active. DDF12R/Q/E, liens armure/RM et coefficients ne fournissent pas f1AS. Nom «RelentlessAssault» et preloads partagés ne fusionnent pas R/passif.

Sept Lua entièrement parsés sans prototype enfant, six initialisations littérales ; Attack NEWTABLEpc6 est une limite, pas corruption. JaxPassive PersistsThroughDeath=true ; ASrecipient absent ne vaut pas false. TriggersSpellCasts/DoesntTriggerSpellCasts sont déclarations. Speed déclare RelentlessBarrier défensif ; Debuff n’a pas de BuffName, IsDebugMode=true ne fournit pas de nom. Cinq preloads/deux FX identifiés sans rendu, dix références communautaires/CharScript vide restent secondaires.

Observations/reçus historiques capturés exactement E, origines F-work inertes. Chaînes en_GB et témoin Ahri réel vérifiés sur miroir F, sans font D ; locale effective ouverte. Inventaire exact avant lectures DDS :

| Chemin lu | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/Jax/info/Armsmaster_MasterOfArms.dds | 4224 / 64x64 DXT5, mip brut=0 | 0.0.0.40 |
| DATA/Spells/Icons2D/Armsmaster_CoupDeGrace.dds | 4224 / 64x64 DXT5, mip brut=0 | 0.0.0.25 |
| DATA/Spells/Icons2D/Armsmaster_MasterOfArms.dds | 4224 / 64x64 DXT5, mip brut=0 | 0.0.0.25 |

Trois lectures/12672octets/deux contenus. MasterOfArms SHA`d15aa919355040f54027d477ecc8da32681b5d738118ee9859bffb4a1da9412d`, CoupDeGrace SHA`4e6dac9bbd6d8335ba9279dde2b422f3d1420b1fbdbcfe47e88c999753431d77`. Le personnage/AS déclarent MasterOfArms, JaxPassive/R CoupDeGrace : rôles préservés sans remplacement. Manifeste5candidats/21120octets, homonymes Master Malphite/Shen non lus. Membres40/25, tailles/MD5 conformes ; aucun OLS, priorité, alias, pixels ou rendu qualifiés.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE :six sites/trois fichiers, catalogue+INIBIN3+Lua2, rôles non promus en HUD. V58022sites/10fichiers ; unionSOURCE12. V5388sites/5fichiers réutilisés distinctement.

Cadence courante :base divisée par croissance/objets/TrundleW/EzrealW/Ezrealpassif−Exhaust, dénominateur min.05, round puis min12ticks. Windup ceil/min1 et planification tick+cadence sont réels. Aucun producteur de cumul Jax identifié dans les corps inspectés ; autres passifs/modificateurs AS sont conservés, sans transfert. Ticks entiers peuvent masquer de petits gains ;47/41 ne prouvent pas une absence globale ou un échec numérique natif sans f1.

Provider/StartupHud, barres, QWER, Buff0 Ezreal et F3/Annie existent sans liaison JaxPassive icône/texte/rang/f1/cumuls/expiry établie. Snapshot/projection/session/horloges ne prouvent pas un payload spécifique ; aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : bonus/cumuls qualifiés, états autoritaires et ressources reliés aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources66/66, consommateurs66/66, contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;10fichiers/22ancres V580,sixSOURCE et5fichiers/8ancres V538 ;12 pins/21 fenêtres directes. Entrées, fenêtres et configurations vérifiées ; diagnostics historiques non rejoués. Corrections préparatoires archivées : champ source puis KeyError V538 avant sorties ; second producteur66/66 et readback E58/58. Fenêtre57lignes, appel config et prédicat Ezreal corrigés avant l’unique collecteur66/66 et son readback14/14. Ensuite, cinq alias documentaires exacts ont passé16/16 contrôles E-only ; JSON original reconstitué byte-exact. 66/14 sont hérités sans réexécution, collecteur inchangé ; sources/natifs non relus pour cette projection.

V580 hérité :deux cas base/Dague1042,18impacts/30refus/420ticks pause-suivi. Huit coups continus par cas, sept intervalles47ticks ou41 avec15%AS local ;120ticks de pause, neuvième coup identique puis90ticks. Physique ordinaire AD*100/(100+armure), régénération comptée, résidu<.002, sans critique. Refus et snapshots inchangés conservés. Pause longue sans état créé ne qualifie pas expiry2.5s ;huit coups ne qualifient pas max6.

V538 distinct :huit coups, sept intervalles47, après Stop1/30/90ticks cadence47 ; contrôle achat/vente Dague47→41→47. Binaire5954560octets SHA`6b9faba974fb8f8c9dbbe6a8613c083522d6d4f003e418cc1df6951053ac51ae`, pas relancé.

V580 binaire6018048octets SHA`472a02372d57fd1a7574c3cab3ad83600beb380a06967c4c1e36fda3ce0356ab`, BUILD/RUN0 historiques. Finisher initial refusé sur compteur trois au lieu de quatre inconnues propres ; quatre IDs toujours conservés. Correction QUESTION_COUNT_CORRECTION/ancienne preuve/anciens marqueurs erronés préservés, sans runtime. Aucun nouveau build, VM, REA, GPU, réseau, audio ou rendu ; V564/priorchain conservés.

## 5. Écarts et inconnues

f1/par cumul ou total/niveaux, déclencheur/cibles, cumul/refresh/expiry/plafond, résolution/arrondis/minima, objets/ralentissements/annulations/changement de cible, mort/disparition/respawn, lookup/rangs/alias/états/audiences/reconnexion et rendu restent ouverts. R/Barrier, icônes de rôles différents et clé absente demeurent séparés.

## 6. Correction et reprise

Réutiliser `CH-Jax-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères :qualifier f1/niveaux/lookup/rangs et clé manquante sans alias arbitraire ; définir gain/refresh/cumul/cibles/expiry/lifecycle, produire état autoritaire et intégrer stats/cadence/windup sans importer R/Ezreal ; qualifier identité/session/fraîcheur/audiences ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier valeurs natives chiffrées tenant compte de la résolution entière, plafonds/objets/niveaux/annulations/pauses/mort/reconnexion et rendu identifié. Préserver témoins génériques, propriété des sept inconnues et acceptation humaine distincte. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_jax_passive_hud_20261104` :sources/captures/manifestes,consommateurs,scripts/journaux/archives,result/finalpeer. Préparateur f9c314 :tous current_input_pins et copies archivées vérifiés, sorties exclues au niveau courant seulement. Publication racine :rapport+ajouts CURRENT/HANDOFF,sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ;zéro tâche complète HUD/SOURCE/NETWORK,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ;SYS-01.2-02 actif/partiel.
