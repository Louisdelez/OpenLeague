# SYS-01.2-02 — Blitzcrank, passif : liaison des icônes et états au HUD, V1200

3 novembre 2026. Unité `AUD-SYS-01.2-02-BLITZCRANK-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis décision racine ; HUD complet, mécanique Mana Barrier, rendu et acceptation ouverts.

## 1. Exigence et frontière

`CH-Blitzcrank-PASSIF-PRESENTATION-HUD`, `OLF-208f22bc-f0d6-5208-acb8-20fc56a0713b`, exige icône, texte, rang et états. Le lot examine leur liaison au HUD, en distinguant les consommateurs génériques de bouclier. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Blitzcrank-PASSIF-NETWORK`. L’inconnue `OLU-f804ef74-b559-5219-8c17-d7416fd08f47` reste ouverte.

V1186 clôt une liaison SOURCE bornée ; V544 traite des frontières de bouclier et d’un diagnostic distinct. Aucun de ces acquis, diagnostic ou périmètre partagé n’est transféré au HUD ou recompté comme nouvelle clôture.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Douze identités natives V544 sont réutilisées sans inspecteur ni hachage de métadonnées rejoué. SOURCE contient 15 relations/12 identités, HUD une relation vers Blitzcrank.inibin, OLS-71d6b4e7-a4d7-5cca-8789-871a26034eea.

La définition déclare `Passive1LuaName=ManaBarrierIcon` et `Blitzcrank_ManaBarrier.dds`. Icon/Cooldown ont des littéraux client qualifiés ; flags et priorité8 ne prouvent pas callbacks, ordre ou persistance exécutée. Le chunk actif ManaBarrier est parsé structurellement, mais NEWTABLEpc8 limite la reconstruction de ses littéraux ; ses constantes BuffName/Texture/AutoCooldownByLevel/DoOnPreDamageInExpirationOrder ne sont pas des affectations récupérées. Quatre chunks sans prototype de callback enfant et trois preloads ne qualifient pas un serveur ou rendu.

Trois fichiers documentaires, sans nouveaux OLS, donnent deux contenus :

| DDS | Chemins sous DATA | SHA-256 |
|---|---|---|
| `Blitzcrank_ManaBarrier.dds` | Characters/Blitzcrank/Info et Spells/Icons2D | `f0c344faab0f24dd2e2cbbb015010e74adec3a68ca5a82b530d09a8c5bdd6dc5` |
| `Blitzcrank_ManaBarrierCD.dds` | Spells/Icons2D | `326e0e88f3666ca9e651d79330194a0ef65c84fb3556d7a678c8694f09cce6ae` |

Chacun fait2176octets,64×64 DXT1. Taille/MD5 concordent au manifeste sélectionné lol_game_client0.0.1.7 : copie Info membre0.0.0.40, deux Icons2D membres0.0.0.25. Priorité, variante effective et pixels rendus inconnus.

Cinq textes en_GB aux lignes1731/2262/2263/4161/4337 décrivent recharge, actif, disponibilité et nom Mana Barrier. Le miroir F correspond à l’identité native héritée ; texte D non rouvert. Le texte indique sous20%PV,50%mana courant,jusqu’à10s,toutes les90s ; égalité du seuil, échantillonnage/dépense, ordre et timers exécutés inconnus. `@SourceName@` et rangs restent non qualifiés. Anciennes chaînes Alistar/tourelle/+400/+600PV/niveaux6/12/18 et NightmareBot ne sont pas adoptés.

## 3. Consommateurs courants

Le CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` demeure `champion_catalog`, appelé par `Simulation::new` : identité/statistiques sans passif. Blitzcrank a267.2mana et582.6PV locaux ; les empreintes dérivées restent distinctes du natif.

Provider/StartupHud et plugins normaux existent. Quatre InventoryIcon QWER sont configurés, aucune entrée Blitzcrank unresolved. Les18textes,11barres/fonds et14widgets QWER/D-F examinés ne fournissent pas de binding ManaBarrier. Le slot Buff0, sa texture BuffIcon0 et BuffStack0 restent liés à Ezreal dans ce module. Les constats négatifs sont bornés aux sélecteurs/corps/configurations inspectés.

**Deux consommateurs de shield génériques sont présents.** F3 somme les boucliers non expirés et affiche un montant arrondi ; ce label est masqué par défaut, sans icône/tag/état ManaBarrier. Le récapitulatif de mort est monté dans l’App normale et mis à jour après receive/shop. Il exige propriétaire/session/epoch, présentation prête, mort/respawn et décodage admis ; il affiche health_removed/shield_absorbed et le résumé. Ces dégâts absorbés passés ne fournissent pas l’identité du bouclier ni ses états.

Champion/Snapshot transportent les boucliers génériques tag/remaining/expires_at ; cela ne démontre pas disponibilité/actif/recharge ManaBarrier. Les barres natives lues dessinent HP/Mana et signalent shields pending ; ce commentaire n’est pas une panne runtime. Monde, animations et preloads steamgolemshield restent distincts.

## 4. Attendu, observé et contrôles exécutés

Attendu : icônes/textes/états disponible-actif-recharge reliés à une autorité et ses audiences qualifiées. Observé : ressources identifiées et deux consommateurs shield génériques réels, sans binding spécifique établi dans le HUD ordinaire inspecté. Sources35/35, consommateurs23/23 contrôles documentaires ; trois DDS lus,6528octets,deux contenus.

Seize pins/29fenêtres partagés concordent ;1219chemins hérités sans recensement. Les17entrées V1186 couvrent les six fichiers/10ancres V544, sans addition artificielle. L’ancien témoin100PV/300ticks était injecté par API serveur diagnostique, pas un déclenchement ManaBarrier ; six refus Attack et cinq grant_shield restent séparés et non rejoués. Aucun runtime/build/GPU/audio/réseau/REA. Omissions, clear et gardes de récapitulatif lus statiquement ; aucun nominal/refus HUD Blitzcrank exécuté ou rendu.

## 5. Écarts et inconnues

Sélection des icônes, SourceName/rangs, disponibilité initiale, seuil/ordre/échantillonnage du mana, montant/durée/recharge, états/audiences, mort/reconnexion et rendu restent ouverts. API grant_shield, absorption, chiffres F3 ou récapitulatif ne les démontrent pas. Autres alias/runtime non globalement exclus.

## 6. Correction et reprise

Réutiliser `CH-Blitzcrank-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : qualifier ressources/textes/SourceName/rang/lookup ; définir états/timers/audiences autoritaires ; intégrer de vrais widgets avec refus des entrées absentes/ambiguës ; vérifier nominal/transitions/confidentialité/fraîcheur/reconnexion/rendu ; séparer shield générique/F3/récapitulatif/HP-Mana/QWER/Ezreal/monde ; obtenir l’acceptation humaine séparée. Reprise sur primaire ou producteur/consommateur précis modifié, sans rejeu identique V544/V1186.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_blitzcrank_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux, result.json et relecture indépendante. Vérification statique partielle ; fonctionnelle non exécutée ; acceptation À VALIDER. Publication racine limitée au rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
