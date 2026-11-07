# Ezreal — métadonnées et liaison des VFX du passif

2026-11-05 · V1328 · AUD-SYS-01.2-02-EZREAL-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et frontières

SYS-01.2-02 ; CH-Ezreal-PASSIF-PRESENTATION-VFX, OLF-60e669ac-e8fa-59c6-8160-65d8781e393f. Qualifier les vues natives/contextuelles du reçu V665 laissé non mappé par V1322 et leurs consommateurs pertinents. V665 associe uniquement CH-Ezreal-PASSIF-NETWORK : il n’est pas promu en inventaire SOURCE ou VFX complet. Critère lancement/trajet/impact applicables, dépendance NETWORK, phases et lots conservés, sans prérequis accepté implicitement.

Audit de ce lien documentaire clôturable après publication vérifiée. Implémentations partielles conservées ; vérification statique/documentaire ; acceptation humaine non donnée. Inventaire exhaustif, décodage natif, modification du jeu et rendu exécuté exclus. Anciens audits de réseau, icônes et sorts restent distincts, non recomptés.

## 2. Sources, identités et limites

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Copie V1322 : ezreal-passive-network-links-v665.json, 366806 octets, SHA 0cba229e09f268fd12133094e4e1eeaf9570afa5f93f3bbf246d1d6a5f157790. Identité vérifiée avant usage, aucun nouvel asset récupéré.

/native_metadata/native_literals/literal_initialization/globals qualifie BuffTextureName=Ezreal_RisingSpellForce.dds et BuffName=EzrealRisingSpellForce, témoins PC1/3. Lua : 168 octets, SHA 9a5fc01c16a5eb6aa9e483493d2322ac706abde13b90f8f4104abb0fb01574f0, cinq instructions, zéro prototype enfant, lecture structurelle complète. Littéraux qualifiés, symboles moteur non résolus ; pas de callback serveur récupéré. Aucun AutoBuff reconnu dans ces deux champs, sans absence d’effet natif déduite.

La définition conserve Passive1 chaîne "20", LuaName suffixé EzrealRisingSpellForceBuff et ancien texte parlant d’Ashe. La description liée en_GB indique 10 %, six secondes, maximum cinq cumuls ; un texte alias indique 15 %/75 %. Les neuf recherches historiques de chemins loose Buff sans résultat ne prouvent pas une absence globale d’asset ou d’alias. Aucun de ces conflits n’est supprimé.

Le catalogue 4.20.1/en_US demeure une référence distincte. Sources de Q/W/E/R, preloads et skins restent contextuelles ; ni leur présence ni les icônes ne fournissent une recette visuelle complète du passif. Aucun accès D, ouverture de particule, décodage ou comparaison de pixels nouveau.

## 3. Consommateurs réels conservés

Cinq fichiers actuels inspectés : ezreal_passive.rs, native_ezreal_passive_hud.rs, main.rs, projected_live.rs et ezreal_r_passive_presentation.rs. Identités concordantes avec V665 ou les preuves communes ; 14 identités partagées inchangées. Dix-huit ancres exactes.

Producteur local partiel réel : contacts acceptés, plafond cinq, expiration 6×TICK_RATE, bonus 0.10 par cumul, contrôles d’owner/équipe/session/santé et projection propriétaire. Ces règles ne sont pas des callbacks natifs retrouvés. Les callsites QWER et observations de contact V665 sont hérités, non rejoués ou intégralement réaudités ici.

Le plugin HUD est enregistré dans main ; il cherche Buff0/BuffIcon0, lit l’icône via Provider et le compteur validé, construit ses éléments et masque les entrées refusées. Présentation partielle conservée, sans exécution GPU. Le filtrage initial de l’inspection avant la première déclaration cfg(test) ne sélectionnait pas les lignes main ; le collecteur et la relecture vérifient explicitement le texte complet, dont l’enregistrement ligne 688.

Le compteur privé et r_samples_3d sont des accesseurs distincts. Données/effets R et route Annie Q de projected_live ne deviennent pas VFX du passif. Associations enregistrées conservées, sans nouvelle liaison de registre ni absence globale affirmée.

## 4. Attendu, observé et contrôles

Attendu : reconnaître les deux valeurs et limites, préserver les consommateurs existants, borner le manque visuel. Observé : 54/54 contrôles documentaires et 48/48 de cohérence séparée du même agent réussissent sur V665 original et cinq témoins courants.

Nominal statique : littéraux, producteur et chaîne compteur→HUD identifiés. Refus lus : owner/session/santé/cumul invalides, icône indisponible, contexte non prêt ou périmé. Aucune branche n’est exécutée ce tour. La fraîcheur locale 0.2 s est distincte de l’expiration autoritaire du passif.

V665 rapporte quatre cas, cinq contacts réels, 77 états projetés, 8215 ticks et 903 datagrammes ; ce sont des observations héritées, pas des images ou une partie complète. Trois anciens échecs privés liés au choix d’arrivée E restent conservés, sans corruption du jeu déduite. Les anciennes écritures de Plan/bases et commandes audit_command ne sont pas reproduites. Aucun build, test Rust, jeu, GPU, réseau, REA, probe ou lecteur natif nouvellement exécuté.

## 5. Écarts et inconnues

Alias Buff, anciens textes, applicabilité d’effets en monde, recette, owner/skin, audiences, attache, cadence, ouverture/montage et rendu restent ouverts. Le DTO privé ne détermine pas les audiences historiques du monde ; ni cumul HUD ni géométrie R ne qualifient le passif. Native server_behavior=false et code_executed=false préservés.

V1322 demeure immuable ; ce supplément qualifie une vue choisie, sans inventaire secondaire complet. Aucune tâche SOURCE/NETWORK/VFX complète, feature, inconnue, acceptation ou goal close. Vérification d’identités aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Ezreal-PASSIF-PRESENTATION-VFX : clauses source-alias-visual-contract, state-audience-world-link et resource-cycle-render-acceptance. Préconditions, objectifs, fins et reprises dans corrections_and_restart.json. Fin : sélection/applicabilité/recette étayées ou manque borné ; état, audience et consommateur reliés ; ressources et cycle observés avant acceptation visuelle. SOURCE/SIMULATION-CONTRAT/NETWORK et HUD conservent leurs critères.

Reprendre sur source, appel, capture ou lecteur nouvellement qualifié, dérive ou anomalie pertinente. Pas de replay inchangé ; conserver les contradictions sans générer de texture comme substitut à une recette. Prochain lot : CH-Ashe-PASSIF-PRESENTATION-VFX, qualifier sa branche du reçu partagé V537 déjà retenu et les consommateurs nécessaires, sans clore Tryndamere par association.

## 7. Livraison et cohérence

Preuves : E:/mapslol3v3/audit_sys01202_ezreal_passive_vfx_20261105, initial_scope, inspection, current_inspection, evidence_review, coherence_review, corrections_and_restart et journaux. Relecture séparée du même agent, non indépendante ni acceptation humaine ; sept rubriques examinées.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2315 entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, relance, suppression ou mutation Git.
