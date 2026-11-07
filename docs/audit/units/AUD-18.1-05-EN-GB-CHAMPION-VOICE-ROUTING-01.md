# SYS-18.1-05 — routage des voix de sélection

2026-11-01T23:33:08.513152+00:00

Audit statique clos avec constats, sous réserve de relecture indépendante. Fonction audio, parent SYS-18.1-05 et goal global ouverts.

## Résolu
- La chaîne native est identifiée : ChampionGeneratedData -> GeneratedContentLoader -> inventaire par championId -> Champion.championData.skinName -> deux écrans de sélection -> provider. Aucun suffixe de skin n’est construit par ces deux appelants.
- Le SWF natif AirGeneratedContent.swf déjà admis (63 377 octets, MD5 fd8778eedf8d83e22f34660ac37fc166) fournit 122 déclarations. Les clés numériques et noms correspondent au catalogue de comparaison 4.20.1 ; celui-ci ne remplace pas la référence binaire EUW/en_GB.
- 118 noms ont un chemin exact en_GB. Les noms natifs Leblanc et Velkoz correspondent à des fichiers écrits LeBlanc et VelKoz : résolution de casse effective non mesurée. Azir et Braum ont des candidats exacts en_US, mais aucun chemin exact en_GB dans ce manifeste. Permission.mp3 reste un membre supplémentaire, sans affectation inventée.
- AudioAsset prévoit un repli par existence physique, puis une reprise IOError distincte ; le provider active cette seconde possibilité. Un manifeste ne prouve ni installation physique ni lecture réussie.
- La boutique expose playChooseMe via le pont JavaScript. Le modèle natif child.html contient trois références, dont un bouton Bowmaster marqué Test Sandbox. Cela ne démontre pas un alias de champion ni le contenu de la boutique historique active.

## Contrôles et preuves
Sept scripts texte décompilés avec Java/JPEXS déjà installés ; aucun ActionScript exécuté ou émulé. Les versions des outils, octets du SWF, commandes, retours et journaux sont identifiés. Trente-cinq fenêtres et les preuves existantes du provider sont reliées à la matrice des 122 noms. La recherche HTML/JS est bornée aux cinq fichiers originaux admis.
La première commande a échoué sur une option CLI invalide et un journal inaccessible. La seconde utilise l’option valide et un APPDATA isolé dans les fichiers de travail. La préparation v1 a rejeté à tort tout appel HTML local avant examen ; v2 conserve les trois références du modèle. Sources et retours échoués restent conservés. Le producteur et le lecteur indépendant ont leurs reçus séparés ; accepted-delivery.json sélectionne uniquement une livraison vérifiée.

## Ouvert et conditions de reprise
- Casse : fournir un contrat historique de File.exists et l’installation exacte. Ne pas renommer automatiquement les fichiers.
- Boutique : fournir la page enfant historique active et son appelant réel. Le bouton de test ne la remplace pas.
- Permission : fournir un mapping ou appelant natif explicite. Les noms synthétiques Random et Bowmaster restent séparés des 122 champions réels.
- Sources : aucune admission MP3 nouvelle. Le catalogue reste à 124 chemins admis et 2 626 sans payload admis. Prochain lot limité aux deux fichiers en_US Azir et Braum, avec provenance et taille/MD5 natifs ; leur récupération ne prouvera pas le repli audio.
- Fonctionnement, voix de skins/en jeu, autres locales, transitions, animations et sorts restent distincts. La recherche actuelle frontend/Tauri est réutilisée à identité inchangée ; aucune absence de tout le moteur n’en est déduite.

## Périmètre des écritures
Ajouts seulement dans F:\OpenLeague-work\audit-units\AUD-18.1-05-EN-GB-CHAMPION-VOICE-ROUTING-01 et ce rapport. Aucun goal, critère, registre, produit, Plan ou base modifié ; aucune installation, migration, relance, suppression ou modification du volume. Les pièces E sont des sources de travail conservées.
Toutes les preuves détaillées, reprises et identités se trouvent dans champion-voice-routing-proof.json et champion_voice_routing_qualifications.json.
