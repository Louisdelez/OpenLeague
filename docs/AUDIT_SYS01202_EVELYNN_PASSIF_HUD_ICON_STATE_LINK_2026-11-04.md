# SYS-01.2-02 — Evelynn : liaison de Shadow Walk au HUD, V1212

4 novembre 2026. Unité `AUD-SYS-01.2-02-EVELYNN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Evelynn-PASSIF-PRESENTATION-HUD`, `OLF-e0e0df2b-de3c-5209-ab83-f4d01f931f38`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Evelynn-PASSIF-NETWORK`. L’inconnue `OLU-473304ed-b408-51bd-ba7b-90381582837d` reste ouverte.

Le lot relie passif, furtivité, marqueurs/révélation et indications HUD aux consommateurs inspectés. Vision générique, état privé du propriétaire, informations adverses et rendu restent distincts. Aucune règle récente Demon Shade ou mana manquant n’est importée.

## 2. Sources, identité et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Vingt-six identités V567 datées réutilisées sans nouvelle lecture des métadonnées natives. Les78associations historiques concernent trois tâches, pas78ressources. HUD porte une seule relation native, définition `OLS-f73ce3f1-640d-5f45-942e-5ed9a3cd2d26` ; CharScript reste une source V567 distincte.

`Passive1LuaName=EvelynnPassive`, `Passive1Icon=Evelynn_ShadowWalk.dds`. Passive1/Passive1Desc et six niveaux explicitement null ne deviennent pas valeurs par défaut ; rang/applicabilité ouverts. BaseMPRegen absent ne signifie pas absence de taux natif : BaseStaticMPRegen vaut1.6216000318527222. Dix Lua hérités entièrement parsés, initialisations littérales sans prototype enfant. CharScript natif vide et flags PersistsThroughDeath/Nondispellable ne prouvent ni machine de furtivité ni mort/réapparition.

ShadowWalk ancien déclare slot2/CastTime0.5, tandis que Spell2=EvelynnW ; aucune substitution au passif. Textes de cet ancien sort, ReadyToBetray et marqueurs restent séparés. Dix références communautaires secondaires : OnTakeDamage enregistré, corps SelfWasDamaged vide ; cette inscription ne reconstitue pas les règles serveur.

Inventaire exact avant les cinq lectures DDS,17064octets :

| Chemin | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/Evelynn/Info/Evelynn_ShadowWalk.dds | 2872 / 64×64 DXT1, champ mip brut=7 | 0.0.0.111 |
| DATA/Spells/Icons2D/Evelynn_OutOfStealth.dds | 4224 / 64×64 DXT5, champ mip brut=1 | 0.0.0.107 |
| DATA/Spells/Icons2D/Evelynn_ReadyToBetray.dds | 4224 / 64×64 DXT5, champ mip brut=0 | 0.0.0.25 |
| DATA/Spells/Icons2D/Evelynn_ShadowWalk.dds | 2872 / 64×64 DXT1, champ mip brut=7 | 0.0.0.111 |
| DATA/Spells/Icons2D/Evelynn_ShadowWalkGray.dds | 2872 / 64×64 DXT1, champ mip brut=7 | 0.0.0.111 |

Quatre basenames/4contenus ; ShadowWalk Info/Spells ont la même identité observée. Tailles/MD5 conformes au manifeste sélectionné, SHA détaillés dans sourceproof.json. Captures E exactes issues des lectures D de ce lot ; aucun OLS créé. Identité ne prouve pas lookup/alias, rôle actif, priorité, pixels ou rendu.

Découverte V567 déjà épinglée capturée byte-identique E,403451octets, pour les dix preloads et références communautaires. Original horsracines non rouvert au gate, gardes inchangées ; déclarations sans effet/chargement qualifié. Scripts dans Characters/Evelynn/Scripts et sorts DATA/Spells : répertoire Characters/Evelynn/Spells absent ne signifie pas ressource manquante.

Six clés en_GB : passif1879, marqueur1882, ancienShadowWalk2610, RevealedDebuff2611, description4183 et nom. Le passif déclare proximité des champions ennemis/vraie vision,1%du **mana maximum** par seconde en furtivité et sortie6s après cast/dégâts reçus/infligés. AncienShadowWalk trueSight-only reste distinct. SourceName des marqueurs/anciens états, seuils, transitions et composition des taux non qualifiés. Markup brut conservé sans normalisation, parse/rendu non exécutés. Provenance font V567/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Shadow Walk icône/texte/rang/furtivité/détection/délai/avertissement. HP/Mana, QWER, Buff0/BuffIcon0/BuffStack0 Ezreal et F3/Annie4 restent distincts. Recherche .rs corroborative après les corps, sans absence globale de code, alias ou assets.

visible_to/visible_point_to utilisent équipe, Ignite, rayons et LOS/terrain/buissons ordinaires ; aucune branche Evelynn identifiée. Le retour interactions=None précède la garde équipe : refus V567 limités au contexte Map10 actif. snapshot_for filtre les joueurs et d’autres projections ; le serveur appelle ce chemin et prépare/envoie des datagrammes dans son corps courant. Appel statique et essai de projection ne prouvent ni transport exécuté, ni vraie vision, ni confidentialité spécifique du passif.

regeneration_rates/advance_regeneration calculent base/croissance/objets et incrément mana plafonné ; aucune condition de furtivité identifiée. stats/shop modifient le maximum en conservant le mana courant, et la fontaine possède ses impulsions séparées. Ces mécanismes et l’affichage MP ne qualifient pas le1%conditionnel ou son régime d’addition/remplacement.

## 4. Attendu, observé et contrôles

Attendu : états autoritaires furtif/révélé/délai/alerte, audiences, ressources et widgets qualifiés. Observé : sources et chemins génériques réels, aucune liaison Shadow Walk spécifique établie dans le trajet inspecté. Sources70/70, consommateurs43/43 contrôles documentaires ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, onze fichiers/24sites V567 et deux lecteurs/six sites SOURCE concordent. Auxiliaires sélectionnés comparés et 6pins/16fenêtres directes ; inventaires et analyses historiques réutilisés sans census.

V567 deux publics à250 et899.9995117unités :360ticks/12s visibles et présents dans la projection adverse chacun,24refus atomiques Learn/Cast/CastAt. Aux bases, projection propre présente/adverse absente ; refus cible/équipe/observateur conservés. Distances d’essai, pas rayons natifs ; visibilité vers900 seule ne démontre pas une violation du seuil inconnu. Snapshot omniscient reste un instrument, pas réseau ou rendu accepté.

Achat public1027 après210ticks : mana courant265.6 conservé, maximum465.6 ;20incréments211–230 entre impulsions de fontaine égaux à base1.6216mana/s.1%du maximum représente4.656, mais aucun état furtif n’est établi ; composition des taux inconnue. Ne pas qualifier le bonus à partir du seul gain ordinaire. Deux inspections historiques, correction du sélecteur V566→V567 conservée sans remplacer les observations. Dans ce paquet, le libellé «Oct26» du consommateur est clarifié en date du reçu2026-10-25UTC, avec archives exactes et sans rejeu. Mouvement V564 et chaîne antérieure ouverts. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

Rayon/proximité/vraie vision, entrée/sortie/redémarrage du délai, sources de révélation,1%conditionnel/cadence/composition/plafond, rang/lookup/états, mort/réapparition, SourceName, audiences/confidentialité/reconnexion et rendu restent ouverts. FOW/Ignite, projection et régénération ordinaires ne remplacent pas Shadow Walk. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Evelynn-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20 et seuils ; qualifier états autoritaires/transitions/temporisation/mana et audiences ; intégrer widgets/refus sans faux zéro/activation/rayon ; vérifier événements cast/dégâts, proximité/vraie vision, mort/reconnexion, confidentialité et rendu identifié ; séparer FOW/Ignite/fontaine/MP/anciens sorts et autres compteurs du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé ni seuil déduit de250/900.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_evelynn_passive_hud_20261104` : source_worker/sourceproof.json, inventaires/captures/manifestes, reçu consommateur, scripts/journaux/archives, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
