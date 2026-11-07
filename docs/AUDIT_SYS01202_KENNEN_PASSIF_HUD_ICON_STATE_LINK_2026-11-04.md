# SYS-01.2-02 — Kennen : liaison de Mark of the Storm au HUD, V1233

4 novembre 2026. Unité `AUD-SYS-01.2-02-KENNEN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. Implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Kennen-PASSIF-PRESENTATION-HUD`, `OLF-37eb8cf2-b87c-5d23-988f-647b0490876a` : icône, texte, rang applicable et état autoritaire. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. `OLU-99a34481-a2c9-57e5-a615-a583fcd4a4e7` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE avec leurs six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/kennen-passive-mark_of_storm-links-v588.json`,1050254octets,SHA4493b3d6b8e8bea4b641470006d00af2ff061f0b881814f977313d0c3bbe12d0. UTC2026-10-26T05:02:51.256813+00:00 ; MD05:09:52.615347. Dates documentaires, pas de date d’exécution déduite.

V588 :32identités natives,96associations,trois tâches,28sites/56liens. SOURCE actuel34relations/32identités ; HUD une relation définition. Captures historiques conservées exactement sur E avec provenance ; chemins de travail F inertes. Métadonnées/font/INIBIN/Lua/preloads inchangés non relus sur D.

Kennen.inibin :PARType=Energy,BaseMP200,Passive1LuaName=KennenMarkOfStorm.lua,icône Kennen_MarkOfStorm.dds. Suffixe .lua conservé ; candidat global .lua non retrouvé, .luaobj compilé présent, sans alias runtime qualifié. Description liée4215 :marques6,25secondes,trois marques pour étourdir1seconde et gagner25énergie ; étourdissement diminué si répété sous7secondes. Coefficient,renouvellement et ordre restent inconnus. W11643 :attaque renforcée toutes les cinq attaques,magique avec marque ; compteur distinct des trois marques. Ancien Passive1Desc de dégâts non adopté comme règle.

Onze Lua entièrement parsés,littéraux,aucun enfant. CharScript natif non vide :métadonnée Teemo_EagleEye.dds seulement ; CharScript communautaire vide distinct. Sept buffs liés,neuf preloads :MegaProc,Q/W/R référencent la marque,E ses sous-effets ; noms/dépendances ne qualifient ni dégâts supplémentaires,callbacks ni rendu. SpellToggleSlot=3 reste une métadonnée,sans mapping automatique au slot Rust R. Cinq chemins absents bornés :preloads MoSDiminish/DoubleStrikeIndicator,DDF,source globale KennenMarkOfStorm.lua,inibin personnage du passif. Seize références communautaires secondaires. Champs absents restent absents.

Inventaire avant payload :six basenames déclarés,neuf candidats/27776octets. Deux lectures nécessaires,4352octets :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Kennen/Info/Kennen_MarkOfStorm.dds | 2176 | 64×64, DXT1, mip brut 1 | 0.0.0.25 |
| DATA/Spells/Icons2D/Kennen_MarkOfStorm.dds | 2176 | 64×64, DXT1, mip brut 1 | 0.0.0.25 |

Un contenu SHA`a18bc452c0c18e7cb045ed90d52a9d862be3cb8512cec0d82efc84a7dba54d1f`,taille/MD5/membership vérifiés. Sept autres candidats non lus dans ce lot ; homonymes Teemo Info/global à MD5 différents ne sont pas assimilés. Aucun lookup,priorité,alias,pixel ou rendu qualifié. Localisation reliée au témoin natif/mirror Ahri,sans font D relu ; locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE4sites/2fichiers,catalogue et trois fonctions INIBIN. V58828sites/13fichiers,plus1lecteur,union14fichiers. Aucun lecteur Lua promu dans cette liaison SOURCE. Énergie/mana,régénération,achats,attaques/projectiles,dégâts,contrôles,progression et refus sont inspectés. Aucun producteur spécifique établi dans les corps sélectionnés,sans absence globale déduite.

Kennen Learn/Cast/CastAt ne sont pas admis. Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0 et F3/Annie restent des acquis ; aucune liaison Kennen icône/texte/rang/marques/durée/diminution autoritaire établie. 4enregistrements QWER,0non résolus,ne constituent pas le passif. Snapshot/session/horloges/départ/lifecycle restent des contextes statiques.

## 4. Attendu, observé et contrôles

Attendu :déclencheur natif éligible,marques/consommation/étourdissement/énergie qualifiés puis HUD autoritaire. Observé :sorts refusés,contrôles génériques,aucun déclencheur natif exercé ni liaison spécifique qualifiée. Sources59/59,relecture E88/88 ; consommateurs63/63,relecture E21/21. 92entrées,92fenêtres,32ancres,19configurations/56chemins matériels contrôlés. Les chiffres de prose proviennent des données. Producteur SOURCE :deux sorties[1,0]. Premier attendu documentaire refusé sur la casse du preload kennenmarkofstorm ; script,contrôles refusés,commande et journal exacts archivés avant correction. Littéral natif conservé,aucune relecture D. Consommateur :une collecte réussie,sans reprise ; préparations antérieures non exécutées conservées. Journaux binaires et provenance identifiés.

V588 hérité :deux parties Map10 neuves,Kennen contre Annie,base/Sapphire1027(+200mana,400or). Douze attaques physiques ordinaires avec projectiles source/cible non critiques,mitigation et régénération attribuables,tolérance0,002 ; aucun étourdissement cible. W non appris,rangs/délais nuls,niveau1,énergie200 toujours au plafond,max200,taux10/s. Le bonus mana ne change pas l’énergie ; ni récupération depuis déficit ni gain25énergie exercés.30refus sans mutation et360ticks finaux. Ces attaques sans W appris ne constituent pas un déclencheur natif éligible qualifié.

Troisième partie séparée :Annie apprend Q,cinq projectiles magiques vérifiés,424ticks d’attente de délai. Quatre Q chargent Pyromania ; cinquième la consomme,source Annie,étourdit Kennen38ticks,arrondi local1,25s. Cinq refus Q en délai et trois refus Kennen étourdi :déplacement,attaque,cast,états inchangés. Immobilité/contrôle puis retrait à expiration et mouvement public après sont observés. Ce témoin générique ne qualifie ni l’étourdissement natif Kennen1seconde,ni ses marques,diminution ou gain énergie. Total38refus,12projectiles physiques et5magiques distincts.

BUILD/RUN historiques0,binaire6081024octets,SHA`ef3ef2b20a4254095280d718f6ca1516c463d0e1a20a28807894451f3df094af`,sans équivalence courante présumée. Aucun nouveau jeu/build/VM/REA/réseau/GPU/audio/rendu. Anciens échecs et preuves conservés,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Q,W appris/actif/renforcé,E,R,cibles/exclusions,effets simultanés et propriétaires multiples restent à qualifier. Durée6,25s,arrondi,consommation/refresh par marque ou global,diminution sous7s/coefficient/tenacité/immunités/ordre et gain25énergie après dépense réelle restent ouverts. Mapping.lua/compilé,ancienne description,rangs,réseau,audiences,Hud/compteurs/durées,lifecycle et rendu restent ouverts. Aucun manque d’asset déduit des sorts refusés.

## 6. Correction et reprise

Réutiliser `CH-Kennen-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Résoudre mappings et règle historique sans importer de politique moderne. Qualifier déclencheurs admis,marques par cible/propriétaire,troisième marque,consommation/refresh/diminution et restitution après déficit. Relier icône/texte/rang/compteurs/durée/audience à ce producteur ; refuser ou retirer données absentes,invalides,périmées ou non autorisées. Vérifier Wcinquième attaque distinct,frontières temporelles,cibles multiples,simultanéité,contrôles et lifecycle/réseau/rendu. Reprise sur nouveau primaire,mapping,producteur,consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_kennen_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. Préparateur f9/vérificateur V1226 réutilisés,toutes entrées et archives incluses. Publication :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
