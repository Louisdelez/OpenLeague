# Garen Q : classe communautaire, requêtes et rôles natifs — V65

Cette étude affine SYS-01.2-05 et ses sources, sans adopter une mécanique communautaire ni qualifier un champion complet. La référence demeure PUBLIC4.20.0.315, EUW/en_GB ; le catalogue4.20.1 et les politiques locales restent distincts.

La classe GarenQ entière, son interface, les métadonnées et sept enums sont copiés octet pour octet depuis l’instantané communautaire. Celui-ci est modifié et le fichier Q.cs est versionné par son SHA, sans attribution inventée au commit parent. Dix fichiers exacts sont compilés dans un projet isolé .NET8.0.25 avec sources NuGet vides. Les objets, informations de cast et APIs sont fournis par un hôte explicite. Le chargeur réel, le dispatcher, le serveur et les véritables dégâts/buffs/particules ne sont pas exécutés.

Les17 profils déjà terminés observent six premières cibles invalides, cinq rangs sur un ennemi fourni, deux ordres de cibles, les métadonnées/OnActivate vide, deux refus d’API non qualifiée et le retour null de Silence. La classe lit la première cible, demande les effets seulement pour un ennemi vivant et continue après un retour null de Silence. Avec50AD fourni, ses demandes de dégâts sont100/125/150/175/200 ; ses durées demandées restent1.5s de Silence et4s de hâte. Les refus interrompent la méthode sans exécuter les appels suivants. Aucun effet réellement appliqué n’est déduit de ces requêtes.

Les cinq INIBIN et quatre Lua inspectés sont conformes aux manifestes sélectionnés. Data.Spell1 du personnage référence GarenQ. DynamicTooltip de GarenQ et QAttack référence directement game_spell_tooltip_GarenQ. GarenQBuff.inibin contient game_buff_tooltip_GarenQBuff sous le hash2287725201 : cette clé diffère du template game_spell_tooltip_GarenQBuff discuté auparavant. Ce résultat qualifie des liaisons de fichiers ; il ne prouve ni le rendu natif ni l’absence globale d’un usage du template alternatif. Les quatre chunks Lua n’ont aucun prototype de callback ; cela ne prouve aucune absence de serveur original ailleurs.

Les anciennes différences de durées classées dans fidelity_community_semantics_4_20.json restent conservées octet pour octet. Les valeurs importées et les sites Rust déjà liés sont relus, sans nouvelle exécution de gameplay. Les cinq ancres du chargeur/API communautaire sont inspectées comme sources ; elles ne deviennent pas un dispatcher historique qualifié.

Le lecteur maintenu tools/project-plan/audit_garen_component_reference.py vérifie270 assertions,60 identités de sources, les décodages INIBIN/Lua, les appartenances et les17 profils enregistrés. Sa qualification passe28 contrôles, dont27 refus de mutations ou d’affirmations excessives. Le lecteur installé est exécuté avec succès. Aucun profil C#, export ou ancien test n’est rejoué pour reformater la preuve.

Commande de relecture : python -B tools/project-plan/audit_garen_component_reference.py --evidence-root E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision65

L’échec préparatoire MissileType.cs est conservé ; IMissileType.cs est le fichier réel. Les sept premières copies exactes sont préservées. Cet échec précède toute compilation ou observation de composant. Les rapports initiaux en attente restent des preuves historiques ; le nouveau reçu indique leur intégration limitée au référentiel.

L’inconnue nominative du script est affinée, pas fermée. Restent à qualifier le serveur original, le dispatch et les paramètres réels du cast/attaque renforcée, les effets de buffs, le calendrier, la ténacité, les piles et les interactions. Aucun Rust/C de production, asset ou binaire du jeu n’est modifié. Cases, notes, révisions et historique utilisateur sont conservés. Les deux plafonds4312/4313 et les six objectifs du Goal restent ouverts selon leurs preuves propres.

Reçu : docs/reference_garen_component_sources/garen-component-reference.json. Livraison : docs/fidelity_registry_garen_component_revision_4_20.json. Sources, compilateur, assembly, journaux et profils : E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision65.
