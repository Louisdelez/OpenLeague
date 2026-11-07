# SYS-01.2-02 — Diana : liaison de Moonsilver Blade au HUD, V1208

4 novembre 2026. Unité `AUD-SYS-01.2-02-DIANA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Diana-PASSIF-PRESENTATION-HUD`, `OLF-fb4b8f2e-6db7-59cc-8630-3a935bc78646`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Diana-PASSIF-NETWORK`. L’inconnue `OLU-ec7f7012-65f7-537a-b0e6-0afd7ef61c4e` reste ouverte.

Le lot relie les déclarations du passif et du troisième coup aux consommateurs courants. Il ne qualifie pas sa simulation, son réseau, ses animations/VFX/audio ni les échecs de déplacement V563. Les compteurs d’autres champions et les voies génériques ne transfèrent aucune clôture.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Treize identités V563 et leurs appartenances sont réutilisées comme preuves datées, sans nouvelle lecture des métadonnées natives. Les 39 associations historiques portent trois tâches, pas 39 ressources.

HUD référence la définition `OLS-5e55ca54-734f-57c5-80e8-ccf311780616` et CharScript `OLS-e14aaa77-87e6-520d-aa0a-0c76aed8e861`. `Passive1LuaName=DianaPassive`, `Passive1Icon=Diana_Passive_LunarBlade.dds`. Passive1/Passive1Desc et niveaux4..6 absents ; niveaux1/4/7 déclarés, sans progression adoptée. Quatre Lua entièrement parsés hérités, sans prototype enfant ; CharScript et DianaCombatBuff natifs vides. Passive/DeathRecap ont les mêmes octets et des littéraux BuffName/icône/PersistsThroughDeath, sans preuve de dispatch ou persistance exécutée. CharScript communautaire contient du code de posture/animation : ni vide, ni passif serveur natif.

L’inventaire exact a précédé une seule lecture DDS : `DATA/Characters/Diana/HUD/Icons2D/Diana_Passive_LunarBlade.dds`,2872octets,64×64 DXT1,7mips, membre `0.0.0.191` du core sélectionné0.0.1.7. SHA-256 `61cd15569879c4776f2f85d7e43e23163243742c3a0a13a55ae671b9ea4cd281`. Aucune copie au chemin Spells inventorié ; cette absence locale ne prouve pas un asset manquant. Copie E exacte pour contrôle documentaire ; pixels, priorité de lookup et rendu non qualifiés, aucun OLS créé.

Le reçu de découverte déjà épinglé V563 est capturé byte-identique sur E,291999octets/SHA `0b87db19e7f1539c706e9b5552d50cec85500e1004184e316250c615af02b906`, pour conserver les références littérales des deux preloads. Déclarations de ressources seulement, sans compteur, animation ou géométrie acceptés ; original horsracines non rouvert au gate, gardes inchangées.

Trois clés en_GB uniques : tooltip1838, description4178 et nom Moonsilver Blade. Deux bindings distincts pointent le même tooltip. Le texte déclare vitesse d’attaque f3 et, tous les trois coups, supplément magique f1/f2 sur ennemis proches ; valeurs, fournisseur, compteur et géométrie restent inconnus. Provenance font V563/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective non prouvée.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`, pas un widget. Catalogue et cinq sites lecteurs SOURCE sont des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Quatre icônes QWER primaires et une variante W InventoryIcon1 sont déclarées, zéro unresolved ; le corps sélectionnant InventoryIcon ne prouve pas l’activation de cette variante. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Diana passif icône/texte/rang/compteur/prêt/consommation. Ezreal Buff0/BuffIcon0/BuffStack0, F3/Annie4, HP/Mana et états QWER restent distincts. Recherche .rs corroborative après lecture des corps, sans absence globale de code, alias ou assets.

Les attaques passent par cadence/statistiques, windup et basic_attack_hit physique. AP et vitesse d’attaque des objets, mitigation Magical et récapitulatif agrégé «Magique» existent ; ils ne fournissent pas un compteur Moonsilver ni un bridge capacité/buff vers le HUD. Les gardes de capacité/finitude du pool et omissions de widgets restent vérifiées statiquement seulement.

## 4. Attendu, observé et contrôles

Attendu : état autoritaire du passif, compteur/prêt/consommation, texte/rang/icône et audiences reliés à des widgets vérifiés. Observé : déclarations identifiées, chemins génériques réels, aucun binding Moonsilver spécifique établi dans le trajet inspecté. Sources50/50, consommateurs38/38 contrôles documentaires ; un DDS lu, aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, douze fichiers/24sites V563 et deux lecteurs/six sites SOURCE concordent. Auxiliaires V1200 2/11,V1201 1/3,V1202 2/3,V1203 2/9,V1204 1/2,V1206 3/4,V1207 3/4 réutilisés ; 1pins/5fenêtres directes. Inventaires et analyses antérieurs restent hérités, sans nouveau census.

V563 conserve deux géométries distinctes :18impacts et48refus chacune. Nearby principal : AP0/20/0, cadence48/48/42ticks, six coups par cas ; troisième/sixième physiques ordinaires, aucun dégât secondaire à141.421unités de Diana. Opposite à273.589unités conservé séparément. Tome20AP et Dague15%AS sont contrôles ordinaires, pas Moonsilver. Trois essais blue-side build0/run101 restent en échec avant combat ; succès depuis l’autre équipe sans résolution du déplacement. Aucune cause rayon/carte déduite. Ancienne inspection visant le mauvais reçu conservée. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

f1/f2/f3, progression, compteur effectif, remise à zéro/expiration/consommation, AP échantillonné, vitesse native, géométrie/orientation/cibles, lookup/états, audiences/confidentialité, mort/persistance/reconnexion et rendu restent ouverts. Nom DeathRecap et données de preload ne prouvent pas des événements. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Diana-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20 ; qualifier état autoritaire compteur/prêt/consommation/durée et audiences ; intégrer widgets/refus sans faux zéro/activation ; vérifier premier/deuxième/troisième coups effectifs, répétition/interruptions, cibles/critique, mort/reconnexion et confidentialité avec rendu identifié ; séparer ASobjet/AP/Physical/recapMagical et autres compteurs du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé. Mouvement reste dans les tâches existantes, hors nouvelle clôture.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_diana_passive_hud_20261104` : source_worker/sourceproof.json, captures/manifestes, reçu consommateur, scripts/journaux, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
