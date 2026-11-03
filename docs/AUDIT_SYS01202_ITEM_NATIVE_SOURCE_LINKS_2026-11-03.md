# Audit de traçabilité — définitions natives des objets (2026-11-03)

## Périmètre et conclusion

Unité AUD-SYS-01.2-02-ITEM-NATIVE-SOURCE-LINKS-01. Question : les fiches d'objet pointent-elles vers la définition native portant le même ID, les fichiers correspondent-ils aux identités enregistrées et combien de ces IDs figurent dans le catalogue boutique source courant ? L'audit de ces liaisons et de l'intersection des IDs est clos pour le snapshot contrôlé. Il ne démontre ni la disponibilité historique sur Map10, ni le fonctionnement ou l'acceptation des objets.

## Liaisons et fichiers natifs

Référence projet : client PUBLIC 4.20.0.315 EUW/en_GB. Le script E:/mapslol3v3/item_source_link_audit/probe.py sélectionne dans fidelity_requirement_trace_4_20.json toutes les fiches correspondant à `^ITEM-(\d+)-(.+)$`. Pour chacune, il exige exactement une liaison native_inputs de rôle native_definition, vers un chemin dont le suffixe normalisé est DATA/Items/<ID>.inibin; pour un même ID, le source_id doit être identique. Une modification synthétique de l'ID ne passe pas le comparateur de chemin. Résultat : 2 779 fiches liées à 280 IDs et 280 source_id, sans ambiguïté ni absence pour cette sélection. Elles comprennent des parents et des sous-tâches : ce n'est pas un nombre d'audits individuels complets.

Les 280 chemins ont été résolus sous D:/LeagueOfLegendsV2/4.20, puis les fichiers natifs lus. Résultat : 280/280 tailles et SHA-256 conformes au registre, 162 628 octets au total. Les chemins, IDs, hashes et correspondances tâche/source figurent individuellement dans resultats.json. Le nom et l'empreinte n'établissent pas indépendamment la signification des propriétés ou l'origine historique du contenu.

## Consommateur courant et écart de périmètre

Dans le code source courant, crates/core/src/shop.rs:39–47 charge data/4.20/shop_foundation.json et expose sa liste; item(id) cherche dans cette liste et buy_item, après shop_guard, refuse un ID absent avec `item behavior not implemented` avant de consulter l'admission Map10. Le script catalog_check.py a comparé les IDs du reçu natif à ceux de ce JSON : 280 définitions natives distinctes, 33 entrées de boutique distinctes, toutes parmi ces 280; 247 IDs de la sélection native ne figurent pas dans ce catalogue. Les listes d'IDs sont conservées dans catalog_resultats.json. Cette différence décrit des données et branches du code source; aucune commande d'achat ou exécution d'un binaire n'a été testée.

Ne pas en déduire que les 247 objets devraient être achetables en Forêt torturée : certains peuvent avoir été indisponibles sur Map10, utilisés dans d'autres modes, retirés ou soumis à d'autres règles. L'admission historique 4.20.0.315, les prix, recettes, effets, icônes, textes et comportements doivent être examinés séparément selon l'objet. Pour les 33 IDs communs, la présence d'une ligne ne prouve pas non plus son admission, sa fidélité ni sa mécanique complète. Les contrôles antérieurs ciblés, dont ITEM-1056 et ITEM-1058, restent applicables et n'ont pas été rejoués.

## Vérifications et preuves

Commandes réellement exécutées, code 0 : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/item_source_link_audit/probe.py` puis le même interpréteur sur catalog_check.py. Aucune installation, modification de source ou exécution du jeu. Entrées : fidelity_requirement_trace_4_20.json SHA-256 05e82921fde916bc1b576db7f9801b87e8223b866ad1bf1205a8d3e670e60a05; fidelity_sources_4_20.json d8283f8872339087d5e2134f9342b06bc3e67d21514ce4149a1bf42b388fcc38; shop_foundation.json 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae; shop.rs 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0.

Preuves conservées sous E:/mapslol3v3/item_source_link_audit : probe.py SHA-256 72228a29ff993b54c13c1a4d5a8600c998d5a287b9cdf166194aeed4d305124e; resultats.json 4ba7b89c666257d17a4f4cbb06d90c757946a3d3fdd8919cfc1fada31289a90d; catalog_check.py 267626eaf25a60bad766ba2f05d46a0ddbb54b48161d5c21325ae9209e983015; catalog_resultats.json 1538b353bc3e154127b8732e4779cd25b65976916772fd34451fb189f540e922. Aucun parseur natif ni jeu exécuté dans ce lot; les hashes vérifient les fichiers par rapport au registre et non une authentification indépendante.

## Reprise

Aucune correction de nom de fichier ni d'identité n'est nécessaire dans les liaisons sélectionnées sur ce snapshot. Réutiliser les fiches ITEM-<ID>-SCOPE, SERVER, SHOP et ACCEPT correspondantes : qualifier d'abord la disponibilité et les sources exactes pour chaque objet/carte, puis déterminer si une entrée et une mécanique sont réellement requises; vérifier ensuite les parcours d'achat, vente, effets et présentation. Rejouer la comparaison globale uniquement après modification de ses entrées ou anomalie. La différence de 247 IDs appelle une qualification, pas une importation automatique.

Audit d'identité et de comparaison d'IDs terminé; implémentation partielle/non évaluée par objet, runtime et acceptation non évalués. Parent SYS-01.2-02 ouvert. Aucun goal, registre, application de suivi, base ou code produit modifié.
