# Origine du plafond de rang des maîtrises 4312 et 4313

La divergence reste ouverte : les deux fichiers `DATA/Talents/*.inibin` contiennent `SpellData.Ranks = 4`, avec quatre descriptions non vides dans les textes natifs en_GB. Le catalogue officiel Data Dragon 4.20.1 donne trois rangs. Aucun de ces constats ne fournit, à lui seul, la valeur effective de `Talent.maxRank` reçue par le client AIR historique.

## Chaîne originale vérifiée

Quatre classes ont été exportées en p-code depuis trois bibliothèques originales de la release AIR 0.0.1.119. Leur appartenance au manifeste exact est vérifiée par chemin, release du membre, taille et MD5 ; les octets sont aussi identifiés par SHA-256. Les exports ActionScript antérieurs restent conservés et reliés aux mêmes bibliothèques.

1. `MasteriesController.grabCatalog` transmet `session.summonerCatalog.talentTree` à `MasteriesUtils.registerTree`.
2. `registerTree` construit la table `masteriesByGameCode` à partir des objets `Talent` et de leurs `tltId` ; `getMasteryByID` lit cette table.
3. `increaseTalentRank` compare le rang courant à `getMasteryByID(id).maxRank`. Le p-code contient le branchement `ifnlt` vers le refus, puis l’incrément du rang dans la branche autorisée. Les autres contrôles de points, de ligne et de prérequis sont conservés.
4. Le getter `Talent.maxRank` lit un champ privé ; son setter reçoit une valeur, la stocke et signale le changement. Il ne fixe pas, dans ces méthodes, un plafond pour 4312 ou 4313.
5. Le renderer compare le rang à `maxRank` pour l’état « maxed », affiche `rang/maxRank` et utilise ce plafond pour le texte du rang suivant.

Le sens du branchement est également recoupé dans [l’interpréteur public Adobe](https://raw.githubusercontent.com/adobe/avmplus/master/core/Interpreter.cpp) ; l’extrait, son origine et son empreinte sont conservés, sans attribuer cette version à AIR 4.20.

Les neuf méthodes représentent 501 instructions inspectées statiquement. Aucune méthode AIR n’a été exécutée. Cette inspection ne constitue ni une émulation du runtime AIR ni un test du moteur Rust.

## Consommateur actuel et recherches

`tools/project-plan/audit_mastery_cap_authority.py` est le consommateur de cette preuve. Il relit les sources, les membres des manifestes, les méthodes et les observations natives/catalogue ; il refuse de transformer un plafond inconnu en valeur démontrée.

Une recherche de mots et d’identifiants dans 1 199 fichiers Rust et JS/TS sélectionnés sous `crates` et `launcher` a produit une seule correspondance : le commentaire de `passive_gold.rs` indique que les modificateurs de revenu des objets, maîtrises et champions restent non pris en charge. Ce commentaire n’est pas une implémentation du plafond. La recherche ne prouve pas une absence dans tous les formats ou composants du projet. Commande, inventaire et empreintes sont conservés dans le reçu de recherche.

Les recherches antérieures sur les exports AIR, les journaux fournis et le manifeste n’ont pas récupéré la réponse historique `talentTree`. Le faux arbre de test `buildFakeMasteryTree` reste exclu. Les quatre descriptions natives ne sont pas utilisées comme substitut à cette réponse.

## Vérification et limites

La qualification passe 19 contrôles : un cas nominal, un contrôle positif de deux classes partageant légitimement la même bibliothèque et 17 refus de données altérées. Le premier test négatif utilisait, par erreur, cette même bibliothèque ; son échec et sa correction sont conservés sans modifier le consommateur ni rejouer les exports.

Pour résoudre chacune des deux divergences, il faut une réponse originale 4.20 EUW contenant le `Talent.maxRank` de l’identifiant concerné, ou une autre preuve primaire établissant le même plafond, puis vérifier le consommateur courant. L’origine des données, le contexte et les règles éventuelles de sélection doivent accompagner cette preuve. Le runtime AIR, le service Riot et le gameplay des maîtrises ne sont pas qualifiés ici.

Les anciennes références, les deux inconnues et leurs historiques restent conservés. Les tâches SYS-01.2-02/04/05 restent partielles et les cases du plan restent manuelles. Cette preuve ne termine pas la fiche ni le jeu.
